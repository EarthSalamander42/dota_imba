if Diretide == nil then
	Diretide = class({})
end

require("components/diretide/announcer")

function Diretide:Init()
	good_pumpkin = CreateUnitByName("npc_dota_good_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
	bad_pumpkin = CreateUnitByName("npc_dota_bad_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_BADGUYS)

	local radiant_top_shrine_pos = Entities:FindByName(nil, "good_healer_6"):GetAbsOrigin()
	local dire_top_shrine_pos = Entities:FindByName(nil, "bad_healer_6"):GetAbsOrigin()

	Entities:FindByName(nil, "good_healer_6"):RemoveSelf()
	Entities:FindByName(nil, "bad_healer_6"):RemoveSelf()

	good_pumpkin:SetAbsOrigin(radiant_top_shrine_pos)
	good_pumpkin:RemoveModifierByName("modifier_invulnerable")
	bad_pumpkin:SetAbsOrigin(dire_top_shrine_pos)
	bad_pumpkin:RemoveModifierByName("modifier_invulnerable")
end

function Diretide:Start()
	Diretide:Announcer("diretide", "game_in_progress")
	nCOUNTDOWNTIMER = PHASE_TIME -- 481 / 8 Min
	DIRETIDE_PHASE = 1
	Diretide:Phase(DIRETIDE_PHASE)
	Diretide:Countdown()

	local buildings = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _, building in pairs(buildings) do
		if string.find(building:GetName(), "tower") or string.find(building:GetName(), "pumpkin") then
			building:AddAbility("diretide_pumpkin_immune"):SetLevel(1)
		end
	end
end

function Diretide:Phase(DIRETIDE_PHASE)
local units = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

	if DIRETIDE_PHASE == 2 then
		Diretide:Announcer("diretide", "phase_2")
		nCOUNTDOWNTIMER = PHASE_TIME
	elseif DIRETIDE_PHASE == 3 then
		nCOUNTDOWNTIMER = 120
		EnableCountdown(false)

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

		SwapTeam(DIRETIDE_WINNER)

		local good_checkpoint = CreateUnitByName("npc_dota_good_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_GOODGUYS)
		local bad_checkpoint = CreateUnitByName("npc_dota_bad_candy_pumpkin", Vector(0, 0, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
		good_checkpoint:AddNewModifier(good_checkpoint, nil, "modifier_invulnerable", {})
		good_checkpoint:SetAbsOrigin(Entities:FindByName(nil, "good_checkpoint_"..DIRETIDE_WINNER):GetAbsOrigin())
		bad_checkpoint:AddNewModifier(bad_checkpoint, nil, "modifier_invulnerable", {})
		bad_checkpoint:SetAbsOrigin(Entities:FindByName(nil, "bad_checkpoint_"..DIRETIDE_WINNER):GetAbsOrigin())
		AddFOWViewer(2, Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin(), 550, 99999, false)
		AddFOWViewer(3, Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin(), 550, 99999, false)
		GameRules:SetUseUniversalShopMode(true)

		local ents = Entities:FindAllByName("lane_*")
		for _, ent in pairs(ents) do
			ent:RemoveSelf()
		end

		local jungles = Entities:FindAllByName("jungle_*")
		for _, ent in pairs(jungles) do
			ent:RemoveSelf()
		end
	elseif DIRETIDE_PHASE == 4 then
		Diretide:End()
	end

	local AImod = ROSHAN_ENT:FindModifierByName("modifier_imba_roshan_ai_diretide")
	if AImod then
		AImod:SetStackCount(DIRETIDE_PHASE)
		ROSHAN_ENT:Interrupt()
	end

	for _, unit in pairs(units) do
		if DIRETIDE_PHASE == 3 then
			if unit:GetUnitLabel() == "npc_diretide_roshan" then
				print("Hi rosh!")
			elseif unit:IsCreep() then
				unit:RemoveSelf()						
			end
		end
	end

	DIRETIDE_PHASE = DIRETIDE_PHASE + 1
	print("Diretide Phase: "..DIRETIDE_PHASE)

	CustomGameEventManager:Send_ServerToAllClients("diretide_phase", {Phase = DIRETIDE_PHASE})
end

function Diretide:Countdown()
	Timers:CreateTimer(function()
		if COUNT_DOWN == 1 then
			nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
		else
		end
		local t = nCOUNTDOWNTIMER
		local minutes = math.floor(t / 60)
		local seconds = t - (minutes * 60)
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

		CustomGameEventManager:Send_ServerToAllClients("countdown", broadcast_gametimer)
--		if t <= 120 then
--			CustomGameEventManager:Send_ServerToAllClients("time_remaining", broadcast_gametimer)
--		end

		if nCOUNTDOWNTIMER < 1 then
			if CustomNetTables:GetTableValue("game_options", "radiant").score == CustomNetTables:GetTableValue("game_options", "dire").score then -- TIE
				nCOUNTDOWNTIMER = 1 -- TIE!
			elseif DIRETIDE_REINCARNATING == true then
				print("Game doesn't end, roshan is reincarnating...")
				nCOUNTDOWNTIMER = nCOUNTDOWNTIMER +1
			else
				Diretide:Phase(DIRETIDE_PHASE)
			end
		end

		return 1.0
	end)
end

function DiretideIncreaseTimer(time)
	nCOUNTDOWNTIMER = nCOUNTDOWNTIMER + time
end

function EnableCountdown(bool)
	if bool == true then
		COUNT_DOWN = 1
	else
		COUNT_DOWN = 0
	end
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

function SwapTeam(team)
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), ROSHAN_ENT)
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		local pos = Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin()

		if hero:GetTeamNumber() == 3 then
			pos = Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin()
		end

		if not hero:IsAlive() then
			hero:RespawnHero(false, false, false)
		end

		hero:SetHealth(hero:GetMaxHealth())
		hero:SetMana(hero:GetMaxMana())
--		ROSHAN_ENT:SetTeam(team)
		FindClearSpaceForUnit(hero, pos, true)
		hero:Stop()
		hero:ModifyGold(DIRETIDE_BONUS_GOLD, true, 0)
		hero:AddExperience(100000, false, false)
	end
end

function EndRoshanCamera()
local i = 1

--	ROSHAN_ENT:SetTeam(4)

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
		hero:RemoveModifierByName("modifier_command_restricted")
		Timers:CreateTimer(0.1, function()
			i = i + 1
			if i < 10 then
--				print("Unlock camera!")
				PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
				return 0.1
			else
--				print("Camera unlocked.")
				return
			end
		end)
	end
end

function Diretide:End()
	EnableCountdown(false)
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_invulnerable", {})
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_command_restricted", {})

	if DIRETIDE_WINNER == 2 then
		Entities:FindByName(nil, "dota_badguys_fort"):ForceKill(false)
	else
		Entities:FindByName(nil, "dota_goodguys_fort"):ForceKill(false)
	end
--	Server_CalculateXPForWinnerAndAll(DIRETIDE_WINNER)
--	GameRules:SetGameWinner(DIRETIDE_WINNER)

--	for _, hero in pairs(HeroList:GetAllHeroes()) do
--		hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
--		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
--		hero:SetRespawnsDisabled(true)
--		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), ROSHAN_ENT)
--	end

--	CustomGameEventManager:Send_ServerToAllClients("hall_of_fame", {})
end

function Diretide:OnEntityKilled(killer, victim)
	if victim:GetTeamNumber() == 4 then
		if victim:GetUnitLabel() == "npc_diretide_roshan" then return end
		local chance = RandomInt(1, 100)
		if chance > 50 then -- 50% chance
			Diretide:CreateCandy(victim:GetAbsOrigin())
		end
	elseif string.find(victim:GetUnitName(), "dota_creep") then
		local chance = RandomInt(1, 100)
		if chance > 90 then -- 10% chance
			Diretide:CreateCandy(victim:GetAbsOrigin())
		end
	end
end

-- Pumpkin ability
function Pumpkin(keys)
local caster = keys.caster
local attacker = keys.attacker
local ability = keys.ability

	if attacker:IsRealHero() then
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
			local item = CreateItem( "item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync(pos, item)
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemWorld")
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score -1})
		elseif caster:GetUnitName() == "npc_dota_bad_candy_pumpkin" and CustomNetTables:GetTableValue("game_options", "dire").score > 0 then
			local item = CreateItem("item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemWorld")
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
	item:LaunchLoot(false, 300, 0.5, pos + RandomVector(RandomInt(50, 200)))
end
