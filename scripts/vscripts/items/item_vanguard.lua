--[[	Author: Firetoad
		Date:	11.10.2015	]]

function CrimsonGuard( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_active") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})			
		end
	end
end

function CrimsonGuardParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.crimson_guard_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.crimson_guard_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.crimson_guard_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function CrimsonGuardParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.crimson_guard_pfx, false)
end

function GreatwyrmPlate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)
	local cooldown = ability:GetCooldownTimeRemaining()

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ally:RemoveModifierByName("modifier_item_crimson_guard_active")
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})
		end
	end
end

function GreatwyrmParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.greatwyrm_plate_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.greatwyrm_plate_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.greatwyrm_plate_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function GreatwyrmParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.greatwyrm_plate_pfx, false)
end