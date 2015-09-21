function ButterflyEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damage = keys.damage

	-- Finds all valid units on the map
	local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_MECHANICAL + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	-- Single out a random enemy
	local enemy = enemies[RandomInt(1, #enemies)]

	-- Ignore the attack if a courier was found
	if enemy:GetName() == "npc_dota_courier" then
		return nil
	end

	-- Perform an attack on the singled out enemy
	if caster:IsRangedAttacker() then
		caster:PerformAttack(enemy, true, true, true, true)
	else
		local initial_pos = caster:GetAbsOrigin()
		local enemy_pos = enemy:GetAbsOrigin()
		caster:SetAbsOrigin(enemy_pos)
		caster:PerformAttack(enemy, true, true, true, true)
		caster:SetAbsOrigin(initial_pos)
	end
end