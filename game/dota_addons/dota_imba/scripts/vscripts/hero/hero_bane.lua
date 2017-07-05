--[[	Author: Seinken
		Date: 16.03.2017	]]

CreateEmptyTalents("bane")

--------------------------------------
----------    ENFEEBLE    ------------
--------------------------------------
LinkLuaModifier("modifier_imba_enfeeble_debuff_stats",          "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
-- Main enfeeble casting
imba_bane_enfeeble       = imba_bane_enfeeble       or class({})  

-- Enfeeble Spell Cast
function imba_bane_enfeeble:OnSpellStart() 
	if  IsServer() then
		-- Ability properties
		local target,caster 	= findtarget(self)
		local enfeeble_duration = self:GetSpecialValueFor("enfeeble_duration") + caster:FindTalentValue("special_bonus_imba_bane_3")
		
		if target:TriggerSpellAbsorb(self) then return end	--Spell block handler
		
		-- Apply enfeeble debuff
		target:AddNewModifier(caster, self, "modifier_imba_enfeeble_debuff_stats", {duration = enfeeble_duration})
		
		-- Emit sound effect
		EmitSoundOn("Hero_Bane.Enfeeble.Cast", caster)
		EmitSoundOn("hero_bane.enfeeble", target)
		if RollPercentage(75) then
			EmitSoundOn ("bane_bane_ability_enfeeble_"..string.format("%02d",RandomInt(1,14)), self:GetCaster())
		end
	end	       
end

function imba_bane_enfeeble:GetAbilityTextureName()
   return "bane_enfeeble"
end


-- Enfeeble Debuff
modifier_imba_enfeeble_debuff_stats = modifier_imba_enfeeble_debuff_stats or class({
		IsDebuff                         = function(self) return true                                                                                                           end,    
		IsPurgable                       = function(self) return false                                                                                                          end,    
		IsPurgableException              = function(self) return false                                                                                                          end,        
		GetModifierBonusStats_Strength   = function(self) return self.strengthmodifier                                                                                          end,
		GetModifierBonusStats_Agility    = function(self) return self.agilitymodifier                                                                                           end,
		GetModifierBonusStats_Intellect  = function(self) return self.intellectmodifier                                                                                         end,
		GetModifierPreAttack_BonusDamage = function(self) return self.damagereduction                                                                                           end,
		GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_enfeeble.vpcf"                                                          end,
		GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
	})

function modifier_imba_enfeeble_debuff_stats:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_imba_enfeeble_debuff_stats:OnCreated()
	--Ability paramaters 
	local ability 	=	self:GetAbility()
	local parent 	=	self:GetParent()
	-- Ability paramaters
	local statreduction		=	ability:GetSpecialValueFor("stat_reduction")
	local damagereduction 	= 	ability:GetSpecialValueFor("damage_reduction") 
	local talentdamagereduction = self:GetCaster():FindTalentValue("special_bonus_imba_bane_5")
	self.damagereduction   = (damagereduction+talentdamagereduction) * (-1)  

	if IsServer() then
		self.strengthmodifier  = parent:GetStrength()  * (statreduction * 0.01 * (-1)) -- Note these are only evaluated once, on spell cast.  On refresh they will                      
		self.agilitymodifier   = parent:GetAgility()   * (statreduction * 0.01 * (-1)) -- NOT be recalculated, this can be rewritten to calculate stat reduction on
		self.intellectmodifier = parent:GetIntellect() * (statreduction * 0.01 * (-1)) -- recast or w/e is required
	end
end

--------------------------------------
---------    BRAIN SAP     -----------
--------------------------------------
LinkLuaModifier("modifier_imba_brain_sap_mana",                 "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
-- Main Brain Sap casting
imba_bane_brain_sap      = imba_bane_brain_sap      or class({})  

-- Brain Sap Spell Cast
function imba_bane_brain_sap:OnSpellStart()
	if IsServer() then
		-- Ability properties
		local target,caster = findtarget(self)
		-- Ability paramaters
		local sapdamage				=	self:GetSpecialValueFor("brain_sap_damage")
		local sapduration			=	self:GetSpecialValueFor("brain_sap_duration")
		local talentdurationbonus 	= 	caster:FindTalentValue("special_bonus_imba_bane_1")
		local talentdamagebonus 	= 	caster:FindTalentValue("special_bonus_imba_bane_4")	
		
		if target:TriggerSpellAbsorb(self) then return end 	-- Spell block handler
		
		-- Deal damage
		damage_table = {
				victim      = target,
				attacker    = caster,
				damage      = sapdamage+talentdamagebonus,
				damage_type = DAMAGE_TYPE_PURE,
				ability     = self
		}
		ApplyDamage(damage_table)
		-- Heal caster
		caster:Heal(sapdamage+talentdamagebonus, caster) 
		-- Apply brain sap debuff
		target:AddNewModifier(caster, self, "modifier_imba_brain_sap_mana", {duration = (sapduration+talentdurationbonus)}) 
		-- Emit brain sap particle
		local sapFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_ABSORIGIN, caster)     
		ParticleManager:SetParticleControlEnt(sapFX, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)   
		ParticleManager:SetParticleControlEnt(sapFX, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)   
		ParticleManager:ReleaseParticleIndex(sapFX)   
		-- Emit brain sap sound
		EmitSoundOn("Hero_Bane.BrainSap", caster)
		EmitSoundOn("Hero_Bane.BrainSap.Target", target) -- slslslllslslsllrprpp
		if RollPercentage(75) then
			EmitSoundOn ("bane_bane_ability_brainsap_"..string.format("%02d",RandomInt(1,6)), self:GetCaster())
		end 
	end    
end

-- Scepter cooldown reduction
function imba_bane_brain_sap:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("cooldown_scepter")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_bane_brain_sap:GetAbilityTextureName()
   return "bane_brain_sap"
end

-- Brain_sap Debuff
modifier_imba_brain_sap_mana = modifier_imba_brain_sap_mana or class({
		IsDebuff                         = function(self) return true                                                                                                           end,
		GetModifierManaBonus             = function(self) return (((self:GetParent():GetIntellect() * 12) + 50) * (self:GetAbility():GetSpecialValueFor("manapool_reduction") * 0.01 * (-1))) end,    
	})
	
function modifier_imba_brain_sap_mana:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs  
end

--------------------------------------
---------    NIGHTMARE     -----------
--------------------------------------

LinkLuaModifier("modifier_imba_nightmare_dot",                 	"hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nightmare_invul",   				"hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_nightmare_vision", 				"hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
-- Main Nightmare casting 
imba_bane_nightmare      = imba_bane_nightmare      or class({})  

-- Nightmare Spell Cast
function imba_bane_nightmare:OnSpellStart()
	if IsServer() then
		-- Ability properties 
		local target,caster	 	=	 findtarget(self) 
		-- Ability paramaters
		local invulnduration 	=	self:GetSpecialValueFor("nightmare_invuln_duration")
		local nightmareduration	=	self:GetSpecialValueFor("nightmare_duration")
		local talentinvulnbonus = self:GetCaster():FindTalentValue("special_bonus_imba_bane_7")
		
		if target:TriggerSpellAbsorb(self) then return end    --Spell block handler 
		
		-- Apply special talent bonus to allies 
		if caster:GetTeamNumber() == target:GetTeamNumber() then 
			invulnduration=invulnduration+talentinvulnbonus
		end    
		
		-- Apply Nightmare modifiers 
		target:AddNewModifier(caster, self, "modifier_imba_nightmare_dot",   {duration = nightmareduration}) 
		target:AddNewModifier(caster, self, "modifier_imba_nightmare_invul", {duration = invulnduration})
		-- Emit Nightmare sound effect 
		EmitSoundOn("hero_bane.nightmare", target)
		if caster ~= target then
			EmitSoundOn ("bane_bane_ability_nightmare_"..string.format("%02d",RandomInt(1,3)), self:GetCaster())   
		end
	end
end

-- Prevent Nightmare griefing when help is disabled 
function imba_bane_nightmare:CastFilterResultTarget(target)
	if IsServer() then
		-- Ability paramaters
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target ~= nil and not target:IsOpposingTeam(caster:GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(targetID,casterID) then
			return UF_FAIL_DISABLE_HELP
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_bane_nightmare:OnUpgrade()
	local caster 	=	self:GetCaster()
	-- When you level up nightmare while it is active, don't level up nightmare end (cuz that's a bad idea)
	if caster:HasAbility("imba_bane_nightmare_end") and caster:FindAbilityByName("imba_bane_nightmare_end"):GetLevel() ~= 1 then
		caster:FindAbilityByName("imba_bane_nightmare_end"):SetLevel(1) 
	end
end

function imba_bane_nightmare:GetAssociatedSecondaryAbilities()
	return "imba_bane_nightmare_end" 
end 

function imba_bane_nightmare:GetAbilityTextureName()
   return "bane_nightmare"
end

-- Nightmare's sub ability (Nightmare end)
imba_bane_nightmare_end  = imba_bane_nightmare_end  or class({}) 

-- End Nightmares 
function imba_bane_nightmare_end:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		-- Emit nightmare end sound effect
		EmitSoundOn("Hero_Bane.Nightmare.End", caster)
		
		-- Find ALL heroes nightmared 
		local units = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										25000, 			-- Global 
										DOTA_UNIT_TARGET_TEAM_BOTH,
										DOTA_UNIT_TARGET_ALL,
										DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
										FIND_ANY_ORDER,
										false)
										
		-- Stop all of the Nightmare modifiers 
		for _,unit in pairs(units) do	
			if unit:HasModifier("modifier_imba_nightmare_invul") then -- We can't debuff an immune target! So remove this first
				unit:RemoveModifierByName("modifier_imba_nightmare_invul")
			end    
			if unit:HasModifier("modifier_imba_nightmare_dot") then 
				unit:RemoveModifierByName("modifier_imba_nightmare_dot")
			end
		end
	end
end

function imba_bane_nightmare_end:GetAssociatedPrimaryAbilities()
	return "imba_bane_nightmare"
end

function imba_bane_nightmare_end:GetAbilityTextureName()
   return "bane_nightmare_end"
end

-- Nightmare Debuff
modifier_imba_nightmare_dot = modifier_imba_nightmare_dot or class({
		IsDebuff                         = function(self) return true                                                                                                           end,
		IsNightmared                     = function(self) return true                                                                                                           end,
		IsPurgable                       = function(self) return true                                                                                                           end,    
		GetBonusVisionPercentage         = function(self) return -100                                                                                                           end,         
		GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_nightmare.vpcf"                                                         end,
		GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
		GetOverrideAnimation             = function(self) return ACT_DOTA_FLAIL                                                                                                 end,
		GetOverrideAnimationRate         = function(self) return 0.2                                                                                                            end,    
	})
		
	
function modifier_imba_nightmare_dot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,  
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_nightmare_dot:OnCreated()
	-- Remove vision 
	self:GetBonusVisionPercentage()
	
	if IsServer() then 
		self:OnIntervalThink()  
		self:StartIntervalThink(1)
	end
end

function modifier_imba_nightmare_dot:CheckState()
	return{
		[MODIFIER_STATE_NIGHTMARED]           = true,
		[MODIFIER_STATE_STUNNED]              = true,
		[MODIFIER_STATE_SPECIALLY_DENIABLE]   = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY]  = true,
	}
end

function modifier_imba_nightmare_dot:OnTakeDamage(t)
	if IsServer() then
		-- Stop Nightmare when hit (by anything other than an auto attack)
		if t.unit == self:GetParent() then
			self:Destroy()
		end
	end
end

function modifier_imba_nightmare_dot:OnAttackStart(t)
	if IsServer() then 
		-- Ability properties
		local ability 	=	self:GetAbility()
		local caster	=	self:GetCaster()
		-- Ability paramaters 
		local nightmare_duration 		= 	ability:GetSpecialValueFor("nightmare_duration")
		local nightmare_invuln_duration	=	ability:GetSpecialValueFor("nightmare_invuln_duration")
		
		-- Redirect Nightmare to auto-attackers 
		if t.target == self:GetParent() then 
			--Don't Nightmare buildings lul
			if t.attacker:IsBuilding() then
				return nil
			end
			-- Apply Nightmare debuff to attackers 
			t.attacker:AddNewModifier(caster, ability, "modifier_imba_nightmare_dot", {duration = nightmare_duration}) 
			t.attacker:AddNewModifier(caster, ability, "modifier_imba_nightmare_invul", {duration = nightmare_invuln_duration})
		end
	end
end

function modifier_imba_nightmare_dot:OnIntervalThink()
	if IsServer() then 
		-- Ability properties
		local ability 	=	self:GetAbility()
		local caster	=	self:GetCaster()
		local parent 	= 	self:GetParent()
		-- Ability paramaters
		local CurHP = parent:GetHealth()
		local nightmare_damage = ability:GetSpecialValueFor("nightmare_damage")
		
		-- If the target dies then:
		if (CurHP <= nightmare_damage) then
			local damage = {
				victim      = parent,
				attacker    = caster,
				damage      = nightmare_damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability     = ability
			}
			-- Frag target with pure damage, give kill credit to Bane.
			ApplyDamage(damage)
		else
			-- Deal damage 
			self:GetParent():SetHealth(CurHP - nightmare_damage)
		end
		-- Emit Nightmare affected sound effect 
		EmitSoundOn("Hero_Bane.Nightmare.Loop", target)
	end
end

function modifier_imba_nightmare_dot:OnDestroy()
	if IsServer() then
		-- Ability properties
		local ability 	=	self:GetAbility()
		local caster	=	self:GetCaster()
		local parent 	= 	self:GetParent()
		-- Ability paramaters
		local nightmare_baleful_visions_duration	=	ability:GetSpecialValueFor("nightmare_baleful_visions_duration")
		local talentdurationbonus					= 	caster:FindTalentValue("special_bonus_imba_bane_2")

		-- Check if the nightmare'd is an enemy
		if caster:GetTeamNumber() ~= parent:GetTeamNumber() then 
			if not parent:IsMagicImmune() then  
				-- Apply vision debuff
				parent:AddNewModifier(caster, ability, "modifier_imba_nightmare_vision", {duration = nightmare_baleful_visions_duration+talentdurationbonus})
			end
		end
		 -- If we don't do this, clever players will only skill one point in nightmare and take the 6sec invuln talent which will make you invulnerable while not stunned
		if parent:HasModifier("modifier_imba_nightmare_invul") then
			parent:RemoveModifierByName("modifier_imba_nightmare_invul")
		end   
		-- Emit Nightmare end sound effect 
		EmitSoundOn("Hero_Bane.Nightmare.End", self:GetParent())
	end
end

-- Nightmare Invulnerability
modifier_imba_nightmare_invul = modifier_imba_nightmare_invul or class({
		IsDebuff                         = function(self) return true                                                                                                           end,    
		IsHidden                         = function(self) return true                                                                                                           end,
	})
	

function modifier_imba_nightmare_invul:DeclareFunctions()
	local funcs = {
		MODIFIER_STATE_INVULNERABLE,
		MODIFIER_STATE_NO_HEALTH_BAR
	}
	return funcs
end

function modifier_imba_nightmare_invul:CheckState()
	return{[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true}
end

-- Nightmare Baleful Visions
modifier_imba_nightmare_vision = modifier_imba_nightmare_vision or class({
		GetBonusVisionPercentage         = function(self) return self.visionreduction                                                                                           end,    
	})

function modifier_imba_nightmare_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_nightmare_vision:OnCreated()
	self:StartIntervalThink(0)
end

function modifier_imba_nightmare_vision:OnIntervalThink()
	local nightmare_baleful_visions_sight_reduction = self:GetAbility():GetSpecialValueFor("nightmare_baleful_visions_sight_reduction") 
	self.visionreduction = nightmare_baleful_visions_sight_reduction*((self:GetRemainingTime() / self:GetDuration())*-1)
	self:GetBonusVisionPercentage()
end

--------------------------------------
-----       FIEND'S GRIP         -----
--------------------------------------
LinkLuaModifier("modifier_imba_fiends_grip_handler",            "hero/hero_bane", LUA_MODIFIER_MOTION_NONE)
imba_bane_fiends_grip    = imba_bane_fiends_grip    or class({})

-- Fiends Grip Spell Cast
function imba_bane_fiends_grip:OnSpellStart()  
	if IsServer() then
		-- Ability properties 
		self.fiendtarget,self.fiendcaster 	= 	findtarget(self)
		-- Ability paramaters 
		local fiends_grip_duration			= 	self:GetSpecialValueFor("fiends_grip_duration")  
		local talentchannelbonus 			= 	self:GetCaster():FindTalentValue("special_bonus_imba_bane_6")
		
		if self.fiendtarget:TriggerSpellAbsorb(self) then self.fiendcaster:Interrupt() return end    -- Spell absorb handler 
	
		-- Create table to store all fiendgrip victims, with no talent it's always 1
		self.fiendgriptable = {} -- set table to blank when skill is invoked to avoid weird shit
		-- we append fiendcaster and fiendtarget into class values for use later in cases of channel interruption or spell reflection to avoid conflicts
		table.insert(self.fiendgriptable,self.fiendtarget)  
		self.fiendtarget:Interrupt()  
		
		--Apply Fiend's Grip 
		self.fiendtarget:AddNewModifier(self.fiendcaster,
										self,
										"modifier_imba_fiends_grip_handler",
										{duration = fiends_grip_duration+talentchannelbonus,propogated = 0,
										original_target = 1}) -- we are the original target, it has not spread
		-- Emit Fiend's Grip sound 
		EmitSoundOn("Hero_Bane.FiendsGrip.Cast", self.fiendcaster)  
		EmitSoundOn("hero_bane.fiends_grip", self.fiendtarget)
		EmitSoundOn("hero_bane.fiends_grip", self.fiendcaster)
		EmitSoundOn ("bane_bane_ability_fiendsgrip_"..string.format("%02d",RandomInt(1,7)), self:GetCaster())  
	end
end

-- When channel is finished or interrupted iterate through table and destroy original modifier. Destroy will trigger OnDestroy() for the modifier, and determine eligibility for propogation <--- dafaq is propogation? 
function imba_bane_fiends_grip:OnChannelFinish(bInterrupted) 
	if IsServer() then
		if not self.fiendgriptable then return end
		for k,v in pairs(self.fiendgriptable) do
		-- Doing it this way prevents a runtime error in case some not accounted for situations occur.
		if ((self.fiendgriptable[k]:HasModifier("modifier_imba_fiends_grip_handler")) and self.fiendgriptable[k]:FindModifierByName("modifier_imba_fiends_grip_handler").propogated == 0) then
			self.fiendgriptable[k]:FindModifierByName("modifier_imba_fiends_grip_handler"):Destroy() -- if our target has been gripped, and it has not been spread by itself, destroy it (which will reinvoke and set propogated to 1)
		end
		end
	end
end

-- We only care about channel operations when he has the lv40 talent			-- Seinken definetly didn't write this block :nofun:
function imba_bane_fiends_grip:OnChannelThink()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasTalent("special_bonus_imba_bane_8") then

			-- Parameters
			local vision_radius = self:GetTalentSpecialValueFor("talent_vision_radius")
			local vision_cone = self:GetTalentSpecialValueFor("talent_vision_cone")
			local fiends_grip_duration = self:GetTalentSpecialValueFor("fiends_grip_duration") + caster:FindTalentValue("special_bonus_imba_bane_6")
			local caster_location = caster:GetAbsOrigin()

			-- Iterate through nearby enemies
			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, vision_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do

				-- If this enemy is already Gripped, do nothing
				if not enemy:HasModifier("modifier_imba_fiends_grip_handler") then
					local enemy_location =  enemy:GetAbsOrigin()
					local enemy_to_caster_direction = (caster_location - enemy_location):Normalized()
					local enemy_forward_vector =  enemy:GetForwardVector()

					-- This is the angle between the enemy's forward vector and the line between them and the caster
					local view_angle = math.abs(RotationDelta(VectorToAngles(enemy_to_caster_direction), VectorToAngles(enemy_forward_vector)).y)

					-- If the angle is inside the vision cone, and the channeling caster can be seen by the enemy team, GET GRIPPED NOOB
					if view_angle <= ( vision_cone / 2 ) and enemy:CanEntityBeSeenByMyTeam(caster) then
						enemy:AddNewModifier(caster, self, "modifier_imba_fiends_grip_handler", {duration = fiends_grip_duration-(GameRules:GetGameTime()-self:GetChannelStartTime()), propogated = 0})
						table.insert(self.fiendgriptable, enemy)
					end
				end
			end
		end
	end
end



function imba_bane_fiends_grip:GetChannelTime()
	local talentchannelbonus = self:GetCaster():FindTalentValue("special_bonus_imba_bane_6")  -- net tables
	return (self:GetSpecialValueFor("fiends_grip_duration")+talentchannelbonus)
end

function imba_bane_fiends_grip:GetCooldown(nLevel)
	local talentcooldownbonus = self:GetCaster():FindTalentValue("special_bonus_imba_bane_8")
	return self.BaseClass.GetCooldown( self, nLevel )-talentcooldownbonus 
end

function imba_bane_fiends_grip:  GetChannelAnimation() return
 ACT_DOTA_CHANNEL_ABILITY_4 or ACT_DOTA_CHANNEL_ABILITY_5
end

function imba_bane_fiends_grip:GetAbilityTextureName()
   return "bane_fiends_grip"
end

-- Fiends Grip Debuff
modifier_imba_fiends_grip_handler = modifier_imba_fiends_grip_handler or class({
		IsDebuff                         = function(self) return true                                                                                                           end,
		IsStunDebuff                     = function(self) return true                                                                                                           end,    
		IsPurgableException              = function(self) return true                                                                                                           end,      
		GetEffectName                    = function(self) return "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf"                                                       end,
		GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                                                                                        end,
		GetOverrideAnimation             = function(self) return ACT_DOTA_FLAIL                                                                                                 end,
	})

function modifier_imba_fiends_grip_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs  
end

function modifier_imba_fiends_grip_handler:OnCreated(var)
	if IsServer() then 
		parent 	=	self:GetParent()
		parent:Interrupt()  
		parent:StartGesture(ACT_DOTA_FLAIL)  -- Flail em
		self:OnIntervalThink() -- Invoke a damage instance, once
		self:StartIntervalThink(1) -- Begin damage instances, 1 second interval
		self.propogated = var.propogated -- attribute defining a 'spread' grip
		self.original_target = var.original_target -- Original target for interrupt purposes
	end
end

function modifier_imba_fiends_grip_handler:OnRefresh(var)
	if IsServer() then  
		self:GetParent():Interrupt()    
		self:OnIntervalThink()  
		self:StartIntervalThink(1)
		self.propogated = var.propogated
		self.original_target = var.original_target
	end
end

function modifier_imba_fiends_grip_handler:OnIntervalThink()
	if  IsServer() then
		-- Ability properties
		local ability	=	self:GetAbility()
		local parent = self:GetParent()
		-- Ability paramaters
		local fiends_grip_mana_damage	=	ability:GetSpecialValueFor("fiends_grip_mana_damage")
		local fiends_grip_damage		=	ability:GetSpecialValueFor("fiends_grip_damage")
		
		-- Drain mana
		local mana_drained = math.min(parent:GetMaxMana() * fiends_grip_mana_damage * 0.01, parent:GetMana())
		parent:ReduceMana(parent:GetMaxMana() * fiends_grip_mana_damage * 0.01) 
		parent:GiveMana(mana_drained)
		-- Deal damage 
		local damage = {
			victim      = self:GetParent(),
			attacker    = self:GetCaster(),
			damage      = fiends_grip_damage,
			damage_type = DAMAGE_TYPE_PURE,
			ability     = self:GetAbility()
		}
		if not self:GetParent():IsMagicImmune() then
			ApplyDamage(damage)
		end
	end
end

function modifier_imba_fiends_grip_handler:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_imba_fiends_grip_handler:OnDestroy()  
	if IsServer() then    
		-- Ability properties
		local ability	=	self:GetAbility()
		local parent	= 	self:GetParent()
		local caster	=	self:GetCaster()
		local fiends_grip_linger_duration = ability:GetSpecialValueFor("fiends_grip_linger_duration")   
		
		parent:FadeGesture(ACT_DOTA_FLAIL)     -- Fade the gesture, even though it can be immeditaely reinvoked if it's not been spread
		if not parent:IsMagicImmune() and self.propogated == 0 then -- Are we magic immune somehow(omniknight)? if not, have we already retriggered once?
			if self.original_target == 1 then -- If we are the original target and it's NOT spread, we need to interrupt the primary caster (typically Bane)
				parent:InterruptChannel()
			end
			
			parent:AddNewModifier(	caster,
									ability, "modifier_imba_fiends_grip_handler",
									{duration = fiends_grip_linger_duration, propogated = 1})   
		end
	end
end


-- Rubick shit 
function imba_bane_enfeeble:     IsHiddenWhenStolen()  return false      end
function imba_bane_brain_sap:    IsHiddenWhenStolen()  return false      end
function imba_bane_nightmare:    IsHiddenWhenStolen()  return false      end
function imba_bane_nightmare_end:IsHiddenWhenStolen()  return false      end
function imba_bane_fiends_grip:  IsHiddenWhenStolen()  return false      end
