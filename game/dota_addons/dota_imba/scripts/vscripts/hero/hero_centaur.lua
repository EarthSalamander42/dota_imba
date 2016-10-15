--[[	Author: D2imba
		Date: 20.03.2015	]]

function HoofStomp( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_caster = keys.modifier_caster
	local modifier_enemies = keys.modifier_enemies
	local particle_pit = keys.particle_pit

	-- Parameters
	local pit_radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local pit_duration = ability:GetLevelSpecialValueFor("pit_duration", ability:GetLevel() - 1)
	local pit_center = caster:GetAbsOrigin()
	local pit_duration_elapsed = 0
	local pit_enemies = {}

	-- Fire the particle
	local pit_fx = ParticleManager:CreateParticle(particle_pit, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pit_fx, 0, pit_center)

	-- Destroy the particle after [pit_duration] seconds
	Timers:CreateTimer(pit_duration, function()
		ParticleManager:DestroyParticle(pit_fx, false)
	end)

	-- Mark the enemies inside the pit to prevent them from leaving
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), pit_center, nil, pit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, enemy in pairs(nearby_enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, modifier_enemies, {duration = pit_duration})
		pit_enemies[#pit_enemies + 1] = enemy
		enemy.hoof_pit_owner = caster
	end

	-- Continuously prevent enemies inside the ring from leaving
	Timers:CreateTimer(0, function()

		-- Check if any new enemies entered the pit
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), pit_center, nil, pit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			if not enemy:HasModifier(modifier_enemies) then
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_enemies, {duration = pit_duration - pit_duration_elapsed})
				pit_enemies[#pit_enemies + 1] = enemy
				enemy.hoof_pit_owner = caster
			end
		end

		-- If an enemy previously marked is outside the ring, move it in
		for k, enemy in pairs(pit_enemies) do
			if ( enemy:GetAbsOrigin() - pit_center ):Length2D() > pit_radius and enemy.hoof_pit_owner == caster and enemy:HasModifier(modifier_enemies) then
				FindClearSpaceForUnit(enemy, pit_center + ( enemy:GetAbsOrigin() - pit_center ):Normalized() * pit_radius, true)
			end
		end

		-- If the caster is outside the pit, remove the damage reduction modifier
		if ( caster:GetAbsOrigin() - pit_center ):Length2D() > pit_radius then
			caster:RemoveModifierByName(modifier_caster)
		end

		-- Check if the pit has ended
		pit_duration_elapsed = pit_duration_elapsed + 0.05
		if pit_duration_elapsed < pit_duration then
			return 0.05
		else

			-- Remove modifier from marked enemies
			for _, enemy in pairs(pit_enemies) do
				enemy:RemoveModifierByName(modifier_enemies)
				enemy.hoof_pit_owner = nil
			end
		end
	end)
end

function DoubleEdge( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("edge_damage", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local str_percentage = ability:GetLevelSpecialValueFor("str_percentage", ability_level)
	local target_pos = target:GetAbsOrigin()
	local caster_str = caster:GetStrength()

	-- Check for Linkens
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return
		end
	end
	
	-- Draw the particle
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin())

	-- Calculate bonus damage
	damage = damage + caster_str * str_percentage / 100

	-- Find enemies to deal damage to
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end

	-- Apply the deny prevention modifier before dealing self damage
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Deal the self damage
	ApplyDamage({victim = caster, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Remove the deny prevention modifier
	caster:RemoveModifierByName(modifier_caster)
end

function Return( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_prevent = keys.modifier_prevent
	local particle_return = keys.particle_return

	-- If the ability is disabled by Break, do nothing
	if ability_level < 0 then
		return nil
	end

	-- Parameters
	local str_percentage = ability:GetLevelSpecialValueFor("strength_pct", ability_level)
	local duration = ability:GetLevelSpecialValueFor("cooldown", ability_level)

	-- Calculate return damage
	local caster_str = caster:GetStrength()
	local damage = caster_str * str_percentage / 100 * 300 / (caster_str + 300)

	-- Damage attacker if it hasn't taken return damage in the last second
	if not attacker:HasModifier(modifier_prevent) then

		-- Apply "damaged by return" modifier to the attacker
		ability:ApplyDataDrivenModifier(caster, attacker, modifier_prevent, {duration = duration})

		-- Deal damage
		ApplyDamage({victim = attacker, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })

		-- Play particle
		local return_pfx = ParticleManager:CreateParticle(particle_return, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(return_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(return_pfx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
	end
end

-- Emits the global sound and initializes a table to keep track of the units hit
function StampedeStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stampede = keys.modifier_stampede
	local modifier_scepter = keys.modifier_scepter
	local scepter = HasScepter(caster)

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	if scepter then
		duration = ability:GetLevelSpecialValueFor("duration_scepter", ability_level)
	end

	-- Initialize the hit table
	if caster.stampede_targets_hit then
		caster.stampede_targets_hit = nil
	end

	caster.stampede_targets_hit = {}

	-- Apply the modifier to all allied units
	local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do
		ability:ApplyDataDrivenModifier(caster, ally, modifier_stampede, {duration = duration})
		if scepter then
			ability:ApplyDataDrivenModifier(caster, ally, modifier_scepter, {duration = duration})
		end
	end
	
	-- Plays the global sound
	caster:EmitSound("Hero_Centaur.Stampede.Cast")
	EmitGlobalSound("Hero_Centaur.Stampede.Cast")
end

function Stampede( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_impact = keys.sound_impact

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local str_percentage = ability:GetLevelSpecialValueFor("strength_damage", ability_level)

	-- Damage calculation
	local damage = caster:GetStrength() * str_percentage / 100
	
	-- Check if the target was already hit by this cast of Stampede
	local hit = false
	for _, unit in pairs(caster.stampede_targets_hit) do
		if unit == target then
			hit = true
		end
	end

	-- If not, hit the target with Stampede
	if not hit then

		-- Damage
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- Stun
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})

		-- Play sound
		target:EmitSound(sound_impact)

		-- Add to hit table
		table.insert(caster.stampede_targets_hit, target)
	end
end