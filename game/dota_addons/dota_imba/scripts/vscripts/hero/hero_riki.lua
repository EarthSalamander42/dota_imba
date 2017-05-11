--	Author: zimberzimber
--	Date:	19.2.2017
	
CreateEmptyTalents("riki")

---------------------------------------------------------------------
-------------------------	Smoke Screen	-------------------------
---------------------------------------------------------------------
if imba_riki_smoke_screen == nil then imba_riki_smoke_screen = class({}) end
LinkLuaModifier( "modifier_imba_riki_smoke_screen_handler", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Aura that applies the debuff
LinkLuaModifier( "modifier_imba_riki_smoke_screen_debuff", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )			-- Silence, miss, turn rate slow, slow
LinkLuaModifier( "modifier_imba_riki_smoke_screen_vision_debuff", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Reduces vision in comparison to smoke centre

function imba_riki_smoke_screen:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE end

function imba_riki_smoke_screen:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_riki_2") end

function imba_riki_smoke_screen:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_1") end

function imba_riki_smoke_screen:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_point = self:GetCursorPosition()
		local smoke_particle = "particles/units/heroes/hero_riki/riki_smokebomb.vpcf"
		
		local duration = self:GetSpecialValueFor("duration")
		local aoe = self:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_dazzle_1")
		local smoke_handler = "modifier_imba_riki_smoke_screen_handler"
		local smoke_sound = "Hero_Riki.Smoke_Screen"

		EmitSoundOnLocationWithCaster(target_point, smoke_sound, caster)
		
		local dummy = CreateUnitByName("npc_dummy_unit", target_point, false, caster, caster, caster:GetTeamNumber())
		dummy:AddNewModifier(caster, self, smoke_handler, {duration = duration})
		
		local particle = ParticleManager:CreateParticle(smoke_particle, PATTACH_WORLDORIGIN, dummy)
			ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(aoe, 0, aoe))
			
		Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
			dummy:Destroy()
		end)
	end
end

---------------------------------
-----	Smoke Screen Aura	-----
---------------------------------
if modifier_imba_riki_smoke_screen_handler == nil then modifier_imba_riki_smoke_screen_handler = class({}) end
function modifier_imba_riki_smoke_screen_handler:IsPurgable() return false end
function modifier_imba_riki_smoke_screen_handler:IsHidden() return true end
function modifier_imba_riki_smoke_screen_handler:IsAura() return true end

function modifier_imba_riki_smoke_screen_handler:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_riki_smoke_screen_handler:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end

function modifier_imba_riki_smoke_screen_handler:GetModifierAura()
	return "modifier_imba_riki_smoke_screen_debuff" end
	
function modifier_imba_riki_smoke_screen_handler:GetAuraRadius()	
	local ability = self:GetAbility()
	local aoe = ability:GetSpecialValueFor("area_of_effect")
	return aoe	
end

function modifier_imba_riki_smoke_screen_handler:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
		self:GetParent().afflicted = {}
	end
end

function modifier_imba_riki_smoke_screen_handler:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = ability:GetCaster()
	local parent = self:GetParent()
		
	local aoe = self:GetAbility():GetSpecialValueFor("area_of_effect")
	local max_reduction = ability:GetSpecialValueFor("max_vision_reduction_pcnt")
	
	local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	
	-- black magic starts here
	for _, unit in pairs(targets) do
	
		-- If the unit was never afflicted with a modifier instance from this handler, give it the modifier and index it along with the units ID
		if not parent.afflicted[unit:entindex()] then
			local mod = unit:AddNewModifier(caster, self:GetAbility(), "modifier_imba_riki_smoke_screen_vision_debuff", {})
			table.insert(parent.afflicted, unit:entindex(), mod)
			
		else
			-- If the parent somehow (death for example) lost the modifier and got back into the smoke(glimpse, timelapse), reapply and re-index it
			if not parent.afflicted[unit:entindex()] then
				local mod = unit:AddNewModifier(caster, self:GetAbility(), "modifier_imba_riki_smoke_screen_vision_debuff", {})
				table.insert(parent.afflicted, unit:entindex(), mod)
			end
			
			-- Calculate the distances between the mid point of the handlers dummy and the unit, and then convert it to % distance from closest to furthest
			local distance = CalcDistanceBetweenEntityOBB(parent, unit)
			local stacks = math.ceil(max_reduction * (100 - (distance * 100 / aoe)) / 100) + 1
			
			-- Check if this modifier instance is the strongest of all the other instances the unit might have
			local isStrongest = true
			local duplicateMods = unit:FindAllModifiersByName("modifier_imba_riki_smoke_screen_vision_debuff")
			for _,modifier in pairs(duplicateMods) do
				if not modifier:IsNull() then
					if modifier ~= parent.afflicted[unit:entindex()] then
						if modifier:GetStackCount() >= stacks then
							-- If not, set the stacks of the instance applied by this handler to 0 and break out of this loop
							parent.afflicted[unit:entindex()]:SetStackCount(0)
							isStrongest = false
							break
						end
					end
				end
			end
			
			-- If it is the strongest, apply the stacks normally
			if isStrongest then parent.afflicted[unit:entindex()]:SetStackCount(stacks) end
		end
	end
	
	for index, modifier in pairs(parent.afflicted) do
		local unit = EntIndexToHScript(index)
		local distance = CalcDistanceBetweenEntityOBB(parent, unit)
		if distance > aoe then modifier:SetStackCount(0) end
	end
end

function modifier_imba_riki_smoke_screen_handler:OnDestroy()
	if IsServer() then
		for _, modifier in pairs(self:GetParent().afflicted) do
			if not modifier:IsNull() then modifier:Destroy() end
		end
	end
end

-----------------------------------
-----	Smoke Screen Debuff	  -----
-----------------------------------
if modifier_imba_riki_smoke_screen_debuff == nil then modifier_imba_riki_smoke_screen_debuff = class({}) end
function modifier_imba_riki_smoke_screen_debuff:IsPurgable() return false end
function modifier_imba_riki_smoke_screen_debuff:IsHidden() return false end
function modifier_imba_riki_smoke_screen_debuff:IsDebuff() return true end

function modifier_imba_riki_smoke_screen_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_imba_riki_smoke_screen_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_riki_smoke_screen_debuff:CheckState()
	local state = { [MODIFIER_STATE_SILENCED] = true}
	return state
end

function modifier_imba_riki_smoke_screen_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MISS_PERCENTAGE,
					MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, }
	return funcs
end

function modifier_imba_riki_smoke_screen_debuff:GetModifierMiss_Percentage()
	local ability = self:GetAbility()
	local miss_chance = ability:GetSpecialValueFor("miss_chance")
	return miss_chance
end

function modifier_imba_riki_smoke_screen_debuff:GetModifierTurnRate_Percentage()
	local ability = self:GetAbility()
	local turn_slow = ability:GetSpecialValueFor("turn_rate_slow")*-1
	return turn_slow
end

function modifier_imba_riki_smoke_screen_debuff:GetModifierMoveSpeedBonus_Percentage()
	local ability = self:GetAbility()
	local slow = ability:GetSpecialValueFor("slow")*-1
	return slow
end

-------------------------------------------
-----	Smoke Screen Vision Debuff	  -----
-------------------------------------------
if modifier_imba_riki_smoke_screen_vision_debuff == nil then modifier_imba_riki_smoke_screen_vision_debuff = class({}) end
function modifier_imba_riki_smoke_screen_vision_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_riki_smoke_screen_vision_debuff:IsPurgable() return false end
function modifier_imba_riki_smoke_screen_vision_debuff:IsHidden() return true end
function modifier_imba_riki_smoke_screen_vision_debuff:IsDebuff() return true end

function modifier_imba_riki_smoke_screen_vision_debuff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, }
	return funcs
end

function modifier_imba_riki_smoke_screen_vision_debuff:GetBonusVisionPercentage()
	return self:GetStackCount() * -1
end

---------------------------------------------------------------------
-------------------------	Blink Strike	-------------------------
---------------------------------------------------------------------
if imba_riki_blink_strike == nil then imba_riki_blink_strike = class({}) end
LinkLuaModifier( "modifier_imba_riki_blink_strike_on_cast", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_riki_blink_strike_debuff", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )					-- Turn rate slow
LinkLuaModifier( "modifier_imba_riki_blink_strike_outofworld", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )				-- Sets the caster out of world for Blink Strike jumping
LinkLuaModifier( "modifier_imba_riki_blink_strike_small_range_indicator", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Small cast range indicator

function imba_riki_blink_strike:GetCastRange()
	local baseCastRange = self:GetSpecialValueFor("no_jump_cast_range")
	local bonusPerJump = self:GetSpecialValueFor("jump_range")
	local jumps = self:GetSpecialValueFor("max_jumps") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_3")
	
	if IsServer() then
		return baseCastRange + bonusPerJump * jumps - GetCastRangeIncrease(self:GetCaster()) end
	return baseCastRange + bonusPerJump * jumps	-- Because client cant 'GetCastRangeIncrease', FU client
end

function imba_riki_blink_strike:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES  end

function imba_riki_blink_strike:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:IsOwnedByAnyPlayer() and not caster:IsIllusion() and self:GetSpecialValueFor("max_jumps") > 0 then
			caster:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_small_range_indicator", {})
		end
	end
end

function imba_riki_blink_strike:OnUnStolen()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_riki_blink_strike_small_range_indicator") then
			caster:RemoveModifierByName("modifier_imba_riki_blink_strike_small_range_indicator")
		end
	end
end

function imba_riki_blink_strike:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local target_pos = target:GetAbsOrigin()
		local damage = self:GetSpecialValueFor("damage")
		local duration = self:GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_4")
		
		local victim_angle = target:GetAnglesAsVector()
		local victim_forward_vector = target:GetForwardVector()
		local cast_sound = "Hero_Riki.Blink_Strike"
		local jump_sound = "Hero_PhantomAssassin.Strike.Start"
		local blink_particle = "particles/units/heroes/hero_riki/riki_blink_strike.vpcf"
		
		-- Proc Linkens, damage, and apply debuff if the target is an enemy
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			if target:TriggerSpellAbsorb(self) then return end
			ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_debuff", {duration = duration})
		end
		
		-- Calculate position behind the target
		local victim_angle_rad = victim_angle.y*math.pi/180
		local victim_position = target:GetAbsOrigin()
		local new_position = Vector(victim_position.x - 100 * math.cos(victim_angle_rad), victim_position.y - 100 * math.sin(victim_angle_rad), 0)
		
		-- If there were units used as jump pads
		if self.jumpTargets[1] then
			
			caster:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_outofworld", {})
			
			local jumpDelay = 0.1
			local reversedTable = { caster }
			local length = #self.jumpTargets
			for k,v in ipairs(self.jumpTargets) do
				reversedTable[length + 1 - k + 1] = v
			end
			
			for k,v in ipairs(reversedTable) do
				if k ~= #reversedTable then
					Timers:CreateTimer(jumpDelay * (k - 1), function()
						local first = reversedTable[k]
						local second = reversedTable[k+1]
						local particle = ParticleManager:CreateParticle(blink_particle, PATTACH_POINT, first)
							ParticleManager:SetParticleControl(particle, 1, second:GetAbsOrigin())
							ParticleManager:ReleaseParticleIndex(particle)
						
						EmitSoundOn(cast_sound, first)
						caster:SetAbsOrigin(second:GetAbsOrigin())
					end)
				else
					Timers:CreateTimer(jumpDelay * (k - 1), function()
						caster:RemoveModifierByName("modifier_imba_riki_blink_strike_outofworld")
						
					-- Set the casters position behind the target (psssh nothin' personnel kid)
					FindClearSpaceForUnit(caster, new_position, true)
					caster:SetForwardVector(victim_forward_vector)
					
					-- Attack order on target - same behavior as 'A' clicking
					local order = 
					{	UnitIndex = caster:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
						TargetIndex = target:entindex(),
						AbilityIndex = self,
						Queue = true }
					ExecuteOrderFromTable(order)
					end)
				end
			end
			
			
		else
			EmitSoundOn(cast_sound, caster)
			local particle = ParticleManager:CreateParticle(blink_particle, PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				
			-- Set the casters position behind the target (psssh nothin' personnel kid)
			FindClearSpaceForUnit(caster, new_position, true)
			caster:SetForwardVector(victim_forward_vector)
			
			-- Attack order on target - same behavior as 'A' clicking
			local order = 
			{	UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = target:entindex(),
				AbilityIndex = self,
				Queue = true }
			ExecuteOrderFromTable(order)
		end
	end
end

function imba_riki_blink_strike:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()		
		caster:AddNewModifier(caster, self, "modifier_imba_riki_blink_strike_on_cast", {})

		-- Can't cast on self, buildings, or spell immune
		if target:IsBuilding() then
			return UF_FAIL_BUILDING
		elseif caster == target then
			return UF_FAIL_CUSTOM
		elseif target:IsMagicImmune() then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local jump_check_result = self:BeginJumpCheck(target)

		if jump_check_result then
			return UF_SUCCESS
		end

		caster:MoveToTargetToAttack(target)
		self.caster = caster
		self.target = target		

		Timers:CreateTimer(function()			
			if self:BeginJumpCheck(self.target) then
				self.caster:CastAbilityOnTarget(self.target, self, self.caster:GetEntityIndex())
			else
				if self.caster:HasModifier("modifier_imba_riki_blink_strike_on_cast") then
					return FrameTime()
				end
			end
		end)		
	end
end

function imba_riki_blink_strike:BeginJumpCheck(target)
	if IsServer() then
		-- Clear tables
		self.jumpTargets = {}
		self.checkedTargets = {}
		
		-- Get Values
		local jumps = self:GetSpecialValueFor("max_jumps") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_3")
		local jump_range = self:GetSpecialValueFor("jump_range")
		local no_jump_cast_range = self:GetSpecialValueFor("no_jump_cast_range")
		
		-- See if the target is within the no-jump cast range
		local caster_target_distance = CalcDistanceBetweenEntityOBB(caster, target)	-- Distance between caster and target
		if caster_target_distance <= no_jump_cast_range then return UF_SUCCESS end	-- If target is whithin no jump cast range
		
		-- Index the filter for later use in the recoursion
		local find_filter = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
		
		-- o boi here we go
		-- Find units around the caster, starting from the furtherest
		if jumps > 0 then -- See if the caster can jump
			local jumppable_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, no_jump_cast_range, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
			for _, unit in pairs(jumppable_units) do
			
				-- See if the unit was already checked
				if unit ~= caster and not self.checkedTargets[unit:entindex()] then
				
					-- index the unit so he won't be checked again until next cast
					-- the entity index of the unit is used so its easier to find
					self.checkedTargets[unit:entindex()] = unit
					
					-- Add all units in a small AoE around the current unit to the checked table to reduce clutter from units that are too close to each other (Broodmother and the likes)
					local irrelevant_units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
					for _,IRunit in pairs(irrelevant_units) do
						if not self.checkedTargets[IRunit:entindex()] then
							self.checkedTargets[IRunit:entindex()] = IRunit
						end
					end
					
					-- Get distances
					local unit_caster_distance_minimum = no_jump_cast_range - jump_range	-- Minimum distance required between unit being checked and caster
					local unit_caster_distance = CalcDistanceBetweenEntityOBB(unit, caster)	-- Distance between unit being checked and caster
					local unit_target_distance = CalcDistanceBetweenEntityOBB(unit, target)	-- Distance between unit being checked and target
					
					-- Check if the unit is closer to the target, and that it's in effective range to reach new targets outside of no-jump range
					if unit_caster_distance > unit_caster_distance_minimum and caster_target_distance > unit_target_distance then
						-- Check if JumpCheck returned true
						local foundPath = self:JumpCheck(target, unit, caster_target_distance, jump_range, find_filter, jumps-1)											
					end

					-- If a path to the target was found, index the unit and commence spell casting
					if foundPath then
						table.insert(self.jumpTargets, unit)
						return true
					end	
				end
			end
		end

		return false
	end
end
 
function imba_riki_blink_strike:JumpCheck( main_target, jump_target, caster_target_distance, jump_range, find_filter, jumps_left )
	local caster = self:GetCaster()
	
	-- Find units around the unit the caster would jump off
	local jumppable_units = FindUnitsInRadius(caster:GetTeamNumber(), jump_target:GetAbsOrigin(), nil, jump_range, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_FARTHEST, false)
	for _, unit in pairs(jumppable_units) do
	
		-- See if the unit was already checked
		if unit ~= caster and not self.checkedTargets[unit:entindex()] then
		
			-- index the unit so he won't be checked again until next cast
			self.checkedTargets[unit:entindex()] = unit
			
			-- Add all units in a small AoE around the current unit to the checked table to reduce clutter from units that are too close to each other (Broodmother and the likes)
			local irrelevant_units = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, 50, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, find_filter, FIND_FARTHEST, false)
			for _,IRunit in pairs(irrelevant_units) do
				if not self.checkedTargets[IRunit:entindex()] then
					self.checkedTargets[IRunit:entindex()] = IRunit
				end
			end
			
			-- Get distance to target
			local unit_target_distance = CalcDistanceBetweenEntityOBB(main_target, unit)		-- Distance between unit being checked and target
			local distance_to_target = CalcDistanceBetweenEntityOBB(main_target, jump_target)	-- Distance between previous unit and target
			
			-- If the main target is within range, return true and index the unit used as a jump pad
			if unit_target_distance <= jump_range then
				table.insert(self.jumpTargets, main_target)
				if unit ~= main_target then table.insert(self.jumpTargets, unit) end
				return true
			end
			-- Check if the unit is closer to the target, and that it's in effective range to reach new targets outside of no-jump range
			-- elseif distance_to_target <= unit_target_distance then
			
				-- See if there are any jumps remaining
				if jumps_left > 1 then
					-- Check if JumpCheck returned true
					local foundPath = self:JumpCheck(main_target, unit, caster_target_distance, jump_range, find_filter, jumps_left-1)
					
					-- If a path to the target was found, index the unit and commence spell casting
					if foundPath then
						table.insert(self.jumpTargets, unit)
						return true
					end
				end
			-- end
		end
	end
	return false
end

function imba_riki_blink_strike:GetCustomCastErrorTarget( target )
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

---------------------------------------------------
-----	Blink Strike Small Range modifier	  -----
---------------------------------------------------
if modifier_imba_riki_blink_strike_small_range_indicator == nil then modifier_imba_riki_blink_strike_small_range_indicator = class({}) end
function modifier_imba_riki_blink_strike_small_range_indicator:RemoveOnDeath() return false end
function modifier_imba_riki_blink_strike_small_range_indicator:IsPurgable() return false end
function modifier_imba_riki_blink_strike_small_range_indicator:IsDebuff() return false end
function modifier_imba_riki_blink_strike_small_range_indicator:IsHidden() return true end

function modifier_imba_riki_blink_strike_small_range_indicator:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		self.smallRangeParticle = ParticleManager:CreateParticleForPlayer("particles/hero/riki/secondary_range_finder.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent, parent:GetPlayerOwner())
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_riki_blink_strike_small_range_indicator:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.smallRangeParticle, true)
		ParticleManager:ReleaseParticleIndex(self.smallRangeParticle)
		self:Destroy()
	end
end

function modifier_imba_riki_blink_strike_small_range_indicator:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = parent:FindAbilityByName("imba_riki_blink_strike")
		
		if parent:IsAlive() then
			local range = ability:GetSpecialValueFor("no_jump_cast_range")
			ParticleManager:SetParticleControl(self.smallRangeParticle, 3, Vector(range, 0, 0))
		else
			ParticleManager:SetParticleControl(self.smallRangeParticle, 3, Vector(0, 0, 0))
		end
	end
end


---------------------------------------------------
-----	Blink Strike cast modifier	  -----
---------------------------------------------------
modifier_imba_riki_blink_strike_on_cast = class({})
function modifier_imba_riki_blink_strike_on_cast:IsHidden() return true end
function modifier_imba_riki_blink_strike_on_cast:IsPurgable() return false end
function modifier_imba_riki_blink_strike_on_cast:IsDebuff() return false end

function modifier_imba_riki_blink_strike_on_cast:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}

	return decFuncs
end

function modifier_imba_riki_blink_strike_on_cast:OnOrder(keys)
	local unit = keys.unit

	if unit == self:GetCaster() then
		self:Destroy()
	end
end

-----------------------------------
-----	Blink Strike Debuff	  -----
-----------------------------------
if modifier_imba_riki_blink_strike_debuff == nil then modifier_imba_riki_blink_strike_debuff = class({}) end
function modifier_imba_riki_blink_strike_debuff:IsPurgable() return true end
function modifier_imba_riki_blink_strike_debuff:IsHidden() return false end
function modifier_imba_riki_blink_strike_debuff:IsDebuff() return true end

function modifier_imba_riki_blink_strike_debuff:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, }
	return funcs
end

function modifier_imba_riki_blink_strike_debuff:GetModifierTurnRate_Percentage()
	local ability = self:GetAbility()
	local turn_slow = ability:GetSpecialValueFor("turn_rate_slow")*-1
	return turn_slow
end

---------------------------------------------------------------
-----	Blink Strike out of world modifier for jumping	  -----
---------------------------------------------------------------
if modifier_imba_riki_blink_strike_outofworld == nil then modifier_imba_riki_blink_strike_outofworld = class({}) end
function modifier_imba_riki_blink_strike_outofworld:IsPurgable() return false end
function modifier_imba_riki_blink_strike_outofworld:IsHidden() return true end
function modifier_imba_riki_blink_strike_outofworld:IsDebuff() return false end

function modifier_imba_riki_blink_strike_outofworld:GetPriority()
	return MODIFIER_PRIORITY_HIGH end
	
function modifier_imba_riki_blink_strike_outofworld:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_INVULNERABLE] = true,
						[MODIFIER_STATE_NO_HEALTH_BAR ] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		return state
	end
end

---------------------------------------------------------------------
--------------------	  Cloak and Dagger		 --------------------
---------------------------------------------------------------------
if imba_riki_cloak_and_dagger == nil then imba_riki_cloak_and_dagger = class({}) end
LinkLuaModifier( "modifier_imba_riki_cloak_and_dagger", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Backstab and invisibility handler
LinkLuaModifier( "modifier_imba_riki_invisibility", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Invisibility modifier

function imba_riki_cloak_and_dagger:GetBehavior() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
function imba_riki_cloak_and_dagger:IsRefreshable() return false end

function imba_riki_cloak_and_dagger:GetIntrinsicModifierName()
	return "modifier_imba_riki_cloak_and_dagger"
end

function imba_riki_cloak_and_dagger:OnOwnerSpawned()
	self:EndCooldown() 
end

----------------------------------------------------------
-----	Cloak and Dagger backstab + invis handler	  ----
----------------------------------------------------------
if modifier_imba_riki_cloak_and_dagger == nil then modifier_imba_riki_cloak_and_dagger = class({}) end
function modifier_imba_riki_cloak_and_dagger:IsPurgable() return false end
function modifier_imba_riki_cloak_and_dagger:IsDebuff() return false end
function modifier_imba_riki_cloak_and_dagger:IsHidden()	return true end

function modifier_imba_riki_cloak_and_dagger:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.backstab_sound = "Hero_Riki.Backstab"
		self.backstab_invisbreak_sound = "Imba.RikiCritStab"
		self.backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		
		-- Ability specials
		self.fade_time = self.ability:GetSpecialValueFor("fade_time") 
		self.agility_multiplier = self.ability:GetSpecialValueFor("agility_damage_multiplier")
		self.agility_multiplier_smoke = self.ability:GetSpecialValueFor("agility_damage_multiplier_smoke")
		self.agility_multiplier_invis_break = self.ability:GetSpecialValueFor("invis_break_agility_multiplier")		
		self.backstab_angle = self.ability:GetSpecialValueFor("backstab_angle")

		-- Ability begins with cooldown when first learned
		if self.ability:GetLevel() == 1 then
			self.ability:StartCooldown(self.ability:GetCooldown(-1))
		end

		-- Start thinking		
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_riki_cloak_and_dagger:OnRefresh()
	self:OnCreated()
end

function modifier_imba_riki_cloak_and_dagger:OnIntervalThink()
	if IsServer() then
		local fade_time = self.fade_time + self.caster:FindTalentValue("special_bonus_imba_riki_6")		
		
		-- If the owner is broken, remove invis modifier and restart cooldown
		if self.parent:PassivesDisabled() then
			
			-- Remove the invis modifier if it exists
			if self.parent:HasModifier("modifier_imba_riki_invisibility") then
				self.parent:RemoveModifierByName("modifier_imba_riki_invisibility")
			end
			
			-- Reset cooldown if it smaller than the fade time
			if self.ability:GetCooldownTimeRemaining() < fade_time then
				self.ability:StartCooldown(fade_time)
			end
		
		-- If the passive cooldown is ready
		elseif self.ability:IsCooldownReady() then
			if not self.parent:HasModifier("modifier_imba_riki_invisibility") then 
				self.parent:AddNewModifier(self.parent, self.ability, "modifier_imba_riki_invisibility", {})
			end
		
		-- If the passive is on cooldown, remove the invis modifier
		elseif self.parent:HasModifier("modifier_imba_riki_invisibility") then
			self.parent:RemoveModifierByName("modifier_imba_riki_invisibility")
		end
	end
end

function modifier_imba_riki_cloak_and_dagger:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED,}
	return funcs
end


function modifier_imba_riki_cloak_and_dagger:OnAttackLanded( keys )
	if IsServer() then
		local target = keys.target		-- Unit getting hit
		local attacker = keys.attacker	-- Unit landing the hit		
		
		-- Check if the parent is the attacker
		if self.parent == attacker then
			
			-- Get values
			local fade_time = self.fade_time - self.caster:FindTalentValue("special_bonus_imba_riki_6")		
			local agility_multiplier = self.agility_multiplier + self.caster:FindTalentValue("special_bonus_imba_riki_5")
			local agility_multiplier_smoke = self.agility_multiplier_smoke * 0.01 * agility_multiplier			
			
			-- If the target is not a building, and passives are not disabled for the passive owner
			-- Also checks if the parent is not channeling Tricks of the Trade, since backstab is handled through there.
			if not self.parent:HasModifier("modifier_imba_riki_tricks_of_the_trade_primary") and not target:IsBuilding() and not self.parent:PassivesDisabled() then
			
				-- If the passive is off cooldown, apply invis break bonus to backstab damage
				if self.ability:IsCooldownReady() and self.parent:IsInvisible() then
					agility_multiplier = agility_multiplier * self.agility_multiplier_invis_break
					agility_multiplier_smoke = agility_multiplier_smoke * self.agility_multiplier_invis_break
				end
				
				-- Find targets back
				local victim_angle = target:GetAnglesAsVector().y
				local origin_difference = target:GetAbsOrigin() - attacker:GetAbsOrigin()
				local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
				origin_difference_radian = origin_difference_radian * 180
				
				local attacker_angle = origin_difference_radian / math.pi
				attacker_angle = attacker_angle + 180.0
				
				local result_angle = attacker_angle - victim_angle
				result_angle = math.abs(result_angle)
				
				-- If the attacker is in backstab angle
				if result_angle >= (180 - (self.backstab_angle / 2)) and result_angle <= (180 + (self.backstab_angle / 2)) then
				
					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(self.backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target) 
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(self.backstab_sound, target)
					
					-- If breaking invisibility, play the critstab sound
					if self.ability:IsCooldownReady() then
						EmitSoundOn(self.backstab_invisbreak_sound, target)
					end
					
					-- If the attacker is an illusion, don't apply the damage
					if not self.parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability})
					end
				
				-- If the attacker is not in backstab angle but the target has the smoke screen modifier
				elseif target:HasModifier("modifier_imba_riki_smoke_screen_debuff") then
				
					-- Play sound and particle
					local particle = ParticleManager:CreateParticle(self.backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target) 
					ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					EmitSoundOn(self.backstab_sound, target)
					
					-- If breaking invisibility, play the critstab sound
					if self.ability:IsCooldownReady() then
						EmitSoundOn(self.backstab_invisbreak_sound, target)
					end
					
					-- If the attacker is an illusion, don't apply the damage
					if not self.parent:IsIllusion() then
						ApplyDamage({victim = target, attacker = attacker, damage = attacker:GetAgility() * agility_multiplier_smoke, damage_type = self.ability:GetAbilityDamageType()})
					end
				end
			end
			
			-- Set skill cooldown to fade time (cooldown is used as an indicator for invis and backstab break bonus)
			-- Checks if its smaller than the fade time
			if self.ability:GetCooldownTimeRemaining() < fade_time then
				self.ability:StartCooldown(fade_time)
			end
		end
	end
end

----------------------------------------------
-----	Cloak and Dagger invisibility	  ----
----------------------------------------------
if modifier_imba_riki_invisibility == nil then modifier_imba_riki_invisibility = class({}) end
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

---------------------------------------------------------------------
--------------------	Tricks of the Trade		---------------------
---------------------------------------------------------------------
if imba_riki_tricks_of_the_trade == nil then imba_riki_tricks_of_the_trade = class({}) end
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_primary", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_imba_riki_tricks_of_the_trade_secondary", "hero/hero_riki.lua", LUA_MODIFIER_MOTION_NONE )	-- Attacks a single enemy based on attack speed

function imba_riki_tricks_of_the_trade:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function imba_riki_tricks_of_the_trade:GetCastRange()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cast_range") end
		
	return self:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8")
end

function imba_riki_tricks_of_the_trade:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8") end
	
function imba_riki_tricks_of_the_trade:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetAbsOrigin()
		local aoe = self:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8")
		local target = self:GetCursorTarget()
		
		if caster:HasScepter() then
			origin = target:GetAbsOrigin() end
		
		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_primary", {})
		caster:AddNewModifier(caster, self, "modifier_imba_riki_tricks_of_the_trade_secondary", {})
			   
		local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
		local tricks_particle = "particles/units/heroes/hero_riki/riki_tricks.vpcf"
		local cast_sound = "Hero_Riki.TricksOfTheTrade.Cast"
		local continuos_sound = "Hero_Riki.TricksOfTheTrade"
		local buttsecks_sound = "Imba.RikiSurpriseButtsex"
		
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
		if #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
			-- caster:EmitSound(buttsecks_sound)
			EmitSoundOn(buttsecks_sound, caster)
		end
		
		EmitSoundOnLocationWithCaster(origin, cast_sound, caster)
		EmitSoundOn(continuos_sound, caster)
		
		self.TricksDummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
		
		if caster:HasScepter() and target ~= caster then
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_ABSORIGIN_FOLLOW , target)
			ParticleManager:CreateParticle(cast_particle, PATTACH_ABSORIGIN, self.TricksDummy)
		else
			self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_ABSORIGIN, self.TricksDummy)
			ParticleManager:CreateParticle(cast_particle, PATTACH_ABSORIGIN, self.TricksDummy)
		end
		
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
		self.TricksDummy:Destroy()
		self.TricksDummy = nil
		
		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)
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
	local aoe = ability:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8")
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
		local interval = ability:GetSpecialValueFor("attack_interval") - self:GetCaster():FindTalentValue("special_bonus_imba_riki_7")
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

		local aoe = ability:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8")
		
		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"
		
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)
		for _,unit in pairs(targets) do
			if unit:IsAlive() then
				caster:PerformAttack(unit, true, true, true, false, false, false, false)
				
				if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
					local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")
					
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit) 
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					
					EmitSoundOn(backstab_sound, unit)
					ApplyDamage({victim = unit, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})
				end
			end
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
		local multiplier = self:GetAbility():GetSpecialValueFor("scepter_attack_speed_mult")
		self:StartIntervalThink(1/aps/multiplier)
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

		local aoe = ability:GetSpecialValueFor("area_of_effect") + self:GetCaster():FindTalentValue("special_bonus_imba_riki_8")
		
		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"
		
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)
		for _,unit in pairs(targets) do
			if unit:IsAlive() then
				caster:PerformAttack(unit, true, true, true, false, false, false, false)
				
				if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
					local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")
					
					local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit) 
					ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(particle)
					
					EmitSoundOn(backstab_sound, unit)
					ApplyDamage({victim = unit, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})
				end
				
				return
			end
		end
	end
end
