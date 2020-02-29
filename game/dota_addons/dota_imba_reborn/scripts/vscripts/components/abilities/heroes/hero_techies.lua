-- Author: Shush
-- Date: 2/5/2017

------------------------------
--     HELPER FUNCTIONS     --
------------------------------

local function ApplyInflammableToRemoteMines(caster, range, remote_mines)

	if not remote_mines then
		-- Find Remote Mines in the explosion radius
		remote_mines = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										range,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_OTHER,
										DOTA_UNIT_TARGET_FLAG_NONE,
										FIND_ANY_ORDER,
										false)
	end

	local modifier_inflammable = "modifier_imba_remote_mine_inflammable"
	local detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

	-- Give them inflammable stacks
	for _,remote_mine in pairs(remote_mines) do
		if remote_mine:GetUnitName() == "npc_imba_techies_remote_mine" then

			local modifier_inflammable_handler = remote_mine:FindModifierByName(modifier_inflammable)
			if not modifier_inflammable_handler then
				local detonate_ability_handler = remote_mine:FindAbilityByName(detonate_ability)
				if detonate_ability_handler then
					local inflammable_duration = detonate_ability_handler:GetSpecialValueFor("inflammable_duration")
					modifier_inflammable_handler = remote_mine:AddNewModifier(caster, detonate_ability_handler, modifier_inflammable, {duration = inflammable_duration})
				end
			end

			-- Nil Check
			if modifier_inflammable_handler then
				modifier_inflammable_handler:IncrementStackCount()
				modifier_inflammable_handler:ForceRefresh()
			end
		end
	end
end

local function RefreshElectroCharge(unit)
	local modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"

	-- If the enemy has Electrocharge (from Stasis Trap), refresh it and add a stack
	local modifier_electrocharge_handler = unit:FindModifierByName(modifier_electrocharge)
	if modifier_electrocharge_handler then
		modifier_electrocharge_handler:IncrementStackCount()
		modifier_electrocharge_handler:ForceRefresh()
	end
end

local function PlantProximityMine(caster, ability, spawn_point, big_boom)
	local mine_ability = "imba_techies_proximity_mine_trigger"

	-- Create the mine unit
	local mine_name
	if big_boom then
		mine_name = "npc_imba_techies_proximity_mine_big_boom"
	else
		mine_name = "npc_imba_techies_proximity_mine"
	end

	local mine = CreateUnitByName(mine_name, spawn_point, true, caster, caster, caster:GetTeamNumber())

	mine:AddRangeIndicator(caster, nil, nil, ability:GetAOERadius(), 150, 22, 22, false, false, false)

	-- Set the mine's team to be the same as the caster
	local playerID = caster:GetPlayerID()
	mine:SetControllableByPlayer(playerID, true)

	-- Set the mine's ability to be the same level as the planting ability
	local mine_ability_handler = mine:FindAbilityByName(mine_ability)
	if mine_ability_handler then
		mine_ability_handler:SetLevel(ability:GetLevel())
	end

	-- Set the mine's owner to be the caster
	mine:SetOwner(caster)
end

------------------------------
--     PROXIMITY MINE       --
------------------------------
imba_techies_proximity_mine = imba_techies_proximity_mine or class({})
LinkLuaModifier("modifier_imba_proximity_mine_charges", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_proximity_mine:GetAbilityTextureName()
   return "techies_land_mines"
end

function imba_techies_proximity_mine:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function imba_techies_proximity_mine:IsHiddenWhenStolen()
	return false
end

function imba_techies_proximity_mine:IsNetherWardStealable()
	return false
end

function imba_techies_proximity_mine:GetIntrinsicModifierName()
	return "modifier_imba_proximity_mine_charges"
end

function imba_techies_proximity_mine:GetManaCost(level)
	-- Ability properties
	local caster = self:GetCaster()
	local initial_mana_cost = self.BaseClass.GetManaCost(self, level)
	local modifier_charges = "modifier_imba_proximity_mine_charges"

	-- Ability specials
	local mana_increase_per_stack = self:GetSpecialValueFor("mana_increase_per_stack")

	-- Find stack count
	stacks = caster:GetModifierStackCount(modifier_charges, caster)

	local mana_cost = initial_mana_cost + mana_increase_per_stack * stacks
	return mana_cost
end

function imba_techies_proximity_mine:CastFilterResultLocation(location)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self

		-- Ability specials
		local mine_distance = ability:GetSpecialValueFor("mine_distance")
		local trigger_range = ability:GetSpecialValueFor("trigger_range")

		-- #1 Talent: Trigger range increase
		trigger_range = trigger_range + caster:FindTalentValue("special_bonus_imba_techies_1")

		-- Radius
		local radius = mine_distance + trigger_range

		-- Look for nearby mines
		local friendly_units = FindUnitsInRadius(caster:GetTeamNumber(),
												location,
												nil,
												radius,
												DOTA_UNIT_TARGET_TEAM_FRIENDLY,
												DOTA_UNIT_TARGET_OTHER,
												DOTA_UNIT_TARGET_FLAG_NONE,
												FIND_ANY_ORDER,
												false)

		local mine_found = false

		-- Search and see if mines were found
		for _,unit in pairs(friendly_units) do
			local unitName = unit:GetUnitName()
			if unitName == "npc_imba_techies_proximity_mine" or unitName == "npc_imba_techies_proximity_mine_big_boom" then
				mine_found = true
				break
			end
		end

		if mine_found then
			return UF_FAIL_CUSTOM
		else
			return UF_SUCCESS
		end
	end
end

function imba_techies_proximity_mine:GetCustomCastErrorLocation(location)
	return "Cannot place mine in range of other mines"
end

function imba_techies_proximity_mine:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self

	local trigger_range = ability:GetSpecialValueFor("trigger_range")
	local mine_distance = ability:GetSpecialValueFor("mine_distance")

	-- #1 Talent: Trigger range increase
	trigger_range = trigger_range + caster:FindTalentValue("special_bonus_imba_techies_1")

	return trigger_range + mine_distance
end

function imba_techies_proximity_mine:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = {"techies_tech_setmine_01", "techies_tech_setmine_02", "techies_tech_setmine_04", "techies_tech_setmine_08", "techies_tech_setmine_09", "techies_tech_setmine_10", "techies_tech_setmine_11", "techies_tech_setmine_13", "techies_tech_setmine_16", "techies_tech_setmine_17", "techies_tech_setmine_18", "techies_tech_setmine_19", "techies_tech_setmine_20", "techies_tech_setmine_30", "techies_tech_setmine_32", "techies_tech_setmine_33", "techies_tech_setmine_34", "techies_tech_setmine_38", "techies_tech_setmine_45", "techies_tech_setmine_46", "techies_tech_setmine_47", "techies_tech_setmine_48", "techies_tech_setmine_50", "techies_tech_setmine_51", "techies_tech_setmine_54", "techies_tech_cast_02", "techies_tech_cast_03", "techies_tech_setmine_05", "techies_tech_setmine_06", "techies_tech_setmine_07", "techies_tech_setmine_14", "techies_tech_setmine_21", "techies_tech_setmine_22", "techies_tech_setmine_23", "techies_tech_setmine_24", "techies_tech_setmine_25", "techies_tech_setmine_26", "techies_tech_setmine_28", "techies_tech_setmine_29", "techies_tech_setmine_35", "techies_tech_setmine_36", "techies_tech_setmine_37", "techies_tech_setmine_39", "techies_tech_setmine_41", "techies_tech_setmine_42", "techies_tech_setmine_43", "techies_tech_setmine_44", "techies_tech_setmine_52"}
	local sound_cast = "Hero_Techies.LandMine.Plant"
	local modifier_charges = "modifier_imba_proximity_mine_charges"

	-- Ability special
	local initial_mines = ability:GetSpecialValueFor("initial_mines")
	local mine_distance = ability:GetSpecialValueFor("mine_distance")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Get the amount of Proximity Mine charges, and consume all stacks
	local mine_placement_count = 0
	local modifier_charges_handler = caster:FindModifierByName(modifier_charges)
	if modifier_charges_handler then
		mine_placement_count = modifier_charges_handler:GetStackCount()

		-- If there are no charges, do nothing
		if modifier_charges_handler:GetStackCount() > 0 then
			modifier_charges_handler:SetStackCount(0)
		end
	end

	-- Determine mine locations, depending on mine count
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	-- Always plant the initial mine in the target point. Big boom if appropriate
	local big_boom = false

	-- #7 Talent: Proximity Mines initial mine is a Big Boom
	if caster:HasTalent("special_bonus_imba_techies_7") then
		big_boom = true
	end

	PlantProximityMine(caster, ability, target_point, big_boom)

	-- Rotate the locations and find the additional mine spots
	if mine_placement_count > 0 then
		local degree = 360 / mine_placement_count

		-- Calculate location of the first mine, ahead of the target point
		local mine_spawn_point = target_point + direction * mine_distance

		for i = 1, mine_placement_count do
			-- Prepare the QAngle
			local qangle = QAngle(0, (i-1) * degree, 0)

			-- Rotate the mine point
			local mine_point = RotatePosition(target_point, qangle, mine_spawn_point)

			-- Plant a mine!
			PlantProximityMine(caster, ability, mine_point, false)
		end
	end
end


-- Charges modifier
modifier_imba_proximity_mine_charges = modifier_imba_proximity_mine_charges or class({})

function modifier_imba_proximity_mine_charges:OnCreated()
	local ability = self:GetAbility()

	-- Ability specials
	self.charge_replenish_duration = ability:GetSpecialValueFor("charge_replenish_duration")
	self.max_charges = ability:GetSpecialValueFor("max_charges")

	-- Set a bonus first mine immediatley when the ability is first learned
	if not self.repeated then
		self:SetStackCount(1)
		self:SetDuration(self.charge_replenish_duration, true)
		self.repeated = true
	end

	-- Start thinking
	self:StartIntervalThink(0.1)
end

function modifier_imba_proximity_mine_charges:OnRefresh()
	self:OnCreated()
end

function modifier_imba_proximity_mine_charges:OnIntervalThink()
	-- Check the current duration
	local duration = self:GetDuration()

	-- If the duration is fixed, do nothing
	if duration == -1 then
		return nil
	end

	-- If the amount of mines somehow got over the maximum, retain max charges
	if self:GetStackCount() > self.max_charges then
		self:SetStackCount(self.max_charges)
	end

	-- Otherwise, get the remaining duration. If it's 0 or below, grant a stack!
	local remaining_duration = self:GetRemainingTime()

	if remaining_duration <= 0 then
		self.restart = true
		self:IncrementStackCount()
	end
end

function modifier_imba_proximity_mine_charges:IsHidden() return false end
function modifier_imba_proximity_mine_charges:IsDebuff() return false end
function modifier_imba_proximity_mine_charges:IsPurgable() return false end
function modifier_imba_proximity_mine_charges:RemoveOnDeath() return false end
function modifier_imba_proximity_mine_charges:AllowIllusionDuplicate() return false end
function modifier_imba_proximity_mine_charges:DestroyOnExpire() return false end

function modifier_imba_proximity_mine_charges:OnStackCountChanged(old_count)
	-- Get current stack count
	local stacks = self:GetStackCount()

	-- If the stacks somehow surpassed max charges, reset to max
	-- This somehow happens when player is disconnected for some reason
	if stacks > self.max_charges then
		self:SetStackCount(self.max_charges)
	end

	-- If the stack is in the maximum, stop the duration
	if stacks == self.max_charges then
		self:SetDuration(-1, true)

	-- Otherwise, if it needs to be restared, do so
	elseif self.restart or old_count == self.max_charges then
		self:SetDuration(self.charge_replenish_duration, true)
	end

	self.restart = false
end


------------------------------
--     PROXIMITY MINE AI    --
------------------------------
imba_techies_proximity_mine_trigger = imba_techies_proximity_mine_trigger or class({})
LinkLuaModifier("modifier_imba_proximity_mine", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_proximity_mine_building_res", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_proximity_mine_talent", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_proximity_mine_trigger:GetIntrinsicModifierName()
	return "modifier_imba_proximity_mine"
end

function imba_techies_proximity_mine_trigger:GetAbilityTextureName()
   return "rubick_empty1"
end

-- Proximity mine states modifier
modifier_imba_proximity_mine = modifier_imba_proximity_mine or class({})

function modifier_imba_proximity_mine:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.owner = self.caster:GetOwner()

		-- Ability specials
		self.explosion_delay = self.ability:GetSpecialValueFor("explosion_delay")
		self.mine_damage = self.ability:GetSpecialValueFor("mine_damage")
		self.explosion_range = self.ability:GetSpecialValueFor("explosion_range")
		self.trigger_range = self.ability:GetSpecialValueFor("trigger_range")
		self.activation_delay = self.ability:GetSpecialValueFor("activation_delay")
		self.building_damage_pct = self.ability:GetSpecialValueFor("building_damage_pct")
		self.buidling_damage_duration = self.ability:GetSpecialValueFor("buidling_damage_duration")
		self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
		self.fow_radius = self.ability:GetSpecialValueFor("fow_radius")
		self.fow_duration = self.ability:GetSpecialValueFor("fow_duration")
		self.big_boom_mine_bonus_dmg = self.ability:GetSpecialValueFor("big_boom_mine_bonus_dmg")
		self.big_boom_shrapnel_duration = self.ability:GetSpecialValueFor("big_boom_shrapnel_duration")

		-- #1 Talent: Trigger range increase
		self.trigger_range = self.trigger_range + self.caster:FindTalentValue("special_bonus_imba_techies_1")

		-- Add mine particle effect
		local particle_mine = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
		local particle_mine_fx = ParticleManager:CreateParticle(particle_mine, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(particle_mine_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_mine_fx, 3, self.caster:GetAbsOrigin())
		self:AddParticle(particle_mine_fx, false, false, -1, false, false)

		-- Set the mine as inactive
		self.active = false
		self.triggered = false
		self.trigger_time = 0

		if IsServer() then

			-- Determine if this is a Big Boom
			if self.caster:GetUnitName() == "npc_imba_techies_proximity_mine_big_boom" then
				self.is_big_boom = true
			end

			-- Wait for the mine to activate
			Timers:CreateTimer(self.activation_delay, function()
				-- Mark mine as active
				self.active = true

				-- Start looking around for enemies
				self:StartIntervalThink(self.tick_interval)
			end)
		end
	end
end

function modifier_imba_proximity_mine:IsHidden() return true end
function modifier_imba_proximity_mine:IsPurgable() return false end
function modifier_imba_proximity_mine:IsDebuff() return false end

function modifier_imba_proximity_mine:OnIntervalThink()
	if IsServer() then
		local caster = self.caster

		-- If the mine was killed, remove the modifier
		if not caster:IsAlive() then
			self:Destroy()
		end

		local modifier_sign = "modifier_imba_minefield_sign_detection"
		-- If the mine is under the sign effect, reset possible triggers and do nothing
		if caster:HasModifier(modifier_sign) then
			self.triggered = false
			self.trigger_time = 0
			self.hidden_by_sign = true
			return nil
		end

		-- Look for nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  self.trigger_range,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
										  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
										  FIND_ANY_ORDER,
										  false)

		local enemy_found

		if #enemies > 0 then
			local non_flying_enemies = false

			-- Check if there is at least one enemy that isn't flying
			for _,enemy in pairs(enemies) do
				if not enemy:HasFlyMovementCapability() then
					non_flying_enemies = true
					break
				end
			end

			-- At least one non-flying enemy found - mark as found
			if non_flying_enemies then
				enemy_found = true
			else
				enemy_found = false
			end
		else
			enemy_found = false
		end

		-- If the mine is not triggered, check if it should be triggered
		if not self.triggered then
			if enemy_found then
				self.triggered = true
				self.trigger_time = 0

				-- Play prime sound
				local sound_prime = "Hero_Techies.LandMine.Priming"
				EmitSoundOn(sound_prime, caster)
			end

		-- If the mine was already triggered, check if it should stop or count time
		else
			if enemy_found then
				self.trigger_time = self.trigger_time + self.tick_interval

				-- Check if the mine should blow up
				if self.trigger_time >= self.explosion_delay then
					self:_Explode()
				end
			else
				self.triggered = false
				self.trigger_time = 0
			end
		end
	end
end

function modifier_imba_proximity_mine:_Explode()
	local enemy_killed
	local caster = self.caster
	local explosion_range = self.explosion_range

	-- BLOW UP TIME! Play explosion sound
	local sound_explosion = "Hero_Techies.LandMine.Detonate"
	EmitSoundOn(sound_explosion, caster)

	local casterAbsOrigin = caster:GetAbsOrigin()

	-- Add particle explosion effect
	local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
	local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explosion_fx, 0, casterAbsOrigin)
	ParticleManager:SetParticleControl(particle_explosion_fx, 1, casterAbsOrigin)
	ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(explosion_range, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

	-- Look for nearby enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										casterAbsOrigin,
										nil,
										explosion_range,
										DOTA_UNIT_TARGET_TEAM_ENEMY,
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
										FIND_ANY_ORDER,
										false)

	local modifier_building_res = "modifier_imba_proximity_mine_building_res"
	local modifier_talent_shrapnel = "modifier_imba_proximity_mine_talent"

	-- If this is a Big Boom, RAIN THEM SHRAPNELS!
	if self.is_big_boom then
		CreateModifierThinker(caster, self.ability, modifier_talent_shrapnel, {duration = self.big_boom_shrapnel_duration}, casterAbsOrigin, caster:GetTeamNumber(), false)
	end

	-- Deal damage to nearby non-flying enemies
	for _,enemy in pairs(enemies) do

		-- If an enemy doesn't have flying movement, ignore it, otherwise continue
		if not enemy:HasFlyMovementCapability() then

			-- If this is a Big Boom, add damage to the blast!
			local damage = self.mine_damage
			if self.is_big_boom then
				damage = damage + self.big_boom_mine_bonus_dmg
			end

			-- If the enemy is a building, reduce damage to it
			if enemy:IsBuilding() then
				damage = damage * self.building_damage_pct * 0.01
			end

			-- Deal damage
			local damageTable = {victim = enemy,
									attacker = caster, 
--									damage = damage * ((1+(PlayerResource:GetSelectedHeroEntity(self.caster:GetPlayerOwnerID()):GetSpellAmplification(false) * 0.01))),
									damage = damage,
									damage_type = DAMAGE_TYPE_MAGICAL,
									ability = self.ability
									}

			ApplyDamage(damageTable)

			-- If the enemy was a building, give it magical protection
			if enemy:IsBuilding() and not enemy:HasModifier(modifier_building_res) then
				enemy:AddNewModifier(caster, self.ability, modifier_building_res, {duration = self.buidling_damage_duration})
			end

			RefreshElectroCharge(enemy)

			-- See if the enemy died from the mine
			Timers:CreateTimer(FrameTime(), function()
				if not enemy:IsAlive() then
					enemy_killed = true
				end
			end)
		end
	end

	ApplyInflammableToRemoteMines(caster, self.trigger_range, nil)

	-- If an enemy was killed from a mine, play kill response
	if RollPercentage(25) then
		Timers:CreateTimer(FrameTime()*2, function()
			local kill_response = {"techies_tech_mineblowsup_01", "techies_tech_mineblowsup_02", "techies_tech_mineblowsup_03", "techies_tech_mineblowsup_04", "techies_tech_mineblowsup_05", "techies_tech_mineblowsup_06", "techies_tech_mineblowsup_08", "techies_tech_mineblowsup_09", "techies_tech_minekill_01", "techies_tech_minekill_02", "techies_tech_minekill_03"}

			if enemy_killed then
				EmitSoundOn(kill_response[math.random(1, #kill_response)], self.owner)
			end
		end)
	end

	-- Apply flying vision at detonation point
	AddFOWViewer(caster:GetTeamNumber(), casterAbsOrigin, self.fow_radius, self.fow_duration, false)

	-- Kill self and remove modifier
	caster:ForceKill(false)
	self:Destroy()
end

function modifier_imba_proximity_mine:CheckState()
	local state

	if self.active and not self.triggered then
		state = {[MODIFIER_STATE_INVISIBLE] = true,
				 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		state = {[MODIFIER_STATE_INVISIBLE] = false,
				 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	end

	return state
end

function modifier_imba_proximity_mine:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_TAKEDAMAGE,
					 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_proximity_mine:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_proximity_mine:OnTakeDamage(keys)
	local unit = keys.unit
	local attacker = keys.attacker

	-- Only apply if the unit taking damage is the mine
	if unit == self.caster then
		-- Reduce mines' life by 1, or kill it. This is only relevant for Big Boom mines
		local mine_health = self.caster:GetHealth()
		if mine_health > 1 then
			self.caster:SetHealth(mine_health - 1)
		else
			self.caster:Kill(self.ability, attacker)
		end
	end
end

function modifier_imba_proximity_mine:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end


-- Building fortification modifier
modifier_imba_proximity_mine_building_res = modifier_imba_proximity_mine_building_res or class({})

function modifier_imba_proximity_mine_building_res:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()

	-- Ability specials
	self.building_magic_resistance = self.ability:GetSpecialValueFor("building_magic_resistance")
end

function modifier_imba_proximity_mine_building_res:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS}

	return decFuncs
end

function modifier_imba_proximity_mine_building_res:GetModifierMagicalResistanceBonus()
	return self.building_magic_resistance
end

function modifier_imba_proximity_mine_building_res:IsHidden() return true end
function modifier_imba_proximity_mine_building_res:IsPurgable() return false end
function modifier_imba_proximity_mine_building_res:IsDebuff() return false end




-- BIG BOOM SHRAPNEL MODIFIER!
modifier_imba_proximity_mine_talent = modifier_imba_proximity_mine_talent or class({})

function modifier_imba_proximity_mine_talent:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.parent_team = self.parent:GetTeamNumber()
		local parentAbsOrigin = self.parent:GetAbsOrigin()
		self.parent_pos = parentAbsOrigin
		self.ability = self:GetAbility()

		-- Ability specials
		self.big_boom_shrapnel_aoe = self.ability:GetSpecialValueFor("big_boom_shrapnel_aoe")
		self.big_boom_shrapnel_damage = self.ability:GetSpecialValueFor("big_boom_shrapnel_damage")
		self.big_boom_shrapnel_interval = self.ability:GetSpecialValueFor("big_boom_shrapnel_interval")

		-- Create rain particles
		local particle_rain = "particles/hero/techies/techies_big_boom_explosions.vpcf"
		local particle_rain_fx = ParticleManager:CreateParticle(particle_rain, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_rain_fx, 0, parentAbsOrigin)
		ParticleManager:SetParticleControl(particle_rain_fx, 1, parentAbsOrigin)
		ParticleManager:SetParticleControl(particle_rain_fx, 3, parentAbsOrigin)
		self:AddParticle(particle_rain_fx, false, false, -1, false, false)

		-- Damage per interval
		self.damage = self.big_boom_shrapnel_damage * self.big_boom_shrapnel_interval

		-- Start thinking
		self:StartIntervalThink(self.big_boom_shrapnel_interval)
	end
end

function modifier_imba_proximity_mine_talent:OnIntervalThink()
	if IsServer() then
		-- Find all nearby units
		local enemies = FindUnitsInRadius(self.parent_team,
										  self.parent_pos,
										  nil,
										  self.big_boom_shrapnel_aoe,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										  DOTA_DAMAGE_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

		for _, enemy in pairs(enemies) do
			-- Deal magical damage to them
			local damageTable = {victim = enemy,
								attacker = self.caster,
--								damage = self.damage * ((1+(PlayerResource:GetSelectedHeroEntity(self.caster:GetPlayerOwnerID()):GetSpellAmplification(false) * 0.01))),
								damage = self.damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = self.ability
								}

			ApplyDamage(damageTable)
		end
	end
end


------------------------------
--       STASIS TRAP        --
------------------------------
imba_techies_stasis_trap = imba_techies_stasis_trap or class({})

function imba_techies_stasis_trap:GetAbilityTextureName()
   return "techies_stasis_trap"
end

function imba_techies_stasis_trap:IsHiddenWhenStolen()
	return false
end

function imba_techies_stasis_trap:IsNetherWardStealable()
	return false
end

function imba_techies_stasis_trap:GetAOERadius()
	local root_range = self:GetSpecialValueFor("root_range")
	return root_range
end

function imba_techies_stasis_trap:GetBehavior()
	local caster = self:GetCaster()

	-- #2 Talent: Stasis Traps can be placed within friendly creeps
	if caster:HasTalent("special_bonus_imba_techies_2") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
end

function imba_techies_stasis_trap:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()

		-- #2 Talent: Stasis Trap can be inserted within creeps
		if caster:HasTalent("special_bonus_imba_techies_2") and target:IsCreep() and caster:GetTeamNumber() == target:GetTeamNumber() then
			return UF_SUCCESS
		end

		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			return UF_FAIL_ENEMY
		end

		if target:IsHero() then
			return UF_FAIL_HERO
		end

		if target:IsBuilding() then
			return UF_FAIL_BUILDING
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_techies_stasis_trap:OnAbilityPhaseStart()

	local target = self:GetCursorTarget()

	if target then
		-- If it was on a target, place effect in it
		local particle_creep = "particles/hero/techies/techies_stasis_trap_plant_creep.vpcf"
		local particle_creep_fx = ParticleManager:CreateParticle(particle_creep, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(particle_creep_fx, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_creep_fx, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_creep_fx)

	-- If it was on a point in the ground, place effect
	else
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		-- Add cast particle
		local particle_cast = "particles/units/heroes/hero_techies/techies_stasis_trap_plant.vpcf"
		local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_cast_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_cast_fx, 1, target_point)
		ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	end

	return true
end

function imba_techies_stasis_trap:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
	local particle_creep = "particles/hero/techies/techies_stasis_trap_plant_creep.vpcf"
	local cast_response = {"techies_tech_settrap_01", "techies_tech_settrap_02", "techies_tech_settrap_03", "techies_tech_settrap_04", "techies_tech_settrap_06", "techies_tech_settrap_07", "techies_tech_settrap_08", "techies_tech_settrap_09", "techies_tech_settrap_10", "techies_tech_settrap_11"}
	local sound_cast = "Hero_Techies.StasisTrap.Plant"

	-- Roll for a cast response
	if RollPercentage(75) then
		EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Plant inside a creep (#2 Talent)
	if target then
		local modifier_stasis = target:AddNewModifier(target, ability, "modifier_imba_statis_trap", {})
		if modifier_stasis then
			modifier_stasis.owner = caster
		end

		Timers:CreateTimer(1, function()
			if target:IsAlive() then
				local particle_creep_fx = ParticleManager:CreateParticle(particle_creep, PATTACH_CUSTOMORIGIN_FOLLOW, target)
				ParticleManager:SetParticleControlEnt(particle_creep_fx, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle_creep_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle_creep_fx)

				return 1
			else

				return nil
			end
		end)

	else -- Plant on the ground
		-- Plant trap
		local trap = CreateUnitByName("npc_imba_techies_stasis_trap", target_point, true, caster, caster, caster:GetTeamNumber())
		local trap_ability = "imba_techies_stasis_trap_trigger"

		-- Set the mine's team to be the same as the caster
		local playerID = caster:GetPlayerID()
		trap:SetControllableByPlayer(playerID, true)

		-- Set the mine's ability to be the same level as the planting ability
		local trap_ability_handler = trap:FindAbilityByName(trap_ability)
		if trap_ability_handler then
			trap_ability_handler:SetLevel(ability:GetLevel())
		end

		-- Set the mine's owner to be the caster
		trap:SetOwner(caster)
	end
end



------------------------------
--      STATIS TRAP AI      --
------------------------------
imba_techies_stasis_trap_trigger = imba_techies_stasis_trap_trigger or class({})
LinkLuaModifier("modifier_imba_statis_trap", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_root", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_electrocharge", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_statis_trap_disarmed", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_stasis_trap_trigger:GetAbilityTextureName()
   return "techies_stasis_trap"
end

function imba_techies_stasis_trap_trigger:GetIntrinsicModifierName()
	return "modifier_imba_statis_trap"
end

-- Statis Trap thinker modifier
modifier_imba_statis_trap = modifier_imba_statis_trap or class({})


function modifier_imba_statis_trap:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.owner = self.caster:GetOwner()

		-- Ability specials
		self.activate_delay = self.ability:GetSpecialValueFor("activate_delay")
		self.trigger_range = self.ability:GetSpecialValueFor("trigger_range")
		self.root_range = self.ability:GetSpecialValueFor("root_range")
		self.root_duration = self.ability:GetSpecialValueFor("root_duration")
		self.tick_rate = self.ability:GetSpecialValueFor("tick_rate")
		self.flying_vision_duration = self.ability:GetSpecialValueFor("flying_vision_duration")

		-- Set variables
		self.active = false

		-- Wait for activation
		Timers:CreateTimer(self.activate_delay, function()

			-- Mark trap as activated
			self.active = true

			-- Start thinking
			self:StartIntervalThink(self.tick_rate)
		end)
	end
end

function modifier_imba_statis_trap:IsHidden() return true end
function modifier_imba_statis_trap:IsPurgable() return false end
function modifier_imba_statis_trap:IsDebuff() return false end

function modifier_imba_statis_trap:OnIntervalThink()
	if IsServer() then
		local caster = self.caster

		-- If the caster has the sign modifier, do nothing
		local modifier_sign = "modifier_imba_minefield_sign_detection"
		if caster:HasModifier(modifier_sign) then
			return nil
		end

		-- If the Stasis trap is dead, do nothing and destroy
		if not caster:IsAlive() then
			self:Destroy()
			return nil
		end

		-- Look for nearby enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  self.trigger_range,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										  FIND_ANY_ORDER,
										  false)

		if #enemies > 0 then
			self:_Explode()
		end
	end
end

function modifier_imba_statis_trap:_Explode()
	local caster = self.caster

	-- Springing the trap! Play root sound
	local sound_explosion = "Hero_Techies.StasisTrap.Stun"
	EmitSoundOn(sound_explosion, caster)

	-- Add explosion particle
	local particle_explode = "particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf"
	local particle_explode_fx = ParticleManager:CreateParticle(particle_explode, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explode_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(self.root_range, 1, 1))
	ParticleManager:SetParticleControl(particle_explode_fx, 3, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_explode_fx)

	-- Find all units in radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
								caster:GetAbsOrigin(),
								nil,
								self.root_range,
								DOTA_UNIT_TARGET_TEAM_ENEMY,
								DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
								DOTA_UNIT_TARGET_FLAG_NONE,
								FIND_ANY_ORDER,
								false)

	local modifier_root = "modifier_imba_statis_trap_root"
	local modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"
	local modifier_disarmed = "modifier_imba_statis_trap_disarmed"

	-- Root enemies nearby if not disarmed, and apply a electrocharge
	for _,enemy in pairs(enemies) do
		if not caster:HasModifier(modifier_disarmed) then
			enemy:AddNewModifier(caster, self.ability, modifier_root, {duration = self.root_duration})
		end

		-- If the enemy is not yet afflicted with electrocharge, add it. Otherwise, add a stack
		if not enemy:HasModifier(modifier_electrocharge) then
			enemy:AddNewModifier(caster, self.ability, modifier_electrocharge, {duration = self.root_duration})
		else
			RefreshElectroCharge(enemy)
		end
	end

	-- Find nearby Statis Traps and mark them as disarmed
	local mines = FindUnitsInRadius(caster:GetTeamNumber(),
									caster:GetAbsOrigin(),
									nil,
									self.root_range,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_OTHER,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)

	for _,mine in pairs(mines) do
		if mine:GetUnitName() == "npc_imba_techies_stasis_trap" and mine ~= caster then
			mine:AddNewModifier(caster, self.ability, modifier_disarmed, {})
		end
	end

	-- #4 Talent: Stasis Traps grants charges of Inflammable to Remote mines
	if self.owner and self.owner:HasTalent("special_bonus_imba_techies_4") then
		ApplyInflammableToRemoteMines(caster, self.root_range, mines)
	end

	-- Apply flying vision
	AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), self.root_range, self.flying_vision_duration, false)

	-- Kill trap and destroy modifier
	caster:ForceKill(false)
	self:Destroy()
end

function modifier_imba_statis_trap:CheckState()
	if IsServer() then

		-- Planted inside a creep
		if self.caster:IsCreep() then
			return nil
		end

		local state

		-- Trap is invisible since activation
		if self.active then
			state = {[MODIFIER_STATE_INVISIBLE] = true,
					 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
		else
			state = {[MODIFIER_STATE_INVISIBLE] = false,
					 [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
		end
		return state
	end
end


-- Root modifier
modifier_imba_statis_trap_root = modifier_imba_statis_trap_root or class({})

function modifier_imba_statis_trap_root:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}
	return state
end

function modifier_imba_statis_trap_root:IsHidden() return false end
function modifier_imba_statis_trap_root:IsPurgable() return true end
function modifier_imba_statis_trap_root:IsDebuff() return true end

function modifier_imba_statis_trap_root:GetStatusEffectName()
	return "particles/status_fx/status_effect_techies_stasis.vpcf"
end


-- Electrocharge modifier
modifier_imba_statis_trap_electrocharge = modifier_imba_statis_trap_electrocharge or class({})

function modifier_imba_statis_trap_electrocharge:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.owner = self.caster:GetOwner()
		self.teamnumber = self.caster:GetTeamNumber()
		self.parent_teamnumber = self.parent:GetTeamNumber()

		-- Ability specials
		self.base_magnetic_radius = self.ability:GetSpecialValueFor("base_magnetic_radius")
		self.base_magnetic_movespeed = self.ability:GetSpecialValueFor("base_magnetic_movespeed")
		self.magnetic_stack_radius = self.ability:GetSpecialValueFor("magnetic_stack_radius")
		self.magnetic_stack_movespeed = self.ability:GetSpecialValueFor("magnetic_stack_movespeed")        

		-- If this is not the Stasis Trap casting it, do nothing (hellblade/curseblade interactions)
		if self.caster:GetUnitName() ~= "npc_imba_techies_stasis_trap" then
			return nil
		end

		-- If the parent is in the same team as the caster, do nothing (don't pull mines towards it)         
		if self.teamnumber == self.parent_teamnumber then
			return nil
		end

		-- #3 Talent: Electrocharge mines pull radius increase
		if self.owner then            
			self.base_magnetic_radius = self.base_magnetic_radius + self.owner:FindTalentValue("special_bonus_imba_techies_3")
		end

		-- Start thinking
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_statis_trap_electrocharge:IsHidden() return false end
function modifier_imba_statis_trap_electrocharge:IsPurgable() return true end
function modifier_imba_statis_trap_electrocharge:IsDebuff() return true end

function modifier_imba_statis_trap_electrocharge:OnIntervalThink()
	if IsServer() then        

		-- Determine movespeed and radius for this tick
		local stacks = self:GetStackCount()
		local movespeed = self.base_magnetic_movespeed + self.magnetic_stack_movespeed * stacks
		local radius = self.base_magnetic_radius + self.magnetic_stack_radius * stacks


		local parentAbsOrigin = self.parent:GetAbsOrigin()

		-- Find all nearby mines
		local mines = FindUnitsInRadius(self.teamnumber,
										parentAbsOrigin,
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_OTHER,
										DOTA_UNIT_TARGET_FLAG_NONE,
										FIND_ANY_ORDER,
										false)

		-- Move each mine towards the parent of the debuff
		for _,mine in pairs(mines) do
			local mineUnitName = mine:GetUnitName()

			if mineUnitName == "npc_imba_techies_proximity_mine" or mineUnitName == "npc_imba_techies_proximity_mine_big_boom" or mineUnitName == "npc_imba_techies_stasis_trap" or mineUnitName == "npc_imba_techies_remote_mine" then
				local mineAbsOrigin = mine:GetAbsOrigin()

				-- Get mine's distance from enemy
				local distance = (parentAbsOrigin - mineAbsOrigin):Length2D()

				-- Minimum distance so game won't keep trying to put it closer in zero range
				if distance > 25 then
					-- Get mine's direction from enemy
					local direction = (parentAbsOrigin - mineAbsOrigin):Normalized()
					-- Set the mine's location closer to the enemy
					local mine_location = mineAbsOrigin + direction * movespeed * FrameTime()
					mine:SetAbsOrigin(mine_location)
				end
			end
		end
	end
end

function modifier_imba_statis_trap_electrocharge:GetTexture()
	return "techies_stasis_trap"
end


-- Disarmed Statis Traps modifier
modifier_imba_statis_trap_disarmed = modifier_imba_statis_trap_disarmed or class({})

function modifier_imba_statis_trap_disarmed:IsHidden() return false end
function modifier_imba_statis_trap_disarmed:IsPurgable() return false end
function modifier_imba_statis_trap_disarmed:IsDebuff() return false end









------------------------------
--        BLAST OFF!        --
------------------------------
imba_techies_blast_off = imba_techies_blast_off or class({})
LinkLuaModifier("modifier_imba_blast_off", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blast_off_movement", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blast_off_silence", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_blast_off:GetAbilityTextureName()
   return "techies_suicide"
end

function imba_techies_blast_off:IsHiddenWhenStolen()
	return false
end

function imba_techies_blast_off:GetAOERadius()
	local radius  = self:GetSpecialValueFor("radius")
	return radius
end

function imba_techies_blast_off:IsNetherWardStealable()
	return false
end

function imba_techies_blast_off:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local piggy_response = "Imba.LittlePiggyWhy"
	local sound_cast = "Hero_Techies.BlastOff.Cast"
	local modifier_blast = "modifier_imba_blast_off"

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- #8 Talent: Blast Off throws a little pig instead of you
	local pig
	local modifierParam = {target_point_x = target_point.x, target_point_y = target_point.y, target_point_z = target_point.z}
	if caster:HasTalent("special_bonus_imba_techies_8") then
		pig = CreateUnitByName("npc_imba_techies_blast_off_piggy", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())

		-- Set the pig to be on the player's team
		local playerID = caster:GetPlayerID()
		pig:SetControllableByPlayer(playerID, true)

		-- Set the pig to look the same way as the caster
		pig:SetForwardVector(caster:GetForwardVector())

		-- Roll a chance for meme sound, if applicable
		if USE_MEME_SOUNDS and RollPercentage(MEME_SOUNDS_CHANCE) then
			EmitSoundOn(piggy_response, caster)
		end

		-- Add the blast off modifier, initialize with target point
		pig:AddNewModifier(caster, ability, modifier_blast, modifierParam)

	else
		-- Add the blast off modifier, initialize with target point
		caster:AddNewModifier(caster, ability, modifier_blast, modifierParam)
	end
end


-- Blast off modifier
modifier_imba_blast_off = modifier_imba_blast_off or class({})

function modifier_imba_blast_off:OnCreated( keys )
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_movement = "modifier_imba_blast_off_movement"

		-- Ability specials
		self.max_jumps = self.ability:GetSpecialValueFor("max_jumps")
		self.jump_continue_delay = self.ability:GetSpecialValueFor("jump_continue_delay")
		self.jump_duration = self.ability:GetSpecialValueFor("jump_duration")

		-- Set the caster to jump freely unless otherwise issued
		self.jumps = 0

		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)

		local parentAbsOrigin = self.parent:GetAbsOrigin()
		self.direction = (self.target_point - parentAbsOrigin):Normalized()
		self.distance = (self.target_point - parentAbsOrigin):Length2D()

		local tick = self.jump_duration + self.jump_continue_delay

		-- Apply the first jump and initialize target point to it as well
		self.parent:AddNewModifier(self.caster, self.ability, self.modifier_movement, {duration = tick, target_point_x = keys.target_point_x, target_point_y = keys.target_point_y, target_point_z = keys.target_point_z })

		-- Start thinking
		self:StartIntervalThink(tick)
	end
end

function modifier_imba_blast_off:OnIntervalThink()
	-- Increment jump count
	self.jumps = self.jumps + 1

	-- If the caster is stunned, hexed, or silenced, destroy self
	if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:IsSilenced() then
		self:Destroy()
		return nil
	end

	-- If the caster reached max jumps, destroy self
	if self.jumps > self.max_jumps then
		self:Destroy()
		return nil
	end

	-- Find new jump position, using the same distance and direction
	self.target_point = self.target_point + self.direction * self.distance

	-- Apply another jump and initialize the new target point to it
	self.parent:AddNewModifier(self.caster, self.ability, self.modifier_movement, {duration = self.jump_duration + self.jump_continue_delay, target_point_x = self.target_point.x, target_point_y = self.target_point.y, target_point_z = self.target_point.z})
end

function modifier_imba_blast_off:IsHidden() return true end
function modifier_imba_blast_off:IsPurgable() return false end
function modifier_imba_blast_off:IsDebuff() return false end

function modifier_imba_blast_off:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}

	return decFuncs
end

function modifier_imba_blast_off:OnOrder(keys)
	if IsServer() then
		local order_type = keys.order_type
		local unit = keys.unit

		-- Only apply if the unit issuing the command is the caster
		if unit == self.parent then

			-- Apply for stop move, or attack commands
			local eligible_order_types = {DOTA_UNIT_ORDER_HOLD_POSITION,
										  DOTA_UNIT_ORDER_STOP,
										  DOTA_UNIT_ORDER_MOVE_TO_POSITION,
										  DOTA_UNIT_ORDER_MOVE_TO_TARGET,
										  DOTA_UNIT_ORDER_ATTACK_MOVE,
										  DOTA_UNIT_ORDER_ATTACK_TARGET}

			-- Find if the order was eligible for stopping further jumps
			for i = 1 , #eligible_order_types do
				if eligible_order_types[i] == order_type then
					self:Destroy()
					break
				end
			end
		end
	end
end

function modifier_imba_blast_off:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
				   [MODIFIER_STATE_DISARMED] = true}
	return state
end

function modifier_imba_blast_off:OnDestroy()
	if IsServer() then
		local modifier_movement_handler = self.parent:FindModifierByName(self.modifier_movement)
		if modifier_movement_handler then
			modifier_movement_handler.last_jump = true
		end

		-- If it was a pig, remove it after a small delay
		if self.parent:GetUnitName() == "npc_imba_techies_blast_off_piggy" then
			-- Avoid reference values from self after onDestroy
			local parent = self.parent

			Timers:CreateTimer(FrameTime(), function()
				parent:ForceKill(false)
			end)
		end
	end
end


-- Blast off motion controller modifier
modifier_imba_blast_off_movement = modifier_imba_blast_off_movement or class({})

function modifier_imba_blast_off_movement:OnCreated( keys )
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		local particle_trail = "particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf"

		-- Ability specials
		self.damage = self.ability:GetSpecialValueFor("damage")
		self.radius = self.ability:GetSpecialValueFor("radius")
		self.self_damage_pct = self.ability:GetSpecialValueFor("self_damage_pct")
		self.silence_duration = self.ability:GetSpecialValueFor("silence_duration")
		self.jump_duration = self.ability:GetSpecialValueFor("jump_duration")
		self.jump_max_height = self.ability:GetSpecialValueFor("jump_max_height")

		self.target_point = Vector(keys.target_point_x, keys.target_point_y, keys.target_point_z)

		local parentAbsOrigin = self.parent:GetAbsOrigin()
		-- Add trail particle
		local particle_trail_fx = ParticleManager:CreateParticle(self.particle_trail, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle_trail_fx, 0, parentAbsOrigin)
		ParticleManager:SetParticleControl(particle_trail_fx, 1, parentAbsOrigin)
		self:AddParticle(particle_trail_fx, false, false, -1, false, false)

		-- Calculate jump variables
		self.direction = (self.target_point - parentAbsOrigin):Normalized()
		self.distance = (self.target_point - parentAbsOrigin):Length2D()
		self.velocity = self.distance / self.jump_duration
		self.time_elapsed = 0
		self.current_height = 0

		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_imba_blast_off_movement:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Vertical motion
	self:VerticalMotion(self.parent, self.frametime)

	-- Horizontal motion
	self:HorizontalMotion(self.parent, self.frametime)
end

function modifier_imba_blast_off_movement:IsHidden() return true end
function modifier_imba_blast_off_movement:IsPurgable() return false end
function modifier_imba_blast_off_movement:IsDebuff() return false end
function modifier_imba_blast_off_movement:IgnoreTenacity() return true end
function modifier_imba_blast_off_movement:IsMotionController() return true end
function modifier_imba_blast_off_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_blast_off_movement:VerticalMotion(me, dt)
	if IsServer() then
		-- Calculate height as a parabula
		local t = self.time_elapsed / self.jump_duration
		self.current_height = self.current_height + FrameTime() * self.jump_max_height * (4-8*t)

		-- Set the new height
		self.parent:SetAbsOrigin(GetGroundPosition(self.parent:GetAbsOrigin(), self.parent) + Vector(0,0,self.current_height))

		-- Increase the time elapsed
		self.time_elapsed = self.time_elapsed + dt
	end
end

function modifier_imba_blast_off_movement:HorizontalMotion(me, dt)
	if IsServer() then

		-- Check if we're still jumping
		if self.time_elapsed < self.jump_duration then
			-- Move parent towards the target point
			local new_location = self.parent:GetAbsOrigin() + self.direction * self.velocity * dt
			self.parent:SetAbsOrigin(new_location)
		else
			self:BlastOffLanded()
		end
	end
end

function modifier_imba_blast_off_movement:BlastOffLanded()
	if IsServer() then
		if self.blast_off_finished then
			return nil
		end

		self.blast_off_finished = true

		-- Play explosion sound
		local sound_suicide = "Hero_Techies.Suicide"
		EmitSoundOn(sound_suicide, self.parent)

		-- Add explosion particle
		local particle_explosion = "particles/units/heroes/hero_techies/techies_blast_off.vpcf"
		local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(particle_explosion_fx, 0, self.parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

		-- Destroy trees around the landing point
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), self.radius, true)

		-- Find all nearby enemies
		local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(),
										  self.parent:GetAbsOrigin(),
										  nil,
										  self.radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

		local modifier_silence = "modifier_imba_blast_off_silence"

		local enemy_killed = false
		for _,enemy in pairs(enemies) do
			-- Deal magical damage to them
			local damageTable = {victim = enemy,
								 attacker = self.caster,
								 damage = self.damage,
								 damage_type = DAMAGE_TYPE_MAGICAL,
								 ability = self.ability
								 }

			ApplyDamage(damageTable)

			-- Add silence modifier to them
			enemy:AddNewModifier(self.caster, self.ability, modifier_silence, {duration = self.silence_duration})

			-- Check (and mark) if an enemy died from the blast
			Timers:CreateTimer(FrameTime(), function()
				if not enemy:IsAlive() then
					enemy_killed = true
				end
			end)
		end

		-- If no enemies were found, play miss response
		if #enemies == 0 and self.last_jump then
			-- Roll for rare response
			local sound
			if RollPercentage(15) then
				local rare_miss_response = {"techies_tech_suicidesquad_08", "techies_tech_failure_01"}
				sound = rare_miss_response[math.random(1, #rare_miss_response)]
			else
				local miss_response = {"techies_tech_suicidesquad_04", "techies_tech_suicidesquad_09", "techies_tech_suicidesquad_13"}
				sound = miss_response[math.random(1, #miss_response)]
			end

			EmitSoundOn(sound, self.caster)
		end

		Timers:CreateTimer(FrameTime()*2, function()
			-- If an enemy died, play kill response
			if enemy_killed then
				-- Roll for rare response
				local sound
				if RollPercentage(15) then
					local rare_kill_response = {"techies_tech_focuseddetonate_14"}
					sound = rare_kill_response[math.random(1, #rare_kill_response)]
				else
					local kill_response = {"techies_tech_suicidesquad_02", "techies_tech_suicidesquad_03", "techies_tech_suicidesquad_06", "techies_tech_suicidesquad_11", "techies_tech_suicidesquad_12"}
					sound = kill_response[math.random(1, #kill_response)]
				end
				EmitSoundOn(sound, self.caster)
			end
		end)


		-- Deal damage to the caster based on its max health
		local self_damage = self.parent:GetMaxHealth() * self.self_damage_pct * 0.01

		local damageTable = {victim = self.parent,
							 attacker = self.caster,
							 damage = self_damage,
							 damage_type = DAMAGE_TYPE_PURE,
							 ability = self.ability,
							 damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
							 }

		ApplyDamage(damageTable)

		--#5 Talent: Blast Off! jumps drop a Proximity Mine
		if self.caster:HasTalent("special_bonus_imba_techies_5") then
			local proximity_ability = "imba_techies_proximity_mine"
			-- Find Proximity Mine ability. Talent can't proc if the caster doesn't have Proximity Mines.
			local proximity_ability_handler = self.caster:FindAbilityByName(proximity_ability)
			if proximity_ability_handler and proximity_ability_handler:GetLevel() > 0 then
				PlantProximityMine(self.caster, proximity_ability_handler, self.parent:GetAbsOrigin())
			end
		end

		self:Destroy()
	end
end

function modifier_imba_blast_off_movement:OnDestroy()
	if IsServer() then
		self.parent:SetUnitOnClearGround()
	end
end

function modifier_imba_blast_off_movement:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
				   [MODIFIER_STATE_DISARMED] = true}
	return state
end


-- Blast Off Silence modifier
modifier_imba_blast_off_silence = modifier_imba_blast_off_silence or class({})

function modifier_imba_blast_off_silence:IsHidden() return false end
function modifier_imba_blast_off_silence:IsPurgable() return true end
function modifier_imba_blast_off_silence:IsDebuff() return true end

function modifier_imba_blast_off_silence:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end

function modifier_imba_blast_off_silence:GetEffectName()
	return "particles/generic_gameplay/generic_silence.vpcf"
end

function modifier_imba_blast_off_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end



------------------------------
--      REMOTE MINES        --
------------------------------
imba_techies_remote_mine = imba_techies_remote_mine or class({})

function imba_techies_remote_mine:GetAbilityTextureName()
   return "techies_remote_mines"
end

function imba_techies_remote_mine:IsHiddenWhenStolen()
	return false
end

function imba_techies_remote_mine:GetAssociatedSecondaryAbilities()
	return "imba_techies_focused_detonate"
end

function imba_techies_remote_mine:IsNetherWardStealable()
	return false
end

function imba_techies_remote_mine:OnUpgrade()
	local caster = self:GetCaster()
	local focused_ability = "imba_techies_focused_detonate"

	local focused_ability_handler = caster:FindAbilityByName(focused_ability)
	if focused_ability_handler then
		focused_ability_handler:SetLevel(1)
	end
end

function imba_techies_remote_mine:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self
	local scepter = caster:HasScepter()

	local radius = ability:GetSpecialValueFor("radius")
	local scepter_radius_bonus = ability:GetSpecialValueFor("scepter_radius_bonus")

	if scepter then
		radius = radius + scepter_radius_bonus
	end

	return radius
end

function imba_techies_remote_mine:OnAbilityPhaseStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_toss = "Hero_Techies.RemoteMine.Toss"
	local particle_plant = "particles/hero/techies/techies_remote_mine_plant.vpcf"

	-- Play toss sound
	EmitSoundOn(sound_toss, caster)

	-- Add particle effect
	local particle_plant_fx = ParticleManager:CreateParticle(particle_plant, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_plant_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_remote", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_plant_fx, 1, target_point)
	ParticleManager:SetParticleControl(particle_plant_fx, 4, target_point)
	ParticleManager:ReleaseParticleIndex(particle_plant_fx)

	return true
end

function imba_techies_remote_mine:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = {"techies_tech_remotemines_03", "techies_tech_remotemines_04", "techies_tech_remotemines_05", "techies_tech_remotemines_07", "techies_tech_remotemines_08", "techies_tech_remotemines_09", "techies_tech_remotemines_13", "techies_tech_remotemines_14", "techies_tech_remotemines_15", "techies_tech_remotemines_17", "techies_tech_remotemines_18", "techies_tech_remotemines_19", "techies_tech_remotemines_20", "techies_tech_remotemines_25", "techies_tech_remotemines_26", "techies_tech_remotemines_27", "techies_tech_remotemines_30", "techies_tech_remotemines_02", "techies_tech_remotemines_10", "techies_tech_remotemines_11", "techies_tech_remotemines_16", "techies_tech_remotemines_21", "techies_tech_remotemines_22", "techies_tech_remotemines_23", "techies_tech_remotemines_28", "techies_tech_remotemines_29"}
	local rare_cast_response = "techies_tech_remotemines_01"
	local sound_cast = "Hero_Techies.RemoteMine.Plant"
	local mine_ability = "imba_techies_remote_mine_pinpoint_detonation"

	-- Ability specials
	local mine_duration = ability:GetSpecialValueFor("mine_duration")

	-- Roll for rare cast response
	local sound
	if RollPercentage(1) then
		sound = rare_cast_response
	else
		sound = cast_response[math.random(1, #cast_response)]
	end
	EmitSoundOn(sound, caster)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Plant mine
	local mine = CreateUnitByName("npc_imba_techies_remote_mine", target_point, false, caster, caster, caster:GetTeamNumber())

	-- Set mine to be controllable by the player
	local playerID = caster:GetPlayerID()
	mine:SetControllableByPlayer(playerID, true)

	-- Set the mine's ability to be the same level as the planting ability
	local mine_ability_handler = mine:FindAbilityByName(mine_ability)
	if mine_ability_handler then
		mine_ability_handler:SetLevel(ability:GetLevel())
	end

	-- Set the mine's owner to be the caster
	mine:SetOwner(caster)

	-- Assign a kill modifier to it
	mine:AddNewModifier(caster, ability, "modifier_kill", {duration = mine_duration})
end


------------------------------
--    PINPOINT DETONATION   --
------------------------------
imba_techies_remote_mine_pinpoint_detonation = imba_techies_remote_mine_pinpoint_detonation or class({})
LinkLuaModifier("modifier_imba_remote_mine", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_remote_mine_inflammable", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_remote_mine_pinpoint_detonation:GetAbilityTextureName()
   return "techies_remote_mines_self_detonate"
end

function imba_techies_remote_mine_pinpoint_detonation:IsStealable()
	return false
end

function imba_techies_remote_mine_pinpoint_detonation:ProcsMagicStick()
	return false
end

function imba_techies_remote_mine_pinpoint_detonation:IsNetherWardStealable()
	return false
end

function imba_techies_remote_mine_pinpoint_detonation:GetIntrinsicModifierName()
	return "modifier_imba_remote_mine"
end

function imba_techies_remote_mine_pinpoint_detonation:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local owner = caster:GetOwner()
	local sound_activate = "Hero_Techies.RemoteMine.Activate"
	local sound_detonate = "Hero_Techies.RemoteMine.Detonate"
	local particle_explosion = "particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf"
	local modifier_inflammable = "modifier_imba_remote_mine_inflammable"
	local modifier_electrocharge = "modifier_imba_statis_trap_electrocharge"
	local scepter = owner:HasScepter()

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local radius = ability:GetSpecialValueFor("radius")
	local inflammable_duration = ability:GetSpecialValueFor("inflammable_duration")
	local inflammable_charge_radius = ability:GetSpecialValueFor("inflammable_charge_radius")
	local inflammable_charge_damage = ability:GetSpecialValueFor("inflammable_charge_damage")
	local scepter_damage_bonus = ability:GetSpecialValueFor("scepter_damage_bonus")
	local scepter_radius_bonus = ability:GetSpecialValueFor("scepter_radius_bonus")

	-- Play activation sound
	EmitSoundOn(sound_activate, caster)

	-- Roll a random time to wait
	local random_wait_time = math.random(1, 4)
	Timers:CreateTimer(FrameTime() * random_wait_time, function()

		-- Play detonation sound
		EmitSoundOn(sound_detonate, caster)

		-- Add detonation particles
		local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_explosion_fx, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(particle_explosion_fx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

		-- If the caster has scepter, increase the damage and radius
		if scepter then
			damage = damage + scepter_damage_bonus
			radius = radius + scepter_radius_bonus
		end

		-- Fetch stacks of Inflammable
		local stacks = 0
		local modifier_inflammable_handler = caster:FindModifierByName(modifier_inflammable)
		if modifier_inflammable_handler then
			stacks = modifier_inflammable_handler:GetStackCount()
		end

		-- Increase radius and damage by current Inflammable stacks
		damage = damage + inflammable_charge_radius * stacks
		radius = radius + inflammable_charge_damage * stacks

		-- Find enemies nearby
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
										  caster:GetAbsOrigin(),
										  nil,
										  radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

		for _,enemy in pairs(enemies) do

			-- Deal damage to enemies
			local damageTable = {victim = enemy,
								attacker = caster,
--								damage = damage * (1+(PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID()):GetSpellAmplification(false) * 0.01)),
								damage = damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = ability
								}
			 ApplyDamage(damageTable)
			RefreshElectroCharge(enemy)
		end

		-- Find remote mines in explosion range
		local mines = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										DOTA_UNIT_TARGET_OTHER,
										DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED,
										FIND_ANY_ORDER,
										false)

		for _,mine in pairs(mines) do
			if mine:GetUnitName() == "npc_imba_techies_remote_mine" then

				local modifier_inflammable_handler = mine:FindModifierByName(modifier_inflammable)
				if not modifier_inflammable_handler then
					-- If a mine doesn't inflammable yet, give it to it
					modifier_inflammable_handler = mine:AddNewModifier(caster, ability, modifier_inflammable, {duration = inflammable_duration})
				end

				-- Grant them a stack of Inflammable
				if modifier_inflammable_handler then
					modifier_inflammable_handler:IncrementStackCount()
					modifier_inflammable_handler:ForceRefresh()
				end
			end
		end

		-- Kill self
		caster:ForceKill(true)
	end)
end


modifier_imba_remote_mine = modifier_imba_remote_mine or class({})


function modifier_imba_remote_mine:OnCreated()
	local caster = self:GetCaster()
	local casterAbsOrigin = caster:GetAbsOrigin()
	local particle_mine = "particles/units/heroes/hero_techies/techies_remote_mine.vpcf"

	-- Play particle effect
	local particle_mine_fx = ParticleManager:CreateParticle(particle_mine, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_mine_fx, 0, casterAbsOrigin)
	ParticleManager:SetParticleControl(particle_mine_fx, 3, casterAbsOrigin)
	ParticleManager:ReleaseParticleIndex(particle_mine_fx)
end

function modifier_imba_remote_mine:IsHidden() return true end
function modifier_imba_remote_mine:IsPurgable() return false end
function modifier_imba_remote_mine:IsDebuff() return false end

function modifier_imba_remote_mine:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end


-- Remote Mines' Inflammable modifier
modifier_imba_remote_mine_inflammable = modifier_imba_remote_mine_inflammable or class({})

function modifier_imba_remote_mine_inflammable:OnCreated()
	-- Ability specials
	self.inflammable_max_charges = self:GetAbility():GetSpecialValueFor("inflammable_max_charges")
end

function modifier_imba_remote_mine_inflammable:GetTexture()
	return "techies_remote_mines_self_detonate"
end

function modifier_imba_remote_mine_inflammable:IsHidden() return false end
function modifier_imba_remote_mine_inflammable:IsPurgable() return false end
function modifier_imba_remote_mine_inflammable:IsDebuff() return false end

function modifier_imba_remote_mine_inflammable:OnStackCountChanged(old_count)
	local stacks = self:GetStackCount()

	-- Cannot exceed the maximum stacks
	if stacks > self.inflammable_max_charges then
		self:SetStackCount(self.inflammable_max_charges)
	end
end





------------------------------
--     FOCUSED DETONATE     --
------------------------------
imba_techies_focused_detonate = imba_techies_focused_detonate or class({})
LinkLuaModifier("modifier_imba_focused_detonate", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_focused_detonate:GetAbilityTextureName()
   return "techies_focused_detonate"
end

function imba_techies_focused_detonate:IsStealable()
	return false
end

function imba_techies_focused_detonate:IsHiddenWhenStolen()
	return false
end

function imba_techies_focused_detonate:IsNetherWardStealable()
	return false
end

function imba_techies_focused_detonate:GetAOERadius()
	local ability = self

	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_techies_focused_detonate:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"

	-- Ability specials
	local radius = ability:GetSpecialValueFor("radius")

	-- Find all mines in radius
	local remote_mines = FindUnitsInRadius(caster:GetTeamNumber(),
										   target_point,
										   nil,
										   radius,
										   DOTA_UNIT_TARGET_TEAM_FRIENDLY,
										   DOTA_UNIT_TARGET_OTHER,
										   DOTA_UNIT_TARGET_FLAG_NONE,
										   FIND_ANY_ORDER,
										   false)

	-- Iterate every mine every game tick
	for i = 1, #remote_mines do
		Timers:CreateTimer(FrameTime()*(i-1), function()

			-- Find their Pinpoint Detonate spell and force them to cast it
			local detonate_ability_handler = remote_mines[i]:FindAbilityByName(detonate_ability)
			if detonate_ability_handler then --detonate only if remote_mines has the ability
				detonate_ability_handler:OnSpellStart()
			end
		end)
	end
end

-- Modifier for casting Focused Detonate without facing cast direction
-- Modifier is added in the OrderFilter in imba.lua
modifier_imba_focused_detonate = modifier_imba_focused_detonate or class({})

function modifier_imba_focused_detonate:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_DISABLE_TURNING
	}
	return decFuncs
end

function modifier_imba_focused_detonate:IsHidden() return true end
function modifier_imba_focused_detonate:IsPurgable() return false end
function modifier_imba_focused_detonate:IsDebuff() return false end

function modifier_imba_focused_detonate:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_imba_focused_detonate:GetModifierDisableTurning()
	return 1
end

function modifier_imba_focused_detonate:IsHidden()
	return false
end

-- Do a stop order after finish casting to prevent turning to the destination point
function modifier_imba_focused_detonate:OnDestroy()
	if IsServer() then
		local stopOrder =
		{
			UnitIndex = self:GetCaster():entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
		ExecuteOrderFromTable( stopOrder )
	end
end


------------------------------
--      MINEFIELD SIGN      --
------------------------------
imba_techies_minefield_sign = imba_techies_minefield_sign or class({})
LinkLuaModifier("modifier_imba_minefield_sign_aura", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_minefield_sign_detection", "components/abilities/heroes/hero_techies.lua", LUA_MODIFIER_MOTION_NONE)

function imba_techies_minefield_sign:GetAbilityTextureName()
   return "techies_minefield_sign"
end

function imba_techies_minefield_sign:IsHiddenWhenStolen()
	return false
end

function imba_techies_minefield_sign:IsNetherWardStealable()
	return false
end

function imba_techies_minefield_sign:IsInnateAbility()
	return true
end

function imba_techies_minefield_sign:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")

	-- #6 Talent: Minefield radius increase
	radius = radius + caster:FindTalentValue("special_bonus_imba_techies_6")

	return radius
end

function imba_techies_minefield_sign:OnUpgrade()
	local ability = self

	if not ability:GetAutoCastState() then
		ability:ToggleAutoCast()
	end
end

function imba_techies_minefield_sign:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local sound_cast = "Hero_Techies.Sign"
	local modifier_sign = "modifier_imba_minefield_sign_aura"

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- If there is already a sign assigned to this ability, destroy it
	if self.assigned_sign then
		self.assigned_sign:Destroy()
	end

	-- Create a new sign
	local sign = CreateUnitByName("npc_imba_techies_minefield_sign", target_point, false, caster, caster, caster:GetTeamNumber())
	sign:AddRangeIndicator(caster, ability, "radius", nil, 255, 40, 40, true, false, false)

	-- Assign it to the ability
	self.assigned_sign = sign

	-- Assign the sign aura modifier to it
	sign:AddNewModifier(caster, ability, modifier_sign, {})
end


-- Sign aura modifier
modifier_imba_minefield_sign_aura = modifier_imba_minefield_sign_aura or class({})

function modifier_imba_minefield_sign_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_imba_minefield_sign_aura:IsHidden() return false end
function modifier_imba_minefield_sign_aura:IsPurgable() return false end
function modifier_imba_minefield_sign_aura:IsDebuff() return false end

function modifier_imba_minefield_sign_aura:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_NO_HEALTH_BAR] = true,
				   [MODIFIER_STATE_INVULNERABLE] = true,
				   [MODIFIER_STATE_UNSELECTABLE] = true}

	return state
end

function modifier_imba_minefield_sign_aura:GetAuraEntityReject(target)
	-- Only apply on mines
	local targetUnitName = target:GetUnitName()
	if targetUnitName == "npc_imba_techies_proximity_mine" or targetUnitName == "npc_imba_techies_proximity_mine_big_boom" or targetUnitName == "npc_imba_techies_stasis_trap" or targetUnitName == "npc_imba_techies_remote_mine" then
		return false
	end

	return true
end

function modifier_imba_minefield_sign_aura:GetAuraRadius()
	-- #6 Talent: Minefield radius increase
	local radius = self.radius + self.caster:FindTalentValue("special_bonus_imba_techies_6")

	return radius
end

function modifier_imba_minefield_sign_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_minefield_sign_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_minefield_sign_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_minefield_sign_aura:GetModifierAura()
	return "modifier_imba_minefield_sign_detection"
end

function modifier_imba_minefield_sign_aura:IsAura()
	if IsServer() then
		-- If the spell is toggled on, aura is emitted from the sign
		return self.ability:GetAutoCastState()
	end
end



-- Sign modifier given to nearby mines
modifier_imba_minefield_sign_detection = modifier_imba_minefield_sign_detection or class({})

function modifier_imba_minefield_sign_detection:CheckState()
	local state = {[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true}
	return state
end

function modifier_imba_minefield_sign_detection:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()

		-- If it is a Remote Mine, wait a game tick, check if the mine is still alive, and scan for nearby enemies
		Timers:CreateTimer(FrameTime(), function()

			if parent:GetUnitName() == "npc_imba_techies_remote_mine" and parent:IsAlive() then

				local detonate_ability = "imba_techies_remote_mine_pinpoint_detonation"
				local detonate_ability_handler = parent:FindAbilityByName(detonate_ability)
				if detonate_ability_handler then --detonate only if parent has the ability
					local radius = detonate_ability_handler:GetSpecialValueFor("radius")

					local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
														parent:GetAbsOrigin(),
														nil,
														radius,
														DOTA_UNIT_TARGET_TEAM_ENEMY,
														DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
														DOTA_UNIT_TARGET_FLAG_NONE,
														FIND_ANY_ORDER,
														false)
					if #enemies > 0 then
						detonate_ability_handler:OnSpellStart()
					end
				end
			end
		end)
	end
end
