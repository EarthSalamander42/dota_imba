--	Author: Firetoad
--	Date: 			11.10.2015
--	Last Update:	19.03.2017

-----------------------------------------------------------------------------------------------------------
--	Stout Shield definition
-----------------------------------------------------------------------------------------------------------

if item_imba_stout_shield == nil then item_imba_stout_shield = class({}) end
LinkLuaModifier( "modifier_item_imba_stout_shield", "items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )	-- Owner's bonus attributes, stackable

function item_imba_stout_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_stout_shield" end

-----------------------------------------------------------------------------------------------------------
--	Stout Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_stout_shield == nil then modifier_item_imba_stout_shield = class({}) end
function modifier_item_imba_stout_shield:IsHidden() return true end
function modifier_item_imba_stout_shield:IsDebuff() return false end
function modifier_item_imba_stout_shield:IsPurgable() return false end
function modifier_item_imba_stout_shield:IsPermanent() return true end
function modifier_item_imba_stout_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Custom unique damage block property
function modifier_item_imba_stout_shield:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield definition
-----------------------------------------------------------------------------------------------------------

if item_imba_poor_mans_shield == nil then item_imba_poor_mans_shield = class({}) end
LinkLuaModifier( "modifier_item_imba_poor_mans_shield", "items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )	-- Owner's bonus attributes, stackable

function item_imba_poor_mans_shield:GetIntrinsicModifierName()
	return "modifier_item_imba_poor_mans_shield" end

-----------------------------------------------------------------------------------------------------------
--	Poor Man's Shield owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_poor_mans_shield == nil then modifier_item_imba_poor_mans_shield = class({}) end
function modifier_item_imba_poor_mans_shield:IsHidden() return true end
function modifier_item_imba_poor_mans_shield:IsDebuff() return false end
function modifier_item_imba_poor_mans_shield:IsPurgable() return false end
function modifier_item_imba_poor_mans_shield:IsPermanent() return true end
function modifier_item_imba_poor_mans_shield:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Custom unique damage block property
function modifier_item_imba_poor_mans_shield:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Declare modifier events/properties
function modifier_item_imba_poor_mans_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_item_imba_poor_mans_shield:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agi") end

-----------------------------------------------------------------------------------------------------------
--	Vanguard definition
-----------------------------------------------------------------------------------------------------------

if item_imba_vanguard == nil then item_imba_vanguard = class({}) end
LinkLuaModifier( "modifier_item_imba_vanguard", "items/item_vanguard.lua", LUA_MODIFIER_MOTION_NONE )			-- Owner's bonus attributes, stackable

function item_imba_vanguard:GetIntrinsicModifierName()
	return "modifier_item_imba_vanguard" end

-----------------------------------------------------------------------------------------------------------
--	Vanguard owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_vanguard == nil then modifier_item_imba_vanguard = class({}) end
function modifier_item_imba_vanguard:IsHidden() return true end
function modifier_item_imba_vanguard:IsDebuff() return false end
function modifier_item_imba_vanguard:IsPurgable() return false end
function modifier_item_imba_vanguard:IsPermanent() return true end
function modifier_item_imba_vanguard:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Custom unique damage block property
function modifier_item_imba_vanguard:GetCustomDamageBlockUnique()
	return self:GetAbility():GetSpecialValueFor("damage_block") end

-- Declare modifier events/properties
function modifier_item_imba_vanguard:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_vanguard:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health") end

function modifier_item_imba_vanguard:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("health_regen") end


function CrimsonGuard( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_active") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})			
		end
	end
end

function CrimsonGuardParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.crimson_guard_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.crimson_guard_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.crimson_guard_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function CrimsonGuardParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.crimson_guard_pfx, false)
end

function GreatwyrmPlate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_active = keys.modifier_active
	local sound_cast = keys.sound_cast
	local particle_cast = keys.particle_cast

	-- Parameters
	local active_radius = ability:GetLevelSpecialValueFor("active_radius", ability_level)
	local cooldown = ability:GetCooldownTimeRemaining()

	-- Play sound
	caster:EmitSound(sound_cast)

	-- Play particle
	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 2, Vector(active_radius, 0, 0))

	-- Find nearby allies
	local nearby_allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, active_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)

	-- Apply the active buff to nearby allies
	for _,ally in pairs(nearby_allies) do
		if not ally:HasModifier("modifier_item_crimson_guard_unique") and not ally:HasModifier("modifier_item_greatwyrm_plate_unique") then
			ally:RemoveModifierByName("modifier_item_crimson_guard_active")
			ability:ApplyDataDrivenModifier(caster, ally, modifier_active, {})
		end
	end
end

function GreatwyrmParticle( keys )
	local target = keys.target
	local particle_guard = keys.particle_guard
	
	-- Create the Crimson Guard particle
	target.greatwyrm_plate_pfx = ParticleManager:CreateParticle(particle_guard, PATTACH_OVERHEAD_FOLLOW, target)
	ParticleManager:SetParticleControl(target.greatwyrm_plate_pfx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(target.greatwyrm_plate_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function GreatwyrmParticleEnd( keys )
	local target = keys.target
	
	-- Destroy the Crimson Guard particle
	ParticleManager:DestroyParticle(target.greatwyrm_plate_pfx, false)
end