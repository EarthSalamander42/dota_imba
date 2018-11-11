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
		By: AtroCty
		Date: 11.05.2017
		Updated:  11.05.2017
	]]

item_imba_aegis = item_imba_aegis or class({})
LinkLuaModifier("modifier_item_imba_aegis", "components/items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_aegis:GetAbilityTextureName()
	return "custom/imba_aegis"
end


modifier_item_imba_aegis = modifier_item_imba_aegis or class({})
-- Passive modifier
function modifier_item_imba_aegis:OnCreated()
	-- Parameters
	local item = self:GetAbility()
	self:SetDuration(item:GetSpecialValueFor("disappear_time"),true)
	self.reincarnate_time = item:GetSpecialValueFor("reincarnate_time")
	self.vision_radius = item:GetSpecialValueFor("vision_radius")
end

function modifier_item_imba_aegis:OnRefresh()
	self:SetDuration(self:GetAbility():GetSpecialValueFor("disappear_time"),true)
end

function modifier_item_imba_aegis:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_REINCARNATION,
			MODIFIER_EVENT_ON_DEATH
		}
	return decFuncs
end

function modifier_item_imba_aegis:GetTexture()
	return "custom/imba_aegis"
end

function modifier_item_imba_aegis:GetPriority()
	return 100
end

function modifier_item_imba_aegis:ReincarnateTime()
	if IsServer() then
		local parent = self:GetParent()
		-- Refresh all your abilities
		for i = 0, 15 do
			local current_ability = parent:GetAbilityByIndex(i)

			-- Refresh
			if current_ability then
				current_ability:EndCooldown()
			end
		end
		self:GetAbility():CreateVisibilityNode(parent:GetAbsOrigin(), self.vision_radius, self.reincarnate_time)
		local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle, 1, Vector(self.reincarnate_time,0,0))
		ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end
	return self.reincarnate_time
end

function modifier_item_imba_aegis:OnDeath(keys)
	if keys.unit == self:GetParent() then
		Timers:CreateTimer(FrameTime(), function()
			self:Destroy()
		end)
	end
end

function modifier_item_imba_aegis:IsDebuff() return false end
function modifier_item_imba_aegis:IsHidden() return false end
function modifier_item_imba_aegis:IsPurgable() return false end
function modifier_item_imba_aegis:IsPurgeException() return false end
function modifier_item_imba_aegis:IsStunDebuff() return false end
function modifier_item_imba_aegis:RemoveOnDeath() return false end

function modifier_item_imba_aegis:OnDestroy()
	if IsServer() then
		local item = self:GetAbility()

		if self:GetParent():IsAlive() then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_imba_regen_rune", {duration = GetItemKV("item_imba_rune_regen", "RuneDuration")})
			self:GetParent():EmitSound("Aegis.Expire")
		end

		UTIL_Remove(item:GetContainer())
		UTIL_Remove(item)
	end
end
