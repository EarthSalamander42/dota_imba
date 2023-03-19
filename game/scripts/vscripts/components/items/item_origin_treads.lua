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

--[[	Author: zimberzimber
		Date:	5.2.2017	]]
-- Merged with Origin Treads by Shush
-- 15.5.2020

-- Original Origin (get it?) by Altivu

-- Creator:
-- 	AltiV - April 14th, 2019

LinkLuaModifier("modifier_item_imba_origin_treads", "components/items/item_origin_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_treads_health", "components/items/item_origin_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_treads_power", "components/items/item_origin_treads", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_origin_treads_chaos", "components/items/item_origin_treads", LUA_MODIFIER_MOTION_NONE)

item_imba_origin_treads                 = class({})
modifier_item_imba_origin_treads        = class({})
modifier_item_imba_origin_treads_health = class({})
modifier_item_imba_origin_treads_power  = class({})
modifier_item_imba_origin_treads_chaos  = class({})

-----------------
-- ORIGIN BASE --
-----------------

function item_imba_origin_treads:GetIntrinsicModifierName()
	return "modifier_item_imba_origin_treads"
end

function item_imba_origin_treads:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_SUCCESS
	elseif self:GetCaster():GetModifierStackCount("modifier_item_imba_origin_treads", self:GetCaster()) == 3 and target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
end

function item_imba_origin_treads:GetAbilityTextureName()
	local origin_modifier_stack_count = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin_treads", self:GetCaster())

	if origin_modifier_stack_count then
		if origin_modifier_stack_count <= 1 then
			return "origin_treads_str"
		elseif origin_modifier_stack_count == 2 then
			return "origin_treads_agi"
		elseif origin_modifier_stack_count == 3 then
			return "origin_treads_int"
		else -- This should never be called but just in case...
			return "origin_treads_str"
		end
	end
end

function item_imba_origin_treads:OnSpellStart()
	local target = self:GetCursorTarget()
	local debuff_duration = self:GetSpecialValueFor("debuff_duration")

	if target == self:GetCaster() then
		-- Self cast is only just to change the Origin state so give back the mana and cooldown
		self:RefundManaCost()
		self:EndCooldown()

		local origin_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_item_imba_origin_treads", self:GetCaster())

		if origin_modifier then
			if origin_modifier:GetStackCount() == 3 then
				origin_modifier:SetStackCount(1)
			else
				origin_modifier:IncrementStackCount()
			end
		end

		target:CalculateStatBonus(true)
	else
		-- Do not bypass linken's Sphere
		if target:TriggerSpellAbsorb(self) then
			return
		end

		local origin_modifier_stack_count = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin_treads", self:GetCaster())

		local actual_debuff_duration
		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			actual_debuff_duration = debuff_duration * (1 - target:GetStatusResistance())
		else
			actual_debuff_duration = debuff_duration
		end

		-- Emit sound
		target:EmitSound("Origin.Cast")

		-- Emit particles
		local particle = ParticleManager:CreateParticle("particles/item/origin/origin_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 2, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)

		if origin_modifier_stack_count then
			if origin_modifier_stack_count <= 1 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_treads_health", { duration = actual_debuff_duration })
			elseif origin_modifier_stack_count == 2 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_treads_power", { duration = actual_debuff_duration })
			elseif origin_modifier_stack_count == 3 then
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_treads_chaos", { duration = actual_debuff_duration })
			else -- This should never be called but just in case...
				active_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_origin_treads_health", { duration = actual_debuff_duration })
			end
		end
	end

	-- This is in attempts to reserve the Origin item state if dropped and picked back up
	self.type = self:GetCaster():GetModifierStackCount("modifier_item_imba_origin_treads", self:GetCaster())
end

---------------------------------------------
-- ORIGIN HEALTHY STRENGTH ACTIVE MODIFIER --
---------------------------------------------

function modifier_item_imba_origin_treads_health:IsPurgable() return false end

function modifier_item_imba_origin_treads_health:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

function modifier_item_imba_origin_treads_health:GetTexture()
	return "origin_treads_str"
end

function modifier_item_imba_origin_treads_health:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.ability                     = self:GetAbility()
	self.caster                      = self:GetCaster()
	self.parent                      = self:GetParent()

	-- AbilitySpecials
	self.debuff_duration             = self.ability:GetSpecialValueFor("debuff_duration")
	self.str_cast_static_damage      = self.ability:GetSpecialValueFor("str_cast_static_damage")      -- flat damage
	self.str_cast_current_hp_pct_dmg = self.ability:GetSpecialValueFor("str_cast_current_hp_pct_dmg") -- % of current HP

	if not IsServer() then return end

	self:StartIntervalThink(1 * (1 - self:GetParent():GetStatusResistance()))
end

-- This is mostly just to recalculate who the caster is for damage ownership
function modifier_item_imba_origin_treads_health:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_origin_treads_health:OnIntervalThink()
	if not IsServer() then return end

	-- Applies flat damage and damage based on current HP in one instance
	ApplyDamage({
		victim       = self.parent,
		damage       = self.str_cast_static_damage + (self.parent:GetHealth() * (self.str_cast_current_hp_pct_dmg / 100)),
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		attacker     = self.caster,
		ability      = self.ability
	})
end

function modifier_item_imba_origin_treads_health:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_origin_treads_health:GetDisableHealing()
	return 1
end

function modifier_item_imba_origin_treads_health:OnTooltip(keys)
	if keys.fail_type == 0 then
		return self.str_cast_static_damage
	elseif keys.fail_type == 1 then
		return self.str_cast_current_hp_pct_dmg
	end
end

----------------------------------------
-- ORIGIN AGILE POWER ACTIVE MODIFIER --
----------------------------------------

function modifier_item_imba_origin_treads_power:IsPurgable() return false end

function modifier_item_imba_origin_treads_power:GetEffectName()
	return "particles/items4_fx/nullifier_slow.vpcf"
end

function modifier_item_imba_origin_treads_power:GetTexture()
	return "origin_treads_agi"
end

function modifier_item_imba_origin_treads_power:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.ability                       = self:GetAbility()
	self.caster                        = self:GetCaster()
	self.parent                        = self:GetParent()

	-- AbilitySpecials
	self.agi_cast_stat_reduction_pct   = self.ability:GetSpecialValueFor("agi_cast_stat_reduction_pct")
	self.agi_cast_damage_reduction_pct = self.ability:GetSpecialValueFor("agi_cast_damage_reduction_pct")

	if not IsServer() then return end

	if self.parent.GetPrimaryStatValue then
		self:SetStackCount(math.max(self.parent:GetPrimaryStatValue() * self.agi_cast_stat_reduction_pct / 100, 0))
	end
end

function modifier_item_imba_origin_treads_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_item_imba_origin_treads_power:GetModifierBonusStats_Strength()
	return self:GetStackCount() * (-1)
end

function modifier_item_imba_origin_treads_power:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (-1)
end

function modifier_item_imba_origin_treads_power:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * (-1)
end

function modifier_item_imba_origin_treads_power:GetModifierDamageOutgoing_Percentage()
	return self.agi_cast_damage_reduction_pct * (-1)
end

----------------------------------
-- ORIGIN CHAOS ACTIVE MODIFIER --
----------------------------------

function modifier_item_imba_origin_treads_chaos:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_origin_treads_chaos:GetEffectName()
	return "particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_ti6.vpcf"
end

function modifier_item_imba_origin_treads_chaos:GetStatusEffectName()
	return "particles/status_fx/status_effect_blademail.vpcf"
end

function modifier_item_imba_origin_treads_chaos:GetTexture()
	return "origin_treads_int"
end

function modifier_item_imba_origin_treads_chaos:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.ability                       = self:GetAbility()
	self.caster                        = self:GetCaster()
	self.parent                        = self:GetParent()

	-- AbilitySpecials
	self.int_cast_dmg_spread_radius    = self.ability:GetSpecialValueFor("int_cast_dmg_spread_radius")
	self.int_cast_dmg_spread_pct       = self.ability:GetSpecialValueFor("int_cast_dmg_spread_pct")
	self.int_cast_ally_dmg_rdction_pct = self.ability:GetSpecialValueFor("int_cast_ally_dmg_rdction_pct")
	self.int_cast_magic_damage_inc_pct = self.ability:GetSpecialValueFor("int_cast_magic_damage_inc_pct")

	if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
		self.int_cast_dmg_spread_pct = self.int_cast_dmg_spread_pct * self.int_cast_ally_dmg_rdction_pct / 100
	end
end

function modifier_item_imba_origin_treads_chaos:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_imba_origin_treads_chaos:OnTakeDamage(keys)
	-- No infinite loops plz
	if keys.unit == self.parent and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		local particle = ParticleManager:CreateParticle("particles/item/origin/origin_chaos_splash.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:ReleaseParticleIndex(particle)

		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.int_cast_dmg_spread_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		for _, enemy in pairs(enemies) do
			if enemy ~= self.parent then
				local damageTable = {
					victim       = enemy,
					damage       = keys.original_damage * (self.int_cast_dmg_spread_pct / 100),
					damage_type  = keys.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
					attacker     = self.caster,
					ability      = self.ability
				}

				ApplyDamage(damageTable)
			end
		end
	end
end

function modifier_item_imba_origin_treads_chaos:OnTooltip(keys)
	if keys.fail_type == 0 then
		return self.int_cast_dmg_spread_pct
	elseif keys.fail_type == 1 then
		return self.int_cast_dmg_spread_radius
	elseif keys.fail_type == 2 then
		return self.int_cast_magic_damage_inc_pct
	end
end

function modifier_item_imba_origin_treads_chaos:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_type == DAMAGE_TYPE_MAGICAL then
		return self.int_cast_magic_damage_inc_pct
	end

	return 0
end

---------------------
-- ORIGIN MODIFIER --
---------------------

function modifier_item_imba_origin_treads:IsHidden() return true end

function modifier_item_imba_origin_treads:IsPurgable() return false end

function modifier_item_imba_origin_treads:RemoveOnDeath() return false end

function modifier_item_imba_origin_treads:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_origin_treads:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.ability                       = self:GetAbility()
	self.caster                        = self:GetCaster()
	self.parent                        = self:GetParent()

	-- AbilitySpecials
	self.all_stats                     = self.ability:GetSpecialValueFor("all_stats")
	self.stat_bonus_state              = self.ability:GetSpecialValueFor("stat_bonus_state")

	self.bonus_movement_speed          = self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_attack_speed            = self.ability:GetSpecialValueFor("bonus_attack_speed")

	self.bonus_health                  = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana                    = self.ability:GetSpecialValueFor("bonus_mana")

	-- Healthy Strength
	self.str_hp_regen                  = self.ability:GetSpecialValueFor("str_hp_regen")
	self.str_hp_regen_amp_pct          = self.ability:GetSpecialValueFor("str_hp_regen_amp_pct")

	-- Agile Power
	self.agi_damage_bonus              = self.ability:GetSpecialValueFor("agi_damage_bonus")
	self.agi_armor_ignore_chance_pct   = self.ability:GetSpecialValueFor("agi_armor_ignore_chance_pct")

	-- Chaotic Intelligence
	self.int_cast_range                = self.ability:GetSpecialValueFor("int_cast_range")
	self.int_magical_damage_return_pct = self.ability:GetSpecialValueFor("int_magical_damage_return_pct")

	if not IsServer() then return end

	-- Get back state of which item was dropped
	if self.ability.type then
		self:SetStackCount(self.ability.type)
	else
		self:SetStackCount(1)
	end
end

function modifier_item_imba_origin_treads:DeclareFunctions()
	return {

		-- Regular item bonuses (stats are increased if they're set on the relevant state)
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE, -- GetModifierMoveSpeedBonus_Special_Boots
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, -- GetModifierAttackSpeedBonus_Constant

		-- Healthy Strength (1)
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, -- GetModifierConstantHealthRegen
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,

		-- Agile Power (2)
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, -- GetModifierPreAttack_BonusDamage
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,

		-- Chaotic Intelligence (3)
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_item_imba_origin_treads:GetModifierBonusStats_Strength()
	if self:GetStackCount() == 1 then
		return self.all_stats + self.stat_bonus_state
	else
		return self.all_stats
	end
end

function modifier_item_imba_origin_treads:GetModifierBonusStats_Agility()
	if self:GetStackCount() == 2 then
		return self.all_stats + self.stat_bonus_state
	else
		return self.all_stats
	end
end

function modifier_item_imba_origin_treads:GetModifierBonusStats_Intellect()
	if self:GetStackCount() == 3 then
		return self.all_stats + self.stat_bonus_state
	else
		return self.all_stats
	end
end

function modifier_item_imba_origin_treads:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_origin_treads:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_origin_treads:GetModifierMoveSpeedBonus_Special_Boots()
	return self.bonus_movement_speed
end

function modifier_item_imba_origin_treads:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

-- HEALTHY STRENGTH

function modifier_item_imba_origin_treads:GetModifierConstantHealthRegen()
	if self:GetStackCount() == 1 then
		return self.str_hp_regen
	end
end

function modifier_item_imba_origin_treads:GetModifierHPRegenAmplify_Percentage()
	if self:GetStackCount() == 1 then
		return self.str_hp_regen_amp_pct
	end
end

-- AGILE POWER
function modifier_item_imba_origin_treads:GetModifierPreAttack_BonusDamage()
	if self:GetStackCount() == 2 then
		return self.agi_damage_bonus
	end
end

function modifier_item_imba_origin_treads:GetModifierProcAttack_BonusDamage_Physical(keys)
	-- Only apply if the attack was done by the caster and this modifier's stack count is 2 (agility)	
	if keys.attacker == self.parent and keys.target:GetTeamNumber() ~= self.parent:GetTeamNumber() and self:GetStackCount() == 2 and RollPseudoRandom(self.agi_armor_ignore_chance_pct, self) then
		-- Calculate armor reduction from target		
		local damage = CalculateDamageIgnoringArmor(keys.target:GetPhysicalArmorBaseValue(), keys.damage)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, keys.target, damage, nil)
		return damage
	end
end

-- CHAOTIC INTELLIGENCE
function modifier_item_imba_origin_treads:GetModifierCastRangeBonusStacking()
	if self:GetStackCount() == 3 then
		return self.int_cast_range
	end
end

function modifier_item_imba_origin_treads:OnTakeDamage(keys)
	if self:GetStackCount() == 3 and keys.unit == self.parent and keys.unit ~= keys.attacker and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			local damageTable = {
				victim       = keys.attacker,
				damage       = keys.original_damage * (self.int_magical_damage_return_pct / 100),
				damage_type  = keys.damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
				attacker     = self.caster,
				ability      = self.ability
			}

			ApplyDamage(damageTable)
		end
	end
end
