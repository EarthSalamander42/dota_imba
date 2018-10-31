-- Author: Shush
-- Date: 15/04/2017

----------------------------
--      ARCANE BOLT       --
----------------------------
imba_skywrath_mage_arcane_bolt = class({})
LinkLuaModifier("modifier_imba_arcane_bolt_buff", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skywrath_flying_movement", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_skywrath_mage_arcane_bolt:GetAbilityTextureName()
   return "skywrath_mage_arcane_bolt"
end

function imba_skywrath_mage_arcane_bolt:IsHiddenWhenStolen()
	return false
end

function imba_skywrath_mage_arcane_bolt:GetIntrinsicModifierName()
	return "modifier_imba_skywrath_flying_movement"
end

function imba_skywrath_mage_arcane_bolt:OnUnStolen()
	local caster = self:GetCaster()

	-- Remove modifier to lessen load. Not that it would ever do something.
	caster:RemoveModifierByName("modifier_imba_skywrath_flying_movement")
end

function imba_skywrath_mage_arcane_bolt:GetManaCost(level)
	local caster = self:GetCaster()
	local mana_cost = self.BaseClass.GetManaCost(self,level)

	-- #1 Talent: Arcane Bolt mana cost decrease
	mana_cost = mana_cost - caster:FindTalentValue("special_bonus_imba_skywrath_mage_1")

	return mana_cost
end

function imba_skywrath_mage_arcane_bolt:GetCooldown(level)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown(self, level)

	-- #5 Talent: Arcane Bolt cooldown decrease
	cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_skywrath_mage_5")

	return cooldown
end

function imba_skywrath_mage_arcane_bolt:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_responses = {"skywrath_mage_drag_arcanebolt_02", "skywrath_mage_drag_arcanebolt_03"}
	local rare_cast_response = "skywrath_mage_drag_arcanebolt_01"
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	local scepter = caster:HasScepter()

	-- Ability specials            
	local scepter_search_radius = ability:GetSpecialValueFor("scepter_search_radius")

	-- Roll for a rare cast response
	if RollPercentage(5) then
		EmitSoundOn(rare_cast_response, caster)

	-- Roll for a cast response    
	elseif RollPercentage(25) then
		EmitSoundOn(cast_responses[math.random(1,#cast_responses)], caster)
	end    

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Fire at the enemy!
	LaunchArcaneBolt(caster, ability, target)

	-- Scepter: Find a secondary target to shot at. Prioritize heroes
	if scepter then
		local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_HERO,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		
		-- If at least one hero was found to shot at, make sure it's not the main target
		for _,enemy_hero in pairs(enemy_heroes) do
			if enemy_hero ~= target then
				-- Launch a bolt at this blyat
				LaunchArcaneBolt(caster, ability, enemy_hero)
				return nil
			end
		end
	
		-- No heroes found. Try finding a creep instead
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_BASIC,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		for _,enemy_creep in pairs(enemy_creeps) do
			-- Make sure it's not the main target
			if enemy_creep ~= target then
				-- Fire at this creep blyat
				LaunchArcaneBolt(caster, ability, enemy_creep)
				return nil
			end
		end
	end
end

function LaunchArcaneBolt(caster, ability, target)
	-- Ability properties
	local particle_projectile = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"        
	local modifier_wrath = "modifier_imba_arcane_bolt_buff"

	-- Ability specials
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local projectile_speed_per_stack = ability:GetSpecialValueFor("projectile_speed_per_stack")    
	local vision_radius = ability:GetSpecialValueFor("vision_radius")

	-- Fetch current amount of Arcane Wrath stacks
	local stacks = 0
	if caster:HasModifier(modifier_wrath) then
		local modifier_wrath_handler = caster:FindModifierByName(modifier_wrath)
		if modifier_wrath_handler then
			stacks = modifier_wrath_handler:GetStackCount()
		end
	end

	-- Increase projectile speed based on stacks
	projectile_speed = projectile_speed + projectile_speed_per_stack * stacks

	-- Fire projectile at target
	local arcane_bolt_projectile
	arcane_bolt_projectile = {Target = target,
							  Source = caster,
							  Ability = ability,
							  EffectName = particle_projectile,
							  iMoveSpeed = projectile_speed,
							  bDodgeable = false, 
							  bVisibleToEnemies = true,
							  bReplaceExisting = false,
							  bProvidesVision = true,
							  iVisionRadius = vision_radius,
							  iVisionTeamNumber = caster:GetTeamNumber()
	}

	ProjectileManager:CreateTrackingProjectile(arcane_bolt_projectile)  
end

function imba_skywrath_mage_arcane_bolt:OnProjectileHit(target, location)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self    
	local sound_impact = "Hero_SkywrathMage.ArcaneBolt.Impact"
	local modifier_wrath = "modifier_imba_arcane_bolt_buff"

	-- Ability specials
	local base_damage = ability:GetSpecialValueFor("base_damage")
	local intelligence_bonus_pct = ability:GetSpecialValueFor("intelligence_bonus_pct")
	local arcane_wrath_duration = ability:GetSpecialValueFor("arcane_wrath_duration")
	local intelligence_bonus_per_stack = ability:GetSpecialValueFor("intelligence_bonus_per_stack")    
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local impact_vision_duration = ability:GetSpecialValueFor("impact_vision_duration")

	-- If there was no target, do nothing
	if not target then
		return nil
	end

	-- If the target became magic immune, do nothing
	if target:IsMagicImmune() then
		return nil
	end

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Add flying vision in the impact area
	AddFOWViewer(caster:GetTeamNumber(),
				 location,
				 vision_radius,
				 impact_vision_duration,
				 false)

	-- Play impact sound
	EmitSoundOn(sound_impact, caster)

	-- Fetch caster's intelligence. Nether Wards has 0
	local intelligence = 0
	if caster:IsHero() then
		intelligence = caster:GetIntellect()
	end

	-- Get the current Arcane Wrath stack count
	local stacks = 0
	if caster:HasModifier(modifier_wrath) then
		local modifier_wrath_handler = caster:FindModifierByName(modifier_wrath)
		if modifier_wrath_handler then
			stacks = modifier_wrath_handler:GetStackCount()
		end
	end

	-- Adjust damage based on intelligence and stacks
	local int_damage_bonus = intelligence * ((intelligence_bonus_pct + intelligence_bonus_per_stack * stacks) * 0.01)
	local damage = base_damage + int_damage_bonus

	-- Deal damage to target
	local damageTable = {victim = target,
						 attacker = caster, 
						 damage = damage,
						 damage_type = DAMAGE_TYPE_MAGICAL,
						 ability = ability
						 }
		
	ApplyDamage(damageTable)  

	-- Add a stack of Arcane Wrath and refresh, if the target is a hero
	if target:IsHero() then
		if not caster:HasModifier(modifier_wrath) then
			caster:AddNewModifier(caster, ability, modifier_wrath, {duration = arcane_wrath_duration})
		end

		local modifier_wrath_handler = caster:FindModifierByName(modifier_wrath)
		if modifier_wrath_handler then
			modifier_wrath_handler:IncrementStackCount()
			modifier_wrath_handler:ForceRefresh()
		end
	end
end


-- Arcane Wrath modifier
modifier_imba_arcane_bolt_buff = class({})

function modifier_imba_arcane_bolt_buff:IsHidden() return false end
function modifier_imba_arcane_bolt_buff:IsPurgable() return false end
function modifier_imba_arcane_bolt_buff:IsDebuff() return false end


----------------------------
--    CONCUSSIVE SHOT     --
----------------------------
imba_skywrath_mage_concussive_shot = class({})
LinkLuaModifier("modifier_imba_concussive_shot_slow", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_skywrath_mage_concussive_shot:GetAbilityTextureName()
   return "skywrath_mage_concussive_shot"
end

function imba_skywrath_mage_concussive_shot:IsHiddenWhenStolen()
	return false
end

function imba_skywrath_mage_concussive_shot:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self    
	local cast_response = "skywrath_mage_drag_concussive_shot_0"..math.random(1, 3)
	local sound_cast = "Hero_SkywrathMage.ConcussiveShot.Cast"    
	local particle_fail = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_failure.vpcf"
	local scepter = caster:HasScepter()

	-- Ability specials
	local search_radius = ability:GetSpecialValueFor("search_radius")    
	local max_bounces = ability:GetSpecialValueFor("max_bounces")    
	local scepter_search_radius = ability:GetSpecialValueFor("scepter_search_radius")        

	-- Roll for a cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Find the closest valid enemy to shot the projectile on
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  caster:GetAbsOrigin(),
									  nil,
									  search_radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO,
									  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
									  FIND_CLOSEST,
									  false)

	-- If no enemies was found, add fizzle effect and exit
	if #enemies == 0 then
		local particle_fail_fx = ParticleManager:CreateParticle(particle_fail, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_fail_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_fail_fx, 1, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_fail_fx)

		return nil
	end

	-- Otherwise, launch projectile
	local target = enemies[1]   
	LaunchConcussiveShot(caster, caster, ability, target, true, max_bounces)    

	-- #8 Talent: Concussive Shot hits all visible heroes
	if caster:HasTalent("special_bonus_imba_skywrath_mage_8") then
		for _,enemy in pairs(enemies) do
			if enemy ~= target then
				LaunchConcussiveShot(caster, caster, ability, enemy, true, max_bounces)                    
			end
		end
	end

	-- Scepter: Shot a second Concussive Shot at a random enemy. Doesn't work when the caster has #8 Talent
	if scepter and not caster:HasTalent("special_bonus_imba_skywrath_mage_8") then        
		local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_HERO,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		
		-- If at least one hero was found to shot at, make sure it's not the main target        
		for _,enemy_hero in pairs(enemy_heroes) do
			if enemy_hero ~= target then
				-- Launch a concussive shot at the secondary hero
				LaunchConcussiveShot(caster, caster, ability, enemy_hero, true, max_bounces)
				return nil
			end
		end
	
		-- No heroes found. Try finding a creep instead
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_BASIC,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		for _,enemy_creep in pairs(enemy_creeps) do
			-- Make sure it's not the main target
			if enemy_creep ~= target then
				-- Fire at this creep blyat
				LaunchConcussiveShot(caster, caster, ability, enemy_creep, true, max_bounces)
				return nil
			end
		end
	end
end

function imba_skywrath_mage_concussive_shot:OnProjectileHit_ExtraData(target, location, extra_data)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_impact = "Hero_SkywrathMage.ConcussiveShot.Target"    
	local modifier_slow = "modifier_imba_concussive_shot_slow"
	local primary_concussive = extra_data.primary_concussive
	local bounces_left = extra_data.bounces_left    

	-- Ability specials
	local search_radius = ability:GetSpecialValueFor("search_radius")
	local damage = ability:GetSpecialValueFor("damage")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local impact_radius = ability:GetSpecialValueFor("impact_radius")
	local ghastly_delay = ability:GetSpecialValueFor("ghastly_delay")
	local ghastly_damage_pct = ability:GetSpecialValueFor("ghastly_damage_pct")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local impact_vision_duration = ability:GetSpecialValueFor("impact_vision_duration")

	-- If there was no target, do nothing
	if not target then
		return nil
	end

	-- If the target is not a hero (scepter aiming allows this), do nothing (why would you make it do nothing if they can be targetted in the first place -_-)
	-- if not target:IsHero() then
		-- return nil
	-- end


	-- Add FOW Viewer
	AddFOWViewer(caster:GetTeamNumber(),
				 location,
				 vision_radius,
				 impact_vision_duration,
				 false)    

	-- Play impact sound
	EmitSoundOn(sound_impact, caster)
	
	-- Adjust damage is the shot was a secondary shot
	if primary_concussive == 0 then
		damage = damage * (1 - (ghastly_damage_pct * 0.01))
	end

	-- Find all enemies in impact radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  target:GetAbsOrigin(),
									  nil,
									  impact_radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

	-- For each enemy, only apply if the enemy is not magic immune
	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() then
			-- Deal damage
			local damageTable = {victim = enemy,
								 attacker = caster, 
								 damage = damage,
								 damage_type = DAMAGE_TYPE_MAGICAL,
								 ability = ability
								 }
		
			ApplyDamage(damageTable)  

			-- Apply/Refresh slow debuff
			enemy:AddNewModifier(caster, ability, modifier_slow, {duration = slow_duration})
		end
	end    

	-- Check if there are anymore bounces to fire    
	if bounces_left > 0 then
	  local target_pos = target:GetAbsOrigin()
		-- If there are, wait a second
		Timers:CreateTimer(ghastly_delay, function()

			-- Search for the closest nearby friendly hero (of the enemy)
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
											  target_pos,
											  nil,
											  search_radius,
											  DOTA_UNIT_TARGET_TEAM_ENEMY,
											  DOTA_UNIT_TARGET_HERO,
											  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
											  FIND_CLOSEST,
											  false)
											  
			-- If no heroes were found, do nothing            
			if #enemies == 0 then                
				return nil
			end

			-- Reduce a bounce
			bounces_left = bounces_left - 1    

			-- This marks the closest hero, since if the target died he won't be counted.
			local enemy_target
			if enemies[1] == target then
				enemy_target = enemies[2]
			else
				enemy_target = enemies[1]
			end

			-- Otherwise, launch a secondary projectile at the closest hero
			LaunchConcussiveShot(caster, target, ability, enemy_target, false, bounces_left)
		end)
	end
end

function LaunchConcussiveShot(caster, source, ability, target, primary, bounces_left)
	-- Ability properties
	local particle_projectile = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf"

	-- Ability specials    
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")    

	-- Define and launch projectile
	local concussive_projectile
	concussive_projectile = {Target = target,
							  Source = source,
							  Ability = ability,
							  EffectName = particle_projectile,
							  iMoveSpeed = projectile_speed,
							  bDodgeable = true, 
							  bVisibleToEnemies = true,
							  bReplaceExisting = false,
							  bProvidesVision = true,
							  iVisionRadius = vision_radius,
							  iVisionTeamNumber = caster:GetTeamNumber(),
							  ExtraData = {bounces_left = bounces_left, primary_concussive = primary}
	}

	ProjectileManager:CreateTrackingProjectile(concussive_projectile)  
end


-- Concussive Shot slow modifier
modifier_imba_concussive_shot_slow = class({})

function modifier_imba_concussive_shot_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
 end 

function modifier_imba_concussive_shot_slow:IsHidden() return false end
function modifier_imba_concussive_shot_slow:IsPurgable() return true end    
function modifier_imba_concussive_shot_slow:IsDebuff() return true end

function modifier_imba_concussive_shot_slow:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_concussive_shot_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_concussive_shot_slow:GetEffectName()
	return "particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot_slow_debuff.vpcf"
end

function modifier_imba_concussive_shot_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end





----------------------------
--      ANCIENT SEAL      --
----------------------------
imba_skywrath_mage_ancient_seal = class({})
LinkLuaModifier("modifier_imba_ancient_seal_main", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_seal_aura", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_seal_secondary", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_skywrath_mage_ancient_seal:GetAbilityTextureName()
   return "skywrath_mage_ancient_seal"
end

function imba_skywrath_mage_ancient_seal:IsHiddenWhenStolen()
	return false
end

function imba_skywrath_mage_ancient_seal:GetCooldown(level)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown(self, level)

	-- #3 Talent: Ancient Seal cooldown decrease 
	cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_skywrath_mage_3")

	return cooldown
end

function imba_skywrath_mage_ancient_seal:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = {"skywrath_mage_drag_ancient_seal_01, skywrath_mage_drag_ancient_seal_03"}
	local rare_cast_response = "skywrath_mage_drag_ancient_seal_02"
	local sound_cast = "Hero_SkywrathMage.AncientSeal.Target"        
	local scepter = caster:HasScepter()

	-- Ability specials    
	local scepter_search_radius = ability:GetSpecialValueFor("scepter_search_radius")

	-- Roll for rare cast response
	if RollPercentage(15) then
		EmitSoundOn(rare_cast_response, caster)

	-- Roll for a normal cast response
	elseif RollPercentage(25) then
		EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)    
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end    

	-- Apply seal!
	ApplyAncientSeal(caster, ability, target)

	-- Scepter: Find a secondary target to apply silence on. Prioritize heroes
	if scepter then
		local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_HERO,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		
		-- If at least one hero was found to silence, make sure it's not the main target
		for _,enemy_hero in pairs(enemy_heroes) do
			if enemy_hero ~= target then
				-- Launch a bolt at this blyat
				ApplyAncientSeal(caster, ability, enemy_hero)
				return nil
			end
		end
	
		-- No heroes found. Try finding a creep instead
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(),
											   target:GetAbsOrigin(),
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_BASIC,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		for _,enemy_creep in pairs(enemy_creeps) do
			-- Make sure it's not the main target
			if enemy_creep ~= target then
				-- Silence this creep blyat
				ApplyAncientSeal(caster, ability, enemy_creep)
				return nil
			end
		end
	end
end

function ApplyAncientSeal(caster, ability, target)
	-- Ability properties
	local modifier_main_seal = "modifier_imba_ancient_seal_main"
	local modifier_thinker_aura = "modifier_imba_ancient_seal_aura"

	-- Ability specials
	local seal_duration = ability:GetSpecialValueFor("seal_duration")

	-- #2 Talent: Ancient Seal duration increase
	seal_duration = seal_duration + caster:FindTalentValue("special_bonus_imba_skywrath_mage_2")

	-- Apply the main modifier on the target
	target:AddNewModifier(caster, ability, modifier_main_seal, {duration = seal_duration})

	-- Apply the modifier thinker on the ground at the target's location
	CreateModifierThinker(caster, ability, modifier_thinker_aura, {duration = seal_duration}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
end

-- Main seal modifier
modifier_imba_ancient_seal_main = class({})

function modifier_imba_ancient_seal_main:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_seal = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf"

	-- Ability specials
	self.mr_reduction_pct = self.ability:GetSpecialValueFor("mr_reduction_pct")

	-- Apply seal particle
	self.particle_seal_fx = ParticleManager:CreateParticle(self.particle_seal, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle_seal_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle_seal_fx, false, false, -1 , false, true)
end

function modifier_imba_ancient_seal_main:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

	return decFuncs
end

function modifier_imba_ancient_seal_main:GetModifierMagicalResistanceBonus()
	return self.mr_reduction_pct * (-1)
end

function modifier_imba_ancient_seal_main:IsHidden() return false end
function modifier_imba_ancient_seal_main:IsPurgable() return true end
function modifier_imba_ancient_seal_main:IsDebuff() return true end

function modifier_imba_ancient_seal_main:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end

-- Aura modifier
modifier_imba_ancient_seal_aura = class({})

function modifier_imba_ancient_seal_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_main_seal = "modifier_imba_ancient_seal_main"
	self.particle_sigil = "particles/hero/skywrath_mage/skywrath_mage_ground_seal.vpcf"

	-- Ability specials
	self.aura_linger = self.ability:GetSpecialValueFor("aura_linger")
	self.sigil_radius = self.ability:GetSpecialValueFor("sigil_radius")

	-- Add the sigil particle
	self.particle_sigil_fx = ParticleManager:CreateParticle(self.particle_sigil, PATTACH_WORLDORIGIN, self.caster)    
	ParticleManager:SetParticleControl(self.particle_sigil_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_sigil_fx, 1, Vector(80, 80 ,1))
	ParticleManager:SetParticleControl(self.particle_sigil_fx, 2, Vector(self.sigil_radius, self.sigil_radius, 0))
	self:AddParticle(self.particle_sigil_fx, false, false, -1, false, false)
end

function modifier_imba_ancient_seal_aura:GetAuraDuration()
	return self.aura_linger
end

function modifier_imba_ancient_seal_aura:GetAuraEntityReject(target)
	-- Reject those with the main silence modifier
	if target:HasModifier(self.modifier_main_seal) then
		return true
	end

	-- Accept the rest
	return false
end

function modifier_imba_ancient_seal_aura:GetAuraRadius()
	return self.sigil_radius
end

function modifier_imba_ancient_seal_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_ancient_seal_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_ancient_seal_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_ancient_seal_aura:GetModifierAura()
	return "modifier_imba_ancient_seal_secondary"
end

function modifier_imba_ancient_seal_aura:IsAura()
	return true
end

-- Secondary seal modifier
modifier_imba_ancient_seal_secondary = class({})

function modifier_imba_ancient_seal_secondary:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_seal = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf"

	-- Ability specials
	self.mr_reduction_pct = self.ability:GetSpecialValueFor("mr_reduction_pct")

	-- Apply seal particle
	self.particle_seal_fx = ParticleManager:CreateParticle(self.particle_seal, PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle_seal_fx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle_seal_fx, false, false, -1 , false, true)
end

function modifier_imba_ancient_seal_secondary:GetEffectName()
	return "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff.vpcf"
end

function modifier_imba_ancient_seal_secondary:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_ancient_seal_secondary:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

	return decFuncs
end

function modifier_imba_ancient_seal_secondary:GetModifierMagicalResistanceBonus()
	return self.mr_reduction_pct * (-1)
end

function modifier_imba_ancient_seal_secondary:IsHidden() return false end
function modifier_imba_ancient_seal_secondary:IsPurgable() return true end
function modifier_imba_ancient_seal_secondary:IsDebuff() return true end

function modifier_imba_ancient_seal_secondary:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end



----------------------------
--      MYSTIC FLARE      --
----------------------------
imba_skywrath_mage_mystic_flare = class({})
LinkLuaModifier("modifier_imba_mystic_flare", "components/abilities/heroes/hero_skywrath_mage.lua", LUA_MODIFIER_MOTION_NONE)

function imba_skywrath_mage_mystic_flare:GetAbilityTextureName()
   return "skywrath_mage_mystic_flare"
end

function imba_skywrath_mage_mystic_flare:IsHiddenWhenStolen()
	return false
end

function imba_skywrath_mage_mystic_flare:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self
	local damage_radius = ability:GetSpecialValueFor("damage_radius")

	-- #4 Talent: Mystic Flare double radius
	damage_radius = damage_radius + caster:FindTalentValue("special_bonus_imba_skywrath_mage_4")

	return damage_radius
end

function imba_skywrath_mage_mystic_flare:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = "skywrath_mage_drag_mystic_flare_0"..math.random(1,5)
	local sound_cast = "Hero_SkywrathMage.MysticFlare.Cast"    
	local scepter = caster:HasScepter()

	-- Ability specials    
	local damage_radius = ability:GetSpecialValueFor("damage_radius")
	local scepter_search_radius = ability:GetSpecialValueFor("scepter_search_radius")

	-- #4 Talent: Mystic Flare double radius
	damage_radius = damage_radius + caster:FindTalentValue("special_bonus_imba_skywrath_mage_4")

	-- Roll for a cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)    

	-- Mystic Flareeeee
	ExecuteMysticFlare(caster, ability, target_point)

	-- Scepter: find a secondary target that is not in the AoE of the initial target point
	if scepter then
		local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(),
											   target_point,
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_HERO,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		
		-- If at least one hero was found to strike, make sure he's not in the initial flare radius
		for _,enemy_hero in pairs(enemy_heroes) do
			local distance = (enemy_hero:GetAbsOrigin() - target_point):Length2D()
			if (distance - 50) > damage_radius then

				-- Secondary flare
				ExecuteMysticFlare(caster, ability, enemy_hero:GetAbsOrigin())
				return nil
			end
		end
	
		-- No heroes found. Try finding a creep instead
		local enemy_creeps = FindUnitsInRadius(caster:GetTeamNumber(),
											   target_point,
											   nil,
											   scepter_search_radius,
											   DOTA_UNIT_TARGET_TEAM_ENEMY,
											   DOTA_UNIT_TARGET_BASIC,
											   DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
											   FIND_ANY_ORDER,
											   false)

		for _,enemy_creep in pairs(enemy_creeps) do
			-- Make sure the target is far enough
			local distance = (enemy_creep:GetAbsOrigin() - target_point):Length2D()
			if (distance - 50) > damage_radius then

				-- Blast this creep blyat (lol no damage)
				ExecuteMysticFlare(caster, ability, enemy_creep:GetAbsOrigin())
				return nil
			end
		end
	end
end

function ExecuteMysticFlare(caster, ability, target_point)
	-- Ability properties
	local modifier_mystic = "modifier_imba_mystic_flare"

	-- Ability specials
	local damage_duration = ability:GetSpecialValueFor("damage_duration")        

	-- #6 Talent: Mystic Flare deals the damage in half the duration
		damage_duration = damage_duration * (1 - caster:FindTalentValue("special_bonus_imba_skywrath_mage_6") * 0.01)        

	-- Apply thinker modifier on target location
	CreateModifierThinker(caster, ability, modifier_mystic, {duration = damage_duration}, target_point, caster:GetTeamNumber(), false)
end


modifier_imba_mystic_flare = class({})

function modifier_imba_mystic_flare:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.sound_target = "Hero_SkywrathMage.MysticFlare.Target"
		self.core_particle = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf"
		self.particle_explosion = "particles/hero/skywrath_mage/skywrath_mage_mystic_flare_explosion.vpcf"
		self.particle_shockwave = "particles/hero/skywrath_mage/skywrath_mage_mystic_flare_explosion_shockwave.vpcf"
		self.modifier_wrath = "modifier_imba_arcane_bolt_buff"

		-- Ability specials
		self.damage_duration = self.ability:GetSpecialValueFor("damage_duration")
		self.damage_radius = self.ability:GetSpecialValueFor("damage_radius")
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.damage_interval = self.ability:GetSpecialValueFor("damage_interval")
		self.explosion_delay = self.ability:GetSpecialValueFor("explosion_delay")
		self.explosion_radius = self.ability:GetSpecialValueFor("explosion_radius")
		self.int_as_damage_pct = self.ability:GetSpecialValueFor("int_as_damage_pct")
		self.int_increase_per_stack = self.ability:GetSpecialValueFor("int_increase_per_stack")

		-- #4 Talent: Mystic Flare double radius
		self.damage_radius = self.damage_radius + self.caster:FindTalentValue("special_bonus_imba_skywrath_mage_4")

		-- #6 Talent: Mystic Flare deals the damage in half the duration
		self.damage_duration = self.damage_duration * (1 - self.caster:FindTalentValue("special_bonus_imba_skywrath_mage_6") * 0.01)
		self.damage_interval = self.damage_interval * (1 - self.caster:FindTalentValue("special_bonus_imba_skywrath_mage_6") * 0.01)

		-- Calculate damage per interval
		self.damage_per_interval = self.damage / self.damage_duration * self.damage_interval

		-- Get thinker's location
		self.parent_loc = self.parent:GetAbsOrigin()

		-- Add particle effect
		self.core_particle_fx = ParticleManager:CreateParticle(self.core_particle, PATTACH_WORLDORIGIN, nil)        
		ParticleManager:SetParticleControl(self.core_particle_fx, 0 , self.parent_loc)
		ParticleManager:SetParticleControl(self.core_particle_fx, 1, Vector(self.damage_radius, self.damage_duration, 0))            
		ParticleManager:ReleaseParticleIndex(self.core_particle_fx)

		-- Start dealing damage on intervals
		self:StartIntervalThink(self.damage_interval)

		-- Nether Ward cannot proc the extra explosion, so do nothing if it is
		if string.find(self.caster:GetUnitName(), "npc_imba_pugna_nether_ward") then
			return nil
		end

		Timers:CreateTimer(self.damage_duration, function()
			-- Add explosion particle
			self.particle_explosion_fx = ParticleManager:CreateParticle(self.particle_explosion, PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(self.particle_explosion_fx, 0, self.parent_loc)  
			ParticleManager:SetParticleControl(self.particle_explosion_fx, 1, Vector(self.explosion_radius, 0, 0))                    

			-- Wait for explosion, then BLOW!
			Timers:CreateTimer(self.explosion_delay, function()
				-- Remove previous particle
				ParticleManager:DestroyParticle(self.particle_explosion_fx, false)
				ParticleManager:ReleaseParticleIndex(self.particle_explosion_fx)

				-- Add shockwave particles
				self.particle_shockwave_fx = ParticleManager:CreateParticle(self.particle_shockwave, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(self.particle_shockwave_fx, 0, self.parent_loc)
				ParticleManager:SetParticleControl(self.particle_shockwave_fx, 1, Vector(self.explosion_radius, self.explosion_radius, 2))
				ParticleManager:ReleaseParticleIndex(self.particle_shockwave_fx)

				-- Fetch caster's intelligence
				self.caster_int = self.caster:GetIntellect()

				-- Fetch stacks of Arcane Wrath
				self.wrath_stacks = 0 
				if self.caster:HasModifier(self.modifier_wrath) then
					self.modifier_wrath_handler = self.caster:FindModifierByName(self.modifier_wrath)
					if self.modifier_wrath_handler then
						self.wrath_stacks = self.modifier_wrath_handler:GetStackCount()
					end
				end
				
				-- Calculate damage based on int
				self.explosion_damage = self.caster_int * ((self.int_as_damage_pct + self.int_increase_per_stack * self.wrath_stacks) * 0.01)

				-- Find all nearby enemies (not only heroes)
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
												  self.parent_loc,
												  nil,
												  self.explosion_radius,
												  DOTA_UNIT_TARGET_TEAM_ENEMY,
												  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												  DOTA_UNIT_TARGET_FLAG_NONE,
												  FIND_ANY_ORDER,
												  false)

				for _,enemy in pairs (enemies) do

					-- If enemy didn't suddenly become magic immune, deal damage
					if not enemy:IsMagicImmune() then
						local damageTable = {victim = enemy,
									 attacker = self.caster, 
									 damage = self.explosion_damage,
									 damage_type = DAMAGE_TYPE_MAGICAL,
									 ability = self.ability
									 }
		
						ApplyDamage(damageTable)  
					end
				end
			end)
		end)        
	end
end

function modifier_imba_mystic_flare:OnIntervalThink()
	if IsServer() then
		-- Play target sound
		EmitSoundOn(self.sound_target, self.parent)

		-- Find nearby enemy heroes in the area
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.parent_loc,
										  nil,
										  self.damage_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
										  FIND_ANY_ORDER,
										  false)

		-- Calculate damage for this instance        
		self.instance_damage = 0    
		if #enemies ~= 0 then
			self.instance_damage = self.damage_per_interval / #enemies
		end                

		-- Deal this instance's damage to each hero
		for _,enemy in pairs (enemies) do
			if not enemy:IsMagicImmune() then
				local damageTable = {victim = enemy,
									 attacker = self.caster, 
									 damage = self.instance_damage,
									 damage_type = DAMAGE_TYPE_MAGICAL,
									 ability = self.ability
									 }
		
				ApplyDamage(damageTable)  
			end
		end
	end
end



--------------------------------
-- PERMANENT FLYING MOVEMENT  --
--------------------------------
modifier_imba_skywrath_flying_movement = class({})

function modifier_imba_skywrath_flying_movement:CheckState()
	local caster = self:GetCaster()
	local state

	if caster:HasTalent("special_bonus_imba_skywrath_mage_7") then
		state = {[MODIFIER_STATE_FLYING] = true}
		return state
	end

	return nil
end

function modifier_imba_skywrath_flying_movement:IsHidden() return true end
function modifier_imba_skywrath_flying_movement:IsPurgable() return false end
function modifier_imba_skywrath_flying_movement:IsDebuff() return false end
