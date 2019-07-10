-- Editors:
--    AltiV, June 22nd, 2019

LinkLuaModifier("modifier_imba_grimstroke_dark_artistry_slow", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_ink_creature_thinker", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature_vision", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_ink_creature_debuff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_spirit_walk_buff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_grimstroke_spirit_walk_debuff", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_grimstroke_soul_chain", "components/abilities/heroes/hero_grimstroke", LUA_MODIFIER_MOTION_NONE)

imba_grimstroke_dark_artistry					= class({})
modifier_imba_grimstroke_dark_artistry_slow		= class({})

imba_grimstroke_ink_creature					= class({})
modifier_imba_grimstroke_ink_creature_thinker	= class({})
modifier_imba_grimstroke_ink_creature_vision	= class({})
modifier_imba_grimstroke_ink_creature			= class({})
modifier_imba_grimstroke_ink_creature_debuff	= class({})

imba_grimstroke_spirit_walk						= class({})
modifier_imba_grimstroke_spirit_walk_buff		= class({})
modifier_imba_grimstroke_spirit_walk_debuff		= class({})

imba_grimstroke_soul_chain						= class({})
modifier_imba_grimstroke_soul_chain				= class({})

--------------------
-- STROKE OF FATE --
--------------------

function imba_grimstroke_dark_artistry:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	self.precast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.precast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	return true
end

function imba_grimstroke_dark_artistry:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	if self.precast_particle then
		ParticleManager:DestroyParticle(self.precast_particle, true)
		ParticleManager:ReleaseParticleIndex(self.precast_particle)
		self.precast_particle = nil
	end
end

function imba_grimstroke_dark_artistry:OnSpellStart()
	self:GetCaster():StopSound("Hero_Grimstroke.DarkArtistry.PreCastPoint")
	
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.Cast")
	self:GetCaster():EmitSound("Hero_Grimstroke.DarkArtistry.Cast.Layer")
	
	if self:GetCaster():GetName() == "npc_dota_hero_grimstroke" and RollPercentage(50) then
		if not self.responses then
			self.responses = 
			{
				["grimstroke_grimstroke_attack_12_02"] = 0,
				["grimstroke_grimstroke_ability3_01"] = 0,
				["grimstroke_grimstroke_ability3_02"] = 0,
				["grimstroke_grimstroke_ability3_04"] = 0,
				["grimstroke_grimstroke_ability3_05"] = 0,
				["grimstroke_grimstroke_ability3_06"] = 0,
				["grimstroke_grimstroke_ability3_07"] = 0, -- This one is supposed to play separately at a 10% chance but like...come on
				["grimstroke_grimstroke_ability3_08"] = 0,
				["grimstroke_grimstroke_ability3_09"] = 0,
				["grimstroke_grimstroke_ability3_10"] = 0,
				["grimstroke_grimstroke_ability3_11"] = 0
			}

			for response, timer in pairs(self.responses) do
				if GameRules:GetDOTATime(true, true) - timer >= 120 then
					self:GetCaster():EmitSound(response)
					self.responses[response] = GameRules:GetDOTATime(true, true)
					break
				end
			end
		end
	end
	
	if self.precast_particle then
		ParticleManager:ReleaseParticleIndex(self.precast_particle)
		self.precast_particle = nil
	end
	
	-- "The ink trail starts 120 range towards Grimstroke's left side and travels towards the targeted point."
	local projectile_start_location = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetRightVector() * 120 * (-1))
	
	-- Create a modifier thinker to attach the sound to, as well as keep track of accumulating damage within one stroke
	local stroke_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	stroke_dummy:EmitSound("Hero_Grimstroke.DarkArtistry.Projectile")
	stroke_dummy.hit_units = 0
	
	local info = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf",
		vSpawnOrigin		= projectile_start_location,
		fDistance			= self:GetTalentSpecialValueFor("range_tooltip") + GetCastRangeIncrease(self:GetCaster()),
		fStartRadius		= self:GetSpecialValueFor("start_radius"),
		fEndRadius			= self:GetSpecialValueFor("end_radius"),
		Source				= self:GetCaster(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= false,
		vVelocity			= (self:GetCursorPosition() - projectile_start_location):Normalized() * self:GetSpecialValueFor("projectile_speed"),
		bProvidesVision		= false,
		
		ExtraData			= 
		{
			-- bScepter 	= true, 
			-- bTargeted	= false,
			-- speed		= self:GetSpecialValueFor("speed_scepter"),
			-- x			= direction.x,
			-- y			= direction.y,
			-- z			= direction.z,
			-- bFiltrate	= filtration_wave,
			stroke_dummy	= stroke_dummy:entindex(),
		}
	}
	
	local projectile = ProjectileManager:CreateLinearProjectile(info)
end

-- Make the travel sound follow the stroke
function imba_grimstroke_dark_artistry:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if data.stroke_dummy then
		EntIndexToHScript(data.stroke_dummy):SetAbsOrigin(location)
	end
end

function imba_grimstroke_dark_artistry:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	-- Stroke of Fate hit some unit
	if target then
		if not target:IsCreep() then
			target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage")
		else
			target:EmitSound("Hero_Grimstroke.DarkArtistry.Damage.Creep")
		end
		
		local stroke_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_demonartist/demonartist_darkartistry_dmg.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(stroke_particle)
		
		-- "Stroke of Fate first applies the damage, then the debuff."
		local damageTable = {
			victim 			= target,
			damage 			= self:GetTalentSpecialValueFor("damage") + (self:GetTalentSpecialValueFor("bonus_damage_per_target") * EntIndexToHScript(data.stroke_dummy).hit_units),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		ApplyDamage(damageTable)
		
		-- Increment the amount of hit units to deal more damage against further targets
		EntIndexToHScript(data.stroke_dummy).hit_units = EntIndexToHScript(data.stroke_dummy).hit_units + 1
		
		local slow_debuff = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_dark_artistry_slow", {duration = self:GetSpecialValueFor("slow_duration")})
		
		if slow_debuff then
			slow_debuff:SetDuration(self:GetSpecialValueFor("slow_duration") * (1 - target:GetStatusResistance()), true)
		end
	-- Stroke of Fate has reached its end location
	elseif data.stroke_dummy then
		-- EntIndexToHScript(data.stroke_dummy):StopSound("Hero_Grimstroke.DarkArtistry.Projectile")
		EntIndexToHScript(data.stroke_dummy):RemoveSelf()
	end
end

----------------------------------
-- STROKE OF FATE SLOW MODIFIER --
----------------------------------

function modifier_imba_grimstroke_dark_artistry_slow:GetEffectName()
	return "particles/units/heroes/hero_grimstroke/grimstroke_dark_artistry_debuff.vpcf"
end

function modifier_imba_grimstroke_dark_artistry_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_grimstroke_dark_artistry.vpcf"
end

function modifier_imba_grimstroke_dark_artistry_slow:OnCreated()
	if self:GetAbility() then
		self.movement_slow_pct	= self:GetAbility():GetSpecialValueFor("movement_slow_pct")
	else
		self:Destroy()
	end
end

function modifier_imba_grimstroke_dark_artistry_slow:OnRefresh()
	self:OnCreated()
end

function modifier_imba_grimstroke_dark_artistry_slow:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	
	return decFuncs
end

function modifier_imba_grimstroke_dark_artistry_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow_pct * (-1)
end

-----------------------
-- PHANTOM'S EMBRACE --
-----------------------

function imba_grimstroke_ink_creature:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_grimstroke_ink_creature:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
	
	local vision_modifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_ink_creature_vision", {})
	
	-- Need these variables due to using a timer
	local ability					= self
	local caster					= self:GetCaster()
	local target					= self:GetCursorTarget()
	
	local speed 					= self:GetSpecialValueFor("speed")
	local latch_unit_offset_short	= self:GetSpecialValueFor("latched_unit_offset_short")
	
	Timers:CreateTimer(self:GetSpecialValueFor("spawn_time"), function()
		local ink_unit = CreateUnitByName("npc_dota_grimstroke_ink_creature", self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self:GetSpecialValueFor("latched_unit_offset_short"), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		ink_unit:AddNewModifier(caster, ability, "modifier_imba_grimstroke_ink_creature_thinker", {})
		
		local projectile =
		{
			Target 				= target,
			Source 				= caster,
			Ability 			= ability,
			--EffectName 			= self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_puck/puck_base_attack.vpcf",
			iMoveSpeed			= speed,
			vSourceLoc 			= caster:GetAbsOrigin() + caster:GetForwardVector() * latch_unit_offset_short,
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= true,
			iVisionRadius 		= 400, -- IDK if there's some number to refer to
			iVisionTeamNumber 	= caster:GetTeamNumber(),
			
			ExtraData = {
				ink_unit_entindex	= ink_unit:entindex()
			}
		}
		
		ProjectileManager:CreateTrackingProjectile(projectile)
	end)
end

function imba_grimstroke_ink_creature:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end
	
	if not data.returning and data.ink_unit_entindex and EntIndexToHScript(data.ink_unit_entindex) and EntIndexToHScript(data.ink_unit_entindex):IsAlive() then
		EntIndexToHScript(data.ink_unit_entindex):SetAbsOrigin(location)
	end
	
	-- ChangeTrackingProjectileSpeed(arg1: handle, arg2: int): nil
end

function imba_grimstroke_ink_creature:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end
	
	if target then
		if target ~= self:GetCaster() and data.ink_unit_entindex and EntIndexToHScript(data.ink_unit_entindex) and EntIndexToHScript(data.ink_unit_entindex):IsAlive() and not target:IsInvulnerable() and not target:IsOutOfGame() then
			local ink_modifier	= EntIndexToHScript(data.ink_unit_entindex):FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_thinker", self:GetCaster())
			
			if ink_modifier then
				-- This seems pretty sketch, but it's to switch animations while retaining a modifier (although two modifiers would have been fine I guess...)
				ink_modifier:Destroy()
				EntIndexToHScript(data.ink_unit_entindex):AddNewModifier(caster, ability, "modifier_imba_grimstroke_ink_creature_thinker", {latched = true})
			end
			
			local individual_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_ink_creature", 
				{
					duration 			= self:GetSpecialValueFor("latch_duration"),
					latched_unit_offset	= self:GetSpecialValueFor("latched_unit_offset"),
					ink_unit_entindex	= data.ink_unit_entindex
				})
			
			if individual_modifier then
				individual_modifier:SetDuration(self:GetSpecialValueFor("latch_duration") * (1 - target:GetStatusResistance()), true)
			end

			local counter_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_ink_creature_debuff", 
				{
					duration 			= self:GetSpecialValueFor("latch_duration"),
				})
			
			if counter_modifier then
				counter_modifier:SetDuration(self:GetSpecialValueFor("latch_duration") * (1 - target:GetStatusResistance()), true)
			end
		else
			-- Refresh cooldown
		end
	else

	end
end



			-- "01"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "spawn_time"				"0.0"
			-- }
			-- "02"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "speed"						"750"
			-- }
			-- "03"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "latch_duration"			"5"
			-- }
			-- "04"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "destroy_attacks"			"6 6 9 9"
				-- "LinkedSpecialBonus"		"special_bonus_unique_grimstroke_4"
			-- }
			-- "05"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "hero_attack_multiplier"	"3"
			-- }
			-- "06"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "damage_per_tick"			"3 7 11 15"
			-- }
			-- "07"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "dps_tooltip"				"6 14 22 30"
			-- }
			-- "08"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "enemy_vision_time"			"4"
			-- }
			-- "09"
			-- {
				-- "var_type"					"FIELD_FLOAT"
				-- "tick_interval"				"0.5"
			-- }
			-- "10"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "infection_search_radius"	"1000"
			-- }
			-- "11"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "pop_damage"				"75 150 225 300"
			-- }
			-- "12"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "return_projectile_speed"	"750"
			-- }
			-- "13"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "latched_unit_offset"		"130"
			-- }
			-- "14"
			-- {
				-- "var_type"					"FIELD_INTEGER"
				-- "latched_unit_offset_short"	"95"
			-- }

----------------------------------------
-- PHANTOM'S EMBRACE THINKER MODIFIER --
----------------------------------------

function modifier_imba_grimstroke_ink_creature_thinker:IsPurgable()	return false end

function modifier_imba_grimstroke_ink_creature_thinker:OnCreated(params)
	if not IsServer() then return end

	-- This is handled on the projectilehit function
	self.latched = params.latched
	
	if self:GetAbility() and self:GetAbility():GetAutoCastState() then
		self:SetStackCount(1)
	end
end

function modifier_imba_grimstroke_ink_creature_thinker:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }

    return decFuncs
end

-- These aren't working right now
function modifier_imba_grimstroke_ink_creature_thinker:GetOverrideAnimation()
	if self.latched then
		return ACT_DOTA_ATTACK
	else
		return ACT_DOTA_RUN
	end
end

function modifier_imba_grimstroke_ink_creature_thinker:GetActivityTranslationModifiers()
	if self.latched then
		return "ink_creature_latched"
	end
end

---------------------------------------
-- PHANTOM'S EMBRACE VISION MODIFIER --
---------------------------------------

function modifier_imba_grimstroke_ink_creature_vision:IsHidden()	return true end
function modifier_imba_grimstroke_ink_creature_vision:IsPurgable()	return false end

function modifier_imba_grimstroke_ink_creature_vision:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PROVIDES_FOW_POSITION}
	
	return decFuncs
end

function modifier_imba_grimstroke_ink_creature_vision:GetModifierProvidesFOWVision()
	return 1
end

--------------------------------
-- PHANTOM'S EMBRACE MODIFIER --
--------------------------------

function modifier_imba_grimstroke_ink_creature:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_grimstroke_ink_creature:OnCreated(params)
	self.return_projectile_speed	= self:GetAbility():GetSpecialValueFor("return_projectile_speed")
	self.pop_damage					= self:GetAbility():GetSpecialValueFor("pop_damage")

	if not IsServer() then return end
	
	self.damage_type			= self:GetAbility():GetAbilityDamageType()
	
	self.latched_unit_offset	= params.latched_unit_offset
	self.ink_unit				= EntIndexToHScript(params.ink_unit_entindex)
	
	if self.ink_unit and self.ink_unit:FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_thinker", self:GetCaster()) then
		self:SetStackCount(self.ink_unit:GetModifierStackCount("modifier_imba_grimstroke_ink_creature_thinker", self:GetCaster()))
	end
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_grimstroke_ink_creature:OnIntervalThink()
	if self.ink_unit and self.ink_unit:IsAlive() then
		self.ink_unit:SetAbsOrigin(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self.latched_unit_offset)
		self.ink_unit:SetForwardVector((self:GetParent():GetAbsOrigin() - self.ink_unit:GetAbsOrigin()):Normalized())
	else
		self:StartIntervalThink(-1)
	end
end

function modifier_imba_grimstroke_ink_creature:OnDestroy()
	if not IsServer() then return end

	local ink_creature_counter = self:GetParent():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_debuff", self:GetCaster())
	
	if ink_creature_counter then
		ink_creature_counter:DecrementStackCount()
	end

	-- IMBAfication
	if self.ink_unit and self.ink_unit:IsAlive() then
		self:Return()
	end
	
	if self:GetRemainingTime() <= 0 then
		-- "The phantom returns to Grimstroke upon expiring, or when its target dies. It does not return when it gets killed."
		local damageTable = {
			victim 			= self:GetParent(),
			damage 			= self.pop_damage,
			damage_type		= self.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}

		ApplyDamage(damageTable)
	end
end

function modifier_imba_grimstroke_ink_creature:Return()
	if self.ink_unit and self.ink_unit:IsAlive() then
		local projectile =
		{
			Target 				= self:GetCaster(),
			Source 				= self.ink_unit,
			Ability 			= self:GetAbility(),
			EffectName 			= "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf",
			iMoveSpeed			= self.return_projectile_speed,
			vSourceLoc 			= self.ink_unit:GetAbsOrigin(),
			bDrawsOnMinimap 	= false,
			bDodgeable 			= true,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10.0,
			bProvidesVision 	= false,
			
			ExtraData = {
				returning		= true
			}
		}	
	
		-- The unit doesn't actually get deleted in vanilla so...
		self.ink_unit:ForceKill(false)
		self.ink_unit:AddNoDraw()
		-- self.ink_unit:RemoveSelf()
		
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function modifier_imba_grimstroke_ink_creature:CheckState()
	local state = {}
	
	if self:GetStackCount() ~= 1 then
		state[MODIFIER_STATE_SILENCED] = true
	else
		state[MODIFIER_STATE_MUTED] = true -- MAKE A BETTER PARTICLE FOR THIS
	end
	
	return state
end

---------------------------------------
-- PHANTOM'S EMBRACE DEBUFF MODIFIER --
---------------------------------------

-- This deals with damage summation in the case of mulitple phantoms

function modifier_imba_grimstroke_ink_creature_debuff:OnCreated(params)
	self.damage_per_tick	= self:GetAbility():GetSpecialValueFor("damage_per_tick")
	self.tick_interval		= self:GetAbility():GetSpecialValueFor("tick_interval")
	
	if not IsServer() then return end
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self:IncrementStackCount()
	
	self:StartIntervalThink(self.tick_interval * (1 - self:GetParent():GetStatusResistance()))
end

function modifier_imba_grimstroke_ink_creature_debuff:OnRefresh()
	if not IsServer() then return end
	
	self:OnCreated()
end

function modifier_imba_grimstroke_ink_creature_debuff:OnIntervalThink()
	if not IsServer() then return end
	
	local damageTable = {
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick * self:GetStackCount(),
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}

	ApplyDamage(damageTable)
end

function modifier_imba_grimstroke_ink_creature_debuff:OnDestroy()
	if not IsServer() then return end
	
	local vision_modifier	= self:GetParent():FindModifierByNameAndCaster("modifier_imba_grimstroke_ink_creature_vision", self:GetCaster())
	
	if vision_modifier then
		vision_modifier:Destroy()
	end
end

---------------
-- INK SWELL --
---------------

function imba_grimstroke_spirit_walk:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_spirit_walk_buff", {duration = self:GetSpecialValueFor("buff_duration")})
end

			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "cast_range_tooltip"	"400 500 600 700"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "buff_duration"			"3.0"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "movespeed_bonus_pct"	"12 14 16 18"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"400"
				-- "LinkedSpecialBonus"	"special_bonus_unique_grimstroke_1"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "max_damage"			"100 200 300 400"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "max_stun"				"1.0 1.9 2.8 3.7"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "damage_per_tick"		"5 7 9 11"
			-- }
			-- "08"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "tick_rate"				"0.2"
			-- }
			-- "09"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "tick_dps_tooltip"		"25 35 45 55"
			-- }

-----------------------------
-- INK SWELL BUFF MODIFIER --
-----------------------------

-- For the IMBAfication that allows casting on enemies
function modifier_imba_grimstroke_spirit_walk_buff:IgnoreTenacity()	return true end

function modifier_imba_grimstroke_spirit_walk_buff:GetEffectName()

end

function modifier_imba_grimstroke_spirit_walk_buff:OnCreated()
	self.buff_duration			= self:GetAbility():GetSpecialValueFor("buff_duration")
	self.movespeed_bonus_pct	= self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
	self.radius					= self:GetAbility():GetSpecialValueFor("radius")
	self.max_damage				= self:GetAbility():GetSpecialValueFor("max_damage")
	self.max_stun				= self:GetAbility():GetSpecialValueFor("max_stun")
	self.damage_per_tick		= self:GetAbility():GetSpecialValueFor("damage_per_tick")
	self.tick_rate				= self:GetAbility():GetSpecialValueFor("tick_rate")
	
	self.coat_of_armor_amount	= self:GetAbility():GetSpecialValueFor("coat_of_armor_amount")
	
	if not IsServer() then return end
	
	-- Track how many times a real hero was hit to determine max damage and stun
	self.counter				= 0
	
	self.ticks					= 0
	self.total_ticks			= self.buff_duration / self.tick_rate
	
	-- if self:GetCaster():FindModifierByNameAndCaster("", self:GetCaster())
		-- self.total_ticks	= self.incarnation_buff_duration / self.tick_rate
	-- end
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.tick_rate)
end

function modifier_imba_grimstroke_spirit_walk_buff:OnIntervalThink()
	if not IsServer() or self.ticks >= self.total_ticks then return end
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim 			= enemy,
			damage 			= damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}
		
		ApplyDamage(damageTable)
	end
	
	-- "The damage and stun upon losing the buff is based on the amount of damage instances the tendrils applied to a single enemy hero."
	if #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false) >= 1 then
		self.counter	= self.counter + 1
	end
	
	self.ticks	= self.ticks + 1
end

-- "When the debuff is lost prematurely, it still applies the area expire damage and stun, based on the damage instances it dealt up to that point."
function modifier_imba_grimstroke_spirit_walk_buff:OnDestroy()
	if not IsServer() then return end
	
	-- "The expire damage and stun only apply when there is at least one enemy hero within the area."
	if #FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false) >= 1 then
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		-- "Ink Swell first applies the damage, then the debuff."
		local damageTable = {
			victim 			= enemy,
			damage 			= (self.max_damage / self.total_ticks) * self.counter,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}
		
		ApplyDamage(damageTable)
		
		local debuff_modifier	= enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_grimstroke_spirit_walk_debuff", {duration = (self.max_stun / self.total_ticks) * self.counter})
		
		if debuff_modifier then
			debuff_modifier:SetDuration(((self.max_stun / self.total_ticks) * self.counter) * (1 - enemy:GetStatusResistance()), true)
		end
	end	
end

-- IMBAfication: Unburdened
function modifier_imba_grimstroke_spirit_walk_buff:CheckState()
	local state = {}
	
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	end
	
	return state
end

function modifier_imba_grimstroke_spirit_walk_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	
	return decFuncs
end

-- IMBAfication: Coat of Armor
function modifier_imba_grimstroke_spirit_walk_buff:GetModifierPhysicalArmorBonus()
	if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then
		return self.coat_of_armor_amount
	else
		return self.coat_of_armor_amount * (-1)
	end
end

-------------------------------
-- INK SWELL DEBUFF MODIFIER --
-------------------------------

function modifier_imba_grimstroke_spirit_walk_debuff:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	
	return state
end

--------------
-- SOULBIND --
--------------

function imba_grimstroke_soul_chain:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
	
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_grimstroke_soul_chain", {duration = self:GetSpecialValueFor("chain_duration")})
end

-----------------------
-- SOULBIND MODIFIER --
-----------------------

function modifier_imba_grimstroke_soul_chain:GetEffectName()

end

function modifier_imba_grimstroke_soul_chain:OnCreated()

end

-- ----------
-- -- GUSH --
-- ----------

-- function imba_tidehunter_gush:GetIntrinsicModifierName()
	-- return "modifier_imba_tidehunter_gush_handler"
-- end

-- function imba_tidehunter_gush:GetAbilityTextureName()
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_gush_handler", self:GetCaster()) < 3 then
		-- return "tidehunter_gush"
	-- else
		-- return "custom/tidehunter_gush_filtration"
	-- end
-- end

-- function imba_tidehunter_gush:GetBehavior()
	-- if self:GetCaster():HasScepter() then
		-- return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- else
		-- return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- end
-- end

-- function imba_tidehunter_gush:GetCastRange(location, target)
	-- if not self:GetCaster():HasScepter() then
		-- return self.BaseClass.GetCastRange(self, location, target)
	-- else
		-- return self:GetSpecialValueFor("cast_range_scepter")
	-- end
-- end

-- function imba_tidehunter_gush:OnSpellStart()
	-- self:GetCaster():EmitSound("Ability.GushCast")
	
	-- -- IMBAfication: Filtration System
	-- local gush_handler_modifier	= self:GetCaster():FindModifierByNameAndCaster("modifier_imba_tidehunter_gush_handler", self:GetCaster())
	-- local filtration_wave		= gush_handler_modifier:GetStackCount() >= self:GetSpecialValueFor("casts_before_filtration")

	-- -- Standard ability logic
	-- if self:GetCursorTarget() then
		-- local direction	= (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		
		-- local projectile =
		-- {
			-- Target 				= self:GetCursorTarget(),
			-- Source 				= self:GetCaster(),
			-- Ability 			= self,
			-- EffectName 			= "particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf",
			-- iMoveSpeed			= self:GetSpecialValueFor("projectile_speed"),
			-- vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
			-- bDrawsOnMinimap 	= false,
			-- bDodgeable 			= true,
			-- bIsAttack 			= false,
			-- bVisibleToEnemies 	= true,
			-- bReplaceExisting 	= false,
			-- flExpireTime 		= GameRules:GetGameTime() + 10.0,
			-- bProvidesVision 	= false,
			
			-- iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2, -- Need to put the mouth?
			
			-- ExtraData = {
				-- bScepter	= self:GetCaster():HasScepter(),
				-- bTargeted	= true,
				-- speed		= self:GetSpecialValueFor("projectile_speed"),
				-- x			= direction.x,
				-- y			= direction.y,
				-- z			= direction.z,
				-- bFiltrate	= filtration_wave
			-- }
		-- }
		
		-- ProjectileManager:CreateTrackingProjectile(projectile)
	-- end
	
	-- -- Scepter ability logic
	-- if self:GetCaster():HasScepter() then		
		-- -- This "dummy" literally only exists to attach the gush travel sound to
		-- local gush_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		-- gush_dummy:EmitSound("Hero_Tidehunter.Gush.AghsProjectile")
		
		-- local direction	= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()
		
		-- local linear_projectile = {
			-- Ability				= self,
			-- EffectName			= "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf", -- Might not do anything
			-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			-- fDistance			= self:GetSpecialValueFor("cast_range_scepter") + GetCastRangeIncrease(self:GetCaster()),
			-- fStartRadius		= self:GetSpecialValueFor("aoe_scepter"),
			-- fEndRadius			= self:GetSpecialValueFor("aoe_scepter"),
			-- Source				= self:GetCaster(),
			-- bHasFrontalCone		= false,
			-- bReplaceExisting	= false,
			-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_BOTH, -- IMBAfication: Surf's Up!
			-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
			-- bDeleteOnHit		= true,
			-- vVelocity			= direction * self:GetSpecialValueFor("speed_scepter"),
			-- bProvidesVision		= false,
			
			-- ExtraData			= 
			-- {
				-- bScepter 	= true, 
				-- bTargeted	= false,
				-- speed		= self:GetSpecialValueFor("speed_scepter"),
				-- x			= direction.x,
				-- y			= direction.y,
				-- z			= direction.z,
				-- bFiltrate	= filtration_wave,
				-- gush_dummy	= gush_dummy:entindex(),
			-- }
		-- }
		
		-- self.projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)
	-- end
	
	-- if not filtration_wave then
		-- gush_handler_modifier:IncrementStackCount()
	-- else
		-- gush_handler_modifier:SetStackCount(0)
	-- end
-- end

-- -- Make the travel sound follow the Gush
-- function imba_tidehunter_gush:OnProjectileThink_ExtraData(location, data)
	-- if not IsServer() then return end
	
	-- if data.gush_dummy then
		-- EntIndexToHScript(data.gush_dummy):SetAbsOrigin(location)
	-- end
-- end

-- function imba_tidehunter_gush:OnProjectileHit_ExtraData(target, location, data)
	-- if not IsServer() then return end
	
	-- -- Gush hit some unit
	-- if target then
		-- if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			-- -- Trigger spell absorb if applicable
			-- if data.bTargeted == 1 and target:TriggerSpellAbsorb(self) then
				-- target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("shieldbreaker_stun")}):SetDuration(self:GetSpecialValueFor("shieldbreaker_stun") * (1 - target:GetStatusResistance()), true)
				-- return nil
			-- end
		
			-- target:EmitSound("Ability.GushImpact")
			
			-- -- IMBAfication: Filtration System
			-- if data.bFiltrate == 1 then
				-- target:Purge(true, false, false, false, false)
			-- end
		
			-- -- Make the targeted gush not have any effects except for shield break if scepter (no double damage nuttiness)
			-- if not (data.bScepter == 1 and data.bTargeted == 1) then
				-- -- "Gush first applies the debuff, then the damage."
				-- target:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_gush", {duration = self:GetDuration()}):SetDuration(self:GetDuration() * (1 - target:GetStatusResistance()), true)

				-- -- "Provides 200 radius ground vision around each hit enemy for 2 seconds."
				-- if data.bScepter == 1 then
					-- self:CreateVisibilityNode(target:GetAbsOrigin(), 200, 2)
				-- end

				-- local damageTable = {
					-- victim 			= target,
					-- damage 			= self:GetTalentSpecialValueFor("gush_damage"),
					-- damage_type		= self:GetAbilityDamageType(),
					-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					-- attacker 		= self:GetCaster(),
					-- ability 		= self
				-- }

				-- ApplyDamage(damageTable)
				
				-- if self:GetCaster():GetName() == "npc_dota_hero_tidehunter" and target:IsRealHero() and not target:IsAlive() and RollPercentage(25) then
					-- self:GetCaster():EmitSound("tidehunter_tide_ability_gush_0"..RandomInt(1, 2))
				-- end
			-- end
		-- end
		
		-- -- IMBAfication: Surf's Up!
		-- if self:GetAutoCastState() and target ~= self:GetCaster() and (target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or (target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and not PlayerResource:IsDisableHelpSetForPlayerID(target:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()))) then
			-- local surf_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_gush_surf", 
			-- {
				-- duration	= self:GetSpecialValueFor("surf_duration"),
				-- speed		= data.speed,
				-- x			= data.x,
				-- y			= data.y,
				-- z			= data.z,
			-- })
			
			-- if surf_modifier then
				-- surf_modifier:SetDuration(self:GetSpecialValueFor("surf_duration") * (1 - target:GetStatusResistance()), true)
			-- end
		-- end
		
	-- -- Scepter Gush has reached its end location
	-- elseif data.gush_dummy then
		-- EntIndexToHScript(data.gush_dummy):StopSound("Hero_Tidehunter.Gush.AghsProjectile")
		-- EntIndexToHScript(data.gush_dummy):RemoveSelf()
	-- end
-- end

-- -------------------
-- -- GUSH MODIFIER --
-- -------------------

-- function modifier_imba_tidehunter_gush:GetEffectName()
	-- return "particles/units/heroes/hero_tidehunter/tidehunter_gush_slow.vpcf"
-- end

-- function modifier_imba_tidehunter_gush:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_gush.vpcf"
-- end

-- function modifier_imba_tidehunter_gush:OnCreated()
	-- if self:GetAbility() then
		-- self.movement_speed	= self:GetAbility():GetSpecialValueFor("movement_speed")
		-- self.negative_armor	= self:GetAbility():GetTalentSpecialValueFor("negative_armor")
	-- else
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_tidehunter_gush:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_tidehunter_gush:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_gush:GetModifierMoveSpeedBonus_Percentage()
	-- return self.movement_speed
-- end

-- function modifier_imba_tidehunter_gush:GetModifierPhysicalArmorBonus()
	-- return self.negative_armor * (-1)
-- end

-- ---------------------------
-- -- GUSH HANDLER MODIFIER --
-- ---------------------------

-- function modifier_imba_tidehunter_gush_handler:IsHidden() return true end

-- ------------------------
-- -- GUSH SURF MODIFIER --
-- ------------------------

-- function modifier_imba_tidehunter_gush_surf:OnCreated(params)
	-- if not IsServer() then return end
	
	-- if self:GetAbility() then
		-- self.speed			= params.speed
		-- self.direction		= Vector(params.x, params.y, params.z)
		-- self.surf_speed_pct	= self:GetAbility():GetSpecialValueFor("surf_speed_pct")
		
		-- self:StartIntervalThink(FrameTime())
	-- else
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_tidehunter_gush_surf:OnRefresh(params)
	-- if not IsServer() then return end
	
	-- self:OnCreated(params)
-- end

-- function modifier_imba_tidehunter_gush_surf:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin() + (self.direction * self.speed * self.surf_speed_pct * 0.01 * FrameTime()), false)
-- end

-- ------------------
-- -- KRAKEN SHELL --
-- ------------------

-- function imba_tidehunter_kraken_shell:GetIntrinsicModifierName()	
	-- return "modifier_imba_tidehunter_kraken_shell"
-- end

-- function imba_tidehunter_kraken_shell:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
-- end

-- function imba_tidehunter_kraken_shell:OnSpellStart()
	-- self:GetCaster():Purge(false, true, false, true, true)
	
	-- local kraken_shell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- ParticleManager:ReleaseParticleIndex(kraken_shell_particle)
	
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_kraken_shell_backstroke", {duration = 3.6})
	
	-- if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_kraken_shell_greater_hardening", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening", "duration")})
	-- end
-- end

-- ---------------------------
-- -- KRAKEN SHELL MODIFIER --
-- ---------------------------

-- function modifier_imba_tidehunter_kraken_shell:IsHidden()	return not (self:GetAbility() and self:GetAbility():GetLevel() >= 1) end

-- function modifier_imba_tidehunter_kraken_shell:OnCreated()
	-- if not IsServer() then return end
	
	-- self.reset_timer	= GameRules:GetDOTATime(true, true)
	-- self:SetStackCount(0)
	
	-- self:StartIntervalThink(0.1)
-- end

-- -- This is to keep tracking of the damage reset interval
-- function modifier_imba_tidehunter_kraken_shell:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- if GameRules:GetDOTATime(true, true) - self.reset_timer >= self:GetAbility():GetSpecialValueFor("damage_reset_interval") then
		-- self:SetStackCount(0)
		-- self.reset_timer = GameRules:GetDOTATime(true, true)
	-- end
-- end

-- function modifier_imba_tidehunter_kraken_shell:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- -- MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT, 
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		
		-- MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		-- MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_kraken_shell:GetModifierPhysical_ConstantBlock()
	-- return self:GetAbility():GetTalentSpecialValueFor("damage_reduction")
-- end

-- function modifier_imba_tidehunter_kraken_shell:OnTakeDamage(keys)
	-- if keys.unit == self:GetParent() and not keys.attacker:IsOther() and (keys.attacker:GetOwnerEntity() or keys.attacker.GetPlayerID) and not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and self:GetAbility():IsTrained() then
		-- self:SetStackCount(self:GetStackCount() + keys.damage)
		-- self.reset_timer = GameRules:GetDOTATime(true, true)
		
		-- if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("damage_cleanse") then
			-- self:GetParent():EmitSound("Hero_Tidehunter.KrakenShell")
			
			-- local kraken_shell_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_krakenshell_purge.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			-- ParticleManager:ReleaseParticleIndex(kraken_shell_particle)
		
			-- self:GetParent():Purge(false, true, false, true, true)
			
			-- self:SetStackCount(0)
			
			-- if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") then
				-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_tidehunter_kraken_shell_greater_hardening", {duration = self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening", "duration")})
			-- end
		-- end
	-- end
-- end

-- function modifier_imba_tidehunter_kraken_shell:GetModifierBonusStats_Strength()
	-- if self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		-- return self:GetAbility():GetSpecialValueFor("aqueous_strength")
	-- end
-- end

-- function modifier_imba_tidehunter_kraken_shell:GetModifierHealthRegenPercentage()
	-- if self:GetParent():GetAbsOrigin().z < 160 and not self:GetParent():PassivesDisabled() then
		-- return self:GetAbility():GetSpecialValueFor("aqueous_heal")
	-- end
-- end

-- --------------------------------------
-- -- KRAKEN SHELL BACKSTROKE MODIFIER --
-- --------------------------------------

-- function modifier_imba_tidehunter_kraken_shell_backstroke:OnCreated()
	-- if self:GetAbility() then
		-- self.backstroke_movespeed		= self:GetAbility():GetSpecialValueFor("backstroke_movespeed")
		-- self.backstroke_statusresist	= self:GetAbility():GetSpecialValueFor("backstroke_statusresist")
	-- else
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_tidehunter_kraken_shell_backstroke:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_kraken_shell_backstroke:GetOverrideAnimation()
	-- --if self:GetParent():GetAbsOrigin().z < 160 then return ACT_DOTA_TAUNT end
	-- return ACT_DOTA_TAUNT
-- end

-- function modifier_imba_tidehunter_kraken_shell_backstroke:GetActivityTranslationModifiers()
	-- --if self:GetParent():GetAbsOrigin().z < 160 then return "backstroke_gesture" end
	-- return "backstroke_gesture"
-- end

-- function modifier_imba_tidehunter_kraken_shell_backstroke:GetModifierMoveSpeedBonus_Percentage()
	-- if self:GetParent():GetAbsOrigin().z >= 160 then
		-- return self.backstroke_movespeed
	-- else
		-- return self.backstroke_movespeed * 2
	-- end
-- end

-- function modifier_imba_tidehunter_kraken_shell_backstroke:GetModifierStatusResistanceStacking()
	-- if self:GetParent():GetAbsOrigin().z >= 160 then
		-- return self.backstroke_statusresist
	-- else
		-- return self.backstroke_statusresist * 2
	-- end
-- end

-- ---------------------------------------------
-- -- KRAKEN SHELL GREATER HARDENING MODIFIER --
-- ---------------------------------------------

-- function modifier_imba_tidehunter_kraken_shell_greater_hardening:OnCreated()
	-- self.value	= self:GetCaster():FindTalentValue("special_bonus_imba_tidehunter_greater_hardening")
	
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_tidehunter_kraken_shell_greater_hardening:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_tidehunter_kraken_shell_greater_hardening:DeclareFunctions()
	-- local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_kraken_shell_greater_hardening:GetModifierMagicalResistanceBonus()
	-- return self:GetStackCount() * self.value
-- end

-- ------------------
-- -- ANCHOR SMASH --
-- ------------------

-- function imba_tidehunter_anchor_smash:GetCastRange(location, target)
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		-- return self.BaseClass.GetCastRange(self, location, target)
	-- else
		-- return self:GetSpecialValueFor("throw_range")
	-- end
-- end

-- function imba_tidehunter_anchor_smash:GetBehavior()
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- else
		-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- end
-- end

-- function imba_tidehunter_anchor_smash:GetAOERadius()
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_anchor_smash_handler", self:GetCaster()) == 0 then
		-- return 0
	-- else
		-- return self:GetSpecialValueFor("throw_radius")
	-- end
-- end

-- function imba_tidehunter_anchor_smash:GetIntrinsicModifierName()
	-- return "modifier_imba_tidehunter_anchor_smash_handler"
-- end

-- function imba_tidehunter_anchor_smash:OnSpellStart()
	-- if self:GetAutoCastState() then
		-- self:GetCaster():EmitSound("Hero_ChaosKnight.idle_throw")
		
		-- local anchor_dummy = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_throw", 
		-- {
			-- x = self:GetCursorPosition().x,
			-- y = self:GetCursorPosition().y,
			-- z = self:GetCursorPosition().z
		-- }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		-- local linear_projectile = {
			-- Ability				= self,
			-- -- EffectName			= "nil"
			-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
			-- fDistance			= self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + GetCastRangeIncrease(self:GetCaster()),
			-- fStartRadius		= self:GetSpecialValueFor("throw_radius"),
			-- fEndRadius			= self:GetSpecialValueFor("throw_radius"),
			-- Source				= self:GetCaster(),
			-- bHasFrontalCone		= false,
			-- bReplaceExisting	= false,
			-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
			-- bDeleteOnHit		= true,
			-- vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("throw_speed"),
			-- bProvidesVision		= false,
			
			-- ExtraData			= {anchor_dummy = anchor_dummy:entindex()}
		-- }
		
		-- ProjectileManager:CreateLinearProjectile(linear_projectile)
	-- else
		-- self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
		
		-- local anchor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		-- ParticleManager:ReleaseParticleIndex(anchor_particle)
		
		-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false) -- IMBAfication: Sheer Force
		
		-- for _, enemy in pairs(enemies) do
			-- self:Smash(enemy)
		-- end
	-- end
-- end

-- function imba_tidehunter_anchor_smash:Smash(enemy, bThrown)
	-- if not enemy:IsRoshan() then
		-- if bThrown and enemy:IsConsideredHero() then
			-- self:GetCaster():EmitSound("Hero_Tidehunter.AnchorSmash")
		-- end
		
		-- -- The smash first applies the debuff, then the instant attack.
		-- if not enemy:IsMagicImmune() then
			-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash", {duration = self:GetSpecialValueFor("reduction_duration")}):SetDuration(self:GetSpecialValueFor("reduction_duration") * (1 - enemy:GetStatusResistance()), true)
		-- end
		
		-- -- "These instant attacks are allowed to trigger attack modifiers, except cleave, normally. Has True Strike."
		-- -- So funny thing about this actually...the VANILLA ability ignores CUSTOM cleave suppression (ex. Jarnbjorn), which means Anchor Smash still applies custom cleaves anyways...so I guess in ways this is actually nerfing the ability but bleh
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_tidehunter_anchor_smash_suppression", {})
		-- -- PerformAttack(target: CDOTA_BaseNPC, useCastAttackOrb: bool, processProcs: bool, skipCooldown: bool, ignoreInvis: bool, useProjectile: bool, fakeAttack: bool, neverMiss: bool): nil
		-- self:GetCaster():PerformAttack(enemy, false, true, true, false, false, false, true)
		-- self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_tidehunter_anchor_smash_suppression", self:GetCaster())
		
		-- -- IMBAfication: Angled
		-- if not bThrown then
			-- enemy:SetForwardVector(enemy:GetForwardVector() * (-1))
			-- enemy:FaceTowards(enemy:GetAbsOrigin() + enemy:GetForwardVector())
		-- end
	-- end
-- end

-- function imba_tidehunter_anchor_smash:OnProjectileThink_ExtraData(location, data)
	-- if not IsServer() then return end
	
	-- EntIndexToHScript(data.anchor_dummy):SetAbsOrigin(GetGroundPosition(location, nil))
-- end

-- function imba_tidehunter_anchor_smash:OnProjectileHit_ExtraData(target, location, data)
	-- if not IsServer() then return end
	
	-- -- Gush hit some unit
	-- if target then 
		-- self:Smash(target, true)
	-- else
		-- EntIndexToHScript(data.anchor_dummy):RemoveSelf()
	-- end
-- end

-- ---------------------------
-- -- ANCHOR SMASH MODIFIER --
-- ---------------------------

-- function modifier_imba_tidehunter_anchor_smash:OnCreated()
	-- if self:GetAbility() then
		-- self.damage_reduction	= self:GetAbility():GetTalentSpecialValueFor("damage_reduction")
	-- else
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_tidehunter_anchor_smash:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_tidehunter_anchor_smash:DeclareFunctions()
	-- local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_anchor_smash:GetModifierBaseDamageOutgoing_Percentage()
	-- return self.damage_reduction
-- end

-- ---------------------------------------
-- -- ANCHOR SMASH SUPPRESSION MODIFIER --
-- ---------------------------------------

-- -- I guess this will also be used for the bonus attack damage

-- function modifier_imba_tidehunter_anchor_smash_suppression:OnCreated()
	-- if self:GetAbility() then
		-- self.attack_damage	= self:GetAbility():GetSpecialValueFor("attack_damage")
	-- else
		-- self:Destroy()
	-- end
-- end

 -- -- MODIFIER_PROPERTY_SUPPRESS_CLEAVE does not work
-- function modifier_imba_tidehunter_anchor_smash_suppression:DeclareFunctions()
	-- local decFuncs = 
	-- {
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_SUPPRESS_CLEAVE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierPreAttack_BonusDamage()
	-- return self.attack_damage
-- end

-- function modifier_imba_tidehunter_anchor_smash_suppression:GetSuppressCleave()
	-- return 1
-- end

-- -- Hopefully this is enough random information to only suppress cleaves?...
-- function modifier_imba_tidehunter_anchor_smash_suppression:GetModifierTotalDamageOutgoing_Percentage(keys)
	-- if not keys.no_attack_cooldown and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.damage_flags == DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION then
		-- return -100
	-- end
-- end

-- --------------------------
-- -- ANCHOR SMASH HANDLER --
-- --------------------------

-- function modifier_imba_tidehunter_anchor_smash_handler:IsHidden()	return true end

-- function modifier_imba_tidehunter_anchor_smash_handler:DeclareFunctions()
	-- local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_anchor_smash_handler:OnOrder(keys)
	-- if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- -- Due to logic order, this is actually reversed
	-- if self:GetAbility():GetAutoCastState() then
		-- self:SetStackCount(0)
	-- else
		-- self:SetStackCount(1)
	-- end
-- end

-- ---------------------------------
-- -- ANCHOR SMASH THROW MODIFIER --
-- ---------------------------------

-- function modifier_imba_tidehunter_anchor_smash_throw:OnCreated(params)
	-- if not IsServer() then return end

	-- local models = {
		-- "models/items/tidehunter/tidehunter_fish_skeleton_lod.vmdl",
		-- "models/items/tidehunter/tidehunter_mine_lod.vmdl",
		-- "models/items/tidehunter/ancient_leviathan_weapon/ancient_leviathan_weapon_fx.vmdl",
		-- "models/items/tidehunter/claddish_cudgel/claddish_cudgel.vmdl",
		-- "models/items/tidehunter/claddish_cudgel/claddish_cudgel_octopus.vmdl",
		-- "models/items/tidehunter/krakens_bane/krakens_bane.vmdl",
		-- "models/items/tidehunter/living_iceberg_collection_weapon/living_iceberg_collection_weapon.vmdl",
		-- --"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_off_hand/ti_9_cache_tide_chelonia_mydas_off_hand.vmdl",
		-- --"models/items/tidehunter/ti_9_cache_tide_chelonia_mydas_weapon/ti_9_cache_tide_chelonia_mydas_weapon.vmdl",
		-- --"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_off_hand/ti_9_cache_tide_tidal_conqueror_off_hand.vmdl",
		-- --"models/items/tidehunter/ti_9_cache_tide_tidal_conqueror_weapon/ti_9_cache_tide_tidal_conqueror_weapon.vmdl",
		-- "models/items/tidehunter/tidebreaker_weapon/tidebreaker_weapon.vmdl"
	-- }
	
	-- -- Some models are originally oriented in a different way, so they have to be flipped to look proper
	-- local models_rotate = {
		-- 180,
		-- 180,
		-- 0,
		-- 0,
		-- 180,
		-- 0,
		-- 0,
		-- --180,
		-- --0, 
		-- --180,
		-- --0,
		-- 0
	-- }
	
	-- local randomSelection	= RandomInt(1, #models)
	-- local cursorPosition	= Vector(params.x, params.y, params.z)
	
	-- self.selected_model = models[randomSelection]
	-- self:GetParent():SetForwardVector(RotatePosition(Vector(0, 0, 0), QAngle(0, models_rotate[randomSelection], 0), ((cursorPosition - self:GetCaster():GetAbsOrigin()):Normalized())))
-- end

-- function modifier_imba_tidehunter_anchor_smash_throw:CheckState()
	-- local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	
	-- return state
-- end

-- function modifier_imba_tidehunter_anchor_smash_throw:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MODEL_CHANGE,
		-- MODIFIER_PROPERTY_VISUAL_Z_DELTA
	-- }
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_anchor_smash_throw:GetModifierModelChange()
	-- return self.selected_model or "models/heroes/tidehunter/tidehunter_anchor.vmdl"
-- end

-- function modifier_imba_tidehunter_anchor_smash_throw:GetVisualZDelta()
	-- return 150
-- end

-- -----------------------------
-- ------ 	   RAVAGE	  -------
-- -----------------------------
-- imba_tidehunter_ravage = imba_tidehunter_ravage or class({})

-- function imba_tidehunter_ravage:GetIntrinsicModifierName()
	-- return "modifier_imba_tidehunter_ravage_handler"
-- end

-- function imba_tidehunter_ravage:GetAOERadius()
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		-- return self:GetSpecialValueFor("radius")
	-- else
		-- return self:GetSpecialValueFor("creeping_radius")
	-- end
-- end

-- function imba_tidehunter_ravage:GetCastRange(location, target)
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		-- return self.BaseClass.GetCastRange(self, location, target)
	-- else
		-- return self:GetSpecialValueFor("creeping_range")
	-- end
-- end

-- function imba_tidehunter_ravage:GetBehavior()
	-- if self:GetCaster():GetModifierStackCount("modifier_imba_tidehunter_ravage_handler", self:GetCaster()) == 0 then
		-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- else
		-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	-- end
-- end

-- -- TODO: Destroy the knockback modifier after it's done
-- -- TODO: add a phased modifier for 0.5 secs
-- -- TODO: fix nyx stun animation too

-- function imba_tidehunter_ravage:OnSpellStart()
	-- if not self:GetAutoCastState() then
		-- -- Ability properties
		-- local caster			=	self:GetCaster()
		-- local caster_pos		=	caster:GetAbsOrigin()
		-- local cast_sound		=	"Ability.Ravage"
		-- local hit_sound			=	"Hero_Tidehunter.RavageDamage"
		-- local kill_responses	=	"tidehunter_tide_ability_ravage_0"
		-- local particle 			=	"particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf"
		-- -- Ability parameters
		-- local end_radius	=	self:GetSpecialValueFor("radius")
		-- local stun_duration	=	self:GetSpecialValueFor("duration")

		-- -- Emit sound
		-- caster:EmitSound(cast_sound)

		-- -- Emit particle
		-- self.particle_fx	=	ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
		-- ParticleManager:SetParticleControl(self.particle_fx, 0, caster_pos)
		-- -- Set each ring in it's position
		-- for i=1, 5 do
			-- ParticleManager:SetParticleControl(self.particle_fx, i, Vector(end_radius * 0.2 * i, 0 , 0))
		-- end
		-- ParticleManager:ReleaseParticleIndex(self.particle_fx)

		-- local radius =	end_radius * 0.2
		-- local ring	 =	1
		-- local ring_width = end_radius * 0.2
		-- local hit_units	=	{}

		-- -- Find units in a ring 5 times and hit them with ravage
		-- Timers:CreateTimer(function()
			-- local enemies =	FindUnitsInRing(caster:GetTeamNumber(),
				-- caster_pos,
				-- nil,
				-- ring * radius,
				-- radius,
				-- DOTA_UNIT_TARGET_TEAM_ENEMY,
				-- DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				-- DOTA_DAMAGE_FLAG_NONE,
				-- FIND_ANY_ORDER,
				-- false
			-- )

			-- for _,enemy in pairs(enemies) do
				-- -- Custom function, checks if the unit was hit already
				-- if not CheckIfInTable(hit_units, enemy) then
					-- -- Emit hit sound
					-- enemy:EmitSound(hit_sound)

					-- -- Apply stun and air time modifiers
					-- enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration}):SetDuration(stun_duration * (1 - enemy:GetStatusResistance()), true)

					-- -- Knock the enemy into the air
					-- local knockback =
					-- {
							-- knockback_duration = 0.5,
						-- duration = 0.5,
						-- knockback_distance = 0,
						-- knockback_height = 350,
					-- }
					-- enemy:RemoveModifierByName("modifier_knockback")
					-- enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

					-- Timers:CreateTimer(0.5, function()
						-- -- Apply damage
						-- local damageTable = {victim = enemy,
							-- damage = self:GetAbilityDamage(),
							-- damage_type = self:GetAbilityDamageType(),
							-- attacker = caster,
							-- ability = self
						-- }
						-- ApplyDamage(damageTable)

						-- -- Check if the enemy is a dead hero, if he is, emit kill response
						-- if not enemy:IsAlive() and enemy:IsHero() and RollPercentage(25) and caster:GetName() == "npc_dota_hero_tidehunter" then
							-- caster:EmitSound(kill_responses..RandomInt(1, 2))
						-- end

						-- -- We need to do this because the gesture takes it's fucking time to stop
						-- enemy:RemoveGesture(ACT_DOTA_FLAIL)
					-- end)

					-- -- Mark the enemy as hit to not get hit again
					-- table.insert(hit_units, enemy)
				-- end
			-- end

			-- -- Send the next ring
			-- if ring < 5 then
				-- ring = ring + 1
				-- return 0.2
			-- end
		-- end)
	-- else
		-- local stun_duration		= self:GetSpecialValueFor("duration")
	
		-- local creeping_range	= self:GetSpecialValueFor("creeping_range")
		-- local creeping_radius	= self:GetSpecialValueFor("creeping_radius")
	
		-- local waves = (creeping_range / creeping_radius / 2)
		-- local counter = 0
		-- local total_time = 1.38 -- This is the duration for the vanilla ability so let's use that too
		
		-- -- Need to save this variable as it's going to be repeatedly used within the timer
		-- local caster_pos	= self:GetCaster():GetAbsOrigin()
		-- local forward_vec	= (self:GetCursorPosition() - caster_pos):Normalized()
		
		-- Timers:CreateTimer(function()
			-- CreateModifierThinker(self:GetCaster(), self, "modifier_imba_tidehunter_ravage_creeping_wave", {
				-- duration		=	0.3, -- Kinda arbitrary but only want to show one wave of tentacles and not all five
				-- damage			=	self:GetAbilityDamage(),
				-- stun_duration	=	stun_duration,
				-- creeping_radius	=	creeping_radius
			-- }, 
			-- caster_pos + (forward_vec * counter * creeping_radius * 2 * ((creeping_range + GetCastRangeIncrease(self:GetCaster())) / creeping_range)), self:GetCaster():GetTeamNumber(), false)

			-- counter = counter + 1
			
			-- if counter <= waves then
				-- return total_time / waves
			-- end
		-- end)
	-- end
-- end

-- -----------------------------
-- -- RAVAGE HANDLER MODIFIER --
-- -----------------------------

-- function modifier_imba_tidehunter_ravage_handler:IsHidden()	return true end

-- function modifier_imba_tidehunter_ravage_handler:DeclareFunctions()
	-- local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	-- return decFuncs
-- end

-- function modifier_imba_tidehunter_ravage_handler:OnOrder(keys)
	-- if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- -- Due to logic order, this is actually reversed
	-- if self:GetAbility():GetAutoCastState() then
		-- self:SetStackCount(0)
	-- else
		-- self:SetStackCount(1)
	-- end
-- end

-- -----------------------------------
-- -- RAVAGE CREEPING WAVE MODIFIER --
-- -----------------------------------

-- function modifier_imba_tidehunter_ravage_creeping_wave:OnCreated(params)
	-- if not IsServer() then return end
	
	-- self.stun_duration		= params.stun_duration
	-- self.creeping_radius	= params.creeping_radius
	
	-- local ability			= self:GetAbility()
	-- local caster			= self:GetCaster()
	-- local damage			= params.damage
	-- local damage_type		= self:GetAbility():GetAbilityDamageType()

	-- self:GetParent():EmitSound("Ability.Ravage")

	-- self.ravage_particle	=	ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	-- ParticleManager:SetParticleControl(self.ravage_particle, 0, self:GetParent():GetAbsOrigin())
	-- for i= 1, 5 do
		-- ParticleManager:SetParticleControl(self.ravage_particle, i, Vector(self.creeping_radius, 0, 0))
	-- end
	
	-- local enemies =	FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.creeping_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)

	-- for _, enemy in pairs(enemies) do
		-- -- Emit hit sound
		-- enemy:EmitSound("Hero_Tidehunter.RavageDamage")

		-- local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN, enemy)
		-- ParticleManager:SetParticleControl(hit_particle, 0, GetGroundPosition(enemy:GetAbsOrigin(), nil))
		-- ParticleManager:ReleaseParticleIndex(hit_particle)

		-- -- Apply stun and air time modifiers
		-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.stun_duration}):SetDuration(self.stun_duration * (1 - enemy:GetStatusResistance()), true)

		-- -- Knock the enemy into the air
		-- local knockback =
		-- {
			-- knockback_duration	= 0.5,
			-- duration 			= 0.5,
			-- knockback_distance	= 0,
			-- knockback_height 	= 350,
		-- }
		
		-- enemy:RemoveModifierByName("modifier_knockback")
		-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_knockback", knockback)
		
		-- Timers:CreateTimer(0.5, function()
			-- -- Apply damage
			-- local damageTable = 
			-- {
				-- victim			= enemy,
				-- damage			= damage,
				-- damage_type		= damage_type,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker		= caster,
				-- ability			= ability
			-- }
			-- ApplyDamage(damageTable)

			-- if caster:GetName() == "npc_dota_hero_tidehunter" and not enemy:IsAlive() and enemy:IsRealHero() and RollPercentage(25) then
				-- caster:EmitSound("tidehunter_tide_ability_ravage_0"..RandomInt(1, 2))
			-- end
		-- end)
	-- end
-- end

-- function modifier_imba_tidehunter_ravage_creeping_wave:OnDestroy()
	-- if not IsServer() then return end
	
	-- ParticleManager:DestroyParticle(self.ravage_particle, false)
	-- ParticleManager:ReleaseParticleIndex(self.ravage_particle)
	-- self:GetParent():RemoveSelf()
-- end

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- LinkLuaModifier("modifier_special_bonus_imba_tidehunter_greater_hardening", "components/abilities/heroes/hero_tidehunter", LUA_MODIFIER_MOTION_NONE)

-- modifier_special_bonus_imba_tidehunter_greater_hardening	= class({})

-- function modifier_special_bonus_imba_tidehunter_greater_hardening:IsHidden() 		return true end
-- function modifier_special_bonus_imba_tidehunter_greater_hardening:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_tidehunter_greater_hardening:RemoveOnDeath() 	return false end

-- function imba_tidehunter_kraken_shell:OnOwnerSpawned()
	-- if not IsServer() then return end

	-- if self:GetCaster():HasTalent("special_bonus_imba_tidehunter_greater_hardening") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_tidehunter_greater_hardening") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_tidehunter_greater_hardening"), "modifier_special_bonus_imba_tidehunter_greater_hardening", {})
	-- end
-- end
