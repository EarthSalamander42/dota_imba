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
--	DateCreated	 -	25.03.2015	<-- It owes Jesus money
--	Date Updated -	05.03.2017
--	Converted to Lua by zimberzimber

-- Illusions don't apply afterburn stacks

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_cloak_of_flames == nil then item_imba_cloak_of_flames = class({}) end
LinkLuaModifier( "modifier_imba_cloak_of_flames_basic", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Item stats
LinkLuaModifier( "modifier_imba_cloak_of_flames_aura", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura
LinkLuaModifier( "modifier_imba_cloak_of_flames_burn", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Damage + blind effect

function item_imba_cloak_of_flames:GetIntrinsicModifierName()
	return "modifier_imba_cloak_of_flames_basic" end

function item_imba_cloak_of_flames:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_cloak_of_flames_aura") then
			self:GetCaster():RemoveModifierByName("modifier_imba_cloak_of_flames_aura")
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_cloak_of_flames_aura", {})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_cloak_of_flames_basic == nil then modifier_imba_cloak_of_flames_basic = class({}) end
function modifier_imba_cloak_of_flames_basic:IsHidden() return true end
function modifier_imba_cloak_of_flames_basic:IsDebuff() return false end
function modifier_imba_cloak_of_flames_basic:IsPurgable() return false end
function modifier_imba_cloak_of_flames_basic:IsPermanent() return true end
function modifier_imba_cloak_of_flames_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the owner when created
function modifier_imba_cloak_of_flames_basic:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_cloak_of_flames_aura") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_cloak_of_flames_aura", {})
		end

		if self.particle == nil then
			self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(self.particle, 0, Vector(0, 0, 0))
			ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetAbility():GetSpecialValueFor("aura_radius"), 1, 1))
		end
	end
end

-- Removes the unique modifier from the owner if this is the last Radiance in its inventory
function modifier_imba_cloak_of_flames_basic:OnDestroy(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_cloak_of_flames_basic") then
			self:GetParent():RemoveModifierByName("modifier_imba_cloak_of_flames_aura")
		end
	end
end

function modifier_imba_cloak_of_flames_basic:OnDestroy()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end

-----------------------------------------------------------------------------------------------------------
--	Aura definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_cloak_of_flames_aura == nil then modifier_imba_cloak_of_flames_aura = class({}) end
function modifier_imba_cloak_of_flames_aura:IsAura() return true end
function modifier_imba_cloak_of_flames_aura:IsHidden() return true end
function modifier_imba_cloak_of_flames_aura:IsDebuff() return false end
function modifier_imba_cloak_of_flames_aura:IsPurgable() return false end

function modifier_imba_cloak_of_flames_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_cloak_of_flames_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_imba_cloak_of_flames_aura:GetModifierAura()
	return "modifier_imba_cloak_of_flames_burn"
end

function modifier_imba_cloak_of_flames_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

-----------------------------------------------------------------------------------------------------------
--	Aura effect (damage)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_cloak_of_flames_burn == nil then modifier_imba_cloak_of_flames_burn = class({}) end
function modifier_imba_cloak_of_flames_burn:IsHidden() return false end
function modifier_imba_cloak_of_flames_burn:IsDebuff() return true end
function modifier_imba_cloak_of_flames_burn:IsPurgable() return false end

function modifier_imba_cloak_of_flames_burn:OnCreated()
	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))
	end
end

function modifier_imba_cloak_of_flames_burn:OnIntervalThink()
	if IsServer() then
		ApplyDamage({
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			ability = self:GetAbility(),
			damage = self:GetAbility():GetSpecialValueFor("base_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
end

if item_imba_radiance == nil then item_imba_radiance = class({}) end
LinkLuaModifier( "modifier_imba_radiance_basic", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Item stats
LinkLuaModifier( "modifier_imba_radiance_aura", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura
LinkLuaModifier( "modifier_imba_radiance_burn", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Damage + blind effect
LinkLuaModifier( "modifier_imba_radiance_afterburn", "components/items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )		-- Sticky effect after leaving the Radiance AoE

function item_imba_radiance:GetIntrinsicModifierName()
	return "modifier_imba_radiance_basic" end

function item_imba_radiance:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_imba_radiance_aura") then
			self:GetCaster():RemoveModifierByName("modifier_imba_radiance_aura")
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_radiance_aura", {})
		end
	end
end

function item_imba_radiance:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_radiance_aura") then
		if not IsClient() then return end
		if not self:GetCaster().radiance_icon_client then return "custom/imba_radiance" end

		return "custom/imba_radiance"..self:GetCaster().radiance_icon_client
	else
		if not self:GetCaster().radiance_icon_client then return "custom/imba_radiance_inactive" end
		return "custom/imba_radiance"..self:GetCaster().radiance_icon_client.."_inactive"
	end
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_basic == nil then modifier_imba_radiance_basic = class({}) end
function modifier_imba_radiance_basic:IsHidden() return true end
function modifier_imba_radiance_basic:IsDebuff() return false end
function modifier_imba_radiance_basic:IsPurgable() return false end
function modifier_imba_radiance_basic:IsPermanent() return true end
function modifier_imba_radiance_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the owner when created
function modifier_imba_radiance_basic:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_radiance_aura") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_radiance_aura", {})
		end
	end

	self:StartIntervalThink(1.0)
end

function modifier_imba_radiance_basic:OnIntervalThink()
	if self:GetCaster():IsIllusion() then return end

	if IsServer() then
		if string.find(self:GetParent():GetUnitName(), "npc_dota_lone_druid_bear") then
			self:SetStackCount(self:GetParent():GetOwnerEntity().radiance_icon)
		else
			self:SetStackCount(self:GetCaster().radiance_icon)
		end
	end

	if IsClient() then
		local icon = self:GetStackCount()
		if icon == 0 then
			self:GetCaster().radiance_icon_client = nil
		else
			self:GetCaster().radiance_icon_client = icon
		end
	end
end

-- Removes the unique modifier from the owner if this is the last Radiance in its inventory
function modifier_imba_radiance_basic:OnDestroy(keys)
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_radiance_basic") then
			self:GetParent():RemoveModifierByName("modifier_imba_radiance_aura")
		end
	end
end

function modifier_imba_radiance_basic:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, }
end

function modifier_imba_radiance_basic:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

-----------------------------------------------------------------------------------------------------------
--	Aura definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_aura == nil then modifier_imba_radiance_aura = class({}) end
function modifier_imba_radiance_aura:IsAura() return true end
function modifier_imba_radiance_aura:IsHidden() return true end
function modifier_imba_radiance_aura:IsDebuff() return false end
function modifier_imba_radiance_aura:IsPurgable() return false end

function modifier_imba_radiance_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_radiance_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_imba_radiance_aura:GetModifierAura()
	return "modifier_imba_radiance_burn"
end

function modifier_imba_radiance_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

-- Create the glow particle and start thinking
function modifier_imba_radiance_aura:OnCreated()
	if IsServer() then
		if string.find(self:GetParent():GetUnitName(), "npc_dota_lone_druid_bear") then
			self.particle = ParticleManager:CreateParticle(self:GetParent():GetOwnerEntity().radiance_effect_owner, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		else
			self.particle = ParticleManager:CreateParticle(self:GetParent().radiance_effect_owner, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		end
	end
end

-- Destroy the glow particle
function modifier_imba_radiance_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

-----------------------------------------------------------------------------------------------------------
--	Aura effects (damage + blind)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_burn == nil then modifier_imba_radiance_burn = class({}) end
function modifier_imba_radiance_burn:IsHidden() return false end
function modifier_imba_radiance_burn:IsDebuff() return true end
function modifier_imba_radiance_burn:IsPurgable() return false end

function modifier_imba_radiance_burn:DeclareFunctions()
	return { MODIFIER_PROPERTY_MISS_PERCENTAGE, } end

function modifier_imba_radiance_burn:OnCreated()
	if IsServer() then

		-- Particle creation
		if string.find(self:GetParent():GetUnitName(), "npc_dota_lone_druid_bear") then
			self.particle = ParticleManager:CreateParticle(self:GetParent():GetOwnerEntity().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		else
			self.particle = ParticleManager:CreateParticle(self:GetParent().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		end

		-- Start thinking
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))

		-- Parameter storage
		local ability = self:GetAbility()
		self.base_damage = ability:GetSpecialValueFor("base_damage")
		self.extra_damage = ability:GetSpecialValueFor("extra_damage")
		self.aura_radius = ability:GetSpecialValueFor("aura_radius")
		self.miss_chance = ability:GetSpecialValueFor("miss_chance")
		self.count_to_afterburn = ability:GetSpecialValueFor("stack_decay")
		self.afterburner_counter = 0
	end
end

function modifier_imba_radiance_burn:OnDestroy()
	if IsServer() then

		-- Destroy particle
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)

		-- Apply afterburn with the appropriate amount of accumulates stacks
		local stacks = self:GetStackCount()
		if stacks > 0 then
			local modifier_afterburn = self:GetParent():FindModifierByName("modifier_imba_radiance_afterburn")
			if not modifier_afterburn then
				modifier_afterburn = self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_imba_radiance_afterburn", {})
			end

			if modifier_afterburn then
				modifier_afterburn:SetStackCount(modifier_afterburn:GetStackCount() + stacks)
			end
		end
	end
end

function modifier_imba_radiance_burn:OnIntervalThink()
	if IsServer() then

		-- Parameters
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		local damage = self.base_damage
		local real_hero_nearby = false

		-- Checks for the presence of the real hero
		if caster:IsRealHero() then
			real_hero_nearby = true
		else
			local real_hero_finder = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false)
			for _,hero in pairs(real_hero_finder) do
				if hero:FindModifierByName("modifier_imba_radiance_aura") then
					real_hero_nearby = true
					break
				end
			end
		end

		-- If the real hero is nearby, increase damage and afterburn counter by 1
		if real_hero_nearby then
			damage = damage + self.extra_damage * self:GetParent():GetHealth() * 0.01
			self.afterburner_counter = self.afterburner_counter + 1

			-- If the afterburner counter has reached its target, reset it and add a stack to this modifier
			if self.afterburner_counter >= self.count_to_afterburn then
				self.afterburner_counter = 0
				self:SetStackCount(self:GetStackCount() + 1)
			end
		end

		-- Apply damage
		ApplyDamage({victim = self:GetParent(), attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_radiance_burn:GetModifierMiss_Percentage()
	return self.miss_chance end

-----------------------------------------------------------------------------------------------------------
--	Afterburn modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_afterburn == nil then modifier_imba_radiance_afterburn = class({}) end
function modifier_imba_radiance_afterburn:IsHidden() return false end
function modifier_imba_radiance_afterburn:IsDebuff() return true end
function modifier_imba_radiance_afterburn:IsPurgable() return false end

function modifier_imba_radiance_afterburn:OnCreated()
	if IsServer() then

		-- Parameter storage
		local ability = self:GetAbility()
		local think_interval = ability:GetSpecialValueFor("think_interval")
		self.base_damage = ability:GetSpecialValueFor("base_damage")
		self.extra_damage = ability:GetSpecialValueFor("extra_damage")
		self.miss_chance = ability:GetSpecialValueFor("miss_chance")

		-- Particle creation
		if string.find(self:GetParent():GetUnitName(), "npc_dota_lone_druid_bear") then
			self.particle = ParticleManager:CreateParticle(self:GetParent():GetOwnerEntity().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		else
			self.particle = ParticleManager:CreateParticle(self:GetParent().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		end

		-- Start thinking
		self:StartIntervalThink(think_interval)
	end
end

function modifier_imba_radiance_afterburn:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_radiance_afterburn:OnIntervalThink()
	if IsServer() then

		-- If the parent has the radiance burn modifier, do nothing
		if not self:GetParent():HasModifier("modifier_imba_radiance_burn") then

			-- If the original item is gone, do nothing and destroy the modifier
			local ability = self:GetAbility()
			if not ability then
				self:Destroy()
				return nil
			end

			-- Parameters
			local caster = ability:GetCaster()
			local stacks = self:GetStackCount()
			local damage = self.base_damage

			-- Calculate and deal damage
			damage = damage + self.extra_damage * self:GetParent():GetHealth() * 0.01
			ApplyDamage({victim = self:GetParent(), attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			self:SetStackCount(self:GetStackCount() - 1)
			if self:GetStackCount() <= 0 then self:Destroy() return end

			local parent_loc = self:GetParent():GetAbsOrigin()
		end
	end
end

function modifier_imba_radiance_afterburn:DeclareFunctions()
	return { MODIFIER_PROPERTY_MISS_PERCENTAGE, }
end

function modifier_imba_radiance_afterburn:GetModifierMiss_Percentage()
	return self.miss_chance
end
