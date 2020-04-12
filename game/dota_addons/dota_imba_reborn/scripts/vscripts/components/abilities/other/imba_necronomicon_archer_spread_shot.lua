-- Creator:
--	   AltiV, February 28th, 2020

LinkLuaModifier("modifier_imba_necronomicon_archer_spread_shot", "components/abilities/other/imba_necronomicon_archer_spread_shot", LUA_MODIFIER_MOTION_NONE)

imba_necronomicon_archer_spread_shot			= imba_necronomicon_archer_spread_shot or class({})
modifier_imba_necronomicon_archer_spread_shot	= modifier_imba_necronomicon_archer_spread_shot or class({})

------------------------------------------
-- IMBA_NECRONOMICON_ARCHER_SPREAD_SHOT --
------------------------------------------

function imba_necronomicon_archer_spread_shot:GetIntrinsicModifierName()
	return "modifier_imba_necronomicon_archer_spread_shot"
end

---------------------------------------------------
-- MODIFIER_IMBA_NECRONOMICON_ARCHER_SPREAD_SHOT --
---------------------------------------------------

function modifier_imba_necronomicon_archer_spread_shot:IsHidden()		return true end
function modifier_imba_necronomicon_archer_spread_shot:IsPurgable()		return false end
function modifier_imba_necronomicon_archer_spread_shot:RemoveOnDeath()	return false end

function modifier_imba_necronomicon_archer_spread_shot:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_imba_necronomicon_archer_spread_shot:OnAttack(keys)
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.target then
				self:GetParent():PerformAttack(enemy, false, false, true, false, true, false, false)
			end
		end
	end
end
