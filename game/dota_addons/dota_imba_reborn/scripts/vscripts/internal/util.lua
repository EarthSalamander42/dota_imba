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
			log.info("Cheats have been enabled, game don't count.")
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
		log.warn("The chance was not found! Make sure to add it to the table or change the value.")
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
				return
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
