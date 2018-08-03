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

function modifier_fountain_aura_effect_lua:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_INVULNERABLE] = true
		}

		return state
	end
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

function modifier_fountain_aura_effect_lua:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle(self:GetParent().fountain_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
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
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
