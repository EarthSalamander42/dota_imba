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


--Level table for IMBA XP
local table_rankXP = {0,100,200,300,400,500,600,800,1000,1200,1400,1700,2000,2300,2600,2900,3400,3800,4200,4600,5000,5500,6000,6500,7000,7500,8500,9000,9500,10000,10500}
--------------------  0  1   2   3   4   5   6   7    8    9    10  11    12  13    14  15   16   17   18   19   20   21   22   23   24   25   26   27   28   29    30 
local XP_level_title= {}
local XP_level = {}
local XP_level_title_player = {}
local XP_need_to_next_level = {}
local XP_this_level = {}
local XP_has_this_level = {}
--Level table for IMBA XP

function Server_SetRankTitle()

	for ni = 1 , 31 do
		if ni==1 then
			XP_level_title[ni]=''
		end
		if ni>=2 and ni<=6 then
			XP_level_title[ni]='#imba_rank_title_rookie'
		end
		if ni>=7 and ni<=11 then
			XP_level_title[ni]='#imba_rank_title_amateur'
		end
		if ni>=12 and ni<=16 then
			XP_level_title[ni]='#imba_rank_title_warrior'
		end
		if ni>=17 and ni<=21 then
			XP_level_title[ni]='#imba_rank_title_general'
		end
		if ni>=22 and ni<=26 then
			XP_level_title[ni]='#imba_rank_title_master'
		end
		if ni>=27 and ni<=31 then
			XP_level_title[ni]='#imba_rank_title_legendary'
		end
	end
end

function Server_DecodeForPlayer ( t, nPlayerID )   --To deep-decode the Json code...
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
		if  PlayerResource:IsValidPlayer(nPlayerID)  then
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
	for i=31,1,-1 do
		if table_XP_has and table_XP_has[nPlayerID] and table_rankXP and table_rankXP[i] then
			if tonumber(table_XP_has[nPlayerID]) >= table_rankXP[i] then
				XP_level[nPlayerID] = i-1
				XP_level_title_player[nPlayerID] = XP_level_title[i]
				XP_this_level[nPlayerID] = table_rankXP[i]
				if i == 31 then
					XP_need_to_next_level[nPlayerID] = 0
				else
					XP_need_to_next_level[nPlayerID] = table_rankXP[i+1] - tonumber(table_XP_has[nPlayerID])
				end
				XP_has_this_level[nPlayerID] = tonumber(table_XP_has[nPlayerID]) - table_rankXP[i]
				CustomNetTables:SetTableValue("player_table", tostring(nPlayerID), {XP = tonumber(XP_has_this_level[nPlayerID]), MaxXP = tonumber(XP_need_to_next_level[nPlayerID] + XP_has_this_level[nPlayerID]), Lvl = tonumber(XP_level[nPlayerID]), ID = nPlayerID})
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
		Server_SetRankTitle()

		for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
			Server_SendAndGetInfoForAll_function(nPlayerID)
		end
		_finished = 1
	end
end

function Server_SendAndGetInfoForAll_function(nPlayerID)
	if PlayerResource:IsValidPlayer(nPlayerID)  then
	if PlayerResource:IsFakeClient(nPlayerID) then
	else

		table_SteamID64[nPlayerID] = tostring(PlayerResource:GetSteamID(nPlayerID))
		table_XP[nPlayerID] = tostring(math.random(24,32)) --How many XP will player get in this game

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
end

function Server_EnableToGainXPForPlyaer(nPlayerID)
	--print("player key:"..table_player_key[nPlayerID])
	if EnnDisEnabled == 1 and is_AFK[nPlayerID] == 0 then
		table_able[nPlayerID] = 1
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
		end )
	end
end

function Server_DisableToGainXpForPlayer(nPlayerID)
	if EnnDisEnabled == 1 then
		table_able[nPlayerID] = 0
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
		end )
	end
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
		--print("Enable Xp gain system....")
		for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:IsValidPlayer(nPlayerID)  then
			if PlayerResource:IsFakeClient(nPlayerID) then
			else
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
	end
	})
end

-- Radiant=2 or Dire=3

function Server_CalculateXPForWinnerAndAll(winning_team)
	local Winner
	for nPlayerID=0, DOTA_MAX_TEAM_PLAYERS-1 do
		if  PlayerResource:IsValidPlayer(nPlayerID)  then
		if PlayerResource:IsFakeClient(nPlayerID) then
		else
			if winning_team == "Radiant" then
				Winner = DOTA_TEAM_GOODGUYS
			end
			if winning_team == "Dire" then
				Winner = DOTA_TEAM_BADGUYS
			end
			local jsondata={}
			local jsontable={}
			jsontable.SteamID64 = table_SteamID64[nPlayerID]
			jsontable.XP = table_XP[nPlayerID]
			if PlayerResource:GetTeam(nPlayerID) == Winner then
				jsontable.XP = tostring(math.ceil(table_XP[nPlayerID] * 1.2))
			end
			jsontable.player_key = table_player_key[nPlayerID]
			table.insert(jsondata,jsontable)
			local request = CreateHTTPRequestScriptVM( "GET", "http://www.dota2imba.cn/XP_game_end_tmp_to_perm.php" )
				request:SetHTTPRequestGetOrPostParameter("data_json",JSON:encode(jsondata))
				request:SetHTTPRequestGetOrPostParameter("auth",_AuthCode);
				request:Send(function(result)
			end )

		end
		end
	end 
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
				if PlayerResource:IsValidPlayer(nPlayerID)  then
				if PlayerResource:IsFakeClient(nPlayerID) then
				else
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
			end
	return cycle_AFK_check_interval --cycle_AFK_check_interval
	end)
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