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

-- Author: Shush
-- Date: 12.03.2017

-----------------------
--    SATANIC        --
-----------------------

item_imba_satanic = class({})
LinkLuaModifier("modifier_imba_satanic", "components/items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_unique", "components/items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_active", "components/items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_satanic_soul_slaughter", "components/items/item_satanic.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_satanic:GetAbilityTextureName()
	return "item_satanic"
end

function item_imba_satanic:GetIntrinsicModifierName()
	return "modifier_imba_satanic"
end

function item_imba_satanic:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_unholy = "modifier_imba_satanic_active"

	-- Ability specials
	local unholy_rage_duration = ability:GetSpecialValueFor("unholy_rage_duration")

	-- Unholy rage!
	caster:AddNewModifier(caster, ability, modifier_unholy, {duration = unholy_rage_duration})
end

-- Satanic modifier
modifier_imba_satanic = class({})

function modifier_imba_satanic:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")
	self.strength_bonus = self.ability:GetSpecialValueFor("strength_bonus")

	if IsServer() then
		if not self.caster:HasModifier("modifier_imba_satanic_unique") then
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_satanic_unique", {})
		end
		-- Change to lifesteal projectile, if there's nothing "stronger"
		ChangeAttackProjectileImba(self.caster)
	end
end

-- Removes the unique modifier from the caster if this is the last Satanic in its inventory
function modifier_imba_satanic:OnDestroy()
	if IsServer() then
		-- If it is the last Satanic in inventory, remove unique effect
		if not self.caster:HasModifier("modifier_imba_satanic") then
			self.caster:RemoveModifierByName("modifier_imba_satanic_unique")
		end

		-- Remove lifesteal projectile
		ChangeAttackProjectileImba(self.caster)
	end
end

function modifier_imba_satanic:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS}

	return decFunc
end

function modifier_imba_satanic:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus
end

function modifier_imba_satanic:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_imba_satanic:IsHidden()
	return true
end

function modifier_imba_satanic:IsPurgable()
	return false
end

function modifier_imba_satanic:IsDebuff()
	return false
end

function modifier_imba_satanic:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


-- Unique Satanic modifier
modifier_imba_satanic_unique = class({})
function modifier_imba_satanic_unique:IsHidden() return true end
function modifier_imba_satanic_unique:IsPurgable() return false end
function modifier_imba_satanic_unique:IsDebuff() return false end

function modifier_imba_satanic_unique:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"
	self.modifier_unholy = "modifier_imba_satanic_active"
	self.modifier_soul = "modifier_imba_satanic_soul_slaughter"

	-- Ability specials
	self.lifesteal_pct = self.ability:GetSpecialValueFor("lifesteal_pct")
	self.unholy_rage_lifesteal_bonus = self.ability:GetSpecialValueFor("unholy_rage_lifesteal_bonus")
	self.soul_slaughter_hp_increase_pct = self.ability:GetSpecialValueFor("soul_slaughter_hp_increase_pct")
	self.soul_slaughter_hp_per_stack = self.ability:GetSpecialValueFor("soul_slaughter_hp_per_stack")
	self.soul_slaughter_duration = self.ability:GetSpecialValueFor("soul_slaughter_duration")
	self.soul_slaughter_max_hp_pct = self.ability:GetSpecialValueFor("soul_slaughter_max_hp_pct")
end

function modifier_imba_satanic_unique:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFunc
end

function modifier_imba_satanic_unique:GetModifierLifesteal()
	-- Calculate lifesteal amount
	local lifesteal_pct = self.lifesteal_pct

	if self.caster:HasModifier(self.modifier_unholy) then
		lifesteal_pct = lifesteal_pct + self.unholy_rage_lifesteal_bonus
	end

	return lifesteal_pct
end

function modifier_imba_satanic_unique:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		local damage = keys.damage

		-- Only apply on caster attacking an enemy
		if self.caster == attacker and self.caster:GetTeamNumber() ~= target:GetTeamNumber() then
			-- If it is not a hero or a unit, do nothing
			if not target:IsHero() and not target:IsCreep() then
				return nil
			end

			local will_incarnate
			if target:IsHero() then
				will_incarnate =  target:WillReincarnate()
			end

			-- Wait a gametick to let things die
			Timers:CreateTimer(FrameTime(), function()
				-- If the target is an illusion, do nothing
				if target:IsIllusion() then
					return nil
				end

				-- Check if the target died as a result of that attack
				if not target:IsAlive() and not will_incarnate then

					-- Calculate soul worth in health and stacks
					local soul_health = target:GetMaxHealth() * (self.soul_slaughter_hp_increase_pct * 0.01)
					local soul_stacks = (soul_health/self.soul_slaughter_hp_per_stack)

					--Calculate maximum stacks based on caster health
					local maximum_stacks = (attacker:GetMaxHealth()*(self.soul_slaughter_max_hp_pct * 0.01)/self.soul_slaughter_hp_per_stack)

					-- Set variable
					local modifier_soul_feast

					-- Assign 5 second duration
					local duration = self.soul_slaughter_duration

					-- Feast on its soul!
					-- Check if the buff already exists, otherwise, add it
					if not self.caster:HasModifier(self.modifier_soul) then
						self.caster:AddNewModifier(self.caster, self.ability, self.modifier_soul, {duration = duration})
					end

					modifier_soul_feast = self.caster:FindModifierByName(self.modifier_soul)
					if modifier_soul_feast then
						for i = 1, soul_stacks do
							-- Increment the stack count if it will not exceed the maximum
							if modifier_soul_feast:GetStackCount() < maximum_stacks then
								modifier_soul_feast:IncrementStackCount()
								modifier_soul_feast:ForceRefresh()
							end
						end
					end
				end
			end)
		end
	end
end


-- Active Satanic modifier
modifier_imba_satanic_active = class({})

function modifier_imba_satanic_active:IsHidden()
	return false
end

function modifier_imba_satanic_active:IsPurgable()
	return true
end

function modifier_imba_satanic_active:IsDebuff()
	return false
end

function modifier_imba_satanic_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_imba_satanic_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


-- Soul Slaughter modifier
modifier_imba_satanic_soul_slaughter = class({})

function modifier_imba_satanic_soul_slaughter:OnCreated()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.soul_slaughter_damage_per_stack = self.ability:GetSpecialValueFor("soul_slaughter_damage_per_stack")
	self.soul_slaughter_hp_per_stack = self.ability:GetSpecialValueFor("soul_slaughter_hp_per_stack")
	if IsServer() then
		self.duration = self.ability:GetSpecialValueFor("soul_slaughter_duration")

		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_satanic_soul_slaughter:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			self.caster:CalculateStatBonus()

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_satanic_soul_slaughter:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_satanic_soul_slaughter:IsHidden()
	return false
end

function modifier_imba_satanic_soul_slaughter:IsPurgable()
	return true
end

function modifier_imba_satanic_soul_slaughter:IsDebuff()
	return false
end

function modifier_imba_satanic_soul_slaughter:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFunc
end

function modifier_imba_satanic_soul_slaughter:GetModifierHealthBonus()
	local stacks = self:GetStackCount()
	return (stacks * self.soul_slaughter_hp_per_stack)
end

function modifier_imba_satanic_soul_slaughter:GetModifierPreAttack_BonusDamage()
	local stacks = self:GetStackCount()
	return (stacks * self.soul_slaughter_damage_per_stack)
end
