LinkLuaModifier("modifier_imba_shrine_passive", "components/modifiers/modifier_imba_shrine_passive.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_shrine_passive_aura = modifier_imba_shrine_passive_aura or class({})

function modifier_imba_shrine_passive_aura:IsHidden() 				return true end
function modifier_imba_shrine_passive_aura:IsAura() 				return true end

function modifier_imba_shrine_passive_aura:GetAuraRadius()			return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_shrine_passive_aura:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_shrine_passive_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_shrine_passive_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO end
function modifier_imba_shrine_passive_aura:GetModifierAura()		return "modifier_imba_shrine_passive" end

modifier_imba_shrine_passive = modifier_imba_shrine_passive or class({})

function modifier_imba_shrine_passive:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(1.0)
end

function modifier_imba_shrine_passive:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and self:GetParent():HasItemInInventory("item_bottle") then
		local bottle = self:GetParent():FindItemByName("item_bottle", true, true)

		if bottle then
			if bottle:GetCurrentCharges() < bottle:GetSpecialValueFor("max_charges") then
				bottle:SetCurrentCharges(bottle:GetSpecialValueFor("max_charges"))
			end
		end
	end
end
