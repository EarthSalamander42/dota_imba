if Diretide == nil then
	Diretide = class({})
end

require("components/diretide/announcer")
require("components/settings/settings_diretide")

function Diretide:Init()
	GoodCamera = CreateUnitByName("npc_dota_good_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
	BadCamera = CreateUnitByName("npc_dota_bad_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	local radiant_top_shrine_pos = Entities:FindByName(nil, "good_healer_6"):GetAbsOrigin()
	local dire_top_shrine_pos = Entities:FindByName(nil, "bad_healer_6"):GetAbsOrigin()

	Entities:FindByName(nil, "good_healer_6"):RemoveSelf()
	Entities:FindByName(nil, "bad_healer_6"):RemoveSelf()

	GoodCamera:SetAbsOrigin(radiant_top_shrine_pos)
	GoodCamera:RemoveModifierByName("modifier_invulnerable")
	BadCamera:SetAbsOrigin(dire_top_shrine_pos)
	BadCamera:RemoveModifierByName("modifier_invulnerable")


	Convars:RegisterCommand("hall_of_fame", function(keys) return TestEndScreenDiretide() end, "Test Duel Event", FCVAR_CHEAT)
end

function TestEndScreenDiretide()
	CustomGameEventManager:Send_ServerToAllClients("hall_of_fame", {})
end

ListenToGameEvent('game_rules_state_change', function(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		Diretide:Init()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Diretide:Countdown()

		-- failsafe in case hero selection didn't enabled the HUD after hero pick
		Timers:CreateTimer(AP_GAME_TIME + 5.0, function()
			CustomGameEventManager:Send_ServerToAllClients("diretide_phase", {Phase = Diretide.DIRETIDE_PHASE})
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		Diretide.COUNT_DOWN = true
		Diretide:Announcer("diretide", "game_in_progress")

		local buildings = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

		for _, building in pairs(buildings) do
			if string.find(building:GetName(), "tower2") or string.find(building:GetName(), "pumpkin") then
				building:AddAbility("diretide_pumpkin_immune"):SetLevel(1)
			end
		end
	end
end, nil)

function Diretide:Phase()
	local units = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

	if Diretide.DIRETIDE_PHASE == 2 then
		Diretide:Announcer("diretide", "phase_2")
	elseif Diretide.DIRETIDE_PHASE == 3 then
		local buildings = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _, building in pairs(buildings) do
			if string.find(building:GetName(), "tower") or string.find(building:GetName(), "pumpkin") then
				building:AddNewModifier(building, nil, "modifier_invulnerable", {})
			end
		end

		if CustomNetTables:GetTableValue("game_options", "dire").score > CustomNetTables:GetTableValue("game_options", "radiant").score then
			DIRETIDE_WINNER = 3
			Diretide:Announcer("diretide", "winner_dire")
		else
			Diretide:Announcer("diretide", "winner_radiant")
		end

		Diretide:SwapTeam(DIRETIDE_WINNER)

		local checkpoint_positions = {}
		checkpoint_positions[2] = Vector(615, -5110, 365)
		checkpoint_positions[3] = Vector(2300, -4100, 365)

		local good_checkpoint = CreateUnitByName("npc_dota_good_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
		local bad_checkpoint = CreateUnitByName("npc_dota_bad_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
		good_checkpoint:AddNewModifier(good_checkpoint, nil, "modifier_invulnerable", {})
		good_checkpoint:SetAbsOrigin(checkpoint_positions[2])
		bad_checkpoint:AddNewModifier(bad_checkpoint, nil, "modifier_invulnerable", {})
		bad_checkpoint:SetAbsOrigin(checkpoint_positions[3])
		AddFOWViewer(2, Entities:FindByName(nil, "good_healer_7"):GetAbsOrigin(), 550, 99999, false)
		AddFOWViewer(3, Entities:FindByName(nil, "good_healer_7"):GetAbsOrigin(), 550, 99999, false)
		GameRules:SetUseUniversalShopMode(true)

		local find_trees = GridNav:GetAllTreesAroundPoint(Entities:FindByName(nil, "good_healer_7"):GetAbsOrigin(), 1200, true)

		for _, tree in pairs(find_trees) do
			tree:CutDownRegrowAfter(99999, -1)
		end

		local ents = Entities:FindAllByName("lane_*")
		for _, ent in pairs(ents) do
			ent:RemoveSelf()
		end

		local jungles = Entities:FindAllByName("jungle_*")
		for _, ent in pairs(jungles) do
			ent:RemoveSelf()
		end

		for _, unit in pairs(units) do
			if unit:GetUnitLabel() == "npc_diretide_roshan" then
				print("Hi rosh!")
			elseif unit:IsCreep() then
				unit:RemoveSelf()						
			end
		end
	elseif Diretide.DIRETIDE_PHASE == 4 then
		Diretide:End()
	end

	local AImod = ROSHAN_ENT:FindModifierByName("modifier_imba_roshan_ai_diretide")
	if AImod then
		AImod:SetStackCount(Diretide.DIRETIDE_PHASE)
		ROSHAN_ENT:Interrupt()
	end


	CustomGameEventManager:Send_ServerToAllClients("diretide_phase", {Phase = Diretide.DIRETIDE_PHASE})
end

function Diretide:Countdown()
	Timers:CreateTimer(function()
		if Diretide.COUNT_DOWN == false then
			CustomGameEventManager:Send_ServerToAllClients("countdown", Diretide:ConvertTimer(Diretide.nCOUNTDOWNTIMER))

			return 1.0
		end

		if GameRules:State_Get() > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			return nil
		end

--		if Diretide.nCOUNTDOWNTIMER <= 30 then
--			CustomGameEventManager:Send_ServerToAllClients("time_remaining", broadcast_gametimer)
--		end

		if Diretide.nCOUNTDOWNTIMER <= 0 then
			if Diretide.DIRETIDE_REINCARNATING == false and CustomNetTables:GetTableValue("game_options", "radiant").score ~= CustomNetTables:GetTableValue("game_options", "dire").score then -- TIE
				Diretide.DIRETIDE_PHASE = Diretide.DIRETIDE_PHASE + 1

				if Diretide.DIRETIDE_PHASE == 2 then
					Diretide.nCOUNTDOWNTIMER = Diretide.nCOUNTDOWNTIMER + PHASE_TIME
				elseif Diretide.DIRETIDE_PHASE == 3 then
					Diretide.COUNT_DOWN = false
					Diretide.nCOUNTDOWNTIMER = Diretide.nCOUNTDOWNTIMER + 120
				end

				Diretide:Phase()
			end
		else
			Diretide.nCOUNTDOWNTIMER = Diretide.nCOUNTDOWNTIMER - 1
		end

		CustomGameEventManager:Send_ServerToAllClients("countdown", Diretide:ConvertTimer(Diretide.nCOUNTDOWNTIMER))

		return 1.0
	end)
end

function Diretide:ConvertTimer(time)
	local minutes = math.floor(time / 60)
	local seconds = time - (minutes * 60)
	local m10 = math.floor(minutes / 10)
	local m01 = minutes - (m10 * 10)
	local s10 = math.floor(seconds / 10)
	local s01 = seconds - (s10 * 10)
	local broadcast_gametimer = 
	{
		timer_minute_10 = m10,
		timer_minute_01 = m01,
		timer_second_10 = s10,
		timer_second_01 = s01,
	}

	return broadcast_gametimer
end

function UpdateRoshanBar(roshan, time)
	if GameRules:IsGamePaused() then
		return time
	else
		Timers:CreateTimer(function()
			CustomNetTables:SetTableValue("game_options", "roshan", {
				level = roshan:GetLevel(),
				HP = roshan:GetHealth(),
				HP_alt = roshan:GetHealthPercent(),
				maxHP = roshan:GetMaxHealth()
			})
			return time
		end)
	end
end

--	function OverrideDiretideCreeps()
--		ListenToGameEvent("npc_spawned", function(event)
--			local npc = EntIndexToHScript(keys.entindex)
--			if npc then
--				
--			end
--		end, nil)
--	end

function Diretide:SwapTeam(team)
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), ROSHAN_ENT)
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if not hero:IsIllusion() then
			hero:RespawnHero(false, false)
			hero:SetHealth(hero:GetMaxHealth())
			hero:SetMana(hero:GetMaxMana())
			hero:Stop()
			hero:ModifyGold(DIRETIDE_BONUS_GOLD, true, 0)
			hero:AddExperience(100000, false, false)
			hero:AddNewModifier(hero, nil, "modifier_no_pvp", {})
		end
	end

	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(0)
end

function Diretide:IncreaseTimer(time)
	Diretide.nCOUNTDOWNTIMER = Diretide.nCOUNTDOWNTIMER + time

	CustomGameEventManager:Send_ServerToAllClients("countdown", Diretide:ConvertTimer(Diretide.nCOUNTDOWNTIMER))
end

function Diretide:EndRoshanCamera()
local i = 1

--	ROSHAN_ENT:SetTeam(4)

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
		hero:RemoveModifierByName("modifier_command_restricted")

		Timers:CreateTimer(1.0, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
			return 1.0
		end)
	end
end

function Diretide:End()
	Diretide.COUNT_DOWN = false
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_invulnerable", {})
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_command_restricted", {})

	local level = ROSHAN_ENT:GetLevel()

	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
		api.imba.diretide_update_levels(level)
	end

	if DIRETIDE_WINNER == 2 then
		Entities:FindByName(nil, "dota_badguys_fort"):ForceKill(false)
	else
		Entities:FindByName(nil, "dota_goodguys_fort"):ForceKill(false)
	end

--	for _, hero in pairs(HeroList:GetAllHeroes()) do
--		hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
--		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
--		hero:SetRespawnsDisabled(true)
--		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), ROSHAN_ENT)
--	end

--	Timers:CreateTimer(function()
--		CustomGameEventManager:Send_ServerToAllClients("hall_of_fame", {})
--
--		return 1.0
--	end)
end

function Diretide:OnEntityKilled(killer, victim)
	if victim:GetTeamNumber() == 4 then
		if victim:GetUnitLabel() == "npc_diretide_roshan" or victim:GetUnitName() == "npc_imba_roshling" then return end
		local chance = RandomInt(1, 100)
		if chance > 50 then -- 50% chance
			Diretide:CreateCandy(victim:GetAbsOrigin())
		end
	elseif string.find(victim:GetUnitName(), "dota_creep") then
		local chance = RandomInt(1, 100)
		if chance > 90 then -- 10% chance
			Diretide:CreateCandy(victim:GetAbsOrigin())
		end
	else
		if victim:IsRealHero() then
			if victim:FindItemByName("item_diretide_candy", false) then
				for i = 1, victim:FindItemByName("item_diretide_candy", false):GetCurrentCharges() do
					Timers:CreateTimer(FrameTime(), function()
						Diretide:CreateCandy(victim:GetAbsOrigin())
					end)
				end

				victim:RemoveItem(victim:FindItemByName("item_diretide_candy", false))
			end

			victim:SetTimeUntilRespawn(victim:GetTimeUntilRespawn() / 2)
		end
	end
end

-- Pumpkin ability
function Pumpkin(keys)
local caster = keys.caster
local attacker = keys.attacker
local ability = keys.ability

	if attacker:IsRealHero() or attacker:IsConsideredHero() then
		HIT_COUNT[caster:GetTeamNumber()] = HIT_COUNT[caster:GetTeamNumber()] + 1
		if attacker:HasModifier("modifier_earthshaker_enchant_totem") then
			print("Earthshaker angry!")
			HIT_COUNT[caster:GetTeamNumber()] = HIT_COUNT[caster:GetTeamNumber()] + 1
		end
	end

	if HIT_COUNT[caster:GetTeamNumber()] >= 4 then
		HIT_COUNT[caster:GetTeamNumber()] = 0
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_FLINCH, rate=1.0})
		if caster:GetUnitName() == "npc_dota_good_candy_pumpkin" and CustomNetTables:GetTableValue("game_options", "radiant").score > 0 then
			Diretide:CreateCandy(caster:GetAbsOrigin())
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score -1})
		elseif caster:GetUnitName() == "npc_dota_bad_candy_pumpkin" and CustomNetTables:GetTableValue("game_options", "dire").score > 0 then
			Diretide:CreateCandy(caster:GetAbsOrigin())
			CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score -1})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_good" and CustomNetTables:GetTableValue("game_options", "radiant").score <= 0 then
			CustomNetTables:SetTableValue("game_options", "radiant", {score = 0})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_bad" and CustomNetTables:GetTableValue("game_options", "dire").score <= 0 then
			CustomNetTables:SetTableValue("game_options", "dire", {score = 0})
		end
	end
end

-- utils

function Diretide:CreateCandy(pos)
	local item = CreateItem("item_diretide_candy", nil, nil)
	CreateItemOnPositionSync(pos, item)
	local random_pos = pos + RandomVector(RandomInt(150, 300))
	item:LaunchLoot(false, 300, 0.5, random_pos)
	item:EmitSound("Item.DropGemWorld")

	local find_trees = GridNav:GetAllTreesAroundPoint(random_pos, 100, true)

	for _, tree in pairs(find_trees) do
		tree:CutDownRegrowAfter(99999, -1)
	end
end
