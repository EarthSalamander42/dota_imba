--[[	Authors: D2imba and Pizzalol
		Date: 23.05.2015				]]

function StiflingDaggerCrit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local crit_ability = caster:FindAbilityByName(keys.crit_ability_name)
	local crit_ability_level = crit_ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- If Coup de Grace is not leveled up, does nothing
	if crit_ability_level < 0 then
		return nil
	end

	-- Parameters
	local crit_chance = crit_ability:GetLevelSpecialValueFor("crit_chance", crit_ability_level)
	local crit_bonus = crit_ability:GetLevelSpecialValueFor("crit_bonus", crit_ability_level)
	local hero_dmg_pct = ability:GetLevelSpecialValueFor("hero_dmg_pct", ability_level)
	local base_damage = ability:GetAbilityDamage()
	local modifier_crit = keys.modifier_crit
	local modifier_blood_fx = keys.modifier_blood_fx

	-- Scepter parameters
	if scepter then
		crit_chance = math.floor( crit_chance / 2 )
	end

	-- Calculate actual chance to crit
	local actual_crit_chance = crit_chance
	if caster:HasModifier(modifier_crit) then
		actual_crit_chance = caster:GetModifierStackCount(modifier_crit, crit_ability)
	end

	-- RNGESUS HEAR MY PRAYER
	if RandomInt(1, 100) <= actual_crit_chance then

		-- Crit! draw the blood particle and refresh the crit stacks modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_blood_fx, {})
		AddStacks(crit_ability, caster, caster, modifier_crit, 0, true)

		-- Deal bonus damage
		if scepter then
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = 77777, damage_type = DAMAGE_TYPE_PURE})
		else
			if target:IsHero() then
				ApplyDamage({attacker = caster, victim = target, ability = ability, damage = base_damage * (crit_bonus - 100) / 100 * hero_dmg_pct / 100 , damage_type = DAMAGE_TYPE_PURE})
			else
				ApplyDamage({attacker = caster, victim = target, ability = ability, damage = base_damage * (crit_bonus - 100) / 100 , damage_type = DAMAGE_TYPE_PURE})
			end
		end		
	end
end

function PhantomStrike( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	-- If cast on self, refund mana cost and cooldown
	if caster == target then
		caster:RemoveModifierByName("modifier_imba_phantom_strike")
		ability:RefundManaCost()
		ability:EndCooldown()
		return nil
	end

	-- If cast on an enemy, immediately start attacking it
	if caster:GetTeam() ~= target:GetTeam() then
		caster:SetAttacking(target)
	end
end

function Blur( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_loc = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local modifier_enemy = keys.modifier_enemy

	local enemy_heroes = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)

	if #enemy_heroes > 0 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_enemy, {})
	else
		if caster:HasModifier(modifier_enemy) then
			caster:RemoveModifierByName(modifier_enemy)
		end
	end
end

function BlurStacks( keys )
	local caster = keys.caster
	local ability = keys.ability
	local attacker = keys.attacker
	local stack_modifier = keys.stack_modifier
	local damage = keys.damage
	local stack_evasion = ability:GetLevelSpecialValueFor("stack_evasion", ability:GetLevel() - 1 )

	-- Increase amount of evasion stacks
	local max_stacks = math.ceil( 100 / stack_evasion )
	if caster:GetModifierStackCount(stack_modifier, ability) < max_stacks then
		AddStacks(ability, caster, caster, stack_modifier, 1, true)
	else
		AddStacks(ability, caster, caster, stack_modifier, 0, true)
	end

	-- PRAY FOR RNGESUS
	if RandomInt(1, 100) <= caster:GetModifierStackCount(stack_modifier, ability) * stack_evasion then

		-- If prayer is successful, heal damage taken
		caster:Heal(damage, caster)
	end
end
	
function CoupDeGrace( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- Parameters
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
	local crit_increase = ability:GetLevelSpecialValueFor("crit_increase", ability_level)
	local stack_modifier = keys.stack_modifier
	local crit_modifier = keys.crit_modifier
	local kill_modifier = keys.kill_modifier

	-- Scepter parameters
	if scepter then
		crit_chance = math.floor( crit_chance / 2 )
		crit_increase = math.floor( crit_increase / 2 )
	end

	-- Calculate actual chance to crit
	local max_stacks = 100
	local actual_crit_chance = crit_chance
	if caster:HasModifier(stack_modifier) then
		actual_crit_chance = caster:GetModifierStackCount(stack_modifier, ability)
	end

	-- RNGESUS ES MI PASTOR
	if RandomInt(1, 100) <= actual_crit_chance then

		-- Crit! Apply crit modifier and increase crit chance
		if scepter then
			ability:ApplyDataDrivenModifier(caster, caster, kill_modifier, {})
		else
			ability:ApplyDataDrivenModifier(caster, caster, crit_modifier, {})
		end
		
		if caster:HasModifier(stack_modifier) then
			local current_stacks = caster:GetModifierStackCount(stack_modifier, ability)
			if current_stacks + crit_increase <= max_stacks then
				AddStacks(ability, caster, caster, stack_modifier, crit_increase, true)
			else
				AddStacks(ability, caster, caster, stack_modifier, max_stacks - current_stacks, true)
			end			
		else
			AddStacks(ability, caster, caster, stack_modifier, crit_chance + crit_increase, true)
		end
	end
end