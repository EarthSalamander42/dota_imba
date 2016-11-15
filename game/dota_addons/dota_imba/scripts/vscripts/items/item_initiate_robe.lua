--[[	Author: Firetoad
		Date:	14.11.2016	]]

function InitiateRobeThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks
	local particle_shield = keys.particle_shield

	-- If a higher-level version of the ability is present, do nothing
	if caster:HasModifier("modifier_item_imba_arcane_nexus_unique") then
		return nil
	end

	-- Parameters
	local mana_conversion_rate = ability:GetSpecialValueFor("mana_conversion_rate") * 0.01
	local max_stacks = ability:GetSpecialValueFor("max_stacks")

	-- Create the global variable, if necessary
	if not caster.magic_shield_mana_count then
		caster.magic_shield_mana_count = caster:GetMana()
	end

	-- Fetch current mana
	local current_mana = caster:GetMana()

	-- If mana was spent or lost, grant magic shield stacks
	if current_mana < caster.magic_shield_mana_count then

		-- Calculate magic shield stacks to gain
		local stacks_to_gain = ( caster.magic_shield_mana_count - current_mana ) * mana_conversion_rate
		
		-- Update mana tracking variable
		caster.magic_shield_mana_count = current_mana

		-- Fetch current amount of shield stacks
		local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

		-- Add the appropriate amount of shield stacks
		AddStacks(ability, caster, caster, modifier_stacks, math.min(stacks_to_gain, max_stacks - current_stacks), true)

		-- Play the mana shield particle
		local shield_pfx = ParticleManager:CreateParticle(particle_shield, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(shield_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(shield_pfx)

	-- Else, update the mana tracking variable
	else
		caster.magic_shield_mana_count = current_mana
	end
end

function InitiateRobeEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- Clear global variable
	caster.magic_shield_mana_count = nil

	-- Remove magic shield stacks
	caster:RemoveModifierByName(modifier_stacks)
end