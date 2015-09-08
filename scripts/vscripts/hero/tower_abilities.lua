--[[	Author: Firetoad
		Date: 06.09.2015	]]

function LaserProjectile( keys )
	local caster = keys.caster
	local projectile_laser = keys.projectile_laser

	caster:SetRangedProjectileName(projectile_laser)
end

function LaserHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local laser_damage = ability:GetLevelSpecialValueFor("laser_damage", ability_level)

	-- Calculate damage
	local tower_damage = RandomInt(caster:GetBaseDamageMin(), caster:GetBaseDamageMax())
	local damage = tower_damage * laser_damage / 100

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
end

function Multishot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local tower_range = caster:GetAttackRange() + 128

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, tower_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	-- Attack each nearby enemy once
	for _,enemy in pairs(enemies) do
		if enemy ~= target then
			caster:PerformAttack(enemy, true, false, true, true)
		end
	end
end

function HexAura( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow = keys.modifier_slow

	-- Parameters
	local hex_duration = ability:GetLevelSpecialValueFor("hex_duration", ability_level)
	local tower_range = caster:GetAttackRange() + 128

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, tower_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	-- Single out one enemy from the group
	local chosen_enemy = enemies[RandomInt(1, #enemies)]

	-- Choose a random hero to be the modifier owner (having a non-hero hex modifier owner crashes the game)
	local hero = HeroList:GetHero(0)

	-- Hex the chosen enemy
	if chosen_enemy then
		if chosen_enemy:IsIllusion() then
			chosen_enemy:ForceKill(true)
		else
			chosen_enemy:AddNewModifier(hero, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
			ability:ApplyDataDrivenModifier(caster, chosen_enemy, modifier_slow, {})
		end
	end
end

function ManaBurn( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_burn = keys.particle_burn
	local sound_burn = keys.sound_burn

	-- If the target has no mana, do nothing
	if target:GetMaxMana() <= 0 then
		return nil
	end

	-- Parameters
	local mana_burn_pct = ability:GetLevelSpecialValueFor("mana_burn", ability_level)

	-- Calculate mana to burn
	local mana_to_burn = caster:GetAttackDamage() * mana_burn_pct / 100

	-- Burn mana
	target:ReduceMana(mana_to_burn)

	-- Play sound
	target:EmitSound(sound_burn)

	-- Play mana burn particle
	local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(mana_burn_pfx, 0, target:GetAbsOrigin())
end

function ManaFlare( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_burn = keys.particle_burn
	local sound_burn = keys.sound_burn

	-- Parameters
	local mana_burn_pct = ability:GetLevelSpecialValueFor("burn_pct", ability_level)
	local tower_range = caster:GetAttackRange() + 128

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, tower_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)

	-- Play sound if there are valid enemies to mana burn
	if #enemies > 0 then
		caster:EmitSound(sound_burn)	
	end

	-- Iterate through targets
	for _,enemy in pairs(enemies) do
		
		-- Burn mana
		local mana_to_burn = enemy:GetMaxMana() * mana_burn_pct / 100
		enemy:ReduceMana(mana_to_burn)

		-- Play mana burn particle
		local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(mana_burn_pfx, 0, enemy:GetAbsOrigin())
	end
end

function Permabash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_bash = keys.sound_bash
	local modifier_bash = keys.modifier_bash

	-- Parameters
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)

	-- Play sound
	target:EmitSound(sound_bash)

	-- Apply bash modifiers
	ability:ApplyDataDrivenModifier(caster, target, modifier_bash, {})
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})
end

function GrievousWounds( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_debuff = keys.modifier_debuff
	local particle_hit = keys.particle_hit

	-- Parameters
	local damage_increase = ability:GetLevelSpecialValueFor("damage_increase", ability_level)

	-- Play hit particle
	local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())

	-- Calculate bonus damage
	local base_damage = caster:GetAttackDamage()
	local current_stacks = target:GetModifierStackCount(modifier_debuff, caster)
	local total_damage = base_damage * ( 1 + current_stacks * damage_increase / 100 )

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_PHYSICAL})

	-- Apply bonus damage modifier
	AddStacks(ability, caster, target, modifier_debuff, 1, true)
end

function EssenceDrain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_str = keys.modifier_str
	local modifier_agi = keys.modifier_agi
	local modifier_int = keys.modifier_int

	-- If the target is not a hero, do nothing
	if not target:IsHero() then
		return nil
	end

	-- Parameters
	local drain_per_hit = ability:GetLevelSpecialValueFor("drain_per_hit", ability_level)

	-- Fetch target's current attributes
	local target_str = target:GetStrength()
	local target_agi = target:GetAgility()
	local target_int = target:GetIntellect()

	-- Reduce Strength to a minimum of 1 (prevents making the target a "zombie" for the rest of the match)
	if target_str > drain_per_hit then
		AddStacks(ability, caster, target, modifier_str, drain_per_hit, true)
	else
		AddStacks(ability, caster, target, modifier_str, target_str - 1, true)
	end

	-- Reduce Intelligence to a minimum of 1 (prevents making the target manaless for the rest of the match)
	if target_int > drain_per_hit then
		AddStacks(ability, caster, target, modifier_int, drain_per_hit, true)
	else
		AddStacks(ability, caster, target, modifier_int, target_int - 1, true)
	end

	-- Reduce Agility (no minimum value)
	AddStacks(ability, caster, target, modifier_agi, drain_per_hit, true)

	-- Update the target's stats
	target:CalculateStatBonus()
end

function Fervor( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_fervor = keys.modifier_fervor

	-- Parameters
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Fetch current stack amount
	local current_stacks = caster:GetModifierStackCount(modifier_fervor, caster)

	-- Increase stacks if below the maximum amount
	if current_stacks < max_stacks then
		AddStacks(ability, caster, caster, modifier_fervor, 1, true)
	else
		AddStacks(ability, caster, caster, modifier_fervor, 0, true)
	end
end

function Berserk( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_berserk = keys.modifier_berserk

	-- Parameters
	local hp_per_stack = ability:GetLevelSpecialValueFor("hp_per_stack", ability_level)

	-- Calculate proper amount of stacks
	local current_hp_pct = caster:GetHealth() / caster:GetMaxHealth()
	local current_stacks = math.floor( ( 1 - current_hp_pct ) * 100 / hp_per_stack )

	-- Update stack amount
	caster:RemoveModifierByName(modifier_berserk)
	AddStacks(ability, caster, caster, modifier_berserk, current_stacks, true)
end

function Multihit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local bonus_attacks = ability:GetLevelSpecialValueFor("bonus_attacks", ability_level)
	local delay = ability:GetLevelSpecialValueFor("delay", ability_level)

	-- Perform bonus attacks
	for i = 1, bonus_attacks do
		Timers:CreateTimer(delay * i, function()
			caster:PerformAttack(target, true, false, true, true)
		end)
	end
end