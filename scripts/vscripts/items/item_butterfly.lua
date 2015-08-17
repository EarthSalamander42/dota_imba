function ButterflyEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.damage

	-- Finds all valid units on the map
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Singles out a random unit from the list above and attacks it
	caster:PerformAttack(enemies[RandomInt(1, #enemies)], true, true, true, true)
end