--[[
Author: sercankd
Date: 06.06.2017
Updated: 17.06.2017
]]

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
	--self.scepter_ms_per_stack = self.ability:GetSpecialValueFor("scepter_ms_per_stack")
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

	--if self.scepter then
	--	move_speed_increase = (self.scepter_ms_per_stack) * stacks				
	--else
		move_speed_increase = (self.ms_per_stack) * stacks					
	--end
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
		duration = duration + caster:FindTalentValue("special_bonus_imba_disruptor_8", "value")

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
		self.strike_interval = self.strike_interval - self.caster:FindTalentValue("special_bonus_imba_disruptor_8", "value2")
			
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
										  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
										  FIND_ANY_ORDER,
										  false)
		
		self.strikes_remaining = #enemies
		
		-- #7 Talent: Heroes within Static Storm are counted twice for Thunder Strike Count.
		if self.caster:HasTalent("special_bonus_imba_disruptor_7") then
		
		local enemies_in_static_storm = 0
		
			for _,enemy in pairs(enemies) do
				if enemy:HasModifier("modifier_imba_static_storm_debuff") then
				-- Add 1 strike count
				enemies_in_static_storm = enemies_in_static_storm + 1
				end
			end
			
			self.strikes_remaining = self.strikes_remaining + enemies_in_static_storm
		end
		
		
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
	local strike_particle = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_bolt.vpcf"
	local aoe_particle = "particles/units/heroes/hero_disruptor/disruptor_thunder_strike_aoe.vpcf"
	local stormbearer_buff = "modifier_imba_stormbearer"
	local scepter = self.caster:HasScepter()
	
	-- Play strike sound
	EmitSoundOn(sound_impact, self.target)

	-- #3 Talent: Thunder Strike has a chance to launch Chain Lightning
	if self.caster:HasTalent("special_bonus_imba_disruptor_3") then 
		if RollPercentage(self.caster:FindTalentValue("special_bonus_imba_disruptor_3")) then		
			LaunchLightning(self.caster, self.target, self.ability, self.damage, self.caster:FindTalentValue("special_bonus_imba_disruptor_3", "bounce_radius"), self.caster:FindTalentValue("special_bonus_imba_disruptor_3", "max_targets"))
		end
	end
	
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

-------------------------------------------
--		Thunder Strike lightning launcher
-------------------------------------------

function LaunchLightning(caster, target, ability, damage, bounce_radius, max_targets)

	-- Parameters
	local targets_hit = { target }
	local search_sources = { target	}
	
	-- Play initial sound
	caster:EmitSound("Item.Maelstrom.Chain_Lightning")

	-- Play first bounce sound
	target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

	-- Zap initial target
	ZapThem(caster, ability, target, target, damage)

	-- While there are potential sources, keep looping
	while #search_sources > 0 do

		-- Loop through every potential source this iteration
		for potential_source_index, potential_source in pairs(search_sources) do
			
			-- Iterate through potential targets near this source
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			local source_removed = false

			for _, potential_target in pairs(nearby_enemies) do
				-- Check if this target was already hit
				local already_hit = false
				for _, hit_target in pairs(targets_hit) do
					if potential_target == hit_target then
						already_hit = true
						break
					end
				end				
				
				-- If not, zap it from this source, and mark it as a hit target and potential future source
				if not already_hit then
				
					ZapThem(caster, ability, potential_source, potential_target, damage)
					targets_hit[#targets_hit+1] = potential_target
					search_sources[#search_sources+1] = potential_target
					
					if #targets_hit == max_targets then
						return
					end
					
					-- On successful hit, delete the potential source and stop the inner loop
					table.remove(search_sources, potential_source_index)
					source_removed = true
					break
				end
			end

			if not source_removed then
				-- Remove this potential source
				table.remove(search_sources, potential_source_index)
			end
		end
	end
end

-- One bounce. Particle + damage
function ZapThem(caster, ability, source, target, damage)

	-- Draw particle
	local bounce_pfx = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
	ParticleManager:ReleaseParticleIndex(bounce_pfx)
	
	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	
end

------------------------------------------------------------------------------------------------------

---------------------------------------------------
--				Glimpse
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_glimpse_thinker"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_movement_check_aura"] = LUA_MODIFIER_MOTION_NONE,	
	["modifier_imba_glimpse_storm_aura"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_glimpse_storm_debuff"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_glimpse_talent_indicator"] = LUA_MODIFIER_MOTION_NONE,
})

imba_disruptor_glimpse = imba_disruptor_glimpse or class({})

function imba_disruptor_glimpse:GetCastRange(location, target)
    return self:GetSpecialValueFor("cast_range") + self:GetCaster():FindTalentValue("special_bonus_imba_disruptor_9")
end

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
		
		local thinker = CreateModifierThinker(caster, ability, "modifier_imba_glimpse_thinker", {}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)	
		local thinkerBuff = thinker:FindModifierByName("modifier_imba_glimpse_thinker")
		local buff = target:FindModifierByName("modifier_imba_glimpse")
		if buff then		
			EmitSoundOn(cast_sound, target)	
            thinkerBuff:BeginGlimpse(target, buff:GetOldestPosition())
		end		
	end
end

-------------------------------------------
--	Glimpse Thinker
-------------------------------------------
modifier_imba_glimpse_thinker = class({})

function modifier_imba_glimpse_thinker:IsHidden()
	return false
end

function modifier_imba_glimpse_thinker:IsPurgable()
	return true
end

function modifier_imba_glimpse_thinker:OnCreated( kv )
	if IsServer() then		
        -- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
        self.modifier_storm = "modifier_imba_glimpse_storm_aura"

        -- Ability specials
		self.move_delay = self.ability:GetSpecialValueFor("move_delay")		
		self.projectile_speed = self.ability:GetSpecialValueFor("projectile_speed")
        self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
        self.vision_duration = self.ability:GetSpecialValueFor("vision_duration")		
        self.storm_duration = self.ability:GetSpecialValueFor("storm_duration")
	end
end

function modifier_imba_glimpse_thinker:BeginGlimpse(target, old_position)
	if IsServer() then				
		local hUnit = target
		local vOldLocation = old_position
		if hUnit and vOldLocation then
			local vVelocity = ( vOldLocation - hUnit:GetOrigin())
			vVelocity.z = 0.0

			local flDist = vVelocity:Length2D()
			vVelocity = vVelocity:Normalized()

			local flDuration = math.max(0.05, math.min(self.move_delay, flDist / self.projectile_speed))
			
			local projectile =
			{
                Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf",
				vSpawnOrigin = hUnit:GetOrigin(), 
                fDistance = flDist,
				Source = self:GetCaster(),                				
				vVelocity = vVelocity * ( flDist / flDuration ),
				fStartRadius = 0,
                fEndRadius = 0,				
				bProvidesVision = true,
				iVisionRadius = self.vision_radius,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			}			  

            ProjectileManager:CreateLinearProjectile(projectile)                      

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, vOldLocation )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex, false, false, -1, false, false )

			local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 1, vOldLocation )
			ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex2, false, false, -1, false, false )

			local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex3, 0, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex3, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex3, false, false, -1, false, false )
			
			EmitSoundOnLocationForAllies( vOldLocation, "Hero_Disruptor.GlimpseNB2017.Destination", self:GetCaster() )
			local buff = hUnit:FindModifierByName( "modifier_imba_glimpse" )
			if buff then
				buff.hThinker = self						
                buff:SetGlimpsePosition(old_position)
				buff:SetExpireTime( GameRules:GetGameTime() + flDuration )						                    
			end			
		end		
	end
end

function modifier_imba_glimpse_thinker:EndGlimpse(caster, ability, hUnit, old_position)	
	if hUnit and not hUnit:IsMagicImmune() then

		AddFOWViewer(caster:GetTeamNumber(), old_position, self.vision_radius, self.vision_duration, false)
		FindClearSpaceForUnit( hUnit, old_position, true)
		hUnit:Interrupt()
		
		-- #5 Talent: Glimpse into Kinetic Field expands Glimpse Storm inside the Kinetic Field
		-- Check if the target is glimpsed into Kinetic Field
		if caster:HasTalent("special_bonus_imba_disruptor_5") then
			hUnit:AddNewModifier(caster, ability, "modifier_glimpse_talent_indicator", {duration = 0.1})
		end
		
		-- Wait a game tick so we can check for the modifier
		Timers:CreateTimer(FrameTime(), function()  
		-- If caster has #5 talent and target is teleported into a Kinetic Field, do nothing, another Glimpse Storm is created by Kinetic Field.
		if hUnit:HasModifier("modifier_imba_kinetic_field_check_inside_field") then
		else
		-- Create a Glimpse Storm thinker
		self.storm_radius = ability:GetSpecialValueFor("storm_radius")
		CreateModifierThinker(caster, ability, self.modifier_storm, {duration = self.storm_duration, storm_radius = self.storm_radius}, old_position, caster:GetTeamNumber(), false) 
		end
		end)
		
        self:Destroy()		    	    		
	end
end

modifier_glimpse_talent_indicator = class({})

function modifier_glimpse_talent_indicator:IsHidden()
	return true
end

function modifier_glimpse_talent_indicator:IsPurgable()
	return false
end

-------------------------------------------
--	Glimpse Aura
-------------------------------------------

modifier_imba_glimpse_movement_check_aura = modifier_imba_glimpse_movement_check_aura or class({})

function modifier_imba_glimpse_movement_check_aura:IsHidden()	return true end
function modifier_imba_glimpse_movement_check_aura:IsPassive()	return true end
function modifier_imba_glimpse_movement_check_aura:IsAura() return true end
function modifier_imba_glimpse_movement_check_aura:IsAuraActiveOnDeath() return true end
function modifier_imba_glimpse_movement_check_aura:GetAuraRadius() 	return self:GetAbility():GetSpecialValueFor("global_radius") end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_glimpse_movement_check_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end

function modifier_imba_glimpse_movement_check_aura:GetModifierAura()
	return "modifier_imba_glimpse"
end

-------------------------------------------
--	Glimpse Movement checker
-------------------------------------------
modifier_imba_glimpse = class({})

function modifier_imba_glimpse:IsHidden()
	return true
end

function modifier_imba_glimpse:IsPurgable()
	return true
end

function modifier_imba_glimpse:OnCreated( kv )
	if IsServer() then	
		self.backtrack_time = self:GetAbility():GetSpecialValueFor("backtrack_time")
        self.interval = 0.1
        self.possible_positions = self.backtrack_time / 0.1

		self.vPositions = {}
		for i = 1, self.possible_positions do
			table.insert(self.vPositions, self:GetParent():GetOrigin())
		end

		self.flExpireTime = -1
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_glimpse:OnIntervalThink()
	if IsServer() then
		if self.flExpireTime ~= -1 and GameRules:GetGameTime() > self.flExpireTime then
			if self.hThinker then
				self.hThinker:EndGlimpse(self:GetCaster(), self:GetAbility(), self:GetParent(), self.glimpse_position)
			end
			self.flExpireTime = -1
			self.hThinker = nil
		end

		for i = 1, #self.vPositions-1 do
			self.vPositions[i] = self.vPositions[i+1]
		end

		self.vPositions[ #self.vPositions ] = self:GetParent():GetOrigin()
	end
end

function modifier_imba_glimpse:GetOldestPosition()
	return self.vPositions[1]
end

function modifier_imba_glimpse:SetExpireTime( flTime )
	if IsServer() then
		self.flExpireTime = flTime
	end
end

function modifier_imba_glimpse:SetGlimpsePosition(old_position)
    self.glimpse_position = old_position
end


------------------------------------------------------------------------------------------------------


-------------------------------------------
--  Glimpse storm aura
-------------------------------------------

modifier_imba_glimpse_storm_aura = modifier_imba_glimpse_storm_aura or class({})

function modifier_imba_glimpse_storm_aura:OnCreated(keys)
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        self.parent_pos = self.parent:GetAbsOrigin()
        self.storm_particle = "particles/hero/disruptor/disruptor_static_storm.vpcf"
        self.sound_storm = "Hero_Disruptor.StaticStorm"
        self.sound_storm_end = "Hero_Disruptor.StaticStorm.End"        

        -- Ability specials
        self.storm_linger = self.ability:GetSpecialValueFor("storm_linger") 
		self.storm_radius = keys.storm_radius
		self.original_radius = self.ability:GetSpecialValueFor("storm_radius") 
        self.storm_duration = self.ability:GetSpecialValueFor("storm_duration")

		-- Setting the model scale according to its radius
		if self.storm_radius > self.original_radius then
		self.scale_factor = 1 + self.storm_radius / self.original_radius
		end
		
        -- Create storm effects
        local storm_particle = ParticleManager:CreateParticle(self.storm_particle, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(storm_particle, 0, self.parent_pos)
		ParticleManager:SetParticleControl(storm_particle, 1, Vector(10,10,10))
        ParticleManager:SetParticleControl(storm_particle, 2, Vector(self.storm_duration,1,1))
        self:AddParticle(storm_particle, false, false, -1, false, false)
		
        -- Create secondary storm fx to indicate the expanded radius of the storm
		if self.storm_radius > self.original_radius then
		local storm_particle_second = ParticleManager:CreateParticle(self.storm_particle, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(storm_particle_second, 0, self.parent_pos)
        ParticleManager:SetParticleControl(storm_particle_second, 1, Vector(10*self.scale_factor,10*self.scale_factor,10*self.scale_factor))
		ParticleManager:SetParticleControl(storm_particle_second, 2, Vector(self.storm_duration,1,1))
        self:AddParticle(storm_particle_second, false, false, -1, false, false)
		end
		
        -- Play storm sound
        EmitSoundOn(self.sound_storm, self.parent)        
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

function modifier_imba_glimpse_storm_aura:OnRemoved()
    if IsServer() then
        -- Stop storm sound
        StopSoundOn(self.sound_storm, self.parent)

        -- Play end sound
        EmitSoundOnLocationWithCaster(self.parent_pos, self.sound_storm_end, nil)
    end
end

function modifier_imba_glimpse_storm_aura:IsAura()  return true end

function modifier_imba_glimpse_storm_aura:IsHidden()    return true end

function modifier_imba_glimpse_storm_aura:IsPurgable()  return false end

function modifier_imba_glimpse_storm_aura:AllowIllusionDuplicate()  return false end

-------------------------------------------
--  Glimpse storm aura debuff
-------------------------------------------

modifier_imba_glimpse_storm_debuff = modifier_imba_glimpse_storm_debuff or class({})

function modifier_imba_glimpse_storm_debuff:OnCreated() 
    -- Ability properties
    self.target = self:GetParent()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()    

    -- Ability specials
	self.storm_damage = self.ability:GetSpecialValueFor("storm_damage")
    self.storm_interval = self.ability:GetSpecialValueFor("storm_interval")
	self.stormbearer_buff = "modifier_imba_stormbearer"
    
    -- Start thinking
    self:StartIntervalThink(self.storm_interval)    
end

function modifier_imba_glimpse_storm_debuff:IsDebuff()  return true end

function modifier_imba_glimpse_storm_debuff:IsHidden()  return false end

function modifier_imba_glimpse_storm_debuff:IsPurgable()    return false end

function modifier_imba_glimpse_storm_debuff:OnDestroy() self:StartIntervalThink(-1) end

function modifier_imba_glimpse_storm_debuff:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_imba_glimpse_storm_debuff:GetEffectAttachType()   return PATTACH_OVERHEAD_FOLLOW end

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
    local state = {[MODIFIER_STATE_SILENCED] = true}     
    return state    
end

---------------------------------------------------
--				Kinetic Field
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_kinetic_field"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_check_position"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_barrier"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_knockback"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_pull"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_kinetic_field_check_inside_field"] = LUA_MODIFIER_MOTION_NONE,
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
		local modifier_kinetic_field = "modifier_imba_kinetic_field"

		-- Ability specials
		local formation_delay = ability:GetSpecialValueFor("formation_delay")
		local field_radius = ability:GetSpecialValueFor("field_radius")
		local duration = ability:GetSpecialValueFor("duration")
		local vision_aoe = ability:GetSpecialValueFor("vision_aoe")
		
		if caster:HasTalent("special_bonus_imba_disruptor_10") then
			formation_delay = formation_delay * caster:FindTalentValue("special_bonus_imba_disruptor_10")
		end
		
		-- Roll for cast response
		if RollPercentage(50) then
			EmitSoundOn(cast_response, caster)
		end

		-- Plays the formation sound
		EmitSoundOn(kinetic_field_sound, caster)

		-- Formation particle
		local formation_particle_fx = ParticleManager:CreateParticle(formation_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(formation_particle_fx, 0, target_point)
		ParticleManager:SetParticleControl(formation_particle_fx, 1, Vector(field_radius, 1, 0))
		ParticleManager:SetParticleControl(formation_particle_fx, 2, Vector(formation_delay, 0, 0))
		ParticleManager:SetParticleControl(formation_particle_fx, 4, Vector(1, 1, 1))
		ParticleManager:SetParticleControl(formation_particle_fx, 15, target_point)           		

		-- Wait for formation to finish setting up
		Timers:CreateTimer(formation_delay, function()

			-- Apply thinker modifier on target location
			CreateModifierThinker(caster, ability, modifier_kinetic_field, {duration = duration, target_point_x = target_point.x, target_point_y = target_point.y, target_point_z = target_point.z, formation_particle_fx = formation_particle_fx}, target_point, caster:GetTeamNumber(), false)
		end)
	end
end

---------------------------------------------------
--				Kinetic Field modifier
---------------------------------------------------
modifier_imba_kinetic_field = modifier_imba_kinetic_field or class({})

function modifier_imba_kinetic_field:IsHidden()	return true end
function modifier_imba_kinetic_field:IsPassive() return true end

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
		
		self.field_particle = ParticleManager:CreateParticle(particle_field, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.field_particle, 0, self.target_point)
		ParticleManager:SetParticleControl(self.field_particle, 1, Vector(self.field_radius, 1, 1))
		ParticleManager:SetParticleControl(self.field_particle, 2, Vector(self.duration, 0, 0))
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_kinetic_field:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local ability = self:GetAbility()
		local kinetic_field_sound_end = "Hero_Disruptor.KineticField.End"
		ParticleManager:DestroyParticle(self.field_particle, true)
        ParticleManager:ReleaseParticleIndex(self.field_particle)
		StopSoundEvent(self.sound_cast, caster)
	end
end

function modifier_imba_kinetic_field:OnIntervalThink()
	local enemies_in_field = FindUnitsInRadius(self.caster:GetTeamNumber(),
									self.target_point,
									nil,
									self.field_radius + 200,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
	for _,enemy in pairs(enemies_in_field) do
		enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_kinetic_field_check_position", {duration = self:GetRemainingTime(), target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})
	end
	
	-- #5 Talent: Glimpse into Kinetic Field expands Glimpse Storm inside the Kinetic Field
	if self.caster:HasTalent("special_bonus_imba_disruptor_5") then
	
		-- Scan and indicator for all enemies in the field, preventing Glimpse from generate the original storm
		local enemies_inside_field = FindUnitsInRadius(self.caster:GetTeamNumber(),
									self.target_point,
									nil,
									self.field_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)
		for _,enemy_in_field in pairs(enemies_inside_field) do
		
			enemy_in_field:AddNewModifier(self.caster, self.ability, "modifier_imba_kinetic_field_check_inside_field", {duration = 0.01})
			
			-- Check if the target is Glimpsed into here.
			if enemy_in_field:HasModifier("modifier_glimpse_talent_indicator") then
			
				-- Get Glimpse's ability specials
				glimpse_ability = self.caster:FindAbilityByName("imba_disruptor_glimpse")
				self.storm_radius = glimpse_ability:GetSpecialValueFor("storm_radius")		
				self.storm_duration = glimpse_ability:GetSpecialValueFor("storm_duration")
				self.modifier_storm = "modifier_imba_glimpse_storm_aura"
				
				-- Get the enemy's vector where the storm is generated.
				enemy_origin = enemy_in_field:GetAbsOrigin()
				
				-- Simple methemethecs
				self.distance = (enemy_origin - self.target_point):Length2D()
				self.storm_overlap_radius = self.storm_radius - self.field_radius
			
				-- If the distance is more than the overlap radius, create the storm with a new radius
				if self.distance >= self.storm_overlap_radius then
					-- New radius = Kinetic Field radius + distance
					self.storm_radius = self.field_radius + self.distance
				else
					-- Give it a condition for generating secondary Glimpse Storm
					self.storm_radius = self.storm_radius + 1
				end
			
				-- Here comes the Storm!
				CreateModifierThinker(self.caster, glimpse_ability, self.modifier_storm, {duration = self.storm_duration, storm_radius = self.storm_radius}, enemy_origin, self.caster:GetTeamNumber(), false) 
		
				-- Remove the indicator from the target
				enemy_in_field:RemoveModifierByName("modifier_glimpse_talent_indicator")
			end
		end
	end
end

modifier_imba_kinetic_field_check_inside_field = modifier_imba_kinetic_field_check_inside_field or class({})

function modifier_imba_kinetic_field_check_inside_field:IsHidden()	return true end

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
	if distance_from_border < 0 and math.abs(distance_from_border) <= 50 then
		target:AddNewModifier(caster, ability, modifier_barrier, {})
		target:AddNewModifier(caster, ability, "modifier_imba_kinetic_field_pull", {duration = 0.5, target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})

	-- Checks if the target is outside the field,
	elseif distance_from_border > 0 and math.abs(distance_from_border) <= 60 then
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
				
				IncrementStormbearerStacks(caster, ability:GetSpecialValueFor("stormbearer_stack_amount"))
			else
				damageTable = {
				victim = target,
				attacker = caster,
				damage = edge_damage_creep,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = ability
				}
			end
		if not target:HasModifier("modifier_imba_kinetic_field_knockback") or not target:HasModifier("modifier_imba_kinetic_field_pull") then
			ApplyDamage(damageTable)
		end
		-- reduce ability cooldown everytime a player touch the barrier
		if not kinetic_recharge and target:IsRealHero() then
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

function modifier_imba_kinetic_field_knockback:CheckState()
    local state = 
	{
		[MODIFIER_STATE_STUNNED] = IsServer()
	}
    return state
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

function modifier_imba_kinetic_field_pull:CheckState()
    local state = 
	{
		[MODIFIER_STATE_STUNNED] = IsServer()
	}
    return state
end
---------------------------------------------------
--			Static Storm
---------------------------------------------------

MergeTables(LinkedModifiers,{
	["modifier_imba_static_storm"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff_aura"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_debuff_linger"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_talent"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_talent_ministun"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_static_storm_talent_ministun_trigger"] = LUA_MODIFIER_MOTION_NONE,
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
		
		
		
		
		--Who's that poke'mon?
		local pikachu_probability = 10
		
		if RollPercentage(pikachu_probability) then
			--PIKACHUUUUUUUUUU
			EmitSoundOn("Imba.DisruptorPikachu", caster)
		elseif RollPercentage(65) then
			--It's....just disruptor
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
		self.particle_storm = "particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf"

		EmitSoundOn(self.sound_cast, self.caster)

		self.particle_storm_fx = ParticleManager:CreateParticle(self.particle_storm, PATTACH_WORLDORIGIN, self.caster)
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

		self.max_damage = self.max_damage
		self.scepter_max_damage = self.scepter_max_damage
		
		self.damage_increase_pulse = self.damage_increase_pulse
			
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
		
		-- Bootleg check for allowing longer particle effects
		self.particle_timer = 0

		CreateModifierThinker(self.caster, self.ability, self.debuff_aura, {duration = self.duration}, self.target_point, self.caster:GetTeamNumber(), false)
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_static_storm:OnIntervalThink()

	self.particle_timer = self.particle_timer + self.interval
	
	if self.particle_timer >= 7 then -- seems like default particle duration?
		-- Destroy and recreate
		--ParticleManager:DestroyParticle(self.particle_storm_fx, false)
		self.particle_storm_fx = ParticleManager:CreateParticle(self.particle_storm, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 0,self.target_point)
		ParticleManager:SetParticleControl(self.particle_storm_fx, 1, Vector(self.radius, 0, 0))
		ParticleManager:SetParticleControl(self.particle_storm_fx, 2, Vector(self.duration, 0, 0))
		self.particle_timer = 0
	end

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
			
			-- #6 Talent: Units exiting Static Storm gets electrocuted
			if self.caster:HasTalent("special_bonus_imba_disruptor_6") then
				if (not enemy:HasModifier("modifier_imba_static_storm_talent")) then
				enemy:AddNewModifier(self.caster,self.ability,"modifier_imba_static_storm_talent",{})
				end
			end
			
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
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_disruptor", MotionController)
end

---------------------------------------------------
--	Static Storm talent ministun debuff ("special_bonus_imba_disruptor_6")
---------------------------------------------------

modifier_imba_static_storm_talent = modifier_imba_static_storm_talent or class({})

function modifier_imba_static_storm_talent:IsHidden()	return false end
function modifier_imba_static_storm_talent:IsDebuff() return true end
function modifier_imba_static_storm_talent:IsPurgable() return false end

function modifier_imba_static_storm_talent:OnCreated()
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:StartIntervalThink(self.caster:FindTalentValue("special_bonus_imba_disruptor_6"))
end

function modifier_imba_static_storm_talent:OnIntervalThink()
	if not IsServer() then return end
	self.stack_count = self:GetStackCount()
	if self.parent:HasModifier("modifier_imba_static_storm_debuff") then
		self:IncrementStackCount()
	else
		self:Destroy()
	end
end

function modifier_imba_static_storm_talent:OnDestroy()
	if not IsServer() then return end
	if self.stack_count == nil then
		return nil
	end	
	if self.stack_count > 0 then
		self.duration = self.caster:FindTalentValue("special_bonus_imba_disruptor_6","interval") * self.stack_count
		modifier_talent_stun = self.parent:AddNewModifier(self.caster,self.ability,"modifier_imba_static_storm_talent_ministun",{duration = self.duration})
	
		if modifier_talent_stun then
		modifier_talent_stun:SetStackCount(self.stack_count)
		end
	else
		return nil
	end
end

modifier_imba_static_storm_talent_ministun = modifier_imba_static_storm_talent_ministun or class({})

function modifier_imba_static_storm_talent_ministun:IsHidden()	return false end
function modifier_imba_static_storm_talent_ministun:IsDebuff() return true end
function modifier_imba_static_storm_talent_ministun:IsPurgable() return false end

function modifier_imba_static_storm_talent_ministun:OnCreated()
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self:StartIntervalThink(self.caster:FindTalentValue("special_bonus_imba_disruptor_6","interval"))
end

function modifier_imba_static_storm_talent_ministun:OnIntervalThink()
	if not IsServer() then return end
	if self:GetStackCount() > 1 then
		self:DecrementStackCount()
	else
		self:Destroy()
	end

	self.parent:AddNewModifier(self.caster,self.parent,"modifier_imba_static_storm_talent_ministun_trigger",{duration = self.caster:FindTalentValue("special_bonus_imba_disruptor_6","stun_duration")})
end

modifier_imba_static_storm_talent_ministun_trigger = modifier_imba_static_storm_talent_ministun_trigger or class({})

function modifier_imba_static_storm_talent_ministun_trigger:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_static_storm_talent_ministun_trigger:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_static_storm_talent_ministun_trigger:CheckState()	
			local state = {[MODIFIER_STATE_STUNNED] = true}
			return state	
end

function modifier_imba_static_storm_talent_ministun_trigger:IsDebuff()
	return true
end

function modifier_imba_static_storm_talent_ministun_trigger:IsStunDebuff()
	return true
end

function modifier_imba_static_storm_talent_ministun_trigger:IsHidden()
	return true
end

-- Client-side helper functions --

LinkLuaModifier("modifier_special_bonus_imba_disruptor_9", "components/abilities/heroes/hero_disruptor", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_disruptor_9 = class({})
function modifier_special_bonus_imba_disruptor_9:IsHidden() 		return true end
function modifier_special_bonus_imba_disruptor_9:IsPurgable() 		return false end
function modifier_special_bonus_imba_disruptor_9:RemoveOnDeath() 	return false end

function imba_disruptor_glimpse:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_disruptor_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_disruptor_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_disruptor_9", {})
	end
end
