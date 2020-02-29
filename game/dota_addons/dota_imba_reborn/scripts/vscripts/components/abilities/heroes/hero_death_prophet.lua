-- Creator:
--	EarthSalamander, May 12th, 2019
--	Death Prophet Silence Luafied

LinkLuaModifier("modifier_imba_death_prophet_silence", "components/abilities/heroes/hero_death_prophet", LUA_MODIFIER_MOTION_NONE)

imba_death_prophet_silence = class({})

function imba_death_prophet_silence:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_death_prophet_silence:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "death_prophet_silence" end
	return "death_prophet_silence_ti9"
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

	local pfx = ParticleManager:CreateParticle(CustomNetTables:GetTableValue("battlepass", "death_prophet").silence, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), 0, 1))
	ParticleManager:ReleaseParticleIndex(pfx)

	for _, enemy in pairs(enemies) do
		print(enemy:GetUnitName())
		local pfx = ParticleManager:CreateParticle(CustomNetTables:GetTableValue("battlepass", "death_prophet").silence_impact, PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pfx)

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_death_prophet_silence", {duration = self:GetDuration()}):SetDuration(self:GetDuration() * (1 - enemy:GetStatusResistance()), true)
	end
end

-----------------------------
-- DIABOLIC EDICT MODIFIER --
-----------------------------

modifier_imba_death_prophet_silence = class({})

function modifier_imba_death_prophet_silence:GetEffectName() return CustomNetTables:GetTableValue("battlepass", "death_prophet").silence_overhead end
function modifier_imba_death_prophet_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_death_prophet_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end

function modifier_imba_death_prophet_silence:OnCreated()
	if IsClient() then return end

	self.pfx = ParticleManager:CreateParticle(CustomNetTables:GetTableValue("battlepass", "death_prophet").silence_custom, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
--	ParticleManager:SetParticleControl(self.pfx, 1, self:GetParent():GetAbsOrigin())
end

function modifier_imba_death_prophet_silence:OnDestroy()
	if IsClient() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end
