--[[	Author: Firetoad
		Date: 16.08.2015	]]

function Upgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Calculate total buff stacks
	local total_stacks = math.max( ( GameRules:GetGameTime() - HERO_SELECTION_TIME - PRE_GAME_TIME ) / 60, 0)

	-- Increase amount of stacks according to game speed
	total_stacks = total_stacks * CREEP_POWER_RAMP_UP_FACTOR

	-- Cap the stacks
	total_stacks = math.min(total_stacks, 100)

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function Frantic( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_cd = keys.modifier_cd
	local modifier_mana = keys.modifier_mana

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_cd)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local cd_stacks = 100 - math.floor( 100 / FRANTIC_MULTIPLIER )
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_cd, cd_stacks, true)
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
end

function FranticUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_mana = keys.modifier_mana
	local modifier_dummy = keys.modifier_dummy

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_dummy)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
end