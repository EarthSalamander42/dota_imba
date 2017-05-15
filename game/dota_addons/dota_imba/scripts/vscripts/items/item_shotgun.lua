--[[	Author: d2imba
		Date:	20.09.2015	]]

function Shotgun( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_projectile = keys.particle_projectile
	local sound_shot = keys.sound_shot

	-- Parameters
	local proc_radius = ability:GetLevelSpecialValueFor("proc_radius", ability_level)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- If the ability is on cooldown, stop here
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Iterate through enemies near the target
	local targets_hit = 0
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, proc_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Ignore the initial target
		if enemy ~= target then

			-- Star projectile parameters
			local shotgun_projectile = {
				Target = enemy,
				Source = target,
				Ability = ability,
				EffectName = particle_projectile,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(shotgun_projectile)

			-- Exit the loop if target count has been reached
			targets_hit = targets_hit + 1
			if targets_hit >= max_targets then
				break
			end
		end
	end

	-- If at least one star was created, play the sound and put the ability on cooldown
	if targets_hit > 0 then
		local cooldown_reduction = caster:GetCooldownReduction()
		ability:StartCooldown(ability:GetCooldown(ability_level) * cooldown_reduction)
		target:EmitSound(sound_shot)
	end
end

function ShotgunHit( keys )
	local caster = keys.caster
	local target = keys.target

	-- Attack the target
	if caster:IsRangedAttacker() then
		caster:PerformAttack(target, true, true, true, true, false, false, false)
	else
		local original_loc = caster:GetAbsOrigin()
		caster:SetAbsOrigin(target:GetAbsOrigin())
		caster:PerformAttack(target, true, true, true, true, true, false, false)
		caster:SetAbsOrigin(original_loc)
	end
end