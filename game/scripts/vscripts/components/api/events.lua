ListenToGameEvent('game_rules_state_change', function()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		api:DetectParties()
		CustomNetTables:SetTableValue("game_options", "game_count", { value = 1 })

		api:RegisterGame(function(data)
			print("Register game...")
			for k, v in pairs(data.players) do
				local payload = {
					steamid = tostring(k),
				}

				api:Request("armory", function(data)
					if api.players[k] then
						api.players[k]["armory"] = data
					end
				end, nil, "POST", payload)
			end

			if CUSTOM_GAME_TYPE == "IMBA" then
				-- GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("anti_stacks_fucker"), function()
				-- TeamOrdering:OnPlayersLoaded()

				-- return nil
				-- end, 3.0)
			elseif CUSTOM_GAME_TYPE == "PLS" then
				api:GenerateGameModeLeaderboard()
			end

			print("ALL PLAYERS LOADED IN!")
			CustomGameEventManager:Send_ServerToAllClients("all_players_battlepass_loaded", {})
		end)

		CustomGameEventManager:Send_ServerToAllClients("all_players_loaded", {})
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		api:InitDonatorTableJS()

		if api.parties then
			CustomNetTables:SetTableValue("game_options", "parties", api.parties)
		end

		Timers:CreateTimer(function()
			api:CheatDetector()

			if GAME_IS_OVER then
				return nil
			end

			return 1.0
		end)
	end
end, nil)

function api:OnGameEnd()
	api:CompleteGame(function(data, payload)
		-- print(data)
		-- print(payload)

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

ListenToGameEvent('dota_item_purchased', function(event)
	-- itemcost, itemname, PlayerID, splitscreenplayer
	local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)

	if CUSTOM_GAME_TYPE == "IMBA" then
		PlayerResource:StoreItemBought(event.PlayerID, event.itemname)
	end

	--	if not PlayerResource.ItemTimer then PlayerResource.ItemTimer = {} end

	--	PlayerResource.ItemTimer = Timers:CreateTimer(10.0, CheckIfItemSold(event))
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("check_item_sold"), function()
		if hero and not hero:IsNull() and IsValidEntity(hero) and hero:HasItemInInventory(event.itemname) then
			PlayerResource:StoreItemBought(event.PlayerID, event.itemname)
		end
	end, 11.0)
end, nil)

-- creepy way to check if an item was sold and fully refund
function CheckIfItemSold(event)
	if PlayerResource:GetSelectedHeroEntity(event.PlayerID):HasItemInInventory(event.itemname) then
		PlayerResource:StoreItemBought(event.PlayerID, event.itemname)
	end
end

-- Call custom functions whenever SetGameWinner is being called anywhere
original_SetGameWinner = CDOTAGameRules.SetGameWinner
CDOTAGameRules.SetGameWinner = function(self, iTeamNumber)
	GAME_WINNER_TEAM = iTeamNumber
	api:OnGameEnd()

	return original_SetGameWinner(self, iTeamNumber)
end
