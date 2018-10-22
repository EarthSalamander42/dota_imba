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
	return "custom/frantic"
end

function modifier_frantic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_frantic:GetEffectName()
	return "particles/generic_gameplay/frantic.vpcf"
end

function modifier_frantic:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_frantic:GetModifierPercentageCooldownStacking()
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").frantic then
		return self:GetStackCount()
	else
		return nil
	end
end

function modifier_frantic:GetModifierPercentageCooldown()
	if self:GetStackCount() == CustomNetTables:GetTableValue("game_options", "frantic").super_frantic then
		return self:GetStackCount()
	else
		return nil
	end
end

function modifier_frantic:GetModifierPercentageManacost()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end
