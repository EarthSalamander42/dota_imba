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
-- Date: 25/01/2017

if item_imba_curseblade == nil then
	item_imba_curseblade = class({})
end

LinkLuaModifier("modifier_item_imba_curseblade", "components/items/item_curseblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_curseblade_debuff", "components/items/item_curseblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_souldrain", "components/items/item_curseblade", LUA_MODIFIER_MOTION_NONE)

function item_imba_curseblade:GetIntrinsicModifierName()
	return "modifier_item_imba_curseblade"
end

function item_imba_curseblade:GetAbilityTextureName()
	return "custom/imba_curseblade"
end

function item_imba_curseblade:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local sound_cast = "Imba.Curseblade"
		local particle_curse = "particles/item/curseblade/imba_curseblade_curse.vpcf"
		local datadrive_baseclass = "modifier_datadriven"
		local debuff = "modifier_item_imba_curseblade_debuff"

		-- Ability specials
		local duration = self:GetSpecialValueFor("duration")

		-- Play sound cast
		EmitSoundOn(sound_cast, caster)

		-- Check for Linken's Sphere
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- Add the curse debuff to the target
		target:AddNewModifier(caster, ability, debuff, {duration = duration})

		-- Find all modifiers on caster
		local modifiers = caster:FindAllModifiers()
		for _,modifier in pairs(modifiers) do
			local modifier_found = false
			local modifier_name = modifier:GetName()

			-- Check via IsDebuff function
			if modifier.IsDebuff and modifier.IsPurgable then
				if modifier:IsDebuff() and modifier:IsPurgable() then
					modifier_found = true
				end
			end

			-- Check via vanilla modifiers list
			if IsVanillaDebuff(modifier_name) then
				modifier_found = true
			end

			-- If the modifier was not found yet, search it in the debuff list
			if not modifier_found then

				-- Compare debuff to try and find it in the KV debuff list
				for _,modifier_name_in_list in pairs(DISPELLABLE_DEBUFF_LIST) do
					if modifier_name == modifier_name_in_list then
						modifier_found = true
					end
				end
			end

			-- If the modifier was found, remove it on the caster and transfer it to the enemy
			if modifier_found then
				local modifier_duration = modifier:GetDuration()
				caster:RemoveModifierByName(modifier_name)

				-- Find if it is a lua based ability or datadriven and assign the correct function
				local modifier_ability = modifier:GetAbility()
				local modifier_class = modifier:GetClass()

				if modifier_class == datadrive_baseclass then
					modifier_ability:ApplyDataDrivenModifier(caster, target, modifier_name, {duration = modifier_duration})
				else
					target:AddNewModifier(caster, modifier_ability, modifier_name, {duration = modifier_duration})
				end
			end
		end
	end
end

-------------------------------------------
--			SOULDRAIN AURA
-------------------------------------------
LinkLuaModifier("modifier_imba_souldrain_damage", "components/items/item_curseblade", LUA_MODIFIER_MOTION_NONE)
modifier_imba_souldrain = modifier_imba_souldrain or class({})
-- Aura properties
function modifier_imba_souldrain:IsAura() return true end
function modifier_imba_souldrain:IsHidden() return true end
function modifier_imba_souldrain:IsDebuff() return false end
function modifier_imba_souldrain:IsPurgable() return false end
function modifier_imba_souldrain:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_souldrain:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_imba_souldrain:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_aoe") end
function modifier_imba_souldrain:GetModifierAura()	return "modifier_imba_souldrain_damage" end

function modifier_imba_souldrain:GetAuraEntityReject(target)
	-- If the target has Hellblade's aura, reject it
	if target:HasModifier("modifier_imba_helldrain_damage") then
		return true
	end

	return false
end

-- Start aura
function modifier_imba_souldrain:OnCreated()
	if IsServer() then
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("aura_damage_heal_interval"))
	end
end

function modifier_imba_souldrain:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

--Heal and Distribute damage modifier
function modifier_imba_souldrain:OnIntervalThink()
	if IsServer() then
		--Ability properties
		local item 					=	self:GetAbility()
		local caster				= 	item:GetCaster()
		local location 				=	caster:GetAbsOrigin()

		--Ability paramaters
		local radius 				=	item:GetSpecialValueFor("aura_aoe")
		local heal_per_enemy		= 	item:GetSpecialValueFor("aura_damage_per_second")
		local heal_interval			=	item:GetSpecialValueFor("aura_damage_heal_interval")

		--Search for nearby enemies
		local enemies 				= 	FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, item:GetAbilityTargetTeam(), item:GetAbilityTargetType(), item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)

		local valid_enemies = 0
		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_imba_souldrain_damage") then
				local actual_damage = ApplyDamage({victim = enemy, attacker = caster, ability = item, damage = heal_per_enemy * heal_interval, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS, ability = item})

				-- Apply aura damage and heal
				caster:Heal(actual_damage, caster)

				valid_enemies = valid_enemies + 1
			end
		end
	end
end

--------------
-- Aura damage
--------------
modifier_imba_souldrain_damage = modifier_imba_souldrain_damage or class ({})
-- Modifier properties
function modifier_imba_souldrain_damage:IsHidden() return false end
function modifier_imba_souldrain_damage:IsDebuff() return true end
function modifier_imba_souldrain_damage:IsPurgable() return false end
function modifier_imba_souldrain_damage:GetEffectName()	return "particles/item/curseblade/imba_curseblade_curse_rope_pnt.vpcf" end


-----------------------------------------
--			PASSIVE STAT MODIFIER
-----------------------------------------

-- Passive stats modifier
if modifier_item_imba_curseblade == nil then
	modifier_item_imba_curseblade = class({})
end

function modifier_item_imba_curseblade:OnCreated()
	if IsServer() then
		--Apply aura
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_imba_souldrain") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_souldrain", {})
		end

		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		--Add the aura

		if not self.ability then
			self:Destroy()
			return nil
		end

		-- Ability specials
		self.agility_bonus = self.ability:GetSpecialValueFor("agility_bonus")
		self.intelligence_bonus = self.ability:GetSpecialValueFor("intelligence_bonus")
		self.strength_bonus = self.ability:GetSpecialValueFor("strength_bonus")
		self.damage = self.ability:GetSpecialValueFor("damage")
	end
end

function modifier_item_imba_curseblade:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_curseblade") then
			parent:RemoveModifierByName("modifier_imba_souldrain")
		end
	end
end
function modifier_item_imba_curseblade:IsHidden() return true end
function modifier_item_imba_curseblade:IsPurgable() return false end
function modifier_item_imba_curseblade:IsDebuff() return false end
function modifier_item_imba_curseblade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_curseblade:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}

	return decFuncs
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Agility()
	return self.agility_bonus
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Intellect()
	return self.intelligence_bonus
end

function modifier_item_imba_curseblade:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_item_imba_curseblade:GetModifierBaseAttack_BonusDamage()
	return self.damage
end

-- Active drain/slow modifier
modifier_item_imba_curseblade_debuff = class({})

function modifier_item_imba_curseblade_debuff:IsDebuff()
	return true
end

function modifier_item_imba_curseblade_debuff:IsHidden()
	return false
end

function modifier_item_imba_curseblade_debuff:IsPurgable()
	return true
end

function modifier_item_imba_curseblade_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.particle_drain = "particles/hero/skeleton_king/skeleton_king_vampiric_aura_lifesteal.vpcf"

	-- Ability specials
	self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")
	self.slow_amount = self.ability:GetSpecialValueFor("slow_amount")
	self.lifedrain_per_second = self.ability:GetSpecialValueFor("lifedrain_per_second")
	self.manadrain_per_second = self.ability:GetSpecialValueFor("manadrain_per_second")

	-- Start interval for ticking HP/MP drain.
	self:StartIntervalThink(self.tick_rate)
end

function modifier_item_imba_curseblade_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_item_imba_curseblade_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_amount * (-1)
end

function modifier_item_imba_curseblade_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_curseblade_debuff:GetEffectName()
	return "particles/item/curseblade/imba_curseblade_curse.vpcf"
end

function modifier_item_imba_curseblade_debuff:OnIntervalThink()
	if IsServer() then
		-- Add drain particles
		local particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(particle_drain_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_drain_fx, 1, self.caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_drain_fx)

		-- Set actual damage/drain per tick
		local lifedrain = self.lifedrain_per_second * self.tick_rate
		local manadrain = self.manadrain_per_second * self.tick_rate

		-- Apply damage to enemy, heal caster
		local damageTable = {victim = self.parent,
			attacker = self.caster,
			damage = lifedrain,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			damage_type = DAMAGE_TYPE_MAGICAL}

		ApplyDamage(damageTable)

		self.caster:Heal(lifedrain, self.caster)

		-- Reduce enemy's mana, replenish caster's.
		self.parent:ReduceMana(manadrain)
		self.caster:GiveMana(manadrain)
	end
end
