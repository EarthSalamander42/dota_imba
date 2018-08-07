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
--	Date: 			07.01.2015
--	Last Update:	02.04.2017
--	Blight stone, Desolator, and Stygian Desolator definitions.

-----------------------------------------------------------------------------------------------------------
--	Blight Stone definition
-----------------------------------------------------------------------------------------------------------

if item_imba_blight_stone == nil then item_imba_blight_stone = class({}) end
LinkLuaModifier( "modifier_item_imba_blight_stone", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_blight_stone_debuff", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )	-- Armor/vision debuff

function item_imba_blight_stone:GetIntrinsicModifierName()
	return "modifier_item_imba_blight_stone" end

function item_imba_blight_stone:GetAbilityTextureName()
	return "custom/imba_blight_stone"
end

-----------------------------------------------------------------------------------------------------------
--	Blight Stone owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_blight_stone == nil then modifier_item_imba_blight_stone = class({}) end
function modifier_item_imba_blight_stone:IsHidden() return true end
function modifier_item_imba_blight_stone:IsDebuff() return false end
function modifier_item_imba_blight_stone:IsPurgable() return false end
function modifier_item_imba_blight_stone:IsPermanent() return true end
function modifier_item_imba_blight_stone:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Possible projectile changes
function modifier_item_imba_blight_stone:OnCreated()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

function modifier_item_imba_blight_stone:OnDestroy()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Declare modifier events/properties
function modifier_item_imba_blight_stone:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

-- On attack landed, apply the debuff
function modifier_item_imba_blight_stone:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, or the wrong team to attack, do nothing either
		local target = keys.target
		if owner:IsIllusion() then -- or (owner:GetTeam() == target:GetTeam())then
			return end

		-- If a higher-priority modifier is present, still do nothing
		if target:HasModifier("modifier_item_imba_desolator_debuff") or target:HasModifier("modifier_item_imba_desolator_2_debuff") then
			return end

		-- All conditions met, apply the Blight Stone modifier
		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_imba_blight_stone_debuff", ability:GetSpecialValueFor("duration"))
	end
end

-----------------------------------------------------------------------------------------------------------
--	Blight Stone debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_blight_stone_debuff == nil then modifier_item_imba_blight_stone_debuff = class({}) end
function modifier_item_imba_blight_stone_debuff:IsHidden() return false end
function modifier_item_imba_blight_stone_debuff:IsDebuff() return true end
function modifier_item_imba_blight_stone_debuff:IsPurgable() return true end

-- Store modifier values in case the original ability is missing
function modifier_item_imba_blight_stone_debuff:OnCreated()
	local ability = self:GetAbility()

	if not ability then
		self:Destroy()
		return nil
	end

	self.armor_reduction = (-1) * ability:GetSpecialValueFor("armor_reduction")
	self.vision_reduction = (-1) * ability:GetSpecialValueFor("vision_reduction")
end

-- Declare modifier events/properties
function modifier_item_imba_blight_stone_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}
	return funcs
end

function modifier_item_imba_blight_stone_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction end

function modifier_item_imba_blight_stone_debuff:GetBonusDayVision()
	return self.vision_reduction end

function modifier_item_imba_blight_stone_debuff:GetBonusNightVision()
	return self.vision_reduction end



-----------------------------------------------------------------------------------------------------------
--	Desolator definition
-----------------------------------------------------------------------------------------------------------

if item_imba_desolator == nil then item_imba_desolator = class({}) end
LinkLuaModifier( "modifier_item_imba_desolator", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_desolator_debuff", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )		-- Armor/vision debuff

function item_imba_desolator:GetAbilityTextureName()
	return "custom/imba_desolator"
end

function item_imba_desolator:GetIntrinsicModifierName()
	return "modifier_item_imba_desolator" end

function item_imba_desolator:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local target_loc = self:GetCursorPosition()
		local projectile_radius = self:GetSpecialValueFor("projectile_radius")
		local projectile_length = self:GetSpecialValueFor("projectile_length")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")

		-- Play cast sound
		caster:EmitSound("Imba.DesolatorCast")

		-- Launch projectile
		local projectile_direction = (target_loc - caster_loc):Normalized()
		if target_loc == caster_loc then
			projectile_direction = caster:GetForwardVector()
		end

		local desolator_projectile = {
			Ability				= self,
			EffectName			= "particles/item/desolator/desolator_active.vpcf",
			vSpawnOrigin		= caster_loc + projectile_direction * 50 + Vector(0, 0, 100),
			fDistance			= projectile_length,
			fStartRadius		= projectile_radius,
			fEndRadius			= projectile_radius,
			Source				= caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			--	fExpireTime			= ,
			bDeleteOnHit		= false,
			vVelocity			= projectile_direction * projectile_speed,
			bProvidesVision		= false,
			iVisionRadius		= 0,
			iVisionTeamNumber	= caster:GetTeamNumber(),
		}

		ProjectileManager:CreateLinearProjectile(desolator_projectile)
	end
end

function item_imba_desolator:OnProjectileHit(target, target_loc)
	if IsServer() and target then
		local active_damage = self:GetSpecialValueFor("active_damage")

		-- Play hit sound
		target:EmitSound("Item_Desolator.Target")

		-- Remove lower priority debuffs
		target:RemoveModifierByName("modifier_item_imba_blight_stone_debuff")

		-- Apply the armor debuff, if applicable
		if not target:HasModifier("modifier_item_imba_desolator_2_debuff") then
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_desolator_debuff", {duration = self:GetSpecialValueFor("duration")})
		end

		-- Fire the effect particle
		local effect_pfx = ParticleManager:CreateParticle("particles/item/desolator/desolator_active_damage.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControl(effect_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(effect_pfx, 1, target_loc + Vector(0, 0, 100))
		ParticleManager:ReleaseParticleIndex(effect_pfx)

		-- Deal minor physical damage on every think
		ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self, damage = active_damage , damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Desolator owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_desolator == nil then modifier_item_imba_desolator = class({}) end
function modifier_item_imba_desolator:IsHidden() return true end
function modifier_item_imba_desolator:IsDebuff() return false end
function modifier_item_imba_desolator:IsPurgable() return false end
function modifier_item_imba_desolator:IsPermanent() return true end
function modifier_item_imba_desolator:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Possible projectile changes
function modifier_item_imba_desolator:OnCreated()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

function modifier_item_imba_desolator:OnDestroy()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Declare modifier events/properties
function modifier_item_imba_desolator:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_desolator:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage")
end

-- On attack landed, apply the debuff
function modifier_item_imba_desolator:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, or the wrong team to attack, do nothing either
		local target = keys.target
		if owner:IsIllusion() then -- or (owner:GetTeam() == target:GetTeam())then
			return end

		-- If a higher-priority modifier is present, still do nothing
		if target:HasModifier("modifier_item_imba_desolator_2_debuff") then
			return end

		-- If a lower-priority modifier is present, remove it
		target:RemoveModifierByName("modifier_item_imba_blight_stone_debuff")

		-- All conditions met, apply the Desolator modifier
		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_imba_desolator_debuff", ability:GetSpecialValueFor("duration"))
	end
end

-----------------------------------------------------------------------------------------------------------
--	Desolator debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_desolator_debuff == nil then modifier_item_imba_desolator_debuff = class({}) end
function modifier_item_imba_desolator_debuff:IsHidden() return false end
function modifier_item_imba_desolator_debuff:IsDebuff() return true end
function modifier_item_imba_desolator_debuff:IsPurgable() return true end

-- Store modifier values in case the original ability is missing
function modifier_item_imba_desolator_debuff:OnCreated()
	local ability = self:GetAbility()
	self.armor_reduction = (-1) * ability:GetSpecialValueFor("armor_reduction")
	self.vision_reduction = (-1) * ability:GetSpecialValueFor("vision_reduction")
end

-- Declare modifier events/properties
function modifier_item_imba_desolator_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}
	return funcs
end

function modifier_item_imba_desolator_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction end

function modifier_item_imba_desolator_debuff:GetBonusDayVision()
	return self.vision_reduction end

function modifier_item_imba_desolator_debuff:GetBonusNightVision()
	return self.vision_reduction end



-----------------------------------------------------------------------------------------------------------
--	Stygian Desolator definition
-----------------------------------------------------------------------------------------------------------

if item_imba_desolator_2 == nil then item_imba_desolator_2 = class({}) end
LinkLuaModifier( "modifier_item_imba_desolator_2", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_desolator_2_debuff", "components/items/item_desolator.lua", LUA_MODIFIER_MOTION_NONE )	-- Armor/vision debuff

function item_imba_desolator_2:GetAbilityTextureName()
	return "custom/imba_desolator_2"
end

function item_imba_desolator_2:GetIntrinsicModifierName()
	return "modifier_item_imba_desolator_2" end

function item_imba_desolator_2:OnSpellStart()
	-- Parameters
	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = self:GetCursorPosition()
	local projectile_radius = self:GetSpecialValueFor("projectile_radius")
	local projectile_length = self:GetSpecialValueFor("projectile_length")
	local projectile_speed = self:GetSpecialValueFor("projectile_speed")
	local projectile_cone = self:GetSpecialValueFor("projectile_cone")
	local projectile_amount = self:GetSpecialValueFor("projectile_amount")

	-- Determine projectile geometry
	local projectile_directions = {}
	local main_direction = (target_loc - caster_loc):Normalized()
	if target_loc == caster_loc then
		main_direction = caster:GetForwardVector()
	end
	local angle_step = projectile_cone / (projectile_amount - 1)
	for i = 1, projectile_amount do
		projectile_directions[i] = RotatePosition(caster_loc, QAngle(0, (i - 1) * angle_step - projectile_cone * 0.5, 0), caster_loc + main_direction * 50)
	end

	-- Base projectile information
	local desolator_projectile = {
		Ability				= self,
		EffectName			= "particles/item/desolator/desolator2_active.vpcf",
		vSpawnOrigin		= caster_loc + main_direction * 50 + Vector(0, 0, 100),
		fDistance			= projectile_length,
		fStartRadius		= projectile_radius,
		fEndRadius			= projectile_radius,
		Source				= caster,
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		--	fExpireTime			= ,
		bDeleteOnHit		= false,
		vVelocity			= main_direction * projectile_speed,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= caster:GetTeamNumber(),
	}

	-- Launch projectiles
	local projectiles_launched = 0
	Timers:CreateTimer(function()
		caster:EmitSound("Imba.DesolatorCast")
		desolator_projectile.vSpawnOrigin = projectile_directions[projectiles_launched + 1] + Vector(0, 0, 100)
		desolator_projectile.vVelocity = (projectile_directions[projectiles_launched + 1] - caster_loc):Normalized() * projectile_speed
		desolator_projectile.vVelocity.z = 0
		ProjectileManager:CreateLinearProjectile(desolator_projectile)

		-- Stop looping if the proper amount was reached
		projectiles_launched = projectiles_launched + 1
		if projectiles_launched < projectile_amount then
			return 0.1
		end
	end)
end

function item_imba_desolator_2:OnProjectileHit(target, target_loc)
	if IsServer() and target then
		local active_damage = self:GetSpecialValueFor("active_damage")

		-- Play hit sound
		target:EmitSound("Item_Desolator.Target")

		-- Remove lower priority debuffs
		target:RemoveModifierByName("modifier_item_imba_blight_stone_debuff")

		-- Apply the armor debuff, if applicable
		if not target:HasModifier("modifier_item_imba_desolator_2_debuff") then
			target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_desolator_debuff", {duration = self:GetSpecialValueFor("duration")})
		end

		-- Fire the effect particle
		local effect_pfx = ParticleManager:CreateParticle("particles/item/desolator/desolator_active_damage.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControl(effect_pfx, 0, target_loc)
		ParticleManager:SetParticleControl(effect_pfx, 1, target_loc + Vector(0, 0, 100))
		ParticleManager:ReleaseParticleIndex(effect_pfx)

		-- Deal minor physical damage on every think
		ApplyDamage({attacker = self:GetCaster(), victim = target, ability = self, damage = active_damage , damage_type = DAMAGE_TYPE_PHYSICAL})
	end
end

-----------------------------------------------------------------------------------------------------------
--	Stygian Desolator owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_desolator_2 == nil then modifier_item_imba_desolator_2 = class({}) end
function modifier_item_imba_desolator_2:IsHidden() return true end
function modifier_item_imba_desolator_2:IsDebuff() return false end
function modifier_item_imba_desolator_2:IsPurgable() return false end
function modifier_item_imba_desolator_2:IsPermanent() return true end
function modifier_item_imba_desolator_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Possible projectile changes
function modifier_item_imba_desolator_2:OnCreated()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

function modifier_item_imba_desolator_2:OnDestroy()
	if IsServer() then
		ChangeAttackProjectileImba(self:GetParent())
	end
end

-- Declare modifier events/properties
function modifier_item_imba_desolator_2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_item_imba_desolator_2:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage") end

-- On attack landed, apply the debuff
function modifier_item_imba_desolator_2:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		-- If this attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return end

		-- If this is an illusion, or the wrong team to attack, do nothing either
		local target = keys.target
		if owner:IsIllusion() then -- or (owner:GetTeam() == target:GetTeam())then
			return end

		-- If a lower-priority modifier is present, remove it
		target:RemoveModifierByName("modifier_item_imba_blight_stone_debuff")
		target:RemoveModifierByName("modifier_item_imba_desolator_debuff")

		-- All conditions met, apply the Desolator modifier
		local ability = self:GetAbility()
		Desolate(owner, target, ability, "modifier_item_imba_desolator_2_debuff", ability:GetSpecialValueFor("duration"))
	end
end

-----------------------------------------------------------------------------------------------------------
--	Stygian Desolator debuff
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_desolator_2_debuff == nil then modifier_item_imba_desolator_2_debuff = class({}) end
function modifier_item_imba_desolator_2_debuff:IsHidden() return false end
function modifier_item_imba_desolator_2_debuff:IsDebuff() return true end
function modifier_item_imba_desolator_2_debuff:IsPurgable() return true end

-- Store modifier values in case the original ability is missing
function modifier_item_imba_desolator_2_debuff:OnCreated()
	local ability = self:GetAbility()
	if ability then
		self.armor_reduction = (-1) * ability:GetSpecialValueFor("armor_reduction")
		self.vision_reduction = (-1) * ability:GetSpecialValueFor("vision_reduction")
	end
end

-- Declare modifier events/properties
function modifier_item_imba_desolator_2_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	}
	return funcs
end

function modifier_item_imba_desolator_2_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction end

function modifier_item_imba_desolator_2_debuff:GetBonusDayVision()
	return self.vision_reduction end

function modifier_item_imba_desolator_2_debuff:GetBonusNightVision()
	return self.vision_reduction end



-----------------------------------------------------------------------------------------------------------
--	Reusable debuff-applying function
-----------------------------------------------------------------------------------------------------------

function Desolate(attacker, target, ability, modifier_name, duration)

	-- Only play the sound when first applied
	if not target:HasModifier(modifier_name) then
		target:EmitSound("Item_Desolator.Target")
	end

	-- Apply the modifier
	target:AddNewModifier(attacker, ability, modifier_name, {duration = duration})
end
