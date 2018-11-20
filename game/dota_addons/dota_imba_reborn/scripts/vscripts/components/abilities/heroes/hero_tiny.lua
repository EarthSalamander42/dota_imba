-- Editors:
--     yahnich, 09.06.2017
--     naowin, 28.05.2018

---------------------------------------
--          Tree Grab                --
---------------------------------------
imba_tiny_tree_grab = imba_tiny_tree_grab or class({})
LinkLuaModifier("imba_tiny_tree_modifier", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_tiny_tree_damage_modifier", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_tiny_tree_building_modifier", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("imba_tiny_tree_animation_modifier", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function imba_tiny_tree_grab:OnSpellStart()
	if IsServer() then 
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()

		-- Destroy targeted tree
		GridNav:DestroyTreesAroundPoint(target_point, 1, false)

		local damage_modifier = caster:AddNewModifier(caster, self, "imba_tiny_tree_damage_modifier", {})
		damage_modifier:SetStackCount(self:GetSpecialValueFor("bonus_damage"))
		local tree_modifier = caster:AddNewModifier(caster, self, "imba_tiny_tree_modifier", {})
		tree_modifier:SetStackCount(5)

		local ability_slot3 = caster:GetAbilityByIndex(2)
		local ability_slot4 = caster:GetAbilityByIndex(3)
		ability_slot4:SetLevel(ability_slot3:GetLevel())

		caster:SwapAbilities(ability_slot3:GetAbilityName(), ability_slot4:GetAbilityName(), false, true)
		
		-- Add tree model + animation
		caster:AddNewModifier(caster, self, "imba_tiny_tree_animation_modifier", {})
	end
end



----------------------------------------------
--     Tree Model and Animation modifier	--
----------------------------------------------
imba_tiny_tree_animation_modifier = class({})
function imba_tiny_tree_animation_modifier:IsHidden() return true end
function imba_tiny_tree_animation_modifier:IsPurgable() return false end
function imba_tiny_tree_animation_modifier:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local grow = caster:FindAbilityByName("imba_tiny_grow")
		local grow_lvl = grow:GetLevel()

		-- If we allrdy have a tree... destroy it and create new. 
		if caster.tree ~= nil then
			caster.tree:AddEffects(EF_NODRAW)
			UTIL_Remove(caster.tree)
			caster.tree = nil
		end
		
		-- Create the tree model
		self.tree = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_01/tiny_01_tree.vmdl"})
		-- Bind it to caster bone 
		self.tree:FollowEntity(self:GetCaster(), true)
		-- Find the Coordinates for model position on left hand
		local origin = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack2"))
		-- Forward Vector!
		local fv = caster:GetForwardVector()
		
		-- Apply diffrent positions of the tree depending on growth model...
		if grow_lvl == 3 then
			--Adjust poition to match grow lvl 3
	        local pos = origin + (fv * 50)
	        self.tree:SetAbsOrigin(Vector(pos.x + 10, pos.y, (origin.z + 25)))
		
		elseif grow_lvl == 2 then
			-- Adjust poition to match grow lvl 2
	        local pos = origin + (fv * 35)
	        self.tree:SetAbsOrigin(Vector(pos.x, pos.y, (origin.z + 25)))

	    elseif grow_lvl == 1 then
	    	-- Adjust poition to match grow lvl 1
	        local pos = origin + (fv * 35) 
	        self.tree:SetAbsOrigin(Vector(pos.x, pos.y + 20, (origin.z + 25)))

	    elseif grow_lvl == 0 then
	    	-- Adjust poition to match original no grow model
	        local pos = origin - (fv * 25) 
	        self.tree:SetAbsOrigin(Vector(pos.x - 20, pos.y - 30 , origin.z))
	        self.tree:SetAngles(60, 60, -60)
	    end

		-- Save model to caster
	    caster.tree = self.tree

	    -- Change animation now that we have a huge ass tree in our hand.
        StartAnimation(caster, { duration = -1, activity = ACT_DOTA_ATTACK_EVENT , rate = 2, translate = "tree" })
	end
end

function imba_tiny_tree_animation_modifier:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		-- stop tree animation
		EndAnimation(caster)
		caster.tree:AddEffects(EF_NODRAW)
	end
end

---------------------------------------
--        Tree Grabb modifier        --
---------------------------------------
imba_tiny_tree_modifier = imba_tiny_tree_modifier or class({})
function imba_tiny_tree_modifier:IsHidden() return false end
function imba_tiny_tree_modifier:IsBuff() return true end
function imba_tiny_tree_modifier:IsPurgable() return false end
function imba_tiny_tree_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
	}
	return funcs
end

function imba_tiny_tree_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end

function imba_tiny_tree_modifier:GetModifierAttackRangeBonus()
	return self.attack_range
end

function imba_tiny_tree_modifier:OnCreated()
	local caster = self:GetCaster()
	if caster ~= nil then 
		local attack_range = self:GetAbility():GetSpecialValueFor("attack_range");
		local caster_range = caster:Script_GetAttackRange()
		-- Override cast_range. it should be fixed when holding a tree
		if caster_range > attack_range then
			self.attack_range = (caster_range - attack_range)
		else
			self.attack_range = (attack_range - caster_range)
		end		
	end
end

function imba_tiny_tree_modifier:OnAttackStart(keys)
	-- Add extra dps vs buildings
	if keys.attacker == self:GetCaster() then 
		if keys.target ~= nil and keys.target:IsBuilding() then
			local caster = self:GetCaster()
			local building_damage_modifier = caster:AddNewModifier(caster, self, "imba_tiny_tree_building_modifier", {})
			building_damage_modifier:SetStackCount(self:GetAbility():GetSpecialValueFor("bonus_damage_buildings"))
		end
	end
end

function imba_tiny_tree_modifier:OnAttack(keys)
	local caster = self:GetCaster()
	if IsServer() then 
		if caster == keys.attacker then
			if caster:HasModifier("imba_tiny_tree_building_modifier") then
				caster:RemoveModifierByName("imba_tiny_tree_building_modifier")
			end

			if keys.target ~= nil then
				-- Splash is centered around a point abit intfron of tiny, tweeked by "splash_distance"
				local splash_distance = caster:GetForwardVector() * self:GetAbility():GetSpecialValueFor("splash_distance")
				local splash_radius = self:GetAbility():GetSpecialValueFor("splash_radius")
				local splash_damage = self:GetAbility():GetSpecialValueFor("splash_damage")
				splash_distance.z = 0

				-- Initiate splash damage_table
				local damage_table = {}
				damage_table.attacker = caster
				damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
				damage_table.damage = caster:GetAttackDamage() * (splash_damage / 100)

				local enemies = FindUnitsInRadius(
					caster:GetTeam(), 
					caster:GetAbsOrigin() + splash_distance, 
					nil, 
					splash_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY, 
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					0,
					0,
					false) 

				for _,enemy in pairs(enemies) do
					-- Dont deal damage to main target twice
					if enemy ~= keys.target then
						damage_table.victim = enemy
						ApplyDamage(damage_table)
					end
				end
			end

			-- Check if we ran out of stacks...
			if caster:HasModifier("imba_tiny_tree_modifier") then
				local modifier = caster:FindModifierByName("imba_tiny_tree_modifier")
				local stacks = modifier:GetStackCount() -1 
				if stacks > 0 then
					modifier:SetStackCount(stacks)
				else
					caster:RemoveModifierByName("imba_tiny_tree_modifier")
				end
			end
		end
	end
end

function imba_tiny_tree_modifier:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local ability_slot3 = caster:GetAbilityByIndex(2)
		local ability_slot4 = caster:GetAbilityByIndex(3)
		caster:SwapAbilities(ability_slot3:GetAbilityName(), ability_slot4:GetAbilityName(), false, true)
		-- Trigger cd when last stack is used up
		self:GetAbility():UseResources(false, false, true)
		if caster:HasTalent("special_bonus_imba_tiny_4") then
			local ability = self:GetAbility()
			local cooldown_reduction = self:GetParent():FindTalentValue("special_bonus_imba_tiny_4")
			local current_cooldown = ability:GetCooldownTime()
			local new_cooldown = current_cooldown - self:GetParent():FindTalentValue("special_bonus_imba_tiny_4")
			ability:EndCooldown()
			self:GetAbility():StartCooldown(new_cooldown)
		end

		if self:GetAbility().tree ~= nil then
			self:GetAbility().tree:Destroy()
		end

		if caster:HasModifier("imba_tiny_tree_damage_modifier") then
			caster:RemoveModifierByName("imba_tiny_tree_damage_modifier")
		end

		if not caster:HasScepter() then 
			caster:RemoveModifierByName("imba_tiny_tree_animation_modifier")
		end
	end
end

---------------------------------------
--       Tree Damage modifier        --
---------------------------------------
imba_tiny_tree_damage_modifier = imba_tiny_tree_damage_modifier or class({})
function imba_tiny_tree_damage_modifier:IsHidden() return true end
function imba_tiny_tree_damage_modifier:IsBuff() return true end
function imba_tiny_tree_damage_modifier:IsPurgable() return false end
function imba_tiny_tree_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function imba_tiny_tree_damage_modifier:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

---------------------------------------
-- Tree Damage vs budilding modifier --
---------------------------------------
imba_tiny_tree_building_modifier = imba_tiny_tree_building_modifier or class({})
function imba_tiny_tree_building_modifier:IsHidden() return true end
function imba_tiny_tree_building_modifier:IsBuff() return true end
function imba_tiny_tree_building_modifier:IsPurgable() return false end
function imba_tiny_tree_building_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function imba_tiny_tree_building_modifier:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

---------------------------------------
--          Tree Throw               --
---------------------------------------
imba_tiny_tree_throw = imba_tiny_tree_throw or class({})
LinkLuaModifier("modifier_imba_tree_throw", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_tiny_tree_throw_knockback", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
function imba_tiny_tree_throw:OnSpellStart()
	if IsServer() then
		local target_point 		= self:GetCursorPosition()
		local target 			= self:GetCursorTarget() 
		local caster 			= self:GetCaster()
		local caster_position 	= caster:GetAbsOrigin()
		local ability 			= caster:FindAbilityByName("imba_tiny_tree_throw")

		local travel_speed 		= ability:GetSpecialValueFor("travel_speed")
		local travel_distance	= ability:GetSpecialValueFor("travel_distance")
		local collision_radius	= ability:GetSpecialValueFor("collision_radius")
		local vision_distance	= ability:GetSpecialValueFor("vision_distance")

		local bonus_damage 		= ability:GetSpecialValueFor("bonus_damage")
		local splash_radius 	= ability:GetSpecialValueFor("splash_radius")
		local splash_damage 	= ability:GetSpecialValueFor("splash_damage")

		local distance 			= (target_point - caster_position):Length2D()
		local direction 		= (target_point - caster_position):Normalized()
		local velocity 			= direction * travel_speed

		-- Create linear projectile if we have no target
		if target == nil then 
			local projectile =  
			{
				EffectName 			= "particles/units/heroes/hero_tiny/tiny_tree_linear_proj.vpcf",
				Ability 			= self,
				vSpawnOrigin 		= caster_position,
				fDistance 			= distance,
				fStartRadius 		= collision_radius,
				fEndRadius 			= collision_radius,
				Source 				= caster,
				bHasFrontalCone 	= true,
				bReplaceExisting 	= false,
				bProvidesVision 	= true,
				iVisionTeamNumber 	= caster:GetTeam(),
				iVisionRadius 		= vision_distance,
				bDrawsOnMinimap 	= false,
				bVisibleToEnemies 	= true, 
				bDeleteOnHit		= true,
				iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				vVelocity 			= Vector(velocity.x,velocity.y,0),
				fExpireTime 		= GameRules:GetGameTime() + 10,
				ExtraData 			= 
				{
					splash_radius 	= splash_radius,
					splash_damage 	= splash_damage
				}
			}				

			ProjectileManager:CreateLinearProjectile(projectile)

		else
			-- Create tracking projectile if we have target
			local projectile =  
			{
				EffectName 			= "particles/units/heroes/hero_tiny/tiny_tree_proj.vpcf",
				Ability 			= self,
				fDistance 			= distance,
				fStartRadius 		= collision_radius,
				fEndRadius 			= collision_radius,
				Source 				= caster,
				Target 				= target,
				iMoveSpeed 			= travel_speed,
				bHasFrontalCone 	= true,
				bReplaceExisting 	= false,
				bProvidesVision 	= true,
				iVisionTeamNumber 	= caster:GetTeam(),
				iVisionRadius 		= vision_distance,
				bDrawsOnMinimap 	= false,
				bVisibleToEnemies 	= true, 
				bDeleteOnHit		= true,
				bDodgeable 			= true,
				fExpireTime 		= GameRules:GetGameTime() + 10,
				ExtraData 			= 
				{
					splash_radius 	= splash_radius,
					splash_damage 	= splash_damage
				}
			}				
			ProjectileManager:CreateTrackingProjectile(projectile)
		end

		caster:RemoveModifierByName("imba_tiny_tree_modifier")

		if not caster:HasScepter() then 
			caster:RemoveModifierByName("imba_tiny_tree_animation_modifier")
		end
	end
end

function imba_tiny_tree_throw:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if not target then
			return nil
		end
		
		local hit_location = target:GetAbsOrigin()
		local caster = self:GetCaster()

		-- Add tree toss bonus modifier
		caster:AddNewModifier(caster, self, "modifier_imba_tree_throw", {})

		-- Initializing the spalsh damage table
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
		damage_table.damage = caster:GetAttackDamage() * (ExtraData.splash_damage / 100)

		local enemies = FindUnitsInRadius(
			caster:GetTeam(), 
			hit_location, 
			nil, 
			ExtraData.splash_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			0,
			0,
			false) 

		for _,enemy in pairs(enemies) do
			-- Dont deal damage to main target twice
			if enemy ~= target then
				damage_table.victim = enemy
				ApplyDamage(damage_table)
				imba_tiny_tree_throw:KnockBack(caster, enemy, location)
			else
				imba_tiny_tree_throw:KnockBack(caster, enemy, caster:GetAbsOrigin())
			end
		end

		-- Do a normal attack, will apply orb effects, cannot miss
		caster:PerformAttack(target, true, true, true, true, true, false, true)
		-- Remove tree toss bonus modifier
		caster:RemoveModifierByName("modifier_imba_tree_throw")
		return true
	end
end

function imba_tiny_tree_throw:KnockBack(caster, target,knockback_center)
	if caster:HasTalent("special_bonus_imba_tiny_5") then
		local knockback_direction 	= (target:GetAbsOrigin() - knockback_center):Normalized() 
		--local knockback_duration 	= caster:GetTalentSpecialValueFor("special_bonus_imba_tiny_5")
		local knockback_talent 	= caster:FindAbilityByName("special_bonus_imba_tiny_5")
		local knockback_duration = knockback_talent:GetSpecialValueFor("knockback_duration")
		local knockback_distance = knockback_talent:GetSpecialValueFor("knockback_distance")

		target:AddNewModifier(caster, self, "modifier_knockback", {
			center_x 			= knockback_center.x, 
			center_y 			= knockback_center.y, 
			center_z 			= knockback_center.z, 
			duration 			= knockback_duration,
			knockback_duration 	= knockback_duration,
	        knockback_distance 	= knockback_distance,
	        knockback_height 	= 0
		})
	end
end

modifier_imba_tiny_tree_throw_knockback = class({})
function modifier_imba_tiny_tree_throw_knockback:IsHidden() return false end
function modifier_imba_tiny_tree_throw_knockback:IsDebuff() return true end
function modifier_imba_tiny_tree_throw_knockback:IsPurgable() return false end
function modifier_imba_tiny_tree_throw_knockback:CheckState()
local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end

function modifier_imba_tiny_tree_throw_knockback:GetOverrideAnimation()
  	return ACT_DOTA_DISABLED
end

modifier_imba_tree_throw = modifier_imba_tree_throw or class({})
function modifier_imba_tree_throw:IsHidden() return true end
function modifier_imba_tree_throw:IsBuff() return true end
function modifier_imba_tree_throw:IsPurgable() return false end
function modifier_imba_tree_throw:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_imba_tree_throw:GetModifierPreAttack_BonusDamage()
	local ability = self:GetAbility()
	return ability:GetSpecialValueFor("bonus_damage");
end

---------------------------------------
--          ROLLING STONE            --
---------------------------------------
imba_tiny_rolling_stone = imba_tiny_rolling_stone or class({})

function imba_tiny_rolling_stone:GetAbilityTextureName()
	return "custom/imba_tiny_rolling_stone"
end

function imba_tiny_rolling_stone:IsInnateAbility()
	return true
end

function imba_tiny_rolling_stone:GetIntrinsicModifierName()
	return "modifier_imba_tiny_rolling_stone"
end


LinkLuaModifier("modifier_imba_tiny_rolling_stone", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_rolling_stone = class({})

function modifier_imba_tiny_rolling_stone:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed_reduction")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	self.modelscale = self:GetAbility():GetSpecialValueFor("bonus_model_scale")
	self.gain = self:GetAbility():GetSpecialValueFor("stack_per_min")

	self.talent8 = false
	self.talent2 = false

	self.internalTimer = 0
	if IsServer() then
		self:StartIntervalThink(0.03)
	end
end

function modifier_imba_tiny_rolling_stone:OnRefresh()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.attackspeed = self:GetAbility():GetSpecialValueFor("attackspeed_reduction")
	self.movespeed = self:GetAbility():GetSpecialValueFor("bonus_movespeed")
	self.modelscale = self:GetAbility():GetSpecialValueFor("bonus_model_scale")
	self.modelcap = self:GetAbility():GetSpecialValueFor("max_model_scale")
	self.gain = self:GetAbility():GetSpecialValueFor("stack_per_min")
	self.growscale = 0
end

function modifier_imba_tiny_rolling_stone:OnIntervalThink()
	if self:GetParent():IsIllusion() then
		self:SetStackCount(0)
		return nil
	end

	if self:GetParent():IsMoving() then
		self.internalTimer = self.internalTimer + 0.03 * self.gain
	end
	if self.internalTimer >= 60 then
		self.internalTimer = 0
		self:IncrementStackCount()
	end
	if not self.talent8 then
		if self:GetParent():HasTalent("special_bonus_imba_tiny_8") then
			self.talent8 = true
			self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("special_bonus_imba_tiny_8"), "modifier_special_bonus_imba_tiny_8", {})
		end
	end
	if not self.talent2 then
		if self:GetParent():HasTalent("special_bonus_imba_tiny_2") then
			self.talent2 = true
			self:SetStackCount(self:GetStackCount() + self:GetParent():FindTalentValue("special_bonus_imba_tiny_2") )
		end
	end
end

function modifier_imba_tiny_rolling_stone:IsHidden()
	return false
end

function modifier_imba_tiny_rolling_stone:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_rolling_stone:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end

function modifier_imba_tiny_rolling_stone:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage * self:GetStackCount()
end

function modifier_imba_tiny_rolling_stone:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed * self:GetStackCount()
end

function modifier_imba_tiny_rolling_stone:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():HasModifier("modifier_special_bonus_imba_tiny_8") then
		return self.attackspeed * self:GetStackCount()
	else
		return 0
	end
end

function modifier_imba_tiny_rolling_stone:GetModifierModelScale()
	if IsServer() then
		local scale = self.modelscale * self:GetStackCount() - self.growscale
		if scale > self.modelcap then scale = self.modelcap end
		return scale
	end
end


---------------------------------------
--             AVALANCH              --
---------------------------------------

imba_tiny_avalanche = imba_tiny_avalanche or class({})

function imba_tiny_avalanche:GetAbilityTextureName()
	return "tiny_avalanche"
end

function imba_tiny_avalanche:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

if IsServer() then
	function imba_tiny_avalanche:OnSpellStart()
		local vPos = self:GetCursorPosition()
		local caster = self:GetCaster()

		local delay = self:GetSpecialValueFor("projectile_duration")
		local casterPos = caster:GetAbsOrigin()
		local distance = (vPos - casterPos):Length2D()
		local direction = (vPos - casterPos):Normalized()
		local velocity = distance/delay * direction
		local ticks = 1 / self:GetSpecialValueFor("tick_interval")
		velocity.z = 0

		local wearables = caster:GetChildren()
		for _,wearable in pairs(wearables) do
            if wearable:GetClassname() == "dota_item_wearable" then
                if wearable:GetModelName():match("tree") then
--					print("Tree", (wearable:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized(), wearable:GetAngles())
                end
            end
		end



		if caster.tree ~= nil then
			caster.tree:RemoveEffects(EF_NODRAW)
		end

		local info = {
			EffectName = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf",
			Ability = self,
			vSpawnOrigin = self:GetCaster():GetOrigin(),
			fStartRadius = 0,
			fEndRadius = 0,
			vVelocity = velocity,
			fDistance = distance,
			Source = self:GetCaster(),
			iUnitTargetTeam = 0,
			iUnitTargetType = 0,
			ExtraData = {ticks = ticks}
		}
		ProjectileManager:CreateLinearProjectile( info )
		EmitSoundOnLocationWithCaster(vPos, "Ability.Avalanche", caster)
	end

	function imba_tiny_avalanche:OnProjectileHit_ExtraData(hTarget, vLocation, extradata)
		local caster = self:GetCaster()
		local grow_ability = caster:FindAbilityByName("imba_tiny_grow")

		local duration = self:GetSpecialValueFor("stun_duration")
		local toss_mult = self:GetSpecialValueFor("toss_damage_multiplier")
		local radius = self:GetSpecialValueFor("radius")
		if grow_ability then
			radius = radius + caster:FindModifierByName("modifier_imba_tiny_rolling_stone"):GetStackCount() * caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")
		end
		local interval = self:GetSpecialValueFor("tick_interval")
		local damage = self:GetTalentSpecialValueFor("avalanche_damage") * self:GetSpecialValueFor("tick_interval")
		self.repeat_increase = false
		local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(avalanche, 0, vLocation)
		ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1, radius))
		local offset = 0
		local ticks = extradata.ticks
		if self:GetCaster():HasAbility("special_bonus_imba_tiny_3") then
			offset = self:GetCaster():FindTalentValue("special_bonus_imba_tiny_3")
			local projDuration = offset * 0.03 / (ticks * interval)
			local newLoc = vLocation
			local distanceTravelled = 0
			Timers:CreateTimer(function()
				ParticleManager:SetParticleControl(avalanche, 0, newLoc + projDuration)
				newLoc = newLoc + projDuration
				distanceTravelled = distanceTravelled + projDuration
				if distanceTravelled < offset then
					return 0.03
				end
			end)
		end
		local hitLoc = vLocation
		Timers:CreateTimer(function()
			local enemies_tick = FindUnitsInRadius(caster:GetTeamNumber(), hitLoc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for _,enemy in pairs(enemies_tick) do
				if enemy:HasModifier("modifier_tiny_toss_movement") and not self.repeat_increase then
					damage = damage * toss_mult
					self.repeat_increase = true
				end
				ApplyDamage({victim = enemy, attacker = caster, damage = damage, damage_type = self:GetAbilityDamageType(), ability = self})
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = duration})
			end
			hitLoc = hitLoc + offset / ticks
			extradata.ticks = extradata.ticks - 1
			if extradata.ticks > 0 then
				return interval
			else
				ParticleManager:DestroyParticle(avalanche, false)
				ParticleManager:ReleaseParticleIndex(avalanche)
			end
		end)
	end
end

function imba_tiny_avalanche:GetIntrinsicModifierName()
	return "modifier_imba_tiny_avalanche_passive"
end

LinkLuaModifier("modifier_imba_tiny_avalanche_passive", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_avalanche_passive = class({})
function modifier_imba_tiny_avalanche_passive:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("passive_chance")
	self.prng = -10
end

function modifier_imba_tiny_avalanche_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("passive_chance")
end

function modifier_imba_tiny_avalanche_passive:IsHidden()
	return true
end

function modifier_imba_tiny_avalanche_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_avalanche_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_imba_tiny_avalanche_passive:OnAttackLanded(params)
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return nil
		end

		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if RollPseudoRandom(self.chance, self) then
				local vPos = params.target:GetAbsOrigin()
				local caster = self:GetCaster()
				local delay = self:GetAbility():GetSpecialValueFor("projectile_duration")
				local casterPos = caster:GetAbsOrigin()
				local distance = (vPos - casterPos):Length2D()
				local direction = (vPos - casterPos):Normalized()
				local velocity = distance/delay * direction
				velocity.z = 0

				local ticks = self:GetAbility():GetTalentSpecialValueFor("passive_ticks")

				local info = {
					EffectName = "particles/units/heroes/hero_tiny/tiny_avalanche_projectile.vpcf",
					Ability = self:GetAbility(),
					vSpawnOrigin = self:GetCaster():GetOrigin(),
					fStartRadius = 0,
					fEndRadius = 0,
					vVelocity = velocity,
					fDistance = distance,
					Source = self:GetCaster(),
					iUnitTargetTeam = 0,
					iUnitTargetType = 0,
					ExtraData = {ticks = ticks}
				}
				ProjectileManager:CreateLinearProjectile( info )
				EmitSoundOnLocationWithCaster(vPos, "Ability.Avalanche", caster)
			end
		end
	end
end

---------------------------------------
--               TOSS                --
---------------------------------------

imba_tiny_toss = imba_tiny_toss or class({})

function imba_tiny_toss:GetAbilityTextureName()
	return "tiny_toss"
end

function imba_tiny_toss:IsNetherWardStealable()
	return false
end

function imba_tiny_toss:CastFilterResultTarget( hTarget )
	if IsServer() then
		print(PlayerResource:IsDisableHelpSetForPlayerID(hTarget:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()))
		print(PlayerResource:IsDisableHelpSetForPlayerID(self:GetCaster():GetPlayerOwnerID(), hTarget:GetPlayerOwnerID()))
		if hTarget:IsOpposingTeam(self:GetCaster():GetTeamNumber()) and PlayerResource:IsDisableHelpSetForPlayerID(hTarget:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()) then 	
			return UF_FAIL_DISABLE_HELP
		end
	end

	return UnitFilter(hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
end

function imba_tiny_toss:OnSpellStart()
	self.tossPosition = self:GetCursorPosition()
	local hTarget = self:GetCursorTarget()
	local caster = self:GetCaster()
	local tossVictim = caster
	local duration = self:GetSpecialValueFor("duration")

	if not hTarget then
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), self.tossPosition, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 1, false)
		for _,target in pairs(targets) do
			hTarget = target
			break
		end
	end
	if hTarget then
		self.tossPosition = hTarget:GetAbsOrigin()
		self.tossTarget = hTarget
	else
		self.tossTarget = nil
	end

	local vLocation = self.tossPosition
	local kv =
	{
		vLocX = vLocation.x,
		vLocY = vLocation.y,
		vLocZ = vLocation.z,
		duration = duration,
		damage = self:GetSpecialValueFor("toss_damage")
	}

	local tossVictims = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, 1, false)

	for _, victim in pairs(tossVictims) do
		if (PlayerResource:IsDisableHelpSetForPlayerID(victim:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID())) then
			table.remove(tossVictims, _)
		end
	end

	for _, victim in pairs(tossVictims) do
		if victim ~= caster then
			victim:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
			if not self:GetCaster():HasTalent("special_bonus_imba_tiny_7") then
				break
			else
				kv.damage = self:GetSpecialValueFor("multitoss_damage")
			end
		end
	end

	-- If only Tiny himself was found, launch him instead
	if #tossVictims <= 1 then
		caster:AddNewModifier(caster, self, "modifier_tiny_toss_movement", kv)
	end

	caster:StartGesture(ACT_TINY_TOSS)

	EmitSoundOn("Ability.TossThrow", self:GetCaster())
end


function imba_tiny_toss:GetCastRange(vLocation, hTarget)
	if IsServer() or hTarget then
		return self:GetSpecialValueFor("cast_range")
	elseif hTarget == nil then
		return self:GetSpecialValueFor("grab_radius")
	end
end

function imba_tiny_toss:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	return radius
end

LinkLuaModifier("modifier_tiny_toss_movement", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)

modifier_tiny_toss_movement = modifier_tiny_toss_movement or class({})
function modifier_tiny_toss_movement:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_movement:IsHidden()
	return true
end

function modifier_tiny_toss_movement:IgnoreTenacity()
	return true
end

function modifier_tiny_toss_movement:IsMotionController()
	return true
end

function modifier_tiny_toss_movement:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:OnCreated( kv )
	self.toss_minimum_height_above_lowest = 500
	self.toss_minimum_height_above_highest = 100
	self.toss_acceleration_z = 4000
	self.toss_max_horizontal_acceleration = 3000

	if IsServer() then
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = Vector( kv.vLocX, kv.vLocY, kv.vLocZ )
		self.damage = kv.damage
		self.vLastKnownTargetPos = self.vLoc

		local duration = self:GetAbility():GetSpecialValueFor( "duration" )
		local flDesiredHeight = self.toss_minimum_height_above_lowest * duration * duration
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + self.toss_minimum_height_above_highest )

		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * self.toss_acceleration_z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * self.toss_acceleration_z * flDeltaZ ) )
		self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / self.toss_acceleration_z, ( self.flInitialVelocityZ - flSqrtDet) / self.toss_acceleration_z )

		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_tiny_toss_movement:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end


		-- Horizontal motion
		self:HorizontalMotion(self.parent, self.frametime)

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_movement:TossLand()
	if IsServer() then
		-- If the Toss was already completed, do nothing
		if self.toss_land_commenced then
			return nil
		end

		-- Mark Toss as completed
		self.toss_land_commenced = true

		local caster = self:GetCaster()
		local rolling_stone_modifier = caster:FindModifierByName("modifier_imba_tiny_rolling_stone")
		local radius = self:GetAbility():GetSpecialValueFor("radius")
		if rolling_stone_modifier and caster:HasAbility("imba_tiny_grow") then
			radius = radius + rolling_stone_modifier:GetStackCount() * caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")
		end

		-- Destroy trees at the target point
		GridNav:DestroyTreesAroundPoint(self.vLastKnownTargetPos, radius, true)

		local victims = FindUnitsInRadius(caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, 0, 1, false)
		for _, victim in pairs(victims) do
			local damage = self.damage
			if victim == self.parent then
				local damage_multiplier = 1 + self.ability:GetSpecialValueFor("bonus_damage_pct") / 100
				if rolling_stone_modifier then
					damage_multiplier = damage_multiplier + rolling_stone_modifier:GetStackCount() / 100
				end
				damage = damage * damage_multiplier
			end
			if victim:IsBuilding() then
				damage = damage * self.ability:GetSpecialValueFor("building_dmg") * 0.01
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			else
				ApplyDamage({victim = victim, attacker = caster, damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
			end
			if caster:HasScepter() and not victim:IsBuilding() then
				victim:AddNewModifier(caster, self.ability, "modifier_stunned", {duration = self.ability:GetSpecialValueFor("scepter_stun_duration")})
			end
		end
		if self.parent == caster then
			ApplyDamage({victim = caster, attacker = caster, damage = caster:GetMaxHealth() * self.ability:GetSpecialValueFor("self_dmg_pct") * 0.01, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
		end

		EmitSoundOn("Ability.TossImpact", self.parent)
		if caster:HasScepter() and self.parent:IsAlive() and self.parent ~= caster then
			self.parent:AddNewModifier(caster, self.ability, "modifier_tiny_toss_scepter_bounce", {})
		end

		self.parent:SetUnitOnClearGround()
		Timers:CreateTimer(FrameTime(), function()
			ResolveNPCPositions(self.parent:GetAbsOrigin(), 150)
		end)
	end
end

function modifier_tiny_toss_movement:OnDestroy()
	if IsServer() then
		self.parent:SetUnitOnClearGround()
	end
end



--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_tiny_toss_movement:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_movement:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_movement:HorizontalMotion( me, dt )
	if IsServer() then
		-- If the unit being tossed died, interrupt motion controllers and remove self
		if not self.parent:IsAlive() then
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end

		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, self.toss_max_horizontal_acceleration )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

function modifier_tiny_toss_movement:VerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -self.toss_acceleration_z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0

		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * self.toss_acceleration_z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			self:TossLand()
		end
	end
end

LinkLuaModifier("modifier_tiny_toss_scepter_bounce", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_VERTICAL)

modifier_tiny_toss_scepter_bounce = modifier_tiny_toss_scepter_bounce or class({})
function modifier_tiny_toss_scepter_bounce:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_scepter_bounce:IsHidden()
	return true
end

function modifier_tiny_toss_scepter_bounce:RemoveOnDeath()
	return false
end

function modifier_tiny_toss_scepter_bounce:IsMotionController()
	return true
end

function modifier_tiny_toss_scepter_bounce:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:OnCreated( kv )
	if IsServer() then
		if self:ApplyVerticalMotionController() == false then
			self:Destroy()
		end

		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.scepter_bounce_damage_pct = self.ability:GetSpecialValueFor("scepter_bounce_damage_pct")
		self.toss_damage = self.ability:GetSpecialValueFor("toss_damage")

		EmitSoundOn("Hero_Tiny.Toss.Target", self:GetParent())
		self.bounce_duration = self:GetAbility():GetSpecialValueFor("scepter_bounce_duration")
		self.time = 0
		self.toss_z = 0
		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_tiny_toss_scepter_bounce:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_tiny_toss_scepter_bounce:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
function modifier_tiny_toss_scepter_bounce:GetEffectName()
	return "particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf"
end

function modifier_tiny_toss_scepter_bounce:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
					[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			else
				local state = {
					[MODIFIER_STATE_ROOTED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

function modifier_tiny_toss_scepter_bounce:OnIntervalThink()
	if IsServer() then
		-- Check for motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Vertical motion
		self:VerticalMotion(self.parent, self.frametime)
	end
end

function modifier_tiny_toss_scepter_bounce:VerticalMotion( me, dt )
	if IsServer() then

		if self.time < self.bounce_duration then
			self.time = self.time + dt
			if self.bounce_duration/2 > self.time then
				-- Go up
				-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
				self.toss_z = self.toss_z + 25
				-- Set the new location to the current ground location + the memorized z point
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			elseif self.parent:GetAbsOrigin().z > 0 then
				-- Go down
				self.toss_z = self.toss_z - 25
				self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.toss_z))
			end
		else
			self.parent:InterruptMotionControllers(true)
			self:Destroy()
		end
	end
end

function modifier_tiny_toss_scepter_bounce:OnRemoved()
	if IsServer() then
		local damage = self.toss_damage * self.scepter_bounce_damage_pct * 0.01
		local radius = self:GetAbility():GetSpecialValueFor("radius") + self.caster:FindModifierByName("modifier_imba_tiny_rolling_stone"):GetStackCount() * self.caster:FindAbilityByName("imba_tiny_grow"):GetSpecialValueFor("rolling_stones_aoe")

		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			ApplyDamage({victim = enemy, attacker = self.caster, damage = damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
		end
		self:GetParent():SetUnitOnClearGround()
	end
end

---------------------------------------
--          CRAGGY EXTERIOR          --
---------------------------------------

imba_tiny_craggy_exterior = imba_tiny_craggy_exterior or class({})

function imba_tiny_craggy_exterior:GetIntrinsicModifierName()
	return "modifier_imba_tiny_craggy_exterior_passive"
end

function imba_tiny_craggy_exterior:GetAbilityTextureName()
	return "tiny_craggy_exterior"
end

LinkLuaModifier("modifier_imba_tiny_craggy_exterior_passive", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_craggy_exterior_passive = class({})
function modifier_imba_tiny_craggy_exterior_passive:OnCreated()
	self.chance = self:GetAbility():GetSpecialValueFor("stun_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.prng = -10
end

function modifier_imba_tiny_craggy_exterior_passive:OnRefresh()
	self.chance = self:GetAbility():GetSpecialValueFor("stun_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.reduction_duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
end

function modifier_imba_tiny_craggy_exterior_passive:IsHidden()
	return true
end

function modifier_imba_tiny_craggy_exterior_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_craggy_exterior_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_imba_tiny_craggy_exterior_passive:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_imba_tiny_craggy_exterior_passive:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then
			local caster = self:GetCaster()

			if caster:PassivesDisabled() or                                              -- if Tiny is broken, do nothing.
				params.attacker:IsBuilding() or	params.attacker:IsMagicImmune() then         -- if the guy attacking Tiny is a tower or spell immune, do nothing.
				return nil
			end

			if RollPseudoRandom(self.chance, self) then
				if self:GetParent():HasTalent("special_bonus_imba_tiny_4") then
					EmitSoundOn("Hero_Tiny.CraggyExterior", self:GetCaster())
					local radius = self:GetParent():FindTalentValue("special_bonus_imba_tiny_4")
					local avalanche = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_CUSTOMORIGIN, params.attacker)
					ParticleManager:SetParticleControl(avalanche, 0, params.attacker:GetAbsOrigin())
					ParticleManager:SetParticleControl(avalanche, 1, Vector(radius, 1, radius))
					Timers:CreateTimer(0.2, function()
						ParticleManager:DestroyParticle(avalanche, false)
						ParticleManager:ReleaseParticleIndex(avalanche)
					end)
					local craggy_targets = FindUnitsInRadius(caster:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
					for _,target in pairs(craggy_targets) do
						ApplyDamage({victim = target, attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
						target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.duration})
						EmitSoundOn("Hero_Tiny.CraggyExterior.Stun", params.attacker)
					end
				else
					ApplyDamage({victim = params.attacker, attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()})
					params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.duration})
					local craggy = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_craggy_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControl(craggy, 0, self:GetCaster():GetAbsOrigin())
					ParticleManager:SetParticleControl(craggy, 1, params.attacker:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(craggy)
					EmitSoundOn("Hero_Tiny.CraggyExterior", self:GetCaster())
					EmitSoundOn("Hero_Tiny.CraggyExterior.Stun", params.attacker)
				end
			end

			-- Bluntstone

			if not params.attacker:HasModifier("modifier_craggy_exterior_blunt") then
				params.attacker:AddNewModifier(caster, self:GetAbility(), "modifier_craggy_exterior_blunt", {duration = self.reduction_duration})
			end

			local modifier_blunt_handler = params.attacker:FindModifierByName("modifier_craggy_exterior_blunt")
			if modifier_blunt_handler then
				modifier_blunt_handler:IncrementStackCount()
				modifier_blunt_handler:ForceRefresh()
			end
		end
	end
end

LinkLuaModifier("modifier_craggy_exterior_blunt", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_craggy_exterior_blunt = class({})
function modifier_craggy_exterior_blunt:OnCreated()
	self.caster = self:GetCaster()
	self.reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_craggy_exterior_blunt:OnRefresh()
	self:OnCreated()
end

function modifier_craggy_exterior_blunt:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end

function modifier_craggy_exterior_blunt:GetModifierPreAttack_BonusDamage()
	local reduction = self.reduction + self.caster:FindTalentValue("special_bonus_imba_tiny_5")
	return reduction * self:GetStackCount()
end


---------------------------------------
--          	  GROW 		         --
---------------------------------------
imba_tiny_grow = imba_tiny_grow or class({})

function imba_tiny_grow:GetAbilityTextureName()
	return "tiny_grow"
end

function imba_tiny_grow:GetIntrinsicModifierName()
	return "modifier_imba_tiny_grow_passive"
end

function imba_tiny_grow:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		local reapply_craggy = false 

		local rolling_stone = self:GetCaster():FindModifierByName("modifier_imba_tiny_rolling_stone")
		rolling_stone.growscale = self:GetSpecialValueFor("rolling_stone_scale_reduction")
		local old_stacks = self:GetLevelSpecialValueFor("rolling_stones_stacks", self:GetLevel() - 2 )
		local new_stacks = self:GetLevelSpecialValueFor("rolling_stones_stacks", self:GetLevel() - 1 )
		if old_stacks == new_stacks then old_stacks = 0 end
		rolling_stone:SetStackCount(rolling_stone:GetStackCount() - old_stacks + new_stacks)
		local level = self:GetLevel() + 1
		if level < 5 then -- model bullshit
			-- Set new model
			self:GetCaster():SetOriginalModel("models/heroes/tiny_0"..level.."/tiny_0"..level..".vmdl")
			self:GetCaster():SetModel("models/heroes/tiny_0"..level.."/tiny_0"..level..".vmdl")
			-- Remove old wearables
			UTIL_Remove(self.head)
			UTIL_Remove(self.rarm)
			UTIL_Remove(self.larm)
			UTIL_Remove(self.body)
			-- Set new wearables
			self.head = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_head.vmdl"})
			self.rarm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_right_arm.vmdl"})
			self.larm = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_left_arm.vmdl"})
			self.body = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/tiny_0"..level.."/tiny_0"..level.."_body.vmdl"})
			-- lock to bone
			self.head:FollowEntity(self:GetCaster(), true)
			self.rarm:FollowEntity(self:GetCaster(), true)
			self.larm:FollowEntity(self:GetCaster(), true)
			self.body:FollowEntity(self:GetCaster(), true)
		end
		-- Effects
		self:GetCaster():StartGesture(ACT_TINY_GROWL)
		EmitSoundOn("Tiny.Grow", self:GetCaster())
		
		local grow = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster()) 
		ParticleManager:SetParticleControl(grow, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(grow)
	end
end

LinkLuaModifier("modifier_imba_tiny_grow_passive", "components/abilities/heroes/hero_tiny", LUA_MODIFIER_MOTION_NONE)
modifier_imba_tiny_grow_passive = class({})

function modifier_imba_tiny_grow_passive:OnCreated()
	self.cleave_pct = self:GetAbility():GetSpecialValueFor("bonus_cleave_damage_scepter")
	self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.cleave_startwidth = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.cleave_endwidth = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.attackrange = self:GetAbility():GetSpecialValueFor("bonus_range_scepter")
	self.buildingdmg = self:GetAbility():GetSpecialValueFor("bonus_building_damage_scepter")
	self.tree = nil
end

function modifier_imba_tiny_grow_passive:IsHidden()
	return true
end

function modifier_imba_tiny_grow_passive:RemoveOnDeath()
	return false
end

function modifier_imba_tiny_grow_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}

	return funcs
end

----------------------------------------------------------------------------

function modifier_imba_tiny_grow_passive:GetModifierAttackRangeBonus( params )
	if self:GetCaster():HasScepter() then
		return self.attackrange
	else
		return 0
	end
end

function modifier_imba_tiny_grow_passive:GetModifierTotalDamageOutgoing_Percentage( params )
	if IsServer() then
		if params.attacker == self:GetParent() and params.target:IsBuilding() and self:GetParent():HasScepter() and not params.inflictor then
			return self.buildingdmg
		end
	end
end

function modifier_imba_tiny_grow_passive:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and not params.target:IsBuilding() and self:GetParent():HasScepter() then
			DoCleaveAttack( params.attacker, params.target, self:GetAbility(), params.damage * self.cleave_pct / 100, self.cleave_startwidth, self.cleave_endwidth, self.cleave_distance, "particles/units/heroes/hero_tiny/tiny_grow_cleave.vpcf" )
		end
	end
end

function modifier_imba_tiny_grow_passive:GetModifierStatusResistanceStacking()
	return self:GetSpecialValueFor("status_resistance")
end
