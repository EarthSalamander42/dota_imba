--[[	Author: d2imba
		Date:	20.09.2015	]]

function ButterflyEffect( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local particle_projectile = keys.particle_projectile
	local min_range = ability:GetLevelSpecialValueFor("min_range", ability:GetLevel() - 1)

	-- Finds valid nearby targets
	local search_range = math.max(caster:GetAttackRange() + 64, min_range)
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- If only one enemy (the target) is a valid target, do nothing else
	if #enemies <= 1 then
		return nil
	end

	-- Single out a random enemy that is not the target
	local enemy = enemies[RandomInt(1, #enemies)]
	while enemy == target do
		enemy = enemies[RandomInt(1, #enemies)]
	end

	-- Perform an attack on the singled out enemy
	if caster:IsRangedAttacker() then
		caster:PerformAttack(enemy, true, true, true, true, true, false, false)

	-- Troll Warlord graphical adjustment
	elseif caster:HasModifier("modifier_imba_berserkers_rage") then
		caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		caster:PerformAttack(enemy, true, true, true, true, true, false, false)
		caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)

	-- Melee attack
	else
		local butterfly_projectile = {
			Target = enemy,
			Source = caster,
			Ability = ability,
			EffectName = particle_projectile,
			bDodgeable = true,
			bProvidesVision = false,
			iMoveSpeed = 900,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile(butterfly_projectile)
	end
end

function ButterflyProjectileHit( keys )
	local caster = keys.caster
	local target = keys.target

	-- Store caster's original position
	local original_loc = caster:GetAbsOrigin()

	-- Teleport caster to perform an attack
	caster:SetAbsOrigin(target:GetAbsOrigin())
	caster:PerformAttack(target, true, true, true, true, true, false, false)
	caster:SetAbsOrigin(original_loc)
end

function FlutterParticle( keys )
	local caster = keys.caster
	local particle_flutter = keys.particle_flutter
	local sound_flutter = keys.sound_flutter

	-- Play sound
	caster:EmitSound(sound_flutter)

	-- Play the particle
	caster.flutter_particle = ParticleManager:CreateParticle(particle_flutter, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(caster.flutter_particle, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(caster.flutter_particle)
end

function FlutterParticleEnd( keys )
	local caster = keys.caster
	local modifier_evasion = keys.modifier_evasion

	-- Add the evasion modifier
	keys.ability:ApplyDataDrivenModifier(caster, caster, modifier_evasion, {})
end