-- Author: AltiV
-- July 25th, 2018
--
-- This script keeps units in bounds of the maps if they try to leave or are forcibly pushed out
-- Note that there are still some corners of the map that you can force staff out of, but hopefully 
-- it's such an edge case that it won't be abused (not like there's much way TO abuse it)
--
-- Rough numbers for boundaries
-- b = Boundary
-- Left/Right/Top/Bottom = Specific edge of map
-- Out = Number on which unit has gone too far out
-- In = Number on which to set unit back on w.r.t. coordinate
local bLeftOut = -8000
local bLeftIn = -7800

local bRightOut = 8000
local bRightIn = 7800

local bTopOut = 7800
local bTopIn = 7500

local bBottomOut = -7500
local bBottomIn = -7200

-- Putting instantiation of pos variable out here
local pos

modifier_boundaries = modifier_boundaries or class({})

function modifier_boundaries:IsDebuff() return false end
function modifier_boundaries:RemoveOnDeath() return false end
function modifier_boundaries:IsPurgable() return false end
function modifier_boundaries:IsPurgeException() return false end
function modifier_boundaries:IsHidden() return true end

function modifier_boundaries:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	-- Setting IntervalThink to a modest 0.5 seconds, as too fast makes for some weird model stretching...
	self:StartIntervalThink(0.5)
end

function modifier_boundaries:OnIntervalThink()
	if not IsServer() then return end
	pos = self.parent:GetAbsOrigin()
	
	-- Putting max/min guards for edge cases where people jump out of map corners (only somewhat works)
	if pos.x < bLeftOut then
		print("Outside Left Boundary! Warping unit back in bounds...")
		self.parent:SetAbsOrigin(Vector(bLeftIn, max(min(pos.y, bTopIn), bBottomIn), pos.z))
		self.parent:SetUnitOnClearGround()
	end
	
	if pos.x > bRightOut then
		print("Outside Right Boundary! Warping unit back in bounds...")
		self.parent:SetAbsOrigin(Vector(bRightIn, max(min(pos.y, bTopIn), bBottomIn), pos.z))
		self.parent:SetUnitOnClearGround()
	end
	
	if pos.y > bTopOut then
		print("Outside Top Boundary! Warping unit back in bounds...")
		self.parent:SetAbsOrigin(Vector(max(min(pos.x, bRightIn), bLeftIn), bTopIn, pos.z))
		self.parent:SetUnitOnClearGround()
	end
	
	if pos.y < bBottomOut then
		print("Outside Bottom Boundary! Warping unit back in bounds...")
		self.parent:SetAbsOrigin(Vector(max(min(pos.x, bRightIn), bLeftIn), bBottomIn, pos.z))
		self.parent:SetUnitOnClearGround()
	end
	
	-- self.parent:SetUnitOnClearGround() is not put outside the if statements because it should not be getting called all the time
end
