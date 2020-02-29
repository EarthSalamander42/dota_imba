modifier_mutation_greed_is_good = class({})
function modifier_mutation_greed_is_good:IsHidden() return true end
function modifier_mutation_greed_is_good:IsDebuff() return false end
function modifier_mutation_greed_is_good:IsPurgable() return false end
function modifier_mutation_greed_is_good:RemoveOnDeath() return false end
function modifier_mutation_greed_is_good:OnCreated()
	if IsServer() then 
		self.parent = self:GetParent()
		self.player = PlayerResource:GetPlayer(self.parent:GetPlayerID())
		self.bonus_gold = 350

		self:StartIntervalThink(60.0)
	end
end

function modifier_mutation_greed_is_good:OnIntervalThink()
 	if IsServer() then
 		local parent = self:GetParent() 

 		-- Apply gold particle
		local gold_particle	= "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
		self.gold_particle_fx = ParticleManager:CreateParticleForPlayer(gold_particle, PATTACH_ABSORIGIN, self.parent, self.player)
		ParticleManager:SetParticleControl(self.gold_particle_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.gold_particle_fx, 1, self.parent:GetAbsOrigin())


		-- Gold message
		local msg_particle = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
		self.msg_particle_fx = ParticleManager:CreateParticleForPlayer(msg_particle, PATTACH_ABSORIGIN, self.parent, self.player)
		ParticleManager:SetParticleControl(self.msg_particle_fx, 1, Vector(0, self.bonus_gold, 0))
		ParticleManager:SetParticleControl(self.msg_particle_fx, 2, Vector(2, string.len(self.bonus_gold) + 1, 0))
		ParticleManager:SetParticleControl(self.msg_particle_fx, 3, Vector(255, 200, 33) )-- Gold

		-- Give gold
		self.parent:ModifyGold(self.bonus_gold, false, DOTA_ModifyGold_Unspecified)

		Timers:CreateTimer(10, function ()
			-- cleanup
			ParticleManager:DestroyParticle(self.gold_particle_fx, false)
			ParticleManager:DestroyParticle(self.msg_particle_fx, false)
		end)
 	end
end