--[[	Author: Firetoad
		Date:	21.07.2016	]]

function DaedalusAttackStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_crit = keys.modifier_crit

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
		if caster.current_daedalus_crit_multiplier then
			crit_damage = caster.current_daedalus_crit_multiplier
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
			caster.current_daedalus_crit_multiplier = nil
		end)

	-- Else, increase the crit damage count
	else
		if not caster.current_daedalus_crit_multiplier then
			caster.current_daedalus_crit_multiplier = base_crit
		else
			caster.current_daedalus_crit_multiplier = caster.current_daedalus_crit_multiplier + crit_increase
		end
	end
end