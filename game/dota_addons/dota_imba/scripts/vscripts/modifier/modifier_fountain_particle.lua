--[[
		Author: MouJiaoZi
		Date: 2017/12/13

]]

function GetFountainBattlePassEffect(npc)
	local effect = "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl3.vpcf"


	return effect
end

LinkLuaModifier("modifier_imba_fountain_particle_control", "modifier/modifier_fountain_particle", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fountain_particle_effect", "modifier/modifier_fountain_particle", LUA_MODIFIER_MOTION_NONE)

modifier_imba_fountain_particle_control = modifier_imba_fountain_particle_control or class({})
modifier_imba_fountain_particle_effect = modifier_imba_fountain_particle_effect or class({})

function modifier_imba_fountain_particle_control:IsHidden() return true end
function modifier_imba_fountain_particle_control:IsPurgable() return false end
function modifier_imba_fountain_particle_control:IsDebuff() return false end
function modifier_imba_fountain_particle_control:RemoveOnDeath() return false end

function modifier_imba_fountain_particle_control:OnCreated()
	if not IsServer() then return end
	self.unit = self:GetParent()
	self.tick = 0.2
	self:StartIntervalThink(self.tick)
end

function modifier_imba_fountain_particle_control:OnIntervalThink()
	if self.unit:HasModifier("modifier_fountain_aura_buff") then
		self.unit:AddNewModifier(self.unit, nil, "modifier_imba_fountain_particle_effect", {duration = (self.tick * 2)})
	end
end

function modifier_imba_fountain_particle_effect:IsHidden() return true end
function modifier_imba_fountain_particle_effect:IsPurgable() return false end
function modifier_imba_fountain_particle_effect:IsDebuff() return false end
function modifier_imba_fountain_particle_effect:RemoveOnDeath() return false end

function modifier_imba_fountain_particle_effect:OnCreated()
	if not IsServer() then return end
	local effect = GetFountainBattlePassEffect(self:GetParent())
	self.pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_imba_fountain_particle_effect:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, true)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end