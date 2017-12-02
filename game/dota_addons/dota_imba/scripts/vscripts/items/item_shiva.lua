--[[	Author: Firetoad
		Date:	20.07.2016	]]

function ShivaBlast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local particle_blast = keys.particle_blast
	local particle_hit = keys.particle_hit
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local blast_radius = ability:GetSpecialValueFor("blast_radius")
	local blast_speed = ability:GetSpecialValueFor("blast_speed")
	local damage = ability:GetSpecialValueFor("damage")
	local slow_initial_stacks = ability:GetSpecialValueFor("slow_initial_stacks")
	local blast_duration = blast_radius / blast_speed
	local current_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(blast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)


	-- Initialize targets hit table
	local targets_hit = {}

	-- Main blasting loop
	local current_radius = 0
	local tick_interval = 0.1
	Timers:CreateTimer(tick_interval, function()

		-- Give vision
		AddFOWViewer(caster:GetTeamNumber(), current_loc, current_radius, 0.1, false)

		-- Update current radius and location
		current_radius = current_radius + blast_speed * tick_interval
		current_loc = caster:GetAbsOrigin()
		--vision_dummy:SetAbsOrigin(current_loc)

		-- Iterate through enemies in the radius
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			
			-- Check if this enemy was already hit
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			-- If not, blast it
			if not enemy_has_been_hit then

				-- Play hit particle
				local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				-- Deal damage
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
				enemy:SetModifierStackCount(modifier_slow, caster, slow_initial_stacks)

				-- Add enemy to the targets hit table
				targets_hit[#targets_hit + 1] = enemy
			end
		end

		-- If the current radius is smaller than the maximum radius, keep going
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end

function ShivaBlastSlowDecay( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow

	-- Fetch current stacks
	local current_stacks = target:GetModifierStackCount(modifier_slow, caster)

	-- If this is the last stack, remove the modifier
	if current_stacks <= 1 then
		target:RemoveModifierByName(modifier_slow)

	-- Else, reduce stack amount by 1
	else
		AddStacks(ability, caster, target, modifier_slow, -1, true)
	end
end

function ShivaAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local aura_as_reduction = ability:GetSpecialValueFor("aura_as_reduction")

	-- Remove the slow modifier in order to properly calculate the target's attack speed
	target:RemoveModifierByName(modifier_slow)

	-- Calculate current attack speed and amount of reduction
	local as_reduction = target:GetAttackSpeed() * aura_as_reduction

	-- Apply stacks
	AddStacks(ability, caster, target, modifier_slow, as_reduction, true)
end