--[[	Author: d2imba
		Date:	13.08.2015	]]

function AegisHeal( keys )
	local caster = keys.caster
	local sound_heal = keys.sound_heal

	-- Play sound
	caster:EmitSound(sound_heal)

	-- Heal
	caster:Heal(caster:GetMaxHealth(), caster)
	caster:GiveMana(caster:GetMaxMana())

	-- Remove this item
	caster:RemoveItem(ability)

	-- Refresh all your abilities
	for i = 0, 15 do
		local current_ability = caster:GetAbilityByIndex(i)

		-- Refresh
		if current_ability then
			current_ability:EndCooldown()
		end
	end

	-- Flag caster as no longer having aegis
	caster.has_aegis = false
end