LinkLuaModifier("modifier_fountain_aura_effect_lua", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_fountain_invulnerable", "components/modifiers/modifier_fountain_aura_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_fountain_aura_lua = class({})

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

modifier_fountain_aura_effect_lua = class({})

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
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle(self:GetParent().fountain_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(0.1)
	end
end

function modifier_fountain_aura_effect_lua:OnIntervalThink()
	if GetMapName() == MapDiretide() then return end

	if IsNearFountain(self:GetParent():GetAbsOrigin(), 1200) then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_fountain_invulnerable", {})

		if self:GetParent():HasItemInInventory("item_bottle") then
			local bottle = self:GetParent():FindItemByName("item_bottle", false)

			if bottle then
				if bottle:GetCurrentCharges() < bottle:GetSpecialValueFor("max_charges") then
					bottle:SetCurrentCharges(bottle:GetSpecialValueFor("max_charges"))
				end
			end
		end
	else
		self:GetParent():RemoveModifierByName("modifier_fountain_invulnerable")
	end
end

function modifier_fountain_aura_effect_lua:GetModifierHealthRegenPercentage(params)
	return 5
end

function modifier_fountain_aura_effect_lua:GetModifierTotalPercentageManaRegen(params)
	return 6
end

function modifier_fountain_aura_effect_lua:OnDestroy()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_fountain_invulnerable") then
			self:GetParent():RemoveModifierByName("modifier_fountain_invulnerable")
		end
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

modifier_fountain_invulnerable = class({})

function modifier_fountain_invulnerable:IsPurgable() return false end
function modifier_fountain_invulnerable:GetTexture() return "tower_armor_aura" end

function modifier_fountain_invulnerable:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_fountain_invulnerable:GetAbsoluteNoDamagePure()
	return 1
end
