-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

function GameMode:_InitGameMode()

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( true ) -- Let server handle hero duplicates
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetShowcaseTime( SHOWCASE_TIME )
	GameRules:SetStrategyTime( STRATEGY_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_NONSTANDARD_HERO_XP_BOUNTY )
	GameRules:SetGoldPerTick( GOLD_PER_TICK )
	GameRules:SetUseBaseGoldBountyOnHeroes( USE_NONSTANDARD_HERO_GOLD_BOUNTY )
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
	GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
	GameRules:SetStartingGold( MAP_INITIAL_GOLD )
	GameRules:LockCustomGameSetupTeamAssignment(true)

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
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
	ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(GameMode, 'OnPlayerChat'), self)

	ListenToGameEvent("dota_item_combined", Dynamic_Wrap(GameMode, 'OnItemCombined'), self)
	ListenToGameEvent("dota_tower_kill", Dynamic_Wrap(GameMode, 'OnTowerKill'), self)
--	ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.bSeenWaitForPlayers = false
end

local mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
	if mode == nil then

		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		if FORCE_PICKED_HERO ~= nil then
			mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
		end
		mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
		mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
		mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
		mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )

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
	-- IMBA: Mode selection data setup
	-------------------------------------------------------------------------------------------------

	-- All random setup
	if tonumber(mode_info.all_pick) == 1 then
		IMBA_PICK_MODE_ALL_PICK = true
		CustomNetTables:SetTableValue("game_options", "all_pick", {true})
	end

	-- All random setup
	if tonumber(mode_info.all_random) == 1 then
		IMBA_PICK_MODE_ALL_RANDOM = true
		HERO_SELECTION_TIME = IMBA_ALL_RANDOM_HERO_SELECTION_TIME
		CustomNetTables:SetTableValue("game_options", "all_random", {true})
	end

	-- All random setup
	if tonumber(mode_info.all_random_same_hero) == 1 then
		log.info("ARDM:", mode_info.all_random_same_hero)
		IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO = true
		HERO_SELECTION_TIME = IMBA_ALL_RANDOM_HERO_SELECTION_TIME
		CustomNetTables:SetTableValue("game_options", "all_random_same_hero", {true})
	end

	-- Bounty multiplier increase
	CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {CUSTOM_GOLD_BONUS[GetMapName()]})

	-- XP multiplier increase
	CustomNetTables:SetTableValue("game_options", "exp_multiplier", {CUSTOM_XP_BONUS[GetMapName()]})

	-- Tower power increase
	if mode_info.exp_multiplier == 1 then
		TOWER_POWER_FACTOR = 1
	elseif mode_info.tower_power == 2 then
		if IsFranticMap() == false then
			TOWER_POWER_FACTOR = 2
		else
			TOWER_POWER_FACTOR = 3
		end
	end
	CustomNetTables:SetTableValue("game_options", "tower_power", {TOWER_POWER_FACTOR})

	-- Hero power increase
	CustomNetTables:SetTableValue("game_options", "initial_gold", {HERO_INITIAL_GOLD[GetMapName()]})
	CustomNetTables:SetTableValue("game_options", "initial_level", {HERO_STARTING_LEVEL[GetMapName()]})
	CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL[GetMapName()]})
end
