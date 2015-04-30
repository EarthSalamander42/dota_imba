function DeathPulse( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_buff = keys.stack_buff
	local stack_debuff = keys.stack_debuff

	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local heal = ability:GetLevelSpecialValueFor("heal", ability_level)
	local stack_power = ability:GetLevelSpecialValueFor("stack_power", ability_level)

	local stack_count

	-- The buff and debuff are separate modifiers, for cases such as spell-stolen death pulse, or same-hero modes.
	if target:GetTeam() == caster:GetTeam() then
		if target:HasModifier(stack_buff) then
			stack_count = target:GetModifierStackCount(stack_buff, ability)
		else
			stack_count = 0
		end
		heal = heal * (1 + stack_power * stack_count / 100)
		target:Heal(heal, caster)
		AddStacks(ability, caster, target, stack_buff, 1, true)
	else
		if target:HasModifier(stack_debuff) then
			stack_count = target:GetModifierStackCount(stack_debuff, ability)
		else
			stack_count = 0
		end
		damage = damage * (1 + stack_power * stack_count / 100)
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		AddStacks(ability, caster, target, stack_debuff, 1, true)
	end
end

function Heartstopper( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stack_modifier = keys.stack_modifier
	local visibility_modifier = keys.visible_modifier

	AddStacks(ability, caster, target, stack_modifier, 1, true)

	if target:CanEntityBeSeenByMyTeam(caster) then
		if not target:HasModifier(visibility_modifier) then
			ability:ApplyDataDrivenModifier(caster, target, visibility_modifier, {})
		end
		target:SetModifierStackCount(visibility_modifier, ability, target:GetModifierStackCount(stack_modifier, ability))
	else
		target:RemoveModifierByName(visibility_modifier)
	end
end

function Sadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local regen_modifier = keys.regen_modifier

	local hero_multiplier = ability:GetLevelSpecialValueFor("hero_multiplier", ability:GetLevel() - 1 )

	if target:IsRealHero() then
		for i = 1, hero_multiplier do
			ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, regen_modifier, {})
	end
end

function ApplySadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	AddStacks(ability, caster, caster, stack_modifier, 1, true)
end

function RemoveSadist( keys )
	local caster = keys.caster
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	RemoveStacks(ability, caster, stack_modifier, 1)
end

function ReapersScythe( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local respawn_base = ability:GetLevelSpecialValueFor("respawn_base", ability_level)
	local respawn_stack = ability:GetLevelSpecialValueFor("respawn_stack", ability_level)
	local damage_delay = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local scepter = HasScepter(caster)

	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	end

	-- Waits for damage_delay to apply damage
	Timers:CreateTimer(damage_delay, function()
		-- Calculates and deals damage
		local damage_bonus = 1 - target:GetHealth() / target:GetMaxHealth() 
		damage = damage * target:GetMaxHealth() * (1 + damage_bonus) / 100
		ApplyDamage(attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE)

		-- Initializes the buyback variable if necessary
		if not target.scythe_added_respawn then
			target.scythe_added_respawn = respawn_base
		end

		-- Checking if target is alive to decide if it needs to increase respawn time
		if not target:IsAlive() then
			target.scythe_added_respawn = scythe_added_respawn + respawn_stack
			target:SetTimeUntilRespawn(target:GetRespawnTime() + target.scythe_added_respawn)
			if scepter then
				target:SetBuyBackDisabledByReapersScythe(true)
			end
		end
	end)
end