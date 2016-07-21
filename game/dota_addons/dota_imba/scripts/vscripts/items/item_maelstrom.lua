--[[	Author: Firetoad
		Date:	19.07.2016	]]

function Maelstrom( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_proc = keys.sound_proc
	local sound_bounce = keys.sound_bounce
	local particle_bounce = keys.particle_bounce

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Parameters
	local proc_chance = ability:GetSpecialValueFor("proc_chance")
	local bounce_damage = ability:GetSpecialValueFor("bounce_damage")
	local bounce_radius = ability:GetSpecialValueFor("bounce_radius")
	local bounce_delay = ability:GetSpecialValueFor("bounce_delay")

	-- "Pseudo-random" (not really), processing time-saving proc chance calculation
	if not caster.maelstrom_proc_count then
		caster.maelstrom_proc_count = proc_chance
	else
		caster.maelstrom_proc_count = caster.maelstrom_proc_count + proc_chance
	end

	-- If enough for a proc, ZAP THEM!
	if caster.maelstrom_proc_count >= 100 then

		-- Reset proc chance
		caster.maelstrom_proc_count = caster.maelstrom_proc_count - 100
		
		-- Play initial sound
		caster:EmitSound(sound_proc)

		-- Play first bounce sound
		target:EmitSound(sound_bounce)

		-- Play first particle
		local bounce_pfx = ParticleManager:CreateParticle(particle_bounce, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(bounce_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
		ParticleManager:ReleaseParticleIndex(bounce_pfx)

		-- Damage initial target
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bounce_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Initialize targets hit table
		local enemies_hit = {}
		enemies_hit[1] = target

		-- Start bouncing
		local keep_bouncing = false
		local current_bounce_source = target
		local current_bounce_source_loc = target:GetAbsOrigin()
		Timers:CreateTimer(bounce_delay, function()
			
			-- Search for valid bounce targets
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_bounce_source_loc, nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			for _,enemy in pairs(nearby_enemies) do
				local is_valid_target = true
				for _,hit_enemy in pairs(enemies_hit) do
					if enemy == hit_enemy then is_valid_target = false end
				end

				-- If this enemy is a valid bounce target, stop searching and bounce
				if is_valid_target then
					
					-- Play bounce sound
					enemy:EmitSound(sound_bounce)

					-- Play bounce particle
					bounce_pfx = ParticleManager:CreateParticle(particle_bounce, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(bounce_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(bounce_pfx, 1, current_bounce_source, PATTACH_POINT_FOLLOW, "attach_hitloc", current_bounce_source_loc, true)
					ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
					ParticleManager:ReleaseParticleIndex(bounce_pfx)

					-- Damage bounce target
					ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = bounce_damage, damage_type = DAMAGE_TYPE_MAGICAL})

					-- Update bounce parameters
					current_bounce_source = enemy
					current_bounce_source_loc = enemy:GetAbsOrigin()
					enemies_hit[#enemies_hit + 1] = enemy
					keep_bouncing = true
					break
				end
			end

			-- If we should keep bouncing, wait [bounce_delay] and restart the loop
			if keep_bouncing then
				keep_bouncing = false
				return bounce_delay
			end
		end)
	end
end

function Mjollnir( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_shield = keys.modifier_shield
	local sound_cast = keys.sound_cast
	local sound_loop = keys.sound_loop

	-- Apply the modifier to the target
	ability:ApplyDataDrivenModifier(caster, target, modifier_shield, {})

	-- Play cast sound
	target:EmitSound(sound_cast)

	-- End any previously existing sound loop, and create a new one
	StopSoundEvent(sound_loop, target)
	target:EmitSound(sound_loop)
end

function MjollnirProc( keys )
	local attacker = keys.attacker
	local shield_owner = keys.unit
	local ability = keys.ability
	local sound_hit = keys.sound_hit
	local particle_static = keys.particle_static
	local modifier_slow = keys.modifier_slow

	-- If the attacker and the shield owner are in the same team, do nothing
	if attacker:GetTeam() == shield_owner:GetTeam() then
		return nil
	end

	-- Parameters
	local static_chance = ability:GetSpecialValueFor("static_chance")
	local static_damage = ability:GetSpecialValueFor("static_damage")
	local static_radius = ability:GetSpecialValueFor("static_radius")

	-- "Pseudo-random" (not really), processing time-saving proc chance calculation
	if not shield_owner.mjollnir_proc_count then
		shield_owner.mjollnir_proc_count = static_chance
	else
		shield_owner.mjollnir_proc_count = shield_owner.mjollnir_proc_count + static_chance
	end

	-- If enough for a proc, ZAP THEM!
	if shield_owner.mjollnir_proc_count >= 100 then

		-- Reset proc chance
		shield_owner.mjollnir_proc_count = shield_owner.mjollnir_proc_count - 100

		local shield_owner_loc = shield_owner:GetAbsOrigin()
		local static_origin = shield_owner_loc + Vector(0, 0, 200)
		
		-- Search for nearby valid targets
		local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner_loc, nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _,enemy in pairs(nearby_enemies) do
			
			-- Play hit sound
			enemy:EmitSound(sound_hit)

			-- Play particle
			local static_pfx = ParticleManager:CreateParticle(particle_static, PATTACH_ABSORIGIN_FOLLOW, shield_owner)
			ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
			ParticleManager:ReleaseParticleIndex(static_pfx)

			-- Apply damage
			ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Apply slow modifier
			ability:ApplyDataDrivenModifier(shield_owner, enemy, modifier_slow, {})
		end
	end
end

function MjollnirEnd( keys )
	local target = keys.target
	local sound_end = keys.sound_end
	local sound_loop = keys.sound_loop

	-- Play end sound
	target:EmitSound(sound_end)

	-- Stop sound loop
	StopSoundEvent(sound_loop, target)
end