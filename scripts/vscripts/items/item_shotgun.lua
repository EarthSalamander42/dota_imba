--[[	Author: d2imba
		Date:	20.09.2015	]]

function Shotgun( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- If the caster is not ranged, do nothing
	if not caster:IsRangedAttacker() then
		return nil
	end

	-- Parameters
	local proc_chance = ability:GetLevelSpecialValueFor("proc_chance", ability_level)
	local proc_targets = ability:GetLevelSpecialValueFor("proc_targets", ability_level)
	local search_range = caster:GetAttackRange() + 64

	-- Roll for proc chance
	if RandomInt(1, 100) <= proc_chance then
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, search_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		-- Attack random units in range
		for i,enemy in pairs(nearby_enemies) do
			if nearby_enemies[i] ~= target then
				caster:PerformAttack(nearby_enemies[i], true, false, true, true, true)
				proc_targets = proc_targets - 1
			end
			if proc_targets == 0 then
				break
			end
		end
	end
end