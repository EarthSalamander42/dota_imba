item_imba_sogat_cuirass = class({})
LinkLuaModifier("modifier_imba_sogat_cuirass", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sogat_cuirass_aura_positive", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sogat_cuirass_aura_positive_effect", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sogat_cuirass_aura_negative", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sogat_cuirass_aura_negative_effect", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_sogat_cuirass_buff", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_sogat_cuirass_nostack", "components/items/item_sogat_cuirass.lua", LUA_MODIFIER_MOTION_NONE)

function item_imba_sogat_cuirass:GetIntrinsicModifierName()
	return "modifier_imba_sogat_cuirass"
end

function item_imba_sogat_cuirass:OnSpellStart(keys)
	if IsServer() then
		local non_relevant_units = {
			["npc_imba_alchemist_greevil"] = true
		}

		-- Play sound
		self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")

		-- Play particle
		local cast_pfx = ParticleManager:CreateParticle("particles/items2_fx/sogat_cuirass_active_launch.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(cast_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(cast_pfx, 1, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(cast_pfx, 2, Vector(self:GetSpecialValueFor("active_radius"), 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		-- Apply the active buff to nearby allies
		local nearby_allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _,ally in pairs(nearby_allies) do
			if not non_relevant_units[ally:GetUnitName()] and not ally:HasModifier("modifier_item_imba_sogat_cuirass_nostack") then
				ally:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_sogat_cuirass_buff", {duration = self:GetSpecialValueFor("duration")})
				ally:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_sogat_cuirass_nostack", {duration = self:GetEffectiveCooldown(self:GetLevel()) - 1})
			end
		end
	end
end

-- Stats passive modifier (stacking)
modifier_imba_sogat_cuirass = class({})

function modifier_imba_sogat_cuirass:IsHidden() return true end
function modifier_imba_sogat_cuirass:IsPurgable() return false end
function modifier_imba_sogat_cuirass:RemoveOnDeath() return false end
function modifier_imba_sogat_cuirass:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_sogat_cuirass:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() and self:GetAbility() then
		-- If it is the first Assault Cuirass in the inventory, grant the Assault Cuirass aura
		if not self:GetCaster():HasModifier("modifier_imba_sogat_cuirass_aura_positive") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_sogat_cuirass_aura_positive", {})
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_sogat_cuirass_aura_negative", {})
		end
	end
end

function modifier_imba_sogat_cuirass:OnDestroy()
	if IsServer() then
		-- If it is the last Assault Cuirass in the inventory, remove the aura
		if not self:GetCaster():HasModifier("modifier_imba_sogat_cuirass") then
			self:GetCaster():RemoveModifierByName("modifier_imba_sogat_cuirass_aura_positive")
			self:GetCaster():RemoveModifierByName("modifier_imba_sogat_cuirass_aura_negative")
		end
	end
end

function modifier_imba_sogat_cuirass:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
--		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
--		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

-- function modifier_imba_sogat_cuirass:GetCustomDamageBlockUnique()
	-- return self:GetAbility():GetSpecialValueFor("damage_block")
-- end

function modifier_imba_sogat_cuirass:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_imba_sogat_cuirass:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_imba_sogat_cuirass:GetModifierAttackSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_as")
	end
end

function modifier_imba_sogat_cuirass:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end

--[[
function modifier_imba_sogat_cuirass:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_stats")
	end
end

function modifier_imba_sogat_cuirass:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_stats")
	end
end

function modifier_imba_sogat_cuirass:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_stats")
	end
end
--]]

function modifier_imba_sogat_cuirass:GetModifierPhysical_ConstantBlock()
	if self:GetAbility() then
		if RollPseudoRandom(self:GetAbility():GetSpecialValueFor("block_chance"), self) then
			if not self:GetParent():IsRangedAttacker() then
				return self:GetAbility():GetSpecialValueFor("block_damage_melee")
			else
				return self:GetAbility():GetSpecialValueFor("block_damage_ranged")
			end
		end
	end
end

-- Custom unique damage reduction property
function modifier_imba_sogat_cuirass:GetCustomIncomingDamageReductionUnique()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_reduction_pct_passive")
	end
end

-- Assault Cuirass positive aura
modifier_imba_sogat_cuirass_aura_positive = class({})

function modifier_imba_sogat_cuirass_aura_positive:IsDebuff() return false end
function modifier_imba_sogat_cuirass_aura_positive:AllowIllusionDuplicate() return true end
function modifier_imba_sogat_cuirass_aura_positive:IsHidden() return true end
function modifier_imba_sogat_cuirass_aura_positive:IsPurgable() return false end

function modifier_imba_sogat_cuirass_aura_positive:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_imba_sogat_cuirass_aura_positive:GetAuraEntityReject(target)
	-- If the target has Siege Aura from Siege Cuirass, ignore it
	if target:HasModifier("modifier_imba_siege_cuirass_aura_positive_effect") then
		return true
	end

	return false
end

function modifier_imba_sogat_cuirass_aura_positive:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_sogat_cuirass_aura_positive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_sogat_cuirass_aura_positive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_sogat_cuirass_aura_positive:GetModifierAura()
	return "modifier_imba_sogat_cuirass_aura_positive_effect"
end

function modifier_imba_sogat_cuirass_aura_positive:IsAura()
	return true
end

-- Assault Cuirass positive aura effect
modifier_imba_sogat_cuirass_aura_positive_effect = class({})

function modifier_imba_sogat_cuirass_aura_positive_effect:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return nil
	end

	-- Ability specials
	self.aura_as_ally = self:GetAbility():GetSpecialValueFor("aura_as_ally")
	self.aura_armor_ally = self:GetAbility():GetSpecialValueFor("aura_armor_ally")
end

function modifier_imba_sogat_cuirass_aura_positive_effect:IsHidden() return false end
function modifier_imba_sogat_cuirass_aura_positive_effect:IsPurgable() return false end
function modifier_imba_sogat_cuirass_aura_positive_effect:IsDebuff() return false end

function modifier_imba_sogat_cuirass_aura_positive_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_imba_sogat_cuirass_aura_positive_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_as_ally
end

function modifier_imba_sogat_cuirass_aura_positive_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_ally
end


-- Assault Cuirass negative aura
modifier_imba_sogat_cuirass_aura_negative = class({})

function modifier_imba_sogat_cuirass_aura_negative:IsDebuff() return false end
function modifier_imba_sogat_cuirass_aura_negative:AllowIllusionDuplicate() return true end
function modifier_imba_sogat_cuirass_aura_negative:IsHidden() return true end
function modifier_imba_sogat_cuirass_aura_negative:IsPurgable() return false end

function modifier_imba_sogat_cuirass_aura_negative:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_imba_sogat_cuirass_aura_negative:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_sogat_cuirass_aura_negative:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_sogat_cuirass_aura_negative:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_imba_sogat_cuirass_aura_negative:GetModifierAura()
	return "modifier_imba_sogat_cuirass_aura_negative_effect"
end

function modifier_imba_sogat_cuirass_aura_negative:IsAura()
	return true
end

-- Assault Cuirass negative aura effect
modifier_imba_sogat_cuirass_aura_negative_effect = class({})

function modifier_imba_sogat_cuirass_aura_negative_effect:GetTexture()
	return "/custom/imba_sogat_cuirass"
end

function modifier_imba_sogat_cuirass_aura_negative_effect:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if self:GetAbility() then
		self.aura_armor_reduction_enemy = self:GetAbility():GetSpecialValueFor("aura_armor_reduction_enemy") * (-1)
	else
		self.aura_armor_reduction_enemy = 0
	end
end

function modifier_imba_sogat_cuirass_aura_negative_effect:IsHidden() return false end
function modifier_imba_sogat_cuirass_aura_negative_effect:IsPurgable() return false end
function modifier_imba_sogat_cuirass_aura_negative_effect:IsDebuff() return true end

function modifier_imba_sogat_cuirass_aura_negative_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_imba_sogat_cuirass_aura_negative_effect:GetModifierPhysicalArmorBonus()
	return self.aura_armor_reduction_enemy
end

if modifier_item_imba_sogat_cuirass_buff == nil then modifier_item_imba_sogat_cuirass_buff = class({}) end
function modifier_item_imba_sogat_cuirass_buff:IsHidden() return false end
function modifier_item_imba_sogat_cuirass_buff:IsDebuff() return false end
function modifier_item_imba_sogat_cuirass_buff:IsPurgable() return false end

-- Particle creation and value storage
function modifier_item_imba_sogat_cuirass_buff:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.active_armor 					= self:GetAbility():GetSpecialValueFor("active_armor")
	self.block_damage_melee_active 		= self:GetAbility():GetSpecialValueFor("block_damage_melee_active")
	self.block_damage_ranged_active 	= self:GetAbility():GetSpecialValueFor("block_damage_ranged_active")
	self.block_chance_active 			= self:GetAbility():GetSpecialValueFor("block_chance_active")
	self.damage_reduction_pct 			= self:GetAbility():GetSpecialValueFor("damage_reduction_pct")

	if IsServer() then
		self.damage_reduction_pct = self:GetAbility():GetSpecialValueFor("damage_reduction_pct")

		self.sogat_active_pfx = ParticleManager:CreateParticle("particles/items2_fx/sogat_cuirass_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.sogat_active_pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.sogat_active_pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.sogat_active_pfx, false, false, -1, false, false)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_sogat_cuirass_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_sogat_cuirass_buff:GetModifierPhysicalArmorBonus()
	return self.active_armor
end

function modifier_item_imba_sogat_cuirass_buff:GetModifierPhysical_ConstantBlock()
	if IsClient() then return self.block_damage_melee_active end

	if RollPseudoRandom(self.block_chance_active, self) then
		if not self:GetParent():IsRangedAttacker() then
			return self.block_damage_melee_active
		else
			return self.block_damage_ranged_active
		end
	end
end

function modifier_item_imba_sogat_cuirass_buff:OnTooltip()
	return self.damage_reduction_pct
end

-- Custom unique damage reduction property
function modifier_item_imba_sogat_cuirass_buff:GetCustomIncomingDamageReductionUnique()
	return self.damage_reduction_pct
end

----------------------------------
--	Bulwark Modifier Cooldown	--
----------------------------------

modifier_item_imba_sogat_cuirass_nostack = class({})

function modifier_item_imba_sogat_cuirass_nostack:IsHidden() 		return false end
function modifier_item_imba_sogat_cuirass_nostack:IsDebuff() 		return true end
function modifier_item_imba_sogat_cuirass_nostack:IsPurgable() 		return false end
function modifier_item_imba_sogat_cuirass_nostack:RemoveOnDeath() 	return false end
