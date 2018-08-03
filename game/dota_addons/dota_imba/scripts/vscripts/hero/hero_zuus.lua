-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--	   Naowin, 04.07.2018

CreateEmptyTalents("zeus")

--------------------------------------
--			Arc Lightning			--
--------------------------------------
imba_zuus_arc_lightning = class({})
function imba_zuus_arc_lightning:OnSpellStart()
	local caster 			= self:GetCaster()
	local ability 			= self
	local jump_delay 		= ability:GetSpecialValueFor("jump_delay")
	local max_jump_count 	= ability:GetSpecialValueFor("jump_count")
	local radius 			= ability:GetSpecialValueFor("radius")
	local damage 			= ability:GetSpecialValueFor("arc_damage")
	local target 			= self:GetCursorTarget()

	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")

	local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y , caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))

	local nearby_enemy_units = FindUnitsInRadius(
		caster:GetTeam(),
		target:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)

	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 
	damage_table.damage			= damage
	damage_table.victim 		= target
	ApplyDamage(damage_table)

	-- Add to list of targets allrdy hit.
	local hit_list = {}
	hit_list[target] = 1

	Timers:CreateTimer(jump_delay, function() 
		-- Find targets to chain too
		for _,enemy in pairs(nearby_enemy_units) do 
			if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() and target ~= enemy then
				imba_zuus_arc_lightning:Chain(caster, target, enemy, ability, damage, radius, jump_delay, max_jump_count, 0, hit_list)
				-- Abort when we find something to chain too
				break
			end
		end
	end)
end

function imba_zuus_arc_lightning:Chain(caster, origin_target, chained_target, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list)
	if IsServer() then 
		num_jumps_done 			 = num_jumps_done + 1
		if hit_list[chained_target] == nil then
			hit_list[chained_target] = 1	
		else
			hit_list[chained_target] = hit_list[chained_target] + 1
		end

		print("num_jumps_done", num_jumps_done, chained_target, hit_list[chained_target])

		local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, origin_target)
		ParticleManager:SetParticleControl(lightningBolt, 0, Vector(origin_target:GetAbsOrigin().x, origin_target:GetAbsOrigin().y , origin_target:GetAbsOrigin().z + origin_target:GetBoundingMaxs().z ))   
		ParticleManager:SetParticleControl(lightningBolt, 1, Vector(chained_target:GetAbsOrigin().x, chained_target:GetAbsOrigin().y, chained_target:GetAbsOrigin().z + chained_target:GetBoundingMaxs().z ))

		local nearby_enemy_units = FindUnitsInRadius(	
			caster:GetTeam(), 
			chained_target:GetAbsOrigin(), 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_CLOSEST, 
			false
		)

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= damage
		damage_table.victim 		= chained_target
		ApplyDamage(damage_table)

		if num_jumps_done < max_jump_count then
			Timers:CreateTimer(jump_delay, function() 
				local has_chained = false
				-- Find targets to chain too
				for _,enemy in pairs(nearby_enemy_units) do 
					if origin_target ~= enemy and chained_target ~= enemy then
						if imba_zuus_arc_lightning:HitCheck(caster, enemy, hit_list) then 
							imba_zuus_arc_lightning:Chain(caster, chained_target, enemy, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list)
							has_chained = true
						end

						-- Abort when we find something to chain too
						break
					end
				end

				-- If there are no targets left to chain too... but we have not hit max_jump cap...
				if (#nearby_enemy_units == 0 or has_chained == false) then 
					-- Get list of all heroes!
					local heroes = HeroList:GetAllHeroes() 
					local dist_ref = {
						hero = nil,
						distance = 9999999
					}

					-- Check if any of them heroes have a static charge... (and havent been hit yet)
					for _,hero in pairs(heroes) do 
						if hero:HasModifier("modifier_imba_zuus_static_charge") and origin_target ~= hero and chained_target ~= hero then
							if imba_zuus_arc_lightning:HitCheck(caster, hero, hit_list) then 
							-- Get the closest one!
								local distance = (caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D()
								if distance < dist_ref.distance then 
									dist_ref.hero = hero
									dist_ref.distance = distance
								end
							end
						end
					end

					-- Did we find an enemy?
					if dist_ref.hero ~= nil then
						imba_zuus_arc_lightning:Chain(caster, chained_target, dist_ref.hero, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list)
					end
				end
			end)
		end
	end
end

function imba_zuus_arc_lightning:HitCheck(caster, enemy, hit_list)
	if IsServer() then
		if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() then 
			if hit_list[enemy] == nil then
				return true
			end

			if caster:HasTalent("special_bonus_imba_zuus_8") then 
				print(caster:FindTalentValue("special_bonus_imba_zuus_8", "additional_hits"))
				if hit_list[enemy] < caster:FindTalentValue("special_bonus_imba_zuus_8", "additional_hits") then
					return true
				end
			end
		end

		return false
	end
end

function imba_zuus_arc_lightning:GetCastRange()
	local bonus_cast_range = 0
	if self:GetCaster():HasTalent("special_bonus_imba_zuus_2") then 
		bonus_cast_range = self:GetCaster():FindTalentValue("special_bonus_imba_zuus_2", "bonus_cast_range")
	end

	return self:GetSpecialValueFor("cast_range") + bonus_cast_range
end



--------------------------------------
--			Lightning Bolt			--
--------------------------------------
LinkLuaModifier("modifier_imba_zuus_lightning_true_sight", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_zuus_lightning_dummy", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)

imba_zuus_lightning_bolt = class({})

function imba_zuus_lightning_bolt:CastFilterResultTarget( target )
	if IsServer() then
		if target ~= nil and target:IsMagicImmune() and ( not self:GetCaster():HasModifier("modifier_imba_zuus_pierce_spellimmunity") ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_zuus_lightning_bolt:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target 		= self:GetCursorTarget()
		local target_point 	= self:GetCursorPosition()

		caster:EmitSound("Hero_Zuus.LightningBolt")

		local reduced_magic_resistance = caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("reduced_magic_resistance")
		if self:GetCaster():HasTalent("special_bonus_imba_zuus_3") then 
			reduced_magic_resistance = reduced_magic_resistance + caster:FindTalentValue("special_bonus_imba_zuus_3", "reduced_magic_resistance")
		end

		local movement_speed 	= 20
		local turn_rate 	 	= 1
		if self:GetCaster():HasTalent("special_bonus_imba_zuus_4") then 
			movement_speed 	= caster:FindTalentValue("special_bonus_imba_zuus_4", "movement_speed")
			turn_rate 	   	= caster:FindTalentValue("special_bonus_imba_zuus_4", "turn_rate")
		end

		CustomNetTables:SetTableValue(
		"player_table", 
		tostring(self:GetCaster():GetPlayerOwnerID()), 
		{ 	
			reduced_magic_resistance 	= reduced_magic_resistance,
			movement_speed 				= movement_speed,
			turn_rate 					= turn_rate
		})

		imba_zuus_lightning_bolt:CastLightningBolt(caster, self, target, target_point)
	end
end

function imba_zuus_lightning_bolt:CastLightningBolt(caster, ability, target, target_point)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day  	= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night  	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")
		local pierce_spellimmunity 	= false
		local z_pos 				= 2000

		if caster:HasTalent("special_bonus_imba_zuus_1") then 
			spread_aoe = spread_aoe + caster:FindTalentValue("special_bonus_imba_zuus_1", "spread_aoe")
		end

		if caster:HasTalent("special_bonus_imba_zuus_7") then
			if caster:HasModifier("modifier_imba_zuus_pierce_spellimmunity") then
				pierce_spellimmunity = true
			end
		end

		-- Add fog vision 
		AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)

		-- Unsure what happens when target is nil. Have to be tested propperly... might have to use dummy target
		if target ~= nil then
			-- target = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, target_point.z), false, nil, nil, DOTA_TEAM_NEUTRALS)
			target_point = target:GetAbsOrigin()

			-- If cast on self. no lightning will be cast but the cloud will spawn at this coordinate.
			if target == caster then
				z_pos = 950
			end
		end

		-- Spell was used on the ground search for invisible hero to target
		if target == nil then 
			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				DOTA_UNIT_TARGET_FLAG_NONE, 
				FIND_CLOSEST, 
				false
			)
			
			local closest = radius
			for i,unit in ipairs(nearby_enemy_units) do
				if not unit:IsMagicImmune() or pierce_spellimmunity then 
					-- First unit is the closest
					target = unit
					break
				end
			end
		end

		-- If we still dont have a target we search for nearby creeps
		if target == nil then
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				ability:GetAbilityTargetType(),
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)

			for i,unit in ipairs(nearby_enemy_units) do
				-- First unit is the closest
				target = unit
			end
		end

		if target == nil or not target:IsMagicImmune() or pierce_spellimmunity then 
			-- Renders the particle on the ground target
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
			ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		end

		-- Add dummy to provide us with truesight aura
		local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
		local true_sight = dummy_unit:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
		true_sight:SetStackCount(true_sight_radius)
		dummy_unit:SetDayTimeVisionRange(sight_radius_day)
		dummy_unit:SetNightTimeVisionRange(sight_radius_night)

		dummy_unit:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_dummy", {})
		dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})

		if target == caster then 
			-- Apply Thundergods Focus and update stacks
			local thundergods_focus_modifier = caster:AddNewModifier(caster, self, "modifier_imba_zuus_thundergods_focus", {duration = 10.0})
			thundergods_focus_modifier:SetStackCount(thundergods_focus_modifier:GetStackCount() + 1)	
		elseif target ~= nil then
			if not target:IsAncient() then 
				local static_charge_modifier = target:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = 5.0})
				if static_charge_modifier ~= nil then 
					static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + 3)	
				end

				target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

				if caster:HasTalent("special_bonus_imba_zuus_5") then 
					local root_duration = 0.5
					local thundergod_focus_modifier = caster:FindModifierByName("modifier_imba_zuus_thundergods_focus")
					if thundergod_focus_modifier ~= nil then 
						root_duration = 0.5 + (thundergod_focus_modifier:GetStackCount() * 0.25)
					end

					target:AddNewModifier(caster, ability, "modifier_rooted", {duration = root_duration})
				end
			end

			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 
			damage_table.damage			= ability:GetAbilityDamage()
			damage_table.victim 		= target

			-- Cannot deal magic dmg to immune... change to pure
			if caster:HasModifier("modifier_imba_zuus_pierce_spellimmunity") and target:IsMagicImmune() then
				damage_table.damage_type = DAMAGE_TYPE_PURE
			end

			ApplyDamage(damage_table)
		end
	end
end



------------------------------------------------------
--  			Lightning bolt dummy 				--
------------------------------------------------------
modifier_imba_zuus_lightning_dummy = class({})
function modifier_imba_zuus_lightning_dummy:IsHidden() return true end
function modifier_imba_zuus_lightning_dummy:IsPurgable() return false end
function modifier_imba_zuus_lightning_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end



------------------------------------------------------------------
--  			Lightning bolt true_sight modifier 				--
------------------------------------------------------------------
modifier_imba_zuus_lightning_true_sight = class({})
function modifier_imba_zuus_lightning_true_sight:IsAura()
    return true
end

function modifier_imba_zuus_lightning_true_sight:IsHidden()
    return true
end

function modifier_imba_zuus_lightning_true_sight:IsPurgable()
    return false
end

function modifier_imba_zuus_lightning_true_sight:GetAuraRadius()
    return self:GetStackCount()
end

function modifier_imba_zuus_lightning_true_sight:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_imba_zuus_lightning_true_sight:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_zuus_lightning_true_sight:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_zuus_lightning_true_sight:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_zuus_lightning_true_sight:GetAuraDuration()
    return 0.5
end




----------------------------------------------
--  			FOW modifier  				--
----------------------------------------------
LinkLuaModifier("modifier_imba_zuus_lightning_fow", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_lightning_fow = class({})
function modifier_imba_zuus_lightning_fow:IsHidden() return true end
function modifier_imba_zuus_lightning_fow:OnCreated(keys) 
	if IsServer() then 
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.radius = keys.radius
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_zuus_lightning_fow:OnIntervalThink()
	AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, FrameTime(), false)
end



----------------------------------------------
--  			Static Field  				--
----------------------------------------------
LinkLuaModifier("modifier_imba_zuus_static_field", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
imba_zuus_static_field = class({})
function imba_zuus_static_field:OnUpgrade(keys)
	if IsServer() then
		local caster = self:GetCaster()
		caster:AddNewModifier(caster, self, "modifier_imba_zuus_static_field", {})
	end
end



------------------------------------------------------
--  			Static Field modifier  				--
------------------------------------------------------
modifier_imba_zuus_static_field = class({})
function modifier_imba_zuus_static_field:RemoveOnDeath() return false end
function modifier_imba_zuus_static_field:IsPurgable() return false end
function modifier_imba_zuus_static_field:IsHidden() return true end
function modifier_imba_zuus_static_field:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return decFuncs
end

function modifier_imba_zuus_static_field:OnAbilityExecuted(keys)
	if IsServer() then
		local caster = self:GetCaster()		
		if keys.unit == caster then 
			local ability 			 = self:GetAbility()
			local radius 			 = ability:GetSpecialValueFor("radius")
			local damage_health_pct  = ability:GetSpecialValueFor("damage_health_pct")
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			local caster_position = caster:GetAbsOrigin()
			local zuus_static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(zuus_static_field, 0, Vector(caster_position.x, caster_position.y, caster_position.z))		
			ParticleManager:SetParticleControl(zuus_static_field, 1, Vector(caster_position.x, caster_position.y, caster_position.z) * 100)	
			
			local damage_table 			= {}
			damage_table.attacker 		= self:GetCaster()
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 

			for _,unit in pairs(nearby_enemy_units) do
				if unit:IsAlive() and unit ~= caster and not unit:IsAncient() then
					local current_health = unit:GetHealth()
					damage_table.damage	 = (current_health / 100) * damage_health_pct
					damage_table.victim  = unit
					ApplyDamage(damage_table)

					-- Add a static charge 
					local static_charge_modifier = unit:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = 5.0})
					if static_charge_modifier ~= nil then
						static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + 1)	
					end
				end
			end
		end
	end
end



------------------------------------------------------
--				Static Charge Modifier  			--
------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_static_charge", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_static_charge = class({})
function modifier_imba_zuus_static_charge:IsDebuff() return true end
function modifier_imba_zuus_static_charge:OnCreated() 
	if IsServer() then
		local caster = self:GetCaster()
		self.reduced_magic_resistance = caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("reduced_magic_resistance")
		if caster:HasTalent("special_bonus_imba_zuus_3") then 
			self.reduced_magic_resistance = self.reduced_magic_resistance + caster:FindTalentValue("special_bonus_imba_zuus_3", "reduced_magic_resistance")
		end
	else 
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.reduced_magic_resistance = net_table.reduced_magic_resistance or 0
	end
end

function modifier_imba_zuus_static_charge:GetTexture()
	return "zuus_static_field"
end

function modifier_imba_zuus_static_charge:DeclareFunctions()
	decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return decFuncs
end

function modifier_imba_zuus_static_charge:CheckState()
	local state = {}
	local stacks = self:GetStackCount()
	if stacks >= 5 then
		state[MODIFIER_STATE_INVISIBLE] = false
	end

	if stacks >= 9 then 
		state[MODIFIER_STATE_MUTED] = true
	end

	return state
end

function modifier_imba_zuus_static_charge:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end


function modifier_imba_zuus_static_charge:GetModifierMagicalResistanceBonus()
	-- Each stack reduces magic resistance
	return self:GetStackCount() * self.reduced_magic_resistance * -1
end



--------------------------------------
--				Nimbus				--
--------------------------------------
LinkLuaModifier("modifier_zuus_nimbus", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_nimbus_storm", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)

imba_zuus_cloud = class({})
function imba_zuus_cloud:OnInventoryContentsChanged()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasScepter() then
			self:SetHidden( false )
			if self:GetLevel() <= 0 then
				self:SetLevel( 1 )
			end
		else
			self:SetHidden( true )
		end
	end
end

function imba_zuus_cloud:OnSpellStart()
	if IsServer() then
		local caster 				= self:GetCaster()
		self.target_point 			= self:GetCursorPosition()

		local cloud_bolt_interval 	= self:GetSpecialValueFor("cloud_bolt_interval")
		local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")
		local cloud_radius 			= self:GetSpecialValueFor("cloud_radius")

		caster:EmitSound("Hero_Zuus.Cloud.Cast")

		caster:RemoveModifierByName("modifier_imba_zuus_on_nimbus")
		self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
		self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		self.zuus_nimbus_unit:SetModelScale(0.7)
		self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
		self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_nimbus_storm", {duration = cloud_duration, cloud_bolt_interval = cloud_bolt_interval, cloud_radius = cloud_radius})
		self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})

		local zap_ability = caster:FindAbilityByName("imba_zuus_nimbus_zap")
		if zap_ability ~= nil then
			zap_ability:SetLevel(1)
			caster:SwapAbilities("imba_zuus_cloud", "imba_zuus_nimbus_zap", false, true)
		end
	end
end

modifier_zuus_nimbus_storm = class({})
function modifier_zuus_nimbus_storm:OnCreated(keys)
	if IsServer() then
		self.caster 				= self:GetCaster()
		self.ability 				= self
		self.cloud_radius 			= keys.cloud_radius
		self.cloud_bolt_interval 	= keys.cloud_bolt_interval
		self.dmg_timer 				= self:GetAbility():GetSpecialValueFor("cloud_bolt_interval")
		self.lightning_bolt 		= self.caster:FindAbilityByName("imba_zuus_lightning_bolt")
		local target_point 			= GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())
		
		self.original_z = target_point.z
		self:SetStackCount(self.original_z)

		-- Create nimbus cloud particle
		self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/hero/zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- Position of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 450))
		-- Radius of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.cloud_radius, 0, 0))
		-- Position of cloud 
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z + 450))	

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_zuus_nimbus_storm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_zuus_nimbus_storm:GetVisualZDelta()
	return 450
end

function modifier_zuus_nimbus_storm:OnIntervalThink()
	if IsServer() then
		-- Current position
		local target_point = self:GetParent():GetAbsOrigin()
		-- Reposition of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 450))
		-- Reposition of cloud 
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z +450))	

		-- Is Zeus on the cloud?
		if self.caster:HasModifier("modifier_imba_zuus_on_nimbus") then
			-- Move sync zeus movement with the cloud... 
			self.caster:SetAbsOrigin(target_point)
		end

		self.dmg_timer = self.dmg_timer + FrameTime()

		-- Time to cast a lightningbolt?
		if self.lightning_bolt:GetLevel() > 0 and self.dmg_timer >= self.cloud_bolt_interval then
			local nearby_enemy_units = FindUnitsInRadius(
				self.caster:GetTeamNumber(), 
				self:GetParent():GetAbsOrigin(), 
				nil, 
				self.cloud_radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				self.lightning_bolt:GetAbilityTargetType(),
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)

			for _,unit in pairs(nearby_enemy_units) do
				if unit:IsAlive() then
					imba_zuus_lightning_bolt:CastLightningBolt(self.caster, self.lightning_bolt, unit, unit:GetAbsOrigin())
					-- Abort when we find something to hit
					break
				end
			end

			-- Reset timer
			self.dmg_timer = 0
		end
	end
end

function modifier_zuus_nimbus_storm:OnAttacked(params)
	if params.target == self:GetParent() then
		if params.attacker:IsRealHero() then
			if params.attacker:IsRangedAttacker() then
				self:GetParent():SetHealth(self:GetParent():GetHealth() - (self:GetAbility():GetSpecialValueFor("ranged_hero_damage") / self:GetParent():GetMaxHealth()))
			else
				self:GetParent():SetHealth(self:GetParent():GetHealth() - (self:GetAbility():GetSpecialValueFor("melee_hero_damage") / self:GetParent():GetMaxHealth()))
			end
		else
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self:GetAbility():GetSpecialValueFor("non_hero_damage") / self:GetParent():GetMaxHealth()))
		end
	end
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_zuus_nimbus_storm:OnRemoved()
	if IsServer() then
		-- Cleanup particle
		ParticleManager:DestroyParticle(self.zuus_nimbus_particle, false)

		local caster = self:GetCaster()
		-- Return Zeus to ground if its the current cloud that ended
		local nimbus_ability = caster:FindAbilityByName("imba_zuus_cloud")
		if self:GetParent() == nimbus_ability.zuus_nimbus_unit then
			caster:RemoveModifierByName("modifier_imba_zuus_nimbus_z")

			local skill_slot_4 = caster:GetAbilityByIndex(3):GetAbilityName()
			-- print("skill to swap? ", skill_slot_4)
			if skill_slot_4 == "imba_zuus_nimbus_zap" then 
				caster:SwapAbilities("imba_zuus_nimbus_zap", "imba_zuus_cloud", false, true)	
			end

			if skill_slot_4 == "imba_zuus_leave_nimbus" then 
				caster:SwapAbilities("imba_zuus_leave_nimbus", "imba_zuus_cloud", false, true)	
			end

			FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
		end
	end
end


----------------------------------------------
--				Nimbus Teleport				--
----------------------------------------------
LinkLuaModifier("modifier_imba_ball_lightning", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_zuus_nimbus_z", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
imba_zuus_nimbus_zap = class({})
function imba_zuus_nimbus_zap:OnSpellStart() 
	if IsServer() then
		-- Ability properties
		local caster 			= self:GetCaster()
		local nimbus_ability 	= caster:FindAbilityByName("imba_zuus_cloud")
		self.nimbus 			= nimbus_ability.zuus_nimbus_unit
		if self.nimbus:IsNull() then 
			print("Nimbus is null")
			caster:SwapAbilities("imba_zuus_nimbus_zap", "imba_zuus_cloud", false, true)
			return 
		end

		caster:EmitSound("Hero_Zuus.LightningBolt")

		local target_loc 	= self.nimbus:GetAbsOrigin()
		local caster_loc 	= GetGroundPosition(caster:GetAbsOrigin(), caster)
		target_loc.z 		= target_loc.z + 100
		local max_height 	= target_loc.z + 100
		
		-- Ability parameters
		local speed 			=	self:GetSpecialValueFor("ball_speed")
		local damage_radius 	= 	self:GetSpecialValueFor("damage_radius")
		local vision 			= 	self:GetSpecialValueFor("ball_vision_radius")
		local tree_radius 		= 	100
		local damage 			= 	self:GetSpecialValueFor("damage_per_100_units")
		local base_mana_cost	= 	self:GetSpecialValueFor("travel_mana_cost_base")
		local pct_mana_cost		= 	self:GetSpecialValueFor("travel_mana_cost_pct") * caster:GetMaxMana()
		local total_mana_cost 	=	base_mana_cost + pct_mana_cost
		local max_spell_amp_range	=	self:GetSpecialValueFor("max_spell_amp_range")

		-- Motion control properties
		self.traveled 	= 0
		self.distance 	= (target_loc - caster_loc):Length2D()
		self.direction 	= (target_loc - caster_loc):Normalized()

		-- Calculate height to add per instance traveled
		local add_height = ((target_loc.z) - caster_loc.z) / (self.distance/speed/FrameTime())
		local add_stacks = 450 / (math.abs(target_loc.z - caster_loc.z) / math.abs(add_height))
		-- Save original target location
		self.target_loc = target_loc

		-- Play the cast sound
		caster:EmitSound("Hero_StormSpirit.BallLightning")
		caster:EmitSound("Hero_StormSpirit.BallLightning.Loop")
		
		caster:AddNewModifier(caster, self, "modifier_imba_ball_lightning", {})
		self.nimbus_z = caster:AddNewModifier(caster, self, "modifier_imba_zuus_nimbus_z", {})

		print("nimbus location", target_loc, caster_loc, max_height, add_height)
		-- Fire the ball of death!
		local projectile =
		{
			Ability				= self,
			EffectName			= "particles/hero/storm_spirit/no_particle_particle.vpcf",
			vSpawnOrigin		= caster_loc,
			fDistance			= self.distance,
			fStartRadius		= damage_radius,
			fEndRadius			= damage_radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= self:GetAbilityTargetTeam(),
			iUnitTargetFlags	= self:GetAbilityTargetFlags(),
			iUnitTargetType		= self:GetAbilityTargetType(),
			bDeleteOnHit		= false,
			vVelocity 			= self.direction * speed * Vector(1, 1, 0),
			bProvidesVision		= true,
			iVisionRadius 		= vision,
			iVisionTeamNumber 	= caster:GetTeamNumber(),
			ExtraData			= {damage = damage,
				tree_radius = tree_radius,
				speed = speed * FrameTime(),
				max_spell_amp_range = max_spell_amp_range,
				add_stacks = add_stacks,
				add_height = add_height,
				max_height = max_height,
				target_loc = target_loc
			}
		}

		self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)

		-- Add Motion-Controller Modifier
		--self.zap_modifier = caster:AddNewModifier(caster, self, "modifier_imba_ball_lightning", {})
		-- StartAnimation(self:GetCaster(), {duration=10.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})		
	end
end

function imba_zuus_nimbus_zap:OnProjectileThink_ExtraData(location, ExtraData)
	-- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
	local caster = self:GetCaster()

	-- When cloud is killed before we get to it...
	if self.nimbus_z:IsNull() then 
		caster:RemoveModifierByName("modifier_imba_ball_lightning")
		return
	end

	if (self.traveled + ExtraData.speed< self.distance) and caster:IsAlive() then

		-- Destroy the trees in the way
		GridNav:DestroyTreesAroundPoint(location, ExtraData.tree_radius, false)

		local tmp = caster:GetAbsOrigin()
		--print("z loc ", tmp.z)
		-- Set Zuus new position
		if tmp.z > ExtraData.max_height then 
			caster:SetAbsOrigin(Vector(location.x, location.y, ExtraData.max_height))
		else
			caster:SetAbsOrigin(Vector(location.x, location.y, tmp.z + ExtraData.add_height))
		end
		
		-- Set Zuus z offset from ground
		self.nimbus_z:SetStackCount(self.nimbus_z:GetStackCount() + ExtraData.add_stacks)
		
		-- Calculate the new travel distance
		self.traveled = self.traveled + ExtraData.speed
		self.units_traveled_in_last_tick = ExtraData.speed

		caster:Purge(false, true, true, true, true)
		caster:AddNewModifier(caster, self, "modifier_item_lotus_orb_active", {duration=FrameTime()})
	else
		-- Make sure we end up at the correct location.
		caster:SetAbsOrigin(self.target_loc)
		self.nimbus_z:SetStackCount(450)

		-- Get rid of stuff
		caster:StopSound("Hero_StormSpirit.BallLightning.Loop")
		caster:RemoveModifierByName("modifier_imba_ball_lightning")
		--ProjectileManager:DestroyLinearProjectile(self.projectileID)

		local leave_nimbus_ability = caster:FindAbilityByName("imba_zuus_leave_nimbus")
		if leave_nimbus_ability ~= nil then
			leave_nimbus_ability:SetLevel(1)
			if not self.nimbus:IsNull() and self.nimbus ~= nil then
				if caster:GetAbilityByIndex(3):GetAbilityName() == "imba_zuus_nimbus_zap" then
					caster:SwapAbilities("imba_zuus_nimbus_zap", "imba_zuus_leave_nimbus", false, true)
				end
			end
		end
	end
end


imba_zuus_leave_nimbus = class({})
function imba_zuus_leave_nimbus:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_imba_zuus_on_nimbus")
		caster:RemoveModifierByName("modifier_imba_zuus_nimbus_z")

		caster:SwapAbilities("imba_zuus_leave_nimbus", "imba_zuus_cloud", false, true)
	end
end

----------------------------------------------------------
--				Nimbus teleport modifier  				--
----------------------------------------------------------
modifier_imba_ball_lightning = modifier_imba_ball_lightning or class({})
function modifier_imba_ball_lightning:IsDebuff() 	return false end
function modifier_imba_ball_lightning:IsHidden() 	return false end
function modifier_imba_ball_lightning:IsPurgable() return false end

function modifier_imba_ball_lightning:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
end

function modifier_imba_ball_lightning:GetEffectAttachType()
	-- Yep, this is a thing.
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_imba_ball_lightning:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end
function modifier_imba_ball_lightning:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_ball_lightning:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_ball_lightning:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_ball_lightning:OnRemoved()
	if IsServer() then
		self:GetCaster():AddNewModifier(nil, nil, "modifier_imba_zuus_on_nimbus", {})
	end
end


modifier_imba_zuus_nimbus_z = class({})
function modifier_imba_zuus_nimbus_z:CheckState()
	state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_imba_zuus_nimbus_z:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS}
	return funcs
end

function modifier_imba_zuus_nimbus_z:GetModifierCastRangeBonus()
	--return 150
end

function modifier_imba_zuus_nimbus_z:GetVisualZDelta()
	return self:GetStackCount()
end


LinkLuaModifier("modifier_imba_zuus_on_nimbus", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_on_nimbus = class({})

----------------------------------------------
--				Thundergods Wrath  			--
----------------------------------------------
imba_zuus_thundergods_wrath = class({})

function imba_zuus_thundergods_wrath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")

	return true
end

function imba_zuus_thundergods_wrath:OnSpellStart() 
	if IsServer() then
		local caster 				= self:GetCaster()
		local ability 				= self
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day 		= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night 	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local pierce_spellimmunity 	= false

		local position 				= caster:GetAbsOrigin()	
		local attack_lock 			= caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
		local thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))		
		ParticleManager:SetParticleControl(thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))		

		local used_on_zuus = false
		local thundergods_focus_modifier = caster:FindModifierByName("modifier_imba_zuus_thundergods_focus")
		if thundergods_focus_modifier ~= nil and thundergods_focus_modifier:GetStackCount() > 5 then
			used_on_zuus = true
		end

		if caster:HasTalent("special_bonus_imba_zuus_7") then
			if caster:HasModifier("modifier_imba_zuus_pierce_spellimmunity") then
				pierce_spellimmunity = true
			end
		end

		EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), "Hero_Zuus.GodsWrath", caster)

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 

		if pierce_spellimmunity then
			damage_table.damage_type = DAMAGE_TYPE_PURE
		end

		local enemies_hit = 0 
		for _,hero in pairs(HeroList:GetAllHeroes()) do 
			if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() and (not hero:IsMagicImmune() or pierce_spellimmunity) then 
				if used_on_zuus == true and not hero:IsIllusion() then 
					-- enemies_hit = enemies_hit + 1
				else
					local target_point = hero:GetAbsOrigin()
					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))		
					ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))	
					ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))

					damage_table.damage	 = self:GetAbilityDamage()
					damage_table.victim  = hero
					ApplyDamage(damage_table)
					hero:EmitSound("Hero_Zuus.LightningBolt")
					hero:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_fow", {duration = sight_duration, radius = true_sight_radius})
					local true_sight = hero:AddNewModifier(caster, self, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
					if true_sight ~= nil then
						true_sight:SetStackCount(true_sight_radius)
					end

					-- Add dummy to provide us with truesight aura
					--local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
					--local true_sight = dummy_unit:AddNewModifier(caster, self, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
					--dummy_unit:SetDayTimeVisionRange(sight_radius_day)
					--dummy_unit:SetNightTimeVisionRange(sight_radius_night)
					--dummy_unit:AddNewModifier(caster, self, "modifier_imba_zuus_lightning_dummy", {})
					--dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})

					local static_charge_modifier = hero:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = 5.0})
					if static_charge_modifier ~= nil then
						static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + 1)
					end
				end
			end
		end

		if used_on_zuus then
			-- Awaken! Calculate durations
			local awakening_duration = enemies_hit * 3
			local thundergods_focus_stacks = thundergods_focus_modifier:GetStackCount()
			if thundergods_focus_stacks > 10 then
				thundergods_focus_modifier:SetStackCount(thundergods_focus_stacks - 10)
				thundergods_focus_stacks = 10
			else
				thundergods_focus_modifier:SetStackCount(thundergods_focus_modifier:GetStackCount() - thundergods_focus_stacks)
				if thundergods_focus_stacks == 6 then
					caster:RemoveModifierByName("modifier_imba_zuus_thundergods_focus")
				end
			end

			-- Add duration for number of stacks
			awakening_duration = awakening_duration + (thundergods_focus_stacks * 3)
			-- print("awakening_duration", awakening_duration, thundergods_focus_stacks, enemies_hit)
 			caster:AddNewModifier(caster, self, "modifier_imba_zuus_thundergods_awakening", {duration = awakening_duration})
		end
	end
end



---------------------------------------------------------
--				Thundergods Focus Modifier  			--
----------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_thundergods_focus", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_thundergods_focus = class({})
function modifier_imba_zuus_thundergods_focus:IsBuff() return true end
function modifier_imba_zuus_thundergods_focus:OnCreated() 
	self.bonus_movement_speed 	= 20
	self.bonus_turn_rate 		= 1
	if IsServer() then
		local caster = self:GetCaster()
		if self:GetCaster():HasTalent("special_bonus_imba_zuus_4") then 
			self.bonus_movement_speed 	= caster:FindTalentValue("special_bonus_imba_zuus_4", "movement_speed")
			self.bonus_turn_rate 		= caster:FindTalentValue("special_bonus_imba_zuus_4", "turn_rate")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_zuus_6") then 		
			for i = 0, 7 do
				local ability = self:GetParent():GetAbilityByIndex(i)
				if ability then
					local remaining_cooldown = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					if remaining_cooldown > 1 then
						ability:StartCooldown(remaining_cooldown - 1)
					end
				end
			end
		end
	else 
		local net_table 			= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_movement_speed 	= net_table.movement_speed or 20
		self.bonus_turn_rate 		= net_table.turn_rate or 1
	end
end

function modifier_imba_zuus_thundergods_focus:OnRefresh() 
	if IsServer() then
		local stacks = (self:GetStackCount() + 1)
		if stacks < 3 then
			self:GetCaster():RemoveModifierByName("modifier_imba_zuus_pierce_spellimmunity")
		elseif self:GetCaster():HasTalent("special_bonus_imba_zuus_7") then 
			self:GetCaster():AddNewModifier(caster, nil , "modifier_imba_zuus_pierce_spellimmunity", {})
		end
	end
end

function modifier_imba_zuus_thundergods_focus:OnRemoved() 
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_imba_zuus_pierce_spellimmunity")
	end
end

function modifier_imba_zuus_thundergods_focus:GetTexture()
	return "zuus_lightning_bolt"
end

function modifier_imba_zuus_thundergods_focus:DeclareFunctions()
	decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_zuus_thundergods_focus:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed * self:GetStackCount()
end

function modifier_imba_zuus_thundergods_focus:GetModifierTurnRate_Percentage()
	return self.bonus_turn_rate * self:GetStackCount()
end


LinkLuaModifier("modifier_imba_zuus_pierce_spellimmunity", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_pierce_spellimmunity = class({})
function modifier_imba_zuus_pierce_spellimmunity:IsHidden() return false end

--------------------------------------------------------------
--				Thundergods Awakening Modifier  			--
--------------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_thundergods_awakening", "hero/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_thundergods_awakening = class({})
function modifier_imba_zuus_thundergods_awakening:IsHidden() return false end
function modifier_imba_zuus_thundergods_awakening:IsBuff() return true end
function modifier_imba_zuus_thundergods_awakening:IsPurgable() return false end
function modifier_imba_zuus_thundergods_awakening:OnCreated()
	if IsServer() then 
		-- Add some epic particle effect MAEK IT FLASHYY! ~(龴◡龴)~
		self.bkb = ParticleManager:CreateParticle("particles/hero/zeus/awakening/awakening_black_king_bar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self.static_field = ParticleManager:CreateParticle("particles/hero/zeus/awakening/awakening_zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

		local caster = self:GetCaster()
		self.ability = caster:FindAbilityByName("imba_zuus_arc_lightning")
		self.arc_damage = self.ability:GetSpecialValueFor("arc_damage")

		if self.arc_damage == nil or self.arc_damage == 0 then
			self.arc_damage = 85
		end
	end
end

function modifier_imba_zuus_thundergods_awakening:GetTexture()
	return "zuus_thundergods_wrath"
end

function modifier_imba_zuus_thundergods_awakening:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return decFuncs
end

function modifier_imba_zuus_thundergods_awakening:CheckState()
	state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}

	return state
end

function modifier_imba_zuus_thundergods_awakening:GetModifierMagicalResistanceBonus()
 	return 100
end

function modifier_imba_zuus_thundergods_awakening:OnAttackLanded(keys)
	if IsServer() then
		local caster = self:GetCaster()
		if keys.attacker:GetTeam() ~= caster:GetTeam() and keys.attacker:IsAlive() and keys.target == caster and not keys.attacker:IsBuilding() and not keys.attacker:IsAncient() then
			print("Attacked!", keys.attacker:IsCreep(), keys.attacker:IsHero())
			local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y , caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(keys.attacker:GetAbsOrigin().x, keys.attacker:GetAbsOrigin().y, keys.attacker:GetAbsOrigin().z + keys.attacker:GetBoundingMaxs().z ))

			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= self.ability
			damage_table.damage_type 	= DAMAGE_TYPE_MAGICAL
			damage_table.damage			= self.arc_damage
			damage_table.victim 		= keys.attacker
			ApplyDamage(damage_table)
		end
	end
end

function modifier_imba_zuus_thundergods_awakening:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.bkb, true)
		ParticleManager:DestroyParticle(self.static_field, true)
	end
end
