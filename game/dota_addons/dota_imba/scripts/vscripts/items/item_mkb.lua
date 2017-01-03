--[[	Author: d2imba
		Date:	20.09.2015	]]

function MonkeyKingBarProc( keys )
	local caster = keys.caster
	local target = keys.target

	-- If the target is a building, or if this is not a real hero, do nothing
	if target:IsBuilding() or ( not caster:IsRealHero() ) then
		return nil
	end

	-- Parameters
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local sound_bash = keys.sound_bash
	local particle_hit = keys.particle_hit
	local modifier_charge = keys.modifier_charge
	local pulverize_count = ability:GetLevelSpecialValueFor("pulverize_count", ability_level)
	local pulverize_radius = ability:GetLevelSpecialValueFor("pulverize_radius", ability_level)
	local pulverize_damage = ability:GetLevelSpecialValueFor("pulverize_damage", ability_level)
	local pulverize_stun = ability:GetLevelSpecialValueFor("pulverize_stun", ability_level)

	-- Add a stack of the charge modifier
	AddStacks(ability, caster, caster, modifier_charge, 1, true)

	-- If this isn't enough charges to proc the chain lightning, do nothing else
	local charge_count = caster:GetModifierStackCount(modifier_charge, caster)
	if charge_count < pulverize_count then
		return nil
	end

	-- Else, remove the charge counter and proc the pulverize
	caster:RemoveModifierByName(modifier_charge)
		
	-- Play bash sound
	target:EmitSound(sound_bash)

	-- Play pulverize sound
	target:EmitSound(sound_hit)

	-- Find enemies to ministun and damage
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, pulverize_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do

		-- Deal pulverize damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = pulverize_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Apply ministun
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = pulverize_stun})

		-- Play particle
		local pulverize_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(pulverize_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:SetParticleControl(pulverize_pfx, 1, Vector(100,0,0))
	end
end