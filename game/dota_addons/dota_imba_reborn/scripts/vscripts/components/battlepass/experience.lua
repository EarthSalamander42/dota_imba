-- Experience System
CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})

local XP_level_table = {}
XP_level_table[0] = 0

-- xp needed increased by 500 xp every 25 levels
for i = 1, 1000 do
	XP_level_table[i] = XP_level_table[i-1] + (500 * (math.floor(i / 25) + 1))
end

function Battlepass:GetXPLevelByXp(xp)
	if xp <= 0 or xp == nil then return 1 end

	for k, v in pairs(XP_level_table) do
		if v > xp then
			return k
		end
	end

	return 1
end

function Battlepass:GetXpProgressToNextLevel(xp)
	if xp == nil then return XP_level_table[1] end

	local level = Battlepass:GetXPLevelByXp(xp)
	local next = level
	local thisXp = XP_level_table[level - 1]
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

function Battlepass:GetTitleXP(level)
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
		local global_xp = tonumber(api:GetPlayerXP(ID))
--		print("Player "..ID.." XP: "..global_xp)
		local level = Battlepass:GetXPLevelByXp(global_xp)
--		print("Battlepass level for ID "..ID..": "..level)
		local progress_to_next_level = Battlepass:GetXpProgressToNextLevel(global_xp)
		local current_xp_in_level = progress_to_next_level.xp
--		print("Battlepass xp in level for ID "..ID..": "..current_xp_in_level)
		local max_xp = progress_to_next_level.max_xp
--		print("Battlepass max xp for ID "..ID..": "..max_xp)

		local color = PLAYER_COLORS[ID]

		if api:IsDonator(ID) ~= 10 then
			donator_color = DONATOR_COLOR[api:GetDonatorStatus(ID)]
		end

		if donator_color == nil then
			donator_color = DONATOR_COLOR[0]
		end

		-- todo: rework this mess
		local arcana_heroes = {
			"axe",
			"earthshaker",
			"juggernaut",
			"lina",
			"nevermore",
			"pudge",
			"terrorblade",
			"wisp",
			"zuus",
		}

		-- check arcana icon replacement
		local arcana = {}
		if Battlepass then
			for k, v in pairs(arcana_heroes) do
				arcana["npc_dota_hero_"..v] = Battlepass:HasArcana(i, v)
			end
		end

		CustomNetTables:SetTableValue("battlepass", tostring(ID),
		{
			XP = current_xp_in_level,
			MaxXP = max_xp,
			Lvl = level,
			ply_color = rgbToHex(color),
			title = Battlepass:GetTitleXP(level),
			title_color = rgbToHex(Battlepass:GetTitleColorXP(Battlepass:GetTitleXP(level))),
			XP_change = 0,
			IMR_5v5_change = 0,
			donator_level = api:GetDonatorStatus(ID),
			donator_color = rgbToHex(donator_color),
			in_game_tag = api:GetPlayerTagEnabled(ID),
			bp_rewards = api:GetPlayerBPRewardsEnabled(ID),
			player_xp = api:GetPlayerXPEnabled(ID),
			winrate = api:GetPlayerWinrate(ID),
			winrate_toggle = api:GetPlayerWinrateShown(ID),
			arcana = arcana
		})

--		print(CustomNetTables:GetTableValue("battlepass", tostring(ID)))
	end
end
