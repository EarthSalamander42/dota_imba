-- Author: Shush
-- Date: 4/1/2017


CreateEmptyTalents("disruptor")


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Disruptor's Stormbearer
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_disruptor_stormbearer = class({})
LinkLuaModifier("modifier_imba_stormbearer", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

function imba_disruptor_stormbearer:GetIntrinsicModifierName()
	return "modifier_imba_stormbearer"
end

function imba_disruptor_stormbearer:IsInnateAbility()
	return true
end

-- Stormbearer's stacks buffs
modifier_imba_stormbearer = class({})

function modifier_imba_stormbearer:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	self.ms_per_stack = self.ability:GetSpecialValueFor("ms_per_stack") 
	self.scepter_ms_per_stack = self.ability:GetSpecialValueFor("scepter_ms_per_stack")

end

function modifier_imba_stormbearer:AllowIllusionDuplicate()	
		return true	
end

---------------------------------------------------

function modifier_imba_stormbearer:GetAttributes()	
		return MODIFIER_ATTRIBUTE_PERMANENT	
end

---------------------------------------------------

function modifier_imba_stormbearer:IsDebuff()	
		return false	
end

---------------------------------------------------

function modifier_imba_stormbearer:IsHidden()	
		return false	
end

---------------------------------------------------

function modifier_imba_stormbearer:IsPurgable()	
		return false	
end

---------------------------------------------------

function modifier_imba_stormbearer:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
		
		return decFuncs	
end

---------------------------------------------------

function modifier_imba_stormbearer:GetModifierMoveSpeedBonus_Constant()		
	self.scepter = self.caster:HasScepter()

	local stacks = self:GetStackCount()		
	local move_speed_increase

	if self.scepter then
		move_speed_increase = (self.scepter_ms_per_stack + self.caster:FindTalentValue("special_bonus_imba_disruptor_3")) * stacks				
	else
		move_speed_increase = (self.ms_per_stack + self.caster:FindTalentValue("special_bonus_imba_disruptor_3")) * stacks					
	end
	
	return move_speed_increase			
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Disruptor's Thunder Strike
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------



imba_disruptor_thunder_strike = class ({})
LinkLuaModifier("modifier_imba_thunder_strike_debuff", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_thunder_strike_talent_slow", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

function imba_disruptor_thunder_strike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

---------------------------------------------------

function imba_disruptor_thunder_strike:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

---------------------------------------------------

function imba_disruptor_thunder_strike:GetAbilityTargetType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


---------------------------------------------------

function imba_disruptor_thunder_strike:GetAbilityDamageType()
	return DAMAGE_TYPE_MAGICAL
end

---------------------------------------------------

function imba_disruptor_thunder_strike:GetAbilityTargetTeam()	
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

---------------------------------------------------

function imba_disruptor_thunder_strike:GetAbilityTargetFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------

function imba_disruptor_thunder_strike:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()	
		local ability = self
		local target = self:GetCursorTarget()		
		local cast_response = "disruptor_dis_thunderstrike_0"..RandomInt(1, 4)
		local sound_cast = "Hero_Disruptor.ThunderStrike.Cast"
		local debuff = "modifier_imba_thunder_strike_debuff"
		
		-- Ability specials
		local duration = ability:GetSpecialValueFor("duration")	
		
		-- Check for Linken's Sphere
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end		

		-- Roll for cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
		
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)	

		-- #8 Talent: Thunder Strike duration increase
		duration = duration + caster:FindSpecificTalentValue("special_bonus_imba_disruptor_8", "value")

		-- Apply Thunder Strike on target
		target:AddNewModifier(caster, ability, debuff, {duration = duration})	
	end
end


-- ThunderStrike debuff modifier
modifier_imba_thunder_strike_debuff = class ({})

function modifier_imba_thunder_strike_debuff:OnCreated()	
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.target = self:GetParent()	
		self.modifier_slow = "modifier_imba_thunder_strike_talent_slow"
			
		-- Ability specials
		self.radius = self.ability:GetSpecialValueFor("radius")	
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.fow_linger_duration = self.ability:GetSpecialValueFor("fow_linger_duration")
		self.fow_radius = self.ability:GetSpecialValueFor("fow_radius")
		self.strike_interval = self.ability:GetSpecialValueFor("strike_interval")
		self.add_strikes_interval = self.ability:GetSpecialValueFor("add_strikes_interval")
		self.talent_4_slow_duration = self.ability:GetSpecialValueFor("talent_4_slow_duration")	

		-- #8 Talent: Thunder Strike interval reduction
		self.strike_interval = self.strike_interval - self.caster:FindSpecificTalentValue("special_bonus_imba_disruptor_8", "value2")
			
		-- Strike immediately upon creation, depending on amount of enemies
		ThunderStrikeBoltStart(self)			
	
		-- Start interval striking
		self:StartIntervalThink(self.strike_interval)
	end
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:DestroyOnExpire()
	return true
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:RemoveOnDeath()
	return false
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:CheckState()
	local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
	return state
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf"
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:IsDebuff()
	return true
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:IsPurgable()
	return true
end

---------------------------------------------------

function modifier_imba_thunder_strike_debuff:OnIntervalThink()	
	if IsServer() then	
		ThunderStrikeBoltStart(self)
	end
end

---------------------------------------------------

function ThunderStrikeBoltStart(self)
	if IsServer() then
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.target:GetAbsOrigin(),
										  nil,
										  self.radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		self.strikes_remaining = #enemies		
		
		-- Strike once for every enemy in the AOE radius.
		Timers:CreateTimer(function()
			ThunderStrikeBoltStrike(self)
			self.strikes_remaining = self.strikes_remaining - 1
			if self.strikes_remaining <= 0 then
				return nil
			else
				return self.add_strikes_interval
			end
		end)
	end
end

---------------------------------------------------

function ThunderStrikeBoltStrike(self)
	local sound_impact = "Hero_Disruptor.ThunderStrike.Target"
	local strike_particle = "particles/hero/disruptor/disruptor_thunder_strike_bolt.vpcf"
	local aoe_particle = "particles/hero/disruptor/disruptor_thuderstrike_aoe_area.vpcf"
	local stormbearer_buff = "modifier_imba_stormbearer"
	local scepter = self.caster:HasScepter()
	
	-- Play strike sound
	EmitSoundOn(sound_impact, self.target)

	-- #4 Talent: Thunder Strikes slow the main target
	if self.caster:HasTalent("special_bonus_imba_disruptor_4") then
		self.target:AddNewModifier(self.caster, self.ability, self.modifier_slow, {duration = self.talent_4_slow_duration})
	end
			
	-- Add bolt particle
	local strike_particle_fx = ParticleManager:CreateParticle(strike_particle, PATTACH_ABSORIGIN, self.target)
	ParticleManager:SetParticleControl(strike_particle_fx, 0, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(strike_particle_fx, 1, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(strike_particle_fx, 2, self.target:GetAbsOrigin())
	
	-- Add Aoe particle
	local aoe_particle_fx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN, self.target)
	ParticleManager:SetParticleControl(aoe_particle_fx, 0, self.target:GetAbsOrigin())
		
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
									  self.target:GetAbsOrigin(),
									  nil,
									  self.radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)
										  
	for _,enemy in pairs(enemies) do
		-- Deal damage to appropriate enemies			
		if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
		
			local damageTable = {victim = enemy,
								attacker = self.caster,
								damage = self.damage,
								damage_type = DAMAGE_TYPE_MAGICAL}
								
			ApplyDamage(damageTable)			
				
			-- Give a Stormbearer stack to caster			
			if self.caster:HasModifier(stormbearer_buff) then
				local stormbearer_buff_handler = self.caster:FindModifierByName(stormbearer_buff)
				stormbearer_buff_handler:IncrementStackCount()	
			end		
		end
	end
end


-- Thunderstrike slow debuff
modifier_imba_thunder_strike_talent_slow = class({})

function modifier_imba_thunder_strike_talent_slow:OnCreated()
	self.ability = self:GetAbility()	
	self.talent_4_slow_pct = self.ability:GetSpecialValueFor("talent_4_slow_pct")
end

function modifier_imba_thunder_strike_talent_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_thunder_strike_talent_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.talent_4_slow_pct * (-1)
end

function modifier_imba_thunder_strike_talent_slow:IsHidden()
	return true
end

function modifier_imba_thunder_strike_talent_slow:IsPurgable()
	return true
end

function modifier_imba_thunder_strike_talent_slow:IsDebuff()
	return true
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--				Disruptor's Glimpse
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_disruptor_glimpse = class({})
LinkLuaModifier("modifier_imba_glimpse_location_aura", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_glimpse_location_store", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_glimpse_dummy", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_glimpse_storm_aura", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_glimpse_storm_debuff", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

function imba_disruptor_glimpse:GetAbilityTargetTeam()	
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

---------------------------------------------------

function imba_disruptor_glimpse:GetAbilityTargetFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------

function imba_disruptor_glimpse:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	
	-- Give caster the glimpse move check aura
	if not caster:HasModifier("modifier_imba_glimpse_location_aura") then		
		caster:AddNewModifier(caster, ability, "modifier_imba_glimpse_location_aura", {})		
	end
end

---------------------------------------------------

function imba_disruptor_glimpse:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()	
		local ability = self
		ability.target_to_move = target	
		local cast_response = "disruptor_dis_glimpse_0"..RandomInt(1, 5)
		local sound_cast = "Hero_Disruptor.Glimpse.Target"
		local particle_start = "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf"
		local particle_travel = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf"
		
		-- Needed since the target can move in two ways, by projectile hitting dummy or by duration ending.
		ability.target_moved = false	
			
		-- Ability specials
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
		local move_delay = ability:GetSpecialValueFor("move_delay")	 
		local vision_radius = ability:GetSpecialValueFor("vision_radius")
		local vision_linger = ability:GetSpecialValueFor("vision_linger")
		
		-- if target is an illusion, kill instantly and do nothing else.
		if target:IsIllusion() then
			target:ForceKill(false)
			return nil
		end
			
		-- Determine Glimpse target location
		if not target.position then			
				ability.glimpse_location = target:GetAbsOrigin()
		else
				ability.glimpse_location = target.position[0]
		end
		
		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
		
		-- Play sound
		EmitSoundOn(sound_cast, caster)
		
		-- Create dummy at glimpse location
		local dummy = CreateUnitByName("npc_dummy_unit", ability.glimpse_location, false, caster, caster, caster:GetTeamNumber())
		-- Apply dummy state to dummy
		dummy:AddNewModifier(caster, ability, "modifier_imba_glimpse_dummy", {})	
		
		-- Add start particle
		ability.particle_start = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControl(ability.particle_start, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.particle_start, 1, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.particle_start, 2, dummy:GetAbsOrigin())
			
		
		glimpse_projectile = 
		{
			Target = dummy,
			Source = target,
			Ability = ability,
			EffectName = particle_travel,		
			iMoveSpeed = projectile_speed,
			bDodgeable = false, 
			bVisibleToEnemies = true,
			bReplaceExisting = false,        
			bProvidesVision = true,
			iVisionRadius = vision_radius,
			iVisionTeamNumber = caster:GetTeamNumber()		
		}	
			
		ProjectileManager:CreateTrackingProjectile(glimpse_projectile)	
		
		Timers:CreateTimer(move_delay, function()
			GlimpseFinalized(caster, target, ability, dummy)	
		end)
	end
end

---------------------------------------------------

function imba_disruptor_glimpse:OnProjectileHit(dummyTarget, location)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = ability.target_to_move
		local dummy = dummyTarget				
		
		-- Ability specials
		local vision_linger = ability:GetSpecialValueFor("vision_linger")
		local vision_radius = ability:GetSpecialValueFor("vision_radius")
			
		AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(),vision_radius, vision_linger, false)
			
		GlimpseFinalized(caster, target, ability, dummy)
	end
	
end

---------------------------------------------------

function GlimpseFinalized(caster, target, ability, dummy)
	if IsServer() then
		local sound_end = "Hero_Disruptor.Glimpse.End"
		local particle_end = "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf"
		local storm_aura = "modifier_imba_glimpse_storm_aura"
		local storm_duration = ability:GetSpecialValueFor("storm_duration")
		local storm_particle = "particles/hero/disruptor/disruptor_static_storm.vpcf"
		local sound_storm = "Hero_Disruptor.StaticStorm"
		local sound_storm_end = "Hero_Disruptor.StaticStorm.End"
		
		if not ability.target_moved then		
			-- Play end glimpse sound
			EmitSoundOn(sound_end, target)
			
			-- Add particles, destroy travel particle
			particle_end = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(particle_end, 1, dummy:GetAbsOrigin())		
			
			-- Wait a little before moving the target and killing the dummy for particle effects
			Timers:CreateTimer(0.5, function()		
							
				-- Move target to dummy's location IF he's not magic immune
				if not target:IsMagicImmune() then
					target:SetAbsOrigin(dummy:GetAbsOrigin())
				end			
				
				-- Remove glimpse ground particle
				ParticleManager:DestroyParticle(ability.particle_start, false)
				ParticleManager:ReleaseParticleIndex(ability.particle_start)		
								
				-- Give dummy static storm aura
				dummy:AddNewModifier(caster, ability, storm_aura, {duration = storm_duration})
				
				-- Play storm's sounds 
				EmitSoundOn(sound_storm, dummy)
				
				-- Add storm particles in dummy's area
				storm_particle = ParticleManager:CreateParticle(storm_particle, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(storm_particle, 0, dummy:GetAbsOrigin())
				ParticleManager:SetParticleControl(storm_particle, 1, Vector(10,10,10))
				ParticleManager:SetParticleControl(storm_particle, 2, Vector(storm_duration,1,1))
				
				Timers:CreateTimer(storm_duration, function()
					-- Stop storm's sound, play end's sound
					StopSoundOn(sound_storm, dummy)
					EmitSoundOn(sound_storm_end, dummy)
					ParticleManager:DestroyParticle(storm_particle, false)
					ParticleManager:ReleaseParticleIndex(storm_particle)
				end)
				
				
				-- Remove dummy a second after storm's end to allow particles to fade out
				Timers:CreateTimer(storm_duration+1, function()					
					dummy:Destroy()
				end)				
			end)		
		end
		
		ability.target_moved = true
	end
end


-- Glimpse checker modifier aura
modifier_imba_glimpse_location_aura = class({})

function modifier_imba_glimpse_location_aura:GetAuraRadius()
	return 100000 --global radius
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:GetModifierAura()
	return "modifier_imba_glimpse_location_store"
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:IsAura()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:IsHidden()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_location_aura:IsPurgable()
	return false
end


-- Glimpse checker modifier storer
modifier_imba_glimpse_location_store = class({})

function modifier_imba_glimpse_location_store:IsHidden()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_location_store:DeclareFunctions()	
	if IsServer() then
		local decFuncs = {MODIFIER_EVENT_ON_TELEPORTED,
						  MODIFIER_EVENT_ON_UNIT_MOVED}
					 
		return decFuncs	
	end
end

---------------------------------------------------

function modifier_imba_glimpse_location_store:OnTeleported( keys )	
	if IsServer() then
		local ability = self:GetAbility()	
		MovementCheck(keys, ability)
	end
end

---------------------------------------------------

function modifier_imba_glimpse_location_store:OnUnitMoved( keys )	
	if IsServer() then
		local ability = self:GetAbility()
		MovementCheck(keys, ability)
	end
end

---------------------------------------------------

-- Credit to YOLOSPAGHETTI from the spell library for this section, couldn't produce it myself -_-
function MovementCheck(keys, ability)
	if IsServer() then
		local target = keys.unit	
		local backtrack_time = ability:GetLevelSpecialValueFor("backtrack_time", ability:GetLevel() -1)	
		
		-- Temporary position array and index
		local temp = {}
		local temp_index = 0
		
		-- Global position array and index
		local target_index = 0
		if target.position == nil then
			target.position = {}
		end
		
		-- Sets the position and game time values in the tempororary array, if the target moved within 4 seconds of current time
		while target.position do
			if target.position[target_index] == nil then
			break
			elseif Time() - target.position[target_index+1] <= backtrack_time then
				temp[temp_index] = target.position[target_index]
				temp[temp_index+1] = target.position[target_index+1]
				temp_index = temp_index + 2
			end
			target_index = target_index + 2
		end
		
		-- Places most recent position and current time in the temporary array
		temp[temp_index] = target:GetAbsOrigin()
		temp[temp_index+1] = Time()
		
		-- Sets the global array as the temporary array
		target.position = temp
	end	
end

-- Glimpse dummy modifier
modifier_imba_glimpse_dummy = class({})

function modifier_imba_glimpse_dummy:CheckState()
	local state = {[MODIFIER_STATE_NO_HEALTH_BAR] = true} 
	return state
end



-- Glimpse storm aura modifier
modifier_imba_glimpse_storm_aura = class({})

function modifier_imba_glimpse_storm_aura:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.storm_linger = self.ability:GetSpecialValueFor("storm_linger")
		self.storm_radius = self.ability:GetSpecialValueFor("storm_radius")					
	end
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetAuraRadius()
	return self.storm_radius - 50
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetAuraDuration()
	return self.storm_linger + self.caster:FindTalentValue("special_bonus_imba_disruptor_2")
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:GetModifierAura()
	return "modifier_imba_glimpse_storm_debuff"
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:IsAura()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:IsHidden()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:IsPurgable()
	return false
end


modifier_imba_glimpse_storm_debuff = class({})

function modifier_imba_glimpse_storm_debuff:OnCreated()	
	-- Ability properties
	self.target = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.stormbearer_buff = "modifier_imba_stormbearer"
	self.scepter = self.caster:HasScepter()

	-- Ability specials
	self.storm_interval = self.ability:GetSpecialValueFor("storm_interval")
	self.storm_damage = self.ability:GetSpecialValueFor("storm_damage")
	
	-- Start thinking
	self:StartIntervalThink(self.storm_interval)	
end

function modifier_imba_glimpse_storm_debuff:IsDebuff()
	return true
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:IsHidden()
	return false
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:IsPurgable()
	return false
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:OnDestroy()
	self:StartIntervalThink(-1)
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf"
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:OnIntervalThink()
	if IsServer() then		
		if not self.target:IsMagicImmune() or not self.target:IsInvulnerable() then			
			local damageTable = {
									victim = self.target,
									attacker = self.caster,
									damage = self.storm_damage,
									damage_type = DAMAGE_TYPE_MAGICAL,		
									ability = self.ability
								}
								
			ApplyDamage(damageTable)

			-- Give a Stormbearer stack to caster			
			if self.caster:HasModifier(self.stormbearer_buff) then
				local stormbearer_buff_handler = self.caster:FindModifierByName(self.stormbearer_buff)					
				stormbearer_buff_handler:IncrementStackCount()			
			end			
		end
	end
end

---------------------------------------------------

function modifier_imba_glimpse_storm_debuff:CheckState()			
	local state	
	if self.scepter then
		
		state = { [MODIFIER_STATE_SILENCED] = true,
				  [MODIFIER_STATE_MUTED] = true}
	else
		state = { [MODIFIER_STATE_SILENCED] = true}	
	end		
	
	return state	
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Disruptor's Kinetic Field
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_disruptor_kinetic_field = class ({})
LinkLuaModifier("modifier_imba_kinetic_field_dummy_guard", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

function imba_disruptor_kinetic_field:GetAOERadius()	
		local radius = self:GetSpecialValueFor("field_radius")	
		return radius	
end

function imba_disruptor_kinetic_field:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		local ability = self
		local cast_response = "disruptor_dis_kineticfield_0"..RandomInt(1, 5)
		local sound_cast = "Hero_Disruptor.KineticField"
		local sound_formation = "Hero_Disruptor.KineticField.Pinfold"
		local sound_end = "Hero_Disruptor.KineticField.End"			
		local particle_formation = "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation.vpcf" -- rods that 'set up' the field
		local particle_field = "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf" -- the field itself
		local guard_buff = "modifier_imba_kinetic_field_dummy_guard"
		
		-- Ability specials
		local formation_delay = ability:GetSpecialValueFor("formation_delay")
		local field_radius = ability:GetSpecialValueFor("field_radius")
		local duration = ability:GetSpecialValueFor("duration")
		local vision_aoe = ability:GetSpecialValueFor("vision_aoe")

		-- #6 Talent: Kinetic Field duration increase
		duration = duration + caster:FindTalentValue("special_bonus_imba_disruptor_6")

		-- Roll for a cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
			 
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)
		
		-- Create dummy unit
		local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeamNumber())	
		
		-- Add vision for the duration	
		AddFOWViewer(caster:GetTeamNumber(), dummy:GetAbsOrigin(),vision_aoe, formation_delay+duration, false)
		
		-- Create formation particles
		particle_formation = ParticleManager:CreateParticle(particle_formation, PATTACH_ABSORIGIN, dummy)
		ParticleManager:SetParticleControl(particle_formation, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_formation, 1, Vector(field_radius, 1,0))
		ParticleManager:SetParticleControl(particle_formation, 2, Vector(formation_delay, 0, 0))
		ParticleManager:SetParticleControl(particle_formation, 4, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(particle_formation, 15, dummy:GetAbsOrigin())
		
		-- Wait for formation to finish setting up
		Timers:CreateTimer(formation_delay, function()
			
			-- Give dummy the guard modifier
			dummy:AddNewModifier(caster, ability, guard_buff, {duration = duration})
			
			-- Play formation sound
			EmitSoundOn(sound_formation, caster)
			
			-- Create field particles
			particle_field = ParticleManager:CreateParticle(particle_field, PATTACH_ABSORIGIN, dummy)
			ParticleManager:SetParticleControl(particle_field, 0, dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_field, 1, Vector(field_radius, 1, 1))
			ParticleManager:SetParticleControl(particle_field, 2, Vector(duration, 0, 0))
		
			-- Make electricity waves run to the middle, as it looks fabulous
			local electricity_radius = field_radius
			
			Timers:CreateTimer(0.3, function()
				electricity_radius = electricity_radius - 50				
				ParticleManager:SetParticleControl(particle_field, 1, Vector(electricity_radius, 1, 1))
				
				if electricity_radius < 50 then
					return nil
				else
					return 0.3			
				end				
			end)
		
			-- Play end sound
			EmitSoundOn(sound_end, caster)
		
			-- Destroy dummy after effects ended
			Timers:CreateTimer(duration+1, function() 
				dummy:Destroy()
			end)			
		end)
	end
end


modifier_imba_kinetic_field_dummy_guard = class ({})


function modifier_imba_kinetic_field_dummy_guard:OnCreated()	
	if IsServer() then
		-- Ability properties
		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.dummy = self:GetParent()
		
		self.particle_attack = "particles/hero/disruptor/disruptor_kinetic_field_attack.vpcf"
		self.stormbearer_buff = "modifier_imba_stormbearer"
		self.scepter = self.caster:HasScepter()		

		-- Ability specials
		self.edge_damage_hero = self.ability:GetSpecialValueFor("edge_damage_hero")
		self.edge_damage_creep = self.ability:GetSpecialValueFor("edge_damage_creep")
		self.knockback_duration = self.ability:GetSpecialValueFor("knockback_duration")
		self.cooldown_reduction = self.ability:GetSpecialValueFor("cooldown_reduction")		
		self.scepter_stack_amount = self.ability:GetSpecialValueFor("scepter_stack_amount")
		self.field_radius = self.ability:GetSpecialValueFor("field_radius") - 15 --340		

		self:StartIntervalThink(0.1)	
	end	
end

---------------------------------------------------

function modifier_imba_kinetic_field_dummy_guard:OnIntervalThink()
	if IsServer() then
		local should_reduce_cd = false

		-- Radiuses
		local in_edge_radius = self.field_radius - 35 -- 305
		local out_edge_radius = self.field_radius + 35 -- 375
		
		-- Find units in the field
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.dummy:GetAbsOrigin(),
										  nil,
										  self.field_radius + 50,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		for _,enemy in pairs(enemies) do				
			
			local distance = (enemy:GetAbsOrigin() - self.dummy:GetAbsOrigin()):Length2D()				
			
			-- units inside the field that touch the wall
			-- #1 Talent: units outside the field that touch the wall are pulled inside
			if (distance >= in_edge_radius and distance <= self.field_radius) or (distance <= out_edge_radius and distance >= self.field_radius and self.caster:HasTalent("special_bonus_imba_disruptor_1")) then
				if not enemy:IsMagicImmune() then
				
					-- Damage enemy depending on whether it is a creep or a hero
					local damageTable			
					if enemy:IsHero() then		
						damageTable = {victim = enemy,
										 	attacker = self.caster,	
										 	damage = self.edge_damage_hero,
										 	damage_type = DAMAGE_TYPE_MAGICAL,
										 	ability = self.ability
											}
					else
						damageTable = {victim = enemy,
										 	attacker = self.caster,	
										 	damage = self.edge_damage_creep,
										 	damage_type = DAMAGE_TYPE_MAGICAL,
										 	ability = self.ability
											}
					end										
					
					ApplyDamage(damageTable)	
					
					-- Give Stormbearer stacks to caster					
					if self.caster:HasModifier(self.stormbearer_buff) then							
						local current_stacks = self.caster:GetModifierStackCount(self.stormbearer_buff,self.caster)							
						self.caster:SetModifierStackCount(self.stormbearer_buff, self.caster, current_stacks + self.scepter_stack_amount)					
					end
					
					
					-- Create dummy that knockbacks toward the field dummy at location
					local direction = (enemy:GetAbsOrigin() - self.dummy:GetAbsOrigin()):Normalized()
					local knockback_dummy_loc = enemy:GetAbsOrigin() + direction * 250
					local knockback_dummy = CreateUnitByName("npc_dummy_unit", knockback_dummy_loc, false, self.caster, self.caster, self.caster:GetTeamNumber())				
							
					-- Add attack particles
					self.particle_attack_fx = ParticleManager:CreateParticle(self.particle_attack, PATTACH_WORLDORIGIN, self.dummy)
					ParticleManager:SetParticleControl(self.particle_attack_fx, 0, Vector(enemy:GetAbsOrigin().x, enemy:GetAbsOrigin().y, enemy:GetAbsOrigin().z + enemy:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(self.particle_attack_fx, 1, Vector(self.dummy:GetAbsOrigin().x, self.dummy:GetAbsOrigin().y, self.dummy:GetAbsOrigin().z + self.dummy:GetBoundingMaxs().z))					
					ParticleManager:SetParticleControl(self.particle_attack_fx, 8, Vector(1,1,1))
					ParticleManager:SetParticleControl(self.particle_attack_fx, 9, Vector(1,1,1))
					
					-- Knockback it towards dummy
					local knockbackProperties =
					{				
						center_x = knockback_dummy:GetAbsOrigin()[1]+1,
						center_y = knockback_dummy:GetAbsOrigin()[2]+1,
						center_z = knockback_dummy:GetAbsOrigin()[3],
						duration = self.knockback_duration,
						knockback_duration = self.knockback_duration,
						knockback_distance = distance,
						knockback_height = 0
					}
					  enemy:RemoveModifierByName("modifier_knockback")	
					  enemy:AddNewModifier(self.caster, nil, "modifier_knockback", knockbackProperties)
					
					-- Destroy dummy
					knockback_dummy:Destroy()	

					-- Mark for cooldown reduction
					should_reduce_cd = true
				end											
			
			-- kick out units outside the field that touch the wall
			elseif distance <= out_edge_radius and distance >= self.field_radius then
				if not enemy:IsMagicImmune() then
					local damageTable
					-- Damage enemy
					if enemy:IsHero() then
						damageTable = {victim = enemy,
									   attacker = self.caster,	
									   damage = self.edge_damage_hero,
									   damage_type = DAMAGE_TYPE_MAGICAL,
									   ability = self.ability
									  }
					else
						damageTable = {victim = enemy,
									   attacker = self.caster,	
									   damage = self.edge_damage_creep,
									   damage_type = DAMAGE_TYPE_MAGICAL,
									   ability = self.ability
									  }
					end
					
					ApplyDamage(damageTable)																

					-- Give a Stormbearer stack to caster					
					if self.caster:HasModifier(self.stormbearer_buff) then
						local stormbearer_buff_handler = self.caster:FindModifierByName(self.stormbearer_buff)
						stormbearer_buff_handler:IncrementStackCount()					
					end				
					
					-- Find location for the shock effect
					local direction = (enemy:GetAbsOrigin() - self.dummy:GetAbsOrigin()):Normalized()
					local knockback_loc = enemy:GetAbsOrigin() + direction * distance					
					
					-- Add attack particles
					self.particle_attack_fx = ParticleManager:CreateParticle(self.particle_attack, PATTACH_WORLDORIGIN, self.dummy)
					ParticleManager:SetParticleControl(self.particle_attack_fx, 0, Vector(knockback_loc.x, knockback_loc.y, knockback_loc.z))
					ParticleManager:SetParticleControl(self.particle_attack_fx, 1, Vector(enemy:GetAbsOrigin().x, enemy:GetAbsOrigin().y, enemy:GetAbsOrigin().z + enemy:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(self.particle_attack_fx, 8, Vector(1,1,1))
					ParticleManager:SetParticleControl(self.particle_attack_fx, 9, Vector(1,1,1))
					
					-- Knockback it away from dummy
					local knockbackProperties =
					{				
						center_x = self.dummy:GetAbsOrigin()[1]+1,
						center_y = self.dummy:GetAbsOrigin()[2]+1,
						center_z = self.dummy:GetAbsOrigin()[3],
						duration = self.knockback_duration,
						knockback_duration = self.knockback_duration,
						knockback_distance = distance,
						knockback_height = 0
					}
					
					enemy:RemoveModifierByName("modifier_knockback")
					enemy:AddNewModifier(self.caster, nil, "modifier_knockback", knockbackProperties)				
					
					-- Mark for cooldown reduction
					should_reduce_cd = true				
				end								
			end
		end
		
		if should_reduce_cd and not self.caster.kinetic_recharge then
			local cd_remaining = self.ability:GetCooldownTimeRemaining()
			self.caster.kinetic_recharge = true
			-- Clear cooldown, set it again if cooldown was higher than reduction
			self.ability:EndCooldown()
			if cd_remaining > self.cooldown_reduction then			
				self.ability:StartCooldown(cd_remaining - self.cooldown_reduction)
			end
			
			-- wait for 0.2 seconds before allowing cd reduction to trigger again
			Timers:CreateTimer(0.2, function()
				self.caster.kinetic_recharge = false
			end)
		end 
	end
end






---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Disruptor's Static Storm
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_disruptor_static_storm = class ({})
LinkLuaModifier("modifier_imba_static_storm_debuff_aura", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_static_storm_debuff", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_static_storm_debuff_linger", "hero/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

function imba_disruptor_static_storm:GetAOERadius()	
		return self:GetSpecialValueFor("radius")	
end

function imba_disruptor_static_storm:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		local ability = self
		local cast_response = "disruptor_dis_staticstorm_0"..RandomInt(1, 5)
		local sound_cast = "Hero_Disruptor.StaticStorm"
		local sound_end = "Hero_Disruptor.StaticStorm.End"
		local particle_storm = "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf"	
		local scepter = caster:HasScepter()
		local stormbearer_buff = "modifier_imba_stormbearer"
		local storm_aura = "modifier_imba_static_storm_debuff_aura"
			
		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("duration")
		local scepter_duration = ability:GetSpecialValueFor("scepter_duration")
		local initial_damage = ability:GetSpecialValueFor("initial_damage")
		local damage_increase_pulse = ability:GetSpecialValueFor("damage_increase_pulse")
		local max_damage = ability:GetSpecialValueFor("max_damage")
		local scepter_max_damage = ability:GetSpecialValueFor("scepter_max_damage")
		local interval = ability:GetSpecialValueFor("interval")
		local damage_increase_enemy = ability:GetSpecialValueFor("damage_increase_enemy")	
		local stormbearer_stack_damage = ability:GetSpecialValueFor("stormbearer_stack_damage")	 
		local scepter_stormbearer_stack_damage = ability:GetSpecialValueFor("scepter_stormbearer_stack_damage")

		-- #5 Talent: Max damage increase
		max_damage = max_damage + caster:FindTalentValue("special_bonus_imba_disruptor_5")
		scepter_max_damage = scepter_max_damage + caster:FindTalentValue("special_bonus_imba_disruptor_5")

		-- #7 Talent: Damage per pulse increase
		damage_increase_pulse = damage_increase_pulse + caster:FindTalentValue("special_bonus_imba_disruptor_7")
			
		-- if has scepter, assign appropriate values	
		if scepter then
			duration = scepter_duration
			max_damage = scepter_max_damage
			stormbearer_stack_damage = scepter_stormbearer_stack_damage
		end

		-- consume Stormbearer stacks, increase initial damage of the spell
		if caster:HasModifier(stormbearer_buff) then
			local stormbearer_buff_handler = caster:FindModifierByName(stormbearer_buff)
			local stacks = stormbearer_buff_handler:GetStackCount()
			initial_damage = initial_damage + stormbearer_stack_damage * stacks
			stormbearer_buff_handler:SetStackCount(0)
		end

		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
		
		-- Play sound
		EmitSoundOn(sound_cast, caster)
		
		-- Create dummy with aura
		local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeamNumber())
		dummy:AddNewModifier(caster, ability, storm_aura, {duration = duration})		
		
		-- Add particles
		local particle_storm_fx = ParticleManager:CreateParticle(particle_storm, PATTACH_WORLDORIGIN, dummy)
		ParticleManager:SetParticleControl(particle_storm_fx, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_storm_fx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(particle_storm_fx, 2, Vector(duration, 0, 0))
			
		-- Assign variables for pulses
		local current_damage = initial_damage
		local damage_increase_from_enemies = 0
		local pulse_num = 0
		local max_pulses = duration / interval
		
		-- Start timer, deal damage on each interval, increase damage to enemies but not over the maximum
		Timers:CreateTimer(interval, function()
			-- Find enemies in storm area
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  dummy:GetAbsOrigin(),
											  nil,
											  radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_NONE,
											  FIND_ANY_ORDER,
											  false)
											  
			-- Apply damage for each non-magic immune enemy								  
			for _,enemy in pairs(enemies) do
				if not enemy:IsMagicImmune() then
					local damageTable = {victim = enemy,
										attacker = caster,
										damage = current_damage,
										damage_type = DAMAGE_TYPE_MAGICAL}
										
					ApplyDamage(damageTable)						
					
					-- Store damage increase for each hit enemy
					damage_increase_from_enemies = damage_increase_from_enemies + damage_increase_enemy
					
					-- Give a Stormbearer stack to caster					
					if caster:HasModifier(stormbearer_buff) then
						local stormbearer_buff_handler = caster:FindModifierByName(stormbearer_buff)
						stormbearer_buff_handler:IncrementStackCount()					
					end					
				end			
			end
			
			pulse_num = pulse_num + 1
			current_damage = current_damage + damage_increase_pulse + damage_increase_from_enemies
			damage_increase_from_enemies = 0 --reset
			
			-- Check if maximum damage was reached
			if current_damage > max_damage then
				current_damage = max_damage
			end
			
			-- Check if there are still more pulses, stop timer if not 
			if pulse_num < max_pulses then
				return interval
			else
				return nil
			end		
			
				
			-- Play end sound 
			EmitSoundOn(sound_end, dummy)	
		end)
		
		-- Kill dummy after a one second delay
		Timers:CreateTimer(duration+1, function()
			dummy:Destroy()
		end)
	end	
end


-- Static storm silence/mute aura
modifier_imba_static_storm_debuff_aura = class({})

function modifier_imba_static_storm_debuff_aura:OnCreated()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_static_storm_debuff_aura:GetAuraRadius()			
		return self.radius	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:GetAuraSearchFlags()	
		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:GetAuraSearchTeam()	
		return DOTA_UNIT_TARGET_TEAM_ENEMY 	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:GetAuraSearchType()	
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:GetModifierAura()	
		return "modifier_imba_static_storm_debuff"	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:IsAura()	
		return true	
end

---------------------------------------------------

function modifier_imba_glimpse_storm_aura:IsHidden()	
		return true		
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_aura:IsPurgable()	
		return false	
end	



-- Static Storm silence/mute debuff
modifier_imba_static_storm_debuff = class ({})

function modifier_imba_static_storm_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.target = self:GetParent()	
	self.scepter = self.caster:HasScepter()		
	
	self.debuff = "modifier_imba_static_storm_debuff_linger"		
	self.linger_time = self.ability:GetSpecialValueFor("linger_time")
end

function modifier_imba_static_storm_debuff:GetEffectName()	
		return "particles/generic_gameplay/generic_silenced.vpcf"	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff:GetEffectAttachType()
		return PATTACH_OVERHEAD_FOLLOW
end

---------------------------------------------------

function modifier_imba_static_storm_debuff:IsDebuff()	
		return true	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff:IsHidden()	
		return false	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff:IsPurgable()	
		return false	
end

---------------------------------------------------

-- Those commented functions counted how much time an enemy was inside the storm.
-- I'll keep it here in case you decide to bring it back instead of the current flat amount.

-- function modifier_imba_static_storm_debuff:OnCreated()
	-- if IsServer() then
		-- Reset linger variable, start counting time
		-- local target = self:GetParent()
		-- local ability = self:GetAbility()
		-- local interval = ability:GetSpecialValueFor("interval")
		-- target.static_storm_debuff_time = 0
		
		-- self:StartIntervalThink(interval)
	-- end
-- end

-- function modifier_imba_static_storm_debuff:OnIntervalThink()
	-- if IsServer() then
		-- Add 0.25 to linger variable
		-- local target = self:GetParent()
		-- local ability = self:GetAbility()
		-- local interval = ability:GetSpecialValueFor("interval")
		-- target.static_storm_debuff_time = target.static_storm_debuff_time + interval
	-- end
-- end

---------------------------------------------------

function modifier_imba_static_storm_debuff:OnDestroy()
	if IsServer() then
		-- Apply linger debuff for linger duration		
		self.target:AddNewModifier(self.caster, self.ability, self.debuff, {duration = self.linger_time})
	end	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff:CheckState()	
	if self.scepter then
		state = { [MODIFIER_STATE_SILENCED] = true,
				  [MODIFIER_STATE_MUTED] = true,}
	else
		state = { [MODIFIER_STATE_SILENCED] = true}	
	end		

	return state	
end

-- Static Storm silence/mute linger debuff 
modifier_imba_static_storm_debuff_linger = class ({})

function modifier_imba_static_storm_debuff_linger:OnCreated()
	self.caster = self:GetCaster()
	self.scepter = self.caster:HasScepter()
end

function modifier_imba_static_storm_debuff_linger:GetEffectName()	
	return "particles/generic_gameplay/generic_silenced.vpcf"	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_linger:GetEffectAttachType()	
		return PATTACH_OVERHEAD_FOLLOW	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_linger:IsDebuff()	
		return true	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_linger:IsHidden()	
		return false	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_linger:IsPurgable()	
		return false	
end

---------------------------------------------------

function modifier_imba_static_storm_debuff_linger:CheckState()			
		local state = nil
		
		if self.scepter then
			state = { [MODIFIER_STATE_SILENCED] = true,
						[MODIFIER_STATE_MUTED] = true,}
		else
			state = { [MODIFIER_STATE_SILENCED] = true}	
		end		
		
		return state	
end