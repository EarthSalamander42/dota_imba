--[[	Author: d2imba
		Date:	13.08.2015	]]

function Cheese( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_cast = keys.sound_cast

	-- Play sound
	target:EmitSound(sound_cast)

	-- Fully heal the target
	target:Heal(target:GetMaxHealth(), caster)
	target:GiveMana(target:GetMaxMana())

	-- Spend a charge
	ability:SetCurrentCharges( ability:GetCurrentCharges() - 1 )

	-- If this was the last charge, remove the item
	if ability:GetCurrentCharges() == 0 then
		caster:RemoveItem(ability)
	end
end