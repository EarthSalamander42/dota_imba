--[[	Author: Firetoad
		Date: 01.10.2015	]]

function GaleCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local distance = ability:GetLevelSpecialValueFor("distance", ability_level) + GetCastRangeIncrease(caster)
	local ward_radius = ability:GetLevelSpecialValueFor("ward_radius", ability_level)
	local caster_pos = caster:GetAbsOrigin()
	local projectile_speed = (target - caster_pos):Normalized() * speed

	-- Handle clicking exactly on top of the caster
	if projectile_speed == Vector(0, 0, 0) then
		projectile_speed = caster:GetForwardVector() * speed
	end
	projectile_speed = Vector(projectile_speed.x, projectile_speed.y, 0)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play random cast line
	Timers:CreateTimer(0.5, function()
		local random_int = RandomInt(1,2)
		caster:EmitSound("venomancer_venm_cast_0"..random_int)
	end)

	-- Launch caster projectile
	local gale_projectile = {
		Ability				= ability,
		EffectName			= particle_projectile,
		vSpawnOrigin		= caster_pos,
		fDistance			= distance,
		fStartRadius		= radius,
		fEndRadius			= radius,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags	= ,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= projectile_speed,
		bProvidesVision		= true,
		iVisionRadius		= 400,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(gale_projectile)

	-- Find nearby wards
	local nearby_wards = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, ward_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Launch projectiles from wards
	for _,ward in pairs(nearby_wards) do
		if ward:GetUnitName() == "npc_imba_venomancer_scourge_ward" then

			-- Calculate projectile direction
			local ward_pos = ward:GetAbsOrigin()
			projectile_speed = (target - ward_pos):Normalized() * speed

			-- Handle clicking exactly on top of the ward
			if projectile_speed == Vector(0, 0, 0) then
				projectile_speed = (target - caster_pos):Normalized() * speed
			end

			-- Play cast sound
			ward:EmitSound(sound_cast)

			-- Face projectile direction
			ward:SetForwardVector(projectile_speed)

			-- Launch ward projectile
			local ward_projectile = {
				Ability				= ability,
				EffectName			= particle_projectile,
				vSpawnOrigin		= ward_pos,
				fDistance			= distance,
				fStartRadius		= radius,
				fEndRadius			= radius,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			--	iUnitTargetFlags	= ,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			--	fExpireTime			= ,
				bDeleteOnHit		= false,
				vVelocity			= projectile_speed,
				bProvidesVision		= true,
				iVisionRadius		= 400,
				iVisionTeamNumber	= caster:GetTeamNumber(),
			}

			ProjectileManager:CreateLinearProjectile(ward_projectile)
		end
	end
end

function GaleHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_slow = keys.modifier_slow
	
	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("initial_damage", ability_level)
	local damage_pct = ability:GetLevelSpecialValueFor("initial_damage_pct", ability_level)
	local initial_slow = ability:GetLevelSpecialValueFor("initial_slow", ability_level)

	-- Play impact sound
	target:EmitSound(sound_hit)

	-- Apply slow modifier stacks
	if not target:HasModifier(modifier_slow) then
		AddStacks(ability, caster, target, modifier_slow, initial_slow, true)
	else
		local current_slow = target:GetModifierStackCount(modifier_slow, caster)
		AddStacks(ability, caster, target, modifier_slow, initial_slow - current_slow, true)
	end

	-- Calculate damage
	local target_health = target:GetMaxHealth()
	local final_damage = math.max(damage, target_health * damage_pct / 100)

	-- Halve damage if target is already poisoned
	if target:HasModifier(modifier_slow) then
		final_damage = final_damage / 2
	end

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = final_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, final_damage, nil)
end

function GaleTick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end
	
	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local tick_damage = ability:GetLevelSpecialValueFor("tick_damage", ability_level)
	local tick_damage_pct = ability:GetLevelSpecialValueFor("tick_damage_pct", ability_level)
	local slow_per_tick = ability:GetLevelSpecialValueFor("slow_per_tick", ability_level)

	-- Update slow modifier stacks
	AddStacks(ability, caster, target, modifier_slow, (-1) * slow_per_tick, false)

	-- Calculate damage
	local target_health = target:GetMaxHealth()
	local final_damage = math.max(tick_damage, target_health * tick_damage_pct / 100)

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = final_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, final_damage, nil)
end

function PoisonSting( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_sting = keys.modifier_sting

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end
	
	-- Parameters
	local caster_stacks = ability:GetLevelSpecialValueFor("caster_stacks", ability_level)
	local initial_stacks = ability:GetLevelSpecialValueFor("initial_stacks", ability_level)

	-- Fetch current stack amount
	local current_stacks = target:GetModifierStackCount(modifier_sting, caster)

	-- Add stacks according to the current amount
	if (current_stacks + caster_stacks) < initial_stacks then
		AddStacks(ability, caster, target, modifier_sting, initial_stacks, true)
	else
		AddStacks(ability, caster, target, modifier_sting, caster_stacks, true)
	end
end

function PoisonStingTick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_sting = keys.modifier_sting
	
	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end
	
	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local stack_decay = ability:GetLevelSpecialValueFor("stack_decay", ability_level)
	local stack_decay_min = ability:GetLevelSpecialValueFor("stack_decay_min", ability_level)
	local dmg_per_stack = ability:GetLevelSpecialValueFor("dmg_per_stack", ability_level)

	-- Fetch current stack amount
	local current_stacks = target:GetModifierStackCount(modifier_sting, caster)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = current_stacks * dmg_per_stack, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, current_stacks * dmg_per_stack, nil)

	-- Remove 10% of the stacks (minimum 2)
	AddStacks(ability, caster, target, modifier_sting, (-1) * math.max(stack_decay_min, current_stacks * stack_decay / 100), true)

	-- Remove the modifier is it is at zero stacks
	if target:GetModifierStackCount(modifier_sting, caster) < 1 then
		target:RemoveModifierByName(modifier_sting)
	end
end

function WardCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_caster_sting = caster:FindAbilityByName(keys.ability_caster_sting)
	local ability_scourge = keys.ability_scourge
	local ability_sting = keys.ability_sting
	local sound_cast = keys.sound_cast
	local modifier_ward = keys.modifier_ward
	
	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local plague_amount = ability:GetLevelSpecialValueFor("plague_amount", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play random cast line
	Timers:CreateTimer(0.5, function()
		local random_int = RandomInt(1,6)
		caster:EmitSound("venomancer_venm_ability_ward_0"..random_int)
	end)

	-- Spawn Scourge Ward
	local scourge_ward = CreateUnitByName("npc_imba_venomancer_scourge_ward", target, true, caster, caster, caster:GetTeamNumber())
	scourge_ward:SetControllableByPlayer(caster:GetPlayerID(), true)

	-- Prevent nearby units from getting stuck
	Timers:CreateTimer(0.01, function()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 64, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
		end
	end)

	-- Apply ward modifiers (controls damage taken and duration)
	ability:ApplyDataDrivenModifier(caster, scourge_ward, modifier_ward, {})
	scourge_ward:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

	-- Align ward to face the cast direction
	scourge_ward:SetForwardVector(caster:GetForwardVector())

	-- Grant the multiattack ability to the scourge ward
	scourge_ward:AddAbility(ability_scourge)
	local learned_multiattack = scourge_ward:FindAbilityByName(ability_scourge)
	learned_multiattack:SetLevel(1)

	-- Grant the ward poison sting if the caster has learned it
	if ability_caster_sting and ability_caster_sting:GetLevel() > 0 then
		scourge_ward:AddAbility(ability_sting)
		local learned_sting = scourge_ward:FindAbilityByName(ability_sting)
		learned_sting:SetLevel(1)
	end

	-- Kill the ward if too near the enemy fountain
	if IsNearEnemyClass(scourge_ward, 1360, "ent_dota_fountain") then
		scourge_ward:Kill(ability, caster)
	end

	-- Spawn Plague Wards
	for i = 1,plague_amount do
		local spawn_point = RotatePosition(target, QAngle(0, i * 360 / plague_amount, 0), target + caster:GetForwardVector() * 125 )
		local plague_ward = CreateUnitByName("npc_imba_venomancer_plague_ward", spawn_point, true, caster, caster, caster:GetTeamNumber())
		plague_ward:SetControllableByPlayer(caster:GetPlayerID(), true)

		-- Prevent nearby units from getting stuck
		Timers:CreateTimer(0.01, function()
			local units = FindUnitsInRadius(caster:GetTeamNumber(), spawn_point, nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end)

		-- Apply ward modifiers (controls damage taken and duration)
		ability:ApplyDataDrivenModifier(caster, plague_ward, modifier_ward, {})
		plague_ward:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})

		-- Grant the ward poison sting if the caster has learned it
		if ability_caster_sting and ability_caster_sting:GetLevel() > 0 then
			plague_ward:AddAbility(ability_sting)
			local learned_sting = plague_ward:FindAbilityByName(ability_sting)
			learned_sting:SetLevel(1)
		end

		-- Kill the ward if too near the enemy fountain
		if IsNearEnemyClass(plague_ward, 1360, "ent_dota_fountain") then
			plague_ward:Kill(ability, caster)
		end
	end
end

function WardDamage( keys )
	local caster = keys.caster
	local ward = keys.target
	local attacker = keys.attacker
	local ability = keys.ability

	-- If the ability was unlearned, do nothing
	if not ability then
		ward:Kill(ability, attacker)
		return nil
	end
	
	-- Parameters
	local damage = 1
	
	-- If the attacker is a hero, deal more damage
	if attacker:IsHero() or attacker:IsTower() or IsRoshan(attacker) then
		local ability_level = ability:GetLevel() - 1
		damage = ability:GetLevelSpecialValueFor("plague_creep_health", ability_level)
	end

	-- If the damage is enough to kill the ward, destroy it
	if ward:GetHealth() <= damage then
		ward:Kill(ability, attacker)

	-- Else, reduce its HP
	else
		ward:SetHealth(ward:GetHealth() - damage)
	end
end

function WardSting( keys )
	local caster = keys.caster:GetOwnerEntity()
	local target = keys.target
	local ability = caster:FindAbilityByName(keys.ability_sting)
	local ability_level = ability:GetLevel() - 1
	local modifier_sting = keys.modifier_sting

	-- If the target is a building, or the ability was unlearned, do nothing
	if target:IsBuilding() or IsRoshan(target) or not ability then
		return nil
	end

	-- Parameters
	local initial_stacks = ability:GetLevelSpecialValueFor("initial_stacks", ability_level)

	-- Fetch current stack amount
	local current_stacks = target:GetModifierStackCount(modifier_sting, caster)

	-- Add stacks according to the current amount
	if (current_stacks + 1) < initial_stacks then
		AddStacks(ability, caster, target, modifier_sting, initial_stacks - current_stacks, true)
	else
		AddStacks(ability, caster, target, modifier_sting, 1, true)
	end
end

function ScourgeWardAttack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_sting = caster:FindAbilityByName(keys.ability_sting)
	local sound_attack = keys.sound_attack
	local projectile_attack = keys.projectile_attack

	-- Parameters
	local attack_delay = ability:GetLevelSpecialValueFor("attack_delay", ability_level)
	local attack_range = ability:GetLevelSpecialValueFor("attack_range", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- Animate an attack
	StartAnimation(caster, {duration = 1.45, activity = ACT_DOTA_ATTACK, rate = 0.65})

	-- Play attack sound
	caster:EmitSound(sound_attack)

	-- Find enemies in range and attack them
	Timers:CreateTimer(attack_delay, function()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, attack_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			poison_projectile = {
				Target = enemy,
				Source = caster,
				Ability = ability_sting,
				EffectName = projectile_attack,
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
				iVisionRadius = 0,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}

			damage_projectile = {
				Target = enemy,
				Source = caster,
				Ability = ability,
			--	EffectName = "",
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = projectile_speed,
				iVisionRadius = 0,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}

			ProjectileManager:CreateTrackingProjectile(damage_projectile)
			ProjectileManager:CreateTrackingProjectile(poison_projectile)
		end
	end)
end

function ScourgeWardHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit

	-- Parameters
	local attack_damage = ability:GetLevelSpecialValueFor("attack_damage", ability_level)

	-- Play attack sound
	target:EmitSound(sound_hit)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = attack_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function PoisonNova( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_nova = keys.particle_nova

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Play random cast line
	Timers:CreateTimer(0.5, function()
		local random_int = RandomInt(1,4)
		if random_int == 1 then
			caster:EmitSound("venomancer_venm_ability_nova_01")
		elseif random_int == 2 then
			caster:EmitSound("venomancer_venm_ability_nova_02")
		elseif random_int == 3 then
			caster:EmitSound("venomancer_venm_ability_nova_06")
		elseif random_int == 4 then
			caster:EmitSound("venomancer_venm_ability_nova_21")
		end
	end)

	-- Make caster briefly visible
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 1.0)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 1.0)

	-- Fire particle
	local nova_pfx = ParticleManager:CreateParticle(particle_nova, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(nova_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(nova_pfx, 1, Vector(radius * 1.2, 1, radius))
	ParticleManager:SetParticleControl(nova_pfx, 2, Vector(0, 0, 0))
end

function PoisonNovaTick( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_nova = keys.modifier_nova
	local scepter = HasScepter(caster)

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end
	
	-- Parameters
	local ability_level = ability:GetLevel() - 1
	local damage_min = ability:GetLevelSpecialValueFor("damage_min", ability_level)
	local damage_pct = ability:GetLevelSpecialValueFor("damage_pct", ability_level)
	local contagion_extra_duration = ability:GetLevelSpecialValueFor("contagion_extra_duration", ability_level)
	local contagion_radius_scepter = ability:GetLevelSpecialValueFor("contagion_radius_scepter", ability_level)
	if scepter then
		damage_min = ability:GetLevelSpecialValueFor("damage_min_scepter", ability_level)
	end

	-- Calculate damage to deal
	local target_health = target:GetHealth()
	local damage = math.max(damage_min, target_health * damage_pct / 100)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, damage, nil)

	-- If the caster has a scepter, spread the debuff to nearby enemies
	if scepter then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, contagion_radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		local modifier = target:FindModifierByNameAndCaster(modifier_nova, caster)
		local duration = contagion_extra_duration
		if modifier then
			duration = duration + modifier:GetRemainingTime()
		end
		
		for _,enemy in pairs(enemies) do
			
			-- If this enemy doesn't have the debuff, spread it, with the same remaining duration
			if not enemy:HasModifier(modifier_nova) then
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_nova, {duration = duration})
			end
		end
	end
end

function Toxicity( keys )
	local caster = keys.caster
	local target = keys.target
	local ability_poison = caster:FindAbilityByName(keys.ability_poison)
	local modifier_poison = keys.modifier_poison

	-- Increase stacks by one
	if ability_poison then
		AddStacks(ability_poison, caster, target, modifier_poison, 1, true)
	end
end

function ToxicityDown( keys )
	local caster = keys.caster
	local target = keys.target
	local ability_poison = caster:FindAbilityByName(keys.ability_poison)
	local modifier_poison = keys.modifier_poison

	-- If the ability was unlearned, remove the modifier
	if not ability_poison then
		target:RemoveModifierByName(modifier_poison)
		return nil
	end
	
	-- Reduce stacks by one
	AddStacks(ability_poison, caster, target, modifier_poison, -1, true)

	-- Remove the modifier is it is at zero stacks
	if target:GetModifierStackCount(modifier_poison, caster) < 1 then
		target:RemoveModifierByName(modifier_poison)
	end
end