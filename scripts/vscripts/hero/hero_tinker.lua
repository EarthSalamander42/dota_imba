--[[	Author: Firetoad
		Date: 10.09.2015	]]

function Laser( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_rearm = caster:FindAbilityByName(keys.ability_rearm)
	local particle_laser = keys.particle_laser
	local sound_cast = keys.sound_cast
	local sound_impact = keys.sound_impact
	local modifier_rearm_stack = keys.modifier_rearm_stack
	local modifier_rearm_mana = keys.modifier_rearm_mana
	local modifier_blind = keys.modifier_blind
	local scepter = HasScepter(caster)
	
	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("base_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local blind_aoe = ability:GetLevelSpecialValueFor("blind_aoe", ability_level)
	local stack_damage = ability:GetLevelSpecialValueFor("stack_damage", ability_level)
	local stack_duration = ability:GetLevelSpecialValueFor("stack_duration", ability_level)
	local bounce_range = ability:GetLevelSpecialValueFor("bounce_range_scepter", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Rearm stacks logic
	local rearm_stacks = caster:GetModifierStackCount(modifier_rearm_stack, caster)
	if ability_rearm and rearm_stacks > 0 then
		AddStacks(ability_rearm, caster, caster, modifier_rearm_stack, 0, true)
		AddStacks(ability_rearm, caster, caster, modifier_rearm_mana, 0, true)
		duration = duration + stack_duration * rearm_stacks
		damage = damage + stack_damage * rearm_stacks
	end

	-- Draw initial particle
	local laser_pfx = ParticleManager:CreateParticle(particle_laser, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(laser_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(laser_pfx, 9, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)

	-- If the target is a hero, play the impact sound
	if target:IsRealHero() then
		target:EmitSound(sound_impact)
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

	-- Blind nearby units
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, blind_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_blind, {duration = duration})
	end

	-- If scepter, refract
	if scepter then
		
		-- Initialize bounce tracking variables
		local targets_hit = {}
		local current_source = target
		local should_bounce = true
		targets_hit[1] = target

		-- Refraction loop
		while should_bounce do
			should_bounce = false

			-- Check for enemies not yet hit by this cast of Laser
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_source:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			for _,enemy in pairs(nearby_enemies) do
				local already_hit = false
				for _,hit_enemy in pairs(targets_hit) do
					if hit_enemy == enemy then
						already_hit = true
						break
					end
				end

				-- Found a valid enemy, create a projectile for it
				if not already_hit then

					-- Draw the bounce particle
					local laser_bounce_pfx = ParticleManager:CreateParticle(particle_laser, PATTACH_CUSTOMORIGIN, current_source)
					ParticleManager:SetParticleControlEnt(laser_bounce_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(laser_bounce_pfx, 9, current_source, PATTACH_POINT_FOLLOW, "attach_hitloc", current_source:GetAbsOrigin(), true)

					-- If the target is a hero, play the impact sound
					if enemy:IsRealHero() then
						enemy:EmitSound(sound_impact)
					end

					-- Deal damage
					ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

					-- Blind nearby units
					local blind_enemies = FindUnitsInRadius(caster:GetTeamNumber(), enemy:GetAbsOrigin(), nil, blind_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,blind_enemy in pairs(blind_enemies) do
						ability:ApplyDataDrivenModifier(caster, blind_enemy, modifier_blind, {duration = duration})
					end

					-- Set up the next bounce
					should_bounce = true
					current_source = enemy
					targets_hit[#targets_hit + 1] = enemy
					break
				end
			end
		end
	end
end

function Missile( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_rearm = caster:FindAbilityByName(keys.ability_rearm)
	local particle_missile = keys.particle_missile
	local particle_dud = keys.particle_dud
	local sound_cast = keys.sound_cast
	local sound_dud = keys.sound_dud
	local modifier_rearm_stack = keys.modifier_rearm_stack
	local modifier_rearm_mana = keys.modifier_rearm_mana
	local scepter = HasScepter(caster)
	
	-- Parameters
	local search_range = ability:GetLevelSpecialValueFor("search_range", ability_level)
	local missile_count = ability:GetLevelSpecialValueFor("base_count", ability_level)
	local stack_count = ability:GetLevelSpecialValueFor("stack_count", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Scepter logic
	if scepter then
		missile_count = missile_count * 2
	end

	-- Rearm stacks logic
	local rearm_stacks = caster:GetModifierStackCount(modifier_rearm_stack, caster)
	if ability_rearm and rearm_stacks > 0 then
		AddStacks(ability_rearm, caster, caster, modifier_rearm_stack, 0, true)
		AddStacks(ability_rearm, caster, caster, modifier_rearm_mana, 0, true)
		missile_count = missile_count + stack_count * rearm_stacks
	end

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Find valid targets
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- If no valid units are found, dud
	if #heroes == 0 and #units == 0 then
		local dud_pfx = ParticleManager:CreateParticle(particle_dud, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(dud_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
		caster:EmitSound(sound_dud)
		return nil
	end

	-- Else, shoot missiles at heroes
	local hero_missiles = math.min(#heroes, missile_count)
	for i = 1, hero_missiles do
		local hero_projectile = {
			Target = heroes[i],
			Source = caster,
			Ability = ability,
			EffectName = particle_missile,
			bDodgeable = true,
			bProvidesVision = false,
			iMoveSpeed = speed,
		--	iVisionRadius = vision_radius,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = caster:ScriptLookupAttachment("attach_attack3")
		}
		ProjectileManager:CreateTrackingProjectile(hero_projectile)
	end

	-- Shoot the remaining missiles at random units in range
	missile_count = missile_count - hero_missiles
	if #units > 0 then
		for i = 1, missile_count do
			local random_projectile = {
				Target = units[RandomInt(1, #units)],
				Source = caster,
				Ability = ability,
				EffectName = particle_missile,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = caster:ScriptLookupAttachment("attach_attack3")
			}
			ProjectileManager:CreateTrackingProjectile(random_projectile)
		end
	end
end

function March( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_rearm = caster:FindAbilityByName(keys.ability_rearm)
	local sound_cast = keys.sound_cast
	local modifier_machine = keys.modifier_machine
	local modifier_rearm_stack = keys.modifier_rearm_stack
	local modifier_rearm_mana = keys.modifier_rearm_mana
	local scepter = HasScepter(caster)
	
	-- Parameters
	local spawner_width = ability:GetLevelSpecialValueFor("spawner_width", ability_level)
	local spawner_amount = ability:GetLevelSpecialValueFor("spawner_amount", ability_level)
	local movement_scepter = ability:GetLevelSpecialValueFor("movement_scepter", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Rearm stacks logic
	local rearm_stacks = caster:GetModifierStackCount(modifier_rearm_stack, caster)
	if ability_rearm and rearm_stacks > 0 then
		AddStacks(ability_rearm, caster, caster, modifier_rearm_stack, 0, true)
		AddStacks(ability_rearm, caster, caster, modifier_rearm_mana, 0, true)
		spawner_amount = spawner_amount + rearm_stacks
	end

	-- Calculate fixed spawn point positions
	local spawn_points = {}
	local caster_pos = caster:GetAbsOrigin()
	local target_direction = (target - caster_pos):Normalized()
	if target == caster_pos then
		target_direction = caster:GetForwardVector()
	end
	spawn_points[1] = RotatePosition(target, QAngle(0, -90, 0), target + target_direction * spawner_width / 2 )
	spawn_points[2] = RotatePosition(target, QAngle(0, 90, 0), target + target_direction * spawner_width / 2 )

	-- Calculate variable spawn point positions
	if spawner_amount <= 3 then
		spawn_points[3] = target
	else
		for i = 3,spawner_amount do
			spawn_points[i] = RotatePosition(target, QAngle(0, (i - 2) * 360 / (spawner_amount - 2), 0), target + target_direction * spawner_width / 4 )
		end
	end

	-- Place spawners on spawn positions
	for _,spawn_point in pairs(spawn_points) do

		-- Spawn spawner
		local spawner = CreateUnitByName("npc_imba_tinker_mom_spawner", spawn_point, false, nil, nil, caster:GetTeamNumber())

		-- Apply spawner modifier (controls projectile spawning)
		ability:ApplyDataDrivenModifier(caster, spawner, modifier_machine, {})

		-- Align spawner to face the cast direction
		spawner:SetForwardVector(target_direction)
		
		-- If scepter, make the spawners controllable
		if scepter then
			Physics:Unit(spawner)
			spawner:SetPhysicsVelocity(target_direction * movement_scepter)	
			spawner:SetPhysicsFriction(0)
			spawner:SetNavCollisionType(PHYSICS_NAV_NOTHING)
		else
			spawner:AddNewModifier(spawner, ability, "modifier_rooted", {})
		end

		-- Movement animation
		StartAnimation(spawner, {duration = 12, activity = ACT_DOTA_RUN, rate = 1.0})
	end
end

function MarchSpawn( keys )
	local caster = keys.caster
	local spawner = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_machine = keys.particle_machine

	-- If the ability was unlearned, or the spawner is near the enemy fountain, destroy it
	if not ability or IsNearEnemyClass(spawner, 1360, "ent_dota_fountain")then
		spawner:Destroy()
		return nil
	end
	
	-- Parameters
	local spawn_radius = ability:GetLevelSpecialValueFor("spawn_radius", ability_level)
	local spawn_length = ability:GetLevelSpecialValueFor("spawn_length", ability_level)
	local collision_radius = ability:GetLevelSpecialValueFor("collision_radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Calculate spawn point
	local spawner_loc = spawner:GetAbsOrigin()
	local forward_direction = spawner:GetForwardVector()
	local spawn_start = spawner_loc - forward_direction * spawn_length / 3
	local spawn_point = RotatePosition(spawn_start, QAngle(0, 90, 0), spawn_start + forward_direction * ( RandomInt(0, 10) - 5 ) * spawn_radius / 5 )

	-- Spawn projectile
	local machine_projectile = {
		Ability				= ability,
		EffectName			= particle_machine,
		vSpawnOrigin		= spawn_point,
		fDistance			= spawn_length,
		fStartRadius		= collision_radius,
		fEndRadius			= collision_radius,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags	= ,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
	--	fExpireTime			= ,
		bDeleteOnHit		= true,
		vVelocity			= Vector(forward_direction.x, forward_direction.y, 0) * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}
	ProjectileManager:CreateLinearProjectile(machine_projectile)

	-- If this spawner is dying, destroy it
	if spawner:GetHealth() <= 1 then
		spawner:Destroy()

	-- If not, reduce its health by 1
	else
		spawner:SetHealth( spawner:GetHealth() - 1 )
	end
end

function MarchDamage( keys )
	local caster = keys.caster
	local spawner = keys.target
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end
	
	-- Parameters
	local attacks_to_kill = ability:GetLevelSpecialValueFor("attacks_to_kill", ability_level)
	local max_spawns = ability:GetLevelSpecialValueFor("max_spawns", ability_level)
	local damage = 1

	-- If the attacker is a hero, deal more damage
	if attacker:IsHero() then
		damage = math.ceil( max_spawns / attacks_to_kill )
	end

	-- If the damage is enough to kill the spawner, destroy it
	if spawner:GetHealth() <= damage then
		spawner:Destroy()

	-- Else, reduce its HP
	else
		spawner:SetHealth(spawner:GetHealth() - damage)
	end
end

function Rearm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_rearm = keys.particle_rearm
	local sound_cast = keys.sound_cast
	local modifier_stack = keys.modifier_stack
	local modifier_mana = keys.modifier_mana
	
	-- Parameters
	local cooldown = ability:GetLevelSpecialValueFor("cooldown_tooltip", ability_level)
	local stack_duration = ability:GetLevelSpecialValueFor("stack_duration", ability_level)

	-- Add buff stacks
	if not IsNearFriendlyClass(caster, 1360, "ent_dota_fountain") then
		AddStacks(ability, caster, caster, modifier_stack, 1, true)

		-- Fetch current amount of stacks
		local current_stacks = caster:GetModifierStackCount(modifier_stack, caster)
		local mana_stacks = current_stacks ^ 2

		-- Add mana penalty stacks
		AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
	end

	-- List of unrefreshable abilities (for Random OMG/LOD modes)
	local forbidden_abilities = {
		"imba_tinker_rearm",
		"ancient_apparition_ice_blast",
		"zuus_thundergods_wrath",
		"furion_wrath_of_nature",
		"imba_magnus_reverse_polarity",
		"imba_omniknight_guardian_angel",
		"imba_mirana_arrow",
		"imba_dazzle_shallow_grave",
		"imba_wraith_king_reincarnation",
		"imba_abaddon_borrowed_time",
		"furion_force_of_nature",
		"imba_nyx_assassin_spiked_carapace",
		"elder_titan_earth_splitter",
		"imba_centaur_stampede"
	}

	-- List of unrefreshable items
	local forbidden_items = {
		"item_imba_bloodstone",
		"item_imba_arcane_boots",
		"item_imba_mekansm",
		"item_imba_mekansm_2",
		"item_imba_guardian_greaves",
		"item_imba_hand_of_midas",
		"item_imba_white_queen_cape",
		"item_imba_black_king_bar",
		"item_imba_refresher",
		"item_imba_necronomicon",
		"item_imba_necronomicon_2",
		"item_imba_necronomicon_3",
		"item_imba_necronomicon_4",
		"item_imba_necronomicon_5",
		"item_imba_skadi"
	}

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play a random cast line
	caster:EmitSound("tink_ability_rearm_0"..RandomInt(1, 9))

	-- Fire particle
	local rearm_pfx = ParticleManager:CreateParticle(particle_rearm, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(rearm_pfx, 0, caster:GetAbsOrigin())

	-- Play animation
	if ability_level == 0 then
		StartAnimation(caster, {duration = 3.0, activity = ACT_DOTA_TINKER_REARM1, rate = 1.0})
	elseif ability_level == 1 then
		StartAnimation(caster, {duration = 2.0, activity = ACT_DOTA_TINKER_REARM2, rate = 1.0})
	elseif ability_level == 2 then
		StartAnimation(caster, {duration = 1.0, activity = ACT_DOTA_TINKER_REARM3, rate = 1.0})
	end

	-- Refresh abilities
	for i = 0, 15 do
		local current_ability = caster:GetAbilityByIndex(i)
		local should_refresh = true

		-- If this ability is forbidden, do not refresh it
		for _,forbidden_ability in pairs(forbidden_abilities) do
			if current_ability and current_ability:GetName() == forbidden_ability then
				should_refresh = false
			end
		end

		-- Refresh
		if current_ability and should_refresh then
			current_ability:EndCooldown()
		end
	end

	-- Refresh items
	for i = 0, 5 do
		local current_item = caster:GetItemInSlot(i)
		local should_refresh = true

		-- If this item is forbidden, do not refresh it
		for _,forbidden_item in pairs(forbidden_items) do
			if current_item and current_item:GetName() == forbidden_item then
				should_refresh = false
			end
		end

		-- Refresh
		if current_item and should_refresh then
			current_item:EndCooldown()
		end
	end

	-- Put Rearm on cooldown
	ability:StartCooldown(cooldown)
end

function RearmStacksCheck( keys )
	local caster = keys.caster
	local modifier_stack = keys.modifier_stack
	local modifier_mana = keys.modifier_mana

	-- Removes Rearm stacks if near the fountain
	if IsNearFriendlyClass(caster, 1360, "ent_dota_fountain") then
		caster:RemoveModifierByName(modifier_stack)
		caster:RemoveModifierByName(modifier_mana)
	end
end