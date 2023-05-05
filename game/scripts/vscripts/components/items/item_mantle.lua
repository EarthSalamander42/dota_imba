item_imba_mantle = item_imba_mantle or class({})

LinkLuaModifier("modifier_imba_mantle", "components/items/item_mantle", LUA_MODIFIER_MOTION_NONE)

---------------------------
-- MANTLE OF INTELLIGENCE --
---------------------------

function item_imba_mantle:GetIntrinsicModifierName()
	return "modifier_imba_mantle"
end

modifier_imba_mantle = modifier_imba_mantle or class({})

--------------------------------------------
-- MANTLE OF INTELLIGENCE PASSIVE MODIFIER --
--------------------------------------------

function modifier_imba_mantle:IsHidden() return true end
function modifier_imba_mantle:IsDebuff() return false end
function modifier_imba_mantle:IsPurgable() return false end
function modifier_imba_mantle:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_mantle:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	-- Ability properties
	self.caster = self:GetCaster() 
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.magical_damage = self.ability:GetSpecialValueFor("magical_damage")
end

function modifier_imba_mantle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
	}
end

function modifier_imba_mantle:GetModifierBonusStats_Intellect()
	return self.bonus_int
end

function modifier_imba_mantle:GetModifierProcAttack_BonusDamage_Magical(keys)
	if IsServer() then

		-- Only trigger on the first of all similar modifiers of the same name
		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self then
			local target = keys.target

			-- Only deal magical damage when not in cooldown
			if self.ability:IsCooldownReady() then

				-- Start cooldown and block
				self.ability:UseResources(false, false, false, true)

				-- Show overhead alert for magical damage
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, self.magical_damage, nil)

				return self.magical_damage
			end

			return
		end
	end
end