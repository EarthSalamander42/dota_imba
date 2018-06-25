LinkLuaModifier("modifier_sticky_river_slow", "modifier/modifier_sticky_river.lua", LUA_MODIFIER_MOTION_NONE )

modifier_sticky_river = modifier_sticky_river or class({})
function modifier_sticky_river:IsHidden() return true end
function modifier_sticky_river:IsDebuff() return false end
function modifier_sticky_river:IsPurgable() return false end

function modifier_sticky_river:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_sticky_river:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if self:IsInRiver() then
			if not parent:HasModifier("modifier_sticky_river_slow") then
				parent:AddNewModifier(parent, nil, "modifier_sticky_river_slow", {})
			end
		else
			parent:RemoveModifierByName("modifier_sticky_river_slow")
		end
	end
end

function modifier_sticky_river:IsInRiver()
	local parent = self:GetParent()
	local origin = parent:GetAbsOrigin()
	if parent:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" or parent:GetUnitName() == "npc_dota_gyrocopter_homing_missile" then return end

	if origin.z < 160 and parent:HasGroundMovementCapability() then
		return true
	else
		return false
	end
end

modifier_sticky_river_slow = class({})
function modifier_sticky_river_slow:IsHidden() return false end
function modifier_sticky_river_slow:IsDebuff() return false end
function modifier_sticky_river_slow:IsPurgable() return false end

function modifier_sticky_river_slow:GetTexture()
	return "visage_grave_chill"
end

function modifier_sticky_river_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}
	return funcs
end

function modifier_sticky_river_slow:GetModifierMoveSpeed_Absolute()
	return 300
end