-- Author: Ported from Angel Arena Black Star's Github
-- https://github.com/ark120202/aabs/blob/1faaadbc3cbf9f9d9bf2cbb8c1e2463141c17d2e/game/scripts/vscripts/items/item_bottle.lua

LinkLuaModifier("modifier_item_imba_bottle_heal", "items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bottle_texture_controller", "items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_bottle = class({})


function item_imba_bottle:OnCreated()
	self:SetCurrentCharges(3)
	self.RuneStorage = nil
end

function item_imba_bottle:GetIntrinsicModifierName() return "modifier_item_imba_bottle_texture_controller" end

function item_imba_bottle:SetCurrentCharges(charges)
	return self.BaseClass.SetCurrentCharges(self, charges)
end

function item_imba_bottle:OnSpellStart()
	if self.RuneStorage then
		PickupRune(self.RuneStorage, self:GetCaster(), true)
		if self.RuneStorage == "bounty" and self:GetCurrentCharges() < 2 then
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
	--if self.RuneStorage then return end
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
		end
	else
		self:SetCurrentCharges(3)
	end

	self:GetCaster():EmitSound("Bottle.Cork")
end

function item_imba_bottle:GetAbilityTextureName()
	local texture = "custom/bottle_3"
	texture = self.texture_name or texture
	return texture
end

modifier_item_imba_bottle_texture_controller = modifier_item_imba_bottle_texture_controller or class({})

function modifier_item_imba_bottle_texture_controller:IsHidden() return true end
function modifier_item_imba_bottle_texture_controller:IsPurgable() return false end
function modifier_item_imba_bottle_texture_controller:IsDebuff() return false end
function modifier_item_imba_bottle_texture_controller:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function modifier_item_imba_bottle_texture_controller:OnCreated()
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_bottle_texture_controller:OnIntervalThink()
	local bottle = self:GetAbility()
	local rune_table = {
						"0",--1
						"1",--2
						"2",--3
						"3",--4
						"arcane", --5
						"double_damage", --6
						"haste", --7
						"regeneration", --8
						"illusion", --9
						"invisibility",  --10
						"frost", --11
						"bounty", --12
						}
	if IsServer() then
		if bottle:IsCooldownReady() and self:GetParent():HasModifier("modifier_fountain_aura_buff") then
			bottle:SetCurrentCharges(3)
		end
		local stack = bottle:GetCurrentCharges() + 1
		for i=5,12 do
			if bottle.RuneStorage == rune_table[i] then
				stack = i
				break
			end
		end
		self:SetStackCount(stack)
	end
	local client_stack = self:GetStackCount()
	if client_stack >= 1 and client_stack <= 4 then
		bottle.texture_name = "custom/bottle_"..rune_table[client_stack]
	else
		bottle.texture_name = "custom/bottle_rune_"..rune_table[client_stack]
	end
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
	return self:GetAbility():GetSpecialValueFor("health_restore") / self:GetDuration()
end

function modifier_item_imba_bottle_heal:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_restore") / self:GetDuration()
end