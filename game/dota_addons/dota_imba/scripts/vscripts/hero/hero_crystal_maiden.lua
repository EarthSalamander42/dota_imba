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

	-- Creates flying vision area
	ability:CreateVisibilityNode(target, vision_radius, duration)

	-- Creates buffing/debuffing dummy
	local dummy = CreateUnitByName("npc_dummy_blank", target, false, nil, nil, caster:GetTeamNumber() )
	dummy:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, duration)
	dummy:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, duration)
	dummy:SetAbsOrigin(target)
	ability:ApplyDataDrivenModifier(caster, dummy, good_aura_modifier, {} )
	ability:ApplyDataDrivenModifier(caster, dummy, bad_aura_modifier, {} )

	-- Creates the particle
	local fxIndex = ParticleManager:CreateParticle( particle, PATTACH_CUSTOMORIGIN, dummy)
	local radiusVector = (Vector (effect_radius, 0, 0))

	ParticleManager:SetParticleControl(fxIndex, 0, target)
	ParticleManager:SetParticleControl(fxIndex, 1, radiusVector)
	ParticleManager:SetParticleControl(fxIndex, 5, radiusVector)

	-- Destroys the dummy and particle when the effect expires
	Timers:CreateTimer(duration, function()
		dummy:Destroy()
		ParticleManager:DestroyParticle(fxIndex, false)
		ReleaseParticleIndex(fxIndex)
	end)
end

function Frostbite( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local attacker = keys.attacker
	local modifier_root = keys.modifier_root
	local modifier_damage = keys.modifier_damage
	local modifier_passive = keys.modifier_passive
	local modifier_cooldown = keys.modifier_cooldown

	-- Parameters
	local duration_hero = ability:GetLevelSpecialValueFor("duration", 0)
	local duration_creep = ability:GetLevelSpecialValueFor("creep_duration", ability_level)
	local cooldown = ability:GetLevelSpecialValueFor("hero_cooldown", ability_level)
	local creep_chance = ability:GetLevelSpecialValueFor("creep_chance", ability_level)
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability_level)

	-- Applies root and damage to attacking unit according to its type, then triggers the cooldown accordingly
	if attacker:GetTeam() ~= caster:GetTeam() and not attacker:IsMagicImmune() then
		if attacker:IsHero() or IsRoshan(attacker) then
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_root, {duration = duration_hero})
			ability:ApplyDataDrivenModifier(caster, attacker, modifier_damage, {duration = duration_hero - damage_interval})
			caster:RemoveModifierByName(modifier_passive)
			ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, {duration = cooldown})
		elseif not attacker:IsTower() and not attacker:IsBuilding() then
			if RandomInt(1, 100) <= creep_chance then
				ability:ApplyDataDrivenModifier(caster, attacker, modifier_root, {duration = duration_creep})
				ability:ApplyDataDrivenModifier(caster, attacker, modifier_damage, {duration = duration_creep - damage_interval})
			end
		end
	end
end

function FrostbitePassive( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_passive = keys.modifier_passive

	ApplyDataDrivenModifierWhenPossible(caster, caster, ability, modifier_passive)
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
	local modifier_aura = keys.modifier_aura
	local modifier_sector_0 = keys.modifier_sector_0
	local modifier_sector_1 = keys.modifier_sector_1
	local modifier_sector_2 = keys.modifier_sector_2
	local modifier_sector_3 = keys.modifier_sector_3

	-- Defines the center point (caster or dummy unit)
	caster.freezing_field_center = caster
	local scepter = HasScepter(caster)
	if scepter then
		caster.freezing_field_center = CreateUnitByName("npc_dummy_unit", keys.target_points[1], false, nil, nil, caster:GetTeamNumber())
		caster.freezing_field_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, caster.freezing_field_center)
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 0, keys.target_points[1])
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 1, Vector (1000, 0, 0))
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 5, Vector (1000, 0, 0))
	else
		caster.freezing_field_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 1, Vector (1000, 0, 0))
		ParticleManager:SetParticleControl(caster.freezing_field_particle, 5, Vector (1000, 0, 0))
	end

	-- Plays the channeling animation
	StartAnimation(caster, {activity = ACT_DOTA_CAST_ABILITY_4, rate = 0.7})

	-- Plays ult ambient sound
	if RandomInt(1, 100) <= 20 then
		caster.freezing_field_center:EmitSound("Imba.CrystalMaidenLetItGo0"..RandomInt(1, 3))
	else
		caster.freezing_field_center:EmitSound("hero_Crystal.freezingField.wind")
	end

	-- Grants the slowing aura to the center unit
	ability:ApplyDataDrivenModifier(caster, caster.freezing_field_center, modifier_aura, {})

	-- Initializes each sector's thinkers
	Timers:CreateTimer(0.1, function()
		ability:ApplyDataDrivenModifier(caster, caster.freezing_field_center, modifier_sector_0, {} )
	end)
		
	Timers:CreateTimer(0.2, function()
		ability:ApplyDataDrivenModifier(caster, caster.freezing_field_center, modifier_sector_1, {} )
	end)
	
	Timers:CreateTimer(0.3, function()
		ability:ApplyDataDrivenModifier(caster, caster.freezing_field_center, modifier_sector_2, {} )
	end)
	
	Timers:CreateTimer(0.4, function()
		ability:ApplyDataDrivenModifier(caster, caster.freezing_field_center, modifier_sector_3, {} )
	end)
end

function FreezingFieldExplode( keys )
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local caster = keys.caster
	local target_loc = caster:GetAbsOrigin()
	local min_distance = ability:GetLevelSpecialValueFor("explosion_min_dist", ability_level)
	local max_distance = ability:GetLevelSpecialValueFor("explosion_max_dist", ability_level)
	local radius = ability:GetLevelSpecialValueFor("explosion_radius", ability_level)
	local direction_constraint = keys.section
	local particle_name = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	local sound_name = "hero_Crystal.freezingField.explosion"
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local scepter = caster:HasScepter()

	if scepter then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability_level)
		target_loc = caster.freezing_field_center:GetAbsOrigin()
	end
	
	-- Get random point
	local castDistance = RandomInt( min_distance, max_distance )
	local angle = RandomInt( 0, 90 )
	local dy = castDistance * math.sin( angle )
	local dx = castDistance * math.cos( angle )
	local attackPoint = Vector( 0, 0, 0 )
	
	if direction_constraint == 0 then			-- NW
		attackPoint = Vector( target_loc.x - dx, target_loc.y + dy, target_loc.z )
	elseif direction_constraint == 1 then		-- NE
		attackPoint = Vector( target_loc.x + dx, target_loc.y + dy, target_loc.z )
	elseif direction_constraint == 2 then		-- SE
		attackPoint = Vector( target_loc.x + dx, target_loc.y - dy, target_loc.z )
	else										-- SW
		attackPoint = Vector( target_loc.x - dx, target_loc.y - dy, target_loc.z )
	end
	
	-- Loop through units
	local units = FindUnitsInRadius(caster:GetTeam(), attackPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _,v in pairs( units ) do
		ApplyDamage({victim = v, attacker = caster, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
	end

	-- Create particle/sound dummy unit
	local explosion_dummy = CreateUnitByName("npc_dummy_unit", attackPoint, false, nil, nil, caster:GetTeamNumber())
	
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, explosion_dummy)
	ParticleManager:SetParticleControl(fxIndex, 0, attackPoint)
	
	-- Fire sound at the center position
	explosion_dummy:EmitSound(sound_name)

	-- Destroy dummy
	explosion_dummy:Destroy()
end

function FreezingFieldStopSound( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local modifier_aura = keys.modifier_aura
	local modifier_caster = keys.modifier_caster
	local modifier_NE = keys.modifier_NE
	local modifier_NW = keys.modifier_NW
	local modifier_SW = keys.modifier_SW
	local modifier_SE = keys.modifier_SE

	-- Stop playing sounds
	caster.freezing_field_center:StopSound("hero_Crystal.freezingField.wind")
	caster.freezing_field_center:StopSound("Imba.CrystalMaidenLetItGo01")
	caster.freezing_field_center:StopSound("Imba.CrystalMaidenLetItGo02")
	caster.freezing_field_center:StopSound("Imba.CrystalMaidenLetItGo03")

	-- Stop animation
	EndAnimation(caster)

	-- Removes auras and modifiers
	if scepter then
		caster.freezing_field_center:Destroy()
		caster:RemoveModifierByName(modifier_caster)
	else
		caster:RemoveModifierByName(modifier_aura)
		caster:RemoveModifierByName(modifier_NE)
		caster:RemoveModifierByName(modifier_NW)
		caster:RemoveModifierByName(modifier_SW)
		caster:RemoveModifierByName(modifier_SE)
	end

	-- Destroy center particle
	ParticleManager:DestroyParticle(caster.freezing_field_particle, true)

	-- Resets the center position
	caster.freezing_field_center = nil
	caster.freezing_field_particle = nil

end

function FreezingFieldEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local modifier_aura = keys.modifier_aura
	local modifier_caster = keys.modifier_caster
	local modifier_NE = keys.modifier_NE
	local modifier_NW = keys.modifier_NW
	local modifier_SW = keys.modifier_SW
	local modifier_SE = keys.modifier_SE

	-- Removes auras and modifiers
	if scepter then
		caster.freezing_field_center:Destroy()
		caster:RemoveModifierByName(modifier_caster)
	else
		caster:RemoveModifierByName(modifier_aura)
		caster:RemoveModifierByName(modifier_NE)
		caster:RemoveModifierByName(modifier_NW)
		caster:RemoveModifierByName(modifier_SW)
		caster:RemoveModifierByName(modifier_SE)
	end

	-- Destroy center particle
	ParticleManager:DestroyParticle(caster.freezing_field_particle, false)

	-- Resets the center position
	caster.freezing_field_center = nil
	caster.freezing_field_particle = nil

end

function ScepterCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		local ability = keys.skill_name
		local new_ability = keys.scepter_skill_name
		local modifier = keys.modifier

		caster:RemoveModifierByName(modifier)
		SwitchAbilities(caster, new_ability, ability, true, true)
	else
		return nil
	end
end

function ScepterLostCheck( keys )
	local caster = keys.caster
	local scepter = HasScepter(caster)

	if scepter then
		return nil
	else
		local ability = keys.scepter_skill_name
		local new_ability = keys.skill_name
		local modifier = keys.modifier
		
		caster:RemoveModifierByName(modifier)
		SwitchAbilities(caster, new_ability, ability, true, true)
	end
end