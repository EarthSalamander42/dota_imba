-- Creator:
--	   AltiV, January 28th, 2020

LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_pre_flight", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon_speed_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon_side_gunner", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_lock_on_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_lock_on", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_gatling_guns", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_call_down_thinker", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_call_down_slow", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

imba_gyrocopter_rocket_barrage						= imba_gyrocopter_rocket_barrage or class({})
modifier_imba_gyrocopter_rocket_barrage				= modifier_imba_gyrocopter_rocket_barrage or class({})
modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression	= modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression or class({})

imba_gyrocopter_homing_missile						= imba_gyrocopter_homing_missile or class({})
modifier_imba_gyrocopter_homing_missile_handler		= modifier_imba_gyrocopter_homing_missile_handler or class({})
modifier_imba_gyrocopter_homing_missile_pre_flight	= modifier_imba_gyrocopter_homing_missile_pre_flight or class({})
modifier_imba_gyrocopter_homing_missile				= modifier_imba_gyrocopter_homing_missile or class({})

imba_gyrocopter_flak_cannon							= imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon				= modifier_imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon_speed_handler	= modifier_imba_gyrocopter_flak_cannon_speed_handler or class({})
modifier_imba_gyrocopter_flak_cannon_side_gunner	= modifier_imba_gyrocopter_flak_cannon_side_gunner or class({})

imba_gyrocopter_lock_on								= imba_gyrocopter_lock_on or class({})
modifier_imba_gyrocopter_lock_on_handler			= modifier_imba_gyrocopter_lock_on_handler or class({})
modifier_imba_gyrocopter_lock_on					= modifier_imba_gyrocopter_lock_on or class({})

imba_gyrocopter_gatling_guns						= imba_gyrocopter_gatling_guns or class({})
modifier_imba_gyrocopter_gatling_guns				= modifier_imba_gyrocopter_gatling_guns or class({})

imba_gyrocopter_call_down							= imba_gyrocopter_call_down or class({})
modifier_imba_gyrocopter_call_down_thinker			= modifier_imba_gyrocopter_call_down_thinker or class({})
modifier_imba_gyrocopter_call_down_slow				= modifier_imba_gyrocopter_call_down_slow or class({})

------------------------------------
-- IMBA_GYROCOPTER_ROCKET_BARRAGE --
------------------------------------

function imba_gyrocopter_rocket_barrage:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.Rocket_Barrage")

	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and RollPercentage(75) then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_rocket_barrage_01",
				"gyrocopter_gyro_rocket_barrage_02",
				"gyrocopter_gyro_rocket_barrage_04",
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_rocket_barrage", {duration = self:GetDuration()})
end

function imba_gyrocopter_rocket_barrage:OnProjectileHit(target, location)
	if target then
		target:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
	
		self.ballistic_modifier	= target:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", {duration = self:GetSpecialValueFor("ballistic_duration")})
		
		if self.ballistic_modifier then
			self.ballistic_modifier:SetDuration(self:GetSpecialValueFor("ballistic_duration") * (1 - target:GetStatusResistance()), true)
		end
		
		self.ballistic_modifier = nil
	
		ApplyDamage({
			victim 			= target,
			damage 			= self:GetTalentSpecialValueFor("rocket_damage"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		
		return true
	end
end

---------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_ROCKET_BARRAGE --
---------------------------------------------

function modifier_imba_gyrocopter_rocket_barrage:OnCreated()
	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second")
	
	if not IsServer() then return end
	
	self.rocket_damage	= self:GetAbility():GetTalentSpecialValueFor("rocket_damage")
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self.weapons		= {"attach_attack1", "attach_attack2"}
	
	self:StartIntervalThink(1 / self.rockets_per_second)
end

function modifier_imba_gyrocopter_rocket_barrage:OnRefresh()
	self:OnCreated()
end

function modifier_imba_gyrocopter_rocket_barrage:OnIntervalThink()
	-- "Does not fire rockets while Gyrocopter is hidden."
	if not self:GetParent():IsOutOfGame() then
		-- TODO: Add Logic for Lock-On here
		if 1 == 0 then
		
		else
			self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
			self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
		
			if #self.enemies >= 1 then
				for _, enemy in pairs(self.enemies) do
					enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
					
					self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(self.barrage_particle)

					self.ballistic_modifier	= target:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", {duration = self:GetSpecialValueFor("ballistic_duration")})
					
					if self.ballistic_modifier then
						self.ballistic_modifier:SetDuration(self:GetSpecialValueFor("ballistic_duration") * (1 - target:GetStatusResistance()), true)
					end
					
					self.ballistic_modifier = nil
		
					ApplyDamage({
						victim 			= enemy,
						damage 			= self.rocket_damage,
						damage_type		= self.damage_type,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self:GetCaster(),
						ability 		= self:GetAbility()
					})
					break
				end
			else
				ProjectileManager:CreateLinearProjectile({
					EffectName	= "",
					Ability		= self:GetAbility(),
					Source		= self:GetCaster(),
					vSpawnOrigin	= self:GetParent():GetAbsOrigin(),
					vVelocity	= self:GetParent():GetForwardVector() * 2400,
					vAcceleration	= nil, --hmm...
					fMaxSpeed	= nil, -- What's the default on this thing?
					fDistance	= 1200,
					fStartRadius	= 25,
					fEndRadius		= 25,
					fExpireTime		= nil,
					iUnitTargetTeam	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					bIgnoreSource		= true,
					bHasFrontalCone		= false,
					bDrawsOnMinimap		= false,
					bVisibleToEnemies	= true,
					bProvidesVision		= false,
					iVisionRadius		= nil,
					iVisionTeamNumber	= nil,
					ExtraData			= {}
				})
			end
		end
	end
end

-------------------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_ROCKET_BARRAGE_BALLISTIC_SUPPRESSION --
-------------------------------------------------------------------

function modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression:OnCreated()
	self.ballistic_spell_amp_reduction	= self:GetAbility():GetSpecialValueFor("ballistic_spell_amp_reduction") * (-1)
	
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression:OnRefresh()
	self:OnCreated()
end

function modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression:GetModifierSpellAmplify_Percentage()
	return self.ballistic_spell_amp_reduction * self:GetStackCount()
end

------------------------------------
-- IMBA_GYROCOPTER_HOMING_MISSILE --
------------------------------------

function imba_gyrocopter_homing_missile:GetIntrinsicModifierName()
	return "modifier_imba_gyrocopter_homing_missile_handler"
end

function imba_gyrocopter_homing_missile:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_gyrocopter_homing_missile_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end
--------------------------------------------------------------------------------

-- function imba_gyrocopter_homing_missile:CastFilterResultTarget( target )
	-- local default_result = self.BaseClass.CastFilterResultTarget(self, target)
	-- return default_result
-- end

function imba_gyrocopter_homing_missile:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_homing_missile_fire_02",
				"gyrocopter_gyro_homing_missile_fire_03",
				"gyrocopter_gyro_homing_missile_fire_04",
				"gyrocopter_gyro_homing_missile_fire_06",
				"gyrocopter_gyro_homing_missile_fire_07"
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end
	
	-- "When Cast, a stationary missile is placed 150 range in front of Gyrocopter, which begins to move 3 seconds later."
	local missile = CreateUnitByName("npc_dota_gyrocopter_homing_missile", self:GetCaster():GetAbsOrigin() + ((self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * 150), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile_pre_flight", {duration = self:GetSpecialValueFor("pre_flight_time"), bAutoCast = self:GetAutoCastState()})
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile", {bAutoCast = self:GetAutoCastState()})

	if not self:GetAutoCastState() then
		missile:SetForwardVector((self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized())
		-- missile:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	else
		missile:SetForwardVector(self:GetCaster():GetForwardVector())
	end
	
	-- The fuse isn't following the rope...
	local fuse_particle = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_homing_missile_fuse.vpcf", PATTACH_ABSORIGIN, missile)
	ParticleManager:SetParticleControlForward(fuse_particle, 0, missile:GetForwardVector() * (-1))
	-- ParticleManager:SetParticleControl(fuse_particle, 0, missile:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(fuse_particle)
end

-----------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_HOMING_MISSILE_HANDLER --
-----------------------------------------------------

function modifier_imba_gyrocopter_homing_missile_handler:IsHidden()			return true end
function modifier_imba_gyrocopter_homing_missile_handler:IsPurgable()		return false end
function modifier_imba_gyrocopter_homing_missile_handler:RemoveOnDeath()	return false end
function modifier_imba_gyrocopter_homing_missile_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_gyrocopter_homing_missile_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_gyrocopter_homing_missile_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

--------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_HOMING_MISSILE_PRE_FLIGHT --
--------------------------------------------------------

function modifier_imba_gyrocopter_homing_missile_pre_flight:IsHidden()		return true end
function modifier_imba_gyrocopter_homing_missile_pre_flight:IsPurgable()	return false end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnCreated(keys)
	self.speed						= self:GetAbility():GetSpecialValueFor("speed")

	-- "Homing Missile's initial speed is 500 and increases by 20 per second, growing by 1 every 0.05 seconds."
	-- Going to be higher than 20 here
	self.interval					= 1 / self:GetAbility():GetSpecialValueFor("acceleration")
	
	if not IsServer() then return end
	
	self.bAutoCast = keys.bAutoCast
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile")
	
	print(keys.bAutoCast)
	
	if keys.bAutoCast == 0 then
		self.target	= self:GetAbility():GetCursorTarget()
	else
		self.target = nil
	end
end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnDestroy()
	if not IsServer() then return end
	
	if not self:GetParent():IsAlive() then return end
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Enemy")
	
	if self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile") then
		-- Okay so this part I don't understand at all; if I don't set controllable by player, the missile won't fly at all EXCEPT when the ability is level 1. This is non-vanilla behaviour to make the missile selectable (as in highlighted green bar), but I can't figure this out right now
		self:GetParent():SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		
		if self.target and not self.target:IsNull() and self.target:IsAlive() then
			self:GetParent():MoveToNPC(self.target)
			-- self:GetParent():SetControllableByPlayer(nil, true) -- Doesn't work
		end
		
		self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile"):StartIntervalThink(self.interval)	
		
		local missile_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(missile_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_fuse", self:GetParent():GetAbsOrigin(), true)
		self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile"):AddParticle(missile_particle, false, false, -1, false, false)
	else
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end

---------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_HOMING_MISSILE --
---------------------------------------------

function modifier_imba_gyrocopter_homing_missile:IsHidden()		return true end
function modifier_imba_gyrocopter_homing_missile:IsPurgable()	return false end

function modifier_imba_gyrocopter_homing_missile:OnCreated(keys)
	self.hits_to_kill_tooltip		= self:GetAbility():GetSpecialValueFor("hits_to_kill_tooltip")
	self.tower_hits_to_kill_tooltip	= self:GetAbility():GetSpecialValueFor("tower_hits_to_kill_tooltip")
	self.attack_speed_bonus_pct		= self:GetAbility():GetSpecialValueFor("attack_speed_bonus_pct")
	self.min_damage					= self:GetAbility():GetSpecialValueFor("min_damage")
	self.max_distance				= self:GetAbility():GetSpecialValueFor("max_distance")
	self.pre_flight_time			= self:GetAbility():GetSpecialValueFor("pre_flight_time")
	self.hero_damage				= self:GetAbility():GetSpecialValueFor("hero_damage")
	self.speed						= self:GetAbility():GetSpecialValueFor("speed")
	self.acceleration				= self:GetAbility():GetSpecialValueFor("acceleration")
	self.enemy_vision_time			= self:GetAbility():GetSpecialValueFor("enemy_vision_time")
	
	if not IsServer() then return end
	
	self.stun_duration				= self:GetAbility():GetTalentSpecialValueFor("stun_duration")
	
	self.damage						= self:GetAbility():GetAbilityDamage()
	self.damage_type				= self:GetAbility():GetAbilityDamageType()
	
	if keys.bAutoCast == 0 then
		self.target	= self:GetAbility():GetCursorTarget()
	else
		self.target = nil
	end
	
	self.interval					= 1 / self.acceleration
	-- This tracks how much additional speed (on top of base) the missile will be moving at
	self.speed_counter				= 0
	
	self.target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target)
	self:AddParticle(self.target_particle, false, false, -1, false, false)
end

-- Missile has hull radius of 24
function modifier_imba_gyrocopter_homing_missile:OnIntervalThink()
	self.speed_counter	= self.speed_counter + 1
	self:SetStackCount(self.speed_counter)
	
	if self.target then
		-- Arbitrary change of target handling as missile gets close (so it can overlap and count collision detection)
		if (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 250 then
			self:GetParent():MoveToNPC(self.target)
		else
			self:GetParent():MoveToPosition(self.target:GetAbsOrigin())
		end
	
		if (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():GetHullRadius() then
			self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
			self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			
			if not self.target:IsMagicImmune() then
				-- "The rocket first applies the debuff, then the damage."
				local stun_modifier	= self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
				
				if stun_modifier then
					stun_modifier:SetDuration(self.stun_duration * (1 - self.target:GetStatusResistance()), true)
				end
				
				ApplyDamage({
					victim 			= self.target,
					damage 			= self.damage,
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
				
				if not self.target:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
					if not self.responses then
						self.responses = 
						{
							"gyrocopter_gyro_homing_missile_impact_01",
							"gyrocopter_gyro_homing_missile_impact_02",
							"gyrocopter_gyro_homing_missile_impact_05",
							"gyrocopter_gyro_homing_missile_impact_06",
							"gyrocopter_gyro_homing_missile_impact_07",
							"gyrocopter_gyro_homing_missile_impact_08"
						}
					end
					
					self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
				end
			end
			
			-- "If the missile hits its target, its 400 range flying vision stays at the location for 3.5 seconds."
			AddFOWViewer(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), 400, self.enemy_vision_time, false)
			
			local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_particle)
			
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
		end
		-- print((self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D())
		-- print(self.target:GetHullRadius())
	else
	
	end
end

-- particles/units/heroes/hero_gyrocopter/gyro_guided_missile_death.vpcf
-- particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf

function modifier_imba_gyrocopter_homing_missile:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile")
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy")
end

function modifier_imba_gyrocopter_homing_missile:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]						= true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS]	= true,
		[MODIFIER_STATE_IGNORING_STOP_ORDERS]				= true
	}
end

function modifier_imba_gyrocopter_homing_missile:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		MODIFIER_EVENT_ON_ATTACKED
	}
end

function modifier_imba_gyrocopter_homing_missile:GetModifierMoveSpeed_Absolute()
	if self:GetElapsedTime() < self.pre_flight_time then
		return 0
	else
		return self.speed + self:GetStackCount()
	end
end

function modifier_imba_gyrocopter_homing_missile:GetModifierMoveSpeed_Limit()
	if self:GetElapsedTime() < self.pre_flight_time then
		return -0.01
	else
		return self.speed + self:GetStackCount()
	end
end

function modifier_imba_gyrocopter_homing_missile:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_imba_gyrocopter_homing_missile:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_gyrocopter_homing_missile:GetAbsoluteNoDamagePure()
    return 1
end

-- "Hero_Gyrocopter.HomingMissile.Destroy"
-- "Hero_Gyrocopter.HomingMissile.Target"

function modifier_imba_gyrocopter_homing_missile:OnAttacked(keys)
	if keys.target == self:GetParent() then
		if keys.attacker:IsHero() or keys.attacker:IsIllusion() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - self.hero_damage)
		elseif keys.attacker:IsBuilding() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self.hero_damage / 2))
		end
		
		if self:GetParent():GetHealth() <= 0 then
			self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			self:GetParent():Kill(nil, keys.attacker)
			self:GetParent():AddNoDraw()
		end
	end
end

---------------------------------
-- IMBA_GYROCOPTER_FLAK_CANNON --
---------------------------------

-- Already built into hero as vanilla so this isn't required

-- function imba_gyrocopter_flak_cannon:GetIntrinsicModifierName()
	-- return "modifier_imba_gyrocopter_flak_cannon_side_gunner"
-- end

-- function imba_gyrocopter_flak_cannon:OnInventoryContentsChanged()
	-- if self:GetIntrinsicModifierName() and self:GetCaster():HasModifier(self:GetIntrinsicModifierName()) then
		-- if self:GetCaster():HasScepter() then
			-- self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(self:GetSpecialValueFor("fire_rate"))
		-- else
			-- self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(-1)
		-- end
	-- end
-- end

-- function imba_gyrocopter_flak_cannon:OnHeroCalculateStatBonus()
	-- self:OnInventoryContentsChanged()
-- end

function imba_gyrocopter_flak_cannon:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.FlackCannon.Activate")

	-- Vanilla particle effect refreshes on modifier reapplication too
	self:GetCaster():RemoveModifierByName("modifier_imba_gyrocopter_flak_cannon")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_flak_cannon", {duration = self:GetDuration()})
end

function imba_gyrocopter_flak_cannon:OnProjectileHit_ExtraData(target, location, data)
	if target then
		-- TODO: Figure out how to do this without the attack sound upon impact
		self:GetCaster():PerformAttack(target, false, false, true, true, false, false, false)
	end
end

------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_FLAK_CANNON --
------------------------------------------

function modifier_imba_gyrocopter_flak_cannon:GetEffectName()
	return "particles/units/heroes/hero_gyrocopter/gyro_flak_cannon_overhead.vpcf"
end

function modifier_imba_gyrocopter_flak_cannon:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_gyrocopter_flak_cannon:OnCreated()
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.max_attacks		= self:GetAbility():GetSpecialValueFor("max_attacks")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	
	if not IsServer() then return end
	
	self.weapons			= {"attach_attack1", "attach_attack2"}
	
	self:SetStackCount(self.max_attacks)
end

-- function modifier_imba_gyrocopter_flak_cannon:OnRefresh()
	-- self:OnCreated()
-- end

function modifier_imba_gyrocopter_flak_cannon:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_imba_gyrocopter_flak_cannon:OnAttack(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown then
		self:GetParent():EmitSound("Hero_Gyrocopter.FlackCannon")
	
		self:DecrementStackCount()
		
		-- "Does not target couriers, wards, buildings, invisible units, or units inside the Fog of War."
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.target and not enemy:IsCourier() then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_gyrocopter_flak_cannon_speed_handler", {projectile_speed = self.projectile_speed})
				self:GetParent():PerformAttack(enemy, false, false, true, true, true, false, false)
				self:GetParent():RemoveModifierByName("modifier_imba_gyrocopter_flak_cannon_speed_handler")
			end
		end
		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_FLAK_CANNON_SPEED_HANDLER --
--------------------------------------------------------

-- This modifier forces the Flak Cannon attack projectiles to be at a specific projectile speed

-- function modifier_imba_gyrocopter_flak_cannon_speed_handler:IsHidden()		return true end
function modifier_imba_gyrocopter_flak_cannon_speed_handler:IsPurgable()	return false end

function modifier_imba_gyrocopter_flak_cannon_speed_handler:OnCreated(keys)
	if not IsServer() then return end
	
	self.projectile_speed		= keys.projectile_speed
	self.projectile_speed_base	= self:GetParent():GetProjectileSpeed()
end

function modifier_imba_gyrocopter_flak_cannon_speed_handler:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS}
end

function modifier_imba_gyrocopter_flak_cannon_speed_handler:GetModifierProjectileSpeedBonus()
	if self.projectile_speed and self.projectile_speed_base then
		return self.projectile_speed - self.projectile_speed_base
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_FLAK_CANNON_SIDE_GUNNER --
------------------------------------------------------

function modifier_imba_gyrocopter_flak_cannon_side_gunner:IsHidden()		return true end
function modifier_imba_gyrocopter_flak_cannon_side_gunner:IsPurgable()		return false end
function modifier_imba_gyrocopter_flak_cannon_side_gunner:RemoveOnDeath()	return false end

-- Tthe scepter effect seems to be tied to the hero as vanilla so this probably won't be necessary

-- "The Side Gunner does not attack when Gyrocopter is hidden, invisible, or affected by Break."
function modifier_imba_gyrocopter_flak_cannon_side_gunner:OnIntervalThink()
	if self:GetParent():HasScepter() and not self:GetParent():IsOutOfGame() and not self:GetParent():IsInvisible() and not self:GetParent():PassivesDisabled() and self:GetParent():IsAlive() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("scepter_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_FARTHEST, false)) do
			if not enemy:IsCourier() then
				self:GetParent():PerformAttack(enemy, false, false, true, true, true, false, false)
				break
			end
		end
	end
end

-----------------------------
-- IMBA_GYROCOPTER_LOCK_ON --
-----------------------------

function imba_gyrocopter_lock_on:OnSpellStart()

end

----------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_LOCK_ON_HANDLER --
----------------------------------------------

function modifier_imba_gyrocopter_lock_on_handler:OnCreated()

end

--------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_LOCK_ON --
--------------------------------------

function modifier_imba_gyrocopter_lock_on:OnCreated()

end

----------------------------------
-- IMBA_GYROCOPTER_GATLING_GUNS --
----------------------------------

function imba_gyrocopter_gatling_guns:OnSpellStart()

end

-------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_GATLING_GUNS --
-------------------------------------------

function modifier_imba_gyrocopter_gatling_guns:OnCreated()

end

-------------------------------
-- IMBA_GYROCOPTER_CALL_DOWN --
-------------------------------

function imba_gyrocopter_call_down:OnSpellStart()
	-- self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire.Self") -- This one has a volume_falloff_max so IDK which one to use

	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_call_down_03",
				"gyrocopter_gyro_call_down_04",
				"gyrocopter_gyro_call_down_05",
				"gyrocopter_gyro_call_down_06",
				"gyrocopter_gyro_call_down_09"
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_gyrocopter_call_down_thinker", {duration = self:GetSpecialValueFor("missile_delay_tooltip") * 2}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
end

------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_CALL_DOWN_THINKER --
------------------------------------------------

function modifier_imba_gyrocopter_call_down_thinker:OnCreated()
	self.slow_duration_first	= self:GetAbility():GetSpecialValueFor("slow_duration_first")
	self.slow_duration_second	= self:GetAbility():GetSpecialValueFor("slow_duration_second")
	self.damage_first			= self:GetAbility():GetSpecialValueFor("damage_first")
	self.damage_second			= self:GetAbility():GetSpecialValueFor("damage_second")
	self.slow_first				= self:GetAbility():GetSpecialValueFor("slow_first")
	self.slow_second			= self:GetAbility():GetSpecialValueFor("slow_second")
	self.radius					= self:GetAbility():GetSpecialValueFor("radius")
	self.missile_delay_tooltip	= self:GetAbility():GetSpecialValueFor("missile_delay_tooltip")
	self.cast_range_standard	= self:GetAbility():GetSpecialValueFor("cast_range_standard")
	
	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.first_missile_impact	= false
	self.second_missile_impact	= false
	
	if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.cast_range_standard or self:GetCaster():GetLevel() >= 25 then
		self.marker_particle		= ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	else
		self.marker_particle		= ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.marker_particle, 0, self:GetParent():GetAbsOrigin())
	end
	
	ParticleManager:SetParticleControl(self.marker_particle, 1, Vector(self.radius, 1, self.radius * (-1)))
	self:AddParticle(self.marker_particle, false, false, -1, false, false)
	
	local calldown_first_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_first_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_first_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_first_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_first_particle)
	
	local calldown_second_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_second_particle, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_second_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_second_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_second_particle)
	
	self:StartIntervalThink(self.missile_delay_tooltip)
end

function modifier_imba_gyrocopter_call_down_thinker:OnIntervalThink()
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	
	if not self.first_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			self.slow_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_call_down_slow", {duration = self.slow_duration_first, slow = self.slow_first})
			
			if self.slow_modifier then
				self.slow_modifier:SetDuration(self.slow_duration_first * (1 - enemy:GetStatusResistance()), true)
			end
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_first,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				self:GetCaster():EmitSound("gyrocopter_gyro_call_down_1"..RandomInt(1, 2))
			end
		end
		
		self.first_missile_impact = true
	elseif not self.second_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			self.slow_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_call_down_slow", {duration = self.slow_duration_second, slow = self.slow_second})
			
			if self.slow_modifier then
				self.slow_modifier:SetDuration(self.slow_duration_second * (1 - enemy:GetStatusResistance()), true)
			end
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_second,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				self:GetCaster():EmitSound("gyrocopter_gyro_call_down_1"..RandomInt(1, 2))
			end
		end
	
		self.second_missile_impact = true
	end
end

---------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_CALL_DOWN_SLOW --
---------------------------------------------

function modifier_imba_gyrocopter_call_down_slow:OnCreated(keys)
	if keys and keys.slow then
		self:SetStackCount(keys.slow * (-1))
	end
end

function modifier_imba_gyrocopter_call_down_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_gyrocopter_call_down_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_range", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- modifier_special_bonus_imba_ancient_apparition_chilling_touch_range		= modifier_special_bonus_imba_ancient_apparition_chilling_touch_range or class({})
-- modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown		= class({})
-- modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage	= class({})
-- modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost			= class({})
-- modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe			= class({})

-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:IsHidden() 		return true end
-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_range:RemoveOnDeath() 	return false end

-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:IsHidden() 			return true end
-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown:RemoveOnDeath() 	return false end

-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:IsHidden() 		return true end
-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:RemoveOnDeath() 	return false end

-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:OnCreated()
	-- if not IsServer() then return end
	
	-- self.chilling_touch_ability		= self:GetCaster():FindAbilityByName("imba_ancient_apparition_chilling_touch")
	-- self.imbued_ice_ability 		= self:GetCaster():FindAbilityByName("imba_ancient_apparition_imbued_ice")
	
	-- if self.chilling_touch_ability and self.imbued_ice_ability then
		-- self.imbued_ice_ability:SetHidden(false)
		-- self.imbued_ice_ability:SetLevel(self.chilling_touch_ability:GetLevel())
	-- end
-- end

-- function modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage:OnDestroy()
	-- if not IsServer() then return end
	
	-- if self.imbued_ice_ability then
		-- self.imbued_ice_ability:SetHidden(true)
	-- end
-- end

-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:IsHidden() 		return true end
-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:RemoveOnDeath() 	return false end

-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:OnCreated()
	-- if not IsServer() then return end
	
	-- self.ice_vortex_ability		= self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_vortex")
	-- self.anti_abrasion_ability	= self:GetCaster():FindAbilityByName("imba_ancient_apparition_anti_abrasion")
	
	-- if self.ice_vortex_ability and self.anti_abrasion_ability then
		-- self.anti_abrasion_ability:SetHidden(false)
		-- self.anti_abrasion_ability:SetLevel(self.ice_vortex_ability:GetLevel())
	-- end
-- end

-- function modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost:OnDestroy()
	-- if not IsServer() then return end
	
	-- if self.anti_abrasion_ability then
		-- self.anti_abrasion_ability:SetHidden(true)
	-- end
-- end

-- function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:IsHidden() 		return true end
-- function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe:RemoveOnDeath() 	return false end

-- function imba_ancient_apparition_cold_feet:OnOwnerSpawned()
	-- if not IsServer() then return end

	-- if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_cold_feet_aoe"), "modifier_special_bonus_imba_ancient_apparition_cold_feet_aoe", {})
	-- end
-- end

-- function imba_ancient_apparition_ice_vortex:OnOwnerSpawned()
	-- if not IsServer() then return end

	-- if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_ice_vortex_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_ice_vortex_cooldown"), "modifier_special_bonus_imba_ancient_apparition_ice_vortex_cooldown", {})
	-- end

	-- if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_ice_vortex_boost") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_ice_vortex_boost"), "modifier_special_bonus_imba_ancient_apparition_ice_vortex_boost", {})
	-- end	
-- end

-- function imba_ancient_apparition_chilling_touch:OnOwnerSpawned()
	-- if not IsServer() then return end
	
	-- if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_chilling_touch_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_range") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_chilling_touch_range"), "modifier_special_bonus_imba_ancient_apparition_chilling_touch_range", {})
	-- end

	-- if self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_chilling_touch_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_ancient_apparition_chilling_touch_damage"), "modifier_special_bonus_imba_ancient_apparition_chilling_touch_damage", {})
	-- end
-- end
