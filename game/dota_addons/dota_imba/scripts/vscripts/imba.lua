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

if GameMode == nil then
	_G.GameMode = class({})
end

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')

-- load api before internal/events
require('api/imba')

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
require('libraries/rgb_to_hex')

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

-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events/events')
require('events/npc_spawned/on_hero_spawned')
require('events/npc_spawned/on_unit_spawned')
require('events/on_entity_killed/on_hero_killed')
require('events/player_disconnect/on_disconnect')

require('components/team_selection')
require('components/battlepass/donator')
require('components/battlepass/experience')
require('components/battlepass/imbattlepass')

-- clientside KV loading
require('addon_init')

if IsMutationMap() then
	require('components/mutation/mutation_list')
	require('components/mutation/mutation')
elseif GetMapName() == "imba_overthrow" then
	require('overthrow/events.lua')
end

ApplyAllTalentModifiers()
StoreCurrentDayCycle()

--	if IsInToolsMode() then
--		OverrideCreateParticle()
--		OverrideReleaseIndex()
--	end

function GameMode:PostLoadPrecache()
	-- precache companions
	if api.imba.get_companions() ~= nil then
		for k, v in pairs(api.imba.get_companions()) do
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
	api.imba.register(function ()
			-- configure log from api
			Log:ConfigureFromApi()
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
	elseif GetMapName() == "cavern" then
	else
--		GoodCamera = Entities:FindByName(nil, "dota_goodguys_fort")
--		BadCamera = Entities:FindByName(nil, "dota_badguys_fort")
		GoodCamera = Entities:FindByName(nil, "good_healer_6")
		BadCamera = Entities:FindByName(nil, "bad_healer_6")

		ROSHAN_SPAWN_LOC = Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):GetAbsOrigin()
		Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):RemoveSelf()
		if GetMapName() ~= "imba_1v1" then
			local roshan = CreateUnitByName("npc_imba_roshan", ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Pre-pick forced hero selection
	-------------------------------------------------------------------------------------------------
	if GetMapName() == "cavern" then
		CCavern:SetupCavernRules()
	else
		flItemExpireTime = 60.0
		GameRules:SetSameHeroSelectionEnabled(true)
		GameRules:GetGameModeEntity():SetCameraDistanceOverride(500) -- default: 1134
	end

	if not IsInToolsMode() then
		GameRules:GetGameModeEntity():SetPauseEnabled( false )
	end

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
		"npc_imba_contributor_wally_chan",
	}

	-- Add 6 random contributor statues
	local current_location = {}
	current_location[1] = Vector(-6900, -5400, 384)
	current_location[2] = Vector(-6900, -5100, 384)
	current_location[3] = Vector(-6900, -4800, 384)
	current_location[4] = Vector(6900, 5000, 384)
	current_location[5] = Vector(6900, 4700, 384)
	current_location[6] = Vector(6900, 4400, 384)
	current_location[7] = Vector(-5800, -6300, 384)
	current_location[8] = Vector(-5500, -6300, 384)
	current_location[9] = Vector(-5200, -6300, 384)
	current_location[10] = Vector(5800, 6300, 384)
	current_location[11] = Vector(5500, 6300, 384)
	current_location[12] = Vector(5200, 6300, 384)

	local current_statue
	local statue_entity
	for i = 1, 12 do
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

	CheatDetector()
end

-- Gold gain filter function
function GameMode:GoldFilter(keys)
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	if GetMapName() == "cavern" then return true end

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute or keys.reason_const == DOTA_ModifyGold_GameTick then
		return true
	end


	-- Ignore negative experience values
	if keys.gold < 0 then
		return false
	end

	local player = PlayerResource:GetPlayer(keys.player_id_const)

	-- player can be nil for some reason
	if player then
		local hero = player:GetAssignedHero()

		-- Hand of Midas gold bonus
		if hero:HasModifier("modifier_item_imba_hand_of_midas") and keys.gold > 0 then
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
			keys.gold = (custom_gold_bonus / 100) + (1 + game_time / 25) * keys.gold
		end

		local reliable = false
		if keys.reason_const == DOTA_ModifyGold_HeroKill or keys.reason_const == DOTA_ModifyGold_RoshanKill or keys.reason_const == DOTA_ModifyGold_CourierKill or keys.reason_const == DOTA_ModifyGold_Building then
			reliable = true
		end

		-- Show gold earned message??
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

	if GetMapName() == "cavern" then return true end

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
	local custom_xp_bonus = tonumber(CustomNetTables:GetTableValue("game_options", "exp_multiplier")["1"])

	if keys.reason_const == DOTA_ModifyXP_HeroKill then
		keys.experience = keys.experience * (custom_xp_bonus / 100)
	else
		if GetMapName() ~= "imba_1v1" then
			keys.experience = keys.experience * (custom_xp_bonus / 100) * (1 + game_time / 200)
		end
	end

	-- Losing team gets huge EXP bonus.
	--	if hero and CustomNetTables:GetTableValue("game_options", "losing_team") then
	--		if CustomNetTables:GetTableValue("game_options", "losing_team").losing_team then
	--			local losing_team = CustomNetTables:GetTableValue("game_options", "losing_team").losing_team

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

			if IsMutationMap() then
				Mutation:ModifierFilter(keys)
			end
		else
			return true
		end

		-- volvo bugfix
		if modifier_name == "modifier_datadriven" then
			return false
		end

		-- don't add buyback penalty
		if modifier_name == "modifier_buyback_gold_penalty" then
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
				keys.duration = keys.duration / (100/50)
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
					actually_duration = actually_duration / (100/IMBA_FRANTIC_VALUE)
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

--		if modifier_name == "modifier_courier_shield" then
--			modifier_caster:RemoveModifierByName(modifier_name)
--			modifier_caster:FindAbilityByName("courier_burst"):CastAbility()
--		end

		-- disarm immune
		local jarnbjorn_immunity = {
			"modifier_disarmed",
			"modifier_item_imba_triumvirate_proc_debuff",
			"modifier_item_imba_sange_kaya_proc",
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

		if modifier_name == "modifier_tusk_snowball_movement" then
			if modifier_owner:FindAbilityByName("tusk_snowball") then
				modifier_owner:FindAbilityByName("tusk_snowball"):SetActivated(false)
				Timers:CreateTimer(15.0, function()
						if not modifier_owner:FindModifierByName("modifier_tusk_snowball_movement") then
							modifier_owner:FindAbilityByName("tusk_snowball"):SetActivated(true)
						end
					end)
			end
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

	if string.find(item_name, "item_imba_rune_") and unit:IsRealHero() then
		PickupRune(item_name, unit)
		return false
	end

	if item.airdrop then
		local overthrow_item_drop =
		{
			hero_id = unit:GetClassname(),
			dropped_item = item:GetName()
		}
		CustomGameEventManager:Send_ServerToAllClients("overthrow_item_drop", overthrow_item_drop)
		EmitGlobalSound("powerup_04")
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
		if unit:IsImbaReincarnating() then
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
		if ability ~= nil and ability:GetAbilityName() == "imba_kunkka_torrent" then
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
		if ability ~= nil and ability:GetAbilityName() == "imba_kunkka_tidebringer" then
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
		if ability ~= nil and ability:GetAbilityName() == "imba_techies_focused_detonate" then
			unit:AddNewModifier(unit, ability, "modifier_imba_focused_detonate", {duration = 0.2})
		end

		-- Mirana's Leap talent cast-handling
		if ability ~= nil and ability:GetAbilityName() == "imba_mirana_leap" and unit:HasTalent("special_bonus_imba_mirana_7") then
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

	if keys.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		local purchaser = EntIndexToHScript(units["0"])
		local item = keys.entindex_ability
		if item == nil then return true end

		for _, banned_item in pairs(BANNED_ITEMS[GetMapName()]) do
			if self.itemIDs[item] == banned_item then
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_purchase_1v1")
				return false
			end
		end
	end

	if GetMapName() == "imba_1v1" then
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET then
			local target = EntIndexToHScript(keys["entindex_target"])
			if target:GetUnitName() == "npc_dota_goodguys_healers" or target:GetUnitName() == "npc_dota_badguys_healers" then
				DisplayError(unit:GetPlayerID(),"#dota_hud_error_cant_shrine_1v1")
				return false
			end
		end
	end

	if keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		local unit = EntIndexToHScript(keys.units["0"])
		if unit ~= nil and unit:GetUnitName() == "npc_dota_courier" then
			local drop = EntIndexToHScript(keys["entindex_target"])
			local item = drop:GetContainedItem()			
			if string.find(item:GetAbilityName(), "imba_rune") ~= nil then
				return false
			end

			return true
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
					victim:RemoveModifierByName("modifier_imba_reapers_scythe")
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
	log.info("All Players have loaded into the game")

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
			building:AddAbility("imba_fountain_danger_zone"):SetLevel(1)
--			building:AddAbility("imba_fountain_relief"):SetLevel(1)

			-- remove vanilla fountain healing
			if building:HasModifier("modifier_fountain_aura") then
				building:RemoveModifierByName("modifier_fountain_aura")
				building:AddNewModifier(building, nil, "modifier_fountain_aura_lua", {})
			end
		end
	end
end

function GameMode:OnHeroInGame(hero)
	PlayerResource:SetCameraTarget(hero:GetPlayerID(), nil)

	if IMBA_PICK_MODE_ALL_RANDOM then
		Timers:CreateTimer(3.0, function()
				HeroSelection:RandomHero({PlayerID = hero:GetPlayerID()})
			end)
	elseif IMBA_PICK_MODE_ALL_RANDOM_SAME_HERO then
		Timers:CreateTimer(3.0, function()
				if arsm == nil then
					arsm = true
					log.info("ARSM")
					HeroSelection:RandomSameHero()
				end
			end)
	end
end

--[[	This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.									]]
function GameMode:OnGameInProgress()
	if GetMapName() ~= "imba_1v1" then
		SpawnImbaRunes(RUNE_SPAWN_TIME, BOUNTY_RUNE_SPAWN_TIME)
	end

	-- IMBA: Passive gold adjustment
	GameRules:SetGoldTickTime(GOLD_TICK_TIME[GetMapName()])

	if GetMapName() == "imba_overthrow" or GetMapName() == "imba_1v1" then return end

	-- Find all towers
	local towers = Entities:FindAllByClassname("npc_dota_tower")

	for _, tower in pairs(towers) do
		for i = 1, 4 do
			for _, ability in pairs(TOWER_ABILITIES["tower"..i]) do
				if string.find(tower:GetUnitName(), "tower"..i) then
					tower:AddAbility(ability):SetLevel(1)
				end
			end
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
--	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- IMBA testbed command
	Convars:RegisterCommand("imba_test", Dynamic_Wrap(self, 'StartImbaTest'), "Spawns several units to help with testing", FCVAR_CHEAT)
	Convars:RegisterCommand("particle_table_print", PrintParticleTable, "Prints a huge table of all used particles", FCVAR_CHEAT)
	Convars:RegisterCommand("test_reconnect", ReconnectPlayer, "", FCVAR_CHEAT)

	CustomGameEventManager:RegisterListener("netgraph_max_gold", Dynamic_Wrap(self, "MaxGold"))
	CustomGameEventManager:RegisterListener("netgraph_max_level", Dynamic_Wrap(self, "MaxLevel"))
	CustomGameEventManager:RegisterListener("netgraph_remove_units", Dynamic_Wrap(self, "RemoveUnits"))
	CustomGameEventManager:RegisterListener("netgraph_give_item", Dynamic_Wrap(self, "NetgraphGiveItem"))
	CustomGameEventManager:RegisterListener("change_companion", Dynamic_Wrap(self, "DonatorCompanionJS"))
	CustomGameEventManager:RegisterListener("change_statue", Dynamic_Wrap(self, "DonatorStatueJS"))
	CustomGameEventManager:RegisterListener("send_gg_vote", Dynamic_Wrap(self, 'GG'))

	self.itemKV = LoadKeyValues("scripts/npc/items.txt")
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_items_custom.txt")) do
		if not self.itemKV[k] then
			self.itemKV[k] = v
		end
	end

	self.itemIDs = {}
	for k,v in pairs(self.itemKV) do
		if type(v) == "table" and v.ID then
			self.itemIDs[v.ID] = k
		end
	end

	--Derived Stats
	mode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN_PERCENT, 0.0015) -- 40-45% of vanilla
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
		log.info("IMBA testbed is only available in tools mode.")
		return nil
	end

	-- If the testbed was already initialized, do nothing
	if IMBA_TESTBED_INITIALIZED then
		log.info("Testbed already initialized.")
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
			dummy_hero:AddItemByName("item_imba_diffusal_blade_2")
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
			dummy_hero:AddItemByName("item_imba_diffusal_blade_2")
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
	log.debug("Leader = " .. leader)
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
	log.debug( "GatherValidTeams:" )

	local foundTeams = {}
	for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
		foundTeams[  playerStart:GetTeam() ] = true
	end

	local numTeams = TableCount(foundTeams)
	log.debug( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )

	local foundTeamsList = {}
	for t, _ in pairs( foundTeams ) do
		table.insert( foundTeamsList, t )
		--		log.debug("Team:", t)
		--		AddFOWViewer(t, Entities:FindByName(nil, "@overboss"):GetAbsOrigin(), 900, 99999, false)
	end

	if numTeams == 0 then
		log.info( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
		table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
		table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
		numTeams = 2
	end

	local maxPlayersPerValidTeam = math.floor( PlayerResource:GetPlayerCount() / numTeams )

	m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

	--	log.debug( "Final shuffled team list:" )
	--	for _, team in pairs( m_GatheredShuffledTeams ) do
	--		log.debug( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
	--	end

	--	log.debug( "Setting up teams:" )
	for team = 0, (DOTA_TEAM_COUNT-1) do
		local maxPlayers = 0

		if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
			maxPlayers = maxPlayersPerValidTeam
		end
		--		log.debug( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
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

	--log.debug(r)
	for i = 1, NumberToSpawn do
		local creature = CreateUnitByName( "npc_dota_creature_" ..r , SpawnLocation:GetAbsOrigin() + RandomVector( RandomFloat( 0, 200 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
		log.debug("Spawning Camps")
		creature:SetInitialGoalEntity( waypointlocation )
	end
end

--------------------------------------------------------------------------------
-- Event: Filter for inventory full
--------------------------------------------------------------------------------
function GameMode:ExecuteOrderFilter( filterTable )
	--[[
	for k, v in pairs( filterTable ) do
		log.debug("EO: " .. k .. " " .. tostring(v) )
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

		--log.debug(pickedItem:GetAbilityName())
		if pickedItem == nil then
			return true
		end

		if pickedItem:GetAbilityName() == "item_treasure_chest" then
			local player = PlayerResource:GetPlayer(filterTable["issuer_player_id_const"])
			local hero = player:GetAssignedHero()
			if hero:GetNumItemsInInventory() < 6 then
				--log.debug("inventory has space")
				return true
			else
				--log.debug("Moving to target instead")
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

function GameMode:OnNpcGoalReached( event )
	local npc = EntIndexToHScript( event.npc_entindex )

	if npc:GetUnitName() == "npc_dota_treasure_courier" then
		GameMode:TreasureDrop( npc )
	end
end

function GameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return nil end
	if GameRules:IsGamePaused() then return 1 end

	CheatDetector()

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IsMutationMap() then
			Mutation:OnThink()
		elseif GetMapName() == "cavern" then
			CCavern:OnThink()
		end
	end

	for _, hero in pairs(HeroList:GetAllHeroes()) do
		-- Make courier controllable, repeat every second to avoid uncontrollable issues
		if COURIER_TEAM then
			if COURIER_TEAM[hero:GetTeamNumber()] and not COURIER_TEAM[hero:GetTeamNumber()]:IsControllableByAnyPlayer() then
				COURIER_TEAM[hero:GetTeamNumber()]:SetControllableByPlayer(hero:GetPlayerID(), true)
			end
		end

		if COURIER_PLAYER then
			if COURIER_PLAYER[hero:GetPlayerID()] and not COURIER_PLAYER[hero:GetPlayerID()]:IsControllableByAnyPlayer() then
				COURIER_PLAYER[hero:GetPlayerID()]:SetControllableByPlayer(hero:GetPlayerID(), true)
				COURIER_PLAYER[hero:GetPlayerID()].owner_id = hero:GetPlayerID()
			end
		end

		-- Undying talent fix
		if hero.undying_respawn_timer then
			if hero.undying_respawn_timer > 0 then
				hero.undying_respawn_timer = hero.undying_respawn_timer -1
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
		if hero:FindModifierByName("modifier_tusk_snowball_movement") then
			if hero:FindAbilityByName("tusk_snowball") then
				hero:FindAbilityByName("tusk_snowball"):SetActivated(false)
			end
		else
			if hero:FindAbilityByName("tusk_snowball") then
				hero:FindAbilityByName("tusk_snowball"):SetActivated(true)
			end
		end

		-- Find hidden modifiers
--		for i = 0, hero:GetModifierCount() -1 do
--			print(hero:GetUnitName(), hero:GetModifierNameByIndex(i))
--		end
	end

	if GetMapName() == "imba_overthrow" then
		self:UpdateScoreboard()
		self:ThinkGoldDrop() -- TODO: Enable this
		self:ThinkSpecialItemDrop()
		CountdownTimer()

		if nCOUNTDOWNTIMER == 30 then
			CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
		end

		if nCOUNTDOWNTIMER <= 0 then
			--Check to see if there's a tie
			if isGameTied == false then
				GameRules:SetCustomVictoryMessage( m_VictoryMessages[leadingTeam] )
				GameMode:EndGame( leadingTeam )
				countdownEnabled = false
				return nil
			else
				TEAM_KILLS_TO_WIN = leadingTeamScore + 1
				local broadcast_killcount =
				{
					killcount = TEAM_KILLS_TO_WIN
				}

				CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
			end
		end
	elseif GetMapName() == "cavern" then
	else
		-- fix for super high respawn time
		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if not hero:IsAlive() then
				local respawn_time = hero:GetTimeUntilRespawn()
				local reaper_scythe = 36 -- max necro timer addition

				if hero:HasModifier("modifier_imba_reapers_scythe_respawn") then
					if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), #HERO_RESPAWN_TIME_PER_LEVEL)] + reaper_scythe then
						log.warn("NECROPHOS BUG:", hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL])
						respawn_time = respawn_time + reaper_scythe
					end
				else
					if respawn_time > HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), #HERO_RESPAWN_TIME_PER_LEVEL)] then
						log.warn(hero:GetUnitName(), "respawn time too high:", respawn_time..". setting to", HERO_RESPAWN_TIME_PER_LEVEL[#HERO_RESPAWN_TIME_PER_LEVEL])
						respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[math.min(hero:GetLevel(), #HERO_RESPAWN_TIME_PER_LEVEL)]
					end
				end
				hero:SetTimeUntilRespawn(min(respawn_time, 99))
			end
		end

		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			-- End the game if one team completely abandoned
			if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
				if not TEAM_ABANDON then
					TEAM_ABANDON = {} -- 15 second to abandon, is_abandoning?, player_count.
					TEAM_ABANDON[2] = {FULL_ABANDON_TIME, false, 0}
					TEAM_ABANDON[3] = {FULL_ABANDON_TIME, false, 0}
				end

				TEAM_ABANDON[2][3] = PlayerResource:GetPlayerCountForTeam(2)
				TEAM_ABANDON[3][3] = PlayerResource:GetPlayerCountForTeam(3)

				for ID = 0, PlayerResource:GetPlayerCount() -1 do
					local team = PlayerResource:GetTeam(ID)

					if PlayerResource:GetConnectionState(ID) ~= 2 then -- if disconnected then
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
							Notifications:BottomToAll({text = abandon_text.." ("..tostring(TEAM_ABANDON[team][1])..")", duration = 1.0, style = {color = "DodgerBlue"} })
						end

						TEAM_ABANDON[team][2] = true
						TEAM_ABANDON[team][1] = TEAM_ABANDON[team][1] -1

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
	end

	if i == nil then i = AP_GAME_TIME -1
	elseif i < 0 then
		if PICKING_SCREEN_OVER == false then
			PICKING_SCREEN_OVER = true
		end

		return 1
	else
		i = i - 1
	end

--	print("i = "..i)

	return 1
end

function GameMode:DonatorCompanionJS(event)
	DonatorCompanion(event.ID, event.unit, event.js)
end

function GameMode:DonatorStatueJS(event)
	DonatorStatue(event.ID, event.unit)
end

function GameMode:MaxGold(event)
	local hero = PlayerResource:GetPlayer(event.ID):GetAssignedHero()

	if IsInToolsMode() then
		hero:ModifyGold(99999, true, DOTA_ModifyGold_CheatCommand)
	else
		AntiDevCheat(event.ID)
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
		AntiDevCheat(event.ID)
	end
end

function GameMode:NetgraphGiveItem(event)
	local hero = PlayerResource:GetPlayer(event.ID):GetAssignedHero()

	if IsInToolsMode() then
		hero:AddItemByName("item_"..event.item)
		hero:AddItemByName("item_imba_"..event.item)
	else
		AntiDevCheat(event.ID)
	end
end

function GameMode:GG(event)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME then return end

--	print(event.ID, event.Vote)

	GG_TEAM[2] = {0, PlayerResource:GetPlayerCountForTeam(2)}
	GG_TEAM[3] = {0, PlayerResource:GetPlayerCountForTeam(3)}

	-- init
	if not GG_TABLE then
		GG_TABLE = {} -- has pressed gg button?, has disconnected?
		local count = PlayerResource:GetPlayerCount()
		if IsInToolsMode() then
			count = 20
		end
		for i = 0, count - 1 do
			GG_TABLE[i] = {false, false}
		end
	end

--	print("Vote:", event.Vote)
	if event.Vote == 1 then
		GG_TABLE[event.ID][1] = true
	end

--	print("Disconnect:", event.disconnect)
	if event.disconnect == 1 then -- disconnect
		GG_TABLE[event.ID][2] = true
	elseif event.disconnect == 2 then -- reconnect

	else -- call '-gg' chat command
		Notifications:BottomToTeam(PlayerResource:GetTeam(event.ID), {text = PlayerResource:GetPlayerName(event.ID).." called GG through the GG Panel!", duration = 4.0, style = {color = "DodgerBlue"} })
		GG_TABLE[event.ID][2] = false
	end

	for i = 0, PlayerResource:GetPlayerCount() - 1 do
		if (GG_TABLE[i][1] or GG_TABLE[i][2]) and GG_TEAM[PlayerResource:GetTeam(event.ID)][1] < GG_TEAM[PlayerResource:GetTeam(event.ID)][2] then
			GG_TEAM[PlayerResource:GetTeam(event.ID)][1] = GG_TEAM[PlayerResource:GetTeam(event.ID)][1] + 1
		end
	end

--	PrintTable(GG_TABLE)
--	print("---------------")
--	PrintTable(GG_TEAM)

	CustomGameEventManager:Send_ServerToAllClients("gg_called", {ID = event.ID, team = PlayerResource:GetTeam(event.ID), radiant_count = GG_TEAM[2], dire_count = GG_TEAM[3], gg_table = GG_TABLE})

	for i = 2, 3 do
--		print(i, GG_TEAM[i][1], GG_TEAM[i][2])
		if GG_TEAM[i][1] > 0 and GG_TEAM[i][1] >= GG_TEAM[i][2] then
--			print("GG")
			local text = {}
			text[2] = "#imba_team_good_gg_message"
			text[3] = "#imba_team_bad_gg_message"
			Notifications:BottomToAll({text = text[i], duration = 5.0, style = {color = "DodgerBlue"} })

			Timers:CreateTimer(5.0, function()
					if i == 2 then
						GAME_WINNER_TEAM = 3
						GameRules:SetGameWinner(3)
					elseif i == 3 then
						GAME_WINNER_TEAM = 2
						GameRules:SetGameWinner(2)
					end
				end)

			break
		end
	end
end
