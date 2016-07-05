--[[	Author: Firetoad
		Date: 06.09.2015	]]

function Laser( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local projectile_laser = keys.projectile_laser
	local sound_impact = keys.sound_impact

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local blind_aoe = ability:GetLevelSpecialValueFor("blind_aoe", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, blind_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, blind_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Emit sound
		caster:EmitSound(sound_impact)

		-- Create projectile
		local laser_projectile = {
			Target = "",
			Source = caster,
			Ability = ability,
			EffectName = projectile_laser,
			bDodgeable = true,
			bProvidesVision = false,
			iMoveSpeed = projectile_speed,
		--	iVisionRadius = vision_radius,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

		-- Launch projectiles
		for _,enemy in pairs(creeps) do
			laser_projectile.Target = enemy
			ProjectileManager:CreateTrackingProjectile(laser_projectile)
		end
		for _,enemy in pairs(heroes) do
			laser_projectile.Target = enemy
			ProjectileManager:CreateTrackingProjectile(laser_projectile)
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function LaserHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_blind = keys.modifier_blind
	local particle_blind = keys.particle_blind
	local sound_impact = keys.sound_impact

	-- Play sound
	target:EmitSound(sound_impact)

	-- Play hit particle
	local laser_pfx = ParticleManager:CreateParticle(particle_blind, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(laser_pfx, 1, target:GetAbsOrigin())

	-- Apply blind modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_blind, {})
end

function Multishot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- Parameters
	local tower_range = caster:GetAttackRange() + 128

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, tower_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	-- Attack each nearby enemy once
	for _,enemy in pairs(enemies) do
		if enemy ~= target then
			caster:PerformAttack(enemy, true, true, true, true, true)
		end
	end
end

function HexAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_slow = keys.modifier_slow

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local hex_aoe = ability:GetLevelSpecialValueFor("hex_aoe", ability_level)
	local hex_duration = ability:GetLevelSpecialValueFor("hex_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, hex_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Choose a random hero to be the modifier owner (having a non-hero hex modifier owner crashes the game)
		local hero_owner = HeroList:GetHero(0)

		-- Hex enemies
		for _,enemy in pairs(creeps) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end
		for _,enemy in pairs(heroes) do
			if enemy:IsIllusion() then
				enemy:ForceKill(true)
			else
				enemy:AddNewModifier(hero_owner, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_slow, {})
			end
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
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
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_burn = keys.particle_burn
	local sound_burn = keys.sound_burn

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local burn_aoe = ability:GetLevelSpecialValueFor("burn_aoe", ability_level)
	local burn_pct = ability:GetLevelSpecialValueFor("burn_pct", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, burn_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_burn)

		-- Iterate through enemies
		for _,enemy in pairs(heroes) do
			
			-- Burn mana
			local mana_to_burn = enemy:GetMaxMana() * burn_pct / 100
			enemy:ReduceMana(mana_to_burn)

			-- Play mana burn particle
			local mana_burn_pfx = ParticleManager:CreateParticle(particle_burn, PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(mana_burn_pfx, 0, enemy:GetAbsOrigin())
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Permabash( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_bash = keys.sound_bash
	local modifier_bash = keys.modifier_bash

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local bash_damage = ability:GetLevelSpecialValueFor("bash_damage", ability_level)
	local bash_duration = ability:GetLevelSpecialValueFor("bash_duration", ability_level)

	-- Play sound
	target:EmitSound(sound_bash)

	-- Apply bash modifiers
	ability:ApplyDataDrivenModifier(caster, target, modifier_bash, {})
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = bash_duration})

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bash_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Put the ability on cooldown
	ability:StartCooldown(ability:GetCooldown(ability_level))
end

function Chronotower( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_stun = keys.sound_stun
	local modifier_stun = keys.modifier_stun

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_stun)

		-- Stun enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_stun, {})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
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
	local modifier_stacks = keys.modifier_stacks

	-- Parameters
	local drain_per_hit = ability:GetLevelSpecialValueFor("drain_per_hit", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local available_stacks = math.max(max_stacks - caster:GetModifierStackCount(modifier_stacks, caster), 0)

	-- If the target is not a hero, apply one time and exit
	if not target:IsHero() then
		AddStacks(ability, caster, caster, modifier_stacks, math.min(1, available_stacks), true)
		return nil
	end

	-- Grant the tower its bonuses
	AddStacks(ability, caster, caster, modifier_stacks, math.min(drain_per_hit, available_stacks), true)

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

function EssenceDrainStackUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_dummy = keys.modifier_dummy

	-- Increase dummy modifier stack count
	AddStacks(ability, caster, caster, modifier_dummy, 1, true)
end

function EssenceDrainStackDown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_dummy = keys.modifier_dummy

	-- If this is the last stack, remove the modifier
	if caster:GetModifierStackCount(modifier_dummy, caster) <= 1 then
		caster:RemoveModifierByName(modifier_dummy)

	-- Else, reduce stack count by one
	else
		AddStacks(ability, caster, caster, modifier_dummy, -1, false)
	end
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
			caster:PerformAttack(target, true, true, true, true, true)
		end)
	end
end

function PlagueParticle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_plague = keys.particle_plague

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("area_of_effect", ability_level)

	-- Play particle
	plague_pfx = ParticleManager:CreateParticle(particle_plague, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(plague_pfx, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl(plague_pfx, 1, Vector(radius,0,0) )
end

function AegisUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Parameters
	local bonus_health = ability:GetLevelSpecialValueFor("bonus_health", 0)

	-- Update health
	caster:SetBaseMaxHealth(caster:GetBaseMaxHealth() + bonus_health)
	caster:SetMaxHealth(caster:GetMaxHealth() + bonus_health)
	caster:SetHealth(caster:GetHealth() + bonus_health)
end

function SelfRepair( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_regen = keys.modifier_regen

	-- If the ability is level 3, do nothing
	if ability_level == 2 then
		return nil
	end

	-- Parameters
	local regen_delay = ability:GetLevelSpecialValueFor("regen_delay", ability_level)
	
	-- Remove this modifier
	caster:RemoveModifierByName(modifier_regen)

	-- Destroy particle
	ParticleManager:DestroyParticle(caster.self_regen_pfx, false)

	-- Apply this modifier again after [regen_delay]
	Timers:CreateTimer(regen_delay, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_regen, {})
	end)
end

function SelfRepairParticle( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_regen = keys.particle_regen

	-- Create particle
	caster.self_regen_pfx = ParticleManager:CreateParticle(particle_regen, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(caster.self_regen_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(caster.self_regen_pfx, 1, caster:GetAbsOrigin())
end

function Spacecow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_creep = keys.sound_creep
	local sound_hero = keys.sound_hero

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local knockback_damage = ability:GetLevelSpecialValueFor("knockback_damage", ability_level)
	local knockback_distance = ability:GetLevelSpecialValueFor("knockback_distance", ability_level)
	local knockback_duration = ability:GetLevelSpecialValueFor("knockback_duration", ability_level)
	local knockback_origin = caster:GetAbsOrigin()

	-- Play appropriate sound
	if target:IsHero() then
		target:EmitSound(sound_hero)
	else
		target:EmitSound(sound_creep)
	end

	-- Knockback target
	local knockback_param =
	{	should_stun = 1,
		knockback_duration = knockback_duration,
		duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_distance / 4,
		center_x = knockback_origin.x,
		center_y = knockback_origin.y,
		center_z = knockback_origin.z
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = knockback_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Put the ability on cooldown
	ability:StartCooldown(ability:GetCooldown(ability_level))
end

function Reality( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_reality = keys.sound_reality

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local reality_aoe = ability:GetLevelSpecialValueFor("reality_aoe", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Kill any existing illusions
	local ability_used = false
	for _,enemy in pairs(heroes) do
		if enemy:IsIllusion() then
			enemy:ForceKill(true)
			ability_used = true
		end
	end

	-- If the ability was used, play the sound and put it on cooldown
	if ability_used then

		-- Play sound
		caster:EmitSound(sound_reality)

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Force( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_force = keys.sound_force

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local force_aoe = ability:GetLevelSpecialValueFor("force_aoe", ability_level)
	local force_distance = ability:GetLevelSpecialValueFor("force_distance", ability_level)
	local force_duration = ability:GetLevelSpecialValueFor("force_duration", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, force_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_force)

		-- Set up knockback parameters
		local knockback_param =
		{	should_stun = 1,
			knockback_duration = force_duration,
			duration = force_duration,
			knockback_distance = force_distance,
			knockback_height = 0,
			center_x = tower_loc.x,
			center_y = tower_loc.y,
			center_z = tower_loc.z
		}

		-- Knockback enemies
		for _,enemy in pairs(creeps) do
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)
		end
		for _,enemy in pairs(heroes) do
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Nature( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_root = keys.sound_root
	local modifier_root = keys.modifier_root

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local root_radius = ability:GetLevelSpecialValueFor("root_radius", ability_level)
	local min_creeps = ability:GetLevelSpecialValueFor("min_creeps", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local creeps = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, root_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #creeps >= min_creeps or #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_root)

		-- Root enemies
		for _,enemy in pairs(creeps) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_root, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Mindblast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_silence = keys.sound_silence
	local modifier_silence = keys.modifier_silence

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local silence_radius = ability:GetLevelSpecialValueFor("silence_radius", ability_level)
	local tower_loc = caster:GetAbsOrigin()

	-- Find nearby enemies
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), tower_loc, nil, silence_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

	-- Check if the ability should be cast
	if #heroes >= 1 then

		-- Play sound
		caster:EmitSound(sound_silence)

		-- Silence enemies
		for _,enemy in pairs(heroes) do
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_silence, {})
		end

		-- Put the ability on cooldown
		ability:StartCooldown(ability:GetCooldown(ability_level))
	end
end

function Forest( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_tree = keys.sound_tree

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local tree_radius = ability:GetLevelSpecialValueFor("tree_radius", ability_level)
	local tree_duration = ability:GetLevelSpecialValueFor("tree_duration", ability_level)

	-- Play sound
	caster:EmitSound(sound_tree)

	-- Create a tree on a random location
	local tree_loc = caster:GetAbsOrigin() + RandomVector(100):Normalized() * RandomInt(100, tree_radius)
	CreateTempTree(tree_loc, tree_duration)

	-- Put the ability on cooldown
	ability:StartCooldown(ability:GetCooldown(ability_level))
end

function Glaives( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_creep = keys.sound_creep
	local sound_hero = keys.sound_hero

	-- If the ability is on cooldown, do nothing
	if not ability:IsCooldownReady() then
		return nil
	end

	-- Parameters
	local knockback_damage = ability:GetLevelSpecialValueFor("knockback_damage", ability_level)
	local knockback_distance = ability:GetLevelSpecialValueFor("knockback_distance", ability_level)
	local knockback_duration = ability:GetLevelSpecialValueFor("knockback_duration", ability_level)
	local knockback_origin = caster:GetAbsOrigin()

	-- Play appropriate sound
	if target:IsHero() then
		target:EmitSound(sound_hero)
	else
		target:EmitSound(sound_creep)
	end

	-- Knockback target
	local knockback_param =
	{	should_stun = 1,
		knockback_duration = knockback_duration,
		duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_distance / 4,
		center_x = knockback_origin.x,
		center_y = knockback_origin.y,
		center_z = knockback_origin.z
	}
	target:RemoveModifierByName("modifier_knockback")
	target:AddNewModifier(caster, nil, "modifier_knockback", knockback_param)

	-- Deal damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = knockback_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Put the ability on cooldown
	ability:StartCooldown(ability:GetCooldown(ability_level))
end

function Split( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- Parameters
	local split_chance = ability:GetLevelSpecialValueFor("split_chance", ability_level)
	local split_radius = ability:GetLevelSpecialValueFor("split_radius", ability_level)
	local split_amount = ability:GetLevelSpecialValueFor("split_amount", ability_level)
	local target_pos = target:GetAbsOrigin()
	
	-- Roll for splinter chance
	if RandomInt(1, 100) <= split_chance then

		-- Choose the correct particle for this tower
		local attack_projectile = ""
		if caster:GetTeam() == DOTA_TEAM_BADGUYS then
			attack_projectile = "particles/base_attacks/ranged_tower_bad.vpcf"
		elseif caster:GetTeam() == DOTA_TEAM_GOODGUYS then
			attack_projectile = "particles/base_attacks/ranged_tower_good.vpcf"
		end

		-- Find enemies near the target
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, split_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #nearby_enemies > 1 then

			-- Initialize the target table
			local split_targets = {}

			-- Add enemies to the target table until it's full
			for _,enemy in pairs(nearby_enemies) do
				
				-- Do not add the original target
				if enemy ~= target then
					split_targets[#split_targets + 1] = enemy

					-- If the target table is full, stop looking for more
					if #split_targets >= split_amount then
						break
					end
				end
			end

			-- Split projectile base parameters
			local split_projectile = {
				Target = "",
				Source = target,
				Ability = ability,
				EffectName = attack_projectile,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = 750,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			-- Create the projectiles
			for _,split_target in pairs(split_targets) do
				split_projectile.Target = split_target
				ProjectileManager:CreateTrackingProjectile(split_projectile)
			end
		end
	end
end

function SplitHit( keys )
	local caster = keys.caster
	local target = keys.target

	caster:PerformAttack(target, true, true, true, true, false)
end

function Cannon( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_explosion = keys.particle_explosion

	-- Parameters
	local salvo_aoe = ability:GetLevelSpecialValueFor("salvo_aoe", ability_level)
	local salvo_dmg = ability:GetLevelSpecialValueFor("salvo_dmg", ability_level)
	local target_loc = target:GetAbsOrigin()

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, salvo_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

	-- Play particle
	target_loc = target_loc + Vector(0, 0, 100)
	local explosion_pfx = ParticleManager:CreateParticle(particle_explosion, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(explosion_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(explosion_pfx, 3, target_loc)

	-- Deal bonus damage to enemies
	for _,enemy in pairs(enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = salvo_dmg, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end