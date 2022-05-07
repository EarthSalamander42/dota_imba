-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:_InitGameMode()
	if self._reentrantCheck then
		return
	end

	-- Setup rules
	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	GameRules:SetStrategyTime(STRATEGY_TIME)
	GameRules:SetShowcaseTime(SHOWCASE_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME[GetMapName()])
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
--	GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )

	GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
	GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )

	if SKIP_TEAM_SETUP then
		GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
		GameRules:LockCustomGameSetupTeamAssignment( true )
		GameRules:EnableCustomGameSetupAutoLaunch( true )
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
		GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
		GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
	end

	-- WHY DON'T YOU WORK FOR CHAT PLAYER COLORS, WHAT HAPPENED TO YOU BUDDY
	if PlayerResource:GetPlayerCount() > 5 then
		for ID = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(ID) then
				PlayerResource:SetCustomPlayerColor(ID, PLAYER_COLORS[ID][1], PLAYER_COLORS[ID][2], PLAYER_COLORS[ID][3])
			end
		end
	end

	if CUSTOM_TEAM_PLAYER_COUNT and CUSTOM_TEAM_PLAYER_COUNT[GetMapName()] and type(CUSTOM_TEAM_PLAYER_COUNT[GetMapName()]) == "table" then
		for team_number, player_count in pairs(CUSTOM_TEAM_PLAYER_COUNT[GetMapName()]) do
			GameRules:SetCustomGameTeamMaxPlayers(team_number, player_count)
		end
	end

	DebugPrint('[BAREBONES] GameRules set')

	--InitLogFile( "log/barebones.txt","")

	-- Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.  If you are interested in the other events, you can uncomment the
	-- ListenToGameEvent line and add a function to handle the event
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, 'OnEntityKilled'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(self, 'OnDisconnect'), self)

	--	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, 'OnConnectFull'), self)
--	ListenToGameEvent('tree_cut', Dynamic_Wrap(self, 'OnTreeCut'), self)
--	ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnect'), self)
--	ListenToGameEvent("player_chat", Dynamic_Wrap(self, 'OnPlayerChat'), self)

	local spew = 0
	if BAREBONES_DEBUG_SPEW then
		spew = 1
	end
	Convars:RegisterConvar('barebones_spew', tostring(spew), 'Set to 1 to start spewing barebones debug info.  Set to 0 to disable.', 0)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.bSeenWaitForPlayers = false
	self.vUserIds = {}

	DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
	self._reentrantCheck = true

	self:_CaptureGameMode()
end

mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()        
		mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
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

		mode:SetUnseenFogOfWarEnabled( USE_UNSEEN_FOG_OF_WAR )

		mode:SetDaynightCycleDisabled( DISABLE_DAY_NIGHT_CYCLE )
		mode:SetKillingSpreeAnnouncerDisabled( DISABLE_KILLING_SPREE_ANNOUNCER )
		mode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )
		mode:SetFreeCourierModeEnabled(USE_MULTIPLE_COURIERS)

		mode:SetItemAddedToInventoryFilter(Dynamic_Wrap(self, "ItemAddedFilter"), self)
		mode:SetBountyRunePickupFilter(Dynamic_Wrap(self, "BountyRuneFilter"), self)
		mode:SetModifierGainedFilter(Dynamic_Wrap(self, "ModifierFilter"), self)
		mode:SetExecuteOrderFilter(Dynamic_Wrap(self, "OrderFilter"), self)
		mode:SetDamageFilter(Dynamic_Wrap(self, "DamageFilter"), self)

		mode:SetRuneEnabled(DOTA_RUNE_DOUBLEDAMAGE , true) -- Double Damage
		mode:SetRuneEnabled(DOTA_RUNE_HASTE, true) -- Haste
		mode:SetRuneEnabled(DOTA_RUNE_ILLUSION, true) -- Illusion
		mode:SetRuneEnabled(DOTA_RUNE_INVISIBILITY, true) -- Invis
		mode:SetRuneEnabled(DOTA_RUNE_REGENERATION, true) -- Regen
		mode:SetRuneEnabled(DOTA_RUNE_ARCANE, true) -- Arcane

--		mode:SetDraftingHeroPickSelectTimeOverride(0.0)
		mode:SetDraftingBanningTimeOverride(AP_BAN_TIME)

		GameMode:SetupTurboRules()
	end 
end

function GameMode:SetupTurboRules()
	-- starting gold
	local custom_gold_bonus = CUSTOM_GOLD_BONUS[GetMapName()] or 100
	
	if custom_gold_bonus > 100 then
		HERO_INITIAL_GOLD = VANILA_HERO_INITIAL_GOLD * custom_gold_bonus / 100
	end
end
