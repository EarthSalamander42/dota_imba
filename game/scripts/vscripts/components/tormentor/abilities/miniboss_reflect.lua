LinkLuaModifier("modifier_miniboss_reflect_custom", "components/tormentor/abilities/miniboss_reflect.lua", LUA_MODIFIER_MOTION_NONE)

miniboss_reflect_custom = miniboss_reflect_custom or class({})

function miniboss_reflect_custom:IsInnateAbility() return true end

function miniboss_reflect_custom:GetIntrinsicModifierName()
	return "modifier_miniboss_reflect_custom"
end

modifier_miniboss_reflect_custom = modifier_miniboss_reflect_custom or class({})

-- function modifier_miniboss_reflect_custom:IsHidden() return true end

function modifier_miniboss_reflect_custom:IsPurgable() return false end

function modifier_miniboss_reflect_custom:IsPurgeException() return false end

function modifier_miniboss_reflect_custom:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_miniboss_reflect_custom:OnCreated()
	if not IsServer() then return end

	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = self.ability:GetSpecialValueFor("radius")
	self.illusion_damage_pct = self.ability:GetSpecialValueFor("illusion_damage_pct")

	self.pfx_name = {}
	self.pfx_name[DOTA_TEAM_GOODGUYS] = {
		shield = "particles/neutral_fx/miniboss_shield.vpcf",
		reflect = "particles/neutral_fx/miniboss_damage_reflect.vpcf",
		impact = "particles/neutral_fx/miniboss_damage_impact.vpcf",
		death = "particles/neutral_fx/miniboss_death.vpcf",
	}

	self.pfx_name[DOTA_TEAM_BADGUYS] = {
		shield = "particles/neutral_fx/miniboss_shield_dire.vpcf",
		reflect = "particles/neutral_fx/miniboss_damage_reflect_dire.vpcf",
		impact = "particles/neutral_fx/miniboss_dire_damage_impact.vpcf",
		death = "particles/neutral_fx/miniboss_death_dire.vpcf",
	}

	-- This delay is required because the tormentor team is not set yet when the modifier is created
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("delay"), function()
		local deaths = Tormentors:GetDeaths(self.parent.tormentorTeam)
		self.bonusReflectionPerDeath = self.ability:GetSpecialValueFor("passive_reflection_bonus_per_death") * deaths
		self.reflection = self.ability:GetSpecialValueFor("passive_reflection_pct") + self.bonusReflectionPerDeath

		self.shield_pfx = ParticleManager:CreateParticle(self.pfx_name[self.parent.tormentorTeam].shield, PATTACH_ABSORIGIN_FOLLOW, self.parent)

		self:SetHasCustomTransmitterData(true)
	end, FrameTime())
end

function modifier_miniboss_reflect_custom:AddCustomTransmitterData()
	return {
		reflection = self.reflection,
	}
end

function modifier_miniboss_reflect_custom:HandleCustomTransmitterData(data)
	self.reflection = data.reflection
end

function modifier_miniboss_reflect_custom:OnTakeDamage(keys)
	if not IsServer() then return end

	local damage = keys.original_damage
	local damageType = keys.damage_type

	if keys.unit ~= self.parent then return end

	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, FIND_ANY_ORDER, false)

	if #enemies == 0 then return end

	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and IsValidEntity(enemy) and enemy:IsAlive() then
			local reflectedDamage = (damage * self.reflection / 100) / #enemies

			if enemy:IsIllusion() then
				reflectedDamage = reflectedDamage * self.illusion_damage_pct / 100
			end

			local damageTable = {
				victim = enemy,
				attacker = self.parent,
				damage = reflectedDamage,
				damage_type = damageType,
				ability = self.ability,
			}

			ApplyDamage(damageTable)

			local pfx = ParticleManager:CreateParticle(self.pfx_name[self.parent.tormentorTeam].reflect, PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControl(pfx, 1, enemy:GetAbsOrigin())

			-- EmitSoundOnClient("Miniboss.Tormenter.Reflect", enemy)
			enemy:EmitSound("Miniboss.Tormenter.Reflect")
		end
	end
end

function modifier_miniboss_reflect_custom:OnTooltip()
	return self.reflection
end

function modifier_miniboss_reflect_custom:OnDeath(keys)
	if not IsServer() then return end

	local unit = keys.unit

	if unit ~= self.parent then return end

	ParticleManager:DestroyParticle(self.shield_pfx, true)
	ParticleManager:ReleaseParticleIndex(self.shield_pfx)

	local pfx = ParticleManager:CreateParticle(self.pfx_name[self.parent.tormentorTeam].death, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
end
