--[[	Author: Firetoad
		Date:	24.11.2016	]]

function AetherLensRangeThink( keys )
	local caster = keys.caster

	-- If a higher-level version of the ability is present do nothing
	if caster:HasModifier("modifier_item_imba_elder_staff_range") or caster:HasModifier("modifier_item_imba_arcane_nexus_range") then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local modifier_cast_range = keys.modifier_cast_range

	-- Update aether lens modifier
	caster:RemoveModifierByName(modifier_cast_range)
	caster:AddNewModifier(caster, ability, modifier_cast_range, {})
end

function AetherLensRangeDestroy( keys )
	local caster = keys.caster
	local modifier_cast_range = keys.modifier_cast_range

	-- Remove aether lens modifier
	caster:RemoveModifierByName(modifier_cast_range)
end

function ElderStaffRangeThink( keys )
	local caster = keys.caster

	-- If a higher-level version of the ability is present do nothing
	if caster:HasModifier("modifier_item_imba_arcane_nexus_range") then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local modifier_cast_range = keys.modifier_cast_range

	-- Update aether lens modifier
	caster:RemoveModifierByName(modifier_cast_range)
	caster:AddNewModifier(caster, ability, modifier_cast_range, {})
end

function ElderStaffRangeDestroy( keys )
	local caster = keys.caster
	local modifier_cast_range = keys.modifier_cast_range

	-- Remove aether lens modifier
	caster:RemoveModifierByName(modifier_cast_range)
end