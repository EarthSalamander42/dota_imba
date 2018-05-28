
---------------------------------
-----	Chronosphere Aura	-----
---------------------------------
modifier_chronosphere_aura = class({})
function modifier_chronosphere_aura:IsPurgable() return false end
function modifier_chronosphere_aura:IsHidden() return true end
function modifier_chronosphere_aura:IsAura() return true end
function modifier_chronosphere_aura:IsNetherWardStealable() return false end

function modifier_chronosphere_aura:GetAuraDuration()
	return 0.1
end

function modifier_chronosphere_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_chronosphere_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_chronosphere_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_OTHER end

function modifier_chronosphere_aura:GetModifierAura()
	return "modifier_imba_faceless_void_chronosphere_handler" end

function modifier_chronosphere_aura:GetAuraRadius()
	return self.radius
end

function modifier_chronosphere_aura:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.radius = 600
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

modifier_mutation_void_path = class({})

function modifier_mutation_void_path:IsHidden() return true end

function modifier_mutation_void_path:OnCreated()
	self:StartIntervalThink(1.0)
end

function modifier_mutation_void_path:OnIntervalThink()
	local x = math.random(-8000, 8000)
	local y = math.random(-8000, 8000)
	local pos = GetGroundPosition(Vector(x, y, 0), nil)
	CreateModifierThinker(self, nil, "modifier_chronosphere_aura", {duration = 5.0}, pos, -1, false)
end