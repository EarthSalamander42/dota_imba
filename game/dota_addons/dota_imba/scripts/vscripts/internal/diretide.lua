nCOUNTDOWNTIMER = 0
PHASE = 0
GAME_ROSHAN_KILLS = 0
HIT_COUNT = 0

function Diretide()
	EmitGlobalSound("announcer_diretide_2012_announcer_welcome_05")
	EmitGlobalSound("DireTideGameStart.DireSide")
	PHASE = 1
	nCOUNTDOWNTIMER = 481 -- 481 / 8 Min
	CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
	CustomNetTables:SetTableValue("game_options", "dire", {score = 25})
	CustomGameEventManager:Send_ServerToAllClients("show_timer", {})

	CountdownDiretide(1.0)
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
		nCOUNTDOWNTIMER = nCOUNTDOWNTIMER - 1
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

--		print("nCOUNTDOWNTIMER:", nCOUNTDOWNTIMER)
--		print("Radiant Score:", CustomNetTables:GetTableValue("game_options", "radiant").score)
--		print("Dire Score:", CustomNetTables:GetTableValue("game_options", "dire").score)
		if nCOUNTDOWNTIMER < 1 then
--			PHASE = PHASE + 1
--			nCOUNTDOWNTIMER = 481
--			print("Phase:", PHASE)
			if CustomNetTables:GetTableValue("game_options", "radiant").score > CustomNetTables:GetTableValue("game_options", "dire").score then
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				return nil
			elseif CustomNetTables:GetTableValue("game_options", "dire").score > CustomNetTables:GetTableValue("game_options", "radiant").score then
				GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
				return nil
			else
--				print("TIE!")
--				GameRules:Defeated()
			end
		end
		return tick
	end)
end
