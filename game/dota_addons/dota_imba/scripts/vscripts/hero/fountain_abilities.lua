function GrievousWounds( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local modifier_debuff = keys.modifier_debuff
    local particle_hit = keys.particle_hit

    -- Parameters
    local damage_increase = ability:GetLevelSpecialValueFor("damage_increase", ability_level)

    -- Play hit particle
    local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
    ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

    -- Calculate bonus damage
    local base_damage = caster:GetAttackDamage()
    local current_stacks = target:GetModifierStackCount(modifier_debuff, caster)
    local total_damage = base_damage * ( 1 + current_stacks * damage_increase / 100 )

    -- Apply damage
    ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})

    -- Apply bonus damage modifier
    AddStacks(ability, caster, target, modifier_debuff, 1, true)
end
