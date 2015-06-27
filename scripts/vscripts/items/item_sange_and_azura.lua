--[[	Author: d2imba
		Date:	25.06.2015	]]

function Maim( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local sound_maim = keys.sound_maim
	local sound_amp = keys.sound_amp

	-- If there's no valid target, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	elseif target:IsAncient() then
		return nil
	end

	-- If a higher-priority maim debuff is present, do nothing
	if target:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_maim_stack") then
		return nil
	end

	-- If a lower-priority maim debuff is present, remove it
	target:RemoveModifierByName("modifier_item_imba_sange_maim")
	target:RemoveModifierByName("modifier_item_imba_azura_amp")
	target:RemoveModifierByName("modifier_item_imba_sange_and_yasha_maim_stacks")
	target:RemoveModifierByName("modifier_item_imba_azura_and_yasha_amp_stack")

	-- Parameters
	local maim_base = ability:GetLevelSpecialValueFor("maim_base", ability_level)
	local maim_stacking = ability:GetLevelSpecialValueFor("maim_stacking", ability_level)

	-- Increases or refreshes the number of maim stacks
	if target:HasModifier(modifier_stacks) then
		AddStacks(ability, caster, target, modifier_stacks, maim_stacking, true)
	else
		target:EmitSound(sound_maim)
		target:EmitSound(sound_amp)
		AddStacks(ability, caster, target, modifier_stacks, maim_base, true)
	end
end