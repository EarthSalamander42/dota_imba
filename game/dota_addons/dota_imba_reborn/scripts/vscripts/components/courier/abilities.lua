--[[	Author: EarthSalamander #42
		Date: 29.01.2018	]]

courier_movespeed = class({})

function courier_movespeed:GetIntrinsicModifierName()
	return "modifier_courier_turbo"
end

LinkLuaModifier("modifier_courier_turbo", "components/courier/abilities.lua", LUA_MODIFIER_MOTION_NONE)

modifier_courier_turbo = modifier_courier_turbo or class({})

function modifier_courier_turbo:IsPurgable() return false end
function modifier_courier_turbo:IsHidden() return true end
function modifier_courier_turbo:RemoveOnDeath() return false end
--[[
function modifier_courier_turbo:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_courier_flying", {})
	end
end
--]]
function modifier_courier_turbo:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end

function modifier_courier_turbo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}

	return funcs
end

function modifier_courier_turbo:GetModifierModelChange()
    return "models/props_gameplay/donkey_wings.vmdl"
end

function modifier_courier_turbo:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_courier_turbo:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end
