-- Author: Shush
-- Date: 11/1/2017


CreateEmptyTalents("ursa")

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Earthshock
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


imba_ursa_earthshock = class({})
LinkLuaModifier("modifier_imba_earthshock_slow", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_buff", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_prevent", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trembling_steps_debuff", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_earthshock:GetAbilityTextureName()
   return "ursa_earthshock"
end

function imba_ursa_earthshock:OnSpellStart()
	if IsServer() then	
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_cast = "Hero_Ursa.Earthshock"
		local earthshock_particle = "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf"
		local earthshock_debuff = "modifier_imba_earthshock_slow"
		local trembling_steps_buff = "modifier_imba_trembling_steps_buff"
		local trembling_steps_prevent = "modifier_imba_trembling_steps_prevent"
		local enrage_buff = "modifier_imba_enrage_buff"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		local enrage_particle = "particles/hero/ursa/enrage_ursa_earthshock.vpcf"
		
		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("duration")
		local base_damage = ability:GetSpecialValueFor("base_damage")
		local values_increase_distance = ability:GetSpecialValueFor("values_increase_distance")
		local values_increase_pct = ability:GetSpecialValueFor("values_increase_pct")		
		local slow_pct = ability:GetSpecialValueFor("slow_pct")
		local trembling_steps_cooldown = ability:GetSpecialValueFor("trembling_steps_cooldown")
		local trembling_steps_duration = ability:GetSpecialValueFor("trembling_steps_duration")
		local bonus_effects_radius = ability:GetSpecialValueFor("bonus_effects_radius")
		local bonus_damage_pct = ability:GetSpecialValueFor("bonus_damage_pct")
		local bonus_slow_pct = ability:GetSpecialValueFor("bonus_slow_pct")
		local enrage_bonus_radius = enrage_ability:GetSpecialValueFor("bonus_radius_skills")
		local enrage_bonus_dmg_pct = ability:GetSpecialValueFor("enrage_bonus_dmg_pct")		
		
		-- #1 Talent: Increased point blank damage
		bonus_damage_pct = bonus_damage_pct + caster:FindTalentValue("special_bonus_imba_ursa_1")		
		
		-- #6 Talent: Enrage Earthshock/Overpower radius increase		
		enrage_bonus_radius = enrage_bonus_radius + caster:FindTalentValue("special_bonus_imba_ursa_6")		
		
		-- Check if Ursa has Enrage buff active, increase radius, damage percents and set Enrage particles
		if caster:HasModifier(enrage_buff) then
			radius = radius + enrage_bonus_radius
			earthshock_particle = enrage_particle
			bonus_damage_pct = bonus_damage_pct + enrage_bonus_dmg_pct
		end
		
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)
		
		-- Add appropriate particles
		local earthshock_particle_fx = ParticleManager:CreateParticle(earthshock_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(earthshock_particle_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(earthshock_particle_fx, 1, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex(earthshock_particle_fx)
		
		-- Find all enemies in Aoe
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		-- Calculate distance from edge of Earthshock's radius.
		for _,enemy in pairs(enemies) do
		
			if not enemy:IsMagicImmune() then
				local distance = (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()				
				local edge_distance = radius - distance		
				local earthshock_debuff_slow_pct
				local damage						
				
				-- If enemy is closer than 190 units, set bonuses, otherwise calculate damage scaling with distance.
				if distance <= bonus_effects_radius then
					damage = base_damage * (1 + (bonus_damage_pct * 0.01))
					earthshock_debuff_slow_pct = slow_pct + bonus_slow_pct					
				else
					local scale_increase_for_distance =  math.floor(edge_distance / values_increase_distance) --how much it should scale
					local pct_increase_for_distance =  values_increase_pct * scale_increase_for_distance -- how many percents the scale should go up
					damage = base_damage * (1 + pct_increase_for_distance) -- final damage				
					earthshock_debuff_slow_pct = slow_pct * (1+ pct_increase_for_distance) -- final slow value													
				end							
				
				-- Apply damage
				local damageTable = {victim = enemy,
									attacker = caster,
									damage = damage,
									damage_type = DAMAGE_TYPE_MAGICAL,
									ability = ability}
				
				ApplyDamage(damageTable)
		
				-- Apply debuff to non-magic immune enemies
				enemy:AddNewModifier(caster, ability, earthshock_debuff, {duration = duration})								
			end
		end
		
		-- Apply trembling steps buff to Ursa AND trembling_steps prevent buff (to stop him from immediately casting trembling_steps
		caster:AddNewModifier(caster, ability, trembling_steps_buff, {duration = trembling_steps_duration})
		caster:AddNewModifier(caster, ability, trembling_steps_prevent, {duration = trembling_steps_cooldown})	
	end
end




-- Earthshock slow debuff
modifier_imba_earthshock_slow = class({})

function modifier_imba_earthshock_slow:OnCreated()
	-- Ability properties	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.enemy = self:GetParent()		

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.bonus_effects_radius = self.ability:GetSpecialValueFor("bonus_effects_radius")
	self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
	self.bonus_slow_pct = self.ability:GetSpecialValueFor("bonus_slow_pct")
	self.values_increase_distance = self.ability:GetSpecialValueFor("values_increase_distance")
	self.values_increase_pct = self.ability:GetSpecialValueFor("values_increase_pct")			

	self.distance = (self.enemy:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()				
	self.edge_distance = self.radius - self.distance			
	
	-- If enemy is closer than 190 units, set bonuses, otherwise calculate damage scaling with distance.
	if self.distance <= self.bonus_effects_radius then		
		self.earthshock_debuff_slow_pct = self.slow_pct + self.bonus_slow_pct					
	else
		self.scale_increase_for_distance =  math.floor(self.edge_distance / self.values_increase_distance) --how much it should scale
		self.pct_increase_for_distance =  self.values_increase_pct * self.scale_increase_for_distance -- how many percents the scale should go up				
		self.earthshock_debuff_slow_pct = self.slow_pct * (1 + self.pct_increase_for_distance) -- final slow value													
	end	
end

function modifier_imba_earthshock_slow:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_imba_earthshock_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_earthshock_slow:IsDebuff()
	return true
end

function modifier_imba_earthshock_slow:IsHidden()
	return false
end

function modifier_imba_earthshock_slow:IsPurgable()
	return true
end

function modifier_imba_earthshock_slow:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_earthshock_slow:GetModifierMoveSpeedBonus_Percentage()	
	local enemy = self:GetParent()			
	return self.earthshock_debuff_slow_pct * (-1)
end


-- Trembling Steps buff
modifier_imba_trembling_steps_buff = class({})

function modifier_imba_trembling_steps_buff:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_UNIT_MOVED}
		
		return decFuncs	
end


function modifier_imba_trembling_steps_buff:OnUnitMoved()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local sound_step = "Imba.UrsaTremblingSteps"
		local particle_step = "particles/hero/ursa/ursa_trembling_steps_elixir.vpcf"
		local trembling_steps_prevent = "modifier_imba_trembling_steps_prevent"
		local trembling_steps_debuff = "modifier_imba_trembling_steps_debuff"
		
		-- Ability specials
		local base_radius = ability:GetSpecialValueFor("radius")		
		local trembling_steps_duration = ability:GetSpecialValueFor("trembling_steps_duration")
		local trembling_steps_slow_pct = ability:GetSpecialValueFor("trembling_steps_slow_pct")
		local trembling_steps_radius_pct = ability:GetSpecialValueFor("trembling_steps_radius_pct")
		local trembling_steps_damage = ability:GetSpecialValueFor("trembling_steps_damage")
		local trembling_steps_cooldown = ability:GetSpecialValueFor("trembling_steps_cooldown")	
				
		-- Mark last position to find real movements
		if caster.last_position == nil then
			caster.last_position = caster:GetAbsOrigin()
		else
			if caster:GetAbsOrigin() - caster.last_position == Vector(0,0,0) then
				return nil
			else
				caster.last_position = caster:GetAbsOrigin()
			end
		end
		
		-- Check if ursa has prevent modifier, if so, do nothing
		if caster:HasModifier(trembling_steps_prevent) then
			return nil
		end
		
		-- Apply prevent modifier
		caster:AddNewModifier(caster, ability, trembling_steps_prevent, {duration = trembling_steps_cooldown})
		
		-- Calculate radius
		   local radius = base_radius * trembling_steps_radius_pct				
		
		-- Play cast sound
		EmitSoundOn(sound_step, caster)
		
		-- Add particles (edited ones? brewmaster's thunder clap particles, later)
		local particle_step_fx = ParticleManager:CreateParticle(particle_step, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_step_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_step_fx, 1, Vector(1,1,1))
		ParticleManager:ReleaseParticleIndex(particle_step_fx)
		
		-- Find all units in AoE
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		
		for _,enemy in pairs(enemies) do
			-- Damage units
			if not enemy:IsMagicImmune() then
				local damageTable = {victim = enemy,
									attacker = caster,
									damage = trembling_steps_damage,
									damage_type = DAMAGE_TYPE_PHYSICAL,
									ability = ability}
									
				ApplyDamage(damageTable)
			end
			
			-- Apply trembling steps debuff to units
			enemy:AddNewModifier(caster, ability, trembling_steps_debuff, {duration = trembling_steps_duration})
		end
	end	
end

function modifier_imba_trembling_steps_buff:IsDebuff()
	return false
end

function modifier_imba_trembling_steps_buff:IsHidden()
	return false
end

function modifier_imba_trembling_steps_buff:IsPurgable()
	return false
end


-- Trembling Steps prevention modifier
modifier_imba_trembling_steps_prevent = class({})

function modifier_imba_trembling_steps_prevent:IsDebuff()
	return false
end

function modifier_imba_trembling_steps_prevent:IsHidden()
	return true
end

function modifier_imba_trembling_steps_prevent:IsPurgable()
	return false
end

-- Trembling Steps slow debuff
modifier_imba_trembling_steps_debuff = class({})

function modifier_imba_trembling_steps_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_earthshock_modifier.vpcf"
end

function modifier_imba_trembling_steps_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_trembling_steps_debuff:IsDebuff()
	return true
end

function modifier_imba_trembling_steps_debuff:IsHidden()
	return false
end

function modifier_imba_trembling_steps_debuff:IsPurgable()
	return true
end

function modifier_imba_trembling_steps_debuff:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
		
		return decFuncs	
end

function modifier_imba_trembling_steps_debuff:GetModifierMoveSpeedBonus_Percentage()	
	local ability = self:GetAbility()
	local trembling_steps_slow_pct = ability:GetSpecialValueFor("trembling_steps_slow_pct")	
	
	return trembling_steps_slow_pct * (-1)
end





---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Overpower
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_overpower = class({})
LinkLuaModifier("modifier_imba_overpower_buff", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_overpower_disarm", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_overpower:GetAbilityTextureName()
   return "ursa_overpower"
end

function imba_ursa_overpower:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local aspd_buff =  "modifier_imba_overpower_buff"
		local disarm_debuff = "modifier_imba_overpower_disarm"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")
		local enrage_buff = "modifier_imba_enrage_buff"
		local disarm_particle = "particles/hero/ursa/enrage_overpower.vpcf"
		local sound_cast = "Hero_Ursa.Overpower"
		
		-- Ability specials
		local attacks_num = ability:GetSpecialValueFor("attacks_num")
		local aspd_duration = ability:GetSpecialValueFor("aspd_duration")
		local disarm_radius = ability:GetSpecialValueFor("disarm_radius")
		local disarm_duration = ability:GetSpecialValueFor("disarm_duration")
		local enrage_disarm_radius = enrage_ability:GetSpecialValueFor("bonus_radius_skills")		
		
		-- #4 Talent: Additional Overpower attacks		
		attacks_num = attacks_num + caster:FindTalentValue("special_bonus_imba_ursa_4")		
		
		-- #5 Talent: Overpower's Disarm duration increase
		disarm_duration = disarm_duration + caster:FindTalentValue("special_bonus_imba_ursa_5")		
		
		-- #6 Talent: Enrage Earthshock/Overpower radius increase		
		enrage_disarm_radius = enrage_disarm_radius + caster:FindTalentValue("special_bonus_imba_ursa_6")
		
		-- Play cast sound
		EmitSoundOn(sound_cast, caster)
		
		-- Get pissed blyat (thanks again Valve)
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)							
		
		-- Remove existing attack speed buff
		if caster:HasModifier(aspd_buff) then
			caster:RemoveModifierByName(aspd_buff)
		end
		
		-- Apply attack speed buff to caster, add stacks
		caster:AddNewModifier(caster, ability, aspd_buff, {duration = aspd_duration})	
		caster:SetModifierStackCount(aspd_buff, caster, attacks_num)	
		
		-- Increase disarm radius if caster is enraged
		if caster:HasModifier(enrage_buff) then
			disarm_radius = disarm_radius + enrage_disarm_radius
		end
		
		-- Add Disarm particles
		local disarm_particle_fx = ParticleManager:CreateParticle(disarm_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(disarm_particle_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(disarm_particle_fx, 1, Vector(disarm_radius, 0, 0))
		ParticleManager:SetParticleControl(disarm_particle_fx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(disarm_particle_fx)
		
		-- Find enemy units in the AoE
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  disarm_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)
		
		-- Apply Disarm for the duration
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				enemy:AddNewModifier(caster, ability, disarm_debuff, {duration = disarm_duration})
			end
		end
	end
end


-- Overpower attack speed buff
modifier_imba_overpower_buff = class({})

function modifier_imba_overpower_buff:OnCreated()
	local caster = self:GetCaster()
	local target_location = caster:GetAbsOrigin()
	local ursa_overpower_buff_particle = "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"
	
	self.ursa_overpower_buff_particle_fx = ParticleManager:CreateParticle(ursa_overpower_buff_particle, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(self.ursa_overpower_buff_particle_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_head", target_location, true)
	ParticleManager:SetParticleControlEnt(self.ursa_overpower_buff_particle_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
	ParticleManager:SetParticleControlEnt(self.ursa_overpower_buff_particle_fx, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
	ParticleManager:SetParticleControlEnt(self.ursa_overpower_buff_particle_fx, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
end
		
function modifier_imba_overpower_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_overpower_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_imba_overpower_buff:IsDebuff()
	return false
end

function modifier_imba_overpower_buff:IsHidden()
	return false
end

function modifier_imba_overpower_buff:IsPurgable()
	return true
end

function modifier_imba_overpower_buff:StatusEffectPriority()
	return 10
end

function modifier_imba_overpower_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_overpower_buff:DeclareFunctions()		
		local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
						  MODIFIER_EVENT_ON_ATTACK}					 
		return decFuncs		
end

function modifier_imba_overpower_buff:GetModifierAttackSpeedBonus_Constant()	
		local ability = self:GetAbility()
		local attack_speed_bonus = ability:GetSpecialValueFor("attack_speed_bonus")
		
		return attack_speed_bonus	
end

function modifier_imba_overpower_buff:OnAttack( keys )
	local caster = self:GetCaster()

	if keys.attacker == caster then		
		local current_stacks = self:GetStackCount()		

		-- If the attacks came from Starfury's PerformAttacks, do nothing
		if caster:HasModifier("modifier_imba_starfury_dmg_penalty") then
			return nil
		end
		
		if current_stacks > 1 then
			self:DecrementStackCount()
		else	
			self:Destroy()
		end
	end
end
	
function modifier_imba_overpower_buff:OnRemoved()	
	ParticleManager:DestroyParticle( self.ursa_overpower_buff_particle_fx, false )
	ParticleManager:ReleaseParticleIndex(self.ursa_overpower_buff_particle_fx)	
end
-- Overpower disarm debuff
modifier_imba_overpower_disarm = class({})

function modifier_imba_overpower_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_imba_overpower_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_overpower_disarm:IsDebuff()
	return true
end

function modifier_imba_overpower_disarm:IsHidden()
	return false
end

function modifier_imba_overpower_disarm:IsPurgable()
	return true
end

function modifier_imba_overpower_disarm:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	return state
end








---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Fury Swipes
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_fury_swipes = class({})
LinkLuaModifier("modifier_imba_fury_swipes_debuff", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fury_swipes", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_fury_swipes:GetAbilityTextureName()
   return "ursa_fury_swipes"
end

function imba_ursa_fury_swipes:GetIntrinsicModifierName()
	return "modifier_imba_fury_swipes"
end


-- Fury swipes debuff
modifier_imba_fury_swipes_debuff = class({})

function modifier_imba_fury_swipes_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_imba_fury_swipes_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_fury_swipes_debuff:IsDebuff()
	return true
end

function modifier_imba_fury_swipes_debuff:IsHidden()
	return false
end

function modifier_imba_fury_swipes_debuff:IsPurgable()
	return false
end

-- Fury Swipes modifier buff
modifier_imba_fury_swipes = class({})

function modifier_imba_fury_swipes:IsDebuff()
	return false
end

function modifier_imba_fury_swipes:IsHidden()
	return true
end

function modifier_imba_fury_swipes:IsPurgable()
	return false
end

function modifier_imba_fury_swipes:DeclareFunctions()		
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}					 
	return decFuncs		
end

function modifier_imba_fury_swipes:OnAttackLanded( keys )
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local target = keys.target
		local ability = self:GetAbility()
		local swipes_particle = "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"
		local fury_swipes_debuff = "modifier_imba_fury_swipes_debuff"	
		local deep_strike_particle = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf"		
		local sound_deep_strike = "Imba.UrsaDeepStrike"
		local enrage_ability = caster:FindAbilityByName("imba_ursa_enrage")		
		local enrage_buff = "modifier_imba_enrage_buff"
		
		-- Ability specials
		local damage_per_stack = ability:GetSpecialValueFor("damage_per_stack")
		local stack_duration = ability:GetSpecialValueFor("stack_duration")
		local roshan_stack_duration = ability:GetSpecialValueFor("roshan_stack_duration")
		local deep_stack_multiplier = ability:GetSpecialValueFor("deep_stack_multiplier")
		local deep_stack_attacks = ability:GetSpecialValueFor("deep_stack_attacks")
		local enrage_swipes_multiplier = enrage_ability:GetSpecialValueFor("fury_swipes_multiplier")		
		
		-- #2 Talent: Increased Deep Strike multiplier
		deep_stack_multiplier = deep_stack_multiplier + caster:FindTalentValue("special_bonus_imba_ursa_2")

		-- #3 Talent: Increased fury swipes damage
		damage_per_stack = damage_per_stack + caster:FindTalentValue("special_bonus_imba_ursa_3")		
		
		-- If the caster is broken, do nothing
		if caster:PassivesDisabled() then
			return nil
		end
		
		if keys.attacker == caster then	
			-- Adjust duration if target is Roshan
			if IsRoshan(target) then
				stack_duration = roshan_stack_duration
			end

			-- If the target is a building, do nothing
			if target:IsBuilding() then
				return nil
			end
			
			-- Initialize variables
			local fury_swipes_debuff_handler
			local damage
			
			-- Add debuff/increment stacks if already exists
			if target:HasModifier(fury_swipes_debuff) then
				fury_swipes_debuff_handler = target:FindModifierByName(fury_swipes_debuff)
				fury_swipes_debuff_handler:IncrementStackCount()
			else					
				target:AddNewModifier(caster, ability, fury_swipes_debuff, {duration = stack_duration})
				fury_swipes_debuff_handler = target:FindModifierByName(fury_swipes_debuff)
				fury_swipes_debuff_handler:IncrementStackCount()		
			end	
			
			-- Refresh stack duration
			fury_swipes_debuff_handler:ForceRefresh()
			
			-- Add fury swipe impact particle
			local swipes_particle_fx = ParticleManager:CreateParticle(swipes_particle, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(swipes_particle_fx, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(swipes_particle_fx)

			-- Get stack count
			local fury_swipes_stacks = fury_swipes_debuff_handler:GetStackCount()
			
			-- Calculate damage
			damage = damage_per_stack * fury_swipes_stacks
			
			-- Check for Enrage's multiplier
			if caster:HasModifier(enrage_buff) then
				damage = damage * enrage_swipes_multiplier				
			end
			
			-- Check for Deep Strike modifier, modify damage, apply particle and play sound if present
			if fury_swipes_stacks % deep_stack_attacks == 0 then --divides with no remainder
				damage = damage * (deep_stack_multiplier * 0.01)
				
				local deep_strike_particle_fx = ParticleManager:CreateParticle(deep_strike_particle, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 0, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 1, target:GetAbsOrigin())
				ParticleManager:SetParticleControl(deep_strike_particle_fx, 3, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(deep_strike_particle_fx)
				
				EmitSoundOn(sound_deep_strike, caster)
			end
			
			-- Apply additional damage	
			local damageTable = {victim = target,
								attacker = caster,
								damage = damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								ability = ability}
						
			ApplyDamage(damageTable)	
		end
	end
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			       Ursa's Enrage
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_enrage = class({})
LinkLuaModifier("modifier_imba_enrage_buff", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_scepter_enrage_damage", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_scepter_enrage_prevent", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_enrage:GetAbilityTextureName()
   return "ursa_enrage"
end

function imba_ursa_enrage:GetCooldown(level)
	local caster = self:GetCaster()
	local ability = self	
	local scepter = caster:HasScepter()

	local cooldown = self.BaseClass.GetCooldown(self, level)
	local scepter_cooldown = ability:GetSpecialValueFor("scepter_cooldown")
	
	if scepter then
		return scepter_cooldown
	end

	return cooldown	
end

function imba_ursa_enrage:OnUpgrade()
	 local caster = self:GetCaster()
	 local ability = self
	 local enrage_modifier = "modifier_imba_scepter_enrage_damage"
	 
	 if not caster:HasModifier(enrage_modifier) then
		caster:AddNewModifier(caster, ability, enrage_modifier, {})
	 end
end


function imba_ursa_enrage:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	
	EnrageCast(caster, ability)
end

function EnrageCast(caster, ability)

	-- Ability properties
	local sound_cast = "Hero_Ursa.Enrage"	
	local enrage_buff = "modifier_imba_enrage_buff"
	
	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")	
	
	-- Roar, baby, roar. CAUSE CAST ANIMATIONS ARE BROKEN LEL GG VALVE
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	
	-- Apply strong purge
	caster:Purge(false, true, false, true, false) --don't remove buffs, remove debuffs, not only on this frame, purges stuns, don't remove exceptions
	
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	-- Apply enrage buff	
	caster:AddNewModifier(caster, ability, enrage_buff, {duration = duration})

end


-- Enrage active buff
modifier_imba_enrage_buff = class({})

function modifier_imba_enrage_buff:AllowIllusionDuplicate()
	return false
end

function modifier_imba_enrage_buff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

function modifier_imba_enrage_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_enrage_buff:IsDebuff()
	return false
end

function modifier_imba_enrage_buff:IsHidden()
	return false
end

function modifier_imba_enrage_buff:IsPurgable()
	return false
end

function modifier_imba_enrage_buff:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local reduce_cd_interval = ability:GetSpecialValueFor("reduce_cd_interval")
	
	if IsServer() then	
		caster:SetRenderColor(255,0,0)		
	end
	
	self:StartIntervalThink(reduce_cd_interval)
end

function modifier_imba_enrage_buff:OnDestroy()
	local caster = self:GetCaster()	
	
	if IsServer() then
		caster:SetRenderColor(255,255,255)		
	end	
end

function modifier_imba_enrage_buff:OnIntervalThink()
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()	
		local ability_earthshock = caster:FindAbilityByName("imba_ursa_earthshock")
		local ability_overpower = caster:FindAbilityByName("imba_ursa_overpower")	
		
		-- Ability specials
		local reduce_cd_amount = ability:GetSpecialValueFor("reduce_cd_amount")

		-- #8 Talent: Skill's cooldown tick faster when Enrage is active
		reduce_cd_amount = reduce_cd_amount + caster:FindTalentValue("special_bonus_imba_ursa_8")
		
		-- Find current CD of skills, lower it if above reduction, else refresh	it	
		if ability_earthshock then
			local ability_earthshock_cd = ability_earthshock:GetCooldownTimeRemaining()
			ability_earthshock:EndCooldown()					
			if ability_earthshock_cd > reduce_cd_amount then		
				ability_earthshock:StartCooldown(ability_earthshock_cd - reduce_cd_amount)	
			end
		end
		
		if ability_overpower then
			local ability_overpower_cd = ability_overpower:GetCooldownTimeRemaining()
			ability_overpower:EndCooldown()		
			if ability_overpower_cd > reduce_cd_amount then		
				ability_overpower:StartCooldown(ability_overpower_cd - reduce_cd_amount)	
			end
		end
	end
end

function modifier_imba_enrage_buff:DeclareFunctions()		
		local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
						 MODIFIER_PROPERTY_MODEL_SCALE}					 
		return decFuncs		
end

function modifier_imba_enrage_buff:GetModifierModelScale()
	return 40
end


function modifier_imba_enrage_buff:GetModifierIncomingDamage_Percentage()
	local ability = self:GetAbility()
	local damage_reduction = ability:GetSpecialValueFor("damage_reduction") 
	return damage_reduction * (-1)
end


-- Enrage scepter damage counter modifier
modifier_imba_scepter_enrage_damage = class({})

function modifier_imba_scepter_enrage_damage:DeclareFunctions()		
		local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE}					 
		return decFuncs		
end

function modifier_imba_scepter_enrage_damage:IsHidden()
	local caster = self:GetCaster()
	local prevent_modifier = "modifier_imba_scepter_enrage_prevent"
	local scepter = caster:HasScepter()
	
	-- Show the buff only when Ursa doesn't have the prevention modifier
	if not caster:HasModifier(prevent_modifier) and scepter then
		return false
	end
		
	return true
end

function modifier_imba_scepter_enrage_damage:RemoveOnDeath()
	return false
end

function modifier_imba_scepter_enrage_damage:IsPurgable()
	return false
end

function modifier_imba_scepter_enrage_damage:IsDebuff()
	return false
end

function modifier_imba_scepter_enrage_damage:OnTakeDamage( keys )
	-- Ability properties
	local caster = self:GetCaster()
	local target = keys.unit
	local damage_taken = keys.damage	
	local ability = self:GetAbility()
	local scepter = caster:HasScepter()	
	local prevent_modifier = "modifier_imba_scepter_enrage_prevent"
	
	-- Ability specials
	local scepter_damage_threshold = ability:GetSpecialValueFor("scepter_damage_threshold")
	local scepter_damage_reset = ability:GetSpecialValueFor("scepter_damage_reset")
	local scepter_enrage_cooldown = ability:GetSpecialValueFor("scepter_enrage_cooldown")

    -- If Ursa is broken, do nothing: don't count damage, don't trigger, etc)
    if caster:PassivesDisabled() then
        return nil
    end
	
	if scepter and caster == target then			
		-- Initialize if not exists		
		if not caster.scepter_enrage_damage or not caster.scepter_enrage_damage_time then
			caster.scepter_enrage_damage = damage_taken
			caster.scepter_enrage_damage_time = Time()
		else
			-- Check last time Ursa got damaged, reset damage if it's above the reset time
			if  Time() - caster.scepter_enrage_damage_time <= scepter_damage_reset then				
				caster.scepter_enrage_damage = caster.scepter_enrage_damage + damage_taken					
			else				
				caster.scepter_enrage_damage = damage_taken					
			end						
		end		
			
		if caster.scepter_enrage_damage >= scepter_damage_threshold and not caster:HasModifier(prevent_modifier) then
			caster:AddNewModifier(caster, ability, prevent_modifier, {duration = scepter_enrage_cooldown})
			EnrageCast(caster, ability)			
		end
				
		caster.scepter_enrage_damage_time = Time()
	end
end


modifier_imba_scepter_enrage_prevent = class({})

function modifier_imba_scepter_enrage_prevent:IsHidden()
	return false
end

function modifier_imba_scepter_enrage_prevent:IsPurgable()
	return false
end






---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Ursa's Territorial Hunter
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_ursa_territorial_hunter = class({})
LinkLuaModifier("modifier_terrorital_hunter_aura", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorital_hunter_fogvision", "hero/hero_ursa", LUA_MODIFIER_MOTION_NONE)

function imba_ursa_territorial_hunter:GetAbilityTextureName()
   return "custom/territorial_hunter"
end

function imba_ursa_territorial_hunter:IsInnateAbility()
	return true
end

function imba_ursa_territorial_hunter:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local aura = "modifier_terrorital_hunter_aura"
		
		-- Kill previous dummy, if exists
		if ability.territorial_dummy then
			ability.territorial_dummy:Destroy()
		end
		
		ability.territorial_tree = target

		-- Create dummy
		ability.territorial_dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		ability.territorial_dummy:AddRangeIndicator(caster, ability, "vision_range", nil, 200, 160, 100, true, true, false)
		ability.territorial_dummy:AddNewModifier(caster, ability, aura, {})
		ability.territorial_dummy:SetAbsOrigin(ability.territorial_tree:GetAbsOrigin())			 
	end	
end

function imba_ursa_territorial_hunter:GetCooldown(level)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown(self, level)
	return (cooldown - caster:FindTalentValue("special_bonus_imba_ursa_7"))
end

-- Territorial Hunter aura modifier
modifier_terrorital_hunter_aura = class({})

function modifier_terrorital_hunter_aura:OnCreated()
	-- Start interval
	self:StartIntervalThink(0.2)
end

function modifier_terrorital_hunter_aura:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		-- Check if tree is cut down, kill dummy if it is
		if not ability.territorial_tree:IsStanding() then
			ability.territorial_dummy:Destroy()
			ability.territorial_dummy = nil
		end
	end
end

function modifier_terrorital_hunter_aura:OnDestroy()
	self:StartIntervalThink(-1)
end

function modifier_terrorital_hunter_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local vision_range = ability:GetSpecialValueFor("vision_range")
	
	return vision_range
end

function modifier_terrorital_hunter_aura:IsAura()
	return true
end

function modifier_terrorital_hunter_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_terrorital_hunter_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_terrorital_hunter_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_terrorital_hunter_aura:GetModifierAura()
	return "modifier_terrorital_hunter_fogvision"
end

function modifier_terrorital_hunter_aura:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_terrorital_hunter_aura:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

 function modifier_terrorital_hunter_aura:CheckState()
	 local state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	 return state
end

function modifier_terrorital_hunter_aura:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_VISUAL_Z_DELTA}
		
		return decFuncs	
end

function modifier_terrorital_hunter_aura:GetVisualZDelta()
	return 350
end


-- Territorial Hunter debuff
modifier_terrorital_hunter_fogvision = class({})

function modifier_terrorital_hunter_fogvision:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_terrorital_hunter_fogvision:IsHidden()
	return true
end

function modifier_terrorital_hunter_fogvision:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_terrorital_hunter_fogvision:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		AddFOWViewer(caster:GetTeamNumber(), parent:GetAbsOrigin(), 10, FrameTime(), false)
	end
end

































