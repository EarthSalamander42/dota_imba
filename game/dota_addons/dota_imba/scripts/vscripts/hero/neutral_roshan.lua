--[[	Author: Firetoad
		Date: 12.08.2015	]]

function RoshanBash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff
	local sound_bash = keys.sound_bash

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local stacking_damage = ability:GetSpecialValueFor("stacking_damage")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local stacking_armor = ability:GetSpecialValueFor("stacking_armor")
	local bash_duration = ability:GetSpecialValueFor("bash_duration")

	-- Calculate updated parameters
	local total_damage = base_damage + stacking_damage * GAME_ROSHAN_KILLS
	local total_armor = base_armor + stacking_armor * GAME_ROSHAN_KILLS

	-- Start ability cooldown
	ability:StartCooldown(ability:GetCooldown(1))

	-- Play sound
	target:EmitSound(sound_bash)

	-- Stun target
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})

	-- Apply debuff modifier
	AddStacks(ability, caster, target, modifier_debuff, total_armor, true)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function RoshanSlam( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_slow = keys.modifier_slow
	local modifier_armor = keys.modifier_armor
	local sound_cast = keys.sound_cast
	local particle_slam = keys.particle_slam

	-- Parameters
	local slam_radius = ability:GetSpecialValueFor("slam_radius")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local stacking_damage = ability:GetSpecialValueFor("stacking_damage")
	local base_armor = ability:GetSpecialValueFor("base_armor")
	local stacking_armor = ability:GetSpecialValueFor("stacking_armor")
	local caster_loc = caster:GetAbsOrigin()

	-- Calculate updated parameters
	local total_damage = base_damage + stacking_damage * GAME_ROSHAN_KILLS
	local total_armor = base_armor + stacking_armor * GAME_ROSHAN_KILLS

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local slam_pfx = ParticleManager:CreateParticle(particle_slam, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(slam_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(slam_pfx, 1, Vector(slam_radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(slam_pfx)

	-- Iterate through targets
	local slam_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, slam_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,target in pairs(slam_targets) do
		
		-- Apply slow and armor debuffs
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
		AddStacks(ability, caster, target, modifier_armor, total_armor, true)

		-- Deal damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end

	-- Trigger reduced cooldown
	Timers:CreateTimer(0.1, function()
		ability:EndCooldown()
		ability:StartCooldown(math.max(ability:GetCooldown(1) - #slam_targets, 1))
	end)
end

function RoshanSummon( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_summon = keys.sound_summon

	-- Parameters
	local summon_duration = ability:GetSpecialValueFor("summon_duration")
	local caster_loc = caster:GetAbsOrigin()
	local caster_direction = caster:GetForwardVector()
	local summon_name = "npc_imba_roshling"
	local summon_amount = 1 + GAME_ROSHAN_KILLS
	local summon_abilities = {
		"imba_roshling_bash",
		"imba_roshling_aura"
	}

	-- Play cast sound
	caster:EmitSound(sound_summon)

	-- Calculate summon positions
	local summon_positions = {}
	for i = 1, summon_amount do
		summon_positions[i] = RotatePosition(caster_loc, QAngle(0, (i - 1) * 360 / summon_amount, 0), caster_loc + caster_direction * 150)
	end

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(caster_loc, 250, false)

	-- Spawn the summons
	for i = 1, summon_amount do
		local roshling_summon = CreateUnitByName(summon_name, summon_positions[i], true, caster, caster, caster:GetTeam())

		-- Make the summons limited duration
		roshling_summon:AddNewModifier(caster, ability, "modifier_kill", {duration = summon_duration})

		-- Level up the summon's abilities
		for _, summon_ability in pairs(summon_abilities) do
			if roshling_summon:FindAbilityByName(summon_ability) then
				roshling_summon:FindAbilityByName(summon_ability):SetLevel(1)
			end
		end
	end
end

function RoshanSummonAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_bonus = keys.modifier_bonus

	-- Parameters
	local bonus_damage = ability:GetSpecialValueFor("bonus_damage")

	-- Fetch the amount of stacks on the target
	local total_bonus = target:GetModifierStackCount(modifier_bonus, nil)

	-- Calculate damage
	local damage = caster:GetAttackDamage() * bonus_damage * total_bonus * 0.01

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function RoshlingBash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff = keys.modifier_debuff

	-- Add a stack of Fury Smash
	AddStacks(ability, caster, target, modifier_debuff, 1, true)
end

function RoshanRage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Parameters
	local base_hp_threshold = ability:GetSpecialValueFor("base_hp_threshold")
	local stacking_hp_threshold_perc = ability:GetSpecialValueFor("stacking_hp_threshold_perc")

	-- Calculate total buff stacks
	local hp_per_stack = base_hp_threshold * (stacking_hp_threshold_perc ^ GAME_ROSHAN_KILLS)
	local total_stacks = math.floor( (caster:GetMaxHealth() - caster:GetHealth()) / hp_per_stack )

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function RoshanFury( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local particle_fury = keys.particle_fury

	-- Parameters
	local width = ability:GetSpecialValueFor("width")
	local length = ability:GetSpecialValueFor("length")
	local speed = ability:GetSpecialValueFor("speed")

	-- Projectile geometry
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	
	local projectile_direction
	if caster_pos == target_pos then
		projectile_direction = caster:GetForwardVector()
	else
		projectile_direction = (target_pos - caster_pos):Normalized()
	end
	-- Play sound
	caster:EmitSound(sound_cast)

	-- Create projectile
	local projectile_fury = {
		Ability				= ability,
		EffectName			= particle_fury,
		vSpawnOrigin		= caster_pos,
		fDistance			= length,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= projectile_direction * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(projectile_fury)
end

function RoshanFuryHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local length = ability:GetSpecialValueFor("length")
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local stacking_damage = ability:GetSpecialValueFor("stacking_damage")
	local debuff_duration = ability:GetSpecialValueFor("debuff_duration")

	-- Calculate total damage
	local total_damage = base_damage + stacking_damage * GAME_ROSHAN_KILLS

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Knockback calculations
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local knockback_pos = caster_pos + ( target_pos - caster_pos ):Normalized() * length
	local knockback_distance = ( knockback_pos - target_pos ):Length2D()
	if ( target_pos - caster_pos ):Length2D() > length then
		knockback_distance = 50
	end

	-- Knockback
	local fury_knockback =	{
		should_stun = 1,
		knockback_duration = debuff_duration,
		duration = debuff_duration,
		knockback_distance = knockback_distance,
		knockback_height = 0,
		center_x = caster_pos.x,
		center_y = caster_pos.y,
		center_z = caster_pos.z
	}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", fury_knockback)
end

function RoshanUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Calculate total buff stacks
	local total_stacks = GAME_ROSHAN_KILLS

	-- Update health
	local bonus_health = ability:GetSpecialValueFor("bonus_health")
	Timers:CreateTimer(0.5, function()
		SetCreatureHealth(caster, 7000 + bonus_health * total_stacks, true)
	end)

	-- Update the stacks buff
	if total_stacks > 0 then
		AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
	end
end

function RoshanIllusionPurge( keys )
	local attacker = keys.attacker

	if attacker:IsIllusion() then
		attacker:ForceKill(true)
	end
end

function RoshanDeath( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local respawn_time = ROSHAN_RESPAWN_TIME

	-- Increase Roshan's death count
	_G.GAME_ROSHAN_KILLS = _G.GAME_ROSHAN_KILLS + 1

	-- Drop the Aegis
	local drop_aegis = CreateItem("item_imba_aegis", nil, nil)
	CreateItemOnPositionSync(caster:GetAbsOrigin(), drop_aegis)
	drop_aegis:LaunchLoot(false, 100, 0.5, caster:GetAbsOrigin())

	-- On each sucessive death, grant extra chesse
	if _G.GAME_ROSHAN_KILLS > 1 then
		for i = 2, _G.GAME_ROSHAN_KILLS do
			local drop_cheese = CreateItem("item_imba_cheese", nil, nil)
			CreateItemOnPositionSync(caster:GetAbsOrigin(), drop_cheese)
			drop_cheese:LaunchLoot(false, 100, 0.5, caster:GetAbsOrigin() + RandomVector(100))
		end
	end

	-- After the respawn timer elapses, spawn another Roshan
	Timers:CreateTimer(respawn_time, function()
		local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
		local roshan = CreateUnitByName("npc_imba_roshan", roshan_spawn_loc, true, nil, nil, DOTA_TEAM_NEUTRALS)
	end)
end

function RoshanAIstart( keys )
	local caster = keys.caster

	-- If the AI is not active, kickstart it
	if not caster.ai_is_active then
		caster.ai_is_active = true
	end
end

function RoshanAIthink( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Search for enemies in the attack search radius
	local attack_search_range_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	if #attack_search_range_enemies > 0 then
		caster.ai_is_active = true
		caster.closest_attack_target = attack_search_range_enemies[1]
	else
		caster.closest_attack_target = nil
	end

	-- Make couriers dodge Roshan
	local roshan_loc = caster:GetAbsOrigin()
	local nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), roshan_loc, nil, 600, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,potential_courier in pairs(nearby_targets) do
		if potential_courier:GetUnitName() == "npc_dota_courier" then
			local courier_loc = potential_courier:GetAbsOrigin()
			FindClearSpaceForUnit(potential_courier, courier_loc + (courier_loc - roshan_loc):Normalized() * 300, true)
		end
	end

	-- Parameters
	local slam_radius = ability:GetSpecialValueFor("slam_radius")
	local roshling_pct = ability:GetSpecialValueFor("roshling_pct")
	local fury_pct = ability:GetSpecialValueFor("fury_pct")
	local leash_radius = ability:GetSpecialValueFor("leash_radius")
	local leash_time = ability:GetSpecialValueFor("leash_time")
	local super_leash_time = ability:GetSpecialValueFor("super_leash_time")
	local leash_margin = ability:GetSpecialValueFor("leash_margin")
	local spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()
	local ability_slam = caster:FindAbilityByName("imba_roshan_slam")
	local ability_roshling = caster:FindAbilityByName("imba_roshan_summon")
	local ability_fury = caster:FindAbilityByName("imba_roshan_fury")

	-- Condition variables
	local roshan_hp = caster:GetHealth() / caster:GetMaxHealth()

	-- Check if currently leashing back to the spawn position
	if caster.ai_is_leashing_back then

		-- Check if leashing back was successful
		if (roshan_loc - spawn_loc):Length2D() < leash_margin then
			caster.ai_is_leashing_back = nil
			caster.ai_leashing_delay = nil
			caster.ai_is_active = nil
			caster.closest_attack_target = nil
			caster.last_attacker = nil
			return nil
		else

			-- Teleport if leashing back for too long
			caster.ai_leashing_delay = caster.ai_leashing_delay + 0.1
			if caster.ai_leashing_delay > super_leash_time then
				FindClearSpaceForUnit(caster, spawn_loc, true)
				caster.ai_is_leashing_back = nil
				caster.ai_leashing_delay = nil
				caster.ai_is_active = nil
				caster.closest_attack_target = nil
				caster.last_attacker = nil
				return nil
			else
				caster:MoveToPosition(spawn_loc)
				return nil
			end
		end
	end

	-- Check if an ability cast is underway
	if ability_slam:IsInAbilityPhase() or ability_roshling:IsInAbilityPhase() or ability_fury:IsInAbilityPhase() then
		return nil
	end
		
	-- Check for leash range
	if (roshan_loc - spawn_loc):Length2D() > leash_radius then

		-- Count to [leash_time] if already out of the leash radius
		if caster.ai_leashing_delay then
			caster.ai_leashing_delay = caster.ai_leashing_delay + 0.1
		else
			caster.ai_leashing_delay = 0
		end

		-- If at or above [leash_time], start leashing back
		if caster.ai_leashing_delay >= leash_time then
			caster.ai_is_leashing_back = true
			caster:MoveToPosition(spawn_loc)
			return nil
		end

	-- If inside leash range, stop counting
	else
		caster.ai_leashing_delay = nil
	end

	-- If the AI is not active, do not launch skills (use basic AI functionality)
	if not caster.ai_is_active then
		return nil
	end

	-- Check for Fury of the Immortal cast conditions
	if roshan_hp <= fury_pct and ability_fury and ability_fury:IsCooldownReady() and caster.closest_attack_target then
		
		-- Cast Fury of the Immortal on the current target
		caster:CastAbilityOnTarget(caster.closest_attack_target, ability_fury, 0)
		return nil

	-- Check for Summon Roshlings cast conditions
	elseif roshan_hp <= roshling_pct and ability_roshling and ability_roshling:IsCooldownReady() then
		
		-- Summon Roshlings
		caster:CastAbilityNoTarget(ability_roshling, 0)
		return nil

	-- Check for Slam cast conditions
	elseif ability_slam and ability_slam:IsCooldownReady() then
		
		-- Perform Slam
		caster:CastAbilityNoTarget(ability_slam, 0)
		return nil
	end
end