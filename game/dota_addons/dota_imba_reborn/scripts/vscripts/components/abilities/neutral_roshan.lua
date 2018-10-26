-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     zimberzimber, 30.08.2017
--     EarthSalamander #42, 12.02.2018

if imba_roshan_ai_diretide == nil then imba_roshan_ai_diretide = class({}) end
LinkLuaModifier("modifier_imba_roshan_ai_diretide", "components/abilities/neutral_roshan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_death_buff", "components/abilities/neutral_roshan", LUA_MODIFIER_MOTION_NONE)

function imba_roshan_ai_diretide:GetIntrinsicModifierName()
	return "modifier_imba_roshan_ai_diretide"
end

------------------------------------------
--				Modifiers				--
------------------------------------------

if modifier_imba_roshan_ai_diretide == nil then modifier_imba_roshan_ai_diretide = class({}) end
function modifier_imba_roshan_ai_diretide:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_diretide:IsPurgeException() return false end
function modifier_imba_roshan_ai_diretide:IsPurgable() return false end
function modifier_imba_roshan_ai_diretide:IsDebuff() return false end
function modifier_imba_roshan_ai_diretide:IsHidden() return true end

--	GENERAL

function modifier_imba_roshan_ai_diretide:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA end
	
function modifier_imba_roshan_ai_diretide:GetActivityTranslationModifiers()
	return "sugarrush"
end

function modifier_imba_roshan_ai_diretide:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_UNIT_MOVED,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_roshan_ai_diretide:CheckState()
	local state = {}

	-- Always phased, and hidden health bar
--	state[MODIFIER_STATE_NO_UNIT_COLLISION]	= true	-- Obvious reasons
	state[MODIFIER_STATE_NO_HEALTH_BAR]		= true	-- Either not needed, or shown in the HUD
	return state
end

function modifier_imba_roshan_ai_diretide:OnCreated()
	if IsServer() then
		-- common keys
		local ability = self:GetAbility()
		self.roshan = self:GetParent()	-- Roshans entity for easier handling
		self.AItarget = nil				-- Targeted hero

		-- phase 3 keys
		self.isTransitioning	= false												-- Is Roshan playing the transition animation?
		self.atStartPoint		= false												-- Has Roshan reached the start point?
		self.acquisition_range	= ability:GetSpecialValueFor("acquisition_range")	-- Acquisition range for phase 3
		self.leashPoint			= nil												-- Phase 3 arena mid point (defined in phase 3 thinking function)
		self.leashDistance		= ability:GetSpecialValueFor("leash_distance")		-- How far is Roshan allowed to walk away from the starting point
		self.leashHealPcnt		= ability:GetSpecialValueFor("leash_heal_pcnt")		-- Percent of max health Roshan will heal should he get leashed
		self.isDead				= false												-- Is Roshan 'dead'?
		self.last_movement		= 0.0

		-- Sound delays to sync with animation
		self.deathRoar		= 1.9

		-- Animation durations
		self.animDeath		= 11
		
		-- Ability handlers
		self.forceWave	= self.roshan:FindAbilityByName("roshan_deafening_blast")
--		self.roshlings	= self.roshan:FindAbilityByName("imba_roshan_diretide_summon_roshlings")
		self.breath		= self.roshan:FindAbilityByName("creature_fire_breath")
		self.apocalypse	= self.roshan:FindAbilityByName("imba_roshan_diretide_apocalypse")
		self.fireBall	= self.roshan:FindAbilityByName("imba_roshan_diretide_fireball")
--		self.toss		= self.roshan:FindAbilityByName("roshan_toss")

		-- Passive effect KVs
		self.bashChance = ability:GetSpecialValueFor("bash_chance") * 0.01
		self.bashDamage = ability:GetSpecialValueFor("bash_damage")
		self.bashDistance = ability:GetSpecialValueFor("bash_distance")
		self.bashDuration = ability:GetSpecialValueFor("bash_duration")

--		if not self.roshan:HasModifier("modifier_destroy_trees") then
--			self.roshan:AddNewModifier(self.roshan, self.ability, "modifier_destroy_trees", {})
--		end

		-- weird bug where roshan would swap team..
		if self.roshan:GetTeamNumber() ~= 4 then
			self.roshan:SetTeam(4)
		end

		if not self.roshan:HasModifier("modifier_command_restricted") then
			self.roshan:AddNewModifier(self.roshan, nil, "modifier_command_restricted", {})
		end

		local mod = self.roshan:AddNewModifier(self.roshan, self:GetAbility(), "modifier_imba_roshan_death_buff", {})
		mod:SetStackCount(GAME_ROSHAN_KILLS +1)

		-- Turn on brain
		self:StartPhase()
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_roshan_ai_diretide:OnUnitMoved(keys)    
	if IsServer() then
		local unit = keys.unit

		if self.caster == unit then
			self.last_movement = GameRules:GetGameTime()
		end
	end
end

function modifier_imba_roshan_ai_diretide:OnIntervalThink()
	local nearbyHeroes = FindUnitsInRadius(self.roshan:GetTeamNumber(), self.roshan:GetAbsOrigin(), nil, self.leashDistance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #nearbyHeroes == 0 then
		return
	else
		if GameRules:GetGameTime() - self.last_movement >= 3.0 then
--			print("Roshan is sleeping...")
			self.roshan:Purge(false, true, true, true, false)
			self.returningToLeash = true
		else
--			print("Activating brain!")
			self:ThinkPhase3(self.roshan)
			UpdateRoshanBar(self.roshan)
		end
	end
end

function modifier_imba_roshan_ai_diretide:OnDeath( keys )
	if keys.unit ~= self.roshan then return end
	-- Spawn death particle, start the respawn timer, index death point
	GAME_ROSHAN_KILLS = GAME_ROSHAN_KILLS + 1

	-- Play sounds
	self.roshan:EmitSound("Diretide.RoshanDeathLava")
	self.roshan:EmitSound("Diretide.RoshanDeath1")

	Timers:CreateTimer(self.deathRoar, function()
		self.roshan:EmitSound("Diretide.RoshanDeath2")
	end)

	-- Play particle
	local deathParticle = ParticleManager:CreateParticle("particles/hw_fx/hw_roshan_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(deathParticle, 0, self.roshan:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(deathParticle)

	Timers:CreateTimer(self.animDeath, function()
		local item = CreateItem("item_imba_aegis", nil, nil)
		local pos = self.roshan:GetAbsOrigin()
		local drop = CreateItemOnPositionSync(pos, item)
		item:LaunchLoot(false, 300, 0.5, pos)

		if GAME_ROSHAN_KILLS >= 2 then
			for i = 1, GAME_ROSHAN_KILLS -1 do
				local item = CreateItem("item_imba_cheese", nil, nil)
				local drop = CreateItemOnPositionSync(pos, item)
				item:LaunchLoot(false, 300, 0.5, pos + RandomVector(RandomInt(100, 150)))
			end
		end
		
		if GAME_ROSHAN_KILLS >= 3 then
			for i = 1, GAME_ROSHAN_KILLS -2 do
				local item = CreateItem("item_refresher_shard", nil, nil)
				local drop = CreateItemOnPositionSync(pos, item)
				item:LaunchLoot(false, 300, 0.5, pos + RandomVector(RandomInt(100, 150)))
			end
		end

		Timers:CreateTimer(ROSHAN_RESPAWN_TIME, function()
			local roshan = CreateUnitByName("npc_imba_roshan", ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end)
	end)
end

function modifier_imba_roshan_ai_diretide:StartPhase(phase)
	-- Reset values
	self.AItarget = nil
	self.atStartPoint = false
	self.leashPoint = nil

	-- Reset behavior
	self.roshan:SetAcquisitionRange(-1000)
	self.roshan:SetForceAttackTarget(nil)
	self.roshan:Interrupt()

	self.roshan:SetHealth(self.roshan:GetMaxHealth())

	self:StartIntervalThink(0.1)
	UpdateRoshanBar(self.roshan, FrameTime()*2)
end

--	PHASE III
function modifier_imba_roshan_ai_diretide:ThinkPhase3(roshan)
if roshan:IsStunned() or roshan:IsSilenced() or roshan:IsHexed() or roshan:IsChanneling() then return end
if not self.leashPoint then self.leashPoint = ROSHAN_SPAWN_LOC end

	local distanceFromLeash = (roshan:GetAbsOrigin() - self.leashPoint):Length2D()
	if not self.returningToLeash and distanceFromLeash >= self.leashDistance then
		self.returningToLeash = true
		roshan:SetHealth(roshan:GetHealth() + roshan:GetMaxHealth() * (self.leashHealPcnt * 0.01)) -- To bypass shit like AAs ult or Malediction healing reduction
	elseif self.returningToLeash and distanceFromLeash < 100 then
		roshan:Interrupt()
		self.returningToLeash = false
		self.roshan:Purge(false, true, true, true, false)

		if not roshan:HasModifier("modifier_command_restricted") then
			roshan:AddNewModifier(roshan, nil, "modifier_command_restricted", {})
		end
	end
	
	-- Return to the leashing point if he should
	if self.returningToLeash then
		roshan:SetForceAttackTarget(nil)
		roshan:MoveToPosition(self.leashPoint)
		return
	end

	local ability_count = roshan:GetAbilityCount()
	for ability_index = 0, ability_count - 1 do
		local ability = roshan:GetAbilityByIndex( ability_index ) 
		if ability and ability:IsInAbilityPhase() then
			if not roshan:HasModifier("modifier_black_king_bar_immune") then
				roshan:EmitSound("DOTA_Item.BlackKingBar.Activate")
			else
				roshan:RemoveModifierByName("modifier_black_king_bar_immune")
			end
			roshan:AddNewModifier(roshan, self.ability, "modifier_black_king_bar_immune", {duration=0.2})
		end
	end

	-- If can summon Roshlings, summon them and keep thinking
	if not roshan:GetCurrentActiveAbility() then
		if self.roshlings and self.roshlings:IsCooldownReady() then
			local foundRoshling = false
			
			local units = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
			for _, unit in ipairs(units) do
				if unit:GetUnitLabel() == "npc_imba_roshling" then
					foundRoshling = true
					break
				end
			end

			if foundRoshling then
				self.roshlings:StartCooldown(self.roshlings:GetSpecialValueFor("spawn_think_cooldown"))
			else
				roshan:CastAbilityNoTarget(self.roshlings, 1)
			end
		end
		
		-- Cast Force Wave if its available
		if self.forceWave and self.forceWave:IsCooldownReady() then
			local radius = 1000
--			local minTargets = self.forceWave:GetSpecialValueFor("min_targets")
			local minTargets = 3

			local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, hero in ipairs(nearbyHeroes) do
				roshan:CastAbilityOnPosition(hero:GetAbsOrigin(), self.forceWave, 1)
				return
			end
		local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #nearbyHeroes >= minTargets then
			roshan:CastAbilityNoTarget(self.apocalypse, 1)
			return
		end
		end

		-- Cast apocalypse if its available
		if self.apocalypse and self.apocalypse:IsCooldownReady() then
			local maxRange = self.apocalypse:GetSpecialValueFor("max_range")
			local minRange = self.apocalypse:GetSpecialValueFor("min_range")
			local minTargets = self.apocalypse:GetSpecialValueFor("min_targets")
			local inRange = 0

			local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for _, hero in ipairs(nearbyHeroes) do
				if CalcDistanceBetweenEntityOBB(roshan, hero) >= minRange then
					inRange = inRange + 1
				end
			end
			
			if inRange >= minTargets then
				roshan:CastAbilityNoTarget(self.apocalypse, 1)
				return
			end
		end

		-- Cast Fire Breath if its available
		if self.breath and self.breath:IsCooldownReady() then
			local searchRange = self.breath:GetSpecialValueFor("search_range")
			local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, searchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, hero in ipairs(nearbyHeroes) do
				roshan:CastAbilityOnPosition(hero:GetAbsOrigin(), self.breath, 1)
				return
			end
		end
		
		-- Cast Fire Ball if its available
		if self.fireBall and self.fireBall:IsCooldownReady() then
			local range = self.fireBall:GetSpecialValueFor("range")
			local minTargets = self.fireBall:GetSpecialValueFor("min_targets")
			
			local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #nearbyHeroes >= minTargets then
				roshan:CastAbilityNoTarget(self.fireBall, 1)
				return
			end
		end
		
		-- Cast Toss if its available
		if self.toss and self.toss:IsCooldownReady() then
			local maxRange = self.toss:GetSpecialValueFor("tooltip_range")
			local pickupRadius = self.toss:GetSpecialValueFor("grab_radius")
			local pickupUnit = nil
			local throwTarget = nil
			
			local units = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, pickupRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false) 
			for _, unit in ipairs(units) do
				if unit and unit:IsAlive() and not unit:IsAncient() then
					pickupUnit = unit
					break
				end
			end

			if pickupUnit then
				units = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_FARTHEST, false) 
				for _, unit in ipairs(units) do
					if unit and unit:IsAlive() then
						throwTarget = unit
						break
					end
				end

				if throwTarget then
					roshan:CastAbilityOnTarget(throwTarget, self.toss, 1)
					return
				end
			end
		end
	end
end

function modifier_imba_roshan_ai_diretide:OnTakeDamage(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker

		if unit == self.roshan then
			if attacker == unit then return nil end
			self.last_movement = GameRules:GetGameTime()

			self.roshan:RemoveModifierByName("modifier_command_restricted")
			attacker.roshan_attacked_time = GameRules:GetGameTime()
			CustomGameEventManager:Send_ServerToPlayer(attacker:GetPlayerOwner(), "show_roshan_hp", {})

			Timers:CreateTimer(5.0, function()
				if GameRules:GetGameTime() - attacker.roshan_attacked_time >= 5.0 then
					CustomGameEventManager:Send_ServerToPlayer(attacker:GetPlayerOwner(), "hide_roshan_hp", {})
				end
			end)
		end
	end
end

--	SPECIAL EFFECTS + ATTACK SOUND + ILLUSION KILLER
function modifier_imba_roshan_ai_diretide:OnAttackLanded(keys)
	if IsServer() then
		local roshan = self:GetParent()
		local target = keys.target
		local attacker = keys.attacker
		
		if roshan == target then
			if attacker:IsIllusion() then attacker:ForceKill(true) end
		elseif roshan == attacker then
			
			-- Emit hit sound
			target:EmitSound("Roshan.Attack")
			target:EmitSound("Roshan.Attack.Post")

			-- check bash chance
			if math.random() <= self.bashChance then
				local knockback = {	center_x = target.x,
									center_y = target.y,
									center_z = target.z,
									duration = self.bashDuration,
									knockback_distance = 200,
									knockback_height = self.bashDistance,
									knockback_duration = self.bashDuration * 0.67,	}
				target:AddNewModifier(roshan, self:GetAbility(), "modifier_knockback", knockback)
				target:EmitSound("Roshan.Bash")
			end
		end
	end
end

--	PREATTACK SOUND
function modifier_imba_roshan_ai_diretide:OnAttackStart(keys)
	if IsServer() then
		local roshan = self:GetParent()
		if roshan == keys.attacker then
			roshan:EmitSound("Roshan.PreAttack")
			roshan:EmitSound("Roshan.Grunt")
			self.last_movement = GameRules:GetGameTime()
		end
	end
end

---------- Roshans death buff
if modifier_imba_roshan_death_buff == nil then modifier_imba_roshan_death_buff = class({}) end
function modifier_imba_roshan_death_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_death_buff:IsPurgeException() return false end
function modifier_imba_roshan_death_buff:IsPurgable() return false end
function modifier_imba_roshan_death_buff:IsHidden() return true end
function modifier_imba_roshan_death_buff:IsDebuff() return false end

function modifier_imba_roshan_death_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_imba_roshan_death_buff:GetModifierExtraHealthBonus()
	return self:GetAbility():GetSpecialValueFor("health_per_death") * self:GetStackCount()
end

function modifier_imba_roshan_death_buff:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor("spellamp_per_death") * self:GetStackCount()
end

function modifier_imba_roshan_death_buff:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("damage_per_death") * self:GetStackCount()
end

function modifier_imba_roshan_death_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("attackspeed_per_death") * self:GetStackCount()
end

function modifier_imba_roshan_death_buff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_per_death") * self:GetStackCount()
end

function modifier_imba_roshan_death_buff:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("tenacity_per_death") * self:GetStackCount()
end

------------------------------------------
--				APOCALYPSE				--
------------------------------------------
if imba_roshan_diretide_apocalypse == nil then imba_roshan_diretide_apocalypse = class({}) end
function imba_roshan_diretide_apocalypse:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_1 end

function imba_roshan_diretide_apocalypse:OnSpellStart()
	local roshan = self:GetCaster()
	local minRange = self:GetSpecialValueFor("min_range")
	local maxRange = self:GetSpecialValueFor("max_range")
	local delay = self:GetSpecialValueFor("delay")
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	
	local positions = {}
	local heroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, maxRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _, hero in ipairs(heroes) do
		if CalcDistanceBetweenEntityOBB(roshan, hero) >= minRange then
			local pos = hero:GetAbsOrigin()
			table.insert(positions, pos)
			
			EmitSoundOnLocationWithCaster(pos, "Hero_Invoker.SunStrike.Charge", roshan)
			local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_CUSTOMORIGIN, roshan)
			ParticleManager:SetParticleControl(particle, 0, pos)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end
	
	Timers:CreateTimer(delay, function()
		
		-- loop through the positions and deal damage to all units caught in the explosions AoE
		for _, position in ipairs(positions) do
			local units = FindUnitsInRadius(roshan:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			local damageTable = {victim = nil, attacker = roshan, damage = damage / #units, damage_type = DAMAGE_TYPE_PURE}

			for _, unit in ipairs(units) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end

			EmitSoundOnLocationWithCaster(position, "Hero_Invoker.SunStrike.Ignite", roshan) 
			local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_CUSTOMORIGIN, roshan)
			ParticleManager:SetParticleControl(particle, 0, position)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end)
end

------------------------------------------
--				ROSHLINGS				--
------------------------------------------
if imba_roshan_diretide_summon_roshlings == nil then imba_roshan_diretide_summon_roshlings = class({}) end
function imba_roshan_diretide_summon_roshlings:OnSpellStart()
	local roshan = self:GetCaster()
	local roshanPos = roshan:GetAbsOrigin()
	local summonCount = self:GetSpecialValueFor("summon_count")
	local summon = "npc_imba_roshling"
	local summonAbilities = { "imba_roshling_bash", "imba_roshling_aura" }
	
	
	local deathMod = roshan:FindModifierByName("modifier_imba_roshan_death_buff")
	if deathMod then
		summonCount = summonCount + deathMod:GetStackCount() * self:GetSpecialValueFor("extra_per_death")
	end
	
	local roshling = nil
	GridNav:DestroyTreesAroundPoint(roshanPos, 250, false)
	for i = 1, summonCount do
		roshling = CreateUnitByName(summon, roshanPos, true, roshan, roshan, roshan:GetTeam())
		roshling:SetForwardVector(roshan:GetForwardVector())
		
		for _, abilityName in ipairs(summonAbilities) do
			local ability = roshling:FindAbilityByName(abilityName)
			if ability then ability:SetLevel(1) end
		end
	end
end
