-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

function GameMode:_InitGameMode()

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetShowcaseTime( SHOWCASE_TIME )
	GameRules:SetStrategyTime( STRATEGY_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_NONSTANDARD_HERO_XP_BOUNTY )
	GameRules:SetGoldPerTick( GOLD_PER_TICK )
	GameRules:SetGoldTickTime( GOLD_TICK_TIME )
	GameRules:SetRuneSpawnTime( RUNE_SPAWN_TIME )
	GameRules:SetUseBaseGoldBountyOnHeroes( USE_NONSTANDARD_HERO_GOLD_BOUNTY )
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	GameRules:EnableCustomGameSetupAutoLaunch( START_GAME_AUTOMATICALLY )
	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
	GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
	GameRules:SetStartingGold( MAP_INITIAL_GOLD )

	-- Register a listener for the game mode configuration
	CustomGameEventManager:RegisterListener("set_game_mode", OnSetGameMode)

	-- This is multiteam configuration stuff
	local count = 0
	for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
		if count >= MAX_NUMBER_OF_TEAMS then
			GameRules:SetCustomGameTeamMaxPlayers(team, 0)
		else
			GameRules:SetCustomGameTeamMaxPlayers(team, number)
		end
		count = count + 1
	end

	if USE_CUSTOM_TEAM_COLORS then
		for team,color in pairs(TEAM_COLORS) do
			SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
		end
	end

	--InitLogFile( "log/barebones.txt","")

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
	ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
	ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
	ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
	ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

	ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'OnIllusionsCreated'), self)
	ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'OnItemCombined'), self)
	ListenToGameEvent("dota_player_begin_cast", Dynamic_Wrap(GameMode, 'OnAbilityCastBegins'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
	ListenToGameEvent("dota_player_selected_custom_team", Dynamic_Wrap(GameMode, 'OnPlayerSelectedCustomTeam'), self)
	ListenToGameEvent("dota_npc_goal_reached", Dynamic_Wrap(GameMode, 'OnNPCGoalReached'), self)
	
	--ListenToGameEvent("dota_tutorial_shop_toggled", Dynamic_Wrap(GameMode, 'OnShopToggled'), self)

	--ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
	--ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
	--ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
	--ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
	--ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
	--ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
	--ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
	--ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

	--[[This block is only used for testing events handling in the event that Valve adds more in the future
	Convars:RegisterCommand('events_test', function()
			GameMode:StartEventTest()
		end, "events test", 0)]]

	local spew = 0
	if BAREBONES_DEBUG_SPEW then
		spew = 1
	end
	Convars:RegisterConvar('barebones_spew', tostring(spew), 'Set to 1 to start spewing barebones debug info.  Set to 0 to disable.', 0)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.bSeenWaitForPlayers = false
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
	if mode == nil then

		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()        
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled( DISABLE_FOG_OF_WAR_ENTIRELY )
		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
		mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
		if FORCE_PICKED_HERO ~= nil then
			mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
		end
		mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
		mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
		mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
		mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
		mode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )

		mode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)

		self:OnFirstPlayerLoaded()
	end 
end

-- This function captures the game mode options when they are set
function OnSetGameMode( eventSourceIndex, args )
	
	local player_id = args.PlayerID
	local player = PlayerResource:GetPlayer(player_id)
	local is_host = GameRules:PlayerHasCustomGameHostPrivileges(player)
	local mode_info = args.modes
	local game_mode_imba = GameRules:GetGameModeEntity()  
	local map_name = GetMapName()

	-- If the player who sent the game options is not the host, do nothing
	if not is_host then
		return nil
	end

	-- If nothing was captured from the game options, do nothing
	if not mode_info then
		return nil
	end

	-- If the game options were already chosen, do nothing
	if GAME_OPTIONS_SET then
		return nil
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Mode selection data setup
	-------------------------------------------------------------------------------------------------

	-- All random setup
	if tonumber(mode_info.all_random) == 1 then
		IMBA_PICK_MODE_ALL_RANDOM = true
		HERO_SELECTION_TIME = IMBA_ALL_RANDOM_HERO_SELECTION_TIME
		CustomNetTables:SetTableValue("game_options", "all_random", {true})
		print("All Random mode activated!")
	end

	-- Tower upgrade setup
	if tonumber(mode_info.tower_upgrades) == 1 then
		TOWER_UPGRADE_MODE = true
		CustomNetTables:SetTableValue("game_options", "tower_upgrades", {true})
		print("Tower upgrades activated!")
	end

	-- Frantic mode setup
	if tonumber(mode_info.frantic_mode) == 1 then
		IMBA_FRANTIC_MODE_ON = true
		CustomNetTables:SetTableValue("game_options", "frantic_mode", {true})
		print("Frantic mode activated!")
	end

	-- Arena mode setup
	if mode_info.kills_to_end and tonumber(mode_info.kills_to_end) > 0 and map_name == "imba_arena" then
		END_GAME_ON_KILLS = true
		KILLS_TO_END_GAME_FOR_TEAM = math.min(tonumber(mode_info.kills_to_end), 250)
		CustomNetTables:SetTableValue("game_options", "kills_to_end", {mode_info.kills_to_end})
		print("Game will end on "..KILLS_TO_END_GAME_FOR_TEAM.." kills!")
	end

	-- Bounty multiplier increase
	if tostring(mode_info.bounty_multiplier) == "GoldExpOption2" then
		if map_name == "imba_standard" or map_name == "imba_random_omg" then
			CUSTOM_GOLD_BONUS = 75
			CUSTOM_XP_BONUS = 75
		elseif map_name == "imba_custom" then
			CUSTOM_GOLD_BONUS = 300
			CUSTOM_XP_BONUS = 300
		elseif map_name == "imba_10v10" then
			CUSTOM_GOLD_BONUS = 125
			CUSTOM_XP_BONUS = 125
		elseif map_name == "imba_arena" then
			CUSTOM_GOLD_BONUS = 150
			CUSTOM_XP_BONUS = 150
		end
		CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {100 + CUSTOM_GOLD_BONUS})
	end
	print("Bounty multipliers set to high")

	-- Creep power increase
	if tostring(mode_info.creep_power) == "CreepPowerOption2" then
		if map_name == "imba_standard" or map_name == "imba_random_omg" then
			CREEP_POWER_FACTOR = 2
		elseif map_name == "imba_custom" then
			CREEP_POWER_FACTOR = 3
		elseif map_name == "imba_10v10" then
			CREEP_POWER_FACTOR = 2
		end
		CustomNetTables:SetTableValue("game_options", "creep_power", {CREEP_POWER_FACTOR})
	end
	print("Creep power set to high")

	-- Tower power increase
	if tostring(mode_info.tower_power) == "TowerPowerOption2" then
		if map_name == "imba_standard" or map_name == "imba_random_omg" then
			TOWER_POWER_FACTOR = 1
		elseif map_name == "imba_custom" then
			TOWER_POWER_FACTOR = 2
		elseif map_name == "imba_10v10" then
			TOWER_POWER_FACTOR = 2
		end
		CustomNetTables:SetTableValue("game_options", "tower_power", {TOWER_POWER_FACTOR})
	end
	print("Tower power set to high")

	-- Respawn timer decrease
	if tostring(mode_info.respawn_reduction) == "RespawnTimeOption2" then
		if map_name == "imba_standard" or map_name == "imba_random_omg" then
			HERO_RESPAWN_TIME_MULTIPLIER = 75
		elseif map_name == "imba_custom" then
			HERO_RESPAWN_TIME_MULTIPLIER = 50
		elseif map_name == "imba_10v10" then
			HERO_RESPAWN_TIME_MULTIPLIER = 50
		end
		CustomNetTables:SetTableValue("game_options", "respawn_multiplier", {100 - HERO_RESPAWN_TIME_MULTIPLIER})
	end
	print("Respawn timer reduction set to high")

	-- Hero power increase
	if tostring(mode_info.hero_power) == "InitialGoldExp2" then
		if map_name == "imba_standard" or map_name == "imba_random_omg" then
			HERO_INITIAL_GOLD = 1200
			HERO_REPICK_GOLD = 1000
			HERO_RANDOM_GOLD = 1500
			HERO_STARTING_LEVEL = 1
			MAX_LEVEL = 50
		elseif map_name == "imba_custom" then
			HERO_INITIAL_GOLD = 5000
			HERO_REPICK_GOLD = 4000
			HERO_RANDOM_GOLD = 6000
			HERO_STARTING_LEVEL = 12
			MAX_LEVEL = 100
		elseif map_name == "imba_10v10" then
			HERO_INITIAL_GOLD = 2000
			HERO_REPICK_GOLD = 1600
			HERO_RANDOM_GOLD = 2400
			HERO_STARTING_LEVEL = 5
			MAX_LEVEL = 60
		elseif map_name == "imba_arena" then
			HERO_INITIAL_GOLD = 2000
			HERO_REPICK_GOLD = 1600
			HERO_RANDOM_GOLD = 2400
			HERO_STARTING_LEVEL = 5
			MAX_LEVEL = 60
		end
		CustomNetTables:SetTableValue("game_options", "initial_gold", {HERO_INITIAL_GOLD})
		CustomNetTables:SetTableValue("game_options", "initial_level", {HERO_STARTING_LEVEL})
		CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL})
	end
	print("Hero power set to high")
	
	-- Set the game options as being chosen
	GAME_OPTIONS_SET = true

	-------------------------------------------------------------------------------------------------
	-- IMBA: Stat tracking stuff
	-------------------------------------------------------------------------------------------------

	-- Tracks if game options were customized or just left as default
	-- statCollection:setFlags({game_options_set = GAME_OPTIONS_SET and 1 or 0})

	-- -- Tracks the game mode
	-- if IMBA_ABILITY_MODE_RANDOM_OMG then
	-- 	statCollection:setFlags({game_mode = "Random_OMG"})
	-- 	if IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
	-- 		statCollection:setFlags({romg_mode = "ROMG_random_skills"})
	-- 	else
	-- 		statCollection:setFlags({romg_mode = "ROMG_fixed_skills"})
	-- 	end
	-- elseif IMBA_PICK_MODE_ALL_RANDOM then
	-- 	statCollection:setFlags({game_mode = "All_Random"})
	-- else
	-- 	statCollection:setFlags({game_mode = "All_Pick"})
	-- end

	-- -- Tracks same-hero selection
	-- statCollection:setFlags({same_hero = ALLOW_SAME_HERO_SELECTION and 1 or 0})

	-- -- Tracks game objective
	-- if END_GAME_ON_KILLS then
	-- 	statCollection:setFlags({kills_to_end = KILLS_TO_END_GAME_FOR_TEAM})
	-- else
	-- 	statCollection:setFlags({kills_to_end = 0})
	-- end

	-- -- Tracks gold/experience options
	-- statCollection:setFlags({gold_bonus = CUSTOM_GOLD_BONUS})
	-- statCollection:setFlags({exp_bonus = CUSTOM_XP_BONUS})

	-- -- Tracks respawn and buyback
	-- statCollection:setFlags({respawn_mult = HERO_RESPAWN_TIME_MULTIPLIER})
	-- statCollection:setFlags({buyback_mult = 100})

	-- -- Track starting gold and levels
	-- statCollection:setFlags({starting_gold = HERO_INITIAL_GOLD})
	-- statCollection:setFlags({starting_exp = HERO_STARTING_LEVEL})

	-- -- Tracks creep and tower power settings
	-- statCollection:setFlags({creep_power = CREEP_POWER_FACTOR})
	-- statCollection:setFlags({tower_power = TOWER_POWER_FACTOR})

	-- -- Tracks structure abilities and upgrades
	-- statCollection:setFlags({tower_abilities = TOWER_ABILITY_MODE and 1 or 0})
	-- statCollection:setFlags({tower_upgrades = TOWER_UPGRADE_MODE and 1 or 0})
end