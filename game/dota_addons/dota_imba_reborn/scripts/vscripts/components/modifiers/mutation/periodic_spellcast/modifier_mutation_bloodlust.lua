-- Coded by AltiV
-- 29.06.2018

-- This Periodic Spellcast version of Bloodlust increases move speed, attack speed, cast speed, and model size.

--[[Bloodlust Buff]]--

modifier_mutation_bloodlust = class({})

-- Add proper buff icon on toolbar
function modifier_mutation_bloodlust:GetTexture() return "ogre_magi_bloodlust" end

-- Add particle effects to heroes affected
function modifier_mutation_bloodlust:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_mutation_bloodlust:OnCreated()
	-- Ability values
	self.movespeed = 20 -- % of hero's movespeed added on buff
	self.attackspeed = 100 -- increase in attack speed
	self.castspeed = 40 -- increase in casting speed
	self.size = 25 -- % of hero's model size increase

	if IsServer() then
		EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", self:GetParent())
		EmitSoundOn("Hero_OgreMagi.Bloodlust.Target.FP", self:GetParent())
	end
end

-- Only called if buff overlaps with itself (which is probably never)
function modifier_mutation_bloodlust:OnRefresh()
	if IsServer() then
		EmitSoundOn("Hero_OgreMagi.Bloodlust.Target", self:GetParent())
		EmitSoundOn("Hero_OgreMagi.Bloodlust.Target.FP", self:GetParent())
	end
end

function modifier_mutation_bloodlust:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	MODIFIER_PROPERTY_MODEL_SCALE}

	return decFuncs
end

function modifier_mutation_bloodlust:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_mutation_bloodlust:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

function modifier_mutation_bloodlust:GetModifierPercentageCasttime()
	return self.castspeed
end

function modifier_mutation_bloodlust:GetModifierModelScale()
	return self.size
end