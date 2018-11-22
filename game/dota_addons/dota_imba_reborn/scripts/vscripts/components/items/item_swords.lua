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

--	Author: Firetoad
--	Date: 			24.06.2015
--	Last Update:	23.03.2017
--	Definitions for the three swords and their combinations

-----------------------------------------------------------------------------------------------------------
--	Sange definition
-----------------------------------------------------------------------------------------------------------

local active_sword_sound = "DOTA_Item.IronTalon.Activate"

if item_imba_sange == nil then item_imba_sange = class({}) end
LinkLuaModifier( "modifier_item_imba_sange", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sange_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Maim debuff

function item_imba_sange:GetIntrinsicModifierName()
	return "modifier_item_imba_sange"
end

function item_imba_sange:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_sange_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound(active_sword_sound)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange == nil then modifier_item_imba_sange = class({}) end
function modifier_item_imba_sange:IsHidden() return true end
function modifier_item_imba_sange:IsDebuff() return false end
function modifier_item_imba_sange:IsPurgable() return false end
function modifier_item_imba_sange:IsPermanent() return true end
function modifier_item_imba_sange:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_sange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_item_imba_sange:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_sange:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_sange:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance")
end

-----------------------------------------------------------------------------------------------------------
--	Sange maim debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_active == nil then modifier_item_imba_sange_active = class({}) end
function modifier_item_imba_sange_active:IsHidden() return false end
function modifier_item_imba_sange_active:IsDebuff() return false end
function modifier_item_imba_sange_active:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_active:GetEffectName()
	return "particles/items2_fx/sange_active.vpcf"
end

function modifier_item_imba_sange_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier events/properties
function modifier_item_imba_sange_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_item_imba_sange_active:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance_active")
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd definition
-----------------------------------------------------------------------------------------------------------

if item_imba_heavens_halberd == nil then item_imba_heavens_halberd = class({}) end
LinkLuaModifier("modifier_item_imba_heavens_halberd", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE)					-- Owner's bonus attributes, stackable
LinkLuaModifier("modifier_item_imba_heavens_halberd_ally_buff", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE)	-- Passive disarm cooldown counter
LinkLuaModifier("modifier_item_imba_heavens_halberd_active_disarm", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE)	-- Active disarm debuff

function item_imba_heavens_halberd:GetIntrinsicModifierName()
	return "modifier_item_imba_heavens_halberd"
end

function item_imba_heavens_halberd:OnSpellStart(keys)
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Define disarm duration
		local duration = self:GetSpecialValueFor("disarm_melee_duration")
		if target:IsRangedAttacker() then
			duration = self:GetSpecialValueFor("disarm_range_duration")
		end

		-- Disarm the target
		if target:GetTeamNumber() == caster:GetTeamNumber() then
			target:AddNewModifier(caster, self, "modifier_item_imba_heavens_halberd_ally_buff", {duration = self:GetSpecialValueFor("buff_duration")})
			self:GetCaster():EmitSound(active_sword_sound)
		else
			target:AddNewModifier(caster, self, "modifier_item_imba_heavens_halberd_active_disarm", {duration = duration})
			target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_heavens_halberd == nil then modifier_item_imba_heavens_halberd = class({}) end
function modifier_item_imba_heavens_halberd:IsHidden() return true end
function modifier_item_imba_heavens_halberd:IsDebuff() return false end
function modifier_item_imba_heavens_halberd:IsPurgable() return false end
function modifier_item_imba_heavens_halberd:IsPermanent() return true end
function modifier_item_imba_heavens_halberd:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_heavens_halberd:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_item_imba_heavens_halberd:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_heavens_halberd:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_heavens_halberd:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

function modifier_item_imba_heavens_halberd:GetModifierStatusResistanceStacking()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance")
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd disarm cooldown (enemy-based)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_heavens_halberd_ally_buff == nil then modifier_item_imba_heavens_halberd_ally_buff = class({}) end
function modifier_item_imba_heavens_halberd_ally_buff:IsHidden() return false end
function modifier_item_imba_heavens_halberd_ally_buff:IsDebuff() return false end
function modifier_item_imba_heavens_halberd_ally_buff:IsPurgable() return true end

function modifier_item_imba_heavens_halberd_ally_buff:GetEffectName()
	return "particles/items2_fx/sange_active.vpcf"
end

function modifier_item_imba_heavens_halberd_ally_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_heavens_halberd_ally_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_item_imba_heavens_halberd_ally_buff:GetModifierStatusResistanceStacking()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance_active")
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd active disarm
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_heavens_halberd_active_disarm == nil then modifier_item_imba_heavens_halberd_active_disarm = class({}) end
function modifier_item_imba_heavens_halberd_active_disarm:IsHidden() return false end
function modifier_item_imba_heavens_halberd_active_disarm:IsDebuff() return true end
function modifier_item_imba_heavens_halberd_active_disarm:IsPurgable() return false end

-- Modifier particle
function modifier_item_imba_heavens_halberd_active_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_item_imba_heavens_halberd_active_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_heavens_halberd_active_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	Yasha definition
-----------------------------------------------------------------------------------------------------------

if item_imba_yasha == nil then item_imba_yasha = class({}) end
LinkLuaModifier( "modifier_item_imba_yasha", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_yasha_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed

function item_imba_yasha:GetIntrinsicModifierName()
	return "modifier_item_imba_yasha"
end

function item_imba_yasha:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_yasha_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound(active_sword_sound)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Yasha passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha == nil then modifier_item_imba_yasha = class({}) end
function modifier_item_imba_yasha:IsHidden() return true end
function modifier_item_imba_yasha:IsDebuff() return false end
function modifier_item_imba_yasha:IsPurgable() return false end
function modifier_item_imba_yasha:IsPermanent() return true end
function modifier_item_imba_yasha:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_yasha:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_yasha:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_imba_yasha:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_item_imba_yasha:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_imba_yasha:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

-----------------------------------------------------------------------------------------------------------
--	Yasha attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha_active == nil then modifier_item_imba_yasha_active = class({}) end
function modifier_item_imba_yasha_active:IsHidden() return false end
function modifier_item_imba_yasha_active:IsDebuff() return false end
function modifier_item_imba_yasha_active:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_yasha_active:GetEffectName()
	return "particles/items2_fx/yasha_active.vpcf"
end

function modifier_item_imba_yasha_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_yasha_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_item_imba_yasha_active:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_evasion_active")
end

-----------------------------------------------------------------------------------------------------------
--	kaya definition
-----------------------------------------------------------------------------------------------------------

if item_imba_kaya == nil then item_imba_kaya = class({}) end
LinkLuaModifier( "modifier_item_imba_kaya", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_kaya_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_kaya:GetIntrinsicModifierName()
	return "modifier_item_imba_kaya"
end

function item_imba_kaya:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_kaya_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	end
end

-----------------------------------------------------------------------------------------------------------
--	kaya passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya == nil then modifier_item_imba_kaya = class({}) end
function modifier_item_imba_kaya:IsHidden() return true end
function modifier_item_imba_kaya:IsDebuff() return false end
function modifier_item_imba_kaya:IsPurgable() return false end
function modifier_item_imba_kaya:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_imba_kaya:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
	return funcs
end

function modifier_item_imba_kaya:GetModifierSpellAmplify_Percentage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_imba_kaya:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_kaya:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_imba_kaya:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

modifier_item_imba_kaya_active = modifier_item_imba_kaya_active or class({})

function modifier_item_imba_kaya_active:IsDebuff() return false end
function modifier_item_imba_kaya_active:IsHidden() return false end
function modifier_item_imba_kaya_active:IsPurgable() return false end
function modifier_item_imba_kaya_active:IsPurgeException() return false end

function modifier_item_imba_kaya_active:GetEffectName()
	return "particles/items2_fx/kaya_active_b0.vpcf"
end

function modifier_item_imba_kaya_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_kaya_active:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_item_imba_kaya_active:GetModifierPercentageCooldown()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_kaya_active:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_kaya_active:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsItem() and not keys.ability:IsToggle() then
		self:GetParent():RemoveModifierByName("modifier_item_imba_kaya_active")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha definition
-----------------------------------------------------------------------------------------------------------

if item_imba_sange_yasha == nil then item_imba_sange_yasha = class({}) end
LinkLuaModifier("modifier_item_imba_sange_yasha", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE)				-- Owner's bonus attributes, stackable
LinkLuaModifier("modifier_item_imba_sange_yasha_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE)			-- Maim debuff

function item_imba_sange_yasha:GetIntrinsicModifierName()
	return "modifier_item_imba_sange_yasha"
end

function item_imba_sange_yasha:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_sange_yasha_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound(active_sword_sound)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha == nil then modifier_item_imba_sange_yasha = class({}) end
function modifier_item_imba_sange_yasha:IsHidden() return true end
function modifier_item_imba_sange_yasha:IsDebuff() return false end
function modifier_item_imba_sange_yasha:IsPurgable() return false end
function modifier_item_imba_sange_yasha:IsPermanent() return true end
function modifier_item_imba_sange_yasha:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_sange_yasha:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_item_imba_sange_yasha:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_sange_yasha:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_imba_sange_yasha:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_item_imba_sange_yasha:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_imba_sange_yasha:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_sange_yasha:GetModifierStatusResistanceStacking()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance")
end

function modifier_item_imba_sange_yasha:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha maim debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha_active == nil then modifier_item_imba_sange_yasha_active = class({}) end
function modifier_item_imba_sange_yasha_active:IsHidden() return false end
function modifier_item_imba_sange_yasha_active:IsDebuff() return false end
function modifier_item_imba_sange_yasha_active:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_yasha_active:GetEffectName()
	return "particles/items2_fx/sange_yasha_active.vpcf"
end

function modifier_item_imba_sange_yasha_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier events/properties
function modifier_item_imba_sange_yasha_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_item_imba_sange_yasha_active:GetModifierStatusResistanceStacking()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance_active")
end

function modifier_item_imba_sange_yasha_active:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion_active")
end

-----------------------------------------------------------------------------------------------------------
--	Kaya and Sange definition
-----------------------------------------------------------------------------------------------------------

if item_imba_kaya_and_sange == nil then item_imba_kaya_and_sange = class({}) end
LinkLuaModifier( "modifier_item_imba_kaya_and_sange", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_kaya_and_sange_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Maim/amp debuff

function item_imba_kaya_and_sange:GetIntrinsicModifierName()
	return "modifier_item_imba_kaya_and_sange"
end

function item_imba_kaya_and_sange:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_kaya_and_sange_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound(active_sword_sound)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_and_sange == nil then modifier_item_imba_kaya_and_sange = class({}) end
function modifier_item_imba_kaya_and_sange:IsHidden() return true end
function modifier_item_imba_kaya_and_sange:IsDebuff() return false end
function modifier_item_imba_kaya_and_sange:IsPurgable() return false end
function modifier_item_imba_kaya_and_sange:IsPermanent() return true end
function modifier_item_imba_kaya_and_sange:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_kaya_and_sange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_item_imba_kaya_and_sange:GetModifierSpellAmplify_Percentage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_imba_kaya_and_sange:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_imba_kaya_and_sange:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_kaya_and_sange:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_kaya_and_sange:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance")
end

function modifier_item_imba_kaya_and_sange:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_kaya_and_sange:GetModifierPercentageCooldown()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya maim/amp debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_and_sange_active == nil then modifier_item_imba_kaya_and_sange_active = class({}) end
function modifier_item_imba_kaya_and_sange_active:IsHidden() return false end
function modifier_item_imba_kaya_and_sange_active:IsDebuff() return false end
function modifier_item_imba_kaya_and_sange_active:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_kaya_and_sange_active:GetEffectName()
	return "particles/items2_fx/kaya_sange_active.vpcf"
end

function modifier_item_imba_kaya_and_sange_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier events/properties
function modifier_item_imba_kaya_and_sange_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}

	return funcs
end

function modifier_item_imba_kaya_and_sange_active:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance_active")
end

function modifier_item_imba_kaya_and_sange_active:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_kaya_and_sange_active:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha definition
-----------------------------------------------------------------------------------------------------------

if item_imba_yasha_and_kaya == nil then item_imba_yasha_and_kaya = class({}) end
LinkLuaModifier( "modifier_item_imba_yasha_and_kaya", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_yasha_and_kaya_active", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Amp debuff

function item_imba_yasha_and_kaya:GetIntrinsicModifierName()
	return "modifier_item_imba_yasha_and_kaya"
end

function item_imba_yasha_and_kaya:OnSpellStart()
	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_yasha_and_kaya_active", {duration=self:GetSpecialValueFor("active_duration")})
		self:GetCaster():EmitSound(active_sword_sound)
	end
end

-----------------------------------------------------------------------------------------------------------
-- Yasha passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha_and_kaya == nil then modifier_item_imba_yasha_and_kaya = class({}) end
function modifier_item_imba_yasha_and_kaya:IsHidden() return true end
function modifier_item_imba_yasha_and_kaya:IsDebuff() return false end
function modifier_item_imba_yasha_and_kaya:IsPurgable() return false end
function modifier_item_imba_yasha_and_kaya:IsPermanent() return true end
function modifier_item_imba_yasha_and_kaya:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_yasha_and_kaya:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}

	return funcs
end

function modifier_item_imba_yasha_and_kaya:GetModifierSpellAmplify_Percentage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_imba_yasha_and_kaya:GetModifierPercentageCooldown()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_yasha_and_kaya:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_yasha_and_kaya:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_imba_yasha_and_kaya:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_item_imba_yasha_and_kaya:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_imba_yasha_and_kaya:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_imba_yasha_and_kaya:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion")
end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha magic amp debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha_and_kaya_active == nil then modifier_item_imba_yasha_and_kaya_active = class({}) end
function modifier_item_imba_yasha_and_kaya_active:IsHidden() return false end
function modifier_item_imba_yasha_and_kaya_active:IsDebuff() return false end
function modifier_item_imba_yasha_and_kaya_active:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_yasha_and_kaya_active:GetEffectName()
	return "particles/items2_fx/yasha_kaya_active.vpcf"
end

function modifier_item_imba_yasha_and_kaya_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier events/properties
function modifier_item_imba_yasha_and_kaya_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_item_imba_yasha_and_kaya_active:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_yasha_and_kaya_active:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr_active")
end

function modifier_item_imba_yasha_and_kaya_active:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion_active")
end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate definition
-----------------------------------------------------------------------------------------------------------

if item_imba_triumvirate == nil then item_imba_triumvirate = class({}) end
LinkLuaModifier( "modifier_item_imba_triumvirate", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_triumvirate_stacks_debuff", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )	-- Maim/amp debuff
LinkLuaModifier( "modifier_item_imba_triumvirate_proc_debuff", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Disarm/silence debuff
LinkLuaModifier( "modifier_item_imba_triumvirate_stacks_buff", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_item_imba_triumvirate_proc_buff", "components/items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Move speed proc

function item_imba_triumvirate:GetAbilityTextureName()
	return "custom/imba_sange_and_kaya_and_yasha"
end

function item_imba_triumvirate:GetIntrinsicModifierName()
	return "modifier_item_imba_triumvirate" end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_triumvirate == nil then modifier_item_imba_triumvirate = class({}) end
function modifier_item_imba_triumvirate:IsHidden() return true end
function modifier_item_imba_triumvirate:IsDebuff() return false end
function modifier_item_imba_triumvirate:IsPurgable() return false end
function modifier_item_imba_triumvirate:IsPermanent() return true end
function modifier_item_imba_triumvirate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_triumvirate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_triumvirate:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_triumvirate:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_triumvirate:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_imba_triumvirate:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_imba_triumvirate:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_str") end

function modifier_item_imba_triumvirate:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agi") end

function modifier_item_imba_triumvirate:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_int") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_triumvirate:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- All conditions met, perform a Triumvirate attack
		TriumAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_triumvirate_stacks_debuff", "modifier_item_imba_triumvirate_stacks_buff", "modifier_item_imba_triumvirate_proc_debuff", "modifier_item_imba_triumvirate_proc_buff")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate maim/amp debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_triumvirate_stacks_debuff == nil then modifier_item_imba_triumvirate_stacks_debuff = class({}) end
function modifier_item_imba_triumvirate_stacks_debuff:IsHidden() return false end
function modifier_item_imba_triumvirate_stacks_debuff:IsDebuff() return true end
function modifier_item_imba_triumvirate_stacks_debuff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_triumvirate_stacks_debuff:GetEffectName()
	return "particles/item/swords/sange_kaya_debuff.vpcf"
end

function modifier_item_imba_triumvirate_stacks_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_triumvirate_stacks_debuff:OnCreated()
	self.ability = self:GetAbility()

	if not self.ability then
		self:Destroy()
		return nil
	end

	self.maim_stack = self.ability:GetSpecialValueFor("maim_stack")
	self.amp_stack = self.ability:GetSpecialValueFor("amp_stack")

	-- Inherit stacks from lower-tier modifiers
	if IsServer() then
		local owner = self:GetParent()
		local lower_tier_modifiers = {
			"modifier_item_imba_sange_active",
			"modifier_item_imba_sange_yasha_active",
			"modifier_item_imba_yasha_and_kaya_active",
			"modifier_item_imba_sange_kaya_active"
		}
		local stack_count = self:GetStackCount()
		for _, modifier in pairs(lower_tier_modifiers) do
			local modifier_to_remove = owner:FindModifierByName(modifier)
			if modifier_to_remove then
				stack_count = math.max(stack_count, modifier_to_remove:GetStackCount())
				modifier_to_remove:Destroy()
			end
		end
		self:SetStackCount(stack_count)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_triumvirate_stacks_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_imba_triumvirate_stacks_debuff:GetModifierMagicalResistanceBonus()
	if not self.amp_stack then return nil end
	return self.amp_stack * self:GetStackCount() end

function modifier_item_imba_triumvirate_stacks_debuff:GetModifierAttackSpeedBonus_Constant()
	if not self.maim_stack then return nil end
	return self.maim_stack * self:GetStackCount() end

function modifier_item_imba_triumvirate_stacks_debuff:GetModifierMoveSpeedBonus_Percentage()
	if not self.maim_stack then return nil end
	return self.maim_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate silence/disarm debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_triumvirate_proc_debuff == nil then modifier_item_imba_triumvirate_proc_debuff = class({}) end
function modifier_item_imba_triumvirate_proc_debuff:IsHidden() return true end
function modifier_item_imba_triumvirate_proc_debuff:IsDebuff() return true end
function modifier_item_imba_triumvirate_proc_debuff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_triumvirate_proc_debuff:GetEffectName()
	return "particles/item/swords/sange_kaya_proc.vpcf"
end

function modifier_item_imba_triumvirate_proc_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_triumvirate_proc_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_triumvirate_stacks_buff == nil then modifier_item_imba_triumvirate_stacks_buff = class({}) end
function modifier_item_imba_triumvirate_stacks_buff:IsHidden() return false end
function modifier_item_imba_triumvirate_stacks_buff:IsDebuff() return false end
function modifier_item_imba_triumvirate_stacks_buff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_triumvirate_stacks_buff:GetEffectName()
	return "particles/item/swords/yasha_buff.vpcf"
end

function modifier_item_imba_triumvirate_stacks_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_triumvirate_stacks_buff:OnCreated()
	self.as_stack = self:GetAbility():GetSpecialValueFor("as_stack")

	-- Inherit stacks from lower-tier modifiers
	if IsServer() then
		local owner = self:GetParent()
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_active",
			"modifier_item_imba_kaya_yasha_stacks",
			"modifier_item_imba_sange_yasha_stacks"
		}
		local stack_count = self:GetStackCount()
		for _, modifier in pairs(lower_tier_modifiers) do
			local modifier_to_remove = owner:FindModifierByName(modifier)
			if modifier_to_remove then
				stack_count = math.max(stack_count, modifier_to_remove:GetStackCount())
				modifier_to_remove:Destroy()
			end
		end
		self:SetStackCount(stack_count)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_triumvirate_stacks_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_triumvirate_stacks_buff:GetModifierAttackSpeedBonus_Constant()
	return self.as_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate move speed proc
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_triumvirate_proc_buff == nil then modifier_item_imba_triumvirate_proc_buff = class({}) end
function modifier_item_imba_triumvirate_proc_buff:IsHidden() return true end
function modifier_item_imba_triumvirate_proc_buff:IsDebuff() return false end
function modifier_item_imba_triumvirate_proc_buff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_triumvirate_proc_buff:GetEffectName()
	return "particles/item/swords/yasha_proc.vpcf"
end

function modifier_item_imba_triumvirate_proc_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_triumvirate_proc_buff:OnCreated()
	self.proc_ms = self:GetAbility():GetSpecialValueFor("proc_ms")

	-- Remove lower-tier modifiers
	if IsServer() then
		local owner = self:GetParent()
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_proc",
			"modifier_item_imba_sange_yasha_proc",
			"modifier_item_imba_kaya_yasha_proc"
		}
		for _, modifier in pairs(lower_tier_modifiers) do
			owner:RemoveModifierByName(modifier)
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_triumvirate_proc_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_triumvirate_proc_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.proc_ms end


-----------------------------------------------------------------------------------------------------------
--	Auxiliary attack functions
-----------------------------------------------------------------------------------------------------------

function SangeAttack(attacker, target, ability, modifier_stacks, modifier_proc)

	-- If this is an illusion, do nothing
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing either
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- Stack the maim up
	local modifier_maim = target:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_maim and modifier_maim:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_maim:SetStackCount(modifier_maim:GetStackCount() + 1)
		target:EmitSound("Imba.SangeStack")
	end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the disarm modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.SangeProc")
		ability:UseResources(false, false, true)
	end
end

function YashaAttack(attacker, ability, modifier_stacks, modifier_proc)

	-- Stack the attack speed buff up
	local modifier_as = attacker:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_as and modifier_as:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_as:SetStackCount(modifier_as:GetStackCount() + 1)
		attacker:EmitSound("Imba.YashaStack")
	end

	-- If this is an illusion, do nothing else
	if attacker:IsIllusion() then
		return end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the move speed modifier and put the ability on cooldown
		attacker:AddNewModifier(attacker, ability, modifier_proc, {duration = ability:GetSpecialValueFor("proc_duration_self")})
		attacker:EmitSound("Imba.YashaProc")
		ability:UseResources(false, false, true)
	end
end

function kayaAttack(attacker, target, ability, modifier_stacks, modifier_proc)

	-- If this is an illusion, do nothing
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing either
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- Stack the magic amp up
	local modifier_amp = target:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_amp and modifier_amp:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_amp:SetStackCount(modifier_amp:GetStackCount() + 1)
		target:EmitSound("Imba.kayaStack")
	end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the silence modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.kayaProc")
		ability:UseResources(false, false, true)
	end
end

function SangeYashaAttack(attacker, target, ability, modifier_enemy_stacks, modifier_self_stacks, modifier_enemy_proc, modifier_self_proc)

	-- Stack the attack speed buff up
	local modifier_as = attacker:AddNewModifier(attacker, ability, modifier_self_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_as and modifier_as:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_as:SetStackCount(modifier_as:GetStackCount() + 1)
		attacker:EmitSound("Imba.YashaStack")
	end

	-- If this is an illusion, do nothing else
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing else
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the move speed modifier
		attacker:AddNewModifier(attacker, ability, modifier_self_proc, {duration = ability:GetSpecialValueFor("proc_duration_self")})
		attacker:EmitSound("Imba.YashaProc")

		-- Apply the disarm modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_enemy_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.SangeProc")
		ability:UseResources(false, false, true)
	end

	-- Stack the maim up
	local modifier_maim = target:AddNewModifier(attacker, ability, modifier_enemy_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_maim and modifier_maim:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_maim:SetStackCount(modifier_maim:GetStackCount() + 1)
		target:EmitSound("Imba.SangeStack")
	end
end

function SangekayaAttack(attacker, target, ability, modifier_stacks, modifier_proc)

	-- If this is an illusion, do nothing
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing either
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- Stack the maim/amp up
	local modifier_debuff = target:AddNewModifier(attacker, ability, modifier_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_debuff and modifier_debuff:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_debuff:SetStackCount(modifier_debuff:GetStackCount() + 1)
		target:EmitSound("Imba.SangeStack")
		target:EmitSound("Imba.kayaStack")
	end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the disarm/silence modifier
		target:AddNewModifier(attacker, ability, modifier_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.SangeProc")
		target:EmitSound("Imba.kayaProc")
		ability:UseResources(false, false, true)
	end
end

function kayaYashaAttack(attacker, target, ability, modifier_enemy_stacks, modifier_self_stacks, modifier_enemy_proc, modifier_self_proc)

	-- Stack the attack speed buff up
	local modifier_as = attacker:AddNewModifier(attacker, ability, modifier_self_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_as and modifier_as:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_as:SetStackCount(modifier_as:GetStackCount() + 1)
		attacker:EmitSound("Imba.YashaStack")
	end

	-- If this is an illusion, do nothing else
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing else
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the move speed modifier
		attacker:AddNewModifier(attacker, ability, modifier_self_proc, {duration = ability:GetSpecialValueFor("proc_duration_self")})
		attacker:EmitSound("Imba.YashaProc")

		-- Apply the silence modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_enemy_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.kayaProc")
		ability:UseResources(false, false, true)
	end

	-- Stack the magic amp up
	local modifier_amp = target:AddNewModifier(attacker, ability, modifier_enemy_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_amp and modifier_amp:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_amp:SetStackCount(modifier_amp:GetStackCount() + 1)
		target:EmitSound("Imba.kayaStack")
	end
end

function TriumAttack(attacker, target, ability, modifier_enemy_stacks, modifier_self_stacks, modifier_enemy_proc, modifier_self_proc)

	-- Stack the attack speed buff up
	local modifier_as = attacker:AddNewModifier(attacker, ability, modifier_self_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_as and modifier_as:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_as:SetStackCount(modifier_as:GetStackCount() + 1)
		attacker:EmitSound("Imba.YashaStack")
	end

	-- If this is an illusion, do nothing
	if attacker:IsIllusion() then
		return end

	-- If the target is not valid, do nothing else
	if target:IsMagicImmune() or (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
		return end

	-- If the ability is not on cooldown, roll for a proc
	if ability:IsCooldownReady() and RollPercentage(ability:GetSpecialValueFor("proc_chance")) then

		-- Proc! Apply the move speed modifier
		attacker:AddNewModifier(attacker, ability, modifier_self_proc, {duration = ability:GetSpecialValueFor("proc_duration_self")})
		attacker:EmitSound("Imba.YashaProc")

		-- Apply the silence/disarm modifier and put the ability on cooldown
		target:AddNewModifier(attacker, ability, modifier_enemy_proc, {duration = ability:GetSpecialValueFor("proc_duration_enemy")})
		target:EmitSound("Imba.SangeProc")
		target:EmitSound("Imba.kayaProc")
		ability:UseResources(false, false, true)
	end

	-- Stack the maim/amp up
	local modifier_maim = target:AddNewModifier(attacker, ability, modifier_enemy_stacks, {duration = ability:GetSpecialValueFor("stack_duration")})
	if modifier_maim and modifier_maim:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
		modifier_maim:SetStackCount(modifier_maim:GetStackCount() + 1)
		target:EmitSound("Imba.SangeStack")
		target:EmitSound("Imba.kayaStack")
	end
end
