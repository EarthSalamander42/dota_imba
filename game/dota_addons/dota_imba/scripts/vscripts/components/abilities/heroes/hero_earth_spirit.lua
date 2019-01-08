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
--     Zimberzimber 2018.5.4

---------------------------------------------------------------------
-------------------------	Stone Remnant	-------------------------
---------------------------------------------------------------------
imba_earth_spirit_stone_remnant = imba_earth_spirit_stone_remnant or class({})
LinkLuaModifier("modifier_imba_earth_spirit_remnant_handler", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)	-- Remnant Handler + Earths Mark on attack
LinkLuaModifier("modifier_imba_stone_remnant", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)					-- Remnant Modifier
LinkLuaModifier("modifier_imba_earths_mark", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)					-- Earths Mark
LinkLuaModifier("modifier_imba_earth_spirit_layout_fix", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)		-- 6 slot layout fix

function imba_earth_spirit_stone_remnant:IsNetherWardStealable() return false end
function imba_earth_spirit_stone_remnant:IsInnateAbility() return true end
function imba_earth_spirit_stone_remnant:IsStealable() return false end

function imba_earth_spirit_stone_remnant:GetManaCost()
	return self:GetSpecialValueFor("overdraw_base_cost") * ((self:GetCaster():GetModifierStackCount("modifier_imba_earth_spirit_remnant_handler", self:GetCaster()) - 1) ^ self:GetSpecialValueFor("overdraw_cost_multiplier"))
end

function imba_earth_spirit_stone_remnant:GetBehavior()
	if IsServer() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
	end
end

function imba_earth_spirit_stone_remnant:OnAbilityPhaseStart()
	if IsServer() then
		if not self.handler then
			self.handler = self:GetCaster():FindModifierByName("modifier_imba_earth_spirit_remnant_handler")
		end
		return true
	end
end

function imba_earth_spirit_stone_remnant:GetIntrinsicModifierName()
	return "modifier_imba_earth_spirit_remnant_handler" end

function imba_earth_spirit_stone_remnant:OnSpellStart()
	if IsServer() then
		if self.handler then
			self.handler:OnCreated()
		else
			self.handler = caster:FindModifierByName("modifier_imba_earth_spirit_remnant_handler")
		end
		
		local caster = self:GetCaster()
		local target = self:GetCursorPosition()
		local unit = self:GetCursorTarget()
		local remnantDuration = self:GetSpecialValueFor("remnant_duration")
		local effectRadius = self:GetSpecialValueFor("effect_radius")
		local visionDuration = self:GetSpecialValueFor("vision_duration")
		
		-- self casting sets the target as caster target + 100 units forward
		if unit == caster then
			target = caster:GetAbsOrigin() + caster:GetForwardVector() * 100
		end
		
		local dummy = CreateUnitByName("npc_imba_dota_earth_spirit_stone", target, false, caster, nil, caster:GetTeamNumber())
		dummy:AddNewModifier(caster, self, "modifier_imba_stone_remnant", {duration = remnantDuration})
		EmitSoundOn("Hero_EarthSpirit.StoneRemnant.Impact", dummy)
		self.handler:NewRemnant(dummy:GetEntityIndex())
		
		if caster:HasTalent("special_bonus_imba_earth_spirit_1") then
			dummy:SetDayTimeVisionRange(caster:FindTalentValue("special_bonus_imba_earth_spirit_1"))
			dummy:SetNightTimeVisionRange(caster:FindTalentValue("special_bonus_imba_earth_spirit_1"))
		else
			self:CreateVisibilityNode(target, effectRadius, visionDuration)
		end
		
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, effectRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, enemy in ipairs(enemies) do
			local mark = enemy:FindModifierByName("modifier_imba_earths_mark")
			if mark then
				mark:IncrementStackCount()
			else
				enemy:AddNewModifier(caster, self, "modifier_imba_earths_mark", {duration = self:GetSpecialValueFor("earths_mark_duration")})
			end
		end
	end
end

function imba_earth_spirit_stone_remnant:OnUpgrade()
	if IsServer() then self:CheckScepter() end end

function imba_earth_spirit_stone_remnant:OnInventoryContentsChanged()
	if IsServer() then self:CheckScepter() end end

function imba_earth_spirit_stone_remnant:CheckScepter()
	local caster = self:GetCaster()
	if not caster:HasModifier("modifier_imba_earth_spirit_layout_fix") then
		caster:AddNewModifier(caster, self, "modifier_imba_earth_spirit_layout_fix", {})
	end
	
	local petrify = caster:FindAbilityByName("imba_earth_spirit_petrify")
	if petrify then
		if caster:HasScepter() then
			petrify:SetActivated(true)
		else
			petrify:SetActivated(false)
		end
	end
end

function imba_earth_spirit_stone_remnant:KillRemnant(remnantID)
	if IsServer() then
		self.handler:KillRemnant(remnantID)
	end
end

-----	Stone Remnant recharge modifier
modifier_imba_earth_spirit_remnant_handler = modifier_imba_earth_spirit_remnant_handler or class({})
function modifier_imba_earth_spirit_remnant_handler:RemoveOnDeath() return false end
function modifier_imba_earth_spirit_remnant_handler:DestroyOnExpire() return false end
function modifier_imba_earth_spirit_remnant_handler:IsDebuff() return true end
function modifier_imba_earth_spirit_remnant_handler:IsHidden()
	if self:GetStackCount() > 1 then return false end
	return true
end

function modifier_imba_earth_spirit_remnant_handler:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ATTACK_LANDED } end

function modifier_imba_earth_spirit_remnant_handler:OnCreated()
	if IsServer() then
		self.overdrawCooldown = self:GetAbility():GetSpecialValueFor("overdraw_cooldown")
		self.noCostRemnants = self:GetAbility():GetSpecialValueFor("no_cost_remnants")
		self.overdrawCooldown = self:GetAbility():GetSpecialValueFor("overdraw_cooldown")
		self.parent = self:GetParent()
		self.overdrawTimer = self.overdrawTimer or 0
		self.remnants = self.remnants or {}
		self:StartIntervalThink(FrameTime()*3)
		
		if self:GetParent():HasTalent("special_bonus_imba_earth_spirit_5") then
			self.overdrawCooldown = self.overdrawCooldown + self:GetCaster():FindTalentValue("special_bonus_imba_earth_spirit_5")
		end
		
		if self:GetParent():HasTalent("special_bonus_imba_earth_spirit_6") then
			self.noCostRemnants = self.noCostRemnants + self:GetCaster():FindTalentValue("special_bonus_imba_earth_spirit_6")
		end
	end
end

function modifier_imba_earth_spirit_remnant_handler:OnIntervalThink()
	if IsServer() then
		if self.overdrawTimer > 0 then
			self.overdrawTimer = self.overdrawTimer - FrameTime()*3
		end
		
		local length = #self.remnants
		for i = 1, length do
			if self.remnants[length - i + 1] then
				if not EntIndexToHScript(self.remnants[length - i + 1]) then
					table.remove(self.remnants, length - i + 1)
				end
			end
		end
		
		if #self.remnants <= self.noCostRemnants and self.overdrawTimer <= 0 then
			self:SetStackCount(1)
		end
	end
end

function modifier_imba_earth_spirit_remnant_handler:NewRemnant(remnantID)
	if IsServer() then
		if #self.remnants >= self.noCostRemnants then
			self.overdrawTimer = self.overdrawCooldown
			self:SetDuration(self.overdrawCooldown, true)
			self:IncrementStackCount()
			self:KillRemnant(self.remnants[1])
		elseif self.overdrawTimer > 0 then
			self.overdrawTimer = self.overdrawCooldown
			self:SetDuration(self.overdrawCooldown, true)
		end
		table.insert(self.remnants, remnantID)
	end
end

function modifier_imba_earth_spirit_remnant_handler:KillRemnant(remnantID)
	if IsServer() then
		for i, id in ipairs(self.remnants) do
			if id == remnantID then
				table.remove(self.remnants, i)
				
				local remnant = EntIndexToHScript(id)
				if remnant then
					local remnantModifier = remnant:FindModifierByName("modifier_imba_stone_remnant")
					if remnantModifier then remnantModifier:Destroy() end
				end
				return
			end
		end
	end
end

function modifier_imba_earth_spirit_remnant_handler:OnAttackLanded(keys)
	if IsServer() then
		if keys.attacker == self.parent and keys.target:GetTeamNumber() ~= self.parent:GetTeamNumber() then
			local mark = keys.target:FindModifierByName("modifier_imba_earths_mark")
			if mark then
				mark:IncrementStackCount()
			else
				keys.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_imba_earths_mark", {duration = self:GetAbility():GetSpecialValueFor("earths_mark_duration")})
			end
		end
	end
end

-----	Stone Remnant handler
modifier_imba_stone_remnant = modifier_imba_stone_remnant or class({})
function modifier_imba_stone_remnant:IsHidden() return true end

function modifier_imba_stone_remnant:OnCreated()
	if IsServer() then
		if self:GetParent():GetUnitName() == "npc_imba_dota_earth_spirit_stone" then
			local particle = "particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf"
			self.remnantParticle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.remnantParticle, 1, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		end
		
		self.exploded = false
	end
end

function modifier_imba_stone_remnant:GetStatusEffectName()
	return "particles/status_fx/status_effect_earth_spirit_petrify.vpcf" end

function modifier_imba_stone_remnant:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_imba_stone_remnant:OnDestroy()
	if IsServer() then
		
		if self.explodedParticle then
			ParticleManager:DestroyParticle(self.explodedParticle, false)
			ParticleManager:ReleaseParticleIndex(self.explodedParticle)
		end
		
		EmitSoundOn("Hero_EarthSpirit.StoneRemnant.Destroy", self:GetParent())
		
		if self:GetParent():GetUnitName() == "npc_imba_dota_earth_spirit_stone" then
			ParticleManager:DestroyParticle(self.remnantParticle, false)
			ParticleManager:ReleaseParticleIndex(self.remnantParticle)
			UTIL_Remove(self:GetParent())
			self:GetAbility():KillRemnant(self:GetParent():GetEntityIndex())
		else
			FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
			
			-- Deal enhcant remnant damage in AoE upon expiration
			if self.PetrifyHandler then
				local damage = self.PetrifyHandler:GetSpecialValueFor("damage")
				local damageRadius = self.PetrifyHandler:GetSpecialValueFor("damage_radius")
				local units = FindUnitsInRadius(self.PetrifyHandler:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, damageRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _, unit in ipairs(units) do
					ApplyDamage({victim = unit, attacker = self.PetrifyHandler:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				end
			end
		end
	end
end

function modifier_imba_stone_remnant:Explode()
	if IsServer() then
		local particle = "particles/units/heroes/hero_earth_spirit/espirit_stoneismagnetized_xpld.vpcf"
		self.explodedParticle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.exploded = true
	end
end

-- passes the enchant remnant skill handler
function modifier_imba_stone_remnant:SetPetrify(petrify)
	if IsServer() then
		self.PetrifyHandler = petrify
	end
end

-----	Earths Mark
modifier_imba_earths_mark = modifier_imba_earths_mark or class({})
function modifier_imba_earths_mark:IsHidden() return false end
function modifier_imba_earths_mark:IsDebuff() return true end

function modifier_imba_earths_mark:GetTexture()
	return "brewmaster_earth_spell_immunity" end

function modifier_imba_earths_mark:GetEffectName()
	return "particles/hero/earth_spirit/earth_mark.vpcf" end

function modifier_imba_earths_mark:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_earths_mark:DestroyOnExpire()
	if self.caster:HasTalent("special_bonus_imba_earth_spirit_8") then
		return false
	end
	return true
end

function modifier_imba_earths_mark:IsPurgable()
	if self.caster:HasTalent("special_bonus_imba_earth_spirit_7") then
		return false
	end
	return true
end

function modifier_imba_earths_mark:IsPurgeException()
	if self.caster:HasTalent("special_bonus_imba_earth_spirit_7") then
		return false
	end
	return true
end

function modifier_imba_earths_mark:DeclareFunctions()
	return { MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS } end

function modifier_imba_earths_mark:OnCreated()
	self.caster = self:GetCaster()	-- Required for client as well
	if IsServer() then
		self.duration = self:GetAbility():GetSpecialValueFor("earths_mark_duration")
		self:SetStackCount(1)
		
		if self.caster:HasTalent("special_bonus_imba_earth_spirit_7") or self.caster:HasTalent("special_bonus_imba_earth_spirit_8") then
			self:StartIntervalThink(FrameTime() * 3)
		end
	end
end

function modifier_imba_earths_mark:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() > 0 then
			if self.caster:HasTalent("special_bonus_imba_earth_spirit_7") then
				if self:GetParent():IsMagicImmune() then
					self:SetDuration(self:GetRemainingTime() + FrameTime() * 3, true)
				end
			end
		else
			if self.caster:HasTalent("special_bonus_imba_earth_spirit_8") then
				if self:GetStackCount() > 1 then
					self:DecrementStackCount()
					self:RefreshDuration(true)
				else
					self:Destroy()
				end
			else
				self:Destroy()
			end
		end
	end
end

function modifier_imba_earths_mark:OnStackCountChanged(oldStacks)
	if IsServer() then
		if oldStacks == self:GetStackCount() then return end
		
		if self:GetStackCount() > oldStacks then
			self:RefreshDuration()
		end
	end
end

function modifier_imba_earths_mark:RefreshDuration(talentRefresh)
	if IsServer() then
		if talentRefresh or not self.caster:HasTalent("special_bonus_imba_earth_spirit_8") then
			local newDuration = self.duration -- * tenacity modifier and so on
			self:SetDuration(newDuration, true)
		end
	end
end

function modifier_imba_earths_mark:GetModifierMagicalResistanceBonus()
	if self.caster:HasTalent("special_bonus_imba_earth_spirit_4") then
		return self.caster:FindTalentValue("special_bonus_imba_earth_spirit_4") * self:GetStackCount() * -1
	end
	
	return 0
end

-----	Layout fix
modifier_imba_earth_spirit_layout_fix = modifier_imba_earth_spirit_layout_fix or class({})
function modifier_imba_earth_spirit_layout_fix:IsHidden() return true end
function modifier_imba_earth_spirit_layout_fix:IsDebuff() return false end
function modifier_imba_earth_spirit_layout_fix:IsPurgable() return false end
function modifier_imba_earth_spirit_layout_fix:RemoveOnDeath() return false end

function modifier_imba_earth_spirit_layout_fix:DeclareFunctions()
	return { MODIFIER_PROPERTY_ABILITY_LAYOUT } end
	
function modifier_imba_earth_spirit_layout_fix:GetModifierAbilityLayout()
	return 6 end

---------------------------------------------------------------------
-------------------------	Boulder Smash	-------------------------
---------------------------------------------------------------------
imba_earth_spirit_boulder_smash = imba_earth_spirit_boulder_smash or class({})
LinkLuaModifier("modifier_imba_boulder_smash_push", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)			-- Movement modifier
LinkLuaModifier("modifier_imba_boulder_smash_cast_thinker", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)	-- Used when the target is outside of unit cast range 

function imba_earth_spirit_boulder_smash:GetAssociatedSecondaryAbilities()
	return "imba_earth_spirit_stone_remnant" end

function imba_earth_spirit_boulder_smash:GetCastRange()
	if IsClient() then
		return self:GetSpecialValueFor("max_distance_for_push")
	else
		return self:GetSpecialValueFor("remnant_distance")
	end
end

function imba_earth_spirit_boulder_smash:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	-- Can't target self, buildings, and invuln units
	if caster == target then
		return UF_FAIL_CUSTOM
	elseif target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	elseif target:IsAncient() then
		return UF_FAIL_ANCIENT

	-- Can't target allies who disabled helps
	elseif caster:GetTeamNumber() == target:GetTeamNumber() then
		if target:GetPlayerOwnerID() and PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), caster:GetPlayerOwnerID()) then
			return UF_FAIL_DISABLE_HELP
		end

	-- Can't target spell immune enemies
	elseif target:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY 
	end

	return UF_SUCCESS
end

function imba_earth_spirit_boulder_smash:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self" end
	return ""
end

-- Shits handled in the phase start because there might not be a remnant to work with
function imba_earth_spirit_boulder_smash:OnAbilityPhaseStart()
	if IsServer() then
		local pointTarget = self:GetCursorPosition()
		local target = self:GetCursorTarget()
		local caster = self:GetCaster()
		local searchRadius = self:GetSpecialValueFor("max_distance_for_push") + GetCastRangeIncrease(caster)
		
		-- remove thinker modifier for when casting outside of unit/remnant search range
		caster:RemoveModifierByName("modifier_imba_boulder_smash_cast_thinker")
		
		if target then
			if CalcDistanceBetweenEntityOBB(caster, target) <= searchRadius then
				
				-- Find remnants first				
				local RemnantAroundCaster = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius+1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
				for _, r in ipairs(RemnantAroundCaster) do
					if r:HasModifier("modifier_imba_stone_remnant") then
						r:RemoveModifierByName("modifier_imba_boulder_smash_push")
						r:RemoveModifierByName("modifier_imba_geomagnetic_grip_pull")
						
						local mod = r:AddNewModifier(r, self, "modifier_imba_boulder_smash_push", {})
						local dir = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
						mod:PassData(caster, dir)
						
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf", PATTACH_ABSORIGIN, caster)
						ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(particle)
						
						EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Target", r)
						return true
					end
				end
				
				target:RemoveModifierByName("modifier_imba_boulder_smash_push")
				target:RemoveModifierByName("modifier_imba_geomagnetic_grip_pull")
				target:AddNewModifier(caster, self, "modifier_imba_boulder_smash_push", {})
				
				if caster:GetTeamNumber() ~= target:GetTeamNumber() then
					ApplyDamage({victim = target, attacker = caster, damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL})
				end
				
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				
				EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Target", target)
				return true
			else
				-- Find remnants around caster first				
				local RemnantAroundCaster = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius+1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
				for _, r in ipairs(RemnantAroundCaster) do
					if r:HasModifier("modifier_imba_stone_remnant") then
						r:RemoveModifierByName("modifier_imba_boulder_smash_push")
						r:RemoveModifierByName("modifier_imba_geomagnetic_grip_pull")
						
						local mod = r:AddNewModifier(r, self, "modifier_imba_boulder_smash_push", {})
						local dir = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
						mod:PassData(caster, dir)
						
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf", PATTACH_ABSORIGIN, caster)
						ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
						ParticleManager:ReleaseParticleIndex(particle)
						
						EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Target", r)
						return true
					end
				end
				
				local orderTbl = {
					UnitIndex = caster:entindex(), 
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
					TargetIndex = target:entindex()
				}
		
				ExecuteOrderFromTable(orderTbl)
				
				Timers:CreateTimer(FrameTime(), function()
					local castMod = caster:AddNewModifier(caster, self, "modifier_imba_boulder_smash_cast_thinker", {})
					castMod:PassTarget(target, "unit")
				end)
				
				return false
			end
		else
			local RemnantAroundCaster = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius+1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			for _, r in ipairs(RemnantAroundCaster) do
				if r:HasModifier("modifier_imba_stone_remnant") then
					r:RemoveModifierByName("modifier_imba_boulder_smash_push")
					r:RemoveModifierByName("modifier_imba_geomagnetic_grip_pull")
					
					local mod = r:AddNewModifier(r, self, "modifier_imba_boulder_smash_push", {})
					local dir = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
					mod:PassData(caster, dir)
					
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
					
					EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Target", r)
					return true
				end
			end
			
			local RemnantAroundCursor = FindUnitsInRadius(caster:GetTeamNumber(), pointTarget, nil, searchRadius+1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			for _, r in ipairs(RemnantAroundCursor) do
				if r:HasModifier("modifier_imba_stone_remnant") then
					local orderTbl = {
						UnitIndex = caster:entindex(), 
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = r:GetAbsOrigin()
					}
			
					ExecuteOrderFromTable(orderTbl)
					
					Timers:CreateTimer(FrameTime(), function()
						local castMod = caster:AddNewModifier(caster, self, "modifier_imba_boulder_smash_cast_thinker", {})
						castMod:PassTarget(r, "remnant")
					end)

					return false
				end
			end
		end
	end

	return false
end

-----	Movement handler
modifier_imba_boulder_smash_push = modifier_imba_boulder_smash_push or class({})
function modifier_imba_boulder_smash_push:IsHidden() return true end
function modifier_imba_boulder_smash_push:IsDebuff() return true end
function modifier_imba_boulder_smash_push:IsPurgable() return false end
function modifier_imba_boulder_smash_push:IsPurgeException() return false end
function modifier_imba_boulder_smash_push:IgnoreTenacity() return true end
function modifier_imba_boulder_smash_push:IsMotionController() return true end
function modifier_imba_boulder_smash_push:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_boulder_smash_push:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_imba_boulder_smash_push:GetEffectName()
	return "particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_target.vpcf" end

function modifier_imba_boulder_smash_push:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_boulder_smash_push:CheckState()
	return	 {	[MODIFIER_STATE_ROOTED] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true, }
end

-- workaround to some bullshit (modifier not applying only to invuln enemies)
function modifier_imba_boulder_smash_push:PassData(rc, dir)
	if IsServer() then
		self.caster = rc
		self.direction = dir
	end
end

function modifier_imba_boulder_smash_push:OnCreated()
	if IsServer() then
		self:GetParent():InterruptMotionControllers(false)
		
		-- Timer is a workaround to some bullshit (modifier not applying only to invuln enemies)
		Timers:CreateTimer(FrameTime(), function()
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.caster = self.caster or self:GetCaster()
			self.casterTeam = self.caster:GetTeamNumber()
			
			-- ability params
			self.hitRadius = self.ability:GetSpecialValueFor("effect_radius")
			self.damage = self.ability:GetSpecialValueFor("damage")
			self.velocity = self.ability:GetSpecialValueFor("speed")
			self.stunDuration = self.ability:GetSpecialValueFor("stun_duration")
			local remnantDistance = self.ability:GetSpecialValueFor("remnant_distance")
			local unitDistance = self.ability:GetSpecialValueFor("unit_distance")
			
			self.earthsMarkDuration = self.ability:GetSpecialValueFor("earths_mark_duration")
			self.markStackDamage = self.ability:GetSpecialValueFor("mark_stack_damage")
			
			-- extra handlers
			self.distance = (self.parent:HasModifier("modifier_imba_stone_remnant") and remnantDistance) or unitDistance
			self.direction = self.direction or (self.ability:GetCursorPosition() - self.caster:GetAbsOrigin()):Normalized()
			self.traveled = 0
			
			self.hitTargets = {}
			self.hitTargets[self.parent:GetEntityIndex()] = true
			
			-- start thinking
			self:StartIntervalThink(FrameTime())
		end)
	end
end

function modifier_imba_boulder_smash_push:OnIntervalThink()
	if IsServer() then
		self:HorizontalMotion(FrameTime())
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), self.hitRadius, false)
		
		local targets = FindUnitsInRadius(self.casterTeam, self.parent:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, target in ipairs(targets) do
			if not self.hitTargets[target:GetEntityIndex()] then
				self.hitTargets[target:GetEntityIndex()] = true
				
				local damage = self.damage
				EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Damage", target)
				
				-- checking for modifier instead of isRemnant because enchant remnant retains movement qualities after expiring, but doesnt stun anymore
				if self.parent:HasModifier("modifier_imba_stone_remnant") then
					target:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stunDuration})
					EmitSoundOn("Hero_EarthSpirit.BoulderSmash.Silence", target)
					
					-- Earths mark effect
					local mark = target:FindModifierByName("modifier_imba_earths_mark")
					if mark then
						damage = damage + self.markStackDamage * mark:GetStackCount()
						mark:IncrementStackCount()
					else
						target:AddNewModifier(self.caster, self.ability, "modifier_imba_earths_mark", {duration = self.earthsMarkDuration})
					end
				end

				ApplyDamage({victim = target, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			end
		end
	end
end

function modifier_imba_boulder_smash_push:HorizontalMotion(dt)
	if IsServer() then
		if self.traveled < self.distance then
			self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.direction * self.velocity * dt)
			self.traveled = self.traveled + self.velocity * dt

			self.parent:SetAbsOrigin(Vector(self.parent:GetAbsOrigin().x, self.parent:GetAbsOrigin().y, GetGroundHeight(self.parent:GetAbsOrigin(), self.parent)))
		else
			if not self.parent:HasModifier("modifier_imba_stone_remnant") then
				FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
			end
			
			self:Destroy()
		end
	end
end

-----	Cast thinker
modifier_imba_boulder_smash_cast_thinker = modifier_imba_boulder_smash_cast_thinker or class({})
function modifier_imba_boulder_smash_cast_thinker:IsHidden() return true end
function modifier_imba_boulder_smash_cast_thinker:IsDebuff() return false end
function modifier_imba_boulder_smash_cast_thinker:IsPurgable() return false end
function modifier_imba_boulder_smash_cast_thinker:IsPurgeException() return false end

function modifier_imba_boulder_smash_cast_thinker:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER} end

function modifier_imba_boulder_smash_cast_thinker:OnCreated()
	if IsServer() then
		self.ignoredOrders = {}
		self.ignoredOrders[DOTA_UNIT_ORDER_CAST_TOGGLE] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_TRAIN_ABILITY] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_SELL_ITEM] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_DISASSEMBLE_ITEM] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_MOVE_ITEM] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO] = true
		self.ignoredOrders[DOTA_UNIT_ORDER_GLYPH] = true
		
		self.caster = self:GetParent()
		self.castRange = self:GetAbility():GetSpecialValueFor("max_distance_for_push") + GetCastRangeIncrease(self.caster) - 20
		
		Timers:CreateTimer(FrameTime(), function()
			if not self:IsNull() then
				self:StartIntervalThink(FrameTime() * 3)
			end
		end)
	end
end

function modifier_imba_boulder_smash_cast_thinker:OnIntervalThink()
	if IsServer() then
		if self.target then
			if self.targetType == "remnant" then
				if CalcDistanceBetweenEntityOBB(self.caster, self.target) <= self.castRange then
					self.caster:Interrupt()
					
					if self.target:HasModifier("modifier_imba_stone_remnant") then
						self.caster:CastAbilityOnPosition(self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * 10, self:GetAbility(), self.caster:GetPlayerOwnerID())
					else
						self.caster:CastAbilityOnTarget(self.target, self:GetAbility(), self.caster:GetPlayerOwnerID())
					end
					
					self:Destroy()
				end
			elseif self.targetType == "unit" then
				if CalcDistanceBetweenEntityOBB(self.caster, self.target) <= self.castRange then
					self.caster:Interrupt()
					
					if self.target:HasModifier("modifier_imba_stone_remnant") then
						self.caster:CastAbilityOnPosition(self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * 10, self:GetAbility(), self.caster:GetPlayerOwnerID())
					else
						self.caster:CastAbilityOnTarget(self.target, self:GetAbility(), self.caster:GetPlayerOwnerID())
					end
					
					self:Destroy()
				end
			else
				self:Destroy()
				return
			end
		else
			self:Destroy()
			return
		end
	end
end

function modifier_imba_boulder_smash_cast_thinker:PassTarget(target, type)
	if IsServer() then
		self.target = target
		self.targetType = type or "none"
	end
end

function modifier_imba_boulder_smash_cast_thinker:OnOrder(kv)
	if IsServer() then
		if kv.unit == self.caster then
			if not self.ignoredOrders[kv.order_type] then
				self:Destroy()
			end
		end
	end
end

---------------------------------------------------------------------
-------------------------	Rolling Boulder	-------------------------
---------------------------------------------------------------------
imba_earth_spirit_rolling_boulder = imba_earth_spirit_rolling_boulder or class({})
LinkLuaModifier("modifier_imba_rolling_boulder", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)		-- Movement handler
LinkLuaModifier("modifier_imba_rolling_boulder_slow", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)	-- Slow debuff
LinkLuaModifier("modifier_imba_rolling_boulder_disarm", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)		-- Disarm from earths mark

function imba_earth_spirit_rolling_boulder:IsNetherWardStealable() return false end

function imba_earth_spirit_rolling_boulder:GetAssociatedSecondaryAbilities()
	return "imba_earth_spirit_stone_remnant" end

function imba_earth_spirit_rolling_boulder:GetCastRange()
	if IsClient() then		-- Indicating no-remnant maximum range
		return self:GetSpecialValueFor("roll_distance")
	else					-- So you can click wherever and roll in that direction, even if its out of range
		return 30000
	end
end

function imba_earth_spirit_rolling_boulder:OnSpellStart()
	if IsServer() then
		EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Cast", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rolling_boulder", {})
	end
end

-----	Movement handler
modifier_imba_rolling_boulder = modifier_imba_rolling_boulder or class({})
function modifier_imba_rolling_boulder:IsHidden() return true end
function modifier_imba_rolling_boulder:IsMotionController() return true end
function modifier_imba_rolling_boulder:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_rolling_boulder:GetEffectName()
	return "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf" end

function modifier_imba_rolling_boulder:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_rolling_boulder:CheckState()
	if IsServer() then
		if self.delay <= 0 and self.caster:HasTalent("special_bonus_imba_earth_spirit_2") then
			return	{	[MODIFIER_STATE_ROOTED] = true,
						[MODIFIER_STATE_DISARMED] = true,
						[MODIFIER_STATE_INVULNERABLE] = true }
		else
			return	{	[MODIFIER_STATE_ROOTED] = true,
						[MODIFIER_STATE_DISARMED] = true }
		end
	end
end

function modifier_imba_rolling_boulder:OnCreated()
	if IsServer() then
		
		self.ability = self:GetAbility()
		self.caster = self:GetCaster()
		self.casterTeam = self.caster:GetTeamNumber()
		
		-- ability params
		self.delay = self.ability:GetSpecialValueFor("launch_delay")
		self.hitRadius = self.ability:GetSpecialValueFor("collision_radius")
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.slowDuration = self.ability:GetSpecialValueFor("remnant_slow_duration")
		self.normalDistance = self.ability:GetSpecialValueFor("roll_distance")
		self.normalVelocity = self.ability:GetSpecialValueFor("speed")
		self.remnantDistance = self.ability:GetSpecialValueFor("remnant_roll_distance")
		self.remnantVelocity = self.ability:GetSpecialValueFor("remnant_speed")
		self.distanceOppositeToTarget = self.ability:GetSpecialValueFor("opposite_to_enemy_distance")
		
		self.earthsMarkDuration = self.ability:GetSpecialValueFor("earths_mark_duration")
		self.disarmDurationPerMark = self.ability:GetSpecialValueFor("disarm_duration_per_mark")
		
		-- extra handlers
		self.hitRemnant = false
		self.traveled = 0
		self.direction = (self.caster:GetCursorPosition() - self.caster:GetAbsOrigin()):Normalized()
		
		self.hitEnemies = {}
		
		self.caster:EmitSound("Hero_EarthSpirit.RollingBoulder.Loop")
		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		Timers:CreateTimer(self.delay, function()
			self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
			self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
			if self.caster:HasTalent("special_bonus_imba_earth_spirit_2") then
				ProjectileManager:ProjectileDodge(self.caster)
			end
		end)
		
		-- Disable ability
		self.ability:SetActivated(false)
		
		-- start thinking
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_rolling_boulder:OnIntervalThink()
	if IsServer() then
		self.caster:SetForwardVector(self.direction)
		
		if self.delay > 0 then
			self.delay = self.delay - FrameTime()
		else
			self:HorizontalMotion(FrameTime())
			GridNav:DestroyTreesAroundPoint(self.caster:GetAbsOrigin(), self.hitRadius, false)
			
			-- Hitting a remnant
			if not self.hitRemnant then
				local RemnantFinder = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
				for _, r in ipairs(RemnantFinder) do
					if r:HasModifier("modifier_imba_stone_remnant") then
						local remnantModifier = r:FindModifierByName("modifier_imba_stone_remnant")
						if remnantModifier then remnantModifier:Destroy() end
						
						EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Stone", self.caster)
						self.hitRemnant = true
						break
					end
				end
			end
			
			local nonHeroes = FindUnitsInRadius(self.casterTeam, self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, nonHero in ipairs(nonHeroes) do
				if not self.hitEnemies[nonHero:GetEntityIndex()] then
					self.hitEnemies[nonHero:GetEntityIndex()] = true
					ApplyDamage({victim = nonHero, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
				end
			end
			
			local heroes = FindUnitsInRadius(self.casterTeam, self.caster:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for i, hero in ipairs(heroes) do
				
				ApplyDamage({victim = hero, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
				
				local mark = hero:FindModifierByName("modifier_imba_earths_mark")
				if mark then
					mark:IncrementStackCount()
					hero:AddNewModifier(self.caster, self.ability, "modifier_imba_rolling_boulder_disarm", {duration = mark:GetStackCount() * self.disarmDurationPerMark})
				else
					hero:AddNewModifier(self.caster, self.ability, "modifier_imba_earths_mark", {duration = self.earthsMarkDuration})
				end
				
				if self.hitRemnant then
					hero:AddNewModifier(self.caster, self.ability, "modifier_imba_rolling_boulder_slow", {duration = self.slowDuration})
					
					local magnetizedFinder = FindUnitsInRadius(self.casterTeam, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
					for _, unit in ipairs(magnetizedFinder) do
						if unit:FindModifierByNameAndCaster("modifier_imba_magnetize", self.caster) then
							unit:AddNewModifier(self.caster, self.ability, "modifier_imba_rolling_boulder_slow", {duration = self.slowDuration})
						end
					end
				end
				
				-- Place caster on the other side of the target
				if i == 1 then
					EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Target", hero)
					FindClearSpaceForUnit(self.caster, hero:GetAbsOrigin() + self.direction * self.distanceOppositeToTarget, false)
				end
				
				-- Stop rolling
				if i == #heroes then
					self:Destroy()
					return
				end
			end
			
			self:HorizontalMotion(FrameTime())
		end
	end
end

function modifier_imba_rolling_boulder:HorizontalMotion(dt)
	if IsServer() then
		if self.hitRemnant then
			if self.traveled < self.remnantDistance then
				self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + self.direction * self.remnantVelocity * dt)
				self.traveled = self.traveled + self.remnantVelocity * dt
				
				self.caster:SetAbsOrigin(Vector(self.caster:GetAbsOrigin().x, self.caster:GetAbsOrigin().y, GetGroundHeight(self.caster:GetAbsOrigin(), self.caster)))
			else
				FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), false)
				EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Destroy", self.caster)
				self:Destroy()
			end
		else
			if self.traveled < self.normalDistance then
				self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + self.direction * self.normalVelocity * dt)
				self.traveled = self.traveled + self.normalVelocity * dt
				
				self.caster:SetAbsOrigin(Vector(self.caster:GetAbsOrigin().x, self.caster:GetAbsOrigin().y, GetGroundHeight(self.caster:GetAbsOrigin(), self.caster)))
			else
				FindClearSpaceForUnit(self.caster, self.caster:GetAbsOrigin(), false)
				EmitSoundOn("Hero_EarthSpirit.RollingBoulder.Destroy", self.caster)
				self:Destroy()
			end
		end
	end
end

function modifier_imba_rolling_boulder:OnDestroy()
	if IsServer() then
		self.caster:StopSound("Hero_EarthSpirit.RollingBoulder.Loop")
		self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START)
		self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL)
		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END)
		
		-- Reenable ability
		self.ability:SetActivated(true)
		
		Timers:CreateTimer(0.6, function()
			self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END)
		end)
	end
end

-----	Slow Modifier
modifier_imba_rolling_boulder_slow = modifier_imba_rolling_boulder_slow or class({})
function modifier_imba_rolling_boulder_slow:IsDebuff() return true end
function modifier_imba_rolling_boulder_slow:IsPurgable() return true end

function modifier_imba_rolling_boulder_slow:GetEffectName()
	return "particles/status_fx/status_effect_earth_spirit_boulderslow.vpcf" end

function modifier_imba_rolling_boulder_slow:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE } end

function modifier_imba_rolling_boulder_slow:OnCreated()
	self.slowPcnt = self:GetAbility():GetSpecialValueFor("remnant_slow_pcnt") * -1 end

function modifier_imba_rolling_boulder_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slowPcnt end

-----	Disarm modifier
modifier_imba_rolling_boulder_disarm = modifier_imba_rolling_boulder_disarm or class({})
function modifier_imba_rolling_boulder_disarm:IsDebuff() return true end
function modifier_imba_rolling_boulder_disarm:IsPurgable() return true end

function modifier_imba_rolling_boulder_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf" end

function modifier_imba_rolling_boulder_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_rolling_boulder_disarm:CheckState()
	return { [MODIFIER_STATE_DISARMED] = true } end


---------------------------------------------------------------------
-------------------------	Geomagnetic Grip	---------------------
---------------------------------------------------------------------
imba_earth_spirit_geomagnetic_grip = imba_earth_spirit_geomagnetic_grip or class({})
LinkLuaModifier("modifier_imba_geomagnetic_grip_pull", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)		-- Movement modifier
LinkLuaModifier("modifier_imba_geomagnetic_grip_silence", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)	-- Silence
LinkLuaModifier("modifier_imba_geomagnetic_grip_root", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)		-- Root

function imba_earth_spirit_geomagnetic_grip:GetAssociatedSecondaryAbilities()
	return "imba_earth_spirit_stone_remnant" end

function imba_earth_spirit_geomagnetic_grip:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	
	-- Can't target self, buildings, and invuln units
	if caster == target then
		return UF_FAIL_CUSTOM
	elseif target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	end
	
	return UF_SUCCESS
end

function imba_earth_spirit_geomagnetic_grip:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self" end
	return ""
end

function imba_earth_spirit_geomagnetic_grip:OnAbilityPhaseStart()
	if IsServer() then
		local remnantSearchRadius = self:GetSpecialValueFor("remnant_search_radius")
		local target = self:GetCursorTarget()
		local pointTarget = self:GetCursorPosition()
		local caster = self:GetCaster()
		
		-- Find remnants first
		local RemnantFinder = FindUnitsInRadius(caster:GetTeamNumber(), pointTarget, nil, remnantSearchRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _, r in ipairs(RemnantFinder) do
			if r:HasModifier("modifier_imba_stone_remnant") then
				r:RemoveModifierByName("modifier_imba_boulder_smash_push")
				r:RemoveModifierByName("modifier_imba_geomagnetic_grip_pull")
				
				local mod = r:AddNewModifier(r, self, "modifier_imba_geomagnetic_grip_pull", {})
				mod:SetRealCaster(caster)
				
				EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Cast", caster)
				EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Target", r)
				return true
			end
		end
		
		if target and target:GetTeamNumber() == caster:GetTeamNumber() and not target:IsBuilding() and not target:IsInvulnerable() and not (target:IsPlayer() and PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), caster:GetPlayerOwnerID())) then
			target:RemoveModifierByName("modifier_imba_boulder_smash_push")
			target:AddNewModifier(caster, self, "modifier_imba_geomagnetic_grip_pull", {})
			
			EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Cast", caster)
			EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Target", target)
			return true
		end
	end
	
	return false
end

-----	Movement handler
modifier_imba_geomagnetic_grip_pull = modifier_imba_geomagnetic_grip_pull or class({})
function modifier_imba_geomagnetic_grip_pull:IsDebuff() return false end
function modifier_imba_geomagnetic_grip_pull:IsHidden() return true end
function modifier_imba_geomagnetic_grip_pull:IsPurgable() return false end
function modifier_imba_geomagnetic_grip_pull:IsStunDebuff() return true end
function modifier_imba_geomagnetic_grip_pull:IgnoreTenacity() return true end
function modifier_imba_geomagnetic_grip_pull:IsMotionController() return true end
function modifier_imba_geomagnetic_grip_pull:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end
function modifier_imba_geomagnetic_grip_pull:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_imba_geomagnetic_grip_pull:GetEffectName()
	return "particles/units/heroes/hero_earth_spirit/espirit_geomagentic_grip_target.vpcf" end

function modifier_imba_geomagnetic_grip_pull:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_geomagnetic_grip_pull:CheckState()
	return	 {	[MODIFIER_STATE_ROOTED] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true, }
end

-- workaround to some bullshit (modifier not applying only to invuln enemies)
function modifier_imba_geomagnetic_grip_pull:SetRealCaster(rc)
	if IsServer() then self.caster = rc end end

function modifier_imba_geomagnetic_grip_pull:OnCreated()
	if IsServer() then
		self:GetParent():InterruptMotionControllers(false)
		
		-- Timer is a workaround to some bullshit (modifier not applying only to invuln enemies)
		Timers:CreateTimer(FrameTime(), function()
			self.ability = self:GetAbility()
			self.parent = self:GetParent()
			self.caster = self.caster or self:GetCaster()
			self.casterTeam = self.caster:GetTeamNumber()
			
			-- ability params
			self.hitRadius = self.ability:GetSpecialValueFor("effect_radius")
			self.damage = self.ability:GetSpecialValueFor("damage")
			self.silenceDuration = self.ability:GetSpecialValueFor("silence_duration")
			self.remnantVelocity = self.ability:GetSpecialValueFor("remnant_speed")
			self.normalVelocity = self.ability:GetSpecialValueFor("speed")
			
			self.earthsMarkDuration = self.ability:GetSpecialValueFor("earths_mark_duration")
			self.rootTimePerMark = self.ability:GetSpecialValueFor("root_time_per_mark")
			
			-- extra handlers
			self.isRemnant = self.parent:HasModifier("modifier_imba_stone_remnant")
			
			self.direction = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
			self.distance = CalcDistanceBetweenEntityOBB(self.parent, self.caster) - 100
			self.traveled = 0
			
			self.hitTargets = {}
			self.hitTargets[self.parent:GetEntityIndex()] = true
			
			-- start thinking
			self:StartIntervalThink(FrameTime())
		end)
	end
end

function modifier_imba_geomagnetic_grip_pull:OnIntervalThink()
	if IsServer() then
		self:HorizontalMotion(FrameTime())
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), self.hitRadius, false)
		
		local targets = FindUnitsInRadius(self.casterTeam, self.parent:GetAbsOrigin(), nil, self.hitRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, target in ipairs(targets) do
			if not self.hitTargets[target:GetEntityIndex()] then
				self.hitTargets[target:GetEntityIndex()] = true
				target:AddNewModifier(self.caster, self.ability, "modifier_imba_geomagnetic_grip_silence", {duration = self.silenceDuration})
				EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Stun", target)
				
				local magnetizedFinder = FindUnitsInRadius(self.casterTeam, Vector(0,0,0), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _, unit in ipairs(magnetizedFinder) do
					if unit:FindModifierByNameAndCaster("modifier_imba_magnetize", self.caster) then
						unit:AddNewModifier(self.caster, self.ability, "modifier_imba_geomagnetic_grip_silence", {duration = self.silenceDuration})
					end
				end
				
				-- checking for modifier instead of isRemnant because enchant remnant retains movement qualities after expiring, but doesnt damage anymore
				if self.parent:HasModifier("modifier_imba_stone_remnant") then
					ApplyDamage({victim = target, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
					EmitSoundOn("Hero_EarthSpirit.GeomagneticGrip.Cast", Damage)
					
					-- Earths mark effect
					local mark = target:FindModifierByName("modifier_imba_earths_mark")
					if mark then
						target:AddNewModifier(self.caster, self.ability, "modifier_imba_geomagnetic_grip_root", {duration = self.rootTimePerMark * mark:GetStackCount()})
						mark:IncrementStackCount()
					else
						target:AddNewModifier(self.caster, self.ability, "modifier_imba_earths_mark", {duration = self.earthsMarkDuration})
					end
				end
			end
		end
	end
end

function modifier_imba_geomagnetic_grip_pull:HorizontalMotion(dt)
	if IsServer() then
		if self.traveled < self.distance then
			if self.isRemnant then
				self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.direction * self.remnantVelocity * dt)
				self.traveled = self.traveled + self.remnantVelocity * dt
			else
				self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.direction * self.normalVelocity * dt)
				self.traveled = self.traveled + self.normalVelocity * dt
			end
			
			self.parent:SetAbsOrigin(Vector(self.parent:GetAbsOrigin().x, self.parent:GetAbsOrigin().y, GetGroundHeight(self.parent:GetAbsOrigin(), self.parent)))
		else
			if not self.isRemnant then
				FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
			end
			self:Destroy()
		end
	end
end

-----	Silence modifier
modifier_imba_geomagnetic_grip_silence = modifier_imba_geomagnetic_grip_silence or class({})
function modifier_imba_geomagnetic_grip_silence:IsDebuff() return true end
function modifier_imba_geomagnetic_grip_silence:IsPurgable() return true end

function modifier_imba_geomagnetic_grip_silence:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true } end

-----	Root modifier
modifier_imba_geomagnetic_grip_root = modifier_imba_geomagnetic_grip_root or class({})
function modifier_imba_geomagnetic_grip_root:IsDebuff() return true end
function modifier_imba_geomagnetic_grip_root:IsPurgable() return true end

function modifier_imba_geomagnetic_grip_root:GetEffectName()
	return "particles/units/heroes/hero_lone_druid/lone_druid_bear_entangle_body.vpcf" end

function modifier_imba_geomagnetic_grip_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_imba_geomagnetic_grip_root:CheckState()
	return { [MODIFIER_STATE_ROOTED] = true } end

---------------------------------------------------------------------
---------------------------	   Magnetize	-------------------------
---------------------------------------------------------------------
imba_earth_spirit_magnetize = imba_earth_spirit_magnetize or class({})
LinkLuaModifier("modifier_imba_magnetize", "components/abilities/heroes/hero_earth_spirit.lua", LUA_MODIFIER_MOTION_NONE)

function imba_earth_spirit_magnetize:GetAssociatedSecondaryAbilities()
	return "imba_earth_spirit_stone_remnant" end

function imba_earth_spirit_magnetize:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function imba_earth_spirit_magnetize:OnSpellStart()
	if IsServer() then
		local searchRadius = self:GetSpecialValueFor("radius")
		local debuffDuration = self:GetSpecialValueFor("duration")
		local caster = self:GetCaster()
		
		EmitSoundOn("Hero_EarthSpirit.Magnetize.Cast", caster)
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, searchRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit:HasModifier("modifier_imba_magnetize") then
				unit:FindModifierByName("modifier_imba_magnetize"):SetDuration(debuffDuration, true)
			else
				unit:AddNewModifier(caster, self, "modifier_imba_magnetize", {duration = debuffDuration})
			end
		end
	end
end

-----	Debuff modifier
modifier_imba_magnetize = modifier_imba_magnetize or class({})
function modifier_imba_magnetize:IsDebuff() return true end
function modifier_imba_magnetize:IsPurgable() return true end

function modifier_imba_magnetize:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		self.caster = self.ability:GetCaster()
		
		self.tickInterval = self.ability:GetSpecialValueFor("tick_cooldown")
		self.tickDamge = self.ability:GetSpecialValueFor("damage_per_sec") * self.tickInterval
		self.refreshRadius = self.ability:GetSpecialValueFor("remnant_refresh_radius")
		self.remnantSearchRadius = self.ability:GetSpecialValueFor("remnant_search_radius")
		self.baseDration = self.ability:GetSpecialValueFor("duration")
		self.remnantNewLifespan = self.ability:GetSpecialValueFor("remnant_lifespan")
		
		self.earthsMarkDuration = self.ability:GetSpecialValueFor("earths_mark_duration")
		self.markTickDamagePerSecPerStack = self.ability:GetSpecialValueFor("mark_damage_per_sec_per_stack") * self.tickInterval
		self.markedStunDuration = self.ability:GetSpecialValueFor("marked_stun_duration")
		
		self:StartIntervalThink(self.tickInterval)
	end
end

function modifier_imba_magnetize:OnIntervalThink()
	if IsServer() then
		local damage = self.tickDamge
		local mark = self.parent:FindModifierByName("modifier_imba_earths_mark")
		if mark then
			mark:RefreshDuration()
			damage = damage + self.markTickDamagePerSecPerStack * mark:GetStackCount()
			
			if self.caster:HasTalent("special_bonus_imba_earth_spirit_3") then
				local heal = self.caster:FindTalentValue("special_bonus_imba_earth_spirit_3") * mark:GetStackCount()
				self.caster:Heal(heal, self.caster)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.caster, heal, nil)
			end
		end
		
		ApplyDamage({ victim = self.parent, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })
		
		EmitSoundOn("Hero_EarthSpirit.Magnetize.Debris", self.parent)
		if self.parent:IsHero() then EmitSoundOn("Hero_EarthSpirit.Magnetize.Tick", self.parent) end
		
		local tickParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnetize_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(tickParticle, 1, Vector(self.remnantSearchRadius, self.remnantSearchRadius, self.remnantSearchRadius))
		ParticleManager:SetParticleControl(tickParticle, 2, Vector(self.remnantSearchRadius, self.remnantSearchRadius, self.remnantSearchRadius))
		ParticleManager:ReleaseParticleIndex(tickParticle)
		
		local remnantFinder = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.remnantSearchRadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
		for _, r in ipairs(remnantFinder) do
			local remnantModifier = r:FindModifierByName("modifier_imba_stone_remnant")
			if remnantModifier and not remnantModifier.exploded then
				local units = FindUnitsInRadius(self.caster:GetTeamNumber(), r:GetAbsOrigin(), nil, self.refreshRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
				for _, unit in ipairs(units) do
					local debuff = unit:FindModifierByName("modifier_imba_magnetize")
					
					EmitSoundOn("Hero_EarthSpirit.Magnetize.StoneBolt", self.parent)
					local zapParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_magnet_arclightning.vpcf", PATTACH_POINT, self.caster)
					ParticleManager:SetParticleControlEnt(zapParticle, 0, r, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(zapParticle, 1, unit, PATTACH_POINT, "attach_hitloc", r:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(zapParticle)
					
					if debuff then
						debuff:SetDuration((debuff:GetRemainingTime() % self.tickInterval) + self.baseDration, true)
					else
						unit:AddNewModifier(self.caster, self.ability, "modifier_imba_magnetize", {duration = self.baseDration})
					end
					
					if self.ability:GetAutoCastState() and self.caster:HasScepter() then
						FindClearSpaceForUnit(unit, r:GetAbsOrigin(), false)
					end
					
					local unitMark = unit:FindModifierByName("modifier_imba_earths_mark")
					if unitMark then
						unitMark:IncrementStackCount()
						self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.markedStunDuration})
					else
						unit:AddNewModifier(unit, self.ability, "modifier_imba_earths_mark", {duration = self.earthsMarkDuration})
					end
				end
				
				-- increase mark stacks and stun -or- add the modifier
				if mark then
					mark:IncrementStackCount()
					self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.markedStunDuration})
				else
					mark = self.parent:AddNewModifier(self.parent, self.ability, "modifier_imba_earths_mark", {duration = self.earthsMarkDuration})
				end
				
				remnantModifier:SetDuration(math.min(self.remnantNewLifespan, remnantModifier:GetRemainingTime()), true)
				remnantModifier:Explode()
				break
			end
		end
	end
end

function modifier_imba_magnetize:OnDestroy()
	if IsServer() then
		EmitSoundOn("Hero_EarthSpirit.Magnetize.End", self.parent)
	end
end

---------------------------------------------------------------------
-------------------------	Enchant Remnant	  -----------------------
---------------------------------------------------------------------
imba_earth_spirit_petrify = imba_earth_spirit_petrify or class({})
function imba_earth_spirit_petrify:IsNetherWardStealable() return false end
function imba_earth_spirit_petrify:IsStealable() return false end
function imba_earth_spirit_petrify:IsInnateAbility() return true end


function imba_earth_spirit_petrify:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	
	-- Can't target self, buildings, and invuln units
	if caster == target then
		return UF_FAIL_CUSTOM
	elseif target:IsBuilding() then
		return UF_FAIL_BUILDING
	elseif target:IsInvulnerable() then
		return UF_FAIL_INVULNERABLE
	elseif target:IsAncient() then
		return UF_FAIL_ANCIENT
	
	-- Can't target allies who disabled helps
	elseif caster:GetTeamNumber() == target:GetTeamNumber() then
		if target:IsPlayer() and PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), caster:GetPlayerOwnerID()) then
			return UF_FAIL_DISABLE_HELP
		end
	
	-- Can't target spell immune enemies
	elseif target:IsMagicImmune() then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY 
	end
	
	return UF_SUCCESS
end

function imba_earth_spirit_petrify:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self" end
	return ""
end

function imba_earth_spirit_petrify:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local duration = self:GetSpecialValueFor("duration")
		
		EmitSoundOn("Hero_EarthSpirit.Petrify", target)
		local mod = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_stone_remnant", {duration = duration})
		mod:SetPetrify(self)
	end
end
