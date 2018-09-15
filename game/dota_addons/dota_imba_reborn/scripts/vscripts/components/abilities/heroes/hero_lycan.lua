-- Author: Shush
-- Date: 17/01/2017

---------------------------------------------------
--			Lycan's Summon Wolves
---------------------------------------------------

imba_lycan_summon_wolves = class({})
LinkLuaModifier("modifier_imba_lycan_wolf_charge", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lycan_wolf_death_check", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summon_wolves_talent", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_summon_wolves:GetAbilityTextureName()
   return "lycan_summon_wolves"
end

function imba_lycan_summon_wolves:OnUpgrade()
    if IsServer() then
    	-- Ability properties
    	local caster = self:GetCaster()
    	local ability = self
    	local charges_buff = "modifier_imba_lycan_wolf_charge"	
    	
    	-- Ability specials
    	local charge_cooldown = ability:GetSpecialValueFor("charge_cooldown")
    	local max_charges = ability:GetSpecialValueFor("max_charges")	
    	
    	-- Give buff, set stacks to maximum count.
    	if not caster:HasModifier(charges_buff) then
    		caster:AddNewModifier(caster, ability, charges_buff, {})			
    	end	
    	
    	local charges_buff_handler = caster:FindModifierByName(charges_buff)
    	charges_buff_handler:ForceRefresh()
    	charges_buff_handler:SetStackCount(max_charges)
    	charges_buff_handler:SetDuration(-1, true)
    	charges_buff_handler:StartIntervalThink(charge_cooldown-0.01)
    end
end


function imba_lycan_summon_wolves:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local caster_level = caster:GetLevel()
	local ability = self		
	local wolf_name = "npc_lycan_wolf"
	local sound_cast = "Hero_Lycan.SummonWolves"
	local response_sound = "lycan_lycan_ability_summon_0"..RandomInt(1,6)	
	local particle_cast = "particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf"
	local particle_spawn = "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf"
	local player_id = nil
	local death_check = "modifier_imba_lycan_wolf_death_check"	
	
	-- Nonhero caster handling (e.g. Nether Ward)
	if caster:IsRealHero() then
		player_id = caster:GetPlayerID()
	end	

	-- Ability specials
	local distance = ability:GetSpecialValueFor("distance")
	local wolves_count = ability:GetSpecialValueFor("wolves_count")
	local HP_bonus_per_lycan_level = ability:GetSpecialValueFor("HP_bonus_per_lycan_level")		
	local wolf_type = ability:GetSpecialValueFor("wolf_type")		
	
	-- #1 TALENT: wolves upgrade by one level			
	wolf_type = wolf_type + caster:FindTalentValue("special_bonus_imba_lycan_1")
	
	-- Find and kill any living wolves on the map
	local creatures = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									25000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
		
	
	-- Iterate between all wolf levels to make sure all of them are dead
	for _,creature in pairs(creatures) do -- check each friendly player controlled creep
		for i = 1, 6 do															-- #3 TALENT: Destroys Alpha wolves on resummon
			if creature:GetUnitName() == wolf_name..i or creature:GetUnitName() == "npc_lycan_summoned_wolf_talent" and creature:GetPlayerOwnerID() == player_id then -- If it's your wolf, kill it
				creature.killed_by_resummon = true
				creature:ForceKill(false)				
			end	
		end
	end
	
	-- Play hero response
	EmitSoundOn(response_sound, caster)
	
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)	
	
	-- Add cast particles
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, caster:GetAbsOrigin())
	
	-- Reset variables
	local summon_origin = caster:GetAbsOrigin() + distance * caster:GetForwardVector()
	local summon_point = nil	
	local angleLeft = nil
	local angleRight = nil
	
	-- Define spawn locations 	
	for i = 0, wolves_count-1 do		
		angleLeft = QAngle(0, 30 + 45*(math.floor(i/2)), 0)
		angleRight = QAngle(0, -30 + (-45*(math.floor(i/2))), 0)			
		
		if (i+1) % 2 == 0 then --to the right			
			summon_point = RotatePosition(caster:GetAbsOrigin(),angleLeft,summon_origin) 			
		else --to the left			
			summon_point = RotatePosition(caster:GetAbsOrigin(),angleRight,summon_origin) 			
		end
		
		-- Add spawn particles in spawn location
		local particle_spawn_fx = ParticleManager:CreateParticle(particle_spawn, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle_spawn_fx, 0, summon_point)
		
		local wolf_name_summon = wolf_name..wolf_type		
		
		-- Create wolf and find clear space for it
		local wolf = CreateUnitByName(wolf_name_summon, summon_point, false, caster, caster, caster:GetTeamNumber())		
		FindClearSpaceForUnit(wolf, summon_point, true)
		 if player_id then
			 wolf:SetControllableByPlayer(player_id, true)
		 end
		
		--Set wolves life depending on lycan's level		
		wolf:SetBaseMaxHealth(wolf:GetBaseMaxHealth() + HP_bonus_per_lycan_level * caster_level )		

		--Set forward vector
		wolf:SetForwardVector(caster:GetForwardVector())	

		-- Give wolf death check modifier
		wolf:AddNewModifier(caster, ability, death_check, {})

		-- #2 TALENT: Wolves gain a bonus damage modifier
		if caster:HasTalent("special_bonus_imba_lycan_2") then
			wolf:AddNewModifier(caster, ability, "modifier_imba_summon_wolves_talent", {})
		end
		
		-- If wolf is Shadow Wolf/Nightclaw (level 5 or 6) paint in grey/black texture
		if wolf_type >= 5 then
			wolf:SetRenderColor(49, 49, 49)			
		end
	end	

	-- #3 TALENT: Summons an alpha wolf
	if caster:HasTalent("special_bonus_imba_lycan_3") then
		-- At the head of the pack
		summon_point = summon_origin 					

		-- Add spawn particles in spawn location
		local particle_spawn_fx = ParticleManager:CreateParticle(particle_spawn, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle_spawn_fx, 0, summon_point)
		
		
		-- Create wolf and find clear space for it
		local wolf = CreateUnitByName("npc_lycan_summoned_wolf_talent", summon_point, false, caster, caster, caster:GetTeamNumber())		
		FindClearSpaceForUnit(wolf, summon_point, true)
		 if player_id then
			 wolf:SetControllableByPlayer(player_id, true)
		 end
		
		--Set wolves life depending on lycan's level		
		wolf:SetBaseMaxHealth(wolf:GetBaseMaxHealth() + HP_bonus_per_lycan_level * caster_level )		

		--Set forward vector
		wolf:SetForwardVector(caster:GetForwardVector())	

		-- Give wolf death check modifier
		wolf:AddNewModifier(caster, ability, death_check, {})

		-- #2 TALENT: Wolves gain a bonus damage modifier
		if caster:HasTalent("special_bonus_imba_lycan_2") then
			wolf:AddNewModifier(caster, ability, "modifier_imba_summon_wolves_talent", {})
		end
	end
end



-- Charge modifier
modifier_imba_lycan_wolf_charge = class({}) 

function modifier_imba_lycan_wolf_charge:GetIntrinsicModifierName()
    return "modifier_imba_lycan_wolf_charge"
end

function modifier_imba_lycan_wolf_charge:IsDebuff()
	return false	
end

function modifier_imba_lycan_wolf_charge:IsHidden()	
		return false	
end

function modifier_imba_lycan_wolf_charge:IsPurgable()
	return false	
end

function modifier_imba_lycan_wolf_charge:AllowIllusionDuplicate()
	return false
end

function modifier_imba_lycan_wolf_charge:RemoveOnDeath()
	--remove if the ability was stolen via Rubick's ulti. 
	--Needed to prevent a bug where the buff would stay on permanently even after losing the ability on death
	if self.ability:IsStolen() then
		return true
	end
	return false
end

function modifier_imba_lycan_wolf_charge:OnCreated()
    if IsServer() then
    	-- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()	    	
    	
    	-- Ability specials
        self.max_charges = self.ability:GetSpecialValueFor("max_charges")
        self.charge_cooldown = self.ability:GetSpecialValueFor("charge_cooldown")
        self.wolves_count = self.ability:GetSpecialValueFor("wolves_count")                        
    			
        -- Start thinking
    	self:StartIntervalThink(self.charge_cooldown-0.01)
    end
end

function modifier_imba_lycan_wolf_charge:OnRefresh()
    self:OnCreated()
end

function modifier_imba_lycan_wolf_charge:OnIntervalThink()
	if IsServer() then
		-- Ability properties		
		local stacks = self:GetStackCount()				
		
		-- if we're not at maximum charges yet, refresh it		
		if stacks < self.max_charges then
		
			-- Increase stack and restart duration
			self:ForceRefresh()							
			self:IncrementStackCount()										
			
			-- Only start charge cooldown if the new stack doesn't reach the maximum allowed			
			if stacks < self.max_charges-1 then
				self:SetDuration(self.charge_cooldown, true)		
			else			
				-- Disable interval, disable duration
				self:SetDuration(-1, true)		
				self:StartIntervalThink(-1)
			end						
		end				
		
		-- count wolves, if there are missing wolves, revive one
		local wolves = FindUnitsInRadius(self.caster:GetTeamNumber(),
    									self.caster:GetAbsOrigin(),
    									nil,
    									25000, -- global
    									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    									DOTA_UNIT_TARGET_BASIC,
    									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
    									FIND_ANY_ORDER,
    									false)
		
		if #wolves < self.wolves_count and self.caster:IsAlive() then
			ReviveWolves(self.caster, self.ability)
		end
		
	end
end



-- Death check modifier (given to wolves)
modifier_imba_lycan_wolf_death_check = class({})

function modifier_imba_lycan_wolf_death_check:IsDebuff()
	return false	
end

function modifier_imba_lycan_wolf_death_check:IsHidden()
	return true
end

function modifier_imba_lycan_wolf_death_check:IsPurgable()
	return false	
end

function modifier_imba_lycan_wolf_death_check:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_DEATH}
		
		return decFuncs	
end

function modifier_imba_lycan_wolf_death_check:OnCreated()
    -- Ability properties               
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.wolf = self:GetParent()
end

function modifier_imba_lycan_wolf_death_check:OnDeath( keys )
    if IsServer() then    	
    	local unit = keys.unit
    		
    	-- Revive only when it was a wolf that just died
    	if unit == self.wolf then
    		-- Only revive wolves that weren't killed due to resummon
    		if not self.wolf.killed_by_resummon then			
    			ReviveWolves(self.caster, self.ability)
    		end
    	end
    end
end

function ReviveWolves (caster, ability)
	if IsServer() then
		local charge_modifier = "modifier_imba_lycan_wolf_charge"				
		local particle_spawn = "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf"
		local wolf_name = "npc_lycan_wolf"
		local caster_level = caster:GetLevel()
		local death_check = "modifier_imba_lycan_wolf_death_check"
		local player_id = nil
		
		-- Ability specials				
		local charge_cooldown = ability:GetSpecialValueFor("charge_cooldown")		
		local distance = ability:GetSpecialValueFor("distance")	
		local HP_bonus_per_lycan_level = ability:GetSpecialValueFor("HP_bonus_per_lycan_level")
		local wolf_type = ability:GetSpecialValueFor("wolf_type")				
	
		-- #1 Talent (wolves upgrade by one level)				
		wolf_type = wolf_type + caster:FindTalentValue("special_bonus_imba_lycan_1")
		
		if caster:HasModifier(charge_modifier) then -- prevents error if Lycan is dead
			local charge_modifier_handler = caster:FindModifierByName(charge_modifier)
			local charge_stacks = charge_modifier_handler:GetStackCount()		
			
			-- If more than one charge, reduce a charge.
			if charge_stacks > 0 then
				charge_modifier_handler:DecrementStackCount()
				
				local modifier_duration = charge_modifier_handler:GetDuration()
				
				-- start cooldown again on permanent durations
				if modifier_duration == -1 then
					charge_modifier_handler:SetDuration(charge_cooldown, true)
					charge_modifier_handler:StartIntervalThink(charge_cooldown-0.01)
				end		
				
				-- Spawn a wolf in front of Lycan
				local summon_origin = caster:GetAbsOrigin() + (distance+RandomInt(0, 160)) * caster:GetForwardVector()	
				
				-- Add spawn particles in spawn location
				local particle_spawn_fx = ParticleManager:CreateParticle(particle_spawn, PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(particle_spawn_fx, 0, caster:GetAbsOrigin())
				
				local wolf_name_summon = wolf_name..wolf_type
				
				-- Create wolf and find clear space for it
				 local wolf = CreateUnitByName(wolf_name_summon, summon_origin, false, caster, caster, caster:GetTeamNumber())							 
				 
				 -- Prevent nearby units from getting stuck
				Timers:CreateTimer(FrameTime(), function()
					local units = FindUnitsInRadius(caster:GetTeamNumber(), summon_origin, nil, 64, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
					for _,unit in pairs(units) do
						FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
					end
				end)
				
				-- Set wolves life depending on lycan's level		
				 wolf:SetBaseMaxHealth(wolf:GetBaseMaxHealth() + HP_bonus_per_lycan_level * caster_level )		
				
				-- Set forward vector
				 wolf:SetForwardVector(caster:GetForwardVector())	
				
				-- Give wolf death check modifier
				wolf:AddNewModifier(caster, ability, death_check, {})
				
				-- #2 TALENT: Wolves gain a bonus damage modifier
				if caster:HasTalent("special_bonus_imba_lycan_2") then
					wolf:AddNewModifier(caster, ability, "modifier_imba_summon_wolves_talent", {})
				end

				-- If wolf is Shadow Wolf/Nightclaw (level 5 or 6) paint in grey/black texture
				 if wolf_type >= 5 then
					 wolf:SetRenderColor(49, 49, 49)
				 end
				
				-- Nonhero caster handling (e.g. Nether Ward)
				if caster:IsRealHero() then
					player_id = caster:GetPlayerID()
					wolf:SetControllableByPlayer(player_id, true)				
				end
			end		
		end	
	end
end


--- #2 TALENT modifier
modifier_imba_summon_wolves_talent = modifier_imba_summon_wolves_talent or class({})

-- Modifier properties
function modifier_imba_summon_wolves_talent:IsDebuff()	return false end
function modifier_imba_summon_wolves_talent:IsHidden() return false end
function modifier_imba_summon_wolves_talent:IsPurgable() return false end

function modifier_imba_summon_wolves_talent:OnCreated()
	if IsServer() then
		local parent		=	self:GetParent()
		local caster 		=	self:GetCaster()
										-- Average base damage
		local bonus_damage 	= 	(caster:GetBaseDamageMin() + caster:GetBaseDamageMax()) / 2 * caster:FindTalentValue("special_bonus_imba_lycan_2") * 0.01

		-- Server-client wormhole entrance
		CustomNetTables:SetTableValue("player_table", "modifier_imba_summon_wolves_talent_bonus_damage"..parent:entindex(), {bonus_damage = bonus_damage})
	end

	-- Server-client wormhole exit
	local parent 	=	self:GetParent()
	if CustomNetTables:GetTableValue("player_table", "modifier_imba_summon_wolves_talent_bonus_damage"..parent:entindex()) then
		if CustomNetTables:GetTableValue("player_table", "modifier_imba_summon_wolves_talent_bonus_damage"..parent:entindex()).bonus_damage then
			self.bonus_damage = CustomNetTables:GetTableValue("player_table", "modifier_imba_summon_wolves_talent_bonus_damage"..parent:entindex()).bonus_damage
		end
	end
end

function modifier_imba_summon_wolves_talent:DeclareFunctions()
	local funcs ={
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
	return funcs
end

function modifier_imba_summon_wolves_talent:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--				Lycan's Howl
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_lycan_howl = class ({})
LinkLuaModifier("modifier_imba_howl_buff", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_howl_flying_movement_talent", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_howl:GetAbilityTextureName()
   return "lycan_howl"
end

function imba_lycan_howl:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Lycan.Howl"
	local response_sound = "lycan_lycan_ability_howl_0" ..RandomInt(1,5)	
	local particle_lycan_howl = "particles/units/heroes/hero_lycan/lycan_howl_cast.vpcf"
	local particle_wolves_howl = "particles/units/heroes/hero_lycan/lycan_howl_cast_wolves.vpcf"
	local wolf_name = "npc_lycan_wolf"
	local buff = "modifier_imba_howl_buff"
	local day = GameRules:IsDaytime()	
	
	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")
	local bonus_health_heroes = ability:GetSpecialValueFor("bonus_health_heroes")	
		
	-- Play global cast sound, only for allies
	EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_cast, caster)
	
	-- Play one of Lycan's howl responses
	EmitSoundOn(response_sound, caster)
	
	-- Add Lycan's cast particles
	local particle_lycan_howl_fx = ParticleManager:CreateParticle(particle_lycan_howl, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lycan_howl_fx, 2 , caster:GetAbsOrigin())
	
	-- Find all wolves	
	local creatures = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									25000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
		
		
	
	for _,creature in pairs(creatures) do 
		for i = 1, 6 do									 -- #3 TALENT: Alpha wolf gesture
			if creature:GetUnitName() == wolf_name..i or "npc_lycan_summoned_wolf_talent" then 
				-- Perform howl cast animation for wolves	
				if creature:IsIdle() then
					creature:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)		
				else
					creature:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
				end				
				
				-- Add wolves cast particles
				local particle_wolves_howl_fx = ParticleManager:CreateParticle(particle_wolves_howl, PATTACH_ABSORIGIN, creature)
				ParticleManager:SetParticleControl(particle_wolves_howl_fx, 1, creature:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_wolves_howl_fx, 2, creature:GetAbsOrigin())

				-- #4 TALENT: Wolves gain a flying movement modifier
				if caster:HasTalent("special_bonus_imba_lycan_4") then
					creature:AddNewModifier(caster, self, "modifier_imba_howl_flying_movement_talent", {duration = caster:FindTalentValue("special_bonus_imba_lycan_4")})
				end
			end	
		end
	end	

	-- #4 TALENT: Lycan gains a flying movement modifier
	if caster:HasTalent("special_bonus_imba_lycan_4") then	
		caster:AddNewModifier(caster, self, "modifier_imba_howl_flying_movement_talent", {duration = caster:FindTalentValue("special_bonus_imba_lycan_4")})
	end
	
	-- Find all allies (except lane creeps) and give them the buff
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									25000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
									
	for _, ally in pairs(allies) do
		ally:AddNewModifier(caster, ability, buff, {duration = duration})	
	end
end

function imba_lycan_howl:OnUpgrade()
	if self:GetLevel() == 1 then
		-- Toggles on the nighttime phasing
		self:ToggleAutoCast()
	end
end

--heroes howl modifier
modifier_imba_howl_buff = class({})

function modifier_imba_howl_buff:IsHidden()
	return false
end

function modifier_imba_howl_buff:IsDebuff()
	return false
end

function modifier_imba_howl_buff:IsPurgable()
	return true
end

function modifier_imba_howl_buff:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
	
	-- Only need to put bonus health value up here because this one doesn't change on day-night cycle
	if self.parent:IsHero() then
		self.bonus_health	=	self.ability:GetSpecialValueFor("bonus_health_heroes")
	else
		self.bonus_health	=	self.ability:GetSpecialValueFor("bonus_health_units")
	end
	
	if not IsDaytime() then
		self.bonus_health	=	self.bonus_health * 2
	end
end

function modifier_imba_howl_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_imba_howl_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_howl_buff:DeclareFunctions()		
		local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE ,
						  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
						  MODIFIER_PROPERTY_HEALTH_BONUS						  
						  }		
		return decFuncs			
end

function modifier_imba_howl_buff:GetModifierPreAttack_BonusDamage()
	-- Check if unit is hero or not
	if self.parent:IsHero() then
		self.bonus_damage	= self.ability:GetSpecialValueFor("bonus_damage_hero")
	else
		self.bonus_damage	= self.ability:GetSpecialValueFor("bonus_damage_units")
	end
	
	-- Check if night time (double bonus)
	if not IsDaytime() then
		self.bonus_damage	= self.bonus_damage * 2
	end
		
	return self.bonus_damage
end

function modifier_imba_howl_buff:GetModifierHealthBonus()
	return self.bonus_health
end


function modifier_imba_howl_buff:GetModifierMoveSpeedBonus_Constant()
	-- Check if unit is hero or not
	if self.parent:IsHero() then
		self.bonus_ms	= self.ability:GetSpecialValueFor("bonus_ms_heroes")
	else
		self.bonus_ms	= self.ability:GetSpecialValueFor("bonus_ms_units")
	end
	
	-- Check if night time (double bonus)
	if not IsDaytime() then
		self.bonus_ms	= self.bonus_ms * 2
	end

	return self.bonus_ms
end


function modifier_imba_howl_buff:CheckState()
	if IsServer() then
		local day = GameRules:IsDaytime()
		
		if not GameRules:IsDaytime() and self:GetAbility():GetAutoCastState() then
			local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
			return state
		end	

		return nil
	end	
end

--- #4 TALENT: flying movement modifier
modifier_imba_howl_flying_movement_talent = modifier_imba_howl_flying_movement_talent or class({})

-- Modifier properties
function modifier_imba_howl_flying_movement_talent:IsDebuff() 		return false end
function modifier_imba_howl_flying_movement_talent:IsHidden() 		return false end
function modifier_imba_howl_flying_movement_talent:IsPurgable() 	return false end
function modifier_imba_howl_flying_movement_talent:IsPurgeException() 	return true end 	-- Dispellable by hard dispells

function modifier_imba_howl_flying_movement_talent:OnCreated()
	if IsServer() then
		self.parent	=	self:GetParent()
		-- Set to flying movement
		self.parent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	end
end

function modifier_imba_howl_flying_movement_talent:OnDestroy()
	if IsServer() then
		-- Set to normal ground movement
		self.parent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		-- Make sure not to get stuck
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
		self.parent:SetUnitOnClearGround()
	end
end

-- Thanks @Luxcerv for the image!
function modifier_imba_howl_flying_movement_talent:GetTexture()
	return "custom/howl_batwolf"
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Lycan's Feral Impulse
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_lycan_feral_impulse = class({})
LinkLuaModifier("modifier_imba_feral_impulse_aura", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_feral_impulse", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_feral_impulse:GetAbilityTextureName()
   return "lycan_feral_impulse"
end

function imba_lycan_feral_impulse:GetIntrinsicModifierName()	
    return "modifier_imba_feral_impulse_aura"
end

-- Feral Impulse aura
modifier_imba_feral_impulse_aura = class({})

function modifier_imba_feral_impulse_aura:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.parent = self:GetParent() 

        -- Ability specials        
        self.base_bonus_damage_perc = self.ability:GetSpecialValueFor("base_bonus_damage_perc")
        self.damage_inc_per_unit = self.ability:GetSpecialValueFor("damage_inc_per_unit")
        self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
        self.hero_inc_multiplier = self.ability:GetSpecialValueFor("hero_inc_multiplier")

	    self:StartIntervalThink(0.2)
    end
end

function modifier_imba_feral_impulse_aura:OnIntervalThink()
	if IsServer() then				
		-- Set variable
		local value_increase = 0		
		
		-- Find all units and heroes around caster (Lycan). Ignore Lycan and illusions.	
		local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.caster:GetAbsOrigin(),
										nil,
										self.aura_radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
										FIND_ANY_ORDER,
										false)
		
		-- For every unit, increase the value. If it's a hero, double that value increase.		
		for _, unit in pairs(units) do
			if unit ~= self.caster then
				if unit:IsRealHero() then
					value_increase = value_increase + 1 * self.hero_inc_multiplier
				else
					value_increase = value_increase + 1
				end		
			end	
		end
		
		-- The stacks define how much increase the effects should receive. 		
		self:SetStackCount(value_increase)	
	end
end

function modifier_imba_feral_impulse_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_feral_impulse_aura:GetEffectName()
	return "particles/auras/aura_feral_impulse.vpcf"
end

function modifier_imba_feral_impulse_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_feral_impulse_aura:GetAuraRadius()	
	return self.aura_radius
end

function modifier_imba_feral_impulse_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_feral_impulse_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_feral_impulse_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_feral_impulse_aura:GetModifierAura()
	return "modifier_imba_feral_impulse"
end

function modifier_imba_feral_impulse_aura:IsAura()
    if IsServer() then
    	if self.caster:PassivesDisabled() then
    		return false
    	end
	
	   return true
    end
end

function modifier_imba_feral_impulse_aura:IsAuraActiveOnDeath()
	return false
end

function modifier_imba_feral_impulse_aura:IsDebuff()
	return false
end

function modifier_imba_feral_impulse_aura:IsHidden()
	return true
end

function modifier_imba_feral_impulse_aura:IsPermanent()
	return true
end

function  modifier_imba_feral_impulse_aura:IsPurgable()
	return false
end

-- Feral Impulse modifier
modifier_imba_feral_impulse = class({})

function modifier_imba_feral_impulse:OnCreated()	    
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.aura_buff = "modifier_imba_feral_impulse_aura"

    -- Ability specials
    self.base_bonus_damage_perc = self.ability:GetSpecialValueFor("base_bonus_damage_perc")
    self.damage_inc_per_unit = self.ability:GetSpecialValueFor("damage_inc_per_unit")          
    self.health_regen = self.ability:GetSpecialValueFor("health_regen")
    self.regen_inc_per_unit = self.ability:GetSpecialValueFor("regen_inc_per_unit")              

    -- Get the aura stacks
	self.feral_impulse_stacks = self.caster:GetModifierStackCount(self.aura_buff, self.caster)

	-- Start thinking
	self:StartIntervalThink(0.1)
end

function modifier_imba_feral_impulse:OnIntervalThink()
    -- Update the aura stacks
	self.feral_impulse_stacks = self.caster:GetModifierStackCount(self.aura_buff, self.caster)
end

function modifier_imba_feral_impulse:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
	
	return decFuncs	
end

function modifier_imba_feral_impulse:GetModifierBaseDamageOutgoing_Percentage()	 		
	-- Calculate damage percents
	local damage_perc_increase = self.base_bonus_damage_perc + self.damage_inc_per_unit * self.feral_impulse_stacks
	return damage_perc_increase		
end

function modifier_imba_feral_impulse:GetModifierConstantHealthRegen()	
	-- Calculate HP regeneration
	local health_increase = self.health_regen + self.regen_inc_per_unit * self.feral_impulse_stacks
	return health_increase	
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Lycan's Shapeshift
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_lycan_shapeshift = class({})
LinkLuaModifier("modifier_imba_shapeshift_transform_stun", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_transform", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_aura", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_certain_crit", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_lycan_7", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_shapeshift:GetAbilityTextureName()
   return "lycan_shapeshift"
end

-- Need this if player skills talent while dead
function imba_lycan_shapeshift:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_lycan_7") and self:GetCaster():FindAbilityByName("special_bonus_imba_lycan_7"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lycan_7") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_lycan_7", {})
	end
end

function imba_lycan_shapeshift:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Lycan.Shapeshift.Cast"
	local response_cast = "lycan_lycan_ability_shapeshift_"	
	local particle_cast = "particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf"
	local transform_buff = "modifier_imba_shapeshift_transform"
	local transform_stun = "modifier_imba_shapeshift_transform_stun"

	-- Ability specials
	local transformation_time = ability:GetSpecialValueFor("transformation_time")
	local duration = ability:GetSpecialValueFor("duration")	
	
	-- Start transformation gesture
	caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	
	-- Play random sound cast 1-10
	local random_sound = RandomInt(1,10)
	local correct_sound_num = ""
	if random_sound < 10 then
		correct_sound_num = "0"..tostring(random_sound)
	else
		correct_sound_num = random_sound
	end
	
	
	--Are we concerned about the identity of the dog releaser?
	local response_cast = response_cast .. correct_sound_num 	
	local who_let_the_dogs_out = 10
	
	if RollPercentage(who_let_the_dogs_out) then
		EmitSoundOn("Imba.LycanDogsOut", caster)
	else
		EmitSoundOn(response_cast, caster)
	end
	
	-- Play cast sound
	EmitSoundOn(sound_cast, caster)
	
	-- Add cast particle effects
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2 , caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , caster:GetAbsOrigin())
	
	-- Disable Lycan for the transform duration
	caster:AddNewModifier(caster, ability, transform_stun, {duration = transformation_time})
	
	-- Wait the transformation time
	Timers:CreateTimer(transformation_time, function()
		-- Give Lycan transform buff
		caster:AddNewModifier(caster, ability, transform_buff, {duration = duration})
	end)	
end

function imba_lycan_shapeshift:GetCooldown(level)	
	local caster = self:GetCaster()
	local ability = self
	local ability_level = ability:GetLevel()
	local base_cooldown = self.BaseClass.GetCooldown( self, level )			
	local wolfsbane_modifier = "modifier_imba_wolfsbane_lycan"			
	
	-- Get amount of Wolfsbane stacks
	if caster:HasModifier(wolfsbane_modifier) and not caster:PassivesDisabled() then
		local stacks = caster:GetModifierStackCount(wolfsbane_modifier, caster)
		
		-- Cooldown can't get lower than 0
		local final_cooldown = (base_cooldown - stacks)
		
		if final_cooldown < 0 then
			final_cooldown = 0
		end
		
		return final_cooldown
	end	
	
	return self.BaseClass.GetCooldown( self, level )			
end

-- Transform modifier (stuns Lycan so he can't do anything but channel his transformation)
modifier_imba_shapeshift_transform_stun = class({})

function modifier_imba_shapeshift_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_imba_shapeshift_transform_stun:IsHidden()
	return true
end

-- Transformation buff (changes model to wolf)
modifier_imba_shapeshift_transform = class({})

function modifier_imba_shapeshift_transform:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE}
		
		return decFuncs	
end

function modifier_imba_shapeshift_transform:GetModifierModelChange()
	return "models/heroes/lycan/lycan_wolf.vmdl"
end

function modifier_imba_shapeshift_transform:OnCreated()
    if IsServer() then
    	self.caster = self:GetCaster()
    	self.ability = self:GetAbility()
    	self.aura = "modifier_imba_shapeshift_aura"	 

    	if self.caster and not self.caster:HasModifier(self.aura) then
    		self.caster:AddNewModifier(self.caster, self.ability, self.aura, {})
    	end	
    end
end

function modifier_imba_shapeshift_transform:OnDestroy()
    if IsServer() then    	
    	local response_sound = "lycan_lycan_ability_revert_0" ..RandomInt(1,3)
    	local particle_revert = "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf"    	
    	local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
    	
    	-- Play one of the revert responses
    	EmitSoundOn(response_sound, self.caster)
    	
    	local particle_revert_fx = ParticleManager:CreateParticle(particle_revert, PATTACH_ABSORIGIN, self.caster)
    	ParticleManager:SetParticleControl(particle_revert_fx, 0, self.caster:GetAbsOrigin())
    	ParticleManager:SetParticleControl(particle_revert_fx, 3, self.caster:GetAbsOrigin())
    	
    	if self.caster:HasModifier(self.aura) then
    		self.caster:RemoveModifierByName(self.aura)
    	end		
    end
end

function modifier_imba_shapeshift_transform:IsHidden()
	return false
end

function modifier_imba_shapeshift_transform:IsPurgable()
	return false
end

function modifier_imba_shapeshift_transform:IsDebuff()
	return false
end

-- Speed/crit aura
modifier_imba_shapeshift_aura = class({})

function modifier_imba_shapeshift_aura:OnCreated()
    if IsServer() then
        self.caster = self:GetCaster()
    end
end

function modifier_imba_shapeshift_aura:AllowIllusionDuplicate()
	return false
end

function modifier_imba_shapeshift_aura:GetAuraRadius()
	return 25000 --global
end

function modifier_imba_shapeshift_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end

function modifier_imba_shapeshift_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_shapeshift_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_shapeshift_aura:GetModifierAura()
	return "modifier_imba_shapeshift"
end

function modifier_imba_shapeshift_aura:IsAura()
	return true	
end

function modifier_imba_shapeshift_aura:IsPurgable()
	return false
end

function modifier_imba_shapeshift_aura:IsHidden()
	return true
end

function modifier_imba_shapeshift_aura:GetAuraEntityReject(target)
    if IsServer() then	    	
    	if target:IsRealHero() then
    		if target == self.caster then		
    			return false
    		end
    	end
    	
    	if target:GetOwnerEntity() then
    		if target:GetOwnerEntity() == self.caster then
    			return false
    		end
    	end	
    		
    	return true
    end
end

-- Speed/crit modifier
modifier_imba_shapeshift = class({})

function modifier_imba_shapeshift:OnCreated()	
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
	self.parent = self:GetParent()    
	self.certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
    self.transform_buff = "modifier_imba_shapeshift_transform"

    -- Ability specials
    self.night_vision_bonus = self.ability:GetSpecialValueFor("night_vision_bonus")
    self.absolute_speed = self.ability:GetSpecialValueFor("absolute_speed")
    self.crit_chance = self.ability:GetSpecialValueFor("crit_chance")
    self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")       
    self.certain_crit_cooldown = self.ability:GetSpecialValueFor("certain_crit_cooldown")
		
    if IsServer() then
		if not self.parent:HasModifier(self.certain_crit_buff) then
			self.parent:AddNewModifier(self.caster, self.ability, self.certain_crit_buff, {})
		end
	end	
end

function modifier_imba_shapeshift:OnDestroy()
	if IsServer() then		
		if self.parent:HasModifier(self.certain_crit_buff) then
			self.parent:RemoveModifierByName(self.certain_crit_buff)
		end
	end	
end

function modifier_imba_shapeshift:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_shapeshift_buff.vpcf"
end

function modifier_imba_shapeshift:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_shapeshift:DeclareFunctions()
		local decFuncs = {MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
						  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
						  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
						  --MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT  -- #7 TALENT: Bonus movespeed property
						}		
		return decFuncs	
end

function modifier_imba_shapeshift:GetBonusNightVision()	
	return self.night_vision_bonus
end

function modifier_imba_shapeshift:GetModifierMoveSpeed_AbsoluteMin()
	-- #7 TALENT: Increases the movement speed cap of units affected by Shapeshift further
	if self.caster:HasTalent("special_bonus_imba_lycan_7") then
		return self.caster:FindTalentValue("special_bonus_imba_lycan_7", "max_movespeed")
	else  	
		return self.absolute_speed
	end
end

function modifier_imba_shapeshift:GetModifierPreAttack_CriticalStrike()
	if IsServer() then				
		-- Check for certain crit modifier, remove and start cooldown timer
		if self.parent:HasModifier(self.certain_crit_buff) then			
			self.parent:RemoveModifierByName(self.certain_crit_buff)	
			
			-- Renews the target's Certain Crit modifier if Lycan is still in his Shapeshift form.
			Timers:CreateTimer(self.certain_crit_cooldown, function()
				if self.caster:HasModifier(self.transform_buff) then
					self.parent:AddNewModifier(self.caster, self.ability, self.certain_crit_buff, {})
				end
			end)
			
			return self.crit_damage		
		end
		
		-- Roll a random for critical		
		if RollPercentage(self.crit_chance) then		
			return self.crit_damage
		end
		
		return nil
	end
end

function modifier_imba_shapeshift:OnDestroy()
	if IsServer() then
		if self.parent:HasModifier(self.certain_crit_buff) then
			self.parent:RemoveModifierByName(self.certain_crit_buff)
		end
	end
end


-- certain crit buff
modifier_imba_shapeshift_certain_crit = class({})

function modifier_imba_shapeshift_certain_crit:IsHidden()
	return false
end

function modifier_imba_shapeshift_certain_crit:IsPurgable()
	return false
end

function modifier_imba_shapeshift_certain_crit:IsDebuff()
	return false
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--				Lycan's Wolfsbane
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_lycan_wolfsbane = class({})
LinkLuaModifier("modifier_imba_wolfsbane_aura", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_wolves", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_lycan", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_lycan_prevent", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_talent", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_wolfsbane:GetAbilityTextureName()
   return "custom/wolfsbane"
end

function imba_lycan_wolfsbane:IsInnateAbility()
	return true
end

function imba_lycan_wolfsbane:OnUpgrade()
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self
	local aura = "modifier_imba_wolfsbane_aura"
	local lycan_modifier = "modifier_imba_wolfsbane_lycan"
	
	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end		
	
	if not caster:HasModifier(lycan_modifier) then
		caster:AddNewModifier(caster, ability, lycan_modifier, {})
	end	
end

-- Wolfsbane's aura
modifier_imba_wolfsbane_aura = class({})

function modifier_imba_wolfsbane_aura:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
end

function modifier_imba_wolfsbane_aura:DestroyOnExpire()
	return false
end

function modifier_imba_wolfsbane_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_wolfsbane_aura:GetAuraRadius()
	return 25000 --global
end

function modifier_imba_wolfsbane_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_wolfsbane_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_wolfsbane_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_wolfsbane_aura:GetModifierAura()
	return "modifier_imba_wolfsbane_wolves"
end

function modifier_imba_wolfsbane_aura:IsAura()
	if self.caster:PassivesDisabled() then
		return false
	end
	
	return true
end

function modifier_imba_wolfsbane_aura:IsAuraActiveOnDeath()
	return true
end

function modifier_imba_wolfsbane_aura:IsDebuff()
	return false
end

function modifier_imba_wolfsbane_aura:IsHidden()
	return true
end

function modifier_imba_wolfsbane_aura:IsPermanent()
	return true
end

function  modifier_imba_wolfsbane_aura:IsPurgable()
	return false
end

function modifier_imba_wolfsbane_aura:GetAuraEntityReject(target)	
	local scepter = self.caster:HasScepter()
	
	-- Reset variable	
	local wolf_found
	
	-- Deny caster, as Lycan has his own modifier
	if target == self.caster then
		return true
	end
	
	-- Define wolves name
	local wolf_name = "npc_lycan_wolf"	 
	local full_name = ""
	
	-- Cycle through wolves names to get a match
	 for i= 1, 6 do
		full_name = wolf_name..i
		if full_name == target:GetUnitName() then
			 wolf_found = true
		 end	
	 end	
	
	-- Accept aura if this is a wolf
	if wolf_found then
		return false --DO NOT REJECT aura from wolves
	end
	
	if scepter then -- Scepter affects all units and heroes globally and grants them the aura
		return false
	end
	
	return true
end


-- Wolfsbane modifier (wolves or anyone if Lycan holds a scepter)
modifier_imba_wolfsbane_wolves = class({})

function modifier_imba_wolfsbane_wolves:OnCreated()	
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.wolf = self:GetParent()		

        -- Ability specials
        self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")

    if IsServer() then
        -- Start thinking
        self:StartIntervalThink(0.5)
	end	
end

function modifier_imba_wolfsbane_wolves:OnRefresh()
    self:OnCreated()
end

function modifier_imba_wolfsbane_wolves:OnIntervalThink()				
	if self.caster:HasModifier("modifier_imba_wolfsbane_lycan") then
		self:SetStackCount(self.caster:FindModifierByName("modifier_imba_wolfsbane_lycan"):GetStackCount())
	end
end

function modifier_imba_wolfsbane_wolves:IsHidden()	
	return false
end

function modifier_imba_wolfsbane_wolves:IsPurgable()
	return false
end

function modifier_imba_wolfsbane_wolves:IsPermanent()
	return true
end

function modifier_imba_wolfsbane_wolves:DeclareFunctions()	
	local decFuncs = {	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					}
	
	return decFuncs	
end

function modifier_imba_wolfsbane_wolves:GetModifierPreAttack_BonusDamage()		
	local stacks = self:GetStackCount()	
	
	if self:GetParent():PassivesDisabled() then
		return nil
	end	
	
	return self.damage_bonus * stacks
end

-- Wolfsbane modifier (lycan)
modifier_imba_wolfsbane_lycan = class({})

function modifier_imba_wolfsbane_lycan:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.aura = "modifier_imba_wolfsbane_aura"
    self.prevent_modifier = "modifier_imba_wolfsbane_lycan_prevent"
    self.sound_howl = "Imba.LycanWolfsbane" 

    -- Ability specials
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.minimum_allies_required = self.ability:GetSpecialValueFor("minimum_allies_required")
    self.prevent_modifier_duration = self.ability:GetSpecialValueFor("prevent_modifier_duration")
    self.scepter_radius = self.ability:GetSpecialValueFor("scepter_radius")
    self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus")

    -- Start thinking
    self:StartIntervalThink(0.5)
end

function modifier_imba_wolfsbane_lycan:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					  MODIFIER_EVENT_ON_HERO_KILLED,
					  MODIFIER_PROPERTY_TOOLTIP
					}
	
	return decFuncs	
end

function modifier_imba_wolfsbane_lycan:OnHeroKilled( keys )
	if IsServer() then		
		local killed_hero = keys.target		
		local scepter = self.caster:HasScepter()
		
		if self.caster:PassivesDisabled() then
			return nil
		end
		
		if self.caster:GetTeamNumber() ~= killed_hero:GetTeamNumber() then -- an enemy was killed
			
			-- Search to see if Lycan is nearby, initialize variables
			local lycan_nearby = false
			local should_grants_stacks = false
			
			local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
											killed_hero:GetAbsOrigin(),
											nil,
											self.radius,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
											FIND_ANY_ORDER,
											false)
			
			-- Look for Lycan
			for _, unit in pairs(units) do 
				if unit == self.caster then -- Lycan was found
					lycan_nearby = true					
				end
			end
			
			-- If Lycan is present nearby and at least the minimum allies required are present, give stacks			
			if #units >= self.minimum_allies_required + 1 and lycan_nearby and self.caster:HasModifier(self.aura) and not self.caster:HasModifier(self.prevent_modifier) then			
				should_grants_stacks = true
			end
			
			-- If Lycan has a scepter and did not benefit from the kill, check for nearby allies and give stacks if enough are present
			if scepter then
					local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
    												killed_hero:GetAbsOrigin(),
    												nil,
    												self.scepter_radius,
    												DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    												DOTA_UNIT_TARGET_FLAG_NONE,
    												FIND_ANY_ORDER,
    												false)
													
				if #units >= self.minimum_allies_required and self.caster:HasModifier(self.aura) and not self.caster:HasModifier(self.prevent_modifier) then			
					should_grants_stacks = true
				end
			end
			
			if should_grants_stacks then
				-- Play howl sound
				EmitSoundOn(self.sound_howl, self.caster)				
				self:IncrementStackCount()
				self.caster:AddNewModifier(self.caster, self.ability, self.prevent_modifier, {duration = self.prevent_modifier_duration})

				-- #8 TALENT: Searches through all of Lycan's unit and gives them a buff modifier
				if self.caster:HasTalent("special_bonus_imba_lycan_8") then
					local units = FindUnitsInRadius(self.caster:GetTeamNumber(),
														 self.caster:GetAbsOrigin(),
														 nil, 
														 25000,  		-- Global 
														 DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
														 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
														 DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 
														 FIND_ANY_ORDER,
														 false)

					for _,unit in pairs(units) do
						-- Give Lycan's units the buff
						if unit:GetOwnerEntity() == self.caster then
							unit:AddNewModifier(self.caster, self.ability, "modifier_imba_wolfsbane_talent", {duration = self.caster:FindTalentValue("special_bonus_imba_lycan_8", "duration")})
						end
						-- Give Lycan the buff
						self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_wolfsbane_talent", {duration = self.caster:FindTalentValue("special_bonus_imba_lycan_8", "duration")})
					end
				end	
			end
		end		
	end	
end

function modifier_imba_wolfsbane_lycan:GetModifierPreAttack_BonusDamage()
	local stacks = self:GetStackCount()

	local damage_bonus = self.damage_bonus 
	
	if self.caster:PassivesDisabled() then
		return nil
	end
	
	return damage_bonus * stacks
end

function modifier_imba_wolfsbane_lycan:IsHidden()
	return false
end

function modifier_imba_wolfsbane_lycan:IsPurgable()
	return false
end

function modifier_imba_wolfsbane_lycan:IsPermanent()
	return true
end

function modifier_imba_wolfsbane_lycan:OnTooltip()
	return self:GetStackCount()
end

--Lycan wolfsbane prevent modifier
modifier_imba_wolfsbane_lycan_prevent = class({})

function modifier_imba_wolfsbane_lycan_prevent:IsHidden()
	return false
end

function modifier_imba_wolfsbane_lycan_prevent:IsPurgable()
	return false
end

function modifier_imba_wolfsbane_lycan_prevent:IsDebuff()
	return false
end

--- #8 TALENT: Modifier
modifier_imba_wolfsbane_talent = modifier_imba_wolfsbane_talent or class({})

-- Modifier properties
function modifier_imba_wolfsbane_talent:IsHidden() return false end
function modifier_imba_wolfsbane_talent:IsPurgable()	return false end
function modifier_imba_wolfsbane_talent:IsDebuff() return false end

function modifier_imba_wolfsbane_talent:OnCreated()
	local caster 	=	self:GetCaster()
	-- Bonuses values
	self.movespeed_bonus	=	caster:FindTalentValue("special_bonus_imba_lycan_8", "bonus_movespeed_pct")
	self.damage_bonus		=	caster:FindTalentValue("special_bonus_imba_lycan_8", "bonus_damage_pct")
	self.attackspeed_bonus	=	caster:FindTalentValue("special_bonus_imba_lycan_8", "bonus_attackspeed")	
end

function modifier_imba_wolfsbane_talent:DeclareFunctions()
	local funcs ={
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
	return funcs 
end

function modifier_imba_wolfsbane_talent:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus
end

function modifier_imba_wolfsbane_talent:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_bonus
end

function modifier_imba_wolfsbane_talent:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		Lycan's Wolves' Wicked Crunch
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_summoned_wolf_wicked_crunch = class({})
LinkLuaModifier("modifier_imba_summoned_wolf_wicked_crunch_debuff", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summoned_wolf_wicked_crunch", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summoned_wolf_wicked_crunch_damage", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_wicked_crunch:GetAbilityTextureName()
   return "lycan_summon_wolves_critical_strike"
end

function imba_summoned_wolf_wicked_crunch:GetIntrinsicModifierName()
	return "modifier_imba_summoned_wolf_wicked_crunch"
end

-- Wolf attack modifier
modifier_imba_summoned_wolf_wicked_crunch = class({})

function modifier_imba_summoned_wolf_wicked_crunch:OnCreated()
    if IsServer() then
        -- Ability properties
        self.caster = self:GetCaster()
        self.ability = self:GetAbility()   
        self.debuff = "modifier_imba_summoned_wolf_wicked_crunch_debuff"
        self.certain_crit = "modifier_imba_shapeshift_certain_crit"    

        -- Ability specials 
		self.duration = self.ability:GetSpecialValueFor("duration")     
    end
end

function modifier_imba_summoned_wolf_wicked_crunch:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_summoned_wolf_wicked_crunch:IsDebuff()
	return false	
end

function modifier_imba_summoned_wolf_wicked_crunch:IsHidden()
	return true	
end

function modifier_imba_summoned_wolf_wicked_crunch:IsPurgable()
	return false	
end

function modifier_imba_summoned_wolf_wicked_crunch:DeclareFunctions()	
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}
	
	return decFuncs	
end

function modifier_imba_summoned_wolf_wicked_crunch:OnAttackLanded (keys)	
	if IsServer() then		
		local target = keys.target		
		local owner = nil
		
		-- Set wolves' owner
		if self.caster:GetOwnerEntity() then -- Some weird error, might be because of wolves dying from an attack on them
			owner = self.caster:GetOwnerEntity() -- Get Lycan, or Rubick if stolen			
		end		
		
		-- If wolves are the attackers, grant modifier or increment stacks if already present.
		if self.caster == keys.attacker then
			if keys.attacker:PassivesDisabled() then
				return nil
			end
			
			-- If wolves are attacking a building, do nothing
			if target:IsBuilding() then
				return nil
			end
			
			-- Inflict modifier on enemy.
			target:AddNewModifier(self.caster, self.ability, self.debuff, {duration = self.duration})			
            target:AddNewModifier(self.caster, self.ability, "modifier_imba_summoned_wolf_wicked_crunch_damage", {duration = self.duration})			

		end
		
		-- If Lycan attacked, consume all stacks and deal bonus damage if present
		if owner and owner == keys.attacker and not owner.has_attacked_for_many_wolves_interaction then	
			if target:HasModifier(self.debuff) then
				local damage_bonus_per_stack = self.ability:GetSpecialValueFor("damage_bonus_per_stack") 
        		local max_stacks = self.ability:GetSpecialValueFor("max_stacks")
				
				-- Refresh the debuff modifier
				target:AddNewModifier(self.caster, self.ability, self.debuff, {duration = self.ability:GetSpecialValueFor("duration"), lycan_attack = true})

				-- Consumes damage debuff and deals damage
				local bonus_damage_modifier = target:FindModifierByName("modifier_imba_summoned_wolf_wicked_crunch_damage")
				if bonus_damage_modifier then
					local bonus_damage_stacks	= #bonus_damage_modifier.stacks_table
					local damage = damage_bonus_per_stack * bonus_damage_stacks	
					if bonus_damage_stacks	 >= max_stacks then
						SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, damage, nil)
					end
					-- Deal bonus damage
					local damageTable = {victim = target,
										attacker = owner,
										damage = damage,
										damage_type = DAMAGE_TYPE_PHYSICAL}

					ApplyDamage(damageTable)

					-- Consume the debuff
					bonus_damage_modifier:Destroy()
				end		
			end
				
			-- Fixes having this activate for each wolf
			owner.has_attacked_for_many_wolves_interaction = true	
			Timers:CreateTimer(FrameTime(), function() 
				owner.has_attacked_for_many_wolves_interaction = false
			end)	
		end
	end
end

-- Crunch debuff
modifier_imba_summoned_wolf_wicked_crunch_debuff = class({})

function modifier_imba_summoned_wolf_wicked_crunch_debuff:OnCreated(params)	
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()		
		self.ability = self:GetAbility()
		self.duration = params.duration										
		
		if not params.lycan_attack then
			-- Initialize table
			self.stacks_table = {}

			if not params.lycan_attack then
				-- Insert stack
				table.insert(self.stacks_table, GameRules:GetGameTime())
			end								

			-- Start thinking
			self:StartIntervalThink(0.1)

			self.owner = self.caster:GetOwnerEntity()
			
			-- #6 Talent (wolves generate two stacks per attack)            
       		 if self.owner:HasTalent("special_bonus_imba_lycan_6") and not params.lycan_attack then
				table.insert(self.stacks_table, GameRules:GetGameTime())
			end

		end
	end
	-- Ability specials
	if self:GetAbility() then
		self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:OnRefresh(params)
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()		
		self.ability = self:GetAbility()
		self.duration = params.duration										
		self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")
		self.owner = self.caster:GetOwnerEntity()

		-- #6 Talent: Double max stacks count
		if self.owner:HasTalent("special_bonus_imba_lycan_6") then
			self.max_stacks = self.max_stacks * self.owner:FindTalentValue("special_bonus_imba_lycan_6") * 0.01
		end

		if not params.lycan_attack then

			-- Insert stack
			table.insert(self.stacks_table, GameRules:GetGameTime())
			-- Remove old stack if limit has been reached
			if #self.stacks_table > self.max_stacks then
				table.remove(self.stacks_table, 1)
			end								

			
			-- #6 Talent (wolves generate two stacks per attack)            
      	 	if self.owner:HasTalent("special_bonus_imba_lycan_6") then
				table.insert(self.stacks_table, GameRules:GetGameTime())
       	 	end
			-- Remove old stack if limit has been reached
			if #self.stacks_table > self.max_stacks then
				table.remove(self.stacks_table, 1)
			end	

		else 
			-- Refresh stacks
			for i=1, #self.stacks_table do 
				table.remove(self.stacks_table, i)
				table.insert(self.stacks_table, GameRules:GetGameTime())
			end
		end
	end
	-- Ability specials
	if self:GetAbility() then
		self.attack_speed_reduction = self:GetAbility():GetSpecialValueFor("attack_speed_reduction")
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = 1, #self.stacks_table do
            	if self.stacks_table[i] then
             	   if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
                		if self.stacks_table then 
                   			table.remove(self.stacks_table, i)
                   		end
                   	end
                else
                	i = #self.stacks_table
                end
            end

            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end
		end
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture_nuke.vpcf"
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetTexture()
	return "lycan_summon_wolves_critical_strike"
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:IsDebuff()
	return true	
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:IsHidden()
	return false
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:IsPurgable()
	return true
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_PROVIDES_FOW_POSITION} -- #5 TALENT: FOW position property
		
	return decFuncs	
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetModifierAttackSpeedBonus_Constant()	
	return (self.attack_speed_reduction * (-1) * self:GetStackCount())
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetModifierProvidesFOWVision()
	if IsServer() then
		local owner = self.caster:GetOwnerEntity()
		-- #5 TALENT: Targets provide FOW vision when they have 6 stacks of wicked crunch
		if owner:HasTalent("special_bonus_imba_lycan_5") then
			if self:GetStackCount() >= owner:FindTalentValue("special_bonus_imba_lycan_5") then
				return 1
			else
				return 0
			end
		else
			return 0
		end
	end
end

--- BURST DAMAGE DEBUFF
modifier_imba_summoned_wolf_wicked_crunch_damage = modifier_imba_summoned_wolf_wicked_crunch_damage or class({})

-- Modifier properties
function modifier_imba_summoned_wolf_wicked_crunch_damage:IsDebuff() 	return true end
function modifier_imba_summoned_wolf_wicked_crunch_damage:IsHidden() 	return false end
function modifier_imba_summoned_wolf_wicked_crunch_damage:IsPurgable() 	return true end

function modifier_imba_summoned_wolf_wicked_crunch_damage:OnCreated(params)	
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()		
		self.ability = self:GetAbility()
		self.duration = params.duration

		if not params.lycan_attack then
			-- Initialize table
			self.stacks_table = {}

			if not params.lycan_attack then
				-- Insert stack
				table.insert(self.stacks_table, GameRules:GetGameTime())
			end								

			-- Start thinking
			self:StartIntervalThink(0.1)

			self.owner = self.caster:GetOwnerEntity()
			
			-- #6 Talent (wolves generate two stacks per attack)            
       		 if self.owner:HasTalent("special_bonus_imba_lycan_6") and not params.lycan_attack then
				table.insert(self.stacks_table, GameRules:GetGameTime())
       	 	end

		end
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_damage:OnRefresh(params)
	if IsServer() then	
		-- Ability properties
		self.caster = self:GetCaster()		
		self.ability = self:GetAbility()
		self.attack_speed_reduction = self.ability:GetSpecialValueFor("attack_speed_reduction")
		self.duration = params.duration

		-- Ability specials												
		self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")	

		-- #6 Talent: Double max stacks count
		if self.owner:HasTalent("special_bonus_imba_lycan_6") then
			self.max_stacks = self.max_stacks * self.owner:FindTalentValue("special_bonus_imba_lycan_6") * 0.01
		end

		-- Insert stack
		table.insert(self.stacks_table, GameRules:GetGameTime())

       	-- Remove old stack if limit has been reached
		if #self.stacks_table > self.max_stacks then
			table.remove(self.stacks_table, 1)
		end								

		self.owner = self.caster:GetOwnerEntity()
			
		-- #6 Talent (wolves generate two stacks per attack)            
      	if self.owner:HasTalent("special_bonus_imba_lycan_6") and self:GetStackCount() < self.max_stacks then
		 	 table.insert(self.stacks_table, GameRules:GetGameTime())
       	end
       	-- Remove old stack if limit has been reached
       	if #self.stacks_table > self.max_stacks then
			table.remove(self.stacks_table, 1)
		end	
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_damage:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
        if #self.stacks_table > 0 then

            -- For each stack, check if it is past its expiration time. If it is, remove it from the table
            for i = 1, #self.stacks_table do
            	if self.stacks_table[i] then
             	   if self.stacks_table[i] + self.duration < GameRules:GetGameTime() then
                		if self.stacks_table then 
                   			table.remove(self.stacks_table, i)
                   		end
                   	end
                else
                	i = #self.stacks_table
                end
            end

            -- If after removing the stacks, the table is empty, remove the modifier.
            if #self.stacks_table == 0 then
                self:Destroy()

            -- Otherwise, set its stack count
            else
                self:SetStackCount(#self.stacks_table)
            end
		end
	end
end

function modifier_imba_summoned_wolf_wicked_crunch_damage:DeclareFunctions()
	local funcs ={
					MODIFIER_PROPERTY_TOOLTIP 
				}
	return funcs
end

-- Tooltip to show how much damage he will take
function modifier_imba_summoned_wolf_wicked_crunch_damage:OnTooltip()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_bonus_per_stack")
end

function modifier_imba_summoned_wolf_wicked_crunch_damage:GetTexture()
	return "custom/summoned_wolf_deep_claws"
end

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		Lycan's Wolves' Hunter Instincts
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_summoned_wolf_hunter_instincts = class({})
LinkLuaModifier("modifier_imba_summoned_wolf_hunter_instincts", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_hunter_instincts:GetAbilityTextureName()
   return "custom/hunter_instincts"
end

function imba_summoned_wolf_hunter_instincts:GetIntrinsicModifierName()
    return "modifier_imba_summoned_wolf_hunter_instincts"
end

-- Hunter instincts buff
modifier_imba_summoned_wolf_hunter_instincts = class({})

function modifier_imba_summoned_wolf_hunter_instincts:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()   

    -- Ability specials
    self.evasion = self.ability:GetSpecialValueFor("evasion")
end

function modifier_imba_summoned_wolf_hunter_instincts:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_EVASION_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_summoned_wolf_hunter_instincts:GetModifierEvasion_Constant()
	if self.caster:PassivesDisabled() then
		return nil
	end	
	
	return self.evasion
end

function modifier_imba_summoned_wolf_hunter_instincts:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_summoned_wolf_hunter_instincts:IsDebuff()
	return false	
end

function modifier_imba_summoned_wolf_hunter_instincts:IsHidden()
	return true	
end

function modifier_imba_summoned_wolf_hunter_instincts:IsPurgable()
	return false	
end



---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		Lycan's Wolves' Invisibility
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


imba_summoned_wolf_invisibility = class({})
LinkLuaModifier("modifier_imba_summoned_wolf_invisibility_fade", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summoned_wolf_invisibility", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_invisibility:GetAbilityTextureName()
   return "lycan_summon_wolves_invisibility"
end

function imba_summoned_wolf_invisibility:OnUpgrade()
	 if IsServer() then
		 local caster = self:GetCaster()
		 local ability = self	 
		 local buff = "modifier_imba_summoned_wolf_invisibility_fade"
		 local fade_time = ability:GetSpecialValueFor("fade_time")
		 
		 if not caster:HasModifier(buff) then
			caster:AddNewModifier(caster, ability, buff, {duration = fade_time})
		 end
	end
end

-- Invisibility fade buff
modifier_imba_summoned_wolf_invisibility_fade = class({})

function modifier_imba_summoned_wolf_invisibility_fade:IsDebuff()
	return false	
end

function modifier_imba_summoned_wolf_invisibility_fade:IsHidden()
	return true	
end

function modifier_imba_summoned_wolf_invisibility_fade:IsPurgable()
	return false	
end

function modifier_imba_summoned_wolf_invisibility_fade:OnCreated()
	if IsServer() then
		self.caster = self:GetParent()
		self.ability = self:GetAbility()
        self.invis_buff = "modifier_imba_summoned_wolf_invisibility"       
	end
end

function modifier_imba_summoned_wolf_invisibility_fade:OnDestroy()
	if IsServer() then		
		self.caster:AddNewModifier(self.caster, self.ability, self.invis_buff, {})
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_invisible", {})
	end
end

function modifier_imba_summoned_wolf_invisibility_fade:DeclareFunctions()	
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FINISHED}
	
	return decFuncs	
end

function modifier_imba_summoned_wolf_invisibility_fade:OnAttackFinished( keys )
	if self.caster == keys.attacker then		
		self:ForceRefresh()
	end
end

-- Actual invisibility buff
modifier_imba_summoned_wolf_invisibility = class({})

function modifier_imba_summoned_wolf_invisibility:OnCreated()
    -- Ability properties
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()   
    self.invis_fade = "modifier_imba_summoned_wolf_invisibility_fade"

    -- Ability specials
    self.fade_time = self.ability:GetSpecialValueFor("fade_time")
end

function modifier_imba_summoned_wolf_invisibility:IsDebuff()
	return false	
end

function modifier_imba_summoned_wolf_invisibility:IsHidden()
	return true	
end

function modifier_imba_summoned_wolf_invisibility:IsPurgable()
	return false	
end

function modifier_imba_summoned_wolf_invisibility:DeclareFunctions()	
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FINISHED}
	
	return decFuncs	
end

function modifier_imba_summoned_wolf_invisibility:OnAttackFinished(keys)
	if IsServer() then
		if self.caster == keys.attacker then			
			self.caster:RemoveModifierByName("modifier_invisible")
			self.caster:AddNewModifier(self.caster, self.ability, self.invis_fade, {duration = self.fade_time})
			self:Destroy()
		end
	end
end

-------------------------------------------------------------
------    #3 TALENT: Alpha Wolf's Packleader aura    -------
-------------------------------------------------------------
imba_summoned_wolf_pack_leader = imba_summoned_wolf_pack_leader or class({})
LinkLuaModifier("modifier_imba_talent_wolf_packleader_aura", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_talent_wolf_packleader", "components/abilities/heroes/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_pack_leader:GetIntrinsicModifierName()	
    return "modifier_imba_talent_wolf_packleader_aura"
end

modifier_imba_talent_wolf_packleader_aura = modifier_imba_talent_wolf_packleader_aura or class({})

-- Modifier properties
function modifier_imba_talent_wolf_packleader_aura:IsAura()					return true end
function modifier_imba_talent_wolf_packleader_aura:IsAuraActiveOnDeath()	return false end
function modifier_imba_talent_wolf_packleader_aura:IsDebuff() 				return false end
function modifier_imba_talent_wolf_packleader_aura:IsHidden() 				return true end
function modifier_imba_talent_wolf_packleader_aura:IsPermanent()			return true end
function modifier_imba_talent_wolf_packleader_aura:IsPurgable()				return false end

function modifier_imba_talent_wolf_packleader_aura:OnCreated()
	local ability	=	self:GetAbility()
	self.radius 	=	ability:GetSpecialValueFor("aura_radius")
end

-- Aura properties
function modifier_imba_talent_wolf_packleader_aura:GetAuraRadius() return
	self.radius 
end

function modifier_imba_talent_wolf_packleader_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_talent_wolf_packleader_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_talent_wolf_packleader_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_talent_wolf_packleader_aura:GetModifierAura()
	return "modifier_imba_talent_wolf_packleader"
end

modifier_imba_talent_wolf_packleader = modifier_imba_talent_wolf_packleader or class({})

-- Modifier properties
function modifier_imba_talent_wolf_packleader:IsDebuff() 	return false end
function modifier_imba_talent_wolf_packleader:IsHidden() 	return false end
function modifier_imba_talent_wolf_packleader:IsPurgable()	return false end

function modifier_imba_talent_wolf_packleader:OnCreated() 
	local ability	=	self:GetAbility()
	self.bonus_damage_pct	=	ability:GetSpecialValueFor("aura_bonus_damage_pct")
end

function modifier_imba_talent_wolf_packleader:DeclareFunctions()
	local funcs ={
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
}
	return funcs 
end

function modifier_imba_talent_wolf_packleader:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage_pct
end

-- Talent #7: Shapeshift Move Speed Cap Increase (need this modifier for client-side viewing)
modifier_special_bonus_imba_lycan_7 = class ({})

function modifier_special_bonus_imba_lycan_7:IsHidden() 		return true end
function modifier_special_bonus_imba_lycan_7:IsPurgable()		return false end
function modifier_special_bonus_imba_lycan_7:RemoveOnDeath()	return false end
