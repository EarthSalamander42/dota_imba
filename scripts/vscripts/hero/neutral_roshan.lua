--[[	Author: Firetoad
		Date: 12.08.2015	]]

function RoshanBash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff
	local sound_bash = keys.sound_bash

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local stacking_damage = ability:GetLevelSpecialValueFor("stacking_damage", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)

	-- Calculate total damage
	local game_time = GAME_TIME_ELAPSED / 60
	local total_damage = base_damage + stacking_damage * game_time

	-- Start ability cooldown
	ability:StartCooldown(ability:GetCooldown(ability_level))

	-- Play sound
	target:EmitSound(sound_bash)

	-- Stun target
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})

	-- Apply debuff modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = ability:GetAbilityDamageType()})
end

function RoshanSlam( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff
	local sound_cast = keys.sound_cast
	local particle_slam = keys.particle_slam

	-- Parameters
	local slam_radius = ability:GetLevelSpecialValueFor("slam_radius", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local dmg_per_minute = ability:GetLevelSpecialValueFor("dmg_per_minute", ability_level)
	local caster_pos = caster:GetAbsOrigin()

	-- Calculate total damage
	local game_time = GAME_TIME_ELAPSED / 60
	local total_damage = base_damage + dmg_per_minute * game_time

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local slam_pfx = ParticleManager:CreateParticle(particle_slam, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(slam_pfx, 0, caster_pos)
	ParticleManager:SetParticleControl(slam_pfx, 1, Vector(slam_radius, 0, 0))

	-- Find targets
	local slam_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, slam_radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)

	for _,target in pairs(slam_targets) do
		
		-- Apply debuff modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})

		-- Deal damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = ability:GetAbilityDamageType()})
	end
end

function RoshanSummon( keys )
	local target = keys.target
	local ability_bash = target:FindAbilityByName(keys.ability_bash)
	local ability_aura = target:FindAbilityByName(keys.ability_aura)
	local ability_passives = target:FindAbilityByName(keys.ability_passives)
	local sound_summon = keys.sound_summon

	-- Play sound
	target:EmitSound(sound_summon)

	-- Setup roshling abilities
	ability_bash:SetLevel(1)
	ability_aura:SetLevel(1)
	ability_passives:SetLevel(1)
	FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
end

function RoshanFury( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_fury = keys.particle_fury

	-- Parameters
	local width = ability:GetLevelSpecialValueFor("width", ability_level)
	local length = ability:GetLevelSpecialValueFor("length", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Projectile geometry
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local projectile_direction = (target_pos - caster_pos):Normalized()

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

	-- Flag spell as having finished cast (for the AI controller)
	caster.ai_is_casting = nil
end

function RoshanFuryHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local length = ability:GetLevelSpecialValueFor("length", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local dmg_per_minute = ability:GetLevelSpecialValueFor("dmg_per_minute", ability_level)
	local debuff_duration = ability:GetLevelSpecialValueFor("debuff_duration", ability_level)

	-- Calculate total damage
	local game_time = GAME_TIME_ELAPSED / 60
	local total_damage = base_damage + dmg_per_minute * game_time

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = ability:GetAbilityDamageType()})

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

function RoshanRage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stack = keys.modifier_stack

	-- Parameters
	local hp_threshold = ability:GetLevelSpecialValueFor("hp_threshold", ability_level)

	-- Calculate total buff stacks
	local total_stacks = math.floor( ( 1 - caster:GetHealth() / caster:GetMaxHealth() ) * 100 / hp_threshold )

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function RoshanUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Calculate total buff stacks
	local total_stacks = GAME_TIME_ELAPSED / 60

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function RoshanPurge( keys )
	local caster = keys.caster

	-- Purge all debuffs
	caster:Purge(false, true, false, true, false)
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
	print(_G.GAME_ROSHAN_KILLS)

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

function RoshanAI( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage_taken = keys.damage_taken
	local ability_slam = caster:FindAbilityByName(keys.ability_slam)
	local ability_roshling = caster:FindAbilityByName(keys.ability_roshling)
	local ability_fury = caster:FindAbilityByName(keys.ability_fury)

	-- If the damage source's height is different from Roshan's (cliff attacks), prevent damage and do nothing
	if (attacker:GetAbsOrigin().z - caster:GetAbsOrigin().z) > 25 then
		caster:Heal(damage_taken, caster)
		return nil
	end

	-- If already acting, do nothing
	if caster.ai_is_active then
		return nil
	end

	-- Parameters
	local leash_radius = ability:GetLevelSpecialValueFor("leash_radius", ability_level)
	local leash_margin = ability:GetLevelSpecialValueFor("leash_margin", ability_level)
	local leash_time = ability:GetLevelSpecialValueFor("leash_time", ability_level)
	local slam_radius = ability:GetLevelSpecialValueFor("slam_radius", ability_level)
	local slam_targets = ability:GetLevelSpecialValueFor("slam_targets", ability_level)
	local roshling_pct = ability:GetLevelSpecialValueFor("roshling_pct", ability_level)
	local fury_pct = ability:GetLevelSpecialValueFor("fury_pct", ability_level)
	local think_interval = ability:GetLevelSpecialValueFor("think_interval", ability_level)
	local roshan_spawn_loc = Entities:FindByName(nil, "roshan_spawn_point"):GetAbsOrigin()

	-- Condition variables
	local roshan_loc
	local roshan_hp
	local nearby_targets

	-- Initialize logical parameters
	caster.ai_is_active = true

	Timers:CreateTimer(0, function()

		-- Update caster status
		roshan_loc = caster:GetAbsOrigin()
		roshan_hp = caster:GetHealth() / caster:GetMaxHealth()

		-- Check if currently leashing back to the spawn position
		if caster.ai_is_leashing_back then

			-- Check if leashing back was successful
			if (roshan_loc - roshan_spawn_loc):Length2D() < leash_margin then
				caster.ai_is_leashing_back = nil
				caster.ai_leashing_delay = nil
				return think_interval
			else

				-- Teleport if leashing back for too long
				caster.ai_leashing_delay = caster.ai_leashing_delay + think_interval
				if caster.ai_leashing_delay > leash_time then
					FindClearSpaceForUnit(caster, roshan_spawn_loc, true)
					caster.ai_is_leashing_back = nil
					caster.ai_leashing_delay = nil
					return think_interval
				else
					caster:MoveToPosition(roshan_spawn_loc)
					return think_interval
				end
			end
		end

		-- Check if an ability cast is underway
		if caster.ai_is_casting then
			return think_interval
		end
		
		-- Check for leash range
		if (roshan_loc - roshan_spawn_loc):Length2D() > leash_radius then
			caster.ai_is_leashing_back = true
			caster.ai_leashing_delay = 0
			caster.ai_current_target = nil
			caster:MoveToPosition(roshan_spawn_loc)
			return think_interval
		end

		-- Update current target
		nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), roshan_loc, nil, leash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		if nearby_targets[1] then
			caster.ai_current_target = nearby_targets[1]
		end

		-- Check for cast conditions
		nearby_targets = FindUnitsInRadius(caster:GetTeamNumber(), roshan_loc, nil, slam_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		if roshan_hp <= fury_pct and ability_fury and ability_fury:IsCooldownReady() then
			
			-- Cast Fury of the Immortal on the current target
			caster:CastAbilityOnTarget(caster.ai_current_target, ability_fury, 0)
			caster.ai_is_casting = true
			Timers:CreateTimer(2.0, function()
				caster.ai_is_casting = nil
			end)
			return think_interval
		elseif roshan_hp <= roshling_pct and ability_roshling and ability_roshling:IsCooldownReady() then
			
			-- Summon Roshlings
			caster:CastAbilityNoTarget(ability_roshling, 0)
			return think_interval
		elseif #nearby_targets >= slam_targets and ability_slam and ability_slam:IsCooldownReady() then
			
			-- Perform Slam
			caster:CastAbilityNoTarget(ability_slam, 0)
			return think_interval
		end

		-- If there is a target, attack it
		if caster.ai_current_target and caster.ai_current_target:IsAlive() then
			caster:SetAttacking(caster.ai_current_target)
			return think_interval
		else
			caster:MoveToPosition(roshan_spawn_loc)
			caster.ai_current_target = nil
			caster.ai_is_active = nil
		end
	end)
end