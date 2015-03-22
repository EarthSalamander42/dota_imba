--[[Author: hewdraw
	Date: 17-3-2015.]]

function DeathCoil( keys )
	-- Variables
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor( "target_damage" , ability_level  )
	local self_heal = ability:GetLevelSpecialValueFor( "self_heal" , ability_level  )
	local heal = ability:GetLevelSpecialValueFor( "heal_amount" , ability_level )
	local projectile_speed = ability:GetSpecialValueFor( "projectile_speed" )
	local particle_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
	
	local ability_frostmourne = caster:FindAbilityByName("imba_abaddon_frostmourne")
	local max_stacks = 1
	if ability_frostmourne:GetLevel() ~= 0 then
		max_stacks = ability_frostmourne:GetLevelSpecialValueFor("max_stacks", ability_frostmourne:GetLevel() - 1)
	end
	local modifier_debuff_base = "modifier_frostmourne_debuff_base"
	local modifier_debuff = "modifier_frostmourne_debuff"
	local modifier_buff_base = "modifier_frostmourne_buff_base"
	local modifier_buff = "modifier_frostmourne_buff"

	-- Play the ability sound
	caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
	target:EmitSound("Hero_Abaddon.DeathCoil.Target")

	-- If the target and caster are on a different team, do Damage. Heal otherwise
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		ApplyDamage({ victim = target, attacker = caster, damage = damage,	damage_type = DAMAGE_TYPE_MAGICAL })

		if target:HasModifier(modifier_debuff_base) then
			local stack_count = target:GetModifierStackCount(modifier_debuff, ability)

			if stack_count < max_stacks then
				ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
				target:SetModifierStackCount(modifier_debuff, ability, stack_count + 1)
			else
				ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
			end
		else
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
			target:SetModifierStackCount(modifier_debuff, ability, 1)
		end
	else
		if target ~= caster then
			target:Heal( heal, caster)
		end
		if target:HasModifier(modifier_buff_base) then
			local stack_count = target:GetModifierStackCount(modifier_buff, ability)

			if stack_count < max_stacks then
				ability:ApplyDataDrivenModifier(caster, target, modifier_buff_base, {})
				ability:ApplyDataDrivenModifier(caster, target, modifier_buff, {})
				target:SetModifierStackCount(modifier_buff, ability, stack_count + 1)
			else
				ability:ApplyDataDrivenModifier(caster, target, modifier_buff_base, {})
				ability:ApplyDataDrivenModifier(caster, target, modifier_buff, {})
				target:SetModifierStackCount(modifier_buff, ability, stack_count)
			end
		else
			ability:ApplyDataDrivenModifier(caster, target, modifier_buff_base, {})
			ability:ApplyDataDrivenModifier(caster, target, modifier_buff, {})
			target:SetModifierStackCount(modifier_buff, ability, 1)
		end
	end

	-- Self Heal
	caster:Heal( self_heal, caster)

	-- Create the projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_name,
		bDodgeable = false,
			bProvidesVision = true,
			iMoveSpeed = projectile_speed,
        iVisionRadius = 0,
        iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
	ProjectileManager:CreateTrackingProjectile( info )
end

function AphoticShield( keys )
	-- Variables
	local target = keys.target
	local caster = keys.caster
	local strentgh = caster.GetStrength(caster)
	local base_damage_absorb = keys.ability:GetLevelSpecialValueFor("damage_absorb", keys.ability:GetLevel() - 1 )
	local max_damage_absorb = base_damage_absorb + strentgh
	local shield_size = 75 -- could be adjusted to model scale

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

	-- Reset the shield
	target.AphoticShieldRemaining = max_damage_absorb

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		target.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(target.ShieldParticle, 1, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 2, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 4, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(target.ShieldParticle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(target.ShieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	end)
end

function AphoticShieldAbsorb( keys )
	-- Variables
	local damage = keys.DamageTaken
	local unit = keys.unit
	local ability = keys.ability
	
	-- Track how much damage was already absorbed by the shield
	local shield_remaining = unit.AphoticShieldRemaining

	-- If the damage is bigger than what the shield can absorb, heal a portion
	if unit:HasModifier("modifier_borrowed_time") == false then
		if damage > shield_remaining then
			unit:Heal(shield_remaining, unit)
		else			
			unit:Heal(damage, unit)
		end
	end

	-- Reduce the shield remaining and remove
	if unit:HasModifier("modifier_borrowed_time") == false then
		unit.AphoticShieldRemaining = unit.AphoticShieldRemaining - damage
		if unit.AphoticShieldRemaining <= 0 then
			unit.AphoticShieldRemaining = nil
			unit:RemoveModifierByName("modifier_aphotic_shield")
		end
	end
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function EndShieldParticle( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local strength = caster.GetStrength(caster)
	local base_damage_absorb = keys.ability:GetLevelSpecialValueFor("damage_absorb", ability_level )
	local max_damage_absorb = base_damage_absorb + strength
	local damageType = DAMAGE_TYPE_MAGICAL
	local radius = ability:GetLevelSpecialValueFor( "radius" , ability_level )

	target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
	ParticleManager:DestroyParticle(target.ShieldParticle,false)

	local enemies = FindUnitsInRadius(caster.GetTeam(caster), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	local ability_frostmourne = caster:FindAbilityByName("imba_abaddon_frostmourne")
	local max_stacks = 1
	if ability_frostmourne:GetLevel() ~= 0 then
		max_stacks = ability_frostmourne:GetLevelSpecialValueFor("max_stacks", ability_frostmourne:GetLevel() - 1)
	end
	local modifier_debuff_base = "modifier_frostmourne_debuff_base"
	local modifier_debuff = "modifier_frostmourne_debuff"

	for _,enemy in pairs(enemies) do
		ApplyDamage({ victim = enemy, attacker = caster, damage = max_damage_absorb, damage_type = damageType })
		if enemy:HasModifier(modifier_debuff_base) then
			local stack_count = enemy:GetModifierStackCount(modifier_debuff, ability)

			if stack_count < max_stacks then
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
				enemy:SetModifierStackCount(modifier_debuff, ability, stack_count + 1)
			else
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
				ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
			end
		else
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff_base, {})
			ability:ApplyDataDrivenModifier(caster, enemy, modifier_debuff, {})
			enemy:SetModifierStackCount(modifier_debuff, ability, 1)
		end
	end
end

-- Keeps track of the targets health
function AphoticShieldHealth( keys )
	local target = keys.target

	target.OldHealth = target:GetHealth()
end

function FrostMourne( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)
	local modifier_debuff_base = "modifier_frostmourne_debuff_base"
	local modifier_debuff = "modifier_frostmourne_debuff"
	local modifier_buff_base = "modifier_frostmourne_buff_base"
	local modifier_buff = "modifier_frostmourne_buff"


	if caster:HasModifier(modifier_buff_base) then
		local stack_count = caster:GetModifierStackCount(modifier_buff, ability)

		if stack_count < max_stacks then
			ability:ApplyDataDrivenModifier(caster, caster, modifier_buff_base, {})
			ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, {})
			caster:SetModifierStackCount(modifier_buff, ability, stack_count + 1)
		else
			ability:ApplyDataDrivenModifier(caster, caster, modifier_buff_base, {})
			ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff_base, {})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_buff, {})
		caster:SetModifierStackCount(modifier_buff, ability, 1)
	end
	if target:HasModifier(modifier_debuff_base) then
		local stack_count = target:GetModifierStackCount(modifier_debuff, ability)

		if stack_count < max_stacks then
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
			target:SetModifierStackCount(modifier_debuff, ability, stack_count + 1)
		else
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
			ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
		end
	else
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff_base, {})
		ability:ApplyDataDrivenModifier(caster, target, modifier_debuff, {})
		target:SetModifierStackCount(modifier_debuff, ability, 1)
	end
end

function FrostMourneAttacked( keys )
	local attacker = keys.attacker
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier_debuff_base = "modifier_frostmourne_debuff_base"
	local modifier_debuff = "modifier_frostmourne_debuff"
	local modifier_buff_base = "modifier_frostmourne_buff_base"
	local modifier_buff = "modifier_frostmourne_buff"

	local stack_count = target:GetModifierStackCount(modifier_debuff, ability)

	if attacker:HasModifier("modifier_frostmourne") == false then
		ability:ApplyDataDrivenModifier(caster, attacker, modifier_buff_base, {})
		ability:ApplyDataDrivenModifier(caster, attacker, modifier_buff, {})
		attacker:SetModifierStackCount(modifier_buff, ability, stack_count)
	end
end

function BorrowedTimeActivate( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local threshold = ability:GetLevelSpecialValueFor( "hp_threshold" , ability:GetLevel() - 1  )
	local cooldown = ability:GetCooldown( ability:GetLevel() )
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	local duration_scepter = ability:GetLevelSpecialValueFor( "duration_scepter" , ability:GetLevel() - 1  )
	local scepter = HasScepter(caster)

	-- Apply the modifier
	if ability:GetCooldownTimeRemaining() == 0 then
		if caster:GetHealth() < 400 then
			BorrowedTimePurge( keys )
			caster:EmitSound("Hero_Abaddon.BorrowedTime")
			ability:StartCooldown(cooldown)
		end
	end
end

function BorrowedTimeHeal( keys )
	-- Variables
	local damage = keys.DamageTaken
	local caster = keys.caster
	local ability = keys.ability
	local scepter = HasScepter(caster)
	local radius = keys.ability:GetLevelSpecialValueFor("redirect_range", ability:GetLevel() - 1 )

	local allies = FindUnitsInRadius(caster.GetTeam(caster), caster.GetAbsOrigin(caster), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	if scepter == true then
		caster:Heal(damage, caster)
		for _,unit in pairs(allies) do
			unit:Heal(damage / #allies, caster)
		end
	else
		caster:Heal(damage*2, caster)
	end
end

function BorrowedTimePurge( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	local duration_scepter = ability:GetLevelSpecialValueFor( "duration_scepter" , ability:GetLevel() - 1  )
	local scepter = HasScepter(caster)

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
	if scepter == true then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time", { duration = duration_scepter })
	else
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time", { duration = duration })
	end
end

function BorrowedTimeAllies( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_taken = keys.DamageTaken
	local redirect = ability:GetLevelSpecialValueFor("redirect", ability:GetLevel() - 1 )
	local unit = keys.attacker

	local redirect_damage = damage_taken * ( redirect / (1 - redirect) )
	
	ApplyDamage({ victim = caster, attacker = unit, damage = redirect_damage, damage_type = DAMAGE_TYPE_PURE })
end