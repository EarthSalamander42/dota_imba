--[[	Author: d2imba
		Date:	03.10.2015	]]

function Starfury( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_proc = keys.sound_proc
	local particle_proc = keys.particle_proc
	local modifier_buff = keys.modifier_buff
	local modifier_dummy = keys.modifier_dummy

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Roll for proc chance
	if RandomInt(1, 100) <= proc_chance then

		-- Play sound
		caster:EmitSound(sound_proc)

		-- Grant proc buff
		ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, {})
	end
	
	-- Find nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	-- Exclude the target from the enemy count
	local enemy_count = #nearby_enemies
	for _,enemy in pairs(nearby_enemies) do
		if enemy == target then
			enemy_count = enemy_count - 1
		end
	end

	-- Calculate damage to be dealt
	local damage = caster:GetAgility() / math.max(enemy_count, 1)

	-- Iterate through enemies 
	for _,enemy in pairs(nearby_enemies) do
		if enemy ~= target then

			-- Projectile parameters
			local starfury_projectile = {
				Target = enemy,
				Source = target,
				Ability = ability,
				EffectName = particle_proc,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the dummy projectile
			ProjectileManager:CreateTrackingProjectile(starfury_projectile)

			-- Calculate projectile arrival time
			local projectile_delay = (enemy:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() / speed

			-- Apply damage after the projectile delay
			Timers:CreateTimer(projectile_delay, function()
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
			end)
		end
	end
end

function StarfuryBuff( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_buff = keys.modifier_buff

	-- Parameters
	local proc_bonus = ability:GetLevelSpecialValueFor("proc_bonus", ability_level)

	-- Calculate amount of stacks to grant
	local stack_amount = caster:GetAgility() * proc_bonus / 100

	-- Add stacks of the real buff
	AddStacks(ability, caster, caster, modifier_buff, stack_amount, true)
end