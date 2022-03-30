-- Creator:
--	   AltiV, January 28th, 2020

LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_pre_flight", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_lock_on", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon_speed_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon_side_gunner", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_gatling_guns_handler", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_gatling_guns_wind_up", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
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

modifier_imba_gyrocopter_lock_on					= modifier_imba_gyrocopter_lock_on or class({})

imba_gyrocopter_flak_cannon							= imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon				= modifier_imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon_speed_handler	= modifier_imba_gyrocopter_flak_cannon_speed_handler or class({})
modifier_imba_gyrocopter_flak_cannon_side_gunner	= modifier_imba_gyrocopter_flak_cannon_side_gunner or class({})

imba_gyrocopter_gatling_guns						= imba_gyrocopter_gatling_guns or class({})
modifier_imba_gyrocopter_gatling_guns_handler		= modifier_imba_gyrocopter_gatling_guns_handler or class({})
modifier_imba_gyrocopter_gatling_guns_wind_up		= modifier_imba_gyrocopter_gatling_guns_wind_up or class({})
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
		
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_rocket_barrage", {duration = self:GetDuration()})
end

function imba_gyrocopter_rocket_barrage:OnProjectileHit(target, location)
	if target then
		target:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
	
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", {duration = self:GetSpecialValueFor("ballistic_duration") * (1 - target:GetStatusResistance())})
	
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
	if not self:GetAbility() then self:Destroy() return end

	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.rockets_per_second	= self:GetAbility():GetSpecialValueFor("rockets_per_second")
	self.ballistic_duration	= self:GetAbility():GetSpecialValueFor("ballistic_duration")
	self.sniping_speed		= self:GetAbility():GetSpecialValueFor("sniping_speed")
	self.sniping_distance	= self:GetAbility():GetSpecialValueFor("sniping_distance")
	
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
		self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
		
		if self:GetCaster():HasAbility("imba_gyrocopter_homing_missile") and self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier and
		(self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.sniping_distance + self:GetCaster():GetCastRangeBonus()
		and not self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent():IsMagicImmune()
		and not self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent():IsOutOfGame() then
			self.lock_on_enemy = self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent()
			
			if (self.lock_on_enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.radius then
				self.lock_on_enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
				
				self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, self.lock_on_enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.lock_on_enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.barrage_particle)
				
				-- IMBAfication: Ballistic Suppression
				self.lock_on_enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", {duration = self.ballistic_duration * (1 - self.lock_on_enemy:GetStatusResistance())})
	
				ApplyDamage({
					victim 			= self.lock_on_enemy,
					damage 			= self.rocket_damage,
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
			else
				ProjectileManager:CreateLinearProjectile({
					EffectName	= "particles/base_attacks/ranged_tower_bad_linear.vpcf",
					Ability		= self:GetAbility(),
					Source		= self:GetCaster(),
					vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),
					vVelocity	= (self.lock_on_enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * self.sniping_speed * Vector(1, 1, 0),
					vAcceleration	= nil, --hmm...
					fMaxSpeed	= nil, -- What's the default on this thing?
					fDistance	= self.sniping_distance + self:GetCaster():GetCastRangeBonus(),
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
		else
			self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
			if #self.enemies >= 1 then
				for _, enemy in pairs(self.enemies) do
					enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
					
					self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(self.barrage_particle)
					
					-- IMBAfication: Ballistic Suppression
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_rocket_barrage_ballistic_suppression", {duration = self.ballistic_duration * (1 - enemy:GetStatusResistance())})
		
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
					EffectName	= "particles/base_attacks/ranged_tower_bad_linear.vpcf",
					Ability		= self:GetAbility(),
					Source		= self:GetCaster(),
					vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),
					vVelocity	= self:GetParent():GetForwardVector() * self.sniping_speed * Vector(1, 1, 0),
					vAcceleration	= nil, --hmm...
					fMaxSpeed	= nil, -- What's the default on this thing?
					fDistance	= self.sniping_distance + self:GetCaster():GetCastRangeBonus(),
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

function modifier_imba_gyrocopter_rocket_barrage:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_imba_gyrocopter_rocket_barrage:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
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
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_gyrocopter_homing_missile:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_gyrocopter_homing_missile_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return 0
	end
end

function imba_gyrocopter_homing_missile:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target then
		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= self:GetCaster():GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end
	end

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
		
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end

	local missile_starting_position = nil
	local pre_flight_time = self:GetSpecialValueFor("pre_flight_time")
	
	if not self:GetAutoCastState() then
		-- "When Cast, a stationary missile is placed 150 range in front of Gyrocopter, which begins to move 3 seconds later."
		missile_starting_position = self:GetCaster():GetAbsOrigin() + ((self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * 150)
		
		if self.lock_on_modifier and self.lock_on_modifier:GetParent() == self:GetCursorTarget() then
			pre_flight_time = 0
		end
	else
		-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
		if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
			self:GetCaster():SetCursorPosition((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized())
		end
	
		missile_starting_position = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 150)
	end
	
	local missile = CreateUnitByName("npc_dota_gyrocopter_homing_missile", missile_starting_position, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile_pre_flight", {duration = pre_flight_time, bAutoCast = self:GetAutoCastState()})
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile", {bAutoCast = self:GetAutoCastState()})

	if not self:GetAutoCastState() then
		missile:SetForwardVector((self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized())
	else
		missile:SetForwardVector((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized())
		missile:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
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

function modifier_imba_gyrocopter_homing_missile_handler:OnIntervalThink()
	if self:GetParent():GetAttackTarget() and self:GetParent():GetAttackTarget():FindModifierByNameAndCaster("modifier_imba_gyrocopter_lock_on", self:GetCaster()) then
		self.bAttackingLockOn = true
	else
		self.bAttackingLockOn = false
	end
end

function modifier_imba_gyrocopter_homing_missile_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
		
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_imba_gyrocopter_homing_missile_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() then return end
	
	if keys.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO and keys.ability == self:GetAbility() then
		-- Due to logic order, this is actually reversed
		if self:GetAbility():GetAutoCastState() then
			self:SetStackCount(0)
		else
			self:SetStackCount(1)
		end
	end
	
	if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and keys.target and keys.target:FindModifierByNameAndCaster("modifier_imba_gyrocopter_lock_on", self:GetCaster()) then
		self.bAttackingLockOn = true
	end
end

function modifier_imba_gyrocopter_homing_missile_handler:GetModifierAttackRangeBonus()
	if self.bAttackingLockOn then
		return self:GetAbility():GetSpecialValueFor("lock_on_attack_range_bonus")
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
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Enemy", self:GetCaster())
	
	if keys.bAutoCast == 0 then
		self.target	= self:GetAbility():GetCursorTarget()
	else
		self.target = nil
	end
end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnDestroy()
	if not IsServer() then return end
	
	if not self:GetParent():IsAlive() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy", self:GetCaster())
	
	if self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile") then
		-- Okay so this part I don't understand at all; if I don't set controllable by player, the missile won't fly at all EXCEPT when the ability is level 1. This is non-vanilla behaviour to make the missile selectable (as in highlighted green bar), but I can't figure this out right now
		self:GetParent():SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		
		if self.target and not self.target:IsNull() and self.target:IsAlive() then
			self:GetParent():MoveToNPC(self.target)
			-- self:GetParent():SetControllableByPlayer(nil, true) -- Doesn't work
		elseif self.bAutoCast == 0 then
			local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_death.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_particle)
			
			self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
			self:GetParent():ForceKill(false)
			self:GetParent():AddNoDraw()
			return
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

function modifier_imba_gyrocopter_homing_missile_pre_flight:DeclareFunctions()
	return {MODIFIER_EVENT_ON_DEATH}
end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnDeath(keys)
	-- "If the missile's target dies, it automatically switches to the nearest valid target within 700 range of the previous target."
	if self.target and keys.unit == self.target then
		local nearby_targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		
		if #nearby_targets >= 1 then
			self.target = nearby_targets[1]
			self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile").target = nearby_targets[1]
			
			ParticleManager:DestroyParticle(self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile").target_particle, false)
			ParticleManager:ReleaseParticleIndex(self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile").target_particle)
			self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile").target_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target, self:GetCaster():GetTeamNumber())
			self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile"):AddParticle(self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile").target_particle, false, false, -1, false, false)
		end
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

	self.propulsion_speed_pct		= self:GetAbility():GetSpecialValueFor("propulsion_speed_pct")
	self.propulsion_duration_pct	= self:GetAbility():GetSpecialValueFor("propulsion_duration_pct")
	
	self.lock_on_duration			= self:GetAbility():GetSpecialValueFor("lock_on_duration")
	self.lock_on_attack_range_bonus	= self:GetAbility():GetSpecialValueFor("lock_on_attack_range_bonus")
	
	self.rc_turn_speed_degrees		= self:GetAbility():GetSpecialValueFor("rc_turn_speed_degrees")
	
	if not IsServer() then return end
	
	self.stun_duration				= self:GetAbility():GetTalentSpecialValueFor("stun_duration")
	
	self.damage						= self:GetAbility():GetAbilityDamage()
	self.damage_type				= self:GetAbility():GetAbilityDamageType()
	
	self.bAutoCast					= keys.bAutoCast
	
	if self.bAutoCast == 0 then
		self.target	= self:GetAbility():GetCursorTarget()
	else
		self.target = nil
	end
	
	if self:GetAbility().lock_on_modifier and self:GetAbility().lock_on_modifier:GetParent() == self:GetAbility():GetCursorTarget() then
		self.pre_flight_time = 0
	end
	
	self.interval					= 1 / self.acceleration
	-- This tracks how much additional speed (on top of base) the missile will be moving at
	self.speed_counter				= 0
	
	if self.target then
		self.target_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target, self:GetCaster():GetTeamNumber())
		self:AddParticle(self.target_particle, false, false, -1, false, false)
	end
	
	-- IMBAfication: R.C. Rocket
	self.rocket_orders = {
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
		[DOTA_UNIT_ORDER_ATTACK_TARGET]		= true,
		
		[DOTA_UNIT_ORDER_STOP]				= true,
		[DOTA_UNIT_ORDER_HOLD_POSITION]		= true
	}
end

-- Missile has hull radius of 24
function modifier_imba_gyrocopter_homing_missile:OnIntervalThink()
	self.speed_counter	= self.speed_counter + 1
	self:SetStackCount(self.speed_counter)

	if self.target then
		if self.target:IsNull() or not self.target:IsAlive() then
			local nearby_targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			
			if #nearby_targets >= 1 then
				self.target = nearby_targets[1]
				self.target = nearby_targets[1]
				
				ParticleManager:DestroyParticle(self.target_particle, false)
				ParticleManager:ReleaseParticleIndex(self.target_particle)
				self.target_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target, self:GetCaster():GetTeamNumber())
				self:AddParticle(self.target_particle, false, false, -1, false, false)
			else
				local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(explosion_particle)
				
				self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
				self:GetParent():ForceKill(false)
				self:GetParent():AddNoDraw()
				return
			end
		end
		
		-- Arbitrary change of target handling as missile gets close (so it can overlap and count collision detection)
		if (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 250 then
			self:GetParent():MoveToNPC(self.target)
		else
			self:GetParent():MoveToPosition(self.target:GetAbsOrigin())
		end
		-- print((self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D())
		-- print(self.target:GetHullRadius())
	else
		-- IMBAfication: R.C. Rocket
		-- This is for how much the rocket can turn in degrees per interval think
		if not self.angle or self.angle == 0 then
			self.differential = 0
		elseif self.angle > 0 then
			self.differential = self.rc_turn_speed_degrees * self.interval
		elseif self.angle < 0 then
			self.differential = self.rc_turn_speed_degrees * self.interval * (-1)
		end
		
		self:GetParent():MoveToPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, self.differential * (-1), 0), self:GetParent():GetForwardVector() * self:GetParent():GetIdealSpeed()))
		
		if self.turn_counter then
			self.turn_counter = self.turn_counter + math.min(math.abs(self.differential), math.abs(self.angle) - self.turn_counter)
			
			if self.turn_counter >= math.abs(self.angle) then
				self.turn_counter	= nil
				self.angle			= 0
				self.differential	= 0
			end
		end
	end
	
	if self.bAutoCast == 1 then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():GetHullRadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)) do
			self.target = enemy
			break
		end
	end
	
	-- Missile impact logic
	if self.target and (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():GetHullRadius() and not (self:GetParent():HasModifier("modifier_item_imba_force_staff_active") or self:GetParent():HasModifier("modifier_item_imba_hurricane_pike_force_ally") or self:GetParent():HasModifier("modifier_item_imba_hurricane_pike_force_enemy") or self:GetParent():HasModifier("modifier_item_imba_lance_of_longinus_force_ally") or self:GetParent():HasModifier("modifier_item_imba_lance_of_longinus_force_enemy_melee")) then
		self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Target")
		self.target:EmitSound("Hero_Gyrocopter.HomingMissile.Destroy")
		
		if not self.target:IsMagicImmune() then
			-- "The rocket first applies the debuff, then the damage."
			self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - self.target:GetStatusResistance())})
			
			ApplyDamage({
				victim 			= self.target,
				-- IMBAfication: Amped Propulsion
				damage 			= self.damage + (self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01) + (math.max(self:GetElapsedTime() - self.pre_flight_time, 0) * self.propulsion_duration_pct * 0.01),
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			-- print((self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01))
			-- print((math.max(self:GetElapsedTime() - self.pre_flight_time, 0) * self.propulsion_duration_pct * 0.01))
			
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
				
				EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
			end
			
			-- IMBAfication: Lock-On
			if self.target:IsAlive() then
				self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_lock_on", {duration = self.lock_on_duration * (1 - self.target:GetStatusResistance())})
			end
		end
		
		-- IMBAfication: Amped Propulsion
		local blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", PATTACH_ABSORIGIN, self.target)
		ParticleManager:SetParticleControl(blast_particle, 1, Vector(self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01, self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01, self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01))
		ParticleManager:ReleaseParticleIndex(blast_particle)

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), nil, (self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01) + (math.max(self:GetElapsedTime() - self.pre_flight_time, 0) * self.propulsion_duration_pct * 0.01), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if enemy ~= self.target then
				-- "The rocket first applies the debuff, then the damage."
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
				
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.damage + (self:GetParent():GetIdealSpeed() * self.propulsion_speed_pct * 0.01) + (math.max(self:GetElapsedTime() - self.pre_flight_time, 0) * self.propulsion_duration_pct * 0.01),
					damage_type		= self.damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
			end
		end
		
		-- "If the missile hits its target, its 400 range flying vision stays at the location for 3.5 seconds."
		AddFOWViewer(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), 400, self.enemy_vision_time, false)
		
		local explosion_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(explosion_particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(explosion_particle)
		
		self:StartIntervalThink(-1)
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
	
	-- Assuming the missile went out of game bounds; destroy it
	if self:GetParent():GetAbsOrigin().z < 0 then
		self:StartIntervalThink(-1)
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end

function modifier_imba_gyrocopter_homing_missile:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile.Enemy", self:GetCaster())
end

function modifier_imba_gyrocopter_homing_missile:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION]					= true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]						= true,
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS]	= (not self.bAutoCast or self.bAutoCast == 0) or self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile_pre_flight"),
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
		
		MODIFIER_EVENT_ON_ATTACKED,
		
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_gyrocopter_homing_missile:GetModifierMoveSpeed_Absolute()
	if self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile_pre_flight") then
		return 0
	else
		return self.speed + self:GetStackCount()
	end
end

function modifier_imba_gyrocopter_homing_missile:GetModifierMoveSpeed_Limit()
	if self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile_pre_flight") then
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

function modifier_imba_gyrocopter_homing_missile:OnOrder(keys)
	if keys.unit == self:GetParent() and self.rocket_orders[keys.order_type] then
		if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
			self.angle = 0
		else
			self.selected_pos = keys.new_pos
			
			if keys.target then
				self.selected_pos = keys.target:GetAbsOrigin()
			end
			
			self.angle			= AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(self.selected_pos - self:GetParent():GetAbsOrigin()).y)
			self.turn_counter	= 0
		end
	end
end

--------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_LOCK_ON --
--------------------------------------

function modifier_imba_gyrocopter_lock_on:IsPurgable()		return false end
function modifier_imba_gyrocopter_lock_on:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_gyrocopter_lock_on:GetEffectName()
	return "particles/hero/gyrocopter/gyrocopter_lock_on.vpcf"
end

function modifier_imba_gyrocopter_lock_on:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_gyrocopter_lock_on:OnCreated(keys)
	if not IsServer() then return end
	
	-- Can only have one lock-on target at a time
	if self:GetAbility() then
		if self:GetAbility().lock_on_modifier then
			self:GetAbility().lock_on_modifier:Destroy()
		end
		
		self:GetAbility().lock_on_modifier = self
	end
	
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_homing_missile_handler") then
		self:GetCaster():FindModifierByName("modifier_imba_gyrocopter_homing_missile_handler"):StartIntervalThink(FrameTime())
	end
end

function modifier_imba_gyrocopter_lock_on:OnDestroy()
	if not IsServer() then return end
	
	if self:GetAbility() and self:GetAbility().lock_on_modifier then
		self:GetAbility().lock_on_modifier = nil
	end
	
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_homing_missile_handler") then
		self:GetCaster():FindModifierByName("modifier_imba_gyrocopter_homing_missile_handler"):StartIntervalThink(-1)
	end
end

function modifier_imba_gyrocopter_lock_on:CheckState()
	if IsServer() and not self:GetCaster():CanEntityBeSeenByMyTeam(self:GetParent()) then self:Destroy() return end

	return {[MODIFIER_STATE_EVADE_DISABLED] = true}
end

---------------------------------
-- IMBA_GYROCOPTER_FLAK_CANNON --
---------------------------------

function imba_gyrocopter_flak_cannon:GetIntrinsicModifierName()
	return "modifier_imba_gyrocopter_flak_cannon_side_gunner"
end

function imba_gyrocopter_flak_cannon:OnInventoryContentsChanged()
	if self:GetIntrinsicModifierName() and self:GetCaster():HasModifier(self:GetIntrinsicModifierName()) then
		if self:GetCaster():HasScepter() then
			self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(self:GetSpecialValueFor("fire_rate"))
		else
			self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName()):StartIntervalThink(-1)
		end
	end
end

function imba_gyrocopter_flak_cannon:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_gyrocopter_flak_cannon:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.FlackCannon.Activate")

	-- Vanilla particle effect refreshes on modifier reapplication too
	self:GetCaster():RemoveModifierByName("modifier_imba_gyrocopter_flak_cannon")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_flak_cannon", {duration = self:GetDuration()})
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
	self.max_attacks		= self:GetAbility():GetTalentSpecialValueFor("max_attacks")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	self.fresh_rounds		= self:GetAbility():GetSpecialValueFor("fresh_rounds")
	
	if not IsServer() then return end
	
	self.weapons			= {"attach_attack1", "attach_attack2"}
	
	self:SetStackCount(self.max_attacks)
end

function modifier_imba_gyrocopter_flak_cannon:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_imba_gyrocopter_flak_cannon:OnAttack(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown then
		self:GetParent():EmitSound("Hero_Gyrocopter.FlackCannon")
		
		-- "Does not target couriers, wards, buildings, invisible units, or units inside the Fog of War."
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.target and not enemy:IsCourier() then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_gyrocopter_flak_cannon_speed_handler", {projectile_speed = self.projectile_speed})
				-- IMBAfication: Fresh Rounds
				self:GetParent():PerformAttack(enemy, false, self:GetStackCount() > self.max_attacks - self.fresh_rounds, true, true, true, false, false)
				self:GetParent():RemoveModifierByName("modifier_imba_gyrocopter_flak_cannon_speed_handler")
			end
		end
		
		self:DecrementStackCount()
		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_FLAK_CANNON_SPEED_HANDLER --
--------------------------------------------------------

-- This modifier forces the Flak Cannon attack projectiles to be at a specific projectile speed

function modifier_imba_gyrocopter_flak_cannon_speed_handler:IsHidden()		return true end
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

----------------------------------
-- IMBA_GYROCOPTER_GATLING_GUNS --
----------------------------------

function imba_gyrocopter_gatling_guns:IsInnateAbility()	return true end

function imba_gyrocopter_gatling_guns:GetIntrinsicModifierName()
	return "modifier_imba_gyrocopter_gatling_guns_handler"
end

function imba_gyrocopter_gatling_guns:OnOwnerSpawned()
	if self:GetCaster():HasModifier("modifier_imba_gyrocopter_gatling_guns_handler") then
		self:GetCaster():FindModifierByName("modifier_imba_gyrocopter_gatling_guns_handler"):StartIntervalThink(1)
	end
end

function imba_gyrocopter_gatling_guns:OnToggle()
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_gatling_guns_wind_up", {duration = self:GetSpecialValueFor("wind_up_time")})
	else
		self:GetCaster():RemoveModifierByName("modifier_imba_gyrocopter_gatling_guns_wind_up")
		self:GetCaster():RemoveModifierByName("modifier_imba_gyrocopter_gatling_guns")
	end
end

function imba_gyrocopter_gatling_guns:OnProjectileHit(target, location)
	if target then
		ApplyDamage({
			victim 			= target,
			damage 			= self:GetCaster():GetAverageTrueAttackDamage(target) * self:GetSpecialValueFor("attack_damage_pct") * 0.01,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		
		return true
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_GATLING_GUNS_HANDLER --
---------------------------------------------------

function modifier_imba_gyrocopter_gatling_guns_handler:IsHidden()		return not self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_gatling_guns_activate") end
function modifier_imba_gyrocopter_gatling_guns_handler:IsPurgable()		return false end
function modifier_imba_gyrocopter_gatling_guns_handler:RemoveOnDeath()	return false end

function modifier_imba_gyrocopter_gatling_guns_handler:OnCreated()
	if not IsServer() then return end
	
	if not self.initialized then
		self:SetStackCount(self:GetAbility():GetLevelSpecialValueFor("initial_ammo", 1))
		self.initialized = true
	end
end

function modifier_imba_gyrocopter_gatling_guns_handler:OnIntervalThink()
	if self:GetCaster():IsAlive() and not self:GetParent():HasModifier("modifier_imba_gyrocopter_gatling_guns_wind_up") then
		self:SetStackCount(math.min(self:GetStackCount() + self:GetAbility():GetSpecialValueFor("ammo_restore_per_second"), self:GetAbility():GetSpecialValueFor("initial_ammo")))
	else
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_gyrocopter_gatling_guns_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_imba_gyrocopter_gatling_guns_handler:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and (keys.ability:GetName() == "item_refresher" or keys.ability:GetName() == "item_refresher_shard") then		
		if self:GetParent():HasModifier("modifier_imba_gyrocopter_gatling_guns") and self:GetStackCount() <= 0 then
			self:GetParent():FindModifierByName("modifier_imba_gyrocopter_gatling_guns"):StartIntervalThink(self:GetAbility():GetSpecialValueFor("fire_interval"))
			self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
			self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Empty")
		end
		
		self:SetStackCount(self:GetAbility():GetLevelSpecialValueFor("initial_ammo", 1))
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_GATLING_GUNS_WIND_UP --
---------------------------------------------------

function modifier_imba_gyrocopter_gatling_guns_wind_up:DestroyOnExpire()	return false end
function modifier_imba_gyrocopter_gatling_guns_wind_up:IsHidden()			return self:GetRemainingTime() <= 0 end
function modifier_imba_gyrocopter_gatling_guns_wind_up:IsPurgable()			return false end

function modifier_imba_gyrocopter_gatling_guns_wind_up:OnCreated()
	if not self:GetAbility() or not self:GetCaster():HasModifier("modifier_imba_gyrocopter_gatling_guns_handler") then return end
	
	self.wind_up_time			= self:GetAbility():GetSpecialValueFor("wind_up_time")
	self.max_move_speed			= self:GetAbility():GetSpecialValueFor("max_move_speed")
	self.incoming_damage_pct	= self:GetAbility():GetSpecialValueFor("incoming_damage_pct")
	
	if not IsServer() then return end
	
	self.ammo_modifier			= self:GetCaster():FindModifierByName("modifier_imba_gyrocopter_gatling_guns_handler")
	
	-- self.standard_attack_capability	= self:GetParent():GetAttackCapability()
	
	-- self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	
	self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Wind_Up")
	self:StartIntervalThink(self:GetRemainingTime())
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_gatling_guns", {})
	
	self:StartIntervalThink(-1)
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Wind_Up")
	self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Wind_Down")
	
	if self.ammo_modifier then
		self.ammo_modifier:StartIntervalThink(1)
	end
	
	-- self:GetParent():SetAttackCapability(self.standard_attack_capability)
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:GetModifierMoveSpeed_Limit()
	return self.max_move_speed
end

function modifier_imba_gyrocopter_gatling_guns_wind_up:GetModifierIncomingDamage_Percentage()
	return self.incoming_damage_pct
end

-------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_GATLING_GUNS --
-------------------------------------------

function modifier_imba_gyrocopter_gatling_guns:IsPurgable()		return false end

function modifier_imba_gyrocopter_gatling_guns:OnCreated()
	if not self:GetAbility() or not self:GetCaster():HasModifier("modifier_imba_gyrocopter_gatling_guns_handler") then return end
	
	self.max_move_speed			= self:GetAbility():GetSpecialValueFor("max_move_speed")
	
	if not IsServer() then return end
	
	self.fire_interval			= self:GetAbility():GetSpecialValueFor("fire_interval")
	self.attack_range_bonus_pct	= self:GetAbility():GetSpecialValueFor("attack_range_bonus_pct")
	self.spread_angle			= self:GetAbility():GetSpecialValueFor("spread_angle")
	
	self.ammo_modifier			= self:GetCaster():FindModifierByName("modifier_imba_gyrocopter_gatling_guns_handler")
	
	self.projectile_info		= {
		EffectName	= "particles/base_attacks/ranged_tower_good_linear.vpcf",
		Ability		= self:GetAbility(),
		Source		= self:GetCaster(),
		vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")),
		vVelocity	= RotatePosition(Vector(0, 0, 0), QAngle(0, RandomFloat(self.spread_angle * (-1), self.spread_angle), 0), self:GetParent():GetForwardVector()) * self:GetParent():GetProjectileSpeed() * Vector(1, 1, 0),
		vAcceleration	= nil, --hmm...
		fMaxSpeed	= nil, -- What's the default on this thing?
		fDistance	= self:GetParent():Script_GetAttackRange() * self.attack_range_bonus_pct * 0.01,
		fStartRadius	= 25,
		fEndRadius		= 25,
		fExpireTime		= nil,
		iUnitTargetTeam	= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bIgnoreSource		= true,
		bHasFrontalCone		= false,
		bDrawsOnMinimap		= false,
		bVisibleToEnemies	= true,
		bProvidesVision		= false,
		iVisionRadius		= nil,
		iVisionTeamNumber	= nil,
		ExtraData			= {}
	}
	
	-- Variable to handle not having the firing sound while disarmed
	self.firing_sound	= true
	
	if self.ammo_modifier and self.ammo_modifier:GetStackCount() > 0 then
		self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
	end
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.fire_interval)
end

function modifier_imba_gyrocopter_gatling_guns:OnIntervalThink()
	if not self.ammo_modifier or self.ammo_modifier:IsNull() then self:StartIntervalThink(-1) return end
	
	if self:GetParent():IsDisarmed() then
		if self.firing_sound then
			self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
			self.firing_sound = false
		end
		
		return
	elseif not self:GetParent():IsDisarmed() and not self.firing_sound then
		self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
		self.firing_sound = true
	end
	
	if self.ammo_modifier:GetStackCount() > 0 then
		self.projectile_info.vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
		self.projectile_info.vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, RandomFloat(self.spread_angle * (-1), self.spread_angle), 0), self:GetParent():GetForwardVector()) * self:GetParent():GetProjectileSpeed() * Vector(1, 1, 0)
	
		ProjectileManager:CreateLinearProjectile(self.projectile_info)
		
		self.ammo_modifier:DecrementStackCount()
	else
		self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
		self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Empty")
		self:StartIntervalThink(-1)
		return
	end
	
	if self.ammo_modifier:GetStackCount() > 0 then
		self.projectile_info.vSpawnOrigin	= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack2"))
		self.projectile_info.vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, RandomFloat(self.spread_angle * (-1), self.spread_angle), 0), self:GetParent():GetForwardVector()) * self:GetParent():GetProjectileSpeed() * Vector(1, 1, 0)
	
		ProjectileManager:CreateLinearProjectile(self.projectile_info)
		
		self.ammo_modifier:DecrementStackCount()
	else
		self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
		self:GetParent():EmitSound("Hero_Gyrocopter.Gatling_Guns_Empty")
		self:StartIntervalThink(-1)
		return
	end
end

function modifier_imba_gyrocopter_gatling_guns:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Shoot")
	self:GetParent():StopSound("Hero_Gyrocopter.Gatling_Guns_Empty")
end

function modifier_imba_gyrocopter_gatling_guns:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_LIMIT}
end

function modifier_imba_gyrocopter_gatling_guns:GetModifierMoveSpeed_Limit()
	return self.max_move_speed
end


-------------------------------
-- IMBA_GYROCOPTER_CALL_DOWN --
-------------------------------

function imba_gyrocopter_call_down:GetCastRange(location, target)
	if IsClient() then
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function imba_gyrocopter_call_down:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_gyrocopter_call_down_cooldown")
end

function imba_gyrocopter_call_down:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_gyrocopter_call_down:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	
	return true
end

function imba_gyrocopter_call_down:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end

function imba_gyrocopter_call_down:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	-- self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire.Self") -- This one has a volume_falloff_max so IDK which one to use

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
		
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
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
	
	-- if self:GetCaster():HasAbility("imba_gyrocopter_homing_missile") and self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier and
	-- (self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile").lock_on_modifier:GetParent():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius then
		-- self.radius	= self.radius * 2
	-- end
	
	ParticleManager:SetParticleControl(self.marker_particle, 1, Vector(self.radius, 1, self.radius * (-1)))
	self:AddParticle(self.marker_particle, false, false, -1, false, false)
	
	local calldown_first_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_first_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_first_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_first_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_first_particle)
	
	local calldown_second_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_second_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket2")))
	ParticleManager:SetParticleControl(calldown_second_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_second_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_second_particle)
	
	self:StartIntervalThink(self.missile_delay_tooltip)
end

function modifier_imba_gyrocopter_call_down_thinker:OnIntervalThink()
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	
	if not self.first_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_call_down_slow", {duration = self.slow_duration_first * (1 - enemy:GetStatusResistance()), slow = self.slow_first})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_first,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
			end
		end
		
		self.first_missile_impact = true
	elseif not self.second_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyrocopter_call_down_slow", {duration = self.slow_duration_second * (1 - enemy:GetStatusResistance()), slow = self.slow_second})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_second,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
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

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks		= modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks or class({})
modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage	= modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage or class({})

function modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks:IsHidden() 		return true end
function modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks:IsPurgable() 	return false end
function modifier_special_bonus_imba_gyrocopter_flak_cannon_attacks:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage:IsPurgable() 		return false end
function modifier_special_bonus_imba_gyrocopter_rocket_barrage_damage:RemoveOnDeath() 	return false end



LinkLuaModifier("modifier_special_bonus_imba_gyrocopter_call_down_cooldown", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_gyrocopter_gatling_guns_activate", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_gyrocopter_homing_missile_charges", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_gyrocopter_call_down_cooldown		= modifier_special_bonus_imba_gyrocopter_call_down_cooldown or class({})
modifier_special_bonus_imba_gyrocopter_gatling_guns_activate	= modifier_special_bonus_imba_gyrocopter_gatling_guns_activate or class({})
modifier_special_bonus_imba_gyrocopter_homing_missile_charges	= modifier_special_bonus_imba_gyrocopter_homing_missile_charges or class({})

function modifier_special_bonus_imba_gyrocopter_call_down_cooldown:IsHidden() 		return true end
function modifier_special_bonus_imba_gyrocopter_call_down_cooldown:IsPurgable() 	return false end
function modifier_special_bonus_imba_gyrocopter_call_down_cooldown:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_gyrocopter_gatling_guns_activate:IsHidden() 		return true end
function modifier_special_bonus_imba_gyrocopter_gatling_guns_activate:IsPurgable() 		return false end
function modifier_special_bonus_imba_gyrocopter_gatling_guns_activate:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_gyrocopter_gatling_guns_activate:OnCreated()
	if not IsServer() then return end
	
	self.gatling_guns_ability		= self:GetCaster():FindAbilityByName("imba_gyrocopter_gatling_guns")
	
	if self.gatling_guns_ability then
		self.gatling_guns_ability:SetHidden(false)
	end
end

function modifier_special_bonus_imba_gyrocopter_gatling_guns_activate:OnDestroy()
	if not IsServer() then return end
	
	if self.gatling_guns_ability then
		self.gatling_guns_ability:SetHidden(true)
	end
end

function modifier_special_bonus_imba_gyrocopter_homing_missile_charges:IsHidden() 		return true end
function modifier_special_bonus_imba_gyrocopter_homing_missile_charges:IsPurgable() 	return false end
function modifier_special_bonus_imba_gyrocopter_homing_missile_charges:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_gyrocopter_homing_missile_charges:OnCreated()
	if not IsServer() then return end
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_gyrocopter_homing_missile"), "modifier_generic_charges", {})
end

function imba_gyrocopter_homing_missile:OnOwnerSpawned()
	if not IsServer() then return end
	
	if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_homing_missile_charges") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_gyrocopter_homing_missile_charges") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_gyrocopter_homing_missile_charges"), "modifier_special_bonus_imba_gyrocopter_homing_missile_charges", {})
	end
end

function imba_gyrocopter_gatling_guns:OnOwnerSpawned()
	if not IsServer() then return end
	
	if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_gatling_guns_activate") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_gyrocopter_gatling_guns_activate") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_gyrocopter_gatling_guns_activate"), "modifier_special_bonus_imba_gyrocopter_gatling_guns_activate", {})
	end
end

function imba_gyrocopter_call_down:OnOwnerSpawned()
	if not IsServer() then return end
	
	if self:GetCaster():HasTalent("special_bonus_imba_gyrocopter_call_down_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_gyrocopter_call_down_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_gyrocopter_call_down_cooldown"), "modifier_special_bonus_imba_gyrocopter_call_down_cooldown", {})
	end
end
