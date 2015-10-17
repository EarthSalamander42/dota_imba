--[[	Author: d2imba
		Date:	15.08.2015	]]

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