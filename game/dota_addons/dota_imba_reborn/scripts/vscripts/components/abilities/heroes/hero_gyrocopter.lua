-- Creator:
--	   AltiV, January 28th, 2020

LinkLuaModifier("modifier_imba_gyrocopter_rocket_barrage", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_homing_missile_pre_flight", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_homing_missile", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_flak_cannon_side_gunner", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_lock_on", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_gatling_guns", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_gyrocopter_call_down_thinker", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gyrocopter_call_down_slow", "components/abilities/heroes/hero_gyrocopter", LUA_MODIFIER_MOTION_NONE)

imba_gyrocopter_rocket_barrage						= imba_gyrocopter_rocket_barrage or class({})
modifier_imba_gyrocopter_rocket_barrage				= modifier_imba_gyrocopter_rocket_barrage or class({})

imba_gyrocopter_homing_missile						= imba_gyrocopter_homing_missile or class({})
modifier_imba_gyrocopter_homing_missile_pre_flight	= modifier_imba_gyrocopter_homing_missile_pre_flight or class({})
modifier_imba_gyrocopter_homing_missile				= modifier_imba_gyrocopter_homing_missile or class({})

imba_gyrocopter_flak_cannon							= imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon				= modifier_imba_gyrocopter_flak_cannon or class({})
modifier_imba_gyrocopter_flak_cannon_side_gunner	= modifier_imba_gyrocopter_flak_cannon_side_gunner or class({})

imba_gyrocopter_lock_on								= imba_gyrocopter_lock_on or class({})
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
			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)) do
				self:GetParent():EmitSound("Hero_Gyrocopter.Rocket_Barrage.Launch")
				enemy:EmitSound("Hero_Gyrocopter.Rocket_Barrage.Impact")
				
				self.barrage_particle	= ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_rocket_barrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, self.weapons[RandomInt(1, #self.weapons)], self:GetParent():GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.barrage_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(self.barrage_particle)
				
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
		end
	end
end

------------------------------------
-- IMBA_GYROCOPTER_HOMING_MISSILE --
------------------------------------

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
	missile:SetForwardVector((self:GetCaster():GetAbsOrigin() - self:GetCursorTarget():GetAbsOrigin()):Normalized())
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile_pre_flight", {duration = self:GetSpecialValueFor("pre_flight_time")})
	missile:AddNewModifier(self:GetCaster(), self, "modifier_imba_gyrocopter_homing_missile", {})
	
	local fuse_particle = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_homing_missile_fuse.vpcf", PATTACH_ABSORIGIN_FOLLOW, missile)
	-- ParticleManager:SetParticleControlEnt(fuse_particle, 0, missile, PATTACH_ABSORIGIN_FOLLOW, "attach_fuse", missile:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(fuse_particle)
	
	-- missile:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
end

--------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_HOMING_MISSILE_PRE_FLIGHT --
--------------------------------------------------------

function modifier_imba_gyrocopter_homing_missile_pre_flight:IsHidden()		return true end
function modifier_imba_gyrocopter_homing_missile_pre_flight:IsPurgable()	return false end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnCreated()
	self.speed						= self:GetAbility():GetSpecialValueFor("speed")

	-- "Homing Missile's initial speed is 500 and increases by 20 per second, growing by 1 every 0.05 seconds."
	-- Going to be higher than 20 here
	self.interval					= 1 / self:GetAbility():GetSpecialValueFor("acceleration")
	
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile")
	
	self.target	= self:GetAbility():GetCursorTarget()
end

function modifier_imba_gyrocopter_homing_missile_pre_flight:OnDestroy()
	if not IsServer() then return end
	
	if not self:GetParent():IsAlive() then return end
	
	self:GetParent():EmitSound("Hero_Gyrocopter.HomingMissile.Enemy")
	
	if self.target and not self.target:IsNull() and self.target:IsAlive() and self:GetParent():HasModifier("modifier_imba_gyrocopter_homing_missile") then
		self:GetParent():MoveToNPC(self.target)
		self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile"):StartIntervalThink(self.interval)
		local missile_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(missile_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_fuse", self:GetParent():GetAbsOrigin(), true)
		self:GetParent():FindModifierByName("modifier_imba_gyrocopter_homing_missile"):AddParticle(missile_particle, false, false, -1, false, false)
		
		-- Consider tracking projectile to handle this?
		-- ProjectileManager:CreateTrackingProjectile({
			-- EffectName			= nil,
			-- Ability				= self,
			-- Source				= self:GetParent():GetAbsOrigin(),
			-- vSourceLoc			= self:GetParent():GetAbsOrigin(),
			-- Target				= self.target,
			-- iMoveSpeed			= self.speed,
			-- -- flExpireTime		= nil,
			-- bDodgeable			= false,
			-- bIsAttack			= false,
			-- bReplaceExisting	= false,
			-- iSourceAttachment	= nil,
			-- bDrawsOnMinimap		= nil,
			-- bVisibleToEnemies	= true,
			-- bProvidesVision		= false,
			-- iVisionRadius		= nil,
			-- iVisionTeamNumber	= nil,
			-- ExtraData			= {}
		-- })
	else
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end

	-- if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		-- if not self.responses then
			-- self.responses = 
			-- {
				-- "gyrocopter_gyro_homing_missile_impact_01",
				-- "gyrocopter_gyro_homing_missile_impact_02",
				-- "gyrocopter_gyro_homing_missile_impact_05",
				-- "gyrocopter_gyro_homing_missile_impact_06",
				-- "gyrocopter_gyro_homing_missile_impact_07",
				-- "gyrocopter_gyro_homing_missile_impact_08"
			-- }
		-- end
		
		-- self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	-- end


---------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_HOMING_MISSILE --
---------------------------------------------

function modifier_imba_gyrocopter_homing_missile:IsHidden()		return true end
function modifier_imba_gyrocopter_homing_missile:IsPurgable()	return false end

function modifier_imba_gyrocopter_homing_missile:OnCreated()
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
	
	self.target						= self:GetAbility():GetCursorTarget()
	
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
	self:GetParent():MoveToNPC(self.target)
	-- print((self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D())
	-- print(self.target:GetHullRadius())
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
		[MODIFIER_STATE_NOT_ON_MINIMAP]						= true
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
		return 0
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

function imba_gyrocopter_flak_cannon:GetIntrinsicModifierName()
	return "modifier_imba_gyrocopter_flak_cannon_side_gunner"
end

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
				-- self:GetParent():PerformAttack(enemy, false, false, true, true, true, false, false)
				
				ProjectileManager:CreateTrackingProjectile({
					EffectName			= "particles/units/heroes/hero_gyrocopter/gyro_base_attack.vpcf",
					Ability				= self:GetAbility(),
					Source				= self:GetParent():GetAbsOrigin(),
					vSourceLoc			= self:GetParent():GetAbsOrigin(),
					Target				= enemy,
					iMoveSpeed			= self.projectile_speed,
					flExpireTime		= nil,
					bDodgeable			= false,
					bIsAttack			= true,
					bReplaceExisting	= false,
					iSourceAttachment	= self:GetCaster():ScriptLookupAttachment(self.weapons[RandomInt(1, #self.weapons)]),
					bDrawsOnMinimap		= nil,
					bVisibleToEnemies	= true,
					bProvidesVision		= false,
					iVisionRadius		= nil,
					iVisionTeamNumber	= nil,
					ExtraData			= {}
				})
			end
		end
		
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_GYROCOPTER_FLAK_CANNON_SIDE_GUNNER --
------------------------------------------------------

function modifier_imba_gyrocopter_flak_cannon_side_gunner:IsHidden()		return true end
function modifier_imba_gyrocopter_flak_cannon_side_gunner:IsPurgable()		return false end
function modifier_imba_gyrocopter_flak_cannon_side_gunner:RemoveOnDeath()	return false end

-- TODO: Make sure Gyrocopter doesn't double-dip on this, as the scepter effect seems to be tied to the hero

function modifier_imba_gyrocopter_flak_cannon_side_gunner:OnCreated()
	self.fire_rate			= self:GetAbility():GetSpecialValueFor("fire_rate")
	self.scepter_radius		= self:GetAbility():GetSpecialValueFor("scepter_radius")

	self:StartIntervalThink(self.fire_rate)
end

-- "The Side Gunner does not attack when Gyrocopter is hidden, invisible, or affected by Break."
function modifier_imba_gyrocopter_flak_cannon_side_gunner:OnIntervalThink()
	if self:GetParent():HasScepter() and not self:GetParent():IsOutOfGame() and not self:GetParent():IsInvisible() and not self:GetParent():PassivesDisabled() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.scepter_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)) do
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
	
	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.first_missile_impact	= false
	self.second_missile_impact	= false
	
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

-- LinkLuaModifier("modifier_imba_ancient_apparition_cold_feet", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_cold_feet_freeze", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_vortex_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_vortex", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_chilling_touch_slow", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_ancient_apparition_imbued_ice", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_imbued_ice_slow", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_ancient_apparition_anti_abrasion_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_thinker", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_global_cooling", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_ancient_apparition_ice_blast_cold_hearted", "components/abilities/heroes/hero_ancient_apparition", LUA_MODIFIER_MOTION_NONE)

-- imba_ancient_apparition_cold_feet								= class({})
-- modifier_imba_ancient_apparition_cold_feet						= class({})
-- modifier_imba_ancient_apparition_cold_feet_freeze				= class({})

-- imba_ancient_apparition_ice_vortex								= class({})
-- modifier_imba_ancient_apparition_ice_vortex_thinker				= class({})
-- modifier_imba_ancient_apparition_ice_vortex						= class({})

-- imba_ancient_apparition_chilling_touch							= class({})
-- modifier_imba_ancient_apparition_chilling_touch_slow			= class({})

-- imba_ancient_apparition_imbued_ice								= class({})
-- modifier_imba_ancient_apparition_imbued_ice						= class({})
-- modifier_imba_ancient_apparition_imbued_ice_slow				= class({})

-- imba_ancient_apparition_anti_abrasion							= class({})
-- modifier_imba_ancient_apparition_anti_abrasion_thinker			= class({})

-- imba_ancient_apparition_ice_blast								= class({})
-- modifier_imba_ancient_apparition_ice_blast_thinker				= class({})
-- modifier_imba_ancient_apparition_ice_blast						= class({})
-- modifier_imba_ancient_apparition_ice_blast_global_cooling		= class({})
-- modifier_imba_ancient_apparition_ice_blast_cold_hearted			= class({})

-- imba_ancient_apparition_ice_blast_release						= class({})

-- ---------------
-- -- COLD FEET --
-- ---------------

-- function imba_ancient_apparition_cold_feet:GetAOERadius()
	-- return self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_cold_feet_aoe")
-- end

-- function imba_ancient_apparition_cold_feet:GetBehavior()
	-- if not self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		-- return self.BaseClass.GetBehavior(self)
	-- else
		-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	-- end
-- end

-- function imba_ancient_apparition_cold_feet:OnSpellStart()
	-- if not self:GetCaster():HasTalent("special_bonus_imba_ancient_apparition_cold_feet_aoe") then
		-- local target = self:GetCursorTarget()
		
		-- if target:TriggerSpellAbsorb(self) then return end
		
		-- if not target:HasModifier("imba_ancient_apparition_cold_feet") then
			-- target:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_cold_feet", {})
		-- end
	-- else
		-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_cold_feet_aoe"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
		-- for _, enemy in pairs(enemies) do
			-- if not enemy:HasModifier("imba_ancient_apparition_cold_feet") then
				-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_cold_feet", {})
			-- end
		-- end
	-- end
-- end

-- ------------------------
-- -- COLD FEET MODIFIER --
-- ------------------------

-- function modifier_imba_ancient_apparition_cold_feet:IgnoreTenacity()	return true end

-- function modifier_imba_ancient_apparition_cold_feet:OnCreated()
	-- if not IsServer() then return end
	
	-- self.duration		= self:GetAbility():GetDuration()
	-- self.damage			= self:GetAbility():GetSpecialValueFor("damage")
	-- self.break_distance	= self:GetAbility():GetSpecialValueFor("break_distance")
	-- self.stun_duration	= self:GetAbility():GetSpecialValueFor("stun_duration")

	-- self.damageTable 	= {
		-- victim 			= self:GetParent(),
		-- damage 			= self.damage,
		-- damage_type		= self:GetAbility():GetAbilityDamageType(),
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetCaster(),
		-- ability 		= self:GetAbility()
	-- }

	-- self.original_position	= self:GetParent():GetAbsOrigin()
	-- self.counter			= 1
	-- self.ticks				= 0
	
	-- self.interval			= 0.1
	
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetCast")
	
	-- -- This marks the original location on the ground
	-- local cold_feet_marker_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	-- self:AddParticle(cold_feet_marker_particle, false, false, -1, false, false)
	
	-- -- This marks the debuff over the target's head
	-- local cold_feet_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	-- self:AddParticle(cold_feet_particle, false, false, -1, false, false)
	
	-- self:OnIntervalThink()
	-- self:StartIntervalThink(self.interval)
-- end

-- function modifier_imba_ancient_apparition_cold_feet:OnIntervalThink()
	-- if (self:GetParent():GetAbsOrigin() - self.original_position):Length2D() < self.break_distance then
		-- self.counter	= self.counter + self.interval
	
		-- if self.counter >= 1 then
			-- if self.ticks < self.duration then
				-- EmitSoundOnClient("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent():GetPlayerOwner())
			
				-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
			
				-- ApplyDamage(self.damageTable)
				-- self.ticks = self.ticks + 1
				-- self.counter = 0
			-- else
				-- local stun_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet_freeze", {duration = self.stun_duration})
				
				-- if stun_modifier then
					-- stun_modifier:SetDuration(self.stun_duration * (1 - self:GetParent():GetStatusResistance()), true)
				-- end
				
				-- self:Destroy()
			-- end
		-- end
	-- else
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_ancient_apparition_cold_feet:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_EVENT_ON_ORDER
	-- }
	
	-- return decFuncs
-- end

-- -- IMBAfication: Pole Transferral
-- function modifier_imba_ancient_apparition_cold_feet:OnOrder(keys)
	-- if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and keys.target == self:GetParent() and keys.unit ~= self:GetParent() and not keys.unit:IsMagicImmune() then
		-- if not keys.unit:HasModifier("imba_ancient_apparition_cold_feet") then
			-- keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet", {})
		-- end
	-- end
-- end

-- -------------------------------
-- -- COLD FEET FREEZE MODIFIER --
-- -------------------------------

-- function modifier_imba_ancient_apparition_cold_feet_freeze:GetEffectName()
	-- return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
-- end

-- function modifier_imba_ancient_apparition_cold_feet_freeze:GetEffectAttachType()
	-- return PATTACH_OVERHEAD_FOLLOW
-- end

-- function modifier_imba_ancient_apparition_cold_feet_freeze:OnCreated()
	-- if not IsServer() then return end
	
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")

	-- if self:GetCaster():GetName() == "npc_dota_hero_ancient_apparition" then
		-- self:GetCaster():EmitSound("ancient_apparition_appa_ability_coldfeet_0"..RandomInt(2, 4))
	-- end	
-- end

-- function modifier_imba_ancient_apparition_cold_feet_freeze:CheckState()
	-- local state = {
		-- [MODIFIER_STATE_STUNNED]	= true,
		-- [MODIFIER_STATE_FROZEN]		= true
	-- }
	
	-- return state
-- end

-- function modifier_imba_ancient_apparition_cold_feet_freeze:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_DISABLE_HEALING,
		-- MODIFIER_EVENT_ON_ORDER
	-- }
	
	-- return decFuncs
-- end

-- -- IMBAfication: Thoroughly Chilled
-- function modifier_imba_ancient_apparition_cold_feet_freeze:GetDisableHealing()
	-- return 1
-- end

-- -- IMBAfication: Pole Transferral
-- function modifier_imba_ancient_apparition_cold_feet_freeze:OnOrder(keys)
	-- if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() and keys.target == self:GetParent() and keys.unit ~= self:GetParent() and not keys.unit:IsMagicImmune() then
		-- if not keys.unit:HasModifier("imba_ancient_apparition_cold_feet") then
			-- keys.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_cold_feet_freeze", {duration = self:GetRemainingTime()})
		-- end
	-- end
-- end

-- ----------------
-- -- ICE VORTEX --
-- ----------------

-- function imba_ancient_apparition_ice_vortex:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_ancient_apparition_ice_vortex:GetCooldown(level)
	-- return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_ancient_apparition_ice_vortex_cooldown")
-- end

-- function imba_ancient_apparition_ice_vortex:OnUpgrade()
	-- if not self.anti_abrasion_ability then
		-- self.anti_abrasion_ability 		= self:GetCaster():FindAbilityByName("imba_ancient_apparition_anti_abrasion")
	-- end
	
	-- if self.anti_abrasion_ability then
		-- self.anti_abrasion_ability:SetLevel(self:GetLevel())
	-- end
-- end

-- function imba_ancient_apparition_ice_vortex:OnSpellStart()
	-- self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceVortexCast")

	-- if self:GetCaster():GetName() == "npc_dota_hero_ancient_apparition" then
		-- if not self.responses then
			-- self.responses = 
			-- {
				-- ["ancient_apparition_appa_ability_vortex_01"] = 0,
				-- ["ancient_apparition_appa_ability_vortex_02"] = 0,
				-- ["ancient_apparition_appa_ability_vortex_03"] = 0,
				-- ["ancient_apparition_appa_ability_vortex_04"] = 0,
				-- ["ancient_apparition_appa_ability_vortex_05"] = 0,
				-- ["ancient_apparition_appa_ability_vortex_06"] = 0
			-- }
		-- end
		
		-- for response, timer in pairs(self.responses) do
			-- if GameRules:GetDOTATime(true, true) - timer >= 60 then
				-- self:GetCaster():EmitSound(response)
				-- self.responses[response] = GameRules:GetDOTATime(true, true)
				-- break
			-- end
		-- end
	-- end	
	
	-- local vortex_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_ice_vortex_thinker", {duration = self:GetSpecialValueFor("vortex_duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
-- end

-- ---------------------------------
-- -- ICE VORTEX THINKER MODIFIER --
-- ---------------------------------

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:OnCreated()
	-- self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	-- self.vision_aoe			= self:GetAbility():GetSpecialValueFor("vision_aoe")
	-- self.vortex_duration	= self:GetAbility():GetSpecialValueFor("vortex_duration")

	-- if not IsServer() then return end
	
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex.lp")
	
	-- local vortex_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControl(vortex_particle, 0, self:GetParent():GetAbsOrigin())
	-- ParticleManager:SetParticleControl(vortex_particle, 5, Vector(self.radius, 0, 0))
	-- self:AddParticle(vortex_particle, false, false, -1, false, false)
	
	-- AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_aoe, self.vortex_duration, false)
-- end

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():StopSound("Hero_Ancient_Apparition.IceVortex.lp")
	-- self:GetParent():RemoveSelf()
-- end

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:IsHidden()				return true end

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:IsAura() 				return true end
-- function modifier_imba_ancient_apparition_ice_vortex_thinker:IsAuraActiveOnDeath() 	return false end

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraRadius()		return self.radius end
-- function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end

-- function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
-- function modifier_imba_ancient_apparition_ice_vortex_thinker:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_imba_ancient_apparition_ice_vortex_thinker:GetModifierAura()		return "modifier_imba_ancient_apparition_ice_vortex" end

-- -------------------------
-- -- ICE VORTEX MODIFIER --
-- -------------------------

-- function modifier_imba_ancient_apparition_ice_vortex:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_frost.vpcf"
-- end

-- function modifier_imba_ancient_apparition_ice_vortex:OnCreated()
	-- if self:GetAbility() then
		-- self.radius				= self:GetAbility():GetSpecialValueFor("radius")
		-- self.movement_speed_pct	= self:GetAbility():GetTalentSpecialValueFor("movement_speed_pct")
		-- self.spell_resist_pct	= self:GetAbility():GetTalentSpecialValueFor("spell_resist_pct")
	-- else
		-- self.radius				= 0
		-- self.movement_speed_pct	= 0
		-- self.spell_resist_pct	= 0
	-- end
-- end

-- function modifier_imba_ancient_apparition_ice_vortex:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	-- }
	
	-- return decFuncs	
-- end

-- function modifier_imba_ancient_apparition_ice_vortex:GetModifierMoveSpeedBonus_Percentage()
	-- if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		-- return self.movement_speed_pct
	-- else
		-- return self.movement_speed_pct * (-1)
	-- end
-- end

-- function modifier_imba_ancient_apparition_ice_vortex:GetModifierSpellAmplify_Percentage()
	-- if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		-- return self.spell_resist_pct
	-- else
		-- return 0
	-- end
-- end

-- --------------------
-- -- CHILLING TOUCH --
-- --------------------

-- function imba_ancient_apparition_chilling_touch:OnUpgrade()
	-- if not self.imbued_ice_ability then
		-- self.imbued_ice_ability 		= self:GetCaster():FindAbilityByName("imba_ancient_apparition_imbued_ice")
	-- end
	
	-- if self.imbued_ice_ability then
		-- self.imbued_ice_ability:SetLevel(self:GetLevel())
	-- end
-- end

-- function imba_ancient_apparition_chilling_touch:GetIntrinsicModifierName()
	-- return "modifier_generic_orb_effect_lua"
-- end

-- function imba_ancient_apparition_chilling_touch:GetProjectileName()
	-- return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_projectile.vpcf"
-- end

-- function imba_ancient_apparition_chilling_touch:GetCastRange()
	-- return self:GetCaster():Script_GetAttackRange() + self:GetTalentSpecialValueFor("attack_range_bonus")
-- end

-- function imba_ancient_apparition_chilling_touch:GetCooldown(level)
	-- if not self:GetCaster():HasScepter() then
		-- return self.BaseClass.GetCooldown(self, level)
	-- else
		-- return 0
	-- end
-- end

-- function imba_ancient_apparition_chilling_touch:OnOrbFire()
	-- self:GetCaster():EmitSound("Hero_Ancient_Apparition.ChillingTouch.Cast")
-- end

-- -- "The attacks first apply the debuff, then their own damage."
-- function imba_ancient_apparition_chilling_touch:OnOrbImpact( keys )
	-- if keys.target:IsMagicImmune() then return end

	-- keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")

	-- local chilling_touch_modifier = keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_chilling_touch_slow", { duration = self:GetSpecialValueFor("duration") })

	-- if chilling_touch_modifier then
		-- chilling_touch_modifier:SetDuration(self:GetSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()), true)
	-- end
	
	-- -- IMBAfication: Packed Ice
	-- local stun_modifier = keys.target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("packed_ice_duration") })

	-- if stun_modifier then
		-- stun_modifier:SetDuration(self:GetSpecialValueFor("packed_ice_duration") * (1 - keys.target:GetStatusResistance()), true)
	-- end

	-- local damageTable = {
		-- victim 			= keys.target,
		-- damage 			= self:GetTalentSpecialValueFor("damage"),
		-- damage_type		= DAMAGE_TYPE_MAGICAL,
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetCaster(),
		-- ability 		= self
	-- }

	-- ApplyDamage(damageTable)
	
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetTalentSpecialValueFor("damage"), nil)
-- end

-- ----------------------------------
-- -- CHILLING TOUCH SLOW MODIFIER --
-- ----------------------------------

-- function modifier_imba_ancient_apparition_chilling_touch_slow:OnCreated()
	-- if self:GetAbility() then
		-- self.slow	= self:GetAbility():GetSpecialValueFor("slow")
	-- else
		-- self.slow	= 0
	-- end
-- end

-- function modifier_imba_ancient_apparition_chilling_touch_slow:DeclareFunctions()
	-- return {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	-- }	
-- end

-- function modifier_imba_ancient_apparition_chilling_touch_slow:GetModifierMoveSpeedBonus_Percentage()
	-- if self.slow then
		-- return self.slow * (-1)
	-- end
-- end

-- ----------------
-- -- IMBUED ICE --
-- ----------------

-- function imba_ancient_apparition_imbued_ice:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_ancient_apparition_imbued_ice:OnSpellStart()
	-- local position = self:GetCursorPosition()

	-- self:GetCaster():EmitSound("Hero_Ancient_Apparition.Imbued_Ice_Cast")

	-- local imbued_ice_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	-- ParticleManager:SetParticleControl(imbued_ice_particle, 0, position)
	-- ParticleManager:SetParticleControl(imbued_ice_particle, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), 0))
	-- ParticleManager:ReleaseParticleIndex(imbued_ice_particle)

	-- -- "The buff is always placed on Ancient Apparition, even when he is outside the targeted area."
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_imbued_ice", {duration = self:GetSpecialValueFor("buff_duration")})

	-- local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), position, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	
	-- for _, ally in pairs(allies) do
		-- if ally ~= self:GetCaster() then
			-- ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_ancient_apparition_imbued_ice", {duration = self:GetSpecialValueFor("buff_duration")})
		-- end
	-- end
-- end

-- -------------------------
-- -- IMBUED ICE MODIFIER --
-- -------------------------

-- function modifier_imba_ancient_apparition_imbued_ice:OnCreated()
	-- if not IsServer() then return end
	
	-- self.number_of_attacks		= self:GetAbility():GetSpecialValueFor("number_of_attacks")
	-- self.damage_per_attack		= self:GetAbility():GetSpecialValueFor("damage_per_attack")
	-- self.move_speed_slow		= self:GetAbility():GetSpecialValueFor("move_speed_slow")
	-- self.move_speed_duration	= self:GetAbility():GetSpecialValueFor("move_speed_duration")
	
	-- -- "The damage source is set to be the attacking hero, not Ancient Apparition."
	-- self.damage_table	= {
		-- victim 			= nil,
		-- damage 			= self.damage_per_attack,
		-- damage_type		= DAMAGE_TYPE_MAGICAL,
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetParent(),
		-- ability 		= self:GetAbility()
	-- }
	
	-- local imbued_ice_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(imbued_ice_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	-- self:AddParticle(imbued_ice_particle, false, false, -1, false, false)
	
	-- self:SetStackCount(self.number_of_attacks)
-- end

-- function modifier_imba_ancient_apparition_imbued_ice:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_ancient_apparition_imbued_ice:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED
	-- }
	
	-- return decFuncs
-- end

-- -- "Does not work against buildings, but fully works against wards."
-- function modifier_imba_ancient_apparition_imbued_ice:OnAttackLanded(keys)
	-- if keys.attacker == self:GetParent() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() then
		-- self:DecrementStackCount()
		
		-- keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")
		
		-- self.damage_table.victim = keys.target
		-- ApplyDamage(self.damage_table)
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self.damage_per_attack, nil)
		
		-- local imbued_ice_slow_modifier = keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_ancient_apparition_imbued_ice_slow", {duration = self.move_speed_duration})
		
		-- if imbued_ice_slow_modifier then
			-- imbued_ice_slow_modifier:SetDuration(self.move_speed_duration * (1 - keys.target:GetStatusResistance()), true)
		-- end
		
		-- if self:GetStackCount() <= 0 then
			-- self:Destroy()
		-- end
	-- end
-- end

-- ------------------------------
-- -- IMBUED ICE SLOW MODIFIER --
-- ------------------------------

-- function modifier_imba_ancient_apparition_imbued_ice_slow:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_ancient_apparition_imbued_ice_slow:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_frost.vpcf"
-- end

-- function modifier_imba_ancient_apparition_imbued_ice_slow:OnCreated()
	-- if self:GetAbility() then
		-- self.move_speed_slow	= self:GetAbility():GetSpecialValueFor("move_speed_slow")
	-- else
		-- self.move_speed_slow	= 0
	-- end
-- end

-- function modifier_imba_ancient_apparition_imbued_ice_slow:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_DISABLE_HEALING
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_ancient_apparition_imbued_ice_slow:GetModifierMoveSpeedBonus_Percentage()
	-- return self.move_speed_slow
-- end

-- function modifier_imba_ancient_apparition_imbued_ice_slow:GetDisableHealing()
	-- return 1
-- end

-- -------------------
-- -- ANTI-ABRASION --
-- -------------------

-- function imba_ancient_apparition_anti_abrasion:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_ancient_apparition_anti_abrasion:OnSpellStart()
	-- self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceVortexCast")
	
	-- local vortex_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_anti_abrasion_thinker", {duration = self:GetSpecialValueFor("vortex_duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
-- end

-- ----------------------------
-- -- ANTI-ABRASION MODIFIER --
-- ----------------------------

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:OnCreated()
	-- self.radius		= self:GetAbility():GetSpecialValueFor("radius")
	-- self.vision_aoe	= self:GetAbility():GetSpecialValueFor("vision_aoe")
	-- self.vortex_duration	= self:GetAbility():GetSpecialValueFor("vortex_duration")

	-- if not IsServer() then return end
	
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex.lp")
	
	-- local vortex_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_anti_abrasion.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControl(vortex_particle, 0, self:GetParent():GetAbsOrigin())
	-- ParticleManager:SetParticleControl(vortex_particle, 5, Vector(self.radius, 0, 0))
	-- self:AddParticle(vortex_particle, false, false, -1, false, false)
	
	-- AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_aoe, self.vortex_duration, false)
-- end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():StopSound("Hero_Ancient_Apparition.IceVortex.lp")
	-- self:GetParent():RemoveSelf()
-- end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsHidden()				return true end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsAura() 				return true end
-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:IsAuraActiveOnDeath() 	return false end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraRadius()			return self.radius end
-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetModifierAura()		return "modifier_ice_slide" end

-- function modifier_imba_ancient_apparition_anti_abrasion_thinker:GetAuraDuration()		return 0.25 end

-- ---------------
-- -- ICE BLAST --
-- ---------------

-- function imba_ancient_apparition_ice_blast:GetAssociatedSecondaryAbilities()	return "imba_ancient_apparition_ice_blast_release" end

-- function imba_ancient_apparition_ice_blast:OnUpgrade()
	-- if not self.release_ability then
		-- self.release_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")
	-- end
	
	-- if self.release_ability and not self.release_ability:IsTrained() then
		-- self.release_ability:SetLevel(1)
	-- end
-- end

-- function imba_ancient_apparition_ice_blast:OnSpellStart()
	-- -- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	-- if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		-- self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	-- end

	-- EmitSoundOnClient("Hero_Ancient_Apparition.IceBlast.Tracker", self:GetCaster():GetPlayerOwner())

	-- local velocity	= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed")

	-- -- Use a dummy to attach logic to
	-- self.ice_blast_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_ancient_apparition_ice_blast_thinker", {x = velocity.x, y = velocity.y}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	-- local linear_projectile = {
		-- Ability				= self,
		-- --EffectName			= "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_initial.vpcf", -- Since this should only show to allies I think I have to make this a separate particle on a modifier thinker?
		-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
		-- fDistance			= math.huge, -- Will this cause issues?
		-- fStartRadius		= 0,
		-- fEndRadius			= 0,
		-- Source				= self:GetCaster(),
		-- bDrawsOnMinimap 	= true,
		-- bVisibleToEnemies 	= false,
		-- bHasFrontalCone		= false,
		-- bReplaceExisting	= false,
		-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_NONE,
		-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- fExpireTime 		= GameRules:GetGameTime() + 30.0,
		-- bDeleteOnHit		= false,
		-- vVelocity			= Vector(velocity.x, velocity.y, 0),
		-- bProvidesVision		= true,
		-- iVisionRadius 		= self:GetSpecialValueFor("target_sight_radius"),
		-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
		
		-- ExtraData			=
		-- {
			-- direction_x		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).x,
			-- direction_y		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).y,
			-- direction_z		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()).z,
			-- ice_blast_dummy	= self.ice_blast_dummy:entindex(),
		-- }
	-- }

	-- self.initial_projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)
	
	-- if not self.release_ability then
		-- self.release_ability = self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")
	-- end	
	
	-- if self.release_ability then
		-- self:GetCaster():SwapAbilities(self:GetName(), self.release_ability:GetName(), false, true)
	-- end
-- end

-- function imba_ancient_apparition_ice_blast:OnProjectileThink_ExtraData(location, data)
	-- if data.ice_blast_dummy then
		-- EntIndexToHScript(data.ice_blast_dummy):SetAbsOrigin(location)
	-- end
	
	-- if not self:GetCaster():IsAlive() and self.release_ability then
		-- self.release_ability:OnSpellStart()
	-- end
-- end

-- function imba_ancient_apparition_ice_blast:OnProjectileHit_ExtraData(target, location, data)
	-- if not target and data.ice_blast_dummy then
		-- local ice_blast_thinker_modifier = EntIndexToHScript(data.ice_blast_dummy):FindModifierByNameAndCaster("modifier_imba_ancient_apparition_ice_blast_thinker", self:GetCaster())
		
		-- if ice_blast_thinker_modifier then
			-- ice_blast_thinker_modifier:Destroy()
		-- end
	-- end
-- end

-- --------------------------------
-- -- ICE BLAST THINKER MODIFIER --
-- --------------------------------

-- function modifier_imba_ancient_apparition_ice_blast_thinker:IsPurgable()	return false end

-- function modifier_imba_ancient_apparition_ice_blast_thinker:OnCreated(params)
	-- if not IsServer() then return end
	
	-- local ice_blast_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	-- ParticleManager:SetParticleControl(ice_blast_particle, 1, Vector(params.x, params.y, 0))
	-- self:AddParticle(ice_blast_particle, false, false, -1, false, false)
-- end

-- function modifier_imba_ancient_apparition_ice_blast_thinker:OnDestroy()
	-- if not IsServer() then return end

	-- self.release_ability	= self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast_release")

	-- if self:GetAbility() and self:GetAbility():IsHidden() and self.release_ability then	
		-- self:GetCaster():SwapAbilities(self:GetAbility():GetName(), self.release_ability:GetName(), true, false)
	-- end
	
	-- self:GetParent():RemoveSelf()
-- end

-- ------------------------
-- -- ICE BLAST MODIFIER --
-- ------------------------

-- function modifier_imba_ancient_apparition_ice_blast:IsPurgable()	return false end

-- function modifier_imba_ancient_apparition_ice_blast:GetEffectName()
	-- return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
-- end

-- function modifier_imba_ancient_apparition_ice_blast:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_frost.vpcf"
-- end

-- function modifier_imba_ancient_apparition_ice_blast:OnCreated(params)
	-- if not IsServer() then return end
	
	-- self.dot_damage		= params.dot_damage
	-- self.kill_pct		= params.kill_pct
	
	-- self.damage_table	= {
		-- victim 			= self:GetParent(),
		-- damage 			= self.dot_damage,
		-- damage_type		= DAMAGE_TYPE_MAGICAL,
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetCaster(),
		-- ability 		= self:GetAbility()
	-- }
	
	-- self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
-- end

-- function modifier_imba_ancient_apparition_ice_blast:OnRefresh(params)
	-- self:OnCreated(params)
-- end

-- function modifier_imba_ancient_apparition_ice_blast:OnIntervalThink()
	-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Tick")

	-- ApplyDamage(self.damage_table)
	
	-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.dot_damage, nil)
-- end

-- function modifier_imba_ancient_apparition_ice_blast:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_DISABLE_HEALING,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_ancient_apparition_ice_blast:GetDisableHealing()
	-- return 1
-- end

-- function modifier_imba_ancient_apparition_ice_blast:OnTakeDamageKillCredit(keys)
	-- if keys.target == self:GetParent() and (self:GetParent():GetHealth() / self:GetParent():GetMaxHealth()) * 100 <= self.kill_pct then
		-- if keys.attacker == self:GetParent() then
			-- self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		-- else
			-- self:GetParent():Kill(self:GetAbility(), keys.attacker)
		-- end
		
		-- if not self:GetParent():IsAlive() then
			-- local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			-- ParticleManager:ReleaseParticleIndex(ice_blast_particle)
		-- end
	-- end
-- end

-- ---------------------------------------
-- -- ICE BLAST GLOBAL COOLING MODIFIER --
-- ---------------------------------------

-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:IsPurgable()			return false end
-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:RemoveOnDeath()		return false end

-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_frost.vpcf"
-- end

-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:OnCreated()
	-- self.global_cooling_move_speed_reduction	= self:GetAbility():GetSpecialValueFor("global_cooling_move_speed_reduction")
-- end

-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_ancient_apparition_ice_blast_global_cooling:GetModifierMoveSpeedBonus_Percentage()
	-- return self.global_cooling_move_speed_reduction * (-1)
-- end

-- -------------------------------------
-- -- ICE BLAST COLD HEARTED MODIFIER --
-- -------------------------------------

-- function modifier_imba_ancient_apparition_ice_blast_cold_hearted:OnCreated(params)
	-- if not IsServer() then return end
	
	-- if self:GetAbility() then
		-- self.cold_hearted_pct	= self:GetAbility():GetSpecialValueFor("cold_hearted_pct") * 0.01
	-- else
		-- self.cold_hearted_pct	= 0.5
	-- end

	-- self:SetStackCount(self:GetStackCount() + (params.regen * self.cold_hearted_pct))
-- end

-- function modifier_imba_ancient_apparition_ice_blast_cold_hearted:OnRefresh(params)
	-- self:OnCreated(params)
-- end

-- function modifier_imba_ancient_apparition_ice_blast_cold_hearted:DeclareFunctions()
	-- return {MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
-- end

-- function modifier_imba_ancient_apparition_ice_blast_cold_hearted:GetModifierConstantHealthRegen()
	-- return self:GetStackCount()
-- end

-- -----------------------
-- -- ICE BLAST RELEASE --
-- -----------------------

-- function imba_ancient_apparition_ice_blast_release:IsStealable()	return false end
-- function imba_ancient_apparition_ice_blast_release:GetAssociatedPrimaryAbilities()	return "imba_ancient_apparition_ice_blast" end

-- function imba_ancient_apparition_ice_blast_release:OnSpellStart()
	-- if not self.ice_blast_ability then
		-- self.ice_blast_ability	= self:GetCaster():FindAbilityByName("imba_ancient_apparition_ice_blast")
	-- end
	
	-- if self.ice_blast_ability then
		-- if self.ice_blast_ability.ice_blast_dummy and self.ice_blast_ability.initial_projectile then
			-- -- Distance vector between where the ice blast tracer ends and where Ancient Apparition is
			-- local vector	= self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
			
			-- -- "The ice blast travels at a speed of 750, or reaches the targeted point in 2 seconds, whichever is faster."
			-- local velocity	= vector:Normalized() * math.max(vector:Length2D() / 2, 750)

			-- -- "The explosion radius starts at 275 and increases by 50 for every second the tracer has traveled, capped at 1000 radius."
			-- local final_radius	= math.min(self.ice_blast_ability:GetSpecialValueFor("radius_min") + ((vector:Length2D() / self.ice_blast_ability:GetSpecialValueFor("speed")) * self.ice_blast_ability:GetSpecialValueFor("radius_grow")), self.ice_blast_ability:GetSpecialValueFor("radius_max"))

			-- --EmitSoundOnClient("Hero_Ancient_Apparition.IceBlastRelease.Cast.Self", self:GetCaster():GetPlayerOwner())
			-- self:GetCaster():EmitSound("Hero_Ancient_Apparition.IceBlastRelease.Cast")
			
			-- local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			-- ParticleManager:SetParticleControl(ice_blast_particle, 0, self:GetCaster():GetAbsOrigin())
			-- -- CP1: Direction Vector
			-- ParticleManager:SetParticleControl(ice_blast_particle, 1, velocity)
			-- -- CP5: Duration
			-- ParticleManager:SetParticleControl(ice_blast_particle, 5, Vector(math.min(vector:Length2D() / velocity:Length2D(), 2), 0, 0))
			-- ParticleManager:ReleaseParticleIndex(ice_blast_particle)

			-- local marker_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_marker.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber())
			-- ParticleManager:SetParticleControl(marker_particle, 0, self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin())
			-- ParticleManager:SetParticleControl(marker_particle, 1, Vector(final_radius, 1, 1))

			-- -- "The tracer has 500 flying vision around itself. Upon release, provides 650 flying vision of the impact site for 4 seconds."
			-- AddFOWViewer(self:GetCaster():GetTeamNumber(), self.ice_blast_ability.ice_blast_dummy:GetAbsOrigin(), 650, 4, false)

			-- local linear_projectile = {
				-- Ability				= self,
				-- --EffectName			= "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_final.vpcf",
				-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
				-- fDistance			= vector:Length2D(),
				-- fStartRadius		= self.ice_blast_ability:GetSpecialValueFor("path_radius"),
				-- fEndRadius			= self.ice_blast_ability:GetSpecialValueFor("path_radius"),
				-- Source				= self:GetCaster(),
				-- bHasFrontalCone		= false,
				-- bReplaceExisting	= false,
				-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_NONE,
				-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
				-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
				-- bDeleteOnHit		= true,
				-- vVelocity			= velocity,
				-- bProvidesVision		= true,
				-- iVisionRadius 		= self.ice_blast_ability:GetSpecialValueFor("target_sight_radius"),
				-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
				
				-- ExtraData			=
				-- {
					-- marker_particle	= marker_particle,
					-- final_radius	= final_radius
				-- }
			-- }

			-- self.initial_projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)

			-- self.ice_blast_ability.ice_blast_dummy:Destroy()
			-- ProjectileManager:DestroyLinearProjectile(self.ice_blast_ability.initial_projectile)
			
			-- self.ice_blast_ability.ice_blast_dummy		= nil
			-- self.ice_blast_ability.initial_projectile	= nil
		-- end
	
		-- self:GetCaster():SwapAbilities(self:GetName(), self.ice_blast_ability:GetName(), false, true)
	-- end
-- end

-- function imba_ancient_apparition_ice_blast_release:OnProjectileThink_ExtraData(location, data)
	-- -- "The ice blast has 500 flying vision, lasting 3 seconds."
	-- if self.ice_blast_ability then
		-- AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self.ice_blast_ability:GetSpecialValueFor("target_sight_radius"), 3, false)
		
		-- -- "The debuff can also be placed on spell immune or invulnerable, but not on hidden units."
		-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self.ice_blast_ability:GetSpecialValueFor("path_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
		-- local duration		= self.ice_blast_ability:GetSpecialValueFor("frostbite_duration")
		
		-- if self:GetCaster():HasScepter() then
			-- duration		= self.ice_blast_ability:GetSpecialValueFor("frostbite_duration_scepter")
		-- end

		-- for _, enemy in pairs(enemies) do
			-- -- IMBAfication: Absolute Freeze
			-- local ice_blast_modifier = enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast", 
				-- {
					-- duration		= duration,
					-- dot_damage		= self.ice_blast_ability:GetSpecialValueFor("dot_damage"),
					-- kill_pct		= self.ice_blast_ability:GetTalentSpecialValueFor("kill_pct")
				-- }
			-- )
			
			-- if ice_blast_modifier then
				-- ice_blast_modifier:SetDuration(duration * (1 - enemy:GetStatusResistance()), true)
			-- end
		-- end
	-- end
-- end

-- function imba_ancient_apparition_ice_blast_release:OnProjectileHit_ExtraData(target, location, data)
	-- if not target and self.ice_blast_ability then
		-- EmitSoundOnLocationWithCaster(location, "Hero_Ancient_Apparition.IceBlast.Target", self:GetCaster())
	
		-- if data.marker_particle then
			-- ParticleManager:DestroyParticle(data.marker_particle, false)
			-- ParticleManager:ReleaseParticleIndex(data.marker_particle)
		-- end
	
		-- -- "The debuff can also be placed on spell immune or invulnerable, but not on hidden units."
		-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, data.final_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	
		-- local damageTable = {
			-- victim 			= nil,
			-- damage 			= self.ice_blast_ability:GetAbilityDamage(),
			-- damage_type		= self.ice_blast_ability:GetAbilityDamageType(),
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
		-- }
		
		-- local duration		= self.ice_blast_ability:GetSpecialValueFor("frostbite_duration")
		
		-- if self:GetCaster():HasScepter() then
			-- duration		= self.ice_blast_ability:GetSpecialValueFor("frostbite_duration_scepter")
		-- end
	
		-- for _, enemy in pairs(enemies) do
			-- -- IMBAfication: Absolute Freeze
			-- local ice_blast_modifier = enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast", 
				-- {
					-- duration		= duration,
					-- dot_damage		= self.ice_blast_ability:GetSpecialValueFor("dot_damage"),
					-- kill_pct		= self.ice_blast_ability:GetTalentSpecialValueFor("kill_pct")
				-- }
			-- )
			
			-- if ice_blast_modifier then
				-- ice_blast_modifier:SetDuration(duration * (1 - enemy:GetStatusResistance()), true)
			-- end
		
			-- if not enemy:IsMagicImmune() then
				-- damageTable.victim = enemy

				-- ApplyDamage(damageTable)
			-- end
			
			-- -- IMBAfication: Cold-Hearted
			-- self:GetCaster():AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast_cold_hearted", {duration = duration, regen = enemy:GetHealthRegen()})
		-- end
		
		-- -- -- IMBAfication: Global Cooling
		-- -- -- Something something lag? IDK
		-- -- local all_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		
		-- -- local global_cooling_modifier = nil
		
		-- -- for _, enemy in pairs(all_enemies) do
			-- -- global_cooling_modifier = enemy:AddNewModifier(self:GetCaster(), self.ice_blast_ability, "modifier_imba_ancient_apparition_ice_blast_global_cooling", {duration = duration})
			
			-- -- if global_cooling_modifier then
				-- -- global_cooling_modifier:SetDuration(duration * (1 - enemy:GetStatusResistance()), true)
			-- -- end
		-- -- end
	-- end
-- end

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
