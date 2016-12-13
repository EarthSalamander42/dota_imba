--[[	Author: Firetoad
		Date: 12.01.2016	]]

function Malefice( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local modifier_target = keys.modifier_target

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Apply debuff modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_target, {})
end

function MaleficeTick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_tick = keys.sound_tick
	local particle_start = keys.particle_start
	local particle_travel = keys.particle_travel
	local particle_end = keys.particle_end

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local tick_damage = ability:GetLevelSpecialValueFor("tick_damage", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local glitch_radius = ability:GetLevelSpecialValueFor("glitch_radius", ability_level)
	local glitch_pull = ability:GetLevelSpecialValueFor("glitch_pull", ability_level)
	local pull_delay = ability:GetLevelSpecialValueFor("pull_delay", ability_level)
	local pull_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()

	-- Play sound
	target:EmitSound(sound_tick)

	-- Choose pull source
	if caster.black_hole_center then
		pull_loc = caster.black_hole_center
	elseif caster.midnight_pulse_center then
		pull_loc = caster.midnight_pulse_center
	end

	-- Calculate pull destination
	local target_distance = (pull_loc - target_loc):Length2D()
	if target_distance > glitch_pull then
		pull_loc = target_loc + (pull_loc - target_loc):Normalized() * glitch_pull
	end

	-- Draw startpoint particle
	local start_pfx = ParticleManager:CreateParticle(particle_start, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(start_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(start_pfx, 2, Vector(pull_delay, 0, 0))
	Timers:CreateTimer(pull_delay, function()
		ParticleManager:DestroyParticle(start_pfx, false)
		ParticleManager:ReleaseParticleIndex(start_pfx)
	end)

	-- Draw traveling particle
	local travel_pfx = ParticleManager:CreateParticle(particle_travel, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(travel_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(travel_pfx, 2, Vector(pull_delay, 0, 0))
	ParticleManager:SetParticleControl(travel_pfx, 1, pull_loc)
	ParticleManager:ReleaseParticleIndex(travel_pfx)
	Timers:CreateTimer(pull_delay, function()
		ParticleManager:DestroyParticle(travel_pfx, false)
		ParticleManager:ReleaseParticleIndex(travel_pfx)
	end)

	-- Draw endpoint particle
	local end_pfx = ParticleManager:CreateParticle(particle_end, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(end_pfx, 1, pull_loc)
	ParticleManager:SetParticleControl(end_pfx, 2, Vector(pull_delay, 0, 0))
	ParticleManager:ReleaseParticleIndex(end_pfx)
	Timers:CreateTimer(pull_delay, function()
		ParticleManager:DestroyParticle(end_pfx, false)
		ParticleManager:ReleaseParticleIndex(end_pfx)
	end)

	-- Iterate through nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, glitch_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = tick_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Stun
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

		-- Pull and prevent enemy from getting stuck after [pull_delay]
		Timers:CreateTimer(pull_delay, function()
			FindClearSpaceForUnit(enemy, pull_loc, true)
			Timers:CreateTimer(0.01, function()
				local units = FindUnitsInRadius(caster:GetTeamNumber(), pull_loc, nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
				for _,unit in pairs(units) do
					FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
				end
			end)
		end)
	end
end

function DemonicConversion( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local modifier_eidolons = keys.modifier_eidolons
	local modifier_buffs = keys.modifier_buffs

	-- Parameters
	local eidolon_count = ability:GetLevelSpecialValueFor("eidolon_count", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local base_health = ability:GetLevelSpecialValueFor("base_health", ability_level)
	local health_per_level = ability:GetLevelSpecialValueFor("health_per_level", ability_level)
	local eidolon_name = "npc_imba_enigma_eidolon_"..(ability_level + 1)
	local caster_level = caster:GetLevel()
	local target_loc = target:GetAbsOrigin()

	-- Play cast sound
	target:EmitSound(sound_cast)

	-- Kill the target creep
	target:Kill(ability, caster)

	-- Spawn the eidolons
	for i = 1, eidolon_count do

		-- Spawn position
		local eidolon_loc = RotatePosition(target_loc, QAngle(0, (i - 1) * 360 / eidolon_count, 0), target_loc + caster:GetForwardVector() * 80)
		local eidolon = CreateUnitByName(eidolon_name, eidolon_loc, true, caster, caster, caster:GetTeam())

		-- Prevent nearby units from getting stuck
		Timers:CreateTimer(0.01, function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), eidolon_loc, nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)

		-- Make the eidolon limited duration and controllable
		eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)
		eidolon:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

		-- Grant eidolon multiplication buff
		ability:ApplyDataDrivenModifier(caster, eidolon, modifier_eidolons, {})

		-- Adjust eidolon health
		SetCreatureHealth(eidolon, base_health + caster_level * health_per_level, true)

		-- Grant level-based bonuses
		AddStacks(ability, caster, eidolon, modifier_buffs, caster_level, true)
	end
end

function EidolonAttack( keys )
	local eidolon = keys.attacker
	local caster = eidolon:GetOwnerEntity()
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_eidolons = keys.modifier_eidolons
	local modifier_buffs = keys.modifier_buffs

	-- If the ability was unlearned, or the target is a building, do nothing
	if target:IsBuilding() or target:IsAncient() or not ability then
		return nil
	end

	-- Parameters
	local attacks_to_split = ability:GetLevelSpecialValueFor("attacks_to_split", ability_level)
	local child_duration = ability:GetLevelSpecialValueFor("child_duration", ability_level)
	local base_health = ability:GetLevelSpecialValueFor("base_health", ability_level)
	local health_per_level = ability:GetLevelSpecialValueFor("health_per_level", ability_level)
	local eidolon_name = "npc_imba_enigma_eidolon_"..(ability_level + 1)
	local caster_level = caster:GetLevel()

	-- Count attacks
	if not eidolon.demonic_conversion_split_attacks then
		eidolon.demonic_conversion_split_attacks = 1
	else
		eidolon.demonic_conversion_split_attacks = eidolon.demonic_conversion_split_attacks + 1
	end

	-- If there are enough attacks for a split, spawn a new eidolon
	if eidolon.demonic_conversion_split_attacks >= attacks_to_split then
		
		-- Reset attack count
		eidolon.demonic_conversion_split_attacks = 0

		-- Restore parent Eidolon's health
		eidolon:SetHealth(eidolon:GetMaxHealth())

		-- Fetch parent eidolon's remaining duration
		local modifier_kill = eidolon:FindAllModifiersByName("modifier_kill")
		local remaining_duration = modifier_kill[1]:GetRemainingTime()

		-- Spawn a new eidolon
		local child_loc = eidolon:GetAbsOrigin() + eidolon:GetForwardVector() * 80
		local child = CreateUnitByName(eidolon_name, child_loc, true, caster, caster, caster:GetTeam())

		-- Prevent nearby units from getting stuck
		Timers:CreateTimer(0.01, function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), child_loc, nil, 128, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)

		-- Make the eidolon limited duration and controllable
		child:SetControllableByPlayer(caster:GetPlayerID(), true)
		child:AddNewModifier(caster, ability, "modifier_kill", {duration = remaining_duration + child_duration})

		-- Grant eidolon multiplication buff
		ability:ApplyDataDrivenModifier(caster, child, modifier_eidolons, {})

		-- Adjust eidolon health
		SetCreatureHealth(child, base_health + caster_level * health_per_level, true)

		-- Grant level-based bonuses
		AddStacks(ability, caster, child, modifier_buffs, caster_level, true)
	end
end

function MidnightPulse( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_pulse = keys.particle_pulse
	local modifier_singularity = keys.modifier_singularity

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local damage_per_tick = ability:GetLevelSpecialValueFor("damage_per_tick", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local pull_distance = ability:GetLevelSpecialValueFor("pull_distance", ability_level)
	local singularity_radius = ability:GetLevelSpecialValueFor("singularity_radius", ability_level)
	local elapsed_duration = 0

	-- Increase radius according to singularity stacks
	radius = radius + singularity_radius * caster:GetModifierStackCount(modifier_singularity, caster)

	-- Set up midnight pulse center position variable
	caster.midnight_pulse_center = target

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(target, radius, false)

	-- Create dummy to play sound on
	local pulse_dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())

	-- Play sound
	pulse_dummy:EmitSound(sound_cast)

	-- Play particle
	local pulse_pfx = ParticleManager:CreateParticle(particle_pulse, PATTACH_ABSORIGIN, pulse_dummy)
	ParticleManager:SetParticleControl(pulse_pfx, 0, pulse_dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(pulse_pfx, 1, Vector(radius, 0, 0))

	-- Start pulse loop
	Timers:CreateTimer(1, function()
		
		-- Update elapsed duration
		elapsed_duration = elapsed_duration + 1

		-- If the duration has elapsed, end timer and clean-up
		if elapsed_duration >= duration then
			pulse_dummy:StopSound(sound_cast)
			ParticleManager:DestroyParticle(pulse_pfx, false)
			pulse_dummy:Destroy()

			-- Clear global variable if it corresponds to this cast
			if caster.midnight_pulse_center == target then
				caster.midnight_pulse_center = nil
			end

		-- Else, keep going
		else

			-- Iterate through nearby enemies
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do

				-- Pull unit if it is not magic immune
				if not enemy:IsMagicImmune() and not IsUninterruptableForcedMovement(enemy) then
					local enemy_loc = enemy:GetAbsOrigin()
					if (target - enemy_loc):Length2D() <= pull_distance then
						FindClearSpaceForUnit(enemy, target, true)
					else
						FindClearSpaceForUnit(enemy, enemy_loc + (target - enemy_loc):Normalized() * pull_distance, true)
					end
				end

				-- Calculate and deal damage
				local damage = enemy:GetMaxHealth() * damage_per_tick / 100
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
			end

			return 1
		end
	end)
end

function Gravity( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local stun_increase = ability:GetLevelSpecialValueFor("stun_increase", ability_level) / 100
	local think_interval = ability:GetLevelSpecialValueFor("think_interval", ability_level)

	-- Calculate adjusted stun increase
	local corrected_increase = 1 - ( 1 / (1 + stun_increase) )

	-- Increase existing stuns' duration
	if target:HasModifier("modifier_stunned") then
		local modifier_stun = target:FindModifierByName("modifier_stunned")
		modifier_stun:SetDuration(modifier_stun:GetRemainingTime() + think_interval * corrected_increase, false)
	end
end

function BlackHole( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_ti5 = keys.sound_ti5
	local particle_hole_ti5 = keys.particle_hole_ti5
	local particle_hole = keys.particle_hole
	local modifier_debuff = keys.modifier_debuff
	local modifier_debuff_ti5 = keys.modifier_debuff_ti5
	local modifier_singularity = keys.modifier_singularity
	local scepter = HasScepter(caster)

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local base_pull_distance = ability:GetLevelSpecialValueFor("base_pull_distance", ability_level)
	local stack_pull_distance = ability:GetLevelSpecialValueFor("stack_pull_distance", ability_level)
	local base_pull_speed = ability:GetLevelSpecialValueFor("base_pull_speed", ability_level)
	local stack_pull_speed = ability:GetLevelSpecialValueFor("stack_pull_speed", ability_level)
	local inner_pull_speed = ability:GetLevelSpecialValueFor("inner_pull_speed", ability_level)
	local pull_speed_scepter = ability:GetLevelSpecialValueFor("pull_speed_scepter", ability_level)

	-- Set up dummy and global center point variable
	caster.black_hole_dummy = CreateUnitByName("npc_dummy_unit", target, false, nil, nil, caster:GetTeamNumber())
	caster.black_hole_center = target

	-- Verify how many enemies were caught initially
	local enemies_caught = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Grant singularity stacks to the caster due to heroes caught
	AddStacks(ability, caster, caster, modifier_singularity, #enemies_caught, true)

	-- Decide particles and sounds to use
	local blackhole_particle = particle_hole
	local blackhole_sound = sound_cast
	local blackhole_modifier = modifier_debuff
	if #enemies_caught >= 4 then
		blackhole_particle = particle_hole_ti5
		blackhole_sound = sound_ti5
		blackhole_modifier = modifier_debuff_ti5
	end

	-- Decide voice responses
	if #enemies_caught >= 4 then
		caster:EmitSound("Imba.EnigmaBlackHoleTobi0"..RandomInt(1, 5))
	elseif #enemies_caught > 0 then
		if RandomInt(1, 100) <= 50 then
			caster:EmitSound("enigma_enig_ability_black_0"..RandomInt(1, 3))
		end
	else
		caster:EmitSound("enigma_enig_ability_failure_0"..RandomInt(1, 2))
	end

	-- Shake screen DRAMATICALLY
	ScreenShake(caster:GetOrigin(), 8 + #enemies_caught * 2, 0.3, 2, 1000, 0, true)

	-- Play cast sound
	caster.black_hole_dummy:EmitSound(blackhole_sound)

	-- Play particle
	local blackhole_pfx = ParticleManager:CreateParticle(blackhole_particle, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(blackhole_pfx, 0, target)

	-- Calculate pull parameters
	local singularity_stacks = caster:GetModifierStackCount(modifier_singularity, caster)
	local pull_distance = base_pull_distance + stack_pull_distance * singularity_stacks
	local pull_speed = base_pull_speed + stack_pull_speed * singularity_stacks
	if scepter then
		pull_speed = pull_speed + pull_speed_scepter
	end

	-- Grant vision on the pull area
	ability:CreateVisibilityNode(target, pull_distance, 4)

	-- Normalize pull speed to the loop interval
	pull_speed = pull_speed * 0.03
	inner_pull_speed = inner_pull_speed * 0.03

	-- Main Black Hole loop
	Timers:CreateTimer(0, function()
		
		-- If the black hole dummy was destroyed, channeling has ended; stop and clean-up
		if not caster.black_hole_center then

			-- Destroy particle
			ParticleManager:DestroyParticle(blackhole_pfx, true)

			-- Find legal positions for all affected
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, pull_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do
				FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
			end
			
		-- Else, keep going
		else
			-- Iterate through enemies in the pull radius
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, pull_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do
				
				-- Decide pull speed based on distance
				local enemy_loc = enemy:GetAbsOrigin()
				local distance = (enemy_loc - target):Length2D()
				if distance > radius then
					if not IsRoshan(enemy) then
						enemy:SetAbsOrigin(enemy_loc + (target - enemy_loc):Normalized() * pull_speed)
					end
				else
					enemy:SetAbsOrigin(enemy_loc + (target - enemy_loc):Normalized() * inner_pull_speed)

					-- Apply the debuff modifier to enemies inside the effect radius
					ability:ApplyDataDrivenModifier(caster, enemy, blackhole_modifier, {})
				end

			end
			return 0.03
		end
	end)
end

function BlackHoleEnd( keys )
	local caster = keys.caster
	local sound_stop = keys.sound_stop

	if not caster:IsNull() then
		-- Play the end sound
		caster:EmitSound(sound_stop)
		
		if caster.black_hole_dummy ~= nil then
			-- Stop all sounds from playing
			caster.black_hole_dummy:StopSound("Hero_Enigma.Black_Hole")
			caster.black_hole_dummy:StopSound("Imba.EnigmaBlackHoleTi5")

			-- Destroy the dummy
			caster.black_hole_dummy:Destroy()

			-- Clear global variable
			caster.black_hole_center = nil
		end
	end
end

function BlackHoleDebuffStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_target = keys.particle_target
	local particle_screen = keys.particle_screen
	local scepter = HasScepter(caster)

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_scepter = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)

	-- Start flailing animation
	StartAnimation(target, {activity = ACT_DOTA_FLAIL, rate = 1.0})

	-- Create particle
	target.black_hole_hit_particle = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(target.black_hole_hit_particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(target.black_hole_hit_particle, 2, caster.black_hole_center)

	-- Play particle to hero owners
	if target:IsRealHero() then
		target.black_hole_screen_particle = ParticleManager:CreateParticleForPlayer(particle_screen, PATTACH_EYES_FOLLOW, target, PlayerResource:GetPlayer(target:GetPlayerID()))
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

	-- Deal max health-based damage if the caster has a scepter
	if scepter then
		if caster:HasModifier("modifier_item_imba_rapier_damage") then
			local rapier_ability = caster:FindModifierByName("modifier_item_imba_rapier_damage"):GetAbility()
			caster:RemoveModifierByName("modifier_item_imba_rapier_damage")
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetMaxHealth() * damage_scepter / 100, damage_type = DAMAGE_TYPE_PURE})
			rapier_ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_imba_rapier_damage", {})
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetMaxHealth() * damage_scepter / 100, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function BlackHoleDebuffTick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_scepter = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

	-- Deal max health-based damage if the caster has a scepter
	if scepter then
		if caster:HasModifier("modifier_item_imba_rapier_damage") then
			local rapier_ability = caster:FindModifierByName("modifier_item_imba_rapier_damage"):GetAbility()
			caster:RemoveModifierByName("modifier_item_imba_rapier_damage")
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetMaxHealth() * damage_scepter / 100, damage_type = DAMAGE_TYPE_PURE})
			rapier_ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_imba_rapier_damage", {})
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target:GetMaxHealth() * damage_scepter / 100, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end

function BlackHoleDebuffEnd( keys )
	local target = keys.target

	-- Stop flailing animation
	EndAnimation(target)

	-- Destroy particles
	ParticleManager:DestroyParticle(target.black_hole_hit_particle, true)
	if target.black_hole_screen_particle then
		ParticleManager:DestroyParticle(target.black_hole_screen_particle, true)
	end
end