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
--	Date: 			15.08.2015
--	Last Update:	18.05.2017
-- 	Updated by AtroCty
-----------------------------------------------------------------------------------------------------------
--	Orchid definition
-----------------------------------------------------------------------------------------------------------

item_imba_orchid = item_imba_orchid or class({})
LinkLuaModifier( "modifier_item_imba_orchid", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_orchid_debuff", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )	-- Active debuff

function item_imba_orchid:GetAbilityTextureName()
	return "custom/imba_orchid"
end

function item_imba_orchid:GetIntrinsicModifierName()
	return "modifier_item_imba_orchid" end

function item_imba_orchid:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local silence_duration = self:GetSpecialValueFor("silence_duration")

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- Play the cast sound
		target:EmitSound("DOTA_Item.Orchid.Activate")

		-- Apply the Orchid debuff
		target:AddNewModifier(caster, self, "modifier_item_imba_orchid_debuff", {duration = silence_duration})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Orchid owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_orchid = modifier_item_imba_orchid or class({})
function modifier_item_imba_orchid:IsHidden() return true end
function modifier_item_imba_orchid:IsDebuff() return false end
function modifier_item_imba_orchid:IsPurgable() return false end
function modifier_item_imba_orchid:IsPermanent() return true end
function modifier_item_imba_orchid:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_orchid:OnDestroy()
	self:CheckUnique(false)
end

function modifier_item_imba_orchid:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.bonus_attack_speed = self.item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = self.item:GetSpecialValueFor("bonus_mana_regen")
		self.spell_power = self.item:GetSpecialValueFor("spell_power")
		self:CheckUnique(true)
	end
end

-- Attribute bonuses
function modifier_item_imba_orchid:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_orchid:GetModifierBonusStats_Intellect()
	return self.bonus_intellect end

function modifier_item_imba_orchid:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed end

function modifier_item_imba_orchid:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage end

function modifier_item_imba_orchid:GetModifierConstantManaRegen()
	return self.bonus_mana_regen end

function modifier_item_imba_orchid:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,{"modifier_item_imba_bloodthorn"})
end

-----------------------------------------------------------------------------------------------------------
--	Orchid active debuff
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_orchid_debuff = modifier_item_imba_orchid_debuff or class({})
function modifier_item_imba_orchid_debuff:IsHidden() return false end
function modifier_item_imba_orchid_debuff:IsDebuff() return true end
function modifier_item_imba_orchid_debuff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_orchid_debuff:GetEffectName()
	return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_imba_orchid_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Reset damage storage tracking, track debuff parameters to prevent errors if the item is unequipped
function modifier_item_imba_orchid_debuff:OnCreated()
	if IsServer() then
		local owner = self:GetParent()
		owner.orchid_damage_storage = owner.orchid_damage_storage or 0
		self.damage_factor = self:GetAbility():GetSpecialValueFor("silence_damage_percent")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_orchid_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- Declare modifier states
function modifier_item_imba_orchid_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_SILENCED] = true,
	}
	return states
end

-- Track damage taken
function modifier_item_imba_orchid_debuff:OnTakeDamage(keys)
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.unit

		-- If this unit is the one suffering damage, store it
		if owner == target then
			owner.orchid_damage_storage = owner.orchid_damage_storage + keys.damage
		end
	end
end

-- When the debuff ends, deal damage
function modifier_item_imba_orchid_debuff:OnDestroy()
	if IsServer() then

		-- Parameters
		local owner = self:GetParent()
		local ability = self:GetAbility()
		local caster = ability:GetCaster()

		-- If damage was taken, play the effect and damage the owner
		if owner.orchid_damage_storage > 0 then

			-- Calculate and deal damage
			local damage = owner.orchid_damage_storage * self.damage_factor * 0.01
			ApplyDamage({attacker = caster, victim = owner, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Fire damage particle
			local orchid_end_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, owner)
			ParticleManager:SetParticleControl(orchid_end_pfx, 0, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(orchid_end_pfx, 1, Vector(100, 0, 0))
			ParticleManager:ReleaseParticleIndex(orchid_end_pfx)
		end

		-- Clear damage taken variable
		self:GetParent().orchid_damage_storage = nil
	end
end

-----------------------------------------------------------------------------------------------------------
--	Bloodthorn definition
-----------------------------------------------------------------------------------------------------------

item_imba_bloodthorn = item_imba_bloodthorn or class({})
LinkLuaModifier( "modifier_item_imba_bloodthorn", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_bloodthorn_unique", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )	-- Crit chance, unstackable
LinkLuaModifier( "modifier_item_imba_bloodthorn_attacker_crit", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )		-- Active attackers' crit buff
LinkLuaModifier( "modifier_item_imba_bloodthorn_debuff", "components/items/item_orchid.lua", LUA_MODIFIER_MOTION_NONE )	-- Active debuff

function item_imba_bloodthorn:GetAbilityTextureName()
	return "custom/imba_bloodthorn"
end

function item_imba_bloodthorn:GetIntrinsicModifierName()
	return "modifier_item_imba_bloodthorn" end

function item_imba_bloodthorn:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local silence_duration = self:GetSpecialValueFor("silence_duration")

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- If the target is magic immune (Lotus Orb/Anti Mage), do nothing
		if target:IsMagicImmune() then
			return nil
		end

		-- Play the cast sound
		target:EmitSound("DOTA_Item.Orchid.Activate")

		-- Apply the Orchid debuff
		target:AddNewModifier(caster, self, "modifier_item_imba_bloodthorn_debuff", {duration = silence_duration})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Bloodthorn owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_bloodthorn = modifier_item_imba_bloodthorn or class({})
function modifier_item_imba_bloodthorn:IsHidden() return true end
function modifier_item_imba_bloodthorn:IsDebuff() return false end
function modifier_item_imba_bloodthorn:IsPurgable() return false end
function modifier_item_imba_bloodthorn:IsPermanent() return true end
function modifier_item_imba_bloodthorn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier when created
function modifier_item_imba_bloodthorn:OnCreated()
	self.item = self:GetAbility()
	self.parent = self:GetParent()
	if self.parent:IsHero() and self.item then
		self.bonus_intellect = self.item:GetSpecialValueFor("bonus_intellect")
		self.bonus_attack_speed = self.item:GetSpecialValueFor("bonus_attack_speed")
		self.bonus_damage = self.item:GetSpecialValueFor("bonus_damage")
		self.bonus_mana_regen = self.item:GetSpecialValueFor("bonus_mana_regen")
		self.spell_power = self.item:GetSpecialValueFor("spell_power")
		self:CheckUnique(true)
		if IsServer() then
			if not self.parent:HasModifier("modifier_item_imba_bloodthorn_unique") then
				self.parent:AddNewModifier(self.parent, self.item, "modifier_item_imba_bloodthorn_unique", {})
			end
		end
	end
end


-- Removes the aura emitter from the caster if this is the last vladmir's offering in its inventory
function modifier_item_imba_bloodthorn:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_bloodthorn") then
			parent:RemoveModifierByName("modifier_item_imba_bloodthorn_unique")
		end
		self:CheckUnique(false)
	end
end


-- Attribute bonuses
function modifier_item_imba_bloodthorn:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_item_imba_bloodthorn:GetModifierBonusStats_Intellect()
	return self.bonus_intellect end

function modifier_item_imba_bloodthorn:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed end

function modifier_item_imba_bloodthorn:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage end

function modifier_item_imba_bloodthorn:GetModifierConstantManaRegen()
	return self.bonus_mana_regen end

function modifier_item_imba_bloodthorn:GetModifierSpellAmplify_Percentage()
	return self:CheckUniqueValue(self.spell_power,nil) end

-----------------------------------------------------------------------------------------------------------
--	Bloodthorn owner unique bonus (crit chance)
-----------------------------------------------------------------------------------------------------------

modifier_item_imba_bloodthorn_unique = modifier_item_imba_bloodthorn_unique or class({})
function modifier_item_imba_bloodthorn_unique:IsHidden() return true end
function modifier_item_imba_bloodthorn_unique:IsDebuff() return false end
function modifier_item_imba_bloodthorn_unique:IsPurgable() return false end
function modifier_item_imba_bloodthorn_unique:IsPermanent() return true end

-- Declare modifier events/properties
function modifier_item_imba_bloodthorn_unique:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end

-- Roll for the crit chance
function modifier_item_imba_bloodthorn_unique:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		local owner = self:GetParent()

		-- If this unit is the attacker, roll for a crit
		if owner == keys.attacker then
			if RollPercentage(self:GetAbility():GetSpecialValueFor("crit_chance")) then
				return self:GetAbility():GetSpecialValueFor("crit_damage")
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Bloodthorn active debuff
-----------------------------------------------------------------------------------------------------------
modifier_item_imba_bloodthorn_debuff = modifier_item_imba_bloodthorn_debuff or class({})
function modifier_item_imba_bloodthorn_debuff:IsHidden() return false end
function modifier_item_imba_bloodthorn_debuff:IsDebuff() return true end
function modifier_item_imba_bloodthorn_debuff:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_bloodthorn_debuff:GetEffectName()
	return "particles/items2_fx/orchid.vpcf"
end

function modifier_item_imba_bloodthorn_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Reset damage storage tracking, track debuff parameters to prevent errors if the item is unequipped
function modifier_item_imba_bloodthorn_debuff:OnCreated()
	if IsServer() then
		local owner = self:GetParent()
		if not owner.orchid_damage_storage then
			owner.orchid_damage_storage = 0
		end
		self.damage_factor = self:GetAbility():GetSpecialValueFor("silence_damage_percent")
		self.target_crit_multiplier = self:GetAbility():GetSpecialValueFor("target_crit_multiplier")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_bloodthorn_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
	return funcs
end

-- Declare modifier states
function modifier_item_imba_bloodthorn_debuff:CheckState()
	local states = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_EVADE_DISABLED] = true,
	}
	return states
end

-- Grant the crit modifier to attackers
function modifier_item_imba_bloodthorn_debuff:OnAttackStart(keys)
	if IsServer() then
		local owner = self:GetParent()

		-- If this unit is the target, grant the attacker a crit buff
		if owner == keys.target then
			local attacker = keys.attacker
			attacker:AddNewModifier(owner, self:GetAbility(), "modifier_item_imba_bloodthorn_attacker_crit", {duration = 1.0, target_crit_multiplier = self.target_crit_multiplier})
		end
	end
end

-- Track damage taken
function modifier_item_imba_bloodthorn_debuff:OnTakeDamage(keys)
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.unit

		-- If this unit is the one suffering damage, amplify and store it
		if owner == target then
			owner.orchid_damage_storage = owner.orchid_damage_storage + keys.damage
		end
	end
end

-- When the debuff ends, deal damage
function modifier_item_imba_bloodthorn_debuff:OnDestroy()
	if IsServer() then

		-- Parameters
		local owner = self:GetParent()
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local damage_factor = ability:GetSpecialValueFor("silence_damage_percent")

		-- If damage was taken, play the effect and damage the owner
		if owner.orchid_damage_storage > 0 then

			-- Calculate and deal damage
			local damage = owner.orchid_damage_storage * damage_factor * 0.01
			ApplyDamage({attacker = caster, victim = owner, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			-- Fire damage particle
			local orchid_end_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, owner)
			ParticleManager:SetParticleControl(orchid_end_pfx, 0, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(orchid_end_pfx, 1, Vector(100, 0, 0))
			ParticleManager:ReleaseParticleIndex(orchid_end_pfx)
		end

		-- Clear damage taken variable
		self:GetParent().orchid_damage_storage = nil
	end
end

-----------------------------------------------------------------------------------------------------------
--	Bloodthorn active attacker crit buff
-----------------------------------------------------------------------------------------------------------
modifier_item_imba_bloodthorn_attacker_crit = modifier_item_imba_bloodthorn_attacker_crit or class({})
function modifier_item_imba_bloodthorn_attacker_crit:IsHidden() return true end
function modifier_item_imba_bloodthorn_attacker_crit:IsDebuff() return false end
function modifier_item_imba_bloodthorn_attacker_crit:IsPurgable() return false end

-- Track parameters to prevent errors if the item is unequipped
function modifier_item_imba_bloodthorn_attacker_crit:OnCreated(keys)
	if IsServer() then
		self.target_crit_multiplier = keys.target_crit_multiplier
	end
end

-- Declare modifier events/properties
function modifier_item_imba_bloodthorn_attacker_crit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

-- Grant the crit damage multiplier
function modifier_item_imba_bloodthorn_attacker_crit:GetModifierPreAttack_CriticalStrike()
	if IsServer() then
		return self.target_crit_multiplier
	end
end

-- Remove the crit modifier when the attack is concluded
function modifier_item_imba_bloodthorn_attacker_crit:OnAttackLanded(keys)
	if IsServer() then

		-- If this unit is the attacker, remove its crit modifier
		if self:GetParent() == keys.attacker then
			self:GetParent():RemoveModifierByName("modifier_item_imba_bloodthorn_attacker_crit")

			-- Increase the crit damage count
			local debuff_modifier = keys.target:FindModifierByName("modifier_item_imba_bloodthorn_debuff")
			debuff_modifier.target_crit_multiplier = debuff_modifier.target_crit_multiplier + self:GetAbility():GetSpecialValueFor("crit_mult_increase")
		end
	end
end
