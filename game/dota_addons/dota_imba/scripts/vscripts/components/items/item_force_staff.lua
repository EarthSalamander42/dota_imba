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

---------------------------------------------
--		item_imba_force_staff
---------------------------------------------
item_imba_force_staff = item_imba_force_staff or class({})
LinkLuaModifier("modifier_item_imba_force_staff", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_force_staff_active", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)

function item_imba_force_staff:GetIntrinsicModifierName()
	return "modifier_item_imba_force_staff"
end

function item_imba_force_staff:CastFilterResultTarget(target)
	if IsServer() then
		if self:GetCaster():GetTeam() == target:GetTeam() and self:GetCaster() ~= target and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ALLY
		elseif self:GetCaster():GetTeam() ~= target:GetTeam() and target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
	end
end

function item_imba_force_staff:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local target = self:GetCursorTarget()

	EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
	target:AddNewModifier(self:GetCaster(), ability, "modifier_item_imba_force_staff_active", {duration = ability:GetSpecialValueFor("duration")})
end

function item_imba_force_staff:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().force_staff_icon_client then return "custom/imba_force_staff" end

	return "custom/imba_force_staff"..self:GetCaster().force_staff_icon_client
end

-------------------------------------
--------- STATE MODIFIER ------------
-------------------------------------

modifier_item_imba_force_staff = modifier_item_imba_force_staff or class({})

function modifier_item_imba_force_staff:IsHidden() return true end
function modifier_item_imba_force_staff:IsPurgable() return false end
function modifier_item_imba_force_staff:IsDebuff() return false end
function modifier_item_imba_force_staff:RemoveOnDeath() return false end
function modifier_item_imba_force_staff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_force_staff:OnCreated()
	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_item_imba_force_staff:OnIntervalThink()
	if self:GetCaster():IsIllusion() then return end

	if IsServer() then
		self:SetStackCount(self:GetCaster().force_staff_icon)
	end

	if IsClient() then
		local icon = self:GetStackCount()
		if icon == 0 then
			self:GetCaster().force_staff_icon_client = nil
		else
			self:GetCaster().force_staff_icon_client = icon
		end
	end
end

function modifier_item_imba_force_staff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return decFuncs
end

function modifier_item_imba_force_staff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_item_imba_force_staff:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

---------------------------------------
--------  ACTIVE BUFF -----------------
---------------------------------------

modifier_item_imba_force_staff_active = modifier_item_imba_force_staff_active or class({})

function modifier_item_imba_force_staff_active:IsDebuff() return false end
function modifier_item_imba_force_staff_active:IsHidden() return true end
function modifier_item_imba_force_staff_active:IsPurgable() return false end
function modifier_item_imba_force_staff_active:IsStunDebuff() return false end
function modifier_item_imba_force_staff_active:IsMotionController()  return true end
function modifier_item_imba_force_staff_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_force_staff_active:OnCreated()
	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect
	if self:GetParent():HasModifier("modifier_legion_commander_duel") or self:GetParent():HasModifier("modifier_imba_enigma_black_hole") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_handler") then
		self:Destroy()
		return
	end
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_force_staff_active:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_force_staff_active:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_force_staff_active:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

---------------------------------------------
--		item_imba_hurricane_pike
---------------------------------------------
item_imba_hurricane_pike = item_imba_hurricane_pike or class({})

LinkLuaModifier("modifier_item_imba_hurricane_pike", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hurricane_pike_unique", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hurricane_pike_force_ally", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hurricane_pike_force_enemy", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hurricane_pike_force_self", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hurricane_pike_attack_speed", "components/items/item_force_staff", LUA_MODIFIER_MOTION_NONE)

function item_imba_hurricane_pike:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().force_staff_icon_client then return "custom/imba_hurricane_pike" end
	return "custom/imba_hurricane_pike"..self:GetCaster().force_staff_icon_client
end

function item_imba_hurricane_pike:GetIntrinsicModifierName()
	return "modifier_item_imba_hurricane_pike"
end

function item_imba_hurricane_pike:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local target = self:GetCursorTarget()
	local duration = 0.4

	if self:GetCaster():GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(self:GetCaster(), ability, "modifier_item_imba_hurricane_pike_force_ally", {duration = duration })
	else
		target:AddNewModifier(self:GetCaster(), ability, "modifier_item_imba_hurricane_pike_force_enemy", {duration = duration})
		self:GetCaster():AddNewModifier(target, ability, "modifier_item_imba_hurricane_pike_force_self", {duration = duration})
		local buff = self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_item_imba_hurricane_pike_attack_speed", {duration = ability:GetSpecialValueFor("range_duration")})
		buff.target = target
		buff:SetStackCount(ability:GetSpecialValueFor("max_attacks"))
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", self:GetCaster())
		local startAttack = {
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),}
		ExecuteOrderFromTable(startAttack)
	end
end

modifier_item_imba_hurricane_pike = modifier_item_imba_hurricane_pike or class({})

function modifier_item_imba_hurricane_pike:IsHidden() return true end
function modifier_item_imba_hurricane_pike:IsPurgable() return false end
function modifier_item_imba_hurricane_pike:IsDebuff() return false end
function modifier_item_imba_hurricane_pike:RemoveOnDeath() return false end
function modifier_item_imba_hurricane_pike:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_hurricane_pike:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_hurricane_pike_unique") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_hurricane_pike_unique", {})
		end
	end

	self:StartIntervalThink(1.0)
end

function modifier_item_imba_hurricane_pike:OnIntervalThink()
	if self:GetCaster():IsIllusion() then return end

	if IsServer() then
		self:SetStackCount(self:GetCaster().force_staff_icon)
	end

	if IsClient() then
		local icon = self:GetStackCount()
		if icon == 0 then
			self:GetCaster().force_staff_icon_client = nil
		else
			self:GetCaster().force_staff_icon_client = icon
		end
	end
end

function modifier_item_imba_hurricane_pike:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_hurricane_pike") then
			parent:RemoveModifierByName("modifier_item_imba_hurricane_pike_unique")
		end
	end
end

function modifier_item_imba_hurricane_pike:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return decFuncs
end

function modifier_item_imba_hurricane_pike:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_item_imba_hurricane_pike:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_imba_hurricane_pike:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_imba_hurricane_pike:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

modifier_item_imba_hurricane_pike_unique = modifier_item_imba_hurricane_pike_unique or class({})

function modifier_item_imba_hurricane_pike_unique:IsHidden() return true end
function modifier_item_imba_hurricane_pike_unique:IsPurgable() return false end
function modifier_item_imba_hurricane_pike_unique:IsDebuff() return false end
function modifier_item_imba_hurricane_pike_unique:RemoveOnDeath() return false end

function modifier_item_imba_hurricane_pike_unique:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
	return decFuncs
end

function modifier_item_imba_hurricane_pike_unique:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("base_attack_range")
	end
end


modifier_item_imba_hurricane_pike_force_ally = modifier_item_imba_hurricane_pike_force_ally or class({})

function modifier_item_imba_hurricane_pike_force_ally:IsDebuff() return false end
function modifier_item_imba_hurricane_pike_force_ally:IsHidden() return true end
function modifier_item_imba_hurricane_pike_force_ally:IsPurgable() return false end
function modifier_item_imba_hurricane_pike_force_ally:IsStunDebuff() return false end
function modifier_item_imba_hurricane_pike_force_ally:IsMotionController()  return true end
function modifier_item_imba_hurricane_pike_force_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_hurricane_pike_force_ally:OnCreated()
	if not IsServer() then return end
	if self:GetParent():HasModifier("modifier_legion_commander_duel") or self:GetParent():HasModifier("modifier_imba_enigma_black_hole") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_handler") then
		self:Destroy()
		return
	end
	self.effect = self:GetCaster().force_staff_effect
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_hurricane_pike_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_hurricane_pike_force_ally:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_hurricane_pike_force_ally:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_hurricane_pike_force_enemy = modifier_item_imba_hurricane_pike_force_enemy or class({})
modifier_item_imba_hurricane_pike_force_self = modifier_item_imba_hurricane_pike_force_self or class({})

function modifier_item_imba_hurricane_pike_force_enemy:IsDebuff() return true end
function modifier_item_imba_hurricane_pike_force_enemy:IsHidden() return true end
function modifier_item_imba_hurricane_pike_force_enemy:IsPurgable() return false end
function modifier_item_imba_hurricane_pike_force_enemy:IsStunDebuff() return false end
function modifier_item_imba_hurricane_pike_force_enemy:IsMotionController()  return true end
function modifier_item_imba_hurricane_pike_force_enemy:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_hurricane_pike_force_enemy:OnCreated()
	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_hurricane_pike_force_enemy:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_hurricane_pike_force_enemy:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_hurricane_pike_force_enemy:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_hurricane_pike_force_self:IsDebuff() return false end
function modifier_item_imba_hurricane_pike_force_self:IsHidden() return true end
function modifier_item_imba_hurricane_pike_force_self:IsPurgable() return false end
function modifier_item_imba_hurricane_pike_force_self:IsStunDebuff() return false end
function modifier_item_imba_hurricane_pike_force_self:IgnoreTenacity() return true end
function modifier_item_imba_hurricane_pike_force_self:IsMotionController()  return true end
function modifier_item_imba_hurricane_pike_force_self:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_hurricane_pike_force_self:OnCreated()
	if not IsServer() then return end
	self.effect = self:GetCaster().force_staff_effect
	self.pfx = ParticleManager:CreateParticle(self.effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_length") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_hurricane_pike_force_self:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_hurricane_pike_force_self:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_hurricane_pike_force_self:HorizontalMotion(unit, time)
	if not IsServer() then return end
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_hurricane_pike_attack_speed = modifier_item_imba_hurricane_pike_attack_speed or class({})

function modifier_item_imba_hurricane_pike_attack_speed:IsDebuff() return false end
function modifier_item_imba_hurricane_pike_attack_speed:IsHidden() return false end
function modifier_item_imba_hurricane_pike_attack_speed:IsPurgable() return true end
function modifier_item_imba_hurricane_pike_attack_speed:IsStunDebuff() return false end
function modifier_item_imba_hurricane_pike_attack_speed:IgnoreTenacity() return true end

function modifier_item_imba_hurricane_pike_attack_speed:OnCreated()
	if not IsServer() then return end
	self.as = 0
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_hurricane_pike_attack_speed:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():GetAttackTarget() == self.target then
		self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
	else
		self.as = 0
		if self:GetParent():IsRangedAttacker() then
			self.ar = 0
		end
	end
end

function modifier_item_imba_hurricane_pike_attack_speed:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
	return decFuncs
end

function modifier_item_imba_hurricane_pike_attack_speed:GetModifierAttackSpeedBonus_Constant()
	if not IsServer() then return end
	return self.as
end

function modifier_item_imba_hurricane_pike_attack_speed:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_item_imba_hurricane_pike_attack_speed:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end

function modifier_item_imba_hurricane_pike_attack_speed:OnOrder( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.unit == self:GetParent() and keys.ordertype == 4 then
		self.ar = 999999
	end
end
