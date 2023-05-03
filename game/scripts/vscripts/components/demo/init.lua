--------------------------------------------------------------------------------
-- GameEvent:OnGameRulesStateChange
--------------------------------------------------------------------------------
ListenToGameEvent('game_rules_state_change', function()
	if IsInToolsMode() == false then
		if GetMapName() ~= "imba_demo" then return end
	end

	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameMode:InitDemo()
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		--		SendToServerConsole( "dota_dev forcegamestart" )

		-- ONLY SHOW THE DEMO PANEL IF IT'S ACTUALLY DEMO MODE (lest people get the wrong idea with thinking other players can use these "hacks")
		GameRules:GetGameModeEntity():SetContextThink("show_demo_panel", function()
			CustomGameEventManager:Send_ServerToAllClients("ShowDemoPanel", {})

			return nil
		end, 3.0)
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not IsInToolsMode() then
			Notifications:TopToAll({ text = "Do not abandon the game, click the red QUIT button bottom left or type -exit in chat to avoid custom game ban.", duration = 3600.0, style = { color = "Red" } })
		end
	end
end, nil)

function GameMode:InitDemo()
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled(true)
	GameRules:GetGameModeEntity():SetFixedRespawnTime(4)
	--	GameRules:GetGameModeEntity():SetBotThinkingEnabled( true ) -- the ConVar is currently disabled in C++
	-- Set bot mode difficulty: can try GameRules:GetGameModeEntity():SetCustomGameDifficulty( 1 )

	GameRules:SetUseUniversalShopMode(true)
	-- GameRules:SetPreGameTime(10.0)
	-- GameRules:SetStrategyTime(0.0)
	-- GameRules:SetCustomGameSetupTimeout(0.0) -- skip the custom team UI with 0, or do indefinite duration with -1
	GameRules:SetSafeToLeave(true)

	-- Events
	CustomGameEventManager:RegisterListener("WelcomePanelDismissed", function(...) return self:OnWelcomePanelDismissed(...) end)
	CustomGameEventManager:RegisterListener("RefreshButtonPressed", function(...) return self:OnRefreshButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("LevelUpButtonPressed", function(...) return self:OnLevelUpButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("MaxLevelButtonPressed", function(...) return self:OnMaxLevelButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("FreeSpellsButtonPressed", function(...) return self:OnFreeSpellsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("InvulnerabilityButtonPressed", function(...) return self:OnInvulnerabilityButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnAllyButtonPressed", function(...) return self:OnSpawnAllyButtonPressed(...) end) -- deprecated
	CustomGameEventManager:RegisterListener("SpawnEnemyButtonPressed", function(...) return self:OnSpawnEnemyButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnEnemyButtonPressedAlt", function(...) return self:OnSpawnEnemyButtonPressedAlt(...) end)
	CustomGameEventManager:RegisterListener("LevelUpEnemyButtonPressed", function(...) return self:OnLevelUpEnemyButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("DummyTargetButtonPressed", function(...) return self:OnDummyTargetButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("RemoveSpawnedUnitsButtonPressed", function(...) return self:OnRemoveSpawnedUnitsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("LaneCreepsButtonPressed", function(...) return self:OnLaneCreepsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("ChangeHeroButtonPressed", function(...) return self:OnChangeHeroButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("ChangeCosmeticsButtonPressed", function(...) return self:OnChangeCosmeticsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("PauseButtonPressed", function(...) return self:OnPauseButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed(...) end)
	--	CustomGameEventManager:RegisterListener("fix_newly_picked_hero", Dynamic_Wrap(self, 'OnNewHeroChosen'))
	CustomGameEventManager:RegisterListener("demo_select_hero", Dynamic_Wrap(self, 'OnNewHeroSelected'))

	SendToServerConsole("sv_cheats 1")
	SendToServerConsole("dota_hero_god_mode 0")
	SendToServerConsole("dota_ability_debug 0")
	SendToServerConsole("dota_creeps_no_spawning 0")
	SendToServerConsole("dota_easybuy 1")
	--	SendToServerConsole( "dota_bot_mode 1" )

	self.m_bPlayerDataCaptured = false
	self.m_nPlayerID = 0

	--	self.m_nHeroLevelBeforeMaxing = 1 -- unused now
	--	self.m_bHeroMaxedOut = false -- unused now

	self.m_nALLIES_TEAM = PlayerResource:GetTeam(0) or 2
	self.m_tAlliesList = {}
	self.m_nAlliesCount = 0

	local enemy_team = self.m_nALLIES_TEAM
	if enemy_team == 2 then
		enemy_team = 3
	elseif enemy_team == 3 then
		enemy_team = 2
	end

	self.m_nENEMIES_TEAM = enemy_team
	self.m_tEnemiesList = {}

	self.m_bFreeSpellsEnabled = false
	self.m_bInvulnerabilityEnabled = false
	self.m_bCreepsEnabled = true

	self.i_broadcast_message_duration = 5.0

	local hNeutralSpawn = Entities:FindByName(nil, "neutral_caster_spawn")
	local hNeutralSpawnPos

	if hNeutralSpawn ~= nil then
		hNeutralSpawnPos = hNeutralSpawn:GetAbsOrigin()
	else
		hNeutralSpawnPos = Vector(0, 0, 256)
	end

	self.hNeutralCaster = CreateUnitByName("npc_dota_neutral_caster", hNeutralSpawnPos, false, nil, nil, DOTA_TEAM_GOODGUYS)

	require("components/demo/events")
end

function GameMode:BroadcastMsg(message, iDuration)
	if iDuration == nil then
		iDuration = GameMode.i_broadcast_message_duration
	elseif iDuration == -1 then
		iDuration = 99999
	end

	Notifications:BottomToAll({ text = message, duration = iDuration, style = { color = "white" } })
end
