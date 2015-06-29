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
	local int_steal_pct = ability:GetLevelSpecialValueFor("int_steal_pct", ability_level)
	local int_steal_duration = ability:GetLevelSpecialValueFor("int_steal_duration", ability_level)
	
	-- Steal intelligence from the enemy if it's a hero
	if target:IsRealHero() then

		-- Calculate the intelligence to be stolen
		local target_int_pct = math.floor( target:GetIntellect() * int_steal_pct / 100 )
		if target_int_pct > int_steal then
			int_steal = target_int_pct
		end

		-- Add the appropriate number of stacks to the caster and the target
		AddStacks(ability, caster, caster, int_gain_modifier, int_steal, true)
		AddStacks(ability, caster, target, int_loss_modifier, int_steal, true)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, int_steal, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, int_steal, nil)
	end

	-- Calculate and deals damage
	local bonus_damage = caster:GetMaxMana() * mana_damage_pct

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
	if ability:GetLevel() == 0 then
		return
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
	if target:GetTeam() ~= caster:GetTeam() then

		-- Calculate the intelligence to be stolen
		local target_int_pct = math.floor( target:GetIntellect() * int_steal_pct / 100 )
		if target_int_pct > int_steal then
			int_steal = target_int_pct
		end

		-- Add the appropriate number of stacks to the caster and the target
		AddStacks(int_steal_ability, caster, caster, int_gain_modifier, int_steal, true)
		AddStacks(int_steal_ability, caster, target, int_loss_modifier, int_steal, true)
		ability:ApplyDataDrivenModifier(caster, caster, int_gain_modifier, {duration = int_steal_duration})
		ability:ApplyDataDrivenModifier(caster, target, int_loss_modifier, {duration = int_steal_duration})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, int_steal, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, int_steal, nil)
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
	StopSoundEvent(sound_name, target)

	-- Redraw the target's model
	target:RemoveNoDraw()

	-- Deal 1 pure damage to enemies (prevents blinks)
	if target:GetTeam() ~= caster:GetTeam() then
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = 1, damage_type = DAMAGE_TYPE_PURE})
	end
end

function RestoreMana( keys )
	local target = keys.unit
	local ability = keys.ability
	local restore_amount = ability:GetLevelSpecialValueFor("restore_amount", ability:GetLevel() - 1 )
	local mana_restore = target:GetMaxMana() * restore_amount / 100 

	-- Restore mana
	target:GiveMana(mana_restore)

end

function EssenceAuraMana( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_int = caster:GetIntellect()
	local modifier = "modifier_essence_aura_mana"
	local modifier_dummy = "modifier_essence_aura_mana_dummy"

	caster:SetModifierStackCount(modifier, caster, caster_int)

	caster:RemoveModifierByName(modifier_dummy)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_dummy, {})
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
	local astral_modifier = keys.astral_modifier
	local caster_int = caster:GetIntellect()
	local scepter = HasScepter(caster)

	-- Find the enemies to be affected
	local enemies = FindUnitsInRadius(caster:GetTeam(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
	if scepter and ability_astral:GetLevel() ~= 0 then
		
		-- Astral Imprisonment Parameters
		local ability_name = keys.ability_name
		local astral_sound = keys.astral_sound
		local int_steal_ability = caster:FindAbilityByName(ability_name)
		local int_gain_modifier = keys.int_gain_modifier
		local int_loss_modifier = keys.int_loss_modifier
		local int_steal = ability_astral:GetLevelSpecialValueFor("int_gain", ability_astral:GetLevel() - 1)
		local int_steal_pct = ability_astral:GetLevelSpecialValueFor("int_steal_pct", ability_astral:GetLevel() - 1)
		local int_steal_duration = ability_astral:GetLevelSpecialValueFor("int_gain_duration", ability_astral:GetLevel() - 1)

		-- Affect each valid enemy
		for _,enemy in pairs(enemies) do
			if enemy:HasModifier(astral_modifier) then
				enemy:RemoveModifierByName(astral_modifier)
			end

			-- Calculate the intelligence to be stolen
			local target_int_pct = math.floor( enemy:GetIntellect() * int_steal_pct / 100 )
			local this_target_int_steal = int_steal
			if target_int_pct > int_steal then
				this_target_int_steal = target_int_pct
			end

			-- Adds the appropriate number of stacks to the caster and the target
			AddStacks(int_steal_ability, caster, caster, int_gain_modifier, this_target_int_steal, true)
			AddStacks(int_steal_ability, caster, enemy, int_loss_modifier, this_target_int_steal, true)
			ability_astral:ApplyDataDrivenModifier(caster, caster, int_gain_modifier, {duration = int_steal_duration})
			ability_astral:ApplyDataDrivenModifier(caster, enemy, int_loss_modifier, {duration = int_steal_duration})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, caster, int_steal, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, enemy, int_steal, nil)


			-- Play sound, remove the target's model, and apply the Astral Imprisonment debuff
			enemy:EmitSound(astral_sound)
			enemy:AddNoDraw()
			ability_astral:ApplyDataDrivenModifier(caster, enemy, astral_modifier, {})
		end
	end

	-- Deals damage to enemies in the area
	for _,enemy in pairs(enemies) do

		-- Calculates damage
		local target_int = enemy:GetIntellect()
		local damage = (caster_int - target_int) * dmg_multiplier
		if caster_int <= target_int then
			damage = 0
		end

		-- If the target is affected by Astral Imprisonment, checks if the damage would be enough to kill it
		if enemy:HasModifier(astral_modifier) then
			local actual_damage = damage * ( 1 - enemy:GetMagicalArmorValue() )
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)

			-- If the damage is enough, ends Astral Imprisonment and kills the target
			if enemy:GetHealth() <= actual_damage then
				enemy:RemoveModifierByName(astral_modifier)
				enemy:Kill(ability, caster)
			else
				enemy:SetHealth( enemy:GetHealth() - actual_damage )
			end
		else
			-- Deals damage
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = ability:GetAbilityDamageType()})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil)
		end

		-- Burns 75% of the enemy's current mana
		local enemy_mana = enemy:GetMana()
		enemy:SetMana( enemy_mana * (1 - mana_burn_pct / 100 ) )
	end
end