--[[	Author: Ractidous
		Date: 27.01.2015.	]]

function LaunchIcyBreath( keys )
	local caster = keys.caster
	local ability = keys.ability

	local caster_pos = caster:GetAbsOrigin()
	local target_pos = keys.target_points[1]
	local direction = target_pos - caster_pos
	direction = direction:Normalized()

	ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
	--	EffectName			= "",
		vSpawnOrigin		= caster_pos,
		fDistance			= keys.distance,
		fStartRadius		= keys.start_radius,
		fEndRadius			= keys.end_radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * keys.speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )

	local particle_name = keys.particle_name
	local pfx = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_pos )
	ParticleManager:SetParticleControl( pfx, 1, direction * keys.speed * 1.333 )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
	ParticleManager:SetParticleControl( pfx, 9, caster_pos )

	caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
		ParticleManager:DestroyParticle( pfx, false )
	end, keys.distance / keys.speed )
	
end

function LaunchFieryBreath( keys )
	local caster = keys.caster
	local fiery_ability = caster:FindAbilityByName( keys.fiery_ability_name )

	local caster_pos = caster:GetAbsOrigin()
	local target_pos = keys.target_points[1]
	local direction = target_pos - caster_pos
	direction = direction:Normalized()

	ProjectileManager:CreateLinearProjectile( {
		Ability				= fiery_ability,
	--	EffectName			= "",
		vSpawnOrigin		= caster_pos,
		fDistance			= keys.distance,
		fStartRadius		= keys.start_radius,
		fEndRadius			= keys.end_radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * keys.speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )

	local particle_name = keys.particle_name
	local pfx = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, caster_pos )
	ParticleManager:SetParticleControl( pfx, 1, direction * keys.speed * 1.333 )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
	ParticleManager:SetParticleControl( pfx, 9, caster_pos )

	caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
		ParticleManager:DestroyParticle( pfx, false )
	end, keys.distance / keys.speed )
end

function DualBreathInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local duration = ability:GetLevelSpecialValueFor("tooltip_duration", ability:GetLevel() - 1)

	-- Resets the debuff's duration when a target is affected
	ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration})
	target.dual_breath_duration = duration
end

function DualBreathCountdown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability:GetLevel() - 1)

	local modifier = keys.modifier
	local modifier_macropyre = keys.modifier_macropyre
	local macropyre_scepter = keys.macropyre_scepter

	-- Checks if the target is in Macropyre's area. If yes, renews the dual breath debuff.
	if target:HasModifier(modifier_macropyre) or target:HasModifier(macropyre_scepter) then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = target.dual_breath_duration})
	else
		target.dual_breath_duration = target.dual_breath_duration - damage_interval
	end
end

function LiquidFireCooldown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )
	local modifier = "modifier_imba_liquid_fire_orb"

	-- Start cooldown
	ability:EndCooldown()
	ability:StartCooldown( cooldown )

	-- Disable orb modifier
	caster:RemoveModifierByName( modifier )

	-- Re-enable orb modifier after for the duration
	ability:SetContextThink( DoUniqueString("activateLiquidFire"), function ()
		-- Here's a magic
		-- Reset the ability level in order to restore a passive modifier
		ability.liquid_fire_forceEnableOrb = true
		ability:SetLevel( ability:GetLevel() )	
	end, cooldown + 0.05 )
end

function LiquidFireCheckOrb( keys )
	local ability = keys.ability
	local caster = keys.caster

	if ability.liquid_fire_forceEnableOrb then
		ability.liquid_fire_forceEnableOrb = nil
		return
	end

	if ability:IsCooldownReady() then
		return
	end

	caster:RemoveModifierByName( "modifier_imba_liquid_fire_orb" )
end

function LiquidFireInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier = keys.modifier
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

	-- Resets the debuff's duration when a target is affected
	ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = duration})
	target.liquid_fire_duration = duration
end

function LiquidFireCountdown( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local damage_interval = ability:GetLevelSpecialValueFor("damage_interval", ability:GetLevel() - 1)

	local modifier = keys.modifier
	local modifier_macropyre = keys.modifier_macropyre
	local macropyre_scepter = keys.macropyre_scepter

	-- Checks if the target is in Macropyre's area. If yes, renews the liquid fire debuff.
	if target:HasModifier(modifier_macropyre) or target:HasModifier(macropyre_scepter) then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = target.liquid_fire_duration})
	else
		target.liquid_fire_duration = target.liquid_fire_duration - damage_interval
	end
end

function Macropyre( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	local path_length = ability:GetLevelSpecialValueFor("range", ability_level)
	local path_radius = ability:GetLevelSpecialValueFor("path_radius", ability_level)
	local ice_delay = ability:GetLevelSpecialValueFor("ice_delay", ability_level)
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	local modifier = keys.modifier
	local modifier_scepter = keys.modifier_scepter
	local modifier_dummy = keys.modifier_dummy

	local start_pos = caster:GetAbsOrigin()
	local end_pos = start_pos + caster:GetForwardVector() * path_length

	local fire_particle = keys.fire_particle
	local ice_particle = keys.ice_particle
	local ice_particle_2 = keys.ice_particle_2

	-- Create fire particle effect
	local pfx = ParticleManager:CreateParticle( fire_particle, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, start_pos )
	ParticleManager:SetParticleControl( pfx, 1, end_pos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 3, start_pos )

	-- Create ice path particles (if the owner has Aghanim's Scepter)
	if scepter then
		-- Start and end points
		local start_pos_left = RotatePosition(start_pos, QAngle(0, 90, 0), start_pos + caster:GetForwardVector() * (path_radius - 150))
		local start_pos_right = RotatePosition(start_pos, QAngle(0, -90, 0), start_pos + caster:GetForwardVector() * (path_radius - 150))
		local end_pos_left = RotatePosition(end_pos, QAngle(0, 90, 0), end_pos + caster:GetForwardVector() * (path_radius - 150))
		local end_pos_right = RotatePosition(end_pos, QAngle(0, -90, 0), end_pos + caster:GetForwardVector() * (path_radius - 150))

		-- Left side
		local pfx = ParticleManager:CreateParticle( ice_particle, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, start_pos_left )
		ParticleManager:SetParticleControl( pfx, 1, end_pos_left )
		ParticleManager:SetParticleControl( pfx, 2, start_pos_left )
	
		pfx = ParticleManager:CreateParticle( ice_particle_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, start_pos_left )
		ParticleManager:SetParticleControl( pfx, 1, end_pos_left )
		ParticleManager:SetParticleControl( pfx, 2, Vector( ice_delay + duration, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx, 9, start_pos_left )

		-- Right side
		local pfx = ParticleManager:CreateParticle( ice_particle, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, start_pos_right )
		ParticleManager:SetParticleControl( pfx, 1, end_pos_right )
		ParticleManager:SetParticleControl( pfx, 2, start_pos_right )
	
		pfx = ParticleManager:CreateParticle( ice_particle_2, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx, 0, start_pos_right )
		ParticleManager:SetParticleControl( pfx, 1, end_pos_right )
		ParticleManager:SetParticleControl( pfx, 2, Vector( ice_delay + duration, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx, 9, start_pos_right )
	end

	-- Generate dummy units
	local num_units = math.floor( path_length / path_radius ) + 1

	for i=1, num_units do
		local dummy_pos = start_pos + caster:GetForwardVector() * (i-1) * path_radius

		-- Destroys trees around the target area
		local trees = Entities:FindAllByClassnameWithin("ent_dota_tree", dummy_pos, path_radius)
		for k, tree in pairs(trees) do
			tree:CutDown(caster:GetTeam())
		end

		-- Creates debuffing dummy (3000 units above ground to prevent camp blocking)
		local dummy = CreateUnitByName("npc_dummy_unit", dummy_pos, false, caster, caster, caster:GetTeamNumber())
		dummy:SetAbsOrigin(dummy_pos + Vector(0, 0, 3000))
		ability:ApplyDataDrivenModifier(caster, dummy, modifier_dummy, {} )

		if scepter then
			ability:ApplyDataDrivenModifier(caster, dummy, modifier_scepter, {} )
		else
			ability:ApplyDataDrivenModifier(caster, dummy, modifier, {} )
		end
	end
end

function MacropyreKillDummy( keys )
	local target = keys.target

	target:Destroy()
end