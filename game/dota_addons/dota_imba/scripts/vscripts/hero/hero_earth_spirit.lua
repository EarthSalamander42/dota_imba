-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     EarthSalamander #42, 03.12.2017

-- Rolling Boulder
imba_earth_spirit_rolling_boulder = class({})

function imba_earth_spirit_rolling_boulder:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_earth_spirit_rolling_boulder", {})
end

LinkLuaModifier( "modifier_imba_earth_spirit_rolling_boulder", "hero/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE )	-- Backstab and invisibility handler

modifier_imba_earth_spirit_rolling_boulder = class({})

function modifier_imba_earth_spirit_rolling_boulder:IsDebuff() return false end
function modifier_imba_earth_spirit_rolling_boulder:IsHidden() return false end
function modifier_imba_earth_spirit_rolling_boulder:IsPurgable() return false end
function modifier_imba_earth_spirit_rolling_boulder:IsStunDebuff() return false end
function modifier_imba_earth_spirit_rolling_boulder:IsMotionController()  return true end
function modifier_imba_earth_spirit_rolling_boulder:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_earth_spirit_rolling_boulder:OnCreated()
	self.cast_position = self:GetParent():GetAbsOrigin()
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
	self.distance = self:GetAbility():GetSpecialValueFor("distance")
	self.remnant_hit = false

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_earth_spirit_rolling_boulder:OnIntervalThink()
	if self.remnant_hit == false then
		if self.remnant_hit == false then
			local remnants = FindUnitsInRadius(self:GetParent():GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

			for _, remnant in pairs(remnants) do
				if remnant:GetUnitName() == "npc_dota_earth_spirit_stone" and (self:GetParent():GetAbsOrigin() - remnant:GetAbsOrigin()):Length2D() < 50 then
					self.remnant_hit = true
					self.distance = self:GetAbility():GetSpecialValueFor("rock_distance")
					self.speed = self:GetAbility():GetSpecialValueFor("rock_speed")
					remnant:ForceKill(false)
				end
			end
		end
	end

	if (self.cast_position - self:GetParent():GetAbsOrigin()):Length2D() > self.distance then
		self:GetParent():RemoveModifierByName("modifier_imba_earth_spirit_rolling_boulder")
	end

	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_imba_earth_spirit_rolling_boulder:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local distance = (self.distance / self.speed) / FrameTime()
	print(self.speed, distance)
	GridNav:DestroyTreesAroundPoint(unit:GetAbsOrigin(), 80, false)
	local pos_p = self.angle * distance
	local next_pos = GetGroundPosition(unit:GetAbsOrigin() + pos_p, unit)
	unit:SetAbsOrigin(next_pos)
end
