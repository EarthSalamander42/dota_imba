-- Editors:
--     Shush, 19.03.2017

-----------------------------
--         STRAFE          --
-----------------------------

imba_clinkz_strafe = class({})
LinkLuaModifier("modifier_imba_strafe_aspd", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_strafe_mount", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_strafe_self_root", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_strafe:GetAbilityTextureName()
   return "clinkz_strafe"
end

function imba_clinkz_strafe:IsHiddenWhenStolen() return false end
function imba_clinkz_strafe:IsNetherWardStealable() return false end
function imba_clinkz_strafe:GetCooldown(level)
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")        
		local modifier_mount = "modifier_imba_strafe_mount"
		
		-- Assign correct cooldown. No need to update the UI
		if self.time_remaining ~= nil then  
			local time_remaining = self.time_remaining
			self.time_remaining = nil
			
			return self.BaseClass.GetCooldown(self, level) - (duration - math.max(time_remaining,0))            
		end
	end

	return self.BaseClass.GetCooldown(self, level)
end

function imba_clinkz_strafe:GetBehavior()
	local caster = self:GetCaster()
	local modifier_mount = "modifier_imba_strafe_mount"
	local modifier_self_root = "modifier_imba_strafe_self_root"

	if caster:HasModifier(modifier_mount) or caster:HasModifier(modifier_self_root) then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function imba_clinkz_strafe:GetManaCost(level)
	local caster = self:GetCaster()
	-- If Clinkz is currently mounted, remove the mana cost
	if caster:HasModifier("modifier_imba_strafe_mount") then
		return 0    
	end

	-- Otherwise, return normal mana cost
	return self.BaseClass.GetManaCost(self, level)
end


function imba_clinkz_strafe:OnSpellStart()
	if IsServer() then        
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local target = self:GetCursorTarget()
		local sound_cast = "Hero_Clinkz.Strafe"    
		local modifier_aspd = "modifier_imba_strafe_aspd"
		local modifier_mount = "modifier_imba_strafe_mount"

		-- Ability specials
		local duration = ability:GetSpecialValueFor("duration")

		-----------------------
		--    CANCEL ROOT    --
		-----------------------
		if caster:HasModifier("modifier_imba_strafe_self_root") then
			caster:RemoveModifierByName("modifier_imba_strafe_self_root")
			
			-- Renew cooldown so it would use the new time remaining variable
			ability:EndCooldown()
			ability:UseResources(false, false, true)
			
			return 0
		end
		
		-----------------------
		--    NORMAL CAST    --
		-----------------------
		if not caster:HasModifier(modifier_mount) then

			-- Play cast sound
			EmitSoundOn(sound_cast, caster)

			-- Apply attack speed modifier    
			caster:AddNewModifier(caster, ability, modifier_aspd, {duration = duration})

			-- If used on ally, apply mount modifier
			if caster ~= target then            
				ability:EndCooldown()
				
				local modifier = caster:AddNewModifier(caster, ability, modifier_mount, {duration = duration})
				if modifier then
					modifier.target = target
				end
			end
			
			if caster:HasTalent("special_bonus_imba_clinkz_5") then
				if target == caster then
					ability:EndCooldown()
					local modifier_self_root = "modifier_imba_strafe_self_root"
					
					print("Root duration: ", duration)
					
					caster:AddNewModifier(caster, ability, modifier_self_root, {duration = duration})
				end
			end
				
			-----------------------
			--     DISMOUNT      --
			-----------------------
		else  
			-- Assign the time remaining to the ability and remove modifier
			local modifier_mount_handler = caster:FindModifierByName(modifier_mount)
			ability.time_remaining = modifier_mount_handler:GetRemainingTime()
			caster:RemoveModifierByName(modifier_mount)   

			-- Renew cooldown so it would use the new time remaining variable
			ability:EndCooldown()
			ability:UseResources(false, false, true)
		end
	end
end


-- Attack speed modifier
modifier_imba_strafe_aspd = class({})

function modifier_imba_strafe_aspd:OnCreated()
	self.modifier_mount = "modifier_imba_strafe_mount"

	self.as_bonus = self:GetAbility():GetSpecialValueFor("as_bonus")
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
end

function modifier_imba_strafe_aspd:IsHidden() return false end
function modifier_imba_strafe_aspd:IsPurgable() return true end
function modifier_imba_strafe_aspd:IsDebuff() return false end

function modifier_imba_strafe_aspd:GetEffectName()
	return "particles/units/heroes/hero_clinkz/clinkz_strafe_fire.vpcf"
end

function modifier_imba_strafe_aspd:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_strafe_aspd:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS}

	return decFuncs
end

function modifier_imba_strafe_aspd:GetModifierAttackSpeedBonus_Constant()

	-- 7.01, grants 2x the bonus when mounted
	
	if self:GetCaster():HasModifier(self.modifier_mount) then 
		return self.as_bonus + self.as_bonus
	else
		return self.as_bonus 
	end
	return nil
end

function modifier_imba_strafe_aspd:GetModifierAttackRangeBonus()

	-- 7.01, grants buff when not mounted, also 2x the bonus when mounted	
	if self:GetCaster():HasModifier(self.modifier_mount) then 
		return self.bonus_attack_range + self.bonus_attack_range
	else
		-- 7.01, talent grants buff when not mounted, also 4x the bonus when casted on self		
		if self:GetCaster():HasModifier("modifier_imba_strafe_self_root") then
			return self.bonus_attack_range * self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_5")
		else
			return self.bonus_attack_range
		end
	end
	return nil 
end


-- Mount modifier
modifier_imba_strafe_mount = class({})

function modifier_imba_strafe_mount:OnCreated()
	if IsServer() then
		-- Ability properties


		-- Ability specials
		self.duration = self:GetAbility():GetSpecialValueFor("duration")

		-- Wait a game tick so we can have the target assigned to this modifier
		Timers:CreateTimer(FrameTime(), function()           
			-- Get mount location
			local direction = self.target:GetForwardVector()
			local collision_radius = self:GetCaster():GetPaddedCollisionRadius() + self.target:GetPaddedCollisionRadius() + 80
			local mount_point = self.target:GetAbsOrigin() + direction * (-1) * collision_radius

			-- Set Clinkz' location to it        
			self:GetCaster():SetAbsOrigin(mount_point)            

			-- Start thinking
			self:StartIntervalThink(FrameTime())
		end)        
	end
end

function modifier_imba_strafe_mount:IsHidden() return false end
function modifier_imba_strafe_mount:IsPurgable() return true end
function modifier_imba_strafe_mount:IsDebuff() return false end

function modifier_imba_strafe_mount:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}

	return state
end

function modifier_imba_strafe_mount:OnIntervalThink()
	if IsServer() then
		-- Get new point        
		local current_loc = self:GetCaster():GetAbsOrigin()

		local direction = self.target:GetForwardVector()
		local collision_radius = self:GetCaster():GetPaddedCollisionRadius() + self.target:GetPaddedCollisionRadius() + 80
		local mount_point = self.target:GetAbsOrigin() + direction * (-1) * collision_radius

		local distance = (mount_point - current_loc):Length2D()

		-- If target died, kill modifier
		if not self.target:IsAlive() then
			self:Destroy()
		end

		-- If the target is invulnerable, kill modifier
		if self.target:IsInvulnerable() then
			self:Destroy()
		end

		if distance > 300 then
			-- Set Clinkz' location to it        
			self:GetCaster():SetAbsOrigin(mount_point) 
		else
			-- Move Clinkz toward it
			direction = (mount_point - current_loc):Normalized()            
			local target_movespeed = self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed())

			local new_point = current_loc + direction * ((target_movespeed * 1.25) * FrameTime())
			local ground_point = GetGroundPosition(new_point, self:GetCaster())
			new_point.z = ground_point.z

			if distance > 25 then                
				self:GetCaster():SetAbsOrigin(new_point)
			end
		end
	end
end

function modifier_imba_strafe_mount:OnRemoved()
	if IsServer() then
		-- Start cooldown, reduce it by the duration of the skill
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility().time_remaining = self:GetRemainingTime()
			self:GetAbility():UseResources(false, false, true)
		end
	end
end

modifier_imba_strafe_self_root = class({})

function modifier_imba_strafe_self_root:IsHidden() 		return false end
function modifier_imba_strafe_self_root:IsPurgable() 	return true end
function modifier_imba_strafe_self_root:IsDebuff() 		return false end

function modifier_imba_strafe_self_root:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}

	return state
end

function modifier_imba_strafe_self_root:OnRemoved()
	if IsServer() then
		-- Start cooldown, reduce it by the duration of the skill
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility().time_remaining = self:GetRemainingTime()
			self:GetAbility():UseResources(false, false, true)
		end
	end
end


-----------------------------
--     SEARING ARROWS      --
-----------------------------

imba_clinkz_searing_arrows = class({})
LinkLuaModifier("modifier_imba_searing_arrows_passive", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_searing_arrows_active", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_searing_arrows:GetAbilityTextureName()
   return "clinkz_searing_arrows"
end

function imba_clinkz_searing_arrows:GetIntrinsicModifierName()    
	return "modifier_imba_searing_arrows_passive"
end

function imba_clinkz_searing_arrows:GetCastRange(location, target)
	 local caster = self:GetCaster()
	 return caster:Script_GetAttackRange()
end 

function imba_clinkz_searing_arrows:IsHiddenWhenStolen()
	return false
end

function imba_clinkz_searing_arrows:OnUnStolen()
	-- Rubick interaction
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_searing_arrows_passive") then
		caster:RemoveModifierByName("modifier_imba_searing_arrows_passive")
	end
end

function imba_clinkz_searing_arrows:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local particle_projectile = "particles/hero/clinkz/searing_flames_active/clinkz_searing_arrow.vpcf"
	local sound_cast = "Hero_Clinkz.SearingArrows"

	-- Ability specials
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")

	-- Play attack sound
	EmitSoundOn(sound_cast, caster)    

	-- Launch projectile on target
	local searing_arrow_active
	searing_arrow_active = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particle_projectile,
		iMoveSpeed = projectile_speed,
		bDodgeable = true, 
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = true,        
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()      
		}

	ProjectileManager:CreateTrackingProjectile(searing_arrow_active)

	-- #4 Talent: Searing Arrow active hits in an AoE
	if caster:HasTalent("special_bonus_imba_clinkz_4") then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  target:GetAbsOrigin(),
										  nil,
										  caster:FindTalentValue("special_bonus_imba_clinkz_4"),
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										  FIND_ANY_ORDER,
										  false)

		-- Fire arrows at anyone that is not the main target
		for _,enemy in pairs(enemies) do 
			if enemy ~= target then
				-- Launch projectile on enemy
				local searing_arrow_active_seconday
				searing_arrow_active_seconday = {
					Target = enemy,
					Source = caster,
					Ability = ability,
					EffectName = particle_projectile,
					iMoveSpeed = projectile_speed,
					bDodgeable = true, 
					bVisibleToEnemies = true,
					bReplaceExisting = false,
					bProvidesVision = true,        
					iVisionRadius = vision_radius,
					iVisionTeamNumber = caster:GetTeamNumber()      
					}

				ProjectileManager:CreateTrackingProjectile(searing_arrow_active_seconday)
			end
		end
	end
end

function imba_clinkz_searing_arrows:OnProjectileHit(target, location)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local sound_hit = "Hero_Clinkz.SearingArrows.Impact"
		local modifier_active = "modifier_imba_searing_arrows_active"

		-- Ability specials
		local active_duration = ability:GetSpecialValueFor("active_duration")

		-- If target has Linken Sphere, block effect entirely
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- Play hit sound
		EmitSoundOn(sound_hit, target)

		-- Perform an attack on the target
		caster:PerformAttack(target, false, true, true, false, false, false, true)

		-- Apply the active debuff
		target:AddNewModifier(caster, ability, modifier_active, {duration = active_duration})
	end
end

function imba_clinkz_searing_arrows:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()    
		caster:RemoveModifierByName("modifier_imba_searing_arrows_passive")    
		caster:AddNewModifier(caster, self, "modifier_imba_searing_arrows_passive", {})
	end
end

-- Passive Clinkz Searing Arrows modifier
modifier_imba_searing_arrows_passive = class({})

function modifier_imba_searing_arrows_passive:OnCreated()
	-- Ability properties

	-- Ability specials
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_searing_arrows_passive:IsHidden() return true end
function modifier_imba_searing_arrows_passive:IsPurgable() return false end
function modifier_imba_searing_arrows_passive:IsDebuff() return false end

function modifier_imba_searing_arrows_passive:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
					  MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}

	return decFuncs
end

function modifier_imba_searing_arrows_passive:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If the ability is null, do nothing
		if self:GetAbility():IsNull() then
			return nil
		end

		-- If the ability is stolen, do nothing
		if self:GetAbility():IsStolen() then
			return nil
		end

		-- If the target is not a valid Searing Arrow target, do nothing
		if not target:IsHero() and not target:IsBuilding() and not target:IsCreep() then
			SetArrowAttackProjectile(self:GetCaster(), false)
			return nil
		end          

		-- Only apply to the caster's attacks on enemy team
		if self:GetCaster() == attacker and self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
			-- Change to correct projectile
			if self:GetCaster():PassivesDisabled() then
				SetArrowAttackProjectile(self:GetCaster(), false)
			else
				SetArrowAttackProjectile(self:GetCaster(), true)

				if self:GetCaster():HasTalent("special_bonus_imba_clinkz_7") then				
					if RollPercentage(self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_7")) then
					   self:GetCaster():PerformAttack(target, false, true, true, false, true, false, false)
					end
				end
			end        
		end        
	end
end


function modifier_imba_searing_arrows_passive:GetModifierBaseAttack_BonusDamage()
	-- If the ability is null, do nothing
	if self:GetAbility():IsNull() then
		return nil
	end
	
	-- Ignore if it is a stolen ability
	if self:GetAbility():IsStolen() then
		return nil
	end

	if not self:GetCaster():PassivesDisabled() then
		return self.bonus_damage -- + self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_3")
	end

	return nil
end

function SetArrowAttackProjectile(caster, searing_arrows)    
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi"
	local deso_modifier = "modifier_item_imba_desolator" 
	local morbid_modifier = "modifier_imba_morbid_mask"
	local mom_modifier = "modifier_imba_mask_of_madness"
	local satanic_modifier = "modifier_imba_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_blood"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"  
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"  
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- searing arrow projectiles
	local basic_arrow = "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf"
	local searing_arrow = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	
	local searing_lifesteal_projectile = "particles/hero/clinkz/searing_lifesteal/searing_lifesteal_arrow.vpcf"
	local searing_skadi_projectile = "particles/hero/clinkz/searing_skadi/searing_skadi_arrow.vpcf"
	local searing_deso_projectile = "particles/hero/clinkz/searing_desolator/searing_desolator_arrow.vpcf"  
	local searing_deso_skadi_projectile = "particles/hero/clinkz/searing_skadi_desolator/searing_skadi_desolator_arrow.vpcf"
	local searing_lifesteal_skadi_projectile = "particles/hero/clinkz/searing_skadi_lifesteal/searing_skadi_steal_arrow.vpcf"
	local searing_lifesteal_deso_projectile = "particles/hero/clinkz/searing_deso_lifesteal/searing_deso_lifesteal.vpcf"
	local searing_lifesteal_deso_skadi_projectile = "particles/hero/clinkz/searing_skadi_deso_steal/searing_skadi_deso_steal_arrow.vpcf"

	-- Set variables
	local has_lifesteal
	local has_skadi
	local has_desolator

	-- Assign variables
	-- Lifesteal
	if caster:HasModifier(morbid_modifier) or caster:HasModifier(mom_modifier) or caster:HasModifier(satanic_modifier) or caster:HasModifier(vladimir_modifier) or caster:HasModifier(vladimir_2_modifier) then
		has_lifesteal = true
	end

	-- Skadi
	if caster:HasModifier(skadi_modifier) then
		has_skadi = true
	end

	-- Desolator
	if caster:HasModifier(deso_modifier) then
		has_desolator = true
	end

	-- ASSIGN PARTICLES
	-- searing attack
	if searing_arrows then
		-- Desolator + lifesteal + searing + skadi
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(searing_lifesteal_deso_skadi_projectile)
			return

		-- Desolator + lifesteal + searing
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(searing_lifesteal_deso_projectile)
			return 

		-- Desolator + skadi + searing 
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(searing_deso_skadi_projectile)
			return

		-- Lifesteal + skadi + searing 
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(searing_lifesteal_skadi_projectile)
			return

		-- skadi + searing
		elseif has_skadi then
			caster:SetRangedProjectileName(searing_skadi_projectile)
			return

		-- lifesteal + searing
		elseif has_lifesteal then
			caster:SetRangedProjectileName(searing_lifesteal_projectile)
			return

		-- Desolator + searing            
		elseif has_desolator then
			caster:SetRangedProjectileName(searing_deso_projectile)
			return

		-- searing
		else
			caster:SetRangedProjectileName(searing_arrow)
			return
		end
	
	else -- Non searing attack
		-- Skadi + desolator
		if has_skadi and has_desolator then
			caster:SetRangedProjectileName(deso_skadi_projectile)
			return

		-- Skadi
		elseif has_skadi then
			caster:SetRangedProjectileName(skadi_projectile)
			return

		-- Desolator
		elseif has_desolator then
			caster:SetRangedProjectileName(deso_projectile)
			return 

		-- Lifesteal
		elseif has_lifesteal then
			caster:SetRangedProjectileName(lifesteal_projectile)
			return 

		-- Basic arrow
		else
			caster:SetRangedProjectileName(basic_arrow)
			return 
		end
	end
end



-- Active burning Searing Arrow modifier
modifier_imba_searing_arrows_active = class({})

function modifier_imba_searing_arrows_active:IsHidden() return false end
function modifier_imba_searing_arrows_active:IsPurgable() return true end
function modifier_imba_searing_arrows_active:IsDebuff() return true end

function modifier_imba_searing_arrows_active:OnCreated()
	-- Ability properties
	self.particle_flame = "particles/hero/clinkz/searing_flames_active/burn_effect.vpcf"

	-- Ability specials
	self.vision_radius = self:GetAbility():GetSpecialValueFor("vision_radius")
	self.active_tick_interval = self:GetAbility():GetSpecialValueFor("active_tick_interval")        
	self.armor_burn_per_stack = self:GetAbility():GetSpecialValueFor("armor_burn_per_stack")

	if IsServer() then
		-- Add and attach flaming particle
		self.particle_flame_fx = ParticleManager:CreateParticle(self.particle_flame, PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.particle_flame_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		self:AddParticle(self.particle_flame_fx, false, false, -1, false, false)        
		
		-- Start revealing 
		self:StartIntervalThink(FrameTime())		

		-- Strengthen the armor reduction by adding stacks once every second
		Timers:CreateTimer(self.active_tick_interval, function()
			if not self:IsNull() then
				self:IncrementStackCount()
				return self.active_tick_interval
			end

			return nil
		end)
	end
end

function modifier_imba_searing_arrows_active:OnIntervalThink()    
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision_radius, FrameTime(), false)		     
end

function modifier_imba_searing_arrows_active:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_imba_searing_arrows_active:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_burn_per_stack * (-1)
end

	
-----------------------------
--     SKELETON WALK       --
-----------------------------

imba_clinkz_skeleton_walk = class({})
LinkLuaModifier("modifier_imba_skeleton_walk_invis", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_spook", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_talent_root", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skeleton_walk_talent_ms", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_skeleton_walk:GetAbilityTextureName()
   return "clinkz_wind_walk"
end

function imba_clinkz_skeleton_walk:IsHiddenWhenStolen()
	return false
end

function imba_clinkz_skeleton_walk:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local particle_invis = "particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf"
	local sound_cast = "Hero_Clinkz.WindWalk"
	local modifier_invis = "modifier_imba_skeleton_walk_invis"
	local scepter = caster:HasScepter()
	local modifier_mount = "modifier_imba_strafe_mount"

	-- Ability specials
	local duration = self:GetSpecialValueFor("duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add particle effect
	local particle_invis_fx = ParticleManager:CreateParticle(particle_invis, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_invis_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_invis_fx, 1, caster:GetAbsOrigin())

	-- Apply invisibilty modifier on self
	caster:AddNewModifier(caster, self, modifier_invis, {duration = duration})

	-- Scepter skeleton walk on mounted 
	if scepter then        
		if caster:HasModifier(modifier_mount) then
			local modifier_mount_handler = caster:FindModifierByName(modifier_mount)
			if modifier_mount_handler then
				local mounted_ally = modifier_mount_handler.target
				mounted_ally:AddNewModifier(caster, self, modifier_invis, {duration = modifier_mount_handler:GetRemainingTime()})
			end
		end

	end
end

-- Invisibility modifier
modifier_imba_skeleton_walk_invis = class({})

function modifier_imba_skeleton_walk_invis:IsHidden() return false end
function modifier_imba_skeleton_walk_invis:IsPurgable() return false end
function modifier_imba_skeleton_walk_invis:IsDebuff() return false end

function modifier_imba_skeleton_walk_invis:OnCreated()
	-- Ability properties
	self.sound_cast = "Hero_Clinkz.WindWalk"
	self.modifier_spook = "modifier_imba_skeleton_walk_spook"        
	self.modifier_talent_ms = "modifier_imba_skeleton_walk_talent_ms"
	self.modifier_mount = "modifier_imba_strafe_mount"   

	-- Ability specials
	self.spook_radius = self:GetAbility():GetSpecialValueFor("spook_radius")
	self.base_spook_duration = self:GetAbility():GetSpecialValueFor("base_spook_duration")
	self.spook_distance_inc = self:GetAbility():GetSpecialValueFor("spook_distance_inc")
	self.spook_added_duration = self:GetAbility():GetSpecialValueFor("spook_added_duration")    
	self.ms_bonus_pct = self:GetAbility():GetSpecialValueFor("ms_bonus_pct")

	-- Talent: Increases Clinkz Skeleton Walk movement speed if no enemies are nearby.
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_skeleton_walk_invis:OnIntervalThink()
	if IsServer() then
		-- If it is someone else from the caster (agh effect) then
		-- Check if the caster still has the Mounted buff. Remove it if he doesn't.    
		if self:GetParent() ~= self:GetCaster() then
			if not self:GetCaster():HasModifier(self.modifier_mount) then
				self:Destroy()
			end
		end	
	
		-- Talent: Increases Clinkz Skeleton Walk movement speed if no enemies are nearby.	
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
											self:GetCaster():GetAbsOrigin(),
											nil,
											self.spook_radius,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
											
		if self:GetCaster():HasTalent("special_bonus_imba_clinkz_2") then
			if #enemies > 0 then			    
				self:SetStackCount(self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_2"))
			else
				self:SetStackCount(0)
			end
		end
			
	   -- Talent: If Clinkz passed through an enemy, root him and Clinkz loses Invisibility.	
		if self:GetCaster():HasTalent("special_bonus_imba_clinkz_3") then				
		
		local enemy_heroes = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
											self:GetParent():GetAbsOrigin(),
											nil,
											128,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_CLOSEST,
											false)
											
			for _,enemy in pairs(enemy_heroes) do				
				-- Stop at the first valid enemy that isn't magic immune
				if not enemy:IsMagicImmune() then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_skeleton_walk_talent_root", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_3")})

					-- If an enemy was rooted successfully, remove Clinkz's invisibility
					if enemy:HasModifier("modifier_imba_skeleton_walk_talent_root") then
						self:Destroy()
					end

					-- Stop the cycle!
					break
				end
			end
		end
	end    
end

function modifier_imba_skeleton_walk_invis:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_INVISIBLE] = true}
	return state
end

function modifier_imba_skeleton_walk_invis:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_skeleton_walk_invis:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_MOVESPEED_MAX,
					  MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
					  MODIFIER_EVENT_ON_ABILITY_EXECUTED,
					  MODIFIER_EVENT_ON_ATTACK}

	return decFuncs
end

function modifier_imba_skeleton_walk_invis:GetModifierMoveSpeed_Max()
	if self:GetStackCount() > 0 then
		return 700
	end
end

function modifier_imba_skeleton_walk_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_skeleton_walk_invis:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus_pct + self:GetStackCount()
end

function modifier_imba_skeleton_walk_invis:OnAbilityExecuted(keys)
	if IsServer() then       
		local caster = keys.unit        

		-- Only apply when Clinkz was the one who activated an ability        
		if self:GetParent() == caster then            
			local enemy = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
											self:GetParent():GetAbsOrigin(),
											nil,
											1000,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
											FIND_CLOSEST,
											false)

			-- Check if Clinkz is visible to the enemy when appearing            
			if enemy[1] and enemy[1]:CanEntityBeSeenByMyTeam(self:GetParent()) then
				self.detected = true
			end

			-- Remove the invisibilty
			self:Destroy()        
		end        
	end
end

function modifier_imba_skeleton_walk_invis:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply when Clinkz was the one attacking anything
		if self:GetParent() == attacker then
			-- Find nearby closest enemy
			local enemy = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
											self:GetParent():GetAbsOrigin(),
											nil,
											1000,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
											DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
											FIND_CLOSEST,
											false)
			
			-- Check if Clinkz is visible to the enemy when appearing            
			if enemy[1] and enemy[1]:CanEntityBeSeenByMyTeam(self:GetParent()) then
				self.detected = true
			end            
 
			-- Remove invisibility
			self:Destroy()
		end
	end
end

function modifier_imba_skeleton_walk_invis:OnRemoved()
	if IsServer() then
		-- #6 Talent: Skeleton Walk move speed persists for a small period
		if self:GetCaster():HasTalent("special_bonus_imba_clinkz_6") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_talent_ms, {duration = self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_6")})
		end        

		-- Only apply if Clinkz wasn't detected before removing modifier
		if self.detected then
			return nil
		end

		-- If Clinkz died, when it was removed, do nothing
		if not self:GetCaster():IsAlive() then
			return nil
		end

		-- Play cast sound, yes, again
		EmitSoundOn(self.sound_cast, self:GetParent())
		
		-- Find nearby enemies
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
										  self:GetParent():GetAbsOrigin(),
										  nil,
										  self.spook_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
										  FIND_ANY_ORDER,
										  false)

		
		for _,enemy in pairs(enemies) do
			-- Only apply on non-magic immune enemies
			if not enemy:IsMagicImmune() then
				-- Calculate distance to each enemy
				local distance = (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D()

				-- Calculate spook duration
				local spook_duration = self.base_spook_duration + (((self.spook_radius - distance) / self.spook_distance_inc) * self.spook_added_duration)

				-- Apply spook for the duration
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), self.modifier_spook, {duration = spook_duration})
			end
		end
		
		-- Are we feeling extra spooky today? Did we actually spooky anyone?
		local spook_likelihood = 10
		if #enemies > 0 and RollPercentage(spook_likelihood) then
			-- sPo0kY sCaRy sKeLeToNs
			EmitSoundOn("Imba.ClinkzSpooky", self:GetParent())
		end
	end
end

-- Spook modifier
modifier_imba_skeleton_walk_spook = class({})

function modifier_imba_skeleton_walk_spook:IsHidden() return false end
function modifier_imba_skeleton_walk_spook:IsPurgable() return true end
function modifier_imba_skeleton_walk_spook:IsDebuff() return true end

function modifier_imba_skeleton_walk_spook:OnCreated()
	if IsServer() then
		-- Ability properties

		self.particle_spook = "particles/hero/clinkz/spooked/spooky_skull.vpcf"        

		-- Add particle
		self.particle_spook_fx = ParticleManager:CreateParticle(self.particle_spook, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle_spook_fx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_spook_fx, 3, self:GetParent():GetAbsOrigin())

		self:AddParticle(self.particle_spook_fx, false, false, -1, false, true)        

		self.reacting = true

		-- Determine location to force move to
		local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		local location = self:GetParent():GetAbsOrigin() + direction * 500

		local newOrder = {UnitIndex = self:GetParent():entindex(), 
						  OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,                 
						  Position = location}
 
		ExecuteOrderFromTable(newOrder)        

		self.reacting = false

		self.qangle_angle = 0

		-- RUN FROM CLINKZ!
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_skeleton_walk_spook:OnIntervalThink()    
	-- Determine a random direction to force move to
	local qangle = QAngle(0, self.qangle_angle, 0)
	self.qangle_angle = self.qangle_angle + 30
	if self.qangle_angle >= 360 then
		self.qangle_angle = 0
	end

	local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()        
	local location = self:GetParent():GetAbsOrigin() + direction * 500    
	local final_location = RotatePosition(self:GetParent():GetAbsOrigin(), qangle, location)

	self:GetParent():MoveToPosition(final_location)  
end

function modifier_imba_skeleton_walk_spook:OnDestroy()
	if IsServer() then
		self:GetParent():Stop()
	end
end

function modifier_imba_skeleton_walk_spook:CheckState()
	if not self.reacting then
		local state = {[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
		return state
	end

	return nil
end

modifier_imba_skeleton_walk_talent_root = class({})

function modifier_imba_skeleton_walk_talent_root:IsHidden() return false end
function modifier_imba_skeleton_walk_talent_root:IsPurgable() return true end
function modifier_imba_skeleton_walk_talent_root:IsDebuff() return true end
			
function modifier_imba_skeleton_walk_talent_root:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}
	return state
end


-- Move speed modifier for #6 Talent
modifier_imba_skeleton_walk_talent_ms = class({})

function modifier_imba_skeleton_walk_talent_ms:IsHidden() return false end
function modifier_imba_skeleton_walk_talent_ms:IsPurgable() return true end
function modifier_imba_skeleton_walk_talent_ms:IsDebuff() return false end

function modifier_imba_skeleton_walk_talent_ms:OnCreated()
	self.ms_bonus_pct = self:GetAbility():GetSpecialValueFor("ms_bonus_pct")
	
	
	-- FUUUUUUSION Talent: Increases Clinkz Skeleton Walk movement speed if no enemies are nearby. + Talent 6
	if IsServer() then
	self:StartIntervalThink(0.1)
	end
end

function modifier_imba_skeleton_walk_talent_ms:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():HasTalent("special_bonus_imba_clinkz_2") then
			self.spook_radius = self:GetAbility():GetSpecialValueFor("spook_radius")
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
											self:GetCaster():GetAbsOrigin(),
											nil,
											self.spook_radius,
											DOTA_UNIT_TARGET_TEAM_ENEMY,
											DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
			if #enemies > 0 then
			self.ms_bonus_pct = self:GetAbility():GetSpecialValueFor("ms_bonus_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_2")
			else
			self.ms_bonus_pct = self:GetAbility():GetSpecialValueFor("ms_bonus_pct")
			end
		end
	end
end
	
function modifier_imba_skeleton_walk_talent_ms:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_skeleton_walk_talent_ms:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus_pct
end




-----------------------------
--       DEATH PACT        --
-----------------------------

imba_clinkz_death_pact = class({})
LinkLuaModifier("modifier_imba_death_pact_buff", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_stack_creep", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_stack_hero", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_talent_debuff", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_talent_buff", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_hero_debuff", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_spirit_aura", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_spirit_attack_range", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_death_pact_bonus_spirited", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function imba_clinkz_death_pact:GetAbilityTextureName()
   return "clinkz_death_pact"
end

function imba_clinkz_death_pact:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- Can't target self
		if caster == target then
			return UF_FAIL_CUSTOM
		end

		if target:GetUnitName() == "npc_imba_clinkz_spirits" then
			return UF_FAIL_CUSTOM
		end

		if target:IsConsideredHero() and not target:IsHero() then
			return UF_FAIL_CONSIDERED_HERO
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_clinkz_death_pact:GetCustomCastErrorTarget(target) 
	if IsServer() then
		local caster = self:GetCaster()

		-- Can't target self
		if caster == target then
			return "dota_hud_error_cant_cast_on_self"
		end

		if target:GetUnitName() == "npc_imba_clinkz_spirits" then
			return "#dota_hud_error_cant_cast_on_spirits"
		end
	end
end

function imba_clinkz_death_pact:IsHiddenWhenStolen()
	return false
end

function imba_clinkz_death_pact:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = "clinkz_clinkz_ability_pact_0"..math.random(1, 6)
	local sound_cast = "Hero_Clinkz.DeathPact.Cast"
	local particle_pact = "particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf"
	local modifier_pact = "modifier_imba_death_pact_buff"
	local modifier_stack_creep = "modifier_imba_death_pact_stack_creep"
	local modifier_bonus_spirited = "modifier_imba_death_pact_bonus_spirited"
	local modifier_stack_hero = "modifier_imba_death_pact_stack_hero"
	local modifier_stack_hero_spirited = "modifier_imba_death_pact_stack_hero_spirited"
	local modifier_spirited_aura = "modifier_imba_death_pact_spirit_aura"
	local modifier_debuff_mark = "modifier_imba_death_pact_hero_debuff"
	local modifier_talent_debuff_mark = "modifier_imba_death_pact_talent_debuff"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")        
	local hero_current_hp_damage_pct = ability:GetSpecialValueFor("hero_current_hp_damage_pct")    

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Roll for cast response
	if RollPercentage(50) and caster:IsHero() then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add particle effect
	local particle_pact_fx = ParticleManager:CreateParticle(particle_pact, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_pact_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_pact_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_pact_fx, 5, target:GetAbsOrigin())

	-- Remove existing modifiers so new values would replace the old ones
	if caster:HasModifier(modifier_pact) then
		caster:RemoveModifierByName(modifier_pact)
		caster:RemoveModifierByName(modifier_stack_creep)
		caster:RemoveModifierByName(modifier_stack_hero)
	end

	-- Variables
	local pact_stacks
	local modifier_stacks
	local Clinkz_team = caster:GetTeamNumber()
	local target_team = target:GetTeamNumber()
	
	-- Check if it is a hero or a creep
	if target:IsHero() then
		-- Calculate damage based on current HP
		local current_hp = target:GetHealth()
		local damage = current_hp * (hero_current_hp_damage_pct * 0.01)

		-- Deal pure damage
		local damageTable = {
			victim = target,
			DAMAGE_TYPE_COMPOSITE = damage,
			damage_type = DAMAGE_TYPE_PURE,
			attacker = caster,
			ability = ability
		}   
		ApplyDamage(damageTable)    

		-- Assign stacks variables
		pact_stacks = damage
		modifier_stacks = caster:AddNewModifier(caster, ability, modifier_stack_hero, {duration = duration})
		
		-- Set the 7.01 Contract
		if target_team == Clinkz_team or target:HasModifier("modifier_imba_reincarnation_wraith_form") then
		else
		target:AddNewModifier(caster, ability, modifier_debuff_mark, {duration = duration})
		end
	else 
		-- Get creeps' current HP
		local current_hp = target:GetHealth()

		-- Remove the buff first, or else interactions will cause a bug on the hero gaining his bonuses.
		caster:RemoveModifierByName(modifier_bonus_spirited)

		-- Kill any spirits that already pay their taxes, if any.
		local spirits_to_kill = FindUnitsInRadius(caster:GetTeamNumber(),
											   caster:GetAbsOrigin(),
											   nil,
											   500,
											   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											   DOTA_UNIT_TARGET_BASIC,
											   DOTA_UNIT_TARGET_FLAG_NONE,
											   FIND_ANY_ORDER,
											   false)
												
		for _,unit in pairs(spirits_to_kill) do
			if unit:FindModifierByNameAndCaster(modifier_spirited_aura,caster) then
				unit:Kill(ability, caster)
			end
		end
		
		-- Summons a spirit. Wooooooooooooooooo~ :)
		local spirit_model = target:GetModelName()
		local spirit_scale = target:GetModelScale()
		local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		local distance = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
		local summon_point = caster:GetAbsOrigin() + direction * distance - 100
		local spirit = CreateUnitByName("npc_imba_clinkz_spirits", summon_point, true, caster, caster, caster:GetTeamNumber())        
		
		-- Set the owner of the wraith as the caster
		spirit:SetOwner(caster)
		
		-- TURN THE TARGETS INTO SPIRITZ!!
		spirit:SetOriginalModel(spirit_model)
		spirit:SetModelScale(spirit_scale)
		spirit:SetRenderColor(12, 55, 74)
		
		-- Set the Wraith to die after a small duration
		spirit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
		spirit:AddNewModifier(caster, ability, modifier_spirited_aura, {duration = duration})
		
		-- Add Spirit's Attack Damage		
		local modifier_spirit_attack_range_bonus = "modifier_imba_death_pact_spirit_attack_range"		
		spirit:AddNewModifier(caster, ability, modifier_spirit_attack_range_bonus, {duration = duration})
		
		-- ALL YOUR STATS ARE BELONG TO CLINKZ
		caster:AddNewModifier(target, ability, modifier_bonus_spirited, {duration = duration})

		ResolveNPCPositions(target:GetAbsOrigin(), 164)
		
		-- Kill the target.
		target:Kill(ability, caster)
		
		-- Assign stacks variables
		pact_stacks = current_hp
		modifier_stacks = caster:AddNewModifier(caster, ability, modifier_stack_creep, {duration = duration})
	end   

	-- If the caster is a nether ward, disable all the bonus.
	if not caster:IsHero() then
		return nil        
	end

	-- Add visible modifier to the caster
	caster:AddNewModifier(caster, ability, modifier_pact, {duration = duration})    

	-- Assign stack counts to the stack modifier
	if modifier_stacks then
		modifier_stacks:SetStackCount(pact_stacks)
	end

	-- Force recalculation of stats (to recalculate HP)
	caster:CalculateStatBonus()

	-- #8 Talent: Death Pact bonuses stay permanently if enemy target dies quickly
	-- Apply a marker on the target if caster has the talent
	if caster:HasTalent("special_bonus_imba_clinkz_8") and caster:GetTeamNumber() ~= target:GetTeamNumber() then
		local mark_duration = caster:FindTalentValue("special_bonus_imba_clinkz_8", "mark_duration")
		target:AddNewModifier(caster, ability, modifier_talent_debuff_mark, {duration = mark_duration})
	end
end
		
-- Dummy Death Pact buff (shows in the UI, but actually does nothing)
modifier_imba_death_pact_buff = class({})

function modifier_imba_death_pact_buff:IsHidden() return false end
function modifier_imba_death_pact_buff:IsPurgable() return false end
function modifier_imba_death_pact_buff:IsDebuff() return false end


-- Hidden buff for counting stacks (gives bonus damage and HP depending on stacks)
modifier_imba_death_pact_stack_creep = class({})

function modifier_imba_death_pact_stack_creep:IsHidden() return true end
function modifier_imba_death_pact_stack_creep:IsPurgable() return false end
function modifier_imba_death_pact_stack_creep:IsDebuff() return false end

function modifier_imba_death_pact_stack_creep:OnCreated()
	-- Ability properties
	self.particle_pact_buff = "particles/units/heroes/hero_clinkz/clinkz_death_pact_buff.vpcf"

	-- Ability specials		
	self.creep_bonus_hp_pct = self:GetAbility():GetSpecialValueFor("creep_bonus_hp_pct")
	self.creep_bonus_dmg_pct = self:GetAbility():GetSpecialValueFor("creep_bonus_dmg_pct")  

	-- Add buff effect
	self.particle_pact_buff_fx = ParticleManager:CreateParticle(self.particle_pact_buff, PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle_pact_buff_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 8, Vector(1,0,0))

	self:AddParticle(self.particle_pact_buff_fx, false, false, -1, false, false)

	if IsServer() then        
		Timers:CreateTimer(FrameTime(), function()
			local stacks = self:GetStackCount()
			self:GetCaster():Heal(self.creep_bonus_hp_pct * 0.01 * stacks, self:GetCaster())            
		end)
	end
end


function modifier_imba_death_pact_stack_creep:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
					  MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

	return decFuncs
end

function modifier_imba_death_pact_stack_creep:GetModifierBaseAttack_BonusDamage()
	local stacks = self:GetStackCount()
	local bonus_damage = self.creep_bonus_dmg_pct * 0.01 * stacks 

	return bonus_damage
end

function modifier_imba_death_pact_stack_creep:GetModifierExtraHealthBonus()
	local stacks = self:GetStackCount()
	local bonus_hp = self.creep_bonus_hp_pct * 0.01 * stacks

	return bonus_hp
end

-- Creeps killed are turned into spirits

modifier_imba_death_pact_spirit_aura = class({})
LinkLuaModifier("modifier_imba_death_pact_spirit_aura_invis", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

function modifier_imba_death_pact_spirit_aura:IsHidden() return true end
function modifier_imba_death_pact_spirit_aura:IsPurgable() return false end
function modifier_imba_death_pact_spirit_aura:IsDebuff() return false end

function modifier_imba_death_pact_spirit_aura:OnCreated()
	if IsServer() then
 -- Tax Collector
 -- Taxed Spirits
		
		-- Ability Specials
		local modifier_bonus_spirited = "modifier_imba_death_pact_bonus_spirited"
		local duration = self:GetAbility():GetSpecialValueFor("duration")        
		
		-- YOU SHALL NOT ATTKCK!
		self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
	
		-- Wait a game tick so we can have the target assigned to this modifier
		 Timers:CreateTimer(FrameTime(), function()
			-- Get mount location
			
			local direction = self:GetCaster():GetForwardVector()
			local collision_radius = self:GetCaster():GetPaddedCollisionRadius() + self:GetParent():GetPaddedCollisionRadius() + 80
			local mount_point = self:GetCaster():GetAbsOrigin() + direction * (-1) * collision_radius

			-- Set the Sp0000000ky spirit behind Clinkz!        
			self:GetParent():SetAbsOrigin(mount_point)   


			-- Add particle effect
			local particle_pact = "particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf"
			local particle_pact_fx = ParticleManager:CreateParticle(particle_pact, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(particle_pact_fx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_pact_fx, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_pact_fx, 5, self:GetParent():GetAbsOrigin())			
				
			-- HEY TAX COLLECTOR, YOU THERE?
			self:StartIntervalThink(FrameTime())
		 end)
	end
end

function modifier_imba_death_pact_spirit_aura:OnIntervalThink(keys)
	if IsServer() then
		
		-- Clinkz Spirit Talent bonus, wait a game tick so that it doesn't interact with the original bonus Clinkz gain.
		if self:GetCaster():HasTalent("special_bonus_imba_clinkz_1") then
		   self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
		end
		
		local modifier_spirit_invis = "modifier_imba_death_pact_spirit_aura_invis"
		
		-- IT'S NOT FAIR IF YOU'RE INVISIBLE WHILE I'M NOT!
		if self:GetCaster():IsImbaInvisible() then
		  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_spirit_invis, {})
		else
		  self:GetParent():RemoveModifierByName(modifier_spirit_invis)
		end
		
		-- Get new point        
		local current_loc = self:GetParent():GetAbsOrigin()

		local direction = self:GetCaster():GetForwardVector()
		local collision_radius = self:GetCaster():GetPaddedCollisionRadius() + self:GetParent():GetPaddedCollisionRadius() + 80
		local mount_point = self:GetCaster():GetAbsOrigin() + direction * (-1) * collision_radius

		local distance = (mount_point - current_loc):Length2D()

		-- If Clinkz died, kill the tax payer
		if not self:GetCaster():IsAlive() then
			self:GetParent():Kill(self:GetAbility(), self:GetCaster())
		end
		
		-- Set the distance behind Clinkz. TAX PAYER, YOU MUST NOT ESCAPE
		
		-- F A C E Y O U R M A S T E R
		self:GetParent():SetForwardVector(direction)
		
		if distance > 300 then
			-- Set it to Clinkz' location        
			self:GetParent():SetAbsOrigin(mount_point)            
		else
			direction = (mount_point - current_loc):Normalized()
			local Clinkz_move_speed = self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed())

			local new_point = current_loc + direction * ((Clinkz_move_speed * 1.25) * FrameTime())
			local ground_point = GetGroundPosition(new_point, self:GetParent())
			new_point.z = ground_point.z

			if distance > 25 then                
				self:GetParent():SetAbsOrigin(new_point)
			end
		end    
	end
end


-- Clinkz Ult is Nether Ward confirmed.

function modifier_imba_death_pact_spirit_aura:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					  MODIFIER_PROPERTY_DISABLE_HEALING,
					  MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_imba_death_pact_spirit_aura:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_death_pact_spirit_aura:GetDisableHealing()
	return 1
end

function modifier_imba_death_pact_spirit_aura:OnAttackLanded(keys)
	local target = keys.target
	local attacker = keys.attacker
	local modifier_spirited_aura = "modifier_imba_death_pact_spirit_aura"

	if target == self:GetParent() then

		-- If the attacker is not a creep, deal damage.
		if attacker:IsHero() or attacker:IsTower() or attacker:IsRoshan() then
			-- If the damage is enough to kill the spirit, destroy it 
			if self:GetParent():GetHealth() <= 1 then 
				self:GetParent():Kill(self:GetAbility(), attacker)
			-- Else, reduce its HP
			else
			self:GetParent():SetHealth(self:GetParent():GetHealth() - 1)
			end
		else
			return nil
		end

	end
end

function modifier_imba_death_pact_spirit_aura:OnRemoved()
	if IsServer() then
	-- When the Spirit dies, remove Clinkz the bonuses
	self:GetParent():SetOriginalModel("models/creeps/neutral_creeps/n_creep_ghost_b/n_creep_ghost_frost.vmdl")
	self:GetCaster():RemoveModifierByName("modifier_imba_death_pact_bonus_spirited")
	end
end
				
function modifier_imba_death_pact_spirit_aura:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				[MODIFIER_STATE_EVADE_DISABLED] = true,				
				[MODIFIER_STATE_PASSIVES_DISABLED] = true,
				[MODIFIER_STATE_COMMAND_RESTRICTED] = true}
	return state
end

-- Use Wraith King's "Ghostly" particles to indicate ghostly effect, as there are no ghostly fx ongoing. I expect this to be the hardest part. Boi, was I wrong. :D

 function modifier_imba_death_pact_spirit_aura:GetStatusEffectName() 
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
 end

-- If Clinkz is invisible, the spirit must also be invisible, or else IT'S A DISASTAH!

modifier_imba_death_pact_spirit_aura_invis = class({})

function modifier_imba_death_pact_spirit_aura_invis:IsHidden() return false end
function modifier_imba_death_pact_spirit_aura_invis:IsPurgable() return false end
function modifier_imba_death_pact_spirit_aura_invis:IsDebuff() return false end

function modifier_imba_death_pact_spirit_aura_invis:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}

	return decFuncs
end

function modifier_imba_death_pact_spirit_aura_invis:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = true}
	return state
end

function modifier_imba_death_pact_spirit_aura_invis:GetModifierInvisibilityLevel()
	return 1
end


-- Adding Clinkz Attack Range and damage to the Spirit..... SP00KY!

modifier_imba_death_pact_spirit_attack_range = class({}) 

function modifier_imba_death_pact_spirit_attack_range:IsHidden() return false end
function modifier_imba_death_pact_spirit_attack_range:IsPurgable() return false end
function modifier_imba_death_pact_spirit_attack_range:IsDebuff() return false end

function modifier_imba_death_pact_spirit_attack_range:OnCreated()
  -- Ability properties
 if IsServer() then
	
	self.spirit_attack_range = self:GetCaster():Script_GetAttackRange()
	self.spirit_damage = self:GetCaster():GetAttackDamage() -- GetBaseDamageMax
	
	self:StartIntervalThink(1)
 end
end

function modifier_imba_death_pact_spirit_attack_range:OnIntervalThink()
 if IsServer() then
	self.spirit_attack_range = self:GetCaster():Script_GetAttackRange()
 end
end

function modifier_imba_death_pact_spirit_attack_range:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
					  MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}

	return decFuncs
end

function modifier_imba_death_pact_spirit_attack_range:GetModifierAttackRangeBonus()
	return self.spirit_attack_range end

function modifier_imba_death_pact_spirit_attack_range:GetModifierBaseAttack_BonusDamage()
	return self.spirit_damage end

	
-- Buff from "spirits"... 

modifier_imba_death_pact_bonus_spirited = class({}) 

function modifier_imba_death_pact_bonus_spirited:IsHidden() return false end
function modifier_imba_death_pact_bonus_spirited:IsPurgable() return false end
function modifier_imba_death_pact_bonus_spirited:IsDebuff() return false end

function modifier_imba_death_pact_bonus_spirited:OnCreated()
	-- Ability properties

	if IsServer() then    		
		-- Need to set as stack count since you cannot access it clientside for some weird reason
		self.spirit_damage = self:GetCaster():GetAttackDamage() -- GetBaseDamageMax
		self:SetStackCount(self.spirit_damage)
	end

	self.spirit_armor = self:GetCaster():GetPhysicalArmorValue() 
end

-- Check if there's any tax to collect.

function modifier_imba_death_pact_bonus_spirited:DeclareFunctions()
	-- 2 BONUS DAMAGE BUFF INSTANCES WTF WHAT ARE YOU DEVS THINKING!? XD - IamInnocentX3
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
					  MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 					  
					  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_death_pact_bonus_spirited:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount() end

function modifier_imba_death_pact_bonus_spirited:GetModifierPhysicalArmorBonus()
	return self.spirit_armor end


-- Setting the attack target for the spirit.
function modifier_imba_death_pact_bonus_spirited:OnAttackStart(keys)
 
 if IsServer() then
 
 local attacker = keys.attacker
 
 if self:GetParent() == attacker then
 
 local target = self:GetParent():GetAttackTarget()
 local modifier_spirited_aura = "modifier_imba_death_pact_spirit_aura"
 local nearby_allies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
								   self:GetParent():GetAbsOrigin(),
								   nil,
								   500,
								   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
								   DOTA_UNIT_TARGET_BASIC,
								   DOTA_UNIT_TARGET_FLAG_NONE,
								   FIND_ANY_ORDER,
								   false)
						
	for _,spirits in pairs(nearby_allies) do
		if spirits:FindModifierByNameAndCaster(modifier_spirited_aura,self:GetParent()) then
			spirits:SetForceAttackTarget(target)
		end
	end
  end
 end
end

-- Hidden buff for counting stacks. Calculates for hero

modifier_imba_death_pact_stack_hero = class({})

function modifier_imba_death_pact_stack_hero:IsHidden() return true end
function modifier_imba_death_pact_stack_hero:IsPurgable() return false end
function modifier_imba_death_pact_stack_hero:IsDebuff() return false end

function modifier_imba_death_pact_stack_hero:OnCreated()
	-- Ability properties
	self.particle_pact_buff = "particles/units/heroes/hero_clinkz/clinkz_death_pact_buff.vpcf"

	-- Ability specials
	self.hero_bonus_hp_dmg_mult = self:GetAbility():GetSpecialValueFor("hero_bonus_hp_dmg_mult")
	self.hero_bonus_dmg_pct = self:GetAbility():GetSpecialValueFor("hero_bonus_dmg_pct")      

	-- Add buff effect
	self.particle_pact_buff_fx = ParticleManager:CreateParticle(self.particle_pact_buff, PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.particle_pact_buff_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 8, Vector(1,0,0))

	self:AddParticle(self.particle_pact_buff_fx, false, false, -1, false, false)   

	if IsServer() then        
		Timers:CreateTimer(FrameTime(), function()
			local stacks = self:GetStackCount()
			self:GetCaster():Heal(self.hero_bonus_hp_dmg_mult * stacks, self:GetCaster())            
		end)
	end
end


function modifier_imba_death_pact_stack_hero:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
					  MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

	return decFuncs
end

function modifier_imba_death_pact_stack_hero:GetModifierBaseAttack_BonusDamage()
	local stacks = self:GetStackCount()
	local bonus_damage = self.hero_bonus_dmg_pct * 0.01 * stacks 

	return bonus_damage
end

function modifier_imba_death_pact_stack_hero:GetModifierExtraHealthBonus()
	if IsServer() then
		local stacks = self:GetStackCount()
		local bonus_hp = self.hero_bonus_hp_dmg_mult * stacks

		return bonus_hp
	end
end


-- #8 Talent Debuff talent target marker
modifier_imba_death_pact_talent_debuff = modifier_imba_death_pact_talent_debuff or class({})

function modifier_imba_death_pact_talent_debuff:IsHidden() return false end
function modifier_imba_death_pact_talent_debuff:IsPurgable() return false end
function modifier_imba_death_pact_talent_debuff:IsDebuff() return true end

function modifier_imba_death_pact_talent_debuff:OnCreated()
	if IsServer() then


		self.modifier_hero_pact = "modifier_imba_death_pact_stack_hero"
		self.modifier_perma_buff = "modifier_imba_death_pact_talent_buff"
	end
end

function modifier_imba_death_pact_talent_debuff:DeclareFunctions()
	local decFuncs ={MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_death_pact_talent_debuff:OnHeroKilled(keys)    
	if IsServer() then
		local killed_hero = keys.target        

		-- Only apply if the killed hero is the parent of the debuff        
		if killed_hero == self:GetParent() and self:GetCaster():HasModifier(self.modifier_hero_pact) then            
			-- Get stack count from the modifier
			local buff_stacks = self:GetCaster():FindModifierByName(self.modifier_hero_pact):GetStackCount()            

			-- Calculate stack amount to keep
			local stacks = buff_stacks * (self:GetCaster():FindTalentValue("special_bonus_imba_clinkz_8", "stacks_pct") * 0.01)            
			
			-- Add perma buff if not exists yet
			if not self:GetCaster():HasModifier(self.modifier_perma_buff) then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.modifier_perma_buff, {})
			end

			-- Increase stack count of the perma buff 
			local modifier_buff_handler = self:GetCaster():FindModifierByName(self.modifier_perma_buff)
			modifier_buff_handler:SetStackCount(modifier_buff_handler:GetStackCount() + stacks)
		end
	end
end

-- Spirit-to-be debuff marker
modifier_imba_death_pact_hero_debuff = class({})

function modifier_imba_death_pact_hero_debuff:IsHidden() return true end
function modifier_imba_death_pact_hero_debuff:IsPurgable() return false end
function modifier_imba_death_pact_hero_debuff:IsDebuff() return true end

function modifier_imba_death_pact_hero_debuff:OnCreated()
	if IsServer() then


	end
end

function modifier_imba_death_pact_hero_debuff:DeclareFunctions()
	local decFuncs ={MODIFIER_EVENT_ON_HERO_KILLED}

	return decFuncs
end

function modifier_imba_death_pact_hero_debuff:OnHeroKilled(keys)    
	if IsServer() then
	
		local killed_hero = keys.target       

		local modifier_stack_hero = "modifier_imba_death_pact_stack_hero"		

		-- Only apply if the killed hero is the parent of the debuff        
		if killed_hero == self:GetParent() and self:GetCaster():HasModifier(modifier_stack_hero) then            
			
			local duration = self:GetAbility():GetSpecialValueFor("duration")
			local modifier_bonus_spirited = "modifier_imba_death_pact_bonus_spirited"
			local modifier_spirited_aura = "modifier_imba_death_pact_spirit_aura"

			-- Kill any spirits that already pay their taxes, if any.
			local spirits_to_kill = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
													self:GetCaster():GetAbsOrigin(),
													nil,
													500,
													DOTA_UNIT_TARGET_TEAM_FRIENDLY,
													DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
													DOTA_UNIT_TARGET_FLAG_NONE,
													FIND_ANY_ORDER,
													false)
										
			for _,unit in pairs(spirits_to_kill) do
				if unit:FindModifierByNameAndCaster(modifier_spirited_aura,self:GetCaster()) then
					unit:Kill(self:GetAbility(),self:GetCaster())
				end
			end
			
			self:GetCaster():RemoveModifierByName(modifier_bonus_spirited)
			
			-- Summons a spirit. Wooooooooooooooooo~ :)
			local spirit_model = self:GetParent():GetModelName()
			local spirit_scale = self:GetParent():GetModelScale()
			local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
			local distance = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
			local summon_point = self:GetCaster():GetAbsOrigin() + direction * distance - 100
			local spirit = CreateUnitByName("npc_imba_clinkz_spirits", summon_point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())        

			-- Set the owner of the wraith as the caster
			spirit:SetOwner(self:GetCaster())

			-- TURN THE TARGETS INTO SPIRITZ!!
			spirit:SetOriginalModel(spirit_model)
			spirit:SetModelScale(spirit_scale)
			spirit:NotifyWearablesOfModelChange(true)
			spirit:ManageModelChanges()
			
			-- Set the Wraith to die after a small duration
			spirit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = duration})
			spirit:AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_spirited_aura, {duration = duration})
			
			-- Add Spirit's Attack Damage					
			local modifier_spirit_attack_range_bonus = "modifier_imba_death_pact_spirit_attack_range"					
			spirit:AddNewModifier(self:GetCaster(), self:GetAbility(), modifier_spirit_attack_range_bonus, {duration = duration})
			
			-- ALL YOUR STATS ARE BELONG TO CLINKZ
			self:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), modifier_bonus_spirited, {duration = duration})
		end
	end
end

-- #8 Talent Perma bonus buff
modifier_imba_death_pact_talent_buff = class({})

function modifier_imba_death_pact_talent_buff:IsHidden() return false end
function modifier_imba_death_pact_talent_buff:IsPurgable() return false end
function modifier_imba_death_pact_talent_buff:IsDebuff() return false end

function modifier_imba_death_pact_talent_buff:OnCreated()
	-- Ability properties

	-- Ability specials
	self.hero_bonus_hp_dmg_mult = self:GetAbility():GetSpecialValueFor("hero_bonus_hp_dmg_mult")
	self.hero_bonus_dmg_pct = self:GetAbility():GetSpecialValueFor("hero_bonus_dmg_pct")      
end

function modifier_imba_death_pact_talent_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
					  MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS}

	return decFuncs
end

function modifier_imba_death_pact_talent_buff:GetModifierBaseAttack_BonusDamage()
	local stacks = self:GetStackCount()
	local bonus_damage = self.hero_bonus_dmg_pct * 0.01 * stacks 

	return bonus_damage
end

function modifier_imba_death_pact_talent_buff:GetModifierExtraHealthBonus()    
	local stacks = self:GetStackCount()
	local bonus_hp = self.hero_bonus_hp_dmg_mult * stacks

	return bonus_hp    
end

-- Client-side helper functions --

-- #5 Talent: Frost Armor adds a portion of the Lich's intelligence to the armor bonus
LinkLuaModifier("modifier_special_bonus_imba_clinkz_5", "components/abilities/heroes/hero_clinkz", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_clinkz_5 = class({})
function modifier_special_bonus_imba_clinkz_5:IsHidden() 		return true end
function modifier_special_bonus_imba_clinkz_5:IsPurgable() 		return false end
function modifier_special_bonus_imba_clinkz_5:RemoveOnDeath() 	return false end

-- Function to ensure the talent that gives root + bonus attack range shows in UI
function imba_clinkz_strafe:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_clinkz_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_clinkz_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_clinkz_5", {})
	end
end
