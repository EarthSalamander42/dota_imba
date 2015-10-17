-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output

BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
	DebugPrint( '[IMBA] creating game mode' )
	_G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

-- storage API
require('libraries/json')
require('libraries/storage')

Storage:SetApiKey("35c56d290cbd168b6a58aabc43c87aff8d6b39cb")

--[[
	This function should be used to set up Async precache calls at the beginning of the gameplay.

	In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
	after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
	be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
	precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
	defined on the unit.

	This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
	time, you can call the functions individually (for example if you want to precache units in a new wave of
	holdout).

	This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
	DebugPrint("[IMBA] Performing Post-Load precache")    
	--PrecacheItemByNameAsync("item_example_item", function(...) end)
	--PrecacheItemByNameAsync("example_ability", function(...) end)

	--PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
	--PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
	DebugPrint("[IMBA] First Player has loaded")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Roshan initialization
	-------------------------------------------------------------------------------------------------

	local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
	local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Contributor models
	-------------------------------------------------------------------------------------------------

	local radiant_spawn = Vector(6820, -6028, 408)
	local dire_spawn = Vector(-5930, 6916, 278)
	local spawn_radius = 400
	local radiant_count = 3
	--local direction = RandomVector(1)
	local radiant_spawns = {}
	for i = 1,radiant_count do
		radiant_spawns[i] = radiant_spawn + RandomVector(1) * spawn_radius * (i - 1) / (radiant_count - 1)
	end

	-- Martyn Garcia
	local martyn_model = CreateUnitByName("npc_imba_contributor_martyn", radiant_spawns[1], true, nil, nil, DOTA_TEAM_NEUTRALS)
	martyn_model:SetForwardVector(RandomVector(100))

	-- Mikkel Garcia
	local mikkel_model = CreateUnitByName("npc_imba_contributor_mikkel", radiant_spawns[2], true, nil, nil, DOTA_TEAM_NEUTRALS)
	mikkel_model:SetForwardVector(RandomVector(100))

	-- Hjort
	local hjort_model = CreateUnitByName("npc_imba_contributor_hjort", radiant_spawns[3], true, nil, nil, DOTA_TEAM_NEUTRALS)
	hjort_model:SetForwardVector(RandomVector(100))

end

-- Multiplies bounty rune experience and gold according to the gamemode multiplier
function GameMode:BountyRuneFilter( keys )

	--player_id_const	 ==> 	0
	--xp_bounty	 ==> 	136.5
	--gold_bounty	 ==> 	132.6

	keys["gold_bounty"] = ( 100 + CREEP_GOLD_BONUS ) / 100 * keys["gold_bounty"]
	keys["xp_bounty"] = ( 100 + CREEP_XP_BONUS ) / 100 * keys["xp_bounty"]

	return true
end

-- Order filter function
function GameMode:OrderFilter( keys )

	--entindex_ability	 ==> 	0
	--sequence_number_const	 ==> 	20
	--queue	 ==> 	0
	--units	 ==> 	table: 0x031d5fd0
	--entindex_target	 ==> 	0
	--position_z	 ==> 	384
	--position_x	 ==> 	-5694.3334960938
	--order_type	 ==> 	1
	--position_y	 ==> 	-6381.1127929688
	--issuer_player_id_const	 ==> 	0

	--local units = keys["units"]
	--local unit = EntIndexToHScript(units["0"])

	return true
end

-- Damage filter function
function GameMode:DamageFilter( keys )

	--damagetype_const
	--damage
	--entindex_attacker_const
	--entindex_victim_const

	local attacker = EntIndexToHScript(keys.entindex_attacker_const)
	local victim = EntIndexToHScript(keys.entindex_victim_const)
	local damage_type = keys.damagetype_const
	local display_red_crit_number = false

	-- Lack of entities handling
	if not attacker or not victim then
		return true
	end

	-- Orchid crit
	if attacker:HasModifier("modifier_item_imba_orchid_unique") and (damage_type == DAMAGE_TYPE_MAGICAL or damage_type == DAMAGE_TYPE_PURE) then
		
		-- Fetch the Orchid's ability handle
		local ability
		for i = 0,5 do
			local this_item = attacker:GetItemInSlot(i)
			if this_item and this_item:GetName() == "item_imba_orchid" then
				ability = this_item
			end
		end

		local ability_level = ability:GetLevel() - 1

		-- Parameters
		local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
		local crit_damage = ability:GetLevelSpecialValueFor("crit_damage", ability_level)
		local distance_taper_start = ability:GetLevelSpecialValueFor("distance_taper_start", ability_level)
		local distance_taper_end = ability:GetLevelSpecialValueFor("distance_taper_end", ability_level)

		-- Check for a valid target
		if not (victim:IsBuilding() or victim:IsTower() or victim == attacker) then

			-- Scale damage bonus according to distance
			local distance = ( victim:GetAbsOrigin() - attacker:GetAbsOrigin() ):Length2D()
			local distance_taper = 1
			if distance > distance_taper_start and distance < distance_taper_end then
				distance_taper = distance_taper * ( 0.3 + ( distance_taper_end - distance ) / ( distance_taper_end - distance_taper_start ) * 0.7 )
			elseif distance >= distance_taper_end then
				distance_taper = 0.3
			end

			-- Roll for crit chance
			if RandomInt(1, 100) <= crit_chance then
				print("hp before damage: "..victim:GetHealth())
				Timers:CreateTimer(0.01, function()
					print("hp after damage: "..victim:GetHealth())
				end)
				keys.damage = keys.damage * (100 + (crit_damage - 100) * distance_taper) / 100
				display_red_crit_number = true
			end
		end
	end

	-- Backtrack dodge
	if victim:HasModifier("modifier_imba_backtrack") and not victim:HasModifier("modifier_imba_backtrack_cooldown") then

		-- Fetch backtrack's ability handle
		local ability
		for i = 0,15 do
			local this_ability = victim:GetAbilityByIndex(i)
			if this_ability and this_ability:GetName() == "imba_faceless_void_backtrack" then
				ability = this_ability
			end
		end

		local ability_level = ability:GetLevel() - 1

		-- Parameters
		local dodge_chance = ability:GetLevelSpecialValueFor("passive_dodge", ability_level)
		
		-- If backtrack is active, increase dodge chance
		if victim:HasModifier("modifier_imba_backtrack_active") then
			dodge_chance = ability:GetLevelSpecialValueFor("active_dodge", ability_level)
		end

		-- Roll for dodge chance
		if RandomInt(1, 100) <= dodge_chance then

			-- Nullify damage
			keys.damage = 0

			-- Play backtrack particle
			local backtrack_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, victim)
			ParticleManager:SetParticleControl(backtrack_pfx, 0, victim:GetAbsOrigin())

			-- Prevent crit damage notifications
			display_red_crit_number = false
		end
	end

	-- Damage overhead display
	if display_red_crit_number then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)		
	end

	return true
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]

function GameMode:OnAllPlayersLoaded()
	DebugPrint("[IMBA] All Players have loaded into the game")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player globals initialization
	-------------------------------------------------------------------------------------------------

	self.players = {}
	self.heroes = {}

	IMBA_STARTED_TRACKING_CONNECTIONS = true

	GOODGUYS_CONNECTED_PLAYERS = 0
	BADGUYS_CONNECTED_PLAYERS = 0

	-- Assign players to the table
	for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
		self.players[id] = PlayerResource:GetPlayer(id)
		
		if self.players[id] then

			-- Initialize connection state
			self.players[id].connection_state = PlayerResource:GetConnectionState(id)
			print("initialized connection for player "..id..": "..self.players[id].connection_state)

			-- Assign appropriate player color
			if IMBA_PLAYERS_ON_GAME == 10 and id > 4 then
				PlayerResource:SetCustomPlayerColor(id+5, PLAYER_COLORS[id+5][1], PLAYER_COLORS[id+5][2], PLAYER_COLORS[id+5][3])
			else
				PlayerResource:SetCustomPlayerColor(id, PLAYER_COLORS[id][1], PLAYER_COLORS[id][2], PLAYER_COLORS[id][3])
			end

			-- Increment amount of players on this team by one
			if PlayerResource:GetTeam(id) == DOTA_TEAM_GOODGUYS then
				GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS + 1
				print("goodguys team now has "..GOODGUYS_CONNECTED_PLAYERS.." players")
			elseif PlayerResource:GetTeam(id) == DOTA_TEAM_BADGUYS then
				BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS + 1
				print("badguys team now has "..BADGUYS_CONNECTED_PLAYERS.." players")
			end
		else

			-- If the player never connected, assign it a special string
			if PlayerResource:GetConnectionState(id) == 1 then
				self.players[id] = "empty_player_slot"
				print("player "..id.." never connected")
			end

		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG setup
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Pick setup
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			Timers:CreateTimer(0, function()
				--print("attempting to random a hero for player "..id)
				if self.players[id] and self.players[id] ~= "empty_player_slot" then
					PlayerResource:GetPlayer(id):MakeRandomHeroSelection()
					PlayerResource:SetHasRepicked(id)
					PlayerResource:SetHasRandomed(id)
					--print("succesfully randomed a hero for player "..id)
				elseif not self.players[id] then
					--print("player "..id.." still hasn't randomed a hero")
					return 0.5
				end
			end)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: All Random setup
	-------------------------------------------------------------------------------------------------

	if IMBA_PICK_MODE_ALL_RANDOM then

		-- Pick setup
		for id = 0, ( IMBA_PLAYERS_ON_GAME - 1 ) do
			Timers:CreateTimer(0, function()
				if self.players[id] and self.players[id] ~= "empty_player_slot" then
					PlayerResource:GetPlayer(id):MakeRandomHeroSelection()
					PlayerResource:SetHasRepicked(id)
					PlayerResource:SetHasRandomed(id)
				elseif not self.players[id] then
					return 0.5
				end
			end)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Filter setup
	-------------------------------------------------------------------------------------------------

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(GameMode, "BountyRuneFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )

	-------------------------------------------------------------------------------------------------
	-- IMBA: Fountain abilities setup
	-------------------------------------------------------------------------------------------------

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	-- Iterate through each one
	for _, building in pairs(buildings) do
		
		-- Parameters
		local building_name = building:GetName()

		-- Identify the fountains
		if string.find(building_name, "fountain") then

			-- Add fountain passive abilities
			building:AddAbility("imba_fountain_buffs")
			building:AddAbility("imba_tower_grievous_wounds")
			local fountain_ability = building:FindAbilityByName("imba_fountain_buffs")
			local swipes_ability = building:FindAbilityByName("imba_tower_grievous_wounds")
			fountain_ability:SetLevel(1)
			swipes_ability:SetLevel(1)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Selected game mode confirmation messages
	-------------------------------------------------------------------------------------------------

	-- Delay the message a bit so it shows up during hero picks
	Timers:CreateTimer(3, function()

		-- If no options were chosen, use the default ones
		if not GAME_OPTIONS_SET then
			Say(nil, "Host did not select any game options, using the default ones.", false)
		end

		-- Game mode
		local game_mode = "<font color='#FF7800'>ALL PICK</font>"
		if IMBA_PICK_MODE_ALL_RANDOM then
			game_mode = "<font color='#FF7800'>ALL RANDOM</font>"
		elseif IMBA_ABILITY_MODE_RANDOM_OMG then
			game_mode = "<font color='#FF7800'>RANDOM OMG</font>, <font color='#FF7800'>"..IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT.."</font> abilities, <font color='#FF7800'>"..IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT.."</font> ultimates"
			if IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
				game_mode = game_mode..", skills are randomed on every respawn"
			end
		end

		-- Same hero
		local same_hero = ""
		if ALLOW_SAME_HERO_SELECTION then
			same_hero = ", same hero allowed"
		end

		-- Bounties
		local gold_bounty = 100 + CREEP_GOLD_BONUS
		gold_bounty = "<font color='#FF7800'>"..gold_bounty.."%</font>"
		local XP_bounty = 100 + CREEP_XP_BONUS
		XP_bounty = "<font color='#FF7800'>"..XP_bounty.."%</font>"

		-- Respawn
		local respawn_time = HERO_RESPAWN_TIME_MULTIPLIER
		if respawn_time == 100 then
			respawn_time = "<font color='#FF7800'>normal</font> respawn time, "
		elseif respawn_time == 50 then
			respawn_time = "<font color='#FF7800'>half</font> respawn time, "
		elseif respawn_time == 0 then
			respawn_time = "<font color='#FF7800'>zero</font> respawn time, "
		end

		-- Buyback
		local buyback_cost = HERO_BUYBACK_COST_MULTIPLIER
		if buyback_cost == 100 then
			buyback_cost = "<font color='#FF7800'>normal</font> buyback cost."
		elseif buyback_cost == 200 then
			buyback_cost = "<font color='#FF7800'>double</font> buyback cost."
		elseif buyback_cost == 99999 then
			buyback_cost = "<font color='#FF7800'>no buyback</font>."
		end

		-- Starting gold & level
		local start_status = "Heroes will start with <font color='#FF7800'>"..HERO_INITIAL_GOLD.."</font> gold, at level <font color='#FF7800'>"..HERO_STARTING_LEVEL.."</font>, and can progress up to level <font color='#FF7800'>"..MAX_LEVEL.."</font>."

		-- Creep power ramp
		local creep_power = "Creeps and summons' damage will increase "
		if CREEP_POWER_RAMP_UP_FACTOR == 1 then
			creep_power = creep_power.."at <font color='#FF7800'>normal</font> speed."
		elseif CREEP_POWER_RAMP_UP_FACTOR == 2 then
			creep_power = creep_power.."<font color='#FF7800'>quicker</font> than normal."
		elseif CREEP_POWER_RAMP_UP_FACTOR == 4 then
			creep_power = creep_power.."at <font color='#FF7800'>extreme</font> speed."
		end

		-- Frantic mode
		local frantic_mode = ""
		if FRANTIC_MULTIPLIER > 1 then
			frantic_mode = " <font color='#FF7800'>Frantic mode</font> is activated - cooldowns and mana costs decreased by <font color='#FF7800'>"..FRANTIC_MULTIPLIER.."x</font>."
		end

		-- Tower abilities
		local tower_abilities = ""
		if TOWER_ABILITY_MODE then
			if TOWER_UPGRADE_MODE then
				tower_abilities = "Towers will gain <font color='#FF7800'>upgradable random abilities</font>."
			else
				tower_abilities = "Towers will gain <font color='#FF7800'>random abilities</font>, with abilities being mirrored for both teams."
			end
		end

		-- Kills to end the game
		local kills_to_end = ""
		if END_GAME_ON_KILLS then
			kills_to_end = "<font color='#FF7800'>ARENA MODE:</font> Game will only end when one team reaches <font color='#FF7800'>"..KILLS_TO_END_GAME_FOR_TEAM.."</font> kills."
		end
		
		Say(nil, game_mode..same_hero, false)
		Say(nil, gold_bounty.." gold rate, "..XP_bounty.." experience rate, "..respawn_time..buyback_cost, false)
		Say(nil, start_status, false)
		Say(nil, creep_power..frantic_mode, false)
		Say(nil, tower_abilities, false)
		Say(nil, kills_to_end, false)
	end)
end

--[[
	This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
	if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
	levels, changing the starting gold, removing/adding abilities, adding physics, etc.

	The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
	DebugPrint("[IMBA] Hero spawned in game for first time -- " .. hero:GetUnitName())

	-------------------------------------------------------------------------------------------------
	-- IMBA: First hero spawn initialization
	-------------------------------------------------------------------------------------------------

	-- Update the player's hero if it was picked or changed
	local player = PlayerResource:GetPlayer(hero:GetPlayerID())

	if player and self.players[player:GetPlayerID()] and self.players[player:GetPlayerID()] ~= "empty_player_slot" and not self.heroes[player:GetPlayerID()] then
		self.heroes[player:GetPlayerID()] = hero
	elseif player and self.players[player:GetPlayerID()] and self.players[player:GetPlayerID()] ~= "empty_player_slot" and self.heroes[player:GetPlayerID()] and ( self.heroes[player:GetPlayerID()]:GetName() ~= hero:GetName() ) then
		self.heroes[player:GetPlayerID()] = hero
	end

	-- Check if this function was already performed
	if not player then
		return nil
	elseif player.already_spawned then
		return nil
	end

	--If not, flag it as being done
	player.already_spawned = true

	-- Create kill and death streak and buyback globals
	hero.kill_streak_count = 0
	hero.death_streak_count = 0
	hero.buyback_count = 0

	-- Add frantic mode passive buff
	if FRANTIC_MULTIPLIER > 1 then
		hero:AddAbility("imba_frantic_buff")
		ability_frantic = hero:FindAbilityByName("imba_frantic_buff")
		ability_frantic:SetLevel(1)
	end

	-- Set up initial level
	if HERO_STARTING_LEVEL > 1 then
		Timers:CreateTimer(1, function()
			hero:AddExperience(XP_PER_LEVEL_TABLE[HERO_STARTING_LEVEL], DOTA_ModifyXP_CreepKill, false, true)
		end)
	end

	-- Set up initial gold
	local has_randomed = PlayerResource:HasRandomed(hero:GetPlayerID())
	local has_repicked = PlayerResource:HasRepicked(hero:GetPlayerID())

	if has_repicked then
		hero:SetGold(HERO_INITIAL_REPICK_GOLD, false)
	elseif has_randomed then
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)
	else
		hero:SetGold(HERO_INITIAL_GOLD, false)
	end

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Set initial gold for the mode 
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)

		-- Randomize abilities
		ApplyAllRandomOmgAbilities(hero)
	end

	if IMBA_PICK_MODE_ALL_RANDOM then

		-- Set initial gold for the mode 
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)
	end

	-- Set up initial hero kill gold bounty
	local gold_bounty = HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL

	-- Multiply bounty by the lobby options
	gold_bounty = gold_bounty * ( 100 + HERO_GOLD_BONUS ) / 100

	-- Update the hero's bounty
	hero:SetMinimumGoldBounty(gold_bounty)
	hero:SetMaximumGoldBounty(gold_bounty)

	-- Set up initial hero kill XP bounty
	local xp_bounty = HERO_KILL_XP_CONSTANT_1

	-- Multiply bounty by the lobby options
	xp_bounty = xp_bounty * ( 100 + HERO_XP_BONUS ) / 100
	hero:SetDeathXP(xp_bounty)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player greeting and explanations
	-------------------------------------------------------------------------------------------------

	local line_duration = 5
	
	-- First line
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_01", duration = line_duration, style = {color = "DodgerBlue"}	} )
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_02", duration = line_duration, style = {color = "Orange"}, continue = true}	)
		
	-- Second line
	Timers:CreateTimer(line_duration, function()
		Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_03", duration = line_duration, style = {color = "DodgerBlue"} }	)

		-- Third line
		Timers:CreateTimer(line_duration, function()
			Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_04", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"} }	)
		end)
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Initialize innate hero abilities
	-------------------------------------------------------------------------------------------------

	InitializeInnateAbilities(hero)

end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	DebugPrint("[IMBA] The game has officially begun")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game time tracker
	-------------------------------------------------------------------------------------------------
	
	Timers:CreateTimer(5, function()
		GAME_TIME_ELAPSED = GAME_TIME_ELAPSED + 5
		return 5
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Structure bounty/stats setup
	-------------------------------------------------------------------------------------------------

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	-- Iterate through each one
	for _, building in pairs(buildings) do
		
		-- Parameters
		local building_name = building:GetName()
		local special_building = true
		local max_bounty = building:GetMaximumGoldBounty()
		local min_bounty = building:GetMinimumGoldBounty()
		local xp_bounty = building:GetDeathXP()

		-- Identify the building type
		if string.find(building_name, "tower") then

			-- Set up base bounties
			min_bounty = TOWER_MINIMUM_GOLD
			max_bounty = TOWER_MAXIMUM_GOLD
			xp_bounty = TOWER_EXPERIENCE

		elseif string.find(building_name, "rax_melee") then

			-- Set up base bounties
			min_bounty = MELEE_RAX_MINIMUM_GOLD
			max_bounty = MELEE_RAX_MAXIMUM_GOLD
			xp_bounty = MELEE_RAX_EXPERIENCE

		elseif string.find(building_name, "rax_range") then

			-- Set up base bounties
			min_bounty = RANGED_RAX_MINIMUM_GOLD
			max_bounty = RANGED_RAX_MAXIMUM_GOLD
			xp_bounty = RANGED_RAX_EXPERIENCE

		elseif string.find(building_name, "fort") then

			-- Add passive buff
			building:AddAbility("imba_ancient_buffs")
			local ancient_ability = building:FindAbilityByName("imba_ancient_buffs")
			ancient_ability:SetLevel(1)

			if TOWER_ABILITY_MODE then

				-- Add Poison Nova ability
				building:AddAbility("venomancer_poison_nova")
				ancient_ability = building:FindAbilityByName("venomancer_poison_nova")
				ancient_ability:SetLevel(1)

				-- Add Overgrowth ability
				building:AddAbility("treant_overgrowth")
				ancient_ability = building:FindAbilityByName("treant_overgrowth")
				ancient_ability:SetLevel(1)

				-- Add Eye of the Storm ability
				building:AddAbility("razor_eye_of_the_storm")
				ancient_ability = building:FindAbilityByName("razor_eye_of_the_storm")
				ancient_ability:SetLevel(1)

				-- Add Borrowed Time ability
				building:AddAbility("abaddon_borrowed_time")
				ancient_ability = building:FindAbilityByName("abaddon_borrowed_time")
				ancient_ability:SetLevel(1)

				-- Add Ravage ability
				building:AddAbility("tidehunter_ravage")
				ancient_ability = building:FindAbilityByName("tidehunter_ravage")
				ancient_ability:SetLevel(1)
			end

		elseif string.find(building_name, "fountain") then
			-- Do nothing (fountain was already modified previously)
		else

			-- Flag this building as non-tower, non-rax
			special_building = false
		end
		
		-- Update XP bounties
		building:SetDeathXP( math.floor( xp_bounty * ( 1 + CREEP_XP_BONUS / 100 ) ) )

		-- Update gold bounties
		if special_building then
			building:SetMaximumGoldBounty( math.floor( max_bounty * CREEP_GOLD_BONUS / 100 ) )
			building:SetMinimumGoldBounty( math.floor( min_bounty * CREEP_GOLD_BONUS / 100 ) )
		else
			building:SetMaximumGoldBounty( math.floor( max_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )
			building:SetMinimumGoldBounty( math.floor( min_bounty * ( 1 + CREEP_GOLD_BONUS / 100 ) ) )
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Tower abilities setup
	-------------------------------------------------------------------------------------------------

	if TOWER_ABILITY_MODE then
		
		-- Safelane towers
		for i = 1, 3 do
			
			-- Find safelane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_safe_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_safe_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Mid towers
		for i = 1, 3 do
			
			-- Find mid towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_mid_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_mid_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Hardlane towers
		for i = 1, 3 do
			
			-- Find hardlane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_hard_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_hard_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Store the towers' tier
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i

			-- Random an ability from the list
			local ability_name = GetRandomTowerAbility(i)

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Tier 4s
		local radiant_left_t4_loc = Entities:FindByName(nil, "radiant_left_tower_t4"):GetAbsOrigin()
		local radiant_right_t4_loc = Entities:FindByName(nil, "radiant_right_tower_t4"):GetAbsOrigin()
		local dire_left_t4_loc = Entities:FindByName(nil, "dire_left_tower_t4"):GetAbsOrigin()
		local dire_right_t4_loc = Entities:FindByName(nil, "dire_right_tower_t4"):GetAbsOrigin()
		local radiant_left_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local radiant_right_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_left_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_right_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		radiant_left_t4 = radiant_left_t4[1]
		radiant_right_t4 = radiant_right_t4[1]
		dire_left_t4 = dire_left_t4[1]
		dire_right_t4 = dire_right_t4[1]

		-- Store the towers' tier
		radiant_left_t4.tower_tier = 4
		radiant_right_t4.tower_tier = 4
		dire_left_t4.tower_tier = 4
		dire_right_t4.tower_tier = 4

		-- Add and level up the multishot ability
		local multishot_ability = "imba_tower_multishot"
		radiant_left_t4:AddAbility(multishot_ability)
		dire_left_t4:AddAbility(multishot_ability)
		radiant_right_t4:AddAbility(multishot_ability)
		dire_right_t4:AddAbility(multishot_ability)
		local radiant_left_ability = radiant_left_t4:FindAbilityByName(multishot_ability)
		local dire_left_ability = dire_left_t4:FindAbilityByName(multishot_ability)
		local radiant_right_ability = radiant_right_t4:FindAbilityByName(multishot_ability)
		local dire_right_ability = dire_right_t4:FindAbilityByName(multishot_ability)
		radiant_left_ability:SetLevel(1)
		dire_left_ability:SetLevel(1)
		radiant_right_ability:SetLevel(1)
		dire_right_ability:SetLevel(1)
	end

end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	DebugPrint('[IMBA] Started loading Dota IMBA...')

	-- Call the internal function to set up the rules/behaviors specified in constants.lua
	-- This also sets up event hooks for all event handlers in events.lua
	-- Check out internals/gamemode to see/modify the exact code
	GameMode:_InitGameMode()

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

	DebugPrint('[IMBA] Finished loading Dota IMBA!\n\n')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end

	print( '*********************************************' )
end