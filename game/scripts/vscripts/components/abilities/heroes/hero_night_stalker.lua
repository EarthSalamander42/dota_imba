-- Author: Shush
-- Date: 5/4/2017

----------------------------------
--     Stalker in the Night     --
----------------------------------

imba_night_stalker_stalker_in_the_night = class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_stalker_in_the_night", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

function imba_night_stalker_stalker_in_the_night:GetIntrinsicModifierName()
	return "modifier_imba_stalker_in_the_night"
end

function imba_night_stalker_stalker_in_the_night:IsInnateAbility()
	return true
end

-- Stalker in the night modifier
modifier_imba_stalker_in_the_night = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_stalker_in_the_night:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.modifier_stalker = "modifier_imba_stalker_in_the_night"

	-- Ability specials
	self.vision_day_loss = self:GetAbility():GetSpecialValueFor("vision_day_loss")
	self.vision_night_gain = self:GetAbility():GetSpecialValueFor("vision_night_gain")

	if IsServer() then
		-- If it is an illusion, look for the owner
		if self.caster:IsIllusion() then
			local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				FIND_UNITS_EVERYWHERE, -- global
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD,
				FIND_CLOSEST,
				false)
			for _, hero in pairs(heroes) do
				-- Find a real Night Stalker in your team
				if hero:IsRealHero() and hero:GetUnitName() == self.caster:GetUnitName() then
					-- Find its stack count
					local modifier_stalker_handler = hero:FindModifierByName(self.modifier_stalker)
					if modifier_stalker_handler then
						local stacks = modifier_stalker_handler:GetStackCount()
						self:SetStackCount(stacks)
						break
					end
				end
			end
		end

		-- Set night mode
		self.is_day = GameRules:IsDaytime()

		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_stalker_in_the_night:OnIntervalThink()
	if IsServer() then
		-- Get current Daytime cycle
		local current_daytime = GameRules:IsDaytime()

		-- If it is now night, compare with previous statement
		if not current_daytime then
			-- If the current cycle is night and the modifier is already aware of that, do nothing
			if current_daytime == self.is_day then
				return nil
			end

			-- Otherwise, a new night has begun. Give a stack to this modifier
			self:IncrementStackCount()
		end

		-- State the current cycle in the modifier
		self.is_day = current_daytime
	end
end

function modifier_imba_stalker_in_the_night:IsHidden() return false end

function modifier_imba_stalker_in_the_night:IsPurgable() return false end

function modifier_imba_stalker_in_the_night:IsDebuff() return false end

function modifier_imba_stalker_in_the_night:RemoveOnDeath() return false end

function modifier_imba_stalker_in_the_night:DeclareFunctions()
	return { --MODIFIER_PROPERTY_BONUS_DAY_VISION,
		--MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_imba_stalker_in_the_night:OnAbilityFullyCast(keys)
	if IsServer() then
		local ability = keys.ability
		local name_ability = ability:GetName()
		local night_inducing_spells = { "imba_night_stalker_darkness", "luna_eclipse" }
		local night_spell_used = false

		-- If it is a day, do nothing
		if GameRules:IsDaytime() then return nil end

		-- Check if a night inducing spell was used
		for _, spell_name in pairs(night_inducing_spells) do
			if spell_name == name_ability then
				night_spell_used = true
			end
		end

		-- If a night inducing spell was used, increment a stack
		if night_spell_used then
			self:IncrementStackCount()
		end
	end
end

-- function modifier_imba_stalker_in_the_night:GetBonusDayVision()
-- -- If the caster is afflicted with Break, do nothing
-- if self.caster:PassivesDisabled() then return 0 end
-- return self.vision_day_loss * (-1)
-- end

-- function modifier_imba_stalker_in_the_night:GetBonusNightVision()
-- -- If the caster is afflicted with Break, do nothing
-- if self.caster:PassivesDisabled() then return 0 end

-- -- #5 Talent: Stalker in the Night night vision bonus
-- local vision_night_gain = self.vision_night_gain + self.caster:FindTalentValue("special_bonus_imba_night_stalker_5")

-- return vision_night_gain
-- end

----------------------------------
--            VOID              --
----------------------------------
imba_night_stalker_void = class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_void_ministun", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_void_slow", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

function imba_night_stalker_void:GetBehavior()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function imba_night_stalker_void:GetCastRange(location, target)
	if not self:GetCaster():HasScepter() or IsClient() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("radius_scepter") - GetCastRangeIncrease(self:GetCaster())
	end
end

function imba_night_stalker_void:GetCooldown(level)
	-- if not self:GetCaster():HasScepter() then
	return self:GetRightfulKV("AbilityCooldown")
	-- else
	-- return self:GetRightfulKV("AbilityCooldown") - self:GetSpecialValueFor("scepter_cooldown_reduction")
	-- end
end

function imba_night_stalker_void:IsHiddenWhenStolen()
	return false
end

function imba_night_stalker_void:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local rare_cast_response = "night_stalker_nstalk_ability_dark_08"
	local cast_response = { "night_stalker_nstalk_ability_void_01", "night_stalker_nstalk_ability_void_02", "night_stalker_nstalk_ability_void_03", "night_stalker_nstalk_ability_void_04" }
	local sound_cast = "Hero_Nightstalker.Void"
	local modifier_ministun = "modifier_imba_void_ministun"
	local modifier_void = "modifier_imba_void_slow"
	local modifier_darkness = "modifier_imba_darkness_night"

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")
	local day_duration = ability:GetSpecialValueFor("day_duration")
	local night_pull = ability:GetSpecialValueFor("night_pull")
	local night_duration = ability:GetSpecialValueFor("night_duration")
	local night_extend = ability:GetSpecialValueFor("night_extend")

	-- Cast responses
	-- Roll for rare response
	if RollPercentage(5) then
		EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), rare_cast_response, caster)

		-- Roll for normal response
	elseif RollPercentage(25) then
		EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), cast_response[math.random(1, #cast_response)], caster)
	end

	-- Play sound cast
	EmitSoundOn(sound_cast, caster)

	if target then
		-- If target has Linken's sphere ready, do nothing
		if caster:GetTeamNumber() ~= target:GetTeamNumber() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end

		-- Damage target
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		}

		ApplyDamage(damageTable)

		-- Apply ministun on target
		target:AddNewModifier(caster, ability, modifier_ministun, { duration = ministun_duration * (1 - target:GetStatusResistance()) })

		-- -- Set duration variable
		local duration

		-- -- If Night Stalker has Darkness active, lengthen it
		if caster:HasModifier(modifier_darkness) then
			-- -- Assign night duration
			duration = night_duration

			-- local modifier_darkness_handler = caster:FindModifierByName(modifier_darkness)
			-- if modifier_darkness_handler then
			-- modifier_darkness_handler:SetDuration(modifier_darkness_handler:GetRemainingTime() + night_extend, true)
			-- modifier_darkness_handler:ForceRefresh()
			-- end
		else
			-- -- Influence the natural time flow
			-- -- Day start time
			-- local day_start = 0.25
			-- local minutes_per_day = 8
			-- local seconds_per_minute = 60

			-- -- Convert daytime to seconds
			-- local daytime_seconds = (GameRules:GetTimeOfDay() - day_start) * minutes_per_day * seconds_per_minute

			-- -- Negative value handling
			-- if daytime_seconds < 0 then
			-- daytime_seconds = daytime_seconds + (minutes_per_day * seconds_per_minute)
			-- end

			-- Check current daytime cycle

			if GameRules:IsDaytime() then
				-- -- Assign day duration
				duration = day_duration

				-- -- If the target is a real hero, pull the night closer
				-- if target:IsRealHero() then

				-- -- Add seconds to hasten the day
				-- daytime_seconds = daytime_seconds + night_pull

				-- -- Convert daytime back to dota format
				-- local dota_daytime = (daytime_seconds / seconds_per_minute / minutes_per_day) + day_start

				-- -- Set the time of day
				-- GameRules:SetTimeOfDay(dota_daytime)
				-- end
			else
				-- -- Assign night duration
				duration = night_duration

				-- -- If the target is a real hero, extend the night
				-- if target:IsRealHero() then
				-- -- Reduce seconds to extend the night
				-- daytime_seconds = daytime_seconds - night_extend

				-- -- Convert daytime back to dota format
				-- local dota_daytime = (daytime_seconds / seconds_per_minute / minutes_per_day) + day_start

				-- -- Set the time of day
				-- GameRules:SetTimeOfDay(dota_daytime)
				-- end
			end
		end

		-- Apply Void on the target with the correct duration
		target:AddNewModifier(caster, ability, modifier_void, { duration = duration * (1 - target:GetStatusResistance()) })
	else
		-- Scepter logic
		local slow_duration = day_duration
		local stun_duration = ministun_duration

		if not GameRules:IsDaytime() then
			slow_duration = night_duration
			stun_duration = self:GetSpecialValueFor("scepter_ministun")
		end

		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		-- Maybe only let this apply Everlasting Night effect only max of one time?
		local hit_hero = false

		for _, enemy in pairs(enemies) do
			-- "Void first applies the slow debuff, then the damage, then the stun debuff."

			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_slow", { duration = slow_duration * (1 - enemy:GetStatusResistance()) })

			local damageTable =
			{
				victim      = enemy,
				attacker    = self:GetCaster(),
				damage      = damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability     = self
			}

			ApplyDamage(damageTable)

			-- Apply ministun on target
			local stun_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_void_ministun", { duration = stun_duration * (1 - enemy:GetStatusResistance()) })

			-- if not hit_hero and enemy:IsRealHero() then
			-- hit_hero = true
			-- -- Set duration variable
			-- local duration

			-- -- If Night Stalker has Darkness active, lengthen it
			-- if caster:HasModifier(modifier_darkness) then
			-- -- Assign night duration
			-- duration = night_duration

			-- local modifier_darkness_handler = caster:FindModifierByName(modifier_darkness)
			-- if modifier_darkness_handler then
			-- modifier_darkness_handler:SetDuration(modifier_darkness_handler:GetRemainingTime() + night_extend, true)
			-- modifier_darkness_handler:ForceRefresh()
			-- end
			-- else
			-- -- Influence the natural time flow
			-- -- Day start time
			-- local day_start = 0.25
			-- local minutes_per_day = 8
			-- local seconds_per_minute = 60

			-- -- Convert daytime to seconds
			-- local daytime_seconds = (GameRules:GetTimeOfDay() - day_start) * minutes_per_day * seconds_per_minute

			-- -- Negative value handling
			-- if daytime_seconds < 0 then
			-- daytime_seconds = daytime_seconds + (minutes_per_day * seconds_per_minute)
			-- end

			-- -- Check current daytime cycle

			-- if GameRules:IsDaytime() then
			-- -- Assign day duration
			-- duration = day_duration
			-- -- Add seconds to hasten the day
			-- daytime_seconds = daytime_seconds + night_pull

			-- -- Convert daytime back to dota format
			-- local dota_daytime = (daytime_seconds / seconds_per_minute / minutes_per_day) + day_start

			-- -- Set the time of day
			-- GameRules:SetTimeOfDay(dota_daytime)
			-- else
			-- -- Assign night duration
			-- duration = night_duration

			-- -- Reduce seconds to extend the night
			-- daytime_seconds = daytime_seconds - night_extend

			-- -- Convert daytime back to dota format
			-- local dota_daytime = (daytime_seconds / seconds_per_minute / minutes_per_day) + day_start

			-- -- Set the time of day
			-- GameRules:SetTimeOfDay(dota_daytime)
			-- end
			-- end
			-- end
		end
	end
end

-- Ministun modifier
modifier_imba_void_ministun = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_void_ministun:IsHidden() return false end

function modifier_imba_void_ministun:IsPurgeException() return true end

function modifier_imba_void_ministun:IsStunDebuff() return true end

function modifier_imba_void_ministun:CheckState()
	local state = { [MODIFIER_STATE_STUNNED] = true }
	return state
end

function modifier_imba_void_ministun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_void_ministun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Attack/movespeed Slow modifier
modifier_imba_void_slow = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_void_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.vision_reduction = self.ability:GetSpecialValueFor("vision_reduction")

	-- #1 Talent: Void vision reduction increase
	self.vision_reduction = self.vision_reduction + self.caster:FindTalentValue("special_bonus_imba_night_stalker_1")
end

function modifier_imba_void_slow:IsHidden() return false end

function modifier_imba_void_slow:IsPurgable() return true end

function modifier_imba_void_slow:IsDebuff() return true end

function modifier_imba_void_slow:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
	}

	return decFuncs
end

function modifier_imba_void_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_void_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_void_slow:GetBonusDayVision()
	return self.vision_reduction * (-1)
end

function modifier_imba_void_slow:GetBonusNightVision()
	return self.vision_reduction * (-1)
end

function modifier_imba_void_slow:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_void.vpcf"
end

function modifier_imba_void_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------
--        Crippling Fear        --
----------------------------------
imba_night_stalker_crippling_fear = class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_crippling_fear_silence", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

function imba_night_stalker_crippling_fear:IsHiddenWhenStolen()
	return false
end

function imba_night_stalker_crippling_fear:GetCooldown(level)
	local caster = self:GetCaster()
	local cooldown = self:GetRightfulKV("AbilityCooldown")

	-- #8 Talent: Crippling Fear cooldown decrease
	cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_night_stalker_8")

	return cooldown
end

function imba_night_stalker_crippling_fear:OnOwnerSpawned()
	if self:GetCaster():HasAbility("special_bonus_imba_night_stalker_8") and self:GetCaster():FindAbilityByName("special_bonus_imba_night_stalker_8"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_night_stalker_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_night_stalker_8", {})
	end
end

function imba_night_stalker_crippling_fear:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local cast_response = { "night_stalker_nstalk_ability_cripfear_01", "night_stalker_nstalk_ability_cripfear_02", "night_stalker_nstalk_ability_cripfear_03" }
	local sound_cast = "Hero_Nightstalker.Trickling_Fear"
	local modifier_fear = "modifier_imba_crippling_fear_silence"

	-- Ability specials
	local day_duration = ability:GetSpecialValueFor("day_duration")
	local night_duration = ability:GetSpecialValueFor("night_duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Block Linken
	if caster:GetTeamNumber() ~= target:GetTeamNumber() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Check day or night to decide duration
	local duration
	if GameRules:IsDaytime() then
		duration = day_duration
	else
		duration = night_duration
	end

	-- Apply Silence modifier
	target:AddNewModifier(caster, ability, modifier_fear, { duration = duration * (1 - target:GetStatusResistance()) })
end

-- Silence modifier
modifier_imba_crippling_fear_silence = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_crippling_fear_silence:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_fear = "Imba.CripplingFearKill"
	self.modifier_fear = "modifier_imba_crippling_fear_silence"

	-- Ability specials
	self.day_miss_chance_pct = self.ability:GetSpecialValueFor("day_miss_chance_pct")
	self.night_miss_chance_pct = self.ability:GetSpecialValueFor("night_miss_chance_pct")
	self.radius_fear = self.ability:GetSpecialValueFor("radius_fear")
	self.fear_duartion = self.ability:GetSpecialValueFor("fear_duartion")

	-- #2 Talent: Crippling Fear miss chance increase
	self.day_miss_chance_pct = self.day_miss_chance_pct + self.caster:FindTalentValue("special_bonus_imba_night_stalker_2")
	self.night_miss_chance_pct = self.night_miss_chance_pct + self.caster:FindTalentValue("special_bonus_imba_night_stalker_2")

	-- #4 Talent: Crippling Fear On-kill effect duration
	self.fear_duartion = self.fear_duartion + self.caster:FindTalentValue("special_bonus_imba_night_stalker_4")
end

function modifier_imba_crippling_fear_silence:IsHidden() return false end

function modifier_imba_crippling_fear_silence:IsPurgable() return true end

function modifier_imba_crippling_fear_silence:IsDebuff() return true end

function modifier_imba_crippling_fear_silence:CheckState()
	-- #6 Talent: Crippling Fear now mutes the target as well
	if self.caster:HasTalent("special_bonus_imba_night_stalker_6") then
		local state = {
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true
		}
		return state
	end

	local state = { [MODIFIER_STATE_SILENCED] = true }
	return state
end

function modifier_imba_crippling_fear_silence:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_MISS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_crippling_fear_silence:GetModifierMiss_Percentage()
	-- Check if it is a day or night
	local is_day = GameRules:IsDaytime()

	-- Assign miss chance according to day-night cycle
	if is_day then
		return self.day_miss_chance_pct
	end

	return self.night_miss_chance_pct
end

function modifier_imba_crippling_fear_silence:OnHeroKilled(keys)
	if IsServer() then
		local target = keys.target

		-- Only apply on the parent getting killed
		if self.parent == target then
			-- If it is an illusion or a creep, do nothing
			if not self.parent:IsRealHero() then
				return nil
			end

			-- Night Stalker Howl animation
			self.caster:StartGesture(ACT_DOTA_VICTORY)

			-- Stop Howl animation
			Timers:CreateTimer(1, function()
				self.caster:FadeGesture(ACT_DOTA_VICTORY)
			end)

			-- Play Howl sound
			EmitSoundOn(self.sound_fear, self.caster)

			-- Find all nearby enemies around the target that died
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.parent:GetAbsOrigin(),
				nil,
				self.radius_fear,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
				FIND_ANY_ORDER,
				false)

			-- Afflict them with secondary Crippling Fear
			for _, enemy in pairs(enemies) do
				-- Make sure enemy didn't get magic immune suddenly
				if not enemy:IsMagicImmune() then
					enemy:AddNewModifier(self.caster, self.ability, self.modifier_fear, { duration = self.fear_duartion * (1 - enemy:GetStatusResistance()) })
				end
			end
		end
	end
end

function modifier_imba_crippling_fear_silence:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
end

function modifier_imba_crippling_fear_silence:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- Need this modifier to show Crippling Fear cooldown reduction talent on client-side
LinkLuaModifier("modifier_special_bonus_imba_night_stalker_8", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_night_stalker_8 = class(VANILLA_ABILITIES_BASECLASS)

function modifier_special_bonus_imba_night_stalker_8:IsHidden() return true end

function modifier_special_bonus_imba_night_stalker_8:IsPurgable() return false end

function modifier_special_bonus_imba_night_stalker_8:RemoveOnDeath() return false end

----------------------------------
--      Hunter in the Night     --
----------------------------------
imba_night_stalker_hunter_in_the_night = class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_hunter_in_the_night_thinker", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hunter_in_the_night", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_hunter_in_the_night_flying", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

function imba_night_stalker_hunter_in_the_night:GetIntrinsicModifierName()
	return "modifier_imba_hunter_in_the_night_thinker"
end

function imba_night_stalker_hunter_in_the_night:OnUpgrade()
	local caster = self:GetCaster()
	local modifier_hunter = "modifier_imba_hunter_in_the_night"

	-- If the caster has HitN while leveling the ability up, refresh the modifier
	if caster:HasModifier(modifier_hunter) then
		local modifier_hunter_handler = caster:FindModifierByName(modifier_hunter)
		if modifier_hunter_handler then
			modifier_hunter_handler:ForceRefresh()
		end
	end
end

-- function imba_night_stalker_hunter_in_the_night:GetBehavior()
-- if self.nightTime then
-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- else
-- return DOTA_ABILITY_BEHAVIOR_PASSIVE
-- end
-- end

function imba_night_stalker_hunter_in_the_night:GetManaCost(level)
	if self.nightTime then
		return self.BaseClass.GetManaCost(self, level)
	else
		return 0
	end
end

-- function imba_night_stalker_hunter_in_the_night:OnSpellStart()
-- if IsServer() then
-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_hunter_in_the_night_flying", {duration = self:GetSpecialValueFor("flying_duration")})
-- end
-- end

-- Thinker modifier
modifier_imba_hunter_in_the_night_thinker = modifier_imba_hunter_in_the_night_thinker or class(VANILLA_ABILITIES_BASECLASS)
function modifier_imba_hunter_in_the_night_thinker:IsHidden() return true end

function modifier_imba_hunter_in_the_night_thinker:IsPurgable() return false end

function modifier_imba_hunter_in_the_night_thinker:IsDebuff() return false end

function modifier_imba_hunter_in_the_night_thinker:OnCreated()
	self.ability = self:GetAbility()
	self.ability.nightTime = false

	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.modifier_hunter = "modifier_imba_hunter_in_the_night"
		self.modifier_day = "modifier_imba_hunter_in_the_night_day_model"
		self.night_transform_response = { "night_stalker_nstalk_ability_dark_01", "night_stalker_nstalk_ability_dark_02", "night_stalker_nstalk_ability_dark_04", "night_stalker_nstalk_ability_dark_05", "night_stalker_nstalk_ability_dark_06" }
		self.night_rare_transform_response = "night_stalker_nstalk_ability_dark_03"
		self.night_rarest_transform_response = "night_stalker_nstalk_ability_dark_07"
		self.day_transform_response = { "night_stalker_nstalk_dayrise_01", "night_stalker_nstalk_dayrise_02", "night_stalker_nstalk_dayrise_03" }
		self.day_rare_transform_response = "night_stalker_nstalk_dayrise_05"
		self.day_rarest_transform_response = "night_stalker_nstalk_dayrise_04"

		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_imba_hunter_in_the_night_thinker:OnStackCountChanged(oldStacks)
	if self:GetStackCount() == 1 then
		self.ability.nightTime = false
	else
		self.ability.nightTime = true
	end
end

function modifier_imba_hunter_in_the_night_thinker:OnIntervalThink()
	if IsServer() then
		-- If the daycycle is a night and Nightstalker doesn't have the buff yet, give it to him
		if (not GameRules:IsDaytime()) and (not self.caster:HasModifier(self.modifier_hunter)) and self.caster:IsAlive() then
			-- Night transform responses
			-- Roll for rarest transform response
			if RollPercentage(5) then
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.night_rarest_transform_response, self.caster)

				-- Roll for rare transform response
			elseif RollPercentage(15) then
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.night_rare_transform_response, self.caster)

				-- Roll for normal transform response
			elseif RollPercentage(75) then
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.night_transform_response[math.random(1, #self.night_transform_response)], self.caster)
			end

			-- Grant night buff
			self.caster:AddNewModifier(self.caster, self.ability, self.modifier_hunter, {})

			-- Set stack count to 2, used to tell the ability its night time
			self:SetStackCount(2)
		end

		-- If the daycycle is a morning and Nightstalker has the buff, remove it from him
		if GameRules:IsDaytime() and self.caster:HasModifier(self.modifier_hunter) and self.caster:IsAlive() then
			-- Day transformation responses
			-- Roll for rarest transform response
			if RollPercentage(5) then
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.day_rarest_transform_response, self.caster)

				-- Roll for rare transform response
			elseif RollPercentage(15) then
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.day_rare_transform_response, self.caster)

				-- Play normal transform response
			else
				EmitSoundOnLocationForAllies(self.caster:GetAbsOrigin(), self.day_transform_response[math.random(1, #self.day_transform_response)], self.caster)
			end

			-- Remove night buff
			self.caster:RemoveModifierByName(self.modifier_hunter)

			-- Set stack count to 1, used to tell the ability its day time
			self:SetStackCount(1)
		end
	end
end

-- Night buff
modifier_imba_hunter_in_the_night = modifier_imba_hunter_in_the_night or class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_hunter_in_the_night:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_change = "particles/units/heroes/hero_night_stalker/nightstalker_change.vpcf"
	self.particle_buff = "particles/units/heroes/hero_night_stalker/nightstalker_night_buff.vpcf"
	self.modifier_stalker = "modifier_imba_stalker_in_the_night"
	self.normal_model = "models/heroes/nightstalker/nightstalker.vmdl"
	self.night_model = "models/heroes/nightstalker/nightstalker_night.vmdl"

	-- Ability specials
	self.base_bonus_ms_pct = self.ability:GetSpecialValueFor("base_bonus_ms_pct")
	self.base_bonus_as = self.ability:GetTalentSpecialValueFor("base_bonus_as")
	-- self.night_vision_bonus = self.ability:GetSpecialValueFor("night_vision_bonus")
	self.ms_increase_per_stack = self.ability:GetSpecialValueFor("ms_increase_per_stack")
	self.as_increase_per_stack = self.ability:GetSpecialValueFor("as_increase_per_stack")

	if IsServer() then
		-- Since illusion getting the buff can actually show who the real one is, don't give them the change particle
		Timers:CreateTimer(FrameTime(), function()
			if self.caster:IsRealHero() then
				-- Apply change particle
				self.particle_change_fx = ParticleManager:CreateParticle(self.particle_change, PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(self.particle_change_fx, 0, self.caster:GetAbsOrigin())
				ParticleManager:SetParticleControl(self.particle_change_fx, 1, self.caster:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(self.particle_change_fx)
			end
		end)

		-- Apply buff particle
		self.particle_buff_fx = ParticleManager:CreateParticle(self.particle_buff, PATTACH_CUSTOMORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.particle_buff_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_buff_fx, 1, Vector(1, 0, 0))
		self:AddParticle(self.particle_buff_fx, false, false, -1, false, false)


		if not self:GetAbility():IsStolen() then
			-- Apply night model
			self.caster:SetModel(self.night_model)
			self.caster:SetOriginalModel(self.night_model)

			if self.wings then
				-- Remove old wearables
				UTIL_Remove(self.wings)
				UTIL_Remove(self.legs)
				UTIL_Remove(self.tail)
			end
			-- Set new wearables
			self.wings = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/nightstalker/nightstalker_wings_night.vmdl" })
			self.legs = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/nightstalker/nightstalker_legarmor_night.vmdl" })
			self.tail = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/nightstalker/nightstalker_tail_night.vmdl" })
			-- lock to bone
			self.wings:FollowEntity(self:GetCaster(), true)
			self.legs:FollowEntity(self:GetCaster(), true)
			self.tail:FollowEntity(self:GetCaster(), true)
		end

		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_hunter_in_the_night:OnRefresh()
	self:OnCreated()
end

function modifier_imba_hunter_in_the_night:IsHidden() return false end

function modifier_imba_hunter_in_the_night:IsPurgable() return false end

function modifier_imba_hunter_in_the_night:IsDebuff() return false end

function modifier_imba_hunter_in_the_night:CheckState()
	if self:GetAbility() and self:GetAbility():GetLevel() >= 1 and IsDaytime and not IsDaytime() and not self:GetParent():HasModifier("modifier_imba_darkness_night") and not self:GetParent():PassivesDisabled() then
		return { [MODIFIER_STATE_FLYING] = true }
	end
end

function modifier_imba_hunter_in_the_night:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}

	return decFuncs
end

function modifier_imba_hunter_in_the_night:GetModifierMoveSpeedBonus_Constant()
	-- If the caster is afflicted with Break, do nothing
	if self.caster:PassivesDisabled() then
		return nil
	end

	local stacks = self.caster:GetModifierStackCount(self.modifier_stalker, nil)
	return self.ms_increase_per_stack * stacks
end

function modifier_imba_hunter_in_the_night:GetModifierMoveSpeedBonus_Percentage()
	-- If the caster is afflicted with Break, do nothing
	if self.caster:PassivesDisabled() then
		return nil
	end

	-- #3 Talent: Hunter in the Night bonuses
	local base_bonus_ms_pct = self.base_bonus_ms_pct + self.caster:FindTalentValue("special_bonus_imba_night_stalker_3", "ms_bonus_pct")

	return base_bonus_ms_pct
end

function modifier_imba_hunter_in_the_night:GetModifierAttackSpeedBonus_Constant()
	-- If the caster is afflicted with Break, do nothing
	if self.caster:PassivesDisabled() then
		return nil
	end

	local stacks = self.caster:GetModifierStackCount(self.modifier_stalker, self.caster)

	-- #3 Talent: Hunter in the Night bonuses
	local base_bonus_as = self.base_bonus_as + self.caster:FindTalentValue("special_bonus_imba_night_stalker_3", "as_bonus")
	return (base_bonus_as + self.as_increase_per_stack * stacks)
end

-- function modifier_imba_hunter_in_the_night:GetBonusDayVision()
-- -- If the caster is afflicted with Break, do nothing
-- if self.caster:PassivesDisabled() then
-- return nil
-- end

-- return self.night_vision_bonus
-- end

function modifier_imba_hunter_in_the_night:GetModifierIgnoreMovespeedLimit()
	if not self:GetParent():PassivesDisabled() and IsDaytime and not IsDaytime() then
		return 1
	end
end

function modifier_imba_hunter_in_the_night:OnDestroy()
	if IsServer() then
		-- Apply change particle
		self.particle_change_fx = ParticleManager:CreateParticle(self.particle_change, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.particle_change_fx, 0, self.caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_change_fx, 1, self.caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle_change_fx)

		if not self:GetAbility():IsStolen() then
			-- Revert Models
			self.caster:SetModel(self.normal_model)
			self.caster:SetOriginalModel(self.normal_model)

			if self.wings then
				-- Remove old wearables
				UTIL_Remove(self.wings)
				UTIL_Remove(self.legs)
				UTIL_Remove(self.tail)
			end
		end
	end
end

--	Flight Modifier
modifier_imba_hunter_in_the_night_flying = modifier_imba_hunter_in_the_night_flying or class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_hunter_in_the_night_flying:IsHidden() return false end

function modifier_imba_hunter_in_the_night_flying:IsPurgable() return false end

function modifier_imba_hunter_in_the_night_flying:IsDebuff() return false end

function modifier_imba_hunter_in_the_night_flying:DeclareFunctions()
	return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS }
end

function modifier_imba_hunter_in_the_night_flying:CheckState()
	return { [MODIFIER_STATE_FLYING] = true }
end

function modifier_imba_hunter_in_the_night_flying:OnCreated()
	if IsServer() then
		self.scepter = self:GetParent():HasScepter()
		self.parent = self:GetParent()
		self:StartIntervalThink(FrameTime() * 3)
	end
end

function modifier_imba_hunter_in_the_night_flying:OnIntervalThink()
	AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.parent:GetCurrentVisionRange(), FrameTime() * 4, false)
end

function modifier_imba_hunter_in_the_night_flying:OnDestroy()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
		GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, false) -- Destroy trees again to prevent odd cases
	end
end

function modifier_imba_hunter_in_the_night_flying:GetActivityTranslationModifiers()
	return "hunter_night"
end

----------------------------------
--           Darkness           --
----------------------------------
imba_night_stalker_darkness = class(VANILLA_ABILITIES_BASECLASS)
LinkLuaModifier("modifier_imba_darkness_night", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_darkness_vision", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_darkness_fogvision", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

function imba_night_stalker_darkness:IsNetherWardStealable() return false end

function imba_night_stalker_darkness:IsHiddenWhenStolen() return false end

function imba_night_stalker_darkness:GetCooldown(level)
	return self:GetRightfulKV("AbilityCooldown") - self:GetCaster():FindTalentValue("special_bonus_imba_night_stalker_10")
end

function imba_night_stalker_darkness:OnUpgrade()
	-- Rubick scepter interaction
	if self:IsStolen() then
		Timers:CreateTimer(FrameTime(), function()
			local caster = self:GetCaster()
			local has_darkness = caster:HasAbility("imba_night_stalker_darkness")
			local scepter = caster:HasScepter()
			local is_day = GameRules:IsDaytime()

			-- If the caster doesn't have darkness anymore, do nothing
			if not has_darkness then
				return nil
			end

			-- If the caster has scepter and it is night, apply a AddFoWViewer
			if scepter and not is_day then
				-- Get the caster's night vision
				local night_vision = caster:GetNightTimeVisionRange()

				-- Apply a FOW Viewer
				AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), night_vision, FrameTime(), false)
			end

			-- Repeat
			return FrameTime()
		end)
	end
end

function imba_night_stalker_darkness:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Nightstalker.Darkness"
	local particle_darkness = "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf"
	local modifier_night = "modifier_imba_darkness_night"
	local modifier_fogivison = "modifier_imba_darkness_fogvision"

	-- Ability specials
	local duration = ability:GetSpecialValueFor("duration")
	local enemy_vision_duration = ability:GetSpecialValueFor("enemy_vision_duration")

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Add darkness particle
	local particle_darkness_fx = ParticleManager:CreateParticle(particle_darkness, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_darkness_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_darkness_fx, 1, caster:GetAbsOrigin())

	-- Apply Darkness
	caster:AddNewModifier(caster, ability, modifier_night, { duration = duration })

	-- Find all enemy heroes
	local enemy_heroes = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE, -- global
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	-- Apply fogivision modifier on enemies
	for _, enemy_hero in pairs(enemy_heroes) do
		enemy_hero:AddNewModifier(caster, ability, modifier_fogivison, { duration = enemy_vision_duration })
	end
end

-- Darkness Night modifier
modifier_imba_darkness_night = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_darkness_night:IsPurgable() return false end

function modifier_imba_darkness_night:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	-- Start a Night Stalker night
	if IsServer() then
		self.game_mode = GameRules:GetGameModeEntity()

		GameRules:BeginNightstalkerNight(self:GetDuration())
		-- self.game_mode:SetDaynightCycleDisabled(true)

		self:StartIntervalThink(FrameTime() * 3)
	end
end

function modifier_imba_darkness_night:OnRefresh()
	self:OnCreated()
end

function modifier_imba_darkness_night:OnIntervalThink()
	AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.parent:GetCurrentVisionRange(), FrameTime() * 3, false)
end

function modifier_imba_darkness_night:OnDestroy()
	if IsServer() then
		-- self.game_mode:SetDaynightCycleDisabled(false)
		FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
	end
end

-- function modifier_imba_darkness_night:GetAuraRadius()
-- return 25000 -- global
-- end

-- function modifier_imba_darkness_night:GetAuraSearchFlags()
-- return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
-- end

-- function modifier_imba_darkness_night:GetAuraSearchTeam()
-- return DOTA_UNIT_TARGET_TEAM_ENEMY
-- end

-- function modifier_imba_darkness_night:GetAuraSearchType()
-- return DOTA_UNIT_TARGET_ALL
-- end

-- function modifier_imba_darkness_night:GetModifierAura()
-- return "modifier_imba_darkness_vision"
-- end

-- function modifier_imba_darkness_night:IsAura()
-- return true
-- end

-- function modifier_imba_darkness_night:IsAuraActiveOnDeath()
-- return true
-- end

function modifier_imba_darkness_night:CheckState()
	return { [MODIFIER_STATE_FLYING] = true }
end

function modifier_imba_darkness_night:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return decFuncs
end

function modifier_imba_darkness_night:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_darkness_night:GetActivityTranslationModifiers()
	return "hunter_night"
end

-- Darkness vision reduction modifier
modifier_imba_darkness_vision = class(VANILLA_ABILITIES_BASECLASS)
function modifier_imba_darkness_vision:IsHidden() return false end

function modifier_imba_darkness_vision:IsPurgable() return false end

function modifier_imba_darkness_vision:IsDebuff() return true end

function modifier_imba_darkness_vision:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		-- Ability specials
		self.vision_reduction_pct = self.ability:GetSpecialValueFor("vision_reduction_pct")

		-- #7 Talent: Darkness maximum vision range reduction
		--self.vision_radius = self.vision_radius - self.caster:FindTalentValue("special_bonus_imba_night_stalker_7")

		-- Keep the original base night vision
		self.original_base_night_vision = self.parent:GetBaseNightTimeVisionRange()

		-- Override the base night vision
		self.parent:SetNightTimeVisionRange(self.original_base_night_vision * (100 - self.vision_reduction_pct) / 100)
	end
end

function modifier_imba_darkness_vision:OnDestroy()
	if IsServer() then
		-- Revert the base night vision of the target
		self.parent:SetNightTimeVisionRange(self.original_base_night_vision)
	end
end

-- Darkness fogvision detection modifier
modifier_imba_darkness_fogvision = class(VANILLA_ABILITIES_BASECLASS)

function modifier_imba_darkness_fogvision:IsHidden() return true end

function modifier_imba_darkness_fogvision:IsPurgable() return false end

function modifier_imba_darkness_fogvision:IsDebuff() return true end

function modifier_imba_darkness_fogvision:IgnoreTenacity() return true end

function modifier_imba_darkness_fogvision:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROVIDES_FOW_POSITION }
end

function modifier_imba_darkness_fogvision:GetModifierProvidesFOWVision()
	return 1
end

LinkLuaModifier("modifier_imba_night_stalker_crippling_fear_720", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_night_stalker_crippling_fear_720_handler", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_night_stalker_crippling_fear_positive_720", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_night_stalker_crippling_fear_aura_720", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_night_stalker_crippling_fear_aura_positive_720", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

imba_night_stalker_crippling_fear_720                        = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_night_stalker_crippling_fear_720_handler       = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_night_stalker_crippling_fear_aura_720          = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_night_stalker_crippling_fear_aura_positive_720 = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_night_stalker_crippling_fear_720               = class(VANILLA_ABILITIES_BASECLASS)
modifier_imba_night_stalker_crippling_fear_positive_720      = class(VANILLA_ABILITIES_BASECLASS)

function imba_night_stalker_crippling_fear_720:GetIntrinsicModifierName()
	return "modifier_imba_night_stalker_crippling_fear_720_handler"
end

function imba_night_stalker_crippling_fear_720:GetBehavior()
	if self:GetCaster():HasScepter() then
		if self:GetCaster():GetModifierStackCount("modifier_imba_night_stalker_crippling_fear_720_handler", self:GetCaster()) == 0 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		else
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function imba_night_stalker_crippling_fear_720:GetAbilityTargetTeam()
	if self:GetCaster():HasScepter() then
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	else
		return DOTA_UNIT_TARGET_TEAM_NONE
	end
end

function imba_night_stalker_crippling_fear_720:GetAbilityTargetType()
	if self:GetCaster():HasScepter() then
		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	else
		return DOTA_UNIT_TARGET_NONE
	end
end

function imba_night_stalker_crippling_fear_720:GetCastRange(location, target)
	if self:GetCaster():HasScepter() and self:GetCaster():GetModifierStackCount("modifier_imba_night_stalker_crippling_fear_720_handler", self:GetCaster()) == 1 then
		return self:GetSpecialValueFor("scepter_cast_range")
	else
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function imba_night_stalker_crippling_fear_720:GetAOERadius()
	if self:GetCaster():GetModifierStackCount("modifier_imba_night_stalker_crippling_fear_720_handler", self:GetCaster()) == 0 then
		return 0
	else
		return self:GetSpecialValueFor("radius")
	end
end

function imba_night_stalker_crippling_fear_720:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self.caster

	if self:GetCursorTarget() ~= nil then
		self.target = self:GetCursorTarget()
	end

	-- AbilitySpecials
	self.duration_day   = self:GetSpecialValueFor("duration_day")
	self.duration_night = self:GetSpecialValueFor("duration_night")
	self.radius         = self:GetSpecialValueFor("radius")

	if not IsServer() then return end

	if GameRules:IsDaytime() then
		self.target:AddNewModifier(self.caster, self, "modifier_imba_night_stalker_crippling_fear_aura_720", { duration = self.duration_day })
	else
		self.target:AddNewModifier(self.caster, self, "modifier_imba_night_stalker_crippling_fear_aura_720", { duration = self.duration_night })
	end

	if self.caster:GetName() == "npc_dota_hero_night_stalker" and RollPercentage(75) then
		self.caster:EmitSound("night_stalker_nstalk_ability_cripfear_0" .. RandomInt(1, 3))
	end

	self.target:EmitSound("Hero_Nightstalker.Trickling_Fear")
	self.target:EmitSound("Hero_Nightstalker.Trickling_Fear_lp")

	-- Loop sound only plays for a short time at cast start
	Timers:CreateTimer(1.0, function()
		if not self:IsNull() and not self.target:IsNull() then
			self.target:StopSound("Hero_Nightstalker.Trickling_Fear_lp")
		end
	end)
end

--------------------------------------------
-- CRIPPLING FEAR HANDLER MODIFIER (7.20) --
--------------------------------------------

function modifier_imba_night_stalker_crippling_fear_720_handler:IsHidden() return true end

function modifier_imba_night_stalker_crippling_fear_720_handler:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_ORDER }

	return decFuncs
end

function modifier_imba_night_stalker_crippling_fear_720_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-----------------------------------------
-- CRIPPLING FEAR MODIFIER AURA (7.20) --
-----------------------------------------

function modifier_imba_night_stalker_crippling_fear_aura_720:IsPurgable() return false end

function modifier_imba_night_stalker_crippling_fear_aura_720:IsAura() return true end

function modifier_imba_night_stalker_crippling_fear_aura_720:IsAuraActiveOnDeath() return false end

function modifier_imba_night_stalker_crippling_fear_aura_720:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") * self:GetStackCount() end

function modifier_imba_night_stalker_crippling_fear_aura_720:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_night_stalker_crippling_fear_aura_720:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_night_stalker_crippling_fear_aura_720:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_night_stalker_crippling_fear_aura_720:GetModifierAura() return "modifier_imba_night_stalker_crippling_fear_720" end

function modifier_imba_night_stalker_crippling_fear_aura_720:OnCreated()
	self.ability          = self:GetAbility()
	self.parent           = self:GetParent()

	-- AbilitySpecials
	self.duration_day     = self.ability:GetSpecialValueFor("duration_day")
	self.duration_night   = self.ability:GetSpecialValueFor("duration_night")
	self.radius           = self.ability:GetSpecialValueFor("radius")
	self.refresh_time_pct = self.ability:GetSpecialValueFor("refresh_time_pct")

	if not IsServer() then return end

	self:SetStackCount(1)

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self:GetCaster())
	self:AddParticle(self.particle, false, false, -1, false, false)
	ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(self.particle, 3, self.parent:GetAbsOrigin())
	self:StartIntervalThink(FrameTime())
end

--[[
function modifier_imba_night_stalker_crippling_fear_720:OnIntervalThink()
	ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
end
--]]
function modifier_imba_night_stalker_crippling_fear_aura_720:OnRefresh()
	self:OnCreated()
end

function modifier_imba_night_stalker_crippling_fear_aura_720:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HERO_KILLED,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return decFuncs
end

-- IMBAfication: Night Terror's Growl
function modifier_imba_night_stalker_crippling_fear_aura_720:OnHeroKilled(keys)
	if not IsServer() then return end

	-- If the hero was killed within Crippling Fear's aura radius (doesn't have to be by the caster), add base radius to radius and add base duration to remaining amount
	if keys.target:GetTeam() ~= self.parent:GetTeam() and (keys.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius * self:GetStackCount() and self.parent:IsAlive() then
		if self:GetStackCount() == 1 then
			self:IncrementStackCount()
		end

		local new_duration = math.min(self:GetRemainingTime() + (self.duration_night * self.refresh_time_pct / 100), self.duration_night)

		if GameRules:IsDaytime() then
			new_duration = math.min(self:GetRemainingTime() + (self.duration_day * self.refresh_time_pct / 100), self.duration_day)
		end

		self:SetDuration(new_duration, true)

		-- Destroy/Release particle index and re-draw with updated radius (don't technically have to but it looks better)
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(self.particle, 2, Vector(self.radius * self:GetStackCount(), self.radius * self:GetStackCount(), self.radius * self:GetStackCount()))
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_imba_night_stalker_crippling_fear_aura_720:OnTooltip()
	return self.radius * self:GetStackCount()
end

function modifier_imba_night_stalker_crippling_fear_aura_720:OnDestroy()
	if not IsServer() then return end

	self.parent:EmitSound("Hero_Nightstalker.Trickling_Fear_end")
end

------------------------------------
-- CRIPPLING FEAR MODIFIER (7.20) --
------------------------------------

function modifier_imba_night_stalker_crippling_fear_720:GetEffectName()
	return "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear.vpcf"
end

function modifier_imba_night_stalker_crippling_fear_720:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_night_stalker_crippling_fear_720:OnCreated()
	self.parent = self:GetParent()

	if not IsServer() then return end

	self.parent:EmitSound("Hero_Nightstalker.Trickling_Fear_lp")
end

function modifier_imba_night_stalker_crippling_fear_720:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MISS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_night_stalker_crippling_fear_720:GetModifierMiss_Percentage()
	return self:GetCaster():FindTalentValue("special_bonus_imba_night_stalker_2")
end

function modifier_imba_night_stalker_crippling_fear_720:CheckState()
	local state = {}

	if self:GetCaster():HasScepter() then
		state = {
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_BLOCK_DISABLED] = true,
			[MODIFIER_STATE_EVADE_DISABLED] = true
		}
	else
		state = {
			[MODIFIER_STATE_SILENCED] = true
		}
	end

	return state
end

function modifier_imba_night_stalker_crippling_fear_720:OnDestroy()
	self.parent = self:GetParent()

	if not IsServer() then return end

	self.parent:StopSound("Hero_Nightstalker.Trickling_Fear_lp")
	self.parent:EmitSound("Hero_Nightstalker.Trickling_Fear_end")
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_night_stalker_9", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_night_stalker_10", "components/abilities/heroes/hero_night_stalker", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_night_stalker_9  = class(VANILLA_ABILITIES_BASECLASS)
modifier_special_bonus_imba_night_stalker_10 = class(VANILLA_ABILITIES_BASECLASS)

function modifier_special_bonus_imba_night_stalker_9:IsHidden() return true end

function modifier_special_bonus_imba_night_stalker_9:IsPurgable() return false end

function modifier_special_bonus_imba_night_stalker_9:RemoveOnDeath() return false end

function modifier_special_bonus_imba_night_stalker_10:IsHidden() return true end

function modifier_special_bonus_imba_night_stalker_10:IsPurgable() return false end

function modifier_special_bonus_imba_night_stalker_10:RemoveOnDeath() return false end

function imba_night_stalker_hunter_in_the_night:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_night_stalker_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_night_stalker_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_night_stalker_9"), "modifier_special_bonus_imba_night_stalker_9", {})
	end
end

function imba_night_stalker_darkness:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_night_stalker_10") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_night_stalker_10") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_night_stalker_10"), "modifier_special_bonus_imba_night_stalker_10", {})
	end
end
