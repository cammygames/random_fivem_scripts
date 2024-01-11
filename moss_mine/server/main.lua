local ObjectsSpawned = {}

lib.callback.register("moss_mine:server:spawnrock", function (_, playerPos, zoneName)
    local rock = CreateObjectNoOffset(`cs_x_rubweec`, playerPos.x, playerPos.y, playerPos.z-0.8, true)
    FreezeEntityPosition(rock, true)
    local netId = NetworkGetNetworkIdFromEntity(rock)

    ObjectsSpawned[rock] = {
        hits = 0,
        type = Config.Zones[zoneName].type,
        isUse = false
    }

    return netId
end)

lib.callback.register("moss_mine:server:minerock", function (_, rockNetId)
    local rock = NetworkGetEntityFromNetworkId(rockNetId)

    local curPos = GetEntityCoords(rock)
    SetEntityCoords(rock, curPos.x, curPos.y, curPos.z-0.15)

    ObjectsSpawned[rock].hits = ObjectsSpawned[rock].hits + 1

    -- Give them a reward every hit?
    
    if ObjectsSpawned[rock].hits >= 5 then
        DeleteEntity(rock)
        ObjectsSpawned[rock] = nil
        return true
    end

    return false
end)

lib.callback.register("moss_mine:server:excavateRock", function (_, rockNetId)
    local rock = NetworkGetEntityFromNetworkId(rockNetId)
    
    local curPos = GetEntityCoords(rock)
    SetEntityCoords(rock, curPos.x, curPos.y, curPos.z+0.15)

    ObjectsSpawned[rock].hits = ObjectsSpawned[rock].hits + 1

    if ObjectsSpawned[rock].hits >= 5 then
        ObjectsSpawned[rock].hits = 0
        return true
    end

    return false
end)


local function Setup()
end

local function Shutdown()
    for k, v in pairs(ObjectsSpawned) do
        DeleteEntity(k)
    end

    ObjectsSpawned = {}
    StaticConfig = nil
end

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