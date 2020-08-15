-- Creator:
-- 	AltiV - August 17th, 2019

LinkLuaModifier("modifier_item_imba_aether_specs", "components/items/item_aether_specs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_aether_specs_ward", "components/items/item_aether_specs", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_aether_specs_aura_bonus", "components/items/item_aether_specs", LUA_MODIFIER_MOTION_NONE)

item_imba_aether_specs							= class({})
modifier_item_imba_aether_specs_ward			= class({})
modifier_item_imba_aether_specs					= class({})
modifier_item_imba_aether_specs_aura_bonus		= class({})

-----------------------
-- AETHER SPECS BASE --
-----------------------

function item_imba_aether_specs:GetIntrinsicModifierName()
	Timers:CreateTimer(FrameTime(), function()
		if not self:IsNull() then
			for _, modifier in pairs(self:GetParent():FindAllModifiersByName("modifier_item_imba_aether_specs")) do
				modifier:SetStackCount(_)
			end
		end
	end)
	
	return "modifier_item_imba_aether_specs"
end

function item_imba_aether_specs:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_imba_aether_specs:OnSpellStart()
	local ward = CreateUnitByName("npc_dota_aether_spec_ward", self:GetCursorPosition(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	ward:AddNewModifier(self:GetCaster(), self, "modifier_item_buff_ward", {duration = self:GetSpecialValueFor("ward_duration")})
	-- I have no idea what this modifier does
	ward:AddNewModifier(self:GetCaster(), self, "modifier_truesight", {duration = self:GetSpecialValueFor("ward_duration")})
	-- This doesn't actually give truesight but it gives a random sentry ward buff so w/e
	ward:AddNewModifier(self:GetCaster(), self, "modifier_item_ward_true_sight", {duration = self:GetSpecialValueFor("ward_duration")})
	ward:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_gem_of_true_sight", {duration = self:GetSpecialValueFor("ward_duration")}) -- The radius was designated with the "radius" KV for the item in npc_items_custom.txt (guess that's just how it works)
	ward:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_aether_specs_ward", {duration = self:GetSpecialValueFor("ward_duration")})
	
	ward:SetBaseMaxHealth(self:GetSpecialValueFor("hits_to_kill") * 4)
	ward:SetMaxHealth(self:GetSpecialValueFor("hits_to_kill") * 4)
	ward:SetHealth(self:GetSpecialValueFor("hits_to_kill") * 4)
	
	EmitSoundOnLocationForAllies(self:GetParent():GetAbsOrigin(), "DOTA_Item.ObserverWard.Activate", self:GetCaster())
end

-----------------------------------
-- AETHER OF SPECS WARD MODIFIER --
-----------------------------------

function modifier_item_imba_aether_specs_ward:IsHidden()	return true end
function modifier_item_imba_aether_specs_ward:IsPurgable()	return false end

function modifier_item_imba_aether_specs_ward:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	
	self.radius		= self:GetAbility():GetSpecialValueFor("radius")
	
	-- self.interval	= 0.5
	
	local aura_particle = ParticleManager:CreateParticle("particles/items_fx/aether_specs_ward_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(aura_particle, 1, Vector(self.radius, 0, 0))
	self:AddParticle(aura_particle, false, false, -1, false, false)
	
	-- self:StartIntervalThink(self.interval)
end

-- function modifier_item_imba_aether_specs_ward:OnIntervalThink()
	-- AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self.interval, false)
-- end

-- function modifier_item_imba_aether_specs_ward:CheckState()
	-- return {[MODIFIER_STATE_FLYING] = true}
-- end

------------------------------
-- AETHER OF SPECS MODIFIER --
------------------------------

function modifier_item_imba_aether_specs:IsHidden()			return true end
function modifier_item_imba_aether_specs:IsPurgable()		return false end
function modifier_item_imba_aether_specs:RemoveOnDeath()	return false end
function modifier_item_imba_aether_specs:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_aether_specs:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if self:GetAbility() then
		-- AbilitySpecials
		self.bonus_mana 		= self:GetAbility():GetSpecialValueFor("bonus_mana")
		self.bonus_mana_regen 	= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
		self.cast_range_bonus 	= self:GetAbility():GetSpecialValueFor("cast_range_bonus")
		self.spell_power 		= self:GetAbility():GetSpecialValueFor("spell_power")

		self.bonus_damage		= self:GetAbility():GetSpecialValueFor("bonus_damage")
		self.bonus_strength		= self:GetAbility():GetSpecialValueFor("bonus_strength")
		self.bonus_agility		= self:GetAbility():GetSpecialValueFor("bonus_agility")
		self.bonus_intellect	= self:GetAbility():GetSpecialValueFor("bonus_intellect")
		self.bonus_aspd			= self:GetAbility():GetSpecialValueFor("bonus_aspd")
	else
		self.bonus_mana 		= 0
		self.bonus_mana_regen 	= 0
		self.cast_range_bonus 	= 0
		self.spell_power 		= 0

		self.bonus_damage		= 0
		self.bonus_strength		= 0
		self.bonus_agility		= 0
		self.bonus_intellect	= 0
		self.bonus_aspd			= 0
	end

	if not IsServer() then return end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_aether_specs:OnDestroy()
	if not IsServer() then return end
	
	for _, modifier in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		modifier:SetStackCount(_)
		modifier:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_item_imba_aether_specs:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,	
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_imba_aether_specs:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_aether_specs:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_imba_aether_specs:GetModifierCastRangeBonusStacking()
	if self:GetStackCount() ~= 1 then
		return 0
	else
		return self.cast_range_bonus
	end
end

-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_item_imba_aether_specs:GetModifierSpellAmplify_Percentage()
    if self:GetAbility():GetSecondaryCharges() == 1 and 
	not self:GetParent():HasModifier("modifier_item_imba_cyclone_2") and 
	not self:GetParent():HasModifier("modifier_item_imba_armlet_of_dementor") and
	not self:GetParent():HasModifier("modifier_item_imba_arcane_nexus_passive") then
        return self.spell_power
    end
end

function modifier_item_imba_aether_specs:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_aether_specs:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_imba_aether_specs:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_imba_aether_specs:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_aether_specs:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_aspd
end

function modifier_item_imba_aether_specs:IsAura()						return true end
function modifier_item_imba_aether_specs:IsAuraActiveOnDeath() 			return false end

function modifier_item_imba_aether_specs:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_imba_aether_specs:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_item_imba_aether_specs:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_imba_aether_specs:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_aether_specs:GetModifierAura()				return "modifier_item_imba_aether_specs_aura_bonus" end

--------------------------------
-- AETHER SPECS AURA MODIFIER --
--------------------------------

function modifier_item_imba_aether_specs_aura_bonus:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	-- AbilitySpecials
	self.aura_mana_regen		= self:GetAbility():GetSpecialValueFor("aura_mana_regen")
	self.aura_bonus_armor		= self:GetAbility():GetSpecialValueFor("aura_bonus_armor")
	self.aura_bonus_vision		= self:GetAbility():GetSpecialValueFor("aura_bonus_vision")
	self.aura_bonus_cast_range	= self:GetAbility():GetSpecialValueFor("aura_bonus_cast_range")
end

function modifier_item_imba_aether_specs_aura_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
	}
end

function modifier_item_imba_aether_specs_aura_bonus:GetModifierConstantManaRegenUnique()
	return self.aura_mana_regen
end

function modifier_item_imba_aether_specs_aura_bonus:GetModifierPhysicalArmorBonusUnique()
	if not self:GetParent():IsIllusion() then
		return self.aura_bonus_armor
	end
end

function modifier_item_imba_aether_specs_aura_bonus:GetBonusDayVision()
	if not self:GetParent():IsIllusion() then
		return self.aura_bonus_vision
	end
end

function modifier_item_imba_aether_specs_aura_bonus:GetBonusNightVision()
	if not self:GetParent():IsIllusion() then
		return self.aura_bonus_vision
	end
end

function modifier_item_imba_aether_specs_aura_bonus:GetModifierCastRangeBonusStacking()
	return self.aura_bonus_cast_range
end
