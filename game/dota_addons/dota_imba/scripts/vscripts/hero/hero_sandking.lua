--[[	Author: Firetoad
		Date: 31.08.2015	]]

function Burrowstrike( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("burrow_speed", ability_level)

	-- Store burrowstrike end point
	caster.burrow_end_point = target

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Reappear on the other side
	FindClearSpaceForUnit(caster, target, true)
end

function BurrowstrikeHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_sands = keys.modifier_sands

	-- Parameters
	local knockback_duration = ability:GetLevelSpecialValueFor("burrow_anim_time", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("burrow_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Knockback towards end point if Treacherous Sands is on, just knock up otherwise
	local knockback_target_loc = target:GetAbsOrigin()
	if caster:HasModifier(modifier_sands) then
		knockback_target_loc = caster.burrow_end_point
	end

	-- Apply stun
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- If the knockback target location is inside the enemy fountain, do nothing
	if IsNearEnemyFountain(knockback_target_loc, target:GetTeam(), 1700) then
		return nil
	end

	-- Knockback geometry
	local target_loc = target:GetAbsOrigin()
	local knockback_height = 350
	local knockback_center = target_loc + ( target_loc - knockback_target_loc ):Normalized() * 1000
	local knockback_distance = (knockback_target_loc - target_loc):Length2D()

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
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local max_duration = ability:GetLevelSpecialValueFor("max_duration", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	
	-- Create particle/sound dummy
	caster.sandstorm_dummy = CreateUnitByName("npc_dummy_unit", caster_loc, false, nil, nil, caster:GetTeamNumber())

	-- Play sounds
	caster.sandstorm_dummy:EmitSound(sound_cast)
	if USE_MEME_SOUNDS and RandomInt(1, 100) <= 20 then
		caster.sandstorm_dummy:EmitSound(sound_darude)
	else
		caster.sandstorm_dummy:EmitSound(sound_loop)
	end

	-- Play particle
	caster.sandstorm_pfx = ParticleManager:CreateParticle(particle_sandstorm, PATTACH_ABSORIGIN, caster.sandstorm_dummy)
	ParticleManager:SetParticleControl(caster.sandstorm_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(caster.sandstorm_pfx, 1, Vector(radius, radius, 0))

	-- Make the caster invisible and phased
	caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = max_duration})
	caster:AddNewModifier(caster, ability, "modifier_phased", {duration = max_duration})

	-- Play channeling animation
	StartAnimation(caster, {duration = max_duration, activity = ACT_DOTA_OVERRIDE_ABILITY_2, rate = 1.0})

	-- Destroy trees in the skill radius
	GridNav:DestroyTreesAroundPoint(caster_loc, radius + 50, false)

	-- Apply caster modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
end

function SandStormChannelEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_loop = keys.sound_loop
	local sound_darude = keys.sound_darude
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local invis_duration = ability:GetLevelSpecialValueFor("invis_duration", ability_level)

	-- Stop sounds
	caster.sandstorm_dummy:StopSound(sound_loop)
	caster.sandstorm_dummy:StopSound(sound_darude)
	caster.sandstorm_dummy:Destroy()
	caster.sandstorm_dummy = nil

	-- Stop channeling animation
	EndAnimation(caster)

	-- Destroy particle
	ParticleManager:DestroyParticle(caster.sandstorm_pfx, false)
	ParticleManager:ReleaseParticleIndex(caster.sandstorm_pfx)
	caster.sandstorm_pfx = nil

	-- Add residual invisibility and phased movement
	caster:RemoveModifierByName("modifier_invisible")
	caster:RemoveModifierByName("modifier_phased")
	caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = invis_duration})
	caster:AddNewModifier(caster, ability, "modifier_phased", {duration = invis_duration})

	-- Remove caster thinker modifier
	caster:RemoveModifierByName(modifier_caster)
end

function SandStormTick( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_sands = keys.modifier_sands

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local wind_force = ability:GetLevelSpecialValueFor("wind_force", ability_level)
	local damage_tick = ability:GetLevelSpecialValueFor("damage_tick", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Affect nearby enemies
	for _,enemy in pairs(enemies) do
		
		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage * damage_tick, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Calculate movement, if necessary
		if caster:HasModifier(modifier_sands) then
			local enemy_loc = enemy:GetAbsOrigin()
			local enemy_distance = (enemy_loc - caster_loc):Length2D()

			-- Move enemies who aren't too close, or already moving
			if enemy_distance > 160 and not IsUninterruptableForcedMovement(enemy) then
				local enemy_knockback_origin = enemy_loc + (enemy_loc - caster_loc):Normalized() * 100
				local sand_storm_knockback = {
					should_stun = 0,
					knockback_duration = 0.03,
					duration = 0.03,
					knockback_distance = wind_force,
					knockback_height = 0,
					center_x = enemy_knockback_origin.x,
					center_y = enemy_knockback_origin.y,
					center_z = enemy_knockback_origin.z
				}
				enemy:RemoveModifierByName("modifier_knockback")
				enemy:AddNewModifier(caster, ability, "modifier_knockback", sand_storm_knockback)
			end
		end
	end
end

function CausticFinale( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local modifier_prevent = keys.modifier_prevent

	-- If the target is an ally, or already has the debuff, or has the prevention debuff, do nothing
	if target:GetTeam() == caster:GetTeam() or target:HasModifier(modifier_debuff) or target:HasModifier(modifier_prevent) then
		return nil
	end

	-- If caster's passives are disabled by break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end
	
	-- Else, apply it
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
end

function CausticFinaleEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff
	local modifier_prevent = keys.modifier_prevent
	local modifier_slow = keys.modifier_slow
	local particle_explode = keys.particle_explode
	local sound_explode = keys.sound_explode

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local target_pos = target:GetAbsOrigin()

	-- Play sound
	target:EmitSound(sound_explode)

	-- Fire particle
	local explosion_pfx = ParticleManager:CreateParticle(particle_explode, PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(explosion_pfx, 0, target_pos)
	ParticleManager:ReleaseParticleIndex(explosion_pfx)

	-- Find and iterate through nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do

		-- Deal damage
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_prevent, {})
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		enemy:RemoveModifierByName(modifier_prevent)

		-- Slow
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})

		-- Chain reaction
		if enemy:HasModifier(modifier_debuff) then
			enemy:RemoveModifierByName(modifier_debuff)
		end
	end
end

function SandsOn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_sands = keys.modifier_sands

	caster.treacherous_sands_toggle_state = 1
	ability:ApplyDataDrivenModifier(caster, caster, modifier_sands, {})

	-- Re-apply invisibility if channeling sandstorm
	if caster:HasModifier("modifier_imba_sandstorm_caster") then
		local duration = caster:FindModifierByName("modifier_phased"):GetRemainingTime()
		if duration > 0 then
			caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = duration})
		end
	end
end

function SandsOff( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_sands = keys.modifier_sands

	if caster:IsAlive() then
		caster.treacherous_sands_toggle_state = 0
		caster:RemoveModifierByName(modifier_sands)
	end

	-- Re-apply invisibility if channeling sandstorm
	if caster:HasModifier("modifier_imba_sandstorm_caster") then
		local duration = caster:FindModifierByName("modifier_phased"):GetRemainingTime()
		if duration > 0 then
			caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = duration})
		end
	end
end

function SandsRespawnToggle( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Create the toggle state variable, if necessary
	if not caster.treacherous_sands_toggle_state then
		caster.treacherous_sands_toggle_state = 1
	end

	-- Turns the ability back on after death, if appropriate
	if caster.treacherous_sands_toggle_state == 1 then
		ability:ToggleAbility()
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
		end
	end)

	-- Play cast sounds
	caster:EmitSound(sound_cast)
	if USE_MEME_SOUNDS then
		caster:EmitSound(sound_darude)
	end

	-- Store channeling start time
	caster.epicenter_channel_start_time = GameRules:GetGameTime()
end

function Epicenter( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster
	local modifier_slow = keys.modifier_slow
	local modifier_sands = keys.modifier_sands
	local sound_epicenter = keys.sound_epicenter
	local sound_darude = keys.sound_darude
	local particle_epicenter = keys.particle_epicenter
	local scepter = HasScepter(caster)

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local step_radius = ability:GetLevelSpecialValueFor("step_radius", ability_level)
	local max_radius = ability:GetLevelSpecialValueFor("max_radius", ability_level)
	local max_pulses = ability:GetLevelSpecialValueFor("max_pulses", ability_level)
	local pulse_duration = ability:GetLevelSpecialValueFor("pulse_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local pull_strength = ability:GetLevelSpecialValueFor("pull_strength", ability_level)
	local pull_radius = ability:GetLevelSpecialValueFor("pull_radius", ability_level)
	local caster_loc = caster:GetAbsOrigin()

	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
		pull_radius = ability:GetLevelSpecialValueFor("pull_radius_scepter", ability_level)
	end

	-- Add level-based pulses
	if caster:IsHero() then
		local caster_level = caster:GetLevel()
		max_pulses = max_pulses + math.floor( caster_level / ability:GetLevelSpecialValueFor("levels_per_pulse", ability_level) )
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
	local pulse_interval = math.max( pulse_duration / total_pulses, 0.17)

	-- Make caster and particle visible for the duration
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, total_pulses * pulse_interval)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, total_pulses * pulse_interval)

	-- Pulse creation loop
	Timers:CreateTimer(0.01, function()

		-- Update pulse size, position and count
		current_pulse = current_pulse + 1
		caster_loc = caster:GetAbsOrigin()
		local current_radius = math.min( base_radius + current_pulse * step_radius, max_radius)

		-- Play particle
		local epicenter_pfx = ParticleManager:CreateParticle(particle_epicenter, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(epicenter_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(epicenter_pfx, 1, Vector(current_radius, current_radius, 0))
		ParticleManager:ReleaseParticleIndex(epicenter_pfx)

		-- Apply damage and slow to nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			if ability then
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- If Treacherous Sands is toggled on, and the caster has a scepter, pull enemies inwards
		if caster:HasModifier(modifier_sands) then
			local pull_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, pull_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(pull_enemies) do

				local enemy_loc = enemy:GetAbsOrigin()
				local enemy_distance = (enemy_loc - caster_loc):Length2D()

				-- Move enemies who aren't too close, or already moving
				if enemy_distance > 160 and not IsUninterruptableForcedMovement(enemy) then
					local enemy_knockback_origin = enemy_loc + (enemy_loc - caster_loc):Normalized() * 100
					local epicenter_knockback = {
						should_stun = 0,
						knockback_duration = 0.03,
						duration = 0.03,
						knockback_distance = pull_strength,
						knockback_height = 0,
						center_x = enemy_knockback_origin.x,
						center_y = enemy_knockback_origin.y,
						center_z = enemy_knockback_origin.z
					}
					enemy:RemoveModifierByName("modifier_knockback")
					enemy:AddNewModifier(caster, ability, "modifier_knockback", epicenter_knockback)
				end
			end
		end

		-- Destroy trees in the effect radius
		GridNav:DestroyTreesAroundPoint(caster_loc, current_radius + 50, false)

		-- If there were enough pulses, stop
		if ability and current_pulse < total_pulses then
			return pulse_interval
		else
			caster:StopSound(sound_epicenter)
		end
	end)
end