modifier_mutation_thundergods_wrath = class({})

function modifier_mutation_thundergods_wrath:IsHidden() return true end
function modifier_mutation_thundergods_wrath:IsDebuff() return true end
function modifier_mutation_thundergods_wrath:IsPurgable() return false end

function modifier_mutation_thundergods_wrath:OnCreated()
	if IsClient() then return end
	self.delay = 1.7
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	self.damage = 300 + (80 * game_time)

	EmitSoundOn("Hero_Zuus.GodsWrath", self:GetParent())

	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	local damageTable = {
		victim = self:GetParent(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = self:GetCaster(),
	}

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
	ApplyDamage(damageTable)
end
