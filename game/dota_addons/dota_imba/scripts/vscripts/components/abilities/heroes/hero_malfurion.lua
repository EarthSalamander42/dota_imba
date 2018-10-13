-- Editors:
--     EarthSalamander #42, 02.04.2017

--------------------------
--	Entrangling Roots	--
--------------------------

LinkLuaModifier("modifier_imba_entrangling_roots", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_entrangling_roots = imba_malfurion_entrangling_roots or class({})

function imba_malfurion_entrangling_roots:OnSpellStart()
	if IsServer() then
		self:GetCursorTarget():EmitSound("Hero_Treant.LeechSeed.Target")
		self:GetCursorTarget():AddNewModifier(self:GetCursorTarget(), self, "modifier_imba_entrangling_roots", {duration=self:GetSpecialValueFor("duration") - 0.01}) -- minus 0.01 second/instance to keep the right root duration but have 1 less damage instance, because first damage instance happen when modifier is granted and not after the first think time.
	end
end

modifier_imba_entrangling_roots = modifier_imba_entrangling_roots or class({})

function modifier_imba_entrangling_roots:IsDebuff() return false end
function modifier_imba_entrangling_roots:IsHidden() return false end

-------------------------------------------

function modifier_imba_entrangling_roots:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_imba_entrangling_roots:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_entrangling_roots:CheckState()
	local states =
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}

	return states
end

function modifier_imba_entrangling_roots:OnCreated()
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_entrangling_roots:OnIntervalThink()
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetAbility():GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor("dmg_per_sec"),
		damage_type = self:GetAbility():GetAbilityDamageType()
	})
end

------------------------------
--		Rejuvenation		--
------------------------------

LinkLuaModifier("modifier_imba_rejuvenation", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_rejuvenation = imba_malfurion_rejuvenation or class({})

function imba_malfurion_rejuvenation:OnSpellStart()
	if IsServer() then
		self:GetCaster():EmitSound("Hero_Warlock.ShadowWordCastGood")

		local allies = FindUnitsInRadius(self:GetCaster():GetTeam(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, ally in pairs (allies) do
			ally:AddNewModifier(ally, self, "modifier_imba_rejuvenation", {duration=self:GetSpecialValueFor("duration")})
		end
	end
end

modifier_imba_rejuvenation = modifier_imba_rejuvenation or class({})

function modifier_imba_rejuvenation:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_rejuvenation:OnIntervalThink()
	local heal_per_sec = self:GetAbility():GetSpecialValueFor("heal_per_sec")

	if self:GetParent():IsBuilding() then
		heal_per_sec = heal_per_sec / 100 * self:GetAbility():GetSpecialValueFor("heal_per_sec_building_pct")
	else
		if not self:GetParent():IsHero() then
			heal_per_sec = heal_per_sec / 100 * self:GetAbility():GetSpecialValueFor("heal_per_sec_creep_pct")
		end
	end

	self:GetParent():Heal(heal_per_sec, self:GetCaster())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), heal_per_sec, nil)
end

function modifier_imba_rejuvenation:GetEffectName()
	return "particles/econ/events/ti6/bottle_ti6.vpcf"
end

function modifier_imba_rejuvenation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-----------------------------
--     Curse Of Avernus    --
-----------------------------

LinkLuaModifier("modifier_imba_mark_of_the_claw", "components/abilities/heroes/hero_malfurion", LUA_MODIFIER_MOTION_NONE)

imba_malfurion_mark_of_the_claw = imba_malfurion_mark_of_the_claw or class({})

function imba_malfurion_mark_of_the_claw:GetIntrinsicModifierName()
	return "modifier_imba_mark_of_the_claw"
end

modifier_imba_mark_of_the_claw = modifier_imba_mark_of_the_claw or class({})

function modifier_imba_mark_of_the_claw:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_imba_mark_of_the_claw:OnAttackLanded(kv)
	if IsServer() then
		if self:GetParent() == kv.attacker and kv.attacker:GetTeamNumber() ~= kv.target:GetTeamNumber() then
			if kv.target:IsBuilding() then return end

			if RandomInt(1, 100) <= self:GetAbility():GetSpecialValueFor("chance") then
				local base_damage = kv.damage * (self:GetAbility():GetSpecialValueFor("bonus_damage_pct") / 100)
				local splash_damage = base_damage * (self:GetAbility():GetSpecialValueFor("splash_damage_pct") / 100)

				print("Base damage: "..base_damage)
				print("Splash damage : "..splash_damage)

				ApplyDamage({
					victim = kv.target,
					attacker = kv.attacker,
					damage = base_damage,
					damage_type = DAMAGE_TYPE_PHYSICAL
				})

				kv.attacker:EmitSound("Imba.UrsaDeepStrike")

				local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, kv.attacker)
				ParticleManager:SetParticleControlEnt(coup_pfx, 0, kv.target, PATTACH_POINT_FOLLOW, "attach_hitloc", kv.target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(coup_pfx, 1, kv.target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", kv.target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(coup_pfx)

				DoCleaveAttack(kv.attacker, kv.target, self:GetAbility(), splash_damage, self:GetAbility():GetSpecialValueFor("cleave_start"), self:GetAbility():GetSpecialValueFor("cleave_end"), self:GetAbility():GetSpecialValueFor("radius"), "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf")
			end
		end
	end
end

--]]
