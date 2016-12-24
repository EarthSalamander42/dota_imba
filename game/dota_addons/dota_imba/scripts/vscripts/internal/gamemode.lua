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
	-- IMBA: Pick mode selection
	-------------------------------------------------------------------------------------------------

	-- Retrieve information
	if tonumber(mode_info.all_random) == 1 then
		IMBA_PICK_MODE_ALL_RANDOM = true
		print("All Random mode activated!")
	end

	-- Enable same hero mode
	if tonumber(mode_info.allow_same_hero) == 1 then
		GameRules:SetSameHeroSelectionEnabled(true)
		print("Same-hero selection enabled!")
	end

	-- Pick wait time setup
	if IMBA_ABILITY_MODE_RANDOM_OMG or IMBA_PICK_MODE_ALL_RANDOM then
		GameRules:SetHeroSelectionTime( IMBA_ALL_RANDOM_HERO_SELECTION_TIME )
	end

	-- Set game end on kills
	if tonumber(mode_info.number_of_kills) > 0 then
		END_GAME_ON_KILLS = true
		KILLS_TO_END_GAME_FOR_TEAM = math.min(tonumber(mode_info.number_of_kills), 250)
		print("Game will end on "..KILLS_TO_END_GAME_FOR_TEAM.." kills!")
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Additional Random OMG setup
	-------------------------------------------------------------------------------------------------

	-- Detect amount of abilities/ultimates to learn each time
	if mode_info.number_of_abilities == "3a2u" then
		IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 3
		IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 2
		print("Random OMG: 3 abilities, 2 ultimates")
	elseif mode_info.number_of_abilities == "4a1u" then
		IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 4
		IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 1
		print("Random OMG: 4 abilities, 1 ultimates")
	elseif mode_info.number_of_abilities == "4a2u" then
		IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 4
		IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 2
		print("Random OMG: 5 abilities, 2 ultimates")
	elseif mode_info.number_of_abilities == "5a1u" then
		IMBA_RANDOM_OMG_NORMAL_ABILITY_COUNT = 5
		IMBA_RANDOM_OMG_ULTIMATE_ABILITY_COUNT = 1
		print("Random OMG: 5 abilities, 1 ultimates")
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Gold/bounties setup
	-------------------------------------------------------------------------------------------------
	
	-- Starting gold information
	if mode_info.gold_start == "2000" then
		HERO_INITIAL_GOLD = 2000 - MAP_INITIAL_GOLD
		HERO_REPICK_GOLD_LOSS = -400
		HERO_RANDOM_GOLD_BONUS = 300
	elseif mode_info.gold_start == "6000" then
		HERO_INITIAL_GOLD = 6000 - MAP_INITIAL_GOLD
		HERO_REPICK_GOLD_LOSS = -900
		HERO_RANDOM_GOLD_BONUS = 800
	elseif mode_info.gold_start == "15000" then
		HERO_INITIAL_GOLD = 15000 - MAP_INITIAL_GOLD
		HERO_REPICK_GOLD_LOSS = -2400
		HERO_RANDOM_GOLD_BONUS = 2300
	end
	print("hero starting gold: "..HERO_INITIAL_GOLD)

	-- Gold bounties information
	if tonumber(mode_info.gold_bounty) > 0 then
		CUSTOM_GOLD_BONUS = math.min(tonumber(mode_info.gold_bounty), 300)
	end
	print("gold bounty increased by: "..CUSTOM_GOLD_BONUS)

	-- XP bounties information
	if tonumber(mode_info.xp_bounty) > 0 then
		CUSTOM_XP_BONUS = math.min(tonumber(mode_info.xp_bounty), 300)
	end
	print("xp bounty increased by: "..CUSTOM_XP_BONUS)

	-- Comeback gold adjustment
	if tonumber(mode_info.comeback_gold) == 0 then
		HERO_GLOBAL_BOUNTY_FACTOR = 0
		print("Global comeback gold deactivated!")
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Creeps and buildings setup
	-------------------------------------------------------------------------------------------------
	
	-- Enable tower/ancient abilities
	if tonumber(mode_info.tower_upgrades) == 1 then
		TOWER_ABILITY_MODE = true
		TOWER_UPGRADE_MODE = true
		print("Upgradable tower abilities enabled!")
	elseif tonumber(mode_info.tower_abilities) == 1 then
		TOWER_ABILITY_MODE = true
		print("Random tower abilities enabled!")
	else
		TOWER_ABILITY_MODE = false
	end

	-- Ancient Behemoth setup
	if tonumber(mode_info.spawn_behemoths) == 0 then
		SPAWN_ANCIENT_BEHEMOTHS = false
		print("Ancient Behemoths deactivated!")
	end

	-- Creep and tower power adjustment
	CREEP_POWER_FACTOR = tonumber(mode_info.creep_power)
	TOWER_POWER_FACTOR = tonumber(mode_info.tower_power)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero levels and respawn setup
	-------------------------------------------------------------------------------------------------

	-- Enable higher starting level
	if tonumber(mode_info.xp_start) then
		HERO_STARTING_LEVEL = math.min(math.max(tonumber(mode_info.xp_start), 1), 25)
		print("Heroes will start the game on level "..HERO_STARTING_LEVEL)
	end

	-- Set up level cap
	if mode_info.level_cap then
		MAX_LEVEL = math.min(math.max(tonumber(mode_info.level_cap), 25), 100)
	end
	print("Heroes can level up to level "..MAX_LEVEL)

	-- Max level experience table set-up
	if MAX_LEVEL > 35 then
		for i = 36, MAX_LEVEL do
			XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
			mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		end
	end

	-- Respawn time information
	if mode_info.respawn == "respawn_half" then
		HERO_RESPAWN_TIME_MULTIPLIER = 50
	elseif mode_info.respawn == "respawn_zero" then
		HERO_RESPAWN_TIME_MULTIPLIER = 0
	end
	print("respawn time multiplier: "..HERO_RESPAWN_TIME_MULTIPLIER)

	-- Buyback cooldown information
	if tonumber(mode_info.disable_buyback_cooldown) == 1 then
		BUYBACK_COOLDOWN_ENABLED = false
		print("buyback cooldown disabled")
	end
	
	-- Set the game options as being chosen
	GAME_OPTIONS_SET = true

	-- Finish mode setup and start the game
	--GameRules:FinishCustomGameSetup()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Stat tracking stuff
	-------------------------------------------------------------------------------------------------

	-- Tracks if game options were customized or just left as default
	statCollection:setFlags({game_options_set = GAME_OPTIONS_SET and 1 or 0})

	-- Tracks the game mode
	if IMBA_ABILITY_MODE_RANDOM_OMG then
		statCollection:setFlags({game_mode = "Random_OMG"})
		if IMBA_RANDOM_OMG_RANDOMIZE_SKILLS_ON_DEATH then
			statCollection:setFlags({romg_mode = "ROMG_random_skills"})
		else
			statCollection:setFlags({romg_mode = "ROMG_fixed_skills"})
		end
	elseif IMBA_PICK_MODE_ALL_RANDOM then
		statCollection:setFlags({game_mode = "All_Random"})
	else
		statCollection:setFlags({game_mode = "All_Pick"})
	end

	-- Tracks same-hero selection
	statCollection:setFlags({same_hero = ALLOW_SAME_HERO_SELECTION and 1 or 0})

	-- Tracks game objective
	if END_GAME_ON_KILLS then
		statCollection:setFlags({kills_to_end = KILLS_TO_END_GAME_FOR_TEAM})
	else
		statCollection:setFlags({kills_to_end = 0})
	end

	-- Tracks gold/experience options
	statCollection:setFlags({gold_bonus = CUSTOM_GOLD_BONUS})
	statCollection:setFlags({exp_bonus = CUSTOM_XP_BONUS})

	-- Tracks respawn and buyback
	statCollection:setFlags({respawn_mult = HERO_RESPAWN_TIME_MULTIPLIER})
	statCollection:setFlags({buyback_mult = 100})

	-- Track starting gold and levels
	statCollection:setFlags({starting_gold = HERO_INITIAL_GOLD})
	statCollection:setFlags({starting_exp = HERO_STARTING_LEVEL})

	-- Tracks creep and tower power settings
	statCollection:setFlags({creep_power = CREEP_POWER_FACTOR})
	statCollection:setFlags({tower_power = TOWER_POWER_FACTOR})

	-- Tracks structure abilities and upgrades
	statCollection:setFlags({tower_abilities = TOWER_ABILITY_MODE and 1 or 0})
	statCollection:setFlags({tower_upgrades = TOWER_UPGRADE_MODE and 1 or 0})
end