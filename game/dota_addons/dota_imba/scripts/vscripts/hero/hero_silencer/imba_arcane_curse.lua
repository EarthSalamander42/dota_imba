imba_silencer_arcane_curse = class({})

function imba_silencer_arcane_curse:OnSpellStart()
	local point = self:GetCursorPosition()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local base_duration = self:GetSpecialValueFor("base_duration")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), 0, 0, false)
	local aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl( aoe, 0, point )
		ParticleManager:SetParticleControl( aoe, 1, Vector(radius, radius, radius) )

	EmitSoundOn("Hero_Silencer.Curse.Cast", caster)
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_imba_arcane_curse_debuff", {duration = base_duration})
		EmitSoundOn("Hero_Silencer.Curse.Impact", enemy)
	end
end

function imba_silencer_arcane_curse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

---------------------------------
-- Arcane Curse debuff modifier
---------------------------------
LinkLuaModifier("modifier_imba_arcane_curse_debuff", "hero/hero_silencer/imba_arcane_curse", LUA_MODIFIER_MOTION_NONE)
modifier_imba_arcane_curse_debuff = class({})

function modifier_imba_arcane_curse_debuff:OnCreated( kv )
	self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
	self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
	self.curse_damage = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.penalty_duration = self:GetAbility():GetSpecialValueFor("penalty_duration")
	self.mana_burn = self:GetAbility():GetSpecialValueFor("burn_per_second")
	self.parent = self:GetParent()
	self.caster = self:GetAbility():GetCaster()

	if IsServer() then
		--[[ SILENCER TALENT CHECK for penalty duration increase
		if self.caster:HasModifier("") then
			self.penalty_duration = self.penalty_duration + 2
		end
		]]
		--[[ SILENCER TALENT CHECK for curse slow increase
		if self.caster:HasModifier("") then
			self.curse_slow = self.curse_slow + 20
		end
		]]
		if self.caster:HasScepter() then
			self.aghs_upgraded = true
		else
			self.aghs_upgraded = false
		end
		self:StartIntervalThink( self.tick_rate )
	end
end

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
		end

		if ( not target:IsSilenced() ) or self.aghs_upgraded then
			local damage_per_tick = self.curse_damage * self.tick_rate
			local mana_per_tick = self.mana_burn * self.tick_rate
			local stack_count = self:GetStackCount()

			if stack_count then
				damage_per_tick = damage_per_tick * (stack_count + 1)
				mana_per_tick = mana_per_tick * (stack_count + 1)
			end

			local damage_table = {
					victim = target,
					attacker = self.caster,
					damage = damage_per_tick,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}

			ApplyDamage( damage_table )
			target:ReduceMana(mana_per_tick)

			--[[ SILENCER TALENT CHECK for healing from mana burn
			if self.caster:HasModifier("") then
				self.caster:Heal(mana_per_tick, nil)
			end
			]]
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
			self:SetDuration( self:GetRemainingTime() + self.penalty_duration, true )
			self:IncrementStackCount()
		end
	end
end

function modifier_imba_arcane_curse_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.curse_slow
end