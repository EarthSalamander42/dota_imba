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

item_imba_hood_of_defiance = item_imba_hood_of_defiance or class({})
LinkLuaModifier("modifier_imba_hood_of_defiance_passive", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hood_of_defiance_active_shield", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hood_of_defiance_active_bonus", "components/items/item_hood_of_defiance.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_hood_of_defiance:GetIntrinsicModifierName()
	return "modifier_imba_hood_of_defiance_passive"
end

function item_imba_hood_of_defiance:OnSpellStart()
	local caster = self:GetCaster()
	local shield_health = self:GetSpecialValueFor("shield_health")
	local duration = self:GetSpecialValueFor("duration")
	local unreducable_magic_resist = self:GetSpecialValueFor("unreducable_magic_resist")

	EmitSoundOn("DOTA_Item.Pipe.Activate", caster)

	caster:AddNewModifier(caster, self, "modifier_imba_hood_of_defiance_active_shield", {duration = duration, shield_health = shield_health})
	caster:AddNewModifier(caster, self, "modifier_imba_hood_of_defiance_active_bonus", {duration = duration, unreducable_magic_resist = unreducable_magic_resist})
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance stats modifier
-----------------------------------------------------------------------------------------------------------
modifier_imba_hood_of_defiance_passive = modifier_imba_hood_of_defiance_passive or class({})

function modifier_imba_hood_of_defiance_passive:IsDebuff() return false end
function modifier_imba_hood_of_defiance_passive:IsHidden() return true end
function modifier_imba_hood_of_defiance_passive:IsPurgable() return false end
function modifier_imba_hood_of_defiance_passive:IsPurgeException() return false end
function modifier_imba_hood_of_defiance_passive:RemoveOnDeath() return false end
function modifier_imba_hood_of_defiance_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_hood_of_defiance_passive:OnCreated( params )
	self.parent = self:GetParent()
	self.passive_tenacity_pct = self:GetAbility():GetSpecialValueFor("passive_tenacity_pct")
	self.active_tenacity_pct = self:GetAbility():GetSpecialValueFor("active_tenacity_pct")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_magic_resist = self:GetAbility():GetSpecialValueFor("bonus_magic_resist")
end

function modifier_imba_hood_of_defiance_passive:GetModifierStatusResistanceStacking()
	if self.parent:HasModifier("modifier_imba_hood_of_defiance_active_bonus") then
		return self.active_tenacity_pct
	end

	return self.passive_tenacity_pct
end

function modifier_imba_hood_of_defiance_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return funcs
end

function modifier_imba_hood_of_defiance_passive:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_imba_hood_of_defiance_passive:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_resist
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance active shield that protects from spell damage
-----------------------------------------------------------------------------------------------------------
modifier_imba_hood_of_defiance_active_shield = modifier_imba_hood_of_defiance_active_shield or class({})

function modifier_imba_hood_of_defiance_active_shield:IsDebuff() return false end
function modifier_imba_hood_of_defiance_active_shield:IsHidden() return false end
function modifier_imba_hood_of_defiance_active_shield:IsPurgable() return false end
function modifier_imba_hood_of_defiance_active_shield:IsPurgeException() return false end

function modifier_imba_hood_of_defiance_active_shield:OnCreated( params )
	local barrier_particle = "particles/items2_fx/pipe_of_insight.vpcf"
	self.parent = self:GetParent()

	if IsServer() then
		self.shield_health = params.shield_health

		if not self.particle then
			self.particle = ParticleManager:CreateParticle(barrier_particle, PATTACH_OVERHEAD_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.particle, 2, Vector(self.parent:GetModelRadius() * 1.1,0,0))
		end
	end
end

function modifier_imba_hood_of_defiance_active_shield:OnDestroy( params )
	if self.particle and IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

-- Don't override pipe's higher potency shield, unless it'c current health is lower than the new one
function modifier_imba_hood_of_defiance_active_shield:OnRefresh( params )
	if IsServer() and self.shield_health < params.shield_health then
		self.shield_health = params.shield_health
	end
end

-- Shield absorption, returns damage to deal to the victim (in DamageFilter)
function modifier_imba_hood_of_defiance_active_shield:AbsorbDamage(damage)
	if IsServer() then
		local new_health = self.shield_health - damage
		if new_health > 0 then
			self.shield_health = new_health
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self.parent, damage, nil)
			return 0
		else
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self.parent, self.shield_health, nil)
			self:Destroy()
			return -(new_health)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance active bonus that increases tenacity and makes the magic resistance unreducable
--  (by calculating a compensation)
-----------------------------------------------------------------------------------------------------------
modifier_imba_hood_of_defiance_active_bonus = modifier_imba_hood_of_defiance_active_bonus or class({})

function modifier_imba_hood_of_defiance_active_bonus:IsDebuff() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsHidden() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsPurgable() return false end
function modifier_imba_hood_of_defiance_active_bonus:IsPurgeException() return false end

function modifier_imba_hood_of_defiance_active_bonus:OnCreated()
	self.magic_resist_compensation = 0
	self.precision = 0.5 / 100 -- margin of 0.5% magic resistance. This is to prevent rounding-related errors/recalculations
	self.parent = self:GetParent()

	self.unreducable_magic_resist = self:GetAbility():GetSpecialValueFor("unreducable_magic_resist")
	self.unreducable_magic_resist = self.unreducable_magic_resist / 100
	self:StartIntervalThink(0.1)
end

function modifier_imba_hood_of_defiance_active_bonus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_imba_hood_of_defiance_active_bonus:OnIntervalThink()
	-- No Sell. If you want item-dropping shenanigans, get Pipe
	if not self.parent:HasModifier("modifier_imba_hood_of_defiance_passive") then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end

	-- If we are under the effect of the stronger bonus of pipe, reset ourseleves and do nothing
	if self.parent:HasModifier("modifier_imba_pipe_active_bonus") then
		self.magic_resist_compensation = 0
		return
	end

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

function modifier_imba_hood_of_defiance_active_bonus:GetModifierMagicalResistanceBonus()
	return self.magic_resist_compensation
end
