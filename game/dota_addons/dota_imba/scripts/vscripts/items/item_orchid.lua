--[[	Author: d2imba
		Date:	15.08.2015	]]

function OrchidCast( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	
	--Check for Linkens	
	if caster:GetTeam() ~= target:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then 
			return 
		end
	end
	
	-- Add the debuff
	target:AddNewModifier(caster, ability, "modifier_orchid_debuff", {})
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
end

function BloodthornCast( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	
	--Check for Linkens	
	if caster:GetTeam() ~= target:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then 
			return 
		end
	end
	
	-- Add the debuff
	target:AddNewModifier(caster, ability, "modifier_bloodthorn_debuff", {})
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
	
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
		ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
	end
end

function BloodthornCritRoll( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_crit = keys.modifier_crit

	-- Parameters
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)

	-- Remove crit modifier
	caster:RemoveModifierByName(modifier_crit)

	-- Roll for a crit
	if RandomInt(1, 100) <= crit_chance then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
	end
end

function BloodthornCritHit( keys )
	local caster = keys.caster
	local modifier_crit = keys.modifier_crit

	-- Remove crit modifier
	caster:RemoveModifierByName(modifier_crit)
end

function BloodthornDamageStorage( keys )
	local target = keys.unit
	local damage = keys.damage

	if not target.bloodthorn_damage_taken then
		target.bloodthorn_damage_taken = damage
	else
		target.bloodthorn_damage_taken = target.bloodthorn_damage_taken + damage
	end
end

function BloodthornEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_pop = keys.particle_pop

	-- Parameters
	local damage_percent = ability:GetLevelSpecialValueFor("silence_damage_percent", ability_level)
	local damage = 0

	-- If damage was taken, apply the Soul Burn effect
	if target.bloodthorn_damage_taken then

		-- Calculate damage
		damage = target.bloodthorn_damage_taken * damage_percent / 100

		-- Clean up damage storage global
		target.bloodthorn_damage_taken = nil

		-- Apply damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Fire particle
		local pop_pfx = ParticleManager:CreateParticle(particle_pop, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(pop_pfx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pop_pfx, 1, Vector(100, 0, 0))
	end
end