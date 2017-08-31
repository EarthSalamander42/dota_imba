-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output

BAREBONES_DEBUG_SPEW = false

if GameMode == nil then
	DebugPrint( '[IMBA] creating game mode' )
	_G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
require('libraries/projectiles_new')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for creating frankenstein monsters
require('libraries/attachments')
-- A*-Path-finding logic
require('libraries/astar')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
-- These are the XP system
require('server/server')
require('libraries/json')
-- All custom constants
require('internal/constants')
-- This library used to handle scoreboard events
require('internal/scoreboard_events')
-- This library used to handle custom IMBA talent UI (hero_selection will need to use a function in this)
require('internal/imba_talent_events')

-- Meepo Vanilla fix (from Angel Arena Black Star)
require('libraries/meepo/data')
require('libraries/meepo/meepo')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

-- clientside KV loading
require('addon_init')

ApplyAllTalentModifiers()
StoreCurrentDayCycle()

--	if IsInToolsMode() then
--		OverrideCreateParticle()
--		OverrideReleaseIndex()
--	end

-- storage API
--require('libraries/json')
--require('libraries/storage')

--Storage:SetApiKey("35c56d290cbd168b6a58aabc43c87aff8d6b39cb")

--[[
	This function should be used to set up Async precache calls at the beginning of the gameplay.

	In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
	after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
	be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
	precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
	defined on the unit.

	This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
	time, you can call the functions individually (for example if you want to precache units in a new wave of
	holdout).

	This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]

 function GameMode:OnItemPickedUp(event) 
   -- If this is a hero
   if event.HeroEntityIndex then
       local owner = EntIndexToHScript( event.HeroEntityIndex )
       -- And you've picked up a gold bag
       if owner:IsHero() and event.itemname == "item_bag_of_gold" then
           -- Pick up the gold
           GoldPickup(event)
       end
    end
  end

function GameMode:PostLoadPrecache()

end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Roshan and Picking Screen camera initialization
	-------------------------------------------------------------------------------------------------

	if GetMapName() == "imba_arena" then
		GoodCamera = Entities:FindByName(nil, "radiant_capture_point")
		BadCamera = Entities:FindByName(nil, "dire_capture_point")
	elseif GetMapName() == "imba_diretide" then
		GoodCamera = Entities:FindByName(nil, "dota_goodguys_fort")
		BadCamera = Entities:FindByName(nil, "dota_badguys_fort")
	else
--		local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
--		local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)
--		roshan:FindAbilityByName("imba_roshan_rage"):SetLevel(1)

		GoodCamera = Entities:FindByName(nil, "good_healer_7")
		BadCamera = Entities:FindByName(nil, "bad_healer_7")
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Pre-pick forced hero selection
	-------------------------------------------------------------------------------------------------

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")

	-------------------------------------------------------------------------------------------------
	-- IMBA: Contributor models
	-------------------------------------------------------------------------------------------------

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

	-- Add 4 random contributor statues
	local current_location
	local current_statue
	local statue_entity
	for i = 1, 4 do
		current_location = Entities:FindByName(nil, "contributor_location_0"..i):GetAbsOrigin()
		current_statue = table.remove(contributor_statues, RandomInt(1, #contributor_statues))
		if i <= 2 then
			statue_entity = CreateUnitByName(current_statue, current_location, true, nil, nil, DOTA_TEAM_GOODGUYS)
			statue_entity:SetForwardVector(Vector(1, 1, 0):Normalized())
		else
			statue_entity = CreateUnitByName(current_statue, current_location, true, nil, nil, DOTA_TEAM_BADGUYS)
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
		"npc_imba_developer_fudge",
		"npc_imba_developer_lindbrum",
		"npc_imba_developer_sercankd",
		"npc_imba_developer_yahnich",
	}

	-- Add 4 random developer statues
	local current_location
	local current_statue
	local statue_entity
	for i = 1, 4 do
		current_location = Entities:FindByName(nil, "developer_location_0"..i):GetAbsOrigin()
		current_statue = table.remove(developer_statues, RandomInt(1, #developer_statues))
		if i <= 2 then
			statue_entity = CreateUnitByName(current_statue, current_location, true, nil, nil, DOTA_TEAM_GOODGUYS)
			statue_entity:SetForwardVector(Vector(1, 1, 0):Normalized())
		else
			statue_entity = CreateUnitByName(current_statue, current_location, true, nil, nil, DOTA_TEAM_BADGUYS)
			statue_entity:SetForwardVector(Vector(-1, -1, 0):Normalized())
		end
		statue_entity:AddNewModifier(statue_entity, nil, "modifier_imba_contributor_statue", {})
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arena mode score initialization
	-------------------------------------------------------------------------------------------------

	CustomNetTables:SetTableValue("arena_capture", "radiant_score", {0})
	CustomNetTables:SetTableValue("arena_capture", "dire_score", {0})
end

-- Multiplies bounty rune experience and gold according to the gamemode multiplier
function GameMode:BountyRuneFilter( keys )

	--player_id_const	 ==> 	0
	--xp_bounty	 ==> 	136.5
	--gold_bounty	 ==> 	132.6

	-- local game_time = math.max(GameRules:GetDOTATime(false, false) / 60, 0)
	-- keys["gold_bounty"] = ( 1 + CUSTOM_GOLD_BONUS * 0.01 ) * (1 + game_time * BOUNTY_RAMP_PER_MINUTE * 0.01) * keys["gold_bounty"]
	-- keys["xp_bounty"] = ( 1 + CUSTOM_XP_BONUS * 0.01 ) * (1 + game_time * BOUNTY_RAMP_PER_MINUTE * 0.01) * keys["xp_bounty"]

	return true
end

-- Gold gain filter function
function GameMode:GoldFilter( keys )
	-- reason_const		12
	-- reliable			1
	-- player_id_const	0
	-- gold				141

	-- Gold from abandoning players does not get multiplied
	if keys.reason_const == DOTA_ModifyGold_AbandonedRedistribute then
		return true
	end

	local hero = PlayerResource:GetPickedHero(keys.player_id_const)

	-- Hand of Midas gold bonus
	if hero and hero:HasModifier("modifier_item_imba_hand_of_midas") and keys.gold > 0 then
		keys.gold = keys.gold * 1.1
	end

	-- Lobby options adjustment
	if keys.gold > 0 then
		local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
		keys.gold = keys.gold * (1 + CUSTOM_GOLD_BONUS * 0.01) * (1 + game_time * BOUNTY_RAMP_PER_SECOND * 0.01)
	end

	-- Comeback gold gain
	local team = PlayerResource:GetTeam(keys.player_id_const)
	if COMEBACK_BOUNTY_BONUS[team] > 0 then
		keys.gold = keys.gold * (1 + COMEBACK_BOUNTY_BONUS[team])
	end

	-- Show gold earned message??
	--if hero then
	--	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, hero, keys.gold, nil)
	--end

	return true
end

-- Experience gain filter function
function GameMode:ExperienceFilter( keys )
	-- reason_const		1
	-- experience		130
	-- player_id_const	0

	local hero = PlayerResource:GetPickedHero(keys.player_id_const)

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	-- Lobby options adjustment
	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
	keys.experience = keys.experience * (1 + CUSTOM_XP_BONUS * 0.01) * (1 + game_time * BOUNTY_RAMP_PER_SECOND * 0.01)

	-- Losing team gets huge EXP bonus.
	if hero and CustomNetTables:GetTableValue("gamerules", "losing_team") then
		if CustomNetTables:GetTableValue("gamerules", "losing_team").losing_team then
			local losing_team = CustomNetTables:GetTableValue("gamerules", "losing_team").losing_team
			
			if hero:GetTeamNumber() == losing_team then
				keys.experience = keys.experience * (1 + COMEBACK_EXP_BONUS * 0.01)
			end
		end
	end
			
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

	-------------------------------------------------------------------------------------------------
	-- Frantic mode duration adjustment
	-------------------------------------------------------------------------------------------------

		if IMBA_FRANTIC_MODE_ON then
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 then
				keys.duration = keys.duration * 0.3
			end
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

		if modifier_owner.GetTenacity then						
			local original_duration = keys.duration

			local tenacity = modifier_owner:GetTenacity()
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 and tenacity ~= 0 then				
				keys.duration = keys.duration * (100 - tenacity) * 0.01
			end

			Timers:CreateTimer(FrameTime(), function()
				if modifier_owner:IsNull() then
					return false
				end
				local modifier_handler = modifier_owner:FindModifierByName(modifier_name)
				if modifier_handler then
					if modifier_handler.IgnoreTenacity then
						if modifier_handler:IgnoreTenacity() then
							modifier_handler:SetDuration(original_duration, true)
						end
					end
				end
			end)
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
	local item_name = 0
	if item:GetName() then
		item_name = item:GetName()
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

	local meepo_extra_boots = {
		"item_imba_ironleaf_boots",
		"item_imba_blink_boots",
		"item_imba_power_treads_2",
		"item_imba_haste_boots"
	}

	if unit:GetUnitName() == "npc_dota_hero_meepo" then
		for _, boots in pairs(meepo_extra_boots) do
			if item_name == boots then
				print("Those boots are special!")
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
	
	-- Techies' Focused Detonate cast-handlign
	if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION then
        local ability = EntIndexToHScript(keys.entindex_ability)        
        
        if ability:GetAbilityName() == "imba_techies_focused_detonate" then                        
            unit:AddNewModifier(unit, ability, "modifier_imba_focused_detonate", {duration = 0.2})            
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
					local mod = victim:AddNewModifier(scythe_caster, ability, "modifier_imba_reapers_scythe_respawn", {})
					scythe_modifier:Destroy()
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

				-- If the table doesn't exist yet, initialize it
				if not modifier_stun_handler.enemy_attackers then
					modifier_stun_handler.enemy_attackers = {}
				end

				-- Cycle through the attackers table
				local attacker_found = false
				for _,enemy in pairs(modifier_stun_handler.enemy_attackers) do
					if enemy == attacker then
						attacker_found = true
					end
				end

				-- If this attacker haven't attacked the stunned target yet, guarantee a critical
				if not attacker_found then
					
					-- Get the modifier's ability
					local stun_ability = modifier_stun_handler:GetAbility()
					if stun_ability then

						-- Get the critical damage count
						local on_prow_crit_damage_pct = stun_ability:GetSpecialValueFor("on_prow_crit_damage_pct")

						-- Increase damage and show the critical attack event
						keys.damage = keys.damage * (1 + on_prow_crit_damage_pct * 0.01)

						-- Overhead critical event
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)

						-- Add the attacker to the attackers table
						table.insert(modifier_stun_handler.enemy_attackers, attacker)
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

	GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap(GameMode, "BountyRuneFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap(GameMode, "GoldFilter"), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(GameMode, "ExperienceFilter"), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap(GameMode, "ModifierFilter"), self )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap(GameMode, "ItemAddedFilter"), self )

	-- CHAT
	self.chat = Chat(self.Players, self.Users, TEAM_COLORS)
    --	Chat:constructor(players, users, teamColors)
	print("Constructing Chat!")

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

random_time = 1.0
function GameMode:OnHeroInGame(hero)	
local time_elapsed = 0

	-- Disabling announcer for the player who picked a hero
	Timers:CreateTimer(0.1, function()
		if hero:GetUnitName() ~= "npc_dota_hero_wisp" then
			hero.picked = true
		elseif hero.is_real_wisp then
			print("REAL WISP")
			hero.picked = true
		end
	end)

	Timers:CreateTimer(0.1, function()
		if hero.is_real_wisp then
			print("REAL WISP")
			hero.picked = true
			return
		elseif hero:GetUnitName() ~= "npc_dota_hero_wisp" then
			hero.picked = true
			return
		elseif not hero.is_real_wisp then
			print("FAKE WISP")
			if hero:GetUnitName() == "npc_dota_hero_wisp" then
				Timers:CreateTimer(function()
					if not hero:HasModifier("modifier_imba_prevent_actions_game_start") then
						hero:AddNewModifier(hero, nil, "modifier_imba_prevent_actions_game_start", {})
						hero:AddEffects(EF_NODRAW)
						hero:SetDayTimeVisionRange(475)
						hero:SetNightTimeVisionRange(475)				
						if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
							PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), GoodCamera)
							FindClearSpaceForUnit(hero, GoodCamera:GetAbsOrigin(), false)
						else
							PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), BadCamera)					
							FindClearSpaceForUnit(hero, BadCamera:GetAbsOrigin(), false)
						end
					end
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

	-------------------------------------------------------------------------------------------------
	-- IMBA: Passive gold adjustment
	-------------------------------------------------------------------------------------------------
	
	local adjusted_gold_tick_time = GOLD_TICK_TIME / ( 1 + CUSTOM_GOLD_BONUS * 0.01 )
	GameRules:SetGoldTickTime( adjusted_gold_tick_time )

	-------------------------------------------------------------------------------------------------
	-- IMBA: Arena mode initialization
	-------------------------------------------------------------------------------------------------

	if GetMapName() == "imba_arena" then

		-- Define the bonus gold positions
		local bonus_gold_positions = {}
		bonus_gold_positions.fountain_radiant = {
			stacks = 20,
			center = Vector(-3776, -3776, 384),
			radius = 1300
		}
		bonus_gold_positions.fountain_dire = {
			stacks = 20,
			center = Vector(3712, 3712, 384),
			radius = 1300
		}
		bonus_gold_positions.center_arena = {
			stacks = 40,
			center = Vector(0, 0, 256),
			radius = 900
		}

		-- Continuously update the amount of gold/exp to gain
		Timers:CreateTimer(0, function()

			-- Apply the modifier
			local nearby_heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, 6000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _, hero in pairs(nearby_heroes) do
				if not hero:HasModifier("modifier_imba_arena_passive_gold_thinker") then
					hero:AddNewModifier(hero, nil, "modifier_imba_arena_passive_gold_thinker", {})
				end
				hero:FindModifierByName("modifier_imba_arena_passive_gold_thinker"):SetStackCount(12)
			end

			-- Update stack amount, when relevant
			for _, position in pairs(bonus_gold_positions) do
				nearby_heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, position.center, nil, position.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
				for _, hero in pairs(nearby_heroes) do
					hero:FindModifierByName("modifier_imba_arena_passive_gold_thinker"):SetStackCount(position.stacks)
				end
			end

			-- Adjust ward vision
			local nearby_wards = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0, 0, 0), nil, 6000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for v, ward in pairs(nearby_wards) do
				ward:SetDayTimeVisionRange(1000)
				ward:SetNightTimeVisionRange(1000)
			end
			return 0.1
		end)

		-- Set up control points
		local radiant_control_point_loc = Entities:FindByName(nil, "radiant_capture_point"):GetAbsOrigin()
		local dire_control_point_loc = Entities:FindByName(nil, "dire_capture_point"):GetAbsOrigin()
		RADIANT_CONTROL_POINT_DUMMY = CreateUnitByName("npc_dummy_unit_perma", radiant_control_point_loc, false, nil, nil, DOTA_TEAM_NOTEAM)
		DIRE_CONTROL_POINT_DUMMY = CreateUnitByName("npc_dummy_unit_perma", dire_control_point_loc, false, nil, nil, DOTA_TEAM_NOTEAM)
		RADIANT_CONTROL_POINT_DUMMY.score = 20
		DIRE_CONTROL_POINT_DUMMY.score = 20
		ArenaControlPointThinkRadiant(RADIANT_CONTROL_POINT_DUMMY)
		ArenaControlPointThinkDire(DIRE_CONTROL_POINT_DUMMY)
		Timers:CreateTimer(10, function()
			ArenaControlPointScoreThink(RADIANT_CONTROL_POINT_DUMMY, DIRE_CONTROL_POINT_DUMMY)
		end)
		CustomGameEventManager:Send_ServerToAllClients("contest_started", {})
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Custom maximum level EXP tables adjustment
	-------------------------------------------------------------------------------------------------
	
	if MAX_LEVEL > 35 then
		for i = 36, MAX_LEVEL do
			XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + 5000
			GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		end
	end

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
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
	GameMode = self

	-- Call the internal function to set up the rules/behaviors specified in constants.lua
	-- This also sets up event hooks for all event handlers in events.lua
	-- Check out internals/gamemode to see/modify the exact code
	GameMode:_InitGameMode()

	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	-- IMBA testbed command
	Convars:RegisterCommand("imba_test", Dynamic_Wrap(GameMode, 'StartImbaTest'), "Spawns several units to help with testing", FCVAR_CHEAT)
	Convars:RegisterCommand("particle_table_print", PrintParticleTable, "Prints a huge table of all used particles", FCVAR_CHEAT)	

	-- Panorama event stuff
	initScoreBoardEvents()
	InitPlayerHeroImbaTalents();
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

	-- Define testbed zone reference point
	local testbed_center = Vector(1500, -5000, 256)
	if GetMapName() == "imba_arena" then
		testbed_center = Vector(0, 0, 128)
	end

	-- Move any existing heroes to the testbed area, and grant them useful testing items
	local player_heroes = HeroList:GetAllHeroes()
	for _, hero in pairs(player_heroes) do
		hero:SetAbsOrigin(testbed_center + Vector(-250, 0, 0))
		hero:AddItemByName("item_imba_diffusal_blade_3")
		hero:AddItemByName("item_manta")
		hero:AddItemByName("item_imba_blink")
		hero:AddItemByName("item_imba_silver_edge")
		hero:AddItemByName("item_black_king_bar")
		hero:AddItemByName("item_imba_heart")
		hero:AddItemByName("item_imba_siege_cuirass")
		hero:AddItemByName("item_imba_butterfly")
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
			dummy_hero:AddItemByName("item_manta")
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
			dummy_hero:AddItemByName("item_manta")
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