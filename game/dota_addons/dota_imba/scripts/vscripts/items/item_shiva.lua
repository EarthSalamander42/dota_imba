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
-- Editors: EarthSalamander #42 (Date: 13.02.2018)
--			AltiV (Date: 02.08.2018)

--[[	Author: Firetoad
		Date:	20.07.2016	]]
		
if item_imba_shivas_guard == nil then item_imba_shivas_guard = class({}) end
LinkLuaModifier("modifier_imba_shiva_handler", "items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shiva_aura", "items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shiva_debuff", "items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shivas_blast_slow", "items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_shivas_guard:GetIntrinsicModifierName()
	return "modifier_imba_shiva_handler"
end

function item_imba_shivas_guard:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	-- Parameters
	local blast_radius = ability:GetSpecialValueFor("blast_radius")
	local blast_speed = ability:GetSpecialValueFor("blast_speed")
	local damage = ability:GetSpecialValueFor("damage")
	local slow_initial_stacks = ability:GetSpecialValueFor("slow_initial_stacks")
	local blast_duration = blast_radius / blast_speed
	local current_loc = caster:GetAbsOrigin()

	-- Play cast sound
	caster:EmitSound("DOTA_Item.ShivasGuard.Activate")

	-- Play particle
	local blast_pfx = ParticleManager:CreateParticle(caster.shiva_blast_effect, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(blast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)

	-- Initialize targets hit table
	local targets_hit = {}

	-- Main blasting loop
	local current_radius = 0
	local tick_interval = 0.1
	Timers:CreateTimer(tick_interval, function()
		-- Give vision
		AddFOWViewer(caster:GetTeamNumber(), current_loc, current_radius, 0.1, false)

		-- Update current radius and location
		current_radius = current_radius + blast_speed * tick_interval
		current_loc = caster:GetAbsOrigin()
		--vision_dummy:SetAbsOrigin(current_loc)

		-- Iterate through enemies in the radius
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			-- Check if this enemy was already hit
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			-- If not, blast it
			if not enemy_has_been_hit then
				-- Play hit particle
				local hit_pfx = ParticleManager:CreateParticle(caster.shiva_hit_effect, PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				-- Deal damage
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(caster, ability, "modifier_item_imba_shivas_blast_slow", {})
				enemy:SetModifierStackCount("modifier_item_imba_shivas_blast_slow", caster, slow_initial_stacks)

				-- Add enemy to the targets hit table
				targets_hit[#targets_hit + 1] = enemy
			end
		end

		-- If the current radius is smaller than the maximum radius, keep going
		if current_radius < blast_radius then
			return tick_interval
		end
	end)
end

function item_imba_shivas_guard:GetAbilityTextureName()
	if not IsClient() then return end
	local caster = self:GetCaster()
	if not caster.shiva_icon_client then return "custom/imba_shiva" end
	return "custom/imba_shiva"..caster.shiva_icon_client
end

-----------------------------------------------------------------------------------------------------------
--	Shiva Handler
-----------------------------------------------------------------------------------------------------------
if modifier_imba_shiva_handler == nil then modifier_imba_shiva_handler = class({}) end
function modifier_imba_shiva_handler:IsHidden() return true end
function modifier_imba_shiva_handler:IsDebuff() return false end
function modifier_imba_shiva_handler:IsPurgable() return false end
function modifier_imba_shiva_handler:RemoveOnDeath() return false end
function modifier_imba_shiva_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shiva_handler:OnCreated()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shiva_aura", {})
	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_imba_shiva_handler:OnIntervalThink()
	local caster = self:GetCaster()
	if caster:IsIllusion() then return end
	if IsServer() then
		self:SetStackCount(caster.shiva_icon)
	end

	if IsClient() then
		local icon = self:GetStackCount()
		if icon == 0 then
			caster.shiva_icon_client = nil
		else
			caster.shiva_icon_client = icon
		end
	end
end

function modifier_imba_shiva_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_imba_shiva_handler:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_imba_shiva_handler:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_imba_shiva_handler:OnDestroy()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_shiva_aura") then
			self:GetCaster():RemoveModifierByName("modifier_imba_shiva_aura")
		end
	end
end

------------------------------------------
-- Shiva's Guard Passive Aura (Handler) --
------------------------------------------

modifier_imba_shiva_aura = class({})

function modifier_imba_shiva_aura:IsAura() return true end

function modifier_imba_shiva_aura:GetModifierAura()
	return "modifier_imba_shiva_debuff"
end

function modifier_imba_shiva_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_shiva_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_shiva_aura:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_shiva_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_shiva_aura:IsHidden() return true end
function modifier_imba_shiva_aura:IsPurgable() return false end
function modifier_imba_shiva_aura:IsPermanent() return true end

---------------------------------------
-- Shiva's Guard Passive Aura Debuff --
---------------------------------------

modifier_imba_shiva_debuff = class({})

function modifier_imba_shiva_debuff:IsHidden() return false end

function modifier_imba_shiva_debuff:GetTexture()
	return "item_shivas_guard"
end

function modifier_imba_shiva_debuff:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	self:OnIntervalThink()
	self:StartIntervalThink(0.5)
end

function modifier_imba_shiva_debuff:OnIntervalThink()
	if not IsServer() then return end
	-- Quick reset of stack so the attack speed calculation doesn't work recursively
	self:SetStackCount(0)
	-- Attack speed formula: 
	-- Attacks per second = [(100 + IAS) × 0.01] / BAT
	-- Tooltip Attack Speed ~= (IAS + 100) = Attacks per second * BAT * 100
	local attack_speed_slow = (self.parent:GetAttacksPerSecond() * self.parent:GetBaseAttackTime() * 100) * (self.ability:GetSpecialValueFor("aura_as_reduction") / 100)
	-- Use stack system to display how much attack speed is reduced (also allows this to update tooltip)
	self:SetStackCount(attack_speed_slow)
end

function modifier_imba_shiva_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_imba_shiva_debuff:GetModifierAttackSpeedBonus_Constant()
	return -self:GetStackCount()
end

------------------------------
-- Shiva's Guard Blast Slow --
------------------------------

modifier_item_imba_shivas_blast_slow = class({})

function modifier_item_imba_shivas_blast_slow:GetTexture()
	return "item_shivas_guard"
end

function modifier_item_imba_shivas_blast_slow:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(1.0)
end

function modifier_item_imba_shivas_blast_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_item_imba_shivas_blast_slow:OnIntervalThink()
	if IsClient() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()

	-- Fetch current stacks
	local current_stacks = target:GetModifierStackCount("modifier_item_imba_shivas_blast_slow", caster)

	-- If this is the last stack, remove the modifier
	if current_stacks <= 1 then
		self:Destroy()
	-- Else, reduce stack amount by 1
	else
		self:DecrementStackCount()
	end
end

function modifier_item_imba_shivas_blast_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow_stack") * self:GetStackCount()
end

function modifier_item_imba_shivas_blast_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_stack") * self:GetStackCount()
end
