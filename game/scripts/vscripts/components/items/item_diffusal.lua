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
-- Date: 07/06/2017


-- Editor: AltiV
-- Date: 05/03/2020

LinkLuaModifier("modifier_item_imba_diffusal", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_diffusal_blade_slow", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_imba_diffusal_2", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_diffusal_blade_2_slow", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)

item_imba_diffusal_blade			= item_imba_diffusal_blade or class({})
modifier_item_imba_diffusal			= modifier_item_imba_diffusal or class({})
modifier_item_imba_diffusal_blade_slow	= modifier_item_imba_diffusal_blade_slow or class({})

item_imba_diffusal_blade_2				= item_imba_diffusal_blade_2 or class({})
modifier_item_imba_diffusal_2			= modifier_item_imba_diffusal_2 or class({})
modifier_item_imba_diffusal_blade_2_slow		= modifier_item_imba_diffusal_blade_2_slow or class({})

------------------------------
-- ITEM_IMBA_DIFFUSAL_BLADE --
------------------------------

function item_imba_diffusal_blade:GetIntrinsicModifierName()
	return "modifier_item_imba_diffusal"
end

function item_imba_diffusal_blade:OnSpellStart()
	local target = self:GetCursorTarget()
	
	-- Play cast sound
	self:GetCaster():EmitSound("DOTA_Item.DiffusalBlade.Activate")
	target:EmitSound("DOTA_Item.DiffusalBlade.Target")

	if target:TriggerSpellAbsorb(self) then return end
	
	-- Play hit particle
	local particle_target_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle_target_fx)

	-- Purge target
	target:Purge(true, false, false, false, false)
	
	-- Add the slow modifier
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_diffusal_blade_slow", {duration = self:GetSpecialValueFor("purge_slow_duration") * (1 - target:GetStatusResistance())})
	
	-- If the target is not a hero (or a creep hero), root it
	if not target:IsHero() and not target:IsRoshan() and not target:IsConsideredHero() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_rooted", {duration = self:GetSpecialValueFor("purge_root_duration") * (1 - target:GetStatusResistance())})
	end
end

---------------------------------
-- MODIFIER_ITEM_IMBA_DIFFUSAL --
---------------------------------

function modifier_item_imba_diffusal:IsHidden()		return true end
function modifier_item_imba_diffusal:IsPurgable()		return false end
function modifier_item_imba_diffusal:RemoveOnDeath()	return false end
function modifier_item_imba_diffusal:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_diffusal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

function modifier_item_imba_diffusal:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end

function modifier_item_imba_diffusal:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

-- "Does not work against allied units when attacking them."
function modifier_item_imba_diffusal:GetModifierProcAttack_BonusDamage_Physical(keys)
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local target = keys.target

	if ability and
	attacker == self:GetParent() and
	attacker:FindAllModifiersByName(self:GetName())[1] == self and
	not attacker:HasModifier("modifier_item_imba_diffusal_2") and
	not attacker:HasModifier("modifier_item_imba_witchblade") and
	attacker:GetTeamNumber() ~= target:GetTeamNumber() and
	(target.GetMaxMana and target:GetMaxMana() > 0) and
	not target:IsMagicImmune() then 
		-- Apply mana burn particle effect
		local particle_manaburn_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)
		
		local mana_burn = nil
		
		-- Determine amount of mana burn - illusions deal less
		if attacker:IsIllusion() then
			if attacker:IsRangedAttacker() then
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
			else
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee")
			end
		else
			mana_burn = ability:GetSpecialValueFor("feedback_mana_burn")
		end
		
		-- Anti Mage Compromise?...
		if attacker:HasAbility("imba_antimage_mana_break") then
			mana_burn = math.max(mana_burn - attacker:FindAbilityByName("imba_antimage_mana_break"):GetSpecialValueFor("base_mana_burn"), 0)
		end

		-- Get the target's mana, to check how much we're burning them
		local target_mana = target:GetMana()

		-- Burn mana
		target:ReduceMana(mana_burn, ability)
		
		return math.min(target_mana, mana_burn) * ability:GetSpecialValueFor("damage_per_burn")
	end
end

---------------------------------------
-- MODIFIER_ITEM_DIFFUSAL_BLADE_SLOW --
---------------------------------------

function modifier_item_imba_diffusal_blade_slow:GetEffectName()
	return "particles/items_fx/diffusal_slow.vpcf"
end

function modifier_item_imba_diffusal_blade_slow:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.purge_slow_duration	= self:GetAbility():GetSpecialValueFor("purge_slow_duration")
	self.purge_rate				= self:GetAbility():GetSpecialValueFor("purge_rate")
	self.movement_speed_slow	= -100
	
	self.slow_intervals			= (self.movement_speed_slow / self.purge_rate) * (-1)
	
	if not IsServer() then return end
	
	self:SetStackCount(self.movement_speed_slow)
	self:StartIntervalThink((self.purge_slow_duration * (1 - self:GetParent():GetStatusResistance())) / self.purge_rate)
end

function modifier_item_imba_diffusal_blade_slow:OnRefresh()
	self:StartIntervalThink(-1)
	self:OnCreated()
end

-- "The slow decreases in 0.8 second intervals, so it slows for 100%/80%/60%/40%/20%, going one step down every 0.8 seconds."
function modifier_item_imba_diffusal_blade_slow:OnIntervalThink()
	self.movement_speed_slow = self.movement_speed_slow + self.slow_intervals
	self:SetStackCount(self.movement_speed_slow)
end

function modifier_item_imba_diffusal_blade_slow:IsHidden() return false end
function modifier_item_imba_diffusal_blade_slow:IsPurgable() return true end
function modifier_item_imba_diffusal_blade_slow:IsDebuff() return true end

function modifier_item_imba_diffusal_blade_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_item_imba_diffusal_blade_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

--------------------------------
-- ITEM_IMBA_DIFFUSAL_BLADE_2 --
--------------------------------

function item_imba_diffusal_blade_2:GetIntrinsicModifierName()
	return "modifier_item_imba_diffusal_2"
end

function item_imba_diffusal_blade_2:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	
	-- Play cast sound
	caster:EmitSound("DOTA_Item.DiffusalBlade.Activate")
	target:EmitSound("DOTA_Item.DiffusalBlade.Target")

	if target:TriggerSpellAbsorb(self) then return end

	-- Play hit particle
	local particle_target_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(particle_target_fx)

	-- Get the initial amount of modifiers for Combust
	local initial_modifiers = target:GetModifierCount()

	-- Purge target
	target:Purge(true, false, false, false, false)

	caster:SetContextThink(DoUniqueString(self:GetName()), function()
		if initial_modifiers - target:GetModifierCount() > 0 then
			-- Burn mana and deal damage according to modifiers lost on the purge
			local mana_burn = (initial_modifiers - target:GetModifierCount()) * self:GetSpecialValueFor("dispel_burn")
			local target_mana = target:GetMana()

			-- Apply particle effect
			local particle_dispel_fx = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_2_dispel_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(particle_dispel_fx)

			target:ReduceMana(mana_burn, self)

			ApplyDamage({
				victim			= target,
				attacker		= caster,
				damage			= math.min(mana_burn, target_mana),
				damage_type		= DAMAGE_TYPE_MAGICAL,
				ability			= self,
				damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
			})
		end

		-- Add the slow modifier
		target:AddNewModifier(caster, self, "modifier_item_imba_diffusal_blade_2_slow", {duration = self:GetSpecialValueFor("purge_slow_duration") * (1 - target:GetStatusResistance())})
		
		-- If the target is not a hero (or a creep hero), root it
		if not target:IsHero() and not target:IsRoshan() and not target:IsConsideredHero() then
			target:AddNewModifier(caster, self, "modifier_rooted", {duration = self:GetSpecialValueFor("purge_root_duration") * (1 - target:GetStatusResistance())})
		end
	
		return
	end, FrameTime())
end

---------------------------------
-- MODIFIER_ITEM_IMBA_DIFFUSAL --
---------------------------------

function modifier_item_imba_diffusal_2:IsHidden()		return true end
function modifier_item_imba_diffusal_2:IsPurgable()		return false end
function modifier_item_imba_diffusal_2:RemoveOnDeath()	return false end
function modifier_item_imba_diffusal_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_diffusal_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end

function modifier_item_imba_diffusal_2:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end

function modifier_item_imba_diffusal_2:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

-- "Does not work against allied units when attacking them."
function modifier_item_imba_diffusal_2:GetModifierProcAttack_BonusDamage_Physical(keys)
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local target = keys.target
	
	if ability and 
	attacker == self:GetParent() and 
	attacker:FindAllModifiersByName(self:GetName())[1] == self and 
	not attacker:HasModifier("modifier_item_imba_witchblade") and 
	attacker:GetTeamNumber() ~= target:GetTeamNumber() and 
	(target.GetMaxMana and target:GetMaxMana() > 0) 
	and not target:IsMagicImmune() then 
		-- Apply mana burn particle effect
		local particle_manaburn_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
		ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)
		
		local mana_burn = nil
		
		-- Determine amount of mana burn - illusions deal less
		if attacker:IsIllusion() then
			if attacker:IsRangedAttacker() then
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_ranged")
			else
				mana_burn = ability:GetSpecialValueFor("feedback_mana_burn_illusion_melee")
			end
		else
			mana_burn = ability:GetSpecialValueFor("feedback_mana_burn")
		end
		
		-- Anti Mage Compromise?...
		if attacker:HasAbility("imba_antimage_mana_break") then
			mana_burn = math.max(mana_burn - attacker:FindAbilityByName("imba_antimage_mana_break"):GetSpecialValueFor("base_mana_burn"), 0)
		end

		-- Get the target's mana, to check how much we're burning them
		local target_mana = target:GetMana()

		-- Burn mana
		target:ReduceMana(mana_burn, ability)
		
		-- IMBAfication: Mana Combustion
		if RollPseudoRandom(ability:GetSpecialValueFor("dispel_chance_pct"), self) then
			-- Look if there is at least one buff to dispel			
			local purgable_buffs = {}
			
			for _, modifier in pairs(target:FindAllModifiers()) do
				if modifier.IsDebuff and modifier.IsPurgable then
					if not modifier:IsDebuff() and modifier:IsPurgable() then
						table.insert(purgable_buffs, modifier)
					end
				end
			end
			
			if #purgable_buffs >= 1 then
				purgable_buffs[RandomInt(1, #purgable_buffs)]:Destroy()
			end
			
			-- Apply particle effect
			local particle_dispel_fx = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_2_dispel_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(particle_dispel_fx)
			
			-- Burn additional mana and deal magical damage
			local target_mana = target:GetMana()
			target:ReduceMana(ability:GetSpecialValueFor("dispel_burn"), ability)

			-- Deal appropriate magical damage, based on mana burnt
			local damageTable = {
				victim			= target,
				attacker		= attacker,
				damage			= math.min(ability:GetSpecialValueFor("dispel_burn"), target_mana),
				damage_type 	= DAMAGE_TYPE_MAGICAL,
				ability			= ability,
				damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
			}
			
			ApplyDamage(damageTable)
		end
		
		-- The target_mana and mana_burn variables are from the regular proc, and not from the Combust code block
		return math.min(target_mana, mana_burn) * ability:GetSpecialValueFor("damage_per_burn")
	end
end

-----------------------------------------
-- MODIFIER_ITEM_DIFFUSAL_BLADE_SLOW_2 --
-----------------------------------------

function modifier_item_imba_diffusal_blade_2_slow:GetEffectName()
	return "particles/items_fx/diffusal_slow.vpcf"
end

function modifier_item_imba_diffusal_blade_2_slow:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.purge_slow_duration	= self:GetAbility():GetSpecialValueFor("purge_slow_duration")
	self.purge_rate				= self:GetAbility():GetSpecialValueFor("purge_rate")
	self.movement_speed_slow	= -100
	
	self.slow_intervals			= (self.movement_speed_slow / self.purge_rate) * (-1)
	
	if not IsServer() then return end
	
	self:SetStackCount(self.movement_speed_slow)
	self:StartIntervalThink((self.purge_slow_duration * (1 - self:GetParent():GetStatusResistance())) / self.purge_rate)
end

function modifier_item_imba_diffusal_blade_2_slow:OnRefresh()
	self:StartIntervalThink(-1)
	self:OnCreated()
end

-- "The slow decreases in 0.8 second intervals, so it slows for 100%/80%/60%/40%/20%, going one step down every 0.8 seconds."
function modifier_item_imba_diffusal_blade_2_slow:OnIntervalThink()
	self.movement_speed_slow = self.movement_speed_slow + self.slow_intervals
	self:SetStackCount(self.movement_speed_slow)
end

function modifier_item_imba_diffusal_blade_2_slow:IsHidden() return false end
function modifier_item_imba_diffusal_blade_2_slow:IsPurgable() return true end
function modifier_item_imba_diffusal_blade_2_slow:IsDebuff() return true end

function modifier_item_imba_diffusal_blade_2_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_item_imba_diffusal_blade_2_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end



-- Old code below

-- Old KVs:

			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_agi"					"20"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_int"					"10"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "mana_burn"					"40"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "slow_degrade_pct"			"20"
			-- }
			-- "05"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "starting_slow_pct"			"100"
			-- }
			-- "06"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "stack_loss_time"			"0.8"
			-- }
			-- "07"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "total_slow_duration"		"4"
			-- }
			-- "08"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "illusion_mana_burn"		"16"
			-- }
			-- "09"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "root_duration"				"3"
			-- }
		-- }


-- -----------------------------------
-- --        DIFFUSAL BLADE         --
-- -----------------------------------
-- item_imba_diffusal_blade = item_imba_diffusal_blade or class({})
-- LinkLuaModifier("modifier_item_imba_diffusal", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_imba_diffusal_unique", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_imba_diffusal_blade_slow", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_imba_diffusal_root", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)

-- function item_imba_diffusal_blade:GetIntrinsicModifierName()
	-- return "modifier_item_imba_diffusal"
-- end

-- function item_imba_diffusal_blade:GetAbilityTextureName()
	-- return "imba_diffusal_blade"
-- end

-- function item_imba_diffusal_blade:OnSpellStart()
	-- -- Ability properties
	-- local caster = self:GetCaster()
	-- local ability = self
	-- local target = self:GetCursorTarget()
	-- local sound_cast = "DOTA_Item.DiffusalBlade.Activate"
	-- local sound_target = "DOTA_Item.DiffusalBlade.Target"
	-- local particle_target = "particles/generic_gameplay/generic_manaburn.vpcf"
	-- local modifier_purge = "modifier_item_imba_diffusal_blade_slow"
	-- local modifier_root = "modifier_item_imba_diffusal_root"

	-- -- Ability specials
	-- local total_slow_duration = ability:GetSpecialValueFor("total_slow_duration")
	-- local root_duration = ability:GetSpecialValueFor("root_duration")

	-- -- Play cast sound
	-- EmitSoundOn(sound_cast, caster)

	-- -- Play hit particle
	-- local particle_target_fx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_target_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(particle_target_fx)

	-- -- If the target has Linken sphere, trigger it and do nothing else
	-- if target:GetTeam() ~= caster:GetTeam() then
		-- if target:TriggerSpellAbsorb(ability) then
			-- return nil
		-- end
	-- end

	-- -- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	-- if target:IsMagicImmune() then
		-- return nil
	-- end

	-- -- Play target sound
	-- EmitSoundOn(sound_target, target)

	-- -- Purge target
	-- target:Purge(true, false, false, false, false)

	-- -- If the target is not a hero (or a creep hero), root it
	-- if not target:IsHero() and not target:IsRoshan() and not target:IsConsideredHero() then
		-- target:AddNewModifier(caster, ability, modifier_root, {duration = root_duration})
	-- end

	-- -- Add the slow modifier
	-- target:AddNewModifier(caster, ability, modifier_purge, {duration = total_slow_duration})
-- end




-- -- Diffusal stats modifier
-- modifier_item_imba_diffusal = modifier_item_imba_diffusal or class({})

-- function modifier_item_imba_diffusal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_item_imba_diffusal:IsHidden() return true end
-- function modifier_item_imba_diffusal:IsDebuff() return false end
-- function modifier_item_imba_diffusal:IsPurgable() return false end
-- function modifier_item_imba_diffusal:RemoveOnDeath() return false end

-- function modifier_item_imba_diffusal:OnCreated()
	-- -- Ability properties
	-- self.caster = self:GetCaster()
	-- self.ability = self:GetAbility()
	-- self.modifier_self = "modifier_item_imba_diffusal"
	-- self.modifier_unique = "modifier_item_imba_diffusal_unique"

	-- -- Ability specials
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	-- self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	-- if IsServer() then
		-- -- If the caster doesn't have the unique modifier yet, give it to him
		-- if not self.caster:HasModifier(self.modifier_unique) then
			-- self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
		-- end
	-- end
-- end

-- function modifier_item_imba_diffusal:OnDestroy()
	-- if IsServer() then
		-- -- If this was the last diffusal in the inventory, remove the unique effect
		-- if not self.caster:IsNull() and not self.caster:HasModifier(self.modifier_self) then
			-- self.caster:RemoveModifierByName(self.modifier_unique)
		-- end
	-- end
-- end

-- function modifier_item_imba_diffusal:DeclareFunctions()
	-- return {
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	-- }
-- end

-- function modifier_item_imba_diffusal:GetModifierBonusStats_Agility()
	-- return self.bonus_agi
-- end

-- function modifier_item_imba_diffusal:GetModifierBonusStats_Intellect()
	-- return self.bonus_int
-- end



-- -- Unique diffusal modifier (attacks burn mana)
-- modifier_item_imba_diffusal_unique = modifier_item_imba_diffusal_unique or class({})

-- function modifier_item_imba_diffusal_unique:IsHidden() return true end
-- function modifier_item_imba_diffusal_unique:IsDebuff() return false end
-- function modifier_item_imba_diffusal_unique:IsPurgable() return false end
-- function modifier_item_imba_diffusal_unique:RemoveOnDeath() return false end

-- function modifier_item_imba_diffusal_unique:OnCreated()
	-- -- Ability properties
	-- self.caster = self:GetCaster()
	-- self.ability = self:GetAbility()
	-- self.particle_manaburn = "particles/generic_gameplay/generic_manaburn.vpcf"

	-- -- Ability specials
	-- self.mana_burn = self.ability:GetSpecialValueFor("mana_burn")
	-- self.illusion_mana_burn = self.ability:GetSpecialValueFor("illusion_mana_burn")
-- end

-- function modifier_item_imba_diffusal_unique:DeclareFunctions()
	-- local decFuncs = {MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}

	-- return decFuncs
-- end

-- function modifier_item_imba_diffusal_unique:GetModifierProcAttack_BonusDamage_Physical(keys)
	-- if IsServer() then
		-- local attacker = keys.attacker
		-- local target = keys.target

		-- -- Only apply if the attacker is the caster
		-- if attacker == self.caster then
			-- -- If the attacker has higher level diffusal blades, do nothing
			-- if self.caster:HasModifier("modifier_item_imba_diffusal_2_unique") or self.caster:HasModifier("modifier_item_imba_witchblade") then
				-- return nil
			-- end

			-- -- Don't apply when attacking teammates
			-- if attacker:GetTeamNumber() == target:GetTeamNumber() then
				-- return nil
			-- end

			-- -- Don't apply on anything that is not a hero or a creep
			-- if not target:IsHero() and not target:IsCreep() then
				-- return nil
			-- end

			-- -- Don't apply on units that have no mana
			-- if target:GetMaxMana() == 0 then
				-- return nil
			-- end

			-- -- Don't apply on spell immune targets
			-- if target:IsMagicImmune() then
				-- return nil
			-- end

			-- -- Apply mana burn particle effect
			-- local particle_manaburn_fx = ParticleManager:CreateParticle(self.particle_manaburn, PATTACH_ABSORIGIN_FOLLOW, target)
			-- ParticleManager:SetParticleControl(particle_manaburn_fx, 0, target:GetAbsOrigin())
			-- ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)

			-- -- Determine amount of mana burn - illusions deal less
			-- local mana_burn
			-- if attacker:IsIllusion() then
				-- mana_burn = self.illusion_mana_burn
			-- else
				-- mana_burn = self.mana_burn
			-- end

			-- -- Anti Mage Compromise?...
			-- if self.caster:HasAbility("imba_antimage_mana_break") then
				-- mana_burn = math.max(mana_burn - self.caster:FindAbilityByName("imba_antimage_mana_break"):GetSpecialValueFor("base_mana_burn"), 0)
			-- end

			-- -- Get the target's mana, to check how much we're burning him
			-- local target_mana = target:GetMana()

			-- -- Burn mana
			-- target:ReduceMana(mana_burn, nil)

			-- -- Damage target depending on amount of mana actually burnt
			-- local damage
			-- if target_mana >= mana_burn then
				-- damage = mana_burn
			-- else
				-- damage = target_mana
			-- end

			-- return damage
		-- end
	-- end
-- end


-- -- Slow modifier
-- modifier_item_imba_diffusal_blade_slow = modifier_item_imba_diffusal_blade_slow or class({})

-- function modifier_item_imba_diffusal_blade_slow:OnCreated()
	-- -- Ability properties
	-- self.caster = self:GetCaster()
	-- self.ability = self:GetAbility()

	-- -- Ability specials
	-- self.slow_degrade_pct = self.ability:GetSpecialValueFor("slow_degrade_pct")
	-- self.starting_slow_pct = self.ability:GetSpecialValueFor("starting_slow_pct")
	-- self.stack_loss_time = self.ability:GetSpecialValueFor("stack_loss_time")

	-- -- Set slow
	-- self.slow_pct = self.starting_slow_pct

	-- -- Start thinking
	-- self:StartIntervalThink(self.stack_loss_time)
-- end

-- function modifier_item_imba_diffusal_blade_slow:OnIntervalThink()
	-- -- Reduce the slow
	-- self.slow_pct = self.slow_pct - self.slow_degrade_pct
-- end

-- function modifier_item_imba_diffusal_blade_slow:IsHidden() return false end
-- function modifier_item_imba_diffusal_blade_slow:IsPurgable() return true end
-- function modifier_item_imba_diffusal_blade_slow:IsDebuff() return true end

-- function modifier_item_imba_diffusal_blade_slow:DeclareFunctions()
	-- return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
-- end

-- function modifier_item_imba_diffusal_blade_slow:GetModifierMoveSpeedBonus_Percentage()
	-- return self.slow_pct * (-1)
-- end

-- function modifier_item_imba_diffusal_blade_slow:GetEffectName()
	-- return "particles/items_fx/diffusal_slow.vpcf"
-- end

-- function modifier_item_imba_diffusal_blade_slow:GetEffectAttachType()
	-- return PATTACH_ABSORIGIN_FOLLOW
-- end



-- -- Root modifier
-- modifier_item_imba_diffusal_root = modifier_item_imba_diffusal_root or class({})

-- function modifier_item_imba_diffusal_root:CheckState()
	-- local state = {[MODIFIER_STATE_ROOTED] = true}

	-- return state
-- end










-- Old KVs

			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_agi"					"40"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_int"					"18"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "mana_burn"					"60"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "slow_degrade_pct"			"20"
			-- }	
			-- "05"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "starting_slow_pct"			"100"
			-- }			
			-- "06"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "stack_loss_time"			"0.8"
			-- }
			-- "07"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "total_slow_duration"		"4"
			-- }
			-- "08"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "illusion_mana_burn"		"25"
			-- }
			-- "09"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "root_duration"				"3"
			-- }
			-- "10"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "dispel_chance_pct"			"20"
			-- }
			-- "11"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "dispel_burn"				"100"
			-- }

-- -----------------------------------
-- --          PURGEBLADE           --
-- -----------------------------------
-- item_imba_diffusal_blade_2 = item_imba_diffusal_blade_2 or class({})
-- LinkLuaModifier("modifier_item_imba_diffusal_2", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_imba_diffusal_2_unique", "components/items/item_diffusal", LUA_MODIFIER_MOTION_NONE)

-- function item_imba_diffusal_blade_2:GetAbilityTextureName()
	-- return "imba_diffusal_blade_2"
-- end

-- function item_imba_diffusal_blade_2:GetIntrinsicModifierName()
	-- return "modifier_item_imba_diffusal_2"
-- end

-- function item_imba_diffusal_blade_2:OnSpellStart()
	-- -- Ability properties
	-- local caster = self:GetCaster()
	-- local ability = self
	-- local target = self:GetCursorTarget()
	-- local sound_cast = "DOTA_Item.DiffusalBlade.Activate"
	-- local sound_target = "DOTA_Item.DiffusalBlade.Target"
	-- local particle_target = "particles/item/diffusal/diffusal_manaburn_2.vpcf"
	-- local particle_dispel = "particles/item/diffusal/diffusal_2_dispel_explosion.vpcf"
	-- local modifier_purge = "modifier_item_imba_diffusal_blade_slow"
	-- local modifier_root = "modifier_item_imba_diffusal_root"

	-- -- Ability specials
	-- local total_slow_duration = ability:GetSpecialValueFor("total_slow_duration")
	-- local root_duration = ability:GetSpecialValueFor("root_duration")
	-- local dispel_burn = ability:GetSpecialValueFor("dispel_burn")

	-- -- Play cast sound
	-- EmitSoundOn(sound_cast, caster)

	-- -- Play hit particle
	-- local particle_target_fx = ParticleManager:CreateParticle(particle_target, PATTACH_ABSORIGIN_FOLLOW, target)
	-- ParticleManager:SetParticleControl(particle_target_fx, 0, target:GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(particle_target_fx)

	-- -- If the target has Linken sphere, trigger it and do nothing else
	-- if target:GetTeam() ~= caster:GetTeam() then
		-- if target:TriggerSpellAbsorb(ability) then
			-- return nil
		-- end
	-- end

	-- -- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
	-- if target:IsMagicImmune() then
		-- return nil
	-- end

	-- -- Play target sound
	-- EmitSoundOn(sound_target, target)

	-- -- Get the initial amount of modifiers
	-- local initial_modifiers = target:GetModifierCount()

	-- -- Purge target
	-- target:Purge(true, false, false, false, false)

	-- -- Find the amount of modifiers it has after it has been purged. Give it a frame to lose modifiers
	-- Timers:CreateTimer(FrameTime(), function()
		-- local modifiers_lost = initial_modifiers - target:GetModifierCount()

		-- if modifiers_lost > 0 then
			-- -- Burn mana and deal damage according to modifiers lost on the purge
			-- local mana_burn = modifiers_lost * dispel_burn

			-- -- Burn the target's mana
			-- local target_mana = target:GetMana()
			-- target:ReduceMana(mana_burn, nil)

			-- -- Calculate damage according to burnt mana
			-- local damage
			-- if target_mana >= mana_burn then
				-- damage = mana_burn
			-- else
				-- damage = target_mana
			-- end

			-- -- Damage the target
			-- local damageTable = {victim = target,
				-- attacker = caster,
				-- damage = damage,
				-- damage_type = DAMAGE_TYPE_MAGICAL,
				-- ability = ability,
				-- damage_flags = (DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
			-- }

			-- ApplyDamage(damageTable)

			-- -- Apply particle effect
			-- local particle_dispel_fx = ParticleManager:CreateParticle(particle_dispel, PATTACH_ABSORIGIN_FOLLOW, target)
			-- ParticleManager:SetParticleControl(particle_dispel_fx, 0, target:GetAbsOrigin())
			-- ParticleManager:ReleaseParticleIndex(particle_dispel_fx)
		-- end

		-- -- If the target is not a hero (or a creep hero), root it
		-- if not target:IsHero() and not target:IsRoshan() and not target:IsConsideredHero() then
			-- target:AddNewModifier(caster, ability, modifier_root, {duration = root_duration})
		-- end

		-- -- Add the slow modifier
		-- target:AddNewModifier(caster, ability, modifier_purge, {duration = total_slow_duration})
	-- end)
-- end




-- -- Diffusal stats modifier
-- modifier_item_imba_diffusal_2 = modifier_item_imba_diffusal_2 or class({})

-- function modifier_item_imba_diffusal_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_item_imba_diffusal_2:IsHidden() return true end
-- function modifier_item_imba_diffusal_2:IsDebuff() return false end
-- function modifier_item_imba_diffusal_2:IsPurgable() return false end
-- function modifier_item_imba_diffusal_2:RemoveOnDeath() return false end

-- function modifier_item_imba_diffusal_2:OnCreated()
	-- -- Ability properties
	-- self.caster = self:GetCaster()
	-- self.ability = self:GetAbility()
	-- self.modifier_self = "modifier_item_imba_diffusal_2"
	-- self.modifier_unique = "modifier_item_imba_diffusal_2_unique"

	-- -- Ability specials
	-- self.bonus_agi = self.ability:GetSpecialValueFor("bonus_agi")
	-- self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	-- if IsServer() then
		-- -- If the caster doesn't have the unique modifier yet, give it to him
		-- if not self.caster:HasModifier(self.modifier_unique) then
			-- self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
		-- end
	-- end
-- end

-- function modifier_item_imba_diffusal_2:OnDestroy()
	-- if IsServer() then
		-- -- If this was the last diffusal in the inventory, remove the unique effect
		-- if not self.caster:IsNull() and not self.caster:HasModifier(self.modifier_self) then
			-- self.caster:RemoveModifierByName(self.modifier_unique)
		-- end
	-- end
-- end

-- function modifier_item_imba_diffusal_2:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		-- MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	-- }

	-- return decFuncs
-- end

-- function modifier_item_imba_diffusal_2:GetModifierBonusStats_Agility()
	-- return self.bonus_agi
-- end

-- function modifier_item_imba_diffusal_2:GetModifierBonusStats_Intellect()
	-- return self.bonus_int
-- end




-- -- Unique diffusal modifier 2 (attacks burn mana, chance to dispel)
-- modifier_item_imba_diffusal_2_unique = modifier_item_imba_diffusal_2_unique or class({})

-- function modifier_item_imba_diffusal_2_unique:IsHidden() return true end
-- function modifier_item_imba_diffusal_2_unique:IsDebuff() return false end
-- function modifier_item_imba_diffusal_2_unique:IsPurgable() return false end
-- function modifier_item_imba_diffusal_2_unique:RemoveOnDeath() return false end

-- function modifier_item_imba_diffusal_2_unique:OnCreated()
	-- -- Ability properties
	-- self.caster = self:GetCaster()
	-- self.ability = self:GetAbility()
	-- self.particle_manaburn = "particles/item/diffusal/diffusal_manaburn_2.vpcf"
	-- self.particle_dispel = "particles/item/diffusal/diffusal_2_dispel_explosion.vpcf"

	-- -- Ability specials
	-- self.mana_burn = self.ability:GetSpecialValueFor("mana_burn")
	-- self.illusion_mana_burn = self.ability:GetSpecialValueFor("illusion_mana_burn")
	-- self.dispel_chance_pct = self.ability:GetSpecialValueFor("dispel_chance_pct")
	-- self.dispel_burn = self.ability:GetSpecialValueFor("dispel_burn")
-- end

-- function modifier_item_imba_diffusal_2_unique:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
	-- }

	-- return decFuncs
-- end

-- function modifier_item_imba_diffusal_2_unique:GetModifierProcAttack_BonusDamage_Physical(keys)
	-- if IsServer() then
		-- local attacker = keys.attacker
		-- local target = keys.target

		-- -- Only apply if the attacker is the caster
		-- if attacker == self.caster then
			-- -- If the attacker has higher level diffusal blades or AM's mana break, do nothing
			-- if self.caster:HasModifier("modifier_item_imba_witchblade") then
				-- return nil
			-- end

			-- -- Don't apply when attacking teammates
			-- if attacker:GetTeamNumber() == target:GetTeamNumber() then
				-- return nil
			-- end

			-- -- Don't apply on anything that is not a hero or a creep
			-- if not target:IsHero() and not target:IsCreep() then
				-- return nil
			-- end

			-- -- Don't apply on units that have no mana
			-- if target:GetMaxMana() == 0 then
				-- return nil
			-- end

			-- -- Don't apply on spell immune targets
			-- if target:IsMagicImmune() then
				-- return nil
			-- end

			-- -- Apply mana burn particle effect
			-- local particle_manaburn_fx = ParticleManager:CreateParticle(self.particle_manaburn, PATTACH_ABSORIGIN_FOLLOW, target)
			-- ParticleManager:SetParticleControl(particle_manaburn_fx, 0, target:GetAbsOrigin())
			-- ParticleManager:ReleaseParticleIndex(particle_manaburn_fx)

			-- -- Determine amount of mana burn - illusions deal less
			-- local mana_burn
			-- if attacker:IsIllusion() then
				-- mana_burn = self.illusion_mana_burn
			-- else
				-- mana_burn = self.mana_burn
			-- end

			-- -- Anti Mage Compromise?...
			-- if self.caster:HasAbility("imba_antimage_mana_break") then
				-- mana_burn = math.max(mana_burn - self.caster:FindAbilityByName("imba_antimage_mana_break"):GetSpecialValueFor("base_mana_burn"), 0)
			-- end

			-- -- Get the target's mana, to check how much we're burning him
			-- local target_mana = target:GetMana()

			-- -- Burn mana
			-- target:ReduceMana(mana_burn, nil)

			-- -- Damage target depending on amount of mana actually burnt
			-- local damage
			-- if target_mana >= mana_burn then
				-- damage = mana_burn
			-- else
				-- damage = target_mana
			-- end

			-- return damage
		-- end
	-- end
-- end


-- function modifier_item_imba_diffusal_2_unique:OnAttackLanded(keys)
	-- if IsServer() then
		-- local attacker = keys.attacker
		-- local target = keys.target

		-- -- Only apply if the attacker is the caster
		-- if attacker == self.caster then

			-- -- Don't apply when attacking teammates
			-- if attacker:GetTeamNumber() == target:GetTeamNumber() then
				-- return nil
			-- end

			-- -- Don't apply on anything that is not a hero or a creep
			-- if not target:IsHero() and not target:IsCreep() then
				-- return nil
			-- end

			-- -- Don't apply on spell immune targets
			-- if target:IsMagicImmune() then
				-- return nil
			-- end

			-- -- Roll for a chance to dispel a buff
			-- if RollPseudoRandom(self.dispel_chance_pct, self) then

				-- -- Look if there is at least one buff to dispel
				-- local target_modifiers = target:FindAllModifiers()

				-- -- Search for a buff
				-- local buff_found = false
				-- for _,modifier in pairs(target_modifiers) do
					-- if modifier.IsDebuff and modifier.IsPurgable then
						-- if not modifier:IsDebuff() and modifier:IsPurgable() then
							-- buff_found = true
							-- break
						-- end
					-- end
				-- end

				-- if buff_found then
					-- -- Randomize a buff to dispel. Try 100 times maximum (to prevent weird cases of infinite loops)
					-- local buff_dispelled = false
					-- local check_count = 0

					-- while not buff_dispelled do

						-- -- Random a modifier
						-- local modifier = target_modifiers[math.random(1, #target_modifiers)]

						-- -- Check if it is a buff
						-- if modifier.IsDebuff and modifier.IsPurgable then
							-- if not modifier:IsDebuff() and modifier:IsPurgable() then
								-- target:RemoveModifierByName(modifier:GetName())
								-- buff_dispelled = true

								-- -- Burn additional mana and deal magical damage
								-- local target_mana = target:GetMana()
								-- target:ReduceMana(self.dispel_burn, nil)

								-- -- Calculate damage
								-- local damage
								-- if target_mana >= self.dispel_burn then
									-- damage = self.dispel_burn
								-- else
									-- damage = target_mana
								-- end

								-- -- Deal appropriate magical damage, based on mana burnt
								-- local damageTable = {victim = target,
									-- attacker = attacker,
									-- damage = damage,
									-- damage_type = DAMAGE_TYPE_MAGICAL,
									-- ability = ability,
									-- damage_flags = (DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL)
								-- }

								-- ApplyDamage(damageTable)

								-- -- Apply particle effect
								-- local particle_dispel_fx = ParticleManager:CreateParticle(self.particle_dispel, PATTACH_ABSORIGIN_FOLLOW, target)
								-- ParticleManager:SetParticleControl(particle_dispel_fx, 0, target:GetAbsOrigin())
								-- ParticleManager:ReleaseParticleIndex(particle_dispel_fx)
							-- end
						-- end

						-- check_count = check_count + 1
						-- if check_count >= 100 then
							-- break
						-- end
					-- end
				-- end
			-- end
		-- end
	-- end
-- end
