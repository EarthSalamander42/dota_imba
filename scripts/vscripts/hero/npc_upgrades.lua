--[[	Author: Firetoad
		Date: 16.08.2015	]]

function Upgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Calculate total buff stacks
	local total_stacks = GAME_TIME_ELAPSED / 60

	-- Increase amount of stacks according to game speed
	total_stacks = math.floor(total_stacks * CREEP_POWER_RAMP_UP_FACTOR)

	-- Cap the stacks
	total_stacks = math.min(total_stacks, 100)

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function FountainBash( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_bash = keys.particle_bash
	local sound_bash = keys.sound_bash

	-- Parameters
	local bash_radius = ability:GetLevelSpecialValueFor("bash_radius", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)
	local bash_distance = ability:GetLevelSpecialValueFor("bash_distance", ability_level)
	local bash_height = ability:GetLevelSpecialValueFor("bash_height", ability_level)
	local fountain_loc = caster:GetAbsOrigin()

	-- Knockback table
	local fountain_bash =	{
		should_stun = 1,
		knockback_duration = bash_duration,
		duration = bash_duration,
		knockback_distance = bash_distance,
		knockback_height = bash_height,
		center_x = fountain_loc.x,
		center_y = fountain_loc.y,
		center_z = fountain_loc.z
	}

	-- Find units to bash
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), fountain_loc, nil, bash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Bash all of them
	for _,enemy in pairs(nearby_enemies) do

		-- Bash
		enemy:RemoveModifierByName("modifier_knockback")
		enemy:AddNewModifier(caster, ability, "modifier_knockback", fountain_bash)

		-- Play particle
		local bash_pfx = ParticleManager:CreateParticle(particle_bash, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(bash_pfx, 0, enemy:GetAbsOrigin())

		-- Play sound
		enemy:EmitSound(sound_bash)
	end
end

function Frantic( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_cd = keys.modifier_cd
	local modifier_mana = keys.modifier_mana

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_cd)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local cd_stacks = 100 - math.floor( 100 / FRANTIC_MULTIPLIER )
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_cd, cd_stacks, true)
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
end

function FranticUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_mana = keys.modifier_mana
	local modifier_dummy = keys.modifier_dummy

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_dummy)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
end