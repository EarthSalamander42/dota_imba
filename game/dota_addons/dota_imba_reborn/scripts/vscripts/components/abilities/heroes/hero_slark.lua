-- Creator:
--	   AltiV, November 15th, 2019

LinkLuaModifier("modifier_imba_slark_dark_pact", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_dark_pact_pulses", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_dark_pact_thinker", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_slark_pounce", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_imba_slark_pounce_leash", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_slark_essence_shift", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_essence_shift_debuff_counter", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_essence_shift_permanent_buff", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_essence_shift_permanent_debuff", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_slark_shadow_dance_passive_regen", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_shadow_dance_aura", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_shadow_dance", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slark_shadow_dance_dark_reef_handler", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_slark_visual", "components/abilities/heroes/hero_slark", LUA_MODIFIER_MOTION_NONE)

imba_slark_dark_pact								= imba_slark_dark_pact or class({})
modifier_imba_slark_dark_pact						= modifier_imba_slark_dark_pact or class({})
modifier_imba_slark_dark_pact_pulses				= modifier_imba_slark_dark_pact_pulses or class({})
modifier_imba_slark_dark_pact_thinker				= modifier_imba_slark_dark_pact_thinker or class({})

imba_slark_pounce									= imba_slark_pounce or class({})
modifier_imba_slark_pounce							= modifier_imba_slark_pounce or class({})
modifier_imba_slark_pounce_leash					= modifier_imba_slark_pounce_leash or class({})

-- imba_slark_essence_shift							= imba_slark_essence_shift or class({})
-- modifier_imba_slark_essence_shift					= modifier_imba_slark_essence_shift or class({})
-- modifier_imba_slark_essence_shift_debuff_counter			= modifier_imba_slark_essence_shift_debuff_counter or class({})
-- modifier_imba_slark_essence_shift_permanent_buff	= modifier_imba_slark_essence_shift_permanent_buff or class({})
-- modifier_imba_slark_essence_shift_permanent_debuff	= modifier_imba_slark_essence_shift_permanent_buff or class({})

imba_slark_essence_shift							= class({})
modifier_imba_slark_essence_shift					= class({})
modifier_imba_slark_essence_shift_debuff_counter	= class({})
modifier_imba_slark_essence_shift_permanent_buff	= class({})
modifier_imba_slark_essence_shift_permanent_debuff	= class({})

-- imba_slark_shadow_dance								= imba_slark_shadow_dance or class({})
-- modifier_imba_slark_shadow_dance_passive_regen		= modifier_imba_slark_shadow_dance_passive_regen or class({})
-- modifier_imba_slark_shadow_dance					= modifier_imba_slark_shadow_dance or class({})

imba_slark_shadow_dance								= class({})
modifier_imba_slark_shadow_dance_passive_regen		= class({})
modifier_imba_slark_shadow_dance_aura				= class({})
modifier_imba_slark_shadow_dance					= class({})
modifier_imba_slark_shadow_dance_dark_reef_handler	= class({})

modifier_imba_slark_visual							= class({})

--------------------------
-- IMBA_SLARK_DARK_PACT --
--------------------------

function imba_slark_dark_pact:GetIntrinsicModifierName()
	return "modifier_imba_slark_dark_pact_thinker"
end

function imba_slark_dark_pact:GetBehavior()
	if self:GetCaster():IsHero() then
		return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function imba_slark_dark_pact:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) - self:GetCaster():GetCastRangeBonus()
end

function imba_slark_dark_pact:OnSpellStart()
	EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Slark.DarkPact.PreCast", self:GetCaster())
	
	local delay_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_slark_dark_pact", {
		duration		= self:GetSpecialValueFor("delay"),
		pulse_duration	= self:GetSpecialValueFor("pulse_duration"),
		radius			= self:GetSpecialValueFor("radius"),
		total_damage	= self:GetTalentSpecialValueFor("total_damage"),
		total_pulses	= self:GetSpecialValueFor("total_pulses"),
		pulse_interval	= self:GetSpecialValueFor("pulse_interval"),
		premature_stack_activation	= self:GetSpecialValueFor("premature_stack_activation"),
		premature_spawn_duration	= self:GetSpecialValueFor("premature_spawn_duration"),
		premature_health_pct	= self:GetSpecialValueFor("premature_health_pct"),
		premature_attack_pct	= self:GetSpecialValueFor("premature_attack_pct"),
		premature_base_health	= self:GetSpecialValueFor("premature_base_health"),
		premature_base_attack_min	= self:GetSpecialValueFor("premature_base_attack_min"),
		premature_base_attack_max	= self:GetSpecialValueFor("premature_base_attack_max")
	})
	
	if delay_modifier then
		local start_particle	= ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetTeamNumber())
		ParticleManager:SetParticleControlEnt(start_particle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(start_particle, 61, Vector(0, 0, 0))
		delay_modifier:AddParticle(start_particle, false, false, -1, false, false)
	end
end

-----------------------------------
-- MODIFIER_IMBA_SLARK_DARK_PACT --
-----------------------------------

function modifier_imba_slark_dark_pact:IsHidden()	return true end
function modifier_imba_slark_dark_pact:IsPurgable()	return false end

function modifier_imba_slark_dark_pact:OnCreated(params)
	if not IsServer() then return end
	
	self.duration		= params.duration
	self.pulse_duration	= params.pulse_duration
	self.radius			= params.radius
	self.total_damage	= params.total_damage
	self.total_pulses	= params.total_pulses
	self.pulse_interval	= params.pulse_interval
	self.premature_stack_activation	= params.premature_stack_activation
	self.premature_spawn_duration	= params.premature_spawn_duration
	self.premature_health_pct	= params.premature_health_pct
	self.premature_attack_pct	= params.premature_attack_pct
	self.premature_base_health	= params.premature_base_health
	self.premature_base_attack_min	= params.premature_base_attack_min
	self.premature_base_attack_max	= params.premature_base_attack_max
	
	self.ability_damage_type	= self:GetAbility():GetAbilityDamageType()
end

function modifier_imba_slark_dark_pact:OnDestroy()
	if not IsServer() then return end

	if self:GetRemainingTime() <= 0 and self:GetParent():IsAlive() then
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_dark_pact_pulses", {
			duration		= self.pulse_duration,
			radius			= self.radius,
			total_damage	= self.total_damage,
			total_pulses	= self.total_pulses,
			pulse_interval	= self.pulse_interval,
			ability_damage_type	= self.ability_damage_type,
			premature_stack_activation	= self.premature_stack_activation,
			premature_spawn_duration	= self.premature_spawn_duration,
			premature_health_pct	= self.premature_health_pct,
			premature_attack_pct	= self.premature_attack_pct,
			premature_base_health	= self.premature_base_health,
			premature_base_attack_min	= self.premature_base_attack_min,
			premature_base_attack_max	= self.premature_base_attack_max
		})
	end
end

------------------------------------------
-- MODIFIER_IMBA_SLARK_DARK_PACT_PULSES --
------------------------------------------

function modifier_imba_slark_dark_pact_pulses:IsHidden()		return true end
function modifier_imba_slark_dark_pact_pulses:IsPurgable()		return false end

function modifier_imba_slark_dark_pact_pulses:OnCreated(params)
	if not IsServer() then return end
	
	self.radius			= params.radius
	self.total_damage	= params.total_damage
	self.total_pulses	= params.total_pulses
	self.pulse_interval	= params.pulse_interval
	self.ability_damage_type	= params.ability_damage_type
	self.premature_stack_activation	= params.premature_stack_activation
	self.premature_spawn_duration	= params.premature_spawn_duration
	self.premature_health_pct	= params.premature_health_pct
	self.premature_attack_pct	= params.premature_attack_pct
	self.premature_base_health	= params.premature_base_health
	self.premature_base_attack_min	= params.premature_base_attack_min
	self.premature_base_attack_max	= params.premature_base_attack_max
	
	self.premature_modifier	= self:GetCaster():FindModifierByName("modifier_imba_slark_dark_pact_thinker")
	
	self.current_health		= self:GetParent():GetHealth()
	self.current_health_pct	= self:GetParent():GetHealthPercent()
	
	self.damage_per_pulse	= self.total_damage / self.total_pulses
	
	self.damage_table	= {
		victim 			= nil,
		damage 			= self.damage_per_pulse,
		damage_type		= self.ability_damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	self.damage_table_self	= {
		victim 			= self:GetParent(),
		damage 			= self.damage_per_pulse * 0.5,
		damage_type		= self.ability_damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NON_LETHAL,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	self:GetParent():EmitSound("Hero_Slark.DarkPact.Cast")
	
	local visual_unit = CreateUnitByName("npc_dota_slark_visual", self:GetParent():GetAbsOrigin(), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
	visual_unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_slark_visual", {})
	visual_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self:GetDuration()})
	-- visual_unit:FollowEntity(self:GetParent(), false)
	
	-- IDK, this particle feels a LITTLE off...
	self.pulses_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, visual_unit)
	ParticleManager:SetParticleControlEnt(self.pulses_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.pulses_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.pulses_particle, 2, Vector(self.radius, 0, 0))
	self:AddParticle(self.pulses_particle, false, false, -1, false, false)
	
	-- OKAY SO THIS THING ACTUALLY DESTROYS TREES IN A SMALL RADIUS AND THE WIKI SAYS NOTHING ABOUT THIS WTF
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), 75, true )	
	
	-- IMBAfication: Premature Spawn
	if self.premature_modifier then
		if self.premature_modifier:GetStackCount() < self.premature_stack_activation then
			self.premature_modifier:IncrementStackCount()
			self.bStoreHealth	= true
		elseif self:GetAbility() and self:GetAbility():GetAutoCastState() then
			local spawn_unit = CreateUnitByName("npc_dota_slark_spawn", self:GetParent():GetAbsOrigin() + RandomVector(128), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
			
			if self:GetParent().GetPlayerID then
				spawn_unit:SetControllableByPlayer(self:GetParent():GetPlayerID(), false)
			end
			
			spawn_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self.premature_spawn_duration})
			
			if spawn_unit:HasAbility("imba_slark_dark_pact") and self:GetCaster():HasAbility("imba_slark_dark_pact") then
				spawn_unit:FindAbilityByName("imba_slark_dark_pact"):SetLevel(self:GetCaster():FindAbilityByName("imba_slark_dark_pact"):GetLevel())
			end
			
			if spawn_unit:HasAbility("imba_slark_pounce") and self:GetCaster():HasAbility("imba_slark_pounce") then
				spawn_unit:FindAbilityByName("imba_slark_pounce"):SetLevel(self:GetCaster():FindAbilityByName("imba_slark_pounce"):GetLevel())
			end
			
			if spawn_unit:HasAbility("imba_slark_essence_shift") and self:GetCaster():HasAbility("imba_slark_essence_shift") then
				spawn_unit:FindAbilityByName("imba_slark_essence_shift"):SetLevel(self:GetCaster():FindAbilityByName("imba_slark_essence_shift"):GetLevel())
			end
			
			if self.premature_modifier.store_health_loss then
				spawn_unit:SetBaseMaxHealth(self.premature_base_health + self.premature_modifier.store_health_loss * self.premature_health_pct * 0.01)
				spawn_unit:SetMaxHealth(self.premature_base_health + self.premature_modifier.store_health_loss * self.premature_health_pct * 0.01)
				spawn_unit:SetHealth(self.premature_base_health + self.premature_modifier.store_health_loss * self.premature_health_pct * 0.01)
				
				spawn_unit:SetBaseDamageMin(self.premature_base_attack_min + self.premature_modifier.store_health_loss * self.premature_attack_pct * 0.01)
				spawn_unit:SetBaseDamageMax(self.premature_base_attack_max + self.premature_modifier.store_health_loss * self.premature_attack_pct * 0.01)
			end	
			
			self.premature_modifier:SetStackCount(0)
			self.premature_modifier.store_health_loss	= 0
			self.bStoreHealth	= false
		else
			self.bStoreHealth	= false
		end
	end
	
	self:StartIntervalThink(self.pulse_interval)
end

function modifier_imba_slark_dark_pact_pulses:OnIntervalThink()
	self:GetParent():Purge(false, true, false, true, true)

	for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		self.damage_table.victim = enemy
		
		ApplyDamage(self.damage_table)
	end
	
	ApplyDamage(self.damage_table_self)
end

function modifier_imba_slark_dark_pact_pulses:OnDestroy()
	if not IsServer() then return end

	if self.premature_modifier and not self.premature_modifier:IsNull() and self.premature_modifier:GetStackCount() ~= 0 and self.bStoreHealth then
		self.health_differential		= self.current_health - self:GetParent():GetHealth()
		self.health_differential_pct	= self.current_health_pct - self:GetParent():GetHealthPercent()
		
		self.store_health_loss			= math.max(self.total_damage * 0.5, math.min(self.health_differential, self:GetParent():GetMaxHealth() * self.health_differential_pct * 0.01))
		
		if not self.premature_modifier.store_health_loss then
			self.premature_modifier.store_health_loss = 0
		end
		
		self.premature_modifier.store_health_loss	= self.premature_modifier.store_health_loss + self.store_health_loss
	end
end

-------------------------------------------
-- MODIFIER_IMBA_SLARK_DARK_PACT_THINKER --
-------------------------------------------

function modifier_imba_slark_dark_pact_thinker:IsHidden()	return self:GetStackCount() <= 0 end

function modifier_imba_slark_dark_pact_thinker:OnCreated()
	if not IsServer() then return end
	
	self.store_health_loss = 0
end

-----------------------
-- IMBA_SLARK_POUNCE --
-----------------------

function imba_slark_pounce:GetCooldown(level)
	if not self:GetCaster():HasModifier("modifier_imba_slark_pounce") or IsClient() then
		return self.BaseClass.GetCooldown(self, level)
	elseif IsServer() then
		return (self.BaseClass.GetCooldown(self, level) * (self:GetCaster():GetCooldownReduction())) - self:GetCaster():FindModifierByName("modifier_imba_slark_pounce"):GetElapsedTime()
	end
end

function imba_slark_pounce:GetManaCost(level)
	if not self:GetCaster():HasModifier("modifier_imba_slark_pounce") then
		return self.BaseClass.GetManaCost(self, level)
	else
		return 0
	end
end

function imba_slark_pounce:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Slark.Pounce.Cast")
	
	local pounce_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_pounce_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(pounce_particle)
	
	if self:GetCaster():GetName() == "npc_dota_hero_slark" then
		self:GetCaster():StartGesture(ACT_DOTA_SLARK_POUNCE)
	end
	
	-- IMBAfication: Aerial Redirection
	if not self:GetCaster():HasModifier("modifier_imba_slark_pounce") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_slark_pounce", {duration = self:GetSpecialValueFor("pounce_distance") / self:GetSpecialValueFor("pounce_speed")})
		self:EndCooldown()
		self:StartCooldown(0.25)
	else
		self:GetCaster():FindModifierByName("modifier_imba_slark_pounce").direction = self:GetCaster():GetForwardVector()		
		self:UseResources(false, false, true)
	end
end

--------------------------------
-- MODIFIER_IMBA_SLARK_POUNCE --
--------------------------------

function modifier_imba_slark_pounce:IsHidden()		return true end
function modifier_imba_slark_pounce:IsPurgable()	return false end

function modifier_imba_slark_pounce:GetEffectName()
	return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf"
end

function modifier_imba_slark_pounce:OnCreated()
	if not IsServer() then return end

	self.pounce_speed	= self:GetAbility():GetSpecialValueFor("pounce_speed")
	-- self.pounce_acceleration	= self:GetAbility:GetSpecialValueFor("pounce_acceleration") -- I don't use this for anything
	self.pounce_radius	= self:GetAbility():GetSpecialValueFor("pounce_radius")
	self.leash_duration	= self:GetAbility():GetTalentSpecialValueFor("leash_duration")
	self.leash_radius	= self:GetAbility():GetSpecialValueFor("leash_radius")
	
	self.duration		= self:GetAbility():GetSpecialValueFor("pounce_distance") / self.pounce_speed
	self.direction		= self:GetParent():GetForwardVector()

	-- I don't see notes on the height in wiki so gonna use arbitrary height of 125 for now
	self.vertical_velocity		= 4 * 125 / self.duration
	self.vertical_acceleration	= -(8 * 125) / (self.duration * self.duration)

	if self:ApplyVerticalMotionController() == false then 
		self:Destroy()
	end
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
end

function modifier_imba_slark_pounce:OnRemoved()
	if not IsServer() then return end

	if self:GetAbility() then
		self:GetAbility():UseResources(false, false, true)
	end
end

function modifier_imba_slark_pounce:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController(self)
	self:GetParent():RemoveVerticalMotionController(self)
	
	if self:GetCaster():GetName() == "npc_dota_hero_slark" then
		self:GetCaster():FadeGesture(ACT_DOTA_SLARK_POUNCE)
	end
	
	-- "Pounce destroys trees within 100 radius around Slark upon landing."
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), 100, true )
end

function modifier_imba_slark_pounce:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.pounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)) do
		if enemy:IsRealHero() or enemy:IsClone() or enemy:IsTempestDouble() then
			enemy:EmitSound("Hero_Slark.Pounce.Impact")
			
			local pounce_modifier = enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_slark_pounce_leash", {
				duration 		= self.leash_duration,
				leash_radius	= self.leash_radius
			})
			
			if pounce_modifier then
				pounce_modifier:SetDuration(self.leash_duration * (1 - enemy:GetStatusResistance()), true)
			end
			
			self:GetParent():MoveToTargetToAttack(enemy)
			
			-- IMBAfication: β/Remnants of Pounce
			self:GetParent():PerformAttack(enemy, true, true, true, false, false, false, false)
			
			self:Destroy()
			break
		end
	end

	me:SetAbsOrigin( me:GetAbsOrigin() + self.pounce_speed * self.direction * dt )
end

function modifier_imba_slark_pounce:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_slark_pounce:UpdateVerticalMotion(me, dt)
	if not IsServer() then return end
	
	me:SetAbsOrigin( me:GetAbsOrigin() + Vector(0, 0, self.vertical_velocity) * dt )
	
	self.vertical_velocity = self.vertical_velocity + (self.vertical_acceleration * dt)
end

function modifier_imba_slark_pounce:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_slark_pounce:CheckState()
	return {[MODIFIER_STATE_DISARMED] = true}
end

function modifier_imba_slark_pounce:DeclareFunctions()
	return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS}
end

function modifier_imba_slark_pounce:GetActivityTranslationModifiers()
	return "leash"
end

--------------------------------------
-- MODIFIER_IMBA_SLARK_POUNCE_LEASH --
--------------------------------------

function modifier_imba_slark_pounce_leash:IsPurgable()	return false end

-- It's pretty annoying to try and figure out all the forced movement exceptions on Pounce, so I think I'm just gonna make it unbreakable and call it an IMBAfication -_-
function modifier_imba_slark_pounce_leash:OnCreated(params)
	if not IsServer() then return end
	
	self.leash_radius	= params.leash_radius
	
	-- Okay there's like no wiki information on how the formula for movespeed limit actually works so I'm going to have to fudge something pretty badly
	self.begin_slow_radius	= params.leash_radius * 80 * 0.01
	
	self.leash_position		= self:GetParent():GetAbsOrigin()
	
	self:GetParent():EmitSound("Hero_Slark.Pounce.Leash")
	
	self.ground_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_pounce_ground.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.ground_particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.ground_particle, 4, Vector(self.leash_radius))
	self:AddParticle(self.ground_particle, false, false, -1, false, false)
	
	self.leash_particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.leash_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.leash_particle, 3, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.leash_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_pounce_leash:OnIntervalThink()
	self.limit		= 0
	self.move_speed	= self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.limit		= ((self.leash_radius - (self:GetParent():GetAbsOrigin() - self.leash_position):Length2D()) / self.leash_radius) * self.move_speed
	
	-- Can't be exactly 0 because that makes the GetModifierMoveSpeed_Limit() function do nothing
	if self.limit == 0 then
		self.limit = -0.01
	end
end

function modifier_imba_slark_pounce_leash:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Slark.Pounce.Leash")
	self:GetParent():EmitSound("Hero_Slark.Pounce.End")
	
	-- "When the leash expires while a position changing effect is ongoing, it instantly cancels the position changing effect."
	self:GetParent():InterruptMotionControllers(true)
end

function modifier_imba_slark_pounce_leash:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

function modifier_imba_slark_pounce_leash:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_LIMIT}
end

function modifier_imba_slark_pounce_leash:GetModifierMoveSpeed_Limit()
	if not IsServer() then return end
	
	-- A R B I T R A R Y   A N G L E
	if (self:GetParent():GetAbsOrigin() - self.leash_position):Length2D() >= self.begin_slow_radius and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetAbsOrigin() - self.leash_position).y, VectorToAngles(self:GetParent():GetForwardVector() ).y)) <= 85 then
		return self.limit
	end
end

------------------------------
-- IMBA_SLARK_ESSENCE_SHIFT --
------------------------------

function imba_slark_essence_shift:GetIntrinsicModifierName()
	return "modifier_imba_slark_essence_shift"
end

function imba_slark_essence_shift:OnSpellStart()

end

---------------------------------------
-- MODIFIER_IMBA_SLARK_ESSENCE_SHIFT --
---------------------------------------

function modifier_imba_slark_essence_shift:DestroyOnExpire()	return false end
function modifier_imba_slark_essence_shift:IsHidden()			return self:GetStackCount() <= 0 end

function modifier_imba_slark_essence_shift:OnCreated()
	if not IsServer() then return end
	
	self.stack_table = {}
	
	-- What's laggier, a frame-time thinker with a hundred+ element table check, or potentially a hundred+ stacks that feed into the stack counter system? It is a mystery...
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_essence_shift:OnIntervalThink()
	Custom_ArrayRemove(self.stack_table, function(i, j)
		return self.stack_table[i].apply_game_time and self.stack_table[i].duration and GameRules:GetDOTATime(true, true) - self.stack_table[i].apply_game_time <= self.stack_table[i].duration
	end)
	
	if #self.stack_table ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_table)
	end
end

function modifier_imba_slark_essence_shift:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_imba_slark_essence_shift:OnAttackLanded(keys)
	if self:GetAbility():IsTrained() and keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and (keys.target:IsRealHero() or keys.target:IsClone()) and not keys.target:IsTempestDouble() then
		self.shift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_essence_shift.vpcf", PATTACH_POINT_FOLLOW, keys.target)
		ParticleManager:ReleaseParticleIndex(self.shift_particle)
	
		table.insert(self.stack_table, {
			apply_game_time	= GameRules:GetDOTATime(true, true),
			duration		= self:GetAbility():GetTalentSpecialValueFor("duration")
		})
		
		self:SetDuration(self:GetAbility():GetTalentSpecialValueFor("duration"), true)
		self:IncrementStackCount()
		
		self.debuff_modifier = keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_essence_shift_debuff_counter", {duration = self:GetAbility():GetTalentSpecialValueFor("duration")})
		
		if self.debuff_modifier then
			self.debuff_modifier:SetDuration(self:GetAbility():GetTalentSpecialValueFor("duration") * (1 - keys.target:GetStatusResistance()), true)
		end
	end
end

function modifier_imba_slark_essence_shift:OnDeath(keys)
	if keys.unit == self:GetParent() then
		self.stack_table = {}
		self:SetStackCount(0)
	end
end

function modifier_imba_slark_essence_shift:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("agi_gain") * self:GetStackCount()
end

----------------------------------------------
-- MODIFIER_imba_slark_essence_shift_debuff_counter --
----------------------------------------------

function modifier_imba_slark_essence_shift_debuff_counter:DestroyOnExpire()	return self:GetParent():GetHealthPercent() > 0 end
function modifier_imba_slark_essence_shift_debuff_counter:IsHidden()		return self:GetParent():GetHealthPercent() <= 0 end
function modifier_imba_slark_essence_shift_debuff_counter:IsPurgable()		return false end
function modifier_imba_slark_essence_shift_debuff_counter:RemoveOnDeath()	return false end

function modifier_imba_slark_essence_shift_debuff_counter:OnCreated()
	if not self.stat_loss then
		self.stat_loss	= self:GetAbility():GetSpecialValueFor("stat_loss")
	end

	if not IsServer() then return end
	
	if not self.stack_table then
		self.stack_table = {}
	end
	
	table.insert(self.stack_table, {
		apply_game_time	= GameRules:GetDOTATime(true, true),
		duration		= self:GetAbility():GetTalentSpecialValueFor("duration")
	})

	self:IncrementStackCount()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_essence_shift_debuff_counter:OnRefresh()
	self:OnCreated()
end

function modifier_imba_slark_essence_shift_debuff_counter:OnIntervalThink()
	Custom_ArrayRemove(self.stack_table, function(i, j)
		return self.stack_table[i].apply_game_time and self.stack_table[i].duration and GameRules:GetDOTATime(true, true) - self.stack_table[i].apply_game_time <= self.stack_table[i].duration
	end)
	
	if #self.stack_table ~= self:GetStackCount() then
		self:SetStackCount(#self.stack_table)
	end
end

function modifier_imba_slark_essence_shift_debuff_counter:OnDestroy()
	if not IsServer() then return end
	
	
end

function modifier_imba_slark_essence_shift_debuff_counter:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_slark_essence_shift_debuff_counter:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and (keys.target:IsRealHero() or keys.target:IsClone()) and not keys.target:IsTempestDouble() then
		table.insert(self.stack_table, {
			apply_game_time	= GameRules:GetDOTATime(true, true),
			duration		= self:GetAbility():GetTalentSpecialValueFor("duration")
		})
		
		self:SetDuration(self:GetAbility():GetTalentSpecialValueFor("duration"), true)
		self:IncrementStackCount()
	end
end

function modifier_imba_slark_essence_shift_debuff_counter:OnDeath(keys)
	if keys.unit == self:GetParent() and keys.unit:GetTeamNumber() ~= keys.attacker:GetTeamNumber() and keys.attacker:HasModifier("modifier_imba_slark_essence_shift") and ((keys.unit:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Length2D() <= 300 or keys.attacker == self:GetCaster()) and not keys.attacker:HasModifier("modifier_morphling_replicate") then
		if self:GetParent().IsReincarnating and not self:GetParent():IsReincarnating() then
			self.bStealAgi = true
			keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_essence_shift_permanent_buff", {})
		else
			self:Destroy()
		end
	end
end

function modifier_imba_slark_essence_shift_debuff_counter:OnRespawn(keys)
	if keys.unit == self:GetParent() and self.bStealAgi then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_essence_shift_permanent_debuff", {})
		self:Destroy()
	end
end

function modifier_imba_slark_essence_shift_debuff_counter:GetModifierBonusStats_Agility()
	return self.stat_loss * (-1) * self:GetStackCount()
end

function modifier_imba_slark_essence_shift_debuff_counter:GetModifierBonusStats_Intellect()
	return self.stat_loss * (-1) * self:GetStackCount()
end

function modifier_imba_slark_essence_shift_debuff_counter:GetModifierBonusStats_Strength()
	return self.stat_loss * (-1) * self:GetStackCount()
end

function modifier_imba_slark_essence_shift_debuff_counter:OnTooltip()
	return self.stat_loss * (-1) * self:GetStackCount()
end

------------------------------------------------------
-- MODIFIER_IMBA_SLARK_ESSENCE_SHIFT_PERMANENT_BUFF --
------------------------------------------------------

function modifier_imba_slark_essence_shift_permanent_buff:IsPurgable()		return false end
function modifier_imba_slark_essence_shift_permanent_buff:RemoveOnDeath()	return false end

function modifier_imba_slark_essence_shift_permanent_buff:OnCreated()
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_slark_essence_shift_permanent_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_slark_essence_shift_permanent_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_imba_slark_essence_shift_permanent_buff:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end

--------------------------------------------------------
-- MODIFIER_IMBA_SLARK_ESSENCE_SHIFT_PERMANENT_DEBUFF --
--------------------------------------------------------

function modifier_imba_slark_essence_shift_permanent_debuff:IsHidden()		return true end
function modifier_imba_slark_essence_shift_permanent_debuff:IsPurgable()	return false end
function modifier_imba_slark_essence_shift_permanent_debuff:RemoveOnDeath()	return false end

function modifier_imba_slark_essence_shift_permanent_debuff:OnCreated()
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_slark_essence_shift_permanent_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_slark_essence_shift_permanent_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_imba_slark_essence_shift_permanent_debuff:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (-1)
end

-----------------------------
-- IMBA_SLARK_SHADOW_DANCE --
-----------------------------

function imba_slark_shadow_dance:GetIntrinsicModifierName()
	return "modifier_imba_slark_shadow_dance_passive_regen"
end

function imba_slark_shadow_dance:GetBehavior()
	return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_slark_shadow_dance:GetCastRange(location, target)
	if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_imba_slark_shadow_dance_dark_reef_handler") then
		return self:GetSpecialValueFor("scepter_aoe") - self:GetCaster():GetCastRangeBonus()
	elseif self:GetCaster():HasModifier("modifier_imba_slark_shadow_dance_dark_reef_handler") then
		return self:GetSpecialValueFor("dark_reef_radius") - self:GetCaster():GetCastRangeBonus()
	end
end

function imba_slark_shadow_dance:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_slark_shadow_dance:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasModifier("modifier_imba_slark_shadow_dance_passive_regen") and self:GetAutoCastState() and not self:GetCaster():HasModifier("modifier_imba_slark_shadow_dance_dark_reef_handler") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_slark_shadow_dance_dark_reef_handler", {})
	end
end

function imba_slark_shadow_dance:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Slark.ShadowDance")

	if not self:GetAutoCastState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_slark_shadow_dance_aura", {duration = self:GetTalentSpecialValueFor("duration")})
	else
		CreateModifierThinker(
			self:GetCaster(),
			self,
			"modifier_imba_slark_shadow_dance_aura",
			{
				duration = self:GetTalentSpecialValueFor("duration"),
				bAutoCast = 1
			},
			self:GetCaster():GetAbsOrigin(),
			self:GetCaster():GetTeamNumber(),
			false		
		)
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_SLARK_SHADOW_DANCE_PASSIVE_REGEN --
----------------------------------------------------

function modifier_imba_slark_shadow_dance_passive_regen:IsHidden()
	return self:GetStackCount() < 0 and not self:GetParent():HasModifier("modifier_imba_slark_shadow_dance")
end

function modifier_imba_slark_shadow_dance_passive_regen:OnCreated()
	if not IsServer() then return end
	
	-- self.bPassiveActive is redundant here cause I'm using stackcounts in order to control modifier visibility on client-side, but I'll leave it for reference
	self.bPassiveActive	= true
	self.bVisible		= false
	self.counter		= 0
	self.interval		= 0.1
	
	self:StartIntervalThink(self.interval)
end

function modifier_imba_slark_shadow_dance_passive_regen:OnIntervalThink()
	self.bVisible		= false
	
	for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
		if (enemy.IsNeutralUnitType and not enemy:IsNeutralUnitType()) and not enemy:IsRoshan() and enemy:CanEntityBeSeenByMyTeam(self:GetParent()) then
			self.bVisible	= true
			break
		end
	end
	
	-- Slark is visible and passive is on its way to being disabled
	if self.bPassiveActive and self.bVisible and not self:GetParent():HasModifier("modifier_imba_slark_shadow_dance") then
		self.counter		= self.counter + self.interval
		
		if self.counter >= self:GetAbility():GetSpecialValueFor("activation_delay") then
			self.bPassiveActive	= false
			self:SetStackCount(-1)
			self.counter		= 0
		end
	-- Slark is not visible and passive is on its way to being re-enabled
	elseif not self.bPassiveActive and not self.bVisible then
		self.counter		= self.counter + self.interval
		
		if self.counter >= self:GetAbility():GetSpecialValueFor("activation_delay") then
			self.bPassiveActive	= true
			self:SetStackCount(0)
			self.counter		= 0
		end
	end
end

function modifier_imba_slark_shadow_dance_passive_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_slark_shadow_dance_passive_regen:GetModifierMoveSpeedBonus_Percentage()
	if not self:IsHidden() and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end

function modifier_imba_slark_shadow_dance_passive_regen:GetModifierHealthRegenPercentage()
	if not self:IsHidden() and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() then
		return self:GetAbility():GetSpecialValueFor("bonus_regen_pct")
	end
end

function modifier_imba_slark_shadow_dance_passive_regen:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:GetParent():RemoveModifierByName("modifier_imba_slark_shadow_dance_dark_reef_handler")
	else
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_shadow_dance_dark_reef_handler", {})
	end
end

-------------------------------------------
-- MODIFIER_IMBA_SLARK_SHADOW_DANCE_AURA --
-------------------------------------------

function modifier_imba_slark_shadow_dance_aura:IsHidden()				return true end

function modifier_imba_slark_shadow_dance_aura:OnCreated(params)
	if not IsServer() then return end

	self.shadow_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.shadow_particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eyeR", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shadow_particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_eyeL", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(self.shadow_particle, false, false, -1, false, false)

	if (not params or params and params.bAutoCast ~= 1) then
		ParticleManager:SetParticleControlEnt(self.shadow_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	
		local visual_unit = CreateUnitByName("npc_dota_slark_visual", self:GetCaster():GetAbsOrigin(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		visual_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_slark_visual", {})
		-- Add aura duration of 0.5 seconds so the visual can attach long enough for the particle below to stick
		visual_unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self:GetAbility():GetTalentSpecialValueFor("duration") + 0.5})
	
		local shadow_particle_name = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"
	
		if not self:GetCaster():HasScepter() then
			self.aoe	= 0
		else
			self.aoe = self:GetAbility():GetSpecialValueFor("scepter_aoe")
			shadow_particle_name = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf"
		end
		
		self.shadow_dummy_particle = ParticleManager:CreateParticle(shadow_particle_name, PATTACH_ABSORIGIN_FOLLOW, visual_unit)
		ParticleManager:SetParticleControlEnt(self.shadow_dummy_particle, 1, visual_unit, PATTACH_POINT_FOLLOW, nil, visual_unit:GetAbsOrigin(), true)
		self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
	else
		ParticleManager:SetParticleControlEnt(self.shadow_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
		
		-- IMBAfication: Welcome to Dark Reef
		self.aoe	= self:GetAbility():GetSpecialValueFor("dark_reef_radius")
		
		-- Okay so...
		-- While this can be done in one clean loop, I'm going to purposefully leave this as a bunch of garbage for-loops for now because I don't think this will even survive testing phase (yeah cause making 300+ particles all at once is going to end well -_-)
		for arr = 1, 50 do
			self.shadow_dummy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(self.shadow_dummy_particle, 1, GetGroundPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, (360/50) * arr, 0), Vector(2300, 0, 0)), nil))
			self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
		end
		
		for arr = 1, 40 do
			self.shadow_dummy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(self.shadow_dummy_particle, 1, GetGroundPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, (360/40) * arr, 0), Vector(1800, 0, 0)), nil))
			self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
		end
		
		for arr = 1, 30 do
			self.shadow_dummy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(self.shadow_dummy_particle, 1, GetGroundPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, (360/30) * arr, 0), Vector(1300, 0, 0)), nil))
			self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
		end
		
		for arr = 1, 20 do
			self.shadow_dummy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(self.shadow_dummy_particle, 1, GetGroundPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, (360/20) * arr, 0), Vector(800, 0, 0)), nil))
			self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
		end
		
		for arr = 1, 10 do
			self.shadow_dummy_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy_sceptor.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
			ParticleManager:SetParticleControl(self.shadow_dummy_particle, 1, GetGroundPosition(self:GetParent():GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, (360/10) * arr, 0), Vector(300, 0, 0)), nil))
			self:AddParticle(self.shadow_dummy_particle, false, false, -1, false, false)
		end
	end
end

function modifier_imba_slark_shadow_dance_aura:IsAura() 				return true end
function modifier_imba_slark_shadow_dance_aura:IsAuraActiveOnDeath()	return false end

function modifier_imba_slark_shadow_dance_aura:GetAuraRadius()			return self.aoe or 0 end
function modifier_imba_slark_shadow_dance_aura:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_slark_shadow_dance_aura:GetAuraSearchTeam()
	if not self:GetParent():GetName() == "npc_dota_thinker" then
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	else
		return DOTA_UNIT_TARGET_TEAM_BOTH
	end
end

function modifier_imba_slark_shadow_dance_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_slark_shadow_dance_aura:GetModifierAura()		return "modifier_imba_slark_shadow_dance" end

function modifier_imba_slark_shadow_dance_aura:GetAuraEntityReject(target)
	if target:HasModifier("modifier_imba_slark_visual") then
		return true
	end
end

--------------------------------------
-- MODIFIER_IMBA_SLARK_SHADOW_DANCE --
--------------------------------------

function modifier_imba_slark_shadow_dance:IsPurgable()	return false end

function modifier_imba_slark_shadow_dance:GetStatusEffectName()
	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_imba_slark_shadow_dance:OnCreated()
	if not IsServer() then return end
end

function modifier_imba_slark_shadow_dance:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE]			= true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE]	= true
	}
end

function modifier_imba_slark_shadow_dance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end

function modifier_imba_slark_shadow_dance:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_slark_shadow_dance:GetActivityTranslationModifiers()
	return "shadow_dance"
end

--------------------------------------------------------
-- MODIFIER_IMBA_SLARK_SHADOW_DANCE_DARK_REEF_HANDLER --
--------------------------------------------------------

function modifier_imba_slark_shadow_dance_dark_reef_handler:IsHidden()		return true end
function modifier_imba_slark_shadow_dance_dark_reef_handler:IsPurgable()	return false end
function modifier_imba_slark_shadow_dance_dark_reef_handler:RemoveOnDeath()	return false end

--------------------------------
-- MODIFIER_IMBA_SLARK_VISUAL --
--------------------------------

-- This modifier is for the visual unit that attaches to Slark so Dark Pact and Shadow Dance particles can be seen while Slark is invisible

function modifier_imba_slark_visual:IsPurgable()	return false end

function modifier_imba_slark_visual:OnCreated()
	if not IsServer() then return end
	
	-- I would have preferred using FollowEntity() but that makes this thing invisible if the caster is invisible so that defeats the whole purpose
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_slark_visual:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end

function modifier_imba_slark_visual:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE]				= false,
		[MODIFIER_STATE_NO_HEALTH_BAR]			= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]		= true,
		[MODIFIER_STATE_INVULNERABLE]			= true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY]	= true,
		[MODIFIER_STATE_UNSELECTABLE]			= true,
		[MODIFIER_STATE_UNTARGETABLE]			= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]			= true
	}
end

	-- //=================================================================================================================
	-- // Slark Shadow Dance
	-- //=================================================================================================================
	-- "slark_shadow_dance"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5497"							// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ULTIMATE"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_IMMEDIATE | DOTA_ABILITY_BEHAVIOR_NO_TARGET"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_NO"
		-- "FightRecapLevel"				"2"
		-- "HasScepterUpgrade"				"1"
		-- "AbilitySound"					"Hero_Slark.ShadowDance"
		-- "AbilityCastAnimation"			"ACT_DOTA_CAST_ABILITY_4"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"80 70 60"
		
		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"120 120 120"		

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "duration"					"4 4.25 4.5"
				-- "LinkedSpecialBonus"	"special_bonus_unique_slark_3"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "fade_time"					"0.0 0.0 0.0"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_movement_speed"		"20 35 50"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "bonus_regen_pct"			"5 6 7"
			-- }
			-- "05"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "activation_delay"			"0.5 0.5 0.5"
			-- }
			-- "06"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "neutral_disable"			"2.0 2.0 2.0"
			-- }
			-- "07"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "scepter_aoe"						"425"
				-- "RequiresScepter"	"1"
			-- }
			-- "08"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "cooldown_scepter"			"30"
				-- "RequiresScepter"	"1"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Slark: Dark Pact
	-- //=================================================================================================================
	-- "slark_dark_pact"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5494"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_NO_TARGET | DOTA_ABILITY_BEHAVIOR_IMMEDIATE"
		-- "AbilityUnitDamageType"			"DAMAGE_TYPE_MAGICAL"	
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_NO"
		-- "FightRecapLevel"				"1"
		-- "AbilitySound"					"Hero_Slark.DarkPact.Cast"

		-- // Casting
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCastAnimation"			"ACT_INVALID"
		-- "AbilityCastPoint"				"0.001 0.001 0.001 0.001"
		-- "AbilityCastRange"				"325"

		-- // Time		
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityCooldown"				"9.0 8.0 7.0 6.0"

		-- // Cost
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilityManaCost"				"60"	
		
		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "delay"					"1.5"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "pulse_duration"		"1.0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"325"
			-- }	
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "total_damage"			"75 150 225 300"
				-- "LinkedSpecialBonus"	"special_bonus_unique_slark_2"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "total_pulses"			"10"
			-- }	
			-- "06"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "pulse_interval"		"0.1"
			-- }			
		-- }
	-- }


	-- //=================================================================================================================
	-- // Slark: Essence Shift
	-- //=================================================================================================================
	-- "slark_essence_shift"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"							"5496"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		-- "SpellImmunityType"				"SPELL_IMMUNITY_ENEMIES_YES"
		-- "SpellDispellableType"			"SPELL_DISPELLABLE_NO"

		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "agi_gain"				"3"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "stat_loss"				"1"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"15 30 60 100"
				-- "LinkedSpecialBonus"	"special_bonus_unique_slark_4"
			-- }
		-- }
		-- "AbilityCastAnimation"		"ACT_DOTA_CAST_ABILITY_3"
	-- }


-- //=================================================================================================================
	-- // Ability: Special Bonus
	-- //=================================================================================================================
	-- "special_bonus_unique_slark"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"					"6147"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ATTRIBUTES"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		
		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "value"				"1"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Ability: Special Bonus
	-- //=================================================================================================================
	-- "special_bonus_unique_slark_2"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"					"6892"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ATTRIBUTES"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		
		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "value"				"150"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Ability: Special Bonus
	-- //=================================================================================================================
	-- "special_bonus_unique_slark_3"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"					"6893"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ATTRIBUTES"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		
		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "value"				"1"
			-- }
		-- }
	-- }

	-- //=================================================================================================================
	-- // Ability: Special Bonus
	-- //=================================================================================================================
	-- "special_bonus_unique_slark_4"
	-- {
		-- // General
		-- //-------------------------------------------------------------------------------------------------------------
		-- "ID"					"6894"														// unique ID number for this ability.  Do not change this once established or it will invalidate collected stats.
		-- "AbilityType"					"DOTA_ABILITY_TYPE_ATTRIBUTES"
		-- "AbilityBehavior"				"DOTA_ABILITY_BEHAVIOR_PASSIVE"
		
		-- // Special
		-- //-------------------------------------------------------------------------------------------------------------
		-- "AbilitySpecial"
		-- {
			-- "01"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "value"				"80"
			-- }
		-- }
	-- }

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- LinkLuaModifier("modifier_special_bonus_imba_timbersaw_timber_chain_range", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

-- modifier_special_bonus_imba_timbersaw_timber_chain_range	= class({})

-- function modifier_special_bonus_imba_timbersaw_timber_chain_range:IsHidden() 		return true end
-- function modifier_special_bonus_imba_timbersaw_timber_chain_range:IsPurgable()	 	return false end
-- function modifier_special_bonus_imba_timbersaw_timber_chain_range:RemoveOnDeath() 	return false end

-- function imba_timbersaw_timber_chain:OnOwnerSpawned()
	-- if not IsServer() then return end

	-- if self:GetCaster():HasTalent("special_bonus_imba_timbersaw_timber_chain_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_timbersaw_timber_chain_range") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_timbersaw_timber_chain_range"), "modifier_special_bonus_imba_timbersaw_timber_chain_range", {})
	-- end
-- end
