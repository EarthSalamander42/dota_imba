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

	-- Plays the sound
	target:EmitSound("Hero_Antimage.ManaBreak")

	-- Plays the particle
	local manaburn_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(manaburn_fx, 0, target:GetAbsOrigin() )

	-- If this unit is an illusion, reduce the parameters by illusion_factor
	local illusion_factor = ability:GetLevelSpecialValueFor("illusion_factor", ability_level)
	if not caster:IsIllusion() then
		illusion_factor = 1
	end

	-- Parameters
	local max_mana_percent = ability:GetLevelSpecialValueFor("max_mana_percent", ability_level) * illusion_factor
	local current_mana_percent = ability:GetLevelSpecialValueFor('current_mana_percent', ability_level) * illusion_factor
	local damage_when_empty = ability:GetLevelSpecialValueFor('damage_when_empty', ability_level) * illusion_factor
	local damage_ratio = ability:GetLevelSpecialValueFor('damage_per_burn', ability_level)
	local target_current_mana = target:GetMana()
	local target_max_mana = target:GetMaxMana()
	local mana_to_burn = ( max_mana_percent * target_max_mana + current_mana_percent * target_current_mana ) / 100
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
	local target = keys.unit
	local modifier_stacks = keys.modifier_stacks
	local particle_stacks = keys.particle_stacks

	-- Parameters
	local scale_up = ability:GetLevelSpecialValueFor("scale_up", ability:GetLevel() - 1 )

	-- Add damage/as stacks
	AddStacks(ability, caster, caster, modifier_stacks, 1, true)
	local current_stacks = caster:GetModifierStackCount(modifier_stacks, caster)

	-- Update the Spell Shield particle
	if not caster.spell_shield_stacks_particle then
		caster.spell_shield_stacks_particle = ParticleManager:CreateParticle(particle_stacks, PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(caster.spell_shield_stacks_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(caster.spell_shield_stacks_particle, 1, Vector(4, 0, 0))
	else
		ParticleManager:SetParticleControl(caster.spell_shield_stacks_particle, 1, Vector(current_stacks * 4, 0, 0))
	end

	-- Update model scale
	caster:SetModelScale( math.min( 0.9 + scale_up * current_stacks, 1.1) )
end

function SpellShieldEnd( keys )
	local caster = keys.caster

	-- Kill the spell shield particle
	ParticleManager:DestroyParticle(caster.spell_shield_stacks_particle, false)
	caster.spell_shield_stacks_particle = nil

	-- Update model scale
	caster:SetModelScale(0.9)
end

function ManaVoid( keys )
	local caster = keys.caster
	local target = keys.target_entities[1]
	local ability = keys.ability
	local targetLocation = target:GetAbsOrigin()
	local damagePerMana = ability:GetLevelSpecialValueFor('mana_void_damage_per_mana', ability:GetLevel() -1)
	local radius = ability:GetLevelSpecialValueFor('mana_void_aoe_radius', ability:GetLevel() -1)
	local scepter = HasScepter(caster)
	local manaBurn = 0

	if scepter == true then
		manaBurn = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct_scepter', ability:GetLevel() -1) / 100
	else
		manaBurn = ability:GetLevelSpecialValueFor('mana_void_mana_burn_pct', ability:GetLevel() -1) / 100
	end

	local damage = 0
	local targetMana = target:GetMana()
	local targetMaxMana = target:GetMaxMana()
	local manaToBurn = manaBurn * targetMaxMana

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
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, v, damageToDeal, nil)
	end

	ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)

end