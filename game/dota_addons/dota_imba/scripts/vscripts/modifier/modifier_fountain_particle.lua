--[[
		Author: MouJiaoZi
		Date: 2017/12/13
]]

LinkLuaModifier("modifier_imba_fountain_particle_control", "modifier/modifier_fountain_particle", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_fountain_particle_effect", "modifier/modifier_fountain_particle", LUA_MODIFIER_MOTION_NONE)

modifier_imba_fountain_particle_control = modifier_imba_fountain_particle_control or class({})
-- modifier_imba_fountain_particle_effect = modifier_imba_fountain_particle_effect or class({})

function modifier_imba_fountain_particle_control:IsHidden() return false end
function modifier_imba_fountain_particle_control:IsPurgable() return false end
function modifier_imba_fountain_particle_control:IsDebuff() return false end
function modifier_imba_fountain_particle_control:RemoveOnDeath() return false end

function modifier_imba_fountain_particle_control:OnCreated()
--	if not IsServer() then return end
--	self.effect = self:GetParent().fountain_effect
--	print(self.effect)
--	self.pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
--	self.tick = 0.2
--	self:StartIntervalThink(self.tick)
end

function modifier_imba_fountain_particle_control:OnIntervalThink() -- doesn't print anything
--	if not self:GetParent():HasModifier("modifier_fountain_aura_buff") then
--		print("Remove modifier")
--		self:GetParent():RemoveModifierByName("modifier_imba_fountain_particle_control"))
--	else
--		print("keep modifier")
--	end
end

function modifier_imba_fountain_particle_control:OnDestroy()
--	if not IsServer() then return end
--	ParticleManager:DestroyParticle(self.pfx, true)
--	ParticleManager:ReleaseParticleIndex(self.pfx)
end
