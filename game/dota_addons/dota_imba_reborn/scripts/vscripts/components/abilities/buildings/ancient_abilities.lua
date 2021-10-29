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
--     Firetoad, 10.01.2016
--	   Firetoad, 24.02.2018
--	   EarthSalamander, 29.10.2021

-- Fountain Danger Zone ability
imba_fountain_danger_zone = imba_fountain_danger_zone or class({})

LinkLuaModifier("modifier_imba_fountain_danger_zone", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_danger_zone_debuff", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_fountain_danger_zone:IsHiddenWhenStolen() return false end
function imba_fountain_danger_zone:IsRefreshable() return false end
function imba_fountain_danger_zone:IsStealable() return false end
function imba_fountain_danger_zone:IsNetherWardStealable() return false end

function imba_fountain_danger_zone:GetAbilityTextureName()
	return "nevermore_shadowraze3"
end

function imba_fountain_danger_zone:GetIntrinsicModifierName()
	return "modifier_imba_fountain_danger_zone"
end

-- Passive modifier
modifier_imba_fountain_danger_zone = modifier_imba_fountain_danger_zone or class({})

function modifier_imba_fountain_danger_zone:IsDebuff() return false end
function modifier_imba_fountain_danger_zone:IsHidden() return true end
function modifier_imba_fountain_danger_zone:IsPurgable() return false end
function modifier_imba_fountain_danger_zone:IsPurgeException() return false end
function modifier_imba_fountain_danger_zone:IsStunDebuff() return false end

function modifier_imba_fountain_danger_zone:OnCreated()
	if not IsServer() then return end

	self.fountain = self:GetParent()
	self.aura_linger = self:GetAbility():GetLevelSpecialValueFor("aura_linger", 1)
	self.damage_pct = self:GetAbility():GetLevelSpecialValueFor("damage_pct", 1)
	self.radius = self:GetAbility():GetLevelSpecialValueFor("kill_radius", 1)
	self.interval = self.aura_linger / 2

	self.fountain:AddRangeIndicator(self.fountain, self:GetAbility(), nil, self.radius, 255, 40, 40, false, false, false, true)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_fountain_danger_zone:OnIntervalThink()
	if not IsServer() then return end

	local nearby_enemies = FindUnitsInRadius(self.fountain:GetTeamNumber(), self.fountain:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #nearby_enemies == 0 then return end

	for _, enemy in pairs(nearby_enemies) do
		local damage = (enemy:GetMaxHealth() * self.damage_pct / 100) * self.interval

		if enemy:IsInvulnerable() then
			enemy:SetHealth(math.max(enemy:GetHealth() - damage, 1))
		else
			ApplyDamage({attacker = self.fountain, victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end

		enemy:AddNewModifier(self.fountain, self:GetAbility(), "modifier_imba_fountain_danger_zone_debuff", {duration = self.aura_linger})
	end
end

modifier_imba_fountain_danger_zone_debuff = modifier_imba_fountain_danger_zone_debuff or class({})

-- function modifier_imba_fountain_danger_zone_debuff:IsDebuff() return false end
-- function modifier_imba_fountain_danger_zone_debuff:IsHidden() return true end
function modifier_imba_fountain_danger_zone_debuff:IsPurgable() return false end
function modifier_imba_fountain_danger_zone_debuff:IsPurgeException() return false end
function modifier_imba_fountain_danger_zone_debuff:IsStunDebuff() return false end
function modifier_imba_fountain_danger_zone_debuff:IgnoreTenacity()	return true end
function modifier_imba_fountain_danger_zone_debuff:GetTexture() return "nevermore_shadowraze3" end
function modifier_imba_fountain_danger_zone_debuff:GetEffectName() return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf" end

function modifier_imba_fountain_danger_zone_debuff:CheckState() return {
	[MODIFIER_STATE_SILENCED] 			= true,
	[MODIFIER_STATE_MUTED]				= true,
	[MODIFIER_STATE_DISARMED] 			= true,
	[MODIFIER_STATE_PASSIVES_DISABLED]	= true
} end
