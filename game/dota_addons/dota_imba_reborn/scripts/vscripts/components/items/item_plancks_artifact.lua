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
--     suthernfriend 11.02.18

-- Basic
if item_imba_plancks_artifact == nil then
	item_imba_plancks_artifact = class({})
end

-- Modifiers:
--   basic: stats, constant mana regen
--   unique: cooldown reduction, spell lifesteal

LinkLuaModifier("modifier_imba_plancks_artifact_basic", "components/items/item_plancks_artifact.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_imba_plancks_artifact_unique", "components/items/item_plancks_artifact.lua", LUA_MODIFIER_MOTION_NONE )

function item_imba_plancks_artifact:GetAbilityTextureName()
	return "custom/imba_plancks_artifact"
end

function item_imba_plancks_artifact:GetIntrinsicModifierName()
	return "modifier_imba_plancks_artifact_basic"
end

function item_imba_plancks_artifact:set_respawn_time(reset)
	if reset ~= nil then
		self:GetCaster().plancks_artifact_respawn_reduction = nil
		print("PLANCK: resetting respawn time")
	else
		self:GetCaster().plancks_artifact_respawn_reduction =
			self:GetSpecialValueFor("respawn_time_reduction") *
			self:GetCurrentCharges()
		print("PLANCK: setting respawn reduction time to " .. tostring(self:GetCaster().plancks_artifact_respawn_reduction))
	end
end

-- Active

function item_imba_plancks_artifact:OnSpellStart()

	if self:GetCaster():HasModifier("modifier_imba_reincarnation") then
		self:GetCaster():Kill(self, self:GetCaster())
	else
		TrueKill(self:GetCaster(), self:GetCaster(), self)
	end

	local units_to_damage = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("implosion_radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	local damage = self:GetCaster():GetMana() * self:GetSpecialValueFor("implosion_damage_percent")

	for _,unit in pairs(units_to_damage) do
		ApplyDamage({
			victim = unit,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PURE
		})
	end

	local particle = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle)
end

-- Stats
if modifier_imba_plancks_artifact_basic == nil then
	modifier_imba_plancks_artifact_basic = class({})
end

if modifier_imba_plancks_artifact_unique == nil then
	modifier_imba_plancks_artifact_unique = class({})
end

function modifier_imba_plancks_artifact_basic:IsHidden() return
	true
end

function modifier_imba_plancks_artifact_basic:IsDebuff() return
	false
end

function modifier_imba_plancks_artifact_basic:IsPurgable() return
	false
end

function modifier_imba_plancks_artifact_basic:IsPermanent() return
	true
end

function modifier_imba_plancks_artifact_basic:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_plancks_artifact_basic:OnCreated()
	if IsServer() then

		self.modifier_self = "modifier_imba_plancks_artifact_basic"
		self.modifier_unique = "modifier_imba_plancks_artifact_unique"
		self.modifier_implosion = "modifier_imba_plancks_artifact_implosion"

		if not self:GetCaster():HasModifier(self.modifier_unique) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_unique, {})
		end
	end
end

function modifier_imba_plancks_artifact_basic:OnDestroy()
	if IsServer() then
		if self:GetCaster():HasModifier(self.modifier_unique) then
			self:GetCaster():RemoveModifierByName(self.modifier_unique)
		end
	end
end

function modifier_imba_plancks_artifact_basic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_imba_plancks_artifact_basic:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_imba_plancks_artifact_basic:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health")
end

function modifier_imba_plancks_artifact_basic:GetModifierConstantManaRegen()

	local reg = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

	if IsServer() then
		reg = reg + self:GetAbility():GetSpecialValueFor("mana_regen_per_charge") * self:GetAbility():GetCurrentCharges()
	end

	return reg
end

function modifier_imba_plancks_artifact_basic:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intelligence")
end

-- CDR / Spell Lifesteal
function modifier_imba_plancks_artifact_unique:OnCreated()
	if IsServer() then
		self:GetAbility():set_respawn_time()
	end
end

function modifier_imba_plancks_artifact_unique:OnDestroy()
	if IsServer() then
		self:GetAbility():set_respawn_time(true)
	end
end

-- Remove stacks, respawn time, heal
function modifier_imba_plancks_artifact_unique:OnDeath(args)

	if not IsServer() then
		return nil
	end

	local stacks = self:GetAbility():GetCurrentCharges()
	local caster = self:GetAbility():GetCaster()
	local target = args.unit

	-- do nothing if someone else dies
	if target ~= caster then

		local target = args.unit

		-- Don't gain charges off of illusions
		if not target:IsRealHero() or target:IsClone() then
			return nil
		end

		if (self:GetAbility():GetCaster():GetAbsOrigin() - target:GetAbsOrigin()
			):Length2D() > self:GetAbility():GetSpecialValueFor("stack_gain_radius")
		then
			return nil
		end

		-- add stack and set respawn reduction
		self:GetAbility():SetCurrentCharges(self:GetAbility():GetCurrentCharges() + 1)
		self:GetAbility():set_respawn_time()

	else

		-- ok if we reincarnate, do nothing
		if caster:WillReincarnate() then
			return nil
		end

		-- Heal nearby allies
		local allies = FindUnitsInRadius(
			caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
			self:GetAbility():GetSpecialValueFor("heal_radius"),
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false
		)

		local heal_amount =
			self:GetAbility():GetSpecialValueFor("heal_on_death_base") +
			stacks * self:GetAbility():GetSpecialValueFor("heal_on_death_per_charge")

		for _,unit in pairs(allies) do
			unit:Heal(heal_amount, caster)
		end

		-- remove stacks
		local new_stacks = math.floor(stacks * self:GetAbility():GetSpecialValueFor("on_death_loss"))

		self:GetAbility():SetCurrentCharges(new_stacks)
		self:GetAbility():set_respawn_time()
	end
end

function modifier_imba_plancks_artifact_unique:IsHidden()
	return true
end

function modifier_imba_plancks_artifact_unique:IsDebuff()
	return false
end

function modifier_imba_plancks_artifact_unique:IsPurgable()
	return false
end

function modifier_imba_plancks_artifact_unique:RemoveOnDeath()
	return false
end

function modifier_imba_plancks_artifact_unique:IsPermanent()
	return false
end

function modifier_imba_plancks_artifact_unique:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_plancks_artifact_unique:GetModifierSpellLifesteal()
	return self:GetAbility():GetSpecialValueFor("spell_lifesteal")
end

function modifier_imba_plancks_artifact_unique:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("bonus_cooldown")
end
