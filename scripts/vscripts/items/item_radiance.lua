--[[	Author: d2imba
		Date:	25.03.2015	]]

function Radiance( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stacks = keys.modifier_stacks

	local aura_damage = ability:GetLevelSpecialValueFor("aura_damage", ability_level)
	local stacking_damage = ability:GetLevelSpecialValueFor("stacking_damage", ability_level)
	local max_creep_stacks = ability:GetLevelSpecialValueFor("max_creep_stacks", ability_level)

	-- Increases the number of radiance stacks
	if target:HasModifier(modifier_stacks) then
		local current_stacks = target:GetModifierStackCount(modifier_stacks, ability)
		if target:IsHero() or current_stacks < max_creep_stacks then
			target:SetModifierStackCount(modifier_stacks, caster, current_stacks + 1 )
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
		target:SetModifierStackCount(modifier_stacks, caster, 1 )
	end

	-- Deals damage
	local stacks = target:GetModifierStackCount(modifier_stacks, ability)
	local damage_table = {}
 	damage_table.victim = target
 	damage_table.attacker = caster
 	damage_table.ability = ability
 	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
 	damage_table.damage = aura_damage + stacks * stacking_damage
	ApplyDamage(damage_table)
end

function RadianceEnd( keys )
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	target:SetModifierStackCount(modifier_stacks, target, 0 )
	target:RemoveModifierByName(modifier_stacks)
end