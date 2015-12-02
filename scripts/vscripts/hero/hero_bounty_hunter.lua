--[[	Author: D2imba
		Date: 17.03.2015	]]

function ShurikenToss( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local track_modifier = keys.track_modifier
	local track_scepter_modifier = keys.track_scepter_modifier
	local target_location = target:GetAbsOrigin()

	-- shuriken projectile keyvalues
	local shuriken_particle = keys.shuriken_particle
	local shuriken_speed = ability:GetLevelSpecialValueFor("speed", ability_level)

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
	local tracked_targets = FindUnitsInRadius(caster:GetTeam(), target_location, nil, 25000, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)

	-- if a target is tracked and is not the main target, create a shuriken projectile flying towards it
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

		-- Delete previously spawned chain if it still exists
		if target.shuriken_particle then
			ParticleManager:DestroyParticle(target.shuriken_particle,true)
		end

		-- Retrieve the impact position
		local target_position = target:GetAbsOrigin()
		target.shuriken_toss_dummy = CreateUnitByName("npc_dummy_unit", target_position, false, nil, nil, caster:GetTeamNumber())
		target.shuriken_position = target:GetAbsOrigin()
		target.shuriken_toss_dummy:SetAbsOrigin(target.shuriken_position)

		-- Spawn a chain attached to the target and the impact point
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
	local pull_strength = ability:GetLevelSpecialValueFor("pull_strength_tooltip", ability_level)

	-- Retrieve the target's distance from the impact point
	local target_position = target:GetAbsOrigin()
	local center_vector = target.shuriken_position - target_position
	local len = center_vector:Length2D()
	local tick_rate = 0.05

	-- Push the target towards the impact point with a strength proportional to its distance from it
	local pull_distance = center_vector:Normalized() * len / chain_range * pull_strength * tick_rate
	FindClearSpaceForUnit(target, target_position + pull_distance, false)
end

function ShurikenTossChainEnd( keys )
	local target = keys.target
	local target_loc = target:GetAbsOrigin()

	-- Destroy the shuriken toss chain and dummy unit
	ParticleManager:DestroyParticle(target.shuriken_particle, true)
	target.shuriken_toss_dummy:Destroy()
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
		Timers:CreateTimer(0.01, function() caster:AddNewModifier(caster, ability, "modifier_invisible", {})	end)
	else
		caster:RemoveModifierByName( modifier_invis )
	end
end

function TrackCast( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local scepter = HasScepter(caster)

	-- Modifiers and effects
	local modifier_track = keys.modifier_track
	local modifier_track_scepter = keys.modifier_track_scepter
	local modifier_track_aura = keys.modifier_track_aura
	local sound_track = keys.sound_track

	-- Play sound to caster's allies
	caster:EmitSound(sound_track)

	-- Updates track modifier according to caster's scepter ownership
	if scepter then
		target:RemoveModifierByName(modifier_track)
		ability:ApplyDataDrivenModifier(caster, target, modifier_track_scepter, {} )
	else
		target:RemoveModifierByName(modifier_track_scepter)
		ability:ApplyDataDrivenModifier(caster, target, modifier_track, {} )
	end

	-- Apply aura modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_track_aura, {})
end

function TrackParticle( keys )
	local caster = keys.caster
	local target = keys.target
	local particle_trail = keys.particle_trail
	local particle_shield = keys.particle_shield

	-- Draws the particles only to the caster's allies
	target.track_trail_pfx = ParticleManager:CreateParticleForTeam(particle_trail, PATTACH_ABSORIGIN_FOLLOW, target, caster:GetTeam())
	ParticleManager:SetParticleControl(target.track_trail_pfx, 0, target:GetAbsOrigin())

	target.track_shield_pfx = ParticleManager:CreateParticleForTeam(particle_shield, PATTACH_OVERHEAD_FOLLOW, target, caster:GetTeam())
	ParticleManager:SetParticleControl(target.track_shield_pfx, 0, target:GetAbsOrigin())
end

function TrackParticleEnd( keys )
	local target = keys.target
	local modifier_track_aura = keys.modifier_track_aura

	-- Remove Aura modifier
	target:RemoveModifierByName(modifier_track_aura)

	-- Destroy track particles
	ParticleManager:DestroyParticle(target.track_trail_pfx, false)
	ParticleManager:DestroyParticle(target.track_shield_pfx, false)
end

function Track( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local bonus_gold_self = ability:GetLevelSpecialValueFor("bonus_gold_self", ability_level)
	local bonus_gold_self_per_lvl = ability:GetLevelSpecialValueFor("bonus_gold_self_per_lvl", ability_level)
	local bonus_gold = ability:GetLevelSpecialValueFor("bonus_gold", ability_level)
	local bonus_gold_per_lvl = ability:GetLevelSpecialValueFor("bonus_gold_per_lvl", ability_level)
	local bonus_gold_radius = ability:GetLevelSpecialValueFor("bonus_gold_radius", ability_level)

	-- If the target is an illusion, do nothing
	if target:IsIllusion() then
		return nil
	end

	-- Calculate total bonus gold
	local target_level = target:GetLevel()
	bonus_gold_self = bonus_gold_self + ( target_level - 1 ) * bonus_gold_self_per_lvl
	bonus_gold = bonus_gold + ( target_level - 1 ) * bonus_gold_per_lvl

	-- Multiply gold bounties according to the game options
	bonus_gold_self = bonus_gold_self * ( 1 + HERO_GOLD_BONUS / 100 )
	bonus_gold = bonus_gold * ( 1 + HERO_GOLD_BONUS / 100 )

	-- Decrease the extra gold by up to 50% if the target is on a deathstreak
	bonus_gold_self = bonus_gold_self * ( 1 - math.min(target.death_streak_count, 5) * 0.1 )
	bonus_gold = bonus_gold * ( 1 - math.min(target.death_streak_count, 5) * 0.1 )

	-- Find all valid friendly heroes within the bonus gold radius
	local bonus_gold_targets = FindUnitsInRadius(caster:GetTeam() , target:GetAbsOrigin(), nil, bonus_gold_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY , DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Grant bonus gold to the caster
	caster:ModifyGold(bonus_gold_self, true, 0)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, caster, bonus_gold_self, nil)

	-- Give gold to allies in the nearby area
	for _,ally in pairs(bonus_gold_targets) do
		if ally ~= caster then
			ally:ModifyGold(bonus_gold, true, 0)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD, ally, bonus_gold, nil)
		end
	end
end

function ShadowJaunt( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_jinada = caster:FindAbilityByName(keys.ability_jinada)
	local modifier_track = keys.modifier_track
	local modifier_track_scepter = keys.modifier_track_scepter
	local sound_cast = keys.sound_cast

	-- Blink geometry
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local direction = ( target_pos - caster_pos ):Normalized()
	target_pos = target_pos + direction * 50

	-- If the target is tracked, blink to it and proc Jinada.
	if target:HasModifier(modifier_track) or target:HasModifier(modifier_track_scepter) then

		-- Play sound
		caster:EmitSound(sound_cast)

		-- Blink
		FindClearSpaceForUnit(caster, target_pos, false)
		caster:SetForwardVector((target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() )
		
		-- Refresh Jinada and attack
		ability_jinada:EndCooldown()
		caster:SetAttacking(target)
	else
		ability:EndCooldown()
	end
end
