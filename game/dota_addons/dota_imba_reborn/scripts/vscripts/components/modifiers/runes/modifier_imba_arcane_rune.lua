modifier_imba_arcane_rune = modifier_imba_arcane_rune or class({})

function modifier_imba_arcane_rune:IsAura() return true end
function modifier_imba_arcane_rune:GetAuraRadius() return self.aura_radius end
function modifier_imba_arcane_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_arcane_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_arcane_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_arcane_rune:GetModifierAura() return "modifier_imba_arcane_rune_aura" end

function modifier_imba_arcane_rune:GetTexture()
	return "custom/imba_rune_arcane"
end

function modifier_imba_arcane_rune:GetEffectName()
	return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_imba_arcane_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Parent doesn't get aura, just the owner stuff
function modifier_imba_arcane_rune:GetAuraEntityReject(entity)
	if entity == self:GetParent() then
		return true
	end
	return false
end

function modifier_imba_arcane_rune:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_imba_arcane_rune:GetModifierPercentageCooldown()
	return 30
end

function modifier_imba_arcane_rune:GetModifierSpellAmplify_Percentage()
	return 50
end

function modifier_imba_arcane_rune:GetModifierPercentageManacost()
	return 40
end

----------------------------------------------------------------------
-- Double Damage team aura
----------------------------------------------------------------------
modifier_imba_arcane_rune_aura = modifier_imba_arcane_rune_aura or class({})
function modifier_imba_arcane_rune_aura:IsDebuff() return false end

function modifier_imba_arcane_rune_aura:GetTextureName()
	return "rune_arcane"
end

function modifier_imba_arcane_rune_aura:GetEffectName()
	return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_imba_arcane_rune_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_arcane_rune_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_imba_arcane_rune_aura:GetModifierPercentageCooldown()
	return 15
end

function modifier_imba_arcane_rune_aura:GetModifierSpellAmplify_Percentage()
	return 25
end

function modifier_imba_arcane_rune_aura:GetModifierPercentageManacost()
	return 20
end
