--[[	Authors: Hewdraw & Firetoad
		Date: 05.05.2015			]]

function TorrentBubble( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

	-- Sound and particle
	local particle_name = keys.particle_name
	local sound_name = keys.sound_name

	-- Plays the particle for the caster's team
	local bubbles_pfx = ParticleManager:CreateParticleForTeam(particle_name, PATTACH_ABSORIGIN, caster, caster:GetTeam())
	ParticleManager:SetParticleControl(bubbles_pfx, 0, target )

	-- Plays the sound for the caster's team
	EmitSoundOnLocationForAllies(target, sound_name, caster)
	
	-- Destroy particle after delay
	Timers:CreateTimer(delay, function()
		ParticleManager:DestroyParticle(bubbles_pfx, false)
	end)
end

function Torrent( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local ability_level = ability:GetLevel() - 1

	-- Ability parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)
	local height = ability:GetLevelSpecialValueFor("torrent_height", ability_level)
	local max_ticks = ability:GetLevelSpecialValueFor("tick_count", ability_level)
	local tsunami_damage = ability:GetLevelSpecialValueFor("tsunami_damage", ability_level)

	-- Modifiers and effects
	local particle_name = keys.particle_name
	local sound_name = keys.sound_name
	local modifier_high_tide = keys.modifier_high_tide
	local modifier_tsunami = keys.modifier_tsunami
	local modifier_wave_break = keys.modifier_wave_break
	local modifier_slow = keys.modifier_slow
	local modifier_phase = keys.modifier_phase

	-- Modifies parameters according to the current Tidebringer buff
	if caster:HasModifier(modifier_high_tide) then
		modifier_slow = keys.modifier_high_tide_slow
	end
	if caster:HasModifier(modifier_tsunami) then
		damage = damage + tsunami_damage
	end
	if caster:HasModifier(modifier_wave_break) then
		delay = 0
	end

	-- Calculates the damage to deal per tick
	local tick_interval = duration / max_ticks
	local damage_tick = damage / (2 * max_ticks)

	-- After [delay], applies damage, knockback, and draws the particle
	Timers:CreateTimer(delay, function()

		-- Finds affected enemies
		local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
		
		-- Iterate through affected enemies
		for _,enemy in pairs(enemies) do

			-- Deals the initial damage
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage / 2, damage_type = ability:GetAbilityDamageType()})
			local current_ticks = 0
			
			-- Calculates the knockback position (for Tsunami)
			local torrent_border = ( enemy:GetAbsOrigin() - target ):Normalized() * ( radius + 100 )
			local distance_from_center = ( enemy:GetAbsOrigin() - target ):Length2D()
			if not caster:HasModifier(modifier_tsunami) then
				distance_from_center = 0
			end

			-- Knocks the target up
			local knockback =
			{	should_stun = 1,
				knockback_duration = duration,
				duration = duration,
				knockback_distance = distance_from_center,
				knockback_height = height,
				center_x = (target + torrent_border).x,
				center_y = (target + torrent_border).y,
				center_z = (target + torrent_border).z
			}

			-- Applies the phasing and knockback modifiers
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_phase, {})
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, ability, "modifier_knockback", knockback)

			-- Deals tick damage [max_ticks] times
			Timers:CreateTimer(function()
				if current_ticks < max_ticks then
					ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage_tick, damage_type = ability:GetAbilityDamageType()})
					current_ticks = current_ticks + 1
					return tick_interval
				end
			end)

			-- Applies the slow
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
		end

		-- Creates the post-ability vision node and sound effect
		ability:CreateVisibilityNode(target, radius, vision_duration)
		local dummy = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
		EmitSoundOn(sound_name, dummy)

		-- Draws the particle
		local torrent_fx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControl(torrent_fx, 0, target)

		-- Destroy the dummy
		Timers:CreateTimer(duration, function()
			dummy:Destroy()
		end)
	end)
end

function TidebringerCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local modifier_name = keys.modifier_name
	local modifier_tidebringer = keys.modifier_tidebringer
	local cooldown = ability:GetCooldownTimeRemaining()

	-- If the skill has finished its cooldown and no modifiers are present, apply one at random when able
	if cooldown == 0 and not caster:HasModifier(modifier_name) and not caster:HasModifier(modifier_tidebringer) and not caster:IsOutOfGame() and not caster:IsInvulnerable() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_name, {})
	end
end

function TidebringerStartCooldown( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )

	-- Modifiers
	local modifier_tsunami = keys.modifier_tsunami
	local modifier_wave_break = keys.modifier_wave_break
	local modifier_high_tide = keys.modifier_high_tide
	local modifier_low_tide = keys.modifier_low_tide

	-- If the target was an enemy, start the cooldown
	if target:GetTeam() ~= caster:GetTeam() then
		caster:RemoveModifierByName(modifier_tsunami)
		caster:RemoveModifierByName(modifier_high_tide)
		caster:RemoveModifierByName(modifier_low_tide)

		-- If the caster has the Wave Break buff, do not start the cooldown
		if caster:HasModifier(modifier_wave_break) then
			caster:RemoveModifierByName(modifier_wave_break)
		else
			ability:StartCooldown(cooldown)
		end
	end
end

function TidebringerTsunami( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

	-- If the target being hit is from the same team, do nothing
	if target:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Particles and modifiers
	local particle_name = keys.particle_name
	local modifier_knockup = keys.modifier_knockup
	
	-- Calculates the AOE's center point and affected enemies
	local effect_center = caster:GetAbsOrigin() + caster:GetForwardVector() * radius
	local enemies = FindUnitsInRadius(caster:GetTeam(), effect_center, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)

	-- Draws the particle only once
	local torrent_fx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(torrent_fx, 0, effect_center)
	ParticleManager:SetParticleControl(torrent_fx, 1, Vector(radius, 0, 0))

	-- Applies knockback to each enemy
	if target:GetTeam() ~= caster:GetTeam() then
		for _,enemy in pairs(enemies) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_knockup, {})
		end
	end
end

function XmarksCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local target_loc = target:GetAbsOrigin()
	local return_name = keys.return_name
	
	-- Set x marks origin point
	caster.x_marks_target = target
	caster.x_marks_origin = target_loc
	
	-- Swap x marks with return 
	caster:SwapAbilities(ability:GetAbilityName(), return_name, false, true)
end

function XmarksReturn( keys )
	local caster = keys.caster
	local x_marks_name = keys.x_marks_name
	local return_name = keys.return_name
	local modifier_name = keys.modifier_name
	
	-- Check if there is a target unit
	if caster.x_marks_target and caster.x_marks_origin then
		FindClearSpaceForUnit(caster.x_marks_target, caster.x_marks_origin, true)
		caster.x_marks_target = nil
		caster.x_marks_origin = nil
	end
	
	-- Swap abilities
	caster:SwapAbilities(x_marks_name, return_name, true, false )
end

function LevelUpReturn( keys )
	local caster = keys.caster		
	local ability_name = keys.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	

	-- Upgrades Return to level 1 if it hasn't already
	ability_handle:SetLevel(1)
end

function XmarksForcedReturn( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName(keys.x_marks_name)
	local modifier_name = keys.modifier_name
	local radius = ability:GetLevelSpecialValueFor("return_range" , ability:GetLevel() - 1 )

	if caster.x_marks_target and caster.x_marks_origin then
		local units
		local target = caster.x_marks_target
		local origin = caster.x_marks_origin
		if target:GetTeam() == caster:GetTeam() then
			units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		else
			units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		end
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, origin, true)
		end

		-- Removes the x marks modifier from the original target, triggering XmarksReturn()
		target:RemoveModifierByName(modifier_name)
	end
end

function GhostShip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Particles and sounds
	local particle_name = keys.particle_name
	local projectile_name = keys.projectile_name
	local crash_sound = keys.crash_sound

	-- Parameters
	local spawn_distance = ability:GetLevelSpecialValueFor("spawn_distance", ability_level)
	local crash_distance = ability:GetLevelSpecialValueFor("crash_distance", ability_level)
	local ship_speed = ability:GetLevelSpecialValueFor("ghostship_speed", ability_level)
	local ship_radius = ability:GetLevelSpecialValueFor("ghostship_width", ability_level)
	local crash_delay = ability:GetLevelSpecialValueFor("tooltip_delay", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local crash_damage = ability:GetLevelSpecialValueFor("crash_damage", ability_level)

	-- Scepter parameters
	local scepter = HasScepter(caster)
	if scepter then
		spawn_distance = ability:GetLevelSpecialValueFor("spawn_distance_scepter", ability_level)
		ship_speed = ability:GetLevelSpecialValueFor("ghostship_speed_scepter", ability_level)
	end

	-- Calculate spawn and crash positions
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = keys.target_points[1]
	local boat_direction = ( target_pos - caster_pos ):Normalized()
	local crash_pos = caster_pos + boat_direction * crash_distance
	local spawn_pos = caster_pos + boat_direction * spawn_distance * (-1)

	-- Persistent target point (for OnABoat function)
	caster.ghostship_crash_pos = crash_pos

	-- Show visual crash point effect to allies only
	local crash_pfx = ParticleManager:CreateParticleForTeam(particle_name, PATTACH_ABSORIGIN, caster, caster:GetTeam())
	ParticleManager:SetParticleControl(crash_pfx, 0, crash_pos )

	-- Destroy particle after the crash
	Timers:CreateTimer(crash_delay, function()
		ParticleManager:DestroyParticle(crash_pfx, false)
	end)

	-- Spawn the boat projectile
	local boat_projectile = {
		Ability = ability,
		EffectName = projectile_name,
		vSpawnOrigin = spawn_pos,
		fDistance = spawn_distance + crash_distance - ship_radius,
		fStartRadius = ship_radius,
		fEndRadius = ship_radius,
		fExpireTime = GameRules:GetGameTime() + crash_delay + 2,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = ability:GetAbilityTargetTeam(),
		iUnitTargetType = ability:GetAbilityTargetType(),
		vVelocity = boat_direction * ship_speed
	}

	ProjectileManager:CreateLinearProjectile(boat_projectile)
	
	-- After [crash_delay], apply damage and stun in the target area
	Timers:CreateTimer(crash_delay, function()
		
		-- Fire sound on crash point
		local dummy = CreateUnitByName("npc_dummy_unit", crash_pos, false, caster, caster, caster:GetTeamNumber() )
		EmitSoundOn(crash_sound, dummy)
		dummy:Destroy()
		
		-- Stun and damage enemies
		local enemies = FindUnitsInRadius(caster:GetTeam(), crash_pos, nil, ship_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)
		for k, enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = crash_damage, damage_type = ability:GetAbilityDamageType()})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", { duration = stun_duration })
		end
	end)
end

function OnABoat( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local crash_distance = ability:GetLevelSpecialValueFor("crash_distance", ability_level)
	local ship_speed = ability:GetLevelSpecialValueFor("ghostship_speed", ability_level)
	local impact_damage = ability:GetLevelSpecialValueFor("impact_damage", ability_level)
	local modifier_rum = keys.modifier_rum

	-- Scepter parameters
	local scepter = HasScepter(caster)
	if scepter then
		ship_speed = ability:GetLevelSpecialValueFor("ghostship_speed_scepter", ability_level)
		modifier_rum = keys.modifier_rum_scepter
	end

	-- If the target is an ally, apply the rum buff and exit the function
	if caster:GetTeam() == target:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_rum, {})
		return nil
	end

	-- Retrieve crash position and calculate knockback parameters
	local crash_pos = caster.ghostship_crash_pos
	local target_pos = target:GetAbsOrigin()
	local knockback_origin = target_pos + (target_pos - crash_pos):Normalized() * 100
	local distance = (crash_pos - target_pos):Length2D()
	local duration = distance / ship_speed

	-- Apply the knockback modifier and deal impact damage
	local knockback =
	{	should_stun = 1,
		knockback_duration = duration,
		duration = duration,
		knockback_distance = distance,
		knockback_height = 0,
		center_x = knockback_origin.x,
		center_y = knockback_origin.y,
		center_z = knockback_origin.z
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, nil, "modifier_knockback", knockback)
	ApplyDamage({victim = target, attacker = caster, ability = ability, damage = impact_damage, damage_type = ability:GetAbilityDamageType()})
end

function GhostShipRegisterDamage( keys )
	local target = keys.unit
	local ability = keys.ability
	local damage_taken = keys.damage_taken
	local rum_reduce_pct = ability:GetLevelSpecialValueFor("rum_reduce_pct", ability:GetLevel() - 1 ) * (-1) / 100

	if not target.ghostship_damage_prevented then
		target.ghostship_damage_prevented = 0
	end
	
	target.ghostship_damage_prevented = target.ghostship_damage_prevented + damage_taken * rum_reduce_pct / (1 - rum_reduce_pct)
end

function GhostShipRegisterDamageScepter( keys )
	local target = keys.unit
	local ability = keys.ability
	local damage_taken = keys.damage_taken
	local rum_reduce_pct = ability:GetLevelSpecialValueFor("rum_reduce_pct_scepter", ability:GetLevel() - 1 ) * (-1) / 100

	if not target.ghostship_damage_prevented then
		target.ghostship_damage_prevented = 0
	end
	
	target.ghostship_damage_prevented = target.ghostship_damage_prevented + damage_taken * rum_reduce_pct / (1 - rum_reduce_pct)
end

function GhostShipDelayedDamage( keys )
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Initialize the variable in case the unit took no damage
	if not target.ghostship_damage_prevented then
		target.ghostship_damage_prevented = 0
	end

	-- Parameters
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability_level)
	local damage_duration = ability:GetLevelSpecialValueFor("buff_duration", ability_level)
	local max_ticks = damage_duration / damage_interval
	local current_ticks = 0
	local damage_per_tick = target.ghostship_damage_prevented / max_ticks
	
	-- Deal the prevented damage over time
	Timers:CreateTimer(damage_interval, function()

		-- Nonlethal HP removal
		local target_hp = target:GetHealth()
		if target_hp - damage_per_tick < 1 then
			target:SetHealth(1)
		else
			target:SetHealth(target_hp - damage_per_tick)
		end
		
		-- Check if all the damage has been dealt, if yes, reset the global variable
		current_ticks = current_ticks + 1
		if current_ticks >= max_ticks then
			target.ghostship_damage_prevented = nil
			return nil
		else
			return damage_interval
		end
	end)
end