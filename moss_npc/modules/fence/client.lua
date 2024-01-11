RegisterNetEvent("moss_npc:client:fence:openMenu", function (data)
  local isNPCLocked = not IsNPCUnlocked(data.k)

  local options = {
    {
      title = 'Trade',
      icon = 'box-open',
      onSelect = function (_)
        exports.ox_inventory:openInventory("stash", "npc_fence_"..data.k)
      end,
      disabled = isNPCLocked
    }
  }

  SetupInteractionDialog('npc_fence_'..data.k, data, options)
end)

AddEventHandler("moss_npc:client:fence_ui:openInv", function (data)
  exports.ox_inventory:openInventory("stash", "npc_fence_"..data.k)
end)