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
		ability:StartCooldown(ability:GetCooldown(0) * (1 - caster:GetCooldownReduction() * 0.01))
	end

	-- Remove all existing stacks
	caster:RemoveModifierByName(modifier_move)
	caster:RemoveModifierByName(modifier_stacks)
end

function TranquilsAllyThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_bearer = keys.modifier_bearer
	local modifier_stacks = keys.modifier_stacks

	-- If this unit is a tranquils bearer, do nothing
	if target:HasModifier(modifier_bearer) then
		return nil
	end

	-- Parameters
	local radius = ability:GetSpecialValueFor("radius")
	local highest_stacks = 0

	-- Search for the aura bearer with the highest amount of stacks nearby
	local nearby_allies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,ally in pairs(nearby_allies) do
		
		-- If this ally is an aura bearer, fetch its stacks
		if ally:HasModifier(modifier_bearer) and ally:HasModifier(modifier_stacks) then
			highest_stacks = math.max(highest_stacks, ally:GetModifierStackCount(modifier_stacks, nil))
		end
	end

	-- If there are more than zero stacks, apply and update them
	if highest_stacks > 0 then
		ability:ApplyDataDrivenModifier(caster, target, modifier_stacks, {})
		target:SetModifierStackCount(modifier_stacks, caster, highest_stacks)

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