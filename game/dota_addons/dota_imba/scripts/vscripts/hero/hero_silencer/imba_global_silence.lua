imba_silencer_global_silence = class({})

function imba_silencer_global_silence:OnSpellStart()
	local caster = self:GetCaster()
	local curse_ability = caster:FindAbilityByName("imba_silencer_arcane_curse")
	if IsServer() then
		EmitSoundOn("Hero_Silencer.GlobalSilence.Cast", caster)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_global_silence.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_imba_silencer_global_silence", {duration = self:GetDuration()})
			if curse_ability and curse_ability:IsTrained() then
				enemy:AddNewModifier(caster, curse_ability, "modifier_imba_arcane_curse_debuff", {duration = self:GetDuration()})
			end
			EmitSoundOn("Hero_Silencer.GlobalSilence.Effect", enemy)
		end
	end
end
------------------------------------------------
-- Global Silence modifier
------------------------------------------------
LinkLuaModifier("modifier_imba_silencer_global_silence", "hero/hero_silencer/imba_global_silence", LUA_MODIFIER_MOTION_NONE)
modifier_imba_silencer_global_silence = class({})

function modifier_imba_silencer_global_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_silencer_global_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_silencer_global_silence:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_imba_silencer_global_silence:GetTexture()
	return "silencer_global_silence"
end

function modifier_imba_silencer_global_silence:IsPurgable()
	return true
end

function modifier_imba_silencer_global_silence:IsDebuff()
	return true
end