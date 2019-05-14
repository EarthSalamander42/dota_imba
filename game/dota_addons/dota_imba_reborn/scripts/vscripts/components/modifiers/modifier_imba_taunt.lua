modifier_imba_taunt = class({})

function modifier_imba_taunt:IsPurgable()
	return false
end

function modifier_imba_taunt:IsPurgeException()
	return false
end

function modifier_imba_taunt:IsHidden()
	return true
end

function modifier_imba_taunt:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_imba_taunt:OnCreated()
	if IsServer() then
		local table = {}
		table["npc_dota_hero_invoker"] = 1
		table["npc_dota_hero_leshrac"] = 2
		table["npc_dota_hero_lion"] = 3
		table["npc_dota_hero_windrunner"] = 4
		table["npc_dota_hero_pangolier"] = 5
		table["npc_dota_hero_dark_willow"] = 6

		if table[self:GetParent():GetUnitName()] then
			self:SetStackCount(table[self:GetParent():GetUnitName()])
		end
	end
end

function modifier_imba_taunt:GetActivityTranslationModifiers()
	local table = {}
	table[0] = ""
	table[1] = "juggle_gesture"
	table[2] = "disco_gesture"
	table[3] = "hell_gesture"
	table[4] = "blowkiss_gesture"
	table[5] = "bombadillo"
	table[6] = "rope"

	return table[self:GetStackCount()]
end

function modifier_imba_taunt:GetOverrideAnimation()
	return ACT_DOTA_TAUNT
end
