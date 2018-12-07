LinkLuaModifier("components/modifiers/demo/lm_take_no_damage", LUA_MODIFIER_MOTION_NONE)

function GameMode:InitDemo()
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )
	GameRules:GetGameModeEntity():SetFixedRespawnTime( 4 )
--	GameRules:GetGameModeEntity():SetBotThinkingEnabled( true ) -- the ConVar is currently disabled in C++
	-- Set bot mode difficulty: can try GameRules:GetGameModeEntity():SetCustomGameDifficulty( 1 )

--	All these not working, called too early?
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetPreGameTime( 0 )
	GameRules:SetCustomGameSetupTimeout( 0 ) -- skip the custom team UI with 0, or do indefinite duration with -1
	PRE_GAME_TIME = 10.0

	-- Events
	CustomGameEventManager:RegisterListener( "WelcomePanelDismissed", function(...) return self:OnWelcomePanelDismissed( ... ) end )
	CustomGameEventManager:RegisterListener( "RefreshButtonPressed", function(...) return self:OnRefreshButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LevelUpButtonPressed", function(...) return self:OnLevelUpButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "MaxLevelButtonPressed", function(...) return self:OnMaxLevelButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "FreeSpellsButtonPressed", function(...) return self:OnFreeSpellsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "InvulnerabilityButtonPressed", function(...) return self:OnInvulnerabilityButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "SpawnAllyButtonPressed", function(...) return self:OnSpawnAllyButtonPressed( ... ) end ) -- deprecated
	CustomGameEventManager:RegisterListener( "SpawnEnemyButtonPressed", function(...) return self:OnSpawnEnemyButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LevelUpEnemyButtonPressed", function(...) return self:OnLevelUpEnemyButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "DummyTargetButtonPressed", function(...) return self:OnDummyTargetButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "RemoveSpawnedUnitsButtonPressed", function(...) return self:OnRemoveSpawnedUnitsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LaneCreepsButtonPressed", function(...) return self:OnLaneCreepsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "ChangeHeroButtonPressed", function(...) return self:OnChangeHeroButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "ChangeCosmeticsButtonPressed", function(...) return self:OnChangeCosmeticsButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "PauseButtonPressed", function(...) return self:OnPauseButtonPressed( ... ) end )
	CustomGameEventManager:RegisterListener( "LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed( ... ) end )

	SendToServerConsole( "sv_cheats 1" )
	SendToServerConsole( "dota_hero_god_mode 0" )
	SendToServerConsole( "dota_ability_debug 0" )
	SendToServerConsole( "dota_creeps_no_spawning 0" )
	SendToServerConsole( "dota_easybuy 1" )
--	SendToServerConsole( "dota_bot_mode 1" )

	self.m_bPlayerDataCaptured = false
	self.m_nPlayerID = 0

--	self.m_nHeroLevelBeforeMaxing = 1 -- unused now
--	self.m_bHeroMaxedOut = false -- unused now

	self.m_nALLIES_TEAM = 2
	self.m_tAlliesList = {}
	self.m_nAlliesCount = 0

	self.m_nENEMIES_TEAM = 3
	self.m_tEnemiesList = {}

	self.m_bFreeSpellsEnabled = false
	self.m_bInvulnerabilityEnabled = false
	self.m_bCreepsEnabled = true

	self.i_broadcast_message_duration = 5.0

--	local hNeutralSpawn = Entities:FindByName( nil, "neutral_caster_spawn" )
--	if ( hNeutralSpawn == NIL ) then
--		hNeutralSpawn = Entities:CreateByClassname( "info_target" );
--	end

--	self.hNeutralCaster = CreateUnitByName( "npc_dota_neutral_caster", hNeutralSpawn:GetAbsOrigin(), false, nil, nil, NEUTRAL_TEAM )
end

function GameMode:BroadcastMsg(message)
	Notifications:BottomToAll({ text = message, duration = GameMode.i_broadcast_message_duration, style = {color = "white"}})
end

require("components/demo/events")
