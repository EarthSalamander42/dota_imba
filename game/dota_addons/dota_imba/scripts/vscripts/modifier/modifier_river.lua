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
		self:GetParent().slideVector = 10
		self.speed = 10
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_river:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
--		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end

--	function modifier_river:GetModifierMoveSpeedBonus_Percentage()
--		if self:GetStackCount() == 1 then
--			return -100
--		else
--			return 0
--		end
--	end

--	function modifier_river:GetOverrideAnimation()
--		if self:GetStackCount() == 1 then
--			return ACT_DOTA_FLAIL
--		else
--			return nil
--		end
--	end
--	
--	function modifier_river:GetOverrideAnimationRate()
--		if self:GetStackCount() == 1 then
--			return 1.0
--		end
--	end

--	function modifier_river:OnOrder(keys)
--		if IsServer() then
--			local order_type = keys.order_type
--			local unit = keys.unit
--	
--			if unit == self:GetParent() then
--				if self:GetStackCount() == 1 then
--					if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or DOTA_UNIT_ORDER_ATTACK_MOVE then
--						print("move to position and stop!")
--						Timers:CreateTimer(FrameTime() *2, function()
--							unit:Stop()
--						end)
--					end
--				end
--			end
--		end
--	end

function modifier_river:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		if self:IsInRiver() then
			if parent:IsRealHero() then
				local forwardPoint = parent:GetAbsOrigin() + (parent.slideVector * self.speed * FrameTime())
				local rotateInterval = 1
				
				if GridNav:IsTraversable(forwardPoint) then
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
				end
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
