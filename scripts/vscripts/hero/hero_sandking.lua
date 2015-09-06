--[[	Author: Firetoad
		Date: 31.08.2015	]]

function Burrowstrike( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("burrow_speed", ability_level)
	local burrow_time = (target - caster:GetAbsOrigin()):Length2D() / speed

	-- Store burrowstrike start/endpoints
	caster.burrow_start_point = caster:GetAbsOrigin()
	caster.burrow_end_point = target

	-- Remove caster from the world
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
	caster:AddNoDraw()

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- After the burrow time, reappear on the other side
	Timers:CreateTimer(burrow_time, function()
		FindClearSpaceForUnit(caster, target, true)
		caster:RemoveModifierByName(modifier_caster)
		caster:RemoveNoDraw()
	end)
end

function BurrowstrikeHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caustic = keys.modifier_caustic
	local ability_caustic = caster:FindAbilityByName(keys.ability_caustic)

	-- Parameters
	local knockback_duration = ability:GetLevelSpecialValueFor("burrow_anim_time", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("burrow_duration", ability_level)
	local knockback_distance = ability:GetLevelSpecialValueFor("knockback_distance", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Knockback geometry
	local knockback_height = 400
	local target_pos = target:GetAbsOrigin()
	local knockback_center = target_pos + ( caster.burrow_start_point - caster.burrow_end_point ):Normalized() * 1000

	-- Apply stun
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

	-- Apply caustic finale modifier
	if ability_caustic then
		ability_caustic:ApplyDataDrivenModifier(caster, target, modifier_caustic, {})
	end
	
	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Knockback
	local burrow_knockback = {
		should_stun = 1,
		knockback_duration = knockback_duration,
		duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
		center_x = knockback_center.x,
		center_y = knockback_center.y,
		center_z = knockback_center.z
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", burrow_knockback)
end

function SandStorm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_loop = keys.sound_loop
	local sound_darude = keys.sound_darude
	local particle_sandstorm = keys.particle_sandstorm
	local modifier_aura = keys.modifier_aura

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local radius_step = ability:GetLevelSpecialValueFor("radius_step", ability_level)
	local damage_step = ability:GetLevelSpecialValueFor("damage_step", ability_level)
	local max_radius = ability:GetLevelSpecialValueFor("max_radius", ability_level)
	local max_damage = ability:GetLevelSpecialValueFor("max_damage", ability_level)
	local invis_duration = ability:GetLevelSpecialValueFor("invis_duration", ability_level)
	local wind_force = ability:GetLevelSpecialValueFor("wind_force", ability_level)

	-- Sandstorm variables
	local caster_pos = caster:GetAbsOrigin()
	local current_radius = base_radius
	local current_time = 0
	local tick_rate = 0.03
	
	-- Create particle/sound dummy
	local sandstorm_dummy = CreateUnitByName("npc_dummy_unit", caster_pos, false, nil, nil, caster:GetTeamNumber())

	-- Play sounds
	EmitSoundOnLocationWithCaster(caster_pos, sound_cast, sandstorm_dummy)
	if RandomInt(1,100) <= 30 then
		sandstorm_dummy:EmitSound(sound_darude)
	else
		sandstorm_dummy:EmitSound(sound_loop)
	end

	-- Play particle
	local sandstorm_pfx = ParticleManager:CreateParticle(particle_sandstorm, PATTACH_ABSORIGIN, sandstorm_dummy)
	ParticleManager:SetParticleControl(sandstorm_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(sandstorm_pfx, 1, Vector(base_radius, base_radius, 0))

	-- Make the caster invisible
	caster:AddNewModifier(caster, ability, "modifier_invisible", {})
	caster:AddNewModifier(caster, ability, "modifier_phased", {})

	-- Play channeling animation
	StartAnimation(caster, {duration = 80, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 1.0})

	-- Set ability as inactive
	ability:SetActivated(false)

	-- Size update loop
	Timers:CreateTimer(0, function()

		-- If the ability is still being channeled, continue
		if ability:IsChanneling() then

			current_time = GameRules:GetGameTime() - ability:GetChannelStartTime()

			-- Update radius
			current_radius = math.min( base_radius + radius_step * current_time, max_radius)

			-- Update particle
			ParticleManager:SetParticleControl(sandstorm_pfx, 1, Vector(current_radius, current_radius, 0))

			-- Find enemies to damage
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

			-- Apply damage according to distance from the center
			for _,enemy in pairs(enemies) do
				local distance_to_center = ( enemy:GetAbsOrigin() - caster_pos ):Length2D()
				local damage = math.min(base_damage + current_time * damage_step - math.max( ( distance_to_center - base_radius ) * damage_step / radius_step, 0), max_damage)
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage / 2, damage_type = DAMAGE_TYPE_MAGICAL})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_aura, {duration = 0.5})
			end

			-- Loop again
			return 0.5

		-- Else, stop particle/sound and make the caster visible
		else
			sandstorm_dummy:StopSound(sound_loop)
			sandstorm_dummy:StopSound(sound_darude)
			sandstorm_dummy:Destroy()
			ParticleManager:DestroyParticle(sandstorm_pfx, false)
			caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = invis_duration})
			caster:RemoveModifierByName("modifier_phased")
			EndAnimation(caster)
		end
	end)
	
	-- Forced movement loop
	Timers:CreateTimer(0, function()

		-- Find enemies to move
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Move targets according to distance from the center
		for _,enemy in pairs(enemies) do
			local distance_to_center = ( enemy:GetAbsOrigin() - caster_pos ):Length2D()
			local enemy_wind_force = ( wind_force - math.max( ( distance_to_center - base_radius ) / ( max_radius - base_radius ) * wind_force, 0) ) * tick_rate
			local enemy_pos = enemy:GetAbsOrigin()
			local target_pos = RotatePosition(caster_pos, QAngle(0, -90, 0), caster_pos + ( enemy_pos - caster_pos ))
			if distance_to_center > 150 then
				FindClearSpaceForUnit(enemy, enemy_pos + ( target_pos - enemy_pos ):Normalized() * enemy_wind_force, true)
			else
				target_pos = RotatePosition(caster_pos, QAngle(0, -2, 0), caster_pos + ( enemy_pos - caster_pos ))
				FindClearSpaceForUnit(enemy, target_pos, true)
			end
			
		end

		if ability:IsChanneling() then
			return tick_rate
		end
	end)
end

function SandStormEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability_level)

	-- Activate ability
	ability:SetActivated(true)

	-- Trigger forced cooldown
	ability:StartCooldown(cooldown)
end

function CausticFinale( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_prevent = keys.modifier_prevent
	local modifier_slow = keys.modifier_slow
	local particle_1 = keys.particle_1
	local particle_2 = keys.particle_2

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local creep_damage = ability:GetLevelSpecialValueFor("creep_damage", ability_level)
	local initial_slow = ability:GetLevelSpecialValueFor("initial_slow", ability_level)
	local stacking_slow = ability:GetLevelSpecialValueFor("stacking_slow", ability_level)
	local target_pos = target:GetAbsOrigin()

	-- If recently affected by caustic, do nothing
	if target:HasModifier(modifier_prevent) or not ability then
		return nil
	end

	-- Apply caustic immunity modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_prevent, {})

	-- Fire particles
	local pulse_pfx_1 = ParticleManager:CreateParticle(particle_1, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(pulse_pfx_1, 0, target_pos + Vector(0,0,100))
	Timers:CreateTimer(0.1, function()
		local pulse_pfx_2 = ParticleManager:CreateParticle(particle_2, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(pulse_pfx_2, 0, target_pos)
		ParticleManager:SetParticleControl(pulse_pfx_2, 1, Vector(radius * 2, 0, 425))
	end)

	-- Find and iterate through nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do

		-- Damage
		if enemy:IsHero() then
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		else
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = creep_damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end

		-- Slow
		if enemy:HasModifier(modifier_slow) then
			AddStacks(ability, caster, enemy, modifier_slow, stacking_slow, true)
		else
			AddStacks(ability, caster, enemy, modifier_slow, initial_slow, true)
		end
	end
end

function EpicenterChannel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_caster = keys.modifier_caster
	local sound_cast = keys.sound_cast
	local sound_darude = keys.sound_darude
	
	-- Apply particle modifier to caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Play channeling animation
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
	Timers:CreateTimer(2.1, function()
		if ability:IsChanneling() then
			StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})
			print("hey! listen!")
		end
	end)

	-- Play cast sounds for the caster's team
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)
	caster:EmitSound(sound_darude)

	-- Store channeling start time
	caster.epicenter_channel_start_time = GameRules:GetGameTime()
end

function Epicenter( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster
	local modifier_slow = keys.modifier_slow
	local sound_epicenter = keys.sound_epicenter
	local sound_darude = keys.sound_darude
	local particle_epicenter = keys.particle_epicenter
	local scepter = HasScepter(caster)

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local step_radius = ability:GetLevelSpecialValueFor("step_radius", ability_level)
	local max_pulses = ability:GetLevelSpecialValueFor("max_pulses", ability_level)
	local pulse_duration = ability:GetLevelSpecialValueFor("pulse_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local pull_scepter = ability:GetLevelSpecialValueFor("pull_scepter", ability_level) * 0.03
	local pull_radius_scepter = ability:GetLevelSpecialValueFor("pull_radius_scepter", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	if scepter then
		max_pulses = ability:GetLevelSpecialValueFor("max_pulses_scepter", ability_level)
	end

	-- Stop cast animation + particle
	caster:RemoveModifierByName(modifier_caster)
	EndAnimation(caster)

	-- Play epicenter sound
	caster:EmitSound(sound_epicenter)

	-- Fetch channeling time
	local channel_time = GameRules:GetGameTime() - caster.epicenter_channel_start_time
	caster.epicenter_channel_start_time = nil

	-- If not channeled to the maximum, stop darude - sandstorm
	if channel_time < 4 then
		caster:StopSound(sound_darude)
	end

	-- Pulse parameters
	local current_pulse = 0
	local total_pulses = math.floor( max_pulses * channel_time / 4 )
	local pulse_interval = pulse_duration / total_pulses
	pull_scepter = pull_scepter * channel_time / 4
	local pulse_ended = false

	-- Make caster and particle visible for the duration
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, total_pulses * pulse_interval)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, total_pulses * pulse_interval)

	-- Pulse creation loop
	Timers:CreateTimer(0.25, function()

		-- Update pulse size, position and count
		current_pulse = current_pulse + 1
		caster_loc = caster:GetAbsOrigin()
		local current_radius = base_radius + current_pulse * step_radius

		-- Play particle
		local epicenter_pfx = ParticleManager:CreateParticle(particle_epicenter, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(epicenter_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(epicenter_pfx, 1, Vector(current_radius, current_radius, 0))

		-- Apply damage and slow to nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			if ability then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- If there were enough pulses, stop
		if ability and current_pulse < total_pulses then
			return pulse_interval
		else
			pulse_ended = true
			caster:StopSound(sound_epicenter)
		end
	end)

	-- Scepter pull loop
	if scepter then
		Timers:CreateTimer(0, function()
			local scepter_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, pull_radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(scepter_enemies) do
				if ( enemy:GetAbsOrigin() - caster_loc ):Length2D() > 100 then
					FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin() + (caster_loc - enemy:GetAbsOrigin()):Normalized() * pull_scepter * ( ( caster_loc - enemy:GetAbsOrigin() ):Length2D() * 3 ) / pull_radius_scepter, true)
				end
			end
			if not pulse_ended then
				return 0.03
			end
		end)
	end
end

function ScepterCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		local modifier_check = keys.modifier_check
		local epicenter_name = keys.epicenter_name

		caster:RemoveModifierByName(modifier_check)
		SwitchAbilities(caster, epicenter_name.."_scepter", epicenter_name, true, true)
	else
		return nil
	end
end

function ScepterLostCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		return nil
	else
		local modifier_check = keys.modifier_check
		local epicenter_name = keys.epicenter_name

		caster:RemoveModifierByName(modifier_check)
		SwitchAbilities(caster, epicenter_name, epicenter_name.."_scepter", true, true)
	end
end