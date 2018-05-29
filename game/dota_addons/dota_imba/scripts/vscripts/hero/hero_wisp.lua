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
--     EarthSalamander #42, 23.05.2018
--     Based on old Dota 2 Spell Library: https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_wisp

CreateEmptyTalents("wisp")

------------------------------
--			TETHER			--
------------------------------
imba_wisp_tether = class({})
LinkLuaModifier("modifier_imba_wisp_tether", "hero/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_ally", "hero/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_latch", "hero/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_tether:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	end
end

function imba_lion_mana_drain:CastFilterResultTarget(target)
	if IsServer() then
		if target == self:GetCaster() then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_wisp_tether:OnSpellStart()
	self.caster_origin = self:GetCaster():GetAbsOrigin()
	self.target_origin = self:GetCursorTarget():GetAbsOrigin()
	self.tether_ally = self:GetCursorTarget()
	self.tether_slowedUnits = {}

	self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
	self:GetCaster().tether_lastMana = self:GetCaster():GetMana()

	self.target = self:GetCursorTarget()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether", {})
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether_ally", {})

	local distToAlly = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
	if distToAlly >= self:GetSpecialValueFor("latch_distance") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether_latch", {})
	end

	self:GetCaster():SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", true, false)
end

modifier_imba_wisp_tether = class({})

function modifier_imba_wisp_tether:IsHidden() return false end
function modifier_imba_wisp_tether:IsPurgable() return false end

function modifier_imba_wisp_tether:OnCreated()
	self.target = self:GetAbility().target
	self.tether_heal_amp = self:GetAbility():GetSpecialValueFor("tether_heal_amp")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")

	EmitSoundOn("Hero_Wisp.Tether", self:GetParent())
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_wisp_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_MANA_GAINED,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
	}

	return decFuncs
end

function modifier_imba_wisp_tether:OnIntervalThink()
	self:GetParent().tether_lastHealth = self:GetParent():GetHealth()
--	print("Ally ms:", self:GetAbility().tether_ally:GetIdealSpeed())
	self:SetStackCount(self:GetAbility().tether_ally:GetIdealSpeed())

	if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
		return
	end

	local distance = (self:GetAbility().tether_ally:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

	if distance <= self.radius then
		return
	end

	self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
end

function modifier_imba_wisp_tether:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
	end
end

function modifier_imba_wisp_tether:OnHealReceived(keys)
	if keys.unit == self:GetParent() then
		local healthGained = self:GetCaster():GetHealth() - self:GetCaster().tether_lastHealth

		if healthGained < 0 then
			return
		end

--		print("Health gained:", healthGained, self:GetAbility():GetCaster().tether_lastHealth)

		self.target:Heal(healthGained * self.tether_heal_amp, self:GetAbility())
		self:GetCaster().tether_lastHealth = self:GetCaster():GetHealth()
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, healthGained * self.tether_heal_amp, nil)
	end
end

function modifier_imba_wisp_tether:OnManaGained(keys)
	if keys.unit == self:GetParent() then
		local manaGained = self:GetCaster():GetMana() - self:GetCaster().tether_lastMana

		if manaGained < 0 then
			return
		end

--		print(manaGained, self:GetCaster().tether_lastMana)

		self.target:GiveMana(manaGained * self.tether_heal_amp)
		self:GetCaster().tether_lastMana = self:GetCaster():GetMana()
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, manaGained * self.tether_heal_amp, nil)
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeedOverride()
    return self:GetStackCount()
end

function modifier_imba_wisp_tether:OnRemoved()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end

		if self.target:HasModifier("modifier_imba_wisp_tether_ally") then
			self.target:RemoveModifierByName("modifier_imba_wisp_tether_ally")
		end

		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", false, true)
	end
end

modifier_imba_wisp_tether_ally = class({})

function modifier_imba_wisp_tether_ally:IsHidden() return false end
function modifier_imba_wisp_tether_ally:IsPurgable() return false end

function modifier_imba_wisp_tether_ally:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		self:StartIntervalThink(FrameTime())
		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())
	end
end

function modifier_imba_wisp_tether_ally:OnIntervalThink()

	if IsServer() then
		local velocity = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()

		local projectile = 
		{
			Ability				= self,
			EffectName			= "particles/hero/ghost_revenant/blackjack_projectile.vpcf",
			vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			fDistance			= velocity:Length2D(),
			fStartRadius		= 100,
			fEndRadius			= 100,
			Source				= self:GetCaster(),
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime			= GameRules:GetGameTime() + FrameTime() + FrameTime(),
			bDeleteOnHit		= false,
			vVelocity			= velocity / FrameTime(),
		}

		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function modifier_imba_wisp_tether_ally:OnProjectileHit(event)
	-- Variables
	local caster	= event.caster
	local target	= event.target	-- An enemy unit
	PrintTable(event)

	-- Already got slowed
	if self:GetAbility().tether_slowedUnits[target] then
		return
	end

	-- Apply slow debuff
--	self:GetAbility():ApplyDataDrivenModifier(caster, target, "", {})

	-- An enemy unit may only be slowed once per cast.
	-- We store the enemy unit to the hashset, so we can check whether the unit has got debuff already later on.
	self:GetAbility().tether_slowedUnits[target] = true
end

function modifier_imba_wisp_tether_ally:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Tether.Target")
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

modifier_imba_wisp_tether_latch = class({})

function modifier_imba_wisp_tether_latch:OnCreated()
	if IsServer() then
		self.target = self:GetAbility().target
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_latch:OnIntervalThink()
	if IsServer() then
		-- Calculate the distance
		local casterDir = self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()
		local distToAlly = casterDir:Length2D()
		casterDir = casterDir:Normalized()

		if distToAlly > self:GetAbility():GetSpecialValueFor("latch_distance") then
			-- Leap to the target
			distToAlly = distToAlly - self:GetAbility():GetSpecialValueFor("latch_speed") * FrameTime()
			distToAlly = math.max( distToAlly, self:GetAbility():GetSpecialValueFor("latch_distance"))	-- Clamp this value

			local pos = self.target:GetAbsOrigin() + casterDir * distToAlly
			pos = GetGroundPosition(pos, self:GetCaster())

			self:GetCaster():SetAbsOrigin(pos)
		end

		if distToAlly <= self:GetAbility():GetSpecialValueFor("latch_distance") then
			-- We've reached, so finish latching
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end
	end
end

imba_wisp_tether_break = class({})

function imba_wisp_tether_break:IsInnateAbility() return true end

function imba_wisp_tether_break:OnSpellStart()
	self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
end
