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
-- Editors: (Gungnir file)
--
-- Author: MouJiaoZi
-- Date: 2017/12/02  YYYY/MM/DD
--
-- Revisionist: AltiV
-- Date: 2019/03/13

-- Most of the logic from Gungnir was brought here but this item has marked differences

item_imba_lance_of_longinus = item_imba_lance_of_longinus or class({})

LinkLuaModifier("modifier_item_imba_lance_of_longinus", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_unique", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_force_ally", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_force_enemy_ranged", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_force_enemy_melee", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_force_self_ranged", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_force_self_melee", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_attack_speed", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_item_imba_lance_of_longinus_god_piercing_ally", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_god_piercing_enemy", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_lance_of_longinus_divergent_thrust", "components/items/item_lance_of_longinus", LUA_MODIFIER_MOTION_NONE)

function item_imba_lance_of_longinus:GetIntrinsicModifierName()
	return "modifier_item_imba_lance_of_longinus"
end

function item_imba_lance_of_longinus:CastFilterResultTarget(target)
	if self:GetCaster() == target or target:HasModifier("modifier_imba_gyrocopter_homing_missile") then
		return UF_SUCCESS
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_CUSTOM, DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES, self:GetCaster():GetTeamNumber())
	end
end

function item_imba_lance_of_longinus:OnSpellStart()
	if not IsServer() then return end
	
	local ability = self
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local duration = ability:GetSpecialValueFor("duration")
	
	if caster:GetTeamNumber() == target:GetTeamNumber() then
		EmitSoundOn("DOTA_Item.ForceStaff.Activate", target)
		target:AddNewModifier(caster, ability, "modifier_item_imba_lance_of_longinus_force_ally", {duration = duration})
	else
		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end

		if caster:IsRangedAttacker() then
			target:AddNewModifier(caster, ability, "modifier_item_imba_lance_of_longinus_force_enemy_ranged", {duration = duration})
			caster:AddNewModifier(target, ability, "modifier_item_imba_lance_of_longinus_force_self_ranged", {duration = duration})
		else
			target:AddNewModifier(caster, ability, "modifier_item_imba_lance_of_longinus_force_enemy_melee", {duration = duration})
			caster:AddNewModifier(target, ability, "modifier_item_imba_lance_of_longinus_force_self_melee", {duration = duration})
		end
	
		-- Attempting to fix Lotus Orb crashes with the purchase time check
		if self:GetPurchaseTime() ~= -1 then
			local god_piercing_modifier = caster:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_lance_of_longinus_god_piercing_ally", {duration = self:GetSpecialValueFor("god_piercing_duration")})
			
			if god_piercing_modifier then
				god_piercing_modifier.enemy = target

				target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_lance_of_longinus_god_piercing_enemy", {duration = self:GetSpecialValueFor("god_piercing_duration")})

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_spiritlink_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
			end
		end
		
		local buff = caster:AddNewModifier(caster, ability, "modifier_item_imba_lance_of_longinus_attack_speed", {duration = ability:GetSpecialValueFor("range_duration")})
		
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

modifier_item_imba_lance_of_longinus = modifier_item_imba_lance_of_longinus or class({})

function modifier_item_imba_lance_of_longinus:IsHidden() return true end
function modifier_item_imba_lance_of_longinus:IsPermanent() return true end
function modifier_item_imba_lance_of_longinus:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_lance_of_longinus:OnCreated()
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
	
	self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana					= self.ability:GetSpecialValueFor("bonus_mana")
	self.magic_resist				= self.ability:GetSpecialValueFor("magic_resist")	
	self.heal_increase				= self.ability:GetSpecialValueFor("heal_increase")	
	
	-- Tracking when to give the true strike + bonus magical damage
	self.pierce_proc 			= true
	self.pierce_records			= {}
	
	if not IsServer() then return end
	
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_lance_of_longinus:OnDestroy()
    if not IsServer() then return end
    
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_lance_of_longinus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_item_imba_lance_of_longinus:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_lance_of_longinus:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_lance_of_longinus:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_lance_of_longinus:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_imba_lance_of_longinus:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_lance_of_longinus:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_lance_of_longinus:GetModifierAttackRangeBonus()
	if self:GetAbility():GetSecondaryCharges() == 1 then
		if self.parent:IsRangedAttacker() then
			return self.base_attack_range
		else
			return self.base_attack_range_melee
		end
	end
end

-------------------------------------
-----  ACTIVE MODIFIER --------------
-------------------------------------

modifier_item_imba_lance_of_longinus_force_ally = modifier_item_imba_lance_of_longinus_force_ally or class({})

function modifier_item_imba_lance_of_longinus_force_ally:IsDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_ally:IsHidden() return true end
function modifier_item_imba_lance_of_longinus_force_ally:IsPurgable() return false end
function modifier_item_imba_lance_of_longinus_force_ally:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_ally:IsMotionController()  return true end
function modifier_item_imba_lance_of_longinus_force_ally:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_lance_of_longinus_force_ally:OnCreated()
	if not IsServer() then return end
	
	-- This doesn't seem like a proper way to do things but w/e MouJiao's legacy code
	if self:GetParent():HasModifier("modifier_legion_commander_duel") or self:GetParent():HasModifier("modifier_imba_enigma_black_hole") or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_handler") then
		self:Destroy()
		return
	end
	
	local particle_name = "particles/items_fx/force_staff.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"] then
		particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"]
	end	
	
	self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = self:GetParent():GetForwardVector():Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("push_length") / ( self:GetDuration() / FrameTime())
	self.attacked_target = {}
	
	self.god_piercing_radius	= self:GetAbility():GetSpecialValueFor("god_piercing_radius")
	self.average_attack_damage	= self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self:GetAbility():GetSpecialValueFor("god_piercing_pure_pct") * 0.01
end

function modifier_item_imba_lance_of_longinus_force_ally:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_lance_of_longinus_force_ally:OnIntervalThink()
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
			attacker:PerformAttack(enemy, true, true, true, true, true, false, true)
			self.attacked_target[enemy:entindex()] = enemy:entindex()
			
			if enemy:IsRealHero() then
				local god_piercing_modifier = attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_lance_of_longinus_god_piercing_ally", {duration = self:GetAbility():GetSpecialValueFor("god_piercing_duration")})
				
				if god_piercing_modifier then
					god_piercing_modifier.enemy = enemy
					
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_lance_of_longinus_god_piercing_enemy", {duration = self:GetAbility():GetSpecialValueFor("god_piercing_duration")})
					
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_spiritlink_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
					ParticleManager:SetParticleControl(particle, 0, attacker:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end
		end
	end

	ProjectileManager:ProjectileDodge(self:GetParent())
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_ally:HorizontalMotion(unit, time)
	if not IsServer() then return end
	
	-- Mars' Arena of Blood exception
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_leash") and self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner() and (self:GetParent():GetAbsOrigin() - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner():GetAbsOrigin()):Length2D() >= self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("radius") - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("width") then
		self:Destroy()
		return
	end
	
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_lance_of_longinus_force_ally:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
		}
	return state
end

function modifier_item_imba_lance_of_longinus_force_ally:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
	
	return decFuncs
end

function modifier_item_imba_lance_of_longinus_force_ally:GetModifierProcAttack_BonusDamage_Pure()
	return self.average_attack_damage
end

modifier_item_imba_lance_of_longinus_force_enemy_ranged = modifier_item_imba_lance_of_longinus_force_enemy_ranged or class({})
modifier_item_imba_lance_of_longinus_force_self_ranged = modifier_item_imba_lance_of_longinus_force_self_ranged or class({})

function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IsDebuff() return true end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IsHidden() return true end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IsPurgable() return false end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IsMotionController()  return true end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_imba_lance_of_longinus_force_enemy_ranged:IgnoreTenacity()  return true end

function modifier_item_imba_lance_of_longinus_force_enemy_ranged:OnCreated()
	if not IsServer() then return end
	local particle_name = "particles/items_fx/force_staff.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"] then
		particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"]
	end	
	
	self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_enemy_ranged:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_lance_of_longinus_force_enemy_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_enemy_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	
	-- Mars' Arena of Blood exception
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_leash") and self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner() and (self:GetParent():GetAbsOrigin() - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner():GetAbsOrigin()):Length2D() >= self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("radius") - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("width") then
		self:Destroy()
		return
	end
	
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_lance_of_longinus_force_self_ranged:IsDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_self_ranged:IsHidden() return true end
function modifier_item_imba_lance_of_longinus_force_self_ranged:IsPurgable() return false end
function modifier_item_imba_lance_of_longinus_force_self_ranged:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_self_ranged:IgnoreTenacity() return true end
function modifier_item_imba_lance_of_longinus_force_self_ranged:IsMotionController()  return true end
function modifier_item_imba_lance_of_longinus_force_self_ranged:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_lance_of_longinus_force_self_ranged:OnCreated()
	if not IsServer() then return end
	local particle_name = "particles/items_fx/force_staff.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"] then
		particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"]
	end	
	
	self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_ranged") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_self_ranged:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_lance_of_longinus_force_self_ranged:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_self_ranged:HorizontalMotion(unit, time)
	if not IsServer() then return end
	
	-- Mars' Arena of Blood exception
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_leash") and self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner() and (self:GetParent():GetAbsOrigin() - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner():GetAbsOrigin()):Length2D() >= self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("radius") - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("width") then
		self:Destroy()
		return
	end
	
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_lance_of_longinus_force_enemy_melee = modifier_item_imba_lance_of_longinus_force_enemy_melee or class({})
modifier_item_imba_lance_of_longinus_force_self_melee = modifier_item_imba_lance_of_longinus_force_self_melee or class({})

function modifier_item_imba_lance_of_longinus_force_enemy_melee:IsDebuff() return true end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:IsHidden() return true end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:IsPurgable() return false end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:IsMotionController()  return true end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_item_imba_lance_of_longinus_force_enemy_melee:IgnoreTenacity()  return true end

function modifier_item_imba_lance_of_longinus_force_enemy_melee:OnCreated()
	if not IsServer() then return end
	local particle_name = "particles/items_fx/force_staff.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"] then
		particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"]
	end	
	
	self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_enemy_melee:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_lance_of_longinus_force_enemy_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_enemy_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	
	-- Mars' Arena of Blood exception
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_leash") and self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner() and (self:GetParent():GetAbsOrigin() - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner():GetAbsOrigin()):Length2D() >= self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("radius") - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("width") then
		self:Destroy()
		return
	end
	
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

function modifier_item_imba_lance_of_longinus_force_self_melee:IsDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_self_melee:IsHidden() return true end
function modifier_item_imba_lance_of_longinus_force_self_melee:IsPurgable() return false end
function modifier_item_imba_lance_of_longinus_force_self_melee:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_force_self_melee:IgnoreTenacity() return true end
function modifier_item_imba_lance_of_longinus_force_self_melee:IsMotionController()  return true end
function modifier_item_imba_lance_of_longinus_force_self_melee:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_item_imba_lance_of_longinus_force_self_melee:OnCreated()
	if not IsServer() then return end
	local particle_name = "particles/items_fx/force_staff.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID())) and CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"] then
		particle_name = CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetParent():GetPlayerOwnerID()))["force_staff"]["effect1"]
	end	
	
	self.pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:GetParent():StartGesture(ACT_DOTA_FLAIL)
	self:StartIntervalThink(FrameTime())
	self.angle = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
	self.distance = self:GetAbility():GetSpecialValueFor("enemy_distance_melee") / ( self:GetDuration() / FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_self_melee:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
end

function modifier_item_imba_lance_of_longinus_force_self_melee:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_lance_of_longinus_force_self_melee:HorizontalMotion(unit, time)
	if not IsServer() then return end
	
	-- Mars' Arena of Blood exception
	if self:GetParent():HasModifier("modifier_mars_arena_of_blood_leash") and self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner() and (self:GetParent():GetAbsOrigin() - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAuraOwner():GetAbsOrigin()):Length2D() >= self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("radius") - self:GetParent():FindModifierByName("modifier_mars_arena_of_blood_leash"):GetAbility():GetSpecialValueFor("width") then
		self:Destroy()
		return
	end
	
	local pos = unit:GetAbsOrigin()
	GridNav:DestroyTreesAroundPoint(pos, 80, false)
	local pos_p = self.angle * self.distance
	local next_pos = GetGroundPosition(pos + pos_p,unit)
	unit:SetAbsOrigin(next_pos)
end

modifier_item_imba_lance_of_longinus_attack_speed = modifier_item_imba_lance_of_longinus_attack_speed or class({})

function modifier_item_imba_lance_of_longinus_attack_speed:IsDebuff() return false end
function modifier_item_imba_lance_of_longinus_attack_speed:IsHidden() return false end
function modifier_item_imba_lance_of_longinus_attack_speed:IsPurgable() return true end
function modifier_item_imba_lance_of_longinus_attack_speed:IsStunDebuff() return false end
function modifier_item_imba_lance_of_longinus_attack_speed:IgnoreTenacity() return true end

function modifier_item_imba_lance_of_longinus_attack_speed:OnCreated()
	if not IsServer() then return end
	self.as = 0
	self.ar = 0
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_lance_of_longinus_attack_speed:OnIntervalThink()
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

function modifier_item_imba_lance_of_longinus_attack_speed:DeclareFunctions()
	local decFuncs =   {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}
	return decFuncs
end

function modifier_item_imba_lance_of_longinus_attack_speed:GetModifierAttackSpeedBonus_Constant()
	if not IsServer() then return end
	return self.as
end

function modifier_item_imba_lance_of_longinus_attack_speed:GetModifierAttackRangeBonus()
	if not IsServer() then return end
	return self.ar
end

function modifier_item_imba_lance_of_longinus_attack_speed:OnAttack( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.attacker == self:GetParent() then
		if self:GetStackCount() > 1 then
			self:DecrementStackCount()
		else
			self:Destroy()
		end
	end
end

function modifier_item_imba_lance_of_longinus_attack_speed:OnOrder( keys )
	if not IsServer() then return end
	if keys.target == self.target and keys.unit == self:GetParent() and keys.order_type == 4 then
		if self:GetParent():IsRangedAttacker() then
			self.ar = 999999
		end
		
		self.as = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

--------------------------------
-- GOD PIERCING ALLY MODIFIER --
--------------------------------

modifier_item_imba_lance_of_longinus_god_piercing_ally = class ({})

function modifier_item_imba_lance_of_longinus_god_piercing_ally:IsPurgable()		return false end
function modifier_item_imba_lance_of_longinus_god_piercing_ally:IgnoreTenacity() 	return true end
function modifier_item_imba_lance_of_longinus_god_piercing_ally:RemoveOnDeath() 	return false end
function modifier_item_imba_lance_of_longinus_god_piercing_ally:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_lance_of_longinus_god_piercing_ally:OnCreated(params)
	if not IsServer() then return end
	
	self.total_gained_health = 0
	
	self:StartIntervalThink(1)
end

function modifier_item_imba_lance_of_longinus_god_piercing_ally:OnIntervalThink()
	if not IsServer() then return end

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.total_gained_health, nil)
	self.total_gained_health = 0
end

function modifier_item_imba_lance_of_longinus_god_piercing_ally:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED
	}

	return decFuncs
end

function modifier_item_imba_lance_of_longinus_god_piercing_ally:OnHealReceived(keys)
	if not IsServer() then return end
	
	-- No longer able to apply multiple times on the same unit due to crash issues
	if keys.unit == self.enemy and not keys.unit:HasModifier("modifier_item_imba_lance_of_longinus_god_piercing_ally") then
		self:GetParent():Heal(keys.gain, self:GetAbility())
		-- in order to avoid spam in "OnGained" we group it up in total_gained. Value is sent and reset each 1s
		self.total_gained_health = self.total_gained_health + keys.gain
	end
end

---------------------------------
-- GOD PIERCING ENEMY MODIFIER --
---------------------------------

-- All this logic should be handled in ally modifier so this is just for visuals
modifier_item_imba_lance_of_longinus_god_piercing_enemy = class ({})

function modifier_item_imba_lance_of_longinus_god_piercing_enemy:IsPurgable()		return false end
function modifier_item_imba_lance_of_longinus_god_piercing_enemy:IgnoreTenacity() 	return true end
function modifier_item_imba_lance_of_longinus_god_piercing_enemy:RemoveOnDeath() 	return false end
function modifier_item_imba_lance_of_longinus_god_piercing_enemy:GetAttributes() 	return MODIFIER_ATTRIBUTE_MULTIPLE end

---------------------------------------
-- DIVERGENT THRUST DISABLE MODIFIER --
---------------------------------------

modifier_item_imba_lance_of_longinus_divergent_thrust = class({})

function modifier_item_imba_lance_of_longinus_divergent_thrust:IgnoreTenacity() return true end

function modifier_item_imba_lance_of_longinus_divergent_thrust:GetTexture()
	return "custom/lance_of_longinus_divergent"
end

function modifier_item_imba_lance_of_longinus_divergent_thrust:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_DISABLE_HEALING 
	}
	return decFuncs
end

function modifier_item_imba_lance_of_longinus_divergent_thrust:GetDisableHealing()
	return 1
end
