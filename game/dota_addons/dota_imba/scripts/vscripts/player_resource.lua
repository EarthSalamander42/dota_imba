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

-- Set a player's first spawn setup as done
function PlayerResource:SetPlayerSpawnSetupDone(player_id)
	if self:IsImbaPlayer(player_id) then
		self.PlayerData[player_id]["first_spawn_setup_done"] = true
		print("Performed first spawn setup for player "..player_id)
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