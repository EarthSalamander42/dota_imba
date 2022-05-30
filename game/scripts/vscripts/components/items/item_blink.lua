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
--

--	Author: AtroCty
--	Date: 			15.09.2016
--	Last Update:	03.03.2017
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger definition
-----------------------------------------------------------------------------------------------------------
if item_imba_blink == nil then item_imba_blink = class({}) end
LinkLuaModifier( "modifier_imba_blink_dagger_handler", "components/items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown

-- function item_imba_blink:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
-- end

function item_imba_blink:GetBehavior()
	if IsServer() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end
end

function item_imba_blink:GetIntrinsicModifierName()
	return "modifier_imba_blink_dagger_handler"
end

function item_imba_blink:GetCastRange(location, target)
	if IsClient() then
		return self:GetSpecialValueFor("max_blink_range") - self:GetCaster():GetCastRangeBonus()
	end
end

function item_imba_blink:OnAbilityPhaseStart()
	if self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
	-- double tap
		for _, ent in pairs(Entities:FindAllByClassname("ent_dota_fountain")) do
			if ent:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				self:GetCaster():SetCursorTargetingNothing(true)
				if self:GetCaster().GetPlayerID then
					self:GetCaster():CastAbilityOnPosition(ent:GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
				elseif self:GetCaster():GetOwner().GetPlayerID then
					self:GetCaster():CastAbilityOnPosition(ent:GetAbsOrigin(), self, self:GetCaster():GetOwner():GetPlayerID())
				end
				
				break
			end
		end
	end
	
	return true
end

function item_imba_blink:OnSpellStart()
	if self:GetCursorTarget() or self:GetCursorTarget() == self:GetCaster() then self:EndCooldown() return end

	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()

	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")

	-- Set distance if targeted destiny is beyond range
	if distance > max_blink_range then
		-- Extra parameters
		local max_extra_distance = self:GetSpecialValueFor("max_extra_distance")
		local max_extra_cooldown = self:GetSpecialValueFor("max_extra_cooldown")

		-- Calculate total overshoot distance
		if distance > max_extra_distance then
			target_point = origin_point + (target_point - origin_point):Normalized() * max_extra_distance
			-- Timers:CreateTimer(0.03, function()
				-- self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown)
			-- end)

			-- -- Calculate cooldown increase if between the two extremes
		-- else
			-- local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			-- Timers:CreateTimer(0.03, function()
				-- self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction)
			-- end)
		-- end
		end
	end

	caster:Blink(target_point, false, true)
end

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger Handler
-----------------------------------------------------------------------------------------------------------
if modifier_imba_blink_dagger_handler == nil then modifier_imba_blink_dagger_handler = class({}) end

function modifier_imba_blink_dagger_handler:IsHidden()		return true end
function modifier_imba_blink_dagger_handler:IsPurgable()	return false end
function modifier_imba_blink_dagger_handler:RemoveOnDeath()	return false end
function modifier_imba_blink_dagger_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_blink_dagger_handler:DeclareFunctions()
	if IMBA_MUTATION and IMBA_MUTATION["positive"] == "super_blink" then return {} end
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_imba_blink_dagger_handler:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")

	local parent = self:GetParent()					-- Modifier carrier
	local unit = keys.unit							-- Who took damage

	if parent == unit and keys.attacker:GetTeam() ~= parent:GetTeam() then
		-- Custom function from funcs.lua
		if keys.attacker:IsHeroDamage(keys.damage) then
			if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
				ability:StartCooldown(blink_damage_cooldown)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Blink Boots definition
-----------------------------------------------------------------------------------------------------------
if item_imba_blink_boots == nil then item_imba_blink_boots = class({}) end
LinkLuaModifier( "modifier_imba_blink_boots_handler", "components/items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown + item bonuses
LinkLuaModifier( "modifier_imba_blink_boots_flash_step", "components/items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set 

function item_imba_blink_boots:GetBehavior()
	if IsServer() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end
end

function item_imba_blink_boots:GetIntrinsicModifierName()
	return "modifier_imba_blink_boots_handler" end

function item_imba_blink_boots:OnAbilityPhaseStart()
	if self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
		for _, building in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
			if string.find(building:GetName(), "ent_dota_fountain") then
				-- target_point = origin_point + (building:GetAbsOrigin() - origin_point):Normalized() * max_blink_range
				self:GetCaster():SetCursorTargetingNothing(true)
				self:GetCaster():CastAbilityOnPosition(building:GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
				break
			end
		end
	end

	return true
end

function item_imba_blink_boots:OnSpellStart()
	if self:GetCursorTarget() or self:GetCursorTarget() == self:GetCaster() then self:EndCooldown() return end

	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()

	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")
	local sweet_spot_min = self:GetSpecialValueFor("sweet_spot_min")

	-- Set distance if targeted destiny is beyond range
	if distance > max_blink_range then
		-- People don't like this increased CD mechanic so let's remove it
		-- Extra parameters
		--local max_extra_distance = self:GetSpecialValueFor("max_extra_distance")
		--local max_extra_cooldown = self:GetSpecialValueFor("max_extra_cooldown")
		
		-- -- Calculate total overshoot distance
		-- if distance > max_extra_distance then
			-- target_point = origin_point + (target_point - origin_point):Normalized() * max_extra_distance
			-- Timers:CreateTimer(0.03, function()
				-- self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown)
			-- end)

			-- -- Calculate cooldown increase if between the two extremes
		-- else
			-- local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			-- Timers:CreateTimer(0.03, function()
				-- self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction)
			-- end)
		-- end
		
		target_point = origin_point + (target_point - origin_point):Normalized() * max_blink_range
	end

	if not self:GetCursorTarget() and distance >= sweet_spot_min and distance <= max_blink_range and not caster:HasModifier("modifier_imba_blink_boots_flash_step") then
		-- Activate flash step (and use random particle effect)
		Timers:CreateTimer(FrameTime(), function()
		local particle = ParticleManager:CreateParticle("particles/econ/items/meepo/meepo_colossal_crystal_chorus/meepo_divining_rod_poof_end_explosion_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 6, Vector(0, 255, 255))
			ParticleManager:ReleaseParticleIndex(particle)
			caster:AddNewModifier(caster, self, "modifier_imba_blink_boots_flash_step", {duration = self:GetSpecialValueFor("flash_step_cooldown")})

			self:EndCooldown()
		end)
	end

	caster:Blink(target_point, false, true)
end

-----------------------------------------------------------------------------------------------------------
--	Blink Boots Handler
-----------------------------------------------------------------------------------------------------------
if modifier_imba_blink_boots_handler == nil then modifier_imba_blink_boots_handler = class({}) end
function modifier_imba_blink_boots_handler:IsHidden() return true end
function modifier_imba_blink_boots_handler:IsDebuff() return false end
function modifier_imba_blink_boots_handler:IsPurgable() return false end
function modifier_imba_blink_boots_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_blink_boots_handler:DeclareFunctions()
	if IMBA_MUTATION and IMBA_MUTATION["positive"] == "super_blink" then
		return {MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE}
	else
		return {
			MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	end
end

function modifier_imba_blink_boots_handler:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end

function modifier_imba_blink_boots_handler:OnTakeDamage( keys )
	if self:GetAbility() then
		if self:GetParent() == keys.unit and keys.attacker:GetTeam() ~= self:GetParent():GetTeam() then
			-- Custom function from funcs.lua
			if keys.attacker:IsHeroDamage(keys.damage) then
				if self:GetAbility():GetCooldownTimeRemaining() < self:GetAbility():GetSpecialValueFor("blink_damage_cooldown") then
					self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("blink_damage_cooldown"))
				end
			end
		end
	end
end

modifier_imba_blink_boots_flash_step = class ({})
function modifier_imba_blink_boots_flash_step:IsDebuff() 		return true end
function modifier_imba_blink_boots_flash_step:IsPurgable() 		return false end
function modifier_imba_blink_boots_flash_step:IgnoreTenacity()	return true end

function modifier_imba_blink_boots_flash_step:GetTexture()
	return "modifiers/imba_blink_boots"
end
