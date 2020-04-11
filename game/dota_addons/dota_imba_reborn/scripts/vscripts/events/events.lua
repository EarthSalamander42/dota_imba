-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

require('events/combat_events')
require('events/npc_spawned/on_hero_spawned')
require('events/npc_spawned/on_unit_spawned')
require('events/on_entity_killed/on_hero_killed')

-- Used for checking memory usage
function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function GameMode:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		InitItemIds()
		GameMode:OnSetGameMode() -- setup gamemode rules

		-- setup Player colors into hex for panorama
		local hex_colors = {}
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			table.insert(hex_colors, i, rgbToHex(PLAYER_COLORS[i]))
		end

		Timers:CreateTimer(2.0, function()
			if tostring(PlayerResource:GetSteamID(0)) == "76561198015161808" then
				BOTS_ENABLED = true
			end

			if BOTS_ENABLED == true then
				SendToServerConsole('sm_gmode 1')
				SendToServerConsole('dota_bot_populate')
			end

			if GetMapName() == MapOverthrow() then
				require("components/overthrow/imbathrow")
				GoodCamera = Entities:FindByName(nil, "@overboss")
				BadCamera = Entities:FindByName(nil, "@overboss")

				local xp_granters = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

				for _, granter in pairs(xp_granters) do
					if string.find(granter:GetUnitName(), "npc_dota_xp_granter") then
						granter:RemoveSelf()
						break
					end
				end
			else
				GoodCamera = Entities:FindByName(nil, "good_healer_6")
				BadCamera = Entities:FindByName(nil, "bad_healer_6")
			end

			HeroSelection:Init()
		end)

		CustomNetTables:SetTableValue("game_options", "player_colors", hex_colors)
	elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if IMBA_PICK_SCREEN == false then
--			for i = 0, PlayerResource:GetPlayerCount() - 1 do
--				if PlayerResource:IsValidPlayer(i) then
--					if PlayerResource:GetTeam(i) == DOTA_TEAM_GOODGUYS then
--						PlayerResource:SetCameraTarget(i, GoodCamera)
--					else
--						PlayerResource:SetCameraTarget(i, BadCamera)
--					end
--				end
--			end

			if IsInToolsMode() then
				for i = 1, PlayerResource:GetPlayerCount() - 1 do
					if PlayerResource:IsValidPlayer(i) then
						PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
						PlayerResource:SetCanRepick(i, false)
					end
				end
			end
		end

		-- IDK how to get this to print only once
		Timers:CreateTimer(FrameTime(), function()
			if api:GetCustomGamemode() == 5 then
				GameMode:SetSameHeroSelection(true)
			end
		end)
	elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		for i = 0, PlayerResource:GetPlayerCount() - 1 do
			if PlayerResource:IsValidPlayer(i) and not PlayerResource:HasSelectedHero(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
				PlayerResource:GetPlayer(i):MakeRandomHeroSelection()
				PlayerResource:SetCanRepick(i, false)
			end
		end
	elseif newState == DOTA_GAMERULES_STATE_PRE_GAME then
		if GetMapName() == MapOverthrow() then
			GoodCamera:AddNewModifier(GoodCamera, nil, "modifier_overthrow_gold_xp_granter", {})
			GoodCamera:AddNewModifier(GoodCamera, nil, "modifier_overthrow_gold_xp_granter_global", {})
		else
			-- No point of these right now until the names are visible again (also probably causing a bit of lag)
			-- self:SetupContributors()
			self:SetupFrostivus()
			self:SetupShrines()
		end

		local fountainEntities = Entities:FindAllByClassname("ent_dota_fountain")

		for _, fountainEnt in pairs(fountainEntities) do
			local danger_zone_pfx = ParticleManager:CreateParticle("particles/ambient/fountain_danger_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(danger_zone_pfx, 0, fountainEnt:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(danger_zone_pfx)

			local fountain_aura_pfx = ParticleManager:CreateParticle("particles/range_indicator.vpcf", PATTACH_ABSORIGIN_FOLLOW, fountainEnt)
			ParticleManager:SetParticleControl(fountain_aura_pfx, 1, Vector(255, 255, 0))
			ParticleManager:SetParticleControl(fountain_aura_pfx, 3, Vector(1200, 0, 0))
			ParticleManager:ReleaseParticleIndex(fountain_aura_pfx)
		end

		-- Create a timer to avoid lag spike entering pick screen
		Timers:CreateTimer(3.0, function()
			if USE_TEAM_COURIER == true then
				COURIER_TEAM = {}
				for i = 2, 3 do
					local pos = {}
					pos[2] = Entities:FindByClassname(nil, "info_courier_spawn_radiant")
					pos[3] = Entities:FindByClassname(nil, "info_courier_spawn_dire")

					if pos[i] then
						COURIER_TEAM[i] = CreateUnitByName("npc_dota_courier", pos[i]:GetAbsOrigin(), true, nil, nil, i)
						COURIER_TEAM[i]:AddNewModifier(COURIER_TEAM[i], nil, "modifier_courier_turbo", {})
						COURIER_TEAM[i]:RemoveModifierByName("modifier_magic_immune")
						COURIER_TEAM[i]:AddAbility("courier_movespeed"):SetLevel(1)
					end
				end
			end

			-- -- IMBA: Custom maximum level EXP tables adjustment
			-- local max_level = tonumber(CustomNetTables:GetTableValue("game_options", "max_level")["1"])
			
			-- if max_level and max_level > 25 then
				-- local j = 26
				-- Timers:CreateTimer(function()
					-- if j >= max_level then
						-- return
					-- end
					-- for i = j, j + 2 do
						-- XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i - 1] + 3500
						-- GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
					-- end
					-- j = j + 2
					-- return 1.0
				-- end)
			-- end

			-- Initialize IMBA Runes system
			if IMBA_RUNE_SYSTEM == true then
				ImbaRunes:Init()
			end

			-- Setup topbar player colors
			CustomGameEventManager:Send_ServerToAllClients("override_top_bar_colors", {})
			
			-- ONLY SHOW THE DEMO PANEL IF IT'S ACTUALLY DEMO MODE (lest people get the wrong idea with thinking other players can use these "hacks")
			if IsInToolsMode() or GetMapName() == "imba_demo" then
				CustomGameEventManager:Send_ServerToAllClients("ShowDemoPanel", {})
			end
		end)

		Timers:CreateTimer(5.0, function()
			-- Welcome message
			if IMBA_PICK_SCREEN == false then
				local line_duration = 5
	
				-- First line
				Notifications:BottomToAll( {text = "#imba_introduction_line_01", duration = line_duration, style = {color = "DodgerBlue"} } )
				Notifications:BottomToAll( {text = "#imba_introduction_line_02", duration = line_duration, style = {color = "Orange"}, continue = true})
				Notifications:BottomToAll( {text = "("..GAME_VERSION..")", duration = line_duration, style = {color = "Orange"}, continue = true})

				-- Second line
				Timers:CreateTimer(line_duration, function()
					Notifications:BottomToAll( {text = "#imba_introduction_line_03", duration = line_duration, style = {color = "DodgerBlue"} }	)

					-- Third line
					Timers:CreateTimer(line_duration, function()
						Notifications:BottomToAll( {text = "#imba_introduction_line_04", duration = line_duration, style = {["font-size"] = "30px", color = "Orange"} }	)
					end)
				end)
			end
		end)
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- start rune timers
		if GetMapName() == Map1v1() then
			Setup1v1()
		else
			-- Controversial addition
			-- if api:GetCustomGamemode() > 1 then
				-- SpawnEasterEgg()
			-- end

			if IMBA_RUNE_SYSTEM == true then
				ImbaRunes:Spawn()
			end
		end

		-- add abilities to all towers
		local towers = Entities:FindAllByClassname("npc_dota_tower")

		for _, tower in pairs(towers) do
			SetupTower(tower)
		end

		-- temporary gold earning through old tick time, until couriers are fixed
		Timers:CreateTimer(function()
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return nil end

			for i = 0, PlayerResource:GetPlayerCount() - 1 do
				if PlayerResource:IsValidPlayerID(i) then
					PlayerResource:ModifyGold(i, 1, true, DOTA_ModifyGold_GameTick)
				end
			end

			return GOLD_TICK_TIME[GetMapName()]
		end)
	end
end

function GameMode:OnNPCSpawned(keys)
	GameMode:_OnNPCSpawned(keys)
	local npc = EntIndexToHScript(keys.entindex)

	if npc then
		-- UnitSpawned Api Event
		local player = "-1"

		if npc:IsRealHero() and npc:GetPlayerID() then
			player = PlayerResource:GetSteamID(npc:GetPlayerID())
		end

		if npc:IsCourier() then
			if npc.first_spawn == true then
				CombatEvents("generic", "courier_respawn", npc)
			else
				npc:AddAbility("courier_movespeed"):SetLevel(1)
				npc.first_spawn = true
			end

			return
		elseif npc:IsRealHero() or npc:IsFakeHero() or npc:IsClone() then
			if npc.first_spawn ~= true then
				npc.first_spawn = true

				-- Need a frame time to detect illusions
				Timers:CreateTimer(FrameTime(), function()
					GameMode:OnHeroFirstSpawn(npc)
				end)

				return
			end

			GameMode:OnHeroSpawned(npc)

			return
		elseif npc:GetClassname() == "npc_dota_tower" then
			print("Tower Spawned!")
			SetupTower(npc)
			return
		else
			if npc.first_spawn ~= true then
				npc.first_spawn = true
				GameMode:OnUnitFirstSpawn(npc)

				return
			end

			GameMode:OnUnitSpawned(npc)

			return
		end
	end
end

function GameMode:OnDisconnect(keys)
	-- GetConnectionState values:
	-- 0 - no connection
	-- 1 - bot connected
	-- 2 - player connected
	-- 3 - bot/player disconnected.

	-- Typical keys:
	-- PlayerID: 2
	-- name: Zimberzimber
	-- networkid: [U:1:95496383]
	-- reason: 2
	-- splitscreenplayer: -1
	-- userid: 7
	-- xuid: 76561198055762111

	-- IMBA: Player disconnect/abandon logic
	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
		-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		if keys.PlayerID == nil or keys.PlayerID == -1 then
			return
		end
		local player_id = keys.PlayerID
		local player_name = keys.name
		if PlayerResource:GetPlayer(player_id):GetAssignedHero() == nil then
			return
		end
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		local line_duration = 7

		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({ hero = hero:GetUnitName(), duration = line_duration })
				Notifications:BottomToAll({ text = player_name .. " ", duration = line_duration, continue = true })
				Notifications:BottomToAll({ text = "#imba_player_abandon_message", duration = line_duration, style = { color = "DodgerBlue" }, continue = true })
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				print("player " .. player_id .. " has abandoned the game.")

				-- Start redistributing this player's gold to its allies (Valve handle it now)
--				PlayerResource:StartAbandonGoldRedistribution(player_id)
				-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

				-- Else, keep tracking connection state
			else
--				print("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)

		local dc_table = {
			ID = player_id,
			team = PlayerResource:GetTeam(player_id),
			disconnect = 1
		}

		GoodGame:Call(dc_table)
	end
end

-- An entity died
function GameMode:OnEntityKilled(keys)
	GameMode:_OnEntityKilled(keys)

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript(keys.entindex_killed)

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript(keys.entindex_attacker)
	end

	if killed_unit then
		------------------------------------------------
		-- Api Event Unit Killed
		------------------------------------------------

		killedUnitName = tostring(killed_unit:GetUnitName())

		if (killedUnitName ~= "") then
			killedPlayer = "-1"

			if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
				killedPlayerId = killed_unit:GetPlayerID()
				killedPlayer = PlayerResource:GetSteamID(killedPlayerId)
			end

			killerUnitName = "-1"
			killerPlayer = "-1"
			if (killer ~= nil) then
				killerUnitName = tostring(killer:GetUnitName())
				if (killer:IsRealHero() and killer:GetPlayerID()) then
					killerPlayerId = killer:GetPlayerID()
					killerPlayer = PlayerResource:GetSteamID(killerPlayerId)
				end
			end

			--			api.imba.event(api.events.unit_killed, {
			--				tostring(killerUnitName),
			--				tostring(killerPlayer),
			--				tostring(killedUnitName),
			--				tostring(killedPlayer)
			--			})
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
			return
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
			return
		end

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() then
			GameMode:OnHeroDeath(killer, killed_unit)

			if IMBA_GOLD_SYSTEM == true then
				GoldSystem:OnHeroDeath(killer, killed_unit)
			end

			return
		elseif killed_unit:IsBuilding() then
			if string.find(killed_unit:GetUnitName(), "tower3") then
				local unit_name = "npc_dota_goodguys_healers"
				if killed_unit:GetTeamNumber() == 3 then
					unit_name = "npc_dota_badguys_healers"
				end

				local units = FindUnitsInRadius(killed_unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

				for _, building in pairs(units) do
					if building:GetUnitName() == unit_name or string.find(building:GetUnitName(), "npc_donator_statue_") then
						if building:HasModifier("modifier_invulnerable") then
							building:RemoveModifierByName("modifier_invulnerable")
						end
					end
				end
			end

			-- if killer:IsRealHero() then
			-- CombatEvents("kill", "hero_kill_tower", killed_unit, killer)
			-- if killer:GetTeam() ~= killed_unit:GetTeam() then
			-- if killed_unit:GetUnitName() == "npc_dota_goodguys_healers" or killed_unit:GetUnitName() == "npc_dota_badguys_healers" then
			-- SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, killed_unit, 125, nil)
			-- else
			-- SendOverheadEventMessage(killer:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, killed_unit, 200, nil)
			-- end
			-- end
			-- else
			-- CombatEvents("generic", "tower_dead", killed_unit, killer)
			-- end

			if GetMapName() == Map1v1() then
				local winner = 2

				if killed_unit:GetTeamNumber() == 2 then
					winner = 3
				end

				GAME_WINNER_TEAM = winner
				GameRules:SetGameWinner(winner)
			end

			return
		elseif killed_unit:IsCourier() then
			CombatEvents("generic", "courier_dead", killed_unit)

			return
		end

		if killed_unit.pedestal then
			killed_unit.pedestal:ForceKill(false)
		end
	end
end

-- This block won't work anymore because I changed the "IMBA_ABILITIES_IGNORE_CDR" variable and changed the logic in modifier_frantic
function GameMode:OnAbilityUsed(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityname = keys.abilityname

	-- for _, ability in pairs(IMBA_ABILITIES_IGNORE_CDR) do
		-- if ability == abilityname then
			-- if player:GetAssignedHero() then
				-- if player:GetAssignedHero():FindAbilityByName(ability) then
					-- local ab = player:GetAssignedHero():FindAbilityByName(ability)
					-- ab:StartCooldown(ab:GetCooldown(ab:GetLevel()))
				-- end
			-- end

			-- break
		-- end
	-- end
	
	-- Tiny Prestige Sword (This is only a temporary pseudo-fix until the ability is customized correctly; it only gives the sword model and doesn't fix antyhing else like ability icons or other particles / tree toss models)
	if player:GetAssignedHero() and player:GetAssignedHero().tree_model == "models/items/tiny/tiny_prestige/tiny_prestige_sword.vmdl" then
		if keys.abilityname == "tiny_tree_grab" then
			local grow_lvl = 0 
			
			if player:GetAssignedHero():FindAbilityByName("imba_tiny_grow") then
				grow_lvl = player:GetAssignedHero():FindAbilityByName("imba_tiny_grow"):GetLevel()
			end
			
			-- If we allrdy have a tree... destroy it and create new. 
			if player:GetAssignedHero().tree ~= nil then
				player:GetAssignedHero().tree:AddEffects(EF_NODRAW)
				UTIL_Remove(player:GetAssignedHero().tree)
				player:GetAssignedHero().tree = nil
			end
			
			-- Create the tree model
			local tree = SpawnEntityFromTableSynchronous("prop_dynamic", {model = player:GetAssignedHero().tree_model})
			-- Bind it to player:GetAssignedHero() bone 
			tree:FollowEntity(player:GetAssignedHero(), true)
			-- Find the Coordinates for model position on left hand
			local origin = player:GetAssignedHero():GetAttachmentOrigin(player:GetAssignedHero():ScriptLookupAttachment("attach_attack2"))
			-- Forward Vector!
			local fv = player:GetAssignedHero():GetForwardVector()
			
			-- Apply diffrent positions of the tree depending on growth model...
			if grow_lvl == 3 then
				--Adjust poition to match grow lvl 3
				local pos = origin + (fv * 50)
				tree:SetAbsOrigin(Vector(pos.x + 10, pos.y, (origin.z + 25)))
			
			elseif grow_lvl == 2 then
				-- Adjust poition to match grow lvl 2
				local pos = origin + (fv * 35)
				tree:SetAbsOrigin(Vector(pos.x, pos.y, (origin.z + 25)))

			elseif grow_lvl == 1 then
				-- Adjust poition to match grow lvl 1
				local pos = origin + (fv * 35) 
				tree:SetAbsOrigin(Vector(pos.x, pos.y + 20, (origin.z + 25)))

			elseif grow_lvl == 0 then
				-- Adjust poition to match original no grow model
				local pos = origin - (fv * 25) 
				tree:SetAbsOrigin(Vector(pos.x - 20, pos.y - 30 , origin.z))
				tree:SetAngles(60, 60, -60)
			end

			-- Save model to player:GetAssignedHero()
			player:GetAssignedHero().tree = tree
		elseif keys.abilityname == "tiny_toss_tree" and player:GetAssignedHero().tree ~= nil then
			player:GetAssignedHero().tree:AddEffects(EF_NODRAW)
			UTIL_Remove(player:GetAssignedHero().tree)
			player:GetAssignedHero().tree = nil
		end
	end
end

-- Add some deprecated abilities back to heroes for that "IMBA" factor
local subAbilities = {"chen_test_of_faith", "huskar_inner_vitality", "tusk_frozen_sigil"}

function GameMode:OnPlayerLevelUp(keys)
	if not keys.player then return end

	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	if hero == nil then
		return
	end
	local level = keys.level
	local hero_attribute = hero:GetPrimaryAttribute()
	if hero_attribute == nil or hero:IsFakeHero() then
		return
	end
	
	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[level])

	-- if hero:GetLevel() > 25 then
		-- if hero:GetUnitName() == "npc_dota_hero_meepo" then
			-- for _, hero in pairs(HeroList:GetAllHeroes()) do
				-- if hero:GetUnitName() == "npc_dota_hero_meepo" and hero:IsClone() then
					-- if not hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
						-- hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_" .. hero:GetCloneSource():GetPrimaryAttribute(), {}):SetStackCount(math.min(hero:GetCloneSource():GetLevel() - 25, 17))
					-- else
						-- hero:FindModifierByName("modifier_imba_war_veteran_" .. hero:GetCloneSource():GetPrimaryAttribute()):SetStackCount(math.min(hero:GetCloneSource():GetLevel() - 25, 17))
					-- end
				-- end
			-- end
		-- end

		-- -- TODO: error sometimes on this line: "hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_"..hero_attribute, {}):SetStackCount(1)""
		-- if not hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
			-- local mod = hero:AddNewModifier(hero, nil, "modifier_imba_war_veteran_" .. hero_attribute, {})
			-- if mod then
				-- mod:SetStackCount(1)
			-- end
		-- elseif hero:HasModifier("modifier_imba_war_veteran_" .. hero_attribute) then
			-- hero:FindModifierByName("modifier_imba_war_veteran_" .. hero_attribute):SetStackCount(math.min(hero:GetLevel() - 25, 17))
		-- end

		-- -- hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
	-- end
	
	for _, ability in ipairs(subAbilities) do 
		if hero:HasAbility(ability) then
			hero:FindAbilityByName(ability):SetLevel(min(math.floor(level / 3), 4))
		end
	end
	
	-- Invoker custom thing
	if hero:HasAbility("invoker_invoke") then
		hero:FindAbilityByName("invoker_invoke"):SetLevel(min(math.floor(level / 6) + 1, 4))
	elseif hero:HasAbility("imba_invoker_invoke") then
		hero:FindAbilityByName("imba_invoker_invoke"):SetLevel(min(math.floor(level / 6) + 1, 4))
	end
end

function GameMode:OnPlayerLearnedAbility(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local abilityname = keys.abilityname

	PlayerResource:StoreAbilitiesLevelUpOrder(keys.PlayerID, abilityname)

	-- -- If it the ability is Homing Missiles, wait a bit and set count to 1
	-- if abilityname == "gyrocopter_homing_missile" then
		-- Timers:CreateTimer(1, function()
			-- -- Find homing missile modifier
			-- local modifier_charges = player:GetAssignedHero():FindModifierByName("modifier_gyrocopter_homing_missile_charge_counter")
			-- if modifier_charges then
				-- modifier_charges:SetStackCount(3)
			-- end
		-- end)
	-- end

	-- initiate talent!
	if abilityname:find("special_bonus_imba_") == 1 then
		hero:AddNewModifier(hero, nil, "modifier_" .. abilityname, {})
	end

	if abilityname == "lone_druid_savage_roar" and not hero.savage_roar then
		hero.savage_roar = true
	end
	
	-- Due to issues with the death illusion spawning without a certain talent being leveled up, there's some messy stuff here involving giving Venge the vanilla Command Aura ability but hidden and un-levelable, so this secretely levels it up to the side while the IMBA version only provides the negative daeth aura and nothing else
	if abilityname == "imba_vengefulspirit_command_aura_723" and hero:HasAbility("vengefulspirit_command_aura") then
		hero:FindAbilityByName("vengefulspirit_command_aura"):SetLevel(hero:FindAbilityByName(abilityname):GetLevel())
	end

	--	if hero then
	--		api.imba.event(api.events.ability_learned, {
	--			tostring(abilityname),
	--			tostring(hero:GetUnitName()),
	--			tostring(PlayerResource:GetSteamID(player:GetPlayerID()))
	--		})
	--	end
end
--[[
function GameMode:PlayerConnect(keys)

end
--]]
-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	local entIndex = keys.index + 1
	local ply = EntIndexToHScript(entIndex)
	local playerID = ply:GetPlayerID()

	ReconnectPlayer(playerID)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	--	local playerID = self.vUserIds[userID]:GetPlayerID()

	local text = keys.text

	local steamid = tostring(PlayerResource:GetSteamID(keys.playerid))
	api.Message("C[" .. steamid .. "] " .. tostring(text))

	-- This Handler is only for commands, ends the function if first character is not "-"
	if not (string.byte(text) == 45) then
		return nil
	end

	local caster = PlayerResource:GetPlayer(keys.playerid):GetAssignedHero()

	for str in string.gmatch(text, "%S+") do
		if IsInToolsMode() or GameRules:IsCheatMode() or (api.imba ~= nil and api.imba.is_developer(steamid)) then
			if str == "-dev_remove_units" then
				GameMode:RemoveUnits(true, true, true)
			end

			if str == "-spawnimbarune" then
				ImbaRunes:Spawn()
			end

			if str == "-replaceherowith" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				if PlayerResource:GetSelectedHeroName(caster:GetPlayerID()) ~= "npc_dota_hero_" .. text then
					if caster.companion then
						caster.companion:ForceKill(false)
						caster.companion = nil
					end

					if IMBA_PICK_SCREEN == true then
						PrecacheUnitByNameAsync("npc_dota_hero_" .. text, function()
							HeroSelection:GiveStartingHero(caster:GetPlayerID(), "npc_dota_hero_" .. text, true)
						end)
					else
						local old_hero = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerID())
						PrecacheUnitByNameAsync("npc_dota_hero_" .. text, function()
							PlayerResource:ReplaceHeroWith(caster:GetPlayerID(), "npc_dota_hero_" .. text, 0, 0)

							Timers:CreateTimer(1.0, function()
								if old_hero then
									UTIL_Remove(old_hero)
								end
							end)
						end)
					end
				end
			end

			if str == "-getwearable" then
				Wearables:PrintWearables(caster)
			end
			
			-- When you don't want to have random match history...
			if str == "-crashgame" then
				print(PlayerResource:GetPlayerName(caster:GetPlayerID()), "(", PlayerResource:GetSteamID(caster:GetPlayerID()), ") has called a crash command.")
				Notifications:BottomToAll({ text = "Game is attempting to be crashed by "..PlayerResource:GetPlayerName(caster:GetPlayerID()).." in 5 seconds.", duration = 5.0, style = { color = "Red" } })
				
				-- Others may be potentially abusing this so putting a failsafe
				-- Crash if teams are less than half full (likely just testing stuff), otherwise make them auto-lose for attempting to crash
				Timers:CreateTimer(5.0, function()
					if PlayerResource:GetPlayerCountForTeam(caster:GetTeam()) / GameRules:GetCustomGameTeamMaxPlayers(caster:GetTeam()) < 0.5 then
						caster:AddNewModifier(caster, nil, nil, {})
					else
						GameRules:MakeTeamLose(caster:GetTeam())
					end
				end)
			end

			if str == "-toggle_ui" then
				CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "toggle_ui", {})
			end
			
			if str == "-same_heroes" then
				GameRules:SetSameHeroSelectionEnabled( true )
				CustomNetTables:SetTableValue("game_options", "same_hero_pick", {value = true})
			end
		end

		if str == "-gg" then
			CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "gg_init_by_local", {})
		end
		
		-- Quick entity check to see if there's too many on the map (can't do anything about it with this, but at least to provide diagnosis)
		if str == "-count" then
			local hero_count = 0
			local creep_count = 0
			local thinker_count = 0
			local wearable_count = 0

			for _, ent in pairs(Entities:FindAllInSphere(Vector(0, 0, 0), 25000)) do
				if string.find(ent:GetDebugName(), "hero") then
					hero_count = hero_count + 1
				end
				
				if string.find(ent:GetDebugName(), "creep") then
					creep_count = creep_count + 1
				end
				
				if string.find(ent:GetDebugName(), "thinker") then
					thinker_count = thinker_count + 1
				end
			
				if string.find(ent:GetDebugName(), "wearable") then
					wearable_count = wearable_count + 1
				end
			end
			
			Say(PlayerResource:GetPlayer(keys.playerid), "There are currently "..#Entities:FindAllInSphere(Vector(0, 0, 0), 25000).." entities residing on the map. From these entities, it is estimated that...", true)
			Say(PlayerResource:GetPlayer(keys.playerid), hero_count.." of them are heroes, "..creep_count.." of them are creeps, "..thinker_count.." of them are thinkers, and "..wearable_count.." of them are wearables.", true)
		end
		
		if str == "-memory" then
			Say(PlayerResource:GetPlayer(keys.playerid), "Current LUA Memory Usage: "..comma_value(collectgarbage("count")*1024).." KB", true)
			-- print(package.loaded) -- This lags everything to absolute death
		end
		
		if str == "-modifier_count" then
			local all_entities = Entities:FindAllInSphere(Vector(0, 0, 0), 25000)
			local modifier_count = 0

			for ent = 1, #all_entities do
				if all_entities[ent].FindAllModifiers then
					modifier_count = modifier_count + #all_entities[ent]:FindAllModifiers()
				end
			end		
		
			Say(PlayerResource:GetPlayer(keys.playerid), "There are a total of "..modifier_count.." modifiers present.", true)
		end
		
		if str == "-slark" then
			if caster:HasModifier("modifier_imba_slark_shadow_dance_passive_regen") and caster:FindModifierByName("modifier_imba_slark_shadow_dance_passive_regen").enemy_that_sees_me then
				DisplayError(caster:GetPlayerID(), "Visible to "..caster:FindModifierByName("modifier_imba_slark_shadow_dance_passive_regen").enemy_that_sees_me:GetName().."...\n\nEnemy Team Number: "..caster:FindModifierByName("modifier_imba_slark_shadow_dance_passive_regen").enemy_that_sees_me:GetTeamNumber())
			else
				DisplayError(caster:GetPlayerID(), "Nothing to see here.")
			end
		end
		
		if str == "-charge" then
			if caster:HasAbility("imba_spirit_breaker_charge_of_darkness") and caster:FindAbilityByName("imba_spirit_breaker_charge_of_darkness").charge_cancel_reason then
				DisplayError(caster:GetPlayerID(), "Charge was cancelled due to..."..caster:FindAbilityByName("imba_spirit_breaker_charge_of_darkness").charge_cancel_reason)
			else
				DisplayError(caster:GetPlayerID(), "Nothing to see here.")
			end
		end
	
		if str == "-killillusions" then
			local zero_health_illusion_count = 0
			
			for _, unit in pairs(FindUnitsInRadius(caster:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
				if (unit:IsIllusion() and unit:GetHealth() <= 0) or (unit.GetPlayerID and unit:GetPlayerID() == -1) then
					unit:ForceKill(false)
					unit:RemoveSelf()
					
					zero_health_illusion_count = zero_health_illusion_count + 1
				end
			end
			
			DisplayError(caster:GetPlayerID(), zero_health_illusion_count.." zero health illusions killed.")
		end
		
		-- For the serial disconnectors
		if (IsInToolsMode() or GetMapName() == "imba_demo") and str == "-exit" then
			GameRules:SetGameWinner(caster:GetTeamNumber())
		end
		
		-- Spooky (inefficiently coded) dev commands
		if PlayerResource:GetSteamAccountID(keys.playerid) == 85812824 or PlayerResource:GetSteamAccountID(keys.playerid) == 925061111 then
			
			if str == "-handicap" then
				local enemy_team		= DOTA_TEAM_BADGUYS
				local enemy_team_name	= "Dire"
				
				if caster:GetTeamNumber() == enemy_team then
					enemy_team = DOTA_TEAM_GOODGUYS
					enemy_team_name	= "Radiant"
				end
				
				local heroes = HeroList:GetAllHeroes()
				local enemies = {}
				
				for _, hero in pairs(heroes) do
					if hero:GetTeam() ~= caster:GetTeam() and hero:IsRealHero() and not hero:IsClone() and not hero:IsTempestDouble() then
						table.insert(enemies, hero)
					end
				end

				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				
				if string.find(text, 'gold') then
					text = string.gsub(text, 'gold', "")
					text = tonumber(text)
					
					for _, enemy in pairs(enemies) do
						enemy:ModifyGold(text, false,  DOTA_ModifyGold_Unspecified)
						
						SendOverheadEventMessage(PlayerResource:GetPlayer(keys.playerid), OVERHEAD_ALERT_GOLD, enemy, text, nil)
					end
					
					Notifications:BottomToAll({ text = PlayerResource:GetPlayerName(caster:GetPlayerID()).." has given every hero on the "..enemy_team_name.." team "..text.." gold for...reasons.", duration = 4.0, style = { color = "LightGreen" } })
				elseif string.find(text, 'exp') then
					text = string.gsub(text, 'exp', "")
					text = tonumber(text)
					
					for _, enemy in pairs(enemies) do
						enemy:AddExperience(text, DOTA_ModifyXP_Unspecified, false, false)
					
						SendOverheadEventMessage(PlayerResource:GetPlayer(keys.playerid), OVERHEAD_ALERT_XP, enemy, text, nil)
					end
					
					Notifications:BottomToAll({ text = PlayerResource:GetPlayerName(caster:GetPlayerID()).." has given every hero on the "..enemy_team_name.." team "..text.." experience for...reasons.", duration = 4.0, style = { color = "LightGreen" } })
				end
				
				-- Says I'm not a "donor" but might be doing something wrong...will leave this for now in case this code block expands
				-- print("Donor status: ", api:GetDonatorStatus(caster:GetPlayerID()))
			elseif str == "-upgrade" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")		
			
				local heroes = HeroList:GetAllHeroes()
				
				for _, hero in pairs(heroes) do
					if hero:IsRealHero() and not hero:IsClone() and not hero:IsTempestDouble() then
						
						local ability_set = {}
						local upgraded = false
						
						-- Temporary code; update as tests require
						if string.find(text, 'techies') and hero:GetName() == "npc_dota_hero_techies" then
							ability_set = {
								[0] = "imba_techies_proximity_mine",
								[1] = "imba_techies_stasis_trap",
								[2] = "imba_techies_blast_off",
								[3] = "imba_techies_focused_detonate",
								[4] = "imba_techies_minefield_sign",
								[5] = "imba_techies_remote_mine",
								[6] = "special_bonus_imba_techies_1",
								[7] = "special_bonus_imba_techies_2",
								[8] = "special_bonus_imba_techies_3",
								[9] = "special_bonus_imba_techies_4",
								[10] = "special_bonus_imba_techies_5",
								[11] = "special_bonus_imba_techies_6",
								[12] = "special_bonus_imba_techies_7",
								[13] = "special_bonus_imba_techies_8"
							}
							upgraded = true
						elseif string.find(text, 'brewmaster') and hero:GetName() == "npc_dota_hero_brewmaster" then
							ability_set = {
								[0] = "imba_brewmaster_thunder_clap",
								[1] = "imba_brewmaster_cinder_brew",
								[2] = "imba_brewmaster_drunken_brawler",
								[3] = "generic_hidden",
								[4] = "generic_hidden",
								[5] = "imba_brewmaster_primal_split",
								[6] = "special_bonus_attack_damage_30",
								[7] = "special_bonus_hp_200",
								[8] = "special_bonus_imba_brewmaster_thunder_clap_slow_duration",
								[9] = "special_bonus_magic_resistance_20",
								[10] = "special_bonus_imba_brewmaster_primal_split_health",
								[11] = "special_bonus_attack_speed_100",
								[12] = "special_bonus_imba_brewmaster_druken_brawler_damage",
								[13] = "special_bonus_imba_brewmaster_primal_split_cooldown"
							}
							upgraded = true
						elseif string.find(text, 'gyrocopter') and hero:GetName() == "npc_dota_hero_gyrocopter" then
							ability_set = {
								[0] = "imba_gyrocopter_rocket_barrage",
								[1] = "imba_gyrocopter_homing_missile",
								[2] = "imba_gyrocopter_flak_cannon",
								[3] = "imba_gyrocopter_gatling_guns",
								[4] = "generic_hidden",
								[5] = "imba_gyrocopter_call_down",
								[6] = "special_bonus_attack_damage_25",
								[7] = "special_bonus_hp_250",
								[8] = "special_bonus_imba_gyrocopter_flak_cannon_attacks",
								[9] = "special_bonus_imba_gyrocopter_rocket_barrage_damage",
								[10] = "special_bonus_movement_speed_50",
								[11] = "special_bonus_imba_gyrocopter_call_down_cooldown",
								[12] = "special_bonus_imba_gyrocopter_homing_missile_charges",
								[13] = "special_bonus_imba_gyrocopter_gatling_guns_activate"
							}
							upgraded = true
						elseif string.find(text, 'void') and hero:GetName() == "npc_dota_hero_void_spirit" then
							ability_set = {
								-- [0] = "imba_gyrocopter_rocket_barrage",
								[1] = "imba_void_spirit_dissimilate",
								[2] = "imba_void_spirit_resonant_pulse",
								[3] = "imba_void_spirit_void_stasis",
								-- [4] = "imba_void_spirit_astral_step_helper",
								[4] = "imba_void_spirit_astral_step_helper_2",
								[5] = "imba_void_spirit_astral_step",
								-- [6] = "special_bonus_attack_damage_25",
								-- [7] = "special_bonus_hp_250",
								-- [8] = "special_bonus_imba_gyrocopter_flak_cannon_attacks",
								[9] = "special_bonus_imba_void_spirit_resonant_pulse_damage",
								-- [10] = "special_bonus_movement_speed_50",
								[11] = "special_bonus_imba_void_spirit_astral_step_charge_cooldown",
								[12] = "special_bonus_imba_void_spirit_astral_step_crit",
								[13] = "special_bonus_imba_void_spirit_dissimilate_stun"
							}
							
							upgraded = true
						elseif string.find(text, 'terror') and hero:GetName() == "npc_dota_hero_terrorblade" then
							ability_set = {
								[0] = "imba_terrorblade_reflection",
								[1] = "imba_terrorblade_conjure_image",
								[2] = "imba_terrorblade_metamorphosis",
								[3] = "imba_terrorblade_terror_wave",
								[4] = "imba_terrorblade_power_rend",
								[5] = "imba_terrorblade_sunder",
								[6] = "special_bonus_movement_speed_20",
								[7] = "special_bonus_evasion_15",
								[8] = "special_bonus_hp_250",
								[9] = "special_bonus_attack_speed_25",
								[10] = "special_bonus_all_stats_10",
								[11] = "special_bonus_imba_terrorblade_reflection_cooldown",
								[12] = "special_bonus_imba_terrorblade_sunder_cooldown",
								[13] = "special_bonus_imba_terrorblade_metamorphosis_attack_range"
							}
							
							upgraded = true
						elseif string.find(text, 'undying') and hero:GetName() == "npc_dota_hero_undying" then
							ability_set = {
								[0] = "imba_undying_decay",
								[1] = "imba_undying_soul_rip",
								[2] = "imba_undying_tombstone",
								[3] = "imba_undying_flesh_golem_grab",
								[4] = "imba_undying_flesh_golem_throw",
								[5] = "imba_undying_flesh_golem",
								[6] = "special_bonus_cast_range_150",
								[7] = "special_bonus_hp_regen_6",
								[8] = "special_bonus_imba_undying_tombstone_zombie_damage",
								[9] = "special_bonus_imba_undying_decay_duration",
								[10] = "special_bonus_imba_undying_tombstone_on_death",
								[11] = "special_bonus_imba_undying_flesh_golem_grab_allies",
								[12] = "special_bonus_reincarnation_200",
								[13] = "special_bonus_imba_undying_decay_cooldown"
							}
							
							upgraded = true
						elseif string.find(text, 'tinker') and hero:GetName() == "npc_dota_hero_tinker" then
							ability_set = {
								[0] = "imba_tinker_laser",
								[1] = "imba_tinker_heat_seeking_missile",
								[2] = "imba_tinker_march_of_the_machines",
								[3] = "imba_tinker_technomancy",
								[4] = "generic_hidden",
								[5] = "imba_tinker_rearm",
								[6] = "special_bonus_imba_tinker_1",
								[7] = "special_bonus_imba_tinker_2",
								[8] = "special_bonus_imba_tinker_3",
								[9] = "special_bonus_imba_tinker_4",
								[10] = "special_bonus_imba_tinker_5",
								[11] = "special_bonus_imba_tinker_6",
								[12] = "special_bonus_imba_tinker_7",
								[13] = "special_bonus_imba_tinker_8"
							}
							upgraded = true
						elseif string.find(text, 'treant') and hero:GetName() == "npc_dota_hero_treant" then
							ability_set = {
								[0] = "imba_treant_natures_grasp",
								[1] = "imba_treant_leech_seed",
								[2] = "imba_treant_living_armor",
								[3] = "treant_eyes_in_the_forest",
								[4] = "imba_treant_natures_guise",
								[5] = "imba_treant_overgrowth",
								[6] = "special_bonus_attack_damage_50",
								[7] = "special_bonus_imba_treant_natures_guise_invisibility",
								[8] = "special_bonus_imba_treant_natures_grasp_damage",
								[9] = "special_bonus_imba_treant_living_armor_heal",
								[10] = "special_bonus_cooldown_reduction_15",
								[11] = "special_bonus_imba_treant_leech_seed_heal",
								[12] = "special_bonus_imba_treant_living_armor_aoe",
								[13] = "special_bonus_imba_treant_overgrowth_damage"
							}
							upgraded = true
						elseif string.find(text, 'arc') and hero:GetName() == "npc_dota_hero_arc_warden" then
							ability_set = {
								[0] = "imba_arc_warden_flux",
								[1] = "imba_arc_warden_magnetic_field",
								[2] = "imba_arc_warden_spark_wraith",
							}
							upgraded = true
						end
						
						for ability = 0, 23 do
							if hero:GetAbilityByIndex(ability) and ability_set[ability] then
								local old_ability_level = hero:GetAbilityByIndex(ability):GetLevel()
							
								hero:RemoveAbility(hero:GetAbilityByIndex(ability):GetName())
								
								local new_ability = hero:AddAbility(ability_set[ability])
								new_ability:SetLevel(old_ability_level)
								
								-- Remove this when done
								if new_ability:GetName() == "imba_gyrocopter_lock_on" or
								new_ability:GetName() == "imba_gyrocopter_gatling_guns" or 
								new_ability:GetName() == "imba_void_spirit_void_stasis" or
								new_ability:GetName() == "imba_tinker_technomancy" then
									new_ability:SetLevel(1)
								end
							end
						end
						
						-- Doing the switch with Undying gives him an infinite usage reincarnation which is...not good for field testing
						if hero:GetName() == "npc_dota_hero_undying" then
							hero:RemoveModifierByName("modifier_special_bonus_reincarnation")
						end
						
						if hero:GetName() == "npc_dota_hero_void_spirit" and not hero:HasAbility("imba_void_spirit_aether_remnant_helper") then
							local helper_ability = hero:AddAbility("imba_void_spirit_aether_remnant_helper")
							helper_ability:SetLevel(1)
							-- helper_ability:SetAbilityIndex(4)
						end
						
						if upgraded then
							-- Random fancy particles to indicate something has changed in the world...
							local particle = ParticleManager:CreateParticle("particles/item/origin/origin_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
							ParticleManager:ReleaseParticleIndex(particle)
							
							local particle2 = ParticleManager:CreateParticle("particles/econ/events/ti8/hero_levelup_ti8.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
							ParticleManager:ReleaseParticleIndex(particle2)
						end
					end
				end
			elseif str == "-phantom_lancer" then
				PlayerResource:GetPlayer(keys.playerid):SetSelectedHero("npc_dota_hero_phantom_lancer")
			elseif str == "-vardor" then
				PlayerResource:GetPlayer(keys.playerid):SetSelectedHero("npc_dota_hero_vardor")
			-- Yeah best not to call this ever but if you really think lag is bad or something...
			elseif str == "-destroyparticles" then
				for particle = 0, 99999 do
					ParticleManager:DestroyParticle(particle, true)
					ParticleManager:ReleaseParticleIndex(particle)
				end
			-- NUKE THE WORLD
			-- elseif str == "-destroy" then
				-- text = string.gsub(text, str, "")
				-- text = string.gsub(text, " ", "")

				-- for _, ent in pairs(Entities:FindAllInSphere(Vector(0, 0, 0), 25000)) do
					-- if string.find(ent:GetDebugName(), text) then
						-- ent:RemoveSelf()
					-- end
				-- end
			elseif str == "-destroylights" then
				for _, ent in pairs(Entities:FindAllInSphere(Vector(0, 0, 0), 25000)) do
					if string.find(ent:GetDebugName(), "env_deferred_light") then
						ent:RemoveSelf()
					end
				end
			elseif str == "-destroywearables" then
				for _, ent in pairs(Entities:FindAllInSphere(Vector(0, 0, 0), 25000)) do
					if string.find(ent:GetDebugName(), "dota_item_wearable") then
						ent:RemoveSelf()
					end
				end
			-- Input a playerID as a parameter (ex. 0 to 19)
			elseif str == "-getname" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				
				if type(tonumber(text)) == "number" and PlayerResource:GetPlayer(tonumber(text)) and PlayerResource:GetPlayer(tonumber(text)):GetAssignedHero() then
					DisplayError(caster:GetPlayerID(), PlayerResource:GetPlayerName(tonumber(text)))
				else
					local foundID = nil
					
					for hero = 0, PlayerResource:GetPlayerCount() do
						if PlayerResource:GetPlayer(hero) and PlayerResource:GetPlayer(hero):GetAssignedHero() and string.find(PlayerResource:GetPlayer(hero):GetAssignedHero():GetName(), text) then
							foundID = hero
							break
						end
					end
					
					if foundID then
						DisplayError(caster:GetPlayerID(), PlayerResource:GetPlayerName(foundID).." -- "..foundID)
					else
						DisplayError(caster:GetPlayerID(), "Invalid PlayerID")
					end
				end
			elseif str == "-freeze" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				
				if type(tonumber(text)) == "number" and PlayerResource:GetPlayer(tonumber(text)) and PlayerResource:GetPlayer(tonumber(text)):GetAssignedHero() and IMBA_PUNISHED then
					IMBA_PUNISHED[PlayerResource:GetSteamAccountID(tonumber(text))] = true
					DisplayError(caster:GetPlayerID(), PlayerResource:GetSteamAccountID(tonumber(text)).." is now frozen.")
				else
					DisplayError(caster:GetPlayerID(), "Invalid Freeze Target")
				end
			elseif str == "-unfreeze" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				
				if type(tonumber(text)) == "number" and PlayerResource:GetPlayer(tonumber(text)) and PlayerResource:GetPlayer(tonumber(text)):GetAssignedHero() and IMBA_PUNISHED then
					IMBA_PUNISHED[PlayerResource:GetSteamAccountID(tonumber(text))] = nil
					PlayerResource:GetPlayer(tonumber(text)):GetAssignedHero():SetCustomHealthLabel("", 0, 0, 0)
					DisplayError(caster:GetPlayerID(), PlayerResource:GetSteamAccountID(tonumber(text)).." is now unfrozen.")
				else
					DisplayError(caster:GetPlayerID(), "Invalid Unfreeze Target")
				end
			elseif str == "-excavate" then
				text = string.gsub(text, str, "")
				text = string.gsub(text, " ", "")
				
				if type(tonumber(text)) == "number" and PlayerResource:GetPlayer(tonumber(text)) and PlayerResource:GetPlayer(tonumber(text)):GetAssignedHero() then
					local obs_count		= 0
					local sentry_count	= 0
				
					for _, obs in pairs(Entities:FindAllByClassname("npc_dota_ward_base")) do
						if obs:GetOwner() == PlayerResource:GetPlayer(tonumber(text)) then
							obs:ForceKill(false)
							obs_count	= obs_count + 1
							caster:AddItemByName("item_ward_observer")
						end
					end
					
					for _, sentry in pairs(Entities:FindAllByClassname("npc_dota_ward_base_truesight")) do
						if sentry:GetOwner() == PlayerResource:GetPlayer(tonumber(text)) then
							sentry:ForceKill(false)
							sentry_count	= sentry_count + 1
							caster:AddItemByName("item_ward_sentry")
						end
					end
					
					DisplayError(caster:GetPlayerID(), "Destroyed "..obs_count.." observer wards and "..sentry_count.." sentry wards placed by "..PlayerResource:GetPlayerName(tonumber(text))..".")
				else
					DisplayError(caster:GetPlayerID(), "Invalid Excavate Target")
				end
			elseif str == "-die" then
				local pos = caster:GetAbsOrigin()
			
				caster:ForceKill(true)
				caster:RespawnHero(false, false)
				FindClearSpaceForUnit(caster, pos, false)
			elseif str == "-addability" then
				-- Mostly for vanilla ability testing
			
				-- Example: -addability 0:axe_berserkers_call
			
				text = string.gsub(text, str, "")
				
				local id = string.match(text, '%d+')
				local ability_name = string.match(text, ":(.*)")
				
				if (type(tonumber(id)) == "number" and PlayerResource:GetPlayer(tonumber(id)) and PlayerResource:GetPlayer(tonumber(id)):GetAssignedHero()) then
					local new_ability = PlayerResource:GetPlayer(tonumber(id)):GetAssignedHero():AddAbility(ability_name)
					
					if new_ability and ability_name then
						for index = 3, 4 do
							if PlayerResource:GetPlayer(tonumber(id)):GetAssignedHero():GetAbilityByIndex(index):GetName() == "generic_hidden" then
								PlayerResource:GetPlayer(tonumber(id)):GetAssignedHero():SwapAbilities(ability_name, "generic_hidden", true, false)
								break
							end
						end
					end
				end
			end
		end
	end
end

-- TODO: FORMAT THIS GARBAGE
function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	if GameRules:IsGamePaused() then
		return 1
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
	
		-- Ban system that forces heroes into their fountain area and locks their position there (either through database or manual intervention)
		if api:GetDonatorStatus(hero:GetPlayerID()) == 10 or (IMBA_PUNISHED and hero.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(hero:GetPlayerID())]) then
			if not IsNearFountain(hero:GetAbsOrigin(), 1200) then
				local pos = GetGroundPosition(Vector(-6700, -7165, 1509), nil)
				if hero:GetTeamNumber() == 3 then
					pos = GetGroundPosition(Vector(7168, 6050, 1431), nil)
				end
				FindClearSpaceForUnit(hero, pos, false)
				
				hero:Interrupt()
			end
			
			-- The "(IMBA_PUNISHED and hero.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(hero:GetPlayerID())])" line is for "banning" units without going into the database (or I guess if it goes down?)
			if (IMBA_PUNISHED and hero.GetPlayerID and IMBA_PUNISHED[PlayerResource:GetSteamAccountID(hero:GetPlayerID())]) then
				local donator_level = 10
			
				hero:SetCustomHealthLabel("#donator_label_" .. donator_level, DONATOR_COLOR[donator_level][1], DONATOR_COLOR[donator_level][2], DONATOR_COLOR[donator_level][3])
			end
		end

		-- Make courier controllable, repeat every second to avoid uncontrollable issues
		if COURIER_TEAM and IsValidEntity(COURIER_TEAM[hero:GetTeamNumber()]) then
			if COURIER_TEAM[hero:GetTeamNumber()] and not COURIER_TEAM[hero:GetTeamNumber()]:IsControllableByAnyPlayer() then
				COURIER_TEAM[hero:GetTeamNumber()]:SetControllableByPlayer(hero:GetPlayerID(), true)
			end
		end

		-- Undying talent fix
		if hero.undying_respawn_timer then
			if hero.undying_respawn_timer > 0 then
				hero.undying_respawn_timer = hero.undying_respawn_timer - 1
			end

			break
		end

		-- Lone Druid fixes
		if hero:GetUnitName() == "npc_dota_hero_lone_druid" and hero.savage_roar then
			local Bears = FindUnitsInRadius(hero:GetTeam(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			for _, Bear in pairs(Bears) do
				if Bear and string.find(Bear:GetUnitName(), "npc_dota_lone_druid_bear") and Bear:FindAbilityByName("lone_druid_savage_roar_bear") and Bear:FindAbilityByName("lone_druid_savage_roar_bear"):IsHidden() then
					Bear:FindAbilityByName("lone_druid_savage_roar_bear"):SetHidden(false)
				end

				break
			end
		elseif hero:GetUnitName() == "npc_dota_hero_morphling" and hero:GetModelName() == "models/heroes/morphling/morphling.vmdl" then
			for _, modifier in pairs(MORPHLING_RESTRICTED_MODIFIERS) do
				if hero:HasModifier(modifier) then
					hero:RemoveModifierByName(modifier)
				end
			end
		elseif hero:GetUnitName() == "npc_dota_hero_witch_doctor" then
			if hero:HasTalent("special_bonus_imba_witch_doctor_6") then
				if not hero:HasModifier("modifier_imba_voodoo_restoration") then
					local ability = hero:FindAbilityByName("imba_witch_doctor_voodoo_restoration")
					hero:AddNewModifier(hero, ability, "modifier_imba_voodoo_restoration", {})
				end
			end
		end

		-- Tusk fixes
		-- Just to clarify on what this does since I didn't know until I commented it out: if you refresh and reuse Snowball while moving, you get permanently lingering particles; there seems to be some other code in the filters.lua file that combines with this to prevent that
		if hero:FindAbilityByName("tusk_snowball") then
			if hero:FindModifierByName("modifier_tusk_snowball_movement") then
				hero:FindAbilityByName("tusk_snowball"):SetActivated(false)
			else
				hero:FindAbilityByName("tusk_snowball"):SetActivated(true)
			end
		end

		-- Find hidden modifiers
		--		if hero:GetUnitName() == "npc_dota_hero_skeleton_king" then
		--			for i = 0, hero:GetModifierCount() -1 do
		--				print(hero:GetUnitName(), hero:GetModifierNameByIndex(i))
		--			end
		--		end
	end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		-- End the game if one team completely abandoned
		if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 and not IsInToolsMode() and not GameRules:IsCheatMode() then
			if not TEAM_ABANDON then
				TEAM_ABANDON = {} -- 15 second to abandon, is_abandoning?, player_count.
				TEAM_ABANDON[2] = { FULL_ABANDON_TIME, false, 0 }
				TEAM_ABANDON[3] = { FULL_ABANDON_TIME, false, 0 }
			end

			TEAM_ABANDON[2][3] = PlayerResource:GetPlayerCountForTeam(2)
			TEAM_ABANDON[3][3] = PlayerResource:GetPlayerCountForTeam(3)

			for ID = 0, PlayerResource:GetPlayerCount() - 1 do
				local team = PlayerResource:GetTeam(ID)

				if PlayerResource:GetConnectionState(ID) ~= 2 then
					-- if disconnected then
					TEAM_ABANDON[team][3] = TEAM_ABANDON[team][3] - 1
				end

				if TEAM_ABANDON[team][3] > 0 then
					TEAM_ABANDON[team][2] = false
				else
					if TEAM_ABANDON[team][2] == false then
						local abandon_text = "#imba_team_good_abandon_message"
						if team == 3 then
							abandon_text = "#imba_team_bad_abandon_message"
						end
						abandon_text = string.gsub(abandon_text, "{s:seconds}", TEAM_ABANDON[team][1])
						Notifications:BottomToAll({text = abandon_text, duration = 1.0})
					end

					TEAM_ABANDON[team][2] = true
					TEAM_ABANDON[team][1] = TEAM_ABANDON[team][1] - 1

					if TEAM_ABANDON[2][1] <= 0 then
						GAME_WINNER_TEAM = 3
						GameRules:SetGameWinner(3)
					elseif TEAM_ABANDON[3][1] <= 0 then
						GAME_WINNER_TEAM = 2
						GameRules:SetGameWinner(2)
					end
				end
			end
		end
	end

	-- What the hell
--[[
	-- Testing trying to remove invinicible 0 hp illusions (really hoping this doesn't lag things to death)
	local entities = Entities:FindAllInSphere(GetGroundPosition(Vector(0, 0, 0), nil), 25000)

	for _, entity in pairs(entities) do
		if entity.HasModifier and entity:HasModifier("modifier_illusion") and entity:FindModifierByName("modifier_illusion"):GetRemainingTime() < 0 and entity:GetHealth() <= 0 then
			entity:RemoveSelf()
		end
	end
--]]

	return 1
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)

	-- Typical keys:
	-- herokills: 6
	-- killer_userid: 0
	-- splitscreenplayer: -1
	-- teamnumber: 2
	-- victim_userid: 7
	-- killer id will be -1 in case of a non-player owned killer (e.g. neutrals, towers, etc.)

	local killer_id = keys.killer_userid
	local victim_id = keys.victim_userid
	local killer_team = keys.teamnumber
	local nTeamKills = keys.herokills

	if GetMapName() == Map1v1() then
		if nTeamKills == IMBA_1V1_SCORE then
			GAME_WINNER_TEAM = killer_team
			GameRules:SetGameWinner(killer_team)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------
	if victim_id ~= nil and victim_id ~= -1 then
		if PlayerResource:IsValidPlayerID(killer_id) and PlayerResource:IsValidPlayerID(victim_id) then
			if killer_id ~= -1 then
				PlayerResource:ResetDeathstreak(killer_id)
			end

			PlayerResource:IncrementDeathstreak(victim_id)

			-- Show Deathstreak message
			if PlayerResource.GetPlayer == nil then
				return
			end

			if PlayerResource:GetPlayer(victim_id):GetAssignedHero() == nil then
				return
			end

			local victim_hero = PlayerResource:GetPlayer(victim_id):GetAssignedHero()
			local victim_player_name = PlayerResource:GetPlayerName(victim_id)
			local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)
			local line_duration = 7

			if victim_death_streak then
				if victim_death_streak >= 3 then
					Notifications:BottomToAll({ hero = victim_hero:GetUnitName(), duration = line_duration })
					Notifications:BottomToAll({ text = victim_player_name .. " ", duration = line_duration, continue = true })
				end

				if victim_death_streak == 3 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_3", duration = line_duration, continue = true })
				elseif victim_death_streak == 4 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_4", duration = line_duration, continue = true })
				elseif victim_death_streak == 5 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_5", duration = line_duration, continue = true })
				elseif victim_death_streak == 6 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_6", duration = line_duration, continue = true })
				elseif victim_death_streak == 7 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_7", duration = line_duration, continue = true })
				elseif victim_death_streak == 8 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_8", duration = line_duration, continue = true })
				elseif victim_death_streak == 9 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_9", duration = line_duration, continue = true })
				elseif victim_death_streak >= 10 then
					Notifications:BottomToAll({ text = "#imba_deathstreak_10", duration = line_duration, continue = true })
				end
			end
		end
	end
end

-- A rune was activated by a player
function GameMode:OnRuneActivated(keys)
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()

	if keys.rune == DOTA_RUNE_ILLUSION then
		ImbaRunes:PickupRune("illusion", hero, false)
	end
end

-- The game was paused
-- This isn't working...
-- function GameMode:OnPause(keys)
	-- print("Game paused.")
-- -- userid ( short )
-- -- value ( short )
-- -- message ( short )
	-- print(keys.userid)
	-- print(keys.value)
	-- print(keys.message)
-- end
