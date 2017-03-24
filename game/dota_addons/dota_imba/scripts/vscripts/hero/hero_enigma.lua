--[[	Author: Firetoad
		Date: 12.01.2016	]]

CreateEmptyTalents("enigma")
--DebugEmptyTalents("enigma")
-- All of these are available to BOTH server and client!!
imba_enigma_malefice           = imba_enigma_malefice           or class({
		IsHiddenWhenStolen         = function(self) return true                                       end,    
		})  
imba_enigma_demonic_conversion = imba_enigma_demonic_conversion or class({
		IsHiddenWhenStolen         = function(self) return true                                       end,   
		})  
imba_enigma_midnight_pulse     = imba_enigma_midnight_pulse     or class({
		IsHiddenWhenStolen         = function(self) return true                                       end,   
		})  
imba_enigma_black_hole         = imba_enigma_black_hole         or class({
		IsHiddenWhenStolen         = function(self) return true                                       end,   
		}) 
imba_enigma_gravity_well       = imba_enigma_gravity_well       or class({
		IsHiddenWhenStolen         = function(self) return true                                       end,   
		IsStealable                = function(self) return false                                      end,   
		GetIntrinsicModifierName   = function(self) return 'modifier_imba_enigma_gravity_well_stacks' end,   
	  }) 

LinkLuaModifier("modifier_imba_enigma_malefice",           "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_malefice_stun",      "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_demonic_conversion", "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eidolon_buffs",                  "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eidolon_increased_mass",         "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_eidolon_increased_mass_counter", "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_midnight_pulse",     "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_black_hole",         "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_gravity_well",       "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_enigma_gravity_well_stacks","hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("midnight_pulse_damage_instance",     	   "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("midnight_pulse_pull_instance",     		   "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("black_hole_damage_instance",     	       "hero/hero_enigma", LUA_MODIFIER_MOTION_NONE)
local talentnamescheme = "special_bonus_imba_enigma_"

modifier_imba_enigma_malefice = class({  -- ticking debuff for malefice duration
		DeclareFunctions                 = function(self) return modifier_imba_enigma_malefice.funcs end,  		
    IsDebuff                         = function(self) return true                                end,    
    IsPurgable                       = function(self) return true                                end,         
  },{
	funcs = {},
	states = {}
  })

modifier_imba_enigma_malefice_stun = class({ -- actual 'stun' of malefice, make sure to apply this to a radius around primary target
		DeclareFunctions                 = function(self) return modifier_imba_enigma_malefice_stun.funcs          end, -- this function is a special snowflake and has no (self) property. GJ valve
    IsDebuff                         = function(self) return true                                              end,    
    GetEffectName                    = function(self) return "particles/generic_gameplay/generic_stunned.vpcf" end,
    GetEffectAttachType              = function(self) return PATTACH_OVERHEAD_FOLLOW                           end,
		IsStunDebuff                     = function(self) return true                                              end,    
		IsPurgableException              = function(self) return true                                              end,   
		CheckState              				 = function(self) return self.states                                       end,      	
  },
	{
	--vars
	funcs  = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION},
	states = {[MODIFIER_STATE_STUNNED]= true}
  })

modifier_imba_enigma_demonic_conversion = class({
		DeclareFunctions                     = function(self) return modifier_imba_enigma_demonic_conversion.funcs     end,  		
    IsDebuff                             = function(self) return true                                              end,
  },
	{
	funcs  = {},
  })  

modifier_eidolon_buffs = class({ 
		DeclareFunctions                     = function(self) return modifier_eidolon_buffs.funcs                      end,		
    IsBuff                               = function(self) return true                                              end,
    IsPurgable                           = function(self) return false                                             end,           
    IsHidden                             = function(self) return false                                             end,    
		GetModifierAttackSpeedBonus_Constant = function(self) return self.shard_attack_speed 													 end,
		GetModifierPhysicalArmorBonus        = function(self) return self.shard_armor 																 end,
		GetModifierMoveSpeedBonus_Constant   = function(self) return self.shard_movespeed															 end,
  },{
	funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_EVENT_ON_ATTACK,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
	})

modifier_imba_enigma_midnight_pulse = class({ -- damage over tick time and extra pull from grav well
    IsDebuff                         = function(self) return true                                              end,
    IsNightmared                     = function(self) return true                                              end,
    IsPurgable                       = function(self) return true                                              end,       
  })

modifier_imba_enigma_black_hole = class({ -- ultra hard disable, forces pull on gravity well, enigma gets perma buff per hero caught
    DeclareFunctions                 = function(self) return modifier_imba_enigma_black_hole.funcs             end,
		CheckState 											 = function(self) return self.states                                       end,
    IsDebuff                         = function(self) return true                                              end,    
    IsHidden                         = function(self) return false                                             end,
  },{
	funcs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}, 
	states = {[MODIFIER_STATE_STUNNED] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	})

modifier_imba_enigma_gravity_well        = class({})
modifier_imba_enigma_gravity_well_stacks = class({})
midnight_pulse_damage_instance           = class({})
midnight_pulse_pull_instance             = class({})
black_hole_damage_instance               = class({})
modifier_eidolon_increased_mass          = class({
    IsHidden                         = function(self) return true                                              end,
    IsPurgable                       = function(self) return true                                              end,     		
	})
modifier_eidolon_increased_mass_counter = class({
    IsHidden                         = function(self) return false                                             end,		
		})

function imba_enigma_black_hole:GetCastRange(l,t)
	if IsClient() then return self.BaseClass.GetCastRange(self,l,t) end  
	local talentrangebonus = TalentManager(self:GetCaster(), talentnamescheme, {4})
	return self.BaseClass.GetCastRange(self,l,t)+talentrangebonus
end

function imba_enigma_black_hole:GetChannelTime()
	local talentchannelbonus = TalentManager(self:GetCaster(),talentnamescheme,{7})  
	return (self.BaseClass.GetChannelTime(self)+talentchannelbonus)
end

function imba_enigma_demonic_conversion:CastFilterResultTarget(hTarget)
  local caster = self:GetCaster()
	local target = hTarget
	if target then
		if TalentManager(caster,talentnamescheme,{8}) == 1 and target:IsHero() and not target:IsIllusion() and not target == caster then
			return UF_SUCCESS
		elseif TalentManager(caster,talentnamescheme,{8}) == 0 and target:IsHero() then
			return UF_FAIL_HERO
		end
	end	
end

function imba_enigma_demonic_conversion:GetCustomCastErrorTarget( target )
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self"
	elseif target:IsHero() then
		return "Can't target heroes"
	end
end

-------------------------------
--[[ SERVER EXECUTION ONLY ]]--
-----vvvvvvvvvvvvvvvvvvvvv-----

if IsServer() then
function imba_enigma_add_gravity_source(source,vector,strength,duration) 						-- Creates a gravity source indexed by strength, returns the index
  if not source.gravitysources then 
    source.gravitysources = {} 
  end
	for i=1,3 do
  if not source.gravitysources[i] then
    source.gravitysources[i] = {}
  end
end
  table.insert(source.gravitysources[strength], vector)
  if duration then
	 local currentindex = #source.gravitysources[strength]
    Timers:CreateTimer(duration,function()   
    imba_enigma_remove_gravity_source(source,strength,currentindex)        
    return nil
    end)  
  end
  return #source.gravitysources[strength]
end

function imba_enigma_remove_gravity_source(source,strength,index) 									-- Remove a requested gravity source by index and strength
  if not source.gravitysources then
    source.gravitysources = {}
  end
  source.gravitysources[strength][index] = nil 
end

function imba_enigma_change_gravity_source(source,vector,strength,index) 						-- Edit an existing index to not mess up our table order
  if not source.gravitysources then
    source.gravitysources = {}
  end
  source.gravitysources[strength][index] = vector
end


function imba_enigma_gravity_strength_fetcher(source) 															-- Precautionary performance measures
	if not IsServer() then return end
  if source:GetName() ~= 'npc_dota_hero_enigma' then -- we aren't enigma!
    return unpack(_G["gravitytable"..source:GetOpposingTeamNumber()])
  end
	if not _G["gravitytable"..source:GetTeamNumber()] then _G["gravitytable"..source:GetTeamNumber()] = {} end
	if source.resetgravity then
		_G["gravitytable"..source:GetTeamNumber()] = {}
		local teamnumber = source:GetTeamNumber()
		local singularity_stacks = (source:FindModifierByName('modifier_imba_enigma_gravity_well_stacks'):GetStackCount())
		local stack_bonus_pull = ((singularity_stacks*source:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('stack_bonus_pull')))
		table.insert(_G["gravitytable"..teamnumber],source:FindModifierByName('modifier_imba_enigma_gravity_well_stacks'):GetStackCount())
		table.insert(_G["gravitytable"..teamnumber],singularity_stacks*source:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('stack_bonus_pull'))
		table.insert(_G["gravitytable"..teamnumber],singularity_stacks*source:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('stack_bonus_radius'))	
		table.insert(_G["gravitytable"..teamnumber],source:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('radius'))
		table.insert(_G["gravitytable"..teamnumber],source:FindAbilityByName('imba_enigma_midnight_pulse'):GetSpecialValueFor('pull_strength'))
		table.insert(_G["gravitytable"..teamnumber],source:FindAbilityByName('imba_enigma_midnight_pulse'):GetSpecialValueFor('well_pull_strength'))
		table.insert(_G["gravitytable"..teamnumber],source:FindAbilityByName('imba_enigma_black_hole'):GetSpecialValueFor('pull_strength') )
		table.insert(_G["gravitytable"..teamnumber],(source:FindAbilityByName('imba_enigma_black_hole'):GetSpecialValueFor('well_pull_strength') + stack_bonus_pull) )
	end
	source.resetgravity = nil
	return unpack(_G["gravitytable"..source:GetTeamNumber()])
end	
	
function imba_enigma_find_strongest_source(source,target,base_extra_pull,strength)  -- Find our strongest source in 900 radius
	if not source.gravitysources then return end	
	local singularity_stacks,
	stack_bonus_pull,
	stack_bonus_radius,
	base_well_radius,
	midnight_pulse_pull_strength,
	midnight_pulse_well_strength,
	black_hole_pull_strength,
	black_hole_well_strength = imba_enigma_gravity_strength_fetcher(source) -- we don't actually need a bunch of these but i'm lazy and will fix it later, the extra table keys won't hurt too much
	local spell_pull_strengths = {black_hole_pull_strength,midnight_pulse_pull_strength}	
	local spell_well_pull_strengths = {black_hole_well_strength,midnight_pulse_well_strength}
	local mass_stack_bonus_percent = 0
	if target:FindModifierByName('modifier_eidolon_increased_mass_counter') then
	  mass_stack_bonus_percent = target:FindModifierByName('modifier_eidolon_increased_mass_counter'):GetStackCount() / 100
	end
	local talent_percent_bonus = (TalentManager(source,talentnamescheme,{5})/100)+mass_stack_bonus_percent
	local bonus_search_radius = 900*talent_percent_bonus
	local pullstrength = 0
	local gravity_well_triggered = false	
	local enemyloc = target:GetAbsOrigin()	
  local strongest_source = target:GetAbsOrigin() -- failsafe because timers operate independently, we can lose a gravity well or pulse during this calculation (rare)
	for i=3,1,-1 do
		local smallestSoFar  
		for _, y in ipairs(source.gravitysources[i]) do 		
			if math.abs((enemyloc - y):Length2D()) < 900+bonus_search_radius then -- this is a hardcoded 'gravity search range' from the primary target
				if strength and i < strength then print('returned') return end	-- We were called by a lesser gravity source but found a stronger one in the vicinity. To prevent double pulling, we return without doing any game actions
				if i == 3 then gravity_well_triggered = true end																		--target is within a 900 radius to trigger a gravity well, so we 'triggered' it for this calculation run
				if i ~= 3 and gravity_well_triggered == true then pullstrength = pullstrength + spell_well_pull_strengths[i] + (spell_well_pull_strengths[i]*talent_percent_bonus) end	-- set our strength based on the number of gravity sources if a well is nearby, else do nothing in regards to pull strength
				if i < 3 then pullstrength = pullstrength + spell_pull_strengths[i] end	-- gravity wells don't natively have a pull strength, and i don't care enough to write better code here
				if not smallestSoFar or (math.abs((enemyloc - y):Length2D()) < smallestSoFar) then
					smallestSoFar = math.abs((enemyloc - y):Length2D())
					strongest_source = y
				end
			end
		end
	end
	if gravity_well_triggered then pullstrength = pullstrength + base_extra_pull end -- for things that are not sources but have a 'pull speed' when affected by a well
	return strongest_source,pullstrength
end

function imba_enigma_gravity_pull(target,strongest_source,pullstrength,radius)			-- Perform actual gravity pull
	if not strongest_source then return end	
	local enemyloc = target:GetAbsOrigin()
	local distance = (enemyloc - strongest_source):Length2D()	
	if not target:IsMagicImmune() and not IsUninterruptableForcedMovement(target) and not IsRoshan(target) then -- not magic immune, not affected by special moveskills, not roshan	
		if distance < radius then -- if our target is too far, we need to pull them tighter
			local percentage = distance/radius 
			if percentage < 0.50 then -- our pull is stronger but a super strong pull at this range looks dumb, so make it chill out
				target:SetAbsOrigin((enemyloc + (strongest_source - enemyloc):Normalized() * (pullstrength*(percentage*2))*FrameTime())) -- pull strength lessened when close to the center of a source
			elseif percentage > 0.80 then -- we are just on the edge of the radius, so our pull is weaker
				target:SetAbsOrigin((enemyloc + (strongest_source - enemyloc):Normalized() * ((pullstrength*(percentage/2))*FrameTime()))) -- move if they are not within a nominal radius of the ground target				
			else
				target:SetAbsOrigin((enemyloc + (strongest_source - enemyloc):Normalized() * (pullstrength*FrameTime()))) -- move if they are not within a nominal radius of the ground target		
			end
		end	
	end
end

function imba_enigma_gravity_pull_area(source,gtarget,radius,strength)							-- iterate through a group near a ground target
	if not source.gravitysources or source:PassivesDisabled() then return end
	local nearby_enemies = FindUnitsInRadius(source:GetTeamNumber(),
   gtarget,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        FIND_ANY_ORDER,
        false)	
	for _,target in pairs(nearby_enemies) do
		if not target then return end 
		local strongest_source,pullstrength = imba_enigma_find_strongest_source(source,target,0,strength)		
		if strongest_source then
			imba_enigma_gravity_pull(target,strongest_source,pullstrength,radius)
			ResolveNPCPositions(strongest_source,120)
		end
	end
end

function imba_enigma_gravity_pull_single_enemy(source,target,bonuspull) 						-- For targets, searches for a nearby gravity source
	if not source.gravitysources or source:PassivesDisabled() then return end
  local strongest_source,pullstrength = imba_enigma_find_strongest_source(source,target,bonuspull)
	if pullstrength == 0 then return end
	local radius = 900 -- targets hit by this are not gravity sources, we just want to manipulate their position, they don't really have a 'radius' to drag to
	imba_enigma_gravity_pull(target,strongest_source,pullstrength,radius)		
	if strongest_source then return ResolveNPCPositions(strongest_source,65) end
end	
	
function imba_enigma_malefice:OnSpellStart()
  local target,caster = findtarget(self)
	caster.resetgravity = true	
	if target:TriggerSpellAbsorb(self) then return end
  local malefice_duration = getkvValues(self,"total_duration")  
	local talentbonus = TalentManager(self:GetCaster(),talentnamescheme,{1})	
	if TalentManager(self:GetCaster(),talentnamescheme,{2}) then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, TalentManager(self:GetCaster(),talentnamescheme,{2}), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_imba_enigma_malefice", {duration = malefice_duration+talentbonus})  			
		end
	else
		if target:TriggerSpellAbsorb(self) then return end
		target:AddNewModifier(caster, self, "modifier_imba_enigma_malefice", {duration = malefice_duration+talentbonus})  
	end

end

function imba_enigma_demonic_conversion:OnSpellStart()
  local target,caster = findtarget(self)
	caster.resetgravity = true	
  target:EmitSound("Hero_Enigma.Demonic_Conversion")
  local duration,count = getkvValues(self,"duration","eidolon_count")
	if not target:IsHero() then
		target:Kill(ability,caster)
	end 
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then return end
	end
  imba_enigma_create_eidolons(target,caster,self,count,duration)

end

function imba_enigma_create_eidolons(target,caster,abilitysource,number_of_eidolons,duration)
  local base_health,health_per_level,shard_percentage = getkvValues(abilitysource,"base_health","health_per_level","shard_percentage")
	local talentshardbonus = TalentManager(caster,talentnamescheme,{3})
	local eidolon_name = "npc_imba_enigma_eidolon_"..math.min(abilitysource:GetLevel(),4)
	local caster_level = caster:GetLevel()
	local target_loc = target:GetAbsOrigin()
	local shard_health,shard_damage_max,shard_damage_min,shard_green_damage,shard_health_regeneration
	shard_percentage = (shard_percentage+talentshardbonus) / 100
  -- eidolon stuff...
	if target:IsHero() then
		shard_damage_min          = target:GetBaseDamageMin() * shard_percentage
		shard_damage_max          = target:GetBaseDamageMax() * shard_percentage
		shard_green_damage        = target:GetBonusDamage(target) * shard_percentage
		shard_health              = target:GetMaxHealth() * shard_percentage
		shard_health_regeneration = target:GetHealthRegen() * shard_percentage		
	else
		shard_damage_min          = caster:GetBaseDamageMin() * shard_percentage
		shard_damage_max          = caster:GetBaseDamageMax() * shard_percentage
		shard_green_damage        = caster:GetBonusDamage(target) * shard_percentage
		shard_health              = caster:GetMaxHealth() * shard_percentage
		shard_health_regeneration = caster:GetHealthRegen() * shard_percentage
	end	
	for i=1, number_of_eidolons do
		local eidolon_loc = RotatePosition(target_loc, QAngle(0, (i - 1) * 360 / number_of_eidolons, 0), target_loc + caster:GetForwardVector() * 80) 		-- Spawn position
		local eidolon = CreateUnitByName(eidolon_name, eidolon_loc, true, caster, caster, caster:GetTeam())
		Timers:CreateTimer(0.01, function()		-- Prevent nearby units from getting stuck
			local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        eidolon_loc,
        nil,
        128,
        DOTA_UNIT_TARGET_TEAM_BOTH,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER,
        false)
			for _,unit in pairs(units) do
				FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
			end
		end) -- end timer
		eidolon:SetOwner(caster)
    eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)
		eidolon:AddNewModifier(caster, abilitysource, "modifier_kill", {duration = duration}) 
		if target:IsHero() then
			eidolon:AddNewModifier(caster, abilitysource, "modifier_eidolon_buffs", {attacks=0,statsource=target:entindex(),test=1})
		else
			eidolon:AddNewModifier(caster, abilitysource, "modifier_eidolon_buffs", {attacks=0,statsource=caster:entindex()})
		end
		SetCreatureHealth(eidolon, base_health + shard_health, true)
    eidolon:SetBaseDamageMin(shard_damage_min + shard_green_damage + eidolon:GetBaseDamageMin())
    eidolon:SetBaseDamageMax(shard_damage_max + shard_green_damage + eidolon:GetBaseDamageMax())
    eidolon:SetBaseHealthRegen(shard_health_regeneration + eidolon:GetHealthRegen())
	end  
end	
	
function imba_enigma_midnight_pulse:OnSpellStart() 
  local gtarget,caster = findgroundtarget(self)
	caster.resetgravity = true
  local radius,duration,damage= getkvValues(self,"radius","duration","damage_per_tick")  -- populate our vars
	self.radius = radius
	GridNav:DestroyTreesAroundPoint(gtarget,radius,false)
  caster.midnight_pulse_center = gtarget
  local midnight_pulse = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl( midnight_pulse, 0, gtarget )
		ParticleManager:SetParticleControl( midnight_pulse, 1, Vector(radius, radius, radius) ) -- stole this from yahnich
  EmitSoundOnLocationWithCaster(gtarget,"Hero_Enigma.Midnight_Pulse",caster)
  imba_enigma_add_gravity_source(self:GetCaster(),gtarget,2,duration+0.2)
  local elapsed_duration = 0
	local damageinstances =  CreateModifierThinker(caster, self, "midnight_pulse_damage_instance", { duration = duration, damage = damage, radius=radius, gfx = midnight_pulse}, gtarget, caster:GetTeamNumber(), false )
	local pullinstances =  	 CreateModifierThinker(caster, self, "midnight_pulse_pull_instance", { duration = duration, radius=radius,strength=2 }, gtarget, caster:GetTeamNumber(), false )
	imba_enigma_gravity_pull_area(caster,gtarget,radius,2)
end	
	
function imba_enigma_black_hole:OnSpellStart()
  local gtarget,caster = findgroundtarget(self)
	if caster:HasScepter() and caster:FindAbilityByName('imba_enigma_midnight_pulse') then
		caster:FindAbilityByName('imba_enigma_midnight_pulse'):OnSpellStart()
	end
	local singularity_stacks = 1
	local well_radius_bonus = 20
  self.caster,self.gtarget = caster,gtarget
	caster.resetgravity = true
  local radius,
  base_pull_distance,
  stack_pull_distance,
  base_pull_speed,
  stack_pull_speed,
  damage = getkvValues(self,"radius","base_pull_distance","stack_pull_distance","base_pull_speed","stack_pull_speed","damage")
  self.damage = damage
	self.baseradius = base_pull_distance
	if caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks') then
		local singularity_stacks = caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks'):GetStackCount()
		local well_radius_bonus  = caster:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('stack_bonus_radius')		
	end
	radius = radius + TalentManager(self:GetCaster(),talentnamescheme,{6})
  self.radius = radius
  self.pull_distance = (base_pull_distance + stack_pull_distance * singularity_stacks)
  self.channel_time = self:GetChannelTime()
	GridNav:DestroyTreesAroundPoint(gtarget,radius,false)
  self.gravityindex = imba_enigma_add_gravity_source(self:GetCaster(),gtarget,1)
  local black_holeGFX = ParticleManager:CreateParticle('particles/units/heroes/hero_enigma/enigma_blackhole.vpcf', PATTACH_CUSTOMORIGIN, nil)
  self.black_holeGFX = black_holeGFX
    ParticleManager:SetParticleControl( black_holeGFX, 0, gtarget )
		ParticleManager:SetParticleControl( black_holeGFX, 1, Vector(radius, radius, radius) ) -- stole this from yahnich
  EmitSoundOn("Hero_Enigma.Black_Hole",self.caster)    
  self:CreateVisibilityNode(gtarget, self.pull_distance, 4)
  self.black_hole_targets = {}
	self.damageinstances =  CreateModifierThinker(caster, self, "black_hole_damage_instance", { duration = duration, damage = damage, radius=radius, gfx = black_holeGFX}, gtarget, caster:GetTeamNumber(), false )
end	
	
function imba_enigma_black_hole:OnChannelThink()
	imba_enigma_gravity_pull_area(self:GetCaster(),self.gtarget,self.baseradius,1)
  self.nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.gtarget, nil, self.pull_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _,enemy in pairs(self.nearby_enemies) do
		local enemy_loc = enemy:GetAbsOrigin()
		local distance = (enemy_loc - self.gtarget):Length2D()
		if distance > self.radius then
		else
      if not enemy:FindModifierByName("modifier_imba_enigma_black_hole") then
        enemy:AddNewModifier(self.caster, self, "modifier_imba_enigma_black_hole", {duration = (self.channel_time-(GameRules:GetGameTime()-self:GetChannelStartTime()))})
				if self.caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks') and enemy:IsHero() and not enemy:IsIllusion() then
					self.caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks'):IncrementStackCount()
				end
        table.insert(self.black_hole_targets,enemy)
      end
		end
	end
end
	
function imba_enigma_black_hole:OnChannelFinish(bInterrupted)
  imba_enigma_remove_gravity_source(self:GetCaster(),1,self.gravityindex)
	for k,v in pairs(self.black_hole_targets) do
    if self.black_hole_targets[k]:HasModifier("modifier_imba_enigma_black_hole") then
		self.black_hole_targets[k]:FindModifierByName("modifier_imba_enigma_black_hole"):Destroy() -- gracefully end flail on interrupt
    end
  end
  ParticleManager:DestroyParticle(self.black_holeGFX, false)
  ParticleManager:ReleaseParticleIndex(self.black_holeGFX)   
  StopSoundOn("Hero_Enigma.Black_Hole",self.caster)
  EmitSoundOnLocationWithCaster(self.gtarget,"Hero_Enigma.Black_Hole.Stop",self.caster)
  self.damageinstances:Destroy()
end

function imba_enigma_gravity_well:OnSpellStart()
  local gravity_well_duration = getkvValues(self,"duration")
	self:GetCaster().gravitytablereset = true	
  if not self:GetCursorTarget() then -- if we are targetting nothing, then we are probably targetting the ground
    local gtarget,caster = findgroundtarget(self)
		GridNav:DestroyTreesAroundPoint(gtarget,250,false)
    EmitSoundOnLocationWithCaster(gtarget,"Enigma.GravityWellCast",caster)
    local gravity_wellGFX = ParticleManager:CreateParticle("particles/hero/enigma/gravity_well.vpcf", PATTACH_CUSTOMORIGIN, nil)
      ParticleManager:SetParticleControl( gravity_wellGFX, 0, gtarget)
      ParticleManager:SetParticleControl( gravity_wellGFX, 1, Vector(250, 0, 0))
    self.gravity_wellGFX = gravity_wellGFX
    imba_enigma_add_gravity_source(self:GetCaster(),gtarget,3,gravity_well_duration) -- 3 is the weakest source
    Timers:CreateTimer(gravity_well_duration,function()
			ParticleManager:DestroyParticle(gravity_wellGFX, false)
			ParticleManager:ReleaseParticleIndex(gravity_wellGFX)   
			StopSoundOn("Enigma.GravityWellCast",self.caster)           
			return nil
		end)  
	else
    local target,caster = findtarget(self)
		if target:TriggerSpellAbsorb(self) then return end 
    self.gravityindex = imba_enigma_add_gravity_source(self:GetCaster(),target:GetAbsOrigin(),3,gravity_well_duration) 
    target:AddNewModifier(self:GetCaster(), self, "modifier_imba_enigma_gravity_well", {duration = gravity_well_duration})
  end
end

function modifier_imba_enigma_malefice:OnCreated()
  self.stunduration,self.damage,self.well_pull_strength = getkvValues(self:GetAbility(),"stun_duration","tick_damage","well_pull_strength")
  self.caster       = self:GetCaster()
  self.ability      = self:GetAbility()
  self.modifier_parent = self:GetParent()
  self.modifier_parent:AddNewModifier(self.caster,self.ability,"modifier_imba_enigma_malefice_stun",{duration=self.stunduration})
	local singularity_stacks,well_pull_bonus
	if self.caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks') then 
		singularity_stacks = self.caster:FindModifierByName('modifier_imba_enigma_gravity_well_stacks'):GetStackCount()	
		well_pull_bonus = self.caster:FindAbilityByName('imba_enigma_gravity_well'):GetSpecialValueFor('stack_bonus_pull')	
	else
		singularity_stacks = 1
		well_pull_bonus = 5
	end
	self.well_pull_strength = self.well_pull_strength + (singularity_stacks * well_pull_bonus)
  self:StartIntervalThink(2)
end

function modifier_imba_enigma_malefice:CheckState()
	return imba_enigma_gravity_pull_single_enemy(self:GetCaster(),self:GetParent(),self.well_pull_strength)
end

function modifier_imba_enigma_malefice:OnIntervalThink()
  self.modifier_parent:AddNewModifier(self.caster,self.ability,"modifier_imba_enigma_malefice_stun",{duration=self.stunduration})
end

function modifier_imba_enigma_malefice_stun:OnCreated()
  self.stunduration,self.damage,self.well_pull_strength = getkvValues(self:GetAbility(),"stun_duration","tick_damage","well_pull_strength")
  self.caster          = self:GetCaster()
  self.ability         = self:GetAbility()
  self.modifier_parent = self:GetParent()
  self.modifier_parent:StartGesture(ACT_DOTA_DISABLED)
  local dealdamage = {
    victim      = self.modifier_parent,
    attacker    = self.caster,
    damage      = self.damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability     = self.ability
  }
  ApplyDamage(dealdamage)
	EmitSoundOn("Hero_Enigma.Malefice",self.modifier_parent)    
end

function modifier_imba_enigma_malefice_stun:OnDestroy()
  self.modifier_parent:FadeGesture(ACT_DOTA_DISABLED)
end

function modifier_eidolon_buffs:OnCreated(var)
  local shard_percentage,attacks_to_split = getkvValues(self:GetAbility(),"shard_percentage","attacks_to_split") 
	self.parent = self:GetParent()
	self.attacks_to_split = attacks_to_split
  shard_percentage = shard_percentage / 100
  self.attacks = var.attacks
	self.statsource = EntIndexToHScript(var.statsource)
  self.shard_attack_speed        = self.statsource:GetAttackSpeed()        * shard_percentage
  self.shard_movespeed           = self.statsource:GetBaseMoveSpeed()      * shard_percentage
  self.shard_armor               = self.statsource:GetPhysicalArmorValue() * shard_percentage
end



function modifier_eidolon_buffs:OnAttack(vars)
  if vars.attacker == self:GetParent() then
		self.attacks = self.attacks + 1
		if self.attacks >= self.attacks_to_split then 
			self.attacks = 0
			self:GetParent():Heal(9999,self:GetParent():GetOwner())
			local duration = getkvValues(self:GetAbility(),"child_duration") + self:GetParent():FindModifierByName("modifier_kill"):GetDuration()
			imba_enigma_create_eidolons(self:GetParent(),self:GetParent():GetOwner(),self:GetAbility(),1,duration)
		end
		local targetmodifiers = self:GetParent():GetAggroTarget():FindAllModifiersByName('modifier_eidolon_increased_mass')
		if #targetmodifiers > 1 then
			for k,v in pairs(targetmodifiers) do
				if v.index == self.parent:GetEntityIndex() then
					local duration = self:GetAbility():GetSpecialValueFor('increased_mass_duration')	
					v.SetDuration(v,duration,false)
					return
				end
			end
		end
		local duration = self:GetAbility():GetSpecialValueFor('increased_mass_duration')	
		self:GetParent():GetAggroTarget():AddNewModifier(self:GetCaster(), self, "modifier_eidolon_increased_mass", {duration = duration,index = self.parent:GetEntityIndex()})
		self:GetParent():GetAggroTarget():AddNewModifier(self:GetCaster(), self, "modifier_eidolon_increased_mass_counter", {})		
  end
end

function modifier_imba_enigma_black_hole:OnCreated()
  self.parent = self:GetParent()
	self.parent:StartGesture(ACT_DOTA_FLAIL)  -- Flail em
end

function modifier_eidolon_increased_mass:OnCreated(vars)
	self.index = vars.index
end

function modifier_eidolon_increased_mass:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_eidolon_increased_mass_counter:OnCreated()
	self.parent = self:GetParent()
  self:StartIntervalThink(0.1)
end

function modifier_eidolon_increased_mass_counter:OnIntervalThink()
	if #self.parent:FindAllModifiersByName('modifier_eidolon_increased_mass') > 0 then
		self:SetStackCount(#self.parent:FindAllModifiersByName('modifier_eidolon_increased_mass')*7)
	else
		self:Destroy()
	end
end

function modifier_imba_enigma_black_hole:OnDestroy()
  self.parent:FadeGesture(ACT_DOTA_FLAIL)
end

function modifier_imba_enigma_gravity_well:OnCreated()
  local duration = getkvValues(self:GetAbility(),"duration")
  local target = self:GetParent():GetAbsOrigin()
  local caster = self:GetCaster()
  EmitSoundOn("Enigma.GravityWellCast",self:GetParent())
  self.gravityindex = imba_enigma_add_gravity_source(self:GetCaster(),self:GetParent():GetAbsOrigin(),3,duration)
  self.gravity_wellGFX = ParticleManager:CreateParticle("particles/hero/enigma/gravity_well.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl( self.gravity_wellGFX, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl( self.gravity_wellGFX, 1, Vector(250, 0, 0))
    --ParticleManager:SetParticleControl( self.gravity_wellGFX, 5, self:GetParent():GetAbsOrigin() + Vector(0, 0, 100)) -- this one makes it work
    --ParticleManager:SetParticleControlEnt( self.gravity_wellGFX, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "follow_overhead", (self:GetParent():GetAbsOrigin() + Vector(0, 0, 100)), true)  
  self:StartIntervalThink(0)
end

function modifier_imba_enigma_gravity_well:OnIntervalThink()
  imba_enigma_change_gravity_source(self:GetCaster(),self:GetParent():GetAbsOrigin(),3,self.gravityindex)
end

function modifier_imba_enigma_gravity_well:OnDestroy()
  local target = self:GetParent():GetAbsOrigin()
  local caster = self:GetCaster()  
  StopSoundOn("Enigma.GravityWellCast",self:GetParent())
  imba_enigma_remove_gravity_source(caster,3,self.gravityindex)
  ParticleManager:DestroyParticle(self.gravity_wellGFX, true)
  ParticleManager:ReleaseParticleIndex(self.gravity_wellGFX) 
  EmitSoundOnLocationWithCaster(target,"Enigma.GravityWellCast",caster)
  local remainingduration = self:GetDuration() - self:GetElapsedTime()
  if remainingduration > 1 then
  self.gravityindex = imba_enigma_add_gravity_source(self:GetCaster(),target,3,remainingduration)
  self.gravity_wellGFX = ParticleManager:CreateParticle("particles/hero/enigma/gravity_well.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl( self.gravity_wellGFX, 0, target)
    ParticleManager:SetParticleControl( self.gravity_wellGFX, 1, Vector(250, 0, 0))
  imba_enigma_add_gravity_source(caster,gtarget,3) -- 3 is the weakest source
  Timers:CreateTimer(remainingduration,function()
  ParticleManager:DestroyParticle(self.gravity_wellGFX, false)
  ParticleManager:ReleaseParticleIndex(self.gravity_wellGFX)   
  StopSoundOn("Enigma.GravityWellCast",caster)           
  return nil
  end)   
  end
end

function midnight_pulse_damage_instance:OnCreated(vars)
	self:StartIntervalThink(1)
	self.damage = vars.damage
	self.gtarget = self:GetParent():GetAbsOrigin()
	self.caster = self:GetCaster()
	self.radius = vars.radius
	self.gfx = vars.gfx
end

function midnight_pulse_damage_instance:OnIntervalThink()
	local nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
  self.gtarget,
  nil,
  self.radius,
  DOTA_UNIT_TARGET_TEAM_ENEMY,
  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
  FIND_ANY_ORDER,
  false)
	for _,enemy in pairs(nearby_enemies) do
		ApplyDamage({ 
      attacker = self.caster,
      victim = enemy,
      ability = self:GetParent(),
      damage = (enemy:GetMaxHealth() * self.damage / 100), -- get damage from maxhealth
      damage_type = DAMAGE_TYPE_PURE
			})
			end
end

function midnight_pulse_damage_instance:OnDestroy()
	StopSoundOn("Hero_Enigma.Midnight_Pulse",self.caster)            
	ParticleManager:DestroyParticle(self.gfx, false)
  ParticleManager:ReleaseParticleIndex(self.gfx)
end	

function midnight_pulse_pull_instance:OnCreated(vars)	
	self.gtarget = self:GetParent():GetAbsOrigin()
	self.caster = self:GetCaster()	
	self.radius = vars.radius
	self.strength = vars.strength
	self:StartIntervalThink(0)
end

function midnight_pulse_pull_instance:OnIntervalThink()
	imba_enigma_gravity_pull_area(self.caster,self.gtarget,self.radius,2)
end

function black_hole_damage_instance:OnCreated(vars)
	self:StartIntervalThink(1)
	self.damage = vars.damage
	self.gtarget = self:GetParent():GetAbsOrigin()
	self.caster = self:GetCaster()
	self.radius = vars.radius
	self.gfx = vars.gfx
end

function black_hole_damage_instance:OnIntervalThink()
	local nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
  self.gtarget,
  nil,
  self.radius,
  DOTA_UNIT_TARGET_TEAM_ENEMY,
  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
  FIND_ANY_ORDER,
  false)
	for _,enemy in pairs(nearby_enemies) do
		ApplyDamage({ 
      attacker = self.caster,
      victim = enemy,
      ability = self:GetParent(),
      damage = self.damage, -- get damage from maxhealth
      damage_type = DAMAGE_TYPE_PURE
			})
			end
end

function black_hole_damage_instance:OnDestroy()
	StopSoundOn("Hero_Enigma.Midnight_Pulse",self.caster)            
	ParticleManager:DestroyParticle(self.gfx, false)
  ParticleManager:ReleaseParticleIndex(self.gfx)
end	
end