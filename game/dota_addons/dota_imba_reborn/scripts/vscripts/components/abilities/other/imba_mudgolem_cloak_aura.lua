-- Creator:
--	   AltiV, February 28th, 2020

LinkLuaModifier("modifier_imba_mudgolem_cloak_aura", "components/abilities/other/imba_mudgolem_cloak_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_mudgolem_cloak_aura_bonus", "components/abilities/other/imba_mudgolem_cloak_aura", LUA_MODIFIER_MOTION_NONE)

imba_mudgolem_cloak_aura				= imba_mudgolem_cloak_aura or class({})
modifier_imba_mudgolem_cloak_aura		= modifier_imba_mudgolem_cloak_aura or class({})
modifier_imba_mudgolem_cloak_aura_bonus	= modifier_imba_mudgolem_cloak_aura_bonus or class({})

------------------------------
-- IMBA_MUDGOLEM_CLOAK_AURA --
------------------------------

function imba_mudgolem_cloak_aura:GetIntrinsicModifierName()
	return "modifier_imba_mudgolem_cloak_aura"
end

---------------------------------------
-- MODIFIER_IMBA_MUDGOLEM_CLOAK_AURA --
---------------------------------------

function modifier_imba_mudgolem_cloak_aura:IsHidden()		return true end
function modifier_imba_mudgolem_cloak_aura:IsPurgable()		return false end
function modifier_imba_mudgolem_cloak_aura:RemoveOnDeath()	return false end

function modifier_imba_mudgolem_cloak_aura:IsAura()							return true end
function modifier_imba_mudgolem_cloak_aura:IsAuraActiveOnDeath() 			return false end

function modifier_imba_mudgolem_cloak_aura:GetAuraRadius()					return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_mudgolem_cloak_aura:GetAuraSearchFlags()				return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_mudgolem_cloak_aura:GetAuraSearchTeam()				return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_mudgolem_cloak_aura:GetAuraSearchType()				return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_mudgolem_cloak_aura:GetModifierAura()				return "modifier_imba_mudgolem_cloak_aura_bonus" end

function modifier_imba_mudgolem_cloak_aura:GetAuraEntityReject(target)		return target:IsIllusion() end

---------------------------------------------
-- MODIFIER_IMBA_MUDGOLEM_CLOAK_AURA_BONUS --
---------------------------------------------

function modifier_imba_mudgolem_cloak_aura_bonus:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_mudgolem_cloak_aura_bonus:OnCreated()
	if self:GetAbility() then
		self.bonus_magical_armor		= self:GetAbility():GetSpecialValueFor("bonus_magical_armor")
		self.bonus_magical_armor_creeps	= self:GetAbility():GetSpecialValueFor("bonus_magical_armor_creeps")
	else
		self.bonus_magical_armor		= 0
		self.bonus_magical_armor_creeps	= 0
	end
end

function modifier_imba_mudgolem_cloak_aura_bonus:DeclareFunctions()
	return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
end

function modifier_imba_mudgolem_cloak_aura_bonus:GetModifierMagicalResistanceBonus()
	if self:GetParent():IsConsideredHero() then
		return self.bonus_magical_armor
	else
		return self.bonus_magical_armor_creeps
	end
end
