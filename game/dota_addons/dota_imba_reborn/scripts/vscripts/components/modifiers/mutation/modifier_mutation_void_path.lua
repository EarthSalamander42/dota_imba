LinkLuaModifier("modifier_imba_faceless_void_chronosphere_handler", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)
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
	return DOTA_UNIT_TARGET_ALL end

function modifier_chronosphere_aura:GetModifierAura()
	return "modifier_imba_faceless_void_chronosphere_handler" end

function modifier_chronosphere_aura:GetAuraRadius()
	return self.radius
end

function modifier_chronosphere_aura:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.radius = math.random(200,400)	-- This is Radius
		local particle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf", PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

modifier_mutation_void_path = class({})

function modifier_mutation_void_path:IsHidden() return true end

function modifier_mutation_void_path:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_mutation_void_path:OnIntervalThink()
	local x = math.random(-8000, 8000)
	local y = math.random(-8000, 8000)
	local pos = GetGroundPosition(Vector(x, y, 0), nil)
	local sound_cast = "Hero_FacelessVoid.Chronosphere"
	self:GetParent():EmitSound(sound_cast)
	CreateModifierThinker(self:GetParent(), nil, "modifier_chronosphere_aura", {duration = 3.0}, pos, 0, false)	-- This is Duration
end
