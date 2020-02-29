LinkLuaModifier("modifier_mutation_river_flows_boost", "components/modifiers/mutation/modifier_mutation_river_flows.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_river_flows = modifier_mutation_river_flows or class({})
function modifier_mutation_river_flows:IsHidden() return true end
function modifier_mutation_river_flows:IsDebuff() return false end
function modifier_mutation_river_flows:IsPurgable() return false end
function modifier_mutation_river_flows:RemoveOnDeath() return false end

function modifier_mutation_river_flows:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_mutation_river_flows:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if self:IsInRiver() then
			if not parent:HasModifier("modifier_mutation_river_flows_boost") then
				parent:AddNewModifier(parent, nil, "modifier_mutation_river_flows_boost", {})
			end
		else
			parent:RemoveModifierByName("modifier_mutation_river_flows_boost")
		end
	end
end

function modifier_mutation_river_flows:IsInRiver()
	local parent = self:GetParent()
	local origin = parent:GetAbsOrigin()
	if parent:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" or parent:GetUnitName() == "npc_dota_gyrocopter_homing_missile" then return end

	-- Add additional logic to allow shadow blade / silver edge usage to also be in check for river
	if origin.z < 160 and (parent:HasGroundMovementCapability() or parent:HasModifier("modifier_item_imba_shadow_blade_invis") or parent:HasModifier("modifier_item_imba_silver_edge_invis")) then
		return true
	else
		return false
	end
end

modifier_mutation_river_flows_boost = class({})
function modifier_mutation_river_flows_boost:IsHidden() return false end
function modifier_mutation_river_flows_boost:IsDebuff() return false end
function modifier_mutation_river_flows_boost:IsPurgable() return false end

function modifier_mutation_river_flows_boost:GetTexture()
	return "morphling_waveform"
end

function modifier_mutation_river_flows_boost:GetEffectName()
	return "particles/item/boots/haste_boots_speed_boost.vpcf"
end

function modifier_mutation_river_flows_boost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX
		
	}
	return funcs
end

function modifier_mutation_river_flows_boost:GetModifierMoveSpeed_Absolute()
	return _G.IMBA_MUTATION_RIVER_FLOWS_MOVESPEED or 1000
end

function modifier_mutation_river_flows_boost:GetModifierMoveSpeed_Max()
	return math.huge
end
