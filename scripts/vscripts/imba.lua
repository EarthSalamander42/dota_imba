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

	-- Assign players to the table
	for id = 0, 9 do
		self.players[id] = PlayerResource:GetPlayer(id)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player connection status check
	-------------------------------------------------------------------------------------------------

	GOODGUYS_CONNECTED_PLAYERS = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	BADGUYS_CONNECTED_PLAYERS = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_BADGUYS)
	print("Good guys connected: "..GOODGUYS_CONNECTED_PLAYERS)
	print("Bad guys connected: "..BADGUYS_CONNECTED_PLAYERS)

	-- Creates global variables which track player connection status
	IMBA_STARTED_TRACKING_CONNECTIONS = true
	for id = 0, 9 do
		if self.players[id] then
			self.players[id].connection_state = PlayerResource:GetConnectionState(id)
		end
	end

	-- debug
	for id = 0, 9 do
		if self.players[id] then
			print("Player "..id.." has connection state "..self.players[id].connection_state)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG pick setup
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then
		GameRules:SetHeroSelectionTime( IMBA_RANDOM_OMG_HERO_SELECTION_TIME )
		for id = 0, 9 do
			if self.players[id] then
				PlayerResource:GetPlayer(id):MakeRandomHeroSelection()
			end
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

	if player and self.players[player:GetPlayerID()] and not self.heroes[player:GetPlayerID()] then
		self.heroes[player:GetPlayerID()] = hero
		print("Assigned hero "..hero:GetName().." to player "..player:GetPlayerID())
	elseif player and self.players[player:GetPlayerID()] and self.heroes[player:GetPlayerID()] and ( self.heroes[player:GetPlayerID()]:GetName() ~= hero:GetName() ) then
		self.heroes[player:GetPlayerID()] = hero
		print("Reassigned hero "..hero:GetName().." to player "..player:GetPlayerID())
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

	-- Set up initial gold
	local has_randomed = PlayerResource:HasRandomed(hero:GetPlayerID())

	if has_repicked then
		hero:SetGold(HERO_INITIAL_REPICK_GOLD, false)
	elseif has_randomed then
		hero:SetGold(HERO_INITIAL_RANDOM_GOLD, false)
	else
		hero:SetGold(HERO_INITIAL_GOLD, false)
	end

	-- Set up initial hero kill bounty
	local hero_bounty = HERO_KILL_GOLD_BASE + HERO_KILL_GOLD_PER_LEVEL

	-- Multiply bounty by the lobby options
	hero_bounty = hero_bounty * ( 100 + HERO_BOUNTY_BONUS ) / 100

	-- Update the hero's bounty
	hero:SetMinimumGoldBounty(hero_bounty)
	hero:SetMaximumGoldBounty(hero_bounty)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player greeting and explanations
	-------------------------------------------------------------------------------------------------

	local line_duration = 4
	
	-- First line
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_01", duration = line_duration, style = {["font-size"] = "30px", color = "DodgerBlue"}	} )
	Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_02", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"}, continue = true}	)
		
	-- Second line
	Timers:CreateTimer(line_duration, function()
		--Notifications:ClearBottom(hero:GetPlayerID())
		Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_03", duration = line_duration, style = {["font-size"] = "30px", color = "DodgerBlue"} }	)

		-- Third line
		Timers:CreateTimer(line_duration, function()
			--Notifications:ClearBottom(hero:GetPlayerID())
			Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_04", duration = line_duration, style = {["font-size"] = "30px", color = "DodgerBlue"} }	)

			-- Fourth line
			Timers:CreateTimer(line_duration, function()
				--Notifications:ClearBottom(hero:GetPlayerID())
				Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_05", duration = line_duration, style = {["font-size"] = "30px", color = "DodgerBlue"} }	)
				Notifications:Bottom(hero:GetPlayerID(), {text = "#imba_introduction_line_06", duration = line_duration, style = {["font-size"] = "36px", color = "Orange"}, continue = true}	)
			end)
		end)
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG ability setup
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then
		
		-- Remove default abilities
		for i = 0, 11 do
			local old_ability = hero:GetAbilityByIndex(i)
			if old_ability then
				hero:RemoveAbility(old_ability:GetAbilityName())
			end
		end

		-- Add new regular abilities
		for i = 1, IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT do
			local randomed_ability
			local ability_owner
			randomed_ability, ability_owner = GetRandomNormalAbility()

			if not hero:FindAbilityByName(randomed_ability) then
				hero:AddAbility(randomed_ability)
			end

			PrecacheUnitByNameAsync(ability_owner, function(...) end)
		end

		-- Add new ultimate abilities
		for i = 1, IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT do
			local randomed_ultimate
			local ultimate_owner
			randomed_ultimate, ultimate_owner = GetRandomUltimateAbility()

			if not hero:FindAbilityByName(randomed_ultimate) then
				hero:AddAbility(randomed_ultimate)
			end

			PrecacheUnitByNameAsync(ultimate_owner, function(...) end)
		end

		-- Re-add attribute bonus
		if hero:GetPrimaryAttribute() == 0 then
			hero:AddAbility("attribute_bonus_str")
		elseif hero:GetPrimaryAttribute() == 1 then
			hero:AddAbility("attribute_bonus_agi")
		elseif hero:GetPrimaryAttribute() == 2 then
			hero:AddAbility("attribute_bonus_int")
		end

		-- Apply ability layout modifier
		local layout_ability_name
		if IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 4 then
			layout_ability_name = "random_omg_ability_layout_changer_4"
		elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 5 then
			layout_ability_name = "random_omg_ability_layout_changer_5"
		elseif IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT + IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT == 6 then
			layout_ability_name = "random_omg_ability_layout_changer_6"
		end

		hero:AddAbility(layout_ability_name)
		local layout_ability = hero:FindAbilityByName(layout_ability_name)
		layout_ability:SetLevel(1)
	end
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
	DebugPrint("[IMBA] The game has officially begun")

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