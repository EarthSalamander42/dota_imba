--[[	Author: Firetoad
		Date: 23.10.2015	]]

function Strafe( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_cast = keys.sound_cast
	local modifier_active = keys.modifier_active
	local modifier_scepter = keys.modifier_scepter
	local scepter = HasScepter(caster)

	-- Play cast sound
	Timers:CreateTimer(0.01, function()
		caster:EmitSound(sound_cast)
	end)

	-- Apply relevant modifier
	if scepter then
		ability:ApplyDataDrivenModifier(caster, caster, modifier_scepter, {})
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier_active, {})
	end

	-- Clear previous Strafe target
	caster.strafe_target = nil

	-- If currently attacking a target, set it as the strafe target
	if caster:GetAttackTarget() then
		caster.strafe_target = caster:GetAttackTarget()
	end
end

function StrafeFire( keys )
	local caster = keys.caster

	-- Target variable
	local target = false

	-- If there is already a target, try to attack it
	if caster.strafe_target then

		-- Calculate target distance
		local target_distance = (caster.strafe_target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()

		-- If the target is in range, attack it
		if target_distance <= (caster:GetAttackRange() + 80) then
			target = caster.strafe_target

		-- Else, search for a new target
		else
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:GetAttackRange() + 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			
			-- Choose the nearest enemy
			if enemies[1] then
				target = enemies[1]
			end
		end

	-- If there's no current target, find a new one
	else
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:GetAttackRange() + 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
			
		-- Choose the nearest enemy
		if enemies[1] then
			target = enemies[1]
		end
	end

	-- If a target was successfully found, and attacking is possible, attack it
	if target and not ( caster:HasModifier("modifier_invisible") or caster:IsDisarmed() or caster:IsStunned() or caster:IsOutOfGame() ) then
		caster:PerformAttack(target, true, true, true, true, true)		
	end
end

function StrafeTargetUpdate( keys )
	local caster = keys.caster
	local target = keys.target

	-- Make the target the new strafe target
	caster.strafe_target = target
end

function SearingArrowsProjectile( keys )
	local caster = keys.caster
	local particle_arrow = keys.particle_arrow

	-- Change caster's attack projectile
	caster:SetRangedProjectileName(particle_arrow)
end

function SearingArrowsHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_impact = keys.sound_impact
	local modifier_debuff = keys.modifier_debuff

	-- Parameters
	local bonus_damage = ability:GetLevelSpecialValueFor("bonus_damage", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Play the impact sound
	target:EmitSound(sound_impact)

	-- Limit the amount of minus armor stacks
	if target:GetModifierStackCount(modifier_debuff, caster) >= max_stacks then
		AddStacks(ability, caster, target, modifier_debuff, 0, true)
	else
		AddStacks(ability, caster, target, modifier_debuff, 1, true)
	end

	-- Deal bonus damage
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = DAMAGE_TYPE_PHYSICAL})
end

function SearingArrowsParticle( keys )
	local target = keys.target
	local particle_debuff = keys.particle_debuff

	-- Create debuff particle
	target.searing_arrows_debuff_pfx = ParticleManager:CreateParticle(particle_debuff, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(target.searing_arrows_debuff_pfx, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function SearingArrowsParticleEnd( keys )
	local target = keys.target

	-- Destroy debuff particle
	ParticleManager:DestroyParticle(target.searing_arrows_debuff_pfx, false)
end

function SkeletonWalk( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast
	local modifier_dummy_invis = keys.modifier_dummy_invis
	local modifier_extra = keys.modifier_extra

	-- Parameters
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

	-- Play cast sound
	caster:EmitSound(sound_cast)

	-- Play cast particle
	local invis_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(invis_pfx, 0, caster:GetAbsOrigin())

	-- Remove lingering speed buff if present
	caster:RemoveModifierByName(modifier_extra)

	-- Apply invisibility modifier
	caster:AddNewModifier(caster, ability, "modifier_invisible", {duration = duration})

	-- Apply dummy invisibility modifier
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy_invis, {})
end

function DeathPact( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound_cast = keys.sound_cast
	local sound_target = keys.sound_target
	local particle_cast = keys.particle_cast
	local modifier_damage = keys.modifier_damage
	local modifier_health = keys.modifier_health
	local modifier_target = keys.modifier_target
	local scepter = HasScepter(caster)

	-- Parameters
	local duration_creep = ability:GetLevelSpecialValueFor("duration_creep", ability_level)
	local duration_hero = ability:GetLevelSpecialValueFor("duration_hero", ability_level)
	local damage_hero = ability:GetLevelSpecialValueFor("damage_hero", ability_level)
	local health_mult_hero = ability:GetLevelSpecialValueFor("health_mult_hero", ability_level)
	local damage_mult_hero = ability:GetLevelSpecialValueFor("damage_mult_hero", ability_level)
	local health_mult_creep = ability:GetLevelSpecialValueFor("health_mult_creep", ability_level)
	local damage_mult_creep = ability:GetLevelSpecialValueFor("damage_mult_creep", ability_level)

	-- Play cast sound
	Timers:CreateTimer(0.01, function()
		caster:EmitSound(sound_cast)
	end)

	-- Play target sound
	target:EmitSound(sound_target)

	-- Play cast particle
	local death_pact_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(death_pact_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(death_pact_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	-- Fetch target's maximum health
	local target_health = target:GetMaxHealth()

	-- Remove any pre-existing temporary Death Pact buff
	caster:RemoveModifierByName(modifier_damage)
	caster:RemoveModifierByName(modifier_health)

	-- Fetch caster initial health
	local initial_hp = caster:GetHealth()

	-- If the target is not a hero, kill it and apply the caster buff
	if not target:IsHero() then

		-- Calculate bonus stacks
		local bonus_damage = math.floor(target_health * damage_mult_creep / 100)
		local bonus_health = math.floor(target_health * health_mult_creep / 100)
		
		-- Kill the target
		target:Kill(ability, caster)

		-- Apply modifier stacks to the caster
		ability:ApplyDataDrivenModifier(caster, caster, modifier_damage, {duration = duration_creep})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_health, {duration = duration_creep})
		AddStacks(ability, caster, caster, modifier_damage, bonus_damage, true)
		AddStacks(ability, caster, caster, modifier_health, bonus_health, true)

		-- Force update caster's attributes
		caster:CalculateStatBonus()

	-- If the target is a hero, deal damage and apply both buffs
	else

		-- Calculate bonus stacks
		local bonus_damage = math.floor(target_health * damage_mult_hero / 100)
		local bonus_health = math.floor(target_health * health_mult_hero / 100)

		-- Apply modifier stacks to the caster
		ability:ApplyDataDrivenModifier(caster, caster, modifier_damage, {duration = duration_hero})
		ability:ApplyDataDrivenModifier(caster, caster, modifier_health, {duration = duration_hero})
		AddStacks(ability, caster, caster, modifier_damage, bonus_damage, true)
		AddStacks(ability, caster, caster, modifier_health, bonus_health, true)

		-- Force update caster's attributes
		caster:CalculateStatBonus()

		-- If the target is not an illusion or an ally, deal damage
		if target:IsRealHero() then
			if target:GetTeam() ~= caster:GetTeam() then
				-- If the caster has a scepter, apply the death pact modifier
				if scepter then
					ability:ApplyDataDrivenModifier(caster, target, modifier_target, {})
				end
				
				ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target_health * damage_hero / 100, damage_type = DAMAGE_TYPE_PURE})
			end
		
		-- If it's an illusion, simply kill it
		else
			ApplyDamage({attacker = caster, victim = target, ability = ability, damage = target_health * 10, damage_type = DAMAGE_TYPE_PURE})
		end
	end

	-- Adjust caster's health
	local bonus_hp = caster:GetModifierStackCount(modifier_health, caster) * 19
	caster:SetHealth( initial_hp + bonus_hp )
end

function DeathPactEnd( keys )
	local caster = keys.caster

	caster:CalculateStatBonus()
end

function DeathPactKill( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_bonus = keys.modifier_bonus

	-- Apply modifier stacks to the caster
	AddStacks(ability, caster, caster, modifier_bonus, 1, true)

	-- Force update caster's attributes
	caster:CalculateStatBonus()
end

function DeathPactDeath( keys )
	local caster = keys.unit
	local ability = keys.ability
	local modifier_pact = keys.modifier_pact

	-- Fetch current stacks
	local current_stacks = caster:GetModifierStackCount(modifier_pact, caster)

	-- Remove half of the stacks
	if current_stacks <= 1 then
		caster:RemoveModifierByName(modifier_pact)
	else
		caster:SetModifierStackCount(modifier_pact, caster, current_stacks - 1)
	end
end
