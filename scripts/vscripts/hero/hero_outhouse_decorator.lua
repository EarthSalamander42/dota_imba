--[[ 	Author: Hewdraw
		Date: 17.05.2015	]]

function ArcaneOrb( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local int_gain_modifier = keys.int_gain_modifier
	local int_loss_modifier = keys.int_loss_modifier

	-- Parameters
	local summon_damage = ability:GetLevelSpecialValueFor("illusion_damage", ability_level)
	local mana_damage_pct = ability:GetLevelSpecialValueFor("mana_pool_damage_pct", ability_level) / 100
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", ability_level)
	local int_steal_duration = ability:GetLevelSpecialValueFor("int_steal_duration", ability_level)
	
	-- Steal intelligence from the enemy if it's a hero
	if target:IsRealHero() then

		-- Add the appropriate number of stacks to the caster
		AddStacks(ability, caster, caster, int_gain_modifier, int_steal, true)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, int_steal, nil)

		-- Prevent the target from going under 1 int
		local target_int = target:GetIntellect()
		if target_int <= int_steal then
			int_steal = target_int - 1
		end

		-- Add the appropriate number of stacks to the enemy
		AddStacks(ability, caster, target, int_loss_modifier, int_steal, true)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, int_steal, nil)

		-- Force update the caster and target's mana
		caster:CalculateStatBonus()
		target:CalculateStatBonus()
	end

	-- Calculate and deal damage
	local bonus_damage = caster:GetMaxMana() * mana_damage_pct / FRANTIC_MULTIPLIER

	if target:IsIllusion() or target:IsSummoned() then
		bonus_damage = bonus_damage  + summon_damage
	end 

	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = bonus_damage, damage_type = ability:GetAbilityDamageType()})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, bonus_damage, nil)
end

function ArcaneOrbRestoreMana( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName(keys.ability_name)

	-- Check if Essence Aura is learned
	if not ability or ability:GetLevel() == 0 then
		return nil
	end

	-- Parameters
	local particle_name = keys.particle_name
	local sound_name = keys.sound_name
	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", ability:GetLevel() - 1 )
	local mana_restore = caster:GetMaxMana() * restore_amount / 100 

	-- Fire up particle
	local essence_fx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(essence_fx, 0, caster:GetAbsOrigin() )

	-- Play sound
	caster:EmitSound(sound_name)

	-- Restore mana
	caster:GiveMana(mana_restore)
end

function AstralImprisonment( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local ability_name = keys.ability_name
	local int_steal_ability = caster:FindAbilityByName(ability_name)

	-- Parameters
	local int_gain_modifier = keys.int_gain_modifier
	local int_loss_modifier = keys.int_loss_modifier
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", ability_level)
	local int_steal_pct = ability:GetLevelSpecialValueFor("int_steal_pct", ability_level)
	local int_steal_duration = ability:GetLevelSpecialValueFor("int_gain_duration", ability_level)

	-- If the target is an enemy, steal its intelligence
	if target:GetTeam() ~= caster:GetTeam() and caster:IsHero() then

		-- Calculate the intelligence to be stolen
		local target_int = target:GetIntellect()
		local target_int_pct = math.floor( target_int * int_steal_pct / 100 )
		if target_int_pct > int_steal then
			int_steal = target_int_pct
		end

		-- Add the appropriate number of stacks to the caster
		AddStacks(int_steal_ability, caster, caster, int_gain_modifier, int_steal, true)
		ability:ApplyDataDrivenModifier(caster, caster, int_gain_modifier, {duration = int_steal_duration})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, int_steal, nil)

		-- Prevent the target from going under 1 int
		if target_int <= int_steal then
			int_steal = target_int - 1
		end

		-- Add the appropriate number of stacks to the enemy
		AddStacks(int_steal_ability, caster, target, int_loss_modifier, int_steal, true)
		ability:ApplyDataDrivenModifier(caster, target, int_loss_modifier, {duration = int_steal_duration})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, int_steal, nil)

		-- Force update the caster and target's mana
		caster:CalculateStatBonus()
		target:CalculateStatBonus()
	end

	-- Remove the target's model from the game
	target:AddNoDraw()
end

function AstralImprisonmentEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local sound_name = keys.sound_name
	local target = keys.target

	-- Stop the looping sound when the modifier ends
	target:StopSound(sound_name)

	-- Redraw the target's model
	target:RemoveNoDraw()

	-- Deal minor pure damage to enemies (prevents blinks)
	if target:GetTeam() ~= caster:GetTeam() and caster:IsHero() then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = caster:GetIntellect(), damage_type = DAMAGE_TYPE_PURE})
	end
end

function RestoreMana( keys )
	local caster = keys.caster
	local target = keys.unit
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cast_ability = keys.event_ability
	local essence_particle = keys.essence_particle
	local essence_sound = keys.essence_sound
	local modifier_int = keys.modifier_int

	-- Parameters
	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", ability_level)
	local mana_absorb = ability:GetLevelSpecialValueFor("mana_absorb", ability_level)
	local max_int_pct = ability:GetLevelSpecialValueFor("max_int_pct", ability_level)
	local mana_restore = target:GetMaxMana() * restore_amount / 100
	local max_stacks = math.floor( caster:GetBaseIntellect() * max_int_pct / 100 )

	-- If the ability just cast uses mana, restore mana accordingly
	if cast_ability and cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) > 0 and StickProcCheck(cast_ability) then

		-- Restores mana
		target:GiveMana(mana_restore)

		-- Plays sound and effect
		local essence_fx = ParticleManager:CreateParticle(essence_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		target:EmitSound("essence_sound")

		-- Buff the caster if the spell was cast by an ally
		if target ~= caster then
			local mana_cost = cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) / FRANTIC_MULTIPLIER
			local stack_amount = math.floor( mana_cost * mana_absorb / 100 )

			-- Initialize stack amount global if necessary
			if not caster.essence_aura_bonus_int then
				caster.essence_aura_bonus_int = 0
			end

			-- Prevent stack amount from going over the cap
			if ( caster.essence_aura_bonus_int + stack_amount ) > max_stacks then
				stack_amount = math.max( max_stacks - caster.essence_aura_bonus_int, 0)
			end

			-- Apply the hidden modifiers which actually increase int
			for i = 1, stack_amount do
				ability:ApplyDataDrivenModifier(caster, caster, modifier_int, {})
			end

			-- Keep track of the amount of modifiers
			caster.essence_aura_bonus_int = caster.essence_aura_bonus_int + stack_amount

			-- Display overhead int gain message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, stack_amount, nil)

			-- Force update the caster's mana
			caster:CalculateStatBonus()
		end
	end
end

function EssenceAuraEnd( keys )
	local caster = keys.caster

	caster.essence_aura_bonus_int = caster.essence_aura_bonus_int - 1

	if caster.essence_aura_bonus_int == 0 then
		caster.essence_aura_bonus_int = nil
	end
end

function EssenceAuraUpdate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_int = caster:GetIntellect()
	local modifier_mana = keys.modifier_mana
	local modifier_stacks = keys.modifier_stacks

	caster:SetModifierStackCount(modifier_mana, caster, caster_int)

	-- Update the bonus int modifier count
	if caster.essence_aura_bonus_int then
		local current_stack_count = caster:GetModifierStackCount(modifier_stacks, caster)
		if caster.essence_aura_bonus_int > current_stack_count then
			AddStacks(ability, caster, caster, modifier_stacks, caster.essence_aura_bonus_int - current_stack_count, true)
		elseif caster.essence_aura_bonus_int < current_stack_count then
			caster:SetModifierStackCount(modifier_stacks, caster, caster.essence_aura_bonus_int)
		end
	end

	-- Force update the caster's mana
	caster:CalculateStatBonus()
end

function SanityEclipse( keys )
	local caster = keys.caster
	local target = keys.target_points[1]
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local radius = 	ability:GetLevelSpecialValueFor("radius", ability_level)
	local dmg_multiplier = ability:GetLevelSpecialValueFor("damage_multiplier", ability_level)
	local mana_burn_pct = ability:GetLevelSpecialValueFor("mana_burn_pct", ability_level)
	local ability_astral = caster:FindAbilityByName(keys.astral_name)
	local ability_astral_level = ability_astral:GetLevel() - 1
	local astral_modifier = keys.astral_modifier
	local particle_mana_burn = keys.particle_mana_burn
	local particle_damage = keys.particle_damage
	local caster_int = caster:GetIntellect()
	local scepter = HasScepter(caster)

	-- Find the enemies to be affected
	local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	-- If the caster has scepter, apply Astral Imprisonment to all targets
	if scepter and ability_astral:GetLevel() ~= 0 then
		
		-- Astral Imprisonment Parameters
		local ability_name = keys.ability_name
		local astral_sound = keys.astral_sound
		local int_steal_ability = caster:FindAbilityByName(ability_name)
		local int_gain_modifier = keys.int_gain_modifier
		local int_loss_modifier = keys.int_loss_modifier
		local int_steal = ability_astral:GetLevelSpecialValueFor("int_gain", ability_astral_level)
		local int_steal_pct = ability_astral:GetLevelSpecialValueFor("int_steal_pct", ability_astral_level)
		local int_steal_duration = ability_astral:GetLevelSpecialValueFor("int_gain_duration", ability_astral_level)
		local total_int_steal = 0

		-- Affect each valid enemy (instantly kills illusions)
		for _,enemy in pairs(enemies) do
			if enemy:IsRealHero() then
				if enemy:HasModifier(astral_modifier) then
					enemy:RemoveModifierByName(astral_modifier)
				end

				-- Calculate the intelligence to be stolen
				local target_int = enemy:GetIntellect()
				local target_int_pct = math.floor( target_int * int_steal_pct / 100 )
				local this_target_int_steal = int_steal
				if target_int_pct > int_steal then
					this_target_int_steal = target_int_pct
				end

				-- Add the appropriate number of stacks to the caster
				AddStacks(int_steal_ability, caster, caster, int_gain_modifier, this_target_int_steal, true)
				ability_astral:ApplyDataDrivenModifier(caster, caster, int_gain_modifier, {duration = int_steal_duration})
				total_int_steal = total_int_steal + this_target_int_steal

				-- Prevent the target from going under 1 int
				if target_int <= int_steal then
					this_target_int_steal = target_int - 1
				end

				-- Add the appropriate number of stacks to the target
				AddStacks(int_steal_ability, caster, enemy, int_loss_modifier, this_target_int_steal, true)
				ability_astral:ApplyDataDrivenModifier(caster, enemy, int_loss_modifier, {duration = int_steal_duration})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, enemy, this_target_int_steal, nil)

				-- Play sound, remove the target's model, and apply the Astral Imprisonment debuff
				enemy:EmitSound(astral_sound)
				enemy:AddNoDraw()
				ability_astral:ApplyDataDrivenModifier(caster, enemy, astral_modifier, {})
			else
				enemy:RemoveModifierByName(astral_modifier)
				TrueKill(caster, enemy, ability)
			end
		end

		-- Show total int gained by the caster
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, total_int_steal, nil)
	end

	-- Deal damage to enemies in the area
	for _,enemy in pairs(enemies) do

		-- Calculate damage
		local target_int = enemy:GetIntellect()
		local damage = (caster_int - target_int) * dmg_multiplier
		if caster_int <= target_int then
			damage = 0
		end

		-- If the target is affected by Astral Imprisonment and the damage is enough, remove it
		if enemy:HasModifier(astral_modifier) then
			if enemy:GetHealth() <= damage then
				enemy:RemoveModifierByName(astral_modifier)
				TrueKill(caster, enemy, ability)
			else
				enemy:SetHealth(enemy:GetHealth() - damage)
			end
		end
		
		-- Deal damage
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)

		-- Burn part of the enemy's maximum mana
		local enemy_mana = enemy:GetMaxMana()
		enemy:ReduceMana(enemy_mana * mana_burn_pct / 100)

		-- Fire mana burn and damage particles
		local mana_burn_pfx = ParticleManager:CreateParticle(particle_mana_burn, PATTACH_RENDERORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(mana_burn_pfx, 0, enemy:GetAbsOrigin())
		local damage_pfx = ParticleManager:CreateParticle(particle_damage, PATTACH_RENDERORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(damage_pfx, 0, enemy:GetAbsOrigin())
	end
end