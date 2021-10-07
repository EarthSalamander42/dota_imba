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
--    

--[[
		Author: MouJiaoZi
		Date: 2017/12/12

]]

--[[
LinkLuaModifier("modifier_imba_teleporting", "components/items/item_tp", LUA_MODIFIER_MOTION_NONE)

modifier_imba_teleporting = modifier_imba_teleporting or class({})

function modifier_imba_teleporting:IsHidden() return false end
function modifier_imba_teleporting:IsPurgable() return false end
function modifier_imba_teleporting:IsDebuff() return false end
function modifier_imba_teleporting:RemoveOnDeath() return true end
function modifier_imba_teleporting:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_teleporting:OnCreated()
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_TELEPORT)
end

function modifier_imba_teleporting:OnDestroy()
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_TELEPORT)
	self:GetCaster():StartGesture(ACT_DOTA_TELEPORT_END)
end

function FindBuildingToTeleport(caster, target_pos, max_distance)
	local location = Vector(0,0,0)
	local building = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, max_distance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if #building >= 1 then
		if CalculateDistance(building[1], target_pos) < max_distance + 80 then
			location = target_pos
		else
			local buildings = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
			local building_pos = buildings[1]:GetAbsOrigin()
			location = GetGroundPosition((((target_pos - building_pos):Normalized() * (max_distance + 80)) + building_pos), nil)
		end
	else
		local buildings = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local building_pos = buildings[1]:GetAbsOrigin()
		location = GetGroundPosition((((target_pos - building_pos):Normalized() * (max_distance + 80)) + building_pos), nil)
	end
	return location
end

item_tpscroll = item_tpscroll or class({})

function item_tpscroll:GetAOERadius() return self:GetSpecialValueFor("maximum_distance") end

function item_tpscroll:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local max_distance = ability:GetSpecialValueFor("maximum_distance")
	local start_pfx_name = "particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = "particles/items2_fx/teleport_end.vpcf"
	self.location = FindBuildingToTeleport(caster, ability:GetCursorPosition(), max_distance)
	if target and caster == target then -- self cast: teleport to base
		local buildings = FindUnitsInRadius(caster:GetTeamNumber(), ability:GetCursorPosition(), nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
		for _, i in pairs(buildings) do
			if IsFountain(i) then
				local building_pos = i:GetAbsOrigin()
				self.location = GetGroundPosition((((ability:GetCursorPosition() - building_pos):Normalized() * max_distance) + building_pos), nil)
				break
			end
		end
	end
	EmitSoundOn("Portal.Loop_Disappear", caster)
	self.unit = CreateUnitByName("npc_dummy_unit", self.location, false, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("Portal.Loop_Appear", self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, ability:GetChannelTime())
	self.buff = caster:AddNewModifier(caster, ability, "modifier_imba_teleporting", {duration = ability:GetSpecialValueFor("tooltip_channel_time")})
	self.start_pfx = ParticleManager:CreateParticle(start_pfx_name, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(self.start_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 2, Vector(255,255,0))
	ParticleManager:SetParticleControl(self.start_pfx, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 4, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 5, Vector(3,0,0))
	ParticleManager:SetParticleControl(self.start_pfx, 6, caster:GetAbsOrigin())
	self.end_pfx = ParticleManager:CreateParticle(end_pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(self.end_pfx, 0, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 1, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 5, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 4, Vector(1,0,0))
	ParticleManager:SetParticleControlEnt(self.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.location, true)
	self.buff:AddParticle(self.start_pfx, false, false, 1, false, false)
	self.buff:AddParticle(self.end_pfx, false, false, 1, false, false)
end

function item_tpscroll:OnChannelThink( fInterval )
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.location, self:GetSpecialValueFor("vision_radius"), FrameTime(), false)
end

function item_tpscroll:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local ability = self
	if bInterrupted then -- unsuccessful
		self.buff:Destroy()
	else -- successful
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Disappear", caster)
		FindClearSpaceForUnit(caster, self.location, true)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Appear", caster)
	end
	StopSoundOn("Portal.Loop_Disappear", caster)
	StopSoundOn("Portal.Loop_Appear", self.unit)
	UTIL_Remove(self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, -1)

	if self:GetCurrentCharges() == 1 then
		caster:RemoveItem(self)
	else
		self:SetCurrentCharges(self:GetCurrentCharges() - 1)
	end
end




item_imba_travel_boots = item_imba_travel_boots or class({})

function item_imba_travel_boots:GetAOERadius() return self:GetSpecialValueFor("maximum_distance") end

function item_imba_travel_boots:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local max_distance = ability:GetSpecialValueFor("maximum_distance")
	local start_pfx_name = "particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = "particles/items2_fx/teleport_end.vpcf"
	self.location = FindBuildingToTeleport(caster, ability:GetCursorPosition(), max_distance)
	self.tp_to_ground = true

	if target and caster == target then -- self cast: teleport to base
		local buildings = FindUnitsInRadius(caster:GetTeamNumber(), ability:GetCursorPosition(), nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
		for _, i in pairs(buildings) do
			if IsFountain(i) then
				local building_pos = i:GetAbsOrigin()
				self.location = GetGroundPosition((((ability:GetCursorPosition() - building_pos):Normalized() * max_distance) + building_pos), nil)
				break
			end
		end
	elseif target and caster ~= target then -- teleport to creeps
		if target:IsHero() then
			self.location = FindBuildingToTeleport(caster, ability:GetCursorPosition(), max_distance)
		else
			self.tp_to_ground = false
			self.target = target
		end
	end
	EmitSoundOn("Portal.Loop_Disappear", caster)
	self.unit = CreateUnitByName("npc_dummy_unit", self.location, false, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("Portal.Loop_Appear", self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, ability:GetChannelTime())
	self.buff = caster:AddNewModifier(caster, ability, "modifier_imba_teleporting", {duration = ability:GetSpecialValueFor("tooltip_channel_time")})
	self.start_pfx = ParticleManager:CreateParticle(start_pfx_name, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(self.start_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 2, Vector(255,255,0))
	ParticleManager:SetParticleControl(self.start_pfx, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 4, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 5, Vector(3,0,0))
	ParticleManager:SetParticleControl(self.start_pfx, 6, caster:GetAbsOrigin())
	self.end_pfx = ParticleManager:CreateParticle(end_pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(self.end_pfx, 0, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 1, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 5, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 4, Vector(1,0,0))
	ParticleManager:SetParticleControlEnt(self.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.location, true)
	self.buff:AddParticle(self.start_pfx, false, false, 1, false, false)
	self.buff:AddParticle(self.end_pfx, false, false, 1, false, false)
end

function item_imba_travel_boots:OnChannelThink( fInterval )
	if not self.tp_to_ground then
		local caster = self:GetCaster()
		self.location = self.target:GetAbsOrigin()
		self.unit:SetAbsOrigin(self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 0, self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 1, self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 5, Vector(self.location.x,self.location.y,self.location.z + 256))
		ParticleManager:SetParticleControl(self.end_pfx, 4, Vector(1,0,0))
		ParticleManager:SetParticleControlEnt(self.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.location, true)
	end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.location, self:GetSpecialValueFor("vision_radius"), FrameTime(), false)
end

function item_imba_travel_boots:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local ability = self
	if bInterrupted then -- unsuccessful
		self.buff:Destroy()
	else -- successful
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Disappear", caster)
		FindClearSpaceForUnit(caster, self.location, true)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Appear", caster)
	end
	StopSoundOn("Portal.Loop_Disappear", caster)
	StopSoundOn("Portal.Loop_Appear", self.unit)
	UTIL_Remove(self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, -1)
end



item_imba_travel_boots_2 = item_imba_travel_boots_2 or class({})

function item_imba_travel_boots_2:GetAOERadius() return self:GetSpecialValueFor("maximum_distance") end

function item_imba_travel_boots_2:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ability = self
	local max_distance = ability:GetSpecialValueFor("maximum_distance")
	local start_pfx_name = "particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = "particles/items2_fx/teleport_end.vpcf"
	self.location = FindBuildingToTeleport(caster, ability:GetCursorPosition(), max_distance)
	self.tp_to_ground = true

	if target and caster == target then -- self cast: teleport to base
		local buildings = FindUnitsInRadius(caster:GetTeamNumber(), ability:GetCursorPosition(), nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_FARTHEST, false)
		for _, i in pairs(buildings) do
			if IsFountain(i) then
				local building_pos = i:GetAbsOrigin()
				self.location = GetGroundPosition((((ability:GetCursorPosition() - building_pos):Normalized() * max_distance) + building_pos), nil)
				break
			end
		end
	elseif target and caster ~= target then -- teleport to creeps
		self.tp_to_ground = false
		self.target = target
	end
	EmitSoundOn("Portal.Loop_Disappear", caster)
	self.unit = CreateUnitByName("npc_dummy_unit", self.location, false, caster, caster, caster:GetTeamNumber())
	EmitSoundOn("Portal.Loop_Appear", self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, ability:GetChannelTime())
	self.buff = caster:AddNewModifier(caster, ability, "modifier_imba_teleporting", {duration = ability:GetSpecialValueFor("tooltip_channel_time")})
	self.start_pfx = ParticleManager:CreateParticle(start_pfx_name, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(self.start_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 2, Vector(255,255,0))
	ParticleManager:SetParticleControl(self.start_pfx, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 4, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 5, Vector(3,0,0))
	ParticleManager:SetParticleControl(self.start_pfx, 6, caster:GetAbsOrigin())
	self.end_pfx = ParticleManager:CreateParticle(end_pfx_name, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(self.end_pfx, 0, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 1, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 5, self.location)
	ParticleManager:SetParticleControl(self.end_pfx, 4, Vector(1,0,0))
	ParticleManager:SetParticleControlEnt(self.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.location, true)
	self.buff:AddParticle(self.start_pfx, false, false, 1, false, false)
	self.buff:AddParticle(self.end_pfx, false, false, 1, false, false)
end

function item_imba_travel_boots_2:OnChannelThink( fInterval )
	if not self.tp_to_ground then
		local caster = self:GetCaster()
		self.location = self.target:GetAbsOrigin()
		self.unit:SetAbsOrigin(self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 0, self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 1, self.location)
		ParticleManager:SetParticleControl(self.end_pfx, 5, Vector(self.location.x,self.location.y,self.location.z + 256))
		ParticleManager:SetParticleControl(self.end_pfx, 4, Vector(1,0,0))
		ParticleManager:SetParticleControlEnt(self.end_pfx, 3, caster, PATTACH_CUSTOMORIGIN, "attach_hitloc", self.location, true)
	end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.location, self:GetSpecialValueFor("vision_radius"), FrameTime(), false)
end

function item_imba_travel_boots_2:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local ability = self
	if bInterrupted then -- unsuccessful
		self.buff:Destroy()
	else -- successful
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Disappear", caster)
		FindClearSpaceForUnit(caster, self.location, true)
		EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Portal.Hero_Appear", caster)
	end
	StopSoundOn("Portal.Loop_Disappear", caster)
	StopSoundOn("Portal.Loop_Appear", self.unit)
	UTIL_Remove(self.unit)
	MinimapEvent(caster:GetTeamNumber(), caster, self.location.x, self.location.y, DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING, -1)
end
--]]
