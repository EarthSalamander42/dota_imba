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

if item_imba_sange == nil then item_imba_sange = class({}) end
LinkLuaModifier( "modifier_item_imba_sange", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sange_maim", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Maim debuff
LinkLuaModifier( "modifier_item_imba_sange_disarm", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Disarm debuff

function item_imba_sange:GetAbilityTextureName()
	return "custom/imba_sange"
end

function item_imba_sange:GetIntrinsicModifierName()
	return "modifier_item_imba_sange" end

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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_sange:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_sange:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_sange:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return
		end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_heavens_halberd",
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_sange_kaya",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Sange attack
		SangeAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_sange_maim", "modifier_item_imba_sange_disarm")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange maim debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_maim == nil then modifier_item_imba_sange_maim = class({}) end
function modifier_item_imba_sange_maim:IsHidden() return false end
function modifier_item_imba_sange_maim:IsDebuff() return true end
function modifier_item_imba_sange_maim:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_maim:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_item_imba_sange_maim:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_maim:OnCreated()
	self.maim_stack = self:GetAbility():GetSpecialValueFor("maim_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_maim",
			"modifier_item_imba_sange_kaya_stacks",
			"modifier_item_imba_triumvirate_stacks_debuff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_sange_maim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_sange_maim:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

function modifier_item_imba_sange_maim:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Sange disarm debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_disarm == nil then modifier_item_imba_sange_disarm = class({}) end
function modifier_item_imba_sange_disarm:IsHidden() return true end
function modifier_item_imba_sange_disarm:IsDebuff() return true end
function modifier_item_imba_sange_disarm:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_item_imba_sange_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_sange_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd definition
-----------------------------------------------------------------------------------------------------------

if item_imba_heavens_halberd == nil then item_imba_heavens_halberd = class({}) end
LinkLuaModifier( "modifier_item_imba_heavens_halberd", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_heavens_halberd_disarm_cooldown", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )	-- Passive disarm cooldown counter
LinkLuaModifier( "modifier_item_imba_heavens_halberd_active_disarm", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )	-- Active disarm debuff

function item_imba_heavens_halberd:GetAbilityTextureName()
	return "custom/imba_heavens_halberd"
end

function item_imba_heavens_halberd:GetIntrinsicModifierName()
	return "modifier_item_imba_heavens_halberd" end

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
		target:AddNewModifier(caster, self, "modifier_item_imba_heavens_halberd_active_disarm", {duration = duration})
		target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_heavens_halberd:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_heavens_halberd:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

function modifier_item_imba_heavens_halberd:GetModifierEvasion_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_evasion") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_heavens_halberd:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_sange_kaya",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- If this is an illusion, do nothing
		if owner:IsIllusion() then
			return end

		-- If the target is not valid, do nothing either
		local target = keys.target
		if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or owner:GetTeam() == target:GetTeam() then
			return end

		-- Stack the maim up
		local ability = self:GetAbility()
		local modifier_maim = target:AddNewModifier(owner, ability, "modifier_item_imba_sange_maim", {duration = ability:GetSpecialValueFor("maim_duration")})
		if modifier_maim:GetStackCount() < ability:GetSpecialValueFor("max_stacks") then
			modifier_maim:SetStackCount(modifier_maim:GetStackCount() + 1)
			target:EmitSound("Imba.SangeStack")
		end

		-- If the target does not have the disarm cooldown modifier, roll for a proc
		if (not target:HasModifier("modifier_item_imba_heavens_halberd_disarm_cooldown")) and RollPercentage(ability:GetSpecialValueFor("disarm_chance")) then

			-- Proc! Apply the disarm and cooldown modifiers
			target:AddNewModifier(owner, ability, "modifier_item_imba_sange_disarm", {duration = ability:GetSpecialValueFor("passive_disarm_duration")})
			target:AddNewModifier(owner, ability, "modifier_item_imba_heavens_halberd_disarm_cooldown", {duration = ability:GetSpecialValueFor("disarm_cooldown")})
			target:EmitSound("Imba.SangeProc")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Heaven's Halberd disarm cooldown (enemy-based)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_heavens_halberd_disarm_cooldown == nil then modifier_item_imba_heavens_halberd_disarm_cooldown = class({}) end
function modifier_item_imba_heavens_halberd_disarm_cooldown:IsHidden() return true end
function modifier_item_imba_heavens_halberd_disarm_cooldown:IsDebuff() return false end
function modifier_item_imba_heavens_halberd_disarm_cooldown:IsPurgable() return false end
function modifier_item_imba_heavens_halberd_disarm_cooldown:IsPermanent() return true end

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
LinkLuaModifier( "modifier_item_imba_yasha", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_yasha_stacks", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_item_imba_yasha_proc", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Move speed proc

function item_imba_yasha:GetAbilityTextureName()
	return "custom/imba_yasha"
end

function item_imba_yasha:GetIntrinsicModifierName()
	return "modifier_item_imba_yasha" end

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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_yasha:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_imba_yasha:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_imba_yasha:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_yasha:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_kaya_yasha",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Yasha attack
		YashaAttack(owner, self:GetAbility(), "modifier_item_imba_yasha_stacks", "modifier_item_imba_yasha_proc")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Yasha attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha_stacks == nil then modifier_item_imba_yasha_stacks = class({}) end
function modifier_item_imba_yasha_stacks:IsHidden() return false end
function modifier_item_imba_yasha_stacks:IsDebuff() return false end
function modifier_item_imba_yasha_stacks:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_yasha_stacks:GetEffectName()
	return "particles/item/swords/yasha_buff.vpcf"
end

function modifier_item_imba_yasha_stacks:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_yasha_stacks:OnCreated()
	self.as_stack = self:GetAbility():GetSpecialValueFor("as_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_stacks",
			"modifier_item_imba_kaya_yasha_stacks",
			"modifier_item_imba_triumvirate_stacks_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_yasha_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_yasha_stacks:GetModifierAttackSpeedBonus_Constant()
	return self.as_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Yasha move speed proc
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_yasha_proc == nil then modifier_item_imba_yasha_proc = class({}) end
function modifier_item_imba_yasha_proc:IsHidden() return true end
function modifier_item_imba_yasha_proc:IsDebuff() return false end
function modifier_item_imba_yasha_proc:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_yasha_proc:GetEffectName()
	return "particles/item/swords/yasha_proc.vpcf"
end

function modifier_item_imba_yasha_proc:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_yasha_proc:OnCreated()
	self.proc_ms = self:GetAbility():GetSpecialValueFor("proc_ms")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_proc",
			"modifier_item_imba_kaya_yasha_proc",
			"modifier_item_imba_triumvirate_proc_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_yasha_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_yasha_proc:GetModifierMoveSpeedBonus_Percentage()
	return self.proc_ms end

-----------------------------------------------------------------------------------------------------------
--	kaya definition
-----------------------------------------------------------------------------------------------------------

if item_imba_kaya == nil then item_imba_kaya = class({}) end
LinkLuaModifier( "modifier_item_imba_kaya", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_kaya:GetAbilityTextureName()
	return "item_kaya"
end

function item_imba_kaya:GetIntrinsicModifierName()
	return "modifier_item_imba_kaya"
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
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_item_imba_kaya:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_imba_kaya:GetCustomCooldownReductionStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

function modifier_item_imba_kaya:GetModifierSpellAmplify_Percentage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("spell_amp")
end

function modifier_item_imba_kaya:GetModifierPercentageManacost()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr")
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha definition
-----------------------------------------------------------------------------------------------------------

if item_imba_sange_yasha == nil then item_imba_sange_yasha = class({}) end
LinkLuaModifier( "modifier_item_imba_sange_yasha", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sange_yasha_maim", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Maim debuff
LinkLuaModifier( "modifier_item_imba_sange_yasha_disarm", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Disarm debuff
LinkLuaModifier( "modifier_item_imba_sange_yasha_stacks", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_item_imba_sange_yasha_proc", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Move speed proc

function item_imba_sange_yasha:GetAbilityTextureName()
	return "custom/imba_sange_and_yasha"
end

function item_imba_sange_yasha:GetIntrinsicModifierName()
	return "modifier_item_imba_sange_yasha" end

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
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_sange_yasha:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_sange_yasha:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_imba_sange_yasha:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_imba_sange_yasha:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility") end

function modifier_item_imba_sange_yasha:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_sange_yasha:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_kaya",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Sange and Yasha attack
		SangeYashaAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_sange_yasha_maim", "modifier_item_imba_sange_yasha_stacks", "modifier_item_imba_sange_yasha_disarm", "modifier_item_imba_sange_yasha_proc")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha maim debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha_maim == nil then modifier_item_imba_sange_yasha_maim = class({}) end
function modifier_item_imba_sange_yasha_maim:IsHidden() return false end
function modifier_item_imba_sange_yasha_maim:IsDebuff() return true end
function modifier_item_imba_sange_yasha_maim:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_yasha_maim:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_item_imba_sange_yasha_maim:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_yasha_maim:OnCreated()
	self.maim_stack = self:GetAbility():GetSpecialValueFor("maim_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_kaya_stacks",
			"modifier_item_imba_triumvirate_stacks_debuff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Inherit stacks from lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_sange_maim"
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
function modifier_item_imba_sange_yasha_maim:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_sange_yasha_maim:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

function modifier_item_imba_sange_yasha_maim:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha disarm debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha_disarm == nil then modifier_item_imba_sange_yasha_disarm = class({}) end
function modifier_item_imba_sange_yasha_disarm:IsHidden() return true end
function modifier_item_imba_sange_yasha_disarm:IsDebuff() return true end
function modifier_item_imba_sange_yasha_disarm:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_yasha_disarm:GetEffectName()
	return "particles/items2_fx/heavens_halberd.vpcf"
end

function modifier_item_imba_sange_yasha_disarm:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_sange_yasha_disarm:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha_stacks == nil then modifier_item_imba_sange_yasha_stacks = class({}) end
function modifier_item_imba_sange_yasha_stacks:IsHidden() return false end
function modifier_item_imba_sange_yasha_stacks:IsDebuff() return false end
function modifier_item_imba_sange_yasha_stacks:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_yasha_stacks:GetEffectName()
	return "particles/item/swords/yasha_buff.vpcf"
end

function modifier_item_imba_sange_yasha_stacks:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_yasha_stacks:OnCreated()
	self.as_stack = self:GetAbility():GetSpecialValueFor("as_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_triumvirate_stacks_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Inherit stacks from lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_stacks",
			"modifier_item_imba_kaya_yasha_stacks"
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
function modifier_item_imba_sange_yasha_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_sange_yasha_stacks:GetModifierAttackSpeedBonus_Constant()
	return self.as_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Sange and Yasha move speed proc
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_yasha_proc == nil then modifier_item_imba_sange_yasha_proc = class({}) end
function modifier_item_imba_sange_yasha_proc:IsHidden() return true end
function modifier_item_imba_sange_yasha_proc:IsDebuff() return false end
function modifier_item_imba_sange_yasha_proc:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_yasha_proc:GetEffectName()
	return "particles/item/swords/yasha_proc.vpcf"
end

function modifier_item_imba_sange_yasha_proc:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_yasha_proc:OnCreated()
	self.proc_ms = self:GetAbility():GetSpecialValueFor("proc_ms")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_triumvirate_proc_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Remove lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_proc",
			"modifier_item_imba_kaya_yasha_proc"
		}
		for _, modifier in pairs(lower_tier_modifiers) do
			owner:RemoveModifierByName(modifier)
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_sange_yasha_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_sange_yasha_proc:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then return end
	return self.proc_ms end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya definition
-----------------------------------------------------------------------------------------------------------

if item_imba_sange_kaya == nil then item_imba_sange_kaya = class({}) end
LinkLuaModifier( "modifier_item_imba_sange_kaya", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_sange_kaya_stacks", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Maim/amp debuff
LinkLuaModifier( "modifier_item_imba_sange_kaya_proc", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Disarm/silence debuff

function item_imba_sange_kaya:GetAbilityTextureName()
	return "custom/imba_sange_and_kaya"
end

function item_imba_sange_kaya:GetIntrinsicModifierName()
	return "modifier_item_imba_sange_kaya" end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_kaya == nil then modifier_item_imba_sange_kaya = class({}) end
function modifier_item_imba_sange_kaya:IsHidden() return true end
function modifier_item_imba_sange_kaya:IsDebuff() return false end
function modifier_item_imba_sange_kaya:IsPurgable() return false end
function modifier_item_imba_sange_kaya:IsPermanent() return true end
function modifier_item_imba_sange_kaya:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_sange_kaya:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_sange_kaya:GetCustomCooldownReduction()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr") end

function modifier_item_imba_sange_kaya:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_int") end

function modifier_item_imba_sange_kaya:GetModifierPreAttack_BonusDamage()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_sange_kaya:GetModifierBonusStats_Strength()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_strength") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_sange_kaya:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Sange and Yasha attack
		SangekayaAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_sange_kaya_stacks", "modifier_item_imba_sange_kaya_proc")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya maim/amp debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_kaya_stacks == nil then modifier_item_imba_sange_kaya_stacks = class({}) end
function modifier_item_imba_sange_kaya_stacks:IsHidden() return false end
function modifier_item_imba_sange_kaya_stacks:IsDebuff() return true end
function modifier_item_imba_sange_kaya_stacks:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_kaya_stacks:GetEffectName()
	return "particles/item/swords/sange_kaya_debuff.vpcf"
end

function modifier_item_imba_sange_kaya_stacks:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_sange_kaya_stacks:OnCreated()
	self.maim_stack = self:GetAbility():GetSpecialValueFor("maim_stack")
	self.amp_stack = self:GetAbility():GetSpecialValueFor("amp_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_triumvirate_stacks_debuff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Inherit stacks from lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_sange_maim",
			"modifier_item_imba_sange_yasha_maim",
			"modifier_item_imba_kaya_yasha_amp"
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
function modifier_item_imba_sange_kaya_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_item_imba_sange_kaya_stacks:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then return end
	return self.amp_stack * self:GetStackCount() end

function modifier_item_imba_sange_kaya_stacks:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

function modifier_item_imba_sange_kaya_stacks:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then return end
	return self.maim_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	Sange and kaya silence/disarm debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_sange_kaya_proc == nil then modifier_item_imba_sange_kaya_proc = class({}) end
function modifier_item_imba_sange_kaya_proc:IsHidden() return true end
function modifier_item_imba_sange_kaya_proc:IsDebuff() return true end
function modifier_item_imba_sange_kaya_proc:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_sange_kaya_proc:GetEffectName()
	return "particles/item/swords/sange_kaya_proc.vpcf"
end

function modifier_item_imba_sange_kaya_proc:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_sange_kaya_proc:CheckState()
	local states = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha definition
-----------------------------------------------------------------------------------------------------------

if item_imba_kaya_yasha == nil then item_imba_kaya_yasha = class({}) end
LinkLuaModifier( "modifier_item_imba_kaya_yasha", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_kaya_yasha_amp", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Amp debuff
LinkLuaModifier( "modifier_item_imba_kaya_yasha_silence", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Silence debuff
LinkLuaModifier( "modifier_item_imba_kaya_yasha_stacks", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_item_imba_kaya_yasha_proc", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )			-- Move speed proc

function item_imba_kaya_yasha:GetAbilityTextureName()
	return "custom/imba_kaya_and_yasha"
end

function item_imba_kaya_yasha:GetIntrinsicModifierName()
	return "modifier_item_imba_kaya_yasha" end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_yasha == nil then modifier_item_imba_kaya_yasha = class({}) end
function modifier_item_imba_kaya_yasha:IsHidden() return true end
function modifier_item_imba_kaya_yasha:IsDebuff() return false end
function modifier_item_imba_kaya_yasha:IsPurgable() return false end
function modifier_item_imba_kaya_yasha:IsPermanent() return true end
function modifier_item_imba_kaya_yasha:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_kaya_yasha:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_kaya_yasha:GetCustomCooldownReduction()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr") end

function modifier_item_imba_kaya_yasha:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end

function modifier_item_imba_kaya_yasha:GetModifierMoveSpeedBonus_Percentage_Unique()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_imba_kaya_yasha:GetModifierBonusStats_Agility()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_agility") end

function modifier_item_imba_kaya_yasha:GetModifierBonusStats_Intellect()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_int") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_kaya_yasha:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.target

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If a higher-priority sword is present, do nothing either
		local priority_sword_modifiers = {
			"modifier_item_imba_sange_yasha",
			"modifier_item_imba_sange_kaya",
			"modifier_item_imba_triumvirate"
		}
		for _, sword_modifier in pairs(priority_sword_modifiers) do
			if owner:HasModifier(sword_modifier) then
				return nil
			end
		end

		-- All conditions met, perform a Sange and Yasha attack
		kayaYashaAttack(owner, keys.target, self:GetAbility(), "modifier_item_imba_kaya_yasha_amp", "modifier_item_imba_kaya_yasha_stacks", "modifier_item_imba_kaya_yasha_silence", "modifier_item_imba_kaya_yasha_proc")
	end
end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha magic amp debuff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_yasha_amp == nil then modifier_item_imba_kaya_yasha_amp = class({}) end
function modifier_item_imba_kaya_yasha_amp:IsHidden() return false end
function modifier_item_imba_kaya_yasha_amp:IsDebuff() return true end
function modifier_item_imba_kaya_yasha_amp:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_kaya_yasha_amp:GetEffectName()
	return "particles/item/swords/kaya_debuff.vpcf"
end

function modifier_item_imba_kaya_yasha_amp:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_kaya_yasha_amp:OnCreated()
	self.amp_stack = self:GetAbility():GetSpecialValueFor("amp_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_kaya_stacks",
			"modifier_item_imba_triumvirate_stacks_debuff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		self:SetStackCount(stack_count)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_kaya_yasha_amp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_item_imba_kaya_yasha_amp:GetModifierMagicalResistanceBonus()
	if not self:GetAbility() then return end
	return self.amp_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha silence debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_yasha_silence == nil then modifier_item_imba_kaya_yasha_silence = class({}) end
function modifier_item_imba_kaya_yasha_silence:IsHidden() return true end
function modifier_item_imba_kaya_yasha_silence:IsDebuff() return true end
function modifier_item_imba_kaya_yasha_silence:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_kaya_yasha_silence:GetEffectName()
	return "particles/item/swords/kaya_proc.vpcf"
end

function modifier_item_imba_kaya_yasha_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Declare modifier states
function modifier_item_imba_kaya_yasha_silence:CheckState()
	local states = {
		[MODIFIER_STATE_SILENCED] = true,
	}
	return states
end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha attack speed buff (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_yasha_stacks == nil then modifier_item_imba_kaya_yasha_stacks = class({}) end
function modifier_item_imba_kaya_yasha_stacks:IsHidden() return false end
function modifier_item_imba_kaya_yasha_stacks:IsDebuff() return false end
function modifier_item_imba_kaya_yasha_stacks:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_kaya_yasha_stacks:GetEffectName()
	return "particles/item/swords/yasha_buff.vpcf"
end

function modifier_item_imba_kaya_yasha_stacks:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_kaya_yasha_stacks:OnCreated()
	self.as_stack = self:GetAbility():GetSpecialValueFor("as_stack")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_stacks",
			"modifier_item_imba_triumvirate_stacks_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Inherit stacks from lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_stacks",
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
function modifier_item_imba_kaya_yasha_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_kaya_yasha_stacks:GetModifierAttackSpeedBonus_Constant()
	if not self:GetAbility() then return end
	return self.as_stack * self:GetStackCount() end

-----------------------------------------------------------------------------------------------------------
--	kaya and Yasha move speed proc
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_kaya_yasha_proc == nil then modifier_item_imba_kaya_yasha_proc = class({}) end
function modifier_item_imba_kaya_yasha_proc:IsHidden() return true end
function modifier_item_imba_kaya_yasha_proc:IsDebuff() return false end
function modifier_item_imba_kaya_yasha_proc:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_kaya_yasha_proc:GetEffectName()
	return "particles/item/swords/yasha_proc.vpcf"
end

function modifier_item_imba_kaya_yasha_proc:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier property storage
function modifier_item_imba_kaya_yasha_proc:OnCreated()
	self.proc_ms = self:GetAbility():GetSpecialValueFor("proc_ms")

	-- Remove this if higher tier modifiers are present
	if IsServer() then
		local owner = self:GetParent()
		local higher_tier_modifiers = {
			"modifier_item_imba_sange_yasha_proc",
			"modifier_item_imba_triumvirate_proc_buff"
		}
		for _, modifier in pairs(higher_tier_modifiers) do
			if owner:FindModifierByName(modifier) then
				self:Destroy()
			end
		end

		-- Remove lower-tier modifiers
		local lower_tier_modifiers = {
			"modifier_item_imba_yasha_proc"
		}
		for _, modifier in pairs(lower_tier_modifiers) do
			owner:RemoveModifierByName(modifier)
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_kaya_yasha_proc:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_kaya_yasha_proc:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetAbility() then return end
	return self.proc_ms end

-----------------------------------------------------------------------------------------------------------
--	Triumvirate definition
-----------------------------------------------------------------------------------------------------------

if item_imba_triumvirate == nil then item_imba_triumvirate = class({}) end
LinkLuaModifier( "modifier_item_imba_triumvirate", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_triumvirate_stacks_debuff", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )	-- Maim/amp debuff
LinkLuaModifier( "modifier_item_imba_triumvirate_proc_debuff", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Disarm/silence debuff
LinkLuaModifier( "modifier_item_imba_triumvirate_stacks_buff", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Stacking attack speed
LinkLuaModifier( "modifier_item_imba_triumvirate_proc_buff", "items/item_swords.lua", LUA_MODIFIER_MOTION_NONE )		-- Move speed proc

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

function modifier_item_imba_triumvirate:GetCustomCooldownReduction()
	if not self:GetAbility() then return end
	return self:GetAbility():GetSpecialValueFor("bonus_cdr") end

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
			"modifier_item_imba_sange_maim",
			"modifier_item_imba_sange_yasha_maim",
			"modifier_item_imba_kaya_yasha_amp",
			"modifier_item_imba_sange_kaya_stacks"
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
			"modifier_item_imba_yasha_stacks",
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
	if target:IsMagicImmune() or (not IsHeroOrCreep(target)) then -- or attacker:GetTeam() == target:GetTeam() then
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
