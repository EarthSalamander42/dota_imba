--[[
		By: AtroCty
		Date: 12.05.2017
		Updated:  12.05.2017
	]]

modifier_imba_range_indicator = modifier_imba_range_indicator or class({})
function modifier_imba_range_indicator:IsDebuff() return false end
function modifier_imba_range_indicator:IsHidden() return true end
function modifier_imba_range_indicator:IsPurgable() return false end
function modifier_imba_range_indicator:IsPurgeException() return false end
function modifier_imba_range_indicator:IsStunDebuff() return false end
function modifier_imba_range_indicator:RemoveOnDeath() return self.bRemoveOnDeath end
-------------------------------------------

function modifier_imba_range_indicator:OnCreated( params )
	if IsServer() then
		self.range_pfx = ParticleManager:CreateParticleForPlayer("particles/range_indicator.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetPlayerOwner())
		ParticleManager:SetParticleControl(self.range_pfx, 1, Vector(params.iRed,params.iGreen,params.iBlue))
		self.hAbility = self:GetAbility()
		self.iRange = params.iRange
		self.bRemoveOnDeath = params.bRemoveOnDeath or true
		self.sAttribute = params.sAttribute
		self.bShowOnCooldown = params.bShowOnCooldown
		self.bShowAlways = params.bShowAlways
		self.bWithCastRangeIncrease = params.bWithCastRangeIncrease
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_range_indicator:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_range_indicator:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.range_pfx, true)
		ParticleManager:ReleaseParticleIndex(self.range_pfx)
		self:Destroy()
	end
end

function modifier_imba_range_indicator:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		if (caster:IsAlive() or (self.bShowAlways == 1)) and self.hAbility then
			if (self.hAbility:IsCooldownReady() or (self.bShowOnCooldown == 1)) and (not caster.norange) then
				self.iRange = self.hAbility:GetSpecialValueFor(self.sAttribute)
				if self.bWithCastRangeIncrease then self.iRange = self.iRange + GetCastRangeIncrease(caster) end
				ParticleManager:SetParticleControl(self.range_pfx, 3, Vector(self.iRange, 0, 0))
			else
				ParticleManager:SetParticleControl(self.range_pfx, 3, Vector(0, 0, 0))
			end
		elseif (caster:IsAlive() or (self.bShowAlways == 1)) and self.iRange and (not caster.norange) and (not self.hAbility) then
			ParticleManager:SetParticleControl(self.range_pfx, 3, Vector(self.iRange, 0, 0))
		end
	end
end
