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
--     Seinken, 16.03.2017
--     AltiV, 08.12.2019 (7.23 Changes)

LinkLuaModifier("modifier_imba_bane_enfeeble_723_handler", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_enfeeble_723_effect", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_bane_fiends_grip_723_handler", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bane_fiends_grip_723", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

imba_bane_enfeeble_723                     = imba_bane_enfeeble_723 or class({})
modifier_imba_bane_enfeeble_723_handler    = modifier_imba_bane_enfeeble_723_handler or class({})
modifier_imba_bane_enfeeble_723_effect     = modifier_imba_bane_enfeeble_723_effect or class({})

imba_bane_brain_sap_723                    = imba_bane_brain_sap_723 or class({})

imba_bane_fiends_grip_723                  = imba_bane_fiends_grip_723 or class({})
modifier_imba_bane_fiends_grip_723_handler = modifier_imba_bane_fiends_grip_723_handler or class({})
modifier_imba_bane_fiends_grip_723         = modifier_imba_bane_fiends_grip_723 or class({})

--------------------------------------
----------    ENFEEBLE    ------------
--------------------------------------
LinkLuaModifier("modifier_imba_enfeeble_debuff", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enfeeble_debuff_vision_handler", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

local function findtarget(source) -- simple list return function for finding a players current target entity
	local t = source:GetCursorTarget()
	local c = source:GetCaster()
	if t and c then return t, c end
end

-- Main enfeeble casting
imba_bane_enfeeble = imba_bane_enfeeble or class({})

-- Enfeeble Spell Cast
function imba_bane_enfeeble:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local target, caster = findtarget(self)
		local enfeeble_duration = self:GetSpecialValueFor("enfeeble_duration")
		local talent_aoe = caster:FindTalentValue("special_bonus_imba_bane_2")

		if target:TriggerSpellAbsorb(self) then return end --Spell block handler

		-- #2 TALENT : Enfeeble is aoe
		if caster:HasTalent("special_bonus_imba_bane_2") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				talent_aoe,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, self, "modifier_imba_enfeeble_debuff", { duration = enfeeble_duration * (1 - enemy:GetStatusResistance()) })
			end
		else
			-- Apply enfeeble debuff
			target:AddNewModifier(caster, self, "modifier_imba_enfeeble_debuff", { duration = enfeeble_duration * (1 - target:GetStatusResistance()) })
		end

		-- Emit sound effect
		EmitSoundOn("Hero_Bane.Enfeeble.Cast", caster)
		EmitSoundOn("hero_bane.enfeeble", target)
		if RollPercentage(75) then
			EmitSoundOn("bane_bane_ability_enfeeble_" .. string.format("%02d", RandomInt(1, 14)), self:GetCaster())
		end
	end
end

function imba_bane_enfeeble:GetAbilityTextureName()
	return "bane_enfeeble"
end

-- #2 TALENT : Enfeeble is aoe
function imba_bane_enfeeble:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_bane_2") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
	end
end

function imba_bane_enfeeble:GetAOERadius()
	local caster = self:GetCaster()
	local radius

	if caster:HasTalent("special_bonus_imba_bane_2") then
		radius = caster:FindTalentValue("special_bonus_imba_bane_2")
	end

	return radius
end

-- Enfeeble Debuff
modifier_imba_enfeeble_debuff = modifier_imba_enfeeble_debuff or class({})

function modifier_imba_enfeeble_debuff:GetEffectName() return "particles/units/heroes/hero_bane/bane_enfeeble.vpcf" end

function modifier_imba_enfeeble_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_enfeeble_debuff:OnCreated()
	if IsServer() then
		--Ability properties
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		self.parent = self:GetParent()

		-- Ability paramaters
		self.duration = self:GetDuration() * (1 - self.parent:GetStatusResistance())
		self.max_stacks = ability:GetSpecialValueFor("max_stacks")

		-- Initialize table
		self.stacks_table = {}
		table.insert(self.stacks_table, GameRules:GetGameTime())

		-- Start thinking
		self:StartIntervalThink(0.1)

		-- Apply periodic vision reduction modifier
		self.parent:AddNewModifier(caster, ability, "modifier_imba_enfeeble_debuff_vision_handler", {})

		-- #4 TALENT: Enfeeble reduces stats
		self.strength_bonus = -(self.parent:GetStrength() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
		self.agility_bonus = -(self.parent:GetAgility() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
		self.intellect_bonus = -(self.parent:GetIntellect() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
	end
end

function modifier_imba_enfeeble_debuff:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then
			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Calculate stats
			self:GetParent():CalculateStatBonus(true)
		end
	end
end

function modifier_imba_enfeeble_debuff:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		if self:GetStackCount() < 5 then
			table.insert(self.stacks_table, GameRules:GetGameTime())
		end

		-- #4 TALENT: Enfeeble reduces stats
		local caster = self:GetCaster()
		self.strength_bonus = -(self.parent:GetStrength() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
		self.agility_bonus = -(self.parent:GetAgility() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
		self.intellect_bonus = -(self.parent:GetIntellect() * (caster:FindTalentValue("special_bonus_imba_bane_4") / 100))
	end
end

function modifier_imba_enfeeble_debuff:OnDestroy()
	-- Remove vision debuff at the end
	if IsServer() then
		local vision_modifier_handler = "modifier_imba_enfeeble_debuff_vision_handler"
		if self.parent:HasModifier(vision_modifier_handler) then self.parent:RemoveModifierByName(vision_modifier_handler) end
	end
end

function modifier_imba_enfeeble_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_imba_enfeeble_debuff:GetModifierAttackSpeedBonus_Constant()
	-- Keep working if the stacks were consumed
	if self:GetStackCount() > 0 then
		return self:GetAbility():GetSpecialValueFor("as_reduction") * (self:GetStackCount())
	else
		return self:GetAbility():GetSpecialValueFor("as_reduction")
	end
end

-- #4 TALENT: Enfeeble reduces stats
function modifier_imba_enfeeble_debuff:GetModifierBonusStats_Strength()
	if self.strength_bonus then
		-- Keep working if the stacks were consumed
		if self:GetStackCount() > 0 then
			return self.strength_bonus * (self:GetStackCount())
		else
			return self.strength_bonus
		end
	else
		return 0
	end
end

function modifier_imba_enfeeble_debuff:GetModifierBonusStats_Agility()
	if self.agility_bonus then
		-- Keep working if the stacks were consumed
		if self:GetStackCount() > 0 then
			return self.agility_bonus * (self:GetStackCount())
		else
			return self.agility_bonus
		end
	else
		return 0
	end
end

function modifier_imba_enfeeble_debuff:GetModifierBonusStats_Intellect()
	if self.intellect_bonus then
		-- Keep working if the stacks were consumed
		if self:GetStackCount() > 0 then
			return self.intellect_bonus * (self:GetStackCount())
		else
			return self.intellect_bonus
		end
	else
		return 0
	end
end

function modifier_imba_enfeeble_debuff:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_status_resistance")
end

-- Enfeeble vision debuff applier

modifier_imba_enfeeble_debuff_vision_handler = modifier_imba_enfeeble_debuff_vision_handler or class({})

function modifier_imba_enfeeble_debuff_vision_handler:IsDebuff() return true end

function modifier_imba_enfeeble_debuff_vision_handler:IsPurgable() return false end

function modifier_imba_enfeeble_debuff_vision_handler:IsHidden() return true end

function modifier_imba_enfeeble_debuff_vision_handler:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self.check_interval = self.ability:GetSpecialValueFor("check_interval")
	self.reduction = self.ability:GetSpecialValueFor("vision_reduction")
	self.stack_vision_efficiency = self.ability:GetSpecialValueFor("stack_vision_efficiency")
	self.efficiency = (1 - self.stack_vision_efficiency / 100)

	self:StartIntervalThink(self.check_interval)
end

function modifier_imba_enfeeble_debuff_vision_handler:OnRefresh()
	self:OnCreated()
end

function modifier_imba_enfeeble_debuff_vision_handler:OnIntervalThink()
	local enfeeble_stacks = self.parent:GetModifierStackCount("modifier_imba_enfeeble_debuff", self:GetCaster())

	-- Whew perry, I salute you. Diminishing returns over stacks!
	self.vision_reduction = self.reduction * (1 - (self.efficiency) ^ enfeeble_stacks) / (1 - self.efficiency)
end

function modifier_imba_enfeeble_debuff_vision_handler:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}
	return decFuncs
end

function modifier_imba_enfeeble_debuff_vision_handler:GetBonusDayVision()
	if self.vision_reduction then
		return self.vision_reduction * (-1)
	end
end

function modifier_imba_enfeeble_debuff_vision_handler:GetBonusNightVision()
	if self.vision_reduction then
		return self.vision_reduction * (-1)
	end
end

----------------------------
-- IMBA_BANE_ENFEEBLE_723 --
----------------------------

function imba_bane_enfeeble_723:GetIntrinsicModifierName()
	return "modifier_imba_bane_enfeeble_723_handler"
end

function imba_bane_enfeeble_723:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function imba_bane_enfeeble_723:GetCastAnimation()
	if self:GetCaster():GetName() == "npc_dota_hero_bane" then
		return ACT_DOTA_ENFEEBLE
	else
		return ACT_DOTA_CAST_ABILITY_1
	end
end

-- IMBAfication: Remnants of Enfeeble
function imba_bane_enfeeble_723:OnSpellStart()
	local target = self:GetCursorTarget()

	if not target:TriggerSpellAbsorb(self) then
		self:GetCaster():EmitSound("Hero_Bane.Enfeeble.Cast")
		target:EmitSound("Hero_Bane.Enfeeble")

		if self:GetCaster():GetName() == "npc_dota_hero_bane" and RollPercentage(75) then
			self:GetCaster():EmitSound("bane_bane_ability_enfeeble_" .. string.format("%02d", RandomInt(1, 14)))
		end

		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_bane_enfeeble_723_effect", { duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()) })
	end
end

---------------------------------------------
-- MODIFIER_IMBA_BANE_ENFEEBLE_723_HANDLER --
---------------------------------------------

function modifier_imba_bane_enfeeble_723_handler:IsHidden() return true end

function modifier_imba_bane_enfeeble_723_handler:IsPurgable() return false end

function modifier_imba_bane_enfeeble_723_handler:RemoveOnDeath() return false end

function modifier_imba_bane_enfeeble_723_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_bane_enfeeble_723_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ABILITY_EXECUTED }
end

function modifier_imba_bane_enfeeble_723_handler:OnAbilityExecuted(keys)
	if keys.unit == self:GetParent() and not self:GetParent():PassivesDisabled() and (not keys.ability:IsItem() and not keys.ability:IsToggle()) and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and keys.ability ~= self:GetAbility() then
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_bane_enfeeble_723_effect", { duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()) })
	end
end

--------------------------------------------
-- MODIFIER_IMBA_BANE_ENFEEBLE_723_EFFECT --
--------------------------------------------

function modifier_imba_bane_enfeeble_723_effect:GetEffectName() return "particles/units/heroes/hero_bane/bane_enfeeble.vpcf" end

function modifier_imba_bane_enfeeble_723_effect:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_bane_enfeeble_723_effect:OnCreated()
	self.status_resistance_reduction                      = self:GetAbility():GetSpecialValueFor("status_resistance_reduction") * (-1)
	self.magic_resistance_reduction                       = self:GetAbility():GetSpecialValueFor("magic_resistance_reduction") * (-1)

	-- IMBAfication: Growing Discomfort
	self.discomfort_status_resistance_reduction_per_stack = self:GetAbility():GetSpecialValueFor("discomfort_status_resistance_reduction_per_stack") * (-1)
	self.discomfort_magic_resistance_reduction_per_stack  = self:GetAbility():GetSpecialValueFor("discomfort_magic_resistance_reduction_per_stack") * (-1)

	-- IMBAfication: The Terror Within
	self.terror_night_vision_reduction_per_stack          = self:GetAbility():GetSpecialValueFor("terror_night_vision_reduction_per_stack") * (-1)

	self.total_status_resistance_reduction                = self.status_resistance_reduction + self.discomfort_status_resistance_reduction_per_stack * self:GetStackCount()
	self.total_magic_resistance_reduction                 = self.magic_resistance_reduction + self.discomfort_magic_resistance_reduction_per_stack * self:GetStackCount()
	self.terror_night_vision_reduction                    = self.terror_night_vision_reduction_per_stack * self:GetStackCount()
end

function modifier_imba_bane_enfeeble_723_effect:OnRefresh()
	self:OnCreated()

	if not IsServer() then return end

	self:IncrementStackCount()
end

function modifier_imba_bane_enfeeble_723_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,

		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}
end

function modifier_imba_bane_enfeeble_723_effect:GetModifierStatusResistanceStacking()
	return self.total_status_resistance_reduction
end

function modifier_imba_bane_enfeeble_723_effect:GetModifierMagicalResistanceBonus()
	return self.total_magic_resistance_reduction
end

function modifier_imba_bane_enfeeble_723_effect:GetBonusNightVision()
	return self.terror_night_vision_reduction
end

--------------------------------------
---------    BRAIN SAP     -----------
--------------------------------------
LinkLuaModifier("modifier_imba_brain_sap_mana", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_brain_sap_baby_bane", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

-- Main Brain Sap casting
imba_bane_brain_sap = imba_bane_brain_sap or class({})

function imba_bane_brain_sap:GetCastPoint()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastPoint(self)
	else
		return self:GetSpecialValueFor("castpoint_scepter")
	end
end

-- Brain Sap Spell Cast
function imba_bane_brain_sap:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		local enfeeble_debuff = target:FindModifierByName("modifier_imba_enfeeble_debuff")

		-- Ability paramaters
		local sapdamage = self:GetSpecialValueFor("brain_sap_damage")
		local sapduration = self:GetSpecialValueFor("brain_sap_duration")
		local enfeeble_stack_to_damage = self:GetSpecialValueFor("enfeeble_stack_to_damage")
		local enfeeble_charges = 0

		if target:TriggerSpellAbsorb(self) then return end -- Spell block handler

		-- #5 TALENT: Brain Sap spawns a Baby bane that casts Fiend's Grip
		if caster:HasTalent("special_bonus_imba_bane_5") then
			local baby_fiends_grip_duration = caster:FindTalentValue("special_bonus_imba_bane_5", "duration")
			local baby_duration = baby_fiends_grip_duration + 1
			local baby_bane = CreateUnitByName("npc_imba_brain_sap_baby_bane", caster:GetAbsOrigin() + RandomVector(100), true, caster, caster, caster:GetTeam())
			baby_bane:AddNewModifier(caster, nil, "modifier_imba_brain_sap_baby_bane", { duration = baby_duration })

			-- Apply (a weaker) Fiend's grip
			target:AddNewModifier(caster, self, "modifier_imba_fiends_grip_handler", { duration = baby_fiends_grip_duration, propogated = 1, original_target = 1, baby = true })

			-- Make the baby look towards the target
			local direction = (target:GetAbsOrigin() - baby_bane:GetAbsOrigin()):Normalized()
			baby_bane:SetForwardVector(direction)
		end

		-- Consume enfeeble charges
		if enfeeble_debuff then
			-- Increase damage
			enfeeble_charges = target:GetModifierStackCount("modifier_imba_enfeeble_debuff", caster)
			-- Remove stacks
			for k, v in pairs(enfeeble_debuff.stacks_table) do
				enfeeble_debuff.stacks_table[k] = nil
			end
			enfeeble_debuff:SetStackCount(0)
		end

		local enfeeble_bonus_damage = enfeeble_stack_to_damage * enfeeble_charges
		-- Deal damage
		damage_table = {
			victim      = target,
			attacker    = caster,
			damage      = sapdamage + enfeeble_bonus_damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability     = self
		}

		ApplyDamage(damage_table)
		-- Heal caster
		caster:Heal(sapdamage, caster)

		-- Apply brain sap debuff
		target:AddNewModifier(caster, self, "modifier_imba_brain_sap_mana", { duration = sapduration * (1 - target:GetStatusResistance()) })

		-- Emit brain sap particle
		local sapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(sapFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(sapFX, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(sapFX)

		-- Emit brain sap sound
		EmitSoundOn("Hero_Bane.BrainSap", caster)
		EmitSoundOn("Hero_Bane.BrainSap.Target", target) -- slslslllslslsllrprpp
		if RollPercentage(75) then
			EmitSoundOn("bane_bane_ability_brainsap_" .. string.format("%02d", RandomInt(1, 6)), self:GetCaster())
		end
	end
end

-- Scepter cooldown reduction
function imba_bane_brain_sap:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_bane_brain_sap:CastFilterResultTarget(target)
	if self:GetCaster():HasScepter() and self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() and target:IsMagicImmune() then
		return UF_SUCCESS
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
end

function imba_bane_brain_sap:GetAbilityTextureName()
	return "bane_brain_sap"
end

-- Brain_sap Debuff
modifier_imba_brain_sap_mana = modifier_imba_brain_sap_mana or class({})

function modifier_imba_brain_sap_mana:IsDebuff() return true end

function modifier_imba_brain_sap_mana:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_brain_sap_mana:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsHero() then
			self.int_loss = -(parent:GetIntellect())
		end

		self.previous_mana = parent:GetMana()

		-- Set mana to 0
		parent:SetMana(0)
	end
end

function modifier_imba_brain_sap_mana:GetModifierBonusStats_Intellect()
	return self.int_loss
end

function modifier_imba_brain_sap_mana:OnDestroy()
	if IsServer() then
		-- Return the lost mana at the end of the duration
		self:GetParent():SetMana(self.previous_mana)
	end
end

-- #5 TALENT: baby Bane modifier
modifier_imba_brain_sap_baby_bane = modifier_imba_brain_sap_baby_bane or class({})

function modifier_imba_brain_sap_baby_bane:OnCreated()
	if IsServer() then
		-- Give the baby bane body parts because we are evil men who won't let the baby grow naturally
		local baby_bane = self:GetParent()
		local fiends_grip_duration = self:GetCaster():FindTalentValue("special_bonus_imba_bane_5", "duration")

		-- Create attachments
		local head = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/bane/bane_head.vmdl" })
		local shoulders = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/bane/bane_shoulders.vmdl" })

		-- Attach
		head:FollowEntity(baby_bane, true)
		shoulders:FollowEntity(baby_bane, true)

		-- Force the baby bane to do our Fiend's Grip biddings
		baby_bane:StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

		-- Stop gesture when Fiend's Grip is done
		Timers:CreateTimer(fiends_grip_duration, function()
			baby_bane:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)
		end)
	end
end

function modifier_imba_brain_sap_baby_bane:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

function modifier_imba_brain_sap_baby_bane:OnDestroy()
	if IsServer() then
		-- Kill the baby
		local parent = self:GetParent()
		parent:ForceKill(false)
	end
end

-----------------------------
-- IMBA_BANE_BRAIN_SAP_723 --
-----------------------------

function imba_bane_brain_sap_723:GetCastPoint()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastPoint(self)
	else
		return self:GetSpecialValueFor("castpoint_scepter")
	end
end

function imba_bane_brain_sap_723:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_bane_brain_sap_723:CastFilterResultTarget(target)
	if not self:GetCaster():HasScepter() then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	end
end

function imba_bane_brain_sap_723:OnSpellStart()
	local target = self:GetCursorTarget()

	if not target:TriggerSpellAbsorb(self) then
		self:GetCaster():EmitSound("Hero_Bane.BrainSap")
		target:EmitSound("Hero_Bane.BrainSap.Target")

		if self:GetCaster():GetName() == "npc_dota_hero_bane" and RollPercentage(75) then
			self:GetCaster():EmitSound("bane_bane_ability_brainsap_" .. string.format("%02d", RandomInt(1, 6)))
		end

		local sap_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(sap_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(sap_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(sap_particle)

		local damage_heal = ApplyDamage({
			victim      = target,
			attacker    = self:GetCaster(),
			damage      = self:GetTalentSpecialValueFor("brain_sap_damage"),
			damage_type = self:GetAbilityDamageType(),
			ability     = self
		})

		self:GetCaster():Heal(damage_heal, self:GetCaster())

		-- IMBAfication: Addlebrain
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_brain_sap_mana", { duration = self:GetSpecialValueFor("addlebrain_duration") * (1 - target:GetStatusResistance()) })
	end
end

--------------------------------------
---------    NIGHTMARE     -----------
--------------------------------------

LinkLuaModifier("modifier_imba_nightmare_dot", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nightmare_invul", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nightmare_vision", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nightmare_talent", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

-- Main Nightmare casting
imba_bane_nightmare = imba_bane_nightmare or class({})

function imba_bane_nightmare:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

-- Nightmare Spell Cast
function imba_bane_nightmare:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Ability paramaters
		local invulnduration = self:GetSpecialValueFor("nightmare_invuln_duration")
		local nightmareduration = self:GetSpecialValueFor("nightmare_duration")
		local talentinvulnbonus = caster:FindTalentValue("special_bonus_imba_bane_7")

		if target:TriggerSpellAbsorb(self) then return end --Spell block handler

		-- #7 TALENT: increased nightmare invulnerability duration
		if caster:GetTeamNumber() == target:GetTeamNumber() then
			invulnduration = invulnduration + talentinvulnbonus
		end

		-- #1 TALENT: nightmare applies enfeeble stacks on enemies
		local talent_enfeeble_stacks = caster:FindTalentValue("special_bonus_imba_bane_1")
		local enfeeble = caster:FindAbilityByName("imba_bane_enfeeble")

		local enfeeble_duration = 0

		if enfeeble then
			enfeeble_duration = enfeeble:GetSpecialValueFor("enfeeble_duration")
		end

		if caster:GetTeamNumber() ~= target:GetTeamNumber() and caster:HasTalent("special_bonus_imba_bane_1") then
			for i = 1, talent_enfeeble_stacks do
				target:AddNewModifier(caster, enfeeble, "modifier_imba_enfeeble_debuff", { duration = enfeeble_duration * (1 - target:GetStatusResistance()) })
			end
		end

		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			nightmareduration = nightmareduration * (1 - target:GetStatusResistance())
			invulnduration    = invulnduration * (1 - target:GetStatusResistance())
		end

		-- Apply Nightmare modifiers
		target:AddNewModifier(caster, self, "modifier_imba_nightmare_dot", { duration = nightmareduration })
		target:AddNewModifier(caster, self, "modifier_imba_nightmare_invul", { duration = invulnduration })
		-- Emit Nightmare sound effect
		EmitSoundOn("hero_bane.nightmare", target)
		if caster ~= target then
			EmitSoundOn("bane_bane_ability_nightmare_" .. string.format("%02d", RandomInt(1, 3)), self:GetCaster())
		end
	end
end

function imba_bane_nightmare:OnUpgrade()
	local caster = self:GetCaster()

	-- When you level up nightmare while it is active, don't level up nightmare end (cuz that's a bad idea)
	if caster:HasAbility("imba_bane_nightmare_end") and caster:FindAbilityByName("imba_bane_nightmare_end"):GetLevel() ~= 1 then
		caster:FindAbilityByName("imba_bane_nightmare_end"):SetLevel(1)
	end
end

function imba_bane_nightmare:GetAssociatedSecondaryAbilities()
	return "imba_bane_nightmare_end"
end

function imba_bane_nightmare:GetAbilityTextureName()
	return "bane_nightmare"
end

-- Nightmare's sub ability (Nightmare end)
imba_bane_nightmare_end = imba_bane_nightmare_end or class({})

-- End Nightmares
function imba_bane_nightmare_end:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		-- Emit nightmare end sound effect
		EmitSoundOn("Hero_Bane.Nightmare.End", caster)

		-- Find ALL heroes nightmared
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			FIND_UNITS_EVERYWHERE, -- Global
			DOTA_UNIT_TARGET_TEAM_BOTH,
			DOTA_UNIT_TARGET_ALL,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
			FIND_ANY_ORDER,
			false)

		-- Stop all of the Nightmare modifiers
		for _, unit in pairs(units) do
			if unit:HasModifier("modifier_imba_nightmare_invul") then -- We can't debuff an immune target! So remove this first
				unit:RemoveModifierByName("modifier_imba_nightmare_invul")
			end
			if unit:HasModifier("modifier_imba_nightmare_dot") then
				unit:RemoveModifierByName("modifier_imba_nightmare_dot")
			end
		end
	end
end

function imba_bane_nightmare_end:ProcsMagicStick() return false end

function imba_bane_nightmare_end:GetAssociatedPrimaryAbilities()
	return "imba_bane_nightmare"
end

function imba_bane_nightmare_end:GetAbilityTextureName()
	return "bane_nightmare_end"
end

-- Nightmare Debuff
modifier_imba_nightmare_dot = modifier_imba_nightmare_dot or class({})

function modifier_imba_nightmare_dot:IsDebuff() return true end

function modifier_imba_nightmare_dot:IsNightmared() return true end

function modifier_imba_nightmare_dot:IsPurgable() return true end

function modifier_imba_nightmare_dot:GetBonusVisionPercentage() return -100 end

function modifier_imba_nightmare_dot:GetEffectName() return "particles/units/heroes/hero_bane/bane_nightmare.vpcf" end

function modifier_imba_nightmare_dot:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_nightmare_dot:GetOverrideAnimation() return ACT_DOTA_FLAIL end

function modifier_imba_nightmare_dot:GetOverrideAnimationRate() return 0.2 end

function modifier_imba_nightmare_dot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,

		-- IMBAfication: Unpleasantries
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_imba_nightmare_dot:OnCreated()
	-- Remove vision
	self:GetBonusVisionPercentage()

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end
end

function modifier_imba_nightmare_dot:CheckState()
	return {
		[MODIFIER_STATE_NIGHTMARED]          = true,
		[MODIFIER_STATE_STUNNED]             = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE]  = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true
	}
end

function modifier_imba_nightmare_dot:OnTakeDamage(t)
	if IsServer() then
		-- Stop Nightmare when hit (by anything other than an auto attack)
		if t.unit == self:GetParent() and t.attacker ~= self:GetCaster() and not t.attacker:IsBuilding() and t.attacker:GetOwnerEntity() then
			self:Destroy()
		end
	end
end

function modifier_imba_nightmare_dot:OnAttackStart(t)
	if IsServer() then
		-- Ability properties
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		-- Ability paramaters
		local nightmare_duration = ability:GetSpecialValueFor("nightmare_duration")
		local nightmare_invuln_duration = ability:GetSpecialValueFor("nightmare_invuln_duration")

		-- Redirect Nightmare to auto-attackers
		-- IMBAfication: Sound Sleeper
		if t.target == self:GetParent() and t.attacker ~= self:GetCaster() and not t.attacker:IsBuilding() and t.attacker:GetOwnerEntity() then
			-- --Don't Nightmare buildings lul
			-- if t.attacker:IsBuilding() then
			-- return nil
			-- end

			if t.attacker:GetTeamNumber() ~= caster:GetTeamNumber() then
				nightmare_duration        = nightmare_duration * (1 - t.attacker:GetStatusResistance())
				nightmare_invuln_duration = nightmare_invuln_duration * (1 - t.attacker:GetStatusResistance())
			end

			-- Apply Nightmare debuff to attackers
			t.attacker:AddNewModifier(caster, ability, "modifier_imba_nightmare_dot", { duration = nightmare_duration })
			t.attacker:AddNewModifier(caster, ability, "modifier_imba_nightmare_invul", { duration = nightmare_invuln_duration })

			self:Destroy()
		end
	end
end

function modifier_imba_nightmare_dot:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local parent = self:GetParent()
		-- Ability paramaters
		local CurHP = parent:GetHealth()
		local nightmare_damage = ability:GetSpecialValueFor("nightmare_damage")

		-- If the target dies then:
		if (CurHP <= nightmare_damage) then
			local damage = {
				victim      = parent,
				attacker    = caster,
				damage      = nightmare_damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability     = ability
			}
			-- Frag target with pure damage, give kill credit to Bane.
			ApplyDamage(damage)
		else
			-- Deal damage
			self:GetParent():SetHealth(CurHP - nightmare_damage)
		end
		-- Emit Nightmare affected sound effect
		EmitSoundOn("Hero_Bane.Nightmare.Loop", target)
	end
end

function modifier_imba_nightmare_dot:OnDestroy()
	if IsServer() then
		-- Ability properties
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local parent = self:GetParent()
		-- Ability paramaters
		local nightmare_baleful_visions_duration = ability:GetSpecialValueFor("nightmare_baleful_visions_duration")

		-- Check if the nightmare'd is an enemy
		if caster:GetTeamNumber() ~= parent:GetTeamNumber() then
			if not parent:IsMagicImmune() then
				-- Apply vision debuff
				parent:AddNewModifier(caster, ability, "modifier_imba_nightmare_vision", { duration = nightmare_baleful_visions_duration })

				-- #6 TALENT: Nightmare applies a mute
				if caster:HasTalent("special_bonus_imba_bane_6") then
					parent:AddNewModifier(caster, ability, "modifier_imba_nightmare_talent", { duration = caster:FindTalentValue("special_bonus_imba_bane_6") })
				end
			end
		end
		-- If we don't do this, clever players will only skill one point in nightmare and take the 6sec invuln talent which will make you invulnerable while not stunned
		if parent:HasModifier("modifier_imba_nightmare_invul") then
			parent:RemoveModifierByName("modifier_imba_nightmare_invul")
		end
		-- Emit Nightmare end sound effect
		EmitSoundOn("Hero_Bane.Nightmare.End", self:GetParent())
	end
end

function modifier_imba_nightmare_dot:GetDisableHealing()
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return 1
	end
end

-- Nightmare Invulnerability
modifier_imba_nightmare_invul = modifier_imba_nightmare_invul or class({})

function modifier_imba_nightmare_invul:IsDebuff() return true end

function modifier_imba_nightmare_invul:IsHidden() return true end

function modifier_imba_nightmare_invul:DeclareFunctions()
	return {
		MODIFIER_STATE_INVULNERABLE,
		MODIFIER_STATE_NO_HEALTH_BAR
	}
end

function modifier_imba_nightmare_invul:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

-- Nightmare Baneful Visions
modifier_imba_nightmare_vision = modifier_imba_nightmare_vision or class({})

function modifier_imba_nightmare_vision:GetBonusVisionPercentage() return -100 end

function modifier_imba_nightmare_vision:DeclareFunctions()
	return { MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE }
end

modifier_imba_nightmare_talent = modifier_imba_nightmare_talent or class({})

function modifier_imba_nightmare_talent:CheckState()
	return {
		[MODIFIER_STATE_MUTED] = true
	}
end

function modifier_imba_nightmare_talent:IsHidden() return false end

function modifier_imba_nightmare_talent:IsDebuff() return true end

function modifier_imba_nightmare_talent:IsPurgable() return true end

--------------------------------------
-----       FIEND'S GRIP         -----
--------------------------------------
LinkLuaModifier("modifier_imba_fiends_grip_handler", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiends_grip_demon", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiends_grip_talent", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

imba_bane_fiends_grip = imba_bane_fiends_grip or class({})

function imba_bane_fiends_grip:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

-- Fiends Grip Spell Cast
function imba_bane_fiends_grip:OnSpellStart()
	if IsServer() then
		-- Ability properties
		self.fiendtarget, self.fiendcaster = findtarget(self)

		-- Ability paramaters
		local fiends_grip_duration = self:GetSpecialValueFor("fiends_grip_duration")

		if self.fiendtarget:TriggerSpellAbsorb(self) then
			self.fiendcaster:Interrupt()
			return
		end                                                                                 -- Spell absorb handler

		-- Create table to store all fiendgrip victims, with no talent it's always 1
		self.fiendgriptable = {} -- set table to blank when skill is invoked to avoid weird shit
		-- we append fiendcaster and fiendtarget into class values for use later in cases of channel interruption or spell reflection to avoid conflicts
		table.insert(self.fiendgriptable, self.fiendtarget)
		self.fiendtarget:Interrupt()

		--Apply Fiend's Grip
		self.fiendtarget:AddNewModifier(self.fiendcaster,
			self,
			"modifier_imba_fiends_grip_handler",
			{
				duration = fiends_grip_duration,
				propogated = 0,
				original_target = 1
			})            -- we are the original target, it has not spread


		-- #3 TALENT: Create modifier to check for #8 talent and to interrupt when disabled
		if self.fiendcaster:HasTalent("special_bonus_imba_bane_3") then
			self.fiendcaster:AddNewModifier(self.fiendcaster,
				self,
				"modifier_imba_fiends_grip_talent",
				{} -- Lasts until destroyed manually
			)
		end
		-- Emit Fiend's Grip sound
		EmitSoundOn("Hero_Bane.FiendsGrip.Cast", self.fiendcaster)
		EmitSoundOn("hero_bane.fiends_grip", self.fiendtarget)
		EmitSoundOn("hero_bane.fiends_grip", self.fiendcaster)
		EmitSoundOn("bane_bane_ability_fiendsgrip_" .. string.format("%02d", RandomInt(1, 7)), self:GetCaster())
	end
end

-- When channel is finished or interrupted iterate through table and destroy original modifier. Destroy will trigger OnDestroy() for the modifier, and determine eligibility for propogation <--- dafaq is propogation?
function imba_bane_fiends_grip:OnChannelFinish(bInterrupted)
	if IsServer() then
		if not self.fiendgriptable then return end
		for k, v in pairs(self.fiendgriptable) do
			-- Doing it this way prevents a runtime error in case some not accounted for situations occur.
			if ((self.fiendgriptable[k]:HasModifier("modifier_imba_fiends_grip_handler")) and self.fiendgriptable[k]:FindModifierByName("modifier_imba_fiends_grip_handler").propogated == 0) then
				self.fiendgriptable[k]:FindModifierByName("modifier_imba_fiends_grip_handler"):Destroy() -- if our target has been gripped, and it has not been spread by itself, destroy it (which will reinvoke and set propogated to 1)
			end
		end

		StopSoundOn("Hero_Bane.FiendsGrip.Cast", self.fiendcaster)
	end
end

-- We only care about channel operations when he has the lv40 talent			-- Seinken definitely didn't write this block :nofun:
function imba_bane_fiends_grip:OnChannelThink()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasTalent("special_bonus_imba_bane_8") then
			-- Parameters
			local vision_radius = self:GetTalentSpecialValueFor("talent_vision_radius")
			local vision_cone = self:GetTalentSpecialValueFor("talent_vision_cone")
			local fiends_grip_duration = self:GetTalentSpecialValueFor("fiends_grip_duration")
			local caster_location = caster:GetAbsOrigin()

			-- Iterate through nearby enemies
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do
				-- If this enemy is already Gripped, do nothing
				if not enemy:HasModifier("modifier_imba_fiends_grip_handler") then
					local enemy_location = enemy:GetAbsOrigin()
					local enemy_to_caster_direction = (caster_location - enemy_location):Normalized()
					local enemy_forward_vector = enemy:GetForwardVector()

					-- This is the angle between the enemy's forward vector and the line between them and the caster
					local view_angle = math.abs(RotationDelta(VectorToAngles(enemy_to_caster_direction), VectorToAngles(enemy_forward_vector)).y)

					-- If the angle is inside the vision cone, and the channeling caster can be seen by the enemy team, GET GRIPPED NOOB
					if view_angle <= (vision_cone / 2) and enemy:CanEntityBeSeenByMyTeam(caster) then
						enemy:AddNewModifier(caster, self, "modifier_imba_fiends_grip_handler", { duration = fiends_grip_duration - (GameRules:GetGameTime() - self:GetChannelStartTime()), propogated = 0 })
						table.insert(self.fiendgriptable, enemy)
					end
				end
			end
		end
	end
end

-- #3 TALENT: Fiend's Grip is no longer channeled
function imba_bane_fiends_grip:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasTalent("special_bonus_imba_bane_3") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end

-- #3 TALENT: There is no channel time
function imba_bane_fiends_grip:GetChannelTime()
	if not self:GetCaster():HasTalent("special_bonus_imba_bane_3") then
		return (self:GetSpecialValueFor("fiends_grip_duration"))
	else
		return 0
	end
end

function imba_bane_fiends_grip:GetCooldown(nLevel)
	local talentcooldownbonus = self:GetCaster():FindTalentValue("special_bonus_imba_bane_8")
	return self.BaseClass.GetCooldown(self, nLevel) - talentcooldownbonus
end

function imba_bane_fiends_grip:GetChannelAnimation()
	return
		ACT_DOTA_CHANNEL_ABILITY_4 or ACT_DOTA_CHANNEL_ABILITY_5
end

function imba_bane_fiends_grip:GetAbilityTextureName()
	return "bane_fiends_grip"
end

-- Fiends Grip Debuff
modifier_imba_fiends_grip_handler = modifier_imba_fiends_grip_handler or class({})

function modifier_imba_fiends_grip_handler:IsDebuff() return true end

function modifier_imba_fiends_grip_handler:IsStunDebuff() return true end

function modifier_imba_fiends_grip_handler:IsPurgableException() return true end

function modifier_imba_fiends_grip_handler:GetEffectName() return "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf" end

function modifier_imba_fiends_grip_handler:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_fiends_grip_handler:GetOverrideAnimation() return ACT_DOTA_FLAIL end

function modifier_imba_fiends_grip_handler:IgnoreTenacity() return true end

function modifier_imba_fiends_grip_handler:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_fiends_grip_handler:OnCreated(var)
	if IsServer() then
		parent = self:GetParent()
		local caster = self:GetCaster()
		parent:Interrupt()
		parent:StartGesture(ACT_DOTA_FLAIL) -- Flail em
		if var.propogated == 0 then
			parent.grip_link_particle_table = {} -- Particle table for the life drain particles
		end
		self.baby = var.baby
		self:OnIntervalThink()               -- Invoke a damage instance, once
		self:StartIntervalThink(1)           -- Begin damage instances, 1 second interval
		self.propogated = var.propogated     -- attribute defining a 'spread' grip
		self.original_target = var.original_target -- Original target for interrupt purposes
		-- #5 TALENT: Check if the baby cast this
	end
end

function modifier_imba_fiends_grip_handler:OnRefresh(var)
	if IsServer() then
		local caster = self:GetCaster()
		parent:Interrupt()
		self.baby = var.baby
		self:GetParent():Interrupt()
		self:OnIntervalThink()
		self:StartIntervalThink(1)
		self.propogated = var.propogated
		self.original_target = var.original_target
		-- #5 TALENT: Check if the baby cast this
	end
end

function modifier_imba_fiends_grip_handler:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local enfeeble_debuff = parent:FindModifierByName("modifier_imba_enfeeble_debuff")
		local drain_particle = "particles/hero/bane/bane_fiends_grip_tether.vpcf"

		-- Ability paramaters
		local fiends_grip_mana_damage = ability:GetSpecialValueFor("fiends_grip_mana_damage")
		local fiends_grip_damage = ability:GetSpecialValueFor("fiends_grip_damage")
		local demon_damage = ability:GetSpecialValueFor("demon_damage")
		local demon_mana_drain = ability:GetSpecialValueFor("demon_mana_drain")

		-- #5 TALENT: Baby Fiend's Grip does reduced damage
		local baby_multiplier = 1
		if self.baby then
			baby_multiplier = caster:FindTalentValue("special_bonus_imba_bane_5", "dmg_mana_pct") / 100
		end

		-- Consume enfeeble charge
		if enfeeble_debuff and not self.baby then
			local stacks_table = enfeeble_debuff.stacks_table
			if #stacks_table > 0 then
				-- Remove enfeeble stack
				stacks_table[#stacks_table] = nil
				enfeeble_debuff:DecrementStackCount()

				-- Spawn daemon
				local demon = CreateUnitByName("npc_imba_fiends_grip_demon", caster:GetAbsOrigin() + RandomVector(100), true, caster, caster, caster:GetTeam())
				demon:AddNewModifier(caster, nil, "modifier_imba_fiends_grip_demon", {})
				demon:SetRenderColor(75, 0, 130)
				-- Apply link particle
				parent.grip_link_particle_table[#parent.grip_link_particle_table + 1] = ParticleManager:CreateParticle(drain_particle, PATTACH_ABSORIGIN, demon) -- Create a seperate link particle for each demon
				local particle = parent.grip_link_particle_table[#parent.grip_link_particle_table]
				ParticleManager:SetParticleControlEnt(particle, 0, demon, PATTACH_POINT_FOLLOW, "attach_hitloc", demon:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			end

			-- Multiply bonus damage by how many demons there are
			self.total_demon_damage = demon_damage * #parent.grip_link_particle_table
			self.total_demon_mana_drain = demon_mana_drain * #parent.grip_link_particle_table
		else
			self.total_demon_damage, self.total_demon_mana_drain = 0, 0
		end

		-- Drain mana
		local mana_drained = math.min(parent:GetMaxMana() * (fiends_grip_mana_damage + self.total_demon_mana_drain) / 100, parent:GetMana())
		parent:ReduceMana((parent:GetMaxMana() * (fiends_grip_mana_damage + self.total_demon_mana_drain) / 100) * baby_multiplier)
		caster:GiveMana(mana_drained)

		-- Deal damage
		local damage = {
			victim      = self:GetParent(),
			attacker    = self:GetCaster(),
			damage      = (fiends_grip_damage + self.total_demon_damage) * baby_multiplier,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability     = self:GetAbility()
		}
		if not self:GetParent():IsMagicImmune() then
			ApplyDamage(damage)
		end
	end
end

function modifier_imba_fiends_grip_handler:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_fiends_grip_handler:OnDestroy()
	if IsServer() then
		-- Ability properties
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local fiends_grip_linger_duration = ability:GetSpecialValueFor("fiends_grip_linger_duration")
		local talent_3 = caster:FindModifierByName("modifier_imba_fiends_grip_talent")

		-- Remove #3 talent modifier
		if talent_3 then
			talent_3:Destroy()
		end

		StopSoundOn("Hero_Bane.FiendsGrip.Cast", ability.fiendcaster)

		parent:FadeGesture(ACT_DOTA_FLAIL)                    -- Fade the gesture, even though it can be immeditaely reinvoked if it's not been spread
		if not parent:IsMagicImmune() and self.propogated == 0 then -- Are we magic immune somehow(omniknight)? have we already retriggered once?
			if self.original_target == 1 then                 -- If we are the original target and it's NOT spread, we need to interrupt the primary caster (typically Bane)
				parent:InterruptChannel()
			end

			parent:AddNewModifier(caster, ability, "modifier_imba_fiends_grip_handler", { duration = fiends_grip_linger_duration * (1 - parent:GetStatusResistance()), propogated = 1 })
		end

		if not self.baby then
			-- If the fiends grip is not gonna continue at all (is propogated or target is magic immune or target died) then
			if parent:IsMagicImmune() or self.propogated == 1 or not parent:IsAlive() then
				-- Kill the drain particle
				for i = 1, #parent.grip_link_particle_table do
					ParticleManager:DestroyParticle(parent.grip_link_particle_table[i], false)
					ParticleManager:ReleaseParticleIndex(parent.grip_link_particle_table[i])
				end

				-- Kill the demons
				local creatures = FindUnitsInRadius(caster:GetTeamNumber(),
					caster:GetAbsOrigin(),
					nil,
					FIND_UNITS_EVERYWHERE, --global
					DOTA_UNIT_TARGET_TEAM_FRIENDLY,
					DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
					FIND_ANY_ORDER,
					false)

				-- Iterate between all demons to make sure all of them are dead
				for _, creature in pairs(creatures) do                                                                      -- check each friendly creep
					if creature:GetUnitName() == "npc_imba_fiends_grip_demon" and creature:GetPlayerOwnerID() == caster:GetPlayerID() then -- If it's your demon, kill it
						creature:ForceKill(false)
					end
				end
			end
		end

		-- Stop channeling if the modifier doesn't exist anymore early (aka from dispels)
		if ability:IsChanneling() and parent == ability:GetCursorTarget() then
			caster:Interrupt()
		end
	end
end

-- #3 TALENT: check for interruptions and #8 talent modifier
modifier_imba_fiends_grip_talent = modifier_imba_fiends_grip_talent or class({})

function modifier_imba_fiends_grip_talent:IsDebuff() return false end

function modifier_imba_fiends_grip_talent:IsHidden()
	if self:GetCaster():HasTalent("special_bonus_imba_bane_8") then
		return false
	else
		return true
	end
end

function modifier_imba_fiends_grip_talent:IsPurgable() return false end

function modifier_imba_fiends_grip_talent:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		-- Start animation
		caster:StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

		-- Start checking
		self:StartIntervalThink(0.2)
	end
end

--#3 TALENT: Fiend's Grip needs to check for enemies even when not channeling
function modifier_imba_fiends_grip_talent:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		-- #8 TALENT: Fiends Grip applies Fiends Grip on enemies that look at bane
		if caster:HasTalent("special_bonus_imba_bane_8") then
			-- Parameters
			local vision_radius = ability:GetTalentSpecialValueFor("talent_vision_radius")
			local vision_cone = ability:GetTalentSpecialValueFor("talent_vision_cone")
			local fiends_grip_duration = ability:GetTalentSpecialValueFor("fiends_grip_duration")
			local caster_location = caster:GetAbsOrigin()

			-- Iterate through nearby enemies
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do
				-- If this enemy is already Gripped, do nothing
				if not enemy:HasModifier("modifier_imba_fiends_grip_handler") then
					local enemy_location = enemy:GetAbsOrigin()
					local enemy_to_caster_direction = (caster_location - enemy_location):Normalized()
					local enemy_forward_vector = enemy:GetForwardVector()

					-- This is the angle between the enemy's forward vector and the line between them and the caster
					local view_angle = math.abs(RotationDelta(VectorToAngles(enemy_to_caster_direction), VectorToAngles(enemy_forward_vector)).y)

					-- If the angle is inside the vision cone, and the channeling caster can be seen by the enemy team, GET GRIPPED NOOB
					if view_angle <= (vision_cone / 2) and enemy:CanEntityBeSeenByMyTeam(caster) then
						enemy:AddNewModifier(caster, ability, "modifier_imba_fiends_grip_handler", { duration = fiends_grip_duration - (GameRules:GetGameTime() - self:GetCreationTime()), propogated = 0 })
						table.insert(ability.fiendgriptable, enemy)
					end
				end
			end
		end
	end
end

function modifier_imba_fiends_grip_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}
end

function modifier_imba_fiends_grip_talent:OnStateChanged(keys)
	-- Ability properties
	local unit = keys.unit
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	-- Only apply if the unit is the caster himself
	-- Interrupt Fiend's Grip if caster is disabled
	if unit == caster and (caster:IsStunned() or caster:IsSilenced()) then
		for num = 1, #ability.fiendgriptable do
			if ability.fiendgriptable[num] and ability.fiendgriptable[num].HasModifier and ability.fiendgriptable[num]:HasModifier("modifier_imba_fiends_grip_handler") and ability.fiendgriptable[num]:FindModifierByName("modifier_imba_fiends_grip_handler").propogated == 0 then -- Only do this if this is the first Grip cast
				ability.fiendgriptable[num]:FindModifierByName("modifier_imba_fiends_grip_handler"):Destroy()
			end
		end
	end
end

function modifier_imba_fiends_grip_talent:GetModifierProvidesFOWVision() return 1 end

function modifier_imba_fiends_grip_talent:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		-- Stop animation
		caster:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)
	end
end

-- Demon modifier
modifier_imba_fiends_grip_demon = modifier_imba_fiends_grip_demon or class({})

function modifier_imba_fiends_grip_demon:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end

-------------------------------
-- IMBA_BANE_FIENDS_GRIP_723 --
-------------------------------

function imba_bane_fiends_grip_723:GetIntrinsicModifierName()
	return "modifier_imba_bane_fiends_grip_723_handler"
end

function imba_bane_fiends_grip_723:GetBehavior()
	if not self:GetCaster():HasTalent("special_bonus_imba_bane_3") then
		return self.BaseClass.GetBehavior(self)
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
end

function imba_bane_fiends_grip_723:GetChannelTime()
	if not self:GetCaster():HasTalent("special_bonus_imba_bane_3") then
		return self:GetCaster():GetModifierStackCount("modifier_imba_bane_fiends_grip_723_handler", self:GetCaster()) / 100
	else
		return 0
	end
end

function imba_bane_fiends_grip_723:OnSpellStart()
	self.target = self:GetCursorTarget()

	if not self.target:TriggerSpellAbsorb(self) then
		if self:GetCaster():GetName() == "npc_dota_hero_bane" then
			self:GetCaster():EmitSound("bane_bane_ability_fiendsgrip_" .. string.format("%02d", RandomInt(1, 7)))
		end

		if not self:GetCaster():HasTalent("special_bonus_imba_bane_3") then
			self.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_bane_fiends_grip_723", { duration = self:GetChannelTime() })
		else
			self.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_bane_fiends_grip_723", { duration = (self.BaseClass.GetChannelTime(self) + self:GetCaster():FindTalentValue("special_bonus_imba_bane_fiends_grip_duration")) * (1 - self.target:GetStatusResistance()) })
		end
	else
		self:GetCaster():Interrupt()
	end
end

function imba_bane_fiends_grip_723:OnChannelFinish(bInterrupted)
	if self.target and not self.target:IsNull() and self.target:FindModifierByNameAndCaster("modifier_imba_bane_fiends_grip_723", self:GetCaster()) then
		self.target:FindModifierByNameAndCaster("modifier_imba_bane_fiends_grip_723", self:GetCaster()):Destroy()
	end
end

------------------------------------------------
-- MODIFIER_IMBA_BANE_FIENDS_GRIP_723_HANDLER --
------------------------------------------------

function modifier_imba_bane_fiends_grip_723_handler:IsHidden() return true end

function modifier_imba_bane_fiends_grip_723_handler:IsPurgable() return false end

function modifier_imba_bane_fiends_grip_723_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_bane_fiends_grip_723_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

-- Going to use this hacky method to determine channel time on UI
-- During the brief time before the ability actually casts, record the target's status resistance * 100 into its intrinsic modifier, then use that divided by 100 as the channel time
function modifier_imba_bane_fiends_grip_723_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end

	if keys.ability == self:GetAbility() and keys.target then
		if keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			self:SetStackCount(((self:GetAbility().BaseClass.GetChannelTime(self:GetAbility()) + self:GetCaster():FindTalentValue("special_bonus_imba_bane_fiends_grip_duration")) * (1 - keys.target:GetStatusResistance())) * 100)
		else
			self:SetStackCount((self:GetAbility().BaseClass.GetChannelTime(self:GetAbility()) + self:GetCaster():FindTalentValue("special_bonus_imba_bane_fiends_grip_duration")) * 100)
		end
	else
		self:SetStackCount((self:GetAbility().BaseClass.GetChannelTime(self:GetAbility()) + self:GetCaster():FindTalentValue("special_bonus_imba_bane_fiends_grip_duration")) * 100)
	end
end

----------------------------------------
-- MODIFIER_IMBA_BANE_FIENDS_GRIP_723 --
----------------------------------------

function modifier_imba_bane_fiends_grip_723:IgnoreTenacity() return true end

function modifier_imba_bane_fiends_grip_723:GetEffectName() return "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf" end

function modifier_imba_bane_fiends_grip_723:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_bane_fiends_grip_723:OnCreated()
	self.fiend_grip_mana_drain = self:GetAbility():GetSpecialValueFor("fiend_grip_mana_drain")
	self.fiend_grip_damage     = self:GetAbility():GetSpecialValueFor("fiend_grip_damage")

	if not IsServer() then return end

	self.fiend_grip_tick_interval = self:GetAbility():GetSpecialValueFor("fiend_grip_tick_interval") * (1 - self:GetParent():GetStatusResistance())
	self.mana_drain_per_tick      = self.fiend_grip_mana_drain * self.fiend_grip_tick_interval
	self.damage_per_tick          = self.fiend_grip_damage * self.fiend_grip_tick_interval

	self.damage_table             = {
		victim      = self:GetParent(),
		attacker    = self:GetCaster(),
		damage      = self.damage_per_tick,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability     = self:GetAbility()
	}

	self:GetCaster():EmitSound("Hero_Bane.FiendsGrip.Cast")
	self:GetParent():EmitSound("Hero_Bane.Fiends_Grip")

	self:GetCaster():StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)

	self:StartIntervalThink(self.fiend_grip_tick_interval)
end

function modifier_imba_bane_fiends_grip_723:OnIntervalThink()
	-- "Applies the damage first on each tick, and then the mana loss."
	ApplyDamage(self.damage_table)

	self.mana_drained = math.min(self:GetParent():GetMaxMana() * self.mana_drain_per_tick / 100, self:GetParent():GetMana())
	self:GetParent():ReduceMana(self.mana_drained)
	self:GetCaster():GiveMana(self.mana_drained)

	-- IMBAfication: Neverending Suffering
	if self:GetParent():HasModifier("modifier_imba_bane_enfeeble_723_effect") then
		self:GetParent():FindModifierByName("modifier_imba_bane_enfeeble_723_effect"):SetDuration(self:GetParent():FindModifierByName("modifier_imba_bane_enfeeble_723_effect"):GetRemainingTime() + self.fiend_grip_tick_interval, true)
	end
end

function modifier_imba_bane_fiends_grip_723:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():StopSound("Hero_Bane.FiendsGrip.Cast")

	self:GetCaster():FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)

	if self:GetAbility() and self:GetAbility():IsChanneling() and self:GetParent() == self:GetAbility():GetCursorTarget() then
		self:GetCaster():Interrupt()
	end
end

function modifier_imba_bane_fiends_grip_723:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

function modifier_imba_bane_fiends_grip_723:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}
end

function modifier_imba_bane_fiends_grip_723:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

-- "If the target turns invulnerable or hidden, the channeling stops instantly."
function modifier_imba_bane_fiends_grip_723:OnStateChanged(keys)
	-- The self:GetElapsedTime() >= 0.03 is roughly to make sure Lotus Orb "works"
	if self:GetElapsedTime() >= 0.03 and (self:GetCaster():IsStunned() or self:GetCaster():IsSilenced() or self:GetCaster():IsHexed() or self:GetCaster():IsOutOfGame() or (self:GetCaster().IsFeared and self:GetCaster():IsFeared()) or (self:GetCaster().IsHypnotized and self:GetCaster():IsHypnotized())) or (self:GetParent():IsInvulnerable() or self:GetParent():IsOutOfGame()) then
		self:Destroy()
	end
end

-- Rubick shit
function imba_bane_enfeeble:IsHiddenWhenStolen() return false end

function imba_bane_brain_sap:IsHiddenWhenStolen() return false end

function imba_bane_nightmare:IsHiddenWhenStolen() return false end

function imba_bane_nightmare_end:IsHiddenWhenStolen() return false end

function imba_bane_fiends_grip:IsHiddenWhenStolen() return false end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_bane_7", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bane_3", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bane_brain_sap_damage", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_bane_fiends_grip_duration", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_bane_7 = modifier_special_bonus_imba_bane_7 or class({})
modifier_special_bonus_imba_bane_3 = modifier_special_bonus_imba_bane_3 or class({})
modifier_special_bonus_imba_bane_brain_sap_damage = modifier_special_bonus_imba_bane_brain_sap_damage or class({})
modifier_special_bonus_imba_bane_fiends_grip_duration = modifier_special_bonus_imba_bane_fiends_grip_duration or class({})

function modifier_special_bonus_imba_bane_7:IsHidden() return true end

function modifier_special_bonus_imba_bane_7:IsPurgable() return false end

function modifier_special_bonus_imba_bane_7:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bane_3:IsHidden() return true end

function modifier_special_bonus_imba_bane_3:IsPurgable() return false end

function modifier_special_bonus_imba_bane_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bane_brain_sap_damage:IsHidden() return true end

function modifier_special_bonus_imba_bane_brain_sap_damage:IsPurgable() return false end

function modifier_special_bonus_imba_bane_brain_sap_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_bane_fiends_grip_duration:IsHidden() return true end

function modifier_special_bonus_imba_bane_fiends_grip_duration:IsPurgable() return false end

function modifier_special_bonus_imba_bane_fiends_grip_duration:RemoveOnDeath() return false end

-- -- Client-side helper functions --

LinkLuaModifier("modifier_special_bonus_imba_bane_2", "components/abilities/heroes/hero_bane", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_bane_2 = class({})

-------------------------
-- ENFEEBLE AOE TALENT --
-------------------------
function modifier_special_bonus_imba_bane_2:IsHidden() return true end

function modifier_special_bonus_imba_bane_2:IsPurgable() return false end

function modifier_special_bonus_imba_bane_2:RemoveOnDeath() return false end

function imba_bane_enfeeble:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_bane_2") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bane_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_bane_2"), "modifier_special_bonus_imba_bane_2", {})
	end
end
