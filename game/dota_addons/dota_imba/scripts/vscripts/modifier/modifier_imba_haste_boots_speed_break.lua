--[[	Author: Firetoad
		Date: 08.07.2016	]]

if modifier_imba_haste_boots_speed_break == nil then
	modifier_imba_haste_boots_speed_break = class({})
end

function modifier_imba_haste_boots_speed_break:OnCreated( kv )	
	if IsServer() then
	end
end

function modifier_imba_haste_boots_speed_break:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX
	}
 
	return funcs
end

function modifier_imba_haste_boots_speed_break:GetModifierMoveSpeed_Max()
	return 625
end

function modifier_imba_haste_boots_speed_break:IsHidden()
	return true
end