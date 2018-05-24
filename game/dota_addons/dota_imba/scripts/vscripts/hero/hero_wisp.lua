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
--     EarthSalamander #42, 23.05.2018
--     Based on old Dota 2 Spell Library: https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_wisp

CreateEmptyTalents("wisp")

------------------------------
--			TETHER			--
------------------------------
imba_wisp_tether = class({})
LinkLuaModifier("modifier_imba_wisp_tether", "hero/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_latch", "hero/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_tether:GetAbilityTextureName()
	return "wisp_tether"
end

function imba_wisp_tether:OnSpellStart()
	self.caster_origin = self:GetCaster():GetAbsOrigin()
	self.target_origin = self:GetCursorTarget():GetAbsOrigin()
	self.tether_ally = self:GetCursorTarget()

	self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
	self:GetCaster().tether_lastMana = self:GetCaster():GetMana()
	self:GetCaster():SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", true, false)
end

modifier_imba_wisp_tether = class({})

function modifier_imba_wisp_tether:IsHidden() return false end
function modifier_imba_wisp_tether:IsPurgable() return false end

function modifier_imba_wisp_tether:OnCreated()
	self.tether_heal_amp = self:GetAbility():GetSpecialValueFor("tether_heal_amp")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_wisp_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_MANA_GAINED,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
	}

	return decFuncs
end

function modifier_imba_wisp_tether:OnIntervalThink()
	self:GetParent().tether_lastHealth = self:GetParent():GetHealth()
	print("Ally ms:", self:GetAbility().tether_ally:GetIdealSpeed())
	self:SetStackCount(self:GetAbility().tether_ally:GetIdealSpeed())

	if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
		return
	end

	local distance = (self:GetAbility().tether_ally:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

	if distance <= self.radius then
		return
	end

	self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
end

function modifier_imba_wisp_tether:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
	end
end

function modifier_imba_wisp_tether:OnHealReceived(keys)
	if keys.unit == self:GetParent() then
		self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
	end
end

function modifier_imba_wisp_tether:OnHealReceived(keys)
	if keys.unit == self:GetParent() then
		self:HealAlly()
	end
end

function modifier_imba_wisp_tether:OnManaGained(keys)
	if keys.unit == self:GetParent() then
		self:GiveManaToAlly()
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeedOverride(params)
    return self:GetStackCount()
end

function modifier_imba_wisp_tether:OnRemoved()
	self:GetParent():SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", false, true)
end

-- utils

function modifier_imba_wisp_tether:HealAlly()
	local healthGained = self:GetAbility():GetCaster():GetHealth() - self:GetAbility():GetCaster().tether_lastHealth

	print(healthGained, self:GetAbility():GetCaster().tether_lastHealth)
	if healthGained < 0 then
		return
	end

	self:GetAbility():GetCursorTarget():Heal(healthGained * self:GetAbility().tether_heal_amp, self:GetAbility())
end

function modifier_imba_wisp_tether:GiveManaToAlly()
	local manaGained = self:GetAbility():GetCaster():GetMana() - self:GetAbility():GetCaster().tether_lastMana

	print(manaGained, self:GetAbility():GetCaster().tether_lastMana)
	if manaGained < 0 then
		return
	end

	target:GiveMana(manaGained * self:GetAbility().tether_heal_amp)
end

modifier_imba_wisp_tether_latch = class({})

imba_wisp_tether_break = class({})

function imba_wisp_tether_break:GetAbilityTextureName()
	return "wisp_tether_break"
end

function imba_wisp_tether_break:OnSpellStart()
	self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
end