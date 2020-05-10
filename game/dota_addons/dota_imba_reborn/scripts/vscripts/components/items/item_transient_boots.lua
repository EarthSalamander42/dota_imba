-- Creator:
-- 	AltiV - March 15th, 2019

LinkLuaModifier("modifier_item_imba_transient_boots", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_transient_boots_invis", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_transient_boots_break", "components/items/item_transient_boots.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_transient_boots					= class({})
modifier_item_imba_transient_boots			= class({})
modifier_item_imba_transient_boots_invis	= class({})
modifier_item_imba_transient_boots_break	= class({})	

--------------------------
-- TRANSIENT BOOTS BASE --
--------------------------

function item_imba_transient_boots:GetIntrinsicModifierName()
	return "modifier_item_imba_transient_boots"
end

function item_imba_transient_boots:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_item_imba_transient_boots_break") then
		return "custom/imba_transient_boots"
	else
		return "custom/imba_transient_boots_broken"
	end
end

function item_imba_transient_boots:OnSpellStart()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	self.target		= self:GetCursorTarget()
	
	-- AbilitySpecials
	self.duration				= self:GetSpecialValueFor("duration")
	
	if not IsServer() then return end
	
	-- Play the cast sound
	self.caster:EmitSound("Item.GlimmerCape.Activate")
	
	-- Emit the particles
	self.particle = ParticleManager:CreateParticle("particles/items3_fx/glimmer_cape_initial_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
	ParticleManager:ReleaseParticleIndex(self.particle)

	self.target:AddNewModifier(self.caster, self, "modifier_item_imba_transient_boots_invis", {duration = self.duration})
end

------------------------------------
-- TRANSIENT BOOTS INVIS MODIFIER --
------------------------------------

function modifier_item_imba_transient_boots_invis:GetEffectName()
	return "particles/items3_fx/glimmer_cape_initial.vpcf"
end

function modifier_item_imba_transient_boots_invis:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.fade_delay				=	self.ability:GetSpecialValueFor("fade_delay")
	self.active_magical_armor	=	self.ability:GetSpecialValueFor("active_magical_armor")
	self.bonus_movement_speed	=	self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_health_regen		=	self.ability:GetSpecialValueFor("bonus_health_regen")
	
	if not IsServer() then return end
	
	-- Keep a counter to check for how much time has passed before applying invisibility again (basically fade_delay)
	self.counter	= 0

	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_transient_boots_invis:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_transient_boots_invis:OnIntervalThink()
	if not IsServer() then return end
	
	local present_mod	= false
	
	for _, modifier in pairs(self.parent:FindAllModifiersByName("modifier_invisible")) do
		if modifier:GetAbility() == self.ability then
			present_mod = true
			break
		end
	end
	
	if not present_mod then
		self.counter	= self.counter + FrameTime()
	
		if self.counter >= self.fade_delay then
			self.parent:AddNewModifier(self.caster, self.ability, "modifier_invisible", {duration = self:GetRemainingTime(), cancelattack = false})
			self.counter	= 0
			
			-- This ability is programmed kind of messed up...but at least have this block so units don't keep getting their attacks interrupted when this activates
			if self:GetParent():GetAggroTarget() then
				self:GetParent():MoveToTargetToAttack(self:GetParent():GetAggroTarget())
			end
		end
	end
end

function modifier_item_imba_transient_boots_invis:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
	
    return decFuncs
end

function modifier_item_imba_transient_boots_invis:GetModifierMagicalResistanceBonus()
	-- Technically you can cheese the bonus magic resist with any form of invisibility while this modifier is active but like...come on
	if self.parent:HasModifier("modifier_invisible") then
		return self.active_magical_armor
	end
end


function modifier_item_imba_transient_boots_invis:GetModifierMoveSpeedBonus_Special_Boots()
	if not self.caster:HasModifier("modifier_item_imba_transient_boots_break") and self.caster ~= self.parent and self.parent:HasModifier("modifier_invisible") then
		return self.bonus_movement_speed
	end
end

function modifier_item_imba_transient_boots_invis:GetModifierConstantHealthRegen()
	if not self.caster:HasModifier("modifier_item_imba_transient_boots_break") and self.caster ~= self.parent and self.parent:HasModifier("modifier_invisible") then
		return self.bonus_health_regen
	end
end

------------------------------------
-- TRANSIENT BOOTS BREAK MODIFIER --
------------------------------------

function modifier_item_imba_transient_boots_break:IsDebuff()		return true end
function modifier_item_imba_transient_boots_break:IsPurgable()		return false end
function modifier_item_imba_transient_boots_break:RemoveOnDeath()	return false end

------------------------------
-- TRANSIENT BOOTS MODIFIER --
------------------------------

function modifier_item_imba_transient_boots:IsHidden()		return true end
function modifier_item_imba_transient_boots:IsPurgable()		return false end
function modifier_item_imba_transient_boots:RemoveOnDeath()	return false end
function modifier_item_imba_transient_boots:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_transient_boots:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_movement_speed	=	self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_health_regen		=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_attack_speed		=	self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_magical_armor	=	self.ability:GetSpecialValueFor("bonus_magical_armor")
	
	self.break_time				=	self.ability:GetSpecialValueFor("break_time")
	self.broken_movement_speed	= 	self.ability:GetSpecialValueFor("broken_movement_speed")
end

function modifier_item_imba_transient_boots:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	
    return decFuncs
end

function modifier_item_imba_transient_boots:GetModifierMoveSpeedBonus_Special_Boots()
	if not self.parent:HasModifier("modifier_item_imba_transient_boots_break") then
		return self.bonus_movement_speed
	else
		return self.broken_movement_speed
	end
end

function modifier_item_imba_transient_boots:GetModifierConstantHealthRegen()
	if not self.parent:HasModifier("modifier_item_imba_transient_boots_break") then
		return self.bonus_health_regen
	end
end

function modifier_item_imba_transient_boots:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_imba_transient_boots:GetModifierMagicalResistanceBonus()
	return self.bonus_magical_armor
end

function modifier_item_imba_transient_boots:OnAttackLanded(keys)
	if not IsServer() then return end

	if (keys.attacker == self.parent and keys.target:IsHero()) or keys.target == self.parent then
		-- Modifier respects cooldown reductions
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_imba_transient_boots_break", {duration = self.break_time * self.ability:GetEffectiveCooldown(self.ability:GetLevel()) / self.ability:GetCooldown(self.ability:GetLevel())})
	end
end
