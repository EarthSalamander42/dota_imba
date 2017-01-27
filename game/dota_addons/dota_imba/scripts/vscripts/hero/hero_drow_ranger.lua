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
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local self_knockback_duration = ability:GetLevelSpecialValueFor("self_knockback_duration", ability_level)
	local knockback_duration = ability:GetLevelSpecialValueFor("knockback_duration", ability_level)
	local knockback_height = ability:GetLevelSpecialValueFor("knockback_height", ability_level)
	local knockback_distance = 0
	local caster_range = caster:GetAttackRange()
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	local knockback_modifier = {}

	-- If the target is closer than the caster's attack range, increase knockback distance
	local target_distance = ( target_loc - caster_loc ):Length2D()
	if target_distance < caster_range then
		knockback_distance = caster_range - target_distance - 10
	end

	-- If this is the first target hit, knockback the caster away from it
	if not caster.gust_enemy_hit and knockback_distance > 50 then
		knockback_distance = knockback_distance / 2
		caster.gust_enemy_hit = true
		Timers:CreateTimer(0.6, function()
			caster.gust_enemy_hit = false
		end)

		-- Backflip
		local steps = math.floor(self_knockback_duration / 0.03)
		local max_height = 180
		local height_step = max_height / steps * 0.5
		local angle_step = 360 / steps
		local length = (caster_loc - target_loc):Normalized() * knockback_distance
		local length_step = length / steps
		
		local angle = 0
		local height = max_height
		local position = caster:GetAbsOrigin()
		Timers:CreateTimer(0, function()
			angle = angle + angle_step
			position = position + length_step
			height = height - height_step
			caster:SetAngles(-angle, 0, 0)
			caster:SetAbsOrigin(position + Vector(0, 0, height))
			if angle < 360 then
				return 0.03
			else
				FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
				caster:SetAngles(0, 0, 0)
			end
		end)

	end

	-- Enemy knockback
	knockback_modifier = {
		should_stun = 0,
		knockback_duration = knockback_duration,
		duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
		center_x = caster_loc.x,
		center_y = caster_loc.y,
		center_z = caster_loc.z
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, ability, "modifier_knockback", knockback_modifier )
end

function Trueshot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- If this is Rubick and Trueshot Aura is no longer present, do nothing and kill the modifiers
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_drow_ranger_trueshot") then
			caster:RemoveModifierByName("modifier_imba_trueshot_aura_owner_hero")
			caster:RemoveModifierByName("modifier_imba_trueshot_aura_owner_creep")
			caster:RemoveModifierByName("modifier_imba_trueshot_aura")
			caster:RemoveModifierByName("modifier_imba_trueshot_damage_stack")
			return nil
		end
	end

	-- If the caster is afflicted by Break, remove all stacks
	if caster.break_duration_left then
		target:RemoveModifierByName(modifier_stack)
		return nil
	end

	-- Adjust damage based on agility of caster
	local agility = caster:GetAgility()
	local percent = ability:GetLevelSpecialValueFor("trueshot_ranged_damage", ability:GetLevel() - 1 )
	local damage = math.floor( agility * percent / 100 )

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
	local modifier_effect = keys.modifier_effect

	-- If the ability was unlearned, do nothing
	if not ability then
		return nil
	end

	-- If the caster is afflicted by Break, remove the buff
	if caster.break_duration_left then
		caster:RemoveModifierByName(modifier_effect)
		return nil
	end

	-- Parameters
	local ability_level = ability:GetLevel() - 1
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

	-- If the ability was unlearned, or there's no scepter, or this is already a splinter, do nothing
	if not ability or not scepter or caster:IsIllusion() then
		return nil
	end

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local splinter_radius = ability:GetLevelSpecialValueFor("splinter_radius_scepter", ability_level)
	local target_pos = target:GetAbsOrigin()
	
	-- Iterate through enemies near the target
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, splinter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Ignore the initial target
		if enemy ~= target then
			
			-- Splinter projectile parameters
			local splinter_projectile = {
				Target = enemy,
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

	-- If at least one splinter was created, put the ability on cooldown
	if #nearby_enemies > 1 then
		local cooldown_reduction = GetCooldownReduction(caster)
		ability:StartCooldown(ability:GetCooldown(ability_level) * cooldown_reduction)
	end
end

function MarksmanshipHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_dmg_penalty = keys.modifier_dmg_penalty

	-- Attack the target
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dmg_penalty, {})
	caster:PerformAttack(target, true, true, true, true, false, false, false)
	caster:RemoveModifierByName(modifier_dmg_penalty)
end