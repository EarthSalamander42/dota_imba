--[[	Author: Firetoad
		Date: 29.12.2016	]]

if modifier_imba_haste_rune_speed_limit_break == nil then
	modifier_imba_haste_rune_speed_limit_break = class({})
end

function modifier_imba_haste_rune_speed_limit_break:OnCreated( kv )	
	if IsServer() then
	end
end

function modifier_imba_haste_rune_speed_limit_break:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX
	}

	return funcs
end

function modifier_imba_haste_rune_speed_limit_break:GetModifierMoveSpeed_Max()
	return 10000
end

function modifier_imba_haste_rune_speed_limit_break:IsPurgable()
	return true
end

function modifier_imba_haste_rune_speed_limit_break:IsHidden()
	return true
end
