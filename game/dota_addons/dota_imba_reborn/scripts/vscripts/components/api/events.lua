ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		api:RegisterGame()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		api:InitDonatorTableJS()
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
				},
			})
		end)
	end
end, nil)
