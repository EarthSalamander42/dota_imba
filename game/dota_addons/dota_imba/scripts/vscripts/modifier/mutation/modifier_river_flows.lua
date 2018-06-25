LinkLuaModifier("modifier_river_flows_movementspeed", "modifier/mutation/modifier_river_flows.lua", LUA_MODIFIER_MOTION_NONE )

modifier_river_flows = modifier_river_flows or class({})
function modifier_river_flows:IsHidden() return true end
function modifier_river_flows:IsDebuff() return false end
function modifier_river_flows:IsPurgable() return false end

function modifier_river_flows:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_river_flows:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if self:IsInRiver() then
			if not parent:HasModifier("modifier_river_flows_movementspeed") then
				parent:AddNewModifier(parent, nil, "modifier_river_flows_movementspeed", {})
			end
		else
			parent:RemoveModifierByName("modifier_river_flows_movementspeed")
		end
	end
end

function modifier_river_flows:IsInRiver()
	local parent = self:GetParent()
	local origin = parent:GetAbsOrigin()
	if parent:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" or parent:GetUnitName() == "npc_dota_gyrocopter_homing_missile" then return end

	if origin.z < 160 and parent:HasGroundMovementCapability() then
		return true
	else
		return false
	end
end

modifier_river_flows_movementspeed = class({})
function modifier_river_flows_movementspeed:IsHidden() return false end
function modifier_river_flows_movementspeed:IsDebuff() return false end
function modifier_river_flows_movementspeed:IsPurgable() return false end

function modifier_river_flows_movementspeed:GetTexture()
	return "item_boots"
end

function modifier_river_flows_movementspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_river_flows_movementspeed:GetModifierMoveSpeedBonus_Percentage()
	return 50
end

function modifier_river_flows_movementspeed:GetModifierMoveSpeed_Max()
	-- becuz gotta go fast! :D 
	return 750
end
