modifier_imba_silencer_int_steal = class({})

function modifier_imba_silencer_int_steal:OnCreated( kv )
	self.steal_range = kv.steal_range or 925
	self.steal_amount = kv.steal_amount or 2

	if IsServer() then
		self.parent = self:GetParent()
		self:SetStackCount( self:GetStackCount() )
		self.parent:CalculateStatBonus()
	end
end

-- Manta Meta a possibility
function modifier_imba_silencer_int_steal:AllowIllusionDuplicate()
	return false
end

function modifier_imba_silencer_int_steal:RemoveOnDeath()
	return false
end

function modifier_imba_silencer_int_steal:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_silencer_int_steal:GetTexture()
    return "silencer_glaives_of_wisdom"
end

function modifier_imba_silencer_int_steal:IsPurgeable()
	return false
end

function modifier_imba_silencer_int_steal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

function modifier_imba_silencer_int_steal:OnDeath( params )
	if IsServer() then
		if self.parent == nil then
			self.parent = self:GetParent()
		end

		if params.unit:IsRealHero() and ( params.unit ~= self.parent ) and ( params.unit:GetTeam() ~= self.parent:GetTeam() ) then
			local distance = ( self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin() ):Length2D()
			if ( distance <= self.steal_range ) or ( params.attacker == self.parent ) then
				-- This is totally a reference
				local enemy_intelligence = params.unit:GetBaseIntellect()
				local enemy_intelligence_taken = 0
				if enemy_intelligence > 1 then
					if ( (enemy_intelligence - self.steal_amount) >= 1 ) then
						enemy_intelligence_taken = self.steal_amount
					else
						enemy_intelligence_taken = -(1 - enemy_intelligence)
					end
					params.unit:SetBaseIntellect( enemy_intelligence - enemy_intelligence_taken )
					params.unit:CalculateStatBonus()

					self.parent:SetBaseIntellect(self.parent:GetBaseIntellect() + enemy_intelligence_taken)
					self:SetStackCount(self:GetStackCount() + enemy_intelligence_taken)
					self.parent:CalculateStatBonus()

					-- Copied from https://moddota.com/forums/discussion/1156/modifying-silencers-int-steal
					local life_time = 2.0
                    local digits = string.len( math.floor( enemy_intelligence_taken ) ) + 1
                    local numParticle = ParticleManager:CreateParticle( "particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
                    ParticleManager:SetParticleControl( numParticle, 1, Vector( 10, enemy_intelligence_taken, 0 ) )
                    ParticleManager:SetParticleControl( numParticle, 2, Vector( life_time, digits, 0 ) )
                    ParticleManager:SetParticleControl( numParticle, 3, Vector( 100, 100, 255 ) )
				end
			end
		end
	end
end