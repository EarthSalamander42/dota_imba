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
--     suthernfriend, 03.02.2018
--	   Firetoad, 24.02.2018



-- Ancient Defense ability
imba_ancient_defense = class({})

LinkLuaModifier("modifier_imba_ancient_defense", "hero/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_ancient_defense:IsHiddenWhenStolen() return false end
function imba_ancient_defense:IsRefreshable() return false end
function imba_ancient_defense:IsStealable() return false end
function imba_ancient_defense:IsNetherWardStealable() return false end

function imba_ancient_defense:GetAbilityTextureName()
	return "custom/ancient_defense"
end

function imba_ancient_defense:GetIntrinsicModifierName()
	return "modifier_imba_ancient_defense"
end


-- Passive modifier
modifier_imba_ancient_defense = class({})
function modifier_imba_ancient_defense:IsDebuff() return false end
function modifier_imba_ancient_defense:IsHidden() return false end
function modifier_imba_ancient_defense:IsPurgable() return false end
function modifier_imba_ancient_defense:IsPurgeException() return false end
function modifier_imba_ancient_defense:IsStunDebuff() return false end

function modifier_imba_ancient_defense:OnCreated()
	if IsServer() then
		self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
		if GetMapName() == "imba_frantic_10v10" or GetMapName() == "imba_10v10" then
			self.max_stacks = self.max_stacks + 3
		end
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_ancient_defense:OnIntervalThink()
	if IsServer() then
		local ancient = self:GetParent()
		local nearby_enemies = FindUnitsInRadius(ancient:GetTeamNumber(), ancient:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		self:SetStackCount(math.max(self.max_stacks - #nearby_enemies, 0))
	end
end

function modifier_imba_ancient_defense:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_imba_ancient_defense:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("defense_stack") * self:GetStackCount()
end



-- Ancient Last Resort ability
imba_ancient_last_resort = class({})

LinkLuaModifier("modifier_imba_ancient_last_resort_aura", "hero/ancient_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_last_resort_debuff", "hero/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_ancient_last_resort:IsHiddenWhenStolen() return false end
function imba_ancient_last_resort:IsRefreshable() return false end
function imba_ancient_last_resort:IsStealable() return false end
function imba_ancient_last_resort:IsNetherWardStealable() return false end

function imba_ancient_last_resort:GetAbilityTextureName()
	return "custom/ancient_last_resort"
end

function imba_ancient_last_resort:GetIntrinsicModifierName()
	return "modifier_imba_ancient_last_resort_aura"
end


-- Passive modifier
modifier_imba_ancient_last_resort_aura = class({})
function modifier_imba_ancient_last_resort_aura:IsDebuff() return false end
function modifier_imba_ancient_last_resort_aura:IsHidden() return true end
function modifier_imba_ancient_last_resort_aura:IsPurgable() return false end
function modifier_imba_ancient_last_resort_aura:IsPurgeException() return false end
function modifier_imba_ancient_last_resort_aura:IsStunDebuff() return false end

function modifier_imba_ancient_last_resort_aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_ancient_last_resort_aura:OnIntervalThink()
	if IsServer() then
		local ancient = self:GetParent()
		local stacks = math.min(1 - ancient:GetHealth() / ancient:GetMaxHealth(), 0.75) * 100
		local nearby_enemies = FindUnitsInRadius(ancient:GetTeamNumber(), ancient:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_ancient_last_resort_debuff", {duration = 2.0}):SetStackCount(stacks)
		end
	end
end


-- Enemy debuff
modifier_imba_ancient_last_resort_debuff = class({})
function modifier_imba_ancient_last_resort_debuff:IsDebuff() return true end
function modifier_imba_ancient_last_resort_debuff:IsHidden() return false end
function modifier_imba_ancient_last_resort_debuff:IsPurgable() return false end
function modifier_imba_ancient_last_resort_debuff:IsPurgeException() return false end
function modifier_imba_ancient_last_resort_debuff:IsStunDebuff() return false end

function modifier_imba_ancient_last_resort_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_imba_ancient_last_resort_debuff:GetModifierMoveSpeedBonus_Percentage()
	return (-1) * self:GetStackCount()
end

function modifier_imba_ancient_last_resort_debuff:GetModifierAttackSpeedBonus_Constant()
	return (-1) * self:GetStackCount()
end

function modifier_imba_ancient_last_resort_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return (-1) * self:GetStackCount()
end