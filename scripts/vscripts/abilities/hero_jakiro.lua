--[[
	Author: Ractidous
	Date: 27.01.2015.
	Launch the icy breath
]]
function Launch_IcyBreath( event )
	local caster = event.caster
	local ability = event.ability

	local casterOrigin = caster:GetAbsOrigin()
	local targetPos = event.target_points[1]
	local direction = targetPos - casterOrigin
	direction = direction / direction:Length2D()

	ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
	--	EffectName			= "",
		vSpawnOrigin		= casterOrigin,
		fDistance			= event.distance,
		fStartRadius		= event.start_radius,
		fEndRadius			= event.end_radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * event.speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )

	local particleName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, casterOrigin )
	ParticleManager:SetParticleControl( pfx, 1, direction * event.speed * 1.333 )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
	ParticleManager:SetParticleControl( pfx, 9, casterOrigin )

	caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
		ParticleManager:DestroyParticle( pfx, false )
	end, event.distance / event.speed )
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Launch the fiery breath
]]
function Launch_FieryBreath( event )
	local caster = event.caster
	local fieryAbility = caster:FindAbilityByName( event.fiery_ability_name )

	local casterOrigin = caster:GetAbsOrigin()
	local targetPos = event.target_points[1]
	local direction = targetPos - casterOrigin
	direction = direction / direction:Length2D()

	ProjectileManager:CreateLinearProjectile( {
		Ability				= fieryAbility,
	--	EffectName			= "",
		vSpawnOrigin		= casterOrigin,
		fDistance			= event.distance,
		fStartRadius		= event.start_radius,
		fEndRadius			= event.end_radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_MECHANICAL,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * event.speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )

	local particleName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, casterOrigin )
	ParticleManager:SetParticleControl( pfx, 1, direction * event.speed * 1.333 )
	ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
	ParticleManager:SetParticleControl( pfx, 9, casterOrigin )

	caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
		ParticleManager:DestroyParticle( pfx, false )
	end, event.distance / event.speed )
end

--[[
	Author: Ractidous
	Date: 26.01.2015.
	Apply burn modifier to the target.
]]
function OnProjectileHit_Fiery( event )
	local caster = event.caster
	local target = event.target
	local ability = caster:FindAbilityByName( event.main_ability_name )

	ability:ApplyDataDrivenModifier( caster, target, event.modifier_name, {} )
end

--[[
	Author: Ractidous
	Date: 26.01.2015.
	Create the particle effect.
]]
function FireEffect_IcePath( event )
	local caster		= event.caster
	local ability		= event.ability
	local pathLength	= ability:GetCastRange()
	local pathDelay		= event.path_delay
	local pathDuration	= event.duration
	local pathRadius	= event.path_radius

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength

	ability.ice_path_stunStart	= GameRules:GetGameTime() + pathDelay
	ability.ice_path_stunEnd	= GameRules:GetGameTime() + pathDelay + pathDuration

	ability.ice_path_startPos	= startPos * 1
	ability.ice_path_endPos		= endPos * 1

	ability.ice_path_startPos.z = 0
	ability.ice_path_endPos.z = 0

	-- Create ice_path
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, startPos )

	ability.pfxIcePath = pfx

	-- Create ice_path_b
	particleName = "particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf"
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( pathDelay + pathDuration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 9, startPos )

	-- Generate projectiles
	if pathRadius < 32 then
		print( "Set the proper value of path_radius in ice_path_datadriven." )
		return
	end

	local projectileRadius = pathRadius * math.sqrt(2)
	local numProjectiles = math.floor( pathLength / (pathRadius*2) ) + 1
	local stepLength = pathLength / ( numProjectiles - 1 )

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
			fExpireTime			= ability.ice_path_stunEnd,
			bDeleteOnHit		= false,
			vVelocity			= Vector( 0, 0, 0 ),	-- Don't move!
			bProvidesVision		= true,
			iVisionRadius		= 150,
			iVisionTeamNumber	= caster:GetTeamNumber(),
		} )
	end
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Destroy ice_path manually in order to show its endcap effects.
]]
function FireEffect_Destroy_IcePath_A( event )
	local caster		= event.caster
	local ability		= event.ability
	local pfxIcePath	= ability.pfxIcePath

	ParticleManager:DestroyParticle( pfxIcePath, false )

	ability.pfxIcePath = nil
end

--[[
	Author: Ractidous
	Data: 27.01.2015.
	Apply a dummy modifier that periodcally checks whether the target is within the ice path.
]]
function ApplyDummyModifier( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifierName = event.modifier_name

	local duration = ability.ice_path_stunEnd - GameRules:GetGameTime()

	ability:ApplyDataDrivenModifier( caster, target, modifierName, { duration = duration } )
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Check whether the target is within the ice path, and apply stun and damage if neccesary.
]]
function CheckIcePath( event )
	local caster		= event.caster
	local target		= event.target
	local ability		= event.ability
	local pathRadius	= event.path_radius

	local stunModifierName	= "modifier_ice_path_stun_datadriven"

	if GameRules:GetGameTime() < ability.ice_path_stunStart then
		-- Not yet.
		return
	end

	if target:HasModifier( stunModifierName ) then
		-- Already stunned.
		return
	end

	local targetPos = target:GetAbsOrigin()
	targetPos.z = 0

	local distance = DistancePointSegment( targetPos, ability.ice_path_startPos, ability.ice_path_endPos )
	if distance < pathRadius then
		local duration = ability.ice_path_stunEnd - GameRules:GetGameTime()
		ability:ApplyDataDrivenModifier( caster, target, stunModifierName, { duration = duration } )
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

--[[
	Author: Ractidous
	Date: 28.01.2015.
	Start cooldown.
]]
function StartCooldown( event )
	local caster = event.caster
	local ability = event.ability
	local cooldown = ability:GetCooldown( ability:GetLevel() - 1 )
	local modifierName = "modifier_liquid_fire_orb_datadriven"

	-- Start cooldown
	ability:EndCooldown()
	ability:StartCooldown( cooldown )

	-- Disable orb modifier
	caster:RemoveModifierByName( "modifier_liquid_fire_orb_datadriven" )

	-- Re-enable orb modifier after for the duration
	ability:SetContextThink( DoUniqueString("activateLiquidFire"), function ()
		-- Here's a magic
		-- Reset the ability level in order to restore a passive modifier
		ability.liquid_fire_forceEnableOrb = true
		ability:SetLevel( ability:GetLevel() )	
	end, cooldown + 0.05 )
end

--[[
	Author: Ractidous
	Dage: 28.01.2015.
	Check orb modifer state on upgrading.
]]
function CheckOrbModifier( event )
	local ability = event.ability
	local caster = event.caster

	if ability.liquid_fire_forceEnableOrb then
		ability.liquid_fire_forceEnableOrb = nil
		return
	end

	if ability:IsCooldownReady() then
		return
	end

	caster:RemoveModifierByName( "modifier_liquid_fire_orb_datadriven" )
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Create the particle effect and projectiles.
]]
function FireMacropyre( event )
	local caster		= event.caster
	local ability		= event.ability

	local pathLength	= event.cast_range
	local pathRadius	= event.path_radius
	local duration		= event.duration

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength

	ability.macropyre_startPos	= startPos
	ability.macropyre_endPos	= endPos
	ability.macropyre_expireTime = GameRules:GetGameTime() + duration

	-- Create particle effect
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
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
function ApplyDummyModifier( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local modifierName = event.modifier_name

	local duration = ability.macropyre_expireTime - GameRules:GetGameTime()

	ability:ApplyDataDrivenModifier( caster, target, modifierName, { duration = duration } )
end

--[[
	Author: Ractidous
	Date: 27.01.2015.
	Check whether the target is within the path, and apply damage if neccesary.
]]
function CheckMacropyre( event )
	local caster		= event.caster
	local target		= event.target
	local ability		= event.ability
	local pathRadius	= event.path_radius
	local damage		= event.damage

	local targetPos = target:GetAbsOrigin()
	targetPos.z = 0

	local distance = DistancePointSegment( targetPos, ability.macropyre_startPos, ability.macropyre_endPos )
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