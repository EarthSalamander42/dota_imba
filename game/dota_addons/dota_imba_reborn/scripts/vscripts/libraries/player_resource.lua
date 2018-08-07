CDOTA_PlayerResource.PlayerData = {}

-- Initializes a player's data
function CDOTA_PlayerResource:InitPlayerData(player_id)
	self.PlayerData = {}
	self.PlayerData[player_id] = {}
	self.PlayerData[player_id]["current_deathstreak"] = 0
	self.PlayerData[player_id]["has_abandoned_due_to_long_disconnect"] = false
	self.PlayerData[player_id]["distribute_gold_to_allies"] = false
	self.PlayerData[player_id]["has_repicked"] = false
	log.debug("player data set up for player with ID "..player_id)
end

function CDOTA_PlayerResource:IsImbaPlayer(player_id)
	if self.PlayerData[player_id] then
		return true
	else
		return false
	end
end

function CDOTA_PlayerResource:GetAllTeamPlayerIDs()
--	local player_id_table = {}

--	for i = 0, self:GetPlayerCount() -1 do
--		table.insert(player_id_table, i)
--	end

--	return player_id_table

	return filter(partial(self.IsValidPlayerID, self), range(0, self:GetPlayerCount()))
end
