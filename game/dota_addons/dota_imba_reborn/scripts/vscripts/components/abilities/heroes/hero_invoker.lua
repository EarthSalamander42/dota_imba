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
--     naowin, 03.05.2018
--	   naowin, 30.07.2019

modifier_imba_invoker_spelloverride = modifier_imba_invoker_spelloverride or class({})
function modifier_imba_invoker_spelloverride:IsPermanent() return true end
function modifier_imba_invoker_spelloverride:IsHidden() return true end
function modifier_imba_invoker_spelloverride:IsPurgable() return false end
function modifier_imba_invoker_spelloverride:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_imba_invoker_spelloverride:OnCreated()
	if IsServer() then
	self.caster = self:GetCaster()
		self.spell_list = {}
		self.spell_list[self.caster:FindAbilityByName("invoker_cold_snap"):GetEntityIndex()]		= { spell = imba_invoker_cold_snap, 		spell_name = "invoker_cold_snap" 		}
		self.spell_list[self.caster:FindAbilityByName("invoker_ghost_walk"):GetEntityIndex()]		= { spell = imba_invoker_ghost_walk,	 	spell_name = "invoker_ghost_walk"		}
		self.spell_list[self.caster:FindAbilityByName("invoker_ice_wall"):GetEntityIndex()]			= { spell = imba_invoker_ice_wall, 			spell_name = "invoker_ice_wall"			}
		self.spell_list[self.caster:FindAbilityByName("invoker_emp"):GetEntityIndex()]				= { spell = imba_invoker_emp, 				spell_name = "invoker_emp"				}
		self.spell_list[self.caster:FindAbilityByName("invoker_tornado"):GetEntityIndex()]			= { spell = imba_invoker_tornado, 			spell_name = "invoker_tornado"			}
		self.spell_list[self.caster:FindAbilityByName("invoker_alacrity"):GetEntityIndex()]			= { spell = imba_invoker_alacrity, 			spell_name = "invoker_alacrity"			}
		self.spell_list[self.caster:FindAbilityByName("invoker_deafening_blast"):GetEntityIndex()]	= { spell = imba_invoker_deafening_blast, 	spell_name = "invoker_deafening_blast"	}
		self.spell_list[self.caster:FindAbilityByName("invoker_sun_strike"):GetEntityIndex()]		= { spell = imba_invoker_sun_strike, 		spell_name = "invoker_sun_strike"		}
		self.spell_list[self.caster:FindAbilityByName("invoker_forge_spirit"):GetEntityIndex()]		= { spell = imba_invoker_forge_spirit, 		spell_name = "invoker_forge_spirit"		}
		self.spell_list[self.caster:FindAbilityByName("invoker_chaos_meteor"):GetEntityIndex()]		= { spell = imba_invoker_chaos_meteor, 		spell_name = "invoker_chaos_meteor"		}

		self.ability 			= self:GetAbility()
		self.current_level 		= self.ability:GetLevel()
		self.spell_amp 			= self.ability:GetSpecialValueFor("bonus_spellpower")
		self.int_buff 			= self.ability:GetSpecialValueFor("bonus_intellect")
		self.magic_resist 		= self.ability:GetSpecialValueFor("magic_resistance_pct")
		self.cooldown_reduction = self.ability:GetSpecialValueFor("cooldown_reduction_pct")
		self.spell_lifesteal 	= self.ability:GetSpecialValueFor("spell_lifesteal")
		self:StartIntervalThink(1)
	end
end

function modifier_imba_invoker_spelloverride:CastSpell(kv) 
	-- Check if order is any type of spellcast between...
	if kv.order_type >= DOTA_UNIT_ORDER_CAST_POSITION and kv.order_type <= DOTA_UNIT_ORDER_CAST_TOGGLE then
		local invoker = self:GetParent()
		local spell_entity = self.spell_list[kv.entindex_ability]
		if spell_entity ~= nil then
			if spell_entity.spell_name == "invoker_cold_snap" then
				spell_entity.spell:CastSpell(invoker, EntIndexToHScript(kv.entindex_target))

			elseif spell_entity.spell_name == "invoker_ghost_walk" then 
				spell_entity.spell:CastSpell(invoker)

			elseif spell_entity.spell_name == "invoker_ice_wall" then 
				spell_entity.spell:CastSpell(invoker)
			
			elseif spell_entity.spell_name == "invoker_emp" then 
				spell_entity.spell:CastSpell(invoker, Vector(kv.position_x, kv.position_y, kv.position_z))

			elseif spell_entity.spell_name == "invoker_tornado" then 
				spell_entity.spell:CastSpell(invoker, Vector(kv.position_x, kv.position_y, kv.position_z))

			elseif spell_entity.spell_name == "invoker_alacrity" then 
				spell_entity.spell:CastSpell(invoker, EntIndexToHScript(kv.entindex_target))

			elseif spell_entity.spell_name == "invoker_deafening_blast" then 
				spell_entity.spell:CastSpell(invoker, Vector(kv.position_x, kv.position_y, kv.position_z))

			elseif spell_entity.spell_name == "invoker_sun_strike" then 
				spell_entity.spell:CastSpell(invoker, Vector(kv.position_x, kv.position_y, kv.position_z), kv.order_type == DOTA_UNIT_ORDER_CAST_TARGET)

			elseif spell_entity.spell_name == "invoker_forge_spirit" then 
				spell_entity.spell:CastSpell(invoker)

			elseif spell_entity.spell_name == "invoker_chaos_meteor" then 
				spell_entity.spell:CastSpell(invoker, Vector(kv.position_x, kv.position_y, kv.position_z))

			end

			-- Invoke is counted as an action... but this method blocks the call and fake casts spells, 
			-- which makes us able to cast spells unhindered while invis...
			-- Check if we have ghost walk... if so fade out of invis
			if invoker:HasModifier("modifier_imba_invoker_ghost_walk") and spell_entity.spell_name ~= "invoker_ghost_walk" then
				invoker:RemoveModifierByName("modifier_imba_invoker_ghost_walk")
				-- Fade out of invis when broken by invoke.
				invoker:AddNewModifier(invoker, nil, "modifier_invis_fade_ghost_walk", { duration = 0.35}) 
			end

			return false
		end
	end

	return true
end 

function modifier_imba_invoker_spelloverride:OnIntervalThink()
	-- minimize stuff neede to be fetched each tick
	if self.current_level ~= self.ability:GetLevel() then
		self.ability = self:GetAbility()
		self.spell_amp = self:GetAbility():GetSpecialValueFor("bonus_spellpower")
		self.int_buff = self.ability:GetSpecialValueFor("bonus_intellect")
		self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resistance_pct")
		self.cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction_pct")
		self.spell_lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal")
	end
end

function modifier_imba_invoker_spelloverride:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_imba_invoker_spelloverride:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end
function modifier_imba_invoker_spelloverride:GetModifierBonusStats_Intellect()
	return self.int_buff
end

function modifier_imba_invoker_spelloverride:GetCustomCooldownReductionStacking()
	return self.cooldown_reduction
end

function modifier_imba_invoker_spelloverride:GetModifierSpellLifesteal()
	return self.spell_lifesteal
end

--[[
function modifier_imba_invoker_spelloverride:printkv(kv)
	for x,y in pairs(kv) do
		print(x)
		print(y)
		print("\n")
	end	
end
]]

---------------------------------------------------------------------------------------------------------------------
--	Invoker's Cold Snap
---------------------------------------------------------------------------------------------------------------------
imba_invoker_cold_snap = imba_invoker_cold_snap or class({})
LinkLuaModifier("modifier_imba_invoker_cold_snap", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_cold_snap_stun_duration", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_cold_snap_cooldown", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_cold_snap:CastSpell(caster, target)
		local ability 				= caster:FindAbilityByName("invoker_cold_snap") 
		local quas_level 			= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1

		-- Get skill stats
		local cold_snap_duration 	= ability:GetLevelSpecialValueFor("duration", quas_level) 
		local freeze_duration 		= ability:GetLevelSpecialValueFor("freeze_duration", quas_level) 
		local freeze_cooldown 		= ability:GetLevelSpecialValueFor("freeze_cooldown", quas_level) 
		local freeze_damage 		= ability:GetLevelSpecialValueFor("freeze_damage", quas_level)
		local damage_trigger	 	= ability:GetSpecialValueFor("damage_trigger")

		-- Check if we have cold snap talent
		if caster:HasTalent("special_bonus_imba_invoker_4") then
			local additional_cold_snap_duration	 	= caster:FindTalentValue("special_bonus_imba_invoker_4","duration")
			cold_snap_duration 						= cold_snap_duration + additional_cold_snap_duration
		end

		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Play Cold Snap Sounds!
		EmitSoundOn("Hero_Invoker.ColdSnap.Cast", caster)
		EmitSoundOn("Hero_Invoker.ColdSnap", target)

		-- check linkens
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end

		-- Create pacticle effect
		local cold_snap_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

		-- Apply cold snap to target
		target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap", {
			duration 			= cold_snap_duration,
			freeze_duration 	= freeze_duration,
			freeze_cooldown		= freeze_cooldown, 
			freeze_damage 		= freeze_damage,
			damage_trigger 		= damage_trigger})

		target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_stun_duration", {duration = freeze_duration}) 
		target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_cooldown", {duration = freeze_cooldown})

		-- Apply damage
		local damage_table = {}
		damage_table.attacker = caster
		damage_table.victim = target
		damage_table.ability = ability
		damage_table.damage_type = ability:GetAbilityDamageType() 
		damage_table.damage = freeze_damage
		ApplyDamage(damage_table)

		-- Cleanup
		Timers:CreateTimer(cold_snap_duration, function()
			ParticleManager:DestroyParticle(cold_snap_effect, false)
		end)
end

---------------------------------------------------------------------------------------------------------------------
--	Cold Snap debuff modifier
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_cold_snap = class({})
LinkLuaModifier("modifier_imba_invoker_cold_snap_stun_duration", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_cold_snap_cooldown", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_invoker_cold_snap:IsBuff() return false end
function modifier_imba_invoker_cold_snap:IsHidden() return false end
function modifier_imba_invoker_cold_snap:IsDebuff() return true end
function modifier_imba_invoker_cold_snap:IsPurgable() return false end
function modifier_imba_invoker_cold_snap:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_TAKEDAMAGE}
	return funcs
end

function modifier_imba_invoker_cold_snap:GetAbilityTextureName()
	return "invoker_cold_snap"
end

function modifier_imba_invoker_cold_snap:GetTexture()
	return "invoker_cold_snap"
end

function modifier_imba_invoker_cold_snap:OnCreated(kv) 
	if IsServer() then 
		self.freeze_duration 	= kv.freeze_duration
		self.freeze_cooldown 	= kv.freeze_cooldown 
		self.freeze_damage 		= kv.freeze_damage
		self.damage_trigger 	= kv.damage_trigger
	end
end

function modifier_imba_invoker_cold_snap:OnTakeDamage(kv) 
	if IsServer() then
		local caster 			= self:GetCaster()
		local target 			= kv.unit
		local ability 			= caster:FindAbilityByName("invoker_cold_snap") 

		-- Only proc cold_snap if the target still have cold_snap debuff and the attacker is not the taret itself
		if caster ~= target and target:HasModifier("modifier_imba_invoker_cold_snap") then
			-- If target is dealt enought damage to trigger cold_snap and the effect is not on cooldown...
			if kv.damage >= self.damage_trigger and not target:HasModifier("modifier_imba_invoker_cold_snap_cooldown") then
				local cold_snap_effect 		= ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
				local stun_effect 			= ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
				target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_stun_duration", {duration = self.freeze_duration}) 
				target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_cooldown", {duration = self.freeze_cooldown})

				-- Apply damage
				local damage_table 			= {}
				damage_table.attacker 		= caster
				damage_table.victim 		= target
				damage_table.ability 		= ability
				damage_table.damage_type 	= ability:GetAbilityDamageType() 
				damage_table.damage 		= self.freeze_damage
				ApplyDamage(damage_table)

				-- Cleanup
				Timers:CreateTimer(self.freeze_cooldown, function()
						ParticleManager:DestroyParticle(cold_snap_effect, false)
						ParticleManager:DestroyParticle(stun_effect, false)
				end)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Cold Snap cooldown modifier - dummy modifier, used to check if coldsnap proc is on cooldown
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_cold_snap_cooldown = class({})
function modifier_imba_invoker_cold_snap_cooldown:IsHidden() return true end
function modifier_imba_invoker_cold_snap_cooldown:IsPurgable() return false end

---------------------------------------------------------------------------------------------------------------------
--	Cold Snap stun modifier
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_cold_snap_stun_duration = class({})
function modifier_imba_invoker_cold_snap_stun_duration:IsDebuff() return true end
function modifier_imba_invoker_cold_snap_stun_duration:IsPurgable() return false end
function modifier_imba_invoker_cold_snap_stun_duration:IsHidden() return true end
function modifier_imba_invoker_cold_snap_stun_duration:OnCreated() 
	if IsServer() then
		local target = self:GetParent()

		-- Play ColdSnap Freeze sound
		EmitSoundOn("Hero_Invoker.ColdSnap.Freeze", target)
	end
end

function modifier_imba_invoker_cold_snap_stun_duration:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	return state
end



---------------------------------------------------------------------------------------------------------------------
--	Invoker's Ghost Walk
---------------------------------------------------------------------------------------------------------------------
imba_invoker_ghost_walk = imba_invoker_ghost_walk or class({})
LinkLuaModifier("modifier_imba_invoker_ghost_walk", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_ghost_walk:CastSpell(caster)
	if IsServer() then
		local ability 						= caster:FindAbilityByName("invoker_ghost_walk")

		-- Get skill stats
		local ghost_walk_duration 			= ability:GetSpecialValueFor("duration")
		local area_of_effect 				= ability:GetSpecialValueFor("area_of_effect") 
		local aura_fade_time 				= ability:GetSpecialValueFor("aura_fade_time")
		local invis_fade_time 				= ability:GetSpecialValueFor("invis_fade_time")
		local quas_level 					= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local wex_level 					= caster:FindAbilityByName("invoker_wex"):GetLevel() - 1
		local self_slow 					= ability:GetLevelSpecialValueFor("self_slow", wex_level)
		local enemy_slow 					= ability:GetLevelSpecialValueFor("enemy_slow", quas_level)
		local aura_think_interval 			= ability:GetSpecialValueFor("aura_update_interval")		
		local increase_max_movement_speed 	= ability:GetSpecialValueFor("increase_max_movement_speed")		
		
		-- Play Ghost Walk sound
		EmitSoundOn("Hero_Invoker.GhostWalk", caster)

		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Add Ghost Walk modifier
		caster:AddNewModifier(caster, ability, "modifier_imba_invoker_ghost_walk", {	
			duration 			= ghost_walk_duration, 
			self_slow 			= self_slow, 
			enemy_slow 			= enemy_slow,
			max_movement_speed 	= max_movement_speed,
			aura_fade_time 		= aura_fade_time,
			aura_think_interval = aura_think_interval,
			area_of_effect 		= area_of_effect,
			invis_fade_time 	= invis_fade_time})

		-- stats for client... 
		CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { 	ghost_walk_self_slow = self_slow, 
																								ghost_walk_enemy_slow = enemy_slow})
	end
end

--------------------------------------------------------------------------------------------------------------------
--	Ghost Walk - self-modifier
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_ghost_walk = class({})
LinkLuaModifier("modifier_invis_fade_ghost_walk", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_ghost_walk_aura", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_invoker_ghost_walk:IsHidden() return false end
function modifier_imba_invoker_ghost_walk:IsPurgable() return false end
function modifier_imba_invoker_ghost_walk:IsDebuff() return false end
function modifier_imba_invoker_ghost_walk:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_PROPERTY_MOVESPEED_MAX}
	return funcs
end

function modifier_imba_invoker_ghost_walk:GetAbilityTextureName()
	return "invoker_ghost_walk"
end

function modifier_imba_invoker_ghost_walk:GetTexture()
	return "invoker_ghost_walk"
end

function modifier_imba_invoker_ghost_walk:GetModifierMoveSpeed_Max()
	return self.max_movement_speed
end

function modifier_imba_invoker_ghost_walk:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] 			= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
	}
	return state
end

function modifier_imba_invoker_ghost_walk:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_invoker_ghost_walk:GetModifierInvisibilityLevel()
	return 100
end

function modifier_imba_invoker_ghost_walk:OnCreated(kv) 
	if IsServer() then 
		self.caster 				= self:GetCaster()
		self.parent 				= self:GetParent()
		self.area_of_effect 		= kv.area_of_effect
		self.aura_fade_time 		= kv.aura_fade_time
		self.enemy_slow 			= kv.enemy_slow
		self.self_slow 				= kv.self_slow
		self.ghost_walk_fade_time 	= kv.invis_fade_time
		self.max_movement_speed 	= kv.max_movement_speed
		local aura_think_interval 	= kv.aura_think_interval	

		-- Add ghost walk effect
		local ghost_walk_effect 	= ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)

		self:StartIntervalThink(aura_think_interval)
	else
		-- Set client-value for self_slow
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetParent():GetPlayerOwnerID())) or {}
		self.self_slow = net_table.ghost_walk_self_slow
	end
end

function modifier_imba_invoker_ghost_walk:OnRefresh(kv) 
	if IsServer() then
		self.area_of_effect 		= kv.area_of_effect
		self.aura_fade_time 		= kv.aura_fade_time
		self.enemy_slow 			= kv.enemy_slow
		self.self_slow 				= kv.self_slow
		self.ghost_walk_fade_time 	= kv.invis_fade_time
	end
end

function modifier_imba_invoker_ghost_walk:OnIntervalThink()
	if IsServer() then
		local nearby_enemy_units = FindUnitsInRadius(	self.caster:GetTeam(), 
														self.caster:GetAbsOrigin(), 
														nil, 
														self.area_of_effect, 
														DOTA_UNIT_TARGET_TEAM_ENEMY,
														DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
														DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 
														FIND_ANY_ORDER, 
														false)

		if nearby_enemy_units ~= nil then
			for _,enemy in pairs(nearby_enemy_units) do
				if enemy ~= self.parent then
					enemy:AddNewModifier(self.caster, self, "modifier_imba_invoker_ghost_walk_aura", {duration = self.aura_fade_time, enemy_slow = self.enemy_slow})
				end
			end
		end
	end
end

function modifier_imba_invoker_ghost_walk:OnAttack(kv)
	if IsServer() then	
		-- Only break ghost_walk if invoker is attacking
		if self.parent == kv.attacker then
			if self.caster:HasModifier("modifier_imba_invoker_ghost_walk") then
				self.caster:RemoveModifierByName("modifier_imba_invoker_ghost_walk")
			end
		end
	end
end

function modifier_imba_invoker_ghost_walk:OnAbilityExecuted(kv)
	if IsServer() then
		local caster = kv.unit
		-- Only break ghost_walk if invoker executed an ability
		if self.parent == caster then 
			if caster:HasModifier("modifier_imba_invoker_ghost_walk") then
				self.caster:RemoveModifierByName("modifier_imba_invoker_ghost_walk")
				-- Becuz IMBA is OP! The intended functionality here is to be able to cast a spell and immediatly reapply ghost walk (without beeing noticed).
				-- This will also let us invoke another spell before we are visible... letting us cast more spells before we are noticed.
				caster:AddNewModifier(self.caster, self, "modifier_invis_fade_ghost_walk", {duration = self.ghost_walk_fade_time})
			end
		end
	end
end

function modifier_imba_invoker_ghost_walk:GetModifierMoveSpeedBonus_Percentage()
	return self.self_slow
end

--------------------------------------------------------------------------------------------------------------------
--	Ghost Walk - fade-invis-modifier
--------------------------------------------------------------------------------------------------------------------
modifier_invis_fade_ghost_walk = class({})
function modifier_invis_fade_ghost_walk:IsHidden() return false end
function modifier_invis_fade_ghost_walk:IsPurgable() return false end
function modifier_invis_fade_ghost_walk:IsDebuff() return false end
function modifier_invis_fade_ghost_walk:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_INVISIBILITY_LEVEL}
	return funcs
end
function modifier_invis_fade_ghost_walk:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] 			= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
	}
	return state
end

function modifier_invis_fade_ghost_walk:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_invis_fade_ghost_walk:GetModifierInvisibilityLevel()
	return 100
end

function modifier_invis_fade_ghost_walk:GetAbilityTextureName()
	return "invoker_ghost_walk"
end

function modifier_invis_fade_ghost_walk:GetTexture()
	return "invoker_ghost_walk"
end

--------------------------------------------------------------------------------------------------------------------
--	Ghost Walk - SlowAura
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_ghost_walk_aura = class({})
function modifier_imba_invoker_ghost_walk_aura:IsHidden() return false end
function modifier_imba_invoker_ghost_walk_aura:IsPurgable() return false end
function modifier_imba_invoker_ghost_walk_aura:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return funcs
end

function modifier_imba_invoker_ghost_walk_aura:GetAbilityTextureName()
	return "invoker_ghost_walk"
end

function modifier_imba_invoker_ghost_walk_aura:GetTexture()
	return "invoker_ghost_walk"
end

function modifier_imba_invoker_ghost_walk_aura:OnCreated(kv)
	if IsServer() then
		self.caster 		= self:GetCaster()
		self.parent 		= self:GetParent()
		self.enemy_slow 	= kv.enemy_slow

		-- Check that target is not invoker himself.
		if self.caster ~= self.parent then
			-- Apply Ghost Walk aura effect
			self.ghost_walk_effect_aura  = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			self.ghost_walk_effect_frost = ParticleManager:CreateParticle("particles/status_fx/status_effect_frost.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		end
	else
		-- Set client-value for self_slow
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.enemy_slow = net_table.ghost_walk_enemy_slow
	end
end

function modifier_imba_invoker_ghost_walk_aura:OnRefresh(kv) 
	if IsServer() then
		self.enemy_slow = kv.enemy_slow
	else
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.enemy_slow = net_table.ghost_walk_enemy_slow
	end
end

function modifier_imba_invoker_ghost_walk_aura:OnRemoved()
	if IsServer() then
		-- Cleanup ghost_walk effects
		if self.ghost_walk_effect_aura ~= nil then
			ParticleManager:DestroyParticle(self.ghost_walk_effect_aura, false)
		end
		
		if self.ghost_walk_effect_frost ~= nil then
			ParticleManager:DestroyParticle(self.ghost_walk_effect_frost, false)
		end
	end
end

function modifier_imba_invoker_ghost_walk_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.enemy_slow
end




--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Ice Wall
--------------------------------------------------------------------------------------------------------------------
imba_invoker_ice_wall = imba_invoker_ice_wall or class({})
LinkLuaModifier("modifier_imba_invoker_ice_wall", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_ice_wall_slow", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_ice_wall:CastSpell(caster)
	if IsServer() then
		local caster_point 					= GetGroundPosition(caster:GetAbsOrigin(), caster)
		local caster_direction 				= caster:GetForwardVector()
		local ability 						= caster:FindAbilityByName("invoker_ice_wall")
		local quas_level 					= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local exort_level 					= caster:FindAbilityByName("invoker_exort"):GetLevel() - 1
		local cast_direction 				= Vector(-caster_direction.y, caster_direction.x, caster_direction.z)

		-- Get the Skills stats
		local ice_wall_placement_distance 	= ability:GetSpecialValueFor("wall_place_distance")
		local ice_wall_length 				= ability:GetSpecialValueFor("wall_length")
		local ice_wall_slow_duration 		= ability:GetSpecialValueFor("slow_duration")
		local ice_wall_damage_interval 		= ability:GetSpecialValueFor("damage_interval")
		local ice_wall_area_of_effect 		= ability:GetSpecialValueFor("wall_element_radius")
		local ice_wall_duration 			= ability:GetLevelSpecialValueFor("duration", quas_level)
		local ice_wall_slow 				= ability:GetLevelSpecialValueFor("slow", quas_level)
		local ice_wall_damage_per_second 	= ability:GetLevelSpecialValueFor("damage_per_second", exort_level)

		--local target_point 						= caster_point + (caster_direction * ice_wall_placement_distance)
		ability.endpoint_distance_from_center	= (cast_direction * ice_wall_length) / 2
		--local ice_wall_end_point 			= target_point - endpoint_distance_from_center

		-- Trigger cooldown
		ability:UseResources(true, false, true)
		
		-- Play Ice Wall sound
		EmitSoundOn("Hero_Invoker.IceWall.Cast", caster)

		local ice_walls 		= 1
		local ice_wall_offset 	= 0
		-- With talent we get THICC icewall
		if caster:HasTalent("imba_special_bonus_unique_invoker_4") then
			ice_walls			= caster:FindTalentValue("imba_special_bonus_unique_invoker_4", "ice_walls")
			ice_wall_offset 	= caster:FindTalentValue("imba_special_bonus_unique_invoker_4", "ice_wall_offset")
		end

		for i = 0, (ice_walls -1) do 
			local target_point = caster_point + (caster_direction * ice_wall_placement_distance + (ice_wall_offset * i))

			--Display the Ice Wall particles in a line.
			local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, target_point - ability.endpoint_distance_from_center)
			ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, target_point + ability.endpoint_distance_from_center)
			
			local ice_wall_particle_effect_spikes = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(ice_wall_particle_effect_spikes, 0, target_point - ability.endpoint_distance_from_center)
			ParticleManager:SetParticleControl(ice_wall_particle_effect_spikes, 1, target_point + ability.endpoint_distance_from_center)

			-- Only create thinker for first and last wall to save some preformance
			if i == 0 or i == (ice_walls -1) then
				CreateModifierThinker(
					caster, 
					ability, 
					"modifier_imba_invoker_ice_wall", 	
					{
				 		duration 							= ice_wall_duration,
						ice_wall_damage_interval 			= ice_wall_damage_interval,
						ice_wall_slow_duration 				= ice_wall_slow_duration,
						ice_wall_slow 						= ice_wall_slow,
						ice_wall_damage_per_second 			= ice_wall_damage_per_second,
						ice_wall_area_of_effect 			= ice_wall_area_of_effect,
						ice_wall_length 					= ice_wall_length,
						ice_wall_particle_effect 			= ice_wall_particle_effect,
						ice_wall_particle_effect_spikes 	= ice_wall_particle_effect_spikes
					}, target_point, caster:GetTeamNumber(), false)
			else
				-- Cleanup middle wall
				Timers:CreateTimer(ice_wall_duration, function()
						ParticleManager:DestroyParticle(ice_wall_particle_effect, false)
						ParticleManager:DestroyParticle(ice_wall_particle_effect_spikes, false)
				end)
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Ice Wall modifier
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_ice_wall = class({})
modifier_imba_invoker_ice_wall.npc_radius_constant = 65
function modifier_imba_invoker_ice_wall:OnCreated(kv)
	if IsServer() then
		local ice_wall_damage_interval 			= kv.ice_wall_damage_interval
		self.slow_duration 						= kv.ice_wall_slow_duration
		self.ice_wall_slow 						= kv.ice_wall_slow
		-- damage per second... i.e multiply with the time and we get the correct value
		self.ice_wall_damage_per_second 		= kv.ice_wall_damage_per_second * kv.ice_wall_damage_interval
		self.ice_wall_area_of_effect 			= kv.ice_wall_area_of_effect
		self.ice_wall_length 					= kv.ice_wall_length
		self.search_area 						= kv.ice_wall_length + (kv.ice_wall_area_of_effect * 2)
		self.GetTeam 							= self:GetParent():GetTeam()
		self.origin 							= self:GetParent():GetAbsOrigin()
		self.ability 							= self:GetAbility()
		self.ice_wall_start_point 				= self.origin - self.ability.endpoint_distance_from_center
		self.ice_wall_end_point 				= self.origin + self.ability.endpoint_distance_from_center
		self.ice_wall_particle_effect 			= kv.ice_wall_particle_effect
		self.ice_wall_particle_effect_spikes 	= kv.ice_wall_particle_effect_spikes

		self:StartIntervalThink(ice_wall_damage_interval)
	end
end

function modifier_imba_invoker_ice_wall:OnIntervalThink()
	if IsServer() then
		local nearby_enemy_units = FindUnitsInRadius(
												self.GetTeam, 
												self.origin, 
												nil, 
												self.search_area, 
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
												FIND_ANY_ORDER, 
												false)


		for _,enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				local target_position = enemy:GetAbsOrigin()
				if self:IsUnitInProximity(self.ice_wall_start_point, self.ice_wall_end_point, target_position, self.ice_wall_area_of_effect) then
					enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_invoker_ice_wall_slow", {duration = self.slow_duration, enemy_slow = self.ice_wall_slow})

					-- Apply damage
					local damage_table 			= {}
					damage_table.attacker 		= self:GetParent()
					damage_table.victim			= enemy
					damage_table.ability 		= self.ability
					damage_table.damage_type 	= self.ability:GetAbilityDamageType() 
					damage_table.damage 		= self.ice_wall_damage_per_second
					ApplyDamage(damage_table)
				end
			end
		end
	end
end

function modifier_imba_invoker_ice_wall:OnRemoved() 
	if self.ice_wall_particle_effect ~= nil then
		ParticleManager:DestroyParticle(self.ice_wall_particle_effect, false)
	end

	if self.ice_wall_particle_effect_spikes ~= nil then
		ParticleManager:DestroyParticle(self.ice_wall_particle_effect_spikes, false)
	end
end

--------------------------------------------------------------------------------------------------------------------
--	Help function - check proximity of target vs ice_wall
--------------------------------------------------------------------------------------------------------------------
function modifier_imba_invoker_ice_wall:IsUnitInProximity(start_point, end_point, target_position, ice_wall_radius)
	-- craete vector which makes up the ice wall 
	local ice_wall = end_point - start_point
	-- create vector for target relative to start_point of the ice wall
	local target_vector = target_position - start_point

	local ice_wall_normalized = ice_wall:Normalized()
	-- create a dot vector of the normalized ice_wall vector
	local ice_wall_dot_vector = target_vector:Dot(ice_wall_normalized)
	-- here we will store the targeted enemies closest position
	local search_point
	-- if all the datapoints in the dot vector is below 0 then the target is outside our search hence closest point is start_point.
	if ice_wall_dot_vector <= 0 then
		search_point = start_point

	-- if all th datapoinst in the dot vector is above the max length of our search then there closest point is the end_point
	elseif ice_wall_dot_vector >= ice_wall:Length2D() then
		search_point = end_point

	-- if a datapoinst in the dot vector within range then the closest position is... 
	else
		search_point = start_point + (ice_wall_normalized * ice_wall_dot_vector)
	end 
	-- with all that setup we can now get the distance from our ice_wall! :D 
	local distance = target_position - search_point
	-- Is the distance less then our "area of effect" radius? true/false
	return distance:Length2D() <= ice_wall_radius + modifier_imba_invoker_ice_wall.npc_radius_constant
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Ice Wall slow aura 
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_ice_wall_slow = class({})
function modifier_imba_invoker_ice_wall_slow:IsPassive() return false end
function modifier_imba_invoker_ice_wall_slow:IsBuff() return false end
function modifier_imba_invoker_ice_wall_slow:IsDebuff() return true end
function modifier_imba_invoker_ice_wall_slow:IsPurgable() return false end
function modifier_imba_invoker_ice_wall_slow:IsHidden() return false end
function modifier_imba_invoker_ice_wall_slow:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return funcs
end

function modifier_imba_invoker_ice_wall_slow:OnCreated(kv)
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self:SetStackCount(kv.enemy_slow)

		-- Apply Ice wall slow effect
		self.ice_wall_effect_aura = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	end
end

function modifier_imba_invoker_ice_wall_slow:OnRefresh(kv) 
	if IsServer() then
		self:SetStackCount(kv.enemy_slow)
	end
end

function modifier_imba_invoker_ice_wall_slow:OnRemoved()
	if IsServer() then
		if self.ice_wall_effect_aura ~= nil then
			ParticleManager:DestroyParticle(self.ice_wall_effect_aura, false)
		end
	end
end

function modifier_imba_invoker_ice_wall_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end



---------------------------------------------------------------------------------------------------------------------
--	Invoker's EMP
---------------------------------------------------------------------------------------------------------------------
imba_invoker_emp = imba_invoker_emp or class({})
LinkLuaModifier("modifier_imba_invoker_emp", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_emp:GetAbilityTextureName()
	return "invoker_emp"
end

function imba_invoker_emp:CastSpell(caster, target_point)
	 if IsServer() then 
		local imba_invoker_wex 	= caster:FindAbilityByName("invoker_wex")
		local ability 			= caster:FindAbilityByName("invoker_emp")
		local wex_level = imba_invoker_wex:GetLevel() - 1

		-- Get the Skills stats
		local mana_burned 				= ability:GetLevelSpecialValueFor("mana_burned", wex_level)
		local after_shock_duration		= ability:GetSpecialValueFor("after_shock_duration")
		local delay 					= ability:GetSpecialValueFor("delay")
		local area_of_effect 			= ability:GetSpecialValueFor("area_of_effect")
		local damage_per_mana_pct 		= ability:GetSpecialValueFor("damage_per_mana_pct")
		local mana_gain_per_mana_pct 	= ability:GetSpecialValueFor("mana_gain_per_mana_pct")
		local emp_recharge_threshold 	= 0
		local emp_effect_reduction 		= 0

		-- Check if we have emp talent?
		if caster:HasTalent("imba_special_bonus_unique_invoker_1") then
			-- Get talent values
			emp_recharge_threshold 		= caster:FindTalentValue("imba_special_bonus_unique_invoker_1", "threshold")
			emp_effect_reduction 		= caster:FindTalentValue("imba_special_bonus_unique_invoker_1", "effect_reduction")
			--print("Has RECHARGE emp talent", emp_recharge_threshold, emp_effect_reduction)
		end

		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Cast the emp 
		imba_invoker_emp:CastEMP(
		{	
			caster 						= caster, 
			target_point 				= target_point, 
			mana_burned 				= mana_burned,
			delay 						= delay, 
			after_shock_duration		= after_shock_duration,
			area_of_effect 				= area_of_effect,
			damage_per_mana_pct 		= damage_per_mana_pct,
			mana_gain_per_mana_pct 		= mana_gain_per_mana_pct,
			emp_recharge_threshold 		= emp_recharge_threshold,
			emp_effect_reduction 		= emp_effect_reduction,
			first_cast 					= true
		})
	end
end

function imba_invoker_emp:CastEMP(kv)	
	local caster 					= kv.caster
	local target_point 				= kv.target_point
	local mana_burned 				= kv.mana_burned
	local delay 					= kv.delay
	local after_shock_duration 		= kv.after_shock_duration
	local area_of_effect 			= kv.area_of_effect
	local damage_per_mana_pct 		= kv.damage_per_mana_pct
	local mana_gain_per_mana_pct 	= kv.mana_gain_per_mana_pct
	local emp_recharge_threshold 	= kv.emp_recharge_threshold
	local emp_effect_reduction 		= kv.emp_effect_reduction

	-- Play EMP Sound!
	EmitSoundOnLocationWithCaster(target_point, "Hero_Invoker.EMP.Cast", caster)
	
	-- Create EMP Effect
	local emp_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(emp_effect, 0, target_point)
	ParticleManager:SetParticleControl(emp_effect, 1, Vector(area_of_effect, 0, 0))

	-- Explode EMP after the delay has passed.
	Timers:CreateTimer(delay, function()
		-- Remove EMP charge
		ParticleManager:DestroyParticle(emp_effect, false)
		-- Create EMP explosion
		local emp_explosion_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf",  PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(emp_explosion_effect, 0, target_point)
		ParticleManager:SetParticleControl(emp_explosion_effect, 1, Vector(area_of_effect, 0, 0))
		-- Play EMP Discharge sound
		EmitSoundOnLocationWithCaster(target_point, "Hero_Invoker.EMP.Discharge", caster)
		
		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeam(), 
			target_point, nil, area_of_effect, 
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 
			FIND_ANY_ORDER, 
			false)

		local enemy_heroes_hit = 0
		for i, individual_enemy in ipairs(nearby_enemy_units) do
			-- Apply damage, drain mana, gain mana to caster, and return true/false if we drained full amount of mana from enemy
			if imba_invoker_emp:OnHit(caster, individual_enemy, mana_burned, after_shock_duration, damage_per_mana_pct, mana_gain_per_mana_pct) and individual_enemy:IsHero() then
				enemy_heroes_hit = enemy_heroes_hit + 1
			end
		end

		-- if this is the initial cast
		if caster:HasTalent("imba_special_bonus_unique_invoker_1") and kv.first_cast then
			-- and hit enough enemies to trigger recharge
			if emp_recharge_threshold > 0 and emp_recharge_threshold <= enemy_heroes_hit then
				-- Apply emp talent damage efficiency effect
				mana_burned = mana_burned * (emp_effect_reduction / 100)

				-- Cast Emp again!
				imba_invoker_emp:CastEMP(
				{	
					caster 						= caster, 
					target_point 				= target_point, 
					mana_burned 				= mana_burned,
					delay 						= delay, 
					area_of_effect 				= area_of_effect,
					damage_per_mana_pct 		= damage_per_mana_pct,
					mana_gain_per_mana_pct 		= mana_gain_per_mana_pct,
					emp_recharge_threshold 		= emp_recharge_threshold,
					emp_effect_reduction 		= emp_effect_reduction,
					first_cast 					= false
				})
			end
		end

		-- Cleanup
		Timers:CreateTimer(3, function()
			ParticleManager:DestroyParticle(emp_explosion_effect, false)
		end)
	end)
end

function imba_invoker_emp:OnHit(caster, enemy, mana_to_burn, after_shock_duration, damage_per_mana_pct, mana_gain_per_mana_pct)
	local full_mana_burn = false
	-- Calculate mana to burn. If amount of mana burned is greater then amount of mana remaning then we remove what remains. 
	local enemy_mana_to_burn = enemy:GetMana()
	if mana_to_burn < enemy_mana_to_burn then
		enemy_mana_to_burn = mana_to_burn
		full_mana_burn = true
	end
	
	-- Burn an amount of mana dependent on WEX.
	enemy:ReduceMana(enemy_mana_to_burn)
	-- Apply damage based on amount burned * damage_per_mana_pct modifier.
	ApplyDamage({	
		victim = enemy, 
		attacker = caster, 
		damage = enemy_mana_to_burn * (damage_per_mana_pct / 100), 
		damage_type = DAMAGE_TYPE_PURE
	})
	
	-- Restore some of the burnt mana to Invoker if the affected unit is a real hero.
	if enemy:IsRealHero() then
		enemy:AddNewModifier(caster, self, "modifier_imba_invoker_emp", {duration = after_shock_duration}) 
		caster:GiveMana(enemy_mana_to_burn * (mana_gain_per_mana_pct / 100))
	end

	return full_mana_burn
end	

function imba_invoker_emp:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect")
end 

modifier_imba_invoker_emp = class({})
function modifier_imba_invoker_emp:IsPassive() return false end
function modifier_imba_invoker_emp:IsBuff() return false end
function modifier_imba_invoker_emp:IsDebuff() return true end
function modifier_imba_invoker_emp:IsPurgable() return true end
function modifier_imba_invoker_emp:IsHidden() return false end
function modifier_imba_invoker_emp:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_MANA_GAINED}
	return funcs
end

function modifier_imba_invoker_emp:OnManaGained(kv) 
	if kv.unit == self:GetParent() then
		local current_mana = kv.unit:GetMana();
		kv.unit:SetMana(current_mana - kv.gain);
	end
end

function modifier_imba_invoker_emp:GetAbilityTextureName()
	return "imba_invoker_emp"
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Tornado
--------------------------------------------------------------------------------------------------------------------
imba_invoker_tornado = imba_invoker_tornado or class({})
imba_invoker_tornado.loop_interval = 0.03
imba_invoker_tornado.ability_effect_path 			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
imba_invoker_tornado.ability_effect_cyclone_path 	= "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf"
LinkLuaModifier("modifier_imba_invoker_tornado", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_tornado_cyclone", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_tornado_empower_debuff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_tornado:CastSpell(caster, target_point)
	if IsServer() then 
		local ability 					= caster:FindAbilityByName("invoker_tornado")
		local caster_location 			= caster:GetAbsOrigin() 

		-- Get skill stats
		local quas_level 				= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local wex_level 				= caster:FindAbilityByName("invoker_wex"):GetLevel() - 1
		local tornado_travel_distance 	= ability:GetLevelSpecialValueFor("travel_distance", wex_level)
		local wex_land_damage 			= ability:GetLevelSpecialValueFor("wex_damage", wex_level)
		local tornado_lift_duration  	= ability:GetLevelSpecialValueFor("tornado_lift_duration", quas_level)
		local area_of_effect 			= ability:GetSpecialValueFor("area_of_effect")
		local base_damage 				= ability:GetSpecialValueFor("base_damage")
		local travel_speed 				= ability:GetSpecialValueFor("travel_speed")
		local end_vision_duration 		= ability:GetSpecialValueFor("end_vision_duration")
		local vision_distance 			= ability:GetSpecialValueFor("vision_distance")
		local cyclone_initial_height 	= ability:GetSpecialValueFor("cyclone_initial_height")
		local cyclone_min_height 		= ability:GetSpecialValueFor("cyclone_min_height")
		local cyclone_max_height 		= ability:GetSpecialValueFor("cyclone_max_height")
		local tornado_duration 			= tornado_travel_distance / travel_speed
		local land_debuff_duration 		= 0

		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Check if we have dark_artistry_cape equipped... change buff effect accordingly
		if caster.dark_artistry_cape_tornado == nil or caster.dark_artistry_cape_cyclone == nil then
			local dark_artistry_cape = "models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl"
			local children = caster:GetChildren();
			for _,child in pairs(children) do
				 if child:GetClassname() == "dota_item_wearable" and child:GetModelName() == dark_artistry_cape then
				 	caster.dark_artistry_cape_tornado					= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
				 	caster.dark_artistry_cape_cyclone 					= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf"
				 	imba_invoker_tornado.ability_effect_path 			= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
				 	imba_invoker_tornado.ability_effect_cyclone_path 	= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf"
				 end
			end
		else
			imba_invoker_tornado.ability_effect_path 			= caster.dark_artistry_cape_tornado
			imba_invoker_tornado.ability_effect_cyclone_path 	= caster.dark_artistry_cape_cyclone
		end

		-- Do we have empowered tornado talent?
		if caster:HasTalent("special_bonus_unique_invoker_3") then
			land_debuff_duration = caster:FindTalentValue("special_bonus_unique_invoker_3", "debuff_duration")
		end

		-- Create a dummy unit that will use the imba ability for us...
		local tornado_dummy_unit = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeam())
		local ability_ref = tornado_dummy_unit:AddAbility("imba_invoker_tornado")

		-- Play tornado sound 
		EmitSoundOn("Hero_Invoker.Tornado", tornado_dummy_unit)			

		-- Set tornado vision
		tornado_dummy_unit:SetDayTimeVisionRange(vision_distance)
		tornado_dummy_unit:SetNightTimeVisionRange(vision_distance)

		-- Create tornado projectile object
		local tornado_projectile_table =  
		{
			EffectName 			= imba_invoker_tornado.ability_effect_path,
			Ability 			= ability_ref,
			vSpawnOrigin 		= caster_location,
			fDistance 			= tornado_travel_distance,
			fStartRadius 		= area_of_effect,
			fEndRadius 			= area_of_effect,
			Source 				= caster,
			bHasFrontalCone 	= false,
			iMoveSpeed 			= travel_speed,
			bReplaceExisting 	= false,
			bProvidesVision 	= true,
			iVisionTeamNumber 	= caster:GetTeam(),
			iVisionRadius 		= vision_distance,
			bDrawsOnMinimap 	= false,
			bVisibleToEnemies 	= true, 
			iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			fExpireTime 		= GameRules:GetGameTime() + tornado_duration + 20,
			ExtraData 			= 	{	
				tornado_lift_duration 	= tornado_lift_duration, 
				end_vision_duration 	= end_vision_duration,
				base_damage 			= base_damage,
				wex_land_damage			= wex_land_damage,
				cyclone_initial_height 	= cyclone_initial_height,
				cyclone_min_height		= cyclone_min_height,
				cyclone_max_height 		= cyclone_max_height,
				land_debuff_duration 	= land_debuff_duration,
				cyclone_effect_path 	= imba_invoker_tornado.ability_effect_cyclone_path
		  	}
		}
		
		-- Get cast and target-points and make sure they are at ground level.
		local target_point_ground			= target_point
		target_point_ground.z 				= 0
		local caster_point 					= caster_location 
		caster_point.z 						= 0

		-- Normalize the vector for the difference between the points.
		local point_difference_normalized 	= (target_point_ground - caster_point):Normalized()

		-- Set direction and travel_speed of Tornado
		local projectile_vvelocity 			= point_difference_normalized * travel_speed
		tornado_projectile_table.vVelocity 	= projectile_vvelocity
		
		-- For debugging... i mean this contains maths... ofc we have to check it
		-- local tornado_final_position 		= caster_location + (projectile_vvelocity * tornado_duration)
		-- DebugDrawCircle(tornado_final_position, Vector(255,0,255), 255, 64, true, 20)

		--Calculate where and when the Tornado projectile will end up.
		local number_of_loops 				= math.floor(tornado_duration / imba_invoker_tornado.loop_interval)
		local rounding_error				= math.fmod((tornado_duration / imba_invoker_tornado.loop_interval), 1)
		local rounding_error_vector			= projectile_vvelocity / rounding_error / number_of_loops
		local tornado_velocity_per_frame 	= (projectile_vvelocity + rounding_error_vector) * imba_invoker_tornado.loop_interval
 		local tornado_dummy_position 		= caster_location + (tornado_velocity_per_frame * 2)

		-- Crate the acctual projectile
		local tornado_projectile = ProjectileManager:CreateLinearProjectile(tornado_projectile_table)

		--Adjust the dummy unit's position each frame to match that of the tornado particle effect.
		local endTime = GameRules:GetGameTime() + tornado_duration
		Timers:CreateTimer({
			endTime = imba_invoker_tornado.loop_interval,
			callback = function()
				tornado_dummy_position = tornado_dummy_position + tornado_velocity_per_frame
				tornado_dummy_unit:SetAbsOrigin(tornado_dummy_position)
				if GameRules:GetGameTime() > endTime then
					tornado_dummy_unit:StopSound("Hero_Invoker.Tornado")
					
					--Have the dummy unit linger in the position the tornado ended up in, in order to provide vision.
					Timers:CreateTimer({
						endTime = end_vision_duration,
						callback = function()
							tornado_dummy_unit:RemoveSelf()
						end
					})	
						
					return  
				else 
					return imba_invoker_tornado.loop_interval
				end
			end
		})
	end
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Tornado On Hit
--------------------------------------------------------------------------------------------------------------------
function imba_invoker_tornado:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target ~= nil then 
			local caster 					= self:GetCaster()
			local base_damage 				= ExtraData.base_damage
			local wex_land_damage			= ExtraData.wex_land_damage
			local tornado_lift_duration 	= ExtraData.tornado_lift_duration
			local cyclone_initial_height 	= ExtraData.cyclone_initial_height
			local cyclone_min_height 		= ExtraData.cyclone_min_height
			local cyclone_max_height 		= ExtraData.cyclone_max_height
			local tornado_start 			= GameRules:GetGameTime()
			local end_vision_duration 		= ExtraData.end_vision_duration

			if tornado_lift_duration ~= nil then
				-- Save the target's forward vector so we can put them back facing in the same direction when they land.
				target.invoker_tornado_forward_vector = target:GetForwardVector()
				
				target:AddNewModifier(caster, target, "modifier_imba_invoker_tornado_cyclone", {duration = tornado_lift_duration})
				local cyclone_effect = ParticleManager:CreateParticle(ExtraData.cyclone_effect_path, PATTACH_ABSORIGIN, target)

				EmitSoundOn("Hero_Invoker.Tornado.Target", target)
				
				-- Flying position variables
				local flying_z_modifier = target:FindModifierByName("modifier_imba_invoker_tornado_cyclone")
				local z_position = 0
				tornado_lift_duration = flying_z_modifier:GetDuration()

				-- 1/10th of the total cyclone duration will be spent ascending and descending to and from the initial height.
				local time_to_reach_initial_height 		= 1/10
				-- This is the height to add every frame when the unit is first cycloned, and applies repeatedly, until the cyclone reaches its max height.
				local initial_ascent_height_per_frame 	= ((cyclone_initial_height) / time_to_reach_initial_height) * imba_invoker_tornado.loop_interval 
				-- This is the height to add or remove every frame while the caster is in up/down cycle motion.
				local up_down_cycle_height_per_frame 	= initial_ascent_height_per_frame / 3  
				-- Cap this value so the unit doesn't jerk up and down for short-duration cyclones.
				if up_down_cycle_height_per_frame > 7.5 then  
					up_down_cycle_height_per_frame = 7.5
				end

				-- This is calculated when the unit begins descending. Basicly the speed by which affected units decend
				local final_descent_height_per_frame = nil  

				-- Time to go down, added 1x0.03 because testing showed we need another frame.
				local time_to_stop_fly = tornado_lift_duration - time_to_reach_initial_height -- imba_invoker_tornado.loop_interval
				-- Loop up and down
				local going_up = true
				-- Loop every frame for the duration
				Timers:CreateTimer(function()
					local time_in_air = GameRules:GetGameTime() - tornado_start
					
					self:spinn({target = target, tornado_lift_duration = tornado_lift_duration})
					-- Throw target unit up in the air towards cyclone's initial height.
					if z_position < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then
						--print("+",initial_ascent_height_per_frame,z_position)
						z_position = z_position + initial_ascent_height_per_frame
						flying_z_modifier:SetStackCount(z_position)
						return imba_invoker_tornado.loop_interval
					-- Go down until the target reaches the ground.
					elseif time_in_air > time_to_stop_fly and time_in_air <= tornado_lift_duration then
						--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
						--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration ends.
						if final_descent_height_per_frame == nil then
							-- distance to ground
							local descent_initial_height_above_ground = cyclone_initial_height
							-- Since (time_to_reach_initial_height / imba_invoker_tornado.loop_interval) will end up in a decimal we will get rounding issues in the loop. 
							-- By using math.floor we discards decimals and gives us the correct value which to divide reamining distance to ground
							local rounding_coeff = math.floor(time_to_reach_initial_height / imba_invoker_tornado.loop_interval)
							-- Final value which we subtracts from unit z-position untill it reaches ground.
							final_descent_height_per_frame = descent_initial_height_above_ground / rounding_coeff
							--print("descent_initial_height_above_ground: " .. descent_initial_height_above_ground .. " times leftt: " .. rounding_coeff)
						end

						--print("-",final_descent_height_per_frame,z_position, time_in_air)
						z_position = z_position - final_descent_height_per_frame
						flying_z_modifier:SetStackCount(z_position)
						return imba_invoker_tornado.loop_interval
					-- Before its time to decend we make Up and down cycles
					elseif time_in_air <= tornado_lift_duration then
						-- Up
						if z_position < cyclone_max_height and going_up then 
							--print("going up")
							z_position = z_position + up_down_cycle_height_per_frame
							flying_z_modifier:SetStackCount(z_position)
							return imba_invoker_tornado.loop_interval
						-- Down
						elseif z_position >= cyclone_min_height then
							going_up = false
							--print("going down")
							z_position = z_position - up_down_cycle_height_per_frame
							flying_z_modifier:SetStackCount(z_position)
							return imba_invoker_tornado.loop_interval
						-- Go up
						else
							--print("going up again")
							going_up = true
							return imba_invoker_tornado.loop_interval
						end
						return imba_invoker_tornado.loop_interval
					end
						-- Stop sound
						target:StopSound("Hero_Invoker.Tornado.Target")
						-- Cleanup
						ParticleManager:DestroyParticle(cyclone_effect, false)
						-- Cant deal damage if modifiers are on
						if target:HasModifier("modifier_imba_invoker_tornado") then
							target:RemoveModifierByName("modifier_imba_invoker_tornado") 
						end

						if target:HasModifier("modifier_imba_invoker_tornado_cyclone") then
							target:RemoveModifierByName("modifier_imba_invoker_tornado_cyclone")
							target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin(), caster))
						end

						-- Apply damage
						self:LandDamage(target, caster, self, {base_damage = base_damage, wex_land_damage = wex_land_damage})

						-- If we have empower tornado talent... apply disarm
						if ExtraData.land_debuff_duration > 0 then
							target:AddNewModifier(caster, self, "modifier_imba_invoker_tornado_empower_debuff", {duration = ExtraData.land_debuff_duration})
						end
				end)		
			end
		end
	end
end

function imba_invoker_tornado:spinn(kv)
    local target = kv.target
	local total_degrees = 20

	--Rotate as close to 20 degrees per x.x seconds (666.666 degrees per second) as possible, so that the target lands facing their initial direction.
	if kv.target.invoker_tornado_degrees_to_spin == nil and kv.tornado_lift_duration ~= nil then
		local ideal_degrees_per_second = 666.666
		local ideal_full_spins = (ideal_degrees_per_second / 360) * kv.tornado_lift_duration
		--Round the number of spins to aim for to the closest integer.
		ideal_full_spins = math.floor(ideal_full_spins + .5) 
		local degrees_per_second_ending_in_same_forward_vector = (360 * ideal_full_spins) / kv.tornado_lift_duration
		kv.target.invoker_tornado_degrees_to_spin = degrees_per_second_ending_in_same_forward_vector * imba_invoker_tornado.loop_interval
	end
	
	target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, kv.target.invoker_tornado_degrees_to_spin, 0), target:GetForwardVector()))
end

function imba_invoker_tornado:LandDamage(target, attacker, ability, kv)
	local damage_type = self:GetAbilityDamageType() 
	EmitSoundOn("Hero_Invoker.Tornado.LandDamage", target)
	
	--Set so the target is facing the original direction as they were when they were hit by the tornado.
	if target.invoker_tornado_forward_vector ~= nil then
		target:SetForwardVector(target.invoker_tornado_forward_vector)
	end

	-- Apply damage
	local damage_table = {}
	damage_table.attacker = attacker
	damage_table.victim = target
	damage_table.ability = ability
	damage_table.damage_type = ability:GetAbilityDamageType() 
	damage_table.damage = kv.base_damage + kv.wex_land_damage
	ApplyDamage(damage_table)
end

--------------------------------------------------------------------------------------------------------------------
-- Tornado help modifier - hide dummy unit from game
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_tornado = class({})
function modifier_imba_invoker_tornado:IsHidden() return false end
function modifier_imba_invoker_tornado:IsBuff() return false end
function modifier_imba_invoker_tornado:IsDebuff() return false end
function modifier_imba_invoker_tornado:IsPassive() return false end
function modifier_imba_invoker_tornado:IsPurgable() return false end
function modifier_imba_invoker_tornado:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_OUT_OF_GAME] 		= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_ROOTED] 			= true,
	}
	return state
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Tornado modifier
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_tornado_cyclone = class({})
function modifier_imba_invoker_tornado_cyclone:IsHidden() return true end
function modifier_imba_invoker_tornado_cyclone:IsBuff() return false end
function modifier_imba_invoker_tornado_cyclone:IsDebuff() return false end
function modifier_imba_invoker_tornado_cyclone:IsPassive() return false end
function modifier_imba_invoker_tornado_cyclone:IsPurgable() return false end
function modifier_imba_invoker_tornado_cyclone:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_STUNNED] 			= true,
		[MODIFIER_STATE_ROOTED] 			= true,
		[MODIFIER_STATE_DISARMED] 			= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] 			= true,
	}
	return state
end

function modifier_imba_invoker_tornado_cyclone:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_VISUAL_Z_DELTA}
	return funcs
end

function modifier_imba_invoker_tornado_cyclone:GetVisualZDelta()
	return self:GetStackCount()
end

function modifier_imba_invoker_tornado_cyclone:OnCreated(kv)
end

function modifier_imba_invoker_tornado_cyclone:OnRemoved(kv)
	self:SetStackCount(0)
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Tornado talent modifier
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_tornado_empower_debuff = class({})
function modifier_imba_invoker_tornado_empower_debuff:IsHidden() return false end
function modifier_imba_invoker_tornado_empower_debuff:IsBuff() return false end
function modifier_imba_invoker_tornado_empower_debuff:IsDebuff() return true end
function modifier_imba_invoker_tornado_empower_debuff:IsPassive() return false end
function modifier_imba_invoker_tornado_empower_debuff:IsPurgable() return false end
function modifier_imba_invoker_tornado_empower_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] 	= true,
	}
	return state
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's Alacrity
--------------------------------------------------------------------------------------------------------------------
imba_invoker_alacrity = class({})
imba_invoker_alacrity.ability_effect_path 	= "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf"
imba_invoker_alacrity.buff_effect_path 		= "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf"
LinkLuaModifier("modifier_imba_invoker_alacrity", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_alacrity:CastSpell(caster, target)
	if IsServer() then
		ability = caster:FindAbilityByName("invoker_alacrity")
		-- Get skill stats
		local wex_level 			= caster:FindAbilityByName("invoker_wex"):GetLevel() - 1
		local exort_level 			= caster:FindAbilityByName("invoker_exort"):GetLevel() - 1
		local alacrity_duration 	= ability:GetSpecialValueFor("duration")
		local bonus_attack_speed 	= ability:GetLevelSpecialValueFor("bonus_attack_speed", wex_level)
		local bonus_damage 			= ability:GetLevelSpecialValueFor("bonus_damage", exort_level)
		local area_of_effect 		= 100

		if caster:HasTalent("imba_special_bonus_unique_invoker_6") then
			area_of_effect 	= caster:FindTalentValue("imba_special_bonus_unique_invoker_6", "alacrity_radius")
		end

		-- Check if we have magus_accord equipped... change buff effect accordingly
		if caster.magus_accord_alacrity == nil or caster.magus_accord_buff == nil then 
			local magus_accord = "models/items/invoker/immortal_arms_ti7/immortal_arms_ti7.vmdl"
			local children = caster:GetChildren();
			for _,child in pairs(children) do
				 if child:GetClassname() == "dota_item_wearable" and child:GetModelName() == magus_accord then
				 	imba_invoker_alacrity.ability_effect_path 	= "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf"
					imba_invoker_alacrity.buff_effect_path 		= "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf"
				 	imba_invoker_alacrity.ability_effect_path	= "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf"
				 	imba_invoker_alacrity.buff_effect_path		= "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf" 
				 end
			end
		else
			imba_invoker_alacrity.ability_effect_path 	= caster.magus_accord_alacrity
			imba_invoker_alacrity.buff_effect_path 		= caster.magus_accord_buff
		end


		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Play Alacrity Sound!
		EmitSoundOn("Hero_Invoker.Alacrity", caster)

		if caster:HasTalent("imba_special_bonus_unique_invoker_6") then 

			local nearby_friendly_units = FindUnitsInRadius(caster:GetTeam(),
															target:GetAbsOrigin(), 
															nil, 
															area_of_effect, 
															DOTA_UNIT_TARGET_TEAM_FRIENDLY,
															DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
															DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
															FIND_ANY_ORDER, 
															false)
			local added_to_invoker = false 
			for _,unit in pairs(nearby_friendly_units) do
				if unit == caster then 
					added_to_invoker = true
				end

				unit:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
					duration = alacrity_duration, 
					bonus_attack_speed = bonus_attack_speed, 
					bonus_damage = bonus_damage, 
					ability_effect = imba_invoker_alacrity.ability_effect_path,
					buff_effect = imba_invoker_alacrity.buff_effect_path})
			end

			if not added_to_invoker then
				caster:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
					duration = alacrity_duration, 
					bonus_attack_speed = bonus_attack_speed, 
					bonus_damage = bonus_damage, 
					ability_effect = imba_invoker_alacrity.ability_effect_path,
					buff_effect = imba_invoker_alacrity.buff_effect_path})
			end
		else
			target:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
				duration = alacrity_duration, 
				bonus_attack_speed = bonus_attack_speed, 
				bonus_damage = bonus_damage, 
				ability_effect = imba_invoker_alacrity.ability_effect_path,
				buff_effect = imba_invoker_alacrity.buff_effect_path})
		end

		-- Set client-values for alacrity
		CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { alacrity_bonus_damage = bonus_damage, alacrity_attack_speed = bonus_attack_speed,})
	end
end

--------------------------------------------------------------------------------------------------------------------
--	Invoker's Alacrity modifier
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_alacrity = class({})
function modifier_imba_invoker_alacrity:IsHidden() return false end
function modifier_imba_invoker_alacrity:IsPurgable() return false end
function modifier_imba_invoker_alacrity:IsBuff() return true end
function modifier_imba_invoker_alacrity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
	return funcs
end

function modifier_imba_invoker_alacrity:OnCreated(kv)
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.parent 			= self:GetParent()
		self.bonus_damage 		= kv.bonus_damage
		self.bonus_attack_speed = kv.bonus_attack_speed

		self.alacrity_effect_1 	= ParticleManager:CreateParticle(kv.ability_effect, PATTACH_OVERHEAD_FOLLOW, self.parent)
		self.alacrity_effect_2 	= ParticleManager:CreateParticle(kv.buff_effect, PATTACH_OVERHEAD_FOLLOW, self.parent)
	else
		local net_table 		= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_damage 		= net_table.alacrity_bonus_damage or 0
		self.bonus_attack_speed = net_table.alacrity_attack_speed or 0
	end
end

function modifier_imba_invoker_alacrity:OnRemoved()
	if IsServer() then
		if self.alacrity_effect_1 ~= nil then
			ParticleManager:DestroyParticle(self.alacrity_effect_1, false)
		end

		if self.alacrity_effect_2 ~= nil then
			ParticleManager:DestroyParticle(self.alacrity_effect_2, false)
		end
	end
end

function modifier_imba_invoker_alacrity:OnRefresh(kv)
	if IsServer() then
		self.bonus_damage 		= kv.bonus_damage
		self.bonus_attack_speed = kv.bonus_attack_speed
	else
		local net_table 		= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_damage 		= net_table.alacrity_bonus_damage or 0
		self.bonus_attack_speed = net_table.alacrity_attack_speed or 0
	end
end


function modifier_imba_invoker_alacrity:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed 
end

function modifier_imba_invoker_alacrity:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end



--------------------------------------------------------------------------------------------------------------------
-- Invoker's Deafening Blast
--------------------------------------------------------------------------------------------------------------------
imba_invoker_deafening_blast = class({})
imba_invoker_deafening_blast.ability_effect_path 			= "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
imba_invoker_deafening_blast.ability_disarm_effect_path 	= "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf"
imba_invoker_deafening_blast.ability_knockback_effect_path 	= "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf"
LinkLuaModifier("modifier_imba_invoker_deafening_blast", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_deafening_blast_knockback", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_deafening_blast_disarm", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_deafening_blast:CastSpell(caster, target_point)
	if IsServer() then 
		local ability 			= caster:FindAbilityByName("invoker_deafening_blast")
		local caster_location 	= caster:GetAbsOrigin()
		local quas_level 		= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local exort_level 		= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local wex_level 		= caster:FindAbilityByName("invoker_wex"):GetLevel() - 1

		-- Get skill stats
		local deafening_blast_damage 				= ability:GetLevelSpecialValueFor("damage", exort_level)
		local deafening_blast_knockback_duration 	= ability:GetLevelSpecialValueFor("knockback_duration", quas_level)
		-- took this value from wiki
		local deafening_blast_knockback_distance 	= 40 * (quas_level + 1)
		local deafening_blast_disarm_duration 		= ability:GetLevelSpecialValueFor("disarm_duration", wex_level)
		local deafening_blast_travel_distance 		= ability:GetSpecialValueFor("travel_distance")
		local deafening_blast_travel_speed 			= ability:GetSpecialValueFor("travel_speed")
		local deafening_blast_radius_start 			= ability:GetSpecialValueFor("radius_start")
		local deafening_blast_radius_end 			= ability:GetSpecialValueFor("radius_end")
		local deafening_blast_end_vision_duration 	= ability:GetSpecialValueFor("end_vision_duration")

		local direction = (target_point - caster_location):Normalized()
		-- make sure direction is horizontal
		direction.z = 0

		-- Check if we have dark_artistry_cape equipped... change buff effect accordingly
		if caster.dark_artistry_cape_deafening_blast == nil or caster.dark_artistry_cape_deafening_blast_disarm == nil or caster.dark_artistry_cape_deafening_blast_knockback == nil then
			local dark_artistry_cape = "models/items/invoker/dark_artistry/dark_artistry_cape_model.vmdl"
			local children = caster:GetChildren();
			for _,child in pairs(children) do
				 if child:GetClassname() == "dota_item_wearable" and child:GetModelName() == dark_artistry_cape then
				 	caster.dark_artistry_cape_deafening_blast 					= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
				 	caster.dark_artistry_cape_deafening_blast_disarm			= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf"		
				 	caster.dark_artistry_cape_deafening_blast_knockback 		= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf"
				 	imba_invoker_deafening_blast.ability_effect_path 			= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
				 	imba_invoker_deafening_blast.ability_disarm_effect_path 	= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_disarm_ti6_debuff.vpcf"
					imba_invoker_deafening_blast.ability_knockback_effect_path 	= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6_knockback_debuff.vpcf"			 	
				 end
			end
		else
		 	imba_invoker_deafening_blast.ability_effect_path 			= caster.dark_artistry_cape_deafening_blast
		 	imba_invoker_deafening_blast.ability_disarm_effect_path 	= caster.dark_artistry_cape_deafening_blast_disarm
			imba_invoker_deafening_blast.ability_knockback_effect_path 	= caster.dark_artistry_cape_deafening_blast_knockback
		end

		-- Play Deafening Blast sound 
		EmitSoundOn("Hero_Invoker.DeafeningBlast", caster)

		-- Trigger cooldown
		ability:UseResources(true, false, true)

		-- Create a dummy unit that will use the imba ability for us...
		local deafening_blast_dummy_unit = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeam())
		local ability_ref 				 = deafening_blast_dummy_unit:AddAbility("imba_invoker_deafening_blast")

		local deafening_blast = caster
		local num_blasts = 1
		-- Check if we have deafening blast talent
		if caster:HasTalent("imba_special_bonus_unique_invoker_7") then
			local num_deafening_blasts	= caster:FindTalentValue("imba_special_bonus_unique_invoker_7","number_of_blasts")
			num_blasts 					= num_blasts + num_deafening_blasts
		end

		ability_ref.hit_table = {}
		local degrees = 360 / num_blasts

		--Adjust the dummy unit's position each frame to match that of the tornado particle effect.
		local endTime = GameRules:GetGameTime() + (num_blasts * 0.05) + 0.20
		Timers:CreateTimer({
			endTime = 0.05,
			callback = function()
				-- Create projectile
				local deafening_blast_projectile_table = 
				{
					EffectName 				= imba_invoker_deafening_blast.ability_effect_path,
					Ability 				= ability_ref,
					vSpawnOrigin 			= caster:GetAbsOrigin(),
					vVelocity 				= direction * deafening_blast_travel_speed,
					fDistance 				= deafening_blast_travel_distance,
					fStartRadius 			= deafening_blast_radius_start,
					fEndRadius 				= deafening_blast_radius_end,
					Source 					= caster,
					bHasFrontalCone 		= true,
					bReplaceExisting 		= false,
					iUnitTargetTeam 		= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags 		= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					ExtraData = {
						deafening_blast_damage 				= deafening_blast_damage, 
						deafening_blast_knockback_duration 	= deafening_blast_knockback_duration, 
						deafening_blast_knockback_distance  = deafening_blast_knockback_distance,
						deafening_blast_disarm_duration 	= deafening_blast_disarm_duration,
						disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
						knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
					}
				}

				ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
				-- Rotate direciton for 360/num_blasts degrees
				direction = RotatePosition(Vector(0,0,0), QAngle(0, degrees, 0), direction)


				if GameRules:GetGameTime() > endTime then	
					for index = 1, num_blasts, 1 do
						-- Create projectile
						local deafening_blast_projectile_table = 
						{
							EffectName 				= imba_invoker_deafening_blast.ability_effect_path,
							Ability 				= ability_ref,
							vSpawnOrigin 			= caster:GetAbsOrigin(),
							vVelocity 				= direction * deafening_blast_travel_speed,
							fDistance 				= deafening_blast_travel_distance,
							fStartRadius 			= deafening_blast_radius_start,
							fEndRadius 				= deafening_blast_radius_end,
							Source 					= caster,
							bHasFrontalCone 		= true,
							bReplaceExisting 		= false,
							iUnitTargetTeam 		= DOTA_UNIT_TARGET_TEAM_ENEMY,
							iUnitTargetFlags 		= DOTA_UNIT_TARGET_FLAG_NONE,
							iUnitTargetType 		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							ExtraData = {
								deafening_blast_damage 				= deafening_blast_damage, 
								deafening_blast_knockback_duration 	= deafening_blast_knockback_duration, 
								deafening_blast_knockback_distance  = deafening_blast_knockback_distance,
								deafening_blast_disarm_duration 	= deafening_blast_disarm_duration,
								disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
								knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
							}
						}

						ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
						-- Rotate direciton for 360/num_blasts degrees
						direction = RotatePosition(Vector(0,0,0), QAngle(0, degrees, 0), direction)
					end

					return  
				else 
					return 0.05
				end
			end
		})

		--[[
		for index = 1, num_blasts, 1 do
			-- Create projectile
			local deafening_blast_projectile_table = 
			{
				EffectName 				= imba_invoker_deafening_blast.ability_effect_path,
				Ability 				= ability_ref,
				vSpawnOrigin 			= caster_location,
				vVelocity 				= direction * deafening_blast_travel_speed,
				fDistance 				= deafening_blast_travel_distance,
				fStartRadius 			= deafening_blast_radius_start,
				fEndRadius 				= deafening_blast_radius_end,
				Source 					= caster,
				bHasFrontalCone 		= true,
				bReplaceExisting 		= false,
				iUnitTargetTeam 		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags 		= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType 		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				ExtraData = {
					deafening_blast_damage 				= deafening_blast_damage, 
					deafening_blast_knockback_duration 	= deafening_blast_knockback_duration, 
					deafening_blast_knockback_distance  = deafening_blast_knockback_distance,
					deafening_blast_disarm_duration 	= deafening_blast_disarm_duration,
					disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
					knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
				}
			}

			ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
			-- Rotate direciton for 360/num_blasts degrees
			direction = RotatePosition(Vector(0,0,0), QAngle(0, degrees, 0), direction)
		end
		]]

		Timers:CreateTimer({
			endTime = deafening_blast_knockback_duration + deafening_blast_disarm_duration,
			callback = function()
				deafening_blast_dummy_unit:RemoveSelf()
			end
		})	
	end
end

function imba_invoker_deafening_blast:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then
			local caster = self:GetCaster()
			local target_entity_index = target:GetEntityIndex()
			-- Is this first time we hit the enemy?
			if self.hit_table[target_entity_index] == nil then
				-- add unit to hit table...
				self.hit_table[target_entity_index] = true

				-- Apply Knockback
				self:KnockBackAndDisarm(
					caster, 
					target, 
					ExtraData.deafening_blast_knockback_duration, 
					ExtraData.deafening_blast_knockback_distance, 
					ExtraData.deafening_blast_disarm_duration, 
					ExtraData.disarm_effect_path, 
					ExtraData.knockback_effect_path)
				
				-- Apply deafening blast damage
				local damage_table 			= {}
				damage_table.attacker 		= caster
				damage_table.victim			= target
				damage_table.ability 		= self
				damage_table.damage_type 	= self:GetAbilityDamageType() 
				damage_table.damage 		= ExtraData.deafening_blast_damage
				ApplyDamage(damage_table)
			end
		end
	end	
end

function imba_invoker_deafening_blast:CheckHitList(target_entity_id) 
	if self.hit_table[target_entity_id] == nil then
		self.hit_table[target_entity_id] = true
		return true
	else
		return false
	end
end

function imba_invoker_deafening_blast:KnockBackAndDisarm(caster, target, knockback_duration, knockback_distance, disarm_duration, disarm_effect_path, knockback_effect_path)
	local knockback_center = caster:GetAbsOrigin()
	local knockback_direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() 

	local knockback_effect = ParticleManager:CreateParticle(knockback_effect_path, PATTACH_ABSORIGIN_FOLLOW, target)
	target:AddNewModifier(caster, self, "modifier_imba_invoker_deafening_blast", {duration = knockback_duration})
	
	target:AddNewModifier(caster, self, "modifier_knockback", {
		center_x 			= knockback_center.x, 
		center_y 			= knockback_center.y, 
		center_z 			= knockback_center.z, 
		duration 			= knockback_duration,
		knockback_duration 	= knockback_duration,
        knockback_distance 	= knockback_distance,
        knockback_height 	= 0
	})

	Timers:CreateTimer(knockback_duration, function()
		target:AddNewModifier(caster, self, "modifier_imba_invoker_deafening_blast_disarm", {duration = disarm_duration})
		ParticleManager:DestroyParticle(knockback_effect, false)
		local disarm_effect = ParticleManager:CreateParticle(disarm_effect_path, PATTACH_ABSORIGIN_FOLLOW, target)
		Timers:CreateTimer(disarm_duration, function()
			ParticleManager:DestroyParticle(disarm_effect, false)
		end)
	end)
end
--------------------------------------------------------------------------------------------------------------------
-- Invoker's Deafening Blast modifier - provides knockback for a short duration
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_deafening_blast = class({})
function modifier_imba_invoker_deafening_blast:IsHidden() return false end
function modifier_imba_invoker_deafening_blast:IsDebuff() return true end
function modifier_imba_invoker_deafening_blast:IsPurgable() return false end
function modifier_imba_invoker_deafening_blast:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function modifier_imba_invoker_deafening_blast:GetStatusEffectName()
    return "particles/status_fx/status_effect_frost.vpcf"
end
--------------------------------------------------------------------------------------------------------------------
-- Invoker's Deafening Blast 3rd modifier - provides disarm for a short duration
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_deafening_blast_disarm = class({})
function modifier_imba_invoker_deafening_blast_disarm:IsHidden() return true end
function modifier_imba_invoker_deafening_blast_disarm:IsDebuff() return true end
function modifier_imba_invoker_deafening_blast_disarm:IsPurgable() return false end
function modifier_imba_invoker_deafening_blast_disarm:StatusEffectPriority() return 15 end
function modifier_imba_invoker_deafening_blast_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true
	}
	return state
end

---------------------------------------------------------------------------------------------------------------------
--	Invoker's Sun Strike
---------------------------------------------------------------------------------------------------------------------
imba_invoker_sun_strike = imba_invoker_sun_strike or class({})
function imba_invoker_sun_strike:CastSpell(caster, target_point, cataclysm)
	if IsServer() then 
		local caster_team		 	= caster:GetTeam()
		local ability 				= caster:FindAbilityByName("invoker_sun_strike")
		local exort_level 			= caster:FindAbilityByName("invoker_exort"):GetLevel() - 1

		-- Get the skill Stats
		local delay 					= ability:GetSpecialValueFor("delay")
		local area_of_effect 			= ability:GetSpecialValueFor("area_of_effect")
		local cataclysm_area_of_effect 	= ability:GetSpecialValueFor("cataclysm_area_of_effect")
		local damage 					= ability:GetLevelSpecialValueFor("damage", exort_level)
		local vision_distance 			= ability:GetSpecialValueFor("vision_distance")
		local vision_duration 			= ability:GetSpecialValueFor("vision_duration")
		local all_heroes 				= HeroList:GetAllHeroes()

		if cataclysm then
			local cooldown 			=  ability:GetSpecialValueFor("cataclysm_cooldown")
			local minimum_range 	=  ability:GetSpecialValueFor("cataclysm_minimum_range")
			local maximum_range 	=  ability:GetSpecialValueFor("cataclysm_maximum_range")

			-- We want to calculate the cooldown reduction before we apply the cooldown value...
			ability:UseResources(false,false,true) 
			local real_cooldown = ability:GetCooldownTime()
			local unaltered_cooldown 		= ability:GetCooldown(1)
			local cooldown_reduction_pct 	= real_cooldown / unaltered_cooldown
			ability:StartCooldown(cooldown * cooldown_reduction_pct)

			-- Cast Cataclysm Sun Strike...
			imba_invoker_sun_strike:CastCataclysmSunStrike({
				caster 				= caster,
				caster_team 		= caster_team,
				ability 			= ability,
				target_point		= target_point,
				delay 				= delay,
				area_of_effect 		= cataclysm_area_of_effect,
				damage 				= damage,
				vision_distance 	= vision_distance,
				vision_duration 	= vision_duration,
				all_heroes 			= all_heroes,
				cooldown 			= cooldown,
				minimum_range 		= minimum_range,
				maximum_range 		= maximum_range
			})
		else
			-- Trigger sun strike cooldown
			ability:UseResources(true, false, true)


			-- Cast Normal SunStrike
			imba_invoker_sun_strike:CastSunStrike(
			{
				caster 				= caster,
				caster_team 		= caster_team,
				ability 			= ability,
				target_point		= target_point,
				delay 				= delay,
				area_of_effect 		= area_of_effect,
				damage 				= damage,
				vision_distance 	= vision_distance,
				vision_duration 	= vision_duration,
				all_heroes 			= all_heroes
			})
		end		
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Casts normal pointed Sun Strike
---------------------------------------------------------------------------------------------------------------------
function imba_invoker_sun_strike:CastSunStrike(kv)
	local caster 				= kv.caster
	local caster_team		 	= kv.caster_team
	local target_point 			= kv.target_point
	local ability 				= kv.ability
	local delay 				= kv.delay
	local area_of_effect 		= kv.area_of_effect
	local damage 				= kv.damage
	local vision_distance 		= kv.vision_distance
	local vision_duration 		= kv.vision_duration
	local all_heroes 			= kv.all_heroes

	-- Create vision on target location
	local duration = delay + vision_duration
	ability:CreateVisibilityNode(target_point, vision_distance, vision_duration)

	-- Play SunStrike Sound!
	EmitSoundOn("Hero_Invoker.SunStrike.Charge", caster)

	-- For each hero...
	for _,hero in pairs(all_heroes) do
		-- That is on your team
		if hero:GetPlayerID() and hero:GetTeam() == caster_team then
			-- Show the sun strike beam
			local sun_strike_beam = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_POINT, hero, PlayerResource:GetPlayer(hero:GetPlayerID()))
			ParticleManager:SetParticleControl(sun_strike_beam, 0, target_point) 
			ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(area_of_effect,0, 0))
	
			-- Create crater after the delay
			Timers:CreateTimer(delay, function()
				ParticleManager:DestroyParticle(sun_strike_beam, false)
				local sun_strike_crater = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_POINT, hero, PlayerResource:GetPlayer(hero:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_crater, 0, target_point)
				ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(area_of_effect,0, 0))

				-- Check if we hit stuff
				local nearby_enemy_units = FindUnitsInRadius(caster:GetTeam(),
												target_point, 
												nil, 
												area_of_effect, 
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
												FIND_ANY_ORDER, 
												false)

				if nearby_enemy_units ~= nil then
					-- Damage is shared between all units hit
					imba_invoker_sun_strike:OnHit(caster, nearby_enemy_units, damage, ability)
				end

				-- Cleanup 
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(sun_strike_crater, false)
				end)
			end)
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Casts Cataclysm Sun Strike
---------------------------------------------------------------------------------------------------------------------
function imba_invoker_sun_strike:CastCataclysmSunStrike(kv)
	local caster 				= kv.caster
	local caster_team		 	= kv.caster_team
	local target_point 			= kv.target_point
	local ability 				= kv.ability
	local delay 				= kv.delay
	local area_of_effect 		= kv.area_of_effect
	local damage 				= kv.damage
	local vision_distance 		= kv.vision_distance
	local vision_duration 		= kv.vision_duration
	local all_heroes 			= kv.all_heroes
	local cooldown 				= kv.cooldown
	local minimum_range 		= kv.minimum_range
	local maximum_range 		= kv.maximum_range

	-- Create vision on target location
	local duration = delay + vision_duration
	ability:CreateVisibilityNode(target_point, vision_distance, vision_duration)

	-- Play SunStrike Sound!
	EmitSoundOn("Hero_Invoker.Cataclysm.Charge", caster)

	for _,hero in pairs(all_heroes) do
		-- Cataclysm effect! For each hero that is not on our team...
		if hero:GetPlayerID() and hero:GetTeam() ~= caster:GetTeam() and hero:IsAlive() then
			-- Create 2 random sunstrike locations
		 	local target_point1 = hero:GetAbsOrigin()  + RandomVector(math.random(minimum_range, maximum_range))
			local target_point2 = hero:GetAbsOrigin()  - RandomVector(math.random(minimum_range, maximum_range))

			ability:CreateVisibilityNode(target_point1, vision_distance, vision_duration)
			ability:CreateVisibilityNode(target_point2, vision_distance, vision_duration)

	
			EmitSoundOnLocationWithCaster(target_point1, "Hero_Invoker.Cataclysm.Ignite", caster)
			EmitSoundOnLocationWithCaster(target_point2, "Hero_Invoker.Cataclysm.Ignite", caster)

			-- For each hero...
			for _,hero2 in pairs(all_heroes) do
				-- Create sun strike beam 1
				local sun_strike_beam = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_POINT, hero2, PlayerResource:GetPlayer(hero2:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam, 0, target_point1) 
				ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(area_of_effect,0, 0))

				-- Create sun strike beam 2
				local sun_strike_beam2 = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_POINT, hero2, PlayerResource:GetPlayer(hero2:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam2, 0, target_point2) 
				ParticleManager:SetParticleControl(sun_strike_beam2, 1, Vector(area_of_effect,0, 0))
				
				Timers:CreateTimer(delay, function()
					ParticleManager:DestroyParticle(sun_strike_beam, false)
					ParticleManager:DestroyParticle(sun_strike_beam2, false)

					-- Create sun strike crater 1
					local sun_strike_crater = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_POINT, hero2, PlayerResource:GetPlayer(hero2:GetPlayerID()))
					ParticleManager:SetParticleControl(sun_strike_crater, 0, target_point1)
					ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(area_of_effect,0, 0))

					-- Create sun strike crater 2
					local sun_strike_crater2 = ParticleManager:CreateParticleForPlayer("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_POINT, hero2, PlayerResource:GetPlayer(hero2:GetPlayerID()))
					ParticleManager:SetParticleControl(sun_strike_crater2, 0, target_point2)
					ParticleManager:SetParticleControl(sun_strike_crater2, 1, Vector(area_of_effect,0, 0))

					-- If hero and cater is both invoker...
					if hero2:GetPlayerID() == caster:GetPlayerID() then
						
						-- Check if we hit stuff with sun strike 1
						local nearby_enemy_units = FindUnitsInRadius(
							caster:GetTeam(),
							target_point1, 
							nil, 
							area_of_effect, 
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
							FIND_ANY_ORDER, 
							false)

						if nearby_enemy_units ~= nil then
							imba_invoker_sun_strike:OnHit(caster, nearby_enemy_units, damage, ability)
						end

						-- Check if we hit stuff with sun strike 2
						nearby_enemy_units = FindUnitsInRadius(
							caster:GetTeam(),
							target_point2, 
							nil, 
							area_of_effect, 
							DOTA_UNIT_TARGET_TEAM_ENEMY,
							DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
							DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
							FIND_ANY_ORDER, 
							false)

						if nearby_enemy_units ~= nil then
							imba_invoker_sun_strike:OnHit(caster, nearby_enemy_units, damage, ability)
						end
					end

					-- Cleanup 
					Timers:CreateTimer(3, function()
						ParticleManager:DestroyParticle(sun_strike_crater, false)
						ParticleManager:DestroyParticle(sun_strike_crater2, false)
					end)
				end)
			end
		end
	end
end

function imba_invoker_sun_strike:OnHit(caster, enemies_hit, damage, ability)
	-- Initialize damage table
	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 
	damage_table.damage 		= damage / #enemies_hit

	-- Deal damage to each enemy hero
	for _,hero in pairs(enemies_hit) do
		damage_table.victim = hero
		ApplyDamage(damage_table)
	end
end

function imba_invoker_sun_strike:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect")
end 



--------------------------------------------------------------------------------------------------------------------
--	Invoker's Forge Spirit
--------------------------------------------------------------------------------------------------------------------
imba_invoker_forge_spirit =	imba_invoker_forge_spirit or class({})
LinkLuaModifier("modifier_imba_invoker_forge_spirit", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_forge_spirit:CastSpell(caster)
	if IsServer() then
		local ability 				= caster:FindAbilityByName("invoker_forge_spirit")
		local quas_level 			= caster:FindAbilityByName("invoker_quas"):GetLevel() - 1
		local exort_level 			= caster:FindAbilityByName("invoker_exort"):GetLevel() - 1
		local spirit_name 			= "npc_dota_invoker_forged_spirit"
		local spirit_level 			= 3;

		-- Get skill stats
		local spirit_damage 		= ability:GetLevelSpecialValueFor("spirit_damage", exort_level) 
		local spirit_hp 			= ability:GetLevelSpecialValueFor("spirit_hp", quas_level) 
		local spirit_armor 			= ability:GetLevelSpecialValueFor("spirit_armor", exort_level) 
		local spirit_attack_range 	= ability:GetLevelSpecialValueFor("spirit_attack_range", quas_level) 
		local spirit_mana 			= ability:GetLevelSpecialValueFor("spirit_mana", exort_level) 
		local spirit_duration 		= ability:GetLevelSpecialValueFor("spirit_duration", quas_level) 
		local spirit_count_quas 	= ability:GetLevelSpecialValueFor("spirit_count", quas_level)
		local spirit_count_exort 	= ability:GetLevelSpecialValueFor("spirit_count", exort_level)

		-- Initialize array
		if ability.forged_spirits == nil then
			ability.forged_spirits = {}
		end

		-- Trigger Forge Spirit Cooldown
		ability:UseResources(true, false, true)

		-- Play ForgeSpirit sound
		EmitSoundOn("Hero_Invoker.ForgeSpirit", caster)

		-- Calculate number of additional spirits we can summon
		local spirit_count
		if spirit_count_quas < spirit_count_exort then
			spirit_count = spirit_count_quas
		else
			spirit_count = spirit_count_exort
		end

		if caster:HasTalent("imba_special_bonus_unique_invoker_3") then
			local additional_spirits 	= caster:FindTalentValue("imba_special_bonus_unique_invoker_3","additional_spirits")
			spirit_count 				= spirit_count + additional_spirits
		end

		-- We dont kill off old spirits... 
		-- the limited duration and our enemies will handle that...
		-- Tho we do need to cleanup dead spirits
		local updated_spirit_array = {}
		for _,spirit in pairs(ability.forged_spirits) do
			-- lua will delete the reference in our array uppon death
			if not spirit:IsNull() then 
				table.insert(updated_spirit_array, spirit)
			end
		end

		-- Replace old array
		ability.forged_spirits = updated_spirit_array

		-- Summon new Spirits
		for i = 1, spirit_count do
			local forged_spirit = CreateUnitByName(spirit_name, caster:GetAbsOrigin() + RandomVector(100), true, caster, caster, caster:GetTeamNumber())
			-- Remove forge_spirit's base ability and add IMBA molten strike
			forged_spirit:AddAbility("imba_forged_spirit_melting_strike") 
			forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):SetLevel(1)	
			-- Apply stats to spirit
			local melt_duration 			= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("duration") 
			local max_armor_removed 		= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("max_armor_removed") 
			local melt_armor_removed 		= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("armor_removed") 
			local melt_strike_mana_cost 	= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetManaCost(1)

			forged_spirit:AddNewModifier(
				caster, 
				ability, 
				"modifier_imba_invoker_forge_spirit", 
				{	
					duration = spirit_duration, 
					melt_duration = melt_duration, 
					melt_armor_removed = melt_armor_removed,
					melt_strike_mana_cost = melt_strike_mana_cost, 
					max_armor_removed = max_armor_removed,
					spirit_attack_range = spirit_attack_range
				})


			forged_spirit:AddNewModifier(caster, ability, "modifier_kill", {duration = spirit_duration})
			forged_spirit:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.03})
			forged_spirit:SetUnitOnClearGround()
			forged_spirit:SetManaGain(spirit_mana);
			forged_spirit:CreatureLevelUp(1)

			-- Set spirit base_damage
			forged_spirit:SetBaseDamageMin(spirit_damage) 
			forged_spirit:SetBaseDamageMax(spirit_damage)
			-- Set spirit health 
			forged_spirit:SetBaseMaxHealth(spirit_hp)
			forged_spirit:SetPhysicalArmorBaseValue(spirit_armor)
			
			forged_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
			-- Add summoned spirit to array
			table.insert(ability.forged_spirits, forged_spirit)
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
-- Forge Spirit modifier
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_forge_spirit = class({})
LinkLuaModifier("modifier_imba_forged_spirit_melting_strike", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function modifier_imba_invoker_forge_spirit:IsHidden() return true end
function modifier_imba_invoker_forge_spirit:IsPassive() return true end
function modifier_imba_invoker_forge_spirit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED}
	return funcs
end

function modifier_imba_invoker_forge_spirit:OnCreated(kv)
	if IsServer() then
		self.caster					= self:GetCaster()
		self.ability 				= self:GetAbility()
		self.parent 				= self:GetParent()
		self.spirit_attack_range 	= kv.spirit_attack_range
		self.melt_duration 			= kv.melt_duration
		self.melt_strike_mana_cost  = kv.melt_strike_mana_cost
		self.max_armor_removed 		= kv.max_armor_removed
		self.melt_armor_removed 	= kv.melt_armor_removed

		self:SetStackCount(self.spirit_attack_range)
	end
end

function modifier_imba_invoker_forge_spirit:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target

		if attacker == self.parent and target:IsHero() or target:IsIllusion() then
			if attacker:GetMana() >= self.melt_strike_mana_cost then
				if target:HasModifier("modifier_imba_forged_spirit_melting_strike") then
					debuff_count = target:GetModifierStackCount("modifier_imba_forged_spirit_melting_strike", self.caster)
					if debuff_count > self.max_armor_removed then
						debuff_count = self.max_armor_removed
					end
				end

				target:AddNewModifier(
					self.parent, 
					self.ability, 
					"modifier_imba_forged_spirit_melting_strike", 
					{
						duration = self.melt_duration, 
						max_armor_removed = self.max_armor_removed,
						melt_strike_mana_cost = self.melt_strike_mana_cost,
						melt_armor_removed = self.melt_armor_removed
					})
			end
		end
	end
end

function modifier_imba_invoker_forge_spirit:GetModifierAttackRangeBonus()
	return self:GetStackCount() 
end

--------------------------------------------------------------------------------------------------------------------
-- Forge Spirit's Meling Strike
--------------------------------------------------------------------------------------------------------------------
imba_forged_spirit_melting_strike = class({})
function imba_forged_spirit_melting_strike:OnSpellStart()
end

modifier_imba_forged_spirit_melting_strike = class({})
function modifier_imba_forged_spirit_melting_strike:IsHidden() return false end
function modifier_imba_forged_spirit_melting_strike:IsDebuff() return true end
function modifier_imba_forged_spirit_melting_strike:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	return funcs
end

function modifier_imba_forged_spirit_melting_strike:GetAbilityTextureName()
	return "forged_spirit_melting_strike"
end

function modifier_imba_forged_spirit_melting_strike:GetTexture()
	return "forged_spirit_melting_strike"
end

function modifier_imba_forged_spirit_melting_strike:OnCreated(kv)
	if IsServer() then
		self.max_armor_removed 		= kv.max_armor_removed
		self.melt_strike_mana_cost 	= kv.melt_strike_mana_cost
		self.melt_armor_removed 	= kv.melt_armor_removed

		self:SetStackCount(self.melt_armor_removed)
	end
end

function modifier_imba_forged_spirit_melting_strike:OnRefresh(kv)
	if IsServer() then
		local curr_stacks = self:GetStackCount()
		if curr_stacks + self.melt_armor_removed > self.max_armor_removed then
			self:SetStackCount(self.max_armor_removed)
		else
			self:SetStackCount(curr_stacks + self.melt_armor_removed)
		end

		self:GetCaster():SpendMana(self.melt_strike_mana_cost, nil)
	end
end

function modifier_imba_forged_spirit_melting_strike:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * -1
end	



--------------------------------------------------------------------------------------------------------------------
--	Invoker's: Choas Meteor
--------------------------------------------------------------------------------------------------------------------
imba_invoker_chaos_meteor = class({})
imba_invoker_chaos_meteor.loop_interval = 0.03
LinkLuaModifier("modifier_imba_invoker_chaos_meteor", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_invoker_chaos_meteor_burn", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
function imba_invoker_chaos_meteor:CastSpell(caster, target_point)
	if IsServer() then
		local ability 							= caster:FindAbilityByName("invoker_chaos_meteor")
		local caster_location 					= caster:GetAbsOrigin()

		local caster_location_ground 			= Vector(caster_location.x, caster_location.y, 0)
		local target_point_ground 				= Vector(target_point.x, target_point.y, 0)

		local wex_level 						= caster:FindAbilityByName("invoker_wex"):GetLevel() - 1
		local exort_level 						= caster:FindAbilityByName("invoker_exort"):GetLevel() - 1

		local chaos_meteor_travel_distance 		= ability:GetLevelSpecialValueFor("travel_distance", wex_level)
		local chaos_meteor_main_dmg				= ability:GetLevelSpecialValueFor("main_damage", exort_level)
		local chaos_meteor_burn_dps				= ability:GetLevelSpecialValueFor("burn_dps", exort_level)

		local chaos_meteor_travel_speed 		= ability:GetSpecialValueFor("travel_speed")
		local chaos_meteor_land_time 			= ability:GetSpecialValueFor("land_time")
		local chaos_meteor_burn_duration 		= ability:GetSpecialValueFor("burn_duration")
		local chaos_meteor_burn_dps_inverval	= ability:GetSpecialValueFor("burn_dps_inverval")
		local chaos_meteor_damage_interval		= ability:GetSpecialValueFor("damage_interval")
		local chaos_meteor_vision_distance 		= ability:GetSpecialValueFor("vision_distance")
		local chaos_meteor_end_vision_duration 	= ability:GetSpecialValueFor("end_vision_duration")
		local chaos_meteor_area_of_effect 		= ability:GetSpecialValueFor("area_of_effect")
		
		local location_difference_normalized 	= ( target_point_ground - caster_location_ground):Normalized()
		local chaos_meteor_velocity 			= location_difference_normalized * chaos_meteor_travel_speed
		local chaos_meteor_velocity_per_frame 	= chaos_meteor_velocity * .03
		local chaos_meteor_duration 			= chaos_meteor_travel_distance / chaos_meteor_travel_speed

		-- Check if we have chaos meteor talent
		if caster:HasTalent("imba_special_bonus_unique_invoker_2") then
			local reduced_damage_interval = caster:FindTalentValue("imba_special_bonus_unique_invoker_2", "reduced_damage_interval")
			chaos_meteor_damage_interval = chaos_meteor_damage_interval - reduced_damage_interval
		end 

		--print("values", chaos_meteor_damage_interval, chaos_meteor_burn_dps_inverval, chaos_meteor_burn_duration, chaos_meteor_main_dmg, chaos_meteor_burn_dps)

		-- Play Chaos Meteor Sounds
		EmitSoundOn("Hero_Invoker.ChaosMeteor.Cast", caster)
		EmitSoundOn("Hero_Invoker.ChaosMeteor.Loop", caster)

		-- Trigger Chaos Meteor Cooldown
		ability:UseResources(true, false, true)		

		-- Create start_point of the meteor 1000z up in the air! Meteors velocity is same while falling through the air as it is rolling on the ground.
		local chaos_meteor_fly_original_point = (target_point - (chaos_meteor_velocity * chaos_meteor_land_time)) + Vector (0, 0, 1000)
		--Create the particle effect consisting of the meteor falling from the sky and landing at the target point.
		local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)		
		--local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/hero/invoker/invoker_chaos_meteor_mini.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, chaos_meteor_fly_original_point)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(chaos_meteor_land_time, 0, 0))
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 3, Vector(0.3, 0, 0))

		local chaos_meteor_dummy_unit = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		chaos_meteor_dummy_unit:AddAbility("imba_invoker_chaos_meteor")

		local chaos_meteor_unit_ability = chaos_meteor_dummy_unit:FindAbilityByName("imba_invoker_chaos_meteor")
		if chaos_meteor_unit_ability ~= nil then
			chaos_meteor_unit_ability:SetLevel(1)
			-- Would be bad if the game engine decided to interract with the meteor dummy... We hide it with modifier!
			chaos_meteor_dummy_unit:AddNewModifier(	
				caster, 
				chaos_meteor_unit_ability, 
				"modifier_imba_invoker_chaos_meteor", 
				{
					duration 				= -1,
					chaos_meteor_duration 	= chaos_meteor_duration,
					burn_duration 			= chaos_meteor_burn_duration,
					main_dmg 				= chaos_meteor_main_dmg,
					burn_dps 				= chaos_meteor_burn_dps,
					burn_dps_inverval 		= chaos_meteor_burn_dps_inverval,
					damage_interval 		= chaos_meteor_damage_interval,
					area_of_effect 			= chaos_meteor_area_of_effect 
				})
		end

		-- Set meteor vision
		chaos_meteor_dummy_unit:SetDayTimeVisionRange(chaos_meteor_vision_distance)
		chaos_meteor_dummy_unit:SetNightTimeVisionRange(chaos_meteor_vision_distance)
	
		-- Meteor Projectile object
		local meteor_projectile_obj =  
		{
			EffectName 				= "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
			Ability 				= chaos_meteor_unit_ability,
			vSpawnOrigin 			= target_point,
			fDistance 				= chaos_meteor_travel_distance,
			fStartRadius 			= chaos_meteor_area_of_effect,
			fEndRadius 				= chaos_meteor_area_of_effect,
			Source 					= caster,
			bHasFrontalCone 		= false,
			iMoveSpeed 				= chaos_meteor_travel_speed,
			bReplaceExisting 		= false,
			bProvidesVision 		= true,
			iVisionTeamNumber 		= caster:GetTeam(),
			iVisionRadius 			= chaos_meteor_vision_distance,
			bDrawsOnMinimap 		= false,
			bVisibleToEnemies 		= true, 
			iUnitTargetTeam 		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags 		= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType 		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 			= GameRules:GetGameTime() + chaos_meteor_land_time + chaos_meteor_duration + chaos_meteor_end_vision_duration,
			ExtraData 				= {
				chaos_meteor_main_dmg = chaos_meteor_main_dmg, 
				ability = ability
			}
		}

		meteor_projectile_obj.vVelocity 			= chaos_meteor_velocity

		local number_of_loops 						= math.floor(chaos_meteor_duration / 0.03)
		local rounding_error						= math.fmod((chaos_meteor_duration / 0.03), 1)
		local rounding_error_vector					= chaos_meteor_velocity / rounding_error / number_of_loops
		local chaos_meteor_velocity_per_frame 		= (chaos_meteor_velocity + rounding_error_vector) * 0.03
 		local chaos_meteor_dummy_position 			= target_point-- + chaos_meteor_velocity_per_frame + chaos_meteor_velocity_per_frame+ chaos_meteor_velocity_per_frame

		-- Run stuff after meteor lands
		Timers:CreateTimer({
			endTime = chaos_meteor_land_time,
			callback = function()
				-- once meteor lands we move the sound source to the meteor instead
				caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
				-- Play meteor sound 
				chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
				chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

				local chaos_meteor_projectile = ProjectileManager:CreateLinearProjectile(meteor_projectile_obj)

				-- Adjust the dummy unit's position each frame to match that of the meteor's particle effect.
				local endTime = GameRules:GetGameTime() + chaos_meteor_duration
				Timers:CreateTimer({
					endTime = imba_invoker_chaos_meteor.loop_interval,
					callback = function()				
						chaos_meteor_dummy_position = chaos_meteor_dummy_position + chaos_meteor_velocity_per_frame
						chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_position)
						-- For debug purpose, shows where the dummy ends in relation to the effect
						--DebugDrawCircle(chaos_meteor_dummy_position, Vector(255,0,255), 255, 64, true, 5)
						if GameRules:GetGameTime() > endTime then
							-- Stop / Play meteor sounds 
							chaos_meteor_dummy_unit:StopSound("Hero_Invoker.ChaosMeteor.Loop")
							chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Destroy")

							-- The dummy is slightly behind the actual meteor. Move it forward abit to provide more accurate vision of the final location.
							chaos_meteor_dummy_position = chaos_meteor_dummy_position + (chaos_meteor_velocity * (chaos_meteor_vision_distance/chaos_meteor_travel_speed))
							
							-- For debug purpose, shows where the dummy ends in relation to the effect
							-- DebugDrawCircle(chaos_meteor_dummy_position, Vector(255,0,255), 255, 64, true, 20)
							chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_position)
							--Have the dummy unit linger in the position the meteor ended up in, in order to provide vision.
							Timers:CreateTimer({
								endTime = chaos_meteor_end_vision_duration,
								callback = function()
									-- Remove the dummy unit after the burn damage modifiers are guaranteed to have expired.
									Timers:CreateTimer({
										endTime = chaos_meteor_burn_duration,
										callback = function()
											chaos_meteor_dummy_unit:RemoveSelf()
										end
									})
								end
							})
							return 
						else 
							return imba_invoker_chaos_meteor.loop_interval
						end
					end
				})
			end
		})		
	end
end

function imba_invoker_chaos_meteor:CastNormalMetero(caster, ability, target_point)
	if IsServer() then

		-- Play Chaos Meteor Sounds
		EmitSoundOn("Hero_Invoker.ChaosMeteor.Cast", caster)
		EmitSoundOn("Hero_Invoker.ChaosMeteor.Loop", caster)

		-- Create start_point of the meteor 1000z up in the air! Meteors velocity is same while falling through the air as it is rolling on the ground.
		local chaos_meteor_fly_original_point = (target_point - (ability.chaos_meteor_velocity * ability.chaos_meteor_land_time)) + Vector (0, 0, 1000)
		--Create the particle effect consisting of the meteor falling from the sky and landing at the target point.
		local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)		
		--local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/hero/invoker/invoker_chaos_meteor_mini.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, chaos_meteor_fly_original_point)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(ability.chaos_meteor_land_time, 0, 0))
		ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 3, Vector(0.3, 0, 0))

		local chaos_meteor_dummy_unit = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		chaos_meteor_dummy_unit:AddAbility("imba_invoker_chaos_meteor")

		local chaos_meteor_unit_ability = chaos_meteor_dummy_unit:FindAbilityByName("imba_invoker_chaos_meteor")
		if chaos_meteor_unit_ability ~= nil then
			chaos_meteor_unit_ability:SetLevel(1)
			-- Would be bad if the game engine decided to interract with the meteor dummy... We hide it with modifier!
			chaos_meteor_dummy_unit:AddNewModifier(	
				caster, 
				chaos_meteor_unit_ability, 
				"modifier_imba_invoker_chaos_meteor", 
				{
					duration 				= -1,
					chaos_meteor_duration 	= ability.chaos_meteor_duration,
					burn_duration 			= ability.chaos_meteor_burn_duration,
					main_dmg 				= ability.chaos_meteor_main_dmg,
					burn_dps 				= ability.chaos_meteor_burn_dps,
					burn_dps_inverval 		= ability.chaos_meteor_burn_dps_inverval,
					damage_interval 		= ability.chaos_meteor_damage_interval,
					area_of_effect 			= ability.chaos_meteor_area_of_effect 
				})
		end

		-- Set meteor vision
		chaos_meteor_dummy_unit:SetDayTimeVisionRange(ability.chaos_meteor_vision_distance)
		chaos_meteor_dummy_unit:SetNightTimeVisionRange(ability.chaos_meteor_vision_distance)
	
		-- Meteor Projectile object
		local meteor_projectile_obj =  
		{
			EffectName 				= "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
			Ability 				= chaos_meteor_unit_ability,
			vSpawnOrigin 			= target_point,
			fDistance 				= ability.chaos_meteor_travel_distance,
			fStartRadius 			= ability.chaos_meteor_area_of_effect,
			fEndRadius 				= ability.chaos_meteor_area_of_effect,
			Source 					= caster,
			bHasFrontalCone 		= false,
			iMoveSpeed 				= ability.chaos_meteor_travel_speed,
			bReplaceExisting 		= false,
			bProvidesVision 		= true,
			iVisionTeamNumber 		= caster:GetTeam(),
			iVisionRadius 			= ability.chaos_meteor_vision_distance,
			bDrawsOnMinimap 		= false,
			bVisibleToEnemies 		= true, 
			iUnitTargetTeam 		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags 		= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType 		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 			= GameRules:GetGameTime() + ability.chaos_meteor_land_time + ability.chaos_meteor_duration + ability.chaos_meteor_end_vision_duration,
			ExtraData 				= {
				chaos_meteor_main_dmg = ability.chaos_meteor_main_dmg, 
				ability = ability
			}
		}

		meteor_projectile_obj.vVelocity 			= ability.chaos_meteor_velocity

		local number_of_loops 						= math.floor(ability.chaos_meteor_duration / 0.03)
		local rounding_error						= math.fmod((ability.chaos_meteor_duration / 0.03), 1)
		local rounding_error_vector					= ability.chaos_meteor_velocity / rounding_error / number_of_loops
		local chaos_meteor_velocity_per_frame 		= (ability.chaos_meteor_velocity + rounding_error_vector) * 0.03
 		local chaos_meteor_dummy_position 			= target_point-- + chaos_meteor_velocity_per_frame + chaos_meteor_velocity_per_frame+ chaos_meteor_velocity_per_frame

		-- Run stuff after meteor lands
		Timers:CreateTimer({
			endTime = ability.chaos_meteor_land_time,
			callback = function()
				-- once meteor lands we move the sound source to the meteor instead
				caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
				-- Play meteor sound 
				chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
				chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

				local chaos_meteor_projectile = ProjectileManager:CreateLinearProjectile(meteor_projectile_obj)

				-- Adjust the dummy unit's position each frame to match that of the meteor's particle effect.
				local endTime = GameRules:GetGameTime() + ability.chaos_meteor_duration
				Timers:CreateTimer({
					endTime = imba_invoker_chaos_meteor.loop_interval,
					callback = function()				
						chaos_meteor_dummy_position = chaos_meteor_dummy_position + ability.chaos_meteor_velocity_per_frame
						chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_position)
						-- For debug purpose, shows where the dummy ends in relation to the effect
						--DebugDrawCircle(chaos_meteor_dummy_position, Vector(255,0,255), 255, 64, true, 5)
						if GameRules:GetGameTime() > endTime then
							-- Stop / Play meteor sounds 
							chaos_meteor_dummy_unit:StopSound("Hero_Invoker.ChaosMeteor.Loop")
							chaos_meteor_dummy_unit:EmitSound("Hero_Invoker.ChaosMeteor.Destroy")

							-- The dummy is slightly behind the actual meteor. Move it forward abit to provide more accurate vision of the final location.
							chaos_meteor_dummy_position = chaos_meteor_dummy_position + (ability.chaos_meteor_velocity * (ability.chaos_meteor_vision_distance/ability.chaos_meteor_travel_speed))
							
							-- For debug purpose, shows where the dummy ends in relation to the effect
							-- DebugDrawCircle(chaos_meteor_dummy_position, Vector(255,0,255), 255, 64, true, 20)
							chaos_meteor_dummy_unit:SetAbsOrigin(chaos_meteor_dummy_position)
							--Have the dummy unit linger in the position the meteor ended up in, in order to provide vision.
							Timers:CreateTimer({
								endTime = ability.chaos_meteor_end_vision_duration,
								callback = function()
									-- Remove the dummy unit after the burn damage modifiers are guaranteed to have expired.
									Timers:CreateTimer({
										endTime = ability.chaos_meteor_burn_duration,
										callback = function()
											chaos_meteor_dummy_unit:RemoveSelf()
										end
									})
								end
							})
							return 
						else 
							return imba_invoker_chaos_meteor.loop_interval
						end
					end
				})
			end
		})		
	end
end

function imba_invoker_chaos_meteor:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target ~= nil then
		-- Apply meteor main dmg
		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.victim			= target
		damage_table.ability 		= self
		damage_table.damage_type 	= self:GetAbilityDamageType() 
		damage_table.damage 		= ExtraData.chaos_meteor_main_dmg
		ApplyDamage(damage_table)
	end
end

--------------------------------------------------------------------------------------------------------------------
-- Chaos Meteor modifier - applies burn debuff and damage. also hides dummy unit from game 
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_chaos_meteor = class({})
modifier_imba_invoker_chaos_meteor.loop_interval = 0.03
function modifier_imba_invoker_chaos_meteor:IsHidden() return false end
function modifier_imba_invoker_chaos_meteor:IsBuff() return false end
function modifier_imba_invoker_chaos_meteor:IsDebuff() return false end
function modifier_imba_invoker_chaos_meteor:IsPassive() return false end
function modifier_imba_invoker_chaos_meteor:IsPurgable() return false end
function modifier_imba_invoker_chaos_meteor:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO]	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_OUT_OF_GAME]		= true,
		[MODIFIER_STATE_NO_HEALTH_BAR]		= true,
		[MODIFIER_STATE_ROOTED] 			= true,
	}
	return state
end

function modifier_imba_invoker_chaos_meteor:OnCreated(kv)
	if IsServer() then
		self.caster 				= self:GetCaster()
		self.ability 				= self:GetAbility()
		self.GetTeam 				= self:GetParent():GetTeam()
		self.chaos_meteor_duration 	= kv.chaos_meteor_duration
		self.damage_interval 		= kv.damage_interval
		self.main_dmg 				= kv.main_dmg
		self.burn_duration 			= kv.burn_duration
		self.burn_dps 				= kv.burn_dps
		self.burn_dps_inverval		= kv.burn_dps_inverval 
		self.area_of_effect 		= kv.area_of_effect

		self:StartIntervalThink(kv.damage_interval)
	end
end

function modifier_imba_invoker_chaos_meteor:OnIntervalThink()
	if IsServer() then
		-- Find enemies close enought to be affected by the meteor
		local nearby_enemy_units = FindUnitsInRadius(
												self.GetTeam, 
												self:GetParent():GetAbsOrigin(), 
												nil, 
												self.area_of_effect, 
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

		for _,enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				-- Add burn debuff
				enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_invoker_chaos_meteor_burn", {
																												duration 			= self.burn_duration,
																												burn_dps 			= self.burn_dps,
																												burn_dps_inverval 	= self.burn_dps_inverval
																											})
				-- Apply meteor main dmg
				local damage_table 			= {}
				damage_table.attacker 		= self.caster
				damage_table.victim			= enemy
				damage_table.ability 		= self.ability
				damage_table.damage_type 	= self.ability:GetAbilityDamageType() 
				damage_table.damage 		= self.main_dmg
				ApplyDamage(damage_table)
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------------------
-- Chaos Meteor burn modifier - applies burn damage per dps interval
--------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_chaos_meteor_burn = class({})
function modifier_imba_invoker_chaos_meteor_burn:IsDebuff() return true end
function modifier_imba_invoker_chaos_meteor_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_invoker_chaos_meteor_burn:OnCreated(kv) 
	if IsServer() then
		self.caster 			= self:GetCaster()
		self.parent 			= self:GetParent()
		self.ability 			= self:GetAbility()
		self.damage_type 		= self.ability:GetAbilityDamageType() 
		self.burn_dps_inverval 	= kv.burn_dps_inverval
		self.burn_dps 			= kv.burn_dps

		self:StartIntervalThink(self.burn_dps_inverval)
	end
end

function modifier_imba_invoker_chaos_meteor_burn:OnIntervalThink()
	if IsServer() then
		-- Apply meteor debuff burn dmg
		local damage_table 			= {}
		damage_table.attacker 		= self.caster
		damage_table.victim			= self.parent
		damage_table.ability 		= self.ability
		damage_table.damage_type 	= self.damage_type
		damage_table.damage 		= self.burn_dps
		ApplyDamage(damage_table)
	end
end
