local function GiveReward(src, amt, item_count, npc_cfg_name, reward_item, inv)
	local Player = exports.qbx_core:GetPlayer(src)
	if type(amt) == "table" then
		amt = GetClosestRewardTeirAmount(npc_cfg_name, Player.PlayerData.citizenid, amt)
	end

	amt = amt * item_count

	if amt == 0 then
		return
	end

	if reward_item == "cash" then
		Player.Functions.AddMoney("cash", amt)
	else
		if Config.RewardsGivenToPlayer then
			Player.Functions.AddItem(reward_item, amt)
			TriggerClientEvent('inventory:client:ItemBox', src, exports.ox_inventory:Items()[reward_item], "add")
		else
			exports.ox_inventory:AddItem(inv, reward_item, amt)
		end
	end

	lib.logger(src, "moss_npc:server:fence:GiveReward", Player.PlayerData.citizenid.." was given "..amt.."x "..reward_item.." from npc "..npc_cfg_name)
end

local function RemoveItemAfterDelay(payload, trade_config, npc_name)
	CreateThread(function ()
		Wait(100)
		local Player = exports.qbx_core:GetPlayer(payload.source)
		lib.print.debug("Removing "..payload.count.."x "..payload.fromSlot.name.." from "..payload.toInventory.." slot "..payload.toSlot)
		local success, error = exports.ox_inventory:RemoveItem(payload.toInventory, payload.fromSlot.name, payload.count, nil, payload.toSlot)

		if not success then
			local msg = Player.PlayerData.citizenid.." attempted to trade "..payload.count.."x "..payload.fromSlot.name.." to "..payload.toInventory.." but item removal failed. Possible Exploit? Error: "..error
			lib.print.error(msg)
			lib.logger(payload.source, "moss_npc:server:fence:RemoveItemAfterDelay", msg)
			return
		end

		local rep_change = 0
		rep_change = rep_change + (trade_config.rep_reward * payload.count)
	
		if trade_config.mode == nil or trade_config.mode == "all" then
			for rk, rv in pairs(trade_config.rewards) do
				GiveReward(payload.source, rv, payload.count, npc_name, rk, payload.toInventory)
			end
		else
			local reward = GetRandomTableEntry(trade_config.rewards)
			GiveReward(payload.source, reward.v, payload.count, npc_name, reward.k, payload.toInventory)
		end
	
		if rep_change ~= 0 then
			UpdateNPCRep(payload.source, npc_name, rep_change)
		end

		lib.logger(payload.source, "moss_npc:server:fence:RemoveItemAfterDelay", Player.PlayerData.citizenid.." Successfully traded "..payload.count.."x "..payload.fromSlot.name.." to "..payload.toInventory)
	end)
end

local FenceHookID = exports.ox_inventory:registerHook("swapItems", function(payload)
	if payload.fromType ~= "player" then
		lib.print.debug("Ignore item move due to not from player inv")
		return true
	end
	lib.print.debug(payload)

	local npc_name = string.gsub(payload.toInventory, "^npc_fence_", "")
	lib.print.debug("Converting "..payload.toInventory.." to "..npc_name)
	local npc = Config.NPC[npc_name]

	if npc == nil then
		lib.print.debug(payload.toInventory.." is not a valid npc")
		return true
	end

	local Player = exports.qbx_core:GetPlayer(payload.source)
	
	local trade_config = npc.trade_cfg[payload.fromSlot.name]

	if trade_config == nil then
		return true -- This item isnt a valid trade.
	end

	if GetRepForCID(Player.PlayerData.citizenid, npc_name) < (trade_config.min_rep or 0) then
		return true -- the player doesnt have enough rep with this npc to trade this item...
	end

	RemoveItemAfterDelay(payload, trade_config, npc_name)

	return true
end, {
	inventoryFilter={
		'^npc_fence_[%w_]+'
	}
})