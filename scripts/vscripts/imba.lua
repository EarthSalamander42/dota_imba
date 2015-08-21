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

end

-- Multiplies bounty rune experience and gold according to the gamemode multiplier
function GameMode:FilterBountyRunePickup( filter_table )
	filter_table["gold_bounty"] = ( 100 + CREEP_GOLD_BONUS ) / 100 * filter_table["gold_bounty"]
	filter_table["xp_bounty"] = ( 100 + CREEP_XP_BONUS ) / 100 * filter_table["xp_bounty"]
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
		print("attempting to fetch connection status for player"..id)
		self.players[id] = PlayerResource:GetPlayer(id)
		
		if self.players[id] then

			-- Initialize connection state
			self.players[id].connection_state = PlayerResource:GetConnectionState(id)
			print("initialized connection for player "..id..": "..self.players[id].connection_state)

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
	-- IMBA: Bounty Rune xp/gold adjustment
	-------------------------------------------------------------------------------------------------

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(GameMode, "FilterBountyRunePickup"), self )

	-------------------------------------------------------------------------------------------------
	-- IMBA: Selected game mode confirmation messages
	-------------------------------------------------------------------------------------------------
	
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
	local creep_power = "Creeps and structures will gain power "
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

	-- Kills to end the game
	local kills_to_end = ""
	if END_GAME_ON_KILLS then
		kills_to_end = "Game will end when one team reaches <font color='#FF7800'>"..KILLS_TO_END_GAME_FOR_TEAM.."</font> kills, or the Ancient falls."
	end
	
	Say(nil, game_mode..same_hero, false)
	Say(nil, gold_bounty.." gold rate, "..XP_bounty.." experience rate, "..respawn_time..buyback_cost, false)
	Say(nil, start_status, false)
	Say(nil, creep_power..frantic_mode, false)
	Say(nil, kills_to_end, false)

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
			building:AddAbility("ursa_fury_swipes")
			local fountain_ability = building:FindAbilityByName("imba_fountain_buffs")
			local swipes_ability = building:FindAbilityByName("ursa_fury_swipes")
			fountain_ability:SetLevel(1)
			swipes_ability:SetLevel(2)

		end
	end
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

	-- Create kill and death streak globals
	hero.kill_streak_count = 0
	hero.death_streak_count = 0

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

	local line_duration = 4
	
	-- First line
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_01", duration = line_duration, style = {color = "DodgerBlue"}	} )
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_02", duration = line_duration, style = {color = "Orange"}, continue = true}	)
		
	-- Second line
	Timers:CreateTimer(line_duration, function()
		Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_03", duration = line_duration, style = {color = "DodgerBlue"} }	)

		-- Third line
		Timers:CreateTimer(line_duration, function()
			Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_04", duration = line_duration, style = {color = "DodgerBlue"} }	)

			-- Fourth line
			Timers:CreateTimer(line_duration, function()
				Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_05", duration = line_duration, style = {color = "DodgerBlue"} }	)
				Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_06", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"}, continue = true}	)
			end)
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

			-- Add passive buff
			building:AddAbility("imba_tower_buffs")
			local tower_ability = building:FindAbilityByName("imba_tower_buffs")
			tower_ability:SetLevel(1)

		elseif string.find(building_name, "rax_melee") then

			-- Set up base bounties
			min_bounty = MELEE_RAX_MINIMUM_GOLD
			max_bounty = MELEE_RAX_MAXIMUM_GOLD
			xp_bounty = MELEE_RAX_EXPERIENCE

			-- Add passive buff
			building:AddAbility("imba_rax_buffs")
			local rax_ability = building:FindAbilityByName("imba_rax_buffs")
			rax_ability:SetLevel(1)

		elseif string.find(building_name, "rax_range") then

			-- Set up base bounties
			min_bounty = RANGED_RAX_MINIMUM_GOLD
			max_bounty = RANGED_RAX_MAXIMUM_GOLD
			xp_bounty = RANGED_RAX_EXPERIENCE

			-- Add passive buff
			building:AddAbility("imba_rax_buffs")
			local rax_ability = building:FindAbilityByName("imba_rax_buffs")
			rax_ability:SetLevel(1)

		elseif string.find(building_name, "fort") then

			-- Add passive buff
			building:AddAbility("imba_ancient_buffs")
			local ancient_ability = building:FindAbilityByName("imba_ancient_buffs")
			ancient_ability:SetLevel(1)

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