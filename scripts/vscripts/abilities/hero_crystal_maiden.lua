--[[
	Author: Hewdraw
]]

function crystal_nova( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[ 1 ]
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ( ability:GetLevel() - 1 ) )
	local radius = ability:GetLevelSpecialValueFor( "vision_radius", ( ability:GetLevel() - 1 ) )
	local current_instance = 0
	local max_instances = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local dummyModifierName = "modifier_crystal_nova_dummy"
	local interval = ability:GetLevelSpecialValueFor( "damage_interval", ability:GetLevel() - 1 )
	local damage_tick = ability:GetLevelSpecialValueFor( "damage_per_tick", ability:GetLevel() - 1 )
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local damageType = DAMAGE_TYPE_PURE
	local scepter = caster:HasScepter()

	local dummy = CreateUnitByName("npc_dummy_blank", target, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )

	Timers:CreateTimer( function()
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, targetTeam,targetType, targetFlag, FIND_ANY_ORDER, false)
			for _,v in pairs( enemies ) do
				if v:HasModifier("modifier_damage_dummy") then
				else
					ApplyDamage({ victim = v, attacker = caster, damage = damage_tick, damage_type = damageType })
					ability:ApplyDataDrivenModifier(caster, v, "modifier_damage_dummy", {})
				end
			end
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, targetFlag, FIND_ANY_ORDER, false)
			for _,c in pairs( allies ) do
				if c:HasModifier("modifier_crystal_maiden") then
					ability:ApplyDataDrivenModifier(caster, c, "modifier_crystal_nova_aura_crystal_maiden", {})
				end
			end
			if scepter == false then
				current_instance = current_instance + 1
				
				if current_instance >= max_instances then
					dummy:Destroy()
					return nil
				else
					return interval
				end
			else
				return interval
			end
		end
	)
end

function crystal_nova_post_vision( keys )
	local ability = keys.ability
	local target = keys.target_points[ 1 ]
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ( ability:GetLevel() - 1 ) )
	local radius = ability:GetLevelSpecialValueFor( "vision_radius", ( ability:GetLevel() - 1 ) )

	ability:CreateVisibilityNode( target, radius, duration )
end

function frost_bite_attack( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local attacker = keys.attacker
	local unit = keys.unit
	local duration = keys.duration
	local damage_interval = ability:GetLevelSpecialValueFor( "damage_interval", ( ability:GetLevel() - 1 ) )
	local modifier = "modifier_frost_bite_passive"
	local damage_duration = duration - damage_interval

	if target:HasModifier(modifier) then
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_frost_bite_root", {duration = duration})
		ability:ApplyDataDrivenModifier(caster, attacker, "modifier_frost_bite_damage", {duration = damage_duration})
		caster:RemoveModifierByName("modifier_frost_bite_passive")
		caster:RemoveModifierByName("modifier_frost_bite_passive_creep")
	end
end

function brilliance_aura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local mana = caster.GetMana(caster)
	local maxmana = caster.GetMaxMana(caster)

	if mana == maxmana then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_brilliance_aura_movement_speed", {})
	else
		caster:RemoveModifierByName("modifier_brilliance_aura_movement_speed")
	end
end

function freezing_field_cast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local scepter = caster:HasScepter()

	if scepter == true then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_freezing_field_caster_scepter", {})
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_freezing_field_caster", {})
	end
end

function freezing_field_order_explosion( keys )
	local caster = keys.caster
	local ability = keys.ability
	Timers:CreateTimer( 0.1, function()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_freezing_field_northwest_thinker", {} )
		return nil
		end )
		
	Timers:CreateTimer( 0.2, function()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_freezing_field_northeast_thinker", {} )
		return nil
		end )
	
	Timers:CreateTimer( 0.3, function()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_freezing_field_southeast_thinker", {} )
		return nil
		end )
	
	Timers:CreateTimer( 0.4, function()
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_freezing_field_southwest_thinker", {} )
		return nil
		end )
end

function freezing_field_explode( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.caster:GetAbsOrigin()
	local minDistance = ability:GetLevelSpecialValueFor( "explosion_min_dist", ( ability:GetLevel() - 1 ) )
	local maxDistance = ability:GetLevelSpecialValueFor( "explosion_max_dist", ( ability:GetLevel() - 1 ) )
	local radius = ability:GetLevelSpecialValueFor( "explosion_radius", ( ability:GetLevel() - 1 ) )
	local directionConstraint = keys.section
	local modifierName = "modifier_freezing_field_debuff"
	local refModifierName = "modifier_freezing_field_ref_point_datadriven"
	local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
	local soundEventName = "hero_Crystal.freezingField.explosion"
	local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local damageType = ability:GetAbilityDamageType()
	local scepter = caster:HasScepter()
	local abilityDamage = 0

	if scepter == true then
		abilityDamage = ability:GetLevelSpecialValueFor( "damage_scepter", ( ability:GetLevel() - 1 ) )
	else
		abilityDamage = ability:GetLevelSpecialValueFor( "damage", ( ability:GetLevel() - 1 ) )
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
	local units = FindUnitsInRadius(caster.GetTeam(caster), attackPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,v in pairs( units ) do
		ApplyDamage({ victim = v, attacker = caster, damage = abilityDamage, damage_type = DAMAGE_TYPE_MAGICAL })
	end
	
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )
	
	-- Fire sound at dummy
	local dummy = CreateUnitByName( "npc_dummy_blank", attackPoint, false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, refModifierName, {} )
	StartSoundEvent( soundEventName, dummy )
	Timers:CreateTimer( 0.1, function()
		dummy:ForceKill( true )
		return nil
	end )
end