modifier_patreon_donator = class({})

function modifier_patreon_donator:IsHidden() return true end
function modifier_patreon_donator:IsPurgable() return false end

function modifier_patreon_donator:OnCreated()
	if IsServer() then
		self:SetStackCount(api:GetDonatorStatus(self:GetParent():GetPlayerID()))
		self:StartIntervalThink(0.2)
		self.current_effect_name = ""
		self.effect_name = api:GetPlayerEmblem(self:GetParent():GetPlayerID())
	end
end

function modifier_patreon_donator:OnIntervalThink()
	for _, v in ipairs(SHARED_NODRAW_MODIFIERS) do
		if self:GetParent():HasModifier(v) then
--			print("hide donator effect...")
			self.effect_name = ""
			self:RefreshEffect()
			return
		end
	end

--	print(self.effect_name)
	self:RefreshEffect()
end

function modifier_patreon_donator:RefreshEffect()
	if self.current_effect_name ~= self.effect_name then
--		print("Old Effect:", self.current_effect_name)
--		print("Effect:", self.effect_name)

		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end

		self.pfx = ParticleManager:CreateParticle(self.effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.current_effect_name = self.effect_name
	end
end

function modifier_patreon_donator:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end
