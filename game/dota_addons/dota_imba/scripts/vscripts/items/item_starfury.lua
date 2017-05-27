--[[	Author: d2imba
		Date:	03.10.2015	]]

function Starfury( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_proc = keys.sound_proc
	local sound_split = keys.sound_split
	local particle_proc = keys.particle_proc
	local modifier_dummy = keys.modifier_dummy
	local modifier_buff = keys.modifier_buff

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- If the attacker is an illusion, do nothing
	if caster:IsIllusion() then
		return nil
	end

	-- Roll for proc chance
	if RandomInt(1, 100) <= proc_chance then

		-- Play sound
		caster:EmitSound(sound_proc)

		-- Grant proc buff
		ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, {})
	end

	-- If the ability is on cooldown, stop here
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Iterate through enemies near the target
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Ignore the initial target
		if enemy ~= target then

			-- Star projectile parameters
			local star_projectile = {
				Target = enemy,
				Source = target,
				Ability = ability,
				EffectName = particle_proc,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(star_projectile)
		end
	end

	-- If at least one star was created, play the sound and put the ability on cooldown
	if #nearby_enemies > 1 then
		local cooldown_reduction = (1 - caster:GetCooldownReduction() * 0.01)
		ability:StartCooldown(ability:GetCooldown(ability_level) * cooldown_reduction)
		target:EmitSound(sound_split)
	end
end

function StarfuryHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_dmg_penalty = keys.modifier_dmg_penalty

	-- Attack the target
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dmg_penalty, {})
	if caster:IsRangedAttacker() then
		caster:PerformAttack(target, true, true, true, true, false, false, false)
	else
		local original_loc = caster:GetAbsOrigin()
		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:PerformAttack(target, true, true, true, true, true, false, false)
		caster:SetAbsOrigin(original_loc)
	end
	caster:RemoveModifierByName(modifier_dmg_penalty)
end

function StarfuryBuff( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_buff = keys.modifier_buff

	-- Parameters
	local proc_bonus = ability:GetLevelSpecialValueFor("proc_bonus", ability_level)

	-- Calculate amount of stacks to grant
	local stack_amount = caster:GetAgility() * proc_bonus / 100

	-- Add stacks of the real buff
	AddStacks(ability, caster, caster, modifier_buff, stack_amount, true)
end