-- Creator:
--	EarthSalamander, May 12th, 2019
--	Leshrac Diabolic Edict luafied

LinkLuaModifier("modifier_imba_leshrac_diabolic_edict", "components/abilities/heroes/hero_leshrac", LUA_MODIFIER_MOTION_NONE)

imba_leshrac_diabolic_edict = class({})

function imba_leshrac_diabolic_edict:OnSpellStart()
	if IsClient() then return end
	local num_explosions = self:GetSpecialValueFor("num_explosions") + self:GetCaster():FindTalentValue("special_bonus_unique_leshrac_1")
	local delay = self:GetDuration() / num_explosions

	self:GetCaster():EmitSound("Hero_Leshrac.Diabolic_Edict_lp")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_leshrac_diabolic_edict", {duration = self:GetDuration(), delay = delay})
end

-----------------------------
-- DIABOLIC EDICT MODIFIER --
-----------------------------

modifier_imba_leshrac_diabolic_edict = class({})

function modifier_imba_leshrac_diabolic_edict:IsPurgable() return false end
function modifier_imba_leshrac_diabolic_edict:RemoveOnDeath() return false end
function modifier_imba_leshrac_diabolic_edict:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_leshrac_diabolic_edict:OnCreated(keys)
	if IsClient() then return end

	self:OnIntervalThink()
	self:StartIntervalThink(keys.delay)
end

function modifier_imba_leshrac_diabolic_edict:OnIntervalThink()
	if IsClient() then return end

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self:GetAbility():GetSpecialValueFor("radius"),
		self:GetAbility():GetAbilityTargetTeam(),
		self:GetAbility():GetAbilityTargetType(),
		self:GetAbility():GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false
	)

	-- Create Particle
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
	local position_cast
	local enemy = enemies[RandomInt(1, #enemies)]

	if enemy then
		position_cast = enemy:GetAbsOrigin()
		ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)

		ApplyDamage({
			attacker = self:GetParent(),
			victim = enemy,
			damage = self:GetAbility():GetAbilityDamage(),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = self:GetAbility():GetAbilityTargetFlags()
		})
	else
		position_cast = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, self:GetAbility():GetSpecialValueFor("radius")))
		ParticleManager:SetParticleControl(pfx, 1, position_cast)
	end

	EmitSoundOnLocationWithCaster(position_cast, "Hero_Leshrac.Diabolic_Edict", self:GetParent())
	ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_imba_leshrac_diabolic_edict:OnDestroy(params)
	if IsClient() then return end

	self:GetParent():StopSound("Hero_Leshrac.Diabolic_Edict_lp")
end
