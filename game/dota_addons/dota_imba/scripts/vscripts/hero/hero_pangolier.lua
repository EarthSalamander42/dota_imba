-- Author: Lindbrum
-- Date: 11/11/2017

CreateEmptyTalents("pangolier")


-------------------------------------
-----        SWASHBUCKLE       ------
-------------------------------------
imba_pangolier_swashbuckle = imba_pangolier_swashbuckle or class({})
LinkLuaModifier("modifier_imba_swashbuckle_dash", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_slashes", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_swashbuckle:GetAbilityTextureName()
   return "pangolier_swashbuckle"
end


function imba_pangolier_swashbuckle:IsHiddenWhenStolen() return false end
function imba_pangolier_swashbuckle:IsStealable() return true end
function imba_pangolier_swashbuckle:IsNetherWardStealable() return true end 

function imba_pangolier_swashbuckle:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)

    return manacost
end

function imba_pangolier_swashbuckle:GetCooldown(level)
    
    local cooldown = self.BaseClass.GetCooldown(self, level)
    local caster = self:GetCaster()

    --Talent: Reduced cooldown on swashbuckle
   	return cooldown - caster:FindTalentValue("special_bonus_imba_pangolier_7")
end

function imba_pangolier_swashbuckle:GetCastRange()
	return self:GetSpecialValueFor("dash_range")
end


function imba_pangolier_swashbuckle:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end




function imba_pangolier_swashbuckle:OnSpellStart()
	
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local point = caster:GetCursorPosition()
    local sound_cast = "Hero_Pangolier.Swashbuckle.Cast"
    local modifier_movement = "modifier_imba_swashbuckle_dash"
    local attack_modifier = "modifier_imba_swashbuckle_slashes"
    print(caster:HasTalent("special_bonus_imba_pangolier_1"))
    print(caster:HasTalent("special_bonus_imba_pangolier_2"))
    print(caster:HasTalent("special_bonus_imba_pangolier_3"))
    print(caster:HasTalent("special_bonus_imba_pangolier_4"))

    -- Ability specials
	local dash_range = ability:GetSpecialValueFor("dash_range")
	local range = ability:GetSpecialValueFor("range")


	
	--Cancel Rolling Thunder if he was rolling
	local rolling_thunder = "DOTA_Tooltip_modifier_pangolier_gyroshell"
	if caster:HasModifier(rolling_thunder) then
		caster:RemoveModifierByName(rolling_thunder)
	end

	-- Turn Pangolier toward the point he will dash (fix targeting for when cast in ranger AND there are no nearby enemies after dash)
	local direction = (point - caster:GetAbsOrigin()):Normalized()

	caster:SetForwardVector(direction)

    --play animation
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	
    -- Play cast sound
    EmitSoundOn(sound_cast, caster)
	
   



    --Begin moving to target point
    caster:AddNewModifier(caster, ability, modifier_movement, {})

    --Pass the targeted point to the modifier
    local modifier_movement_handler = caster:FindModifierByName(modifier_movement)
    modifier_movement_handler.target_point = point


end


--Dash movement modifier
modifier_imba_swashbuckle_dash = modifier_imba_swashbuckle_dash or class({})

function modifier_imba_swashbuckle_dash:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.attack_modifier = "modifier_imba_swashbuckle_slashes"
	self.dash_particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf"

	--Ability specials
	self.dash_speed = self.ability:GetSpecialValueFor("dash_speed")
	self.range = self.ability:GetSpecialValueFor("range")

	if IsServer() then

		--variables
		self.time_elapsed = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.dash_time = self.distance / self.dash_speed
			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

			--Add dash particle
			local dash = ParticleManager:CreateParticle(self.dash_particle, PATTACH_WORLDORIGIN, self.caster)
			ParticleManager:SetParticleControl(dash, 0, self.caster:GetAbsOrigin()) -- point 0: origin, point 2: sparkles, point 5: burned soil
			self:AddParticle(dash, false, false, -1, true, false)

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

--pangolier is stunned during the dash
function modifier_imba_swashbuckle_dash:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true}

	return state
end

function modifier_imba_swashbuckle_dash:IsHidden() return true end
function modifier_imba_swashbuckle_dash:IsPurgable() return false end
function modifier_imba_swashbuckle_dash:IsDebuff() return false end
function modifier_imba_swashbuckle_dash:IgnoreTenacity() return true end
function modifier_imba_swashbuckle_dash:IsMotionController() return true end
function modifier_imba_swashbuckle_dash:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_swashbuckle_dash:OnIntervalThink()

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end


	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)


end

function modifier_imba_swashbuckle_dash:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still dashing
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.dash_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.dash_speed * dt
			self.caster:SetAbsOrigin(new_location)            
		else            
			self:Destroy()
		end
	end 
end


function modifier_imba_swashbuckle_dash:OnRemoved()    
	if IsServer() then
		self.caster:SetUnitOnClearGround()

		--Pangolier finished the dash: look for enemies in range starting from the nearest
   		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.caster:GetAbsOrigin(),
										  nil,
										  self.range,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
										  FIND_CLOSEST,
										  false)


   		 --Check if there is an enemy hero in range. In case there is, he will be targeted, otherwise the nearest enemy unit is targeted
		local target_unit = nil
		local target_direction = nil
		if #enemies > 0 then --In case there is no target in range, Pangolier will attack in front of him
   		 	for _,enemy in pairs(enemies) do
				target_unit = target_unit or enemy	--track the nearest unit
				if enemy:IsRealHero() then
					target_unit = enemy
					break
				end
			end
			--Turn Pangolier towards the target
			target_direction = (target_unit:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
			self.caster:SetForwardVector(target_direction)
		end



   		--plays the slash animation
   		self.caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

   		

    	--Add the attack modifier on Pangolier that will handle the slashes
    	
    	local attack_modifier_handler = self.caster:AddNewModifier(self.caster, self.ability, self.attack_modifier, {})
    	
    	--pass the target
    	attack_modifier_handler.target = target_unit
	end
end



--attack modifier: will handle the slashes
modifier_imba_swashbuckle_slashes = modifier_imba_swashbuckle_slashes or class({})

function modifier_imba_swashbuckle_slashes:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
	self.slashing_sound = "Hero_Pangolier.Swashbuckle"
	self.hit_sound= "Hero_Pangolier.Swashbuckle.Damage"
	
	--Ability specials
	self.range = self.ability:GetSpecialValueFor("range")
	self.damage = self.ability:GetSpecialValueFor("damage") + self.caster:FindTalentValue("special_bonus_imba_pangolier_5")
	self.start_radius = self.ability:GetSpecialValueFor("start_radius")
	self.end_radius = self.ability:GetSpecialValueFor("end_radius")
	self.strikes = self.ability:GetSpecialValueFor("strikes")
	self.attack_interval = self.ability:GetSpecialValueFor("attack_interval")

	if IsServer() then

		--variables
		self.executed_strikes = 0

		--wait one frame to acquire the target from the ability
		Timers:CreateTimer(FrameTime(), function()
			--Set the point to use for the direction. If no units were found from the ability, use Pangolier current forward vector
			local direction = nil -- needed for the particle
			if self.target then
				direction = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
				self.fixed_target = self.caster:GetAbsOrigin() + direction * self.range -- will lock the targeting on the direction of the target on-cast
			else --no units found
				direction = self.caster:GetForwardVector():Normalized()
				self.fixed_target = self.caster:GetAbsOrigin() + direction * self.range
			end

			--play slashing particle
			local slash_particle = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(slash_particle, 0, self.caster:GetAbsOrigin()) --origin of particle
			ParticleManager:SetParticleControl(slash_particle, 1, direction * self.range) --direction and range of the subparticles
            self:AddParticle(slash_particle, false, false, -1, true, false)


			--start interval thinker
			self:StartIntervalThink(self.attack_interval)
		end)

	end
end

function modifier_imba_swashbuckle_slashes:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return declfuncs
end


function modifier_imba_swashbuckle_slashes:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1_END
end

function modifier_imba_swashbuckle_slashes:OnIntervalThink()
	if IsServer() then
		

		--check if pangolier is done slashing
		if self.executed_strikes == self.strikes then
			
			self:Destroy()
			return nil
		end

		--plays the attack sound
  		EmitSoundOn(self.slashing_sound, self.caster)



		--Check for enemies in the direction set on cast
		local enemies = FindUnitsInLine(self.caster:GetTeamNumber(),
										 self.caster:GetAbsOrigin(),
										 self.fixed_target,
										 nil,
										 self.start_radius,
										 DOTA_UNIT_TARGET_TEAM_ENEMY,
										 DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										 DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		
		for _,enemy in pairs(enemies) do

			--Play damage sound effect
			EmitSoundOn(self.hit_sound, enemy)

			--Apply the damage from the slash
			local damageTable = {victim = enemy,
                        damage = self.damage,
                        damage_type = DAMAGE_TYPE_PHYSICAL,
                        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
                        attacker = self.caster,
                        ability = nil
                        }



            ApplyDamage(damageTable)
            --Apply on-hit effects
			self.caster:PerformAttack(enemy, true, true, true, true, false, true, true) --slashes are disguised normal attacks that never misses
			
		end


		--increment the slash counter
		self.executed_strikes = self.executed_strikes + 1

	end
end

function modifier_imba_swashbuckle_slashes:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true}

	return state
end




-------------------------------------
-----      SHIELD CRUSH         -----
-------------------------------------
imba_pangolier_shield_crash = imba_pangolier_shield_crash or class({})
LinkLuaModifier("modifier_imba_shield_crash_buff", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shield_crash_jump", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_shield_crash:GetAbilityTextureName()
   return "pangolier_shield_crash"
end

function imba_pangolier_shield_crash:IsHiddenWhenStolen()  return false end
function imba_pangolier_shield_crash:IsStealable() return true end
function imba_pangolier_shield_crash:IsNetherWardStealable() return false end

function imba_pangolier_shield_crash:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)

    return manacost
end

function imba_pangolier_shield_crash:GetCooldown(level)
    
    local cooldown = self.BaseClass.GetCooldown(self, level)
    local caster = self:GetCaster()
    local talent_cooldown = caster:FindTalentValue("special_bonus_imba_pangolier_3")

    -- Talent: Shield Crash cooldown is set to 2 seconds during Rolling Thunder
    if caster:HasModifier("modifier_pangolier_gyroshell") and talent_cooldown > 0 then
    	
    	return talent_cooldown

    end
    return cooldown
end


function imba_pangolier_shield_crash:OnUpgrade()
end

function imba_pangolier_shield_crash:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end


function imba_pangolier_shield_crash:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local sound_cast= "Hero_Pangolier.TailThump.Cast"
    local gyroshell_ability = caster:FindAbilityByName("imba_pangolier_gyroshell")
    local modifier_movement = "modifier_imba_shield_crash_jump"
    local dust_particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf"


    -- Ability specials
    local jump_duration = ability:GetSpecialValueFor("jump_duration")
    local jump_duration_gyroshell = ability:GetSpecialValueFor("jump_duration_gyroshell")
    local jump_height = ability:GetSpecialValueFor("jump_height")
    local jump_height_gyroshell = ability:GetSpecialValueFor("jump_height_gyroshell")
    local jump_horizontal_distance = ability:GetSpecialValueFor("jump_horizontal_distance")

  
   	-- Play animation and dust particle
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	local dust = ParticleManager:CreateParticle(dust_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(dust, 0, caster:GetAbsOrigin())
    



	-- Play cast sound
	EmitSoundOn(sound_cast, caster)


   --jump in the faced direction
	local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})

	-- Assign the landing point, jump height and duration in the modifier
	if modifier_movement_handler then
		local gyroshell_horizontal_distance = jump_duration_gyroshell * gyroshell_ability:GetSpecialValueFor("forward_move_speed")
		modifier_movement_handler.dust_particle = dust
		--if Pangolier is rolling, the jump will be longer
		if caster:HasModifier("modifier_pangolier_gyroshell") then
			modifier_movement_handler.target_point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * gyroshell_horizontal_distance
			modifier_movement_handler.jump_height = jump_height_gyroshell
			modifier_movement_handler.jump_duration = jump_duration_gyroshell
		else --shorter jump
			modifier_movement_handler.target_point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * jump_horizontal_distance
			modifier_movement_handler.jump_height = jump_height
			modifier_movement_handler.jump_duration = jump_duration
		end
	end

	

end



--Shield Crash damage reduction modifier
modifier_imba_shield_crash_buff = modifier_imba_shield_crash_buff or class ({})
function modifier_imba_shield_crash_buff:OnCreated(kv)
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.stacks = kv.stacks
    self.particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"

    -- Ability specials
    self.damage_reduction_pct = self.ability:GetSpecialValueFor("hero_stacks")
    

    if IsServer() then
    	--set the stacks to the total % of mitigation for readability
    	self.caster:SetModifierStackCount("modifier_imba_shield_crash_buff", self.caster, self.damage_reduction_pct * self.stacks)

    	--Add buff particle
    	self.buff_particle = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.buff_particle, 1, self.caster:GetAbsOrigin()) --origin

   		self:AddParticle(self.buff_particle, false, false, -1, true, false)

   		--start thinking
   		self:StartIntervalThink(FrameTime())
    end
end

function modifier_imba_shield_crash_buff:OnIntervalThink()
	if IsServer() then

		--set particle to new position
		ParticleManager:SetParticleControl(self.buff_particle, 1, self.caster:GetAbsOrigin())
	end


end


function modifier_imba_shield_crash_buff:DestroyOnExpire()
    return true
end

function modifier_imba_shield_crash_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

    return decFuncs
end

function modifier_imba_shield_crash_buff:GetModifierIncomingDamage_Percentage()

	return self.damage_reduction_pct * self.stacks * (-1)
end



function modifier_imba_shield_crash_buff:IsPermanent() return false end
function modifier_imba_shield_crash_buff:IsHidden() return false end
function modifier_imba_shield_crash_buff:IsPurgable() return false end
function modifier_imba_shield_crash_buff:IsDebuff() return false end
function modifier_imba_shield_crash_buff:AllowIllusionDuplicate() return true end
function modifier_imba_shield_crash_buff:IsStealable() return true end



--Shield crash jump movement modifier
modifier_imba_shield_crash_jump = modifier_imba_shield_crash_jump or class({})

function modifier_imba_shield_crash_jump:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.buff_modifier = "modifier_imba_shield_crash_buff"
	self.smash_particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	self.smash_sound = "Hero_Pangolier.TailThump"

	-- Ability specials
	-- self.jump_height passed by the ability
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.talent_damage = self.caster:FindTalentValue("special_bonus_imba_pangolier_6")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.radius = self.ability:GetSpecialValueFor("radius")

	if IsServer() then

		-- Variables
		self.time_elapsed = 0
		self.jump_z = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.jump_time = self.jump_duration
			self.jump_speed = self.distance / self.jump_time

			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

function modifier_imba_shield_crash_jump:CheckState()
	state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}

	return state
end

function modifier_imba_shield_crash_jump:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Vertical Motion
	self:VerticalMotion(self.caster, self.frametime)

	-- Horizontal Motion
	self:HorizontalMotion(self.caster, self.frametime)
end

function modifier_imba_shield_crash_jump:IsHidden() return true end
function modifier_imba_shield_crash_jump:IsPurgable() return false end
function modifier_imba_shield_crash_jump:IsDebuff() return false end
function modifier_imba_shield_crash_jump:IgnoreTenacity() return true end
function modifier_imba_shield_crash_jump:IsMotionController() return true end
function modifier_imba_shield_crash_jump:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_shield_crash_jump:VerticalMotion(me, dt)
	if IsServer() then

		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then

			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up                
				self.jump_z = self.jump_z + ((self.jump_height * dt) / (self.jump_time / 2))               
				

				self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.jump_z))                
			else
				-- Going down
				self.jump_z = self.jump_z - ((self.jump_height * dt) / (self.jump_time / 2))
				if self.jump_z > 0 then
					self.caster:SetAbsOrigin(GetGroundPosition(self.caster:GetAbsOrigin(), self.caster) + Vector(0,0,self.jump_z))
				end
				
			end 
		end
	end
end

function modifier_imba_shield_crash_jump:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
			self.caster:SetAbsOrigin(new_location)            
		else            
			self:Destroy()
		end
	end 
end


function modifier_imba_shield_crash_jump:OnRemoved()    
	if IsServer() then
		self.caster:SetUnitOnClearGround()

		--play the smash particle

		local smash = ParticleManager:CreateParticle(self.smash_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(smash, 0, self.caster:GetAbsOrigin())
	


		-- Play smash sound
		EmitSoundOn(self.smash_sound, self.caster)


		-- Find heroes in AoE and track how many will be damaged
		local enemy_heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.caster:GetAbsOrigin(),
										  nil,
										  self.radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
										  FIND_ANY_ORDER,
										  false)


		local damaged_heroes = #enemy_heroes

		--Talent: extra damage for each enemy hero damaged

		local total_damage = self.damage + (damaged_heroes * self.talent_damage)

		-- Find all enemies in AoE
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.caster:GetAbsOrigin(),
										  nil,
										  self.radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

		

		-- Deal damage to each enemy
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table = ({victim = enemy,
							 attacker = self.caster,
							 ability = self.ability,
							 damage = total_damage,
							 damage_type = DAMAGE_TYPE_MAGICAL})

				ApplyDamage(damage_table)


			end
		end


		--Create (replace if it exists already) the damage reduction modifier
		if damaged_heroes > 0 then
			if self.caster:HasModifier(self.buff_modifier) then
				self.caster:RemoveModifierByName(self.buff_modifier)
			end
			self.caster:AddNewModifier(self.caster, self.ability, self.buff_modifier, {duration = self.duration, stacks = damaged_heroes}) 
		end

		--destroy and release particle indexes
		ParticleManager:DestroyParticle(self.dust_particle, false)
    	ParticleManager:ReleaseParticleIndex(self.dust_particle)
    	ParticleManager:ReleaseParticleIndex(smash)

	end
end









------------------------------------
-----      HEARTPIERCER        -----
------------------------------------
imba_pangolier_heartpiercer = imba_pangolier_heartpiercer or class({})
LinkLuaModifier("modifier_imba_heartpiercer_passive", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartpiercer_delay", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartpiercer_debuff", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)


function imba_pangolier_heartpiercer:GetAbilityTextureName()
	return "pangolier_heartpiercer"
end

function imba_pangolier_heartpiercer:GetIntrinsicModifierName()
	return "modifier_imba_heartpiercer_passive"
end


function imba_pangolier_heartpiercer:IsStealable() return false end
function imba_pangolier_heartpiercer:IsNetherWardStealable() return false end


--HEARTPIERCER PASSIVE MODIFIER (the one that let Pangolier apply the debuff)
modifier_imba_heartpiercer_passive = modifier_imba_heartpiercer_passive or class ({})

function modifier_imba_heartpiercer_passive:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.proc_sound_hero = "Hero_Pangolier.HeartPiercer.Proc"
	self.proc_sound_creep = "Hero_Pangolier.HeartPiercer.Proc.Creep"
	self.delayed_debuff = "modifier_imba_heartpiercer_delay"
	self.procced_debuff = "modifier_imba_heartpiercer_debuff"

	--Ability specials
	self.chance_pct = self.ability:GetSpecialValueFor("chance_pct") + self.caster:FindTalentValue("special_bonus_imba_pangolier_2") --Talent: extra proc chance
	self.debuff_delay = self.ability:GetSpecialValueFor("debuff_delay")

	if IsServer() then


	end

end

function modifier_imba_heartpiercer_passive:DeclareFunctions()
	local declfuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return declfuncs

end

function modifier_imba_heartpiercer_passive:OnAttackLanded(kv)
	if IsServer() then
		
		local attacker = kv.attacker
        local target = kv.target


        -- Only apply if the attacker is the parent
        if self.parent == attacker then

            -- If the parent is broken, do nothing
            if self.parent:PassivesDisabled() then
                return nil
            end

            --Roll for the pierce chance
            if RollPercentage(self.chance_pct) then
            	--heartpiercer procced

            	--Talent: check if heartpiercer is already in effect on the target. If it is, reapply the modifier 
            	--with the remaining duration (will take care of any change to bonus armor gained while debuffed)

            	if target:HasModifier(self.procced_debuff) then
            		if self.caster:HasTalent("special_bonus_imba_pangolier_1") then
            	
            			local modifier_handler = target:FindModifierByName(self.procced_debuff)
            			local remaining_duration = modifier_handler:GetDuration() - modifier_handler:GetElapsedTime()
            			target:RemoveModifierByName(self.procced_debuff)
            			target:AddNewModifier(self.caster, self.ability, self.procced_debuff, {duration = remaining_duration})
            		end
            		return
            	else

            		if not target:HasModifier(self.delayed_debuff) and not target:HasModifier(self.procced_debuff) then --heartpiercer wasn't already in effect: apply the delay if it's not already in effect
   

						--play proc sound effect
						if target:IsCreep() then
							EmitSoundOn(self.proc_sound_creep, target)
						else
							EmitSoundOn(self.proc_sound_hero, target)
						end

            			target:AddNewModifier(self.parent, self.ability, self.delayed_debuff, {duration = self.debuff_delay})
            		end
            	end
            end

            
            
        end


	end
end

function modifier_imba_heartpiercer_passive:IsHidden() return true end
function modifier_imba_heartpiercer_passive:IsPurgable() return false end
function modifier_imba_heartpiercer_passive:IsStealable() return false end
function modifier_imba_heartpiercer_passive:IsPermanent() return true end
function modifier_imba_heartpiercer_passive:IsDebuff() return false end


--Heartpiercer initial debuff delay modifier
modifier_imba_heartpiercer_delay = modifier_imba_heartpiercer_delay or class({})

function modifier_imba_heartpiercer_delay:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.debuff = "modifier_imba_heartpiercer_debuff"
	self.icon = "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_delay.vpcf"
	self.debuff_sound_creep = "Hero_Pangolier.HeartPiercer.Creep"
	self.debuff_sound_hero = "Hero_Pangolier.HeartPiercer"

	--Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")

	--if IsServer() then

		--add overhead particle
		local icon_particle = ParticleManager:CreateParticle(self.icon, PATTACH_OVERHEAD_FOLLOW, self.parent)
        self:AddParticle(icon_particle, false, false, -1, true, true)

		--

	--end


end

function modifier_imba_heartpiercer_delay:OnRemoved()
	if IsServer() then

		--play debuff sound
		if self.parent:IsCreep() then
			EmitSoundOn(self.debuff_sound_creep, self.parent)
		else
			EmitSoundOn(self.debuff_sound_hero, self.parent)
		end

		--apply the debuff
		local modifier_handler = self.parent:AddNewModifier(self.caster, self.ability, self.debuff, {duration = self.duration})

	end
end

function modifier_imba_heartpiercer_delay:IsHidden() return false end
function modifier_imba_heartpiercer_delay:IsPurgable() return false end
function modifier_imba_heartpiercer_delay:IsStealable() return false end
function modifier_imba_heartpiercer_delay:IsPermanent() return false end
function modifier_imba_heartpiercer_delay:IsDebuff() return true end


--Heartpiercer debuff modifier
modifier_imba_heartpiercer_debuff = modifier_imba_heartpiercer_debuff or class ({})

function modifier_imba_heartpiercer_debuff:OnCreated()
	--Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.icon = "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf"
	self.parent_armor = self.parent:GetPhysicalArmorValue()

	--Ability specials
	self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")



		--create overhead particle
		local icon_particle = ParticleManager:CreateParticle(self.icon, PATTACH_OVERHEAD_FOLLOW, self.parent)
        self:AddParticle(icon_particle, false, false, -1, true, true)

        --start thinking
        self:StartIntervalThink(0.1)


end

function modifier_imba_heartpiercer_debuff:OnIntervalThink()


	--client side: will reflect the armor denied in the UI
	if IsClient() then

		self.parent_armor = self.parent:GetModifierStackCount("modifier_imba_heartpiercer_debuff", self.caster)

	end



end

function modifier_imba_heartpiercer_debuff:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
						MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return declfuncs
end


function modifier_imba_heartpiercer_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct
end

function modifier_imba_heartpiercer_debuff:GetModifierPhysicalArmorBonus()
	
	local armor = self.parent_armor or 0  --self.parent_armor may be nil on first iteration
	--set stacks to denied armor (needed to display it correctly on UI)
	if IsServer() then
		self.parent:SetModifierStackCount("modifier_imba_heartpiercer_debuff", self.caster, armor)
	end
	
	
	return armor * (-1)
end

function modifier_imba_heartpiercer_debuff:IsHidden() return false end
function modifier_imba_heartpiercer_debuff:IsPurgable() return false end
function modifier_imba_heartpiercer_debuff:IsStealable() return false end
function modifier_imba_heartpiercer_debuff:IsPermanent() return false end
function modifier_imba_heartpiercer_debuff:IsDebuff() return true end



------------------------------------
-----    ROLLING THUNDER       -----
------------------------------------
imba_pangolier_gyroshell = imba_pangolier_gyroshell or class({})
--LinkLuaModifier("modifier_imba_gyroshell_roll", "hero/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_gyroshell:GetAbilityTextureName()
   return "pangolier_gyroshell"
end

function imba_pangolier_gyroshell:IsHiddenWhenStolen() return false end
function imba_pangolier_gyroshell:IsStealable() return true end
function imba_pangolier_gyroshell:IsNetherWardStealable() return false end

function imba_pangolier_gyroshell:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)

    return manacost
end

function imba_pangolier_gyroshell:GetCooldown(level)
    
    local cooldown = self.BaseClass.GetCooldown(self, level)
    local caster = self:GetCaster()

    --Talent: Reduced cooldown on Rolling Thunder
    return cooldown - caster:FindTalentValue("special_bonus_imba_pangolier_8")
end


function imba_pangolier_gyroshell:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end

function imba_pangolier_gyroshell:OnAbilityPhaseStart()
	local sound_cast = "Hero_Pangolier.Gyroshell.Cast"
	local cast_particle = "particles/units/heroes/hero_pangolier/pangolier_gyroshell_cast.vpcf"
	local caster = self:GetCaster() 

	--Play ability cast sound
	EmitSoundOn(sound_cast, caster)

	--Play the effect and animation
	self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect, 3, caster:GetAbsOrigin()) --3: shell and sprint effect position,
	ParticleManager:SetParticleControl(self.cast_effect, 5, caster:GetAbsOrigin()) --5: roses landing point

	return true
end

function imba_pangolier_gyroshell:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local ability = self
    local loop_sound = "Hero_Pangolier.Gyroshell.Loop"
    local vanilla_modifier = "modifier_pangolier_gyroshell"
    --local stun_modifier = "modifier_imba_gyroshell_stun" (not needed since we are using vanilla modifier for now)

    -- Ability specials
	local tick_interval = ability:GetSpecialValueFor("tick_interval")
	local forward_move_speed = ability:GetSpecialValueFor("forward_move_speed")
	local turn_rate_boosted = ability:GetSpecialValueFor("turn_rate_boosted")
	local turn_rate = ability:GetSpecialValueFor("turn_rate")
	local radius = ability:GetSpecialValueFor("radius")
	local hit_radius = ability:GetSpecialValueFor("hit_radius")
	local bounce_duration = ability:GetSpecialValueFor("bounce_duration")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local knockback_radius = ability:GetSpecialValueFor("knockback_radius")
	local ability_duration = ability:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_imba_pangolier_4")
	local jump_recover_time = ability:GetSpecialValueFor("jump_recover_time")


	-- Play animation
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)


	
	--Stop the cast effect and animation
	ParticleManager:DestroyParticle(self.cast_effect, false)
	ParticleManager:ReleaseParticleIndex(self.cast_effect)

	--Starts rolling (Vanilla modifier for now)
	caster:AddNewModifier(caster, ability, vanilla_modifier, {duration = ability_duration})

	--Play Loop sound
	EmitSoundOn(loop_sound, caster)

end










--[[ Rolling Thunder IMBA modifier (INCOMPLETE)
modifier_imba_gyroshell_roll = modifier_imba_gyroshell_roll or class({})

function modifier_imba_gyroshell_roll:OnCreated()
	-- Ability properties
    self.caster = self:GetCaster()
    self.ability = self
    self.stun_modifier = "modifier_imba_gyroshell_stun"

    -- Ability specials
	self.tick_interval = ability:GetSpecialValueFor("tick_interval")
	self.forward_move_speed = ability:GetSpecialValueFor("forward_move_speed")
	self.turn_rate_boosted = ability:GetSpecialValueFor("turn_rate_boosted")
	self.turn_rate = ability:GetSpecialValueFor("turn_rate")
	self.radius = ability:GetSpecialValueFor("radius")
	self.hit_radius = ability:GetSpecialValueFor("hit_radius")
	self.bounce_duration = ability:GetSpecialValueFor("bounce_duration")
	self.stun_duration = ability:GetSpecialValueFor("stun_duration")
	self.knockback_radius = ability:GetSpecialValueFor("knockback_radius")
	self.jump_recover_time = ability:GetSpecialValueFor("jump_recover_time")

	if IsServer() then



		--start modifier interval thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_gyroshell_roll:IsHidden() return true end
function modifier_imba_gyroshell_roll:IsPurgable() return false end
function modifier_imba_gyroshell_roll:IsDebuff() return false end
function modifier_imba_gyroshell_roll:IgnoreTenacity() return true end
function modifier_imba_gyroshell_roll:IsMotionController() return true end
function modifier_imba_gyroshell_roll:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_gyroshell_roll:OnIntervalThink()

	--check the direction we are rolling to and the target point to determine if Pangolier is turning
	local direction = self.caster:GetForwardVector():Normalized()
	local target_direction = self.point - self.caster:GetAbsOrigin():Normalized()

	if direction ~= target_direction
end


end

function modifier_imba_gyroshell_roll:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
						MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
						MODIFIER_PROPERTY_OVERRIDE_ANIMATION
						MODIFIER_EVENT_ON_ORDER}

	return declfuncs
end 

--if issuing an movement order, update the position Pangolier will try to roll to
function modifier_imba_gyroshell_roll:OnOrder(kv)
	local order_type = kv.order_type
	if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET or order_type == DOTA_UNIT_ORDER_HOLD_POSITION then
		self.point = self.caster:GetCursorPosition()
	end
end


function modifier_imba_gyroshell_roll:GetModifierMoveSpeed_Absolute()
	return self.forward_move_speed
end

function modifier_imba_gyroshell_roll:GetModifierTurnRate_Percentage()



	return self.forward_move_speed
end

function modifier_imba_gyroshell_roll:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end]]