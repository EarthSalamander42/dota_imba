--[[	Authors: Hewdraw & Firetoad
		Date: 05.05.2015			]]

function TorrentBubble( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor( "vision_duration", ability_level)
	
	-- Grant vision on the target area
	ability:CreateVisibilityNode(target, radius, vision_duration)

	-- Sound and particle
	local particle_name = keys.particle_name
	local sound_name = keys.sound_name

	-- Plays the particle for the caster's team
	local bubbles_pfx = ParticleManager:CreateParticleForTeam(particle_name, PATTACH_ABSORIGIN, caster, caster:GetTeam())
	ParticleManager:SetParticleControl(bubbles_pfx, 0, target)

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
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
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
	local damage_tick = damage / max_ticks

	-- After [delay], applies damage, knockback, and draws the particle
	Timers:CreateTimer(delay, function()

		-- Finds affected enemies
		local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
		
		-- Iterate through affected enemies
		for _,enemy in pairs(enemies) do

			-- Deals the initial damage
			ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage_tick, damage_type = ability:GetAbilityDamageType()})
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

		-- Creates the post-ability sound effect
		local dummy = CreateUnitByName("npc_dummy_unit", target, false, caster, caster, caster:GetTeamNumber() )
		dummy:EmitSound(sound_name)

		-- Draws the particle
		local torrent_fx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, dummy)
		ParticleManager:SetParticleControl(torrent_fx, 0, target)

		-- Destroy the dummy
		Timers:CreateTimer(duration, function()
			dummy:Destroy()
		end)
	end)
end

function TidebringerLevelUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_tidebringer = keys.modifier_tidebringer
	local sound_cooldown = keys.sound_cooldown
	local particle_weapon = keys.particle_weapon

	-- If this is the first time learning the ability, activate Tidebringer
	if ability:GetLevel() == 1 then
		
		-- Play sound on caster's client only
		caster:EmitSound(sound_cooldown)

		-- Create weapon particle
		caster.tidebringer_weapon_pfx = ParticleManager:CreateParticle(particle_weapon, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster:GetAbsOrigin(), true)

		-- Apply the on-hit modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier_tidebringer, {})
	end
end

function TidebringerToggle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_tidebringer = keys.modifier_tidebringer
	local sound_cooldown = keys.sound_cooldown
	local particle_weapon = keys.particle_weapon

	-- If Tidebringer is inactive, activate it
	if not caster:HasModifier(modifier_tidebringer) then
		-- Play sound on caster's client only
		caster:EmitSound(sound_cooldown)

		-- Create weapon particle
		caster.tidebringer_weapon_pfx = ParticleManager:CreateParticle(particle_weapon, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster:GetAbsOrigin(), true)

		-- Apply the on-hit modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier_tidebringer, {})

	-- Else, deactivate it
	else
		-- Destroy particle
		ParticleManager:DestroyParticle(caster.tidebringer_weapon_pfx, true)
		ParticleManager:ReleaseParticleIndex(caster.tidebringer_weapon_pfx)
		caster.tidebringer_weapon_pfx = nil

		-- Remove the on-hit modifier
		caster:RemoveModifierByName(modifier_tidebringer)
	end
end

function TidebringerDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_high_tide = keys.modifier_high_tide
	local modifier_damage = keys.modifier_damage

	-- If this is Rubick and Tidebringer is no longer present, do nothing and kill the modifiers
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_kunkka_tidebringer") then
			caster:RemoveModifierByName("modifier_imba_tidebringer")
			caster:RemoveModifierByName("modifier_imba_tidebringer_damage")
			caster:RemoveModifierByName("modifier_imba_tidebringer_high_tide")
			caster:RemoveModifierByName("modifier_imba_tidebringer_wave_break")
			caster:RemoveModifierByName("modifier_imba_tidebringer_tsunami")
			return nil
		end
	end

	-- Verify high tide
	local high_tide = caster:HasModifier(modifier_high_tide)

	-- Apply the bonus damage modifier
	if high_tide then
		caster:SetModifierStackCount(modifier_damage, caster, 2)
	else
		caster:SetModifierStackCount(modifier_damage, caster, 1)
	end
end

function Tidebringer( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local sound_attack = keys.sound_attack
	local sound_hit = keys.sound_hit
	local particle_cleave = keys.particle_cleave
	local particle_tsunami = keys.particle_tsunami
	local modifier_high_tide = keys.modifier_high_tide
	local modifier_wave_break = keys.modifier_wave_break
	local modifier_tsunami = keys.modifier_tsunami
	local modifier_particle = keys.modifier_particle
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local tsunami_height = ability:GetLevelSpecialValueFor("tsunami_height", ability_level)
	local tsunami_duration = ability:GetLevelSpecialValueFor("tsunami_duration", ability_level)
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability_level)

	-- Calculate geometry
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	local cleave_center_loc = caster_loc + (target_loc - caster_loc):Normalized() * radius

	-- Verify and clear tides
	local wave_break = caster:HasModifier(modifier_wave_break)
	local tsunami = caster:HasModifier(modifier_tsunami)
	caster:RemoveModifierByName(modifier_high_tide)
	caster:RemoveModifierByName(modifier_wave_break)
	caster:RemoveModifierByName(modifier_tsunami)

	-- Roll for new tides
	if RandomInt(1, 100) <= proc_chance then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_high_tide, {})
	end
	if RandomInt(1, 100) <= proc_chance then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_wave_break, {})
	end
	if RandomInt(1, 100) <= proc_chance then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_tsunami, {})
	end

	-- Fetch the total attack damage
	local attack_damage = caster:GetAverageTrueAttackDamage(caster)

	-- Play attack sound
	caster:EmitSound(sound_attack)

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Play cleave particle
	local tidebringer_target_particle_count = 2
	local tidebringer_pfx = ParticleManager:CreateParticle(particle_cleave, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(tidebringer_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(tidebringer_pfx, 1, target:GetAbsOrigin())

	-- Prepare Tsunami
	if tsunami then

		-- Play particle
		local tsunami_pfx = ParticleManager:CreateParticle(particle_tsunami, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(tsunami_pfx, 0, cleave_center_loc)
		ParticleManager:ReleaseParticleIndex(tsunami_pfx)
	end

	-- Initialize knockup
	local tsunami_knockback =	{
		should_stun = 1,
		knockback_duration = tsunami_duration,
		duration = tsunami_duration,
		knockback_distance = 0,
		knockback_height = tsunami_height,
		center_x = target_loc.x,
		center_y = target_loc.y,
		center_z = target_loc.z
	}

	-- Put the ability on cooldown
	local tidebringer_cooldown = cooldown * GetCooldownReduction(caster)
	if wave_break then
		tidebringer_cooldown = 0.1
	end
	ability:StartCooldown(tidebringer_cooldown)

	-- Destroy "ability ready" particle and play it again with sound after [tidebringer cooldown]
	caster:RemoveModifierByName(modifier_particle)
	Timers:CreateTimer(tidebringer_cooldown, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_particle, {})
	end)

	-- Iterate through enemies in the cleave area
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), cleave_center_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		
		-- Affect enemies
		if enemy ~= target and not enemy:IsAttackImmune() then

			-- Perform an attack
			local enemy_loc = enemy:GetAbsOrigin()
			caster:SetAbsOrigin(enemy_loc)
			caster:PerformAttack(enemy, true, true, true, true, true)
			caster:SetAbsOrigin(caster_loc)

			-- Sound and particle
			enemy:EmitSound(sound_hit)
			if tidebringer_target_particle_count <= 16 then
				ParticleManager:SetParticleControl(tidebringer_pfx, tidebringer_target_particle_count, enemy_loc)
				tidebringer_target_particle_count = tidebringer_target_particle_count + 1
			end
		end

		-- Tsunami knock-up
		if tsunami then
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, ability, "modifier_knockback", tsunami_knockback)
		end
	end

	-- Release Tidebringer particle index
	ParticleManager:ReleaseParticleIndex(tidebringer_pfx)
end

function XmarksCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_return = keys.ability_return
	local modifier_caster = keys.modifier_caster
	local modifier_duration = keys.modifier_duration
	local modifier_xmarks = keys.modifier_xmarks

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local allied_duration = ability:GetLevelSpecialValueFor("allied_duration", ability_level)
	local grace_period = ability:GetLevelSpecialValueFor("grace_period", ability_level)

	-- Initialize mark duration reference point, if necessary
	if not caster.x_marks_initial_cast_time then
		caster.x_marks_initial_cast_time = GameRules:GetGameTime()
	end

	-- Adjust buff durations based on elapsed duration of the grace_period
	local elapsed_time = GameRules:GetGameTime() - caster.x_marks_initial_cast_time
	duration = duration - elapsed_time
	allied_duration = allied_duration - elapsed_time
	grace_period = math.max(math.min(grace_period - elapsed_time, grace_period), 0)

	-- Apply grace period modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {duration = grace_period})
	
	-- Apply appropriate modifiers according to the target's team
	if target:GetTeam() == caster:GetTeam() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_xmarks, {duration = allied_duration})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_duration, {duration = allied_duration})
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_xmarks, {duration = duration})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_duration, {duration = duration})
	end

	-- Make the return ability active
	caster:FindAbilityByName(ability_return):SetActivated(true)
end

function XmarksMark( keys )
	local caster = keys.caster
	local target = keys.target

	-- If this target is already marked, do nothing
	if target.x_marks_origin then
		return nil
	end

	-- Initialize Xmarks target table, if necessary
	if not caster.x_marks_target_table then
		caster.x_marks_target_table = {}
	end

	-- Add this target to the table
	caster.x_marks_target_table[#caster.x_marks_target_table + 1] = target
	
	-- Set x marks origin point
	target.x_marks_origin = target:GetAbsOrigin()
end

function XmarksReturn( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- If the target's origin position is unknown, do nothing
	if not target.x_marks_origin then
		return nil
	end
	
	-- Return target to its original position
	FindClearSpaceForUnit(target, target.x_marks_origin, true)
	target.x_marks_origin = nil

	-- If it's an enemy, ministun it
	if target:GetTeam() ~= caster:GetTeam() then
		target:AddNewModifier(unit, ability, "modifier_stunned", {duration = 0.01})
	end

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)
end

function XmarksGraceEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("cooldown", ability_level)

	-- Put the ability on cooldown
	local remaining_cooldown = cooldown
	if caster.x_marks_initial_cast_time then
		remaining_cooldown = cooldown - (GameRules:GetGameTime() - caster.x_marks_initial_cast_time)
		caster.x_marks_initial_cast_time = nil
	end
	ability:StartCooldown(remaining_cooldown * GetCooldownReduction(caster))
end

function LevelUpReturn( keys )
	local caster = keys.caster		
	local ability_name = keys.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	

	-- Upgrades Return to level 1 and make it inactive, if it hasn't already
	if ability_handle:GetLevel() < 1 then
		ability_handle:SetLevel(1)
		ability_handle:SetActivated(false)
	end
end

function XmarksForcedReturn( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_x_mark = keys.modifier_x_mark
	local modifier_caster = keys.modifier_caster

	-- Iterate through the target list for this cast
	if caster.x_marks_target_table then
		for _,unit in pairs(caster.x_marks_target_table) do
			unit:RemoveModifierByName(modifier_x_mark)
		end
		caster.x_marks_target_table = nil
	end

	-- End the caster's grace period
	caster:RemoveModifierByName(modifier_caster)

	-- Make return inactive again
	ability:SetActivated(false)
end

function XmarksDurationEnd( keys )
	local caster = keys.caster
	local ability_return = keys.ability_return

	-- Delete the targets hit table, just in case
	caster.x_marks_target_table = nil

	-- Make return inactive just to be sure
	caster:FindAbilityByName(ability_return):SetActivated(false)
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
		dummy:EmitSound(crash_sound)
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
	local modifier_rum = keys.modifier_rum

	-- Parameters
	local crash_distance = ability:GetLevelSpecialValueFor("crash_distance", ability_level)
	local ship_speed = ability:GetLevelSpecialValueFor("ghostship_speed", ability_level)
	local impact_damage = ability:GetLevelSpecialValueFor("impact_damage", ability_level)
	local ghostship_width = ability:GetLevelSpecialValueFor("ghostship_width", ability_level)

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
	{	should_stun = 0,
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

	-- Stun target after it reaches the crash zone
	Timers:CreateTimer(duration, function()
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = ghostship_width / ship_speed})
	end)
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

		-- If the target has died, do nothing
		if target:IsAlive() then

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
		else
			target.ghostship_damage_prevented = nil
		end
	end)
end