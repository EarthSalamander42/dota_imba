modifier_fountain_aura_effect_lua = class({})

function modifier_fountain_aura_effect_lua:IsPurgable()
	return false
end

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}

	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

function modifier_fountain_aura_effect_lua:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle(self:GetParent().fountain_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

--		if self:GetParent():GetUnitName() == "npc_dota_courier" then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invulnerable", {})
--		end
	end
end

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage( params )
	return 5
end

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen( params )
	return 6
end

function modifier_fountain_aura_effect_lua:OnDestroy()
	if IsServer() then
--		if self:GetParent():GetUnitName() == "npc_dota_courier" then
			self:GetParent():RemoveModifierByName("modifier_invulnerable")
--		end

		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
