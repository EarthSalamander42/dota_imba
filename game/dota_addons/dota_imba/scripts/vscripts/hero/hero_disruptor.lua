--[[
Author: sercankd
Date: 06.06.2017
]]


CreateEmptyTalents("disruptor")
local LinkedModifiers = {}

-------------------------------------------
--			     StormBearer
------------------------------------------- 

-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_stormbearer"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_stormbearer = imba_disruptor_stormbearer or class({})

function imba_disruptor_stormbearer:GetIntrinsicModifierName()
	return "modifier_imba_stormbearer"
end

function imba_disruptor_stormbearer:IsInnateAbility()
	return true
end

function imba_disruptor_stormbearer:GetAbilityTextureName()
   return "custom/disruptor_stormbearer"
end
-------------------------------------------
--		Stormbearer's stacks buffs
------------------------------------------- 

modifier_imba_stormbearer = modifier_imba_stormbearer or class({})

function modifier_imba_stormbearer:AllowIllusionDuplicate()	return true	end
function modifier_imba_stormbearer:GetAttributes()	return MODIFIER_ATTRIBUTE_PERMANENT	end
function modifier_imba_stormbearer:IsDebuff()	return false	end
function modifier_imba_stormbearer:IsHidden()	return false	end
function modifier_imba_stormbearer:IsPurgable()	return false	end

function modifier_imba_stormbearer:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	self.ms_per_stack = self.ability:GetSpecialValueFor("ms_per_stack") 
	self.scepter_ms_per_stack = self.ability:GetSpecialValueFor("scepter_ms_per_stack")
end

function modifier_imba_stormbearer:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
		return decFuncs	
end

function modifier_imba_stormbearer:GetModifierMoveSpeedBonus_Constant()		
	self.scepter = self.caster:HasScepter()
	-- Does nothing if the caster is disabled
	if self.caster:PassivesDisabled() then
		return nil
	end

	local stacks = self:GetStackCount()		
	local move_speed_increase

	if self.scepter then
		move_speed_increase = (self.scepter_ms_per_stack + self.caster:FindTalentValue("special_bonus_imba_disruptor_3")) * stacks				
	else
		move_speed_increase = (self.ms_per_stack + self.caster:FindTalentValue("special_bonus_imba_disruptor_3")) * stacks					
	end
	return move_speed_increase			
end

function IncrementStormbearerStacks(caster, stacks)
	-- If no stacks were specified, set them as 1 stack
	if not stacks then
		stacks = 1
	end
	local modifier_stormbearer = "modifier_imba_stormbearer"
	-- Only apply if the caster has the modifier and isn't currently broken
	if caster:HasModifier(modifier_stormbearer) and not caster:PassivesDisabled() then
		local modifier_stormbearer_handler = caster:FindModifierByName(modifier_stormbearer)
		if modifier_stormbearer_handler then
			for i = 1, stacks do
				modifier_stormbearer_handler:IncrementStackCount()
			end
		end
	end
end

---------------------------------------------------
--					Thunder Strike
---------------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_thunder_strike_debuff"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_thunder_strike_talent_slow"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_thunder_strike = imba_disruptor_thunder_strike or class ({})

function imba_disruptor_thunder_strike:GetAOERadius()	return self:GetSpecialValueFor("radius")	end
function imba_disruptor_thunder_strike:GetBehavior()	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING	end
function imba_disruptor_thunder_strike:GetAbilityTargetType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function imba_disruptor_thunder_strike:GetAbilityDamageType()	return DAMAGE_TYPE_MAGICAL end
function imba_disruptor_thunder_strike:GetAbilityTargetTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function imba_disruptor_thunder_strike:GetAbilityTargetFlags()	return DOTA_UNIT_TARGET_FLAG_DEAD end
function imba_disruptor_thunder_strike:GetAbilityTextureName()
   return "disruptor_thunder_strike"
end
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
		if RollPercentage(50) then
			EmitSoundOn(cast_response, caster)
		end
		
		-- Play cast sound
		EmitSoundOn(sound_cast, target)	

		-- #8 Talent: Thunder Strike duration increase
		duration = duration + caster:FindSpecificTalentValue("special_bonus_imba_disruptor_8", "value")

		-- Apply Thunder Strike on target
		target:AddNewModifier(caster, ability, debuff, {duration = duration})	
	end
end

-------------------------------------------
--		Thunder Strike debuff modifier
-------------------------------------------

modifier_imba_thunder_strike_debuff = modifier_imba_thunder_strike_debuff or class ({})

function modifier_imba_thunder_strike_debuff:DestroyOnExpire()	return true end
function modifier_imba_thunder_strike_debuff:RemoveOnDeath()	return false end
function modifier_imba_thunder_strike_debuff:GetEffectName() 	return "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_buff.vpcf" end
function modifier_imba_thunder_strike_debuff:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_thunder_strike_debuff:IsDebuff()	return true end
function modifier_imba_thunder_strike_debuff:IsPurgable()	return true end

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

function modifier_imba_thunder_strike_debuff:CheckState()
	local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
	return state
end

function modifier_imba_thunder_strike_debuff:OnIntervalThink()	
	if IsServer() then	
		ThunderStrikeBoltStart(self)
	end
end

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
	self.strike_particle_fx = ParticleManager:CreateParticle(strike_particle, PATTACH_ABSORIGIN, self.target)
	ParticleManager:SetParticleControl(self.strike_particle_fx, 0, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.strike_particle_fx, 1, self.target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.strike_particle_fx, 2, self.target:GetAbsOrigin())
	
	-- Add Aoe particle
	self.aoe_particle_fx = ParticleManager:CreateParticle(aoe_particle, PATTACH_ABSORIGIN, self.target)
	ParticleManager:SetParticleControl(self.aoe_particle_fx, 0, self.target:GetAbsOrigin())
		
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
			if self.caster:HasModifier(stormbearer_buff) and enemy:IsRealHero() then
				IncrementStormbearerStacks(self.caster)
			end
		end
	end
end

-------------------------------------------
--		Thunder Strike talent modifier
-------------------------------------------

modifier_imba_thunder_strike_talent_slow = modifier_imba_thunder_strike_talent_slow or class({})

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

function modifier_imba_thunder_strike_talent_slow:IsHidden()	return true end

function modifier_imba_thunder_strike_talent_slow:IsPurgable()	return true end

function modifier_imba_thunder_strike_talent_slow:IsDebuff()	return true end

------------------------------------------------------------------------------------------------------

---------------------------------------------------
--				Glimpse
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_glimpse_movement_check_aura"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_movement_check"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_projectile_control"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_modifier_dummy"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_storm_aura"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_storm_debuff"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_glimpse = imba_disruptor_glimpse or class({})

function imba_disruptor_glimpse:GetIntrinsicModifierName()
	return "modifier_imba_glimpse_movement_check_aura"
end
function imba_disruptor_glimpse:GetAbilityTextureName()
   return "disruptor_glimpse"
end
function imba_disruptor_glimpse:OnSpellStart()
	if IsServer() then
		local caster	=	self:GetCaster()
		local ability	=	self
		local target	=	self:GetCursorTarget()
		local modifier_projectile_control = "modifier_imba_glimpse_projectile_control"
		local cast_sound = "Hero_Disruptor.Glimpse.Target"
		local delay = ability:GetSpecialValueFor("move_delay")
		local cast_response = "disruptor_dis_glimpse_0"..math.random(1,5)

			-- Check for Linken's Sphere
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end			

		-- if target is an illusion, kill instantly and do nothing else.
		if target:IsIllusion() then
			target:ForceKill(false)
			return nil
		end

		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end

		EmitSoundOn(cast_sound, target)	

		target:AddNewModifier(caster, ability, modifier_projectile_control, {duration = delay})	
	end
end
-------------------------------------------
--	Glimpse movement check aura
-------------------------------------------

modifier_imba_glimpse_movement_check_aura = modifier_imba_glimpse_movement_check_aura or class({})

function modifier_imba_glimpse_movement_check_aura:IsHidden()	return true end
function modifier_imba_glimpse_movement_check_aura:IsPassive()	return true end

function modifier_imba_glimpse_movement_check_aura:IsAura() return true end

function modifier_imba_glimpse_movement_check_aura:GetAuraRadius() 	return self:GetAbility():GetSpecialValueFor("global_radius") end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_imba_glimpse_movement_check_aura:GetModifierAura()
	return "modifier_imba_glimpse_movement_check"
end

-------------------------------------------
--	Glimpse movement check modifier
-------------------------------------------
modifier_imba_glimpse_movement_check = modifier_imba_glimpse_movement_check or class({})

function modifier_imba_glimpse_movement_check:IsHidden()	return true end
function modifier_imba_glimpse_movement_check:DeclareFunctions()
  local funcs = {
    MODIFIER_EVENT_ON_TELEPORTED, MODIFIER_EVENT_ON_UNIT_MOVED
  }
  return funcs
end
function modifier_imba_glimpse_movement_check:OnTeleported(keys)
	if IsServer() then
		local parent = self:GetParent()
		--OnUnitMoved actually responds to ALL units. Return immediately if not the modifier's parent.
		if keys.unit then
			if keys.unit:GetEntityIndex() ~= parent:GetEntityIndex() then
				return
			else
				movement_check(parent,self:GetAbility())
			end
		else
			return
		end
	end
end	
function modifier_imba_glimpse_movement_check:OnUnitMoved(keys)
	if IsServer() then
		local parent = self:GetParent()
		--OnUnitMoved actually responds to ALL units. Return immediately if not the modifier's parent.
		if keys.unit then
			if keys.unit:GetEntityIndex() ~= parent:GetEntityIndex() then
				return
			else
				movement_check(parent,self:GetAbility())
			end
		else
			return
		end
	end
end

--this function is fishy, if it causes lag i will replace it wit onintervalthink every 1 second
function movement_check(target, ability)
	if target:IsHero() then
		local backtrack_time = ability:GetSpecialValueFor("backtrack_time")

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

-------------------------------------------
--	Glimpse projectile control
-------------------------------------------

modifier_imba_glimpse_projectile_control = modifier_imba_glimpse_projectile_control or class({})

function modifier_imba_glimpse_projectile_control:IsHidden()	return true end

function modifier_imba_glimpse_projectile_control:GetEffectName()
	return "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf"
end

function modifier_imba_glimpse_projectile_control:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_imba_glimpse_projectile_control:OnCreated(keys)
	if IsServer() then
		local caster = self:GetAbility():GetCaster()
		local target = self:GetParent()
		local ability = self:GetAbility()	
		local projectile_speed = ability:GetSpecialValueFor("projectile_speed")/100
		local glimpse_target_particle = "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf"
		local travel_particle = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf"

		ability.moved = false

		-- The glimpse location will be the oldest stored position in the array, providing it has been instantiated
		if target.position[0] == nil then
			ability.glimpse_location = target:GetAbsOrigin()
		else
			ability.glimpse_location = target.position[0]
		end
			-- Creates a dummy unit at the glimpse location to throw the projectile at
		self.dummy = CreateUnitByName("npc_dummy_unit", ability.glimpse_location, false, caster, caster, caster:GetTeamNumber())
		-- Applies a modifier that removes it health bar
		self.dummy:AddNewModifier(caster, ability, "modifier_imba_glimpse_modifier_dummy", {})	

		-- Renders the glimpse location particle
		self.glimpse_target_fx = ParticleManager:CreateParticle(glimpse_target_particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(self.glimpse_target_fx, 0, ability.glimpse_location)
		ParticleManager:SetParticleControl(self.glimpse_target_fx, 1, ability.glimpse_location)
		ParticleManager:SetParticleControl(self.glimpse_target_fx, 2, ability.glimpse_location)

		-- Throws the glimpse projectile at the dummy
		local info = {
		Target = self.dummy,
		Source = target,
		Ability = ability,
		EffectName = travel_particle,
		bDodgeable = false,
		iMoveSpeed = projectile_speed,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
		}
		ProjectileManager:CreateTrackingProjectile( info )
	end
end

function modifier_imba_glimpse_projectile_control:OnDestroy(keys)
	local target = self:GetParent()
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local glimpse_end_sound = "Hero_Disruptor.Glimpse.End"

	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local vision_duration = ability:GetSpecialValueFor("vision_duration")

	--storm aura stuff
	local storm_aura = "modifier_imba_glimpse_storm_aura"
	local storm_duration = ability:GetSpecialValueFor("storm_duration")
	local storm_particle = "particles/hero/disruptor/disruptor_static_storm.vpcf"
	local sound_storm = "Hero_Disruptor.StaticStorm"
	local sound_storm_end = "Hero_Disruptor.StaticStorm.End"

	-- Checks if the target has been moved yet
	if ability.moved == false then
		-- Plays the move sound on the target
		EmitSoundOn(glimpse_end_sound, target)

		AddFOWViewer(caster:GetTeamNumber(), self.dummy:GetAbsOrigin(),vision_radius, vision_duration, false)
		-- Destroys the glimpse location particle
		ParticleManager:DestroyParticle(self.glimpse_target_fx, true)
		ParticleManager:ReleaseParticleIndex(self.glimpse_target_fx)
		-- Moves the target
		target:SetAbsOrigin(ability.glimpse_location)
		FindClearSpaceForUnit(target, ability.glimpse_location, true)

		-- Give dummy static storm aura
		self.dummy:AddNewModifier(caster, ability, storm_aura, {duration = storm_duration})
		-- Play storm's sounds 
		EmitSoundOn(sound_storm, self.dummy)

		-- Add storm particles in dummy's area
		self.storm_particle_fx = ParticleManager:CreateParticle(storm_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(self.storm_particle_fx, 0, self.dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.storm_particle_fx, 1, Vector(10,10,10))
		ParticleManager:SetParticleControl(self.storm_particle_fx, 2, Vector(storm_duration,1,1))

		Timers:CreateTimer(storm_duration, function()
			-- Stop storm's sound, play end's sound
			StopSoundOn(sound_storm, self.dummy)
			EmitSoundOn(sound_storm_end, self.dummy)
			ParticleManager:DestroyParticle(self.storm_particle_fx, false)
			ParticleManager:ReleaseParticleIndex(self.storm_particle_fx)
		end)

		-- Remove dummy a second after storm's end to allow particles to fade out
		Timers:CreateTimer(storm_duration+1, function()					
			--destroy this little shit
			UTIL_Remove(self.dummy)
		end)
	end
	ability.moved = true
end


-------------------------------------------
--	Glimpse dummy modifier
-------------------------------------------

modifier_imba_glimpse_modifier_dummy = modifier_imba_glimpse_modifier_dummy or class({})

function modifier_imba_glimpse_modifier_dummy:CheckState()
	local state = {[MODIFIER_STATE_NO_HEALTH_BAR] = true} 
	return state
end

-------------------------------------------
--	Glimpse storm aura
-------------------------------------------

modifier_imba_glimpse_storm_aura = modifier_imba_glimpse_storm_aura or class({})

function modifier_imba_glimpse_storm_aura:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.storm_linger = self.ability:GetSpecialValueFor("storm_linger")
		self.storm_radius = self.ability:GetSpecialValueFor("storm_radius")					
	end
end
function modifier_imba_glimpse_storm_aura:GetAuraRadius()	
	return self.storm_radius - 50 
end

function modifier_imba_glimpse_storm_aura:GetAuraDuration()
	return self.storm_linger + self.caster:FindTalentValue("special_bonus_imba_disruptor_2")
end

function modifier_imba_glimpse_storm_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_glimpse_storm_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_glimpse_storm_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_glimpse_storm_aura:GetModifierAura()
	return "modifier_imba_glimpse_storm_debuff"
end

function modifier_imba_glimpse_storm_aura:IsAura()	return true end

function modifier_imba_glimpse_storm_aura:IsHidden()	return true end

function modifier_imba_glimpse_storm_aura:IsPurgable()	return false end

function modifier_imba_glimpse_storm_aura:AllowIllusionDuplicate()	return false end

-------------------------------------------
--	Glimpse storm aura debuff
-------------------------------------------

modifier_imba_glimpse_storm_debuff = modifier_imba_glimpse_storm_debuff or class({})

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

function modifier_imba_glimpse_storm_debuff:IsDebuff()	return true end

function modifier_imba_glimpse_storm_debuff:IsHidden() 	return false end

function modifier_imba_glimpse_storm_debuff:IsPurgable()	return false end

function modifier_imba_glimpse_storm_debuff:OnDestroy()	self:StartIntervalThink(-1) end

function modifier_imba_glimpse_storm_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_imba_glimpse_storm_debuff:GetEffectAttachType() 	return PATTACH_OVERHEAD_FOLLOW end

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
			if self.caster:HasModifier(self.stormbearer_buff) and self.target:IsRealHero() then
				IncrementStormbearerStacks(self.caster)
			end			
		end
	end
end

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

------------------------------------------------------------------------------------------------------

---------------------------------------------------
--				Kinetic Field
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_kinetic_field"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_check_position"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_barrier"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_knockback"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_pull"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_kinetic_field = imba_disruptor_kinetic_field or class({})

function imba_disruptor_kinetic_field:GetAOERadius()	
		local radius = self:GetSpecialValueFor("field_radius")	
		return radius	
end

function imba_disruptor_kinetic_field:GetAbilityTextureName()
   return "disruptor_kinetic_field"
end

function imba_disruptor_kinetic_field:OnSpellStart()			
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		local ability = self
		local cast_response = "disruptor_dis_kineticfield_0"..math.random(1,5)
		local kinetic_field_sound = "Hero_Disruptor.KineticField"
		local formation_particle = "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation.vpcf"
		local formation_particle_marker = "particles/units/heroes/hero_disruptor/disruptor_kineticfield_formation_markers.vpcf"
		local modifier_kinetic_field = "modifier_imba_kinetic_field"
		-- Ability specials
		local formation_delay = ability:GetSpecialValueFor("formation_delay")
		local field_radius = ability:GetSpecialValueFor("field_radius")
		local duration = ability:GetSpecialValueFor("duration")
		local vision_aoe = ability:GetSpecialValueFor("vision_aoe")
		
		-- #6 Talent: Kinetic Field duration increase
		duration = duration + caster:FindTalentValue("special_bonus_imba_disruptor_6")

		-- Roll for cast response
		if RollPercentage(50) then
			EmitSoundOn(cast_response, caster)
		end

		-- Plays the formation sound
		EmitSoundOn(kinetic_field_sound, caster)

		--formation particle
		local formation_particle_fx = ParticleManager:CreateParticle(formation_particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(formation_particle_fx, 0, target_point)
		ParticleManager:SetParticleControl(formation_particle_fx, 1, Vector(field_radius, field_radius, 0))
		ParticleManager:SetParticleControl(formation_particle_fx, 2, Vector(1, 0, 0))
		ParticleManager:SetParticleControl(formation_particle_fx, 4, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(formation_particle_fx, 15, target_point)

		--marker particle
		local marker_particle = ParticleManager:CreateParticle(formation_particle_marker, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(marker_particle, 0, target_point)
		ParticleManager:SetParticleControl(marker_particle, 1, Vector(field_radius, field_radius, 0))
		ParticleManager:SetParticleControl(marker_particle, 2, Vector(1, 0, 0))
		-- Wait for formation to finish setting up
		Timers:CreateTimer(formation_delay, function()
			-- Apply thinker modifier on target location
			CreateModifierThinker(caster, ability, modifier_kinetic_field, {duration = duration, target_point_x = target_point.x, target_point_y = target_point.y, target_point_z = target_point.z, marker_particle = marker_particle, formation_particle_fx = formation_particle_fx}, target_point, caster:GetTeamNumber(), false)
		end)
	end
end

---------------------------------------------------
--				Kinetic Field modifier
---------------------------------------------------
modifier_imba_kinetic_field = modifier_imba_kinetic_field or class({})

function modifier_imba_kinetic_field:IsHidden()	return true end
function modifier_imba_kinetic_field:IsPassive()	return true end

function modifier_imba_kinetic_field:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.target = self:GetParent()
		self.ability = self:GetAbility()
		self.field_radius = self.ability:GetSpecialValueFor("field_radius")

		--fuck you vectors
		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
		local vision_aoe = self.ability:GetSpecialValueFor("vision_aoe")
		self.duration = self.ability:GetSpecialValueFor("duration")
		local particle_field = "particles/units/heroes/hero_disruptor/disruptor_kineticfield.vpcf" -- the field itself

		self.sound_cast = "Hero_Disruptor.KineticField"
		EmitSoundOn(self.sound_cast, self.caster)

		AddFOWViewer(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), vision_aoe, self.duration, false)
		ParticleManager:DestroyParticle(keys.formation_particle_fx, true)
		ParticleManager:ReleaseParticleIndex(keys.formation_particle_fx)
		ParticleManager:DestroyParticle(keys.marker_particle, true)
		ParticleManager:ReleaseParticleIndex(keys.marker_particle)
		
		self.field_particle = ParticleManager:CreateParticle(particle_field, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.field_particle, 0, self.target_point)
		ParticleManager:SetParticleControl(self.field_particle, 1, Vector(self.field_radius, 1, 1))
		ParticleManager:SetParticleControl(self.field_particle, 2, Vector(self.duration, 0, 0))
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_kinetic_field:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local ability = self:GetAbility()
		local kinetic_field_sound_end = "Hero_Disruptor.KineticField.End"
		ParticleManager:DestroyParticle(self.field_particle, true)
		StopSoundEvent(self.sound_cast, caster)
	end
end

function modifier_imba_kinetic_field:OnIntervalThink()
	local enemies_in_field = FindUnitsInRadius(self.caster:GetTeamNumber(),
									self.target_point,
									nil,
									self.field_radius + 50,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
	for _,enemy in pairs(enemies_in_field) do
		enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_kinetic_field_check_position", {duration = self:GetRemainingTime(), target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})
	end
end

---------------------------------------------------
--			Kinetic Field check position
---------------------------------------------------

modifier_imba_kinetic_field_check_position = modifier_imba_kinetic_field_check_position or class({})

function modifier_imba_kinetic_field_check_position:IsHidden()	return true end
function modifier_imba_kinetic_field_check_position:OnCreated(keys)
	--fuck you vectors
	self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
end
function modifier_imba_kinetic_field_check_position:DeclareFunctions()
  local funcs = { MODIFIER_EVENT_ON_UNIT_MOVED }
  return funcs
end

function modifier_imba_kinetic_field_check_position:OnUnitMoved(keys)
	if IsServer() then
		local parent = self:GetParent()
		local caster =  self:GetCaster()
		local ability = self:GetAbility()
		--OnUnitMoved actually responds to ALL units. Return immediately if not the modifier's parent.
		if keys.unit then
			if keys.unit:GetEntityIndex() ~= parent:GetEntityIndex() then
				return
			else
				self:kineticize(caster, parent, ability)
			end
		else
			return
		end
	end
end

function modifier_imba_kinetic_field_check_position:kineticize(caster, target, ability)
	local radius = ability:GetSpecialValueFor("field_radius")
	local duration = ability:GetSpecialValueFor("duration")
	local center_of_field = self.target_point
	local modifier_barrier = "modifier_imba_kinetic_field_barrier"

	-- Solves for the target's distance from the border of the field (negative is inside, positive is outside)
	local distance = (target:GetAbsOrigin() - center_of_field):Length2D()
	local distance_from_border = distance - radius
	
	-- The target's angle in the world
	local target_angle = target:GetAnglesAsVector().y
	
	-- Solves for the target's angle in relation to the center of the circle in radians
	local origin_difference =  center_of_field - target:GetAbsOrigin()
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	
	-- Converts the radians to degrees.
	origin_difference_radian = origin_difference_radian * 180
	local angle_from_center = origin_difference_radian / math.pi
	-- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
	angle_from_center = angle_from_center + 180.0
	
	-- Checks if the target is inside the field
	if distance_from_border < 0 and math.abs(distance_from_border) <= 40 then
		target:AddNewModifier(caster, ability, modifier_barrier, {})
		target:AddNewModifier(caster, ability, "modifier_imba_kinetic_field_pull", {duration = 0.5, target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})

	-- Checks if the target is outside the field,
	elseif distance_from_border > 0 and math.abs(distance_from_border) <= 40 then
		target:AddNewModifier(caster, ability, modifier_barrier, {})

		--check if caster has scepter
		if caster:HasTalent("special_bonus_imba_disruptor_1") then
			target:AddNewModifier(caster, ability, "modifier_imba_kinetic_field_pull", {duration = 0.5, target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})
		else
			target:AddNewModifier(caster, ability, "modifier_imba_kinetic_field_knockback", {duration = 0.5, target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})
		end
	else
		-- Removes debuffs, so the unit can move freely
		if target:HasModifier(modifier_barrier) then
			target:RemoveModifierByName(modifier_barrier)
		end
		self:Destroy()
	end
end

function modifier_imba_kinetic_field_check_position:OnDestroy()
	if IsServer() then
		local target = self:GetParent()
			if target:HasModifier("modifier_imba_kinetic_field_barrier") then
				target:RemoveModifierByName("modifier_imba_kinetic_field_barrier")
			end
	end
end

---------------------------------------------------
--			Kinetic Field barrier
---------------------------------------------------

modifier_imba_kinetic_field_barrier = modifier_imba_kinetic_field_barrier or class({})

function modifier_imba_kinetic_field_barrier:IsHidden()	return true end

function modifier_imba_kinetic_field_barrier:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local target = self:GetParent()
		local edge_damage_hero = ability:GetSpecialValueFor( "edge_damage_hero" )
		local edge_damage_creep =ability:GetSpecialValueFor( "edge_damage_creep" )
		local cooldown_reduction =ability:GetSpecialValueFor( "cooldown_reduction" )
		local damageTable
			if target:IsHero() then
				damageTable = {
				victim = target,
				attacker = caster,
				damage = edge_damage_hero,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
				}
			else
				damageTable = {
				victim = target,
				attacker = caster,
				damage = edge_damage_creep,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
				}
			end
		ApplyDamage(damageTable)
		-- reduce ability cooldown everytime a player touch the barrier
		if not kinetic_recharge then
			local kinetic_recharge = true
			local cd_remaining = ability:GetCooldownTimeRemaining()
			-- Clear cooldown, set it again if cooldown was higher than reduction
			ability:EndCooldown()
			if cd_remaining > cooldown_reduction then			
				ability:StartCooldown(cd_remaining - cooldown_reduction)
			end
			-- wait for 0.2 seconds before allowing cd reduction to trigger again
			Timers:CreateTimer(0.2, function()
				kinetic_recharge = false
			end)
		end
	end
end

function modifier_imba_kinetic_field_barrier:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
  }
  return funcs
end
function modifier_imba_kinetic_field_barrier:GetModifierMoveSpeed_Absolute()
  return 0.1
end

---------------------------------------------------
--			Kinetic Field knockback
---------------------------------------------------

modifier_imba_kinetic_field_knockback = modifier_imba_kinetic_field_knockback or class({})

function modifier_imba_kinetic_field_knockback:IsHidden()	return true end
function modifier_imba_kinetic_field_knockback:IsMotionController()	return true end
function modifier_imba_kinetic_field_knockback:GetMotionControllerPriority()	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_kinetic_field_knockback:OnCreated( keys )
	if IsServer() then
		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
		self.parent = self:GetParent()
		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)	
	end
end

function modifier_imba_kinetic_field_knockback:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
  return funcs
end
function modifier_imba_kinetic_field_knockback:GetOverrideAnimation()
  return ACT_DOTA_FLAIL
end
function modifier_imba_kinetic_field_knockback:GetStatusEffectName()
  return "particles/status_fx/status_effect_electrical.vpcf"
end
function modifier_imba_kinetic_field_knockback:GetEffectName()
  return "particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_rise_electricfleks.vpcf"
end
function modifier_imba_kinetic_field_knockback:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end
function modifier_imba_kinetic_field_knockback:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end
	-- Horizontal motion
	self:HorizontalMotion(self.parent, self.frametime)	
end

function modifier_imba_kinetic_field_knockback:HorizontalMotion()
	if IsServer() then
		local knock_distance = 25
		local direction = (self.parent:GetAbsOrigin() - self.target_point):Normalized()
		local set_point = self.parent:GetAbsOrigin() + direction * knock_distance
		self.parent:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, self.parent).z))
		self.parent:SetUnitOnClearGround()
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), knock_distance, false)
	end
end

---------------------------------------------------
--			Kinetic Field pull
---------------------------------------------------

modifier_imba_kinetic_field_pull = modifier_imba_kinetic_field_pull or class({})

function modifier_imba_kinetic_field_pull:IsHidden()	return true end
function modifier_imba_kinetic_field_pull:IsMotionController()	return true end
function modifier_imba_kinetic_field_pull:GetMotionControllerPriority()	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_kinetic_field_pull:OnCreated( keys )
	if IsServer() then
		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)	
	end
end

function modifier_imba_kinetic_field_pull:DeclareFunctions()
  local funcs = { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
  return funcs
end
function modifier_imba_kinetic_field_pull:GetOverrideAnimation()
  return ACT_DOTA_FLAIL
end
function modifier_imba_kinetic_field_pull:GetStatusEffectName()
  return "particles/status_fx/status_effect_electrical.vpcf"
end
function modifier_imba_kinetic_field_pull:GetEffectName()
  return "particles/econ/items/disruptor/disruptor_resistive_pinfold/disruptor_kf_wall_rise_electricfleks.vpcf"
end
function modifier_imba_kinetic_field_pull:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end
function modifier_imba_kinetic_field_pull:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end
	-- Horizontal motion
	self:HorizontalMotion(self.parent, self.frametime)	
end

function modifier_imba_kinetic_field_pull:HorizontalMotion()
	if IsServer() then
		local pull_distance = 15
		local direction = (self.target_point - self.parent:GetAbsOrigin()):Normalized()
		local set_point = self.parent:GetAbsOrigin() + direction * pull_distance
		self.parent:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, self.parent).z))
		self.parent:SetUnitOnClearGround()
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), pull_distance, false)
	end
end


---------------------------------------------------
--			Static Storm
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_static_storm"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff_aura"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff_linger"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_static_storm = imba_disruptor_static_storm or class ({})

function imba_disruptor_static_storm:GetAOERadius()	
		local radius = self:GetSpecialValueFor("radius")	
		return radius	
end

function imba_disruptor_static_storm:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()	
		local ability = self
		local target_point = self:GetCursorPosition()		
		local cast_response = "disruptor_dis_staticstorm_0"..RandomInt(1, 5)
		local sound_end = "Hero_Disruptor.StaticStorm.End"
		local scepter = caster:HasScepter()
		local modifier_static_storm = "modifier_imba_static_storm"
		-- Ability specials
		local scepter_duration = ability:GetSpecialValueFor("scepter_duration")
		local duration = ability:GetSpecialValueFor("duration")	
		-- if has scepter, assign appropriate values	
		if scepter then
			duration = scepter_duration
		end
		
		-- Roll cast response
		if RollPercentage(75) then
			EmitSoundOn(cast_response, caster)
		end
		CreateModifierThinker(caster, ability, modifier_static_storm, {duration = duration, target_point_x = target_point.x, target_point_y = target_point.y, target_point_z = target_point.z}, target_point, caster:GetTeamNumber(), false)
	end
end


---------------------------------------------------
--		Static Storm Modifier
---------------------------------------------------
modifier_imba_static_storm = modifier_imba_static_storm or class({})

function modifier_imba_static_storm:IsHidden()	return true end
function modifier_imba_static_storm:IsPassive()	return true end

function modifier_imba_static_storm:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.target = self:GetParent()
		self.ability = self:GetAbility()
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.interval = self.ability:GetSpecialValueFor("interval")
		self.sound_cast = "Hero_Disruptor.StaticStorm"
		self.stormbearer_buff = "modifier_imba_stormbearer"
		local scepter = self.caster:HasScepter()
		self.sound_end = "Hero_Disruptor.StaticStorm.End"
		self.debuff_aura = "modifier_imba_static_storm_debuff_aura"
		--ability specials
		local initial_damage = self.ability:GetSpecialValueFor("initial_damage")
		self.damage_increase_pulse = self.ability:GetSpecialValueFor("damage_increase_pulse")
		self.max_damage = self.ability:GetSpecialValueFor("max_damage")
		self.scepter_max_damage = self.ability:GetSpecialValueFor("scepter_max_damage")
		self.damage_increase_enemy = self.ability:GetSpecialValueFor("damage_increase_enemy")	
		self.stormbearer_stack_damage = self.ability:GetSpecialValueFor("stormbearer_stack_damage")
		self.duration = self.ability:GetSpecialValueFor("duration")	
		self.scepter_duration = self.ability:GetSpecialValueFor("scepter_duration")	
		--fuck you vectors
		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)
		local particle_storm = "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf"

		EmitSoundOn(self.sound_cast, self.caster)

		self.particle_storm_fx = ParticleManager:CreateParticle(particle_storm, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 0,self.target_point)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.particle_storm_fx, 2, Vector(self.duration, 0, 0))


		-- consume Stormbearer stacks, increase initial damage of the spell
		if self.caster:HasModifier(self.stormbearer_buff) then
			local stormbearer_buff_handler = self.caster:FindModifierByName(self.stormbearer_buff)
			local stacks = stormbearer_buff_handler:GetStackCount()
			initial_damage = initial_damage + self.stormbearer_stack_damage * stacks
			stormbearer_buff_handler:SetStackCount(0)
		end

		-- #5 Talent: Max damage increase
		self.max_damage = self.max_damage + self.caster:FindTalentValue("special_bonus_imba_disruptor_5")
		self.scepter_max_damage = self.scepter_max_damage + self.caster:FindTalentValue("special_bonus_imba_disruptor_5")

		-- #7 Talent: Damage per pulse increase
		self.damage_increase_pulse = self.damage_increase_pulse + self.caster:FindTalentValue("special_bonus_imba_disruptor_7")
			
		-- if has scepter, assign appropriate values	
		if scepter then
			self.duration = self.scepter_duration
			self.max_damage = self.scepter_max_damage			
		end

		-- Assign variables for pulses
		self.current_damage = initial_damage
		self.damage_increase_from_enemies = 0
		self.pulse_num = 0
		self.max_pulses = self.duration / self.interval

		CreateModifierThinker(self.caster, self.ability, self.debuff_aura, {duration = self.duration}, self.target_point, self.caster:GetTeamNumber(), false)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_static_storm:OnIntervalThink()
	local enemies_in_field = FindUnitsInRadius(self.caster:GetTeamNumber(),
									self.target_point,
									nil,
									self.radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
									
	self.bonus_damage_per_enemy = #enemies_in_field * self.damage_increase_enemy
	for _,enemy in pairs(enemies_in_field) do
		-- Deal damage to appropriate enemies			
		if not enemy:IsMagicImmune() and not enemy:IsInvulnerable() then
		
			local damageTable = {victim = enemy,
								attacker = self.caster,
								damage = self.current_damage,
								ability = self.ability,
								damage_type = DAMAGE_TYPE_MAGICAL}
								
			ApplyDamage(damageTable)			
				
			-- Give a Stormbearer stack to caster			
			if self.caster:HasModifier(self.stormbearer_buff) and enemy:IsRealHero() then
				IncrementStormbearerStacks(self.caster)
			end
		end
	end
		self.pulse_num = self.pulse_num + 1
		self.current_damage = self.current_damage + self.damage_increase_pulse + self.damage_increase_from_enemies + self.bonus_damage_per_enemy
		self.damage_increase_from_enemies = 0 --reset
		
		-- Check if maximum damage was reached
		if self.current_damage > self.max_damage then
			self.current_damage = self.max_damage
		end
		
		-- Check if there are still more pulses, stop timer if not 
		if self.pulse_num < self.max_pulses then
			return self.interval
		else
			return nil
		end	
end

function modifier_imba_static_storm:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		ParticleManager:DestroyParticle(self.particle_storm_fx, false)
		StopSoundEvent(self.sound_cast, caster)
		EmitSoundOnLocationWithCaster(self.target_point, self.sound_end, self.caster)
	end
end
---------------------------------------------------
--	Static Storm silence and mute aura
---------------------------------------------------

modifier_imba_static_storm_debuff_aura = class({})

function modifier_imba_static_storm_debuff_aura:OnCreated()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_static_storm_debuff_aura:GetAuraRadius()	return self.radius	end
function modifier_imba_static_storm_debuff_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE	end
function modifier_imba_static_storm_debuff_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY 	end
function modifier_imba_static_storm_debuff_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_static_storm_debuff_aura:GetModifierAura() return "modifier_imba_static_storm_debuff" end
function modifier_imba_static_storm_debuff_aura:IsAura() return true end
function modifier_imba_static_storm_debuff_aura:IsHidden() return true end
function modifier_imba_static_storm_debuff_aura:IsPurgable() return false end	

---------------------------------------------------
--	Static Storm silence and mute aura modifier
---------------------------------------------------

modifier_imba_static_storm_debuff = class ({})

function modifier_imba_static_storm_debuff:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.target = self:GetParent()	
	self.scepter = self.caster:HasScepter()		
	self.debuff = "modifier_imba_static_storm_debuff_linger"		
	self.linger_time = self.ability:GetSpecialValueFor("linger_time")
end

function modifier_imba_static_storm_debuff:GetEffectName()	return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_imba_static_storm_debuff:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_static_storm_debuff:IsDebuff() return true end
function modifier_imba_static_storm_debuff:IsHidden() return false end
function modifier_imba_static_storm_debuff:IsPurgable()	return false end
function modifier_imba_static_storm_debuff:OnDestroy()
	if IsServer() then
		-- Apply linger debuff for linger duration		
		self.target:AddNewModifier(self.caster, self.ability, self.debuff, {duration = self.linger_time})
	end	
end

function modifier_imba_static_storm_debuff:CheckState()	
	if self.scepter then
		state = { [MODIFIER_STATE_SILENCED] = true,
				  [MODIFIER_STATE_MUTED] = true,}
	else
		state = { [MODIFIER_STATE_SILENCED] = true}	
	end
	return state	
end

---------------------------------------------------
--	Static Storm debuff linger
---------------------------------------------------

modifier_imba_static_storm_debuff_linger = class ({})

function modifier_imba_static_storm_debuff_linger:OnCreated()
	self.caster = self:GetCaster()
	self.scepter = self.caster:HasScepter()
end

function modifier_imba_static_storm_debuff_linger:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf"	end
function modifier_imba_static_storm_debuff_linger:GetEffectAttachType()	return PATTACH_OVERHEAD_FOLLOW end
function modifier_imba_static_storm_debuff_linger:IsDebuff() return true end
function modifier_imba_static_storm_debuff_linger:IsHidden() return false end
function modifier_imba_static_storm_debuff_linger:IsPurgable() return false end

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

-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "hero/hero_disruptor", MotionController)
end