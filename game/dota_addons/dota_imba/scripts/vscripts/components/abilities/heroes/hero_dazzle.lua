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
--     zimberzimber, 10.03.2017

---------------------------------------------------------------------
-------------------------	Poison Touch	-------------------------
---------------------------------------------------------------------

if imba_dazzle_poison_touch == nil then imba_dazzle_poison_touch = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_poison_touch_setin", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )		-- Set in modifier (slow + attack counter)
LinkLuaModifier( "modifier_imba_dazzle_poison_touch_debuff", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )		-- Stun + damage over time
LinkLuaModifier( "modifier_imba_dazzle_poison_touch_talent_slow", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Because FUCK Valve, and FUCK net tables

function imba_dazzle_poison_touch:GetAbilityTextureName()
	return "dazzle_poison_touch"
end

function imba_dazzle_poison_touch:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_dazzle_poison_touch:GetCooldown()
	return self:GetSpecialValueFor("cooldown")
end

function imba_dazzle_poison_touch:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET end

function imba_dazzle_poison_touch:OnSpellStart()
	local projectile = {
		Target = self:GetCursorTarget(),
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf",
		bDodgable = true,
		bProvidesVision = false,
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
	}
	EmitSoundOn("Hero_Dazzle.Poison_Cast", self:GetCaster())
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_dazzle_poison_touch:OnProjectileHit(target, location)
	if target:TriggerSpellAbsorb(self) then return end

	EmitSoundOn("Hero_Dazzle.Poison_Touch", target)
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dazzle_poison_touch_setin", {duration = self:GetSpecialValueFor("set_in_time")})
end

-----------------------------------------------
-----	Poison Touch set in modifier	  -----
-----------------------------------------------

if modifier_imba_dazzle_poison_touch_setin == nil then modifier_imba_dazzle_poison_touch_setin = class({}) end
function modifier_imba_dazzle_poison_touch_setin:IsPurgable() return true end
function modifier_imba_dazzle_poison_touch_setin:IsHidden() return false end
function modifier_imba_dazzle_poison_touch_setin:IsDebuff() return true end
function modifier_imba_dazzle_poison_touch_setin:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_poison_touch_setin:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end

function modifier_imba_dazzle_poison_touch_setin:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_poison_touch_setin:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_dazzle_poison_touch_setin:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsAlive() and not parent:IsMagicImmune() then
			local ability = self:GetAbility()

			if ability:GetCaster():HasTalent("special_bonus_imba_dazzle_4") then
				local slowMod = parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_dazzle_poison_touch_talent_slow", {duration = ability:GetSpecialValueFor("poison_duration")})
				slowMod:SetStackCount(parent:GetMaxHealth())
			end

			local mod = parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_dazzle_poison_touch_debuff", {duration = ability:GetSpecialValueFor("poison_duration")})
			mod:SetStackCount(self:GetStackCount())
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,			}
	return funcs
end

function modifier_imba_dazzle_poison_touch_setin:OnIntervalThink()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Poison_Tick", self:GetParent())

		local remaining = self:GetRemainingTime()
		if remaining <= 1 then
			local ability = self:GetAbility()
			self:GetParent():AddNewModifier(ability:GetCaster(), ability, "modifier_stunned", {duration = 1})
			self:StartIntervalThink(-1)
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:OnAttackLanded( keys )
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local victim = keys.target
		local damage = keys.damage

		if victim == parent and damage > 0 then
			local stacks = self:GetStackCount()
			if stacks then
				self:SetStackCount(1 + stacks)
			else
				self:SetStackCount(1)
			end
		end
	end
end

function modifier_imba_dazzle_poison_touch_setin:GetModifierMoveSpeedBonus_Percentage()
	if IsServer() then
		local ability = self:GetAbility()
		local minSlow = ability:GetSpecialValueFor("minimum_slow")
		local maxSlow = ability:GetSpecialValueFor("maximum_slow")

		local duration = self:GetDuration() - 1
		local elapsed = math.floor(self:GetElapsedTime())

		local totalSlow = (maxSlow - minSlow) / duration * elapsed + minSlow
		return totalSlow * -1
	end
end

-----------------------------------------------
-----	Poison Touch debuff modifier	  -----
-----------------------------------------------

if modifier_imba_dazzle_poison_touch_debuff == nil then modifier_imba_dazzle_poison_touch_debuff = class({}) end
function modifier_imba_dazzle_poison_touch_debuff:IsPurgable() return true end
function modifier_imba_dazzle_poison_touch_debuff:IsHidden() return false end
function modifier_imba_dazzle_poison_touch_debuff:IsDebuff() return true end
function modifier_imba_dazzle_poison_touch_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_poison_touch_debuff:GetTexture()
	return "dazzle_poison_touch" end

function modifier_imba_dazzle_poison_touch_debuff:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf" end

function modifier_imba_dazzle_poison_touch_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_poison_touch_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,	}
	return funcs
end

function modifier_imba_dazzle_poison_touch_debuff:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1)
	end

	if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_5") then
		self.talentPoisonSpreadEnabled = true
	end
end

function modifier_imba_dazzle_poison_touch_debuff:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local stacks = self:GetStackCount()
		local baseDamage = ability:GetSpecialValueFor("poison_base_damage")
		local stackDamage = ability:GetSpecialValueFor("poison_stack_damage")
		local totalDamage = baseDamage

		totalDamage = baseDamage + stackDamage * stacks

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), totalDamage, nil)
		ApplyDamage({victim = self:GetParent(), attacker = ability:GetCaster(), damage = totalDamage, damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

function modifier_imba_dazzle_poison_touch_debuff:GetModifierPhysicalArmorBonus()
	local stacks = self:GetStackCount()
	if stacks then return self:GetAbility():GetSpecialValueFor("stack_armor_reduction") * stacks * -1 end
	return 0
end

function modifier_imba_dazzle_poison_touch_debuff:OnAbilityFullyCast( keys )
	if self.talentPoisonSpreadEnabled then
		local ability = keys.ability
		local parent = self:GetParent()
		local caster = ability:GetCaster()

		local originalAbility = self:GetAbility()
		local originalCaster = originalAbility:GetCaster()
		if ability:GetCursorTarget() == parent and caster:GetTeamNumber() == parent:GetTeamNumber() and not caster:FindModifierByName("modifier_imba_dazzle_poison_touch_debuff") then
			local mod = caster:AddNewModifier(originalAbility:GetCaster(), originalAbility, "modifier_imba_dazzle_poison_touch_debuff", {duration = originalAbility:GetSpecialValueFor("poison_duration")})
			mod:SetStackCount(self:GetStackCount())
		end
	end
end

---------------------------------------------------	Fun times with not having 'GetMaxHealth' for client \o/
-----	Poison Touch talent slow modifier	  -----	This is the most cancerous pile of junk, chemotherapy highly advised after gazing upon this garbage
---------------------------------------------------	Yeah apperantly 'OnTakeDamage' also doesn't work for client

if modifier_imba_dazzle_poison_touch_talent_slow == nil then modifier_imba_dazzle_poison_touch_talent_slow = class({}) end
function modifier_imba_dazzle_poison_touch_talent_slow:IsPurgable() return true end
function modifier_imba_dazzle_poison_touch_talent_slow:IsHidden() return true end
function modifier_imba_dazzle_poison_touch_talent_slow:IsDebuff() return true end
function modifier_imba_dazzle_poison_touch_talent_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_poison_touch_talent_slow:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,					}
	return funcs
end

function modifier_imba_dazzle_poison_touch_talent_slow:OnCreated()
	local ability = self:GetAbility()
	self.wasDamaged = false
	self.maxHealth = self:GetStackCount()
	if IsServer() then self.maxHealth = self:GetParent():GetMaxHealth() end
	self.caster = self:GetCaster()
	self.maxSlow = self.caster:FindTalentValue("special_bonus_imba_dazzle_4", "talent_slow_max") * -1
	self.slowPerDamage = self.caster:FindTalentValue("special_bonus_imba_dazzle_4", "talent_slow_per_damage")
	self.HpLossForSlowProc = self.caster:FindTalentValue("special_bonus_imba_dazzle_4", "talent_damage_for_slow_proc")
end

function modifier_imba_dazzle_poison_touch_talent_slow:GetModifierMoveSpeedBonus_Percentage()
	local slow = math.floor((self:GetStackCount() * 100 / self.maxHealth))
	local sub = slow % self.HpLossForSlowProc
	return math.max((slow - sub) * -1, self.maxSlow)
end

function modifier_imba_dazzle_poison_touch_talent_slow:OnTakeDamage( keys )
	local damage = keys.damage

	if keys.unit == self:GetParent() and damage > 0 then
		if not self.wasDamaged then
			self:SetStackCount(0)
			self.wasDamaged = true
		end

		local ceil = math.abs(math.ceil(damage) - damage)
		local floor = math.abs(math.floor(damage) - damage)
		if ceil < floor then
			damage = math.ceil(damage)
		else
			damage = math.floor(damage)
		end

		self:SetStackCount(self:GetStackCount() + damage)
	end
end

---------------------------------------------------------------------
-------------------------	Shallow Grave	-------------------------
---------------------------------------------------------------------

if imba_dazzle_shallow_grave == nil then imba_dazzle_shallow_grave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_shallow_grave", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )				-- Shallow Grave effect
LinkLuaModifier( "modifier_imba_dazzle_nothl_protection", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )			-- Passive self-cast
LinkLuaModifier( "modifier_imba_dazzle_post_shallow_grave_buff", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )		-- Post-grave buff
LinkLuaModifier( "modifier_imba_dazzle_nothl_protection_aura_talent", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Talent aura Nothl Protection
LinkLuaModifier( "modifier_imba_dazzle_nothl_protection_particle", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )-- Talent aura Nothl Protection

function imba_dazzle_shallow_grave:GetAbilityTextureName()
	return "dazzle_shallow_grave"
end

function imba_dazzle_shallow_grave:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_dazzle_shallow_grave:GetManaCost()
	return self:GetSpecialValueFor("mana_cost")
end

function imba_dazzle_shallow_grave:GetCastAnimation()
	return ACT_DOTA_SHALLOW_GRAVE end

function imba_dazzle_shallow_grave:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", target)
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_dazzle_shallow_grave", {duration = self:GetSpecialValueFor("duration")})
	end
end

function imba_dazzle_shallow_grave:GetIntrinsicModifierName()
	local caster = self:GetCaster()
	if not caster:HasAbility("imba_pugna_nether_ward_aura") and not caster:IsIllusion() then
		return "modifier_imba_dazzle_nothl_protection"
	end
end

---------------------------------------
-----	Shallow Grave modifier	  -----
---------------------------------------

if modifier_imba_dazzle_shallow_grave == nil then modifier_imba_dazzle_shallow_grave = class({}) end
function modifier_imba_dazzle_shallow_grave:IsPurgable() return false end
function modifier_imba_dazzle_shallow_grave:IsHidden() return false end
function modifier_imba_dazzle_shallow_grave:IsDebuff() return false end

function modifier_imba_dazzle_shallow_grave:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_shallow_grave:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_dazzle_shallow_grave:GetMinHealth()
	return 1 end

function modifier_imba_dazzle_shallow_grave:OnCreated()
	if IsServer() then
		self.shallowDamage = 0
		self.shallowDamageInstances = 0		
		self.shallow_grave_particle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

function modifier_imba_dazzle_shallow_grave:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()

		ParticleManager:DestroyParticle(self.shallow_grave_particle, true)

		-- Checking if alive for cases of death that don't care for Shallow Grave
		if parent:IsAlive() and self.shallowDamage > 0 then
			if self.shallowDamageInstances > 0 then
				local ability = self:GetAbility()
				local modifier = parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_dazzle_post_shallow_grave_buff", {duration = ability:GetSpecialValueFor("post_grave_duration")})
				modifier:SetStackCount(self.shallowDamageInstances)
			end

			local ability = self:GetAbility()
			local caster = ability:GetCaster()

			parent:Heal(self.shallowDamage, caster)
			if caster:HasTalent("special_bonus_imba_dazzle_3") then
				self.targetsHit = {}
				table.insert(self.targetsHit, parent:entindex(), true)
				EmitSoundOn("Hero_Dazzle.Shadow_Wave", self:GetCaster())
				self:ShadowWave(ability, caster, parent, self.shallowDamage/2)
			end
		end
	end
end

function modifier_imba_dazzle_shallow_grave:OnTakeDamage( keys )
	if IsServer() then
		local parent = self:GetParent()
		local health = parent:GetHealth()
		local victim = keys.unit
		local damage = keys.damage

		if not self.triggered_meme_count and USE_MEME_SOUNDS then
			-- Prepares a table to store the times in which the hero was graved
			parent.shallow_grave_meme_table = parent.shallow_grave_meme_table or {}

			local current_time = GameRules:GetGameTime()
			-- Remove old time stamps
			for i= #parent.shallow_grave_meme_table, 1, -1 do
				if current_time - 30 > parent.shallow_grave_meme_table[i] then
					table.remove(parent.shallow_grave_meme_table, i)
				end
			end

			-- Inserts a timestamp
			table.insert(parent.shallow_grave_meme_table,  current_time)

			if #parent.shallow_grave_meme_table > 3 then
				-- Nil handling
				parent.time_of_triggered_rare_shallow_grave_meme = parent.time_of_triggered_rare_shallow_grave_meme or 0
				parent.time_of_triggered_shallow_grave_meme = parent.time_of_triggered_shallow_grave_meme or 0
				-- Normal trigger									-- Make sure the sounds don't overlap
				if not parent.has_triggered_shallow_grave_meme  and  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
					parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
					parent.time_of_triggered_shallow_grave_meme = current_time
					-- Possible rare trigger:
				else
					-- Super rare sound 	-- Make sure the sounds don't overlap
					if RollPercentage(50) and current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
						parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive2")
						parent.time_of_triggered_rare_shallow_grave_meme =  current_time

						-- Make sure the sounds don't overlap
					elseif  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
						parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
					end
				end
				-- A check for the rare sound
				parent.has_triggered_shallow_grave_meme = true
			else
				parent.has_triggered_shallow_grave_meme = false
			end
			self.triggered_meme_count = true
		end

		if parent == victim and math.floor(health) <= 1 then
			self.shallowDamage = self.shallowDamage + damage
			self.shallowDamageInstances = self.shallowDamageInstances + 1
		end
	end
end

-- For the talent that releases a shadow wave
function modifier_imba_dazzle_shallow_grave:ShadowWave(ability, caster, oldTarget, heal)
	local bounceDistance = ability:GetSpecialValueFor("talent_wave_bounce_distance")

	oldTarget:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, oldTarget, heal, nil)

	-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
	local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local newTarget

	for _,hero in pairs(heroTable) do
		if hero:GetHealth() < hero:GetMaxHealth() and not self.targetsHit[hero:entindex()] then
			table.insert(self.targetsHit, hero:entindex(), true)
			newTarget = hero
			break
		end
	end

	if not newTarget then
		for _,hero in pairs(heroTable) do
			if not self.targetsHit[hero:entindex()] then
				table.insert(self.targetsHit, hero:entindex(), true)
				newTarget = hero
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if creep:GetHealth() < creep:GetMaxHealth() and not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if newTarget then
		local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, oldTarget)
		ParticleManager:SetParticleControlEnt(waveParticle, 0, oldTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", oldTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(waveParticle)

		self:ShadowWave(ability, caster, newTarget, heal)
	end
end

-------------------------------------------
-----	Nothl Protection modifier	  -----
-------------------------------------------

if modifier_imba_dazzle_nothl_protection == nil then modifier_imba_dazzle_nothl_protection = class({}) end
function modifier_imba_dazzle_nothl_protection:IsPurgable() return false end
function modifier_imba_dazzle_nothl_protection:IsHidden() return false end
function modifier_imba_dazzle_nothl_protection:DestroyOnExpire() return false end

function modifier_imba_dazzle_nothl_protection:IsDebuff()
	if self:GetStackCount() < 1 then
		return false
	end
	return true
end

function modifier_imba_dazzle_nothl_protection:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_dazzle_nothl_protection:GetTexture()
	if self:GetStackCount() > 0 then
		return "custom/dazzle_shallow_grave_cooldown"
	else
		return "custom/dazzle_nothl_protection"
	end
end

function modifier_imba_dazzle_nothl_protection:GetMinHealth()
	if IsServer() then
		if self:GetParent():PassivesDisabled() and not self.isActive then
			return 0
		elseif self:GetStackCount() > 0 then
			return 0
		else
			return 1
		end
	end
end

function modifier_imba_dazzle_nothl_protection:OnCreated()
	if IsServer() then
		self.isActive = false
		self.shallowDamage = 0
		self.shallowDamageInstances = 0
		self:StartIntervalThink(1)
	end
end

function modifier_imba_dazzle_nothl_protection:OnTakeDamage( keys )
	if IsServer() then
		if self:GetStackCount() < 1 then
			local parent = self:GetParent()
			local health = parent:GetHealth()
			local victim = keys.unit
			local damage = keys.damage

			-- If the victim is the modifier holder
			if parent == victim and math.floor(health) <= 1 and not parent:FindModifierByName("modifier_imba_dazzle_shallow_grave") then

				-- If the modifier is not active, and the carrier is not broken
				if not self.isActive and not parent:PassivesDisabled() then
					local ability = self:GetAbility()

					self.shallowDamage = self.shallowDamage + damage
					self.shallowDamageInstances = self.shallowDamageInstances + 1
					self.isActive = true

					parent:AddNewModifier(caster, nil , "modifier_imba_dazzle_nothl_protection_particle", { duration = nothl_duration})
					
					local nothl_duration = ability:GetSpecialValueFor("nothl_protection_duration")
					Timers:CreateTimer(nothl_duration, function()

							-- Checking if alive for cases of death that don't care for Nothl Protection
							if self:GetParent():IsAlive() and self.shallowDamage > 0 and self:GetParent():HasModifier("modifier_imba_dazzle_nothl_protection_particle") then
								if self.shallowDamageInstances > 0 then
									local modifier = parent:AddNewModifier(parent, ability, "modifier_imba_dazzle_post_shallow_grave_buff", {duration = ability:GetSpecialValueFor("post_grave_duration")})
									modifier:SetStackCount(self.shallowDamageInstances)
								end

								parent:Heal(self.shallowDamage, parent)
								if parent:HasTalent("special_bonus_imba_dazzle_3") then
									self.targetsHit = {}
									table.insert(self.targetsHit, parent:entindex(), true)
									EmitSoundOn("Hero_Dazzle.Shadow_Wave", parent)
									self:ShadowWave(ability, parent, parent, self.shallowDamage/2)
								end
							end

							self.isActive = false
							self.shallowDamage = 0
							self.shallowDamageInstances = 0

							parent:RemoveModifierByName("modifier_imba_dazzle_nothl_protection_particle")
							local nothl_cooldown = ability:GetSpecialValueFor("nothl_protection_cooldown")

							self:SetStackCount(math.floor(nothl_cooldown))
							self:StartIntervalThink(1)
					end)

					-- If the modifier is active
				elseif self.isActive and not parent:PassivesDisabled() then
					if not self.triggered_meme_count and USE_MEME_SOUNDS then
						-- Prepares a table to store the times in which the hero was graved
						parent.shallow_grave_meme_table = parent.shallow_grave_meme_table or {}

						local current_time = GameRules:GetGameTime()
						-- Remove old time stamps
						for i= #parent.shallow_grave_meme_table, 1, -1 do
							if current_time - 30 > parent.shallow_grave_meme_table[i] then
								table.remove(parent.shallow_grave_meme_table, i)
							end
						end

						-- Inserts a timestamp
						table.insert(parent.shallow_grave_meme_table,  current_time)

						if #parent.shallow_grave_meme_table > 3 then
							-- Nil handling
							parent.time_of_triggered_rare_shallow_grave_meme = parent.time_of_triggered_rare_shallow_grave_meme or 0
							parent.time_of_triggered_shallow_grave_meme = parent.time_of_triggered_shallow_grave_meme or 0
							-- Normal trigger									-- Make sure the sounds don't overlap
							if not parent.has_triggered_shallow_grave_meme  and  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
								parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
								parent.time_of_triggered_shallow_grave_meme = current_time
								-- Possible rare trigger:
							else
								-- Super rare sound 	-- Make sure the sounds don't overlap
								if RollPercentage(50) and current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
									parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive2")
									parent.time_of_triggered_rare_shallow_grave_meme =  current_time

									-- Make sure the sounds don't overlap
								elseif  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
									parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
								end
							end
							-- A check for the rare sound
							parent.has_triggered_shallow_grave_meme = true
						else
							parent.has_triggered_shallow_grave_meme = false
						end
						self.triggered_meme_count = true
					end
					self.shallowDamage = self.shallowDamage + damage
					self.shallowDamageInstances = self.shallowDamageInstances + 1
				end
			end
		end
	end
end

function modifier_imba_dazzle_nothl_protection:OnIntervalThink()
	local stacks = self:GetStackCount()
	if stacks > 0 then
		self:SetStackCount(stacks - 1)
	end

	if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_6") then
		if self.auraTalentCooldowns then
			for id, cd in pairs(self.auraTalentCooldowns) do
				if cd > 0 then
					self.auraTalentCooldowns[id] = cd - 1
				end
			end
		else
			self.auraTalentCooldowns = {}
		end
	end
end

function modifier_imba_dazzle_nothl_protection:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nothl_protection_particle, true)
	end
end

function modifier_imba_dazzle_nothl_protection:OnDestroy()
	if IsServer() then
		if self.isActive and self:GetParent():IsAlive() then
			self:GetParent():Heal(self.shallowDamage, self:GetParent())
		end
	end
end

-- For the talent that releases a shadow wave
function modifier_imba_dazzle_nothl_protection:ShadowWave(ability, caster, oldTarget, heal)
	oldTarget:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, oldTarget, heal, nil)
	local bounceDistance = ability:GetSpecialValueFor("talent_wave_bounce_distance")

	-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
	local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local newTarget

	for _,hero in pairs(heroTable) do
		if hero:GetHealth() < hero:GetMaxHealth() and not self.targetsHit[hero:entindex()] then
			table.insert(self.targetsHit, hero:entindex(), true)
			newTarget = hero
			break
		end
	end

	if not newTarget then
		for _,hero in pairs(heroTable) do
			if not self.targetsHit[hero:entindex()] then
				table.insert(self.targetsHit, hero:entindex(), true)
				newTarget = hero
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if creep:GetHealth() < creep:GetMaxHealth() and not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if newTarget then
		local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, oldTarget)
		ParticleManager:SetParticleControlEnt(waveParticle, 0, oldTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", oldTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(waveParticle)

		self:ShadowWave(ability, caster, newTarget, heal)
	end
end

-- Talent Nothl Protection aura
function modifier_imba_dazzle_nothl_protection:IsAura()
	return self:GetParent():HasTalent("special_bonus_imba_dazzle_6") end

function modifier_imba_dazzle_nothl_protection:GetAuraRadius()
	return self:GetCaster():FindTalentValue("special_bonus_imba_dazzle_6", "talent_aura_radius") end

function modifier_imba_dazzle_nothl_protection:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_dazzle_nothl_protection:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO end

function modifier_imba_dazzle_nothl_protection:GetModifierAura()
	return "modifier_imba_dazzle_nothl_protection_aura_talent" end

function modifier_imba_dazzle_nothl_protection:GetAuraEntityReject( hero )
	if hero == self:GetParent() then return true end

	local id = hero:GetEntityIndex()
	if self.auraTalentCooldowns then
		if self.auraTalentCooldowns[id] then
			if self.auraTalentCooldowns[id] > 0 then
				return true
			end
		else
			table.insert(self.auraTalentCooldowns, id, 0)
		end
	else
		self.auraTalentCooldowns = {}
	end
	return false
end

function modifier_imba_dazzle_nothl_protection:TalentAuraTimeUpdater(id)
	self.auraTalentCooldowns[id] = self:GetAbility():GetSpecialValueFor("nothl_protection_cooldown")
	if self.auraTalentCooldowns[id] == 0 then self.auraTalentCooldowns[id] = 30 end -- fail safe just in case
end


modifier_imba_dazzle_nothl_protection_particle = class({})
function modifier_imba_dazzle_nothl_protection_particle:OnCreated()
	if IsServer() then
		self.particles = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_shallow_grave_self.vpcf", PATTACH_ABSORIGIN_FOLLOW , self:GetParent())
	end
end

function modifier_imba_dazzle_nothl_protection_particle:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particles, true)
	end
end

---------------------------------------
-----	Post-Shallow Grave buff	  -----
---------------------------------------

if modifier_imba_dazzle_post_shallow_grave_buff == nil then modifier_imba_dazzle_post_shallow_grave_buff = class({}) end
function modifier_imba_dazzle_post_shallow_grave_buff:IsPurgable() return true end
function modifier_imba_dazzle_post_shallow_grave_buff:IsHidden() return false end
function modifier_imba_dazzle_post_shallow_grave_buff:IsDebuff() return false end

function modifier_imba_dazzle_post_shallow_grave_buff:GetTexture()
	return "dazzle_shallow_grave" end

function modifier_imba_dazzle_post_shallow_grave_buff:GetEffectName()
	return "particles/hero/dazzle/dazzle_post_grave.vpcf" end

function modifier_imba_dazzle_post_shallow_grave_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_dazzle_post_shallow_grave_buff:OnCreated()
	local ability = self:GetAbility()
	self.armor = ability:GetSpecialValueFor("post_grave_armor_per_hit")
	self.resist = ability:GetSpecialValueFor("post_grave_resist_per_hit")
	if IsServer() then
		self.post_shallow_grave_particle = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_post_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end

function modifier_imba_dazzle_post_shallow_grave_buff:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.post_shallow_grave_particle, true)
	end
end

function modifier_imba_dazzle_post_shallow_grave_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,	}
	return funcs
end

function modifier_imba_dazzle_post_shallow_grave_buff:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * self.resist
end

function modifier_imba_dazzle_post_shallow_grave_buff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor
end

-----------------------------------------------
-----	Nothl Protection Aura modifier	  -----
-----------------------------------------------
if modifier_imba_dazzle_nothl_protection_aura_talent == nil then modifier_imba_dazzle_nothl_protection_aura_talent = class({}) end
function modifier_imba_dazzle_nothl_protection_aura_talent:IsPurgable() return false end
function modifier_imba_dazzle_nothl_protection_aura_talent:IsHidden() return false end
function modifier_imba_dazzle_nothl_protection_aura_talent:IsDebuff() return false end

function modifier_imba_dazzle_nothl_protection_aura_talent:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_dazzle_nothl_protection_aura_talent:GetMinHealth()
	return 1 end

function modifier_imba_dazzle_nothl_protection_aura_talent:OnCreated()
	if IsServer() then
		self.shallowDamage = 0
		self.shallowDamageInstances = 0
		self.triggered = false
	end
end

function modifier_imba_dazzle_nothl_protection_aura_talent:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()

		-- Checking if alive for cases of death that don't care for Shallow Grave
		if parent:IsAlive() and self.shallowDamage > 0 then
			self:GetAbility():GetCaster():FindModifierByName("modifier_imba_dazzle_nothl_protection"):TalentAuraTimeUpdater(parent:GetEntityIndex())

			local ability = self:GetAbility()
			local caster = ability:GetCaster()

			parent:Heal(self.shallowDamage, self:GetAbility():GetCaster())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, self.shallowDamage, nil)
			if self.shallowDamageInstances > 0 then
				local modifier = parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_dazzle_post_shallow_grave_buff", {duration = ability:GetSpecialValueFor("post_grave_duration")})
				modifier:SetStackCount(self.shallowDamageInstances)
			end

			if caster:HasTalent("special_bonus_imba_dazzle_3") then
				self.shallow_wave_damage_pct = caster:FindTalentValue("special_bonus_imba_dazzle_3", "shallow_wave_damage_pct")
				self.targetsHit = {}
				table.insert(self.targetsHit, parent:entindex(), true)
				EmitSoundOn("Hero_Dazzle.Shadow_Wave", self:GetCaster())
				self:ShadowWave(ability, caster, parent, self.shallowDamage/self.shallow_wave_damage_pct)
			end
		end
	end
end

function modifier_imba_dazzle_nothl_protection_aura_talent:OnTakeDamage( keys )
	if IsServer() then
		local parent = self:GetParent()
		local health = parent:GetHealth()
		local victim = keys.unit
		local damage = keys.damage

		if parent == victim and math.floor(health) <= 1 then
			self.shallowDamage = self.shallowDamage + damage
			self.shallowDamageInstances = self.shallowDamageInstances + 1

			if not self.triggered_meme_count and USE_MEME_SOUNDS then
				-- Prepares a table to store the times in which the hero was graved
				parent.shallow_grave_meme_table = parent.shallow_grave_meme_table or {}

				local current_time = GameRules:GetGameTime()
				-- Remove old time stamps
				for i= #parent.shallow_grave_meme_table, 1, -1 do
					if current_time - 30 > parent.shallow_grave_meme_table[i] then
						table.remove(parent.shallow_grave_meme_table, i)
					end
				end

				-- Inserts a timestamp
				table.insert(parent.shallow_grave_meme_table,  current_time)

				if #parent.shallow_grave_meme_table > 3 then
					-- Nil handling
					parent.time_of_triggered_rare_shallow_grave_meme = parent.time_of_triggered_rare_shallow_grave_meme or 0
					parent.time_of_triggered_shallow_grave_meme = parent.time_of_triggered_shallow_grave_meme or 0
					-- Normal trigger									-- Make sure the sounds don't overlap
					if not parent.has_triggered_shallow_grave_meme  and  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
						parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
						parent.time_of_triggered_shallow_grave_meme = current_time
						-- Possible rare trigger:
					else
						-- Super rare sound 	-- Make sure the sounds don't overlap
						if RollPercentage(50) and current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
							parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive2")
							parent.time_of_triggered_rare_shallow_grave_meme =  current_time

							-- Make sure the sounds don't overlap
						elseif  current_time - 23 > parent.time_of_triggered_rare_shallow_grave_meme and current_time -6 > parent.time_of_triggered_shallow_grave_meme then
							parent:EmitSound("Imba.DazzleShallowGraveIWillSurvive1")
						end
					end
					-- A check for the rare sound
					parent.has_triggered_shallow_grave_meme = true
				else
					parent.has_triggered_shallow_grave_meme = false
				end
				self.triggered_meme_count = true
			end

			if not self.triggered then
				self.triggered = true
				local particle = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_shallow_grave_talent.vpcf", PATTACH_ABSORIGIN_FOLLOW , parent)
				Timers:CreateTimer(self:GetCaster():FindTalentValue("special_bonus_imba_dazzle_6", "talent_aura_nothl_duration"), function()
					if not self:IsNull() then
						ParticleManager:DestroyParticle(particle, false)
						ParticleManager:ReleaseParticleIndex(particle)
						self:Destroy()
					end
				end)
			end
		end
	end
end

-- For the talent that releases a shadow wave
function modifier_imba_dazzle_nothl_protection_aura_talent:ShadowWave(ability, caster, oldTarget, heal)
	local bounceDistance = caster:FindTalentValue("special_bonus_imba_dazzle_3", "talent_wave_bounce_distance")

	oldTarget:Heal(heal, caster)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, oldTarget, self.heal, nil)

	-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
	local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), oldTarget:GetAbsOrigin(), nil, bounceDistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local newTarget

	for _,hero in pairs(heroTable) do
		if hero:GetHealth() < hero:GetMaxHealth() and not self.targetsHit[hero:entindex()] then
			table.insert(self.targetsHit, hero:entindex(), true)
			newTarget = hero
			break
		end
	end

	if not newTarget then
		for _,hero in pairs(heroTable) do
			if not self.targetsHit[hero:entindex()] then
				table.insert(self.targetsHit, hero:entindex(), true)
				newTarget = hero
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if creep:GetHealth() < creep:GetMaxHealth() and not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if not newTarget then
		for _,creep in pairs(creepTable) do
			if not self.targetsHit[creep:entindex()] then
				table.insert(self.targetsHit, creep:entindex(), true)
				newTarget = creep
				break
			end
		end
	end

	if newTarget then
		local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, oldTarget)
		ParticleManager:SetParticleControlEnt(waveParticle, 0, oldTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", oldTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(waveParticle)

		self:ShadowWave(ability, caster, newTarget, heal)
	end
end

---------------------------------------------------------------------
-------------------------	Shadow Wave		-------------------------
---------------------------------------------------------------------
if imba_dazzle_shadow_wave == nil then imba_dazzle_shadow_wave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_shadow_wave_delayed_bounce", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )			-- Talent delayed wave bounce
LinkLuaModifier( "modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Talent delayed wave bounce cooldown

function imba_dazzle_shadow_wave:GetAbilityTextureName()
	return "dazzle_shadow_wave"
end

function imba_dazzle_shadow_wave:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_dazzle_shadow_wave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK end

function imba_dazzle_shadow_wave:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		local isAlly = false

		if target:GetTeamNumber() == caster:GetTeamNumber() then
			isAlly = true
		end

		if caster:HasTalent("special_bonus_imba_dazzle_1") then
			if not self.talentWaveDelayed then
				self.talentWaveDelayed = {}
				for i = 1, caster:FindTalentValue("special_bonus_imba_dazzle_1", "talent_delayed_wave_max_waves") do
					self.talentWaveDelayed[i] = "empty"
				end
			end

			local oldest = -1
			for loc, dat in ipairs(self.talentWaveDelayed) do
				if dat == "empty" then
					oldest = loc
					break
				end
			end

			if oldest == -1 then
				oldest = 1
				for loc, dat in ipairs(self.talentWaveDelayed) do
					if dat.timeCreated <= self.talentWaveDelayed[oldest].timeCreated then
						oldest = loc
					end
				end
			end

			if self.talentWaveDelayed and self.talentWaveDelayed[oldest] and self.talentWaveDelayed[oldest].handler and not self.talentWaveDelayed[oldest].handler:IsNull() then
				self.talentWaveDelayed[oldest].handler:DestroyCustom()

				-- Destroy all bounce cooldowns
				local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
				for _, unit in ipairs(units) do
					local cooldownMods = unit:FindAllModifiersByName("modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown")
					for _, mod in ipairs(cooldownMods) do
						if mod:GetStackCount() == oldest then
							mod:Destroy()
						end
					end
				end
			end

			self:WaveHit(target, isAlly, poisonTouched)
			if target ~= caster then
				self:WaveHit(caster, true)
			end

			local mod = target:AddNewModifier(caster, self, "modifier_imba_dazzle_shadow_wave_delayed_bounce", {duration = caster:FindTalentValue("special_bonus_imba_dazzle_1", "talent_delayed_wave_delay")})
			mod:SetStackCount(oldest)

			self.talentWaveDelayed[oldest] = {
				timeCreated = GameRules:GetGameTime(),
				poisonTouched = nil,
				isAlly = isAlly,
				handler = mod,
			}

			EmitSoundOn("Hero_Dazzle.Shadow_Wave", self:GetCaster())
			local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(waveParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(waveParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(waveParticle)
		else
			self.targetsHit = {}

			table.insert(self.targetsHit, caster:entindex(), true)

			self:WaveHit(caster, true)
			self:WaveBounce(target, isAlly)

			if target ~= caster then
				table.insert(self.targetsHit, target:entindex(), true)
			end

			EmitSoundOn("Hero_Dazzle.Shadow_Wave", self:GetCaster())
			local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(waveParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(waveParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(waveParticle)
		end
	end
end

-- Unit finder
function imba_dazzle_shadow_wave:WaveBounce(target, isAlly, poisonTouched)
	if IsServer() then
		local caster = self:GetCaster()
		local bounceDistance = self:GetSpecialValueFor("bounce_distance")
		local newTarget
		local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY

		if isAlly then
			targetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
		else
			local poisonMods = target:FindAllModifiersByName("modifier_imba_dazzle_poison_touch_debuff")
			if poisonMods and poisonMods[1] then
				for _,modifier in ipairs(poisonMods) do
					local stacks = modifier:GetStackCount()
					if not poisonTouched or poisonTouched < stacks then
						poisonTouched = stacks
					end
				end
			end
		end

		-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
		-- Priority changed from vanilla since the skill now applies a buff, which you'd probably prefer hitting heroes over creeps
		local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounceDistance, targetTeam, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, bounceDistance, targetTeam, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for _,hero in pairs(heroTable) do
			if hero:GetHealth() < hero:GetMaxHealth() and not self.targetsHit[hero:entindex()] then
				table.insert(self.targetsHit, hero:entindex(), true)
				newTarget = hero
				break
			end
		end

		if not newTarget then
			for _,hero in pairs(heroTable) do
				if not self.targetsHit[hero:entindex()] then
					table.insert(self.targetsHit, hero:entindex(), true)
					newTarget = hero
					break
				end
			end
		end

		if not newTarget then
			for _,creep in pairs(creepTable) do
				if creep:GetHealth() < creep:GetMaxHealth() and not self.targetsHit[creep:entindex()] then
					table.insert(self.targetsHit, creep:entindex(), true)
					newTarget = creep
					break
				end
			end
		end

		if not newTarget then
			for _,creep in pairs(creepTable) do
				if not self.targetsHit[creep:entindex()] then
					table.insert(self.targetsHit, creep:entindex(), true)
					newTarget = creep
					break
				end
			end
		end

		if newTarget then
			local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControlEnt(waveParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(waveParticle)

			self:WaveBounce(newTarget, isAlly, poisonTouched)
			self:WaveHit(newTarget, isAlly, poisonTouched)
		end
	end
end

-- Heal + buff + damage
function imba_dazzle_shadow_wave:WaveHit(unit, isAlly, poisonTouched)
	if IsServer() then
		local caster = self:GetCaster()
		local spellAmp = caster:GetSpellAmplification(false)
		local damage = self:GetSpecialValueFor("damage")
		local damageRadius = self:GetSpecialValueFor("damage_radius")

		local totalHeal = damage * (1 + spellAmp * 0.01)
		local targetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY

		if isAlly then
			-- If ally, heal and change search type to find enemies
			unit:Heal(totalHeal, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, unit, totalHeal, nil)
			targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		else
			-- If enemy, deal damage and check for poison
			-- If poison was found, and it has more stacks than an older poison instance, change poisonTouched so further bounces apply it as well (with the updated value)
			ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
			local poisonTouchAbility = caster:FindAbilityByName("imba_dazzle_poison_touch")
			local oldMod = unit:FindModifierByName("modifier_imba_dazzle_poison_touch_debuff")
			if poisonTouched and poisonTouchAbility then
				if not oldMod or oldMod:GetStackCount() < poisonTouched then
					local modifier = unit:AddNewModifier(caster, poisonTouchAbility, "modifier_imba_dazzle_poison_touch_debuff", {duration = poisonTouchAbility:GetSpecialValueFor("poison_duration")})
					EmitSoundOn("Hero_Dazzle.Poison_Tick", unit)
					modifier:SetStackCount(poisonTouched)
				end
			end
		end

		-- If the caster has the talent, change flag to search for both sides so they both get affected by AoE damage/heal
		if caster:HasTalent("special_bonus_imba_dazzle_2") then
			targetTeam = DOTA_UNIT_TARGET_TEAM_BOTH
		end

		local aoeTargets = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, damageRadius, targetTeam, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		for _,target in pairs(aoeTargets) do
			if target ~= unit then
				local damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_damage.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControlEnt(damage_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(damage_particle)

				if target:GetTeamNumber() ~= caster:GetTeamNumber() then
					ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
				else
					target:Heal(totalHeal, caster)
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, totalHeal, nil)
				end
			end
		end
	end
end

-- Delayed wave talent helpers
function imba_dazzle_shadow_wave:GetDelayedWaveData(location)
	return self.talentWaveDelayed[location]
end

function imba_dazzle_shadow_wave:SetDelayedWaveData(location, data)
	self.talentWaveDelayed[location] = data
end

---------------------------------------------------------------
-----	Shadow Wave delayed wave jump talent modifier	  -----
---------------------------------------------------------------
if modifier_imba_dazzle_shadow_wave_delayed_bounce == nil then modifier_imba_dazzle_shadow_wave_delayed_bounce = class({}) end
function modifier_imba_dazzle_shadow_wave_delayed_bounce:IsPurgable() return false end
function modifier_imba_dazzle_shadow_wave_delayed_bounce:IsHidden() return true end
function modifier_imba_dazzle_shadow_wave_delayed_bounce:IsDebuff() return false end
function modifier_imba_dazzle_shadow_wave_delayed_bounce:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_dazzle_shadow_wave_delayed_bounce:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local cooldownMod = parent:AddNewModifier(caster, ability, "modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown", {duration = caster:FindTalentValue("special_bonus_imba_dazzle_1", "talent_delayed_wave_rehit_cd") + caster:FindTalentValue("special_bonus_imba_dazzle_1", "talent_delayed_wave_delay")})

		Timers:CreateTimer(0.01, function()
			if not (self:IsNull() or ability:IsNull()) then
				self.data = ability:GetDelayedWaveData(self:GetStackCount())
				cooldownMod:SetStackCount(self:GetStackCount())
			end
		end)
	end
end

function modifier_imba_dazzle_shadow_wave_delayed_bounce:OnDestroy()
	if IsServer() then
		if not self.destroyNoJump then
			local ability = self:GetAbility()
			local caster = ability:GetCaster()
			local parent = self:GetParent()
			local bounceDistance = ability:GetSpecialValueFor("bounce_distance")
			local newTarget
			local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY

			if self.data.isAlly then
				targetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
			else
				local poisonMods = parent:FindAllModifiersByName("modifier_imba_dazzle_poison_touch_debuff")
				if poisonMods and poisonMods[1] then
					for _,modifier in ipairs(poisonMods) do
						local stacks = modifier:GetStackCount()
						if not self.data.poisonTouched or self.data.poisonTouched < stacks then
							self.data.poisonTouched = stacks
						end
					end
				end
			end

			-- Prioritize injured heroes, then heroes, then injured creeps, then creeps
			-- Priority changed from vanilla since the skill now applies a buff, which you'd probably prefer hitting heroes over creeps
			local heroTable = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, bounceDistance, targetTeam, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local creepTable = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, bounceDistance, targetTeam, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local stacks = self:GetStackCount()

			for _,hero in pairs(heroTable) do
				if hero ~= parent and hero:GetHealth() < hero:GetMaxHealth() then
					local cooldownMods = hero:FindAllModifiersByName("modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown")
					local hasCD = false
					for _,mod in ipairs(cooldownMods) do
						if mod:GetStackCount() == stacks then
							hasCD = true
							break
						end
					end

					if not hasCD then
						newTarget = hero
						break
					end
				end
			end

			if not newTarget then
				for _,hero in pairs(heroTable) do
					if hero ~= parent then
						local cooldownMods = hero:FindAllModifiersByName("modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown")
						local hasCD = false
						for _,mod in ipairs(cooldownMods) do
							if mod:GetStackCount() == stacks then
								hasCD = true
								break
							end
						end

						if not hasCD then
							newTarget = hero
							break
						end
					end
				end
			end

			if not newTarget then
				for _,creep in pairs(creepTable) do
					if creep ~= parent and creep:GetHealth() < creep:GetMaxHealth() then
						local cooldownMods = creep:FindAllModifiersByName("modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown")
						local hasCD = false
						for _,mod in ipairs(cooldownMods) do
							if mod:GetStackCount() == stacks then
								hasCD = true
								break
							end
						end

						if not hasCD then
							newTarget = creep
							break
						end
					end
				end
			end

			if not newTarget then
				for _,creep in pairs(creepTable) do
					if creep ~= parent then
						local cooldownMods = creep:FindAllModifiersByName("modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown")
						local hasCD = false
						for _,mod in ipairs(cooldownMods) do
							if mod:GetStackCount() == stacks then
								hasCD = true
								break
							end
						end

						if not hasCD then
							newTarget = creep
							break
						end
					end
				end
			end

			if newTarget then
				local mod = newTarget:AddNewModifier(caster, ability, "modifier_imba_dazzle_shadow_wave_delayed_bounce", {duration = caster:FindTalentValue("special_bonus_imba_dazzle_1", "talent_delayed_wave_delay")})
				mod:SetStackCount(self:GetStackCount())

				self.data.handler = mod

				ability:SetDelayedWaveData(self:GetStackCount(), self.data)

				local waveParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControlEnt(waveParticle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(waveParticle, 1, newTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", newTarget:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(waveParticle)

				EmitSoundOn("Hero_Dazzle.Shadow_Wave", parent)
				ability:WaveHit(newTarget, self.data.isAlly, self.data.poisonTouched)
			end
		end
	end
end

function modifier_imba_dazzle_shadow_wave_delayed_bounce:DestroyCustom()
	self.destroyNoJump = true
	self:Destroy()
end

-----------------------------------------------------------------------
-----	Shadow Wave delayed wave jump talent modifier cooldown	  -----
-----------------------------------------------------------------------
if modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown == nil then modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown = class({}) end
function modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown:IsPurgable() return false end
function modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown:IsHidden() return true end
function modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown:IsDebuff() return true end
function modifier_imba_dazzle_shadow_wave_delayed_bounce_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-------------------------------------------------------------
-------------------------	Weave	-------------------------
-------------------------------------------------------------
if imba_dazzle_weave == nil then imba_dazzle_weave = class({}) end
LinkLuaModifier( "modifier_imba_dazzle_weave_buff", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )			-- Allied bonus armor
LinkLuaModifier( "modifier_imba_dazzle_weave_debuff", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )		-- Allied bonus armor
LinkLuaModifier( "modifier_imba_dazzle_ressurection_layout", "components/abilities/heroes/hero_dazzle.lua", LUA_MODIFIER_MOTION_NONE )	-- Ressurection ability layout modifier

function imba_dazzle_weave:GetAbilityTextureName()
	return "dazzle_weave" end

function imba_dazzle_weave:GetCooldown()
	return self:GetSpecialValueFor("cooldown") end

function imba_dazzle_weave:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4 end

function imba_dazzle_weave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE end

function imba_dazzle_weave:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end

function imba_dazzle_weave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()

		local area_of_effect = self:GetSpecialValueFor("area_of_effect")
		local modifier_duration = self:GetSpecialValueFor("modifier_duration")
		local vision_duration = self:GetSpecialValueFor("vision_duration")
		local vision_radius = self:GetSpecialValueFor("vision_radius")
		local repeat_delay = self:GetSpecialValueFor("repeat_delay")
		local tick_interval = self:GetSpecialValueFor("tick_interval")

		local targetType = DOTA_UNIT_TARGET_HERO
		local repeat_times = math.floor(modifier_duration / repeat_delay)
		local times_repeated = 0
		local affected = {}

		if caster:HasTalent("special_bonus_imba_dazzle_7") then
			targetType = targetType + DOTA_UNIT_TARGET_BUILDING
		end

		Timers:CreateTimer(0, function()
			local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, area_of_effect, DOTA_UNIT_TARGET_TEAM_BOTH, targetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for _,target in pairs(targets) do
				if not affected[target:GetEntityIndex()] then
					if target:GetTeamNumber() == caster:GetTeamNumber() then
						local mod = target:AddNewModifier(caster, self, "modifier_imba_dazzle_weave_buff", {duration = modifier_duration - times_repeated * repeat_delay})
						if not caster:HasTalent("special_bonus_imba_dazzle_8") then
							mod:SetStackCount(times_repeated * repeat_delay / tick_interval)
						else
							mod:SetStackCount(times_repeated * repeat_delay / (tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")))
						end
					elseif target:GetTeamNumber() ~= caster:GetTeamNumber() then
						local mod = target:AddNewModifier(caster, self, "modifier_imba_dazzle_weave_debuff", {duration = modifier_duration - times_repeated * repeat_delay})
						if not caster:HasTalent("special_bonus_imba_dazzle_8") then
							mod:SetStackCount(times_repeated * repeat_delay / tick_interval)
						else
							mod:SetStackCount(times_repeated * repeat_delay / (tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")))
						end
					end

					table.insert(affected, target:GetEntityIndex(), target)
				end
			end

			self:CreateVisibilityNode(target_point, area_of_effect, vision_duration)
			EmitSoundOnLocationWithCaster(target_point, "Hero_Dazzle.Weave", caster)

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_weave.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 0, target_point)
			ParticleManager:SetParticleControl(particle, 1, Vector(area_of_effect,0,0))
			ParticleManager:ReleaseParticleIndex(particle)

			if times_repeated < repeat_times then
				times_repeated = times_repeated + 1
				return repeat_delay
			end
		end)

	end
end

function imba_dazzle_weave:OnInventoryContentsChanged()
	if IsServer() then
		local caster = self:GetCaster()
		local ressurection = caster:FindAbilityByName("imba_dazzle_ressurection")

		if ressurection then
			if caster:HasScepter() then
				ressurection:SetLevel(1)
				ressurection:SetHidden(false)
				if not caster:HasModifier("modifier_imba_dazzle_ressurection_layout") then
					caster:AddNewModifier(caster, self, "modifier_imba_dazzle_ressurection_layout", {})
				end
			else
				if ressurection:GetLevel() > 0 then
					ressurection:SetLevel(0)
					ressurection:SetHidden(true)
					caster:RemoveModifierByName("modifier_imba_dazzle_ressurection_layout")
				end
			end
		end
	end
end

-----------------------------
-----	Weave ally buff	-----
-----------------------------

if modifier_imba_dazzle_weave_buff == nil then modifier_imba_dazzle_weave_buff = class({}) end
function modifier_imba_dazzle_weave_buff:IsPurgable() return false end
function modifier_imba_dazzle_weave_buff:IsHidden() return false end
function modifier_imba_dazzle_weave_buff:IsDebuff() return false end
function modifier_imba_dazzle_weave_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_imba_dazzle_weave_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_weave_buff:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
		local caster = self:GetAbility():GetCaster()

		if parent:IsBuilding() then
			if caster:HasTalent("special_bonus_imba_dazzle_7") then
				if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_8") then
					tick_interval = tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")
				end
				self:StartIntervalThink(tick_interval)
			end
		else
			if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_8") then
				tick_interval = tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")
			end
			self:StartIntervalThink(tick_interval)
		end

		self.particle =  ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf", PATTACH_OVERHEAD_FOLLOW , parent)
		ParticleManager:SetParticleControlEnt(self.particle, 1, parent, PATTACH_POINT_FOLLOW, "follow_origin", parent:GetAbsOrigin(), true)
	end
end

function modifier_imba_dazzle_weave_buff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_dazzle_weave_buff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_dazzle_weave_buff:GetModifierPhysicalArmorBonus()
	local base = self:GetAbility():GetSpecialValueFor("base_shift")
	local stacked = self:GetAbility():GetSpecialValueFor("stack_shift")

	return stacked * self:GetStackCount() + base
end

---------------------------------
-----	Weave enemy debuff	-----
---------------------------------

if modifier_imba_dazzle_weave_debuff == nil then modifier_imba_dazzle_weave_debuff = class({}) end
function modifier_imba_dazzle_weave_debuff:IsPurgable() return false end
function modifier_imba_dazzle_weave_debuff:IsHidden() return false end
function modifier_imba_dazzle_weave_debuff:IsDebuff() return true end
function modifier_imba_dazzle_weave_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_imba_dazzle_weave_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,}
	return funcs
end

function modifier_imba_dazzle_weave_debuff:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
		local caster = self:GetAbility():GetCaster()

		if parent:IsBuilding() then
			if caster:HasTalent("special_bonus_imba_dazzle_7") then
				if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_8") then
					tick_interval = tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")
				end
				self:StartIntervalThink(tick_interval)
			end
		else
			if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_dazzle_8") then
				tick_interval = tick_interval / caster:FindTalentValue("special_bonus_imba_dazzle_8")
			end
			self:StartIntervalThink(tick_interval)
		end

		self.particle =  ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf", PATTACH_OVERHEAD_FOLLOW , parent)
		ParticleManager:SetParticleControlEnt(self.particle, 1, parent, PATTACH_POINT_FOLLOW, "follow_origin", parent:GetAbsOrigin(), true)
	end
end

function modifier_imba_dazzle_weave_debuff:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_dazzle_weave_debuff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

function modifier_imba_dazzle_weave_debuff:GetModifierPhysicalArmorBonus()
	local base = self:GetAbility():GetSpecialValueFor("base_shift")
	local stacked = self:GetAbility():GetSpecialValueFor("stack_shift")

	return (stacked * self:GetStackCount() + base) * -1
end

-------------------------------------------------------------------------
-------------------------	Ressurection		-------------------------
-------------------------------------------------------------------------

if imba_dazzle_ressurection == nil then imba_dazzle_ressurection = class({}) end

function imba_dazzle_ressurection:GetCastAnimation()
	return ACT_DOTA_SHALLOW_GRAVE end

function imba_dazzle_ressurection:OnAbilityPhaseStart()
	if IsServer() then
		local target_point = self:GetCursorPosition()
		local caster = self:GetCaster()
		local search_radius = self:GetSpecialValueFor("search_radius")

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD, FIND_CLOSEST , false)
		for _,target in pairs(targets) do
			if not target:IsAlive() then
				self.target = target
				return true
			end
		end

		return false
	end
end

function imba_dazzle_ressurection:OnSpellStart()
	if IsServer() then
		local target = self.target
		local caster = self:GetCaster()
		local delay = self:GetSpecialValueFor("delay")

		self:SetActivated(false)

		local castParticle = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_ressurection_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(castParticle)

		local screenParticle = ParticleManager:CreateParticleForPlayer("particles/hero/dazzle/dazzle_ressurection_screen.vpcf", PATTACH_MAIN_VIEW, target, PlayerResource:GetPlayer(target:GetPlayerID()))

		Timers:CreateTimer(delay, function()
			if target:IsAlive() then
				self:SetActivated(true)
				EmitSoundOn("Imba.DazzleRessurectionFail", target)

				ParticleManager:DestroyParticle(screenParticle, true)
				ParticleManager:ReleaseParticleIndex(screenParticle)

				self:EndCooldown()
				self:RefundManaCost()
			else
				self:SetActivated(true)
				target:RespawnHero(false, false)
				FindClearSpaceForUnit(target, caster:GetAbsOrigin(), true)

				ParticleManager:DestroyParticle(screenParticle, true)
				ParticleManager:ReleaseParticleIndex(screenParticle)

				local targetParticle = ParticleManager:CreateParticle("particles/hero/dazzle/dazzle_ressurection_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				ParticleManager:ReleaseParticleIndex(targetParticle)
				EmitGlobalSound("Imba.reincarnationGlobal")
			end
		end)
	end
end

---------------------------------
-----	Skill Layout fix	-----
---------------------------------
modifier_imba_dazzle_ressurection_layout = modifier_imba_dazzle_ressurection_layout or class({})

function modifier_imba_dazzle_ressurection_layout:IsHidden() return true end
function modifier_imba_dazzle_ressurection_layout:IsDebuff() return false end
function modifier_imba_dazzle_ressurection_layout:IsPurgable() return false end
function modifier_imba_dazzle_ressurection_layout:RemoveOnDeath() return false end

function modifier_imba_dazzle_ressurection_layout:GetModifierAbilityLayout()
	return 5 end

function modifier_imba_dazzle_ressurection_layout:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ABILITY_LAYOUT}
	return decFuncs
end

----------------------
-----	Talents	 -----
----------------------
for i = 1,8 do
	LinkLuaModifier("modifier_special_bonus_imba_dazzle_"..i, "components/abilities/heroes/hero_dazzle", LUA_MODIFIER_MOTION_NONE)
end

modifier_special_bonus_imba_dazzle_1 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_2 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_3 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_4 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_5 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_6 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_7 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })

modifier_special_bonus_imba_dazzle_8 = class({
	IsHidden      = function(self) return true  end,
	RemoveOnDeath = function(self) return false end })
