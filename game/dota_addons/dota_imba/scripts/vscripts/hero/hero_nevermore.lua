--[[    Author: Thorminator
		Date: 28.08.2016    ]]

-- Remove souls on death
function NecromasteryDeath(keys)
	local caster = keys.caster

	-- Check if requiem is learned
	local ability_requiem = caster:FindAbilityByName(keys.ability_requiem)
	if ability_requiem then
		if ability_requiem:GetLevel() > 0 then

			-- Requiem is responsible for soul release once it is learned
			return nil
		end
	end

	-- Otherwise reduce soul counter
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_souls = keys.modifier_souls
	local modifier_souls_dummy = keys.modifier_souls_dummy
	local soul_release = ability:GetLevelSpecialValueFor("soul_release", ability_level)
	local current_stack = caster:GetModifierStackCount(modifier_souls, caster)
	local current_dummy_stack = caster:GetModifierStackCount(modifier_souls_dummy, caster)
	local souls_lost = math.floor(current_stack * soul_release)
	if current_stack then
		caster:SetModifierStackCount(modifier_souls, caster, current_stack - souls_lost)
		caster:SetModifierStackCount(modifier_souls_dummy, caster, current_dummy_stack - souls_lost)
	end
end

-- Add permanent souls on kill
function NecromasteryKill(keys)
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_souls = keys.modifier_souls
	local modifier_souls_temp = keys.modifier_souls_temp
	local modifier_souls_dummy = keys.modifier_souls_dummy
	local particle_projectile = keys.particle_projectile
	local scepter = HasScepter(caster)

	-- Can't steal the soul of gingers
	if IsGinger(target) then
		return nil
	end
	
	-- Parameters
	local soul_projectile_speed = ability:GetLevelSpecialValueFor("soul_projectile_speed", ability_level)
	local creep_kill_souls = ability:GetLevelSpecialValueFor("creep_kill_souls", ability_level)
	local hero_kill_souls = ability:GetLevelSpecialValueFor("hero_kill_souls", ability_level)
	local max_souls = ability:GetLevelSpecialValueFor("max_souls", ability_level)
	if scepter then
		max_souls = ability:GetLevelSpecialValueFor("max_souls_scepter", ability_level)
	end

	-- Fire visual soul projectile
	local soul_projectile = {
		Target = caster,
		Source = target,
		Ability = ability,
		EffectName = particle_projectile,
		bDodgeable = false,
		bProvidesVision = false,
		iMoveSpeed = soul_projectile_speed,
	--	iVisionRadius = vision_radius,
	--	iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
	}
	ProjectileManager:CreateTrackingProjectile(soul_projectile)

	-- Check how many stacks should be granted, 0 for illusions
	local souls_gained = 0
	if target:IsRealHero() then
		souls_gained = hero_kill_souls
	elseif not target:IsIllusion() then
		souls_gained = creep_kill_souls
	end

	-- Calculate excess souls (to be converted to temporary)
	local current_souls = caster:GetModifierStackCount(modifier_souls, caster)
	local excess_souls = math.max(souls_gained - (max_souls - current_souls), 0)
	local souls_gained = souls_gained - excess_souls
	while excess_souls > 0 do
		ability:ApplyDataDrivenModifier(caster, caster, modifier_souls_temp, {})
		excess_souls = excess_souls - 1
	end

	-- Update true and dummy modifier counts
	AddStacks(ability, caster, caster, modifier_souls, souls_gained, false)
	AddStacks(ability, caster, caster, modifier_souls_dummy, souls_gained, false)
end

-- Give temporary souls upon dealing damage
function NecromasteryAttack(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local modifier_souls_temp = keys.modifier_souls_temp
	local particle_projectile = keys.particle_projectile

	-- If the ability is disabled (by break), do nothing
	if ability_level < 0 then
		return nil
	end

	-- Absorb souls only from enemy heroes
	if target:IsRealHero() and target:GetTeam() ~= caster:GetTeam() then

		-- Can't absorb the soul of gingers
		if IsGinger(target) then
			return nil
		end

		-- Parameters
		local soul_projectile_speed = ability:GetLevelSpecialValueFor("soul_projectile_speed", ability_level)
		local hero_attack_souls = ability:GetLevelSpecialValueFor("hero_attack_souls", ability_level)
		local harvest_levels_per_soul = ability:GetLevelSpecialValueFor("harvest_levels_per_soul", ability_level)

		-- Add temporary souls
		local total_souls = hero_attack_souls + math.floor(caster:GetLevel() / harvest_levels_per_soul)
		for i = 1, total_souls do
			ability:ApplyDataDrivenModifier(caster, caster, modifier_souls_temp, {})
		end

		-- Fire visual soul projectile
		local soul_projectile = {
			Target = caster,
			Source = target,
			Ability = ability,
			EffectName = particle_projectile,
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = soul_projectile_speed,
		--	iVisionRadius = vision_radius,
		--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile(soul_projectile)
	end
end

-- Increase dummy soul count
function NecromasteryDummySoulsUp(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_souls_dummy = keys.modifier_souls_dummy

	-- Parameters
	local temp_soul_duration = ability:GetLevelSpecialValueFor("temp_soul_duration", ability_level)

	-- Increase dummy soul counter's stack amount
	AddStacks(ability, caster, caster, modifier_souls_dummy, 1, false)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_souls_dummy, {duration = temp_soul_duration})
end

-- Decrease dummy soul count
function NecromasteryDummySoulsDown(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier_souls_temp = keys.modifier_souls_temp
	local modifier_souls_dummy = keys.modifier_souls_dummy

	-- If there are no more temporary souls, remove the dummy modifier
	if not caster:HasModifier(modifier_souls_temp) then
		caster:RemoveModifierByName(modifier_souls_dummy)

	-- Else, reduce the dummy modifier's count by 1
	else
		AddStacks(ability, caster, caster, modifier_souls_dummy, -1, false)
	end
end

-- Reset dummy soul count to the amount of real souls
function NecromasteryTempSoulsOver(keys)
	local caster = keys.caster
	local ability = keys.ability
	local modifier_souls = keys.modifier_souls
	local modifier_souls_dummy = keys.modifier_souls_dummy

	-- Fetch current amount of real souls
	local current_souls = caster:GetModifierStackCount(modifier_souls, caster)

	-- Re-apply dummy modifier (insist until it sticks, in case the caster is dead)
	Timers:CreateTimer(0, function()
		ability:ApplyDataDrivenModifier(caster, caster, modifier_souls_dummy, {})
		if caster:HasModifier(modifier_souls_dummy) then
			caster:SetModifierStackCount(modifier_souls_dummy, caster, current_souls)
		else
			return 0.1
		end
	end)
end

-- Called once for each unit affected by Presence of the Dark Lord
function DarkLordPresence(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_aura_dummy = keys.modifier_aura_dummy
	local modifier_souls_temp = keys.modifier_souls_temp
	local particle_projectile = keys.particle_projectile
	local ability_necromastery = caster:FindAbilityByName(keys.ability_necromastery)

	-- If this is not a real hero, GTFO 
	if not target:IsRealHero() then
		return nil
	end

	-- Can't steal the soul of gingers
	if IsGinger(target) then
		return nil
	end

	-- If the caster is visible to this target's team, show the debuff
	if target:CanEntityBeSeenByMyTeam(caster) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_aura_dummy, {})

		-- If the target is also visible to the caster, fire the visual soul projectile
		if caster:CanEntityBeSeenByMyTeam(target) then
			local soul_projectile = {
				Target = caster,
				Source = target,
				Ability = ability,
				EffectName = particle_projectile,
				bDodgeable = false,
				bProvidesVision = false,
				iMoveSpeed = 1500,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
			}
			ProjectileManager:CreateTrackingProjectile(soul_projectile)
		end
	
	-- Else, remove it
	else
		target:RemoveModifierByName(modifier_aura_dummy)
	end

	-- If Necromastery was not learned, do nothing
	if ability_necromastery:GetLevel() > 0 then

		-- Gain temporary souls
		local souls_per_tick = ability:GetLevelSpecialValueFor("souls_per_tick", ability_level)
		ability_necromastery:ApplyDataDrivenModifier(caster, caster, modifier_souls_temp, {})
	end
end

-- Toggles visibility of the Presence of the Dark Lord debuff on/off
function DarkLordDummyStart(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_aura_dummy = keys.modifier_aura_dummy

	-- If the caster is visible to this target's team, show the debuff
	if target:CanEntityBeSeenByMyTeam(caster) then
		ability:ApplyDataDrivenModifier(caster, target, modifier_aura_dummy, {})
	end
end

-- Removes the Presence of the Dark Lord debuff
function DarkLordDummyEnd(keys)
	local target = keys.target
	local modifier_aura_dummy = keys.modifier_aura_dummy

	target:RemoveModifierByName(modifier_aura_dummy)
end

--[[	Create a shadowraze at [point] with [radius], and [particle_raze].
		Returns the true if a hero was hit by this raze	]]
function ShadowrazeCreateRaze(keys, point, radius, particle_raze)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Fetch Presence of the Dark Lord's ability level, if existing
	local ability_dark_lord = caster:FindAbilityByName(keys.presence_of_the_dark_lord)
	local dark_lord_level
	if ability_dark_lord then
		dark_lord_level = ability_dark_lord:GetLevel()
	end

	-- Fetch Necromastery's ability level, if existing
	local ability_necromastery = caster:FindAbilityByName(keys.necromastery)
	local necromastery_level
	if ability_necromastery then
		necromastery_level = ability_necromastery:GetLevel()
	end

	-- Modifiers and effects
	local modifier_combo = keys.modifier_combo
	local modifier_souls_count = keys.modifier_souls_count
	local modifier_souls_temp = keys.modifier_souls_temp
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown
	local modifier_raze_refresh_cooldown = keys.modifier_raze_refresh_cooldown
	local sound_raze = keys.sound_raze

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("raze_damage", ability_level)
	local soul_damage_bonus = ability:GetLevelSpecialValueFor("soul_damage_bonus", ability_level)
	local souls = caster:GetModifierStackCount(modifier_souls_count, caster)
	local damage = base_damage + soul_damage_bonus * souls
	local damage_type = ability:GetAbilityDamageType()

	-- Raze particle
	local raze_pfx = ParticleManager:CreateParticle(particle_raze, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(raze_pfx, 0, point)
	ParticleManager:SetParticleControl(raze_pfx, 1, point)
	ParticleManager:ReleaseParticleIndex(raze_pfx)

	-- Raze sound (on dummy)
	local dummy = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, caster:GetTeamNumber())
	dummy:EmitSound(sound_raze)
	dummy:Destroy()

	-- Variable setup for raze
	local can_refresh = not caster:HasModifier(modifier_raze_refresh_cooldown)
	local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
	local hero_hit = false

	-- Find raze targets hit
	local enemies = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do

		-- Check for raze combos
		if enemy:IsRealHero() then

			-- Register that a hero was hit
			hero_hit = true

			-- Gain temporary souls if Necromastery is learned
			if ability_necromastery and necromastery_level > 0 and not IsGinger(enemy) then
				local hero_attack_souls = ability_necromastery:GetLevelSpecialValueFor("hero_attack_souls", necromastery_level - 1 )
				local harvest_levels_per_soul = ability_necromastery:GetLevelSpecialValueFor("harvest_levels_per_soul", necromastery_level - 1 )
				local total_souls = hero_attack_souls + math.floor(caster:GetLevel() / harvest_levels_per_soul)
				for i = 1, total_souls do
					ability_necromastery:ApplyDataDrivenModifier(caster, caster, modifier_souls_temp, {})
				end
			end

			-- Apply presence of the dark lord debuff if it is learned
			if ability_dark_lord and dark_lord_level > 0 then

				local dark_lord_max_stack_count = ability_dark_lord:GetLevelSpecialValueFor("raze_debuff_max_stacks", dark_lord_level - 1)
				local modifier_dark_lord = keys.modifier_dark_lord_raze
				local dark_lord_stack_count = 0

				-- Check if enemy is already debuffed
				if enemy:HasModifier(modifier_dark_lord) then
					dark_lord_stack_count = enemy:GetModifierStackCount(modifier_dark_lord, caster)
				end

				-- Increase stack count if below 3
				if dark_lord_stack_count < dark_lord_max_stack_count then
					dark_lord_stack_count = dark_lord_stack_count + 1
				end

				-- Remove and reapply debuff to refresh stack
				ability_dark_lord:ApplyDataDrivenModifier(caster, enemy, modifier_dark_lord, {})
				enemy:SetModifierStackCount(modifier_dark_lord, caster, dark_lord_stack_count)
			end

			-- Combos can only be performed if you have the other raze abilities
			local ability_near_raze = caster:FindAbilityByName(keys.near_raze)
			if ability_near_raze and caster:FindAbilityByName(keys.medium_raze) and caster:FindAbilityByName(keys.far_raze) then

				-- Add combo modifier stack to enemy
				local stack_count = 0
				if enemy:HasModifier(modifier_combo) then
					stack_count = enemy:GetModifierStackCount(modifier_combo, caster)

					-- Remove combo modifier to refresh its duration
					enemy:RemoveModifierByNameAndCaster(modifier_combo, caster)
				end
				ability_near_raze:ApplyDataDrivenModifier(caster, enemy, modifier_combo, {})
				stack_count = stack_count + 1
				enemy:SetModifierStackCount(modifier_combo, caster, stack_count)

				-- Check number of combo stacks on this enemy hero
				if stack_count >= 3 then

					-- Sufficient stacks for raze refresh
					if can_refresh and not no_cooldown_buff_active then

						-- Refresh razes, add cooldown modifier to caster and remove combo modifier
						RefreshRazes(keys)
						ability_near_raze:ApplyDataDrivenModifier(caster, caster, modifier_raze_refresh_cooldown, {})
						enemy:RemoveModifierByNameAndCaster(modifier_combo, caster)
					end
				end
			end
		end

		-- Apply damage AFTER combo check to allow combos on heroes that die from the raze damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = damage_type})
	end

	return hero_hit
end

-- Refresh all razes. 'keys' needs to contain the necessary ability names
function RefreshRazes(keys)
	RefreshAbilityIfPresent(keys.caster, keys.near_raze)
	RefreshAbilityIfPresent(keys.caster, keys.medium_raze)
	RefreshAbilityIfPresent(keys.caster, keys.far_raze)
end

-- Update levels of all shadowraze abilities when leveling one of them
function ShadowrazeLeveled(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel()

	-- Update internal level variable
	if not caster.shadowraze_level then
		caster.shadowraze_level = 1
	elseif caster.shadowraze_level == ability_level then
		return nil
	else
		caster.shadowraze_level = ability_level
	end

	-- Set levels of all shadowraze abilities
	SetAbilityLevelIfPresent(caster, keys.near_raze, ability_level)
	SetAbilityLevelIfPresent(caster, keys.medium_raze, ability_level)
	SetAbilityLevelIfPresent(caster, keys.far_raze, ability_level)
end

function Shadowraze1Cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_raze = keys.particle_raze
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local raze_point = caster:GetAbsOrigin()

	-- Create the raze and track if a hero was hit
	local hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius, particle_raze)

   -- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
	local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
	if no_cooldown_buff_active then
		if hero_hit then
			RefreshRazes(keys)
		else
			caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
		end
	end 
end

function Shadowraze2Cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_raze = keys.particle_raze
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local distance = ability:GetLevelSpecialValueFor("distance", ability_level)
	local raze_amount = ability:GetLevelSpecialValueFor("raze_amount", ability_level)

	-- Find raze points
	local raze_point
	local caster_loc = caster:GetAbsOrigin()
	local forward_vector = caster:GetForwardVector()
	local hero_hit = false
	local side_razes = (raze_amount - 1) * 0.5
	for i = -side_razes, side_razes do
		raze_point = RotatePosition(caster_loc, QAngle(0, i * 60, 0), caster_loc + forward_vector * distance)

		-- Create raze and track if a hero has been hit
		hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius, particle_raze) or hero_hit
	end

	-- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
	local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
	if no_cooldown_buff_active then
		if hero_hit then
			RefreshRazes(keys)
		else
			caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
		end
	end
end

function Shadowraze3Cast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown

	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("initial_radius", ability_level)
	local distance = ability:GetLevelSpecialValueFor("initial_distance", ability_level)
	local radius_inc_per_raze = ability:GetLevelSpecialValueFor("radius_inc_per_raze", ability_level)
	local raze_amount = ability:GetLevelSpecialValueFor("raze_amount", ability_level)

	-- Shadowraze 3 particles
	local raze_particles = {
		"particles/hero/nevermore/nevermore_shadowraze_150.vpcf",
		"particles/hero/nevermore/nevermore_shadowraze_200.vpcf",
		"particles/hero/nevermore/nevermore_shadowraze_250.vpcf",
		"particles/hero/nevermore/nevermore_shadowraze_300.vpcf"
	}

	-- Find raze points
	local raze_point
	local caster_loc = caster:GetAbsOrigin()
	local forward_vector = caster:GetForwardVector()
	local hero_hit = false
	for i = 1, raze_amount do
		raze_point = caster_loc + forward_vector * distance

		-- Create raze and track if a hero has been hit
		hero_hit = ShadowrazeCreateRaze(keys, raze_point, radius, raze_particles[i]) or hero_hit

		-- Update for next raze
		distance = distance + 2 * radius + radius_inc_per_raze
		radius = radius + radius_inc_per_raze
	end

	-- If caster has the no cd buff, refresh all razes if an enemy was hit. Remove buff if not.
	local no_cooldown_buff_active = caster:HasModifier(modifier_raze_no_cooldown)
	if no_cooldown_buff_active then
		if hero_hit then
			RefreshRazes(keys)
		else
			caster:RemoveModifierByNameAndCaster(modifier_raze_no_cooldown, caster)
		end
	end
end

function RequiemCast(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_aux = caster:FindAbilityByName(keys.ability_aux)
	local ability_level = ability:GetLevel() - 1
	local modifier_temp_souls = keys.modifier_temp_souls
	local modifier_souls_counter = keys.modifier_souls_counter
	local modifier_temp_souls_counter = keys.modifier_temp_souls_counter
	local particle_caster = keys.particle_caster_souls
	local particle_ground = keys.particle_caster_ground
	local particle_lines = keys.particle_lines
	local death_cast = keys.death_cast
	local scepter = HasScepter(caster)

	-- Parameters
	local soul_conversion = ability:GetLevelSpecialValueFor("soul_conversion", ability_level)
	local line_width_start = ability:GetLevelSpecialValueFor("line_width_start", ability_level)
	local line_width_end = ability:GetLevelSpecialValueFor("line_width_end", ability_level)
	local line_speed = ability:GetLevelSpecialValueFor("line_speed", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local soul_death_release = ability:GetLevelSpecialValueFor("soul_death_release", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local scepter_release_time = radius / line_speed
	local souls

	-- If this was cast on death, we are responsible for removing souls
	if death_cast == 1 then

		-- Reduce real soul counter by half
		local current_stack = caster:GetModifierStackCount(modifier_souls_counter, caster)
		local current_dummy_stack = caster:GetModifierStackCount(modifier_temp_souls_counter, caster)
		local souls_lost = math.floor(current_stack * soul_death_release)
		if current_stack then
			caster:SetModifierStackCount(modifier_souls_counter, caster, current_stack - souls_lost)
			caster:SetModifierStackCount(modifier_temp_souls_counter, caster, current_dummy_stack - souls_lost)
		end
	end

	-- Get number of souls. Uses Necromastery's maximum soul amount instead of current souls for nonstandard heroes, like Rubick, pugna ward, or in Random OMG. (yeah, hardcoded, blah blah sue me)
	if not caster:FindAbilityByName("imba_nevermore_necromastery") then
		if scepter then
			souls = 46
		else
			souls = 36
		end
	else
		souls = caster:GetModifierStackCount(modifier_temp_souls_counter, caster)
	end

	-- Remove all temporary souls. They are consumed regardless of death
	local real_souls = caster:GetModifierStackCount(modifier_souls_counter, caster)
	local temp_souls = math.max(souls - real_souls, 0)
	if temp_souls > 0 then
		for i = 1, temp_souls do
			caster:RemoveModifierByName(modifier_temp_souls)
		end
	end

	-- If this was a death cast, use only real souls
	if death_cast == 1 then
		souls = real_souls
	end
	local lines = math.floor(souls * soul_conversion)

	-- Sound and particle effects
	caster:EmitSound(keys.requiem_cast_sound)
	local pfx_caster = ParticleManager:CreateParticle(particle_caster, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx_caster, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_caster, 1, Vector(lines, 0, 0))
	ParticleManager:SetParticleControl(pfx_caster, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx_caster)
	local pfx_ground = ParticleManager:CreateParticle(particle_ground, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx_caster, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_ground, 1, Vector(lines, 0, 0))
	ParticleManager:ReleaseParticleIndex(pfx_ground)
	local pfx_line

	-- Create projectiles
	local forward_vector = caster:GetForwardVector()
	local line_targets = {}
	local next_line_target
	local next_line_velocity
	local projectile_info
	local pfx_projectile
	for i = 0, (lines - 1) do

		-- Find points to fire projectiles at
		next_line_target = RotatePosition(caster_loc, QAngle(0, i * 360 / lines, 0), caster_loc + forward_vector * radius)
		line_targets[i] = next_line_target

		-- Calculate velocity from point vectors and speed
		next_line_velocity = (next_line_target - caster_loc):Normalized() * line_speed
		projectile_info = {
			Ability = ability,
			EffectName = "",
			vSpawnOrigin = caster_loc,
			fDistance = radius,
			fStartRadius = line_width_start,
			fEndRadius = line_width_end,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit = false,
			vVelocity = next_line_velocity,
			bProvidesVision = false
		}

		-- Create the projectile
		ProjectileManager:CreateLinearProjectile(projectile_info)

		-- Create the particle
		pfx_line = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(pfx_line, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(pfx_line, 1, next_line_velocity)
		ParticleManager:SetParticleControl(pfx_line, 2, Vector(0, scepter_release_time, 0))
		ParticleManager:ReleaseParticleIndex(pfx_line)
	end

	-- Do scepter effect if we have it and it was not a death cast
	if scepter and ability_aux and death_cast == 0 then
		local next_line_direction
		local next_line_length
		local next_line_particle_duration
		Timers:CreateTimer(scepter_release_time, function()

			-- Update caster location in case he has moved
			caster_loc = caster:GetAbsOrigin()

			-- Go through the targets from before and create projectiles that fly back to caster
			for i, line_target in pairs(line_targets) do
				next_line_direction = caster_loc - line_target
				next_line_length = next_line_direction:Length()
				next_line_velocity = next_line_direction:Normalized() * next_line_length / scepter_release_time
				projectile_info = {
					Ability = ability_aux,
					EffectName = "",
					vSpawnOrigin = line_target,
					fDistance = next_line_length,
					fStartRadius = line_width_start,
					fEndRadius = line_width_end,
					Source = caster,
					bHasFrontalCone = false,
					bReplaceExisting = false,
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					bDeleteOnHit = false,
					vVelocity = next_line_velocity,
					bProvidesVision = false
				}

				-- Create the projectile
				ProjectileManager:CreateLinearProjectile(projectile_info)

				-- Create the particle
				pfx_line = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(pfx_line, 0, line_target)
				ParticleManager:SetParticleControl(pfx_line, 1, next_line_velocity)
				ParticleManager:SetParticleControl(pfx_line, 2, Vector(0, scepter_release_time, 0))
				ParticleManager:ReleaseParticleIndex(pfx_line)
			end
		end)
	end
end

function RequiemProjectileHitOutward(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_enemy = keys.modifier_enemy
	local modifier_screen = keys.modifier_enemy_screen
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown
	local scepter = HasScepter(caster)

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("line_damage", ability_level)
	local raze_no_cd_duration_base = ability:GetLevelSpecialValueFor("raze_no_cd_duration_base", ability_level)
	local raze_no_cd_duration_stack = ability:GetLevelSpecialValueFor("raze_no_cd_duration_stack", ability_level)

	-- Apply enemy modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})

	-- Apply dark screen modifier if the caster has a scepter
	if scepter then
		ability:ApplyDataDrivenModifier(caster, target, modifier_screen, {})
	end

	-- Apply damage
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

	-- Apply no raze cooldown modifier to caster
	if target:IsRealHero() then

		-- If this is the first instance of the buff, apply its initial duration
		if not caster:HasModifier(modifier_raze_no_cooldown) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = raze_no_cd_duration_base})

		-- Else, increase its duration by the stacking amount
		else
			local raze_modifier = caster:FindModifierByName(modifier_raze_no_cooldown)
			local remaining_duration = raze_modifier:GetRemainingTime()
			ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = remaining_duration + raze_no_cd_duration_stack})
		end
	end
end

function RequiemProjectileHitInward(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = caster:FindAbilityByName(keys.ability_main)

	-- If the ability is gone (e.g. Random OMG), do nothing
	if not ability then
		return nil
	end

	local ability_level = ability:GetLevel() - 1
	local modifier_enemy = keys.modifier_enemy
	local modifier_raze_no_cooldown = keys.modifier_raze_no_cooldown
	local caster_health = caster:GetHealth()    

	-- Parameters
	local raze_no_cd_duration_base = ability:GetLevelSpecialValueFor("raze_no_cd_duration_base", ability_level)
	local raze_no_cd_duration_stack = ability:GetLevelSpecialValueFor("raze_no_cd_duration_stack", ability_level)
	local heal_factor = ability:GetLevelSpecialValueFor("heal_pct_scepter", ability_level) * 0.01
	local damage = ability:GetLevelSpecialValueFor("line_damage", ability_level) * heal_factor

	-- Apply enemy modifier
	ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})

	-- Damage & Healing
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	caster:Heal(damage, caster)

	-- Apply no raze cooldown modifier to caster
	if target:IsRealHero() then

		-- If this is the first instance of the buff, apply its initial duration
		if not caster:HasModifier(modifier_raze_no_cooldown) then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = raze_no_cd_duration_base})

		-- Else, increase its duration by the stacking amount
		else
			local raze_modifier = caster:FindModifierByName(modifier_raze_no_cooldown)
			local remaining_duration = raze_modifier:GetRemainingTime()
			ability:ApplyDataDrivenModifier(caster, caster, modifier_raze_no_cooldown, {duration = remaining_duration + raze_no_cd_duration_stack})
		end
	end
end

function RequiemDebuffCreated( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_screen = keys.particle_screen

	-- Play particle to hero owners
	if target:IsRealHero() then
		target.requiem_screen_particle = ParticleManager:CreateParticleForPlayer(particle_screen, PATTACH_EYES_FOLLOW, target, PlayerResource:GetPlayer(target:GetPlayerID()))
	end
end

function RequiemDebuffDestroyed( keys )
	local target = keys.target

	-- Destroy particle
	if target.requiem_screen_particle then
		ParticleManager:DestroyParticle(target.requiem_screen_particle, true)
	end
end

function ShadowrazeNoCooldownBuffCreated(keys)
	RefreshRazes(keys)
end