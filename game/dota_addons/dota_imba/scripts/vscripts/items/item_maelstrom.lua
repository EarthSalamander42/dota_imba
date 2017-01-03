--[[	Author: Firetoad
		Date:	19.07.2016	]]

function Maelstrom( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_proc = keys.sound_proc
	local sound_bounce = keys.sound_bounce
	local particle_bounce = keys.particle_bounce
	local particle_charge = keys.particle_charge
	local modifier_charge = keys.modifier_charge

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Parameters
	local proc_count = ability:GetSpecialValueFor("proc_count")
	local bounce_damage = ability:GetSpecialValueFor("bounce_damage")
	local bounce_radius = ability:GetSpecialValueFor("bounce_radius")

	-- Add a stack of the charge modifier
	AddStacks(ability, caster, caster, modifier_charge, 1, true)

	-- If this isn't enough charges to proc the chain lightning, do nothing else
	local charge_count = caster:GetModifierStackCount(modifier_charge, caster)
	if charge_count < proc_count then
		return nil
	end

	-- Else, remove the charge counter and proc the chain lightning
	caster:RemoveModifierByName(modifier_charge)
		
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

	-- Bounce around and ZAP THEM!
	local keep_bouncing = true
	local current_bounce_source = target
	local current_bounce_source_loc = target:GetAbsOrigin()
	while keep_bouncing do
		keep_bouncing = false

		-- Search for valid bounce targets
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_bounce_source_loc, nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for _,enemy in pairs(nearby_enemies) do
			local is_valid_target = true
			for _,hit_enemy in pairs(enemies_hit) do
				if enemy == hit_enemy then is_valid_target = false end
			end

			-- If this enemy is a valid bounce target, stop searching and bounce
			if is_valid_target then

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
	local modifier_charge = keys.modifier_charge

	-- If the attacker and the shield owner are in the same team, do nothing
	if attacker:GetTeam() == shield_owner:GetTeam() then
		return nil
	end

	-- Parameters
	local static_proc_count = ability:GetSpecialValueFor("static_proc_count")
	local static_damage = ability:GetSpecialValueFor("static_damage")
	local static_radius = ability:GetSpecialValueFor("static_radius")

	-- Add a stack of the charge modifier
	AddStacks(ability, shield_owner, shield_owner, modifier_charge, 1, true)

	-- If this isn't enough charges to proc the chain lightning, do nothing else
	local charge_count = shield_owner:GetModifierStackCount(modifier_charge, shield_owner)
	if charge_count < static_proc_count then
		return nil
	end

	-- Else, remove the charge counter and ZAP THEM!
	shield_owner:RemoveModifierByName(modifier_charge)

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

function MjollnirEnd( keys )
	local target = keys.target
	local sound_end = keys.sound_end
	local sound_loop = keys.sound_loop

	-- Play end sound
	target:EmitSound(sound_end)

	-- Stop sound loop
	StopSoundEvent(sound_loop, target)
end