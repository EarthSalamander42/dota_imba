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

	IMBA_STARTED_TRACKING_CONNECTIONS = true

	GOODGUYS_CONNECTED_PLAYERS = 0
	BADGUYS_CONNECTED_PLAYERS = 0

	-- Assign players to the table
	for id = 0, 9 do
		Timers:CreateTimer(0, function()
			self.players[id] = PlayerResource:GetPlayer(id)
			
			if self.players[id] then

				-- Initialize connection state
				self.players[id].connection_state = PlayerResource:GetConnectionState(id)

				-- Increment amount of players on this team by one
				if PlayerResource:GetTeam(id) == DOTA_TEAM_GOODGUYS then
					GOODGUYS_CONNECTED_PLAYERS = GOODGUYS_CONNECTED_PLAYERS + 1
				elseif PlayerResource:GetTeam(id) == DOTA_TEAM_BADGUYS then
					BADGUYS_CONNECTED_PLAYERS = BADGUYS_CONNECTED_PLAYERS + 1
				end
			else

				-- If the player never connected, assign it a special string
				if PlayerResource:GetConnectionState(id) == 1 then
					self.players[id] = "empty_player_slot"

				-- If not, keep trying
				else
					return 0.5
				end
			end
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Random OMG setup
	-------------------------------------------------------------------------------------------------

	if IMBA_ABILITY_MODE_RANDOM_OMG then

		-- Pick setup
		for id = 0, 9 do
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

		-- Illusion skill adjustment
		Timers:CreateTimer(0, function()
			local illusions_on_world = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,illusion in pairs(illusions_on_world) do

				-- Check if this illusion has already been adjusted
				if illusion:IsIllusion() and not illusion.illusion_skills_adjusted then
					local player_id = illusion:GetPlayerID()
					local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()

					-- Remove previously existing abilities
					for i = 0, 15 do
						local old_ability = illusion:GetAbilityByIndex(i)
						if old_ability then
							illusion:RemoveAbility(old_ability:GetAbilityName())
						end
					end

					-- Add and level owner's abilities
					for i = 0, 15 do
						if hero.random_omg_abilities[i] then
							illusion:AddAbility(hero.random_omg_abilities[i])
							local ability = illusion:FindAbilityByName(hero.random_omg_abilities[i])
							local ability_level = hero:FindAbilityByName(hero.random_omg_abilities[i]):GetLevel()
							ability:SetLevel(ability_level)
						end
					end

					-- Mark this illusion as already adjusted
					illusion.illusion_skills_adjusted = true
				end
			end
			return 0.1
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: All Random setup
	-------------------------------------------------------------------------------------------------

	if IMBA_PICK_MODE_ALL_RANDOM then

		-- Pick setup
		for id = 0, 9 do
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

	-- Kills to end the game
	local kills_to_end = ""
	if END_GAME_ON_KILLS then
		kills_to_end = "Game will end when one team reaches <font color='#FF7800'>"..KILLS_TO_END_GAME_FOR_TEAM.."</font> kills, or the Ancient falls."
	end

	-- Level cap
	local level_cap = ""
	if USE_CUSTOM_HERO_LEVELS then
		level_cap = " Heroes can progress up to level <font color='#FF7800'>"..MAX_LEVEL.."</font>."
	end
	
	Say(nil, game_mode..same_hero, false)
	Say(nil, gold_bounty.." gold rate, "..XP_bounty.." experience rate, "..respawn_time..buyback_cost, false)
	Say(nil, kills_to_end..level_cap, false)
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