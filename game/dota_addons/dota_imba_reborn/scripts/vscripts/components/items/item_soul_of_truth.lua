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
		Date: 27.05.2017
		Updated:  27.05.2017
	]]


-------------------------------------------
--			  SOUL OF TRUTH
-------------------------------------------
item_imba_soul_of_truth = item_imba_soul_of_truth or class({})
LinkLuaModifier("modifier_imba_soul_of_truth_buff","components/items/item_soul_of_truth", LUA_MODIFIER_MOTION_NONE)

function item_imba_soul_of_truth:GetAbilityTextureName()
	return "custom/imba_soul_of_truth"
end
-------------------------------------------

function item_imba_soul_of_truth:CastFilterResult()
	if self:GetCaster():HasModifier("modifier_imba_soul_of_truth_buff") then
		return UF_FAIL_CUSTOM
	end
end

function item_imba_soul_of_truth:GetCustomCastError()
	if self:GetCaster():HasModifier("modifier_imba_soul_of_truth_buff") then
		return "#dota_hud_error_soul_of_truth_already_active"
	end
end

function item_imba_soul_of_truth:OnSpellStart()
	if IsServer() then
		-- Parameters
		local hCaster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")

		hCaster:AddNewModifier(hCaster, self, "modifier_imba_soul_of_truth_buff", {duration = duration})
		hCaster:AddNewModifier(hCaster, self, "modifier_item_imba_gem_of_true_sight", {duration = duration})
		self:Destroy()
	end
end

-------------------------------------------
modifier_imba_soul_of_truth_buff = modifier_imba_soul_of_truth_buff or class({})
function modifier_imba_soul_of_truth_buff:IsDebuff() return false end
function modifier_imba_soul_of_truth_buff:IsHidden() return false end
function modifier_imba_soul_of_truth_buff:IsPurgable() return false end
function modifier_imba_soul_of_truth_buff:IsPurgeException() return false end
function modifier_imba_soul_of_truth_buff:IsStunDebuff() return false end
function modifier_imba_soul_of_truth_buff:RemoveOnDeath() return false end
-------------------------------------------
function modifier_imba_soul_of_truth_buff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	local hItem = self:GetAbility()

	if hItem then
		self.radius = hItem:GetSpecialValueFor("radius")
		self.armor = hItem:GetSpecialValueFor("armor")
		self.health_regen = hItem:GetSpecialValueFor("health_regen")
	elseif not self:GetParent():IsRealHero() then
		local main_hero = self:GetParent():GetOwner():GetAssignedHero()
		local main_hero_modifier = main_hero:FindModifierByName(self:GetName())		
		if main_hero and main_hero_modifier then
			self.radius = main_hero_modifier.radius
			self.armor = main_hero_modifier.armor
			self.health_regen = main_hero_modifier.health_regen
		end
	end

	self.eye_pfx = ParticleManager:CreateParticle("particles/item/soul_of_truth/soul_of_truth_overhead.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	self:AddParticle(self.eye_pfx, false, false, MODIFIER_PRIORITY_HIGH, false, false)
end

function modifier_imba_soul_of_truth_buff:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN
	}
end

-- function modifier_imba_soul_of_truth_buff:GetModifierPhysicalArmorBonus()
	-- return self.armor
-- end

-- function modifier_imba_soul_of_truth_buff:GetModifierConstantHealthRegen()
	-- return self.health_regen
-- end

function modifier_imba_soul_of_truth_buff:OnDeath(keys)
	if (keys.unit == self:GetParent()) and (not keys.reincarnate) then
		if keys.unit:IsTempestDouble() and keys.attacker == keys.unit then return end
		if self.eye_pfx then
			ParticleManager:DestroyParticle( self.eye_pfx, false )
			ParticleManager:ReleaseParticleIndex(self.eye_pfx)
			self.eye_pfx = nil
			
			self:Destroy()
		end
	end
end

-- function modifier_imba_soul_of_truth_buff:OnRespawn(keys)
	-- if (keys.unit == self:GetParent()) then
		-- Timers:CreateTimer(0.1, function()
			-- self.eye_pfx = ParticleManager:CreateParticle("particles/item/soul_of_truth/soul_of_truth_overhead.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			-- self:AddParticle(self.eye_pfx, false, false, MODIFIER_PRIORITY_HIGH, false, false)
		-- end)
	-- end
-- end

function modifier_imba_soul_of_truth_buff:OnDestroy()
	if IsServer() then
		local gem = CreateItem("item_imba_gem", nil, nil)

		gem:SetOwner(nil)
		CreateItemOnPositionSync(self:GetParent():GetAbsOrigin(), gem)

		gem.dummy_unit = CreateUnitByName("npc_dummy_unit_perma", self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetCaster():GetTeam())
		gem.dummy_unit:AddNewModifier(self:GetCaster(), gem, "modifier_item_imba_gem_of_true_sight_dropped", {})
	end
end

function modifier_imba_soul_of_truth_buff:GetTexture()
	return "custom/imba_soul_of_truth"
end
