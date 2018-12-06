local PlayerResource = CDOTA_PlayerResource
PlayerResource.PlayerData = {}

-- Initializes a player's data
function PlayerResource:InitPlayerData(player_id)
	self.PlayerData = {}
	self.PlayerData[player_id] = {}
	self.PlayerData[player_id]["current_deathstreak"] = 0
	self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = false
	self.PlayerData[player_id]["distribute_gold_to_allies"] = false
	self.PlayerData[player_id]["has_repicked"] = false
--	print("player data set up for player with ID "..player_id)
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
