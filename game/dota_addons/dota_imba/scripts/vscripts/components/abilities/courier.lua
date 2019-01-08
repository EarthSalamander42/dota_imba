--[[	Author: EarthSalamander #42
		Date: 29.01.2018	]]

courier_movespeed = class({})

function courier_movespeed:GetIntrinsicModifierName()
	return "modifier_courier_hack"
end

LinkLuaModifier("modifier_courier_hack", "components/abilities/courier", LUA_MODIFIER_MOTION_NONE)

modifier_courier_hack = modifier_courier_hack or class({})

function modifier_courier_hack:IsPurgable() return false end
function modifier_courier_hack:IsHidden() return true end
function modifier_courier_hack:RemoveOnDeath() return false end

function modifier_courier_hack:OnCreated()
	-- fail-safe, not needed since modifier is not removed on death
--	if self:GetParent():HasFlyMovementCapability() then
--		self:SetStackCount(self:GetAbility():GetSpecialValueFor("flying_movespeed"))
--	else
--		self:SetStackCount(self:GetAbility():GetSpecialValueFor("ground_movespeed"))
--	end
end

function modifier_courier_hack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
--		MODIFIER_EVENT_ON_MODEL_CHANGED,
	}

	return funcs
end

function modifier_courier_hack:GetModifierMoveSpeed_Absolute()
    if self:GetParent():HasFlyMovementCapability() then
		return self:GetAbility():GetSpecialValueFor("flying_movespeed")
	else
		return self:GetAbility():GetSpecialValueFor("ground_movespeed")
	end
end

function modifier_courier_hack:GetModifierMoveSpeed_Max()
	if self:GetParent():HasFlyMovementCapability() then
		return self:GetAbility():GetSpecialValueFor("flying_movespeed")
	else
		return self:GetAbility():GetSpecialValueFor("ground_movespeed")
	end
end

-- function modifier_courier_hack:OnModelChanged(keys)
-- 	self:SetStackCount(self:GetAbility():GetSpecialValueFor("flying_movespeed"))
-- end
