--[[	Author: Firetoad
		Date: 04.08.2015	]]

function StormBoltLaunch( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster
	local modifier_god_str = keys.modifier_god_str
	local particle_bolt = keys.particle_bolt
	local particle_ult = keys.particle_ult
	local sound_cast = keys.sound_cast

	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Randomly play a cast line
	if RandomInt(1, 100) <= 50 then
		caster:EmitSound("sven_sven_ability_stormbolt_0"..RandomInt(1,9))
	end

	-- Remove caster from the world
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
	caster:AddNoDraw()

	-- Create tracking projectile
	local bolt_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_bolt,
		bDodgeable = true,
		bProvidesVision = true,
		iMoveSpeed = speed,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	-- Change projectile if God's strength is active
	if caster:HasModifier(modifier_god_str) then
		bolt_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_ult,
			bDodgeable = true,
			bProvidesVision = true,
			iMoveSpeed = speed,
			iVisionRadius = vision_radius,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}
	end

	ProjectileManager:CreateTrackingProjectile(bolt_projectile)
end

function StormBoltEnd( keys )
	local caster = keys.caster
	local modifier_caster = keys.modifier_caster

	-- Return caster to the world
	caster:RemoveModifierByName(modifier_caster)
	caster:RemoveNoDraw()
end

function StormBoltHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_caster = keys.modifier_caster
	local modifier_god_str = keys.modifier_god_str
	local ability_god_str = caster:FindAbilityByName(keys.ability_god_str)
	local sound_impact = keys.sound_impact
	local particle_impact = keys.particle_impact
	local sound_berserk = keys.sound_berserk	

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- If God's strength is active, update damage
	if ability_god_str and caster:HasModifier(modifier_god_str) then
		local bonus_damage = ability_god_str:GetLevelSpecialValueFor("storm_bolt_damage", ability_god_str:GetLevel() - 1)
		local bonus_radius = ability_god_str:GetLevelSpecialValueFor("storm_bolt_radius", ability_god_str:GetLevel() - 1)
		damage = damage + bonus_damage
		radius = radius + bonus_radius
	end

	-- Play sound
	target:EmitSound(sound_impact)

	-- Return caster to the world
	caster:RemoveModifierByName(modifier_caster)
	caster:RemoveNoDraw()

	-- Teleport the caster to the target
	local target_pos = target:GetAbsOrigin()
	local caster_pos = caster:GetAbsOrigin()
	local blink_pos = target_pos + ( caster_pos - target_pos ):Normalized() * 100
	FindClearSpaceForUnit(caster, blink_pos, true)

	-- Randomly play a cast line
	if ( target_pos - caster_pos ):Length2D() > 600 and RandomInt(1, 100) <= 20 then
		caster:EmitSound("sven_sven_ability_teleport_0"..RandomInt(1,3))
	end

	-- Start attacking the target
	caster:SetAttacking(target)

	-- Find enemies in effect area
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		
		-- Fire impact particle
		local enemy_loc = enemy:GetAbsOrigin()
		local impact_pfx = ParticleManager:CreateParticle(particle_impact, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(impact_pfx, 0, enemy_loc)
		ParticleManager:SetParticleControlEnt(impact_pfx, 3, enemy, PATTACH_ABSORIGIN, "attach_origin", enemy_loc, true)

		-- Stun
		enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = duration})

		-- Apply damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
	end
	
	
	if ability_god_str and caster:HasModifier(modifier_god_str) and #enemies >= 4 then
		target:EmitSound(sound_berserk)
	end
	
end

function GreatCleave( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particle_great_cleave = keys.particle_great_cleave
	local sound_cast = keys.sound_cast
	local modifier_active = keys.modifier_active
	local modifier_passive = keys.modifier_passive

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local great_cleave_pfx = ParticleManager:CreateParticle(particle_great_cleave, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(great_cleave_pfx, 0, caster:GetAbsOrigin())

	-- Remove the passive modifier
	caster:RemoveModifierByName(modifier_passive)

	-- Apply the active modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_active, {})
end

function GreatCleaveLevelUp( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_active = keys.modifier_active
	local modifier_passive = keys.modifier_passive

	-- If the skill is active, remove the passive aura modifier
	if caster:HasModifier(modifier_active) then
		caster:RemoveModifierByName(modifier_passive)
	end
end

function GreatCleaveEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_passive = keys.modifier_passive

	ability:ApplyDataDrivenModifier(caster, caster, modifier_passive, {})
end

function GreatCleaveHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_attack = keys.sound_attack
	local modifier_stack = keys.modifier_stack

	-- If the target is a building, do nothing
	if target:IsBuilding() then
		return nil
	end

	-- Play alternate attack sound
	target:EmitSound(sound_attack)

	-- Add a stack of the damage debuff
	AddStacks(ability, caster, target, modifier_stack, 1, true)
end

function Warcry( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_warcry = keys.particle_warcry
	local sound_cast = keys.sound_cast
	local modifier_aura = keys.modifier_aura

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	-- Purge the caster of all debuffs
	caster:Purge(false, true, false, true, false)

	-- Remove the passive aura and apply the active one
	ability:ApplyDataDrivenModifier(caster, caster, modifier_aura, {})

	-- Play the sound
	caster:EmitSound(sound_cast)

	-- Randomly play a cast line
	caster:EmitSound("sven_sven_ability_warcry_0"..RandomInt(1,9))

	-- Find particle targets
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), 0, FIND_ANY_ORDER, false)
	for _,ally in pairs(allies) do
		
		-- Play particle
		local warcry_pfx = ParticleManager:CreateParticle(particle_warcry, PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:SetParticleControl(warcry_pfx, 0, ally:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(warcry_pfx)
	end

	-- Toggle the skill off
	ability:ToggleAbility()
end

function GodStrength( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local sound_cast = keys.sound_cast
	local sound_be_a_man = keys.sound_be_a_man
	local particle_caster = keys.particle_caster
	local modifier_caster = keys.modifier_caster
	local modifier_aura = keys.modifier_aura
	local modifier_aura_scepter = keys.modifier_aura_scepter
	local scepter = HasScepter(caster)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Become a man... 30% of the time
	if RandomInt(1, 100) <= 30 then
		Timers:CreateTimer(2, function()
			caster:EmitSound(sound_be_a_man)
		end)
	end

	-- Randomly play a cast line
	caster:EmitSound("sven_sven_ability_godstrength_0"..RandomInt(1,2))

	-- Play caster particle
	local god_str_pfx = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(god_str_pfx, 0, caster:GetAbsOrigin())

	-- Apply the caster's modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})

	-- Apply the ally aura accordingly
	if scepter then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aura_scepter, {})
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier_aura, {})
	end
end

function GodStrengthCleave( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local damage = keys.damage
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_cleave = keys.particle_cleave

	-- If the target is a building, or this is an illusion, do nothing
	if target:IsBuilding() or not attacker:IsRealHero() then
		return nil
	end

	-- Parameters
	local cleave_pct = ability:GetLevelSpecialValueFor("ally_cleave_pct_scepter", ability_level)
	local cleave_radius = ability:GetLevelSpecialValueFor("ally_cleave_radius_scepter", ability_level)

	-- Calculate damage to deal
	damage = damage * cleave_pct * 0.01

	-- Draw particle
	local cleave_pfx = ParticleManager:CreateParticle(particle_cleave, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(cleave_pfx, 0, target:GetAbsOrigin())

	-- Find enemies to damage
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), target:GetAbsOrigin(), nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	-- Deal damage
	for _,enemy in pairs(enemies) do
		if enemy ~= target and not enemy:IsAttackImmune() then
			ApplyDamage({attacker = attacker, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		end
	end
end