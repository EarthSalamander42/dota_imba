-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later

require('internal/constants')

function GameMode:_InitGameMode()
	if self._reentrantCheck then
		return
	end

	-- Store day/night time clientside
	StoreCurrentDayCycle()
	--	print("Vote Settings listener initialized.")
	CustomGameEventManager:RegisterListener("setting_vote", Dynamic_Wrap(GameMode, "OnSettingVote"))
	CustomGameEventManager:RegisterListener("send_gg_vote", Dynamic_Wrap(GoodGame, 'Call'))
	CustomGameEventManager:RegisterListener("effigy_destroyed", Dynamic_Wrap(GameMode, 'EffigyDestroyed'))
	CustomGameEventManager:RegisterListener("party_vote", Dynamic_Wrap(GameMode, "OnPartyVote"))

	self:SetupAncients()

	-- Setup rules
	GameRules:SetUseUniversalShopMode(UNIVERSAL_SHOP_MODE)
	GameRules:SetSameHeroSelectionEnabled(SAME_HERO_SELECTION) -- Let server handle hero duplicates
	GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
	GameRules:SetHeroSelectPenaltyTime(SELECT_PENALTY_TIME)
	GameRules:SetPreGameTime(PRE_GAME_TIME)
	GameRules:SetPostGameTime(POST_GAME_TIME)
	GameRules:SetShowcaseTime(SHOWCASE_TIME)
	GameRules:SetStrategyTime(STRATEGY_TIME)
	GameRules:SetTreeRegrowTime(TREE_REGROW_TIME)
	GameRules:SetHeroMinimapIconScale(MINIMAP_ICON_SIZE)
	GameRules:SetCreepMinimapIconScale(MINIMAP_CREEP_ICON_SIZE)
	GameRules:SetRuneMinimapIconScale(MINIMAP_RUNE_ICON_SIZE)
	GameRules:SetFirstBloodActive(ENABLE_FIRST_BLOOD)
	GameRules:SetHideKillMessageHeaders(HIDE_KILL_BANNERS)
	GameRules:SetCustomGameSetupAutoLaunchDelay(AUTO_LAUNCH_DELAY)
	GameRules:SetUseCustomHeroXPValues(USE_NONSTANDARD_HERO_XP_BOUNTY)
	GameRules:SetUseBaseGoldBountyOnHeroes(USE_NONSTANDARD_HERO_GOLD_BOUNTY)

	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_DOUBLEDAMAGE, true) --Double Damage
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_HASTE, true)     --Haste
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ILLUSION, true)  --Illusion
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_INVISIBILITY, true) --Invis
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_REGENERATION, true) --Regen
	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_ARCANE, true)    --Arcane
	--	GameRules:GetGameModeEntity():SetRuneEnabled(DOTA_RUNE_BOUNTY, false) --Bounty

	GameRules:GetGameModeEntity():SetFreeCourierModeEnabled(true)
	GameRules:GetGameModeEntity():SetUseDefaultDOTARuneSpawnLogic(true)

	--	if IMBA_PICK_SCREEN == false then
	--		GameRules:SetStartingGold(HERO_INITIAL_GOLD[GetMapName()])
	--	else
	--		GameRules:SetStartingGold(0)
	--	end

	GameRules:LockCustomGameSetupTeamAssignment(true)

	if IMBA_PICK_SCREEN == false then
		if IsInToolsMode() then
			GameRules:SetCustomGameSetupRemainingTime(0.0)
			GameRules:SetCustomGameSetupAutoLaunchDelay(0.0)
			GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(HERO_SELECTION_TIME)
			GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(0)
		else
			GameRules:GetGameModeEntity():SetDraftingHeroPickSelectTimeOverride(HERO_SELECTION_TIME)
			GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(AP_BAN_TIME)
		end

		if not IsInToolsMode() or GetMapName() ~= "imba_demo" then
			GameRules:SetCustomGameBansPerTeam(IMBA_PLAYERS_ON_GAME / #CUSTOM_TEAM_PLAYER_COUNT)
		end
	end

	if IsInToolsMode() then
		GameRules:SetCustomGameTeamMaxPlayers(1, 1)
	end

	-- team colors are not working in chat, so use team colors instead
	--	SetTeamCustomHealthbarColor(DOTA_TEAM_GOODGUYS, 0, 128, 0)
	--	SetTeamCustomHealthbarColor(DOTA_TEAM_BADGUYS, 128, 0, 0)

	-- WHY DON'T YOU WORK FOR CHAT PLAYER COLORS, WHAT HAPPENED TO YOU BUDDY
	-- for ID = 0, PlayerResource:GetPlayerCount() - 1 do
	-- 	if PlayerResource:IsValidPlayer(ID) then
	-- 		PlayerResource:SetCustomPlayerColor(ID, PLAYER_COLORS[ID][1], PLAYER_COLORS[ID][2], PLAYER_COLORS[ID][3])
	-- 	end
	-- end

	-- Event Hooks
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(self, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(self, '_OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(self, '_OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(self, 'OnDisconnect'), self)
	--	ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(self, 'OnItemPickedUp'), self)
	--	ListenToGameEvent('player_connect', Dynamic_Wrap(self, 'PlayerConnect'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(self, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(self, '_OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(self, '_OnNPCSpawned'), self)
	--	ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnect'), self)
	ListenToGameEvent("player_chat", Dynamic_Wrap(self, 'OnPlayerChat'), self)
	ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(self, 'OnPlayerLearnedAbility'), self)
	ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(self, 'OnTeamKillCredit'), self)
	ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(self, 'OnRuneActivated'), self)
	-- ListenToGameEvent('dota_pause_event', Dynamic_Wrap(self, 'OnPause'), self) -- Doesn't work

	-- Change random seed
	local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '^0+', '')
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
		mode:SetRecommendedItemsDisabled(false)
		mode:SetCustomBuybackCostEnabled(CUSTOM_BUYBACK_COST_ENABLED)
		mode:SetCustomBuybackCooldownEnabled(CUSTOM_BUYBACK_COOLDOWN_ENABLED)
		mode:SetBuybackEnabled(BUYBACK_ENABLED)
		mode:SetTopBarTeamValuesOverride(false)
		mode:SetTopBarTeamValuesVisible(true)
		-- mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
		-- mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

		mode:SetBotThinkingEnabled(false)
		mode:SetTowerBackdoorProtectionEnabled(ENABLE_TOWER_BACKDOOR_PROTECTION)

		mode:SetGoldSoundDisabled(DISABLE_GOLD_SOUNDS)
		mode:SetRemoveIllusionsOnDeath(REMOVE_ILLUSIONS_ON_DEATH)

		if FORCE_PICKED_HERO ~= nil and IMBA_PICK_SCREEN == true then
			mode:SetCustomGameForceHero(FORCE_PICKED_HERO)
		end

		mode:SetFixedRespawnTime(-1)
		--		mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
		--		mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
		--		mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
		mode:SetLoseGoldOnDeath(LOSE_GOLD_ON_DEATH)
		mode:SetMinimumAttackSpeed(MINIMUM_ATTACK_SPEED)
		mode:SetMaximumAttackSpeed(MAXIMUM_ATTACK_SPEED)

		mode:SetHudCombatEventsDisabled(IMBA_COMBAT_EVENTS)

		self:OnFirstPlayerLoaded()
	end
end

-- This function captures the game mode options when they are set
function GameMode:OnSetGameMode()
	CustomNetTables:SetTableValue("game_options", "bounty_multiplier", { CUSTOM_GOLD_BONUS[GetMapName()] })
	CustomNetTables:SetTableValue("game_options", "exp_multiplier", { CUSTOM_XP_BONUS[GetMapName()] })
	CustomNetTables:SetTableValue("game_options", "initial_level", { HERO_STARTING_LEVEL[GetMapName()] })
	CustomNetTables:SetTableValue("game_options", "max_level", { MAX_LEVEL[GetMapName()] })

	local hero_gold = HERO_INITIAL_GOLD
	local custom_gold_bonus = CUSTOM_GOLD_BONUS[GetMapName()] or 100

	if custom_gold_bonus > 100 then
		hero_gold = hero_gold * custom_gold_bonus / 100
	end

	CustomNetTables:SetTableValue("game_options", "initial_gold", { hero_gold })
end

function GameMode:EffigyDestroyed(keys)
	if keys.player_name and keys.player_name ~= "" then
		if string.find(keys.unit_name, "developer") then
			-- Say(nil, keys.player_name.." destroyed "..keys.real_unit_name.."'s effigy! Incoming ban in 3, 2, 1...", false)
		else
			-- Say(nil, keys.player_name.." destroyed "..keys.real_unit_name.."'s effigy!", false)
		end
	else
		if string.find(keys.real_unit_name, "developer") then
			-- Say(nil, keys.real_unit_name.."'s effigy has been destroyed! Incoming ban in 3, 2, 1...", false)
		else
			-- Say(nil, keys.real_unit_name.."'s effigy has been destroyed!", false)
		end
	end
end

function GameMode:SetupTower(tower)
	if tower.initialized then return end
	--	if tower.initialized or GetMapName() == Map1v1() then return end
	for i = 1, 4 do
		for _, ability in pairs(TOWER_ABILITIES["tower" .. i]) do
			if string.find(tower:GetUnitName(), "tower" .. i) then
				--				print("Tower found:", ability) -- tower spawned from pocket tower mutation are found and print well, abilities are not given for reasons
				tower:AddAbility(ability):SetLevel(i)
				tower.initialized = true
			end
		end
	end
end

function GameMode:SetPlayerColors()
	-- setup Player colors into hex for panorama
	local hex_colors = {}

	for team = 2, 3 do
		hex_colors[team] = {}

		for i = 0, #PLAYER_COLORS + 1 do
			if PLAYER_COLORS and PLAYER_COLORS[team] and PLAYER_COLORS[team][i] then
				table.insert(hex_colors[team], i, rgbToHex(PLAYER_COLORS[team][i]))
			end
		end
	end

	CustomNetTables:SetTableValue("game_options", "player_colors", hex_colors)
end

function GameMode:ApplyPlayerColors(nPlayerID)
	local player = PlayerResource:GetPlayer(nPlayerID)

	-- Setup topbar player colors
	if player and PlayerResource:IsValidPlayer(nPlayerID) and PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
		CustomGameEventManager:Send_ServerToPlayer(player, "override_top_bar_colors", {})
	end
end
