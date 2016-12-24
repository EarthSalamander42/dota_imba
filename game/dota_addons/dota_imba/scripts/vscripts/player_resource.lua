--[[	Author: Firetoad
		Original code: lolle
		Date: 17.12.2016
		Extends PlayerResource to include player-based data.	]]

local PlayerResource = CDOTA_PlayerResource
PlayerResource.PlayerData = {}

-- Initializes a player's data
function PlayerResource:InitPlayerData(player_id)
	self.PlayerData[player_id] = {}
	self.PlayerData[player_id]["first_spawn_setup_done"] = false
	self.PlayerData[player_id]["current_deathstreak"] = 0
	self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = false
	self.PlayerData[player_id]["distribute_gold_to_allies"] = false
	print("player data set up for player with ID "..player_id)
end

-- Verifies if this player ID already has player data assigned to it
function PlayerResource:IsImbaPlayer(player_id)
	if self.PlayerData[player_id] then
		return true
	else
		return false
	end
end

-- Assigns a hero to a player
function PlayerResource:SetPickedHero(player_id, hero_entity)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id].hero = hero_entity
		self.PlayerData[player_id].hero_name = hero_entity:GetUnitName()
		print("assigned "..self.PlayerData[player_id].hero_name.." to player with ID "..player_id)
	end
end

-- Fetches a player's hero
function PlayerResource:GetPickedHero(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id].hero
	end
	return nil
end

-- Fetches a player's hero name
function PlayerResource:GetPickedHeroName(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id].hero_name
	end
	return nil
end

-- Set a player's first spawn setup as done
function PlayerResource:SetPlayerSpawnSetupDone(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["first_spawn_setup_done"] = true
		print("Performed first spawn setup for player "..player_id)

		-- Add one to the team's player count
		self:IncrementTeamPlayerCount(player_id)
	end
end

-- Fetch if a player's first spawn setup was already done
function PlayerResource:IsPlayerSpawnSetupDone(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["first_spawn_setup_done"]
	else
		return false
	end
end

-- Set a player's abandonment due to long disconnect status
function PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, state)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = state
		print("Set player "..player_id.." 's abandon due to long disconnect state as "..tostring(state))
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

-- Increase a player's team's player count
function PlayerResource:IncrementTeamPlayerCount(player_id)
	if self:IsImbaPlayer(player_id) then
		if self:GetTeam(player_id) == DOTA_TEAM_GOODGUYS then
			REMAINING_GOODGUYS = REMAINING_GOODGUYS + 1
			print("Radiant now has "..REMAINING_GOODGUYS.." players remaining")
		else
			REMAINING_BADGUYS = REMAINING_BADGUYS + 1
			print("Dire now has "..REMAINING_BADGUYS.." players remaining")
		end
	end
end

-- Decrease a player's team's player count
function PlayerResource:DecrementTeamPlayerCount(player_id)
	if self:IsImbaPlayer(player_id) then
		if self:GetTeam(player_id) == DOTA_TEAM_GOODGUYS then
			REMAINING_GOODGUYS = REMAINING_GOODGUYS - 1
			print("Radiant now has "..REMAINING_GOODGUYS.." players remaining")
		else
			REMAINING_BADGUYS = REMAINING_BADGUYS - 1
			print("Dire now has "..REMAINING_BADGUYS.." players remaining")
		end
	end
end

-- Increase a player's current deathstreak count
function PlayerResource:IncrementDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["current_deathstreak"] = self.PlayerData[player_id]["current_deathstreak"] + 1
		print("Current deathstreak for player "..player_id..": "..self.PlayerData[player_id]["current_deathstreak"])
	end
end

-- Reset a player's current deathstreak count
function PlayerResource:ResetDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["current_deathstreak"] = 0
		print("Current deathstreak for player "..player_id.." reset to zero.")
	end
end

-- Fetch a player's current deathstreak count
function PlayerResource:GetDeathstreak(player_id)
	if self:IsImbaPlayer(player_id) then
		return self.PlayerData[player_id]["current_deathstreak"]
	end
	return nil
end

-- While active, redistributes a player's gold to its allies
function PlayerResource:StartAbandonGoldRedistribution(player_id)

	-- Set redistribution as active
	self.PlayerData[player_id]["distribute_gold_to_allies"] = true
	print("player "..player_id.." is now redistributing gold to its allies.")

	-- Fetch this player's team
	local player_team = self:GetTeam(player_id)
	local current_gold = self:GetGold(player_id)
	local current_allies = {}
	local ally_amount = 0

	-- Start gold redistribution loop
	Timers:CreateTimer(0, function()

		-- Update active ally amount
		for id = 0, 19 do
			if self:IsImbaPlayer(id) and (not self.PlayerData[id]["distribute_gold_to_allies"]) and self:GetTeam(id) == player_team then
				current_allies[#current_allies + 1] = id
			end
		end

		-- If there is at least one ally to redirect gold to, do it
		ally_amount = #current_allies
		if ally_amount >= 1 and current_gold >= ally_amount then
			local gold_to_share = current_gold - (current_gold % ally_amount)
			local gold_per_ally = gold_to_share / ally_amount
			self:ModifyGold(player_id, -gold_to_share, false, DOTA_ModifyGold_AbandonedRedistribute)
			for _,ally_id in pairs(current_allies) do
				self:ModifyGold(ally_id, gold_per_ally, false, DOTA_ModifyGold_AbandonedRedistribute)
			end
		end

		-- Update variables
		current_gold = self:GetGold(player_id)
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
	print("player "..player_id.." is no longer redistributing gold to its allies.")
end