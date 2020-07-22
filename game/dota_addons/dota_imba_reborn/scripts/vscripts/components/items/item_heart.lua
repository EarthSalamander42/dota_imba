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
-- Date: 04/08/2017

item_imba_heart = item_imba_heart or class({})

LinkLuaModifier("modifier_item_imba_heart", "components/items/item_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_heart_aura_buff", "components/items/item_heart", LUA_MODIFIER_MOTION_NONE)

function item_imba_heart:GetIntrinsicModifierName()
	return "modifier_item_imba_heart"
end

function item_imba_heart:GetCooldown(level)
	if self:GetCaster():IsRangedAttacker() then
		return self:GetSpecialValueFor("regen_cooldown_ranged")
	else
		return self:GetSpecialValueFor("regen_cooldown_melee")
	end
end

-- Stats modifier (stackable)
modifier_item_imba_heart = modifier_item_imba_heart or class({})

function modifier_item_imba_heart:IsHidden()		return true end
function modifier_item_imba_heart:IsPurgable()		return false end
function modifier_item_imba_heart:RemoveOnDeath()	return false end
function modifier_item_imba_heart:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_heart:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	
    -- Use Secondary Charges system to make CDR not stack with multiple Kayas
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end

    -- i guess this is still required?
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_heart:OnIntervalThink()
	if not self:GetAbility() then
		self:StartIntervalThink(-1)
		self:Destroy()
		return nil
	end

	if self:GetAbility():GetCooldownTimeRemaining() == 0 then
--		self:SetStackCount(self:GetAbility():GetSpecialValueFor("noncombat_regen"))
		self:SetStackCount(1)
	else
--		self:SetStackCount(self:GetAbility():GetSpecialValueFor("base_regen"))
		self:SetStackCount(0)
	end
end

function modifier_item_imba_heart:OnDestroy()
    if not IsServer() then return end

    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_heart:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end

function modifier_item_imba_heart:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_item_imba_heart:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_item_imba_heart:GetModifierHealthRegenPercentage()
	if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 then
		if not self:GetParent():IsIllusion() then
			return self:GetAbility():GetSpecialValueFor("health_regen_pct")
		else
			-- IMBAfication: We Are All Alive
			return self:GetAbility():GetSpecialValueFor("health_regen_pct") * self:GetAbility():GetSpecialValueFor("alive_illusion_pct") / 100
		end
	end
end

function modifier_item_imba_heart:OnTakeDamage(keys)
	-- "Damage greater than 0 from any player (including allies, excluding self) or Roshan puts the regeneration on a 5/7-second cooldown. "
	if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 and keys.unit == self:GetParent() and keys.damage > 0 and keys.attacker ~= keys.unit and (keys.attacker:IsHero() or keys.attacker:IsConsideredHero() or keys.attacker:IsRoshan()) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		if self:GetParent():IsRangedAttacker() then
			self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("regen_cooldown_ranged") * self:GetParent():GetCooldownReduction())
		else
			self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("regen_cooldown_melee") * self:GetParent():GetCooldownReduction())
		end
	end
end

function modifier_item_imba_heart:GetModifierHPRegenAmplify_Percentage()
	if self:GetAbility() then
		if self:GetStackCount() == 1 then
			if self:GetParent():IsIllusion() then
				-- IMBAfication: We Are All Alive
				return self:GetAbility():GetSpecialValueFor("hp_regen_amp") * self:GetAbility():GetSpecialValueFor("alive_illusion_pct") / 100
			else
				return self:GetAbility():GetSpecialValueFor("hp_regen_amp")
			end
		else
			return self:GetAbility():GetSpecialValueFor("hp_regen_amp_broken")
		end
	end
end

function modifier_item_imba_heart:IsAura() return true end

function modifier_item_imba_heart:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_item_imba_heart:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_imba_heart:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_heart:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_item_imba_heart:GetModifierAura()		return "modifier_item_imba_heart_aura_buff" end

-- Aura buff
modifier_item_imba_heart_aura_buff = modifier_item_imba_heart_aura_buff or class({})

function modifier_item_imba_heart_aura_buff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if not self:GetAbility() then self:Destroy() return end

	-- Ability specials	
	self.aura_str = self:GetAbility():GetSpecialValueFor("aura_str")	
end

function modifier_item_imba_heart_aura_buff:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}
end

function modifier_item_imba_heart_aura_buff:GetModifierBonusStats_Strength()
	return self.aura_str
end
