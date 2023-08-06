-- Creator:
-- 	AltiV - October 30th, 2019

LinkLuaModifier("modifier_item_imba_valiance", "components/items/item_valiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_valiance_guard", "components/items/item_valiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_valiance_counter", "components/items/item_valiance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_valiance_dash", "components/items/item_valiance", LUA_MODIFIER_MOTION_HORIZONTAL)

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

item_imba_valiance						= class({}) 
modifier_item_imba_valiance				= class({})
modifier_item_imba_valiance_guard		= class({})
modifier_item_imba_valiance_counter		= class({})
modifier_item_imba_valiance_dash		= class({})

------------------------
-- ITEM_IMBA_VALIANCE --
------------------------

function item_imba_valiance:GetIntrinsicModifierName()
	return "modifier_item_imba_valiance"
end

function item_imba_valiance:GetAbilityTextureName()
	if not self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") then
		return "item_valiance"
	else
		return "item_valiance_counter"
	end
end

function item_imba_valiance:GetBehavior()
	if not self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") and not self:GetCaster():HasModifier("modifier_item_imba_valiance_guard") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_POINT
	end
end

-- function item_imba_valiance:GetCastPoint()
	-- if self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") or self:GetCaster():HasModifier("modifier_item_imba_valiance_guard") then
		-- return self:GetSpecialValueFor("counter_castpoint")
	-- end
-- end

function item_imba_valiance:GetCastRange(location, target)
	if self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") or self:GetCaster():HasModifier("modifier_item_imba_valiance_guard") then
		return self:GetSpecialValueFor("counter_cast_range")
	end
end

function item_imba_valiance:GetCooldown(level)
	if IsClient() or not self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") then
		return self.BaseClass.GetCooldown(self, level)
	elseif self.FindModifierByName and self:FindModifierByName("modifier_item_imba_valiance_counter").GetElapsedTime then
		return self.BaseClass.GetCooldown(self, level) - self:FindModifierByName("modifier_item_imba_valiance_counter"):GetElapsedTime()
	end
end

function item_imba_valiance:GetManaCost(level)
	if self:GetCaster() and self:GetCaster().HasModifier and not self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") then
		return self.BaseClass.GetManaCost(self, level)
	else
		return self:GetSpecialValueFor("counter_mana_cost")
	end
end

function item_imba_valiance:CastFilterResultLocation(vLocation)
	if not self:GetCaster():IsRooted() or (self:GetCaster():IsRooted() and (vLocation - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetSpecialValueFor("counter_distance")) then
		return UF_SUCCESS
	else
		return UF_FAIL_OTHER
	end
end

function item_imba_valiance:OnAbilityPhaseStart()
	if self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") or self:GetCaster():HasModifier("modifier_item_imba_valiance_guard") then
		self:SetOverrideCastPoint(self:GetSpecialValueFor("counter_castpoint"))
	else
		self:SetOverrideCastPoint(0)
	end

	return true
end

function item_imba_valiance:OnSpellStart()
	if not self:GetCaster():HasModifier("modifier_item_imba_valiance_counter") then
		self:GetCaster():EmitSound("Valiance.Cast")
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_valiance_guard", {duration = self:GetSpecialValueFor("guard_duration")})
	else
		self:GetCaster():EmitSound("Valiance.Dash")
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_imba_valiance_dash", {
			duration		= math.max(((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D() - self:GetSpecialValueFor("counter_distance")) / self:GetSpecialValueFor("counter_dash_speed"), 0),
			damage_counter	= self:GetCaster():FindModifierByName("modifier_item_imba_valiance_counter").damage_counter
		})
		
		self:GetCaster():FindModifierByName("modifier_item_imba_valiance_counter"):Destroy()
	end
end

---------------------------------
-- MODIFIER_ITEM_IMBA_VALIANCE --
---------------------------------

function modifier_item_imba_valiance:IsHidden()		return true end
function modifier_item_imba_valiance:IsPurgable()		return false end
function modifier_item_imba_valiance:RemoveOnDeath()	return false end
function modifier_item_imba_valiance:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Declare modifier events/properties
function modifier_item_imba_valiance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_item_imba_valiance:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_item_imba_valiance:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_item_imba_valiance:GetModifierPhysical_ConstantBlock()
	if self:GetAbility() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("block_chance"), self) then
		if not self:GetParent():IsRangedAttacker() then
			return self:GetAbility():GetSpecialValueFor("block_damage_melee")
		else
			return self:GetAbility():GetSpecialValueFor("block_damage_ranged")
		end
	end
end

---------------------------------------
-- MODIFIER_ITEM_IMBA_VALIANCE_GUARD --
---------------------------------------

function modifier_item_imba_valiance_guard:IsPurgable()	return false end

function modifier_item_imba_valiance_guard:GetTexture()
	return "item_valiance"
end

function modifier_item_imba_valiance_guard:GetStatusEffectName()
	return "particles/status_effect_gold_armor.vpcf"
end

function modifier_item_imba_valiance_guard:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.guard_damage_reduction		= self:GetAbility():GetSpecialValueFor("guard_damage_reduction") * (-1)
	self.guard_angle				= self:GetAbility():GetSpecialValueFor("guard_angle")
	self.guard_status_resistance	= self:GetAbility():GetSpecialValueFor("guard_status_resistance")
	self.counter_duration			= self:GetAbility():GetSpecialValueFor("counter_duration")
	
	if not IsServer() then return end
	
	self.shield_particle = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_golden_reality_rift.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.shield_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(self.shield_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.shield_particle, 2, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100)
	ParticleManager:SetParticleControlForward(self.shield_particle, 2, self:GetParent():GetForwardVector())
	self:AddParticle(self.shield_particle, false, false, -1, false, false)
	
	self.damage_counter	= 0
end

function modifier_item_imba_valiance_guard:OnDestroy()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self:GetAbility():EndCooldown()
		
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_valiance_counter", {
			duration		= self.counter_duration,
			damage_counter	= self.damage_counter
		})
	end
end

function modifier_item_imba_valiance_guard:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_item_imba_valiance_guard:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end


function modifier_item_imba_valiance_guard:GetAbsoluteNoDamagePhysical(keys)
	if keys.attacker and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.guard_angle then
		return 1
	end
end

function modifier_item_imba_valiance_guard:GetAbsoluteNoDamageMagical(keys)
	if keys.attacker and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.guard_angle then
		return 1
	end
end

-- Since the pure function seems to run last when compared to the physical and magical ones above (but before the GetModifierIncomingDamage_Percentage), I guess it makes sense to put the actual logic here? Seems kinda hacky...
function modifier_item_imba_valiance_guard:GetAbsoluteNoDamagePure(keys)
	if keys.attacker and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.guard_angle then
		self.damage_counter = self.damage_counter + keys.original_damage
		self:SetStackCount(self.damage_counter)
		
		return 1
	end
end

-- function modifier_item_imba_valiance_guard:GetModifierIncomingDamage_Percentage(keys)
	-- if keys.attacker and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.guard_angle then
		-- self.damage_counter = self.damage_counter + keys.original_damage
		-- self:SetStackCount(self.damage_counter)
		
		-- return self.guard_damage_reduction
	-- end
-- end

function modifier_item_imba_valiance_guard:GetModifierStatusResistanceStacking()
	return self.guard_status_resistance
end

-----------------------------------------
-- MODIFIER_ITEM_IMBA_VALIANCE_COUNTER --
-----------------------------------------

function modifier_item_imba_valiance_counter:IsPurgable()	return false end

function modifier_item_imba_valiance_counter:GetTexture()
	return "item_valiance_counter"
end

function modifier_item_imba_valiance_counter:OnCreated(params)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end
	
	self.damage_counter	= params.damage_counter
	self:SetStackCount(self.damage_counter)
end

function modifier_item_imba_valiance_counter:OnRemoved()
	if not IsServer() or not self:GetAbility() then return end
	
	self:GetAbility():UseResources(false, false, false, true)
end

function modifier_item_imba_valiance_counter:OnDestroy()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self:GetAbility():UseResources(false, false, false, true)
	end
end

--------------------------------------
-- MODIFIER_ITEM_IMBA_VALIANCE_DASH --
--------------------------------------

function modifier_item_imba_valiance_dash:IsPurgable()	return false end

function modifier_item_imba_valiance_dash:GetStatusEffectName()
	return "particles/status_effect_gold_armor.vpcf"
end

function modifier_item_imba_valiance_dash:OnCreated(params)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end
	
	self.guard_angle				= self:GetAbility():GetSpecialValueFor("guard_angle")
	self.counter_cast_range			= self:GetAbility():GetSpecialValueFor("counter_cast_range")
	self.counter_dash_speed			= self:GetAbility():GetSpecialValueFor("counter_dash_speed")
	self.counter_distance			= self:GetAbility():GetSpecialValueFor("counter_distance")
	self.counter_damage_percent		= self:GetAbility():GetSpecialValueFor("counter_damage_percent")
	self.counter_knockback_distance	= self:GetAbility():GetSpecialValueFor("counter_knockback_distance")
	self.counter_knockback_height	= self:GetAbility():GetSpecialValueFor("counter_knockback_height")
	self.counter_knockback_duration	= self:GetAbility():GetSpecialValueFor("counter_knockback_duration")
	self.counter_tree_radius		= self:GetAbility():GetSpecialValueFor("counter_tree_radius")
	self.counter_stun_threshold		= self:GetAbility():GetSpecialValueFor("counter_stun_threshold")
	
	if not IsServer() then return end
	
	self.damage_counter		= params.damage_counter or 0
	self.cursor_position	= self:GetAbility():GetCursorPosition()
	
	self.velocity		= (self.cursor_position - self:GetParent():GetAbsOrigin()):Normalized() * self.counter_dash_speed

	self:SetStackCount(self.damage_counter)
	self:GetParent():SetForwardVector((self.cursor_position - self:GetParent():GetAbsOrigin()):Normalized())

	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
	end
end

function modifier_item_imba_valiance_dash:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end
	
	me:SetAbsOrigin( me:GetAbsOrigin() + self.velocity * dt )
	me:FaceTowards((self.cursor_position - me:GetAbsOrigin()):Normalized())
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_item_imba_valiance_dash:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_item_imba_valiance_dash:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():InterruptMotionControllers(true)
	
	self:GetParent():SetForwardVector((self.cursor_position - self:GetParent():GetAbsOrigin()):Normalized())
	
	-- TODO: Check that particle matches the damage angle
	self.bash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.bash_particle, 1, Vector(self.counter_distance, self.counter_distance, self.counter_distance))
	-- Gold RGB for particle effect
	ParticleManager:SetParticleControl(self.bash_particle, 60, Vector(212, 175, 37))
	ParticleManager:SetParticleControl(self.bash_particle, 61, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.bash_particle)

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.counter_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if #enemies > 0 then
		self:GetParent():EmitSound("Valiance.Shield.Cast")
		self:GetParent():EmitSound("Valiance.Shield.Crit")
	else
		self:GetParent():EmitSound("Valiance.Shield.Cast.Small")
	end

	for _, enemy in pairs(enemies) do
		if math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.guard_angle then
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_counter * (self.counter_damage_percent * 0.01),
				damage_type		= DAMAGE_TYPE_PURE,
				damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION,
				attacker 		= self:GetParent(),
				ability 		= self:GetAbility()
			})
			
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, enemy, self.damage_counter * (self.counter_damage_percent * 0.01), nil)
			
			-- if not enemy:IsMagicImmune() or (enemy:IsMagicImmune() and self.damage_counter >= self.counter_stun_threshold) then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
					{
						distance		= self.counter_knockback_distance,
						direction_x 	= (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).x,
						direction_y 	= (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y,
						direction_z 	= (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).z,
						duration 		= self.counter_knockback_duration,
						height 			= self.counter_knockback_height,
						bGroundStop 	= true,
						bDecelerate 	= true,
						bInterruptible 	= false,
						bIgnoreTenacity	= true,
						treeRadius		= self.counter_tree_radius,
						bStun			= true
					})
			-- end
		end
	end
end

function modifier_item_imba_valiance_dash:CheckState()
	return {
		-- TODO: Check to make sure you don't attack at weird angles after this
		-- [MODIFIER_STATE_COMMAND_RESTRICTED]	= true,
		[MODIFIER_STATE_STUNNED]			= true,
		[MODIFIER_STATE_DISARMED]			= true,
		[MODIFIER_STATE_INVULNERABLE]		= true,
	}
end
