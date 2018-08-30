modifier_mutation_cold_feet = class({})

function modifier_mutation_cold_feet:IsHidden() 	return false end
function modifier_mutation_cold_feet:IsDebuff() 	return true end
function modifier_mutation_cold_feet:IsPurgable() 	return true end

function modifier_mutation_cold_feet:GetTexture()
	return "ancient_apparition_cold_feet"
end

function modifier_mutation_cold_feet:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet.vpcf"
end

function modifier_mutation_cold_feet:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_mutation_cold_feet:OnCreated()
	if IsClient() then return end
	
	-- Do not apply on magic immune units
	if self:GetParent():IsMagicImmune() then
		self.cold_feet = false
		self:Destroy()
		return
	end
	
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	-- Minimum of 30 damage per tick, maximum of 150
	self.damage 		= 30 + (4 * game_time)
	-- Minimum of 2 second stun, maximum of 5
	self.stun_duration 	= 2.0 + (0.1 * game_time)
	self.pos 			= self:GetParent():GetAbsOrigin()
	self.cold_feet 		= true
	self.break_distance = 740
	self.damageTable 	= 	{victim = self:GetParent(),
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = DAMAGE_TYPE_MAGICAL}
	self.counter = 1
	
	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())

	self.ground_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_marker.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	
	ApplyDamage(self.damageTable)
	
	self:StartIntervalThink(1.0)
end

function modifier_mutation_cold_feet:OnIntervalThink()
	if IsServer() then
		-- Increment counter
		self.counter = self.counter + 1
		
		if (self.pos - self:GetParent():GetAbsOrigin()):Length() > self.break_distance then
			self.cold_feet = false
			self:GetParent():RemoveModifierByName("modifier_mutation_cold_feet")
		elseif self.counter <= 4 then 
			ApplyDamage(self.damageTable)
		end
				
		EmitSoundOn("Hero_Ancient_Apparition.ColdFeetTick", self:GetParent())
	end
end

function modifier_mutation_cold_feet:OnRemoved()
	if IsServer() then
		if self.ground_particle then
			ParticleManager:DestroyParticle(self.ground_particle, false)
			ParticleManager:ReleaseParticleIndex(self.ground_particle)
		end

		if self.cold_feet and self.counter > 4 then
			self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_mutation_cold_feet_stun", {duration = self.stun_duration})
		end
	end
end

LinkLuaModifier("modifier_mutation_cold_feet_stun", "components/modifiers/mutation/periodic_spellcast/modifier_mutation_cold_feet.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_cold_feet_stun = class({})

function modifier_mutation_cold_feet_stun:IsHidden() 			return false end
function modifier_mutation_cold_feet_stun:IsDebuff() 			return true end
function modifier_mutation_cold_feet_stun:IsPurgable() 			return false end
function modifier_mutation_cold_feet_stun:IsPurgeException() 	return true end

function modifier_mutation_cold_feet_stun:GetTexture()
	return "ancient_apparition_cold_feet"
end

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
