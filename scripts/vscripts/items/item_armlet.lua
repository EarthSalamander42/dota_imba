--[[	Author: d2imba
		Date:	24.05.2015	]]

function Armlet( keys )
	local caster = keys.caster
	local ability = keys.ability
	local new_item = keys.new_item
	local bonus_strength = ability:GetLevelSpecialValueFor("unholy_bonus_strength", ability:GetLevel() - 1 )

	-- Grant unholy strength's excess HP and switch to active Armlet
	local initial_hp = caster:GetHealth()
	local bonus_hp = bonus_strength * 19
	SwapToItem(caster, ability, new_item)
	caster:SetHealth( initial_hp + bonus_hp )
end

function ArmletDeactivate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local new_item = keys.new_item
	local bonus_strength = ability:GetLevelSpecialValueFor("unholy_bonus_strength", ability:GetLevel() - 1 )

	-- Remove unholy strength's excess HP and switch to regular Armlet
	local initial_hp = caster:GetHealth()
	local bonus_hp = bonus_strength * 19
	SwapToItem(caster, ability, new_item)
	caster:SetHealth( math.max( initial_hp - bonus_hp, 1) )
end

function UnholyStrength( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local stack_modifier = keys.stack_modifier
	local stacks_per_second = ability:GetLevelSpecialValueFor("stacks_per_second", ability_level)
	local health_drain = ability:GetLevelSpecialValueFor("unholy_health_drain", ability_level)

	if not caster:IsIllusion() then
		-- Remove health from the owner
		local current_hp = caster:GetHealth()
		health_drain = health_drain / stacks_per_second
		caster:SetHealth( math.max( current_hp - health_drain, 1) )
	end

	-- Add a unholy strength stack
	AddStacks(ability, caster, caster, stack_modifier, 1, true)
end

function UnholyStrengthEnd( keys )
	local caster = keys.caster
	local stack_modifier = keys.stack_modifier

	caster:RemoveModifierByName(stack_modifier)
end