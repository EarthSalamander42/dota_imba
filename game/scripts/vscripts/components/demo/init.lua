if not IsInToolsMode() and not GameRules:IsCheatMode() and GetMapName() ~= "imba_demo" then
	return
end

if HeroDemo == nil then
	_G.HeroDemo = class({}) -- put HeroDemo in the global scope
	--refer to: http://stackoverflow.com/questions/6586145/lua-require-with-global-local
end

require("components/demo/events")

LinkLuaModifier("lm_take_no_damage", "hero_demo/demo_core.lua", LUA_MODIFIER_MOTION_NONE)
lm_take_no_damage = lm_take_no_damage or class({})

function lm_take_no_damage:DeclareFunctions() return { MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE } end

function lm_take_no_damage:GetTexture() return "modifier_invulnerable" end

function lm_take_no_damage:GetAbsoluteNoDamageMagical(params) return 1 end

function lm_take_no_damage:GetAbsoluteNoDamagePhysical(params) return 1 end

function lm_take_no_damage:GetAbsoluteNoDamagePure(params) return 1 end

ListenToGameEvent("game_rules_state_change", function()
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		HeroDemo:Init()
	end
end, nil)

function HeroDemo:Init()
	sHeroSelection = GameRules:GetGameSessionConfigValue("demo_hero_name", "default_value")

	GameRules:SetUseUniversalShopMode(true)

	CustomGameEventManager:RegisterListener("RequestInitialSpawnHeroID", function(...) return self:OnRequestInitialSpawnHeroID(...) end)

	CustomGameEventManager:RegisterListener("WelcomePanelDismissed", function(...) return self:OnWelcomePanelDismissed(...) end)
	CustomGameEventManager:RegisterListener("RefreshButtonPressed", function(...) return self:OnRefreshButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("LevelUpButtonPressed", function(...) return self:OnLevelUpButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("UltraMaxLevelButtonPressed", function(...) return self:OnUltraMaxLevelButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("FreeSpellsButtonPressed", function(...) return self:OnFreeSpellsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("CombatLogButtonPressed", function(...) return self:CombatLogButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("SelectMainHeroButtonPressed", function(...) return self:OnSelectMainHeroButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SelectSpawnHeroButtonPressed", function(...) return self:OnSelectSpawnHeroButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnEnemyButtonPressed", function(...) return self:OnSpawnEnemyButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnAllyButtonPressed", function(...) return self:OnSpawnAllyButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("RemoveHeroButtonPressed", function(...) return self:OnRemoveHeroButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("LevelUpHero", function(...) return self:OnLevelUpHero(...) end)
	CustomGameEventManager:RegisterListener("MaxLevelUpHero", function(...) return self:OnMaxLevelUpHero(...) end)
	CustomGameEventManager:RegisterListener("ScepterHero", function(...) return self:OnScepterHero(...) end)
	CustomGameEventManager:RegisterListener("ShardHero", function(...) return self:OnShardHero(...) end)
	CustomGameEventManager:RegisterListener("ResetHero", function(...) return self:OnResetHero(...) end)
	CustomGameEventManager:RegisterListener("ToggleInvulnerabilityHero", function(...) return self:OnSetInvulnerabilityHero(nil, ...) end)
	CustomGameEventManager:RegisterListener("InvulnOnHero", function(...) return self:OnSetInvulnerabilityHero(true, ...) end)
	CustomGameEventManager:RegisterListener("InvulnOffHero", function(...) return self:OnSetInvulnerabilityHero(false, ...) end)

	CustomGameEventManager:RegisterListener("DummyTargetButtonPressed", function(...) return self:OnDummyTargetButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("ChangeHeroButtonPressed", function(...) return self:OnChangeHeroButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("ChangeCosmeticsButtonPressed", function(...) return self:OnChangeCosmeticsButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("SpawnCreepsButtonPressed", function(...) return self:OnSpawnCreepsButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnSingleCreepWaveButtonPressed", function(...) return self:OnSpawnSingleCreepWaveButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("TowersEnabledButtonPressed", function(...) return self:OnTowersEnabledButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("PauseButtonPressed", function(...) return self:OnPauseButtonPressed(...) end)
	CustomGameEventManager:RegisterListener("LeaveButtonPressed", function(...) return self:OnLeaveButtonPressed(...) end)

	CustomGameEventManager:RegisterListener("SpawnRuneDoubleDamagePressed", function(...) return self:OnSpawnRuneDoubleDamagePressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnRuneHastePressed", function(...) return self:OnSpawnRuneHastePressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnRuneIllusionPressed", function(...) return self:OnSpawnRuneIllusionPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnRuneInvisibilityPressed", function(...) return self:OnSpawnRuneInvisibilityPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnRuneRegenerationPressed", function(...) return self:OnSpawnRuneRegenerationPressed(...) end)
	CustomGameEventManager:RegisterListener("SpawnRuneArcanePressed", function(...) return self:OnSpawnRuneArcanePressed(...) end)

	local sHeroToSpawn = Convars:GetStr("dota_hero_demo_default_enemy")

	if sHeroToSpawn then
		GameRules:GetGameModeEntity():SetCustomGameForceHero(sHeroToSpawn)
		GameRules:SetHeroSelectionTime(0.0)
		GameRules:SetPreGameTime(0.0)
		GameRules:SetStrategyTime(0.0)
		GameRules:SetShowcaseTime(0.0)
	end

	if Convars:GetInt("dota_hero_demo_spawn_creeps_enabled") == 1 then
		-- print("Starting demo mode with creeps spawning")
		SendToServerConsole("dota_creeps_no_spawning 0")
	else
		-- print("Starting demo mode with no creeps spawning")
		SendToServerConsole("dota_creeps_no_spawning 1")
	end

	self:FindTowers()
	if Convars:GetInt("dota_hero_demo_towers_enabled") == 1 then
		-- print("Starting demo mode with towers")
		self:SetTowersEnabled(true)
	else
		-- print("Starting demo mode with no towers")
		self:SetTowersEnabled(false)
	end

	SendToServerConsole("dota_easybuy 1")
	--SendToServerConsole( "dota_bot_mode 1" )

	self.m_sHeroSelection = sHeroSelection -- this seems redundant, but events.lua doesn't seem to know about sHeroSelection

	self.m_bPlayerDataCaptured = false
	self.m_nPlayerID = 0

	--self.m_nHeroLevelBeforeMaxing = 1 -- unused now
	--self.m_bHeroMaxedOut = false -- unused now

	self.m_nPlayerEntIndex = -1

	self.m_nALLIES_TEAM = 2

	self.m_nENEMIES_TEAM = 3

	self.m_bFreeSpellsEnabled = false
	self.m_bInvulnerabilityEnabled = false

	CustomNetTables:SetTableValue("game_options", "ui_defaults",
		{
			WTFEnabled = Convars:GetInt("dota_ability_debug"),
			SpawnCreepsEnabled = Convars:GetInt("dota_hero_demo_spawn_creeps_enabled"),
			TowersEnabled = Convars:GetInt("dota_hero_demo_towers_enabled")
		}
	)
end

--------------------------------------------------------------------------------
-- Think_InitializePlayerHero
--------------------------------------------------------------------------------
function HeroDemo:Think_InitializePlayerHero(hPlayerHero)
	if not hPlayerHero then
		return 0.1
	end

	hPlayerHero:GetPlayerOwner():CheckForCourierSpawning(hPlayerHero)

	if self.m_bPlayerDataCaptured == false then
		if hPlayerHero:GetUnitName() == self.m_sHeroSelection then
			local nPlayerID = hPlayerHero:GetPlayerOwnerID()
			PlayerResource:ModifyGold(nPlayerID, 99999, true, 0)
			self.m_bPlayerDataCaptured = true
		end
	end

	-- TODO - support this!
	if self.m_bInvulnerabilityEnabled then
		local hAllPlayerUnits = {}
		hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
		hAllPlayerUnits[#hAllPlayerUnits + 1] = hPlayerHero

		for _, hUnit in pairs(hAllPlayerUnits) do
			hUnit:AddNewModifier(hPlayerHero, nil, "lm_take_no_damage", nil)
		end
	end

	return
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnWelcomePanelDismissed
--------------------------------------------------------------------------------
function HeroDemo:OnWelcomePanelDismissed(event)
	--print( "Entering HeroDemo:OnWelcomePanelDismissed( event )" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnRefreshButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnRefreshButtonPressed(eventSourceIndex)
	SendToServerConsole("dota_dev hero_refresh")

	EmitGlobalSound("UI.Button.Pressed")

	--self:BroadcastMsg( "#Refresh_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnLevelUpButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnLevelUpButtonPressed(eventSourceIndex)
	SendToServerConsole("dota_dev hero_level 1")

	EmitGlobalSound("UI.Button.Pressed")

	--self:BroadcastMsg( "#LevelUp_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnUltraMaxLevelButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnUltraMaxLevelButtonPressed(eventSourceIndex, data)
	print('ULTRA MAX!')

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	HeroMaxLevel(hPlayerHero)

	if not hPlayerHero:FindModifierByName("modifier_item_aghanims_shard") then
		hPlayerHero:AddItemByName("item_aghanims_shard")
	end

	if not hPlayerHero:FindModifierByName("modifier_item_ultimate_scepter_consumed") then
		hPlayerHero:AddItemByName("item_ultimate_scepter_2")
	end

	EmitGlobalSound("UI.Button.Pressed")

	--self:BroadcastMsg( "#MaxLevel_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnFreeSpellsButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnFreeSpellsButtonPressed(eventSourceIndex)
	local nWTFEnabledEnabled = Convars:GetInt("dota_ability_debug")

	if nWTFEnabledEnabled == 0 then
		print("Enabling WTF")
		Convars:SetInt("dota_ability_debug", 1)
		self.m_bFreeSpellsEnabled = true
		SendToServerConsole("dota_dev hero_refresh")
		self:BroadcastMsg("#FreeSpellsOn_Msg")
	elseif nWTFEnabledEnabled == 1 then
		print("Disabling WTF")
		Convars:SetInt("dota_ability_debug", 0)
		self.m_bFreeSpellsEnabled = false
		self:BroadcastMsg("#FreeSpellsOff_Msg")
	end

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: CombatLogButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:CombatLogButtonPressed(eventSourceIndex)
	SendToServerConsole("dota_toggle_combatlog")
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSetInvulnerabilityHero
--------------------------------------------------------------------------------
function HeroDemo:OnSetInvulnerabilityHero(bInvuln, eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnSetInvulnerabilityHero! - found hero with ent index = ' .. nHeroEntIndex)

		local hAllUnits = {}
		if hHero:IsRealHero() then
			hAllUnits = hHero:GetAdditionalOwnedUnits()
		end
		table.insert(hAllUnits, hHero)

		if bInvuln == nil then
			bInvuln = hHero:FindModifierByName("lm_take_no_damage") == nil
		end

		if bInvuln then
			for _, hUnit in pairs(hAllUnits) do
				print('Adding INVULN modifier to entindex ' .. hUnit:GetEntityIndex() .. ' - ' .. hUnit:GetUnitName())
				hUnit:AddNewModifier(hHero, nil, "lm_take_no_damage", nil)
			end
		else
			for _, hUnit in pairs(hAllUnits) do
				print('Removing INVULN modifier to ' .. hUnit:GetUnitName())
				hUnit:RemoveModifierByName("lm_take_no_damage")
			end
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnEnemyButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnEnemyButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	local hPlayer = PlayerResource:GetPlayer(data.PlayerID)

	local sHeroToSpawn = Convars:GetStr("dota_hero_demo_default_enemy")

	DebugCreateUnit(hPlayer, sHeroToSpawn, self.m_nENEMIES_TEAM, false,
		function(hEnemy)
			hEnemy:SetControllableByPlayer(self.m_nPlayerID, false)
			hEnemy:SetRespawnPosition(hPlayerHero:GetAbsOrigin())
			FindClearSpaceForUnit(hEnemy, hPlayerHero:GetAbsOrigin(), false)
			hEnemy:Hold()
			hEnemy:SetIdleAcquire(false)
			hEnemy:SetAcquisitionRange(0)
			self:BroadcastMsg("#SpawnEnemy_Msg")
		end)

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- RequestInitialSpawnHeroID
--------------------------------------------------------------------------------
function HeroDemo:OnRequestInitialSpawnHeroID(eventSourceIndex, data)
	local sHeroToSpawn = Convars:GetStr("dota_hero_demo_default_enemy")
	local nHeroID = DOTAGameManager:GetHeroIDByName(sHeroToSpawn)
	local event_data =
	{
		hero_id = nHeroID,
		hero_name = sHeroToSpawn
	}
	CustomGameEventManager:Send_ServerToAllClients("set_spawn_hero_id", event_data)
end

--------------------------------------------------------------------------------
-- ButtonEvent: SelectMainHeroButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSelectMainHeroButtonPressed(eventSourceIndex, data)
	print('OnSelectMainHeroButtonPressed! - data.str = ' .. data.str)
	local sHero = data.str
	--EmitGlobalSound( "UI.Button.Pressed" )

	-- print('MAIN HERO PICK!')

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	PlayerResource:ReplaceHeroWith(hPlayerHero:GetPlayerOwnerID(), sHero, 0, 0)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("terrible_fix"), function()
		if hPlayerHero then
			UTIL_Remove(hPlayerHero)
		end

		return nil
	end, FrameTime())

	local event_data = {
		hero_name = sHero
	}
	CustomGameEventManager:Send_ServerToAllClients("set_main_hero_id", event_data)
end

--------------------------------------------------------------------------------
-- ButtonEvent: SelectSpawnHeroButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSelectSpawnHeroButtonPressed(eventSourceIndex, data)
	local sHeroToSpawn = DOTAGameManager:GetHeroUnitNameByID(tonumber(data.str))
	Convars:SetStr("dota_hero_demo_default_enemy", sHeroToSpawn)
	--EmitGlobalSound( "UI.Button.Pressed" )

	print('SPAWN HERO PICK!')

	local event_data =
	{
		hero_id = tonumber(data.str),
		hero_name = sHeroToSpawn
	}
	CustomGameEventManager:Send_ServerToAllClients("set_spawn_hero_id", event_data)
end

--------------------------------------------------------------------------------
-- ButtonEvent: RemoveHeroButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnRemoveHeroButtonPressed(eventSourceIndex, data)
	print('OnRemoveHeroButtonPressed! - data.str = ' .. data.str)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)

	if (hHero ~= nil and hHero:IsNull() == false and hHero ~= PlayerResource:GetSelectedHeroEntity(0)) then
		print('OnRemoveHeroButtonPressed! - found hero with ent index = ' .. nHeroEntIndex)
		if hHero:IsHero() and hHero:GetPlayerOwner() ~= nil and hHero:GetPlayerOwnerID() ~= 0 then
			local nPlayerID = hHero:GetPlayerID()
			-- TODO - kill all clones that are attached
			DisconnectClient(nPlayerID, true)
		else
			hHero:Destroy()
		end

		local event_data =
		{
			entindex = nHeroEntIndex
		}
		CustomGameEventManager:Send_ServerToAllClients("remove_hero_entry", event_data)
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: LevelUpHero
--------------------------------------------------------------------------------
function HeroDemo:OnLevelUpHero(eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnLevelUpHero! - found hero with ent index = ' .. nHeroEntIndex)
		if hHero.HeroLevelUp then
			hHero:HeroLevelUp(true)
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: MaxLevelUpHero
--------------------------------------------------------------------------------
function HeroDemo:OnMaxLevelUpHero(eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnMaxLevelUpHero! - found hero with ent index = ' .. nHeroEntIndex)

		if hHero.AddExperience then
			hHero:AddExperience(599000, false, false) -- for some reason maxing your level this way fixes the bad interaction with OnHeroReplaced

			for i = 0, DOTA_MAX_ABILITIES - 1 do
				local hAbility = hHero:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsAttributeBonus() then
					while hAbility:GetLevel() < hAbility:GetMaxLevel() and hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED and not hAbility:IsHidden() do
						hHero:UpgradeAbility(hAbility)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ScepterHero
--------------------------------------------------------------------------------
function HeroDemo:OnScepterHero(eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnScepterHero! - found hero with ent index = ' .. nHeroEntIndex)

		if not hHero:FindModifierByName("modifier_item_ultimate_scepter_consumed") then
			hHero:AddItemByName("item_ultimate_scepter_2")
		else
			hHero:RemoveModifierByName("modifier_item_ultimate_scepter_consumed")
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ShardHero
--------------------------------------------------------------------------------
function HeroDemo:OnShardHero(eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnShardHero! - found hero with ent index = ' .. nHeroEntIndex)

		if not hHero:FindModifierByName("modifier_item_aghanims_shard") then
			hHero:AddItemByName("item_aghanims_shard")
		else
			hHero:RemoveModifierByName("modifier_item_aghanims_shard")
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: ResetHero
--------------------------------------------------------------------------------
function HeroDemo:OnResetHero(eventSourceIndex, data)
	local nHeroEntIndex = tonumber(data.str)
	local hHero = EntIndexToHScript(nHeroEntIndex)
	if (hHero ~= nil and hHero:IsNull() == false) then
		print('OnResetHero! - found hero with ent index = ' .. nHeroEntIndex)
		GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept(true)
		PlayerResource:ReplaceHeroWithNoTransfer(hHero:GetPlayerOwnerID(), hHero:GetUnitName(), -1, 0)
		GameRules:SetSpeechUseSpawnInsteadOfRespawnConcept(false)
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: SpawnAllyButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnAllyButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	local hPlayer = PlayerResource:GetPlayer(data.PlayerID)

	local sHeroToSpawn = Convars:GetStr("dota_hero_demo_default_enemy")

	DebugCreateUnit(hPlayer, sHeroToSpawn, self.m_nALLIES_TEAM, false,
		function(hAlly)
			hAlly:SetControllableByPlayer(self.m_nPlayerID, false)
			hAlly:SetRespawnPosition(hPlayerHero:GetAbsOrigin())
			FindClearSpaceForUnit(hAlly, hPlayerHero:GetAbsOrigin(), false)
			hAlly:Hold()
			hAlly:SetIdleAcquire(false)
			hAlly:SetAcquisitionRange(0)
			self:BroadcastMsg("#SpawnAlly_Msg")
		end)

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnDummyTargetButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnDummyTargetButtonPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	local hDummy = CreateUnitByName("npc_dota_hero_target_dummy", hPlayerHero:GetAbsOrigin(), true, nil, nil, self.m_nENEMIES_TEAM)
	hDummy:SetAbilityPoints(0)
	hDummy:SetControllableByPlayer(self.m_nPlayerID, false)
	hDummy:Hold()
	hDummy:SetIdleAcquire(false)
	hDummy:SetAcquisitionRange(0)

	EmitGlobalSound("UI.Button.Pressed")

	--self:BroadcastMsg( "#SpawnDummyTarget_Msg" )
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnTowersEnabledButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnTowersEnabledButtonPressed(eventSourceIndex)
	local nTowersEnabledEnabled = Convars:GetInt("dota_hero_demo_towers_enabled")

	if nTowersEnabledEnabled == 0 then
		print("Enabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 1)
		self:SetTowersEnabled(true)
		self:BroadcastMsg("#TowersEnabledOn_Msg")
	elseif nTowersEnabledEnabled == 1 then
		print("Disabling Towers")
		Convars:SetInt("dota_hero_demo_towers_enabled", 0)
		self:SetTowersEnabled(false)
		self:BroadcastMsg("#TowersEnabledOff_Msg")
	end

	EmitGlobalSound("UI.Button.Pressed")
end

function HeroDemo:SetTowersEnabled(bEnabled)
	-- print("SetTowersEnabled: " .. tostring(bEnabled))
	for _, tTower in pairs(self.m_rgTowers) do
		local hTower = tTower.hUnit

		if hTower ~= nil and not hTower:IsNull() then
			if not hTower:IsAlive() and hTower:UnitCanRespawn() then
				-- print(" respawning " .. tTower.sName)
				hTower:SetOriginalModel(tTower.sOriginalModel)
				hTower:RespawnUnit()
				hTower:RemoveModifierByName("modifier_invulnerable")
			end

			-- print(" enabling " .. tTower.sName .. " " .. tostring(bEnabled))
			if bEnabled then
				hTower:RemoveModifierByName("modifier_invulnerable")
			else
				hTower:AddNewModifier(hTower, nil, "modifier_invulnerable", {})
			end
		end
	end
end

function HeroDemo:FindTowers()
	self.m_rgTowers = {}
	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(units) do
		if hUnit:IsTower() then
			local tTower = {
				hUnit = hUnit,
				sName = hUnit:GetUnitName(),
				sOriginalModel = hUnit:GetModelName()
			}
			hUnit:SetUnitCanRespawn(true)
			self.m_rgTowers[#self.m_rgTowers + 1] = tTower
			--[[if hUnit:GetUnitName() == "npc_dota_goodguys_tower1_mid" then
				hUnit:SetUnitCanRespawn( true )
				self.m_rgTowers[1] = tTower
			elseif hUnit:GetUnitName() == "npc_dota_badguys_tower1_mid" then
				hUnit:SetUnitCanRespawn( true )
				self.m_rgTowers[2] = tTower
			end]]
		end
	end
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnCreepsButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnCreepsButtonPressed(eventSourceIndex)
	local nSpawnCreepsEnabled = Convars:GetInt("dota_hero_demo_spawn_creeps_enabled")

	if nSpawnCreepsEnabled == 0 then
		print("Enabling Creep Spawns")
		SendToServerConsole("dota_creeps_no_spawning 0")
		SendToServerConsole("dota_spawn_creeps")
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 1)
		self:BroadcastMsg("#SpawnCreepsOn_Msg")
	elseif nSpawnCreepsEnabled == 1 then
		print("Disabling Creep Spawns")
		self:RemoveCreeps()
		SendToServerConsole("dota_creeps_no_spawning 1")
		Convars:SetInt("dota_hero_demo_spawn_creeps_enabled", 0)
		self:BroadcastMsg("#SpawnCreepsOff_Msg")
	end

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnSingleCreepWaveButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnSingleCreepWaveButtonPressed(eventSourceIndex)
	SendToServerConsole("dota_spawn_creeps")
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------

function HeroDemo:RemoveCreeps()
	print("Removing Creeps")
	local nInclusiveTypeFlags = DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, nInclusiveTypeFlags, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(units) do
		if hUnit:IsCreep() and not hUnit:IsControllableByAnyPlayer() then
			hUnit:Destroy()
		end
	end
end

--------------------------------------------------------------------------------
-- SpawnRuneInFrontOfUnit - Helper method for rune spawning
--------------------------------------------------------------------------------
function HeroDemo:SpawnRuneInFrontOfUnit(hUnit, runeType)
	if hUnit == nil then
		return
	end

	local fDistance = 200.0
	local fMinSeparation = 50.0
	local fRingOffset = fMinSeparation + 20.0
	local vDir = hUnit:GetForwardVector()
	local vInitialTarget = hUnit:GetAbsOrigin() + vDir * fDistance
	vInitialTarget.z = GetGroundHeight(vInitialTarget, nil)
	local vTarget = vInitialTarget
	local nRemainingAttempts = 100
	local fAngle = 2 * math.pi
	local fOffset = 0.0
	local bDone = false

	local vecRunes = Entities:FindAllByClassname("dota_item_rune")
	while (not bDone and nRemainingAttempts > 0) do
		bDone = true
		-- Too close to other runes?
		for i = 1, #vecRunes do
			if (vecRunes[i]:GetAbsOrigin() - vTarget):Length() < fMinSeparation then
				bDone = false
				break
			end
		end
		if not GridNav:CanFindPath(hUnit:GetAbsOrigin(), vTarget) then
			bDone = false
		end
		if not bDone then
			fAngle = fAngle + 2 * math.pi / 8
			if fAngle >= 2 * math.pi then
				fOffset = fOffset + fRingOffset
				fAngle = 0
			end
			vTarget = vInitialTarget + fOffset * Vector(math.cos(fAngle), math.sin(fAngle), 0.0)
			vTarget.z = GetGroundHeight(vTarget, nil)
		end
		nRemainingAttempts = nRemainingAttempts - 1
	end

	CreateRune(vTarget, runeType)
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneDoubleDamagePressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneDoubleDamagePressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_DOUBLEDAMAGE)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneHastePressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneHastePressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_HASTE)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneIllusionPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneIllusionPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_ILLUSION)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneInvisibilityPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneInvisibilityPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_INVISIBILITY)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------

function HeroDemo:GetRuneSpawnLocation()

end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneRegenerationPressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneRegenerationPressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_REGENERATION)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- ButtonEvent: OnSpawnRuneArcanePressed
--------------------------------------------------------------------------------
function HeroDemo:OnSpawnRuneArcanePressed(eventSourceIndex, data)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	if hPlayerHero == nil then
		return
	end

	self:SpawnRuneInFrontOfUnit(hPlayerHero, DOTA_RUNE_ARCANE)
	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeCosmeticsButtonPresse
--------------------------------------------------------------------------------
function HeroDemo:OnChangeCosmeticsButtonPressed(eventSourceIndex)
	-- currently running the command directly in XML, should run it here if possible
	-- can use GetSelectedHeroID

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- GameEvent: OnChangeHeroButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnChangeHeroButtonPressed(eventSourceIndex, data)
	-- currently running the command directly in XML, should run it here if possible
	local nHeroID = PlayerResource:GetSelectedHeroID(data.PlayerID)
	print("PlayerResource:GetSelectedHeroID( data.PlayerID ) == " .. nHeroID)

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- GameEvent: OnPauseButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnPauseButtonPressed(eventSourceIndex)
	SendToServerConsole("dota_pause")

	EmitGlobalSound("UI.Button.Pressed")
end

--------------------------------------------------------------------------------
-- GameEvent: OnLeaveButtonPressed
--------------------------------------------------------------------------------
function HeroDemo:OnLeaveButtonPressed(eventSourceIndex)
	EmitGlobalSound("UI.Button.Pressed")

	SendToServerConsole("disconnect")
end

function HeroDemo:BroadcastMsg(sMsg)
	-- Display a message about the button action that took place
	local buttonEventMessage = sMsg
	--print( buttonEventMessage )
	local centerMessage = {
		message = buttonEventMessage,
		duration = 1.0,
		clearQueue = true -- this doesn't seem to work
	}
	FireGameEvent("show_center_message", centerMessage)
end
