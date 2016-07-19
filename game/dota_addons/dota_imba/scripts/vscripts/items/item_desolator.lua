--[[	Author: d2imba
		Date:	07.01.2015	]]

function Shiv( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local attack_damage = keys.attack_damage

	-- Parameters
	local armor_ignore = ability:GetLevelSpecialValueFor("armor_ignore", ability_level)

	-- Calculate bonus damage
	local armor_before = target:GetPhysicalArmorValue()
	local armor_after = armor_before - armor_ignore
	local dmg_mult_before = 1 - 0.06 * armor_before / (1 + 0.06 * math.abs(armor_before))
	local dmg_mult_after = 1 - 0.06 * armor_after / (1 + 0.06 * math.abs(armor_after))
	local bonus_damage = attack_damage * (dmg_mult_after / dmg_mult_before - 1)

	-- Deal bonus damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function DesolatorProjectile( keys )
	local caster = keys.caster

	ChangeAttackProjectileImba(caster)
end

function DesolatorCast( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_projectile = keys.particle_projectile

	-- Parameters
	local active_range = ability:GetLevelSpecialValueFor("active_range", ability_level)
	local projectile_count = ability:GetLevelSpecialValueFor("projectile_count", ability_level)
	local projectile_radius = ability:GetLevelSpecialValueFor("projectile_radius", ability_level)
	local projectile_distance = ability:GetLevelSpecialValueFor("projectile_distance", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Calculate projectile initial positions
	local caster_pos = caster:GetAbsOrigin()
	local direction = (target - caster_pos):Normalized()
	local projectile_line_start = RotatePosition(caster_pos, QAngle(0, 90, 0), caster_pos + direction * math.floor(projectile_count / 2) * projectile_distance)
	local projectile_line_direction = (caster_pos - projectile_line_start):Normalized()

	-- Launch projectiles
	for i = 1, projectile_count do
		local projectile_position = projectile_line_start + projectile_line_direction * projectile_distance * (i - 1)

		local desolator_projectile = {
			Ability				= ability,
			EffectName			= particle_projectile,
			vSpawnOrigin		= projectile_position,
			fDistance			= active_range,
			fStartRadius		= projectile_radius,
			fEndRadius			= projectile_radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= direction * projectile_speed,
			bProvidesVision		= false,
			iVisionRadius		= 0,
			iVisionTeamNumber	= caster:GetTeamNumber(),
		}

		ProjectileManager:CreateLinearProjectile(desolator_projectile)
	end
end

function DesolatorActiveHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_armor = keys.modifier_armor
	local modifier_vision = keys.modifier_vision
	local modifier_hit_dummy = keys.modifier_hit_dummy

	-- If the target was already hit this cast, 
	if target:HasModifier(modifier_hit_dummy) then
		return nil
	end

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local active_damage = ability:GetLevelSpecialValueFor("active_damage", ability_level)

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Apply hit prevention modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_hit_dummy, {})

	-- Apply maximum stacks of the armor modifier
	local armor_stacks = target:GetModifierStackCount(modifier_armor, nil)
	ability:ApplyDataDrivenModifier(caster, target, modifier_armor, {})
	if armor_stacks <= max_stacks then
		target:SetModifierStackCount(modifier_armor, caster, max_stacks)
	end

	-- Apply maximum stacks of the vision loss modifier if the target is not magic immune
	local vision_stacks = target:GetModifierStackCount(modifier_vision, nil)
	if not target:IsMagicImmune() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_vision, {})
		if vision_stacks <= max_stacks then
			target:SetModifierStackCount(modifier_vision, caster, max_stacks)
		end
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = active_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function DesolatorHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_armor = keys.modifier_armor
	local modifier_vision = keys.modifier_vision

	-- If a higher-level desolator is present, do nothing
	if caster:HasModifier("modifier_item_imba_desolator_2_unique") or caster:GetTeam() == target:GetTeam() then
		return nil
	end

	-- Parameters
	local base_stacks = ability:GetLevelSpecialValueFor("base_stacks", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- If the target has no armor debuff stacks, apply the base value
	if not target:HasModifier(modifier_armor) then
		AddStacks(ability, caster, target, modifier_armor, base_stacks, true)

		-- Play hit sound
		target:EmitSound(sound_hit)

	-- Else, add one stack, or refresh them if already at the maximum value
	else
		local current_stacks = target:GetModifierStackCount(modifier_armor, nil)
		if current_stacks < max_stacks then
			AddStacks(ability, caster, target, modifier_armor, 1, true)

			-- Play hit sound
			target:EmitSound(sound_hit)
		else
			AddStacks(ability, caster, target, modifier_armor, 0, true)
		end
	end

	-- If the target is not magic immune, apply the vision debuff
	if not target:IsMagicImmune() and not target:IsBuilding() then
		
		-- If at zero stacks, apply the base value
		if not target:HasModifier(modifier_vision) then
			AddStacks(ability, caster, target, modifier_vision, base_stacks, true)

		-- Else, add one stack, or refresh them if already at the maximum value
		else
			local current_stacks = target:GetModifierStackCount(modifier_vision, nil)
			if current_stacks < max_stacks then
				AddStacks(ability, caster, target, modifier_vision, 1, true)
			else
				AddStacks(ability, caster, target, modifier_vision, 0, true)
			end
		end
	end
end

function Desolator2ActiveHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_armor = keys.modifier_armor
	local modifier_vision = keys.modifier_vision
	local modifier_hit_dummy = keys.modifier_hit_dummy

	-- If the target was already hit this cast, 
	if target:HasModifier(modifier_hit_dummy) then
		return nil
	end

	-- Parameters
	local active_stacks = ability:GetLevelSpecialValueFor("active_stacks", ability_level)
	local active_damage = ability:GetLevelSpecialValueFor("active_damage", ability_level)

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Apply hit prevention modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_hit_dummy, {})

	-- Apply maximum stacks of the armor modifier
	local armor_stacks = target:GetModifierStackCount(modifier_armor, nil)
	ability:ApplyDataDrivenModifier(caster, target, modifier_armor, {})
	if armor_stacks <= active_stacks then
		target:SetModifierStackCount(modifier_armor, caster, active_stacks)
	end

	-- Apply maximum stacks of the vision loss modifier if the target is not magic immune
	local vision_stacks = target:GetModifierStackCount(modifier_vision, nil)
	if not target:IsMagicImmune() and not target:IsBuilding() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_vision, {})
		if vision_stacks <= active_stacks then
			target:SetModifierStackCount(modifier_vision, caster, active_stacks)
		end
	end

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = active_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function Desolator2Hit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local modifier_armor = keys.modifier_armor
	local modifier_vision = keys.modifier_vision

	-- If the target is an ally, do nothing
	if caster:GetTeam() == target:GetTeam() then
		return nil
	end

	-- Parameters
	local base_stacks = ability:GetLevelSpecialValueFor("base_stacks", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("active_stacks", ability_level)

	-- Play hit sound
	target:EmitSound(sound_hit)

	-- If the target has no armor debuff stacks, apply the base value
	if not target:HasModifier(modifier_armor) then
		AddStacks(ability, caster, target, modifier_armor, base_stacks, true)

	-- Else, if the target is a building, apply one stack up to the maximum amount
	elseif target:IsBuilding() then
		local current_stacks = target:GetModifierStackCount(modifier_armor, nil)
		if current_stacks < max_stacks then
			AddStacks(ability, caster, target, modifier_armor, 1, true)
		else
			AddStacks(ability, caster, target, modifier_armor, 0, true)
		end

	-- Else, add one stack
	else
		AddStacks(ability, caster, target, modifier_armor, 1, true)
	end

	-- If the target is not magic immune, apply the vision debuff
	if not target:IsMagicImmune() and not target:IsBuilding() then
		
		-- If at zero stacks, apply the base value
		if not target:HasModifier(modifier_vision) then
			AddStacks(ability, caster, target, modifier_vision, base_stacks, true)

		-- Else, add one stack
		else
			AddStacks(ability, caster, target, modifier_vision, 0, true)
		end
	end
end