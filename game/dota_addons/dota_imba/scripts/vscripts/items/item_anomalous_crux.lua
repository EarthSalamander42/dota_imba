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
--     AltiV (Created August 4th, 2018)
--
-- Original Concept (posted by suthernfriend):
--
-- # <INSERT NAME FOR ITEM HERE>
--
-- ## Stats
-- * + 500 Health
-- * + 500 Mana
-- * + 40 Intelligence
-- * + 15 HP Regen
-- * + 5 Mana Regen
-- * + 30% cooldown reduction
-- * + 35% spell lifesteal
--
-- Suggested effect:
-- ## Passive: Double Strike
-- When not on cooldown, the next ability (or item) you cast gets cast twice.
-- (Does not affect channeled or ultimate abilities)
-- Cooldown: 18 seconds
--
-- Coded effect: 
-- ## Passive: Recollection
-- When not on cooldown, the next ability (or item) you cast gets instantly refreshed.
-- (Does not affect ultimate abilities or abilities with a base cooldown of 1.5 seconds or less)
-- Cooldown: 18 seconds (static)
--
-- ## Build:
-- Octarine Core + Refresher Orb + Staff of Wizardry
-- 5900 + 5100 + 1000 = 12000
--
--
LinkLuaModifier("modifier_imba_anomalous_crux_stats", "items/item_anomalous_crux.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_imba_anomalous_crux_passive", "items/item_anomalous_crux.lua", LUA_MODIFIER_MOTION_NONE )

item_imba_anomalous_crux = class ({})
modifier_imba_anomalous_crux_stats = class ({})
modifier_imba_anomalous_crux_passive = class ({})

---------------
-- Main Item --
---------------

function item_imba_anomalous_crux:IsRefreshable() return false end

function item_imba_anomalous_crux:GetIntrinsicModifierName()
	return "modifier_imba_anomalous_crux_stats"
end

-- Swap between active and inactive icons on toggle
function item_imba_anomalous_crux:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_anomalous_crux_passive") then
		return "custom/imba_anomalous_crux_active"
	else
		return "custom/imba_anomalous_crux_inactive"
	end
end

function item_imba_anomalous_crux:OnSpellStart()
	if not IsServer() then return end
	if self:GetCaster():HasModifier("modifier_imba_anomalous_crux_passive") then
		self:GetCaster():RemoveModifierByName("modifier_imba_anomalous_crux_passive")
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_anomalous_crux_passive", {})
	end
	self:GetCaster():EmitSound("Item.DropGemWorld")
	-- Item does not have any cooldown on toggle
	self:EndCooldown()
end

------------------------
-- Stats / Attributes --
------------------------

function modifier_imba_anomalous_crux_stats:IsHidden() return true end
function modifier_imba_anomalous_crux_stats:IsPurgable() return	false end

function modifier_imba_anomalous_crux_stats:OnCreated()
	if not IsServer() then return end
	if not self:GetParent():HasModifier("modifier_imba_anomalous_crux_passive") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_anomalous_crux_passive", {})
	end
end

function modifier_imba_anomalous_crux_stats:OnDestroy()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_imba_anomalous_crux_passive") then
		self:GetParent():RemoveModifierByName("modifier_imba_anomalous_crux_passive")
	end
end

function modifier_imba_anomalous_crux_stats:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_anomalous_crux_stats:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end

function modifier_imba_anomalous_crux_stats:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health_bonus") -- 500
end

function modifier_imba_anomalous_crux_stats:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("mana_bonus") -- 500
end

function modifier_imba_anomalous_crux_stats:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("intellect_bonus") -- 40
end

function modifier_imba_anomalous_crux_stats:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("health_regen") -- 15
end

function modifier_imba_anomalous_crux_stats:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen") -- 5
end

function modifier_imba_anomalous_crux_stats:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("cooldown_pct") -- 30%
end

function modifier_imba_anomalous_crux_stats:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal") -- 35%
end

-----------------------
-- Refresher Passive --
-----------------------

function modifier_imba_anomalous_crux_passive:IsHidden() return true end
function modifier_imba_anomalous_crux_passive:IsPurgable() return false end

function modifier_imba_anomalous_crux_passive:OnCreated()
	if not IsServer() then return end
	self.ability_name = ""
	self.ability_timer = 0
	self.crux_timer = self:GetAbility():GetCooldown(self:GetAbility():GetLevel())
end

function modifier_imba_anomalous_crux_passive:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
		}
	return decFuncs
end
 
function modifier_imba_anomalous_crux_passive:OnAbilityFullyCast( keys )
	if not IsServer() then return end
	-- Additional check if this was the reset spell to apply cooldown modifications
	-- Reduce cooldown when cast by difference between Anomalous Crux's base cooldown
	-- and its current cooldown time.
	if self.ability_name == keys.ability:GetName() then
		if not keys.ability:IsItem() then
			keys.unit:FindAbilityByName(keys.ability:GetName()):EndCooldown()
			keys.unit:FindAbilityByName(keys.ability:GetName()):StartCooldown(max(self.ability_timer - (self.crux_timer - self:GetAbility():GetCooldownTimeRemaining()), 1))
		else
			for item = 0, 5 do
				if keys.unit:GetItemInSlot(item):GetName() == keys.ability:GetName()
				then
					keys.unit:GetItemInSlot(item):EndCooldown()
					keys.unit:GetItemInSlot(item):StartCooldown(self.ability_timer - (self.crux_timer - self:GetAbility():GetCooldownTimeRemaining()))
					break
				end
			end
		end
		-- Reset variables
		self.ability_name = ""
		self.ability_timer = 0
		-- Break out of function early so it doesn't check Crux cooldown effect on same spell
		return
	end
	
	if self:GetAbility():IsCooldownReady() -- Check if Crux is ready
	and keys.unit == self:GetParent() -- Check if cast belongs to Crux owner
	and keys.ability -- Check if ability actually exists
	and keys.ability:GetCooldown(self:GetAbility():GetLevel()) > self:GetAbility():GetSpecialValueFor("min_cooldown") -- Check if ability's base cooldown is above some minimum
	and keys.ability:GetAbilityType() ~= 1 -- Check if ability is not an ultimate
	and keys.ability:GetName() ~= "item_imba_anomalous_crux" -- Do not allow this to refresh itself
	and keys.ability:GetName() ~= "item_refresher" -- Do not allow this to refresh Refresher Orb
	and keys.ability:GetName() ~= "item_refresher_shard" -- Do not allow this to refresh Refresher Shard
	and keys.ability:GetName() ~= "item_imba_cheese" -- Do not allow this to refresh Cheese
	and keys.ability:GetName() ~= "item_imba_octarine_core" -- Do not allow this to refresh Octarine Core
	then
		-- Crux will be activated; check for skill
		if keys.unit:FindAbilityByName(keys.ability:GetName()) ~= nil then
			self.ability_name = keys.ability:GetName()
			self.ability_timer = keys.unit:FindAbilityByName(keys.ability:GetName()):GetCooldownTime()
			keys.unit:FindAbilityByName(keys.ability:GetName()):EndCooldown()
		-- Crux will be activated; check for item if not a skill
		else
			if keys.unit:HasItemInInventory(keys.ability:GetName()) -- Check if ability was from an item
			then
				for item = 0, 5 do
					if keys.unit:GetItemInSlot(item):GetName() == keys.ability:GetName()
					then
						self.ability_name = keys.ability:GetName()
						self.ability_timer = keys.unit:GetItemInSlot(item):GetCooldownTime()
						keys.unit:GetItemInSlot(item):EndCooldown()
						break
					end
				end
			end
		end
		
		-- Play particle effect (Blue Refresher)
		local particle = ParticleManager:CreateParticle("particles/item/anomalous_crux/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		
		-- Put Crux on Cooldown
		self:GetAbility():UseResources(false, false, true)
		self.crux_timer = self:GetAbility():GetCooldownTime()
	end
end
