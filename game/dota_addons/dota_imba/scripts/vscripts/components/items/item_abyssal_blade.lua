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

item_imba_abyssal_blade = item_imba_abyssal_blade or class({})

LinkLuaModifier("modifier_imba_abyssal_blade", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_abyssal_blade_unique", "components/items/item_abyssal_blade", LUA_MODIFIER_MOTION_NONE)
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

	-- Add particle effect
	local particle_abyssal_fx = ParticleManager:CreateParticle(particle_abyssal, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_abyssal_fx, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_abyssal_fx)

	-- Stun and break the target for the duration
	target:AddNewModifier(caster, ability, modifier_bash, {duration = active_stun_duration})
	target:AddNewModifier(caster, ability, modifier_break, {duration = actual_break_duration})
end


-- Modifier (stackable, grants stats bonuses)
modifier_imba_abyssal_blade = modifier_imba_abyssal_blade or class({})

function modifier_imba_abyssal_blade:IsHidden() return true end
function modifier_imba_abyssal_blade:IsPurgable() return false end
function modifier_imba_abyssal_blade:IsDebuff() return false end
function modifier_imba_abyssal_blade:IsPermanent() return true end
function modifier_imba_abyssal_blade:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end 

function modifier_imba_abyssal_blade:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_self = "modifier_imba_abyssal_blade"
	self.modifier_unique = "modifier_imba_abyssal_blade_unique"

	-- Ability specials
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self.ability:GetSpecialValueFor("bonus_strength")   
	self.bonus_hp_regen = self.ability:GetSpecialValueFor("bonus_hp_regen") 
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.damage_block = self.ability:GetSpecialValueFor("damage_block")

	if IsServer() then
		-- Grant the unique modifier for bashing
		if not self.caster:HasModifier(self.modifier_unique) then
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_unique, {})
		end
	end
end

function modifier_imba_abyssal_blade:OnDestroy()
	if IsServer() then
		-- If there are no more skull bashers in inventory, remove the skull basher unique modifier altogether
		if not self.caster:HasModifier(self.modifier_self) then
			self.caster:RemoveModifierByName(self.modifier_unique)
		end
	end
end

function modifier_imba_abyssal_blade:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					  MODIFIER_PROPERTY_HEALTH_BONUS,
					  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}

	return decFuncs
end

function modifier_imba_abyssal_blade:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_abyssal_blade:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_abyssal_blade:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_imba_abyssal_blade:GetModifierConstantHealthRegen()
	return self.bonus_hp_regen
end

function modifier_imba_abyssal_blade:GetCustomDamageBlockUnique()
	return self.damage_block
end



-- Unique modifier responsible for bashing the target
modifier_imba_abyssal_blade_unique = modifier_imba_abyssal_blade_unique or class({})

function modifier_imba_abyssal_blade_unique:IsHidden() return true end
function modifier_imba_abyssal_blade_unique:IsPurgable() return false end
function modifier_imba_abyssal_blade_unique:IsDebuff() return false end
function modifier_imba_abyssal_blade_unique:IsPermanent() return true end

function modifier_imba_abyssal_blade_unique:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_bash = "modifier_imba_abyssal_blade_bash"
	self.modifier_skull_crash = "modifier_imba_abyssal_blade_skull_crash"
	self.modifier_skull_break = "modifier_imba_abyssal_blade_skull_break"
	self.modifier_internal_cd = "modifier_imba_abyssal_blade_internal_cd"

	-- Ability specials
	self.bonus_range_melee = self.ability:GetSpecialValueFor("bonus_range_melee")
	self.bash_chance_melee = self.ability:GetSpecialValueFor("bash_chance_melee")
	self.bash_chance_ranged = self.ability:GetSpecialValueFor("bash_chance_ranged")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
	self.bash_damage = self.ability:GetSpecialValueFor("bash_damage")
	self.skull_break_duration = self.ability:GetSpecialValueFor("skull_break_duration")
	self.internal_bash_cd = self.ability:GetSpecialValueFor("internal_bash_cd")
	self.insta_skull_break_chance_pct = self.ability:GetSpecialValueFor("insta_skull_break_chance_pct")
	self.actual_break_duration = self.ability:GetSpecialValueFor("actual_break_duration")
end

function modifier_imba_abyssal_blade_unique:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED,
					  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
					  MODIFIER_EVENT_ON_ATTACK,
					  MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL}

	return decFuncs
end

function modifier_imba_abyssal_blade_unique:GetModifierAttackRangeBonus()
	if not self.caster:IsRangedAttacker() then
		return self.bonus_range_melee
	end
end

function modifier_imba_abyssal_blade_unique:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply if the attacker is the caster
		if attacker == self.caster then

			-- Check if this is a ranged or melee attacker
			local chance
			if self.caster:IsRangedAttacker() then
				chance = self.bash_chance_ranged
			else
				chance = self.bash_chance_melee
			end

			-- If the attacker is an illusion, do nothing
			if self.caster:IsIllusion() then
				return nil
			end

			-- If the target is a building, do nothing
			if target:IsBuilding() then
				return nil                
			end

			if attacker:GetTeamNumber() == target:GetTeamNumber() then
				return nil
			end

			-- If the Abyssal Blade is on cooldown (internal), do nothing
			if self.caster:HasModifier(self.modifier_internal_cd) then                
				return nil
			end

			-- Roll for a bash!
			if RollPseudoRandom(chance, self) then                
				self.bash_proc = true
			end
		end
	end
end

function modifier_imba_abyssal_blade_unique:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If the attacker is one of the forbidden heroes, do nothing
		for _, restricted_hero in pairs(IMBA_DISABLED_SKULL_BASHER) do
			if restricted_hero == attacker:GetUnitName() then
				return nil
			end
		end

		-- Only apply if the caster is the attacker
		if attacker == self.caster then
			if self.bash_proc then
				-- Bash bash bash
				target:AddNewModifier(self.caster, self.ability, self.modifier_bash, {duration = self.stun_duration})

				-- Make the ability go into an internal cooldown
				self.caster:AddNewModifier(self.caster, self.ability, self.modifier_internal_cd, {duration = self.internal_bash_cd})

				-- If the target is not skull crashed yet, try to immediately CRUSH IT!
				if not target:HasModifier(self.modifier_skull_crash) then
					if RollPseudoRandom(self.insta_skull_break_chance_pct, self) then
						target:AddNewModifier(self.caster, self.ability, self.modifier_skull_break, {duration = self.actual_break_duration})  
					else
						target:AddNewModifier(self.caster, self.ability, self.modifier_skull_crash, {duration = self.skull_break_duration})
					end
				else
					-- Otherwise, it was ALREADY CRUSHED! BREAK IT!!!!!!!!!!!! BREAK IT!!!!!!!!!!!!!!!
					-- Consume skull crash modifier
					target:RemoveModifierByName(self.modifier_skull_crash)

					-- Apply BREAK!
					target:AddNewModifier(self.caster, self.ability, self.modifier_skull_break, {duration = self.actual_break_duration})
				end
			end            

			self.bash_proc = false
		end
	end
end

function modifier_imba_abyssal_blade_unique:GetModifierProcAttack_BonusDamage_Magical()
	if self.bash_proc then
		return self.bash_damage
	end

	return nil
end


-- Bash modifier
modifier_imba_abyssal_blade_bash = modifier_imba_abyssal_blade_bash or class({})

function modifier_imba_abyssal_blade_bash:IsHidden() return false end
function modifier_imba_abyssal_blade_bash:IsPurgeException() return true end
function modifier_imba_abyssal_blade_bash:IsStunDebuff() return true end

function modifier_imba_abyssal_blade_bash:CheckState()
   local state = {[MODIFIER_STATE_STUNNED] = true} 

   return state 
end

function modifier_imba_abyssal_blade_bash:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_abyssal_blade_bash:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_abyssal_blade_bash:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return decFuncs
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
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true}

	return state
end

function modifier_imba_abyssal_blade_skull_break:OnCreated()
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

function modifier_imba_abyssal_blade_internal_cd:IsHidden() return true end
function modifier_imba_abyssal_blade_internal_cd:IsPurgable() return false end
function modifier_imba_abyssal_blade_internal_cd:IsDebuff() return false end
