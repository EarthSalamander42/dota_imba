--[[
		By: AtroCty
		Prev. Authors: Firetoad
		Date:  10.09.2015
		Updated:  11.04.2017
	]]

-- #7 Talent - Decreased cast-animations
--[[
function modifier_special_bonus_imba_tinker_7:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
	return decFuncs
end

function modifier_special_bonus_imba_tinker_7:GetModifierPercentageCasttime()
	return self:GetParent():FindTalentValue("special_bonus_imba_tinker_7")
end
--]]
-------------------------------------------
--			   REARM
-------------------------------------------
LinkLuaModifier("modifier_imba_rearm_animation", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rearm_overdrive", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rearm_shield", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)

imba_tinker_rearm = class({})

function imba_tinker_rearm:GetAbilityTextureName()
   return "tinker_rearm"
end

function imba_tinker_rearm:IsNetherWardStealable()
	return false
end

function imba_tinker_rearm:GetAssociatedSecondaryAbilities()
	return "imba_tinker_technomancy"
end

function imba_tinker_rearm:IsStealable()
	return true
end

function imba_tinker_rearm:IsHiddenWhenStolen()
	return false
end

function imba_tinker_rearm:GetIntrinsicModifierName()
    return "modifier_imba_rearm_overdrive"
end

function imba_tinker_rearm:GetChannelAnimation()
	return nil
end

function imba_tinker_rearm:GetChannelTime()
	if self:GetCaster():HasTalent("special_bonus_imba_tinker_8") then
		return 0
	end
	return self.BaseClass.GetChannelTime(self)
end

function imba_tinker_rearm:GetCooldown( nLevel )
	if self:GetCaster():HasTalent("special_bonus_imba_tinker_8") then
		return self.BaseClass.GetChannelTime(self)
	end
	return 0
end

function imba_tinker_rearm:GetManaCost()
	local extra_cost = (self:GetLevel() - 1) * self:GetSpecialValueFor("rearm_mana_per_lvl")
	return (self:GetSpecialValueFor("base_manacost") + extra_cost - self:GetCaster():FindTalentValue("special_bonus_imba_tinker_1"))
end

function imba_tinker_rearm:GetCastAnimation()
	return ACT_DOTA_TINKER_REARM1
end

function imba_tinker_rearm:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		-- Play a random cast line
		if caster:GetName() == "npc_dota_hero_tinker" then
			caster:EmitSound("tinker_tink_ability_rearm_0"..math.random(1,9))
		end

		if caster:HasTalent("special_bonus_imba_tinker_8") then
			caster:AddNewModifier(caster, self, "modifier_imba_rearm_animation", { duration = 0.1})
		else
			caster:AddNewModifier(caster, self, "modifier_imba_rearm_animation", { duration = self:GetChannelTime()})
		end
		if caster:HasTalent("special_bonus_imba_tinker_8") then
			self:OnChannelFinish( false )
		end
		-- #6 Talent - Shield
		if caster:HasTalent("special_bonus_imba_tinker_6") then
			caster:AddNewModifier(caster, self, "modifier_imba_rearm_shield", { duration = 3.5 })
		end
	end
end

function imba_tinker_rearm:OnChannelFinish( bInterrupted )
	if IsServer() then
		local caster = self:GetCaster()
		if not bInterrupted then
			-- List of unrefreshable items
			local forbidden_items = 
			{
				"item_aeon_disk",
				"item_imba_arcane_boots",
				"item_black_king_bar",
				"item_imba_bloodstone",
				"item_imba_guardian_greaves",
				"item_imba_hand_of_midas",
				"item_imba_mekansm",
				"item_meteor_hammer",
				"item_imba_necronomicon",
				"item_imba_necronomicon_2",
				"item_imba_necronomicon_3",
				"item_imba_necronomicon_4",
				"item_imba_necronomicon_5",
				"item_imba_pipe",
				"item_refresher",
				"item_refresher_shard",
				"item_imba_skadi",
				"item_sphere",
				"item_imba_plancks_artifact",
				"item_imba_white_queen_cape",
			}

			for i = 0, caster:GetAbilityCount() do
				local current_ability = caster:GetAbilityByIndex(i)

				-- Refresh
				if current_ability then
					current_ability:EndCooldown()
				end
			end

			-- Refresh items
			for i = 0, 5 do
				local current_item = caster:GetItemInSlot(i)
				local should_refresh = true

				-- If this item is forbidden, do not refresh it
				for _,forbidden_item in pairs(forbidden_items) do
					if current_item and current_item:GetName() == forbidden_item then
						should_refresh = false
					end
				end

				-- Refresh
				if current_item and should_refresh then
					current_item:EndCooldown()
				end
			end
		end
		caster:FadeGesture(ACT_DOTA_TINKER_REARM1)
		caster:FadeGesture(ACT_DOTA_TINKER_REARM3)
		caster:RemoveModifierByName("modifier_imba_rearm_animation")
	end
end

modifier_imba_rearm_animation = class({})
function modifier_imba_rearm_animation:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local level = self:GetAbility():GetLevel()
		
		---------------------------------------------------------------------------------------------
		-- Valve made a shitty animation logic on Rearm, so each channel-time needs proper adjustment
		---------------------------------------------------------------------------------------------
		caster:EmitSound("Hero_Tinker.Rearm")
		local cast_main_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_main_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_main_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		local cast_pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_b.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		local cast_pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_b.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
		local cast_sparkle_pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_c.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_sparkle_pfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		local cast_sparkle_pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm_c.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_sparkle_pfx2, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
		local animation_reset = 0
		if not caster:HasTalent("special_bonus_imba_tinker_8") then
			if level == 1 or level == 2 then
				caster:StartGesture(ACT_DOTA_TINKER_REARM1)
			elseif level == 3 or level == 4 then
				caster:StartGesture(ACT_DOTA_TINKER_REARM2)
			elseif level == 5 then
				caster:StartGestureWithPlaybackRate(ACT_DOTA_TINKER_REARM3, 0.9)
			elseif level == 6 then
				caster:StartGestureWithPlaybackRate(ACT_DOTA_TINKER_REARM3, 1.2)
			elseif level == 7 then
				caster:StartGestureWithPlaybackRate(ACT_DOTA_TINKER_REARM3, 1.9)
			end
		end
		Timers:CreateTimer(FrameTime(), function()
			if caster:HasModifier("modifier_imba_rearm_animation") and not caster:HasTalent("special_bonus_imba_tinker_8") then
				animation_reset = animation_reset + 1
				if (level == 1 and animation_reset == 60) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM1)
					caster:StartGesture(ACT_DOTA_TINKER_REARM3)
				elseif (level == 2 and animation_reset == 45) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM1)
					caster:StartGesture(ACT_DOTA_TINKER_REARM3)
				elseif (level == 3 and animation_reset == 23) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM2)
					caster:StartGestureWithPlaybackRate(ACT_DOTA_TINKER_REARM3, 0.9)
				elseif (level == 4 and animation_reset == 20) then
					caster:FadeGesture(ACT_DOTA_TINKER_REARM2)
					caster:StartGesture(ACT_DOTA_TINKER_REARM3)
				end
				return FrameTime()
			else
				ParticleManager:DestroyParticle(cast_main_pfx, false)
				ParticleManager:DestroyParticle(cast_pfx1, false)
				ParticleManager:DestroyParticle(cast_pfx2, false)
				ParticleManager:DestroyParticle(cast_sparkle_pfx1, false)
				ParticleManager:DestroyParticle(cast_sparkle_pfx2, false)
				ParticleManager:ReleaseParticleIndex(cast_main_pfx)
				ParticleManager:ReleaseParticleIndex(cast_pfx1)
				ParticleManager:ReleaseParticleIndex(cast_pfx2)
				ParticleManager:ReleaseParticleIndex(cast_sparkle_pfx1)
				ParticleManager:ReleaseParticleIndex(cast_sparkle_pfx2)
				return nil
			end
		end)
	end
end

function modifier_imba_rearm_animation:GetEffectName()
	return "particles/units/heroes/hero_tinker/tinker_rearm.vpcf"
end

function modifier_imba_rearm_animation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_imba_rearm_overdrive = class({})
function modifier_imba_rearm_overdrive:IsHidden()
	if self:GetParent():HasScepter() then return false end
	return true
end

function modifier_imba_rearm_overdrive:IsDebuff()
	return false
end

function modifier_imba_rearm_overdrive:IsPurgable()
	return false
end

function modifier_imba_rearm_overdrive:OnCreated()
	local ability = self:GetAbility()
	self.aghs_spellpower = ability:GetSpecialValueFor("aghs_spellpower")
	self.aghs_interval_pct = ability:GetSpecialValueFor("aghs_interval_pct")
	self:StartIntervalThink(0.2)
end

function modifier_imba_rearm_overdrive:OnIntervalThink()
	local parent = self:GetParent()
	self:IsHidden()
	if parent:HasScepter() then
		self:SetStackCount(math.ceil((1 - (parent:GetMana() / parent:GetMaxMana())) * (100/self.aghs_interval_pct)))
	else
		self:SetStackCount(0)
	end
end

function modifier_imba_rearm_overdrive:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_imba_rearm_overdrive:GetModifierSpellAmplify_Percentage()
	return (self.aghs_spellpower * self:GetStackCount())
end

modifier_imba_rearm_shield = class({})
function modifier_imba_rearm_shield:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return decFuncs
end

function modifier_imba_rearm_shield:IsHidden()
	return false
end

function modifier_imba_rearm_shield:IsDebuff()
	return false
end

function modifier_imba_rearm_shield:IsPurgable()
	return true
end

function modifier_imba_rearm_shield:GetEffectName()
	return "particles/hero/tinker/rearmshield_shield.vpcf"
end

function modifier_imba_rearm_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_rearm_shield:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		self.current_health = self:GetParent():GetHealth()
		self.shield_hp = caster:GetMaxHealth() * (caster:FindTalentValue("special_bonus_imba_tinker_6") / 100)
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_rearm_shield:OnRefresh()
	if IsServer() then
		local caster = self:GetCaster()
		self.shield_hp = caster:GetMaxHealth() * (caster:FindTalentValue("special_bonus_imba_tinker_6") / 100)
	end
end

function modifier_imba_rearm_shield:OnIntervalThink()
	-- Get current health per frame
	self.current_health = self:GetParent():GetHealth()
end

function modifier_imba_rearm_shield:OnTakeDamage( params )
	if IsServer() then
		local parent = self:GetParent()
		
		if parent == params.unit then
			if params.damage > 0 then
				if params.damage >= self.shield_hp then
					self:Destroy()
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, parent, self.shield_hp, nil)
					parent:SetHealth(self.current_health - params.damage + self.shield_hp)
				else
					self.shield_hp = self.shield_hp - params.damage
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, parent, params.damage, nil)
					parent:SetHealth(self.current_health)
				end
			end
		end
	end
end

-------------------------------------------
--			   LASER
-------------------------------------------
LinkLuaModifier("modifier_imba_laser_blind", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
imba_tinker_laser = class({})

function imba_tinker_laser:GetAbilityTextureName()
   return "tinker_laser"
end

function imba_tinker_laser:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local technomancy_ability_name = "imba_tinker_technomancy"
		
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
		
		if RollPercentage(15) and (caster:GetName() == "npc_dota_hero_tinker") then
			caster:EmitSound("tinker_tink_ability_laser_0"..math.random(1,4))
		end

		caster:EmitSound("Hero_Tinker.Laser")

		-- initalize tables		
		self.cast_table = {}		

		-- Create initial laser
		local start_pos = caster:GetAbsOrigin()
		local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()		
		self:CreateLaser(start_pos, direction)

		-- Technomancy laser upgrades
		local technomancy_ability
		if caster:HasAbility(technomancy_ability_name) then
			technomancy_ability = caster:FindAbilityByName(technomancy_ability_name)			
		end

		if technomancy_ability and technomancy_ability:GetLevel() > 0 then
			-- Technomancy specials
			local vertical_laser_distance = technomancy_ability:GetSpecialValueFor("vertical_laser_distance")
			local diagonal_laser_distance = technomancy_ability:GetSpecialValueFor("diagonal_laser_distance")
			local vertical_lasers = technomancy_ability:GetSpecialValueFor("vertical_lasers")
			local diagonal_lasers = technomancy_ability:GetSpecialValueFor("diagonal_lasers")
			local vertical_laser_delay = technomancy_ability:GetSpecialValueFor("vertical_laser_delay")
			local diagonal_laser_delay = technomancy_ability:GetSpecialValueFor("diagonal_laser_delay")
			local vertical_laser_angle = technomancy_ability:GetSpecialValueFor("vertical_laser_angle")
			local diagonal_laser_angle = technomancy_ability:GetSpecialValueFor("diagonal_laser_angle")

			-- Vertical lasers!
			if vertical_lasers > 0 then
				Timers:CreateTimer(vertical_laser_delay, function()
					for i = 1, vertical_lasers do
						local qangle_vertical_left = QAngle(0, vertical_laser_angle, 0)
						local qangle_vertical_right = QAngle(0, -vertical_laser_angle, 0)								
						local target_caster_direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
						
						-- Define start point of the laser
						local laser_start_point = target:GetAbsOrigin() + target_caster_direction * vertical_laser_distance
						if (i+1) % 2 == 0 then --to the left							
							laser_start_point = RotatePosition(target:GetAbsOrigin(),qangle_vertical_left,laser_start_point)						
						else --to the right
							laser_start_point = RotatePosition(target:GetAbsOrigin(),qangle_vertical_right,laser_start_point)
						end

						-- Define direction of the laser (towards the target)
						local vertical_direction = (target:GetAbsOrigin() - laser_start_point):Normalized()						

						self:CreateLaser(laser_start_point, vertical_direction)
					end
				end)
			end

			-- Diagonal lasers!
			if diagonal_lasers > 0 then
				Timers:CreateTimer(diagonal_laser_delay, function()
					for i = 1, vertical_lasers do
						local qangle_diagonal_left = QAngle(0, diagonal_laser_angle, 0)
						local qangle_diagonal_right = QAngle(0, -diagonal_laser_angle, 0)								
						local target_caster_direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
						
						-- Define start point of the laser
						local laser_start_point = target:GetAbsOrigin() + target_caster_direction * 350
						if (i+1) % 2 == 0 then --to the left							
							laser_start_point = RotatePosition(target:GetAbsOrigin(),qangle_diagonal_left,laser_start_point)						
						else --to the right
							laser_start_point = RotatePosition(target:GetAbsOrigin(),qangle_diagonal_right,laser_start_point)
						end

						-- Define direction of the laser (towards the target)
						local diagonal_direction = (target:GetAbsOrigin() - laser_start_point):Normalized()						

						self:CreateLaser(laser_start_point, diagonal_direction)
					end
				end)
			end
		end
	end
end

function imba_tinker_laser:CreateLaser(start_pos, laser_direction)
	if IsServer() then		
		local caster = self:GetCaster()		
		
		local travel_speed = self:GetSpecialValueFor("travel_speed")
		local radius = self:GetSpecialValueFor("radius")
		local distance = self:GetCastRange(caster:GetAbsOrigin(),caster) + GetCastRangeIncrease(caster) 		

		-- Create the particle index
		local laser_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, caster)	
		
		-- Create Laser Projectile
		local laser_projectile = 
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_tinker/tinker_laser.vpcf",
				Source 				= caster,
				vSpawnOrigin		= start_pos,
				fDistance			= distance,
				fStartRadius		= radius,
				fEndRadius			= radius,				
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(laser_direction.x,laser_direction.y,0) * travel_speed,
				bProvidesVision		= false,
				ExtraData			= {source_loc_x = start_pos.x, source_loc_y = start_pos.y, source_loc_z = start_pos.z, particle_index = laser_pfx, distance = distance}
			}
			
		ProjectileManager:CreateLinearProjectile(laser_projectile)
	end
end

function imba_tinker_laser:OnProjectileThink_ExtraData(location, extradata)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self		
		local start_pos = Vector(extradata.source_loc_x, extradata.source_loc_y, extradata.source_loc_z)
		local laser_pfx = extradata.particle_index
		local distance = extradata.distance

		-- Particle 
		ParticleManager:SetParticleControl(laser_pfx, 0, start_pos)
		ParticleManager:SetParticleControl(laser_pfx, 1, location)
		ParticleManager:SetParticleControl(laser_pfx, 3, start_pos)
		ParticleManager:SetParticleControl(laser_pfx, 9, start_pos)

		-- If the projectile is far enough, release its particle effect.		
		local projectile_distance = (location - start_pos):Length2D()
		if projectile_distance > (distance - 50) then
			ParticleManager:ReleaseParticleIndex(laser_pfx)
		end
	end
end

function imba_tinker_laser:OnProjectileHit(target, location)
	if IsServer() then		
		if not target then
			return nil
		end

		local caster = self:GetCaster()

		target:EmitSound("Hero_Tinker.LaserImpact")
			
		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local damage_type = self:GetAbilityDamageType()
		local secondary_reduction = self:GetSpecialValueFor("secondary_reduction")
		local blind_duration = self:GetSpecialValueFor("blind_duration")		
		
		-- If the target is hit by the laser once, reduce the damage property
		if self.cast_table[target] then			
			ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage * secondary_reduction * 0.01, damage_type = damage_type})
			target:AddNewModifier(caster, self, "modifier_imba_laser_blind", { duration = blind_duration })					
		else
			-- Damage & blind
			ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = damage_type})
			target:AddNewModifier(caster, self, "modifier_imba_laser_blind", { duration = blind_duration })	
			self.cast_table[target] = true
		end
	end
end
	

function imba_tinker_laser:IsNetherWardStealable()
	return true
end

function imba_tinker_laser:GetAssociatedSecondaryAbilities()
	return "imba_tinker_technomancy"
end

function imba_tinker_laser:IsStealable()
	return true
end

function imba_tinker_laser:IsHiddenWhenStolen()
	return false
end

modifier_imba_laser_blind = class({})

function modifier_imba_laser_blind:IsHidden() return false end
function modifier_imba_laser_blind:IsPurgable() return true end
function modifier_imba_laser_blind:IsDebuff() return true end

function modifier_imba_laser_blind:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss_chance_pct")
end

function modifier_imba_laser_blind:DeclareFunctions()
	local decFuncs = 
	{	
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
	return decFuncs	
end

function modifier_imba_laser_blind:GetEffectName()
	return "particles/ambient/tower_laser_blind.vpcf"
end

function modifier_imba_laser_blind:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-------------------------------------------
--		HEAT-SEEKING MISSILES
-------------------------------------------
LinkLuaModifier("modifier_imba_heat_seeking_missile_break", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
imba_tinker_heat_seeking_missile = class({})

function imba_tinker_heat_seeking_missile:GetAbilityTextureName()
   return "tinker_heat_seeking_missile"
end

function imba_tinker_heat_seeking_missile:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		
		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local missile_count = self:GetTalentSpecialValueFor("base_count")
		local vision_radius = self:GetSpecialValueFor("vision_radius")
		local vision_duration = self:GetTalentSpecialValueFor("vision_duration")
		local speed = self:GetSpecialValueFor("speed")
		local range = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local mini_damage = self:GetSpecialValueFor("mini_damage")
		local mini_vision_duration = self:GetTalentSpecialValueFor("mini_vision_duration")
		local mini_speed = self:GetSpecialValueFor("mini_speed")
		local mini_missile_count = self:GetSpecialValueFor("mini_missile_count")
		
		if (math.random(1,100) <= 50) and (caster:GetName() == "npc_dota_hero_tinker") then
			caster:EmitSound("tinker_tink_ability_heatseekingmissile_0"..math.random(1,4))
		end
		
		caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
		
		-- Find valid targets
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		-- If no valid units are found, dud
		if #heroes == 0 and #units == 0 then
			local dud_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControlEnt(dud_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster_loc, true)
			ParticleManager:ReleaseParticleIndex(dud_pfx)
			caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")
			return nil
		end
		
		-- Else, shoot missiles at heroes
		local hero_missiles = math.min(#heroes, missile_count)
		for i = 1, hero_missiles do
			local hero_projectile = 
			{
				Target 				= heroes[i],
				Source 				= caster,
				Ability 			= self,
				EffectName 			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
				bDodgeable 			= true,
				bProvidesVision 	= false,
				iMoveSpeed 			= speed,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
				iSourceAttachment	= caster:ScriptLookupAttachment("attach_attack3"),
				ExtraData			= {damage = damage, vision_radius = vision_radius, vision_duration = vision_duration, range = range, speed = speed, mini_damage = mini_damage, mini_vision_duration = mini_vision_duration, mini_speed = mini_speed, mini_missile_count = mini_missile_count, cast_origin_x = caster_loc.x, cast_origin_y = caster_loc.y}
			}
			ProjectileManager:CreateTrackingProjectile(hero_projectile)
		end

		-- Shoot the remaining missiles at random units in range
		missile_count = missile_count - hero_missiles
		if #units > 0 then
			for i = 1, missile_count do
				local random_projectile = 
				{
					Target				= units[i],
					Source 				= caster,
					Ability 			= self,
					EffectName			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
					bDodgeable 			= true,
					bProvidesVision 	= false,
					iMoveSpeed 			= speed,
				--	iVisionRadius = vision_radius,
				--	iVisionTeamNumber = caster:GetTeamNumber(),
					iSourceAttachment 	= caster:ScriptLookupAttachment("attach_attack3"),
					ExtraData			= {damage = damage, vision_radius = vision_radius, vision_duration = vision_duration, range = range, speed = speed, mini_damage = mini_damage, mini_vision_duration = mini_vision_duration, mini_speed = mini_speed, mini_missile_count = mini_missile_count, cast_origin_x = caster_loc.x, cast_origin_y = caster_loc.y, is_main_missile = 1}
				}
				ProjectileManager:CreateTrackingProjectile(random_projectile)
			end
		end
	end
end

function imba_tinker_heat_seeking_missile:OnProjectileThink_ExtraData(location, ExtraData)
	local caster = self:GetCaster()

	if ExtraData.mini_missile_count and ExtraData.mini_missile_count > 0 then
	local distance = (location - Vector(ExtraData.cast_origin_x, ExtraData.cast_origin_y, 0)):Length2D()
	local interval = math.floor(ExtraData.speed)
	
	local technomancy
	if caster:HasAbility("imba_tinker_technomancy") then
		 technomancy = caster:FindAbilityByName("imba_tinker_technomancy")
	end
	if technomancy and technomancy:GetLevel() >= 2 then
	interval = math.floor(interval * (1 - technomancy:GetSpecialValueFor("interval_reduction")))
	end
	
	-- Spawn once every second, determines whether the missile has travelled for a second by it's distance
	if (math.mod(math.floor(distance),interval)) < math.floor(interval * FrameTime()) and (math.floor(distance - interval * FrameTime())) > math.floor(interval * FrameTime()) then		
		
		-- Find valid targets
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ExtraData.range, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local units = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ExtraData.range, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		-- If no valid units are found, dududududu
		if #heroes == 0 and #units == 0 then
			local dud_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControlEnt(dud_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster_loc, true)
			ParticleManager:ReleaseParticleIndex(dud_pfx)
			caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")
			return nil
		end
		
		-- Else, shoot missiles at heroes
		local hero_missiles = math.min(#heroes, ExtraData.mini_missile_count)
		for i = 1, hero_missiles do
			local hero_projectile = 
			{
				Target 				= heroes[i],
				--Source 				= caster,
				vSourceLoc			= location,
				Ability 			= self,
				EffectName 			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
				bDodgeable 			= true,
				bProvidesVision 	= false,
				bReplaceExisting	= false,
				iMoveSpeed 			= ExtraData.mini_speed,
				ExtraData			= {damage = ExtraData.mini_damage, vision_radius = ExtraData.vision_radius, vision_duration = ExtraData.mini_vision_duration, is_mini_missile = 1}
			}
			ProjectileManager:CreateTrackingProjectile(hero_projectile)
		end

		-- Shoot the remaining missiles at random units in range
		local remaining_missiles = ExtraData.mini_missile_count
		remaining_missiles = remaining_missiles - hero_missiles
		if #units > 0 then
			for i = 1,remaining_missiles do
				local random_projectile = 
				{
					Target				= units[i],
					--Source 				= caster,
					vSourceLoc			= location,
					Ability 			= self,
					EffectName			= "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
					bDodgeable 			= true,
					bProvidesVision 	= false,
					bReplaceExisting	= false,
					iMoveSpeed 			= ExtraData.mini_speed,
					ExtraData			= {damage = ExtraData.mini_damage, vision_radius = ExtraData.vision_radius, vision_duration = ExtraData.mini_vision_duration, is_mini_missile = 1}
				}
				ProjectileManager:CreateTrackingProjectile(random_projectile)
			end
		end
	end
	end
end

function imba_tinker_heat_seeking_missile:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	if target then
		-- Get Technomancy
		local technomancy
		if caster:HasAbility("imba_tinker_technomancy") then
			technomancy = caster:FindAbilityByName("imba_tinker_technomancy")
		end
		
		-- Technomancy level 3, mini missiles now apply an explosive warhead, aimed at breaking defences
		if technomancy and technomancy:GetLevel() >= 3 and ExtraData.is_mini_missile == 1 then
			
			-- Particle & Sound
			local particle_explosion_fx = ParticleManager:CreateParticle("particles/hero/tinker/tinker_mini_missile_explosive_warhead.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle_explosion_fx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_explosion_fx, 1, location)
			ParticleManager:SetParticleControl(particle_explosion_fx, 3, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_explosion_fx)
			
			EmitSoundOn("Hero_Techies.LandMine.Detonate", target)

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, technomancy:GetSpecialValueFor("missile_aoe"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs (enemies) do
				-- Find the defence break modifier
				local modifier_defence_break = enemy:FindModifierByName("modifier_imba_heat_seeking_missile_break")
				-- If the target already has the debuff, refresh it
				if modifier_defence_break then
				modifier_defence_break:ForceRefresh()
				else
				-- Else, create the debuff and refresh it
				modifier_defence_break = enemy:AddNewModifier(caster,self,"modifier_imba_heat_seeking_missile_break",{duration = ExtraData.vision_duration})
				modifier_defence_break:ForceRefresh()
				end
			end
		end
		
		-- Technomancy level 2, apply main explosive damage on each main missile
		if technomancy and technomancy:GetLevel() >= 2 and ExtraData.is_main_missile == 1 then
			
			-- Particle & Sound
			local particle_explosion_fx = ParticleManager:CreateParticle("particles/hero/tinker/tinker_missile_explosive_warhead.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_explosion_fx, 1, location)
			ParticleManager:SetParticleControl(particle_explosion_fx, 3, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle_explosion_fx)
			
			EmitSoundOn("Hero_Techies.RemoteMine.Detonate", target)

			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, technomancy:GetSpecialValueFor("missile_aoe"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in pairs (enemies) do
				
				-- Get the damage parameters
				local explosion_damage = technomancy:GetSpecialValueFor("explosion_damage")
				local explosion_damage_main = technomancy:GetSpecialValueFor("explosion_damage_main")
				
				-- Get the missile break modifier
				local modifier_defence_break = enemy:FindModifierByName("modifier_imba_heat_seeking_missile_break")
				-- If the target is break by a missile, amplify the damage
				if modifier_defence_break then
				explosion_damage = explosion_damage * (1+modifier_defence_break:GetStackCount()*technomancy:GetSpecialValueFor("mini_break_extra_dmg")*0.01)
				explosion_damage_main = explosion_damage_main * (1+modifier_defence_break:GetStackCount()*technomancy:GetSpecialValueFor("mini_break_extra_dmg")*0.01)
				end
				
				-- If it's the main target, apply double damage
				if enemy == target then
				ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = explosion_damage_main, damage_type = self:GetAbilityDamageType()})
				-- Else apply normal damage
				else
				ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = explosion_damage, damage_type = self:GetAbilityDamageType()})
				end
			end
		end
		
		local missile_damage = ExtraData.damage
		
		-- Get the missile break modifier
		local modifier_defence_break = target:FindModifierByName("modifier_imba_heat_seeking_missile_break")

		-- If the target is break by a missile, amplify the damage
		if modifier_defence_break then
			missile_damage = missile_damage * (1 + modifier_defence_break:GetStackCount()* technomancy:GetSpecialValueFor("mini_break_extra_dmg")* 0.01)
		end
				
		ApplyDamage({attacker = caster, victim = target, ability = self, damage = missile_damage, damage_type = self:GetAbilityDamageType()})
		local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(explosion_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", location, true)
		ParticleManager:ReleaseParticleIndex(explosion_pfx)
		target:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
	end
	self:CreateVisibilityNode( location, ExtraData.vision_radius, ExtraData.vision_duration )
end

function imba_tinker_heat_seeking_missile:IsNetherWardStealable()
	return true
end

function imba_tinker_heat_seeking_missile:GetAssociatedSecondaryAbilities()
	return "imba_tinker_technomancy"
end

function imba_tinker_heat_seeking_missile:IsStealable()
	return true
end

function imba_tinker_heat_seeking_missile:IsHiddenWhenStolen()
	return false
end

modifier_imba_heat_seeking_missile_break = class ({})

function modifier_imba_heat_seeking_missile_break:IsHidden()
	return false
end

function modifier_imba_heat_seeking_missile_break:IsDebuff()
	return true
end

function modifier_imba_heat_seeking_missile_break:IsPurgable()
	return true
end

function modifier_imba_heat_seeking_missile_break:OnRefresh()
	if IsServer() then
	local ability = self:GetCaster():FindAbilityByName("imba_tinker_heat_seeking_missile")
	
		if ability then
		self:SetDuration(ability:GetSpecialValueFor("mini_vision_duration"),true)
		self:IncrementStackCount()
		end
	end
end

function modifier_imba_heat_seeking_missile_break:GetEffectName()
	return "particles/items2_fx/medallion_of_courage_b.vpcf"
end

function modifier_imba_heat_seeking_missile_break:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-------------------------------------------
--		MARCH OF THE MACHINES
-------------------------------------------
LinkLuaModifier("modifier_imba_march_flame_aura", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_march_flame_damage", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_march_tesla_stun", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_march_sticky_root", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_march_dismantle", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_march_drone", "components/abilities/heroes/hero_tinker", LUA_MODIFIER_MOTION_NONE)

imba_tinker_march_of_the_machines = class({})

function imba_tinker_march_of_the_machines:GetAbilityTextureName()
   return "tinker_march_of_the_machines"
end

function imba_tinker_march_of_the_machines:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()
		local direction = (target_loc - caster_loc):Normalized()
		local ability = self
		
		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local collision_radius = self:GetSpecialValueFor("collision_radius")
		local explosion_radius = self:GetSpecialValueFor("explosion_radius")
		local spawn_radius = self:GetSpecialValueFor("spawn_radius")
		local travel_distance = self:GetSpecialValueFor("travel_distance")
		local robots_per_sec = self:GetSpecialValueFor("robots_per_sec")
		local touch_chance_pct = self:GetTalentSpecialValueFor("touch_chance_pct")
		local flame_radius = self:GetSpecialValueFor("flame_radius")
		local flame_duration = self:GetSpecialValueFor("flame_duration")
		local tesla_stun_duration = self:GetSpecialValueFor("tesla_stun_duration")
		local dismantle_duration = self:GetSpecialValueFor("dismantle_duration")
		local railgun_damage = self:GetSpecialValueFor("railgun_damage")
		local railgun_range = self:GetSpecialValueFor("railgun_range")
		local railgun_radius = self:GetSpecialValueFor("railgun_radius")
		local sticky_duration = self:GetSpecialValueFor("sticky_duration")
		local drone_duration = self:GetSpecialValueFor("drone_duration")
		local speed = self:GetSpecialValueFor("speed")
		local spawn_duration = self:GetSpecialValueFor("spawn_duration")
		local spawn_line_direction = RotateVector2D(direction,90,true)
		
		-- #4 Talent - Increased speed and range
		speed = speed * (1 + (caster:FindTalentValue("special_bonus_imba_tinker_3") / 100))
		travel_distance = travel_distance * (1 + (caster:FindTalentValue("special_bonus_imba_tinker_3") / 100))
		
		-- Level-Unlocks
		local unlock_flame = false
		local unlock_tesla = false
		local unlock_dismantle = false
		local unlock_railgun = false
		local unlock_sticky = false
		local unlock_drone = false
		
		if self:GetLevel() >= 1 then unlock_flame = true end
		if self:GetLevel() >= 5 then unlock_tesla = true end
		if self:GetLevel() >= 6 then unlock_dismantle = true end
		if self:GetLevel() >= 7 then unlock_railgun = true end
		
		-- Technomancy handling
		if caster:HasAbility("imba_tinker_technomancy") then
			local technomancy = caster:FindAbilityByName("imba_tinker_technomancy")
			if technomancy:GetLevel() >= 3 then unlock_sticky = true end
			if technomancy:GetLevel() >= 6 then unlock_drone = true end
		end
		
		if (math.random(1,100) <= 80) and (caster:GetName() == "npc_dota_hero_tinker") then
			local sound_random = math.random(1,11)
			if sound_random <= 9 then
				caster:EmitSound("tinker_tink_ability_marchofthemachines_0"..sound_random)
			else
				caster:EmitSound("tinker_tink_ability_marchofthemachines_"..sound_random)
			end
		end
		
		
		caster:EmitSound("Hero_Tinker.March_of_the_Machines.Cast")
		caster:EmitSound("Hero_Tinker.March_of_the_Machines")
		
		local area_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_motm.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(area_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster_loc, true)
		ParticleManager:SetParticleControl(area_pfx, 1, caster_loc)
		ParticleManager:SetParticleControlForward(area_pfx, 1, direction)
		ParticleManager:ReleaseParticleIndex(area_pfx)
		
		for i=0, spawn_duration * robots_per_sec, 1 do
			Timers:CreateTimer(i*(1/robots_per_sec), function()
				local position_ran = (math.random() - 0.5) * travel_distance
				local projectile
				local bot_random = math.random(1,100)
				-- Flaming bot
				if (bot_random <= touch_chance_pct) and unlock_flame then
					local index = "projectile_" .. DoUniqueString("projectile")
					self[index] = {}
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_flame.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {index = index, damage = damage, explosion_radius = explosion_radius, flame_radius = flame_radius, flame_duration = flame_duration})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {index = index, damage = damage, explosion_radius = explosion_radius, flame_radius = flame_radius, flame_duration = flame_duration})
					  end,
					}
				-- Tesla bot
				elseif ((bot_random <= (2 * touch_chance_pct)) and (bot_random > (touch_chance_pct))) and unlock_tesla then
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_tesla.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, tesla_stun_duration = tesla_stun_duration})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, tesla_stun_duration = tesla_stun_duration})
					  end,
					}
				-- Drone bot
				elseif ((bot_random <= (3 * touch_chance_pct)) and (bot_random > (2 * touch_chance_pct))) and unlock_drone then
					local index = "projectile_" .. DoUniqueString("projectile")
					self[index] = {}
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_drone.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, drone_duration = drone_duration})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, drone_duration = drone_duration})
					  end,
					}
				-- Sticky bot
				elseif ((bot_random <= (4 * touch_chance_pct)) and (bot_random > (3 * touch_chance_pct))) and unlock_sticky then
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_sticky.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, sticky_duration = sticky_duration})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, sticky_duration = sticky_duration})
					  end,
					}
				-- Dismantle bot
				elseif ((bot_random <= (5 * touch_chance_pct)) and (bot_random > (4 * touch_chance_pct))) and unlock_dismantle then
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_dismantle.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, dismantle_duration = dismantle_duration})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {damage = damage, explosion_radius = explosion_radius, dismantle_duration = dismantle_duration})
					  end,
					}
				-- Railgun bot
				elseif ((bot_random <= (6 * touch_chance_pct)) and (bot_random > (5 * touch_chance_pct))) and unlock_railgun then
					local index = "projectile_" .. DoUniqueString("projectile")
					self[index] = {}
					projectile = {
					  EffectName = "particles/hero/tinker/tinker_march_railgun.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) 
					    ability:OnProjectileThink_ExtraData(projectile:GetPosition(), {index = index, damage = damage, explosion_radius = explosion_radius, railgun_damage = railgun_damage, railgun_range = railgun_range, railgun_radius = railgun_radius, direction_x = direction.x, direction_y = direction.y})
					  end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, projectile:GetPosition(), {index = index, damage = damage, explosion_radius = explosion_radius, railgun_damage = railgun_damage, railgun_range = railgun_range, railgun_radius = railgun_radius, direction_x = direction.x, direction_y = direction.y})
					  end,
					}
				else
					projectile = {
					  EffectName = "particles/units/heroes/hero_tinker/tinker_machine.vpcf",
					  vSpawnOrigin = target_loc - (direction * spawn_radius) + (spawn_line_direction * position_ran),
					  fDistance = travel_distance,
					  fStartRadius = collision_radius,
					  fEndRadius = collision_radius,
					  Source = caster,
					  fExpireTime = GameRules:GetGameTime() + 10.0,
					  vVelocity = Vector(direction.x,direction.y,0) * speed,
					  UnitBehavior = PROJECTILES_DESTROY,
					  bMultipleHits = false,
					  bIgnoreSource = true,
					  TreeBehavior = PROJECTILES_NOTHING,
					  bCutTrees = false,
					  bTreeFullCollision = false,
					  WallBehavior = PROJECTILES_NOTHING,
					  GroundBehavior = PROJECTILES_NOTHING,
					  fGroundOffset = 80,
					  nChangeMax = 1,
					  bRecreateOnChange = false,
					  bDestroyImmediate = false,
					  bZCheck = false,
					  bGroundLock = true,
					  bProvidesVision = false,
					  OnThink = function(self) end,
					  UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() end,
					  OnUnitHit = function(self, unit) 
						ability:OnProjectileHit_ExtraData(unit, self:GetPosition(), {damage = damage, explosion_radius = explosion_radius})
					  end,
					}
				end
				Projectiles:CreateProjectile(projectile)
			end)
		end
	end
end

function imba_tinker_march_of_the_machines:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	
	if self[ExtraData.index] then
		self[ExtraData.index] = nil
	end
	
	-- Railgun-bot handling
	if target then
		if ExtraData.raildamage then
			if target then
				ApplyDamage({attacker = caster, victim = target, ability = self, damage = ExtraData.raildamage, damage_type = self:GetAbilityDamageType()})
				return false
			end
		else
			-- Deal damage
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ExtraData.explosion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,enemy in ipairs(enemies) do
				ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
				-- Tesla-bot handling
				if ExtraData.tesla_stun_duration then
					enemy:AddNewModifier(caster, self, "modifier_imba_march_tesla_stun", {duration = ExtraData.tesla_stun_duration})
				end
				-- Sticky-bot handling
				if ExtraData.sticky_duration then
					enemy:AddNewModifier(caster, self, "modifier_imba_march_sticky_root", {duration = ExtraData.sticky_duration})
				end
				-- Dismantle-bot handling
				if ExtraData.dismantle_duration then
					enemy:AddNewModifier(caster, self, "modifier_imba_march_dismantle", {duration = ExtraData.dismantle_duration})
				end
				-- Drone-bot handling
				if ExtraData.drone_duration then
					enemy:AddNewModifier(caster, self, "modifier_imba_march_drone", {duration = ExtraData.drone_duration})
				end
			end
		end
	end
	return true
end

function imba_tinker_march_of_the_machines:OnProjectileThink_ExtraData(location, ExtraData)
	if IsServer() then
		local caster = self:GetCaster()
		
		-- Flame-bot handling
		if ExtraData.flame_duration then
			self[ExtraData.index].counter = self[ExtraData.index].counter or 0
			if self[ExtraData.index].counter == 0 then
				CreateModifierThinker(caster, self, "modifier_imba_march_flame_aura", {duration = ExtraData.flame_duration, flame_radius = ExtraData.flame_radius}, location, caster:GetTeamNumber(), false)
			end
			self[ExtraData.index].counter = self[ExtraData.index].counter + 1
			-- Do this every 10 frames
			if self[ExtraData.index].counter > 9 then
				self[ExtraData.index].counter = 0
			end
		end
		
		-- Railgun-bot handling
		if ExtraData.railgun_damage then
			self[ExtraData.index].counter = self[ExtraData.index].counter or 0
			if self[ExtraData.index].counter == 0 then
				projectile = 
				{
					Ability				= self,
					EffectName			= "particles/units/heroes/hero_zuus/zuus_arc_lightning_head_c.vpcf",
					vSpawnOrigin		= location,
					fDistance			= ExtraData.railgun_range,
					fStartRadius		= ExtraData.railgun_radius,
					fEndRadius			= ExtraData.railgun_radius,
					Source				= caster,
					bHasFrontalCone		= true,
					bReplaceExisting	= false,
					iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					fExpireTime 		= GameRules:GetGameTime() + 10.0,
					bDeleteOnHit		= false,
					vVelocity			= Vector(ExtraData.direction_x,ExtraData.direction_y,0) * 20000,
					bProvidesVision		= false,
					ExtraData			= {raildamage = ExtraData.railgun_damage}
				}
				ProjectileManager:CreateLinearProjectile(projectile)
				
				if self[ExtraData.index].lightningBolt then
					ParticleManager:ReleaseParticleIndex(self[ExtraData.index].lightningBolt)
					self[ExtraData.index].lightningBolt = nil
				end
				
				self[ExtraData.index].lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(self[ExtraData.index].lightningBolt,0,GetGroundPosition(location, caster))
				ParticleManager:SetParticleControl(self[ExtraData.index].lightningBolt,1,GetGroundPosition(location, caster) + (Vector(ExtraData.direction_x,ExtraData.direction_y,0) * ExtraData.railgun_range))
			end
			ParticleManager:SetParticleControl(self[ExtraData.index].lightningBolt,0,GetGroundPosition(location, caster))
			self[ExtraData.index].counter = self[ExtraData.index].counter + 1
			-- Do this every 30 frames
			if self[ExtraData.index].counter > 29 then
				self[ExtraData.index].counter = 0
			end
		end
	end
end

function imba_tinker_march_of_the_machines:IsNetherWardStealable()
	return true
end

function imba_tinker_march_of_the_machines:GetAssociatedSecondaryAbilities()
	return "imba_tinker_technomancy"
end

function imba_tinker_march_of_the_machines:IsStealable()
	return true
end

function imba_tinker_march_of_the_machines:IsHiddenWhenStolen()
	return false
end

modifier_imba_march_flame_aura = class({})
function modifier_imba_march_flame_aura:OnCreated(params)
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		
		self.radius = params.flame_radius
		
		local fire_fx = ParticleManager:CreateParticle( "particles/hero/tinker/tinker_march_fire_burn.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleAlwaysSimulate(fire_fx)
		ParticleManager:SetParticleControl( fire_fx, 0, parent:GetAbsOrigin() )
		self:AddParticle(fire_fx, false, false, -1, false, false)
	end
end

function modifier_imba_march_flame_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_march_flame_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_march_flame_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_march_flame_aura:IsAura()
	return true
end

function modifier_imba_march_flame_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_march_flame_aura:GetModifierAura()
	return "modifier_imba_march_flame_damage"
end

modifier_imba_march_flame_damage = class({})

function modifier_imba_march_flame_damage:IsDebuff()
	return true
end

function modifier_imba_march_flame_damage:OnCreated()
	if IsServer() then
		self.damage_interval = 0.5
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_march_flame_damage:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local flame_dmg_sec = ability:GetSpecialValueFor("flame_dmg_sec")
		ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = ability, damage = flame_dmg_sec * self.damage_interval, damage_type = ability:GetAbilityDamageType()})
	end
end

function modifier_imba_march_flame_damage:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_firefly_debuff.vpcf"
end

function modifier_imba_march_flame_damage:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_march_flame_damage:IsHidden()
	return true
end

modifier_imba_march_tesla_stun = class({})
function modifier_imba_march_tesla_stun:IsStunDebuff()
	return true
end

function modifier_imba_march_tesla_stun:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex_debuff_end.vpcf"
end

function modifier_imba_march_tesla_stun:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_march_tesla_stun:OnCreated()
	if IsServer() then
		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx,false,false,-1,false,false)
	end
end

function modifier_imba_march_tesla_stun:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = true
	}
	return state
end

function modifier_imba_march_tesla_stun:IsHidden()
	return true
end

modifier_imba_march_sticky_root = class({})
function modifier_imba_march_sticky_root:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf"
end

function modifier_imba_march_sticky_root:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_march_sticky_root:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true
	}
	return state
end

function modifier_imba_march_sticky_root:IsHidden()
	return true
end

modifier_imba_march_dismantle = class({})
function modifier_imba_march_dismantle:OnCreated(params)
	self.dismantle_dmg_pct = self:GetAbility():GetTalentSpecialValueFor("dismantle_dmg_pct") * (-1)
	self:SetStackCount(1)
end

function modifier_imba_march_dismantle:OnRefresh(params)
	self.dismantle_dmg_pct = self:GetAbility():GetTalentSpecialValueFor("dismantle_dmg_pct") * (-1)
	self:IncrementStackCount()
end

function modifier_imba_march_dismantle:IsDebuff()
	return true
end

function modifier_imba_march_dismantle:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return decFuncs	
end

function modifier_imba_march_dismantle:GetModifierBaseDamageOutgoing_Percentage()
	return self.dismantle_dmg_pct * self:GetStackCount()
end

modifier_imba_march_drone = class({})
function modifier_imba_march_drone:OnCreated(params)
	local drone_order_interval = self:GetAbility():GetSpecialValueFor("drone_order_interval")
	self:StartIntervalThink(drone_order_interval)
end

function modifier_imba_march_drone:IsDebuff()
	return true
end

function modifier_imba_march_drone:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local direction = Vector(math.random(-1000,1000),math.random(-1000,1000),0):Normalized()
		local location = parent:GetAbsOrigin() + (direction * 1000)
		parent:Stop()
		parent:MoveToPosition(location)
	end
end

function modifier_imba_march_drone:CheckState()
    local state = 
	{
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
    return state 
end

-------------------------------------------
--			TECHNOMANCY
-------------------------------------------
imba_tinker_technomancy = class({})

function imba_tinker_technomancy:GetAbilityTextureName()
   return "custom/tinker_tinkermaster"
end

function imba_tinker_technomancy:OnUpgrade()
	local caster = self:GetCaster()
	if caster:HasAbility("imba_tinker_rearm") then
		local ability = caster:FindAbilityByName("imba_tinker_rearm")
		ability:SetLevel((self:GetLevel() + 1))
	end
end

function imba_tinker_technomancy:IsNetherWardStealable()
	return false
end

function imba_tinker_technomancy:IsStealable()
	return true
end

function imba_tinker_technomancy:IsHiddenWhenStolen()
	return true
end
