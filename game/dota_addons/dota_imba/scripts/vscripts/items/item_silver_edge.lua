--[[	Author: d2imba
		Date:	15.08.2015	]]

function SilverEdgeSlow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_maim = keys.modifier_maim

	-- If there's no valid target, do nothing
	if target:IsBuilding() or target:IsAncient() or target:IsMagicImmune() then
		return nil
	end

	-- Apply the maim debuff
	ability:ApplyDataDrivenModifier(caster, target, modifier_maim, {})
end

function SilverEdgeFade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_fade = keys.modifier_fade
	local sound_cast = keys.sound_cast

	-- Apply fade modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_fade, {})

	-- Play sound to the caster's team
	EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, caster)

	-- Tell other invisibility abilities that Shadow Blade is active
	caster.shadow_blade_active = true

	-- If there are nearby enemies who can see the caster, play sound for them
	local nearby_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, unit in pairs(nearby_units) do
		if unit:CanEntityBeSeenByMyTeam(caster) then
			EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, unit)
			return nil
		end
	end
end

function SilverEdgeInvisCancel( keys )
	local caster = keys.caster

	-- Tell other invisibility abilities that Shadow Blade is no longer active
	caster.shadow_blade_active = nil
end

function SilverEdgeInvis( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_invis = keys.modifier_invis
	local modifier_phase = keys.modifier_phase

	-- Parameters
	local invis_duration = ability:GetLevelSpecialValueFor("invis_duration", ability_level)

	-- Apply modifiers
	ability:ApplyDataDrivenModifier(caster, caster, modifier_invis, {})
	ability:ApplyDataDrivenModifier(caster, caster, modifier_phase, {})
	caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = invis_duration})
end

function SilverEdgeHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_hit = keys.particle_hit

	-- If the target is a building, do nothing
	if target:IsBuilding() or target:IsTower() then
		return nil
	end

	-- Parameters
	local invis_damage = ability:GetLevelSpecialValueFor("invis_damage", ability_level)

	-- Play sound
	target:EmitSound(sound_hit)

	-- Play particle
	local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = invis_damage, damage_type = DAMAGE_TYPE_PHYSICAL})

	-- Show overhead damage message
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, invis_damage, nil)
end

function SilverEdgePhaseCooldown( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local modifier_phase = keys.modifier_phase
	local modifier_phase_cd = keys.modifier_phase_cd

	-- Check if damage was dealt by a hero
	if attacker:IsHero() then

		-- Remove phasing modifier
		caster:RemoveModifierByName(modifier_phase)

		-- Apply phasing cooldown modifier
		ability:ApplyDataDrivenModifier(caster, caster, modifier_phase_cd, {})
	end
end

function SilverEdgePhaseCooldownEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_invis = keys.modifier_invis
	local modifier_phase = keys.modifier_phase

	-- Check if the caster still has the invisibility modifier
	if caster:HasModifier(modifier_invis) and caster:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_phase, {})
	end
end

function SilverEdgeBreakParticleEnd( keys )
	local target = keys.target

	-- Destroy particle
	if target.silver_edge_break_particle then
		ParticleManager:DestroyParticle(target.silver_edge_break_particle, false)
		target.silver_edge_break_particle = nil
	end
end

function SilverEdgeAura( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_target = keys.particle_target

	-- Create particle
	if not target.silver_edge_aura_particle then
		target.silver_edge_aura_particle = ParticleManager:CreateParticleForTeam(particle_target, PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
		ParticleManager:SetParticleControl(target.silver_edge_aura_particle, 0, target:GetAbsOrigin())
	end
end

function SilverEdgeAuraEnd( keys )
	local target = keys.target

	-- Destroy particle
	if target.silver_edge_aura_particle then
		ParticleManager:DestroyParticle(target.silver_edge_aura_particle, false)
		target.silver_edge_aura_particle = nil
	end
end