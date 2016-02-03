--[[	Author: Firetoad
		Date:	16.12.2015	]]

function Skadi( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_ground = keys.particle_ground
	local modifier_freeze = keys.modifier_freeze

	-- Parameters
	local base_radius = ability:GetLevelSpecialValueFor("base_radius", ability_level)
	local base_duration = ability:GetLevelSpecialValueFor("base_duration", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local radius_per_str = ability:GetLevelSpecialValueFor("radius_per_str", ability_level)
	local duration_per_int = ability:GetLevelSpecialValueFor("duration_per_int", ability_level)
	local damage_per_agi = ability:GetLevelSpecialValueFor("damage_per_agi", ability_level)

	-- Calculate parameters
	local caster_loc = caster:GetAbsOrigin()
	local caster_str = caster:GetStrength()
	local caster_int = caster:GetIntellect()
	local caster_agi = caster:GetAgility()
	local radius = base_radius + caster_str * radius_per_str
	local duration = base_duration + caster_int * duration_per_int
	local damage = base_damage + caster_agi * damage_per_agi

	-- Play sound
	if RandomInt(1, 100) <= 5 then
		caster:EmitSound("Imba.SkadiDeadWinter")
	else
		caster:EmitSound(sound_cast)
	end

	-- Play particle
	local blast_pfx = ParticleManager:CreateParticle(particle_ground, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleAlwaysSimulate(blast_pfx)
	ParticleManager:SetParticleControl(blast_pfx, 0, caster_loc)
	ParticleManager:SetParticleControl(blast_pfx, 2, Vector(radius, 1, 1))

	-- Grant flying vision in the target area
	ability:CreateVisibilityNode(caster_loc, radius, 3)

	-- Find targets in range
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- Play sound
	if #nearby_enemies > 0 then
		caster:EmitSound(sound_target)
	end

	for _,enemy in pairs(nearby_enemies) do

		-- Apply damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Apply freeze modifier (do not refresh)
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_freeze, {duration = duration})

		-- Apply ministun
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.01})
	end
end

function SkadiProjectile( keys )
	local caster = keys.caster

	ChangeAttackProjectileImba(caster)
end

function SkadiSlow( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = keys.damage
	local modifier_slow = keys.modifier_slow

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsTower() or target:GetTeam() == caster:GetTeam() then
		return nil
	end

	-- Parameters
	local max_duration = ability:GetLevelSpecialValueFor("max_duration", ability_level)
	local min_duration = ability:GetLevelSpecialValueFor("min_duration", ability_level)
	local slow_range_cap = ability:GetLevelSpecialValueFor("slow_range_cap", ability_level)
		
	-- Calculate slow duration
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local distance = (target_pos - caster_pos):Length2D()
	local slow_duration = min_duration + ( max_duration - min_duration ) * math.max( slow_range_cap - distance, 0) / slow_range_cap

	-- Apply slow
	ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {duration = slow_duration})
end