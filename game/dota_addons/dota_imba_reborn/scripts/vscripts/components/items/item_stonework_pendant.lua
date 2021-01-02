-- Main logic taken from Valve's Slitbreaker dungeon files

-- Reformatted for DotA IMBA by:
-- 	AltiV - March 15th, 2019

item_imba_stonework_pendant = class({})
LinkLuaModifier( "modifier_item_imba_stonework_pendant", "components/items/item_stonework_pendant", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_imba_stonework_pendant:GetIntrinsicModifierName()
	return "modifier_item_imba_stonework_pendant"
end

--------------------------------------------------------------------------------

-- function item_imba_stonework_pendant:Spawn()
	-- self.required_level = self:GetSpecialValueFor( "required_level" )
-- end

--------------------------------------------------------------------------------

-- function item_imba_stonework_pendant:OnHeroLevelUp()
	-- if IsServer() then
		-- if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			-- self:OnUnequip()
			-- self:OnEquip()
		-- end
	-- end
-- end

--------------------------------------------------------------------------------

-- function item_imba_stonework_pendant:IsMuted()	
	-- if self.required_level > self:GetCaster():GetLevel() then
		-- return true
	-- end
	-- if not self:GetCaster():IsHero() then
		-- return true
	-- end
	-- return self.BaseClass.IsMuted( self )
-- end

---

modifier_item_imba_stonework_pendant = class({})

------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:IsPurgable()
	return false
end

function modifier_item_imba_stonework_pendant:RemoveOnDeath()	return false end
function modifier_item_imba_stonework_pendant:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

----------------------------------------

function modifier_item_imba_stonework_pendant:OnCreated( kv )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.spell_lifesteal 	= self:GetAbility():GetSpecialValueFor( "spell_lifesteal" )
	self.mana_to_hp_pct	= (100 + self:GetAbility():GetSpecialValueFor("mana_to_hp_pct")) / 100
	self.mana_to_hp_damage	= self:GetAbility():GetSpecialValueFor("mana_to_hp_damage")
	
	self.flBonusHP 			= self:GetParent():GetMaxMana() 	* self.mana_to_hp_pct
	self.flBonusHPRegen 	= self:GetParent():GetManaRegen() 	* self.mana_to_hp_pct
	
	self:StartIntervalThink( FrameTime() )
	
	-- Start tracking mana percentages and mana values to determine if mana was lost
	if not IsServer() then return end
	
	self.mana_pct = self:GetParent():GetManaPercent()
	self.mana_raw = self:GetParent():GetMana()
end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:OnIntervalThink()
	self.flBonusHP 			= self:GetParent():GetMaxMana() 	* self.mana_to_hp_pct
	self.flBonusHPRegen 	= self:GetParent():GetManaRegen() 	* self.mana_to_hp_pct
	
	if not IsServer() then return end
	
	-- If mana percentage at any frame is lower than the frame before it, set stacks
	if self:GetParent():GetManaPercent() < self.mana_pct and self:GetParent():GetMana() < self.mana_raw then		
		self:GetParent():SetHealth(math.max(self:GetParent():GetHealth() - (self.mana_raw - self:GetParent():GetMana()) * self.mana_to_hp_damage, 1))
		
		if self:GetParent():GetHealth() <= 1 then
			self:GetParent():Kill(self:GetAbility(), self:GetParent())
		end
		
		self:GetParent():SetMana(math.min(math.max(self.mana_raw, 0), self:GetParent():GetMaxMana()))
	end
		
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()
	
	--self:GetParent():CalculateStatBonus(true)
end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_MANA_BONUS,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:GetModifierHealthBonus( params )
	return self.flBonusHP
end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:GetModifierConstantHealthRegen( params )
	return self.flBonusHPRegen
end

--------------------------------------------------------------------------------

-- function modifier_item_imba_stonework_pendant:GetModifierManaBonus( params )
	-- return -self.flBonusHP
-- end

--------------------------------------------------------------------------------

-- function modifier_item_imba_stonework_pendant:GetModifierConstantManaRegen( params )
	-- if self.flBonusHPRegen then
		-- return -self.flBonusHPRegen
	-- end
-- end

--------------------------------------------------------------------------------

-- function modifier_item_imba_stonework_pendant:OnTakeDamage( params )
	-- if IsServer() then
		-- local Attacker = params.attacker
		-- local Target = params.unit
		-- local Ability = params.inflictor
		-- local flDamage = params.damage

		-- if Attacker ~= self:GetParent() or Ability == nil or Target == nil or Target == self:GetParent() then
			-- return 0
		-- end

		-- if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			-- return 0
		-- end
		-- if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			-- return 0
		-- end

		-- local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		-- ParticleManager:ReleaseParticleIndex( nFXIndex )

		-- local flLifesteal = flDamage * self.spell_lifesteal / 100
		-- Attacker:Heal( flLifesteal, self:GetAbility() )
	-- end
	-- return 0
-- end

--------------------------------------------------------------------------------

-- function modifier_item_imba_stonework_pendant:GetModifierSpellsRequireHP( params )
	-- return self:GetAbility():GetSpecialValueFor("mana_hp_convert_mult")
-- end

--------------------------------------------------------------------------------

function modifier_item_imba_stonework_pendant:GetModifierSpellLifesteal()
	return self.spell_lifesteal
end
