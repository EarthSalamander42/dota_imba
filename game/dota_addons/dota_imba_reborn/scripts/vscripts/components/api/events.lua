ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})
		api:RegisterGame()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		api:InitDonatorTableJS()

		if CUSTOM_GAME_TYPE == "IMBA" then
			if api:GetCustomGamemode() == 4 then
				api:DiretideHallOfFame(
					function(data)
						CustomNetTables:SetTableValue("battlepass", "leaderboard_diretide", {data = data})
					end,

					function(data)
						print("FAIL:", data)
					end
				)
			end
		end

		Timers:CreateTimer(function()
			api:CheatDetector()

			if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
				return nil
			end

			return 1.0
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		if CUSTOM_GAME_TYPE == "IMBA" then
			if api:GetCustomGamemode() == 4 then
				CustomGameEventManager:Send_ServerToAllClients("diretide_hall_of_fame", {})
			end
		end

		api:CompleteGame(function(data, payload)
			CustomGameEventManager:Send_ServerToAllClients("end_game", {
				players = payload.players,
				data = data,
				info = {
					winner = GAME_WINNER_TEAM,
					id = api:GetApiGameId(),
					radiant_score = GetTeamHeroKills(2),
					dire_score = GetTeamHeroKills(3),
					gamemode = api:GetCustomGamemode(),
				},
			})
		end)
	end
end, nil)
