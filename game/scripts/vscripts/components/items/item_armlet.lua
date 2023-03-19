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

--	Author		 -	d2imba
--	DateCreated	 -	24.05.2015	<-- Shits' ancient yo
--	Date Updated -	05.03.2017
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_armlet == nil then item_imba_armlet = class({}) end
LinkLuaModifier("modifier_imba_armlet_basic", "components/items/item_armlet.lua", LUA_MODIFIER_MOTION_NONE)                   -- Item stat
LinkLuaModifier("modifier_imba_armlet_unholy_strength", "components/items/item_armlet.lua", LUA_MODIFIER_MOTION_NONE)         -- Unholy Strength
LinkLuaModifier("modifier_imba_armlet_toggle_prevention", "components/items/item_armlet.lua", LUA_MODIFIER_MOTION_NONE)       -- Toggle prevention

function item_imba_armlet:GetAbilityTextureName()
	return "imba_armlet"
end

function item_imba_armlet:GetIntrinsicModifierName()
	return "modifier_imba_armlet_basic"
end

function item_imba_armlet:OnSpellStart()
	if IsServer() then
		-- Grant or remove the appropriate modifiers
		local caster = self:GetCaster()

		-- If the caster has a toggle prevention, prevent toggling
		if caster:HasModifier("modifier_imba_armlet_toggle_prevention") then
			return nil
		end

		-- Prevent abusers from spamming Armlets.
		caster:AddNewModifier(caster, self, "modifier_imba_armlet_toggle_prevention", { duration = 0.05 })

		if caster:HasModifier("modifier_imba_armlet_unholy_strength") then
			caster:EmitSound("DOTA_Item.Armlet.Activate")
			caster:RemoveModifierByName("modifier_imba_armlet_unholy_strength")
		else
			caster:EmitSound("DOTA_Item.Armlet.DeActivate")
			caster:AddNewModifier(caster, self, "modifier_imba_armlet_unholy_strength", {})
		end
	end
end

function item_imba_armlet:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_armlet_unholy_strength") then
		return "imba_armlet_active"
	else
		return "imba_armlet"
	end
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_armlet_basic == nil then modifier_imba_armlet_basic = class({}) end

function modifier_imba_armlet_basic:IsHidden() return true end

function modifier_imba_armlet_basic:IsPurgable() return false end

function modifier_imba_armlet_basic:RemoveOnDeath() return false end

function modifier_imba_armlet_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_armlet_basic:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end

	-- Check for illusions to add Unoly Strength to if active (there's probably a less convoluted way to do this...)
	if self:GetParent():IsIllusion() and self:GetParent():GetPlayerOwner():GetAssignedHero():HasModifier("modifier_imba_armlet_unholy_strength") then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_armlet_unholy_strength", {})
	end
end

function modifier_imba_armlet_basic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_imba_armlet_basic:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_armlet_basic:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_imba_armlet_basic:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_imba_armlet_basic:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

-----------------------------------------------------------------------------------------------------------
--	Unholy Strength modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_armlet_unholy_strength == nil then modifier_imba_armlet_unholy_strength = class({}) end
function modifier_imba_armlet_unholy_strength:IsDebuff() return false end

function modifier_imba_armlet_unholy_strength:IsPurgable() return false end

function modifier_imba_armlet_unholy_strength:GetEffectName()
	return "particles/items_fx/armlet.vpcf"
end

function modifier_imba_armlet_unholy_strength:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.unholy_bonus_strength = self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
	self.unholy_health_drain   = self:GetAbility():GetSpecialValueFor("unholy_health_drain")
	self.health_per_stack      = self:GetAbility():GetSpecialValueFor("health_per_stack")

	if IsServer() then
		-- Adjust caster's health
		local caster = self:GetCaster()
		local bonus_health = self:GetAbility():GetSpecialValueFor("unholy_bonus_strength") * 20
		local health_before_activation = caster:GetHealth()

		if not self:GetParent():IsIllusion() then
			Timers:CreateTimer(0.01, function()
				caster:SetHealth(health_before_activation + bonus_health)
			end)
		end

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_armlet_unholy_strength:OnIntervalThink()
	-- If the parent no longer has the modifier (which means he no longer has an armlet), commit sudoku
	if not self:GetParent():HasModifier("modifier_imba_armlet_basic") then
		self:GetParent():RemoveModifierByName("modifier_imba_armlet_unholy_strength_visual_effect")
		self:Destroy()
		return
	end

	-- Remove health from the owner
	self:GetParent():SetHealth(math.max(self:GetParent():GetHealth() - self.unholy_health_drain * 0.1, 1))

	-- Calculate stacks to apply
	local unholy_stacks = math.floor((self:GetParent():GetMaxHealth() - self:GetParent():GetHealth()) / self.health_per_stack)

	-- Update stacks
	self:SetStackCount(unholy_stacks)
end

function modifier_imba_armlet_unholy_strength:OnDestroy()
	if IsServer() then
		if self:GetCaster():IsAlive() then
			-- Adjust caster's health
			local caster = self:GetCaster()
			local bonus_health = self.unholy_bonus_strength * 20
			local health_before_deactivation = caster:GetHealthPercent() * (caster:GetMaxHealth() + bonus_health) / 100
			caster:SetHealth(math.max(health_before_deactivation - bonus_health, 1))
		end
	end
end

function modifier_imba_armlet_unholy_strength:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_armlet_unholy_strength:GetModifierBonusStats_Strength() -- Static only
	return self:GetAbility():GetSpecialValueFor("unholy_bonus_strength")
end

function modifier_imba_armlet_unholy_strength:GetModifierPreAttack_BonusDamage() -- Static + stacks
	return self:GetAbility():GetSpecialValueFor("unholy_bonus_damage") + self:GetStackCount() * self:GetAbility():GetSpecialValueFor("stack_damage")
end

function modifier_imba_armlet_unholy_strength:GetModifierPhysicalArmorBonus() -- Static + stacks
	return self:GetAbility():GetSpecialValueFor("unholy_bonus_armor") + self:GetStackCount() * self:GetAbility():GetSpecialValueFor("stack_armor")
end

function modifier_imba_armlet_unholy_strength:GetModifierAttackSpeedBonus_Constant() -- Stacks only
	if IsClient() or not self:GetParent():IsIllusion() then
		return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("stack_as")
	end
end

function modifier_imba_armlet_unholy_strength:OnTooltip()
	return self.unholy_health_drain
end

-- Toggle prevention
modifier_imba_armlet_toggle_prevention = modifier_imba_armlet_toggle_prevention or class({})

function modifier_imba_armlet_toggle_prevention:IsHidden() return true end

function modifier_imba_armlet_toggle_prevention:IsDebuff() return false end

function modifier_imba_armlet_toggle_prevention:IsPurgable() return false end
