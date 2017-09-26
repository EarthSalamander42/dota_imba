nCOUNTDOWNTIMER = 0
PHASE = 0
GAME_ROSHAN_KILLS = 0
HIT_COUNT = {}
HIT_COUNT[2] = 0
HIT_COUNT[3] = 0

DIRETIDE_WINNER = 2
COUNT_DOWN = 1
PHASE_TIME = 31 -- 481

function Diretide()
local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		

	for _, unit in pairs(units) do
		if unit:IsBuilding() and not unit:GetUnitName() == "npc_dota_candy_pumpkin_good" or not unit:GetUnitName() == "npc_dota_candy_pumpkin_bad" then
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
		end
	end

	EmitGlobalSound("announcer_diretide_2012_announcer_welcome_05")
	EmitGlobalSound("DireTideGameStart.DireSide")
	PHASE = 1
	nCOUNTDOWNTIMER = PHASE_TIME -- 481 / 8 Min
	CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
	CustomNetTables:SetTableValue("game_options", "dire", {score = 25})
	CustomGameEventManager:Send_ServerToAllClients("show_timer", {})
	DiretidePhase(PHASE)
	CountdownDiretide(1.0)
end

function DiretidePhase(PHASE)
local units = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

	for _, unit in ipairs(units) do
		if unit:GetUnitLabel() == "npc_diretide_roshan" then
			local AImod = unit:FindModifierByName("modifier_imba_roshan_ai_diretide")
			if AImod then
				print()
				AImod:SetStackCount(PHASE)
				unit:Interrupt()
			else
				print("ERROR - Could not find Roshans AI modifier")
			end
		end
	end
	CustomGameEventManager:Send_ServerToAllClients("diretide_phase", {Phase = tostring(PHASE)})
end

-- Pumpkin
function Pumpkin(keys)
local caster = keys.caster
local target = keys.target
local ability = keys.ability

	HIT_COUNT[caster:GetTeamNumber()] = HIT_COUNT[caster:GetTeamNumber()] + 1

	if HIT_COUNT[caster:GetTeamNumber()] >= 2 then
		HIT_COUNT[caster:GetTeamNumber()] = 0
		if caster:GetName() == "npc_dota_candy_pumpkin_good" and CustomNetTables:GetTableValue("game_options", "radiant").score > 0 then
			-- Create the item
			local item = CreateItem( "item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync(pos, item)
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemShop")
			CustomNetTables:SetTableValue("game_options", "radiant", {score = CustomNetTables:GetTableValue("game_options", "radiant").score -1})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_bad" and CustomNetTables:GetTableValue("game_options", "dire").score > 0 then
			-- Create the item
			local item = CreateItem("item_diretide_candy", nil, nil)
			local pos = caster:GetAbsOrigin()
			local drop = CreateItemOnPositionSync( pos, item )
			local pos_launch = pos+RandomVector(RandomFloat(150,200))
			item:LaunchLoot(false, 200, 0.75, pos_launch)
			item:EmitSound("Item.DropGemShop")
			CustomNetTables:SetTableValue("game_options", "dire", {score = CustomNetTables:GetTableValue("game_options", "dire").score -1})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_good" and CustomNetTables:GetTableValue("game_options", "radiant").score <= 0 then
			Notifications:BottomToAll({text="No more Candy in Radiant Pumpkin!", duration=6.0})
			CustomNetTables:SetTableValue("game_options", "radiant", {score = 0})
		elseif caster:GetName() == "npc_dota_candy_pumpkin_bad" and CustomNetTables:GetTableValue("game_options", "dire").score <= 0 then
			Notifications:BottomToAll({text="No more Candy in Dire Pumpkin!", duration=6.0})
			CustomNetTables:SetTableValue("game_options", "dire", {score = 0})
		end
--		print("Radiant Score:"..CustomNetTables:GetTableValue("game_options", "radiant").score)
--		print("Dire Score:"..CustomNetTables:GetTableValue("game_options", "dire").score)
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
--			print("Roshan Reincarnate:", DIRETIDE_REINCARNATING)
			if CustomNetTables:GetTableValue("game_options", "radiant").score == CustomNetTables:GetTableValue("game_options", "dire").score then -- TIE
--				print("TIE")
				nCOUNTDOWNTIMER = 1
--			elseif DIRETIDE_REINCARNATING == true then
--				nCOUNTDOWNTIMER = nCOUNTDOWNTIMER +1
			else
				nCOUNTDOWNTIMER = PHASE_TIME
				PHASE = PHASE + 1
				DiretidePhase(PHASE)
			end
			if PHASE == 2 then
				if CustomNetTables:GetTableValue("game_options", "dire").score > CustomNetTables:GetTableValue("game_options", "radiant").score then
					DIRETIDE_WINNER = 3
				end
			elseif PHASE == 3 then
				nCOUNTDOWNTIMER = 120
				COUNT_DOWN = 0
				SwapTeam(DIRETIDE_WINNER)
				local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)		
				for _, unit in pairs(units) do
					if unit:GetUnitLabel() == "npc_diretide_roshan" then
					else
						if unit:IsCreep() then
							unit:RemoveSelf()						
						end
					end
				end
				local ents = Entities:FindAllByName("lane_*")
				for _, ent in pairs(ents) do
					ent:RemoveSelf()
				end
			elseif PHASE == 4 then
				GameRules:SetGameWinner(DOTA_TEAM_NEUTRALS)
			end
		elseif nCOUNTDOWNTIMER == 120 and PHASE == 3 then
			local hero = FindUnitsInRadius(2, Entities:FindByName(nil, "roshan_arena_"..DIRETIDE_WINNER):GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #hero > 0 then
				print("A hero is near...")
				COUNT_DOWN = 1
			end
		end
		return tick
	end)
end

function DiretideIncreaseTimer(time)
	nCOUNTDOWNTIMER = nCOUNTDOWNTIMER + time
end

function UpdateRoshanBar(roshan, level, time)
	if GameRules:IsGamePaused() then
		return time
	else
		print("Launching Roshan's Health Bar")
		print(level)
		Timers:CreateTimer(function()
			CustomNetTables:SetTableValue("game_options", "roshan", {
				level = level,
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
		FindClearSpaceForUnit(hero, Entities:FindByName(nil, "courier_spawn_"..team):GetAbsOrigin(), true)
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)
		hero:Stop()
		hero:SetGold(hero:GetGold() + 20000, true)
		Timers:CreateTimer(0.1, function()
			PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
		end)
	end
end
