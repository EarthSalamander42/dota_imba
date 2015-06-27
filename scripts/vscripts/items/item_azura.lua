--[[	Author: d2imba
		Date:	26.03.2015	]]

function Azura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local stack_sound = keys.stack_sound

	-- If there's no valid target, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	elseif target:IsAncient() then
		return nil
	end

	-- If a higher-priority amp debuff is present, do nothing
	if target:HasModifier("modifier_item_imba_sange_and_azura_stack") or target:HasModifier("modifier_item_imba_azura_and_yasha_amp_stack") or target:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_maim_stack") then
		return nil
	end

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("amp_stacks", ability_level)

	-- Increases or refreshes the number of amp stacks
	if target:HasModifier(modifier_stacks) then
		local current_stacks = target:GetModifierStackCount(modifier_stacks, ability)
		if current_stacks < max_stacks then
			AddStacks(ability, caster, target, modifier_stacks, 1, true)
		else
			AddStacks(ability, caster, target, modifier_stacks, 0, true)
		end
	else
		target:EmitSound(stack_sound)
		AddStacks(ability, caster, target, modifier_stacks, 1, true)
	end
end