function ManaBreak(event)
	local caster = event.caster
	local ability = event.ability 
	local target = event.target
	if not(caster and ability and target) then return end

	local manaPerHit = ability:GetLevelSpecialValueFor("mana_per_hit", ability:GetLevel() - 1)
	local manaPercentagePerHit = ability:GetLevelSpecialValueFor('mana_percentage_per_hit', ability:GetLevel() -1) / 100
	local targetMana = target:GetMana()
	local targetMaxMana = target:GetMaxMana()
	local manaToBurn = manaPerHit + manaPercentagePerHit * targetMana
	local damageRatio = ability:GetLevelSpecialValueFor('damage_per_burn', ability:GetLevel() -1)
	local bonusDamage = 0

	if targetMana < manaToBurn then
		target:SetMana(0)
		manaToBurn = 0
		bonusDamage = manaPerHit + manaPercentagePerHit * targetMaxMana
	else
		target:SetMana(targetMana - manaToBurn)
	end

	local damageToDeal = damageRatio * (manaToBurn + bonusDamage)
	local damageDealt = ApplyDamage({
		victim = target,
		attacker = caster,
		damage = damageToDeal,
		damage_type = ability:GetAbilityDamageType(),
		damage_flags = 0,
		ability = ability
	})
end

function ManaVoid(keys)
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
	end

	ScreenShake(target:GetOrigin(), 10, 0.1, 1, 500, 0, true)

end