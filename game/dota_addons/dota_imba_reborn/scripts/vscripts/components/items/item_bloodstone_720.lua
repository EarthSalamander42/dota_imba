-- Editors:
--     AltiV - February 16th, 2019

LinkLuaModifier("modifier_item_imba_bloodstone_720", "components/items/item_bloodstone_720.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_imba_bloodstone_active_720", "components/items/item_bloodstone_720.lua", LUA_MODIFIER_MOTION_NONE )

item_imba_bloodstone_720 					= class({})
modifier_item_imba_bloodstone_720 			= class({})
modifier_item_imba_bloodstone_active_720 	= class({})

function item_imba_bloodstone_720:GetIntrinsicModifierName()
	return "modifier_item_imba_bloodstone_720"
end

function item_imba_bloodstone_720:GetManaCost()
	-- There's like one server-tick where the caster is nil so add this conditional to prevent random error
	if self:GetCaster() ~= nil then
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
end

-------------------------------------
-- BLOODSTONE ACTIVE MODIFIER 7.20 --
-------------------------------------

function modifier_item_imba_bloodstone_active_720:OnCreated()
	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	-- self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	-- self.bonus_mana					= self.ability:GetSpecialValueFor("bonus_mana")
	-- self.bonus_health_regen			= self.ability:GetSpecialValueFor("bonus_health_regen")
	-- self.bonus_mana_regen			= self.ability:GetSpecialValueFor("bonus_mana_regen")
	-- self.mana_regen_multiplier		= self.ability:GetSpecialValueFor("mana_regen_multiplier")
	-- self.regen_per_charge			= self.ability:GetSpecialValueFor("regen_per_charge")
	-- self.death_charges				= self.ability:GetSpecialValueFor("death_charges")
	-- self.kill_charges				= self.ability:GetSpecialValueFor("kill_charges")
	-- self.charge_range				= self.ability:GetSpecialValueFor("charge_range")
	-- self.initial_charges_tooltip	= self.ability:GetSpecialValueFor("initial_charges_tooltip")
	-- self.mana_cost_percentage		= self.ability:GetSpecialValueFor("mana_cost_percentage")
	self.restore_duration			= self.ability:GetSpecialValueFor("restore_duration")
	
	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(self.particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_item_imba_bloodstone_active_720:DeclareFunctions()
    local decFuncs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MIN_HEALTH,	-- IMBAfication: Lingering Will
		MODIFIER_PROPERTY_TOOLTIP
    }

    return decFuncs
end

function modifier_item_imba_bloodstone_active_720:GetModifierConstantHealthRegen()
    return self.ability:GetManaCost() / self.restore_duration
end

function modifier_item_imba_bloodstone_active_720:GetMinHealth()
    return self.ability:GetManaCost()
end

function modifier_item_imba_bloodstone_active_720:OnTooltip()
    return self.ability:GetManaCost()
end

--------------------------------------
-- BLOODSTONE PASSIVE MODIFIER 7.20 --
--------------------------------------

function modifier_item_imba_bloodstone_720:IsHidden()		return true end
function modifier_item_imba_bloodstone_720:IsPermanent()	return true end
function modifier_item_imba_bloodstone_720:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_bloodstone_720:OnCreated()
	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	
	self.bonus_health				= self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana					= self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_health_regen			= self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			= self.ability:GetSpecialValueFor("bonus_mana_regen")
	self.mana_regen_multiplier		= self.ability:GetSpecialValueFor("mana_regen_multiplier")
	self.regen_per_charge			= self.ability:GetSpecialValueFor("regen_per_charge")
	self.death_charges				= self.ability:GetSpecialValueFor("death_charges")
	self.kill_charges				= self.ability:GetSpecialValueFor("kill_charges")
	self.charge_range				= self.ability:GetSpecialValueFor("charge_range")
	self.initial_charges_tooltip	= self.ability:GetSpecialValueFor("initial_charges_tooltip")
	-- self.mana_cost_percentage		= self.ability:GetSpecialValueFor("mana_cost_percentage")
	-- self.restore_duration			= self.ability:GetSpecialValueFor("restore_duration")
	
	if not IsServer() then return end
	
	-- Need to do this instead of using the "ItemInitialCharges" KV because the latter messes with sell prices
	if not self.ability.initialized then
		self.ability:SetCurrentCharges(self.initial_charges_tooltip)
		self.ability.initialized = true
	end
	
	self:SetStackCount(self.ability:GetCurrentCharges())
end

function modifier_item_imba_bloodstone_720:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH 
    }
    return decFuncs
end

function modifier_item_imba_bloodstone_720:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_bloodstone_720:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_imba_bloodstone_720:GetModifierConstantHealthRegen()
	return self.bonus_health_regen + (self.regen_per_charge * self:GetStackCount())
end

function modifier_item_imba_bloodstone_720:GetModifierConstantManaRegen()
	return self.bonus_mana_regen + (self.regen_per_charge * self:GetStackCount())
end

function modifier_item_imba_bloodstone_720:GetModifierTotalPercentageManaRegen()
	return (self.mana_regen_multiplier - 100) / 100
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
