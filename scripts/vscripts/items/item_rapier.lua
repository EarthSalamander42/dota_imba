--[[	Author: d2imba
		Date:	16.05.2015	]]

function Rapier( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local damage = keys.damage

	if target:GetHealth() < damage then
		target:Kill(ability, caster)
	else
		target:SetHealth(target:GetHealth() - damage)
	end	
end

function RapierDrop( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_pos = caster:GetAbsOrigin()

	for i=0,5 do
		print("badlel")
		local item = caster:GetItemInSlot(i)
		if item and item:GetAbilityName() == "item_imba_rapier" then
			caster:DropItemAtPositionImmediate(item, caster_pos)
			print("lel")
		end
	end
end