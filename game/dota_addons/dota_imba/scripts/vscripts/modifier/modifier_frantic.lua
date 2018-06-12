modifier_frantic = modifier_frantic or class({})

----------------------------------------------------------------------
-- Frantic handler
----------------------------------------------------------------------

modifier_frantic = modifier_frantic or class({})

function modifier_frantic:IsDebuff() return false end
function modifier_frantic:RemoveOnDeath() return false end
function modifier_frantic:IsPurgable() return false end
function modifier_frantic:IsPurgeException() return false end

function modifier_frantic:GetTexture()
	return "custom/imba_rune_arcane"
end

function modifier_frantic:GetEffectName()
	return "particles/generic_gameplay/rune_arcane_owner.vpcf"
end

function modifier_frantic:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frantic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_frantic:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(_G.IMBA_FRANTIC_VALUE)
end

function modifier_frantic:GetModifierPercentageCooldown()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierPercentageManacost()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierStatusResistanceStacking()
	print("Status Resistance:", self:GetStackCount())
	return self:GetStackCount()
end

function modifier_frantic:GetModifierStatusResistance()
	print("Status Resistance:", self:GetStackCount())
	return self:GetStackCount()
end
