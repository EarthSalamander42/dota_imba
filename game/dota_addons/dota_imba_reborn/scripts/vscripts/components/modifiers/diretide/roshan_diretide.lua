--------------------------------------------------
--				DIRETIDE Roshan AI
--------------------------------------------------
-- Author:	zimberzimber
-- Date:	30.8.2017

if imba_roshan_ai_diretide == nil then imba_roshan_ai_diretide = class({}) end
LinkLuaModifier("modifier_imba_roshan_ai_diretide", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_ai_beg", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_ai_eat", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_eaten_candy", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_acceleration", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_roshan_death_buff", "components/modifiers/diretide/roshan_diretide", LUA_MODIFIER_MOTION_NONE)

function imba_roshan_ai_diretide:GetIntrinsicModifierName()
	return "modifier_imba_roshan_ai_diretide" end

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

function modifier_imba_roshan_ai_diretide:GetModifierProvidesFOWVision()
--	if self:GetStackCount() == 3 then
--		return 0
--	else
		return 1
--	end
end
	
function modifier_imba_roshan_ai_diretide:GetActivityTranslationModifiers()
	if self:GetStackCount() == 3 then
		return "sugarrush"
	else return nil end
end

function modifier_imba_roshan_ai_diretide:DeclareFunctions()
	return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			 MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			 MODIFIER_EVENT_ON_ATTACK_LANDED,
			 MODIFIER_EVENT_ON_ATTACK_START,
			 MODIFIER_EVENT_ON_TAKEDAMAGE 			 }
end

function modifier_imba_roshan_ai_diretide:CheckState()
	local state = {}

	if self:GetStackCount() == 1 then
		state = {
			[MODIFIER_STATE_ATTACK_IMMUNE]	= true,
			[MODIFIER_STATE_INVULNERABLE]	= true,
			[MODIFIER_STATE_MAGIC_IMMUNE]	= true,
			[MODIFIER_STATE_CANNOT_MISS]	= true,
			[MODIFIER_STATE_ROOTED]			= true,
			[MODIFIER_STATE_DISARMED]		= true,
			[MODIFIER_STATE_SILENCED]		= false,
			[MODIFIER_STATE_MUTED]			= false,
			[MODIFIER_STATE_STUNNED]		= false,
			[MODIFIER_STATE_HEXED]			= false,
			[MODIFIER_STATE_INVISIBLE]		= false,
			[MODIFIER_STATE_UNSELECTABLE]	= true }
	elseif self:GetStackCount() == 2 then
		state = {
			[MODIFIER_STATE_ATTACK_IMMUNE]	= true,
			[MODIFIER_STATE_INVULNERABLE]	= true,
			[MODIFIER_STATE_MAGIC_IMMUNE]	= true,
			[MODIFIER_STATE_CANNOT_MISS]	= true,
			[MODIFIER_STATE_ROOTED]			= false,
			[MODIFIER_STATE_DISARMED]		= false,
			[MODIFIER_STATE_SILENCED]		= false,
			[MODIFIER_STATE_MUTED]			= false,
			[MODIFIER_STATE_STUNNED]		= false,
			[MODIFIER_STATE_HEXED]			= false,
			[MODIFIER_STATE_INVISIBLE]		= false, }
		if self.isEatingCandy then
			state[MODIFIER_STATE_UNSELECTABLE] = true
			state[MODIFIER_STATE_DISARMED] = true
			state[MODIFIER_STATE_ROOTED] = true
		elseif self.begState == 1 then
			state[MODIFIER_STATE_DISARMED] = true
			state[MODIFIER_STATE_ROOTED] = true
		end
	elseif self:GetStackCount() == 3 then
		if self.isTransitioning then
			state = { [MODIFIER_STATE_INVULNERABLE]		= true,
					  [MODIFIER_STATE_UNSELECTABLE]		= true,
					  [MODIFIER_STATE_DISARMED]			= true,
					  [MODIFIER_STATE_ATTACK_IMMUNE]	= true, }
			if self.atStartPoint then	  
				state[MODIFIER_STATE_ROOTED] = true
			end
		elseif self.returningToLeash then
			state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true -- Because fuck those Overused Dildos and their Astral Prisons
		end
	end

	-- Always phased, and hidden health bar
	state[MODIFIER_STATE_NO_UNIT_COLLISION]	= true	-- Obvious reasons
	state[MODIFIER_STATE_NO_HEALTH_BAR]		= true	-- Either not needed, or shown in the HUD
	return state
end

function modifier_imba_roshan_ai_diretide:OnCreated()
	if IsServer() then
		-- common keys
		local ability = self:GetAbility()
		self.roshan = self:GetParent()	-- Roshans entity for easier handling
		self.AItarget = nil				-- Targeted hero
		
		-- phase 2 keys
		self.targetTeam		= math.random(DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS)	-- Team Roshan is currently targeting
		self.begState		= 0														-- 0 = not begged | 1 = begging | anything else = has begged
		self.isEatingCandy	= false													-- Is Roshan eating a candy right now?
		self.begDistance	= ability:GetSpecialValueFor("beg_distance")			-- Distance from target to start begging
		
		-- phase 3 keys
		self.isTransitioning	= false												-- Is Roshan playing the transition animation?
		self.atStartPoint		= false												-- Has Roshan reached the start point?
		self.acquisition_range	= ability:GetSpecialValueFor("acquisition_range")	-- Acquisition range for phase 3
		self.leashPoint			= nil												-- Phase 3 arena mid point (defined in phase 3 thinking function)
		self.leashDistance		= ability:GetSpecialValueFor("leash_distance")		-- How far is Roshan allowed to walk away from the starting point
		self.leashHealPcnt		= ability:GetSpecialValueFor("leash_heal_pcnt")		-- Percent of max health Roshan will heal should he get leashed
		self.isDead				= false												-- Is Roshan 'dead'?
		self.deathPoint			= Vector(0,0,0)										-- Roshans last death point to which he will return upon respawn
		self.deathCounter		= 0													-- Times Roshan died
		self.refreshed_heroes	= false

		-- Sound delays to sync with animation
		self.candyBeg		= 0.5
		self.candyEat		= 0.15
		self.candySniff		= 3.33
		self.candyRoar		= 5.9
		self.pumpkinDrop	= 0.3
		self.candyGobble	= 0.5
		self.gobbleRoar		= 4.7
		self.deathRoar		= 1.9

		-- Aimation durations
		self.animBeg		= 5
		self.animGobble		= 6
		self.animDeath		= 10

		-- Ability handlers
		self.forceWave	= self.roshan:FindAbilityByName("roshan_deafening_blast")
		self.roshlings	= self.roshan:FindAbilityByName("imba_roshan_diretide_summon_roshlings")
		self.breath		= self.roshan:FindAbilityByName("creature_fire_breath")
		self.apocalypse	= self.roshan:FindAbilityByName("imba_roshan_diretide_apocalypse")
		self.fireBall	= self.roshan:FindAbilityByName("imba_roshan_diretide_fireball")
		self.toss		= self.roshan:FindAbilityByName("tiny_toss")
		
		-- Passive effect KVs
		self.bashChance = ability:GetSpecialValueFor("bash_chance") * 0.01
		self.bashDamage = ability:GetSpecialValueFor("bash_damage")
		self.bashDistance = ability:GetSpecialValueFor("bash_distance")
		self.bashDuration = ability:GetSpecialValueFor("bash_duration")
		
		-- Create a dummy for global vision
		AddFOWViewer(self.roshan:GetTeamNumber(), Vector(0,0,0), 250000, 999999, false)

		-- Turn on brain
		self.targetTeam = DOTA_TEAM_GOODGUYS
		self:SetStackCount(1)
	end
end

function modifier_imba_roshan_ai_diretide:OnStackCountChanged(stacks)
	if IsServer() then
		-- Get new stacks, and start thinking if its 2 or 3, or become idle if its 1 or anything else
		local stacks = self:GetStackCount()
		if stacks < 1 or stacks > 3 then
			stacks = 1
		end
		self:StartPhase(stacks)
	end
end

function modifier_imba_roshan_ai_diretide:OnIntervalThink()
local stacks = self:GetStackCount()
	
	if self.roshan:IsAlive() then
		-- When back from the dead, respawns Rosh at his death point
		if self.isDead then
			self.isDead = false
		end
		
		if stacks == 2 and not self.isEatingCandy then
			if self.targetTeam ~= DOTA_TEAM_GOODGUYS and self.targetTeam ~= DOTA_TEAM_BADGUYS then
				self.targetTeam = math.random(DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS)
			end
			self:ThinkPhase2(self.roshan)
			
		elseif stacks == 3 then
			self:ThinkPhase3(self.roshan)
		end
	else
		-- Spawn death particle, start the respawn timer, index death point
		if not self.isDead then
			self.deathPoint = self.roshan:GetAbsOrigin()
			self.isDead = true
			self.deathCounter = self.deathCounter + 1
			Diretide.DIRETIDE_REINCARNATING = true

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
				if self.isDead then
					self.roshan:RespawnUnit()
					self.roshan:CreatureLevelUp(1)
					Diretide.nCOUNTDOWNTIMER = Diretide.nCOUNTDOWNTIMER + 30.0
					self.refreshed_heroes = false

					if self.forceWave	then self.forceWave:EndCooldown()	end
					if self.roshlings	then self.roshlings:EndCooldown()	end
					if self.breath		then self.breath:EndCooldown()		end
					if self.apocalypse	then self.apocalypse:EndCooldown()	end
					if self.fireBall	then self.fireBall:EndCooldown()	end
					if self.toss		then self.toss:EndCooldown()		end
					
					local deathMod = self.roshan:FindModifierByName("modifier_imba_roshan_death_buff")
					if not deathMod then
						deathMod = self.roshan:AddNewModifier(self.roshan, self:GetAbility(), "modifier_imba_roshan_death_buff", {})
					end
					
					if deathMod then
						deathMod:SetStackCount(self.deathCounter)
					else
						print("ERROR - DEATH COUNTING MODIFIER MISSING AND FAILED TO APPLY TO ROSHAN")
					end

					Diretide.DIRETIDE_REINCARNATING = false
				end
			end)
		end
	end
end

function modifier_imba_roshan_ai_diretide:StartPhase(phase)
	-- Reset values
	self.begState = 0
	self.AItarget = nil
	self.targetTeam = 0
	self.isEatingCandy = false
	self.isTransitioning = false
	self.atStartPoint = false
	self.wait = 0
	self.leashPoint = nil
	self.deathPoint = self.roshan:GetAbsOrigin()
	self.deathCounter = 0

	if self.isDead then
		self.isDead = false
		self.roshan:RespawnUnit()
	end

	-- Reset behavior
	self.roshan:SetAcquisitionRange(-1000)
	self.roshan:SetForceAttackTarget(nil)
	self.roshan:Interrupt()

	self.roshan:SetHealth(self.roshan:GetMaxHealth())

	-- Destroy candy eaten count
	local candyMod = self.roshan:FindModifierByName("modifier_imba_roshan_eaten_candy")
	if candyMod then candyMod:Destroy() end

	-- Destroy all fury swipe modifiers
	local units = FindUnitsInRadius(self.roshan:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		local swipesModifier = unit:FindModifierByName("modifier_imba_roshan_fury_swipes")
		if swipesModifier then swipesModifier:Destroy() end
	end
	
	-- Destroy acceleration modifier
	local accelerationMod = self.roshan:FindModifierByName("modifier_imba_roshan_acceleration")
	if accelerationMod then accelerationMod:Destroy() end
	
	if phase == 1 then			-- Halts thinking, and become unrespawnable
		self.roshan:SetUnitCanRespawn(false)
		self:StartIntervalThink(-1)
	else						-- Starts thinking, and become respawnable
		self.roshan:SetUnitCanRespawn(true)
		if phase == 2 then
			EmitGlobalSound("diretide_eventstart_Stinger")
			self.roshan:AddNewModifier(self.roshan, self:GetAbility(), "modifier_imba_roshan_eaten_candy", {})

			Timers:CreateTimer(5.8, function() -- Timer so music ends first
				self:StartIntervalThink(0.1)
			end)
		elseif phase == 3 then
			EmitGlobalSound("diretide_sugarrush_Stinger")
			self.isTransitioning = true
			self:StartIntervalThink(0.1)

			UpdateRoshanBar(self.roshan, FrameTime() * 2)
		end
	end
end

--	PHASE II
function modifier_imba_roshan_ai_diretide:ThinkPhase2(roshan)
	if not self.AItarget then		-- If no target
		local heroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, hero in ipairs(heroes) do
			if hero:GetTeamNumber() == self.targetTeam then
				if hero:IsAlive() then
					self.AItarget = hero
					self.roshan:SetForceAttackTarget(hero)
					roshan:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_acceleration", {})
					EmitSoundOnClient("diretide_select_target_Stinger", hero:GetPlayerOwner())
					CustomGameEventManager:Send_ServerToAllClients("roshan_target", {target = hero:GetUnitName(), team_target = hero:GetTeamNumber()})
					break
				end
			end
		end
	else
		if self.AItarget and self.AItarget:IsAlive() then 
			if not self.roshan:IsAttackingEntity(self.AItarget) then
				self.roshan:SetForceAttackTarget(self.AItarget)
			end
		else
			self:ChangeTarget(self.roshan)
		end

		if self.begState == 0 then -- If haven't begged
			if CalcDistanceBetweenEntityOBB(roshan, self.AItarget) <= self.begDistance then
				self.begState = 1
				roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai_beg", {duration = self.animBeg})

				-- sound
				Timers:CreateTimer(self.candyBeg, function()
					roshan:EmitSound("Diretide.RoshanBeg")
				end)
			end
		elseif self.begState == 1 then

		else -- If has begged

		end
	end
end

function modifier_imba_roshan_ai_diretide:Candy(roshan)
	self.isEatingCandy = true
	roshan:SetForceAttackTarget(nil)
	roshan:Interrupt()
	
	local begMod = roshan:FindModifierByName("modifier_imba_roshan_ai_beg")
	if begMod then begMod:DestroyNoAggro() end

	-- Timer because if an animation modifying modifier gets removed and another gets added at the same moment, the new animation will not apply
	Timers:CreateTimer(FrameTime(), function()
		roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai_eat", {duration = 7})
		Diretide:Announcer("Diretide.Announcer.Roshan.Fed")
		print("ROSHAN ATE CANDY")

		-- Sounds
		Timers:CreateTimer(self.candyEat, function()
			roshan:EmitSound("Diretide.RoshanEatCandy")
		end)
		
		Timers:CreateTimer(self.candySniff, function()
			roshan:EmitSound("Diretide.RoshanSniff")
		end)
		
		Timers:CreateTimer(self.candyRoar, function()
			roshan:EmitSound("Diretide.RoshanRoar")
		end)
	end)

	local candyMod = roshan:FindModifierByName("modifier_imba_roshan_eaten_candy")
	if not candyMod then
		candyMod = roshan:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_eaten_candy", {})
	end
	
	candyMod:IncrementStackCount()
end

function modifier_imba_roshan_ai_diretide:ChangeTarget(roshan)
	self.AItarget = nil
	self.begState = 0
	self.isEatingCandy = false
	
	roshan:SetForceAttackTarget(nil)
	roshan:Interrupt()

	-- Destroy all fury swipe modifiers
	local units = FindUnitsInRadius(roshan:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		local swipesModifier = unit:FindModifierByName("modifier_imba_roshan_fury_swipes")
		if swipesModifier then swipesModifier:Destroy() end
	end
	
	-- Destroy acceleration modifier
	local accelerationMod = roshan:FindModifierByName("modifier_imba_roshan_acceleration")
	if accelerationMod then accelerationMod:Destroy() end
	
	local begMod = roshan:FindModifierByName("modifier_imba_roshan_ai_beg")
	if begMod then begMod:DestroyNoAggro() end
	
	if self.targetTeam == DOTA_TEAM_GOODGUYS then
		self.targetTeam = DOTA_TEAM_BADGUYS
		print("ROSHAN TARGET DIRE")
		Diretide:Announcer("diretide", "roshan_target_bad")		
	else
		print("ROSHAN TARGET RADIANT")
		Diretide:Announcer("diretide", "roshan_target_good")
		self.targetTeam = DOTA_TEAM_GOODGUYS
	end
end

--	PHASE III
function modifier_imba_roshan_ai_diretide:ThinkPhase3(roshan)

	-- Don't think while being stunned, hexed, or casting spells
	if roshan:IsStunned() or roshan:IsHexed() or roshan:IsChanneling() or roshan:GetCurrentActiveAbility() then return end

	-- Wait. No reason to decrement negative values
	if self.wait < 0 then
		return
	elseif self.wait > 0 then
		self.wait = self.wait - 1
		return
	end

	if not self.leashPoint then
		self.leashPoint = Entities:FindByName(nil, "good_healer_7"):GetAbsOrigin()		-- Pick arena based on phase 2 winner
	end

	-- Transitioning from Phase 2 to 3
	if self.isTransitioning then
		if self.atStartPoint then return end
		
		local distanceFromLeash = (roshan:GetAbsOrigin() - self.leashPoint):Length2D()
		if distanceFromLeash > 100 then
			roshan:SetForceAttackTarget(nil)
			roshan:MoveToPosition(self.leashPoint)

			if distanceFromLeash < 250 then
				Entities:FindByName(nil, "good_healer_7"):ForceKill(false)
			end
		else
			self.atStartPoint = true
			EmitSoundOnLocationWithCaster(roshan:GetAbsOrigin(), "RoshanDT.", roshan)
			
			roshan:SetForceAttackTarget(nil)
			roshan:Interrupt()
			roshan:StartGesture(ACT_TRANSITION)
			
			Timers:CreateTimer(self.pumpkinDrop, function()
				roshan:EmitSound("Diretide.RoshanBucketDrop")
			end)
			
			Timers:CreateTimer(self.candyGobble, function()
				roshan:EmitSound("Diretide.RoshanGobble")
			end)
			
			Timers:CreateTimer(self.gobbleRoar, function()
				roshan:EmitSound("Diretide.RoshanRoar2")
			end)
		
			Timers:CreateTimer(self.animGobble, function()
				self.atStartPoint = false
				self.isTransitioning = false
				roshan:RemoveGesture(ACT_TRANSITION)
				roshan:SetAcquisitionRange(self.acquisition_range)
				Diretide:EndRoshanCamera()
			end)
		end
	
		return
	end
	
	if Diretide.COUNT_DOWN and Diretide.COUNT_DOWN == false then
		local heroDetector = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if #heroDetector > 0 then
--			EnableCountdown(true)
		else
			self.wait = 5
			return
		end
	end
	
	-- Check if Roshan too far away from the leashing point
	local distanceFromLeash = (roshan:GetAbsOrigin() - self.leashPoint):Length2D()
	if not self.returningToLeash and distanceFromLeash >= self.leashDistance then
		self.returningToLeash = true
		roshan:SetHealth(roshan:GetHealth() + roshan:GetMaxHealth() * (self.leashHealPcnt * 0.01)) -- To bypass shit like AAs ult or Malediction healing reduction
	elseif self.returningToLeash and distanceFromLeash < 100 then
		roshan:Interrupt()
		self.returningToLeash = false
	end
	
	-- Return to the leashing point if he should
	if self.returningToLeash then
		roshan:SetForceAttackTarget(nil)
		roshan:MoveToPosition(self.leashPoint)
		 -- Destroy trees for dramatic effect because he has flying movement while being leashed
		GridNav:DestroyTreesAroundPoint(roshan:GetAbsOrigin(), 150, false)
		return
	end

	if self.refreshed_heroes == false then
		if roshan:GetHealthPercent() <= 50 then
			self.refreshed_heroes = true
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				for i=0, 23, 1 do  --The maximum number of abilities a unit can have is currently 16.
					local current_ability = hero:GetAbilityByIndex(i)
					if current_ability ~= nil then
						current_ability:EndCooldown()
					end
				end

				for i=0, 8, 1 do
					local current_item = hero:GetItemInSlot(i)
					if current_item ~= nil then
						if current_item:GetName() ~= "item_refresher_datadriven" then  --Refresher Orb does not refresh itself.
							current_item:EndCooldown()
						end
					end
				end

				ParticleManager:SetParticleControlEnt(ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero), 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
			end
			roshan:EmitSound("DOTA_Item.Refresher.Activate")
		end
	end

	local ability_count = roshan:GetAbilityCount()
	for ability_index = 0, ability_count - 1 do
		local ability = roshan:GetAbilityByIndex( ability_index ) 
		if ability and ability:IsInAbilityPhase() then
--			print("Cast Time:", ability:GetCastPoint())
			if not roshan:HasModifier("modifier_black_king_bar_immune") then
				roshan:EmitSound("DOTA_Item.BlackKingBar.Activate")
			else
				roshan:RemoveModifierByName("modifier_black_king_bar_immune")
			end
			roshan:AddNewModifier(roshan, self.ability, "modifier_black_king_bar_immune", {duration=0.2})
		end
	end
	
	-- Don't attempt casting spells if Silenced
	if not roshan:IsSilenced() then
		-- If can summon Roshlings, summon them and keep thinking
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
			local radius = self.forceWave:GetSpecialValueFor("travel_distance")

			local nearbyHeroes = FindUnitsInRadius(roshan:GetTeamNumber(), roshan:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if #nearbyHeroes >= 1 then
				roshan:CastAbilityNoTarget(self.forceWave, 1)
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

		-- Only apply if the unit taking damage is the caster
		if unit == self.roshan then
			-- If the damage came from ourselves (e.g. Rot, Double Edge), do nothing
			if attacker == unit then
				return nil
			end

			if Diretide.COUNT_DOWN == false then
				Diretide.COUNT_DOWN = true
				print("PHASE 3")
				Diretide:Announcer("diretide", "phase_3")
			end
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
			-- Instantly kill attacking illusions
			if attacker:IsIllusion() then attacker:ForceKill(true) end
			
		elseif roshan == attacker then
			
			-- Emit hit sound
			target:EmitSound("Roshan.Attack")
			target:EmitSound("Roshan.Attack.Post")

			-- Deal fury swipes increased damage
			local furySwipesModifier = target:FindModifierByName("modifier_imba_roshan_fury_swipes")
			if furySwipesModifier then
				local damageTable = { victim = target,attacker = roshan, damage_type = DAMAGE_TYPE_PURE, -- armor 2 stronk
									  damage = furySwipesModifier:GetStackCount() * self.furyswipeDamage,	}
				
				-- Increase fury swipe damage based on times Roshan died
				if self:GetStackCount() == 3 then
					local deathMod = roshan:FindModifierByName("modifier_imba_roshan_death_buff")
					if deathMod then
						damageTable.damage = damageTable.damage + deathMod:GetStackCount() * self.furyswipeIncreasePerDeath
					end
				end
				
				ApplyDamage(damageTable)
				furySwipesModifier:IncrementStackCount()
			else
				-- Does not wear off on phase 2
				if self:GetStackCount() == 2 then
					furySwipesModifier = target:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_fury_swipes", {duration = math.huge})
					if furySwipesModifier then furySwipesModifier:SetStackCount(1) end
					
				elseif self:GetStackCount() == 3 then
					furySwipesModifier = target:AddNewModifier(roshan, self:GetAbility(), "modifier_imba_roshan_fury_swipes", {duration = self.furyswipeDuration})
					if furySwipesModifier then furySwipesModifier:SetStackCount(1) end
				end
			end

			-- Bash only in phase 3
			if self:GetStackCount() == 3 then
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
end

--	PREATTACK SOUND
function modifier_imba_roshan_ai_diretide:OnAttackStart(keys)
	if IsServer() then
		local roshan = self:GetParent()
		if roshan == keys.attacker then
			roshan:EmitSound("Roshan.PreAttack")
			roshan:EmitSound("Roshan.Grunt")
		end
	end
end

---------- Roshans Fury Swipes modifier
if modifier_imba_roshan_fury_swipes == nil then modifier_imba_roshan_fury_swipes = class({}) end
function modifier_imba_roshan_fury_swipes:IsPurgeException() return false end
function modifier_imba_roshan_fury_swipes:IsPurgable() return false end
function modifier_imba_roshan_fury_swipes:IsHidden() return false end
function modifier_imba_roshan_fury_swipes:IsDebuff() return true end

function modifier_imba_roshan_fury_swipes:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf" end

function modifier_imba_roshan_fury_swipes:GetTexture()
	return "roshan_bash" end

function modifier_imba_roshan_fury_swipes:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

---------- Roshans acceleration modifier
if modifier_imba_roshan_acceleration == nil then modifier_imba_roshan_acceleration = class({}) end
function modifier_imba_roshan_acceleration:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_acceleration:IsPurgeException() return false end
function modifier_imba_roshan_acceleration:IsPurgable() return false end
function modifier_imba_roshan_acceleration:IsDebuff() return false end
function modifier_imba_roshan_acceleration:IsHidden() return true end

function modifier_imba_roshan_acceleration:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end

function modifier_imba_roshan_acceleration:OnCreated()
	local ability = self:GetAbility()
	self.speedIncrease = ability:GetSpecialValueFor("speedup_increase")
	self.asIncrease	= ability:GetSpecialValueFor("speedup_as_increase")
	
	if IsServer() then
		self:StartIntervalThink(ability:GetSpecialValueFor("speedup_interval"))
	end
end

function modifier_imba_roshan_acceleration:OnIntervalThink()
	self:IncrementStackCount() end

function modifier_imba_roshan_acceleration:GetModifierMoveSpeedBonus_Constant()
	return self.speedIncrease * self:GetStackCount() end

function modifier_imba_roshan_acceleration:GetModifierAttackSpeedBonus_Constant()
	return self.asIncrease * self:GetStackCount() end

---------- Roshans death buff
if modifier_imba_roshan_death_buff == nil then modifier_imba_roshan_death_buff = class({}) end
function modifier_imba_roshan_death_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_death_buff:IsPurgeException() return false end
function modifier_imba_roshan_death_buff:IsPurgable() return false end
function modifier_imba_roshan_death_buff:IsHidden() return true end
function modifier_imba_roshan_death_buff:IsDebuff() return false end

function modifier_imba_roshan_death_buff:OnCreated()
local ability = self:GetAbility()

	self.bonusHealth = ability:GetSpecialValueFor("health_per_death")
	self.bonusSpellAmp = ability:GetSpecialValueFor("spellamp_per_death")
	self.bonusDamage = ability:GetSpecialValueFor("damage_per_death")
	self.bonusAttackSpeed = ability:GetSpecialValueFor("attackspeed_per_death")
	self.bonusArmor = ability:GetSpecialValueFor("armor_per_death")
	self.bonusResist = ability:GetSpecialValueFor("resist_per_death")
	self.bonusTenacity = ability:GetSpecialValueFor("tenacity_per_death")
end

function modifier_imba_roshan_death_buff:DeclareFunctions()
	return { MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			 MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
			 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			 MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			 MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING }
end

function modifier_imba_roshan_death_buff:GetModifierExtraHealthBonus()
	return self.bonusHealth * self:GetStackCount() end

function modifier_imba_roshan_death_buff:GetModifierSpellAmplify_Percentage()
	return self.bonusSpellAmp * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonusAttackSpeed * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierPhysicalArmorBonus()
	return self.bonusArmor * self:GetStackCount() end
	
function modifier_imba_roshan_death_buff:GetModifierMagicalResistanceBonus()
	return self.bonusResist * self:GetStackCount() end

function modifier_imba_roshan_death_buff:GetModifierStatusResistanceStacking()
	return self.bonusTenacity * self:GetStackCount() end

---------- Modifier for handling begging
if modifier_imba_roshan_ai_beg == nil then modifier_imba_roshan_ai_beg = class({}) end
function modifier_imba_roshan_ai_beg:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_beg:IsPurgeException() return false end
function modifier_imba_roshan_ai_beg:IsPurgable() return false end
function modifier_imba_roshan_ai_beg:IsDebuff() return false end
function modifier_imba_roshan_ai_beg:IsHidden() return true end

function modifier_imba_roshan_ai_beg:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end
	
function modifier_imba_roshan_ai_beg:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_roshan_ai_beg:OnDestroy()
	if IsServer() then
		if not self.noAggro then	-- Go ape shit if the modifier expired on its own (not by candy-ing Roshan or through 'ChangeTarget)
			local roshan = self:GetParent()
			local AImod = roshan:FindModifierByName("modifier_imba_roshan_ai_diretide")
			if AImod then
				AImod.begState = 2
			end
		end
	end
end

function modifier_imba_roshan_ai_beg:DestroyNoAggro()
	self.noAggro = true
	self:Destroy()
end

function modifier_imba_roshan_ai_beg:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			 MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,}
end

function modifier_imba_roshan_ai_beg:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5 end

function modifier_imba_roshan_ai_beg:GetOverrideAnimationWeight()
	return 100 end

---------- Modifier for when eating a candy
if modifier_imba_roshan_ai_eat == nil then modifier_imba_roshan_ai_eat = class({}) end
function modifier_imba_roshan_ai_eat:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai_eat:IsPurgeException() return false end
function modifier_imba_roshan_ai_eat:IsPurgable() return false end
function modifier_imba_roshan_ai_eat:IsDebuff() return false end
function modifier_imba_roshan_ai_eat:IsHidden() return true end

function modifier_imba_roshan_ai_eat:GetEffectName()
	return "particles/hw_fx/candy_fed.vpcf"
end

function modifier_imba_roshan_ai_eat:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_roshan_ai_eat:OnDestroy()
	if IsServer() then
		local roshan = self:GetParent()
		local AImod = roshan:FindModifierByName("modifier_imba_roshan_ai_diretide")
		
		if AImod then
			AImod:ChangeTarget(roshan)
		end
	end
end

function modifier_imba_roshan_ai_eat:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
			 MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT,}
end

function modifier_imba_roshan_ai_eat:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6 end

function modifier_imba_roshan_ai_eat:GetOverrideAnimationWeight()
	return 1000 end

---------- Candy modifier
if modifier_imba_roshan_eaten_candy == nil then modifier_imba_roshan_eaten_candy = class({}) end
function modifier_imba_roshan_eaten_candy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_eaten_candy:IsPurgeException() return false end
function modifier_imba_roshan_eaten_candy:IsPurgable() return false end
function modifier_imba_roshan_eaten_candy:IsDebuff() return false end
function modifier_imba_roshan_eaten_candy:IsHidden() return false end

function modifier_imba_roshan_eaten_candy:GetTexture()
	return "item_halloween_candy_corn" end

function modifier_imba_roshan_eaten_candy:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_MAX,
			 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			 MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, }
end

function modifier_imba_roshan_eaten_candy:OnCreated()
	local ability = self:GetAbility()
	if not ability then
		print("ERROR - NO ABILITY FOR CANDY MODIFIER!")
		self:Destroy()
		return
	end
	
	self.speedPerCandy = ability:GetSpecialValueFor("speed_per_candy")
	self.damagePerCandy = ability:GetSpecialValueFor("damage_per_candy")
end

function modifier_imba_roshan_eaten_candy:GetModifierPreAttack_BonusDamage()
	return self.speedPerCandy * self:GetStackCount() end

function modifier_imba_roshan_eaten_candy:GetModifierMoveSpeedBonus_Constant()
	return self.damagePerCandy * self:GetStackCount() end

function modifier_imba_roshan_eaten_candy:GetModifierMoveSpeed_Max()
	return 99999 end

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
			local units = FindUnitsInRadius(roshan:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
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

--------------------------------------
--			Wave of Force			--
--------------------------------------
if imba_roshan_diretide_force_wave == nil then imba_roshan_diretide_force_wave = class({}) end

function imba_roshan_diretide_force_wave:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET end

function imba_roshan_diretide_force_wave:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_2 end

function imba_roshan_diretide_force_wave:OnSpellStart()	-- Parameters
	local roshan = self:GetCaster()
	local castPoint = roshan:GetAbsOrigin()
	local waveDistance = self:GetSpecialValueFor("radius")
	local waveRadius = 200
	local waveSpeed = self:GetSpecialValueFor("speed")
	local waves = 8
	local angleStep = 360 / waves
	local hitUnits = {}

	roshan:EmitSound("RoshanDT.WaveOfForce.Cast")

	print(waveSpeed)
	print(angleStep)
	
	-- Base projectile information
	local waveProjectile = {
		Ability				= self,
		EffectName			= "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf",
		vSpawnOrigin		= castPoint + Vector(0, 0, 50),
		fDistance			= waveDistance,
		fStartRadius		= waveRadius,
		fEndRadius			= waveRadius,
		Source				= roshan,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit		= false,
		vVelocity			= roshan:GetForwardVector() * waveSpeed,
		bProvidesVision		= false,
		iVisionRadius		= 0,
		iVisionTeamNumber	= roshan:GetTeamNumber(),
	}
	
	for i = 1, waves do
		waveProjectile.vVelocity = roshan:GetForwardVector() + angleStep
		waveProjectile.vVelocity.z = 0	-- So it doesn't move upwards
		ProjectileManager:CreateLinearProjectile(waveProjectile)
	end
end

function imba_roshan_diretide_force_wave:OnProjectileHit(unit, unitPos)
	print("Target hit!")
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