--[[	Author: d2imba
		Date:	20.09.2015	]]

function JinguBangPassive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_ranged = keys.modifier_ranged
	local modifier_melee = keys.modifier_melee

	-- Apply the relevant modifier, according to the caster's attack capability
	if caster:IsRangedAttacker() then
		caster:RemoveModifierByName(modifier_melee)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_ranged, {})
	else
		caster:RemoveModifierByName(modifier_ranged)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_melee, {})
	end
end

function JinguBangProc( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit

	-- Parameters
	local pulverize_chance = ability:GetLevelSpecialValueFor("pulverize_chance", ability_level)
	local pulverize_radius = ability:GetLevelSpecialValueFor("pulverize_radius", ability_level)
	local pulverize_length = ability:GetLevelSpecialValueFor("pulverize_length", ability_level)

	-- Check for a proc
	if not target:IsBuilding() and RandomInt(1, 100) <= pulverize_chance then
		
		-- Play sound
		target:EmitSound(sound_hit)

		-- Immunize target from projectile damage
		caster.jingu_bang_initial_target = target

		-- Launch projectile
		local direction = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized()
		local pulverize_projectile = {
			Ability				= ability,
		--	EffectName			= "",
			vSpawnOrigin		= target:GetAbsOrigin(),
			fDistance			= pulverize_length,
			fStartRadius		= pulverize_radius,
			fEndRadius			= pulverize_radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * 3500,
			bProvidesVision		= false,
		--	iVisionRadius		= ,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		}
		ProjectileManager:CreateLinearProjectile(pulverize_projectile)
	end
end

function JinguBangHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local particle_hit = keys.particle_hit

	-- Check if this is the original target
	if target ~= caster.jingu_bang_initial_target then

		-- Attack (does not calculate on-hit procs)
		local initial_pos = caster:GetAbsOrigin()
		local target_pos = target:GetAbsOrigin()
		caster:SetAbsOrigin(target_pos)
		caster:PerformAttack(target, true, false, true, true)
		caster:SetAbsOrigin(initial_pos)

		-- Play particle
		local pulverize_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(pulverize_pfx, 0, target_pos)
		ParticleManager:SetParticleControl(pulverize_pfx, 1, Vector(100,0,0))
	end
end
	
