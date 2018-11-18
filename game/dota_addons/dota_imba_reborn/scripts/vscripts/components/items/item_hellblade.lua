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
-- Updated: 10/5/2017

if item_imba_hellblade == nil then
	item_imba_hellblade = class({})
end
LinkLuaModifier("modifier_item_imba_hellblade", "components/items/item_hellblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hellblade_unique", "components/items/item_hellblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hellblade_debuff", "components/items/item_hellblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_helldrain", "components/items/item_hellblade", LUA_MODIFIER_MOTION_NONE)


function item_imba_hellblade:GetIntrinsicModifierName()
	return "modifier_item_imba_hellblade"
end

function item_imba_hellblade:GetAbilityTextureName()
	return "custom/imba_hellblade"
end

function item_imba_hellblade:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local ability = self
		local sound_cast = "Imba.Curseblade"
		local datadrive_baseclass = "modifier_datadriven"
		local debuff = "modifier_item_imba_hellblade_debuff"

		-- Ability specials
		local duration = self:GetSpecialValueFor("duration")

		-- Play sound cast
		EmitSoundOn(sound_cast, caster)

		-- Add the curse debuff to the target
		target:AddNewModifier(caster, ability, debuff, {duration = duration})

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
	end
end

function item_imba_hellblade:TransferAllDebuffs(caster, target)
	if IsServer() then
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
--			HELLDRAIN AURA
-------------------------------------------
LinkLuaModifier("modifier_imba_helldrain_damage", "components/items/item_hellblade", LUA_MODIFIER_MOTION_NONE)
modifier_imba_helldrain = modifier_imba_helldrain or class({})

-- Aura properties
function modifier_imba_helldrain:IsAura() return true end
function modifier_imba_helldrain:IsHidden() return true end
function modifier_imba_helldrain:IsDebuff()  return false end
function modifier_imba_helldrain:IsPurgable()  return false end
function modifier_imba_helldrain:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_helldrain:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_imba_helldrain:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_aoe") end
function modifier_imba_helldrain:GetModifierAura() return "modifier_imba_helldrain_damage" end

-- Start aura
function modifier_imba_helldrain:OnCreated()
	if IsServer() then
		self:StartIntervalThink( self:GetAbility():GetSpecialValueFor("aura_damage_heal_interval") )
	end
end

function modifier_imba_helldrain:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

-- Heal and Distribute damage modifier
function modifier_imba_helldrain:OnIntervalThink()
	if IsServer() then
		--Ability properties
		local item 					=	self:GetAbility()
		local caster				= 	item:GetCaster()
		local location 				=	caster:GetAbsOrigin()

		--Ability paramaters
		local radius 				=	item:GetSpecialValueFor("aura_aoe")
		local heal_per_enemy		= 	item:GetSpecialValueFor("aura_damage_per_second")
		local heal_interval			=	item:GetSpecialValueFor("aura_damage_heal_interval")

		if caster:IsIllusion() then
			heal_per_enemy = heal_per_enemy / 2
		end
		
		--Search for nearby enemies
		local enemies 				= 	FindUnitsInRadius(caster:GetTeamNumber(), location, nil, radius, item:GetAbilityTargetTeam(), item:GetAbilityTargetType(), item:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)

		local valid_enemies = 0
		for _,enemy in pairs(enemies) do
			if enemy:HasModifier("modifier_imba_helldrain_damage") then
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
modifier_imba_helldrain_damage = modifier_imba_helldrain_damage or class ({})
-- Modifier properties
function modifier_imba_helldrain_damage:IsHidden() return false end
function modifier_imba_helldrain_damage:IsDebuff() return true end
function modifier_imba_helldrain_damage:IsPurgable() return false end
function modifier_imba_helldrain_damage:GetEffectName()	return "particles/item/curseblade/imba_hellblade_rope_pnt.vpcf" end


-- Passive stats modifier (stackable)
if modifier_item_imba_hellblade == nil then
	modifier_item_imba_hellblade = class({})
end

function modifier_item_imba_hellblade:IsHidden() return true end
function modifier_item_imba_hellblade:IsPurgable() return false end
function modifier_item_imba_hellblade:IsDebuff() return false end
function modifier_item_imba_hellblade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_hellblade:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.agility_bonus = self.ability:GetSpecialValueFor("agility_bonus")
	self.intelligence_bonus = self.ability:GetSpecialValueFor("intelligence_bonus")
	self.strength_bonus = self.ability:GetSpecialValueFor("strength_bonus")
	self.damage = self.ability:GetSpecialValueFor("damage")

	if IsServer() then
		--Create the aura
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_imba_helldrain") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_helldrain", {})
		end
		-- Create a unique modifier for passive attack transfer (doesn't stack)
		if not self.caster:HasModifier("modifier_item_imba_hellblade_unique") then
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_item_imba_hellblade_unique", {})
		end
	end
end

-- Removes the unique modifier from the caster if this is the last hellblade in its inventory
function modifier_item_imba_hellblade:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_hellblade") then
			parent:RemoveModifierByName("modifier_imba_helldrain")
		end
		if not self.caster:IsNull() and not self.caster:HasModifier("modifier_item_imba_hellblade") then
			self.caster:RemoveModifierByName("modifier_item_imba_hellblade_unique")
		end
	end
end

function modifier_item_imba_hellblade:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return decFuncs
end

function modifier_item_imba_hellblade:GetModifierBonusStats_Agility()
	return self.agility_bonus
end

function modifier_item_imba_hellblade:GetModifierBonusStats_Intellect()
	return self.intelligence_bonus
end

function modifier_item_imba_hellblade:GetModifierBonusStats_Strength()
	return self.strength_bonus
end

function modifier_item_imba_hellblade:GetModifierBaseAttack_BonusDamage()
	return self.damage
end



-- Non-stackable modifier for on-attack events
modifier_item_imba_hellblade_unique = class({})

function modifier_item_imba_hellblade_unique:IsHidden() return true end
function modifier_item_imba_hellblade_unique:IsPurgable() return false end
function modifier_item_imba_hellblade_unique:IsDebuff() return false end


function modifier_item_imba_hellblade_unique:OnCreated()

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_cast = "Imba.Curseblade"
	self.datadrive_baseclass = "modifier_datadriven"

	-- Ability specials
	self.transfer_chance = self.ability:GetSpecialValueFor("transfer_chance")

end

function modifier_item_imba_hellblade_unique:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACKED}

	return decFuncs
end

function modifier_item_imba_hellblade_unique:OnAttacked(keys)
	if IsServer() then
		-- Ability properties
		local target = keys.attacker
		local modifier_transferred = false
		local debuff_found = false
		local is_valid_debuff = false

		-- Only apply on the caster being attacked, if the roll is in the range
		if keys.target == self.caster and RollPseudoRandom(self.transfer_chance, self) then

			-- If the attacker is magic immune, we cannot transfer debuffs to him. Do nothing!
			if target:IsMagicImmune() then
				return nil
			end

			-- Find all modifiers on caster, check if it has at least one purgable debuff
			local modifiers = self.caster:FindAllModifiers()
			for _,modifier in pairs(modifiers) do

				-- Lua based debuff/purgable declaration
				if modifier.IsDebuff and modifier.IsPurgable then
					if modifier:IsDebuff() and modifier:IsPurgable() then
						debuff_found = true
						break
					end
				end

				local modifier_name = modifier:GetName()

				-- Check via vanilla modifiers list
				if not debuff_found then
					if IsVanillaDebuff(modifier_name) then
						debuff_found = true
					end
				end

				-- If it wasn't found yet, compare debuff to try and find it in the KV debuff list
				if not debuff_found then
					for _,modifier_name_in_list in pairs(DISPELLABLE_DEBUFF_LIST) do
						if modifier_name == modifier_name_in_list then
							debuff_found = true
							break
						end
					end
				end

				-- Break outer for
				if debuff_found then
					break
				end
			end

			if debuff_found then
				while not modifier_transferred do
					-- Find a random modifier
					local random_modifier_index = math.random(1,#modifiers)
					local modifier = modifiers[random_modifier_index]

					-- Check if it is one of the debuffs that were found
					local modifier_name = modifier:GetName()

					-- Lua based debuff/purgable declaration
					if modifier.IsDebuff and modifier.IsPurgable then
						if modifier:IsDebuff() and modifier:IsPurgable() then
							is_valid_debuff = true
						end
					end

					if not is_valid_debuff then
						if IsVanillaDebuff(modifier_name) then
							is_valid_debuff = true
						end
					end

					-- if it wasn't found, compare debuffs to try and find it in the KV debuff list
					if not is_valid_debuff then
						for _,modifier_name_in_list in pairs(DISPELLABLE_DEBUFF_LIST) do
							if modifier_name == modifier_name_in_list then
								is_valid_debuff = true
								break
							end
						end
					end

					-- If a match was found, get its remaining duration, and remove it from caster
					if is_valid_debuff then
						local modifier_duration = modifier:GetRemainingTime()
						self.caster:RemoveModifierByName(modifier_name)

						-- Mark debuff as transferred
						modifier_transferred = true

						-- Find if it is a lua based ability or datadriven and assign the correct function
						local modifier_ability = modifier:GetAbility()
						local modifier_class = modifier:GetClass()

						if modifier_class == self.datadrive_baseclass then
							modifier_ability:ApplyDataDrivenModifier(self.caster, target, modifier_name, {duration = modifier_duration})
						else
							target:AddNewModifier(self.caster, modifier_ability, modifier_name, {duration = modifier_duration})
						end
					end
				end
			end
		end
	end
end




-- Active drain/slow modifier
modifier_item_imba_hellblade_debuff = class({})

function modifier_item_imba_hellblade_debuff:IsDebuff()
	return true
end

function modifier_item_imba_hellblade_debuff:IsHidden()
	return false
end

function modifier_item_imba_hellblade_debuff:IsPurgable()
	return true
end

function modifier_item_imba_hellblade_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.particle_drain = "particles/hero/skeleton_king/skeleton_king_vampiric_aura_lifesteal.vpcf"

	-- Ability specials
	self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")
	self.lifedrain_per_second = self.ability:GetSpecialValueFor("lifedrain_per_second")
	self.manadrain_per_second = self.ability:GetSpecialValueFor("manadrain_per_second")
	self.slow_amount = self.ability:GetSpecialValueFor("slow_amount")

	-- Transfer debuffs
	self.ability:TransferAllDebuffs(self.caster, self.parent)

	-- Start interval for ticking HP/MP drain.
	self:StartIntervalThink(self.tick_rate)
end

function modifier_item_imba_hellblade_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_item_imba_hellblade_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_amount
end

function modifier_item_imba_hellblade_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_imba_hellblade_debuff:GetEffectName()
	return "particles/item/curseblade/imba_hellblade_curse.vpcf"
end

function modifier_item_imba_hellblade_debuff:OnIntervalThink()
	if IsServer() then
		-- Transfer debuffs to the cursed target
		self.ability:TransferAllDebuffs(self.caster, self.parent)

		-- Show drain particles
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
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			ability = self.ability}

		ApplyDamage(damageTable)

		self.caster:Heal(lifedrain, self.caster)

		-- Reduce enemy's mana, replenish caster's.
		self.parent:ReduceMana(manadrain)
		self.caster:GiveMana(manadrain)
	end
end
