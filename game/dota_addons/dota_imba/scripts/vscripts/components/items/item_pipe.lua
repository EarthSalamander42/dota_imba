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

item_imba_pipe = item_imba_pipe or class({})
LinkLuaModifier("modifier_imba_pipe_passive", "components/items/item_pipe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pipe_aura_emitter", "components/items/item_pipe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pipe_aura", "components/items/item_pipe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_pipe_active_bonus", "components/items/item_pipe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hood_of_defiance_active_shield", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_pipe:GetIntrinsicModifierName()
	return "modifier_imba_pipe_passive"
end

function item_imba_pipe:OnSpellStart()
	local caster = self:GetCaster()
	local shield_health = self:GetSpecialValueFor("shield_health")
	local duration = self:GetSpecialValueFor("duration")
	local search_radius = self:GetSpecialValueFor("aura_radius")
	local unreducable_magic_resist = self:GetSpecialValueFor("unreducable_magic_resist")
	local activation_particle = "particles/items2_fx/pipe_of_insight_launch.vpcf"

	EmitSoundOn("DOTA_Item.Pipe.Activate", caster)
	local particle = ParticleManager:CreateParticle(activation_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(particle)

	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		search_radius,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		0,
		FIND_ANY_ORDER,
		false)
	for _, unit in pairs(allies) do
		unit:AddNewModifier(caster, self, "modifier_imba_hood_of_defiance_active_shield", {duration = duration, shield_health = shield_health})
		-- Only heroes get the unreducable magic resistance
		if unit:IsHero() then
			unit:AddNewModifier(caster, self, "modifier_imba_pipe_active_bonus", {duration = duration, unreducable_magic_resist = unreducable_magic_resist})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance stats modifier
-----------------------------------------------------------------------------------------------------------
modifier_imba_pipe_passive = modifier_imba_pipe_passive or class({})

function modifier_imba_pipe_passive:IsDebuff() return false end
function modifier_imba_pipe_passive:IsHidden() return true end
function modifier_imba_pipe_passive:IsPurgable() return false end
function modifier_imba_pipe_passive:IsPurgeException() return false end
function modifier_imba_pipe_passive:RemoveOnDeath() return false end
function modifier_imba_pipe_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_pipe_passive:OnCreated( params )
	self.parent = self:GetParent()
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
	if not self.parent:HasModifier("modifier_imba_pipe_aura_emitter") and IsServer() then
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_pipe_aura_emitter", {})
	end
end

function modifier_imba_pipe_passive:OnDestroy( params )
	if not self:IsNull() and not self.parent:IsNull() and not self.parent:HasModifier("modifier_imba_pipe_passive") and IsServer() then
		self.parent:RemoveModifierByName("modifier_imba_pipe_aura_emitter")
	end
end

function modifier_imba_pipe_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_imba_pipe_passive:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_imba_pipe_passive:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resist
end

-----------------------------------------------------------------------------------------------------------
--	Pipe of Insight aura emitter
-----------------------------------------------------------------------------------------------------------
modifier_imba_pipe_aura_emitter = modifier_imba_pipe_aura_emitter or class({})

function modifier_imba_pipe_aura_emitter:IsHidden() return true end
function modifier_imba_pipe_aura_emitter:IsAura() return true end
function modifier_imba_pipe_aura_emitter:IsDebuff() return false end
function modifier_imba_pipe_aura_emitter:IsPurgable() return false end
function modifier_imba_pipe_aura_emitter:IsPurgeException() return false end
function modifier_imba_pipe_aura_emitter:RemoveOnDeath() return false end
function modifier_imba_pipe_aura_emitter:IsAuraActiveOnDeath() return false end

function modifier_imba_pipe_aura_emitter:OnCreated( params )
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_pipe_aura_emitter:GetModifierAura()
	return "modifier_imba_pipe_aura"
end

function modifier_imba_pipe_aura_emitter:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_imba_pipe_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_pipe_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_imba_pipe_aura_emitter:GetAuraRadius()
	return self.aura_radius
end

-----------------------------------------------------------------------------------------------------------
--	Pipe of Insight aura, gives bonus health regen/magic resist and tenacity (DOES stack multiplicatively, unlike Hood)
-----------------------------------------------------------------------------------------------------------
modifier_imba_pipe_aura = modifier_imba_pipe_aura or class({})

function modifier_imba_pipe_aura:IsPurgable() return false end

function modifier_imba_pipe_aura:OnCreated( params )
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("aura_bonus_health_regen")
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("aura_bonus_magic_resist")
	self.aura_tenacity_pct = self:GetAbility():GetSpecialValueFor("aura_tenacity_pct")
	self.active_tenacity_pct = self:GetAbility():GetSpecialValueFor("active_tenacity_pct")
end

function modifier_imba_pipe_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return funcs
end

function modifier_imba_pipe_aura:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_imba_pipe_aura:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resist
end

function modifier_imba_pipe_aura:GetModifierStatusResistanceStacking()
	-- If the parent has the active bonus, tenacity bonus is increased
	if self.parent:HasModifier("modifier_imba_pipe_active_bonus") then
		return self.active_tenacity_pct
	end

	return self.aura_tenacity_pct
end

-----------------------------------------------------------------------------------------------------------
--	Pipe of Insight active unreducable magic resistance modifier
-----------------------------------------------------------------------------------------------------------
modifier_imba_pipe_active_bonus = modifier_imba_pipe_active_bonus or class({})

function modifier_imba_pipe_active_bonus:IsDebuff() return false end
function modifier_imba_pipe_active_bonus:IsHidden() return false end
function modifier_imba_pipe_active_bonus:IsPurgable() return false end
function modifier_imba_pipe_active_bonus:IsPurgeException() return false end

function modifier_imba_pipe_active_bonus:OnCreated( params )
	self.magic_resist_compensation = 0
	self.precision = 0.5 / 100 -- margin of 0.5% magic resistance. This is to prevent rounding-related errors/recalculations
	self.parent = self:GetParent()

	self.unreducable_magic_resist = self:GetAbility():GetSpecialValueFor("unreducable_magic_resist")
	self.unreducable_magic_resist = self.unreducable_magic_resist / 100
	self:StartIntervalThink(0.1)
end

function modifier_imba_pipe_active_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_imba_pipe_active_bonus:OnIntervalThink()
	local current_res = self.parent:GetMagicalArmorValue()
	-- If we are below the margin, we need to add magic resistance
	if current_res < ( self.unreducable_magic_resist - self.precision ) then
		-- Serious math
		if self.magic_resist_compensation > 0 then
			local current_compensation = self.magic_resist_compensation / 100
			local compensation = ( self.unreducable_magic_resist - 1 ) * ( 1 - current_compensation) / (1 - current_res) + 1
			self.magic_resist_compensation = compensation * 100
		else
			local compensation = 1 + (self.unreducable_magic_resist - 1) / (1 - current_res)
			self.magic_resist_compensation = compensation * 100
		end
		-- If we already have compensation and are above the margin, decrease it
	elseif self.magic_resist_compensation > 0 and current_res > ( self.unreducable_magic_resist + self.precision ) then
		-- Serious copy-paste
		local current_compensation = self.magic_resist_compensation / 100
		local compensation = (self.unreducable_magic_resist - 1) * ( 1 - current_compensation) / (1 - current_res) + 1

		self.magic_resist_compensation = math.max(compensation * 100, 0)
	end
end

function modifier_imba_pipe_active_bonus:GetModifierMagicalResistanceBonus()
	return self.magic_resist_compensation
end
