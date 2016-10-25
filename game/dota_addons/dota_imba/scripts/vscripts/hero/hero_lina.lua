--[[ 	Author: D2imba
		Date: 26.04.2015	]]

function DragonSlaveLevel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_aux = caster:FindAbilityByName(keys.ability_aux)
	local ability_fiery = caster:FindAbilityByName(keys.ability_fiery)
	local ability_fiery_aux = caster:FindAbilityByName(keys.ability_fiery_aux)

	-- Upgrades all auxiliary abilities to the proper level
	local ability_level = ability:GetLevel()
	ability_aux:SetLevel(ability_level)
	ability_fiery:SetLevel(ability_level)
	ability_fiery_aux:SetLevel(ability_level)
end

function BlazingAbilityLevel( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_fiery = caster:FindAbilityByName(keys.ability_fiery)

	-- Upgrades auxiliary abilities to the proper level
	local ability_level = ability:GetLevel()
	ability_fiery:SetLevel(ability_level)
end

function DragonSlave( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_aux = caster:FindAbilityByName(keys.ability_aux)
	local ability_level = ability:GetLevel() - 1
	local particle_projectile = keys.particle_projectile
	local sound_cast = keys.sound_cast

	-- Parameters
	local primary_speed = ability:GetLevelSpecialValueFor("primary_speed", ability_level)
	local primary_start_width = ability:GetLevelSpecialValueFor("primary_start_width", ability_level)
	local primary_end_width = ability:GetLevelSpecialValueFor("primary_end_width", ability_level)
	local primary_distance = ability:GetLevelSpecialValueFor("primary_distance", ability_level) + GetCastRangeIncrease(caster)
	local secondary_amount = ability:GetLevelSpecialValueFor("secondary_amount", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)

	-- Trashy Spell Steal workaround
	local secondary_speed = primary_speed * 0.5
	local secondary_start_width = primary_start_width
	local secondary_end_width = primary_end_width
	local secondary_distance = primary_distance * 0.5
	local ability_aux_level
	if not IsStolenSpell(caster) then
		ability_aux_level = ability_aux:GetLevel() - 1
		secondary_speed = ability_aux:GetLevelSpecialValueFor("secondary_speed", ability_aux_level)
		secondary_start_width = ability_aux:GetLevelSpecialValueFor("secondary_start_width", ability_aux_level)
		secondary_end_width = ability_aux:GetLevelSpecialValueFor("secondary_end_width", ability_aux_level)
		secondary_distance = ability_aux:GetLevelSpecialValueFor("secondary_distance", ability_aux_level)
	end
	
	local target_loc = keys.target_points[1]
	local caster_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Launch primary projectile
	local direction_center = (target_loc - caster_loc):Normalized()
	local projectile = {
		Ability				= ability,
		EffectName			= particle_projectile,
		vSpawnOrigin		= caster_loc,
		fDistance			= primary_distance,
		fStartRadius		= primary_start_width,
		fEndRadius			= primary_end_width,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit		= false,
		vVelocity			= direction_center * primary_speed,
		bProvidesVision		= false,
	}
	ProjectileManager:CreateLinearProjectile(projectile)

	-- Calculate secondary directions
	local angular_opening = 135
	local projectile_directions = {}
	for i = 1, secondary_amount do
		projectile_directions[i] = (RotatePosition(target_loc, QAngle(0, (-1) * angular_opening / 2 + (i - 1) * angular_opening / (secondary_amount - 1) , 0), target_loc + direction_center * primary_distance) - target_loc):Normalized()
	end

	-- Calculates how long should we wait for the secondary dragon slaves to spawn
	secondary_delay = secondary_delay + (target_loc - caster_loc):Length2D() / primary_speed

	-- Creates the three projectiles after a spawn_time delay
	Timers:CreateTimer(secondary_delay, function()
		
		-- Play the cast sound again
		caster:EmitSound(sound_cast)

		-- Launch the secondary projectiles
		for i = 1, secondary_amount do
			projectile = {
				Ability				= ability_aux,
				EffectName			= particle_projectile,
				vSpawnOrigin		= target_loc,
				fDistance			= secondary_distance,
				fStartRadius		= secondary_start_width,
				fEndRadius			= secondary_end_width,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bDeleteOnHit		= false,
				vVelocity			= projectile_directions[i] * secondary_speed,
				bProvidesVision		= false,
			}
			ProjectileManager:CreateLinearProjectile(projectile)
		end
	end)
end

function LightStrikeArray( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local particle_cast = keys.particle_cast
	local particle_blast = keys.particle_blast
	local sound_cast = keys.sound_cast
	local sound_blast = keys.sound_blast

	-- Parameters
	local aoe_radius = ability:GetLevelSpecialValueFor("aoe_radius", ability_level)
	local cast_delay = ability:GetLevelSpecialValueFor("cast_delay", ability_level)
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local secondary_delay = ability:GetLevelSpecialValueFor("secondary_delay", ability_level)
	local cast_range = ability:GetLevelSpecialValueFor("cast_range", ability_level) + GetCastRangeIncrease(caster)

	-- Calculate first blast geometry
	local target_loc = keys.target_points[1]
	local caster_loc = caster:GetAbsOrigin()
	local blast_direction = (target_loc - caster_loc):Normalized()
	local blast_positions = {}
	blast_positions[1] = caster_loc + blast_direction * aoe_radius

	-- Calculate the rest of the blasts' position
	local distance = aoe_radius
	local i = 2
	while (distance + aoe_radius * 0.5) < cast_range do
		blast_positions[i] = blast_positions[i-1] + blast_direction * aoe_radius * 0.75
		distance = distance + aoe_radius * 0.75
		i = i + 1
	end

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Play the cast particle, only to the caster's team
	for _,blast_loc in pairs(blast_positions) do
		local cast_pfx = ParticleManager:CreateParticleForTeam(particle_cast, PATTACH_CUSTOMORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(cast_pfx, 0, blast_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(aoe_radius * 2, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)
	end

	-- Blasting loop
	local blast_count = 1
	Timers:CreateTimer(cast_delay, function()

		-- Create a sound/visibility dummy
		local sound_dummy = CreateUnitByName("npc_dummy_unit", blast_positions[blast_count], false, caster, caster, caster:GetTeamNumber())

		-- Guarantee blast visibility by making the caster briefly visible
		caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 0.3)
		caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 0.3)

		-- Play the blast particle
		local blast_pfx = ParticleManager:CreateParticle(particle_blast, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(blast_pfx, 0, blast_positions[blast_count])
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(aoe_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(blast_pfx)

		-- Deal damage and stun
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), blast_positions[blast_count], nil, aoe_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		end

		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(blast_positions[blast_count], aoe_radius, false)

		-- Play the blast sound on the dummy, then destroy it
		sound_dummy:EmitSound(sound_blast)
		sound_dummy:Destroy()

		-- Increases blast count and checks if blasting should continue
		if blast_count < #blast_positions then
			blast_count = blast_count + 1
			return secondary_delay
		end
	end)
end

function FierySoul( keys )
	local caster = keys.caster
	local ability = keys.ability
	local cast_ability = keys.event_ability
	local modifier_stacks = keys.modifier_stacks
	local modifier_active = keys.modifier_active

	-- If this is Rubick and Fiery Soul is no longer present, do nothing and kill the modifiers
	if IsStolenSpell(caster) then
		if not caster:FindAbilityByName("imba_lina_fiery_soul") then
			caster:RemoveModifierByName("modifier_imba_fiery_soul")
			caster:RemoveModifierByName("modifier_imba_fiery_soul_stacks")
			caster:RemoveModifierByName("modifier_imba_fiery_soul_active")
			return nil
		end
	end

	-- If the ability is disabled by Break, do nothing
	if caster.break_duration_left then
		return nil
	end

	-- If this is an item-based ability, do nothing
	local should_grant_stack = false
	for i = 0, 16 do
		local test_ability = caster:GetAbilityByIndex(i)
		if test_ability and ( test_ability:GetName() == cast_ability:GetName() ) and cast_ability:GetManaCost(1) > 0 then
			should_grant_stack = true
			break
		end
	end

	-- If not, grant a stack of the buff, or mantain it if the skill is active
	if should_grant_stack then
		if caster:HasModifier(modifier_active) then
			if caster:HasModifier(modifier_stacks) then
				AddStacks(ability, caster, caster, modifier_stacks, 0, true)
			end
		else
			AddStacks(ability, caster, caster, modifier_stacks, 1, true)
		end
	end
end

function FierySoulActivate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local modifier_stacks = keys.modifier_stacks
	local modifier_active = keys.modifier_active
	local ability_q = caster:FindAbilityByName(keys.ability_q)
	local ability_q_fiery = keys.caster:FindAbilityByName(keys.ability_q_fiery)
	local ability_w = caster:FindAbilityByName(keys.ability_w)
	local ability_w_fiery = keys.caster:FindAbilityByName(keys.ability_w_fiery)
	local ability_e = caster:FindAbilityByName(keys.ability_e)
	local ability_e_fiery = keys.caster:FindAbilityByName(keys.ability_e_fiery)
	local ability_r = caster:FindAbilityByName(keys.ability_r)
	local ability_r_fiery = keys.caster:FindAbilityByName(keys.ability_r_fiery)

	-- If this is Rubick, do nothing
	if IsStolenSpell(caster) then
		return nil
	end

	-- If any of the abilities is missing, do nothing
	if not ability_q or not ability_q_fiery or not ability_w or not ability_w_fiery or not ability_e or not ability_e_fiery or not ability_r or not ability_r_fiery then
		return nil
	end

	-- If the caster does not have enough stacks, do nothing
	local active_stacks = ability:GetLevelSpecialValueFor("active_stacks", ability_level)
	local current_stacks = caster:GetModifierStackCount(modifier_stacks, ability)
	if current_stacks < active_stacks then
		return nil
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Remove 3 stacks of the buff
	if current_stacks <= 3 then
		caster:RemoveModifierByName(modifier_stacks)
	else
		AddStacks(ability, caster, caster, modifier_stacks, -3, false)
	end

	-- Grant active modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_active, {})

	-- Swap abilities
	caster:SwapAbilities(keys.ability_q, keys.ability_q_fiery, false, true)
	caster:SwapAbilities(keys.ability_w, keys.ability_w_fiery, false, true)
	caster:SwapAbilities(keys.ability_e, keys.ability_e_fiery, false, true)
	caster:SwapAbilities(keys.ability_r, keys.ability_r_fiery, false, true)
end

function FierySoulEnd( keys )
	local caster = keys.caster
	local ability_q = caster:FindAbilityByName(keys.ability_q)
	local ability_q_fiery = keys.caster:FindAbilityByName(keys.ability_q_fiery)
	local ability_w = caster:FindAbilityByName(keys.ability_w)
	local ability_w_fiery = keys.caster:FindAbilityByName(keys.ability_w_fiery)
	local ability_e = caster:FindAbilityByName(keys.ability_e)
	local ability_e_fiery = keys.caster:FindAbilityByName(keys.ability_e_fiery)
	local ability_r = caster:FindAbilityByName(keys.ability_r)
	local ability_r_fiery = keys.caster:FindAbilityByName(keys.ability_r_fiery)

	-- If any of the abilities is missing, do nothing
	if not ability_q or not ability_q_fiery or not ability_w or not ability_w_fiery or not ability_e or not ability_e_fiery or not ability_r or not ability_r_fiery then
		return nil
	end

	-- Swap abilities
	caster:SwapAbilities(keys.ability_q, keys.ability_q_fiery, true, false)
	caster:SwapAbilities(keys.ability_w, keys.ability_w_fiery, true, false)
	caster:SwapAbilities(keys.ability_e, keys.ability_e_fiery, true, false)
	caster:SwapAbilities(keys.ability_r, keys.ability_r_fiery, true, false)
end

function LagunaBlade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast

	-- Parameters
	local speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local start_width = ability:GetLevelSpecialValueFor("start_width", ability_level)
	local end_width = ability:GetLevelSpecialValueFor("end_width", ability_level)
	local total_length = ability:GetLevelSpecialValueFor("total_length", ability_level) + GetCastRangeIncrease(caster)
	local target_loc = keys.target:GetAbsOrigin()
	local caster_loc = caster:GetAbsOrigin()

	-- Play the cast sound
	caster:EmitSound(sound_cast)

	-- Throw out the projectile
	local direction = (target_loc - caster_loc):Normalized()
	ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		--EffectName		= "",
		vSpawnOrigin		= caster_loc,
		fDistance			= total_length,
		fStartRadius		= start_width,
		fEndRadius			= end_width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= direction * speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	} )
end

function LagunaBladeHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_hit = keys.sound_hit
	local scepter = HasScepter(caster)

	-- Parameters
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Play hit sound
	target:EmitSound(sound_hit)

	-- Calculate and deal damage
	if scepter then
		local int = caster:GetIntellect()
		local int_multiplier = ability:GetLevelSpecialValueFor("int_damage_scepter", ability_level)
		damage = damage + int * int_multiplier
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end
