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
-- Date: 2018/02/09  YYYY/MM/DD


item_imba_cyclone = class({})

LinkLuaModifier("modifier_item_imba_cyclone", "components/items/item_eul_scepter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_active", "components/items/item_eul_scepter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_active_debuff", "components/items/item_eul_scepter", LUA_MODIFIER_MOTION_NONE)

function item_imba_cyclone:GetIntrinsicModifierName()
	return "modifier_item_imba_cyclone"
end

modifier_item_imba_cyclone = class({})

function modifier_item_imba_cyclone:IsHidden() return true end
function modifier_item_imba_cyclone:IsPurgable() return false end
function modifier_item_imba_cyclone:IsDebuff() return false end
function modifier_item_imba_cyclone:RemoveOnDeath() return false end
function modifier_item_imba_cyclone:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_cyclone:DeclareFunctions()
	local funcs = {
					MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
					}
	return funcs
end

function modifier_item_imba_cyclone:GetModifierConstantManaRegen()	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
function modifier_item_imba_cyclone:GetModifierBonusStats_Intellect()	return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
function modifier_item_imba_cyclone:GetModifierMoveSpeedBonus_Constant()	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end

function item_imba_cyclone:CastFilterResultTarget(hTarget)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if caster:GetTeamNumber() == hTarget:GetTeamNumber() and caster ~= hTarget then
		return UF_FAIL_FRIENDLY
	end
	if caster ~= hTarget and hTarget:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end
end

function item_imba_cyclone:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		target:Purge(true, false, false, false, false)
		target:AddNewModifier(caster, self, "modifier_item_imba_cyclone_active_debuff", {duration = self:GetSpecialValueFor("cyclone_duration")})
	else
		caster:Purge(false, true, false, false, false)
		target:AddNewModifier(caster, self, "modifier_item_imba_cyclone_active", {duration = self:GetSpecialValueFor("cyclone_duration")})
	end
end

modifier_item_imba_cyclone_active = class({})

function modifier_item_imba_cyclone_active:IsDebuff() return false end
function modifier_item_imba_cyclone_active:IsHidden() return false end
function modifier_item_imba_cyclone_active:IsPurgable() return true end
function modifier_item_imba_cyclone_active:IsStunDebuff() return true end
function modifier_item_imba_cyclone_active:IsMotionController()  return true end
function modifier_item_imba_cyclone_active:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_item_imba_cyclone_active:OnCreated()
	self:StartIntervalThink(FrameTime())
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/items_fx/cyclone.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)
	end
end

function modifier_item_imba_cyclone_active:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_cyclone_active:HorizontalMotion(unit, time)
	if not IsServer() then return end
	-- Change the Face Angle
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	-- Change the height at the first and last 0.3 sec
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	else -- Random move
		local pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		while ((pos - self.abs):Length2D() > 50) do
			pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		end
		self:GetParent():SetAbsOrigin(pos)
	end
end

function modifier_item_imba_cyclone_active:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end

function modifier_item_imba_cyclone_active:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	return state
end

modifier_item_imba_cyclone_active_debuff = class({})

function modifier_item_imba_cyclone_active_debuff:IsDebuff() return true end
function modifier_item_imba_cyclone_active_debuff:IsHidden() return false end
function modifier_item_imba_cyclone_active_debuff:IsPurgable() return true end
function modifier_item_imba_cyclone_active_debuff:IsStunDebuff() return true end
function modifier_item_imba_cyclone_active_debuff:IsMotionController()  return true end
function modifier_item_imba_cyclone_active_debuff:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end

function modifier_item_imba_cyclone_active_debuff:OnCreated()
	self:StartIntervalThink(FrameTime())
	EmitSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_FLAIL)
		self.angle = self:GetParent():GetAngles()
		self.abs = self:GetParent():GetAbsOrigin()
		self.cyc_pos = self:GetParent():GetAbsOrigin()

		self.pfx_name = "particles/items_fx/cyclone.vpcf"
		self.pfx = ParticleManager:CreateParticle(self.pfx_name, PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.pfx, 0, self.abs)
	end
end

function modifier_item_imba_cyclone_active_debuff:OnIntervalThink()
	-- Remove force if conflicting
	if not self:CheckMotionControllers() then
		self:Destroy()
		return
	end
	self:HorizontalMotion(self:GetParent(), FrameTime())
end

function modifier_item_imba_cyclone_active_debuff:HorizontalMotion(unit, time)
	if not IsServer() then return end
	-- Change the Face Angle
	local angle = self:GetParent():GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,20,0))
	self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])
	-- Change the height at the first and last 0.3 sec
	if self:GetElapsedTime() <= 0.3 then
		self.cyc_pos.z = self.cyc_pos.z + 50
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	elseif self:GetDuration() - self:GetElapsedTime() < 0.3 then
		self.step = self.step or (self.cyc_pos.z - self.abs.z) / ((self:GetDuration() - self:GetElapsedTime()) / FrameTime())
		self.cyc_pos.z = self.cyc_pos.z - self.step
		self:GetParent():SetAbsOrigin(self.cyc_pos)
	else -- Random move
		local pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		while ((pos - self.abs):Length2D() > 50) do
			pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(),5)
		end
		self:GetParent():SetAbsOrigin(pos)
	end
end

function modifier_item_imba_cyclone_active_debuff:OnDestroy()
	StopSoundOn("DOTA_Item.Cyclone.Activate", self:GetParent())
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

	self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
	self:GetParent():SetAbsOrigin(self.abs)
	ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])

	--damage enemy
	local damageTable = {victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = self:GetAbility():GetSpecialValueFor("tooltip_drop_damage"),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()}
	ApplyDamage(damageTable)
end

function modifier_item_imba_cyclone_active_debuff:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		}
	return state
end
