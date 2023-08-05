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
--     Broccoli, 02.04.2017

local LinkedModifiers = {}

-- Yet Another ShallowCopy Copy...ironic
local function ShallowCopy(orig)
	local copy = {}
	for orig_key, orig_value in pairs(orig) do
		copy[orig_key] = orig_value
	end
	return copy
end

local function getOverChannelDamageIncrease(caster)
	if caster:HasModifier("modifier_over_channel_handler") then
		local over_channel = caster:FindAbilityByName("imba_abaddon_over_channel")
		if over_channel then
			-- #6 Talent: +50% Overchannel power
			return over_channel:GetSpecialValueFor("extra_dmg") *
				(1 + caster:FindTalentValue("special_bonus_imba_abaddon_6"))
		end
	end

	return 0
end

local function getOverChannelMistIncrease(caster)
	if caster:HasModifier("modifier_over_channel_handler") then
		local over_channel = caster:FindAbilityByName("imba_abaddon_over_channel")
		if over_channel then
			local ability_level = over_channel:GetLevel() - 1
			-- #6 Talent: +50% Overchannel power
			return over_channel:GetSpecialValueFor("extra_mist_duration") *
				(1 + caster:FindTalentValue("special_bonus_imba_abaddon_6"))
		end
	end

	return 0
end

local function getOverChannelShieldIncrease(caster)
	if caster:HasModifier("modifier_over_channel_handler") then
		local over_channel = caster:FindAbilityByName("imba_abaddon_over_channel")
		if over_channel then
			local ability_level = over_channel:GetLevel() - 1
			-- #6 Talent: +50% Overchannel power
			return over_channel:GetSpecialValueFor("extra_dmg") *
				(1 + caster:FindTalentValue("special_bonus_imba_abaddon_6")) --+ over_channel:GetLevelSpecialValueFor( "extra_shield_health" , ability_level )
		end
	end

	return 0
end

-----------------------------
--		Mist Coil          --
-----------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_mist_coil_passive"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_mist_coil_mist_ally"] = LUA_MODIFIER_MOTION_NONE,
})

imba_abaddon_death_coil = imba_abaddon_death_coil or class(VANILLA_ABILITIES_BASECLASS)

function imba_abaddon_death_coil:GetIntrinsicModifierName()
	return "modifier_imba_mist_coil_passive"
end

function imba_abaddon_death_coil:IsHiddenWhenStolen()
	return false
end

function imba_abaddon_death_coil:OnSpellStart(unit, special_cast)
	if IsServer() then
		local caster = self:GetCaster()
		local target = unit or self:GetCursorTarget()

		caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")

		-- If caster is alive
		if not special_cast then
			local responses = { "abaddon_abad_deathcoil_01", "abaddon_abad_deathcoil_02", "abaddon_abad_deathcoil_06",
				"abaddon_abad_deathcoil_08", }
			caster:EmitCasterSound("npc_dota_hero_abaddon", responses, 25, DOTA_CAST_SOUND_FLAG_NONE, 20, "coil")

			local health_cost = self:GetVanillaAbilitySpecial("self_damage")

			if getOverChannelDamageIncrease then
				ApplyDamage({
					victim = caster,
					attacker = caster,
					ability = self,
					damage = getOverChannelDamageIncrease(caster),
					damage_type = DAMAGE_TYPE_PURE,
					damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL
				})
			end

			ApplyDamage({
				victim = caster,
				attacker = caster,
				ability = self,
				damage = health_cost,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
			})
		end

		-- Use up overchannel
		if not special_cast then
			self.overchannel_damage_increase = getOverChannelDamageIncrease(caster)
			self.overchannel_mist_increase   = getOverChannelMistIncrease(caster)
		else
			self.overchannel_damage_increase = 0
			self.overchannel_mist_increase   = 0
		end

		-- Create the projectile
		local info = {
			Target = target,
			Source = caster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
			bDodgeable = false,
			bProvidesVision = true,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			iMoveSpeed = self:GetVanillaAbilitySpecial("missile_speed"),
			iVisionRadius = 0,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData = { special_cast = special_cast }
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

function imba_abaddon_death_coil:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsServer() then
		local caster = self:GetCaster()
		local target = hTarget
		local ability_level = self:GetLevel() - 1
		local special_cast = ExtraData.special_cast or false

		target:EmitSound("Hero_Abaddon.DeathCoil.Target")
		local mist_duration = self:GetSpecialValueFor("mist_duration")

		if not special_cast then
			mist_duration = mist_duration + self.overchannel_mist_increase
		end

		if not self.overchannel_damage_increase then return end

		if target:GetTeam() ~= caster:GetTeam() then
			-- If target has Linken Sphere, block effect entirely
			if target:TriggerSpellAbsorb(self) then
				return nil
			end

			local damage = self:GetVanillaAbilitySpecial("target_damage") + self.overchannel_damage_increase
			local damage_type = DAMAGE_TYPE_MAGICAL

			-- Apply damage + parsing if the ability killed the target
			local dealt_damage = ApplyDamage({
				victim = target,
				attacker = caster,
				damage = damage,
				damage_type = damage_type
			})
			if caster:HasModifier(self:GetIntrinsicModifierName()) then
				caster:FindModifierByName(self:GetIntrinsicModifierName()).applied_damage = dealt_damage
			end
			-- Apply curse of avernus debuff
			local curse_of_avernus = caster:FindAbilityByName("imba_abaddon_frostmourne")

			if curse_of_avernus then
				local debuff_duration = curse_of_avernus:GetVanillaAbilitySpecial("slow_duration")

				-- debuff_duration can be 0 if caster has ability but not learnt it yet
				if debuff_duration > 0 and not caster:PassivesDisabled() then
					target:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff_counter",
						{ duration = debuff_duration * (1 - target:GetStatusResistance()) })
				end
			end
		else
			--Apply spellpower to heal
			-- local heal_amp = 1 + (caster:GetSpellAmplification(false) / 100)

			local heal = (self:GetVanillaAbilitySpecial("heal_amount") + self.overchannel_damage_increase) -- * heal_amp

			-- heal allies or self and apply mist
			target:Heal(heal, caster)
			target:AddNewModifier(caster, self, "modifier_imba_mist_coil_mist_ally", { duration = mist_duration })
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, heal, nil)

			-- Refresh health and extend duration of Aphotic Shield
			local shield_modifier = target:FindModifierByName("modifier_imba_aphotic_shield_buff_block")
			if shield_modifier and shield_modifier.ResetAndExtendBy then
				shield_modifier:ResetAndExtendBy(self:GetSpecialValueFor("shield_duration_extend"))
			end
		end

		-- Extra effect if coil was casted with over channel
		if not special_cast and caster:HasModifier("modifier_over_channel_handler") then
			local over_channel_particle = ParticleManager:CreateParticle(
				"particles/dev/library/base_dust_hit_detail.vpcf", PATTACH_POINT, target)
			ParticleManager:ReleaseParticleIndex(over_channel_particle)

			over_channel_particle = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_smoke.vpcf",
				PATTACH_POINT, target)
			ParticleManager:ReleaseParticleIndex(over_channel_particle)
		end

		-- Cast response
		if not special_cast and caster:GetName() == "npc_dota_hero_abaddon" then
			Timers:CreateTimer(0.4, function()
				if self.killed then
					local responses = { "abaddon_abad_deathcoil_03", "abaddon_abad_deathcoil_07",
						"abaddon_abad_deathcoil_04", "abaddon_abad_deathcoil_05", "abaddon_abad_deathcoil_09",
						"abaddon_abad_deathcoil_10" }
					caster:EmitCasterSound("npc_dota_hero_abaddon", responses, 25, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil,
						nil)
					self.killed = nil
				end
			end)
		end
	end
end

function imba_abaddon_death_coil:OnOwnerDied()
	if self:GetCaster():IsRealHero() then
		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil,
			self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()), DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			if unit ~= self:GetCaster() then
				self:OnSpellStart(unit, true)
			end
		end
	end
end

modifier_imba_mist_coil_passive = modifier_imba_mist_coil_passive or class({})
function modifier_imba_mist_coil_passive:IsDebuff() return false end

function modifier_imba_mist_coil_passive:IsHidden() return true end

function modifier_imba_mist_coil_passive:IsPurgable() return false end

function modifier_imba_mist_coil_passive:IsPurgeException() return false end

function modifier_imba_mist_coil_passive:IsStunDebuff() return false end

function modifier_imba_mist_coil_passive:RemoveOnDeath() return false end

-------------------------------------------
function modifier_imba_mist_coil_passive:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return decFuns
end

function modifier_imba_mist_coil_passive:OnDeath(keys)
	if self.applied_damage then
		if keys.attacker == self:GetParent() then
			if self.record then
				if self.record == keys.record then
					local ability = self:GetAbility()
					if ability then
						ability.killed = true
					end
				end
			end
		end
	end
end

function modifier_imba_mist_coil_passive:OnTakeDamage(keys)
	if self.applied_damage then
		if keys.attacker == self:GetParent() then
			if keys.damage == self.applied_damage then
				self.record = keys.record
			end
		end
	end
end

modifier_imba_mist_coil_mist_ally = modifier_imba_mist_coil_mist_ally or class({})
function modifier_imba_mist_coil_mist_ally:IsDebuff() return false end

function modifier_imba_mist_coil_mist_ally:IsHidden() return false end

function modifier_imba_mist_coil_mist_ally:IsPurgable() return true end

function modifier_imba_mist_coil_mist_ally:RemoveOnDeath() return true end

---------------------------------------------

function modifier_imba_mist_coil_mist_ally:OnCreated(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.damage_heal_pct = self:GetAbility():GetSpecialValueFor("damage_heal_pct") / 100
end

function modifier_imba_mist_coil_mist_ally:OnRefresh()
	self:OnCreated()
end

function modifier_imba_mist_coil_mist_ally:OnDestroy(keys)
	if not self:GetAbility() then return end

	if IsServer() and self:GetParent():IsAlive() then
		self:GetParent():Heal(self:GetStackCount(), self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetStackCount(), nil)
	end
end

function modifier_imba_mist_coil_mist_ally:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_imba_mist_coil_mist_ally:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		self:SetStackCount(self:GetStackCount() + math.floor(keys.damage * self.damage_heal_pct))
	end
end

-----------------------------
--	   Aphotic Shield      --
-----------------------------

-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_aphotic_shield_buff_block"] = LUA_MODIFIER_MOTION_NONE,
})

imba_abaddon_aphotic_shield = imba_abaddon_aphotic_shield or class(VANILLA_ABILITIES_BASECLASS)

function imba_abaddon_aphotic_shield:IsHiddenWhenStolen() return false end

function imba_abaddon_aphotic_shield:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Play Sound
		caster:EmitSound("Hero_Abaddon.AphoticShield.Cast")
		local responses = { "abaddon_abad_aphoticshield_01", "abaddon_abad_aphoticshield_02",
			"abaddon_abad_aphoticshield_03", "abaddon_abad_aphoticshield_04", "abaddon_abad_aphoticshield_05",
			"abaddon_abad_aphoticshield_06", "abaddon_abad_aphoticshield_07" }
		caster:EmitCasterSound("npc_dota_hero_abaddon", responses, 50, DOTA_CAST_SOUND_FLAG_NONE, 20, "aphotic_shield")

		-- Check health cost required due to over channel
		local health_cost = getOverChannelDamageIncrease(caster)
		if health_cost > 0 then
			ApplyDamage({
				victim = caster,
				attacker = caster,
				ability = self,
				damage = health_cost,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL
			})
		end

		-- Strong Dispel
		target:Purge(false, true, false, true, true)

		local modifier_name_aphotic_shield = "modifier_imba_aphotic_shield_buff_block"

		-- Remove previous aphotic shield
		-- Did not use RemoveModifierByNameAndCaster because it will not destroy the shield if it was stolen by rubick from another rubick who stole from abaddon
		target:RemoveModifierByName(modifier_name_aphotic_shield)

		local duration = self:GetVanillaAbilitySpecial("duration")
		-- Add new modifier
		target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
	end
end

modifier_imba_aphotic_shield_buff_block = modifier_imba_aphotic_shield_buff_block or class({
	IsHidden   = function(self) return false end,
	IsPurgable = function(self) return true end,
	IsDebuff   = function(self) return false end
})

function modifier_imba_aphotic_shield_buff_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_imba_aphotic_shield_buff_block:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"

		self.shield_init_value = ability:GetVanillaAbilitySpecial("damage_absorb") + getOverChannelShieldIncrease(caster)
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()

		-- Talent : During the first second of Aphotic Shield, it absorbs all damage done to it and adds it to it's health/damage
		if caster:HasTalent("special_bonus_imba_abaddon_3") then
			self.has_talent = true
			-- GetGameTime and invulnerability_period are defined in seconds
			self.damage_absorption_end = GameRules:GetGameTime() + caster:FindTalentValue("special_bonus_imba_abaddon_3")
			self.invulnerability_expired = false
		end

		local particle = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size, 0, shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size, 0, 0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin,
			true)
		self:AddParticle(particle, false, false, -1, false, false)

		-- Extra effect if shield was casted with over channel
		if caster:HasModifier("modifier_over_channel_handler") then
			local over_channel_particle = ParticleManager:CreateParticle(
				"particles/econ/courier/courier_baekho/courier_baekho_ambient_vapor.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(over_channel_particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc,
				target_origin, true)
			self:AddParticle(over_channel_particle, false, false, -1, false, false)

			over_channel_particle = ParticleManager:CreateParticle(
				"particles/econ/courier/courier_baekho/courier_baekho_ambient_swirl.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(over_channel_particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc,
				target_origin, true)
			self:AddParticle(over_channel_particle, false, false, -1, false, false)
		end
	end
end

function modifier_imba_aphotic_shield_buff_block:OnDestroy()
	if IsServer() then
		local target              = self:GetParent()
		local caster              = self:GetCaster()
		local ability             = self:GetAbility()
		local ability_level       = ability:GetLevel()
		local radius              = ability:GetVanillaAbilitySpecial("radius")
		local explode_target_team = DOTA_UNIT_TARGET_TEAM_BOTH
		local explode_target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector       = target:GetAbsOrigin()

		target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		-- Explosion particle is shown by default when the particle is to be removed, however that does not work for illusions. Hence this added explosion is to make the particle show when illusions die
		local particle = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector)
		ParticleManager:ReleaseParticleIndex(particle)

		local units            = FindUnitsInRadius(caster:GetTeamNumber(), target_vector, nil, radius,
			explode_target_team, explode_target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Deal damage to enemies around
		local damage           = self.shield_init_value
		local damage_type      = DAMAGE_TYPE_MAGICAL
		local curse_of_avernus = caster:FindAbilityByName("imba_abaddon_frostmourne")

		local debuff_duration
		if curse_of_avernus then
			debuff_duration = curse_of_avernus:GetVanillaAbilitySpecial("slow_duration")
		end

		-- Talent : When Aphotic Shield is destroyed, cast Mist Coil in 425 AoE
		local mist_coil_ability
		local mist_coil_range
		if caster:HasTalent("special_bonus_imba_abaddon_1") then
			mist_coil_ability = caster:FindAbilityByName("imba_abaddon_death_coil")
			if mist_coil_ability then
				mist_coil_range = caster:FindTalentValue("special_bonus_imba_abaddon_1")
			end
		end

		for _, unit in pairs(units) do
			if unit:GetTeam() ~= caster:GetTeam() then
				ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = damage_type })

				if debuff_duration and debuff_duration > 0 then
					if not caster:PassivesDisabled() and curse_of_avernus then
						unit:AddNewModifier(caster, curse_of_avernus, "modifier_imba_curse_of_avernus_debuff_counter",
							{ duration = debuff_duration * (1 - unit:GetStatusResistance()) })
					end

					-- Show particle when hit
					particle = ParticleManager:CreateParticle(
						"particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf", PATTACH_POINT, unit)
					ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT, "attach_hitloc",
						unit:GetAbsOrigin(), true)
					local hit_size = unit:GetModelRadius() * 0.3
					ParticleManager:SetParticleControl(particle, 1, Vector(hit_size, hit_size, hit_size))
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end
			-- Talent Mist Coil stuff. Hopefully, just passing it the ability + making the projectile is enough without any
			-- skill-copy/dummy-unit stuff
			if mist_coil_ability and CalculateDistance(target, unit) < mist_coil_range then
				local info = {
					Target = unit,
					Source = target,
					Ability = mist_coil_ability,
					EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
					bDodgeable = false,
					bProvidesVision = true,
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					iMoveSpeed = mist_coil_ability:GetVanillaAbilitySpecial("missile_speed"),
					iVisionRadius = 0,
					iVisionTeamNumber = caster:GetTeamNumber(),
					ExtraData = { special_cast = true }
				}
				ProjectileManager:CreateTrackingProjectile(info)
			end
		end
	end
end

--Block damage
function modifier_imba_aphotic_shield_buff_block:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target                 = self:GetParent()
		local original_shield_amount = self.shield_remaining
		local shield_hit_particle    = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
		-- Avoid blocking when borrowed time is active						--No need for block when there is no damage
		if not target:HasModifier("modifier_imba_borrowed_time_buff_hot_caster") and kv.damage > 0 and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
			if self.has_talent and not self.invulnerability_expired then
				-- damage_absorbtion_end is calculated in OnCreated
				if GameRules:GetGameTime() <= self.damage_absorption_end then
					self.shield_remaining = self.shield_remaining + kv.damage
					original_shield_amount = self.shield_remaining
					-- Increase the max capacity. The if check is just for sanity
					if self.shield_remaining > self.shield_init_value then
						self.shield_init_value = self.shield_remaining
					end
				else
					-- copy-paste of code, but that allows skipping on GetGameTime calls in the if
					self.shield_remaining = self.shield_remaining - kv.damage
					self.invulnerability_expired = true
				end
			else
				--Reduce the amount of shield remaining
				self.shield_remaining = self.shield_remaining - kv.damage
			end


			--If there is enough shield to block everything, then block everything.
			if kv.damage < original_shield_amount then
				--Emit damage blocking effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
				return kv.damage
				--Else, reduce what you can and blow up the shield
			else
				--Emit damage block effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end
		end
	end
end

function modifier_imba_aphotic_shield_buff_block:ResetAndExtendBy(seconds)
	self.shield_remaining = self.shield_init_value
	self:SetDuration(self:GetRemainingTime() + seconds, true)
end

-----------------------------
--     Curse Of Avernus    --
-----------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_curse_of_avernus_debuff_counter"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_curse_of_avernus_debuff_slow"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_curse_of_avernus_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_curse_of_avernus_buff_haste_aura"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_curse_of_avernus_passive"] = LUA_MODIFIER_MOTION_NONE,
})

imba_abaddon_frostmourne = imba_abaddon_frostmourne or class(VANILLA_ABILITIES_BASECLASS)

function imba_abaddon_frostmourne:GetIntrinsicModifierName()
	return "modifier_imba_curse_of_avernus_passive"
end

function imba_abaddon_frostmourne:OnCreated()
	self.curse_of_avernus_target = nil
end

function imba_abaddon_frostmourne:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_abaddon_4") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end

	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function imba_abaddon_frostmourne:OnOwnerSpawned()
	if not IsServer() then return end
	self:EndCooldown()
	--[[
	if self:GetCaster():HasAbility("special_bonus_imba_abaddon_2") and self:GetCaster():FindAbilityByName("special_bonus_imba_abaddon_2"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_abaddon_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_abaddon_2", {})
	end
	
	if self:GetCaster():HasAbility("special_bonus_imba_abaddon_4") and self:GetCaster():FindAbilityByName("special_bonus_imba_abaddon_4"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_abaddon_4") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_abaddon_4", {})
	end
--]]
end

function imba_abaddon_frostmourne:GetCooldown()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_4", "active_cooldown")
	end

	return 0
end

function imba_abaddon_frostmourne:GetCastRange()
	return self:GetCaster():Script_GetAttackRange()
end

--[[
function imba_abaddon_frostmourne:OnSpellStart()
	if IsServer() then
		self.curse_of_avernus_target = self:GetCursorTarget()
		self:GetCaster():MoveToTargetToAttack(self.curse_of_avernus_target)
		self:EndCooldown() --we enter cooldown OnAttack
	end
end
--]]
modifier_imba_curse_of_avernus_passive = modifier_imba_curse_of_avernus_passive or class({
	IsHidden               = function(self) return true end,
	IsPurgable             = function(self) return false end,
	IsDebuff               = function(self) return false end,
	AllowIllusionDuplicate = function(self) return false end,
	--	IsAuraActiveOnDeath		= function(self) return false end,
	--	GetModifierAura			= function(self) return "modifier_imba_curse_of_avernus_buff_haste_aura" end,
	--	GetAuraSearchType		= function(self) return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end,
	--	GetAuraSearchTeam		= function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
})

function modifier_imba_curse_of_avernus_passive:RemoveOnDeath() return false end

function modifier_imba_curse_of_avernus_passive:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsServer() then
		local target = self:GetParent()

		if target:IsIllusion() then
			self:Destroy()
		end
	end
end

--[[
function modifier_imba_curse_of_avernus_passive:IsAura()
	if self.caster:HasTalent("special_bonus_imba_abaddon_5") and not self.caster:PassivesDisabled() then
		return true
	end

	return false
end
--]]
function modifier_imba_curse_of_avernus_passive:GetAuraRadius()
	return self.caster:FindTalentValue("special_bonus_imba_abaddon_5")
end

function modifier_imba_curse_of_avernus_passive:GetAuraEntityReject(hEntity)
	if hEntity:HasModifier("modifier_imba_curse_of_avernus_buff_haste") then
		return true
	end

	return false
end

function modifier_imba_curse_of_avernus_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_ORDER,
	}

	return funcs
end

function modifier_imba_curse_of_avernus_passive:OnAttack(kv)
	if IsServer() then
		-- Do not apply curse if avernus if "break"
		if not self:GetCaster():PassivesDisabled() then
			local attacker = kv.attacker

			if attacker == self:GetCaster() then
				local target = kv.target

				-- Apply curse of avernus to enemies
				if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not target:HasModifier("modifier_imba_curse_of_avernus_debuff_slow") then
					-- remove attack speed buff if attacking a target who's not cursed
					if self:GetCaster():HasModifier("modifier_imba_curse_of_avernus_buff_haste") then
						self:GetCaster():RemoveModifierByName("modifier_imba_curse_of_avernus_buff_haste")
					end

					-- Apply debuff if enemy
					if self:GetAbility() then
						local slow_duration = self:GetAbility():GetVanillaAbilitySpecial("slow_duration") -- Not possible for this to be 0 here
						target:AddNewModifier(self:GetCaster(), self:GetAbility(),
							"modifier_imba_curse_of_avernus_debuff_counter",
							{ duration = slow_duration * (1 - target:GetStatusResistance()) })
					end
				end
			end
		end

		--[[
		-- Smiting of Avernus talent
		if kv.attacker == self:GetCaster() and self.ability:IsCooldownReady() and ( self.ability.curse_of_avernus_target or self.ability:GetAutoCastState() ) then
			local health_lost = self:GetCaster():GetMaxHealth() * self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_4", "health_cost_pct") / 100

			local over_channel_modifier = self:GetCaster():FindModifierByName("modifier_over_channel_handler")
			if over_channel_modifier then
				-- if we have overchannel, double the health lost and damage (+50% Overchannel strength also applies multiplicatively, for maximum lols)
				health_lost = health_lost * over_channel_modifier:GetAbility():GetSpecialValueFor("curse_of_avernus_multiplier") * (1 + self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_6"))
			end

			self.damage = health_lost * self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_4", "health_to_damage_ratio")
			self.ability.curse_of_avernus_target = kv.target
			
			ApplyDamage({ victim = self:GetCaster(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL})
			
			-- Start cooldown
			self.ability:UseResources(false, false, false, true)
		end
--]]
	end
end

function modifier_imba_curse_of_avernus_passive:OnOrder(kv)
	local order_type = kv.order_type

	if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.ability.curse_of_avernus_target = nil
	end
end

function modifier_imba_curse_of_avernus_passive:OnAttackFail(kv)
	if self:GetParent() == kv.attacker then
		self.ability.curse_of_avernus_target = nil
	end
end

function modifier_imba_curse_of_avernus_passive:OnAttackLanded(kv)
	if self:GetParent() == kv.attacker then
		self.ability.curse_of_avernus_target = nil
	end
end

function modifier_imba_curse_of_avernus_passive:GetModifierProcAttack_BonusDamage_Physical(kv)
	if kv.attacker == self:GetCaster() and self.ability.curse_of_avernus_target == kv.target then
		return self.damage
	end

	return 0
end

modifier_imba_curse_of_avernus_debuff_counter = modifier_imba_curse_of_avernus_debuff_counter or class({})

function modifier_imba_curse_of_avernus_debuff_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_imba_curse_of_avernus_debuff_counter:OnCreated(kv)
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_abaddon_2") then
		self.has_talent = true
		self.duration_extend = self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_2", "extend_duration")
		self.hits = 0
		self.base_duration = kv.duration
	end

	self:SetStackCount(1)
end

function modifier_imba_curse_of_avernus_debuff_counter:OnRefresh(kv)
	if not IsServer() then return end

	self:IncrementStackCount()

	if self:GetStackCount() >= self:GetAbility():GetVanillaAbilitySpecial("hit_count") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_curse_of_avernus_debuff_slow",
			{ duration = self:GetAbility():GetVanillaAbilitySpecial("curse_duration") })
		self:GetParent():RemoveModifierByName("modifier_imba_curse_of_avernus_debuff_counter")
		local responses = { "abaddon_abad_frostmourne_01", "abaddon_abad_frostmourne_02", "abaddon_abad_frostmourne_03",
			"abaddon_abad_frostmourne_04", "abaddon_abad_frostmourne_05", "abaddon_abad_frostmourne_06",
			"abaddon_abad_frostmourne_06" }
		self:GetCaster():EmitCasterSound("npc_dota_hero_abaddon", responses, 50, DOTA_CAST_SOUND_FLAG_NONE, 30,
			"curse_of_avernus")
		self:GetCaster():EmitSound("Hero_Abaddon.Curse.Proc")
	end
end

function modifier_imba_curse_of_avernus_debuff_counter:OnStackCountChanged(iStackCount)
	if not IsServer() then return end

	if not self.pfx then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf",
			PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end

	ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end

function modifier_imba_curse_of_avernus_debuff_counter:OnRemoved()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function modifier_imba_curse_of_avernus_debuff_counter:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility()
		:GetVanillaAbilitySpecial("movement_speed") * (-1)
end

modifier_imba_curse_of_avernus_debuff_slow = modifier_imba_curse_of_avernus_debuff_slow or class({
	IsHidden            = function(self) return false end,
	IsPurgable          = function(self) return true end,
	IsDebuff            = function(self) return true end,
	GetEffectName       = function(self)
		return
		"particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf"
	end,
	GetEffectAttachType = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_curse_of_avernus_debuff_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_imba_curse_of_avernus_debuff_slow:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_imba_curse_of_avernus_debuff_slow:OnCreated(kv)
	if IsServer() then
		-- Give caster the buff immediately, else caster has to hit the target again to gain the buff
		local buff_name = "modifier_imba_curse_of_avernus_buff_haste"
		local current_buff = self:GetCaster():FindModifierByName(buff_name)

		if self:GetCaster():HasTalent("special_bonus_imba_abaddon_2") then
			self.has_talent = true
			self.duration_extend = self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_2", "extend_duration")
			self.hits = 0
			self.base_duration = kv.duration
		end

		if not current_buff then
			local buff_duration = self:GetAbility():GetVanillaAbilitySpecial("slow_duration") -- Not possible for this to be 0 here
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), buff_name, { duration = buff_duration })
		else
			current_buff:ForceRefresh()
		end

		self.heal_convert = (self:GetAbility():GetSpecialValueFor("heal_convert") / 100)
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnRefresh(kv)
	if self.has_talent then
		self:SetDuration(self.base_duration + self.hits * self.duration_extend, true)
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnAttack(kv)
	if IsServer() then
		local target = kv.target

		-- Apply buff to allies who hit the enemy with this debuff
		if target == self:GetParent() then
			local caster   = self:GetCaster()
			local attacker = kv.attacker

			if caster:GetTeamNumber() == attacker:GetTeamNumber() then
				local ability = self:GetAbility()
				local buff_duration = ability:GetVanillaAbilitySpecial("slow_duration") -- Not possible for this to be 0 here

				-- Apply buff on allies who attack this enemy
				if self.has_talent then
					buff_duration = buff_duration + self.hits * self.duration_extend
				end

				attacker:AddNewModifier(caster, ability, "modifier_imba_curse_of_avernus_buff_haste",
					{ duration = buff_duration })
			end
		end
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnAttackLanded(kv)
	if self.has_talent and (kv.attacker == self:GetCaster()) and (kv.target == self:GetParent()) then
		self.hits = self.hits + 1
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:OnTakeDamage(kv)
	if IsServer() then
		-- Caster gain heal equal to damage to taken (heal_convert)
		local heal_convert = self.heal_convert

		-- Do not process if there is no heal convert
		if heal_convert > 0 then
			local target = self:GetParent()

			-- Unit having this debuff must be the one taking damage
			if target == kv.unit then
				local caster = self:GetCaster()
				local damage = kv.damage
				local target_health_left = target:GetHealth()

				-- Ensure that we do not heal over the target's health
				local heal_amount
				if damage > target_health_left then
					heal_amount = target_health_left
				else
					heal_amount = damage
				end
				heal_amount = heal_amount * heal_convert

				local life_steal_particle_name = "particles/generic_gameplay/generic_lifesteal.vpcf"
				-- Show heal animation on caster
				local healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",
					PATTACH_POINT_FOLLOW, caster)
				ParticleManager:ReleaseParticleIndex(healFX)
				-- Heal caster equal to a percentage of damage taken by unit affected by this debuff
				caster:Heal(heal_amount, caster)

				if caster:HasModifier("modifier_imba_borrowed_time_buff_hot_caster") then
					local buffed_allies = caster._borrowed_time_buffed_allies
					-- Aghanim heal allies
					if buffed_allies and caster:HasScepter() then
						for k, _ in pairs(buffed_allies) do
							-- Show heal animation on allies
							healFX = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf",
								PATTACH_POINT_FOLLOW, k)
							ParticleManager:ReleaseParticleIndex(healFX)
							-- Show value healed on allies
							SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, k, heal_amount, nil)
							k:Heal(heal_amount, caster)
						end
					end
				end
			end
		end
	end
end

function modifier_imba_curse_of_avernus_debuff_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility()
		:GetVanillaAbilitySpecial("curse_slow") * (-1)
end

modifier_imba_curse_of_avernus_buff_haste = modifier_imba_curse_of_avernus_buff_haste or class({
	IsHidden            = function(self) return false end,
	IsPurgable          = function(self) return true end,
	IsDebuff            = function(self) return false end,
	GetEffectName       = function(self) return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" end,
	GetEffectAttachType = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_curse_of_avernus_buff_haste:_UpdateIncreaseValues()
	self.attack_increase = self:GetAbility():GetVanillaAbilitySpecial("curse_attack_speed")

	if self:GetCaster():HasTalent("special_bonus_imba_abaddon_2") then
		self.attack_increase = self.attack_increase +
			self:GetCaster():FindTalentValue("special_bonus_imba_abaddon_2", "value")
	end
end

function modifier_imba_curse_of_avernus_buff_haste:OnCreated()
	self:_UpdateIncreaseValues()
end

function modifier_imba_curse_of_avernus_buff_haste:OnRefresh(params)
	self:_UpdateIncreaseValues()
end

function modifier_imba_curse_of_avernus_buff_haste:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_imba_curse_of_avernus_buff_haste:GetModifierAttackSpeedBonus_Constant() return self.attack_increase end

modifier_imba_curse_of_avernus_buff_haste_aura = ShallowCopy(modifier_imba_curse_of_avernus_buff_haste)
-----------------------------
--		Over Channel       --
-----------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_over_channel_handler"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_over_channel_reduction"] = LUA_MODIFIER_MOTION_NONE
})
imba_abaddon_over_channel = imba_abaddon_over_channel or class({
	IsStealable     = function(self) return false end,
	IsInnateAbility = function(self) return true end,
})

function imba_abaddon_over_channel:OnToggle()
	if self:GetToggleState() and not self:GetCaster():HasModifier("modifier_over_channel_handler") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_over_channel_handler", {})
	elseif not self:GetToggleState() and self:GetCaster():HasModifier("modifier_over_channel_handler") then
		self:GetCaster():RemoveModifierByName("modifier_over_channel_handler")
	end
end

modifier_over_channel_handler = modifier_over_channel_handler or class({
	IsHidden               = function(self) return false end,
	IsPurgable             = function(self) return false end,
	IsDebuff               = function(self) return false end,
	RemoveOnDeath          = function(self) return true end,
	AllowIllusionDuplicate = function(self) return false end -- Allow illusions to carry this particle modifier
})

function modifier_over_channel_handler:OnCreated()
	local target = self:GetParent()
	local target_origin = target:GetAbsOrigin()
	local particle_name = "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam_blue.vpcf"

	-- Body steam particle
	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_origin, true)
	self:AddParticle(particle, false, false, -1, false, false)

	-- Weapon particle
	particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target_origin,
		true)
	self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_over_channel_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
	return funcs
end

function modifier_over_channel_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() and not keys.ability:IsItem() and keys.ability:GetName() ~= "imba_abaddon_over_channel" and keys.ability:GetName() ~= "ability_capture" then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_over_channel_reduction",
			{ duration = self:GetAbility():GetSpecialValueFor("reduction_duration") })

		local parent = self:GetParent()

		Timers:CreateTimer(self:GetAbility():GetSpecialValueFor("reduction_duration"), function()
			local overchannel_modifier = parent:FindModifierByName("modifier_over_channel_reduction")
			if overchannel_modifier then
				overchannel_modifier:DecrementStackCount()
			end
		end)
	end
end

modifier_over_channel_reduction = modifier_over_channel_reduction or class({
	IsHidden      = function(self) return false end,
	IsPurgable    = function(self) return false end,
	IsDebuff      = function(self) return true end,
	RemoveOnDeath = function(self) return true end
})

function modifier_over_channel_reduction:OnCreated()
	if not IsServer() then return end

	self:SetStackCount(1)
end

function modifier_over_channel_reduction:OnRefresh()
	if not IsServer() then return end

	self:IncrementStackCount()
end

function modifier_over_channel_reduction:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_over_channel_reduction:GetModifierAttackSpeedBonus_Constant()
	return -self:GetStackCount() * self:GetAbility():GetSpecialValueFor("reduction_multiplier")
end

function modifier_over_channel_reduction:GetModifierMoveSpeedBonus_Constant()
	return -self:GetStackCount() * self:GetAbility():GetSpecialValueFor("reduction_multiplier")
end

-----------------------------
--       Borrowed Time     --
-----------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_borrowed_time_buff_hot_caster"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_borrowed_time_buff_hot_ally"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_borrowed_time_buff_mist"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers, {
	["modifier_imba_borrowed_time_handler"] = LUA_MODIFIER_MOTION_NONE,
})

imba_abaddon_borrowed_time = imba_abaddon_borrowed_time or class(VANILLA_ABILITIES_BASECLASS)

function imba_abaddon_borrowed_time:GetIntrinsicModifierName()
	if self:GetCaster():IsRealHero() then
		return "modifier_imba_borrowed_time_handler"
	end
end

function imba_abaddon_borrowed_time:IsNetherWardStealable() return false end

function imba_abaddon_borrowed_time:OnUpgrade()
	local over_channel = self:GetCaster():FindAbilityByName("imba_abaddon_over_channel")
	if over_channel then
		over_channel:SetLevel(1 + self:GetLevel())
	end
end

function imba_abaddon_borrowed_time:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability_level = self:GetLevel()
		local buff_duration = self:GetVanillaAbilitySpecial("duration")

		if caster:HasScepter() then
			buff_duration = self:GetVanillaAbilitySpecial("duration_scepter")
		end
		caster:AddNewModifier(caster, self, "modifier_imba_borrowed_time_buff_hot_caster", { duration = buff_duration })
		local responses = { "abaddon_abad_borrowedtime_02", "abaddon_abad_borrowedtime_03",
			"abaddon_abad_borrowedtime_04", "abaddon_abad_borrowedtime_05", "abaddon_abad_borrowedtime_06",
			"abaddon_abad_borrowedtime_07", "abaddon_abad_borrowedtime_08", "abaddon_abad_borrowedtime_09",
			"abaddon_abad_borrowedtime_10", "abaddon_abad_borrowedtime_11" }
		if not caster:EmitCasterSound("npc_dota_hero_abaddon", responses, 50, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil, nil) then
			caster:EmitCasterSound("npc_dota_hero_abaddon", { "abaddon_abad_borrowedtime_01" }, 1,
				DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil, nil)
		end
		-- Talent : Strong Purge allies in redirect range on cast
		if caster:HasTalent("special_bonus_imba_abaddon_7") then
			local target_team = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			local target_type = DOTA_UNIT_TARGET_HERO

			local allies      = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,
				FIND_UNITS_EVERYWHERE, target_team, target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, unit in pairs(allies) do
				-- Give some tactile feedback that allies have been purged (reusing Mist Coil particles)
				local over_channel_particle = ParticleManager:CreateParticle(
					"particles/dev/library/base_dust_hit_detail.vpcf", PATTACH_POINT, unit)
				ParticleManager:ReleaseParticleIndex(over_channel_particle)

				over_channel_particle = ParticleManager:CreateParticle("particles/dev/library/base_dust_hit_smoke.vpcf",
					PATTACH_POINT, unit)
				ParticleManager:ReleaseParticleIndex(over_channel_particle)
				unit:Purge(false, true, false, true, false)
			end
		end
	end
end

modifier_imba_borrowed_time_handler = modifier_imba_borrowed_time_handler or class({
	IsHidden               = function(self) return true end,
	IsPurgable             = function(self) return false end,
	IsDebuff               = function(self) return false end,
	AllowIllusionDuplicate = function(self) return false end,
})

function modifier_imba_borrowed_time_handler:_CheckHealth(damage)
	local target = self:GetParent()
	local ability = self:GetAbility()

	-- Check state
	if not ability:IsHidden() and ability:IsCooldownReady() and not target:PassivesDisabled() and target:IsAlive() then
		local hp_threshold = self.hp_threshold
		local current_hp = target:GetHealth()
		if current_hp <= hp_threshold then
			target:CastAbilityImmediately(ability, target:GetPlayerID())
		end
	end
end

function modifier_imba_borrowed_time_handler:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:Destroy()
		else
			self.hp_threshold = self:GetAbility():GetVanillaAbilitySpecial("hp_threshold")

			-- Check if we need to auto cast immediately
			self:_CheckHealth(0)
		end
	end
end

function modifier_imba_borrowed_time_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function modifier_imba_borrowed_time_handler:OnTakeDamage(kv)
	if IsServer() then
		local target = self:GetParent()

		if target == kv.unit then
			-- Auto cast borrowed time if damage will bring target to lower than hp_threshold
			self:_CheckHealth(kv.damage)
		end
	end
end

function modifier_imba_borrowed_time_handler:OnStateChanged(kv)
	-- Trigger borrowed time if health below hp_threshold after silence/hex
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			self:_CheckHealth(0)
		end
	end
end

modifier_imba_borrowed_time_buff_hot_caster = modifier_imba_borrowed_time_buff_hot_caster or class({
	IsHidden             = function(self) return false end,
	IsPurgable           = function(self) return false end,
	IsDebuff             = function(self) return false end,
	IsAura               = function(self) return true end,
	IsAuraActiveOnDeath  = function(self) return false end,
	GetModifierAura      = function(self) return "modifier_imba_borrowed_time_buff_hot_ally" end,
	GetAuraSearchType    = function(self) return DOTA_UNIT_TARGET_HERO end,
	GetAuraSearchTeam    = function(self) return DOTA_UNIT_TARGET_TEAM_FRIENDLY end,
	GetEffectName        = function(self) return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end,
	GetEffectAttachType  = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	GetStatusEffectName  = function(self) return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end,
	StatusEffectPriority = function(self) return 15 end,
})

function modifier_imba_borrowed_time_buff_hot_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_imba_borrowed_time_buff_hot_caster:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("redirect_range")
end

function modifier_imba_borrowed_time_buff_hot_caster:GetAuraEntityReject(hEntity)
	-- Do not apply aura to target
	if hEntity == self:GetParent() or hEntity:HasModifier("modifier_imba_borrowed_time_buff_hot_caster") then
		return true
	end
	return false
end

function modifier_imba_borrowed_time_buff_hot_caster:OnCreated()
	if IsServer() then
		local target = self:GetParent()

		if target:HasTalent("special_bonus_imba_abaddon_8") then
			self.has_talent = true
			self.ratio = 1 / target:FindTalentValue("special_bonus_imba_abaddon_8", "ratio_pct") * 100
			self.mist_duration = target:FindTalentValue("special_bonus_imba_abaddon_8", "mist_duration")
		end

		self.target_current_health = target:GetHealth()

		-- Create/Reset list to keep track of allies affected by buff
		target._borrowed_time_buffed_allies = {}

		-- Hey you?
		if RollPercentage(15) then
			--WHATCHA GUN DO
			target:EmitSound("Imba.AbaddonHeyYou")
		end

		--Play the borrowed time sound either way
		target:EmitSound("Hero_Abaddon.BorrowedTime")


		-- Strong Dispel
		target:Purge(false, true, false, true, false)
	end
end

function modifier_imba_borrowed_time_buff_hot_caster:OnDestroy()
	if IsServer() then
		--Stop Meme Sounds
		StopSoundEvent("Imba.AbaddonHeyYou", self:GetParent())
		if self.has_talent and self:GetStackCount() > 0 then
			local target = self:GetParent()
			if target:IsAlive() then
				target:AddNewModifier(target, self:GetAbility(), "modifier_imba_borrowed_time_buff_mist",
					{ duration = self.mist_duration })
				target:FindModifierByName("modifier_imba_borrowed_time_buff_mist"):SetStackCount(self:GetStackCount())
			end
		end
	end
end

function modifier_imba_borrowed_time_buff_hot_caster:OnTakeDamage(kv)
	if IsServer() then
		if (kv.unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetAbility():GetVanillaAbilitySpecial("redirect_range_scepter") and self:GetCaster():HasScepter() and kv.unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() and not kv.unit:IsBuilding() then
			if not kv.unit.borrowed_time_damage_taken then
				kv.unit.borrowed_time_damage_taken = 0
			end

			kv.unit.borrowed_time_damage_taken = kv.unit.borrowed_time_damage_taken + kv.damage

			if kv.unit.borrowed_time_damage_taken / self:GetAbility():GetVanillaAbilitySpecial("ally_threshold_scepter") >= 1 then
				-- print("iteration:", kv.unit.borrowed_time_damage_taken / self:GetAbility():GetVanillaAbilitySpecial("ally_threshold_scepter"))
				-- print("Damage stored:", kv.unit.borrowed_time_damage_taken)
				for i = 1, kv.unit.borrowed_time_damage_taken / self:GetAbility():GetVanillaAbilitySpecial("ally_threshold_scepter") do
					kv.unit.borrowed_time_damage_taken = kv.unit.borrowed_time_damage_taken -
						self:GetAbility():GetVanillaAbilitySpecial("ally_threshold_scepter")
					self:GetCaster():FindAbilityByName("imba_abaddon_death_coil"):OnSpellStart(kv.unit, true)
				end
			end
		end
	end
end

--Block damage

function modifier_imba_borrowed_time_buff_hot_caster:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local target        = self:GetParent()

		-- Show borrowed time heal particle
		local heal_particle = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)

		--  A heal to heal the damage,and -100% to prevent it,
		-- Talent : Heals that heal above maximum health threshold during Borrowed Time grants a mist shield (25% ratio) that is released after Borrowed Time expires for 5 seconds, healing Abaddon.
		if self.has_talent then
			local current_health = target:GetHealth()
			local max_health = target:GetMaxHealth()
			self:SetStackCount(self:GetStackCount() + math.floor(kv.damage / self.ratio))
		end
		target:Heal(kv.damage, target)

		return -9999999
	end
end

modifier_imba_borrowed_time_buff_hot_ally = modifier_imba_borrowed_time_buff_hot_ally or class({
	IsHidden   = function(self) return false end,
	IsPurgable = function(self) return false end,
	IsDebuff   = function(self) return false end,
})

function modifier_imba_borrowed_time_buff_hot_ally:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_imba_borrowed_time_buff_hot_ally:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[target] = true
		end

		local target_origin = target:GetAbsOrigin()
		local particle_name = "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_trail_steam.vpcf"

		-- Body steam particle
		local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_origin,
			true)
		self:AddParticle(particle, false, false, -1, false, false)

		-- Weapon particle
		particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_attack1", target_origin,
			true)
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

function modifier_imba_borrowed_time_buff_hot_ally:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_list = caster._borrowed_time_buffed_allies
		if buff_list then
			buff_list[self:GetParent()] = nil
		end
	end
end

function modifier_imba_borrowed_time_buff_hot_ally:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		-- Ability properties
		local caster          = self:GetCaster()
		local target          = self:GetParent()
		local ability         = self:GetAbility()
		local ability_level   = ability:GetLevel()
		local attacker        = kv.attacker
		local redirect_pct    = (ability:GetLevelSpecialValueFor("redirect", ability_level))
		local redirect_damage = kv.damage * (redirect_pct / 100)

		--Apply the damage to Abaddon.
		ApplyDamage({ victim = caster, attacker = attacker, damage = redirect_damage, damage_type = DAMAGE_TYPE_PURE })

		--Block the amount of damage required.
		return -(redirect_pct)
	end
end

-------------------------------------------
modifier_imba_borrowed_time_buff_mist = modifier_imba_borrowed_time_buff_mist or class({
	IsHidden            = function(self) return false end,
	IsPurgable          = function(self) return true end,
	IsDebuff            = function(self) return false end,
	GetEffectName       = function(self) return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end,
	GetEffectAttachType = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_imba_borrowed_time_buff_mist:OnCreated(params)
	self.duration = self:GetDuration()
end

function modifier_imba_borrowed_time_buff_mist:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
	return decFuns
end

function modifier_imba_borrowed_time_buff_mist:GetModifierConstantHealthRegen()
	return self:GetStackCount() / self.duration
end

-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_abaddon", MotionController)
end

-------------------------------------------
-- Special Modifier OnCreated Logic
-- This is done to reget the behavior of the spell for client purposes
-------------------------------------------

LinkLuaModifier("modifier_special_bonus_imba_abaddon_1", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_2", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_3", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_4", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_abaddon_5", "components/abilities/heroes/hero_abaddon.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_6", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_7", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_abaddon_8", "components/abilities/heroes/hero_abaddon.lua",
	LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_abaddon_1 = modifier_special_bonus_imba_abaddon_1 or class({})
modifier_special_bonus_imba_abaddon_2 = modifier_special_bonus_imba_abaddon_2 or class({})
modifier_special_bonus_imba_abaddon_3 = modifier_special_bonus_imba_abaddon_3 or class({})
modifier_special_bonus_imba_abaddon_4 = modifier_special_bonus_imba_abaddon_4 or class({})
-- modifier_special_bonus_imba_abaddon_5 = modifier_special_bonus_imba_abaddon_5 or class({})
modifier_special_bonus_imba_abaddon_6 = modifier_special_bonus_imba_abaddon_6 or class({})
modifier_special_bonus_imba_abaddon_7 = modifier_special_bonus_imba_abaddon_7 or class({})
modifier_special_bonus_imba_abaddon_8 = modifier_special_bonus_imba_abaddon_8 or class({})

function modifier_special_bonus_imba_abaddon_1:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_1:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_2:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_2:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_2:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_3:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_3:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_4:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_4:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_4:RemoveOnDeath() return false end

-- function modifier_special_bonus_imba_abaddon_5:IsHidden() 		return true end
-- function modifier_special_bonus_imba_abaddon_5:IsPurgable() 	return false end
-- function modifier_special_bonus_imba_abaddon_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_abaddon_6:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_6:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_7:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_7:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_7:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_8:IsHidden() return true end

function modifier_special_bonus_imba_abaddon_8:IsPurgable() return false end

function modifier_special_bonus_imba_abaddon_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_abaddon_4:OnCreated(params)
	if IsServer() then
		local curse_of_avernus_ability = self:GetParent():FindAbilityByName("imba_abaddon_frostmourne")
		if curse_of_avernus_ability then
			curse_of_avernus_ability:GetBehavior()
			curse_of_avernus_ability:GetCooldown()
		end
	end
end
