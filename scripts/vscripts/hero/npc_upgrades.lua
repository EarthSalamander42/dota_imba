--[[	Author: Firetoad
		Date: 16.08.2015	]]

function Upgrade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack

	-- Calculate total buff stacks
	local total_stacks = GAME_TIME_ELAPSED / 60

	-- Increase amount of stacks according to game speed
	total_stacks = total_stacks * CREEP_POWER_RAMP_UP_FACTOR

	-- Cap the stacks
	total_stacks = math.min(total_stacks, CREEP_POWER_MAX_UPGRADES)

	-- Update the stacks buff
	caster:RemoveModifierByName(modifier_stack)
	AddStacks(ability, caster, caster, modifier_stack, total_stacks, true)
end

function AncientHealth( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local health = ability:GetLevelSpecialValueFor("ancient_health", 0)

	-- Update health
	SetCreatureHealth(caster, health, true)
end

function AncientThink( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- If the game is set to end on kills, make the ancient invulnerable
	if END_GAME_ON_KILLS then

		-- Make the ancient invulnerable
		caster:AddNewModifier(caster, ability, "modifier_invulnerable", {})

		-- Kill any nearby creeps (prevents lag)
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemy_creeps) do
			enemy:Kill(ability, caster)
		end
		return nil
	end

	-- Parameters
	local ancient_health = caster:GetHealth() / caster:GetMaxHealth()

	-- Search for nearby units
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- If there are no nearby enemies, do nothing
	if #enemies == 0 then
		return nil
	end
	
	-- Ancient abilities logic
	local ability_ravage = caster:FindAbilityByName("tidehunter_ravage")
	local ability_eye_of_the_storm = caster:FindAbilityByName("razor_eye_of_the_storm")
	local ability_borrowed_time = caster:FindAbilityByName("abaddon_borrowed_time")
	local ability_poison_nova = caster:FindAbilityByName("venomancer_poison_nova")
	local ability_overgrowth = caster:FindAbilityByName("treant_overgrowth")

	-- If health < 20%, refresh abilities once
	if ancient_health < 0.20 and IMBA_PLAYERS_ON_GAME == 20 and not caster.abilities_refreshed then
		ability_ravage:EndCooldown()
		ability_borrowed_time:EndCooldown()
		caster.abilities_refreshed = true
	end

	-- If health < 30%, use Ravage
	if ancient_health < 0.3 and ability_ravage and ability_ravage:IsCooldownReady() then
		ability_eye_of_the_storm:EndCooldown()
		ability_ravage:OnSpellStart()
		ability_ravage:StartCooldown(ability_ravage:GetCooldown(1))
		return nil
	end

	-- If health < 40%, use Borrowed Time
	if ancient_health < 0.4 and ability_borrowed_time and ability_borrowed_time:IsCooldownReady() then
		ability_eye_of_the_storm:EndCooldown()
		ability_borrowed_time:OnSpellStart()
		ability_borrowed_time:StartCooldown(ability_borrowed_time:GetCooldown(1))
	end

	-- If health < 60%, use Eye of the Storm
	if ancient_health < 0.6 and ability_eye_of_the_storm and ability_eye_of_the_storm:IsCooldownReady() then
		ability_poison_nova:EndCooldown()
		ability_eye_of_the_storm:OnSpellStart()
		ability_eye_of_the_storm:StartCooldown(ability_eye_of_the_storm:GetCooldown(1))
		return nil
	end

	-- If health < 80%, use Overgrowth
	if ancient_health < 0.8 and ability_overgrowth and ability_overgrowth:IsCooldownReady() then
		ability_overgrowth:OnSpellStart()
		ability_overgrowth:StartCooldown(ability_overgrowth:GetCooldown(1))
		return nil
	end

	-- If health < 100%, use Poison Nova
	if ancient_health < 1.0 and ability_poison_nova and ability_poison_nova:IsCooldownReady() then
		ability_poison_nova:OnSpellStart()
		ability_poison_nova:StartCooldown(ability_poison_nova:GetCooldown(1))
		return nil
	end
end

function AncientAttacked( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local ancient_health = caster:GetHealth() / caster:GetMaxHealth()
	
	-- Ancient abilities logic
	local ability_ravage = caster:FindAbilityByName("tidehunter_ravage")
	local ability_eye_of_the_storm = caster:FindAbilityByName("razor_eye_of_the_storm")
	local ability_borrowed_time = caster:FindAbilityByName("abaddon_borrowed_time")
	local ability_poison_nova = caster:FindAbilityByName("venomancer_poison_nova")
	local ability_overgrowth = caster:FindAbilityByName("treant_overgrowth")

	-- If health < 20%, refresh abilities once
	if ancient_health < 0.20 and not caster.abilities_refreshed then
		ability_ravage:EndCooldown()
		ability_borrowed_time:EndCooldown()
		caster.abilities_refreshed = true
	end

	-- If health < 30%, use Ravage
	if ancient_health < 0.3 and ability_ravage and ability_ravage:IsCooldownReady() then
		ability_eye_of_the_storm:EndCooldown()
		ability_ravage:OnSpellStart()
		ability_ravage:StartCooldown(ability_ravage:GetCooldown(1))
		return nil
	end

	-- If health < 40%, use Borrowed Time
	if ancient_health < 0.4 and ability_borrowed_time and ability_borrowed_time:IsCooldownReady() then
		ability_eye_of_the_storm:EndCooldown()
		ability_borrowed_time:OnSpellStart()
		ability_borrowed_time:StartCooldown(ability_borrowed_time:GetCooldown(1))
	end

	-- If health < 60%, use Eye of the Storm
	if ancient_health < 0.6 and ability_eye_of_the_storm and ability_eye_of_the_storm:IsCooldownReady() then
		ability_poison_nova:EndCooldown()
		ability_eye_of_the_storm:OnSpellStart()
		ability_eye_of_the_storm:StartCooldown(ability_eye_of_the_storm:GetCooldown(1))
		return nil
	end

	-- If health < 80%, use Overgrowth
	if ancient_health < 0.8 and ability_overgrowth and ability_overgrowth:IsCooldownReady() then
		ability_overgrowth:OnSpellStart()
		ability_overgrowth:StartCooldown(ability_overgrowth:GetCooldown(1))
		return nil
	end

	-- If health < 100%, use Poison Nova
	if ancient_health < 1.0 and ability_poison_nova and ability_poison_nova:IsCooldownReady() then
		ability_poison_nova:OnSpellStart()
		ability_poison_nova:StartCooldown(ability_poison_nova:GetCooldown(1))
		return nil
	end
end

function CreepStructureDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local building_damage = ability:GetLevelSpecialValueFor("structure_damage_per_minute", ability_level)
	local hero_damage = ability:GetLevelSpecialValueFor("hero_damage_per_minute", ability_level)
	local game_time = math.min( GAME_TIME_ELAPSED / 60, CREEP_POWER_MAX_UPGRADES)

	-- Deal bonus damage
	if target:IsBuilding() or target:IsTower() then
		local bonus_damage = caster:GetAttackDamage() * building_damage * game_time / 100
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	elseif target:IsHero() then
		local bonus_damage = caster:GetAttackDamage() * hero_damage * game_time / 100
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function FountainThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particle_danger = keys.particle_danger

	local danger_pfx = ParticleManager:CreateParticle(particle_danger, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(danger_pfx, 0, caster:GetAbsOrigin())

	-- If mega creeps are nearby on arena mode, disable fountain protection
	if END_GAME_ON_KILLS and not caster.fountain_disabled then
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 20000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for	_,enemy in pairs(enemy_creeps) do
			if enemy:GetTeam() ~= caster:GetTeam() and (enemy:GetUnitName() == "npc_dota_creep_goodguys_melee_upgraded_mega" or enemy:GetUnitName() == "npc_dota_creep_badguys_melee_upgraded_mega") then
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
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), fountain_loc, nil, bash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

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

function Frantic( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_cd = keys.modifier_cd
	local modifier_mana = keys.modifier_mana

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_cd)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local cd_stacks = 100 - math.floor( 100 / FRANTIC_MULTIPLIER )
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_cd, cd_stacks, true)
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
end

function FranticUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_mana = keys.modifier_mana
	local modifier_dummy = keys.modifier_dummy

	-- Remove any pre-existing frantic modifiers
	caster:RemoveModifierByName(modifier_dummy)
	caster:RemoveModifierByName(modifier_mana)

	-- Calculate amount of stacks to add
	local mana_stacks = caster:GetMaxMana() * ( FRANTIC_MULTIPLIER - 1 )

	-- Apply stacks
	AddStacks(ability, caster, caster, modifier_mana, mana_stacks, true)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
end