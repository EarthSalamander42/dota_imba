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