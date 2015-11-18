--[[	Author: d2imba
		Date:	09.05.2015	]]

function Mango( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast

	-- If there isn't a target, use on self
	if not target then
		target = caster
	end

	-- Parameters
	local minimum_mana = ability:GetLevelSpecialValueFor("minimum_mana", ability_level)
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)

	-- Calculate the mana to restore
	local mana_to_restore = target:GetMaxMana() * mana_percent / 100
	if mana_to_restore < minimum_mana then
		mana_to_restore = minimum_mana
	end

	-- Play sound
	target:EmitSound(sound_cast)
	
	-- Restore mana
	target:GiveMana(mana_to_restore)
end