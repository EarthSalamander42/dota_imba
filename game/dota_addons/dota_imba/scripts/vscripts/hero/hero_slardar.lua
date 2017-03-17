-- Author: Shush
-- Date: 3/1/2017

CreateEmptyTalents("slardar")

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Slardar's Guardian Sprint
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_slardar_guardian_sprint = class({})
LinkLuaModifier("modifier_imba_guardian_sprint_buff", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_guardian_sprint_aspd_slow", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rip_current_movement", "hero/hero_slardar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_rip_current_stun", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rip_current_slow", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)


function imba_slardar_guardian_sprint:GetAbilityTextureName()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sprint_buff = "modifier_imba_guardian_sprint_buff"	
	
	if caster:HasModifier(sprint_buff) then
		return "custom/slardar_forward_propel"
	else
		return "slardar_sprint"
	end
end

function imba_slardar_guardian_sprint:GetCooldown()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sprint_buff = "modifier_imba_guardian_sprint_buff"	
	
	-- Ability specials	
	local rip_current_cd = ability:GetSpecialValueFor("rip_current_cd")
	local sprint_cd = ability:GetSpecialValueFor("sprint_cd")
	local duration = ability:GetSpecialValueFor("duration")	
	
	-- Check which mode we are on right now
	if caster:HasModifier(sprint_buff) then
		return rip_current_cd
	else		
		return sprint_cd
	end
end

function imba_slardar_guardian_sprint:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	
	local sprint_buff = "modifier_imba_guardian_sprint_buff"	
	local sound_cast = "Hero_Slardar.Sprint"
	local motion_modifier = "modifier_imba_rip_current_movement"	
	local modifier_stun = "modifier_imba_rip_current_stun"
	local modifier_slow = "modifier_imba_rip_current_slow"
	
	-- Decide which mode we should use right now, depending on if caster has sprint	
	if not caster:HasModifier(sprint_buff) then
		-----------------------------------------------------
		-- SPRINT MODE
		-----------------------------------------------------		
		-- Ability specials
		local duration = ability:GetSpecialValueFor("duration")		
		
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)
		
		-- Apply sprint modifier
		caster:AddNewModifier(caster, ability, sprint_buff, {duration = duration})		
		
		-- Disable Rip Current
		ability:EndCooldown()
		ability:SetActivated(false)
	else
		-----------------------------------------------------
		-- RIP CURRENT MODE
		-----------------------------------------------------						
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)		
			
		-- Stop caster's action before pushing
		caster:Stop()
		
		-- Apply move modifier
		caster:AddNewModifier(caster, ability, motion_modifier, {})		
	end
end

-- Sprint modifier
modifier_imba_guardian_sprint_buff = class({})

function modifier_imba_guardian_sprint_buff:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_imba_guardian_sprint_buff:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local modifier_talent_slow = "modifier_imba_guardian_sprint_aspd_slow"	 
		
		-- Ability specials
		local search_radius = ability:GetSpecialValueFor("search_radius")
		
		-- #5 Talent: Rip Current can always be cast without needing a unit
		if caster:HasTalent("special_bonus_imba_slardar_5") then
			ability:SetActivated(true)
		else
			-- Decide Rip Current activation
			local allies = FindUnitsInRadius(caster:GetTeamNumber(),
											 caster:GetAbsOrigin(),
											 nil,
											 search_radius,
											 DOTA_UNIT_TARGET_TEAM_BOTH,
											 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											 DOTA_UNIT_TARGET_FLAG_NONE,
											 FIND_CLOSEST,
											 false)
			
			-- Not including self.
			if #allies > 1 then
				ability:SetActivated(true)			
			else
				ability:SetActivated(false)
			end	
		end

		-- #2 Talent: Sprinting through enemy units slows their attack speed for 0.5 seconds
		if caster:HasTalent("special_bonus_imba_slardar_2") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  caster:GetAbsOrigin(),
											  nil,
											  search_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_NONE,
											  FIND_ANY_ORDER,
											  false)

			-- Apply enemies attack speed slow modifier
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, ability, modifier_talent_slow, {duration = 0.3})
			end
		end
	end
end

function modifier_imba_guardian_sprint_buff:GetTexture()
	return "slardar_sprint"
end

function modifier_imba_guardian_sprint_buff:CheckState()
	 
	 local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	 return state
end

function modifier_imba_guardian_sprint_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
						  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
						  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_guardian_sprint_buff:GetActivityTranslationModifiers()
	return "sprint"
end

function modifier_imba_guardian_sprint_buff:GetModifierMoveSpeedBonus_Percentage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local modifier_rain = "modifier_imba_rain_cloud_buff"
	
	local ms_bonus_pct = ability:GetSpecialValueFor("ms_bonus_pct")
	local ms_speed_rain_pct = ability:GetSpecialValueFor("ms_speed_rain_pct")
	
	if caster:HasModifier(modifier_rain) then
		ms_bonus_pct = ms_bonus_pct + ms_speed_rain_pct
	end
	
	return ms_bonus_pct	
end

function modifier_imba_guardian_sprint_buff:GetModifierIncomingDamage_Percentage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local modifier_rain = "modifier_imba_rain_cloud_buff"
	
	local damage_amp_pct = ability:GetSpecialValueFor("damage_amp_pct")
	local damage_reduction_rain = ability:GetSpecialValueFor("damage_reduction_rain")
	
	if caster:HasModifier(modifier_rain) then
		damage_amp_pct = damage_amp_pct + (-damage_reduction_rain)
	end
	
	return damage_amp_pct	
end

function modifier_imba_guardian_sprint_buff:GetEffectName()
	return "particles/units/heroes/hero_slardar/slardar_sprint.vpcf"
end

function modifier_imba_guardian_sprint_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_guardian_sprint_buff:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		local sprint_cd = ability:GetSpecialValueFor("sprint_cd")
		
		ability:SetActivated(true)
		ability:StartCooldown(sprint_cd)
	end
end

-- Rip current movement modifier
modifier_imba_rip_current_movement = class({})

function modifier_imba_rip_current_movement:GetTexture()
	return "custom/slardar_forward_propel"
end

function modifier_imba_rip_current_movement:OnCreated()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		-- Ability specials
		local distance = ability:GetSpecialValueFor("distance")
		local velocity = ability:GetSpecialValueFor("velocity")
		
		-- Set variables for current cast
		self.distance_travelled = 0
		self.distance = distance
		self.direction = caster:GetForwardVector()
		self.velocity = velocity	

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end	
	end
end

function modifier_imba_rip_current_movement:UpdateHorizontalMotion( me, dt)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		if self.distance_travelled < self.distance then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + self.direction * self.velocity * dt)
			self.distance_travelled = self.distance_travelled + self.velocity * dt
		else
			caster:InterruptMotionControllers(true)
			self:Destroy()
		end
	end
end

function modifier_imba_rip_current_movement:IsHidden()
	return true
end

function modifier_imba_rip_current_movement:IsDebuff()
	return false
end

function modifier_imba_rip_current_movement:IsPurgable()
	return false
end

function modifier_imba_rip_current_movement:OnRemoved()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local sound_land = "n_mud_golem.Boulder.Cast"
		local modifier_stun = "modifier_imba_rip_current_stun"
		local modifier_slow = "modifier_imba_rip_current_slow"
		
		-- Ability specials
		local slow_duration = ability:GetSpecialValueFor("slow_duration")
		local stun_duration = ability:GetSpecialValueFor("stun_duration")
		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")

		-- #1 Talent: Rip Current land radius and damage increase
		radius = radius + caster:FindSpecificTalentValue("special_bonus_imba_slardar_1", "radius")
		damage = damage + caster:FindSpecificTalentValue("special_bonus_imba_slardar_1", "damage")
		
		-- Play hit sound
		EmitSoundOn(sound_land, caster)
		
		-- Find nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		-- Cycle through enemies are not magic immune
		for _, enemy in pairs(enemies) do						
			if not enemy:IsMagicImmune() then		
				-- Apply damage
				local damageTable = {victim = enemy,
									attacker = caster,
									damage = damage,
									damage_type = DAMAGE_TYPE_PHYSICAL}
							
				ApplyDamage(damageTable)	
				
				-- Apply stun and slow modifiers
				enemy:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})
				enemy:AddNewModifier(caster, ability, modifier_slow, {duration = slow_duration})				
			end
		end
	end
end

function modifier_imba_rip_current_movement:GetEffectName()
	return "particles/hero/slardar/slardar_foward_propel.vpcf"
end

function modifier_imba_rip_current_movement:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_rip_current_movement:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
						  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS}
		
		return decFuncs	
end

function modifier_imba_rip_current_movement:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_imba_rip_current_movement:GetActivityTranslationModifiers()
	return "forcestaff_friendly"
end

-- Stun propel modifier 
modifier_imba_rip_current_stun = class({})

function modifier_imba_rip_current_stun:GetTexture()
	return "custom/slardar_forward_propel"
end

function modifier_imba_rip_current_stun:IsDebuff()
	return true
end

function modifier_imba_rip_current_stun:IsHidden()
	return false
end

function modifier_imba_rip_current_stun:IsPurgeException()
	return true
end

function modifier_imba_rip_current_stun:IsStunDebuff()
	return true
end

function modifier_imba_rip_current_stun:CheckState()
	 local state = {[MODIFIER_STATE_STUNNED] = true}
	 return state
end

-- Slow propel modifier
modifier_imba_rip_current_slow = class({})

function modifier_imba_rip_current_slow:GetTexture()
	return "custom/slardar_forward_propel"
end

function modifier_imba_rip_current_slow:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_rip_current_slow:GetModifierMoveSpeedBonus_Percentage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()	
	local ms_slow_pct = ability:GetSpecialValueFor("ms_slow_pct")
	
	return ms_slow_pct
end


-- Talent modifier: attack speed slow
modifier_imba_guardian_sprint_aspd_slow = class({})

function modifier_imba_guardian_sprint_aspd_slow:IsHidden()
	return false
end

function modifier_imba_guardian_sprint_aspd_slow:IsPurgable()
	return true
end

function modifier_imba_guardian_sprint_aspd_slow:IsDebuff()
	return true
end

function modifier_imba_guardian_sprint_aspd_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFuncs
end

function modifier_imba_guardian_sprint_aspd_slow:GetModifierAttackSpeedBonus_Constant()
	self.caster = self:GetCaster()
	return self.caster:FindTalentValue("special_bonus_imba_slardar_2") * (-1)
end

function modifier_imba_guardian_sprint_aspd_slow:GetTexture()
	return "slardar_sprint"
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--  		Slardar's Slithereen Crush
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_slardar_slithereen_crush = class({})
LinkLuaModifier("modifier_imba_slithereen_crush_stun", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slithereen_crush_slow", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_slithereen_crush_royal_break", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)

function imba_slardar_slithereen_crush:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self		
	local particle_start = "particles/units/heroes/hero_slardar/slardar_crush_start.vpcf"
	
	-- Add start particle
	local particle_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 0, caster:GetAbsOrigin())
	
	return true
end

function imba_slardar_slithereen_crush:OnSpellStart()
	local caster = self:GetCaster()
	SlithereenCrush(self)

	-- #6 Talent: Casts a second Slithereen Crush after a second delay
	if caster:HasTalent("special_bonus_imba_slardar_6") then
		local delay = caster:FindTalentValue("special_bonus_imba_slardar_6")		
		
		Timers:CreateTimer(delay, function()						
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
			Timers:CreateTimer(self:GetCastPoint(), function()
				SlithereenCrush(self)
			end)
		end)
	end
end

function SlithereenCrush(self)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	
	local sound_cast = "Hero_Slardar.Slithereen_Crush"	
	local particle_splash = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
	local particle_hit = "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf"
	local modifier_stun = "modifier_imba_slithereen_crush_stun"
	local modifier_slow = "modifier_imba_slithereen_crush_slow"
	local modifier_royal_break = "modifier_imba_slithereen_crush_royal_break"
	local modifier_rain = "modifier_imba_rain_cloud_buff"
		
	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")
	local radius_inc_rain_pct = ability:GetSpecialValueFor("radius_inc_rain_pct") -- Not used yet, agh effect
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local damage = ability:GetSpecialValueFor("damage")
	local royal_break_duration = ability:GetSpecialValueFor("royal_break_duration")
	
	if caster:HasModifier(modifier_rain) then
		radius = radius * (1+(radius_inc_rain_pct/100))
	end	
	
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	-- Add crush particles
	local particle_splash_fx = ParticleManager:CreateParticle(particle_splash, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_splash_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_splash_fx, 1, Vector(1, 1, radius+100))
	
	-- Find all nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  caster:GetAbsOrigin(),
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)
	
	for _, enemy in pairs(enemies) do
		-- Check for magic immunity
		if not enemy:IsMagicImmune() then			
			-- Apply hit splash particles on enemies hit
			local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(particle_hit_fx, 0, enemy:GetAbsOrigin())
			
			-- Damage nearby enemies
			local damageTable = {victim = enemy,
								attacker = caster,
								damage = damage,
								damage_type = DAMAGE_TYPE_PHYSICAL}
						
			ApplyDamage(damageTable)
		
			-- Apply the three debuffs on them
			enemy:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})
			enemy:AddNewModifier(caster, ability, modifier_slow, {duration = (stun_duration + slow_duration)})
			enemy:AddNewModifier(caster, ability, modifier_royal_break, {duration = royal_break_duration})
		end
	end
end

-- Stun modifier
modifier_imba_slithereen_crush_stun = class({})

function modifier_imba_slithereen_crush_stun:IsDebuff()
	return true
end

function modifier_imba_slithereen_crush_stun:IsHidden()
	return false
end

function modifier_imba_slithereen_crush_stun:IsPurgeException()
	return true
end

function modifier_imba_slithereen_crush_stun:IsStunDebuff()
	return true
end

function modifier_imba_slithereen_crush_stun:CheckState()
	 local state = {[MODIFIER_STATE_STUNNED] = true}
	 return state
end

-- Slow modifier
modifier_imba_slithereen_crush_slow = class({})

function modifier_imba_slithereen_crush_slow:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
						  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_slithereen_crush_slow:GetModifierMoveSpeedBonus_Percentage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()	
	local ms_slow_pct = ability:GetSpecialValueFor("ms_slow_pct")
	
	return ms_slow_pct
end

function modifier_imba_slithereen_crush_slow:GetModifierAttackSpeedBonus_Constant()
	local caster = self:GetCaster()
	local ability = self:GetAbility()	
	local as_slow = ability:GetSpecialValueFor("as_slow")
	
	return as_slow
end

function modifier_imba_slithereen_crush_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_slardar_crush.vpcf"
end

function modifier_imba_slithereen_crush_stun:IsDebuff()
	return true
end

function modifier_imba_slithereen_crush_stun:IsHidden()
	return false
end

function modifier_imba_slithereen_crush_stun:IsPurgable()
	return true
end

-- Royal break modifier
modifier_imba_slithereen_crush_royal_break = class({})

function modifier_imba_slithereen_crush_royal_break:OnCreated()
	if IsServer() then		
		local ability = self:GetAbility()
		local royal_break_attacks = ability:GetSpecialValueFor("royal_break_attacks")
		
		self:SetStackCount(royal_break_attacks)	
	end
end

function modifier_imba_slithereen_crush_royal_break:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_slithereen_crush_royal_break:OnAttackLanded( keys )
	if IsServer() then	
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local attacker = keys.attacker
		local target = keys.target
		
		-- Only apply when the caster, or his teammates attack the target
		if attacker:IsHero() and attacker:GetTeamNumber() ~= target:GetTeamNumber() and parent == target then
			-- Remove a stack, or destroy the debuff
			local stacks = self:GetStackCount()
			
			if stacks > 1 then
				self:DecrementStackCount()
			else
				self:Destroy()
			end
		end
	end
end

function modifier_imba_slithereen_crush_royal_break:CheckState()
	 local state = {[MODIFIER_STATE_BLOCK_DISABLED] = true,
					[MODIFIER_STATE_EVADE_DISABLED] = true}
	 return state
end

function modifier_imba_slithereen_crush_stun:IsDebuff()
	return true
end

function modifier_imba_slithereen_crush_stun:IsHidden()
	return false
end

function modifier_imba_slithereen_crush_stun:IsPurgable()
	return true
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--  	   Slardar's Bash of the Deep
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_slardar_bash_of_the_deep = class({})
LinkLuaModifier("modifier_imba_bash_of_the_deep_attack", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_bash_of_the_deep_stun", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)

function imba_slardar_bash_of_the_deep:GetIntrinsicModifierName()
	return "modifier_imba_bash_of_the_deep_attack"	
end

-- Bash attacks modifier
modifier_imba_bash_of_the_deep_attack = class({})

function modifier_imba_bash_of_the_deep_attack:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
		
		return decFuncs	
end

function modifier_imba_bash_of_the_deep_attack:IsHidden()
	return true
end

function modifier_imba_bash_of_the_deep_attack:IsDebuff()
	return false
end

function modifier_imba_bash_of_the_deep_attack:IsPurgable()
	return false
end

function modifier_imba_bash_of_the_deep_attack:OnAttackLanded( keys )
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local attacker = keys.attacker
		local target = keys.target
		local sound_bash = "Hero_Slardar.Bash"
		local modifier_stun = "modifier_imba_bash_of_the_deep_stun"
		
		-- Ability specials
		local bash_chance_pct = ability:GetSpecialValueFor("bash_chance_pct")
		local bash_damage = ability:GetSpecialValueFor("bash_damage")
		local hero_stun_duration = ability:GetSpecialValueFor("hero_stun_duration")
		local creep_duration_mult = ability:GetSpecialValueFor("creep_duration_mult")
		local extend_duration = ability:GetSpecialValueFor("extend_duration")
		local damage_smack = ability:GetSpecialValueFor("damage_smack")

		-- #3 Talent: Forceful Smack duration increase
		extend_duration = extend_duration + caster:FindTalentValue("special_bonus_imba_slardar_3")
		
		-- Set up variables
		local continue_looking_lua_stuns = true
		local smack_target = false
		local modifiers		
		
		-- Check if the caster is the one attacking
		if caster == attacker then
		
			-- If passives are disabled, do nothing
			if caster:PassivesDisabled() then
				return nil
			end
			
			-- Check if victim is stunned
			if target:IsStunned() then				
				-- Check for ALL existing stuns on the victim through "modifier_stunned" (KV stuns)
				modifiers = target:FindAllModifiersByName("modifier_stunned")
				if #modifiers > 0 then -- KV stun was found					
					for _,modifier in pairs(modifiers) do																	
						-- if found and not marked, increase its duration. Stop when one is found.
						if not modifier.extended_by_deep_bash then
						
							-- Make sure it's not a passive bash
							if not modifier:GetAbility():IsPassive() then
								
								modifier:SetDuration(modifier:GetRemainingTime() + extend_duration, true)
								
								-- Mark that modifier as modified
								modifier.extended_by_deep_bash = true							
						
								-- Change variables
								smack_target = true
								
								-- No need to look at lua stuns
								continue_looking_lua_stuns = false
								break
							end
						end
					end
				end
				
				-- If no KV modifier was found, cycle through modifiers, find the first one with the stunned state (lua) that is not marked
				if continue_looking_lua_stuns then
					modifiers = target:FindAllModifiers()
					for _,modifier in pairs(modifiers) do										
						-- Find if it has any checkstate (lua)
						if modifier.CheckState then
							-- Find if the state of the modifier is stunned and it's not marked. Stop when one is found.
							if modifier:CheckState()[MODIFIER_STATE_STUNNED] and not modifier.extended_by_deep_bash then							
								-- Make sure it's not a passive bash.
								if not modifier:GetAbility():IsPassive() then
									-- increase its duration.								
									modifier:SetDuration(modifier:GetRemainingTime() + extend_duration, true)
									
									-- Mark that modifier as modified.
									modifier.extended_by_deep_bash = true

									-- Change variables
									smack_target = true
									break
								end
							end
						end
					end
				end
				
				if smack_target then
					-- Deal bonus smack damage
					local damageTable = {victim = target,
										attacker = caster,
										damage = damage_smack,
										damage_type = DAMAGE_TYPE_PHYSICAL}
				
					ApplyDamage(damageTable)
				end
			end		

			-- Target was not stunned, or was stunned with bashes, and therefore wasn't "smacked".
			-- A normal bash is rolled
			if not smack_target then				
				-- Roll for chance
				local rand = RandomInt(1, 100)				
				if rand <= bash_chance_pct then		
					-- Play bash sound
					EmitSoundOn(sound_bash, target)
					
					-- Apply bash stun with duration depending on hero/creep
					if target:IsHero() then
						target:AddNewModifier(caster, ability, modifier_stun, {duration = hero_stun_duration})
					else
						target:AddNewModifier(caster, ability, modifier_stun, {duration = (hero_stun_duration * creep_duration_mult)})
					end
					
					-- Apply bonus damage
					local damageTable = {victim = target,
										attacker = caster,
										damage = bash_damage,
										damage_type = DAMAGE_TYPE_PHYSICAL}
				
					ApplyDamage(damageTable)					
				end
			end		
		end
	end
end


-- Bash stun modifier
modifier_imba_bash_of_the_deep_stun = class({})

function modifier_imba_bash_of_the_deep_stun:IsDebuff()
	return true
end

function modifier_imba_bash_of_the_deep_stun:IsHidden()
	return false
end

function modifier_imba_bash_of_the_deep_stun:IsPurgeException()
	return true
end

function modifier_imba_bash_of_the_deep_stun:IsStunDebuff()
	return true
end

function modifier_imba_bash_of_the_deep_stun:CheckState()
	 local state = {[MODIFIER_STATE_STUNNED] = true}
	 return state
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--  	   Slardar's Corrosive Haze
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_slardar_corrosive_haze = class({})
LinkLuaModifier("modifier_imba_corrosive_haze_debuff", "hero/hero_slardar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_corrosive_haze_debuff_secondary", "hero/hero_slardar", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_corrosive_haze_slip_debuff", "hero/hero_slardar", LUA_MODIFIER_MOTION_HORIZONTAL)

function imba_slardar_corrosive_haze:GetAOERadius()
	local caster = self:GetCaster()
	return caster:FindSpecificTalentValue("special_bonus_imba_slardar_7", "radius")
end

function imba_slardar_corrosive_haze:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	
	local target = ability:GetCursorTarget()
	local sound_cast = "Hero_Slardar.Amplify_Damage"
	local cast_response_string = "slardar_slar_ability_ampdam_"	
	local particle_haze = "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf"
	local modifier_debuff = "modifier_imba_corrosive_haze_debuff"
	local modifier_secondary_debuff = "modifier_imba_corrosive_haze_debuff_secondary"
	
	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")
	
	-- if target has linken's sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end		

	-- Cast responses
	-- If the target is Riki, roll a cast response for it 
	if target:GetUnitName() == "npc_dota_hero_riki" then
		if RollPercentage(35) then
			local cast_response_roll = RandomInt(9, 14)

			if cast_response_roll < 10 then
				cast_response_string = cast_response_string.."0"
			end

			local cast_response = cast_response_string..cast_response_roll			
			EmitSoundOn(cast_response, caster)
		end		
	else -- otherwise just roll a normal repsonse
		if RollPercentage(15) then
			local cast_response_table = {1, 4, 5, 6, 7, 8}
			local cast_response = cast_response_string.."0"..cast_response_table[RandomInt(1, 6)]			
			EmitSoundOn(cast_response, caster)
		end
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
			
	-- Apply debuff modifier on enemy
	local corrosive_haze_modifier = target:AddNewModifier(caster, ability, modifier_debuff, {duration = duration})	
	
	-- Apply particle effects on enemy
	Timers:CreateTimer(0.01, function() 
		particle_haze_fx = ParticleManager:CreateParticle(particle_haze, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(particle_haze_fx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_haze_fx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_haze_fx, 2, target:GetAbsOrigin())	

		ParticleManager:SetParticleControlEnt(particle_haze_fx, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_haze_fx, 2, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		corrosive_haze_modifier:AddParticle(particle_haze_fx, false, true, -1, false, true)
	end)

	-- #7 Talent: Corrosize Haze now applies to all targets
	if caster:HasTalent("special_bonus_imba_slardar_7") then
		local radius = caster:FindSpecificTalentValue("special_bonus_imba_slardar_7", "radius")		

		-- Find all enemies and apply Corrosive Haze on them as well
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  target:GetAbsOrigin(),
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		-- Ignore main target
		for _,enemy in pairs(enemies) do			
			if enemy ~= target and not enemy:HasModifier(modifier_debuff) then
				corrosive_haze_modifier = enemy:AddNewModifier(caster, ability, modifier_secondary_debuff, {duration = duration})				

				-- Apply particle effects on enemy
				Timers:CreateTimer(0.01, function() 
					particle_haze_fx = ParticleManager:CreateParticle(particle_haze, PATTACH_OVERHEAD_FOLLOW, enemy)
					ParticleManager:SetParticleControl(particle_haze_fx, 0, enemy:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle_haze_fx, 1, enemy:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle_haze_fx, 2, enemy:GetAbsOrigin())	

					ParticleManager:SetParticleControlEnt(particle_haze_fx, 1, enemy, PATTACH_OVERHEAD_FOLLOW, "attach_overhead", enemy:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle_haze_fx, 2, enemy, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
					corrosive_haze_modifier:AddParticle(particle_haze_fx, false, true, -1, false, true)					
				end)
			end
		end
	end
end


-- Armor reduction debuff
modifier_imba_corrosive_haze_debuff = class({})

function modifier_imba_corrosive_haze_debuff:CheckState()
	 
	 local state = {[MODIFIER_STATE_PROVIDES_VISION] = true,
					[MODIFIER_STATE_INVISIBLE] = false}
	 return state
end

function modifier_imba_corrosive_haze_debuff:GetPriority() 
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_imba_corrosive_haze_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
						  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
						  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
						  MODIFIER_EVENT_ON_TAKEDAMAGE}
		
		return decFuncs	
end

function modifier_imba_corrosive_haze_debuff:OnTakeDamage(keys)
	-- #8 Talent: Corrosive Haze decreases armor on physical instances
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local attacker = keys.attacker
	local victim = keys.unit
	local damage_type = keys.damage_type	

	-- if the caster doesn't have the talent, do nothing
	if not caster:HasTalent("special_bonus_imba_slardar_8") then
		return nil
	end

	-- if the damage wasn't physical, do nothing
	if not damage_type == DAMAGE_TYPE_PHYSICAL then
		return nil
	end

	-- Only apply if the victim is in another team of the attacker, and is the one getting hit
	if parent == victim and caster:GetTeamNumber() ~= victim:GetTeamNumber() then
		local max_stacks = caster:FindSpecificTalentValue("special_bonus_imba_slardar_8", "max_stacks")
		local stacks = self:GetStackCount()

		-- Give stack, but don't apply over the allowed amount
		if stacks < max_stacks then
			self:IncrementStackCount()
		end
	end

end

function modifier_imba_corrosive_haze_debuff:GetModifierPhysicalArmorBonus()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local armor_reduction = ability:GetSpecialValueFor("armor_reduction")	
	local stacks = self:GetStackCount()
	local armor_per_stack = caster:FindSpecificTalentValue("special_bonus_imba_slardar_8", "armor_per_stack")

	armor_reduction = armor_reduction + armor_per_stack * stacks
	return armor_reduction * (-1)
end

function modifier_imba_corrosive_haze_debuff:GetModifierIncomingDamage_Percentage()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local modifier_rain = "modifier_imba_rain_cloud_buff"
	
	-- Ability specials
	local rain_cloud_stunned_amp_pct = ability:GetSpecialValueFor("rain_cloud_stunned_amp_pct")
	
	-- Only apply on target if it's stunne and the caster has the Rain Cloud buff
	if caster:HasModifier(modifier_rain) and parent:IsStunned() then
		return rain_cloud_stunned_amp_pct
	else
		return nil
	end
end

function modifier_imba_corrosive_haze_debuff:GetModifierTotalDamageOutgoing_Percentage( keys )
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local attacker = keys.attacker
	local inflictor = keys.inflictor
	local modifier_slip = "modifier_imba_corrosive_haze_slip_debuff"
	
	-- Abiliy specials
	local slip_up_chance_pct = ability:GetSpecialValueFor("slip_up_chance_pct")
	local slip_up_duration = ability:GetSpecialValueFor("slip_up_duration")
	local slip_up_damage_negation = ability:GetSpecialValueFor("slip_up_damage_negation")

	-- #4 Talent: Slipstream miss chance increase
	local slip_up_chance_pct = slip_up_chance_pct + caster:FindTalentValue("special_bonus_imba_slardar_4")
	
	-- Only commit if the parent auto attacked, and does not have the slip debuff
	if attacker == parent and not inflictor and not parent:HasModifier(modifier_slip) then
		-- Roll for slip
		local rand = RandomInt(1,100)
	
		-- Check chance, apply slip modifier and negate damage
		if rand <= slip_up_chance_pct then
			parent:AddNewModifier(caster, ability, modifier_slip, {duration = slip_up_duration})
			
			return slip_up_damage_negation		
		end
	end
	
	return nil	
end

function modifier_imba_corrosive_haze_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_slardar_amp_damage.vpcf"
end

function modifier_imba_corrosive_haze_debuff:IsHidden()
	return false
end

function modifier_imba_corrosive_haze_debuff:IsDebuff()
	return true
end

function modifier_imba_corrosive_haze_debuff:IsPurgable()
	return true
end

-- secondary debuff (#7 talent)
modifier_imba_corrosive_haze_debuff_secondary = class({})

function modifier_imba_corrosive_haze_debuff_secondary:CheckState()
	 
	 local state = {[MODIFIER_STATE_PROVIDES_VISION] = true,
					[MODIFIER_STATE_INVISIBLE] = false}
	 return state
end

function modifier_imba_corrosive_haze_debuff_secondary:GetPriority() 
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_imba_corrosive_haze_debuff_secondary:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
						  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
						  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_corrosive_haze_debuff_secondary:GetModifierPhysicalArmorBonus()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	
	local armor_loss_pct = caster:FindSpecificTalentValue("special_bonus_imba_slardar_7", "armor_loss_pct")
	armor_reduction = armor_reduction * (armor_loss_pct * 0.01)
	

	return armor_reduction * (-1)
end

function modifier_imba_corrosive_haze_debuff_secondary:GetModifierIncomingDamage_Percentage()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local modifier_rain = "modifier_imba_rain_cloud_buff"
	
	-- Ability specials
	local rain_cloud_stunned_amp_pct = ability:GetSpecialValueFor("rain_cloud_stunned_amp_pct")
	
	-- Only apply on target if it's stunne and the caster has the Rain Cloud buff
	if caster:HasModifier(modifier_rain) and parent:IsStunned() then
		return rain_cloud_stunned_amp_pct
	else
		return nil
	end
end

function modifier_imba_corrosive_haze_debuff_secondary:GetModifierTotalDamageOutgoing_Percentage( keys )
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	local attacker = keys.attacker
	local inflictor = keys.inflictor
	local modifier_slip = "modifier_imba_corrosive_haze_slip_debuff"
	
	-- Abiliy specials
	local slip_up_chance_pct = ability:GetSpecialValueFor("slip_up_chance_pct")
	local slip_up_duration = ability:GetSpecialValueFor("slip_up_duration")
	local slip_up_damage_negation = ability:GetSpecialValueFor("slip_up_damage_negation")

	-- #4 Talent: Slipstream miss chance increase
	local slip_up_chance_pct = slip_up_chance_pct + caster:FindTalentValue("special_bonus_imba_slardar_4")
	
	-- Only commit if the parent auto attacked, and does not have the slip debuff
	if attacker == parent and not inflictor and not parent:HasModifier(modifier_slip) then
		-- Roll for slip
		local rand = RandomInt(1,100)
	
		-- Check chance, apply slip modifier and negate damage
		if rand <= slip_up_chance_pct then
			parent:AddNewModifier(caster, ability, modifier_slip, {duration = slip_up_duration})
			
			return slip_up_damage_negation		
		end
	end
	
	return nil	
end

function modifier_imba_corrosive_haze_debuff_secondary:GetStatusEffectName()
	return "particles/status_fx/status_effect_slardar_amp_damage.vpcf"
end

function modifier_imba_corrosive_haze_debuff_secondary:IsHidden()
	return false
end

function modifier_imba_corrosive_haze_debuff_secondary:IsDebuff()
	return true
end

function modifier_imba_corrosive_haze_debuff_secondary:IsPurgable()
	return true
end


-- Slip up debuff
modifier_imba_corrosive_haze_slip_debuff = class({})

function modifier_imba_corrosive_haze_slip_debuff:GetEffectName()
	return "particles/hero/slardar/slardar_slip_up.vpcf"
end

function modifier_imba_corrosive_haze_slip_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_corrosive_haze_slip_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_corrosive_haze_slip_debuff:GetModifierMoveSpeedBonus_Percentage()	
	local ability = self:GetAbility()
	local slip_up_ms_loss_pct = ability:GetSpecialValueFor("slip_up_ms_loss_pct")*(-1)

	return slip_up_ms_loss_pct
end

function modifier_imba_corrosive_haze_slip_debuff:IsHidden()
	return false
end

function modifier_imba_corrosive_haze_slip_debuff:IsDebuff()
	return true
end

function modifier_imba_corrosive_haze_slip_debuff:IsPurgable()
	return true
end





---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--  	   Slardar's Rain Cloud
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_slardar_rain_cloud = class({})
LinkLuaModifier("modifier_imba_rain_cloud_slardar", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_cloud_buff", "hero/hero_slardar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rain_cloud_dummy", "hero/hero_slardar", LUA_MODIFIER_MOTION_HORIZONTAL)


function imba_slardar_rain_cloud:OnInventoryContentsChanged()
	-- Checks if Slardar now has a scepter, or still has it.
	if IsServer() then
		local caster = self:GetCaster()		
		local modifier_slardar = "modifier_imba_rain_cloud_slardar"		
		
		if caster:HasScepter() then
			self:SetLevel(1)
			self:SetHidden(false)
		else
			-- Clear dummy and rain after a game tick
			Timers:CreateTimer(0.01, function()
				if self.dummy and not caster:HasScepter() then									
					-- Release rain effects
					ParticleManager:DestroyParticle(self.particle_rain_fx, false)
					ParticleManager:ReleaseParticleIndex(self.particle_rain_fx)
					
					caster:RemoveModifierByName(modifier_slardar)
				end		
			end)
			
			self:SetLevel(0)
			self:SetHidden(true)
		end
	end
end

function imba_slardar_rain_cloud:GetIntrinsicModifierName()
	return "modifier_imba_rain_cloud_slardar"
end

-- Slardar modifier
modifier_imba_rain_cloud_slardar = class({})

function modifier_imba_rain_cloud_slardar:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_ABILITY_LAYOUT,
						  MODIFIER_EVENT_ON_DEATH,
						  MODIFIER_EVENT_ON_RESPAWN}
		
		return decFuncs	
end

function modifier_imba_rain_cloud_slardar:OnDeath( keys )
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local unit = keys.unit		
		
		-- Check if the caster died, dispel the effect
		if caster == unit then
			ParticleManager:DestroyParticle(ability.particle_rain_fx, false)			
			ParticleManager:ReleaseParticleIndex(ability.particle_rain_fx)
		end
	end
end

function modifier_imba_rain_cloud_slardar:OnRespawn ( keys ) 
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local unit = keys.unit
		local particle_rain = "particles/hero/slardar/slardar_rain_cloud.vpcf"		
		
		-- Check if the caster respawned
		if caster == unit then			
			-- Move dummy to caster's location, apply particles on dummy
			ability.dummy:SetAbsOrigin(caster:GetAbsOrigin())
			
			ability.particle_rain_fx = ParticleManager:CreateParticle(particle_rain, PATTACH_ABSORIGIN_FOLLOW, ability.dummy)
			ParticleManager:SetParticleControl(ability.particle_rain_fx, 0, ability.dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(ability.particle_rain_fx, 1, ability.dummy:GetAbsOrigin())
		end
	end

end

function modifier_imba_rain_cloud_slardar:OnCreated()
	if IsServer() then
		-- Ability properties	
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local modifier_dummy = "modifier_imba_rain_cloud_dummy"
		local modifier_aura = "modifier_imba_rain_cloud_aura"
		local particle_rain = "particles/hero/slardar/slardar_rain_cloud.vpcf"		
		
		-- Existing dummy from repicking Scepter
		if ability.dummy then
			ability.dummy:Destroy()
			ability.dummy = nil
		end
		
		-- Summon dummy on current location
		ability.dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber()) 			
		
		-- Grant the dummy the dummy modifier
		ability.dummy:AddNewModifier(caster, ability, modifier_dummy, {})										
		
		-- Apply particles on dummy
		ability.particle_rain_fx = ParticleManager:CreateParticle(particle_rain, PATTACH_ABSORIGIN_FOLLOW, ability.dummy)
		ParticleManager:SetParticleControl(ability.particle_rain_fx, 0, ability.dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(ability.particle_rain_fx, 1, ability.dummy:GetAbsOrigin())
	end
end

function modifier_imba_rain_cloud_slardar:GetModifierAbilityLayout()
	return 5
end

function modifier_imba_rain_cloud_slardar:IsHidden()
	return true
end

function modifier_imba_rain_cloud_slardar:IsDebuff()
	return false
end

function modifier_imba_rain_cloud_slardar:IsPurgable()
	return false
end

-- Dummy modifier
modifier_imba_rain_cloud_dummy = class({})

function modifier_imba_rain_cloud_dummy:OnCreated()
	if IsServer() then
		local dummy = self:GetParent()
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	end
end

function modifier_imba_rain_cloud_dummy:CheckState()	 
	 local state = {[MODIFIER_STATE_UNSELECTABLE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_NO_HEALTH_BAR] = true,
					[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
					[MODIFIER_STATE_INVULNERABLE] = true}
	 return state
end

function modifier_imba_rain_cloud_dummy:UpdateHorizontalMotion( me, dt)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local dummy = self:GetParent()
		local ability = self:GetAbility()
		
		-- Ability specials
		local velocity_pct = ability:GetSpecialValueFor("velocity_pct")
		local distance_speed_up_1 = ability:GetSpecialValueFor("distance_speed_up_1")
		local speed_up_1_multiplier = ability:GetSpecialValueFor("speed_up_1_multiplier")
		local distance_speed_up_2 = ability:GetSpecialValueFor("distance_speed_up_2")
		local speed_up_2_multiplier = ability:GetSpecialValueFor("speed_up_2_multiplier")
		
		-- If dummy is on the same spot as the caster, do nothing
		if dummy:GetAbsOrigin() == caster:GetAbsOrigin() then
			return nil
		end
		
		-- Calculate distance 		
		local distance = (caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Length2D()	
		
		-- Calculate velocity for the tick based on caster's move speed and distance
		local velocity = caster:GetBaseMoveSpeed() * (velocity_pct/100)
		
		if distance > distance_speed_up_1 then
			velocity = velocity * speed_up_1_multiplier
		end
		
		if distance > distance_speed_up_2 then
			velocity = velocity * speed_up_2_multiplier
		end
		
		-- Calculate direction
		local direction = (caster:GetAbsOrigin() - dummy:GetAbsOrigin()):Normalized()
		
		-- Move the dummy
		dummy:SetAbsOrigin(dummy:GetAbsOrigin() + direction * velocity * dt)		
	end
end

function modifier_imba_rain_cloud_dummy:GetAuraDuration()
	return 0.5
end

function modifier_imba_rain_cloud_dummy:GetAuraEntityReject(target)
	local caster = self:GetCaster()	
	
	if target == caster then		
		return false -- Don't reject aura
	else		
		return true
	end
end

function modifier_imba_rain_cloud_dummy:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")
	
	return aura_radius	
end

function modifier_imba_rain_cloud_dummy:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_imba_rain_cloud_dummy:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_rain_cloud_dummy:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_rain_cloud_dummy:GetModifierAura()
	return "modifier_imba_rain_cloud_buff"
end

function modifier_imba_rain_cloud_dummy:IsAura()
	return true
end

function modifier_imba_rain_cloud_dummy:IsPurgable()
	return false
end

-- Rain cloud aura buff (slardar)
modifier_imba_rain_cloud_buff = class({})

function modifier_imba_rain_cloud_buff:IsDebuff()
	return false
end

function modifier_imba_rain_cloud_buff:IsHidden()
	return false
end

function modifier_imba_rain_cloud_buff:IsPurgable()
	return false
end

function modifier_imba_rain_cloud_buff:GetStatusEffectName()
	return "particles/hero/slardar/slardar_rain_cloud_status_effect.vpcf"
end












