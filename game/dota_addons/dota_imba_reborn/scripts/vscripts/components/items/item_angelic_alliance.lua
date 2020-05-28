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

--	Angelic Alliance
--	Author: zimberzimber
--	Date:	27.1.2017

if item_imba_angelic_alliance == nil then item_imba_angelic_alliance = class({}) end
LinkLuaModifier( "modifier_imba_angelic_alliance_debuff", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )					--	Disarm, armor reduction, vision
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_effect", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Item Modifier + attack/hit effect
LinkLuaModifier( "modifier_imba_angelic_alliance_buff", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )					--	Evasion, armor, vision
LinkLuaModifier( "modifier_imba_angelic_alliance_buff_self", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_angelic_alliance_debuff_caster", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Armor reduction for the caster
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_disarm", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )			--	Passive disarm from attacking or getting attacked
LinkLuaModifier( "modifier_imba_angelic_alliance_passive_disarm_cooldown", "components/items/item_angelic_alliance.lua", LUA_MODIFIER_MOTION_NONE )--	Cooldown for the passive disarm effect per target

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------

function item_imba_angelic_alliance:GetAbilityTextureName()
	return "custom/imba_angelic_alliance"
end

function item_imba_angelic_alliance:GetBehavior()		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 	end
function item_imba_angelic_alliance:IsRefreshable()		return true		end
function item_imba_angelic_alliance:ProcsMagicStick()	return false	end

function item_imba_angelic_alliance:GetIntrinsicModifierName()
	return "modifier_imba_angelic_alliance_passive_effect"
end

function item_imba_angelic_alliance:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")

	if target == self:GetCaster() then
		duration = self:GetSpecialValueFor("duration_self")
	end

	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return
		end
	end

	-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	if target:IsMagicImmune() then
		return nil
	end

	target:EmitSound("Imba.AngelicAllianceCast")

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		if target ~= caster then
			target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_buff", {duration = duration})
		else
			target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_buff_self", {duration = duration})
		end
	else
		if target:TriggerSpellAbsorb(self) then return nil end
		target:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_debuff", {duration = duration * (1 - target:GetStatusResistance())})
	end

	if target ~= self:GetCaster() then
		caster:AddNewModifier(caster, self, "modifier_imba_angelic_alliance_debuff_caster", {duration = duration})
	end
end

function item_imba_angelic_alliance:CastFilterResultTarget(target)
	if target:IsBuilding() then
		return UF_FAIL_BUILDING
	end
	
	if IsServer() then
		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

-----------------------------------------------------------------------------------------------------------
--	Item Modifier (stats + attack/damaged effect)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_effect == nil then modifier_imba_angelic_alliance_passive_effect = class({}) end

function modifier_imba_angelic_alliance_passive_effect:IsHidden()			return true end
function modifier_imba_angelic_alliance_passive_effect:IsPurgable()		return false end
function modifier_imba_angelic_alliance_passive_effect:RemoveOnDeath()	return false end
function modifier_imba_angelic_alliance_passive_effect:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_angelic_alliance_passive_effect:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.bonus_strength		= self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_agility		= self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.bonus_intellect	= self:GetAbility():GetSpecialValueFor("bonus_intellect")
	self.armor_change		= self:GetAbility():GetSpecialValueFor("armor_change")
	self.movement_speed		= self:GetAbility():GetSpecialValueFor("movement_speed")
	self.bonus_evasion		= self:GetAbility():GetSpecialValueFor("bonus_evasion")
	self.bonus_mana_regen	= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.status_resistance	= self:GetAbility():GetSpecialValueFor("status_resistance")
end

function modifier_imba_angelic_alliance_passive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("armor_change")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("movement_speed")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierEvasion_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_evasion")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_imba_angelic_alliance_passive_effect:GetModifierStatusResistanceStacking()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("status_resistance")
	end
end

function modifier_imba_angelic_alliance_passive_effect:OnAttackLanded( keys )
	if self:GetAbility() then
		if self:GetCaster():HasModifier("modifier_imba_angelic_alliance_debuff_caster") then return nil end
		-- Proc once every 6 seconds, regardless of if it's us attacking or being attacked
		if self:GetCaster():HasModifier("modifier_imba_angelic_alliance_passive_disarm_cooldown") then return nil end
		-- Don't disarm towers
		if keys.attacker:IsBuilding() or keys.target:IsBuilding() or keys.attacker:IsCreep() then
			return nil
		end

		if self:GetCaster() == keys.target and not keys.target:IsIllusion() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("passive_disarm_chance"), self) then				-- Disarm attacker when the wielder is the one getting hit
			if keys.attacker:IsMagicImmune() then return end
			if keys.attacker:HasModifier("modifier_imba_angelic_alliance_passive_disarm") then return end
			keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_angelic_alliance_passive_disarm", {duration = self:GetAbility():GetSpecialValueFor("passive_disarm_duration") * (1 - keys.attacker:GetStatusResistance())})
			keys.attacker:EmitSound("DOTA_Item.HeavensHalberd.Activate")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Enemy Debuff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_debuff == nil then modifier_imba_angelic_alliance_debuff = class({}) end
function modifier_imba_angelic_alliance_debuff:IsDebuff() 				return true end
function modifier_imba_angelic_alliance_debuff:IsHidden() 				return false end
function modifier_imba_angelic_alliance_debuff:IsPurgable() 			return false end
function modifier_imba_angelic_alliance_debuff:GetTexture() 			return "custom/imba_angelic_alliance" end
function modifier_imba_angelic_alliance_debuff:GetEffectName()			return "particles/item/angelic_alliance/angelic_alliance_debuff.vpcf" end
function modifier_imba_angelic_alliance_debuff:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_debuff:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_angelic_alliance_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.armor_change				= self:GetAbility():GetSpecialValueFor("armor_change") * (-1)
	self.target_movement_speed		= self:GetAbility():GetSpecialValueFor("target_movement_speed") * (-1)
	self.target_attack_speed		= self:GetAbility():GetSpecialValueFor("target_attack_speed") * (-1)
end

function modifier_imba_angelic_alliance_debuff:CheckState()
	return {
		[MODIFIER_STATE_DISARMED]	= true,
		[MODIFIER_STATE_INVISIBLE]	= false,
	}
end

function modifier_imba_angelic_alliance_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_angelic_alliance_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_change
end

function modifier_imba_angelic_alliance_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.target_movement_speed
end

function modifier_imba_angelic_alliance_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.target_attack_speed
end

-----------------------------------------------------------------------------------------------------------
--	Ally Buff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_buff == nil then modifier_imba_angelic_alliance_buff = class({}) end
function modifier_imba_angelic_alliance_buff:IsHidden() return false end
function modifier_imba_angelic_alliance_buff:IsDebuff() return false end
function modifier_imba_angelic_alliance_buff:GetTexture() return "custom/imba_angelic_alliance" end

function modifier_imba_angelic_alliance_buff:GetEffectName()
	return "particles/item/angelic_alliance/angelic_alliance_buff.vpcf"
end

function modifier_imba_angelic_alliance_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_angelic_alliance_buff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.armor_change				= self:GetAbility():GetSpecialValueFor("armor_change")
	self.target_movement_speed		= self:GetAbility():GetSpecialValueFor("target_movement_speed")
	self.target_attack_speed		= self:GetAbility():GetSpecialValueFor("target_attack_speed")
	self.target_status_resistance	= self:GetAbility():GetSpecialValueFor("target_status_resistance")
	self.target_evasion				= self:GetAbility():GetSpecialValueFor("target_evasion")
end

function modifier_imba_angelic_alliance_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_imba_angelic_alliance_buff:GetModifierPhysicalArmorBonus()
	if self:GetParent() ~= self:GetCaster() then
		return self.armor_change
	end
end

function modifier_imba_angelic_alliance_buff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetParent() ~= self:GetCaster() then
		return self.target_movement_speed
	end
end

function modifier_imba_angelic_alliance_buff:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent() ~= self:GetCaster() then
		return self.target_attack_speed
	end
end

function modifier_imba_angelic_alliance_buff:GetModifierStatusResistanceStacking()
	return self.target_status_resistance
end

function modifier_imba_angelic_alliance_buff:GetModifierEvasion_Constant()
	if self:GetParent() ~= self:GetCaster() then
		return self.target_evasion
	end
end

----------------------------------------------
-- MODIFIER_IMBA_ANGELIC_ALLIANCE_BUFF_SELF --
----------------------------------------------

modifier_imba_angelic_alliance_buff_self	= modifier_imba_angelic_alliance_buff_self or class({})

function modifier_imba_angelic_alliance_buff_self:GetTexture() return "custom/imba_angelic_alliance" end

function modifier_imba_angelic_alliance_buff_self:GetEffectName()
	return "particles/items2_fx/sange_active.vpcf"
end

function modifier_imba_angelic_alliance_buff_self:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.target_status_resistance	= self:GetAbility():GetSpecialValueFor("target_status_resistance")
end

function modifier_imba_angelic_alliance_buff_self:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_angelic_alliance_buff_self:GetModifierStatusResistanceStacking()
	return self.target_status_resistance
end

-----------------------------------------------------------------------------------------------------------
--	Caster Debuff
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_debuff_caster == nil then modifier_imba_angelic_alliance_debuff_caster = class({}) end
function modifier_imba_angelic_alliance_debuff_caster:IsHidden() return false end
function modifier_imba_angelic_alliance_debuff_caster:IsDebuff() return true end
function modifier_imba_angelic_alliance_debuff_caster:IsPurgable() return false end

function modifier_imba_angelic_alliance_debuff_caster:GetEffectName()
	return "particles/items2_fx/medallion_of_courage.vpcf" end

function modifier_imba_angelic_alliance_debuff_caster:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_debuff_caster:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.armor_change	= self:GetAbility():GetSpecialValueFor("armor_change") * (-1)
end

function modifier_imba_angelic_alliance_debuff_caster:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_imba_angelic_alliance_debuff_caster:GetModifierPhysicalArmorBonus()
	return self.armor_change
end

-----------------------------------------------------------------------------------------------------------
--	Passive disarm (from attacks or getting attacked)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_disarm == nil then modifier_imba_angelic_alliance_passive_disarm = class({}) end

function modifier_imba_angelic_alliance_passive_disarm:IsHidden() return false end
function modifier_imba_angelic_alliance_passive_disarm:IsDebuff() return true end
function modifier_imba_angelic_alliance_passive_disarm:IsPurgable() return false end

function modifier_imba_angelic_alliance_passive_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf" end

function modifier_imba_angelic_alliance_passive_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_angelic_alliance_passive_disarm:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_imba_angelic_alliance_passive_disarm:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	if not IsServer() then return end
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_angelic_alliance_passive_disarm_cooldown", {duration = self:GetAbility():GetSpecialValueFor("passive_disarm_cooldown")})
end

-----------------------------------------------------------------------------------------------------------
--	Passive disarm cooldown (prevents the passive disarm from proccing)
-----------------------------------------------------------------------------------------------------------

if modifier_imba_angelic_alliance_passive_disarm_cooldown == nil then modifier_imba_angelic_alliance_passive_disarm_cooldown = class({}) end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsHidden() return false end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsDebuff() return true end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:IsPurgable() return false end
function modifier_imba_angelic_alliance_passive_disarm_cooldown:GetTexture() return "custom/imba_angelic_alliance" end
