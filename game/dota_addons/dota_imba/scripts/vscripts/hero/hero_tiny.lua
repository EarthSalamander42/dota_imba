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
--
-- limitations under the License.
--
-- Editors:
--     yahnich, 09.06.2017
--     suthernfriend, 03.02.2018

CreateEmptyTalents("tiny")

---------------------------------------
--          ROLLING STONE            --
---------------------------------------
imba_tiny_rolling_stone = imba_tiny_rolling_stone or class({})

function imba_tiny_rolling_stone:GetAbilityTextureName()
	return "custom/imba_tiny_rolling_stone"
end

function imba_tiny_rolling_stone:IsInnateAbility()
	return true
end

function imba_tiny_rolling_stone:GetIntrinsicModifierName()
	return "modifier_imba_tiny_rolling_stone"
end


LinkLuaModifier("modifier_imba_tiny_rolling_stone", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_rolling_stone = class({})

function modifier_imba_tiny_rolling_stone:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed_reduction")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	self.modelscale = self:GetAbility():GetSpecialValueFor("bonus_model_scale")
	self.gain = self:GetAbility():GetSpecialValueFor("stack_per_min")

	self.talent8 = false
	self.talent2 = false

	self.internalTimer = 0
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_imba_tiny_rolling_stone:OnRefresh()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed_reduction")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	self.modelscale = self:GetAbility():GetSpecialValueFor("bonus_model_scale")
	self.modelcap = self:GetAbility():GetSpecialValueFor("max_model_scale")
	self.gain = self:GetAbility():GetSpecialValueFor("stack_per_min")
	self.growscale = 0
end

function modifier_imba_tiny_rolling_stone:OnIntervalThink()
	if self:GetParent():IsIllusion() then
		self:SetStackCount(0)
		return nil
	end

	if self:GetParent():IsMoving() then
		self.internalTimer = self.internalTimer + 0.03 * self.gain
	end
	if self.internalTimer >= 60 then
		self.internalTimer = 0
		self:IncrementStackCount()
	end
	if not self.talent8 then
		if self:GetParent():HasTalent("special_bonus_imba_tiny_8") then
			self.talent8 = true
			self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("special_bonus_imba_tiny_8"), "modifier_special_bonus_imba_tiny_8", {})
		end
	end
	if not self.talent2 then
		if self:GetParent():HasTalent("special_bonus_imba_tiny_2") then
			self.talent2 = true
			self:SetStackCount(self:GetStackCount() + self:GetParent():FindTalentValue("special_bonus_imba_tiny_2") )
		end
	end
end

function modifier_imba_tiny_rolling_stone:IsHidden()
	return false
end

function modifier_imba_tiny_rolling_stone:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_rolling_stone:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_imba_tiny_rolling_stone:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage * self:GetStackCount()
end

function modifier_imba_tiny_rolling_stone:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed * self:GetStackCount()
end

function modifier_imba_tiny_rolling_stone:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():HasModifier("modifier_special_bonus_imba_tiny_8") then
		return self.attackspeed * self:GetStackCount()
	else
		return 0
	end
end

function modifier_imba_tiny_rolling_stone:GetModifierModelScale()
	if IsServer() then
		local scale = self.modelscale * self:GetStackCount() - self.growscale
		if scale > self.modelcap then scale = self.modelcap end
		return scale
	end
end


---------------------------------------
--             AVALANCH              --
---------------------------------------

imba_tiny_avalanche = imba_tiny_avalanche or class({})

function imba_tiny_avalanche:GetAbilityTextureName()
	return "tiny_avalanche"
end

function imba_tiny_avalanche:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
if IsServer() then
	function imba_tiny_avalanche:OnSpellStart()
		local vPos = self:GetCursorPosition()
		local caster = self:GetCaster()

		local delay = self:GetSpecialValueFor("projectile_duration")
		local casterPos = caster:GetAbsOrigin()
		local distance = (vPos - casterPos):Length2D()
		local direction = (vPos - casterPos):Normalized()
		local velocity = distance/delay * direction
		local ticks = 1 / self:GetSpecialValueFor("tick_interval")
		velocity.z = 0

		local info = {
			EffectName = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 0,
			fEndRadius = 0,
			vVelocity = velocity,
			fDistance = distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = 0,
			iUnitTargetType = 0,
			ExtraData = {ticks = ticks}
		}
		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOnLocationWithCaster(vPos, "Ability.Avalanche", caster)
	end

	function imba_tiny_avalanche:OnProjectileHit_ExtraData(hTarget, vLocation, extradata)
		local caster = self:GetCaster()
		local grow_ability = caster:FindAbilityByName("imba_tiny_grow")

		local duration = self:GetSpecialValueFor("stun_duration")
		local toss_mult = self:GetSpecialValueFor("toss_damage_multiplier")
		local radius = self:GetSpecialValueFor("radius")
		if grow_ability then
			radius = radius + caster:FindModifierByName("modifier_imba_tiny_rolling_stone"):GetStackCount() * caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")
		end
		local interval = self:GetSpecialValueFor("tick_interval")
		local damage = self:GetTalentSpecialValueFor("avalanche_damage") * self:GetSpecialValueFor("tick_interval")
		self.repeat_increase = false
		local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(avalanche, 0, vLocation)
		ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1, radius))
		local offset = 0
		local ticks = extradata.ticks
		if self:GetCaster():HasAbility("special_bonus_imba_tiny_3") then
			offset = self:GetCaster():FindTalentValue("special_bonus_imba_tiny_3")
			local projDuration = offset * 0.03 / (ticks * interval)
			local newLoc = vLocation
			local distanceTravelled = 0
			Timers:CreateTimer(function()
				ParticleManager:SetParticleControl(avalanche, 0, newLoc + projDuration)
				newLoc = newLoc + projDuration
				distanceTravelled = distanceTravelled + projDuration
				if distanceTravelled < offset then
					return 0.03
				end
			end)
		end
		local hitLoc = vLocation
		Timers:CreateTimer(function()
			local enemies_tick = FindUnitsInRadius(caster:GetTeamNumber(), hitLoc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for _,enemy in pairs(enemies_tick) do
				if enemy:HasModifier("modifier_tiny_toss_movement") and not self.repeat_increase then
					damage = damage * toss_mult
					self.repeat_increase = true
				end
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = self:GetAbilityDamageType(), ability = self})
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = duration})
			end
			hitLoc = hitLoc + offset / ticks
			extradata.ticks = extradata.ticks - 1
			if extradata.ticks > 0 then
				return interval
			else
				ParticleManager:DestroyParticle(avalanche, false)
				ParticleManager:ReleaseParticleIndex(avalanche)
			end
		end)
	end
end

function imba_tiny_avalanche:GetIntrinsicModifierName()
	return "modifier_imba_tiny_avalanche_passive"
end


LinkLuaModifier("modifier_imba_tiny_avalanche_passive", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_avalanche_passive = class({})
function modifier_imba_tiny_avalanche_passive:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("passive_chance")
	self.prng = -10
end

function modifier_imba_tiny_avalanche_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("passive_chance")
end

function modifier_imba_tiny_avalanche_passive:IsHidden()
	return true
end

function modifier_imba_tiny_avalanche_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_avalanche_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_imba_tiny_avalanche_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return nil
		end

		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if RollPseudoRandom(self.chance, self) then
				local vPos = params.target:GetAbsOrigin()
				local caster = self:GetCaster()
				local delay = self:GetAbility():GetSpecialValueFor("projectile_duration")
				local casterPos = caster:GetAbsOrigin()
				local distance = (vPos - casterPos):Length2D()
				local direction = (vPos - casterPos):Normalized()
				local velocity = distance/delay * direction
				velocity.z = 0

				local ticks = self:GetAbility():GetTalentSpecialValueFor("passive_ticks")

				local info = {
					EffectName = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf",
					Ability = self:GetAbility(),
					vSpawnOrigin = self:GetCaster():GetOrigin(),
					fStartRadius = 0,
					fEndRadius = 0,
					vVelocity = velocity,
					fDistance = distance,
					Source = self:GetCaster(),
					iUnitTargetTeam = 0,
					iUnitTargetType = 0,
					ExtraData = {ticks = ticks}
				}
				ProjectileManager:CreateLinearProjectile( info )
				EmitSoundOnLocationWithCaster(vPos, "Ability.Avalanche", caster)
			end
		end
	end
end

---------------------------------------
--               TOSS                --
---------------------------------------

imba_tiny_toss = imba_tiny_toss or class({})

function imba_tiny_toss:GetAbilityTextureName()
	return "tiny_toss"
end

function imba_tiny_toss:IsNetherWardStealable()
	return false
end

function imba_tiny_toss:OnSpellStart()
	self.tossPosition = self:GetCursorPosition()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	local tossVictim = caster
	local duration = self:GetSpecialValueFor("duration")

	if not hTarget then
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), self.tossPosition, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 1, false)
		for _,target in pairs(targets) do
			hTarget = target
			break
		end
	end
	if hTarget then
		self.tossPosition = hTarget:GetAbsOrigin()
		self.tossTarget = hTarget
	else
		self.tossTarget = nil
	end

	local vLocation = self.tossPosition
	local kv =
		{
			vLocX = vLocation.x,
			vLocY = vLocation.y,
			vLocZ = vLocation.z,
			duration = duration
		}

	local tossVictims = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, 1, false)
	for _, victim in pairs(tossVictims) do
		if victim ~= caster then
			victim:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
			if not self:GetCaster():HasTalent("special_bonus_imba_tiny_7") then
				break
			end
		end
	end

	-- If only Tiny himself was found, launch him instead
	if #tossVictims <= 1 then
		caster:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
	end

	caster:StartGesture(ACT_TINY_TOSS)

	EmitSoundOn("Ability.TossThrow", self:GetCaster())
end


function imba_tiny_toss:GetCastRange(vLocation, hTarget)
	if IsServer() or hTarget then
		return self:GetSpecialValueFor("cast_range")
	elseif hTarget == nil then
		return self:GetSpecialValueFor("grab_radius")
	end
end

function imba_tiny_toss:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

LinkLuaModifier("modifier_tiny_toss_movement", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)

modifier_tiny_toss_movement = modifier_tiny_toss_movement or class({})
function modifier_tiny_toss_movement:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_movement:IsHidden()
	return true
end

function modifier_tiny_toss_movement:IgnoreTenacity()
	return true
end

function modifier_tiny_toss_movement:IsMotionController()
	return true
end

function modifier_tiny_toss_movement:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:OnCreated( kv )
	self.toss_minimum_height_above_lowest = 500
	self.toss_minimum_height_above_highest = 100
	self.toss_acceleration_z = 4000
	self.toss_max_horizontal_acceleration = 3000

	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.toss_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.toss_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.toss_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.toss_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.toss_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.toss_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_tiny_toss_movement:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end


		-- Horizontal motion
		self:HorizontalMotion(self.parent, self.frametime)

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_movement:TossLand()
	if IsServer() then
		-- If the Toss was already completed, do nothing
		if self.toss_land_commenced then
			return nil
		end

		-- Mark Toss as completed
		self.toss_land_commenced = true

		local caster = self:GetCaster()
		local rolling_stone_modifier = caster:FindModifierByName("modifier_imba_tiny_rolling_stone")
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		if rolling_stone_modifier and caster:HasAbility("imba_tiny_grow") then
			radius = radius + rolling_stone_modifier:GetStackCount() * caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")
		end

		-- Destroy trees at the target point
		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, radius, true)

		local victims = FindUnitsInRadius(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 1, false)
		for _, victim in pairs(victims) do
			local damage = self.ability:GetSpecialValueFor("toss_damage")
			if victim == self.parent then
				local damage_multiplier = 1 + self.ability:GetSpecialValueFor("bonus_damage_pct") / 100
				if rolling_stone_modifier then
					damage_multiplier = damage_multiplier + rolling_stone_modifier:GetStackCount() / 100
				end
				damage = damage * damage_multiplier
			end
			if victim:IsBuilding() then
				damage = damage * self.ability:GetSpecialValueFor("building_dmg") * 0.01
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			else
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			end
			if caster:HasScepter() and not victim:IsBuilding() then
				victim:AddNewModifier(caster, self.ability, "modifier_stunned", {duration = self.ability:GetSpecialValueFor("scepter_stun_duration")})
			end
		end
		if self.parent == caster then
			ApplyDamage({victim = caster, attacker = caster, damage = caster:GetMaxHealth() * self.ability:GetSpecialValueFor("self_dmg_pct") * 0.01, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
		end

		EmitSoundOn("Ability.TossImpact", self.parent)
		if caster:HasScepter() and self.parent:IsAlive() and self.parent ~= caster then
			self.parent:AddNewModifier(caster, self.ability, "modifier_tiny_toss_scepter_bounce", {})
		end

		self.parent:SetUnitOnClearGround()
		Timers:CreateTimer(FrameTime(), function()
			ResolveNPCPositions(self.parent:GetAbsOrigin(), 150)
		end)
	end
end

function modifier_tiny_toss_movement:OnDestroy()
	if IsServer() then
		self.parent:SetUnitOnClearGround()
	end
end



--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_tiny_toss_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_movement:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being tossed died, interrupt motion controllers and remove self
		if not self.parent:IsAlive() then
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.toss_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_tiny_toss_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.toss_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.toss_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:TossLand()
		end
	end
end

LinkLuaModifier("modifier_tiny_toss_scepter_bounce", "hero/hero_tiny", LUA_MODIFIER_MOTION_VERTICAL)

modifier_tiny_toss_scepter_bounce = modifier_tiny_toss_scepter_bounce or class({})
function modifier_tiny_toss_scepter_bounce:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_scepter_bounce:IsHidden()
	return true
end

function modifier_tiny_toss_scepter_bounce:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_scepter_bounce:IsMotionController()
	return true
end

function modifier_tiny_toss_scepter_bounce:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:OnCreated( kv )
	if IsServer() then
		if self:ApplyVerticalMotionController() == false then
			self:Destroy()
		end

		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.scepter_bounce_damage_pct = self.ability:GetSpecialValueFor("scepter_bounce_damage_pct")
		self.toss_damage = self.ability:GetSpecialValueFor("toss_damage")

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())
		self.bounce_duration = self:GetAbility():GetSpecialValueFor("scepter_bounce_duration")
		self.time = 0
		self.toss_z = 0
		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_tiny_toss_scepter_bounce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_tiny_toss_scepter_bounce:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_scepter_bounce:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

function modifier_tiny_toss_scepter_bounce:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_scepter_bounce:VerticalMotion( me, dt )
	if IsServer() then

		if self.time < self.bounce_duration then
			self.time = self.time + dt
			if self.bounce_duration/2 > self.time then
				-- Go up
				-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
				self.toss_z = self.toss_z + 25
				-- Set the new location to the current ground location + the memorized z point
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			elseif self.parent:GetAbsOrigin().z > 0 then
				-- Go down
				self.toss_z = self.toss_z - 25
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			end
		else
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end
	end
end

function modifier_tiny_toss_scepter_bounce:OnRemoved()
	if IsServer() then
		local damage = self.toss_damage * self.scepter_bounce_damage_pct * 0.01
		local radius = self:GetAbility():GetSpecialValueFor("radius") + self.caster:FindModifierByName("modifier_imba_tiny_rolling_stone"):GetStackCount() * self.caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")

		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self.caster, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
		end
		self:GetParent():SetUnitOnClearGround()
	end
end

---------------------------------------
--          CRAGGY EXTERIOR          --
---------------------------------------

imba_tiny_craggy_exterior = imba_tiny_craggy_exterior or class({})

function imba_tiny_craggy_exterior:GetIntrinsicModifierName()
	return "modifier_imba_tiny_craggy_exterior_passive"
end

function imba_tiny_craggy_exterior:GetAbilityTextureName()
	return "tiny_craggy_exterior"
end

LinkLuaModifier("modifier_imba_tiny_craggy_exterior_passive", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_craggy_exterior_passive = class({})
function modifier_imba_tiny_craggy_exterior_passive:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("stun_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.prng = -10
end

function modifier_imba_tiny_craggy_exterior_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("stun_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.reduction_duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
end

function modifier_imba_tiny_craggy_exterior_passive:IsHidden()
	return true
end

function modifier_imba_tiny_craggy_exterior_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_craggy_exterior_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_imba_tiny_craggy_exterior_passive:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_imba_tiny_craggy_exterior_passive:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then
			local caster = self:GetCaster()

			if caster:PassivesDisabled() or                                              -- if Tiny is broken, do nothing.
				params.attacker:IsBuilding() or	params.attacker:IsMagicImmune() then         -- if the guy attacking Tiny is a tower or spell immune, do nothing.
				return nil
			end

			if RollPseudoRandom(self.chance, self) then
				if self:GetParent():HasTalent("special_bonus_imba_tiny_4") then
					EmitSoundOn("Hero_Tiny.CraggyExterior", self:GetCaster())
					local radius = self:GetParent():FindTalentValue("special_bonus_imba_tiny_4")
					local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, params.attacker)
					ParticleManager:SetParticleControl(avalanche, 0, params.attacker:GetAbsOrigin())
					ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1, radius))
					Timers:CreateTimer(0.2, function()
						ParticleManager:DestroyParticle(avalanche, false)
						ParticleManager:ReleaseParticleIndex(avalanche)
					end)
					local craggy_targets = FindUnitsInRadius(caster:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
					for _,target in pairs(craggy_targets) do
						ApplyDamage({victim = target, attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
						target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.duration})
						EmitSoundOn("Hero_Tiny.CraggyExterior.Stun", params.attacker)
					end
				else
					ApplyDamage({victim = params.attacker, attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
					params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.duration})
					local craggy = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_craggy_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControl(craggy, 0, self:GetCaster():GetAbsOrigin())
					ParticleManager:SetParticleControl(craggy, 1, params.attacker:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(craggy)
					EmitSoundOn("Hero_Tiny.CraggyExterior", self:GetCaster())
					EmitSoundOn("Hero_Tiny.CraggyExterior.Stun", params.attacker)
				end
			end

			-- Bluntstone

			if not params.attacker:HasModifier("modifier_craggy_exterior_blunt") then
				params.attacker:AddNewModifier(caster, self:GetAbility(), "modifier_craggy_exterior_blunt", {duration = self.reduction_duration})
			end

			local modifier_blunt_handler = params.attacker:FindModifierByName("modifier_craggy_exterior_blunt")
			if modifier_blunt_handler then
				modifier_blunt_handler:IncrementStackCount()
				modifier_blunt_handler:ForceRefresh()
			end
		end
	end
end

LinkLuaModifier("modifier_craggy_exterior_blunt", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_craggy_exterior_blunt = class({})
function modifier_craggy_exterior_blunt:OnCreated()
	self.caster = self:GetCaster()
	self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_craggy_exterior_blunt:OnRefresh()
	self:OnCreated()
end

function modifier_craggy_exterior_blunt:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end

function modifier_craggy_exterior_blunt:GetModifierPreAttack_BonusDamage()
	local reduction = self.reduction + self.caster:FindTalentValue("special_bonus_imba_tiny_5")
	return reduction * self:GetStackCount()
end


---------------------------------------
--          	  GROW 		         --
---------------------------------------
imba_tiny_grow = imba_tiny_grow or class({})

function imba_tiny_grow:GetAbilityTextureName()
	return "tiny_grow"
end

function imba_tiny_grow:GetIntrinsicModifierName()
	return "modifier_imba_tiny_grow_passive"
end


function imba_tiny_grow:OnUpgrade()
	if IsServer() then
		local rolling_stone = self:GetCaster():FindModifierByName("modifier_imba_tiny_rolling_stone")
		rolling_stone.growscale = self:GetSpecialValueFor("rolling_stone_scale_reduction")
		local old_stacks = self:GetLevelSpecialValueFor("rolling_stones_stacks", self:GetLevel() - 2 )
		local new_stacks = self:GetLevelSpecialValueFor("rolling_stones_stacks", self:GetLevel() - 1 )
		if old_stacks == new_stacks then old_stacks = 0 end
		rolling_stone:SetStackCount(rolling_stone:GetStackCount() - old_stacks + new_stacks)
		local level = self:GetLevel() + 1
		if level < 5 then -- model bullshit
			-- Set new model
			self:GetCaster():SetOriginalModel("models/heroes/tiny_0"..level.."/tiny_0"..level..".vmdl")
			self:GetCaster():SetModel("models/heroes/tiny_0"..level.."/tiny_0"..level..".vmdl")
			-- Remove old wearables
			UTIL_Remove(self.head)
			UTIL_Remove(self.rarm)
			UTIL_Remove(self.larm)
			UTIL_Remove(self.body)
			-- Set new wearables
			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_head.vmdl"})
			self.rarm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_right_arm.vmdl"})
			self.larm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_left_arm.vmdl"})
			self.body = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_body.vmdl"})
			-- lock to bone
			self.head:FollowEntity(self:GetCaster(), true)
			self.rarm:FollowEntity(self:GetCaster(), true)
			self.larm:FollowEntity(self:GetCaster(), true)
			self.body:FollowEntity(self:GetCaster(), true)
		end
		-- Effects
		self:GetCaster():StartGesture(ACT_TINY_GROWL)
		EmitSoundOn("Tiny.Grow", self:GetCaster())
		
		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
		ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
	end
end

LinkLuaModifier("modifier_imba_tiny_grow_passive", "hero/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_grow_passive = class({})

function modifier_imba_tiny_grow_passive:OnCreated()
	self.cleave_pct = self:GetAbility():GetSpecialValueFor("bonus_cleave_damage_scepter")
	self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.cleave_startwidth = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_endwidth = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.attackrange = self:GetAbility():GetSpecialValueFor("bonus_range_scepter")
	self.buildingdmg = self:GetAbility():GetSpecialValueFor("bonus_building_damage_scepter")
	self.tree = nil
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_imba_tiny_grow_passive:OnIntervalThink()
	if self:GetCaster():HasScepter() and not self.tree then
		self.tree = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_tree.vmdl"})
		self.tree:FollowEntity(self:GetCaster(), true)
	elseif not self:GetCaster():HasScepter() and self.tree then
		UTIL_Remove(self.tree)
		self.tree = nil
	end
end

function modifier_imba_tiny_grow_passive:IsHidden()
	return true
end

function modifier_imba_tiny_grow_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_grow_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}

	return funcs
end

----------------------------------------------------------------------------

function modifier_imba_tiny_grow_passive:GetModifierAttackRangeBonus( params )
	if self:GetCaster():HasScepter() then
		return self.attackrange
	else
		return 0
	end
end

function modifier_imba_tiny_grow_passive:GetModifierTotalDamageOutgoing_Percentage( params )
	if IsServer() then
		if params.attacker == self:GetParent() and params.target:IsBuilding() and self:GetParent():HasScepter() and not params.inflictor then
			return self.buildingdmg
		end
	end
end



function modifier_imba_tiny_grow_passive:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and not params.target:IsBuilding() and self:GetParent():HasScepter() then
			DoCleaveAttack( params.attacker, params.target, self:GetAbility(), params.damage * self.cleave_pct / 100, self.cleave_startwidth, self.cleave_endwidth, self.cleave_distance, "particles/units/heroes/hero_tiny/tiny_grow_cleave.vpcf" )
		end
	end
end
