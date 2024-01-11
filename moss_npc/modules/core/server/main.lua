PlayerRepCache = {}

NPC_DEFAULTS = {
    rep = 0,
    unlocked = false,
}

local UPSERT_REP = 'INSERT INTO player_rep (citizenid, data) VALUES (:citizenid, :data) ON DUPLICATE KEY UPDATE data = :data'

lib.callback.register('moss_npc:server:initLoadData', function(source)
    local Player = exports.qbx_core:GetPlayer(source)

    if Player == nil then
        lib.print.error("Unable to find player????")
        return {}
    end

    local dbRep = nil

    -- Only load from the db if they arent in the table, should handle some cases of client crash when the event to remove them hasnt been fired.
    if PlayerRepCache[Player.PlayerData.citizenid] == nil then
        local result = MySQL.query.await('SELECT data FROM player_rep WHERE citizenid = ?', {Player.PlayerData.citizenid})

        lib.print.debug(result)

        if result and #result == 1 and result[1].data then
            dbRep = json.decode(result[1].data)
        end
    end

    local all_npcs = GetAllNpcNames()
    
    PlayerRepCache[Player.PlayerData.citizenid] = dbRep or {}

    lib.print.info("Adding "..Player.PlayerData.citizenid.." to PlayerRepCache due to login")
    lib.print.debug(PlayerRepCache)

    -- Update the table with all available npc's 
    for _, v in pairs(all_npcs) do
        if PlayerRepCache[Player.PlayerData.citizenid][v] == nil then
            lib.print.debug("Player "..Player.PlayerData.citizenid.." is missing npc "..v.." setting default rep")
            PlayerRepCache[Player.PlayerData.citizenid][v] = Config.NPC[v].defaults or NPC_DEFAULTS
        end
    end

    -- Add this player to db as they arent in the db already
    if dbRep == nil then
        MySQL.insert(UPSERT_REP, {
            citizenid = Player.PlayerData.citizenid,
            data = json.encode(PlayerRepCache[Player.PlayerData.citizenid])
        })
    end

    local cfg = GetConfig()
    return {rep = PlayerRepCache[Player.PlayerData.citizenid], cfg = cfg}
end)

local function RemoveFromCache(citizenid)
    local data = PlayerRepCache[citizenid]
    PlayerRepCache[citizenid] = nil
    return data
end

RegisterNetEvent("moss_npc:server:logOutSync", function ()
    local src = source
	local Player = exports.qbx_core:GetPlayer(src)

    lib.print.info("Removing "..Player.PlayerData.citizenid.." from PlayerRepCache due to logout")

    MySQL.insert('INSERT INTO player_rep (citizenid, data) VALUES (:citizenid, :data) ON DUPLICATE KEY UPDATE data = :data', {
        citizenid = Player.PlayerData.citizenid,
        data = json.encode(RemoveFromCache(Player.PlayerData.citizenid))
    })
end)

local function SetupStashes() 
    for k, v in pairs(GetConfig()) do
        local stash = {
            id = 'npc_'..v.type.."_"..k,
            label = v.name,
            slots = 10,
            weight = 4000000,
            owner = false,
            coords = vector3(v.pos.x, v.pos.y, v.pos.z),
        }

        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.groups, stash.coords)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    -- Schedule Update the rep table
    lib.cron.new('*/5 * * * *', function()
        for k, v in pairs(PlayerRepCache) do
            if v ~= nil then
                MySQL.insert(UPSERT_REP, {
                    citizenid = k,
                    data = json.encode(v)
                })
                lib.print.info(k .. ' REP SAVED!')
                lib.logger(-1, "moss_npc:server:rep_save", k.." rep saved. Data: "..json.encode(v))
            end
        end
    end)

    -- Pre gen the config to allow for it to support a table for pos which it will pick from at random.
    GetConfig()
    --Register Stashes
    SetupStashes()
end)