-- Author: Fudge

item_imba_rune_haste = item_imba_rune_haste or class({})

------------------------------
-----   HASTE MODIFIER   -----
------------------------------
modifier_imba_haste_rune = modifier_imba_haste_rune or class({})

-- Modifier properties
function modifier_imba_haste_rune:IsHidden() 	return false end
function modifier_imba_haste_rune:IsPurgable()	return true end
function modifier_imba_haste_rune:IsDebuff() 	return false end

function modifier_imba_haste_rune:GetTextureName()
	return "rune_haste"
end

function modifier_imba_haste_rune:OnCreated()
	-- Ability properties
	self.caster		=	self:GetCaster()

	-- Ability parameters
	self.radius			=	900
	self.movespeed_pct	=	60
	self.attackspeed	=	80
end

-- Function declarations
function modifier_imba_haste_rune:DeclareFunctions()
	local funcs	=	{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_MOVESPEED_MAX
}
	return funcs
end

-- Bonus movespeed
function modifier_imba_haste_rune:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_pct
end

-- Bonus attackspeed
function modifier_imba_haste_rune:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

-- Minimum unslowable movement speed
function modifier_imba_haste_rune:GetModifierMoveSpeed_Absolute()
	return 550
end

-- Infinite max movespeed
function modifier_imba_haste_rune:GetModifierMoveSpeed_Max()
	return 10000
end

-- Aura properties
function modifier_imba_haste_rune:IsAura()
	return true
end

function modifier_imba_haste_rune:GetAuraRadius()
	return self.radius
end

function modifier_imba_haste_rune:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_haste_rune:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_haste_rune:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_haste_rune:GetModifierAura()
	return "modifier_imba_haste_rune_aura"
end

function modifier_imba_haste_rune:GetAuraEntityReject(target)
	if target == self.caster then
        return true
    end
	return false
end

-- Haste particle
function modifier_imba_haste_rune:GetEffectName()
	return "particles/generic_gameplay/rune_haste.vpcf"
end

function modifier_imba_haste_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


--- MINOR AURA MODIFIER
modifier_imba_haste_rune_aura = modifier_imba_haste_rune_aura or class({})

-- Modifier properties
function modifier_imba_haste_rune_aura:IsHidden() 	return false end
function modifier_imba_haste_rune_aura:IsPurgable()	return false end
function modifier_imba_haste_rune_aura:IsDebuff() 	return false end

function modifier_imba_haste_rune_aura:GetTextureName()
	return "rune_haste"
end

function modifier_imba_haste_rune_aura:OnCreated()
	-- Ability parameters
	self.movespeed_pct	=	60	/2
	self.attackspeed	=	80	/2
end

-- Function declarations
function modifier_imba_haste_rune_aura:DeclareFunctions()
	local funcs	=	{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
	return funcs
end

-- Bonus movespeed
function modifier_imba_haste_rune_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_pct
end

-- Bonus attackspeed
function modifier_imba_haste_rune_aura:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end

-- Haste particle
function modifier_imba_haste_rune_aura:GetEffectName()
	return "particles/generic_gameplay/rune_haste.vpcf"
end

function modifier_imba_haste_rune_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end