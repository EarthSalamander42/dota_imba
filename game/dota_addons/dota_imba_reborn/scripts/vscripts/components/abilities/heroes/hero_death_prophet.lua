-- Creator:
--	EarthSalamander, May 12th, 2019
--	Death Prophet Silence Luafied

LinkLuaModifier("modifier_imba_death_prophet_silence", "components/abilities/heroes/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

imba_death_prophet_silence = class({})

function imba_death_prophet_silence:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_death_prophet_silence:OnSpellStart()
	if IsClient() then return end

	self:GetCaster():EmitSound("Hero_DeathProphet.Silence")

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCursorPosition(),
		nil,
		self:GetSpecialValueFor("radius"),
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence.vpcf", PATTACH_CUSTOMORIGIN, nil, self:GetCaster())
	ParticleManager:SetParticleControl(pfx, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 1))
	ParticleManager:ReleaseParticleIndex(pfx)

	for _, enemy in pairs(enemies) do
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy, self:GetCaster())
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_death_prophet_silence", {duration = self:GetDuration() * (1 - enemy:GetStatusResistance())})
	end
end

-----------------------------------------
-- MODIFIER_IMBA_DEATH_PROPHET_SILENCE --
-----------------------------------------

modifier_imba_death_prophet_silence = class({})

function modifier_imba_death_prophet_silence:CheckState() return {
	[MODIFIER_STATE_SILENCED] = true,
} end

function modifier_imba_death_prophet_silence:OnCreated()
	if IsClient() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_silence_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
--	ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())

	self.pfx2 = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx2, 0, self:GetParent():GetAbsOrigin())
end

function modifier_imba_death_prophet_silence:OnDestroy()
	if IsClient() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	if self.pfx2 then
		ParticleManager:DestroyParticle(self.pfx2, false)
		ParticleManager:ReleaseParticleIndex(self.pfx2)
	end
end
