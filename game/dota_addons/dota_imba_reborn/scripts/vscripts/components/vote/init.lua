if GameMode == nil then
	GameMode = class({})
end

CustomGameEventManager:RegisterListener( "setting_vote", Dynamic_Wrap(GameMode, "OnSettingVote"))

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- If no one voted, default to IMBA 10v10 gamemode
		GameRules:SetCustomGameDifficulty(1)

		if GameMode.VoteTable == nil then return end
		local votes = GameMode.VoteTable

		for category, pidVoteTable in pairs(votes) do
			-- Tally the votes into a new table
			local voteCounts = {}
			for pid, vote in pairs(pidVoteTable) do
				if not voteCounts[vote] then voteCounts[vote] = 0 end
				voteCounts[vote] = voteCounts[vote] + 1
			end

			-- Find the key that has the highest value (key=vote value, value=number of votes)
			local highest_vote = 0
			local highest_key = ""
			for k, v in pairs(voteCounts) do
				if v > highest_vote then
					highest_key = k
					highest_vote = v
				end
			end

			-- Check for a tie by counting how many values have the highest number of votes
			local tieTable = {}
			for k, v in pairs(voteCounts) do
				if v == highest_vote then
					table.insert(tieTable, k)
				end
			end

			-- Resolve a tie by selecting a random value from those with the highest votes
			if table.getn(tieTable) > 1 then
				--print("TIE!")
				highest_key = tieTable[math.random(table.getn(tieTable))]
			end

			-- Act on the winning vote
			if category == "gamemode" then
				GameRules:SetCustomGameDifficulty(highest_key)
			end

--			print(category .. ": " .. highest_key)
		end
	end
end, nil)

function GameMode:OnSettingVote(keys)
	local pid = keys.PlayerID

	if not GameMode.VoteTable then
		GameMode.VoteTable = {}
	end

	if not GameMode.VoteTable[keys.category] then
		GameMode.VoteTable[keys.category] = {}
	end

	GameMode.VoteTable[keys.category][pid] = keys.vote

	-- TODO: Finish votes show up
	CustomGameEventManager:Send_ServerToAllClients("send_votes", {category = keys.category, vote = keys.vote, table = GameMode.VoteTable, table2 = GameMode.VoteTable[keys.category]})
end
