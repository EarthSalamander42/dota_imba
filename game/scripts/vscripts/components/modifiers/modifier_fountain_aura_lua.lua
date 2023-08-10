LinkLuaModifier("modifier_fountain_aura_effect_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_fountain_aura_lua = modifier_fountain_aura_lua or class({})

function modifier_fountain_aura_lua:IsHidden() return true end

function modifier_fountain_aura_lua:IsAura() return true end

function modifier_fountain_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fountain_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER
end

function modifier_fountain_aura_lua:GetModifierAura()
	return "modifier_fountain_aura_effect_lua"
end

function modifier_fountain_aura_lua:GetAuraDuration()
	return 3.0
end

function modifier_fountain_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_fountain_aura_lua:GetAuraRadius()
	return 1200
end

modifier_fountain_aura_effect_lua = modifier_fountain_aura_effect_lua or class({})

function modifier_fountain_aura_effect_lua:IsHidden() return false end

function modifier_fountain_aura_effect_lua:IsPurgable() return false end

function modifier_fountain_aura_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}

	return funcs
end

function modifier_fountain_aura_effect_lua:GetTexture()
	return "rune_regen"
end

function modifier_fountain_aura_effect_lua:OnCreated()
	if not IsServer() then return end

	if self:GetParent():GetClassname() == "npc_dota_additive" then
		self:Destroy()
		return
	end

	self.time_before_pfx = 1.0

	self:StartIntervalThink(0.1)
end

function modifier_fountain_aura_effect_lua:OnIntervalThink()
	if self.time_before_pfx > 0 then
		self.time_before_pfx = self.time_before_pfx - 0.1
	else
		if not self.pfx then
			self.pfx = ParticleManager:CreateParticle("particles/generic_gameplay/radiant_fountain_regen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent())
		end
	end

	if self:GetParent():HasItemInInventory("item_bottle") then
		local bottle = self:GetParent():FindItemByName("item_bottle", true, true)

		if bottle then
			if bottle:GetCurrentCharges() < bottle:GetSpecialValueFor("max_charges") then
				bottle:SetCurrentCharges(bottle:GetSpecialValueFor("max_charges"))
			end
		end
	end
end

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage()
	return 5
end

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen()
	return 6
end

function modifier_fountain_aura_effect_lua:OnDestroy()
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, false)
			ParticleManager:ReleaseParticleIndex(self.pfx)
		end
	end
end
