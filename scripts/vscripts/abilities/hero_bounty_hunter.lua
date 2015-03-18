--[[Author: d2imba
	Date: 17-3-2015.]]

function ShurikenToss( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_track = caster:FindAbilityByName("imba_bounty_hunter_track")
	local track_modifier = keys.track_modifier
	local target_location = target:GetAbsOrigin()

	-- shuriken projectile keyvalues
	local shuriken_particle = keys.shuriken_particle
	local shuriken_speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)

	local shuriken_projectile = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = shuriken_particle,
		bDodgable = true,
		bProvidesVision = false,
		iMoveSpeed = shuriken_speed,
		iVisionRadius = 0,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}

	-- shoots the shuriken at the main target
	ProjectileManager:CreateTrackingProjectile(shuriken_projectile)

	-- retrieves the targettable enemy heroes on the map
	local tracked_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)

	-- if a target is tracked and is not the main target, create a shuriken projectile flying towards it
	ProjectileManager:CreateTrackingProjectile(projectile)
	for _,v in pairs(tracked_targets) do
		if v:HasModifier(track_modifier) and v ~= target then
			shuriken_projectile = {
				Target = v,
				Source = caster,
				Ability = ability,
				EffectName = shuriken_particle,
				bDodgable = true,
				bProvidesVision = false,
				iMoveSpeed = shuriken_speed,
				iVisionRadius = 0,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
			}
			ProjectileManager:CreateTrackingProjectile(shuriken_projectile)
		end
	end
end

function ShurikenTossImpact( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local chain_particle = keys.chain_particle

	-- enables physics.lua library functions on the target
	Physics:Unit(target)

	-- retrieves the impact position
	local target_position = target:GetAbsOrigin()
	target.shuriken_toss_dummy = CreateUnitByName("npc_dummy_unit", target_position, false, nil, nil, caster:GetTeamNumber())
	target.shuriken_position = target:GetAbsOrigin()

	-- spawns a chain attached to the target and the impact point
	target.shuriken_particle = ParticleManager:CreateParticle(chain_particle, PATTACH_RENDERORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(target.shuriken_particle, 6, target.shuriken_toss_dummy, 5, "attach_attack1", target.shuriken_position, false)
	ParticleManager:SetParticleControlEnt(target.shuriken_particle, 0, target, 5, "attach_hitloc", target_position, false)
end

function ShurikenTossChain( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local chain_range = ability:GetLevelSpecialValueFor("chain_range", ability_level)
	local pull_strength = ability:GetLevelSpecialValueFor("pull_strength", ability_level)

	-- retrieves the target's distance from the impact point
	local target_position = target:GetAbsOrigin()
	local center_vector = target.shuriken_position - target_position
	local len = center_vector:Length2D()

	-- pushes the target towards the impact point with a strength proportional to its distance from it
	local velocity_vector = center_vector:Normalized() * len / chain_range * pull_strength
	target:AddPhysicsVelocity (velocity_vector)	
end

function ShurikenTossChainEnd( keys )
	local target = keys.target
	
	-- disables physics.lua library functions on the target
	target:StopPhysicsSimulation()

	-- destroys the shuriken toss chain and dummy unit
	ParticleManager:DestroyParticle(target.shuriken_particle,true)
	target.shuriken_toss_dummy:ForceKill(true)
end

function WindWalk( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_invis = keys.modifier
	local ability_track = caster:FindAbilityByName("imba_bounty_hunter_track")

	-- checks which ability is currently being cast
	local current_ability = caster:GetCurrentActiveAbility()

	-- if it's track, reapply invisibility as soon as the cast is concluded
	if current_ability == ability_track then
		Timers:CreateTimer(0.1, function() caster:AddNewModifier(caster, ability, "modifier_invisible", {IsHidden = 1})	end)
	else
		caster:RemoveModifierByName( modifier_invis )
	end
end
