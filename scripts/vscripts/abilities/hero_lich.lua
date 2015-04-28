--[[ 	Author: D2imba
		Date: 25.04.2015	]]
		
function FrostNova( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local modifier_slow = keys.modifier_slow
	local particle = keys.particle
	local sound = keys.sound
	local ability_level = ability:GetLevel() - 1

	local stack_damage = ability:GetLevelSpecialValueFor("damage_per_stack", ability_level)
	local cast_chance = ability:GetLevelSpecialValueFor("chance_per_stack", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local aoe_damage = ability:GetLevelSpecialValueFor("aoe_damage", ability_level)
	local target_damage = ability:GetLevelSpecialValueFor("target_damage", ability_level)

	local target_pos = target:GetAbsOrigin()

	-- Adds a stack of the aura modifier
	AddStacks(ability, caster, target, modifier, 1, false)

	-- Deals damage according to the number of stacks
	local stack_count = target:GetModifierStackCount(modifier, ability)
	local damage = stack_damage * stack_count
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})

	-- Rolls for the chance of casting Frost Nova
	if RandomInt(1, 100) <= cast_chance * stack_count then
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false )
		for _,v in pairs(targets) do
			ApplyDamage({victim = v, attacker = caster, damage = aoe_damage, damage_type = ability:GetAbilityDamageType()})
			ability:ApplyDataDrivenModifier(caster, v, modifier_slow, {duration = ability:GetDuration()})
		end
		-- Casts the spell
		ApplyDamage({victim = target, attacker = caster, damage = target_damage, damage_type = ability:GetAbilityDamageType()})
		target:EmitSound(sound)
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function FrostArmorParticle( keys )
	local target = keys.target
	local location = target:GetAbsOrigin()
	local particle = keys.particle

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.frost_armor_particle = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.frost_armor_particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.frost_armor_particle, 1, Vector(1,0,0))

		ParticleManager:SetParticleControlEnt(target.frost_armor_particle, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndFrostArmorParticle( keys )
	local target = keys.target
	ParticleManager:DestroyParticle(target.frost_armor_particle,false)
end

function DarkRitual( keys )
	local caster = keys.caster
	local target = keys.target
	local heroes = keys.target_entities
	local ability = keys.ability

	-- Mana to give	
	local target_health = target:GetMaxHealth()
	local rate = ability:GetLevelSpecialValueFor("health_conversion", ability:GetLevel() - 1 ) * 0.01
	local mana_gain = target_health * rate

	-- XP to share
	local XP = target:GetDeathXP()
	local split_XP = XP / #heroes

	-- Grants the caster mana
	caster:GiveMana(mana_gain)

	-- If the caster's mana is full, grant the excess mana as healing
	local current_mana = caster:GetMana()
	local max_mana = caster:GetMana()
	if max_mana - current_mana < mana_gain then
		caster:Heal(mana_gain - (max_mana - current_mana), caster)
	end

	-- Purple particle with eye
	local particleName = "particles/msg_fx/msg_xp.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)

	local digits = 0
    if mana_gain ~= nil then
        digits = #tostring(mana_gain)
    end

	ParticleManager:SetParticleControl(particle, 1, Vector(9, mana_gain, 6))
    ParticleManager:SetParticleControl(particle, 2, Vector(1, digits+1, 0))
    ParticleManager:SetParticleControl(particle, 3, Vector(170, 0, 250))

    -- Kill the target, ForceKill doesn't grant xp
	target:ForceKill(true)

	for _,v in pairs(heroes) do
		v:AddExperience(split_XP, false, false)
	end
end

function ChainFrost( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	local target_pos = target:GetAbsOrigin()
	local bounce_target = target

	local jump_range = ability:GetLevelSpecialValueFor("jump_range", ability_level)
	local projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)

	if scepter then
		jump_range = ability:GetLevelSpecialValueFor("jump_range_scepter", ability_level)
		projectile_speed = ability:GetLevelSpecialValueFor("projectile_speed_scepter", ability_level)
	end

	local particle_name = keys.particle_name

	-- Emit the sound, Creep or Hero depending on the type of the enemy hit
	if target:IsRealHero() then
		target:EmitSound("Hero_Lich.ChainFrostImpact.Hero")
	else
		target:EmitSound("Hero_Lich.ChainFrostImpact.Creep")
	end

	-- Control variables for the next bounce
	local should_bounce = false
	local hero_bounce = false

	-- If valid targets are found, should_bounce is set to true, and the chain frost keeps going
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, jump_range, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, ability:GetAbilityTargetFlags(), FIND_CLOSEST, false )
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, jump_range, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false )

	for _,v in pairs(heroes) do
		if v ~= target then
			should_bounce = true
			hero_bounce = true
		end
	end

	for _,v in pairs(units) do
		if v ~= target then
			should_bounce = true
		end
	end

	-- If there's a target to bounce to, find it and jump
	if should_bounce then

		-- If it's a hero bounce, select the closest hero; if not, select any other valid unit
		if hero_bounce then
			bounce_target = heroes[1]
			if bounce_target == target then
				bounce_target = heroes[2]
			end
		else
			local random_unit = RandomInt(1, #units)
			bounce_target = units[random_unit]
		end

		-- Create the next projectile
		local info = {
			Target = bounce_target,
			Source = target,
			Ability = ability,
			EffectName = particle_name,
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = projectile_speed,
			iVisionRadius = vision_radius,
			iVisionTeamNumber = caster:GetTeamNumber(), -- Vision still belongs to the one that casted the ability
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile( info )
	end
end