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
LinkLuaModifier("modifier_imba_shiva_handler", "components/items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shiva_aura", "components/items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shiva_debuff", "components/items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shivas_blast_slow", "components/items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shivas_blast_true_sight", "components/items/item_shiva.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shiva_frost_goddess_breath", "components/items/item_shiva", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_shiva_truesight_null", "components/items/item_shiva", LUA_MODIFIER_MOTION_NONE)

function item_imba_shivas_guard:GetIntrinsicModifierName()
	return "modifier_imba_shiva_handler"
end

function item_imba_shivas_guard:OnSpellStart()
	-- Parameters
	local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local damage = self:GetSpecialValueFor("damage")
	local slow_initial_stacks = self:GetSpecialValueFor("slow_initial_stacks")
	local blast_duration = blast_radius / blast_speed
	local current_loc = self:GetCaster():GetAbsOrigin()
	
	local bTrueSight = not self:GetCaster():HasModifier("modifier_item_imba_shiva_truesight_null")
	local slow_duration_tooltip	= self:GetSpecialValueFor("slow_duration_tooltip")

	local caster	= self:GetCaster()
	local ability	= self

	-- Play cast sound
	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")

	local blast_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControl(blast_pfx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(blast_radius, blast_duration * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(blast_pfx)

	if bTrueSight then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_shiva_truesight_null", {duration = math.max(self:GetEffectiveCooldown(self:GetLevel()), 0)})
	end

	-- Initialize targets hit table
	local targets_hit = {}

	-- Main blasting loop
	local current_radius = 0
	local tick_interval = 0.1
	Timers:CreateTimer(tick_interval, function()
		-- Give vision
		AddFOWViewer(self:GetCaster():GetTeamNumber(), current_loc, current_radius, 0.1, false)

		-- Update current radius and location
		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()
		--vision_dummy:SetAbsOrigin(current_loc)

		-- Iterate through enemies in the radius
		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			-- Check if this enemy was already hit
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			-- If not, blast it
			if not enemy_has_been_hit then
				local hit_pfx = ParticleManager:CreateParticle("particles/items2_fx/shivas_guard_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy, self:GetCaster())
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				-- Deal damage
				ApplyDamage({attacker = caster, victim = enemy, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(caster, ability, "modifier_item_imba_shivas_blast_slow", {})
				enemy:SetModifierStackCount("modifier_item_imba_shivas_blast_slow", caster, slow_initial_stacks)

				-- Apply (IMBA) true sight modifier if applicable
				if bTrueSight then
					true_sight_modifier = enemy:AddNewModifier(caster, ability, "modifier_item_imba_shivas_blast_true_sight", {duration = slow_duration_tooltip})
					
					if true_sight_modifier then
						true_sight_modifier:SetDuration(slow_duration_tooltip * (1 - enemy:GetStatusResistance()), true)
					end	
				end

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

-----------------------------------------------------------------------------------------------------------
--	Shiva Handler
-----------------------------------------------------------------------------------------------------------
if modifier_imba_shiva_handler == nil then modifier_imba_shiva_handler = class({}) end

function modifier_imba_shiva_handler:IsHidden() return true end
function modifier_imba_shiva_handler:IsPurgable() return false end
function modifier_imba_shiva_handler:RemoveOnDeath() return false end
function modifier_imba_shiva_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_shiva_handler:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if self:GetAbility() then
		self.aura_radius	= self:GetAbility():GetSpecialValueFor("aura_radius")
	else
		self:Destroy()
		return
	end

	self:StartIntervalThink(1.0)
	self:OnIntervalThink()

	if IsServer() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shiva_aura", {})
	end
end

function modifier_imba_shiva_handler:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
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

function modifier_imba_shiva_handler:IsAura() 				return true end
function modifier_imba_shiva_handler:IsAuraActiveOnDeath()	return false end

function modifier_imba_shiva_handler:GetAuraRadius()			return self.aura_radius end
function modifier_imba_shiva_handler:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_shiva_handler:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_shiva_handler:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO end
function modifier_imba_shiva_handler:GetModifierAura()			return "modifier_item_imba_shiva_frost_goddess_breath" end

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
function modifier_imba_shiva_aura:RemoveOnDeath() return false end

---------------------------------------
-- Shiva's Guard Passive Aura Debuff --
---------------------------------------

modifier_imba_shiva_debuff = class({})

function modifier_imba_shiva_debuff:IsHidden() return false end

function modifier_imba_shiva_debuff:GetTexture()
	return "item_shivas_guard"
end

function modifier_imba_shiva_debuff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.parent = self:GetParent()
	
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
	if self.parent and self:GetAbility() then
		local attack_speed_slow = (self.parent:GetAttacksPerSecond() * self.parent:GetBaseAttackTime() * 100) * (self:GetAbility():GetSpecialValueFor("aura_as_reduction") / 100)
		-- Use stack system to display how much attack speed is reduced (also allows this to update tooltip)
		self:SetStackCount(attack_speed_slow)
	end
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
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.slow_stack	= self:GetAbility():GetSpecialValueFor("slow_stack")

	if not IsServer() then return end
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_item_imba_shivas_blast_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_item_imba_shivas_blast_slow:OnIntervalThink()
	if IsClient() then return end

	-- Fetch current stacks
	local current_stacks = self:GetParent():GetModifierStackCount("modifier_item_imba_shivas_blast_slow", self:GetCaster())

	-- If this is the last stack, remove the modifier
	if current_stacks <= 1 then
		self:Destroy()
	-- Else, reduce stack amount by 1
	else
		self:DecrementStackCount()
	end
end

function modifier_item_imba_shivas_blast_slow:GetModifierAttackSpeedBonus_Constant()
	return self.slow_stack * self:GetStackCount()
end

function modifier_item_imba_shivas_blast_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_stack * self:GetStackCount()
end

------------------------------------------------
-- MODIFIER_ITEM_IMBA_SHIVAS_BLAST_TRUE_SIGHT --
------------------------------------------------

modifier_item_imba_shivas_blast_true_sight	= modifier_item_imba_shivas_blast_true_sight or class({})

function modifier_item_imba_shivas_blast_true_sight:GetEffectName()
	return "particles/items2_fx/true_sight_debuff.vpcf"
end

function modifier_item_imba_shivas_blast_true_sight:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_item_imba_shivas_blast_true_sight:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_imba_shivas_blast_true_sight:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = false}
end

---------------------------------------------------
-- MODIFIER_ITEM_IMBA_SHIVA_FROST_GODDESS_BREATH --
---------------------------------------------------

modifier_item_imba_shiva_frost_goddess_breath	= modifier_item_imba_shiva_frost_goddess_breath or class({})

function modifier_item_imba_shiva_frost_goddess_breath:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.aura_intellect	= self:GetAbility():GetSpecialValueFor("aura_intellect")
end

function modifier_item_imba_shiva_frost_goddess_breath:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_item_imba_shiva_frost_goddess_breath:GetModifierBonusStats_Intellect()
	return self.aura_intellect
end

---------------------------------------------
-- MODIFIER_ITEM_IMBA_SHIVA_TRUESIGHT_NULL --
---------------------------------------------

modifier_item_imba_shiva_truesight_null	= modifier_item_imba_shiva_truesight_null or class({})

function modifier_item_imba_shiva_truesight_null:IgnoreTenacity()	return true end
function modifier_item_imba_shiva_truesight_null:IsDebuff()			return true end
function modifier_item_imba_shiva_truesight_null:IsPurgable()		return false end
function modifier_item_imba_shiva_truesight_null:RemoveOnDeath()	return false end
