--[[ 	Author: D2imba
		Date: 27.04.2015	]]

function Starfall( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Particles and sounds
	local ambient_sound = keys.ambient_sound
	local hit_sound = keys.hit_sound
	local ambient_particle = keys.ambient_particle
	local hit_particle = keys.hit_particle

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("secondary_radius", ability_level)
	local max_count = ability:GetLevelSpecialValueFor("secondary_count", ability_level)
	local pulse_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
	local hit_delay = ability:GetLevelSpecialValueFor("hit_delay", ability_level)
	local secondary_damage = ability:GetLevelSpecialValueFor("secondary_damage", ability_level)

	local caster_pos = caster:GetAbsOrigin()
	local current_count = 0

	if max_count > 0 then
		Timers:CreateTimer(pulse_delay, function()
			-- Emit sound
			caster:EmitSound(ambient_sound)

			-- Create ambient particle
			local pfx = ParticleManager:CreateParticle(ambient_particle, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(pfx, 0, caster_pos)
			ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))

			-- Find targets and apply the particle, damage, and hit sound
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )
			for _,v in pairs(targets) do
				local pfx_2 = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, v)
				ParticleManager:SetParticleControl(pfx_2, 0, v:GetAbsOrigin())
				Timers:CreateTimer(hit_delay, function()
					v:EmitSound(hit_sound)
					ApplyDamage({victim = v, attacker = caster, damage = secondary_damage, damage_type = ability:GetAbilityDamageType()})
				end)
			end

			-- If there are more pulses to create, call the function again after the pulse delay
			current_count = current_count + 1
			if current_count < max_count then
				return pulse_delay
			end
		end)
	end
end

function LaunchArrow( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target_points[1]
	
	-- Memorizes the cast location to calculate the distance traveled later
	local arrow_location = caster:GetAbsOrigin()

	-- Parameters
	local arrow_direction = caster:GetForwardVector()
	local modifier_arrow = keys.modifier_arrow
	local sound_arrow = keys.sound_arrow
	local arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", ability_level)
	local arrow_width = ability:GetLevelSpecialValueFor("arrow_width", ability_level)
	local arrow_max_stunrange = ability:GetLevelSpecialValueFor("arrow_max_stunrange", ability_level)
	local arrow_min_stun = ability:GetLevelSpecialValueFor("arrow_min_stun", ability_level)
	local arrow_max_stun = ability:GetLevelSpecialValueFor("arrow_max_stun", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local arrow_bonus_damage = ability:GetLevelSpecialValueFor("arrow_bonus_damage", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	local enemy_units

	-- Initializing the damage table
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability

	-- Stun per distance
	local stun_per_100 = (arrow_max_stun - arrow_min_stun) * 100 / arrow_max_stunrange
	local arrow_stun_duration

	-- Spawn the arrow unit and move it forward
	local sacred_arrow = CreateUnitByName("npc_dummy_mirana_arrow", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	sacred_arrow:SetForwardVector(arrow_direction)
	ability:ApplyDataDrivenModifier(caster, sacred_arrow, modifier_arrow, {})
	Physics:Unit(sacred_arrow)
	sacred_arrow:SetPhysicsVelocity(arrow_direction * arrow_speed * 1.58)	
	sacred_arrow:SetPhysicsFriction(0)
	sacred_arrow:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	sacred_arrow:SetAutoUnstuck(false)
	sacred_arrow:FollowNavMesh(false)
	sacred_arrow:SetGroundBehavior(PHYSICS_GROUND_ABOVE)

	-- Arrow duration counter (destroys the arrow after it travels for too long)
	local arrow_ticks = 0

	Timers:CreateTimer(0, function()
		-- During the night, ignores creeps and hits only heroes
		if GameRules:IsDaytime() then
			enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		else
			enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		end

		-- If no enemy is found, keep going
		if #enemy_units == 0 then
			arrow_ticks = arrow_ticks + 1
			
			-- Destroys the arrow after 1000 ticks (~30 seconds)
			if arrow_ticks >= 1000 then
				sacred_arrow:StopPhysicsSimulation()
				sacred_arrow:Destroy()
			else
				return 0.03
			end

		-- else, play the impact sound and apply damage
		else
			for _,unit in pairs(enemy_units) do
				-- Calculate hit distance 
				local distance = (sacred_arrow:GetAbsOrigin() - arrow_location):Length2D()

				-- Calculate and apply stun
				if distance < arrow_max_stunrange then
					arrow_stun_duration = distance * stun_per_100 / 100 + arrow_min_stun
				else
					arrow_stun_duration = arrow_max_stun
				end

				unit:AddNewModifier(caster, nil, "modifier_stunned", {duration = arrow_stun_duration})

				-- Damage
				local arrow_damage = base_damage + arrow_bonus_damage * distance / 1000
				damage_table.victim = unit
				damage_table.damage = arrow_damage
				ApplyDamage(damage_table)

				-- Destroy the arrow and play the hit sound
				sacred_arrow:StopPhysicsSimulation()
				sacred_arrow:Destroy()
				unit:EmitSound(sound_arrow)
				ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)
			end
		end
	end)
end

function Leap( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local caster_pos = caster:GetAbsOrigin()
	local target_pos = keys.target_points[1]
	local leap_speed = ability:GetLevelSpecialValueFor("leap_speed", ability_level)
	local max_distance = ability:GetLevelSpecialValueFor("leap_distance", ability_level)
	local max_time = ability:GetLevelSpecialValueFor("leap_time", ability_level)
	local root_modifier = keys.root_modifier

	-- Clears any current command, grants temporary invulnerability
	caster:Stop()

	-- Physics
	local direction = (target_pos - caster_pos):Normalized()
	local leap_distance = (target_pos - caster_pos):Length2D()
	if leap_distance > max_distance then
		leap_distance = max_distance
	end
	local end_time = leap_distance / leap_speed
	if end_time > max_time then
		leap_speed = leap_distance / max_time
		end_time = max_time
	end
	local velocity = leap_speed * 1.4
	local time_elapsed = 0
	local time = end_time / 2
	local jump = end_time / 0.03

	Physics:Unit(caster)

	ability:ApplyDataDrivenModifier(caster, caster, root_modifier, {})
	caster:SetAutoUnstuck(false)
	caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	caster:FollowNavMesh(false)	
	caster:SetPhysicsVelocity(direction * velocity)

	-- Move the unit
	Timers:CreateTimer(function()
		local ground_position = GetGroundPosition(caster:GetAbsOrigin() , caster)
		time_elapsed = time_elapsed + 0.03
		if time_elapsed < time then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,jump)) -- Going up
		else
			caster:SetAbsOrigin(caster:GetAbsOrigin() - Vector(0,0,jump)) -- Going down
		end
		-- If the target reached the ground then remove physics
		if time_elapsed >= end_time then
			caster:RemoveModifierByName(root_modifier)
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin() , caster))
			caster:SetPhysicsAcceleration(Vector(0,0,0))
			caster:SetPhysicsVelocity(Vector(0,0,0))
			caster:OnPhysicsFrame(nil)
			caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
			caster:SetAutoUnstuck(true)
			caster:FollowNavMesh(true)
			caster:SetPhysicsFriction(.05)
			return nil
		end

		return 0.03
	end)
end

function MoonlightScepter( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local cast_modifier = keys.cast_modifier
	local fade_modifier = keys.fade_modifier
	local scepter = HasScepter(caster)

	if scepter and not GameRules:IsDaytime() and caster:IsAlive() then
		if not target:HasModifier(modifier) then
			ability:ApplyDataDrivenModifier(caster, target, modifier, {})
			ability:ApplyDataDrivenModifier(caster, target, fade_modifier, {})
		end
	else
		if target:HasModifier(modifier) and not caster:HasModifier(cast_modifier) then
			target:RemoveModifierByName(modifier)
		end
	end
end

