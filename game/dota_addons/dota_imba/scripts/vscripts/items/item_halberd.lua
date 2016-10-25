--[[	Author: d2imba
		Date:	24.06.2015	]]

function HalberdCast( keys )		
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_target = keys.particle_target
	local modifier_disarm = keys.modifier_disarm
	local disarm_range = keys.disarm_range
	local disarm_melee = keys.disarm_melee
	
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play cast sound
	caster:EmitSound(sound_cast)
	
	-- Check if melee or ranged
	if target:IsRangedAttacker() then
		target:AddNewModifier(caster, ability, "modifier_halberd_disarm", {duration = disarm_range})
		ability:ApplyDataDrivenModifier(caster, target, modifier_disarm, {duration = disarm_range})
	else
		target:AddNewModifier(caster, ability, "modifier_halberd_disarm", {duration = disarm_melee})
		ability:ApplyDataDrivenModifier(caster, target, modifier_disarm, {duration = disarm_melee})
	end
end
	
	
function Maim( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_maim = keys.modifier_maim
	local sound_maim = keys.sound_maim

	-- If there's no valid target, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	elseif target:IsAncient() then
		return nil
	end

	-- If a higher-priority maim debuff is present, do nothing
	if target:HasModifier("modifier_item_imba_sange_and_yasha_maim_stacks") or target:HasModifier("modifier_item_imba_sange_and_azura_stack") or target:HasModifier("modifier_item_imba_sange_and_azura_and_yasha_maim_stack") then
		return nil
	end

	-- If a lower-priority maim debuff is present, remove it
	target:RemoveModifierByName("modifier_item_imba_sange_maim")
	target:RemoveModifierByName("modifier_item_imba_silver_edge_maim")

	-- Parameters
	local maim_base = ability:GetLevelSpecialValueFor("maim_base", ability_level)
	local maim_stacking = ability:GetLevelSpecialValueFor("maim_stacking", ability_level)
	local maim_cap = ability:GetLevelSpecialValueFor("maim_cap", ability_level)

	-- Increases or refreshes the number of maim stacks
	if target:HasModifier(modifier_maim) then
		local current_stacks = target:GetModifierStackCount(modifier_maim, ability)
		if current_stacks < maim_cap then
			if current_stacks + maim_stacking > maim_cap then
				AddStacks(ability, caster, target, modifier_maim, maim_cap - current_stacks, true)
			else
				AddStacks(ability, caster, target, modifier_maim, maim_stacking, true)
			end
		else
			AddStacks(ability, caster, target, modifier_maim, 0, true)
		end
	else
		target:EmitSound(sound_maim)
		AddStacks(ability, caster, target, modifier_maim, maim_base, true)
	end
end