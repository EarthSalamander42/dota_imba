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

--	Author: Firetoad
--	Date: 			19.07.2016
--	Last Update:	26.03.2017
--	Maelstrom, Mjollnir and Jarnbjorn

-----------------------------------------------------------------------------------------------------------
--	Maelstrom definition
-----------------------------------------------------------------------------------------------------------

if item_imba_maelstrom == nil then item_imba_maelstrom = class({}) end
LinkLuaModifier( "modifier_item_imba_maelstrom", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_maelstrom:GetIntrinsicModifierName()
	return "modifier_item_imba_maelstrom" end

function item_imba_maelstrom:GetAbilityTextureName()
	return "custom/imba_maelstrom"
end

-----------------------------------------------------------------------------------------------------------
--	Maelstrom passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_maelstrom == nil then modifier_item_imba_maelstrom = class({}) end
function modifier_item_imba_maelstrom:IsHidden() return true end
function modifier_item_imba_maelstrom:IsDebuff() return false end
function modifier_item_imba_maelstrom:IsPurgable() return false end
function modifier_item_imba_maelstrom:IsPermanent() return true end

function modifier_item_imba_maelstrom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Declare modifier events/properties
function modifier_item_imba_maelstrom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_maelstrom:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_maelstrom:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_maelstrom:OnAttackLanded( keys )
	if IsServer() then
		local attacker = self:GetParent()

		-- If this attack is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return
		end

		-- If this is an illusion, do nothing either
		if attacker:IsIllusion() then
			return
		end

		-- If the target is invalid, still do nothing
		local target = keys.target
		if (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
			return end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()

		-- zap the target's ass
		local proc_chance = ability:GetSpecialValueFor("proc_chance")
		if RollPseudoRandom(proc_chance, ability) then
			LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
		end
	end
end


-----------------------------------------------------------------------------------------------------------
--	Mjollnir definition
-----------------------------------------------------------------------------------------------------------

if item_imba_mjollnir == nil then item_imba_mjollnir = class({}) end
LinkLuaModifier( "modifier_item_imba_mjollnir", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_mjollnir_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Attack proc counter
LinkLuaModifier( "modifier_item_imba_mjollnir_static", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Static shield
LinkLuaModifier( "modifier_item_imba_mjollnir_static_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )	-- Shield proc counter
LinkLuaModifier( "modifier_item_imba_mjollnir_slow", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )				-- Shield slow

function item_imba_mjollnir:GetIntrinsicModifierName()
	return "modifier_item_imba_mjollnir"
end

function item_imba_mjollnir:GetAbilityTextureName()
	return "item_mjollnir"
end

function item_imba_mjollnir:OnSpellStart()
	if IsServer() then

		-- Apply the modifier to the target
		local target = self:GetCursorTarget()
		target:AddNewModifier(target, self, "modifier_item_imba_mjollnir_static", {duration = self:GetSpecialValueFor("static_duration")})

		-- Play cast sound
		target:EmitSound("DOTA_Item.Mjollnir.Activate")
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir == nil then modifier_item_imba_mjollnir = class({}) end
function modifier_item_imba_mjollnir:IsHidden() return true end
function modifier_item_imba_mjollnir:IsDebuff() return false end
function modifier_item_imba_mjollnir:IsPurgable() return false end
function modifier_item_imba_mjollnir:IsPermanent() return true end

function modifier_item_imba_mjollnir:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_mjollnir:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

function modifier_item_imba_mjollnir:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as") end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_mjollnir:OnAttackLanded( keys )
	if IsServer() then
		local attacker = self:GetParent()

		-- If this attack is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return
		end

		-- If this is an illusion, do nothing either
		if attacker:IsIllusion() then
			return
		end

		-- If the target is invalid, still do nothing
		local target = keys.target
		if (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
			return
		end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()

		-- zap the target's ass
		local proc_chance = ability:GetSpecialValueFor("proc_chance")
		if RollPseudoRandom(proc_chance, ability) then
			LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir static shield
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir_static == nil then modifier_item_imba_mjollnir_static = class({}) end
function modifier_item_imba_mjollnir_static:IsHidden() return false end
function modifier_item_imba_mjollnir_static:IsDebuff() return false end
function modifier_item_imba_mjollnir_static:IsPurgable() return true end

-- Modifier particle
function modifier_item_imba_mjollnir_static:GetEffectName()
	return "particles/items2_fx/mjollnir_shield.vpcf" end

function modifier_item_imba_mjollnir_static:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

-- Start playing sound and store ability parameters
function modifier_item_imba_mjollnir_static:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
		self.static_cooldown = false
	end
end

function modifier_item_imba_mjollnir_static:OnIntervalThink()
	self.static_cooldown = false
	self:StartIntervalThink(-1)
end

-- Stop playing sound and destroy the proc counter
function modifier_item_imba_mjollnir_static:OnDestroy()
	if IsServer() then
		StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
		self:GetParent():RemoveModifierByName("modifier_item_imba_mjollnir_static_counter")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir_static:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- On damage taken, count stacks and proc the static shield
function modifier_item_imba_mjollnir_static:OnTakeDamage( keys )
	if IsServer() then
		local shield_owner = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if shield_owner ~= keys.unit then
			return end

		-- If the attacker is invalid, do nothing either
		if keys.attacker:GetTeam() == shield_owner:GetTeam() then
			return end
			
		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()
		-- If enough stacks accumulated, reset them and zap nearby enemies
		local static_proc_chance = ability:GetSpecialValueFor("static_proc_chance")
		local static_damage = ability:GetSpecialValueFor("static_damage")
		local static_radius = ability:GetSpecialValueFor("static_radius")
		local static_slow_duration = ability:GetSpecialValueFor("static_slow_duration")
		
		if not self.static_cooldown and keys.damage >= 5 and RollPseudoRandom(static_proc_chance, ability) then
			self.static_cooldown = true
			self:StartIntervalThink(ability:GetSpecialValueFor("static_cooldown"))
			
			-- Iterate through nearby enemies
			local static_origin = shield_owner:GetAbsOrigin() + Vector(0, 0, 100)
			local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do

				-- Play particle
				local static_pfx = ParticleManager:CreateParticle("particles/item/mjollnir/static_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, shield_owner)
				ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
				ParticleManager:ReleaseParticleIndex(static_pfx)

				-- Apply damage
				ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(shield_owner, ability, "modifier_item_imba_mjollnir_slow", {duration = static_slow_duration})
			end

			-- Play hit sound if at least one enemy was hit
			if #nearby_enemies > 0 then
				shield_owner:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mjollnir passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mjollnir_slow == nil then modifier_item_imba_mjollnir_slow = class({}) end
function modifier_item_imba_mjollnir_slow:IsHidden() return false end
function modifier_item_imba_mjollnir_slow:IsDebuff() return true end
function modifier_item_imba_mjollnir_slow:IsPurgable() return true end

-- Declare modifier events/properties
function modifier_item_imba_mjollnir_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_mjollnir_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("static_slow")
end

function modifier_item_imba_mjollnir_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("static_slow")
end

-----------------------------------------------------------------------------------------------------------
--	Jarnbjorn definition
-----------------------------------------------------------------------------------------------------------

if item_imba_jarnbjorn == nil then item_imba_jarnbjorn = class({}) end
LinkLuaModifier( "modifier_item_imba_jarnbjorn", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_jarnbjorn_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Attack proc counter
LinkLuaModifier( "modifier_item_imba_jarnbjorn_static", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )			-- Static shield
LinkLuaModifier( "modifier_item_imba_jarnbjorn_static_counter", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )	-- Shield proc counter
LinkLuaModifier( "modifier_item_imba_jarnbjorn_slow", "components/items/item_maelstrom.lua", LUA_MODIFIER_MOTION_NONE )				-- Shield slow

function item_imba_jarnbjorn:GetIntrinsicModifierName()
	return "modifier_item_imba_jarnbjorn"
end

function item_imba_jarnbjorn:GetAbilityTextureName()
	return "custom/imba_jarnbjorn"
end

function item_imba_jarnbjorn:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()
		local tree_cooldown = self:GetSpecialValueFor("tree_cooldown")

		if target.GetUnitName == nil then
			self:RefundManaCost()
			target:CutDown(-1)
			self:EndCooldown()
			self:StartCooldown(tree_cooldown)
		else
			-- Play cast sound
			target:EmitSound("DOTA_Item.Mjollnir.Activate")
			target:AddNewModifier(target, self, "modifier_item_imba_jarnbjorn_static", {duration = self:GetSpecialValueFor("static_duration")})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Jarnbjorn passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_jarnbjorn == nil then modifier_item_imba_jarnbjorn = class({}) end
function modifier_item_imba_jarnbjorn:IsHidden() return true end
function modifier_item_imba_jarnbjorn:IsDebuff() return false end
function modifier_item_imba_jarnbjorn:IsPurgable() return false end
function modifier_item_imba_jarnbjorn:IsPermanent() return true end

function modifier_item_imba_jarnbjorn:GetTexture()
	return "modifiers/imba_jarnbjorn"
end

function modifier_item_imba_jarnbjorn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

-- Declare modifier events/properties
function modifier_item_imba_jarnbjorn:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_jarnbjorn:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_imba_jarnbjorn:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_as")
end

function modifier_item_imba_jarnbjorn:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_hp_regen")
end

function modifier_item_imba_jarnbjorn:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

-- On attack landed, roll for proc and apply stacks
function modifier_item_imba_jarnbjorn:OnAttackLanded( keys )
	if IsServer() then
		local attacker = self:GetParent()
		local damage = keys.damage

		-- If this attack is irrelevant, do nothing
		if attacker ~= keys.attacker then
			return
		end

		-- If this is an illusion, do nothing either
		if attacker:IsIllusion() then
			return
		end

		-- If the target is invalid, still do nothing
		local target = keys.target
		if (not target:IsHeroOrCreep()) then -- or attacker:GetTeam() == target:GetTeam() then
			return
		end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()

		-- zap the target's ass
		local proc_chance = ability:GetSpecialValueFor("proc_chance")
		if RollPseudoRandom(proc_chance, ability) then
			LaunchLightning(attacker, target, ability, ability:GetSpecialValueFor("bounce_damage"), ability:GetSpecialValueFor("bounce_radius"))
		end

		-- If this a ranged hero, do not cleave
		if attacker:IsRangedAttacker() then
			return
		end

		-- Only apply if the attacker is the parent of the buff, and the victim is on the opposing team.
		if self:GetParent() == attacker and self:GetParent():GetTeamNumber() ~= target:GetTeamNumber() then
			-- Add explosion particle
			local explosion_pfx = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave_b.vpcf", PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(explosion_pfx, 0, target:GetAbsOrigin())
			ParticleManager:SetParticleControl(explosion_pfx, 3, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(explosion_pfx)

			-- Calculate bonus damage
			local splash_damage = damage * (ability:GetSpecialValueFor("splash_damage_pct") * 0.01)

			DoCleaveAttack( attacker, keys.target, ability, splash_damage, ability:GetSpecialValueFor("cleave_start"), ability:GetSpecialValueFor("cleave_end"), ability:GetSpecialValueFor("splash_range"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf" )
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	jarnbjorn static shield
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_jarnbjorn_static == nil then modifier_item_imba_jarnbjorn_static = class({}) end
function modifier_item_imba_jarnbjorn_static:IsHidden() return false end
function modifier_item_imba_jarnbjorn_static:IsDebuff() return false end
function modifier_item_imba_jarnbjorn_static:IsPurgable() return true end

function modifier_item_imba_jarnbjorn_static:GetTexture()
	return "modifiers/imba_jarnbjorn"
end

-- Modifier particle
function modifier_item_imba_jarnbjorn_static:GetEffectName()
	return "particles/items2_fx/jarnbjorn_shield.vpcf" end

function modifier_item_imba_jarnbjorn_static:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

-- Start playing sound and store ability parameters
function modifier_item_imba_jarnbjorn_static:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
		self.static_cooldown = false
	end
end

function modifier_item_imba_jarnbjorn_static:OnIntervalThink()
	self.static_cooldown = false
	self:StartIntervalThink(-1)
end

-- Stop playing sound and destroy the proc counter
function modifier_item_imba_jarnbjorn_static:OnDestroy()
	if IsServer() then
		StopSoundEvent("DOTA_Item.Mjollnir.Loop", self:GetParent())
		self:GetParent():RemoveModifierByName("modifier_item_imba_jarnbjorn_static_counter")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_jarnbjorn_static:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

-- On damage taken, count stacks and proc the static shield
function modifier_item_imba_jarnbjorn_static:OnTakeDamage( keys )
	if IsServer() then
		local shield_owner = self:GetParent()

		-- If this damage event is irrelevant, do nothing
		if shield_owner ~= keys.unit then
			return end

		-- If the attacker is invalid, do nothing either
		if keys.attacker:GetTeam() == shield_owner:GetTeam() then
			return end

		-- All conditions met, stack the proc counter up
		local ability = self:GetAbility()
		-- If enough stacks accumulated, reset them and zap nearby enemies
		local static_proc_chance = ability:GetSpecialValueFor("static_proc_chance")
		local static_damage = ability:GetSpecialValueFor("static_damage")
		local static_radius = ability:GetSpecialValueFor("static_radius")
		local static_slow_duration = ability:GetSpecialValueFor("static_slow_duration")
		if not self.static_cooldown and keys.damage >= 5 and RollPseudoRandom(static_proc_chance, ability) then
			self.static_cooldown = true
			self:StartIntervalThink(ability:GetSpecialValueFor("static_cooldown"))

			-- Iterate through nearby enemies
			local static_origin = shield_owner:GetAbsOrigin() + Vector(0, 0, 100)
			local nearby_enemies = FindUnitsInRadius(shield_owner:GetTeamNumber(), shield_owner:GetAbsOrigin(), nil, static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(nearby_enemies) do

				-- Play particle
				local static_pfx = ParticleManager:CreateParticle("particles/item/jarnbjorn/static_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, shield_owner)
				ParticleManager:SetParticleControlEnt(static_pfx, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(static_pfx, 1, static_origin)
				ParticleManager:ReleaseParticleIndex(static_pfx)

				-- Apply damage
				ApplyDamage({attacker = shield_owner, victim = enemy, ability = ability, damage = static_damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(shield_owner, ability, "modifier_item_imba_jarnbjorn_slow", {duration = static_slow_duration})
			end

			-- Play hit sound if at least one enemy was hit
			if #nearby_enemies > 0 then
				shield_owner:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Jarnbjorn passive modifier (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_jarnbjorn_slow == nil then modifier_item_imba_jarnbjorn_slow = class({}) end
function modifier_item_imba_jarnbjorn_slow:IsHidden() return false end
function modifier_item_imba_jarnbjorn_slow:IsDebuff() return true end
function modifier_item_imba_jarnbjorn_slow:IsPurgable() return true end

function modifier_item_imba_jarnbjorn_slow:GetTexture()
	return "modifiers/imba_jarnbjorn"
end

-- Declare modifier events/properties
function modifier_item_imba_jarnbjorn_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_jarnbjorn_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("static_slow")
end

function modifier_item_imba_jarnbjorn_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("static_slow")
end

-----------------------------------------------------------------------------------------------------------
--	Lightning proc functions
-----------------------------------------------------------------------------------------------------------

-- Initial launch + main loop
function LaunchLightning(caster, target, ability, damage, bounce_radius)

	-- Parameters
	local targets_hit = { target }
	local search_sources = { target	}

	-- Play initial sound
	caster:EmitSound("Item.Maelstrom.Chain_Lightning")

	-- Play first bounce sound
	target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

	ZapThem(caster, ability, caster, target, damage)

	-- While there are potential sources, keep looping
	while #search_sources > 0 do

		-- Loop through every potential source this iteration
		for potential_source_index, potential_source in pairs(search_sources) do

			local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), potential_source:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

			for _, potential_target in pairs(nearby_enemies) do

				-- Check if this target was already hit
				local already_hit = false
				for _, hit_target in pairs(targets_hit) do
					if potential_target == hit_target then
						already_hit = true
						break
					end
				end

				-- If not, zap it from this source, and mark it as a hit target and potential future source
				if not already_hit then
					ZapThem(caster, ability, potential_source, potential_target, damage)
					targets_hit[#targets_hit+1] = potential_target
					search_sources[#search_sources+1] = potential_target
				end
			end

			-- Remove this potential source
			table.remove(search_sources, potential_source_index)
		end
	end
end

-- One bounce. Particle + damage
function ZapThem(caster, ability, source, target, damage)
	-- Draw particle
	local particle = "particles/items_fx/chain_lightning.vpcf"
	if ability:GetAbilityName() == "item_imba_jarnbjorn" then
		particle = "particles/items_fx/chain_lightning_jarnbjorn.vpcf"
	end

	local bounce_pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 1, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
	ParticleManager:ReleaseParticleIndex(bounce_pfx)

	ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end
