function ButterflyEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.damage

	-- Finds all valid units on the map
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)

	-- Singles out a random unit from the list above and deals damage to it
	local unit = RandomInt(1, #enemies)
	for k, enemy in pairs(enemies) do
		unit = unit - 1
		if unit == 0 then
			ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
			break
		end
	end
end