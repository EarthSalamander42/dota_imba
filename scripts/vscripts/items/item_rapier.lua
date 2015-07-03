--[[	Author: d2imba
		Date:	16.05.2015	]]

function RapierPickup( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Apply stacks of the Rapier buff
	local rapier_stacks = ability:GetCurrentCharges()
	AddStacks(ability, caster, caster, "modifier_item_imba_rapier", rapier_stacks, true)
	print("applied "..rapier_stacks.." stacks of RAPIRA")
end

function RapierDamage( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local damage = keys.damage

	-- Retrieve the current amount of rapier stacks
	local rapier_stacks = caster:GetModifierStackCount("modifier_item_imba_rapier", ability)
	print(rapier_stacks.." stacks of RAPIRA found! multiplying damage")

	-- Deal extra damage
	caster:RemoveModifierByName("modifier_item_imba_rapier")
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage * rapier_stacks, damage_type = DAMAGE_TYPE_PURE})
	AddStacks(ability, caster, caster, "modifier_item_imba_rapier", rapier_stacks, true)
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

	-- If the caster has aegis, do nothing
	if caster.has_aegis then
		return nil
	end

	-- Retrieve the current amount of rapier stacks
	local rapier_stacks = caster:GetModifierStackCount("modifier_item_imba_rapier", ability)
	print("RAPIRA owner died with "..rapier_stacks.." stacks!")

	-- Remove the rapier stacks
	caster:RemoveModifierByName("modifier_item_imba_rapier")

	-- Removes the rapiers from the player's inventory
	for i = 0, 12 do
		local item = caster:GetItemInSlot(i)
		if item and item:GetAbilityName() == "item_imba_rapier" then
			print("RAPIRA found! Removing RAPIRA from slot "..i)
			caster:DropItemAtPositionImmediate(item, caster:GetAbsOrigin())
		end
	end
end