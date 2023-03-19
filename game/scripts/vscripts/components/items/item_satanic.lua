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

-- Editor: AltiV
-- Date: 18.03.2020

-----------------------
--    SATANIC        --
-----------------------

LinkLuaModifier("modifier_imba_satanic", "components/items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_active", "components/items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_soul_slaughter_counter", "components/items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_soul_slaughter_stack", "components/items/item_satanic", LUA_MODIFIER_MOTION_NONE)

item_imba_satanic = item_imba_satanic or class({})

function item_imba_satanic:GetIntrinsicModifierName()
	return "modifier_imba_satanic"
end

function item_imba_satanic:OnSpellStart()
	-- Satanic sound
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())

	-- Unholy rage!
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_satanic_active", { duration = self:GetSpecialValueFor("unholy_rage_duration") })
end

---------------------------
-- MODIFIER_IMBA_SATANIC --
---------------------------

-- Satanic modifier
modifier_imba_satanic = class({})

function modifier_imba_satanic:IsHidden() return true end

function modifier_imba_satanic:IsPurgable() return false end

function modifier_imba_satanic:RemoveOnDeath() return false end

function modifier_imba_satanic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_satanic:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if IsServer() then
		-- Change to lifesteal projectile, if there's nothing "stronger"
		ChangeAttackProjectileImba(self:GetCaster())
	end
end

-- Removes the unique modifier from the caster if this is the last Satanic in its inventory
function modifier_imba_satanic:OnDestroy()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetCaster())
	end
end

function modifier_imba_satanic:GetModifierLifesteal()
	if self:GetAbility() and self:GetParent():FindAllModifiersByName(self:GetName())[1] == self then
		if self:GetParent():HasModifier("modifier_imba_satanic_active") then
			return self:GetAbility():GetSpecialValueFor("lifesteal_pct") + self:GetAbility():GetSpecialValueFor("unholy_rage_lifesteal_bonus")
		else
			return self:GetAbility():GetSpecialValueFor("lifesteal_pct")
		end
	else
		return 0
	end
end

function modifier_imba_satanic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,

		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_satanic:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_imba_satanic:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

function modifier_imba_satanic:GetModifierStatusResistanceStacking()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("status_resistance")
	end
end

function modifier_imba_satanic:OnDeath(keys)
	-- Assumption is that no keys.inflictor means it's a regular attack
	if self:GetAbility() and keys.attacker == self:GetParent() and keys.unit:IsRealHero() and keys.attacker ~= keys.unit and not keys.inflictor then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_satanic_soul_slaughter_counter", { duration = self:GetAbility():GetSpecialValueFor("soul_slaughter_duration") })
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_satanic_soul_slaughter_stack", {
			duration = self:GetAbility():GetSpecialValueFor("soul_slaughter_duration"),
			stacks   = keys.unit:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("soul_slaughter_hp_increase_pct") / 100
		})
	end
end

----------------------------------
-- MODIFIER_IMBA_SATANIC_ACTIVE --
----------------------------------

-- Active Satanic modifier
modifier_imba_satanic_active = modifier_imba_satanic_active or class({})

function modifier_imba_satanic_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

--------------------------------------------------
-- MODIFIER_IMBA_SATANIC_SOUL_SLAUGHTER_COUNTER --
--------------------------------------------------

modifier_imba_satanic_soul_slaughter_counter = modifier_imba_satanic_soul_slaughter_counter or class({})

function modifier_imba_satanic_soul_slaughter_counter:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.soul_slaughter_damage_per_stack = self:GetAbility():GetSpecialValueFor("soul_slaughter_damage_per_stack")
	self.soul_slaughter_hp_per_stack     = self:GetAbility():GetSpecialValueFor("soul_slaughter_hp_per_stack")
end

function modifier_imba_satanic_soul_slaughter_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}
end

function modifier_imba_satanic_soul_slaughter_counter:GetModifierPreAttack_BonusDamage()
	return self.soul_slaughter_damage_per_stack * self:GetStackCount()
end

function modifier_imba_satanic_soul_slaughter_counter:GetModifierHealthBonus()
	return self.soul_slaughter_hp_per_stack * self:GetStackCount()
end

------------------------------------------------
-- MODIFIER_IMBA_SATANIC_SOUL_SLAUGHTER_STACK --
------------------------------------------------

modifier_imba_satanic_soul_slaughter_stack = modifier_imba_satanic_soul_slaughter_stack or class({})

function modifier_imba_satanic_soul_slaughter_stack:IsHidden() return true end

function modifier_imba_satanic_soul_slaughter_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_satanic_soul_slaughter_stack:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end

	self:SetStackCount(keys.stacks)

	if self:GetParent():HasModifier("modifier_imba_satanic_soul_slaughter_counter") then
		self:GetParent():FindModifierByName("modifier_imba_satanic_soul_slaughter_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_satanic_soul_slaughter_counter"):GetStackCount() + self:GetStackCount())
	end
end

function modifier_imba_satanic_soul_slaughter_stack:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_imba_satanic_soul_slaughter_counter") then
		self:GetParent():FindModifierByName("modifier_imba_satanic_soul_slaughter_counter"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_satanic_soul_slaughter_counter"):GetStackCount() - self:GetStackCount())
	end
end
