-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors: 
--     EarthSalamander #42
--

function DebugPrint(...)
	--local spew = Convars:GetInt('barebones_spew') or -1
	--if spew == -1 and BAREBONES_DEBUG_SPEW then
	--spew = 1
	--end

	--if spew == 1 then
	--print(...)
	--end
end

function DebugPrintTable(...)
	--local spew = Convars:GetInt('barebones_spew') or -1
	--if spew == -1 and BAREBONES_DEBUG_SPEW then
	--spew = 1
	--end

	--if spew == 1 then
	--PrintTable(...)
	--end
end

function PrintAll(t)
	log.debug(t)
end

function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

function AddTableToTable( t1, t2)
	for k,v in pairs(t2) do
		table.insert(t1, v)
	end
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
	table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
	-- Ignore FDesc
	if v ~= 'FDesc' then
		local value = t[v]

		if type(value) == "table" and not done[value] then
		done [value] = true
		print(string.rep ("\t", indent)..tostring(v)..":")
		PrintTable (value, indent + 2, done)
		elseif type(value) == "userdata" and not done[value] then
		done [value] = true
		print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
		if t.FDesc and t.FDesc[v] then
			print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
		end
	end
	end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'

-- Returns a random value from a non-array table
function RandomFromTable(table)
	local array = {}
	local n = 0
	for _,v in pairs(table) do
		array[#array+1] = v
		n = n + 1
	end

	if n == 0 then return nil end

	return array[RandomInt(1,n)]
end

-- Turns an entindex string into a table and returns a table of handles.
-- Separator can only be a space (" ") or a comma (",").
function StringToTableEnt(string, separator)
	local gmatch_sign

	if separator == " " then
		gmatch_sign = "%S+"
	elseif separator == "," then
		gmatch_sign = "([^,]+)"
	end

	local return_table = {}
	for str in string.gmatch(string, gmatch_sign) do 		
		local handle = EntIndexToHScript(tonumber(str))
		table.insert(return_table, handle)
	end	

	return return_table
end

-- Turns a table of entity handles into entindex string separated by commas.
function TableToStringCommaEnt(table)	
	local string = ""
	local first_value = true

	for _,handle in pairs(table) do
		if first_value then
			string = string..tostring(handle:entindex())	
			first_value = false
		else
			string = string..","
			string = string..tostring(handle:entindex())	
		end		
	end

	return string
end

function FindNearestPointFromLine(caster, dir, affected)
	local castertoaffected = affected - caster
	local len = castertoaffected:Dot(dir)
	local ntgt = Vector(dir.x * len, dir.y * len, caster.z)
	return caster + ntgt
end

-------------------------------------------------------------------------------------------------
-- IMBA: custom utility functions
-------------------------------------------------------------------------------------------------

-- Returns the killstreak/deathstreak bonus gold for this hero
function GetKillstreakGold( hero )
	local base_bounty = HERO_KILL_GOLD_BASE + hero:GetLevel() * HERO_KILL_GOLD_PER_LEVEL
	local gold = ( hero.kill_streak_count ^ KILLSTREAK_EXP_FACTOR ) * HERO_KILL_GOLD_PER_KILLSTREAK - hero.death_streak_count * HERO_KILL_GOLD_PER_DEATHSTREAK
	
	-- Limits to maximum and minimum kill/deathstreak values
	gold = math.max(gold, (-1) * base_bounty * HERO_KILL_GOLD_DEATHSTREAK_CAP / 100 )
	gold = math.min(gold, base_bounty * ( HERO_KILL_GOLD_KILLSTREAK_CAP - 100 ) / 100)

	return gold
end

-- Precaches an unit, or, if something else is being precached, enters it into the precache queue
function PrecacheUnitWithQueue( unit_name )
	Timers:CreateTimer(function()
		-- If something else is being precached, wait two seconds
		if UNIT_BEING_PRECACHED then
			return 2

		-- Otherwise, start precaching and block other calls from doing so
		else
			UNIT_BEING_PRECACHED = true
			PrecacheUnitByNameAsync(unit_name, function(...) end)

			-- Release the queue after one second
			Timers:CreateTimer(2, function()
				UNIT_BEING_PRECACHED = false
			end)
		end
	end)

--	print("Precached", unit_name)
end

-- Initializes heroes' innate abilities
function InitializeInnateAbilities( hero )	
	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do		
		local current_ability = hero:GetAbilityByIndex(i)		
		if current_ability and current_ability.IsInnateAbility then
			if current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end
		end
	end
end

-- Upgrades a tower's abilities
function UpgradeTower(tower)
	for i = 0, tower:GetAbilityCount() -1 do
		local ability = tower:GetAbilityByIndex(i)
		if ability and ability:GetLevel() < ability:GetMaxLevel() then			
			ability:SetLevel(ability:GetLevel() + 1)
		end
	end
end

-- Initialize Physics library on this target
function InitializePhysicsParameters(unit)

	if not IsPhysicsUnit(unit) then
		Physics:Unit(unit)
		unit:SetPhysicsVelocityMax(600)
		unit:PreventDI()
	end
end

-- Gold bag pickup event function
function GoldPickup(event)
	if IsServer() then
		local item = EntIndexToHScript( event.ItemEntityIndex )
		local owner = EntIndexToHScript( event.HeroEntityIndex )
		local gold_per_bag = item:GetCurrentCharges()
		PlayerResource:ModifyGold( owner:GetPlayerID(), gold_per_bag, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, gold_per_bag, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

-- Talents modifier function
function ApplyAllTalentModifiers()
	Timers:CreateTimer(0.1,function()
		local current_hero_list = HeroList:GetAllHeroes()
		for k,v in pairs(current_hero_list) do
			local hero_name = string.match(v:GetName(),"npc_dota_hero_(.*)")
			-- TODO: This is odd, please do something better bro
			if hero_name == nil or hero_name == "npc_dota_hero_ghost_revenant" or hero_name == "npc_dota_hero_hell_empress" then print("Custom Hero, ignoring talents for now.") return end
			for i = 1, 8 do
				local talent_name = "special_bonus_imba_"..hero_name.."_"..i
				local modifier_name = "modifier_special_bonus_imba_"..hero_name.."_"..i
				if v:HasTalent(talent_name) and not v:HasModifier(modifier_name) then
					v:AddNewModifier(v,v,modifier_name,{})
				end
			end
		end
		return 0.5
	end)
end

function NetTableM(tablename,keyname,...) 
	local values = {...}                                                                  -- Our user input
	local returnvalues = {}                                                               -- table that will be unpacked for result                                                    
	for k,v in ipairs(values) do  
		local keyname = keyname..v[1]                                                       -- should be 1-8, but probably can be extrapolated later on to be any number
		if IsServer() then
			local netTableKey = netTableCmd(false,tablename,keyname)                              -- Command to grab our key set
			local my_key = createNetTableKey(v)                                               -- key = 250,444,111 as table, stored in key as 1 2 3
			if not netTableKey then                                                           -- No key with requested name exists
				netTableCmd(true,tablename,keyname,my_key)                                          -- create database key with "tablename","myHealth1","1=250,2=444,3=111"
			elseif type(netTableKey) == 'boolean' then                                        -- Our check returned that a key exists but that it is empty, we need to populate it for clients
				netTableCmd(true,tablename,keyname,my_key)                                          -- create database key with "tablename","myHealth1","1=250,2=444,3=111"
			else                                                                              -- Our key exists and we got some values, now we need to check the key against the requested value from other scripts  
				if #v > 1 then
					for i=1,#netTableKey do
						if netTableKey[i] ~= v[i-1] then                                              -- compare each value, does server 1 = our 250? does server 2 = our 444? 
							netTableCmd(true,tablename,keyname,my_key)                                      -- If our key is different from the sent value, rewrite it ONCE and break execution to main loop again
							break
						end
					end
				end
			end      
		end
		local allkeys = netTableCmd(false,tablename,keyname)
		if allkeys and type(allkeys) ~= 'boolean' then
			for i=1,#allkeys do
				table.insert(returnvalues, allkeys[i])    
			end
		else
			for i=1,#v do
				table.insert(returnvalues, 0)
			end
		end
	end
return unpack(returnvalues)
end

function netTableCmd(send,readtable,key,tabletosend)
	if send == false then
		local finalresulttable = {}
		local nettabletemp = CustomNetTables:GetTableValue(readtable,key)
		if not nettabletemp then return false end
		for key,value in pairs(nettabletemp) do
			table.insert(finalresulttable,value)
		end          
		if #finalresulttable > 0 then 
			return finalresulttable
		else
			return true
		end
	else
		CustomNetTables:SetTableValue(readtable, key, tabletosend)
	end
end

function createNetTableKey(v)
	local valuePair = {}
	if #v > 1 then
		for i=2,#v do
			table.insert(valuePair,v[i])                                              -- returns just numbers 2-x from sent value...
		end    
	end
	return valuePair  
end

function getkvValues(tEntity, ...) -- KV Values look hideous in finished code, so this function will parse through all sent KV's for tEntity (typically self)
	local values = {...}
	local data = {}
	for i,v in ipairs(values) do
		table.insert(data,tEntity:GetSpecialValueFor(v))
	end
	return unpack(data)
end

function TalentManager(tEntity, nameScheme, ...)
	local talents = {...}
	local return_values = {}
	for k,v in pairs(talents) do    
		if #v > 1 then
			for i=1,#v do
				table.insert(return_values, tEntity:FindSpecificTalentValue(nameScheme..v[1],v[i]))
			end
		else
			table.insert(return_values, tEntity:FindTalentValue(nameScheme..v[1]))
		end
	end    
return unpack(return_values)
end

function findtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorTarget()
	local c = source:GetCaster()
	if t and c then return t,c end
end

-- Controls comeback gold
function UpdateComebackBonus(points, team)

	-- Calculate both teams' networths
	local team_networth = {}
	team_networth[DOTA_TEAM_GOODGUYS] = 0
	team_networth[DOTA_TEAM_BADGUYS] = 0
	for player_id = 0, 19 do
		if PlayerResource:IsImbaPlayer(player_id) and PlayerResource:GetConnectionState(player_id) <= 2 and (not PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id)) then
			team_networth[PlayerResource:GetTeam(player_id)] = team_networth[PlayerResource:GetTeam(player_id)] + PlayerResource:GetTotalEarnedGold(player_id)
		end
	end

	-- Update teams' score
	if COMEBACK_BOUNTY_SCORE[team] == nil then
		COMEBACK_BOUNTY_SCORE[team] = 0
	end
	
	COMEBACK_BOUNTY_SCORE[team] = COMEBACK_BOUNTY_SCORE[team] + points

	-- If one of the teams is eligible, apply the bonus
	if (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] < COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS]) and (team_networth[DOTA_TEAM_GOODGUYS] < team_networth[DOTA_TEAM_BADGUYS]) then
		COMEBACK_BOUNTY_BONUS[DOTA_TEAM_GOODGUYS] = (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] - COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS]) / ( COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] + 60 - GameRules:GetDOTATime(false, false) / 60 )
	elseif (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] < COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS]) and (team_networth[DOTA_TEAM_BADGUYS] < team_networth[DOTA_TEAM_GOODGUYS]) then
		COMEBACK_BOUNTY_BONUS[DOTA_TEAM_BADGUYS] = (COMEBACK_BOUNTY_SCORE[DOTA_TEAM_GOODGUYS] - COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS]) / ( COMEBACK_BOUNTY_SCORE[DOTA_TEAM_BADGUYS] + 60 - GameRules:GetDOTATime(false, false) / 60 )
	end
end

-------------------------------------------------------------------------------------------------------
-- Client side daytime tracking system
-------------------------------------------------------------------------------------------------------

function StoreCurrentDayCycle()	
	Timers:CreateTimer(function()		

		-- Get current daytime cycle
		local is_day = GameRules:IsDaytime()		

		-- Set in the table
		CustomNetTables:SetTableValue("gamerules", "isdaytime", {is_day = is_day} )		

	-- Repeat
	return 0.5
	end)	
end

function IsDaytime()
	if CustomNetTables:GetTableValue("gamerules", "isdaytime") then
		if CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day then  
			local is_day = CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day  

			if is_day == 1 then
				return true
			else
				return false
			end
		end
	end

	return true   
end

function SystemMessage(token, vars)
	CustomGameEventManager:Send_ServerToAllClients("custom_system_message", { token = token or "", vars = vars or {}})
end

-- This function is responsible for cleaning dummy units and wisps that may have accumulated
function StartGarbageCollector()	
--	print("started collector")

	-- Find all dummy units in the game
	local dummies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		

	-- Cycle each dummy. If it is alive for more than 1 minute, delete it.
	local gametime = GameRules:GetGameTime()
	for _, dummy in pairs(dummies) do
		if dummy:GetUnitName() == "npc_dummy_unit" then			
			local dummy_creation_time = dummy:GetCreationTime()
			if gametime - dummy_creation_time > 60 then
				log.warn("NUKING A LOST DUMMY!")
				UTIL_Remove(dummy)
			else
				log.warn("dummy is still kinda new. Not removing it!")
			end
		end
	end

--	local particle_removed = 0

--	for _, particle in pairs(PARTICLE_TABLE) do
--		print("Particle:", particle)
--		print("Amount:", gametime - particle.lifetime)

--		if gametime - particle.lifetime > 0 then
--			if particle then
--				particle_removed = particle_removed +1
--				table.remove(PARTICLE_TABLE, particle.name)
--			end
--		end
--	end

--	for i = 1, #PARTICLE_TABLE do
--		if manager == PARTICLE_TABLE[i] then
--			particle_removed = particle_removed+1		
--			table.remove(PARTICLE_TABLE, i)
--			break
--		end
--	end

--	if particle_removed > 0 then
--		print("Removed "..particle_removed.." particle.")			
--	end
end
--[[
-- This function is responsible for deciding which team is behind, if any, and store it at a nettable.
function DefineLosingTeam()
-- Losing team is defined as a team that is both behind in both the sums of networth and levels.
local radiant_networth = 0
local radiant_levels = 0
local dire_networth = 0
local dire_levels = 0

	for i = 0, DOTA_MAX_TEAM_PLAYERS-1 do
		if PlayerResource:IsValidPlayer(i) then

			-- Only count connected players or bots
			if PlayerResource:GetConnectionState(i) == 1 or PlayerResource:GetConnectionState(i) == 2 then

			-- Get player
			local player = PlayerResource:GetPlayer(i)
			
				if player then				
					-- Get team
					local team = player:GetTeam()				

					-- Get level, add it to the sum
					local level = player:GetAssignedHero():GetLevel()				

					-- Get networth
					local hero_networth = 0
					for i = 0, 8 do
						local item = player:GetAssignedHero():GetItemInSlot(i)
						if item then
							hero_networth = hero_networth + GetItemCost(item:GetName())						
						end
					end

					-- Add to the relevant team
					if team == DOTA_TEAM_GOODGUYS then					
						radiant_networth = radiant_networth + hero_networth					
						radiant_levels = radiant_levels + level					
					else					
						dire_networth = dire_networth + hero_networth					
						dire_levels = dire_levels + level					
					end				
				end
			end
		end
	end	

	-- Check for the losing team. A team must be behind in both levels and networth.
	if (radiant_networth < dire_networth) and (radiant_levels < dire_levels) then
		-- Radiant is losing		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = DOTA_TEAM_GOODGUYS})

	elseif (radiant_networth > dire_networth) and (radiant_levels > dire_levels) then
		-- Dire is losing		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = DOTA_TEAM_BADGUYS})

	else -- No team is losing - one of the team is better on levels, the other on gold. No experience bonus in this case		
		CustomNetTables:SetTableValue("gamerules", "losing_team", {losing_team = 0})		
	end
end
--]]
hero_particles = {}
hero_particles[0] = 0
hero_particles[1] = 0
hero_particles[2] = 0
hero_particles[3] = 0
hero_particles[4] = 0
hero_particles[5] = 0
hero_particles[6] = 0
hero_particles[7] = 0
hero_particles[8] = 0
hero_particles[9] = 0
hero_particles[10] = 0
hero_particles[11] = 0
hero_particles[12] = 0
hero_particles[13] = 0
hero_particles[14] = 0
hero_particles[15] = 0
hero_particles[16] = 0
hero_particles[17] = 0
hero_particles[18] = 0
hero_particles[19] = 0

total_hero_particles = {}
total_hero_particles[0] = 0
total_hero_particles[1] = 0
total_hero_particles[2] = 0
total_hero_particles[3] = 0
total_hero_particles[4] = 0
total_hero_particles[5] = 0
total_hero_particles[6] = 0
total_hero_particles[7] = 0
total_hero_particles[8] = 0
total_hero_particles[9] = 0
total_hero_particles[10] = 0
total_hero_particles[11] = 0
total_hero_particles[12] = 0
total_hero_particles[13] = 0
total_hero_particles[14] = 0
total_hero_particles[15] = 0
total_hero_particles[16] = 0
total_hero_particles[17] = 0
total_hero_particles[18] = 0

total_particles = 0
total_particles_created = 0
function OverrideCreateParticle()
	local CreateParticleFunc = ParticleManager.CreateParticle

	ParticleManager.CreateParticle = 
	function(manager, path, int, handle) 		 
		local particle = CreateParticleFunc(manager, path, int, handle)
		local time = GameRules:GetGameTime()

		manager.lifetime = time
		manager.name = path

--		print("Manager:", manager)
--		print("Manager Time:", manager.lifetime)
--		print("Path:", path)
--		print("Int:", int)
--		print("Handle:", handle)
--		print("------------------------")

		-- Index in a big, fat table. Only works in tools mode!
--		if IsInToolsMode() then
			PARTICLE_TABLE = PARTICLE_TABLE or {}
			table.insert(PARTICLE_TABLE, manager)
--		end

--		if path == "particles/units/heroes/hero_pudge/pudge_meathook.vpcf" then
--			print("HOOK!")
--			print("Manager:", manager)
--			print("Int:", int)
--			print("Handle:", handle)
--			return particle
--		end

		if handle and handle:IsRealHero() then
			if handle.pID then
--				print("Valid pID")
--				hero_particles[handle.pID] = hero_particles[handle.pID] +1 -- Need to filter ReleaseParticleIndex for hero to get only active particles
				total_hero_particles[handle.pID] = total_hero_particles[handle.pID] +1
			end
		else
--			print("non-Hero Handle:", handle)
		end

		total_particles = total_particles +1
		total_particles_created = total_particles_created +1

		return particle
	end
end

function OverrideCreateLinearProjectile()
	local CreateProjectileFunc = ProjectileManager.CreateLinearProjectile

	ProjectileManager.CreateProjectileFunc = 
	function(manager, handle)                  

		-- Do things here to override

		return CreateProjectileFunc(manager, handle)
	end
end

function OverrideReleaseIndex()
local ReleaseIndexFunc = ParticleManager.ReleaseParticleIndex
local released_particles = 0

	ParticleManager.ReleaseParticleIndex = 
	function(manager, int)		
		-- Find handle in table
--		print(#PARTICLE_TABLE)
		for i = 1, #PARTICLE_TABLE do
			if manager == PARTICLE_TABLE[i] then
				released_particles = released_particles+1		
				table.remove(PARTICLE_TABLE, i)
				break
			end
		end

		-- Release normally
		total_particles = total_particles -1
		ReleaseIndexFunc(manager, int)
	end
--	print("Released "..released_particles.." particles.")
end

function PrintParticleTable()
	PrintTable(PARTICLE_TABLE)	
end

-- Custom NetGraph. Creator: Cookies [Earth Salamander]
function ImbaNetGraph(tick)
	Timers:CreateTimer(function()
		local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
		local good_unit_count = 0
		local bad_unit_count = 0
		local good_build_count = 0
		local bad_build_count = 0
		local dummy_count = 0

		for _, unit in pairs(units) do
			if unit:GetTeamNumber() == 2 then
				if unit:IsBuilding() then
					good_build_count = good_build_count+1
				else
					good_unit_count = good_unit_count +1
				end
			elseif unit:GetTeamNumber() == 3 then
				if unit:IsBuilding() then
					bad_build_count = bad_build_count+1
				else
					bad_unit_count = bad_unit_count +1
				end
			end
			if unit:GetUnitName() == "npc_dummy_unit" or unit:GetUnitName() == "npc_dummy_unit_perma" then			
				dummy_count = dummy_count +1
			end
		end

		CustomNetTables:SetTableValue("netgraph", "hero_number", {value = PlayerResource:GetPlayerCount()})
		CustomNetTables:SetTableValue("netgraph", "good_unit_number", {value = good_unit_count -4}) -- developer statues
		CustomNetTables:SetTableValue("netgraph", "bad_unit_number", {value = bad_unit_count -4}) -- developer statues
		CustomNetTables:SetTableValue("netgraph", "good_build_number", {value = good_build_count})
		CustomNetTables:SetTableValue("netgraph", "bad_build_number", {value = bad_build_count})
		CustomNetTables:SetTableValue("netgraph", "total_unit_number", {value = #units})
		CustomNetTables:SetTableValue("netgraph", "total_dummy_number", {value = dummy_count})
		CustomNetTables:SetTableValue("netgraph", "total_dummy_created_number", {value = dummy_created_count})
--		CustomNetTables:SetTableValue("netgraph", "total_particle_number", {value = total_particles})
--		CustomNetTables:SetTableValue("netgraph", "total_particle_created_number", {value = total_particles_created})

--		for i = 0, PlayerResource:GetPlayerCount() -1 do
--			CustomNetTables:SetTableValue("netgraph", "hero_particle_"..i-1, {particle = hero_particles[i-1], pID = i-1})
--			CustomNetTables:SetTableValue("netgraph", "hero_total_particle_"..i-1, {particle = total_hero_particles[i-1], pID = i-1})
--		end
	return tick
	end)
end

function table.deepmerge(t1, t2)
	for k,v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end

function ReconnectPlayer(player_id)
if not player_id then player_id = 0 end

	log.info("Player is reconnecting:", player_id)
	-- Reinitialize the player's pick screen panorama, if necessary
	if HeroSelection.HorriblyImplementedReconnectDetection then
		HeroSelection.HorriblyImplementedReconnectDetection[player_id] = false
		Timers:CreateTimer(1.0, function()
			if HeroSelection.HorriblyImplementedReconnectDetection[player_id] then
				local pick_state = HeroSelection.playerPickState[player_id].pick_state
				local repick_state = HeroSelection.playerPickState[player_id].repick_state

				local data = {
					PlayerID = player_id,
					PickedHeroes = HeroSelection.picked_heroes,
					pickState = pick_state,
					repickState = repick_state
				}

				PrintTable(HeroSelection.picked_heroes)
				CustomGameEventManager:Send_ServerToAllClients("player_reconnected", {PlayerID = player_id, PickedHeroes = HeroSelection.picked_heroes, pickState = pick_state, repickState = repick_state})
			else
				log.info("Not fully reconnected yet:", player_id)
				return 0.1
			end

			if GetMapName() == "imba_overthrow" then
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = true})
			else
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = false})
			end
		end)

		-- If this is a reconnect from abandonment due to a long disconnect, remove the abandon state
		if PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id) then
			local player_name = keys.name
			local hero = PlayerResource:GetPickedHero(player_id)
			local hero_name = PlayerResource:GetPickedHeroName(player_id)
			local line_duration = 7
			Notifications:BottomToAll({hero = hero_name, duration = line_duration})
			Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
			Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

			-- Stop redistributing gold to allies, if applicable
			PlayerResource:StopAbandonGoldRedistribution(player_id)
		end
	else
		log.info("Player "..player_id.." has not fully connected before this time")
	end
end

function DonatorCompanion(ID, model)
if model == nil then return end
local hero = PlayerResource:GetPlayer(ID):GetAssignedHero()
local color = hero:GetFittingColor()

	if hero.companion then
		hero.companion:ForceKill(false)
	end

	local companion = CreateUnitByName("npc_imba_donator_companion", hero:GetAbsOrigin() + RandomVector(200), true, hero, hero, hero:GetTeamNumber())
	companion:SetModel(model)
	companion:SetOriginalModel(model)
	companion:SetOwner(hero)
	companion:SetControllableByPlayer(hero:GetPlayerID(), true)

	companion:AddNewModifier(companion, nil, "modifier_companion", {})

	hero.companion = companion

	if model == "models/courier/baby_rosh/babyroshan.vmdl" then
		local particle_name = {}
		particle_name[0] = "particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"
		particle_name[1] = "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf"
		particle_name[2] = "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf"
		particle_name[3] = "particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf" -- particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon_flying.vpcf
		particle_name[4] = "particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf"
		particle_name[5] = "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf"
		particle_name[6] = "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf"
		-- also attach eyes effect later
		local random_int = RandomInt(0, #particle_name)

		local particle = ParticleManager:CreateParticle(particle_name[random_int], PATTACH_ABSORIGIN_FOLLOW, companion)
		if random_int <= 4 then
			companion:SetMaterialGroup(tostring(random_int))
		else
			companion:SetModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetOriginalModel("models/courier/baby_rosh/babyroshan_elemental.vmdl")
			companion:SetMaterialGroup(tostring(random_int-4))
		end

		companion:SetModelScale(0.7)
	elseif model == "npc_imba_donator_companion_suthernfriend" then
		companion:SetMaterialGroup("1")
	elseif model == "models/heroes/mario/mario_model.vmdl" then
		companion:SetMaterialGroup(tostring(RandomInt(0, 2)))
		companion:SetModelScale(0.5)
	elseif model == "npc_imba_donator_companion_baekho" then
		local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_baekho/courier_baekho_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, companion)
	end

--	if string.find(model, "flying") then
--		companion:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
--	end

--	if super_donator then
--		local ab = companion:FindAbilityByName("companion_morph")
--		ab:SetLevel(1)
--		ab:CastAbility()		
--	end
end

function UpdateRoshanBar(roshan)
	CustomNetTables:SetTableValue("game_options", "roshan", {
		level = GAME_ROSHAN_KILLS +1,
		HP = roshan:GetHealth(),
		HP_alt = roshan:GetHealthPercent(),
		maxHP = roshan:GetMaxHealth()
	})
	return time
end

-- Checks if this ability is casted by someone with Spell Steal (i.e. Rubick)
function IsStolenSpell(caster)

	-- If the caster has the Spell Steal ability, return true
	if caster:FindAbilityByName("rubick_spell_steal") then
		return true
	end

	return false
end

function InitRunes()
	bounty_rune_spawners = {}
	bounty_rune_locations = {}
	powerup_rune_spawners = {}
	powerup_rune_locations = {}

	bounty_rune_spawners = Entities:FindAllByName("dota_item_rune_spawner_bounty")

	if GetMapName() == "imba_overthrow" then
		powerup_rune_spawners = Entities:FindAllByName("dota_item_rune_spawner")
	else
		powerup_rune_spawners = Entities:FindAllByClassname("dota_item_rune_spawner_powerup")
	end

	for i = 1, #powerup_rune_spawners do
		powerup_rune_locations[i] = powerup_rune_spawners[i]:GetAbsOrigin()
		powerup_rune_spawners[i]:RemoveSelf()
	end

	for i = 1, #bounty_rune_spawners do
		bounty_rune_locations[i] = bounty_rune_spawners[i]:GetAbsOrigin()
		bounty_rune_spawners[i]:RemoveSelf()
	end
end

-- Spawns runes on the map
function SpawnImbaRunes()
bounty_rune_is_initial_bounty_rune = false

	-- Remove any existing runes, if any
	RemoveRunes()

	-- List of powerup rune types
	local powerup_rune_types = {}
	powerup_rune_types[1] = {"item_imba_rune_arcane", "particles/generic_gameplay/rune_arcane.vpcf"}
	powerup_rune_types[2] = {"item_imba_rune_double_damage", "particles/generic_gameplay/rune_doubledamage.vpcf"}
	powerup_rune_types[3] = {"item_imba_rune_haste", "particles/generic_gameplay/rune_haste.vpcf"}
	powerup_rune_types[4] = {"item_imba_rune_regeneration", "particles/generic_gameplay/rune_regeneration.vpcf"}
	powerup_rune_types[5] = {"item_imba_rune_illusion", "particles/generic_gameplay/rune_illusion.vpcf"}
	powerup_rune_types[6] = {"item_imba_rune_invisibility", "particles/generic_gameplay/rune_invisibility.vpcf"}
	powerup_rune_types[7] = {"item_imba_rune_frost", "particles/econ/items/puck/puck_snowflake/puck_snowflake_ambient.vpcf"}
--	powerup_rune_types[8] = {"item_imba_rune_ember", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf"}
--	powerup_rune_types[9] = {"item_imba_rune_stone", "particles/econ/items/natures_prophet/natures_prophet_flower_treant/natures_prophet_flower_treant_ambient.vpcf"}

	local rune
	local particle
	local random_int = RandomInt(1, #powerup_rune_types)
	for k, v in pairs(powerup_rune_locations) do
		rune = CreateItemOnPositionForLaunch(powerup_rune_locations[k], CreateItem(powerup_rune_types[random_int][1], nil, nil))
		RegisterRune(rune)
		SpawnRuneParticle(rune, powerup_rune_types[random_int][2])
	end

	for k, v in pairs(bounty_rune_locations) do
		local bounty_rune = CreateItem("item_imba_rune_bounty", nil, nil)
		rune = CreateItemOnPositionForLaunch(bounty_rune_locations[k], bounty_rune)		
		RegisterRune(rune)

		-- If these are the 00:00 runes, double their worth
		local game_time = GameRules:GetDOTATime(false, false)
		if game_time < 1 then
			bounty_rune_is_initial_bounty_rune = true
			SpawnRuneParticle(rune, "particles/generic_gameplay/rune_bounty_first.vpcf")
		else
			bounty_rune_is_initial_bounty_rune = false
			SpawnRuneParticle(rune, "particles/generic_gameplay/rune_bounty.vpcf")
		end
	end
end

function SpawnRuneParticle(rune, particle)
	local rune_particle = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, rune)
	ParticleManager:SetParticleControl(rune_particle, 0, rune:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(rune_particle)
end

function RegisterRune(rune)
	AddFOWViewer(2, rune:GetAbsOrigin(), 100, 0.02, false)
	AddFOWViewer(3, rune:GetAbsOrigin(), 100, 0.02, false)

	-- Initialize table
	if not rune_spawn_table then
		rune_spawn_table = {}
	end

	-- Register rune into table
	table.insert(rune_spawn_table, rune)
end

function RemoveRunes()
	if rune_spawn_table then

		-- Remove existing runes
		for _,rune in pairs(rune_spawn_table) do
			if not rune:IsNull() then								
				local item = rune:GetContainedItem()
				UTIL_Remove(item)
				UTIL_Remove(rune)
			end
		end

		-- Clear the table
		rune_spawn_table = {}
	end
end

function PickupRune(rune_name, unit, bActiveByBottle)
	if string.find(rune_name, "item_imba_rune_") then
		rune_name = string.gsub(rune_name, "item_imba_rune_", "")
	end

	local bottle = bActiveByBottle or false
	local store_in_bottle = false
	local duration = GetItemKV("item_imba_rune_"..rune_name, "RuneDuration")

	for i = 0, 5 do
		local item = unit:GetItemInSlot(i)
		if item and not bottle then
			if item:GetAbilityName() == "item_imba_bottle" and not item.RuneStorage then
				item:SetStorageRune(rune_name)
				store_in_bottle = true
				break
			end
		end
	end

	if store_in_bottle == false then
		if rune_name == "bounty" then
			-- Bounty rune parameters
			local base_bounty = 100
			local bounty_per_minute = 4
			local xp_per_minute = 10
			local game_time = GameRules:GetDOTATime(false, false)
			local current_bounty = base_bounty + bounty_per_minute * game_time / 60
			local current_xp = xp_per_minute * game_time / 60

			-- Adjust value for lobby options
			local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
			current_bounty = current_bounty * (1 + custom_gold_bonus * 0.01)

			-- Grant the unit experience
			unit:AddExperience(current_xp, DOTA_ModifyXP_CreepKill, false, true)

			-- If this is alchemist, increase the gold amount
			if unit:FindAbilityByName("imba_alchemist_goblins_greed") and unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetLevel() > 0 then
				current_bounty = current_bounty * (unit:FindAbilityByName("imba_alchemist_goblins_greed"):GetSpecialValueFor("bounty_multiplier") / 100)

				-- #7 Talent: Doubles gold from bounty runes
				if unit:HasTalent("special_bonus_imba_alchemist_7") then
					current_bounty = current_bounty * (unit:FindTalentValue("special_bonus_imba_alchemist_7") / 100)
				end		
			end

			-- #3 Talent: Bounty runes give gold bags
			if unit:HasTalent("special_bonus_imba_alchemist_3") then
				local stacks_to_gold =( unit:FindTalentValue("special_bonus_imba_alchemist_3") / 100 )  / 5
				local gold_per_bag = unit:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount() * stacks_to_gold
				for i=1, 5 do
					-- Drop gold bags
					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( gold_per_bag )
					
					local drop = CreateItemOnPositionSync( unit:GetAbsOrigin(), newItem )
					local dropTarget = unit:GetAbsOrigin() + RandomVector( RandomFloat( 300, 450 ) )
					newItem:LaunchLoot( true, 300, 0.75, dropTarget )
					EmitSoundOn( "Dungeon.TreasureItemDrop", unit )
				end
			end

			-- If this is the first bounty rune spawn, double the base bounty
			if bounty_rune_is_initial_bounty_rune then
				for _, hero in pairs(HeroList:GetAllHeroes()) do
					if hero:GetTeam() == unit:GetTeam() then
						if (hero:GetUnitName() == "npc_dota_hero_monkey_king" and not hero.is_real_mk) or (hero:GetUnitName() == "npc_dota_hero_meepo" and not hero.is_real_meepo) or hero:IsIllusion() then
						else
							hero:ModifyGold(current_bounty, false, DOTA_ModifyGold_Unspecified)
							SendOverheadEventMessage(PlayerResource:GetPlayer(hero:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, hero, current_bounty, nil)
						end
					end
				end
			else
				unit:ModifyGold(current_bounty, false, DOTA_ModifyGold_Unspecified)
				SendOverheadEventMessage(PlayerResource:GetPlayer(unit:GetPlayerOwnerID()), OVERHEAD_ALERT_GOLD, unit, current_bounty, nil)
			end
--			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "General.Coins", unit)
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Bounty", unit)
		elseif rune_name == "arcane" then
			unit:AddNewModifier(unit, item, "modifier_imba_arcane_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Arcane", unit)
		elseif rune_name == "double_damage" then
			unit:AddNewModifier(unit, item, "modifier_imba_double_damage_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.DD", unit)
		elseif rune_name == "haste" then
			unit:AddNewModifier(unit, item, "modifier_imba_haste_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Haste", unit)
		elseif rune_name == "illusion" then
			local images_count = 3
			local vRandomSpawnPos = {
				Vector( 72, 0, 0 ),		-- North
				Vector( 0, 72, 0 ),		-- East
				Vector( -72, 0, 0 ),	-- South
				Vector( 0, -72, 0 ),	-- West
			}

			for i = #vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
				local j = RandomInt( 1, i )
				vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
			end

			table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin() + table.remove( vRandomSpawnPos, 1 ), true)

			for i = 1, images_count do
				local origin = unit:GetAbsOrigin() + table.remove( vRandomSpawnPos, 1 )
				local illusion = IllusionManager:CreateIllusion(unit, self, origin, unit, {damagein=incomingDamage, damageout=outcomingDamage, unique=unit:entindex().."_rune_illusion_"..i, duration=duration})
			end

			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Illusion", unit)
		elseif rune_name == "invisibility" then
			unit:AddNewModifier(unit, nil, "modifier_imba_invisibility_rune_handler", {duration=2.0, rune_duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Invis", unit)
		elseif rune_name == "regeneration" then
			unit:AddNewModifier(unit, nil, "modifier_imba_regen_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Regen", unit)
		elseif rune_name == "frost" then
			unit:AddNewModifier(unit, nil, "modifier_imba_frost_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		elseif rune_name == "ember" then
			unit:AddNewModifier(unit, nil, "modifier_imba_ember_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		elseif rune_name == "stone" then
			unit:AddNewModifier(unit, nil, "modifier_imba_stone_rune", {duration=duration})
			EmitSoundOnLocationForAllies(unit:GetAbsOrigin(), "Rune.Frost", unit)
		end

		CustomGameEventManager:Send_ServerToTeam(unit:GetTeam(), "create_custom_toast", {
			type = "generic",
			text = "#custom_toast_ActivatedRune",
			player = unit:GetPlayerID(),
			runeType = rune_name,
			runeFirst = bounty_rune_is_initial_bounty_rune
		})
	end
end

function CBaseEntity:IsRune()
	local runes = {
		"models/props_gameplay/rune_goldxp.vmdl",
		"models/props_gameplay/rune_haste01.vmdl",
		"models/props_gameplay/rune_doubledamage01.vmdl",
		"models/props_gameplay/rune_regeneration01.vmdl",
		"models/props_gameplay/rune_arcane.vmdl",
		"models/props_gameplay/rune_invisibility01.vmdl",
		"models/props_gameplay/rune_illusion01.vmdl",
		"models/props_gameplay/rune_frost.vmdl",
		"models/props_gameplay/gold_coin001.vmdl",	-- Overthrow coin
	}

	for _, model in pairs(runes) do
		if self:GetModelName() == model then
			return true
		end
	end

	return false
end

-- Overthrow
function PickRandomShuffle( reference_list, bucket )
	if ( #reference_list == 0 ) then
		return nil
	end
	
	if ( #bucket == 0 ) then
		-- ran out of options, refill the bucket from the reference
		for k, v in pairs(reference_list) do
			bucket[k] = v
		end
	end

	-- pick a value from the bucket and remove it
	local pick_index = RandomInt( 1, #bucket )
	local result = bucket[ pick_index ]
	table.remove( bucket, pick_index )
	return result
end

function shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function ShuffledList( orig_list )
	local list = shallowcopy( orig_list )
	local result = {}
	local count = #list
	for i = 1, count do
		local pick = RandomInt( 1, #list )
		result[ #result + 1 ] = list[ pick ]
		table.remove( list, pick )
	end
	return result
end

function TableCount( t )
	local n = 0
	for _ in pairs( t ) do
		n = n + 1
	end
	return n
end

function TableFindKey( table, val )
	if table == nil then
		print( "nil" )
		return nil
	end

	for k, v in pairs( table ) do
		if v == val then
			return k
		end
	end
	return nil
end

function CountdownTimer()
	nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
	local t = nCOUNTDOWNTIMER
	-- print( t )
	local minutes = math.floor(t / 60)
	local seconds = t - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local broadcast_gametimer = 
		{
			timer_minute_10 = m10,
			timer_minute_01 = m01,
			timer_second_10 = s10,
			timer_second_01 = s01,
		}
	CustomGameEventManager:Send_ServerToAllClients( "countdown", broadcast_gametimer )
	if t <= 120 then
		CustomGameEventManager:Send_ServerToAllClients( "time_remaining", broadcast_gametimer )
	end
end

function InitializeTalentsOverride(hero)
	linked_abilities = {}
	local non_talent_abilities = 0
	for i = 0, 16 do
		local ability = hero:GetAbilityByIndex(i)

		if ability then
			if not string.find(ability:GetAbilityName(), "_bonus_") then
				non_talent_abilities = non_talent_abilities +1
			else
--				print(ability, ability:GetAbilityName())
				for k, v in pairs(ability:GetAbilityKeyValues()) do
					if k == "LinkedAbility" then
						for l, m in pairs(v) do
--							print(l, m)
							table.insert(linked_abilities, i - non_talent_abilities + 1, m)
						end
						break
					end
				end
			end
		end
	end

--	print(linked_abilities)
--	PrintTable(linked_abilities)
	CustomGameEventManager:Send_ServerToAllClients("init_talent_window", {linked_abilities})
end

function RestrictAndHideHero(hero)
	if not hero:HasModifier("modifier_command_restricted") then
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		hero:AddEffects(EF_NODRAW)
		hero:SetDayTimeVisionRange(475)
		hero:SetNightTimeVisionRange(475)

		if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), GoodCamera)
--			FindClearSpaceForUnit(hero, GoodCamera:GetAbsOrigin(), false)
		else
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), BadCamera)
--			FindClearSpaceForUnit(hero, BadCamera:GetAbsOrigin(), false)
		end
	end
end

-- not working: team kill tower, courier dead, courier respawn, 
-- hero kill tower says hero denied
function CombatEvents(event_type, reason, victim, attacker)
local text = ""
local team
local atacker_name
local victim_name
local courier = false
local first_blood = false
local glyph = false
local neutral = false
local roshan = false
local suicide = false
local tower = false
local gold = 0
if victim then
	if victim:IsBuilding() then gold = 200 end
	if victim:GetUnitName() == "npc_dota_badguys_healers" then gold = 125 end
end
local attacker_id
local victim_id
local variables

local streak = {}
streak[3] = "Killing spree"
streak[4] = "Dominating"
streak[5] = "Mega kill"
streak[6] = "Unstoppable"
streak[7] = "Wicked sick"
streak[8] = "Monster kill"
streak[9] = "Godlike"
streak[10] = "Beyond Godlike"

	if event_type == "generic" then
		if reason == "courier_respawn" then
			text = "#custom_toast_CourierRespawned"
			team = victim:GetTeam()
			courier = true
		elseif reason == "courier_dead" then
			text = "#custom_toast_CourierKilled"
			team = victim:GetTeam()
			courier = true
		elseif reason == "tower_kill_hero" then
			text = "#custom_toast_TeamKilled"
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
			tower = true
		elseif reason == "tower_dead" then
			text = "#custom_toast_TeamKilled"
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
		elseif reason == "glyph" then
			text = "#custom_toast_GlyphUsed"
			team = victim:GetTeam()
			glyph = true
		end

		CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
			type = "generic",
			text = text,
			teamColor = team,
			team = team,
			victimUnitName = victim_name,
			courier = courier,
			gold = gold,
			tower = tower,
			glyph = glyph,
		})
	elseif event_type == "kill" then
		if reason == "first_blood" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			first_blood = true
			gold = CustomNetTables:GetTableValue("player_table", tostring(attacker_id)).hero_kill_bounty
		elseif reason == "hero_kill" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			gold = CustomNetTables:GetTableValue("player_table", tostring(attacker_id)).hero_kill_bounty
			variables = {
				["{kill_streak}"] = streak[math.min(attacker.killstreak, 10)]
			}
		elseif reason == "hero_kill_tower" then
			attacker_id = attacker:GetPlayerID()
			victim_name = victim:GetUnitName()
			gold = gold
		elseif reason == "roshan_dead" then
			team = attacker:GetTeam()
			victim_name = victim:GetUnitName()
			roshan = true
			gold = 150
		elseif reason == "hero_suicide" then
			victim_name = victim:GetUnitName()
			suicide = true
		elseif reason == "hero_deny_hero" then
			attacker_id = attacker:GetPlayerID()
			victim_id = victim:GetPlayerID()
			victim_name = victim:GetUnitName()
		elseif reason == "neutrals_kill_hero" then
			victim_name = victim:GetUnitName()
			neutral = true
		end

		CustomGameEventManager:Send_ServerToAllClients("create_custom_toast", {
			type = "kill",
			teamColor = team,
			team = team,
			killerPlayer = attacker_id,
			victimPlayer = victim_id,
			victimUnitName = victim_name,
			courier = courier,
			gold = gold,
			tower = tower,
			variables = variables,
			roshan = roshan,
			neutral = neutral,
			suicide = suicide,
		})
	end
end

function HeroVoiceLine(hero, event, extra) -- extra can be victim for kill event, or item purchased for purch event
if not hero:GetKeyValue("ShortName") then return end
local ID = hero:GetPlayerID()
local hero_name = string.gsub(hero:GetUnitName(), "npc_dota_hero_", "")
local short_hero_name = hero:GetKeyValue("ShortName")
local max_line = 2
local voice_line

if event == "blink" or event == "firstblood" then
	max_line = 1
else
	max_line = hero:GetKeyValue(event)
end

local random_int = RandomInt(1, max_line)

if not VOICELINE_IN_CD then
	VOICELINE_IN_CD = {} -- move/cast/attack cd, 
	VOICELINE_IN_CD[ID] = {false, false, false}
end

	-- NOT ADDED YET:
	-- notyet
	-- failure
	-- anger
	-- happy
	-- rare
	-- nomana
	-- RIVAL MEETING SYSTEM
	-- ITEM PURCHASED SYSTEM
	-- FIRST BLOOD SYSTEM (always 2 voicelines)

	-- Later on, finish this to play specific sounds from the ability
--	if event == "cast" then
--		if RandomInt(1, 100) >= 20 then
--			event = hero:GetKeyValue("OnAbility"..ab.."Used")
--			print("play specific ab sound")
--		else
--			print("play global ab sound")
--		end
--	end

	if random_int >= 10 then
		voice_line = hero_name.."_"..short_hero_name.."_"..event.."_"..random_int
--		print(hero_name.."_"..short_hero_name.."_"..event.."_"..random_int)
	else
		voice_line = hero_name.."_"..short_hero_name.."_"..event.."_0"..random_int
--		print(hero_name.."_"..short_hero_name.."_"..event.."_0"..random_int)
	end

	EmitAnnouncerSoundForPlayer(voice_line, ID)

	-- no timer required, play the voicelines everytime
	if event == "blink" or event == "purch" or event == "battlebegins" or event == "win" or event == "lose" or event == "kill" or event == "death" or event == "level_voiceline" or event == "laugh" or event == "thanks" then
		if event == "level_voiceline" then event = string.gsub(event, "_voiceline", "") end
		if event == "purch" and RandomInt(1, 100) <= 50 then return end -- 50% chance to play purchase voice line
	return
	elseif event == "move" or event == "cast" or event == "attack" then
		if event == "cast" and RandomInt(1, 100) <= 50 then return end -- 50% chance to play purchase voice line
--		print("Move/Attack/Cast cd:", VOICELINE_IN_CD[ID][1])
		if VOICELINE_IN_CD[ID][1] == false then

			VOICELINE_IN_CD[ID][1] = true
			Timers:CreateTimer(6.0, function()
				VOICELINE_IN_CD[ID][1] = false
			end)
		end
	return
	elseif event == "lasthit" or event == "deny" then
--		print("Last hit/Deny cd:", VOICELINE_IN_CD[ID][2])
		if VOICELINE_IN_CD[ID][2] == false then
			if event == "deny" then
				-- detect if enemy hero in 1000 radius and visible, if not return end
				return
			end


			VOICELINE_IN_CD[ID][2] = true
			Timers:CreateTimer(60.0, function()
				VOICELINE_IN_CD[ID][2] = false
			end)
		end
	return
	elseif event == "pain" then
		if VOICELINE_IN_CD[ID][3] == false then

			VOICELINE_IN_CD[ID][3] = true
			Timers:CreateTimer(3.0, function()
				VOICELINE_IN_CD[ID][3] = false
			end)
		end
	return
--	elseif event == "notyet" or event == "nomana" then
--		if VOICELINE_IN_CD[ID][4] == false then

			-- make hero play anger voice lines if he click within 10 seconds
--		end
	end
end

GameEvents = GameEvents or {}

function CreateGameEvent(name) --luacheck: ignore CreateGameEvent
	local event = Event()

	GameEvents[name] = (function (self, fn)
		return event.listen(fn)
	end)

	return event.broadcast
end

function CheatDetector()
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
		if Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
			if not IsInToolsMode() then
				print("Cheats have been enabled, game don't count.")
				CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
				CustomGameEventManager:Send_ServerToAllClients("safe_to_leave", {})
				return true
			end
		end
	else
		return false
	end
end

function AntiDevCheat(ID)
	Notifications:BottomToAll({hero = hero:GetName(), duration = 10.0})
	Notifications:BottomToAll({text = PlayerResource:GetPlayerName(ID).." ", duration = 5.0, continue = true})
	Notifications:BottomToAll({text = "is trying to cheat using dev tool! GET HIM!", duration = 5.0, style = {color = "Red"}, continue = true})
end
