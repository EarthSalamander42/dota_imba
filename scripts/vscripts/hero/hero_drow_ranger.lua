--[[Author: hewdraw
	Date: 14-3-2015.]]

function FrostArrows( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier
	local freeze_modifier = keys.freeze_modifier
	local ability_level = ability:GetLevel() - 1
	local stacks_to_freeze = ability:GetLevelSpecialValueFor("stacks_to_freeze", ability_level)

	-- Counts stacks up to stacks_to_freeze; when that number is reached, removes all stacks and roots the target with freeze_modifier
	if not target:HasModifier(stack_modifier) then
		ability:ApplyDataDrivenModifier(caster, target, stack_modifier, {})
		target:SetModifierStackCount(stack_modifier, ability, 1)
	elseif target:GetModifierStackCount(stack_modifier, ability) < stacks_to_freeze - 1 then
		local stack_count = target:GetModifierStackCount(stack_modifier, ability)
		ability:ApplyDataDrivenModifier(caster, target, stack_modifier, {})
		target:SetModifierStackCount(stack_modifier, ability, stack_count + 1)
	else
		target:RemoveModifierByName(stack_modifier)
		ability:ApplyDataDrivenModifier(caster, target, freeze_modifier, {})
	end	
end

-- Upgrades Frost Arrows' cast range when leveling up Marksmanship
function UpgradeFrostArrows( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_0 = caster:FindAbilityByName(keys.ability_0)
	local ability_1 = caster:FindAbilityByName(keys.ability_1)
	local ability_2 = caster:FindAbilityByName(keys.ability_2)
	local ability_3 = caster:FindAbilityByName(keys.ability_3)

	local old_ability_name
	local new_ability_name

	-- Checks which level of Marksmanship we are upgrading to
	if not ability_0 then
		if not ability_1 then
			old_ability_name = keys.ability_2
			new_ability_name = keys.ability_3
		else
			old_ability_name = keys.ability_1
			new_ability_name = keys.ability_2
		end
	else
		old_ability_name = keys.ability_0
		new_ability_name = keys.ability_1
	end

	-- Removes the passive modifier to prevent crashing
	caster:RemoveModifierByName("modifier_imba_frost_arrows_caster")

	-- Performs the switch
	SwitchAbilities(caster, new_ability_name, old_ability_name, true, false)
end

function Gust( keys )
	local ability = keys.ability
	local vCaster = keys.caster:GetAbsOrigin()
	local vTarget = keys.target:GetAbsOrigin()
	local caster = keys.caster
	local distance = caster:GetAttackRange()

	-- calculates knockback distance
	local len = ( vTarget - vCaster ):Length2D()
	if len > distance then
		len = 25
	else
		len = distance - len + 25
	end

	-- knockbacks using modifier_knockback
	local knockbackModifierTable =
	{
		should_stun = 0,
		knockback_duration = keys.duration,
		duration = keys.duration,
		knockback_distance = len,
		knockback_height = keys.height,
		center_x = keys.caster:GetAbsOrigin().x,
		center_y = keys.caster:GetAbsOrigin().y,
		center_z = keys.caster:GetAbsOrigin().z
	}
	keys.target:RemoveModifierByName("modifier_knockback")
	keys.target:AddNewModifier( keys.caster, ability, "modifier_knockback", knockbackModifierTable )
end

function Trueshot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Adjust damage based on agility of caster
	local agility = caster:GetAgility()
	local percent = ability:GetLevelSpecialValueFor("trueshot_ranged_damage", ability:GetLevel() - 1 )
	local damage = math.floor( agility * percent / 100 )

	-- Check if the unit is Drow Ranger
	if target == caster then
		damage = math.floor( agility * percent / 50 )
	end

	-- Apply stacks equal to the bonus damage only if the target is ranged
	if target:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK or target == caster then

		-- Check if the aura needs to be updated
		if target:GetModifierStackCount(modifier_stack, caster) ~= damage then

			-- Remove previous instance of the aura
			target:RemoveModifierByName(modifier_stack)

			-- Update aura values
			AddStacks(ability, caster, target, modifier_stack, damage, true)
		end
	end
end

function Marksmanship( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_effect = keys.modifier_effect

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- Parameters
	local enemy_radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local caster_position = caster:GetAbsOrigin()

	-- Check enemy presence in enemy_radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_position, caster, enemy_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false)
	
	-- If enemies are nearby, remove the effect
	if #units > 0 then
		caster:RemoveModifierByName(modifier_effect)

	-- Else, apply it if not previously existing
	elseif not caster:HasModifier(modifier_effect) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_effect, {})
	end
end

function MarksmanshipSplinter( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- If the ability was unlearned, or there's no scepter, do nothing
	if not ability or not scepter or caster:IsIllusion() then
		return nil
	end

	-- Parameters
	local splinter_chance = ability:GetLevelSpecialValueFor("splinter_chance_scepter", ability_level)
	local splinter_radius = ability:GetLevelSpecialValueFor("splinter_radius_scepter", ability_level)
	local target_pos = target:GetAbsOrigin()
	
	-- Roll for splinter chance
	if RandomInt(1, 100) <= splinter_chance then

		-- Find enemies near the target
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, splinter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #nearby_enemies > 1 then

			-- Choose a nearby enemy different from the initial target
			local splinter_target
			if nearby_enemies[1] ~= target then
				splinter_target = nearby_enemies[1]
			else
				splinter_target = nearby_enemies[2]
			end

			-- Splinter projectile parameters
			local splinter_projectile = {
				Target = splinter_target,
				Source = target,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf",
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = 1250,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectile
			ProjectileManager:CreateTrackingProjectile(splinter_projectile)
		end
	end
end

function MarksmanshipHit( keys )
	local caster = keys.caster
	local target = keys.target

	caster:PerformAttack(target, true, true, true, true, false)
end