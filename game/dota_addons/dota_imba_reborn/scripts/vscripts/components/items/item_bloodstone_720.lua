-- Editors:
--     AltiV - February 16th, 2019

LinkLuaModifier("modifier_item_imba_bloodstone_720", "components/items/item_bloodstone_720", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_imba_bloodstone_active_720", "components/items/item_bloodstone_720", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_imba_bloodstone_active_cdr_720", "components/items/item_bloodstone_720", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_imba_bloodstone_min_health_null_720", "components/items/item_bloodstone_720", LUA_MODIFIER_MOTION_NONE )

item_imba_bloodstone_720 							= class({})
modifier_item_imba_bloodstone_720 					= class({})
modifier_item_imba_bloodstone_active_720 			= class({})
modifier_item_imba_bloodstone_active_cdr_720 		= class({})
modifier_item_imba_bloodstone_min_health_null_720	= class({})

function item_imba_bloodstone_720:GetIntrinsicModifierName()
	return "modifier_item_imba_bloodstone_720"
end

function item_imba_bloodstone_720:GetManaCost()
	-- There's like one server-tick where the caster is nil so add this conditional to prevent random error
	if self and not self:IsNull() and self.GetCaster and self:GetCaster() ~= nil then
		return self:GetCaster():GetMaxMana() * (self:GetSpecialValueFor("mana_cost_percentage") / 100)
	end
end

function item_imba_bloodstone_720:OnSpellStart()
	self.caster	= self:GetCaster()

	-- AbilitySpecials
	-- self.bonus_health				= self:GetSpecialValueFor("bonus_health")
	-- self.bonus_mana					= self:GetSpecialValueFor("bonus_mana")
	-- self.bonus_health_regen			= self:GetSpecialValueFor("bonus_health_regen")
	-- self.bonus_mana_regen			= self:GetSpecialValueFor("bonus_mana_regen")
	-- self.mana_regen_multiplier		= self:GetSpecialValueFor("mana_regen_multiplier")
	-- self.regen_per_charge			= self:GetSpecialValueFor("regen_per_charge")
	-- self.death_charges				= self:GetSpecialValueFor("death_charges")
	-- self.kill_charges				= self:GetSpecialValueFor("kill_charges")
	-- self.charge_range				= self:GetSpecialValueFor("charge_range")
	-- self.initial_charges_tooltip	= self:GetSpecialValueFor("initial_charges_tooltip")
	-- self.mana_cost_percentage		= self:GetSpecialValueFor("mana_cost_percentage")
	self.restore_duration			= self:GetSpecialValueFor("restore_duration")

	if not IsServer() then return end
		
	self.caster:EmitSound("DOTA_Item.Bloodstone.Cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_bloodstone_active_720", {duration = self.restore_duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_bloodstone_active_cdr_720", {duration = self:GetSpecialValueFor("active_duration")})
end

-------------------------------------
-- BLOODSTONE ACTIVE MODIFIER 7.20 --
-------------------------------------

function modifier_item_imba_bloodstone_active_720:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	self.restore_duration			= self.ability:GetSpecialValueFor("restore_duration")
	self.mana_cost					= self.ability:GetManaCost()
	
	if not IsServer() then return end
	
	self.cooldown_remaining			= math.max(self:GetAbility():GetCooldownTimeRemaining() - self:GetRemainingTime(), 0)

	self.particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self:StartIntervalThink(self:GetRemainingTime())
end

function modifier_item_imba_bloodstone_active_720:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_item_imba_bloodstone_min_health_null_720") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_bloodstone_min_health_null_720", {duration = self.cooldown_remaining})
	end
end

function modifier_item_imba_bloodstone_active_720:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MIN_HEALTH,	-- IMBAfication: Lingering Will
		MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_imba_bloodstone_active_720:GetModifierConstantHealthRegen()
    return self.mana_cost / self.restore_duration
end

function modifier_item_imba_bloodstone_active_720:GetMinHealth()
	if not self:GetParent():HasModifier("modifier_item_imba_bloodstone_min_health_null_720") then
		return self.mana_cost
	end
end

function modifier_item_imba_bloodstone_active_720:OnTooltip()
    return self.mana_cost
end

--------------------------------------
-- BLOODSTONE PASSIVE MODIFIER 7.20 --
--------------------------------------

function modifier_item_imba_bloodstone_720:IsHidden()		return true end
function modifier_item_imba_bloodstone_720:IsPurgable()	return false end
function modifier_item_imba_bloodstone_720:RemoveOnDeath()	return false end
function modifier_item_imba_bloodstone_720:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_bloodstone_720:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana					= self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_intellect			= self.ability:GetSpecialValueFor("bonus_intellect")
	self.manacost_reduction			= self.ability:GetSpecialValueFor("manacost_reduction")
	self.spell_amp					= self.ability:GetSpecialValueFor("spell_amp")
	self.mana_regen_multiplier		= self.ability:GetSpecialValueFor("mana_regen_multiplier")
	self.regen_per_charge			= self.ability:GetSpecialValueFor("regen_per_charge")
	self.amp_per_charge				= self.ability:GetSpecialValueFor("amp_per_charge")
	self.death_charges				= self.ability:GetSpecialValueFor("death_charges")
	self.kill_charges				= self.ability:GetSpecialValueFor("kill_charges")
	self.charge_range				= self.ability:GetSpecialValueFor("charge_range")
	self.initial_charges_tooltip	= self.ability:GetSpecialValueFor("initial_charges_tooltip")
	self.bonus_cdr					= self.ability:GetSpecialValueFor("bonus_cdr")
			
	if not IsServer() then return end
	
	-- Need to do this instead of using the "ItemInitialCharges" KV because the latter messes with sell prices
	if not self.ability.initialized then
		self.ability:SetCurrentCharges(self.initial_charges_tooltip)
		self.ability.initialized = true
	end
	
	self:SetStackCount(self.ability:GetCurrentCharges())
	
	-- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiple Bloodstones
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end

function modifier_item_imba_bloodstone_720:OnDestroy()
	if not IsServer() then return end
	
	for _, mod in pairs(self:GetCaster():FindAllModifiersByName(self:GetName())) do
		mod:GetAbility():SetSecondaryCharges(_)
	end
end


function modifier_item_imba_bloodstone_720:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		
		MODIFIER_EVENT_ON_DEATH 
    }
end

function modifier_item_imba_bloodstone_720:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_bloodstone_720:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_bloodstone_720:GetModifierTotalPercentageManaRegen()
	return self.mana_regen_multiplier / 100
end

function modifier_item_imba_bloodstone_720:GetModifierSpellAmplify_PercentageUnique()
	return self.spell_amp
end

function modifier_item_imba_bloodstone_720:GetModifierPercentageManacost()
	if self:GetAbility():GetSecondaryCharges() == 1 then
		return self.manacost_reduction
	end
end

function modifier_item_imba_bloodstone_720:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_bloodstone_720:GetModifierPercentageCooldown()
	if self:GetAbility():GetSecondaryCharges() == 1 then
		return self.bonus_cdr
	end
end

function modifier_item_imba_bloodstone_720:GetModifierConstantManaRegen()
	return self.regen_per_charge * self:GetStackCount()
end

function modifier_item_imba_bloodstone_720:GetModifierSpellAmplify_Percentage()
	return self.amp_per_charge * self:GetStackCount()
end

function modifier_item_imba_bloodstone_720:OnDeath(keys)
	if keys.unit:IsRealHero() and self.parent:IsRealHero() then
		-- Checks for real enemy heroes that have died within vicinity or if the parent is the killer
		if self.parent:GetTeam() ~= keys.unit:GetTeam() and ((keys.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.charge_range or self.parent == keys.attacker) and self.parent:IsAlive() then
			-- If the parent has multiple Bloodstones, only apply the charge gain to the top-left most one
			if self == self.parent:FindAllModifiersByName(self:GetName())[1] then
				for itemSlot = 0, 5 do
					local item = self.parent:GetItemInSlot(itemSlot)
				
					if item and item:GetName() == self.ability:GetName() then
						item:SetCurrentCharges(item:GetCurrentCharges() + self.kill_charges)
						break
					end
				end
			end
			
		-- Check if the owner of the Bloodstone died and is not reincarnating
		elseif self.parent == keys.unit and (not keys.unit.IsReincarnating or (keys.unit.IsReincarnating and not keys.unit:IsReincarnating())) then
			self.ability:SetCurrentCharges(math.max(self.ability:GetCurrentCharges() - self.death_charges, 0))
		end
		
		-- Set stack count to current charges to allow client-side regen to show
		self:SetStackCount(self.ability:GetCurrentCharges())	
	end
end

--------------------------------------------------
-- MODIFIER_ITEM_IMBA_BLOODSTONE_ACTIVE_CDR_720 --
--------------------------------------------------

function modifier_item_imba_bloodstone_active_cdr_720:IsPurgable() return false end

function modifier_item_imba_bloodstone_active_cdr_720:GetEffectName()
	return "particles/items2_fx/kaya_active_b0.vpcf"
end

function modifier_item_imba_bloodstone_active_cdr_720:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.active_cdr	= self:GetAbility():GetSpecialValueFor("active_cdr")
end

function modifier_item_imba_bloodstone_active_cdr_720:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_item_imba_bloodstone_active_cdr_720:GetModifierPercentageCooldown()
	return self.active_cdr
end

function modifier_item_imba_bloodstone_active_cdr_720:GetModifierPercentageManacost()
	return self.active_cdr
end

function modifier_item_imba_bloodstone_active_cdr_720:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsItem() and not keys.ability:IsToggle() then
		self:Destroy()
	end
end

-------------------------------------------------------
-- MODIFIER_ITEM_IMBA_BLOODSTONE_MIN_HEALTH_NULL_720 --
-------------------------------------------------------

function modifier_item_imba_bloodstone_min_health_null_720:IgnoreTenacity()	return true end
function modifier_item_imba_bloodstone_min_health_null_720:IsDebuff()		return true end
function modifier_item_imba_bloodstone_min_health_null_720:IsPurgable()		return false end
function modifier_item_imba_bloodstone_min_health_null_720:RemoveOnDeath()	return false end

function modifier_item_imba_bloodstone_min_health_null_720:GetTexture()
	return "item_bloodstone"
end
