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

	for player_id = 0, PlayerResource:GetPlayerCount() -1 do
		local steamid = tostring(PlayerResource:GetSteamID(player_id))

		if api.players[steamid] then
--			print("Player XP:", api.players[steamid].xp_in_level, api.players[steamid].xp_next_level, api.players[steamid].xp_level)

			local color = PLAYER_COLORS[player_id]

			if api:IsDonator(player_id) ~= 10 then
				donator_color = DONATOR_COLOR[api:GetDonatorStatus(player_id)]
			end

			if donator_color == nil then
				donator_color = DONATOR_COLOR[0]
			end

			CustomNetTables:SetTableValue("battlepass_player", tostring(player_id),
			{
				XP = api.players[steamid].xp_in_level,
				MaxXP = api.players[steamid].xp_next_level,
				Lvl = api.players[steamid].xp_level,
				ply_color = rgbToHex(color),
				title = api.players[steamid].rank_title,
				title_color = rgbToHex(Battlepass:GetTitleColorXP(api.players[steamid].rank_title)),
				donator_level = api:GetDonatorStatus(player_id),
				donator_color = rgbToHex(donator_color),
				toggle_tag = api:GetPlayerTagEnabled(player_id),
				bp_rewards = api:GetPlayerBPRewardsEnabled(player_id),
				player_xp = api:GetPlayerXPEnabled(player_id),
				winrate = api:GetPlayerSeasonalWinrate(player_id),
				winrate_toggle = api:GetPlayerWinrateShown(player_id),
				XP_change = 0,
				ingame_tag = api:GetPlayerIngameTag(player_id),
--				mmr = api:GetPlayerMMR(player_id),
--				mmr_title = api:GetPlayerRankMMR(player_id),
			})
		end
	end
end

function Battlepass:UpdatePlayerTable(player_id, key, value)
	local ply_table = CustomNetTables:GetTableValue("battlepass_player", tostring(player_id))

	ply_table[key] = value

	CustomNetTables:SetTableValue("battlepass_player", tostring(player_id), ply_table)
end
