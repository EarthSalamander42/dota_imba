-- Adds [stack_amount] stacks to a lua-based modifier
function AddStacksLua(ability, caster, unit, modifier, stack_amount, refresh)
    if unit:HasModifier(modifier) then
        if refresh then
            unit:AddNewModifier(caster, ability, modifier, {})
        end
        unit:SetModifierStackCount(modifier, ability, unit:GetModifierStackCount(modifier, nil) + stack_amount)
    else
        unit:AddNewModifier(caster, ability, modifier, {})
        unit:SetModifierStackCount(modifier, ability, stack_amount)
    end
end

CreateEmptyTalents("lycan")


-- Author: Shush
-- Date: 17/01/2017
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Lycan's Summon Wolves
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


imba_lycan_summon_wolves = class({})
LinkLuaModifier("modifier_imba_lycan_wolf_charge", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lycan_wolf_death_check", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)


function imba_lycan_summon_wolves:OnUpgrade()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local charges_buff = "modifier_imba_lycan_wolf_charge"	
	
	-- Ability specials
	local charge_cooldown = ability:GetSpecialValueFor("charge_cooldown")
	local max_charges = ability:GetSpecialValueFor("max_charges")	
	
	-- #5 Talent extra max charges	
	max_charges = max_charges + caster:FindTalentValue("special_bonus_imba_lycan_5")	
	
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
	
	
	-- #1 Talent: wolves upgrade by one level			
	wolf_type = wolf_type + caster:FindTalentValue("special_bonus_imba_lycan_1")
	
	-- #5 Talent: Increase wolves count	
	wolves_count = wolves_count + caster:FindTalentValue("special_bonus_imba_lycan_5")
	
	
	-- Fine and kill any living wolves on the map
	local creatures = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									50000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
		
	
	-- Iterate between all wolf levels to make sure all of them are dead
	for _,creature in pairs(creatures) do -- check each friendly player controlled creep
		for i = 1, 6 do						
			if creature:GetUnitName() == wolf_name..i then -- if it's a wolf, kill it
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
		
		-- If wolf is Shadow Wolf/Nightclaw (level 5 or 6) paint in grey/black texture
		if wolf_type >= 5 then
			wolf:SetRenderColor(49, 49, 49)			
		end
		
	end	
end



-- Charge modifier
modifier_imba_lycan_wolf_charge = class({}) 

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
	return false
end

function modifier_imba_lycan_wolf_charge:OnCreated()
	-- Ability properties	
	local ability = self:GetAbility()	
	
	-- Ability specials
	local charge_cooldown = ability:GetSpecialValueFor("charge_cooldown")	
			
	self:StartIntervalThink(charge_cooldown-0.01)
end

function modifier_imba_lycan_wolf_charge:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()	
		local stacks = self:GetStackCount()				
		
		-- Ability specials
		local max_charges = ability:GetSpecialValueFor("max_charges")
		local charge_cooldown = ability:GetSpecialValueFor("charge_cooldown")
		local wolves_count = ability:GetSpecialValueFor("wolves_count")				
		
		
		-- #5 Talent: extra max charges and wolves		
		max_charges = max_charges + caster:FindTalentValue("special_bonus_imba_lycan_5")
		wolves_count = wolves_count + caster:FindTalentValue("special_bonus_imba_lycan_5")		
		
		-- if we're not at maximum charges yet, refresh it		
		if stacks < max_charges then
		
			-- Increase stack and restart duration
			self:ForceRefresh()							
			self:IncrementStackCount()										
			
			-- Only start charge cooldown if the new stack doesn't reach the maximum allowed			
			if stacks < max_charges-1 then
				self:SetDuration(charge_cooldown, true)		
			else			
				-- Disable interval, disable duration
				self:SetDuration(-1, true)		
				self:StartIntervalThink(-1)
			end						
		end				
		
		-- count wolves, if there are missing wolves, revive one
		local wolves = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									25000, -- global
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
		
		if #wolves < wolves_count and caster:IsAlive() then
			ReviveWolves(caster, ability)
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

function modifier_imba_lycan_wolf_death_check:OnDeath( keys )
	-- Ability properties				
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local wolf = self:GetParent()
	local unit = keys.unit
		
	-- Revive only when it was a wolf that just died
	if unit == wolf then
		-- Only revive wolves that weren't killed due to resummon
		if not wolf.killed_by_resummon then			
			ReviveWolves(caster, ability)
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
				Timers:CreateTimer(0.01, function()
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




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--				Lycan's Howl
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------



imba_lycan_howl = class ({})
LinkLuaModifier("modifier_imba_howl_buff", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

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
	
	-- #3 Talent howl duration	
	duration = duration + caster:FindTalentValue("special_bonus_imba_lycan_3")	
		
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
									50000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
		
		
	
	for _,creature in pairs(creatures) do 
		for i = 1, 6 do						
			if creature:GetUnitName() == wolf_name..i then 
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
			end	
		end
	end	
	
	
	-- Find all allies (except lane creeps) and give them the buff
	local allies = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									50000,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
									FIND_ANY_ORDER,
									false)
									
	for _, ally in pairs(allies) do		
		ally:AddNewModifier(caster, ability, buff, {duration = duration})	
		--Heroes gain max HP, but current HP stays the same, which makes it seems like they were damaged.
		if day then
			ally:Heal(bonus_health_heroes, caster) 
		else
			ally:Heal(bonus_health_heroes * 2, caster)
		end
		
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

function modifier_imba_howl_buff:GetEffectName()
	return "particles/units/heroes/hero_lycan/lycan_howl_buff.vpcf"
end

function modifier_imba_howl_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_howl_buff:DeclareFunctions()		
		local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
						  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
						  MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS						  
						  }		
		return decFuncs			
end

function modifier_imba_howl_buff:GetModifierBaseAttack_BonusDamage()
	if IsServer() then	
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local day = GameRules:IsDaytime()
		
		-- Ability specials
		local bonus_damage_hero = ability:GetSpecialValueFor("bonus_damage_hero")
		local bonus_damage_units = ability:GetSpecialValueFor("bonus_damage_units")		
		
		-- #7 Talent: Increased damage		
		bonus_damage_hero = bonus_damage_hero + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "damage_hero")
		bonus_damage_units = bonus_damage_units + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "damage_creep")		
		
		-- If hero, give appropriate hero damage bonus, else creep damage
		if parent:IsHero() then
			if day then
				return bonus_damage_hero
			else
				return bonus_damage_hero * 2		
			end
		end
		
		if day then
			return bonus_damage_units
		end
		
		return bonus_damage_units * 2	
	end
end

function modifier_imba_howl_buff:GetModifierExtraHealthBonus()
	if IsServer() then		
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local day = GameRules:IsDaytime()
		
		-- Ability specials
		local bonus_health_heroes = ability:GetSpecialValueFor("bonus_health_heroes")
		local bonus_health_units = ability:GetSpecialValueFor("bonus_health_units")		
		
		-- #7 Talent: Increased health		
		bonus_health_heroes = bonus_health_heroes + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "health_hero")
		bonus_health_units = bonus_health_units + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "health_creep")		
		
		-- If hero, give appropriate hero health bonus based on current day cycle
		if parent:IsHero() then
			if GameRules:IsDaytime() then
				return bonus_health_heroes
			else
				return bonus_health_heroes * 2
			end
		end
		
		if GameRules:IsDaytime() then
			return bonus_health_units	
		end
		
		return bonus_health_units * 2
	end
end


function modifier_imba_howl_buff:GetModifierMoveSpeedBonus_Constant()
	-- Ability properties	
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local parent = self:GetParent()	
	
	--Get daytime value
	local day = IsDaytime()
	
	-- Ability specials
	local bonus_ms_heroes = ability:GetSpecialValueFor("bonus_ms_heroes")
	local bonus_ms_units = ability:GetSpecialValueFor("bonus_ms_units")				
	
	-- #7 Talent: Increase move speed
	bonus_ms_heroes = bonus_ms_heroes + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "ms_hero")
	bonus_ms_units = bonus_ms_units + caster:FindSpecificTalentValue("special_bonus_imba_lycan_7", "ms_creep")				

	-- If hero, give appropriate hero move speed bonus based on current day cycle
	if parent:IsHero() then					
		if day then									
			return bonus_ms_heroes
		else									
			return bonus_ms_heroes * 2
		end		
	end
	
	if day then		
		return bonus_ms_units		
	end
	
	return bonus_ms_units * 2		
end



function modifier_imba_howl_buff:CheckState()
	if IsServer() then
		local day = GameRules:IsDaytime()
		
		if not GameRules:IsDaytime() then
			local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
			return state
		end	
			return nil
	end
	
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--			Lycan's Feral Impulse
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_lycan_feral_impulse = class({})
LinkLuaModifier("modifier_imba_feral_impulse_aura", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_feral_impulse", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_lycan_feral_impulse:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local aura_buff = "modifier_imba_feral_impulse_aura"	
	if not caster:HasModifier(aura_buff) then
		caster:AddNewModifier(caster, ability, aura_buff, {})
	end
end

-- Feral Impulse aura
modifier_imba_feral_impulse_aura = class({})

function modifier_imba_feral_impulse_aura:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_imba_feral_impulse_aura:OnIntervalThink()
	if IsServer() then
			--Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()	
		
		-- Ability specials
		local base_bonus_damage_perc = ability:GetSpecialValueFor("base_bonus_damage_perc")
		local damage_inc_per_unit = ability:GetSpecialValueFor("damage_inc_per_unit")
		local aura_radius = ability:GetSpecialValueFor("aura_radius")
		local hero_inc_multiplier = ability:GetSpecialValueFor("hero_inc_multiplier") 		
		
		-- Set variable
		local value_increase = 0		
		
		-- Find all units and heroes around caster (Lycan). Ignore Lycan and illusions.	
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										aura_radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
										FIND_ANY_ORDER,
										false)
		
		-- For every unit, increase the value. If it's a hero, double that value increase.		
		for _, unit in pairs(units) do
			if unit ~= caster then
				if unit:IsRealHero() then
					value_increase = value_increase + 1 * hero_inc_multiplier
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
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_feral_impulse_aura:GetEffectName()
	return "particles/auras/aura_feral_impulse.vpcf"
end

function modifier_imba_feral_impulse_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_feral_impulse_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local aura_radius = ability:GetSpecialValueFor("aura_radius")

	return aura_radius
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
	local caster = self:GetCaster()	
	
	if caster:PassivesDisabled() then
		return false
	end
	
	return true
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
	self.feral_impulse_stacks = self.caster:GetModifierStackCount(self.aura_buff, self.caster)

	-- Start thinking
	self:StartIntervalThink(0.1)
end

function modifier_imba_feral_impulse:OnIntervalThink()
	self.feral_impulse_stacks = self.caster:GetModifierStackCount(self.aura_buff, self.caster)
end

function modifier_imba_feral_impulse:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
	
	return decFuncs	
end

function modifier_imba_feral_impulse:GetModifierBaseDamageOutgoing_Percentage()	 		
	-- Ability specials
	local base_bonus_damage_perc = self.ability:GetSpecialValueFor("base_bonus_damage_perc")
	local damage_inc_per_unit = self.ability:GetSpecialValueFor("damage_inc_per_unit")			
	
	-- #2 Talent: damage increase bonus 	
	damage_inc_per_unit = damage_inc_per_unit + self.caster:FindTalentValue("special_bonus_imba_lycan_2")	
	
	-- Calculate damage percents
	local damage_perc_increase = base_bonus_damage_perc + damage_inc_per_unit * self.feral_impulse_stacks
	return damage_perc_increase		
end

function modifier_imba_feral_impulse:GetModifierConstantHealthRegen()
	-- Ability specials
	local health_regen = self.ability:GetSpecialValueFor("health_regen")
	local regen_inc_per_unit = self.ability:GetSpecialValueFor("regen_inc_per_unit")			
	
	-- #2 Talent - HP regen increase bonus 	
	regen_inc_per_unit = regen_inc_per_unit + self.caster:FindTalentValue("special_bonus_imba_lycan_2")		
	
	-- Calculate HP regeneration
	local health_increase = health_regen + regen_inc_per_unit * self.feral_impulse_stacks
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
LinkLuaModifier("modifier_imba_shapeshift_transform_stun", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_transform", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_aura", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shapeshift_certain_crit", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

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
	
	-- #8 Talent: Shapeshift duration increase	
	duration = duration + caster:FindTalentValue("special_bonus_imba_lycan_8")
	
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
	local response_cast = response_cast .. correct_sound_num 	
	EmitSoundOn(response_cast, caster)

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

function imba_lycan_shapeshift:GetCooldown( level )	
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
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local aura = "modifier_imba_shapeshift_aura"	 

	if not caster:HasModifier(aura) then
		caster:AddNewModifier(caster, ability, aura, {})
	end	
end

function modifier_imba_shapeshift_transform:OnDestroy()
	local caster = self:GetCaster()
	local response_sound = "lycan_lycan_ability_revert_0" ..RandomInt(1,3)
	local particle_revert = "particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf"
	local aura = "modifier_imba_shapeshift_aura"
	local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
	
	-- Play one of the revert responses
	EmitSoundOn(response_sound, caster)
	
	local particle_revert_fx = ParticleManager:CreateParticle(particle_revert, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_revert_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_revert_fx, 3, caster:GetAbsOrigin())
	
	if caster:HasModifier(aura) then
		caster:RemoveModifierByName(aura)
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

function modifier_imba_shapeshift_aura:AllowIllusionDuplicate()
	return false
end

function modifier_imba_shapeshift_aura:GetAuraRadius()
	return 50000 --global
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

function modifier_imba_shapeshift_aura:GetAuraEntityReject( target )
	local caster = self:GetCaster()		
	local owner = target:GetOwnerEntity()
	
	if target:IsRealHero() then
		if target == caster then		
			return false
		end
	end
	
	if owner then
		if owner == caster then
			return false
		end
	end	
		
	return true
end

-- Speed/crit modifier
modifier_imba_shapeshift = class({})

function modifier_imba_shapeshift:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
		
		if not parent:HasModifier(certain_crit_buff) then
			parent:AddNewModifier(caster, ability, certain_crit_buff, {})
		end
	end	
end

function modifier_imba_shapeshift:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
		
		if parent:HasModifier(certain_crit_buff) then
			parent:RemoveModifierByName(certain_crit_buff)
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
						  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
						  MODIFIER_PROPERTY_MOVESPEED_MAX,
						  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}		
		return decFuncs	
end

function modifier_imba_shapeshift:GetBonusNightVision()
	local ability = self:GetAbility()
	local night_vision_bonus = ability:GetSpecialValueFor("night_vision_bonus")
	
	return night_vision_bonus
end

function modifier_imba_shapeshift:GetModifierMoveSpeed_Max()
	local ability = self:GetAbility()
	local absolute_speed = ability:GetSpecialValueFor("absolute_speed")
	
	return absolute_speed
end

function modifier_imba_shapeshift:GetModifierMoveSpeed_Absolute()
	local ability = self:GetAbility()
	local absolute_speed = ability:GetSpecialValueFor("absolute_speed")
	
	return absolute_speed
end

function modifier_imba_shapeshift:GetModifierPreAttack_CriticalStrike()
	if IsServer() then		
		-- Ability properties
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
		local transform_buff = "modifier_imba_shapeshift_transform"
				
		-- Ability specials		
		local crit_chance = ability:GetSpecialValueFor("crit_chance")
		local crit_damage = ability:GetSpecialValueFor("crit_damage")		
		local certain_crit_cooldown = ability:GetSpecialValueFor("certain_crit_cooldown")
		
		-- Check for certain crit modifier, remove and start cooldown timer
		if parent:HasModifier(certain_crit_buff) then			
			parent.certain_crit_attacked = true	--mark for Wicked Crunch			
			parent:RemoveModifierByName(certain_crit_buff)	
			
			-- destroys Wicked Crunch mark if not used in the timeframe, 
			-- so it won't last forever until the next wicked crunch consumption
			Timers:CreateTimer(0.5, function() 
				parent.certain_crit_attacked = false
			end) 
			
			-- Renews the target's Certain Crit modifier if Lycan is still in his Shapeshift form.
			Timers:CreateTimer(certain_crit_cooldown, function()
					if caster:HasModifier(transform_buff) then
						parent:AddNewModifier(caster, ability, certain_crit_buff, {})
					end
			end)
			
			return crit_damage		
		end
		
		-- Roll a random for critical
		local rand = RandomInt(1,100)		
		if rand <= crit_chance then		
			return crit_damage
		end
		
		return nil
	end
end

function modifier_imba_shapeshift:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		local certain_crit_buff = "modifier_imba_shapeshift_certain_crit"
	
		if parent:HasModifier(certain_crit_buff) then
			parent:RemoveModifierByName(certain_crit_buff)
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
LinkLuaModifier("modifier_imba_wolfsbane_aura", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_wolves", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_lycan", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wolfsbane_lycan_prevent", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

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

--wolfsbane's aura
modifier_imba_wolfsbane_aura = class({})


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
	local caster = self:GetCaster()
	
	if caster:PassivesDisabled() then
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

function modifier_imba_wolfsbane_aura:GetAuraEntityReject( target )	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local scepter = caster:HasScepter()
	
	-- Reset variable	
	local wolf_found = false
	
	-- Deny caster, as Lycan has his own modifier
	if target == caster then
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


--wolfsbane modifier (wolves or anyone if Lycan holds a scepter)
modifier_imba_wolfsbane_wolves = class({})

function modifier_imba_wolfsbane_wolves:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
	
end

function modifier_imba_wolfsbane_wolves:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local wolf = self:GetParent()
		local aura = "modifier_imba_wolfsbane_aura"		
		local aura_handler = caster:FindModifierByName(aura)

		if aura_handler then
			local aura_stacks = aura_handler:GetStackCount()
			local wolf_stacks = self:GetStackCount()		
			
			if wolf_stacks ~= aura_stacks then -- aura stacks are higher, set stacks
				self:SetStackCount(aura_stacks)
			end	
		end
	end
end

function modifier_imba_wolfsbane_wolves:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
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
		local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
		
		return decFuncs	
end

function modifier_imba_wolfsbane_wolves:GetModifierBaseAttack_BonusDamage()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()
	
	local damage_bonus = ability:GetSpecialValueFor("damage_bonus")
	local stacks = self:GetStackCount()	
	
	-- #4 Talent: Wolfsbane damage increase
	damage_bonus = damage_bonus + caster:FindTalentValue("special_bonus_imba_lycan_4")
	
	if parent:PassivesDisabled() then
		return nil
	end
	
	return damage_bonus * stacks
end


--wolfsbane modifier (lycan)
modifier_imba_wolfsbane_lycan = class({})

function modifier_imba_wolfsbane_lycan:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
						  MODIFIER_EVENT_ON_HERO_KILLED}
		
		return decFuncs	
end

function modifier_imba_wolfsbane_lycan:OnHeroKilled( keys )
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local killed_hero = keys.target
		local aura = "modifier_imba_wolfsbane_aura"
		local prevent_modifier = "modifier_imba_wolfsbane_lycan_prevent"
		local sound_howl = "Imba.LycanWolfsbane" 
		local scepter = caster:HasScepter()
		
		-- Ability specials
		local radius = ability:GetSpecialValueFor("radius")
		local minimum_allies_required = ability:GetSpecialValueFor("minimum_allies_required")
		local prevent_modifier_duration = ability:GetSpecialValueFor("prevent_modifier_duration")
		local scepter_radius = ability:GetSpecialValueFor("scepter_radius")
		
		if caster:PassivesDisabled() then
			return nil
		end
		
		if caster:GetTeamNumber() ~= killed_hero:GetTeamNumber() then -- an enemy was killed
			
			-- Search to see if Lycan is nearby, initialize variables
			local lycan_nearby = false
			local should_grants_stacks = false
			
			local units = FindUnitsInRadius(caster:GetTeamNumber(),
											killed_hero:GetAbsOrigin(),
											nil,
											radius,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
											FIND_ANY_ORDER,
											false)
			
			-- Look for Lycan
			for _, unit in pairs(units) do 
				if unit == caster then --Lycan was found
					lycan_nearby = true					
				end
			end
			
			-- If Lycan is present nearby and at least the minimum allies required are present, give stacks			
			if #units >= minimum_allies_required + 1 and lycan_nearby and caster:HasModifier(aura) and not caster:HasModifier(prevent_modifier) then			
				should_grants_stacks = true
			end
			
			-- If Lycan has a scepter and did not benefit from the kill, check for nearby allies and give stacks if enough are present
			if scepter then
					local units = FindUnitsInRadius(caster:GetTeamNumber(),
												killed_hero:GetAbsOrigin(),
												nil,
												scepter_radius,
												DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												DOTA_UNIT_TARGET_FLAG_NONE,
												FIND_ANY_ORDER,
												false)
													
				if #units >= minimum_allies_required and caster:HasModifier(aura) and not caster:HasModifier(prevent_modifier) then			
					should_grants_stacks = true
				end
			end
			
			if should_grants_stacks then
				-- Play howl sound
				EmitSoundOn(sound_howl, caster)				
				AddStacksLua(ability, caster, caster, aura, 1, false)				
				caster:AddNewModifier(caster, ability, prevent_modifier, {duration = prevent_modifier_duration})
			end
		end		
	end	
end

function modifier_imba_wolfsbane_lycan:GetModifierBaseAttack_BonusDamage()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damage_bonus = ability:GetSpecialValueFor("damage_bonus")
	local stacks = self:GetStackCount()

	-- #4 Talent: Wolfsbane damage increase
	damage_bonus = damage_bonus + caster:FindTalentValue("special_bonus_imba_lycan_4")
	
	if caster:PassivesDisabled() then
		return nil
	end
	
	return damage_bonus * stacks
end

function modifier_imba_wolfsbane_lycan:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()		
		self:StartIntervalThink(0.5)
	end
	
end

function modifier_imba_wolfsbane_lycan:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()		
		local aura = "modifier_imba_wolfsbane_aura"		
		local aura_handler = caster:FindModifierByName(aura)
		local aura_stacks = aura_handler:GetStackCount()
		local lycan_stacks = self:GetStackCount()		
		
		if lycan_stacks ~= aura_stacks then -- aura stacks are higher, set stacks
			self:SetStackCount(aura_stacks)
		end	
	end
end

function modifier_imba_wolfsbane_lycan:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
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




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		Lycan's Wolves' Wicked Crunch
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

imba_summoned_wolf_wicked_crunch = class({})
LinkLuaModifier("modifier_imba_summoned_wolf_wicked_crunch_debuff", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summoned_wolf_wicked_crunch", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_wicked_crunch:GetIntrinsicModifierName()
	return "modifier_imba_summoned_wolf_wicked_crunch"
end

-- Wolf attack modifier
modifier_imba_summoned_wolf_wicked_crunch = class({})

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

function modifier_imba_summoned_wolf_wicked_crunch:OnAttackLanded ( keys )
	-- Ability properties
	if IsServer() then
		local caster = self:GetCaster()
		local target = keys.target
		local ability = self:GetAbility()	
		local debuff = "modifier_imba_summoned_wolf_wicked_crunch_debuff"
		local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal_lanecreeps.vpcf"
		local owner = nil
		
		-- Set wolves' owner
		if caster:GetOwnerEntity() then --some weird error, might be because of wolves dying from an attack on them
			owner = caster:GetOwnerEntity() --get Lycan, or Rubick if stolen			
		end
		
		-- Ability specials
		local damage_bonus_per_stack = ability:GetSpecialValueFor("damage_bonus_per_stack")	
		local fixed_lifesteal = ability:GetSpecialValueFor("fixed_lifesteal")
		local duration = ability:GetSpecialValueFor("duration")		
		local lycan_lifesteal = ability:GetSpecialValueFor("lycan_lifesteal")
		local certain_crit = "modifier_imba_shapeshift_certain_crit"				
		
		-- If wolves are the attackers, grant modifier or increment stacks if already present.
		if caster == keys.attacker then
			
			if caster:PassivesDisabled() then
				return nil
			end
			
			-- if wolves are attacking a building, do nothing
			if target:IsBuilding() then
				return nil
			end
			
			-- Inflict modifier on enemy, or increment if present 
			if not target:HasModifier(debuff) then
				target:AddNewModifier(caster, ability, debuff, {duration =  duration})				
			end

			local debuff_handler = target:FindModifierByName(debuff)
			debuff_handler:IncrementStackCount()								
			
			-- #6 Talent (wolves generate two stacks per attack) 			
			if owner:HasTalent("special_bonus_imba_lycan_6") then
				debuff_handler:IncrementStackCount()
			end
			
			debuff_handler:ForceRefresh()
			
			-- Delay the lifesteal for one game tick to prevent blademail interaction
				Timers:CreateTimer(FrameTime(), function()
					caster:Heal(fixed_lifesteal, caster)
				end)	
				
			-- Create lifesteal effect
			local lifesteal_particle_fx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(lifesteal_particle_fx, 0 , caster:GetAbsOrigin())
		end
		
		-- If Lycan attacked, consume all stacks and deal bonus damage if present
		if owner == keys.attacker then	
			if owner:PassivesDisabled() then
				return nil			
			end
			
			if target:HasModifier(debuff) then
				local debuff_handler = target:FindModifierByName(debuff)
				local stacks = debuff_handler:GetStackCount()
				debuff_handler:Destroy()
				
				local damage = damage_bonus_per_stack * stacks							
				
				-- If Lycan has just Certain Critted with Shapeshift, increase damage by crit damage				
				if owner.certain_crit_attacked then
					local shapeshift_ability = owner:FindAbilityByName("imba_lycan_shapeshift")
					local crit_damage = shapeshift_ability:GetSpecialValueFor("crit_damage")
					damage = damage * (crit_damage/100)
					owner.certain_crit_attacked = false					
				end
				
			
				-- Deal bonus damage
				local damageTable = {victim = target,
									attacker = owner,
									damage = damage,
									damage_type = DAMAGE_TYPE_PHYSICAL}
									
				ApplyDamage(damageTable)	
				
				-- Lifesteal from damage
				local lifesteal = damage * lycan_lifesteal			
				
				-- Delay the lifesteal for one game tick to prevent blademail interaction
				Timers:CreateTimer(0.01, function()
					owner:Heal(lifesteal, caster)				
				end)	
				
				-- Create lifesteal effect
				local lifesteal_particle_fx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(lifesteal_particle_fx, 0 , caster:GetAbsOrigin())		
			end				
		end
	end
end


-- Crunch debuff
modifier_imba_summoned_wolf_wicked_crunch_debuff = class({})

function modifier_imba_summoned_wolf_wicked_crunch_debuff:OnCreated()	
		-- Ability properties
		self.caster = self:GetCaster()		
		self.ability = self:GetAbility()
		self.attack_speed_reduction = self.ability:GetSpecialValueFor("attack_speed_reduction")

		-- Ability specials
		self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")	

	if IsServer() then
		self.owner = self.caster:GetOwnerEntity()
			
		-- #6 Talent: Double max stacks count
		self.max_stacks = self.max_stacks + self.owner:FindTalentValue("special_bonus_imba_lycan_6")
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
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
		
	return decFuncs	
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:GetModifierAttackSpeedBonus_Constant()	
	
	
	return (self.attack_speed_reduction * (-1))
end

function modifier_imba_summoned_wolf_wicked_crunch_debuff:OnStackCountChanged()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- If we're past the maximum possible stacks, retract them
		if stacks > self.max_stacks then
			self:SetStackCount(self.max_stacks)
		end
	end
end




---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
--		Lycan's Wolves' Hunter Instincts
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
imba_summoned_wolf_hunter_instincts = class({})
LinkLuaModifier("modifier_imba_summoned_wolf_hunter_instincts", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

function imba_summoned_wolf_hunter_instincts:OnUpgrade()
	 local caster = self:GetCaster()
	 local ability = self	 
	 local buff = "modifier_imba_summoned_wolf_hunter_instincts"
	 
	 if not caster:HasModifier(buff) then
		caster:AddNewModifier(caster, ability, buff, {})
	 end
end

-- Hunter instincts buff
modifier_imba_summoned_wolf_hunter_instincts = class({})

function modifier_imba_summoned_wolf_hunter_instincts:DeclareFunctions()	
		local decFuncs = {MODIFIER_PROPERTY_EVASION_CONSTANT}
		
		return decFuncs	
end

function modifier_imba_summoned_wolf_hunter_instincts:GetModifierEvasion_Constant()
	local caster = self:GetCaster()
	
	if caster:PassivesDisabled() then
		return nil
	end

	local ability = self:GetAbility()	
	local evasion = ability:GetSpecialValueFor("evasion")
	
	return evasion
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
LinkLuaModifier("modifier_imba_summoned_wolf_invisibility_fade", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_summoned_wolf_invisibility", "hero/hero_lycan", LUA_MODIFIER_MOTION_NONE)

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



--invisibility fade buff
modifier_imba_summoned_wolf_invisibility_fade = class({})

function modifier_imba_summoned_wolf_invisibility_fade:IsDebuff()
	return false	
end

function modifier_imba_summoned_wolf_invisibility_fade:IsHidden()
	return false	
end

function modifier_imba_summoned_wolf_invisibility_fade:IsPurgable()
	return false	
end

function modifier_imba_summoned_wolf_invisibility_fade:OnCreated()
	if IsServer() then
		self.caster = self:GetParent()
		self.ability = self:GetAbility()
	end
end

function modifier_imba_summoned_wolf_invisibility_fade:OnDestroy()
	if IsServer() then
		local caster = self.caster
		local ability = self.ability
		local invis_buff = "modifier_imba_summoned_wolf_invisibility"		
	
		caster:AddNewModifier(caster, ability, invis_buff, {})
		caster:AddNewModifier(caster, ability, "modifier_invisible", {})
	end
end

function modifier_imba_summoned_wolf_invisibility_fade:DeclareFunctions()	
		local decFuncs = {MODIFIER_EVENT_ON_ATTACK_FINISHED}
		
		return decFuncs	
end

function modifier_imba_summoned_wolf_invisibility_fade:OnAttackFinished( keys )
	local caster = self:GetCaster()
	local ability = self:GetAbility()			
	
	if caster == keys.attacker then		
		self:ForceRefresh()
	end
end

--actual invisibility buff
modifier_imba_summoned_wolf_invisibility = class({})

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

function modifier_imba_summoned_wolf_invisibility:OnAttackFinished( keys )
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()	
		local invis_fade = "modifier_imba_summoned_wolf_invisibility_fade"
		local fade_time = ability:GetSpecialValueFor("fade_time")
		
		if caster == keys.attacker then
			
			caster:RemoveModifierByName("modifier_invisible")
			caster:AddNewModifier(caster, ability, invis_fade, {duration = fade_time})
			self:Destroy()
		end
	end
end

