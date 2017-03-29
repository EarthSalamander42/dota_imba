--[[	Author: Firetoad
		Date: 29.09.2015	]]

if modifier_imba_speed_limit_break == nil then
	modifier_imba_speed_limit_break = class({})
end

function modifier_imba_speed_limit_break:OnCreated( kv )	
	if IsServer() then
	end
end

function modifier_imba_speed_limit_break:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_MAX
	}
 
	return funcs
end

function modifier_imba_speed_limit_break:GetModifierMoveSpeed_Max()
	return 10000
end
function modifier_imba_speed_limit_break:GetPriority()
    return MODIFIER_PRIORITY_HIGH end
   
function modifier_imba_speed_limit_break:IsHidden()
	return true
end