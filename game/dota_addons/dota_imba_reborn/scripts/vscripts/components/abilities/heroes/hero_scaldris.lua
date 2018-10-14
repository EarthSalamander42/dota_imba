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
--     Firetoad

-------------------------------------------
--				 General
-------------------------------------------
function AntipodeColorChange(caster, fire, ice)
	local antipode_modifier = caster:FindModifierByName("modifier_imba_antipode_passive")
	if fire then
		antipode_modifier.fire_strength = antipode_modifier.fire_strength + 1
		Timers:CreateTimer(5.0, function()
			antipode_modifier.fire_strength = antipode_modifier.fire_strength - 1
		end)
	end
	if ice then
		antipode_modifier.ice_strength = antipode_modifier.ice_strength + 1
		Timers:CreateTimer(5.0, function()
			antipode_modifier.ice_strength = antipode_modifier.ice_strength - 1
		end)
	end
end

function AntipodeFireProc(caster, target)
	local actual_damage = 0
	if target:FindModifierByName("modifier_imba_cold_front_dps") then
		local modifier = target:FindModifierByName("modifier_imba_cold_front_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_cold_front_dps")
	end
	if target:FindModifierByName("modifier_imba_freeze_dps") then
		local modifier = target:FindModifierByName("modifier_imba_freeze_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_freeze_dps")
	end
	if target:FindModifierByName("modifier_imba_ice_floes_dps") then
		local modifier = target:FindModifierByName("modifier_imba_ice_floes_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_ice_floes_dps")
	end
	if target:FindModifierByName("modifier_imba_absolute_zero_dps") then
		local modifier = target:FindModifierByName("modifier_imba_absolute_zero_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_absolute_zero_dps")
	end
	if actual_damage > 0 then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actual_damage, nil)
	end
end

function AntipodeIceProc(caster, target)
	local actual_damage = 0
	if target:FindModifierByName("modifier_imba_heatwave_dps") then
		local modifier = target:FindModifierByName("modifier_imba_heatwave_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_heatwave_dps")
	end
	if target:FindModifierByName("modifier_imba_scorch_dps") then
		local modifier = target:FindModifierByName("modifier_imba_scorch_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_scorch_dps")
	end
	if target:FindModifierByName("modifier_imba_jet_blaze_dps") then
		local modifier = target:FindModifierByName("modifier_imba_jet_blaze_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
		target:RemoveModifierByName("modifier_imba_jet_blaze_dps")
	end
	if target:FindModifierByName("modifier_imba_living_flame_dps") then
		local modifier = target:FindModifierByName("modifier_imba_living_flame_dps")
		LivingFlameSpreadAttempt(modifier)
		target:RemoveModifierByName("modifier_imba_living_flame_dps")
		actual_damage = actual_damage + ApplyDamage({victim = target, attacker = caster, damage = modifier.dps * math.ceil(modifier:GetRemainingTime()), damage_type = DAMAGE_TYPE_MAGICAL})
	end
	if actual_damage > 0 then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actual_damage, nil)
	end
end



-------------------------------------------
--				 Antipode
-------------------------------------------

imba_scaldris_antipode = class({})

LinkLuaModifier("modifier_imba_antipode_passive", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_antipode:IsHiddenWhenStolen() return false end
function imba_scaldris_antipode:IsRefreshable() return false end
function imba_scaldris_antipode:IsStealable() return false end
function imba_scaldris_antipode:IsNetherWardStealable() return false end
function imba_scaldris_antipode:IsInnateAbility() return true end

function imba_scaldris_antipode:GetAbilityTextureName()
	return "custom/scaldris_antipode"
end

function imba_scaldris_antipode:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

-- Passive modifier
modifier_imba_antipode_passive = class({})
function modifier_imba_antipode_passive:IsDebuff() return false end
function modifier_imba_antipode_passive:IsHidden() return true end
function modifier_imba_antipode_passive:IsPurgable() return false end
function modifier_imba_antipode_passive:IsPurgeException() return false end
function modifier_imba_antipode_passive:IsStunDebuff() return false end

function modifier_imba_antipode_passive:OnCreated()
	if IsServer() then
		self.fire_strength = 0
		self.ice_strength = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_antipode_passive:OnIntervalThink()
	if IsServer() then
		if not self:GetAbility():IsStolen() then
			self:GetParent():SetRenderColor(63 + math.min(self.fire_strength, 4) * 48, 64, 63 + math.min(self.ice_strength, 4) * 48)
		end
	end
end



-------------------------------------------
--				 Heatwave
-------------------------------------------

imba_scaldris_heatwave = class({})

LinkLuaModifier("modifier_imba_heatwave_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_heatwave:IsHiddenWhenStolen() return false end
function imba_scaldris_heatwave:IsRefreshable() return true end
function imba_scaldris_heatwave:IsStealable() return true end
function imba_scaldris_heatwave:IsNetherWardStealable() return true end

function imba_scaldris_heatwave:GetAbilityTextureName()
	return "custom/scaldris_heatwave"
end

function imba_scaldris_heatwave:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_heatwave:GetAssociatedSecondaryAbilities()
	return "imba_scaldris_cold_front"
end

function imba_scaldris_heatwave:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_cold_front") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_cold_front")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_heatwave:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_loc = self:GetCursorPosition()

		-- Cursorcast fix
		if target_loc == caster_loc then
			target_loc = caster_loc + caster:GetForwardVector() * 100
		end

		local direction = (target_loc - caster_loc):Normalized()
		local wave_radius = self:GetSpecialValueFor("wave_radius")
		local wave_speed = self:GetSpecialValueFor("wave_speed")
		local wave_distance = self:GetSpecialValueFor("wave_distance") + GetCastRangeIncrease(caster)

		-- Antipode visuals
		AntipodeColorChange(caster, true, false)

		-- Cast sound
		caster:EmitSound("Hero_Invoker.DeafeningBlast")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_heatwave", "imba_scaldris_cold_front", false, true)

		-- Create projectile
		local wave_projectile = {
			Ability				= self,
			EffectName			= "particles/hero/scaldris/heatwave.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= wave_distance,
			fStartRadius		= wave_radius,
			fEndRadius			= wave_radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * wave_speed,
			bProvidesVision		= true,
			iVisionRadius 		= wave_radius + 150,
			iVisionTeamNumber 	= caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(wave_projectile)
	end
end

function imba_scaldris_heatwave:OnProjectileHit(target, location)
	if IsServer() then
		if target then
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_heatwave_dps", {duration = self:GetSpecialValueFor("duration"), dps = self:GetSpecialValueFor("dps")})
		end
	end
end

-- Heatwave debuff
modifier_imba_heatwave_dps = class({})

function modifier_imba_heatwave_dps:IsDebuff() return true end
function modifier_imba_heatwave_dps:IsHidden() return false end
function modifier_imba_heatwave_dps:IsPurgable() return false end
function modifier_imba_heatwave_dps:IsPurgeException() return true end
function modifier_imba_heatwave_dps:IsStunDebuff() return false end
function modifier_imba_heatwave_dps:RemoveOnDeath() return true end

function modifier_imba_heatwave_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeFireProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_heatwave_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_heatwave_dps:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_imba_heatwave_dps:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



-------------------------------------------
--				 Cold Front
-------------------------------------------

imba_scaldris_cold_front = class({})

LinkLuaModifier("modifier_imba_cold_front_root", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_cold_front_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_cold_front:IsHiddenWhenStolen() return true end
function imba_scaldris_cold_front:IsRefreshable() return true end
function imba_scaldris_cold_front:IsStealable() return true end
function imba_scaldris_cold_front:IsNetherWardStealable() return true end

function imba_scaldris_cold_front:GetAOERadius()
	return self:GetSpecialValueFor("blast_radius")
end

function imba_scaldris_cold_front:GetAbilityTextureName()
	return "custom/scaldris_cold_front"
end

function imba_scaldris_cold_front:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_cold_front:GetAssociatedPrimaryAbilities()
	return "imba_scaldris_heatwave"
end


function imba_scaldris_cold_front:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_heatwave") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_heatwave")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_cold_front:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_loc = self:GetCursorPosition()

		-- Cursorcast fix
		if target_loc == caster_loc then
			target_loc = caster_loc + caster:GetForwardVector() * 100
		end

		local direction = (target_loc - caster_loc):Normalized()
		local distance = (target_loc - caster_loc):Length2D()
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")

		-- Antipode visuals
		AntipodeColorChange(caster, false, true)

		-- Cast sound
		caster:EmitSound("Scaldris.ColdFrontLaunch")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_heatwave", "imba_scaldris_cold_front", true, false)

		-- Create projectile
		local ice_projectile = {
			Ability				= self,
			EffectName			= "particles/hero/scaldris/ice_spell_projectile.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= distance,
			fStartRadius		= 0,
			fEndRadius			= 0,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * projectile_speed,
			bProvidesVision		= false,
			ExtraData			= {x = target_loc.x, y = target_loc.y}
		}
		ProjectileManager:CreateLinearProjectile(ice_projectile)
	end
end

function imba_scaldris_cold_front:OnProjectileHit(target, location)
	if IsServer() then
	end
end

function imba_scaldris_cold_front:OnProjectileThink_ExtraData(location, extra_data)
	if IsServer() then
		if (location - Vector(extra_data.x, extra_data.y, location.z)):Length2D() <= 16 then

			-- Blast sound
			self:GetCaster():EmitSound("Scaldris.ColdFrontImpact")

			-- Blast vision
			AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self:GetSpecialValueFor("blast_radius") + 200, 3.0, false)

			-- Blast particle
			local blast_pfx = ParticleManager:CreateParticle("particles/hero/scaldris/cold_front_blast.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(blast_pfx, 0, location + Vector(0, 0, 100))
			ParticleManager:SetParticleControl(blast_pfx, 3, location + Vector(0, 0, 100))
			ParticleManager:ReleaseParticleIndex(blast_pfx)

			-- Apply root and damage modifiers to nearby enemies
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("blast_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_cold_front_root", {duration = self:GetSpecialValueFor("root_duration")})
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_cold_front_dps", {duration = self:GetSpecialValueFor("damage_duration"), dps = self:GetSpecialValueFor("dps")})
			end
		end
	end
end

-- Cold Front root debuff
modifier_imba_cold_front_root = class({})

function modifier_imba_cold_front_root:IsDebuff() return true end
function modifier_imba_cold_front_root:IsHidden() return false end
function modifier_imba_cold_front_root:IsPurgable() return true end
function modifier_imba_cold_front_root:IsStunDebuff() return false end
function modifier_imba_cold_front_root:RemoveOnDeath() return true end

function modifier_imba_cold_front_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

function modifier_imba_cold_front_root:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_imba_cold_front_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Cold Front damage debuff
modifier_imba_cold_front_dps = class({})

function modifier_imba_cold_front_dps:IsDebuff() return true end
function modifier_imba_cold_front_dps:IsHidden() return false end
function modifier_imba_cold_front_dps:IsPurgable() return false end
function modifier_imba_cold_front_dps:IsPurgeException() return true end
function modifier_imba_cold_front_dps:IsStunDebuff() return false end
function modifier_imba_cold_front_dps:RemoveOnDeath() return true end

function modifier_imba_cold_front_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeIceProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_cold_front_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_cold_front_dps:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end



-------------------------------------------
--				 Scorch
-------------------------------------------

imba_scaldris_scorch = class({})

LinkLuaModifier("modifier_imba_scorch_blind", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_scorch_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_scorch:IsHiddenWhenStolen() return false end
function imba_scaldris_scorch:IsRefreshable() return true end
function imba_scaldris_scorch:IsStealable() return true end
function imba_scaldris_scorch:IsNetherWardStealable() return true end

function imba_scaldris_scorch:GetAbilityTextureName()
	return "custom/scaldris_scorch"
end

function imba_scaldris_scorch:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_scorch:GetAssociatedSecondaryAbilities()
	return "imba_scaldris_freeze"
end

function imba_scaldris_scorch:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_freeze") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_freeze")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_scorch:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local effect_radius = self:GetSpecialValueFor("effect_radius")

		-- Antipode visuals
		AntipodeColorChange(caster, true, false)

		-- Cast sound
		caster:EmitSound("Scaldris.Scorch")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_scorch", "imba_scaldris_freeze", false, true)

		-- Blast vision
		AddFOWViewer(caster:GetTeamNumber(), caster_loc, effect_radius, 3.0, false)

		-- Blast particle
		local scorch_pfx = ParticleManager:CreateParticle("particles/hero/scaldris/scorch.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(scorch_pfx, 0, caster_loc + Vector(0, 0, 25))
		ParticleManager:SetParticleControl(scorch_pfx, 1, Vector(effect_radius, 1, 1))
		Timers:CreateTimer(0.45, function()
			ParticleManager:DestroyParticle(scorch_pfx, false)
			ParticleManager:ReleaseParticleIndex(scorch_pfx)
		end)

		-- Apply blind and damage modifiers to nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_imba_scorch_blind", {duration = self:GetSpecialValueFor("blind_duration")})
			enemy:AddNewModifier(caster, self, "modifier_imba_scorch_dps", {duration = self:GetSpecialValueFor("duration"), dps = self:GetSpecialValueFor("dps")})
		end
	end
end

-- Scorch blind debuff
modifier_imba_scorch_blind = class({})

function modifier_imba_scorch_blind:IsDebuff() return true end
function modifier_imba_scorch_blind:IsHidden() return false end
function modifier_imba_scorch_blind:IsPurgable() return true end
function modifier_imba_scorch_blind:IsStunDebuff() return false end
function modifier_imba_scorch_blind:RemoveOnDeath() return true end

function modifier_imba_scorch_blind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
	return funcs
end

function modifier_imba_scorch_blind:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("blind_amount")
end

function modifier_imba_scorch_blind:GetEffectName()
	return "particles/hero/scaldris/scorch_blind.vpcf"
end

function modifier_imba_scorch_blind:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Scorch damage debuff
modifier_imba_scorch_dps = class({})

function modifier_imba_scorch_dps:IsDebuff() return true end
function modifier_imba_scorch_dps:IsHidden() return false end
function modifier_imba_scorch_dps:IsPurgable() return false end
function modifier_imba_scorch_dps:IsPurgeException() return true end
function modifier_imba_scorch_dps:IsStunDebuff() return false end
function modifier_imba_scorch_dps:RemoveOnDeath() return true end

function modifier_imba_scorch_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeFireProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_scorch_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_scorch_dps:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_imba_scorch_dps:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



-------------------------------------------
--				 Freeze
-------------------------------------------

imba_scaldris_freeze = class({})

LinkLuaModifier("modifier_imba_freeze_slow", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_freeze_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_freeze:IsHiddenWhenStolen() return true end
function imba_scaldris_freeze:IsRefreshable() return true end
function imba_scaldris_freeze:IsStealable() return true end
function imba_scaldris_freeze:IsNetherWardStealable() return true end

function imba_scaldris_freeze:GetAbilityTextureName()
	return "custom/scaldris_freeze"
end

function imba_scaldris_freeze:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_freeze:GetAssociatedPrimaryAbilities()
	return "imba_scaldris_scorch"
end

function imba_scaldris_freeze:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_scorch") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_scorch")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_freeze:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_loc = self:GetCursorPosition()

		-- Cursorcast fix
		if target_loc == caster_loc then
			target_loc = caster_loc + caster:GetForwardVector() * 100
		end

		local direction = (target_loc - caster_loc):Normalized()
		local initial_radius = self:GetSpecialValueFor("initial_radius")
		local final_radius = self:GetSpecialValueFor("final_radius")
		local wave_speed = self:GetSpecialValueFor("wave_speed")
		local wave_distance = self:GetSpecialValueFor("wave_distance") + GetCastRangeIncrease(caster)

		-- Antipode visuals
		AntipodeColorChange(caster, false, true)

		-- Cast sound
		caster:EmitSound("Scaldris.Freeze")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_scorch", "imba_scaldris_freeze", true, false)

		-- Create projectile
		local wave_projectile = {
			Ability				= self,
			EffectName			= "particles/hero/scaldris/freeze.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= wave_distance,
			fStartRadius		= initial_radius,
			fEndRadius			= final_radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * wave_speed,
			bProvidesVision		= false,
		}
		ProjectileManager:CreateLinearProjectile(wave_projectile)
	end
end

function imba_scaldris_freeze:OnProjectileHit(target, location)
	if IsServer() then
		if target then
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_freeze_slow", {duration = self:GetSpecialValueFor("slow_duration")})
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_freeze_dps", {duration = self:GetSpecialValueFor("damage_duration"), dps = self:GetSpecialValueFor("dps")})
		end
	end
end

-- Freeze slow debuff
modifier_imba_freeze_slow = class({})

function modifier_imba_freeze_slow:IsDebuff() return true end
function modifier_imba_freeze_slow:IsHidden() return false end
function modifier_imba_freeze_slow:IsPurgable() return true end
function modifier_imba_freeze_slow:IsStunDebuff() return false end
function modifier_imba_freeze_slow:RemoveOnDeath() return true end

function modifier_imba_freeze_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_imba_freeze_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow_amount")
end

function modifier_imba_freeze_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

-- Freeze damage debuff
modifier_imba_freeze_dps = class({})

function modifier_imba_freeze_dps:IsDebuff() return true end
function modifier_imba_freeze_dps:IsHidden() return false end
function modifier_imba_freeze_dps:IsPurgable() return false end
function modifier_imba_freeze_dps:IsPurgeException() return true end
function modifier_imba_freeze_dps:IsStunDebuff() return false end
function modifier_imba_freeze_dps:RemoveOnDeath() return true end

function modifier_imba_freeze_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeIceProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_freeze_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_freeze_dps:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end



-------------------------------------------
--				 Jet Blaze
-------------------------------------------

imba_scaldris_jet_blaze = class({})

LinkLuaModifier("modifier_imba_jet_blaze_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_jet_blaze_rush", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_jet_blaze:IsHiddenWhenStolen() return false end
function imba_scaldris_jet_blaze:IsRefreshable() return true end
function imba_scaldris_jet_blaze:IsStealable() return true end
function imba_scaldris_jet_blaze:IsNetherWardStealable() return true end

function imba_scaldris_jet_blaze:GetAbilityTextureName()
	return "custom/scaldris_jet_blaze"
end

function imba_scaldris_jet_blaze:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_jet_blaze:GetAssociatedSecondaryAbilities()
	return "imba_scaldris_ice_floes"
end

function imba_scaldris_jet_blaze:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_ice_floes") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_ice_floes")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_jet_blaze:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local direction =  caster:GetForwardVector()
		local initial_radius = self:GetSpecialValueFor("initial_radius")
		local final_radius = self:GetSpecialValueFor("final_radius")
		local cone_length = self:GetSpecialValueFor("cone_length")
		local fire_speed = self:GetSpecialValueFor("fire_speed")
		local rush_distance = self:GetSpecialValueFor("rush_distance") + GetCastRangeIncrease(caster)
		local rush_speed = rush_distance / self:GetSpecialValueFor("rush_duration")

		-- Antipode visuals
		AntipodeColorChange(caster, true, false)

		-- Cast sound
		caster:EmitSound("Hero_DragonKnight.BreathFire")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_jet_blaze", "imba_scaldris_ice_floes", false, true)

		-- Create projectiles
		local jet_projectile = {
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= cone_length,
			fStartRadius		= initial_radius,
			fEndRadius			= final_radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * (-1) * fire_speed,
			bProvidesVision		= false,
		}
		local rush_projectile = {
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= rush_distance,
			fStartRadius		= initial_radius,
			fEndRadius			= initial_radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * rush_speed,
			bProvidesVision		= false,
		}
		ProjectileManager:CreateLinearProjectile(jet_projectile)
		Timers:CreateTimer(0.1, function()
			ProjectileManager:CreateLinearProjectile(rush_projectile)
		end)

		-- Move the caster
		caster:AddNewModifier(caster, self, "modifier_imba_jet_blaze_rush", {duration = self:GetSpecialValueFor("rush_duration"), distance = rush_distance,})
	end
end

function imba_scaldris_jet_blaze:OnProjectileHit(target, location)
	if IsServer() then
		if target then
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_jet_blaze_dps", {duration = self:GetSpecialValueFor("damage_duration"), dps = self:GetSpecialValueFor("dps")})
		end
	end
end

-- Jet Blaze damage debuff
modifier_imba_jet_blaze_dps = class({})

function modifier_imba_jet_blaze_dps:IsDebuff() return true end
function modifier_imba_jet_blaze_dps:IsHidden() return false end
function modifier_imba_jet_blaze_dps:IsPurgable() return false end
function modifier_imba_jet_blaze_dps:IsPurgeException() return true end
function modifier_imba_jet_blaze_dps:IsStunDebuff() return false end
function modifier_imba_jet_blaze_dps:RemoveOnDeath() return true end

function modifier_imba_jet_blaze_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeFireProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_jet_blaze_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_jet_blaze_dps:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_imba_jet_blaze_dps:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Jet Blaze rush modifier
modifier_imba_jet_blaze_rush = class({})

function modifier_imba_jet_blaze_rush:IsDebuff() return false end
function modifier_imba_jet_blaze_rush:IsHidden() return true end
function modifier_imba_jet_blaze_rush:IsPurgable() return false end
function modifier_imba_jet_blaze_rush:IsStunDebuff() return false end
function modifier_imba_jet_blaze_rush:IsMotionController() return true end
function modifier_imba_jet_blaze_rush:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_jet_blaze_rush:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.03)
		self.direction = self:GetParent():GetForwardVector()
		self.movement_tick = self.direction * keys.distance / ( self:GetDuration() / 0.03 )
	end
end

function modifier_imba_jet_blaze_rush:GetEffectName() return "particles/hero/scaldris/jet_blaze.vpcf" end

function modifier_imba_jet_blaze_rush:OnDestroy()
	if IsServer() then
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
	end
end

function modifier_imba_jet_blaze_rush:OnIntervalThink()
	if IsServer() then
		-- Remove motion controller if conflicting with another
		if not self:CheckMotionControllers() then
			self:Destroy()
			return
		end

		-- Continue moving
		local unit = self:GetParent()
		local position = unit:GetAbsOrigin()
		GridNav:DestroyTreesAroundPoint(position, 100, false)
		unit:SetAbsOrigin(GetGroundPosition(position + self.movement_tick, unit))
	end
end



-------------------------------------------
--				 Ice Floes
-------------------------------------------

imba_scaldris_ice_floes = class({})

LinkLuaModifier("modifier_imba_ice_floes_stun", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_floes_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_ice_floes:IsHiddenWhenStolen() return true end
function imba_scaldris_ice_floes:IsRefreshable() return true end
function imba_scaldris_ice_floes:IsStealable() return true end
function imba_scaldris_ice_floes:IsNetherWardStealable() return true end

function imba_scaldris_ice_floes:GetAbilityTextureName()
	return "custom/scaldris_ice_floes"
end

function imba_scaldris_ice_floes:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_ice_floes:GetAssociatedPrimaryAbilities()
	return "imba_scaldris_jet_blaze"
end

function imba_scaldris_ice_floes:GetAOERadius()	 
	return self:GetSpecialValueFor("effect_radius")
end

function imba_scaldris_ice_floes:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_jet_blaze") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_jet_blaze")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_ice_floes:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_loc = self:GetCursorPosition()

		-- Cursorcast fix
		if target_loc == caster_loc then
			target_loc = caster_loc + caster:GetForwardVector() * 100
		end
		
		local direction = (target_loc - caster_loc):Normalized()
		local distance = (target_loc - caster_loc):Length2D()
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")

		-- Antipode visuals
		AntipodeColorChange(caster, false, true)

		-- Cast sound
		caster:EmitSound("Scaldris.ColdFrontLaunch")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_jet_blaze", "imba_scaldris_ice_floes", true, false)

		-- Create projectile
		local ice_projectile = {
			Ability				= self,
			EffectName			= "particles/hero/scaldris/ice_spell_projectile.vpcf",
			vSpawnOrigin		= caster_loc + Vector(0, 0, 100),
			fDistance			= distance,
			fStartRadius		= 0,
			fEndRadius			= 0,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= Vector(direction.x, direction.y, 0) * projectile_speed,
			bProvidesVision		= false,
			ExtraData			= {x = target_loc.x, y = target_loc.y}
		}
		ProjectileManager:CreateLinearProjectile(ice_projectile)
	end
end

function imba_scaldris_ice_floes:OnProjectileHit(target, location)
	if IsServer() then
	end
end

function imba_scaldris_ice_floes:OnProjectileThink_ExtraData(location, extra_data)
	if IsServer() then
		if (location - Vector(extra_data.x, extra_data.y, location.z)):Length2D() <= 16 then

			-- Teleport sound
			local caster = self:GetCaster()
			caster:EmitSound("Scaldris.IceFloes.Teleport")

			-- Teleport particle
			local teleport_pfx = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_marker_ti7_endpoint.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(teleport_pfx, 0, location)
			Timers:CreateTimer(1.5, function()
				ParticleManager:DestroyParticle(teleport_pfx, false)
				ParticleManager:ReleaseParticleIndex(teleport_pfx)
			end)

			-- Apply stun and damage modifiers to enemies in the path
			--local enemies = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), location, nil, self:GetSpecialValueFor("effect_radius") * 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, self:GetSpecialValueFor("effect_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, self, "modifier_imba_ice_floes_stun", {duration = self:GetSpecialValueFor("stun_duration")})
				enemy:AddNewModifier(caster, self, "modifier_imba_ice_floes_dps", {duration = self:GetSpecialValueFor("damage_duration"), dps = self:GetSpecialValueFor("dps")})
			end

			-- Move the caster
			ProjectileManager:ProjectileDodge(caster)
			FindClearSpaceForUnit(caster, location, true)
		end
	end
end

-- Ice Floes stun debuff
modifier_imba_ice_floes_stun = class({})

function modifier_imba_ice_floes_stun:IsDebuff() return true end
function modifier_imba_ice_floes_stun:IsHidden() return false end
function modifier_imba_ice_floes_stun:IsPurgable() return false end
function modifier_imba_ice_floes_stun:IsStunDebuff() return true end
function modifier_imba_ice_floes_stun:RemoveOnDeath() return true end

function modifier_imba_ice_floes_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function modifier_imba_ice_floes_stun:GetEffectName()
	return "particles/hero/lich/cold_front_freeze.vpcf"
end

function modifier_imba_ice_floes_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Ice Floes damage debuff
modifier_imba_ice_floes_dps = class({})

function modifier_imba_ice_floes_dps:IsDebuff() return true end
function modifier_imba_ice_floes_dps:IsHidden() return false end
function modifier_imba_ice_floes_dps:IsPurgable() return false end
function modifier_imba_ice_floes_dps:IsPurgeException() return true end
function modifier_imba_ice_floes_dps:IsStunDebuff() return false end
function modifier_imba_ice_floes_dps:RemoveOnDeath() return true end

function modifier_imba_ice_floes_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeIceProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_ice_floes_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
	end
end

function modifier_imba_ice_floes_dps:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end



-------------------------------------------
--				Living Flame
-------------------------------------------

imba_scaldris_living_flame = class({})

LinkLuaModifier("modifier_imba_living_flame_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_living_flame:IsHiddenWhenStolen() return false end
function imba_scaldris_living_flame:IsRefreshable() return true end
function imba_scaldris_living_flame:IsStealable() return true end
function imba_scaldris_living_flame:IsNetherWardStealable() return true end

function imba_scaldris_living_flame:GetAbilityTextureName()
	return "custom/scaldris_living_flame"
end

function imba_scaldris_living_flame:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_living_flame:GetAssociatedSecondaryAbilities()
	return "imba_scaldris_absolute_zero"
end

function imba_scaldris_living_flame:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_absolute_zero") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_absolute_zero")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_living_flame:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local jump_radius = self:GetSpecialValueFor("jump_radius")
		local duration = self:GetSpecialValueFor("duration")
		local dps = self:GetSpecialValueFor("dps")

		-- Antipode visuals
		AntipodeColorChange(caster, true, false)

		-- Cast sound
		caster:EmitSound("Scaldris.LivingFlame.Spread")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_living_flame", "imba_scaldris_absolute_zero", false, true)

		-- Play spread particle
		local spread_pfx = ParticleManager:CreateParticle("particles/hero/scaldris/living_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(spread_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(spread_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(spread_pfx)

		-- Apply the modifier
		target:AddNewModifier(caster, self, "modifier_imba_living_flame_dps", {duration = duration, jump_radius = jump_radius, dps = dps})
	end
end

-- Living Flame spread
function LivingFlameSpreadAttempt(modifier)
	local enemies = FindUnitsInRadius(modifier:GetCaster():GetTeamNumber(), modifier:GetParent():GetAbsOrigin(), nil, modifier.jump_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= modifier:GetParent() then

			-- Play spread particle/sound
			modifier:GetParent():EmitSound("Scaldris.LivingFlame.Spread")
			local spread_pfx = ParticleManager:CreateParticle("particles/hero/scaldris/living_flame.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControlEnt(spread_pfx, 0, modifier:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", modifier:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(spread_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(spread_pfx)

			-- Apply the modifier
			enemy:AddNewModifier(modifier:GetCaster(), modifier:GetAbility(), "modifier_imba_living_flame_dps", {duration = modifier:GetDuration(), jump_radius = modifier.jump_radius, dps = modifier.dps})
			break
		end
	end
end

-- Living Flame debuff
modifier_imba_living_flame_dps = class({})

function modifier_imba_living_flame_dps:IsDebuff() return true end
function modifier_imba_living_flame_dps:IsHidden() return false end
function modifier_imba_living_flame_dps:IsPurgable() return false end
function modifier_imba_living_flame_dps:IsPurgeException() return true end
function modifier_imba_living_flame_dps:IsStunDebuff() return false end
function modifier_imba_living_flame_dps:RemoveOnDeath() return true end

function modifier_imba_living_flame_dps:OnCreated(keys)
	if IsServer() then
		self.jump_radius = keys.jump_radius
		self.dps = keys.dps
		AntipodeFireProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_living_flame_dps:DeclareFunctions()
	if IsServer() then
		local funcs = {
			MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			MODIFIER_EVENT_ON_DEATH
		}
		return funcs
	end
end

function modifier_imba_living_flame_dps:GetModifierProvidesFOWVision()
	return 1
end

function modifier_imba_living_flame_dps:OnDeath(keys)
	if IsServer() then
		if self:GetParent() == keys.unit then
			LivingFlameSpreadAttempt(self)
		end
	end
end

function modifier_imba_living_flame_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
		self:GetParent():EmitSound("Scaldris.FireTick")
	end
end

function modifier_imba_living_flame_dps:GetEffectName()
	return "particles/hero/scaldris/living_flame_debuff.vpcf"
end

function modifier_imba_living_flame_dps:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



-------------------------------------------
--				Absolute Zero
-------------------------------------------

imba_scaldris_absolute_zero = class({})

LinkLuaModifier("modifier_imba_absolute_zero_stun", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_absolute_zero_slow", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_absolute_zero_dps", "components/abilities/heroes/hero_scaldris", LUA_MODIFIER_MOTION_NONE)

function imba_scaldris_absolute_zero:IsHiddenWhenStolen() return true end
function imba_scaldris_absolute_zero:IsRefreshable() return true end
function imba_scaldris_absolute_zero:IsStealable() return true end
function imba_scaldris_absolute_zero:IsNetherWardStealable() return true end

function imba_scaldris_absolute_zero:GetAbilityTextureName()
	return "custom/scaldris_absolute_zero"
end

function imba_scaldris_absolute_zero:GetIntrinsicModifierName()
	return "modifier_imba_antipode_passive"
end

function imba_scaldris_absolute_zero:GetAssociatedPrimaryAbilities()
	return "imba_scaldris_living_flame"
end

function imba_scaldris_absolute_zero:OnUpgrade()
	if IsServer() then
		if self:GetCaster():FindAbilityByName("imba_scaldris_living_flame") then
			local paired_ability = self:GetCaster():FindAbilityByName("imba_scaldris_living_flame")
			if paired_ability:GetLevel() < self:GetLevel() then
				paired_ability:SetLevel(self:GetLevel())
			end
		end
	end
end

function imba_scaldris_absolute_zero:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local initial_slow = self:GetSpecialValueFor("initial_slow")
		local damage_duration = self:GetSpecialValueFor("damage_duration")
		local dps = self:GetSpecialValueFor("dps")

		-- Antipode visuals
		AntipodeColorChange(caster, false, true)

		-- Cast sound
		caster:EmitSound("Scaldris.ColdFrontLaunch")

		-- Swap fire/ice abilities
		caster:SwapAbilities("imba_scaldris_living_flame", "imba_scaldris_absolute_zero", true, false)

		-- Launch the projectile
		local ice_projectile = {
			Target 				= target,
			Source 				= caster,
			Ability 			= self,
			EffectName 			= "particles/hero/scaldris/ice_spell_projectile_tracking.vpcf",
			iMoveSpeed			= projectile_speed,
			vSpawnOrigin 		= caster:GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= false,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 30,
			bProvidesVision 	= true,
			iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
			iVisionRadius 		= 150,
			iVisionTeamNumber 	= caster:GetTeamNumber()
		}
		ProjectileManager:CreateTrackingProjectile(ice_projectile)
	end
end

function imba_scaldris_absolute_zero:OnProjectileHit(target, location)
	if IsServer() then
		if target then
			target:EmitSound("Scaldris.AbsoluteZero.Impact")
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_absolute_zero_stun", {duration = self:GetSpecialValueFor("stun_duration"), initial_slow = self:GetSpecialValueFor("initial_slow")})
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_absolute_zero_dps", {duration = self:GetSpecialValueFor("damage_duration"), dps = self:GetSpecialValueFor("dps")})
		end
	end
end

-- Absolute Zero stun debuff
modifier_imba_absolute_zero_stun = class({})

function modifier_imba_absolute_zero_stun:IsDebuff() return true end
function modifier_imba_absolute_zero_stun:IsHidden() return false end
function modifier_imba_absolute_zero_stun:IsPurgable() return false end
function modifier_imba_absolute_zero_stun:IsStunDebuff() return true end
function modifier_imba_absolute_zero_stun:RemoveOnDeath() return true end

function modifier_imba_absolute_zero_stun:OnCreated(keys)
	if IsServer() then
		self.initial_slow = keys.initial_slow
	end
end

function modifier_imba_absolute_zero_stun:OnDestroy()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_absolute_zero_slow", {initial_slow = self.initial_slow})
	end
end

function modifier_imba_absolute_zero_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function modifier_imba_absolute_zero_stun:GetEffectName()
	return "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse.vpcf"
end

function modifier_imba_absolute_zero_stun:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- Absolute Zero slow debuff
modifier_imba_absolute_zero_slow = class({})

function modifier_imba_absolute_zero_slow:IsDebuff() return true end
function modifier_imba_absolute_zero_slow:IsHidden() return false end
function modifier_imba_absolute_zero_slow:IsPurgable() return true end
function modifier_imba_absolute_zero_slow:IsStunDebuff() return false end
function modifier_imba_absolute_zero_slow:RemoveOnDeath() return true end

function modifier_imba_absolute_zero_slow:OnCreated(keys)
	if IsServer() then
		self:SetStackCount((-1) * keys.initial_slow)
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_absolute_zero_slow:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() - 1)
		if self:GetStackCount() <= 0 then
			self:GetParent():RemoveModifierByName("modifier_imba_absolute_zero_slow")
		end
	end
end

function modifier_imba_absolute_zero_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	return funcs
end

function modifier_imba_absolute_zero_slow:GetModifierMoveSpeedBonus_Percentage()
	return (-1) * self:GetStackCount()
end

function modifier_imba_absolute_zero_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

-- Absolute Zero damage debuff
modifier_imba_absolute_zero_dps = class({})

function modifier_imba_absolute_zero_dps:IsDebuff() return true end
function modifier_imba_absolute_zero_dps:IsHidden() return false end
function modifier_imba_absolute_zero_dps:IsPurgable() return false end
function modifier_imba_absolute_zero_dps:IsPurgeException() return true end
function modifier_imba_absolute_zero_dps:IsStunDebuff() return false end
function modifier_imba_absolute_zero_dps:RemoveOnDeath() return true end

function modifier_imba_absolute_zero_dps:OnCreated(keys)
	if IsServer() then
		self.dps = keys.dps
		AntipodeIceProc(self:GetCaster(), self:GetParent())
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_absolute_zero_dps:OnIntervalThink()
	if IsServer() then
		local actual_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.dps, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), actual_damage, nil)
		self:GetParent():EmitSound("Scaldris.IceTick")
	end
end

function modifier_imba_absolute_zero_dps:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end
