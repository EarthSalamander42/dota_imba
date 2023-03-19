-- Creator:
-- 	AltiV - April 11th, 2020

-- There is no custom code for recreation of the item here; this file is only meant for logic concerning duration reduction similar to Wraith King's Aghanim's Scepter Reincarnation wraith mechanics
-- Additionally, it will include a TrueKill at its conclusion to prevent custom save abilities from keeping heroes alive

-- Modifier is linked in scripts\vscripts\addon_game_mode.lua
-- LinkLuaModifier("modifier_item_imba_helm_of_the_undying_addendum", "components/items/item_helm_of_the_undying", LUA_MODIFIER_MOTION_NONE)

modifier_item_imba_helm_of_the_undying_addendum = modifier_item_imba_helm_of_the_undying_addendum or class({})

-----------------------------------------------------
-- MODIFIER_ITEM_IMBA_HELM_OF_THE_UNDYING_ADDENDUM --
-----------------------------------------------------

function modifier_item_imba_helm_of_the_undying_addendum:IsHidden() return true end

function modifier_item_imba_helm_of_the_undying_addendum:IsPurgable() return false end

function modifier_item_imba_helm_of_the_undying_addendum:IsDebuff() return true end

function modifier_item_imba_helm_of_the_undying_addendum:RemoveOnDeath() return false end

function modifier_item_imba_helm_of_the_undying_addendum:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.health_damage_pct_threshold      = self:GetAbility():GetSpecialValueFor("health_damage_pct_threshold")
	self.duration_reduction_per_threshold = self:GetAbility():GetSpecialValueFor("duration_reduction_per_threshold")

	if not IsServer() then return end

	self.damage_taken        = 0
	self.max_health          = self:GetParent():GetMaxHealth()

	self.threshold_intervals = self:GetParent():GetMaxHealth() * (self.health_damage_pct_threshold / 100)
end

-- Hopefully this doesn't have to run but if it does, use the last unit that dealt damaged as the killer because we didn't store the unit dealing the killing blow
function modifier_item_imba_helm_of_the_undying_addendum:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():IsAlive() and TrueKill and self.last_attacker then
		TrueKill(self.last_attacker, self:GetParent(), nil)
	end
end

function modifier_item_imba_helm_of_the_undying_addendum:DeclareFunctions()
	return { MODIFIER_EVENT_ON_TAKEDAMAGE }
end

function modifier_item_imba_helm_of_the_undying_addendum:OnTakeDamage(keys)
	if keys.unit == self:GetParent() then
		self.last_attacker = keys.attacker

		self.damage_taken = self.damage_taken + keys.damage

		if self.damage_taken >= self.threshold_intervals then
			while self.damage_taken >= self.threshold_intervals and self:GetParent():HasModifier("modifier_item_helm_of_the_undying_active") do
				self.damage_taken = self.damage_taken - self.threshold_intervals

				if self:GetParent():HasModifier("modifier_item_helm_of_the_undying_active") then
					self:GetParent():FindModifierByName("modifier_item_helm_of_the_undying_active"):SetDuration(math.max(self:GetParent():FindModifierByName("modifier_item_helm_of_the_undying_active"):GetRemainingTime() - self.duration_reduction_per_threshold, 0), true)
				end

				self:SetDuration(self:GetParent():FindModifierByName("modifier_item_helm_of_the_undying_active"):GetRemainingTime(), true)
			end
		end
	end
end
