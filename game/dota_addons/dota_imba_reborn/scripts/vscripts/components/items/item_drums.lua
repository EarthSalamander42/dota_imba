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


---------------------------------
--     DRUMS OF ENDURANCE      --
---------------------------------
item_imba_ancient_janggo = class({})
LinkLuaModifier("modifier_imba_drums", "components/items/item_drums.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drums_aura", "components/items/item_drums.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drums_aura_effect", "components/items/item_drums.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drums_active", "components/items/item_drums.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_ancient_janggo:GetIntrinsicModifierName()
	return "modifier_imba_drums"
end

function item_imba_ancient_janggo:GetAbilityTextureName()
	return "custom/imba_ancient_janggo"
end

function item_imba_ancient_janggo:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "DOTA_Item.DoE.Activate"
	local modifier_active = "modifier_imba_drums_active"

	-- Ability specials
	local hero_multiplier = ability:GetSpecialValueFor("hero_multiplier")
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")

	-- Play cast sound effect
	EmitSoundOn(sound_cast, caster)

	-- Find all nearby allies
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
		FIND_ANY_ORDER,
		false)

	-- Decide how many stacks the active should have
	local stacks = 0
	for _,ally in pairs(allies) do

		-- Illusions are treated as creeps
		if ally:IsRealHero() then
			stacks = stacks + hero_multiplier
		else
			stacks = stacks + 1
		end
	end

	-- Apply the active modifier on nearby ally with the stacks that were calculated
	for _,ally in pairs(allies) do
		-- If the ally has Hellish Siege (Siege cuirass's active), do nothing
		if not ally:HasModifier("modifier_imba_siege_cuirass_active") then
			local modifier_active_handler = ally:AddNewModifier(caster, ability, modifier_active, {duration = duration})
			if modifier_active_handler then
				modifier_active_handler:SetStackCount(stacks)
			end
		end
	end
end


-- Active modifier
modifier_imba_drums_active = class({})

function modifier_imba_drums_active:OnCreated()
	-- Ability properties
	self.particle_buff = "particles/items_fx/drum_of_endurance_buff.vpcf"

	-- Ability specials
	self.active_as_per_ally = self:GetAbility():GetSpecialValueFor("active_as_per_ally")
	self.active_ms_per_ally = self:GetAbility():GetSpecialValueFor("active_ms_per_ally")

	-- Apply particle effects
	local particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_buff_fx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_buff_fx, 1, Vector(0,0,0))
	self:AddParticle(particle_buff_fx, false, false, -1, false, false)
end

function modifier_imba_drums_active:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return decFuncs
end

function modifier_imba_drums_active:GetModifierMoveSpeedBonus_Percentage()
	return self.active_ms_per_ally * self:GetStackCount()
end

function modifier_imba_drums_active:GetModifierAttackSpeedBonus_Constant()
	return self.active_as_per_ally * self:GetStackCount()
end


-- Stats modifier (stacks)
modifier_imba_drums = class({})

function modifier_imba_drums:OnCreated()
	-- Ability specials
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

	if IsServer() then
		-- If it is the first drums in inventory, add the aura modifier
		if not self:GetCaster():HasModifier("modifier_imba_drums_aura") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drums_aura", {})
		end
	end
end

function modifier_imba_drums:IsHidden() return true end
function modifier_imba_drums:IsPurgable() return false end
function modifier_imba_drums:IsDebuff() return false end
function modifier_imba_drums:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_drums:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT}

	return decFuncs
end

function modifier_imba_drums:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_imba_drums:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_imba_drums:GetModifierBonusStats_Agility()
	return self.bonus_agi
end

function modifier_imba_drums:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_drums:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_imba_drums:OnDestroy()
	if IsServer() then
		-- If it is the last drums in inventory, remove the aura modifier
		if not self:GetCaster():HasModifier("modifier_imba_drums") then
			self:GetCaster():RemoveModifierByName("modifier_imba_drums_aura")
		end
	end
end


-- Drums aura modifier
modifier_imba_drums_aura = class({})

function modifier_imba_drums_aura:OnCreated()
	-- Ability specials
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_drums_aura:IsDebuff() return false end
function modifier_imba_drums_aura:AllowIllusionDuplicate() return true end
function modifier_imba_drums_aura:IsHidden() return true end
function modifier_imba_drums_aura:IsPurgable() return false end

function modifier_imba_drums_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_drums_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_drums_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_drums_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_drums_aura:GetModifierAura()
	return "modifier_imba_drums_aura_effect"
end

function modifier_imba_drums_aura:IsAura()
	return true
end

function modifier_imba_drums_aura:GetAuraEntityReject(target)

	-- If the target has higher level aura (Siege), do not apply the aura
	if target:HasModifier("modifier_imba_siege_cuirass_aura_positive_effect") then
		return true
	end

	-- Apply for the rest
	return false
end

-- Drum aura modifier effect
modifier_imba_drums_aura_effect = class({})

function modifier_imba_drums_aura_effect:OnCreated()
	-- Ability specials
	self.aura_ms = self:GetAbility():GetSpecialValueFor("aura_ms")
	self.aura_as = self:GetAbility():GetSpecialValueFor("aura_as")
end

function modifier_imba_drums_aura_effect:IsHidden() return false end
function modifier_imba_drums_aura_effect:IsPurgable() return false end
function modifier_imba_drums_aura_effect:IsDebuff() return false end

function modifier_imba_drums_aura_effect:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return decFuncs
end

function modifier_imba_drums_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.aura_ms
end

function modifier_imba_drums_aura_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as
end
