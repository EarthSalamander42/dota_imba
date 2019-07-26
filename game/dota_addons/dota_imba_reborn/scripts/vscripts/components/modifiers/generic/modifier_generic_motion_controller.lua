-- Creator: AltiV
--   July 22nd, 2019

-- To use this in other files, include these two lines:

-- LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

-- <<insert modifier_name here>> = modifier_generic_motion_controller -- for overrides
-- OR
-- <<target_unit>>:AddNewModifier(<<caster>>, <<ability>>, "modifier_generic_motion_controller", {distance = <<>> , direction_x = <<>> , direction_y = <<>> , direction_z = <<>> , duration = <<>> , height = <<>> , bInterruptible = <<>> , bGroundStop = <<>> , bDecelerate = <<>> }) -- for standard usage

-- Example:
-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", {distance = 1000, direction_x = self:GetCaster():GetForwardVector().x, direction_y = self:GetCaster():GetForwardVector().y, direction_z = self:GetCaster():GetForwardVector().z, duration = 0.6, height = 250 , bGroundStop = true, bDecelerate = true})

-- Generally I would recommend the override though cause you'll probably need to account for extra stuff like state checking, DeclareFunctions values, particles, being purgable or not, etc.

modifier_generic_motion_controller = class({})

function modifier_generic_motion_controller:IsPurgable()	return self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() end
function modifier_generic_motion_controller:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end -- This seems to allow proper interruption of stacking modifiers or something

-- Function parameters:
-- distance, direction_x, direction_y, direction_z, duration, height, bGroundStop, bDecelerate

-- bGroundStop makes the motion controller if the parent's vertical position would otherwise be lower than the ground position (similar to Techies' Blast Off!)
-- bDecelerate makes the horizontal portion decelerate towards the destination rather than having constant velocity

function modifier_generic_motion_controller:OnCreated(params)
	if not IsServer() then return end
	
	self.distance		= params.distance
	self.direction		= Vector(params.direction_x, params.direction_y, params.direction_z):Normalized()
	self.duration		= params.duration
	self.height			= params.height
	self.bInterruptible	= params.bInterruptible
	self.bGroundStop	= params.bGroundStop
	self.bDecelerate	= params.bDecelerate
	
	-- Velocity = Displacement/Time
	self.velocity		= self.direction * self.distance / self.duration
	
	-- If decelerating...
	-- Horizontal Starting Velocity
	-- Rationale: distance = (initial_velocity + final_velocity) * time / 2
	
	-- Final_velocity is 0, so:
	-- distance = (initial_velocity) * time / 2
	
	-- Solve for initial_velocity:
	-- initial_velocity = 2 * distance / time
	
	-- Using this for self.horizontal_velocity
	
	
	
	-- Horizontal Acceleration (if applicable)
	-- Rationale: acceleration = (final_velocity - initial_velocity) / time
	
	-- Final_velocity is 0, so:
	-- acceleration = -initial_velocity / * time
	
	-- Substitute for initial_velocity solved above:
	-- acceleration = -(2 * distance / time) / time
	-- acceleration = -(2 * distance) / time^2
	
	-- Using this for self.horizontal_acceleration
	if self.bDecelerate and self.bDecelerate == 1 then
		self.horizontal_velocity		= (2 * self.distance / self.duration) * self.direction
		self.horizontal_acceleration 	= -(2 * self.distance) / (self.duration * self.duration)
	end
	
	-- Vertical Starting Velocity (if applicable)
	-- Rationale: distance = (initial_velocity + final_velocity) * time / 2
	
	-- At half (0.5) time, final_velocity is 0, so:
	-- distance = (initial_velocity) * 0.5 * time / 2
	
	-- Solve for initial_velocity:
	-- initial_velocity = distance * 2 / (0.5 * time)
	-- initial_velocity = 4 * distance / time
	
	-- Using this for self.vertical_velocity (more like distance cause no directional but w/e)
	
	
	
	-- Vertical Acceleration (if applicable)
	-- Rationale: acceleration = (final_velocity - initial_velocity) / time
	
	-- At half (0.5) time, final_velocity is 0, so:
	-- acceleration = -initial_velocity / (0.5 * time)
	
	-- Substitute for initial_velocity solved above:
	-- acceleration = -(4 * distance / time) / (0.5 * time)
	-- acceleration = -(8 * distance) / time^2
	
	-- Using this for self.vertical_acceleration
	
	if self.height then
		self.vertical_velocity		= 4 * self.height / self.duration
		self.vertical_acceleration	= -(8 * self.height) / (self.duration * self.duration)
	end
	
	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
end

function modifier_generic_motion_controller:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():InterruptMotionControllers(true)
end

function modifier_generic_motion_controller:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end
	
	if not self.bDecelerate or self.bDecelerate == 0 then
		me:SetOrigin( me:GetOrigin() + self.velocity * dt )
	else
		me:SetOrigin( me:GetOrigin() + (self.horizontal_velocity * dt) )
		self.horizontal_velocity = self.horizontal_velocity + (self.direction * self.horizontal_acceleration * dt)
	end
	
	if self.bInterruptible == 1 and self:GetParent():IsStunned() then
		self:Destroy()
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_generic_motion_controller:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_generic_motion_controller:UpdateVerticalMotion(me, dt)
	if not IsServer() then return end
	
	if self.height then
		me:SetOrigin( me:GetOrigin() + Vector(0, 0, self.vertical_velocity) * dt )
		
		if self.bGroundStop == 1 and GetGroundHeight(self:GetParent():GetAbsOrigin(), nil) > self:GetParent():GetAbsOrigin().z then
			self:Destroy()
		else
			self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * dt)
		end
	else
		me:SetOrigin( GetGroundPosition(me:GetOrigin(), nil) )
	end
end

-- -- This typically gets called if the caster uses a position breaking tool (ex. Earth Spike) while in mid-motion
function modifier_generic_motion_controller:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_generic_motion_controller:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_generic_motion_controller:GetOverrideAnimation( params )
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return ACT_DOTA_FLAIL
	end
end
