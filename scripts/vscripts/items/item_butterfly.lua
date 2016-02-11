function ButterflyEffect( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.damage

	-- Does not trigger if the enemy is an ancient
	if target:IsAncient() then
		return nil
	end

	-- Finds all valid units on the map
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Single out a random enemy
	local enemy = enemies[RandomInt(1, #enemies)]

	-- Ignore the attack if a courier was found
	if enemy:GetUnitName() == "npc_dota_courier" or enemy:GetName() == "npc_badguys_fort" or enemy:GetName() == "npc_goodguys_fort" or IsRoshan(enemy) then
		return nil
	end

	-- Perform an attack on the singled out enemy
	if caster:IsRangedAttacker() then
		caster:PerformAttack(enemy, true, false, true, true, true)
	else
		ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end