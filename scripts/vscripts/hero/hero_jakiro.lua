--[[	Author: Ractidous & D2imba
		Date: 15.07.2015.			]]

function DualBreath( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_breath = keys.particle_breath
	local modifier_caster = keys.modifier_caster
	local modifier_breath = keys.modifier_breath
	local ability_just_used = keys.ability_just_used
	local ability_to_switch = keys.ability_to_switch

	-- Parameters
	local path_radius = ability:GetLevelSpecialValueFor("path_radius", ability_level)
	local spill_radius = ability:GetLevelSpecialValueFor("spill_radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)

	-- Path calculations
	local initial_pos = caster:GetAbsOrigin()
	local path_direction = ( target - initial_pos ):Normalized()
	if ( target - initial_pos ):Length2D() > range then
		target = initial_pos + path_direction * range
	end
	local path_distance = ( target - initial_pos ):Length2D()

	-- Initialize movement variables
	local movement_tick = 0.03
	local distance_from_start = 0
	local searches_made = 0
	local caster_pos = initial_pos
	local caster_direction = caster:GetForwardVector()
	local movement_step = path_direction * speed * movement_tick

	-- Set up animation
	if modifier_breath == "modifier_imba_fire_breath" then
		StartAnimation(caster, {activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	else
		StartAnimation(caster, {activity = ACT_DOTA_CAST_ABILITY_1, rate = 1.0})
	end
	
	-- Start movement
	Timers:CreateTimer(0, function()

		-- Calculate distance since start
		caster_pos = caster:GetAbsOrigin()
		caster:SetForwardVector(caster_direction)
		distance_from_start = ( caster_pos - initial_pos ):Length2D()

		-- Check if Dual Breath should be stopped here
		if distance_from_start < path_distance and not IsHardDisabled(caster) then

			-- Check if an enemy search should be done
			if distance_from_start >= ( searches_made * path_radius / 2 ) then
				searches_made = searches_made + 1

				-- Apply Breath modifier on enemies
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos + ( path_direction * path_radius ) / 2, nil, path_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				for _,enemy in pairs(enemies) do
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_breath, {})
				end

				-- Destroy trees
				GridNav:DestroyTreesAroundPoint(caster_pos + ( path_direction * path_radius ) / 2, path_radius, false)

				-- Fire particle
				local breath_pfx = ParticleManager:CreateParticle(particle_breath, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(breath_pfx, 0, caster_pos )
				ParticleManager:SetParticleControl(breath_pfx, 1, path_direction * speed * 1.2 )
				ParticleManager:SetParticleControl(breath_pfx, 3, Vector(0,0,0) )
				ParticleManager:SetParticleControl(breath_pfx, 9, caster_pos )
				Timers:CreateTimer(0.4, function()
					ParticleManager:DestroyParticle(breath_pfx, false)
				end)
			end

			-- Move forward
			caster:SetAbsOrigin( caster_pos + movement_step )
			return movement_tick
		else

			-- Apply Breath modifier on enemies in spill area
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos + ( path_direction * spill_radius / 2 ), nil, spill_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_breath, {})
			end

			-- Destroy trees
			GridNav:DestroyTreesAroundPoint(caster_pos + ( path_direction * spill_radius ) / 2, spill_radius, false)

			caster:RemoveModifierByName(modifier_caster)
			FindClearSpaceForUnit(caster, caster_pos, false)
			EndAnimation(caster)

			-- Switch breath abilities
			caster:SwapAbilities(ability_just_used, ability_to_switch, false, true)
		end
	end)
end

function DualBreathUpgrade( keys )
	local caster = keys.caster
	local ability_level = keys.ability:GetLevel()
	local ability_ice = caster:FindAbilityByName(keys.ability_ice)
	
	ability_ice:SetLevel(ability_level)
end

function DualBreathDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_macropyre = keys.modifier_macropyre
	local modifier_macropyre_2 = keys.modifier_macropyre_2
	local modifier_breath = keys.modifier_breath

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability_level)

	-- Apply damage
	damage = damage * damage_interval
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Refresh the debuff if on top of Macropyre
	if target:HasModifier(modifier_macropyre) or target:HasModifier(modifier_macropyre_2) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_breath, {})
	end
end

function LiquidFire( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_liquid_fire = keys.sound_liquid_fire
	local particle_liquid_fire = keys.particle_liquid_fire
	local modifier_liquid_fire = keys.modifier_liquid_fire

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Play sound
	target:EmitSound(sound_liquid_fire)

	-- Play explosion particle
	local fire_pfx = ParticleManager:CreateParticle( particle_liquid_fire, PATTACH_ABSORIGIN, target )
	ParticleManager:SetParticleControl( fire_pfx, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fire_pfx, 1, Vector(radius * 2,0,0) )

	-- Apply liquid fire modifier to enemies in the area
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_liquid_fire, {})
	end
end

function LiquidFireDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_liquid_fire = keys.modifier_liquid_fire
	local modifier_macropyre = keys.modifier_macropyre
	local modifier_macropyre_2 = keys.modifier_macropyre_2
	
	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability_level)

	-- Apply damage
	damage = damage * damage_interval
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Refresh the debuff if on top of Macropyre
	if target:HasModifier(modifier_macropyre) or target:HasModifier(modifier_macropyre_2) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_liquid_fire, {})
	end
end

function Macropyre( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)
	local modifier = keys.modifier
	local modifier_scepter = keys.modifier_scepter
	local modifier_dummy = keys.modifier_dummy
	local fire_particle = keys.fire_particle
	local ice_particle = keys.ice_particle
	local sound_fire = keys.sound_fire
	local sound_ice = keys.sound_ice
	local sound_fire_loop = keys.sound_fire_loop

	-- Parameters
	local path_length = ability:GetLevelSpecialValueFor("range", ability_level)
	local path_radius = ability:GetLevelSpecialValueFor("path_radius", ability_level)
	local trail_angle = ability:GetLevelSpecialValueFor("trail_angle", ability_level)
	local trail_amount = ability:GetLevelSpecialValueFor("trail_amount", ability_level)
	local formation_delay = ability:GetLevelSpecialValueFor("formation_delay", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- Play fire sound, and ice sound if owner has Aghanim's Scepter
	caster:EmitSound(sound_fire)
	if scepter then
		caster:EmitSound(sound_ice)
	end
	
	-- Initialize effect geometry
	local direction = caster:GetForwardVector()
	local start_pos = caster:GetAbsOrigin() + direction * path_radius
	local end_pos = start_pos
	local trail_start = ( -1 ) * ( trail_amount - 1 ) / 2
	local trail_end = ( trail_amount - 1 ) / 2

	-- Create the visibility dummy
	local dummy = CreateUnitByName("npc_dummy_unit", start_pos, false, nil, nil, caster:GetTeamNumber())
	AddFOWViewer(DOTA_TEAM_BADGUYS, start_pos, 100, duration, false)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, start_pos, 100, duration, false)

	-- Destroys trees around the target area
	GridNav:DestroyTreesAroundPoint(start_pos, path_radius, false)

	-- Play the fire loop sound on the dummy, finishing it after duration
	dummy:EmitSound(sound_fire_loop)
	Timers:CreateTimer(duration, function()
		dummy:StopSound(sound_fire_loop)
		dummy:Destroy()
	end)
	
	-- Start particle/dummy creation loop
	for trail = trail_start, trail_end do

		-- Calculate each trail's end position
		end_pos = RotatePosition(start_pos, QAngle(0, trail * trail_angle, 0), start_pos + direction * path_length)

		-- Create thinkers along the trail
		for i = 0, math.floor( path_length / path_radius ) do

			-- Calculate thinker position
			local thinker_pos = start_pos + i * path_radius * ( end_pos - start_pos ):Normalized()

			-- Destroys trees around the target area
			GridNav:DestroyTreesAroundPoint(thinker_pos, path_radius, false)

			-- Repeatedly search for enemies in the target area
			local time_elapsed = 0
			Timers:CreateTimer(0, function()
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), thinker_pos, nil, path_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
				
				-- Applies debuff to enemies found
				for _, enemy in pairs(enemies) do
					if scepter then
						ability:ApplyDataDrivenModifier(caster, enemy, modifier_scepter, {} )
					else
						ability:ApplyDataDrivenModifier(caster, enemy, modifier, {} )
					end
				end

				-- Check if time is over
				time_elapsed = time_elapsed + 0.1
				if time_elapsed < duration then
					return 0.1
				end
			end)
		end

		-- Draw the fire particles (blue fire if the owner has Aghanim's Scepter)
		if scepter then
			local ice_pfx = ParticleManager:CreateParticle( ice_particle, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleAlwaysSimulate(ice_pfx)
			ParticleManager:SetParticleControl( ice_pfx, 0, start_pos )
			ParticleManager:SetParticleControl( ice_pfx, 1, end_pos )
			ParticleManager:SetParticleControl( ice_pfx, 2, Vector( duration, 0, 0 ) )
			ParticleManager:SetParticleControl( ice_pfx, 3, start_pos )
		else
			local fire_pfx = ParticleManager:CreateParticle( fire_particle, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleAlwaysSimulate(fire_pfx)
			ParticleManager:SetParticleControl( fire_pfx, 0, start_pos )
			ParticleManager:SetParticleControl( fire_pfx, 1, end_pos )
			ParticleManager:SetParticleControl( fire_pfx, 2, Vector( duration, 0, 0 ) )
			ParticleManager:SetParticleControl( fire_pfx, 3, start_pos )
		end
	end
end