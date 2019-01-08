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

-- Author: Fudge

------------------------------------
------------ ACTIVE ----------------
------------------------------------
item_imba_veil_of_discord = item_imba_veil_of_discord or class({})
LinkLuaModifier("modifier_veil_passive", "components/items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_debuff_aura_modifier", "components/items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura", "components/items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_buff_aura_modifier", "components/items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_veil_active_debuff", "components/items/item_veil_of_discord.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_veil_of_discord:OnSpellStart()
	-- Ability properties
	local caster        =   self:GetCaster()
	local target_loc    =   self:GetCursorPosition()
	local particle      =   "particles/items2_fx/veil_of_discord.vpcf"
	-- Ability parameters
	local radius            =   self:GetSpecialValueFor("active_aoe")
	local debuff_duration   =   self:GetSpecialValueFor("debuff_duration")

	-- Emit sound
	caster:EmitSound("DOTA_Item.VeilofDiscord.Activate")

	-- Emit the particle
	local particle_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_fx, 0, target_loc)
	ParticleManager:SetParticleControl(particle_fx, 1, Vector(radius,1 ,1 ))
	ParticleManager:ReleaseParticleIndex(particle_fx)

	-- Find units around the target point
	local enemies =   FindUnitsInRadius(caster:GetTeamNumber(),
		target_loc,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)

	-- Iterate through the unit table and give each unit its respective modifier
	for _,enemy in pairs(enemies) do
		-- Give enemies a debuff
		enemy:AddNewModifier(caster, self, "modifier_veil_active_debuff", {duration = debuff_duration})
	end
end

function item_imba_veil_of_discord:GetAOERadius()
	return self:GetSpecialValueFor("active_aoe")
end

function item_imba_veil_of_discord:GetIntrinsicModifierName()
	return "modifier_veil_passive"
end

--- ACTIVE DEBUFF MODIFIER
modifier_veil_active_debuff = modifier_veil_active_debuff or class({})

-- Modifier properties
function modifier_veil_active_debuff:IsDebuff() return true end
function modifier_veil_active_debuff:IsHidden() return false end
function modifier_veil_active_debuff:IsPurgable() return true end

function modifier_veil_active_debuff:OnCreated()
	self.magic_resis    =   self:GetAbility():GetSpecialValueFor("active_resis")
end

function modifier_veil_active_debuff:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_veil_active_debuff:GetModifierMagicalResistanceBonus()
	return self.magic_resis
end

function modifier_veil_active_debuff:GetEffectName()
	return "particles/items2_fx/veil_of_discord_debuff.vpcf"
end

function modifier_veil_active_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------
--- PASSIVE STAT/BUFF AURA ---
------------------------------
modifier_veil_passive = modifier_veil_passive or class({})

-- Modifier properties
function modifier_veil_passive:IsHidden() return true end
function modifier_veil_passive:IsDebuff() return false end
function modifier_veil_passive:IsPurgable() return false end
function modifier_veil_passive:IsPermanent() return true end
function modifier_veil_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_veil_passive:IsAura() return true end

function modifier_veil_passive:OnCreated()
	local ability   =   self:GetAbility()
	if IsServer() then
		-- Give buff aura modifier
		self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_veil_buff_aura", {})
	end

	-- Ability parameters
	if self:GetParent():IsHero() and ability then
		self.int_bonus              =   ability:GetSpecialValueFor("bonus_int")
		self.str_bonus              =   ability:GetSpecialValueFor("bonus_str")
		self.agi_bonus              =   ability:GetSpecialValueFor("bonus_agi")
		self.hp_regen_bonus         =   ability:GetSpecialValueFor("bonus_health_regen")
		self.armor_bonus            =   ability:GetSpecialValueFor("bonus_armor")
		self.attack_damage_bonus    =   ability:GetSpecialValueFor("bonus_attack_damage")
		self:CheckUnique(true)
	end
end

-- Various stat bonuses
function modifier_veil_passive:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return funcs
end

-- Stats
function modifier_veil_passive:GetModifierBonusStats_Intellect() return self.int_bonus end
function modifier_veil_passive:GetModifierBonusStats_Agility() return self.agi_bonus end
function modifier_veil_passive:GetModifierBonusStats_Strength() return self.str_bonus end
function modifier_veil_passive:GetModifierConstantHealthRegen() return self.hp_regen_bonus end
function modifier_veil_passive:GetModifierPhysicalArmorBonus() return self.armor_bonus end
function modifier_veil_passive:GetModifierPreAttack_BonusDamage() return self.attack_damage_bonus end

--- DEBUFF AURA
function modifier_veil_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_veil_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

function modifier_veil_passive:GetModifierAura()
	return "modifier_veil_debuff_aura_modifier"
end

function modifier_veil_passive:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_veil_passive:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_veil_buff_aura")
	end
end

--- AURA DEBUFF MODIFIER
modifier_veil_debuff_aura_modifier = modifier_veil_debuff_aura_modifier or class({})

-- Modifier properties
function modifier_veil_debuff_aura_modifier:IsDebuff() return true end
function modifier_veil_debuff_aura_modifier:IsHidden() return false end
function modifier_veil_debuff_aura_modifier:IsPurgable() return false end

function modifier_veil_debuff_aura_modifier:OnCreated()
	self.magic_resis    =   self:GetAbility():GetSpecialValueFor("aura_resist")
end
function modifier_veil_debuff_aura_modifier:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_veil_debuff_aura_modifier:GetModifierMagicalResistanceBonus()
	return self.magic_resis
end

-----------------
--- BUFF AURA ---
-----------------
modifier_veil_buff_aura = modifier_veil_buff_aura or class({})

-- Modifier properties
function modifier_veil_buff_aura:IsHidden() return true end
function modifier_veil_buff_aura:IsDebuff() return false end
function modifier_veil_buff_aura:IsPurgable() return false end
function modifier_veil_buff_aura:IsPermanent() return true end
function modifier_veil_buff_aura:IsAura() return true end

function modifier_veil_buff_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_veil_buff_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_veil_buff_aura:GetModifierAura()
	return "modifier_veil_buff_aura_modifier"
end

function modifier_veil_buff_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

--- AURA BUFF MODIFIER
modifier_veil_buff_aura_modifier = modifier_veil_buff_aura_modifier or class({})

-- Modifier properties
function modifier_veil_buff_aura_modifier:IsDebuff() return false end
function modifier_veil_buff_aura_modifier:IsHidden() return false end
function modifier_veil_buff_aura_modifier:IsPurgable() return true end

function modifier_veil_buff_aura_modifier:OnCreated()
	self.spell_power    =   self:GetAbility():GetSpecialValueFor("aura_spell_power")
end

function modifier_veil_buff_aura_modifier:DeclareFunctions()
	local funcs =   {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
	return funcs
end

function modifier_veil_buff_aura_modifier:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end
