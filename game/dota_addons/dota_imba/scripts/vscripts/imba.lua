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
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for creating frankenstein monsters
require('libraries/attachments')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')
-- This library used to handle scoreboard events
require('internal/scoreboard_events')
-- This library used to handle custom IMBA talent UI (hero_selection will need to use a function in this)
require('internal/imba_talent_events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

-- clientside KV loading
require('addon_init')

ApplyAllTalentModifiers()
StoreCurrentDayCycle()

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
function GameMode:PostLoadPrecache()

end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()

	-------------------------------------------------------------------------------------------------
	-- IMBA: Roshan initialization
	-------------------------------------------------------------------------------------------------

	if GetMapName() ~= "imba_arena" then
		local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
		local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)
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
		"npc_imba_contributor_hewdraw",
		"npc_imba_contributor_zimber",
		"npc_imba_contributor_matt",
		"npc_imba_contributor_maxime",
		"npc_imba_contributor_poly",
		"npc_imba_contributor_firstlady"
	}

	-- Add 8 random contributor statues
	local current_location
	local current_statue
	local statue_entity
	for i = 1, 8 do
		current_location = Entities:FindByName(nil, "contributor_location_0"..i):GetAbsOrigin()
		current_statue = table.remove(contributor_statues, RandomInt(1, #contributor_statues))
		if i <= 4 then
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

	-- Ignore negative experience values
	if keys.experience < 0 then
		return false
	end

	-- Lobby options adjustment
	local game_time = math.max(GameRules:GetDOTATime(false, false), 0)
	keys.experience = keys.experience * (1 + CUSTOM_XP_BONUS * 0.01) * (1 + game_time * BOUNTY_RAMP_PER_SECOND * 0.01)

	return true
end

---------------------------------------------------------------------
-- Arcane Supremacy duration reduction applicable debuffs
---------------------------------------------------------------------
arcane_supremacy_eligible_debuffs = {
	["modifier_silence"] = true,
	["modifier_item_imba_orchid_debuff"] = true,
	["modifier_item_imba_bloodthorn_debuff"] = true,
	["modifier_imba_gust_silence"] = true,
	["modifier_imba_crippling_fear_day"] = true,
	["modifier_imba_crippling_fear_night"] = true,
	["modifier_imba_stifling_dagger_silence"] = true,
	["modifier_imba_ancient_seal_silence"] = true,
	["modifier_imba_silencer_last_word_repeat_thinker"] = true,
	["modifier_imba_silencer_global_silence"] = true,
}

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
			local tenacity = modifier_owner:GetTenacity()
			if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 and tenacity ~= 0 then
				keys.duration = keys.duration * (100 - tenacity) * 0.01
			end
		end


	-------------------------------------------------------------------------------------------------
	-- Silencer Arcane Supremacy silence duration reduction
	-------------------------------------------------------------------------------------------------

		if modifier_owner:HasModifier("modifier_imba_silencer_arcane_supremacy") then
			if not modifier_owner:PassivesDisabled() then
				local arcane_supremacy = modifier_owner:FindModifierByName("modifier_imba_silencer_arcane_supremacy")
				local silence_reduction_pct = arcane_supremacy:GetSilenceReductionPct()
				if modifier_owner:GetTeam() ~= modifier_caster:GetTeam() and keys.duration > 0 and arcane_supremacy_eligible_debuffs[modifier_name] then
					-- if more than 100 reduction, don't even apply the modifier
					if silence_reduction_pct >= 100 then
						return false
					end
					keys.duration = keys.duration * (1 - silence_reduction_pct/100)
				end
			end
		end
	end
	return true
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
	-- Rune pickup logic
	-------------------------------------------------------------------------------------------------

	if item_name == "item_imba_rune_bounty" or item_name == "item_imba_rune_bounty_arena" or item_name == "item_imba_rune_double_damage" or item_name == "item_imba_rune_haste" or item_name == "item_imba_rune_regeneration" then

		-- Only real heroes can pick up runes
		--if unit:IsRealHero() then
			if item_name == "item_imba_rune_bounty" or item_name == "item_imba_rune_bounty_arena" then
				PickupBountyRune(item, unit)
				return false
			end

			if item_name == "item_imba_rune_double_damage" then
				PickupDoubleDamageRune(item, unit)
				return false
			end

			if item_name == "item_imba_rune_haste" then
				PickupHasteRune(item, unit)
				return false
			end

			if item_name == "item_imba_rune_regeneration" then
				PickupRegenerationRune(item, unit)
				return false
			end

		-- If this is not a real hero, drop another rune in place of the picked up one
		-- else
		-- 	local new_rune = CreateItem(item_name, nil, nil)
		-- 	CreateItemOnPositionForLaunch(item:GetAbsOrigin(), new_rune)
		-- 	return false
		-- end
	end

	-------------------------------------------------------------------------------------------------
	-- Aegis of the Immortal pickup logic
	-------------------------------------------------------------------------------------------------

	if item_name == "item_imba_aegis" then
		
		-- If this is a player, do Aegis stuff
		if unit:IsRealHero() then

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

			-- Destroy the item
			return false
		end
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
		if unit:IsRealHero() then
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
		if unit:IsIllusion() then
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
			modifier:DecrementStackCount()
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
			modifier:DecrementStackCount()
			if modifier:GetStackCount() == 0 then
				modifier:Destroy()
			end
		end
	end
	
	if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
		local ability = EntIndexToHScript(keys.entindex_ability)
		
		-- Magnataur Skewer handler
		if unit:HasModifier("modifier_imba_skewer_motion_controller") then
			if ability:GetAbilityName() == "imba_magnataur_skewer" then
				unit:FindModifierByName("modifier_imba_skewer_motion_controller").begged_for_pardon = true
			end
		end
		
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
	
	
	-- Divine Rapier undropable
	if (keys.order_type == DOTA_UNIT_ORDER_DROP_ITEM) or (keys.order_type == DOTA_UNIT_ORDER_MOVE_ITEM) or (keys.order_type == DOTA_UNIT_ORDER_GIVE_ITEM) or (keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM) then
		local item
		if keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
			item = EntIndexToHScript(keys.entindex_target):GetContainedItem()
		else
			item = EntIndexToHScript(keys.entindex_ability)
		end
		if item.IsRapier then
			local player_ID
			-- Courier handling
			if unit:IsCourier() then
				player_ID = keys.issuer_player_id_const
				if (keys.order_type == DOTA_UNIT_ORDER_PICKUP_ITEM) then
					DisplayError(player_ID,"#dota_hud_error_cant_item_courier")
					return false
				end
				if keys.entindex_target	and (keys.order_type == DOTA_UNIT_ORDER_GIVE_ITEM) then
					local hTarget = EntIndexToHScript(keys.entindex_target)
					if item:GetPurchaser():GetPlayerID() == hTarget:GetPlayerID() then
						return true
					end
				end
			else
				player_ID = unit:GetPlayerID()
			end
			-- Player handling
			if (keys.order_type == DOTA_UNIT_ORDER_GIVE_ITEM) then
				DisplayError(player_ID,"#dota_hud_error_cant_item_give")
				return false
			end
			if  (keys.entindex_target >= DOTA_STASH_SLOT_1) and (keys.entindex_target <= DOTA_STASH_SLOT_6) then
				DisplayError(player_ID,"#dota_hud_error_cant_item_stash")
				return false
			end
			if not ((keys.position_x == 0) and (keys.position_y == 0) and (keys.position_z == 0)) then
				DisplayError(player_ID,"#dota_hud_error_cant_item_drop")
				return false
			end
			if (keys.entindex_target >= DOTA_ITEM_SLOT_7) and (keys.entindex_target <= DOTA_ITEM_SLOT_9) then
				DisplayError(player_ID,"#dota_hud_error_cant_item_backpack")
				return false
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
		local display_red_crit_number = false

		-- Lack of entities handling
		if not attacker or not victim then
			return false
		end

		-- Cursed Rapier damage reduction
		if victim:HasModifier("modifier_imba_rapier_cursed") and keys.damage > 0 and victim:GetTeam() ~= attacker:GetTeam() then
			keys.damage = keys.damage * 0.25
		end

		-- Spiked Carapace damage prevention
		if victim:HasModifier("modifier_imba_spiked_carapace") and keys.damage > 0 then

			-- Nullify damage
			keys.damage = 0

			-- Prevent crit damage notifications
			display_red_crit_number = false
		end

		-- Vanguard block
		if victim:HasModifier("modifier_item_vanguard_unique") and keys.damage > 0 then

			-- If a higher tier of Vanguard-based block is present, do nothing
			if not ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") or victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

				-- Reduce damage
				if victim:GetTeam() ~= attacker:GetTeam() then
					keys.damage = keys.damage * 0.90
				end

				-- Physical damage block
				if damage_type == DAMAGE_TYPE_PHYSICAL and not ( attacker:IsBuilding() or attacker:GetUnitName() == "witch_doctor_death_ward" ) then

					-- Calculate damage block
					local damage_block = 0 + victim:GetLevel()

					-- Calculate actual damage
					local actual_damage = math.max(keys.damage - damage_block, 0)

					-- Calculate actually blocked damage
					local damage_blocked = keys.damage - actual_damage

					-- Play block message
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

					-- Reduce damage
					keys.damage = actual_damage
				end
			end
		end

		-- Crimson Guard block
		if ( victim:HasModifier("modifier_item_crimson_guard_unique") or victim:HasModifier("modifier_item_crimson_guard_active") ) and keys.damage > 0 then

			-- If a higher tier of Vanguard-based block is present, do nothing
			if not ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and not victim:HasModifier("modifier_sheepstick_debuff") then

				-- Reduce damage
				if victim:GetTeam() ~= attacker:GetTeam() then
					keys.damage = keys.damage * 0.85
				end

				-- Physical damage block
				if damage_type == DAMAGE_TYPE_PHYSICAL and not ( attacker:IsBuilding() or attacker:GetUnitName() == "witch_doctor_death_ward" ) then

					-- Calculate damage block
					local damage_block
					if victim:GetLevel() then
						damage_block = 5 + victim:GetLevel()
					else
						damage_block = 20
					end

					-- Calculate actual damage
					local actual_damage = math.max(keys.damage - damage_block, 0)

					-- Calculate actually blocked damage
					local damage_blocked = keys.damage - actual_damage

					-- Play block message
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

					-- Reduce damage
					keys.damage = actual_damage
				end
			end
		end

		-- Greatwyrm plate block
		if ( victim:HasModifier("modifier_item_greatwyrm_plate_unique") or victim:HasModifier("modifier_item_greatwyrm_plate_active") ) and keys.damage > 0 and not victim:HasModifier("modifier_sheepstick_debuff") then

			-- Reduce damage
			if victim:GetTeam() ~= attacker:GetTeam() then
				keys.damage = keys.damage * 0.85
			end

			-- Physical damage block
			if damage_type == DAMAGE_TYPE_PHYSICAL and not ( attacker:IsBuilding() or attacker:GetUnitName() == "witch_doctor_death_ward" ) then

				-- Calculate damage block
				local damage_block
				if victim:GetLevel() then
					damage_block = 10 + victim:GetLevel()
				else
					damage_block = 25
				end

				-- Calculate actual damage
				local actual_damage = math.max(keys.damage - damage_block, 0)

				-- Calculate actually blocked damage
				local damage_blocked = keys.damage - actual_damage

				-- Play block message
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, damage_blocked, nil)

				-- Reduce damage
				keys.damage = actual_damage
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

		-- Damage overhead display
		if display_red_crit_number then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)		
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
				if scythe_caster and attacker ~= scythe_caster then
					keys.damage = 0

					-- Find the Reaper's Scythe ability
					local ability = caster:FindAbilityByName("imba_necrolyte_reapers_scythe")
					if not ability then return nil end

					-- Attempt to kill the target, crediting it to the caster of Reaper's Scythe
					ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetHealth(), damage_type = DAMAGE_TYPE_PURE})
				end
			end
		end

		-- Centaur Bulging Hide
		if victim:HasModifier("modifier_imba_return_damage_block") then
			local return_ability = victim:FindAbilityByName("imba_centaur_return")
			local stacks = victim:FindModifierByName("modifier_imba_return_damage_block"):GetStackCount()
			if return_ability and stacks then
				local damage_block = return_ability:GetSpecialValueFor("damage_block")
				local block = damage_block * stacks

				keys.damage = keys.damage - block
			end
		end

		-- Cheese auto-healing
		if victim:HasModifier("modifier_imba_cheese_death_prevention") then
			
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
			local fountain_ability = building:FindAbilityByName("imba_fountain_buffs")
			local swipes_ability = building:FindAbilityByName("imba_fountain_grievous_wounds")
			fountain_ability:SetLevel(1)
			swipes_ability:SetLevel(1)
		elseif string.find(building_name, "tower") then
			building:SetDayTimeVisionRange(1900)
			building:SetNightTimeVisionRange(800)
		end
	end	
end

--[[
	This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
	if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
	levels, changing the starting gold, removing/adding abilities, adding physics, etc.

	The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)

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
		RADIANT_CONTROL_POINT_DUMMY = CreateUnitByName("npc_dummy_unit", radiant_control_point_loc, false, nil, nil, DOTA_TEAM_NOTEAM)
		DIRE_CONTROL_POINT_DUMMY = CreateUnitByName("npc_dummy_unit", dire_control_point_loc, false, nil, nil, DOTA_TEAM_NOTEAM)
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
			XP_PER_LEVEL_TABLE[i] = XP_PER_LEVEL_TABLE[i-1] + i * 100
			GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
		end
	end

	-------------------------------------------------------------------------------------------------
	-- IMBA: Rune timers setup
	-------------------------------------------------------------------------------------------------

	Timers:CreateTimer(0, function()
		if GetMapName() == "imba_arena" then
			SpawnArenaRunes()
		else
			SpawnImbaRunes()
		end
		return RUNE_SPAWN_TIME
	end)

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
		local protective_instict = "imba_tower_protective_instinct"		
		
		-- Roll the random tower abilities for this game
		TOWER_UPGRADE_TREE["safelane"]["tier_1"][1] = GetRandomTowerAbility(1)		

		TOWER_UPGRADE_TREE["safelane"]["tier_2"][1] = GetRandomTowerAbility(2)

		TOWER_UPGRADE_TREE["safelane"]["tier_3"][1] = GetRandomTowerAbility(3)		
		
		TOWER_UPGRADE_TREE["hardlane"]["tier_1"][1] = GetRandomTowerAbility(1)
		
		TOWER_UPGRADE_TREE["hardlane"]["tier_2"][1] = GetRandomTowerAbility(2)
		
		TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1] = GetRandomTowerAbility(3)

		TOWER_UPGRADE_TREE["midlane"]["tier_1"][1] = GetRandomTowerAbility(1)
		
		TOWER_UPGRADE_TREE["midlane"]["tier_2"][1] = GetRandomTowerAbility(2)
		
		TOWER_UPGRADE_TREE["midlane"]["tier_3"][1] = GetRandomTowerAbility(3)

		TOWER_UPGRADE_TREE["midlane"]["tier_41"][1] = GetRandomTowerAbility(3)	
		
		TOWER_UPGRADE_TREE["midlane"]["tier_42"][1] = GetRandomTowerAbility(3)
		
		-- Make sure tier 3 abilities are unique between themselves. Includes tier 4 towers
		local tier_3_and_4_towers = {} -- towers to index
		local tier_3_abilities = {} -- distinct abilities		
		local is_distinct = false	
		local tower_ability_found = false
		
		-- Insert all tower upgrade trees into the table for easy looping		
		table.insert(tier_3_and_4_towers, TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1])
		table.insert(tier_3_and_4_towers, TOWER_UPGRADE_TREE["midlane"]["tier_3"][1])
		table.insert(tier_3_and_4_towers, TOWER_UPGRADE_TREE["midlane"]["tier_41"][1])
		table.insert(tier_3_and_4_towers, TOWER_UPGRADE_TREE["midlane"]["tier_42"][1])
		
		
		-- First T3 tower ability is used for sure, no checking needed
		table.insert(tier_3_abilities, TOWER_UPGRADE_TREE["safelane"]["tier_3"][1])
		
		-- Roll unique abilities for each tower. 
		-- i resembles the current ability that was picked for a certain tower.
		-- j resembles the current ability that former towers have already picked.
		for i=1, #tier_3_and_4_towers do			
			is_distinct = false		
			while not is_distinct do
				tower_ability_found = false
				for j=1, #tier_3_abilities do				
					if tier_3_and_4_towers[i] == tier_3_abilities[j] then						
						tower_ability_found = true
						tier_3_and_4_towers[i] = GetRandomTowerAbility(3)						
						break
					end				
				end
				
				if not tower_ability_found then
					is_distinct = true
					table.insert(tier_3_abilities, tier_3_and_4_towers[i])
				end			
			end
		end

		-- Assign final tower abilities from the table
		TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1] = tier_3_and_4_towers[1]
		TOWER_UPGRADE_TREE["midlane"]["tier_3"][1] = tier_3_and_4_towers[2]
		TOWER_UPGRADE_TREE["midlane"]["tier_41"][1] = tier_3_and_4_towers[3]
		TOWER_UPGRADE_TREE["midlane"]["tier_42"][1] = tier_3_and_4_towers[4]

		-- Make sure that Tier 4 towers are distinct in the actives they get
		TOWER_UPGRADE_TREE["midlane"]["tier_41"][2] = GetRandomTowerAbility(4)
		TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] = GetRandomTowerAbility(4)
		while TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] == TOWER_UPGRADE_TREE["midlane"]["tier_41"][2] do
			TOWER_UPGRADE_TREE["midlane"]["tier_42"][2] = GetRandomTowerAbility(4)
		end

		-- Safelane towers
		for i = 1, 3 do
			
			-- Find safelane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_safe_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_safe_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]
			
			-- Grant Protective Instinct ability to each tower
			radiant_tower:AddAbility(protective_instict)
			dire_tower:AddAbility(protective_instict)
			local radiant_protective = radiant_tower:FindAbilityByName(protective_instict)
			local dire_protective = dire_tower:FindAbilityByName(protective_instict)
			radiant_protective:SetLevel(1)
			dire_protective:SetLevel(1)

			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "safelane"
			dire_tower.tower_lane = "safelane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["safelane"]["tier_3"][1]
			end

			
			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Mid towers
		for i = 1, 3 do
			
			-- Find mid towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_mid_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_mid_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Grant Protective Instinct ability to each tower
			radiant_tower:AddAbility(protective_instict)
			dire_tower:AddAbility(protective_instict)
			local radiant_protective = radiant_tower:FindAbilityByName(protective_instict)
			local dire_protective = dire_tower:FindAbilityByName(protective_instict)
			radiant_protective:SetLevel(1)
			dire_protective:SetLevel(1)
			
			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "midlane"
			dire_tower.tower_lane = "midlane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["midlane"]["tier_3"][1]
			end			

			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Hardlane towers
		for i = 1, 3 do
			
			-- Find hardlane towers
			local radiant_tower_loc = Entities:FindByName(nil, "radiant_hard_tower_t"..i):GetAbsOrigin()
			local dire_tower_loc = Entities:FindByName(nil, "dire_hard_tower_t"..i):GetAbsOrigin()
			local radiant_tower = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local dire_tower = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_tower_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			radiant_tower = radiant_tower[1]
			dire_tower = dire_tower[1]

			-- Grant Protective Instinct ability to each tower
			radiant_tower:AddAbility(protective_instict)
			dire_tower:AddAbility(protective_instict)
			local radiant_protective = radiant_tower:FindAbilityByName(protective_instict)
			local dire_protective = dire_tower:FindAbilityByName(protective_instict)
			radiant_protective:SetLevel(1)
			dire_protective:SetLevel(1)
			
			-- Store the towers' tier and lane
			radiant_tower.tower_tier = i
			dire_tower.tower_tier = i
			radiant_tower.tower_lane = "hardlane"
			dire_tower.tower_lane = "hardlane"

			-- Fetch the corresponding ability's name
			local ability_name
			if i == 1 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_1"][1]
			elseif i == 2 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_2"][1]
			elseif i == 3 then
				ability_name = TOWER_UPGRADE_TREE["hardlane"]["tier_3"][1]
			end			
			
			
			-- Add and level up the ability
			radiant_tower:AddAbility(ability_name)
			dire_tower:AddAbility(ability_name)
			local radiant_ability = radiant_tower:FindAbilityByName(ability_name)
			local dire_ability = dire_tower:FindAbilityByName(ability_name)
			radiant_ability:SetLevel(1)
			dire_ability:SetLevel(1)
		end

		-- Tier 4s
		local radiant_left_t4_loc = Entities:FindByName(nil, "radiant_left_tower_t4"):GetAbsOrigin()
		local radiant_right_t4_loc = Entities:FindByName(nil, "radiant_right_tower_t4"):GetAbsOrigin()
		local dire_left_t4_loc = Entities:FindByName(nil, "dire_left_tower_t4"):GetAbsOrigin()
		local dire_right_t4_loc = Entities:FindByName(nil, "dire_right_tower_t4"):GetAbsOrigin()
		local radiant_left_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local radiant_right_t4 = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, radiant_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_left_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_left_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local dire_right_t4 = FindUnitsInRadius(DOTA_TEAM_BADGUYS, dire_right_t4_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		radiant_left_t4 = radiant_left_t4[1]
		radiant_right_t4 = radiant_right_t4[1]
		dire_left_t4 = dire_left_t4[1]
		dire_right_t4 = dire_right_t4[1]

		-- Store the towers' tier and lane
		radiant_left_t4.tower_tier = 41
		radiant_right_t4.tower_tier = 42
		dire_left_t4.tower_tier = 41
		dire_right_t4.tower_tier = 42
		radiant_left_t4.tower_lane = "midlane"
		radiant_right_t4.tower_lane = "midlane"
		dire_left_t4.tower_lane = "midlane"
		dire_right_t4.tower_lane = "midlane"

		-- Grant Protective Instinct ability to each tower
		radiant_left_t4:AddAbility(protective_instict)
		radiant_right_t4:AddAbility(protective_instict)
		dire_left_t4:AddAbility(protective_instict)
		dire_right_t4:AddAbility(protective_instict)
		local radiant_protective_left = radiant_left_t4:FindAbilityByName(protective_instict)
		local radiant_protective_right = radiant_right_t4:FindAbilityByName(protective_instict)
		local dire_protective_left = dire_left_t4:FindAbilityByName(protective_instict)
		local dire_protective_right = dire_right_t4:FindAbilityByName(protective_instict)
		radiant_protective_left:SetLevel(1)
		radiant_protective_right:SetLevel(1)
		dire_protective_left:SetLevel(1)
		dire_protective_right:SetLevel(1)
		
		-- Add and level up the aura and active
		
		for i = 1, 2 do
			local ability_name_1 = TOWER_UPGRADE_TREE["midlane"]["tier_41"][i]
			local ability_name_2 = TOWER_UPGRADE_TREE["midlane"]["tier_42"][i]
			radiant_left_t4:AddAbility(ability_name_1)
			dire_left_t4:AddAbility(ability_name_1)
			radiant_right_t4:AddAbility(ability_name_2)
			dire_right_t4:AddAbility(ability_name_2)
			local radiant_left_ability = radiant_left_t4:FindAbilityByName(ability_name_1)
			local dire_left_ability = dire_left_t4:FindAbilityByName(ability_name_1)
			local radiant_right_ability = radiant_right_t4:FindAbilityByName(ability_name_2)
			local dire_right_ability = dire_right_t4:FindAbilityByName(ability_name_2)
			radiant_left_ability:SetLevel(1)
			dire_left_ability:SetLevel(1)
			radiant_right_ability:SetLevel(1)
			dire_right_ability:SetLevel(1)
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

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

	GameRules.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")

	initScoreBoardEvents()
	InitPlayerHeroImbaTalents();
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end

	print( '*********************************************' )
end