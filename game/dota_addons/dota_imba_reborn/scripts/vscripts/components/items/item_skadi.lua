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
--	Date: 			16.12.2015
--	Last Update:	25.03.2017
--	Eye of Skadi

-----------------------------------------------------------------------------------------------------------
--	Skadi definition
-----------------------------------------------------------------------------------------------------------

if item_imba_skadi == nil then item_imba_skadi = class({}) end
LinkLuaModifier( "modifier_item_imba_skadi", "components/items/item_skadi.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_skadi_unique", "components/items/item_skadi.lua", LUA_MODIFIER_MOTION_NONE )	-- On-damage slow applier
LinkLuaModifier( "modifier_item_imba_skadi_slow", "components/items/item_skadi.lua", LUA_MODIFIER_MOTION_NONE )	-- Slow debuff
LinkLuaModifier( "modifier_item_imba_skadi_freeze", "components/items/item_skadi.lua", LUA_MODIFIER_MOTION_NONE )	-- Root debuff

-- Passive modifier
function item_imba_skadi:GetIntrinsicModifierName()
	return "modifier_item_imba_skadi"
end

function item_imba_skadi:GetAbilityTextureName()
	return "custom/imba_skadi"
end

-- Dynamic cast range
function item_imba_skadi:GetCastRange()
	if IsServer() then
		return
	end
	local caster = self:GetCaster()
	if caster and caster:HasModifier("modifier_item_imba_skadi") then
		return caster:GetModifierStackCount("modifier_item_imba_skadi", caster)
	else
		return 0
	end
end

-- Root active
function item_imba_skadi:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		-- Parameters
		local caster_loc = caster:GetAbsOrigin()
		local radius = self:GetSpecialValueFor("base_radius")
		local duration = self:GetSpecialValueFor("base_duration")
		local damage = self:GetSpecialValueFor("base_damage")

		-- Calculate cast parameters
		if caster:IsRealHero() then
			radius = radius + caster:GetStrength() * self:GetSpecialValueFor("radius_per_str")
			duration = duration + caster:GetIntellect() * self:GetSpecialValueFor("duration_per_int")
			damage = damage + caster:GetAgility() * self:GetSpecialValueFor("damage_per_agi")
		end

		-- Play sound
		if USE_MEME_SOUNDS and RollPercentage(MEME_SOUNDS_CHANCE) then
			caster:EmitSound("Imba.SkadiDeadWinter")
		else
			caster:EmitSound("Imba.SkadiCast")
		end

		-- Play particle
		local blast_pfx = ParticleManager:CreateParticle("particles/item/skadi/skadi_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleAlwaysSimulate(blast_pfx)
		ParticleManager:SetParticleControl(blast_pfx, 0, caster_loc)
		ParticleManager:SetParticleControl(blast_pfx, 2, Vector(radius * 1.15, 1, 1))
		ParticleManager:ReleaseParticleIndex(blast_pfx)

		-- Grant flying vision in the target area
		self:CreateVisibilityNode(caster_loc, radius, duration + self:GetSpecialValueFor("vision_extra_duration"))

		-- Find targets in range
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Play target sound if at least one enemy was hit
		if #nearby_enemies > 0 then caster:EmitSound("Imba.SkadiHit") end

		-- Damage and freeze enemies
		for _,enemy in pairs(nearby_enemies) do

			-- Apply damage
			ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Apply freeze modifier
			enemy:AddNewModifier(caster, self, "modifier_item_imba_skadi_freeze", {duration = duration})

			-- Apply ministun
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = 0.01})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Skadi owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_skadi == nil then modifier_item_imba_skadi = class({}) end
function modifier_item_imba_skadi:IsHidden() return true end
function modifier_item_imba_skadi:IsDebuff() return false end
function modifier_item_imba_skadi:IsPurgable() return false end
function modifier_item_imba_skadi:IsPermanent() return true end
function modifier_item_imba_skadi:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the caster when created
function modifier_item_imba_skadi:OnCreated(keys)
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.radius = self:GetAbility():GetSpecialValueFor("base_radius")

		if not self.parent:HasModifier("modifier_item_imba_skadi_unique") then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_imba_skadi_unique", {})
		end

		-- Set stack count
		self:UpdateCastRange()

		-- Cast range update thinker
		self:StartIntervalThink(0.5)
	end
end

-- Removes the unique modifier from the caster if this is the last skadi in its inventory
function modifier_item_imba_skadi:OnDestroy()
	if IsServer() then
		if not self.parent:HasModifier("modifier_item_imba_skadi") then
			self.parent:RemoveModifierByName("modifier_item_imba_skadi_unique")
		end
	end
end

-- Cast range update thinker
function modifier_item_imba_skadi:OnIntervalThink()
	self:UpdateCastRange()
end

function modifier_item_imba_skadi:UpdateCastRange()
	if IsServer() then
		if self.parent:IsRealHero() then
			local iradius = self.radius + self.parent:GetStrength() * self.ability:GetSpecialValueFor("radius_per_str")
		end

		self:SetStackCount(( self.radius + self.parent:GetStrength() * self.ability:GetSpecialValueFor("radius_per_str")))
	end
end

-- Declare modifier events/properties
function modifier_item_imba_skadi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end

function modifier_item_imba_skadi:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_imba_skadi:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_imba_skadi:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

-----------------------------------------------------------------------------------------------------------
--	Skadi slow applier
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_skadi_unique == nil then modifier_item_imba_skadi_unique = class({}) end
function modifier_item_imba_skadi_unique:IsHidden() return true end
function modifier_item_imba_skadi_unique:IsDebuff() return false end
function modifier_item_imba_skadi_unique:IsPurgable() return false end
function modifier_item_imba_skadi_unique:IsPermanent() return true end

-- Changes the caster's attack projectile, if applicable
function modifier_item_imba_skadi_unique:OnCreated(keys)
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())

		-- Store ability KVs for later usage
		local ability = self:GetAbility()
		self.max_duration = ability:GetSpecialValueFor("max_duration")
		self.min_duration = ability:GetSpecialValueFor("min_duration")
		self.slow_range_cap = ability:GetSpecialValueFor("slow_range_cap")
		self.max_distance = ability:GetSpecialValueFor("max_distance")
	end
end

-- Changes the caster's attack projectile, if applicable
function modifier_item_imba_skadi_unique:OnDestroy()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Declare modifier events/properties
function modifier_item_imba_skadi_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- On-damage slow effect
function modifier_item_imba_skadi_unique:OnTakeDamage( keys )
	if IsServer() then
		local attacker = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return
		end

		-- If the attacker is an illusion, do nothing either
		if attacker:IsIllusion() then
			return
		end
		local target = keys.unit

		-- If there's no valid target, do nothing
		if (not target:IsHeroOrCreep()) or attacker:GetTeam() == target:GetTeam() then
			return
		end

		-- Calculate actual slow duration
		local target_distance = (target:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D()

		-- If the target is too far away, do nothing
		if target_distance >= self.max_distance then
			return nil
		end

		local slow_duration = self.min_duration + (self.max_duration - self.min_duration) * math.max( self.slow_range_cap - target_distance, 0) / self.slow_range_cap

		-- Apply the slow
		target:AddNewModifier(attacker, self:GetAbility(), "modifier_item_imba_skadi_slow", {duration = slow_duration})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Skadi slow
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_skadi_slow == nil then modifier_item_imba_skadi_slow = class({}) end
function modifier_item_imba_skadi_slow:IsHidden() return false end
function modifier_item_imba_skadi_slow:IsDebuff() return true end
function modifier_item_imba_skadi_slow:IsPurgable() return true end

-- Modifier status effect
function modifier_item_imba_skadi_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf" end

function modifier_item_imba_skadi_slow:StatusEffectPriority()
	return 10 end

-- Ability KV storage
function modifier_item_imba_skadi_slow:OnCreated(keys)
	self.slow_as = self:GetAbility():GetSpecialValueFor("slow_as")
	self.slow_ms = self:GetAbility():GetSpecialValueFor("slow_ms")
end

-- Declare modifier events/properties
function modifier_item_imba_skadi_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_skadi_slow:GetModifierAttackSpeedBonus_Constant()
	return self.slow_as end

function modifier_item_imba_skadi_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_ms end

-----------------------------------------------------------------------------------------------------------
--	Skadi freeze
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_skadi_freeze == nil then modifier_item_imba_skadi_freeze = class({}) end
function modifier_item_imba_skadi_freeze:IsHidden() return true end
function modifier_item_imba_skadi_freeze:IsDebuff() return true end
function modifier_item_imba_skadi_freeze:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_skadi_freeze:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_item_imba_skadi_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Modifier status effect
function modifier_item_imba_skadi_freeze:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf" end

function modifier_item_imba_skadi_freeze:StatusEffectPriority()
	return 11 end

-- Declare modifier states
function modifier_item_imba_skadi_freeze:CheckState()
	local states = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return states
end
