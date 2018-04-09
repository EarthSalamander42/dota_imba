--[[	Author: Firetoad
		Date: 29.12.2016	]]

if modifier_courier_hack == nil then
	modifier_courier_hack = class({})
end

function modifier_courier_hack:IsPurgable() return true end
function modifier_courier_hack:IsHidden() return false end
function modifier_courier_hack:RemoveOnDeath() return false end

function modifier_courier_hack:OnCreated( kv )	
	if IsServer() then
		self:SetStackCount(1000)

		-- fail-safe, not needed since modifier is not removed on death
		if string.find(self:GetParent():GetModelName(), "flying") then
			self:SetStackCount(2500)
		end
	end
end

function modifier_courier_hack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_EVENT_ON_MODEL_CHANGED,
	}

	return funcs
end

function modifier_courier_hack:GetModifierMoveSpeed_Absolute()
    return self:GetStackCount()
end

function modifier_courier_hack:GetModifierMoveSpeed_Max()
	return self:GetStackCount()
end

function modifier_courier_hack:OnModelChanged(keys)
	self:SetStackCount(2500)
end
