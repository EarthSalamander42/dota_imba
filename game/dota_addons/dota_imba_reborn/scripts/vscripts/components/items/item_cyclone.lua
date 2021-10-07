-- Creator:
-- 	AltiV - November 1st, 2019

LinkLuaModifier("modifier_item_imba_cyclone_2", "components/items/item_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_2_movement", "components/items/item_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_2_thinker", "components/items/item_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_2_thinker_aura", "components/items/item_cyclone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_cyclone_2_disorient", "components/items/item_cyclone", LUA_MODIFIER_MOTION_NONE)

item_imba_cyclone_2							= class({})
modifier_item_imba_cyclone_2				= class({})
modifier_item_imba_cyclone_2_movement		= class({})
modifier_item_imba_cyclone_2_thinker		= class({})
modifier_item_imba_cyclone_2_thinker_aura	= class({})
modifier_item_imba_cyclone_2_disorient		= class({})

-------------------------
-- ITEM_IMBA_CYCLONE_2 --
-------------------------

function item_imba_cyclone_2:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_SUCCESS
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function item_imba_cyclone_2:GetIntrinsicModifierName()
	return "modifier_item_imba_cyclone_2"
end

function item_imba_cyclone_2:OnSpellStart()
	local target = self:GetCursorTarget()
	
	if not target:TriggerSpellAbsorb(self) then
		target:EmitSound("DOTA_Item.Cyclone.Activate")
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_cyclone_2_movement", {duration = self:GetSpecialValueFor("cyclone_duration")})
		target:AddNewModifier(self:GetCaster(), self, "modifier_eul_cyclone", {duration = self:GetSpecialValueFor("cyclone_duration")}):SetDuration(self:GetSpecialValueFor("cyclone_duration"), true)

		if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			target:Purge(true, false, false, false, false)
		else
			target:Purge(false, true, false, false, false)
		end

		for tornado = 1, self:GetSpecialValueFor("tornado_count") do
			CreateModifierThinker(self:GetCaster(), self, "modifier_item_imba_cyclone_2_thinker", 
			{
				duration	= self:GetSpecialValueFor("cyclone_duration")
			}, target:GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, tornado * (360 / self:GetSpecialValueFor("tornado_count")), 0), self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("tornado_spacing")), self:GetCaster():GetTeamNumber(), false)
		end
	end
end

----------------------------------
-- MODIFIER_ITEM_IMBA_CYCLONE_2 --
----------------------------------

function modifier_item_imba_cyclone_2:IsHidden()		return true end
function modifier_item_imba_cyclone_2:IsPurgable()		return false end
function modifier_item_imba_cyclone_2:RemoveOnDeath()	return false end
function modifier_item_imba_cyclone_2:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_cyclone_2:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if self:GetAbility() then
		self.bonus_intellect		= self:GetAbility():GetSpecialValueFor("bonus_intellect")
		self.bonus_mana_regen		= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
		self.bonus_movement_speed	= self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
		self.bonus_spell_amp		= self:GetAbility():GetSpecialValueFor("bonus_spell_amp")
	else
		self.bonus_intellect		= 0
		self.bonus_mana_regen		= 0
		self.bonus_movement_speed	= 0
		self.bonus_spell_amp		= 0
	end
	
	if not IsServer() then return end
	
    -- Use Secondary Charges system to make mana loss reduction and CDR not stack with multiples
    for _, mod in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
        mod:GetAbility():SetSecondaryCharges(_)
    end
end

function modifier_item_imba_cyclone_2:OnDestroy()
	if not IsServer() then return end
	
	for _, modifier in pairs(self:GetParent():FindAllModifiersByName(self:GetName())) do
		modifier:SetStackCount(_)
		modifier:GetAbility():SetSecondaryCharges(_)
	end
end

-- Declare modifier events/properties
function modifier_item_imba_cyclone_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_item_imba_cyclone_2:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_imba_cyclone_2:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end

function modifier_item_imba_cyclone_2:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed
end

-- As of 7.23, the items that Nether Wand's tree contains are as follows:
--   - Nether Wand
--   - Aether Lens
--   - Aether Specs
--   - Eul's Scepter of Divinity EX
--   - Armlet of Dementor
--   - Arcane Nexus
function modifier_item_imba_cyclone_2:GetModifierSpellAmplify_Percentage()
	if self:GetAbility():GetSecondaryCharges() == 1 and 
	not self:GetParent():HasModifier("modifier_item_imba_armlet_of_dementor") and
	not self:GetParent():HasModifier("modifier_item_imba_arcane_nexus_passive") then
        return self.bonus_spell_amp
    end
end

-------------------------------------------
-- MODIFIER_ITEM_IMBA_CYCLONE_2_MOVEMENT --
-------------------------------------------

function modifier_item_imba_cyclone_2_movement:IsHidden()		return true end
function modifier_item_imba_cyclone_2_movement:IgnoreTenacity()	return true end

function modifier_item_imba_cyclone_2_movement:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.tornado_aura_duration	= self:GetAbility():GetSpecialValueFor("tornado_aura_duration")
	self.disorient_duration		= self:GetAbility():GetSpecialValueFor("disorient_duration")
	self.displacement_distance	= self:GetAbility():GetSpecialValueFor("displacement_distance") / self:GetDuration()

	if not IsServer() then return end

	self.interval		= FrameTime()
	-- self.angle			= RandomVector(1)
	self.angle			= self:GetParent():GetForwardVector()
	self.rotation		= (360 / self:GetDuration()) * self:GetAbility():GetSpecialValueFor("tornado_self_rotations")
	
	-- if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		-- self:StartIntervalThink(FrameTime())
	-- end
end

-- function modifier_item_imba_cyclone_2_movement:OnIntervalThink()
	-- self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + self.angle * self:GetElapsedTime() * self.displacement_distance)
	
	-- self.angle	= RotatePosition(Vector(0, 0, 0), QAngle(0, self.interval * self.rotation, 0), self.angle)
-- end

function modifier_item_imba_cyclone_2_movement:OnDestroy()
	if not IsServer() then return end

	-- -- To prevent projectiles that were swirling around with Violent Displacement to land at the end
	-- ProjectileManager:ProjectileDodge(self:GetParent())
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
	
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_cyclone_2_disorient", {duration = self.disorient_duration})
	end
end


------------------------------------------
-- MODIFIER_ITEM_IMBA_CYCLONE_2_THINKER --
------------------------------------------

function modifier_item_imba_cyclone_2_thinker:GetEffectName()
	return self.effect
end

function modifier_item_imba_cyclone_2_thinker:OnCreated(params)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.effect_table = {
		"particles/econ/events/ti5/cyclone_ti5.vpcf",
		"particles/econ/events/ti6/cyclone_ti6.vpcf",
		"particles/econ/events/fall_major_2016/cyclone_fm06.vpcf",
		"particles/econ/events/ti7/cyclone_ti7.vpcf",
		"particles/econ/events/winter_major_2017/cyclone_wm07.vpcf",
		"particles/econ/events/ti8/cyclone_ti8.vpcf",
		"particles/econ/events/ti9/cyclone_ti9.vpcf",
	}
	
	self.effect = self.effect_table[RandomInt(1, #self.effect_table)]
	
	self.tornado_radius			= self:GetAbility():GetSpecialValueFor("tornado_radius")
	self.tornado_aura_duration	= self:GetAbility():GetSpecialValueFor("tornado_aura_duration")
end

function modifier_item_imba_cyclone_2_thinker:IsAura()					return true end
function modifier_item_imba_cyclone_2_thinker:IsAuraActiveOnDeath()		return true end

function modifier_item_imba_cyclone_2_thinker:GetAuraRadius()			return self.tornado_radius end
function modifier_item_imba_cyclone_2_thinker:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_imba_cyclone_2_thinker:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_imba_cyclone_2_thinker:GetAuraDuration()			return self.tornado_aura_duration end

function modifier_item_imba_cyclone_2_thinker:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_imba_cyclone_2_thinker:GetModifierAura()			return "modifier_item_imba_cyclone_2_thinker_aura" end
function modifier_item_imba_cyclone_2_thinker:GetAuraEntityReject(hEntity)	return hEntity:HasModifier("modifier_item_imba_cyclone_2_disorient") end

-----------------------------------------------
-- MODIFIER_ITEM_IMBA_CYCLONE_2_THINKER_AURA --
-----------------------------------------------

function modifier_item_imba_cyclone_2_thinker_aura:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_cyclone_2_thinker_aura:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.tornado_pull_speed	= self:GetAbility():GetSpecialValueFor("tornado_pull_speed")

	if not IsServer() then return end
	
	self.owner_origin	= self:GetAuraOwner():GetAbsOrigin()
	self.interval		= FrameTime()
	
	self:StartIntervalThink(self.interval)
end

function modifier_item_imba_cyclone_2_thinker_aura:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin() + (self.owner_origin - self:GetParent():GetAbsOrigin()):Normalized() * self.interval * self.tornado_pull_speed)
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

function modifier_item_imba_cyclone_2_thinker_aura:CheckState()
	return {[MODIFIER_STATE_TETHERED] = true}
end

--------------------------------------------
-- MODIFIER_ITEM_IMBA_CYCLONE_2_DISORIENT --
--------------------------------------------

function modifier_item_imba_cyclone_2_disorient:IgnoreTenacity()	return true end
function modifier_item_imba_cyclone_2_disorient:IsPurgable()		return false end

function modifier_item_imba_cyclone_2_disorient:GetStatusEffectName()
	return "particles/status_fx/status_effect_abaddon_frostmourne.vpcf"
end

function modifier_item_imba_cyclone_2_disorient:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.disorient_status_resistance	= self:GetAbility():GetSpecialValueFor("disorient_status_resistance") * (-1)
end

function modifier_item_imba_cyclone_2_disorient:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING}
end

function modifier_item_imba_cyclone_2_disorient:GetModifierStatusResistanceStacking()
	return self.disorient_status_resistance
end
