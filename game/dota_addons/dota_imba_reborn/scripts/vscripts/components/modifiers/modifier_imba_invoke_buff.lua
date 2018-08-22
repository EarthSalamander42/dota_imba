--[[	Author: Noobsauce
		Date: 1.5.2017	]]

if modifier_imba_invoke_buff == nil then
	modifier_imba_invoke_buff = class({})
end

function modifier_imba_invoke_buff:OnCreated()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spellpower")
		self.int_buff = self.ability:GetSpecialValueFor("bonus_intellect")
		self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
		self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction_pct")
		self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal")
		self:StartIntervalThink(1.0)
end

function modifier_imba_invoke_buff:OnIntervalThink()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spellpower")
		self.int_buff = self.ability:GetSpecialValueFor("bonus_intellect")
		self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
		self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction_pct")
		self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal")
end

function modifier_imba_invoke_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING
	}
	return funcs
end

function modifier_imba_invoke_buff:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_imba_invoke_buff:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end

function modifier_imba_invoke_buff:GetModifierBonusStats_Intellect()
	return self.int_buff
end

function modifier_imba_invoke_buff:GetModifierPercentageCooldownStacking()
	return self.cooldown_reduction
end

function modifier_imba_invoke_buff:GetModifierSpellLifesteal()
	return self.spell_lifesteal
end

function modifier_imba_invoke_buff:IsPurgable()
	return false
end

function modifier_imba_invoke_buff:IsHidden()
	return true
end

function modifier_imba_invoke_buff:IsPermanent()
	return true
end
