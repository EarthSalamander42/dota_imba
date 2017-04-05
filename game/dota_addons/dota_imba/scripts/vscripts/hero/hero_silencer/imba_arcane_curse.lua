imba_silencer_arcane_curse = class({})

CreateEmptyTalents("silencer")

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
	self.parent = self:GetParent()
	self.caster = self:GetAbility():GetCaster()
	self.tick_rate = self:GetAbility():GetSpecialValueFor("tick_rate")
	self.curse_slow = self:GetAbility():GetSpecialValueFor("curse_slow")
	self.curse_damage = self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.penalty_duration = self:GetAbility():GetSpecialValueFor("penalty_duration")
	self.mana_burn = self:GetAbility():GetSpecialValueFor("burn_per_second")
	self.talent_learned = self.caster:HasTalent("special_bonus_imba_silencer_1")

	if IsServer() then
		self.penalty_duration = self.penalty_duration + self.caster:FindTalentValue("special_bonus_imba_silencer_2")
		self.curse_slow = self.curse_slow + self.caster:FindTalentValue("special_bonus_imba_silencer_7")

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
			local damage_dealt = self.curse_damage * self.tick_rate
			local mana_drained = self.mana_burn * self.tick_rate
			local stack_count = self:GetStackCount()

			if stack_count then
				damage_dealt = damage_dealt * (stack_count + 1)
				mana_drained = mana_drained * (stack_count + 1)
			end

			local damage_table = {
					victim = target,
					attacker = self.caster,
					damage = damage_dealt,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}

			ApplyDamage( damage_table )

			-- Unfortunately, if we have the mana-drain-as-lifesteal talent, we'll need to make sure we don't heal more than the mana we drain
			if self.talent_learned then
				local enemy_mana = target:GetMana()
				if enemy_mana > 0 then
					if ( enemy_mana - mana_drained ) < 0 then
						mana_drained = enemy_mana
					end
				else
					mana_drained = 0
				end
			end

			target:ReduceMana(mana_drained)

			if self.talent_learned then
				self.caster:Heal(mana_drained, nil)
			end
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
		if ( not params.ability:IsItem() ) and ( params.unit == self.parent ) and ( not exception[params.ability:GetName()] ) then
			-- Only extend duration of Toggle abilities when they are turned on
			-- OnAbilityExecuted is ran before the toggle completes, so 'true' = we are about to turn it off
			if CheckExceptions(params.ability) then
				return
			end
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end
			self:SetDuration( self:GetRemainingTime() + self.penalty_duration, true )
			self:IncrementStackCount()
		end
	end
end

function modifier_imba_arcane_curse_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -self.curse_slow
end