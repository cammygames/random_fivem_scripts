function GetRepForCID(cid, npc)
    return PlayerRepCache[cid][npc].rep
end

function SetRepForCID(cid, npc, input)
    PlayerRepCache[cid][npc].rep = input

    return PlayerRepCache[cid][npc].rep
end

function GetUnlockStateForCID(cid, npc)
    return PlayerRepCache[cid][npc].unlocked or false
end


---Adds the input amount to the rep with the npc for the src player
---@param src number
---@param npc string
---@param input number
function UpdateNPCRep(src, npc, input)
    local Player = exports.qbx_core:GetPlayer(src)

    local new_total = GetRepForCID(Player.PlayerData.citizenid, npc) + input
    SetRepForCID(Player.PlayerData.citizenid, npc, new_total)

    if GetRepForCID(Player.PlayerData.citizenid, npc) < 0 then
        SetRepForCID(Player.PlayerData.citizenid, npc, 0)
    end

    if GetRepForCID(Player.PlayerData.citizenid, npc) > Config.MaxRep then
        SetRepForCID(Player.PlayerData.citizenid, npc, Config.MaxRep)
    end

    lib.logger(src, "moss_npc:server:updateNPCRep", Player.PlayerData.citizenid.." rep for npc ".. npc .." has been updated to "..GetRepForCID(Player.PlayerData.citizenid, npc))
    lib.print.debug("Rep for npc "..npc.." has been updated to "..GetRepForCID(Player.PlayerData.citizenid, npc))

    TriggerClientEvent("moss_npc:client:sync_rep", src, PlayerRepCache[Player.PlayerData.citizenid])
    
    return PlayerRepCache[Player.PlayerData.citizenid]
end

exports("UpdateNPCRep", UpdateNPCRep)

---Sets the rep with the npc for the src player
---@param src number
---@param npc string
---@param input number
function SetNPCRep(src, npc, input)
    local Player = exports.qbx_core:GetPlayer(src)

    SetRepForCID(Player.PlayerData.citizenid, npc, input)

    if GetRepForCID(Player.PlayerData.citizenid, npc) < 0 then
        SetRepForCID(Player.PlayerData.citizenid, npc, 0)
    end

    if GetRepForCID(Player.PlayerData.citizenid, npc) > Config.MaxRep then
        SetRepForCID(Player.PlayerData.citizenid, npc, Config.MaxRep)
    end

    lib.logger(src, "moss_npc:server:setNPCRep", Player.PlayerData.citizenid.." rep for npc ".. npc .." has been set to "..input)
    lib.print.debug("Rep for npc "..npc.." has been set to "..input)

    TriggerClientEvent("moss_npc:client:sync_rep", src, PlayerRepCache[Player.PlayerData.citizenid])

    return PlayerRepCache[Player.PlayerData.citizenid]
end

exports("SetNPCRep", SetNPCRep)

---Sets the npc to unlocked for the src player
---@param src number
---@param npc string
function UnlockNPC(src, npc)
    local Player = exports.qbx_core:GetPlayer(src)

    if PlayerRepCache[Player.PlayerData.citizenid][npc] == nil then
        PlayerRepCache[Player.PlayerData.citizenid][npc] = Config.NPC[npc].defaults or NPC_DEFAULTS
    end

    PlayerRepCache[Player.PlayerData.citizenid][npc].unlocked = true

    lib.logger(src, "moss_npc:server:unlockNPC", "NPC "..npc.." has been unlocked for "..Player.PlayerData.citizenid)
    lib.print.debug("NPC "..npc.." has been unlocked for "..Player.PlayerData.citizenid)

    TriggerClientEvent("moss_npc:client:sync_rep", src, PlayerRepCache[Player.PlayerData.citizenid])

    return PlayerRepCache[Player.PlayerData.citizenid]
end

exports("UnlockNPC", UnlockNPC)

---Gets the rep with the npc for the src player
---@param src number
---@param npc string
function GetNPCRepForPlayer(src, npc)
    local Player = exports.qbx_core:GetPlayer(src)

    return GetRepForCID(Player.PlayerData.citizenid, npc)
end

exports("GetNPCRepForPlayer", GetNPCRepForPlayer)

---Checks if the npc is unlocked for the player
---@param src number
---@param npc string
function IsNPCUnlockedForPlayer(src, npc)
    local Player = exports.qbx_core:GetPlayer(src)

    return GetUnlockStateForCID(Player.PlayerData.citizenid, npc)
end

exports("IsNPCUnlockedForPlayer", IsNPCUnlockedForPlayer)

---Runs a math.floor on 
---@param npc string
---@param citizenid string
function GetRepTeir(npc, citizenid)
    return math.floor(GetRepForCID(citizenid, npc))
end
exports("GetRepTeir", GetRepTeir)

function GetClosestRewardTeirAmount(npc, citizenid, reward_tbl)
    local target = GetRepTeir(npc, citizenid)
    local amount = 0
    
    for k, v in pairs(reward_tbl) do
        if target >= k then
            amount = v
        end
    end

    return amount
end

exports("GetClosestRewardTeirAmount", GetClosestRewardTeirAmount)