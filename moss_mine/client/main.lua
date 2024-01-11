local Zones = {}
local Blips = {}
CurrentZone = nil

function MineRock(rock, isJackhammer)
    local rockMined = false
    local fails = 0
    local ent = NetworkGetEntityFromNetworkId(rock)

    TaskLookAtEntity(cache.ped, ent, -1, 2048, 3)
    TaskTurnPedToFaceEntity(cache.ped, ent, -1)

    exports.scully_emotemenu:setLimitation(true)

    local emote, maxFails, minSleep, maxSleep = "axe4", 2, 2000, 5000

    if isJackhammer then
        emote = "drill"
        minSleep = 1000
        maxSleep = 3000
        maxFails = 3
    end
    
    exports.scully_emotemenu:playEmoteByCommand(emote)
    
    while not rockMined do
        if fails > maxFails then
            break
        end

        local sleep = math.random(minSleep, maxSleep)
        Wait(sleep)
        local success = lib.skillCheck({'easy'}, {'w', 'a', 's', 'd'})

        if success then
            rockMined = lib.callback.await("moss_mine:server:minerock", false, NetworkGetNetworkIdFromEntity(rock))
        else
            fails = fails + 1
        end
    end

    exports.scully_emotemenu:cancelEmote()
    exports.scully_emotemenu:setLimitation(false)
    ClearPedTasksImmediately(cache.ped)

    if fails > 5 then
        lib.notify({
            title = 'Failed',
            type = 'error'
        })

        return
    end

    lib.notify({
        title = 'Rock Mined',
        type = 'success'
    })

    exports.ox_target:removeEntity(rock, "mine")
end

function ExcavateRock(rock)
    local rockMined = false
    local fails = 0
    local ent = NetworkGetEntityFromNetworkId(rock)
    
    TaskLookAtEntity(cache.ped, ent, -1, 2048, 3)
    TaskTurnPedToFaceEntity(cache.ped, ent, -1)

    exports.scully_emotemenu:setLimitation(true)

    exports.scully_emotemenu:playEmoteByCommand("dig")

    while not rockMined do
        if fails > 2 then
            break
        end

        local sleep = math.random(1000, 2000)
        Wait(sleep)
        local success = lib.skillCheck({'easy'}, {'w', 'a', 's', 'd'})

        if success then
            rockMined = lib.callback.await("moss_mine:server:excavateRock", false, NetworkGetNetworkIdFromEntity(rock))
        else
            fails = fails + 1
        end
    end

    exports.scully_emotemenu:cancelEmote()
    exports.scully_emotemenu:setLimitation(false)
    ClearPedTasksImmediately(cache.ped)
    exports.ox_target:removeEntity(rock, "excavate")

    if fails > 5 then
        lib.notify({
            title = 'Failed',
            type = 'error'
        })

        exports.ox_target:addEntity(rock, {
            {
                name = 'excavate',
                icon = 'fas fa-pickaxe',
                label = 'Excavate Rock',
                items = "WEAPON_HAMMER",
                onSelect = function ()
                    CreateThread(function ()
                        ExcavateRock(rock)            
                    end)
                end
            }
        })

        return
    end

    exports.ox_target:addEntity(rock, {
        {
            name = 'mine',
            icon = 'fas fa-pickaxe',
            label = 'Mine Rock',
            items = "pickaxe",
            onSelect = function ()
                CreateThread(function ()
                    MineRock(rock, false)            
                end)
            end
        },
        {
            name = 'mine',
            icon = 'fas fa-pickaxe',
            label = 'Jackhammer Rock',
            items = "jackhammer",
            onSelect = function ()
                CreateThread(function ()
                    MineRock(rock, true)            
                end)
            end
        }
    })

    lib.notify({
        title = 'Rock Excavated',
        type = 'success'
    })
end

function RequestRock(isDebug)
    local pos = GetEntityCoords(PlayerPedId())

    local success, z = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z, true)

    local netId = lib.callback.await("moss_mine:server:spawnrock", false, vector3(pos.x, pos.y, z or pos.z), CurrentZone)
    
    Wait(100)

    local ent = NetworkGetEntityFromNetworkId(netId)
        
    if ent == 0 then
        lib.print.error("NO ENT FOR NET ID")
        return nil
    end

    if isDebug then
        exports.ox_target:addEntity(netId, {
            {
                name = 'excavate',
                icon = 'fas fa-pickaxe',
                label = 'Excavate Rock',
                items = "shovel",
                onSelect = function ()
                    CreateThread(function ()
                        ExcavateRock(netId)            
                    end)
                end
            }
        })
    end

    return netId
end

if Config.Debug then
    RegisterCommand("getTestRock", function ()
        RequestRock(true)
    end)
end

local function Setup()
    for k, v in pairs(Config.Zones) do
        local blip = AddBlipForCoord(v.zone.pos.x, v.zone.pos.y, v.zone.pos.z)
        SetBlipSprite(blip, v.icon.sprite)
        SetBlipDisplay(blip, v.icon.display)
        SetBlipScale(blip, v.icon.scale)
        SetBlipAsShortRange(blip, v.icon.shortRange)
        SetBlipColour(blip, v.icon.colour)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(v.name)
        EndTextCommandSetBlipName(blip)
        Blips[k.."_l_"] = blip

        local radiusBlip = AddBlipForRadius(v.zone.pos.x, v.zone.pos.y, v.zone.pos.z, v.zone.radius)
        SetBlipColour(radiusBlip, v.zone.color)
        SetBlipAlpha(radiusBlip, v.zone.alpha)

        Blips[k.."_r_"] = radiusBlip

        local mineZone = CircleZone:Create(v.zone.pos, v.zone.radius, {
            name=k,
            debugPoly=Config.Debug,
        })

        mineZone:onPlayerInOut(function(isPointInside, point)
            if isPointInside then
                CurrentZone = k
                return
            end
            
            CurrentZone = nil
        end)

        Zones[k] = mineZone
    end
end

local function Shutdown()
    for k, _ in pairs(Zones) do
        Zones[k]:destroy()
    end

    for _, blip in pairs(Blips) do
        RemoveBlip(blip)
    end

    Blips = {}
    Zones = {}
    CurrentZone = nil
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Setup()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    Shutdown()
end)


AddEventHandler('onResourceStart', function(resourceName)
    if cache.resource == resourceName then
        Setup()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if cache.resource == resourceName then
        Shutdown()
    end
end)