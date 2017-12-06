--[[	Author: Firetoad
		Date: 29.12.2016	]]

if modifier_courier_hack == nil then
	modifier_courier_hack = class({})
end

function modifier_courier_hack:IsPurgable() return true end
function modifier_courier_hack:IsHidden() return true end

function modifier_courier_hack:OnCreated( kv )	
	if IsServer() then
	end
end

function modifier_courier_hack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_courier_hack:GetModifierMoveSpeed_Absolute()
    return 1000
end

function modifier_courier_hack:GetModifierMoveSpeed_Max()
	return 1000
end
