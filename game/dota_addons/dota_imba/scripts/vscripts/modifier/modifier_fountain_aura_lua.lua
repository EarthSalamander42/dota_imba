modifier_fountain_aura_lua = class({})

function modifier_fountain_aura_lua:IsHidden() return true end
function modifier_fountain_aura_lua:IsAura() return true end

function modifier_fountain_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER
end

function modifier_fountain_aura_lua:GetModifierAura()
	return "modifier_fountain_aura_effect_lua"
end

function modifier_fountain_aura_lua:GetAuraDuration()
	return 3.0
end

function modifier_fountain_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_fountain_aura_lua:GetAuraRadius()
	return 1200
end
