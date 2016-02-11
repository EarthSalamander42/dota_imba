--[[	Author: D2imba
		Date: 07.03.2015	]]

function ManaBreak( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target

	-- If there isn't a valid target, do nothing
	if not ( target:IsHero() or target:IsCreep() or target:IsAncient() ) or target:GetMaxMana() == 0 or target:IsMagicImmune() then
		return nil
	end

	-- Play sound
	caster:EmitSound("Hero_Antimage.ManaBreak")

	-- Plays the particle
	local manaburn_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(manaburn_fx, 0, target:GetAbsOrigin() )

	-- If this unit is an illusion, reduce the parameters by illusion_factor
	local illusion_factor = ability:GetLevelSpecialValueFor("illusion_factor", ability_level)
	if not caster:IsIllusion() then
		illusion_factor = 1
	end

	-- Parameters
	local max_mana_percent = ability:GetLevelSpecialValueFor("max_mana_percent", ability_level)
	local maximum_mana_burn = ability:GetLevelSpecialValueFor('maximum_mana_burn', ability_level) * illusion_factor * FRANTIC_MULTIPLIER
	local damage_when_empty = ability:GetLevelSpecialValueFor('damage_when_empty', ability_level) * illusion_factor / FRANTIC_MULTIPLIER
	local damage_ratio = ability:GetLevelSpecialValueFor('damage_per_burn', ability_level) / FRANTIC_MULTIPLIER
	local target_current_mana = target:GetMana()
	local target_max_mana = target:GetMaxMana()
	local mana_to_burn = math.min( max_mana_percent * target_max_mana / 100, maximum_mana_burn)
	local mana_is_low

	-- Burns mana
	if target_current_mana < mana_to_burn then
		target:SetMana(0)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, target_current_mana, nil)
		mana_is_low = true
	else
		target:SetMana(target_current_mana - mana_to_burn)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, target, mana_to_burn, nil)
		mana_is_low = false
	end

	-- If mana is low, deals pure damage based on the target's mana. Else, deals physical damage based on the amount of mana burned.
	if mana_is_low then
		local damage = damage_when_empty * target_max_mana / 100
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	else
		local damage = mana_to_burn * damage_ratio
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function SpellShield( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.unit
	local cast_ability = keys.event_ability
	local modifier_stacks = keys.modifier_stacks
	local particle_stacks = keys.particle_stacks

	-- If there isn't a casted ability, do nothing
	if not cast_ability then
		return nil
	end

	-- Parameters
	local mana_per_stack = ability:GetLevelSpecialValueFor("mana_per_stack", ability_level)
	local mana_to_purge = ability:GetLevelSpecialValueFor("mana_to_purge", ability_level)
	local scale_up = ability:GetLevelSpecialValueFor("scale_up", ability_level)
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- If total mana spent variable doesn't exist, create it
	if not caster.spell_shield_mana_spent then
		caster.spell_shield_mana_spent = 0
	end

	-- Increase count of mana spent around the caster
	local mana_spent = cast_ability:GetManaCost( cast_ability:GetLevel() - 1 ) / FRANTIC_MULTIPLIER
	caster.spell_shield_mana_spent = caster.spell_shield_mana_spent + mana_spent

	-- If the mana spent around the caster exceeds the threshold, purge all debuffs
	if caster.spell_shield_mana_spent >= mana_to_purge then
		caster.spell_shield_mana_spent = caster.spell_shield_mana_spent - mana_to_purge

		-- Repeatedly purge for the next 0.3 seconds
		local i = 0
		Timers:CreateTimer(0, function()
			caster:Purge(false, true, false, true, false)
			i = i + 1
			if i <= 3 then
				return 0.1
			end
		end)
	end

	-- Add damage stacks
	local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)
	local stacks_to_add = math.floor( mana_spent / mana_per_stack )
	if (stacks_to_add + current_stacks) <= max_stacks then
		AddStacks(ability, caster, caster, modifier_stacks, stacks_to_add, true)
	else
		AddStacks(ability, caster, caster, modifier_stacks, max_stacks - current_stacks, true)
	end
	current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

	-- Update the Spell Shield particle
	if not caster.spell_shield_stacks_particle then
		caster.spell_shield_stacks_particle = ParticleManager:CreateParticle(particle_stacks, PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.spell_shield_stacks_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(caster.spell_shield_stacks_particle, 1, Vector(math.floor(current_stacks / 8), 0, 0))
	else
		ParticleManager:SetParticleControl(caster.spell_shield_stacks_particle, 1, Vector(math.floor(current_stacks / 8), 0, 0))
	end

	-- Update model scale
	caster:SetModelScale( math.min( 0.9 + scale_up * current_stacks, 1.1) )
end

function SpellShieldEnd( keys )
	local caster = keys.caster

	-- Kill the spell shield particle
	ParticleManager:DestroyParticle(caster.spell_shield_stacks_particle, false)
	caster.spell_shield_stacks_particle = nil

	-- Reset mana spent counter
	caster.spell_shield_mana_spent = nil

	-- Update model scale
	caster:SetModelScale(0.9)
end

function ManaVoid( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() -1
	local scepter = HasScepter(caster)

	-- Parameters
	local damage_per_mana = ability:GetLevelSpecialValueFor('mana_void_damage_per_mana', ability_level) / FRANTIC_MULTIPLIER
	local radius = ability:GetLevelSpecialValueFor('mana_void_aoe_radius', ability_level)
	local mana_burn_pct = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct', ability_level)
	local secondary_mana_pct = 0
	local damage = 0

	-- If the caster has a scepter, add secondary targets' mana contribution
	if scepter then
		secondary_mana_pct = ability:GetLevelSpecialValueFor('secondary_mana_scepter', ability_level)
	end

	-- Burn main target's mana
	local target_mana_burn = target:GetMaxMana() * mana_burn_pct / 100
	target:ReduceMana(target_mana_burn)

	-- Find all enemies in the area of effect
	local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(nearby_enemies) do

		-- Calculate this enemy's damage contribution
		local this_enemy_damage = (enemy:GetMaxMana() - enemy:GetMana()) * damage_per_mana

		-- If this is not the main target, weight its damage contribution
		if enemy ~= target then
			this_enemy_damage = this_enemy_damage * secondary_mana_pct / 100
		end

		-- Add this enemy's contribution to the damage tally
		damage = damage + this_enemy_damage
	end

	-- Damage all enemies in the area for the total damage tally
	for _,enemy in pairs(nearby_enemies) do
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
	end

	-- Shake screen due to excessive PURITY OF WILL
	ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)
end