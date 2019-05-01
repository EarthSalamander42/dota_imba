-- Creator:
--	   AltiV, April 29th, 2019

LinkLuaModifier("modifier_imba_medusa_split_shot", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_serpent_shot", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_medusa_mana_shield", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_medusa_stone_gaze", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_facing", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_stone", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

imba_medusa_split_shot						= class({})
modifier_imba_medusa_split_shot				= class({})
modifier_imba_medusa_serpent_shot			= class({})

imba_medusa_mystic_snake					= class({})

imba_medusa_mana_shield						= class({})
modifier_imba_medusa_mana_shield			= class({})

imba_medusa_stone_gaze						= class({})
modifier_imba_medusa_stone_gaze				= class({})
modifier_imba_medusa_stone_gaze_facing		= class({})
modifier_imba_medusa_stone_gaze_stone		= class({})

----------------
-- SPLIT SHOT --
----------------

-- function imba_medusa_split_shot:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

function imba_medusa_split_shot:ResetToggleOnRespawn()
	return false
end

function imba_medusa_split_shot:GetIntrinsicModifierName()
	return "modifier_imba_medusa_split_shot"
end

function imba_medusa_split_shot:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_serpent_shot", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_medusa_serpent_shot", self:GetCaster())
	end
end

-------------------------
-- SPLIT SHOT MODIFIER --
-------------------------

function modifier_imba_medusa_split_shot:IsHidden()	return true end

function modifier_imba_medusa_split_shot:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }

    return decFuncs
end

function modifier_imba_medusa_split_shot:OnAttack(keys)
	if not IsServer() then return end
	
	-- "Secondary arrows are not released upon attacking allies."
	-- The "not keys.no_attack_cooldown" clause seems to make sure the function doesn't trigger on PerformAttacks with that false tag so this thing doesn't crash
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then	
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		local target_number = 0
		
		local apply_modifiers = self:GetParent():HasTalent("special_bonus_imba_medusa_split_shot_modifiers")
		
		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self.split_shot_target = true
				
				self:GetParent():PerformAttack(enemy, false, apply_modifiers, true, false, true, false, false)
				
				self.split_shot_target = false
				
				target_number = target_number + 1
				
				if target_number >= self:GetAbility():GetSpecialValueFor("arrow_count") then
					break
				end
			end
		end
	end
end

function modifier_imba_medusa_split_shot:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	
	if self.split_shot_target then
		return self:GetAbility():GetSpecialValueFor("damage_modifier")
	else
		return 0
	end
end

function modifier_imba_medusa_split_shot:GetActivityTranslationModifiers()
	return "split_shot"
end

---------------------------
-- SERPENT SHOT MODIFIER --
---------------------------

function modifier_imba_medusa_serpent_shot:IsPurgable()		return false end
function modifier_imba_medusa_serpent_shot:RemoveOnDeath()	return false end

function modifier_imba_medusa_serpent_shot:OnCreated()
	
end

function modifier_imba_medusa_serpent_shot:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_PROPERTY_PROJECTILE_NAME 
    }

    return decFuncs
end

-- Remove modifier if the ability doesn't exist (Morphling/Rubick exception)
function modifier_imba_medusa_serpent_shot:OnAttackRecord(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and not self:GetAbility() then
		self:Destroy()
	end
end

function modifier_imba_medusa_serpent_shot:GetModifierProjectileName()
	return "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf"
end

------------------
-- MYSTIC SNAKE --
------------------

function imba_medusa_mystic_snake:OnSpellStart()
	if not IsServer() then return end
			-- "01"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "radius"				"475 475 475 475"
			-- }
			-- "02"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "snake_jumps"			"3 4 5 6"
			-- }
			-- "03"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "jump_delay"			"0.25 0.25 0.25 0.25"
			-- }
			-- "04"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "snake_damage"			"80 120 160 200"
			-- }
			-- "05"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "snake_mana_steal"		"11 14 17 20"
				-- "LinkedSpecialBonus"			"special_bonus_unique_medusa_3"
			-- }
			-- "06"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "snake_scale"			"35"
			-- }
			-- "07"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "initial_speed"			"800"
			-- }
			-- "08"
			-- {
				-- "var_type"				"FIELD_INTEGER"
				-- "return_speed"			"800"
			-- }
			-- "09"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "stone_form_scepter_base"		"1.0"
			-- }
			-- "10"
			-- {
				-- "var_type"				"FIELD_FLOAT"
				-- "stone_form_scepter_increment"		"0.3"
			-- }
	
	self:GetCaster():EmitSound("Hero_Medusa.MysticSnake.Cast")
	
	if self:GetCaster():GetName() == "npc_dota_hero_medusa" and RollPercentage(75) then
		local random_response	= RandomInt(1, 6)
		
		-- Plays line 1 or lines 3-7
		if random_response >= 2 then random_response = random_response + 1 end
		
		self:GetCaster():EmitSound("medusa_medus_mysticsnake_0"..random_response)
	end	
	
	local particle_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_cast)
	
	local particle_snake = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_snake, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_snake, 1, self:GetCursorTarget():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_snake, 2, Vector(self:GetSpecialValueFor("initial_speed"), 0, 0))
	
	local targets = self:GetCursorTarget():GetEntityIndex()
	
	local snake =
		{
			Target 				= self:GetCursorTarget(),
			Source 				= self:GetCaster(),
			Ability 			= self,
			--EffectName 			= "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
			iMoveSpeed			= self:GetSpecialValueFor("initial_speed"),
			--vSourceLoc 			= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack2")), -- This does nothing
			bDrawsOnMinimap 	= false,
			bDodgeable 			= false,
			bIsAttack 			= false,
			bVisibleToEnemies 	= true,
			bReplaceExisting 	= false,
			flExpireTime 		= GameRules:GetGameTime() + 10,
			bProvidesVision 	= true,
			iVisionRadius 		= 100, -- AbilitySpecial?
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),

			ExtraData = {
				target			= target,
				bounces			= 0,
				damage			= self:GetSpecialValueFor("snake_damage"),
				particle_snake	= particle_snake,
			}
		}

	ProjectileManager:CreateTrackingProjectile(snake)	
end

function imba_medusa_mystic_snake:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsServer() or not hTarget then return end
	
	if hTarget:IsAlive() and not hTarget:IsInvulnerable() and not hTarget:IsOutOfGame() then
		hTarget:EmitSound("Hero_Medusa.MysticSnake.Target")
		
		local mana_stolen = 0
		
		-- "Applies the mana loss first, and then the damage (and then the Stone Gaze debuff [if scepter])."
		if hTarget:GetMana() and hTarget:GetMaxMana() then 
			-- Store amount of mana before stealing some
			local target_mana = hTarget:GetMana()
			
			hTarget:ReduceMana(hTarget:GetMaxMana() * self:GetSpecialValueFor("snake_mana_steal") * 0.01)
			
			mana_stolen = math.max(target_mana - hTarget:GetMana(), 0)
		end
		
		local damageTable = {
			victim 			= hTarget,
			damage 			= ExtraData.damage,
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
		
		ApplyDamage(damageTable)
		
		-- Add logic after Stone Gaze is complete
		if self:GetCaster():HasScepter() then
		
		end
		
		-- Increment bounce count
		ExtraData.bounces = ExtraData.bounces + 1
	end
	
	-- Small delay between bounces
	--Timers:CreateTimer(self:GetSpecialValueFor("jump_delay"), function()
		-- If the snake has not reached max bounces yet, look for nearby enemies
		if ExtraData.bounces < self:GetSpecialValueFor("snake_jumps") then
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			
			for _, enemy in pairs(enemies) do
				if enemy ~= hTarget then
				
					local snake =
						{
							Target 				= enemy,
							Source 				= hTarget,
							Ability 			= self,
							iMoveSpeed			= self:GetSpecialValueFor("initial_speed"),
							bDrawsOnMinimap 	= false,
							bDodgeable 			= false,
							bIsAttack 			= false,
							bVisibleToEnemies 	= true,
							bReplaceExisting 	= false,
							flExpireTime 		= GameRules:GetGameTime() + 10,
							bProvidesVision 	= true,
							iVisionRadius 		= 100, -- AbilitySpecial?
							iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),

							ExtraData = {
								target			= enemy:GetEntityIndex(),
								bounces			= ExtraData.bounces,
								damage			= ExtraData.damage + self:GetSpecialValueFor("snake_damage") * self:GetSpecialValueFor("snake_scale") * 0.01,
								particle_snake	= ExtraData.particle_snake,
							}
						}

					ProjectileManager:CreateTrackingProjectile(snake)
					
					ParticleManager:SetParticleControl(ExtraData.particle_snake, 1, enemy:GetAbsOrigin())
					break
				end
			end
		else
			ParticleManager:DestroyParticle(ExtraData.particle_snake, false)
			ParticleManager:ReleaseParticleIndex(ExtraData.particle_snake)
		end
	--end)
	
	
	-- local illumination_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_illumination.vpcf", PATTACH_POINT, hTarget)
	-- -- CP1 controls how long the particle stays for as the x coordinate of vector
	-- ParticleManager:SetParticleControl(illumination_particle, 1, Vector(self:GetSpecialValueFor("duration"), 0, 0))
	-- ParticleManager:ReleaseParticleIndex(illumination_particle)
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- local damage = self:GetAbilityDamage()
	
	-- -- Carpet Fire damage reduction
	-- if ExtraData.carpet_fire then
		-- damage = damage * self:GetSpecialValueFor("carpet_fire_damage") * 0.01
	-- end
	
	-- -- Retrieve where the Rocket Flare was originally fired from to check for System Critical IMBAfication
	-- local cast_position = Vector(ExtraData.x, ExtraData.y, ExtraData.z)
	
	-- for _, enemy in pairs(enemies) do
		-- -- Standard damage
		-- local flare_damage		= damage
		
		-- local travel_distance	= (enemy:GetAbsOrigin() - cast_position):Length2D()
		-- local target_distance	= (enemy:GetAbsOrigin() - vLocation):Length2D()
		
		-- -- IMBAfication: System Critical
		-- if travel_distance >= self:GetSpecialValueFor("system_min_distance") and (target_distance <= self:GetSpecialValueFor("system_radius") or (ExtraData.carpet_fire and (target_distance <= enemy:GetHullRadius()))) then
			-- -- For every multiple of "self:GetSpecialValueFor("system_min_distance")" (2500 is the original number) that the travel_distance is, the damage is boosted by self:GetSpecialValueFor("system_crit") as a percentage (175% is the original number)
			
			-- -- So if the flare lands true from exactly 2500 range away for example, the damage should be multiplied by 2.75 (175% critical = 275% of base damage)
			-- flare_damage = damage * (travel_distance / self:GetSpecialValueFor("system_min_distance")) * (self:GetSpecialValueFor("system_crit") + 100) * 0.01
			
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, enemy, flare_damage, nil)
			
			-- -- Destroy all their mana (only if not a Carpet Fire shot cause """balance""")
			-- if enemy.SetMana and not ExtraData.carpet_fire then
				-- enemy:SetMana(0)
			-- end
			
			-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_rocket_flare_critical", {duration = self:GetSpecialValueFor("system_duration")}):SetDuration(self:GetSpecialValueFor("system_duration") * (1 - enemy:GetStatusResistance()), true)
		-- end
	
		-- local damageTable = {
			-- victim 			= enemy,
			-- damage 			= flare_damage,
			-- damage_type		= self:GetAbilityDamageType(),
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
		-- }
		
		-- ApplyDamage(damageTable)
		
		-- -- Voice response for "Killing enemy, 6000 minimum travel distance"
		-- if not enemy:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and travel_distance >= 6000 then
			-- local random_response = RandomInt(8, 12)

			-- if random_response <= 9 then
				-- self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_0"..random_response)
			-- else
				-- self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_"..random_response)
			-- end
		-- end
	-- end
	
	-- AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)
	
	-- -- Truesight talent (Carpet Fire doesn't get this for "balance" reasons)
	-- if self:GetCaster():HasTalent("special_bonus_imba_rattletrap_rocket_flare_truesight") and not ExtraData.carpet_fire then
		-- local sight_area = CreateModifierThinker(self:GetCaster(), self, "modifier_item_gem_of_true_sight", {
			-- duration		= self:GetSpecialValueFor("duration")
		-- },
		-- vLocation, self:GetCaster():GetTeamNumber(), false)
	-- end
end

-----------------
-- MANA SHIELD --
-----------------

imba_medusa_mana_shield						= class({})

--------------------------
-- MANA SHIELD MODIFIER --
--------------------------

modifier_imba_medusa_mana_shield			= class({})

----------------
-- STONE GAZE --
----------------

imba_medusa_stone_gaze						= class({})

-------------------------
-- STONE GAZE MODIFIER --
-------------------------

modifier_imba_medusa_stone_gaze				= class({})

--------------------------------
-- STONE GAZE FACING MODIFIER --
--------------------------------

modifier_imba_medusa_stone_gaze_facing		= class({})

-------------------------------
-- STONE GAZE STONE MODIFIER --
-------------------------------

modifier_imba_medusa_stone_gaze_stone		= class({})



-- LinkLuaModifier("modifier_imba_rattletrap_battery_assault", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_rattletrap_battery_assault_fragmentation_rend", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_rattletrap_battery_assault_percussive_maint_aura", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_rattletrap_battery_assault_percussive_maint", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_rattletrap_power_cogs", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_rattletrap_cog_push", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_HORIZONTAL)
-- LinkLuaModifier("modifier_imba_rattletrap_power_cogs_charge_coil_counter", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_rattletrap_power_cogs_charge_coil_instance", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_rattletrap_rocket_flare_critical", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_imba_rattletrap_hookshot", "components/abilities/heroes/hero_rattletrap", LUA_MODIFIER_MOTION_HORIZONTAL)

-- imba_rattletrap_battery_assault									= class({})
-- modifier_imba_rattletrap_battery_assault						= class({})
-- modifier_imba_rattletrap_battery_assault_fragmentation_rend		= class({})
-- modifier_imba_rattletrap_battery_assault_percussive_maint_aura	= class({})
-- modifier_imba_rattletrap_battery_assault_percussive_maint		= class({})

-- imba_rattletrap_power_cogs										= class({})
-- modifier_imba_rattletrap_power_cogs								= class({})
-- modifier_imba_rattletrap_cog_push								= class({})
-- modifier_imba_rattletrap_power_cogs_charge_coil_counter			= class({})
-- modifier_imba_rattletrap_power_cogs_charge_coil_instance		= class({})

-- imba_rattletrap_rocket_flare									= class({})
-- modifier_imba_rattletrap_rocket_flare_critical					= class({})

-- imba_rattletrap_hookshot										= class({})
-- modifier_imba_rattletrap_hookshot								= class({})

-- ---------------------
-- -- BATTERY ASSAULT --
-- ---------------------

-- function imba_rattletrap_battery_assault:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_rattletrap_battery_assault:GetIntrinsicModifierName()
	-- return "modifier_imba_rattletrap_battery_assault_percussive_maint_aura"
-- end

-- function imba_rattletrap_battery_assault:OnSpellStart()
	-- if not IsServer() then return end
	
	-- self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_BATTERYASSAULT)
	
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" then
		-- local random_response	= RandomInt(3, 18)
	
		-- if random_response <= 9 then
			-- self:GetCaster():EmitSound("rattletrap_ratt_ability_batt_0"..random_response)
		-- else
			-- self:GetCaster():EmitSound("rattletrap_ratt_ability_batt_"..random_response)
		-- end
	-- end	
	
	-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_battery_assault", {duration = self:GetSpecialValueFor("duration")})
-- end

-- ------------------------------
-- -- BATTERY ASSAULT MODIFIER --
-- ------------------------------

-- -- function modifier_imba_rattletrap_battery_assault:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_rattletrap_battery_assault:OnCreated()
	-- -- AbilitySpecials
	-- self.radius		= self:GetAbility():GetSpecialValueFor("radius")
	-- self.interval	= self:GetAbility():GetTalentSpecialValueFor("interval")
	
	-- self.fragmentation_mult		= self:GetAbility():GetSpecialValueFor("fragmentation_mult")
	-- self.fragmentation_damage	= self:GetAbility():GetSpecialValueFor("fragmentation_damage")
	-- self.fragmentation_duration	= self:GetAbility():GetSpecialValueFor("fragmentation_duration")
	
	-- if not IsServer() then return end
	
	-- self.damage				= self:GetAbility():GetAbilityDamage()
	-- self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	-- self:GetParent():EmitSound("Hero_Rattletrap.Battery_Assault")
	
	-- -- Damages immediately on modifier creation
	-- self:OnIntervalThink()
	
	-- if self:GetAbility() and self:GetAbility():GetAutoCastState() then
		-- self:StartIntervalThink(self.interval / self.fragmentation_mult)
	-- else
		-- self:StartIntervalThink(self.interval)
	-- end
-- end

-- function modifier_imba_rattletrap_battery_assault:OnIntervalThink()
	-- if not IsServer() then return end

	-- self:GetParent():EmitSound("Hero_Rattletrap.Battery_Assault_Launch")

	-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_assault.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:ReleaseParticleIndex(particle)
	
	-- local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	-- if #enemies >= 1 then
		-- enemies[1]:EmitSound("Hero_Rattletrap.Battery_Assault_Impact")
	
		-- ParticleManager:SetParticleControl(particle2, 1, enemies[1]:GetAbsOrigin())
		
		-- -- Standard logic
		-- if not self:GetAbility() or (self:GetAbility() and not self:GetAbility():GetAutoCastState()) then
			-- local damageTable = {
				-- victim 			= enemies[1],
				-- damage 			= self.damage,
				-- damage_type		= self.damage_type,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetCaster(),
				-- ability 		= self:GetAbility()
			-- }

			-- ApplyDamage(damageTable)
		
			-- local stun_modifier	= enemies[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1})
			
			-- if stun_modifier then
				-- stun_modifier:SetDuration(0.1 * (1 - enemies[1]:GetStatusResistance()), true)
			-- end
		-- else
			-- -- IMBAfication: Fragmentation Rend
			-- local damageTable = {
				-- victim 			= enemies[1],
				-- damage 			= self.damage * self.fragmentation_damage * 0.01,
				-- damage_type		= self.damage_type,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetCaster(),
				-- ability 		= self:GetAbility()
			-- }

			-- ApplyDamage(damageTable)
		
			-- local fragmentation_modifier	= enemies[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_battery_assault_fragmentation_rend", {duration = self.fragmentation_duration})
			
			-- if fragmentation_modifier then
				-- fragmentation_modifier:SetDuration(self.fragmentation_duration * (1 - enemies[1]:GetStatusResistance()), true)
			-- end
		-- end
	-- else
		-- ParticleManager:SetParticleControl(particle2, 1, self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, 128))) -- Arbitrary numbers
	-- end
	
	-- ParticleManager:ReleaseParticleIndex(particle)
	
	-- if self:GetAbility() and self:GetAbility():GetAutoCastState() then
		-- self:StartIntervalThink(self.interval / self.fragmentation_mult)
	-- else
		-- self:StartIntervalThink(self.interval)
	-- end
-- end

-- function modifier_imba_rattletrap_battery_assault:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():StopSound("Hero_Rattletrap.Battery_Assault")
-- end

-- -------------------------------------------------
-- -- BATTERY ASSAULT FRAGMENTATION REND MODIFIER --
-- -------------------------------------------------

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:OnCreated()
	-- if self:GetAbility() then
		-- self.fragmentation_vuln		= self:GetAbility():GetSpecialValueFor("fragmentation_vuln")
		-- self.fragmentation_vision	= self:GetAbility():GetSpecialValueFor("fragmentation_vision")
		-- self.fragmentation_resist	= self:GetAbility():GetSpecialValueFor("fragmentation_resist")
	-- else
		-- self:Destroy()
		-- return
	-- end
	
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:OnRefresh()
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		-- MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:GetModifierIncomingDamage_Percentage()
	-- return self:GetStackCount() * self.fragmentation_vuln
-- end

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:GetModifierStatusResistanceStacking()
	-- return self:GetStackCount() * self.fragmentation_resist
-- end

-- function modifier_imba_rattletrap_battery_assault_fragmentation_rend:GetBonusVisionPercentage()
	-- return self:GetStackCount() * self.fragmentation_vision
-- end

-- ------------------------------------------------
-- -- BATTERY ASSAULT PERCUSSIVE MAINTENACE AURA --
-- ------------------------------------------------

-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:IsHidden() 				return true end

-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:IsAura() 				return true end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:IsAuraActiveOnDeath() 	return false end

-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetAuraRadius()			return self:GetAbility():GetTalentSpecialValueFor("percussive_maint_radius") end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetModifierAura()		return "modifier_imba_rattletrap_battery_assault_percussive_maint" end
-- function modifier_imba_rattletrap_battery_assault_percussive_maint_aura:GetAuraEntityReject(hEntity) return self:GetCaster():PassivesDisabled() end

-- ----------------------------------------------------
-- -- BATTERY ASSAULT PERCUSSIVE MAINTENACE MODIFIER --
-- ----------------------------------------------------

-- function modifier_imba_rattletrap_battery_assault_percussive_maint:OnCreated()
	-- self.percussive_maint_base_chance	= self:GetAbility():GetSpecialValueFor("percussive_maint_base_chance")
	-- self.percussive_maint_frag_chance	= self:GetAbility():GetSpecialValueFor("percussive_maint_frag_chance")
-- end

-- function modifier_imba_rattletrap_battery_assault_percussive_maint:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_battery_assault_percussive_maint:OnAttackLanded(keys)
	-- if not IsServer() then return end

	-- if keys.target == self:GetParent() then
		-- if (not self:GetAbility() or not self:GetAbility():GetAutoCastState()) then
			-- if RollPercentage(self.percussive_maint_base_chance) then
				-- self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_battery_assault", {duration = FrameTime()})
			-- end
		-- elseif RollPercentage(self.percussive_maint_frag_chance) then
			-- self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_battery_assault", {duration = FrameTime()})
		-- end
	-- end
-- end

-- ----------------
-- -- POWER COGS --
-- ----------------

-- function imba_rattletrap_power_cogs:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_rattletrap_power_cogs:OnSpellStart()
	-- if not IsServer() then return end
	
	-- local caster_pos		= self:GetCaster():GetAbsOrigin()
	
	-- local num_of_cogs		= 8 -- You're probably gonna get some really weird results if you change this number
	-- local cogs_radius		= self:GetSpecialValueFor("cogs_radius")
	
	-- local cog_vector 		= GetGroundPosition(caster_pos + Vector(0, cogs_radius, 0), nil)
	-- local second_cog_vector	= GetGroundPosition(caster_pos + Vector(0, cogs_radius * 2, 0), nil)
	
	-- self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_POWERCOGS)
	
	-- for cog = 1, num_of_cogs do
		-- local cog = CreateUnitByName("npc_dota_rattletrap_cog", cog_vector, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		-- cog:EmitSound("Hero_Rattletrap.Power_Cogs")
		
		-- cog:AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_power_cogs",
		-- {
			-- duration 	= self:GetSpecialValueFor("duration"),
			-- x 			= (cog_vector - caster_pos).x,
			-- y 			= (cog_vector - caster_pos).y,
			
			-- -- Also need to store these for the Rotational IMBAfication
			-- center_x	= caster_pos.x,
			-- center_y	= caster_pos.y,
			-- center_z	= caster_pos.z
		-- })
		
		-- -- Talent: Second Gear (might be too laggy with Rotational...)
		-- if self:GetCaster():HasTalent("special_bonus_imba_rattletrap_second_gear") then
			-- local second_cog = CreateUnitByName("npc_dota_rattletrap_cog", second_cog_vector, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
			
			-- second_cog:EmitSound("Hero_Rattletrap.Power_Cogs")
			
			-- second_cog:AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_power_cogs",
			-- {
				-- duration 	= self:GetSpecialValueFor("duration"),
				-- x 			= (second_cog_vector - caster_pos).x,
				-- y 			= (second_cog_vector - caster_pos).y,
				
				-- -- Also need to store these for the Rotational IMBAfication
				-- center_x	= caster_pos.x,
				-- center_y	= caster_pos.y,
				-- center_z	= caster_pos.z,
				-- second_gear	= true
			-- })
			
			-- second_cog_vector	= RotatePosition(caster_pos, QAngle(0, 360 / num_of_cogs, 0), second_cog_vector)
		-- end
		
		-- cog_vector		= RotatePosition(caster_pos, QAngle(0, 360 / num_of_cogs, 0), cog_vector)
	-- end
	
	-- local deploy_particle	= ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_cog_deploy.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	-- ParticleManager:ReleaseParticleIndex(deploy_particle)
	
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and RollPercentage(50) then
		-- local responses	= {"rattletrap_ratt_ability_cogs_01", "rattletrap_ratt_ability_cogs_02", "rattletrap_ratt_ability_cogs_07"}
	
		-- self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
	-- end		
	
	-- local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("cogs_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- -- Set everyone nearby to get "sucked" into cogs, otherwise you sometimes have people stuck in-between cogs
	-- for _, unit in pairs(units) do
		-- -- Friendly units won't get displaced towards caster, while enemies do
		-- if unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			-- FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), false)
		-- else
			-- FindClearSpaceForUnit(unit, self:GetCaster():GetAbsOrigin() + RandomVector(self:GetSpecialValueFor("extra_pull_buffer")), false)
		-- end
	-- end
-- end

-- -------------------------
-- -- POWER COGS MODIFIER --
-- -------------------------

-- function modifier_imba_rattletrap_power_cogs:IsHidden()		return true end
-- function modifier_imba_rattletrap_power_cogs:IsPurgable()	return false end

-- function modifier_imba_rattletrap_power_cogs:GetEffectName()
	-- -- No idea if this is actually a thing but w/e using assets as I see them
	-- return "particles/units/heroes/hero_rattletrap/rattletrap_cog_ambient_blur.vpcf"
-- end

-- function modifier_imba_rattletrap_power_cogs:OnCreated(params)
	-- if self:GetAbility() then
		-- self.damage					= self:GetAbility():GetSpecialValueFor("damage")
		-- self.mana_burn				= self:GetAbility():GetSpecialValueFor("mana_burn")
		-- self.attacks_to_destroy		= self:GetAbility():GetSpecialValueFor("attacks_to_destroy")
		-- self.push_length			= self:GetAbility():GetTalentSpecialValueFor("push_length")
		-- self.push_duration			= self:GetAbility():GetSpecialValueFor("push_duration")
		-- self.trigger_distance		= self:GetAbility():GetSpecialValueFor("trigger_distance")
		-- self.rotational_speed		= self:GetAbility():GetSpecialValueFor("rotational_speed")
		-- self.charge_coil_duration	= self:GetAbility():GetSpecialValueFor("charge_coil_duration")
		
		-- -- Use this variable to track if the cog is currently charged
		-- self.powered			= true
		-- -- Use this variable to track how much "health" the cog has (the health doesn't actually change in vanilla)
		-- self.health				= self:GetAbility():GetSpecialValueFor("attacks_to_destroy")
	-- else
		-- self:Destroy()
		-- return
	-- end
	
	-- if not IsServer() then return end
	
	-- -- Make the cog face a certain way to determine when it should shock people using its "face"
	-- self:GetParent():SetForwardVector(Vector(params.x, params.y, 0))
	
	-- -- Get the center of all the cogs (basically where the caster cast this spell)
	-- self.center_loc		= Vector(params.center_x, params.center_y, params.center_z)
	
	-- -- Check if the cog is from the Second Gear talent (it will be rotating the other way under Rotational)
	-- self.second_gear	= params.second_gear
	
	-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_cog_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControl(self.particle, 62, Vector(0, 0, 0))
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- self:OnIntervalThink()
	-- self:StartIntervalThink(FrameTime())
-- end

-- function modifier_imba_rattletrap_power_cogs:OnIntervalThink()
	-- if not IsServer() then return end
	
	-- if self:GetAbility() and self:GetAbility():GetAutoCastState() then
		
		-- if not self.second_gear then
			-- self:GetParent():SetAbsOrigin(GetGroundPosition(RotatePosition(self.center_loc, QAngle(0, self.rotational_speed * FrameTime(), 0), self:GetParent():GetAbsOrigin()), nil))
		-- else
			-- self:GetParent():SetAbsOrigin(GetGroundPosition(RotatePosition(self.center_loc, QAngle(0, self.rotational_speed * FrameTime() * (-1), 0), self:GetParent():GetAbsOrigin()), nil))		
		-- end
		
		-- -- Update forward vector to face away from the center
		-- self:GetParent():SetForwardVector(self:GetParent():GetAbsOrigin() - self.center_loc)
		-- -- Try to make sure people don't get stuck in-between the cogs if they slip in a gap
		-- ResolveNPCPositions(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius())
	-- end
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.trigger_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, FIND_CLOSEST, false)
	
	-- for _, enemy in pairs(enemies) do
		-- -- QANGLES, HOW DO THEY WORK
		-- -- Basically this if statement checks if the cog is powered (i.e. hasn't pushed someone yet), if the target themselves isn't already being pushed by another cog, and if the difference between the cog's "face" vector and the directional vector between the enemy and the cog is less than 90 degrees both ways (so 180 degrees of the cog face is valid for shocking)
		-- if self.powered and not enemy:HasModifier("modifier_imba_rattletrap_cog_push") and math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= 90 then
		
			-- -- The cog is the caster here, as its position will be passed into the modifier
			-- enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rattletrap_cog_push", 
			-- {
				-- duration	= self.push_duration,
				
				-- damage		= self.damage,
				-- mana_burn	= self.mana_burn,
				-- push_length	= self.push_length
			-- })
			
			-- self.powered	= false
			-- ParticleManager:DestroyParticle(self.particle, false)
			-- ParticleManager:ReleaseParticleIndex(self.particle)
			
			-- -- Can't break interval think anymore if I want to have the Rotational IMBAfication handled here too
			-- --self:StartIntervalThink(-1)
			-- break
		-- end
	-- end
-- end

-- function modifier_imba_rattletrap_power_cogs:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():StopSound("Hero_Rattletrap.Power_Cogs")
	-- self:GetParent():EmitSound("Hero_Rattletrap.Power_Cog.Destroy")
	
	-- if self:GetRemainingTime() <= 0 then
		-- self:GetParent():RemoveSelf()
	-- end
-- end

-- function modifier_imba_rattletrap_power_cogs:CheckState()
	-- local state = {
		-- [MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	-- }

	-- return state
-- end

-- function modifier_imba_rattletrap_power_cogs:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		-- MODIFIER_EVENT_ON_ATTACK_LANDED
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_power_cogs:GetAbsoluteNoDamageMagical()
    -- return 1
-- end

-- function modifier_imba_rattletrap_power_cogs:GetAbsoluteNoDamagePhysical()
    -- return 1
-- end

-- function modifier_imba_rattletrap_power_cogs:GetAbsoluteNoDamagePure()
    -- return 1
-- end

-- function modifier_imba_rattletrap_power_cogs:OnAttackLanded(keys)
    -- if not IsServer() then return end
	
	-- if keys.target == self:GetParent() then
		-- if keys.attacker == self:GetCaster() then
			-- self:GetParent():Kill(nil, self:GetCaster())
			-- keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_power_cogs_charge_coil_counter",
			-- {
				-- duration		= self.charge_coil_duration,
				-- push_duration	= self.push_duration,
				-- damage			= self.damage,
				-- mana_burn		= self.mana_burn,
				-- push_length		= self.push_length,
			-- })
			-- keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_power_cogs_charge_coil_instance", {duration = 20})
		-- else
			-- self.health = self.health - 1
			
			-- if self.health <= 0 then
				-- self:GetParent():Kill(nil, keys.attacker)
				
				-- if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
					-- keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_power_cogs_charge_coil_counter", 
					-- {
						-- duration		= self.charge_coil_duration,
						-- push_duration	= self.push_duration,
						-- damage			= self.damage,
						-- mana_burn		= self.mana_burn,
						-- push_length		= self.push_length,
					-- })
					-- keys.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_power_cogs_charge_coil_instance", {duration = 20})
				-- end
			-- end
		-- end
	-- end
-- end

-- ------------------------------
-- -- POWER COGS PUSH MODIFIER --
-- ------------------------------

-- function modifier_imba_rattletrap_cog_push:OnCreated(params)
	-- if not IsServer() then return end
	
	-- self.duration			= params.duration
	-- self.damage				= params.damage
	-- self.mana_burn			= params.mana_burn
	-- self.push_length		= params.push_length
	
	-- -- This is purely for if a cog is destroyed while it is applying a push, so the attacker can be rerouted to the cog owner to properly deal damage
	-- self.owner				= self:GetCaster():GetOwner() or self:GetCaster()

	-- -- Normally I put the sounds and particles in the spell cast, but due to having two sources that can potentially call this modifier, I'm putting them in here
	-- self:GetCaster():EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
	
	-- -- Create cog zap particle
	-- local attack_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_cog_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	
	-- if self:GetCaster():GetName() == "npc_dota_rattletrap_cog" then
		-- ParticleManager:SetParticleControlEnt(attack_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	-- else
		-- -- Charge Coil particle attachment
		-- ParticleManager:SetParticleControlEnt(attack_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	-- end
	
	-- -- Calculate speed at which modifier owner will be knocked back
	-- self.knockback_speed		= self.push_length / self.duration
	
	-- -- Get the center of the cog to know which direction to get knocked back
	-- self.position	= self:GetCaster():GetAbsOrigin()
	
	-- -- If horizontal motion cannot be applied, remove the modifier
	-- if self:ApplyHorizontalMotionController() == false then 
		-- self:Destroy()
		-- return
	-- end
-- end

-- function modifier_imba_rattletrap_cog_push:UpdateHorizontalMotion( me, dt )
	-- if not IsServer() then return end

	-- local distance = (me:GetOrigin() - self.position):Normalized()
	
	-- me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
-- end

-- -- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
-- function modifier_imba_rattletrap_cog_push:OnHorizontalMotionInterrupted()
	-- self:Destroy()
-- end

-- function modifier_imba_rattletrap_cog_push:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():RemoveHorizontalMotionController( self )
	
	-- -- "Applies the damage first, and then the mana loss."
	-- local damageTable = {
		-- victim 			= self:GetParent(),
		-- damage 			= self.damage,
		-- damage_type		= DAMAGE_TYPE_MAGICAL,
		-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		-- attacker 		= self:GetCaster(),
		-- ability 		= self:GetAbility()
	-- }
	
	-- if not damageTable.attacker then
		-- damageTable.attacker = self.owner
	-- end
	
	-- ApplyDamage(damageTable)
	
	-- self:GetParent():ReduceMana(self.mana_burn)
	
	-- -- "At the end of the knock back, trees within a 100 radius of the unit are destroyed."
	-- GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 100, true )
-- end

-- function modifier_imba_rattletrap_cog_push:CheckState()
	-- local state = {
	-- [MODIFIER_STATE_STUNNED] = true
	-- }

	-- return state
-- end

-- function modifier_imba_rattletrap_cog_push:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_cog_push:GetOverrideAnimation()
	 -- return ACT_DOTA_FLAIL
-- end

-- ---------------------------------------------
-- -- POWER COGS CHARGE COIL COUNTER MODIFIER --
-- ---------------------------------------------

-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:OnStackCountChanged()
	-- if not IsServer() then return end
	
	-- -- If there are no charges on charge coil, remove the modifier
	-- if self:GetStackCount() <= 0 then
		-- -- Safety destructors (this should never be called ideally cause they'd be handled naturally)
		-- local charge_coil_instances = self:GetParent():FindAllModifiersByName("modifier_imba_rattletrap_power_cogs_charge_coil_instance")
		
		-- if #charge_coil_instances >= 1 then
			-- for _, modifier in pairs(charge_coil_instances) do
				-- modifier:Destroy()
			-- end
		-- end
		
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:OnCreated(params)
	-- if not IsServer() then return end
	
	-- -- These are needed to feed into the knockback modifier from a separate entity (since it'd be an attacker and not a cog this time)
	-- self.push_duration		= params.push_duration
	-- self.damage				= params.damage
	-- self.mana_burn			= params.mana_burn
	-- self.push_length		= params.push_length
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:OnRefresh()
	-- if not IsServer() then return end
	
	-- self:IncrementStackCount()
-- end

-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		-- MODIFIER_EVENT_ON_ATTACK_FAIL
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:OnAttackLanded(keys)
	-- if not IsServer() then return end
	
	-- -- Charge Coil will not work on buildings, ward-type units, magic immune enemies, or other cogs, and only works if they don't already have the push modifier
	-- if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsMagicImmune() and not keys.target:IsOther() and keys.target:GetName() ~= "npc_dota_rattletrap_cog" and not keys.target:HasModifier("modifier_imba_rattletrap_cog_push") then
	
		-- local charge_coil_instances = self:GetParent():FindAllModifiersByName("modifier_imba_rattletrap_power_cogs_charge_coil_instance")
		
		-- if #charge_coil_instances >= 1 then
			-- keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rattletrap_cog_push", 
			-- {
				-- duration	= self.push_duration,
					
				-- damage		= self.damage,
				-- mana_burn	= self.mana_burn,
				-- push_length	= 0
			-- })
		
			-- charge_coil_instances[1]:Destroy()
		-- end
	-- end
-- end

-- -- Charge Coil loses a stack if the modifier holder is a ranged attacker it misses (something something LOGIC IN MY VIDEO GAMES???)
-- function modifier_imba_rattletrap_power_cogs_charge_coil_counter:OnAttackFail(keys)
	-- if not IsServer() then return end
	
	-- -- Charge Coil will not work on buildings, ward-type units, magic immune enemies, or other cogs, and only works if they don't already have the push modifier
	-- if keys.attacker:IsRangedAttacker() and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsMagicImmune() and not keys.target:IsOther() and keys.target:GetName() ~= "npc_dota_rattletrap_cog" and not keys.target:HasModifier("modifier_imba_rattletrap_cog_push") then
	
		-- local charge_coil_instances = self:GetParent():FindAllModifiersByName("modifier_imba_rattletrap_power_cogs_charge_coil_instance")
		
		-- if #charge_coil_instances >= 1 then
			-- charge_coil_instances[1]:Destroy()
		-- end
	-- end
-- end

-- ----------------------------------------------
-- -- POWER COGS CHARGE COIL INSTANCE MODIFIER --
-- ----------------------------------------------

-- function modifier_imba_rattletrap_power_cogs_charge_coil_instance:IsHidden()		return true end
-- function modifier_imba_rattletrap_power_cogs_charge_coil_instance:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- function modifier_imba_rattletrap_power_cogs_charge_coil_instance:OnDestroy()
	-- if not IsServer() then return end
	
	-- local charge_coil_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_rattletrap_power_cogs_charge_coil_counter", self:GetCaster())
	
	-- if charge_coil_modifier then
		-- charge_coil_modifier:DecrementStackCount()
	-- end
-- end

-- ------------------
-- -- ROCKET FLARE --
-- ------------------

-- function imba_rattletrap_rocket_flare:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_rattletrap_rocket_flare:GetAOERadius()
	-- return self:GetSpecialValueFor("radius")
-- end

-- function imba_rattletrap_rocket_flare:OnSpellStart()
	-- if not IsServer() then return end
	
	-- -- This temporarily deletes the rocket model from Clockwerk
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" then	
		-- self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_0"..RandomInt(1, 7))
	
		-- if self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_MISC ) then
			-- self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_MISC ):AddEffects(EF_NODRAW)
		-- end
	-- end
	
	-- -- Standard logic
	-- if not self:GetAutoCastState() then
		-- -- Why is this a tracking projectile...
		-- local rocket_target = CreateModifierThinker(self:GetCaster(), self, nil, {
				-- duration		= FrameTime() -- Don't really need these things to be existing at all except to be a target for the rocket to go towards -_-
			-- },
			-- self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
		
		-- -- This "dummy" literally only exists to attach the rocket travel sound to
		-- local rocket_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {},	self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		-- if self:GetCaster():HasTalent("special_bonus_imba_rattletrap_rocket_flare_truesight") then
			-- rocket_dummy:AddNewModifier(self:GetCaster(), self, "modifier_item_gem_of_true_sight", {})
		-- end
		
		-- -- Need to look at how to shoot the rocket from the correct place + make the rocet "disappear" from Clockwerk for the duration
		-- local rocket_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControl(rocket_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket")))
		-- ParticleManager:SetParticleControl(rocket_particle, 1, self:GetCursorPosition())
		-- ParticleManager:SetParticleControl(rocket_particle, 2, Vector(self:GetSpecialValueFor("speed"), 0, 0))
		
		-- local rocket =
			-- {
				-- Target 				= rocket_target,
				-- Source 				= self:GetCaster(),
				-- Ability 			= self,
				-- --EffectName 			= "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", // IDK why this works as a projectile but you have to use it like a particle anyways and split everything up ugh
				-- iMoveSpeed			= self:GetSpecialValueFor("speed"),
				-- vSourceLoc 			= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket")),
				-- bDrawsOnMinimap 	= true,
				-- bDodgeable 			= true,
				-- bIsAttack 			= false,
				-- bVisibleToEnemies 	= true,
				-- bReplaceExisting 	= false,
				-- flExpireTime 		= GameRules:GetGameTime() + 20,
				-- bProvidesVision 	= true,
				-- iVisionRadius 		= self:GetSpecialValueFor("vision_radius"),
				-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),

				-- ExtraData = {rocket_dummy = rocket_dummy:entindex(), rocket_particle = rocket_particle, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y, z = self:GetCaster():GetAbsOrigin().z}
			-- }
		
		-- self:GetCaster():EmitSound("Hero_Rattletrap.Rocket_Flare.Fire")
		-- rocket_dummy:EmitSound("Hero_Rattletrap.Rocket_Flare.Travel")
		
		-- ProjectileManager:CreateTrackingProjectile(rocket)
	-- else
		-- -- IMBAfication: Carpet Fire
		-- for instance = 0, self:GetSpecialValueFor("carpet_fire_rockets") - 1 do
			-- local cursor_position = self:GetCursorPosition()
			
			-- -- Copy pasting the above code with minor visions for stuff like location and damage
			-- Timers:CreateTimer(self:GetSpecialValueFor("carpet_fire_delay") * instance, function()
				-- -- You never know if things are going to go around deleting themselves before they fire...
				-- if self then
					-- local random_position = cursor_position + RandomVector(RandomInt(0, self:GetSpecialValueFor("radius") * self:GetSpecialValueFor("carpet_fire_spread")))
				
					-- -- Why is this a tracking projectile...
					-- local rocket_target = CreateModifierThinker(self:GetCaster(), self, nil, {
							-- duration		= FrameTime() -- Don't really need these things to be existing at all except to be a target for the rocket to go towards -_-
						-- },
						-- random_position, self:GetCaster():GetTeamNumber(), false)
					
					-- -- This "dummy" literally only exists to attach the rocket travel sound to
					-- local rocket_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {},	self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
					
					-- -- Need to look at how to shoot the rocket from the correct place + make the rocet "disappear" from Clockwerk for the duration
					-- local rocket_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
					-- ParticleManager:SetParticleControl(rocket_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket")))
					-- ParticleManager:SetParticleControl(rocket_particle, 1, random_position)
					-- ParticleManager:SetParticleControl(rocket_particle, 2, Vector(self:GetSpecialValueFor("speed"), 0, 0))
					
					-- local rocket =
						-- {
							-- Target 				= rocket_target,
							-- Source 				= self:GetCaster(),
							-- Ability 			= self,
							-- --EffectName 			= "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf", // IDK why this works as a projectile but you have to use it like a particle anyways and split everything up ugh
							-- iMoveSpeed			= self:GetSpecialValueFor("speed"),
							-- vSourceLoc 			= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket")),
							-- bDrawsOnMinimap 	= true,
							-- bDodgeable 			= true,
							-- bIsAttack 			= false,
							-- bVisibleToEnemies 	= true,
							-- bReplaceExisting 	= false,
							-- flExpireTime 		= GameRules:GetGameTime() + 20,
							-- bProvidesVision 	= true,
							-- iVisionRadius 		= self:GetSpecialValueFor("vision_radius"),
							-- iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),

							-- ExtraData = {rocket_dummy = rocket_dummy:entindex(), rocket_particle = rocket_particle, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y, z = self:GetCaster():GetAbsOrigin().z, carpet_fire = true}
						-- }
					
					-- self:GetCaster():EmitSound("Hero_Rattletrap.Rocket_Flare.Fire")
					-- rocket_dummy:EmitSound("Hero_Rattletrap.Rocket_Flare.Travel")
					
					-- ProjectileManager:CreateTrackingProjectile(rocket)
				-- end
			-- end)
		-- end
	-- end
-- end

-- -- Make the travel sound follow the rocket
-- function imba_rattletrap_rocket_flare:OnProjectileThink_ExtraData(vLocation, ExtraData)
	-- if not IsServer() then return end
	
	-- EntIndexToHScript(ExtraData.rocket_dummy):SetAbsOrigin(vLocation)
-- end

-- function imba_rattletrap_rocket_flare:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	-- if not IsServer() then return end
	
	-- ParticleManager:DestroyParticle(ExtraData.rocket_particle, false)
	-- ParticleManager:ReleaseParticleIndex(ExtraData.rocket_particle)
	
	-- -- This brings back the rocket model for Clockwerk
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_MISC ) then
		-- self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_MISC ):RemoveEffects(EF_NODRAW)
	-- end
	
	-- EntIndexToHScript(ExtraData.rocket_dummy):StopSound("Hero_Rattletrap.Rocket_Flare.Travel")
	-- EntIndexToHScript(ExtraData.rocket_dummy):RemoveSelf()
	-- EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Explode", self:GetCaster())
	
	-- local illumination_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_illumination.vpcf", PATTACH_POINT, hTarget)
	-- -- CP1 controls how long the particle stays for as the x coordinate of vector
	-- ParticleManager:SetParticleControl(illumination_particle, 1, Vector(self:GetSpecialValueFor("duration"), 0, 0))
	-- ParticleManager:ReleaseParticleIndex(illumination_particle)
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- local damage = self:GetAbilityDamage()
	
	-- -- Carpet Fire damage reduction
	-- if ExtraData.carpet_fire then
		-- damage = damage * self:GetSpecialValueFor("carpet_fire_damage") * 0.01
	-- end
	
	-- -- Retrieve where the Rocket Flare was originally fired from to check for System Critical IMBAfication
	-- local cast_position = Vector(ExtraData.x, ExtraData.y, ExtraData.z)
	
	-- for _, enemy in pairs(enemies) do
		-- -- Standard damage
		-- local flare_damage		= damage
		
		-- local travel_distance	= (enemy:GetAbsOrigin() - cast_position):Length2D()
		-- local target_distance	= (enemy:GetAbsOrigin() - vLocation):Length2D()
		
		-- -- IMBAfication: System Critical
		-- if travel_distance >= self:GetSpecialValueFor("system_min_distance") and (target_distance <= self:GetSpecialValueFor("system_radius") or (ExtraData.carpet_fire and (target_distance <= enemy:GetHullRadius()))) then
			-- -- For every multiple of "self:GetSpecialValueFor("system_min_distance")" (2500 is the original number) that the travel_distance is, the damage is boosted by self:GetSpecialValueFor("system_crit") as a percentage (175% is the original number)
			
			-- -- So if the flare lands true from exactly 2500 range away for example, the damage should be multiplied by 2.75 (175% critical = 275% of base damage)
			-- flare_damage = damage * (travel_distance / self:GetSpecialValueFor("system_min_distance")) * (self:GetSpecialValueFor("system_crit") + 100) * 0.01
			
			-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, enemy, flare_damage, nil)
			
			-- -- Destroy all their mana (only if not a Carpet Fire shot cause """balance""")
			-- if enemy.SetMana and not ExtraData.carpet_fire then
				-- enemy:SetMana(0)
			-- end
			
			-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_rocket_flare_critical", {duration = self:GetSpecialValueFor("system_duration")}):SetDuration(self:GetSpecialValueFor("system_duration") * (1 - enemy:GetStatusResistance()), true)
		-- end
	
		-- local damageTable = {
			-- victim 			= enemy,
			-- damage 			= flare_damage,
			-- damage_type		= self:GetAbilityDamageType(),
			-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			-- attacker 		= self:GetCaster(),
			-- ability 		= self
		-- }
		
		-- ApplyDamage(damageTable)
		
		-- -- Voice response for "Killing enemy, 6000 minimum travel distance"
		-- if not enemy:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and travel_distance >= 6000 then
			-- local random_response = RandomInt(8, 12)

			-- if random_response <= 9 then
				-- self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_0"..random_response)
			-- else
				-- self:GetCaster():EmitSound("rattletrap_ratt_ability_flare_"..random_response)
			-- end
		-- end
	-- end
	
	-- AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("duration"), false)
	
	-- -- Truesight talent (Carpet Fire doesn't get this for "balance" reasons)
	-- if self:GetCaster():HasTalent("special_bonus_imba_rattletrap_rocket_flare_truesight") and not ExtraData.carpet_fire then
		-- local sight_area = CreateModifierThinker(self:GetCaster(), self, "modifier_item_gem_of_true_sight", {
			-- duration		= self:GetSpecialValueFor("duration")
		-- },
		-- vLocation, self:GetCaster():GetTeamNumber(), false)
	-- end
-- end

-- ------------------------------------
-- -- ROCKET FLARE CRITICAL MODIFIER --
-- ------------------------------------

-- function modifier_imba_rattletrap_rocket_flare_critical:IsPurgable()	return false end

-- function modifier_imba_rattletrap_rocket_flare_critical:OnCreated()
	-- self.system_mana_loss_pct	= self:GetAbility():GetSpecialValueFor("system_mana_loss_pct")
-- end

-- function modifier_imba_rattletrap_rocket_flare_critical:DeclareFunctions()
    -- local decFuncs = {
		-- MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
    -- }
	
    -- return decFuncs
-- end

-- function modifier_imba_rattletrap_rocket_flare_critical:GetModifierTotalPercentageManaRegen()	
    -- return (self.system_mana_loss_pct - 100) / 100
-- end

-- --------------
-- -- HOOKSHOT --
-- --------------

-- function imba_rattletrap_hookshot:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
-- end

-- function imba_rattletrap_hookshot:GetCooldown(iLevel)
	-- if self:GetCaster():HasScepter() then 
		-- self:GetSpecialValueFor("cooldown_scepter")
	-- else
		-- return self.BaseClass.GetCooldown(self, iLevel)
	-- end
-- end

-- function imba_rattletrap_hookshot:OnAbilityPhaseStart()
	-- if not IsServer() then return end
	
	-- self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_START)
	
	-- return true
-- end

-- function imba_rattletrap_hookshot:OnSpellStart()
	-- if not IsServer() then return end

	-- self:GetCaster():EmitSound("Hero_Rattletrap.Hookshot.Fire")
	
	-- -- Direction the hook is facing
	-- self.direction = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()
	-- -- In case the z-axis shoots off to some weird alternate dimension
	-- self.direction.z = 0
	
	-- -- Accounts for total of travel time to and from the full distance
	-- local hookshot_duration	= ((self:GetSpecialValueFor("tooltip_range") + GetCastRangeIncrease(self:GetCaster())) / self:GetSpecialValueFor("speed")) * 2
	
	-- local hookshot_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- -- CP0 is the hook's starting point
	-- ParticleManager:SetParticleControlEnt(hookshot_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetCaster():GetAbsOrigin(), true)
	-- -- CP1 is the farthest point the hook will travel
	-- ParticleManager:SetParticleControl(hookshot_particle, 1, self:GetCaster():GetAbsOrigin() + self.direction * (self:GetSpecialValueFor("tooltip_range") + GetCastRangeIncrease(self:GetCaster())))
	-- -- CP2 is the speed at which the hook travels
	-- ParticleManager:SetParticleControl(hookshot_particle, 2, Vector(self:GetSpecialValueFor("speed"), 0, 0))
	-- -- CP3 is the duration at which the hook will last for
	-- ParticleManager:SetParticleControl(hookshot_particle, 3, Vector(hookshot_duration, 0, 0))
	
	-- local linear_projectile = {
		-- Ability				= self,
		-- -- EffectName			= "particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", -- Doesn't do anything
		-- vSpawnOrigin		= self:GetCaster():GetAbsOrigin(),
		-- fDistance			= self:GetSpecialValueFor("tooltip_range") + GetCastRangeIncrease(self:GetCaster()),
		-- fStartRadius		= self:GetSpecialValueFor("latch_radius"),
		-- fEndRadius			= self:GetSpecialValueFor("latch_radius"),
		-- Source				= self:GetCaster(),
		-- bHasFrontalCone		= false,
		-- bReplaceExisting	= false,
		-- iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_BOTH,
		-- iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		-- iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- fExpireTime 		= GameRules:GetGameTime() + 10.0,
		-- bDeleteOnHit		= true,
		-- vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed"),
		-- bProvidesVision		= false,
		
		-- ExtraData			= {hookshot_particle = hookshot_particle}
	-- }
	
	-- -- IMBAfication: Shish Kabob
	-- if self:GetAutoCastState() then
		-- linear_projectile.ExtraData.autocast = true
		-- self.shish_kabob = {}
	-- end
	
	-- -- Clear out Razor Wind IMBAfication table to begin adding new victims if applicable
	-- self.razor_wind = {}
	
	-- self.projectile = ProjectileManager:CreateLinearProjectile(linear_projectile)	
	
	-- -- This temporarily deletes the hook model from Clockwerk
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ) then
		-- self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ):AddEffects(EF_NODRAW)
	-- end
	
	-- -- This block is just for the hook model returning back if a hook is missed
	-- local caster = self:GetCaster()
	
	-- Timers:CreateTimer(hookshot_duration, function()
		-- -- Return the hook model to Clockwerk
		-- if caster:GetName() == "npc_dota_hero_rattletrap" and caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ) then
			-- caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ):RemoveEffects(EF_NODRAW)
		-- end
	-- end)
-- end

-- -- IMBAfication: Razor Wind
-- function imba_rattletrap_hookshot:OnProjectileThink_ExtraData(vLocation, ExtraData)
	-- if not IsServer() then return end
	
	-- local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("razor_wind_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	-- for _, enemy in pairs(enemies) do
		-- local distance_vector = enemy:GetAbsOrigin() - vLocation
		
		-- -- If the hook isn't going to latch onto the enemy to begin with, and the angle that the hook passes the enemy at is between 60 and 120 degrees relative to its own direction (the double math.abs is to just save on having to an an additional conditional), then they get affected by Razor Wind
		-- -- 60 to 120 degrees is just a safety deviation from the standard perpendicular angle (90 degrees) expected to pass by
		-- if distance_vector:Length2D() > self:GetSpecialValueFor("latch_radius") and math.abs(math.abs(AngleDiff(VectorToAngles(distance_vector).y, VectorToAngles(self.direction).y)) - 90) <= 30 and not self.razor_wind[enemy:GetEntityIndex()] then
			
			-- enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = 0.1}):SetDuration(0.1 * (1 - enemy:GetStatusResistance()), true)
			
			-- local damageTable = {
				-- victim 			= enemy,
				-- damage 			= self:GetSpecialValueFor("damage") * self:GetSpecialValueFor("razor_wind_damage") * 0.01,
				-- damage_type		= DAMAGE_TYPE_MAGICAL,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetCaster(),
				-- ability 		= self
			-- }
		
			-- ApplyDamage(damageTable)
			
			-- -- Add enemy to Razor Wind table so they don't get affected again by the same hook
			-- self.razor_wind[enemy:GetEntityIndex()] = true
		-- end
	-- end
-- end

-- function imba_rattletrap_hookshot:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	-- if not IsServer() then return end
	
	-- if hTarget then
		-- if hTarget ~= self:GetCaster() and not hTarget:IsCourier() then
			-- if not ExtraData.autocast then
				-- self:GetCaster():StopSound("Hero_Rattletrap.Hookshot.Fire")
				-- hTarget:EmitSound("Hero_Rattletrap.Hookshot.Impact")
				
				-- -- Retract sound lingers if target is too close to caster at start so only make it play if they were farther to begin with
				-- if (self:GetCaster():GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D() > self:GetSpecialValueFor("latch_radius") then
					-- self:GetCaster():EmitSound("Hero_Rattletrap.Hookshot.Retract")
				-- end

				-- ParticleManager:SetParticleControlEnt(ExtraData.hookshot_particle, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
				-- -- "The pulling lasts a maximum of 0.5 seconds, so if the target moves away, Clockwerk may not fully reach it."
				-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_hookshot", 
				-- {
					-- duration 		= 0.5,
					-- latch_radius	= self:GetSpecialValueFor("latch_radius"),
					-- stun_radius		= self:GetSpecialValueFor("stun_radius"),
					-- stun_duration	= self:GetSpecialValueFor("duration"),
					-- speed			= self:GetSpecialValueFor("speed"),
					-- damage			= self:GetSpecialValueFor("damage"),
					-- ent_index		= hTarget:GetEntityIndex(),
					-- particle		= ExtraData.hookshot_particle
				-- })
				
				-- -- This line is so Clockwerk doesn't pierce through everyone if there are multiple targets (although that would be pretty cool)
				-- -- It may interfere with previous projectiles if you're shooting multiple at once (aka WTF mode) but come on now, vanilla arguably handles this even worse with lingering particles so no bulli
				-- ProjectileManager:DestroyLinearProjectile(self.projectile)
			-- else
				-- hTarget:EmitSound("Hero_Rattletrap.Hookshot.Impact")
			
				-- table.insert(self.shish_kabob, hTarget:GetEntityIndex())

				-- ParticleManager:SetParticleControlEnt(ExtraData.hookshot_particle, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			-- end
			
			-- if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				-- hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")}):SetDuration(self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance()), true)
			-- end
		-- end
	-- else
		-- if ExtraData.autocast and #self.shish_kabob > 0 then
			-- -- Retract sound lingers if target is too close to caster at start so only make it play if they were farther to begin with
			-- if (self:GetCaster():GetAbsOrigin() - EntIndexToHScript(self.shish_kabob[#self.shish_kabob]):GetAbsOrigin()):Length2D() > self:GetSpecialValueFor("latch_radius") then
				-- self:GetCaster():EmitSound("Hero_Rattletrap.Hookshot.Retract")
			-- end
		
			-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_rattletrap_hookshot", 
			-- {
				-- duration 		= 0.5,
				-- latch_radius	= self:GetSpecialValueFor("latch_radius"),
				-- stun_radius		= self:GetSpecialValueFor("stun_radius"),
				-- stun_duration	= self:GetSpecialValueFor("duration"),
				-- speed			= self:GetSpecialValueFor("speed"),
				-- damage			= self:GetSpecialValueFor("damage"),
				-- ent_index		= self.shish_kabob[#self.shish_kabob],
				-- particle		= ExtraData.hookshot_particle,
				-- shish_kabob		= true
			-- })
		-- end
		
		-- ParticleManager:SetParticleControl(ExtraData.hookshot_particle, 1, self:GetCaster():GetAbsOrigin())
	-- end
-- end

-- -----------------------
-- -- HOOKSHOT MODIFIER --
-- -----------------------

-- function modifier_imba_rattletrap_hookshot:IgnoreTenacity()	return true end
-- function modifier_imba_rattletrap_hookshot:IsPurgable()		return false end

-- function modifier_imba_rattletrap_hookshot:OnCreated(params)
	-- if not IsServer() then return end
	
	-- self.duration		= params.duration
	-- self.latch_radius	= params.latch_radius
	-- self.stun_radius	= params.stun_radius
	-- self.stun_duration	= params.stun_duration
	-- self.speed			= params.speed
	-- self.damage			= params.damage
	-- self.particle		= params.particle
	-- self.shish_kabob	= params.shish_kabob

	-- self.target			= EntIndexToHScript(params.ent_index)

	-- -- This will be called in the horizontal motion updater, as it is based on target's location rather than hook's landing spot
	-- self.distance			= (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	
	-- -- Initialize table of enemies hit
	-- self.enemies_hit	= {}
	
	-- -- If horizontal motion cannot be applied, remove the modifier
	-- if self:ApplyHorizontalMotionController() == false or (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self.latch_radius then 
		-- self:Destroy()
		-- return
	-- elseif self:GetCaster():GetName() == "npc_dota_hero_rattletrap" then
		-- local responses	= {
			-- "rattletrap_ratt_ability_batt_06",
			-- "rattletrap_ratt_ability_batt_07",
			-- "rattletrap_ratt_ability_batt_11",
			-- "rattletrap_ratt_ability_hook_01",
			-- "rattletrap_ratt_ability_hook_02",
			-- "rattletrap_ratt_ability_hook_06",	
		-- }
	
		-- self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])	
	-- end
-- end

-- function modifier_imba_rattletrap_hookshot:UpdateHorizontalMotion( me, dt )
	-- if not IsServer() then return end

	-- self.distance	= (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	
	-- me:SetOrigin( me:GetOrigin() + self.distance * self.speed * dt )
	
	-- local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.stun_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- -- Secondary stun (whoever is passed by Clockwerk in close proximity)
	-- for _, unit in pairs(units) do
		-- if not unit:IsCourier() then
			-- -- Apply pass-by stun modifier to enemies
			-- if unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and not self.enemies_hit[unit:GetEntityIndex()] then
				-- unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration}):SetDuration(self.stun_duration * (1 - unit:GetStatusResistance()), true)
				
				-- -- "Does not attempt to damage any spell immune enemy."
				-- if not unit:IsMagicImmune() then
					-- local damageTable = {
						-- victim 			= unit,
						-- damage 			= self.damage,
						-- damage_type		= DAMAGE_TYPE_MAGICAL,
						-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						-- attacker 		= self:GetCaster(),
						-- ability 		= self:GetAbility()
					-- }
				
					-- ApplyDamage(damageTable)
				-- end
				
				-- self.enemies_hit[unit:GetEntityIndex()] = true
			-- end
			
			-- -- Shish Kabob drags units (friend and foe) along with Clockwerk until he reaches the last target
			-- -- Can be blocked by Disabling Help cause this can easily be a griefing ability
			-- if self.shish_kabob and unit ~= self.target and not PlayerResource:IsDisableHelpSetForPlayerID(unit:GetPlayerOwnerID(), self:GetCaster():GetPlayerOwnerID()) then
				-- unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_rattletrap_hookshot", 
				-- {
					-- duration 		= self:GetRemainingTime(),
					-- latch_radius	= self.latch_radius,
					-- stun_radius		= 0,
					-- stun_duration	= 0,
					-- speed			= self.speed,
					-- damage			= 0,
					-- ent_index		= self.target:GetEntityIndex()
				-- })
			-- end
		-- end
	-- end
	
	-- -- IDK what conditionals they use for collision detection so w/e let's use a random one
	-- if (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self.latch_radius then
		-- FindClearSpaceForUnit(self:GetParent(), self.target:GetAbsOrigin() - self.distance * (self:GetParent():GetHullRadius() + self.target:GetHullRadius()), true)
		-- self:Destroy()
	-- end
-- end

-- -- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
-- function modifier_imba_rattletrap_hookshot:OnHorizontalMotionInterrupted()
	-- self:Destroy()
-- end

-- function modifier_imba_rattletrap_hookshot:OnDestroy()
	-- if not IsServer() then return end
	
	-- self:GetParent():RemoveHorizontalMotionController( self )

	-- self:GetCaster():StopSound("Hero_Rattletrap.Hookshot.Retract")
	-- self:GetCaster():EmitSound("Hero_Rattletrap.Hookshot.Damage")
	
	-- -- The things I go through to replicate voice responses zzz
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and (self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() <= self.latch_radius and RollPercentage(15) then
		-- if self.target:GetName() == "npc_dota_hero_pudge" then
			-- local responses	= {
				-- "rattletrap_ratt_ability_hook_08",
				-- "rattletrap_ratt_ability_hook_11",
				-- "rattletrap_ratt_ability_hook_12"
			-- }
		
			-- self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
		-- elseif self.target:GetName() == "npc_dota_hero_tinker" then
			-- self:GetCaster():EmitSound("rattletrap_ratt_ability_hook_13")	
		-- else
			-- self:GetCaster():EmitSound("rattletrap_ratt_ability_hook_0"..RandomInt(4, 5))
		-- end
	-- end	
	
	-- if self.particle then
		-- ParticleManager:DestroyParticle(self.particle, false)
		-- ParticleManager:ReleaseParticleIndex(self.particle)
	-- end

	-- self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_END)

	-- -- Return the hook model to Clockwerk
	-- if self:GetCaster():GetName() == "npc_dota_hero_rattletrap" and self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ) then
		-- self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON ):RemoveEffects(EF_NODRAW)
	-- end
-- end

-- function modifier_imba_rattletrap_hookshot:CheckState()
	-- local state = {}
	
	-- if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or self:GetParent() == self:GetCaster() then
		-- state = {
			-- [MODIFIER_STATE_SILENCED] = true,
			-- [MODIFIER_STATE_DISARMED] = true,
		-- }
	-- end

	-- return state
-- end

-- function modifier_imba_rattletrap_hookshot:DeclareFunctions()
	-- local funcs = {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	-- }

	-- return funcs
-- end

-- function modifier_imba_rattletrap_hookshot:GetOverrideAnimation()
	 -- return ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP
-- end
