-- Main logic taken from Valve's Slitbreaker dungeon files

-- Reformatted for DotA IMBA by:
-- 	AltiV - March 15th, 2019

----------------------------
-- WAND OF THE BRINE FILE --
----------------------------

item_imba_wand_of_the_brine = class({})
LinkLuaModifier( "modifier_item_imba_wand_of_the_brine", "components/items/item_wand_of_the_brine", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_imba_wand_of_the_brine_bubble", "components/items/item_wand_of_the_brine", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function item_imba_wand_of_the_brine:OnSpellStart()
	if IsServer() then
		self.bubble_duration = self:GetSpecialValueFor( "bubble_duration" )

		local hTarget = self:GetCursorTarget()
		
		hTarget:AddNewModifier( self:GetCaster(), self, "modifier_item_imba_wand_of_the_brine_bubble", { duration = self.bubble_duration } )
		
		hTarget:Purge(false, true, false, true, true)

		EmitSoundOn( "DOTA_Item.GhostScepter.Activate", self:GetCaster() )
	end
end

--------------------------------------------------------------------------------

function item_imba_wand_of_the_brine:GetIntrinsicModifierName()
	return "modifier_item_imba_wand_of_the_brine"
end

--------------------------------------------------------------------------------

-- function item_imba_wand_of_the_brine:Spawn()
	-- self.required_level = self:GetSpecialValueFor( "required_level" )
-- end

--------------------------------------------------------------------------------

-- function item_imba_wand_of_the_brine:OnHeroLevelUp()
	-- if IsServer() then
		-- if self:GetCaster():GetLevel() == self.required_level and self:IsInBackpack() == false then
			-- self:OnUnequip()
			-- self:OnEquip()
		-- end
	-- end
-- end

--------------------------------------------------------------------------------

-- function item_imba_wand_of_the_brine:IsMuted()	
	-- if self.required_level > self:GetCaster():GetLevel() then
		-- return true
	-- end
	-- if not self:GetCaster():IsHero() then
		-- return true
	-- end
	
	-- return self.BaseClass.IsMuted( self )
-- end

---------------------------------------
-- WAND OF THE BRINE BUBBLE MODIFIER --
---------------------------------------

modifier_item_imba_wand_of_the_brine_bubble = class({})

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine_bubble:OnCreated( kv )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		self.bubble_heal_per_tick = self:GetAbility():GetSpecialValueFor( "bubble_heal_per_tick" )
		self.heal_tick_interval = self:GetAbility():GetSpecialValueFor( "heal_tick_interval" )

		self.nFXIndex = ParticleManager:CreateParticle( "particles/item/wand_of_the_brine/wand_of_the_brine_bubble.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector( 2.5, 2.5, 2.5 ) ) -- target model scale
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
		--ParticleManager:SetParticleControlEnt( self.nFXIndex, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )

		self:StartIntervalThink( self.heal_tick_interval )
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine_bubble:OnIntervalThink()
	if IsServer() then
		self:GetParent():Heal( self.bubble_heal_per_tick, self:GetAbility() )
		
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.bubble_heal_per_tick, nil);
	end
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine_bubble:CheckState()
	local state = {}
	if IsServer()  then
		state[ MODIFIER_STATE_STUNNED]  = true
		state[ MODIFIER_STATE_ROOTED ] = true
		state[ MODIFIER_STATE_DISARMED] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_MAGIC_IMMUNE ] = true
		state[ MODIFIER_STATE_INVULNERABLE ] = true
		state[ MODIFIER_STATE_OUT_OF_GAME ] = true
		state[ MODIFIER_STATE_UNSELECTABLE ] = true
		state[ MODIFIER_STATE_NO_HEALTH_BAR ] = true -- This is extraneuous but seems appropriate
	end

	return state
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine_bubble:OnDestroy()
	if IsServer()  then
		ParticleManager:DestroyParticle( self.nFXIndex, false )
	end
end

--------------------------------------------------------------------------------

--------------------------------
-- WAND OF THE BRINE MODIFIER --
--------------------------------

modifier_item_imba_wand_of_the_brine = class({})

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine:IsHidden() 
	return true
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine:IsPurgable()
	return false
end

function modifier_item_imba_wand_of_the_brine:RemoveOnDeath()	return false end
function modifier_item_imba_wand_of_the_brine:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine:OnCreated( kv )
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.bonus_intelligence = self:GetAbility():GetSpecialValueFor( "bonus_intelligence" )
	self.bonus_mana_regen_pct = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen_pct" )
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		--MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_imba_wand_of_the_brine:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end 

--------------------------------------------------------------------------------

--function modifier_item_imba_wand_of_the_brine:GetModifierPercentageManaRegen( params )
function modifier_item_imba_wand_of_the_brine:GetModifierTotalPercentageManaRegen( params )
	return (self.bonus_mana_regen_pct - 100) / 100
end 

--------------------------------------------------------------------------------
