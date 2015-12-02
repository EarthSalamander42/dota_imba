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
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
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
	local tier_1_ability = caster:GetAbilityByIndex(2)
	local tier_2_ability = caster:GetAbilityByIndex(3)
	local tier_3_ability = caster:GetAbilityByIndex(4)
	local tier_4_ability = caster:GetAbilityByIndex(5)
	local tier_5_ability = caster:GetAbilityByIndex(6)

	-- If health < 20%, refresh abilities once
	if (( ancient_health < 0.20 and IMBA_PLAYERS_ON_GAME == 20 ) and not caster.abilities_refreshed ) then
		tier_5_ability:EndCooldown()
		caster.abilities_refreshed = true
	end

	-- If health < 30%, use the tier 5 ability
	if ancient_health < 0.3 and tier_5_ability and tier_5_ability:IsCooldownReady() then
		tier_4_ability:EndCooldown()
		tier_5_ability:OnSpellStart()
		tier_5_ability:StartCooldown(tier_5_ability:GetCooldown(1))
		return nil
	end

	-- If health < 40%, use the tier 4 ability
	if ancient_health < 0.4 and tier_4_ability and tier_4_ability:IsCooldownReady() then
		tier_3_ability:EndCooldown()
		tier_4_ability:OnSpellStart()
		tier_4_ability:StartCooldown(tier_4_ability:GetCooldown(1))
	end

	-- If health < 60%, use the tier 3 ability
	if ancient_health < 0.6 and tier_3_ability and tier_3_ability:IsCooldownReady() then
		tier_2_ability:EndCooldown()
		tier_3_ability:OnSpellStart()
		tier_3_ability:StartCooldown(tier_3_ability:GetCooldown(1))
		return nil
	end

	-- If health < 80%, use the tier 2 ability
	if ancient_health < 0.8 and tier_2_ability and tier_2_ability:IsCooldownReady() then
		tier_1_ability:EndCooldown()
		tier_2_ability:OnSpellStart()
		tier_2_ability:StartCooldown(tier_2_ability:GetCooldown(1))
		return nil
	end

	-- If health < 100%, use the tier 1 ability
	if ancient_health < 1.0 and tier_1_ability and tier_1_ability:IsCooldownReady() then
		tier_1_ability:OnSpellStart()
		tier_1_ability:StartCooldown(tier_1_ability:GetCooldown(1))
		return nil
	end
end

function AncientAttacked( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local ancient_health = caster:GetHealth() / caster:GetMaxHealth()
	
	-- Ancient abilities logic
	local tier_1_ability = caster:GetAbilityByIndex(2)
	local tier_2_ability = caster:GetAbilityByIndex(3)
	local tier_3_ability = caster:GetAbilityByIndex(4)
	local tier_4_ability = caster:GetAbilityByIndex(5)
	local tier_5_ability = caster:GetAbilityByIndex(6)

	-- If health < 20%, refresh abilities once
	if (( ancient_health < 0.20 and IMBA_PLAYERS_ON_GAME == 20 ) and not caster.abilities_refreshed ) then
		tier_5_ability:EndCooldown()
		caster.abilities_refreshed = true
	end

	-- If health < 30%, use the tier 5 ability
	if ancient_health < 0.3 and tier_5_ability and tier_5_ability:IsCooldownReady() then
		tier_4_ability:EndCooldown()
		tier_5_ability:OnSpellStart()
		tier_5_ability:StartCooldown(tier_5_ability:GetCooldown(1))
		return nil
	end

	-- If health < 40%, use the tier 4 ability
	if ancient_health < 0.4 and tier_4_ability and tier_4_ability:IsCooldownReady() then
		tier_3_ability:EndCooldown()
		tier_4_ability:OnSpellStart()
		tier_4_ability:StartCooldown(tier_4_ability:GetCooldown(1))
	end

	-- If health < 60%, use the tier 3 ability
	if ancient_health < 0.6 and tier_3_ability and tier_3_ability:IsCooldownReady() then
		tier_2_ability:EndCooldown()
		tier_3_ability:OnSpellStart()
		tier_3_ability:StartCooldown(tier_3_ability:GetCooldown(1))
		return nil
	end

	-- If health < 80%, use the tier 2 ability
	if ancient_health < 0.8 and tier_2_ability and tier_2_ability:IsCooldownReady() then
		tier_1_ability:EndCooldown()
		tier_2_ability:OnSpellStart()
		tier_2_ability:StartCooldown(tier_2_ability:GetCooldown(1))
		return nil
	end

	-- If health < 100%, use the tier 1 ability
	if ancient_health < 1.0 and tier_1_ability and tier_1_ability:IsCooldownReady() then
		tier_1_ability:OnSpellStart()
		tier_1_ability:StartCooldown(tier_1_ability:GetCooldown(1))
		return nil
	end
end

function CreepArmor( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_armor = keys.modifier_armor

	-- Parameters
	local game_time = GAME_TIME_ELAPSED / 60

	-- Adjust mega creep armor
	if string.find(caster:GetUnitName(), "mega") then
		AddStacks(ability, caster, caster, modifier_armor, math.max(game_time - 13, 0), true)
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

	local danger_pfx = ParticleManager:CreateParticle(particle_danger, PATTACH_CUSTOMORIGIN, nil)
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