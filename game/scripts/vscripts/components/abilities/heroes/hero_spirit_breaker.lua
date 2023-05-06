-- Creator:
--	   AltiV, May 16th, 2019

LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_vision", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_clothesline", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_taxi", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_spirit_breaker_bulldoze", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_bulldoze_empowering_haste", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_spirit_breaker_greater_bash", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_greater_bash_speed", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_vision", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_planeswalker", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)

imba_spirit_breaker_charge_of_darkness							= class({})
modifier_imba_spirit_breaker_charge_of_darkness					= class({})
modifier_imba_spirit_breaker_charge_of_darkness_vision			= class({})
modifier_imba_spirit_breaker_charge_of_darkness_clothesline		= class({})
modifier_imba_spirit_breaker_charge_of_darkness_taxi			= class({})
modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter	= class({})
modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker	= class({})


imba_spirit_breaker_bulldoze									= class({})
modifier_imba_spirit_breaker_bulldoze							= class({})
modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura		= class({})
modifier_imba_spirit_breaker_bulldoze_empowering_haste			= class({})

imba_spirit_breaker_greater_bash								= class({})
modifier_imba_spirit_breaker_greater_bash						= class({})
modifier_imba_spirit_breaker_greater_bash_speed					= class({})

imba_spirit_breaker_nether_strike								= class({})
modifier_imba_spirit_breaker_nether_strike						= class({})
modifier_imba_spirit_breaker_nether_strike_vision				= class({})
modifier_imba_spirit_breaker_nether_strike_planeswalker			= class({})
modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy	= class({})

------------------------
-- CHARGE OF DARKNESS --
------------------------

function imba_spirit_breaker_charge_of_darkness:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_spirit_breaker_charge_of_darkness:GetAssociatedSecondaryAbilities()
	return "imba_spirit_breaker_greater_bash"
end

function imba_spirit_breaker_charge_of_darkness:GetIntrinsicModifierName()
	return "modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker"
end

function imba_spirit_breaker_charge_of_darkness:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cooldown")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_spirit_breaker_charge_of_darkness:OnSpellStart()
	-- Debug line
	self.charge_cancel_reason = nil

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then
		return nil
	end
	
	self:GetCaster():Interrupt()
	
	self:GetCaster():EmitSound("Hero_Spirit_Breaker.ChargeOfDarkness")

	if self:GetCaster():GetName() == "npc_dota_hero_spirit_breaker" and RollPercentage(10) then
		local responses	= {"spirit_breaker_spir_ability_charge_02", "spirit_breaker_spir_ability_charge_14", "spirit_breaker_spir_ability_charge_19"}
	
		self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_charge_of_darkness", 
	{
		ent_index = target:GetEntityIndex()
	})
	
	-- IDK how to replicate 0 second CD so gonna go with activation disabling as usual
	self:SetActivated(false)
end

---------------------------------
-- CHARGE OF DARKNESS MODIFIER --
---------------------------------

function modifier_imba_spirit_breaker_charge_of_darkness:IsPurgable()	return false end

function modifier_imba_spirit_breaker_charge_of_darkness:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_imba_spirit_breaker_charge_of_darkness:GetStatusEffectName()
	return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end

function modifier_imba_spirit_breaker_charge_of_darkness:OnCreated(params)
	if self:GetAbility() then
		self.movement_speed		= self:GetAbility():GetTalentSpecialValueFor("movement_speed")
		self.stun_duration		= self:GetAbility():GetSpecialValueFor("stun_duration")
		self.bash_radius		= self:GetAbility():GetSpecialValueFor("bash_radius")
		self.scepter_speed		= self:GetAbility():GetSpecialValueFor("scepter_speed")
		
		-- These aren't used
		-- self.vision_radius		= self:GetAbility():GetSpecialValueFor("vision_radius")
		-- self.vision_duration	= self:GetAbility():GetSpecialValueFor("vision_duration")
		
		self.darkness_speed			= self:GetAbility():GetSpecialValueFor("darkness_speed")
		self.clothesline_duration	= self:GetAbility():GetSpecialValueFor("clothesline_duration")
		self.taxi_radius			= self:GetAbility():GetSpecialValueFor("taxi_radius")
		self.taxi_distance			= self:GetAbility():GetSpecialValueFor("taxi_distance")
	else
		return
	end

	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Spirit_Breaker.ChargeOfDarkness.FP")
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
	
	-- Set sights on the target
	self.target					= EntIndexToHScript(params.ent_index)
	-- Initialize empty table to add bashed enemies into (as they can only be bashed once per charge)
	self.bashed_enemies			= {}
	-- ???????????
	self.trees					= {}
	-- IMBAfication: Darkness Imprisoning Me
	-- Initialize counter to track how long the charge has lasted under fog of war
	self.darkness_counter		= 0
	-- IMBAfication: Taxi!
	-- Initialize empty table to add allies attempting to board (allows for smooth boarding when they get close enough, somewhat like Tusk's Snowball)
	self.attempting_to_board	= {}
	
	-- Add the vision modifier to the target
	self.vision_modifier = self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_spirit_breaker_charge_of_darkness_vision", {})
end

function modifier_imba_spirit_breaker_charge_of_darkness:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	
	-- Rubick/Morphling stuff I guess
	if not self:GetAbility() then
		-- Okay this line should never run but...
		self:GetAbility().charge_cancel_reason = "Ability Does Not Exist"
		self:Destroy()
		return
	end
	
	-- "If the target dies during the charge, it is transferred to the nearest valid target within 4000 range of the previous target."
	if not self.target:IsAlive() then
		local new_targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.target:GetAbsOrigin(), nil, 4000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		
		-- Set this to nil and begin looking for a new target if applicable
		self.target = nil
		
		if #new_targets == 0 then
			self:GetAbility().charge_cancel_reason = "Primary target dead; no other valid targets within 4000 radius"
			self:Destroy()
			return
		end
		
		for _, target in pairs(new_targets) do 
			if target ~= self.clothesline_target then
				self.target = target
				self.vision_modifier = self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_spirit_breaker_charge_of_darkness_vision", {})
				break
			end
		end
		
		if not self.target then
			self:GetAbility().charge_cancel_reason = "Primary target dead; only valid target within 4000 radius is being Clotheslined"
			self:Destroy()
			return
		end
	end
	
	-- "Any unit which comes within 300 radius of Spirit Breaker during the charge gets hit by the current level of Greater Bash."
	-- "The bash radius is offset by 20 units in front of Spirit Breaker, so it can hit units 280 range behind and 320 range in front of him."
	local greater_bash_ability = self:GetCaster():FindAbilityByName("imba_spirit_breaker_greater_bash")
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin() + (self:GetParent():GetForwardVector() * 20), nil, self.bash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	
	for _, enemy in pairs(enemies) do
		-- IMBAfication: Clothesline
		if self:GetAbility():GetAutoCastState() and not self.clothesline_target and enemy ~= self.target and not enemy:IsRoshan() and enemy:IsHero() then
			self.clothesline_target = enemy
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_spirit_breaker_charge_of_darkness_clothesline", {duration = self.clothesline_duration * (1 - enemy:GetStatusResistance())})
			self.bashed_enemies[enemy] = true
		elseif greater_bash_ability and greater_bash_ability:IsTrained() and enemy ~= self.target and not self.bashed_enemies[enemy] then
			greater_bash_ability:Bash(enemy, me)
			self.bashed_enemies[enemy] = true
		end
	end
	
	-- Check anyone that's currently following Spirit Breaker as well before the cast...
	local taxi_tracker_modifier	= self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker", self:GetCaster())
	
	-- Check allies attempting to board
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.taxi_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, ally in pairs(allies) do
		if ally ~= self:GetParent() and (self.attempting_to_board[ally] or (taxi_tracker_modifier and taxi_tracker_modifier.attempting_to_board[ally])) then
			local taxi_modifier = ally:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_spirit_breaker_charge_of_darkness_taxi", 
			{
				passenger_num	= 1, -- This will be changed by checking the index of taxi counter modifiers
				taxi_distance	= self.taxi_distance
			})
			
			local taxi_counter_modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter", 
			{
				ent_index = ally:GetEntityIndex()
			})
			
			-- Assign passenger number
			local counter_modifiers = self:GetParent():FindAllModifiersByName("modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter")
			
			for num = 1, #counter_modifiers do
				if taxi_counter_modifier == counter_modifiers[num] then
					taxi_modifier.passenger_num = num
					break
				end
			end

			self.attempting_to_board[ally] = nil
			
			if taxi_tracker_modifier and taxi_tracker_modifier.attempting_to_board[ally] then
				taxi_tracker_modifier.attempting_to_board[ally] = nil
			end
		end
	end
	
	-- Play...tree breaking particles when charging through a tree, but don't actually break it
	local trees = GridNav:GetAllTreesAroundPoint( me:GetOrigin(), me:GetHullRadius(), false )
	
	for _, tree in pairs(trees) do
		if not self.trees[tree] then
			local tree_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_tree.vpcf", PATTACH_POINT, me)
			ParticleManager:ReleaseParticleIndex(tree_particle)
			self.trees[tree] = true
		end
	end
	
	-- "The charge is cancelled when Spirit Breaker gets stunned, cycloned, hexed, rooted, slept, hidden, feared, hypnotized or hit by Forced Movement."
	if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 then
		self:GetParent():EmitSound("Hero_Spirit_Breaker.Charge.Impact")
	
		if greater_bash_ability and greater_bash_ability:IsTrained() then
			greater_bash_ability:Bash(self.target, me)
			
			-- le memes
			if USE_MEME_SOUNDS and self:GetAbility() then
				if RollPercentage(10) then
					self:GetCaster():EmitSound("Hero_Spirit_Breaker.FryingPan")
					self:GetAbility().frying_pan	= true
					self:GetAbility().timer			= GameRules:GetDOTATime(true, true)
				else
					self:GetAbility().frying_pan	= false
					self:GetAbility().timer			= nil
				end
			end		
		end
		
		if not self.target:IsMagicImmune() and self:GetAbility() then
			self.target:AddNewModifier(me, self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - self.target:GetStatusResistance())})
		end
		
		-- IMBAfication: Mad Cow (if the target is NOT alive after the charge connects, the charge modifier is not necessarily destroyed)
		if self.target:IsAlive() then
			self:GetAbility().charge_cancel_reason = "Charge connected with target and they were still alive after impact"
			me:SetAggroTarget(self.target)
			self:Destroy()
		end
		
		return
	elseif me:IsStunned() or me:IsOutOfGame() or me:IsHexed() or me:IsRooted() then
		self:GetAbility().charge_cancel_reason = "Caster was disabled mid-charge"
		self:Destroy()
		return
	end

	-- IDK which ones to use properly, cause some break run animations and some break the modifier
	-- me:SetForwardVector((self.target:GetOrigin() - me:GetOrigin()):Normalized())
	me:FaceTowards(self.target:GetOrigin())
	-- me:MoveToPosition(self.target:GetOrigin())

	local distance = (GetGroundPosition(self.target:GetOrigin(), nil) - GetGroundPosition(me:GetOrigin(), nil)):Normalized()
	me:SetOrigin( me:GetOrigin() + distance * me:GetIdealSpeed() * dt )
	
	if not self.target:CanEntityBeSeenByMyTeam(self:GetParent()) then
		self.darkness_counter = self.darkness_counter + ( self.darkness_speed * dt)
	
		self:SetStackCount(math.floor(self.darkness_counter))
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_spirit_breaker_charge_of_darkness:OnHorizontalMotionInterrupted()
	self:GetAbility().charge_cancel_reason = "Horizontal Motion Interrupted"

	self:Destroy()
end

function modifier_imba_spirit_breaker_charge_of_darkness:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController( self )
	
	-- Gonna call these first cause they're arguably more important and don't want to brick the hero if code fails
	if self:GetAbility() then
		self:GetAbility():SetActivated(true)
		self:GetAbility():UseResources(false, false, false, true)
	end
	
	self:GetParent():StopSound("Hero_Spirit_Breaker.ChargeOfDarkness.FP")
	
	self:GetParent():StartGesture(ACT_DOTA_SPIRIT_BREAKER_CHARGE_END)
	
	-- "Destroys trees within a small radius around Spirit Breaker whenever the charge ends."
	-- ...YEAH BUT HOW BIG IS THE RADIUS
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self:GetParent():GetHullRadius(), true )
	
	-- Remove the vision modifier from targets if applicable
	if self.vision_modifier and not self.vision_modifier:IsNull() then
		self.vision_modifier:Destroy()
	end
	
	-- Clean up any taxi counter modifiers if they persisted after charge end for some reason
	local counter_modifiers = self:GetParent():FindAllModifiersByName("modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter")

	for _, mod in pairs(counter_modifiers) do
		mod:Destroy()
	end	
end

-- This is so Spirit Breaker doesn't spaz out at random pathing while charging
function modifier_imba_spirit_breaker_charge_of_darkness:CheckState()
	return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
end

function modifier_imba_spirit_breaker_charge_of_darkness:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		-- MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		
		-- This violates the "When auto-attack is enabled, Spirit Breaker can automatically attack units when close enough, without cancelling the charge." clause, but Spirit Breaker runs in weird-ass directions when he aggros things he charges by so this is a...compromise
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,

		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_spirit_breaker_charge_of_darkness:GetModifierIgnoreMovespeedLimit()
	return 1
end

-- function modifier_imba_spirit_breaker_charge_of_darkness:GetModifierMoveSpeed_Limit()
	-- return 10000
-- end

function modifier_imba_spirit_breaker_charge_of_darkness:GetDisableAutoAttack()
	return 1
end

function modifier_imba_spirit_breaker_charge_of_darkness:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():HasScepter() then
		return self.movement_speed + self:GetStackCount() + self.scepter_speed
	else
		return self.movement_speed + self:GetStackCount()
	end
end

function modifier_imba_spirit_breaker_charge_of_darkness:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_imba_spirit_breaker_charge_of_darkness:GetActivityTranslationModifiers()
	return "charge"
end

function modifier_imba_spirit_breaker_charge_of_darkness:OnOrder(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() then
		local cancel_commands = 
		{
			[DOTA_UNIT_ORDER_MOVE_TO_POSITION] 	= true,
			[DOTA_UNIT_ORDER_MOVE_TO_TARGET] 	= true,
			[DOTA_UNIT_ORDER_ATTACK_MOVE] 		= true,
			[DOTA_UNIT_ORDER_ATTACK_TARGET] 	= true,
			[DOTA_UNIT_ORDER_CAST_POSITION]		= true,
			[DOTA_UNIT_ORDER_CAST_TARGET]		= true,
			[DOTA_UNIT_ORDER_CAST_TARGET_TREE]	= true,
			[DOTA_UNIT_ORDER_HOLD_POSITION] 	= true,
			[DOTA_UNIT_ORDER_STOP]				= true
		}
		
		-- Testing something to try and stop randomly cancelled charges but IDK what the issue is
		if cancel_commands[keys.order_type] then -- and self:GetElapsedTime() >= 0.1 then
			self:GetAbility().charge_cancel_reason = "Cancel Order Issued: "..keys.order_type
			
			self:Destroy()
		end
	-- IMBAfication: Taxi!
	elseif keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET and keys.target == self:GetParent() and not keys.unit:HasModifier("modifier_imba_spirit_breaker_charge_of_darkness_taxi") then
			self.attempting_to_board[keys.unit] = true
		elseif self.attempting_to_board[keys.unit] then
			self.attempting_to_board[keys.unit] = nil
		end
	end
end

----------------------------------------
-- CHARGE OF DARKNESS VISION MODIFIER --
----------------------------------------

function modifier_imba_spirit_breaker_charge_of_darkness_vision:IsHidden()		return true end
function modifier_imba_spirit_breaker_charge_of_darkness_vision:IsPurgable()	return false end
function modifier_imba_spirit_breaker_charge_of_darkness_vision:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_spirit_breaker_charge_of_darkness_vision:ShouldUseOverheadOffset() return true end -- I have no idea when this works but it might be particle-specific

function modifier_imba_spirit_breaker_charge_of_darkness_vision:OnCreated()
	if not IsServer() then return end
	
	self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	self:AddParticle(self.particle, false, false, -1, false, true)
end

function modifier_imba_spirit_breaker_charge_of_darkness_vision:CheckState()
	return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

---------------------------------------------
-- CHARGE OF DARKNESS CLOTHESLINE MODIFIER --
---------------------------------------------

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:OnCreated(params)
	if not IsServer() then return end
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	
	-- "The charge is cancelled when Spirit Breaker gets stunned, cycloned, hexed, rooted, slept, hidden, feared, hypnotized or hit by Forced Movement."
	if not self:GetCaster():HasModifier("modifier_imba_spirit_breaker_charge_of_darkness") or me:IsOutOfGame() then
		self:Destroy()
		return
	end
	
	me:SetOrigin( self:GetCaster():GetOrigin() + (self:GetCaster():GetForwardVector() * 128) )
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController( self )
	
	local greater_bash_ability = self:GetCaster():FindAbilityByName("imba_spirit_breaker_greater_bash")
	
	if greater_bash_ability and greater_bash_ability:IsTrained() then
		greater_bash_ability:Bash(self:GetParent(), self:GetCaster())
	end
end

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	
	return state
end

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_charge_of_darkness_clothesline:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------
-- CHARGE OF DARKNESS TAXI MODIFIER --
--------------------------------------

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:IsPurgable()	return false end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:GetStatusEffectName()
	return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:OnCreated(params)
	if not IsServer() then return end
	
	self.passenger_num	= params.passenger_num
	self.taxi_distance	= params.taxi_distance
	
	self:GetParent():EmitSound("Hero_Spirit_Breaker.ChargeOfDarkness.FP")
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end
	
	-- "The charge is cancelled when Spirit Breaker gets stunned, cycloned, hexed, rooted, slept, hidden, feared, hypnotized or hit by Forced Movement."
	if not self:GetCaster():HasModifier("modifier_imba_spirit_breaker_charge_of_darkness") or me:IsStunned() or me:IsOutOfGame() or me:IsHexed() or me:IsRooted() then
		self:Destroy()
		return
	end
	
	me:SetOrigin( self:GetCaster():GetOrigin() + (self:GetCaster():GetForwardVector() * (-1) * (self.passenger_num * self.taxi_distance)) ) -- Another AbilitySpecial
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_spirit_breaker_charge_of_darkness_taxi:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveHorizontalMotionController( self )
	
	-- If targets get off of the ride early, free the index to allow other units to sit closer to the front
	local charge_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_charge_of_darkness", self:GetCaster())
	
	if charge_modifier and charge_modifier.passengers then
		charge_modifier.passengers = math.max(charge_modifier.passengers - 1, 0)
	end
	
	-- Destroy the cooresponding taxi counter on the main charging unit's end
	local counter_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter")
	
	for num = 1, #counter_modifiers do
		if counter_modifiers[num].target == self:GetParent() then
			counter_modifiers[num]:Destroy()
			break
		end
	end
	
	-- Call the table again (since everything should be shifted now), and re-assign passenger numbers
	local counter_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter")
	
	for num = 1, #counter_modifiers do
		if counter_modifiers[num].target then
			local taxi_modifier = counter_modifiers[num].target:FindModifierByName("modifier_imba_spirit_breaker_charge_of_darkness_taxi")

			if taxi_modifier then
				taxi_modifier.passenger_num = num
			end
		end
	end	
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	return decFuncs
end

-- Slightly less restrictive set of cancel orders compared to standard charge (passengers get a bit more freedom, after all)
function modifier_imba_spirit_breaker_charge_of_darkness_taxi:OnOrder(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() then
		local cancel_commands = 
		{
			-- [DOTA_UNIT_ORDER_MOVE_TO_POSITION] 	= true,
			-- [DOTA_UNIT_ORDER_MOVE_TO_TARGET] 	= true,
			[DOTA_UNIT_ORDER_HOLD_POSITION] 	= true,
			[DOTA_UNIT_ORDER_STOP]				= true
		}
		
		if cancel_commands[keys.order_type] then
			self:Destroy()
		end
	end
end

----------------------------------------------
-- CHARGE OF DARKNESS TAXI COUNTER MODIFIER --
----------------------------------------------

function modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter:IsHidden()		return true end
function modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter:IsPurgable()		return false end
function modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi_counter:OnCreated(params)
	if not IsServer() then return end
	
	self.target					= EntIndexToHScript(params.ent_index)
end

----------------------------------------------
-- CHARGE OF DARKNESS TAXI TRACKER MODIFIER --
----------------------------------------------

-- This is just for QOL stuff and latching to Spirit Breaker before he actually charges...hopefully it's not laggy as hell
function modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker:IsHidden()	return true end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker:OnCreated()
	if not IsServer() then return end
	
	-- Initialize empty table to add allies hoping to board before an actual charge
	self.attempting_to_board	= {}
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_ORDER
	}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_charge_of_darkness_taxi_tracker:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		if keys.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET and keys.target == self:GetParent() and not keys.unit:HasModifier("modifier_imba_spirit_breaker_charge_of_darkness_taxi") then
			self.attempting_to_board[keys.unit] = true
		elseif self.attempting_to_board[keys.unit] then
			self.attempting_to_board[keys.unit] = nil
		end
	end
end


--------------
-- BULLDOZE --
--------------

-- IMBAfication: Remnants of Empowering Haste
function imba_spirit_breaker_bulldoze:GetIntrinsicModifierName()
	return "modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura"
end

function imba_spirit_breaker_bulldoze:GetCooldown(nLevel)
	return self.BaseClass.GetCooldown(self, nLevel) - self:GetCaster():FindTalentValue("special_bonus_imba_spirit_breaker_bulldoze_cooldown")
end

function imba_spirit_breaker_bulldoze:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Spirit_Breaker.Bulldoze.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_spirit_breaker" and RollPercentage(50) then
		local responses	= {"spirit_breaker_spir_ability_charge_03", "spirit_breaker_spir_ability_charge_05", "spirit_breaker_spir_ability_charge_13"}
	
		self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_bulldoze", {duration = self:GetSpecialValueFor("duration")})
end

-----------------------
-- BULLDOZE MODIFIER --
-----------------------

function modifier_imba_spirit_breaker_bulldoze:GetEffectName()
	return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf"
end

function modifier_imba_spirit_breaker_bulldoze:OnCreated()
	self.movement_speed		= self:GetAbility():GetSpecialValueFor("movement_speed")
	self.status_resistance	= self:GetAbility():GetSpecialValueFor("status_resistance")
end

function modifier_imba_spirit_breaker_bulldoze:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_bulldoze:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_spirit_breaker_bulldoze:GetModifierStatusResistanceStacking()
	return self.status_resistance
end

------------------------------------
-- BULLDOZE EMPOWERING HASTE AURA --
------------------------------------

function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:IsHidden()						return true end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:IsAura()						return true end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:IsAuraActiveOnDeath() 			return false end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("empowering_aura_radius") end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetModifierAura()				return "modifier_imba_spirit_breaker_bulldoze_empowering_haste" end
function modifier_imba_spirit_breaker_bulldoze_empowering_haste_aura:GetAuraEntityReject(hTarget)	return self:GetCaster():PassivesDisabled() end

----------------------------------------
-- BULLDOZE EMPOWERING HASTE MODIFIER --
----------------------------------------

function modifier_imba_spirit_breaker_bulldoze_empowering_haste:IsHidden()	return not (self:GetAbility() and self:GetAbility():GetLevel() >= 1) end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste:GetTexture()
	return "spirit_breaker_empowering_haste"
end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste:OnCreated()
	self.empowering_aura_move_speed	= self:GetAbility():GetSpecialValueFor("empowering_aura_move_speed")
end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_bulldoze_empowering_haste:GetModifierMoveSpeedBonus_Percentage()
	return self.empowering_aura_move_speed
end

------------------
-- GREATER BASH --
------------------

imba_spirit_breaker_greater_bash						= class({})

function imba_spirit_breaker_greater_bash:GetIntrinsicModifierName()
	return "modifier_imba_spirit_breaker_greater_bash"
end

function imba_spirit_breaker_greater_bash:Bash(target, parent, bUltimate)
	if not IsServer() then return end
	
	local parent_loc	= parent:GetAbsOrigin()
	-- local bash_location = (target:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("knockback_distance")
	
	if not target:IsCreep() then
		target:EmitSound("Hero_Spirit_Breaker.GreaterBash")
	else
		target:EmitSound("Hero_Spirit_Breaker.GreaterBash.Creep")
	end
	
	local bash_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(bash_particle)
	
	-- "Can proc on Roshan, putting it on cooldown and applying the damage, but Roshan is neither knocked back nor stunned."
	if not target:IsRoshan() then
		-- Stacking knockback modifiers causes the target to get stuck in place, so the previous modifier before reapplying
		local knockback_modifier = target:FindModifierByNameAndCaster("modifier_knockback", parent)
		
		if knockback_modifier then
			knockback_modifier:Destroy()
		end
		
		knockback_properties = {
			 center_x 			= parent_loc.x,
			 center_y 			= parent_loc.y,
			 center_z 			= parent_loc.z,
			 duration 			= self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()),
			 knockback_duration = self:GetSpecialValueFor("knockback_duration") * (1 - target:GetStatusResistance()),
			 knockback_distance = self:GetSpecialValueFor("knockback_distance"),
			 knockback_height 	= self:GetSpecialValueFor("knockback_height"),
		}
		-- "[Nether Strike] knocks back for double the normal distance."
		if bUltimate then
			knockback_properties.knockback_distance = knockback_properties.knockback_distance * 2
		end
		
		-- Greater Bash first applies the debuff, then the damage, no matter whether it procs on attacks, or is applied by Spirit Breaker's abilities.
		knockback_modifier = target:AddNewModifier(parent, self, "modifier_knockback", knockback_properties)
	end
	
	local damageTable = {
		victim 			= target,
		damage 			= parent:GetIdealSpeed() * self:GetSpecialValueFor("damage") * 0.01,
		damage_type		= self:GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= parent,
		ability 		= self
	}

	damage_dealt = ApplyDamage(damageTable)
	
	-- IMBAfication: Power Forward
	parent:AddNewModifier(parent, self, "modifier_imba_spirit_breaker_greater_bash_speed", {duration = self:GetSpecialValueFor("movespeed_duration")})
end

---------------------------
-- GREATER BASH MODIFIER --
---------------------------

function modifier_imba_spirit_breaker_greater_bash:IsHidden()	return true end

-- function modifier_imba_spirit_breaker_greater_bash:OnCreated()
	-- self.chance_pct				= self:GetAbility():GetSpecialValueFor("chance_pct")
	-- self.damage					= self:GetAbility():GetSpecialValueFor("damage")
	-- self.duration				= self:GetAbility():GetSpecialValueFor("duration")
	-- self.knockback_duration		= self:GetAbility():GetSpecialValueFor("knockback_duration")
	-- self.knockback_distance		= self:GetAbility():GetSpecialValueFor("knockback_distance")
	-- self.knockback_height		= self:GetAbility():GetSpecialValueFor("knockback_height")
	-- self.bonus_movespeed_pct	= self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
	-- self.movespeed_duration		= self:GetAbility():GetSpecialValueFor("movespeed_duration")
-- end

function modifier_imba_spirit_breaker_greater_bash:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }

    return decFuncs
end

function modifier_imba_spirit_breaker_greater_bash:OnAttackLanded(keys)
	if not IsServer() then return end

	if self:GetAbility() and self:GetAbility():IsTrained() and self:GetAbility():IsCooldownReady() and keys.attacker == self:GetParent() and not keys.attacker:PassivesDisabled() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not self:GetParent():IsIllusion() then
	
		if RollPseudoRandom(self:GetAbility():GetTalentSpecialValueFor("chance_pct"), self) then
			self:GetAbility():Bash(keys.target, keys.attacker)
			self:GetAbility():UseResources(false, false, false, true)
		end
	end
end

---------------------------------
-- GREATER BASH SPEED MODIFIER --
---------------------------------

function modifier_imba_spirit_breaker_greater_bash_speed:OnCreated()
	if self:GetAbility() then
		self.bonus_movespeed_pct	= self:GetAbility():GetSpecialValueFor("bonus_movespeed_pct")
	else
		self:Destroy()
	end
end

function modifier_imba_spirit_breaker_greater_bash_speed:CheckState()
	return {[MODIFIER_STATE_UNSLOWABLE] = true}
end

function modifier_imba_spirit_breaker_greater_bash_speed:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_greater_bash_speed:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movespeed_pct
end

-------------------
-- NETHER STRIKE --
-------------------

function imba_spirit_breaker_nether_strike:GetAssociatedSecondaryAbilities()
	return "imba_spirit_breaker_greater_bash"
end

function imba_spirit_breaker_nether_strike:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

-- Planeswalker IMBAfication will be an "opt-out" add-on
function imba_spirit_breaker_nether_strike:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_spirit_breaker_nether_strike:GetCooldown(nLevel)
	-- if self:GetCaster():HasScepter() then
		-- return self:GetSpecialValueFor("cooldown_scepter")
	-- else
		return self.BaseClass.GetCooldown(self, nLevel)
	-- end
end

function imba_spirit_breaker_nether_strike:GetCastRange(location, target)
	-- if self:GetCaster():HasScepter() then
		-- return self:GetSpecialValueFor("cast_range_scepter")
	-- else
		return self.BaseClass.GetCastRange(self, location, target)
	-- end
end

function imba_spirit_breaker_nether_strike:GetCastPoint()
	if self:GetCaster():HasModifier("modifier_imba_spirit_breaker_nether_strike_planeswalker") then
		return self.BaseClass.GetCastPoint(self) * (100 - self:GetTalentSpecialValueFor("planeswalker_reduction")) * 0.01
	else
		return self.BaseClass.GetCastPoint(self)
	end
end

function imba_spirit_breaker_nether_strike:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_imba_spirit_breaker_nether_strike_planeswalker") then
		return self.BaseClass.GetManaCost(self, iLevel) * (100 - self:GetTalentSpecialValueFor("planeswalker_reduction")) * 0.01
	else
		return self.BaseClass.GetManaCost(self, iLevel)
	end
end

function imba_spirit_breaker_nether_strike:CastFilterResultTarget(hTarget)
	if not IsServer() then return end
	
	if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker", self:GetCaster()) then
		if hTarget:FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", self:GetCaster()) then
			return UF_SUCCESS
		else
			return UF_FAIL_CUSTOM
		end
	else
		local nResult = UnitFilter( hTarget, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		
		return nResult
	end
end

function imba_spirit_breaker_nether_strike:GetCustomCastErrorTarget( hTarget )
	if not IsServer() then return end
	
	if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker", self:GetCaster()) and not hTarget:FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", self:GetCaster()) then
		return "Invalid Planeswalker Target"
	end
end

function imba_spirit_breaker_nether_strike:OnAbilityPhaseStart()
	if not IsServer() then return end
	
	if not self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker", self:GetCaster()) then
		self:GetCaster():EmitSound("Hero_Spirit_Breaker.NetherStrike.Begin")
		
		-- Give vision of the target for the duration of the cast point
		self.vision_modifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_nether_strike_vision", {duration = self:GetCastPoint()})
		
		-- IMBAfication: BIG DICK ENERGY
		self.energy_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_nether_strike", {duration = self:GetCastPoint()})
		
		-- IT'S RANDY ORTON
		if USE_MEME_SOUNDS then
			if RollPercentage(20) then
				self:GetCaster():EmitSound("Hero_Spirit_Breaker.RandyOrton1")
				self.randy = true
			else
				self.randy = false
			end
		end
	end

	return true
end

function imba_spirit_breaker_nether_strike:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
	
	self:GetCaster():StopSound("Hero_Spirit_Breaker.NetherStrike.Begin")
	
	if self.vision_modifier and not self.vision_modifier:IsNull() then
		self.vision_modifier:Destroy()
	end
	
	if self.energy_modifier and not self.energy_modifier:IsNull() then
		self.energy_modifier:Destroy()
	end
	
	if USE_MEME_SOUNDS and self.randy then
		self:GetCaster():StopSound("Hero_Spirit_Breaker.RandyOrton1")
		self.randy = false
	end
end

function imba_spirit_breaker_nether_strike:OnSpellStart()
	if not IsServer() then return end
	
	local target = self:GetCursorTarget()
	
	if self.vision_modifier and not self.vision_modifier:IsNull() then
		self.vision_modifier:Destroy()
	end
	
	if self.energy_modifier and not self.energy_modifier:IsNull() then
		self.energy_modifier:Destroy()
	end
	
	if target:TriggerSpellAbsorb(self) then
		return nil
	end
	
	self:GetCaster():EmitSound("Hero_Spirit_Breaker.NetherStrike.End")

	if USE_MEME_SOUNDS then
		if self.randy then
			self:GetCaster():EmitSound("Hero_Spirit_Breaker.RandyOrton2")
			self.randy = false
		end
			
		local charge_ability = self:GetCaster():FindAbilityByName("imba_spirit_breaker_charge_of_darkness")
		
		-- Only give a three second window between charge and ultimate to persist the meme sound		
		if charge_ability and charge_ability.frying_pan and charge_ability.timer and GameRules:GetDOTATime(true, true) - charge_ability.timer <= 3 then
			self:GetCaster():EmitSound("Hero_Spirit_Breaker.FryingPan")
			
			charge_ability.frying_pan		= false
			charge_ability.timer			= nil			
		end
	end	
	
	local start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_begin.vpcf", PATTACH_ABSORIGIN, self:GetCaster())

	-- "Nether Strike instantly moves Spirit Breaker on the opposite side of the target, 54 range away from it."
	FindClearSpaceForUnit(self:GetCaster(), target:GetAbsOrigin() + ((target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() * (54)), false)
	
	-- IMBAfication: Warp Beast
	ProjectileManager:ProjectileDodge(self:GetCaster())
	
	ParticleManager:SetParticleControl(start_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(start_particle)
	
	local end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_end.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(end_particle)
	
	-- "Instantly applies Greater Bash on the target based on its current level. The bash is applied before its own damage is."
	local greater_bash_ability = self:GetCaster():FindAbilityByName("imba_spirit_breaker_greater_bash")

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("bash_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

	if greater_bash_ability and greater_bash_ability:IsTrained() then
		greater_bash_ability:Bash(target, self:GetCaster(), true)
	end
	
	local damageTable = {
		victim 			= target,
		damage 			= self:GetSpecialValueFor("damage"),
		damage_type		= self:GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self
	}
		
	damage_dealt = ApplyDamage(damageTable)

	-- if self:GetCaster():HasScepter() then
		-- for _, enemy in pairs(enemies) do
			-- if enemy ~= target then
				-- if greater_bash_ability and greater_bash_ability:IsTrained() then
					-- greater_bash_ability:Bash(enemy, self:GetCaster())
				-- end
				
				-- local damageTable = {
					-- victim 			= target,
					-- damage 			= self:GetSpecialValueFor("damage"),
					-- damage_type		= self:GetAbilityDamageType(),
					-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					-- attacker 		= self:GetCaster(),
					-- ability 		= self
				-- }
				
				-- damage_dealt = ApplyDamage(damageTable)
			-- end
		-- end
	-- end
	
	-- IMBAfication: Planeswalker
	if self:GetAutoCastState() then
		if not self:GetCaster():FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker", self:GetCaster()) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_nether_strike_planeswalker", {duration = self:GetSpecialValueFor("planeswalker_duration")})
			
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(enemies) do
				if enemy ~= target and not target:FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", self:GetCaster()) then
					enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", {duration = self:GetSpecialValueFor("planeswalker_duration")})
				end
			end		
		elseif target:FindModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy", self:GetCaster())
		end
		
		-- Mostly QOL for testing purposes so I don't have to keep refreshing the ability manually
		if self:GetCooldownTimeRemaining() <= 0 then
			self.wtf_mode = true
		else
			self.wtf_mode = false
			self:EndCooldown()
		end
	end
end

----------------------------
-- NETHER STRIKE MODIFIER --
----------------------------

-- Not using this modifier for anything vanilla...guess I'll make an IMBAfication
-- IMBAfication: BIG DICK ENERGY
function modifier_imba_spirit_breaker_nether_strike:IsHidden()		return true end
function modifier_imba_spirit_breaker_nether_strike:IsPurgable()	return false end

function modifier_imba_spirit_breaker_nether_strike:OnCreated()
	self.big_dmg_reduction	= self:GetAbility():GetSpecialValueFor("big_dmg_reduction")
end

function modifier_imba_spirit_breaker_nether_strike:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	
	return decFuncs
end

function modifier_imba_spirit_breaker_nether_strike:GetModifierIncomingDamage_Percentage()
	return self.big_dmg_reduction
end

-----------------------------------
-- NETHER STRIKE VISION MODIFIER --
-----------------------------------

function modifier_imba_spirit_breaker_nether_strike_vision:IgnoreTenacity()	return true end
function modifier_imba_spirit_breaker_nether_strike_vision:IsHidden()	return true end
function modifier_imba_spirit_breaker_nether_strike_vision:IsPurgable()	return false end
function modifier_imba_spirit_breaker_nether_strike_vision:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_spirit_breaker_nether_strike_vision:DeclareFunctions()
	return {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
end

function modifier_imba_spirit_breaker_nether_strike_vision:GetModifierProvidesFOWVision()
	return 1
end

-----------------------------------------
-- NETHER STRIKE PLANESWALKER MODIFIER --
-----------------------------------------

function modifier_imba_spirit_breaker_nether_strike_planeswalker:IsPurgable()	return false end

function modifier_imba_spirit_breaker_nether_strike_planeswalker:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash_trail_base.vpcf"
end

function modifier_imba_spirit_breaker_nether_strike_planeswalker:OnCreated()
	if not IsServer() then return end
	
	local planeswalker_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_planeswalker_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(planeswalker_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	
	self:AddParticle(planeswalker_particle, false, false, -1, false, false)
end

function modifier_imba_spirit_breaker_nether_strike_planeswalker:OnDestroy()
	if not IsServer() or not self:GetAbility() then return end

	self:GetAbility():EndCooldown()
	
	if not self:GetAbility().wtf_mode then
		self:GetAbility():StartCooldown(math.max(self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel() - 1) - self:GetElapsedTime(), 0))
	end
end

-----------------------------------------------
-- NETHER STRIKE PLANESWALKER ENEMY MODIFIER --
-----------------------------------------------

function modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy:IgnoreTenacity()	return true end
function modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy:IsPurgable()		return false end
function modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy:OnCreated()
	if not IsServer() then return end
	
	local enemy_planeswalker_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_nether_strike_planeswalker.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(enemy_planeswalker_particle, false, false, -1, false, false)
end

function modifier_imba_spirit_breaker_nether_strike_planeswalker_enemy:CheckState()
	local state = {[MODIFIER_STATE_PROVIDES_VISION] = true}

	return state
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_spirit_breaker_charge_speed", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_spirit_breaker_bonus_health", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_spirit_breaker_bash_chance", "components/abilities/heroes/hero_spirit_breaker", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_spirit_breaker_charge_speed					= class({})
modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown			= class({})
modifier_special_bonus_imba_spirit_breaker_bonus_health					= class({})
modifier_special_bonus_imba_spirit_breaker_bash_chance					= modifier_special_bonus_imba_spirit_breaker_bash_chance or class({})

function modifier_special_bonus_imba_spirit_breaker_charge_speed:IsHidden() 		return true end
function modifier_special_bonus_imba_spirit_breaker_charge_speed:IsPurgable() 		return false end
function modifier_special_bonus_imba_spirit_breaker_charge_speed:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown:IsHidden() 		return true end
function modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_spirit_breaker_bonus_health:IsHidden() 		return true end
function modifier_special_bonus_imba_spirit_breaker_bonus_health:IsPurgable() 		return false end
function modifier_special_bonus_imba_spirit_breaker_bonus_health:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_spirit_breaker_bash_chance:IsHidden() 		return true end
function modifier_special_bonus_imba_spirit_breaker_bash_chance:IsPurgable() 		return false end
function modifier_special_bonus_imba_spirit_breaker_bash_chance:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_spirit_breaker_bonus_health:OnCreated()
	self.bonus_health	= self:GetParent():FindTalentValue("special_bonus_imba_spirit_breaker_bonus_health")
end

function modifier_special_bonus_imba_spirit_breaker_bonus_health:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HEALTH_BONUS
    }

    return decFuncs
end

function modifier_special_bonus_imba_spirit_breaker_bonus_health:GetModifierHealthBonus()
	return self.bonus_health
end

function imba_spirit_breaker_charge_of_darkness:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_spirit_breaker_charge_speed") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_spirit_breaker_charge_speed") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_spirit_breaker_charge_speed"), "modifier_special_bonus_imba_spirit_breaker_charge_speed", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_spirit_breaker_bonus_health") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_spirit_breaker_bonus_health") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_spirit_breaker_bonus_health"), "modifier_special_bonus_imba_spirit_breaker_bonus_health", {})
	end
end

function imba_spirit_breaker_bulldoze:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_spirit_breaker_bulldoze_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_spirit_breaker_bulldoze_cooldown"), "modifier_special_bonus_imba_spirit_breaker_bulldoze_cooldown", {})
	end
end
