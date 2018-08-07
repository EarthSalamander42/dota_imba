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


--------------------------------
--        BLADE MAIL          --
--------------------------------
item_imba_blade_mail = item_imba_blade_mail or class({})
LinkLuaModifier("modifier_imba_blade_mail", "components/items/item_blademail", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blade_mail_active", "components/items/item_blademail", LUA_MODIFIER_MOTION_NONE)

function item_imba_blade_mail:GetIntrinsicModifierName()
	return "modifier_imba_blade_mail"
end

function item_imba_blade_mail:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_active = "modifier_imba_blade_mail_active"

	-- Ability specials
	local return_duration = ability:GetSpecialValueFor("return_duration")

	-- Apply blade mail on caster!
	caster:AddNewModifier(caster, ability, modifier_active, {duration = return_duration})
end

function item_imba_blade_mail:GetAbilityTextureName()
	if IsClient() then
		local caster = self:GetCaster()
		if not caster:IsHero() then return "custom/imba_blade_mail" end

		local uniqueBM = {
			npc_dota_hero_axe = "axe",
		}

		if uniqueBM[caster:GetName()] then
			return "custom/imba_blade_mail_"..uniqueBM[caster:GetName()]
		end

		return "custom/imba_blade_mail"
	end
end

---------------------------------------
--     STATS MODIFIER (STACKABLE)    --
---------------------------------------
modifier_imba_blade_mail = modifier_imba_blade_mail or class({})

function modifier_imba_blade_mail:IsHidden() return true end
function modifier_imba_blade_mail:IsDebuff() return false end
function modifier_imba_blade_mail:IsPurgable() return false end
function modifier_imba_blade_mail:RemoveOnDeath() return false end
function modifier_imba_blade_mail:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_imba_blade_mail:OnCreated()
	-- Ability properties
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
end

function modifier_imba_blade_mail:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_blade_mail:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_blade_mail:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_imba_blade_mail:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end


---------------------------------------
--        BLADE MAIL (ACTIVE)        --
---------------------------------------
modifier_imba_blade_mail_active = modifier_imba_blade_mail_active or class({})

function modifier_imba_blade_mail_active:IsHidden() return false end
function modifier_imba_blade_mail_active:IsDebuff() return false end
function modifier_imba_blade_mail_active:IsPurgable() return false end

function modifier_imba_blade_mail_active:OnCreated()
	-- Ability properties
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- Ability specials
	self.return_damage_pct = self.ability:GetSpecialValueFor("return_damage_pct")
end

function modifier_imba_blade_mail_active:GetEffectName()
	return "particles/items_fx/blademail.vpcf"
end

function modifier_imba_blade_mail_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_blade_mail_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_imba_blade_mail_active:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_imba_blade_mail_active:OnTakeDamage(keys)
	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags

	-- Only apply if the one taking damage is the parent
	if target == self.parent then

		-- If the damage was self-inflicted or from an ally, ignore it
		if attacker:GetTeamNumber() == target:GetTeamNumber() then
			return nil
		end

		-- If the damage is flagged as HP Removal, ignore it
		if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
			return nil
		end

		-- If the damage is flagged as a reflection, ignore it
		if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			return nil
		end

		-- If the damage came from a ward or a building, ignore it
		if attacker:IsOther() or attacker:IsBuilding() then
			return nil
		end

		-- If the target is invulnerable, do nothing
		if target:IsInvulnerable() then
			return nil
		end

		-- If we're here, it's time to return the favor
		local damageTable = {victim = attacker,
			damage = original_damage,
			damage_type = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			attacker = self.parent,
			ability = self.ability
		}
		ApplyDamage(damageTable)
	end
end
