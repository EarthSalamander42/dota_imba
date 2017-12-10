--[[
modifier_river = class({})

function modifier_river:IsHidden() return true end
function modifier_river:IsDebuff() return false end
function modifier_river:IsPurgable() return false end

function modifier_river:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_river:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if self:IsInRiver() then
			if not parent:HasModifier("modifier_ice_slide") then
				parent:AddNewModifier(nil, nil, "modifier_ice_slide", {})
			end
		else
			parent:RemoveModifierByName("modifier_ice_slide")
		end
	end
end

function modifier_river:IsInRiver()
	local parent = self:GetParent()
	local origin = parent:GetAbsOrigin()
	if parent:GetUnitName() == "npc_dota_elder_titan_ancestral_spirit" or parent:GetUnitName() == "npc_dota_gyrocopter_homing_missile" then return end

	if origin.z < 160 and parent:HasGroundMovementCapability() then
		return true
	else
		return false
	end
end
--]]

modifier_river = class({})

function modifier_river:IsHidden() return true end
function modifier_river:IsDebuff() return false end
function modifier_river:IsPurgable() return false end

function modifier_river:OnCreated()
	if IsServer() then
		self.speed = 10
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_river:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if parent:IsRealHero() then
			if self:IsInRiver() and slidevector == nil then -- start sliding
				parent.slideVector = parent:GetForwardVector() * self.speed
				parent:SetAbsOrigin(parent:GetAbsOrigin() + parent.slideVector)
			else if self:IsInRiver() then -- continue sliding
				
			else
				slideVector = nil
			end
		end
	end
end

function modifier_river:IsInRiver()
	local parent = self:GetParent()
	local origin = parent:GetAbsOrigin()

	if origin.z < 160 and parent:HasGroundMovementCapability() then
		return true
	else
		return false
	end
end
--]]

function modifier_river:GetCorrectPoint()
local parent = self:GetParent()
local forwardPoint = parent:GetAbsOrigin() + (parent.slideVector * self.speed * FrameTime())
local rotateInterval = 1
local leftRotation = 0
local rightRotation = 0

local leftPoint = forwardPoint
local rightPoint = forwardPoint
local correctPoint

	while not correctPoint do
		leftRotation = leftRotation - rotateInterval
		rightRotation = rightRotation + rotateInterval

		leftPoint = RotatePosition(parent:GetAbsOrigin(), QAngle(0, leftRotation, 0), forwardPoint)
		rightPoint = RotatePosition(parent:GetAbsOrigin(), QAngle(0, rightRotation, 0), forwardPoint)

		if GridNav:IsTraversable(leftPoint) then
			correctPoint = leftPoint
		elseif GridNav:IsTraversable(rightPoint) then
			correctPoint = rightPoint
		end

		if rightRotation > 360 then
			correctPoint = rightPoint
		end
	end
	print(correctPoint, GridNav:IsTraversable(forwardPoint))
	return correctPoint
end
