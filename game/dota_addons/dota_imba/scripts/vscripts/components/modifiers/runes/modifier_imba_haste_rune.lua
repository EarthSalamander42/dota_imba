-- Author: Fudge

LinkLuaModifier("modifier_imba_haste_rune_aura", "components/modifiers/runes/modifier_imba_haste_rune", LUA_MODIFIER_MOTION_NONE)

item_imba_rune_haste = item_imba_rune_haste or class({})

------------------------------
-----   HASTE MODIFIER   -----
------------------------------
modifier_imba_haste_rune = modifier_imba_haste_rune or class({})

-- Modifier properties
function modifier_imba_haste_rune:IsHidden() 	return false end
function modifier_imba_haste_rune:IsPurgable()	return true end
function modifier_imba_haste_rune:IsDebuff() 	return false end

function modifier_imba_haste_rune:GetTexture()
	return "rune_haste"	-- "custom/imba_rune_haste"
end

-- Function declarations
function modifier_imba_haste_rune:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
	}
	return funcs
end

-- Bonus movespeed
function modifier_imba_haste_rune:GetModifierMoveSpeedBonus_Percentage()
	return CustomNetTables:GetTableValue("game_options", "runes").haste_rune_move_speed
end

-- Bonus attackspeed
function modifier_imba_haste_rune:GetModifierAttackSpeedBonus_Constant()
	return CustomNetTables:GetTableValue("game_options", "runes").haste_rune_attack_speed
end

-- Minimum unslowable movement speed
function modifier_imba_haste_rune:GetModifierMoveSpeed_AbsoluteMin()
	return CustomNetTables:GetTableValue("game_options", "runes").haste_rune_move_speed_min
end

-- Aura properties
function modifier_imba_haste_rune:IsAura()
	return true
end

function modifier_imba_haste_rune:GetAuraRadius()
	return CustomNetTables:GetTableValue("game_options", "runes").rune_radius_effect
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
	if target == self:GetCaster() then
        return true
    end
	return false
end

-- Haste particle
function modifier_imba_haste_rune:GetEffectName()
	return "particles/generic_gameplay/rune_haste_owner.vpcf"
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
	return CustomNetTables:GetTableValue("game_options", "runes").haste_rune_move_speed / 2
end

-- Bonus attackspeed
function modifier_imba_haste_rune_aura:GetModifierAttackSpeedBonus_Constant()
	return CustomNetTables:GetTableValue("game_options", "runes").haste_rune_attack_speed / 2
end

-- Haste particle
function modifier_imba_haste_rune_aura:GetEffectName()
	return "particles/generic_gameplay/rune_haste_owner.vpcf"
end

function modifier_imba_haste_rune_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
