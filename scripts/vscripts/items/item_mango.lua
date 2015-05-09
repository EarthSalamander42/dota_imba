--[[	Author: d2imba
		Date:	09.05.2015	]]

function Mango( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local minimum_mana = ability:GetLevelSpecialValueFor("minimum_mana", ability_level)
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)

	-- Calculates the mana to restore
	local mana_to_restore = target:GetMaxMana() * mana_percent / 100
	if mana_to_restore < minimum_mana then
		mana_to_restore = minimum_mana
	end

	-- Restores mana
	target:GiveMana(mana_to_restore)
end