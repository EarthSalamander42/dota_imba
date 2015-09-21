--[[	Author: d2imba
		Date:	20.09.2015	]]

function Dagon( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_hit = keys.particle_hit

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local bounce_damage = ability:GetLevelSpecialValueFor("bounce_damage", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range", ability_level)
	local bounce_count = ability:GetLevelSpecialValueFor("bounce_count", ability_level)
	local current_source = caster
	local targets_hit = {}

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Create initial particle
	local dagon_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(dagon_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Deal damage to the initial target
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Add initial target to targets_hit table
	targets_hit[1] = target

	-- Start bouncing from the initial target
	current_source = target

	-- Start bounce loop
	while bounce_count > 0 do

		-- Find nearby enemies
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_source:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

		-- Check for not-yet-hit enemies
		for _,enemy in pairs(nearby_enemies) do
			local already_hit = false
			for _,hit_enemy in pairs(targets_hit) do
				if hit_enemy == enemy then
					already_hit = true
					break
				end
			end

			-- Found a valid enemy, zap it
			if not already_hit then

				-- Create particle
				local bounce_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_RENDERORIGIN_FOLLOW, current_source)
				ParticleManager:SetParticleControlEnt(bounce_pfx, 0, current_source, PATTACH_POINT_FOLLOW, "attach_hitloc", current_source:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(bounce_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
				ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(bounce_damage, 0, 0))

				-- Play hit sound if the target is a hero
				if enemy:IsHero() then
					enemy:EmitSound(sound_hit)
				end

				-- Deal damage to the initial target
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = bounce_damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Set up the next bounce
				current_source = enemy
				targets_hit[#targets_hit + 1] = enemy
				break
			end
		end
		bounce_count = bounce_count - 1
	end
end