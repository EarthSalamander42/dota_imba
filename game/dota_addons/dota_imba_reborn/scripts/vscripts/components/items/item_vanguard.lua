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

--	Author: Firetoad
--	Date: 			11.10.2015
--	Last Update:	19.03.2017

-----------------------------------------------------------------------------------------------------------
--	Stout Shield definition
-----------------------------------------------------------------------------------------------------------

if item_imba_stout_shield == nil then item_imba_stout_shield = class({}) end
LinkLuaModifier( "modifier_item_imba_stout_shield", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )	-- Owner's bonus attributes, stackable

function item_imba_stout_shield:GetAbilityTextureName()
	return "custom/imba_stout_shield"
end

function item_imba_stout_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_stout_shield" end

-----------------------------------------------------------------------------------------------------------
--	Stout Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_stout_shield == nil then modifier_item_imba_stout_shield = class({}) end
function modifier_item_imba_stout_shield:IsHidden() return true end
function modifier_item_imba_stout_shield:IsDebuff() return false end
function modifier_item_imba_stout_shield:IsPurgable() return false end
function modifier_item_imba_stout_shield:IsPermanent() return true end
function modifier_item_imba_stout_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Custom unique damage block property
function modifier_item_imba_stout_shield:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield definition
-----------------------------------------------------------------------------------------------------------

if item_imba_poor_mans_shield == nil then item_imba_poor_mans_shield = class({}) end
LinkLuaModifier( "modifier_item_imba_poor_mans_shield", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )	-- Owner's bonus attributes, stackable

function item_imba_poor_mans_shield:GetAbilityTextureName()
	return "custom/imba_poor_mans_shield"
end

function item_imba_poor_mans_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_poor_mans_shield" end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_poor_mans_shield == nil then modifier_item_imba_poor_mans_shield = class({}) end
function modifier_item_imba_poor_mans_shield:IsHidden() return true end
function modifier_item_imba_poor_mans_shield:IsDebuff() return false end
function modifier_item_imba_poor_mans_shield:IsPurgable() return false end
function modifier_item_imba_poor_mans_shield:IsPermanent() return true end
function modifier_item_imba_poor_mans_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_poor_mans_shield:OnCreated()
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_agi")
end

-- Custom unique damage block property
function modifier_item_imba_poor_mans_shield:GetCustomDamageBlockUnique()
	return self.damage_block end

-- Declare modifier events/properties
function modifier_item_imba_poor_mans_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_imba_poor_mans_shield:GetModifierBonusStats_Agility()
	return self.bonus_agi end

-----------------------------------------------------------------------------------------------------------
--	Vanguard definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vanguard == nil then item_imba_vanguard = class({}) end
LinkLuaModifier( "modifier_item_imba_vanguard", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_vanguard:GetAbilityTextureName()
	return "custom/imba_vanguard"
end

function item_imba_vanguard:GetIntrinsicModifierName()
	return "modifier_item_imba_vanguard" end

-----------------------------------------------------------------------------------------------------------
--	Vanguard owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vanguard == nil then modifier_item_imba_vanguard = class({}) end
function modifier_item_imba_vanguard:IsHidden() return true end
function modifier_item_imba_vanguard:IsDebuff() return false end
function modifier_item_imba_vanguard:IsPurgable() return false end
function modifier_item_imba_vanguard:IsPermanent() return true end
function modifier_item_imba_vanguard:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_vanguard:OnCreated()
	self.health = self:GetAbility():GetSpecialValueFor("health")
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
end

-- Custom unique damage block property
function modifier_item_imba_vanguard:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Declare modifier events/properties
function modifier_item_imba_vanguard:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_vanguard:GetModifierHealthBonus()
	return self.health end

function modifier_item_imba_vanguard:GetModifierConstantHealthRegen()
	return self.health_regen end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard definition
-----------------------------------------------------------------------------------------------------------

if item_imba_crimson_guard == nil then item_imba_crimson_guard = class({}) end
LinkLuaModifier( "modifier_item_imba_crimson_guard", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_crimson_guard_buff", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )		-- Active allied buff

function item_imba_crimson_guard:GetIntrinsicModifierName()
	return "modifier_item_imba_crimson_guard" end

function item_imba_crimson_guard:OnSpellStart(keys)
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local active_radius = self:GetSpecialValueFor("active_radius")
		local duration = self:GetSpecialValueFor("duration")

		local non_relevant_units = {["npc_imba_alchemist_greevil"] = true}

		-- Play sound
		caster:EmitSound("Item.CrimsonGuard.Cast")

		-- Play particle
		local cast_pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- Apply the active buff to nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,ally in pairs(nearby_allies) do
			if not ally:HasModifier("modifier_item_imba_sogat_cuirass_buff") then
				if not non_relevant_units[ally:GetUnitName()] then
					ally:AddNewModifier(caster, self, "modifier_item_imba_crimson_guard_buff", {duration = duration})
				end
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_crimson_guard == nil then modifier_item_imba_crimson_guard = class({}) end
function modifier_item_imba_crimson_guard:IsHidden() return true end
function modifier_item_imba_crimson_guard:IsDebuff() return false end
function modifier_item_imba_crimson_guard:IsPurgable() return false end
function modifier_item_imba_crimson_guard:IsPermanent() return true end
function modifier_item_imba_crimson_guard:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_crimson_guard:OnCreated()
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.health = self:GetAbility():GetSpecialValueFor("health")
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
end


-- Custom unique damage block property
function modifier_item_imba_crimson_guard:GetCustomDamageBlockUnique()
	return self.damage_block end

-- Custom unique damage reduction property
function modifier_item_imba_crimson_guard:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction end

-- Declare modifier events/properties
function modifier_item_imba_crimson_guard:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_imba_crimson_guard:GetModifierHealthBonus()
	return self.health end

function modifier_item_imba_crimson_guard:GetModifierConstantHealthRegen()
	return self.health_regen end

function modifier_item_imba_crimson_guard:GetModifierPhysicalArmorBonus()
	return self.armor end

function modifier_item_imba_crimson_guard:GetModifierBonusStats_Strength()
	return self.bonus_stats end

function modifier_item_imba_crimson_guard:GetModifierBonusStats_Agility()
	return self.bonus_stats end

function modifier_item_imba_crimson_guard:GetModifierBonusStats_Intellect()
	return self.bonus_stats end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard active buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_crimson_guard_buff == nil then modifier_item_imba_crimson_guard_buff = class({}) end
function modifier_item_imba_crimson_guard_buff:IsHidden() return true end
function modifier_item_imba_crimson_guard_buff:IsDebuff() return false end
function modifier_item_imba_crimson_guard_buff:IsPurgable() return false end

-- Particle creation and value storage
function modifier_item_imba_crimson_guard_buff:OnCreated(keys)
	if IsServer() then
		local owner = self:GetParent()
		self.crimson_guard_pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, owner)
		ParticleManager:SetParticleControl(self.crimson_guard_pfx, 0, owner:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.crimson_guard_pfx, 1, owner, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", owner:GetAbsOrigin(), true)
	end
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.active_armor = self:GetAbility():GetSpecialValueFor("active_armor")
end

-- Particle destruction
function modifier_item_imba_crimson_guard_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.crimson_guard_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.crimson_guard_pfx)
	end
end

-- Custom unique damage block property
function modifier_item_imba_crimson_guard_buff:GetCustomDamageBlockUnique()
	return self.damage_block end

-- Custom unique damage reduction property
function modifier_item_imba_crimson_guard_buff:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction end

-- Declare modifier events/properties
function modifier_item_imba_crimson_guard_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_imba_crimson_guard_buff:GetModifierPhysicalArmorBonus()
	return self.active_armor end

-- Regular damage block (for towers, redundant on heroes)
function modifier_item_imba_crimson_guard_buff:GetModifierPhysical_ConstantBlock()
	return self.damage_block end

-----------------------------------------------------------------------------------------------------------
--	Tutela Plate definition
-----------------------------------------------------------------------------------------------------------

if item_imba_greatwyrm_plate == nil then item_imba_greatwyrm_plate = class({}) end
LinkLuaModifier( "modifier_item_imba_greatwyrm_plate", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_greatwyrm_plate_buff", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )		-- Active allied buff

function item_imba_greatwyrm_plate:GetAbilityTextureName()
	return "custom/imba_greatwyrm_plate"
end

function item_imba_greatwyrm_plate:GetIntrinsicModifierName()
	return "modifier_item_imba_greatwyrm_plate" end

function item_imba_greatwyrm_plate:OnSpellStart(keys)
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local active_radius = self:GetSpecialValueFor("active_radius")
		local duration = self:GetSpecialValueFor("duration")

		local non_relevant_units = {["npc_imba_alchemist_greevil"] = true}

		-- Play sound
		caster:EmitSound("Item.CrimsonGuard.Cast")

		-- Play particle
		local cast_pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 1, caster_loc)
		ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- Apply the active buff to nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,ally in pairs(nearby_allies) do
			if not non_relevant_units[ally:GetUnitName()] then
				ally:RemoveModifierByName("modifier_item_imba_crimson_guard_buff")
				ally:AddNewModifier(caster, self, "modifier_item_imba_greatwyrm_plate_buff", {duration = duration})
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Tutela Plate owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greatwyrm_plate == nil then modifier_item_imba_greatwyrm_plate = class({}) end
function modifier_item_imba_greatwyrm_plate:IsHidden() return true end
function modifier_item_imba_greatwyrm_plate:IsDebuff() return false end
function modifier_item_imba_greatwyrm_plate:IsPurgable() return false end
function modifier_item_imba_greatwyrm_plate:IsPermanent() return true end
function modifier_item_imba_greatwyrm_plate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_greatwyrm_plate:OnCreated()
	self.health = self:GetAbility():GetSpecialValueFor("health")
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
end

-- Custom unique damage block property
function modifier_item_imba_greatwyrm_plate:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Custom unique damage reduction property
function modifier_item_imba_greatwyrm_plate:GetCustomIncomingDamageReductionUnique()
	return self:GetAbility():GetSpecialValueFor("damage_reduction") end

-- Custom tenacity property
function modifier_item_imba_greatwyrm_plate:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("tenacity") end

-- Declare modifier events/properties
function modifier_item_imba_greatwyrm_plate:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_item_imba_greatwyrm_plate:GetModifierHealthBonus()
	return self.health end

function modifier_item_imba_greatwyrm_plate:GetModifierConstantHealthRegen()
	return self.health_regen end

function modifier_item_imba_greatwyrm_plate:GetModifierPhysicalArmorBonus()
	return self.armor end

function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Strength()
	return self.bonus_stats + self.bonus_strength end

function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Agility()
	return self.bonus_stats end

function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Intellect()
	return self.bonus_stats end

-----------------------------------------------------------------------------------------------------------
--	Tutela Plate active buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_greatwyrm_plate_buff == nil then modifier_item_imba_greatwyrm_plate_buff = class({}) end
function modifier_item_imba_greatwyrm_plate_buff:IsHidden() return false end
function modifier_item_imba_greatwyrm_plate_buff:IsDebuff() return false end
function modifier_item_imba_greatwyrm_plate_buff:IsPurgable() return false end

-- Particle creation and value storage
function modifier_item_imba_greatwyrm_plate_buff:OnCreated(keys)
	if IsServer() then
		local owner = self:GetParent()
		self.greatwyrm_plate_pfx = ParticleManager:CreateParticle("particles/item/greatwyrm_plate/greatwyrm_active.vpcf", PATTACH_OVERHEAD_FOLLOW, owner)
		ParticleManager:SetParticleControl(self.greatwyrm_plate_pfx, 0, owner:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.greatwyrm_plate_pfx, 1, owner, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", owner:GetAbsOrigin(), true)
	end
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.tenacity = self:GetAbility():GetSpecialValueFor("tenacity")
	self.active_armor = self:GetAbility():GetSpecialValueFor("active_armor")
end

-- Particle destruction
function modifier_item_imba_greatwyrm_plate_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.greatwyrm_plate_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.greatwyrm_plate_pfx)
	end
end

-- Custom unique damage block property
function modifier_item_imba_greatwyrm_plate_buff:GetCustomDamageBlockUnique()
	return self.damage_block end

-- Custom unique damage reduction property
function modifier_item_imba_greatwyrm_plate_buff:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction end

-- Custom tenacity property
function modifier_item_imba_greatwyrm_plate_buff:GetModifierStatusResistanceStacking()
	return self.tenacity end

-- Declare modifier events/properties
function modifier_item_imba_greatwyrm_plate_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return funcs
end

function modifier_item_imba_greatwyrm_plate_buff:GetModifierPhysicalArmorBonus()
	return self.active_armor end

-- Regular damage block (for towers, redundant on heroes)
function modifier_item_imba_greatwyrm_plate_buff:GetModifierPhysical_ConstantBlock()
	return self.damage_block end
