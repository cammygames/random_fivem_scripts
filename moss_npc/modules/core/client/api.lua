---Checks if the npc is unlocked
---@param npc string
function IsNPCUnlocked(npc)
    return MyRep[npc].unlocked
end

exports("IsNPCUnlocked", IsNPCUnlocked)

---Gets the players current rep level with the npc
---@param npc string
function GetNPCRep(npc)
    return MyRep[npc].rep
end

exports("GetNPCRep", GetNPCRep)