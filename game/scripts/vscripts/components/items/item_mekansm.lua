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

--	Author: Rook
--	Date: 			26.01.2015		<-- Dinosaurs roamed the earth
--	Converted to lua by Firetoad
--	Last Update:	26.03.2017
--	Mekansm and Guardian Greaves

-----------------------------------------------------------------------------------------------------------
--	Mekansm definition
-----------------------------------------------------------------------------------------------------------

if item_imba_mekansm == nil then item_imba_mekansm = class({}) end
LinkLuaModifier( "modifier_item_imba_mekansm", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_mekansm_aura_emitter", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_imba_mekansm_aura", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff
LinkLuaModifier( "modifier_item_imba_mekansm_heal", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Heal buff

function item_imba_mekansm:GetIntrinsicModifierName()
	return "modifier_item_imba_mekansm"
end

function item_imba_mekansm:OnSpellStart()
	if IsServer() then
		-- Parameters
		local heal_amount = self:GetSpecialValueFor("heal_amount") * (1 + self:GetCaster():GetSpellAmplification(false) * 0.01)
		local heal_radius = self:GetSpecialValueFor("heal_radius")
		local heal_duration = self:GetSpecialValueFor("heal_duration")

		-- Play activation sound and particle
		self:GetCaster():EmitSound("DOTA_Item.Mekansm.Activate")

		local mekansm_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
		ParticleManager:ReleaseParticleIndex(mekansm_pfx)

		-- Iterate through nearby allies
		local caster_loc = self:GetCaster():GetAbsOrigin()
		local nearby_allies = FindUnitsInRadius(self:GetCaster():GetTeam(), caster_loc, nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do
			-- Heal the ally
			ally:Heal(heal_amount, self:GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)

			-- Play healing sound & particle
			ally:EmitSound("DOTA_Item.Mekansm.Target")

			local mekansm_target_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally, self:GetCaster())
			ParticleManager:SetParticleControl(mekansm_target_pfx, 0, caster_loc)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 1, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(mekansm_target_pfx)

			-- Apply armor & heal over time buff
			ally:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_mekansm_heal", {duration = heal_duration})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mekansm owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm == nil then modifier_item_imba_mekansm = class({}) end

function modifier_item_imba_mekansm:IsHidden()			return true end
function modifier_item_imba_mekansm:IsPurgable()		return false end
function modifier_item_imba_mekansm:RemoveOnDeath()	return false end
function modifier_item_imba_mekansm:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_imba_mekansm:OnCreated(keys)
	if not self:GetAbility() then
		if IsServer() then
			self:Destroy()
		end

		return
	end

--	self.bonus_all_stats	= self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_armor		= self:GetAbility():GetSpecialValueFor("bonus_armor")

	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_mekansm_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_mekansm_aura_emitter", {})
		end
	end

	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

-- Removes the aura emitter from the caster if this is the last mekansm in its inventory
function modifier_item_imba_mekansm:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_mekansm") then
			parent:RemoveModifierByName("modifier_item_imba_mekansm_aura_emitter")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		--MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		--MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

--[[
function modifier_item_imba_mekansm:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_imba_mekansm:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_imba_mekansm:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end
--]]

function modifier_item_imba_mekansm:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_aura_emitter == nil then modifier_item_imba_mekansm_aura_emitter = class({}) end
function modifier_item_imba_mekansm_aura_emitter:IsAura() return true end
function modifier_item_imba_mekansm_aura_emitter:IsHidden() return true end
function modifier_item_imba_mekansm_aura_emitter:IsDebuff() return false end
function modifier_item_imba_mekansm_aura_emitter:IsPurgable() return false end

function modifier_item_imba_mekansm_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_imba_mekansm_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_item_imba_mekansm_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_imba_mekansm_aura"
		else
			return
		end
	end
end

function modifier_item_imba_mekansm_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_aura == nil then modifier_item_imba_mekansm_aura = class({}) end
function modifier_item_imba_mekansm_aura:IsHidden() return false end
function modifier_item_imba_mekansm_aura:IsDebuff() return false end
function modifier_item_imba_mekansm_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_mekansm_aura:GetTexture()
	return "item_mekansm"
end

-- Stores the aura's parameters to prevent errors when the item is destroyed
function modifier_item_imba_mekansm_aura:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	self.aura_health_regen = self:GetAbility():GetSpecialValueFor("aura_health_regen")
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_item_imba_mekansm_aura:GetModifierConstantHealthRegen()
	return self.aura_health_regen end

-----------------------------------------------------------------------------------------------------------
--	Mekansm heal over time
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_heal == nil then modifier_item_imba_mekansm_heal = class({}) end
function modifier_item_imba_mekansm_heal:IsHidden() return false end
function modifier_item_imba_mekansm_heal:IsDebuff() return false end
function modifier_item_imba_mekansm_heal:IsPurgable() return true end

-- Modifier texture
function modifier_item_imba_mekansm_heal:GetTexture()
	return "item_mekansm" end

-- Stores the ability's parameters to prevent errors if the item is destroyed
function modifier_item_imba_mekansm_heal:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	self.heal_bonus_armor = self:GetAbility():GetSpecialValueFor("heal_bonus_armor")
	self.heal_percentage = self:GetAbility():GetSpecialValueFor("heal_percentage")
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
	}
end

function modifier_item_imba_mekansm_heal:GetModifierHealthRegenPercentage()
	return self.heal_percentage end

function modifier_item_imba_mekansm_heal:GetModifierPhysicalArmorBonusUniqueActive()
	return self.heal_bonus_armor end



-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves definition
-----------------------------------------------------------------------------------------------------------

if item_imba_guardian_greaves == nil then item_imba_guardian_greaves = class({}) end
LinkLuaModifier( "modifier_item_imba_guardian_greaves", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_guardian_greaves_aura_emitter", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_imba_guardian_greaves_aura", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff
LinkLuaModifier( "modifier_item_imba_guardian_greaves_heal", "components/items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Heal buff

function item_imba_guardian_greaves:GetIntrinsicModifierName()
	return "modifier_item_imba_guardian_greaves"
end

function item_imba_guardian_greaves:OnAbilityPhaseStart()
	if self:GetCaster():IsClone() then
		return false
	end

	return true
end

function item_imba_guardian_greaves:OnSpellStart()
	if IsServer() then

		-- Parameters
		local heal_amount = self:GetSpecialValueFor("replenish_health") * (1 + self:GetCaster():GetSpellAmplification(false) * 0.01)
		local mana_amount = self:GetSpecialValueFor("replenish_mana") + self:GetSpecialValueFor("mend_mana_pct") * self:GetCaster():GetMaxMana() * 0.01
		local heal_radius = self:GetSpecialValueFor("aura_radius")
		local heal_duration = self:GetSpecialValueFor("mend_duration")

		-- Cast Mend
		GreavesActivate(self:GetCaster(), self, heal_amount, mana_amount, heal_radius, heal_duration)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_guardian_greaves == nil then modifier_item_imba_guardian_greaves = class({}) end

function modifier_item_imba_guardian_greaves:IsHidden()			return true end
function modifier_item_imba_guardian_greaves:IsPurgable()		return false end
function modifier_item_imba_guardian_greaves:RemoveOnDeath()	return false end
function modifier_item_imba_guardian_greaves:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_imba_guardian_greaves:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	self.bonus_movement		= self:GetAbility():GetSpecialValueFor("bonus_movement")
	self.bonus_mana			= self:GetAbility():GetSpecialValueFor("bonus_mana")
--	self.bonus_all_stats	= self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.bonus_armor		= self:GetAbility():GetSpecialValueFor("bonus_armor")

	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_guardian_greaves_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_guardian_greaves_aura_emitter", {})
		end
	end

	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

-- Removes the aura emitter from the caster if this is the last greaves in its inventory
function modifier_item_imba_guardian_greaves:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_guardian_greaves") then
			parent:RemoveModifierByName("modifier_item_imba_guardian_greaves_aura_emitter")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_guardian_greaves:DeclareFunctions()
	return {
		--MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		--MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		--MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_imba_guardian_greaves:GetModifierMoveSpeedBonus_Special_Boots()
	return self.bonus_movement end

function modifier_item_imba_guardian_greaves:GetModifierManaBonus()
	return self.bonus_mana end

--[[
function modifier_item_imba_guardian_greaves:GetModifierBonusStats_Strength()
	return self.bonus_all_stats end

function modifier_item_imba_guardian_greaves:GetModifierBonusStats_Agility()
	return self.bonus_all_stats end

function modifier_item_imba_guardian_greaves:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats end
--]]

function modifier_item_imba_guardian_greaves:GetModifierPhysicalArmorBonus()
	return self.bonus_armor end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_guardian_greaves_aura_emitter == nil then modifier_item_imba_guardian_greaves_aura_emitter = class({}) end
function modifier_item_imba_guardian_greaves_aura_emitter:IsAura() return true end
function modifier_item_imba_guardian_greaves_aura_emitter:IsHidden() return true end
function modifier_item_imba_guardian_greaves_aura_emitter:IsDebuff() return false end
function modifier_item_imba_guardian_greaves_aura_emitter:IsPurgable() return false end

function modifier_item_imba_guardian_greaves_aura_emitter:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	self.aura_radius			= self:GetAbility():GetSpecialValueFor("aura_radius")
	self.aura_bonus_threshold	= self:GetAbility():GetSpecialValueFor("aura_bonus_threshold")
	self.replenish_health		= self:GetAbility():GetSpecialValueFor("replenish_health")
	self.replenish_mana			= self:GetAbility():GetSpecialValueFor("replenish_mana")
	self.mend_mana_pct			= self:GetAbility():GetSpecialValueFor("mend_mana_pct")
	self.mend_duration			= self:GetAbility():GetSpecialValueFor("mend_duration")
end

function modifier_item_imba_guardian_greaves_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_imba_guardian_greaves_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_imba_guardian_greaves_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_imba_guardian_greaves_aura"
		else
			return
		end
	end
end

function modifier_item_imba_guardian_greaves_aura_emitter:GetAuraRadius()
	if not self:GetAbility() then return 0 end
	
	return self.aura_radius
end

-- Declare modifier events/properties
function modifier_item_imba_guardian_greaves_aura_emitter:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

-- Psssive activation when below the threshold
function modifier_item_imba_guardian_greaves_aura_emitter:OnTakeDamage( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if owner ~= keys.unit then
			return end

		-- If this is an illusion, do nothing
		if owner:IsIllusion() then
			return end

		-- If the owner's health is below the threshold, and Mend is off cooldown, activate it
		local ability = self:GetAbility()
		if owner:GetHealthPercent() <= self.aura_bonus_threshold and owner:GetHealthPercent() > 0 and ability:IsCooldownReady() and owner:GetMana() >= ability:GetManaCost(-1) then
			GreavesActivate(owner, ability, self.replenish_health, self.replenish_mana + self.mend_mana_pct * owner:GetMaxMana() * 0.01, self.aura_radius, self.mend_duration)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_guardian_greaves_aura == nil then modifier_item_imba_guardian_greaves_aura = class({}) end
function modifier_item_imba_guardian_greaves_aura:IsHidden() return false end
function modifier_item_imba_guardian_greaves_aura:IsDebuff() return false end
function modifier_item_imba_guardian_greaves_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_guardian_greaves_aura:GetTexture()
	return "item_guardian_greaves"
end

-- Stores the aura's parameters to prevent errors when the item is destroyed
function modifier_item_imba_guardian_greaves_aura:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	local ability = self:GetAbility()
	
	self.aura_health_regen = ability:GetSpecialValueFor("aura_health_regen")
	self.aura_armor = ability:GetSpecialValueFor("aura_armor")
	self.aura_health_regen_bonus = ability:GetSpecialValueFor("aura_health_regen_bonus")
	self.aura_armor_bonus = ability:GetSpecialValueFor("aura_armor_bonus")
	self.aura_bonus_threshold = ability:GetSpecialValueFor("aura_bonus_threshold")
end

-- Declare modifier events/properties
function modifier_item_imba_guardian_greaves_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_imba_guardian_greaves_aura:GetModifierPhysicalArmorBonus()
	local owner = self:GetParent()

	-- Hero-only health-scaling bonus
	if owner:IsRealHero() then
		local bonus_power = (1 - math.max(owner:GetHealthPercent(), self.aura_bonus_threshold) * 0.01) / (1 - self.aura_bonus_threshold * 0.01)
		return self.aura_armor + (self.aura_armor_bonus - self.aura_armor) * bonus_power
	end

	return self.aura_armor
end

function modifier_item_imba_guardian_greaves_aura:GetModifierConstantHealthRegen()
	local owner = self:GetParent()

	-- Hero-only health-scaling bonus
	if owner:IsRealHero() then
		local bonus_power = (1 - math.max(owner:GetHealthPercent(), self.aura_bonus_threshold) * 0.01) / (1 - self.aura_bonus_threshold * 0.01)
		return self.aura_health_regen + (self.aura_health_regen_bonus - self.aura_health_regen) * bonus_power
	end

	return self.aura_health_regen
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves heal over time
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_guardian_greaves_heal == nil then modifier_item_imba_guardian_greaves_heal = class({}) end
function modifier_item_imba_guardian_greaves_heal:IsHidden() return false end
function modifier_item_imba_guardian_greaves_heal:IsDebuff() return false end
function modifier_item_imba_guardian_greaves_heal:IsPurgable() return true end

-- Modifier texture
function modifier_item_imba_guardian_greaves_heal:GetTexture()
	return "item_guardian_greaves"
end

-- Stores the ability's parameters to prevent errors if the item is destroyed
function modifier_item_imba_guardian_greaves_heal:OnCreated(keys)
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end
	
	self.mend_regen = self:GetAbility():GetSpecialValueFor("mend_regen")
end

-- Declare modifier events/properties
function modifier_item_imba_guardian_greaves_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_item_imba_guardian_greaves_heal:GetModifierHealthRegenPercentage()
	return self.mend_regen
end

-----------------------------------------------------------------------------------------------------------
--	Guardian Greaves active
-----------------------------------------------------------------------------------------------------------

function GreavesActivate(caster, ability, heal_amount, mana_amount, heal_radius, heal_duration)
	-- Purge debuffs from the caster
	caster:Purge(false, true, false, false, false)

	-- Play activation sound and particle
	caster:EmitSound("Item.GuardianGreaves.Activate")

	local cast_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, caster)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	-- Iterate through nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(nearby_allies) do
		-- Heal & replenish mana
		ally:Heal(heal_amount, caster)
		ally:GiveMana(mana_amount)

		-- Show hp & mana overhead messages
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana_amount, nil)

		-- Play target sound
		ally:EmitSound("Item.GuardianGreaves.Target")

		local particle_name 		= "particles/items3_fx/warmage_mana_nonhero.vpcf"
		local particle_name_hero	= "particles/items3_fx/warmage_recipient.vpcf"

		-- Choose target particle
		local particle_target = particle_name
		if ally:IsHero() then
			particle_target = particle_name_hero
		end

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, ally, caster)
		ParticleManager:SetParticleControl(target_pfx, 0, ally:GetAbsOrigin())

		-- Apply heal over time buff
		ally:AddNewModifier(caster, ability, "modifier_item_imba_guardian_greaves_heal", {duration = heal_duration})

		-- start cooldown of GG boots for every meepoes
		if caster:GetUnitName() == "npc_dota_hero_meepo" then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				for i = 0, 5 do
					local item = hero:GetItemInSlot(i)
					if item and item:GetAbilityName() == "item_imba_guardian_greaves" then
						item:UseResources(true, false, false, true)
						break
					end
				end
			end
		else
			ability:UseResources(true, false, false, true)
		end
	end
end
