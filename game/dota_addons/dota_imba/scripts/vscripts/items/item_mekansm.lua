--	Author: Rook
--	Date: 			26.01.2015		<-- Dinosaurs roamed the earth
--	Converted to lua by Firetoad
--	Last Update:	26.03.2017
--	Arcane Boots, Mekansm, and Guardian Greaves

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots definition
-----------------------------------------------------------------------------------------------------------

if item_imba_arcane_boots == nil then item_imba_arcane_boots = class({}) end
LinkLuaModifier( "modifier_item_imba_arcane_boots", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )				-- Owner's bonus attributes, stackable

function item_imba_arcane_boots:GetIntrinsicModifierName()
	return "modifier_item_imba_arcane_boots" end

function item_imba_arcane_boots:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local replenish_mana = self:GetSpecialValueFor("base_replenish_mana") + self:GetSpecialValueFor("replenish_mana_pct") * caster:GetMaxMana() * 0.01
		local replenish_radius = self:GetSpecialValueFor("replenish_radius")

		-- Play activation sound and particle
		caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")
		local arcane_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(arcane_pfx)

		-- Iterate through nearby allies
		local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, replenish_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do

			-- Grant the ally mana 
			ally:GiveMana(replenish_mana)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , ally, replenish_mana, nil)

			-- Play the "hit" particle
			local arcane_target_pfx = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(arcane_target_pfx)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Arcane Boots owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_arcane_boots == nil then modifier_item_imba_arcane_boots = class({}) end
function modifier_item_imba_arcane_boots:IsHidden() return true end
function modifier_item_imba_arcane_boots:IsDebuff() return false end
function modifier_item_imba_arcane_boots:IsPurgable() return false end
function modifier_item_imba_arcane_boots:IsPermanent() return true end
function modifier_item_imba_arcane_boots:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_arcane_boots:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
	return funcs
end

function modifier_item_imba_arcane_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_ms") end

function modifier_item_imba_arcane_boots:GetModifierManaBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_mana") end



-----------------------------------------------------------------------------------------------------------
--	Mekansm definition
-----------------------------------------------------------------------------------------------------------

if item_imba_mekansm == nil then item_imba_mekansm = class({}) end
LinkLuaModifier( "modifier_item_imba_mekansm", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )					-- Owner's bonus attributes, stackable
LinkLuaModifier( "modifier_item_imba_mekansm_aura_emitter", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )	-- Aura emitter
LinkLuaModifier( "modifier_item_imba_mekansm_aura", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura buff
LinkLuaModifier( "modifier_item_imba_mekansm_heal", "items/item_mekansm.lua", LUA_MODIFIER_MOTION_NONE )			-- Heal buff

function item_imba_mekansm:GetIntrinsicModifierName()
	return "modifier_item_imba_mekansm" end

function item_imba_mekansm:OnSpellStart()
	if IsServer() then

		-- Parameters
		local caster = self:GetCaster()
		local heal_amount = self:GetSpecialValueFor("heal_amount") * (1 + caster:GetSpellPower() * 0.01)
		local heal_radius = self:GetSpecialValueFor("heal_radius")
		local heal_duration = self:GetSpecialValueFor("heal_duration")

		-- Play activation sound and particle
		caster:EmitSound("DOTA_Item.Mekansm.Activate")
		local mekansm_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:ReleaseParticleIndex(mekansm_pfx)

		-- Iterate through nearby allies
		local caster_loc = caster:GetAbsOrigin()
		local nearby_allies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, ally in pairs(nearby_allies) do

			-- Heal the ally
			ally:Heal(heal_amount, caster)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, heal_amount, nil)

			-- Play healing sound & particle
			ally:EmitSound("DOTA_Item.Mekansm.Target")
			local mekansm_target_pfx = ParticleManager:CreateParticle("particles/items2_fx/mekanism_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 0, caster_loc)
			ParticleManager:SetParticleControl(mekansm_target_pfx, 1, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(mekansm_target_pfx)

			-- Apply armor & heal over time buff
			ally:AddNewModifier(caster, self, "modifier_item_imba_mekansm_heal", {duration = heal_duration})
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Mekansm owner bonus attributes (stackable)
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm == nil then modifier_item_imba_mekansm = class({}) end
function modifier_item_imba_mekansm:IsHidden() return true end
function modifier_item_imba_mekansm:IsDebuff() return false end
function modifier_item_imba_mekansm:IsPurgable() return false end
function modifier_item_imba_mekansm:IsPermanent() return true end
function modifier_item_imba_mekansm:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the aura emitter to the caster when created
function modifier_item_imba_mekansm:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_mekansm_aura_emitter") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_imba_mekansm_aura_emitter", {})
		end
	end
end

-- Removes the aura emitter from the caster if this is the last mekansm in its inventory
function modifier_item_imba_mekansm:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_item_imba_mekansm") then
			parent:RemoveModifierByName("modifier_item_imba_mekansm_aura_emitter")
		end
	end
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_item_imba_mekansm:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_imba_mekansm:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_imba_mekansm:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end

function modifier_item_imba_mekansm:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura emitter
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_aura_emitter == nil then modifier_item_imba_mekansm_aura_emitter = class({}) end
function modifier_item_imba_mekansm_aura_emitter:IsAura() return true end
function modifier_item_imba_mekansm_aura_emitter:IsHidden() return true end
function modifier_item_imba_mekansm_aura_emitter:IsDebuff() return false end
function modifier_item_imba_mekansm_aura_emitter:IsPurgable() return false end

function modifier_item_imba_mekansm_aura_emitter:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
	
function modifier_item_imba_mekansm_aura_emitter:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
	
function modifier_item_imba_mekansm_aura_emitter:GetModifierAura()
	if IsServer() then
		if self:GetParent():IsAlive() then
			return "modifier_item_imba_mekansm_aura"
		else
			return nil
		end
	end
end
	
function modifier_item_imba_mekansm_aura_emitter:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

-----------------------------------------------------------------------------------------------------------
--	Mekansm aura
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_aura == nil then modifier_item_imba_mekansm_aura = class({}) end
function modifier_item_imba_mekansm_aura:IsHidden() return false end
function modifier_item_imba_mekansm_aura:IsDebuff() return false end
function modifier_item_imba_mekansm_aura:IsPurgable() return false end

-- Aura icon
function modifier_item_imba_mekansm_aura:GetTexture()
	return "custom/imba_mekansm" end

-- Stores the aura's parameters to prevent errors when the item is destroyed
function modifier_item_imba_mekansm_aura:OnCreated(keys)
	self.aura_health_regen = self:GetAbility():GetSpecialValueFor("aura_health_regen")
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_item_imba_mekansm_aura:GetModifierConstantHealthRegen()
	return self.aura_health_regen end

-----------------------------------------------------------------------------------------------------------
--	Mekansm heal over time
-----------------------------------------------------------------------------------------------------------

if modifier_item_imba_mekansm_heal == nil then modifier_item_imba_mekansm_heal = class({}) end
function modifier_item_imba_mekansm_heal:IsHidden() return false end
function modifier_item_imba_mekansm_heal:IsDebuff() return false end
function modifier_item_imba_mekansm_heal:IsPurgable() return true end

-- Modifier texture
function modifier_item_imba_mekansm_heal:GetTexture()
	return "custom/imba_mekansm" end

-- Stores the ability's parameters to prevent errors if the item is destroyed
function modifier_item_imba_mekansm_heal:OnCreated(keys)
	self.heal_bonus_armor = self:GetAbility():GetSpecialValueFor("heal_bonus_armor")
	self.heal_percentage = self:GetAbility():GetSpecialValueFor("heal_percentage")
end

-- Declare modifier events/properties
function modifier_item_imba_mekansm_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE,
	}
	return funcs
end

function modifier_item_imba_mekansm_heal:GetModifierHealthRegenPercentage()
	return self.heal_percentage end

function modifier_item_imba_mekansm_heal:GetModifierPhysicalArmorBonusUniqueActive()
	return self.heal_bonus_armor end