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
--     EarthSalamander, 15/10/2020

LinkLuaModifier("modifier_quick_stick_3_handler", "components/abilities/heroes/hero_quick_stick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_quick_stick_3_counter", "components/abilities/heroes/hero_quick_stick", LUA_MODIFIER_MOTION_NONE)

quick_stick_3 = quick_stick_3 or class({})

function quick_stick_3:GetIntrinsicModifierName()
	return "modifier_quick_stick_3_handler"
end

modifier_quick_stick_3_handler = modifier_quick_stick_3_handler or class({})

function modifier_quick_stick_3_handler:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
} end

function modifier_quick_stick_3_handler:OnAttackLanded(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() then
		if not self:GetParent():HasModifier("modifier_quick_stick_3_buff") then
			if not params.target:HasModifier("modifier_quick_stick_3_counter") then
				params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_quick_stick_3_counter", {duration = self:GetAbility():GetSpecialValueFor("duration")}):SetStackCount(1)
			else
				params.target:FindModifierByName("modifier_quick_stick_3_counter"):IncrementStackCount()
			end
		end
	end
end

modifier_quick_stick_3_counter = modifier_quick_stick_3_counter or class({})

function modifier_quick_stick_3_counter:OnStackCountChanged(iStackCount)
	if iStackCount >= self:GetAbility():GetSpecialValueFor("required_hits") - 1 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_quick_stick_3_buff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		self:Destroy()
	else
		if not self.pfx then
			self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		end

		ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))

		self:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
	end
end

function modifier_quick_stick_3_counter:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

modifier_quick_stick_3_buff = modifier_quick_stick_3_buff or class({})

function modifier_quick_stick_3_buff:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
end

function modifier_quick_stick_3_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_quick_stick_3_buff:DeclareFunctions() return {
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
} end

function modifier_quick_stick_3_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end
