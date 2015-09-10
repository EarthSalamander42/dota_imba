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

	-- If there is not casted ability, do nothing
	if not cast_ability then
		return nil
	end

	-- Parameters
	local mana_per_stack = ability:GetLevelSpecialValueFor("mana_per_stack", ability_level)
	local mana_to_purge = ability:GetLevelSpecialValueFor("mana_to_purge", ability_level)
	local scale_up = ability:GetLevelSpecialValueFor("scale_up", ability_level)

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

	-- Add damage/as stacks
	AddStacks(ability, caster, caster, modifier_stacks, math.floor( mana_spent / mana_per_stack ), true)
	local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

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
	local targetLocation = target:GetAbsOrigin()
	local damagePerMana = ability:GetLevelSpecialValueFor('mana_void_damage_per_mana', ability:GetLevel() -1) / FRANTIC_MULTIPLIER
	local radius = ability:GetLevelSpecialValueFor('mana_void_aoe_radius', ability:GetLevel() -1)
	local scepter = HasScepter(caster)
	local manaBurn = 0
	local maxManaBurn = 0

	if scepter then
		manaBurn = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct_scepter', ability:GetLevel() -1) / 100
		maxManaBurn = ability:GetLevelSpecialValueFor('max_mana_burn_scepter', ability:GetLevel() -1) * FRANTIC_MULTIPLIER
	else
		manaBurn = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct', ability:GetLevel() -1) / 100
		maxManaBurn = ability:GetLevelSpecialValueFor('max_mana_burn', ability:GetLevel() -1) * FRANTIC_MULTIPLIER
	end

	local damage = 0
	local targetMana = target:GetMana()
	local targetMaxMana = target:GetMaxMana()
	local manaToBurn = math.min( manaBurn * targetMaxMana, maxManaBurn) 

	if targetMana < manaToBurn then
		target:SetMana(0)
		damageToDeal = damagePerMana * targetMaxMana
	else
		target:SetMana(targetMana - manaToBurn)
		damageToDeal = damagePerMana * (targetMaxMana - targetMana + manaToBurn)
	end

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.ability = ability
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.damage = damageToDeal

	-- Finds all the enemies in a radius around the target and then deals damage to each of them
	local unitsToDamage = FindUnitsInRadius(caster:GetTeam(), targetLocation, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

	for _,v in ipairs(unitsToDamage) do
		damageTable.victim = v
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, v, target:GetMaxMana() - target:GetMana(), nil)
	end

	ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)

end