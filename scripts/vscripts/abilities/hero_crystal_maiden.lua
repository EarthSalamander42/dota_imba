--[[ Author: Hewdraw ]]

function CrystalNova( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target_points[ 1 ]
	local effect_radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)
	local particle = keys.particle
	
	local good_aura_modifier = keys.good_aura_modifier
	local bad_aura_modifier = keys.bad_aura_modifier
	local scepter = caster:HasScepter()

	-- Creates flying vision area
	ability:CreateVisibilityNode(target, vision_radius, duration)

	-- Creates the particle
	local fxIndex = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, caster )
	local radiusVector = (Vector (effect_radius, 0, 0))

	ParticleManager:SetParticleControl(fxIndex, 0, target)
	ParticleManager:SetParticleControl(fxIndex, 1, radiusVector)
	ParticleManager:SetParticleControl(fxIndex, 5, radiusVector)

	-- Creates buffing/debuffing dummy (3000 units above ground to prevent camp blocking)
	local dummy = CreateUnitByName("npc_dummy_blank", target, false, caster, caster, caster:GetTeamNumber() )
	dummy:SetAbsOrigin(target + Vector(0, 0, 3000))
	ability:ApplyDataDrivenModifier(caster, dummy, good_aura_modifier, {} )
	ability:ApplyDataDrivenModifier(caster, dummy, bad_aura_modifier, {} )

	-- Destroys the dummy and particle when the effect expires
	Timers:CreateTimer(duration, function()
		if scepter then
			Timers:CreateTimer(duration * 9, function()
				dummy:Destroy()
				ParticleManager:DestroyParticle(fxIndex, false)
			end)
		else
			dummy:Destroy()
			ParticleManager:DestroyParticle(fxIndex, false)
		end
	end)
end

function Frostbite( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local attacker = keys.attacker
	local duration_hero = ability:GetLevelSpecialValueFor("duration", ability_level)
	local duration_creep = ability:GetLevelSpecialValueFor("creep_duration", ability_level)
	local cooldown_hero = ability:GetLevelSpecialValueFor("hero_cooldown", ability_level)
	local cooldown_creep = ability:GetLevelSpecialValueFor("creep_cooldown", ability_level)
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability_level)

	local modifier_root = keys.modifier_root
	local modifier_damage = keys.modifier_damage
	local modifier_passive = keys.modifier_passive
	local modifier_cooldown = keys.modifier_cooldown

	-- Applies root and damage to attacking unit according to its type, then triggers the cooldown accordingly
	if attacker:GetTeam() ~= caster:GetTeam() and not attacker:IsMagicImmune() then
		if attacker:IsHero() or attacker:IsAncient() then
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_root, {duration = duration_hero})
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_damage, {duration = duration_hero - damage_interval})
			caster:RemoveModifierByName(modifier_passive)
			ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, {duration = cooldown_hero})
		elseif not attacker:IsTower() then
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_root, {duration = duration_creep})
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_damage, {duration = duration_creep - damage_interval})
			caster:RemoveModifierByName(modifier_passive)
			ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, {duration = cooldown_creep})
		end
	end
end

function BrillianceAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_speed = keys.modifier_speed

	local mana_percent = caster:GetManaPercent()

	if mana_percent == 100 then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_speed, {})
	else
		caster:RemoveModifierByName(modifier_speed)
	end
end

function FreezingFieldCast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = caster:HasScepter()
	local modifier_aura = keys.modifier_aura
	local modifier_aura_scepter = keys.modifier_aura_scepter
	local modifier_sector_0 = keys.modifier_sector_0
	local modifier_sector_1 = keys.modifier_sector_1
	local modifier_sector_2 = keys.modifier_sector_2
	local modifier_sector_3 = keys.modifier_sector_3
	
	-- Grants the slowing aura to the caster
	if scepter then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aura_scepter, {})
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aura, {})
	end

	-- Initializes each sector's thinkers
	Timers:CreateTimer(0.1, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_sector_0, {} )
		return nil
		end )
		
	Timers:CreateTimer(0.2, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_sector_1, {} )
		return nil
		end )
	
	Timers:CreateTimer(0.3, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_sector_2, {} )
		return nil
		end )
	
	Timers:CreateTimer(0.4, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_sector_3, {} )
		return nil
		end )
end

function FreezingFieldExplode( keys )
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local caster = keys.caster
	local casterLocation = caster:GetAbsOrigin()
	local minDistance = ability:GetLevelSpecialValueFor("explosion_min_dist", ability_level)
	local maxDistance = ability:GetLevelSpecialValueFor("explosion_max_dist", ability_level)
	local radius = ability:GetLevelSpecialValueFor("explosion_radius", ability_level)
	local directionConstraint = keys.section
	local modifierName = "modifier_imba_freezing_field_debuff"
	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	local soundEventName = "hero_Crystal.freezingField.explosion"
	local damageType = ability:GetAbilityDamageType()
	local scepter = caster:HasScepter()
	local abilityDamage = 0

	if scepter == true then
		abilityDamage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
	else
		abilityDamage = ability:GetLevelSpecialValueFor("damage", ability_level)
	end
	
	-- Get random point
	local castDistance = RandomInt( minDistance, maxDistance )
	local angle = RandomInt( 0, 90 )
	local dy = castDistance * math.sin( angle )
	local dx = castDistance * math.cos( angle )
	local attackPoint = Vector( 0, 0, 0 )
	
	if directionConstraint == 0 then			-- NW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 1 then		-- NE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y + dy, casterLocation.z )
	elseif directionConstraint == 2 then		-- SE
		attackPoint = Vector( casterLocation.x + dx, casterLocation.y - dy, casterLocation.z )
	else										-- SW
		attackPoint = Vector( casterLocation.x - dx, casterLocation.y - dy, casterLocation.z )
	end
	
	-- From here onwards might be possible to port it back to datadriven through modifierArgs with point but for now leave it as is
	-- Loop through units
	local units = FindUnitsInRadius(caster:GetTeam(), attackPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _,v in pairs( units ) do
		ApplyDamage({victim = v, attacker = caster, damage = abilityDamage, damage_type = damageType})
	end
	
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(fxIndex, 0, attackPoint)
	
	-- Fire sound at caster's position
	StartSoundEvent(soundEventName, caster)

end