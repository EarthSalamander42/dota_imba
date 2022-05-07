-- Creator:
-- 	AltiV - January 21st, 2020

LinkLuaModifier("modifier_item_imba_banana", "components/items/item_banana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_banana_thinker", "components/items/item_banana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_banana_thinker_aura", "components/items/item_banana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_banana_stun", "components/items/item_banana", LUA_MODIFIER_MOTION_NONE)

item_imba_banana						= class({}) 
modifier_item_imba_banana				= class({})
modifier_item_imba_banana_thinker		= class({})
modifier_item_imba_banana_thinker_aura	= class({})
modifier_item_imba_banana_stun			= class({})

----------------------
-- ITEM_IMBA_BANANA --
----------------------

function item_imba_banana:OnSpellStart()
	self:GetCursorTarget():EmitSound("DOTA_Imba_Item.Banana.Cast")

	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_banana", {})
	
	if self:GetCursorTarget():CalculateStatBonus(true) then
		self:GetCursorTarget():CalculateStatBonus(true)
	end
	
	-- if self:GetCursorTarget() == self:GetCaster() then
		CreateModifierThinker(self:GetCaster(), self, "modifier_item_imba_banana_thinker", {duration = self:GetSpecialValueFor("banana_duration")}, self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * (-1) * self:GetSpecialValueFor("banana_drop_distance")), self:GetCaster():GetTeamNumber(), false)
	-- end
	
	self:SetCurrentCharges(math.max(self:GetCurrentCharges() - 1, 0))	
	
	if self:GetCurrentCharges() <= 0 then
		self:Destroy()
	end
end

-------------------------------
-- MODIFIER_ITEM_IMBA_BANANA --
-------------------------------

function modifier_item_imba_banana:IsPurgable()		return false end
function modifier_item_imba_banana:RemoveOnDeath()	return false end

function modifier_item_imba_banana:GetTexture()
	return "item_banana"
end

function modifier_item_imba_banana:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if self:GetAbility() then
		self.int_gain	= self:GetAbility():GetSpecialValueFor("int_gain")
	else
		self.int_gain	= 4
	end
	
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_item_imba_banana:OnRefresh()
	self:OnCreated()
end

function modifier_item_imba_banana:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS}
end

function modifier_item_imba_banana:GetModifierBonusStats_Intellect()
	return self.int_gain * self:GetStackCount()
end

---------------------------------------
-- MODIFIER_ITEM_IMBA_BANANA_THINKER --
---------------------------------------

function modifier_item_imba_banana_thinker:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.banana_peel_radius		= self:GetAbility():GetSpecialValueFor("banana_peel_radius")
	self.banana_flying_vision	= self:GetAbility():GetSpecialValueFor("banana_flying_vision")
	
	if not IsServer() then return end
	
	self.think_interval			= 1
	
	self:StartIntervalThink(self.think_interval)
end

function modifier_item_imba_banana_thinker:OnIntervalThink()
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.banana_flying_vision, self.think_interval, false)
end

function modifier_item_imba_banana_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}
end

function modifier_item_imba_banana_thinker:GetModifierModelChange()
	return "models/props_gameplay/banana_prop_open.vmdl"
end

function modifier_item_imba_banana_thinker:IsHidden()					return true end

function modifier_item_imba_banana_thinker:IsAura()						return true end
function modifier_item_imba_banana_thinker:IsAuraActiveOnDeath() 		return false end

function modifier_item_imba_banana_thinker:GetAuraDuration()			return 0.1 end
function modifier_item_imba_banana_thinker:GetAuraRadius()				return self.banana_peel_radius end
function modifier_item_imba_banana_thinker:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end

function modifier_item_imba_banana_thinker:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_imba_banana_thinker:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_banana_thinker:GetModifierAura()			return "modifier_item_imba_banana_thinker_aura" end

function modifier_item_imba_banana_thinker:GetAuraEntityReject(hTarget)	return hTarget:HasModifier("modifier_item_imba_banana_stun") end

--------------------------------------------
-- MODIFIER_ITEM_IMBA_BANANA_THINKER_AURA --
--------------------------------------------

function modifier_item_imba_banana_thinker_aura:IsHidden()	return true end

function modifier_item_imba_banana_thinker_aura:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_banana_stun", {duration = 1})
	self:GetAuraOwner():AddNoDraw()
	self:GetAuraOwner():ForceKill(false)
end

------------------------------------
-- MODIFIER_ITEM_IMBA_BANANA_STUN --
------------------------------------

function modifier_item_imba_banana_stun:IgnoreTenacity()	return true end

function modifier_item_imba_banana_stun:GetTexture()
	return "item_banana"
end

-- Due to the ability probably not existing when this modifier would apply, I'm just going to hard-code the values here
function modifier_item_imba_banana_stun:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	if not IsServer() then return end
	
	self.banana_slide_duration		= 1
	self.banana_peel_radius			= 100
	self.banana_slide_distance		= 400
	self.banana_directional_changes	= 4
	
	self.counter	= 0
	self.change_time	= self.banana_slide_duration / self.banana_directional_changes
	self.interval	= FrameTime()
	
	self.direction	= RandomVector(1)
	
	self:GetParent():EmitSound("DOTA_Imba_Item.Banana.Slip")
	
	self:StartIntervalThink(FrameTime())
end

function modifier_item_imba_banana_stun:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + (self.direction * self.interval * self.banana_slide_distance))

	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.banana_peel_radius, true)

	self.counter	= self.counter + self.interval
	
	if self.counter >= self.change_time then
		self.direction	= RandomVector(1)
		self.counter	= 0
	end
end

function modifier_item_imba_banana_stun:OnDestroy()
	if not IsServer() then return end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

function modifier_item_imba_banana_stun:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_item_imba_banana_stun:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_item_imba_banana_stun:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
