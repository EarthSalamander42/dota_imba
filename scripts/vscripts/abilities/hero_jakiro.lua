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

	-- Checks if the target is in Macropyre's area. If yes, renews the dual breath debuff.
	if target:HasModifier(modifier_macropyre) then
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

	-- Checks if the target is in Macropyre's area. If yes, renews the liquid fire debuff.
	if target:HasModifier(modifier_macropyre) then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {duration = target.liquid_fire_duration})
	else
		target.liquid_fire_duration = target.liquid_fire_duration - damage_interval
	end
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Create the particle effect and projectiles.
]]
function FireMacropyre( keys )
	local caster		= keys.caster
	local ability		= keys.ability

	local pathLength	= keys.cast_range
	local pathRadius	= keys.path_radius
	local duration		= keys.duration

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength

	ability.macropyre_startPos	= startPos
	ability.macropyre_endPos	= endPos
	ability.macropyre_expireTime = GameRules:GetGameTime() + duration

	-- Create particle effect
	local particle_name = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
	local pfx = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 3, startPos )

	-- Generate projectiles
	pathRadius = math.max( pathRadius, 64 )
	local projectileRadius = pathRadius * math.sqrt(2)
	local numProjectiles = math.floor( pathLength / (pathRadius*2) ) + 1
	local stepLength = pathLength / ( numProjectiles - 1 )

	local dummyModifierName = "modifier_macropyre_destroy_tree_datadriven"

	for i=1, numProjectiles do
		local projectilePos = startPos + caster:GetForwardVector() * (i-1) * stepLength

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
		--	EffectName			= "",
			vSpawnOrigin		= projectilePos,
			fDistance			= 64,
			fStartRadius		= projectileRadius,
			fEndRadius			= projectileRadius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
			fExpireTime			= ability.macropyre_expireTime,
			bDeleteOnHit		= false,
			vVelocity			= Vector( 0, 0, 0 ),	-- Don't move!
			bProvidesVision		= false,
		--	iVisionRadius		= 0,
		--	iVisionTeamNumber	= caster:GetTeamNumber(),
		} )

		-- Create dummy to destroy trees
		if i~=1 and GridNav:IsNearbyTree( projectilePos, pathRadius, true ) then
			local dummy = CreateUnitByName( "npc_dota_thinker", projectilePos, false, caster, caster, caster:GetTeamNumber() )
			ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
		end
	end
end

--[[
	Author: Ractidous
	Data: 27.01.2015.
	Apply a dummy modifier that periodcally checks whether the target is within the macropyre's path.
]]
function ApplyDummyModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = keys.modifier_name

	local duration = ability.macropyre_expireTime - GameRules:GetGameTime()

	ability:ApplyDataDrivenModifier( caster, target, modifierName, { duration = duration } )
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Check whether the target is within the path, and apply damage if neccesary.
]]
function CheckMacropyre( keys )
	local caster		= keys.caster
	local target		= keys.target
	local ability		= keys.ability
	local pathRadius	= keys.path_radius
	local damage		= keys.damage

	local target_pos = target:GetAbsOrigin()
	target_pos.z = 0

	local distance = DistancePointSegment( target_pos, ability.macropyre_startPos, ability.macropyre_endPos )
	if distance < pathRadius then
		-- Apply damage
		ApplyDamage( {
			ability = ability,
			attacker = caster,
			victim = target,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
		} )
	end
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Distance between a point and a segment.
]]
function DistancePointSegment( p, v, w )
	local l = w - v
	local l2 = l:Dot( l )
	t = ( p - v ):Dot( w - v ) / l2
	if t < 0.0 then
		return ( v - p ):Length2D()
	elseif t > 1.0 then
		return ( w - p ):Length2D()
	else
		local proj = v + t * l
		return ( proj - p ):Length2D()
	end
end