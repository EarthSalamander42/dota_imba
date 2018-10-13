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
-- Date: 16/05/2017



-------------------------------
--      SIEGE CUIRASS        --
-------------------------------
item_imba_siege_cuirass = class({})
LinkLuaModifier("modifier_imba_siege_cuirass", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_siege_cuirass_aura_positive", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_siege_cuirass_aura_positive_effect", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_siege_cuirass_aura_negative", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_siege_cuirass_aura_negative_effect", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_siege_cuirass_active", "components/items/item_siege_cuirass", LUA_MODIFIER_MOTION_NONE)

function item_imba_siege_cuirass:GetIntrinsicModifierName()
	return "modifier_imba_siege_cuirass"
end

function item_imba_siege_cuirass:GetAbilityTextureName()
	return "custom/imba_siege_cuirass"
end

function item_imba_siege_cuirass:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.DoE.Activate"
	local modifier_active = "modifier_imba_siege_cuirass_active"

	-- Ability specials
	local active_hero_multiplier = ability:GetSpecialValueFor("active_hero_multiplier")
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Find how many units and heroes are around
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
		FIND_ANY_ORDER,
		false)

	-- Calculate how many stacks should be given to those units, based on if those are creeps or heroes
	local stacks = 0
	for _,ally in pairs(allies) do

		-- Illusions are regarded as creeps
		if ally:IsRealHero() then
			stacks = stacks + active_hero_multiplier
		else
			stacks = stacks + 1
		end
	end

	-- Add modifiers to all units (including caster) and assign them the stack count found
	for _,ally in pairs(allies) do
		-- If the target has drums' active, remove it
		if ally:HasModifier("modifier_imba_drums_active") then
			ally:RemoveModifierByName("modifier_imba_drums_active")
		end

		local modifier_active_handler = ally:AddNewModifier(caster, ability, modifier_active, {duration = duration})
		if modifier_active_handler then
			modifier_active_handler:SetStackCount(stacks)
		end
	end
end


-- Active modifier
modifier_imba_siege_cuirass_active = class({})

function modifier_imba_siege_cuirass_active:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_buff = "particles/items_fx/drum_of_endurance_buff.vpcf"

	-- Ability specials
	self.active_as_per_ally = self.ability:GetSpecialValueFor("active_as_per_ally")
	self.active_ms_per_ally = self.ability:GetSpecialValueFor("active_ms_per_ally")

	-- Add cast particle effect
	local particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_buff_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_buff_fx, 1, Vector(0, 0, 0))
	self:AddParticle(particle_buff_fx, false, false, -1, false, false)
end

function modifier_imba_siege_cuirass_active:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_siege_cuirass_active:GetModifierAttackSpeedBonus_Constant()
	return self.active_as_per_ally * self:GetStackCount()
end

function modifier_imba_siege_cuirass_active:GetModifierMoveSpeedBonus_Constant()
	return self.active_ms_per_ally * self:GetStackCount()
end


-- Stats passive modifier (stacking)
modifier_imba_siege_cuirass = class({})

function modifier_imba_siege_cuirass:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_self = "modifier_imba_siege_cuirass"
	self.modifier_aura_positive = "modifier_imba_siege_cuirass_aura_positive"
	self.modifier_aura_negative = "modifier_imba_siege_cuirass_aura_negative"

	-- Abiltiy specials
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_as = self.ability:GetSpecialValueFor("bonus_as")
	self.bonus_mana_regen_pct = self.ability:GetSpecialValueFor("bonus_mana_regen_pct")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

	if IsServer() then
		-- If it is the first siege cuirass in the inventory, grant the siege cuirass aura
		if not self.caster:HasModifier(self.modifier_aura_positive) then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura_positive, {})
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_aura_negative, {})
		end
	end
end

function modifier_imba_siege_cuirass:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	return decFuncs
end

function modifier_imba_siege_cuirass:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_imba_siege_cuirass:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_imba_siege_cuirass:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_siege_cuirass:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_siege_cuirass:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_siege_cuirass:GetModifierConstantManaRegen()
	return self.bonus_mana_regen_pct
end

function modifier_imba_siege_cuirass:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end


function modifier_imba_siege_cuirass:IsHidden() return true end
function modifier_imba_siege_cuirass:IsPurgable() return false end
function modifier_imba_siege_cuirass:IsDebuff() return false end
function modifier_imba_siege_cuirass:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_siege_cuirass:OnDestroy()
	if IsServer() then
		-- If it is the last siege cuirass in the inventory, remove the aura
		if not self.caster:HasModifier(self.modifier_self) then
			self.caster:RemoveModifierByName(self.modifier_aura_positive)
			self.caster:RemoveModifierByName(self.modifier_aura_negative)
		end
	end
end

-- Siege Cuirass positive aura
modifier_imba_siege_cuirass_aura_positive = class({})

function modifier_imba_siege_cuirass_aura_positive:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_siege = "modifier_imba_siege_cuirass_aura_positive_effect"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_siege_cuirass_aura_positive:IsDebuff() return false end
function modifier_imba_siege_cuirass_aura_positive:AllowIllusionDuplicate() return true end
function modifier_imba_siege_cuirass_aura_positive:IsHidden() return true end
function modifier_imba_siege_cuirass_aura_positive:IsPurgable() return false end

function modifier_imba_siege_cuirass_aura_positive:GetAuraRadius()
	return self.radius
end

function modifier_imba_siege_cuirass_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_siege_cuirass_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_siege_cuirass_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_siege_cuirass_aura_positive:GetModifierAura()
	return self.modifier_siege
end

function modifier_imba_siege_cuirass_aura_positive:IsAura()
	return true
end



-- Siege Cuirass positive aura effect
modifier_imba_siege_cuirass_aura_positive_effect = class({})

function modifier_imba_siege_cuirass_aura_positive_effect:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.aura_as_ally = self.ability:GetSpecialValueFor("aura_as_ally")
	self.aura_ms_ally = self.ability:GetSpecialValueFor("aura_ms_ally")
	self.aura_armor_ally = self.ability:GetSpecialValueFor("aura_armor_ally")
end

function modifier_imba_siege_cuirass_aura_positive_effect:IsHidden() return false end
function modifier_imba_siege_cuirass_aura_positive_effect:IsPurgable() return false end
function modifier_imba_siege_cuirass_aura_positive_effect:IsDebuff() return false end

function modifier_imba_siege_cuirass_aura_positive_effect:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_siege_cuirass_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_imba_siege_cuirass_aura_positive_effect:GetModifierMoveSpeedBonus_Constant()
	return self.aura_ms_ally
end

function modifier_imba_siege_cuirass_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end




-- Siege Cuirass negative aura
modifier_imba_siege_cuirass_aura_negative = class({})

function modifier_imba_siege_cuirass_aura_negative:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.modifier_siege = "modifier_imba_siege_cuirass_aura_negative_effect"

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_siege_cuirass_aura_negative:IsDebuff() return false end
function modifier_imba_siege_cuirass_aura_negative:AllowIllusionDuplicate() return true end
function modifier_imba_siege_cuirass_aura_negative:IsHidden() return true end
function modifier_imba_siege_cuirass_aura_negative:IsPurgable() return false end

function modifier_imba_siege_cuirass_aura_negative:GetAuraRadius()
	return self.radius
end

function modifier_imba_siege_cuirass_aura_negative:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_siege_cuirass_aura_negative:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_siege_cuirass_aura_negative:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_siege_cuirass_aura_negative:GetModifierAura()
	return self.modifier_siege
end

function modifier_imba_siege_cuirass_aura_negative:IsAura()
	return true
end



-- Siege Cuirass negative aura effect
modifier_imba_siege_cuirass_aura_negative_effect = class({})

function modifier_imba_siege_cuirass_aura_negative_effect:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.aura_as_reduction_enemy = self.ability:GetSpecialValueFor("aura_as_reduction_enemy")
	self.aura_ms_reduction_enemy = self.ability:GetSpecialValueFor("aura_ms_reduction_enemy")
	self.aura_armor_reduction_enemy = self.ability:GetSpecialValueFor("aura_armor_reduction_enemy")
end

function modifier_imba_siege_cuirass_aura_negative_effect:IsHidden() return false end
function modifier_imba_siege_cuirass_aura_negative_effect:IsPurgable() return false end
function modifier_imba_siege_cuirass_aura_negative_effect:IsDebuff() return true end

function modifier_imba_siege_cuirass_aura_negative_effect:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_siege_cuirass_aura_negative_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_reduction_enemy * (-1)
end

function modifier_imba_siege_cuirass_aura_negative_effect:GetModifierMoveSpeedBonus_Constant()
	return self.aura_ms_reduction_enemy * (-1)
end

function modifier_imba_siege_cuirass_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_reduction_enemy * (-1)
end
