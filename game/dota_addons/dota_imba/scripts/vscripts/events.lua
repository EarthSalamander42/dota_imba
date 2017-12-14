-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Cleanup a player when they leave
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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player disconnect/abandon logic
	-------------------------------------------------------------------------------------------------

	-- If the game hasn't started, or has already ended, do nothing
	if (GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME) or (GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME) then
		return nil
	-- Else, start tracking player's reconnect/abandon state
	else
		-- Fetch player's player and hero information
		local player_id = keys.PlayerID
		local player_name = keys.name
		local hero = PlayerResource:GetPickedHero(player_id)
		local hero_name = PlayerResource:GetPickedHeroName(player_id)
		local line_duration = 7

		-- Start tracking
		print("started keeping track of player "..player_id.."'s connection state")
		local disconnect_time = 0
		Timers:CreateTimer(1, function()
			
			-- Keep track of time disconnected
			disconnect_time = disconnect_time + 1

			-- If the player has abandoned the game, set his gold to zero and distribute passive gold towards its allies
			if hero:HasOwnerAbandoned() or disconnect_time >= ABANDON_TIME then
				-- Abandon message
				Notifications:BottomToAll({hero = hero_name, duration = line_duration})
				Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
				Notifications:BottomToAll({text = "#imba_player_abandon_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})
				PlayerResource:SetHasAbandonedDueToLongDisconnect(player_id, true)
				print("player "..player_id.." has abandoned the game.")

				-- Decrease the player's team's player count
				PlayerResource:DecrementTeamPlayerCount(player_id)

				-- Start redistributing this player's gold to its allies
				PlayerResource:StartAbandonGoldRedistribution(player_id)

				-- If this was the last player to abandon on his team, wait 15 seconds and end the game if no one came back.
				if REMAINING_GOODGUYS <= 0 then
					Notifications:BottomToAll({text = "#imba_team_good_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })
					Timers:CreateTimer(FULL_ABANDON_TIME, function()
						if REMAINING_GOODGUYS <= 0 then
							GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
							GAME_WINNER_TEAM = 3
						end
					end)
				elseif REMAINING_BADGUYS <= 0 then
					Notifications:BottomToAll({text = "#imba_team_bad_abandon_message", duration = line_duration, style = {color = "DodgerBlue"} })
					Timers:CreateTimer(FULL_ABANDON_TIME, function()
						if REMAINING_BADGUYS <= 0 then
							GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
							GAME_WINNER_TEAM = 2
						end
					end)
				end
			-- If the player has reconnected, stop tracking connection state every second
			elseif PlayerResource:GetConnectionState(player_id) == 2 then

			-- Else, keep tracking connection state
			else
				print("tracking player "..player_id.."'s connection state, disconnected for "..disconnect_time.." seconds.")
				return 1
			end
		end)
	end
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
	DebugPrint("[BAREBONES] GameRules State Changed")
	DebugPrintTable(keys)
	--	local i = 10

	-- This internal handling is used to set up main barebones functions
	GameMode:_OnGameRulesStateChange(keys)

	local new_state = GameRules:State_Get()
	CustomNetTables:SetTableValue("game_options", "game_state", {state = new_state})

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game Setup / API Calls
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		-- get top 10 xp
--		for i = 1, 13 do -- +2 for the 2 unallowed xp (cookies and suthernfriend) and +1 because universe big bang 42
--			Server_GetTopPlayer(i)
--		end

		if PlayerResource:GetPlayerCount() < 10 then
			if not IsInToolsMode() then
				CHEAT_ENABLED = true
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Pick screen stuff
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		ApiPrint("entered hero selection")
		HeroSelection:HeroListPreLoad()

		-- get the IXP of everyone (ignore bot)
		GetPlayerInfoIXP()
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Start-of-pre-game stuff
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_PRE_GAME then
		-- Play Announcer sounds in Picking Screen until a hero is picked
--		Timers:CreateTimer(function()
--			local i2 = false
--			for _, hero in pairs(HeroList:GetAllHeroes()) do
--				if hero.picked == true then print("Hero Picked! Aborting Announcer...") return nil end
--				if GameRules:GetDOTATime(false, true) >= -PRE_GAME_TIME + HERO_SELECTION_TIME -30 and GameRules:GetDOTATime(false, true) <= -PRE_GAME_TIME + HERO_SELECTION_TIME -29 then
--					EmitAnnouncerSoundForPlayer("announcer_announcer_count_battle_30", hero:GetPlayerID())
--				elseif GameRules:GetDOTATime(false, true) >= -PRE_GAME_TIME + HERO_SELECTION_TIME -10 and GameRules:GetDOTATime(false, true) <= -PRE_GAME_TIME + HERO_SELECTION_TIME then
--					if i2 == false then
--						if i == 10 then
--							EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_"..i, hero:GetPlayerID())
--							i = i -1
--							i2 = true
--						elseif i <= 10 then
--							EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_0"..i, hero:GetPlayerID())
--							i = i -1
--							i2 = true
--						elseif i == 1 then
--							print("NIL")
--							return nil
--						end
--					end
--				end
--			end
--			return 1.0
--		end)

		-- Initialize Battle Pass
		Imbattlepass:Init()

--		PrintTable(get_topxpplayers())

		-- Shows various info to devs in pub-game to find lag issues
		ImbaNetGraph(10.0)

		Timers:CreateTimer(function() -- OnThink
			if CHEAT_ENABLED == false then
				if Convars:GetBool("developer") == true or Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
					if not IsInToolsMode() then
						print("Cheats have been enabled, game don't count.")
						CHEAT_ENABLED = true
					end
				end
			end

			-- fix to setup flying courier speed, volvo black magic reset it to 450
			if GameRules:GetDOTATime(false, false) > 180 then
				for _, courier in pairs(IMBA_COURIERS) do
					if not courier:HasModifier("modifier_courier_hack") then
						courier:AddNewModifier(courier, nil, "modifier_courier_hack", {})
					end
				end
			end

			-- fix for super high respawn time
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if not hero:IsAlive() then
					local respawn_time = hero:GetTimeUntilRespawn()
					local reaper_scythe = 36 -- max necro timer addition
					if hero:HasModifier("modifier_imba_reapers_scythe_respawn") then
						if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[25] + reaper_scythe then
							print("NECROPHOS BUG:", hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[25])
							respawn_time = respawn_time + reaper_scythe
						end
					else
						if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[25] then
							print(hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[25])
							respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[25]
						end
					end
					hero:SetTimeUntilRespawn(respawn_time)
				end
			end
			return 1.0
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game started (horn sounded)
	-------------------------------------------------------------------------------------------------
	if new_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		
		ApiPrint("Entering Game in progress / horn")

		CountGameIXP()

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if IsDev(hero) then
				hero.has_graph = true
				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph", {})
--				CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(), "show_netgraph_heronames", {})
			end
			HeroVoiceLine(hero, "battlebegins")
		end

		Timers:CreateTimer(60, function()
			StartGarbageCollector()
--			DefineLosingTeam()
			return 60
		end)

		if RandomInt(1, 100) > 25 then
			Timers:CreateTimer(RandomInt(5, 10) * 60, function()
				if CHEAT_ENABLED == false then
					local pos = {}
					pos[1] = Vector(6446, -6979, 1496)
					pos[2] = Vector(RandomInt(-6000, 0), RandomInt(7150, 7300), 1423)
					pos[3] = Vector(RandomInt(-1000, 2000), RandomInt(6900, 7200), 1440)
					pos[4] = Vector(7041, -6263, 1461)
					local pos = pos[4]

					GridNav:DestroyTreesAroundPoint(pos, 80, false)
					local item = CreateItem("item_the_caustic_finale", nil, nil)
					local drop = CreateItemOnPositionSync(pos, item)
				end
			end)
		end
	end

	if new_state == DOTA_GAMERULES_STATE_POST_GAME then
		-- call imba api
		ApiPrint("Entering post game")

		imba_api_game_complete(function (players)
			print("Sending new XP / IMR values to clients")
			for ID = 0, PlayerResource:GetPlayerCount() -1 do
				print("XP DIFF:", players[tostring(PlayerResource:GetSteamID(ID))].xp_diff)
				CustomNetTables:SetTableValue("player_table", tostring(ID), {
					XP = CustomNetTables:GetTableValue("player_table", tostring(ID)).XP,
					MaxXP = CustomNetTables:GetTableValue("player_table", tostring(ID)).MaxXP,
					Lvl = CustomNetTables:GetTableValue("player_table", tostring(ID)).Lvl,
					title = CustomNetTables:GetTableValue("player_table", tostring(ID)).title,
					title_color = CustomNetTables:GetTableValue("player_table", tostring(ID)).title_color,
					XP_change = players[tostring(PlayerResource:GetSteamID(ID))].xp_diff
				})
			end
--			CustomGameEventManager:Send_ServerToAllClients("end_game", players)
		end)

		CustomGameEventManager:Send_ServerToAllClients("end_game", {})

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:GetTeamNumber() == GAME_WINNER_TEAM then
				print("WINNING! YAY:", GAME_WINNER_TEAM)
				HeroVoiceLine(hero, "win")
			else
				print("LOSING! OH NOES:", GAME_WINNER_TEAM)
				HeroVoiceLine(hero, "lose")
			end
		end
	end
end

dummy_created_count = 0

function GameMode:OnNPCSpawned(keys)
GameMode:_OnNPCSpawned(keys)
local npc = EntIndexToHScript(keys.entindex)
local normal_xp = npc:GetDeathXP()

	if npc then
		if GetMapName() == "imba_10v10" or GetMapName() == "imba_frantic_10v10" then
			npc:SetDeathXP(normal_xp)
		else
			npc:SetDeathXP(normal_xp*1.5)
		end

--		npc:AddNewModifier(npc, nil, "modifier_river", {})

		-- Valve Illusion bug to prevent respawning
		if npc:IsIllusion() or npc:IsTempestDouble() then
			if npc.illusion == true then
				UTIL_Remove(npc)
			end
			npc.illusion = true
			return
		end

		-- monkey king fix, do not spawn the 14 monkeys
		if npc:GetUnitName() == "npc_dota_hero_monkey_king" then
			if TRUE_MK_HAS_SPAWNED then
				return nil
			else
				TRUE_MK_HAS_SPAWNED = true
			end
		end

		if npc:GetUnitName() == "npc_dota_courier" then
			if not npc.first_spawn then
				npc.first_spawn = true
				table.insert(IMBA_COURIERS, npc)
				if npc:FindAbilityByName("courier_burst"):GetLevel() ~= 1 then
					npc:FindAbilityByName("courier_burst"):SetLevel(1)
				end
			end
			npc:AddNewModifier(npc, nil, "modifier_imba_speed_limit_break", {})
		end

--		if npc:IsRealHero() and npc:GetUnitName() ~= "npc_dota_hero_wisp" or npc.is_real_wisp then
--			if not npc.has_label then
--				Timers:CreateTimer(5.0, function()
--					local title = GetTitleIXP(npc:GetPlayerID())
--					local rgb = GetTitleColorIXP(title)
--					npc:SetCustomHealthLabel(title, rgb[1], rgb[2], rgb[3])
--				end)
--				npc.has_label = true
--			end
--		elseif npc:IsIllusion() then
--			if not npc.has_label then
--				local title = GetTitleIXP(npc:GetPlayerID())
--				local rgb = GetTitleColorIXP(title)
--				npc:SetCustomHealthLabel(title, rgb[1], rgb[2], rgb[3])
--				npc.has_label = true
--			end
--		end
	end

	if npc:GetUnitName() == "npc_dummy_unit" or npc:GetUnitName() == "npc_dummy_unit_perma" then
		dummy_created_count = dummy_created_count +1
	end

	if npc:IsRealHero() then
		if not npc.first_spawn then
			if npc:GetUnitName() == "npc_dota_hero_troll_warlord" then
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", false, true)
				npc:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
			end

			if IsDonator(npc) ~= false then
				if npc:GetUnitName() ~= "npc_dota_hero_wisp" or npc.is_real_wisp then
					if tostring(PlayerResource:GetSteamID(npc:GetPlayerID())) == "76561198015161808" then
						DonatorCompanion(npc, "cookies")
					else
						DonatorCompanion(npc, IsDonator(npc))
					end
				end
			end

			npc.first_spawn = true
			HeroVoiceLine(npc, "spawn")
		else
			HeroVoiceLine(npc, "respawn")
		end

		-- fix for killed with Ghost Revenant immolation
		if npc:HasModifier("modifier_ghost_revenant_ghost_immolation_debuff") then
			npc:RemoveModifierByName("modifier_ghost_revenant_ghost_immolation_debuff")
			Timers:CreateTimer(0.2, function()
				npc:SetHealth(100000)
			end)
		end

		Timers:CreateTimer(1, function() -- Silencer fix
			if npc:HasModifier("modifier_silencer_int_steal") then
				npc:RemoveModifierByName("modifier_silencer_int_steal")
			end
		end)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arc Warden clone handling
	-------------------------------------------------------------------------------------------------
	if npc:FindAbilityByName("arc_warden_tempest_double") and not npc.first_tempest_double_cast and npc:IsRealHero() then
		npc.first_tempest_double_cast = true
		local tempest_double_ability = npc:FindAbilityByName("arc_warden_tempest_double")
		tempest_double_ability:SetLevel(4)
		Timers:CreateTimer(0.1, function()
			if not npc:HasModifier("modifier_arc_warden_tempest_double") then
				tempest_double_ability:CastAbility()
				tempest_double_ability:SetLevel(1)
			end
		end)
	end

	if npc:HasModifier("modifier_arc_warden_tempest_double") then

		-- List of modifiers which carry over from the main hero to the clone
		local clone_shared_buffs = {			
			"modifier_imba_moon_shard_stacks_dummy",
			"modifier_imba_moon_shard_consume_1",
			"modifier_imba_moon_shard_consume_2",
			"modifier_imba_moon_shard_consume_3",
			"modifier_item_imba_soul_of_truth"
		}
		
		-- Iterate through the main hero's potential modifiers
		local main_hero = npc:GetOwner():GetAssignedHero()
		for _, shared_buff in pairs(clone_shared_buffs) do
			
			-- If the main hero has this modifier, copy it to the clone
			if main_hero:HasModifier(shared_buff) then
				local shared_buff_modifier = main_hero:FindModifierByName(shared_buff)
				local shared_buff_ability = shared_buff_modifier:GetAbility()

				-- If a source ability was found, use it
				if shared_buff_ability then
					shared_buff_ability:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})

				-- Else, it's a consumable item modifier. Create a dummy item to use the ability from.
				else
					-- Moon Shard
					if string.find(shared_buff, "moon_shard") then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_moon_shard", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_moon_shard" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end

					-- Soul of Truth
					if shared_buff == "modifier_item_imba_soul_of_truth" then

						-- Create dummy item
						local dummy_item = CreateItem("item_imba_soul_of_truth", npc, npc)
						main_hero:AddItem(dummy_item)

						-- Fetch dummy item's ability handle
						for i = 0, 11 do
							local current_item = main_hero:GetItemInSlot(i)
							if current_item and current_item:GetName() == "item_imba_soul_of_truth" then
								current_item:ApplyDataDrivenModifier(main_hero, npc, shared_buff, {})
								break
							end
						end
						main_hero:RemoveItem(dummy_item)
					end
				end

				-- Apply any stacks if relevant
				if main_hero:GetModifierStackCount(shared_buff, nil) > 0 then
					npc:SetModifierStackCount(shared_buff, main_hero, main_hero:GetModifierStackCount(shared_buff, nil))
				end
			end
		end
	end		

	-------------------------------------------------------------------------------------------------
	-- IMBA: Buyback penalty removal
	-------------------------------------------------------------------------------------------------

	Timers:CreateTimer(0.1, function()
		if (not npc:IsNull()) and npc:HasModifier("modifier_buyback_gold_penalty") then
			npc:RemoveModifierByName("modifier_buyback_gold_penalty")
		end
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Negative Vengeance Aura removal
	-------------------------------------------------------------------------------------------------

	if npc.vengeance_aura_target then
		npc.vengeance_aura_target:RemoveModifierByName("modifier_imba_command_aura_negative_aura")
		npc.vengeance_aura_target = nil
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Creep stats adjustment
	-------------------------------------------------------------------------------------------------

	if not npc:IsHero() and not npc:IsOwnedByAnyPlayer() and not npc:IsBuilding() then
		-- Add passive buff to lane creeps
		if string.find(npc:GetUnitName(), "dota_creep") then
			npc:AddNewModifier(npc, nil, "modifier_imba_creep_power", {})
		end
	end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
	--local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	--if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
	--local entCause = EntIndexToHScript(keys.entindex_attacker)
	--local entVictim = EntIndexToHScript(keys.entindex_killed)
	--end

	if keys.entindex_killed ~= nil then
		if EntIndexToHScript(keys.entindex_killed):IsRealHero() then
			HeroVoiceLine(EntIndexToHScript(keys.entindex_killed), "pain")
		end
	end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
	DebugPrint( '[BAREBONES] OnItemPickedUp' )
	DebugPrintTable(keys)

	--local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	--local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	--local player = PlayerResource:GetPlayer(keys.PlayerID)
	--local itemname = keys.itemname
end

-- A player has reconnected to the game. This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
	PrintTable(keys)
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
local plyID = keys.PlayerID
if not plyID then return end
local hero = PlayerResource:GetSelectedHeroEntity(plyID)
local itemName = keys.itemname 
local itemcost = keys.itemcost

	if itemName == "item_imba_blink" then
		HeroVoiceLine(hero, "blink")
	else
		if RandomInt(1, 100) >= 50 then
			HeroVoiceLine(hero, "purch")
		end
	end
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
local player = keys.PlayerID
local abilityname = keys.abilityname
if not abilityname then return end

local hero = PlayerResource:GetSelectedHeroEntity(player)
if not hero then return end

local abilityUsed = hero:FindAbilityByName(abilityname)
if not abilityUsed then return end

	HeroVoiceLine(hero, "cast")

	if abilityname == "rubick_spell_steal" then
		local target = abilityUsed:GetCursorTarget()
		hero.spellStealTarget = target
	end

	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	if hero:GetUnitName() == "npc_dota_hero_meepo" then
		for m = 1, #meepo_table do
			if meepo_table[m]:IsClone() then
				if abilityname == "item_sphere" then
					print("Linken!")
					local duration = abilityname:GetSpecialValueFor("block_cooldown")					
					print("Duration", duration)
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_item_sphere_target", {duration = duration})
				end
			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Remote Mines adjustment
	-------------------------------------------------------------------------------------------------

	-- if abilityname == "techies_remote_mines" then

	-- 	local mine_caster = player:GetAssignedHero()
	-- 	Timers:CreateTimer(0.01, function()
	-- 		local nearby_units = FindUnitsInRadius(mine_caster:GetTeamNumber(), mine_caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 		for _,unit in pairs(nearby_units) do

	-- 			-- Only operate on remotes which need setup
	-- 			if unit.needs_remote_mine_setup then
	
	-- 				-- Add extra abilities
	-- 				unit:AddAbility("imba_techies_minefield_teleport")
	-- 				unit:AddAbility("imba_techies_remote_auto_creep")
	-- 				unit:AddAbility("imba_techies_remote_auto_hero")
	-- 				local minefield_teleport = unit:FindAbilityByName("imba_techies_minefield_teleport")
	-- 				local auto_creep = unit:FindAbilityByName("imba_techies_remote_auto_creep")
	-- 				local auto_hero = unit:FindAbilityByName("imba_techies_remote_auto_hero")
	-- 				auto_creep:SetLevel(1)
	-- 				auto_hero:SetLevel(1)

	-- 				-- Enable minefield teleport if the caster has a scepter
	-- 				local scepter = HasScepter(mine_caster)
	-- 				if scepter then
	-- 					minefield_teleport:SetLevel(1)
	-- 				end

	-- 				-- Toggle abilities on according to the current caster setting
	-- 				if mine_caster.auto_hero_exploding then
	-- 					auto_hero:ToggleAbility()
	-- 				elseif mine_caster.auto_creep_exploding then
	-- 					auto_creep:ToggleAbility()
	-- 				end

	-- 				-- Set this mine's setup as done
	-- 				unit.needs_remote_mine_setup = nil
	-- 			end
	-- 		end
	-- 	end)
	-- end

end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
	DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
	DebugPrint('[BAREBONES] OnPlayerChangedName')
	DebugPrintTable(keys)

	local newName = keys.newname
	local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
	DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
	DebugPrintTable(keys)

	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname

	-- If it the ability is Homing Missiles, wait a bit and set count to 1	
	if abilityname == "gyrocopter_homing_missile" then
		Timers:CreateTimer(1, function()
			-- Find homing missile modifier
			local modifier_charges = player:GetAssignedHero():FindModifierByName("modifier_gyrocopter_homing_missile_charge_counter")
			if modifier_charges then
				modifier_charges:SetStackCount(3)
			end
		end)
	end
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
	DebugPrint('[BAREBONES] OnAbilityChannelFinished')
	DebugPrintTable(keys)

	local abilityname = keys.abilityname
	local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)

	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Missing/Extra ability points correction
	-------------------------------------------------------------------------------------------------
	local missing_point_levels = {17, 19, 21, 22, 23, 24}
	local extra_point_levels = {33, 34, 37, 38, 39}
	local missing_point_levels_meepo = {17, 32, 33, 34, 36, 37, 38, 39}

	if hero:GetUnitName() == "npc_dota_hero_meepo" then
		-- Remove extra point on the appropriate levels for Meepo only
		for _, current_level in pairs(missing_point_levels_meepo) do
			if hero_level == current_level then
				hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
			end
		end
	else
		-- Remove extra point on the appropriate levels
		for _, current_level in pairs(extra_point_levels) do
			if hero_level == current_level then
				hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
			end
		end
	end

	-- Add missing point on the appropriate levels
	for _, current_level in pairs(missing_point_levels) do
		if hero_level == current_level then
			hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
		end
	end

--	local special_talent = 0
--	if hero_level == 34 then
--		for i = 1, 24 do
--			local ability_key = hero:GetKeyValue("Ability"..i)
--			if ability_key and string.find(ability_key, "special_bonus_unique_*") then
--				special_talent = special_talent +1
--				print(special_talent)
--			end
--		end

--		if special_talent < 2 then
--			print("Removing an ability point")
--			hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
--		end
--	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Hero experience bounty adjustment
	-------------------------------------------------------------------------------------------------

	hero:SetCustomDeathXP(HERO_XP_BOUNTY_PER_LEVEL[hero_level])
	HeroVoiceLine(hero, "level_voiceline")
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
	DebugPrint('[BAREBONES] OnLastHit')
	DebugPrintTable(keys)

	if keys.PlayerID == -1 then return end
	local isFirstBlood = keys.FirstBlood == 1
	local isHeroKill = keys.HeroKill == 1
	local isTowerKill = keys.TowerKill == 1
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local killedEnt = EntIndexToHScript(keys.EntKilled)

	if isFirstBlood then
		HeroVoiceLine(player:GetAssignedHero(), "firstblood")
		return
	elseif isHeroKill then
		HeroVoiceLine(player:GetAssignedHero(), "kill")
		return
	end
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
	DebugPrint('[BAREBONES] OnTreeCut')
	DebugPrintTable(keys)

	local treeX = keys.tree_x
	local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated(keys)
	DebugPrint('[BAREBONES] OnRuneActivated')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local rune = keys.rune

	PrintTable(rune)

	--[[ Rune Can be one of the following types
	DOTA_RUNE_DOUBLEDAMAGE
	DOTA_RUNE_HASTE
	DOTA_RUNE_HAUNTED
	DOTA_RUNE_ILLUSION
	DOTA_RUNE_INVISIBILITY
	DOTA_RUNE_BOUNTY
	DOTA_RUNE_MYSTERY
	DOTA_RUNE_RAPIER
	DOTA_RUNE_REGENERATION
	DOTA_RUNE_SPOOKY
	DOTA_RUNE_TURBO
	]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
	DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)

	local hero_entity = EntIndexToHScript(keys.heroindex)
	local player_id = hero_entity:GetPlayerID()
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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Comeback gold logic
	-------------------------------------------------------------------------------------------------
--	UpdateComebackBonus(1, killer_team)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Deathstreak logic
	-------------------------------------------------------------------------------------------------		
	if PlayerResource:IsValidPlayerID(killer_id) and PlayerResource:IsValidPlayerID(victim_id) then

		PlayerResource:ResetDeathstreak(killer_id)		
		PlayerResource:IncrementDeathstreak(victim_id)

		-- Show Deathstreak message
		local victim_hero_name = PlayerResource:GetPickedHeroName(victim_id)
		local victim_player_name = PlayerResource:GetPlayerName(victim_id)
		local victim_death_streak = PlayerResource:GetDeathstreak(victim_id)		
		local line_duration = 7

		if victim_death_streak then
			if victim_death_streak >= 3 then
				Notifications:BottomToAll({hero = victim_hero_name, duration = line_duration})
				Notifications:BottomToAll({text = victim_player_name.." ", duration = line_duration, continue = true})
			end

			if victim_death_streak == 3 then
				Notifications:BottomToAll({text = "#imba_deathstreak_3", duration = line_duration, continue = true})
			elseif victim_death_streak == 4 then
				Notifications:BottomToAll({text = "#imba_deathstreak_4", duration = line_duration, continue = true})
			elseif victim_death_streak == 5 then
				Notifications:BottomToAll({text = "#imba_deathstreak_5", duration = line_duration, continue = true})
			elseif victim_death_streak == 6 then
				Notifications:BottomToAll({text = "#imba_deathstreak_6", duration = line_duration, continue = true})
			elseif victim_death_streak == 7 then
				Notifications:BottomToAll({text = "#imba_deathstreak_7", duration = line_duration, continue = true})
			elseif victim_death_streak == 8 then
				Notifications:BottomToAll({text = "#imba_deathstreak_8", duration = line_duration, continue = true})
			elseif victim_death_streak == 9 then
				Notifications:BottomToAll({text = "#imba_deathstreak_9", duration = line_duration, continue = true})
			elseif victim_death_streak >= 10 then
				Notifications:BottomToAll({text = "#imba_deathstreak_10", duration = line_duration, continue = true})
			end	
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rancor logic
	-------------------------------------------------------------------------------------------------

	-- Victim stack loss
	local victim_hero = PlayerResource:GetPickedHero(victim_id)
	if victim_hero and victim_hero:HasModifier("modifier_imba_rancor") then
		local current_stacks = victim_hero:GetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER)
		if current_stacks <= 2 then
			victim_hero:RemoveModifierByName("modifier_imba_rancor")
		else
			victim_hero:SetModifierStackCount("modifier_imba_rancor", VENGEFUL_RANCOR_CASTER, current_stacks - math.floor(current_stacks / 2) - 1)
		end
	end
	
	-- Killer stack gain
	if victim_hero and VENGEFUL_RANCOR and PlayerResource:IsImbaPlayer(killer_id) and killer_team ~= VENGEFUL_RANCOR_TEAM then
		local eligible_rancor_targets = FindUnitsInRadius(victim_hero:GetTeamNumber(), victim_hero:GetAbsOrigin(), nil, 1500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if eligible_rancor_targets[1] then
			local rancor_stacks = 1

			-- Double stacks if the killed unit was Venge
			if victim_hero == VENGEFUL_RANCOR_CASTER then
				rancor_stacks = rancor_stacks * 2
			end

			-- Add stacks and play particle effect
			AddStacks(VENGEFUL_RANCOR_ABILITY, VENGEFUL_RANCOR_CASTER, eligible_rancor_targets[1], "modifier_imba_rancor", rancor_stacks, true)
			local rancor_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_negative_aura.vpcf", PATTACH_ABSORIGIN, eligible_rancor_targets[1])
			ParticleManager:SetParticleControl(rancor_pfx, 0, eligible_rancor_targets[1]:GetAbsOrigin())
			ParticleManager:SetParticleControl(rancor_pfx, 1, VENGEFUL_RANCOR_CASTER:GetAbsOrigin())
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Vengeance Aura logic
	-------------------------------------------------------------------------------------------------

	if victim_hero and PlayerResource:IsImbaPlayer(killer_id) then
		local vengeance_aura_ability = victim_hero:FindAbilityByName("imba_vengeful_command_aura")
		local killer_hero = PlayerResource:GetPickedHero(killer_id)
		if vengeance_aura_ability and vengeance_aura_ability:GetLevel() > 0 then
			vengeance_aura_ability:ApplyDataDrivenModifier(victim_hero, killer_hero, "modifier_imba_command_aura_negative_aura", {})
			victim_hero.vengeance_aura_target = killer_hero
		end
	end
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
	DebugPrintTable( keys )

	GameMode:_OnEntityKilled( keys )

	-- The Unit that was killed
	local killed_unit = EntIndexToHScript( keys.entindex_killed )

	-- The Killing entity
	local killer = nil

	if keys.entindex_attacker then
		killer = EntIndexToHScript( keys.entindex_attacker )
	end

	if killed_unit then
		-------------------------------------------------------------------------------------------------
		-- IMBA: Ancient destruction detection
		-------------------------------------------------------------------------------------------------
		if killed_unit:GetUnitName() == "npc_dota_badguys_fort" then
			GAME_WINNER_TEAM = 2
		elseif killed_unit:GetUnitName() == "npc_dota_goodguys_fort" then
			GAME_WINNER_TEAM = 3
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Respawn timer setup
		-------------------------------------------------------------------------------------------------
		local reincarnation_death = false
		if killed_unit:HasModifier("modifier_imba_reincarnation") then
			local wk_mod = killed_unit:FindModifierByName("modifier_imba_reincarnation")
			reincarnation_death = (wk_mod.can_die == false)
		end

		if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
			if killed_unit:GetCloneSource() and killed_unit:GetCloneSource():HasModifier("modifier_item_imba_aegis") then
				local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
				if meepo_table then
					for i = 1, #meepo_table do
						if meepo_table[i]:IsClone() then
							meepo_table[i]:SetRespawnsDisabled(true)
							meepo_table[i]:GetCloneSource():SetTimeUntilRespawn(killed_unit:GetCloneSource():FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							meepo_table[i]:GetCloneSource():RemoveModifierByName("modifier_item_imba_aegis")
						else
							meepo_table[i]:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
							return
						end
					end
				end
			elseif killed_unit:HasModifier("modifier_item_imba_aegis") then
				killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
			end
		end

		if reincarnation_death then
			killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_imba_reincarnation").reincarnate_delay)
		elseif killed_unit:HasModifier("modifier_item_imba_aegis") then
			killed_unit:SetTimeUntilRespawn(killed_unit:FindModifierByName("modifier_item_imba_aegis").reincarnate_time)
		elseif killed_unit:IsRealHero() and killed_unit:GetPlayerID() and (PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) or (GameRules:IsCheatMode() == true) ) then
			-- Calculate base respawn timer, capped at 60 seconds
			local hero_level = math.min(killed_unit:GetLevel(), 25)
			local respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]
			-- Calculate respawn timer reduction due to talents and modifiers
			respawn_time = respawn_time * killed_unit:GetRespawnTimeModifier_Pct() * 0.01
			respawn_time = math.max(respawn_time + killed_unit:GetRespawnTimeModifier(),0)
			-- Fetch decreased respawn timer due to Bloodstone charges
			if killed_unit.bloodstone_respawn_reduction and (respawn_time > 0) then
				respawn_time = math.max( respawn_time - killed_unit.bloodstone_respawn_reduction, 0)
			end

			-- Set up the respawn timer, include meepo fix
			if killed_unit:GetUnitName() == "npc_dota_hero_meepo" then
				KillMeepos()
			else
				if killed_unit:HasModifier("modifier_imba_reapers_scythe_respawn") then
					local reaper_scythe = killer:FindAbilityByName("imba_necrolyte_reapers_scythe"):GetSpecialValueFor("respawn_increase")
					print("ignore respawn time limit")
					print(reaper_scythe)
					respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level] + reaper_scythe
				elseif respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[25] then
					respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[25]
				end

				-- divide the respawn time by 2 for frantic mode
				if IMBA_FRANTIC_MODE_ON == true then
					killed_unit:SetTimeUntilRespawn(respawn_time * IMBA_FRANTIC_VALUE)
				else
					killed_unit:SetTimeUntilRespawn(respawn_time)
				end
			end
			HeroVoiceLine(killed_unit, "death")
		end

		-------------------------------------------------------------------------------------------------
		-- IMBA: Buyback setup
		-------------------------------------------------------------------------------------------------

		-- Check if the dying unit was a player-controlled hero
		if killed_unit:IsRealHero() and killed_unit:GetPlayerID() and PlayerResource:IsImbaPlayer(killed_unit:GetPlayerID()) then
			-- Buyback parameters
			local player_id = killed_unit:GetPlayerID()
			local hero_level = killed_unit:GetLevel()
			local game_time = GameRules:GetDOTATime(false, true)

			-- Calculate buyback cost
			local level_based_cost = math.min(hero_level * hero_level, 625) * BUYBACK_COST_PER_LEVEL
			if hero_level > 25 then
				level_based_cost = level_based_cost + BUYBACK_COST_PER_LEVEL_AFTER_25 * (hero_level - 25)
			end
			local buyback_cost = BUYBACK_BASE_COST + level_based_cost + game_time * BUYBACK_COST_PER_SECOND		
			local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"])
			buyback_cost = buyback_cost * (1 + custom_gold_bonus * 0.01)

			-- Setup buyback cooldown
			local buyback_cooldown = 0
			-- if BUYBACK_COOLDOWN_ENABLED and game_time > BUYBACK_COOLDOWN_START_POINT then
			-- 	buyback_cooldown = math.min(BUYBACK_COOLDOWN_GROW_FACTOR * (game_time - BUYBACK_COOLDOWN_START_POINT), BUYBACK_COOLDOWN_MAXIMUM)
			-- end
			buyback_cooldown = 90

			-- #7 Talent Vengeful Spirit - Decreased respawn time & cost
			if killed_unit:HasTalent("special_bonus_imba_vengefulspirit_7") then
				buyback_cost = buyback_cost * (1 - (killed_unit:FindSpecificTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cost_pct") * 0.01))
				buyback_cooldown = buyback_cooldown * (1 - (killed_unit:FindSpecificTalentValue("special_bonus_imba_vengefulspirit_7", "buyback_cooldown_pct") * 0.01))			
			end

			-- Update buyback cost
			PlayerResource:SetCustomBuybackCost(player_id, buyback_cost)
			PlayerResource:SetCustomBuybackCooldown(player_id, buyback_cooldown)
		end

		if string.find(killed_unit:GetUnitName(), "dota_creep") then
			if killer:GetTeamNumber() == killed_unit:GetTeamNumber() then
				HeroVoiceLine(killer, "deny")
			else
				HeroVoiceLine(killer, "lasthit")
			end
		end
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they have completely connected
function GameMode:PlayerConnect(keys)
	DebugPrint('[BAREBONES] PlayerConnect')
	DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
	DebugPrint('[BAREBONES] OnConnectFull')
	DebugPrintTable(keys)

	GameMode:_OnConnectFull(keys)
	
	local entIndex = keys.index+1
	local ply = EntIndexToHScript(entIndex)
	local player_id = ply:GetPlayerID()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Player data initialization
	-------------------------------------------------------------------------------------------------
	print("Player has fully connected:", player_id)

--	if player.is_dev then
--		CustomGameEventManager:Send_ServerToPlayer(player:GetPlayerOwner(), "show_netgraph", {})
--	end
	-------------------------------------------------------------------------------------------------
	-- IMBA: Player reconnect logic
	-------------------------------------------------------------------------------------------------
	ReconnectPlayer(player_id)

	PlayerResource:InitPlayerData(player_id)
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
	local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
	DebugPrint('[BAREBONES] OnItemCombined')
	DebugPrintTable(keys)

	-- The playerID of the hero who is buying something
	local plyID = keys.PlayerID
	if not plyID then return end
	local player = PlayerResource:GetPlayer(plyID)

	-- The name of the item purchased
	local itemName = keys.itemname 
	
	-- The cost of the item purchased
	local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
	DebugPrint('[BAREBONES] OnAbilityCastBegins')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
	local gold = keys.gold
	local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
	local tower_team = keys.teamnumber	

	-------------------------------------------------------------------------------------------------
	-- IMBA: Attack of the Ancients tower upgrade logic
	-------------------------------------------------------------------------------------------------
	
	-- Always enabled!
--	if TOWER_UPGRADE_MODE then		
		
		-- Find all friendly towers on the map
		local towers = FindUnitsInRadius(tower_team, Vector(0, 0, 0), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
		-- Upgrade each tower
		for _, tower in pairs(towers) do						
			UpgradeTower(tower)			
		end		
		
		-- Display upgrade message and play ominous sound
		if tower_team == DOTA_TEAM_GOODGUYS then			
			Notifications:BottomToAll({text = "#tower_abilities_radiant_upgrade", duration = 7, style = {color = "DodgerBlue"}})
			EmitGlobalSound("powerup_01")			
		else			
			Notifications:BottomToAll({text = "#tower_abilities_dire_upgrade", duration = 7, style = {color = "DodgerBlue"}})
			EmitGlobalSound("powerup_02")			
		end
--	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Update comeback gold logic
	-------------------------------------------------------------------------------------------------

--	local team = PlayerResource:GetTeam(keys.killer_userid)
--	UpdateComebackBonus(2, team)
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
	DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
	DebugPrintTable(keys)

	local player = PlayerResource:GetPlayer(keys.player_id)
	local success = (keys.success == 1)
	local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
	DebugPrint('[BAREBONES] OnNPCGoalReached')
	DebugPrintTable(keys)

	local goalEntity = EntIndexToHScript(keys.goal_entindex)
	local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
	local npc = EntIndexToHScript(keys.npc_entindex)
end
