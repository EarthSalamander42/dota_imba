--[[Author:
		-- d2imba: 13.08.2015 (datadriven)
	Editors:
		-- EarthSalamander #42: 13.10.2018 (luafied)
--	]]

------------------------------
--			CHEESE
------------------------------

-- Utilities

local function ConsumeCheese(parent, item)
	-- Play sound
	parent:EmitSound("DOTA_Item.Cheese.Activate")

	-- Fully heal yourself
	parent:Heal(parent:GetMaxHealth(), parent)
	parent:GiveMana(parent:GetMaxMana())

	-- Spend a charge
	item:SetCurrentCharges(item:GetCurrentCharges() - 1)

	-- If this was the last charge, remove the item
	if item:GetCurrentCharges() == 0 then
		parent:RemoveItem(item)
	else -- starting the cooldown manually is required for the auto-use
		item:StartCooldown(item:GetCooldown(item:GetLevel()))
	end
end

LinkLuaModifier("modifier_item_imba_cheese_death_prevention", "components/items/item_cheese.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_cheese = item_imba_cheese or class({})

function item_imba_cheese:GetIntrinsicModifierName()
	return "modifier_item_imba_cheese_death_prevention"
end

function item_imba_cheese:OnSpellStart()
	if IsServer() then
		ConsumeCheese(self:GetParent(), self)
	end
end

modifier_item_imba_cheese_death_prevention = modifier_item_imba_cheese_death_prevention or class({})

function modifier_item_imba_cheese_death_prevention:IsHidden() return true end
function modifier_item_imba_cheese_death_prevention:IsPurgable() return false end
function modifier_item_imba_cheese_death_prevention:IsPurgeException() return false end
function modifier_item_imba_cheese_death_prevention:RemoveOnDeath() return false end

function modifier_item_imba_cheese_death_prevention:DeclareFunctions()
	local state =
	{
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return state
end

function modifier_item_imba_cheese_death_prevention:OnTakeDamage(keys)
	if keys.unit:IsIllusion() or keys.unit ~= self:GetParent() then return end
	if keys.unit:HasModifier("modifier_imba_dazzle_shallow_grave") then return end

	if keys.unit:HasModifier("modifier_imba_dazzle_nothl_protection") then
		if keys.unit:FindModifierByName("modifier_imba_dazzle_nothl_protection"):GetStackCount() == 0 then
			return
		end
	end

	if keys.damage >= keys.unit:GetHealth() and self:GetAbility():IsCooldownReady() then
		ConsumeCheese(keys.unit, self:GetAbility())
	end
end

function modifier_item_imba_cheese_death_prevention:GetMinHealth()
	-- if the cooldown is ready, set the unit minimum health to 1 (invincible)
	if self:GetAbility():IsCooldownReady() and self:GetParent():IsRealHero() then
		return 1
	end

	return nil
end
