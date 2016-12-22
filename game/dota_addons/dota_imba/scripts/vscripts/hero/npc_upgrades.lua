--[[	Author: Firetoad
		Date: 16.08.2015	]]

function WarVeteranUpdater( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stacks = keys.modifier_stacks

	-- Adjust this hero's War Veteran stack amount
	if caster:GetLevel() > 25 then
		local correct_stacks = math.max(caster:GetLevel() - 25, 0)
		caster:SetModifierStackCount(modifier_stacks, caster, correct_stacks)
	end
end

function CreepUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_damage = keys.modifier_damage
	local modifier_armor = keys.modifier_armor
	local modifier_magic_resist = keys.modifier_magic_resist

	-- Parameters
	local game_time = GameRules:GetDOTATime(false, false) * CREEP_POWER_FACTOR / 60
	local magic_armor_per_minute = ability:GetLevelSpecialValueFor("mega_magic_armor_per_minute", ability_level)

	-- Adjust creep damage
	AddStacks(ability, caster, caster, modifier_damage, game_time, true)

	-- Adjust mega creep armor
	if string.find(caster:GetUnitName(), "mega") then
		AddStacks(ability, caster, caster, modifier_armor, math.max(game_time - 12, 0), true)
		AddStacks(ability, caster, caster, modifier_magic_resist, math.floor(100 - 100 * (1 - magic_armor_per_minute / 100) ^ math.max(game_time - 12, 0)), true)
	end
end

function TowerUpgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_buffs = keys.modifier_buffs

	-- Parameters
	local base_health_per_tier = ability:GetLevelSpecialValueFor("base_health_per_tier", ability_level) * TOWER_POWER_FACTOR

	-- Calculate tower tier
	local tower_tier_multiplier = 0
	if string.find(caster:GetUnitName(), "tower1") then
		return nil
	elseif string.find(caster:GetUnitName(), "tower2") then
		tower_tier_multiplier = 1
	elseif string.find(caster:GetUnitName(), "tower3") then
		tower_tier_multiplier = 2
	elseif string.find(caster:GetUnitName(), "tower4") then
		tower_tier_multiplier = 2
	end

	-- Adjust health
	SetCreatureHealth(caster, caster:GetMaxHealth() + base_health_per_tier * tower_tier_multiplier, true)

	-- Adjust damage/armor/attack speed
	AddStacks(ability, caster, caster, modifier_buffs, tower_tier_multiplier * TOWER_POWER_FACTOR, true)
end

function FountainThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particle_danger = keys.particle_danger

	local danger_pfx = ParticleManager:CreateParticle(particle_danger, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(danger_pfx, 0, caster:GetAbsOrigin())

	-- If mega creeps are nearby on arena mode, disable fountain protection
	if END_GAME_ON_KILLS and not caster.fountain_disabled then
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for	_,enemy in pairs(enemy_creeps) do
			if enemy:GetTeam() ~= caster:GetTeam() and string.find(enemy:GetUnitName(), "mega") then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_imba_fountain_disabled", {})
				caster.fountain_disabled = true
			end
		end
	end
end

function FountainBash( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_bash = keys.particle_bash
	local sound_bash = keys.sound_bash

	-- Parameters
	local bash_radius = ability:GetLevelSpecialValueFor("bash_radius", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)
	local bash_distance = ability:GetLevelSpecialValueFor("bash_distance", ability_level)
	local bash_height = ability:GetLevelSpecialValueFor("bash_height", ability_level)
	local fountain_loc = caster:GetAbsOrigin()

	-- Knockback table
	local fountain_bash =	{
		should_stun = 1,
		knockback_duration = bash_duration,
		duration = bash_duration,
		knockback_distance = bash_distance,
		knockback_height = bash_height,
		center_x = fountain_loc.x,
		center_y = fountain_loc.y,
		center_z = fountain_loc.z
	}

	-- Find units to bash
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), fountain_loc, nil, bash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Bash all of them
	for _,enemy in pairs(nearby_enemies) do

		-- Bash
		enemy:RemoveModifierByName("modifier_knockback")
		enemy:AddNewModifier(caster, ability, "modifier_knockback", fountain_bash)

		-- Play particle
		local bash_pfx = ParticleManager:CreateParticle(particle_bash, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(bash_pfx, 0, enemy:GetAbsOrigin())

		-- Play sound
		enemy:EmitSound(sound_bash)
	end
end

function NecrowarriorTrample( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_hit = keys.sound_hit
	local particle_hit = keys.particle_hit
	local modifier_dummy = keys.modifier_dummy

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local direction = (target - caster_loc):Normalized()
	local distance = (target - caster_loc):Length2D()

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play animation
	StartAnimation(caster, {activity = ACT_DOTA_ATTACK, rate = 1.2})

	-- Movement parameters
	local current_distance = 0
	local tick_rate = 0.03
	local distance_tick = direction * speed * tick_rate

	-- Move the caster
	Timers:CreateTimer(0, function()
		caster:SetAbsOrigin(caster:GetAbsOrigin() + distance_tick)
		current_distance = current_distance + speed * tick_rate
		
		-- If the movement has ended, find a legal position and exit
		if current_distance >= distance then
			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

		-- Else, keep moving
		else

			-- Destroy trees
			GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), 175, false)

			-- Iterate through nearby enemies
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(nearby_enemies) do
				if not enemy:HasModifier(modifier_dummy) then
					
					-- Apply the multiple-hit-prevention modifier
					ability:ApplyDataDrivenModifier(caster, enemy, modifier_dummy, {})

					-- Play hit sound
					enemy:EmitSound(sound_hit)

					-- Play hit particle
					local trample_hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, enemy)
					ParticleManager:SetParticleControl(trample_hit_pfx, 0, enemy:GetAbsOrigin())

					-- Deal damage
					ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				end
			end

			-- Keep moving
			return tick_rate
		end
	end)
end

function NecrowarriorBlazeSpikes( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_hit = keys.particle_hit
	local sound_hit = keys.sound_hit

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Play sound
	target:EmitSound(sound_hit)

	-- Play particle
	local blaze_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(blaze_pfx, 0, target:GetAbsOrigin())

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end