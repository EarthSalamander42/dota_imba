--[[
	Author: Hewdraw
]]

function PoisonTouchStun( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local ability_level = ability:GetLevel() - 1
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local should_stun = ability:GetLevelSpecialValueFor(keys.Slow, ability_level)

	if should_stun == 0 then
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
	end
end

function ShallowGravePassive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_passive = keys.modifier_passive
	local modifier_cooldown = keys.modifier_cooldown
	local scepter = caster:HasScepter()

	if scepter and not caster:HasModifier(modifier_cooldown) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_passive, {})
	else
		caster:RemoveModifierByName(modifier_passive)
	end
end

function ShallowGraveDamageCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_grave = keys.modifier_grave
	local modifier_passive = keys.modifier_passive
	local modifier_cooldown = keys.modifier_cooldown

	local health = caster:GetHealth()

	if health == 1 and not caster:HasModifier(modifier_grave) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_grave, {})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, {})
		caster:RemoveModifierByName(modifier_passive)
	end
end

function ShallowGraveDamageStorage( keys )
	local caster = keys.caster
	local unit = keys.unit
	local ability = keys.ability

	local health = caster:GetHealth()
	local damage = keys.DamageTaken

	local newHealth = health - damage
	local damageStored = 1 - newHealth

	-- creates unit.grave_damage if it doesn't exist
	if not unit.grave_damage then
		unit.grave_damage = 0
	end

	if newHealth < 1 then
		unit.grave_damage = unit.grave_damage + damageStored
	end
end

function ShallowGraveHeal( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability

	-- create unit.grave_damage if it doesn't exist
	if not unit.grave_damage then
		unit.grave_damage = 0
	end

	-- heal the target after shallow grave ends
	unit:Heal(unit.grave_damage, caster)
	unit.grave_damage = nil
end

function ShadowWave( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local armor_bonus = keys.armor_bonus
	local armor_reduction = keys.armor_reduction

	-- Ability variables
	local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local heal = damage

	-- Particles
	local shadow_wave_particle = keys.shadow_wave_particle
	local shadow_wave_damage_particle = keys.damage_particle

	-- Setting up the damage and hit tables
	local hit_table = {}
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.damage = damage

	-- If the target is not the caster then do the extra bounce for the caster
	if target ~= caster then
		-- Insert the caster into the hit table
		table.insert(hit_table, caster)
		-- Heal the caster and do damage to the units around it
		ability:ApplyDataDrivenModifier(caster, caster, armor_bonus, {})
		caster:Heal(heal, caster)

		local units_to_damage = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

		for _,v in pairs(units_to_damage) do
			AddStacks(ability, caster, v, armor_reduction, 1, true)
			damage_table.victim = v
			ApplyDamage(damage_table)

			-- Play the particle
			local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(damage_particle)
		end
	end

	-- Mark the target as already hit
	table.insert(hit_table, target)
	-- Heal the initial target and do the damage to the units around it
	ability:ApplyDataDrivenModifier(caster, target, armor_bonus, {})
	target:Heal(heal, caster)

	local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

	for _,v in pairs(units_to_damage) do
		AddStacks(ability, caster, v, armor_reduction, 1, true)
		damage_table.victim = v
		ApplyDamage(damage_table)

		-- Play the particle
		local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(damage_particle)
	end

	-- we start from 2 first because we healed 1 target already
	for i = 2, max_targets do

		-- Find all units in bounce radius
		local units = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, 0, FIND_CLOSEST, false)
		
		for _,unit in pairs(units) do
			local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

			-- Checking the hit table to see if the unit is hit
			for c = 0, #hit_table do
				if hit_table[c] == unit then
					check_unit = 1
				end
			end

			-- If its not hit then bounce the wave to it
			if check_unit == 0 then
				-- After we find the next unit to heal then we insert it into the hit table to keep track of it
				-- and we also get the unit position
				table.insert(hit_table, unit)
				local unit_location = unit:GetAbsOrigin()

				-- Create the particle for the visual effect
				local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
				ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

				-- Set the unit as the new target
				target = unit
				target_location = unit_location

				-- Heal it and deal damage to enemy units around it
				ability:ApplyDataDrivenModifier(caster, target, armor_bonus, {})
				target:Heal(heal, caster)
				local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

				for _,v in pairs(units_to_damage) do
					AddStacks(ability, caster, v, armor_reduction, 1, true)
					damage_table.victim = v
					ApplyDamage(damage_table)

					-- Play the particle
					local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(damage_particle)
				end

				-- Exit the loop for checking the next affected unit
				break
			end
		end
	end
end

function WeaveVision( keys )
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local vision_radius = ability:GetLevelSpecialValueFor("vision", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	ability:CreateVisibilityNode(target_point, vision_radius, vision_duration)
end

function Weave( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = caster:HasScepter()

	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- Finds allies and enemies to affect
	local enemies = FindUnitsInRadius(caster.GetTeam(caster), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local allies = FindUnitsInRadius(caster.GetTeam(caster), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- If Dazzle has Aghanim's Scepter, includes mechanical units and buildings
	if scepter then
		enemies = FindUnitsInRadius(caster.GetTeam(caster), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		allies = FindUnitsInRadius(caster.GetTeam(caster), target_point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	end

	-- Applies the buff/debuff
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_imba_weave_enemy", {})
	end
	for _,ally in pairs(allies) do
		ability:ApplyDataDrivenModifier(caster, ally, "modifier_imba_weave_friendly", {})
	end	
end

function WeaveInterval( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local scepter = caster:HasScepter()

	if scepter then
		if caster:GetTeam() == target:GetTeam() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_imba_weave_positive_scepter", {})
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_imba_weave_negative_scepter", {})
		end
	else
		if caster:GetTeam() == target:GetTeam() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_imba_weave_positive", {})
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_imba_weave_negative", {})
		end
	end
end

function WeaveRemoveBuff( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local modifier_scepter = keys.modifier_scepter

	-- Modifier variables
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local tick_interval = ability:GetLevelSpecialValueFor("tick_interval", ability_level)

	-- Calculating how many modifiers we have to remove
	local modifiers_to_remove = duration / tick_interval

	-- Removing the modifiers
	for i = 1, modifiers_to_remove do
		target:RemoveModifierByNameAndCaster(modifier, caster)
		target:RemoveModifierByNameAndCaster(modifier_scepter, caster)
	end
end

function WeaveParticle( keys )
	local target = keys.target
	local location = target:GetAbsOrigin()
	local particleName = keys.particle_name
	local modifier = keys.modifier

	-- If the target was not affected by Weave previously, apply the particle
	if target.WeaveParticle == nil then 
		target.WeaveParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.WeaveParticle, 0, location)
		ParticleManager:SetParticleControl(target.WeaveParticle, 1, location)
		ParticleManager:SetParticleControlEnt(target.WeaveParticle, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", location, true)
	end
end

-- Destroys the particle when the modifier is destroyed, only when the target doesnt have the modifier
function EndWeaveParticle( keys )
	local target = keys.target
	local particleName = keys.particle_name
	local modifier = keys.modifier

	if not target:HasModifier(modifier) then
		ParticleManager:DestroyParticle(target.WeaveParticle,false)
	end
end