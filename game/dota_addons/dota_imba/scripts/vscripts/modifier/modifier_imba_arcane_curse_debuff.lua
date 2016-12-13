modifier_imba_arcane_curse_debuff = class({})

function modifier_imba_arcane_curse_debuff:OnCreated( kv )
	self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
	self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
	self.curse_damage = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.penalty_duration = self:GetAbility():GetSpecialValueFor("penalty_duration")
	self.parent = self:GetParent()

	if IsServer() then
		self:SetDuration( self:GetAbility():GetSpecialValueFor("base_duration"), true )
		self:StartIntervalThink( self.tick_rate )
	end
end

--Various Get's for attributes and effects
function modifier_imba_arcane_curse_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_arcane_curse_debuff:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_curse.vpcf"
end

function modifier_imba_arcane_curse_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_arcane_curse_debuff:GetTexture()
	return "silencer_curse_of_the_silent"
end

function modifier_imba_arcane_curse_debuff:IsPurgable()
	return true
end

function modifier_imba_arcane_curse_debuff:IsDebuff()
	return true
end

function modifier_imba_arcane_curse_debuff:OnIntervalThink()
	if IsServer() then
		local target = self.parent
		if target:IsSilenced() then
			self:SetDuration( self:GetRemainingTime() + self.tick_rate, true )
		else
			local damage_per_tick = self.curse_damage * self.tick_rate

			local damage_table = {
				victim = target,
				attacker = self:GetCaster(),
				damage = damage_per_tick,
				damage_type = self:GetAbility():GetAbilityDamageType(),
				ability = self:GetAbility()
			}

			ApplyDamage( damage_table )
		end
	end
end

function modifier_imba_arcane_curse_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
 
	return funcs
end

function modifier_imba_arcane_curse_debuff:OnAbilityExecuted( params )
	if IsServer() then
		if ( not params.ability:IsItem() ) and ( params.unit == self.parent ) then
			-- Only extend duration of Toggle abilities when they are turned on
			-- OnAbilityExecuted is ran before the toggle completes, so 'true' = we are about to turn it off
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end
			-- The main reason this is a LUA script...so I don't have to do black magic to extend every individual
			-- curse modifier, in case we have multiple of them (since they stack)
			self:SetDuration( self:GetRemainingTime() + self.penalty_duration, true )
		end
	end
end

function modifier_imba_arcane_curse_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.curse_slow
end