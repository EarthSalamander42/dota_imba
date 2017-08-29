-- Created by X-The-Dark

modifier_imba_double_damage_rune = modifier_imba_double_damage_rune or class({})

function modifier_imba_double_damage_rune:IsAura() return true end
function modifier_imba_double_damage_rune:GetAuraRadius() return self.aura_radius end
function modifier_imba_double_damage_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_double_damage_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_double_damage_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_double_damage_rune:GetModifierAura() return "modifier_imba_rune_double_damage_aura" end

function modifier_imba_double_damage_rune:GetTextureName()
	return "custom/imba_rune_double_damage"
end

function modifier_imba_double_damage_rune:GetEffectName()
	return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_imba_double_damage_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Parent doesn't get aura, just the owner stuff
function modifier_imba_double_damage_rune:GetAuraEntityReject(entity)
	if entity == self.parent then
		return true
	end
	return false
end

function modifier_imba_double_damage_rune:OnCreated()
	self.parent = self:GetParent()
	self.aura_radius = 900
	self.bonus_main_attribute_multiplier = 1

	self.strength_bonus = 0
	self.agility_bonus = 0
	self.intellect_bonus = 0

	local primary_attribute = self.parent:GetPrimaryAttribute()

	-- Strength
	if primary_attribute == 0 then
		self.strength_bonus = self.parent:GetBaseStrength() * self.bonus_main_attribute_multiplier
	-- Agility
	elseif primary_attribute == 1 then
		self.agility_bonus = self.parent:GetBaseAgility() * self.bonus_main_attribute_multiplier
	-- Intelligence
	else
		self.intellect_bonus = self.parent:GetBaseIntellect() * self.bonus_main_attribute_multiplier
	end
end

function modifier_imba_double_damage_rune:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
				MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
				MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
	return funcs
end

function modifier_imba_double_damage_rune:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_imba_double_damage_rune:GetModifierBonusStats_Agility()
	return self.agility_bonus
end

function modifier_imba_double_damage_rune:GetModifierBonusStats_Intellect()
	return self.intellect_bonus
end
----------------------------------------------------------------------
-- Double Damage team aura
----------------------------------------------------------------------
modifier_imba_rune_double_damage_aura = modifier_imba_rune_double_damage_aura or class({})
function modifier_imba_rune_double_damage_aura:IsDebuff() return false end

function modifier_imba_rune_double_damage_aura:GetTextureName()
	return "custom/imba_rune_double_damage"
end

function modifier_imba_rune_double_damage_aura:GetEffectName()
	return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end

function modifier_imba_rune_double_damage_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_rune_double_damage_aura:OnCreated()
	self.parent = self:GetParent()
	self.bonus_damage_pct_aura = 50
	self.bonus_main_attribute_multiplier = 0.5
	
	self.strength_bonus = 0
	self.agility_bonus = 0
	self.intellect_bonus = 0

	local primary_attribute = self.parent:GetPrimaryAttribute()
	
	-- Strength
	if primary_attribute == 0 then
		self.strength_bonus = self.parent:GetBaseStrength() * self.bonus_main_attribute_multiplier
	-- Agility
	elseif primary_attribute == 1 then
		self.agility_bonus = self.parent:GetBaseAgility() * self.bonus_main_attribute_multiplier
	-- Intelligence
	else
		self.intellect_bonus = self.parent:GetBaseIntellect() * self.bonus_main_attribute_multiplier
	end
end

function modifier_imba_rune_double_damage_aura:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
				MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
				MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
				MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
	return funcs
end

function modifier_imba_rune_double_damage_aura:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_imba_rune_double_damage_aura:GetModifierBonusStats_Agility()
	return self.agility_bonus
end

function modifier_imba_rune_double_damage_aura:GetModifierBonusStats_Intellect()
	return self.intellect_bonus
end

function modifier_imba_rune_double_damage_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct_aura
end