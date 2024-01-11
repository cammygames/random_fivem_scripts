local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("hexbyte:tuning:saveTuning", function (plate, data)
    local src = source
    exports.oxmysql:update('UPDATE player_vehicles SET tune = :tune WHERE plate = :plate', {
        ['tune'] = json.encode(data),
        ['plate'] = plate
    })

    TriggerClientEvent('QBCore:Notify', src, 'Tune Applied', 'success')
end)

QBCore.Functions.CreateUseableItem("tuning_advanced_laptop", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Config.RequiredJob ~= nil then    
        if Player.PlayerData.job.name == Config.RequiredJob then
            TriggerClientEvent("hexbyte:tuing:client:openTuneMenu", src)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You dont seem to be able to turn it on', 'error')
        end
    else
        TriggerClientEvent("hexbyte:tuing:client:openTuneMenu", src)
    end
end) 

QBCore.Functions.CreateUseableItem("tuning_chip_written", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player.Functions.RemoveItem(item.name, 1, item.slot) then 
        TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items['tuning_chip_written'], 'remove')
        TriggerClientEvent("hexbyte:tuning:client:applyFromChip", source, item.info.tune)
    end
end)

RegisterNetEvent("hexbyte:tuning:server:saveToChip", function (data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem("tuning_chip_blank", 1) then
        TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items['tuning_chip_blank'], 'remove')

        Player.Functions.AddItem("tuning_chip_written", 1, nil, {
            tune = data.tune,
            name = data.name
        })
        TriggerClientEvent('inventory:client:ItemBox', src,  QBCore.Shared.Items['tuning_chip_written'], 'add')
        
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("hexbyte:tuning:server:GetVehicleTune", function(source, cb, plate)
    local src = source
    local tune = {}
    local result = MySQL.Sync.fetchAll('SELECT tune FROM player_vehicles WHERE plate = ?', {plate})
    
    if result[1] then
        tune = json.decode(result[1].tune)
    end

    cb(tune)
end)
