modifier_mutation_cold_feet = class({})

function modifier_mutation_cold_feet:IsHidden() return false end
function modifier_mutation_cold_feet:IsDebuff() return true end
function modifier_mutation_cold_feet:IsPurgable() return false end

function modifier_mutation_cold_feet:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf"
end

function modifier_mutation_cold_feet:OnCreated()
	if IsClient() then return end
--	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
--	self.damage = 250 + (50 * game_time)
	self.pos = self:GetParent():GetAbsOrigin()
	self.stun_duration = 2.0
	self.cold_feet = true
	self.break_distance = 740

	self:StartIntervalThink(1.0)

	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())

	self.ground_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker.vpcf", PATTACH_ABSORIGIN, self:GetParent())
end

function modifier_mutation_cold_feet:OnIntervalThink()
	if IsServer() then
		if (self.pos - self:GetParent():GetAbsOrigin()):Length() > self.break_distance then
			print("Distance Break!")
			self.cold_feet = false
			self:GetParent():RemoveModifierByName("modifier_mutation_cold_feet")
		end

		EmitSoundOn("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent())
	end
end

function modifier_mutation_cold_feet:OnRemoved()
	if IsServer() then
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
		end

		if self.ground_particle then
			ParticleManager:DestroyParticle(self.ground_particle, false)
			ParticleManager:ReleaseParticleIndex(self.ground_particle)
		end

		if self.tick_timer then
			Timers:RemoveTimer(self.tick_timer)
		end

		if self.cold_feet then
			self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_mutation_cold_feet_stun", {duration = self.stun_duration})
		end
	end
end

LinkLuaModifier("modifier_mutation_cold_feet_stun", "components/mutation/modifiers/periodic_spellcast/modifier_mutation_cold_feet.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_cold_feet_stun = class({})

function modifier_mutation_cold_feet_stun:IsHidden() return false end
function modifier_mutation_cold_feet_stun:IsDebuff() return true end
function modifier_mutation_cold_feet_stun:IsPurgable() return false end

function modifier_mutation_cold_feet_stun:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

function modifier_mutation_cold_feet_stun:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_mutation_cold_feet_stun:OnCreated()
	if IsServer() then
		EmitSoundOn("Hero_Ancient_Apparition.ColdFeetFreeze", self:GetParent())
	end
end
