-- Global vars init
DIRETIDE_BONUS_GOLD = 20000
nCOUNTDOWNTIMER = 0
DIRETIDE_PHASE = 0
DIRETIDE_WINNER = 2
COUNT_DOWN = 1
PHASE_TIME = 481
if IsInToolsMode() then
	PHASE_TIME = 31
end

HIT_COUNT = {}
HIT_COUNT[2] = 0
HIT_COUNT[3] = 0

function Diretide()
	EmitGlobalSound("announcer_diretide_2012_announcer_welcome_05")
	EmitGlobalSound("DireTideGameStart.DireSide")
	nCOUNTDOWNTIMER = PHASE_TIME -- 481 / 8 Min
	CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
	CustomNetTables:SetTableValue("game_options", "dire", {score = 25})
	DIRETIDE_PHASE = DIRETIDE_PHASE + 1
	DiretidePhase(DIRETIDE_PHASE)
	CountdownDiretide(1.0)

	if GetMapName() ~= "imba_diretide" then
		good_pumpkin:RemoveModifierByName("modifier_invulnerable")
		bad_pumpkin:RemoveModifierByName("modifier_invulnerable")
--		CustomGameEventManager:Send_ServerToAllClients("chat_fix", {})
	end
end

function DiretidePhase(DIRETIDE_PHASE)
local units = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

	if DIRETIDE_PHASE == 2 then
		nCOUNTDOWNTIMER = PHASE_TIME
		if CustomNetTables:GetTableValue("game_options", "dire").score > CustomNetTables:GetTableValue("game_options", "radiant").score then
			DIRETIDE_WINNER = 3
		end
	elseif DIRETIDE_PHASE == 3 then
		nCOUNTDOWNTIMER = 120
		EnableCountdown(false)
		SwapTeam(DIRETIDE_WINNER)
		AddFOWViewer(DIRETIDE_WINNER, Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin(), 500, 99999, false)
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
		DiretideEnd()
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
	CustomGameEventManager:Send_ServerToAllClients("diretide_phase", {Phase = DIRETIDE_PHASE})
end

-- Pumpkin
function Pumpkin(keys)
local caster = keys.caster
local attacker = keys.attacker
local ability = keys.ability

	if attacker:IsRealHero() then
		HIT_COUNT[caster:GetTeamNumber()] = HIT_COUNT[caster:GetTeamNumber()] + 1
	end

	if HIT_COUNT[caster:GetTeamNumber()] >= 2 then
		HIT_COUNT[caster:GetTeamNumber()] = 0
		if caster:GetUnitName() == "npc_dota_good_candy_pumpkin" and CustomNetTables:GetTableValue("game_options", "radiant").score > 0 then
			local item = CreateItem( "item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync(pos, item)
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemShop")
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score -1})
		elseif caster:GetUnitName() == "npc_dota_bad_candy_pumpkin" and CustomNetTables:GetTableValue("game_options", "dire").score > 0 then
			local item = CreateItem("item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemShop")
			CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score -1})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_good" and CustomNetTables:GetTableValue("game_options", "radiant").score <= 0 then
--			Notifications:BottomToAll({text="No more Candy in Radiant Pumpkin!", duration=6.0})
			CustomNetTables:SetTableValue("game_options", "radiant", {score = 0})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_bad" and CustomNetTables:GetTableValue("game_options", "dire").score <= 0 then
--			Notifications:BottomToAll({text="No more Candy in Dire Pumpkin!", duration=6.0})
			CustomNetTables:SetTableValue("game_options", "dire", {score = 0})
		end
	end
end

function CountdownDiretide(tick)
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
				DIRETIDE_PHASE = DIRETIDE_PHASE + 1
				DiretidePhase(DIRETIDE_PHASE)
			end
		elseif nCOUNTDOWNTIMER == 120 and DIRETIDE_PHASE == 3 then
			local hero = FindUnitsInRadius(2, Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #hero > 0 and COUNT_DOWN == 0 then
				print("A hero is near...")
				EnableCountdown(true)
			end
		end
		return tick
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
local duration = 15.0

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		local player_id = hero:GetPlayerOwnerID()
		if hero:GetTeamNumber() == team then
		else
			local Gold = hero:GetGold()
			hero:SetTeam(team)
			hero:GetPlayerOwner():SetTeam(team)
			hero:SetGold(Gold, false)
			PlayerResource:UpdateTeamSlot(player_id, team, 1)
			PlayerResource:SetCustomTeamAssignment(player_id, team)
		end
		if not hero:IsAlive() then
			hero:RespawnHero(false, false, false)
		end
		hero:SetHealth(hero:GetMaxHealth())
		hero:SetMana(hero:GetMaxMana())
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		ROSHAN_ENT:SetTeam(team)
		PlayerResource:SetCameraTarget(player_id, ROSHAN_ENT)
		FindClearSpaceForUnit(hero, Entities:FindByName(nil, "courier_spawn_"..team):GetAbsOrigin(), true)
		hero:Stop()
		hero:SetGold(hero:GetGold() + DIRETIDE_BONUS_GOLD, true)
	end
end

function EndRoshanCamera()
	ROSHAN_ENT:SetTeam(4)

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
		hero:RemoveModifierByName("modifier_command_restricted")
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
		end)
	end
end

function DiretideEnd()
	EnableCountdown(false)
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_invulnerable", {})
	ROSHAN_ENT:AddNewModifier(ROSHAN_ENT, nil, "modifier_command_restricted", {})

	-- remove this once the Hall of Fame is ready
--	if DIRETIDE_WINNER == 3 then
--		UTIL_Remove(Entities:FindByName(nil, "dota_goodguys_fort"))
--	elseif DIRETIDE_WINNER == 2 then
--		UTIL_Remove(Entities:FindByName(nil, "dota_badguys_fort"))
--	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
		hero:AddNewModifier(hero, nil, "modifier_command_restricted", {})
		hero:SetRespawnsDisabled(true)
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), ROSHAN_ENT)
	end
	CustomGameEventManager:Send_ServerToAllClients("hall_of_fame", {})
end
