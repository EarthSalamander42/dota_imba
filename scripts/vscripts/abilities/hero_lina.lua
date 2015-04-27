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
	local direction_center = ( target_pos - caster:GetAbsOrigin() ):Normalized()
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

function LightStrikeArrayPre( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
	local amount = ability:GetLevelSpecialValueFor("secondary_amount", ability_level)

	local target_pos = keys.target_points[1]
	local caster_pos = caster:GetAbsOrigin()
	local step = (target_pos - caster_pos):Normalized() * radius
	local particle_name = keys.particle_name

	-- Fixes the cast position for the next function call
	ability.blast_pos = target_pos
	ability.caster_pos = caster_pos
	ability.blast_count = 0


	-- Creates the pre-cast particles
	for i=0, amount do
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, target_pos + step * i )
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(pfx, 3, Vector(0, 0, 0))
	end	
end

function LightStrikeArray( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("light_strike_array_aoe", ability_level)
	local amount = ability:GetLevelSpecialValueFor("secondary_amount", ability_level)

	local target_pos = ability.blast_pos
	local caster_pos = ability.caster_pos
	local particle_name = keys.particle_name
	local modifier_stun = keys.modifier_stun
	local modifier_delay = keys.modifier_delay

	ability.step = (target_pos - caster_pos):Normalized() * radius
	ability.blast_count = ability.blast_count + 1

	-- Checks if blast count has reached the amount of secondary blasts, if not, blasts
	if ability.blast_count <= amount then
		-- Updates the blast position
		local blast_pos = target_pos + ability.step * ability.blast_count

		caster:EmitSound("Ability.LightStrikeArray")

		-- Draws the particle
		local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx, 0, blast_pos)
		ParticleManager:SetParticleControl(pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(pfx, 3, Vector(0, 0, 0))

		-- Applies the damage and stun modifier
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), blast_pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )
		for _,v in pairs(targets) do
			ability:ApplyDataDrivenModifier(caster, v, modifier_stun, {})
		end
	else
		-- Resets the global variables for the next cast
		caster:RemoveModifierByName(modifier_delay)
		ability.blast_count = nil
		ability.step = nil
		ability.blast_pos = nil
		ability.caster_pos = nil
	end
end

function FierySoul( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("imba_lina_fiery_soul")
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
		return
	end

	-- Fetch the skill names
	local dragon_slave = keys.dragon_slave
	local dragon_slave_fiery = keys.dragon_slave_fiery
	local light_strike_array = keys.light_strike_array
	local light_strike_array_fiery = keys.light_strike_array_fiery
	local fiery_soul = keys.fiery_soul
	local blazing_soul = keys.blazing_soul
	local laguna_blade = keys.laguna_blade
	local laguna_blade_fiery = keys.laguna_blade_fiery
	if scepter then
		laguna_blade = keys.laguna_scepter
		laguna_blade_fiery = keys.laguna_scepter_fiery
	end

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
	if scepter then
		laguna_blade = keys.laguna_scepter
		laguna_blade_fiery = keys.laguna_scepter_fiery
	end

	-- Remove the blazing soul buff
	caster:RemoveModifierByName("modifier_imba_fiery_soul_active")

	-- Switch skillset
	SwitchAbilities(caster, dragon_slave, dragon_slave_fiery, true, false)
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
		EffectName			= "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
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

function LagunaBladeGetScepterCheck( keys )
	local caster = keys.caster
	local normal_name = keys.normal_name
	local scepter_name = keys.scepter_name
	local scepter = HasScepter(caster)

	if scepter then
		caster:RemoveModifierByName("modifier_imba_laguna_blade_scepter_check")
		SwitchAbilities(caster, scepter_name, normal_name, true, true)
	end
end

function LagunaBladeDropScepterCheck( keys )
	local caster = keys.caster
	local normal_name = keys.normal_name
	local scepter_name = keys.scepter_name
	local scepter = HasScepter(caster)

	if not scepter then
		caster:RemoveModifierByName("modifier_imba_laguna_blade_scepter_check")
		SwitchAbilities(caster, normal_name, scepter_name, true, true)
	end
end

function LagunaBladeScepterDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local int = caster:GetIntellect()
	local int_multiplier = ability:GetLevelSpecialValueFor("int_multiplier_scepter", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )

	damage = damage + int * int_multiplier

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
end
