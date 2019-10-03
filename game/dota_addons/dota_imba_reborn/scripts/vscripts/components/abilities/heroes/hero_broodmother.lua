-- Creator:
--		EarthSalamander, October 3rd, 2019

LinkLuaModifier("modifier_imba_broodmother_spawn_spiderlings", "components/abilities/hero_broodmother.lua", LUA_MODIFIER_MOTION_NONE)

imba_broodmother_spawn_spiderlings = imba_broodmother_spawn_spiderlings or class({})

function imba_broodmother_spawn_spiderlings:OnSpellStart()
	if not IsServer() then return end

	local info = {
		Source = self:GetCaster(),
		Target = self:GetCursorTarget(),
		Ability = self,
		bDodgeable = true,
		EffectName = "",
		iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
	}

	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_broodmother_spawn_spiderlings:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_broodmother_spawn_spiderlings", {duration = self:GetSpecialValueFor("duration")})

		ApplyDamage({
			attacker = fountain,
			victim = enemy,
			damage = self:GetAbility():GetSpecialValueFor("damage"),
			damage_type = self:GetAbility():GetAbilityDamageType(),
			damage_flags = self:GetAbility():GetAbilityTargetFlags()
		})
	end
end

modifier_imba_broodmother_spawn_spiderlings = modifier_imba_broodmother_spawn_spiderlings or class({})

function modifier_imba_broodmother_spawn_spiderlings:IsDebuff() return true end

function modifier_imba_broodmother_spawn_spiderlings:OnDestroy()
	if not IsServer() then return end

	-- OnDestroy procs before/after death?
	print(self:GetParent():IsAlive())
	if not self:GetParent():IsAlive() then
		for i = 1, self:GetAbility():GetSpecialValueFor("count") do
			local spiderling = CreateUnitByName("npc_dota_broodmother_spiderling", self:GetParent():GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			spiderling:SetUnitOnClearGround()
			ResolveNPCPositions(spiderling:GetAbsOrigin(), 50)
		end
	end
end
