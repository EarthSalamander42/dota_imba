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

--	Author		 -	d2imba
--	Date Created -	15.08.2015	<-- Shits' ancient yo
--	Date Updated -	05.03.2020 (AltiV)
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_octarine_core == nil then item_imba_octarine_core = class({}) end
LinkLuaModifier( "modifier_imba_octarine_core_basic", "components/items/item_octarine_core.lua", LUA_MODIFIER_MOTION_NONE )	-- Item stats

function item_imba_octarine_core:GetAbilityTextureName()
	return "imba_octarine_core"
end

function item_imba_octarine_core:GetIntrinsicModifierName()
	return "modifier_imba_octarine_core_basic" end

function item_imba_octarine_core:OnSpellStart()
	-- Play sound only to the caster
	self:GetCaster():EmitSound("Item.DropGemWorld")
	
	if self:GetCaster():GetModifierStackCount("modifier_imba_octarine_core_basic", self:GetCaster()) == 1 then
		for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetIntrinsicModifierName())) do
			mod:SetStackCount(2)
		end
	else
		for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetIntrinsicModifierName())) do
			mod:SetStackCount(1)
		end
	end
	
	-- Ignore the item's cooldown
	self:EndCooldown()
end

function item_imba_octarine_core:GetAbilityTextureName()
	if self:GetCaster():GetModifierStackCount("modifier_imba_octarine_core_basic", self:GetCaster()) == 1 then
		return "imba_octarine_core_off"
	else
		return "imba_octarine_core"
	end
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_octarine_core_basic == nil then modifier_imba_octarine_core_basic = class({}) end

function modifier_imba_octarine_core_basic:IsHidden()		return true end
function modifier_imba_octarine_core_basic:IsPurgable()		return false end
function modifier_imba_octarine_core_basic:RemoveOnDeath()	return false end
function modifier_imba_octarine_core_basic:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_imba_octarine_core_basic:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if not IsServer() then return end

	self:SetStackCount(2)
	
	-- Use Secondary Charges system to make CDR not stack with multiple Octarine Cores
	for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_imba_octarine_core_basic:OnDestroy()
	if not IsServer() then return end

	for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_imba_octarine_core_basic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
end

function modifier_imba_octarine_core_basic:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end

function modifier_imba_octarine_core_basic:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_imba_octarine_core_basic:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intelligence")
	end
end

--- Enum DamageCategory_t
-- DOTA_DAMAGE_CATEGORY_ATTACK = 1
-- DOTA_DAMAGE_CATEGORY_SPELL = 0
function modifier_imba_octarine_core_basic:OnTakeDamage( keys )
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then		
		-- Spell lifesteal handler
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- Particle effect
			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			-- "However, when attacking illusions, the heal is not affected by the illusion's changed incoming damage values."
			-- This is EXTREMELY rough because I am not aware of any functions that can explicitly give you the incoming/outgoing damage of an illusion, or to give you the "displayed" damage when you're hitting illusions, which show numbers as if you were hitting a non-illusion.
			if keys.unit:IsIllusion() then
				if keys.damage_type == DAMAGE_TYPE_PHYSICAL and keys.unit.GetPhysicalArmorValue and GetReductionFromArmor then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetPhysicalArmorValue(false)))
				elseif keys.damage_type == DAMAGE_TYPE_MAGICAL and keys.unit.GetMagicalArmorValue then
					keys.damage = keys.original_damage * (1 - GetReductionFromArmor(keys.unit:GetMagicalArmorValue()))
				elseif keys.damage_type == DAMAGE_TYPE_PURE then
					keys.damage = keys.original_damage
				end
			end
			
			if keys.unit:IsCreep() then
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("creep_lifesteal") * 0.01, keys.attacker)
			else
				keys.attacker:Heal(math.max(keys.damage, 0) * self:GetAbility():GetSpecialValueFor("hero_lifesteal") * 0.01, keys.attacker)
			end
		end
	end
end

function modifier_imba_octarine_core_basic:GetModifierPercentageCooldown()
	if self:GetAbility() and self:GetAbility():GetSecondaryCharges() == 1 then
		return self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	end
end

function modifier_imba_octarine_core_basic:OnSpentMana( keys )
	if self:GetAbility() and keys.unit == self:GetParent() and keys.unit:FindAllModifiersByName(self:GetName())[1] == self and self:GetStackCount() == 2 and self:GetAbility():IsCooldownReady() and keys.cost > 0 then	-- [ 1 = disabled | 2 = enabled ]
		self:GetAbility():UseResources(false, false, false, true)
		
		-- Blast geometry
		local blast_duration = 0.75 * 0.75
		local blast_speed = self:GetAbility():GetSpecialValueFor("blast_radius") / blast_duration

		-- Calculate damage
		local damage = keys.cost * self:GetAbility():GetSpecialValueFor("blast_damage") * 0.01

		-- Fire particle
		local blast_pfx = ParticleManager:CreateParticle("particles/item/octarine_core/octarine_core_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(100, 0, blast_speed))
		ParticleManager:ReleaseParticleIndex(blast_pfx)

		-- Fire sound
		self:GetParent():EmitSound("Hero_Zuus.StaticField")

		-- Damage units inside the blast radius if they haven't been affected already
		for _, target in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("blast_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do

			-- Apply damage
			ApplyDamage({attacker = self:GetParent(), victim = target, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Fire particle
			local hit_pfx = ParticleManager:CreateParticle("particles/item/octarine_core/octarine_core_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Print overhead message
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil)
		end
	end
end
