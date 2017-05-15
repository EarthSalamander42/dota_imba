--[[	Author: Firetoad
		Date: 15.05.2017	]]

-- Definition
if modifier_imba_war_veteran == nil then modifier_imba_war_veteran = class({}) end
function modifier_imba_war_veteran:IsDebuff() return false end
function modifier_imba_war_veteran:IsPurgable() return false end
function modifier_imba_war_veteran:IsPermanent() return true end

function modifier_imba_war_veteran:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

-- Updates stack amount every second
function modifier_imba_war_veteran:OnIntervalThink()
	if IsServer() then
		local current_level = self:GetParent():GetLevel()
		if current_level > 40 then
			self:SetStackCount(current_level - 40)
		else
			self:SetStackCount(0)
		end
	end
end

-- Hides the buff when at level 40 and below
function modifier_imba_war_veteran:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	else
		return true
	end
end

-- Icon definition
function modifier_imba_war_veteran:GetTexture()
	return "custom/unlimited_level_powerup"
end

-- Bonus definitions
function modifier_imba_war_veteran:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

-- Attack damage
function modifier_imba_war_veteran:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() end

-- Attack speed
function modifier_imba_war_veteran:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() end

-- Base movement speed
function modifier_imba_war_veteran:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * 2 end

-- Maximum movement speed
function modifier_imba_war_veteran:GetModifierMoveSpeed_Max()
	return 550 + self:GetStackCount() * 2 end

-- Spell power
function modifier_imba_war_veteran:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount() end

-- Strength
function modifier_imba_war_veteran:GetModifierBonusStats_Strength()
	return self:GetStackCount() end

-- Agility
function modifier_imba_war_veteran:GetModifierBonusStats_Agility()
	return self:GetStackCount() end

-- Intelligence
function modifier_imba_war_veteran:GetModifierBonusStats_Intellect()
	return self:GetStackCount() end

-- Armor
function modifier_imba_war_veteran:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * 0.4 end

-- Magic resistance
function modifier_imba_war_veteran:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() end