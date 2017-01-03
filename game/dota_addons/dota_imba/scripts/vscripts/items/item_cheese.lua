--[[	Author: d2imba
		Date:	13.08.2015	]]

function Cheese( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_cast = keys.sound_cast

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Fully heal the caster
	caster:Heal(caster:GetMaxHealth(), caster)
	caster:GiveMana(caster:GetMaxMana())

	-- Spend a charge
	ability:SetCurrentCharges( ability:GetCurrentCharges() - 1 )

	-- If this was the last charge, remove the item
	if ability:GetCurrentCharges() == 0 then
		caster:RemoveItem(ability)
	end
end