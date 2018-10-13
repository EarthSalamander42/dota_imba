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
--     EarthSalamander #42, 03.02.2018

------------------------------
--			DOOM
------------------------------

LinkLuaModifier("modifier_imba_doom_bringer_doom", "components/abilities/heroes/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_doom_enemies", "components/abilities/heroes/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)

imba_doom_bringer_doom = class({})
function imba_doom_bringer_doom:IsHiddenWhenStolen() return false end
function imba_doom_bringer_doom:IsRefreshable() return true end
function imba_doom_bringer_doom:IsStealable() return true end
function imba_doom_bringer_doom:IsNetherWardStealable() return false end

function imba_doom_bringer_doom:GetAbilityTextureName()
	return "doom_bringer_doom"
end

function imba_doom_bringer_doom:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		caster:AddNewModifier(caster, self, "modifier_imba_doom_bringer_doom", {duration = duration})
	end
end
-------------------------------------------
modifier_imba_doom_bringer_doom = class({})
function modifier_imba_doom_bringer_doom:IsDebuff() return false end
function modifier_imba_doom_bringer_doom:IsHidden() return false end
function modifier_imba_doom_bringer_doom:IsPurgable() return false end
function modifier_imba_doom_bringer_doom:IsPurgeException() return false end
function modifier_imba_doom_bringer_doom:IsStunDebuff() return false end
function modifier_imba_doom_bringer_doom:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_doom_bringer_doom:IsAura()
	return true
end

function modifier_imba_doom_bringer_doom:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_doom_bringer_doom:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_doom_bringer_doom:GetModifierAura()
	return "modifier_imba_doom_bringer_doom_enemies"
end

function modifier_imba_doom_bringer_doom:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_doom_bringer_doom:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_doom_bringer_doom:GetAuraEntityReject(target)
	if IsServer() then
		if self:GetParent() == target then
			return true
		end
	end
	return false
end

function modifier_imba_doom_bringer_doom:OnCreated()
	EmitSoundOn("Hero_DoomBringer.Doom", self:GetParent())
end

function modifier_imba_doom_bringer_doom:GetEffectName()
	return "particles/units/hero/doom_bringer/doom/doom_bringer_doom_self.vpcf"
end

function modifier_imba_doom_bringer_doom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_doom_bringer_doom:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom_self.vpcf"
end

function modifier_imba_doom_bringer_doom:StatusEffectPriority()
	return 10
end

function modifier_imba_doom_bringer_doom:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		}
	return decFuns
end

function modifier_imba_doom_bringer_doom:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function modifier_imba_doom_bringer_doom:OnDestroy()
	StopSoundOn("Hero_DoomBringer.Doom", self:GetParent())
end

-------------------------------------------
modifier_imba_doom_bringer_doom_enemies = class({})
function modifier_imba_doom_bringer_doom_enemies:IsDebuff() return false end
function modifier_imba_doom_bringer_doom_enemies:IsHidden() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgable() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgeException() return false end
function modifier_imba_doom_bringer_doom_enemies:IsStunDebuff() return false end
function modifier_imba_doom_bringer_doom_enemies:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_doom_bringer_doom_enemies:OnCreated()
	--	self:GetParent():Purge(true, false, false, false, false)
	self:StartIntervalThink(1.0)
end

function modifier_imba_doom_bringer_doom_enemies:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf"
end

function modifier_imba_doom_bringer_doom_enemies:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_doom_bringer_doom_enemies:OnRefresh()
	self:OnCreated()
end

function modifier_imba_doom_bringer_doom_enemies:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_imba_doom_bringer_doom_enemies:StatusEffectPriority()
	return 10
end

function modifier_imba_doom_bringer_doom_enemies:CheckState()
	local state = {}
	state = {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end

function modifier_imba_doom_bringer_doom_enemies:OnIntervalThink()
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_5"), damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
	end
end
