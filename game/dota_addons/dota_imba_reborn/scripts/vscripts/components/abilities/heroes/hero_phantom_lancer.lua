-- Editors:
--     Shush, 13.09.2017
--     AltiV, 23.12.2019

LinkLuaModifier("modifier_imba_phantom_lancer_spirit_lance", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_dopplewalk_phase", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge_boost", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_phantom_edge_agility", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_phantom_lancer_juxtapose", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_lancer_juxtapose_counter", "components/abilities/heroes/hero_phantom_lancer", LUA_MODIFIER_MOTION_NONE)

imba_phantom_lancer_spirit_lance			= imba_phantom_lancer_spirit_lance or class({})
modifier_imba_phantom_lancer_spirit_lance	= modifier_imba_phantom_lancer_spirit_lance or class({})
modifier_imba_phantom_lancer_illusion		= modifier_imba_phantom_lancer_illusion or class({})

imba_phantom_lancer_dopplewalk					= imba_phantom_lancer_dopplewalk or class({})
modifier_imba_phantom_lancer_dopplewalk_phase	= modifier_imba_phantom_lancer_dopplewalk_phase or class({})

imba_phantom_lancer_phantom_edge					= imba_phantom_lancer_phantom_edge or class({})
modifier_imba_phantom_lancer_phantom_edge			= modifier_imba_phantom_lancer_phantom_edge or class({})
modifier_imba_phantom_lancer_phantom_edge_boost		= modifier_imba_phantom_lancer_phantom_edge_boost or class({})
modifier_imba_phantom_lancer_phantom_edge_agility	= modifier_imba_phantom_lancer_phantom_edge_agility or class({})

imba_phantom_lancer_juxtapose					= imba_phantom_lancer_juxtapose or class({})
modifier_imba_phantom_lancer_juxtapose			= modifier_imba_phantom_lancer_juxtapose or class({})
modifier_imba_phantom_lancer_juxtapose_counter	= modifier_imba_phantom_lancer_juxtapose_counter or class({})

--------------------------------------
--			SPIRIT LANCE            --
--------------------------------------

function imba_phantom_lancer_spirit_lance:OnAbilityPhaseStart()
	-- Cycle between found units, only include illusions
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("fake_lance_distance"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit ~= self:GetCaster() then
			-- Fake casting animation
			unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)

			-- Illusions that are moving/attacking are ignored. Idle illusions fake their Spirit Lance
			if unit:IsIdle() then
				unit:FaceTowards(self:GetCursorTarget():GetAbsOrigin())
			end
		end
	end

	return true
end

function imba_phantom_lancer_spirit_lance:OnSpellStart()
	local target = self:GetCursorTarget()

	-- Play cast sound
	self:GetCaster():EmitSound("Hero_PhantomLancer.SpiritLance.Throw")

	if self:GetCaster():GetName() == "npc_dota_hero_phantom_lancer" then
		if not self.responses then
			self.responses = 
			{
				"phantom_lancer_plance_ability_spiritlance_01",
				"phantom_lancer_plance_ability_spiritlance_03",
				"phantom_lancer_plance_ability_spiritlance_05",
				"phantom_lancer_plance_ability_spiritlance_06",
				"phantom_lancer_plance_ability_spiritlance_08"
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	ProjectileManager:CreateTrackingProjectile({
		Target = target,
		Source = self:GetCaster(),
		Ability = self,
		EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
		iMoveSpeed = self:GetSpecialValueFor("lance_speed"),
		bDodgeable = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		--ExtraData = {}
	})

	-- Nearby illusions also cast their own projectiles. Those are fake, of course
	-- Find all nearby illusions
	-- Cycle between found units, only include illusions
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("fake_lance_distance"),
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
		FIND_ANY_ORDER,
		false)) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit ~= self:GetCaster() then
			ProjectileManager:CreateTrackingProjectile({
				Target = target,
				Source = unit,
				Ability = ability,
				EffectName = "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_projectile.vpcf",
				iMoveSpeed = self:GetSpecialValueFor("lance_speed") * ((unit:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() / (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D()),
				bDodgeable = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
				--ExtraData = {real_lance = 0}
			})
		end
	end
end

function imba_phantom_lancer_spirit_lance:OnProjectileHit_ExtraData(target, location, extradata)
	-- If there was no target (disjointed), do nothing
	if not target or target:IsMagicImmune() then
		return nil
	end

	-- If it was a fake lance, do nothing
	if extradata.real_lance == 0 then
		return nil
	end
	
	-- Play hit sound
	EmitSoundOn("Hero_PhantomLancer.SpiritLance.Impact", target)

	-- If target has Linken's sphere ready, do nothing
	if self:GetCaster():GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end

	-- "The lance first applies the debuff, then the damage."
	-- Slow target
	local slow_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_spirit_lance", {duration = self:GetSpecialValueFor("duration")})
	
	if slow_modifier then
		slow_modifier:SetDuration(self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()), true)
	end
	
	-- Deal damage to target
	ApplyDamage({
		victim 			= target,
		damage 			= self:GetTalentSpecialValueFor("lance_damage"),
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self
	})

	-- "The illusion spawns 58 range away from the target, at random spot around it."
	-- "Illusions created by Spirit Lance have a static 5 gold and experience bounty which does not scale with levels."
	local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), 
	{
		outgoing_damage = self:GetSpecialValueFor("illusion_damage_out_pct"),
		incoming_damage	= self:GetSpecialValueFor("illusion_damage_in_pct"),
		bounty_base		= 5,
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self:GetSpecialValueFor("illusion_duration")
	}
	, 1, self:GetCaster():GetHullRadius(), false, true)


	for _, illusion in pairs(illusions) do
		-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_illusion", {})
		illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
		FindClearSpaceForUnit(illusion, target:GetAbsOrigin() + RandomVector(58), true)
	end

	-- -- Create illusion
	-- local illusion = IllusionManager:CreateIllusion(caster, ability, target:GetAbsOrigin(), caster, {damagein = illusion_in_damage, damageout = illusion_out_damage, duration = illusion_duration, callback = attack_callback_func}, target)
end

-----------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_SPIRIT_LANCE --
-----------------------------------------------

function modifier_imba_phantom_lancer_spirit_lance:GetEffectName()
	return "particles/units/heroes/hero_phantom_lancer/phantomlancer_spiritlance_target.vpcf"
end

function modifier_imba_phantom_lancer_spirit_lance:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantoml_slowlance.vpcf"
end

function modifier_imba_phantom_lancer_spirit_lance:OnCreated()
	-- Ability specials
	self.movement_speed_pct = self:GetAbility():GetSpecialValueFor("movement_speed_pct")
end

function modifier_imba_phantom_lancer_spirit_lance:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_phantom_lancer_spirit_lance:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed_pct
end

------------------------------------
-- IMBA_PHANTOM_LANCER_DOPPLEWALK --
------------------------------------

-- Doppelganger disjoints projectiles upon cast.
-- Applies a basic dispel on Phantom Lancer upon cast.
function imba_phantom_lancer_dopplewalk:OnSpellStart()
	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_phantom_lancer" then
		if RollPercentage(5) then
			if not self.rare_responses then
				self.rare_responses = 
				{
					"phantom_lancer_plance_ability_dopplewalk_01",
					"phantom_lancer_plance_ability_dopplewalk_06"
				}
			end
			
			self:GetCaster():EmitSound(self.rare_responses[RandomInt(1, #self.rare_responses)])
		else	
			if not self.responses then
				self.responses = 
				{
					"phantom_lancer_plance_ability_dopplewalk_02",
					"phantom_lancer_plance_ability_dopplewalk_04",
					"phantom_lancer_plance_ability_dopplewalk_05",
					"phantom_lancer_plance_ability_juxtapose_02"
				}
			end
			
			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end
	end

	self.first_unit = nil
	self.new_pos	= nil
	
	local illusion_1 = CreateIllusions(self:GetCaster(), self:GetCaster(), 
	{
		outgoing_damage = self:GetSpecialValueFor("illusion_1_damage_in_pct"),
		incoming_damage	= self:GetSpecialValueFor("illusion_1_damage_in_pct"),
		bounty_base		= 5,
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("illusion_extended_duration") - self:GetSpecialValueFor("delay")
	}
	, 1, self:GetCaster():GetHullRadius(), false, true)
	
	illusion_1[1]:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_doppelwalk_illusion", {})
	
	local illusion_2 = CreateIllusions(self:GetCaster(), self:GetCaster(), 
	{
		outgoing_damage = self:GetSpecialValueFor("illusion_2_damage_out_pct"),
		incoming_damage	= self:GetSpecialValueFor("illusion_2_damage_out_pct"),
		bounty_base		= 5,
		bounty_growth	= nil,
		outgoing_damage_structure	= nil,
		outgoing_damage_roshan		= nil,
		duration		= self:GetSpecialValueFor("illusion_duration") + self:GetSpecialValueFor("illusion_extended_duration") - self:GetSpecialValueFor("delay")
	}
	, 1, self:GetCaster():GetHullRadius(), false, true)
	
	illusion_2[1]:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
	
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("search_radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)) do
		if unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and (unit == self:GetCaster() or unit:IsIllusion()) then
			unit:Purge(false, true, false, false, false)
	
			ProjectileManager:ProjectileDodge(unit)
			
			if not self.first_unit then
				self.first_unit = unit:entindex()
				self.new_pos	= self:GetCursorPosition()
			else
				-- "Phantom Lancer and his illusions reappear in a formation shaped like a plus, with a bit of variaton."
				if RollPercentage(50) then
					self.new_pos	= self:GetCursorPosition() + Vector(RandomInt(-self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe")), 0, 0)
				else
					self.new_pos	= self:GetCursorPosition() + Vector(0, RandomInt(-self:GetSpecialValueFor("target_aoe"), self:GetSpecialValueFor("target_aoe")), 0)
				end
			end
			
			unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_phantom_lancer_dopplewalk_phase", {
				duration	= self:GetSpecialValueFor("delay"),
				pos_x		= self:GetCursorPosition().x,
				pos_y		= self:GetCursorPosition().y,
				pos_z		= self:GetCursorPosition().z,
				
				new_pos_x	= self.new_pos.x,
				new_pos_y	= self.new_pos.y,
				new_pos_z	= self.new_pos.z
			})
		end
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_DOPPLEWALK_PHASE --
---------------------------------------------------

function modifier_imba_phantom_lancer_dopplewalk_phase:IsHidden()	return true end
function modifier_imba_phantom_lancer_dopplewalk_phase:IsPurgable()	return false end

function modifier_imba_phantom_lancer_dopplewalk_phase:OnCreated(keys)
	if not IsServer() then return end
	
	self.new_pos	= Vector(self.new_pos_x, self.new_pos_y, self.new_pos_z)
	
	self:GetParent():AddNoDraw()
end

function modifier_imba_phantom_lancer_dopplewalk_phase:OnDestroy()
	if not IsServer() then return end
	
	self:GetCaster():EmitSound("Hero_PhantomLancer.Doppelganger.Appear")
	
	self:GetParent():RemoveNoDraw()
	
	if self:GetParent():IsAlive() then
		FindClearSpaceForUnit(self:GetParent(), self.new_pos, true)
	end
end

-- "Phantom Lancer and his affected illusions are invulnerable and hidden during the reappear delay."
-- "Phantom Lancer cannot do anything during the reappear delay. Any order given during it is queued as next order."
function modifier_imba_phantom_lancer_dopplewalk_phase:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE]	= true,
		[MODIFIER_STATE_OUT_OF_GAME]	= true,
		[MODIFIER_STATE_STUNNED]		= true
	}
end

--------------------------------------
-- IMBA_PHANTOM_LANCER_PHANTOM_EDGE --
--------------------------------------

function imba_phantom_lancer_phantom_edge:GetIntrinsicModifierName()
	return "modifier_imba_phantom_lancer_phantom_edge"
end

function imba_phantom_lancer_phantom_edge:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_phantom_lancer_phantom_edge:OnSpellStart()

end

-----------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE --
-----------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge:IsHidden()		return true end
function modifier_imba_phantom_lancer_phantom_edge:IsPurgable()		return false end
function modifier_imba_phantom_lancer_phantom_edge:RemoveOnDeath()	return false end

function modifier_imba_phantom_lancer_phantom_edge:OnCreated()

end

function modifier_imba_phantom_lancer_phantom_edge:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end

function modifier_imba_phantom_lancer_phantom_edge:OnOrder(keys)
	if keys.unit == self:GetParent() and keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and self:GetAbility() and not self:GetAbility():GetToggleState() and not self:GetParent():PassivesDisabled() and keys.target and 
	(keys.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetTalentSpecialValueFor("max_distance") and ((keys.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= self:GetAbility():GetTalentSpecialValueFor("min_distance") or self:GetCaster():HasScepter()) then
		self:GetParent():EmitSound("Hero_PhantomLancer.PhantomEdge")
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_boost", {duration = 5})
		
		self:GetAbility():UseResources(true, false, true)
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE_BOOST --
-----------------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge_boost:GetEffectName()
	return "particles/units/heroes/hero_phantom_lancer/phantomlancer_edge_boost.vpcf"
end

function modifier_imba_phantom_lancer_phantom_edge_boost:OnCreated()
	self.bonus_speed		= self:GetAbility():GetSpecialValueFor("bonus_speed")
	self.bonus_agility		= self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.agility_duration	= self:GetAbility():GetSpecialValueFor("agility_duration")
	
	self.destroy_orders	=
	{
		[DOTA_UNIT_ORDER_MOVE_TO_POSITION]	= true,
		[DOTA_UNIT_ORDER_MOVE_TO_TARGET]	= true,
		[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
		-- [DOTA_UNIT_ORDER_ATTACK_TARGET]		= true,
		
		[DOTA_UNIT_ORDER_STOP]				= true,
		[DOTA_UNIT_ORDER_CONTINUE]			= true,
		[DOTA_UNIT_ORDER_CAST_POSITION]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET]		= true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE]	= true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE]		= true,
		[DOTA_UNIT_ORDER_HOLD_POSITION]		= true,
		[DOTA_UNIT_ORDER_DROP_ITEM]			= true,
		[DOTA_UNIT_ORDER_GIVE_ITEM]			= true,
		[DOTA_UNIT_ORDER_PICKUP_ITEM]		= true,
		[DOTA_UNIT_ORDER_PICKUP_RUNE]		= true,
	}
end

function modifier_imba_phantom_lancer_phantom_edge_boost:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function modifier_imba_phantom_lancer_phantom_edge_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_STATE_CHANGED,
		
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}
end

function modifier_imba_phantom_lancer_phantom_edge_boost:GetModifierMoveSpeed_AbsoluteMin()
	return self.bonus_speed
end

-- "This buff lasts for up to 5 seconds, until Phantom Lancer successfully hits the rush target, or until he receives another order."
-- "Non-targeted items do not cancel the rush. Items which can be double-clicked to cast on self still count as targeted."
function modifier_imba_phantom_lancer_phantom_edge_boost:OnOrder(keys)
	if keys.unit == self:GetParent() and self.destroy_orders[keys.order_type] then
		self:Destroy()
	end
end

-- "The rush buff is also lost when Phantom Lancer gets stunned, cycloned, slept, hexed or hidden."
function modifier_imba_phantom_lancer_phantom_edge_boost:OnStateChanged(keys)
	if keys.unit == self:GetParent() and (self:GetParent():IsStunned() or self:GetParent():IsNightmared() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame()) then
		self:Destroy()
	end
end

function modifier_imba_phantom_lancer_phantom_edge_boost:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() and not no_attack_cooldown then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_phantom_lancer_phantom_edge_agility", {
			duration		= self.agility_duration,
			bonus_agility	= self.bonus_agility
		})
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_PHANTOM_EDGE_AGILITY --
-------------------------------------------------------

function modifier_imba_phantom_lancer_phantom_edge_agility:OnCreated(keys)
	if self:GetAbility() then
		self.bonus_agility	= self:GetAbility():GetSpecialValueFor("bonus_agility")
	elseif keys and keys.bonus_agility then
		self.bonus_agility	= keys.bonus_agility
	else
		self.bonus_agility	= 11
	end
end

function modifier_imba_phantom_lancer_phantom_edge_agility:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end

function modifier_imba_phantom_lancer_phantom_edge_agility:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

-----------------------------------
-- IMBA_PHANTOM_LANCER_JUXTAPOSE --
-----------------------------------

function imba_phantom_lancer_juxtapose:GetIntrinsicModifierName()
	return "modifier_imba_phantom_lancer_juxtapose"
end

function imba_phantom_lancer_juxtapose:OnOwnerDied()
	if self.owner and not self.owner:IsNull() then
		self.owner:RemoveModifierByNameAndCaster("modifier_imba_phantom_lancer_juxtapose_counter", self:GetParent())
	end
end

--------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_JUXTAPOSE --
--------------------------------------------

function modifier_imba_phantom_lancer_juxtapose:IsHidden()		return true end
function modifier_imba_phantom_lancer_juxtapose:IsPurgable()	return false end
function modifier_imba_phantom_lancer_juxtapose:RemoveOnDeath()	return false end

function modifier_imba_phantom_lancer_juxtapose:OnCreated()
	self.duration = 0
	
	self.directional_vectors = {
		Vector(72, 0, 0),
		Vector(0, -72, 0),
		Vector(-72, 0, 0),
		Vector(0, 72, 0)
	}
	
	if not IsServer() then return end
	
	if self:GetParent():IsRealHero() then
		self.owner = self:GetParent()
	elseif not self:GetParent():IsRealHero() and self:GetParent():GetOwner() then
		self.owner = self:GetParent():GetOwner()
	end
end

function modifier_imba_phantom_lancer_juxtapose:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_imba_phantom_lancer_juxtapose:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and self.owner and #self.owner:FindAllModifiersByName("modifier_imba_phantom_lancer_juxtapose_counter") < self:GetAbility():GetTalentSpecialValueFor("max_illusions") then
		if self:GetParent():IsRealHero() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("proc_chance_pct"), self) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_duration")
		elseif not self:GetParent():IsRealHero() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("illusion_proc_chance_pct"), self) then
			self.duration = self:GetAbility():GetSpecialValueFor("illusion_from_illusion_duration")
		end
		
		if self.duration > 0 then
			local illusions = CreateIllusions(self:GetCaster():GetOwner() or self:GetCaster(), self:GetParent(), 
				{
					outgoing_damage = self:GetAbility():GetSpecialValueFor("illusion_damage_out_pct"),
					incoming_damage	= self:GetAbility():GetSpecialValueFor("illusion_damage_in_pct"),
					bounty_base		= 5,
					bounty_growth	= nil,
					outgoing_damage_structure	= nil,
					outgoing_damage_roshan		= nil,
					duration		= self.duration
				}
				, 1, self:GetCaster():GetHullRadius(), false, true)
			
			for _, illusion in pairs(illusions) do		
				illusion:AddNewModifier(self:GetCaster(), self, "modifier_phantom_lancer_juxtapose_illusion", {})
				FindClearSpaceForUnit(illusion, self:GetParent():GetAbsOrigin() + self.directional_vectors[RandomInt(1, #self.directional_vectors)], true)
				
				self.owner:AddNewModifier(illusion, self:GetAbility(), "modifier_imba_phantom_lancer_juxtapose_counter", {})
			end
			
			self.duration = 0
		end
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_PHANTOM_LANCER_JUXTAPOSE_COUNTER --
----------------------------------------------------

-- This modifier is used to track the maximum number of illusions that Juxtapose is allowed to create

-- function modifier_imba_phantom_lancer_juxtapose_counter:IsHidden()	return true end
function modifier_imba_phantom_lancer_juxtapose_counter:IsPurgable()	return false end
function modifier_imba_phantom_lancer_juxtapose_counter:RemoveOnDeath()	return false end
function modifier_imba_phantom_lancer_juxtapose_counter:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
