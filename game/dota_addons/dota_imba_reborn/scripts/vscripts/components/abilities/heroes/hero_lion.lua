-- Author: Shush
-- Date: 29/03/2017

------------------------------------------
--             EARTH SPIKE              --
------------------------------------------

imba_lion_earth_spike = class({})
LinkLuaModifier("modifier_imba_earthspike_stun", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_earthspike_death_spike", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_earth_spike:GetAbilityTextureName()
   return "lion_impale"
end

function imba_lion_earth_spike:IsHiddenWhenStolen()
	return false
end 

function imba_lion_earth_spike:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + (self:GetCaster():FindTalentValue("special_bonus_imba_lion_9") / 2)
end
 
function imba_lion_earth_spike:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorPosition()            
	local cast_response = "lion_lion_ability_spike_01"
	local sound_cast = "Hero_Lion.Impale"
	local particle_projectile = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf"    
	
	-- Ability specials
	local spike_speed = ability:GetSpecialValueFor("spike_speed")    
	local spikes_radius = ability:GetSpecialValueFor("spikes_radius")
	local max_bounces_per_cast = ability:GetSpecialValueFor("max_bounces_per_cast")
	local travel_distance = ability:GetSpecialValueFor("travel_distance")

	-- Roll for a cast response
	if RollPercentage(15) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	caster:EmitSound(sound_cast)        
			
	-- Creating a unique list of hit-Targets, delete it after 20 secs
	local dota_time = tostring(GameRules:GetDOTATime(true,true))

	-- Index 
	local hit_targets_index = "hit_targets_" .. dota_time
	local incoming_targets_index = "incoming_targets_"..dota_time

	-- Store on the ability
	self[hit_targets_index] = {}
	self[incoming_targets_index] = {}    

	Timers:CreateTimer(20, function()
		self[hit_targets_index] = nil
		self[incoming_targets_index] = nil
		
	end) 
	
	-- Adjust length if caster has cast increase
	local travel_distance = travel_distance + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_imba_lion_9")

	-- Decide direction
	local direction = (target - caster:GetAbsOrigin()):Normalized()
	
	-- Launch line projectile
	local spikes_projectile = { Ability = ability,
								EffectName = particle_projectile,
								vSpawnOrigin = caster:GetAbsOrigin(),
								fDistance = travel_distance,
								fStartRadius = spikes_radius,
								fEndRadius = spikes_radius,
								Source = caster,
								bHasFrontalCone = false,
								bReplaceExisting = false,
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
								bDeleteOnHit = false,
								vVelocity = direction * spike_speed * Vector(1, 1, 0),
								bProvidesVision = false,
								ExtraData = {hit_targets_index = hit_targets_index, incoming_targets_index = incoming_targets_index, bounces_left = max_bounces_per_cast}
							}
							
	ProjectileManager:CreateLinearProjectile(spikes_projectile)
end

function imba_lion_earth_spike:OnProjectileHit_ExtraData(target, location, extra_data)

	-- If there was no target, do nothing
	if not target then
		return nil
	end    

	-- Ability properties
	local caster = self:GetCaster()      
	local ability = self    
	local sound_impact = "Hero_Lion.ImpaleHitTarget"
	local particle_hit = "particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf"  
	local sound_cast = "Hero_Lion.Impale"
	local particle_projectile = "particles/units/heroes/hero_lion/lion_spell_impale.vpcf"
	local modifier_stun = "modifier_imba_earthspike_stun"
	local modifier_death_spike = "modifier_imba_earthspike_death_spike"

	-- Extra data
	local hit_targets_index = extra_data.hit_targets_index
	local incoming_targets_index = extra_data.incoming_targets_index
	local bounces_left = extra_data.bounces_left
	
	-- Ability specials 
	local knock_up_height = ability:GetSpecialValueFor("knock_up_height")
	local knock_up_time = ability:GetSpecialValueFor("knock_up_time")
	local damage = ability:GetSpecialValueFor("damage")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local spike_speed = ability:GetSpecialValueFor("spike_speed")
	local travel_distance = ability:GetSpecialValueFor("travel_distance")
	local spikes_radius = ability:GetSpecialValueFor("spikes_radius")   
	local extra_spike_AOE = ability:GetSpecialValueFor("extra_spike_AOE")
	local wait_interval = ability:GetSpecialValueFor("wait_interval")    

	-- If the target was already hit by spikes this cast, do nothing
	for _, hit_target in pairs(self[hit_targets_index]) do
		if hit_target == target then            
			return nil
		end
	end      
	
	-- Add target to the hit table
	table.insert(self[hit_targets_index], target)

	-- Adjust length if caster has cast increase
	travel_distance = travel_distance + GetCastRangeIncrease(caster)

	local target_position = target:GetAbsOrigin()
	target_position.z = 0 
	
	-- Add high spikes particles
	local particle_hit_fx = ParticleManager:CreateParticle(particle_hit, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle_hit_fx, 0, target_position)
	ParticleManager:SetParticleControl(particle_hit_fx, 1, target_position)
	ParticleManager:SetParticleControl(particle_hit_fx, 2, target_position)
	ParticleManager:ReleaseParticleIndex(particle_hit_fx)
	
	-- Play hit sound
	caster:EmitSound(sound_impact)  

	-- Should the Spikes branch?
	local should_branch = false

	-- #1 Talent: Earth Spike now branches from creeps as well
	if caster:HasTalent("special_bonus_imba_lion_1") then
		if bounces_left > 0 and (target:IsRealHero() or target:IsCreep()) then
			should_branch = true
		end
	else
		if bounces_left > 0 and target:IsRealHero() then
			should_branch = true
		end
	end    
	
	-- If it can bounce, start a timer and look for bounce target
	if should_branch then
		
		Timers:CreateTimer(wait_interval, function() 

			-- Find closest enemy around target that is not on the hit table and has no lines coming to them.                                
			local enemies = FindUnitsInRadius(caster:GetTeam(),
											 target:GetAbsOrigin(),
											 nil,
											 extra_spike_AOE,
											 DOTA_UNIT_TARGET_TEAM_ENEMY, 
											 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											 DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
											 FIND_CLOSEST,
											 false)                                      
					
			for _,enemy in pairs(enemies) do
				local hit_by_earth_spikes = false
				local earth_spikes_incoming = false

				-- Iterate hit target table
				for _,hit_target in pairs(self[hit_targets_index]) do
					-- Check if the enemy has been hit already
					if hit_target == enemy then
						hit_by_earth_spikes = true
					end
				end                

				-- Iterate incoming targets table
				for _,incoming_target in pairs(self[incoming_targets_index]) do

					-- Check if the enemy has a spike coming to it
					if incoming_target == enemy then
						earth_spikes_incoming = true
					end
				end                

				-- Prevent heroes spiking themselves and those who are already in the tables
				if enemy ~= target and not hit_by_earth_spikes and not earth_spikes_incoming then                   
						
					-- Add the enemy to incoming table
					table.insert(self[incoming_targets_index], enemy)                                    

					-- Reduce bounce counter by one
					bounces_left = bounces_left - 1

					-- Decide direction                    
					local direction = (enemy:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
							
					-- Play sound
					caster:EmitSound(sound_cast)        
								
					-- Launch line projectile
					local spikes_projectile = { Ability = ability,
												EffectName = particle_projectile,
												vSpawnOrigin = target:GetAbsOrigin(),
												fDistance = travel_distance/2,
												fStartRadius = spikes_radius,
												fEndRadius = spikes_radius,
												Source = caster,
												bHasFrontalCone = false,
												bReplaceExisting = false,
												iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,                          
												iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,                           
												bDeleteOnHit = false,
												vVelocity = direction * spike_speed * Vector(1, 1, 0),
												bProvidesVision = false, 
												ExtraData = {hit_targets_index = hit_targets_index, incoming_targets_index = incoming_targets_index, bounces_left = bounces_left}                           
											 }
													
					ProjectileManager:CreateLinearProjectile(spikes_projectile)

					

				-- Stop at the first valid enemy                                        
				break
				end
			end         
		end)
	end
	
	-- If target has magic immunity, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end     
	
	-- Immediately apply stun
	target:AddNewModifier(caster, ability, modifier_stun, {duration = stun_duration})
	
	-- #7 Talent: Earth Spikes slows target by 25% and they take 30% more damage from Finger of Death
	if caster:HasTalent("special_bonus_imba_lion_7") then
	target:AddNewModifier(caster, ability, modifier_death_spike, {duration = knock_up_time + caster:FindTalentValue("special_bonus_imba_lion_7","duration")})
	end

	
		
	-- Knockback unit to the air    
	local knockbackProperties =
	{
		center_x = target.x,
		center_y = target.y,
		center_z = target.z,
		duration = knock_up_time,
		knockback_duration = knock_up_time,
		knockback_distance = 0,
		knockback_height = knock_up_height
	}

	target:AddNewModifier( target, nil, "modifier_knockback", knockbackProperties )

	-- Wait for the target to land and apply damage
	Timers:CreateTimer(knock_up_time, function()
		-- Add target to table of enemies hit
			
		
		local damageTable = {victim = target,
							 attacker = caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = ability
							}
	
		ApplyDamage(damageTable)        
	end)
end

-- Earthspike stun modifier
modifier_imba_earthspike_stun = class({})

function modifier_imba_earthspike_stun:IsHidden() return false end
function modifier_imba_earthspike_stun:IsPurgeException() return true end
function modifier_imba_earthspike_stun:IsStunDebuff() return true end

function modifier_imba_earthspike_stun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_earthspike_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_earthspike_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Earthspike talent modifier
modifier_imba_earthspike_death_spike = class({})

function modifier_imba_earthspike_death_spike:IsHidden() return false end
function modifier_imba_earthspike_death_spike:IsPurgable() return true end

function modifier_imba_earthspike_death_spike:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return funcs
end

function modifier_imba_earthspike_death_spike:GetModifierMoveSpeedBonus_Percentage()
	return self:GetCaster():FindTalentValue("special_bonus_imba_lion_7","slow") * (-1)
end
------------------------------------------
--                HEX                   --
------------------------------------------

imba_lion_hex = class({})
LinkLuaModifier("modifier_imba_lion_hex", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_lion_hex_chain_cooldown", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_hex:GetAbilityTextureName()
   return "lion_voodoo"
end

function imba_lion_hex:IsHiddenWhenStolen()
	return false
end

function imba_lion_hex:GetAOERadius()
	if self:GetCaster():HasTalent("special_bonus_imba_lion_10") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_lion_10")
	else
		return 0
	end
end

function imba_lion_hex:OnSpellStart()
	print(self:GetCaster():FindTalentValue("special_bonus_imba_lion_10"))

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = {"lion_lion_ability_voodoo_03", "lion_lion_ability_voodoo_04", "lion_lion_ability_voodoo_05", "lion_lion_ability_voodoo_06", "lion_lion_ability_voodoo_07", "lion_lion_ability_voodoo_08", "lion_lion_ability_voodoo_09", "lion_lion_ability_voodoo_10"}
	local sound_cast = "Hero_Lion.Voodoo"
	local particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	local modifier_hex = "modifier_imba_lion_hex"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")    

	-- Roll for a cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response[math.random(1,7)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, target)

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end     

	-- Add particle effect
	local particle_hex_fx = ParticleManager:CreateParticle(particle_hex, PATTACH_CUSTOMORIGIN, target)     
	ParticleManager:SetParticleControl(particle_hex_fx, 0, target:GetAbsOrigin())      
	ParticleManager:ReleaseParticleIndex(particle_hex_fx)

	-- Transform your enemy into a frog
	target:AddNewModifier(caster, ability, modifier_hex, {duration = duration})
	
	-- AoE Hex talent
	if caster:HasTalent("special_bonus_imba_lion_10") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
								  target:GetAbsOrigin(),
								  nil,
								  self:GetCaster():FindTalentValue("special_bonus_imba_lion_10"),
								  DOTA_UNIT_TARGET_TEAM_ENEMY,
								  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
								  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
								  FIND_ANY_ORDER,
								  false)
								  
		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				local particle_hex_fx = ParticleManager:CreateParticle(particle_hex, PATTACH_CUSTOMORIGIN, enemy)     
				ParticleManager:SetParticleControl(particle_hex_fx, 0, enemy:GetAbsOrigin())      
				ParticleManager:ReleaseParticleIndex(particle_hex_fx)
				
				enemy:AddNewModifier(caster, ability, modifier_hex, {duration = duration})
			end
		end
	end
end

-- Hex modifier
modifier_imba_lion_hex = class({})

function modifier_imba_lion_hex:OnCreated()    
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_cast = "Hero_Lion.Voodoo"
	self.sound_meme_firetoad = "Imba.LionHexREEE"
	self.particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	self.particle_flaming_frog = "particles/hero/lion/firetoad.vpcf"
	self.modifier_hex = "modifier_imba_lion_hex"
	self.caster_team = self.caster:GetTeamNumber() -- Pugna ward problems
	self.firetoad_chance = 10

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.move_speed = self.ability:GetSpecialValueFor("move_speed")
	self.hex_bounce_radius = self.ability:GetSpecialValueFor("hex_bounce_radius")
	self.maximum_hex_enemies = self.ability:GetSpecialValueFor("maximum_hex_enemies")
	
	-- #6 Talent: Hex bounces to a second enemy
	self.maximum_hex_enemies = self.maximum_hex_enemies + self.caster:FindTalentValue("special_bonus_imba_lion_6")

	-- If the parent is an illusion, pop it and exit
	if self.parent:IsIllusion() then
		self.parent:Kill(self.ability, self.caster)
		return nil
	end

	if IsServer() then

		-- Roll for a Firetoad
		if RollPercentage(self.firetoad_chance) then

			-- REEEEEEEEEEEEE
			EmitSoundOn(self.sound_meme_firetoad, self.parent)    

			-- Set render color of the frog
			self.parent:SetRenderColor(255, 86, 1)

			-- Add flaming frog particle 
			self.particle_flaming_frog_fx = ParticleManager:CreateParticle(self.particle_flaming_frog, PATTACH_POINT_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt(self.particle_flaming_frog_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)    
			self:AddParticle(self.particle_flaming_frog_fx, false, false, -1, false, false)
		end        

		-- Slight modification to wait a frame before applying bounces to respect frantic status resistance (while still applying Chain Hex if duration is less than the standard requirements)
		Timers:CreateTimer(FrameTime(), function()
			self.bounce_interval = math.min(self.ability:GetSpecialValueFor("bounce_interval"), (self:GetRemainingTime() - FrameTime()))
				
			-- Start interval think
			self:StartIntervalThink(self.bounce_interval)
		end)
	end
end

function modifier_imba_lion_hex:OnIntervalThink()
	if IsServer() then
		local hexed_enemies = 0        

		-- Find nearby enemies
		local enemies = FindUnitsInRadius(self.caster_team,
										  self.parent:GetAbsOrigin(),
										  nil,
										  self.hex_bounce_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										  FIND_ANY_ORDER,
										  false)

		-- Get the first enemy that is not the parent, or an hexed target
		for _,enemy in pairs(enemies) do
			if self.parent ~= enemy and not enemy:HasModifier(self.modifier_hex) and not enemy:HasModifier("modifier_imba_lion_hex_chain_cooldown") then

				-- Play hex sound
				EmitSoundOn(self.sound_cast, enemy)

				-- If target has Linken's Sphere off cooldown, do nothing
				if enemy:GetTeam() ~= self.caster_team then
					if enemy:TriggerSpellAbsorb(self.ability) then                        
						return nil
					end
				end     

				-- Add hex particle
				self.particle_hex_fx = ParticleManager:CreateParticle(self.particle_hex, PATTACH_CUSTOMORIGIN, enemy)     
				ParticleManager:SetParticleControl(self.particle_hex_fx, 0, enemy:GetAbsOrigin())      
				ParticleManager:ReleaseParticleIndex(self.particle_hex_fx)

				-- Give it the hex modifier
				enemy:AddNewModifier(self.caster, self.ability, self.modifier_hex, {duration = self.duration})                

				-- Increment count
				hexed_enemies = hexed_enemies + 1

				-- Stop when enough valid enemies were hexed
				if hexed_enemies >= self.maximum_hex_enemies then
					break
				end
			end
		end
	end
end

function modifier_imba_lion_hex:IsHidden() return false end
function modifier_imba_lion_hex:IsPurgable() return true end
function modifier_imba_lion_hex:IsDebuff() return true end

function modifier_imba_lion_hex:CheckState()
	local state
	-- #2 Talent: Hexed targets have break applied to them
	if self:GetCaster():HasTalent("special_bonus_imba_lion_2") then
		state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true,
				 [MODIFIER_STATE_PASSIVES_DISABLED] = true}
	else
		state = {[MODIFIER_STATE_HEXED] = true,
				 [MODIFIER_STATE_DISARMED] = true,
				 [MODIFIER_STATE_SILENCED] = true,
				 [MODIFIER_STATE_MUTED] = true}
	end
				   
	return state
end

function modifier_imba_lion_hex:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
					  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}

	return decFuncs
end

function modifier_imba_lion_hex:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end

function modifier_imba_lion_hex:GetModifierMoveSpeed_Absolute()
	return self.move_speed
end

function modifier_imba_lion_hex:OnDestroy()
	if IsServer() then
		-- Prevent conflict with Lina's Talent. REEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE !
		if self.parent:HasModifier("modifier_imba_fiery_soul_blaze_burn") then
		else
		self.parent:SetRenderColor(255,255,255)        
		end
		
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_imba_lion_hex_chain_cooldown", {duration = self.ability:GetSpecialValueFor("chain_hex_cooldown")})
	end
end

-- Eh, might as well make it somewhat not chain infinitely
modifier_imba_lion_hex_chain_cooldown = class({})

function modifier_imba_lion_hex_chain_cooldown:IgnoreTenacity() 	return true end
function modifier_imba_lion_hex_chain_cooldown:IsDebuff() 			return true end
function modifier_imba_lion_hex_chain_cooldown:IsHidden() 			return false end
function modifier_imba_lion_hex_chain_cooldown:IsPurgable() 		return false end

------------------------------------------
--             Mana Drain               --
------------------------------------------

imba_lion_mana_drain = class({})
LinkLuaModifier("modifier_imba_manadrain_aura", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_manadrain_aura_debuff", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_manadrain_debuff", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_manadrain_buff", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_manadrain_manaovercharge", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_mana_drain:GetAbilityTextureName()
   return "lion_mana_drain"
end

function imba_lion_mana_drain:OnUnStolen()
	local caster = self:GetCaster()

	-- Remove Rubick's Mana Drain aura
	if caster:HasModifier("modifier_imba_manadrain_aura") then
		caster:RemoveModifierByName("modifier_imba_manadrain_aura")
	end
end

function imba_lion_mana_drain:IsHiddenWhenStolen()
	return false
end


function imba_lion_mana_drain:GetIntrinsicModifierName()
	 return "modifier_imba_manadrain_aura"
end

function imba_lion_mana_drain:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Don't apply on targets with 0 max mana (no mana)
		if target:GetMaxMana() == 0 then
			return UF_FAIL_CUSTOM
		end

		-- Can't suck yourself
		if target == caster then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_lion_mana_drain:GetCustomCastErrorTarget(target)
	local caster = self:GetCaster()

	-- Don't apply on targets with 0 max mana (no mana)
	if target:GetMaxMana() == 0 then
		return "dota_hud_error_mana_drain_no_mana"
	end

	-- Can't suck yourself
	if target == caster then
		return "dota_hud_error_mana_drain_self"
	end
end

function imba_lion_mana_drain:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()        
	local sound_cast = "Hero_Lion.ManaDrain"    
	local modifier_drain_enemy = "modifier_imba_manadrain_debuff"
	local modifier_drain_ally = "modifier_imba_manadrain_buff"
	
	-- Ability specials    
	local break_distance = ability:GetSpecialValueFor("break_distance")
	local interval = ability:GetSpecialValueFor("interval")    
	local aura_radius = ability:GetSpecialValueFor("aura_radius")

	-- Play cast sound
	caster:EmitSound(sound_cast)
	
	-- Check for Linken's Sphere
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			-- Stop the caster's channeling
			Timers:CreateTimer(FrameTime(), function()
				caster:InterruptChannel()
			end)
			return nil
		end
	end 
	


	-- Assign the correct modifier based on enemy or ally
	local modifier_manadrain
	local enemy_target = false

	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		-- Enemy modifier
		modifier_manadrain = modifier_drain_enemy
		enemy_target = true
	else
		-- Ally modifier
		modifier_manadrain = modifier_drain_ally
	end

	-- If it is an enemy target, decide behavior depending on if caster has #8 talent
	-- #8 Talent: Mana Drain now targets all units in aura radius
	if enemy_target and caster:HasTalent("special_bonus_imba_lion_8") then
		Timers:CreateTimer(interval, function()
			-- If the caster is no longer channeling, stop everything
			if not caster:IsChanneling() then    
				caster:StopSound(sound_cast)                                       
				return nil
			end     

			-- Find all nearby enemies
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  caster:GetAbsOrigin(),
											  nil,
											  aura_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY, 
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MANA_ONLY,
											  FIND_ANY_ORDER,
											  false)

			-- If there are any enemies, apply debuff modifier to them for the duration of the interval
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					enemy:AddNewModifier(caster, ability, modifier_manadrain, {duration = interval*2})                    
				end

				return interval
			else
				-- No enemies, stop chanelling
				caster:InterruptChannel()
				return nil
			end
		end)
		
	else
		-- Add debuff
		target:AddNewModifier(caster, ability, modifier_manadrain, {})

		-- Start timer every 0.1 interval, 
		Timers:CreateTimer(interval, function()

			-- Check if it's time to break the timer, remove particle and debuff modifier from target
			if not caster:IsChanneling() then    
			caster:StopSound(sound_cast)                           
			target:RemoveModifierByName(modifier_manadrain)
				return nil
			end     
		
			-- Distance and direction
			local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() 
			local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()      
		
			-- Make sure caster is always facing towards the target
			caster:SetForwardVector(direction)  
		
			-- Check for states that break the drain, remove particle if so
			if distance > break_distance or target:IsMagicImmune() or target:IsInvulnerable() then                  
				caster:InterruptChannel()
				caster:StopSound(sound_cast)            
				target:RemoveModifierByName(modifier_manadrain)
				return nil
			end                    
			
			return interval 
		end)    
	end

	
end

-- Mana Drain Aura
modifier_imba_manadrain_aura = class({})

function modifier_imba_manadrain_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
end

function modifier_imba_manadrain_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_manadrain_aura:IsHidden() return true end
function modifier_imba_manadrain_aura:IsPurgable() return false end
function modifier_imba_manadrain_aura:IsDebuff() return false end

function modifier_imba_manadrain_aura:GetAuraDuration()
	return 0.1
end

function modifier_imba_manadrain_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_manadrain_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_imba_manadrain_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_manadrain_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_manadrain_aura:GetEffectName()    
	return "particles/hero/lion/aura_manadrain.vpcf"
end

function modifier_imba_manadrain_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_manadrain_aura:GetModifierAura()
	return "modifier_imba_manadrain_aura_debuff"
end

function modifier_imba_manadrain_aura:IsAura()
	-- Disable when caster is broken
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end


-- Mana Drain aura debuff
modifier_imba_manadrain_aura_debuff = class({})

function modifier_imba_manadrain_aura_debuff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.interval = self.ability:GetSpecialValueFor("interval")
		self.aura_mana_drain_pct = self.ability:GetSpecialValueFor("aura_mana_drain_pct")

		-- Start interval
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_manadrain_aura_debuff:IsHidden()	return false end
function modifier_imba_manadrain_aura_debuff:IsPurgable() return false end
function modifier_imba_manadrain_aura_debuff:IsDebuff() return true end

function modifier_imba_manadrain_aura_debuff:OnIntervalThink()
	if IsServer() then
		-- Calculate mana drain per second
		local mana_drain_per_sec = self.parent:GetMaxMana() * self.aura_mana_drain_pct * 0.01

		-- Actual mana drain for this interval
		local mana_drain = mana_drain_per_sec * self.interval

		-- Reduce the target's mana by the value or get everything he has
		local target_mana = self.parent:GetMana()
		if target_mana > mana_drain then
			self.parent:ReduceMana(mana_drain)
			self.caster:GiveMana(mana_drain)
		else
			self.parent:ReduceMana(target_mana)
			self.caster:GiveMana(target_mana)
		end
	end
end

-- Active Mana Drain debuff modifier (enemies)
modifier_imba_manadrain_debuff = class({})

function modifier_imba_manadrain_debuff:OnCreated()    
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_drain = "particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"

		-- Destroy the target if it is an illusion
		if self.parent:IsIllusion() then
		self.parent:Kill(self.ability, self.caster)
			return nil
		end

		-- Ability specials
		self.interval = self.ability:GetSpecialValueFor("interval")
		self.mana_drain_sec = self.ability:GetSpecialValueFor("mana_drain_sec")
		self.mana_pct_as_damage = self.ability:GetSpecialValueFor("mana_pct_as_damage")

		-- Initalize variables        
		self.mana_drain_per_interval = self.mana_drain_sec * self.interval
		self.mana_drained = nil

		-- Add particles
		self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)        
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_mouth", self.caster:GetAbsOrigin(), true)        
		self:AddParticle(self.particle_drain_fx, false, false, -1, false, false)

	if IsServer() then
		-- Start interval
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_manadrain_debuff:IsHidden() return false end
function modifier_imba_manadrain_debuff:IsPurgable() return false end
function modifier_imba_manadrain_debuff:IsDebuff() return true end

function modifier_imba_manadrain_debuff:OnIntervalThink()
	if IsServer() then
		-- Get target's current mana
		local target_mana = self.parent:GetMana()
		
		-- Check if target has more mana than max possible to drain, else drain what target has     
		if target_mana > self.mana_drain_per_interval then
			self.parent:ReduceMana(self.mana_drain_per_interval)          
			self.caster:GiveMana(self.mana_drain_per_interval)
			self.mana_drained = self.mana_drain_per_interval
		else            
			self.caster:GiveMana(target_mana)
			self.parent:ReduceMana(target_mana)            
			self.mana_drained = target_mana
		end         
		
		-- Damage target by a percent of mana drained
		local damage = self.mana_drained * self.mana_pct_as_damage * 0.01

			local damageTable = {victim = self.parent,
								 attacker = self.caster, 
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL,
								 ability = self.ability
								}

		ApplyDamage(damageTable)
		
		local mana_over_drain = math.floor(self.mana_drained - (self.caster:GetMaxMana() - self.caster:GetMana()))
		-- #3 Talent: Draining Mana while mana pool is full grants Mana Overcharge
		if self.caster:HasTalent("special_bonus_imba_lion_3") and mana_over_drain > 0 then
			local mana_overcharge = self.caster:FindModifierByName("modifier_imba_manadrain_manaovercharge")
			if not mana_overcharge then
				mana_overcharge = self.caster:AddNewModifier(self.caster,self.ability,"modifier_imba_manadrain_manaovercharge",{duration = self.caster:FindTalentValue("special_bonus_imba_lion_3","duration")})
			end
			if mana_overcharge then
			mana_overcharge_stacks = mana_overcharge:GetStackCount()
			mana_overcharge:SetStackCount(mana_overcharge_stacks + mana_over_drain)
			end
		end
	end
end

function modifier_imba_manadrain_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP}

	return decFuncs
end

function modifier_imba_manadrain_debuff:GetModifierMoveSpeedBonus_Percentage()
	-- #4 Talent: Mana drain slows the target according to missing mana
	if self.caster:HasTalent("special_bonus_imba_lion_4") then
		local maximum_mana = self.parent:GetMaxMana()
		local current_mana = self.parent:GetMana()

		return (100 - ((current_mana/maximum_mana) * 100)) * (-1)
	end
	
	return self:GetAbility():GetSpecialValueFor("movespeed") * (-1)
end

function modifier_imba_manadrain_debuff:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("mana_drain_sec")
end

modifier_imba_manadrain_manaovercharge = class({})

function modifier_imba_manadrain_manaovercharge:IsHidden() return false end
function modifier_imba_manadrain_manaovercharge:IsPurgable() return false end

-- Active Mana Drain buff modifier (allies)
modifier_imba_manadrain_buff = class({})

function modifier_imba_manadrain_buff:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_drain = "particles/econ/items/lion/lion_demon_drain/lion_spell_mana_drain_demon.vpcf"

		-- Ability specials
		self.interval = self.ability:GetSpecialValueFor("interval")
		self.mana_drain_sec = self.ability:GetSpecialValueFor("mana_drain_sec")        

		-- Initalize variables        
		self.mana_drain_per_interval = self.mana_drain_sec * self.interval
		self.mana_drained = nil

		-- Add particles
		self.particle_drain_fx = ParticleManager:CreateParticle(self.particle_drain, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_mouth", self.caster:GetAbsOrigin(), true)        
		ParticleManager:SetParticleControlEnt(self.particle_drain_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)        
		self:AddParticle(self.particle_drain_fx, false, false, -1, false, false)

		-- Start interval
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_manadrain_buff:OnIntervalThink()
	if IsServer() then
		-- Get target's current mana
		local caster_mana = self.caster:GetMana()
		
		-- If the caster has more mana than how much it is supposed to give, give it all
		if caster_mana > self.mana_drain_per_interval then
			self.caster:ReduceMana(self.mana_drain_per_interval)          
			self.parent:GiveMana(self.mana_drain_per_interval)            
		else            
			self.parent:GiveMana(caster_mana)
			self.target:ReduceMana(caster_mana)                        
		end                 
	end
end


------------------------------------------
--          FINGER OF DEATH             --
------------------------------------------
imba_lion_finger_of_death = class({})
LinkLuaModifier("modifier_imba_trigger_finger_debuff", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death_hex", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death_delay", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_finger_of_death_counter", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)

function imba_lion_finger_of_death:GetAbilityTextureName()
   return "lion_finger_of_death"
end

function imba_lion_finger_of_death:IsHiddenWhenStolen()
	return false
end

function imba_lion_finger_of_death:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self
	local enemies_frog_radius = ability:GetSpecialValueFor("enemies_frog_radius")

	return enemies_frog_radius
end

function imba_lion_finger_of_death:GetManaCost(level)
	-- Ability properties
	local caster = self:GetCaster()    
	local ability = self
	local modifier_finger = "modifier_imba_trigger_finger_debuff"
	local base_mana_cost = self.BaseClass.GetManaCost(self, level)

	-- Ability special
	local triggerfinger_mana_inc_pct = ability:GetSpecialValueFor("triggerfinger_mana_inc_pct")
	
	-- Get stack count of Trigger Finger
	local stacks = 0
	if caster:HasModifier(modifier_finger) then
		stacks = caster:GetModifierStackCount(modifier_finger, caster)        
	end

	local mana_cost = base_mana_cost * (1 + (stacks * triggerfinger_mana_inc_pct * 0.01))
	return mana_cost
end

function imba_lion_finger_of_death:GetCooldown(level)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local scepter = caster:HasScepter()

	-- Ability specials
	local cooldown = self.BaseClass.GetCooldown(self, level)
	local scepter_cooldown = ability:GetSpecialValueFor("scepter_cooldown")

	-- Assign correct cooldown based on whether or not caster has a scepter
	local base_cooldown
	if scepter then
		base_cooldown = scepter_cooldown
	else
		base_cooldown = cooldown
	end

	return base_cooldown
end

function imba_lion_finger_of_death:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "Hero_Lion.FingerOfDeath"            
	local modifier_finger = "modifier_imba_trigger_finger_debuff"    
	local modifier_hex = "modifier_imba_finger_of_death_hex"
	local scepter = caster:HasScepter()

	-- Ability specials    
	local damage = ability:GetSpecialValueFor("damage")
	local scepter_damage = ability:GetSpecialValueFor("scepter_damage")    
	local scepter_radius = ability:GetSpecialValueFor("scepter_radius")    
	local triggerfinger_duration = ability:GetSpecialValueFor("triggerfinger_duration")    
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")        
	local enemies_frog_radius = ability:GetSpecialValueFor("enemies_frog_radius")        

	-- Enemy killed variable
	ability.enemy_killed = false

	-- Cast sound
	EmitSoundOn(sound_cast, caster)    

	-- Assign damage if caster has scepter
	if scepter then
		damage = scepter_damage
	end
	
	-- #3 Talent: Assign Mana Overcharge damage
	local mana_overcharge = caster:FindModifierByName("modifier_imba_manadrain_manaovercharge")
	if mana_overcharge then
		mana_overcharge_stacks = mana_overcharge:GetStackCount()
		damage = damage + mana_overcharge_stacks
		caster:RemoveModifierByName("modifier_imba_manadrain_manaovercharge")
	end
	
	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end         

	-- Finger main enemy
	FingerOfDeath(caster, ability, target, target, damage, enemies_frog_radius)    

	-- If caster has scepter, find all targets in the scepter radius and fire at them
	if scepter then

		-- Index a table for enemies to be marked
		local finger_scepter_enemies = {}

		enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target:GetAbsOrigin(),
									nil,
									enemies_frog_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
									FIND_ANY_ORDER,
									false)

		for _, enemy in pairs(enemies) do            
			if not enemy:IsMagicImmune() and not enemy:HasModifier(modifier_hex) then
				-- Add enemy to the table
				table.insert(finger_scepter_enemies, enemy)
			end
		end

		enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									target:GetAbsOrigin(),
									nil,
									scepter_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
									FIND_ANY_ORDER,
									false)

		for _,enemy in pairs(enemies) do
			local marked = false
			-- Look at the table to see if enemy was marked (is gonna become hexed)
			for _,marked_enemy in pairs(finger_scepter_enemies) do
				if marked_enemy == enemy then
					marked = true
					break
				end
			end

			-- If target is not the main target, not magic immune, is either stunned or hexed, finger it
			if enemy ~= target and not enemy:IsMagicImmune() then
				if enemy:IsStunned() or enemy:IsHexed() or marked then

					-- Finger enemy (kek)    
					FingerOfDeath(caster, ability, target, enemy, damage, enemies_frog_radius)
				end
			end         
		end        
	end    

	-- Wait for small duration, check if a target has been marked as dead
	Timers:CreateTimer(0.5, function()
		if ability.enemy_killed then
			-- Apply and/or Grant stack of Trigger Finger
			if not caster:HasModifier(modifier_finger) then
				caster:AddNewModifier(caster, ability, modifier_finger, {duration = triggerfinger_duration})
			end

			local modifier_finger_handler = caster:FindModifierByName(modifier_finger)
			if modifier_finger_handler:GetDuration() > triggerfinger_duration then
			modifier_finger_handler:SetDuration(triggerfinger_duration,true)
			end
			modifier_finger_handler:IncrementStackCount()
			modifier_finger_handler:ForceRefresh()

			-- Refresh cooldown completely            
			Timers:CreateTimer(FrameTime(), function()
				ability:EndCooldown()
			end)      
		-- #5 Talent: Trigger Finger always triggers
		elseif caster:HasTalent("special_bonus_imba_lion_5") then
			if not caster:HasModifier(modifier_finger) then
				caster:AddNewModifier(caster, ability, modifier_finger, {duration = caster:FindTalentValue("special_bonus_imba_lion_5")})
			end
				
			local modifier_finger_handler = caster:FindModifierByName(modifier_finger)
			modifier_finger_handler:SetDuration(caster:FindTalentValue("special_bonus_imba_lion_5"),true)
			modifier_finger_handler:IncrementStackCount()
			modifier_finger_handler:ForceRefresh()

			-- Refresh cooldown completely            
			Timers:CreateTimer(FrameTime(), function()
				ability:EndCooldown()
			end)		
		end
	end)
end 

	
function FingerOfDeath(caster, ability, main_target, target, damage, enemies_frog_radius)
	-- Ability properties
	local sound_impact = "Hero_Lion.FingerOfDeathImpact"
	local particle_finger = "particles/units/heroes/hero_lion/lion_spell_finger_of_death.vpcf"
	local modifier_hex = "modifier_imba_finger_of_death_hex"    

	-- Ability specials
	local damage_delay = ability:GetSpecialValueFor("damage_delay")    
	local enemies_frog_duration = ability:GetSpecialValueFor("enemies_frog_duration")
	local damage_per_kill = ability:GetSpecialValueFor("damage_per_kill")
	
	-- Add particle effects
	local particle_finger_fx = ParticleManager:CreateParticle(particle_finger, PATTACH_ABSORIGIN_FOLLOW, caster)

	--ParticleManager:SetParticleControl(particle_finger_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(particle_finger_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_finger_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_finger_fx, 2, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_finger_fx)           

	-- Wait a short delay
	Timers:CreateTimer(damage_delay, function()

		-- Hex all nearby units when Finger hits, however, only if this the main target being fingered
		if main_target == target then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  target:GetAbsOrigin(),
											  nil,
											  enemies_frog_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
											  FIND_ANY_ORDER,
											  false)

			for _, enemy in pairs(enemies) do
				-- Hex them
				if not enemy:IsMagicImmune() and not enemy:HasModifier(modifier_hex) then
					enemy:AddNewModifier(caster, ability, modifier_hex, {duration = enemies_frog_duration})
				end
			end
		end

		-- Make sure the target is not magic immune
		if target:IsMagicImmune() then
			return nil
		end

		target:AddNewModifier(caster, ability, "modifier_imba_finger_of_death_delay", {duration = ability:GetSpecialValueFor("kill_grace_duration")})
		
		-- Play impact sound
		EmitSoundOn(sound_impact, target)

		-- Deal damage to the main target
		if target:HasModifier("modifier_imba_earthspike_death_spike") then
			damage = damage * (1+(caster:FindTalentValue("special_bonus_imba_lion_7","bonus_damage")*0.01))
		end
		
		-- Add damage from counter stacks
		if caster:HasModifier("modifier_imba_finger_of_death_counter") then
			damage = damage + caster:FindModifierByName("modifier_imba_finger_of_death_counter"):GetStackCount() * damage_per_kill
		end
		
		local damageTable = {victim = target,
							 attacker = caster, 
							 damage = damage,
							 damage_type = DAMAGE_TYPE_MAGICAL,
							 ability = ability
							}
	
		ApplyDamage(damageTable)            

		-- Find out if target has died, mark it
		Timers:CreateTimer(FrameTime(), function()
			if not target:IsAlive() and not target:IsIllusion() then
				ability.enemy_killed = true                                
			end
		end)
	end) 
end

-- Trigger Finger modifier
modifier_imba_trigger_finger_debuff = class({})

function modifier_imba_trigger_finger_debuff:IsHidden() return false end
function modifier_imba_trigger_finger_debuff:IsPurgable() return false end
function modifier_imba_trigger_finger_debuff:IsDebuff() return true end


-- Finger's Hex modifier
modifier_imba_finger_of_death_hex = class({})

function modifier_imba_finger_of_death_hex:IsHidden() return false end
function modifier_imba_finger_of_death_hex:IsPurgable() return true end
function modifier_imba_finger_of_death_hex:IsDebuff() return true end

function modifier_imba_finger_of_death_hex:CheckState()
	local state = {[MODIFIER_STATE_HEXED] = true,
				   [MODIFIER_STATE_DISARMED] = true,
				   [MODIFIER_STATE_SILENCED] = true,
				   [MODIFIER_STATE_MUTED] = true}
	return state
end

function modifier_imba_finger_of_death_hex:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
					  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE}

	return decFuncs
end

function modifier_imba_finger_of_death_hex:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end

function modifier_imba_finger_of_death_hex:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("hex_move_speed")
end

function modifier_imba_finger_of_death_hex:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("hex_move_speed")
end

modifier_imba_finger_of_death_delay = class({})
function modifier_imba_finger_of_death_delay:IsPurgable() 		return false end

-- function modifier_imba_finger_of_death_delay:OnCreated()
	-- print("delay created.")
-- end

function modifier_imba_finger_of_death_delay:OnRemoved()
	if not IsServer() then return end
	if not self:GetParent():IsAlive() and (self:GetParent():IsRealHero() or self:GetParent():IsClone()) and not self:GetAbility():IsStolen() then
		self:GetParent():EmitSound("Hero_Lion.KillCounter") 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_finger_of_death_counter", {})
	end
end

modifier_imba_finger_of_death_counter = class({})
function modifier_imba_finger_of_death_counter:IsDebuff() 		return false end
function modifier_imba_finger_of_death_counter:IsHidden() 		return false end
function modifier_imba_finger_of_death_counter:IsPurgable() 	return false end
function modifier_imba_finger_of_death_counter:RemoveOnDeath() 	return false end

function modifier_imba_finger_of_death_counter:OnCreated()
	self:SetStackCount(1)
end

function modifier_imba_finger_of_death_counter:OnRefresh()
	self:IncrementStackCount()
end

function modifier_imba_finger_of_death_counter:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_TOOLTIP}

	return decFuncs
end

function modifier_imba_finger_of_death_counter:OnTooltip()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_per_kill")
end

-- Client-side helper functions --

-- #9 Talent: +1000 Earth Spike Range
LinkLuaModifier("modifier_special_bonus_imba_lion_9", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)
-- #10 Talent: +325 AoE Hex
LinkLuaModifier("modifier_special_bonus_imba_lion_10", "components/abilities/heroes/hero_lion", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lion_9 = class({})
function modifier_special_bonus_imba_lion_9:IsHidden() 			return true end
function modifier_special_bonus_imba_lion_9:IsPurgable() 		return false end
function modifier_special_bonus_imba_lion_9:RemoveOnDeath() 	return false end

modifier_special_bonus_imba_lion_10 = class({})
function modifier_special_bonus_imba_lion_10:IsHidden() 		return true end
function modifier_special_bonus_imba_lion_10:IsPurgable() 		return false end
function modifier_special_bonus_imba_lion_10:RemoveOnDeath() 	return false end

function imba_lion_earth_spike:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_lion_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lion_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_lion_9", {})
	end
end

function imba_lion_hex:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_lion_10") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_lion_10") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_lion_10", {})
	end
end
