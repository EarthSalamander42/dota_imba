local PlayerResource = CDOTA_PlayerResource
PlayerResource.PlayerData = {}
--[[
local support_items = {
	"item_smoke_of_deceit",
	"item_ward_observer",
	"item_ward_sentry",
	"item_imba_dust_of_appearance",
	"item_gem",
	"item_imba_soul_of_truth",
}
--]]
-- i know i can avoid using a loop, but it doesn't seem to be working so fuck it
local function IsSupportItem(bItemName)
	if bItemName == "item_smoke_of_deceit" or bItemName == "item_ward_observer" or bItemName == "item_ward_sentry" or bItemName == "item_imba_dust_of_appearance" or bItemName == "item_gem" or bItemName == "item_imba_soul_of_truth" then
		return true
	end

	return false
end

-- Initializes a player's data
ListenToGameEvent('npc_spawned', function(event)
	local npc = EntIndexToHScript(event.entindex)

	if npc.GetPlayerID and npc:GetPlayerID() >= 0 and not PlayerResource.PlayerData[npc:GetPlayerID()] then
		PlayerResource.PlayerData[npc:GetPlayerID()] = {}
		PlayerResource.PlayerData[npc:GetPlayerID()]["current_deathstreak"] = 0
		PlayerResource.PlayerData[npc:GetPlayerID()]["has_abandoned_due_to_long_disconnect"] = false
--		PlayerResource.PlayerData[npc:GetPlayerID()]["distribute_gold_to_allies"] = false -- not used atm
--		PlayerResource.PlayerData[npc:GetPlayerID()]["has_repicked"] = false -- not used atm
		PlayerResource.PlayerData[npc:GetPlayerID()]["items_bought"] = {}
		PlayerResource.PlayerData[npc:GetPlayerID()]["abilities_level_up_order"] = {}
--		print("player data set up for player with ID "..npc:GetPlayerID())
	end
end, nil)

function PlayerResource:StoreAbilitiesLevelUpOrder(player_id, ability_name)
	if self:IsImbaPlayer(player_id) then
		local i = #self.PlayerData[player_id]["abilities_level_up_order"] + 1

		-- shitty but doing the job
		if i == 17 or i == 19 then
			table.insert(self.PlayerData[player_id]["abilities_level_up_order"], "generic_hidden")
		elseif i == 21 then
			for i = 1, 4 do
				table.insert(self.PlayerData[player_id]["abilities_level_up_order"], "generic_hidden")
			end
		end

		table.insert(self.PlayerData[player_id]["abilities_level_up_order"], ability_name)
	end

--	print("Abilities stored:", self.PlayerData[player_id]["abilities_level_up_order"])
end

function PlayerResource:GetAbilitiesLevelUpOrder(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["abilities_level_up_order"]
	end

	return {}
end

-- todo: handle sell item shouldn't be stored
function PlayerResource:StoreItemBought(player_id, item_name)
	if self:IsImbaPlayer(player_id) then
		local item_info = {}
		item_info.game_time = GameRules:GetDOTATime(false, false)
		item_info.item_name = item_name

		table.insert(self.PlayerData[player_id]["items_bought"], item_info)
	end
end

function PlayerResource:GetItemsBought(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["items_bought"]
	end

	return {}
end

function PlayerResource:GetSupportItemsBought(player_id, items)
	local support_items_table = {}

	if self:IsImbaPlayer(player_id) then
		for i = 1, #items do
			local item_name = items[i].item_name

			if IsSupportItem(item_name) then
				local is_in_table = false

				for k, v in pairs(support_items_table) do
--					print(item_name, v.item_name, v.item_count)
					if item_name == v.item_name then
						v.item_count = v.item_count + 1
						is_in_table = true
						break
					end
				end

				if is_in_table == false then
					local item_info = {}
					item_info.item_count = 1
					item_info.item_name = item_name

					table.insert(support_items_table, item_info)
				end
			end
		end
	end

--	print(support_items_table)

	return support_items_table
end

function PlayerResource:IsImbaPlayer(player_id)
	if self.PlayerData[player_id] then
		return true
	else
		return false
	end
end

-- Set a player's abandonment due to long disconnect status
function PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, state)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = state
--		print("Set player "..player_id.." 's abandon due to long disconnect state as "..tostring(state))
	end
end

-- Fetch a player's abandonment due to long disconnect status
function PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"]
	else
		return false
	end
end

-- While active, redistributes a player's gold to its allies
function PlayerResource:StartAbandonGoldRedistribution(player_id)

	-- Set redistribution as active
	if self.PlayerData[player_id] == nil then
		print(self.PlayerData, player_id)
		return
	end

	self.PlayerData[player_id]["distribute_gold_to_allies"] = true -- TODO: nil sometimes
	print("player "..player_id.." is now redistributing gold to its allies.")

	-- Fetch this player's team
	local player_team = self:GetTeam(player_id)
	local current_gold = self:GetGold(player_id)
	local current_allies = {}
	local ally_amount = 0
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
	local gold_per_interval = 3 * (custom_gold_bonus / 100 ) / GOLD_TICK_TIME[GetMapName()]

	if self.GetPlayerCount then 
		-- Distribute initial gold
		for id = 0, self:GetPlayerCount() -1 do
			if self:IsImbaPlayer(id) and (not self.PlayerData[id]["distribute_gold_to_allies"]) and self:GetTeam(id) == player_team then
				current_allies[#current_allies + 1] = id
			end
		end
	end

	-- If there is at least one ally to redirect gold to, do it
	ally_amount = #current_allies
	if ally_amount >= 1 and current_gold >= ally_amount then
		local gold_to_share = current_gold - (current_gold % ally_amount)
		local gold_per_ally = gold_to_share / ally_amount
		for _,ally_id in pairs(current_allies) do
			self:ModifyGold(ally_id, gold_per_ally, false, DOTA_ModifyGold_AbandonedRedistribute)
		end
		print("distributed "..gold_to_share.." gold initially ("..gold_per_ally.." per ally)")
	end

	-- Update the variables to start the cycle
	current_gold = current_gold % ally_amount
	ally_amount = 0
	current_allies = {}

	-- Start the redistribution cycle
	Timers:CreateTimer(3, function()

		-- Update gold according to passive gold gain
		current_gold = current_gold + gold_per_interval

		-- Update active ally amount
		if self.GetPlayerCount then 
			for id = 0, self:GetPlayerCount() -1 do
				if self:IsImbaPlayer(id) and (not self.PlayerData[id]["distribute_gold_to_allies"]) and self:GetTeam(id) == player_team then
					current_allies[#current_allies + 1] = id
				end
			end
		end

		-- If there is at least one ally to redirect gold to, do it
		ally_amount = #current_allies
		if ally_amount >= 1 and current_gold >= ally_amount then
			local gold_to_share = current_gold - (current_gold % ally_amount)
			local gold_per_ally = gold_to_share / ally_amount
			for _,ally_id in pairs(current_allies) do
				self:ModifyGold(ally_id, gold_per_ally, false, DOTA_ModifyGold_AbandonedRedistribute)
			end
			print("distributed "..gold_to_share.." gold ("..gold_per_ally.." per ally)")
		end

		-- Update variables
		current_gold = current_gold % ally_amount
		current_allies = {}
		ally_amount = 0

		-- Keep going, if applicable
		if self.PlayerData[player_id]["distribute_gold_to_allies"] then
			return 3
		end
	end)
end

-- Stops a specific player from redistributing their gold to its allies
function PlayerResource:StopAbandonGoldRedistribution(player_id)
	self.PlayerData[player_id]["distribute_gold_to_allies"] = false
	self:ModifyGold(player_id, -self:GetGold(player_id), false, DOTA_ModifyGold_AbandonedRedistribute)
--	print("player "..player_id.." is no longer redistributing gold to its allies.")
end

-- Increase a player's current deathstreak count
function PlayerResource:IncrementDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["current_deathstreak"] = self.PlayerData[player_id]["current_deathstreak"] + 1
--		print("Current deathstreak for player "..player_id..": "..self.PlayerData[player_id]["current_deathstreak"])
	end
end

-- Reset a player's current deathstreak count
function PlayerResource:ResetDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["current_deathstreak"] = 0
--		print("Current deathstreak for player "..player_id.." reset to zero.")
	end
end

-- Fetch a player's current deathstreak count
function PlayerResource:GetDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["current_deathstreak"]
	end
	return nil
end

function PlayerResource:GetAllTeamPlayerIDs()
--	local player_id_table = {}

--	for i = 0, self:GetPlayerCount() -1 do
--		table.insert(player_id_table, i)
--	end

--	return player_id_table

	return filter(partial(self.IsValidPlayerID, self), range(0, self:GetPlayerCount()))
end
