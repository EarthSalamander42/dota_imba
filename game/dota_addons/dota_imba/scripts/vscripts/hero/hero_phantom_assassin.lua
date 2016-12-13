--[[	Authors: D2imba and Pizzalol
		Date: 23.05.2015				]]

function StiflingDaggerHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_crit = caster:FindAbilityByName(keys.ability_crit)
	local modifier_crit = keys.modifier_crit
	local modifier_stacks = keys.modifier_stacks
	local modifier_kill = keys.modifier_kill
	local modifier_silence = keys.modifier_silence
	local modifier_slow = keys.modifier_slow
	local modifier_damage = keys.modifier_damage
	local scepter = HasScepter(caster)
	
	-- If the target possesses a ready Linken's Sphere, do nothing else
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Apply slow and silence modifiers
	if not target:IsMagicImmune() then
		ability:ApplyDataDrivenModifier(caster, target, modifier_silence, {})
		ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {})
	end
	
	-- If coup de grace is learned, roll for crits and instant kills
	local rand = math.random
	if ability_crit and ability_crit:GetLevel() > 0 then

		-- Crit parameters
		local ability_level = ability_crit:GetLevel() - 1
		local crit_chance = ability_crit:GetLevelSpecialValueFor("crit_chance", ability_level)
		local crit_increase = ability_crit:GetLevelSpecialValueFor("crit_increase", ability_level)
		local kill_chance = ability_crit:GetLevelSpecialValueFor("crit_chance_scepter", ability_level)

		-- Calculate actual crit chance
		crit_chance = crit_chance + crit_increase * caster:GetModifierStackCount(modifier_stacks, caster)

		-- Roll for crits
		if scepter and rand(100) < kill_chance then
			ability_crit:ApplyDataDrivenModifier(caster, caster, modifier_kill, {})
		elseif rand(100) < crit_chance then
			ability_crit:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
		end
	end

	-- Apply bonus damage modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_damage, {})

	-- Attack (calculates on-hit procs)
	local initial_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	caster:SetAbsOrigin(target_pos)
	caster:PerformAttack(target, true, true, true, true, true)
	caster:SetAbsOrigin(initial_pos)
end

function PhantomStrike( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_phantom_strike = keys.modifier_phantom_strike
	local modifier_stacks = keys.modifier_stacks
	local sound_start = keys.sound_start
	local sound_end = keys.sound_end
	local particle_end = keys.particle_end

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end
	
	-- Remove crit chance bonus modifier
	caster:RemoveModifierByName(modifier_stacks)

	-- Parameters
	local blink_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local blink_width = ability:GetLevelSpecialValueFor("projectile_width", ability_level)

	-- Trajectory calculations
	local caster_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
	local direction = ( target_pos - caster_pos ):Normalized()
	local distance = ( target_pos - caster_pos ):Length2D()
	target_pos = caster_pos + direction * ( distance + 50 )

	-- Launch a projectile to detect enemies in the blink path
	local blink_projectile = {
		Ability				= ability,
	--	EffectName			= "",
		vSpawnOrigin		= caster_pos,
		fDistance			= distance,
		fStartRadius		= blink_width,
		fEndRadius			= blink_width,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
	--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= Vector(direction.x, direction.y, 0) * blink_speed,
		bProvidesVision		= false,
	--	iVisionRadius		= ,
	--	iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	ProjectileManager:CreateLinearProjectile(blink_projectile)

	-- Fire blink start sound
	caster:EmitSound(sound_start)

	-- Blink
	FindClearSpaceForUnit(caster, target_pos, true)
	caster:SetForwardVector( (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() )

	-- Disjoint projectiles
	ProjectileManager:ProjectileDodge(caster)

	-- Fire blink particle
	local blink_pfx = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN_FOLLOW, caster)

	-- Fire blink end sound
	target:EmitSound(sound_end)

	-- Apply blink strike modifier on caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier_phantom_strike, {})

	-- If cast on an enemy, immediately start attacking it
	if caster:GetTeam() ~= target:GetTeam() then
		caster.phantom_strike_target = target
		caster:SetAttacking(target)
		caster:SetForceAttackTarget(target)
		Timers:CreateTimer(0.01, function()
			caster:SetForceAttackTarget(nil)
		end)
	end
end

function PhantomStrikeHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local modifier_crit = keys.modifier_crit
	local modifier_stacks = keys.modifier_stacks
	local sound_kill = keys.sound_kill
	local scepter = HasScepter(caster)
	local ability_crit = caster:FindAbilityByName(keys.ability_crit)
	local ability_level
	if ability_crit then
		ability_level = ability_crit:GetLevel() - 1
	end

	-- If coup de grace is learned, roll for crits and instant kills
	local rand = math.random
	if ability_crit then

		-- Crit parameters
		local crit_chance = ability_crit:GetLevelSpecialValueFor("crit_chance", ability_level)
		local crit_increase = ability_crit:GetLevelSpecialValueFor("crit_increase", ability_level)
		local kill_chance = ability_crit:GetLevelSpecialValueFor("crit_chance_scepter", ability_level)

		-- Increase amount of crit stacks
		local max_stacks = 100
		if caster:HasModifier(modifier_stacks) then
			local current_stacks = caster:GetModifierStackCount(modifier_stacks, ability_crit)
			if current_stacks + crit_increase <= max_stacks then
				AddStacks(ability_crit, caster, caster, modifier_stacks, crit_increase, true)
			else
				AddStacks(ability_crit, caster, caster, modifier_stacks, max_stacks - current_stacks, true)
			end			
		else
			AddStacks(ability_crit, caster, caster, modifier_stacks, crit_chance + crit_increase, true)
		end

		-- Roll for kill chance if the caster has a scepter
		if scepter and rand(100) <= kill_chance then
			TrueKill(caster, target, ability_crit)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, 999999, nil)

			-- Global effect when killing a real hero
			if target:IsRealHero() then

				-- Play screen blood particle
				local blood_pfx = ParticleManager:CreateParticle("particles/hero/phantom_assassin/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)

				-- Play fatality message
				Notifications:BottomToAll({text = "#coup_de_grace_fatality", duration = 4.0, style = {["font-size"] = "50px", color = "Red"} })

				-- Play global sounds
				EmitGlobalSound(sound_kill)
				EmitGlobalSound("Imba.PhantomAssassinFatality")
				return nil
			end
		end

		-- Roll for normal crit chance
		if rand(100) <= crit_chance then
			ability_crit:ApplyDataDrivenModifier(caster, caster, modifier_crit, {})
		end
	end

	-- Attack (calculates on-hit procs)
	if target ~= caster.phantom_strike_target then
		local initial_pos = caster:GetAbsOrigin()
		local target_pos = target:GetAbsOrigin()
		caster:SetAbsOrigin(target_pos)
		caster:PerformAttack(target, true, true, true, true, true)
		caster:SetAbsOrigin(initial_pos)
	end
end

function Blur( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_blur = keys.modifier_blur
	local main_modifier = keys.main_modifier
	
	-- If caster's passives are disabled, remove buffs and stop
	if caster:PassivesDisabled() then
		caster:RemoveModifierByName(modifier_blur)		
		caster:RemoveModifierByName(main_modifier)			
		return nil
	end
	
	-- Parameters
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)	
	
	-- Detect nearby enemies
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- If there is at least one, apply the blur modifier
	if #nearby_enemies > 0 and not caster:HasModifier(modifier_blur) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_blur, {})

	-- Else, if there are no enemies, remove the modifier
	elseif #nearby_enemies == 0 and caster:HasModifier(modifier_blur) then
		caster:RemoveModifierByName(modifier_blur)
	end
end

function BlurSelfCheck ( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_blur = keys.modifier_blur
	local main_modifier = keys.main_modifier
	
	-- If caster's passives are not disabled and it doesn't have them, apply buffs
	if not caster:PassivesDisabled() and not caster:HasModifier(main_modifier) then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_blur, {})
		ability:ApplyDataDrivenModifier(caster, caster, main_modifier, {})
	end
	
	
end

function BlurStart( keys )
	--local caster = keys.caster
end

function BlurEnd( keys )
	--local caster = keys.caster
end	
	
function CoupDeGrace( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local scepter = HasScepter(caster)

	-- If the target is not a hero, creep, or siege unit, do nothing
	if not target:IsHero() and not target:IsCreep() then
		return nil
	end

	-- If caster's passives are disabled by break, do nothing
	if caster:PassivesDisabled() then
		return nil
	end
	
	-- Parameters
	local crit_chance = ability:GetLevelSpecialValueFor("crit_chance", ability_level)
	local kill_chance = ability:GetLevelSpecialValueFor("crit_chance_scepter", ability_level)
	local stack_modifier = keys.stack_modifier
	local crit_modifier = keys.crit_modifier
	local kill_modifier = keys.kill_modifier

	-- Roll for scepter instant kill
	local rand = math.random
	if scepter and rand(100) <= kill_chance then
		ability:ApplyDataDrivenModifier(caster, caster, kill_modifier, {})
		return nil
	end

	-- Calculate actual chance to crit
	local actual_crit_chance = crit_chance
	if caster:HasModifier(stack_modifier) then
		actual_crit_chance = caster:GetModifierStackCount(stack_modifier, ability)
	end

	-- RNGESUS ES MI PASTOR
	if rand(100) <= actual_crit_chance then
		ability:ApplyDataDrivenModifier(caster, caster, crit_modifier, {})
	end
end

function CoupDeGraceKill( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local sound_kill = keys.sound_kill

	TrueKill(caster, target, ability)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, 999999, nil)

	-- Global effect when killing a real hero
	if target:IsRealHero() then
		
		-- Play screen blood particle
		local blood_pfx = ParticleManager:CreateParticle("particles/hero/phantom_assassin/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)

		-- Play fatality message
		Notifications:BottomToAll({text = "#coup_de_grace_fatality", duration = 4.0, style = {["font-size"] = "50px", color = "Red"} })

		-- Play global sounds
		EmitGlobalSound(sound_kill)
		EmitGlobalSound("Imba.PhantomAssassinFatality")
	end
end