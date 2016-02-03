--[[ 	Author: D2imba
		Date: 26.04.2015	]]

function DragonSlaveLevel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_name = keys.ability_name
	local ability_aux = caster:FindAbilityByName(ability_name)

	local level = ability:GetLevel()
	ability_aux:SetLevel(level)
end

function DragonSlave( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName(keys.ability_name)
	local ability_level = ability:GetLevel() - 1

	local speed = ability:GetLevelSpecialValueFor("dragon_slave_speed", ability_level)
	local start_width = ability:GetLevelSpecialValueFor("dragon_slave_width_initial", ability_level)
	local end_width = ability:GetLevelSpecialValueFor("dragon_slave_width_end", ability_level)
	local distance = ability:GetLevelSpecialValueFor("dragon_slave_distance", ability_level)
	local particle_name = keys.particle_name
	local sound = keys.sound

	-- Defines the projectiles' directions
	local target_pos = keys.target_points[1]
	local caster_pos = caster:GetAbsOrigin()
	local direction_center = (target_pos - caster_pos):Normalized()
	if target_pos == caster_pos then
		direction_center = caster:GetForwardVector()
	end
	local direction_left = (RotatePosition(target_pos, QAngle(0, 45, 0), target_pos + direction_center * distance) - target_pos):Normalized()
	local direction_right = (RotatePosition(target_pos, QAngle(0, -45, 0), target_pos + direction_center) - target_pos):Normalized()

	-- Calculates how long should we wait for the secondary dragon slaves to spawn
	local spawn_time = ( target_pos - caster:GetAbsOrigin() ):Length2D() / speed

	-- Creates the three projectiles after a spawn_time delay
	Timers:CreateTimer(spawn_time, function()
		if spawn_time > 0.2 then
			caster:EmitSound(sound)
		end

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= particle_name,
			vSpawnOrigin		= target_pos,
			fDistance			= distance,
			fStartRadius		= start_width,
			fEndRadius			= end_width,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= direction_left * speed,
			bProvidesVision		= false,
		--	iVisionRadius		= ,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		} )

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= particle_name,
			vSpawnOrigin		= target_pos,
			fDistance			= distance,
			fStartRadius		= start_width,
			fEndRadius			= end_width,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= direction_center * speed,
			bProvidesVision		= false,
		--	iVisionRadius		= ,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		} )

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= particle_name,
			vSpawnOrigin		= target_pos,
			fDistance			= distance,
			fStartRadius		= start_width,
			fEndRadius			= end_width,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= direction_right * speed,
			bProvidesVision		= false,
		--	iVisionRadius		= ,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		} )
	end)
end

function LightStrikeArray( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Ability parameters
	local ability_level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
	local blast_amount = ability:GetLevelSpecialValueFor("secondary_amount", ability_level) + 1
	local main_delay = ability:GetLevelSpecialValueFor("light_strike_array_delay_time", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)

	-- Modifiers and resources
	local pre_particle = keys.pre_particle
	local blast_particle = keys.blast_particle
	local pre_sound = keys.pre_sound
	local blast_sound = keys.blast_sound
	local hit_modifier = keys.hit_modifier

	-- Blast positioning variables
	local target_pos = keys.target_points[1]
	local caster_pos = caster:GetAbsOrigin()
	local direction = (target_pos - caster_pos):Normalized()
	if target_pos == caster_pos then
		direction = caster:GetForwardVector()
	end
	local blast_pos = target_pos
	local step = direction * radius
	local blast_count = 0

	-- Create a (visible) dummy at the initial cast point
	local visibility_dummy = CreateUnitByName("npc_dummy_unit", blast_pos, false, caster, caster, caster:GetTeamNumber())
	visibility_dummy:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, main_delay + blast_amount * secondary_delay)
	visibility_dummy:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, main_delay + blast_amount * secondary_delay)

	-- Creates the pre-cast particles
	for i = 1, blast_amount do
		local light_pos = GetGroundPosition(target_pos + step * (i-1), caster)
		local pre_fx = ParticleManager:CreateParticle(pre_particle, PATTACH_CUSTOMORIGIN, visibility_dummy)
		ParticleManager:SetParticleControl(pre_fx, 0, light_pos)
		ParticleManager:SetParticleControl(pre_fx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(pre_fx, 3, Vector(0, 0, 0))
	end

	-- Plays the pre-cast sound
	caster:EmitSound(pre_sound)

	-- Blasting loop
	Timers:CreateTimer(main_delay, function()

		-- Calculates this blast's position
		blast_pos = GetGroundPosition(target_pos + step * blast_count, caster)

		-- Creates the blast particle
		local blast_fx = ParticleManager:CreateParticle(blast_particle, PATTACH_ABSORIGIN, visibility_dummy)
		ParticleManager:SetParticleControl(blast_fx, 0, blast_pos)
		ParticleManager:SetParticleControl(blast_fx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(blast_fx, 3, Vector(0, 0, 0))

		-- Applies the damage and stun modifier
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), blast_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for _,v in pairs(targets) do
			ability:ApplyDataDrivenModifier(caster, v, hit_modifier, {})
		end

		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(blast_pos, radius, false)

		-- Creates a dummy to play the sound, then destroys it
		local dummy = CreateUnitByName("npc_dummy_unit", blast_pos, false, caster, caster, caster:GetTeamNumber())
		dummy:EmitSound(blast_sound)
		dummy:Destroy()

		-- Increases blast count and checks if blasting should continue
		blast_count = blast_count + 1
		if blast_count < blast_amount then
			return secondary_delay
		end

		-- Destroy visibility dummy
		visibility_dummy:Destroy()
	end)
end

function FierySoul( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("imba_lina_fiery_soul")

	-- If Fiery Soul is not leveled, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("fiery_soul_max_stacks", ability:GetLevel() - 1 )
	local modifier = "modifier_imba_fiery_soul"

	local current_stacks = caster:GetModifierStackCount(modifier, ability)

	if current_stacks < max_stacks then
		AddStacks(ability, caster, caster, modifier, 1, true)
	else
		AddStacks(ability, caster, caster, modifier, 0, true)
	end
end

function FierySoulActivate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor("fiery_soul_duration", ability:GetLevel() - 1 )
	local max_stacks = ability:GetLevelSpecialValueFor("fiery_soul_max_stacks", ability:GetLevel() - 1 )
	local scepter = HasScepter(caster)

	-- If not at maximum number of stacks, do nothing
	if caster:GetModifierStackCount("modifier_imba_fiery_soul", ability) < max_stacks then
		return nil
	end

	-- Play the sound
	local activate_sound = keys.activate_sound
	caster:EmitSound(activate_sound)

	-- Fetch the skill names
	local dragon_slave = keys.dragon_slave
	local dragon_slave_fiery = keys.dragon_slave_fiery
	local light_strike_array = keys.light_strike_array
	local light_strike_array_fiery = keys.light_strike_array_fiery
	local fiery_soul = keys.fiery_soul
	local blazing_soul = keys.blazing_soul
	local laguna_blade = keys.laguna_blade
	local laguna_blade_fiery = keys.laguna_blade_fiery

	-- Remove the fiery soul stacks and grant blazing soul
	caster:RemoveModifierByName("modifier_imba_fiery_soul")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_imba_fiery_soul_active", {})

	-- Store Laguna Blade's cooldown for the switch back (the other skills' cooldowns are shorter than the buff duration)
	local laguna_ability = caster:FindAbilityByName(laguna_blade)
	caster.laguna_cooldown = laguna_ability:GetCooldownTimeRemaining() - duration
	if caster.laguna_cooldown < 0 then
		caster.laguna_cooldown = 0
	end

	-- Switch skillset
	SwitchAbilities(caster, dragon_slave_fiery, dragon_slave, true, false)
	caster:RemoveModifierByName("modifier_imba_light_strike_array_delay")
	SwitchAbilities(caster, light_strike_array_fiery, light_strike_array, true, false)
	SwitchAbilities(caster, blazing_soul, fiery_soul, true, false)
	caster:RemoveModifierByName("modifier_imba_laguna_blade_scepter_check")
	SwitchAbilities(caster, laguna_blade_fiery, laguna_blade, true, false)
end

function FierySoulEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)

	-- Fetch the skill names
	local dragon_slave = keys.dragon_slave
	local dragon_slave_fiery = keys.dragon_slave_fiery
	local light_strike_array = keys.light_strike_array
	local light_strike_array_fiery = keys.light_strike_array_fiery
	local fiery_soul = keys.fiery_soul
	local blazing_soul = keys.blazing_soul
	local laguna_blade = keys.laguna_blade
	local laguna_blade_fiery = keys.laguna_blade_fiery

	-- Remove the blazing soul buff
	caster:RemoveModifierByName("modifier_imba_fiery_soul_active")

	-- Switch skillset
	SwitchAbilities(caster, dragon_slave, dragon_slave_fiery, true, false)
	caster:RemoveModifierByName("modifier_imba_light_strike_array_delay")
	SwitchAbilities(caster, light_strike_array, light_strike_array_fiery, true, false)
	SwitchAbilities(caster, fiery_soul, blazing_soul, true, false)
	caster:RemoveModifierByName("modifier_imba_laguna_blade_scepter_check")
	SwitchAbilities(caster, laguna_blade, laguna_blade_fiery, true, false)

	-- Restore Laguna Blade's cooldown
	local laguna_ability = caster:FindAbilityByName(laguna_blade)
	laguna_ability:StartCooldown(caster.laguna_cooldown)
	caster.laguna_cooldown = nil
end

function LagunaBladeProjectile( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_pos = keys.target:GetAbsOrigin()
	local ability_level = ability:GetLevel() - 1

	local speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local start_width = ability:GetLevelSpecialValueFor("start_width", ability_level)
	local end_width = ability:GetLevelSpecialValueFor("end_width", ability_level)

	local caster_pos = caster:GetAbsOrigin()
	local distance = (target_pos - caster_pos):Length2D()
	local direction = (target_pos - caster_pos):Normalized()

	ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		--EffectName		= "",
		vSpawnOrigin		= caster_pos,
		fDistance			= distance,
		fStartRadius		= start_width,
		fEndRadius			= end_width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= ability:GetAbilityTargetTeam(),
		iUnitTargetFlags	= ability:GetAbilityTargetFlags(),
		iUnitTargetType		= ability:GetAbilityTargetType(),
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )
end

function LagunaBladeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local scepter = HasScepter(caster)

	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )

	if scepter then
		local int = caster:GetIntellect()
		local int_multiplier = ability:GetLevelSpecialValueFor("int_multiplier_scepter", ability:GetLevel() - 1 )
		damage = damage + int * int_multiplier
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end
