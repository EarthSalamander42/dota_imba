function crimson_guard_activate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local meleeModifier = "modifier_item_crimson_guard_active_melee"
	local rangedModifier = "modifier_item_crimson_guard_avtive_ranged"
	local cooldownModifier = "modifier_item_crimson_guard_cooldown"
	local ability_level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("bonus_aoe_radius", ability_level)

	local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,ally in pairs( allies ) do
		if ally:HasModifier(cooldownModifier) then
			return
		else
			if ally:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
				ability:ApplyDataDrivenModifier(caster, ally, meleeModifier, {})
			elseif ally:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
				ability:ApplyDataDrivenModifier(caster, ally, rangedModifier, {})
			end
			ability:ApplyDataDrivenModifier(caster, ally, cooldownModifier, {})
		end
	end
end

function crimson_guard_created( keys )
	local caster = keys.caster
	local ability = keys.ability
	local meleeModifier = "modifier_item_crimson_guard_block_melee"
	local rangedModifier = "modifier_item_crimson_guard_block_ranged"

	Timers:CreateTimer( 0.1, function()
		if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
			caster:RemoveModifierByName(rangedModifier)
		end
		if caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
			caster:RemoveModifierByName(meleeModifier)
		end
		return nil
		end )
	
end