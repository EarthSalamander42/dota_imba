-- Creator:
--	   Naowin, 04.07.2018

-- Editors:
--	   EarthSalamander #42, ??.07.2018
--     AltiV, ??.08.2018

--------------------------------------
--			Arc Lightning			--
--------------------------------------
imba_zuus_arc_lightning = class({})
function imba_zuus_arc_lightning:OnSpellStart()
	local caster 			= self:GetCaster()
	local ability 			= self
	local jump_delay 		= ability:GetSpecialValueFor("jump_delay")
	local max_jump_count 	= ability:GetSpecialValueFor("jump_count")
	local radius 			= ability:GetSpecialValueFor("radius")
	local damage 			= ability:GetSpecialValueFor("arc_damage")
	local static_chain_mult	= ability:GetSpecialValueFor("static_chain_mult")
	local target 			= self:GetCursorTarget()

	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")

	local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y , caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
	ParticleManager:SetParticleControl(lightningBolt, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))

	local nearby_enemy_units = FindUnitsInRadius(
		caster:GetTeam(),
		target:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		--DOTA_UNIT_TARGET_FLAG_NONE, 
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
		FIND_CLOSEST, 
		false
	)

	local damage_table 			= {}
	damage_table.attacker 		= caster
	damage_table.ability 		= ability
	damage_table.damage_type 	= ability:GetAbilityDamageType() 
	damage_table.damage			= damage
	damage_table.victim 		= target
	ApplyDamage(damage_table)

	-- Add to list of targets allrdy hit.
	local hit_list = {}
	hit_list[target] = 1

	Timers:CreateTimer(jump_delay, function() 
		-- Find targets to chain too
		for _,enemy in pairs(nearby_enemy_units) do 
			if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() and target ~= enemy then
				imba_zuus_arc_lightning:Chain(caster, target, enemy, ability, damage, radius, jump_delay, max_jump_count, 0, hit_list, static_chain_mult)
				-- Abort when we find something to chain too
				break
			end
		end
	end)
end

function imba_zuus_arc_lightning:Chain(caster, origin_target, chained_target, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list, static_chain_mult)
	if IsServer() then 
		num_jumps_done 			 = num_jumps_done + 1
		if hit_list[chained_target] == nil then
			hit_list[chained_target] = 1	
		else
			hit_list[chained_target] = hit_list[chained_target] + 1
		end

		-- print("num_jumps_done", num_jumps_done, chained_target, hit_list[chained_target])

		origin_target:EmitSound("Hero_Zuus.ArcLightning.Target")

		local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, origin_target)
		ParticleManager:SetParticleControl(lightningBolt, 0, Vector(origin_target:GetAbsOrigin().x, origin_target:GetAbsOrigin().y , origin_target:GetAbsOrigin().z + origin_target:GetBoundingMaxs().z ))   
		ParticleManager:SetParticleControl(lightningBolt, 1, Vector(chained_target:GetAbsOrigin().x, chained_target:GetAbsOrigin().y, chained_target:GetAbsOrigin().z + chained_target:GetBoundingMaxs().z ))

		local nearby_enemy_units = FindUnitsInRadius(	
			caster:GetTeam(), 
			chained_target:GetAbsOrigin(), 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			--DOTA_UNIT_TARGET_FLAG_NONE, 
			DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			FIND_CLOSEST, 
			false
		)

		local damage_table 			= {}
		damage_table.attacker 		= caster
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage			= damage
		damage_table.victim 		= chained_target
		ApplyDamage(damage_table)

		if num_jumps_done < max_jump_count then
			Timers:CreateTimer(jump_delay, function() 
				local has_chained = false
				-- Find targets to chain to
				for _,enemy in pairs(nearby_enemy_units) do 
					if origin_target ~= enemy and chained_target ~= enemy then
						if imba_zuus_arc_lightning:HitCheck(caster, enemy, hit_list) then 
							imba_zuus_arc_lightning:Chain(caster, chained_target, enemy, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list, static_chain_mult)
							has_chained = true
						end

						-- Abort when we find something to chain too
						break
					end
				end

				-- If there are no targets left to chain to... but we have not hit max_jump cap...
				if (#nearby_enemy_units == 0 or has_chained == false) then 
					-- Get list of all heroes!
					local heroes = HeroList:GetAllHeroes() 
					local dist_ref = {
						hero = nil,
						-- Let's try and make this a bit more reasonable
						distance = radius * static_chain_mult
					}

					-- Check if any of them heroes have a static charge... (and havent been hit yet)
					for _,hero in pairs(heroes) do 
						if hero:HasModifier("modifier_imba_zuus_static_charge") and origin_target ~= hero and chained_target ~= hero then
							if imba_zuus_arc_lightning:HitCheck(caster, hero, hit_list) then 
							-- Get the closest one!
								local distance = (caster:GetAbsOrigin() - hero:GetAbsOrigin()):Length2D()
								if distance < dist_ref.distance then 
									dist_ref.hero = hero
									dist_ref.distance = distance
								end
							end
						end
					end

					-- Did we find an enemy?
					if dist_ref.hero ~= nil then
						imba_zuus_arc_lightning:Chain(caster, chained_target, dist_ref.hero, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list, static_chain_mult)
					end
				end
			end)
		end
	end
end

function imba_zuus_arc_lightning:HitCheck(caster, enemy, hit_list)
	if IsServer() then
		if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() then 
			if hit_list[enemy] == nil then
				return true
			end

			if caster:HasTalent("special_bonus_imba_zuus_8") then 
				print(caster:FindTalentValue("special_bonus_imba_zuus_8", "additional_hits"))
				if hit_list[enemy] < caster:FindTalentValue("special_bonus_imba_zuus_8", "additional_hits") then
					return true
				end
			end
		end

		return false
	end
end

function imba_zuus_arc_lightning:GetCastRange()
	local bonus_cast_range = 0
	if self:GetCaster():HasTalent("special_bonus_imba_zuus_2") then 
		bonus_cast_range = self:GetCaster():FindTalentValue("special_bonus_imba_zuus_2", "bonus_cast_range")
	end

	return self:GetSpecialValueFor("cast_range") + bonus_cast_range
end



--------------------------------------
--			Lightning Bolt			--
--------------------------------------
LinkLuaModifier("modifier_imba_zuus_lightning_true_sight", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_zuus_lightning_dummy", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)

imba_zuus_lightning_bolt = class({})

function imba_zuus_lightning_bolt:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")

	return true
end

function imba_zuus_lightning_bolt:CastFilterResultTarget( target )
	if IsServer() then
		if target ~= nil
		and target:IsMagicImmune()
		-- If the caster has the Thundergod Talent and meets all the criteria for piercing spell immunity, then break out of failure check
		and not (self:GetCaster():HasTalent("special_bonus_imba_zuus_7")
		and (self:GetCaster():HasModifier("modifier_imba_zuus_thundergods_focus")
		and self:GetCaster():GetModifierStackCount("modifier_imba_zuus_thundergods_focus", self:GetCaster()) >= self:GetCaster():FindTalentValue("special_bonus_imba_zuus_7", "value")))
		then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end
		
		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_zuus_lightning_bolt:OnSpellStart()
	if IsServer() then
		local caster 		= self:GetCaster()
		local target 		= self:GetCursorTarget()
		local target_point 	= self:GetCursorPosition()

		if caster:HasAbility("imba_zuus_static_field") then
			local reduced_magic_resistance = caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("reduced_magic_resistance")
			if self:GetCaster():HasTalent("special_bonus_imba_zuus_3") then 
				reduced_magic_resistance = reduced_magic_resistance + caster:FindTalentValue("special_bonus_imba_zuus_3", "reduced_magic_resistance")
			end
		end

		local movement_speed 	= 10
		local turn_rate 	 	= 1
		if self:GetCaster():HasTalent("special_bonus_imba_zuus_4") then 
			movement_speed 	= movement_speed + caster:FindTalentValue("special_bonus_imba_zuus_4", "movement_speed")
			turn_rate 	   	= caster:FindTalentValue("special_bonus_imba_zuus_4", "turn_rate")
		end

		CustomNetTables:SetTableValue(
		"player_table", 
		tostring(self:GetCaster():GetPlayerOwnerID()), 
		{ 	
			reduced_magic_resistance 	= reduced_magic_resistance,
			movement_speed 				= movement_speed,
			turn_rate 					= turn_rate
		})

		imba_zuus_lightning_bolt:CastLightningBolt(caster, self, target, target_point)
	end
end

function imba_zuus_lightning_bolt:CastLightningBolt(caster, ability, target, target_point)
	if IsServer() then
		local spread_aoe 			= ability:GetSpecialValueFor("spread_aoe")
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day  	= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night  	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local stun_duration 		= ability:GetSpecialValueFor("stun_duration")
		local pierce_spellimmunity 	= false
		local z_pos 				= 2000

		caster:EmitSound("Hero_Zuus.LightningBolt")

		if caster:HasTalent("special_bonus_imba_zuus_1") then 
			spread_aoe = spread_aoe + caster:FindTalentValue("special_bonus_imba_zuus_1", "spread_aoe")
		end

		if caster:HasTalent("special_bonus_imba_zuus_7") then
			--if caster:HasModifier("modifier_imba_zuus_pierce_spellimmunity") then
			if caster:HasModifier("modifier_imba_zuus_thundergods_focus") and caster:FindModifierByName("modifier_imba_zuus_thundergods_focus"):GetStackCount() >= caster:FindTalentValue("special_bonus_imba_zuus_7", "value") then
				pierce_spellimmunity = true
			end
		end

		-- Add fog vision 
		AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)

		-- Unsure what happens when target is nil. Have to be tested propperly... might have to use dummy target
		if target ~= nil then
			-- target = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, target_point.z), false, nil, nil, DOTA_TEAM_NEUTRALS)
			target_point = target:GetAbsOrigin()

			-- If cast on self. no lightning will be cast but the cloud will spawn at this coordinate.
			if target == caster then
				z_pos = 950
			end
		end

		-- Spell was used on the ground search for invisible hero to target
		if target == nil then
			local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
			if pierce_spellimmunity == true then 
				target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
			end

			-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO, 
				target_flags, 
				FIND_CLOSEST, 
				false
			)
			
			local closest = radius
			for i,unit in ipairs(nearby_enemy_units) do
				if not unit:IsMagicImmune() or pierce_spellimmunity then 
					-- First unit is the closest
					target = unit
					break
				end
			end
		end

		-- If we still dont have a target we search for nearby creeps
		if target == nil then
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				target_point, 
				nil, 
				spread_aoe, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				ability:GetAbilityTargetType(),
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)

			for i,unit in ipairs(nearby_enemy_units) do
				-- First unit is the closest
				target = unit
				break
			end
		end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
		if target == nil then 
			-- Renders the particle on the ground target
			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
			ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		elseif target:IsMagicImmune() == false or pierce_spellimmunity then  
			target_point = target:GetAbsOrigin()
			ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, target_point.z))
			ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, z_pos))
			ParticleManager:SetParticleControl(particle, 2, Vector(target_point.x, target_point.y, target_point.z))
		end

		-- Add dummy to provide us with truesight aura
		local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
		local true_sight = dummy_unit:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
		true_sight:SetStackCount(true_sight_radius)
		dummy_unit:SetDayTimeVisionRange(sight_radius_day)
		dummy_unit:SetNightTimeVisionRange(sight_radius_night)

		dummy_unit:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_dummy", {})
		dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = sight_duration + 1})

		if target == caster then 
			-- Apply Thundergods Focus and update stacks
			local thundergods_focus_modifier = caster:AddNewModifier(caster, self, "modifier_imba_zuus_thundergods_focus", {duration = ability:GetSpecialValueFor("thundergods_focus_duration")})
			thundergods_focus_modifier:SetStackCount(thundergods_focus_modifier:GetStackCount() + 1)	
		elseif target ~= nil and target:GetTeam() ~= caster:GetTeam() then
			
			if caster:HasAbility("imba_zuus_static_field") and caster:FindAbilityByName("imba_zuus_static_field"):IsTrained() then
				local static_charge_modifier = target:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = 5.0})
				
				if static_charge_modifier ~= nil then 
					static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + ability:GetSpecialValueFor("static_charge_stacks"))
				end
			end
				
			target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})

			if caster:HasTalent("special_bonus_imba_zuus_5") then 
				local root_duration = 0.5
				local thundergod_focus_modifier = caster:FindModifierByName("modifier_imba_zuus_thundergods_focus")
				if thundergod_focus_modifier ~= nil then 
					root_duration = 0.5 + (thundergod_focus_modifier:GetStackCount() * 0.25)
				end

				print("Root duration:", root_duration)
				target:AddNewModifier(caster, ability, "modifier_rooted", {duration = root_duration})
			end

			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 
			damage_table.damage			= ability:GetAbilityDamage()
			damage_table.victim 		= target

			-- Cannot deal magic dmg to immune... change to pure
			if pierce_spellimmunity and target:IsMagicImmune() then
				damage_table.damage_type = DAMAGE_TYPE_PURE
			end

			ApplyDamage(damage_table)
		end
	end
end



------------------------------------------------------
--  			Lightning bolt dummy 				--
------------------------------------------------------
modifier_imba_zuus_lightning_dummy = class({})
function modifier_imba_zuus_lightning_dummy:IsHidden() return true end
function modifier_imba_zuus_lightning_dummy:IsPurgable() return false end
function modifier_imba_zuus_lightning_dummy:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
		[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
		[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
		[MODIFIER_STATE_INVULNERABLE] 		= true,
		[MODIFIER_STATE_UNSELECTABLE] 		= true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
		[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
		[MODIFIER_STATE_FLYING] = true,
	}

	return state
end



------------------------------------------------------------------
--  			Lightning bolt true_sight modifier 				--
------------------------------------------------------------------
modifier_imba_zuus_lightning_true_sight = class({})
function modifier_imba_zuus_lightning_true_sight:IsAura()
    return true
end

function modifier_imba_zuus_lightning_true_sight:IsHidden()
    return true
end

function modifier_imba_zuus_lightning_true_sight:IsPurgable()
    return false
end

function modifier_imba_zuus_lightning_true_sight:GetAuraRadius()
	if self:GetParent():GetName() == "npc_dota_creep_neutral" then
		return self:GetStackCount()
	else
		return 1
	end
end

function modifier_imba_zuus_lightning_true_sight:GetModifierAura()
    return "modifier_truesight"
end
   
function modifier_imba_zuus_lightning_true_sight:GetAuraSearchTeam()
	if self:GetParent():GetName() == "npc_dota_creep_neutral" then
		return DOTA_UNIT_TARGET_TEAM_ENEMY
	else
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_imba_zuus_lightning_true_sight:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_zuus_lightning_true_sight:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_zuus_lightning_true_sight:GetAuraDuration()
    return 0.5
end




----------------------------------------------
--  			FOW modifier  				--
----------------------------------------------
LinkLuaModifier("modifier_imba_zuus_lightning_fow", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_lightning_fow = class({})
function modifier_imba_zuus_lightning_fow:IsHidden() return true end
function modifier_imba_zuus_lightning_fow:OnCreated(keys) 
	if IsServer() then 
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.radius = keys.radius
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_zuus_lightning_fow:OnIntervalThink()
	AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, FrameTime(), false)
end



----------------------------------------------
--  			Static Field  				--
----------------------------------------------
LinkLuaModifier("modifier_imba_zuus_static_field", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
imba_zuus_static_field = class({})

function imba_zuus_static_field:GetIntrinsicModifierName()
	return "modifier_imba_zuus_static_field"
end

------------------------------------------------------
--  			Static Field modifier  				--
------------------------------------------------------
modifier_imba_zuus_static_field = class({})
function modifier_imba_zuus_static_field:RemoveOnDeath() return false end
function modifier_imba_zuus_static_field:IsPurgable() return false end
function modifier_imba_zuus_static_field:IsHidden() return true end
function modifier_imba_zuus_static_field:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return decFuncs
end

function modifier_imba_zuus_static_field:OnAbilityExecuted(keys)
	if IsServer() then
		local caster = self:GetCaster()		
		if keys.unit == caster and not keys.ability:IsItem() then 
			local ability 			 = self:GetAbility()
			local radius 			 = ability:GetSpecialValueFor("radius")
			local damage_health_pct  = ability:GetSpecialValueFor("damage_health_pct")
			local duration			 = ability:GetSpecialValueFor("duration")
			local nearby_enemy_units = FindUnitsInRadius(
				caster:GetTeamNumber(), 
				caster:GetAbsOrigin(), 
				nil, 
				radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			local caster_position = caster:GetAbsOrigin()
			local zuus_static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(zuus_static_field, 0, Vector(caster_position.x, caster_position.y, caster_position.z))		
			ParticleManager:SetParticleControl(zuus_static_field, 1, Vector(caster_position.x, caster_position.y, caster_position.z) * 100)	
			
			local damage_table 			= {}
			damage_table.attacker 		= self:GetCaster()
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 

			for _,unit in pairs(nearby_enemy_units) do
				if unit:IsAlive() and unit ~= caster and not unit:IsRoshan() then
					local current_health = unit:GetHealth()
					damage_table.damage	 = (current_health / 100) * damage_health_pct
					damage_table.victim  = unit
					ApplyDamage(damage_table)

					-- Add a static charge 
					local static_charge_modifier = unit:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = duration})
					if static_charge_modifier ~= nil then
						static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + 1)	
					end
				end
			end
		end
	end
end



------------------------------------------------------
--				Static Charge Modifier  			--
------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_static_charge", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_static_charge = class({})
function modifier_imba_zuus_static_charge:IsDebuff() return true end
function modifier_imba_zuus_static_charge:OnCreated() 
	if IsServer() then
		local caster = self:GetCaster()
		self.reduced_magic_resistance 	= caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("reduced_magic_resistance")
		self.stacks_to_reveal			= caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("stacks_to_reveal")
		self.stacks_to_mute				= caster:FindAbilityByName("imba_zuus_static_field"):GetSpecialValueFor("stacks_to_mute")

		if caster:HasTalent("special_bonus_imba_zuus_3") then 
			self.reduced_magic_resistance = self.reduced_magic_resistance + caster:FindTalentValue("special_bonus_imba_zuus_3", "reduced_magic_resistance")
		end
	else 
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.reduced_magic_resistance 	= net_table.reduced_magic_resistance or 0
		self.stacks_to_reveal			= 5
		self.stacks_to_mute				= 9
	end
end

function modifier_imba_zuus_static_charge:GetTexture()
	return "zuus_static_field"
end

function modifier_imba_zuus_static_charge:DeclareFunctions()
	decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return decFuncs
end

function modifier_imba_zuus_static_charge:CheckState()
	local state = {}
	local stacks = self:GetStackCount()
	if stacks >= self.stacks_to_reveal then
		state[MODIFIER_STATE_INVISIBLE] = false
	end

	if stacks >= self.stacks_to_mute then 
		state[MODIFIER_STATE_MUTED] = true
	end

	return state
end

function modifier_imba_zuus_static_charge:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end


function modifier_imba_zuus_static_charge:GetModifierMagicalResistanceBonus()
	-- Each stack reduces magic resistance
	return self:GetStackCount() * self.reduced_magic_resistance * -1
end



--------------------------------------
--				Nimbus				--
--------------------------------------
LinkLuaModifier("modifier_zuus_nimbus", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_nimbus_storm", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)

imba_zuus_cloud = imba_zuus_cloud or class({})

function imba_zuus_cloud:IsInnateAbility() return true end

function imba_zuus_cloud:GetAssociatedPrimaryAbilities()
	return "imba_zuus_lightning_bolt"
end

function imba_zuus_cloud:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end

function imba_zuus_cloud:OnInventoryContentsChanged()
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self:SetHidden(false)
		else
			self:SetHidden(true)
		end
	end
end

function imba_zuus_cloud:OnSpellStart()
	if IsServer() then
		self.target_point 			= self:GetCursorPosition()
		local caster 				= self:GetCaster()
		
		local cloud_bolt_interval 	= self:GetSpecialValueFor("cloud_bolt_interval")
		local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")
		local cloud_radius 			= self:GetSpecialValueFor("cloud_radius")

		EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.Cloud.Cast", caster)
		caster:RemoveModifierByName("modifier_imba_zuus_on_nimbus")
		
		self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
		self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
		self.zuus_nimbus_unit:SetModelScale(0.7)
		self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
		self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_nimbus_storm", {duration = cloud_duration, cloud_bolt_interval = cloud_bolt_interval, cloud_radius = cloud_radius})
		self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
		
		if caster:HasAbility("imba_zuus_nimbus_zap") then
			caster:FindAbilityByName("imba_zuus_nimbus_zap"):SetActivated(true)
		end
	end
end

modifier_zuus_nimbus_storm = class({})

function modifier_zuus_nimbus_storm:IsHidden() return true end

function modifier_zuus_nimbus_storm:OnCreated(keys)
	if IsServer() then
		self.caster 				= self:GetCaster()
		self.ability 				= self
		self.cloud_radius 			= keys.cloud_radius
		self.cloud_bolt_interval 	= keys.cloud_bolt_interval
		self.lightning_bolt 		= self.caster:FindAbilityByName("imba_zuus_lightning_bolt")
		local target_point 			= GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())
		
		self.original_z = target_point.z
		self:SetStackCount(self.original_z)
		
		-- Initialize counter to equal that of the interval so Nimbus can immediately strike targets upon spawn
		self.counter = self.cloud_bolt_interval

		-- Create nimbus cloud particle
		self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- Position of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 450))
		-- Radius of ground effect
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.cloud_radius, 0, 0))
		-- Position of cloud 
		ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z + 450))	

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_zuus_nimbus_storm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_zuus_nimbus_storm:GetVisualZDelta()
	return 450
end

function modifier_zuus_nimbus_storm:OnIntervalThink()
	if IsServer() then
		if self.lightning_bolt:GetLevel() > 0 and self.counter >= self.cloud_bolt_interval then
			local nearby_enemy_units = FindUnitsInRadius(
				self.caster:GetTeamNumber(), 
				self:GetParent():GetAbsOrigin(), 
				nil, 
				self.cloud_radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				self.lightning_bolt:GetAbilityTargetType(),
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST,
				false
			)

			for _,unit in pairs(nearby_enemy_units) do
				if unit:IsAlive() then
					imba_zuus_lightning_bolt:CastLightningBolt(self.caster, self.lightning_bolt, unit, unit:GetAbsOrigin())
					-- Abort when we find something to hit
					self.counter = 0
					break
				end
			end
		end
		
		self.counter = self.counter + FrameTime()
	end
end

function modifier_zuus_nimbus_storm:OnAttacked(params)
	if params.target == self:GetParent() then
		if params.attacker:IsRealHero() then
			if params.attacker:IsRangedAttacker() then
				-- print("Ranged attack!", self:GetParent():GetHealth() - self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("ranged_hero_attack"))
				self:GetParent():SetHealth(self:GetParent():GetHealth() - self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("ranged_hero_attack"))
			else
				-- print("Melee Attack!", self:GetParent():GetHealth() - (self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("melee_hero_attack")))
				self:GetParent():SetHealth(self:GetParent():GetHealth() - (self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("melee_hero_attack")))
			end
		else
			-- print("Non-hero!", self:GetParent():GetHealth() - (self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("non_hero_attack")))
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self:GetParent():GetMaxHealth() / self:GetAbility():GetSpecialValueFor("non_hero_attack")))
		end
	end
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_zuus_nimbus_storm:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_zuus_nimbus_storm:OnRemoved()
	if IsServer() then
		-- Cleanup particle
		ParticleManager:DestroyParticle(self.zuus_nimbus_particle, false)
		local caster = self:GetCaster()
		local nimbusRemaining = false

		-- Return Zeus to ground if it's the current cloud that ended
		if caster:HasModifier("modifier_imba_zuus_nimbus_z") then
			caster:RemoveModifierByName("modifier_imba_zuus_nimbus_z")
			FindClearSpaceForUnit(caster, self:GetCaster():GetAbsOrigin(), false)
		end
		
		-- Check to see if there are any active nimbuses on the map, and set variable to true if there is
		for _, nimbus in pairs(Entities:FindAllByName("npc_dota_zeus_cloud")) do
			if nimbus:IsAlive() then
				nimbusRemaining = true
				break
			end
		end
		
		-- If there are no active nimbuses on the map anymore...
		if not nimbusRemaining then
			-- ...and the owner has both relevant abilities...
			if caster:HasAbility("imba_zuus_leave_nimbus") and caster:HasAbility("imba_zuus_nimbus_zap") then
				-- ...and the "Descend" skill is visible on the skills menu...
				if not caster:FindAbilityByName("imba_zuus_leave_nimbus"):IsHidden() then
					caster:SwapAbilities("imba_zuus_leave_nimbus", "imba_zuus_nimbus_zap", false, true)
				end
				self:GetCaster():FindAbilityByName("imba_zuus_nimbus_zap"):SetActivated(false)
			end
		end
	end
end

----------------------------------------------
--				Nimbus Teleport				--
----------------------------------------------
LinkLuaModifier("modifier_imba_ball_lightning", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_zuus_nimbus_z", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)

imba_zuus_nimbus_zap = class({})

function imba_zuus_nimbus_zap:IsInnateAbility() return true end
function imba_zuus_nimbus_zap:IsStealable() 	return false end

function imba_zuus_nimbus_zap:OnUpgrade()
	self:SetActivated(false)
end

function imba_zuus_nimbus_zap:OnInventoryContentsChanged()
	if IsServer() then
		-- only activate ability once to avoid all possible abuse by switching item in and out of inventory.
		if self:GetCaster():HasScepter() then
			self:SetHidden(false)
		else
			self:SetHidden(true)
		end
	end
end

function imba_zuus_nimbus_zap:GetManaCost( nLevel )
	return self:GetCaster():GetMana() * self:GetSpecialValueFor("mana_cost_pct") / 100
end

function imba_zuus_nimbus_zap:OnSpellStart() 
	if IsServer() then
		local target_point 	= self:GetCursorPosition()
		
		local caster_loc 	= GetGroundPosition(self:GetCaster():GetAbsOrigin(), self:GetCaster())
		local target_loc	= nil
		local distance 		= math.huge
		
		if target ~= nil then
			target_point = target:GetAbsOrigin()
		end		
			
		local nimbus_ability 	= self:GetCaster():FindAbilityByName("imba_zuus_cloud")
		self.nimbus = nimbus_ability.zuus_nimbus_unit

		for _, nimbus in pairs(Entities:FindAllByName("npc_dota_zeus_cloud")) do
			if nimbus:IsAlive() and (target_point - nimbus:GetAbsOrigin()):Length2D() < distance then
				distance 	= (target_point - nimbus:GetAbsOrigin()):Length2D()
				target_loc 	= nimbus:GetAbsOrigin()				
			end
		end
		
		-- If the spell was somehow able to be cast with no nimbus active, deactivate it and do nothing else
		if target_loc == nil then
			self:SetActivated(false)
			return
		end
		
		target_loc.z 		= target_loc.z + 100
		local max_height 	= target_loc.z + 100
		
		-- Ability parameters
		local speed 			=	self:GetSpecialValueFor("ball_speed")
		local damage_radius 	= 	self:GetSpecialValueFor("damage_radius")
		local vision 			= 	self:GetSpecialValueFor("ball_vision_radius")

		-- Motion control properties
		self.traveled 	= 0
		self.distance 	= (target_loc - caster_loc):Length2D()
		-- Cast fails if Zeus tries to port to a nimbus directly on top of him (breaks the skill)
		if self.distance == 0 then
			return
		end
		self.direction 	= (target_loc - caster_loc):Normalized()

		-- Calculate height to add per instance traveled
		local add_height = ((target_loc.z) - caster_loc.z) / (self.distance/speed/FrameTime())
		local add_stacks = 450 / (math.abs(target_loc.z - caster_loc.z) / math.abs(add_height))
		-- Save original target location
		self.target_loc = target_loc
		
		-- Play the cast sounds
		self:GetCaster():EmitSound("Hero_Zuus.LightningBolt")
		self:GetCaster():EmitSound("Hero_StormSpirit.BallLightning")
		self:GetCaster():EmitSound("Hero_StormSpirit.BallLightning.Loop")
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_ball_lightning", {})
		self.nimbus_z = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_zuus_nimbus_z", {})

		-- print("nimbus location", target_loc, caster_loc, max_height, add_height)
		-- Fire the ball of death!
		local projectile =
		{
			Ability				= self,
			EffectName			= "particles/hero/storm_spirit/no_particle_particle.vpcf",
			vSpawnOrigin		= caster_loc,
			fDistance			= self.distance,
			fStartRadius		= damage_radius,
			fEndRadius			= damage_radius,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= self:GetAbilityTargetTeam(),
			iUnitTargetFlags	= self:GetAbilityTargetFlags(),
			iUnitTargetType		= self:GetAbilityTargetType(),
			bDeleteOnHit		= false,
			vVelocity 			= self.direction * speed * Vector(1, 1, 0),
			bProvidesVision		= true,
			iVisionRadius 		= vision,
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
			ExtraData			= {
				speed = speed * FrameTime(),
				add_stacks = add_stacks,
				add_height = add_height,
				max_height = max_height,
				target_loc = target_loc
			}
		}

		self.projectileID = ProjectileManager:CreateLinearProjectile(projectile)

		-- Add Motion-Controller Modifier
		--self.zap_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_ball_lightning", {})
		-- StartAnimation(self:GetCaster(), {duration=10.0, activity=ACT_DOTA_OVERRIDE_ABILITY_4, rate=1.0})		
	end
end

function imba_zuus_nimbus_zap:OnProjectileThink_ExtraData(location, ExtraData)
	-- Move the caster as long as he has not reached the distance he wants to go to, and he still has enough mana
	-- When cloud is killed before we get to it...
	if self.nimbus_z:IsNull() then 
		self:GetCaster():RemoveModifierByName("modifier_imba_ball_lightning")
		ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), 128)
		return
	end

	if (self.traveled + ExtraData.speed < self.distance) and self:GetCaster():IsAlive() then
		local tmp = self:GetCaster():GetAbsOrigin()
		--print("z loc ", tmp.z)
		-- Set Zuus new position
		if tmp.z > ExtraData.max_height then 
			self:GetCaster():SetAbsOrigin(Vector(location.x, location.y, ExtraData.max_height))
		else
			self:GetCaster():SetAbsOrigin(Vector(location.x, location.y, tmp.z + ExtraData.add_height))
		end
		
		-- Set Zuus z offset from ground
		self.nimbus_z:SetStackCount(self.nimbus_z:GetStackCount() + ExtraData.add_stacks)
		
		-- Calculate the new travel distance
		self.traveled = self.traveled + ExtraData.speed
		self.units_traveled_in_last_tick = ExtraData.speed
	else
		-- Make sure we end up at the correct location.
		self:GetCaster():SetAbsOrigin(self.target_loc)
		self.nimbus_z:SetStackCount(450)

		if self:GetCaster():HasAbility("imba_zuus_leave_nimbus") and self:GetCaster():HasAbility("imba_zuus_nimbus_zap") and self.nimbus ~= nil and self:GetCaster():FindAbilityByName("imba_zuus_leave_nimbus"):IsHidden() then
			self:GetCaster():SwapAbilities("imba_zuus_nimbus_zap", "imba_zuus_leave_nimbus", false, true)	
		end
		
		-- Get rid of stuff
		self:GetCaster():StopSound("Hero_StormSpirit.BallLightning.Loop")
		self:GetCaster():RemoveModifierByName("modifier_imba_ball_lightning")
		ProjectileManager:DestroyLinearProjectile(self.projectileID)
	end
end

imba_zuus_leave_nimbus = class({})

function imba_zuus_leave_nimbus:IsInnateAbility() 	return true end
function imba_zuus_leave_nimbus:IsStealable() 		return false end

function imba_zuus_leave_nimbus:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_imba_zuus_on_nimbus")
		caster:RemoveModifierByName("modifier_imba_zuus_nimbus_z")
		ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), 128)
		
		self:GetCaster():SwapAbilities("imba_zuus_leave_nimbus", "imba_zuus_nimbus_zap", false, true)
	end
end

----------------------------------------------------------
--				Nimbus teleport modifier  				--
----------------------------------------------------------
modifier_imba_ball_lightning = modifier_imba_ball_lightning or class({})
function modifier_imba_ball_lightning:IsDebuff() 	return false end
function modifier_imba_ball_lightning:IsHidden() 	return false end
function modifier_imba_ball_lightning:IsPurgable() return false end

function modifier_imba_ball_lightning:GetEffectName()
	return "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
end

function modifier_imba_ball_lightning:GetEffectAttachType()
	-- Yep, this is a thing.
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_imba_ball_lightning:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
	return funcs
end

function modifier_imba_ball_lightning:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_imba_ball_lightning:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_imba_ball_lightning:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_imba_ball_lightning:OnRemoved()
	if IsServer() then
		self:GetCaster():AddNewModifier(nil, nil, "modifier_imba_zuus_on_nimbus", {})
	end
end


modifier_imba_zuus_nimbus_z = class({})
function modifier_imba_zuus_nimbus_z:CheckState()
	state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_imba_zuus_nimbus_z:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING }
	return funcs
end

function modifier_imba_zuus_nimbus_z:GetVisualZDelta()
	return self:GetStackCount()
end

function modifier_imba_zuus_nimbus_z:GetModifierCastRangeBonusStacking()
	return self:GetStackCount() / 3
end

LinkLuaModifier("modifier_imba_zuus_on_nimbus", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_on_nimbus = class({})

----------------------------------------------
--				Thundergods Wrath  			--
----------------------------------------------
imba_zuus_thundergods_wrath = class({})

function imba_zuus_thundergods_wrath:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")

	return true
end

function imba_zuus_thundergods_wrath:OnSpellStart() 
	if IsServer() then
		local ability 				= self
		local caster 				= self:GetCaster()
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day 		= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night 	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local pierce_spellimmunity 	= false

		local position 				= self:GetCaster():GetAbsOrigin()	
		local attack_lock 			= caster:GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))
		local thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))		
		ParticleManager:SetParticleControl(thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))		

		if caster:HasTalent("special_bonus_imba_zuus_7") then
			if caster:HasModifier("modifier_imba_zuus_thundergods_focus") and caster:FindModifierByName("modifier_imba_zuus_thundergods_focus"):GetStackCount() >= caster:FindTalentValue("special_bonus_imba_zuus_7", "value") then
				pierce_spellimmunity = true
			end
		end
		
		local thundergods_focus_stacks = 0
		
		if caster:HasModifier("modifier_imba_zuus_thundergods_focus") then
			thundergods_focus_stacks = caster:FindModifierByName("modifier_imba_zuus_thundergods_focus"):GetStackCount()
			-- Consume all Thundergod's Focus stacks to feed into Static Charge
			caster:FindModifierByName("modifier_imba_zuus_thundergods_focus"):Destroy()
		end

		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Zuus.GodsWrath", self:GetCaster())

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		
		for _,hero in pairs(HeroList:GetAllHeroes()) do 
			if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() and (not hero:IsIllusion()) then 
				local target_point = hero:GetAbsOrigin()
				local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
				ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))		
				ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))	
				ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))
				
				if caster:HasAbility("imba_zuus_static_field") and caster:FindAbilityByName("imba_zuus_static_field"):IsTrained() then
					-- Add static charges prior to inflicting the damage
					local static_charge_modifier = hero:AddNewModifier(caster, self, "modifier_imba_zuus_static_charge", {duration = 5.0})
					
					if static_charge_modifier ~= nil then
						static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + 1)
						-- Add Thundergod's Focus stack count to Static Charge count if applicable
						static_charge_modifier:SetStackCount(static_charge_modifier:GetStackCount() + thundergods_focus_stacks)
					end
				end
				
				-- Cannot deal magic dmg to immune... change to pure
				if pierce_spellimmunity and hero:IsMagicImmune() then
					damage_table.damage_type = DAMAGE_TYPE_PURE
				end
				
				if (not hero:IsMagicImmune() or pierce_spellimmunity) and (not hero:IsInvisible() or caster:CanEntityBeSeenByMyTeam(hero)) then
					damage_table.damage	 = self:GetAbilityDamage()
					damage_table.victim  = hero
					ApplyDamage(damage_table)
				end
				
				hero:EmitSound("Hero_Zuus.GodsWrath.Target")
				hero:AddNewModifier(caster, ability, "modifier_imba_zuus_lightning_fow", {duration = sight_duration, radius = true_sight_radius})
				
				local true_sight = hero:AddNewModifier(caster, self, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
				if true_sight ~= nil then
					true_sight:SetStackCount(true_sight_radius)
				end
				
				-- Cut existing static charges in half, rounded down
				if hero:HasModifier("modifier_imba_zuus_static_charge") then
					hero:FindModifierByName("modifier_imba_zuus_static_charge"):SetStackCount(math.floor(hero:FindModifierByName("modifier_imba_zuus_static_charge"):GetStackCount() / 2))
				end

				-- End cooldown of Nimbus and Ascend if target is killed and relevant talent is skilled
				if not hero:IsAlive() and caster:HasTalent("special_bonus_imba_zuus_9") and caster:HasAbility("imba_zuus_cloud") then
					caster:FindAbilityByName("imba_zuus_cloud"):EndCooldown()
					if caster:HasAbility("imba_zuus_nimbus_zap") then
						caster:FindAbilityByName("imba_zuus_nimbus_zap"):EndCooldown()
					end
					if caster:HasAbility("imba_zuus_lightning_bolt") then
						local thundergods_focus_modifier = caster:AddNewModifier(caster, self, "modifier_imba_zuus_thundergods_focus", {duration = caster:FindAbilityByName("imba_zuus_lightning_bolt"):GetSpecialValueFor("thundergods_focus_duration")})
						thundergods_focus_modifier:SetStackCount(thundergods_focus_modifier:GetStackCount() + 1)
					end
				end
				
				-- Add dummy to provide us with truesight aura
				-- local dummy_unit = CreateUnitByName("npc_dummy_unit", Vector(target_point.x, target_point.y, 0), false, nil, nil, self:GetCaster():GetTeam())
				-- local true_sight = dummy_unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_zuus_lightning_true_sight", {duration = sight_duration})
				-- dummy_unit:SetDayTimeVisionRange(sight_radius_day)
				-- dummy_unit:SetNightTimeVisionRange(sight_radius_night)
				-- dummy_unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_zuus_lightning_dummy", {})
				-- dummy_unit:AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = sight_duration + 1})
			end
		end
		
		if thundergods_focus_stacks >= self:GetSpecialValueFor("stacks_to_awaken") then
			ScreenShake(caster:GetAbsOrigin(), 50, 1, 1.0, 1000, 0, true)
			caster:AddNewModifier(caster, self, "modifier_imba_zuus_thundergods_awakening", {duration = min(thundergods_focus_stacks * 3, 42)})
		end
	end
end

----------------------------------------------------------
--				Thundergods Focus Modifier  			--
----------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_thundergods_focus", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_thundergods_focus = class({})
function modifier_imba_zuus_thundergods_focus:IsBuff() return true end
function modifier_imba_zuus_thundergods_focus:OnCreated() 
	self.bonus_movement_speed 	= 10
	self.bonus_turn_rate 		= 1
	if IsServer() then
		local caster = self:GetCaster()
		if self:GetCaster():HasTalent("special_bonus_imba_zuus_4") then 
			self.bonus_movement_speed 	= self.bonus_movement_speed + caster:FindTalentValue("special_bonus_imba_zuus_4", "movement_speed")
			self.bonus_turn_rate 		= caster:FindTalentValue("special_bonus_imba_zuus_4", "turn_rate")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_zuus_6") then 		
			for i = 0, 7 do
				local ability = self:GetParent():GetAbilityByIndex(i)
				if ability then
					local remaining_cooldown = ability:GetCooldownTimeRemaining()
					ability:EndCooldown()
					if remaining_cooldown > 1 then
						ability:StartCooldown(remaining_cooldown - 1)
					end
				end
			end
		end
	else 
		local net_table 			= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_movement_speed 	= net_table.movement_speed or 10
		self.bonus_turn_rate 		= net_table.turn_rate or 1
	end
end

function modifier_imba_zuus_thundergods_focus:GetTexture()
	return "zuus_lightning_bolt"
end

function modifier_imba_zuus_thundergods_focus:DeclareFunctions()
	decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_zuus_thundergods_focus:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed * self:GetStackCount()
end

function modifier_imba_zuus_thundergods_focus:GetModifierTurnRate_Percentage()
	return self.bonus_turn_rate * self:GetStackCount()
end


LinkLuaModifier("modifier_imba_zuus_pierce_spellimmunity", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_pierce_spellimmunity = class({})
function modifier_imba_zuus_pierce_spellimmunity:IsHidden() return false end

--------------------------------------------------------------
--				Thundergods Awakening Modifier  			--
--------------------------------------------------------------
LinkLuaModifier("modifier_imba_zuus_thundergods_awakening", "components/abilities/heroes/hero_zuus.lua", LUA_MODIFIER_MOTION_NONE)
modifier_imba_zuus_thundergods_awakening = class({})
function modifier_imba_zuus_thundergods_awakening:IsHidden() 	return false end
function modifier_imba_zuus_thundergods_awakening:IsBuff() 		return true end
function modifier_imba_zuus_thundergods_awakening:IsPurgable() 	return false end
function modifier_imba_zuus_thundergods_awakening:OnCreated()
	if IsServer() then 
		--self.static_field = ParticleManager:CreateParticle("particles/hero/zeus/awakening_zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		self.static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

		local caster = self:GetCaster()
		self.ability = caster:FindAbilityByName("imba_zuus_arc_lightning")
		self.arc_damage = self.ability:GetSpecialValueFor("arc_damage")

		if self.arc_damage == nil or self.arc_damage == 0 then
			self.arc_damage = 85
		end
	end
end

function modifier_imba_zuus_thundergods_awakening:GetTexture()
	return "zuus_thundergods_wrath"
end

function modifier_imba_zuus_thundergods_awakening:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return decFuncs
end

function modifier_imba_zuus_thundergods_awakening:GetModifierPercentageCasttime()
	return self:GetAbility():GetSpecialValueFor("cast_time_increase_pct")
end

function modifier_imba_zuus_thundergods_awakening:GetBonusVisionPercentage()
	return self:GetAbility():GetSpecialValueFor("vision_increase_pct")
end

function modifier_imba_zuus_thundergods_awakening:OnAttackLanded(keys)
	if IsServer() then
		local caster = self:GetCaster()
		if keys.attacker:GetTeam() ~= caster:GetTeam() and keys.attacker:IsAlive() and keys.target == caster and not keys.attacker:IsBuilding() then
			--print("Attacked!", keys.attacker:IsCreep(), keys.attacker:IsHero())
			local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, caster)
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y , caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(keys.attacker:GetAbsOrigin().x, keys.attacker:GetAbsOrigin().y, keys.attacker:GetAbsOrigin().z + keys.attacker:GetBoundingMaxs().z ))

			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= self.ability
			damage_table.damage_type 	= DAMAGE_TYPE_MAGICAL
			damage_table.damage			= self.arc_damage
			damage_table.victim 		= keys.attacker
			keys.attacker:EmitSound("Hero_Zuus.ArcLightning.Target")
			ApplyDamage(damage_table)
		end
	end
end

function modifier_imba_zuus_thundergods_awakening:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.static_field, true)
	end
end
