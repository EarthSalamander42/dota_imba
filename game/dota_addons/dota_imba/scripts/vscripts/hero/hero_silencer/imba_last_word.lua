imba_silencer_last_word = class({})

function imba_silencer_last_word:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if IsServer() then
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		EmitSoundOn("Hero_Silencer.LastWord.Cast", caster)

		target:AddNewModifier(caster, self, "modifier_imba_silencer_last_word_debuff", {duration = self:GetDuration()})
	end
end

function imba_silencer_last_word:GetIntrinsicModifierName()
	return "imba_silencer_last_word_aura"
end

----------------------------------------------------
-- Last Word silence talent aura
----------------------------------------------------
LinkLuaModifier("imba_silencer_last_word_aura", "hero/hero_silencer/imba_last_word", LUA_MODIFIER_MOTION_NONE)
imba_silencer_last_word_aura = class({})

function imba_silencer_last_word_aura:OnCreated( kv )
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function imba_silencer_last_word_aura:IsAura()
	if self:GetCaster():HasTalent("special_bonus_imba_silencer_8") then
		return true
	else
		return false
	end

	return false
end

function imba_silencer_last_word_aura:IsHidden()
	return true
end

function imba_silencer_last_word_aura:GetModifierAura()
	return "imba_silencer_last_word_silence_aura"
end

function imba_silencer_last_word_aura:IsAuraActiveOnDeath()
	return false
end

function imba_silencer_last_word_aura:GetAuraRadius()
	return self.aura_radius
end

function imba_silencer_last_word_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function imba_silencer_last_word_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

----------------------------------------------------
-- Last Word aura enemy silence modifier
----------------------------------------------------
LinkLuaModifier("imba_silencer_last_word_silence_aura", "hero/hero_silencer/imba_last_word", LUA_MODIFIER_MOTION_NONE)
imba_silencer_last_word_silence_aura = class({})

function imba_silencer_last_word_silence_aura:OnCreated( kv )
	self.silence_duration = self:GetAbility():GetSpecialValueFor("aura_silence")
end

function imba_silencer_last_word_silence_aura:IsDebuff()
	return true
end

function imba_silencer_last_word_silence_aura:IsPurgable()
	return false
end

function imba_silencer_last_word_silence_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function imba_silencer_last_word_silence_aura:OnAbilityExecuted( params )
	if IsServer() then
		if ( not params.ability:IsItem() ) and ( params.unit == self:GetParent() ) and ( not self:GetParent():IsMagicImmune() ) then
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
		end
	end
end

function imba_silencer_last_word_silence_aura:GetTexture()
	return "silencer_last_word"
end

----------------------------------------------------
-- Last Word initial debuff : disarms and provides vision of target
----------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_last_word_debuff", "hero/hero_silencer/imba_last_word", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_last_word_debuff = class({})

function modifier_imba_silencer_last_word_debuff:OnCreated( kv )
	self.caster = self:GetCaster()

	if IsServer() then
		EmitSoundOn("Hero_Silencer.LastWord.Target", self:GetParent())
		self.damage = self:GetAbility():GetAbilityDamage()
		self.silence_duration = self:GetAbility():GetSpecialValueFor("silence_duration")
		self:StartIntervalThink(self:GetAbility():GetDuration())
	end
end

function modifier_imba_silencer_last_word_debuff:OnDestroy( kv )
	if not self:GetParent():IsMagicImmune() then
		if IsServer() then
			EmitSoundOn("Hero_Silencer.LastWord.Damage", self:GetParent())
			local damage_table = {
					victim = self:GetParent(),
					attacker = self.caster,
					damage = self.damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}
			ApplyDamage(damage_table)
		end
	end
end

function modifier_imba_silencer_last_word_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_PROVIDES_VISION] = true,
	}

	return state
end

function modifier_imba_silencer_last_word_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifier_imba_silencer_last_word_debuff:OnAbilityExecuted( params )
	if IsServer() then
		if ( not params.ability:IsItem() ) and ( params.unit == self:GetParent() ) then
			if params.ability:IsToggle() and params.ability:GetToggleState() then
				return
			end
			self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_silencer_last_word_repeat_thinker", {duration = self.silence_duration})
			self:Destroy()
		end
	end
end

function modifier_imba_silencer_last_word_debuff:OnIntervalThink()
	local target = self:GetParent()
	if IsServer() then
		target:AddNewModifier(self.caster, self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
	end
end

function modifier_imba_silencer_last_word_debuff:GetEffectName()
	return "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
end

function modifier_imba_silencer_last_word_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------------
-- Last Word repeat thinker : casts Last Word on parent when the modifier expires
----------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_last_word_repeat_thinker", "hero/hero_silencer/imba_last_word", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_last_word_repeat_thinker = class({})

function modifier_imba_silencer_last_word_repeat_thinker:OnDestroy( kv )
	if not self:GetParent():IsMagicImmune() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_silencer_last_word_debuff", {duration = self:GetAbility():GetDuration()})
	end
end

function modifier_imba_silencer_last_word_repeat_thinker:IsDebuff()
	return true
end

function modifier_imba_silencer_last_word_repeat_thinker:IsPurgable()
	return true
end

function modifier_imba_silencer_last_word_repeat_thinker:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end