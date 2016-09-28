--[[ 	Author: AtroCty, Firetoad & Hewdraw
		Date: 
		06.09.2016	
		Last Update:
		12.09.2016	]]

function StarFall( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_seed = caster:FindAbilityByName("imba_mirana_sky_seed")
	local target = keys.target
	local hit_sound = keys.hit_sound
	local hit_particle = keys.hit_particle
	local debuff_stacks = keys.debuff_stacks
	local buff_stacks = keys.buff_stacks
	local buff_counter = "modifier_imba_sky_seed_buff"
	local debuff_counter = "modifier_imba_sky_seed_debuff_counter"
		
	-- Parameters
	local scepter = HasScepter(caster)
	local ability_starfall = caster:FindAbilityByName("imba_mirana_reap_and_sow")
	local ability_starfall_level = ability_starfall:GetLevel() - 1
	local ability_moonlight = caster:FindAbilityByName("imba_mirana_invis")
	local ability_moonlight_level = ability_moonlight:GetLevel()	
	local stack_reduction = ability:GetLevelSpecialValueFor("stack_reduction", 0)
	local secondary_reduction = ability:GetLevelSpecialValueFor("secondary_reduction", 0)
	local default_damage = ability:GetLevelSpecialValueFor("default_damage", 0)
	local debuff_duration = ability:GetLevelSpecialValueFor("debuff_duration", 0)
	local buff_duration = ability:GetLevelSpecialValueFor("debuff_duration", 0)
	local damage_interval = ability:GetLevelSpecialValueFor("interval", 0)
	local buff_duration = ability:GetLevelSpecialValueFor("buff_duration", 0)
	local minimum_damage_scepter = ability:GetLevelSpecialValueFor("minimum_damage_scepter", 0)
	local damage_scepter = ability:GetLevelSpecialValueFor("damage_scepter", 0)
	local damage_starfall = ability_starfall:GetLevelSpecialValueFor("damage", ability_starfall_level)
	
	-- Is it night time or Ultimate applied?
	local is_night = false
	if caster:HasModifier("modifier_moonlight_duration") or not GameRules:IsDaytime() then
		is_night = true
	end
	
	-- Additional damage from Ultimate
	local damage_moonlight = (ability_moonlight_level * 30) + 30
	
	-- Minimum damage per star
	local min_damage = default_damage
	if scepter then min_damage = min_damage + minimum_damage_scepter end
	
	local dmg_counter = target:GetModifierStackCount(debuff_stacks, caster)
	local dmg_counter = target:GetModifierStackCount(debuff_counter, caster)
		
	if ability_moonlight_level ~= 0 then min_damage = min_damage + damage_moonlight end
	local count = target:GetModifierStackCount(debuff_counter, caster)
	target:RemoveModifierByName(debuff_counter)
	
	for i = 1, count do
		local countDelay = i * damage_interval 
		Timers:CreateTimer(countDelay, function()
			target:EmitSound(hit_sound)
			
			-- Actual damage per star
			local damage = damage_starfall
			if target:HasModifier(buff_counter) then
				local res_counter = target:GetModifierStackCount(buff_counter, caster)
				damage = damage_starfall - (res_counter * stack_reduction) - secondary_reduction
			else 
				local res_counter = 0
			end
			if damage < min_damage then damage = min_damage end
			AddStacks(ability_seed, caster, target, buff_counter, 1, true)
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			local star_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(star_pfx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(star_pfx)
		end)
	end
end

function ReapAndSow( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_seed = caster:FindAbilityByName("imba_mirana_sky_seed")
	local ability_level = ability:GetLevel() - 1
	local ambient_sound = keys.ambient_sound
	local hit_sound = keys.hit_sound
	local ambient_particle = keys.ambient_particle
	local debuff_stacks = keys.debuff_stacks
	local stack_counter = keys.stack_counter
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local secondary_radius = ability:GetLevelSpecialValueFor("secondary_radius", ability_level)
	local secondary_amount = ability:GetLevelSpecialValueFor("secondary_amount", ability_level)
	local hit_delay = ability:GetLevelSpecialValueFor("hit_delay", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local debuff_duration = ability_seed:GetLevelSpecialValueFor("debuff_duration", 0)
	
	
	-- Grant vision of the area for the duration
	local caster_pos = caster:GetAbsOrigin()
	ability:CreateVisibilityNode(caster_pos, radius, hit_delay + vision_duration)
	
	-- Is it night time or is Ulti appllied?
	local is_night = false
	if caster:HasModifier("modifier_moonlight_duration") or not GameRules:IsDaytime() then
		is_night = true
	end
	
	-- Emit sound
	caster:EmitSound(ambient_sound)
	
	-- Create ambient particle
	local ambient_pfx = ParticleManager:CreateParticle(ambient_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(ambient_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(ambient_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(ambient_pfx)
	
	-- Find nearby enemies and apply the particle, damage, debuff, and hit sound
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	for _,target in pairs(enemies) do
		AddStacks(ability_seed, caster, target, debuff_stacks, 1, true)
		AddStacks(ability_seed, caster, target, stack_counter, 1, true)
	end
	
	-- Apply additional stacks to random close
	local count = 1
	-- Apply more on night time
	if is_night then count = secondary_amount end
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, secondary_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	if #enemies >= 1 then
		for i = 1, count do
			local target = enemies[RandomInt( 1, #enemies)]
			AddStacks(ability_seed, caster, target, debuff_stacks, 1, true)
			AddStacks(ability_seed, caster, target, stack_counter, 1, true)
		end
	end
	
	-- Remove all stacks globaly
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if (enemy:HasModifier(debuff_stacks)) then
			local destroy_ability = enemy:FindAllModifiersByName("modifier_imba_sky_seed_debuff")
			destroy_ability[1]:Destroy()
		end
	end	
end

function LaunchArrow( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_seed = caster:FindAbilityByName("imba_mirana_sky_seed")
	local target_pos = keys.target_points[1]
	local debuff_stacks = keys.debuff_stacks
	local stack_counter = keys.stack_counter
	local scepter = HasScepter(caster)
	
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
	local arrow_max_damage = 50
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("arrow_vision", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local buff_range = ability:GetLevelSpecialValueFor("buff_range", ability_level)
	local enemy_units
	local debuff_duration = ability_seed:GetLevelSpecialValueFor("debuff_duration", 0)
	
	local secondary_angle = 26
	local arrow_direction_left = arrow_direction 
	local arrow_direction_right = arrow_direction
	local arrow_speed_side = arrow_speed + 50
	local creep_hit_store = {false, false, false}
	
	-- Is it night time or is Ulti appllied?
	local is_night = false
	if caster:HasModifier("modifier_moonlight_duration") or not GameRules:IsDaytime() then
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
	
	local sacred_arrow_left = CreateUnitByName("npc_dummy_mirana_arrow", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	sacred_arrow_left:SetForwardVector(arrow_direction_left)
	arrow_direction_left = RotateVector2D(arrow_direction_left, math.rad(secondary_angle))
	ability:ApplyDataDrivenModifier(caster, sacred_arrow_left, modifier_arrow, {})
	Physics:Unit(sacred_arrow_left)
	sacred_arrow_left:SetPhysicsVelocity(arrow_direction_left * arrow_speed_side * 1.58)	
	sacred_arrow_left:SetPhysicsFriction(0)
	sacred_arrow_left:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	sacred_arrow_left:SetAutoUnstuck(false)
	sacred_arrow_left:FollowNavMesh(false)
	sacred_arrow_left:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
	
	local sacred_arrow_right = CreateUnitByName("npc_dummy_mirana_arrow", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	sacred_arrow_right:SetForwardVector(arrow_direction_right)
	arrow_direction_right = RotateVector2D(arrow_direction_right, math.rad(secondary_angle * (-1)))
	ability:ApplyDataDrivenModifier(caster, sacred_arrow_right, modifier_arrow, {})
	Physics:Unit(sacred_arrow_right)
	sacred_arrow_right:SetPhysicsVelocity(arrow_direction_right * arrow_speed_side * 1.58)	
	sacred_arrow_right:SetPhysicsFriction(0)
	sacred_arrow_right:SetNavCollisionType(PHYSICS_NAV_NOTHING)
	sacred_arrow_right:SetAutoUnstuck(false)
	sacred_arrow_right:FollowNavMesh(false)
	sacred_arrow_right:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
	
	local distance = (target_pos - arrow_location):Length2D()
	
	-- Arrow duration counter (destroys the arrow after it travels for too long)
	local arrow_ticks = 0
	local arrow_ticks_left = 0
	local arrow_ticks_right = 0
	local angle_factor = 0
	local curve_duration = 0
	
	-- Calculate the Ticks to the range and buff
	local range_ticks = range / 29.9
	if distance > range then distance = range end
	angle_factor = distance / 1000
	curve_duration = distance / 29.9
	local buff_ticks = buff_range / 29.9
	angle_factor = 187500 * math.pow (distance,(-2.05))

	Timers:CreateTimer(0, function()

		-- Find nearby enemy units
		enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
		-- If no enemy is found, keep going
		if #enemy_units == 0 then
			arrow_ticks = arrow_ticks + 1
			
			-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
			if arrow_ticks >= range_ticks or IsNearEnemyClass(sacred_arrow, 1360, "ent_dota_fountain") then
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
				if not unit:IsRealHero() and is_night then
					if not unit:IsAncient() then
						unit:Kill(ability, caster)
						unit:EmitSound(sound_arrow)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, 9999, nil)
						ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

						-- Store the fact a non-hero was hit
						creep_hit = true
						creep_hit_store[1] = true
					end

				-- Else, it's a real hero; play sound, damage, and apply stun
				else
					-- Calculate hit distance 
					local distance = (sacred_arrow:GetAbsOrigin() - arrow_location):Length2D()

					-- Calculate and apply stun
					if distance < arrow_max_stunrange then
						arrow_stun_duration = distance * stun_per_100 / 100 + arrow_min_stun
					else
						arrow_stun_duration = arrow_max_stun
					end
					unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun_duration})

					-- Impact sound
					unit:EmitSound(sound_arrow)

					-- Impact vision
					ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)
					
					-- Apply Debuff
					AddStacks(ability_seed, caster, unit, debuff_stacks, 1, true)
					AddStacks(ability_seed, caster, unit, stack_counter, 1, true)
					
					if ((buff_ticks < arrow_ticks) and (creep_hit_store[1] == false) and scepter) then
						AddStacks(ability_seed, caster, unit, debuff_stacks, 1, true)
						AddStacks(ability_seed, caster, unit, stack_counter, 1, true)
					end
					
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
				if arrow_ticks >= range_ticks or IsNearEnemyClass(sacred_arrow, 1360, "ent_dota_fountain") then
					sacred_arrow:StopPhysicsSimulation()
					sacred_arrow:Destroy()
				else
					return 0.03
				end
			end
		end
	end)
	
	Timers:CreateTimer(0, function()

		-- Find nearby enemy units
		enemy_units_left = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow_left:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
		if #enemy_units_left == 0 then
			-- Calculate how long it has to rotate
			arrow_ticks_left = arrow_ticks_left + 1
			
			if (arrow_ticks_left < curve_duration) then
				arrow_direction_left = RotateVector2D(arrow_direction_left, math.rad((-1)*arrow_ticks_left*angle_factor))
				sacred_arrow_left:SetPhysicsVelocity(arrow_direction_left * arrow_speed_side * 1.58)
			end
				
			-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
			if arrow_ticks_left >= range_ticks or IsNearEnemyClass(sacred_arrow_left, 1360, "ent_dota_fountain") then
				sacred_arrow_left:StopPhysicsSimulation()
				sacred_arrow_left:Destroy()
			else
				return 0.03
			end

		-- Else, check targets' status
		else
			local creep_hit = false
			local hero_hit = false
			
			for _,unit in pairs(enemy_units_left) do

				-- If this unit is a non-ancient creep or illusion, kill it
				if not unit:IsRealHero() and is_night then
					if not unit:IsAncient() then
						unit:Kill(ability, caster)
						unit:EmitSound(sound_arrow)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, 9999, nil)
						ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

						-- Store the fact a non-hero was hit
						creep_hit = true
						creep_hit_store[2] = true
					end

				-- Else, it's a real hero; play sound, damage, and apply stun
				else
					-- Calculate hit distance 
					local distance = (sacred_arrow_left:GetAbsOrigin() - arrow_location):Length2D()

					-- Calculate and apply stun
					if distance < arrow_max_stunrange then
						arrow_stun_duration = distance * stun_per_100 / 100 + arrow_min_stun
					else
						arrow_stun_duration = arrow_max_stun
					end
					unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun_duration})

					-- Impact sound
					unit:EmitSound(sound_arrow)

					-- Impact vision
					ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

					-- Apply Debuff
					if ((buff_ticks < arrow_ticks_left) and (creep_hit_store[2] == false) and scepter) then
						AddStacks(ability_seed, caster, unit, debuff_stacks, 1, true)
						AddStacks(ability_seed, caster, unit, stack_counter, 1, true)
					end
					
					-- Calculate damage
					local actual_bonus_damage = 0
					if distance > arrow_max_stunrange then
						local extra_distance = distance - arrow_max_stunrange
						actual_bonus_damage = math.min(extra_distance * 0.001 * arrow_bonus_damage * 0.01, arrow_max_damage * 0.01) * unit:GetMaxHealth()
					end
					
					-- Damage
					local arrow_damage = base_damage + actual_bonus_damage					
					damage_table.victim = unit
					arrow_damage = (arrow_damage / 2.5)
					damage_table.damage = arrow_damage
					ApplyDamage(damage_table)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, arrow_damage, nil)

					-- Store the fact a hero was hit
					hero_hit = true
				end
			end

			-- If a hero was hit, or if a creep was hit during the day, destroy the arrow
			if hero_hit or ( creep_hit and not is_night ) then
				sacred_arrow_left:StopPhysicsSimulation()
				sacred_arrow_left:Destroy()
			
			-- Else, keep going
			else
				arrow_ticks_left = arrow_ticks_left + 1
			
				-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
				if arrow_ticks_left >= range_ticks or IsNearEnemyClass(sacred_arrow_left, 1360, "ent_dota_fountain") then
					sacred_arrow_left:StopPhysicsSimulation()
					sacred_arrow_left:Destroy()
				else
					return 0.03
				end
			end
		end
	end)
	
	Timers:CreateTimer(0, function()
		
		-- Find nearby enemy units
		enemy_units_right = FindUnitsInRadius(caster:GetTeamNumber(), sacred_arrow_right:GetAbsOrigin(), nil, arrow_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
		-- If no enemy is found, keep going
		if #enemy_units_right == 0 then
			-- Calculate how long it has to rotate
			arrow_ticks_right = arrow_ticks_right + 1
			if (arrow_ticks_right < curve_duration) then
				arrow_direction_right = RotateVector2D(arrow_direction_right, math.rad(arrow_ticks_right*angle_factor))
				sacred_arrow_right:SetPhysicsVelocity(arrow_direction_right * arrow_speed_side * 1.58)
			end
			
			-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
			if arrow_ticks_right >= range_ticks or IsNearEnemyClass(sacred_arrow_right, 1360, "ent_dota_fountain") then
				sacred_arrow_right:StopPhysicsSimulation()
				sacred_arrow_right:Destroy()
			else
				return 0.03
			end

		-- Else, check targets' status
		else
			local creep_hit = false
			local hero_hit = false
			for _,unit in pairs(enemy_units_right) do

				-- If this unit is a non-ancient creep or illusion, kill it
				if not unit:IsRealHero() and is_night then
					if not unit:IsAncient() then
						unit:Kill(ability, caster)
						unit:EmitSound(sound_arrow)
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, 9999, nil)
						ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

						-- Store the fact a non-hero was hit
						creep_hit = true
						creep_hit_store[3] = true
					end

				-- Else, it's a real hero; play sound, damage, and apply stun
				else
					-- Calculate hit distance 
					local distance = (sacred_arrow_right:GetAbsOrigin() - arrow_location):Length2D()

					-- Calculate and apply stun
					if distance < arrow_max_stunrange then
						arrow_stun_duration = distance * stun_per_100 / 100 + arrow_min_stun
					else
						arrow_stun_duration = arrow_max_stun
					end
					unit:AddNewModifier(caster, ability, "modifier_stunned", {duration = arrow_stun_duration})

					-- Impact sound
					unit:EmitSound(sound_arrow)

					-- Impact vision
					ability:CreateVisibilityNode(unit:GetAbsOrigin(), vision_radius, vision_duration)

					-- Apply Debuff
					if ((buff_ticks < arrow_ticks_right) and (creep_hit_store[3] == false) and scepter) then
						AddStacks(ability_seed, caster, unit, debuff_stacks, 1, true)
						AddStacks(ability_seed, caster, unit, stack_counter, 1, true)
					end
					
					-- Calculate damage
					local actual_bonus_damage = 0
					if distance > arrow_max_stunrange then
						local extra_distance = distance - arrow_max_stunrange
						actual_bonus_damage = math.min(extra_distance * 0.001 * arrow_bonus_damage * 0.01, arrow_max_damage * 0.01) * unit:GetMaxHealth()
					end
					
					-- Damage
					local arrow_damage = base_damage + actual_bonus_damage
					damage_table.victim = unit
					arrow_damage = (arrow_damage / 2.5)
					damage_table.damage = arrow_damage
					ApplyDamage(damage_table)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, unit, arrow_damage, nil)

					-- Store the fact a hero was hit
					hero_hit = true
				end
			end

			-- If a hero was hit, or if a creep was hit during the day, destroy the arrow
			if hero_hit or ( creep_hit and not is_night ) then
				sacred_arrow_right:StopPhysicsSimulation()
				sacred_arrow_right:Destroy()
			
			-- Else, keep going
			else
				arrow_ticks_right = arrow_ticks_right + 1
			
				-- Destroys the arrow after 1000 ticks (~30 seconds) or when near the enemy fountain
				if arrow_ticks_right >= range_ticks or IsNearEnemyClass(sacred_arrow_right, 1360, "ent_dota_fountain") then
					sacred_arrow_right:StopPhysicsSimulation()
					sacred_arrow_right:Destroy()
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

	-- Is it night time or Ultimate applied?
	local is_night = false
	if caster:HasModifier("modifier_moonlight_duration") or not GameRules:IsDaytime() then
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
	local modifier_stack = keys.modifier_stack

	-- If the target is affected by Moonlight Shadow, make it invisible for the remainder of the duration
	if target:HasModifier(modifier_buff) then
		
		-- Fetch the Moonlight Shadow buff
		local modifier_moonlight = target:FindModifierByNameAndCaster(modifier_buff, caster)
		local remaining_duration = modifier_moonlight:GetRemainingTime()

		-- Apply invisibility
		target:AddNewModifier(caster, ability, "modifier_invisible", {duration = remaining_duration})
	end
end