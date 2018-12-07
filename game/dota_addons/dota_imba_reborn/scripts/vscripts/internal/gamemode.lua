-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

require('internal/constants')

function GameMode:_InitGameMode()
	if self._reentrantCheck then
		return
	end

	-- Store day/night time clientside
	StoreCurrentDayCycle()
	CustomGameEventManager:RegisterListener("change_companion", Dynamic_Wrap(self, "DonatorCompanionJS"))
	CustomGameEventManager:RegisterListener("change_companion_skin", Dynamic_Wrap(self, "DonatorCompanionSkinJS"))
	CustomGameEventManager:RegisterListener("send_gg_vote", Dynamic_Wrap(GoodGame, 'Call'))

	self:SetupAncients()
	self:SetupFountains()

	-- Setup rules
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( IMBA_PICK_SCREEN ) -- Let server handle hero duplicates
	GameRules:SetPreGameTime( PRE_GAME_TIME )
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

	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_DOUBLEDAMAGE , true) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_HASTE, true) --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ILLUSION, true) --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_INVISIBILITY, true) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_REGENERATION, true) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ARCANE, true) --Arcane
--	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_BOUNTY, false) --Bounty

	if IMBA_PICK_SCREEN == false then
		GameRules:SetStartingGold(HERO_INITIAL_GOLD[GetMapName()])
	else
		GameRules:SetStartingGold(0)
	end

	GameRules:LockCustomGameSetupTeamAssignment(not IsInToolsMode())

	if IMBA_PICK_SCREEN == false then
		GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(AP_GAME_TIME)
		GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(AP_BAN_TIME)
	end

	-- This is multiteam configuration stuff
	if USE_AUTOMATIC_PLAYERS_PER_TEAM then
		local num = math.floor(10 / MAX_NUMBER_OF_TEAMS)
		local count = 0
		for team,number in pairs(TEAM_COLORS) do
			if count >= MAX_NUMBER_OF_TEAMS then
				GameRules:SetCustomGameTeamMaxPlayers(team, 0)
			else
				GameRules:SetCustomGameTeamMaxPlayers(team, num)
			end
			count = count + 1
		end
	else
		local count = 0
		for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
			if count >= MAX_NUMBER_OF_TEAMS then
				GameRules:SetCustomGameTeamMaxPlayers(team, 0)
			else
				GameRules:SetCustomGameTeamMaxPlayers(team, number)
			end
			count = count + 1
		end
	end

	-- team colors are not working in chat, so use team colors instead
--	SetTeamCustomHealthbarColor(DOTA_TEAM_GOODGUYS, 0, 128, 0)
--	SetTeamCustomHealthbarColor(DOTA_TEAM_BADGUYS, 128, 0, 0)

	-- WHY DON'T YOU WORK FOR CHAT PLAYER COLORS, WHAT HAPPENED TO YOU BUDDY
	for ID = 0, PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(ID) then
			PlayerResource:SetCustomPlayerColor(ID, PLAYER_COLORS[ID][1], PLAYER_COLORS[ID][2], PLAYER_COLORS[ID][3])
		end
	end

	-- Event Hooks
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(self, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, '_OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, '_OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(self, 'OnDisconnect'), self)
	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(self, 'OnItemPickedUp'), self)
--	ListenToGameEvent('player_connect', Dynamic_Wrap(self, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(self, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, '_OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, '_OnNPCSpawned'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnect'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(self, 'OnPlayerChat'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(self, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(self, 'OnTeamKillCredit'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(self, 'OnRuneActivated'), self)

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+','')
	math.randomseed(tonumber(timeTxt))

	-- Initialized tables for tracking state
	self.bSeenWaitForPlayers = false
	self.vUserIds = {}

	self._reentrantCheck = true
	self:InitGameMode()
	self._reentrantCheck = false
end

local mode = nil

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:_CaptureGameMode()
	if mode == nil then
		-- Set GameMode parameters
		mode = GameRules:GetGameModeEntity()
		mode:SetRecommendedItemsDisabled( false )
		mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
		mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
		mode:SetBuybackEnabled( BUYBACK_ENABLED )
		mode:SetTopBarTeamValuesOverride ( false )
		mode:SetTopBarTeamValuesVisible( true )
		mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		mode:SetBotThinkingEnabled( false )
		mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

		mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
		mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

		if FORCE_PICKED_HERO ~= nil and IMBA_PICK_SCREEN == true then
			mode:SetCustomGameForceHero( FORCE_PICKED_HERO )
		end

		mode:SetFixedRespawnTime( -1 ) 
--		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
--		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
--		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
		mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
		mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
		mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )

		mode:SetHudCombatEventsDisabled(IMBA_COMBAT_EVENTS)
		mode:SetCustomTerrainWeatherEffect(IMBA_WEATHER_EFFECT[RandomInt(1, #IMBA_WEATHER_EFFECT)])

		self:OnFirstPlayerLoaded()
	end
end

-- This function captures the game mode options when they are set
function GameMode:OnSetGameMode()
	CustomNetTables:SetTableValue("game_options", "bounty_multiplier", {CUSTOM_GOLD_BONUS[GetMapName()]})
	CustomNetTables:SetTableValue("game_options", "exp_multiplier", {CUSTOM_XP_BONUS[GetMapName()]})
	CustomNetTables:SetTableValue("game_options", "initial_gold", {HERO_INITIAL_GOLD[GetMapName()]})
	CustomNetTables:SetTableValue("game_options", "initial_level", {HERO_STARTING_LEVEL[GetMapName()]})
	if IsMutationMap() and IMBA_MUTATION["positive"] == "ultimate_level" then
		MAX_LEVEL[GetMapName()] = IMBA_MUTATION_ULTIMATE_LEVEL
	end
	CustomNetTables:SetTableValue("game_options", "max_level", {MAX_LEVEL[GetMapName()]})
end
