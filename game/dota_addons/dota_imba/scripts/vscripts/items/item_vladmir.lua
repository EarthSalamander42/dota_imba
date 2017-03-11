--[[	Author: d2imba
		Date:	03.08.2015	]]

function VladmirOffering( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local particle_hero = keys.particle_hero
	local particle_creeps = keys.particle_creeps

	-- Parameters
	local lifesteal_pct = ability:GetLevelSpecialValueFor("vampiric_aura", ability_level)

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == attacker or target:IsIllusion() then
		return nil
	end

	-- If the attacker is a real hero, heal and draw the particle
	if attacker:IsRealHero() then
		attacker:Heal(damage * lifesteal_pct * 0.01, caster)
		local lifesteal_fx = ParticleManager:CreateParticle(particle_hero, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)

	-- If the attacker is an illusion, only draw the particle
	elseif attacker:IsHero() then
		local lifesteal_fx = ParticleManager:CreateParticle(particle_hero, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)

	-- If the attacker is a creep, heal and draw its appropriate particle
	elseif attacker:IsCreep() then
		attacker:Heal(damage * lifesteal_pct * 0.01, caster)
		local lifesteal_fx = ParticleManager:CreateParticle(particle_creeps, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)
	end
end

function VladmirOfferingProjectile(keys)
	local caster = keys.caster
	ChangeAttackProjectileImba(caster)
end

function VladmirBlood( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local particle_hero = keys.particle_hero
	local particle_creeps = keys.particle_creeps

	-- Parameters
	local hero_lifesteal = ability:GetLevelSpecialValueFor("hero_lifesteal", ability_level)
	local creep_lifesteal = ability:GetLevelSpecialValueFor("creep_lifesteal", ability_level)

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target == attacker or target:IsIllusion() then
		return nil
	end

	-- If the attacker is a real hero, heal and draw the particle
	if attacker:IsRealHero() then

		-- Delay the lifesteal for one game tick to prevent blademail interaction
		Timers:CreateTimer(0.01, function()
			if target:IsRealHero() then
				attacker:Heal(damage * hero_lifesteal * 0.01, caster)
			else
				attacker:Heal(damage * creep_lifesteal * 0.01, caster)
			end
		end)

		local lifesteal_fx = ParticleManager:CreateParticle(particle_hero, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)

	-- If the attacker is an illusion, only draw the particle
	elseif attacker:IsHero() then
		local lifesteal_fx = ParticleManager:CreateParticle(particle_hero, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)

	-- If the attacker is a creep, heal and draw its appropriate particle
	elseif attacker:IsCreep() then

		if target:IsRealHero() then
			attacker:Heal(damage * hero_lifesteal * 0.01, caster)
		else
			attacker:Heal(damage * creep_lifesteal * 0.01, caster)
		end
		
		local lifesteal_fx = ParticleManager:CreateParticle(particle_creeps, PATTACH_ABSORIGIN_FOLLOW, attacker)
		ParticleManager:SetParticleControl(lifesteal_fx, 0, attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(lifesteal_fx)
	end
end