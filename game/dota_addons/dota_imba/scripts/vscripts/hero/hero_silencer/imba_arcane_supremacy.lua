--[[	Author: X-TheDark
		Date: 10.12.2016	]]
imba_silencer_arcane_supremacy = class({})

function imba_silencer_arcane_supremacy:GetIntrinsicModifierName()
	return "modifier_imba_silencer_arcane_supremacy"
end

LinkLuaModifier("modifier_imba_silencer_arcane_supremacy", "hero/hero_silencer/imba_arcane_supremacy", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_arcane_supremacy = class({})

function modifier_imba_silencer_arcane_supremacy:OnCreated( kv )
	self.steal_range = self:GetAbility():GetSpecialValueFor("int_steal_range")
	self.steal_amount = self:GetAbility():GetSpecialValueFor("int_steal_amount")
	self.silence_reduction_pct = self:GetAbility():GetSpecialValueFor("silence_reduction_pct")
	self.caster = self:GetCaster()
end

function modifier_imba_silencer_arcane_supremacy:GetSilenceReductionPct()
	local reduction = self.silence_reduction_pct
	--[[ SILENCER TALENT CHECK remove hardcode
	if(self.caster:HasModifier("")) then
		reduction = reduction + 50
	end
	]]
	return reduction
end

function modifier_imba_silencer_arcane_supremacy:AllowIllusionDuplicate()
	return false
end

function modifier_imba_silencer_arcane_supremacy:RemoveOnDeath()
	return false
end

function modifier_imba_silencer_arcane_supremacy:IsPermanent()
	return true
end

function modifier_imba_silencer_arcane_supremacy:GetTexture()
    return "custom/arcane_supremacy"
end

function modifier_imba_silencer_arcane_supremacy:IsPurgeable()
	return false
end

function modifier_imba_silencer_arcane_supremacy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_imba_silencer_arcane_supremacy:OnDeath( params )
	if IsServer() then
		if self.caster:PassivesDisabled() then
			return nil
		end
		if params.unit:IsRealHero() and ( params.unit ~= self.caster ) and ( params.unit:GetTeam() ~= self.caster:GetTeam() ) then
			local distance = ( self.caster:GetAbsOrigin() - params.unit:GetAbsOrigin() ):Length2D()
			if ( distance <= self.steal_range ) or ( params.attacker == self.caster ) or ( params.unit:HasModifier("modifier_imba_silencer_global_silence") ) then
				local enemy_intelligence = params.unit:GetBaseIntellect()
				local enemy_intelligence_taken = 0
				local steal_amount = self.steal_amount
				--[[ SILENCER TALENT CHECK for steal amount
				if self:GetCaster():HasModifier("") then
					steal_amount = steal_amount + 2
				end
				]]
				if enemy_intelligence > 1 then
					if ( (enemy_intelligence - self.steal_amount) >= 1 ) then
						enemy_intelligence_taken = self.steal_amount
					else
						enemy_intelligence_taken = -(1 - enemy_intelligence)
					end
					params.unit:SetBaseIntellect( enemy_intelligence - enemy_intelligence_taken )
					params.unit:CalculateStatBonus()

					self.caster:SetBaseIntellect(self.caster:GetBaseIntellect() + enemy_intelligence_taken)
					self:SetStackCount(self:GetStackCount() + enemy_intelligence_taken)
					self.caster:CalculateStatBonus()

					-- Copied from https://moddota.com/forums/discussion/1156/modifying-silencers-int-steal
					local life_time = 2.0
					local digits = string.len( math.floor( enemy_intelligence_taken ) ) + 1
					local numParticle = ParticleManager:CreateParticle( "particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, self.caster )
					ParticleManager:SetParticleControl( numParticle, 1, Vector( 10, enemy_intelligence_taken, 0 ) )
					ParticleManager:SetParticleControl( numParticle, 2, Vector( life_time, digits, 0 ) )
					ParticleManager:SetParticleControl( numParticle, 3, Vector( 100, 100, 255 ) )
				end
			end
		end
	end
end