nCOUNTDOWNTIMER = 0
PHASE = 0
GAME_ROSHAN_KILLS = 0
HIT_COUNT = 0
DIRETIDE_WINNER = 2
COUNT_DOWN = 1

function Diretide()
	EmitGlobalSound("announcer_diretide_2012_announcer_welcome_05")
	EmitGlobalSound("DireTideGameStart.DireSide")
	PHASE = 1
	nCOUNTDOWNTIMER = 481 -- 481 / 8 Min
	CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
	CustomNetTables:SetTableValue("game_options", "dire", {score = 25})
	CustomGameEventManager:Send_ServerToAllClients("show_timer", {})
	DiretidePhase(PHASE)
	CountdownDiretide(1.0)
end

function DiretidePhase(PHASE)
	local units = FindUnitsInRadius(1, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, unit in ipairs(units) do
		if unit:GetName() == "npc_dota_roshan" then
			local AImod = unit:FindModifierByName("modifier_imba_roshan_ai_diretide")
			if AImod then
				AImod:SetStackCount(PHASE)
				unit:Interrupt()
			else
				print("ERROR - Could not find Roshans AI modifier")
			end
		--	break (Do we want multiple Roshans roaming the map? :nofun:)
		end
	end
end

-- Pumpkin
function Pumpkin(keys)
local caster = keys.caster
local target = keys.target
local ability = keys.ability
HIT_COUNT = HIT_COUNT + 1

	if HIT_COUNT >= 2 then
		HIT_COUNT = 0
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
		print("Radiant Score:"..CustomNetTables:GetTableValue("game_options", "radiant").score)
		print("Dire Score:"..CustomNetTables:GetTableValue("game_options", "dire").score)
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
			PHASE = PHASE + 1
			DiretidePhase(PHASE)
			print("Phase:", PHASE)
			if PHASE == 2 then
				if CustomNetTables:GetTableValue("game_options", "radiant").score == CustomNetTables:GetTableValue("game_options", "dire").score then
					nCOUNTDOWNTIMER = 481
					COUNT_DOWN = 0
				elseif CustomNetTables:GetTableValue("game_options", "dire").score > CustomNetTables:GetTableValue("game_options", "radiant").score then
					DIRETIDE_WINNER = 3
					nCOUNTDOWNTIMER = 481
					COUNT_DOWN = 1
				else
					nCOUNTDOWNTIMER = 481
					COUNT_DOWN = 1
				end
			elseif PHASE == 3 then
				nCOUNTDOWNTIMER = 120
				COUNT_DOWN = 0
			end
		end
		return tick
	end)
end
