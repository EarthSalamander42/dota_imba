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
--		Someone was here before this...but anyways AltiV - June 28th, 2019

LinkLuaModifier("modifier_imba_spectre_haunt", "components/abilities/heroes/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spectre_haunt_self", "components/abilities/heroes/hero_spectre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spectre_haunt_reduce", "components/abilities/heroes/hero_spectre", LUA_MODIFIER_MOTION_NONE)

imba_spectre_reality				= class({})

imba_spectre_haunt_single			= class({})

imba_spectre_haunt					= class({})
modifier_imba_spectre_haunt			= class({})
modifier_imba_spectre_haunt_self	= class({})
modifier_imba_spectre_haunt_reduce	= class({})

-------------
-- REALITY --
-------------

function imba_spectre_reality:GetAssociatedSecondaryAbilities()
	return "imba_spectre_haunt"
end

function imba_spectre_reality:ProcsMagicStick() return false end

function imba_spectre_reality:OnSpellStart()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
	
	local self_haunt_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spectre_haunt_self", self:GetCaster())
		
	if self_haunt_modifier then
		for _, enemy in pairs(enemies) do
			if enemy:FindModifierByNameAndCaster("modifier_imba_spectre_haunt", self:GetCaster()) and enemy ~= self_haunt_modifier.current_target then
				FindClearSpaceForUnit(self:GetCaster(), enemy:GetAbsOrigin() + RandomVector(256), false)
				self:GetCaster():FaceTowards(enemy:GetAbsOrigin())
				
				self:GetCaster():EmitSound("Hero_Spectre.Reality")
				
				self_haunt_modifier.current_target = enemy
				break
			end
		end
	end
end

-----------------
-- SHADOW STEP --
-----------------

function imba_spectre_haunt_single:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)
	else
		self:SetHidden(true)
	end
end

function imba_spectre_haunt_single:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_spectre_haunt_single:OnSpellStart()
	if not self:GetCursorTarget():TriggerSpellAbsorb(self) then
		self:GetCaster():EmitSound("Hero_Spectre.HauntCast")
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spectre_haunt_self", {duration = self:GetSpecialValueFor("duration")})
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_spectre_haunt", {duration = self:GetSpecialValueFor("duration")})
	end
end

-----------
-- HAUNT --
-----------

function imba_spectre_haunt:GetAssociatedPrimaryAbilities()
	return "imba_spectre_reality"
end

function imba_spectre_haunt:OnUpgrade()
	local reality_ablity = self:GetCaster():FindAbilityByName("imba_spectre_reality")
	
	if reality_ablity and not reality_ablity:IsTrained() and self:GetLevel() >= 1 then
		reality_ablity:SetLevel(1)
		reality_ablity:SetActivated(true)
	end
	
	local shadow_step_ability = self:GetCaster():FindAbilityByName("imba_spectre_haunt_single")
	
	if shadow_step_ability then
		shadow_step_ability:SetLevel(self:GetLevel())
	end
end

function imba_spectre_haunt:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Spectre.HauntCast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spectre_haunt_self", {duration = self:GetSpecialValueFor("duration")})

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_spectre_haunt", {duration = self:GetSpecialValueFor("duration")})
	end
end

--------------------
-- HAUNT MODIFIER --
--------------------

function modifier_imba_spectre_haunt:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_spectre_haunt:IgnoreTenacity()	return true end
function modifier_imba_spectre_haunt:IsPurgable()		return false end

function modifier_imba_spectre_haunt:GetEffectName()
	return "particles/units/heroes/hero_spectre/spectre_ambient.vpcf"
end

function modifier_imba_spectre_haunt:OnCreated()
	self.illusion_damage_outgoing	= self:GetAbility():GetSpecialValueFor("illusion_damage_outgoing")
	self.attack_delay				= self:GetAbility():GetSpecialValueFor("attack_delay")
	self.spawn_distance				= self:GetAbility():GetSpecialValueFor("spawn_distance")
	self.travel_speed				= self:GetAbility():GetSpecialValueFor("travel_speed")
	
	if not IsServer() then return end
	
	self.self_haunt_modifier		= self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spectre_haunt_self", self:GetCaster())
	self.location					= self:GetParent():GetAbsOrigin() + RandomVector(self.spawn_distance)
	
	self:GetParent():EmitSound("Hero_Spectre.Haunt")
	
	local death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(death_particle, 0, self.location)
	ParticleManager:ReleaseParticleIndex(death_particle)
	
	self:StartIntervalThink(self.attack_delay)
end

function modifier_imba_spectre_haunt:OnIntervalThink()
	if not IsServer() then return end
	
	if (self:GetParent():GetAbsOrigin() - self.location):Length2D() <= self.travel_speed then
		self.location = self:GetParent():GetAbsOrigin()
		
		if not self:GetParent():IsInvisible() and not self:GetParent():IsInvulnerable() and not self:GetParent():IsOutOfGame() and not self:GetParent():IsAttackImmune() and self:GetCaster():IsAlive() and (self.self_haunt_modifier and self.self_haunt_modifier.current_target ~= self:GetParent()) and not IsNearFountain(self:GetParent():GetAbsOrigin(), 1200) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_spectre_haunt_reduce", {illusion_damage_outgoing = self.illusion_damage_outgoing})
			self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)
			self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_spectre_haunt_reduce", self:GetCaster())
		end
	else
		self.location = self.location + (self:GetParent():GetAbsOrigin() - self.location):Normalized() * self.travel_speed
	end
	
	if (self.self_haunt_modifier and self.self_haunt_modifier.current_target ~= self:GetParent()) then
		local death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(death_particle, 0, self.location)
		ParticleManager:ReleaseParticleIndex(death_particle)
	end
end

function modifier_imba_spectre_haunt:CheckState()
	return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

function modifier_imba_spectre_haunt:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
	}
end

function modifier_imba_spectre_haunt:GetBonusVisionPercentage()
	if self:GetElapsedTime() <= (self:GetAbility():GetSpecialValueFor("attack_delay") or self.attack_delay) then
		return -100
	end
end

-------------------------
-- SELF HAUNT MODIFIER --
-------------------------

function modifier_imba_spectre_haunt_self:IsPurgable()		return false end
function modifier_imba_spectre_haunt_self:RemoveOnDeath()	return false end

function modifier_imba_spectre_haunt_self:OnCreated()
	if not IsServer() then return end

	self.current_target = nil

	local death_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_death_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(death_particle)
end

function modifier_imba_spectre_haunt_self:OnRefresh()
	if not IsServer() then return end

	self:OnCreated()
end

---------------------------
-- HAUNT REDUCE MODIFIER --
---------------------------

function modifier_imba_spectre_haunt_reduce:IsHidden()		return true end
function modifier_imba_spectre_haunt_reduce:IsPurgable()	return false end

function modifier_imba_spectre_haunt_reduce:OnCreated(params)
	if not IsServer() then return end
	
	self.illusion_damage_outgoing	= params.illusion_damage_outgoing
end

function modifier_imba_spectre_haunt_reduce:DeclareFunctions()
	return {MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE}
end

function modifier_imba_spectre_haunt_reduce:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then return end
	
	if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		return -100
	else
		return self.illusion_damage_outgoing + self:GetCaster():FindTalentValue("special_bonus_unique_spectre_4")
	end
end

-- Old, "correct but holy shit laggy" version
-- imba_spectre_haunt = imba_spectre_haunt or class({})

-- LinkLuaModifier("modifier_imba_spectre_haunt_illusion", "components/abilities/heroes/hero_spectre", LUA_MODIFIER_MOTION_NONE)

-- function imba_spectre_haunt:IsNetherWardStealable() return false end
-- function imba_spectre_haunt:GetAbilityTextureName() return "spectre_haunt" end
-- function imba_spectre_haunt:GetCastPoint() return 0.3 end
-- function imba_spectre_haunt:GetBackswingTime() return 0.5 end
-- function imba_spectre_haunt:GetAssociatedPrimaryAbilities() return "imba_spectre_reality" end

-- function imba_spectre_haunt:OnUpgrade()
	-- local reality_ability = self:GetCaster():FindAbilityByName("imba_spectre_reality")
	-- if reality_ability and reality_ability:GetLevel() < 1 then
		-- reality_ability:SetLevel(1)
	-- end
-- end

-- function imba_spectre_haunt:OnSpellStart()
	-- if not IsServer() then
		-- return
	-- end
	-- -- ability values
	-- local haunt_sound_cast = "Hero_Spectre.HauntCast"
	-- local haunt_sound_enemy = "Hero_Spectre.Haunt"
	-- local additional_modifiers = { "modifier_imba_spectre_haunt_illusion" } -- extra modifiers that are grante to Spectre illusions (contains min speed/flying movement)
	-- local spawn_distance = 58 -- illusion spawn distance from enemy

-- --	if not self.spawned_illusions then
		-- self.spawned_illusions = {}
-- --	end

	-- self.expire_time = GameRules:GetGameTime() + self:GetSpecialValueFor("duration")

	-- local caster = self:GetCaster()
	-- local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	-- for _, enemy in pairs(enemies) do
		-- if enemy:IsRealHero() and enemy:IsAlive() then
			-- local enemy_position = enemy:GetAbsOrigin()

			-- local spawn_angle = RandomInt(0, 90)
			-- local spawn_dx = spawn_distance * math.sin(spawn_angle)
			-- local spawn_dy = spawn_distance * math.cos(spawn_angle)
			-- -- Make 2 rolls to randomize the spawn position in a "good enough" way
			-- if RandomInt(0, 1) == 1 then
				-- spawn_dx = -spawn_dx
			-- end
			-- if RandomInt(0, 1) == 1 then
				-- spawn_dy = -spawn_dy
			-- end
			-- local spawn_pos = Vector(enemy_position.x + spawn_dx, enemy_position.y + spawn_dy, enemy_position.z)
			-- local inc = self:GetSpecialValueFor("illusion_dmg_received") - 100
			-- local out = self:GetSpecialValueFor("illusion_dmg_dealt") - 100

			-- self:GetCaster():CreateIllusion(self:GetSpecialValueFor("duration"), inc, out, spawn_pos, additional_modifiers, self)
			-- EmitSoundOn(haunt_sound_enemy, enemy)
		-- end
	-- end

	-- EmitSoundOn(haunt_sound_cast, caster)
-- end

-- -- Spectre Illusion modifier (set absolute speed + command restrict + flying pathing)
-- modifier_imba_spectre_haunt_illusion = modifier_imba_spectre_haunt_illusion or class({})
-- function modifier_imba_spectre_haunt_illusion:IsPurgable() return false end
-- function modifier_imba_spectre_haunt_illusion:IsHidden() return true end

-- function modifier_imba_spectre_haunt_illusion:OnCreated( kv )
	-- -- Ability values
	-- self.absolute_min_speed = self:GetAbility():GetSpecialValueFor("illusion_base_speed") or 400 -- Vanilla Dota 2 has this as absolute speed (cannot be increased), but this is IMBA, so buff
	-- self.activation_delay = 1.0 -- Vanilla Dota 2 delay from when illusion spawns to when it gets to move/attack
	-- self.tick_rate = 0.5 -- ordering unit to attack/move-to

	-- if IsServer() then
		-- --print("modifier_imba_spectre_haunt_illusion:OnCreated")
		-- self.parent = self:GetParent()
		-- self.caster = self:GetCaster()
		-- --print("Parent's entindex : ", self.parent:entindex())
		-- self.ability = self:GetAbility()
		-- self.caster_attack_cap = self.caster:GetAttackCapability() -- Fucking Rubick

		-- -- illusion index, since illusions aren't deleted - this is for Reality ability
		-- if self.ability.spawned_illusions and self.ability.spawned_illusions[self.parent:entindex()] == nil then
			-- --print("Adding ourselves to illusion table")
			-- self.ability.spawned_illusions[self.parent:entindex()] = self.parent
		-- end

		-- --print(self.parent:GetForceAttackTarget():GetName())

		-- -- Target is initialized before modifiers are added/reset
		-- self.target = self.parent:GetForceAttackTarget()
		-- if not self.expire_time or GameRules:GetGameTime() > self.expire_time then
			-- -- Ability tracking stuff
			-- self.first_activation = true -- for different first OnIntervalThink delay
			-- self.expire_time = GameRules:GetGameTime() + self:GetDuration() -- To buff Refresher Orb - doesn't cause the activation delay

			-- --self.parent:SetAcquisitionRange(0)
			-- self.parent:SetForceAttackTarget(nil)
			-- --self.parent:SetIdleAcquire(false)
			-- self.parent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			-- self.parent:Stop()

			-- self:StartIntervalThink(self.activation_delay)
		-- end
	-- end
-- end

-- function modifier_imba_spectre_haunt_illusion:OnIntervalThink()
	-- if IsServer() then
		-- if self.parent:GetAttackCapability() ~= self.caster_attack_cap then
			-- self.parent:SetAttackCapability(self.caster_attack_cap)
		-- end
		-- -- If illusion becomes inactive (dead/expired), then stop everything
		-- if self.parent.active == 0 then
			-- --print("Deactivating illusion")
			-- self.parent:SetForceAttackTarget(nil)
			-- self.parent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			-- self.parent:Stop()
			-- self:StartIntervalThink(-1)
			-- return
		-- end

		-- if self.target and self.target:IsAlive() then
			-- if self.target:IsImbaInvisible() then
				-- --print("Moving to invisible unit")
				-- self.parent:MoveToNPC(self.target)
			-- else
				-- if self.parent:GetForceAttackTarget() ~= self.target then
					-- --print("Setting attack target")
					-- self.parent:SetForceAttackTarget(self.target)
				-- end
			-- end
		-- else
			-- --print("Stopping parent")
			-- self.parent:SetForceAttackTarget(nil)
			-- self.parent:Stop()
		-- end
		-- --[[
		-- self.CheckState = function(self)
			-- return { [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
					 -- [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
					 -- [MODIFIER_STATE_UNSELECTABLE] = true}
		-- end
		-- ]]

		-- -- If we were activated due to delay (rather than tickrate), set our interval to the tick rate
		-- if self.first_activation then
			-- self.first_activation = false
			-- self:StartIntervalThink(-1)
			-- self:StartIntervalThink(self.tick_rate)
		-- end
	-- end
-- end

-- function modifier_imba_spectre_haunt_illusion:CheckState()
	-- return { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true }
-- end

-- function modifier_imba_spectre_haunt_illusion:DeclareFunctions()
	-- return { MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN }
-- end

-- function modifier_imba_spectre_haunt_illusion:GetModifierMoveSpeed_AbsoluteMin()
	-- return self.absolute_min_speed
-- end

-- -----------------------------------------------------------------
-- -- Spectre's Reality
-- -----------------------------------------------------------------
-- imba_spectre_reality = imba_spectre_reality or class({})
-- function imba_spectre_reality:IsStealable() return false end
-- function imba_spectre_reality:IsNetherWardStealable() return false end
-- function imba_spectre_reality:GetCastPoint() return 0 end
-- function imba_spectre_reality:GetBackswingTime() return 0.7 end
-- function imba_spectre_reality:GetAbilityTextureName() return "spectre_reality" end

-- function imba_spectre_reality:OnSpellStart()
	-- if not IsServer() then
		-- return
	-- end
	-- -- ability values
	-- local reality_sound = "Hero_Spectre.Reality"

	-- local caster = self:GetCaster()
	-- local haunt_ability = caster:FindAbilityByName("imba_spectre_haunt")
	-- -- if we don't have the haunt ability (somehow), or the ability isn't currently active, don't do anything
	-- if not haunt_ability or not haunt_ability.expire_time or haunt_ability.expire_time < GameRules:GetGameTime() then
		-- --print("Ability not found or expired")
		-- return
	-- end

	-- -- if haunt has spawned illusions, we loop through them to find active ones and check their distance to us
	-- -- to find the closest one
	-- if haunt_ability.spawned_illusions then
		-- local cursor_pos = self:GetCursorPosition()
		-- local closest_illusion
		-- local illusion_count = 0
		-- for entindex, illusion in pairs(haunt_ability.spawned_illusions) do
			-- illusion_count = illusion_count + 1
-- --			if illusion.active == 1 then
				-- local distance = (cursor_pos - illusion:GetAbsOrigin()):Length2D()
				-- if ( not closest_illusion ) or ( distance < (cursor_pos - closest_illusion:GetAbsOrigin()):Length2D() ) then
					-- closest_illusion = illusion
				-- end
-- --			end
		-- end

		-- -- If we found a closest illusion, swap our positions
		-- if closest_illusion then
			-- -- You're about to get shanked!
			-- local temp_pos = closest_illusion:GetAbsOrigin()
			-- EmitSoundOnLocationWithCaster(temp_pos, reality_sound, caster)
			-- closest_illusion:SetAbsOrigin(caster:GetAbsOrigin())
			-- caster:SetAbsOrigin(temp_pos)
			-- -- ...also set our attack target to the illusions target, for Quality of Life and less clicking
			-- caster:MoveToTargetToAttack(closest_illusion:GetForceAttackTarget())
		-- end
	-- else
		-- print("Haunt ability illusion table not found")
	-- end
-- end
