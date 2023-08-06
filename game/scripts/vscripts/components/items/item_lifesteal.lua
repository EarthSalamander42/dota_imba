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

-- Author: Shush
-- Date: 12.03.2017

-----------------------
--    MORBID MASK    --
-----------------------

item_imba_morbid_mask = class({})
LinkLuaModifier("modifier_imba_morbid_mask", "components/items/item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_morbid_mask_unique", "components/items/item_lifesteal.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_morbid_mask:GetIntrinsicModifierName()
	return "modifier_imba_morbid_mask"
end

function item_imba_morbid_mask:GetAbilityTextureName()
	return "item_lifesteal"
end

-- morbid mask modifier
modifier_imba_morbid_mask = class({})

function modifier_imba_morbid_mask:IsHidden()		return true end
function modifier_imba_morbid_mask:IsPurgable()		return false end
function modifier_imba_morbid_mask:RemoveOnDeath()	return false end
function modifier_imba_morbid_mask:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_morbid_mask:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"

	if self.ability then
		-- Ability specials
		self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")

		if IsServer() then
			-- Change to lifesteal projectile, if there's nothing "stronger"
			ChangeAttackProjectileImba(self.caster)

			if not self.caster:HasModifier("modifier_imba_morbid_mask_unique") then
				self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_morbid_mask_unique", {})
			end
		end
	end
end

function modifier_imba_morbid_mask:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_imba_morbid_mask:OnDestroy()
	if IsServer() then
		if self.caster and not self.caster:IsNull() and not self.caster:HasModifier("modifier_imba_morbid_mask") then
			self.caster:RemoveModifierByName("modifier_imba_morbid_mask_unique")
			
			-- Remove lifesteal projectile
			ChangeAttackProjectileImba(self.caster)
		end
	end
end

modifier_imba_morbid_mask_unique = class({})
function modifier_imba_morbid_mask_unique:IsHidden() return true end
function modifier_imba_morbid_mask_unique:IsPurgable() return false end
function modifier_imba_morbid_mask_unique:RemoveOnDeath() return false end

function modifier_imba_morbid_mask_unique:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	-- Ability specials
	self.lifesteal_pct = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
end

function modifier_imba_morbid_mask_unique:OnRefresh()
	self:OnCreated()
end

function modifier_imba_morbid_mask_unique:GetModifierLifesteal()
	return self.lifesteal_pct
end
