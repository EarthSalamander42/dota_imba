--[[	Author: Firetoad
		Date: 25.02.2015	]]

function WhirlingAxesMelee( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_axe = keys.particle_axe
	local modifier_miss = keys.modifier_miss

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_tick = ability:GetLevelSpecialValueFor("damage_tick", ability_level)
	local damage_duration = ability:GetLevelSpecialValueFor("damage_duration", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local elapsed_duration = 0
	local enemies_hit = {}
	
	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play cast animation
	StartAnimation(caster, {activity = ACT_DOTA_CAST_ABILITY_2, rate = 1.0, translate="melee"})

	-- Main loop
	Timers:CreateTimer(0, function()

		-- Update caster location and facing
		local caster_pos = caster:GetAbsOrigin()
		local caster_direction = caster:GetForwardVector()

		-- Create axe particles
		for i = 1,5 do
			local axe_target_point = RotatePosition(caster_pos, QAngle(0, i * 72 - 72 * elapsed_duration, 0), caster_pos + caster_direction * (radius-175))
			local axe_pfx = ParticleManager:CreateParticle(particle_axe, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(axe_pfx, 0, caster_pos + Vector(0, 0, 100))
			ParticleManager:SetParticleControl(axe_pfx, 1, axe_target_point + Vector(0, 0, 100))
			ParticleManager:SetParticleControl(axe_pfx, 4, Vector(0.65, 0, 0))	
			Timers:CreateTimer(0.4, function()
				ParticleManager:SetParticleControl(axe_pfx, 1, caster:GetAbsOrigin() + Vector(0, 0, 100))
			end)		
		end
		
		-- Iterate through affected enemies
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do

			-- If this enemy is being hit for the first time, damage it
			if not enemies_hit[enemy] then
				enemies_hit[enemy] = true
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end

			-- Play hit sound
			enemy:EmitSound(sound_hit)

			-- Apply a stack of the dummy blind modifier
			AddStacks(ability, caster, enemy, modifier_miss, 1, true)
		end

		-- If the duration is over, end
		if elapsed_duration < damage_duration then

			-- Add a tick to the elapsed duration
			elapsed_duration = elapsed_duration + damage_tick
			return damage_tick
		end
	end)
end

function WhirlingAxesMeleeAttackMiss( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local modifier_dummy = keys.modifier_dummy

	-- Retrieve current dummy modifier count
	local current_stacks = attacker:GetModifierStackCount(modifier_dummy, caster)

	-- If this is the last stack, remove the dummy modifier
	if current_stacks <= 1 then
		attacker:RemoveModifierByName(modifier_dummy)

	-- Else, reduce the amount of stacks by one
	else
		attacker:SetModifierStackCount(modifier_dummy, caster, current_stacks - 1)
	end
end

function WhirlingAxesMeleeDebuffCreate( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_miss = keys.modifier_miss

	-- Apply the actual miss modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_miss, {})
end

function WhirlingAxesMeleeDebuffEnd( keys )
	local target = keys.target
	local modifier_miss = keys.modifier_miss

	-- Remove the actual miss modifier
	target:RemoveModifierByName(modifier_miss)
end

function WhirlingAxesRanged( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_axe = keys.particle_axe

	-- Parameters
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local base_axes = ability:GetLevelSpecialValueFor("base_axes", ability_level)
	local spread_angle = ability:GetLevelSpecialValueFor("spread_angle", ability_level)
	local agility_per_axe = ability:GetLevelSpecialValueFor("agility_per_axe", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Projectile geometry
	local caster_pos = caster:GetAbsOrigin()
	local direction = (target - caster_pos):Normalized()

	-- Calculate amount of axes to generate
	local total_axes = base_axes
	if caster:IsHero() then
		total_axes = base_axes + math.floor(caster:GetAgility() / agility_per_axe)
	end

	-- Reduce spread angle if too many axes are present
	if (total_axes - 1) * spread_angle > 72 then
		spread_angle = 72 / (total_axes - 1)
	end

	-- Projectile creation loop
	for i = 1, total_axes do
		
		local start_angle = (total_axes - 1) * spread_angle / 2
		local target_pos = RotatePosition(caster_pos, QAngle(0, start_angle - (i-1) * spread_angle, 0), caster_pos + direction * range)
		local this_axe_direction = (target_pos - caster_pos):Normalized()

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= particle_axe,
			vSpawnOrigin		= caster_pos,
			fDistance			= range,
			fStartRadius		= radius,
			fEndRadius			= radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= this_axe_direction * speed,
			bProvidesVision		= false,
		--	iVisionRadius		= ,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		} )
	end
end

function WhirlingAxesRangedHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_slow = keys.modifier_slow
	local modifier_stack = keys.modifier_stack

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Play hit sound if the target is not affected by the slow
	if not target:HasModifier(modifier_slow) then
		target:EmitSound(sound_hit)
	end

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- If the slow is already present, increase it by one stack
	if target:HasModifier(modifier_slow) then
		AddStacks(ability, caster, target, modifier_stack, 1, false)

	-- Else, apply the initial slow
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end
end

function BerserkersRageAttackStart( keys )
	local caster = keys.caster
	
	-- Make the caster a ranged unit
	caster:SetAttackCapability(2)
end

function BerserkersRageAttack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_bash = keys.sound_bash

	-- If caster's passives are disabled by break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end
	
	-- Parameters
	local bash_chance = ability:GetLevelSpecialValueFor("bash_chance", ability_level)
	local bash_damage = ability:GetLevelSpecialValueFor("bash_damage", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)

	-- Calculate bash damage
	bash_damage = caster:GetAttackDamage() * bash_damage / 100

	-- Roll for a bash proc
	if RandomInt(1, 100) <= bash_chance and not target:IsBuilding() then
		
		-- Apply bash damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bash_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Apply bash stun
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})

		-- Play bash sound
		target:EmitSound(sound_bash)
	end
	
	-- Make the caster a melee unit
	caster:SetAttackCapability(1)
end

function FervorLimitBreak( keys )
	local caster = keys.caster
	
	-- Increase attack speed cap
	IncreaseAttackSpeedCap(caster, 10000)
end

function FervorLimitBreakEnd( keys )
	local caster = keys.caster
	local modifier_stacks = keys.modifier_stacks
	local modifier_dummy = keys.modifier_dummy

	-- Remove current stacks
	caster:RemoveModifierByName(modifier_stacks)
	caster:RemoveModifierByName(modifier_dummy)
	
	-- Revert to the normal attack speed cap
	RevertAttackSpeedCap(caster)
end

function FervorAttack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- If caster's passives are disabled by break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end
	
	-- Apply a stack of Fervor
	ability:ApplyDataDrivenModifier(caster, caster, modifier_stacks, {})
end

function FervorStackUp( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_dummy = keys.modifier_dummy

	-- Add a stack to the dummy modifier
	AddStacks(ability, caster, target, modifier_dummy, 1, true)
end

function FervorStackDown( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_dummy = keys.modifier_dummy

	-- If this is the last stack, remove the dummy modifier
	if caster:GetModifierStackCount(modifier_dummy, caster) <= 1 then
		caster:RemoveModifierByName(modifier_dummy)

	-- Else, decrease the stack count by one
	else
		AddStacks(ability, caster, target, modifier_dummy, -1, false)
	end
end

function BattleTrance( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local modifier_trance = keys.modifier_trance
	local modifier_scepter = keys.modifier_scepter
	local particle_cast = keys.particle_cast
	local sound_cast = keys.sound_cast
	local sound_global = keys.sound_global
	local scepter = HasScepter(caster)

	-- Parameters
	local caster_pos = caster:GetAbsOrigin()

	-- Play local cast sound
	caster:EmitSound(sound_cast)

	-- Play cast animation
	StartAnimation(caster, {activity = ACT_DOTA_CAST_ABILITY_4, rate = 1.0})

	-- Play allied buff sound
	EmitSoundOnLocationForAllies(caster_pos, sound_global, caster)

	-- Play cast particle
	local trance_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(trance_pfx, 0, caster_pos)

	-- Iterate through all affected allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_pos, nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		
		-- Grant the attack speed buff
		ability:ApplyDataDrivenModifier(caster, ally, modifier_buff, {})

		-- If this unit is a real hero, apply the trance buff
		if ally:IsRealHero() then
			ability:ApplyDataDrivenModifier(caster, ally, modifier_trance, {})

			-- If the caster has a scepter, also apply the BAT reduction modifier
			if scepter then
				ability:ApplyDataDrivenModifier(caster, ally, modifier_scepter, {})
			end
		end
	end
end

function BattleTranceAttack( keys )
	local caster = keys.caster
	local unit = keys.attacker
	local ability = keys.ability
	local modifier_buff = keys.modifier_buff
	local modifier_stacks = keys.modifier_stacks

	-- If the unit still has the Battle Trance modifier, refresh the stacks' duration
	if unit:HasModifier(modifier_buff) then
		AddStacks(ability, caster, unit, modifier_stacks, 1, true)

	-- Else, add a stack without refreshing the buff
	else
		AddStacks(ability, caster, unit, modifier_stacks, 1, false)
	end
end

function BattleTranceBatStart( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local bat_reduction = ability:GetLevelSpecialValueFor("bat_scepter", ability_level)

	-- Apply BAT reduction
	ModifyBAT(unit, -bat_reduction, 0)
end

function BattleTranceBatEnd( keys )
	local caster = keys.caster
	local unit = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local bat_reduction = ability:GetLevelSpecialValueFor("bat_scepter", ability_level)
	local bat_increase = 100 * ( 100 / ( 100 - bat_reduction ) - 1 )

	-- Remove BAT reduction
	ModifyBAT(unit, bat_increase, 0)
end