-- Author: Ported from Angel Arena Black Star's Github
-- https://github.com/ark120202/aabs/blob/1faaadbc3cbf9f9d9bf2cbb8c1e2463141c17d2e/game/scripts/vscripts/items/item_bottle.lua

LinkLuaModifier("modifier_item_imba_bottle_heal", "items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_bottle = class({})

if IsServer() then
	function item_imba_bottle:OnCreated()
		self:SetCurrentCharges(3)
	end

	function item_imba_bottle:SetCurrentCharges(charges)
		return self.BaseClass.SetCurrentCharges(self, charges)
	end

	function item_imba_bottle:OnSpellStart()
		if self.RuneStorage then
			PickupRune(self.RuneStorage, self:GetCaster())
			if self.RuneStorage == "bounty" then
				self:SetCurrentCharges(2)
			else
				self:SetCurrentCharges(3)
			end
			self.RuneStorage = nil
		else
			local charges = self:GetCurrentCharges()
			if charges > 0 then
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_bottle_heal", {duration = self:GetSpecialValueFor("restore_time")})
				self:SetCurrentCharges(charges - 1)
				self:GetCaster():EmitSound("Bottle.Drink")
			end
		end
	end

	function item_imba_bottle:SetStorageRune(type)
		if self.RuneStorage then return end
		if self:GetCaster().GetPlayerID then
			local gameEvent = {}
			gameEvent["player_id"] = self:GetCaster():GetPlayerID()
			gameEvent["team_number"] = self:GetCaster():GetTeamNumber()
			gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_item_imba_rune_"..type
			gameEvent["message"] = "#IMBA_custom_rune_bottled_"..type
			FireGameEvent("dota_combat_event_message", gameEvent)
		end
		self.RuneStorage = type
		if self.RuneStorage == "bounty" then
			if self:GetCurrentCharges() < 3 then
				self:SetCurrentCharges(2)
			else
				PickupRune(self.RuneStorage, self:GetCaster())
				return
			end
		else
			self:SetCurrentCharges(3)
		end

		self:GetCaster():EmitSound("Bottle.Cork")
	end
end

function item_imba_bottle:GetAbilityTextureName()
	local texture = "custom/bottle_3"
	if self.GetCurrentCharges ~= nil then
		texture = self.RuneStorage ~= nil and "custom/bottle_rune_"..self.RuneStorage or "custom/bottle_"..self:GetCurrentCharges()
	end
	print("Bottle Texture:", texture, self.GetCurrentCharges)
	return texture
end

modifier_item_imba_bottle_heal = class({
	GetTexture =          function() return "custom/bottle_3" end,
	IsPurgable =          function() return false end,
	GetEffectName =       function() return "particles/items_fx/bottle.vpcf" end,
	GetEffectAttachType = function() return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_item_imba_bottle_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_item_imba_bottle_heal:GetModifierConstantHealthRegen()
	return self:GetAbility():GetAbilitySpecial("health_restore") / self:GetDuration()
end

function modifier_item_imba_bottle_heal:GetModifierConstantManaRegen()
	return self:GetAbility():GetAbilitySpecial("mana_restore") / self:GetDuration()
end