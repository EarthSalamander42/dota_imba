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
--     Shush, 08.03.2018

----------------------------
--		FROST ARROWS      --
----------------------------

imba_drow_ranger_frost_arrows = class({})
LinkLuaModifier("modifier_imba_frost_arrows_thinker", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_slow", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_freeze", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_frost_arrows_buff", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)


function imba_drow_ranger_frost_arrows:GetAbilityTextureName()
	return "drow_ranger_frost_arrows"
end

function imba_drow_ranger_frost_arrows:GetIntrinsicModifierName()
	return "modifier_imba_frost_arrows_thinker"
end

function imba_drow_ranger_frost_arrows:GetCastRange(Location, Target)
	-- Get caster's cast range
	local caster = self:GetCaster()
	return caster:Script_GetAttackRange()
end

function imba_drow_ranger_frost_arrows:IsStealable()
	return false
end

function imba_drow_ranger_frost_arrows:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local modifier = "modifier_imba_frost_arrows_thinker"
		local target = self:GetCursorTarget()

		-- Tag the current shot as a forced one
		self.force_frost_arrow = true

		-- Force attack the target
		caster:MoveToTargetToAttack(target)

		-- Replenish mana cost (since it's spent on the OnAttack function)
		ability:RefundManaCost()
	end
end

-- Frost arrows thinker modifier
modifier_imba_frost_arrows_thinker = class({})



function modifier_imba_frost_arrows_thinker:DeclareFunctions()
	local decFunc = {MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER}

	return decFunc
end

function modifier_imba_frost_arrows_thinker:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_cast = "Hero_DrowRanger.FrostArrows"
	self.modifier_slow = "modifier_imba_frost_arrows_slow"
end

function modifier_imba_frost_arrows_thinker:OnAttackStart(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Do absolutely nothing if the attacker is an illusion
		if attacker:IsIllusion() then
			return nil
		end

		-- Only apply on caster's attacks
		if self.caster == attacker then
			-- Ability specials
			self.hero_duration = self.ability:GetSpecialValueFor("hero_duration")
			self.creep_duration = self.ability:GetSpecialValueFor("creep_duration")

			-- Assume it's a frost arrow unless otherwise stated
			local frost_attack = true

			-- Initialize attack table
			if not self.attack_table then
				self.attack_table = {}
			end

			-- Get variables
			self.auto_cast = self.ability:GetAutoCastState()
			self.current_mana = self.caster:GetMana()
			self.mana_cost = self.ability:GetManaCost(-1)

			-- If the caster is silenced, mark attack as non-frost arrow
			if self.caster:IsSilenced() then
				frost_attack = false
			end

			-- If the target is a building or is magic immune, mark attack as non-frost arrow
			if target:IsBuilding() or target:IsMagicImmune() then
				frost_attack = false
			end

			-- If it wasn't a forced frost attack (through ability cast), or
			-- auto cast is off, change projectile to non-frost and return
			if not self.ability.force_frost_arrow and not self.auto_cast then
				frost_attack = false
			end

			-- If there isn't enough mana to cast a Frost Arrow, assign as a non-frost arrow
			if self.current_mana < self.mana_cost then
				frost_attack = false
			end

			if frost_attack then
				--mark that attack as a frost arrow
				self.frost_arrow_attack = true
				SetArrowAttackProjectile(self.caster, true)
			else
				-- Transform back to usual projectiles
				self.frost_arrow_attack = false
				SetArrowAttackProjectile(self.caster, false)
			end
		end
	end
end

function modifier_imba_frost_arrows_thinker:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on caster's attacks
		if self.caster == keys.attacker then

			-- Clear instance of ability's forced frost arrow
			self.ability.force_frost_arrow = nil

			-- If it wasn't a frost arrow, do nothing
			if not self.frost_arrow_attack then
				return nil
			end

			-- Emit sound
			EmitSoundOn(self.sound_cast, self.caster)

			-- Spend mana
			self.caster:SpendMana(self.mana_cost, self.ability)
		end
	end
end

function modifier_imba_frost_arrows_thinker:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on Drow's attacks
		if self.caster == attacker then

			-- #2 Talent: Chance to kill creeps instantly
			local instakill_chance = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_2")

			-- Only applicable on creeps, except ancients
			if target:IsCreep() and not target:IsAncient() then
				if RollPercentage(instakill_chance) then
					target:Kill(self.ability, self.caster)
				end
			end

			-- Only apply if the arrow was a frost attack and the target is alive
			if target:IsAlive() and self.frost_arrow_attack then
				ApplyFrostAttack(self, target)
			end
		end
	end
end

function ApplyFrostAttack(modifier, target)

	-- Determine duration
	local duration

	if target:IsHero() then
		duration = modifier.hero_duration
	else
		duration = modifier.creep_duration
	end

	-- Apply slow effect if the target didn't suddenly become magic immune
	if not target:IsMagicImmune() then
		if not target:HasModifier(modifier.modifier_slow) then
			local modifier_slow_handler = target:AddNewModifier(modifier.caster, modifier.ability, modifier.modifier_slow, {duration = duration})
			if modifier_slow_handler then
				modifier_slow_handler:IncrementStackCount()
			end
		else
			local modifier_slow_handler = target:FindModifierByName(modifier.modifier_slow)
			modifier_slow_handler:IncrementStackCount()
			modifier_slow_handler:SetDuration(modifier_slow_handler:GetDuration(), true)
		end
	end
end

function modifier_imba_frost_arrows_thinker:OnOrder(keys)
	if keys.unit == self.caster then
		local order_type = keys.order_type

		-- On any order apart from attacking target, clear the forced frost arrow variable.
		if order_type ~= DOTA_UNIT_ORDER_ATTACK_TARGET then
			self.ability.force_frost_arrow = nil
		end
	end
end

function SetArrowAttackProjectile(caster, frost_attack)
	-- modifiers
	local skadi_modifier = "modifier_item_imba_skadi"
	local deso_modifier = "modifier_item_imba_desolator"
	local deso_2_modifier = "modifier_item_imba_desolator_2"
	local morbid_modifier = "modifier_imba_morbid_mask"
	local mom_modifier = "modifier_imba_mask_of_madness"
	local satanic_modifier = "modifier_imba_satanic"
	local vladimir_modifier = "modifier_item_imba_vladmir"
	local vladimir_2_modifier = "modifier_item_imba_vladmir_blood"

	-- normal projectiles
	local skadi_projectile = "particles/items2_fx/skadi_projectile.vpcf"
	local deso_projectile = "particles/items_fx/desolator_projectile.vpcf"
	local deso_skadi_projectile = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local lifesteal_projectile = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"

	-- Frost arrow projectiles
	local basic_arrow = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
	local frost_arrow = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"

	local frost_lifesteal_projectile = "particles/hero/drow/lifesteal_arrows/drow_lifedrain_frost_arrow.vpcf"
	local frost_skadi_projectile = "particles/hero/drow/skadi_arrows/drow_skadi_frost_arrow.vpcf"
	local frost_deso_projectile = "particles/hero/drow/deso_arrows/drow_deso_frost_arrow.vpcf"
	local frost_deso_skadi_projectile = "particles/hero/drow/deso_skadi_arrows/drow_deso_skadi_frost_arrow.vpcf"
	local frost_lifesteal_skadi_projectile = "particles/hero/drow/lifesteal_skadi_arrows/drow_lifesteal_skadi_frost_arrow.vpcf"
	local frost_lifesteal_deso_projectile = "particles/hero/drow/lifesteal_deso_arrows/drow_lifedrain_deso_frost_arrow.vpcf"
	local frost_lifesteal_deso_skadi_projectile = "particles/hero/drow/lifesteal_deso_skadi_arrows/drow_lifesteal_deso_skadi_frost_arrow.vpcf"

	-- Set variables
	local has_lifesteal
	local has_skadi
	local has_desolator

	-- Assign variables
	-- Lifesteal
	if caster:HasModifier(morbid_modifier) or caster:HasModifier(mom_modifier) or caster:HasModifier(satanic_modifier) or caster:HasModifier(vladimir_modifier) or caster:HasModifier(vladimir_2_modifier) then
		has_lifesteal = true
	end

	-- Skadi
	if caster:HasModifier(skadi_modifier) then
		has_skadi = true
	end

	-- Desolator
	if caster:HasModifier(deso_modifier) or caster:HasModifier(deso_2_modifier) then
		has_desolator = true
	end

	-- ASSIGN PARTICLES
	-- Frost attack
	if frost_attack then
		-- Desolator + lifesteal + frost + skadi (doesn't exists yet)
		if has_desolator and has_skadi and has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_deso_skadi_projectile)
			-- Desolator + lifesteal + frost
		elseif has_desolator and has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_deso_projectile)
			-- Desolator + skadi + frost
		elseif has_skadi and has_desolator then
			caster:SetRangedProjectileName(frost_deso_skadi_projectile)
			-- Lifesteal + skadi + frost
		elseif has_lifesteal and has_skadi then
			caster:SetRangedProjectileName(frost_lifesteal_skadi_projectile)
			-- skadi + frost
		elseif has_skadi then
			caster:SetRangedProjectileName(frost_skadi_projectile)
			-- lifesteal + frost
		elseif has_lifesteal then
			caster:SetRangedProjectileName(frost_lifesteal_projectile)
			-- Desolator + frost
		elseif has_desolator then
			caster:SetRangedProjectileName(frost_deso_projectile)
			return
			-- Frost
		else
			caster:SetRangedProjectileName(frost_arrow)
			return
		end
	else -- Non frost attack
		-- Skadi + desolator
		if has_skadi and has_desolator then
			caster:SetRangedProjectileName(deso_skadi_projectile)
			return
			-- Skadi
	elseif has_skadi then
		caster:SetRangedProjectileName(skadi_projectile)
		-- Desolator
	elseif has_desolator then
		caster:SetRangedProjectileName(deso_projectile)
		return
			Lifesteal
	elseif has_lifesteal then
		caster:SetRangedProjectileName(lifesteal_projectile)
		-- Basic arrow
	else
		caster:SetRangedProjectileName(basic_arrow)
		return
	end
	end
end

function modifier_imba_frost_arrows_thinker:IsHidden()
	return true
end

function modifier_imba_frost_arrows_thinker:IsPurgable()
	return false
end

function modifier_imba_frost_arrows_thinker:IsDebuff()
	return false
end

-- Slow modifier
modifier_imba_frost_arrows_slow = class({})

function modifier_imba_frost_arrows_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_freeze = "hero_Crystal.frostbite"
	self.modifier_freeze = "modifier_imba_frost_arrows_freeze"
	self.caster_modifier = "modifier_imba_frost_arrows_buff" -- talent movement speed buff

	-- Ability specials
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.stacks_to_freeze = self.ability:GetSpecialValueFor("stacks_to_freeze")
	self.freeze_duration = self.ability:GetSpecialValueFor("freeze_duration")

	-- Play freeze sound
	EmitSoundOn(self.modifier_freeze, self.parent)
end

function modifier_imba_frost_arrows_slow:OnRemoved()
	--Talent #4: Update the stack count on Drow accordingly when the parent lose the debuff (including when dying), remove the buff if no more stacks are left
	if IsServer() then
		local target_stacks = self:GetStackCount()
		stack_count = self.caster:GetModifierStackCount(self.caster_modifier, self.caster)
		if stack_count <= target_stacks then
			self.caster:RemoveModifierByName(self.caster_modifier)
		else
			self.caster:SetModifierStackCount(self.caster_modifier, self.caster, stack_count - target_stacks)
		end
	end
end

function modifier_imba_frost_arrows_slow:GetTexture()
	return "drow_ranger_frost_arrows"
end

function modifier_imba_frost_arrows_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_imba_frost_arrows_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_frost_arrows_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_frost_arrows_slow:OnStackCountChanged()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- If the stacks should freeze an enemy, reset the stack count and freeze it!
		if stacks >= self.stacks_to_freeze then
			self:SetStackCount(self:GetStackCount()-self.stacks_to_freeze)
			-- #4 talent: decrease the stack count on the movespeed buff accordingly, remove it if no more stacks are left
			if self.caster:HasTalent("special_bonus_imba_drow_ranger_4") then
				if (self.caster:GetModifierStackCount(self.caster_modifier, self.caster) <= self.stacks_to_freeze) then
					self.caster:RemoveModifierByName(self.caster_modifier)
				else
					local stack_count = self.caster:GetModifierStackCount(self.caster_modifier, self.caster)
					self.caster:SetModifierStackCount(self.caster_modifier, self.caster, stack_count - self.stacks_to_freeze)
				end
			end
			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_freeze, {duration = self.freeze_duration})
		else --target not frozen
			--talent buff: if Drow doesn't have the buff, apply it
			if self.caster:HasTalent("special_bonus_imba_drow_ranger_4") and not self.caster:HasModifier(self.caster_modifier)  then
				self.caster:AddNewModifier(self.caster, self.ability, self.caster_modifier, {})
				self.caster:SetModifierStackCount(self.caster_modifier, self, 1)
		else
			--talent buff: increase the buff stack count
			local stack_count = self.caster:GetModifierStackCount(self.caster_modifier, self)
			self.caster:SetModifierStackCount(self.caster_modifier, self, stack_count + 1)
		end
		end
	end
end

function modifier_imba_frost_arrows_slow:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}

	return decFunc
end

function modifier_imba_frost_arrows_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_frost_arrows_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow * (-1)
end

function modifier_imba_frost_arrows_slow:IsHidden()
	return false
end

function modifier_imba_frost_arrows_slow:IsPurgable()
	return true
end

function modifier_imba_frost_arrows_slow:IsDebuff()
	return true
end

-- Freeze modifier
modifier_imba_frost_arrows_freeze = class({})

function modifier_imba_frost_arrows_freeze:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true}
	return state
end

function modifier_imba_frost_arrows_freeze:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_imba_frost_arrows_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

function modifier_imba_frost_arrows_freeze:IsHidden()
	return false
end

function modifier_imba_frost_arrows_freeze:IsPurgable()
	return true
end

function modifier_imba_frost_arrows_freeze:IsDebuff()
	return true
end

--#4 Talent movement speed buff modifier
modifier_imba_frost_arrows_buff = class({})

function modifier_imba_frost_arrows_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT ,
		MODIFIER_EVENT_ON_HERO_KILLED}
	return funcs
end

function modifier_imba_frost_arrows_buff:IsPermanent() return true end
function modifier_imba_frost_arrows_buff:IsHidden() return false end
function modifier_imba_frost_arrows_buff:IsPurgable() return false end
function modifier_imba_frost_arrows_buff:IsDebuff() return false end

function modifier_imba_frost_arrows_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.bonus_movespeed = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_4","bonus_movespeed")
end

function modifier_imba_frost_arrows_buff:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movespeed * self:GetStackCount()
end

----------------------------
--		DEADEYE		      --
----------------------------

imba_drow_ranger_deadeye = class({})
LinkLuaModifier("modifier_imba_deadeye_aura", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_deadeye_vision", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_deadeye:GetAbilityTextureName()
	return "custom/drow_deadeye"
end

function imba_drow_ranger_deadeye:IsInnateAbility()
	return true
end

function imba_drow_ranger_deadeye:GetIntrinsicModifierName()
	return "modifier_imba_deadeye_aura"
end

-- Aura modifier
modifier_imba_deadeye_aura = class({})

function modifier_imba_deadeye_aura:OnCreated()
	self.caster = self:GetCaster()
	self.modifier_active = "modifier_imba_trueshot_active"
end

function modifier_imba_deadeye_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_deadeye_aura:GetAuraEntityReject(target)
	if IsServer() then
		-- Never reject caster
		if target == self.caster then
			return false
		end

		-- #7 Talent: Deadeye becomes an aura
		if self.caster:HasTalent("special_bonus_imba_drow_ranger_7") then
			if target:IsHero() then
				return false
			end
		end

		return true
	end
end

function modifier_imba_deadeye_aura:GetAuraRadius()
	return 25000 --global
end

function modifier_imba_deadeye_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_deadeye_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_deadeye_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_deadeye_aura:GetModifierAura()
	return "modifier_imba_deadeye_vision"
end

function modifier_imba_deadeye_aura:IsAura()
	-- Stops working when the caster is Broken
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end

function modifier_imba_deadeye_aura:IsDebuff()
	return false
end

function modifier_imba_deadeye_aura:IsHidden()
	return true
end

function modifier_imba_deadeye_aura:IsPurgable()
	return false
end

-- Vision modifier
modifier_imba_deadeye_vision = class({})

function modifier_imba_deadeye_vision:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.day_vision = self.ability:GetSpecialValueFor("day_vision")
	self.night_vision = self.ability:GetSpecialValueFor("night_vision")
end

function modifier_imba_deadeye_vision:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION}

	return decFunc
end

function modifier_imba_deadeye_vision:GetBonusDayVision()
	local day_vision = self.day_vision
	return day_vision
end

function modifier_imba_deadeye_vision:GetBonusNightVision()
	local night_vision = self.night_vision
	return night_vision
end

function modifier_imba_deadeye_vision:IsHidden()
	return false
end

function modifier_imba_deadeye_vision:IsPurgable()
	return false
end

function modifier_imba_deadeye_vision:IsDebuff()
	return false
end



----------------------------
--			GUST 		  --
----------------------------

imba_drow_ranger_gust = class({})

LinkLuaModifier("modifier_imba_gust_silence", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gust_movement", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_gust_buff", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_gust:GetAbilityTextureName()
	return "drow_ranger_wave_of_silence"
end

function imba_drow_ranger_gust:IsHiddenWhenStolen()
	return false
end

function imba_drow_ranger_gust:GetBehavior()
	--#1 talent allow selfcast
	if self:GetCaster():HasTalent("special_bonus_imba_drow_ranger_1") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_POINT
end

function imba_drow_ranger_gust:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget() --selfcast with #1 talent
	local target_point = self:GetCursorPosition()
	local modifier_movement = "modifier_imba_gust_movement" --for talent #1
	local sound_cast = "Hero_DrowRanger.Silence"
	local particle_gust = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf"

	-- Ability specials
	local wave_speed = ability:GetSpecialValueFor("wave_speed")
	local wave_distance = ability:GetSpecialValueFor("wave_distance")
	local wave_width = ability:GetSpecialValueFor("wave_width")
	local jump_speed = ability:GetSpecialValueFor("jump_speed")
	local leap_range = ability:GetSpecialValueFor("leap_range")


	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	--#3 Talent: Casting gust allow Drow auto attacks, for 5 seconds, to cast mini gusts on the target to knock it 50 units away (no damage/silence)
	if caster:HasTalent("special_bonus_imba_drow_ranger_3") then
		local buff_duration = caster:FindTalentValue("special_bonus_imba_drow_ranger_3", "buff_duration")
		caster:AddNewModifier(caster, ability, "modifier_imba_gust_buff", { duration = buff_duration })
	end

	--#1 Talent: Gust can be selfcast on Drow Ranger, sendind a wave that will push her forward too, silencing any enemy it comes in contact to
	if caster == target and caster:HasTalent("special_bonus_imba_drow_ranger_1") then
		-- Start moving
		local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})

		-- Assign the ending point of gust, sent in the direction Drow has been facing, as the target location in the modifier
		if modifier_movement_handler then
			modifier_movement_handler.target_point = caster:GetAbsOrigin() + (caster:GetForwardVector() * wave_distance)
		end
	end

	--if gust was self cast, set the target point of the gust at 900 units far in the direction drow was facing
	if caster == target then
		target_point = caster:GetAbsOrigin() + (caster:GetForwardVector() * wave_distance)
	end

	Timers:CreateTimer(FrameTime(), function()
		-- Send Gust!
		local gust_projectile = {	Ability = ability,
			EffectName = particle_gust,
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = wave_distance,
			fStartRadius = wave_width,
			fEndRadius = wave_width,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bDeleteOnHit = false,
			vVelocity = (((target_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * wave_speed,
			bProvidesVision = false,
		}

		ProjectileManager:CreateLinearProjectile(gust_projectile)
	end)
end

function imba_drow_ranger_gust:OnProjectileHit(target, location)
	if IsServer() then
		-- Ability properties
		local caster = self:GetCaster()
		local ability = self
		local modifier_silence = "modifier_imba_gust_silence"
		local modifier_chill = "modifier_imba_frost_arrows_slow"
		local frost_arrow_ability = "imba_drow_ranger_frost_arrows"

		-- Ability specials
		local knockback_duration = ability:GetSpecialValueFor("knockback_duration")
		local max_distance = ability:GetSpecialValueFor("max_distance")
		local silence_duration = ability:GetSpecialValueFor("silence_duration")
		local chill_duration = ability:GetSpecialValueFor("chill_duration")
		local chill_stacks = ability:GetSpecialValueFor("chill_stacks")
		local damage = ability:GetSpecialValueFor("damage")

		-- if no target was found, do nothing
		if not target then
			return nil
		end

		-- Calculate knockback distance
		local distance = max_distance - ((target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D())

		-- If the distance is higher than the max distance (negative result), just make it go back a little
		if distance < 0 then
			distance = 50
		end


		-- Knockback properties
		local knockbackProperties =
			{
				center_x = caster:GetAbsOrigin()[1]+1,
				center_y = caster:GetAbsOrigin()[2]+1,
				center_z = caster:GetAbsOrigin()[3],
				duration = knockback_duration,
				knockback_duration = knockback_duration,
				knockback_distance = distance,
				knockback_height = 0,
				should_stun = 0
			}

		-- Apply knockback on enemies hit
		target:AddNewModifier(caster, ability, "modifier_knockback", knockbackProperties)

		-- Deal damage
		local damageTable = {victim = target,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = caster,
			ability = ability
		}

		ApplyDamage(damageTable)

		-- Apply silence
		target:AddNewModifier(caster, ability, modifier_silence, {duration = silence_duration})


		-- if appropriate, apply chill stacks (only if Frost Arrows were learned)
		if caster:HasAbility(frost_arrow_ability) then
			local frost_ability = caster:FindAbilityByName(frost_arrow_ability)
			if frost_ability:GetLevel() > 0 then

				-- Apply stacks or increase stacks if already exists
				if not target:HasModifier(modifier_chill) then
					local modifier = target:AddNewModifier(caster, frost_ability, modifier_chill, {duration = chill_duration})
					if modifier then
						modifier:SetStackCount(chill_stacks)
					end
				else
					local modifier = target:FindModifierByName(modifier_chill)
					modifier:SetStackCount(modifier:GetStackCount() + chill_stacks)
				end
			end
		end
	end
end


-- Silence modifier
modifier_imba_gust_silence = class({})

function modifier_imba_gust_silence:CheckState()
	local state = {[MODIFIER_STATE_SILENCED] = true}
	return state
end

-- Movement modifier (#1 talent only)
modifier_imba_gust_movement = class({})

function modifier_imba_gust_movement:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability specials
		self.jump_speed = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_1","jump_speed")

		-- Variables
		self.time_elapsed = 0
		self.leap_z = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.direction = (self.target_point - self.caster:GetAbsOrigin()):Normalized()

			self.distance = (self.caster:GetAbsOrigin() - self.target_point):Length2D()
			self.jump_time = self.distance / self.jump_speed


			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

function modifier_imba_gust_movement:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal Motion
	self:HorizontalMotion(self.caster, self.frametime)
end

function modifier_imba_gust_movement:IsHidden() return true end
function modifier_imba_gust_movement:IsPurgable() return false end
function modifier_imba_gust_movement:IsDebuff() return false end
function modifier_imba_gust_movement:IgnoreTenacity() return true end
function modifier_imba_gust_movement:IsMotionController() return true end
function modifier_imba_gust_movement:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_gust_movement:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still moving
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self.caster:GetAbsOrigin() + self.direction * self.jump_speed * dt
			self.caster:SetAbsOrigin(new_location)
		else
			self:Destroy()
		end
	end
end

function modifier_imba_gust_movement:OnRemoved()
	if IsServer() then
		self.caster:SetUnitOnClearGround()
	end
end

--#3 Talent: mini-gust modifier

modifier_imba_gust_buff = class({})

function modifier_imba_gust_buff:IsHidden() return false end
function modifier_imba_gust_buff:IsPurgable() return true end
function modifier_imba_gust_buff:IsDebuff() return false end

function modifier_imba_gust_buff:DeclareFunctions()
	local decfunc = {MODIFIER_EVENT_ON_ATTACK_LANDED}
	return decfunc
end


function modifier_imba_gust_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.duration = self:GetDuration()

	-- Ability specials
	self.knockback_duration = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_3","knockback_duration")
	self.knockback_distance = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_3","knockback_distance")
end

function modifier_imba_gust_buff:OnAttackLanded(kv)
	if IsServer() then
		local sound_cast = "Hero_DrowRanger.Silence"
		local knockback_particle = "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf"

		local caster = self.caster
		local ability = self.ability
		local attacker = kv.attacker
		local target = kv.target
		local knockback_duration = self.knockback_duration
		local distance = self.knockback_distance

		-- Knockback properties
		local knockbackProperties =
			{
				center_x = caster:GetAbsOrigin()[1]+1,
				center_y = caster:GetAbsOrigin()[2]+1,
				center_z = caster:GetAbsOrigin()[3],
				duration = knockback_duration,
				knockback_duration = knockback_duration,
				knockback_distance = distance,
				knockback_height = 0,
				should_stun = 0
			}

		--if the attack didn't come from Drow, do nothing
		if attacker ~= caster then
			return nil
		end
		-- Play gust sound effect
		EmitSoundOn(sound_cast, target)
		-- Play Spirit Breaker Greater Bash particle on the target
		local knockback_particle = ParticleManager:CreateParticle(knockback_particle, PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(knockback_particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(knockback_particle, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(knockback_particle, 2, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(knockback_particle)
		-- Apply knockback on the target. Reapply the modifier if it didn't expire yet (can happen when Drow hit 0.4 or less attack time)
		if target:HasModifier("modifier_knockback") then
			target:RemoveModifierByName("modifier_knockback")
		end
		target:AddNewModifier(caster, ability, "modifier_knockback", knockbackProperties)
	end
end

----------------------------
--	   PRECISION AURA     --
----------------------------

imba_drow_ranger_trueshot = class({})
LinkLuaModifier("modifier_imba_trueshot_aura", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trueshot", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trueshot_active", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_trueshot_talent_buff", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_trueshot:GetAbilityTextureName()
	return "drow_ranger_trueshot"
end

function imba_drow_ranger_trueshot:GetIntrinsicModifierName()
	return "modifier_imba_trueshot_aura"
end

function imba_drow_ranger_trueshot:IsHiddenWhenStolen()
	return false
end

function imba_drow_ranger_trueshot:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_active = "modifier_imba_trueshot_active"
	local talent_modifier = "modifier_imba_trueshot_talent_buff"

	-- Ability specials
	local active_duration = ability:GetSpecialValueFor("active_duration")

	-- Add active modifier
	caster:AddNewModifier(caster, ability, modifier_active, {duration = active_duration})

	--#6 talent: Add modifier to Drow
	if caster:HasTalent("special_bonus_imba_drow_ranger_6")	then
		caster:AddNewModifier(caster, ability, talent_modifier, {duration = active_duration})
	end
end

-- Trueshot aura
modifier_imba_trueshot_aura = class({})

function modifier_imba_trueshot_aura:OnCreated()
	self.caster = self:GetCaster()
	self.modifier_active = "modifier_imba_trueshot_active"
end

function modifier_imba_trueshot_aura:GetAuraEntityReject(target)
	-- Don't reject heroes, even illusion ones
	if target:IsHero() then
		return false
	end

	-- Don't reject anyone, including creeps, if the active modifier is active
	if self.caster:HasModifier(self.modifier_active) then
		return false
	end

	return true
end

function modifier_imba_trueshot_aura:GetAuraDuration()
	return 5
end

function modifier_imba_trueshot_aura:GetAuraRadius()
	return 25000 --global
end

function modifier_imba_trueshot_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_trueshot_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_trueshot_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_trueshot_aura:GetModifierAura()
	return "modifier_imba_trueshot"
end

function modifier_imba_trueshot_aura:IsAura()
	-- Not an aura when the caster is broken
	if self.caster:PassivesDisabled() then
		return false
	end

	-- Illusions cannot emit the aura
	if self.caster:IsIllusion() then
		return false
	end

	return true
end

function modifier_imba_trueshot_aura:IsDebuff()
	return false
end

function modifier_imba_trueshot_aura:IsHidden()
	return true
end

function modifier_imba_trueshot_aura:IsPurgable()
	return false
end

-- Trueshot modifier
modifier_imba_trueshot = class({})

function modifier_imba_trueshot:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_active = "modifier_imba_trueshot_active"

	-- Ability specials
	self.agi_to_damage_pct = self.ability:GetSpecialValueFor("agi_to_damage_pct")
	self.melee_reduction_pct = self.ability:GetSpecialValueFor("melee_reduction_pct")
	self.active_bonus_agi_pct = self.ability:GetSpecialValueFor("active_bonus_agi_pct")

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_trueshot:OnIntervalThink()
	if IsServer() then
		-- Update Drow's agility
		local drow_agility = self.caster:GetAgility()

		if self.parent:IsHero() then
			self.parent:CalculateStatBonus()
		end


		-- Set the values in the nettable
		CustomNetTables:SetTableValue( "player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID()), { precision_aura_drow_agility = drow_agility})
	end
end

function modifier_imba_trueshot:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS}

	return decFunc
end

function modifier_imba_trueshot:GetModifierPreAttack_BonusDamage()
	if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())) then
		if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility then
			local drow_agility = CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility

			-- Calculate bonus damage
			local bonus_damage = drow_agility * (self.agi_to_damage_pct/100)

			-- Reduce damage if the target is melee
			if not self.parent:IsRangedAttacker() then
				bonus_damage = bonus_damage * (self.melee_reduction_pct/100)
			end

			return bonus_damage
		end
	end
end

function modifier_imba_trueshot:GetModifierAttackSpeedBonus_Constant()
	return nil
end

function modifier_imba_trueshot:GetModifierBonusStats_Agility()
	-- Check if Drow's agility was indexed
	if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())) then
		if CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility then
			local drow_agility = CustomNetTables:GetTableValue("player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID())).precision_aura_drow_agility
			-- Only applies when the active component works
			if self.caster:HasModifier(self.modifier_active) then
				-- Only applies to heroes
				if self.parent:IsHero() then
					-- Does not apply to Drow herself
					if self.parent ~= self.caster then
						-- Calculate bonus agility
						local bonus_agility = drow_agility * (self.active_bonus_agi_pct/100)
						return bonus_agility
					end
				end
			end
		end
	end

	return nil
end

function modifier_imba_trueshot:IsHidden()
	return false
end

function modifier_imba_trueshot:IsPurgable()
	return false
end

function modifier_imba_trueshot:IsDebuff()
	return false
end

-- Active Trueshot modifier
modifier_imba_trueshot_active = class({})

function modifier_imba_trueshot_active:IsHidden()
	return false
end

function modifier_imba_trueshot_active:IsPurgable()
	return false
end

function modifier_imba_trueshot_active:IsDebuff()
	return false
end

-- Talent buff modifier
modifier_imba_trueshot_talent_buff = class ({})

function modifier_imba_trueshot_talent_buff:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}

	return decFunc
end

function modifier_imba_trueshot_talent_buff:OnCreated()
	--Ability Properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.current_total_agility = 0

	--Ability Specials
	self.agility_bonus_percent = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_6", "agility_bonus_percent")

	if IsServer() then
		self:StartIntervalThink(1)
	end
end

--Calculate total agility of allied heroes
function modifier_imba_trueshot_talent_buff:GetTotalAgilityOfTeam()
	local total_agility = 0
	if IsServer() then
		local allies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			total_agility = total_agility + ally:GetAgility()
		end
		return total_agility
	end
end

function modifier_imba_trueshot_talent_buff:OnIntervalThink()
	if IsServer() then
		--refresh allies agility total every 1 second
		self.current_total_agility = self:GetTotalAgilityOfTeam()
	end
end

--return a % of the total agility of the allied heroes as bonus agility to Drow
function modifier_imba_trueshot_talent_buff:GetModifierBonusStats_Agility()
	local agility_bonus = self.current_total_agility * (self.agility_bonus_percent / 100)
	return agility_bonus
end

function modifier_imba_trueshot_talent_buff:IsDebuff() return false end
function modifier_imba_trueshot_talent_buff:IsPurgable() return true end
function modifier_imba_trueshot_talent_buff:IsHidden() return false end



----------------------------
--	  MARKSMANSHIP        --
----------------------------

imba_drow_ranger_marksmanship = class({})
LinkLuaModifier("modifier_imba_marksmanship", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_marksmanship_scepter_dmg_reduction", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_aura", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_buff", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_slow", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_marksmanship:GetAbilityTextureName()
	return "drow_ranger_marksmanship"
end

function imba_drow_ranger_marksmanship:GetIntrinsicModifierName()
	return "modifier_imba_marksmanship"
end

function imba_drow_ranger_marksmanship:OnUpgrade()
	-- This is needed to renew values to the correct levels
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local modifier_markx = "modifier_imba_marksmanship"

		if caster:HasModifier(modifier_markx) then
			caster:RemoveModifierByName(modifier_markx)
			caster:AddNewModifier(caster, ability, modifier_markx, {})
		end
	end
end

-- Agility bonus modifier
modifier_imba_marksmanship = class({})

function modifier_imba_marksmanship:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_start = "particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf"
	self.particle_marksmanship = "particles/units/heroes/hero_drow/drow_marksmanship.vpcf"
	self.talent_aura = "modifier_imba_markmanship_aura" -- talent #5

	-- Ability specials
	self.agility_bonus = self.ability:GetSpecialValueFor("agility_bonus")
	self.range_bonus = self.ability:GetSpecialValueFor("range_bonus")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.damage_reduction_scepter = self.ability:GetSpecialValueFor("damage_reduction_scepter")
	self.splinter_radius_scepter = self.ability:GetSpecialValueFor("splinter_radius_scepter")

	if IsServer() then
		-- Assign Marksmanship variable
		self.marksmanship_enabled = false

		self:StartIntervalThink(0.25)
	end
end

function modifier_imba_marksmanship:OnIntervalThink()
	if IsServer() then

		-- #5 Talent: enable the aura if Markmanship isn't disabled, other way around if it's disabled
		if self.caster:HasTalent("special_bonus_imba_drow_ranger_5") then
			if self.marksmanship_enabled and not self.caster:HasModifier(self.talent_aura) then
				self.caster:AddNewModifier(self.caster, self.ability, self.talent_aura, {})
			elseif not self.marksmanship_enabled and self.caster:HasModifier(self.talent_aura) then
				self.caster:RemoveModifierByName(self.talent_aura)
			end
		end

		-- #8 Talent: Marksmanship no longer disables itself
		-- Find enemies nearby
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false)

		if not self.caster:HasTalent("special_bonus_imba_drow_ranger_8") then
			-- If there are enemies near drow, destroy particles and disable Marksmanship
			if #enemies > 0 and self.marksmanship_enabled then
				ParticleManager:DestroyParticle(self.particle_marksmanship_fx, false)
				ParticleManager:ReleaseParticleIndex(self.particle_marksmanship_fx)

				self.marksmanship_enabled = false
			end
		end

		-- If there aren't and Marksmanship was disabled, enable it and activate particles
		if not self.marksmanship_enabled and #enemies == 0 then
			-- Apply start particle
			self.particle_start_fx = ParticleManager:CreateParticle(self.particle_start, PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(self.particle_start_fx, 0, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.particle_start_fx)

			-- Apply marksmanship particle
			self.particle_marksmanship_fx = ParticleManager:CreateParticle(self.particle_marksmanship, PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 0, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 2, Vector(2,0,0))
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 3, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_marksmanship_fx, 5, self.caster:GetAbsOrigin())

			self.marksmanship_enabled = true
		end

		-- Either way, recalculate stats.
		self.caster:CalculateStatBonus()
	end
end

function modifier_imba_marksmanship:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFunc
end

function modifier_imba_marksmanship:GetModifierAttackRangeBonus()
	-- Do nothing if caster is disabled by break
	if self.caster:PassivesDisabled() then
		return nil
	end

	return self.range_bonus
end

function modifier_imba_marksmanship:GetModifierBonusStats_Agility()
	if IsServer() then
		-- Do nothing if caster is disabled by break
		if self.caster:PassivesDisabled() then
			return nil
		end

		-- Only apply if Marksmanship is enabled
		if self.marksmanship_enabled then
			local agility_bonus = self.agility_bonus
			return agility_bonus
		end
	end
end

function modifier_imba_marksmanship:OnAttackLanded(keys)
	if IsServer() then
		local scepter = self.caster:HasScepter()
		local target = keys.target
		local attacker = keys.attacker
		local modifier_frost = "modifier_imba_frost_arrows_thinker"

		-- Only apply on caster's attacks, and only when she has scepter
		if self.caster == attacker and scepter then
			-- Find enemies near the target's hit location
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
				target:GetAbsOrigin(),
				nil,
				self.splinter_radius_scepter,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
				FIND_ANY_ORDER,
				false)

			-- If any enemies were found, splinter an attack towards them
			if #enemies > 0 then
				for _,enemy in pairs(enemies) do
					-- Ignore the original target
					if enemy ~= target then
						-- Launch an arrow
						local arrow_projectile

						arrow_projectile = {hTarget = enemy,
							hCaster = target,
							hAbility = self.ability,
							iMoveSpeed = self.caster:GetProjectileSpeed(),
							EffectName = self.caster:GetRangedProjectileName(),
							SoundName = "",
							flRadius = 1,
							bDodgeable = true,
							bDestroyOnDodge = true,
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
							OnProjectileHitUnit = function(params, projectileID)
								SplinterArrowHit(params, projectileID, self)
							end
						}

						TrackingProjectiles:Projectile(arrow_projectile)
					end
				end
			end
		end
	end
end

function SplinterArrowHit(keys, projectileID, modifier)
	local caster = modifier.caster
	local target = keys.hTarget
	local modifier_reduction = "modifier_imba_marksmanship_scepter_dmg_reduction"

	-- Give caster the weakening effect
	caster:AddNewModifier(modifier.caster, modifier.ability, modifier_reduction, {})

	-- Perform an instant attack on hit enemy
	caster:PerformAttack(target, false, false, true, true, false, false, false)

	-- Remove weakening effect from caster
	caster:RemoveModifierByName(modifier_reduction)

	-- Access the Frost Attack modifier
	if modifier.caster:HasModifier("modifier_imba_frost_arrows_thinker") then
		local modifier_frost = modifier.caster:FindModifierByName("modifier_imba_frost_arrows_thinker")
		ApplyFrostAttack(modifier_frost, target)
	end
end

function modifier_imba_marksmanship:IsPurgable()
	return false
end

function modifier_imba_marksmanship:IsHidden()
	return true
end

function modifier_imba_marksmanship:IsDebuff()
	return false
end

function modifier_imba_marksmanship:OnDestroy()
	-- Make sure the particles don't stay on Drow
	if self.particle_marksmanship_fx then
		ParticleManager:DestroyParticle(self.particle_marksmanship_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_marksmanship_fx)
	end
end

-- Scepter splinter damage reduction modifier
modifier_imba_marksmanship_scepter_dmg_reduction = class({})

function modifier_imba_marksmanship_scepter_dmg_reduction:OnCreated()
	self.ability = self:GetAbility()
	self.damage_reduction_scepter = self.ability:GetSpecialValueFor("damage_reduction_scepter")
end

function modifier_imba_marksmanship_scepter_dmg_reduction:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}

	return decFunc
end

function modifier_imba_marksmanship_scepter_dmg_reduction:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction_scepter * (-1)
end


--Talent aura
modifier_imba_markmanship_aura = class({})

function modifier_imba_markmanship_aura:OnCreated()
	--Ability Properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
end

function modifier_imba_markmanship_aura:GetAuraEntityReject(target)
	-- Heroes only
	if target:IsHero() and not target:IsIllusion() then
		return false
	end
	return true
end

function modifier_imba_markmanship_aura:GetAuraRadius()
	return self.caster:FindTalentValue("special_bonus_imba_drow_ranger_5", "aura_radius")
end

function modifier_imba_markmanship_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_markmanship_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_markmanship_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_markmanship_aura:GetModifierAura()
	return "modifier_imba_markmanship_buff"
end

function modifier_imba_markmanship_aura:IsAura()
	-- Not an aura when the caster is broken
	if self.caster:PassivesDisabled() then
		return false
	end

	-- Illusions cannot emit the aura
	if self.caster:IsIllusion() then
		return false
	end

	return true
end

function modifier_imba_markmanship_aura:IsDebuff()
	return false
end

function modifier_imba_markmanship_aura:IsHidden()
	return true
end

function modifier_imba_markmanship_aura:IsPurgable()
	return false
end

-- Markmanship talent aura modifier for allies
modifier_imba_markmanship_buff = class({})

function modifier_imba_markmanship_buff:DeclareFunctions()
	local decfunc = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decfunc
end

function modifier_imba_markmanship_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier = "modifier_imba_markmanship_slow"

	-- Ability specials
	self.duration = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_5", "duration")
end

function modifier_imba_markmanship_buff:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- Only apply on the hero attack
		if self.parent == attacker then

			-- Only apply if the target isn't magic immune or a building
			if not target:IsMagicImmune() and not target:IsBuilding() then
				target:AddNewModifier(self.caster, self.ability, self.modifier, {duration = self.duration})
			end
		end
	end
end

function modifier_imba_markmanship_buff:IsHidden()
	return false
end

function modifier_imba_markmanship_buff:IsPurgable()
	return false
end

function modifier_imba_markmanship_buff:IsDebuff()
	return false
end


-- talent aura slow modifier
modifier_imba_markmanship_slow = class({})

function modifier_imba_markmanship_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self:GetDuration()

	-- Ability specials
	self.slow_pct = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_5", "slow_pct")
end

function modifier_imba_markmanship_slow:GetTexture()
	return "drow_ranger_frost_arrows"
end

function modifier_imba_markmanship_slow:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_imba_markmanship_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_markmanship_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_markmanship_slow:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFunc
end

function modifier_imba_markmanship_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct * (-1)
end

function modifier_imba_markmanship_slow:IsHidden()
	return false
end

function modifier_imba_markmanship_slow:IsPurgable()
	return true
end

function modifier_imba_markmanship_slow:IsDebuff()
	return true
end
