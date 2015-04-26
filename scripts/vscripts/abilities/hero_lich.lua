function FrostNova( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local modifier_slow = keys.modifier_slow
	local particle = keys.particle
	local sound = keys.sound
	local ability_level = ability:GetLevel() - 1

	local stack_damage = ability:GetLevelSpecialValueFor("damage_per_stack", ability_level)
	local cast_chance = ability:GetLevelSpecialValueFor("chance_per_stack", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local aoe_damage = ability:GetLevelSpecialValueFor("aoe_damage", ability_level)
	local target_damage = ability:GetAbilityDamage()

	local target_pos = target:GetAbsOrigin()

	-- Adds a stack of the aura modifier
	AddStacks(ability, caster, target, modifier, 1, false)

	-- Deals damage according to the number of stacks
	local stack_count = target:GetModifierStackCount(modifier, ability)
	local damage = stack_damage * stack_count
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Rolls for the chance of casting Frost Nova
	if RandomInt(1, 100) <= cast_chance * stack_count then
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false )
		for _,v in pairs(targets) do
			ApplyDamage({victim = v, attacker = caster, damage = aoe_damage, damage_type = ability:GetAbilityDamageType()})
			ability:ApplyDataDrivenModifier(caster, v, modifier_slow, {duration = ability:GetDuration()})
		end

		-- Casts the spell
		ApplyDamage({victim = target, attacker = caster, damage = target_damage, damage_type = ability:GetAbilityDamageType()})
		target:EmitSound(sound)
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
		
	end

end