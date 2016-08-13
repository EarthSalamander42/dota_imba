--[[	Author: Firetoad
		Date: 09.07.2015	]]

function Headshot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_near = keys.modifier_near
	local modifier_far = keys.modifier_far
	local modifier_normal_debuff = keys.modifier_normal_debuff

	-- Parameters
	local near_duration = ability:GetLevelSpecialValueFor("near_duration", ability_level)
	local normal_damage = ability:GetLevelSpecialValueFor("normal_damage", ability_level)
	local far_aoe = ability:GetLevelSpecialValueFor("far_aoe", ability_level)
	local far_shot_speed = ability:GetLevelSpecialValueFor("far_shot_speed", ability_level)
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local far_proc_chance = ability:GetLevelSpecialValueFor("far_proc_chance", ability_level)

	-- Near mode headshot, stuns the target if it is not a building
	if caster:HasModifier(modifier_near) then
		if not target:IsBuilding() then
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = near_duration})
		end

	-- Far mode headshot, finds all enemies around the target and creates a projectile for each one
	elseif caster:HasModifier(modifier_far) and target:GetTeam() ~= caster:GetTeam() and RandomInt(1, proc_chance) <= far_proc_chance then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, far_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,unit in pairs(units) do
			local headshot_projectile = {
				Target = unit,
				Source = caster,
				Ability = ability,	
				EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
				vSpawnOrigin = caster:GetAbsOrigin(),
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bDeleteOnHit = true,
				iMoveSpeed = far_shot_speed,
				bProvidesVision = false,
				bDodgeable = true,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(headshot_projectile)
		end

		if #units > 0 then
			caster:EmitSound("Imba.SniperLongRangeHeadshot")
			caster:EmitSound("Imba.SniperLongRangeHeadshotProjectile")
		end

	-- Normal mode headshot, deals damage + slows target
	else
		if not target:IsBuilding() then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = normal_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
			ability:ApplyDataDrivenModifier(caster, target, modifier_normal_debuff, {})
		end
	end
end

function HeadshotKnockback( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If the target is magic immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- Parameters
	local knockback_distance = ability:GetLevelSpecialValueFor("far_knockback", ability_level)
	local speed = ability:GetLevelSpecialValueFor("knockback_speed", ability_level)
	local caster_pos = caster:GetAbsOrigin()

	-- Play sound
	target:EmitSound("Imba.SniperLongRangeHeadshot0"..RandomInt(1, 2))

	-- Knockback
	local headshot_knockback =	{
		should_stun = 1,
		knockback_duration = knockback_distance / speed,
		duration = knockback_distance / speed,
		knockback_distance = knockback_distance,
		knockback_height = knockback_distance * 0.3,
		center_x = caster_pos.x,
		center_y = caster_pos.y,
		center_z = caster_pos.z
	}

	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", headshot_knockback)

end

function TakeAimNear( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_near = keys.modifier_near
	local modifier_normal = keys.modifier_normal
	local modifier_far = keys.modifier_far
	local normal_skill_name = keys.normal_skill_name

	--Fetch Normal mode ability handle
	local ability_normal = caster:FindAbilityByName(normal_skill_name)

	-- If Near mode is already activated, return to Normal mode
	if caster:HasModifier(modifier_near) then
		caster:RemoveModifierByName(modifier_near)
		caster:RemoveModifierByName(modifier_far)
		ability_normal:ApplyDataDrivenModifier(caster, caster, modifier_normal, {})
	-- else, activate Near mode
	else
		caster:RemoveModifierByName(modifier_far)
		caster:RemoveModifierByName(modifier_normal)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_near, {})
	end
end

function TakeAimFar( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_near = keys.modifier_near
	local modifier_normal = keys.modifier_normal
	local modifier_far = keys.modifier_far
	local normal_skill_name = keys.normal_skill_name
	local sound_cast = keys.sound_cast

	--Fetch Normal mode ability handle
	local ability_normal = caster:FindAbilityByName(normal_skill_name)

	-- Play toggle sound
	caster:EmitSound(sound_cast)

	-- If Far mode is already activated, return to Normal mode
	if caster:HasModifier(modifier_far) then
		caster:RemoveModifierByName(modifier_near)
		caster:RemoveModifierByName(modifier_far)
		ability_normal:ApplyDataDrivenModifier(caster, caster, modifier_normal, {})
	-- else, activate Far mode
	else
		caster:RemoveModifierByName(modifier_near)
		caster:RemoveModifierByName(modifier_normal)
		ability:ApplyDataDrivenModifier(caster, caster, modifier_far, {})
	end
end

function TakeAimNearBatStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local new_bat = ability:GetLevelSpecialValueFor("BAT", ability_level) - 1.7

	-- Update BAT
	ModifyBAT(caster, 0, new_bat)
end

function TakeAimNearBatEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local new_bat = ability:GetLevelSpecialValueFor("BAT", ability_level) - 1.7

	-- Update BAT
	ModifyBAT(caster, 0, -new_bat)
end

function TakeAimFarFountainRemover( keys )
	local caster = keys.caster
	local ability_normal = caster:FindAbilityByName(keys.normal_skill)
	local modifier_normal = keys.modifier_normal
	local modifier_far = keys.modifier_far

	-- Deactivate far mode if inside the fountain
	if IsNearFriendlyClass(caster, 1360, "ent_dota_fountain") then
		caster:RemoveModifierByName(modifier_far)
		ability_normal:ApplyDataDrivenModifier(caster, caster, modifier_normal, {})
	end
end

function TakeAimFarBatStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_normal = caster:FindAbilityByName(keys.normal_skill)
	local modifier_normal = keys.modifier_normal
	local modifier_far = keys.modifier_far

	-- Parameters
	local new_bat = ability:GetLevelSpecialValueFor("BAT", ability_level) - 1.7

	-- Update BAT
	ModifyBAT(caster, 0, new_bat)

	-- Immediately deactivate far mode if inside the fountain
	if IsNearFriendlyClass(caster, 1360, "ent_dota_fountain") then
		caster:RemoveModifierByName(modifier_far)
		ability_normal:ApplyDataDrivenModifier(caster, caster, modifier_normal, {})
	end
end

function TakeAimFarBatEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local new_bat = ability:GetLevelSpecialValueFor("BAT", ability_level) - 1.7

	-- Update BAT
	ModifyBAT(caster, 0, -new_bat)
end

function TakeAimUpgrade( keys )
	local caster = keys.caster
	local ability_level = keys.ability:GetLevel()
	local ability_near = caster:FindAbilityByName(keys.near_skill)
	local ability_normal = caster:FindAbilityByName(keys.normal_skill)
	local ability_far = caster:FindAbilityByName(keys.far_skill)
	local modifier_near = keys.modifier_near
	local modifier_normal = keys.modifier_normal
	local modifier_far = keys.modifier_far

	-- Update variable which tracks this ability's level
	if not caster.take_aim_level then
		caster.take_aim_level = 1
	elseif caster.take_aim_level == ability_level then
		return nil
	else
		caster.take_aim_level = ability_level
	end

	-- Update the respective modifiers
	if caster:HasModifier(modifier_near) then
		caster:RemoveModifierByName(modifier_near)
		caster:RemoveModifierByName(modifier_normal)
		caster:RemoveModifierByName(modifier_far)

		-- Compensate for the BAT difference during the ability's upgrade
		local near_bat_difference = ability_near:GetLevelSpecialValueFor("BAT", ability_level - 1) - ability_near:GetLevelSpecialValueFor("BAT", ability_level - 2)
		ModifyBAT(caster, 0, near_bat_difference)

		ability_near:ApplyDataDrivenModifier(caster, caster, modifier_near, {})
	elseif caster:HasModifier(modifier_far) then
		caster:RemoveModifierByName(modifier_near)
		caster:RemoveModifierByName(modifier_normal)
		caster:RemoveModifierByName(modifier_far)

		-- Compensate for the BAT difference during the ability's upgrade
		local far_bat_difference = ability_far:GetLevelSpecialValueFor("BAT", ability_level - 1) - ability_far:GetLevelSpecialValueFor("BAT", ability_level - 2)
		ModifyBAT(caster, 0, far_bat_difference)
		
		ability_far:ApplyDataDrivenModifier(caster, caster, modifier_far, {})
	end

	-- Level up abilities
	ability_near:SetLevel(caster.take_aim_level)
	ability_normal:SetLevel(caster.take_aim_level)
	ability_far:SetLevel(caster.take_aim_level)

end

function AssassinateCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_shrapnel = keys.modifier_shrapnel
	local modifier_target = keys.modifier_target
	local modifier_caster = keys.modifier_caster
	local modifier_cast_check = keys.modifier_cast_check

	-- Parameters
	local regular_range = ability:GetLevelSpecialValueFor("regular_range", ability_level)
	local cast_distance = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Length2D()

	-- Check if the target can be assassinated, if not, stop casting and move closer
	if cast_distance > regular_range and not target:HasModifier(modifier_shrapnel) then

		-- Start moving
		caster:MoveToPosition(target:GetAbsOrigin())
		Timers:CreateTimer(0.1, function()

			-- Update distance between caster and target
			cast_distance = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Length2D()

			-- If it's not a legal cast situation and no other order was given, keep moving
			if cast_distance > regular_range and not target:HasModifier(modifier_shrapnel) and not caster.stop_assassinate_cast then
				return 0.1

			-- If another order was given, stop tracking the cast distance
			elseif caster.stop_assassinate_cast then
				caster:RemoveModifierByName(modifier_cast_check)
				caster.stop_assassinate_cast = nil

			-- If all conditions are met, cast Assassinate again
			else
				caster:CastAbilityOnTarget(target, ability, caster:GetPlayerID())
			end
		end)
		return nil
	end

	-- Play the pre-cast sound
	caster:EmitSound("Ability.AssassinateLoad")

	-- Mark the target with the crosshair
	ability:ApplyDataDrivenModifier(caster, target, modifier_target, {})
	target.assassinate_crosshair_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
	ParticleManager:SetParticleControl(target.assassinate_crosshair_pfx, 0, target:GetAbsOrigin())

	-- Apply the caster modifiers
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
	caster:RemoveModifierByName(modifier_cast_check)

	-- Memorize the target
	caster.assassinate_target = target

end

function AssassinateCastCheck( keys )
	local caster = keys.caster
	caster.stop_assassinate_cast = true
end

function AssassinateStop( keys )
	local caster = keys.caster
	local target_modifier = keys.target_modifier
	caster.assassinate_target:RemoveModifierByName(target_modifier)
	ParticleManager:DestroyParticle(caster.assassinate_target.assassinate_crosshair_pfx, true)
	ParticleManager:ReleaseParticleIndex(caster.assassinate_target.assassinate_crosshair_pfx)
	caster.assassinate_target = nil
end

function Assassinate( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local bullet_duration = ability:GetLevelSpecialValueFor("projectile_travel_time", ability_level)
	local spill_range = ability:GetLevelSpecialValueFor("spill_range", ability_level)
	local bullet_radius = ability:GetLevelSpecialValueFor("aoe_size", ability_level)
	local bullet_direction = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Normalized()
	bullet_direction = Vector(bullet_direction.x, bullet_direction.y, 0)
	local bullet_distance = ( target:GetAbsOrigin() - caster:GetAbsOrigin() ):Length2D() + spill_range
	local bullet_speed = bullet_distance / bullet_duration

	-- Destroy the crosshair particle
	ParticleManager:DestroyParticle(target.assassinate_crosshair_pfx, true)
	ParticleManager:ReleaseParticleIndex(target.assassinate_crosshair_pfx)

	-- Create the real, invisible projectile
	local assassinate_projectile = {
		Ability				= ability,
		EffectName			= "",
		vSpawnOrigin		= caster:GetAbsOrigin(),
		fDistance			= bullet_distance,
		fStartRadius		= bullet_radius,
		fEndRadius			= bullet_radius,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= bullet_direction * bullet_speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(assassinate_projectile)

	-- Create the fake, visible projectile
	assassinate_projectile = {
		Target = target,
		Source = caster,
		Ability = nil,	
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		vSpawnOrigin = caster:GetAbsOrigin(),
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = true,
		iMoveSpeed = bullet_speed,
		bProvidesVision = false,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}

	ProjectileManager:CreateTrackingProjectile(assassinate_projectile)
end

function AssassinateHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Play sound
	target:EmitSound("Hero_Sniper.AssassinateDamage")

	-- Scepter damage and debuff
	if scepter then

		-- Scepter parameters
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
		local knockback_speed = ability:GetLevelSpecialValueFor("knockback_speed_scepter", ability_level)
		local knockback_distance = ability:GetLevelSpecialValueFor("knockback_dist_scepter", ability_level)
		local caster_pos = caster:GetAbsOrigin()

		-- Knockback parameters
		local assassinate_knockback =	{
			should_stun = 1,
			knockback_duration = math.min( knockback_distance / knockback_speed, 0.6),
			duration = math.min( knockback_distance / knockback_speed, 0.6),
			knockback_distance = knockback_distance,
			knockback_height = 200,
			center_x = caster_pos.x,
			center_y = caster_pos.y,
			center_z = caster_pos.z
		}

		-- Apply knockback and slow modifiers
		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(caster, ability, "modifier_knockback", assassinate_knockback )
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Grant short-lived vision
	ability:CreateVisibilityNode(target:GetAbsOrigin(), 500, 1.0)

	-- Ministun
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.1})

	-- Fire particle
	local hit_fx = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(hit_fx, 0, target:GetAbsOrigin() )
end