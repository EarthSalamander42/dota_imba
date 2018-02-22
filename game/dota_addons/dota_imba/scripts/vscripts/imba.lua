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
--
-- Editors: 
--     EarthSalamander #42
--

-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output

BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
	DebugPrint( '[IMBA] creating game mode' )
	_G.GameMode = class({})
end

require('libraries/timers')
require('libraries/physics')
require('libraries/projectiles')
require('libraries/projectiles_new')
require('libraries/notifications')
require('libraries/animations')
require('libraries/attachments')
-- A*-Path-finding logic
require('libraries/astar')
-- Illusion manager, created by Seinken!
require('libraries/illusionmanager')
require('libraries/keyvalues')
-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
-- All custom constants
require('internal/constants')
-- This library used to handle scoreboard events
require('internal/scoreboard_events')
-- This library used to handle custom IMBA talent UI (hero_selection will need to use a function in this)
require('internal/imba_talent_events')

-- Meepo Vanilla fix
require('libraries/meepo/meepo')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

require('api/api')
require('api/frontend')

require('battlepass/experience')
require('battlepass/imbattlepass')

-- clientside KV loading
require('addon_init')

ApplyAllTalentModifiers()
StoreCurrentDayCycle()

--	if IsInToolsMode() then
--		OverrideCreateParticle()
--		OverrideReleaseIndex()
--	end

function GameMode:PostLoadPrecache()
	-- precache companions
	if GetAllCompanions() ~= nil then
		for k, v in pairs(GetAllCompanions()) do
			PrecacheUnitWithQueue(v.file)
		end
	end

	-- Ancient
	PrecacheUnitWithQueue("npc_dota_hero_juggernaut")

	-- Storegga
	PrecacheUnitWithQueue("npc_dota_hero_earth_spirit")
	PrecacheUnitWithQueue("npc_dota_hero_leshrac")
	PrecacheUnitWithQueue("npc_dota_hero_phantom_assassin")
	PrecacheUnitWithQueue("npc_dota_hero_tiny")
end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()

	-------------------------------------------------------------------------------------------------
	-- IMBA: API. Preload
	-------------------------------------------------------------------------------------------------
	ImbaApiFrontendInit(function ()
		--
		-- Here API Data is guaranteed to be available !!!
		--
		--		PrintTable(GetTopImrUsers())
		end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Roshan and Picking Screen camera initialization
	-------------------------------------------------------------------------------------------------
	if GetMapName() == "imba_overthrow" then
		GoodCamera = Entities:FindByName(nil, "@overboss")
		BadCamera = Entities:FindByName(nil, "@overboss")

		-- Spawning monsters
		spawncamps = {}
		for i = 1, OVERTHROW_CAMP_NUMBER do
			local campname = "camp"..i.."_path_customspawn"
			spawncamps[campname] =
				{
					NumberToSpawn = RandomInt(3,5),
					WaypointName = "camp"..i.."_path_wp1"
				}
		end
		GameMode:CustomSpawnCamps()
	else
		GoodCamera = Entities:FindByName(nil, "dota_goodguys_fort")
		BadCamera = Entities:FindByName(nil, "dota_badguys_fort")
		ROSHAN_SPAWN_LOC = Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):GetAbsOrigin()
		Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):RemoveSelf()
		local roshan = CreateUnitByName("npc_imba_roshan", ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Pre-pick forced hero selection
	-------------------------------------------------------------------------------------------------
	flItemExpireTime = 60.0
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Contributor models
	-------------------------------------------------------------------------------------------------

	for i = 2, 3 do
		for _, amphibian in pairs(Entities:FindAllByName("imbamphibian"..i)) do
			local imbamphibian = CreateUnitByName("npc_imba_amphibian", amphibian:GetAbsOrigin(), true, nil, nil, i)
			imbamphibian:SetForwardVector(Vector(1, 1, 0):Normalized())
			imbamphibian:AddNewModifier(imbamphibian, nil, "modifier_imba_amphibian", {})
		end
	end

	-- Contributor statue list
	local contributor_statues = {
		"npc_imba_contributor_hjort",
		"npc_imba_contributor_martyn",
		"npc_imba_contributor_mikkel",
		"npc_imba_contributor_anees",
		"npc_imba_contributor_swizard",
		"npc_imba_contributor_phroureo",
		"npc_imba_contributor_catchy",
		"npc_imba_contributor_matt",
		"npc_imba_contributor_maxime",
		"npc_imba_contributor_poly",
		"npc_imba_contributor_firstlady",
		"npc_imba_contributor_wally_chan"
	}

	-- Add 6 random contributor statues
	local current_location = {}
	current_location[1] = Vector(-6900, -5400, 384)
	current_location[2] = Vector(-6900, -5100, 384)
	current_location[3] = Vector(-6900, -4800, 384)
	current_location[4] = Vector(6900, 5000, 384)
	current_location[5] = Vector(6900, 4700, 384)
	current_location[6] = Vector(6900, 4400, 384)

	local current_statue
	local statue_entity
	for i = 1, 6 do
		current_statue = table.remove(contributor_statues, RandomInt(1, #contributor_statues))
		if i <= 3 then
			statue_entity = CreateUnitByName(current_statue, current_location[i], true, nil, nil, DOTA_TEAM_GOODGUYS)
			statue_entity:SetForwardVector(Vector(1, 1, 0):Normalized())
		else
			statue_entity = CreateUnitByName(current_statue, current_location[i], true, nil, nil, DOTA_TEAM_BADGUYS)
			statue_entity:SetForwardVector(Vector(-1, -1, 0):Normalized())
		end
		statue_entity:AddNewModifier(statue_entity, nil, "modifier_imba_contributor_statue", {})
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: developer models
	-------------------------------------------------------------------------------------------------

	-- Developer statue list
	local developer_statues = {
		"npc_imba_developer_shush",
		"npc_imba_developer_firetoad",
		"npc_imba_developer_xthedark",
		"npc_imba_developer_zimber",
		"npc_imba_developer_hewdraw",
		"npc_imba_developer_iaminnocent",
		"npc_imba_developer_noobsauce",
		"npc_imba_developer_seinken",
		"npc_imba_developer_mouji",
		"npc_imba_developer_atrocty",
		"npc_imba_developer_broccoli",
		"npc_imba_developer_cookies",
		"npc_imba_developer_dewouter",
		"npc_imba_developer_suthernfriend",
		"npc_imba_developer_fudge",
		"npc_imba_developer_lindbrum",
		"npc_imba_developer_sercankd",
		"npc_imba_developer_yahnich",
	}

	-- Add 6 random developer statues
	local current_location = {}
	current_location[1] = Vector(-5800, -6300, 384)
	current_location[2] = Vector(-5500, -6300, 384)
	current_location[3] = Vector(-5200, -6300, 384)
	current_location[4] = Vector(5800, 6300, 384)
	current_location[5] = Vector(5500, 6300, 384)
	current_location[6] = Vector(5200, 6300, 384)

	local current_statue
	local statue_entity
	for i = 1, 6 do
		current_statue = table.remove(developer_statues, RandomInt(1, #developer_statues))
		if i <= 3 then
			statue_entity = CreateUnitByName(current_statue, current_location[i], true, nil, nil, DOTA_TEAM_GOODGUYS)
			statue_entity:SetForwardVector(Vector(1, 1, 0):Normalized())
		else
			statue_entity = CreateUnitByName(current_statue, current_location[i], true, nil, nil, DOTA_TEAM_BADGUYS)
			statue_entity:SetForwardVector(Vector(-1, -1, 0):Normalized())
		end
		statue_entity:AddNewModifier(statue_entity, nil, "modifier_imba_contributor_statue", {})
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arena mode score initialization
	-------------------------------------------------------------------------------------------------

	CustomNetTables:SetTableValue("game_options", "radiant", {score = 25})
	CustomNetTables:SetTableValue("game_options", "dire", {score = 25})
end

-- Gold gain filter function
function GameMode:GoldFilter( keys )
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end

	local hero = PlayerResource:GetPlayer(keys.player_id_const):GetAssignedHero()

	-- Ignore negative experience values
	if keys.gold < 0 then
		return false
	end

	-- Hand of Midas gold bonus
	if hero and hero:HasModifier("modifier_item_imba_hand_of_midas") and keys.gold > 0 then
		keys.gold = keys.gold * 1.1
	end

	-- Lobby options adjustment
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30) -- minutes
	local custom_gold_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "bounty_multiplier")["1"]) or 100

	if keys.reason_const == DOTA_ModifyGold_HeroKill then
		keys.gold = keys.gold * (custom_gold_bonus / 100)
		if not hero.kill_hero_bounty then hero.kill_hero_bounty = 0 end
		if hero.kill_hero_bounty == 0 then hero.kill_hero_bounty = keys.gold end
		if hero.kill_hero_bounty ~= 0 and hero.kill_hero_bounty ~= keys.gold then
			CustomNetTables:SetTableValue("player_table", tostring(keys.player_id_const), {hero_kill_bounty = keys.gold + hero.kill_hero_bounty})
		end
	else
		--		print(keys.gold, custom_gold_bonus / 100, 1 + game_time / 25)
		keys.gold = (custom_gold_bonus / 100) + (1 + game_time / 25) * keys.gold
		--		print(keys.gold)
	end

	-- Comeback gold gain
	--	local team = PlayerResource:GetTeam(keys.player_id_const)
	--	if COMEBACK_BOUNTY_BONUS[team] > 0 then
	--		keys.gold = keys.gold * (1 + COMEBACK_BOUNTY_BONUS[team])
	--	end

	local reliable = false
	if keys.reason_const == DOTA_ModifyGold_HeroKill or keys.reason_const == DOTA_ModifyGold_RoshanKill or keys.reason_const == DOTA_ModifyGold_CourierKill or keys.reason_const == DOTA_ModifyGold_Building then
		reliable = true
	end

	-- Show gold earned message??
	if hero then
		hero:ModifyGold(keys.gold, reliable, keys.reason_const)
		if keys.reason_const == DOTA_ModifyGold_Unspecified then return true end
		SendOverheadEventMessage(PlayerResource:GetPlayer(keys.player_id_const), OVERHEAD_ALERT_GOLD, hero, keys.gold, nil)
	end

	return false
end

-- Experience gain filter function
function GameMode:ExperienceFilter( keys )
	-- reason_const		1 (DOTA_ModifyXP_CreepKill)
	-- experience		130
	-- player_id_const	0

	local hero = PlayerResource:GetPickedHero(keys.player_id_const)

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	if keys.reason_const == DOTA_ModifyXP_HeroKill then
		keys.experience = keys.experience * (custom_xp_bonus / 100)
	else
		keys.experience = keys.experience * (custom_xp_bonus / 100) * (1 + game_time / 200)
	end

	-- Losing team gets huge EXP bonus.
	--	if hero and CustomNetTables:GetTableValue("gamerules", "losing_team") then
	--		if CustomNetTables:GetTableValue("gamerules", "losing_team").losing_team then
	--			local losing_team = CustomNetTables:GetTableValue("gamerules", "losing_team").losing_team

	--			if hero:GetTeamNumber() == losing_team then
	--				keys.experience = keys.experience * (1 + COMEBACK_EXP_BONUS * 0.01)
	--			end
	--		end
	--	end

	return true
end

-- Modifier gained filter function
function GameMode:ModifierFilter( keys )
	-- entindex_parent_const	215
	-- entindex_ability_const	610
	-- duration					-1
	-- entindex_caster_const	215
	-- name_const				modifier_imba_roshan_rage_stack

	if IsServer() then
		local modifier_owner = EntIndexToHScript(keys.entindex_parent_const)
		local modifier_name = keys.name_const
		local modifier_caster
		if keys.entindex_caster_const then
			modifier_caster = EntIndexToHScript(keys.entindex_caster_const)
		else
			return true
		end

		if GetMapName() == "imba_overthrow" then
			if modifier_name == "modifier_fountain_aura_buff" then
				return false
			end
		end

		if modifier_name == "modifier_datadriven" then
			return false
		end

		-------------------------------------------------------------------------------------------------
		-- Roshan special modifier rules
		-------------------------------------------------------------------------------------------------
		if IsRoshan(modifier_owner) then
			-- Ignore stuns
			if modifier_name == "modifier_stunned" then
				return false
			end

			-- Halve the duration of everything else
			if modifier_caster ~= modifier_owner and keys.duration > 0 then
				keys.duration = keys.duration * 0.5
			end

			-- Fury swipes capping
			if modifier_owner:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil) > 5 then
				modifier_owner:SetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", nil, 5)
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Tenacity debuff duration reduction
		-------------------------------------------------------------------------------------------------
		if modifier_owner.GetTenacity and keys.duration > 0 then
			local original_duration = keys.duration
			local actually_duration = original_duration
			local tenacity = modifier_owner:GetTenacity()
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then --and tenacity ~= 0 then
				actually_duration = actually_duration * (100 - tenacity) * 0.01
				-------------------------------------------------------------------------------------------------
				-- Frantic mode duration adjustment
				-------------------------------------------------------------------------------------------------
				if IMBA_FRANTIC_MODE_ON then
					actually_duration = actually_duration * IMBA_FRANTIC_VALUE
				end
			end

			local modifier_handler = modifier_owner:FindModifierByName(modifier_name)
			if modifier_handler then
				if modifier_handler.IgnoreTenacity then
					if modifier_handler:IgnoreTenacity() then
						actually_duration = original_duration
					end
				end
			end
			keys.duration = actually_duration
		end

		-------------------------------------------------------------------------------------------------
		-- Frantic mode duration adjustment
		-------------------------------------------------------------------------------------------------
		if modifier_name == "modifier_imba_doom_bringer_doom" then
			if IMBA_FRANTIC_MODE_ON then
				local original_duration = keys.duration
				local actually_duration = original_duration
				actually_duration = actually_duration * IMBA_FRANTIC_VALUE
				keys.duration = actually_duration
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Silencer Arcane Supremacy silence duration reduction
		-------------------------------------------------------------------------------------------------
		if modifier_owner:HasModifier("modifier_imba_silencer_arcane_supremacy") then
			if not modifier_owner:PassivesDisabled() then

				local arcane_supremacy = modifier_owner:FindModifierByName("modifier_imba_silencer_arcane_supremacy")
				local silence_reduction_pct
				if arcane_supremacy then
					silence_reduction_pct = arcane_supremacy:GetSilenceReductionPct() * 0.01
				end

				if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then
					if IsVanillaSilence(modifier_name) or IsImbaSilence(modifier_name) then
						-- if reduction is 1 (or more), the modifier is completely ignored
						if silence_reduction_pct >= 1 then
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_LAST_HIT_MISS, modifier_owner, 0, nil)
							return false
						else
							keys.duration = keys.duration * (1 - silence_reduction_pct)
						end
					elseif IsSilentSilence(modifier_name) then
						if silence_reduction_pct >= 1 then
							return false
						else
							keys.duration = keys.duration * (1 - silence_reduction_pct)
						end
					end
				end
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Silencer Arcane Supremacy silence duration increase for Silencer's applied silences
		-------------------------------------------------------------------------------------------------
		if modifier_caster:HasModifier("modifier_imba_silencer_arcane_supremacy") and not modifier_owner:PassivesDisabled() then
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then

				durationIncreasePcnt = modifier_caster:FindTalentValue("special_bonus_imba_silencer_3") * 0.01
				if durationIncreasePcnt > 0 then

					-- If the modifier is a vanilla one, increase duration directly
					if IsVanillaSilence(modifier_name) or IsImbaSilence(modifier_name) then
						keys.duration = keys.duration * (1 + durationIncreasePcnt)
					end
				end
			end
		end

		-------------------------------------------------------------------------------------------------
		-- Rune pickup logic
		-------------------------------------------------------------------------------------------------
		if modifier_caster == modifier_owner then
			if modifier_caster:HasModifier("modifier_rune_doubledamage") then
				local duration = modifier_caster:FindModifierByName("modifier_rune_doubledamage"):GetDuration()
				modifier_caster:RemoveModifierByName("modifier_rune_doubledamage")
				modifier_caster:AddNewModifier(modifier_caster, nil, "modifier_imba_double_damage_rune", {duration = duration})
			elseif modifier_caster:HasModifier("modifier_rune_haste") then
				local duration = modifier_caster:FindModifierByName("modifier_rune_haste"):GetDuration()
				modifier_caster:RemoveModifierByName("modifier_rune_haste")
				modifier_caster:AddNewModifier(modifier_caster, nil, "modifier_imba_haste_rune", {duration = duration})
			elseif modifier_caster:HasModifier("modifier_rune_invis") then
			--				PickupInvisibleRune(modifier_caster)
			--				return false
			elseif modifier_caster:HasModifier("modifier_rune_regen") then
				local duration = modifier_caster:FindModifierByName("modifier_rune_regen"):GetDuration()
				modifier_caster:RemoveModifierByName("modifier_rune_regen")
				modifier_caster:AddNewModifier(modifier_caster, nil, "modifier_imba_regen_rune", {duration = duration})
			end
		end

		--		if modifier_name == "modifier_courier_shield" then
		--			modifier_caster:RemoveModifierByName(modifier_name)
		--			modifier_caster:FindAbilityByName("courier_burst"):CastAbility()
		--		end

		-- disarm immune
		local jarnbjorn_immunity = {
			"modifier_item_imba_triumvirate_proc_debuff",
			"modifier_item_imba_sange_azura_proc",
			"modifier_item_imba_sange_yasha_disarm",
			"modifier_item_imba_heavens_halberd_active_disarm",
			"modifier_item_imba_sange_disarm",
			"modifier_imba_angelic_alliance_debuff",
			"modifier_imba_overpower_disarm",
			"modifier_imba_silencer_last_word_debuff",
			"modifier_imba_hurl_through_hell_disarm",
			"modifier_imba_frost_armor_freeze",
			"modifier_dismember_disarm",
			"modifier_imba_decrepify",

		--			"modifier_imba_faceless_void_time_lock_stun",
		--			"modifier_bashed",
		}

		-- add particle or sound playing to notify
		if modifier_owner:HasModifier("modifier_item_imba_jarnbjorn_static") then
			for _, modifier in pairs(jarnbjorn_immunity) do
				if modifier_name == modifier then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, modifier_owner, 0, nil)
					return false
				end
			end
		end

		if modifier_name == "modifier_fountain_aura_buff" then
			modifier_owner:AddNewModifier(modifier_owner, nil, "modifier_imba_fountain_particle_control", {})
		end

		return true
	end
end

-- Item added to inventory filter
function GameMode:ItemAddedFilter( keys )

	-- Typical keys:
	-- inventory_parent_entindex_const: 852
	-- item_entindex_const: 1519
	-- item_parent_entindex_const: -1
	-- suggested_slot: -1
	local unit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local item = EntIndexToHScript(keys.item_entindex_const)
	if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then return false end
	local item_name = 0
	if item:GetName() then
		item_name = item:GetName()
	end

	print(item_name)
	if string.find(item_name, "item_imba_rune_") and unit:IsRealHero() then
		PickupRune(item_name, unit)
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Aegis of the Immortal pickup logic
	-------------------------------------------------------------------------------------------------
	if item_name == "item_imba_aegis" then
		-- If this is a player, do Aegis stuff
		if unit:IsRealHero() and not unit:HasModifier("modifier_item_imba_aegis") then

			-- Display aegis pickup message for all players
			unit:AddNewModifier(unit, item, "modifier_item_imba_aegis",{})
			local line_duration = 7
			Notifications:BottomToAll({hero = unit:GetName(), duration = line_duration})
			Notifications:BottomToAll({text = PlayerResource:GetPlayerName(unit:GetPlayerID()).." ", duration = line_duration, continue = true})
			Notifications:BottomToAll({text = "#imba_player_aegis_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

			-- Destroy the item
			return false
				-- If this is not a player, do nothing and drop another Aegis
		else
			local drop = CreateItem("item_imba_aegis", nil, nil)
			CreateItemOnPositionSync(unit:GetAbsOrigin(), drop)
			drop:LaunchLoot(false, 250, 0.5, unit:GetAbsOrigin() + RandomVector(100))

			UTIL_Remove(item:GetContainer())
			UTIL_Remove(item)

			-- Destroy the item
			return false
		end
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Rapier pickup logic
	-------------------------------------------------------------------------------------------------
	if item.IsRapier then
		if item.rapier_pfx then
			ParticleManager:DestroyParticle(item.rapier_pfx, false)
			ParticleManager:ReleaseParticleIndex(item.rapier_pfx)
			item.rapier_pfx = nil
		end
		if item.x_pfx then
			ParticleManager:DestroyParticle(item.x_pfx, false)
			ParticleManager:ReleaseParticleIndex(item.x_pfx)
			item.x_pfx = nil
		end
		if unit:IsRealHero() or ( unit:GetClassname() == "npc_dota_lone_druid_bear" ) then
			item:SetPurchaser(nil)
			item:SetPurchaseTime(0)
			local rapier_amount = 0
			local rapier_2_amount = 0
			local rapier_magic_amount = 0
			local rapier_magic_2_amount = 0
			for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
				local current_item = unit:GetItemInSlot(i)
				if not current_item then
					return true
				elseif current_item and current_item:GetName() == "item_imba_rapier" then
					rapier_amount = rapier_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_2" then
					rapier_2_amount = rapier_2_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_magic" then
					rapier_magic_amount = rapier_magic_amount + 1
				elseif current_item and current_item:GetName() == "item_imba_rapier_magic_2" then
					rapier_magic_2_amount = rapier_magic_2_amount + 1
				end
			end
			if 	((item_name == "item_imba_rapier") and (rapier_amount == 2)) or
				((item_name == "item_imba_rapier_magic") and (rapier_magic_amount == 2)) or
				((item_name == "item_imba_rapier_2") and (rapier_magic_2_amount >= 1)) or
				((item_name == "item_imba_rapier_magic_2") and (rapier_2_amount >= 1)) then
				return true
			else
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_item_enough_slots")
			end
		end
		if unit:IsIllusion() or unit:IsTempestDouble() then
			return true
		else
			unit:DropRapier(nil, item_name)
		end
		return false
	end

	-------------------------------------------------------------------------------------------------
	-- Tempest Double forbidden items
	-------------------------------------------------------------------------------------------------

	if unit:IsTempestDouble() then

		-- List of items the clone can't carry
		local clone_forbidden_items = {
			"item_imba_rapier",
			"item_imba_rapier_2",
			"item_imba_rapier_magic",
			"item_imba_rapier_magic_2",
			"item_imba_rapier_cursed",
			"item_imba_moon_shard",
			"item_imba_soul_of_truth",
			"item_imba_mango",
			"item_imba_refresher",
			"item_imba_ultimate_scepter_synth"
		}

		-- If this item is forbidden, delete it
		for _, forbidden_item in pairs(clone_forbidden_items) do
			if item_name == forbidden_item then
				return false
			end
		end
	end

	return true
end

-- Order filter function
function GameMode:OrderFilter( keys )

	--entindex_ability	 ==> 	0
	--sequence_number_const	 ==> 	20
	--queue	 ==> 	0
	--units	 ==> 	table: 0x031d5fd0
	--entindex_target	 ==> 	0
	--position_z	 ==> 	384
	--position_x	 ==> 	-5694.3334960938
	--order_type	 ==> 	1
	--position_y	 ==> 	-6381.1127929688
	--issuer_player_id_const	 ==> 	0

	local units = keys["units"]
	local unit
	if units["0"] then
		unit = EntIndexToHScript(units["0"])
	else
		return nil
	end

	-- Do special handlings if shift-casted only here! The event gets fired another time if the caster
	-- is actually doing this order
	if keys.queue == 1 then
		return true
	end

	--	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
	--		local ability = EntIndexToHScript(keys["entindex_ability"])
	--		if unit:IsRealHero() then
	--			local companions = FindUnitsInRadius(unit:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	--			for _, companion in pairs(companions) do
	--				if companion:GetUnitName() == "npc_imba_donator_companion" and companion:GetOwner() == unit then
	--					if ability:GetAbilityName() == "slark_pounce" then
	--						local ab = companion:AddAbility(ability:GetAbilityName())
	--						ab:SetLevel(1)
	--						ab:EndCooldown()
	--						companion:CastAbilityNoTarget(ab, -1)
	--						Timers:CreateTimer(ab:GetCastPoint() + 0.1, function()
	--							companion:RemoveAbility(ab:GetAbilityName())
	--						end)
	--					end
	--				end
	--			end
	--		end
	--	end

	if keys.order_type == DOTA_UNIT_ORDER_GLYPH then
		CombatEvents("generic", "glyph", unit)
	end

	------------------------------------------------------------------------------------
	-- Prevent Buyback during reincarnation
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_BUYBACK then
		if unit:IsReincarnating() then
			return false
		end
	end

	------------------------------------------------------------------------------------
	-- Witch Doctor Death Ward handler
	------------------------------------------------------------------------------------
	if unit:HasModifier("modifier_imba_death_ward") then
		if keys.order_type ==  DOTA_UNIT_ORDER_ATTACK_TARGET then
			local death_ward_mod = unit:FindModifierByName("modifier_imba_death_ward")
			death_ward_mod.attack_target = EntIndexToHScript(keys.entindex_target)
			return true
		else
			return nil
		end
	end

	if unit:HasModifier("modifier_imba_death_ward_caster") then
		if keys.order_type ==  DOTA_UNIT_ORDER_ATTACK_TARGET then
			local modifier = unit:FindModifierByName("modifier_imba_death_ward_caster")
			modifier.death_ward_mod.attack_target = EntIndexToHScript(keys.entindex_target)
			return nil
		end
	end

	------------------------------------------------------------------------------------
	-- Riki Blink-Strike handler
	------------------------------------------------------------------------------------
	if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
		local ability = EntIndexToHScript(keys["entindex_ability"])
		if ability:GetAbilityName() == "imba_riki_blink_strike" then
			ability.thinker = unit:AddNewModifier(unit, ability, "modifier_imba_blink_strike_thinker", {target = keys.entindex_target})
		end
	end

	------------------------------------------------------------------------------------
	-- Queen of Pain's Sonic Wave confusion
	------------------------------------------------------------------------------------

	if unit:HasModifier("modifier_imba_sonic_wave_daze") then
		-- Determine order type
		local modifier = unit:FindModifierByName("modifier_imba_sonic_wave_daze")
		local rand = math.random

		-- Change "move to target" to "move to position"
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_MOVE_TO_POSITION
		end

		-- Change "attack target" to "attack move"
		if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			local target_loc = target:GetAbsOrigin()
			keys.position_x = target_loc.x
			keys.position_y = target_loc.y
			keys.position_z = target_loc.z
			keys.entindex_target = 0
			keys.order_type = DOTA_UNIT_ORDER_ATTACK_MOVE
		end

		-- Change "cast on target" target
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then

			local target = EntIndexToHScript(keys["entindex_target"])
			local ability = EntIndexToHScript(keys["entindex_ability"])
			local caster_loc = unit:GetAbsOrigin()
			local target_loc = target:GetAbsOrigin()
			local target_distance = (target_loc - caster_loc):Length2D()

			local nearby_units = FindUnitsInRadius(unit:GetTeamNumber(), caster_loc, nil, math.max(target_distance,(ability:GetCastRange(caster_loc, unit)) + GetCastRangeIncrease(unit)), ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			if #nearby_units >= 1 then
				keys.entindex_target = nearby_units[1]:GetEntityIndex()

				-- If no target was found, change to "cast on position" order
			else
				keys.position_x = target_loc.x
				keys.position_y = target_loc.y
				keys.position_z = target_loc.z
				keys.entindex_target = 0
				keys.order_type = DOTA_UNIT_ORDER_CAST_POSITION
			end

			-- Reduce stack-amount
			if not (keys.queue == 1) then
				modifier:DecrementStackCount()
			end
			if modifier:GetStackCount() == 0 then
				modifier:Destroy()
			end
		end

		if keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
		-- Still needs some checkup

		end

		-- Spin positional orders a random angle
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or keys.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
			-- Calculate new order position
			local target_loc = Vector(keys.position_x, keys.position_y, keys.position_z)
			local origin_loc = unit:GetAbsOrigin()
			local order_vector = target_loc - origin_loc
			local new_order_vector = RotatePosition(origin_loc, QAngle(0, 180, 0), origin_loc + order_vector)

			-- Override order
			keys.position_x = new_order_vector.x
			keys.position_y = new_order_vector.y
			keys.position_z = new_order_vector.z

			-- Reduce stack-amount
			if not (keys.queue == 1) then
				modifier:DecrementStackCount()
			end
			if modifier:GetStackCount() == 0 then
				modifier:Destroy()
			end
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local ability = EntIndexToHScript(keys.entindex_ability)

		-- Kunkka Torrent cast-handling
		if ability:GetAbilityName() == "imba_kunkka_torrent" then
			local range = ability.BaseClass.GetCastRange(ability,ability:GetCursorPosition(),unit) + GetCastRangeIncrease(unit)
			if unit:HasModifier("modifier_imba_ebb_and_flow_tide_low") or unit:HasModifier("modifier_imba_ebb_and_flow_tsunami") then
				range = range + ability:GetSpecialValueFor("tide_low_range")
			end
			local distance = (unit:GetAbsOrigin() - Vector(keys.position_x,keys.position_y,keys.position_z)):Length2D()

			if ( range >= distance) then
				unit:AddNewModifier(unit, ability, "modifier_imba_torrent_cast", {duration = 0.41} )
			end
		end

		-- Kunkka Tidebringer cast-handling
		if ability:GetAbilityName() == "imba_kunkka_tidebringer" then
			ability.manual_cast = true
		end

	elseif unit:HasModifier("modifier_imba_torrent_cast") and keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
		unit:RemoveModifierByName("modifier_imba_torrent_cast")
	end
	-- Tidebringer manual cast
	if unit:HasModifier("modifier_imba_tidebringer_manual") then
		unit:RemoveModifierByName("modifier_imba_tidebringer_manual")
	end

	-- Culling Blade leap
	if unit:HasModifier("modifier_imba_axe_culling_blade_leap") then
		return false
	end

	if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
		local ability = EntIndexToHScript(keys.entindex_ability)

		-- Techies' Focused Detonate cast-handling
		if ability:GetAbilityName() == "imba_techies_focused_detonate" then
			unit:AddNewModifier(unit, ability, "modifier_imba_focused_detonate", {duration = 0.2})
		end

		-- Mirana's Leap talent cast-handling
		if ability:GetAbilityName() == "imba_mirana_leap" and unit:HasTalent("special_bonus_imba_mirana_7") then
			unit:AddNewModifier(unit, ability, "modifier_imba_leap_talent_cast_angle_handler", {duration = FrameTime()})
		end
	end


	-- Meepo item handle
	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	local ability = EntIndexToHScript(keys.entindex_ability)
	if unit:GetUnitName() == "npc_dota_hero_meepo" then
		for m = 1, #meepo_table do
			if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
				if ability:GetName() == "item_black_king_bar" then
					local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
				elseif ability:GetName() == "item_imba_white_queen_cape" then
					local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], ability, "modifier_black_king_bar_immune", {duration = duration})
				end
			elseif keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
				if ability:GetName() == "item_imba_black_queen_cape" then
					local duration = ability:GetLevelSpecialValueFor("bkb_duration", ability:GetLevel() -1)
					meepo_table[m]:AddNewModifier(meepo_table[m], nil, "modifier_imba_black_queen_cape_active_bkb", {duration = duration})
				end
			end
		end
	end

	return true
end

-- Damage filter function
function GameMode:DamageFilter( keys )
	if IsServer() then
		--damagetype_const
		--damage
		--entindex_attacker_const
		--entindex_victim_const
		local attacker
		local victim

		if keys.entindex_attacker_const and keys.entindex_victim_const then
			attacker = EntIndexToHScript(keys.entindex_attacker_const)
			victim = EntIndexToHScript(keys.entindex_victim_const)
		else
			return false
		end

		local damage_type = keys.damagetype_const

		-- Lack of entities handling
		if not attacker or not victim then
			return false
		end

		-- If the attacker is holding an Arcane/Archmage/Cursed Rapier and the distance is over the cap, remove the spellpower bonus from it
		if attacker:HasModifier("modifier_imba_arcane_rapier") or attacker:HasModifier("modifier_imba_arcane_rapier_2") or attacker:HasModifier("modifier_imba_rapier_cursed") then
			local distance = (attacker:GetAbsOrigin() - victim:GetAbsOrigin()):Length2D()

			if distance > IMBA_DAMAGE_EFFECTS_DISTANCE_CUTOFF then
				local rapier_spellpower = 0

				-- Get all modifiers, gather how much spellpower the target has from rapiers
				local modifiers = attacker:FindAllModifiers()

				for _,modifier in pairs(modifiers) do
					-- Increment Cursed Rapier's spellpower
					if modifier:GetName() == "modifier_imba_rapier_cursed" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")

						-- Increment Archmage Rapier spellpower
					elseif modifier:GetName() == "modifier_imba_arcane_rapier_2" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")

						-- Increment Arcane Rapier spellpower
					elseif modifier:GetName() == "modifier_imba_arcane_rapier" then
						rapier_spellpower = rapier_spellpower + modifier:GetAbility():GetSpecialValueFor("spell_power")
					end
				end

				-- If spellpower was accumulated, reduce the damage
				if rapier_spellpower > 0 then
					keys.damage = keys.damage / (1 + rapier_spellpower * 0.01)
				end
			end
		end

		-- Magic shield damage prevention
		if victim:HasModifier("modifier_item_imba_initiate_robe_stacks") and victim:GetTeam() ~= attacker:GetTeam() then

			-- Parameters
			local shield_stacks = victim:GetModifierStackCount("modifier_item_imba_initiate_robe_stacks", nil)

			-- Ignore part of incoming damage
			if keys.damage > shield_stacks then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, victim, shield_stacks, nil)
				victim:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
				keys.damage = keys.damage - shield_stacks
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, victim, keys.damage, nil)
				victim:SetModifierStackCount("modifier_item_imba_initiate_robe_stacks", victim, math.floor(shield_stacks - keys.damage))
				keys.damage = 0
			end
		end

		-- Magic barrier (pipe/hood) damage mitigation
		if victim:HasModifier("modifier_imba_hood_of_defiance_active_shield") and victim:GetTeam() ~= attacker:GetTeam() and damage_type == DAMAGE_TYPE_MAGICAL then
			local shield_modifier = victim:FindModifierByName("modifier_imba_hood_of_defiance_active_shield")

			if shield_modifier and shield_modifier.AbsorbDamage then
				keys.damage = shield_modifier:AbsorbDamage(keys.damage)
			end
		end

		-- Reaper's Scythe kill credit logic
		if victim:HasModifier("modifier_imba_reapers_scythe") then

			-- Check if this is the killing blow
			local victim_health = victim:GetHealth()
			if keys.damage >= victim_health then

				-- Prevent death and trigger Reaper's Scythe's on-kill effects
				local scythe_modifier = victim:FindModifierByName("modifier_imba_reapers_scythe")
				local scythe_caster = false
				if scythe_modifier then
					scythe_caster = scythe_modifier:GetCaster()
				end
				if scythe_caster then
					keys.damage = 0

					-- Find the Reaper's Scythe ability
					local ability = scythe_caster:FindAbilityByName("imba_necrolyte_reapers_scythe")
					if not ability then return nil end
					scythe_modifier:Destroy()
					victim:AddNewModifier(scythe_caster, ability, "modifier_imba_reapers_scythe_respawn", {})

					-- Attempt to kill the target, crediting it to the caster of Reaper's Scythe
					ApplyDamage({attacker = scythe_caster, victim = victim, ability = ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
				end
			end
		end

		-- Cheese auto-healing
		if victim:HasModifier("modifier_imba_cheese_death_prevention") then

			-- Only apply if it was a real hero
			if victim:IsRealHero() then

				-- Check if death is imminent
				local victim_health = victim:GetHealth()
				if keys.damage >= victim_health and not ( victim:HasModifier("modifier_imba_dazzle_shallow_grave") or victim:HasModifier("modifier_imba_dazzle_nothl_protection") ) then

					-- Find the cheese item handle
					local cheese_modifier = victim:FindModifierByName("modifier_imba_cheese_death_prevention")
					local item = cheese_modifier:GetAbility()

					-- Spend a charge of Cheese if the cooldown is ready
					if item:IsCooldownReady() then

						-- Reduce damage by your remaining amount of health
						keys.damage = keys.damage - victim_health

						-- Play sound
						victim:EmitSound("DOTA_Item.Cheese.Activate")

						-- Fully heal yourself
						victim:Heal(victim:GetMaxHealth(), victim)
						victim:GiveMana(victim:GetMaxMana())

						-- Spend a charge
						item:SetCurrentCharges( item:GetCurrentCharges() - 1 )

						-- Trigger cooldown
						item:StartCooldown( item:GetCooldown(1) * (1 - victim:GetCooldownReduction() * 0.01) )

						-- If this was the last charge, remove the item
						if item:GetCurrentCharges() == 0 then
							victim:RemoveItem(item)
						end
					end
				end
			end

		end

		-- Mirana's Sacred Arrow On The Prowl guaranteed critical
		if victim:HasModifier("modifier_imba_sacred_arrow_stun") then
			local modifier_stun_handler = victim:FindModifierByName("modifier_imba_sacred_arrow_stun")
			if modifier_stun_handler then

				-- Get the modifier's ability and caster
				local stun_ability = modifier_stun_handler:GetAbility()
				local caster = modifier_stun_handler:GetCaster()
				if stun_ability and caster then
					local should_crit = false

					-- If the table doesn't exist yet, initialize it
					if not modifier_stun_handler.enemy_attackers then
						modifier_stun_handler.enemy_attackers = {}
					end

					-- Check for the attacker in the attackers table
					local attacker_found = false

					if modifier_stun_handler.enemy_attackers[attacker:entindex()] then
						attacker_found = true
					end

					-- If this attacker haven't attacked the stunned target yet, guarantee a critical
					if not attacker_found then

						should_crit = true

						-- Add the attacker to the attackers table
						modifier_stun_handler.enemy_attackers[attacker:entindex()] = true
					end

					-- #2 Talent: Sacred Arrows allow allies to trigger On The Prowls' critical as long as there is at least enough seconds remaining to the stun
					if caster:HasTalent("special_bonus_imba_mirana_2") and not should_crit then

						-- Talent specials
						local allow_crit_time = caster:FindTalentValue("special_bonus_imba_mirana_2")

						-- Check if the remaining time is above the threshold
						local remaining_stun_time = modifier_stun_handler:GetRemainingTime()

						if remaining_stun_time >= allow_crit_time then
							should_crit = true
						end
					end

					if should_crit then
						-- Get the critical damage count
						local on_prow_crit_damage_pct = stun_ability:GetSpecialValueFor("on_prow_crit_damage_pct")

						-- Increase damage and show the critical attack event
						keys.damage = keys.damage * (1 + on_prow_crit_damage_pct * 0.01)

						-- Overhead critical event
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)
					end
				end
			end
		end

		-- Axe Battle Hunger kill credit
		if victim:GetTeam() == attacker:GetTeam() and keys.damage > 0 and attacker:HasModifier("modifier_imba_battle_hunger_debuff_dot") then
			-- Check if this is the killing blow
			local victim_health = victim:GetHealth()
			if keys.damage >= victim_health then
				-- Prevent death and trigger Reaper's Scythe's on-kill effects
				local battle_hunger_modifier = victim:FindModifierByName("modifier_imba_battle_hunger_debuff_dot")
				local battle_hunger_caster = false
				local battle_hunger_ability = false
				if battle_hunger_modifier then
					battle_hunger_caster = battle_hunger_modifier:GetCaster()
					battle_hunger_ability = battle_hunger_modifier:GetAbility()
				end
				if battle_hunger_caster then
					keys.damage = 0

					if not battle_hunger_ability then return nil end

					-- Attempt to kill the target, crediting it to Axe
					ApplyDamage({attacker = battle_hunger_caster, victim = victim, ability = battle_hunger_ability, damage = victim:GetHealth() + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
				end
			end
		end

		-- Kunkka Oceanids Blessing talent damage negation, applying true PURE damage towards the target
		if victim:HasModifier("modifier_imba_tidebringer_cleave_hit_target") then
			local tidebringer_ability = attacker:FindAbilityByName("imba_kunkka_tidebringer")
			local tidebringer_modifier = victim:FindModifierByName("modifier_imba_tidebringer_cleave_hit_target")
			if tidebringer_ability then
				keys.damage = 0

				local scythe_modifier = victim:FindModifierByName("modifier_imba_reapers_scythe")
				if scythe_modifier then return nil end
				victim:RemoveModifierByName("modifier_imba_tidebringer_cleave_hit_target")
			end
		end
	end
	return true
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]

function GameMode:OnAllPlayersLoaded()
	DebugPrint("[IMBA] All Players have loaded into the game")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Game filters setup
	-------------------------------------------------------------------------------------------------

	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap(GameMode, "GoldFilter"), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(GameMode, "ExperienceFilter"), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap(GameMode, "ModifierFilter"), self )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap(GameMode, "ItemAddedFilter"), self )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )

	-- CHAT
	chat = Chat(Players, Users, TEAM_COLORS)
	--	Chat:constructor(players, users, teamColors)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Fountain abilities setup
	-------------------------------------------------------------------------------------------------

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	-- Iterate through each one
	for _, building in pairs(buildings) do

		-- Parameters
		local building_name = building:GetName()

		-- Identify the fountains
		if string.find(building_name, "fountain") then

			-- Add fountain passive abilities
			building:AddAbility("imba_fountain_buffs")
			building:AddAbility("imba_fountain_grievous_wounds")
			building:AddAbility("imba_fountain_relief")

			local fountain_ability = building:FindAbilityByName("imba_fountain_buffs")
			local swipes_ability = building:FindAbilityByName("imba_fountain_grievous_wounds")
			local relief_aura_ability = building:FindAbilityByName("imba_fountain_relief")

			fountain_ability:SetLevel(1)
			swipes_ability:SetLevel(1)
			relief_aura_ability:SetLevel(1)
		elseif string.find(building_name, "tower") then
			building:SetDayTimeVisionRange(1900)
			building:SetNightTimeVisionRange(800)
		end
	end
end

function GameMode:OnHeroInGame(hero)
	local time_elapsed = 0

	Timers:CreateTimer(function()
		if not hero:IsNull() then
			if hero:GetUnitName() == "npc_dota_hero_meepo" then
				if not hero:IsClone() then
					TrackMeepos()
				end
			end
		end
		return 0.5
	end)

	if IMBA_PICK_MODE_ALL_RANDOM then
		Timers:CreateTimer(3.0, function()
			HeroSelection:RandomHero({PlayerID = hero:GetPlayerID()})
		end)
	elseif IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO then
		Timers:CreateTimer(3.0, function()
			if arsm == nil then
				arsm = true
				print("ARSM")
				HeroSelection:RandomSameHero()
			end
		end)
	end

	-- Disabling announcer for the player who picked a hero
	Timers:CreateTimer(0.1, function()
		if hero:GetUnitName() ~= "npc_dota_hero_wisp" or hero.is_real_wisp then
			hero.picked = true
		end
	end)

	Timers:CreateTimer(0.1, function()
		if hero.is_real_wisp or hero:GetUnitName() ~= "npc_dota_hero_wisp" and not hero:IsIllusion() then
			hero.picked = true
			return
		elseif not hero.is_real_wisp then
			if hero:GetUnitName() == "npc_dota_hero_wisp" and not hero:IsIllusion() then
				Timers:CreateTimer(function()
					RestrictAndHideHero(hero)
					if time_elapsed < 0.9 then
						time_elapsed = time_elapsed + 0.1
					else
						return nil
					end
					return 0.1
				end)
			end
			return
		end
	end)
end

--[[	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.									]]
function GameMode:OnGameInProgress()

	Timers:CreateTimer(0, function()
		SpawnImbaRunes()
		return RUNE_SPAWN_TIME
	end)

	-------------------------------------------------------------------------------------------------
	-- IMBA: Passive gold adjustment
	-------------------------------------------------------------------------------------------------
	GameRules:SetGoldTickTime( GOLD_TICK_TIME[GetMapName()] )

	if GetMapName() == "imba_overthrow" then return end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Structure stats setup
	-------------------------------------------------------------------------------------------------
	-- Roll the random ancient abilities for this game
	local ancient_ability_2 = "imba_ancient_stalwart_defense"
	local ancient_ability_3 = GetAncientAbility(1)
	local ancient_ability_4 = GetAncientAbility(2)
	local ancient_ability_5 = GetAncientAbility(3)

	-- Find all buildings on the map
	local buildings = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 20000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	-- Iterate through each one
	for _, building in pairs(buildings) do

		-- Fetch building name
		local building_name = building:GetName()

		-- Identify the building type
		if string.find(building_name, "tower") then

			building:AddAbility("imba_tower_buffs")
			local tower_ability = building:FindAbilityByName("imba_tower_buffs")
			tower_ability:SetLevel(1)

		elseif string.find(building_name, "fort") then

			-- Add passive buff
			building:AddAbility("imba_ancient_buffs")
			local ancient_ability = building:FindAbilityByName("imba_ancient_buffs")
			ancient_ability:SetLevel(1)

			if TOWER_ABILITY_MODE then

				-- Add Spawn Behemoth ability, if appropriate
				if SPAWN_ANCIENT_BEHEMOTHS then
					if string.find(building_name, "goodguys") then
						building:AddAbility("imba_ancient_radiant_spawn_behemoth")
						ancient_ability = building:FindAbilityByName("imba_ancient_radiant_spawn_behemoth")
					elseif string.find(building_name, "badguys") then
						building:AddAbility("imba_ancient_dire_spawn_behemoth")
						ancient_ability = building:FindAbilityByName("imba_ancient_dire_spawn_behemoth")
					end
					ancient_ability:SetLevel(1)
				end

				-- Add Stalwart Defense ability
				building:AddAbility(ancient_ability_2)
				ancient_ability = building:FindAbilityByName(ancient_ability_2)
				ancient_ability:SetLevel(1)

				-- Add tier 1 ability
				building:AddAbility(ancient_ability_3)
				ancient_ability = building:FindAbilityByName(ancient_ability_3)
				ancient_ability:SetLevel(1)

				-- Add tier 2 ability
				building:AddAbility(ancient_ability_4)
				ancient_ability = building:FindAbilityByName(ancient_ability_4)
				ancient_ability:SetLevel(1)

				-- Add tier 3 ability
				building:AddAbility(ancient_ability_5)
				ancient_ability = building:FindAbilityByName(ancient_ability_5)
				if ancient_ability:GetAbilityName() == "tidehunter_ravage" then
					ancient_ability:SetLevel(3)
				else
					ancient_ability:SetLevel(1)
				end

			end
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Tower abilities setup
	-------------------------------------------------------------------------------------------------

	if TOWER_ABILITY_MODE then
		local ability_table = IndexAllTowerAbilities()
		local protective_instict = "imba_tower_protective_instinct"

		-- Find all towers
		local towers = Entities:FindAllByClassname("npc_dota_tower")

		for _,radiant_tower in pairs(towers) do

			-- Check if it is indeed a radiant tower
			if radiant_tower:GetTeamNumber() == DOTA_TEAM_GOODGUYS then

				-- Find its dire equivalent
				local dire_tower_name = string.gsub(radiant_tower:GetUnitName(), "goodguys", "badguys")
				local dire_tower

				for _,tower in pairs(towers) do
					if tower:GetUnitName() == dire_tower_name and not tower.initially_upgraded then
						dire_tower = tower
						break
					end
				end

				-- Add protective instincts to both radiant and dire towers
				local ability = radiant_tower:AddAbility(protective_instict)
				ability:SetLevel(1)

				local ability = dire_tower:AddAbility(protective_instict)
				ability:SetLevel(1)

				if string.find(radiant_tower:GetUnitName(), "tower1") then
					-- Tier 1 tower found. Add tier 1 ability
					local ability_name = GetRandomTowerAbility(1, ability_table)
					local ability = radiant_tower:AddAbility(ability_name)
					ability:SetLevel(1)

					-- Add the same ability to the equivalent tower in dire
					local ability = dire_tower:AddAbility(ability_name)
					ability:SetLevel(1)

					-- After the ability has been set, remove it from the table.
					for j = 1, #ability_table[1] do
						if ability_table[1][j] == ability_name then
							table.remove(ability_table[1], j)
							break
						end
					end
				end

				if string.find(radiant_tower:GetUnitName(), "tower2") then
					-- Tier 2 tower found. Add tier 1 and 2 abilities
					for i = 1, 2 do
						local ability_name = GetRandomTowerAbility(i, ability_table)
						local ability = radiant_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- Add the same ability to the equivalent tower in dire
						local ability = dire_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- After the ability has been set, remove it from the table.
						for j = 1, #ability_table[i] do
							if ability_table[i][j] == ability_name then
								table.remove(ability_table[i], j)
								break
							end
						end
					end
				end

				if string.find(radiant_tower:GetUnitName(), "tower3") then
					-- Tier 3 tower found. Add tier 1, 2 and 3 abilities
					for i = 1, 3 do
						local ability_name = GetRandomTowerAbility(i, ability_table)
						local ability = radiant_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- Add the same ability to the equivalent tower in dire
						local ability = dire_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- After the ability has been set, remove it from the table.
						for j = 1, #ability_table[i] do
							if ability_table[i][j] == ability_name then
								table.remove(ability_table[i], j)
								break
							end
						end
					end
				end

				if string.find(radiant_tower:GetUnitName(), "tower4") then
					-- Tier 3 tower found. Add tier 1, 2 and 3 abilities
					for i = 2, 4 do
						local ability_name = GetRandomTowerAbility(i, ability_table)
						local ability = radiant_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- Add the same ability to the equivalent tower in dire
						local ability = dire_tower:AddAbility(ability_name)
						ability:SetLevel(1)

						-- After the ability has been set, remove it from the table.
						for j = 1, #ability_table[i] do
							if ability_table[i][j] == ability_name then
								table.remove(ability_table[i], j)
								break
							end
						end

						-- Mark tower as upgraded, so it could identify the other dire tower to upgrade.
						dire_tower.initially_upgraded = true
					end
				end
			end
		end
	end

	-- Find all towers
	local towers = Entities:FindAllByClassname("npc_dota_tower")

	for _,tower in pairs(towers) do
		if string.find(tower:GetUnitName(), "tower1") then
			tower:SetBaseDamageMin(180)
			tower:SetBaseDamageMax(200)
			print(tower:GetName())
		end
	end
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self
	local mode = GameRules:GetGameModeEntity()

	-- Call the internal function to set up the rules/behaviors specified in constants.lua
	-- This also sets up event hooks for all event handlers in events.lua
	-- Check out internals/gamemode to see/modify the exact code
	self:_InitGameMode()

	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- IMBA testbed command
	Convars:RegisterCommand("imba_test", Dynamic_Wrap(self, 'StartImbaTest'), "Spawns several units to help with testing", FCVAR_CHEAT)
	Convars:RegisterCommand("particle_table_print", PrintParticleTable, "Prints a huge table of all used particles", FCVAR_CHEAT)
	Convars:RegisterCommand("test_reconnect", ReconnectPlayer, "", FCVAR_CHEAT)

	CustomGameEventManager:RegisterListener("netgraph_max_gold", Dynamic_Wrap(self, "MaxGold"))
	CustomGameEventManager:RegisterListener("netgraph_max_level", Dynamic_Wrap(self, "MaxLevel"))
	CustomGameEventManager:RegisterListener("netgraph_remove_units", Dynamic_Wrap(self, "RemoveUnits"))
	CustomGameEventManager:RegisterListener("netgraph_give_item", Dynamic_Wrap(self, "NetgraphGiveItem"))
	CustomGameEventManager:RegisterListener("change_companion", Dynamic_Wrap(self, "DonatorCompanionJS"))

	--Derived Stats
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN_PERCENT, 0.002) -- 60-65% of vanilla
--	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN_PERCENT, 0.010)
--	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT, 0.075)

--	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT, 0)
--	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT, 0)
--	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT, 0)

	-- Panorama event stuff
	initScoreBoardEvents()
	--	InitPlayerHeroImbaTalents();

	if GetMapName() == "imba_overthrow" then
		mode:SetLoseGoldOnDeath( false )
		mode:SetFountainPercentageHealthRegen( 0 )
		mode:SetFountainPercentageManaRegen( 0 )
		mode:SetFountainConstantManaRegen( 0 )
		GameRules:SetHideKillMessageHeaders( true )
		mode:SetTopBarTeamValuesOverride( true )
		mode:SetTopBarTeamValuesVisible( false )

		self:SetUpFountains()
		self:GatherAndRegisterValidTeams()
	end
end

-- Starts the testbed if in tools mode
function GameMode:StartImbaTest()

	-- If not in tools mode, do nothing
	if not IsInToolsMode() then
		print("IMBA testbed is only available in tools mode.")
		return nil
	end

	-- If the testbed was already initialized, do nothing
	if IMBA_TESTBED_INITIALIZED then
		print("Testbed already initialized.")
		return nil
	end

	local testbed_center = Vector(1360, -4920, 1365)

	-- Move any existing heroes to the testbed area, and grant them useful testing items
	local player_heroes = HeroList:GetAllHeroes()
	for _, hero in pairs(player_heroes) do
		hero:SetAbsOrigin(testbed_center + Vector(-250, 0, 0))
		hero:AddItemByName("item_imba_manta")
		hero:AddItemByName("item_imba_blink")
		hero:AddItemByName("item_imba_silver_edge")
		hero:AddItemByName("item_black_king_bar")
		hero:AddItemByName("item_imba_heart")
		hero:AddItemByName("item_ultimate_scepter")
		hero:AddExperience(100000, DOTA_ModifyXP_Unspecified, false, true)
		PlayerResource:SetCameraTarget(0, hero)
	end
	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(0, nil)
	end)
	ResolveNPCPositions(testbed_center + Vector(-300, 0, 0), 128)

	-- Spawn some high health allies for benefic spell testing
	local dummy_hero
	local dummy_ability
	for i = 1, 3 do
		dummy_hero = CreateUnitByName("npc_dota_hero_axe", testbed_center + Vector(-500, (i-2) * 300, 0), true, player_heroes[1], player_heroes[1], DOTA_TEAM_GOODGUYS)
		dummy_hero:AddExperience(25000, DOTA_ModifyXP_Unspecified, false, true)
		dummy_hero:SetControllableByPlayer(0, true)
		dummy_hero:AddItemByName("item_imba_heart")
		dummy_hero:AddItemByName("item_imba_heart")

		-- Add specific items to each dummy hero
		if i == 1 then
			dummy_hero:AddItemByName("item_imba_manta")
			dummy_hero:AddItemByName("item_imba_diffusal_blade_3")
		elseif i == 2 then
			dummy_hero:AddItemByName("item_imba_silver_edge")
			dummy_hero:AddItemByName("item_imba_necronomicon_5")
		elseif i == 3 then
			dummy_hero:AddItemByName("item_sphere")
			dummy_hero:AddItemByName("item_black_king_bar")
		end
	end

	-- Spawn some high health enemies to attack/spam abilities on
	for i = 1, 3 do
		dummy_hero = CreateUnitByName("npc_dota_hero_axe", testbed_center + Vector(300, (i-2) * 300, 0), true, player_heroes[1], player_heroes[1], DOTA_TEAM_BADGUYS)
		dummy_hero:AddExperience(25000, DOTA_ModifyXP_Unspecified, false, true)
		dummy_hero:SetControllableByPlayer(0, true)
		dummy_hero:AddItemByName("item_imba_heart")
		dummy_hero:AddItemByName("item_imba_heart")

		-- Add specific items to each dummy hero
		if i == 1 then
			dummy_hero:AddItemByName("item_imba_manta")
			dummy_hero:AddItemByName("item_imba_diffusal_blade_3")
		elseif i == 2 then
			dummy_hero:AddItemByName("item_imba_silver_edge")
			dummy_hero:AddItemByName("item_imba_necronomicon_5")
		elseif i == 3 then
			dummy_hero:AddItemByName("item_sphere")
			dummy_hero:AddItemByName("item_black_king_bar")
		end
	end

	-- Spawn a rubick with spell steal leveled up
	dummy_hero = CreateUnitByName("npc_dota_hero_rubick", testbed_center + Vector(600, 200, 0), true, player_heroes[1], player_heroes[1], DOTA_TEAM_BADGUYS)
	dummy_hero:AddExperience(25000, DOTA_ModifyXP_Unspecified, false, true)
	dummy_hero:SetControllableByPlayer(0, true)
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_ability = dummy_hero:FindAbilityByName("rubick_spell_steal")
	if dummy_ability then
		dummy_ability:SetLevel(6)
	end

	-- Spawn a pugna with nether ward leveled up and some CDR
	dummy_hero = CreateUnitByName("npc_dota_hero_pugna", testbed_center + Vector(600, 0, 0), true, player_heroes[1], player_heroes[1], DOTA_TEAM_BADGUYS)
	dummy_hero:AddExperience(25000, DOTA_ModifyXP_Unspecified, false, true)
	dummy_hero:SetControllableByPlayer(0, true)
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_hero:AddItemByName("item_imba_triumvirate")
	dummy_hero:AddItemByName("item_imba_octarine_core")
	dummy_ability = dummy_hero:FindAbilityByName("imba_pugna_nether_ward")
	if dummy_ability then
		dummy_ability:SetLevel(7)
	end

	-- Spawn an antimage with a scepter and leveled up spell shield
	dummy_hero = CreateUnitByName("npc_dota_hero_antimage", testbed_center + Vector(600, -200, 0), true, player_heroes[1], player_heroes[1], DOTA_TEAM_BADGUYS)
	dummy_hero:AddExperience(25000, DOTA_ModifyXP_Unspecified, false, true)
	dummy_hero:SetControllableByPlayer(0, true)
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_hero:AddItemByName("item_imba_heart")
	dummy_hero:AddItemByName("item_ultimate_scepter")
	dummy_ability = dummy_hero:FindAbilityByName("imba_antimage_spell_shield")
	if dummy_ability then
		dummy_ability:SetLevel(7)
	end

	-- Spawn some assorted neutrals for reasons
	neutrals_table = {}
	neutrals_table[1] = {}
	neutrals_table[2] = {}
	neutrals_table[3] = {}
	neutrals_table[4] = {}
	neutrals_table[5] = {}
	neutrals_table[6] = {}
	neutrals_table[7] = {}
	neutrals_table[8] = {}
	neutrals_table[1].name = "npc_dota_neutral_big_thunder_lizard"
	neutrals_table[1].position = Vector(-450, 800, 0)
	neutrals_table[2].name = "npc_dota_neutral_granite_golem"
	neutrals_table[2].position = Vector(-150, 800, 0)
	neutrals_table[3].name = "npc_dota_neutral_black_dragon"
	neutrals_table[3].position = Vector(150, 800, 0)
	neutrals_table[4].name = "npc_dota_neutral_prowler_shaman"
	neutrals_table[4].position = Vector(450, 800, 0)
	neutrals_table[5].name = "npc_dota_neutral_satyr_hellcaller"
	neutrals_table[5].position = Vector(-450, 600, 0)
	neutrals_table[6].name = "npc_dota_neutral_mud_golem"
	neutrals_table[6].position = Vector(-150, 600, 0)
	neutrals_table[7].name = "npc_dota_neutral_enraged_wildkin"
	neutrals_table[7].position = Vector(150, 600, 0)
	neutrals_table[8].name = "npc_dota_neutral_centaur_khan"
	neutrals_table[8].position = Vector(450, 600, 0)

	for _, neutral in pairs(neutrals_table) do
		dummy_hero = CreateUnitByName(neutral.name, testbed_center + neutral.position, true, player_heroes[1], player_heroes[1], DOTA_TEAM_NEUTRALS)
		dummy_hero:SetControllableByPlayer(0, true)
		dummy_hero:Hold()
	end

	-- Flag testbed as having been initialized
	IMBA_TESTBED_INITIALIZED = true
end

--	function GameMode:RemoveUnits(good, bad, neutral)
function GameMode:RemoveUnits()
	-- local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_ANY_ORDER, false )
	-- local units2 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_INVULNERABLE , FIND_ANY_ORDER, false )
	local units3 = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE , FIND_ANY_ORDER, false )
	local count = 0

	--	if good == true then
	--		for _,v in pairs(units) do
	--			if v:HasMovementCapability() and not v:GetUnitName() == "npc_dota_creep_goodguys_melee" then
	--				count = count +1
	--				v:RemoveSelf()
	--			end
	--		end
	--	end

	--	if bad == true then
	--		for _,v in pairs(units2) do
	--			if v:HasMovementCapability() and not v:GetUnitName() == "npc_dota_creep_badguys_melee" then
	--				count = count +1
	--				v:RemoveSelf()
	--			end
	--		end
	--	end

	--	if neutral == true then
	for _,v in pairs(units3) do
		if v:GetUnitName() == "npc_imba_roshan" then
		else
			count = count +1
			v:RemoveSelf()
		end
	end
	--	end

	if count > 0 then
		Notifications:TopToAll({text="Critical lags! Developer removed Jungle creeps: "..count, duration=10.0})
	end
end
--[[
function GameMode:ProcessItemForLootExpire( item, flCutoffTime )
	if item:IsNull() then
		return false
	end
	if item:GetCreationTime() >= flCutoffTime then
		return true
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, item )
	ParticleManager:SetParticleControl( nFXIndex, 0, item:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	local inventoryItem = item:GetContainedItem()
	if inventoryItem then
		UTIL_RemoveImmediate( inventoryItem )
	end
	UTIL_RemoveImmediate( item )
	return false
end
--]]

-- Overthrow
---------------------------------------------------------------------------
-- Set up fountain regen
---------------------------------------------------------------------------
function GameMode:SetUpFountains()

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
	end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function GameMode:ColorForTeam( teamID )
	local color = TEAM_COLORS[ teamID ]
	if color == nil then
		color = { 255, 255, 255 } -- default to white
	end
	return color
end

---------------------------------------------------------------------------
function GameMode:EndGame( victoryTeam )
	local overBoss = Entities:FindByName( nil, "@overboss" )
	if overBoss then
		local celebrate = overBoss:FindAbilityByName( 'dota_ability_celebrate' )
		if celebrate then
			overBoss:CastAbilityNoTarget( celebrate, -1 )
		end
	end

	GameRules:SetGameWinner( victoryTeam )
end

---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function GameMode:UpdatePlayerColor( nPlayerID )
	if not PlayerResource:HasSelectedHero( nPlayerID ) then
		return
	end

	local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
	if hero == nil then
		return
	end

	local teamID = PlayerResource:GetTeam( nPlayerID )
	local color = self:ColorForTeam( teamID )
	PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
	local sortedTeams = {}
	for _, team in pairs( m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

	for _, t in pairs( sortedTeams ) do
		local clr = self:ColorForTeam( t.teamID )

		-- Scaleform UI Scoreboard
		local score =
			{
				team_id = t.teamID,
				team_score = t.teamScore
			}
		FireGameEvent( "score_board", score )
	end
	-- Leader effects (moved from OnTeamKillCredit)
	local leader = sortedTeams[1].teamID
	--print("Leader = " .. leader)
	leadingTeam = leader
	GAME_WINNER_TEAM = leadingTeam
	runnerupTeam = sortedTeams[2].teamID
	leadingTeamScore = sortedTeams[1].teamScore
	runnerupTeamScore = sortedTeams[2].teamScore
	if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
		isGameTied = true
	else
		isGameTied = false
	end
	local allHeroes = HeroList:GetAllHeroes()
	for _,entity in pairs( allHeroes) do
		if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
			if entity:IsAlive() == true then
				-- Attaching a particle to the leading team heroes
				local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
				if existingParticle == -1 then
					local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
					ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
					entity:Attribute_SetIntValue( "particleID", particleLeader )
				end
			else
				local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
				if particleLeader ~= -1 then
					ParticleManager:DestroyParticle( particleLeader, true )
					entity:DeleteAttribute( "particleID" )
				end
			end
		else
			local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
			if particleLeader ~= -1 then
				ParticleManager:DestroyParticle( particleLeader, true )
				entity:DeleteAttribute( "particleID" )
			end
		end
	end
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function GameMode:GatherAndRegisterValidTeams()
	--	print( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	--	print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )

	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
		--		print("Team:", t)
		--		AddFOWViewer(t, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), 900, 99999, false)
	end

	if numTeams == 0 then
		print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( IMBA_PLAYERS_ON_GAME / numTeams )

	m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	--	print( "Final shuffled team list:" )
	--	for _, team in pairs( m_GatheredShuffledTeams ) do
	--		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	--	end

	--	print( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0

		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		--		print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
		GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
	end
end

-- Spawning individual camps
function GameMode:spawncamp(campname)
	spawnunits(campname)
end

-- Simple Custom Spawn
function spawnunits(campname)
	local spawndata = spawncamps[campname]
	local NumberToSpawn = spawndata.NumberToSpawn --How many to spawn
	local SpawnLocation = Entities:FindByName( nil, campname )
	local waypointlocation = Entities:FindByName ( nil, spawndata.WaypointName )

	if SpawnLocation == nil then
		return
	end

	local randomCreature =
		{
			"basic_zombie",
			"berserk_zombie"
		}
	local r = randomCreature[RandomInt(1,#randomCreature)]

	--print(r)
	for i = 1, NumberToSpawn do
		local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
		--print ("Spawning Camps")
		creature:SetInitialGoalEntity( waypointlocation )
	end
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function GameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		print("EO: " .. k .. " " .. tostring(v) )
	end
	]]

	local orderType = filterTable["order_type"]

	if ( orderType ~= DOTA_UNIT_ORDER_PICKUP_ITEM or filterTable["issuer_player_id_const"] == -1 ) then
		return true
	else
		local item = EntIndexToHScript( filterTable["entindex_target"] )

		if item == nil then
			return true
		end

		local pickedItem = item:GetContainedItem()

		--print(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end

		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 6 then
				--print("inventory has space")
				return true
			else
				--print("Moving to target instead")
				local position = item:GetAbsOrigin()
				filterTable["position_x"] = position.x
				filterTable["position_y"] = position.y
				filterTable["position_z"] = position.z
				filterTable["order_type"] = DOTA_UNIT_ORDER_MOVE_TO_POSITION
				return true
			end
		end
	end

	return true
end

function GameMode:CustomSpawnCamps()
	for name,_ in pairs(spawncamps) do
		spawnunits(name)
	end
end

function GameMode:OnItemPickUp( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )

	r = RandomInt(300, 450)

	if event.itemname == "item_bag_of_gold" then
		--print("Bag of gold picked up")
		PlayerResource:ModifyGold( owner:GetPlayerID(), r, true, 0 )
		SendOverheadEventMessage( owner, OVERHEAD_ALERT_GOLD, owner, r, nil )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	elseif event.itemname == "item_treasure_chest" then
		--print("Special Item Picked Up")
		DoEntFire( "item_spawn_particle_" .. itemSpawnIndex, "Stop", "0", 0, self, self )
		GameMode:SpecialItemAdd( event )
		UTIL_Remove( item ) -- otherwise it pollutes the player inventory
	end
end

function GameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )

	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		GameMode:TreasureDrop( npc )
	end
end

function GameMode:OnThink()
	local newState = GameRules:State_Get()

	if newState == DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then 
		if Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
			if not IsInToolsMode() then
				print("Cheats have been enabled, game don't count.")
				CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
				CustomGameEventManager:Send_ServerToAllClients("safe_to_leave", {})
			end
		end
	end

	-- Undying talent fix
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero.undying_respawn_timer then
			if hero.undying_respawn_timer > 0 then
				hero.undying_respawn_timer = hero.undying_respawn_timer -1
			end
		end
	end

	if GetMapName() == "imba_overthrow" then
		self:UpdateScoreboard()
	else
		-- fix for super high respawn time
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if not hero:IsAlive() then
				local respawn_time = hero:GetTimeUntilRespawn()
				local reaper_scythe = 36 -- max necro timer addition

				if hero:HasModifier("modifier_imba_reapers_scythe_respawn") then
					if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), 25)] + reaper_scythe then
						print("NECROPHOS BUG:", hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[25])
						respawn_time = respawn_time + reaper_scythe
					end
				else
					if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), 25)] then
						print(hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[25])
						respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), 25)]
					end
				end
				hero:SetTimeUntilRespawn(respawn_time)
			end
		end

		if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			-- End the game if one team completely abandoned
			if IsInToolsMode() then
				if not TEAM_ABANDON then
					TEAM_ABANDON = {} -- 15 second to abandon, is_abandoning?, player_count.
					TEAM_ABANDON[2] = {FULL_ABANDON_TIME, false, 0}
					TEAM_ABANDON[3] = {FULL_ABANDON_TIME, false, 0}
				end

				TEAM_ABANDON[2][3] = PlayerResource:GetPlayerCountForTeam(2)
				TEAM_ABANDON[3][3] = PlayerResource:GetPlayerCountForTeam(3)

				for ID = 0, PlayerResource:GetPlayerCount() -1 do
					local team = PlayerResource:GetTeam(ID)

					if PlayerResource:GetConnectionState(ID) == 3 then -- if disconnected then
						TEAM_ABANDON[team][3] = TEAM_ABANDON[team][3] -1
					end

					if TEAM_ABANDON[team][3] > 0 then
						TEAM_ABANDON[team][2] = false
					else
						if TEAM_ABANDON[team][2] == false then
							local abandon_text = "#imba_team_good_abandon_message"
							if team == 3 then
								abandon_text = "#imba_team_bad_abandon_message"
							end
							Notifications:BottomToAll({text = abandon_text, duration = 15.0, style = {color = "DodgerBlue"} })
						end

						TEAM_ABANDON[team][2] = true
						TEAM_ABANDON[team][1] = TEAM_ABANDON[team][1] -1

						if TEAM_ABANDON[2][1] <= 0 then
							GameRules:SetGameWinner(3)
							GAME_WINNER_TEAM = 3
						elseif TEAM_ABANDON[3][1] <= 0 then
							GameRules:SetGameWinner(2)
							GAME_WINNER_TEAM = 2
						end
					end
				end
			end
		end
	end

	-- Picking Screen voice alert
	if i == nil then i = HERO_SELECTION_TIME -1
	elseif i == false then
	else
		i = i -1
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if not hero.picked and not i == false then -- have to double check false for reasons
				if i == 30 then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_"..i, hero:GetPlayerID())
				elseif i == 10 then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_"..i, hero:GetPlayerID())
				elseif i <= 10 and i > 0 then
					EmitAnnouncerSoundForPlayer("announcer_ann_custom_countdown_0"..i, hero:GetPlayerID())
				elseif i <= 0 then
					i = false
				end
			end
		end
	end

	return 1
end

function GameMode:DonatorCompanionJS(event)
	DonatorCompanion(event.ID, event.unit)
end

function GameMode:MaxGold(event)
	local hero = PlayerResource:GetPlayer(event.ID):GetAssignedHero()

	if IsInToolsMode() then
		hero:ModifyGold(99999, true, DOTA_ModifyGold_CheatCommand)
	else
		AntiDevCheat()
	end
end

function GameMode:MaxLevel(event)
	local hero = PlayerResource:GetPlayer(event.ID):GetAssignedHero()

	if IsInToolsMode() then
		hero:AddExperience(500000, DOTA_ModifyXP_Unspecified, false, true)
		for i = 0, 23 do
			local ability = hero:GetAbilityByIndex(i)
			if IsValidEntity(ability) then
				if ability:GetLevel() < ability:GetMaxLevel() then
					for j = 1, ability:GetMaxLevel() - ability:GetLevel() do
						hero:UpgradeAbility(ability)
					end
				end
			end
		end
	else
		AntiDevCheat()
	end
end

function GameMode:NetgraphGiveItem(event)
	local hero = PlayerResource:GetPlayer(event.ID):GetAssignedHero()

	if IsInToolsMode() then
		hero:AddItemByName("item_"..event.item)
		hero:AddItemByName("item_imba_"..event.item)
	else
		AntiDevCheat()
	end
end

function AntiDevCheat()
	Notifications:BottomToAll({hero = hero:GetName(), duration = 10.0})
	Notifications:BottomToAll({text = PlayerResource:GetPlayerName(event.ID).." ", duration = 5.0, continue = true})
	Notifications:BottomToAll({text = "is trying to cheat using dev tool! GET HIM!", duration = 5.0, style = {color = "Red"}, continue = true})
end
