-- Creator:
-- 	AltiV - June 8th, 2019

LinkLuaModifier("modifier_item_imba_nullifier", "components/items/item_nullifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_nullifier_mute", "components/items/item_nullifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_nullifier_slow", "components/items/item_nullifier", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_nullifier_shudder", "components/items/item_nullifier", LUA_MODIFIER_MOTION_NONE)

item_imba_nullifier						= class({})
modifier_item_imba_nullifier			= class({})
modifier_item_imba_nullifier_mute		= class({})
modifier_item_imba_nullifier_slow		= class({})
modifier_item_imba_nullifier_shudder	= class({})

item_imba_nullifier_2					= item_imba_nullifier

--------------------
-- NULLIFIER BASE --
--------------------

function item_imba_nullifier:GetIntrinsicModifierName()
	return "modifier_item_imba_nullifier"
end

function item_imba_nullifier:OnSpellStart()
	-- This is just to save the variable so Shudder doesn't affect the direct target (yes I know it still messes up if you refresh and cast again while projectile is already flying)
	self.target	= self:GetCursorTarget()
	
	-- Play the cast sound
	self:GetCaster():EmitSound("DOTA_Item.Nullifier.Cast")

	local effectName = "particles/items4_fx/nullifier_proj.vpcf"
	
	if self:GetLevel() == 2 then
		effectName = "particles/items4_fx/nullifier_proj_2.vpcf"
	end

	-- Create the projectile
	local projectile =
		{
			Target 				= self:GetCursorTarget(),
			Source 				= self:GetCaster(),
			Ability 			= self,
			EffectName 			= effectName,
			iMoveSpeed			= self:GetSpecialValueFor("projectile_speed"),
			vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10,
			bProvidesVision 	= false,
		}
		
	ProjectileManager:CreateTrackingProjectile(projectile)
end

-- IMBAfication: Shudder
function item_imba_nullifier:OnProjectileThink(location)
	if self:GetLevel() >= 2 then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("shudder_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _, enemy in pairs(enemies) do
			if enemy ~= self.target and not enemy:HasModifier("modifier_item_imba_nullifier_shudder") then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_nullifier_shudder", {duration = self:GetSpecialValueFor("shudder_duration")}):SetDuration(self:GetSpecialValueFor("shudder_duration") * (1 - enemy:GetStatusResistance()), true)
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_nullifier_slow", {duration = self:GetSpecialValueFor("shudder_duration")}):SetDuration(self:GetSpecialValueFor("shudder_duration") * (1 - enemy:GetStatusResistance()), true)
			end
		end
	end
end

function item_imba_nullifier:OnProjectileHit(target, location)
	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then
			-- Check for Linken's / Lotus Orb
		if target:TriggerSpellAbsorb(self) then return nil end

		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.Nullifier.Target")
		
		-- ..and apply the purge, mute modifier, and slow modifier
		target:Purge(true, false, false, false, false)
		target:AddNewModifier(self:GetCaster(), self, "modifier_item_imba_nullifier_mute", {duration = self:GetSpecialValueFor("mute_duration")}):SetDuration(self:GetSpecialValueFor("mute_duration") * (1 - target:GetStatusResistance()), true)
		
		if self:GetLevel() >= 2 then
			-- IMBAfication: Objection Index
			
			-- First, determine what slot Nullifier EX is in
			local nullifier_slot = nil
			
			for itemSlot = 0, 5 do
				if self:GetCaster():GetItemInSlot(itemSlot) == self then
					nullifier_slot = itemSlot
					break
				end
			end
			
			-- If Nullifier was in a slot (aka logic ends if item is out of inventory or in stash when projectile lands)
			if nullifier_slot then
				if target:GetItemInSlot(nullifier_slot) then
					target:SwapItems(nullifier_slot, 8)
					target:SwapItems(nullifier_slot, 8)
				end
				
				if target:GetItemInSlot((nullifier_slot + 1) % 6) then
					target:SwapItems((nullifier_slot + 1) % 6, 8)
					target:SwapItems((nullifier_slot + 1) % 6, 8)
				end
			end
		end
	end
	
	self.target = nil
end


------------------------
-- NULLIFIER MODIFIER --
------------------------

function modifier_item_imba_nullifier:IsHidden()		return true end
function modifier_item_imba_nullifier:IsPermanent()	return true end
function modifier_item_imba_nullifier:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_nullifier:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.bonus_damage	=	self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_armor	=	self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_regen	=	self:GetAbility():GetSpecialValueFor("bonus_regen")
	self.bonus_health	=	self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana		=	self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function modifier_item_imba_nullifier:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS, 
		MODIFIER_PROPERTY_MANA_BONUS 
    }
	
    return decFuncs
end

function modifier_item_imba_nullifier:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_imba_nullifier:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_imba_nullifier:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

function modifier_item_imba_nullifier:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_imba_nullifier:GetModifierManaBonus()
	return self.bonus_mana
end

-----------------------------
-- NULLIFIER MUTE MODIFIER --
-----------------------------

function modifier_item_imba_nullifier_mute:GetEffectName()
	if (self:GetAbility() and self:GetAbility():GetLevel() == 2) or self.level == 2 then
		return "particles/items4_fx/nullifier_mute_debuff_2.vpcf"
	else
		return "particles/items4_fx/nullifier_mute_debuff.vpcf"
	end
end

function modifier_item_imba_nullifier_mute:GetStatusEffectName()
	return "particles/status_fx/status_effect_nullifier.vpcf"
end

function modifier_item_imba_nullifier_mute:OnCreated()
	self.level	= self:GetAbility():GetLevel()

	if self:GetAbility() then
		self.slow_interval_duration = self:GetAbility():GetSpecialValueFor("slow_interval_duration")
	else
		self:Destroy()
		return
	end

	if not IsServer() then return end

	local overhead_particle = "particles/items4_fx/nullifier_mute.vpcf"

	if (self:GetAbility() and self:GetAbility():GetLevel() == 2) or self.level == 2 then
		overhead_particle = "particles/items4_fx/nullifier_mute_2.vpcf"
	end

	local overhead_particle = ParticleManager:CreateParticle(overhead_particle, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(overhead_particle, false, false, -1, false, false)
	
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_nullifier_slow", {duration = self.slow_interval_duration}):SetDuration(self.slow_interval_duration * (1 - self:GetParent():GetStatusResistance()), true)
end

function modifier_item_imba_nullifier_mute:CheckState()
	local state = {
	[MODIFIER_STATE_MUTED] = true
	}

	return state
end

function modifier_item_imba_nullifier_mute:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	
    return decFuncs
end

function modifier_item_imba_nullifier_mute:OnAttackLanded(keys)
	if not IsServer() then return end
	
	if keys.target == self:GetParent() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_nullifier_slow", {duration = self.slow_interval_duration}):SetDuration(self.slow_interval_duration * (1 - self:GetParent():GetStatusResistance()), true)
	end	
end

-----------------------------
-- NULLIFIER SLOW MODIFIER --
-----------------------------

function modifier_item_imba_nullifier_mute:GetStatusEffectName()
	return "particles/status_fx/status_effect_nullifier_slow.vpcf"
end

function modifier_item_imba_nullifier_slow:OnCreated()
	self.slow_pct	= 0
	
	if self:GetAbility() then
		self.slow_pct	= self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
	end
	
	if not IsServer() then return end
	
	self:GetParent():EmitSound("DOTA_Item.Nullifier.Slow")
end

function modifier_item_imba_nullifier_slow:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
	
    return decFuncs
end

-- Based on vanilla testing, the 100% slow modifier applies but doesn't slow if the item doesn't exist (i.e. you destroy it)
function modifier_item_imba_nullifier_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct
end

--------------------------------
-- NULLIFIER SHUDDER MODIFIER --
--------------------------------

function modifier_item_imba_nullifier_shudder:CheckState()
	local state = {
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}

	return state
end
