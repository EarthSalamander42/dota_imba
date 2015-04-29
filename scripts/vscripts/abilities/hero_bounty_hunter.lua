--[[	Author: D2imba
		Date: 17.03.2015	]]

function ShurikenToss( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_track = caster:FindAbilityByName("imba_bounty_hunter_track")
	local track_modifier = keys.track_modifier
	local track_scepter_modifier = keys.track_scepter_modifier
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
		if v:HasModifier(track_modifier) or v:HasModifier(track_scepter_modifier) then
			if v ~= target then
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
end

function ShurikenTossImpact( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local chain_particle = keys.chain_particle

	if target:IsAlive() then
		
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
	local target_loc = target:GetAbsOrigin()
	
	-- disables physics.lua library functions on the target
	target:StopPhysicsSimulation()

	-- destroys the shuriken toss chain and dummy unit
	ParticleManager:DestroyParticle(target.shuriken_particle,true)
	target.shuriken_toss_dummy:ForceKill(true)

	-- finds a legal position to the attached units to prevent them getting stuck
	FindClearSpaceForUnit(target, target_loc, false)
end

function WindWalk( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_invis = keys.modifier
	local ability_track = caster:FindAbilityByName("imba_bounty_hunter_track")
	local ability_jaunt = caster:FindAbilityByName("imba_bounty_hunter_shadow_jaunt")

	-- checks which ability is currently being cast
	local current_ability = caster:GetCurrentActiveAbility()

	-- if it's track, reapply invisibility as soon as the cast is concluded
	if current_ability == ability_track then
		Timers:CreateTimer(0.1, function()caster:AddNewModifier(caster, ability, "modifier_invisible", {})	end)
	else
		caster:RemoveModifierByName( modifier_invis )
	end
end

function TrackCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_track = keys.modifier_track
	local modifier_track_scepter = keys.modifier_track_scepter
	local aura_track = keys.aura_track
	local aura_track_scepter = keys.aura_track_scepter
	local scepter = HasScepter(caster)

	-- applies the relevant modifier depending on the presence of aghanim's scepter or not
	if scepter == true then
		target:RemoveModifierByName( modifier_track )
		ability:ApplyDataDrivenModifier(caster, target, aura_track_scepter, {} )
		ability:ApplyDataDrivenModifier(caster, target, modifier_track_scepter, {} )
	else
		target:RemoveModifierByName( modifier_track_scepter )
		ability:ApplyDataDrivenModifier(caster, target, aura_track, {} )
		ability:ApplyDataDrivenModifier(caster, target, modifier_track, {} )
	end
end

function Track( keys )
	local caster = keys.caster
	local target = keys.target
	local targetLocation = target:GetAbsOrigin() 
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local track_modifier = keys.track_modifier
	local track_scepter_modifier = keys.track_scepter_modifier
	local track_aura = keys.track_aura
	local track_scepter_aura = keys.track_scepter_aura
	local gold_steal = ability:GetLevelSpecialValueFor("gold_steal_scepter", ability_level)
	local bonus_gold_self = ability:GetLevelSpecialValueFor("bonus_gold_self", ability_level)
	local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability_level)
	local bonus_gold_radius = ability:GetLevelSpecialValueFor("bonus_gold_radius", ability_level)

	-- Calculates bonus gold based on the target's net worth
	local bonus_gold_self_percent = ability:GetLevelSpecialValueFor("bonus_gold_self_percent", ability_level)
	local bonus_gold_percent = ability:GetLevelSpecialValueFor("bonus_gold_percent", ability_level)
	local target_networth = PlayerResource:GetTotalEarnedGold(target:GetPlayerID())
	bonus_gold_self = bonus_gold_self + target_networth * bonus_gold_self_percent / 100
	bonus_gold = bonus_gold + target_networth * bonus_gold_percent / 100

	-- Finds all valid friendly heroes within the bonus gold radius
	local bonus_gold_targets = FindUnitsInRadius(caster:GetTeam() , targetLocation, nil, bonus_gold_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_HERO, 0, 0, false)

	-- Checks if the Track debuff is Scepter-upgraded; if true, calculates unreliable gold to steal from the target and distribute to all nearby allies.
	local gold_to_steal = math.floor( PlayerResource:GetUnreliableGold(target:GetPlayerID()) * gold_steal / 100 )
	local ally_count = #bonus_gold_targets

	if modifier == track_scepter_modifier then
		bonus_gold = bonus_gold + math.floor(gold_to_steal / ally_count)
		bonus_gold_self = bonus_gold_self + math.floor(gold_to_steal / ally_count)
	end

	-- Checks if the target is alive when the modifier is destroyed
	if not target:IsAlive() then
		-- If the Track debuff is Scepter-upgraded, decreases target's unreliable gold
		if modifier == track_scepter_modifier then
			gold_to_steal = (-1) * gold_to_steal
			target:ModifyGold(gold_to_steal, false, 0)
		end

		-- Gives gold to the caster
		caster:ModifyGold(bonus_gold_self, true, 0)

		-- Gives gold to allies in the nearby area
		for i,v in ipairs(bonus_gold_targets) do
			if not (v == caster) then
				v:ModifyGold(bonus_gold, true, 0)
			end
		end
	end

	-- Remove the track aura from the target
	-- NOTE: Trying to do this in KV is not possible it seems
	target:RemoveModifierByName( track_aura ) 
	target:RemoveModifierByName( track_scepter_aura ) 
end

function ShadowJaunt( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_jinada = caster:FindAbilityByName(keys.ability_jinada)
	local blink_sound = keys.blink_sound
	local track_modifier = keys.track_modifier
	local track_scepter_modifier = keys.track_scepter_modifier
	local target_loc = target:GetAbsOrigin()

	-- if the target is tracked, jumps to it and procs Jinada; otherwise, nothing happens.
	if target:HasModifier(track_modifier) or target:HasModifier(track_scepter_modifier) then
		EmitSoundOn(blink_sound, caster)
		ability_jinada:EndCooldown()		
		FindClearSpaceForUnit(caster, target_loc, false)
		caster:SetAttacking(target)
	else
		ability:EndCooldown()
	end
end
