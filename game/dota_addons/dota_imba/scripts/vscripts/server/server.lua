local statInfo = LoadKeyValues('scripts/vscripts/server/auth.kv')

local _AuthCode = statInfo._auth --The auth code for game and http server

local table_PlayerID = {}
local table_SteamID64 = {}
local table_player_key = {}
local table_able = {}
local table_XP_has = {}
local table_XP = {}

local SteamID64
local player_key
local XP_has

local EnnDisEnabled = 0

XP_WIN = 48
ABANDON_CHARGE = 200
-- imba_standard win = +96
-- imba_standard lose = +24
-- else win = +48
-- else lose = +12
-- abandon = -200 / disconnected_players

--Level table for IMBA XP
local table_rankXP = {0,100,200,300,400,500,700,900,1100,1300,1500,1800,2100,2400,2700,3000,3400,3800,4200,4600,5000}
--------------------  0  1   2   3   4   5   6   7    8    9   10   11   12   13   14   15   16   17   18   19   20

CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})

local bonus = 0
for i = 21 +1, 1000 do
	bonus = bonus +10
	table_rankXP[i] = table_rankXP[i-1] + 500 + bonus
end

local XP_level_title = {}
local XP_level = {}
local XP_level_title_player = {}
local XP_need_to_next_level = {}
local XP_this_level = {}
local XP_has_this_level = {}
--Level table for IMBA XP

--	"imba_rank_title_rookie"
--	"imba_rank_title_amateur"
--	"imba_rank_title_captain"
--	"imba_rank_title_warrior"
--	"imba_rank_title_commander"
--	"imba_rank_title_general"
--	"imba_rank_title_master"
--	"imba_rank_title_epic"
--	"imba_rank_title_legendary"
--	"imba_rank_title_icefrog"
--	"imba_rank_title_firetoad"

--	function Server_GetTitle(level)
--		if level <= 9 then
--			return "#imba_rank_title_rookie"
--		elseif level <= 19 then
--			return "#imba_rank_title_amateur"
--		elseif level <= 29 then
--			return "#imba_rank_title_captain"
--		elseif level <= 39 then
--			return "#imba_rank_title_warrior"
--		elseif level <= 49 then
--			return "#imba_rank_title_commander"
--		elseif level <= 59 then
--			return "#imba_rank_title_general"
--		elseif level <= 69 then
--			return "#imba_rank_title_master"
--		elseif level <= 79 then
--			return "#imba_rank_title_epic"
--		elseif level <= 89 then
--			return "#imba_rank_title_legendary"
--		elseif level <= 99 then
--			return "#imba_rank_title_icefrog"
--		else 
--			return "#imba_rank_title_firetoad "..level-100
--		end
--	end

function Server_GetTitleColor(title, js)
	if js == true then
		if title == "Rookie" then
			return "#FFFFFF"
		elseif title == "Amateur" then
			return "#66CC00"
		elseif title == "Captain" then
			return "#4C8BCA"
		elseif title == "Warrior" then
			return "#004C99"
		elseif title == "Commander" then
			return "#985FD1"
		elseif title == "General" then
			return "#460587"
		elseif title == "Master" then
			return "#FA5353"
		elseif title == "Epic" then
			return "#8E0C0C"
		elseif title == "Legendary" then
			return "#EFBC14"
		elseif title == "Icefrog" then
			return "#1456EF"
		else -- it's Firetoaaaaaaaaaaad! 
			return "#C75102"
		end
	else
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
		elseif title == "Icefrog" then
			return {20, 86, 239}
		else -- it's Firetoaaaaaaaaaaad! 
			return {199, 81, 2}
		end
	end
end

--	function Server_GetTitleColor(title)
--		if title == "#imba_rank_title_rookie" then
--			return {255, 255, 255}
--		elseif title == "#imba_rank_title_amateur" then
--			return {102, 204, 0}
--		elseif title == "#imba_rank_title_captain" then
--			return {76, 139, 202}
--		elseif title == "#imba_rank_title_warrior" then
--			return {0, 76, 153}
--		elseif title == "#imba_rank_title_commander" then
--			return {152, 95, 209}
--		elseif title == "#imba_rank_title_general" then
--			return {70, 5, 135}
--		elseif title == "#imba_rank_title_master" then
--			return {250, 83, 83}
--		elseif title == "#imba_rank_title_epic" then
--			return {142, 12, 12}
--		elseif title == "#imba_rank_title_legendary" then
--			return {239, 188, 20}
--		elseif title == "#imba_rank_title_icefrog" then
--			return {20, 86, 239}
--		else -- it's Firetoaaaaaaaaaaad! 
--			return {199, 81, 2}
--		end
--	end

function Server_DecodeForPlayer( t, nPlayerID )   --To deep-decode the Json code...
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			--print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
					elseif (type(val)=="string") then                   
						if pos == "SteamID64" then
							SteamID64 = val
							--print("SteamID64="..SteamID64)
						end
						if pos == "player_key" then
							player_key = val
							table_player_key[nPlayerID] = tostring(player_key)
							--print("player_key="..table_player_key[nPlayerID])
						end
						if pos == "XP_has" then
							XP_has = val
							if tonumber(XP_has) < 0 then
								table_XP_has[nPlayerID] = 0
							else
								table_XP_has[nPlayerID] = tostring(XP_has)
							end
							table_XP_has[nPlayerID] = tostring(XP_has)
							--print("XP_has="..table_XP_has[nPlayerID])
						end
						table_able[nPlayerID] = tostring(0)
					end
				end
			end
		end
	end
	if (type(t)=="table") then
		sub_print_r(t,"  ")
	end
end

function Server_PrintInfo()
	for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
		if  PlayerResource:IsValidPlayer(nPlayerID) then
		if PlayerResource:IsFakeClient(nPlayerID) then
		else
			print("=============================")
			print("PlayerID:"..nPlayerID)
			print("SteamID64:"..table_SteamID64[nPlayerID])
			print("Level:"..XP_level[nPlayerID])
			print("Rank_title:"..XP_level_title_player[nPlayerID])
			print("XP this level need:"..XP_this_level[nPlayerID])
			print("XP has in this level:"..XP_has_this_level[nPlayerID])
			print("XP need to level up:"..XP_need_to_next_level[nPlayerID])
			print("player_key:"..table_player_key[nPlayerID])
			print("If able to get XP:"..table_able[nPlayerID])
			print("XP has:"..table_XP_has[nPlayerID])
			print("XP to get this game:"..table_XP[nPlayerID])
			print("Team(2 is Radiant, 3 is Dire):"..PlayerResource:GetTeam(nPlayerID))
			print("=============================")
		end
		end
	end
end

function Server_GetPlayerLevelAndTitle(nPlayerID)
	for i = #table_rankXP, 1, -1 do
		if table_XP_has and table_XP_has[nPlayerID] and table_rankXP and table_rankXP[i] then
			if tonumber(table_XP_has[nPlayerID]) >= table_rankXP[i] then
				if tonumber(table_XP_has[nPlayerID]) < 0 then
					print("What did you do! Negative value!")
				end
				XP_level[nPlayerID] = i-1
				XP_level_title_player[nPlayerID] = Server_GetTitle(XP_level[nPlayerID])
				XP_this_level[nPlayerID] = table_rankXP[i]
				if i == #table_rankXP then
					XP_need_to_next_level[nPlayerID] = 0
				else
					XP_need_to_next_level[nPlayerID] = table_rankXP[i+1] - tonumber(table_XP_has[nPlayerID])
				end
				XP_has_this_level[nPlayerID] = tonumber(table_XP_has[nPlayerID]) - table_rankXP[i]
				CustomNetTables:SetTableValue("player_table", tostring(nPlayerID), {
					XP = tonumber(XP_has_this_level[nPlayerID]),
					MaxXP = tonumber(XP_need_to_next_level[nPlayerID] + XP_has_this_level[nPlayerID]),
					Lvl = tonumber(XP_level[nPlayerID]),
					ID = nPlayerID,
					title = XP_level_title_player[nPlayerID],
					title_color = Server_GetTitleColor(XP_level_title_player[nPlayerID], true)})
				break
			end
		end
	end
end

local _finished = 0
local is_AFK = {}

function Server_SendAndGetInfoForAll()
	if _finished == 0 then
		require('libraries/json')		

		for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
			Server_SendAndGetInfoForAll_function(nPlayerID)
		end
		_finished = 1
	end
end

function Server_SendAndGetInfoForAll_function(nPlayerID)
	if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsFakeClient(nPlayerID) then

		table_SteamID64[nPlayerID] = tostring(PlayerResource:GetSteamID(nPlayerID))
		table_XP[nPlayerID] = tostring(XP_WIN) --How many XP will player get in this game
		local jsondata={}
		local jsontable={}
		jsontable.SteamID64 = table_SteamID64[nPlayerID]
		jsontable.XP = table_XP[nPlayerID]
		table.insert(jsondata,jsontable)
			local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_to_tmp.php" )
			request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
			request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode)
			request:Send(function(result)
			if result.StatusCode == 200 then
				Adecode=JSON:decode(result.Body)
				Server_DecodeForPlayer(Adecode, nPlayerID)
				Server_GetPlayerLevelAndTitle(nPlayerID)
			end
			if result.StatusCode ~= 200 then
				Server_SendAndGetInfoForAll_function(nPlayerID)
				return
			end
		end )
		is_AFK[nPlayerID] = 0
	end
end

function Server_EnableToGainXPForPlyaer(nPlayerID)
	if EnnDisEnabled == 1 and is_AFK[nPlayerID] == 0 then
		table_able[nPlayerID] = 1
		Server_AbilityToGainXPForPlyaer_function(nPlayerID)
	end
end

function Server_DisableToGainXpForPlayer(nPlayerID)
	if EnnDisEnabled == 1 then
		table_able[nPlayerID] = 0
		Server_AbilityToGainXPForPlyaer_function(nPlayerID)
	end
end

function Server_AbilityToGainXPForPlyaer_function(nPlayerID)
	local jsondata={}
	local jsontable={}
	jsontable.player_key = table_player_key[nPlayerID]
	jsontable._able = table_able[nPlayerID]
	jsontable.SteamID64 = table_SteamID64[nPlayerID]
	table.insert(jsondata,jsontable)
	local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_ability_to_gain.php" )
		request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
		request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode)
		request:Send(function(result)
		if result.StatusCode ~= 200 then
			Server_AbilityToGainXPForPlyaer_function(nPlayerID)
			return
		end
	end )
end

-- GetConnectionState values:
-- 0 - no connection
-- 1 - bot connected
-- 2 - player connected
-- 3 - bot/player disconnected.

function Server_WaitToEnableXpGain()
	Serer_CheckForAFKPlayer()
	Timers:CreateTimer({
	endTime = 600, -- Plyaer can gain XP from this game after 10 mins later the creep spwans
	callback = function()
		EnnDisEnabled = 1
		if CHEAT_ENABLED == true then
			print("Game don't count.")
			return
		else
			CustomNetTables:SetTableValue("game_options", "game_count", {value = 1})
		end
		--print("Enable Xp gain system....")
		for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsFakeClient(nPlayerID) then
				-- Determain if this guy could gain XP
				if PlayerResource:GetConnectionState(nPlayerID) == 2 then
					table_able[nPlayerID] = 1
					Server_EnableToGainXPForPlyaer(nPlayerID)
				end
				if PlayerResource:GetConnectionState(nPlayerID) == 3 then
					table_able[nPlayerID] = 0
					Server_DisableToGainXpForPlayer(nPlayerID)
				end
				-- Determain if this guy could gain XP
			end
		end
	end
	})
end

-- Radiant=2 or Dire=3

function Server_CalculateXPForWinnerAndAll(winning_team)
	if CHEAT_ENABLED == true then return end
	local Winner
	local dis_player = 0
	for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
		if  PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsFakeClient(nPlayerID) and PlayerResource:GetConnectionState(nPlayerID) ~= 2 then
			dis_player = dis_player + 1
		end
	end

	local multiplier = 1.0
	if GetMapName() == "imba_standard" then
		multiplier = 2.0
	end

	local abandon_xp = 0 - (ABANDON_CHARGE / dis_player / multiplier)
	for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
		if  PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsFakeClient(nPlayerID) then
			if winning_team == "Radiant" then
				Winner = DOTA_TEAM_GOODGUYS
			end
			if winning_team == "Dire" then
				Winner = DOTA_TEAM_BADGUYS
			end
			if EnnDisEnabled ~= 1 then
				return
			end
			local jsondata={}
			local jsontable={}
			jsontable.SteamID64 = table_SteamID64[nPlayerID]
			jsontable.XP = table_XP[nPlayerID]

			if PlayerResource:GetTeam(nPlayerID) == Winner and PlayerResource:GetConnectionState(nPlayerID) == 2 then
				jsontable.XP = tostring(math.ceil(table_XP[nPlayerID] * multiplier)) -- WIN
				CustomNetTables:SetTableValue("player_table", tostring(nPlayerID), {
					XP = tonumber(XP_has_this_level[nPlayerID]),
					MaxXP = tonumber(XP_need_to_next_level[nPlayerID] + XP_has_this_level[nPlayerID]),
					Lvl = tonumber(XP_level[nPlayerID]),
					ID = nPlayerID,
					title = XP_level_title_player[nPlayerID],
					XP_change = tonumber(math.ceil(table_XP[nPlayerID] * multiplier)),
					title_color = Server_GetTitleColor(XP_level_title_player[nPlayerID], true)
				})
			else
				if PlayerResource:GetConnectionState(nPlayerID) ~= 2 then
					jsontable.XP = tostring(math.ceil(abandon_xp)) -- ABANDON
					CustomNetTables:SetTableValue("player_table", tostring(nPlayerID), {
						XP = tonumber(XP_has_this_level[nPlayerID]),
						MaxXP = tonumber(XP_need_to_next_level[nPlayerID] + XP_has_this_level[nPlayerID]),
						Lvl = tonumber(XP_level[nPlayerID]),
						ID = nPlayerID,
						title = XP_level_title_player[nPlayerID],
						XP_change = tonumber(math.ceil(abandon_xp)),
						title_color = Server_GetTitleColor(XP_level_title_player[nPlayerID], true)
					})
				else
					jsontable.XP = tostring(table_XP[nPlayerID] / 2) -- LOSE
					CustomNetTables:SetTableValue("player_table", tostring(nPlayerID), {
						XP = tonumber(XP_has_this_level[nPlayerID]),
						MaxXP = tonumber(XP_need_to_next_level[nPlayerID] + XP_has_this_level[nPlayerID]),
						Lvl = tonumber(XP_level[nPlayerID]),
						ID = nPlayerID,
						title = XP_level_title_player[nPlayerID],
						XP_change = tonumber(table_XP[nPlayerID] / 2),
						title_color = Server_GetTitleColor(XP_level_title_player[nPlayerID], true)
					})
				end
			end
			jsontable.player_key = table_player_key[nPlayerID]
			table.insert(jsondata,jsontable)
			Server_SendEndGameInfo(jsondata)
		end
	end
end

function Server_SendEndGameInfo(json)
	local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_end_tmp_to_perm.php" )
	request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(json))
	request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
	request:Send(function(result)
		if result.StatusCode ~= 200 then
			Server_SendEndGameInfo(json)
			return
		end
	end)
end

local table_AFK_check_allHeroes = {}
local cycle_AFK_check_interval = 60
local AFK_check_times = 5
local _maxLv

local table_AFK_exp_round =  {}
local cycle_AFK_exp_round = 1
local cycle_AFK_exp_max_round = AFK_check_times

function Serer_CheckForAFKPlayer()
	for i=1,cycle_AFK_exp_max_round do
		table_AFK_exp_round[i] = {}
	end
	for k,v in pairs(CustomNetTables:GetTableValue("game_options", "max_level")) do
		_maxLv = v
	end
	Timers(function()
			for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
				if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsFakeClient(nPlayerID) then

					table_AFK_check_allHeroes[nPlayerID]=PlayerResource:GetSelectedHeroEntity(nPlayerID)   
					if PlayerResource:GetLevel(nPlayerID) ~= _maxLv then
						table_AFK_exp_round[cycle_AFK_exp_round][nPlayerID]=CDOTA_BaseNPC_Hero.GetCurrentXP(table_AFK_check_allHeroes[nPlayerID])
						if cycle_AFK_exp_round == cycle_AFK_exp_max_round then
							cycle_AFK_exp_round = 1
						else
							cycle_AFK_exp_round = cycle_AFK_exp_round + 1
						end
						local _AFK_check_pass = 0
						for i=1,cycle_AFK_exp_max_round-1 do
							if table_AFK_exp_round[i][nPlayerID] == table_AFK_exp_round[i+1][nPlayerID] then
								_AFK_check_pass = _AFK_check_pass +1
							end
						end
						if _AFK_check_pass == cycle_AFK_exp_max_round-1 then
							is_AFK[nPlayerID] = 1
							Server_DisableToGainXpForPlayer(nPlayerID)
						end
					end

					local idle_change_time = CDOTA_BaseNPC.GetLastIdleChangeTime(table_AFK_check_allHeroes[nPlayerID])
					local current_game_time = GameRules:GetGameTime()

					if current_game_time-idle_change_time > AFK_check_times * cycle_AFK_check_interval then --AFK_check_times * cycle_AFK_check_interval
						is_AFK[nPlayerID] = 1
						Server_DisableToGainXpForPlayer(nPlayerID)
					end

				end
			end
	return cycle_AFK_check_interval --cycle_AFK_check_interval
	end)
end


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------Useful Functions-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

function Server_GetPlayerLevel(playerID)
	if CustomNetTables:GetTableValue("player_table", tostring(playerID)) then
		return CustomNetTables:GetTableValue("player_table", tostring(playerID)).Lvl
	end
end

function Server_GetPlayerXP(playerID)
	if CustomNetTables:GetTableValue("player_table", tostring(playerID)) then
		return CustomNetTables:GetTableValue("player_table", tostring(playerID)).XP
	end
end

function Server_GetPlayerTitle(playerID)
	if CustomNetTables:GetTableValue("player_table", tostring(playerID)) then
		return CustomNetTables:GetTableValue("player_table", tostring(playerID)).title
	end
end

function print_r ( t )  
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end

function Server_GetTopPlayer(ranking)
local jsondata = {}
local jsontable = {}
jsontable.Ranking = ranking
table.insert(jsondata,jsontable)
local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_top.php" )

	request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
	request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
	request:Send(function(result)
		if result.StatusCode ~= 200 then
			Server_GetTopPlayer(ranking)
			return
		else
			local Adecode=JSON:decode(result.Body)
--			print("Result:", result.Body)
			Server_RankDecode(Adecode, ranking)
		end
	end)
end

leaderboard_SteamID = {}
leaderboard_XP = {}
leaderboard_IMR = {}

function Server_RankDecode( t, ranking )
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			--print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
					elseif (type(val)=="string") then
						if pos == "SteamID64" then
							leaderboard_SteamID[ranking] = val
						end
						if pos == "XP" then
							leaderboard_XP[ranking] = val
						end
--						if pos == "IMR_has" then
--							print("Imba Matchmaking Rank:", val)
--							table.insert(leaderboard_IMR, val)
--						end
					end
				end
			end
		end
	end

	-- turn pure xp into level xp
	for k, v in pairs(leaderboard_XP) do
		Server_DecodeLeaderboard(leaderboard_SteamID[k], tonumber(v))
	end

	if (type(t)=="table") then
		sub_print_r(t,"  ")
	end
end

local rank = 0
local steamid_table = {}
local xp_table = {}
local level_table = {}
local level_title_table = {}
local title_color_table = {}
local XP_max_in_level_table = {}
local leaderboard_table = {}
local steamid_duplicate = {}
table.insert(steamid_duplicate, "76561198021465788")
table.insert(steamid_duplicate, "76561198015161808")

function Server_DecodeLeaderboard(steamid64, xp)
local level = 0 -- imba level
local level_title = "" -- imba title
local XP_in_this_level = 0 --xp in level
local XP_needed_to_levelup = 0 -- xp required to level up
local XP_max_in_level = 0
local title_color
local send_info = true

	for k, v in pairs(steamid_duplicate) do
		if v == steamid64 then
--			print("Found Steam ID duplicated, ignoring...")
			send_info = false
		end
	end
	if send_info == false then return end

	for i = #table_rankXP, 1, -1 do
		if xp and table_rankXP and table_rankXP[i] then
			if xp >= table_rankXP[i] then
				if level < i then
					rank = rank +1
					level = i-1
					level_title = Server_GetTitle(level)
					XP_needed_to_levelup = table_rankXP[i+1] - xp
					XP_in_this_level = xp - table_rankXP[i]
					title_color = Server_GetTitleColor(level_title, true)

					table.insert(steamid_table, steamid64)
					table.insert(xp_table, XP_in_this_level)
					table.insert(level_table, level)
					table.insert(level_title_table, level_title)
					table.insert(title_color_table, title_color)
					table.insert(XP_max_in_level_table, XP_needed_to_levelup + XP_in_this_level)
				end
			end
		end
	end

	print(rank, steamid64, level, level_title)
	CustomNetTables:SetTableValue("game_options", "leaderboard", {
		Rank = rank,
		SteamID64 = steamid_table,
		XP = xp_table,
		MaxXP = XP_max_in_level_table,
		Lvl = level_table,
		Title = level_title_table,
		TitleColor = title_color_table,
--		IMR = leaderboard_IMR,
	})

	table.insert(steamid_duplicate, steamid64)
end
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------HERO Particle-----------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

function Server_findHeroByPlayerID(nPlayerID)
	local _Hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
	return _Hero
end

local Table_Hero_Particle = {}

function Server_DestroyParticle(_particle)
	ParticleManager:DestroyParticle(_particle, true)
	ParticleManager:ReleaseParticleIndex(_particle)
	_particle = nil
end

function Server_Particle_Darkmoon(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Sands(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end


function Server_Particle_Frost(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Lava(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Platinum(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_FlameHaze(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_orange/courier_greevil_orange_ambient_3.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_HellFire(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_red/courier_greevil_red_ambient_3.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Sakura(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Radiant(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/radiant_fx2/good_ancient001_ambient.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end

function Server_Particle_Dire(nPlayerID)
	if Table_Hero_Particle[nPlayerID] then
		Server_DestroyParticle(Table_Hero_Particle[nPlayerID])
	end
	local hero = Server_findHeroByPlayerID(nPlayerID)
	local _particle = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient_flow_test.vpcf",PATTACH_ABSORIGIN_FOLLOW,hero)
	Table_Hero_Particle[nPlayerID] = _particle
	ParticleManager:SetParticleControlEnt(_particle,0,hero,PATTACH_ABSORIGIN_FOLLOW,"follow_origin",hero:GetAbsOrigin(),true)
end