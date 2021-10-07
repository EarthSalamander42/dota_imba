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

-- Author: MouJiaoZi
-- Date: 2017/12/02  YYYY/MM/DD
--
-- Revisionist: AltiV
-- Date: 2019/03/13

item_imba_gungnir = item_imba_gungnir or class({})

LinkLuaModifier("modifier_item_imba_gungnir", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_unique", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_ally", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_enemy_ranged", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_enemy_melee", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_self_ranged", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_force_self_melee", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_gungnir_attack_speed", "components/items/item_gungnir", LUA_MODIFIER_MOTION_NONE)

function item_imba_gungnir:GetIntrinsicModifierName()
	-- Client/server way of checking for multiple items and only apply the effects of one without relying on extra modifiers
	
	-- ...Also wtf who puts logic in the GetIntrinsicModifierName function
	Timers:CreateTimer(FrameTime(), function()
		for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_item_imba_gungnir")) do
			modifier:SetStackCount(_)
		end
	end)
	
	return "modifier_item_imba_gungnir"
end

function item_imba_gungnir:OnSpellStart()
	if not IsServer() then return end
	
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local duration = ability:GetSpecialValueFor("duration")
	
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_ally", {duration = duration})
	else
		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end

		if caster:IsRangedAttacker() then
			target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_enemy_ranged", {duration = duration})
			caster:AddNewModifier(target, ability, "modifier_item_imba_gungnir_force_self_ranged", {duration = duration})
		else
			target:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_force_enemy_melee", {duration = duration})
			caster:AddNewModifier(target, ability, "modifier_item_imba_gungnir_force_self_melee", {duration = duration})
		end
		
		local buff = caster:AddNewModifier(caster, ability, "modifier_item_imba_gungnir_attack_speed", {duration = ability:GetSpecialValueFor("range_duration")})
		
		buff.target = target
		buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", caster)
		
		local startAttack = {
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),}
		ExecuteOrderFromTable(startAttack)
	end
end

-------------------------------------
-----  STATE MODIFIER ---------------
-------------------------------------

modifier_item_imba_gungnir = modifier_item_imba_gungnir or class({})

function modifier_item_imba_gungnir:IsHidden()		return true end
function modifier_item_imba_gungnir:IsPurgable()		return false end
function modifier_item_imba_gungnir:RemoveOnDeath()	return false end
function modifier_item_imba_gungnir:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_gungnir:OnCreated()	
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_strength				= self.ability:GetSpecialValueFor("bonus_strength")
	self.bonus_agility				= self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect			= self.ability:GetSpecialValueFor("bonus_intellect")
	self.bonus_health_regen			= self.ability:GetSpecialValueFor("bonus_health_regen")

	self.bonus_damage				= self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed_passive	= self.ability:GetSpecialValueFor("bonus_attack_speed_passive")
	
	self.base_attack_range			= self.ability:GetSpecialValueFor("base_attack_range")
	self.base_attack_range_melee	= self.ability:GetSpecialValueFor("base_attack_range_melee")	
	
	self.bonus_chance				= self.ability:GetSpecialValueFor("bonus_chance")
	self.bonus_chance_damage		= self.ability:GetSpecialValueFor("bonus_chance_damage")
	self.bonus_attack_speed			= self.ability:GetSpecialValueFor("bonus_attack_speed")
	
	-- Tracking when to give the true strike + bonus magical damage
	self.pierce_proc 			= true
	self.pierce_records			= {}
end

function modifier_item_imba_gungnir:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
	return decFuncs
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_gungnir:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_gungnir:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_imba_gungnir:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_gungnir:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed_passive
end

-- MKB related stuff
function modifier_item_imba_gungnir:GetModifierAttackRangeBonus()
	if self:GetStackCount() == 1 then
		if self.parent:IsRangedAttacker() then
			return self.base_attack_range
		else
			return self.base_attack_range_melee
		end
	end
end

-- Gungnir Pierces do not stack
function modifier_item_imba_gungnir:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not IsServer() then return end
	
	for _, record in pairs(self.pierce_records) do	
		if record == keys.record then
			table.remove(self.pierce_records, _)

			if not self.parent:IsIllusion() and self:GetStackCount() == 1 and not keys.target:IsBuilding() then
				-- self.parent:EmitSound("DOTA_Item.MKB.proc")
				return self.bonus_chance_damage
			end
		end
	end
end

function modifier_item_imba_gungnir:OnAttackRecord(keys)
	if keys.attacker == self.parent then
		if self.pierce_proc then
			table.insert(self.pierce_records, keys.record)
			self.pierce_proc = false
		end
	
		if RollPseudoRandom(self.bonus_chance, self) then
			self.pierce_proc = true
		end
	end
end

function modifier_item_imba_gungnir:CheckState()
	local state = {}
	
	if self.pierce_proc then
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end

-------------------------------------
-----  ACTIVE MODIFIER --------------
-------------------------------------

modifier_item_imba_gungnir_force_ally = modifier_item_imba_gungnir_force_ally or class({})

function modifier_item_imba_gungnir_force_ally:IsDebuff() return false end
function modifier_item_imba_gungnir_force_ally:IsHidden() return true end
function modifier_item_imba_gungnir_force_ally:IsPurgable() return false end
function modifier_item_imba_gungnir_force_ally:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_ally:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_ally:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	
	-- This doesn't seem like a proper way to do things but w/e MouJiao's legacy code
	if self:GetParent():HasModifier("modifier_legion_commander_duel") or self:GetParent():HasModifier("modifier_imba_enigma_black_hole") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_handler") then
		self:Destroy()
		return
	end
	
	self.effect = self:GetCaster().force_staff_effect or "particles/items_fx/force_staff.vpcf"
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
	self.attacked_target = {}
	
	self.god_piercing_radius	= self:GetAbility():GetSpecialValueFor("god_piercing_radius")
end

function modifier_item_imba_gungnir_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_ally:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	local attacker = self:GetParent()
	local enemies = FindUnitsInRadius(attacker:GetTeamNumber(),
		attacker:GetAbsOrigin(),
		nil,
		self.god_piercing_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _,enemy in pairs(enemies) do
		if not self.attacked_target[enemy:entindex()] then
			attacker:PerformAttack(enemy, true, true, true, true, true, false, false)
			self.attacked_target[enemy:entindex()] = enemy:entindex()
		end
	end

	ProjectileManager:ProjectileDodge(self:GetParent())
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_ally:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_ally:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
		}
	return state
end

modifier_item_imba_gungnir_force_enemy_ranged = modifier_item_imba_gungnir_force_enemy_ranged or class({})
modifier_item_imba_gungnir_force_self_ranged = modifier_item_imba_gungnir_force_self_ranged or class({})

function modifier_item_imba_gungnir_force_enemy_ranged:IsDebuff() return true end
function modifier_item_imba_gungnir_force_enemy_ranged:IsHidden() return true end
function modifier_item_imba_gungnir_force_enemy_ranged:IsPurgable() return false end
function modifier_item_imba_gungnir_force_enemy_ranged:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_enemy_ranged:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_enemy_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_imba_gungnir_force_enemy_ranged:IgnoreTenacity()  return true end

function modifier_item_imba_gungnir_force_enemy_ranged:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect or "particles/items_fx/force_staff.vpcf"
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_ranged:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_enemy_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_self_ranged:IsDebuff() return false end
function modifier_item_imba_gungnir_force_self_ranged:IsHidden() return true end
function modifier_item_imba_gungnir_force_self_ranged:IsPurgable() return false end
function modifier_item_imba_gungnir_force_self_ranged:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_self_ranged:IgnoreTenacity() return true end
function modifier_item_imba_gungnir_force_self_ranged:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_self_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_self_ranged:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect or "particles/items_fx/force_staff.vpcf"
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_self_ranged:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_self_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_self_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_gungnir_force_enemy_melee = modifier_item_imba_gungnir_force_enemy_melee or class({})
modifier_item_imba_gungnir_force_self_melee = modifier_item_imba_gungnir_force_self_melee or class({})

function modifier_item_imba_gungnir_force_enemy_melee:IsDebuff() return true end
function modifier_item_imba_gungnir_force_enemy_melee:IsHidden() return true end
function modifier_item_imba_gungnir_force_enemy_melee:IsPurgable() return false end
function modifier_item_imba_gungnir_force_enemy_melee:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_enemy_melee:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_enemy_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_imba_gungnir_force_enemy_melee:IgnoreTenacity()  return true end

function modifier_item_imba_gungnir_force_enemy_melee:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect or "particles/items_fx/force_staff.vpcf"
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_melee:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_enemy_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_enemy_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_gungnir_force_self_melee:IsDebuff() return false end
function modifier_item_imba_gungnir_force_self_melee:IsHidden() return true end
function modifier_item_imba_gungnir_force_self_melee:IsPurgable() return false end
function modifier_item_imba_gungnir_force_self_melee:IsStunDebuff() return false end
function modifier_item_imba_gungnir_force_self_melee:IgnoreTenacity() return true end
function modifier_item_imba_gungnir_force_self_melee:IsMotionController()  return true end
function modifier_item_imba_gungnir_force_self_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_gungnir_force_self_melee:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect or "particles/items_fx/force_staff.vpcf"
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_gungnir_force_self_melee:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_gungnir_force_self_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_gungnir_force_self_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_gungnir_attack_speed = modifier_item_imba_gungnir_attack_speed or class({})

function modifier_item_imba_gungnir_attack_speed:IsDebuff() return false end
function modifier_item_imba_gungnir_attack_speed:IsHidden() return false end
function modifier_item_imba_gungnir_attack_speed:IsPurgable() return true end
function modifier_item_imba_gungnir_attack_speed:IsStunDebuff() return false end
function modifier_item_imba_gungnir_attack_speed:IgnoreTenacity() return true end

function modifier_item_imba_gungnir_attack_speed:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	self.as = 0
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_gungnir_attack_speed:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget() == self.target then
		self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
	else
		self.as = 0
		self.ar = 0
	end
end

function modifier_item_imba_gungnir_attack_speed:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
	return decFuncs
end

function modifier_item_imba_gungnir_attack_speed:GetModifierAttackSpeedBonus_Constant()
	if not IsServer() then return end
	return self.as
end

function modifier_item_imba_gungnir_attack_speed:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_item_imba_gungnir_attack_speed:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end

function modifier_item_imba_gungnir_attack_speed:OnOrder( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.unit == self:GetParent() and keys.order_type == 4 then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
		
		self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end
