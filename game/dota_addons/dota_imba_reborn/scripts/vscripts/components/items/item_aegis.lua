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



LinkLuaModifier("modifier_item_imba_aegis", "components/items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_aegis_pfx", "components/items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_aegis					= item_imba_aegis or class({})
modifier_item_imba_aegis		= modifier_item_imba_aegis or class({})
modifier_item_imba_aegis_pfx	= modifier_item_imba_aegis_pfx or class({})

function item_imba_aegis:GetAbilityTextureName()
	return "custom/imba_aegis"
end

function modifier_item_imba_aegis:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end

	-- Parameters
	self:SetDuration(GetAbilitySpecial("item_imba_aegis", "disappear_time"), true)
	self.reincarnate_time = GetAbilitySpecial("item_imba_aegis", "reincarnate_time")

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_aegis_pfx", {})
end

function modifier_item_imba_aegis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_item_imba_aegis:GetTexture()
	return "custom/imba_aegis"
end

function modifier_item_imba_aegis:GetPriority()
	return 100
end

function modifier_item_imba_aegis:ReincarnateTime()
	if IsServer() then
		-- Commenting out ability refreshing
		
		-- Refresh all your abilities
		-- for i = 0, 15 do
			-- local current_ability = parent:GetAbilityByIndex(i)

			-- -- Refresh
			-- if current_ability then
				-- current_ability:EndCooldown()
			-- end
		-- end
	end

	return self.reincarnate_time
end

function modifier_item_imba_aegis:OnDeath(keys)
	if keys.unit == self:GetParent() or keys.unit:GetCloneSource() == self:GetParent() then
		Timers:CreateTimer(FrameTime(), function()
			self:Destroy()
		end)
	end
end

function modifier_item_imba_aegis:IsPurgable() return false end
function modifier_item_imba_aegis:IsPurgeException() return false end
function modifier_item_imba_aegis:RemoveOnDeath() return false end

function modifier_item_imba_aegis:OnDestroy()
	if not IsServer() then return end

	local item = self:GetAbility()

	if self:GetParent():IsAlive() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_imba_regen_rune", {duration = GetItemKV("item_imba_rune_regen", "RuneDuration")})
		self:GetParent():EmitSound("Aegis.Expire")
		self:GetParent():RemoveModifierByName("modifier_item_imba_aegis_pfx")
	end

	if item then
		if item.GetContainer then
			UTIL_Remove(item:GetContainer())
		end

		UTIL_Remove(item)
	end
end

function modifier_item_imba_aegis_pfx:IsHidden() return true end
function modifier_item_imba_aegis_pfx:IsPurgable() return false end
function modifier_item_imba_aegis_pfx:IsPurgeException() return false end
function modifier_item_imba_aegis_pfx:RemoveOnDeath() return false end

function modifier_item_imba_aegis_pfx:DeclareFunctions() return {
	MODIFIER_EVENT_ON_RESPAWN,
} end

function modifier_item_imba_aegis_pfx:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if not IsServer() then return end

	self.reincarnate_time = GetAbilitySpecial("item_imba_aegis", "reincarnate_time")
	self.vision_radius = GetAbilitySpecial("item_imba_aegis", "vision_radius")
end

function modifier_item_imba_aegis_pfx:OnRespawn(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then
		self:PlayEffects()
		self:Destroy()
	end
end

function modifier_item_imba_aegis_pfx:PlayEffects(keys)
	if not IsServer() then return end

	AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_radius, self.reincarnate_time, false)
	local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 1, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
end
