--[[	Author: d2imba
		Date:	25.06.2015	]]

function Yasha( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks
	local sound_battle_rhythm = keys.sound_battle_rhythm

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- If a higher-priority battle rhytm buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_azura_and_yasha_stack") or caster:HasModifier("modifier_item_imba_sange_and_yasha_stack") or caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_stack") then
		return nil
	end

	-- Increase or refresh the number of battle rhythm stacks
	if caster:HasModifier(modifier_stacks) then
		local current_stacks = caster:GetModifierStackCount(modifier_stacks, ability)
		if current_stacks < max_stacks then
			AddStacks(ability, caster, caster, modifier_stacks, 1, true)
		else
			AddStacks(ability, caster, caster, modifier_stacks, 0, true)
		end
	else
		caster:EmitSound(sound_battle_rhythm)
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)
	end
end

function YashaProc( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_projectile = keys.sound_projectile

	-- If a higher-priority illusion generation buff is present, do nothing
	if caster:HasModifier("modifier_item_imba_azura_and_yasha_proc") or caster:HasModifier("modifier_item_imba_sange_and_yasha_proc") or caster:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_proc") then
		return nil
	end

	-- Play sound
	caster:EmitSound(sound_projectile)

	caster:PerformAttack(target, true, true, true, true, true)
end