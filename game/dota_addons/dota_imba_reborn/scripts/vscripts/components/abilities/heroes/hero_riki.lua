-- Editors:
--     zimberzimber, 19.02.2017

-- Attempt to implement A*-algorithm
-- https://github.com/lattejed/a-star-lua

local LinkedModifiers = {}
---------------------------------------------------------------------
-------------------------	Smoke Screen	-------------------------
---------------------------------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_smoke_screen_debuff_miss"] = LUA_MODIFIER_MOTION_NONE,			-- Silence, miss, turn rate slow, slow
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_smoke_screen_handler"] = LUA_MODIFIER_MOTION_NONE,			-- Aura that applies the debuff
	["modifier_imba_smoke_screen_vision"] = LUA_MODIFIER_MOTION_NONE,	-- Reduces vision in comparison to smoke centre
	["modifier_imba_smoke_screen_invi"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_smoke_screen_invi_indicator"] = LUA_MODIFIER_MOTION_NONE,
})
imba_riki_smoke_screen = imba_riki_smoke_screen or class({})

function imba_riki_smoke_screen:GetAbilityTextureName()
	return "riki_smoke_screen"
end

function imba_riki_smoke_screen:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE end

function imba_riki_smoke_screen:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) end

function imba_riki_smoke_screen:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end

function imba_riki_smoke_screen:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

		local duration = self:GetSpecialValueFor("duration")
		local aoe = self:GetSpecialValueFor("area_of_effect")
		local smoke_handler = "modifier_imba_smoke_screen_handler"
		local smoke_sound = "Hero_Riki.Smoke_Screen"

		EmitSoundOnLocationWithCaster(target_point, smoke_sound, caster)

		local thinker = CreateModifierThinker(caster, self, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, caster:GetTeamNumber(), false)

		local particle = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
		ParticleManager:SetParticleControl(particle, 0, thinker:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(aoe, 0, aoe))

		Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end)
	end
end

---------------------------------
-----	Smoke Screen Aura	-----
---------------------------------
modifier_imba_smoke_screen_handler = modifier_imba_smoke_screen_handler or class({})
function modifier_imba_smoke_screen_handler:IsPurgable() return false end
function modifier_imba_smoke_screen_handler:IsHidden() return true end
function modifier_imba_smoke_screen_handler:IsAura() return true end

function modifier_imba_smoke_screen_handler:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_smoke_screen_handler:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_imba_smoke_screen_handler:GetModifierAura()
	return "modifier_imba_smoke_screen_debuff_miss" end

function modifier_imba_smoke_screen_handler:GetAuraRadius()
	local ability = self:GetAbility()
	local aoe = ability:GetSpecialValueFor("area_of_effect")
	return aoe
end

function modifier_imba_smoke_screen_handler:OnCreated(keys)
	if IsServer() then
		self.target_point_x = keys.target_point_x
		self.target_point_y = keys.target_point_y
		self:StartIntervalThink(0.1)
		self:GetParent().afflicted = {}
	end
end

function modifier_imba_smoke_screen_handler:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local parent = self:GetParent()

	local aoe = self:GetAbility():GetSpecialValueFor("area_of_effect")
	local max_reduction = ability:GetSpecialValueFor("max_vision_reduction_pcnt")
	local remaining_duration = self:GetRemainingTime()

	-- #3 Talent: Smokescreen grants Riki a second form of invisibility
	if caster:HasTalent("special_bonus_imba_riki_5") then

		local allies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for _,ally in pairs (allies) do
			if ally == caster then
				local smoke_screen_invi = caster:AddNewModifier(caster,ability,"modifier_imba_smoke_screen_invi_indicator",{})
				if smoke_screen_invi then
					smoke_screen_invi.thinker = self
					smoke_screen_invi.pos_x = self.target_point_x
					smoke_screen_invi.pos_y = self.target_point_y
				end
			end
		end
	end

	local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	-- black magic starts here
	for _, unit in pairs(targets) do

		-- If the unit was never afflicted with a modifier instance from this handler, give it the modifier and index it along with the units ID
		if not parent.afflicted[unit:entindex()] then
			local mod = unit:AddNewModifier(caster, self:GetAbility(), "modifier_imba_smoke_screen_vision", {duration = remaining_duration})
			table.insert(parent.afflicted, unit:entindex(), mod)

		else
			-- If the parent somehow (death for example) lost the modifier and got back into the smoke(glimpse, timelapse), reapply and re-index it
			if not parent.afflicted[unit:entindex()] then
				local mod = unit:AddNewModifier(caster, self:GetAbility(), "modifier_imba_smoke_screen_vision", {duration = remaining_duration})
				table.insert(parent.afflicted, unit:entindex(), mod)
			end

			-- Calculate the distances between the mid point of the handlers dummy and the unit, and then convert it to % distance from closest to furthest
			local distance = CalcDistanceBetweenEntityOBB(parent, unit)
			local stacks = math.ceil(max_reduction * (100 - (distance * 100 / aoe)) / 100) + 1

			-- Check if this modifier instance is the strongest of all the other instances the unit might have
			local isStrongest = true
			local duplicateMods = unit:FindAllModifiersByName("modifier_imba_smoke_screen_vision")
			for _,modifier in pairs(duplicateMods) do
				if not modifier:IsNull() then
					if modifier ~= parent.afflicted[unit:entindex()] then
						if modifier:GetStackCount() >= stacks then
							-- If not, set the stacks of the instance applied by this handler to 0 and break out of this loop
							if not parent.afflicted[unit:entindex()]:IsNull() then
								parent.afflicted[unit:entindex()]:SetStackCount(0)
								isStrongest = false
							end
							break
						end
					end
				end
			end

			-- If it is the strongest, apply the stacks normally
			if isStrongest and not parent.afflicted[unit:entindex()]:IsNull() then
				parent.afflicted[unit:entindex()]:SetStackCount(stacks)
			end
		end
	end

	for index, modifier in pairs(parent.afflicted) do
		local unit = EntIndexToHScript(index)
		local distance = CalcDistanceBetweenEntityOBB(parent, unit)
		if not modifier:IsNull() then
			if distance > aoe then modifier:SetStackCount(0) end
		end
	end
end

function modifier_imba_smoke_screen_handler:OnDestroy()
	if IsServer() then
		for _, modifier in pairs(self:GetParent().afflicted) do
			if not modifier:IsNull() then modifier:Destroy() end
		end

		-- Destroy Smokescreen #4 Invisible talent
		local ability = self:GetAbility()
		local caster = ability:GetCaster()

		if caster:HasModifier("modifier_imba_smoke_screen_invi_indicator") then
			caster:RemoveModifierByName("modifier_imba_smoke_screen_invi_indicator")
		end
	end
end

-----------------------------------------
-----	Smoke Screen Invi Talent	-----
-----------------------------------------

modifier_imba_smoke_screen_invi_indicator = modifier_imba_smoke_screen_invi_indicator or class({})

function modifier_imba_smoke_screen_invi_indicator:IsPurgable() return false end
function modifier_imba_smoke_screen_invi_indicator:IsDebuff() return false end
function modifier_imba_smoke_screen_invi_indicator:IsHidden() return false end
function modifier_imba_smoke_screen_invi_indicator:DestroyOnExpire() return false end

function modifier_imba_smoke_screen_invi_indicator:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		self.counter = 0
		self.interval = 0.1
		self.radius = self.ability:GetSpecialValueFor("area_of_effect")
		self.fade_time = self.caster:FindTalentValue("special_bonus_imba_riki_5")
		self.fade_delay = self.fade_time / self.interval
		self:StartIntervalThink(self.interval)
	end
end

function modifier_imba_smoke_screen_invi_indicator:OnIntervalThink()
	if self.thinker then
		self.distance = (Vector(self.pos_x,self.pos_y,0) - self.caster:GetAbsOrigin()):Length2D()
	end
	-- Destroys itself if Riki isn't inside Smokescreen :S
	if self.distance > self.radius then
		self:Destroy()
		return
	end
	-- Get if Riki breaks the invisibility
	if self.caster:HasModifier("modifier_imba_smoke_screen_invi") then
		self.counter = 0
		self:SetDuration(-1,true)
	else
		-- If Riki breaks out of invisibility, set the duration to indicate its fade time
		if self.counter == 0 then
			self:SetDuration(self.fade_time,true)
		end
		self.counter = self.counter +1
	end
	if self.counter >= self.fade_delay then
		self.caster:AddNewModifier(caster,ability,"modifier_imba_smoke_screen_invi",{})
	end
end

modifier_imba_smoke_screen_invi = modifier_imba_smoke_screen_invi or class({})

function modifier_imba_smoke_screen_invi:IsPurgable() return false end
function modifier_imba_smoke_screen_invi:IsDebuff() return false end
function modifier_imba_smoke_screen_invi:IsHidden()	return true end


-----------------------------------
-----	Smoke Screen Debuff	  -----
-----------------------------------
modifier_imba_smoke_screen_debuff_miss = modifier_imba_smoke_screen_debuff_miss or class({})
function modifier_imba_smoke_screen_debuff_miss:IsPurgable() return false end
function modifier_imba_smoke_screen_debuff_miss:IsHidden() return false end
function modifier_imba_smoke_screen_debuff_miss:IsDebuff() return true end

function modifier_imba_smoke_screen_debuff_miss:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_imba_smoke_screen_debuff_miss:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_smoke_screen_debuff_miss:CheckState()
	local state = { [MODIFIER_STATE_SILENCED] = true}
	return state
end

function modifier_imba_smoke_screen_debuff_miss:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, }
	return funcs
end

function modifier_imba_smoke_screen_debuff_miss:GetModifierMiss_Percentage()
	local ability = self:GetAbility()
	local miss_chance = ability:GetSpecialValueFor("miss_chance")
	return miss_chance
end

function modifier_imba_smoke_screen_debuff_miss:GetModifierTurnRate_Percentage()
	local ability = self:GetAbility()
	local turn_slow = ability:GetSpecialValueFor("turn_rate_slow")*-1
	return turn_slow
end

function modifier_imba_smoke_screen_debuff_miss:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local slow = ability:GetSpecialValueFor("slow")*-1
	return slow
end

-------------------------------------------
-----	Smoke Screen Vision Debuff	  -----
-------------------------------------------
modifier_imba_smoke_screen_vision = modifier_imba_smoke_screen_vision or class({})
function modifier_imba_smoke_screen_vision:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_smoke_screen_vision:IsPurgable() return false end
function modifier_imba_smoke_screen_vision:IsHidden() return true end
function modifier_imba_smoke_screen_vision:IsDebuff() return true end

function modifier_imba_smoke_screen_vision:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, }
	return funcs
end

function modifier_imba_smoke_screen_vision:GetBonusVisionPercentage()
	return self:GetStackCount() * -1
end

---------------------------------------------------------------------
-------------------------	Blink Strike	-------------------------
---------------------------------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_blink_strike_debuff_turn"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_blink_strike_thinker"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_blink_strike_cmd"] = LUA_MODIFIER_MOTION_NONE,
})

imba_riki_blink_strike = imba_riki_blink_strike or class({})
function imba_riki_blink_strike:IsHiddenWhenStolen() return false end
function imba_riki_blink_strike:IsRefreshable() return true end
function imba_riki_blink_strike:IsStealable() return true end
function imba_riki_blink_strike:IsNetherWardStealable() return false end

function imba_riki_blink_strike:GetAbilityTextureName()
	return "riki_blink_strike"
end
-------------------------------------------

function imba_riki_blink_strike:GetCastRange(location , target)
	if IsServer() then
		if self.thinker or self.tMarkedTargets then
			if self.tStoredTargets or self.tMarkedTargets then
				return 25000
			end
		end
	end
	return self.BaseClass.GetCastRange(self,location,target)
end

function imba_riki_blink_strike:OnAbilityPhaseStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		self.hTarget = self:GetCursorTarget()
		local hTarget = self.hTarget
		if self.thinker then
			if not self.thinker:IsNull() then
				self.thinker:Destroy()
			end
			self.thinker = nil
		end
		local jump_interval_frames = self:GetSpecialValueFor("jump_interval_frames")
		local cast_range = self.BaseClass.GetCastRange(self,hCaster:GetAbsOrigin(),hTarget) + GetCastRangeIncrease(hCaster)
		local current_distance = CalcDistanceBetweenEntityOBB(hCaster, hTarget)
		if (self:GetTalentSpecialValueFor("max_jumps") >= 1) and (current_distance > cast_range) and self.tStoredTargets then
			-- Once you start to begin to cast, the chain is set, and no additional target will be searched nor removed.
			-- This can only be prevented if you get disabled or stop the order
			self.tMarkedTargets = {}
			for _,target_entindex in pairs(self.tStoredTargets) do
				if not (target_entindex.IsCaster or target_entindex.IsTarget) then
					table.insert(self.tMarkedTargets, EntIndexToHScript(target_entindex.entity_index))
				end
			end
		else
			self.tMarkedTargets = nil
		end
		-- Clear the cache
		self.tStoredTargets = nil
		-- Only the trail particle function, lul
		local index = DoUniqueString("index")
		self.index = index
		local counter = 0
		local marked_counter = 1
		local current_target
		local last_position = hCaster:GetAbsOrigin()
		local tMarkedTargets
		if self.tMarkedTargets then
			tMarkedTargets = self.tMarkedTargets
			current_target = tMarkedTargets[marked_counter]
		else
			marked_counter = 0
			current_target = hTarget
		end
		self.trail_pfx = nil
		self.trail_pfx = ParticleManager:CreateParticleForTeam("particles/hero/riki/blink_trail.vpcf", PATTACH_ABSORIGIN, hCaster, hCaster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position+Vector(0,0,35))
		Timers:CreateTimer(FrameTime(), function()
			if self.trail_pfx then
				-- To make sure its the same cast
				if (index == self.index and not current_target:IsNull()) then
					ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position+Vector(0,0,35))
					counter = counter + 1
					local target_loc = current_target:GetAbsOrigin()
					local distance = (last_position - target_loc):Length2D()
					local direction = (target_loc - last_position):Normalized()
					last_position = last_position + (direction * (distance/jump_interval_frames) * counter)
					ParticleManager:SetParticleControl(self.trail_pfx, 0, last_position)
					if counter >= jump_interval_frames then
						if (marked_counter == 0) or (marked_counter >= #tMarkedTargets+1) then
							ParticleManager:DestroyParticle(self.trail_pfx, false)
							ParticleManager:ReleaseParticleIndex(self.trail_pfx)
							return false
						else
							counter = 0
							marked_counter = marked_counter + 1
							if marked_counter > #tMarkedTargets then
								current_target = hTarget
							else
								current_target = tMarkedTargets[marked_counter]
							end
						end
					end
				else
					ParticleManager:DestroyParticle(self.trail_pfx, true)
					ParticleManager:ReleaseParticleIndex(self.trail_pfx)
					return false
				end
				return FrameTime()
			else
				return false
			end
		end)
		return true
	end
end

function imba_riki_blink_strike:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.thinker then
			local hCaster = self:GetCaster()
			self.thinker:Destroy()
			self.thinker = nil
			self.tStoredTargets = nil
			self.tMarkedTargets = nil
			ParticleManager:DestroyParticle(self.trail_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.trail_pfx)
			-- Reset this, it gets removed anyways if you do another order
			self.thinker = hCaster:AddNewModifier(hCaster, self, "modifier_imba_blink_strike_thinker", {target = self.hTarget:entindex()})
		end
	end
end

function imba_riki_blink_strike:OnSpellStart()
	if IsServer() then
		self.hCaster = self:GetCaster()
		self.hTarget = self:GetCursorTarget()
		local hTarget = self.hTarget

		-- Parameters
		self.damage = self:GetSpecialValueFor("damage")
		self.duration = self:GetTalentSpecialValueFor("duration")
		local jump_duration = 0
		local cast_sound = "Hero_Riki.Blink_Strike"
		self.hCaster:Stop()
		if self.tMarkedTargets then
			local tMarkedTargets = self.tMarkedTargets
			self.jump_interval_frames = self:GetSpecialValueFor("jump_interval_frames")
			local jump_interval_time = self.jump_interval_frames * FrameTime()
			jump_duration = #tMarkedTargets * jump_interval_time + jump_interval_time
			self.hCaster:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_cmd", {duration = jump_duration})
			table.insert(tMarkedTargets, hTarget)
			for i = 1, (#tMarkedTargets - 1) do
				Timers:CreateTimer(i*jump_interval_time, function()
					self:DoJumpAttack(tMarkedTargets[i], tMarkedTargets[(i+1)])
				end)
			end
		else
			self.hCaster:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_cmd", {duration = FrameTime()})
		end

		Timers:CreateTimer(jump_duration, function()
			local target_loc_forward_vector = hTarget:GetForwardVector()
			local final_pos = hTarget:GetAbsOrigin() - target_loc_forward_vector * 100
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
			ParticleManager:SetParticleControl(particle, 1, final_pos)
			ParticleManager:ReleaseParticleIndex(particle)
			FindClearSpaceForUnit(self.hCaster, final_pos, true)
			self.hCaster:MoveToTargetToAttack(hTarget)
			if (hTarget:GetTeamNumber() ~= self.hCaster:GetTeamNumber()) then
				ApplyDamage({victim = hTarget, attacker = self.hCaster, damage = self.damage, damage_type = self:GetAbilityDamageType()})
				hTarget:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_debuff_turn", {duration = self.duration})
			end
			self.hCaster:SetForwardVector(target_loc_forward_vector)
			EmitSoundOn("Hero_Riki.Blink_Strike", hTarget)

			-- #1 Talent: Blink Strike now leaves Smokescreen for 1 second after each instance
			if self.hCaster:HasTalent("special_bonus_imba_riki_1") then
				local smokescreen_ability = self.hCaster:FindAbilityByName("imba_riki_smoke_screen")
				if smokescreen_ability:GetLevel() >=1 then
					local target_point = final_pos
					local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

					local duration = self.hCaster:FindTalentValue("special_bonus_imba_riki_1")
					local aoe = smokescreen_ability:GetSpecialValueFor("area_of_effect")
					local smoke_handler = "modifier_imba_smoke_screen_handler"
					local smoke_sound = "Hero_Riki.Smoke_Screen"

					EmitSoundOnLocationWithCaster(target_point, smoke_sound, self.hCaster)

					local thinker = CreateModifierThinker(self.hCaster, smokescreen_ability, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, self.hCaster:GetTeamNumber(), false)

					local smoke_particle_fx = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
					ParticleManager:SetParticleControl(smoke_particle_fx, 0, thinker:GetAbsOrigin())
					ParticleManager:SetParticleControl(smoke_particle_fx, 1, Vector(aoe, 0, aoe))

					Timers:CreateTimer(duration, function()
						ParticleManager:DestroyParticle(smoke_particle_fx, false)
						ParticleManager:ReleaseParticleIndex(smoke_particle_fx)
						smoke_particle_fx = nil
					end)
				end
			end
		end)
		self.tStoredTargets = nil
		self.tMarkedTargets = nil
		self.hTarget = nil
	end
end

function imba_riki_blink_strike:DoJumpAttack(hTarget, hNextTarget)
	self.hCaster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
	self.hCaster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
	EmitSoundOn("Hero_Riki.Blink_Strike", hTarget)
	local target_loc = hTarget:GetAbsOrigin()
	local next_target_loc = hNextTarget:GetAbsOrigin()

	-- #1 Talent: Blink Strike now leaves Smokescreen for 1 second after each instance
	if self.hCaster:HasTalent("special_bonus_imba_riki_1") then
		local smokescreen_ability = self.hCaster:FindAbilityByName("imba_riki_smoke_screen")
		if smokescreen_ability:GetLevel() >=1 then
			local target_point = target_loc
			local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

			local duration = self.hCaster:FindTalentValue("special_bonus_imba_riki_1")
			local aoe = smokescreen_ability:GetSpecialValueFor("area_of_effect")
			local smoke_handler = "modifier_imba_smoke_screen_handler"
			local smoke_sound = "Hero_Riki.Smoke_Screen"

			EmitSoundOnLocationWithCaster(target_point, smoke_sound, self.hCaster)

			local thinker = CreateModifierThinker(self.hCaster, smokescreen_ability, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, self.hCaster:GetTeamNumber(), false)

			local smoke_particle_fx = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
			ParticleManager:SetParticleControl(smoke_particle_fx, 0, thinker:GetAbsOrigin())
			ParticleManager:SetParticleControl(smoke_particle_fx, 1, Vector(aoe, 0, aoe))

			Timers:CreateTimer(duration, function()
				ParticleManager:DestroyParticle(smoke_particle_fx, false)
				ParticleManager:ReleaseParticleIndex(smoke_particle_fx)
				smoke_particle_fx = nil
			end)
		end
	end

	local direction = (target_loc - next_target_loc):Normalized()
	if (hTarget:GetTeamNumber() == self.hCaster:GetTeamNumber()) then
		self.hCaster:SetForwardVector(direction)
		local start_loc = target_loc + Vector(0,0,100)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
		ParticleManager:SetParticleControl(particle, 1, start_loc)
		ParticleManager:ReleaseParticleIndex(particle)
		local distance = 200 / self.jump_interval_frames
		self.hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
		for i=1, (self.jump_interval_frames - 1) do
			Timers:CreateTimer(FrameTime()*i, function()
				local location = (start_loc - direction * distance * i)
				self.hCaster:SetAbsOrigin(location)
				self.hCaster:SetForwardVector(direction)
			end)
		end
	else
		self.hCaster:SetForwardVector(direction)
		local location = target_loc - (hTarget:GetForwardVector()*100)
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_blink_strike.vpcf", PATTACH_ABSORIGIN, self.hCaster)
		ParticleManager:SetParticleControl(particle, 1, location)
		ParticleManager:ReleaseParticleIndex(particle)
		self.hCaster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.5)
		self.hCaster:PerformAttack(hTarget, true, true, true, false, false, false, false)
		ApplyDamage({victim = hTarget, attacker = self.hCaster, damage = self.damage, damage_type = self:GetAbilityDamageType()})
		hTarget:AddNewModifier(self.hCaster, self, "modifier_imba_blink_strike_debuff_turn", {duration = self.duration})
		self.hCaster:SetAbsOrigin(location)
	end
end
-------------------------------------------
modifier_imba_blink_strike_thinker = modifier_imba_blink_strike_thinker or class({})
function modifier_imba_blink_strike_thinker:IsDebuff() return false end
function modifier_imba_blink_strike_thinker:IsHidden() return false end
function modifier_imba_blink_strike_thinker:IsPurgable() return false end
function modifier_imba_blink_strike_thinker:IsPurgeException() return false end
function modifier_imba_blink_strike_thinker:IsStunDebuff() return false end
-------------------------------------------
function modifier_imba_blink_strike_thinker:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ORDER
		}
	return decFuns
end

function modifier_imba_blink_strike_thinker:OnOrder(params)
	if IsServer() then
		if params.unit == self:GetCaster() and self.created_flag then
			local activity = params.unit:GetCurrentActiveAbility()
			if activity then
				if not (activity:GetName() == "imba_riki_blink_strike") then
					self.hAbility.tStoredTargets = nil
					self.hAbility.tMarkedTargets = nil
					self.hAbility.hTarget = nil
					self.hAbility.thinker = nil
					self:Destroy()
				end
			end
		end
	end
end

function modifier_imba_blink_strike_thinker:OnCreated(params)
	if IsServer() then
		self.hCaster = self:GetCaster()
		if params.target then
			self.hTarget = EntIndexToHScript(params.target)
		else
			self:Destroy()
		end
		self.hAbility = self:GetAbility()
		-- Parameters
		self.jump_range = self.hAbility:GetSpecialValueFor("jump_range") + GetCastRangeIncrease(self.hCaster)
		self.max_jumps = self.hAbility:GetTalentSpecialValueFor("max_jumps")
		self.jump_interval_time = self.hAbility:GetSpecialValueFor("jump_interval_time")
		self.lagg_threshold = self.hAbility:GetSpecialValueFor("lagg_threshold")
		self.cast_range = self.hAbility.BaseClass.GetCastRange(self.hAbility,self.hCaster:GetAbsOrigin(),self.hTarget) + GetCastRangeIncrease(self.hCaster)
		self.max_range = self.cast_range + self.max_jumps * self.jump_range
		Timers:CreateTimer(FrameTime(), function()
			self.created_flag = true
		end)
		-- Run this instantly, not after 1 Frame delay
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_blink_strike_thinker:OnIntervalThink()
	if IsServer() then
		-- If already found a chain, don't recheck (They are "marked", thus will always get hit like Sleight of fist)
		if (not self.hAbility.tStoredTargets) then
			local current_distance = CalcDistanceBetweenEntityOBB(self.hCaster, self.hTarget)
			-- No need for calculations if they already exceed max-range
			if (current_distance <= self.max_range) or (current_distance < self.cast_range) then
				local tJumpableUnits = FindUnitsInRadius(self.hCaster:GetTeamNumber(), self.hCaster:GetAbsOrigin(), nil, self.max_range, self.hAbility:GetAbilityTargetTeam(), self.hAbility:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
				-- Creating nodes for A*, a 2D-graph for calculations, using x and y coordinates
				local graph = {}
				local caster_index = false
				local target_index = false
				-- Making a table suitable for the A*-algorithm, adding a lagg-threshold to ensure mass units affect performance (e.g. Broodmother)
				for i=1,math.min(#tJumpableUnits,self.lagg_threshold) do
					local pos = tJumpableUnits[i]:GetAbsOrigin()
					graph[i] = {}
					graph[i].x = pos.x
					graph[i].y = pos.y
					graph[i].entity_index = tJumpableUnits[i]:entindex()
					if (tJumpableUnits[i] == self.hCaster) then
						caster_index = i
						graph[i].IsCaster = true
					elseif (tJumpableUnits[i] == self.hTarget) then
						target_index = i
						graph[i].IsTarget = true
					end
				end
				-- If it exceed the lagg-limit, check if both caster and target are in it, else add them
				if not caster_index then
					local pos = self.hCaster:GetAbsOrigin()
					caster_index = 0
					graph[caster_index] = {}
					graph[caster_index].x = pos.x
					graph[caster_index].y = pos.y
					graph[caster_index].IsCaster = true
				end
				if not target_index then
					local pos = self.hTarget:GetAbsOrigin()
					target_index = self.lagg_threshold + 1
					graph[target_index] = {}
					graph[target_index].x = pos.x
					graph[target_index].y = pos.y
					graph[target_index].IsTarget = true
				end
				-- This are the parameters for the A-star.
				local valid_node_func = function ( node, neighbor )
					if (node.IsCaster and (astar.distance(node.x,node.y,neighbor.x,neighbor.y ) < self.cast_range)) or
						(astar.distance(node.x,node.y,neighbor.x,neighbor.y ) < self.jump_range) then
						return true
					end
					return false
				end
				-- This is the call for the algorithm. Returns nil if no valid path was found
				local path = astar.path(graph[caster_index],graph[target_index],graph,true,valid_node_func)
				if path then
					if (#path <= self.max_jumps+2) and (not (#path == 2)) then
						self.hAbility.tStoredTargets = path
						-- No need to re-run anymore, thinker gets destroyed if it parsed all variables.
						self:StartIntervalThink(-1)
					end
				end
			else
				-- If there are unforseen circumstances this will bre resetted. Optimaly this will never run.
				self.hAbility.tStoredTargets = nil
			end
		end
	end
end

-----------------------------------
-----	Blink Strike Debuff	  -----
-----------------------------------
modifier_imba_blink_strike_debuff_turn = modifier_imba_blink_strike_debuff_turn or class({})
function modifier_imba_blink_strike_debuff_turn:IsPurgable() return true end
function modifier_imba_blink_strike_debuff_turn:IsHidden() return false end
function modifier_imba_blink_strike_debuff_turn:IsDebuff() return true end

function modifier_imba_blink_strike_debuff_turn:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, }
	return funcs
end

function modifier_imba_blink_strike_debuff_turn:OnCreated()
	self.slow_pct = self:GetAbility():GetSpecialValueFor("turn_rate_slow_pct")
end

function modifier_imba_blink_strike_debuff_turn:GetModifierTurnRate_Percentage()
	return self.slow_pct * (-1)
end

---------------------------------------------------------------
-----	Blink Strike out of world modifier for jumping	  -----
---------------------------------------------------------------
modifier_imba_blink_strike_cmd = modifier_imba_blink_strike_cmd or class({})
function modifier_imba_blink_strike_cmd:IsPurgable() return false end
function modifier_imba_blink_strike_cmd:IsHidden() return true end
function modifier_imba_blink_strike_cmd:IsDebuff() return false end

function modifier_imba_blink_strike_cmd:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_blink_strike_cmd:OnCreated()
	if IsServer() then
		local hCaster = self:GetCaster()

	end
end

function modifier_imba_blink_strike_cmd:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_DISARMED ] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR ] = true,
			[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		return state
	end
end

function modifier_imba_blink_strike_cmd:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			MODIFIER_PROPERTY_DISABLE_TURNING
		}
	return decFuns
end

function modifier_imba_blink_strike_cmd:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_riki" then
		return "backstab"
	end
	return 0
end

function modifier_imba_blink_strike_cmd:GetModifierDisableTurning()
	return 1
end
---------------------------------------------------------------------
--------------------	  Cloak and Dagger		 --------------------
---------------------------------------------------------------------
imba_riki_cloak_and_dagger = imba_riki_cloak_and_dagger or class({})
LinkLuaModifier( "modifier_imba_riki_cloak_and_dagger", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Backstab and invisibility handler
LinkLuaModifier( "modifier_imba_riki_invisibility", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Invisibility modifier
LinkLuaModifier( "modifier_imba_riki_backstab_translation", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Attack translate
LinkLuaModifier( "modifier_imba_riki_peek_a_boo", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_riki_backbreaker", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_riki_backbroken", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )

-- Adding "modifier_special_bonus_imba_riki_3" as separate modifier to force GetBehavior call from passive to active skill
LinkLuaModifier("modifier_special_bonus_imba_riki_3", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_riki_3 = class({})

function modifier_special_bonus_imba_riki_3:IsHidden() 			return true end
function modifier_special_bonus_imba_riki_3:IsPurgable() 		return false end
function modifier_special_bonus_imba_riki_3:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_riki_3:OnCreated()
	if not IsServer() then return end
	if self:GetParent():FindAbilityByName("imba_riki_cloak_and_dagger") then
		self:GetParent():FindAbilityByName("imba_riki_cloak_and_dagger"):GetBehavior()
	end
end

---

function imba_riki_cloak_and_dagger:GetAbilityTextureName()
	return "riki_permanent_invisibility"
end

function imba_riki_cloak_and_dagger:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_riki_3") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function imba_riki_cloak_and_dagger:IsRefreshable() return false end

function imba_riki_cloak_and_dagger:GetIntrinsicModifierName()
	return "modifier_imba_riki_cloak_and_dagger"
end

function imba_riki_cloak_and_dagger:OnOwnerSpawned()
	if not IsServer() then return end
	self:EndCooldown()
	if self:GetCaster():HasAbility("special_bonus_imba_riki_3") and self:GetCaster():FindAbilityByName("special_bonus_imba_riki_3"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_riki_3") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_riki_3", {})
	end
end

function imba_riki_cloak_and_dagger:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

-- #3 Talent: Riki can now activate Cloak and Dagger to gain bonus Agi Multiplier
function imba_riki_cloak_and_dagger:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if caster:HasTalent("special_bonus_imba_riki_3") then
			local particle = ParticleManager:CreateParticle("particles/hero/riki/riki_peek_a_boo_active.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_CUSTOMORIGIN_FOLLOW, "follow_hitloc", caster:GetAbsOrigin(), true)

			EmitSoundOn("Hero_Riki.Blink_Strike", caster)
			caster:AddNewModifier(caster,self,"modifier_imba_riki_peek_a_boo",{duration = caster:FindTalentValue("special_bonus_imba_riki_3","duration")})
		end

		self:EndCooldown()
		self:StartCooldown(caster:FindTalentValue("special_bonus_imba_riki_3","duration"))
	end
end

----------------------------------------------------------
-----	Cloak and Dagger backstab + invis handler	  ----
----------------------------------------------------------
modifier_imba_riki_cloak_and_dagger = modifier_imba_riki_cloak_and_dagger or class({})
function modifier_imba_riki_cloak_and_dagger:IsPurgable() return false end
function modifier_imba_riki_cloak_and_dagger:IsDebuff() return false end
function modifier_imba_riki_cloak_and_dagger:IsHidden()	return true end

function modifier_imba_riki_cloak_and_dagger:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED,}
	return funcs
end

function modifier_imba_riki_cloak_and_dagger:CheckState()
	if IsServer() then
		local ability = self:GetAbility()
		local parent = self:GetParent()
		local fade_time = ability:GetTalentSpecialValueFor("fade_time")

		-- If the owner is broken, remove invis modifier and restart cooldown
		if parent:PassivesDisabled() then

			-- Remove the invis modifier if it exists
			if parent:HasModifier("modifier_imba_riki_invisibility") then
				parent:RemoveModifierByName("modifier_imba_riki_invisibility")
			end

			-- Reset cooldown if it smaller than the fade time
			if ability:GetCooldownTimeRemaining() < fade_time then
				ability:StartCooldown(fade_time)
			end
			-- If the passive cooldown is ready
		elseif ability:IsCooldownReady() or parent:HasModifier("modifier_imba_smoke_screen_invi") then
			if parent:HasModifier("modifier_imba_riki_peek_a_boo") then
				if parent:HasModifier("modifier_imba_riki_invisibility") then
					parent:RemoveModifierByName("modifier_imba_riki_invisibility")
				end
				return
			end

			if not parent:HasModifier("modifier_imba_riki_invisibility") then
				parent:AddNewModifier(parent, ability, "modifier_imba_riki_invisibility", {})
			end

			-- If the passive is on cooldown, remove the invis modifier
		elseif parent:HasModifier("modifier_imba_riki_invisibility") then
			parent:RemoveModifierByName("modifier_imba_riki_invisibility")
		end
	end
end

function modifier_imba_riki_cloak_and_dagger:OnAttackLanded( keys )
	if IsServer() then
		local target = keys.target		-- Unit getting hit
		local attacker = keys.attacker	-- Unit landing the hit
		local parent = self:GetParent()	-- Unit holding this modifier
		local ability = self:GetAbility()

		-- Check if the parent is the attacker
		if parent == attacker then

			-- Get values
			local fade_time = ability:GetTalentSpecialValueFor("fade_time")
			local agility_multiplier = ability:GetSpecialValueFor("agility_damage_multiplier")
			local agility_multiplier_smoke = ability:GetSpecialValueFor("agility_damage_multiplier_smoke")
			local agility_multiplier_side = ability:GetSpecialValueFor("agility_damage_multiplier_side")
			local agility_multiplier_invis_break = ability:GetSpecialValueFor("invis_break_agility_multiplier")

			local backstab_sound = "Hero_Riki.Backstab"
			local backstab_invisbreak_sound = "Imba.RikiCritStab"
			local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
			local sucker_punch_particle = "particles/hero/riki/riki_sucker_punch.vpcf"
			local backbreak = false

			-- If the target is not a building, and passives are not disabled for the passive owner
			-- Also checks if the parent is not channeling Tricks of the Trade, since backstab is handled through there.
			if not parent:HasModifier("modifier_imba_riki_tricks_of_the_trade_primary") and not target:IsBuilding() and not parent:PassivesDisabled() then

				-- If the passive is off cooldown, apply invis break bonus to backstab damage
				if ability:IsCooldownReady() and parent:IsImbaInvisible() then
					agility_multiplier = agility_multiplier * agility_multiplier_invis_break
					agility_multiplier_smoke = agility_multiplier_smoke * agility_multiplier_invis_break
					agility_multiplier_side = agility_multiplier_side * agility_multiplier_invis_break
				end

				-- #6 Talent: Cloak and Dagger can be activated for Riki to gain bonus multiplier, but loses its invisibility over the duration
				if parent:HasModifier("modifier_imba_riki_peek_a_boo") then
					agility_multiplier = agility_multiplier * parent:FindTalentValue("special_bonus_imba_riki_3")
					agility_multiplier_smoke = agility_multiplier_smoke * parent:FindTalentValue("special_bonus_imba_riki_3")
					agility_multiplier_side = agility_multiplier_side * parent:FindTalentValue("special_bonus_imba_riki_3")
					backstab_particle = "particles/hero/riki/riki_peek_a_boo_stab.vpcf"
				end

				-- Find targets back
				local victim_angle = target:GetAnglesAsVector().y
				local origin_difference = target:GetAbsOrigin() - attacker:GetAbsOrigin()
				local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
				origin_difference_radian = origin_difference_radian * 180

				local attacker_angle = origin_difference_radian / math.pi

				-- For some reason Dota mechanics read the result as 30 degrees anticlockwise, need to adjust it down to appropriate angles for backstabbing.
				attacker_angle = attacker_angle + 180.0 + 30.0

				local result_angle = attacker_angle - victim_angle
				result_angle = math.abs(result_angle)

				-- Get the chance for Riki to appear at the back of the victim
				local back_chance_success = false
				local back_chance = parent:FindTalentValue("special_bonus_imba_riki_8") or 0
				if RollPseudoRandom(back_chance, self) then
					back_chance_success = true
				end

				-- #8 Talent: Riki gains a chance to attack an opponent's back
				if parent:HasTalent("special_bonus_imba_riki_8") and back_chance_success then

					-- Get the Blink Strike ability for the debuff duration. If it doesn't have it, no debuff for you!
					blink_strike_ability = parent:FindAbilityByName("imba_riki_blink_strike")
					local turn_debuff_duration
					if blink_strike_ability then
						turn_debuff_duration = blink_strike_ability:GetSpecialValueFor("duration")
						target:AddNewModifier(parent, blink_strike_ability, "modifier_imba_blink_strike_debuff_turn", {duration = turn_debuff_duration})
						ApplyDamage({victim = target, attacker = attacker, damage = blink_strike_ability:GetSpecialValueFor("damage"), damage_type = blink_strike_ability:GetAbilityDamageType()})
					end

					-- Emit Blink Strike sound
					EmitSoundOn("Hero_Riki.Blink_Strike", attacker)

					-- Get behind the victim
					local direction = target:GetForwardVector() * (-1)
					local distance = parent:FindTalentValue("special_bonus_imba_riki_8","distance")

					local blink_point = target:GetAbsOrigin() + direction * distance
					attacker:SetAbsOrigin(blink_point)
					attacker:SetForwardVector(-direction)
					attacker:SetUnitOnClearGround()

					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(backstab_sound, target)

					-- If breaking invisibility, play the sound and particle of critstab
					if parent:HasModifier("modifier_imba_riki_invisibility") then
						local sucker_particle = ParticleManager:CreateParticle(sucker_punch_particle, PATTACH_ABSORIGIN_FOLLOW, target)
						ParticleManager:SetParticleControlEnt(sucker_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,-100) , true)
						ParticleManager:ReleaseParticleIndex(sucker_particle)
						EmitSoundOn(backstab_invisbreak_sound, target)
					end

					-- If the attacker is an illusion, don't apply the damage
					if not parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier, damage_type = ability:GetAbilityDamageType()})
						backbreak = true
					end
					parent:AddNewModifier(parent, self, "modifier_imba_riki_backstab_translation", {duration = parent:GetAttackSpeed()})

					-- #1 Talent: Blink Strike now leaves Smokescreen for 1 second after each instance
					if parent:HasTalent("special_bonus_imba_riki_1") then
						local smokescreen_ability = parent:FindAbilityByName("imba_riki_smoke_screen")
						if smokescreen_ability:GetLevel() >=1 then
							local target_point = target:GetAbsOrigin()
							local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"

							local duration = parent:FindTalentValue("special_bonus_imba_riki_1")
							local aoe = smokescreen_ability:GetSpecialValueFor("area_of_effect")
							local smoke_handler = "modifier_imba_smoke_screen_handler"
							local smoke_sound = "Hero_Riki.Smoke_Screen"

							EmitSoundOnLocationWithCaster(target_point, smoke_sound, parent)

							local thinker = CreateModifierThinker(parent, smokescreen_ability, smoke_handler, {duration = duration, target_point_x = target_point.x , target_point_y = target_point.y}, target_point, parent:GetTeamNumber(), false)

							local smoke_particle_fx = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, thinker)
							ParticleManager:SetParticleControl(smoke_particle_fx, 0, thinker:GetAbsOrigin())
							ParticleManager:SetParticleControl(smoke_particle_fx, 1, Vector(aoe, 0, aoe))

							Timers:CreateTimer(duration, function()
								ParticleManager:DestroyParticle(smoke_particle_fx, false)
								ParticleManager:ReleaseParticleIndex(smoke_particle_fx)
								smoke_particle_fx = nil
							end)
						end
					end

					-- If the attacker is in backstab angle
				elseif result_angle >= (180 - (ability:GetSpecialValueFor("backstab_angle") / 2)) and result_angle <= (180 + (ability:GetSpecialValueFor("backstab_angle") / 2)) then

					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(backstab_sound, target)

					-- If breaking invisibility, play the sound and particle of critstab
					if parent:HasModifier("modifier_imba_riki_invisibility") then
						local sucker_particle = ParticleManager:CreateParticle(sucker_punch_particle, PATTACH_ABSORIGIN_FOLLOW, target)
						ParticleManager:SetParticleControlEnt(sucker_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,-100) , true)
						ParticleManager:ReleaseParticleIndex(sucker_particle)
						EmitSoundOn(backstab_invisbreak_sound, target)
					end

					-- If the attacker is an illusion, don't apply the damage
					if not parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier, damage_type = ability:GetAbilityDamageType()})
						backbreak = true
					end
					parent:AddNewModifier(parent, self, "modifier_imba_riki_backstab_translation", {duration = parent:GetAttackSpeed()})


					-- If the attacker is not in backstab angle but the target has the smoke screen modifier
				elseif target:HasModifier("modifier_imba_smoke_screen_debuff_miss") then

					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(backstab_sound, target)

					-- If breaking invisibility, play the sound and particle of critstab
					if parent:HasModifier("modifier_imba_riki_invisibility") then
						local sucker_particle = ParticleManager:CreateParticle(sucker_punch_particle, PATTACH_ABSORIGIN_FOLLOW, target)
						ParticleManager:SetParticleControlEnt(sucker_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,-100) , true)
						ParticleManager:ReleaseParticleIndex(sucker_particle)
						EmitSoundOn(backstab_invisbreak_sound, target)
					end

					-- If the attacker is an illusion, don't apply the damage
					if not parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier_smoke, damage_type = ability:GetAbilityDamageType()})
						backbreak = true
					end
					parent:AddNewModifier(parent, self, "modifier_imba_riki_backstab_translation", {duration = parent:GetAttackSpeed()})

					-- #4 Talent: Riki now applies Sidestab at reduced multiplier
				elseif parent:HasTalent("special_bonus_imba_riki_4") and result_angle >= (180 - (parent:FindTalentValue("special_bonus_imba_riki_4","sidestab_angle") / 2)) and result_angle <= (180 + (parent:FindTalentValue("special_bonus_imba_riki_4","sidestab_angle") / 2)) then

					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(backstab_sound, target)

					-- If breaking invisibility, play the sound and particle of critstab
					if parent:HasModifier("modifier_imba_riki_invisibility") then
						local sucker_particle = ParticleManager:CreateParticle(sucker_punch_particle, PATTACH_ABSORIGIN_FOLLOW, target)
						ParticleManager:SetParticleControlEnt(sucker_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin() + Vector(0,0,-100) , true)
						ParticleManager:ReleaseParticleIndex(sucker_particle)
						EmitSoundOn(backstab_invisbreak_sound, target)
					end

					-- If the attacker is an illusion, don't apply the damage
					if not parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier_side, damage_type = ability:GetAbilityDamageType()})
						backbreak = true
					end
					parent:AddNewModifier(parent, self, "modifier_imba_riki_backstab_translation", {duration = parent:GetAttackSpeed()})

				end

				-- #7 Talent: 4 Consecutive Backstabs applies Break on the target for 5 seconds.
				local backbreaker_mod = target:FindModifierByName("modifier_imba_riki_backbreaker")
				if backbreak then
					if backbreaker_mod then
						backbreaker_mod:ForceRefresh()
					else
						backbreaker_mod = target:AddNewModifier(parent,ability,"modifier_imba_riki_backbreaker",{duration = parent:FindTalentValue("special_bonus_imba_riki_7","duration")})
					end
				else
					if backbreaker_mod then
						backbreaker_mod:Destroy()
					end
				end

			end

			-- Remove the Invisibility given by Smokescreen on #3 talent
			if parent:HasModifier("modifier_imba_smoke_screen_invi") then
				parent:RemoveModifierByName("modifier_imba_smoke_screen_invi")
			end
			-- Set skill cooldown to fade time (cooldown is used as an indicator for invis and backstab break bonus)
			-- Checks if its smaller than the fade time (Should this behavior apply?)
			if ability:GetCooldownTimeRemaining() < fade_time then
				ability:StartCooldown(fade_time)
			end
		end
	end
end

----------------------------------------------
-----	Cloak and Dagger invisibility	  ----
----------------------------------------------
modifier_imba_riki_invisibility = modifier_imba_riki_invisibility or class({})

function modifier_imba_riki_invisibility:IsPurgable() return false end
function modifier_imba_riki_invisibility:IsDebuff() return false end
function modifier_imba_riki_invisibility:IsHidden()	return false end

function modifier_imba_riki_invisibility:OnCreated()
	local particle = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_imba_riki_invisibility:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_INVISIBILITY_LEVEL, }
	return funcs
end

function modifier_imba_riki_invisibility:GetModifierInvisibilityLevel()
	if IsClient() then
		return 1
	end
end

function modifier_imba_riki_invisibility:CheckState()
	if IsServer() then
		local state = { [MODIFIER_STATE_INVISIBLE] = true}
		return state
	end
end
----------------------------------------------
-----	Cloak and Dagger attack-translate ----
----------------------------------------------
modifier_imba_riki_backstab_translation = modifier_imba_riki_backstab_translation or class({})
function modifier_imba_riki_backstab_translation:IsPurgable() return false end
function modifier_imba_riki_backstab_translation:IsDebuff() return false end
function modifier_imba_riki_backstab_translation:IsHidden()	return true end

function modifier_imba_riki_backstab_translation:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, }
	return funcs
end

function modifier_imba_riki_backstab_translation:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_riki" then
		return "backstab"
	end
	return 0
end

-------------------------------------------------------------------------------------
--------------------	Cloak and Dagger Peek A Boo talent		---------------------
-------------------------------------------------------------------------------------

modifier_imba_riki_peek_a_boo = modifier_imba_riki_peek_a_boo or class({})
function modifier_imba_riki_peek_a_boo:IsPurgable() return false end
function modifier_imba_riki_peek_a_boo:IsDebuff() return false end
function modifier_imba_riki_peek_a_boo:IsHidden() return false end

-------------------------------------------------------------------------------------
--------------------	Cloak and Dagger Peek Backbreaker	  -----------------------
-------------------------------------------------------------------------------------

modifier_imba_riki_backbreaker = modifier_imba_riki_backbreaker or class({})
function modifier_imba_riki_backbreaker:IsPurgable() return false end
function modifier_imba_riki_backbreaker:IsDebuff() return true end
function modifier_imba_riki_backbreaker:IsHidden() return false end

function modifier_imba_riki_backbreaker:OnCreated()
	self:SetStackCount(1)
end

function modifier_imba_riki_backbreaker:OnRefresh()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()

		self:IncrementStackCount()
		if self:GetStackCount() >= caster:FindTalentValue("special_bonus_imba_riki_7") then

			-- Play the Backbreaker particle and sound
			local backbreak_particle_fx = ParticleManager:CreateParticle("particles/hero/riki/riki_backbreaker_slash.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
			ParticleManager:SetParticleControlEnt(backbreak_particle_fx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(backbreak_particle_fx)
			EmitSoundOn("Imba.RikiCritStab", parent)

			parent:AddNewModifier(caster,ability,"modifier_imba_riki_backbroken",{duration = caster:FindTalentValue("special_bonus_imba_riki_7","break_duration")})
			self:Destroy()
		end
	end
end

modifier_imba_riki_backbroken = modifier_imba_riki_backbroken or class({})
function modifier_imba_riki_backbroken:IsPurgable() return true end
function modifier_imba_riki_backbroken:IsDebuff() return true end
function modifier_imba_riki_backbroken:IsHidden() return false end

function modifier_imba_riki_backbroken:CheckState()
	return {[MODIFIER_STATE_PASSIVES_DISABLED] = true}
end

---------------------------------------------------------------------
--------------------	Tricks of the Trade		---------------------
---------------------------------------------------------------------
if imba_riki_tricks_of_the_trade == nil then imba_riki_tricks_of_the_trade = class({}) end
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_primary", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_secondary", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Attacks a single enemy based on attack speed
LinkLuaModifier( "modifier_imba_martyrs_mark", "components/abilities/heroes/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )

function imba_riki_tricks_of_the_trade:GetAbilityTextureName()
	return "riki_tricks_of_the_trade"
end

function imba_riki_tricks_of_the_trade:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function imba_riki_tricks_of_the_trade:IsNetherWardStealable()
	return false
end

function imba_riki_tricks_of_the_trade:GetChannelTime()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_duration")
	else
		return self:GetSpecialValueFor("channel_duration")
	end
end

function imba_riki_tricks_of_the_trade:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cast_range") end

	return self:GetSpecialValueFor("area_of_effect")
end

function imba_riki_tricks_of_the_trade:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") end

function imba_riki_tricks_of_the_trade:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetAbsOrigin()
		local aoe = self:GetSpecialValueFor("area_of_effect")
		local target = self:GetCursorTarget()

		self.channel_start_time = GameRules:GetGameTime()

		if caster:HasScepter() then
			origin = target:GetAbsOrigin() end

		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_primary", {})
		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_secondary", {})

		local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
		local tricks_particle = "particles/units/heroes/hero_riki/riki_tricks.vpcf"
		local cast_sound = "Hero_Riki.TricksOfTheTrade.Cast"
		local continous_sound = "Hero_Riki.TricksOfTheTrade"
		local buttsecks_sound = "Imba.RikiSurpriseButtsex"

		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		if #heroes >= PlayerResource:GetPlayerCount() * 0.35 then
			-- caster:EmitSound(buttsecks_sound)
			EmitSoundOn(buttsecks_sound, caster)
		end

		EmitSoundOnLocationWithCaster(origin, cast_sound, caster)
		EmitSoundOn(continous_sound, caster)

		local caster_loc = caster:GetAbsOrigin()

		if caster:HasScepter() and target ~= caster then
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)


			ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
		else
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)


			ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
		end

		ParticleManager:SetParticleControl(self.TricksParticle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.TricksParticle, 1, Vector(aoe, 0, aoe))
		ParticleManager:SetParticleControl(self.TricksParticle, 2, Vector(aoe, 0, aoe))

		caster:AddNoDraw()
	end
end

function imba_riki_tricks_of_the_trade:OnChannelThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		if caster:HasScepter() and target and target ~= caster then
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
			ParticleManager:SetParticleControl(self.TricksParticle, 0, origin)
			ParticleManager:SetParticleControl(self.TricksParticle, 3, origin)
		end
	end
end

function imba_riki_tricks_of_the_trade:OnChannelFinish()
	if IsServer() then
		local caster = self:GetCaster()
		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:RemoveModifierByName("modifier_imba_riki_tricks_of_the_trade_primary")
		caster:RemoveModifierByName("modifier_imba_riki_tricks_of_the_trade_secondary")
		if backstab_ability and backstab_ability:GetLevel() > 0 then backstab_ability:EndCooldown() end

		StopSoundEvent("Hero_Riki.TricksOfTheTrade", caster)
		StopSoundEvent("Imba.RikiSurpriseButtsex", caster)
		ParticleManager:DestroyParticle(self.TricksParticle, false)
		ParticleManager:ReleaseParticleIndex(self.TricksParticle)
		self.TricksParticle = nil

		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)

		-- #6 Talent: Tricks of the Trade refunds cooldown proportional to the channel duration remaining_duration
		if caster:HasTalent("special_bonus_imba_riki_6") then
			local channel_time = GameRules:GetGameTime() - self.channel_start_time
			local channel_duration = self:GetSpecialValueFor("channel_duration")
			if caster:HasScepter() then
				channel_duration = self:GetSpecialValueFor("scepter_duration")
			end
			local portion_refunded = channel_time/channel_duration
			local new_cooldown = self:GetCooldownTimeRemaining() * (portion_refunded)
			if new_cooldown < caster:FindTalentValue("special_bonus_imba_riki_6") and new_cooldown ~= 0 then
				new_cooldown = caster:FindTalentValue("special_bonus_imba_riki_6")
			end
			self:EndCooldown()
			self:StartCooldown(new_cooldown)
		end
	end
end

----------------------------------------------
-----	Tricks of the Trade modifier	  ----
----------------------------------------------
if modifier_imba_riki_tricks_of_the_trade_primary == nil then modifier_imba_riki_tricks_of_the_trade_primary = class({}) end
function modifier_imba_riki_tricks_of_the_trade_primary:IsPurgable() return false end
function modifier_imba_riki_tricks_of_the_trade_primary:IsDebuff() return false end
function modifier_imba_riki_tricks_of_the_trade_primary:IsHidden() return false end

function modifier_imba_riki_tricks_of_the_trade_primary:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, }
	return funcs
end

function modifier_imba_riki_tricks_of_the_trade_primary:GetModifierAttackRangeBonus()
	local ability = self:GetAbility()
	local aoe = ability:GetSpecialValueFor("area_of_effect")
	return aoe
end

function modifier_imba_riki_tricks_of_the_trade_primary:CheckState()
	if IsServer() then
		local state

		if self:GetParent():HasScepter() and self:GetAbility():GetCursorTarget() == self:GetParent() then
			state = {	[MODIFIER_STATE_INVULNERABLE] = true,
				--	[MODIFIER_STATE_UNSELECTABLE] = true,		Temporary Solution to self-casting getting cancelled
				--	[MODIFIER_STATE_OUT_OF_GAME] = true,		Side effects - Caster will still be selectable with drag-box, and will interact with skillshots (like meat hook)
				[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		else
			state = {	[MODIFIER_STATE_INVULNERABLE] = true,
				[MODIFIER_STATE_UNSELECTABLE] = true,
				[MODIFIER_STATE_OUT_OF_GAME] = true,
				[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		end

		return state
	end
end

function modifier_imba_riki_tricks_of_the_trade_primary:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("attack_interval")
		self:OnIntervalThink()
		self:StartIntervalThink(interval)
	end
end

function modifier_imba_riki_tricks_of_the_trade_primary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		if caster:HasScepter() then
			local target = ability:GetCursorTarget()
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
		end

		local aoe = ability:GetSpecialValueFor("area_of_effect")

		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)

		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				caster:PerformAttack(unit, true, true, true, false, false, false, false)

				if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
					local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")

					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)

					EmitSoundOn(backstab_sound, unit)
					ApplyDamage({victim = unit, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})

					-- #7 Talent: 4 Consecutive Backstabs applies Break on the target for 5 seconds.
					if caster:HasTalent("special_bonus_imba_riki_7") then
						local backbreaker_mod = unit:FindModifierByName("modifier_imba_riki_backbreaker")
						if backbreaker_mod then
							backbreaker_mod:ForceRefresh()
						else
							backbreaker_mod = unit:AddNewModifier(caster,backstab_ability,"modifier_imba_riki_backbreaker",{duration = caster:FindTalentValue("special_bonus_imba_riki_7","duration")})
						end
					end
				end
			end
			
			return
		end
	end
end

------------------------------------------------------
-----	Tricks of the Trade secondary attacks	  ----
------------------------------------------------------
if modifier_imba_riki_tricks_of_the_trade_secondary == nil then modifier_imba_riki_tricks_of_the_trade_secondary = class({}) end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsPurgable() return false end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsDebuff() return false end
function modifier_imba_riki_tricks_of_the_trade_secondary:IsHidden() return true end

function modifier_imba_riki_tricks_of_the_trade_secondary:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local aps = parent:GetAttacksPerSecond()
		self:StartIntervalThink(1/aps)
	end
end

function modifier_imba_riki_tricks_of_the_trade_secondary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		if caster:HasScepter() then
			local target = ability:GetCursorTarget()
			origin = target:GetAbsOrigin()
			caster:SetAbsOrigin(origin)
		end

		local aoe = ability:GetSpecialValueFor("area_of_effect")

		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)

		-- #2 Talent: Tricks of the Trade now applies martyrs Mark on the target, targets with martyrs Mark becomes more likely to be targetted by Marty's Strike
		local martyrs_mark_targets = nil
		if caster:HasTalent("special_bonus_imba_riki_2") then
			for _,unit in pairs(targets) do
				if unit:IsAlive() and not unit:IsAttackImmune() then
					local martyrs_mark_mod = unit:FindModifierByName("modifier_imba_martyrs_mark")
					if martyrs_mark_mod then
						if not martyrs_mark_targets then
							martyrs_mark_targets = {}
						end
						table.insert(martyrs_mark_targets,unit)
					end
				end
			end
		end

		-- Check
		if martyrs_mark_targets then

			local martyrs_mark_stacks
			local martyrs_mark_target = nil
			local martyrs_mark_checklist = {}
			local highest_stack = 0
			local martyrs_mark_checked = false

			-- Check for targets from the highest stack count to lowest stack count
			for i=1,#martyrs_mark_targets,1 do
				for _,target in pairs(martyrs_mark_targets) do
					martyrs_mark_checked = false
					local martyrs_mark_mod = target:FindModifierByName("modifier_imba_martyrs_mark")
					if martyrs_mark_mod then
						for _,check_target in pairs(martyrs_mark_checklist) do
							if check_target == target then
								martyrs_mark_checked = true
							end
						end
						if not martyrs_mark_checked then
							if martyrs_mark_mod:GetStackCount() > highest_stack then
								martyrs_mark_stacks = martyrs_mark_mod:GetStackCount()
								highest_stack = martyrs_mark_stacks
								martyrs_mark_target = target
							end
						end
					end
				end

				-- Get the proc chance for martyrs Mark, the formula goes like this
				-- 3 targets causes a target to have 33% chance
				-- 5 Martyr's Mark stacks causes the target to have 66% chance to be stroke
				-- 10 Martyr's Mark stacks causes the target to have 99% chance to be stroke
				-- 15 Martyr's Mark stacks causes the target to have 132% chance to be stroke
				local proc_chance = (1/#targets) * (1+martyrs_mark_stacks*caster:FindTalentValue("special_bonus_imba_riki_2")*0.01) * 100

				-- Don't roll the dice, don't do it Cuphead! D:
				if RollPercentage(proc_chance) or proc_chance >= 100 then
					self:ProcTricks(caster,ability,martyrs_mark_target,backstab_ability,backstab_particle,backstab_sound,caster:FindTalentValue("special_bonus_imba_riki_2","duration"))

					local caster = self:GetParent()
					local aps = caster:GetAttacksPerSecond()
					self:StartIntervalThink(1/aps)
					return
				end
				-- If the marked target doesn't get hit, add him into the checklist
				table.insert(martyrs_mark_checklist, martyrs_mark_target)
			end
		end

		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				self:ProcTricks(caster,ability,unit,backstab_ability,backstab_particle,backstab_sound,caster:FindTalentValue("special_bonus_imba_riki_2","duration"))

				local caster = self:GetParent()
				local aps = caster:GetAttacksPerSecond()
				self:StartIntervalThink(1/aps)
				return
			end
		end
	end
end

function modifier_imba_riki_tricks_of_the_trade_secondary:ProcTricks(caster,ability,target,backstab_ability,backstab_particle,backstab_sound,talent_duration)
	if caster:HasTalent("special_bonus_imba_riki_2") then
		local martyrs_mark_mod = target:FindModifierByName("modifier_imba_martyrs_mark")
		if martyrs_mark_mod then
			martyrs_mark_mod:ForceRefresh()
		else
			martyrs_mark_mod = target:AddNewModifier(caster,ability,"modifier_imba_martyrs_mark",{duration = talent_duration})
		end
	end

	caster:PerformAttack(target, true, true, true, false, false, false, false)

	if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
		local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")

		local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)

		EmitSoundOn(backstab_sound, target)
		ApplyDamage({victim = target, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})

		-- #7 Talent: 4 Consecutive Backstabs applies Break on the target for 5 seconds.
		if caster:HasTalent("special_bonus_imba_riki_7") then
			local backbreaker_mod = target:FindModifierByName("modifier_imba_riki_backbreaker")
			if backbreaker_mod then
				backbreaker_mod:ForceRefresh()
			else
				backbreaker_mod = target:AddNewModifier(caster,backstab_ability,"modifier_imba_riki_backbreaker",{duration = caster:FindTalentValue("special_bonus_imba_riki_7","duration")})
			end
		end
	end
end

-------------------------------------
---------	Martyr's Mark	---------
-------------------------------------

if modifier_imba_martyrs_mark == nil then modifier_imba_martyrs_mark = class({}) end
function modifier_imba_martyrs_mark:IsPurgable() return false end
function modifier_imba_martyrs_mark:IsDebuff() return true end
function modifier_imba_martyrs_mark:IsHidden() return false end

function modifier_imba_martyrs_mark:OnCreated()
	if IsServer() then
		local parent = self:GetParent()

		self.particle_mark_fx = ParticleManager:CreateParticle("particles/hero/riki/riki_martyr_dagger_start_pos.vpcf", PATTACH_OVERHEAD_FOLLOW, parent)
		ParticleManager:SetParticleControlEnt(self.particle_mark_fx, 0, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle_mark_fx, 1, parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		self:AddParticle(self.particle_mark_fx, false, false, -1, false, true)

		self:SetStackCount(1)
	end
end

function modifier_imba_martyrs_mark:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end

-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_riki", MotionController)
end
-------------------------------------------
