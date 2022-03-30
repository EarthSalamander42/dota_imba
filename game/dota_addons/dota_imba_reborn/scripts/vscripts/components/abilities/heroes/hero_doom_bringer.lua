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
--	   AltiV, 23.06.2019

------------------------------
--			DOOM
------------------------------

LinkLuaModifier("modifier_imba_doom_bringer_doom", "components/abilities/heroes/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_doom_handler", "components/abilities/heroes/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_doom_enemies", "components/abilities/heroes/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)

imba_doom_bringer_doom = class({})
function imba_doom_bringer_doom:IsHiddenWhenStolen() return false end
function imba_doom_bringer_doom:IsRefreshable() return true end
function imba_doom_bringer_doom:IsStealable() return true end
function imba_doom_bringer_doom:IsNetherWardStealable() return false end

function imba_doom_bringer_doom:GetAbilityTextureName()
	return "doom_bringer_doom"
end

function imba_doom_bringer_doom:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_doom_bringer_doom_handler", self:GetCaster()) == 0 then
		return self:GetSpecialValueFor("aoe_radius")
	else
		return 0
	end
end

function imba_doom_bringer_doom:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_doom_bringer_doom_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("aura_radius")
	end
end

function imba_doom_bringer_doom:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_doom_bringer_doom_handler", self:GetCaster()) == 0 then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AURA + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_doom_bringer_doom:GetIntrinsicModifierName()
	return "modifier_imba_doom_bringer_doom_handler"
end

function imba_doom_bringer_doom:OnSpellStart()
	local caster = self:GetCaster()
	
	if self:GetAutoCastState() then
		caster:AddNewModifier(caster, self, "modifier_imba_doom_bringer_doom", {duration = self:GetSpecialValueFor("self_duration") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_7")})
	else
		if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
		
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_doom_bringer_doom_enemies", {duration = (self:GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_7")) * (1 - enemy:GetStatusResistance())})
			end
		end
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

function modifier_imba_doom_bringer_doom:GetAuraDuration()
	return 0.25
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
modifier_imba_doom_bringer_doom_handler = class({})
function modifier_imba_doom_bringer_doom_handler:IsHidden() return false end

function modifier_imba_doom_bringer_doom_handler:IsHidden()	return true end

function modifier_imba_doom_bringer_doom_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	return decFuncs
end

function modifier_imba_doom_bringer_doom_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end
-------------------------------------------
modifier_imba_doom_bringer_doom_enemies = class({})
function modifier_imba_doom_bringer_doom_enemies:IsDebuff() return true end
function modifier_imba_doom_bringer_doom_enemies:IsHidden() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgable() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgeException() return false end
function modifier_imba_doom_bringer_doom_enemies:IsStunDebuff() return false end
function modifier_imba_doom_bringer_doom_enemies:RemoveOnDeath() return true end
function modifier_imba_doom_bringer_doom_enemies:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
-------------------------------------------

function modifier_imba_doom_bringer_doom_enemies:OnCreated()
	if self:GetAbility() then
		self.deniable_pct	= self:GetAbility():GetSpecialValueFor("deniable_pct")
		self.duration		= self:GetAbility():GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_7")
		self.damage			= self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():FindTalentValue("special_bonus_unique_doom_5")
	else
		self.deniable_pct	= 25
		self.duration		= self:GetAbility():GetSpecialValueFor(16)
		self.damage			= 0
	end
	
	if not IsServer() then return end
	
	EmitSoundOn("Hero_DoomBringer.Doom", self:GetParent())
	
	-- This is to track Aghanim's Scepter duration and tick mechanics 
	self.reentered = nil
	
	-- if self:GetAbility() and self:GetCaster():HasScepter() and not self:GetAbility():GetAutoCastState() then
		-- self:GetParent():Purge(true, false, false, false, false)
	-- end
	
	self:OnIntervalThink()
	
	self:StartIntervalThink(1.0 * (1 - self:GetParent():GetStatusResistance()))
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

function modifier_imba_doom_bringer_doom_enemies:OnDestroy()
	if not IsServer() then return end

	StopSoundOn("Hero_DoomBringer.Doom", self:GetParent())
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
	}
	
	-- if self:GetCaster():HasScepter() then
		-- state[MODIFIER_STATE_PASSIVES_DISABLED] = true
	-- end
	
	if self:GetParent():GetHealthPercent() <= self.deniable_pct then
		state[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	end
	
	return state
end

function modifier_imba_doom_bringer_doom_enemies:OnIntervalThink()
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
		
		-- if self:GetAbility() and not self:GetAbility():GetAutoCastState() and self:GetCaster():HasScepter() and (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= 900 and self:GetCaster():IsAlive() then
			-- if self.reentered == nil then
				-- self.reentered = true
			-- end
			
			-- if self.reentered and self:GetElapsedTime() >= self.duration * (1 - self:GetParent():GetStatusResistance()) then
				-- self:Destroy()
			-- else
				-- self.reentered = nil
				-- self:SetDuration(self:GetRemainingTime() + 1.0, true)
				-- self:StartIntervalThink(1.0)
			-- end
		-- else
			self.reentered = false
			self:StartIntervalThink(1.0 * (1 - self:GetParent():GetStatusResistance()))
		-- end
	end
end
