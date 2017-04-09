--[[	Broccoli
		Date: 24.03.2017.			]]

-- Copy shallow copy given input
function ShallowCopy(orig)
    local copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    return copy
end

-- Base local ability to be used for fire breath and ice breath
local base_ability_dual_breath = class({})

function base_ability_dual_breath:GetCastRange(Location, Target)
	if IsServer() then
		return 0
	else
		-- #1 Talent: Dual Breath Range Increase
		return self:GetSpecialValueFor("range") + self:GetCaster():FindTalentValue("special_bonus_imba_jakiro_1")
	end
end

function base_ability_dual_breath:OnUpgrade()

	if IsServer() then
		local caster = self:GetCaster()
		-- Do not switch dual breath abilities if it is a stolen spell
		if IsStolenSpell(caster) then
			return nil
		end

		local ability_other_breath_name = self.ability_other_breath_name

		if not ability_other_breath_name then
			return nil
		end

		-- Prevent dead lock updating each other
		local ability_level = self:GetLevel()
		if not caster.breath_level or caster.breath_level ~= ability_level then
			caster.breath_level = ability_level
			SetAbilityLevelIfPresent(caster, ability_other_breath_name, ability_level)
		end
	end
	
end

function base_ability_dual_breath:OnSpellStart()

	if IsServer() then
		local caster = self:GetCaster()

		caster:EmitSound("Hero_Jakiro.DualBreath")
		caster:AddNewModifier(caster, self, self.modifier_caster_name, {})
	end
end

-- Base dual breath modifier to be placed on caster. This modifier makes the hero fly forward while applying damage in an AOE
local base_modifier_dual_breath_caster = class({
	IsHidden 						= function(self) return true end,
	IsPurgable 						= function(self) return false end,
	IsDebuff 						= function(self) return false end,
	RemoveOnDeath 					= function(self) return true end,
	AllowIllusionDuplicate			= function(self) return false end,
	GetOverrideAnimation 			= function(self) return ACT_DOTA_FLAIL end,
	GetActivityTranslationModifiers = function(self) return "forcestaff_friendly" end,
	GetOverrideAnimationRate 		= function(self) return 0.5 end,
	GetModifierDisableTurning 		= function(self) return 1 end -- Disable turning during flying animation
})

function base_modifier_dual_breath_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS 
	}
 
	return funcs
end

function base_modifier_dual_breath_caster:OnCreated( kv )

	if IsServer() then

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		else

			local caster = self:GetCaster()
			local ability = self:GetAbility()
			local caster_pos = caster:GetAbsOrigin()
			local ability_level = ability:GetLevel() - 1
			local target = ability:GetCursorPosition()
			-- #1 Talent: Dual Breath Range Increase
			local range = ability:GetSpecialValueFor("range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_imba_jakiro_1")
			local particle_breath = self.particle_breath

			self.caster = caster
			self.ability = ability
			self.path_radius = ability:GetSpecialValueFor("path_radius")
			self.debuff_duration = ability:GetSpecialValueFor("duration")

			local caster_pos = caster:GetAbsOrigin()
			local breath_direction = ( target - caster_pos ):Normalized()
			local breath_distance = ( target - caster_pos ):Length2D()
			if breath_distance > range then
				breath_distance = range
			end

			-- #6 Talent: Dual Breath Speed Increase
			local breath_speed = ability:GetLevelSpecialValueFor("speed", ability_level) + caster:FindTalentValue("special_bonus_imba_jakiro_6")
			
			-- Ability variables
			self.breath_direction = breath_direction
			self.breath_distance = breath_distance
			-- Tick rate is 30 per sec
			self.breath_speed = breath_speed * 1/30
			self.breath_traveled = 0
			self.affected_unit_list = {}
			
			-- Destroy existing particle if it exist
			if self.existing_breath_particle then
				local destroy_existing_breath_particle = self.existing_breath_particle
				-- Delay before destroying particle
				Timers:CreateTimer(0.4, function()
					ParticleManager:DestroyParticle(destroy_existing_breath_particle, false)
					ParticleManager:ReleaseParticleIndex( destroy_existing_breath_particle )
				end)
			end

			-- Create breath particle
			local breath_pfx = ParticleManager:CreateParticle(particle_breath, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(breath_pfx, 0, caster_pos )
			ParticleManager:SetParticleControl(breath_pfx, 1, breath_direction * breath_speed)
			ParticleManager:SetParticleControl(breath_pfx, 3, Vector(0,0,0) )
			ParticleManager:SetParticleControl(breath_pfx, 9, caster_pos )

			self.existing_breath_particle = breath_pfx
		end

	end
end

function base_modifier_dual_breath_caster:_DualBreathApplyModifier( radius )
	
	local caster = self.caster
	local ability = self.ability
	
	local affected_unit_list = self.affected_unit_list
	local debuff_duration = self.debuff_duration
	local modifier_debuff_name = self.modifier_debuff_name

	local caster_pos = caster:GetAbsOrigin()

	local target_vector = caster_pos + ( self.breath_direction * radius ) / 2

	-- Apply Breath modifier on enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_vector, nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		--Apply Debuff only once per unit
		if not affected_unit_list[enemy] then
			affected_unit_list[enemy] = true
			enemy:AddNewModifier(caster, ability, modifier_debuff_name, { duration = debuff_duration })
		end
	end

	-- Destroy trees
	GridNav:DestroyTreesAroundPoint(target_vector, radius, false)
end


function base_modifier_dual_breath_caster:UpdateHorizontalMotion()

	if IsServer() then
		local caster = self.caster
		local ability = self.ability
		local breath_speed = self.breath_speed
		local breath_traveled = self.breath_traveled

		if breath_traveled < self.breath_distance and not IsHardDisabled(caster) then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + self.breath_direction * breath_speed)
			self.breath_traveled = breath_traveled + breath_speed

			self:_DualBreathApplyModifier( self.path_radius )
		else
			caster:InterruptMotionControllers( true )
			if not IsStolenSpell(caster) then
				-- Switch breath abilities if spell is not stolen
				caster:SwapAbilities(ability:GetAbilityName(), self.ability_other_breath_name, false, true)
			end

			-- Apply debuff modifier in spill_radius
			self:_DualBreathApplyModifier( ability:GetSpecialValueFor("spill_radius") )

			self:Destroy()
		end
	end
end

function base_modifier_dual_breath_caster:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
 
	return state
end

function base_modifier_dual_breath_caster:OnHorizontalMotionInterrupted()

	-- Destroy breath particle when motion interrupted
	if self.existing_breath_particle then
		local destroy_existing_breath_particle = self.existing_breath_particle
		self.existing_breath_particle = nil
		-- Delay before destroying particle
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(destroy_existing_breath_particle, false)
			ParticleManager:ReleaseParticleIndex( destroy_existing_breath_particle )
		end)
	end

	self:Destroy()
end

-- Base DOT (Damage Over Time) debuff class
local base_modifier_dot_debuff = class({
	IsHidden		= function(self) return false end,
	IsPurgable	  	= function(self) return true end,
	IsDebuff	  	= function(self) return true end
})

-- _UpdateDebuffLevelValues is called in OnCreated and OnRefreshed to handle ability values that changes with level or talents
function base_modifier_dot_debuff:_UpdateDebuffLevelValues()
	local ability = self.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	self.tick_damage = damage * self.damage_interval

	-- _UpdateSubClassLevelValues is to be implemented by inherit classes to perform ability value update in OnCreated and OnRefreshed
	if self._UpdateSubClassLevelValues then
		self:_UpdateSubClassLevelValues()
	end
end

function base_modifier_dot_debuff:OnCreated()
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.parent 			= self:GetParent()

		local ability 			= self:GetAbility()
		local damage_interval 	= ability:GetSpecialValueFor("damage_interval")

		self.ability 			= ability
		self.ability_dmg_type 	= ability:GetAbilityDamageType()
		self.damage_interval	= damage_interval

		-- _SubClassOnCreated is to implemented by inherit class to perform attaching ability value in OnCreated
		if self._SubClassOnCreated then
			self:_SubClassOnCreated()
		end

		self:_UpdateDebuffLevelValues()

		-- Apply damage immediately
		self:OnIntervalThink()
		-- Run interval applying of damage
		self:StartIntervalThink(damage_interval)
	end
end

function base_modifier_dot_debuff:OnRefresh()
	if IsServer() then
		self:_UpdateDebuffLevelValues()
	end
end

function base_modifier_dot_debuff:OnIntervalThink()
	if IsServer() then
		local caster = self.caster
		local victim = self.parent

		local final_tick_damage = self.tick_damage

		-- Ice Path Antipode Effect
		if victim:FindModifierByNameAndCaster("modifier_imba_ice_path_freeze_debuff", caster) then
			local ability_ice_path = caster:FindAbilityByName("imba_jakiro_ice_path")
			if ability_ice_path then
				local ability_level = ability_ice_path:GetLevel() - 1
				-- #7 Talent: Ice Path Antipode Effect Increase
				local dmg_amp = ability_ice_path:GetLevelSpecialValueFor("dmg_amp", ability_level) + caster:FindTalentValue("special_bonus_imba_jakiro_7")
				final_tick_damage = final_tick_damage * ( 1 + dmg_amp/100 )
			end
		end

		ApplyDamage({attacker = caster, victim = victim, ability = self.ability, damage = final_tick_damage, damage_type = self.ability_dmg_type })
	end
end

CreateEmptyTalents("jakiro")

-----------------------------
--		Fire Breath        --
-----------------------------
-- Extend base_ability_dual_breath
imba_jakiro_fire_breath = ShallowCopy( base_ability_dual_breath )
imba_jakiro_fire_breath.ability_other_breath_name = "imba_jakiro_ice_breath"
imba_jakiro_fire_breath.modifier_caster_name = "modifier_imba_fire_breath_caster"
LinkLuaModifier("modifier_imba_fire_breath_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fire_breath_caster", "hero/hero_jakiro", LUA_MODIFIER_MOTION_HORIZONTAL)

function imba_jakiro_fire_breath:GetTexture()
	return "custom/jakiro_fire_breath"
end

-- Fire breath debuff (applied to enemies to deal damage)
-- Extend base_modifier_dot_debuff
modifier_imba_fire_breath_debuff = ShallowCopy( base_modifier_dot_debuff )

-- Override _UpdateDebuffLevelValues due to talent
function modifier_imba_fire_breath_debuff:_UpdateDebuffLevelValues()
	local caster = self.caster
	local ability = self.ability
	local ability_level = ability:GetLevel() - 1

	-- #2 Talent: Fire Breath DPS Increase, Ice Breath Slow Increase
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level) + caster:FindSpecificTalentValue("special_bonus_imba_jakiro_2", "fire_damage_increase")
	self.tick_damage = damage * self.damage_interval
end

function modifier_imba_fire_breath_debuff:_SubClassOnCreated()
	self.move_slow = -(self.ability:GetSpecialValueFor("move_slow"))
end

function modifier_imba_fire_breath_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function modifier_imba_fire_breath_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end

-- Dual breath modifier applied to caster
-- Extend base_modifier_dual_breath_caster
modifier_imba_fire_breath_caster = ShallowCopy( base_modifier_dual_breath_caster )
modifier_imba_fire_breath_caster.modifier_debuff_name = "modifier_imba_fire_breath_debuff"
modifier_imba_fire_breath_caster.ability_other_breath_name = "imba_jakiro_ice_breath"
modifier_imba_fire_breath_caster.particle_breath = "particles/hero/jakiro/jakiro_fire_breath.vpcf"

-----------------------------
--		Ice Breath         --
-----------------------------
-- Extend base_ability_dual_breath
imba_jakiro_ice_breath = ShallowCopy( base_ability_dual_breath )
imba_jakiro_ice_breath.ability_other_breath_name = "imba_jakiro_fire_breath"
imba_jakiro_ice_breath.modifier_caster_name = "modifier_imba_ice_breath_caster"
LinkLuaModifier("modifier_imba_ice_breath_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_breath_caster", "hero/hero_jakiro", LUA_MODIFIER_MOTION_HORIZONTAL)

function imba_jakiro_ice_breath:GetTexture()
	return "custom/jakiro_ice_breath"
end

-- Ice breath debuff (applied to enemies to deal damage)
-- Extend base_modifier_dot_debuff
modifier_imba_ice_breath_debuff = ShallowCopy( base_modifier_dot_debuff )

function modifier_imba_ice_breath_debuff:_UpdateSubClassLevelValues()
	local ability = self:GetAbility()
	-- #2 Talent: Fire Breath DPS Increase, Ice Breath Slow Increase
	local talent_slow = self:GetCaster():FindSpecificTalentValue("special_bonus_imba_jakiro_2", "slow_increase")
	-- slow_increase is positive
	-- attack_slow is a constant, not a percentage
	self.attack_slow = -(ability:GetSpecialValueFor("attack_slow")) * (1+(talent_slow/100))
	self.move_slow = -(ability:GetSpecialValueFor("move_slow")) - talent_slow
end

function modifier_imba_ice_breath_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
 
	return funcs
end

function modifier_imba_ice_breath_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end
function modifier_imba_ice_breath_debuff:GetModifierAttackSpeedBonus_Constant() return self.attack_slow end

-- Dual breath modifier applied to caster
-- Extend base_modifier_dual_breath_caster
modifier_imba_ice_breath_caster = ShallowCopy(base_modifier_dual_breath_caster)
modifier_imba_ice_breath_caster.modifier_debuff_name = "modifier_imba_ice_breath_debuff"
modifier_imba_ice_breath_caster.ability_other_breath_name = "imba_jakiro_fire_breath"
modifier_imba_ice_breath_caster.particle_breath = "particles/hero/jakiro/jakiro_ice_breath.vpcf"


-----------------------------
--		Ice Path           --
-----------------------------

imba_jakiro_ice_path = class({})
LinkLuaModifier("modifier_imba_ice_path_thinker", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_freeze_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ice_path_slow_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)

function imba_jakiro_ice_path:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		-- Create thinker to apply modifiers to enemies on path
		CreateModifierThinker( caster, self, "modifier_imba_ice_path_thinker", kv, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
	end
end

modifier_imba_ice_path_thinker = class({})
modifier_imba_ice_path_thinker.modifier_freeze 	= "modifier_imba_ice_path_freeze_debuff"
modifier_imba_ice_path_thinker.modifier_slow 	= "modifier_imba_ice_path_slow_debuff"
function modifier_imba_ice_path_thinker:OnCreated( kv )
	if IsServer() then
		local caster				= self:GetCaster()
		local ability				= self:GetAbility()
		local ability_level 		= ability:GetLevel() - 1
		local path_length 			= ability:GetLevelSpecialValueFor("range", ability_level) + GetCastRangeIncrease(caster)
		
		local path_delay 			= ability:GetSpecialValueFor("path_delay")
		local path_radius 			= ability:GetSpecialValueFor("path_radius")

		-- #3 Talent: Ice Path Duration Increase
		local path_duration 		= ability:GetLevelSpecialValueFor("path_duration", ability_level) + caster:FindTalentValue("special_bonus_imba_jakiro_3")
		-- #5 Talent: Ice Path Stun Duration Increase
		local stun_duration 		= ability:GetLevelSpecialValueFor("stun_duration", ability_level) + caster:FindTalentValue("special_bonus_imba_jakiro_5")

		local start_pos 			= caster:GetAbsOrigin()
		local end_pos 				= start_pos + caster:GetForwardVector() * path_length
		local path_total_duration	= path_delay + path_duration

		self.ice_path_end_time 		= GameRules:GetGameTime() + path_total_duration
		-- Prevent enemy from getting frozen again
		self.frozen_enemy_set 		= {}
		self.ability_target_team 	= ability:GetAbilityTargetTeam()
		self.ability_target_type 	= ability:GetAbilityTargetType()
		self.ability_target_flags 	= ability:GetAbilityTargetFlags()
		self.path_radius			= path_radius
		self.stun_duration 			= stun_duration
		self.start_pos 				= start_pos
		self.end_pos 				= end_pos

		caster:EmitSound("Hero_Jakiro.IcePath")

		Timers:CreateTimer(0.1, function()
			caster:EmitSound("Hero_Jakiro.IcePath.Cast")
		end)

		-- Create ice path blob
		particle_name = "particles/hero/jakiro/jakiro_ice_path_line_blob.vpcf"
		local pfx_ice_path_blob = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx_ice_path_blob, 0, start_pos )
		ParticleManager:SetParticleControl( pfx_ice_path_blob, 1, end_pos )
		ParticleManager:SetParticleControl( pfx_ice_path_blob, 2, Vector(path_duration, 0, 0) ) --Shorter duration as it needs to melt
		self:AddParticle(pfx_ice_path_blob, false, false, -1, false, false)

		-- Create ice path flash
		Timers:CreateTimer(path_delay, function()
			particle_name = "particles/hero/jakiro/jakiro_ice_path_line_crack.vpcf"
			local pfx_ice_path_explode = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
			ParticleManager:SetParticleControl( pfx_ice_path_explode, 0, start_pos )
			ParticleManager:SetParticleControl( pfx_ice_path_explode, 1, end_pos )
			ParticleManager:ReleaseParticleIndex( pfx_ice_path_explode )
		end)

		-- Create ice path icicles
		particle_name = "particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf"
		local pfx_icicles = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControl( pfx_icicles, 0, start_pos )
		ParticleManager:SetParticleControl( pfx_icicles, 1, end_pos )
		ParticleManager:SetParticleControl( pfx_icicles, 2, Vector( path_total_duration, 0, 0 ) )
		ParticleManager:SetParticleControl( pfx_icicles, 9, start_pos )
		self:AddParticle(pfx_icicles, false, false, -1, false, false)

		local tick_rate = 0.1

		-- Apply affect after delay
		Timers:CreateTimer(path_delay, function()
			-- Apply effect immediately after delay
			self:OnIntervalThink()
			-- Run applying effects on interval
			self:StartIntervalThink( tick_rate )
		end)
	end
end

function modifier_imba_ice_path_thinker:OnIntervalThink()
	if IsServer() then
		local current_game_time = GameRules:GetGameTime()
		local ice_path_end_time = self.ice_path_end_time

		if current_game_time >= ice_path_end_time then
			-- Remove dummy thinker if ice path has ended
			UTIL_Remove( self:GetParent() )
		else

			local stun_duration 	= self.stun_duration
			local frozen_enemy_set 	= self.frozen_enemy_set
			local caster 			= self:GetCaster()
			local ability			= self:GetAbility()
			local modifier_freeze 	= self.modifier_freeze

			local time_diff = ice_path_end_time - current_game_time

			-- Stun duration does not last longer than the time left for ice path (follows original ice path)
			local stun_duration_left
			if time_diff > stun_duration then
				stun_duration_left = stun_duration
			else
				stun_duration_left = time_diff
			end

			local enemies = FindUnitsInLine(caster:GetTeamNumber(), self.start_pos, self.end_pos, nil, self.path_radius, self.ability_target_team, self.ability_target_type, self.ability_target_flags)

			for _, enemy in pairs(enemies) do
				if not frozen_enemy_set[enemy] then
					-- Freeze enemy if they touch ice path the first time
					frozen_enemy_set[enemy] = true
					enemy:AddNewModifier(caster, ability, modifier_freeze, { duration = stun_duration_left })
				else
					if not enemy:FindModifierByNameAndCaster(modifier_freeze, caster) then
						-- Slow enemy after the freeze expires
						enemy:AddNewModifier(caster, ability, self.modifier_slow, { duration = 1.0 })
					end
				end
			end
		end
	end
end

-- Ice path freeze debuff (applies stun to enemies and used as indicator for base_modifier_dot_debuff to deal more damage)
modifier_imba_ice_path_freeze_debuff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end,
	GetEffectName			= function(self) return "particles/generic_gameplay/generic_stunned.vpcf" end,
	GetEffectAttachType     = function(self) return PATTACH_OVERHEAD_FOLLOW end,
	GetOverrideAnimation 	= function(self) return ACT_DOTA_DISABLED end
})

function modifier_imba_ice_path_freeze_debuff:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = ability, damage = ability:GetSpecialValueFor("damage"), damage_type = ability:GetAbilityDamageType()})
	end
end

function modifier_imba_ice_path_freeze_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
 
	return funcs
end

function modifier_imba_ice_path_freeze_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
 
	return state
end

-- Ice path slow debuff (applies slow to enemies)
modifier_imba_ice_path_slow_debuff = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return true end
})

function modifier_imba_ice_path_slow_debuff:OnCreated()
	local ability = self:GetAbility()
	self.attack_slow = -(ability:GetSpecialValueFor("attack_slow"))
	self.move_slow = -(ability:GetSpecialValueFor("move_slow"))
end

function modifier_imba_ice_path_slow_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
 
	return funcs
end

function modifier_imba_ice_path_slow_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end
function modifier_imba_ice_path_slow_debuff:GetModifierAttackSpeedBonus_Constant() return self.attack_slow end

-----------------------------
--		Liquid Fire        --
-----------------------------

imba_jakiro_liquid_fire = class({
	GetIntrinsicModifierName = function(self) return "modifier_imba_liquid_fire_caster" end
})
LinkLuaModifier("modifier_imba_liquid_fire_caster", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_liquid_fire_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)

function imba_jakiro_liquid_fire:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	--cast_liquid_fire used as indicator to apply liquid fire to next attack
	self.cast_liquid_fire = false
end

function imba_jakiro_liquid_fire:GetCastRange(Location, Target)
	local caster = self:GetCaster()
	-- #4 Talent: Liquid Fire Cast Range Increase
	return caster:GetAttackRange() + self:GetSpecialValueFor("extra_cast_range") + caster:FindTalentValue("special_bonus_imba_jakiro_4")
end

function imba_jakiro_liquid_fire:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()

		self.cast_liquid_fire = true

		-- Attack the main target
		caster:PerformAttack(target, true, true, true, true, true, false, false)
	end
end

modifier_imba_liquid_fire_caster = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	RemoveOnDeath 			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end
})

function modifier_imba_liquid_fire_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER
	}

	return funcs
end

function modifier_imba_liquid_fire_caster:OnCreated()
	
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	-- apply_aoe_modifier_debuff_on_hit used as indicator to apply AOE modifier on target hit
	-- { target(key) : times_to_apply_liquid_fire_on_attack_lands (value)}
	-- This is done to allow attacking with liquid fire on correct targets if refresher orb is used
	self.apply_aoe_modifier_debuff_on_hit = {}

end

-- Returns true when liquid fire is not on cooldown and can be casted on target. Ability must be in auto cast or manual cast mode
function modifier_imba_liquid_fire_caster:_ShouldAttachLiquidFire( target )
	local ability = self.ability

	if not ability:IsHidden() and not target:IsMagicImmune() then
		return ability.cast_liquid_fire == true or (ability:GetAutoCastState() and ability:IsCooldownReady())
	end

	return false
end

function modifier_imba_liquid_fire_caster:OnAttack(keys)
	if IsServer() then
		local caster = self.caster
		local target = keys.target
		local attacker = keys.attacker

		if caster == attacker and self:_ShouldAttachLiquidFire(target) then
			local ability = self.ability

			-- Remove manual cast indicator
			ability.cast_liquid_fire = false

			-- Apply modifier on next hit
			if self.apply_aoe_modifier_debuff_on_hit[target] == nil then
				self.apply_aoe_modifier_debuff_on_hit[target] = 1;
			else
				self.apply_aoe_modifier_debuff_on_hit[target] = self.apply_aoe_modifier_debuff_on_hit[target] + 1;
			end

			local cooldown = ability:GetCooldown( ability:GetLevel() - 1 ) *  GetCooldownReduction(caster)

			-- Start cooldown
			ability:StartCooldown( cooldown )
		end
	end
end

function modifier_imba_liquid_fire_caster:_ApplyAOELiquidFire( keys )
	

	if IsServer() then

		local caster = self.caster
		local attacker = keys.attacker
		local target = keys.target
		local target_liquid_fire_counter = self.apply_aoe_modifier_debuff_on_hit[target]

		if caster == attacker and target_liquid_fire_counter and target_liquid_fire_counter > 0 then
			self.apply_aoe_modifier_debuff_on_hit[target] = target_liquid_fire_counter - 1;
			-- Remove key reference
			if self.apply_aoe_modifier_debuff_on_hit[target] == 0 then
				self.apply_aoe_modifier_debuff_on_hit[target] = nil
			end

			local ability = self.ability

			local ability_level = ability:GetLevel() - 1
			local particle_liquid_fire = "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
			local modifier_liquid_fire_debuff = "modifier_imba_liquid_fire_debuff"
			local duration = ability:GetLevelSpecialValueFor("duration", ability_level)

			-- Parameters
			local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

			-- Play sound
			target:EmitSound("Hero_Jakiro.LiquidFire")

			-- Play explosion particle
			local fire_pfx = ParticleManager:CreateParticle( particle_liquid_fire, PATTACH_ABSORIGIN, target )
			ParticleManager:SetParticleControl( fire_pfx, 0, target:GetAbsOrigin() )
			ParticleManager:SetParticleControl( fire_pfx, 1, Vector(radius * 2,0,0) )
			ParticleManager:ReleaseParticleIndex( fire_pfx )

			-- Apply liquid fire modifier to enemies in the area
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(caster, ability, modifier_liquid_fire_debuff, { duration = duration })
			end
		end
	end
end

function modifier_imba_liquid_fire_caster:OnAttackLanded( keys )
	self:_ApplyAOELiquidFire(keys)
end

function modifier_imba_liquid_fire_caster:OnAttackFail( keys )
	self:_ApplyAOELiquidFire(keys)
end

function modifier_imba_liquid_fire_caster:OnOrder(keys)
	local order_type = keys.order_type	

	-- On any order apart from attacking target, clear the cast_liquid_fire variable.
	if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
		self.ability.cast_liquid_fire = false
	end
end

-- Liquid Fire Debuff (deal damage and slow to enemies)
-- Extend base_modifier_dot_debuff
modifier_imba_liquid_fire_debuff = ShallowCopy( base_modifier_dot_debuff )

function modifier_imba_liquid_fire_debuff:_UpdateSubClassLevelValues()
	local ability = self.ability
	local ability_level = ability:GetLevel() - 1
	self.attack_slow = -(ability:GetLevelSpecialValueFor("attack_slow", ability_level))
end

function modifier_imba_liquid_fire_debuff:_SubClassOnCreated()
	self.turn_slow = -(self.ability:GetSpecialValueFor("turn_slow"))
end

function modifier_imba_liquid_fire_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_imba_liquid_fire_debuff:GetModifierAttackSpeedBonus_Constant() return self.attack_slow end
function modifier_imba_liquid_fire_debuff:GetModifierTurnRate_Percentage() return self.turn_slow end
function modifier_imba_liquid_fire_debuff:GetEffectName() return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf" end
function modifier_imba_liquid_fire_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

-----------------------------
--		Macropyre          --
-----------------------------

imba_jakiro_macropyre = class({})
LinkLuaModifier("modifier_imba_macropyre_thinker", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_macropyre_debuff", "hero/hero_jakiro", LUA_MODIFIER_MOTION_NONE)

function imba_jakiro_macropyre:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		CreateModifierThinker( caster, self, "modifier_imba_macropyre_thinker", {}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
	end
end

modifier_imba_macropyre_thinker = class({})
function modifier_imba_macropyre_thinker:OnCreated( kv )
	if IsServer() then
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local target 				= ability:GetCursorPosition()
		local ability_level 		= ability:GetLevel() - 1
		local scepter 				= HasScepter(caster)

		local path_radius 			= ability:GetLevelSpecialValueFor("path_radius", ability_level)
		local trail_amount 			= ability:GetLevelSpecialValueFor("trail_amount", ability_level)
		local path_duration
		local path_length
		-- Draw the fire particles (blue fire if the owner has Aghanim's Scepter)
		local particle_name

		-- Play cast sound, and ice sound if owner has Aghanim's Scepter
		caster:EmitSound("Hero_Jakiro.Macropyre.Cast")

		-- If the owner has a scepter, add cast sound, increase duration and length
		if scepter then
			caster:EmitSound("Hero_Jakiro.IcePath.Cast")
			path_duration 			= ability:GetLevelSpecialValueFor("duration_scepter", ability_level)
			path_length 			= ability:GetLevelSpecialValueFor("range_scepter", ability_level)
			particle_name			= "particles/hero/jakiro/jakiro_macropyre_blue.vpcf"
		else
			path_duration 			= ability:GetLevelSpecialValueFor("duration", ability_level)
			path_length 			= ability:GetLevelSpecialValueFor("range", ability_level)
			particle_name			= "particles/hero/jakiro/jakiro_macropyre.vpcf"
		end

		-- Add extra path length due to items
		path_length 				= path_length + GetCastRangeIncrease(caster)

		-- Initialize effect geometry
		local direction 			= (target - caster:GetAbsOrigin()):Normalized()
		local half_trail_amount 	= ( trail_amount - 1 ) / 2
		local start_pos 			= caster:GetAbsOrigin() + direction * path_radius
		local trail_start 			= ( -1 ) * half_trail_amount
		local trail_end 			= half_trail_amount
		local trail_angle 			= ability:GetLevelSpecialValueFor("trail_angle", ability_level)
		local sound_fire_loop		= "hero_jakiro.macropyre.scepter"
		self.ability_target_team 	= ability:GetAbilityTargetTeam()
		self.ability_target_type 	= ability:GetAbilityTargetType()
		self.ability_target_flags 	= ability:GetAbilityTargetFlags()
		self.debuff_duration 		= ability:GetSpecialValueFor("stickyness")
		self.macropyre_end_time 	= GameRules:GetGameTime() + path_duration
		self.path_radius			= path_radius
		self.sound_fire_loop		= sound_fire_loop
		
		self.start_pos = start_pos

		-- Destroys trees around the target area
		GridNav:DestroyTreesAroundPoint(start_pos, path_radius, false)

		self:GetParent():EmitSound(sound_fire_loop)

		local common_vector = start_pos + direction * path_length

		-- Calculate thinker position
		-- Multiple pos required to destroy trees (since no API to destroy trees in a line yet)
		self.thinker_pos_list = {}

		for trail = trail_start, trail_end do
		
			local macropyre_pfx = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN, caster)

			-- Calculate each trail's end position
			local end_pos = RotatePosition(start_pos, QAngle(0, trail * trail_angle, 0), common_vector)

			ParticleManager:SetParticleAlwaysSimulate(macropyre_pfx)
			ParticleManager:SetParticleControl( macropyre_pfx, 0, start_pos )
			ParticleManager:SetParticleControl( macropyre_pfx, 1, end_pos )
			ParticleManager:SetParticleControl( macropyre_pfx, 2, Vector( path_duration, 0, 0 ) )
			ParticleManager:SetParticleControl( macropyre_pfx, 3, start_pos )
			self:AddParticle(macropyre_pfx, false, false, -1, false, false)

			-- Create thinkers along the trail
			for i = 0, math.floor( path_length / path_radius ) do
				-- Calculate thinker position
				local thinker_pos = start_pos + i * path_radius * ( end_pos - start_pos ):Normalized()
				table.insert(self.thinker_pos_list, thinker_pos)
			end
		end

		-- Apply modifiers when thinker is created
		self:OnIntervalThink()
		-- Run applying modifiers on interval
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_imba_macropyre_thinker:OnIntervalThink()

	if IsServer() then

		if GameRules:GetGameTime() > self.macropyre_end_time then
			--Stop sound before destroy parent
			self:GetParent():StopSound(self.sound_fire_loop)
			UTIL_Remove( self:GetParent() )
		else
			local caster 				= self:GetCaster()
			local ability 				= self:GetAbility()
			local unique_enemy_list 	= {}
			local unique_enemy_set 		= {}
			local thinker_pos_list 		= self.thinker_pos_list
			local path_radius 			= self.path_radius
			local ability_target_team	= self.ability_target_team
			local ability_target_type	= self.ability_target_type
			local ability_target_flags	= self.ability_target_flags
			local debuff_duration		= self.debuff_duration

			--Increase Modifier Duration
			local modifier_list 		= {
				"modifier_imba_liquid_fire_debuff",
				"modifier_imba_fire_breath_debuff",
				"modifier_imba_ice_breath_debuff"
			}

			for _, thinker_pos in pairs(thinker_pos_list) do
				-- Destroys trees around the target area
				GridNav:DestroyTreesAroundPoint(thinker_pos, path_radius, false)

				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), thinker_pos, nil, path_radius, ability_target_team, ability_target_type, ability_target_flags, FIND_ANY_ORDER, false)

				-- Collate enemies into unique list
				for _, enemy in pairs(enemies) do
					if not unique_enemy_set[enemy] then
						unique_enemy_set[enemy] = true
						table.insert(unique_enemy_list, enemy)
					end
				end
			end

			for _, enemy in pairs(unique_enemy_list) do

				-- Applies debuff to enemies found
				enemy:AddNewModifier(caster, ability, "modifier_imba_macropyre_debuff", { duration = debuff_duration } )

				-- Increase duration for some modifiers
				for _,modifier_name in pairs(modifier_list) do
					local other_modifier = enemy:FindModifierByNameAndCaster(modifier_name, caster)
					if other_modifier then
						other_modifier:SetDuration(other_modifier:GetRemainingTime() + 0.25, true)
					end
				end
			end
		end
	end
end

-- Macropyre Debuff (deal damage and slow to enemies)
-- Extend base_modifier_dot_debuff
modifier_imba_macropyre_debuff = ShallowCopy( base_modifier_dot_debuff )

function modifier_imba_macropyre_debuff:_UpdateSubClassLevelValues()
	local caster = self.caster
	-- #8 Talent: Macropyre Cause Progressive Slow
	if caster:HasTalent("special_bonus_imba_jakiro_8") then

		-- normal macropyre duration = 10s
		-- scepter macropyre duration = 30s
		-- tick rate = 0.5s
		-- total normal ticks = 20
		-- total scepter ticks = 60
		-- initial slow = 5
		-- scale per tick = 1.05
		-- formula : 5 * (1.05 ^ n) where n is the number of ticks
		-- max normal slow = 13.2664885257
		-- max scepter slow = 93.3959294706
		-- This exludes slow from other abilities

		if not self.move_slow or self.move_slow == 0 then
			self.move_slow = -(caster:FindSpecificTalentValue("special_bonus_imba_jakiro_8", "init_slow"))
		else
			--Cache scale_per_tick value
			if not self.scale_per_tick then
				self.scale_per_tick = caster:FindSpecificTalentValue("special_bonus_imba_jakiro_8", "scale_per_tick")
			end
			self.move_slow = self.move_slow * self.scale_per_tick
		end
	else
		self.move_slow = 0
	end
end

function modifier_imba_macropyre_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
 
	return funcs
end

function modifier_imba_macropyre_debuff:GetModifierMoveSpeedBonus_Percentage() return self.move_slow end