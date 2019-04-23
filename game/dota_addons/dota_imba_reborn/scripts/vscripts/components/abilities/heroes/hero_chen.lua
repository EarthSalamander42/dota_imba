-- Creator:
--	   AltiV, April 21st, 2019

LinkLuaModifier("modifier_imba_chen_penitence", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_penitence_buff", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_penitence_summon", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_chen_divine_favor", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_chen_holy_persuasion", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_tracker", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_chen_holy_persuasion_teleport", "components/abilities/heroes/hero_chen", LUA_MODIFIER_MOTION_NONE)

imba_chen_penitence										= class({})
modifier_imba_chen_penitence							= class({})
modifier_imba_chen_penitence_buff						= class({})
modifier_imba_chen_penitence_summon						= class({})

imba_chen_divine_favor									= class({})
modifier_imba_chen_divine_favor							= class({})

imba_chen_holy_persuasion								= class({})
modifier_imba_chen_holy_persuasion						= class({})
modifier_imba_chen_holy_persuasion_tracker				= class({})
modifier_imba_chen_holy_persuasion_teleport				= class({})
imba_chen_test_of_faith									= class({})

imba_chen_hand_of_god									= class({})

----------------
-- PENITENCE --
----------------

function imba_chen_penitence:OnSpellStart()
	if not IsServer() then return end
	
	if self:GetCaster():GetName() == "npc_dota_hero_chen" and RollPercentage(50) then
		self:GetCaster():EmitSound("chen_chen_ability_penit_0"..RandomInt(2, 3))
	end
	
	self:GetCaster():EmitSound("Hero_Chen.PenitenceCast")
	
	local projectile =
		{
			Target 				= self:GetCursorTarget(),
			Source 				= self:GetCaster(),
			Ability 			= self,
			EffectName 			= "particles/units/heroes/hero_chen/chen_penitence_proj.vpcf",
			iMoveSpeed			= self:GetSpecialValueFor("speed"),
			vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 20,
			bProvidesVision 	= false,
			
			iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 -- Hmm...
		}
		
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_chen_penitence:OnProjectileHit_ExtraData(hTarget, vLocation, kv)
	if not IsServer() or not hTarget then return end
	
	-- Trigger spell absorb if applicable
	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	hTarget:EmitSound("Hero_Chen.PenitenceImpact")
	
	local particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:ReleaseParticleIndex(particle)
	
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_penitence", {duration = self:GetSpecialValueFor("duration")}):SetDuration(self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()), true)
end

------------------------
-- PENITENCE MODIFIER --
------------------------

function modifier_imba_chen_penitence:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_penitence_debuff.vpcf"
end

function modifier_imba_chen_penitence:OnCreated()
	if self:GetAbility() then
		self.bonus_movement_speed	= self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	end
end

function modifier_imba_chen_penitence:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		
		MODIFIER_EVENT_ON_ATTACK_START
    }

    return decFuncs
end

function modifier_imba_chen_penitence:GetModifierMoveSpeedBonus_Percentage()
    return self.bonus_movement_speed or 0
end

function modifier_imba_chen_penitence:OnAttackStart(keys)
	if not IsServer() then return end

	if keys.target == self:GetParent() then
		keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_chen_penitence_buff", {duration = 2}) -- Oh look another number not in abilityspecials..maybe put this in and buff the number?
	end
end

-----------------------------
-- PENITENCE BUFF MODIFIER --
-----------------------------

function modifier_imba_chen_penitence_buff:OnCreated()
	if self:GetAbility() then
		self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	end
end

function modifier_imba_chen_penitence_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }

    return decFuncs
end

function modifier_imba_chen_penitence_buff:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed or 0
end

-------------------------------
-- PENITENCE SUMMON MODIFIER --
-------------------------------

function modifier_imba_chen_penitence_summon:OnCreated()

end

------------------
-- DIVINE FAVOR --
------------------

function imba_chen_divine_favor:OnSpellStart()
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "heal_amp"				"25"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "heal_rate"					"7 13 19 25"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage_bonus"		"8 16 24 32"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "duration"				"8 10 12 14"
			-- }

	if not IsServer() then return end
	
	-- This can be WAY more efficient but my brain is dead right now
	if self:GetCaster():GetName() == "npc_dota_hero_chen" then
		if RollPercentage(50) then
			-- Initialize the responses table
			if not self.responses then
				self.responses =
				{
					["chen_chen_ability_holyp_01"] = 0,
					["chen_chen_move_07"] = 0
				}
			end
			
			-- Check if 120 seconds has passed betewen either of the caster responses
			if self.responses["chen_chen_ability_holyp_01"] == 0 or GameRules:GetDOTATime(true, true) - self.responses["chen_chen_ability_holyp_01"] >= 120 then
				self:GetCaster():EmitSound("chen_chen_ability_holyp_01")
				self.responses["chen_chen_ability_holyp_01"] = GameRules:GetDOTATime(true, true)
			elseif self.responses["chen_chen_move_07"] == 0 or GameRules:GetDOTATime(true, true) - self.responses["chen_chen_move_07"] >= 120 then
				self:GetCaster():EmitSound("chen_chen_move_07")
				self.responses["chen_chen_move_07"] = GameRules:GetDOTATime(true, true)
			end
		end
	end

	self:GetCaster():EmitSound("Hero_Chen.DivineFavor.Cast")

	local particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_divine_favor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:ReleaseParticleIndex(particle)
	
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_divine_favor", {duration = self:GetSpecialValueFor("duration")})
end

---------------------------
-- DIVINE FAVOR MODIFIER --
---------------------------

function modifier_imba_chen_divine_favor:GetEffectName()
	return "particles/units/heroes/hero_chen/chen_divine_favor_buff.vpcf"
end

function modifier_imba_chen_divine_favor:OnCreated()
	-- AbilitySpecials
	self.heal_amp		= self:GetAbility():GetSpecialValueFor("heal_amp")
	self.heal_rate		= self:GetAbility():GetSpecialValueFor("heal_rate")
	self.damage_bonus	= self:GetAbility():GetSpecialValueFor("damage_bonus")
end

function modifier_imba_chen_divine_favor:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }

    return decFuncs
end

function modifier_imba_chen_divine_favor:GetModifierHPRegenAmplify_Percentage()
	return self.heal_amp
end

function modifier_imba_chen_divine_favor:GetModifierConstantHealthRegen()
	return self.heal_rate
end

function modifier_imba_chen_divine_favor:GetModifierPreAttack_BonusDamage()
	if self:GetParent():IsCreep() then
		return self.damage_bonus * 3 -- once again, AbilitySpecial
	else
		return self.damage_bonus
	end
end

---------------------
-- HOLY PERSUASION --
---------------------

--"dota_hud_error_cant_cast_creep_level"			"Ability Can't Target Creeps of This Level"

			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "max_units"				"1 2 3 4"
				-- "LinkedSpecialBonus"	"special_bonus_unique_chen_1"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "level_req"				"4 5 6 6"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "health_min"			"1000"
				-- "LinkedSpecialBonus"	"special_bonus_unique_chen_4"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "teleport_delay"	"6.0"
			-- }

function imba_chen_holy_persuasion:CastFilterResultTarget(target)
	if IsServer() then
		if target == self:GetCaster() 
		or (target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and target:IsCreep() and not target:IsRoshan())
		or (target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and (target:GetOwner() == self:GetCaster() or target:IsPlayer())) then
			return UF_SUCCESS
		else
			return UF_FAIL_OTHER
		end
	end
end

-- function imba_chen_holy_persuasion:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

function imba_chen_holy_persuasion:OnUpgrade()
	if not IsServer() then return end
	
	if self:GetLevel() == self:GetMaxLevel() and self:GetCaster():GetName() == "npc_dota_hero_chen" then
		self:GetCaster():EmitSound("chen_chen_item_04")
	end
end

function imba_chen_holy_persuasion:OnSpellStart()
	if not IsServer() then return end
	
	local target	= self:GetCursorTarget()
	
	-- Enemy logic
	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
	-- if (not target:IsConsideredHero() and not target:IsRoshan() then	
		
		-- Play the standard Holy Persuasion sounds
		self:GetCaster():EmitSound("Hero_Chen.HolyPersuasionCast")
		target:EmitSound("Hero_Chen.HolyPersuasionEnemy")
		
		-- Basic dispel (buffs and debuffs)
		target:Purge(true, true, false, false, false)
		
		-- SUPER JANK LANE CREEP SWITCHAROO TO BYPASS LANE AI
		if string.find(target:GetUnitName(), "guys_") then
			local lane_creep_name = target:GetUnitName()
			
			local new_lane_creep = CreateUnitByName(target:GetUnitName(), target:GetAbsOrigin(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			-- Copy the relevant stats over to the creep
			new_lane_creep:SetBaseMaxHealth(target:GetMaxHealth())
			new_lane_creep:SetHealth(target:GetHealth())
			new_lane_creep:SetBaseDamageMin(target:GetBaseDamageMin())
			new_lane_creep:SetBaseDamageMax(target:GetBaseDamageMax())
			new_lane_creep:SetMinimumGoldBounty(target:GetGoldBounty())
			new_lane_creep:SetMaximumGoldBounty(target:GetGoldBounty())			
			UTIL_Remove(target)
			target = new_lane_creep
		end
		
		-- Particle effects
		local particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		
		-- "When the unit's maximum health is below the minimum health threshold, its maximum and current health are increased by the difference."
		if target:GetMaxHealth() < self:GetSpecialValueFor("health_min") then
			local health_difference = self:GetSpecialValueFor("health_min") - target:GetMaxHealth()
			target:SetBaseMaxHealth(target:GetMaxHealth() + health_difference)
			target:SetHealth(target:GetHealth() + health_difference)
		end
		
		-- Transfer ownership over to Chen
		target:SetOwner(self:GetCaster())
		target:SetTeam(self:GetCaster():GetTeam())
		target:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)

		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion", {})
		local persuasion_tracker_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_tracker", {})
		persuasion_tracker_modifier.creep	= target

		-- Get the total number of persuaded creeps (and ancient persuaded ancient creeps) Chen currently has
		local persuaded_creeps_modifiers		= self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker")
		local persuaded_creeps_count			= #persuaded_creeps_modifiers
		local persuaded_ancient_creeps_count	= 0
		-- Keep a reference to the first ancient creep in case it needs to be force killed for over-capacity
		local first_ancient_creep				= nil
		local first_ancient_creep_modifier		= nil
		
		for _, modifier in pairs(persuaded_creeps_modifiers) do
			-- Why is this not tracking the creep variable?
			if modifier.creep:IsAncient() then
				persuaded_ancient_creeps_count	= persuaded_ancient_creeps_count + 1
				
				if persuaded_ancient_creeps_count == 1 then
					first_ancient_creep				= modifier.creep
					first_ancient_creep_modifier	= modifier
				end
			end
		end

		-- If the total amount of persuaded ancient creeps exceeds the max limit (and all the ability checks passed), force kill the oldest one and remove it from the table
		if self:GetCaster():HasScepter() then
			local hand_of_god_ability = self:GetCaster():FindAbilityByName("imba_chen_hand_of_god")
			
			if hand_of_god_ability and hand_of_god_ability:IsTrained() and target:IsAncient() and persuaded_ancient_creeps_count > hand_of_god_ability:GetSpecialValueFor("ancient_creeps_scepter") then
				first_ancient_creep:ForceKill(false)
				first_ancient_creep_modifier:Destroy()
			end
		-- If the total amount of persuaded creeps exceeds the max limit, force kill the oldest one and remove it from the table
		elseif persuaded_creeps_count > self:GetTalentSpecialValueFor("max_units") and self.persuaded_creeps_table[1] then
			persuaded_creeps_modifiers[1].creep:ForceKill(false)
			persuaded_creeps_modifiers[1]:Destroy()
		end 

		--target:AddNewModifier(self:GetCaster(), self, "modifier_dominated", {}) -- This didn't work for me
	else -- Same-team logic
		-- Self target
		if target	== self:GetCaster() then
			
		-- Ally target
		else
			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_chen_holy_persuasion_teleport", {duration = self:GetSpecialValueFor("teleport_delay")})
		end
	end
end

------------------------------
-- HOLY PERSUASION MODIFIER --
------------------------------

function modifier_imba_chen_holy_persuasion:IsDebuff()		return false end
function modifier_imba_chen_holy_persuasion:IsPurgable()	return false end
function modifier_imba_chen_holy_persuasion:RemoveOnDeath()	return false end

-- OnCreated and OnIntervalThink purely for stupid Rubick/Morphling exceptions
function modifier_imba_chen_holy_persuasion:OnCreated()
	if not IsServer() then return end
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_chen_holy_persuasion:OnIntervalThink()
	if not IsServer() then return end
	
	if not self:GetCaster() or not self:GetAbility() then
		self:GetParent():ForceKill(false)
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_imba_chen_holy_persuasion:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_DEATH
    }

    return decFuncs
end

-- If the persuaded creep dies, remove the relevant modifier from the caster as well
function modifier_imba_chen_holy_persuasion:OnDeath(keys)
	if not IsServer() then return end
	
	if keys.victim == self:GetParent() then
		local persuaded_creeps_modifiers		= self:GetCaster():FindAllModifiersByName("modifier_imba_chen_holy_persuasion_tracker")
		
		for _, modifier in pairs(persuaded_creeps_modifiers) do
			if modifier.creep == self:GetParent() then
				modifier:Destroy()
				self:Destroy()
				break
			end
		end
	end
end

---------------------------------------
-- HOLY PERSUASION TRACKER MODIFIER --
---------------------------------------

function modifier_imba_chen_holy_persuasion_tracker:IsHidden()		return false end -- change to true when done testing
function modifier_imba_chen_holy_persuasion_tracker:IsPurgable()	return false end
function modifier_imba_chen_holy_persuasion_tracker:RemoveOnDeath()	return false end
function modifier_imba_chen_holy_persuasion_tracker:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

---------------------------------------
-- HOLY PERSUASION TELEPORT MODIFIER --
---------------------------------------

function modifier_imba_chen_holy_persuasion_teleport:OnCreated()
	self.distance	= 120 -- Something something HELLO ABILITYSPECIAL???
end

function modifier_imba_chen_holy_persuasion_teleport:OnDestroy()
	if not IsServer() then return end
	
	-- The full duration has passed, and the teleport has succeeded
	if self:GetRemainingTime() <= 0 then
		local caster_position	= self:GetCaster():GetAbsOrigin()
		
		if self:GetAbility() and self:GetCaster() and self:GetCaster():IsAlive() then
			
			-- If the initial teleport vector for the ability hasn't been set yet, do so now (starts North)
			if self:GetAbility().teleport_vector then
				self:GetAbility().teleport_vector = Vector(0, self.distance, 0)
			end
			
			-- Teleport the parent to the caster's position + the teleport vector
			self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + self:GetAbility().teleport_vector)
			
			-- Rotate the teleport vector 90 degrees clockwise to use for the next unit that gets ported
			self:GetAbility().teleport_vector = RotatePosition(Vector(0, 0, 0), QAngle(0, -90, 0), self:GetAbility().teleport_vector)
		end
	end
end

-------------------
-- TEST OF FAITH --
-------------------

function imba_chen_test_of_faith:OnSpellStart()

end

-----------------
-- HAND OF GOD --
-----------------

function imba_chen_hand_of_god:OnSpellStart()
	if not IsServer() then return end
	
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
	
	local voiceline = nil
	
	if self:GetCaster():GetName() == "npc_dota_hero_chen" then
		local voiceline = "chen_chen_ability_handgod_0"..RandomInt(1, 3)
	end
	
	for _, ally in pairs(allies) do
		if ally:IsPlayer() or ally:IsClone() or ally:GetOwner() == self:GetCaster() then
			
			-- Let's try not to blow up eardrums
			if voiceline and ally:IsRealHero() and ally:GetPlayerOwner() then
				EmitSoundOnClient(voiceline, ally:GetPlayerOwner())
			end

			if ally:IsRealHero() then
				ally:EmitSound("Hero_Chen.HandOfGodHealHero")
			elseif ally:IsCreep() then
				ally:EmitSound("Hero_Chen.HandOfGodHealCreep")
			end

			--This has CP60 and 61 for colours...HMM...
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, ally)
			ParticleManager:ReleaseParticleIndex(particle)
	
			ally:Heal(self:GetTalentSpecialValueFor("heal_amount"), self:GetCaster())
		end
	end
end



-- ----------------
-- -- INNER FIRE --
-- ----------------

-- function imba_huskar_inner_fire:OnSpellStart()
	-- if not IsServer() then return end

	-- local damage				= self:GetSpecialValueFor("damage")
	-- local radius				= self:GetSpecialValueFor("radius")
	-- local disarm_duration		= self:GetSpecialValueFor("disarm_duration")
	-- local knockback_distance	= self:GetSpecialValueFor("knockback_distance")
	-- local knockback_duration	= self:GetSpecialValueFor("knockback_duration")

	-- local raze_land_duration	= self:GetSpecialValueFor("raze_land_duration")
	
	-- -- Emit sound
	-- self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")
	
	-- -- Particle effects
	-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_POINT, self:GetCaster())
	-- ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	-- ParticleManager:SetParticleControl(particle, 3, self:GetCaster():GetAbsOrigin())
	-- ParticleManager:ReleaseParticleIndex(particle)
	
	-- -- Find enemies in the radius
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- -- "Inner Fire first applies the damage, then the debuffs."
	-- for _, enemy in pairs(enemies) do
		-- local damageTable = {
			-- victim 			= enemy,
			-- damage 			= damage,
			-- damage_type		= DAMAGE_TYPE_MAGICAL,
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
		-- }
		
		-- ApplyDamage(damageTable)
		
		-- -- Apply the knockback (and pass the caster's location coordinates to know which way to knockback)
		-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_knockback", {duration = knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
		
		-- -- Apply the disarm
		-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_disarm", {duration = disarm_duration})
	-- end
	
	-- -- IMBAfication: Raze Land
	-- CreateModifierThinker(self:GetCaster(), self, "modifier_imba_huskar_inner_fire_raze_land_aura", {
		-- duration		= raze_land_duration
	-- }, 
	-- self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
-- end

-- -----------------------------------
-- -- INNER FIRE KNOCKBACK MODIFIER --
-- -----------------------------------

-- function modifier_imba_huskar_inner_fire_knockback:IsHidden() return true end

-- function modifier_imba_huskar_inner_fire_knockback:OnCreated(params)
	-- if not IsServer() then return end
	
	-- self.ability				= self:GetAbility()
	-- self.caster					= self:GetCaster()
	-- self.parent					= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.knockback_duration		= self.ability:GetSpecialValueFor("knockback_duration")
	-- -- Knockbacks a set distance, so change this value based on distance from caster and parent
	-- self.knockback_distance		= math.max(self.ability:GetSpecialValueFor("knockback_distance") - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 50)
	
	-- -- Calculate speed at which modifier owner will be knocked back
	-- self.knockback_speed		= self.knockback_distance / self.knockback_duration
	
	-- -- Get the center of the Blinding Light sphere to know which direction to get knocked back
	-- self.position	= GetGroundPosition(Vector(params.x, params.y, 0), nil)
	
	-- if self:ApplyHorizontalMotionController() == false then 
		-- self:Destroy()
		-- return
	-- end
-- end

-- function modifier_imba_huskar_inner_fire_knockback:UpdateHorizontalMotion( me, dt )
	-- if not IsServer() then return end

	-- local distance = (me:GetOrigin() - self.position):Normalized()
	
	-- me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
	
	-- -- Destroy any trees passed through
	-- GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
-- end

-- function modifier_imba_huskar_inner_fire_knockback:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_inner_fire_knockback:GetOverrideAnimation()
	 -- return ACT_DOTA_FLAIL
-- end

-- function modifier_imba_huskar_inner_fire_knockback:OnDestroy()
	-- if not IsServer() then return end
	
	-- self.parent:RemoveHorizontalMotionController( self )
-- end

-- --------------------------------
-- -- INNER FIRE DISARM MODIFIER --
-- --------------------------------

-- function modifier_imba_huskar_inner_fire_disarm:GetEffectName()
	-- return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
-- end

-- function modifier_imba_huskar_inner_fire_disarm:GetEffectAttachType()
	-- return PATTACH_OVERHEAD_FOLLOW
-- end

-- function modifier_imba_huskar_inner_fire_disarm:CheckState()
	-- return {[MODIFIER_STATE_DISARMED] = true}
-- end

-- -----------------------------------
-- -- INNER FIRE RAZE LAND MODIFIER --
-- -----------------------------------

-- function modifier_imba_huskar_inner_fire_raze_land:GetEffectName()
	-- return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
-- end

-- function modifier_imba_huskar_inner_fire_raze_land:OnCreated()
	-- self.raze_land_strength_pct	= self:GetAbility():GetSpecialValueFor("raze_land_strength_pct")
	
	-- if not IsServer() then return end
	
	-- self.damage		= self:GetCaster():GetStrength() * self.raze_land_strength_pct * 0.01
	
	-- self:OnIntervalThink()
	-- self:StartIntervalThink(0.5)
-- end

-- function modifier_imba_huskar_inner_fire_raze_land:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- -- Update strength damage periodically if the caster still exists
	-- if self:GetCaster() then
		-- self.damage		= self:GetCaster():GetStrength() * self.raze_land_strength_pct * 0.01
	-- end
	
	-- local damageTable = {
		-- victim 			= self:GetParent(),
		-- attacker 		= self:GetCaster(),
		-- damage 			= self.damage,
		-- damage_type 	= DAMAGE_TYPE_MAGICAL,
		-- ability 		= self:GetAbility(),
		-- damage_flags	= DOTA_DAMAGE_FLAG_NONE
	-- }
	-- ApplyDamage(damageTable)

	-- -- Apply burning spear stacks if applicable
	-- local burning_spears_ability = self:GetCaster():FindAbilityByName("imba_huskar_burning_spear")
	
	-- if burning_spears_ability and burning_spears_ability:IsTrained() then
		-- self:GetParent():AddNewModifier(self:GetCaster(), burning_spears_ability, "modifier_imba_huskar_burning_spear_debuff", { duration = burning_spears_ability:GetDuration() })
		-- self:GetParent():AddNewModifier(self:GetCaster(), burning_spears_ability, "modifier_imba_huskar_burning_spear_counter", { duration = burning_spears_ability:GetDuration() })
	-- end
-- end

-- ----------------------------------------
-- -- INNER FIRE RAZE LAND AURA MODIFIER --
-- ----------------------------------------

-- function modifier_imba_huskar_inner_fire_raze_land_aura:IsAura() 				return true end

-- function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraRadius()			return self:GetAbility():GetSpecialValueFor("radius") end
-- function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
-- function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
-- function modifier_imba_huskar_inner_fire_raze_land_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_imba_huskar_inner_fire_raze_land_aura:GetModifierAura()		return "modifier_imba_huskar_inner_fire_raze_land" end

-- function modifier_imba_huskar_inner_fire_raze_land_aura:OnCreated()
	-- self.radius						= self:GetAbility():GetSpecialValueFor("radius")
	-- self.raze_land_damage_interval	= self:GetAbility():GetSpecialValueFor("raze_land_damage_interval")
	
	-- if not IsServer() then return end
	-- -- Man I am so garbage with particles
	-- self.particle = ParticleManager:CreateParticle("particles/hero/huskar/huskar_inner_fire_raze_land.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- self:StartIntervalThink(self.raze_land_damage_interval)
-- end

-- function modifier_imba_huskar_inner_fire_raze_land_aura:OnIntervalThink()
	-- GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )
	
	-- local wards = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	-- for _, ward in pairs(wards) do
		-- if ward:GetUnitName() == "npc_dota_observer_wards" or ward:GetUnitName() == "npc_dota_sentry_wards" then
			-- ward:Kill(self:GetAbility(), self:GetCaster())
		-- end
	-- end
-- end

-- -------------------
-- -- BURNING SPEAR --
-- -------------------

-- function imba_huskar_burning_spear:GetIntrinsicModifierName()
	-- return "modifier_generic_orb_effect_lua"
-- end

-- function imba_huskar_burning_spear:GetProjectileName()
	-- return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
-- end

-- function imba_huskar_burning_spear:GetAbilityTargetFlags()
	-- if self:GetCaster():HasTalent("special_bonus_imba_huskar_pure_burning_spears") then
		-- return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	-- else
		-- return DOTA_UNIT_TARGET_FLAG_NONE
	-- end
-- end

-- function imba_huskar_burning_spear:OnOrbFire()
	-- self:GetCaster():EmitSound("Hero_Huskar.Burning_Spear.Cast")
	
	-- -- Vanilla version doesn't actually show Huskar taking damage so I assume it's a SetHealth thing
	-- self:GetCaster():SetHealth(math.max(self:GetCaster():GetHealth() - self:GetSpecialValueFor("health_cost"), 1))
-- end

-- function imba_huskar_burning_spear:OnOrbImpact( keys )
	-- local duration = self:GetDuration()
	
	-- keys.target:EmitSound("Hero_Huskar.Burning_Spear")
	
	-- keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_burning_spear_debuff", { duration = duration })
	-- keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_burning_spear_counter", { duration = duration })
-- end

-- ------------------------------------
-- -- BURNING SPEAR COUNTER MODIFIER --
-- ------------------------------------

-- -- This will be the visible, non-multiple, stacking modifier
-- function modifier_imba_huskar_burning_spear_counter:IgnoreTenacity()	return true end
-- function modifier_imba_huskar_burning_spear_counter:IsPurgable()		return false end

-- function modifier_imba_huskar_burning_spear_counter:GetEffectName()
	-- return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnCreated()
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()

	-- self.burn_damage 				= self:GetAbility():GetSpecialValueFor("burn_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_huskar_2")
	-- self.pain_reflection_per_stack	= self:GetAbility():GetSpecialValueFor("pain_reflection_per_stack")

	-- self.damage_type = DAMAGE_TYPE_MAGICAL
	
	-- if self:GetCaster() and self:GetCaster():HasTalent("special_bonus_unique_huskar_5") then
		-- self.damage_type = DAMAGE_TYPE_PURE
	-- end

	-- -- Precache damage table
	-- self.damageTable = {
		-- victim = self:GetParent(),
		-- attacker = self:GetCaster(),
		-- -- damage = to be handled in the intervalthink due to stacks
		-- -- damage_type = to be handled in the intervalthink due to potential talent switch
		-- ability = self:GetAbility()
	-- }
	
	-- self:StartIntervalThink(1)
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnRefresh()
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnIntervalThink()
	-- if not IsServer() then return end

	-- -- Dumb nil checks that should never happen in an actual game
	-- if self:GetAbility() and self:GetCaster() then
		-- self.burn_damage 				= self:GetAbility():GetSpecialValueFor("burn_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_huskar_2")
		
		-- self.damage_type = DAMAGE_TYPE_MAGICAL
		
		-- if self:GetCaster() and self:GetCaster():HasTalent("special_bonus_unique_huskar_5") then
			-- self.damage_type = DAMAGE_TYPE_PURE
		-- end
	-- end
	
	-- self.damageTable.damage 		= self:GetStackCount() * self.burn_damage
	-- self.damageTable.damage_type	= self.damage_type

	-- ApplyDamage( self.damageTable )
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():StopSound("Hero_Huskar.Burning_Spear")
-- end

-- function modifier_imba_huskar_burning_spear_counter:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE, -- IMBAfication: Know My Pain!
		-- MODIFIER_PROPERTY_TOOLTIP,
		-- MODIFIER_PROPERTY_TOOLTIP2
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnTakeDamage(keys)
	-- if not IsServer() then return end
	
	-- -- No infinite loops plz
	-- if keys.unit == self:GetCaster() and bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION then
	
		-- -- Might be too obnoxious if played a billion times
		-- -- self:GetParent():EmitSound("DOTA_Item.BladeMail.Damage")
		
		-- local damageTable = {
			-- victim 			= self:GetParent(),
			-- damage 			= keys.original_damage * (self:GetStackCount() * self.pain_reflection_per_stack * 0.01),
			-- damage_type		= keys.damage_type,
			-- damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self:GetAbility()
		-- }
								
		-- ApplyDamage(damageTable)
	-- end
-- end

-- function modifier_imba_huskar_burning_spear_counter:OnTooltip()
	-- return self:GetStackCount() * self.pain_reflection_per_stack
-- end

-- -----------------------------------
-- -- BURNING SPEAR DEBUFF MODIFIER --
-- -----------------------------------

-- -- This will be the hidden, multiple, non-stacking modifier

-- function modifier_imba_huskar_burning_spear_debuff:IgnoreTenacity()	return true end
-- function modifier_imba_huskar_burning_spear_debuff:IsHidden() 		return true end
-- function modifier_imba_huskar_burning_spear_debuff:IsPurgable()		return false end
-- function modifier_imba_huskar_burning_spear_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_huskar_burning_spear_debuff:OnDestroy()
	-- if not IsServer() then return end
	
	-- local burning_spear_counter = self:GetParent():FindModifierByNameAndCaster("modifier_imba_huskar_burning_spear_counter", self:GetCaster())
	
	-- if burning_spear_counter then
		-- burning_spear_counter:DecrementStackCount()
	-- end
-- end

-- -----------------------
-- -- BERSERKER'S BLOOD --
-- -----------------------

-- -- IMBAfication: Crimson Priest
-- function imba_huskar_berserkers_blood:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- -- Crimson Priest IMBAfication will be an "opt-out" add-on
-- function imba_huskar_berserkers_blood:OnUpgrade()
	-- if self:GetLevel() == 1 then
		-- self:ToggleAutoCast()
	-- end
-- end

-- -- Not castable
-- function imba_huskar_berserkers_blood:OnAbilityPhaseStart() return false end

-- function imba_huskar_berserkers_blood:GetIntrinsicModifierName()
	-- return "modifier_imba_huskar_berserkers_blood"
-- end

-- --------------------------------
-- -- BERSERKER'S BLOOD MODIFIER --
-- --------------------------------

-- function modifier_imba_huskar_berserkers_blood:IsHidden()	return true end
	
-- function modifier_imba_huskar_berserkers_blood:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.maximum_attack_speed		= self.ability:GetSpecialValueFor("maximum_attack_speed")
	-- self.maximum_health_regen		= self.ability:GetSpecialValueFor("maximum_health_regen")
	-- self.hp_threshold_max 			= self.ability:GetSpecialValueFor("hp_threshold_max")
	-- self.maximum_resistance 		= self.ability:GetSpecialValueFor("maximum_resistance")
	-- self.crimson_priest_duration	= self.ability:GetSpecialValueFor("crimson_priest_duration")
	
	-- self.range 					= 100 - self.hp_threshold_max
	
	-- -- Max size in pct that Huskar increases to
	-- self.max_size = 35
	
	-- if not IsServer() then return end
	
	-- -- Create the Berserker's Blood particle (glow + heal)
	-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	
	-- -- Create the "blood" particle (big thanks to DarkDice from ModDota for making this for me; as he said, it's not perfect, but it looks much better than the stupid color render solution I was using before)
	-- -- ...Now only if he could show me how to get it to actually work in-game
	-- -- self.particle2 = ParticleManager:CreateParticle("particles/hero/huskar/status_effect_berserker_blood_mod.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	
	-- self:StartIntervalThink(0.1)
-- end

-- -- When the ability gets leveled up
-- function modifier_imba_huskar_berserkers_blood:OnRefresh()
	-- -- AbilitySpecials
	-- self.maximum_attack_speed		= self.ability:GetSpecialValueFor("maximum_attack_speed")
	-- self.maximum_health_regen		= self.ability:GetSpecialValueFor("maximum_health_regen")
	-- self.hp_threshold_max 			= self.ability:GetSpecialValueFor("hp_threshold_max")
	-- self.maximum_resistance 		= self.ability:GetSpecialValueFor("maximum_resistance")
	-- self.crimson_priest_duration	= self.ability:GetSpecialValueFor("crimson_priest_duration")
	
	-- self.range 						= 100 - self.hp_threshold_max
-- end

-- function modifier_imba_huskar_berserkers_blood:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- -- Use the stack count to store strength value for proper client/server interaction
	-- self:SetStackCount(self.parent:GetStrength())
-- end

-- -- Realistically speaking, this function will never be called...but just in case...
-- function modifier_imba_huskar_berserkers_blood:OnDestroy()
	-- if not IsServer() then return end

	-- ParticleManager:DestroyParticle(self.particle, false)
	-- ParticleManager:ReleaseParticleIndex(self.particle)
	
	-- -- ParticleManager:DestroyParticle(self.particle2, false)
	-- -- ParticleManager:ReleaseParticleIndex(self.particle2)
-- end

-- function modifier_imba_huskar_berserkers_blood:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_MODEL_SCALE,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		
		-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, -- IMBAfication: Remnants of Berserker's Blood
		-- MODIFIER_PROPERTY_MIN_HEALTH,				-- IMBAfication: Crimson Priest
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
	-- }

	-- return funcs
-- end

-- function modifier_imba_huskar_berserkers_blood:GetModifierAttackSpeedBonus_Constant()
	-- if self.parent:PassivesDisabled() then return end

	-- -- This percentage gets lower as health drops, which in turn increases the returned value
	-- local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	-- return self.maximum_attack_speed * (1 - pct)
-- end

-- function modifier_imba_huskar_berserkers_blood:GetModifierConstantHealthRegen()
	-- if self.parent:PassivesDisabled() then return end

	-- local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	-- -- Strength * max health regen value pct converted to decimal * the reverse range
	-- return self:GetStackCount() * self.maximum_health_regen  * 0.01 * (1 - pct)
-- end

-- -- This doesn't change if the modifier owner is broken
-- function modifier_imba_huskar_berserkers_blood:GetModifierModelScale()
	-- if not IsServer() then return end
	
	-- local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)

	-- -- Glow / regen particles are controlled by CP1 of the particle
	-- ParticleManager:SetParticleControl(self.particle, 1, Vector( (1 - pct) * 100, 0, 0))
	
	-- -- I haven't seen any examples of how to replicate the blood particles (and can't figure it myself) so time for massive bootleg instead	
	-- self.parent:SetRenderColor(255, 255 * pct, 255 * pct)
	
	-- -- Let's use DarkDice's particles (seems to work through a scaling CP0 second value from 0 to 1.4)
	-- -- ParticleManager:SetParticleControlEnt(self.particle2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector( 0, 1.4 * (1 - pct), 0), true)
	-- -- return self.max_size * (1 - pct)
-- end

-- function modifier_imba_huskar_berserkers_blood:GetActivityTranslationModifiers()
	-- return "berserkers_blood"
-- end

-- function modifier_imba_huskar_berserkers_blood:GetModifierMagicalResistanceBonus()
	-- local pct = math.max((self.parent:GetHealthPercent() - self.hp_threshold_max) / self.range, 0)
	
	-- return self.maximum_resistance * (1 - pct)
-- end

-- function modifier_imba_huskar_berserkers_blood:GetMinHealth()
	-- if (self:GetAbility():GetAutoCastState() and self:GetAbility():IsCooldownReady()) or self:GetParent():HasModifier("modifier_imba_huskar_berserkers_blood_crimson_priest") then
		-- return 1
	-- else
		-- return 0
	-- end
-- end

-- function modifier_imba_huskar_berserkers_blood:OnTakeDamage(keys)
	-- if not IsServer() then return end
	
	-- -- Don't waste it if caster has Shallow Grave or Cheese Death Prevention
	-- if keys.unit == self.caster and self.caster:GetHealth() <= 1 and (self.ability:GetAutoCastState() and self.ability:IsCooldownReady()) and not self.caster:PassivesDisabled() and not self.caster:HasModifier("modifier_imba_dazzle_shallow_grave") and not self.caster:HasModifier("modifier_imba_dazzle_nothl_protection_aura_talent") and not self.caster:HasModifier("modifier_imba_cheese_death_prevention") and not self.caster:HasModifier("modifier_imba_huskar_berserkers_blood_crimson_priest") then
		-- self.ability:UseResources(false, false, true)
	
		-- self.caster:EmitSound("Hero_Dazzle.Shallow_Grave")
		-- self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_berserkers_blood_crimson_priest", {duration = self.crimson_priest_duration})
	-- end
-- end

-- -----------------------------------------------
-- -- BERSERKER'S BLOOD CRIMSON PRIEST MODIFIER --
-- -----------------------------------------------

-- function modifier_imba_huskar_berserkers_blood_crimson_priest:IsPurgable()	return false end

-- function modifier_imba_huskar_berserkers_blood_crimson_priest:GetEffectName()
	-- return "particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold.vpcf"
-- end

-- function modifier_imba_huskar_berserkers_blood_crimson_priest:OnDestroy()
	-- if not IsServer() then return end

	-- self:GetCaster():StopSound("Hero_Dazzle.Shallow_Grave")
-- end

-- --------------------
-- -- INNER VITALITY --
-- --------------------

-- -- Self leveling function (since this is technically a completely separate ability)
-- function imba_huskar_inner_vitality:OnHeroLevelUp()
	-- self:SetLevel(min(math.floor(self:GetCaster():GetLevel() / 3), 4))
-- end

-- function imba_huskar_inner_vitality:OnSpellStart()
	-- if not IsServer() then return end
	
	-- self:GetCursorTarget():EmitSound("Hero_Huskar.Inner_Vitality")

	-- self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_inner_vitality", {duration = self:GetDuration()})
-- end

-- -----------------------------
-- -- INNER VITALITY MODIFIER --
-- -----------------------------

-- function modifier_imba_huskar_inner_vitality:GetEffectName()
	-- return "particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf"
-- end

-- function modifier_imba_huskar_inner_vitality:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.heal				= self.ability:GetSpecialValueFor("heal")
	-- self.attrib_bonus		= self.ability:GetSpecialValueFor("attrib_bonus")
	-- self.hurt_attrib_bonus	= self.ability:GetSpecialValueFor("hurt_attrib_bonus")
	-- self.hurt_percent		= self.ability:GetSpecialValueFor("hurt_percent")
	
	-- self.final_stand_hp_threshold	= self.ability:GetSpecialValueFor("final_stand_hp_threshold")
	-- self.final_stand_status_resist	= self.ability:GetSpecialValueFor("final_stand_status_resist")
	
	-- if not IsServer() then return end
	
	-- self.primary_stat_regen	= 0
	
	-- -- Check if the target has a primary attribute (creep-heroes typically do not, so they only benefit from the base heal value)
	-- if self.parent.GetPrimaryStatValue then
		-- -- If they are healthy, use the standard attribute bonus
		-- if self.parent:GetHealthPercent() > self.hurt_percent * 100 then
			-- self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.attrib_bonus
		-- -- If they are under the threshold, use the hurt attribute bonus
		-- else
			-- self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.hurt_attrib_bonus
		-- end
	-- end
	
	-- -- Set the final heal regen value as a stack so we don't have client/server issues as per usual
	-- -- Multiplying by 10 to divide by 10 later for decimal place regen
	-- self:SetStackCount((self.heal + self.primary_stat_regen) * 10)
	
	-- self:StartIntervalThink(1)
-- end

-- -- Repeats the stat regen calculation part every second
-- function modifier_imba_huskar_inner_vitality:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- if self.parent.GetPrimaryStatValue then
		-- if self.parent:GetHealthPercent() > self.hurt_percent * 100 then
			-- self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.attrib_bonus
		-- else
			-- self.primary_stat_regen = self.parent:GetPrimaryStatValue() * self.hurt_attrib_bonus
		-- end
	-- end
	
	-- self:SetStackCount((self.heal + self.primary_stat_regen) * 10)
-- end

-- function modifier_imba_huskar_inner_vitality:OnDestroy()
	-- if not IsServer() then return end
	
	-- self.parent:StopSound("Hero_Huskar.Inner_Vitality")
-- end

-- function modifier_imba_huskar_inner_vitality:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING	-- IMBAfication: Final Stand
	-- }

	-- return funcs
-- end

-- function modifier_imba_huskar_inner_vitality:GetModifierConstantHealthRegen()
	-- return self:GetStackCount() * 0.1
-- end

-- function modifier_imba_huskar_inner_vitality:GetModifierStatusResistanceStacking()
	-- if self.parent:GetHealthPercent() < self.final_stand_hp_threshold then
		-- return self.final_stand_status_resist
	-- end
-- end

-- ----------------
-- -- LIFE BREAK --
-- ----------------

-- function imba_huskar_life_break:CastFilterResultTarget(target)
	-- if IsServer() then
		-- if target == self:GetCaster() and self:GetAutoCastState() then
			-- return UF_SUCCESS
		-- end
		
		-- local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		-- return nResult
	-- end
-- end

-- function imba_huskar_life_break:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_huskar_life_break:GetCastRange(location, target)
	-- if IsClient() then
		-- return self.BaseClass.GetCastRange(self, location, target)
	-- else
		-- return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_unique_huskar")
	-- end
-- end

-- -- Harakiri IMBAfication will be an "opt-out" add-on
-- function imba_huskar_life_break:OnUpgrade()
	-- if self:GetLevel() == 1 then
		-- self:ToggleAutoCast()
	-- end
-- end

-- function imba_huskar_life_break:GetCooldown(level)
	-- if self:GetCaster():HasScepter() then
		-- return self:GetSpecialValueFor("cooldown_scepter")
	-- else
		-- return self.BaseClass.GetCooldown(self, level)
	-- end
-- end

-- function imba_huskar_life_break:OnSpellStart()
	-- if not IsServer() then return end

	-- self:GetCaster():EmitSound("Hero_Huskar.Life_Break")

	-- -- Applies a basic purge on caster
	-- self:GetCaster():Purge(false, true, false, false, false)

	-- -- Yeah this is a thing
	-- local life_break_charge_max_duration = 5
	
	-- -- Create Life Break standard (motion controller) and charge modifier and feed the entity index as a parameter, which will be converted back into an entity to handle targeting
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_life_break", {ent_index = self:GetCursorTarget():GetEntityIndex()})
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_huskar_life_break_charge", {duration = life_break_charge_max_duration})
-- end

-- -------------------------
-- -- LIFE BREAK MODIFIER --
-- -------------------------

-- function modifier_imba_huskar_life_break:IsHidden()		return true end
-- function modifier_imba_huskar_life_break:IsPurgable()	return false end

-- function modifier_imba_huskar_life_break:OnCreated(params)
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()

	-- -- AbilitySpecials
	-- self.health_cost_percent	= self.ability:GetSpecialValueFor("health_cost_percent")
	-- self.health_damage			= self.ability:GetSpecialValueFor("health_damage")
	-- self.health_damage_scepter	= self.ability:GetSpecialValueFor("health_damage_scepter")
	-- self.charge_speed			= self.ability:GetSpecialValueFor("charge_speed")

	-- self.sac_dagger_duration		= self.ability:GetSpecialValueFor("sac_dagger_duration")
	-- self.sac_dagger_distance		= self.ability:GetSpecialValueFor("sac_dagger_distance")
	-- self.sac_dagger_rotation_speed	= self.ability:GetSpecialValueFor("sac_dagger_rotation_speed")
	-- self.sac_dagger_contact_radius	= self.ability:GetSpecialValueFor("sac_dagger_contact_radius")
	-- self.sac_dagger_dmg_pct			= self.ability:GetSpecialValueFor("sac_dagger_dmg_pct")

	-- if not IsServer() then return end

	-- self.target			= EntIndexToHScript(params.ent_index)
	-- -- As per the wiki; Life Break stops if the target exceeds this distance away from the caster
	-- self.break_range	= 1450

	-- -- Begin the motion controller
	-- if self:ApplyHorizontalMotionController() == false then
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_huskar_life_break:UpdateHorizontalMotion( me, dt )
	-- if not IsServer() then return end
	
	-- me:FaceTowards(self.target:GetOrigin())

	-- local distance = (self.target:GetOrigin() - me:GetOrigin()):Normalized()
	-- me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
	
	-- -- IDK aribtrary numbers again
	-- if (self.target:GetOrigin() - me:GetOrigin()):Length2D() <= 128 or (self.target:GetOrigin() - me:GetOrigin()):Length2D() > self.break_range or self.parent:IsHexed() or self.parent:IsNightmared() or self.parent:IsStunned() then
		-- self:Destroy()
	-- end
-- end

-- -- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
-- function modifier_imba_huskar_life_break:OnHorizontalMotionInterrupted()
	-- self:Destroy()
-- end

-- function modifier_imba_huskar_life_break:OnDestroy()
	-- if not IsServer() then return end

	-- self.parent:RemoveHorizontalMotionController( self )
	
	-- if self.parent:HasModifier("modifier_imba_huskar_life_break_charge") then
		-- self.parent:RemoveModifierByName("modifier_imba_huskar_life_break_charge")
	-- end
	
	-- -- Assumption is that if the caster's within range when the modifier is destroyed, then the cast landed (probably some extreme edge cases but like come on now)
	-- if (self.target:GetOrigin() - self.parent:GetOrigin()):Length2D() <= 128 then
		-- -- Do nothing else if blocked
		-- if self.target:TriggerSpellAbsorb(self.ability) then
			-- return nil
		-- end
		
		-- -- Play ending cast animation if applicable
		-- if self.parent:GetName() == "npc_dota_hero_huskar" then
			-- self.parent:StartGesture(ACT_DOTA_CAST_LIFE_BREAK_END)
		-- end
		
		-- -- Emit sound
		-- self.target:EmitSound("Hero_Huskar.Life_Break.Impact")
		
		-- -- Emit particle
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		-- ParticleManager:SetParticleControl(particle, 1, self.target:GetOrigin())
		-- ParticleManager:ReleaseParticleIndex(particle)

		-- local enemy_damage_to_use = self.health_damage
		
		-- if self.parent:HasScepter() then
			-- enemy_damage_to_use = self.health_damage_scepter
		-- end

		-- -- Deal damage to enemy and self
		-- local damageTable_enemy = {
			-- victim 			= self.target,
			-- attacker 		= self.parent,
			-- damage 			= enemy_damage_to_use * self.target:GetHealth(),
			-- damage_type 	= DAMAGE_TYPE_MAGICAL,
			-- ability 		= self.ability,
			-- damage_flags	= DOTA_DAMAGE_FLAG_NONE
		-- }
		-- local enemy_damage = ApplyDamage(damageTable_enemy)

		-- local damageTable_self = {
			-- victim 			= self.parent,
			-- attacker 		= self.parent,
			-- damage 			= self.health_cost_percent * self.parent:GetHealth(),
			-- damage_type 	= DAMAGE_TYPE_MAGICAL,
			-- ability		 	= self.ability,
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NON_LETHAL
		-- }
		-- local self_damage = ApplyDamage(damageTable_self)

		-- -- Apply the slow modifier
		-- local slow_modifier = self.target:AddNewModifier(self.parent, self.ability, "modifier_imba_huskar_life_break_slow", {duration = self.ability:GetDuration()})
		
		-- if slow_modifier then
			-- slow_modifier:SetDuration(self.ability:GetDuration() * (1 - self.target:GetStatusResistance()), true)
		-- end
		
		-- -- This is optional I guess but it replicates vanilla Life Break being reflected by Lotus Orb a bit closer (cause the target starts attacking you)
		-- self.parent:MoveToTargetToAttack( self.target )
		
		-- local random_angle	= RandomInt(0, 359)

		-- CreateModifierThinker(self.parent, self.ability, "modifier_imba_huskar_life_break_sac_dagger", {
			-- duration		= self.sac_dagger_duration,
			-- random_angle	= random_angle,
			-- distance		= self.sac_dagger_distance,
			-- rotation_speed	= self.sac_dagger_rotation_speed,
			-- contact_radius	= self.sac_dagger_contact_radius,
			-- damage			= enemy_damage * self.sac_dagger_dmg_pct * 0.01
		-- }, 
		-- self.parent:GetAbsOrigin() + Vector(math.cos(math.rad(random_angle)), math.sin(math.rad((random_angle)))) * self.sac_dagger_distance, self.parent:GetTeamNumber(), false)
		
		-- -- Create damage tracker modifier
		-- local tracker_modifier = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_huskar_life_break_sac_dagger_tracker", {duration = self.sac_dagger_duration})
		
		-- if tracker_modifier then
			-- tracker_modifier:SetStackCount(enemy_damage * self.sac_dagger_dmg_pct * 0.01)
		-- end
	-- end
-- end

-- --------------------------------
-- -- LIFE BREAK CHARGE MODIFIER --
-- --------------------------------

-- --"This modifier turns him spell immune, disarms him, forces him to face the target and is responsible for the leap animation."
-- -- I'm gonna put the "forces him to face the target" in the other modifier cause it seems to make sense to just deal with that logic in the motion controller

-- function modifier_imba_huskar_life_break_charge:IsHidden()		return true end
-- function modifier_imba_huskar_life_break_charge:IsPurgable()	return false end

-- function modifier_imba_huskar_life_break_charge:CheckState()
	-- local state = {
		-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
		-- [MODIFIER_STATE_DISARMED] = true,
	-- }

	-- return state
-- end

-- function modifier_imba_huskar_life_break_charge:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_life_break_charge:GetOverrideAnimation()
	-- return ACT_DOTA_CAST_LIFE_BREAK_START
-- end

-- ------------------------------
-- -- LIFE BREAK SLOW MODIFIER --
-- ------------------------------

-- -- Only need this line cause Huskar can self-cast it with IMBAfication
-- function modifier_imba_huskar_life_break_slow:IsDebuff()	return true end

-- function modifier_imba_huskar_life_break_slow:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
-- end

-- function modifier_imba_huskar_life_break_slow:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.movespeed	= self.ability:GetSpecialValueFor("movespeed")
-- end

-- function modifier_imba_huskar_life_break_slow:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_huskar_life_break_slow:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_life_break_slow:GetModifierMoveSpeedBonus_Percentage()
    -- return self.movespeed
-- end

-- ------------------------------------
-- -- LIFE BREAK SAC DAGGER MODIFIER --
-- ------------------------------------

-- -- Let's get weird.
-- function modifier_imba_huskar_life_break_sac_dagger:GetEffectName()
	-- return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
-- end

-- function modifier_imba_huskar_life_break_sac_dagger:OnCreated(params)
   -- if not IsServer() then return end
   
	-- self.random_angle		= params.random_angle
	-- self.distance			= params.distance
	-- self.rotation_speed		= params.rotation_speed
	-- self.contact_radius		= params.contact_radius
	-- self.damage				= params.damage
	
	-- self:OnIntervalThink()
	-- self:StartIntervalThink(FrameTime())
-- end

-- function modifier_imba_huskar_life_break_sac_dagger:OnIntervalThink()
	-- if not IsServer() then return end

	-- -- Remove if caster died
	-- if not self:GetCaster():IsAlive() then
		-- self:Destroy()
	-- end

	-- self:GetParent():SetOrigin(self:GetCaster():GetOrigin() + Vector(math.cos(math.rad(self.random_angle)), math.sin(math.rad((self.random_angle)))) * self.distance)

	-- self.random_angle = self.random_angle + (self.rotation_speed * FrameTime())
	
	-- -- Make the dagger face the correct direction (for the PA dagger model specifically it has to be rotated 90 degrees after "facing" towards caster)
	-- local forward_vector = (self:GetCaster():GetOrigin() - self:GetParent():GetOrigin()):Normalized()
	-- self:GetParent():SetForwardVector(Vector(forward_vector.y, forward_vector.x * (-1), forward_vector.z))
	
	-- local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.contact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	-- for _, enemy in pairs(enemies) do
		-- -- Apply half the damage as physical
		-- local damageTable = {
			-- victim 			= enemy,
			-- damage 			= self.damage * FrameTime() * 0.5,
			-- damage_type		= DAMAGE_TYPE_PHYSICAL,
			-- damage_flags 	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self:GetAbility()
		-- }
		-- ApplyDamage(damageTable)
		
		-- -- and the other half as magical
		-- damageTable.damage_type		= DAMAGE_TYPE_MAGICAL
		-- ApplyDamage(damageTable)
	-- end
-- end

-- -- IDK if I actually need this but when I was testing, Huskar started moving in weird directions if too many daggers were out
-- function modifier_imba_huskar_life_break_sac_dagger:CheckState()
	-- local state = {
	-- [MODIFIER_STATE_UNSELECTABLE] = true,
	-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true
	-- }

	-- return state
-- end

-- function modifier_imba_huskar_life_break_sac_dagger:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MODEL_CHANGE,
		-- MODIFIER_PROPERTY_MODEL_SCALE
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_life_break_sac_dagger:GetModifierModelChange()
	-- return "models/particle/phantom_assassin_dagger_model.vmdl"
-- end

-- -- Arbitrary
-- function modifier_imba_huskar_life_break_sac_dagger:GetModifierModelScale()
	-- return 300
-- end

-- --------------------------------------------
-- -- LIFE BREAK SAC DAGGER TRACKER MODIFIER --
-- --------------------------------------------

-- -- This is just a QOL modifier to show how much damage the dagger is doing
-- function modifier_imba_huskar_life_break_sac_dagger_tracker:IsPurgable()	return false end
-- function modifier_imba_huskar_life_break_sac_dagger_tracker:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_huskar_life_break_sac_dagger_tracker:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_TOOLTIP
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_huskar_life_break_sac_dagger_tracker:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- -- Nothing needed here for now.
