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
		Date: 25.05.2017
		Updated:  25.05.2017
	]]

-- Shared visible modifiers
LinkLuaModifier("modifier_imba_echo_rapier_haste", "components/items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_echo_rapier_debuff_slow", "components/items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
--				ECHO SABRE
-------------------------------------------
LinkLuaModifier("modifier_imba_echo_sabre", "components/items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_echo_sabre_passive", "components/items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_echo_sabre = item_imba_echo_sabre or class({})
-------------------------------------------
function item_imba_echo_sabre:GetIntrinsicModifierName()
	return "modifier_imba_echo_sabre_passive"
end

function item_imba_echo_sabre:GetAbilityTextureName()
	return "imba_echo_sabre"
end

modifier_imba_echo_sabre = modifier_imba_echo_sabre or class({})

function modifier_imba_echo_sabre:IsPurgable()		return false end
function modifier_imba_echo_sabre:RemoveOnDeath()	return false end
function modifier_imba_echo_sabre:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_echo_sabre:IsHidden() return true end

function modifier_imba_echo_sabre:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_intellect = item:GetSpecialValueFor("bonus_intellect")
		self.bonus_strength = item:GetSpecialValueFor("bonus_strength")
		self.bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.slow_duration = item:GetSpecialValueFor("slow_duration")
	end
end

function modifier_imba_echo_sabre:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_imba_echo_sabre:OnAttack(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	
	if keys.attacker == parent and item and not parent:IsIllusion() and self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and not self:GetParent():HasItemInInventory("item_imba_reverb_rapier") then
		if not parent:IsRangedAttacker() then 
			if item:IsCooldownReady() and not keys.no_attack_cooldown then
				item:UseResources(false, false, false, true)
				parent:AddNewModifier(parent, item, "modifier_imba_echo_rapier_haste", {})
				if not keys.target:IsBuilding() and not keys.target:IsOther() then
					keys.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_echo_rapier_debuff_slow", {duration = self.slow_duration})
				end
			end
		end
		
		if parent:HasModifier("modifier_imba_echo_rapier_haste") and (not parent:HasAbility("imba_slark_essence_shift") or parent:FindAbilityByName("imba_slark_essence_shift"):GetCooldownTime() < parent:FindAbilityByName("imba_slark_essence_shift"):GetEffectiveCooldown(parent:FindAbilityByName("imba_slark_essence_shift"):GetLevel())) then
			local mod = parent:FindModifierByName("modifier_imba_echo_rapier_haste")
			mod:DecrementStackCount()
			if mod:GetStackCount() < 1 then
				mod:Destroy()
			end
		end
	end
end

function modifier_imba_echo_sabre:OnRemoved()
	if not IsServer() then return end
	if (self:GetParent():FindModifierByName("modifier_imba_echo_rapier_haste")) then
		self:GetParent():FindModifierByName("modifier_imba_echo_rapier_haste"):Destroy()
	end
end

-------------------------------------------
modifier_imba_echo_sabre_passive = modifier_imba_echo_sabre_passive or class({})

function modifier_imba_echo_sabre_passive:IsHidden()		return true end
function modifier_imba_echo_sabre_passive:IsPurgable()		return false end
function modifier_imba_echo_sabre_passive:RemoveOnDeath()	return false end
function modifier_imba_echo_sabre_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_echo_sabre_passive:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() return end

		self.echo_modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_echo_sabre", {})
	end

	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_intellect = item:GetSpecialValueFor("bonus_intellect")
		self.bonus_strength = item:GetSpecialValueFor("bonus_strength")
		self.bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.slow_duration = item:GetSpecialValueFor("slow_duration")
	end
end

function modifier_imba_echo_sabre_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_imba_echo_sabre_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_echo_sabre_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_echo_sabre_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_echo_sabre_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_echo_sabre_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_echo_sabre_passive:OnRemoved()
	if not IsServer() then return end

	if self.echo_modifier then
		self.echo_modifier:Destroy()
	end
end

-------------------------------------------
--				REVERB RAPIER
-------------------------------------------
LinkLuaModifier("modifier_imba_reverb_rapier_passive", "components/items/item_echo_sabre.lua", LUA_MODIFIER_MOTION_NONE)
-------------------------------------------
item_imba_reverb_rapier = item_imba_reverb_rapier or class({})
-------------------------------------------
function item_imba_reverb_rapier:GetIntrinsicModifierName()
	return "modifier_imba_reverb_rapier_passive"
end

function item_imba_reverb_rapier:GetAbilityTextureName()
	return "imba_reverb_rapier"
end

-------------------------------------------
modifier_imba_reverb_rapier_passive = modifier_imba_reverb_rapier_passive or class({})

function modifier_imba_reverb_rapier_passive:IsHidden()		return true end
function modifier_imba_reverb_rapier_passive:IsPurgable()		return false end
function modifier_imba_reverb_rapier_passive:RemoveOnDeath()	return false end
function modifier_imba_reverb_rapier_passive:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_reverb_rapier_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_imba_reverb_rapier_passive:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	local item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and item then
		self.bonus_intellect = item:GetSpecialValueFor("bonus_intellect")
		self.bonus_strength = item:GetSpecialValueFor("bonus_strength")
		self.bonus_attack_speed = item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = item:GetSpecialValueFor("bonus_mana_regen")
		self.slow_duration = item:GetSpecialValueFor("slow_duration")
	end
end

function modifier_imba_reverb_rapier_passive:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_imba_reverb_rapier_passive:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_reverb_rapier_passive:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_reverb_rapier_passive:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_reverb_rapier_passive:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_reverb_rapier_passive:OnAttack(keys)
	local item = self:GetAbility()
	local parent = self:GetParent()
	
	if keys.attacker == parent and item and not parent:IsIllusion() and self:GetParent():FindAllModifiersByName(self:GetName())[1] == self then
		if not parent:IsRangedAttacker() then 
			if item:IsCooldownReady() and not keys.no_attack_cooldown then
				item:UseResources(false, false, false, true)
				parent:AddNewModifier(parent, item, "modifier_imba_echo_rapier_haste", {})
				if not keys.target:IsBuilding() and not keys.target:IsOther() then
					keys.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_echo_rapier_debuff_slow", {duration = self.slow_duration})
				end
			end
		end
			
		if parent:HasModifier("modifier_imba_echo_rapier_haste") and (not parent:HasAbility("imba_slark_essence_shift") or parent:FindAbilityByName("imba_slark_essence_shift"):GetCooldownTime() < parent:FindAbilityByName("imba_slark_essence_shift"):GetEffectiveCooldown(parent:FindAbilityByName("imba_slark_essence_shift"):GetLevel())) then
			local mod = parent:FindModifierByName("modifier_imba_echo_rapier_haste")
			mod:DecrementStackCount()
			if mod:GetStackCount() < 1 then
				mod:Destroy()
			end
		end
	end
end

function modifier_imba_reverb_rapier_passive:OnRemoved()
	if not IsServer() then return end
	if (self:GetParent():FindModifierByName("modifier_imba_echo_rapier_haste")) then
		self:GetParent():FindModifierByName("modifier_imba_echo_rapier_haste"):Destroy()
	end
end

-------------------------------------------
modifier_imba_echo_rapier_haste = modifier_imba_echo_rapier_haste or class({})
function modifier_imba_echo_rapier_haste:IsDebuff() return false end
function modifier_imba_echo_rapier_haste:IsHidden() return true end
function modifier_imba_echo_rapier_haste:IsPurgable() return false end
function modifier_imba_echo_rapier_haste:IsPurgeException() return false end
function modifier_imba_echo_rapier_haste:IsStunDebuff() return false end
function modifier_imba_echo_rapier_haste:RemoveOnDeath() return true end
-------------------------------------------
function modifier_imba_echo_rapier_haste:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	local item = self:GetAbility()
	self.parent = self:GetParent()
	if item then
		self.slow_duration = item:GetSpecialValueFor("slow_duration")
		local current_speed = self.parent:GetIncreasedAttackSpeed()
		if item:GetName() == "item_imba_reverb_rapier" then
			current_speed = current_speed * 3
		else
			current_speed = current_speed * 2
		end
		local max_hits = item:GetSpecialValueFor("max_hits")
		self:SetStackCount(max_hits)
		self.attack_speed_buff = math.max(item:GetSpecialValueFor("attack_speed_buff"), current_speed)
	end
end

function modifier_imba_echo_rapier_haste:OnRefresh()
	self:OnCreated()
end

function modifier_imba_echo_rapier_haste:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_imba_echo_rapier_haste:OnAttack(keys)
	if self.parent == keys.attacker and not keys.target:IsBuilding() and not keys.target:IsOther() then
		keys.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_echo_rapier_debuff_slow", {duration = self.slow_duration * (1 - keys.target:GetStatusResistance())})
	end
end

function modifier_imba_echo_rapier_haste:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_buff
end
-------------------------------------------
modifier_imba_echo_rapier_debuff_slow = modifier_imba_echo_rapier_debuff_slow or class({})
function modifier_imba_echo_rapier_debuff_slow:IsDebuff() return true end
function modifier_imba_echo_rapier_debuff_slow:IsHidden() return false end
function modifier_imba_echo_rapier_debuff_slow:IsPurgable() return true end
function modifier_imba_echo_rapier_debuff_slow:IsStunDebuff() return false end
function modifier_imba_echo_rapier_debuff_slow:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_echo_rapier_debuff_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_echo_rapier_debuff_slow:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end
	
	local item = self:GetAbility()
	if item then
		self.movement_slow = item:GetSpecialValueFor("movement_slow") * (-1)
		self.attack_speed_slow = item:GetSpecialValueFor("attack_speed_slow") * (-1)
	end
end

function modifier_imba_echo_rapier_debuff_slow:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_slow
end

function modifier_imba_echo_rapier_debuff_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_echo_rapier_debuff_slow:GetTexture()
	if self:GetAbility():GetName() == "item_imba_reverb_rapier" then
		return "imba_reverb_rapier"
	else
		return "imba_echo_sabre"
	end
end
