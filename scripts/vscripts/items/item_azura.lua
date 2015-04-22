--[[	Author: d2imba
		Date:	26.03.2015	]]

function Azura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks

	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Increases the number of amp stacks
	if target:HasModifier(modifier_stacks) then
		local current_stacks = target:GetModifierStackCount(modifier_stacks, ability)
		if current_stacks < max_stacks then
			ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
			target:SetModifierStackCount(modifier_stacks, caster, current_stacks + 1 )
		else
			ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
		target:SetModifierStackCount(modifier_stacks, caster, 1 )
	end
end

function AzuraEnd( keys )
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	target:SetModifierStackCount(modifier_stacks, target, 0 )
	target:RemoveModifierByName(modifier_stacks)
end