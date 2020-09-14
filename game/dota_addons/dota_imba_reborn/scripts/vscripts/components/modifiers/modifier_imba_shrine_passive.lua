LinkLuaModifier("modifier_imba_shrine_passive", "components/modifiers/modifier_imba_shrine_passive.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_shrine_passive_aura = modifier_imba_shrine_passive_aura or class({})
--[[
function modifier_imba_shrine_passive_aura:OnCreated()
	if not IsServer() then return end

	-- Fuck you.
--	self:StartIntervalThink(1.0)
end

function modifier_imba_shrine_passive_aura:OnIntervalThink()
	if self:GetParent() and self:GetParent():FindAbilityByName("filler_ability") and self:GetParent():FindAbilityByName("filler_ability"):GetSpecialValueFor("radius") then
		self:StartIntervalThink(-1)
		print("RADIUS SET TO:", self:GetParent():FindAbilityByName("filler_ability"):GetSpecialValueFor("radius"))
		self:SetStackCount(self:GetParent():FindAbilityByName("filler_ability"):GetSpecialValueFor("radius"))
	end
end
--]]
function modifier_imba_shrine_passive_aura:IsHidden() 				return true end
function modifier_imba_shrine_passive_aura:IsAura() 				return true end

function modifier_imba_shrine_passive_aura:GetAuraRadius()			return 900 end
-- function modifier_imba_shrine_passive_aura:GetAuraRadius()			return self:GetStackCount() end
function modifier_imba_shrine_passive_aura:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_shrine_passive_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_shrine_passive_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO end
function modifier_imba_shrine_passive_aura:GetModifierAura()		return "modifier_imba_shrine_passive" end
--	function modifier_imba_shrine_passive_aura:GetAuraEntityReject(target) return target == self:GetCaster() end

modifier_imba_shrine_passive = modifier_imba_shrine_passive or class({})

function modifier_imba_shrine_passive:IsHidden() return true end

function modifier_imba_shrine_passive:OnCreated()
	if not IsServer() then return end

--	print(self:GetParent(), self:GetParent():GetUnitName())

	self:StartIntervalThink(1.0)
end

function modifier_imba_shrine_passive:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and self:GetParent():HasItemInInventory("item_bottle") then
		local bottle = self:GetParent():FindItemByName("item_bottle", true, true)

		if bottle then
			if bottle:GetCurrentCharges() < 1 then
				bottle:SetCurrentCharges(1)
			end
		end
	end
end
