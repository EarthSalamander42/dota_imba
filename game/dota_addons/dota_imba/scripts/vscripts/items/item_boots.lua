--[[	Author: Firetoad
		Date:	08.07.2016	]]

function HasteBoots( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_ms = keys.modifier_ms
	local sound_haste = keys.sound_haste
	local particle_haste = keys.particle_haste

	-- Parameters
	local phase_duration = ability:GetLevelSpecialValueFor("phase_duration", ability_level)

	-- Play sound locally
	EmitSoundOnClient(sound_haste, PlayerResource:GetPlayer(caster:GetPlayerID()))

	-- Play particle
	local haste_pfx = ParticleManager:CreateParticle(particle_haste, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(haste_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(haste_pfx)

	-- Apply bonus move speed
	ability:ApplyDataDrivenModifier(caster, caster, modifier_ms, {})

	-- Increase move speed limit
	caster:AddNewModifier(caster, ability, "modifier_imba_haste_boots_speed_break", {duration = phase_duration})
end

function TranquilsThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_move = keys.modifier_move
	local modifier_stacks = keys.modifier_stacks

	-- If on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local base_move_speed = ability:GetLevelSpecialValueFor("base_move_speed", ability_level)
	local move_speed_per_sec = ability:GetLevelSpecialValueFor("move_speed_per_sec", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Fetch current amount of stacks
	local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

	-- If below maximum stacks, add one more
	if current_stacks < max_stacks then
		AddStacks(ability, caster, caster, modifier_stacks, 1, true)
		current_stacks = current_stacks + 1
	end

	-- Update movement speed
	ability:ApplyDataDrivenModifier(caster, caster, modifier_move, {})
	caster:SetModifierStackCount(modifier_move, caster, base_move_speed + move_speed_per_sec * current_stacks)
end

function TranquilsBreak( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_move = keys.modifier_move
	local modifier_stacks = keys.modifier_stacks

	-- Put the ability on cooldown
	if ability then
		ability:StartCooldown(ability:GetCooldown(0) * GetCooldownReduction(caster))
	end

	-- Remove all existing stacks
	caster:RemoveModifierByName(modifier_move)
	caster:RemoveModifierByName(modifier_stacks)
end

function TranquilsAllyThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	-- If the aura bearer has stacks, copy them
	if caster:HasModifier(modifier_stacks) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
		target:SetModifierStackCount(modifier_stacks, caster, caster:GetModifierStackCount(modifier_stacks, caster))

	-- Else, remove them
	else
		target:RemoveModifierByName(modifier_stacks)
	end
end

function TranquilsAllyEnd( keys )
	local target = keys.target
	local modifier_stacks = keys.modifier_stacks

	-- Remove all existing stacks of the aura
	target:RemoveModifierByName(modifier_stacks)
end