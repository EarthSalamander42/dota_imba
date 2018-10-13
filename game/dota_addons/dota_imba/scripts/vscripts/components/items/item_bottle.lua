-- Author: Ported from Angel Arena Black Star's Github
-- https://github.com/ark120202/aabs/blob/1faaadbc3cbf9f9d9bf2cbb8c1e2463141c17d2e/game/scripts/vscripts/items/item_bottle.lua

LinkLuaModifier("modifier_item_imba_bottle_heal", "components/items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bottle_texture_controller", "components/items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bottle_texture_controller_2", "components/items/item_bottle.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_bottle = class({})

function item_imba_bottle:GetIntrinsicModifierName() return "modifier_item_imba_bottle_texture_controller" end

function item_imba_bottle:SetCurrentCharges(charges)
	return self.BaseClass.SetCurrentCharges(self, charges)
end

function item_imba_bottle:OnSpellStart()
	local caster = self:GetCaster()
	if self.RuneStorage then
		-- Safe env. so the rune still gets consumed even if it errors
		--pcall(PickupRune, self.RuneStorage, caster, true)
		ImbaRunes:PickupRune(self.RuneStorage, caster, true)
		self:SetCurrentCharges(3)
		self.RuneStorage = nil
	else
		local charges = self:GetCurrentCharges()

		if charges > 0 then
			caster:AddNewModifier(caster, self, "modifier_item_imba_bottle_heal", {duration = self:GetSpecialValueFor("restore_time")})
			self:SetCurrentCharges(charges - 1)
			caster:EmitSound("Bottle.Drink")
		end
	end
end

function item_imba_bottle:SetStorageRune(type)
	--if self.RuneStorage then return end
	if self:GetCaster().GetPlayerID then
		CustomGameEventManager:Send_ServerToTeam(self:GetCaster():GetTeam(), "create_custom_toast", {
			type = "generic",
			text = "#custom_toast_BottledRune",
			player = self:GetCaster():GetPlayerID(),
			runeType = type
		})
	end

	self.RuneStorage = type
	self:SetCurrentCharges(3)
	self:GetCaster():EmitSound("Bottle.Cork")
end

function item_imba_bottle:GetAbilityTextureName()
	local texture = "custom/bottle_0_3"
	texture = self.texture_name or texture
	return texture
end

modifier_item_imba_bottle_texture_controller = modifier_item_imba_bottle_texture_controller or class({})

function modifier_item_imba_bottle_texture_controller:IsHidden() return true end
function modifier_item_imba_bottle_texture_controller:IsPurgable() return false end
function modifier_item_imba_bottle_texture_controller:IsDebuff() return false end
function modifier_item_imba_bottle_texture_controller:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_bottle_texture_controller:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_imba_bottle_texture_controller_2", {})
	end

	self:StartIntervalThink(0.1)
end

function modifier_item_imba_bottle_texture_controller:OnIntervalThink()
	local rune_table = {
		tostring(self:GetAbility().bottle_icon).."_0",--1
		tostring(self:GetAbility().bottle_icon).."_1",--2
		tostring(self:GetAbility().bottle_icon).."_2",--3
		tostring(self:GetAbility().bottle_icon).."_3",--4
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
		if self:GetAbility():IsCooldownReady() and self:GetParent():HasModifier("modifier_fountain_aura_effect_lua") then
			self:GetAbility():SetCurrentCharges(3)
		end

		local stack = self:GetAbility():GetCurrentCharges() + 1

		for i = 5, 12 do
			if self:GetAbility().RuneStorage == rune_table[i] then
				stack = i
				break
			end
		end

		self:SetStackCount(stack)
	end

	if self:GetStackCount() >= 1 and self:GetStackCount() <= 4 then
		self:GetAbility().texture_name = "custom/bottle_"..rune_table[self:GetStackCount()]
	else
		self:GetAbility().texture_name = "custom/bottle_rune_"..rune_table[self:GetStackCount()]
	end
end

function modifier_item_imba_bottle_texture_controller:OnDestroy()
	if self:GetParent():HasModifier("modifier_item_imba_bottle_texture_controller_2") then
		self:GetParent():RemoveModifierByName("modifier_item_imba_bottle_texture_controller_2")
	end
end

modifier_item_imba_bottle_texture_controller_2 = modifier_item_imba_bottle_texture_controller_2 or class({})

function modifier_item_imba_bottle_texture_controller_2:IsHidden() return true end
function modifier_item_imba_bottle_texture_controller_2:IsPurgable() return false end
function modifier_item_imba_bottle_texture_controller_2:IsDebuff() return false end
function modifier_item_imba_bottle_texture_controller_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_bottle_texture_controller_2:OnCreated()
	if self:GetParent().bottle_icon then
		self:SetStackCount(self:GetParent().bottle_icon)
		self:GetAbility().bottle_icon = self:GetStackCount()
	end

	if IsClient() then
		self:GetAbility().bottle_icon = self:GetStackCount()
	end
end

modifier_item_imba_bottle_heal = class({
	GetTexture =			function() return "custom/bottle_0_3" end,
	IsPurgable =			function() return false end,
	GetEffectAttachType =	function() return PATTACH_ABSORIGIN_FOLLOW end,
})

function modifier_item_imba_bottle_heal:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_item_imba_bottle_heal:GetModifierConstantHealthRegen()
	if self:GetAbility() ~= nil then
		return self:GetAbility():GetSpecialValueFor("health_restore") / self:GetAbility():GetSpecialValueFor("restore_time")
	end
end

function modifier_item_imba_bottle_heal:GetModifierConstantManaRegen()
	if self:GetAbility() ~= nil then
		return self:GetAbility():GetSpecialValueFor("mana_restore") / self:GetAbility():GetSpecialValueFor("restore_time")
	end
end

function modifier_item_imba_bottle_heal:OnCreated()
	if not IsServer() then return end
	self.pfx = ParticleManager:CreateParticle(self:GetCaster().bottle_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end

function modifier_item_imba_bottle_heal:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)
end
