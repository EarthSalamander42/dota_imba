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
-- Date: 28/07/2016

-- Editor: AltiV
-- Date: 22/03/2020, and times before

item_imba_skull_basher = item_imba_skull_basher or class({})

LinkLuaModifier("modifier_imba_skull_basher", "components/items/item_skull_basher", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skull_basher_bash", "components/items/item_skull_basher", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skull_basher_skull_crash", "components/items/item_skull_basher", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skull_basher_skull_break", "components/items/item_skull_basher", LUA_MODIFIER_MOTION_NONE)

function item_imba_skull_basher:GetIntrinsicModifierName()
	return "modifier_imba_skull_basher"
end


-- Modifier (stackable, grants stats bonuses)
modifier_imba_skull_basher = modifier_imba_skull_basher or class({})

function modifier_imba_skull_basher:IsHidden() return true end
function modifier_imba_skull_basher:IsPurgable() return false end
function modifier_imba_skull_basher:RemoveOnDeath() return false end
function modifier_imba_skull_basher:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_skull_basher:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_imba_skull_basher:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_imba_skull_basher:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_imba_skull_basher:OnAttack(keys)
	if self:GetAbility() and
	keys.attacker == self:GetParent() and
	keys.attacker:FindAllModifiersByName(self:GetName())[1] == self and
	self:GetAbility():IsCooldownReady() and
	not keys.attacker:IsIllusion() and
	not keys.target:IsBuilding() and
	not keys.target:IsOther() and
	not keys.attacker:HasModifier("modifier_monkey_king_fur_army_soldier") and
	not keys.attacker:HasModifier("modifier_monkey_king_fur_army_soldier_hidden") and
	not keys.attacker:HasItemInInventory("item_imba_abyssal_blade") then
		if self:GetParent():IsRangedAttacker() then
			if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("bash_chance_ranged"), self) then
				self.bash_proc = true
			end
		else
			if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("bash_chance_melee"), self) then
				self.bash_proc = true
			end
		end
	end
end

function modifier_imba_skull_basher:OnAttackLanded(keys)
	if self:GetAbility() and keys.attacker == self:GetParent() and self.bash_proc then
		self.bash_proc = false
		-- Make the ability go into cooldown
		self:GetAbility():UseResources(false, false, false, true)
		
		-- If the attacker is one of the forbidden heroes, do not proc the bash
		if IMBA_DISABLED_SKULL_BASHER == nil or not IMBA_DISABLED_SKULL_BASHER[keys.attacker:GetUnitName()] then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_skull_basher_bash", {duration = self:GetAbility():GetSpecialValueFor("stun_duration") * (1 - keys.target:GetStatusResistance())})
		end
		
		-- IMBAfication: Skull Crash
		-- If the target is not skull crashed yet, CRUSH IT!
		if not keys.target:HasModifier("modifier_imba_skull_basher_skull_crash") then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_skull_basher_skull_crash", {duration = self:GetAbility():GetSpecialValueFor("skull_break_duration") * (1 - keys.target:GetStatusResistance())})
		else
			-- Otherwise, it was ALREADY CRUSHED! BREAK IT!!!!!!!!!!!! BREAK IT!!!!!!!!!!!!!!!
			-- Consume skull crash modifier
			keys.target:RemoveModifierByName("modifier_imba_skull_basher_skull_crash")

			-- Apply BREAK!
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_skull_basher_skull_break", {duration = self:GetAbility():GetSpecialValueFor("actual_break_duration") * (1 - keys.target:GetStatusResistance())})
		end
	end
end

function modifier_imba_skull_basher:GetModifierProcAttack_BonusDamage_Magical()
	if self:GetAbility() and self.bash_proc then
		return self:GetAbility():GetSpecialValueFor("bash_damage")
	end
end

-- Bash modifier
modifier_imba_skull_basher_bash = modifier_imba_skull_basher_bash or class({})

function modifier_imba_skull_basher_bash:IsHidden() return false end
function modifier_imba_skull_basher_bash:IsPurgeException() return true end
function modifier_imba_skull_basher_bash:IsStunDebuff() return true end

function modifier_imba_skull_basher_bash:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_imba_skull_basher_bash:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_skull_basher_bash:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_skull_basher_bash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_imba_skull_basher_bash:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end



-- Modifier responsible for showing that the skull has been broken - Next attack will break it for real!
modifier_imba_skull_basher_skull_crash = modifier_imba_skull_basher_skull_crash or class({})

function modifier_imba_skull_basher_skull_crash:IsHidden() return false end
function modifier_imba_skull_basher_skull_crash:IsPurgable() return true end
function modifier_imba_skull_basher_skull_crash:IsDebuff() return true end


-- Modifier responsible for showing BROKEN SKULLS MUHAHHAHA TARGET IS BROKEN PITY IT!
modifier_imba_skull_basher_skull_break = modifier_imba_skull_basher_skull_break or class({})

function modifier_imba_skull_basher_skull_break:IsHidden() return false end
function modifier_imba_skull_basher_skull_break:IsPurgable() return true end
function modifier_imba_skull_basher_skull_break:IsDebuff() return true end

function modifier_imba_skull_basher_skull_break:CheckState()
	return {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
end

function modifier_imba_skull_basher_skull_break:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local particle_break = "particles/item/skull_basher/skull_basher.vpcf"

		local particle_break_fx = ParticleManager:CreateParticle(particle_break, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle_break_fx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_break_fx)
	end
end
