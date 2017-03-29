--[[	Author: Firetoad
		Date: 27.02.2017	]]

if modifier_imba_frantic == nil then
	modifier_imba_frantic = class({})
end

function modifier_imba_frantic:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING ,
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
 
	return funcs
end

function modifier_imba_frantic:GetModifierPercentageCooldownStacking()
	return 70
end

function modifier_imba_frantic:GetModifierPercentageManacost()
	return 70
end

function modifier_imba_frantic:GetModifierPercentageCasttime()
	return 70
end

function modifier_imba_frantic:IsHidden()
	return true
end

function modifier_imba_frantic:IsPermanent()
	return true
end