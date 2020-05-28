item_imba_clarity = item_imba_clarity or class({})

LinkLuaModifier("modifier_imba_clarity", "components/items/item_clarity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_clarity_mana_reserves", "components/items/item_clarity", LUA_MODIFIER_MOTION_NONE)

----------------
--  CLARITY   --
----------------

function item_imba_clarity:OnSpellStart() 
	-- Ability properties
	local caster = self:GetCaster() 
	local ability = self
	local target = self:GetCursorTarget() 
	local cast_sound = "DOTA_Item.ClarityPotion.Activate"
	local modifier_regen = "modifier_imba_clarity"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")

	-- Emit sound
	EmitSoundOn(cast_sound, target) 

	-- Give the target the modifier
	target:AddNewModifier(caster, ability, modifier_regen, {duration = duration})

	-- Reduce a charge, or destroy the item if no charges are left
	ability:SpendCharge()
end


----------------------------------
-- CLARITY MANA REGEN MODIFIER  --
----------------------------------

modifier_imba_clarity = modifier_imba_clarity or class({})

function modifier_imba_clarity:IsHidden() return false end
function modifier_imba_clarity:IsDebuff() return false end
function modifier_imba_clarity:IsPurgable() return true end

function modifier_imba_clarity:GetTexture()
	return "item_clarity"
end

function modifier_imba_clarity:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster() 
	self.ability = self:GetAbility()
	self.parent = self:GetParent()	
	self.modifier_mana_reserves = "modifier_imba_clarity_mana_reserves"

	-- Ability specials
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
	self.vision_increase = self.ability:GetSpecialValueFor("vision_increase")
	self.cast_range_increase = self.ability:GetSpecialValueFor("cast_range_increase")	
	self.mana_reserves_duration = self.ability:GetSpecialValueFor("mana_reserves_duration")

	-- Write to parent so the modifier info could be drawn clientside
	self.parent.item_clarity_mana_reserves_mana = self.ability:GetSpecialValueFor("mana_reserves_mana")
	self.parent.item_clarity_max_mana_bonus = self.ability:GetSpecialValueFor("max_mana_bonus")	
end

function modifier_imba_clarity:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
					 MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
					 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_EVENT_ON_TAKEDAMAGE} 
	return decFuncs
end

function modifier_imba_clarity:GetModifierConstantManaRegen()
	return self.mana_regen
end

function modifier_imba_clarity:GetModifierCastRangeBonusStacking()
	return self.cast_range_increase
end

function modifier_imba_clarity:GetBonusDayVision()
	return self.vision_increase
end

function modifier_imba_clarity:GetBonusNightVision()
	return self.vision_increase
end

function modifier_imba_clarity:GetEffectName()
	return "particles/items_fx/healing_clarity.vpcf"
end

function modifier_imba_clarity:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function  modifier_imba_clarity:OnTakeDamage(keys)
	if not IsServer() then return nil end
	
	local attacker = keys.attacker
	local target = keys.unit
	local damage = keys.original_damage
	local damage_flags = keys.damage_flags

	-- Do nothing if the target isn't the parent
	if target ~= self.parent then
		return nil
	end

	-- Do nothing if damage is 0
	if damage <= 0 then 
		return nil
	end

	-- Do nothing if the source of the damage is the modifier bearer himself
	if attacker == self.parent then
	 	return nil
	end

	-- Do nothing if the source of the damage is flagged as HP removal
	if damage_flags == DOTA_DAMAGE_FLAG_HPLOSS then
		return nil
	end

	-- Check if the source of the damage is a player controlled unit/hero, or Roshan	
	if (attacker:GetTeamNumber() == target:GetOpposingTeamNumber() and attacker:IsHero()) or (attacker:GetTeamNumber() == target:GetOpposingTeamNumber() and attacker:GetPlayerOwner() ~= nil) or attacker:GetTeamNumber() == target:GetTeamNumber() or attacker:IsRoshan() then
		-- On valid damage taken, destroy this modifier		
		self:Destroy() 
	end
end

function modifier_imba_clarity:OnDestroy()
	if IsServer() then
		if self.parent:IsAlive() then
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_mana_reserves, {duration = self.mana_reserves_duration}) 		
		end
	end
end


-------------------------------------
-- CLARITY MANA RESERVES MODIFIER  --
-------------------------------------


modifier_imba_clarity_mana_reserves = modifier_imba_clarity_mana_reserves or class({})

function modifier_imba_clarity_mana_reserves:IsHidden() return false end
function modifier_imba_clarity_mana_reserves:IsDebuff() return false end
function modifier_imba_clarity_mana_reserves:IsPurgable() return true end

function modifier_imba_clarity_mana_reserves:GetTexture()
	return "item_clarity"
end

function modifier_imba_clarity_mana_reserves:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	-- Ability properties	
	self.parent = self:GetParent()		

	-- Take information from parent and remove it
	self.mana_reserves_mana = self.parent.item_clarity_mana_reserves_mana
	self.max_mana_bonus = self.parent.item_clarity_max_mana_bonus
	self.parent.item_clarity_mana_reserves_mana = nil
	self.parent.item_clarity_max_mana_bonus = nil

	if IsServer() then

		-- Wait a frame, then give the unit mana
		-- This needs to be done in this way in order to give the unit the mana, otherwise it will only get a percentage increase
		Timers:CreateTimer(FrameTime(), function()
			self.parent:GiveMana(self.mana_reserves_mana)
		end)
	end
end

function modifier_imba_clarity_mana_reserves:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_EXTRA_MANA_BONUS}

	return decFuncs
end

function modifier_imba_clarity_mana_reserves:GetModifierExtraManaBonus()
	return self.max_mana_bonus
end