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
	return "imba_stout_shield"
end

function item_imba_stout_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_stout_shield" end

-----------------------------------------------------------------------------------------------------------
--	Stout Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_stout_shield == nil then modifier_item_imba_stout_shield = class({}) end

function modifier_item_imba_stout_shield:IsHidden()		return true end
function modifier_item_imba_stout_shield:IsPurgable()		return false end
function modifier_item_imba_stout_shield:RemoveOnDeath()	return false end
function modifier_item_imba_stout_shield:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- -- Custom unique damage block property
-- function modifier_item_imba_stout_shield:GetCustomDamageBlockUnique()
	-- return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Declare modifier events/properties
function modifier_item_imba_stout_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_imba_stout_shield:GetModifierPhysical_ConstantBlock()
	if self:GetAbility() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("block_chance"), self) then
		if not self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("damage_block_melee")
		else
			return self:GetAbility():GetSpecialValueFor("damage_block_ranged")
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield definition
-----------------------------------------------------------------------------------------------------------

if item_imba_poor_mans_shield == nil then item_imba_poor_mans_shield = class({}) end
LinkLuaModifier( "modifier_item_imba_poor_mans_shield", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )	-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_poor_mans_shield_active", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )

modifier_item_imba_poor_mans_shield_active	= class({})

function item_imba_poor_mans_shield:GetAbilityTextureName()
	return "imba_poor_mans_shield"
end

function item_imba_poor_mans_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_poor_mans_shield" end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_poor_mans_shield == nil then modifier_item_imba_poor_mans_shield = class({}) end

function modifier_item_imba_poor_mans_shield:IsHidden()		return true end
function modifier_item_imba_poor_mans_shield:IsPurgable()		return false end
function modifier_item_imba_poor_mans_shield:RemoveOnDeath()	return false end
function modifier_item_imba_poor_mans_shield:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_poor_mans_shield:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.bonus_agility			= self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.damage_block_melee		= self:GetAbility():GetSpecialValueFor("damage_block_melee")
	self.damage_block_ranged	= self:GetAbility():GetSpecialValueFor("damage_block_ranged")
	self.block_chance			= self:GetAbility():GetSpecialValueFor("block_chance")
	self.bonus_block_melee		= self:GetAbility():GetSpecialValueFor("bonus_block_melee")
	self.bonus_block_range		= self:GetAbility():GetSpecialValueFor("bonus_block_range")
	self.bonus_block_duration	= self:GetAbility():GetSpecialValueFor("bonus_block_duration")
end

-- -- Custom unique damage block property
-- function modifier_item_imba_poor_mans_shield:GetCustomDamageBlockUnique()
	-- return self.damage_block end

-- Declare modifier events/properties
function modifier_item_imba_poor_mans_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_imba_poor_mans_shield:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_poor_mans_shield:GetModifierPhysical_ConstantBlock(keys)
	if keys.attacker:IsHero() and self:GetAbility() and self:GetAbility():IsCooldownReady() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_poor_mans_shield_active", {duration = self.bonus_block_duration})
		self:GetAbility():UseResources(false, false, false, true)
	end
	
	if RollPseudoRandom(self.block_chance, self) then
		if not self:GetParent():IsRangedAttacker() then
			return self.damage_block_melee + ((self:GetParent():HasModifier("modifier_item_imba_poor_mans_shield_active") and self.bonus_block_melee) or 0)
		else
			return self.damage_block_ranged + ((self:GetParent():HasModifier("modifier_item_imba_poor_mans_shield_active") and self.bonus_block_range) or 0)
		end
	end
end

------------------------------------------------
-- MODIFIER_ITEM_IMBA_POOR_MANS_SHIELD_ACTIVE --
------------------------------------------------

function modifier_item_imba_poor_mans_shield_active:GetTexture()
	return "modifiers/imba_poor_mans_shield"
end

-----------------------------------------------------------------------------------------------------------
--	Vanguard definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vanguard == nil then item_imba_vanguard = class({}) end
LinkLuaModifier( "modifier_item_imba_vanguard", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_vanguard:GetAbilityTextureName()
	return "imba_vanguard"
end

function item_imba_vanguard:GetIntrinsicModifierName()
	return "modifier_item_imba_vanguard" end

-----------------------------------------------------------------------------------------------------------
--	Vanguard owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vanguard == nil then modifier_item_imba_vanguard = class({}) end

function modifier_item_imba_vanguard:IsHidden()		return true end
function modifier_item_imba_vanguard:IsPurgable()		return false end
function modifier_item_imba_vanguard:RemoveOnDeath()	return false end
function modifier_item_imba_vanguard:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- -- Custom unique damage block property
-- function modifier_item_imba_vanguard:GetCustomDamageBlockUnique()
	-- return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Declare modifier events/properties
function modifier_item_imba_vanguard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_imba_vanguard:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("health")
	end
end

function modifier_item_imba_vanguard:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("health_regen")
	end
end

function modifier_item_imba_vanguard:GetModifierPhysical_ConstantBlock()
	if self:GetAbility() then
		if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("block_chance"), self) then
			if not self:GetParent():IsRangedAttacker() then
				return self:GetAbility():GetSpecialValueFor("block_damage_melee")
			else
				return self:GetAbility():GetSpecialValueFor("block_damage_ranged")
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard definition
-----------------------------------------------------------------------------------------------------------

if item_imba_crimson_guard == nil then item_imba_crimson_guard = class({}) end
LinkLuaModifier( "modifier_item_imba_crimson_guard", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_crimson_guard_buff", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )		-- Active allied buff
LinkLuaModifier("modifier_item_imba_sogat_cuirass_nostack", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)	-- Nostack modifier for Guard Active

function item_imba_crimson_guard:GetIntrinsicModifierName()
	return "modifier_item_imba_crimson_guard" end

function item_imba_crimson_guard:OnSpellStart(keys)
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
			if not non_relevant_units[ally:GetUnitName()] and not ally:HasModifier("modifier_item_imba_sogat_cuirass_nostack") then
				ally:AddNewModifier(caster, self, "modifier_item_imba_crimson_guard_buff", {duration = duration})
				ally:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_sogat_cuirass_nostack", {duration = self:GetEffectiveCooldown(self:GetLevel() - 1)})
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_crimson_guard == nil then modifier_item_imba_crimson_guard = class({}) end

function modifier_item_imba_crimson_guard:IsHidden()		return true end
function modifier_item_imba_crimson_guard:IsPurgable()		return false end
function modifier_item_imba_crimson_guard:RemoveOnDeath()	return false end
function modifier_item_imba_crimson_guard:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_crimson_guard:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.health					= self:GetAbility():GetSpecialValueFor("health")
	self.health_regen			= self:GetAbility():GetSpecialValueFor("health_regen")
--	self.bonus_stats			= self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.armor					= self:GetAbility():GetSpecialValueFor("armor")
	self.block_damage_melee 	= self:GetAbility():GetSpecialValueFor("block_damage_melee")
	self.block_damage_ranged 	= self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	self.block_chance 			= self:GetAbility():GetSpecialValueFor("block_chance")
	self.damage_reduction 		= self:GetAbility():GetSpecialValueFor("damage_reduction")
end

-- -- Custom unique damage block property
-- function modifier_item_imba_crimson_guard:GetCustomDamageBlockUnique()
	-- return self.damage_block end

-- Custom unique damage reduction property
function modifier_item_imba_crimson_guard:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction end

-- Declare modifier events/properties
function modifier_item_imba_crimson_guard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
--		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
--		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_imba_crimson_guard:GetModifierHealthBonus()
	return self.health end

function modifier_item_imba_crimson_guard:GetModifierConstantHealthRegen()
	return self.health_regen end

function modifier_item_imba_crimson_guard:GetModifierPhysicalArmorBonus()
	return self.armor end

--[[
function modifier_item_imba_crimson_guard:GetModifierBonusStats_Strength()
	return self.bonus_stats end

function modifier_item_imba_crimson_guard:GetModifierBonusStats_Agility()
	return self.bonus_stats end

function modifier_item_imba_crimson_guard:GetModifierBonusStats_Intellect()
	return self.bonus_stats end
--]]

function modifier_item_imba_crimson_guard:GetModifierPhysical_ConstantBlock()
	if RollPseudoRandom(self.block_chance, self) then
		if not self:GetParent():IsRangedAttacker() then
			return self.block_damage_melee
		else
			return self.block_damage_ranged
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Crimson Guard active buff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_crimson_guard_buff == nil then modifier_item_imba_crimson_guard_buff = class({}) end
function modifier_item_imba_crimson_guard_buff:IsDebuff() return false end
function modifier_item_imba_crimson_guard_buff:IsPurgable() return false end

-- Particle creation and value storage
function modifier_item_imba_crimson_guard_buff:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.active_armor 					= self:GetAbility():GetSpecialValueFor("active_armor")
	self.block_damage_melee_active 		= self:GetAbility():GetSpecialValueFor("block_damage_melee_active")
	self.block_damage_ranged_active 	= self:GetAbility():GetSpecialValueFor("block_damage_ranged_active")
	self.block_chance_active 			= self:GetAbility():GetSpecialValueFor("block_chance_active")
	self.damage_reduction 				= self:GetAbility():GetSpecialValueFor("damage_reduction")
	
	if IsServer() then
		self.crimson_guard_pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.crimson_guard_pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.crimson_guard_pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)self:AddParticle(self.crimson_guard_pfx, false, false, -1, false, false)
	end
end

-- -- Custom unique damage block property
-- function modifier_item_imba_crimson_guard_buff:GetCustomDamageBlockUnique()
	-- return self.damage_block end

-- Custom unique damage reduction property
function modifier_item_imba_crimson_guard_buff:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction
end

-- Declare modifier events/properties
function modifier_item_imba_crimson_guard_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_crimson_guard_buff:GetModifierPhysicalArmorBonusUniqueActive()
	return self.active_armor
end

function modifier_item_imba_crimson_guard_buff:GetModifierPhysical_ConstantBlock()
	if IsClient() then return self.block_damage_melee_active end
	
	if RollPseudoRandom(self.block_chance_active, self) then
		if not self:GetParent():IsRangedAttacker() then
			return self.block_damage_melee_active
		else
			return self.block_damage_ranged_active
		end
	end
end

function modifier_item_imba_crimson_guard_buff:OnTooltip()
	return self.damage_reduction
end

-- -----------------------------------------------------------------------------------------------------------
-- --	Tutela Plate definition
-- -----------------------------------------------------------------------------------------------------------

-- if item_imba_greatwyrm_plate == nil then item_imba_greatwyrm_plate = class({}) end
-- LinkLuaModifier( "modifier_item_imba_greatwyrm_plate", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
-- LinkLuaModifier( "modifier_item_imba_greatwyrm_plate_buff", "components/items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )		-- Active allied buff

-- function item_imba_greatwyrm_plate:GetAbilityTextureName()
	-- return "imba_greatwyrm_plate"
-- end

-- function item_imba_greatwyrm_plate:GetIntrinsicModifierName()
	-- return "modifier_item_imba_greatwyrm_plate" end

-- function item_imba_greatwyrm_plate:OnSpellStart(keys)
	-- if IsServer() then

		-- -- Parameters
		-- local caster = self:GetCaster()
		-- local caster_loc = caster:GetAbsOrigin()
		-- local active_radius = self:GetSpecialValueFor("active_radius")
		-- local duration = self:GetSpecialValueFor("duration")

		-- local non_relevant_units = {["npc_imba_alchemist_greevil"] = true}

		-- -- Play sound
		-- caster:EmitSound("Item.CrimsonGuard.Cast")

		-- -- Play particle
		-- local cast_pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active_launch.vpcf", PATTACH_ABSORIGIN, caster)
		-- ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
		-- ParticleManager:SetParticleControl(cast_pfx, 1, caster_loc)
		-- ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))
		-- ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- -- Apply the active buff to nearby allies
		-- local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		-- for _,ally in pairs(nearby_allies) do
			-- if not non_relevant_units[ally:GetUnitName()] then
				-- ally:RemoveModifierByName("modifier_item_imba_crimson_guard_buff")
				-- ally:AddNewModifier(caster, self, "modifier_item_imba_greatwyrm_plate_buff", {duration = duration})
			-- end
		-- end
	-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Tutela Plate owner bonus attributes (stackable)
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_greatwyrm_plate == nil then modifier_item_imba_greatwyrm_plate = class({}) end
-- function modifier_item_imba_greatwyrm_plate:IsHidden() return true end
-- function modifier_item_imba_greatwyrm_plate:IsDebuff() return false end
-- function modifier_item_imba_greatwyrm_plate:IsPurgable() return false end
-- function modifier_item_imba_greatwyrm_plate:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_item_imba_greatwyrm_plate:OnCreated()
	-- self.health = self:GetAbility():GetSpecialValueFor("health")
	-- self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	-- self.armor = self:GetAbility():GetSpecialValueFor("armor")
	-- self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	-- self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	-- self.block_damage_melee 	= self:GetAbility():GetSpecialValueFor("block_damage_melee")
	-- self.block_damage_ranged 	= self:GetAbility():GetSpecialValueFor("block_damage_ranged")
	-- self.block_chance 			= self:GetAbility():GetSpecialValueFor("block_chance")
-- end

-- -- Custom unique damage block property
-- -- function modifier_item_imba_greatwyrm_plate:GetCustomDamageBlockUnique()
	-- -- return self:GetAbility():GetSpecialValueFor("damage_block") end

-- -- Custom unique damage reduction property
-- function modifier_item_imba_greatwyrm_plate:GetCustomIncomingDamageReductionUnique()
	-- return self:GetAbility():GetSpecialValueFor("damage_reduction") end

-- -- Custom tenacity property
-- function modifier_item_imba_greatwyrm_plate:GetModifierStatusResistanceStacking()
	-- return self:GetAbility():GetSpecialValueFor("tenacity") end

-- -- Declare modifier events/properties
-- function modifier_item_imba_greatwyrm_plate:DeclareFunctions()
	-- return {
		-- MODIFIER_PROPERTY_HEALTH_BONUS,
		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	-- }
-- end

-- function modifier_item_imba_greatwyrm_plate:GetModifierHealthBonus()
	-- return self.health end

-- function modifier_item_imba_greatwyrm_plate:GetModifierConstantHealthRegen()
	-- return self.health_regen end

-- function modifier_item_imba_greatwyrm_plate:GetModifierPhysicalArmorBonus()
	-- return self.armor end

-- function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Strength()
	-- return self.bonus_stats + self.bonus_strength end

-- function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Agility()
	-- return self.bonus_stats end

-- function modifier_item_imba_greatwyrm_plate:GetModifierBonusStats_Intellect()
	-- return self.bonus_stats end
	
-- function modifier_item_imba_greatwyrm_plate:GetModifierPhysical_ConstantBlock()
	-- if RollPseudoRandom(self.block_chance, self) then
		-- if not self:GetParent():IsRangedAttacker() then
			-- return self.damage_block_melee
		-- else
			-- return self.damage_block_ranged
		-- end
	-- end
-- end

-- -----------------------------------------------------------------------------------------------------------
-- --	Tutela Plate active buff
-- -----------------------------------------------------------------------------------------------------------

-- if modifier_item_imba_greatwyrm_plate_buff == nil then modifier_item_imba_greatwyrm_plate_buff = class({}) end
-- function modifier_item_imba_greatwyrm_plate_buff:IsHidden() return false end
-- function modifier_item_imba_greatwyrm_plate_buff:IsDebuff() return false end
-- function modifier_item_imba_greatwyrm_plate_buff:IsPurgable() return false end

-- -- Particle creation and value storage
-- function modifier_item_imba_greatwyrm_plate_buff:OnCreated(keys)
	-- self.block_damage_melee_active 		= self:GetAbility():GetSpecialValueFor("block_damage_melee_active")
	-- self.block_damage_ranged_active 	= self:GetAbility():GetSpecialValueFor("block_damage_ranged_active")
	-- self.block_chance_active 			= self:GetAbility():GetSpecialValueFor("block_chance_active")
	
	-- self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	-- self.tenacity = self:GetAbility():GetSpecialValueFor("tenacity")
	-- self.active_armor = self:GetAbility():GetSpecialValueFor("active_armor")

	-- if IsServer() then
		-- self.greatwyrm_plate_pfx = ParticleManager:CreateParticle("particles/item/greatwyrm_plate/greatwyrm_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControl(self.greatwyrm_plate_pfx, 0, self:GetParent():GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(self.greatwyrm_plate_pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		-- self:AddParticle(self.greatwyrm_plate_pfx, false, false, -1, false, false)
	-- end
-- end

-- -- -- Custom unique damage block property
-- -- function modifier_item_imba_greatwyrm_plate_buff:GetCustomDamageBlockUnique()
	-- -- return self.damage_block end

-- -- Custom unique damage reduction property
-- function modifier_item_imba_greatwyrm_plate_buff:GetCustomIncomingDamageReductionUnique()
	-- return self.damage_reduction end

-- -- Declare modifier events/properties
-- function modifier_item_imba_greatwyrm_plate_buff:DeclareFunctions()
	-- return {
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		-- MODIFIER_PROPERTY_TOOLTIP
	-- }
-- end

-- function modifier_item_imba_greatwyrm_plate_buff:GetModifierPhysicalArmorBonusUniqueActive()
	-- return self.active_armor end

-- function modifier_item_imba_greatwyrm_plate_buff:GetModifierPhysical_ConstantBlock()
	-- if RollPseudoRandom(self.block_chance_active, self) then
		-- if not self:GetParent():IsRangedAttacker() then
			-- return self.block_damage_melee_active
		-- else
			-- return self.block_damage_ranged_active
		-- end
	-- end
-- end

-- function modifier_item_imba_greatwyrm_plate_buff:OnTooltip()
	-- return self.damage_reduction
-- end
