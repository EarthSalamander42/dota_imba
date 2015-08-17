--[[	Author: d2imba
		Date:	15.08.2015	]]

function OrchidCrit( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local modifier_prevent = keys.modifier_prevent
	local modifier_orchid = keys.modifier_orchid

	-- Parameters
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
	local crit_damage = ability:GetLevelSpecialValueFor("crit_damage", ability_level)
	local bonus_damage = math.max( damage * ( crit_damage - 100 ) / 100, 0)

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == caster or target:HasModifier(modifier_prevent) then
		return nil
	end

	-- Roll for crit chance
	if RandomInt(1, 100) <= crit_chance then
		caster:RemoveModifierByName(modifier_orchid)
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = DAMAGE_TYPE_PURE})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, damage + bonus_damage, nil)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_orchid, {})
	end
end

function OrchidAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_prevent = keys.modifier_prevent

	-- Applies the crit-prevention modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_prevent, {})
end

function OrchidDamageStorage( keys )
	local target = keys.unit
	local damage = keys.damage

	if not target.orchid_damage_taken then
		target.orchid_damage_taken = damage
	else
		target.orchid_damage_taken = target.orchid_damage_taken + damage
	end
end

function OrchidEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_pop = keys.particle_pop

	-- Parameters
	local damage_percent = ability:GetLevelSpecialValueFor("silence_damage_percent", ability_level)
	local damage = 0

	-- If damage was taken, apply the Soul Burn effect
	if target.orchid_damage_taken then

		-- Calculate damage
		damage = target.orchid_damage_taken * damage_percent / 100

		-- Clean up damage storage global
		target.orchid_damage_taken = nil

		-- Apply damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Fire particle
		local pop_pfx = ParticleManager:CreateParticle(particle_pop, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(pop_pfx, 0, target:GetAbsOrigin())
	end
end