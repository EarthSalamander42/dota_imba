ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})
		api:IterateWinrateOrdering()
		api:RegisterGame()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		api:InitDonatorTableJS()
		Timers:CreateTimer(function()
			api:CheatDetector()

			if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
				return nil
			end

			return 1.0
		end)

		api:ExperienceLeaderboard(function(data)
			print("Statistics XP")
			print(data)
			CustomNetTables:SetTableValue("game_options", "leaderboard_experience", {data = data})
		end)

		api:WinrateLeaderboard(function(data)
			print("Statistics Winrate")
			print(data)
			CustomNetTables:SetTableValue("game_options", "leaderboard_winrate", {data = data})
		end)

		api:DiretideHallOfFame(function(data)
			print("Statistics Diretide")
			print(data)
			CustomNetTables:SetTableValue("game_options", "leaderboard_diretide", {data = data})
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		api:CompleteGame(function(data, payload)
			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = payload.players,
				data = data,
				info = {
					winner = GAME_WINNER_TEAM,
					id = api:GetApiGameId(),
					radiant_score = GetTeamHeroKills(2),
					dire_score = GetTeamHeroKills(3),
					gamemode = GameMode:GetCustomGamemode(),
				},
			})
		end)
	end
end, nil)
