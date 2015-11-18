--[[	Author: d2imba
		Date:	09.05.2015	]]

function Mango( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
<<<<<<< HEAD
	local sound_cast = keys.sound_cast

	-- If there isn't a target, use on self
	if not target then
		target = caster
	end
=======
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108

	-- Parameters
	local minimum_mana = ability:GetLevelSpecialValueFor("minimum_mana", ability_level)
	local mana_percent = ability:GetLevelSpecialValueFor("mana_percent", ability_level)

<<<<<<< HEAD
	-- Calculate the mana to restore
=======
	-- Calculates the mana to restore
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
	local mana_to_restore = target:GetMaxMana() * mana_percent / 100
	if mana_to_restore < minimum_mana then
		mana_to_restore = minimum_mana
	end

<<<<<<< HEAD
	-- Play sound
	target:EmitSound(sound_cast)
	
	-- Restore mana
=======
	-- Restores mana
>>>>>>> 89be1c8d830c3e137210ee56e52e0e38cc5c3108
	target:GiveMana(mana_to_restore)
end