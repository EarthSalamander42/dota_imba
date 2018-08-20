function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..":")
				PrintTable (value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done [value] = true
				print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
				else
					print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
				end
			end
		end
	end
end

function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

-- Map utils
function MapRanked5v5() return "imba_ranked_5v5" end
function MapRanked10v10() return "imba_ranked_10v10" end
function MapMutation5v5() return "imba_mutation_5v5" end
function MapMutation10v10() return "imba_mutation_10v10" end
function Map1v1() return "imba_1v1" end
function MapTournament() return "map_tournament" end

function IsRankedMap()
	if GetMapName() == MapRanked5v5() or GetMapName() == MapRanked10v10() then
		return true
	end

	return false
end

function Is1v1Map()
	if GetMapName() == Map1v1() then
		return true
	end

	return false
end

function IsTournamentMap()
	if GetMapName() == MapTournament() then
		return true
	end

	return false
end

function IsMutationMap()
	if GetMapName() == MapMutation5v5() or GetMapName() == MapMutation10v10() then
		return true
	end

	return false
end

-- Check if an unit is near the enemy fountain
function IsNearFountain(location, distance)
	for _, fountain in pairs(Entities:FindAllByClassname("ent_dota_fountain")) do
		if (fountain:GetAbsOrigin() - location):Length2D() <= distance then
			return true
		end
	end

	return false
end

-- Finds whether or not an entity is an item container (the box on the game ground)
function CBaseEntity:IsItemContainer()
	if self.GetContainedItem then
		if self:GetContainedItem() then
			return true
		end
	end

	return false
end

-- hero utils

-- Initializes heroes' innate abilities
function InitializeInnateAbilities( hero )	
	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do		
		local current_ability = hero:GetAbilityByIndex(i)		
		if current_ability and current_ability.IsInnateAbility then
			if current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end
		end
	end
end

-- Copy shallow copy given input
function ShallowCopy(orig)
	local copy = {}
	for orig_key, orig_value in pairs(orig) do
		copy[orig_key] = orig_value
	end
	return copy
end

function ShowHUD(bool)
-- 0, Clock
-- 1, Top Bar
-- 2, ???
-- 3, Action Panel
-- 4, Minimap
-- 5, Inventory
-- 6, Courier + Shop Button Area

	for i = 0, 6 do
		if GameRules:GetGameModeEntity():GetHUDVisible(i) ~= bool then
			GameRules:GetGameModeEntity():SetHUDVisible(i, bool)
		end
	end
end

function UpdateRoshanBar(roshan)
	CustomNetTables:SetTableValue("game_options", "roshan", {
			level = GAME_ROSHAN_KILLS +1,
			HP = roshan:GetHealth(),
			HP_alt = roshan:GetHealthPercent(),
			maxHP = roshan:GetMaxHealth()
		})
	return time
end

function CheatDetector()
	if CustomNetTables:GetTableValue("game_options", "game_count").value == 1 then
		if Convars:GetBool("sv_cheats") == true or GameRules:IsCheatMode() then
--			if not IsInToolsMode() then
			print("Cheats have been enabled, game don't count.")
			CustomNetTables:SetTableValue("game_options", "game_count", {value = 0})
			CustomGameEventManager:Send_ServerToAllClients("safe_to_leave", {})
--			end
		end
	end
end

-- TODO: Maybe this is laggy, format it later
function InitItemIds()
	GameMode.itemIDs = {}
	for k,v in pairs(KeyValues.ItemKV) do
		if type(v) == "table" and v.ID then
			GameMode.itemIDs[v.ID] = k
		end
	end
end

-- Yahnich's calculate distance and direction functions
function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end

-- Rolls a Psuedo Random chance. If failed, chances increases, otherwise chances are reset
function RollPseudoRandom(base_chance, entity)
	local chances_table = {
		{5, 0.38},
		{10, 1.48},
		{15, 3.22},
		{16, 3.65},
		{17, 4.09},
		{19, 5.06},
		{20, 5.57},
		{21, 6.11},
		{22, 6.67},
		{24, 7.85},
		{25, 8.48},
		{27, 9.78},
		{30, 11.9},
		{35, 15.8},
		{40, 20.20},
		{50, 30.20},
		{60, 42.30},
		{70, 57.10},
		{100, 100}
	}

	entity.pseudoRandomModifier = entity.pseudoRandomModifier or 0
	local prngBase
	for i = 1, #chances_table do
		if base_chance == chances_table[i][1] then		  
			prngBase = chances_table[i][2]
		end	 
	end

	if not prngBase then
--		log.warn("The chance was not found! Make sure to add it to the table or change the value.")
		return false
	end
	
	if RollPercentage( prngBase + entity.pseudoRandomModifier ) then
		entity.pseudoRandomModifier = 0
		return true
	else
		entity.pseudoRandomModifier = entity.pseudoRandomModifier + prngBase		
		return false
	end
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function TrueKill(caster, target, ability)

	-- Extremely specific blademail interaction because fuck everything
	if caster:HasModifier("modifier_item_blade_mail_reflect") then
		target:RemoveModifierByName("modifier_imba_purification_passive")
	end

	local nothlProtection = target:FindModifierByName("modifier_imba_dazzle_nothl_protection")
	if nothlProtection and nothlProtection:GetStackCount() < 1 then
		nothlProtection:SetStackCount(1)
		nothlProtection:StartIntervalThink(1)
	end

	-- Deals lethal damage in order to trigger death-preventing abilities... Except for Reincarnation
	if not ( target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_reincarnation_wraith_form_buff") or target:HasModifier("modifier_imba_reincarnation_wraith_form") ) then
		target:Kill(ability, caster)
	end

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_invulnerable")
	target:RemoveModifierByName("modifier_imba_dazzle_shallow_grave")
	target:RemoveModifierByName("modifier_imba_aphotic_shield_buff_block")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_borrowed_time")
	target:RemoveModifierByName("modifier_imba_centaur_return")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_active")
	target:RemoveModifierByName("modifier_item_crimson_guard_unique")
	target:RemoveModifierByName("modifier_item_crimson_guard_active")	
	target:RemoveModifierByName("modifier_item_vanguard_unique")
	target:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
	target:RemoveModifierByName("modifier_imba_cheese_death_prevention")
	target:RemoveModifierByName("modifier_imba_rapier_cursed")
	target:RemoveModifierByName("modifier_imba_dazzle_nothl_protection_aura_talent")
	

	-- Kills the target
	if not target:HasModifier("modifier_imba_reincarnation_wraith_form") then
		target:Kill(ability, caster)
	end
end

-- Checks if a unit is near units of a certain class on the same team
function IsNearFriendlyClass(unit, radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, unit:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() == unit:GetTeam() then
			return true
		end
	end
	
	return false
end

function ChangeAttackProjectileImba(unit)

	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	local particle_skadi = "particles/items2_fx/skadi_projectile.vpcf"
	local particle_lifesteal = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"
	local particle_deso_skadi = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local particle_clinkz_arrows = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	local particle_dragon_form_green = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	local particle_dragon_form_red = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
	local particle_dragon_form_blue = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
	local particle_terrorblade_transform = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

	-- If the unit has a Desolator and a Skadi, use the special projectile
	if unit:HasModifier("modifier_item_imba_desolator") or unit:HasModifier("modifier_item_imba_desolator_2") then
		if unit:HasModifier("modifier_item_imba_skadi") then
			unit:SetRangedProjectileName(particle_deso_skadi)
		-- If only a Desolator, use its attack projectile instead
		else
			unit:SetRangedProjectileName(particle_deso)
		end
	-- If only a Skadi, use its attack projectile instead
	elseif unit:HasModifier("modifier_item_imba_skadi") then
		unit:SetRangedProjectileName(particle_skadi)

	-- If the unit has any form of lifesteal, use the lifesteal projectile
	elseif unit:HasModifier("modifier_imba_morbid_mask") or unit:HasModifier("modifier_imba_mask_of_madness") or unit:HasModifier("modifier_imba_satanic") or unit:HasModifier("modifier_item_imba_vladmir") or unit:HasModifier("modifier_item_imba_vladmir_blood") then		
		unit:SetRangedProjectileName(particle_lifesteal)	

	-- If it's one of Dragon Knight's forms, use its attack projectile instead
	elseif unit:HasModifier("modifier_dragon_knight_corrosive_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_green)
	elseif unit:HasModifier("modifier_dragon_knight_splash_attack") then
		unit:SetRangedProjectileName(particle_dragon_form_red)
	elseif unit:HasModifier("modifier_dragon_knight_frost_breath") then
		unit:SetRangedProjectileName(particle_dragon_form_blue)

	-- If it's a metamorphosed Terrorblade, use its attack projectile instead
	elseif unit:HasModifier("modifier_terrorblade_metamorphosis") then
		unit:SetRangedProjectileName(particle_terrorblade_transform)

	-- Else, default to the base ranged projectile
	else
		log.debug(unit:GetKeyValue("ProjectileModel"))
		unit:SetRangedProjectileName(unit:GetKeyValue("ProjectileModel"))
	end
end

-- Sets a creature's max health to [health]
function SetCreatureHealth(unit, health, update_current_health)

	unit:SetBaseMaxHealth(health)
	unit:SetMaxHealth(health)

	if update_current_health then
		unit:SetHealth(health)
	end
end

--[[
-- Items and abilities that have uninterruptable forced movement
function IsUninterruptableForcedMovement( unit )
	
	-- List of uninterruptable movement modifiers
	local modifier_list = {
		"modifier_spirit_breaker_charge_of_darkness",
		"modifier_magnataur_skewer_movement",
		"modifier_invoker_deafening_blast_knockback",
		"modifier_knockback",
		"modifier_item_forcestaff_active",
		"modifier_shredder_timber_chain",
		"modifier_batrider_flaming_lasso",
		"modifier_imba_leap_self_root",
		"modifier_faceless_void_chronosphere_freeze",
		"modifier_storm_spirit_ball_lightning",
		"modifier_morphling_waveform"
	}

	-- Iterate through the list
	for _,modifier_name in pairs(modifier_list) do
		if unit:HasModifier(modifier_name) then
			return true
		end
	end

	return false
end
--]]

-- Returns an unit's existing increased cast range modifiers
function GetCastRangeIncrease( unit )
	local cast_range_increase = 0
	-- Only the greatefd st increase counts for items, they do not stack
	for _, parent_modifier in pairs(unit:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonus then
			cast_range_increase = math.max(cast_range_increase,parent_modifier:GetModifierCastRangeBonus())
		end
	end

	for _, parent_modifier in pairs(unit:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonusStacking then
			cast_range_increase = cast_range_increase + parent_modifier:GetModifierCastRangeBonusStacking()
		end
	end

	return cast_range_increase
end

function SetupTower(tower)
	if tower.initialized then return end
	for i = 1, 4 do
		for _, ability in pairs(TOWER_ABILITIES["tower"..i]) do
			if string.find(tower:GetUnitName(), "tower"..i) then
--				print("Tower found:", ability) -- tower spawned from pocket tower mutation are found and print well, abilities are not given for reasons
				tower:AddAbility(ability):SetLevel(1)
				tower.initialized = true
			end
		end
	end
end

function GetReductionFromArmor(armor)
	local m = 0.06 * armor

	return 100 * (1 - m / ( 1 + math.abs(m)))
end

function CalculateReductionFromArmor_Percentage(armorOffset, armor)
	return -GetReductionFromArmor(armor) + GetReductionFromArmor(armorOffset)
end

-- if isDegree = true, entered angle is degree, else radians
function RotateVector2D(v,angle,bIsDegree)
	if bIsDegree then angle = math.rad(angle) end
	local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
	local yp = v.x * math.sin(angle) + v.y * math.cos(angle)

	return Vector(xp,yp,v.z):Normalized()
end

-- Returns true if a value is in a table, false if it is not.
function CheckIfInTable(table, searched_value, optional_number_of_table_rows_to_search_through)
	-- Searches through the ENTIRE table
	if not optional_number_of_table_rows_to_search_through then
		for _,table_value in pairs(table) do
			if table_value == searched_value then
				return true
			end
		end
	else
		-- Searches through the first few rows
		for i=1, optional_number_of_table_rows_to_search_through do
			if i <= #table then
				if table[i] == searched_value then
					return true
				end
			end
		end
	end

	return false
end

function IsVanillaSilence(modifier_name)
	local vanilla_silences = 
	{["modifier_silence"] = true,
	["modifier_earth_spirit_geomagnetic_grip"] = true}

	if vanilla_silences[modifier_name] then
		return true
	end

	return false
end

function IsImbaSilence(modifier_name)
	local silence_modifiers = 		
		{["modifier_imba_blood_bath_debuff_silence"] = true,							 
		 ["modifier_imba_gust_silence"] = true,
		 ["modifier_imba_crippling_fear_silence"] = true,
		 ["modifier_imba_stifling_dagger_silence"] = true,		 
		 ["modifier_imba_silencer_last_word_repeat_thinker"] = true,
		 ["modifier_imba_silencer_global_silence"] = true,
		 ["modifier_imba_ancient_seal_main"] = true,				 		 
		 ["modifier_imba_blast_off_silence"] = true,
		 ["modifier_item_imba_orchid_debuff"] = true,
		 ["modifier_item_imba_bloodthorn_debuff"] = true,
		 ["modifier_item_imba_kaya_silence"] = true,
		 ["modifier_item_imba_sange_kaya_proc"] = true,
		 ["modifier_item_imba_kaya_yasha_silence"] = true,
		 ["modifier_item_imba_triumvirate_proc_debuff"] = true}


	if silence_modifiers[modifier_name] then
		return true
	end

	return false
end

function IsSilentSilence(modifier_name)
	local silence_modifiers = 		
		{["modifier_imba_ancient_seal_secondary"] = true}


	if silence_modifiers[modifier_name] then
		return true
	end

	return false
end

function IsVanillaDebuff(modifier_name)		
local vanilla_debuffs = 
	{["modifier_cold_feet"] = true,
	["modifier_arc_warden_flux"] = true,
	["modifier_batrider_sticky_napalm"] = true,
	["modifier_flamebreak_damage"] = true,
	["modifier_beastmaster_primal_roar_slow"] = true,
	["modifier_brewmaster_thunder_clap"] = true,
	["modifier_brewmaster_drunken_haze"] = true,
	["modifier_bristleback_viscous_nasal_goo"] = true,
	["modifier_broodmother_spawn_spiderlings"] = true,
	["modifier_broodmother_incapacitating_bite_orb"] = true,
	["modifier_chaos_knight_reality_rift"] = true,
	["modifier_chen_penitence"] = true, 	 
	["modifier_silence"] = true,
	["modifier_doom_bringer_infernal_blade_burn"] = true,
	["modifier_dragonknight_breathefire_reduction"] = true,
	["modifier_dragon_knight_corrosive_breath_dot"] = true,
	["modifier_dragon_knight_frost_breath_slow"] = true,
	["modifier_earth_spirit_rolling_boulder_slow"] = true,
	["modifier_earth_spirit_geomagnetic_grip_debuff"] = true,
	["modifier_earth_spirit_magnetize"] = true,
	["modifier_elder_titan_earth_splitter"] = true,
	["modifier_ember_spirit_searing_chains"] = true,
	["modifier_enchantress_untouchable_slow"] = true,
	["modifier_enchantress_enchant_slow"] = true,
	["modifier_gyrocopter_call_down_slow"] = true,
	["modifier_huskar_life_break_slow"] = true,
	["modifier_invoker_cold_snap"] = true,
	["modifier_invoker_tornado"] = true,
	["modifier_invoker_chaos_meteor_burn"] = true,
	["modifier_wisp_tether_slow"] = true,
	["modifier_keeper_of_the_light_mana_leak"] = true,
	["modifier_keeper_of_the_light_blinding_light"] = true,
	["modifier_leshrac_lightning_storm_slow"] = true,
	["modifier_life_stealer_open_wounds"] = true,
	["modifier_lone_druid_savage_roar"] = true,
	["modifier_meepo_earthbind"] = true,
	["modifier_meepo_geostrike_debuff"] = true,
	["modifier_monkey_king_spring_slow"] = true,
	["modifier_naga_siren_ensnare"] = true,
	["modifier_naga_siren_rip_tide"] = true,
	["modifier_furion_wrathofnature_spawn"] = true,
	["modifier_ogre_magi_ignite"] = true,
	["modifier_oracle_fates_edict"] = true,
	["modifier_oracle_fortunes_end_purge"] = true,
	["modifier_phantom_lancer_spirit_lance"] = true,
	["modifier_phoenix_icarus_dive_burn"] = true,
	["modifier_phoenix_fire_spirit_burn"] = true,
	["modifier_razor_unstablecurrent_slow"] = true,
	["modifier_rubick_fade_bolt_debuff"] = true,
	["modifier_shadow_demon_soul_catcher"] = true,
	["modifier_shadow_demon_shadow_poison"] = true,
	["modifier_shadow_shaman_voodoo"] = true,
	["modifier_templar_assassin_meld_armor"] = true,
	["modifier_templar_assassin_trap_slow"] = true,
	["modifier_terrorblade_reflection_slow"] = true,
	["modifier_tidehunter_gush"] = true,
	["modifier_tidehunter_anchor_smash"] = true,
	["modifier_whirling_death_debuff"] = true,
	["modifier_shredder_chakram_debuff"] = true,
	["modifier_tinker_laser_blind"] = true,
	["modifier_treant_natures_guise_root"] = true,
	["modifier_greevil_leech_seed"] = true,
	["modifier_treant_overgrowth"] = true,
	["modifier_tusk_walrus_punch_slow"] = true,
	["modifier_tusk_walrus_kick_slow"] = true,
	["modifier_abyssal_underlord_pit_of_malice_ensare"] = true,
	["modifier_viper_poison_attack_slow"] = true,
	["modifier_viper_corrosive_skin_slow"] = true,
	["modifier_visage_grave_chill_debuff"] = true,
	["modifier_winter_wyvern_arctic_burn_slow"] = true,
	["modifier_winter_wyvern_splinter_blast_slow"] = true,
	["modifier_big_thunder_lizard_slam"] = true,
	["modifier_dark_troll_warlord_ensnare"] = true,
	["modifier_ghost_frost_attack_slow"] = true,
	["modifier_polar_furbolg_ursa_warrior_thunder_clap"] = true,
	["modifier_ogre_magi_frost_armor_slow"] = true,
	["modifier_imba_roshan_slam"] = true,
	["modifier_imba_roshan_slam_armor"] = true,
	["modifier_satyr_trickster_purge"] = true,
	["modifier_broodmother_poison_sting_debuff"] = true,
	["modifier_broodmother_poison_sting_dps_debuff"] = true,
	["modifier_lone_druid_spirit_bear_entangle_effect"] = true,
	["modifier_brewmaster_storm_cyclone"] = true,
	["modifier_undying_tombstone_zombie_deathlust"] = true,
	["modifier_gnoll_assassin_envenomed_weapon_poison"] = true,
	["modifier_item_ethereal_blade_ethereal"] = true,
	["modifier_item_ethereal_blade_slow"] = true,
	["modifier_cyclone"] = true,
	["modifier_item_medallion_of_courage_armor_reduction"] = true,
	["modifier_item_orb_of_venom_slow"] = true,
	["modifier_rod_of_atos_debuff"] = true,
	["modifier_item_imba_shivas_blast_slow"] = true,
	["modifier_item_solar_crest_armor_reduction"] = true}

	if vanilla_debuffs[modifier_name] then
		return true
	end

	return false
end

-- Finds units only on the outer layer of a ring
function FindUnitsInRing(teamNumber, position, cacheUnit, ring_radius, ring_width, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	-- First checks all of the units in a radius
	local all_units	= FindUnitsInRadius(teamNumber, position, cacheUnit, ring_radius, teamFilter, typeFilter, flagFilter, order, canGrowCache)
	
	-- Then builds a table composed of the units that are in the outer ring, but not in the inner one.
	local outer_ring_units	=	{}

	for _,unit in pairs(all_units) do
		-- Custom function, checks if the unit is far enough away from the inner radius
		if CalculateDistance(unit:GetAbsOrigin(), position) >= ring_radius - ring_width then
			table.insert(outer_ring_units, unit)
		end
	end

	return outer_ring_units
end

-- Cleave-like cone search - returns the units in front of the caster in a cone.
function FindUnitsInCone(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local vDirectionCone = Vector( vDirection.y, -vDirection.x, 0.0 )
	local enemies = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, endRadius + flLength, targetTeam, targetUnit, targetFlags, findOrder, bCache )
	local unitTable = {}
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil then
				local vToPotentialTarget = enemy:GetOrigin() - vPosition
				local flSideAmount = math.abs( vToPotentialTarget.x * vDirectionCone.x + vToPotentialTarget.y * vDirectionCone.y + vToPotentialTarget.z * vDirectionCone.z )
				local enemy_distance_from_caster = ( vToPotentialTarget.x * vDirection.x + vToPotentialTarget.y * vDirection.y + vToPotentialTarget.z * vDirection.z )
				
				-- Author of this "increase over distance": Fudge, pretty proud of this :D 
				
				-- Calculate how much the width of the check can be higher than the starting point
				local max_increased_radius_from_distance = endRadius - startRadius
				
				-- Calculate how close the enemy is to the caster, in comparison to the total distance
				local pct_distance = enemy_distance_from_caster / flLength
				
				-- Calculate how much the width should be higher due to the distance of the enemy to the caster.
				local radius_increase_from_distance = max_increased_radius_from_distance * pct_distance
				
				if ( flSideAmount < startRadius + radius_increase_from_distance ) and ( enemy_distance_from_caster > 0.0 ) and ( enemy_distance_from_caster < flLength ) then
					table.insert(unitTable, enemy)
				end
			end
		end
	end
	return unitTable
end

function CalculateDirection(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	return direction
end

-- Thanks to LoD-Redux & darklord for this!
function DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

-- TODO: FORMAT THIS SHIT
function ReconnectPlayer(player_id)
	if not player_id then player_id = 0 end
	if player_id == "test_reconnect" then player_id = 0 end

--	print("Player is reconnecting:", player_id)

	-- Reinitialize the player's pick screen panorama, if necessary
	Timers:CreateTimer(1.0, function()
--		print(PlayerResource:GetSelectedHeroEntity(player_id))
			if PlayerResource:GetSelectedHeroEntity(player_id) then
				CustomGameEventManager:Send_ServerToAllClients("player_reconnected", {PlayerID = player_id, PickedHeroes = HeroSelection.picked_heroes, pickState = pick_state, repickState = repick_state})

--			Timers:CreateTimer(3.0, function()
--				local table = {
--					ID = player_id,
--					team = PlayerResource:GetTeam(player_id),
--					disconnect = 2,
--				}

--				print("Decrease GG Amount!")
--				GameMode:GG(table)
--			end)

				local hero = PlayerResource:GetSelectedHeroEntity(player_id)

--			print(hero:GetUnitName())

--			if GameRules:IsCheatMode() then
--				Notifications:TopToAll({text = "Player "..player_id.. " has reconnected with hero: "..hero:GetUnitName(), duration = 10.0, style = {color = "DodgerBlue"}})
--			end

--				print(PICKING_SCREEN_OVER)
--			if GameRules:IsCheatMode() then
--				if PICKING_SCREEN_OVER then
--					Notifications:TopToAll({text = "Pick Screen is over!", duration = 10.0, style = {color = "DodgerBlue"}})
--				else
--					Notifications:TopToAll({text = "Pick Screen is not over yet!", duration = 10.0, style = {color = "DodgerBlue"}})
--				end
--			end

				if PICKING_SCREEN_OVER == true then
					if hero:GetUnitName() == FORCE_PICKED_HERO then
--				if not lockedHeroes[player_id] or hero:GetUnitName() == FORCE_PICKED_HERO then
						-- we don't care if they haven't locked in yet
--					if GameRules:IsCheatMode() then
--						Notifications:TopToAll({text = "Player "..player_id.. ": NO HERO LOCKED IN, RANDOM A HERO!", duration = 10.0, style = {color = "DodgerBlue"}})
--					end

						print('Giving player ' .. player_id .. ' a random hero! (reconnected)')
--					if GameRules:IsCheatMode() then
--						Notifications:TopToAll({text = 'Giving player ' .. player_id .. ' a random hero: '..HeroSelection:RandomHero()..' (reconnected)', duration = 10.0, style = {color = "DodgerBlue"}})
--					end

						local random_hero = HeroSelection:RandomHero()
						print("Random Hero:", random_hero)
						HeroSelection:GiveStartingHero(player_id, random_hero, true)
					else
--					print('Reconnecting... ' .. hero .. ' ' .. loadedHeroes[lockedHeroes[player_id]])
--					print(loadedHeroes)
--					if GameRules:IsCheatMode() then
--						Notifications:TopToAll({text = 'Reconnecting... ' .. hero .. ' ' .. loadedHeroes[lockedHeroes[player_id]], duration = 10.0, style = {color = "DodgerBlue"}})
--					end
--					if not hero or hero:GetUnitName() == FORCE_PICKED_HERO and loadedHeroes[lockedHeroes[player_id]] then
--						if GameRules:IsCheatMode() then
--							Notifications:TopToAll({text = 'Giving player ' .. player_id .. ' ' .. lockedHeroes[player_id] .. '(reconnected)', duration = 10.0, style = {color = "DodgerBlue"}})
--						end
--						print('Giving player ' .. player_id .. ' ' .. lockedHeroes[player_id] .. '(reconnected)')
--						HeroSelection:GiveStartingHero(player_id, lockedHeroes[player_id])
--					end
					end

					if IsMutationMap() then
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "send_mutations", IMBA_MUTATION)
					end
				end
			else
--			print("Not fully reconnected yet:", player_id)
				return 0.1
			end

			if GetMapName() == "imba_overthrow" then
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = true})
			else
				CustomGameEventManager:Send_ServerToAllClients("imbathrow_topbar", {imbathrow = false})
			end
		end)

	-- If this is a reconnect from abandonment due to a long disconnect, remove the abandon state
	if PlayerResource:GetHasAbandonedDueToLongDisconnect(player_id) then
		local player_name = PlayerResource:GetPlayerName(player_id)
		local hero = PlayerResource:GetPlayer(player_id):GetAssignedHero()
		local hero_name = hero:GetUnitName()
		local line_duration = 7
		Notifications:BottomToAll({hero = hero_name, duration = line_duration})
		Notifications:BottomToAll({text = player_name.." ", duration = line_duration, continue = true})
		Notifications:BottomToAll({text = "#imba_player_reconnect_message", duration = line_duration, style = {color = "DodgerBlue"}, continue = true})

		-- Stop redistributing gold to allies, if applicable
		PlayerResource:StopAbandonGoldRedistribution(player_id)
	end
end

-- Turns a table of entity handles into entindex string separated by commas.
function TableToStringCommaEnt(table)	
	local string = ""
	local first_value = true

	for _,handle in pairs(table) do
		if first_value then
			string = string..tostring(handle:entindex())	
			first_value = false
		else
			string = string..","
			string = string..tostring(handle:entindex())	
		end		
	end

	return string
end

-- Turns an entindex string into a table and returns a table of handles.
-- Separator can only be a space (" ") or a comma (",").
function StringToTableEnt(string, separator)
	local gmatch_sign

	if separator == " " then
		gmatch_sign = "%S+"
	elseif separator == "," then
		gmatch_sign = "([^,]+)"
	end

	local return_table = {}
	for str in string.gmatch(string, gmatch_sign) do 		
		local handle = EntIndexToHScript(tonumber(str))
		table.insert(return_table, handle)
	end	

	return return_table
end

function StoreCurrentDayCycle()	
	Timers:CreateTimer(function()		
		-- Get current daytime cycle
		local is_day = GameRules:IsDaytime()		

		-- Set in the table
		CustomNetTables:SetTableValue("game_options", "isdaytime", {is_day = is_day} )		

		-- Repeat
		return 0.5
	end)	
end

function IsDaytime()
	if CustomNetTables:GetTableValue("game_options", "isdaytime") then
		if CustomNetTables:GetTableValue("game_options", "isdaytime").is_day then  
			local is_day = CustomNetTables:GetTableValue("game_options", "isdaytime").is_day  

			if is_day == 1 then
				return true
			else
				return false
			end
		end
	end

	return true   
end

function SetupShrines()
	local good_fillers = {
		"good_filler_1",
		"good_filler_3",
		"good_filler_5",
	}

	local bad_fillers = {
		"bad_filler_1",
		"bad_filler_3",
		"bad_filler_5",
	}

	for _, ent_name in pairs(good_fillers) do
		local filler = Entities:FindByName(nil, ent_name)
		local abs = filler:GetAbsOrigin()
		filler:RemoveSelf()
		local shrine = CreateUnitByName("npc_dota_goodguys_healers", abs, true, nil, nil, 2)
		shrine:SetAbsOrigin(abs)
	end

	for _, ent_name in pairs(bad_fillers) do
		local filler = Entities:FindByName(nil, ent_name)
		local abs = filler:GetAbsOrigin()
		filler:RemoveSelf()
		local shrine = CreateUnitByName("npc_dota_badguys_healers", abs, true, nil, nil, 3)
		shrine:SetAbsOrigin(abs)
	end
end
