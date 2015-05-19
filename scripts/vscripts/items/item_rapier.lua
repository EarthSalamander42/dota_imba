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

function AegisCheck( keys )
	local caster = keys.caster

	if not caster.has_aegis then
		caster.has_aegis = false
	end

	if HasAegis(caster) then
		caster.has_aegis = true
	else
		caster.has_aegis = false
	end
end

function RapierDrop( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_pos = caster:GetAbsOrigin()

	for i=0,5 do
		local item = caster:GetItemInSlot(i)
		if item and item:GetAbilityName() == "item_imba_rapier" and not caster.has_aegis then
			caster:DropItemAtPositionImmediate(item, caster_pos)
		end
	end
end