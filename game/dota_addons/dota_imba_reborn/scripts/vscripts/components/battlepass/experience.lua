-- Experience System
CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})

function Battlepass:GetTitleColorXP(title)
	if title == "Rookie" then
		return {255, 255, 255}
	elseif title == "Amateur" then
		return {102, 204, 0}
	elseif title == "Captain" then
		return {76, 139, 202}
	elseif title == "Warrior" then
		return {0, 76, 153}
	elseif title == "Commander" then
		return {152, 95, 209}
	elseif title == "General" then
		return {70, 5, 135}
	elseif title == "Master" then
		return {250, 83, 83}
	elseif title == "Epic" then
		return {142, 12, 12}
	elseif title == "Legendary" then
		return {239, 188, 20}
	elseif title == "Ancient" then
		return {191, 149, 13}
	elseif title == "Amphibian" then
		return {0, 0, 102}
	elseif title == "Icefrog" then
		return {20, 86, 239}
	else -- it's Firetoaaaaaaaaaaad!
		return {199, 81, 2}
	end
end

function Battlepass:GetPlayerInfoXP() -- yet it has too much useless loops, format later. Need to be loaded in game setup
	if not api.players then
		-- print("API not ready! Retry...")
		Timers:CreateTimer(1.0, function()
			Battlepass:GetPlayerInfoXP()
		end)

		return
	end

	print("API ready!")

	local current_xp_in_level = {}

	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		local steamid = tostring(PlayerResource:GetSteamID(ID))

		if api.players[steamid] then
			print("Player XP:", api.players[steamid].xp_in_level, api.players[steamid].xp_next_level, api.players[steamid].xp_level)

			local color = PLAYER_COLORS[ID]

			if api:IsDonator(ID) ~= 10 then
				donator_color = DONATOR_COLOR[api:GetDonatorStatus(ID)]
			end

			if donator_color == nil then
				donator_color = DONATOR_COLOR[0]
			end

			CustomNetTables:SetTableValue("battlepass_player", tostring(ID),
			{
				XP = api.players[steamid].xp_in_level,
				MaxXP = api.players[steamid].xp_next_level,
				Lvl = api.players[steamid].xp_level,
				ply_color = rgbToHex(color),
				title = api.players[steamid].rank_title,
				title_color = rgbToHex(Battlepass:GetTitleColorXP(api.players[steamid].rank_title)),
				donator_level = api:GetDonatorStatus(ID),
				donator_color = rgbToHex(donator_color),
				in_game_tag = api:GetPlayerTagEnabled(ID),
				bp_rewards = api:GetPlayerBPRewardsEnabled(ID),
				player_xp = api:GetPlayerXPEnabled(ID),
				winrate = api:GetPlayerWinrate(ID),
				winrate_toggle = api:GetPlayerWinrateShown(ID),
				XP_change = 0,
				IMR_5v5_change = 0,
				mmr = api:GetPlayerMMR(ID),
				mmr_title = api:GetPlayerRankMMR(ID),
			})
		end
	end

	if not IsInToolsMode() and CUSTOM_GAME_TYPE == "IMBA" then
		TeamOrdering:OnPlayersLoaded()
	end

	print("ALL PLAYERS LOADED IN!")
	CustomGameEventManager:Send_ServerToAllClients("all_players_battlepass_loaded", {})
end
