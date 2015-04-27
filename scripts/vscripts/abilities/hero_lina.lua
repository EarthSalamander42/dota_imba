function DragonSlave( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName(keys.ability_name)
	local ability_level = ability:GetLevel() - 1

	local speed = ability:GetLevelSpecialValueFor("dragon_slave_speed", ability_level)
	local start_width = ability:GetLevelSpecialValueFor("dragon_slave_width_initial", ability_level)
	local end_width = ability:GetLevelSpecialValueFor("dragon_slave_width_end", ability_level)
	local distance = ability:GetLevelSpecialValueFor("dragon_slave_distance", ability_level)
	local particle_name = keys.particle_name

	-- Defines the projectiles' directions
	local target_pos = keys.target_points[1]
	local direction_center = ( target_pos - caster:GetAbsOrigin() ):Normalized()
	local direction_left = (RotatePosition(target_pos, QAngle(0, 45, 0), target_pos + direction_center * distance) - target_pos):Normalized()
	local direction_right = (RotatePosition(target_pos, QAngle(0, -45, 0), target_pos + direction_center) - target_pos):Normalized()

	-- Creates the three projectiles
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
end

function FierySoul( keys )
	local caster = keys.caster
	local ability = keys.ability
	local maxStack = ability:GetLevelSpecialValueFor("fiery_soul_max_stacks", (ability:GetLevel() - 1))
	local modifierCount = caster:GetModifierCount()
	local currentStack = 0
	local modifierBuffName = "modifier_fiery_soul_buff_datadriven"
	local modifierStackName = "modifier_fiery_soul_buff_stack_datadriven"
	local modifierName

	-- Always remove the stack modifier
	caster:RemoveModifierByName(modifierStackName) 

	-- Counts the current stacks
	for i = 0, modifierCount do
		modifierName = caster:GetModifierNameByIndex(i)

		if modifierName == modifierBuffName then
			currentStack = currentStack + 1
		end
	end

	-- Remove all the old buff modifiers
	for i = 0, currentStack do
		print("Removing modifiers")
		caster:RemoveModifierByName(modifierBuffName)
	end

	-- Always apply the stack modifier 
	ability:ApplyDataDrivenModifier(caster, caster, modifierStackName, {})

	-- Reapply the maximum number of stacks
	if currentStack >= maxStack then
		caster:SetModifierStackCount(modifierStackName, ability, maxStack)

		-- Apply the new refreshed stack
		for i = 1, maxStack do
			ability:ApplyDataDrivenModifier(caster, caster, modifierBuffName, {})
		end
	else
		-- Increase the number of stacks
		currentStack = currentStack + 1

		caster:SetModifierStackCount(modifierStackName, ability, currentStack)

		-- Apply the new increased stack
		for i = 1, currentStack do
			ability:ApplyDataDrivenModifier(caster, caster, modifierBuffName, {})
		end
	end
end