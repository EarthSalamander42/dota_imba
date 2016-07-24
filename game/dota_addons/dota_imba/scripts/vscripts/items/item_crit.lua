--[[	Author: Firetoad
		Date:	21.07.2016	]]

function DaedalusAttackStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit
	local modifier_dummy = keys.modifier_dummy

	-- If the target is a building or an ally, do nothing
	if target:IsBuilding() or target:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Parameters
	local crit_chance = ability:GetSpecialValueFor("crit_chance")
	local base_crit = ability:GetSpecialValueFor("base_crit")

	-- Roll for a crit
	local rnd = math.random
	if rnd(100) <= crit_chance then
		
		-- If there's no crit multiplier counter, use the base value
		local crit_damage = base_crit
		if caster:HasModifier(modifier_dummy) then
			crit_damage = crit_damage + caster:GetModifierStackCount(modifier_dummy, caster)
		end

		-- Add the appropriate amount of crit stacks
		caster:RemoveModifierByName(modifier_crit)
		AddStacks(ability, caster, caster, modifier_crit, crit_damage, true)
	end
end

function DaedalusAttackHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_crit = keys.sound_crit
	local modifier_crit = keys.modifier_crit
	local modifier_item = keys.modifier_item
	local modifier_dummy = keys.modifier_dummy

	-- If the target is a building or an ally, do nothing
	if target:IsBuilding() or target:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Parameters
	local base_crit = ability:GetSpecialValueFor("base_crit")
	local crit_increase = ability:GetSpecialValueFor("crit_increase")

	-- If this is a crit, remove the modifier and reset the counter after a small delay
	if caster:HasModifier(modifier_crit) then
		target:EmitSound(sound_crit)
		Timers:CreateTimer(0.01, function()
			caster:RemoveModifierByName(modifier_crit)
			caster:RemoveModifierByName(modifier_dummy)
		end)

	-- Else, increase the crit damage count
	else

		-- Increase crit bonus if there is more than one Daedalus
		local item_stacks = caster:GetModifierStackCount(modifier_item, caster)
		crit_increase = crit_increase * item_stacks

		-- Add stacks of crit damage increase counter
		AddStacks(ability, caster, caster, modifier_dummy, crit_increase, true)
	end
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