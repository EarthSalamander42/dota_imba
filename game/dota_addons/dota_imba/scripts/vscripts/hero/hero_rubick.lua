--[[	Author: Firetoad
		Date: 25.10.2016	]]

function Telekinesis(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_ally = keys.modifier_ally
	local modifier_enemy = keys.modifier_enemy
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_lift = keys.particle_lift

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Parameters
	local ally_cooldown = ability:GetLevelSpecialValueFor("ally_cooldown", ability_level)
	local enemy_lift_time = ability:GetLevelSpecialValueFor("enemy_lift_time", ability_level)
	local ally_lift_time = ability:GetLevelSpecialValueFor("ally_lift_time", ability_level)
	local target_loc = target:GetAbsOrigin()

	-- Remember target's position for Telekinesis Land marking
	caster.telekinesis_target_position = target:GetAbsOrigin()
	caster.telekinesis_target_unit = target

	-- Play cast/target sounds
	caster:EmitSound(sound_cast)
	target:EmitSound(sound_target)

	-- Play lift particle
	local lift_pfx = ParticleManager:CreateParticle(particle_lift, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(lift_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(lift_pfx, 1, target_loc)

	-- Lift target
	target:SetAbsOrigin(target:GetAbsOrigin() + Vector(0, 0, 250))

	-- If this is an ally, just root them in place
	if target:GetTeam() == caster:GetTeam() then
		
		-- Apply root/phasing modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_ally, {})

		-- Trigger reduced cooldown
		ability:EndCooldown()
		ability:StartCooldown(ally_cooldown * GetCooldownReduction(caster))

		-- Adjust particle duration
		ParticleManager:SetParticleControl(lift_pfx, 2, Vector(ally_lift_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(lift_pfx)

	-- Else, stun them
	else

		-- Apply phasing/duration modifier
		ability:ApplyDataDrivenModifier(caster, target, modifier_enemy, {})

		-- Actually stun
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = enemy_lift_time})

		-- Play flailing animation
		StartAnimation(target, {activity = ACT_DOTA_FLAIL, rate = 1.0})

		-- Adjust particle duration
		ParticleManager:SetParticleControl(lift_pfx, 2, Vector(enemy_lift_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(lift_pfx)
	end

	-- Swap this ability with Telekinesis Land
	local land_ability = caster:FindAbilityByName("imba_rubick_telekinesis_land")
	if land_ability then
		caster:SwapAbilities(ability:GetAbilityName(), "imba_rubick_telekinesis_land", false, true)
	end
end

function TelekinesisLand(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_land = keys.sound_land
	local particle_land = keys.particle_land
	local particle_blink = keys.particle_blink
	
	-- Parameters
	local landing_knockup_duration = ability:GetLevelSpecialValueFor("landing_knockup_duration", ability_level)
	local landing_stun_duration = ability:GetLevelSpecialValueFor("landing_stun_duration", ability_level)
	local landing_stun_radius = ability:GetLevelSpecialValueFor("landing_stun_radius", ability_level)
	local landing_damage = ability:GetLevelSpecialValueFor("landing_damage", ability_level)
	local origin_loc = target:GetAbsOrigin()
	local target_loc = target:GetAbsOrigin()

	-- If there is a marked spot for landing, use it
	if caster.telekinesis_land_position then
		target_loc = caster.telekinesis_land_position
		caster.telekinesis_land_position = nil
	end

	-- Play landing sound
	target:EmitSound(sound_land)

	-- Play impact particle
	local landing_pfx = ParticleManager:CreateParticle(particle_land, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(landing_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(landing_pfx, 1, target_loc)
	ParticleManager:ReleaseParticleIndex(landing_pfx)

	-- Play blink particle, if necessary
	if origin_loc ~= target_loc then
		local blink_pfx = ParticleManager:CreateParticle(particle_blink, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blink_pfx, 0, origin_loc)
		ParticleManager:SetParticleControl(blink_pfx, 1, target_loc)
		ParticleManager:ReleaseParticleIndex(blink_pfx)
	end

	-- Stop the flailing animation
	EndAnimation(target)

	-- Destroy telekinesis marker particle
	if caster.telekinesis_marker_pfx then
		ParticleManager:DestroyParticle(caster.telekinesis_marker_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.telekinesis_marker_pfx)
	end
	caster.telekinesis_target_unit = nil
	caster.telekinesis_target_position = nil
	caster.telekinesis_marker_pfx = nil

	-- Destroy trees around the landing spot
	GridNav:DestroyTreesAroundPoint(target_loc, landing_stun_radius, false)

	-- Find a legal position for the main target
	FindClearSpaceForUnit(target, target_loc, true)

	-- Iterate through nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, landing_stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do
		
		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = landing_damage, damage_type = DAMAGE_TYPE_MAGICAL})

		-- If this is not the main target, stun it
		if enemy ~= target then
			
			-- Stun the enemy
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = landing_stun_duration})

			-- Knock it upwards
			local knockback =
			{	should_stun = 1,
				knockback_duration = landing_knockup_duration,
				duration = landing_knockup_duration,
				knockback_distance = 0,
				knockback_height = 60,
				center_x = target_loc.x,
				center_y = target_loc.y,
				center_z = target_loc.z
			}
			enemy:RemoveModifierByName("modifier_knockback")
			enemy:AddNewModifier(caster, ability, "modifier_knockback", knockback)
		end
	end

	-- Swap this ability with Telekinesis
	local land_ability = caster:FindAbilityByName("imba_rubick_telekinesis_land")
	if land_ability then
		caster:SwapAbilities(ability:GetAbilityName(), "imba_rubick_telekinesis_land", true, false)
	end
end

function TelekinesisMark(keys)
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_marker = keys.particle_marker
	
	-- Parameters
	local maximum_distance
	if caster.telekinesis_target_unit:GetTeam() == caster:GetTeam() then
		maximum_distance = ability:GetLevelSpecialValueFor("ally_land_distance", ability_level) + GetCastRangeIncrease(caster)
	else
		maximum_distance = ability:GetLevelSpecialValueFor("enemy_land_distance", ability_level) + GetCastRangeIncrease(caster)
	end

	-- If there's an existing marker particle already, destroy it
	if caster.telekinesis_marker_pfx then
		ParticleManager:DestroyParticle(caster.telekinesis_marker_pfx, false)
		ParticleManager:ReleaseParticleIndex(caster.telekinesis_marker_pfx)
	end

	-- If the marked distance is too great, limit it
	local marked_distance = (target - caster.telekinesis_target_position):Length2D()
	if marked_distance > maximum_distance then
		target = caster.telekinesis_target_position + (target - caster.telekinesis_target_position):Normalized() * maximum_distance
	end

	-- Draw marker particle
	caster.telekinesis_marker_pfx = ParticleManager:CreateParticleForTeam(particle_marker, PATTACH_CUSTOMORIGIN, nil, caster:GetTeam())
	ParticleManager:SetParticleControl(caster.telekinesis_marker_pfx, 0, target)
	ParticleManager:SetParticleControl(caster.telekinesis_marker_pfx, 1, Vector(3, 0, 0))
	ParticleManager:SetParticleControl(caster.telekinesis_marker_pfx, 2, caster.telekinesis_target_position)

	-- Update landing position
	caster.telekinesis_land_position = target
end