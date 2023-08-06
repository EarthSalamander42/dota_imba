--[[	Author: Firetoad
		Date: 29.12.2016	]]

if modifier_imba_haste_rune_speed_limit_break == nil then
	modifier_imba_haste_rune_speed_limit_break = class({})
end

function modifier_imba_haste_rune_speed_limit_break:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_imba_haste_rune_speed_limit_break:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_imba_haste_rune_speed_limit_break:IsPurgable()
	return true
end

function modifier_imba_haste_rune_speed_limit_break:IsHidden()
	return true
end
