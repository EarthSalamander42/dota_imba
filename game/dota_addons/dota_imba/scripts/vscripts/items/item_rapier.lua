--[[	Author: Firetoad
		Date:	16.05.2015	]]

function RapierThinkPhys( keys )
	local caster = keys.caster
	local particle_aura = keys.particle_aura

	-- Make the owner visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.1)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.1)

	-- Create rapier particle if necessary
	if not caster.rapier_phys_pfx then
		caster.rapier_phys_pfx = ParticleManager:CreateParticle(particle_aura, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(caster.rapier_phys_pfx, 0, caster:GetAbsOrigin())

	-- Else, update its position
	else
		ParticleManager:SetParticleControl(caster.rapier_phys_pfx, 0, caster:GetAbsOrigin())
	end
end

function RapierThinkMagic( keys )
	local caster = keys.caster
	local particle_aura = keys.particle_aura

	-- Make the owner visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.1)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.1)

	-- Create rapier particle if necessary
	if not caster.rapier_magic_pfx then
		caster.rapier_magic_pfx = ParticleManager:CreateParticle(particle_aura, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(caster.rapier_magic_pfx, 0, caster:GetAbsOrigin())

	-- Else, update its position
	else
		ParticleManager:SetParticleControl(caster.rapier_magic_pfx, 0, caster:GetAbsOrigin())
	end
end

function RapierThinkCursed( keys )
	local caster = keys.caster
	local item = keys.ability
	local particle_aura = keys.particle_aura

	-- Make the owner visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.1)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.1)

	-- Delete old rapier particles if necessary
	if caster.rapier_phys_pfx then
		ParticleManager:DestroyParticle(caster.rapier_phys_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.rapier_phys_pfx)
		caster.rapier_phys_pfx = nil
	end
	if caster.rapier_magic_pfx then
		ParticleManager:DestroyParticle(caster.rapier_magic_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.rapier_magic_pfx)
		caster.rapier_magic_pfx = nil
	end

	-- Create rapier particle if necessary
	if not caster.rapier_cursed_pfx then
		caster.rapier_cursed_pfx = ParticleManager:CreateParticle(particle_aura, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(caster.rapier_cursed_pfx, 0, caster:GetAbsOrigin())

	-- Else, update its position
	else
		ParticleManager:SetParticleControl(caster.rapier_cursed_pfx, 0, caster:GetAbsOrigin())
	end

	-- Calculate corruption damage
	local base_corruption = item:GetSpecialValueFor("base_corruption")
	local time_to_double = item:GetSpecialValueFor("time_to_double")
	if not caster.corruption_total_time then
		caster.corruption_total_time = 0
	end
	caster.corruption_total_time = caster.corruption_total_time + 0.03
	local total_corruption = base_corruption * caster:GetMaxHealth() * (caster.corruption_total_time / time_to_double) * 0.01 * 0.03
	ApplyHealthReductionDamage(caster, total_corruption)
end

function RapierDrop( keys )
	local caster = keys.caster
	local item = keys.ability
	local rapier_type = keys.rapier_type

	-- Destroy rapier particles, if existing
	if caster.rapier_phys_pfx then
		ParticleManager:DestroyParticle(caster.rapier_phys_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.rapier_phys_pfx)
		caster.rapier_phys_pfx = nil
	end
	if caster.rapier_magic_pfx then
		ParticleManager:DestroyParticle(caster.rapier_magic_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.rapier_magic_pfx)
		caster.rapier_magic_pfx = nil
	end
	if caster.rapier_cursed_pfx then
		ParticleManager:DestroyParticle(caster.rapier_cursed_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.rapier_cursed_pfx)
		caster.rapier_cursed_pfx = nil
	end

	-- Illusions stop here
	if caster:IsRealHero() then

		-- Reset cursed rapier corruption count
		caster.corruption_total_time = nil

		-- Remove the rapiers from the player's inventory
		caster:RemoveItem(item)

		-- Drop this rapier
		local caster_pos = caster:GetAbsOrigin()
		local drop = CreateItem(rapier_type, nil, nil)
		CreateItemOnPositionSync(caster_pos, drop)
		drop:LaunchLoot(false, 250, 0.5, caster_pos + RandomVector(100))
	end
end