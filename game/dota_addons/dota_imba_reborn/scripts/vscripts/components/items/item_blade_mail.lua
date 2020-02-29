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
-- Date: 17/06/2017

-- Refactored by:
-- 	AltiV - June 8th, 2019

LinkLuaModifier("modifier_item_imba_blade_mail", "components/items/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_blade_mail_active", "components/items/item_blade_mail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_blade_mail_lacerate", "components/items/item_blade_mail", LUA_MODIFIER_MOTION_NONE)

item_imba_blade_mail					= class({})
modifier_item_imba_blade_mail			= class({})
modifier_item_imba_blade_mail_active	= class({})
modifier_item_imba_blade_mail_lacerate	= class({})

item_imba_bladestorm_mail				= item_imba_blade_mail

---------------------
-- BLADE MAIL BASE --
---------------------

function item_imba_blade_mail:GetAbilityTextureName()
	local uniqueBM = {
		npc_dota_hero_axe = "axe",
	}
	
	if self:GetLevel() == 2 then
		return "custom/item_bladestorm_mail"
	elseif uniqueBM[self:GetCaster():GetName()] then
		return "custom/imba_blade_mail_"..uniqueBM[self:GetCaster():GetName()]
	else
		return "item_blade_mail"
	end
end

function item_imba_blade_mail:GetIntrinsicModifierName()
	return "modifier_item_imba_blade_mail"
end

function item_imba_blade_mail:OnSpellStart()
	self:GetCaster():EmitSound("DOTA_Item.BladeMail.Activate")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_blade_mail_active", {duration = self:GetSpecialValueFor("duration")})
end

-------------------------
-- BLADE MAIL MODIFIER --
-------------------------

function modifier_item_imba_blade_mail:IsHidden()	return true end

function modifier_item_imba_blade_mail:OnCreated()
	self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_armor		= self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_intellect	= self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_imba_blade_mail:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
	
    return decFuncs
end

function modifier_item_imba_blade_mail:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_blade_mail:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_imba_blade_mail:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

--------------------------------
-- BLADE MAIL ACTIVE MODIFIER --
--------------------------------

function modifier_item_imba_blade_mail_active:IsPurgable() return false end

function modifier_item_imba_blade_mail_active:GetEffectName()
	if (self:GetAbility() and self:GetAbility():GetLevel()) == 2 or self.level == 2 then
		return "particles/items_fx/bladestorm_mail.vpcf"
	else
		return "particles/items_fx/blademail.vpcf"
	end
end

function modifier_item_imba_blade_mail_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_item_imba_blade_mail_active:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_item_imba_blade_mail_active:OnCreated()
	self.level				= self:GetAbility():GetLevel()
	
	self.lacerate_pct		= self:GetAbility():GetSpecialValueFor("lacerate_pct")
	self.lacerate_duration	= self:GetAbility():GetSpecialValueFor("lacerate_duration")
	self.justice_pct		= self:GetAbility():GetSpecialValueFor("justice_pct")
end

function modifier_item_imba_blade_mail_active:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("DOTA_Item.BladeMail.Deactivate")
end

function modifier_item_imba_blade_mail_active:OnTakeDamage(keys)
	if not IsServer() then return end
	
	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags

	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())
		
			local damageTable = {
				victim			= keys.attacker,
				damage			= keys.original_damage,
				damage_type		= keys.damage_type,
				damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			
			local reflectDamage = ApplyDamage(damageTable)
			
			-- IMBAfication: Lacerate
			local lacerate_modifier = keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_blade_mail_lacerate", {duration = self.lacerate_duration})
			
			if lacerate_modifier then
				lacerate_modifier:SetDuration(self.lacerate_duration * (1 - keys.attacker:GetStatusResistance()), true)
				-- Don't want to brick units into negative max health, so set an upper limit
				lacerate_modifier:SetStackCount(math.min(lacerate_modifier:GetStackCount() + (reflectDamage * self.lacerate_pct * 0.01), lacerate_modifier:GetStackCount() + keys.attacker:GetMaxHealth() - 1))
				
				if keys.attacker.CalculateStatBonus then
					keys.attacker:CalculateStatBonus()
				end
				
				if keys.attacker:GetMaxHealth() <= 0 then
					lacerate_modifier:Destroy()
				end
			end
		end
		
		-- IMBAfication: Justice
		if ((self:GetAbility() and self:GetAbility():GetLevel() >= 2) or self.level >= 2) and keys.attacker:GetPlayerOwner() and keys.attacker:GetPlayerOwner():GetAssignedHero() and keys.attacker ~= keys.attacker:GetPlayerOwner():GetAssignedHero() then
			EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())
			
			local damageTable = {
				victim			= keys.attacker:GetPlayerOwner():GetAssignedHero(),
				damage			= keys.original_damage * self.justice_pct * 0.01,
				damage_type		= keys.damage_type,
				damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			
			local reflectDamage = ApplyDamage(damageTable)
			
			-- IMBAfication: Lacerate
			local lacerate_modifier = keys.attacker:GetPlayerOwner():GetAssignedHero():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_blade_mail_lacerate", {duration = self.lacerate_duration})
			
			if lacerate_modifier then
				lacerate_modifier:SetDuration(self.lacerate_duration * (1 - keys.attacker:GetPlayerOwner():GetAssignedHero():GetStatusResistance()), true)
				-- Don't want to brick units into negative max health, so set an upper limit
				lacerate_modifier:SetStackCount(math.min(lacerate_modifier:GetStackCount() + (reflectDamage * self.lacerate_pct * 0.01), lacerate_modifier:GetStackCount() + keys.attacker:GetMaxHealth() - 1))
				
				if keys.attacker:GetPlayerOwner():GetAssignedHero().CalculateStatBonus then
					keys.attacker:GetPlayerOwner():GetAssignedHero():CalculateStatBonus()
				end
				
				if keys.attacker:GetPlayerOwner():GetAssignedHero():GetMaxHealth() <= 0 then
					lacerate_modifier:Destroy()
				end
			end
		end
	end
end

----------------------------------
-- BLADE MAIL LACERATE MODIFIER --
----------------------------------

function modifier_item_imba_blade_mail_lacerate:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner_smoke_dark.vpcf"
end

-- Unbricking
function modifier_item_imba_blade_mail_lacerate:OnDestroy()
	if not IsServer() then return end
	
	if self:GetParent():GetMaxHealth() <= 0 then
		self:GetParent():SetMaxHealth(self:GetParent():GetBaseMaxHealth())
		self:GetParent():SetHealth(1)
	end
end

function modifier_item_imba_blade_mail_lacerate:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}
	
	return decFuncs
end

function modifier_item_imba_blade_mail_lacerate:GetModifierExtraHealthBonus()
	return self:GetStackCount() * (-1)
end

