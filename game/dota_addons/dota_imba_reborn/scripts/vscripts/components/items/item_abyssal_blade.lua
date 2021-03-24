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
-- Date: 29/07/2016

-- Editor: AltiV
-- Date: 22/03/2020, and times before

item_imba_abyssal_blade = item_imba_abyssal_blade or class({})

LinkLuaModifier("modifier_imba_abyssal_blade", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_abyssal_blade_internal_cd", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_abyssal_blade_bash", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_abyssal_blade_skull_crash", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_abyssal_blade_skull_break", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)

function item_imba_abyssal_blade:GetIntrinsicModifierName()
	return "modifier_imba_abyssal_blade"
end

function item_imba_abyssal_blade:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "DOTA_Item.AbyssalBlade.Activate"    
	local particle_abyssal = "particles/items_fx/abyssal_blade.vpcf"
	local modifier_bash = "modifier_imba_abyssal_blade_bash"
	local modifier_break = "modifier_imba_abyssal_blade_skull_break"

	-- Ability specials
	local active_stun_duration = ability:GetSpecialValueFor("active_stun_duration")
	local actual_break_duration = ability:GetSpecialValueFor("actual_break_duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, target)
	
	-- If the target possesses a ready Linken's Sphere, do nothing
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	if self:GetCaster():HasModifier("modifier_imba_slark_pounce") then
		self:GetCaster():FindModifierByName("modifier_imba_slark_pounce"):Destroy()
	end
	
	-- This isn't the right particle but I don't want to spend forever looking for this when there are a million other changes to work on
	local blink_start_particle = ParticleManager:CreateParticle("particles/econ/events/ti9/blink_dagger_ti9_start_lvl2.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(blink_start_particle)
	
	FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin() - self:GetCaster():GetForwardVector() * 56, false)
	
	local blink_end_particle = ParticleManager:CreateParticle("particles/econ/events/ti9/blink_dagger_ti9_lvl2_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(blink_end_particle)

	-- Add particle effect
	local particle_abyssal_fx = ParticleManager:CreateParticle(particle_abyssal, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_abyssal_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_abyssal_fx)

	-- Apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("bash_damage"),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self
	}

	ApplyDamage(damageTable)

	if target:IsAlive() then
		-- Stun and break the target for the duration
		target:AddNewModifier(caster, ability, modifier_bash, {duration = active_stun_duration * (1 - target:GetStatusResistance())})
		target:AddNewModifier(caster, ability, modifier_break, {duration = actual_break_duration * (1 - target:GetStatusResistance())})
	end
end


-- Modifier (stackable, grants stats bonuses)
modifier_imba_abyssal_blade = modifier_imba_abyssal_blade or class({})

function modifier_imba_abyssal_blade:IsHidden()			return true end
function modifier_imba_abyssal_blade:IsPurgable()		return false end
function modifier_imba_abyssal_blade:RemoveOnDeath()	return false end
function modifier_imba_abyssal_blade:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_abyssal_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_imba_abyssal_blade:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_imba_abyssal_blade:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage")
	end
end

function modifier_imba_abyssal_blade:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_imba_abyssal_blade:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
	end
end

function modifier_imba_abyssal_blade:GetModifierPhysical_ConstantBlock()
	if self:GetAbility() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("block_chance"), self) then
		if not self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("block_damage_melee")
		else
			return self:GetAbility():GetSpecialValueFor("block_damage_ranged")
		end
	end
end


function modifier_imba_abyssal_blade:OnAttack(keys)
	if self:GetAbility() and
	keys.attacker == self:GetParent() and
	keys.attacker:FindAllModifiersByName(self:GetName())[1] == self and
	self:GetAbility():IsCooldownReady() and
	not keys.attacker:IsIllusion() and
	not keys.target:IsBuilding() and
	not keys.target:IsOther() and
	not keys.attacker:HasModifier("modifier_monkey_king_fur_army_soldier") and
	not keys.attacker:HasModifier("modifier_monkey_king_fur_army_soldier_hidden") and
	not keys.attacker:HasModifier("modifier_imba_abyssal_blade_internal_cd") then
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

function modifier_imba_abyssal_blade:OnAttackLanded(keys)
	if self:GetAbility() and keys.attacker == self:GetParent() and self.bash_proc then
		self.bash_proc = false

		-- Make the ability go into an internal cooldown
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_abyssal_blade_internal_cd", {duration = self:GetAbility():GetSpecialValueFor("internal_bash_cd")})

		-- If the attacker is one of the forbidden heroes, do not proc the bash
		if IMBA_DISABLED_SKULL_BASHER == nil or not IMBA_DISABLED_SKULL_BASHER[keys.attacker:GetUnitName()] then
			keys.target:EmitSound("DOTA_Item.SkullBasher")
			
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_abyssal_blade_bash", {duration = self:GetAbility():GetSpecialValueFor("stun_duration") * (1 - keys.target:GetStatusResistance())})
		end

		-- IMBAfication: Skull Crash
		-- If the target is not skull crashed yet, CRUSH IT!
		if not keys.target:HasModifier("modifier_imba_abyssal_blade_skull_crash") then
			if RollPercentage(self:GetAbility():GetSpecialValueFor("insta_skull_break_chance_pct")) then
				keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_abyssal_blade_skull_break", {duration = self:GetAbility():GetSpecialValueFor("actual_break_duration") * (1 - keys.target:GetStatusResistance())})
			else
				keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_abyssal_blade_skull_crash", {duration = self:GetAbility():GetSpecialValueFor("skull_break_duration") * (1 - keys.target:GetStatusResistance())})
			end
		else
			-- Otherwise, it was ALREADY CRUSHED! BREAK IT!!!!!!!!!!!! BREAK IT!!!!!!!!!!!!!!!
			-- Consume skull crash modifier
			keys.target:RemoveModifierByName("modifier_imba_abyssal_blade_skull_crash")

			-- Apply BREAK!
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_abyssal_blade_skull_break", {duration = self:GetAbility():GetSpecialValueFor("actual_break_duration") * (1 - keys.target:GetStatusResistance())})
		end
	end
end

-- Bash modifier
modifier_imba_abyssal_blade_bash = modifier_imba_abyssal_blade_bash or class({})

function modifier_imba_abyssal_blade_bash:IsHidden() return false end
function modifier_imba_abyssal_blade_bash:IsPurgeException() return true end
function modifier_imba_abyssal_blade_bash:IsStunDebuff() return true end

function modifier_imba_abyssal_blade_bash:CheckState()
   return {[MODIFIER_STATE_STUNNED] = true} 
end

function modifier_imba_abyssal_blade_bash:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_abyssal_blade_bash:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_abyssal_blade_bash:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_imba_abyssal_blade_bash:GetOverrideAnimation()
	return ACT_DOTA_DISABLED 
end

-- Modifier responsible for showing that the skull has been broken - Next attack will break it for real!
modifier_imba_abyssal_blade_skull_crash = modifier_imba_abyssal_blade_skull_crash or class({})

function modifier_imba_abyssal_blade_skull_crash:IsHidden() return false end
function modifier_imba_abyssal_blade_skull_crash:IsPurgable() return true end
function modifier_imba_abyssal_blade_skull_crash:IsDebuff() return true end


-- Modifier responsible for showing BROKEN SKULLS MUHAHHAHA TARGET IS BROKEN PITY IT!
modifier_imba_abyssal_blade_skull_break = modifier_imba_abyssal_blade_skull_break or class({})

function modifier_imba_abyssal_blade_skull_break:IsHidden() return false end
function modifier_imba_abyssal_blade_skull_break:IsPurgable() return true end
function modifier_imba_abyssal_blade_skull_break:IsDebuff() return true end

function modifier_imba_abyssal_blade_skull_break:CheckState()
	return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

function modifier_imba_abyssal_blade_skull_break:OnCreated()
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



-- Modifier responsible for being an internal CD
modifier_imba_abyssal_blade_internal_cd = modifier_imba_abyssal_blade_internal_cd or class({})

function modifier_imba_abyssal_blade_internal_cd:IgnoreTenacity()	return true end
function modifier_imba_abyssal_blade_internal_cd:IsPurgable() 		return false end
function modifier_imba_abyssal_blade_internal_cd:IsDebuff() 		return true end
function modifier_imba_abyssal_blade_internal_cd:RemoveOnDeath()	return false end
