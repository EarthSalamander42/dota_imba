--[[	Author: d2imba
		Date:	25.03.2015	]]

function Radiance( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Parameters
	local base_damage = ability:GetLevelSpecialValueFor("base_damage", ability_level)
	local extra_damage = ability:GetLevelSpecialValueFor("extra_damage", ability_level)

	-- Calculate and deal damage
	local damage = base_damage + extra_damage * target:GetHealth() / 100
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end