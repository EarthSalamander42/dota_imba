-------------------------------------------------------------------------------------------------
-- IMBA: custom utility functions
-------------------------------------------------------------------------------------------------

-- Adds [stack_amount] stacks to a modifier
function AddStacks(ability, caster, unit, modifier, stack_amount, refresh)
	if unit:HasModifier(modifier) then
		if refresh then
			ability:ApplyDataDrivenModifier(caster, unit, modifier, {})
		end
		unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, nil) + stack_amount)
	else
		ability:ApplyDataDrivenModifier(caster, unit, modifier, {})
		unit:SetModifierStackCount(modifier, ability, stack_amount)
	end
end

-- Adds [stack_amount] stacks to a lua-based modifier
function AddStacksLua(ability, caster, unit, modifier, stack_amount, refresh)
	if unit:HasModifier(modifier) then
		if refresh then
			unit:AddNewModifier(caster, ability, modifier, {})
		end
		unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, nil) + stack_amount)
	else
		unit:AddNewModifier(caster, ability, modifier, {})
		unit:SetModifierStackCount(modifier, ability, stack_amount)
	end
end

-- Removes [stack_amount] stacks from a modifier, and deleted it if it is depleted
function CDOTA_Buff:RemoveStacks(stack_amount)
	local current_stacks = self:GetStackCount()
	if stack_amount >= current_stacks then
		self:Destroy()
	else
		self:SetStackCount(current_stacks-stack_amount)
	end
end

-- Switches one skill with another
function SwitchAbilities(hero, added_ability_name, removed_ability_name, keep_level, keep_cooldown)
	local removed_ability = hero:FindAbilityByName(removed_ability_name)
	local level = removed_ability:GetLevel()
	local cooldown = removed_ability:GetCooldownTimeRemaining()
	hero:RemoveAbility(removed_ability_name)
	hero:AddAbility(added_ability_name)
	local added_ability = hero:FindAbilityByName(added_ability_name)
	
	if keep_level then
		added_ability:SetLevel(level)
	end
	
	if keep_cooldown then
		added_ability:StartCooldown(cooldown)
	end
end


--[[ ============================================================================================================
	Author: Rook
	Date: February 3, 2015
	A helper method that switches the removed_item item to one with the inputted name.
================================================================================================================= ]]
function SwapToItem(caster, removed_item, added_item)
	for i=0, 5, 1 do  --Fill all empty slots in the player's inventory with "dummy" items.
		local current_item = caster:GetItemInSlot(i)
		if current_item == nil then
			caster:AddItem(CreateItem("item_imba_dummy", caster, caster))
		end
	end
	
	caster:RemoveItem(removed_item)
	caster:AddItem(CreateItem(added_item, caster, caster))  --This should be put into the same slot that the removed item was in.
	
	for i=0, 5, 1 do  --Remove all dummy items from the player's inventory.
		local current_item = caster:GetItemInSlot(i)
		if current_item ~= nil then
			if current_item:GetName() == "item_imba_dummy" then
				caster:RemoveItem(current_item)
			end
		end
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
	if not ( target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_reincarnation_scepter") ) then
		target:Kill(ability, caster)
	end

	-- Removes the relevant modifiers
	target:RemoveModifierByName("modifier_invulnerable")
	target:RemoveModifierByName("modifier_imba_dazzle_shallow_grave")
	target:RemoveModifierByName("modifier_aphotic_shield")
	target:RemoveModifierByName("modifier_imba_spiked_carapace")
	target:RemoveModifierByName("modifier_borrowed_time")
	target:RemoveModifierByName("modifier_imba_centaur_return")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_active")
	target:RemoveModifierByName("modifier_item_crimson_guard_unique")
	target:RemoveModifierByName("modifier_item_crimson_guard_active")
	target:RemoveModifierByName("modifier_item_greatwyrm_plate_unique")
	target:RemoveModifierByName("modifier_item_vanguard_unique")
	target:RemoveModifierByName("modifier_item_imba_initiate_robe_stacks")
	target:RemoveModifierByName("modifier_imba_cheese_death_prevention")
	target:RemoveModifierByName("modifier_imba_reincarnation_wraith_form")

	-- Kills the target
	target:Kill(ability, caster)
end

-- Checks if a given unit is Roshan
function IsRoshan(unit)
	if unit:GetName() == "npc_imba_roshan" or unit:GetName() == "npc_dota_roshan" then
		return true
	else
		return false
	end
end

-- Checks if a unit is near units of a certain class not on its team
function IsNearEnemyClass(unit, radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, unit:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() ~= unit:GetTeam() then
			return true
		end
	end
	
	return false
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

-- Returns if this unit is a fountain or not
function IsFountain( unit )
	if unit:GetName() == "ent_dota_fountain_bad" or unit:GetName() == "ent_dota_fountain_good" then
		return true
	end
	
	return false
end

function CDOTABaseAbility:GetTrueCooldown()
	local cooldown = self:GetCooldown(-1)
	local cdr = self:GetCaster():GetCooldownReduction()
	cooldown = cooldown * cdr
	return cooldown
end

-- Check if an unit is near the enemy fountain
function IsNearEnemyFountain(location, team, distance)

	local fountain_loc
	if team == DOTA_TEAM_GOODGUYS then
		fountain_loc = Vector(7472, 6912, 512)
	else
		fountain_loc = Vector(-7456, -6938, 528)
	end

	if (fountain_loc - location):Length2D() <= distance then
		return true
	end

	return false
end

-- Sets level of the ability with [ability_name] to [level] for [caster] if the caster has this ability
function SetAbilityLevelIfPresent(caster, ability_name, level)
	local ability = caster:FindAbilityByName(ability_name)
	if ability then
		ability:SetLevel(level)
	end
end

-- Refreshes ability with [ability_name] for [caster] if the caster has this ability
function RefreshAbilityIfPresent(caster, ability_name)
	local ability = caster:FindAbilityByName(ability_name)
	if ability then
		ability:EndCooldown()
	end
end

-- Returns true if a hero has red hair
function IsGinger(unit)

	local ginger_hero_names = {
		"npc_dota_hero_enchantress",
		"npc_dota_hero_lina",
		"npc_dota_hero_windrunner"
	}

	local unit_name = unit:GetName()
	for _,name in pairs(ginger_hero_names) do
		if name == unit_name then
			return true
		end
	end
	
	return false
end

function RemoveWearables( hero )

	-- Setup variables
	Timers:CreateTimer(0.1, function()
		hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
		local model = hero:FirstMoveChild()
		while model ~= nil do
			if model:GetClassname() == "dota_item_wearable" then
				model:AddEffects(EF_NODRAW) -- Set model hidden
				table.insert(hero.hiddenWearables, model)
			end
			model = model:NextMovePeer()
		end
	end)
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
	v:RemoveEffects(EF_NODRAW)
  end
end

-- Get the base projectile of a unit
function GetBaseRangedProjectileName( unit )
	local unit_name = unit:GetUnitName()
	unit_name = string.gsub(unit_name, "dota", "imba")
	local unit_table = unit:IsHero() and GameRules.HeroKV[unit_name] or GameRules.UnitKV[unit_name]
	return unit_table and unit_table["ProjectileModel"] or ""
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
		unit:SetRangedProjectileName(GetBaseRangedProjectileName(unit))
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

function CDOTA_BaseNPC:GetBonusDamage(tEntity)
  return tEntity:GetAverageTrueAttackDamage(tEntity) - ( tEntity:GetBaseDamageMin()  + tEntity:GetBaseDamageMax() ) / 2 
end

-- Detect hero-creeps with an inventory, like warlock golems or lone druid's bear
function IsHeroCreep( unit )

	if unit:GetName() == "npc_dota_lone_druid_bear" then
		return true
	end

	return false
end

-- Initializes a charge-based system for an ability
function InitializeAbilityCharges(unit, ability_name, max_charges, initial_charges, cooldown, modifier_name)

	-- Find the passed ability
	local ability = unit:FindAbilityByName(ability_name)

	-- Procees only if the relevant ability was found
	if ability then

		local extra_parameters = {
			max_count = max_charges,
			start_count = initial_charges,
			replenish_time = cooldown
		}

		unit:AddNewModifier(unit, ability, "modifier_charges_"..modifier_name, extra_parameters)
	end
end

-- Safely modify BAT while storing the unit's original value
function ModifyBAT(unit, modify_percent, modify_flat)

	-- Fetch base BAT if necessary
	if not unit.unmodified_bat then
		unit.unmodified_bat = unit:GetBaseAttackTime()
	end

	-- Create the current BAT variable if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit.unmodified_bat
	end

	-- Create the percent modifier variable if necessary
	if not unit.percent_bat_modifier then
		unit.percent_bat_modifier = 1
	end

	-- Create the flat modifier variable if necessary
	if not unit.flat_bat_modifier then
		unit.flat_bat_modifier = 0
	end

	-- Update BAT percent modifiers
	unit.percent_bat_modifier = unit.percent_bat_modifier * (100 + modify_percent) / 100

	-- Update BAT flat modifiers
	unit.flat_bat_modifier = unit.flat_bat_modifier + modify_flat

	-- Unmodified BAT special exceptions
	if unit:GetUnitName() == "npc_dota_hero_alchemist" then
		return nil
	end
	
	-- Update modifier BAT
	unit.current_modified_bat = (unit.unmodified_bat + unit.flat_bat_modifier) * unit.percent_bat_modifier

	-- Update unit's BAT
	unit:SetBaseAttackTime(unit.current_modified_bat)

end

-- Override all BAT modifiers and return the unit to its base value
function RevertBAT( unit )

	-- Fetch base BAT if necessary
	if not unit.unmodified_bat then
		unit.unmodified_bat = unit:GetBaseAttackTime()
	end

	-- Create the current BAT variable if necessary
	if not unit.current_modified_bat then
		unit.current_modified_bat = unit.unmodified_bat
	end

	-- Create the percent modifier variable if necessary
	if not unit.percent_bat_modifier then
		unit.percent_bat_modifier = 1
	end

	-- Create the flat modifier variable if necessary
	if not unit.flat_bat_modifier then
		unit.flat_bat_modifier = 0
	end

	-- Reset variables
	unit.percent_bat_modifier = 1
	unit.flat_bat_modifier = 0

	-- Reset BAT
	unit:SetBaseAttackTime(unit.unmodified_bat)

end

-- Returns an unit's existing increased cast range modifiers
function GetCastRangeIncrease( unit )
	local cast_range_increase = 0
	-- Only the greatest increase counts for items, they do not stack
	for _, parent_modifier in pairs(unit:FindAllModifiers()) do
		-- Vanguard-based damage reduction does not stack
		if parent_modifier.GetModifierCastRangeBonus then
			cast_range_increase = math.max(cast_range_increase,parent_modifier:GetModifierCastRangeBonus())
		end
	end

	-- From talents
	for talent_name,cast_range_bonus in pairs(CAST_RANGE_TALENTS) do
		if unit:FindAbilityByName(talent_name) and unit:FindAbilityByName(talent_name):GetLevel() > 0 then
			cast_range_increase = cast_range_increase + cast_range_bonus
		end
	end

	return cast_range_increase
end

-- Talent handling
function CDOTA_BaseNPC:HasTalent(talentName)
	if self:HasAbility(talentName) then
		if self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
	end
	return false
end

function CDOTA_BaseNPC:FindTalentValue(talentName)
	if self:HasAbility(talentName) then
		return self:FindAbilityByName(talentName):GetSpecialValueFor("value")
	end
	return 0
end

function CDOTA_BaseNPC:FindSpecificTalentValue(talentName, valname)
	if self:HasAbility(talentName) then
		return self:FindAbilityByName(talentName):GetSpecialValueFor(valname)
	end
	return 0
end

function CDOTA_BaseNPC:HighestTalentTypeValue(talentType)
	local value = 0
	for i = 0, 23 do
		local talent = self:GetAbilityByIndex(i)
		if talent and string.match(talent:GetName(), "special_bonus_"..talentType.."_(%d+)") and self:FindTalentValue(talent:GetName()) > value then
			value = self:FindTalentValue(talent:GetName())
		end
	end
	return value
end

function CDOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = self:GetAbilityKeyValues()
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName then 
		local talent = self:GetCaster():FindAbilityByName(talentName)
		if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
	end
	return base
end

function CreateEmptyTalents(hero)
	for i=1,8 do
		LinkLuaModifier("modifier_special_bonus_imba_"..hero.."_"..i, "hero/hero_"..hero, LUA_MODIFIER_MOTION_NONE)  
		local class = "modifier_special_bonus_imba_"..hero.."_"..i.." = class({IsHidden = function(self) return true end, RemoveOnDeath = function(self) return false end, AllowIllusionDuplicate = function(self) return true end})"  
		load(class)()
	end
end

function findtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorTarget()
	local c = source:GetCaster()
	if t and c then return t,c end
end

function findgroundtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorPosition()
	local c = source:GetCaster()
	if t and c then return t,c end
end

----------------------------------------------------------------
-- "Custom" modifier value fetching
----------------------------------------------------------------

-- Spell lifesteal
function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierSpellLifesteal()
		end
	end
	return lifesteal
end

-- Autoattack lifesteal
function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end
	return lifesteal
end

-- Health regeneration % amplification
function CDOTA_BaseNPC:GetHealthRegenAmp()
	local regen_increase = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierHealthRegenAmp then
			regen_increase = regen_increase + parent_modifier:GetModifierHealthRegenAmp()
		end
	end
	return regen_increase
end

-- Spell power
function CDOTA_BaseNPC:GetSpellPower()

	-- If this is not a hero, or the unit is invulnerable, do nothing
	if not self:IsHero() or self:IsInvulnerable() then
		return 0
	end

	-- Adjust base spell power based on current intelligence
	local spell_power = self:GetIntellect() / 14

	-- Mega Treads increase spell power from intelligence by 30%
	if self:HasModifier("modifier_imba_mega_treads_stat_multiplier_02") then
		spell_power = self:GetIntellect() * 0.093
	end

	-- Fetch spell power from modifiers
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellAmplify_Percentage then
			spell_power = spell_power + parent_modifier:GetModifierSpellAmplify_Percentage()
		end
	end

	-- Return current spell power
	return spell_power
end

-- Cooldown reduction
function CDOTA_BaseNPC:GetCooldownReduction()

	-- If this is not a hero, do nothing
	if not self:IsRealHero() then
		return 0
	end

	-- Fetch cooldown reduction from modifiers
	local cooldown_reduction = 0
	local nonstacking_reduction = 0
	local stacking_reduction = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Nonstacking reduction
		if parent_modifier.GetCustomCooldownReduction then
			nonstacking_reduction = math.max(nonstacking_reduction, parent_modifier:GetCustomCooldownReduction())
		end

		-- Stacking reduction
		if parent_modifier.GetCustomCooldownReductionStacking then
			stacking_reduction = 100 - (100 - stacking_reduction) * (100 - parent_modifier:GetCustomCooldownReductionStacking()) * 0.01
		end
	end

	-- Calculate actual cooldown reduction
	cooldown_reduction = 100 - (100 - nonstacking_reduction) * (100 - stacking_reduction) * 0.01

	-- Frantic mode adjustment (70% CDR)
	if IMBA_FRANTIC_MODE_ON then
		cooldown_reduction = 100 - (100 - cooldown_reduction) * 30 * 0.01
	end

	-- Return current cooldown reduction
	return cooldown_reduction
end

-- Respawn timer modifier
function CDOTA_BaseNPC:GetRespawnTimeModifier()

	-- If this is not a hero, do nothing
	local respawn_modifier = 0
	if not self:IsRealHero() then
		return respawn_modifier
	end

	-- Fetch respawn time modifications from modifiers
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.RespawnTimeStacking then
			respawn_modifier = respawn_modifier + parent_modifier:RespawnTimeStacking()
		end
	end

	-- Calculate respawn timer reduction due to vanilla talents
	local respawn_reduction_talents = {}
	respawn_reduction_talents["special_bonus_respawn_reduction_15"] = 9
	respawn_reduction_talents["special_bonus_respawn_reduction_20"] = 12
	respawn_reduction_talents["special_bonus_respawn_reduction_25"] = 15
	respawn_reduction_talents["special_bonus_respawn_reduction_30"] = 18
	respawn_reduction_talents["special_bonus_respawn_reduction_35"] = 20
	respawn_reduction_talents["special_bonus_respawn_reduction_40"] = 25
	respawn_reduction_talents["special_bonus_respawn_reduction_50"] = 30
	respawn_reduction_talents["special_bonus_respawn_reduction_60"] = 40

	for talent_name, respawn_reduction_bonus in pairs(respawn_reduction_talents) do
		if self:FindAbilityByName(talent_name) and self:FindAbilityByName(talent_name):GetLevel() > 0 then
			respawn_modifier = respawn_modifier - respawn_reduction_bonus
		end
	end

	-- Return current respawn time modifier
	return respawn_modifier
end

function CDOTA_BaseNPC:GetRespawnTimeModifier_Pct()

	-- If this is not a hero, do nothing
	local multiplicator_pct = 100
	if not self:IsRealHero() then
		return multiplicator_pct
	end

	-- Fetch respawn time modifications from modifiers
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.RespawnTimeStacking_Pct then
			multiplicator_pct = 100 - (100 - multiplicator_pct) * (100 - parent_modifier:RespawnTimeStacking_Pct()) * 0.01
		end
	end
	
	-- Return current respawn time modifier
	return multiplicator_pct
end

-- Calculate physical damage post reduction
function CDOTA_BaseNPC:GetPhysicalArmorReduction()
	local armornpc = self:GetPhysicalArmorValue()
	local armor_reduction = 1 - (0.06 * armornpc) / (1 + (0.06 * math.abs(armornpc)))
	armor_reduction = 100 - (armor_reduction * 100)
	return armor_reduction
end

function GetReductionFromArmor(armor)
	local m = 0.06 * armor
	return 100 * (1 - m/(1+math.abs(m)))
end

function CalculateReductionFromArmor_Percentage(armorOffset, armor)
	return -GetReductionFromArmor(armor) + GetReductionFromArmor(armorOffset)
end

-- Physical damage block
function CDOTA_BaseNPC:GetDamageBlock()

	-- Fetch damage block from custom modifiers
	local damage_block = 0
	local unique_damage_block = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Vanguard-based damage block does not stack
		if parent_modifier.GetCustomDamageBlockUnique then
			unique_damage_block = math.max(unique_damage_block, parent_modifier:GetCustomDamageBlockUnique())
		end

		-- Stack all other sources of damage block
		if parent_modifier.GetCustomDamageBlock then
			damage_block = damage_block + parent_modifier:GetCustomDamageBlock()
		end
	end

	-- Calculate total damage block
	damage_block = damage_block + unique_damage_block

	-- Ranged attackers only benefit from part of the damage block
	if self:IsRangedAttacker() then
		return 0.6 * damage_block
	else
		return damage_block
	end
end

-- if isDegree = true, entered angle is degree, else radians
function RotateVector2D(v,angle,isDegree)
	if isDegree then angle = math.rad(angle) end
	local xp = v.x * math.cos(angle) - v.y * math.sin(angle)
	local yp = v.x * math.sin(angle) + v.y * math.cos(angle)
	return Vector(xp,yp,v.z):Normalized()
end

-- Universal damage amplification
function CDOTA_BaseNPC:GetIncomingDamagePct()

	-- Fetch damage amp from modifiers
	local damage_amp = 1
	local vanguard_damage_reduction = 1
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Vanguard-based damage reduction does not stack
		if parent_modifier.GetCustomIncomingDamageReductionUnique then
			vanguard_damage_reduction = math.min(vanguard_damage_reduction, (100 - parent_modifier:GetCustomIncomingDamageReductionUnique()) * 0.01)
		end

		-- Stack all other custom sources of damage amp
		if parent_modifier.GetCustomIncomingDamagePct then
			damage_amp = damage_amp * (100 + parent_modifier:GetCustomIncomingDamagePct()) * 0.01
		end
	end

	-- Calculate total damage amp
	damage_amp = damage_amp * vanguard_damage_reduction

	return (damage_amp - 1) * 100
end

-- Tenacity
function CDOTA_BaseNPC:GetTenacity()

	-- Fetch tenacity from modifiers
	local tenacity = 1
	local tenacity_unique = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Tutela Plate's tenacity does not stack with itself
		if parent_modifier.GetCustomTenacityUnique then
			tenacity_unique = math.max(tenacity_unique, parent_modifier:GetCustomTenacityUnique())
		end

		-- Stack all other sources multiplicatively
		if parent_modifier.GetCustomTenacity then
			tenacity = tenacity * (100 - parent_modifier:GetCustomTenacity()) * 0.01
		end
	end

	-- Calculate total tenacity
	tenacity = tenacity * (100 - tenacity_unique) * 0.01

	return (1 - tenacity) * 100
end

-- Safely checks if this unit is a hero or a creep
function IsHeroOrCreep(unit)
	if unit.IsCreep and unit:IsCreep() then
		return true
	elseif unit.IsHero and unit:IsHero() then
		return true
	end
	return false
end

-- Rolls a Psuedo Random chance. If failed, chances increases, otherwise chances are reset
function RollPseudoRandom(base_chance, entity)
	local chances_table = { {5, 0.38},
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
							{70, 57.10}
						  }

	entity.pseudoRandomModifier = entity.pseudoRandomModifier or 0
	local prngBase
	for i = 1, #chances_table do
		if base_chance == chances_table[i][1] then		  
			prngBase = chances_table[i][2]
		end	 
	end

	if not prngBase then
		print("The chance was not found! Make sure to add it to the table or change the value.")
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

function IsDaytime()
	if CustomNetTables:GetTableValue("gamerules", "isdaytime") then
		if CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day then  
			local is_day = CustomNetTables:GetTableValue("gamerules", "isdaytime").is_day  

			if is_day == 1 then
				return true
			else
				return false
			end
		end
	end

	return true   
end

function CalculateDistance(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local distance = (pos1 - pos2):Length2D()
	return distance
end

-- Thanks to LoD-Redux & darklord for this!
function DisplayError(playerID, message)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message=message})
	end
end

-- Carefully, DON'T use this for visible modifiers or with stack-handling!!!!!!!!!
-- This is only needed if the modifier has MODIFIER_ATTRIBUTE_MULTIPLE!
function CDOTA_Modifier_Lua:CheckUnique(bCreated)
	local hParent = self:GetParent()
	if bCreated then
		local mod = hParent:FindAllModifiersByName(self:GetName())
		if #mod >= 2 then
			self:SetStackCount(1)
			return true
		else
			self:SetStackCount(0)
			return false
		end
	else
		if self:GetStackCount() == 0 then
			local mod = hParent:FindModifierByName(self:GetName())
			if mod then
				mod:SetStackCount(0)
			end
		end
		return nil
	end
end

function CDOTA_Modifier_Lua:CheckUniqueValue(value, tSuperiorModifierNames)
	local hParent = self:GetParent()
	if tSuperiorModifierNames then
		for _,sSuperiorMod in pairs(tSuperiorModifierNames) do
			if hParent:HasModifier(sSuperiorMod) then
				return 0
			end
		end
	end
	if bit.band(self:GetAttributes(), MODIFIER_ATTRIBUTE_MULTIPLE) == MODIFIER_ATTRIBUTE_MULTIPLE then
		if self:GetStackCount() == 1 then
			return 0
		end
	end
	return value
end


-- Serversided function only
function CDOTA_BaseNPC:DropRapier(hItem, sNewItemName)
	local vLocation = self:GetAbsOrigin()
	local sName
	local hRapier
	local vRandomVector = RandomVector(100)
	if hItem then
		hRapier = hItem
		sName = hItem:GetName()
		self:DropItemAtPositionImmediate(hRapier, vLocation)
	else
		sName = sNewItemName
		hRapier = CreateItem(sNewItemName, nil, nil)
		CreateItemOnPositionSync(vLocation, hRapier)
	end
	if sName == "item_imba_rapier" then
		hRapier:GetContainer():SetRenderColor(230,240,35)
	elseif sName == "item_imba_rapier_2" then
		hRapier:GetContainer():SetRenderColor(240,150,30)
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_trinity.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_magic" then
		hRapier:GetContainer():SetRenderColor(35,35,240)
	elseif sName == "item_imba_rapier_magic_2" then
		hRapier:GetContainer():SetRenderColor(140,70,220)
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_archmage.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_cursed" then
		hRapier:GetContainer():SetRenderColor(20,160,20)
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_cursed.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
	end
	hRapier:LaunchLoot(false, 250, 0.5, vLocation + vRandomVector)
end

function CDOTA_BaseNPC:AddRangeIndicator(hCaster, hAbility, sAttribute, iRange, iRed, iGreen, iBlue, bShowOnCooldown, bShowAlways, bWithCastRangeIncrease, bRemoveOnDeath)
	local modifier = self:AddNewModifier(hCaster or self,hAbility, "modifier_imba_range_indicator", {
		sAttribute = sAttribute,
		iRange = iRange,
		iRed = iRed,
		iGreen = iGreen,
		iBlue = iBlue,
		bShowOnCooldown = bShowOnCooldown,
		bShowAlways = bShowAlways,
		bWithCastRangeIncrease = bWithCastRangeIncrease,
		bRemoveOnDeath = bRemoveOnDeath
	})
	return modifier
end

function CDOTA_BaseNPC:EmitCasterSound(sCasterName, tSoundNames, fChancePct, flags, fCooldown, sCooldownindex)
	flags = flags or 0
	if self:GetName() ~= sCasterName then
		return true
	end
	
	if fCooldown then
		if self[sCooldownindex] then
			return true
		else
			self[sCooldownindex] = true
			Timers:CreateTimer(fCooldown, function()
				self[sCooldownindex] = nil
			end)
		end
	end
	
	
	if fChancePct then
		if fChancePct <= math.random(1,100) then
			return false -- Only return false if chance was missed
		end
	end
	if (bit.band(flags, DOTA_CAST_SOUND_FLAG_WHILE_DEAD) > 0) or self:IsAlive() then
		local sound = tSoundNames[math.random(1,#tSoundNames)]
		if bit.band(flags, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS) > 0 then
			self:EmitSound(sound)
		--elseif bit.band(flags, DOTA_CAST_SOUND_FLAG_GLOBAL) > 0 then
			-- Iterate through players, added later
		else
			StartSoundEventReliable(sound, self)
		end
	end
	return true
end

function CDOTA_Buff:CopyModifier(source,target)
	for i = 0, source:GetModifierCount() do
		local modifierMame = source:GetModifierNameByIndex(i)
		local modifier = source:FindModifierByName(modifierName)
		if modifier then
			local caster = modifier:GetCaster()
			local ability = modifier:GetAbility()
			local fullDuration = modifier:GetDuration()
			local duration = modifier:GetRemainingTime()
			local stackCount = modifier:GetStackCount()

			local copyModifier = target:AddNewModifier(caster,ability,modifierName,{duration = fullDuration})
			copyModifier:SetDuration(duration,true)
			copyModifier:SetStackCount(stackCount)
			return copyModifier
		end
	end
end

-----------------------------------
--    Talent Helper functions    --
-----------------------------------
function CDOTA_BaseNPC_Hero:CopyTalents(hEntity, flags) --type 1(generic only), 2(unique only), 3(all)
    if (bit.band(flags, DOTA_TALENT_COPY_GENERIC) > 0) then
        local modifierList = self:FindAllModifiers()
        for _,modifier in pairs(modifierList) do
			local modifierName = modifier:GetName()
            -- Check if it is a generic talent
            if IMBA_GENERIC_TALENT_LIST[string.gsub(modifierName,"modifier_", "")] then
                -- Apply to entity
                local newModifier = hEntity:AddNewModifier(hEntity, nil, modifierName, {})
				if newModifier then
                    newModifier:SetStackCount(modifier:GetStackCount())
                    newModifier:ForceRefresh()
                else
                    print("failed to attach generic talent: "..modifierName)
                end
            end
        end
    end

    if (bit.band(flags, DOTA_TALENT_COPY_UNIQUE) > 0) then
        local endAbilityIndex = (self:GetAbilityCount()-1)
        while endAbilityIndex >= 0 do
            local ability = self:GetAbilityByIndex(endAbilityIndex)
            if ability then
                local abilityName = ability:GetName()
                -- Check if it is a unique talent
                if abilityName:find("special_bonus_imba_") == 1 or abilityName:find("special_bonus_unique_") == 1 then
					local newAbility = hEntity:AddAbility(abilityName)
                    if newAbility then
                        newAbility:SetLevel(ability:GetLevel())
                    else
                        print("failed to attach unique talent: "..abilityName)
                    end
                end
            end
            endAbilityIndex = endAbilityIndex - 1
        end
    end
end

function CDOTA_Modifier_Lua:CheckMotionControllers()
	local parent = self:GetParent()
	local modifier_priority = self:GetMotionControllerPriority()
	local is_motion_controller = false
	local motion_controller_priority
	local found_modifier_handler

	local non_imba_motion_controllers =
	{"modifier_brewmaster_storm_cyclone",
	 "modifier_dark_seer_vacuum",
	 "modifier_eul_cyclone",
	 "modifier_earth_spirit_rolling_boulder_caster",
	 "modifier_huskar_life_break_charge",
	 "modifier_invoker_tornado",
	 "modifier_item_forcestaff_active",
	 "modifier_rattletrap_hookshot",
	 "modifier_phoenix_icarus_dive",
	 "modifier_shredder_timber_chain",
	 "modifier_slark_pounce",
	 "modifier_spirit_breaker_charge_of_darkness",
	 "modifier_tusk_walrus_punch_air_time",
	 "modifier_earthshaker_enchant_totem_leap"}
	

	-- Fetch all modifiers
	local modifiers = parent:FindAllModifiers()	

	for _,modifier in pairs(modifiers) do		
		-- Ignore the modifier that is using this function
		if self ~= modifier then			

			-- Check if this modifier is assigned as a motion controller
			if modifier.IsMotionController then
				if modifier:IsMotionController() then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- Get the motion controller priority
					motion_controller_priority = modifier:GetMotionControllerPriority()

					-- Stop iteration					
					break
				end
			end

			-- If not, check on the list
			for _,non_imba_motion_controller in pairs(non_imba_motion_controllers) do				
				if modifier:GetName() == non_imba_motion_controller then
					-- Get its handle
					found_modifier_handler = modifier

					is_motion_controller = true

					-- We assume that vanilla controllers are the highest priority
					motion_controller_priority = DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST

					-- Stop iteration					
					break
				end
			end
		end
	end

	-- If this is a motion controller, check its priority level
	if is_motion_controller and motion_controller_priority then

		-- If the priority of the modifier that was found is higher, override
		if motion_controller_priority > modifier_priority then			
			return false

		-- If they have the same priority levels, check which of them is older and remove it
		elseif motion_controller_priority == modifier_priority then			
			if found_modifier_handler:GetCreationTime() >= self:GetCreationTime() then				
				return false
			else				
				found_modifier_handler:Destroy()
				return true
			end

		-- If the modifier that was found is a lower priority, destroy it instead
		else			
			parent:InterruptMotionControllers(true)
			found_modifier_handler:Destroy()
			return true
		end
	else
		-- If no motion controllers were found, apply
		return true
	end
end

function CDOTA_BaseNPC:SetUnitOnClearGround()
	Timers:CreateTimer(FrameTime(), function()
		self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
		ResolveNPCPositions(self:GetAbsOrigin(), 64)
	end)
end

function CDOTA_BaseNPC:GetFittingColor()
	-- Specially colored item modifiers have priority, in this order
	if self:FindModifierByName("modifier_item_imba_rapier_cursed") then
		return Vector(1,1,1)
	elseif self:FindModifierByName("modifier_item_imba_skadi") then
		return Vector(50,255,255)
	elseif self:FindModifierByName("modifier_item_imba_nether_wand") or self:FindModifierByName("modifier_item_imba_elder_staff") then
		return Vector(0,255,0)
	
	-- Heroes' color is based on attributes
	elseif self:IsHero() then
		local r = self:GetStrength()
		local g = self:GetAgility()
		local b = self:GetIntellect()
		local highest = math.max(r, math.max(g,b))
		r = math.max(255 - (highest - r) * 20, 0)
		g = math.max(255 - (highest - g) * 20, 0)
		b = math.max(255 - (highest - b) * 20, 0)
		return Vector(r,g,b)
	
	-- Other units use the default golden glow
	else
		return Vector(253, 144, 63)
	end
end