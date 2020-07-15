ListenToGameEvent('game_rules_state_change', function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		api:DetectParties()
		CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})

		api:RegisterGame(function(data)
			for k, v in pairs(data.players) do
				local payload = {
					steamid = tostring(k),
				}

				api:Request("armory", function(data)
					if api.players[k] then
						api.players[k]["armory"] = data
					end
				end, nil, "POST", payload);
			end
		end)

		api:GetDisabledHeroes()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		api:InitDonatorTableJS()

		if api.parties then
			CustomNetTables:SetTableValue("game_options", "parties", api.parties)
		end

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
			print(data)
			print(payload)
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

ListenToGameEvent('dota_item_purchased', function(event)
	-- itemcost, itemname, PlayerID, splitscreenplayer

	if CUSTOM_GAME_TYPE == "IMBA" then
		PlayerResource:StoreItemBought(event.PlayerID, event.itemname)
	end

--	if not PlayerResource.ItemTimer then PlayerResource.ItemTimer = {} end

--	PlayerResource.ItemTimer = Timers:CreateTimer(10.0, CheckIfItemSold(event))
end, nil)

-- creepy way to check if an item was sold and fully refund
function CheckIfItemSold(event)
	if PlayerResource:GetSelectedHeroEntity(event.PlayerID):HasItemInInventory(event.itemname) then
		PlayerResource:StoreItemBought(event.PlayerID, event.itemname)
	end
end
