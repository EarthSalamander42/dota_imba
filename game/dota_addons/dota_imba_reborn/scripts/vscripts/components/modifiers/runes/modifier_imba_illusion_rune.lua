LinkLuaModifier("modifier_imba_illusion_rune", "components/modifiers/runes/modifier_imba_illusion_rune.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_illusion_rune = class({})

function modifier_imba_illusion_rune:GetTexture()
	return "custom/imba_rune_illusion"
end

function modifier_imba_illusion_rune:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_assassin_active_blur.vpcf"
end

function modifier_imba_illusion_rune:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_imba_illusion_rune:GetModifierIncomingDamage_Percentage()
	if not IsServer() then return end

	if RollPercentage(CustomNetTables:GetTableValue("game_options", "runes").illusion_rune_dodge_pct) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, self:GetParent(), 0, nil)
		return -100
	end

	return nil
end