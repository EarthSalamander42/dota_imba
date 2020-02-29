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
--     Firetoad, 10.01.2016
--	   Firetoad, 24.02.2018

-- Ancient Defense ability
imba_ancient_defense = class({})

LinkLuaModifier("modifier_imba_ancient_defense", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_danger_zone", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_ancient_defense:IsHiddenWhenStolen() return false end
function imba_ancient_defense:IsRefreshable() return false end
function imba_ancient_defense:IsStealable() return false end
function imba_ancient_defense:IsNetherWardStealable() return false end

function imba_ancient_defense:GetAbilityTextureName()
	return "custom/ancient_defense"
end

function imba_ancient_defense:GetIntrinsicModifierName()
	return "modifier_imba_ancient_defense"
end

-- Passive modifier
modifier_imba_ancient_defense = class({})
function modifier_imba_ancient_defense:IsDebuff() return false end
function modifier_imba_ancient_defense:IsHidden() return false end
function modifier_imba_ancient_defense:IsPurgable() return false end
function modifier_imba_ancient_defense:IsPurgeException() return false end
function modifier_imba_ancient_defense:IsStunDebuff() return false end

function modifier_imba_ancient_defense:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_ancient_defense:OnIntervalThink()
	if IsServer() then
		local ancient = self:GetParent()
		local nearby_enemies = FindUnitsInRadius(ancient:GetTeamNumber(), ancient:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		self:SetStackCount(math.max(self:GetAbility():GetSpecialValueFor("max_stacks") - #nearby_enemies, 0))
	end
end

function modifier_imba_ancient_defense:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end

function modifier_imba_ancient_defense:GetModifierConstantHealthRegen()
	if (GameRules:GetDOTATime(false, false) / 60) > self:GetAbility():GetSpecialValueFor("min_before_instability") then
		return math.min(((GameRules:GetDOTATime(false, false) / 60) - self:GetAbility():GetSpecialValueFor("min_before_instability")) * self:GetAbility():GetSpecialValueFor("instability_hp_reduce_per_min"), 12) * (-1)
	end
end

function modifier_imba_ancient_defense:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("defense_stack") * self:GetStackCount()
end

-- Ancient Last Resort ability
imba_ancient_last_resort = class({})

LinkLuaModifier("modifier_imba_ancient_last_resort_aura", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ancient_last_resort_debuff", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_ancient_last_resort:IsHiddenWhenStolen() return false end
function imba_ancient_last_resort:IsRefreshable() return false end
function imba_ancient_last_resort:IsStealable() return false end
function imba_ancient_last_resort:IsNetherWardStealable() return false end

function imba_ancient_last_resort:GetAbilityTextureName()
	return "custom/ancient_last_resort"
end

function imba_ancient_last_resort:GetIntrinsicModifierName()
	return "modifier_imba_ancient_last_resort_aura"
end

-- Passive modifier
modifier_imba_ancient_last_resort_aura = class({})
function modifier_imba_ancient_last_resort_aura:IsDebuff() return false end
function modifier_imba_ancient_last_resort_aura:IsHidden() return true end
function modifier_imba_ancient_last_resort_aura:IsPurgable() return false end
function modifier_imba_ancient_last_resort_aura:IsPurgeException() return false end
function modifier_imba_ancient_last_resort_aura:IsStunDebuff() return false end

function modifier_imba_ancient_last_resort_aura:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_ancient_last_resort_aura:OnIntervalThink()
	if IsServer() then
		local ancient = self:GetParent()
		local stacks = math.min(100 - ancient:GetHealthPercent(), self:GetAbility():GetSpecialValueFor("max_reduction"))
		local nearby_enemies = FindUnitsInRadius(ancient:GetTeamNumber(), ancient:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("aura_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(nearby_enemies) do
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_ancient_last_resort_debuff", {duration = 2.0}):SetStackCount(stacks)
		end
	end
end

-- Enemy debuff
modifier_imba_ancient_last_resort_debuff = class({})
function modifier_imba_ancient_last_resort_debuff:IsDebuff() return true end
function modifier_imba_ancient_last_resort_debuff:IsHidden() return false end
function modifier_imba_ancient_last_resort_debuff:IsPurgable() return false end
function modifier_imba_ancient_last_resort_debuff:IsPurgeException() return false end
function modifier_imba_ancient_last_resort_debuff:IsStunDebuff() return false end

function modifier_imba_ancient_last_resort_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_imba_ancient_last_resort_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return (-1) * self:GetStackCount()
end

-- Fountain Danger Zone ability
imba_fountain_danger_zone = class({})

LinkLuaModifier("modifier_imba_fountain_danger_zone", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_danger_zone_debuff", "components/abilities/buildings/ancient_abilities", LUA_MODIFIER_MOTION_NONE)

function imba_fountain_danger_zone:IsHiddenWhenStolen() return false end
function imba_fountain_danger_zone:IsRefreshable() return false end
function imba_fountain_danger_zone:IsStealable() return false end
function imba_fountain_danger_zone:IsNetherWardStealable() return false end

function imba_fountain_danger_zone:GetAbilityTextureName()
	return "nevermore_shadowraze3"
end

function imba_fountain_danger_zone:GetIntrinsicModifierName()
	return "modifier_imba_fountain_danger_zone"
end

-- Passive modifier
modifier_imba_fountain_danger_zone = class({})
function modifier_imba_fountain_danger_zone:IsDebuff() return false end
function modifier_imba_fountain_danger_zone:IsHidden() return true end
function modifier_imba_fountain_danger_zone:IsPurgable() return false end
function modifier_imba_fountain_danger_zone:IsPurgeException() return false end
function modifier_imba_fountain_danger_zone:IsStunDebuff() return false end

-- function modifier_imba_fountain_danger_zone:CheckState()
	-- local state = {
		-- [MODIFIER_STATE_DISARMED] = true,
	-- }

	-- return state
-- end

function modifier_imba_fountain_danger_zone:OnCreated()
	self.interval = 0.2

	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_fountain_danger_zone:OnIntervalThink()
	if IsServer() then
		local fountain = self:GetParent()
		local fountain_pos = fountain:GetAbsOrigin() 
		local nearby_enemies = FindUnitsInRadius(fountain:GetTeamNumber(), fountain_pos, nil, self:GetAbility():GetSpecialValueFor("kill_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		if #nearby_enemies == 0 then return end

		for _, enemy in pairs(nearby_enemies) do
			local damage = (enemy:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage_pct") / 100) * self.interval
			local aura_linger = self:GetAbility():GetSpecialValueFor("aura_linger")

			if enemy:IsInvulnerable() then
				enemy:SetHealth(math.max(enemy:GetHealth() - damage, 1))
			else
				ApplyDamage({attacker = fountain, victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			end

			enemy:AddNewModifier(fountain, self:GetAbility(), "modifier_doom_bringer_doom", {duration = aura_linger})
			enemy:AddNewModifier(fountain, self:GetAbility(), "modifier_imba_fountain_danger_zone_debuff", {duration = aura_linger})
		end
	
		-- All this forcekill nonsense is kinda causing problems but I'll leave the whole block here for reference
		-- local act_on_target = 1 -- 0 = do nothing, 1 = damage, 2 = kill, 3 = remove.

		-- for _, enemy in pairs(nearby_enemies) do
			-- -- do this before the ignore fountain units to prevent killing units that shouldn't be killed!
			-- if not enemy:IsConsideredHero() then
				-- act_on_target = 3
			-- end

			-- -- Ignore a list of units
			-- for _, unit_name in pairs(IGNORE_FOUNTAIN_UNITS) do
				-- if unit_name == enemy:GetUnitName() then
					-- act_on_target = 0
					-- break
				-- end
			-- end

			-- -- Ignore roshan(s)
			-- if string.find(enemy:GetUnitName(), "roshan") then
				-- act_on_target = 0
			-- end

			-- if enemy:IsIllusion() then
				-- act_on_target = 2
			-- end

			-- for _, unit_name in pairs(RESTRICT_FOUNTAIN_UNITS) do
				-- if unit_name == enemy:GetUnitName() then
					-- act_on_target = 2
					-- break
				-- end
			-- end

			-- -- Potential fix to another unidentified bug
			-- if enemy:IsCourier() then
				-- act_on_target = 2
			-- end

			-- if act_on_target == 1 then
				-- local damage = (enemy:GetMaxHealth() * self:GetAbility():GetSpecialValueFor("damage_pct") / 100) * self.interval
				-- local aura_linger = self:GetAbility():GetSpecialValueFor("aura_linger")
-- --				print("Damage:", damage)

				-- if enemy:IsInvulnerable() then
					-- enemy:SetHealth(math.max(enemy:GetHealth() - damage, 1))
				-- else
					-- ApplyDamage({attacker = fountain, victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
				-- end

-- --				local damage_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_laser.vpcf", PATTACH_CUSTOMORIGIN, enemy)
-- --				ParticleManager:SetParticleControl(damage_pfx, 0, fountain_pos)
-- --				ParticleManager:SetParticleControlEnt(damage_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
-- --				ParticleManager:SetParticleControl(damage_pfx, 3, fountain_pos)
-- --				ParticleManager:SetParticleControl(damage_pfx, 9, fountain_pos)
-- --				ParticleManager:ReleaseParticleIndex(damage_pfx)
				-- enemy:AddNewModifier(fountain, self:GetAbility(), "modifier_doom_bringer_doom", {duration = aura_linger})
				-- enemy:AddNewModifier(fountain, self:GetAbility(), "modifier_imba_fountain_danger_zone_debuff", {duration = aura_linger})
			-- elseif act_on_target == 2 then
				-- enemy:ForceKill(false)
			-- elseif act_on_target == 3 then
				-- -- Potential fix for a bug not clearly identified (it's everyday bro)
				-- if not enemy:IsRealHero() then
					-- -- Can we like not use this remove thing cause it's causing stupid errors with deleted entities
					-- --UTIL_Remove(enemy)
					
					-- enemy:ForceKill(false)
				-- end
			-- end
		-- end
	end
end

modifier_imba_fountain_danger_zone_debuff = class({})
function modifier_imba_fountain_danger_zone_debuff:IsDebuff() return false end
function modifier_imba_fountain_danger_zone_debuff:IsHidden() return true end
function modifier_imba_fountain_danger_zone_debuff:IsPurgable() return false end
function modifier_imba_fountain_danger_zone_debuff:IsPurgeException() return false end
function modifier_imba_fountain_danger_zone_debuff:IsStunDebuff() return false end
function modifier_imba_fountain_danger_zone_debuff:IgnoreTenacity()	return true end

function modifier_imba_fountain_danger_zone_debuff:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
end
