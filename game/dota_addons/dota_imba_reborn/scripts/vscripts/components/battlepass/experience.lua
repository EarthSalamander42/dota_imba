-- Experience System
CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})

local XP_level_table = {}
XP_level_table[0] = 0

-- xp needed increased by 500 every 25 levels
for i = 1, 500 do
	XP_level_table[i] = XP_level_table[i-1] + (500 * (math.floor(i / 25) + 1))
end

function GetXPLevelByXp(xp)
	if xp <= 0 or xp == nil then return 1 end

	for k, v in pairs(XP_level_table) do
		if v > xp then
			return k - 1
		end
	end

	return 500
end

function GetXpProgressToNextLevel(xp)
	if xp == nil then return XP_level_table[1] end

	local level = GetXPLevelByXp(xp)
	local next = level + 1
	local thisXp = XP_level_table[level]
	local nextXp = XP_level_table[next]
	if nextXp == nil then
		nextXp = 0
	end

	local xpRequiredForThisLevel = nextXp - thisXp
	local xpProgressInThisLevel = xp - thisXp

	local xp = {
		xp = xpProgressInThisLevel,
		max_xp = xpRequiredForThisLevel,
	}

	return xp
end

function GetTitleIXP(level)
	if level <= 19 then
		return "Rookie"
	elseif level <= 39 then
		return "Amateur"
	elseif level <= 59 then
		return "Captain"
	elseif level <= 79 then
		return "Warrior"
	elseif level <= 99 then
		return "Commander"
	elseif level <= 119 then
		return "General"
	elseif level <= 139 then
		return "Master"
	elseif level <= 159 then
		return "Epic"
	elseif level <= 179 then
		return "Legendary"
	elseif level <= 199 then
		return "Ancient"
	elseif level <= 299 then
		return "Amphibian "..level-200
	elseif level <= 399 then
		return "Icefrog "..level-300
	else
		return "Firetoad "..level-400
	end
end

function GetTitleColorIXP(title)
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

function GetPlayerInfoIXP() -- yet it has too much useless loops, format later. Need to be loaded in game setup
	if not api.players then
--		print("IMBA API not ready! Retry...")
		Timers:CreateTimer(1.0, function()
			GetPlayerInfoIXP()
		end)

		return
	end

--	print("IMBA API ready!")

	local current_xp_in_level = {}

	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		local global_xp = tonumber(api:GetPlayerXP(ID))
--		print("Player "..ID.." XP: "..global_xp)
		local level = GetXPLevelByXp(global_xp)
--		print("Battlepass for ID "..ID..": "..level)
		local previous_xp = XP_level_table[level - 1]
		local current_xp_in_level
		local max_xp

		for i = 1, #XP_level_table do
			if global_xp >= XP_level_table[i] then
				if global_xp >= XP_level_table[#XP_level_table] then -- if max level
					current_xp_in_level = XP_level_table[level] - previous_xp
					max_xp = XP_level_table[level] - previous_xp
				else
					level = i
					current_xp_in_level = 0
					current_xp_in_level = global_xp - XP_level_table[i]
					max_xp = XP_level_table[level + 1] - XP_level_table[level]
				end
			elseif global_xp == 0 or global_xp == nil then
				level = 1
				current_xp_in_level = 0
				max_xp = XP_level_table[1]
			end
		end

		local color = PLAYER_COLORS[ID]

		if api:IsDonator(ID) ~= 10 then
			donator_color = DONATOR_COLOR[api:GetDonatorStatus(ID)]
		end

		if donator_color == nil then
			donator_color = DONATOR_COLOR[0]
		end

		CustomNetTables:SetTableValue("player_table", tostring(ID),
		{
			XP = current_xp_in_level,
			MaxXP = max_xp,
			Lvl = level,
			ply_color = rgbToHex(color),
			title = GetTitleIXP(level),
			title_color = rgbToHex(GetTitleColorIXP(GetTitleIXP(level))),
--			IMR_5v5 = api.imba.get_player_info(PlayerResource:GetSteamID(ID)).imr5v5,
--			IMR_10v10 = api.imba.get_player_info(PlayerResource:GetSteamID(ID)).imr10v10,
--			IMR_5v5_calibrating = api.imba.get_player_info(PlayerResource:GetSteamID(ID)).imr5v5_calibrating,
--			IMR_10v10_calibrating = api.imba.get_player_info(PlayerResource:GetSteamID(ID)).imr10v10_calibrating,
			XP_change = 0,
			IMR_5v5_change = 0,
			donator_level = api:GetDonatorStatus(ID),
			donator_color = rgbToHex(donator_color),
		})
	end

	-- TODO: fixdishit
--	GetTopPlayersIXP()
--	GetTopPlayersIMR()
end

function GetTopPlayersIXP()
	if not api.imba.ready then return end

	for _, top_user in pairs(api.imba.get_rankings_xp()) do
		local global_xp = top_user.xp
		local level = GetXPLevelByXp(global_xp)
		local current_xp_in_level
		local max_xp

		for i = 1, #XP_level_table do
			if global_xp > XP_level_table[i] then
				if global_xp > XP_level_table[#XP_level_table] then -- if max level
					level = #XP_level_table
					current_xp_in_level = XP_level_table[level] - XP_level_table[level]
					max_xp = XP_level_table[level] - XP_level_table[level]
				else
					level = i +1
					current_xp_in_level = 0
					current_xp_in_level = global_xp - XP_level_table[i]
					max_xp = XP_level_table[level + 1] - XP_level_table[level]
				end
			end
		end

		CustomNetTables:SetTableValue("top_xp", tostring(top_user.rank),
		{
			SteamID64 = top_user.steamid,
			XP = current_xp_in_level,
			MaxXP = max_xp,
			Lvl = level,
			title = GetTitleIXP(level),
			title_color = rgbToHex(GetTitleColorIXP(level)),
			IMR_5v5 = top_user.imr5v5,
		})
	end
end

function GetTopPlayersIMR()
	if not api.imba.ready then return end

	for _, top_user in pairs(api.imba.get_rankings_imr5v5()) do
		local global_xp = top_user.xp
		local level = GetXPLevelByXp(global_xp)
		local current_xp_in_level
		local max_xp

		for i = 1, #XP_level_table do
			if global_xp > XP_level_table[i] then
				if global_xp > XP_level_table[#XP_level_table] then -- if max level
					level = #XP_level_table
					current_xp_in_level = XP_level_table[level] - XP_level_table[level]
					max_xp = XP_level_table[level] - XP_level_table[level]
				else
					level = i +1 -- transform level 0 into level 1
					current_xp_in_level = 0
					current_xp_in_level = global_xp - XP_level_table[i]
					max_xp = XP_level_table[level + 1] - XP_level_table[level]
				end
			end
		end

		CustomNetTables:SetTableValue("top_imr5v5", tostring(top_user.rank),
		{
			SteamID64 = top_user.steamid,
			XP = current_xp_in_level,
			MaxXP = max_xp,
			Lvl = level,
			title = GetTitleIXP(level),
			title_color = rgbToHex(GetTitleColorIXP(GetTitleIXP(level))),
			IMR_5v5 = top_user.imr5v5,
		})
	end
end
