modifier_frantic = modifier_frantic or class({})

----------------------------------------------------------------------
-- Frantic handler
----------------------------------------------------------------------

modifier_frantic = modifier_frantic or class({})

function modifier_frantic:IsDebuff() return false end
function modifier_frantic:RemoveOnDeath() return false end
function modifier_frantic:IsPurgable() return false end
function modifier_frantic:IsPurgeException() return false end

function modifier_frantic:GetTexture()
	return "custom/frantic"
end

function modifier_frantic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end

function modifier_frantic:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(_G.IMBA_FRANTIC_VALUE)
	self:StartIntervalThink(0.2)
	self.current_effect_name = ""
	self.effect_name = ""
end

function modifier_frantic:OnIntervalThink()
	for _, v in ipairs(SHARED_NODRAW_MODIFIERS) do
		if self:GetParent():HasModifier(v) then
--			print("hide donator effect...")
			self.effect_name = ""
			self:RefreshEffect()
			return
		end
	end

	self.effect_name = "particles/generic_gameplay/frantic.vpcf"
	self:RefreshEffect()
end

function modifier_frantic:RefreshEffect()
	if self.current_effect_name ~= self.effect_name then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

		self.pfx = ParticleManager:CreateParticle(self.effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.current_effect_name = self.effect_name
	end
end

function modifier_frantic:GetModifierPercentageCooldownStacking()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierPercentageManacost()
	return self:GetStackCount()
end

function modifier_frantic:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end
