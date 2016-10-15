--[[ 	Author: D2imba
		Date: 27.04.2015	]]

function CosmicDustUpgrade( keys )
	local caster = keys.caster
	local ability_starfall = keys.ability
	local ability_cosmic_dust = caster:FindAbilityByName(keys.ability_cosmic_dust)

	-- Upgrade the Cosmic Dust ability
	if ability_cosmic_dust then
		ability_cosmic_dust:SetLevel(ability_starfall:GetLevel())
	end
end

function Starfall( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ambient_sound = keys.ambient_sound
	local hit_sound = keys.hit_sound
	local ambient_particle = keys.ambient_particle
	local hit_particle = keys.hit_particle
	local modifier_debuff = keys.modifier_debuff

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local hit_delay = ability:GetLevelSpecialValueFor("hit_delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	-- Grant vision of the area for the duration
	local caster_pos = caster:GetAbsOrigin()
	ability:CreateVisibilityNode(caster_pos, radius, hit_delay + vision_duration)

	-- Emit sound
	caster:EmitSound(ambient_sound)

	-- Create ambient particle
	local ambient_pfx = ParticleManager:CreateParticle(ambient_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(ambient_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(ambient_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(ambient_pfx)

	-- Find nearby enemies and apply the particle, damage, debuff, and hit sound
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies) do
		local star_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(star_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(star_pfx)
		Timers:CreateTimer(hit_delay, function()
			enemy:EmitSound(hit_sound)
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end)
	end
end

function StarfallSecondary( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local hit_sound = keys.hit_sound
	local hit_particle = keys.hit_particle
	local scepter = HasScepter(caster)

	-- Parameters
	local secondary_radius = ability:GetLevelSpecialValueFor("secondary_radius", ability_level)
	local hit_delay = ability:GetLevelSpecialValueFor("hit_delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Iterate through eligible targets
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, secondary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	local delay_count = 0
	for _,enemy in pairs(enemies) do
		Timers:CreateTimer(delay_count * 0.3, function()

			-- Fire particle, sound, and apply damage
			local star_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(star_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(star_pfx)
			Timers:CreateTimer(hit_delay, function()
				enemy:EmitSound(hit_sound)
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end)
		end)

		-- Decrease available target count
		delay_count = delay_count + 1
	end
end

function LaunchArrow( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target_points[1]
	local scepter = HasScepter(caster)
	
	-- Memorizes the cast location to calculate the distance traveled later
	local arrow_location = caster:GetAbsOrigin()

	-- Parameters
	local arrow_direction = (target - arrow_location):Normalized()
	local modifier_arrow = keys.modifier_arrow
	local sound_arrow = keys.sound_arrow
	local arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed", ability_level)
	local arrow_width = ability:GetLevelSpecialValueFor("arrow_width", ability_level)
	local arrow_max_stunrange = ability:GetLevelSpecialValueFor("arrow_max_stunrange", ability_level)
	local arrow_min_stun = ability:GetLevelSpecialValueFor("arrow_min_stun", ability_level)
	local arrow_max_stun = ability:GetLevelSpecialValueFor("arrow_max_stun", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local arrow_bonus_damage = ability:GetLevelSpecialValueFor("arrow_bonus_damage", ability_level)
	local arrow_max_damage = ability:GetLevelSpecialValueFor("arrow_max_damage", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	local enemy_units

	-- Is it night time?
	local is_night = false
	if scepter or not GameRules:IsDaytime() then
		is_night = true
	end

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

		-- Find nearby enemy units
		enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

		-- If no enemy is found, keep going
		if #enemy_units == 0 then
			arrow_ticks = arrow_ticks + 1
			
			-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
			if arrow_ticks >= 1000 or IsNearEnemyClass(sacred_arrow, 1360, "ent_dota_fountain") then
				sacred_arrow:StopPhysicsSimulation()
				sacred_arrow:Destroy()
			else
				return 0.03
			end

		-- Else, check targets' status
		else
			local creep_hit = false
			local hero_hit = false
			for _,unit in pairs(enemy_units) do

				-- If this unit is a non-ancient creep or illusion, kill it
				if not unit:IsRealHero() then
					if not unit:IsAncient() then
						unit:Kill(ability, caster)
						unit:EmitSound(sound_arrow)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, 9999, nil)
						ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

						-- Store the fact a non-hero was hit
						creep_hit = true
					end

				-- Else, it's a real hero; play sound, damage, and apply stun
				else
					-- Calculate hit distance 
					local distance = (sacred_arrow:GetAbsOrigin() - arrow_location):Length2D()

					-- Calculate and apply stun
					if distance < arrow_max_stunrange then
						arrow_stun_duration = distance * stun_per_100 * 0.01 + arrow_min_stun
					else
						arrow_stun_duration = arrow_max_stun
					end
					unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun_duration})

					-- Impact sound
					unit:EmitSound(sound_arrow)

					-- Impact vision
					ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

					-- Calculate damage
					local actual_bonus_damage = 0
					if distance > arrow_max_stunrange then
						local extra_distance = distance - arrow_max_stunrange
						actual_bonus_damage = math.min(extra_distance * 0.001 * arrow_bonus_damage * 0.01, arrow_max_damage * 0.01) * unit:GetMaxHealth()
					end

					-- Damage
					local arrow_damage = base_damage + actual_bonus_damage
					damage_table.victim = unit
					damage_table.damage = arrow_damage
					ApplyDamage(damage_table)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, arrow_damage, nil)

					-- Store the fact a hero was hit
					hero_hit = true
				end
			end

			-- If a hero was hit, or if a creep was hit during the day, destroy the arrow
			if hero_hit or ( creep_hit and not is_night ) then
				sacred_arrow:StopPhysicsSimulation()
				sacred_arrow:Destroy()
			
			-- Else, keep going
			else
				arrow_ticks = arrow_ticks + 1
			
				-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
				if arrow_ticks >= 1000 or IsNearEnemyClass(sacred_arrow, 1360, "ent_dota_fountain") then
					sacred_arrow:StopPhysicsSimulation()
					sacred_arrow:Destroy()
				else
					return 0.03
				end
			end
		end
	end)
end

function Leap( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_pos = keys.target_points[1]
	local ability_level = ability:GetLevel() - 1
	local root_modifier = keys.root_modifier
	local buff_modifier = keys.buff_modifier
	local sound_cast = keys.sound_cast
	local scepter = HasScepter(caster)

	-- Parameters
	local caster_pos = caster:GetAbsOrigin()
	local min_speed = ability:GetLevelSpecialValueFor("min_speed", ability_level)
	local base_distance = ability:GetLevelSpecialValueFor("base_distance", ability_level)
	local max_time = ability:GetLevelSpecialValueFor("max_time", ability_level)
	local buff_radius = ability:GetLevelSpecialValueFor("buff_radius", ability_level)
	local cooldown_increase = ability:GetLevelSpecialValueFor("cooldown_increase", ability_level)
	local base_height = ability:GetLevelSpecialValueFor("base_height", ability_level)
	local height_step = ability:GetLevelSpecialValueFor("height_step", ability_level)
	local max_height = ability:GetLevelSpecialValueFor("max_height", ability_level)

	-- Is it night time?
	local is_night = false
	if scepter or not GameRules:IsDaytime() then
		is_night = true
	end

	-- Base range can be increased
	base_distance = base_distance + GetCastRangeIncrease(caster)

	-- Clears any current command
	caster:Stop()

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Calculate leap geometry
	local direction = (target_pos - caster_pos):Normalized()
	local distance = (target_pos - caster_pos):Length2D()
	local height = base_height

	-- Cap distance during the day
	if not is_night then
		distance = math.min(distance, base_distance)
		target_pos = caster_pos + direction * distance

	-- Adjust height during long nighttime jumps
	else
		height = math.min( (distance - base_distance) / base_distance * height_step + base_height, max_height)
	end

	-- Increase cooldown for long-distance jumps
	local cooldown = ability:GetCooldown(ability_level) + cooldown_increase * math.max( (distance - base_distance) / base_distance, 0)
	ability:StartCooldown(cooldown * GetCooldownReduction(caster))

	-- Calculate leap speed and duration
	local leap_speed = math.max( distance / max_time, min_speed)
	local leap_time = distance / leap_speed

	-- Root the caster during the jump
	ability:ApplyDataDrivenModifier(caster, caster, root_modifier, {})

	-- Perform movement loop
	local current_time = 0
	Timers:CreateTimer(0.03, function()

		-- Update time
		current_time = current_time + 0.03

		-- Calculate height
		local current_height
		if current_time <= (leap_time / 2) then
			current_height = height * current_time / leap_time * 2
		else
			current_height = height * (1 - current_time / leap_time) * 2
		end

		-- Calculate position
		local current_position = caster_pos + direction * distance * current_time / leap_time

		-- Update position
		caster:SetAbsOrigin(Vector(current_position.x, current_position.y, GetGroundHeight(current_position, caster) + current_height))
		
		-- If the jump time hasn't elapsed yet, keep going
		if current_time < leap_time then
			return 0.03

		-- Else, finalize the jump
		else

			-- Unroot the caster
			caster:RemoveModifierByName(root_modifier)

			-- Prevent the caster from getting stuck
			FindClearSpaceForUnit(caster, target_pos, true)

			-- Buff nearby allies
			local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, buff_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,ally in pairs(nearby_allies) do
				ability:ApplyDataDrivenModifier(caster, ally, buff_modifier, {})
			end

			-- If the leap distance was too long, roar again
			if distance > 5000 then
				caster:EmitSound(sound_cast)
			end
		end
	end)
end

function CosmicDust( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_starfall = caster:FindAbilityByName("imba_mirana_starfall")

	local scepter = HasScepter(caster)

	-- Is it night time?
	local is_night = false
	if scepter or not GameRules:IsDaytime() then
		is_night = true
	end

	-- Spell Steal exception
	if IsStolenSpell(caster) then
		ability_starfall = true
	end

	-- If starfall was not learned yet, or if it's day, do nothing
	if not ability_starfall or not is_night then
		ability:EndCooldown()
		return nil
	end

	-- Spell Steal shitty workaround
	local ability_level
	if IsStolenSpell(caster) then
		ability_level = 3
	else
		ability_level = ability_starfall:GetLevel() - 1
	end

	-- Parameters
	local ambient_sound = keys.ambient_sound
	local hit_sound = keys.hit_sound
	local ambient_particle = keys.ambient_particle
	local hit_particle = keys.hit_particle
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local hit_delay = ability:GetLevelSpecialValueFor("hit_delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	-- Grant vision of the area for the duration
	local caster_pos = caster:GetAbsOrigin()
	ability:CreateVisibilityNode(caster_pos, radius, hit_delay + vision_duration)

	-- Emit sound
	caster:EmitSound(ambient_sound)

	-- Create ambient particle
	local ambient_pfx = ParticleManager:CreateParticle(ambient_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(ambient_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(ambient_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(ambient_pfx)

	-- Find nearby enemies and apply the particle, damage, debuff, and hit sound
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,enemy in pairs(enemies) do
		local star_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(star_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(star_pfx)
		Timers:CreateTimer(hit_delay, function()
			enemy:EmitSound(hit_sound)
			ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		end)
	end
end

function MoonlightStartFade( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_fade = keys.modifier_fade

	-- Apply the fade time buff
	ability:ApplyDataDrivenModifier(caster, target, modifier_fade, {})
end

function MoonlightFadeEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff

	-- If the target is affected by Moonlight Shadow, make it invisible for the remainder of the duration
	if target:HasModifier(modifier_buff) then
		
		-- Fetch the Moonlight Shadow buff
		local modifier_moonlight = target:FindModifierByNameAndCaster(modifier_buff, caster)
		local remaining_duration = modifier_moonlight:GetRemainingTime()

		-- Apply invisibility
		target:AddNewModifier(caster, ability, "modifier_invisible", {duration = remaining_duration})
	end
end