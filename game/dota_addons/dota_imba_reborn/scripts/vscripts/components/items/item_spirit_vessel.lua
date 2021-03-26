-- Creator:
-- 	AltiV - February 22nd, 2019

-- TODO:
-- Spirit Vessel overrides the heal buff and damage debuff of Urn of Shadows, but the urn cannot override the vessel's modifiers.
-- When attempting to do so, Urn of Shadows only goes on cooldown, without losing charges.

LinkLuaModifier("modifier_item_imba_spirit_vessel", "components/items/item_spirit_vessel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_spirit_vessel_heal", "components/items/item_spirit_vessel.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_spirit_vessel_damage", "components/items/item_spirit_vessel.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_spirit_vessel					= class({})
modifier_item_imba_spirit_vessel		= class({})
modifier_item_imba_spirit_vessel_heal	= class({})
modifier_item_imba_spirit_vessel_damage	= class({})

------------------------
-- SPIRIT VESSEL BASE --
------------------------

function item_imba_spirit_vessel:GetIntrinsicModifierName()
	return "modifier_item_imba_spirit_vessel"
end

function item_imba_spirit_vessel:OnSpellStart()
	-- This is to prevent Ogre Magi's vanilla Multicast from working with vessel
	if self:GetPurchaseTime() == -1 then return end

	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	-- self.bonus_health					=	self:GetSpecialValueFor("bonus_health")
	-- self.bonus_movement_speed			=	self:GetSpecialValueFor("bonus_movement_speed")
	-- self.bonus_mana_regen				=	self:GetSpecialValueFor("bonus_mana_regen")
	-- self.bonus_all_stats				=	self:GetSpecialValueFor("bonus_all_stats")
	-- self.bonus_armor					=	self:GetSpecialValueFor("bonus_armor")
	self.soul_radius					=	self:GetSpecialValueFor("soul_radius")
	self.soul_initial_charge			=	self:GetSpecialValueFor("soul_initial_charge")
	self.soul_additional_charges		=	self:GetSpecialValueFor("soul_additional_charges")
	self.soul_heal_amount				=	self:GetSpecialValueFor("soul_heal_amount")
	self.soul_damage_amount				=	self:GetSpecialValueFor("soul_damage_amount")
	self.duration						=	self:GetSpecialValueFor("duration")
	self.soul_release_range_tooltip		=	self:GetSpecialValueFor("soul_release_range_tooltip")
	self.hp_regen_reduction_enemy		=	self:GetSpecialValueFor("hp_regen_reduction_enemy")
	self.enemy_hp_drain					=	self:GetSpecialValueFor("enemy_hp_drain")
	self.soul_sacrifice_max_health_pct	= self:GetSpecialValueFor("soul_sacrifice_max_health_pct")

	-- -- Level 2 (and above?) does...something
	-- if self:GetLevel() >= 2 then

	-- end
	
	-- Don't reduce charges in WTF mode (there might be some edge case where some other modifier immediately reduces this item's CD to 0 in which case it also won't lose charges but that will be addressed if it ever comes...maybe.
	if self:GetCooldownTimeRemaining() > 0 then
		
		-- IMBAfication: Soul Sacrifice
		if self:GetCurrentCharges() == 0 then
			
			-- -- Set the fountain as the damage dealer
			-- local fountain = Entities:FindByName(nil, "ent_dota_fountain_good")
			
			-- -- If the caster is on Radiant, the Dire fountain is the damage dealer
			-- if self.caster:GetTeam() == 2 then
				-- fountain = Entities:FindByName(nil, "ent_dota_fountain_bad")
			-- end
			
			-- local damageTableSelf = {
				-- victim 			= self.caster,
				-- damage 			= self.caster:GetMaxHealth() * (self.soul_sacrifice_max_health_pct / 100),
				-- damage_type		= DAMAGE_TYPE_PURE,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL,
				-- attacker 		= fountain,
				-- ability 		= self.ability
			-- }
			
			-- ApplyDamage(damageTableSelf)
			
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, self.caster, self.caster:GetMaxHealth() * (self.soul_sacrifice_max_health_pct / 100), nil)
			
			self.caster:AddNewModifier(self.caster, self, "modifier_item_imba_spirit_vessel_damage", {duration = self.duration})
		else
			self:SetCurrentCharges(math.max(self:GetCurrentCharges() - 1, 0))
		end
	end

	self.target	= self:GetCursorTarget()
	
	-- Play the cast sound
	self.caster:EmitSound("DOTA_Item.SpiritVessel.Cast")

	-- Emit the cast particles
	self.particle	= ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(self.particle, 1, self.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)

	-- Check if target is an ally or an enemy
	local vesselSound		= "DOTA_Item.SpiritVessel.Target.Enemy"
	local vesselModifier	= "modifier_item_imba_spirit_vessel_damage"
	
	if self.target:GetTeam() == self.caster:GetTeam() then
		vesselSound		= "DOTA_Item.SpiritVessel.Target.Ally"
		vesselModifier	= "modifier_item_imba_spirit_vessel_heal"
	end

	self.target:EmitSound(vesselSound)
	
	self.target:AddNewModifier(self.caster, self, vesselModifier, {duration = self.duration})
end

-- This function SEEMS to call if the enemy hero dying is like within 1625 range or something (must be non-reincarnation and real hero)

-- Never mind this function doesn't activate consistently so just using the MODIFIER_EVENT_ON_DEATH function instead...

-- function item_imba_spirit_vessel:OnHeroDiedNearby(unit, attacker, tableParam)
	-- local caster		= self:GetCaster()
	-- local soul_radius	= self:GetSpecialValueFor("soul_radius")

	-- -- First check: Is the unit within capture range?
	-- if (caster:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() <= soul_radius then
	
		-- -- Second check: Is there no one closer than the item owner that also has a Spirit Vessel?
		-- local nearbyAllies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, soul_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
		
		-- for _, ally in pairs(nearbyAllies) do
			-- -- If the check reaches the item owner then break out of loop and continue checks
			-- if ally == caster then
				-- break
			-- -- If anyone closer has the same item, the owner of this item will not get any charges
			-- elseif ally:HasItemInInventory(self:GetName()) then
				-- return
			-- end
		-- end
		
		-- -- If the parent has multiple Spirit Vessels, only apply the charge gain to the first one
		-- if caster:FindModifierByName("modifier_item_imba_spirit_vessel") == caster:FindAllModifiersByName("modifier_item_imba_spirit_vessel")[1] then
			-- for itemSlot = 0, 5 do
				-- local item = caster:GetItemInSlot(itemSlot)
			
				-- if item:GetName() == self:GetName() then
					-- -- 2 charges if current count is 0, 1 charge otherwise
					-- if item:GetCurrentCharges() == 0 then
						-- item:SetCurrentCharges(item:GetCurrentCharges() + self:GetSpecialValueFor("soul_initial_charge"))
					-- else
						-- item:SetCurrentCharges(item:GetCurrentCharges() + self:GetSpecialValueFor("soul_additional_charges"))
					-- end
					
					-- -- Don't continue checking for any other Spirit Vessels cause it only adds to one
					-- break
				-- end
			-- end
		-- end	
	-- end
-- end

---------------------------------
-- SPIRIT VESSEL HEAL MODIFIER --
---------------------------------

function modifier_item_imba_spirit_vessel_heal:GetEffectName()
	return "particles/items4_fx/spirit_vessel_heal.vpcf"
end

function modifier_item_imba_spirit_vessel_heal:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_health				=	self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_movement_speed		=	self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	self.bonus_all_stats			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_armor				=	self.ability:GetSpecialValueFor("bonus_armor")
	self.soul_radius				=	self.ability:GetSpecialValueFor("soul_radius")
	self.soul_initial_charge		=	self.ability:GetSpecialValueFor("soul_initial_charge")
	self.soul_additional_charges	=	self.ability:GetSpecialValueFor("soul_additional_charges")
	self.soul_heal_amount			=	self.ability:GetSpecialValueFor("soul_heal_amount")
	self.soul_damage_amount			=	self.ability:GetSpecialValueFor("soul_damage_amount")
	self.duration					=	self.ability:GetSpecialValueFor("duration")
	self.soul_release_range_tooltip	=	self.ability:GetSpecialValueFor("soul_release_range_tooltip")
	self.hp_regen_reduction_enemy	=	self.ability:GetSpecialValueFor("hp_regen_reduction_enemy")
	self.enemy_hp_drain				=	self.ability:GetSpecialValueFor("enemy_hp_drain")
	
	if not IsServer() then return end
	
	-- Overrides Urn of Shadows modifier
	if self.parent:HasModifier("modifier_imba_urn_of_shadows_active_ally") then
		self.parent:FindModifierByName("modifier_imba_urn_of_shadows_active_ally"):Destroy()
	end
end

function modifier_item_imba_spirit_vessel_heal:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_item_imba_spirit_vessel_heal:GetModifierConstantHealthRegen()
	return self.soul_heal_amount
end

-- Remove heal on any non-self player or rosh based damage
function modifier_item_imba_spirit_vessel_heal:OnTakeDamage(keys)
	if not IsServer() then return end
	
	if keys.unit == self.parent and keys.attacker ~= self.parent and (keys.attacker:IsConsideredHero() or keys.attacker:IsRoshan()) and keys.damage > 0 then
		self:Destroy()
	end
end

-----------------------------------
-- SPIRIT VESSEL DAMAGE MODIFIER --
-----------------------------------

function modifier_item_imba_spirit_vessel_damage:IsDebuff()	return true end

function modifier_item_imba_spirit_vessel_damage:GetEffectName()
	return "particles/items4_fx/spirit_vessel_damage.vpcf"
end

-- Not affected by status resistance (this is vanilla)
function modifier_item_imba_spirit_vessel_damage:IgnoreTenacity()
	return true
end

function modifier_item_imba_spirit_vessel_damage:OnCreated(params)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	if params and params.curse_stack then
		self:SetStackCount(params.curse_stack)
	end
	
	-- IMBAfication: Curse Activation
	self.debuff_multiplier			= math.max(self:GetStackCount(), 1)
	
	-- AbilitySpecials
	self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_movement_speed		= self.ability:GetSpecialValueFor("bonus_movement_speed")
	self.bonus_mana_regen			= self.ability:GetSpecialValueFor("bonus_mana_regen")
	self.bonus_all_stats			= self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_armor				= self.ability:GetSpecialValueFor("bonus_armor")
	self.soul_radius				= self.ability:GetSpecialValueFor("soul_radius")
	self.soul_initial_charge		= self.ability:GetSpecialValueFor("soul_initial_charge")
	self.soul_additional_charges	= self.ability:GetSpecialValueFor("soul_additional_charges")
	self.soul_heal_amount			= self.ability:GetSpecialValueFor("soul_heal_amount")
	self.soul_damage_amount			= self.ability:GetSpecialValueFor("soul_damage_amount") * self.debuff_multiplier
	self.duration					= self.ability:GetSpecialValueFor("duration")
	self.soul_release_range_tooltip	= self.ability:GetSpecialValueFor("soul_release_range_tooltip")
	-- Field m_flHealthThinkRegen tried to quantize an out-of-range value (-101287.726563, range is -100.000000->1000.000000), clamping.
	self.hp_regen_reduction_enemy	= self.ability:GetSpecialValueFor("hp_regen_reduction_enemy") * self.debuff_multiplier * (-1)
	self.enemy_hp_drain				= self.ability:GetSpecialValueFor("enemy_hp_drain") * self.debuff_multiplier
	self.curse_activation_reduction	= self.ability:GetSpecialValueFor("curse_activation_reduction")
	
	if not IsServer() then return end
	
	-- Overrides Urn of Shadows modifier
	if self.parent:HasModifier("modifier_imba_urn_of_shadows_active_enemy") then
		self.parent:FindModifierByName("modifier_imba_urn_of_shadows_active_enemy"):Destroy()
	end
	
	-- Applies damage every second
	self:StartIntervalThink(1)
end

-- This is mostly just to recalculate who the caster is for damage ownership
function modifier_item_imba_spirit_vessel_damage:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_spirit_vessel_damage:OnIntervalThink()
	if not IsServer() then return end
	
	-- Applies flat damage and damage based on current HP in one instance
	local damageTableHP = {
		victim 			= self.parent,
		damage 			= self.soul_damage_amount + (self.parent:GetHealth() * (self.enemy_hp_drain / 100)),
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.caster,
		ability 		= self.ability
	}
	
	ApplyDamage(damageTableHP)
end

-- IMBAfication: Curse Activation
function modifier_item_imba_spirit_vessel_damage:OnDestroy()
	if not IsServer() then return end
	
	local duration		= math.max(self:GetRemainingTime() - self.curse_activation_reduction, 0)
	local curse_stack	= math.max(self:GetStackCount(), 1) * self:GetAbility():GetSpecialValueFor("curse_activation_mult")
	
	-- Some exceptions due to this deleting certain heroes otherwise
	if self:GetParent():HasModifier("modifier_slark_dark_pact_pulses") or self:GetParent():HasModifier("modifier_imba_slark_dark_pact_pulses") or (self:GetParent():HasModifier("modifier_imba_tidehunter_kraken_shell") and not self:GetParent():PassivesDisabled()) or self:GetParent():HasModifier("modifier_imba_voodoo_restoration") then
		duration	= math.max(self:GetRemainingTime() + self.curse_activation_reduction, 0)
		curse_stack = nil
	end
	
	if (self:GetRemainingTime() / self:GetDuration()) >= 0.5 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_spirit_vessel_damage", {duration = duration, curse_stack = curse_stack})
	end
end

function modifier_item_imba_spirit_vessel_damage:DeclareFunctions()	
	return {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_item_imba_spirit_vessel_damage:GetModifierHealAmplify_PercentageTarget()
	return self.hp_regen_reduction_enemy
end

function modifier_item_imba_spirit_vessel_damage:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_reduction_enemy
end

function modifier_item_imba_spirit_vessel_damage:OnTooltip()
	return self.hp_regen_reduction_enemy
end

-- function modifier_item_imba_spirit_vessel_damage:Custom_AllHealAmplify_Percentage()
	-- return self.hp_regen_reduction_enemy
-- end

----------------------------
-- SPIRIT VESSEL MODIFIER --
----------------------------

function modifier_item_imba_spirit_vessel:IsHidden() return true end
function modifier_item_imba_spirit_vessel:IsPurgable() return false end
function modifier_item_imba_spirit_vessel:RemoveOnDeath() return false end
function modifier_item_imba_spirit_vessel:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_spirit_vessel:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
--		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
		MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_item_imba_spirit_vessel:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

--[[
function modifier_item_imba_spirit_vessel:GetModifierMoveSpeedBonus_Constant()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end
--]]

function modifier_item_imba_spirit_vessel:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	end
end

function modifier_item_imba_spirit_vessel:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_item_imba_spirit_vessel:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_item_imba_spirit_vessel:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_item_imba_spirit_vessel:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end


function modifier_item_imba_spirit_vessel:OnDeath(keys)
	-- First check: Is the unit within capture range and an enemy and not reincarnating?
	if self:GetAbility() and keys.unit:IsRealHero() and self:GetCaster():IsRealHero() and self:GetCaster():GetTeam() ~= keys.unit:GetTeam() and (not keys.unit.IsReincarnating or (keys.unit.IsReincarnating and not keys.unit:IsReincarnating())) and self:GetCaster():IsAlive() and (self:GetCaster():GetAbsOrigin() - keys.unit:GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("soul_radius") then
	
		-- Second check: Is there no one closer than the item owner that also has a Spirit Vessel?
		local nearbyAllies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.unit:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("soul_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
		
		for _, ally in pairs(nearbyAllies) do
			-- If the check reaches the item owner then break out of loop and continue checks
			if ally == self:GetCaster() then
				break
			-- If anyone closer has the same item, the owner of this item will not get any charges
			elseif ally:HasItemInInventory(self:GetAbility():GetName()) then
				return
			end
		end
		
		-- If the parent has multiple Spirit Vessels, only apply the charge gain to the first one
		if self == self:GetCaster():FindAllModifiersByName("modifier_item_imba_spirit_vessel")[1] then
			for itemSlot = 0, 5 do
				local item = self:GetCaster():GetItemInSlot(itemSlot)
			
				if item and item:GetName() == self:GetAbility():GetName() then
					-- 2 charges if current count is 0, 1 charge otherwise
					if item:GetCurrentCharges() == 0 then
						item:SetCurrentCharges(item:GetCurrentCharges() + self:GetAbility():GetSpecialValueFor("soul_initial_charge"))
					else
						item:SetCurrentCharges(item:GetCurrentCharges() + self:GetAbility():GetSpecialValueFor("soul_additional_charges"))
					end
					
					-- Don't continue checking for any other Spirit Vessels cause it only adds to one
					break
				end
			end
		end	
	end
end
