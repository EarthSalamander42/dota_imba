--[[	Author: Firetoad
		Date: 03.10.2015	]]

function RancorUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability

	_G.VENGEFUL_RANCOR = true
	_G.VENGEFUL_RANCOR_CASTER = caster
	_G.VENGEFUL_RANCOR_ABILITY = ability
	_G.VENGEFUL_RANCOR_TEAM = caster:GetTeam()
end

function MagicMissile( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_missile = keys.particle_missile
	local particle_rancor = keys.particle_rancor
	local modifier_rancor = keys.modifier_rancor
	
	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	-- Initialize the targets hit table
	caster.magic_missile_targets = nil
	caster.magic_missile_targets = {}
	caster.magic_missile_targets[1] = target

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Check if the target has Rancor stacks
	if target:HasModifier(modifier_rancor) then

		-- If yes, launch an undisjointable, vision-granting projectile
		local rancor_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_rancor,
			bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = speed,
			iVisionRadius = 400,
			iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

		ProjectileManager:CreateTrackingProjectile(rancor_projectile)

	-- Else, launch a regular projectile
	else
		local magic_missile_projectile = {
			Target = target,
			Source = caster,
			Ability = ability,
			EffectName = particle_missile,
			bDodgeable = true,
			bProvidesVision = false,
			iMoveSpeed = speed,
		--	iVisionRadius = 300,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
		}

		ProjectileManager:CreateTrackingProjectile(magic_missile_projectile)
	end
end

function MagicMissileHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local particle_rancor = keys.particle_rancor
	local modifier_rancor = keys.modifier_rancor
	
	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local rancor_damage = ability:GetLevelSpecialValueFor("rancor_damage", ability_level)
	local rancor_radius = ability:GetLevelSpecialValueFor("rancor_radius", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)

	-- Play the impact sound
	caster:EmitSound(sound_hit)

	-- Stun the target
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

	-- Fetch target's rancor stacks
	local rancor_stacks = target:GetModifierStackCount(modifier_rancor, caster)

	-- If this is the main target, increase damage dealt based on rancor stacks
	if target == caster.magic_missile_targets[1] then
		-- Calculate damage
		local total_damage = base_damage + rancor_damage * rancor_stacks

		-- Apply damage
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = total_damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Else, just deal normal damage
	else
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = base_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end

	-- Find nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, rancor_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_rancor) then

			-- Check if this enemy was already hit
			local already_hit = false
			for _,enemy_test in pairs(caster.magic_missile_targets) do
				if enemy_test == enemy then
					already_hit = true
				end
			end
			
			-- If the target wasn't hit, launch an undisjointable, vision-granting projectile
			if not already_hit then
				local rancor_projectile = {
					Target = enemy,
					Source = target,
					Ability = ability,
					EffectName = particle_rancor,
					bDodgeable = false,
					bProvidesVision = true,
					iMoveSpeed = speed,
					iVisionRadius = 400,
					iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}

				ProjectileManager:CreateTrackingProjectile(rancor_projectile)

				-- Add this target to the targets already hit list
				caster.magic_missile_targets[#caster.magic_missile_targets + 1] = enemy
			end
		end
	end
end

function WaveOfTerror( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_wave = keys.particle_wave
	
	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local length = ability:GetLevelSpecialValueFor("length", ability_level)
	local width = ability:GetLevelSpecialValueFor("width", ability_level)
	local vision_aoe = ability:GetLevelSpecialValueFor("vision_aoe", ability_level)
	local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Projectile geometry
	local caster_pos = caster:GetAbsOrigin()
	local direction = (target - caster_pos):Normalized()

	-- Launch projectile
	local wave_projectile = {
		Ability				= ability,
		EffectName			= particle_wave,
		vSpawnOrigin		= caster:GetAbsOrigin(),
		fDistance			= length,
		fStartRadius		= width,
		fEndRadius			= width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(wave_projectile)

	-- Vision geometry
	local current_distance = vision_aoe / 2
	local tick_rate = vision_aoe / speed / 2

	-- Provide vision along the projectile's path
	Timers:CreateTimer(0, function()
		local current_vision_location = caster_pos + direction * current_distance

		ability:CreateVisibilityNode(current_vision_location, vision_aoe, vision_duration)

		current_distance = current_distance + vision_aoe / 2
		if current_distance < length then
			return tick_rate
		end
	end)
end

function WaveOfTerrorHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_armor = keys.modifier_armor
	local modifier_terror = keys.modifier_terror
	local modifier_rancor = keys.modifier_rancor
	
	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Apply damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})

	-- Apply armor reduction
	ability:ApplyDataDrivenModifier(caster, target, modifier_armor, {})

	-- Apply terror if applicable
	if target:HasModifier(modifier_rancor) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_terror, {})
	end
end

function WaveOfTerrorTerror( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_terror = keys.modifier_terror
	local modifier_rancor = keys.modifier_rancor
	
	-- Parameters
	local rancor_amp = ability:GetLevelSpecialValueFor("rancor_amp", ability_level)
	local terror_angle = ability:GetLevelSpecialValueFor("terror_angle", ability_level)

	-- Fetch amount of rancor stacks
	local rancor_stacks = target:GetModifierStackCount(modifier_rancor, caster)

	-- Check if the caster is in view of the target
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()
	local direction = (caster_loc - target_loc):Normalized()
	local forward_vector = target:GetForwardVector()
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)

	-- If yes, apply the extra incoming damage debuff
	if angle <= ( terror_angle / 2 ) and target:CanEntityBeSeenByMyTeam(caster) then
		target:SetModifierStackCount(modifier_terror, caster, rancor_amp * rancor_stacks)

	-- Else, remove it
	else
		target:SetModifierStackCount(modifier_terror, caster, 0)
	end
end

function VengeanceAuraCritCleanup( keys )
	local caster = keys.caster
	local target = keys.attacker
	local modifier_crit = keys.modifier_crit

	target:RemoveModifierByName(modifier_crit)
end

function VengeanceAuraCrit( keys )
	local caster = keys.caster
	local target = keys.attacker
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_crit = keys.modifier_crit
	local modifier_rancor = keys.modifier_rancor
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
	local base_crit_damage = ability:GetLevelSpecialValueFor("base_crit_damage", ability_level)
	local rancor_crit_damage = ability:GetLevelSpecialValueFor("rancor_crit_damage", ability_level)

	-- Roll for the crit
	if RandomInt(1, 100) <= crit_chance then

		-- Initialize stack count
		local rancor_stacks = 0

		-- Find enemies in the aura's radius
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

		-- Count rancor stacks inside the aura's radius
		for _,enemy in pairs(enemies) do
			rancor_stacks = rancor_stacks + enemy:GetModifierStackCount(modifier_rancor, caster)
		end

		-- Grant appropriate critical damage bonus
		AddStacks(ability, caster, target, modifier_crit, base_crit_damage + rancor_crit_damage * rancor_stacks, true)
	end
end

function UpgradeSwapback( keys )
	local caster = keys.caster
	local ability_swapback = caster:FindAbilityByName(keys.ability_swapback)

	-- Upgrade the Swapback ability
	if ability_swapback then
		ability_swapback:SetLevel(1)
		ability_swapback:SetActivated(false)
	end
end

function NetherSwap( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_name = ability:GetName()
	local ability_swapback_name = keys.ability_swapback
	local ability_swapback = caster:FindAbilityByName(ability_swapback_name)
	local sound_swap = keys.sound_swap
	local particle_caster = keys.particle_caster
	local particle_target = keys.particle_target
	local particle_rancor = keys.particle_rancor
	local modifier_rancor = keys.modifier_rancor
	local scepter = HasScepter(caster)
	
	-- Parameters
	local rancor_radius = ability:GetLevelSpecialValueFor("rancor_radius", ability_level)
	local rancor_speed = ability:GetLevelSpecialValueFor("rancor_speed", ability_level)
	local tree_radius = ability:GetLevelSpecialValueFor("tree_radius", ability_level)
	local swapback_min_time = ability:GetLevelSpecialValueFor("swapback_min_time", ability_level)
	local swapback_max_time = ability:GetLevelSpecialValueFor("swapback_max_time", ability_level)
	local ministun_duration = ability:GetLevelSpecialValueFor("ministun_duration", ability_level)
	local cooldown_scepter = ability:GetLevelSpecialValueFor("cooldown_scepter", ability_level)

	-- Start the reduced cooldown if the caster has a scepter
	if scepter then
		ability:EndCooldown()
		ability:StartCooldown(cooldown_scepter * GetCooldownReduction(caster))
	end

	-- Ministun the target if it's an enemy
	if target:GetTeam() ~= caster:GetTeam() then
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = ministun_duration})		
	end

	-- Play sounds
	caster:EmitSound(sound_swap)
	target:EmitSound(sound_swap)

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)
	if target:GetTeam() == caster:GetTeam() then
		ProjectileManager:ProjectileDodge(target)
	end

	-- Play caster particle
	local caster_pfx = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

	-- Play target particle
	local target_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(target_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(target_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	-- Fetch positions
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()

	-- Adjust target's position if it is inside the enemy fountain
	local fountain_loc
	if target:GetTeam() == DOTA_TEAM_GOODGUYS then
		fountain_loc = Vector(7472, 6912, 512)
	else
		fountain_loc = Vector(-7456, -6938, 528)
	end
	if (caster_loc - fountain_loc):Length2D() < 1700 then
		caster_loc = fountain_loc + (target_loc - fountain_loc):Normalized() * 1700
	end

	-- Store initial position for swapback
	caster.nether_swap_start_position = caster_loc

	-- Launch initial position Rancor projectiles
	local start_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, rancor_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(start_enemies) do
		if enemy:HasModifier(modifier_rancor) then
			
			-- Launch an undisjointable, vision-granting projectile
			local rancor_projectile = {
				Target = enemy,
				Source = caster,
				Ability = ability,
				EffectName = particle_rancor,
				bDodgeable = false,
				bProvidesVision = true,
				iMoveSpeed = rancor_speed,
				iVisionRadius = 400,
				iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}

			ProjectileManager:CreateTrackingProjectile(rancor_projectile)
		end
	end

	-- Swap positions
	Timers:CreateTimer(0.01, function()
		FindClearSpaceForUnit(caster, target_loc, true)
		FindClearSpaceForUnit(target, caster_loc, true)
	end)

	-- Destroy trees around start and end areas
	GridNav:DestroyTreesAroundPoint(caster_loc, tree_radius, false)
	GridNav:DestroyTreesAroundPoint(target_loc, tree_radius, false)

	-- Launch final position Rancor projectiles
	local end_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, rancor_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	Timers:CreateTimer(0.05, function()
		for _,enemy in pairs(end_enemies) do
			if enemy:HasModifier(modifier_rancor) then
				
				-- Launch an undisjointable, vision-granting projectile
				local rancor_projectile = {
					Target = enemy,
					Source = caster,
					Ability = ability,
					EffectName = particle_rancor,
					bDodgeable = false,
					bProvidesVision = true,
					iMoveSpeed = rancor_speed,
					iVisionRadius = 400,
					iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}

				ProjectileManager:CreateTrackingProjectile(rancor_projectile)
			end
		end
	end)

	-- Activate swapback after [swapback_min_time] seconds
	Timers:CreateTimer(swapback_min_time, function()
		ability_swapback:SetActivated(true)
	end)

	-- Deactivate swapback after [swapback_max_time] seconds
	Timers:CreateTimer(swapback_max_time, function()
		ability_swapback:SetActivated(false)
	end)

end

function NetherSwapBack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_name = ability:GetName()
	local ability_swap_name = keys.ability_swap
	local ability_swap = caster:FindAbilityByName(ability_swap_name)
	local sound_swap = keys.sound_swap
	local particle_caster = keys.particle_caster
	
	-- If there is no return point, do nothing
	if not caster.nether_swap_start_position then
		return nil
	end

	-- Parameters
	local tree_radius = ability_swap:GetLevelSpecialValueFor("tree_radius", ability_swap:GetLevel() - 1)

	-- Play sound
	caster:EmitSound(sound_swap)

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Create dummy on the initial position
	local dummy_target = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, caster:GetTeamNumber())

	-- Play particle
	local swap_pfx = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(swap_pfx, 0, dummy_target, PATTACH_POINT_FOLLOW, "attach_hitloc", dummy_target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(swap_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	-- Swap positions
	FindClearSpaceForUnit(caster, caster.nether_swap_start_position, true)

	-- Destroy trees around start and end areas
	GridNav:DestroyTreesAroundPoint(caster:GetAbsOrigin(), tree_radius, false)
	GridNav:DestroyTreesAroundPoint(caster.nether_swap_start_position, tree_radius, false)

	-- Clean-up dummy and global
	caster.nether_swap_start_position = nil
	Timers:CreateTimer(0.01, function()
		dummy_target:Destroy()
	end)

	-- Deactivate the swapback ability
	ability:SetActivated(false)
end
