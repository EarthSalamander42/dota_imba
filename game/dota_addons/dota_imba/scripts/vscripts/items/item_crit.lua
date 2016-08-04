--[[	Author: Firetoad
		Date:	21.07.2016	]]

function DaedalusHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit
	local modifier_item = keys.modifier_item
	local modifier_dummy = keys.modifier_dummy

	-- If the target is a building or an ally, or this is a crit, do nothing
	if target:IsBuilding() or target:GetTeam() == caster:GetTeam() or caster:HasModifier(modifier_crit) then
		return nil
	end

	-- Parameters
	local crit_chance = ability:GetSpecialValueFor("crit_chance")
	local base_crit = ability:GetSpecialValueFor("base_crit")
	local crit_increase = ability:GetSpecialValueFor("crit_increase")
	local current_increase = caster:GetModifierStackCount(modifier_dummy, caster)

	-- Increase crit bonus if there is more than one Daedalus
	local item_stacks = caster:GetModifierStackCount(modifier_item, caster)
	crit_increase = crit_increase * item_stacks

	-- Roll for a crit
	local rnd = math.random
	if rnd(100) <= crit_chance then

		-- If there's no crit multiplier counter, use the base value
		local crit_damage = base_crit + crit_increase
		if caster:HasModifier(modifier_dummy) then
			crit_damage = crit_damage + current_increase + crit_increase
		end

		-- Add the appropriate amount of crit stacks
		AddStacks(ability, caster, caster, modifier_crit, crit_damage, true)
	end

	-- Add stacks of crit damage increase counter
	AddStacks(ability, caster, caster, modifier_dummy, crit_increase, true)
end

function DaedalusCrit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_crit = keys.sound_crit
	local modifier_crit = keys.modifier_crit
	local modifier_dummy = keys.modifier_dummy

	-- Play the crit sound
	target:EmitSound(sound_crit)

	-- Reset the crit damage stacks
	caster:RemoveModifierByName(modifier_dummy)

	-- Remove the crit modifier after a slight delay
	Timers:CreateTimer(0.01, function()
		caster:RemoveModifierByName(modifier_crit)
	end)
end

function DaedalusStackUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit

	-- Apply a stack of the cleave modifier
	AddStacks(ability, caster, caster, modifier_crit, 1, true)
end

function DaedalusStackDown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit

	-- If this is the last stack, remove cleave modifier
	local current_stacks = caster:GetModifierStackCount(modifier_crit, caster)
	if current_stacks <= 1 then
		caster:RemoveModifierByName(modifier_crit)

	-- Else, reduce stack count by 1
	else
		caster:SetModifierStackCount(modifier_crit, caster, current_stacks - 1)
	end
end