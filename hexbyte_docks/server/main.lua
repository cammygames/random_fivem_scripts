local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("hexbyte:docks:server:payDeposit", function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player.Functions.RemoveMoney("bank", Config.ContainerHandlerRentalFee, "Rental Deposit") then
        ServerDisplayNotification(src, Lang:t("error.not_enough", {value = Config.ContainerHandlerRentalFee}), "error")
    end
end)

RegisterNetEvent("hexbyte:docks:server:RequestPaycheck", function (bonus)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney("bank", bonus + Config.ContainerHandlerRentalFee, 'Job Bonus + Rental Return')

    ServerDisplayNotification(src, Lang:t("success.pay_slip", {total = bonus, deposit = bonus + Config.ContainerHandlerRentalFee}), "success")
end)
