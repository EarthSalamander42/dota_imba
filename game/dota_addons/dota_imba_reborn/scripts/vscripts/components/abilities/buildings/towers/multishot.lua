LinkLuaModifier('modifier_imba_tower_multishot', "components/abilities/buildings/towers/multishot.lua", LUA_MODIFIER_MOTION_NONE)

imba_tower_multishot = imba_tower_multishot or class({})

function imba_tower_multishot:GetIntrinsicModifierName()
	return "modifier_imba_tower_multishot"
end

modifier_imba_tower_multishot = modifier_imba_tower_multishot or class({})

function modifier_imba_tower_multishot:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
} end

function modifier_imba_tower_multishot:OnAttack(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() and not self:GetParent():PassivesDisabled() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)
		local target_count = 0

		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false)

				target_count = target_count + 1

				if target_count >= self:GetAbility():GetSpecialValueFor("arrow_count") then
					break
				end
			end
		end
	end
end

function modifier_imba_tower_multishot:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end

	return self:GetAbility():GetSpecialValueFor("damage_modifier")
end
