-- Created by X-The-Dark

LinkLuaModifier("modifier_imba_rune_doubledamage_aura", "components/modifiers/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_double_damage_rune_super", "components/modifiers/runes/modifier_imba_double_damage_rune.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_double_damage_rune = modifier_imba_double_damage_rune or class({})

function modifier_imba_double_damage_rune:IsAura() return true end
function modifier_imba_double_damage_rune:GetAuraRadius() return CustomNetTables:GetTableValue("game_options", "runes").rune_radius_effect end
function modifier_imba_double_damage_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_double_damage_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_double_damage_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_double_damage_rune:GetModifierAura() return "modifier_imba_rune_doubledamage_aura" end

function modifier_imba_double_damage_rune:GetTexture()
	if CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier > 1 then
		return "custom/imba_rune_double_damage_super"
	else
		return "custom/imba_rune_double_damage"
	end
end

function modifier_imba_double_damage_rune:GetEffectName()
	if CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier > 1 then
		return "particles/generic_gameplay/rune_quadrupledamage_owner.vpcf"
	else
		return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
	end
end

function modifier_imba_double_damage_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Parent doesn't get aura, just the owner stuff
function modifier_imba_double_damage_rune:GetAuraEntityReject(entity)
	if entity == self:GetParent() then
		return true
	end

	return false
end

function modifier_imba_double_damage_rune:OnCreated(keys)
	self:SetStackCount(100 * CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier)
	self.bonus_main_attribute_multiplier = 1 * CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier

	if not IsServer() then return end
	if self:GetParent():IsRealHero() then
		local primary_attribute = self:GetParent():GetPrimaryAttribute()

		-- Strength
		if primary_attribute == 0 then
			self.strength_bonus = self:GetParent():GetBaseStrength() * self.bonus_main_attribute_multiplier
		-- Agility
		elseif primary_attribute == 1 then
			self.agility_bonus = self:GetParent():GetBaseAgility() * self.bonus_main_attribute_multiplier
		-- Intelligence
		else
			self.intellect_bonus = self:GetParent():GetBaseIntellect() * self.bonus_main_attribute_multiplier
		end
	end
end

function modifier_imba_double_damage_rune:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
				MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
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

function modifier_imba_double_damage_rune:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()
end

----------------------------------------------------------------------
-- Double Damage team aura
----------------------------------------------------------------------
modifier_imba_rune_doubledamage_aura = modifier_imba_rune_doubledamage_aura or class({})
function modifier_imba_rune_doubledamage_aura:IsDebuff() return false end

function modifier_imba_rune_doubledamage_aura:GetTexture()
	if CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier > 1 then
		return "custom/imba_rune_double_damage_super"
	else
		return "custom/imba_rune_double_damage"
	end
end

function modifier_imba_rune_doubledamage_aura:GetEffectName()
	if CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier > 1 then
		return "particles/generic_gameplay/rune_quadrupledamage_owner.vpcf"
	else
		return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
	end
end

function modifier_imba_rune_doubledamage_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_rune_doubledamage_aura:OnCreated()
	if not IsServer() then return end
	self:SetStackCount((100 * CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier) / 2)
	self.bonus_main_attribute_multiplier = (1 * CustomNetTables:GetTableValue("game_options", "runes").double_damage_rune_multiplier)	/ 2
    
	-- Don't calculate all this stuff for MK clones cause it can cause lag problems
	if self:GetParent():IsRealHero() then
		self.strength_bonus = 0
		self.agility_bonus = 0
		self.intellect_bonus = 0

		local primary_attribute = self:GetParent():GetPrimaryAttribute()

		-- Strength
		if primary_attribute == 0 then
			self.strength_bonus = self:GetParent():GetBaseStrength() * self.bonus_main_attribute_multiplier
		-- Agility
		elseif primary_attribute == 1 then
			self.agility_bonus = self:GetParent():GetBaseAgility() * self.bonus_main_attribute_multiplier
		-- Intelligence
		else
			self.intellect_bonus = self:GetParent():GetBaseIntellect() * self.bonus_main_attribute_multiplier
		end
	end
end

function modifier_imba_rune_doubledamage_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function modifier_imba_rune_doubledamage_aura:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_imba_rune_doubledamage_aura:GetModifierBonusStats_Agility()
	return self.agility_bonus
end

function modifier_imba_rune_doubledamage_aura:GetModifierBonusStats_Intellect()
	return self.intellect_bonus
end

function modifier_imba_rune_doubledamage_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self:GetStackCount()
end
