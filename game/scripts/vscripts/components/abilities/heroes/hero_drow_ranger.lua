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

function imba_drow_ranger_frost_arrows:GetIntrinsicModifierName()
	return "modifier_imba_frost_arrows_thinker"
end

function imba_drow_ranger_frost_arrows:GetCastRange(Location, Target)
	return self:GetCaster():Script_GetAttackRange()
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

		-- Replenish mana cost (since it's spent on the OnAttack function) (note that this basically gives free mana if WTF mode is on and you continuously cancel the cast but I guess that's not a normal issue?...)
		ability:RefundManaCost()
	end
end

-- Frost arrows thinker modifier
modifier_imba_frost_arrows_thinker = class({})



function modifier_imba_frost_arrows_thinker:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ORDER
	}
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
			-- (This one does not respect mana loss reductions so I'm commenting it out and using the IsFullyCastable function below instead)
			-- if self.current_mana < self.mana_cost then
				-- frost_attack = false
			-- end
			
			if not self.ability:IsFullyCastable() then
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
			self.ability:UseResources(true, false, false, false)
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
			local modifier_slow_handler = target:AddNewModifier(modifier.caster, modifier.ability, modifier.modifier_slow, {duration = duration * (1 - target:GetStatusResistance())})
			if modifier_slow_handler then
				modifier_slow_handler:IncrementStackCount()
			end
		else
			local modifier_slow_handler = target:FindModifierByName(modifier.modifier_slow)
			modifier_slow_handler:IncrementStackCount()
			modifier_slow_handler:SetDuration(modifier_slow_handler:GetDuration() * (1 - target:GetStatusResistance()), true)
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

function SetArrowAttackProjectile(caster, frost_attack, marksmanship_attack)
	if marksmanship_attack then
		local marksmanship_arrow = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"

		if frost_attack then
			marksmanship_arrow = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"
		end

		caster:SetRangedProjectileName(marksmanship_arrow)

		return
	end

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
	-- Non frost attack
	else
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
		-- Lifesteal
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
	self.modifier_freeze = "modifier_imba_frost_arrows_freeze"
	self.caster_modifier = "modifier_imba_frost_arrows_buff" -- talent movement speed buff

-- Ability specials
	if self:GetAbility():GetName() == "imba_drow_ranger_frost_arrows_723" then
		self.ms_slow_pct = self.ability:GetSpecialValueFor("frost_arrows_movement_speed")
	else	
		self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct") * (-1)
	end
	
	self.as_slow = self.ability:GetSpecialValueFor("as_slow")
	self.stacks_to_freeze = self.ability:GetSpecialValueFor("stacks_to_freeze")
	self.freeze_duration = self.ability:GetSpecialValueFor("freeze_duration")
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

function modifier_imba_frost_arrows_slow:GetStatusEffectName()
--	if self:GetStackCount() == 1 then
--		return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
--	end

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

			self.parent:AddNewModifier(self.caster, self.ability, self.modifier_freeze, {duration = self.freeze_duration * (1 - self.parent:GetStatusResistance())})

			-- Play freeze sound
			EmitSoundOn("hero_Crystal.frostbite", self.parent)
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
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_frost_arrows_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct
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
	return {
		[MODIFIER_STATE_ROOTED]		= true,
		[MODIFIER_STATE_DISARMED]	= true
	}
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
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function modifier_imba_frost_arrows_buff:IsHidden() return false end
function modifier_imba_frost_arrows_buff:IsPurgable() return false end
function modifier_imba_frost_arrows_buff:RemoveOnDeath() return false end

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

---------------------------------------
-- IMBA_DROW_RANGER_FROST_ARROWS_723 --
---------------------------------------

LinkLuaModifier("modifier_generic_orb_effect_lua", "components/modifiers/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_frost_arrows_723_bonus_damage", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

imba_drow_ranger_frost_arrows_723						= imba_drow_ranger_frost_arrows_723 or class({})
modifier_imba_drow_ranger_frost_arrows_723_bonus_damage	= modifier_imba_drow_ranger_frost_arrows_723_bonus_damage or class({})

function imba_drow_ranger_frost_arrows_723:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function imba_drow_ranger_frost_arrows_723:GetProjectileName()
	return "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end

function imba_drow_ranger_frost_arrows_723:OnOrbRecord()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_drow_ranger_frost_arrows_723_bonus_damage", {})
end

function imba_drow_ranger_frost_arrows_723:OnOrbFire()
	self:GetCaster():EmitSound("Hero_DrowRanger.FrostArrows")
end

function imba_drow_ranger_frost_arrows_723:OnOrbImpact( keys )
	-- Apply slow effect if the target didn't suddenly become magic immune
	if not keys.target:IsMagicImmune() then
		local modifier_slow_handler = keys.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_frost_arrows_slow", {duration = self:GetDuration() * (1 - keys.target:GetStatusResistance())})
		
		if modifier_slow_handler then
			modifier_slow_handler:IncrementStackCount()
		end
	end
end

function imba_drow_ranger_frost_arrows_723:OnOrbRecordDestroy()
	self:GetCaster():RemoveModifierByName("modifier_imba_drow_ranger_frost_arrows_723_bonus_damage")
end

-------------------------------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_FROST_ARROWS_723_BONUS_DAMAGE --
-------------------------------------------------------------

function modifier_imba_drow_ranger_frost_arrows_723_bonus_damage:IsHidden()		return true end
function modifier_imba_drow_ranger_frost_arrows_723_bonus_damage:IsPurgable()	return false end

function modifier_imba_drow_ranger_frost_arrows_723_bonus_damage:OnCreated()
	if not IsServer() then return end
	
	self.damage	= self:GetAbility():GetTalentSpecialValueFor("damage")
end

function modifier_imba_drow_ranger_frost_arrows_723_bonus_damage:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_imba_drow_ranger_frost_arrows_723_bonus_damage:GetModifierPreAttack_BonusDamage()
	return self.damage
end

----------------------------
--		DEADEYE		      --
----------------------------

imba_drow_ranger_deadeye = class({})
LinkLuaModifier("modifier_imba_deadeye_aura", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_deadeye_vision", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

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
	if self.caster:IsNull() or self.caster:PassivesDisabled() then
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

function imba_drow_ranger_gust:GetCastRange(location, target)
	return self:GetSpecialValueFor("wave_distance") + (self:GetCaster():FindTalentValue("special_bonus_imba_drow_ranger_9"))
end

function imba_drow_ranger_gust:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget() --selfcast with #1 talent
	local target_point = self:GetCursorPosition()

	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if target_point == self:GetCaster():GetAbsOrigin() then
		target_point = self:GetCursorPosition() + self:GetCaster():GetForwardVector()
	end

	local modifier_movement = "modifier_imba_gust_movement" --for talent #1
	local sound_cast = "Hero_DrowRanger.Silence"
	local particle_gust = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf"

	-- Ability specials
	local wave_speed = ability:GetSpecialValueFor("wave_speed")
	local wave_distance = ability:GetSpecialValueFor("wave_distance") + caster:FindTalentValue("special_bonus_imba_drow_ranger_9")
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
		local max_distance = ability:GetSpecialValueFor("max_distance") + caster:FindTalentValue("special_bonus_imba_drow_ranger_9")
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
				duration = knockback_duration * (1 - target:GetStatusResistance()),
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
		target:AddNewModifier(caster, ability, modifier_silence, {duration = silence_duration * (1 - target:GetStatusResistance())})


		-- if appropriate, apply chill stacks (only if Frost Arrows were learned)
		if caster:HasAbility(frost_arrow_ability) or caster:HasAbility("imba_drow_ranger_frost_arrows_723") then
			local frost_ability = caster:FindAbilityByName(frost_arrow_ability) or caster:FindAbilityByName("imba_drow_ranger_frost_arrows_723")
			if frost_ability:GetLevel() > 0 then

				-- Apply stacks or increase stacks if already exists
				if not target:HasModifier(modifier_chill) then
					local modifier = target:AddNewModifier(caster, frost_ability, modifier_chill, {duration = chill_duration * (1 - target:GetStatusResistance())})
					if modifier then
						modifier:SetStackCount(chill_stacks)
					end
				else
					local modifier = target:FindModifierByName(modifier_chill)
					modifier:SetStackCount(modifier:GetStackCount() + chill_stacks)
					modifier:SetDuration(chill_duration * (1 - target:GetStatusResistance()), true)
				end
			end
		end
	end
end


-- Silence modifier
modifier_imba_gust_silence = class({})

function modifier_imba_gust_silence:CheckState()
	return {[MODIFIER_STATE_SILENCED] = true}
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
				duration = knockback_duration * (1 - target:GetStatusResistance()),
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
			self.parent:CalculateStatBonus(true)
		end


		-- Set the values in the nettable
		CustomNetTables:SetTableValue( "player_table", "precision_aura_drow_agility"..tostring(self.parent:GetPlayerOwnerID()), { precision_aura_drow_agility = drow_agility})
	end
end

function modifier_imba_trueshot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
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
	return self:GetAbility():GetLevel() <= 0
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
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end

function modifier_imba_trueshot_talent_buff:OnCreated()
	--Ability Properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.current_total_agility = 0

	--Ability Specials
	self.agility_bonus_percent = self.caster:FindTalentValue("special_bonus_imba_drow_ranger_6", "agility_bonus_percent")

	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(0.1)
	end
end

--Calculate total agility of allied heroes
function modifier_imba_trueshot_talent_buff:GetTotalAgilityOfTeam()
	local total_agility = 0
	
	if IsServer() then
		for _, ally in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS , FIND_ANY_ORDER, false)) do
			if ally.GetAgility then
				total_agility = total_agility + ally:GetAgility()
			end
		end
		
		return total_agility
	end
end

function modifier_imba_trueshot_talent_buff:OnIntervalThink()
	-- self.current_total_agility = self:GetTotalAgilityOfTeam()
	self:SetStackCount(self:GetTotalAgilityOfTeam() * (self.agility_bonus_percent / 100))
end

--return a % of the total agility of the allied heroes as bonus agility to Drow
function modifier_imba_trueshot_talent_buff:GetModifierBonusStats_Agility()
	-- return self.current_total_agility * (self.agility_bonus_percent / 100)
	return self:GetStackCount()
end

function modifier_imba_trueshot_talent_buff:IsDebuff() return false end
function modifier_imba_trueshot_talent_buff:IsPurgable() return true end
function modifier_imba_trueshot_talent_buff:IsHidden() return false end



--------------------------------
-- IMBA_DROW_RANGER_MULTISHOT --
--------------------------------

LinkLuaModifier("modifier_imba_drow_ranger_multishot", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

imba_drow_ranger_multishot			= imba_drow_ranger_multishot or class({})
modifier_imba_drow_ranger_multishot	= modifier_imba_drow_ranger_multishot or class({})

function imba_drow_ranger_multishot:OnSpellStart()
	self.targets_hit = {}

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_drow_ranger_multishot", {duration = self:GetChannelTime()})
end

function imba_drow_ranger_multishot:OnChannelFinish(bInterrupted)
	self:GetCaster():RemoveModifierByName("modifier_imba_drow_ranger_multishot")
end

function imba_drow_ranger_multishot:OnProjectileHit_ExtraData(target, location, ExtraData)
	if not self.targets_hit[ExtraData.volley_index] then
		self.targets_hit[ExtraData.volley_index] = {}
	end
		
	if target and not self.targets_hit[ExtraData.volley_index][target:entindex()] then
		target:EmitSound("Hero_DrowRanger.ProjectileImpact")
	
		if self:GetCaster():HasAbility("imba_drow_ranger_frost_arrows_723") and self:GetCaster():FindAbilityByName("imba_drow_ranger_frost_arrows_723"):IsTrained() then
			if not target:IsMagicImmune() then
				local frost_modifier = target:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_drow_ranger_frost_arrows_723"), "modifier_imba_frost_arrows_slow", {duration = self:GetSpecialValueFor("arrow_slow_duration") * (1 - target:GetStatusResistance())})
				
				if frost_modifier then
					frost_modifier:IncrementStackCount()
				end
			end
		end
	
		ApplyDamage({
			victim 			= target,
			damage 			= ((self:GetCaster():GetBaseDamageMax() + self:GetCaster():GetBaseDamageMin()) / 2)  * self:GetSpecialValueFor("arrow_damage_pct") * 0.01,
			damage_type		= DAMAGE_TYPE_PHYSICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
		
		self.targets_hit[ExtraData.volley_index][target:entindex()] = true
		
		-- Returning true deestroys the projectile upon land
		return true
	end
end

-- function imba_drow_ranger_multishot:GetPlaybackRateOverride()
	-- return 2
-- end

-----------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_MULTISHOT --
-----------------------------------------

-- "Releases the waves in a 0.55-second interval .The first wave starts 0.1 seconds after channel begin. "
function modifier_imba_drow_ranger_multishot:OnCreated()
	self.arrow_count			= self:GetAbility():GetSpecialValueFor("arrow_count")
	self.arrow_damage_pct		= self:GetAbility():GetTalentSpecialValueFor("arrow_damage_pct")
	self.arrow_slow_duration	= self:GetAbility():GetSpecialValueFor("arrow_slow_duration")
	self.arrow_width			= self:GetAbility():GetSpecialValueFor("arrow_width")
	self.arrow_speed			= self:GetAbility():GetSpecialValueFor("arrow_speed")
	self.arrow_range_multiplier	= self:GetAbility():GetSpecialValueFor("arrow_range_multiplier")
	self.arrow_angle			= self:GetAbility():GetSpecialValueFor("arrow_angle")
	
	self.volley_interval		= self:GetAbility():GetSpecialValueFor("volley_interval")
	self.arrow_interval			= self:GetAbility():GetSpecialValueFor("arrow_interval")
	self.initial_delay			= self:GetAbility():GetSpecialValueFor("initial_delay")

	if not IsServer() then return end
	
	self.arrows_per_salvo		= math.floor(self.arrow_count / 3)
	-- "The cone's angle is calculated as if 6 arrows get released per wave. If 6 arrows would get released, the cone's angle would be 50°."
	-- "However, since only 4 arrows get released, the cone's angle is 33.33°, with an angle of 8.33° between each arrow."
	self.angle_per_arrow		= (self.arrow_angle / 6) / 2
	self.adjusted_angle			= (self.angle_per_arrow * self.arrows_per_salvo)
	
	self.num_arrow_in_salvo		= 1
	self.volley_index			= 1
	
	self:GetParent():EmitSound("Hero_DrowRanger.Multishot.Channel")

	self.first_salvo = true
	
	self:StartIntervalThink(self.initial_delay)
end

function modifier_imba_drow_ranger_multishot:OnIntervalThink()	
	self:GetParent():EmitSound("Hero_DrowRanger.Multishot.Attack")
	-- self:GetParent():EmitSound("Hero_DrowRanger.Multishot.FrostArrows")
	
	ProjectileManager:CreateLinearProjectile({
		Ability				= self:GetAbility(),
		EffectName			= "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf",
		vSpawnOrigin		= self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_attack1")),
		fDistance			= self:GetParent():Script_GetAttackRange() * self.arrow_range_multiplier,
		fStartRadius		= self.arrow_width,
		fEndRadius			= self.arrow_width,
		Source				= self:GetParent(),
		bHasFrontalCone		= false,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime 		= GameRules:GetGameTime() + 10.0,
		bDeleteOnHit		= true,
		vVelocity			= RotatePosition(Vector(0, 0, 0), QAngle(0, - self.adjusted_angle + (self.angle_per_arrow * self.num_arrow_in_salvo * 2), 0), self:GetParent():GetForwardVector()) * self.arrow_speed,
		bProvidesVision		= true,
		iVisionRadius		= 100,
		iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
		
		ExtraData			=
		{
			volley_index	= self.volley_index
		}
	})
	
	if self.num_arrow_in_salvo < self.arrows_per_salvo then
		self:StartIntervalThink(self.arrow_interval)
	else
		-- "Releases the waves in a 0.55-second interval .The first wave starts 0.1 seconds after channel begin. "
		self:StartIntervalThink(math.max((self.volley_interval - (self.arrow_interval * (self.arrows_per_salvo - 1))), 0))
		self.volley_index	= self.volley_index + 1
	end
	
	self.num_arrow_in_salvo	= (self.num_arrow_in_salvo % self.arrows_per_salvo) + 1
end

function modifier_imba_drow_ranger_multishot:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_DrowRanger.Multishot.Channel")
end

----------------------------
--	  MARKSMANSHIP        --
----------------------------

imba_drow_ranger_marksmanship = class({})
LinkLuaModifier("modifier_imba_marksmanship", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_marksmanship_scepter_dmg_reduction", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_aura", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_buff", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_markmanship_slow", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_marksmanship_proc_armor", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

function imba_drow_ranger_marksmanship:GetAbilityTextureName()
	if not IsClient() then return end
	if not self:GetCaster().arcana_style then return "drow_ranger_marksmanship" end
	return "drow_ranger_marksmanship_ti9"
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
		local enemies = FindUnitsInRadius(
			self.caster:GetTeamNumber(),
			self.caster:GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false
		)

		if not self.caster:HasTalent("special_bonus_imba_drow_ranger_8") then
			-- If there are enemies near drow, destroy particles and disable Marksmanship
			if #enemies > 0 and self.marksmanship_enabled then
				ParticleManager:DestroyParticle(self.particle_marksmanship_fx, false)
				ParticleManager:ReleaseParticleIndex(self.particle_marksmanship_fx)

				self.marksmanship_enabled = false
			end
		end

		-- If there aren't and Marksmanship was disabled, enable it and activate particles
		if not self.marksmanship_enabled and (#enemies == 0 or self.caster:HasTalent("special_bonus_imba_drow_ranger_8")) then
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
		self.caster:CalculateStatBonus(true)
	end
end

function modifier_imba_marksmanship:DeclareFunctions()
	return {
--		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end

function modifier_imba_marksmanship:GetModifierAttackRangeBonus()
	-- Do nothing if caster is disabled by break
	if self.caster:PassivesDisabled() then
		return nil
	end

	if self.marksmanship_enabled == false then
		return nil
	end

	return self.range_bonus
end

--[[
-- not ignoring armor for reasons
function modifier_imba_marksmanship:GetModifierIgnorePhysicalArmor()
	
	-- Do nothing if caster is disabled by break
		if self.caster:PassivesDisabled() then
			print("Passive disabled")
			return 0
		end

		-- Only apply if Marksmanship is enabled
		if self.marksmanship_enabled == false then
			print("Marksmanship disabled")
			return 0
		end

	print("Everything's fine! Proc?", self:GetStackCount())
	return self:GetStackCount()
end
--]]

function modifier_imba_marksmanship:GetModifierProjectileName()
	if self:GetStackCount() == 1 then
		return "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
	end
end

function modifier_imba_marksmanship:OnAttackStart(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker

		-- Only apply on caster's attacks
		if self.caster == attacker then
			-- Instantly kill creeps if the luck is with you
			if self:GetAbility() and self:GetAbility():IsTrained() and not self.caster:IsIllusion() and RandomInt(1, 100) < self:GetAbility():GetSpecialValueFor("proc_chance") and self.marksmanship_enabled and not self.caster:PassivesDisabled() and (not target:IsBuilding() and not target:IsOther() and attacker:GetTeamNumber() ~= target:GetTeamNumber()) then
				self:SetStackCount(1)
				--SetArrowAttackProjectile(attacker, false, true)
			end
		end
	end
end

function modifier_imba_marksmanship:GetModifierTotalDamageOutgoing_Percentage( params )
	if IsServer() then
		if not self.caster:IsIllusion() and params.target and not params.inflictor and self:GetStackCount() == 1 then
			if params.target:IsBuilding() or params.target:IsOther() or params.attacker:GetTeamNumber() == params.target:GetTeamNumber() then
				-- ignore buildings and allies
			elseif params.target:IsConsideredHero() or params.target:IsRoshan() then
				if params.target:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("instakill_threshold") and not params.target:HasModifier("modifier_oracle_false_promise_timer") then
					if not params.target:IsRoshan() then
						params.target:Kill(self:GetAbility(), params.attacker)
					end
				else
					-- local armor = params.target:GetPhysicalArmorValue(false)
					-- local real_damage

					-- if armor > 0 then
						-- real_damage = CalculateReductionFromArmor_Percentage((armor - armor), armor)
					-- end

					-- Technically this isn't "correct" because the extra damage is supposed to be an "attack" but I can't be assed to figure out how to replicate it properly along with the armor piercing
					local damageTable = {
						victim 			= params.target,
						damage 			= self:GetAbility():GetSpecialValueFor("bonus_damage"),
						damage_type		= DAMAGE_TYPE_PHYSICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL,
						attacker 		= self.caster,
						ability 		= self:GetAbility()
					}
										
					ApplyDamage(damageTable)
					
					-- -- This seems to be the true calculation for simulating damage piercing armor (minus the safety math.max)
					-- return (100 / math.max((1 + real_damage), 0.001)) - 100
				end
			else
				params.target:Kill(self:GetAbility(), params.attacker)
			end

			self:SetStackCount(0)
			params.target:EmitSound("Hero_DrowRanger.Marksmanship.Target")
		end

		return 0
	end
end

function modifier_imba_marksmanship:OnAttackLanded(keys)
	if IsServer() then
		if self.caster:IsNull() then return end
	
		local scepter = self.caster:HasScepter()
		local target = keys.target
		local attacker = keys.attacker
		local modifier_frost = "modifier_imba_frost_arrows_thinker"

		-- Only apply on caster's attacks
		if self.caster == attacker then
			if self:GetStackCount() == 1 then
				keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drow_ranger_marksmanship_proc_armor", {duration = 0.01})
			end
		
			-- Only apply when she has scepter
			if scepter then
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
end

-- function modifier_imba_marksmanship:OnAttackRecordDestroy(keys)
	-- keys.target:RemoveModifierByName("modifier_imba_drow_ranger_marksmanship_proc_armor")
-- end

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
	return {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
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

function modifier_imba_markmanship_aura:GetAuraEntityReject(target)
	return not self:GetAbility() or not self:GetAbility():IsTrained()
end

-- Markmanship talent aura modifier for allies
modifier_imba_markmanship_buff = class({})

function modifier_imba_markmanship_buff:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
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
				target:AddNewModifier(self.caster, self.ability, self.modifier, {duration = self.duration * (1 - target:GetStatusResistance())})
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
	return "drow_ranger_marksmanship"
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
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
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

-------------------------------------------------------
-- modifier_imba_drow_ranger_marksmanship_proc_armor --
-------------------------------------------------------

modifier_imba_drow_ranger_marksmanship_proc_armor	= modifier_imba_drow_ranger_marksmanship_proc_armor or class({})

-- function modifier_imba_drow_ranger_marksmanship_proc_armor:IsHidden()		return true end
function modifier_imba_drow_ranger_marksmanship_proc_armor:IsPurgable()		return false end

function modifier_imba_drow_ranger_marksmanship_proc_armor:OnCreated()
	if not IsServer() then return end
end

function modifier_imba_drow_ranger_marksmanship_proc_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR}
end

function modifier_imba_drow_ranger_marksmanship_proc_armor:GetModifierIgnorePhysicalArmor(keys)
	return 1
end

---------------------------------------
-- IMBA_DROW_RANGER_MARKSMANSHIP_723 --
---------------------------------------

LinkLuaModifier("modifier_imba_drow_ranger_marksmanship_723", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_marksmanship_723_aura_bonus", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_drow_ranger_marksmanship_723_proc_damage", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_marksmanship_723_proc_armor", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

imba_drow_ranger_marksmanship_723						= imba_drow_ranger_marksmanship_723 or class({})
modifier_imba_drow_ranger_marksmanship_723				= modifier_imba_drow_ranger_marksmanship_723 or class({})
modifier_imba_drow_ranger_marksmanship_723_aura_bonus	= modifier_imba_drow_ranger_marksmanship_723_aura_bonus or class({})

modifier_imba_drow_ranger_marksmanship_723_proc_damage	= modifier_imba_drow_ranger_marksmanship_723_proc_damage or class({})
modifier_imba_drow_ranger_marksmanship_723_proc_armor	= modifier_imba_drow_ranger_marksmanship_723_proc_armor or class({})

function imba_drow_ranger_marksmanship_723:GetIntrinsicModifierName()
	return "modifier_imba_drow_ranger_marksmanship_723"
end

------------------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_MARKSMANSHIP_723 --
------------------------------------------------

function modifier_imba_drow_ranger_marksmanship_723:OnCreated()
	self.procs						= {}
	
	if not IsServer() then return end

	self.marksmanship_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_marksmanship.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.marksmanship_particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.marksmanship_particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(self.marksmanship_particle, 5, self:GetParent():GetAbsOrigin())

	self:StartIntervalThink(0.1)
end

function modifier_imba_drow_ranger_marksmanship_723:OnIntervalThink()
	if #FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("disable_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD +  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false) >= 1 then
		if self.marksmanship_particle then
			ParticleManager:SetParticleControl(self.marksmanship_particle, 2, Vector(1, 0, 0))
		end
		
		self.start_particle = nil
		self:SetStackCount(-1)
	elseif not self.start_particle then
		self.start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.start_particle)
		self:SetStackCount(0)
		
		ParticleManager:SetParticleControl(self.marksmanship_particle, 2, Vector(2, 0, 0))
	end
end

function modifier_imba_drow_ranger_marksmanship_723:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		
		-- IMBAfication: Perfect Ranger
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_imba_drow_ranger_marksmanship_723:OnAttackRecord(keys)
	if keys.attacker == self:GetParent() then
		if not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and self.start_particle and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= keys.attacker:GetTeamNumber() and RollPseudoRandom(self:GetAbility():GetTalentSpecialValueFor("chance"), self) then
			self.procs[keys.record] = true
			
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drow_ranger_marksmanship_723_proc_damage", {})
		else
		end
	end
end

function modifier_imba_drow_ranger_marksmanship_723:OnAttack(keys)
	if keys.attacker == self:GetParent() and self.procs[keys.record] then
		self:GetParent():RemoveModifierByName("modifier_imba_drow_ranger_marksmanship_723_proc_damage")
		
		if self:GetParent():HasAbility("imba_drow_ranger_frost_arrows_723") and not self.frost_arrow_modifier then
			for _, mod in pairs(self:GetParent():FindAllModifiersByName("modifier_generic_orb_effect_lua")) do
				if mod:GetAbility():GetName() == "imba_drow_ranger_frost_arrows_723" then
					self.frost_arrow_modifier = mod
					break
				end
			end
		end
		
		if not keys.no_attack_cooldown then
			if self.frost_arrow_modifier and self.frost_arrow_modifier.cast and self.frost_arrow_modifier:GetAbility() and self.frost_arrow_modifier:GetAbility():IsFullyCastable() then
				self.projectile_name = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"
			else
				self.projectile_name = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
			end
			
			ProjectileManager:CreateTrackingProjectile({
				Target 				= keys.target,
				-- Source 				= self:GetCaster(),
				Ability 			= self:GetAbility(),
				EffectName 			= self.projectile_name,
				iMoveSpeed			= self:GetParent():GetProjectileSpeed(),
				vSourceLoc 			= self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_attack1")),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= true,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10.0,
				bProvidesVision 	= false,
				
				iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			})
		end
	end
end

function modifier_imba_drow_ranger_marksmanship_723:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		if self.procs[keys.record] then
			keys.target:EmitSound("Hero_DrowRanger.Marksmanship.Target")
		
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_drow_ranger_marksmanship_723_proc_armor", {})
			
			-- IMBAfication: Perfect Shot
			if keys.target:GetHealthPercent() <= self:GetAbility():GetSpecialValueFor("instakill_threshold") and not keys.target:IsRoshan() and not keys.target:HasModifier("modifier_oracle_false_promise_timer") and not keys.target:HasModifier("modifier_imba_oracle_false_promise_timer") then
				keys.target:Kill(self:GetAbility(), self:GetParent())
			end
		end
		
		if self:GetParent():HasScepter() and not self:GetParent():PassivesDisabled() and self.start_particle and not keys.no_attack_cooldown then
			local splinter_counter = 0

			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), keys.target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("scepter_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)) do
				if enemy ~= keys.target then 
					if splinter_counter < self:GetAbility():GetSpecialValueFor("split_count_scepter") then
						if self.frost_arrow_modifier and self.frost_arrow_modifier:GetAbility() and (self.frost_arrow_modifier.cast or self.frost_arrow_modifier:GetAbility():GetAutoCastState()) and self.frost_arrow_modifier:GetAbility():IsFullyCastable() then 
							self.frost_arrow_modifier:GetAbility():UseResources(true, false, false, false)
							
							self.bFrost = true
							self.splinter_projectile_name = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
						else
							self.bFrost = false
							self.splinter_projectile_name = self:GetParent():GetRangedProjectileName()
						end
						
						TrackingProjectiles:Projectile({
							hTarget				= enemy,
							hCaster				= keys.target,
							hAbility			= self:GetAbility(),
							iMoveSpeed			= self:GetParent():GetProjectileSpeed(),
							EffectName			= self.splinter_projectile_name,
							SoundName			= "",
							flRadius			= 1,
							bDodgeable			= true,
							bDestroyOnDodge 	= true,
							iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
							bFrost				= self.bFrost,
							OnProjectileHitUnit = function(params, projectileID)
								self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_marksmanship_scepter_dmg_reduction", {})
								self:GetParent():PerformAttack(enemy, false, true, true, true, false, false, false)
								self:GetParent():RemoveModifierByName("modifier_imba_marksmanship_scepter_dmg_reduction")

								if params.bFrost then 
									self.frost_arrow_modifier:GetAbility():OnOrbImpact({target = enemy})
								end
							end
						})
						
						splinter_counter = splinter_counter + 1
					else
						break
					end
				end
			end
		end
	end
end

function modifier_imba_drow_ranger_marksmanship_723:OnAttackRecordDestroy(keys)
	if keys.attacker == self:GetParent() and self.procs[keys.record] then
		self.procs[keys.record] = nil
		
		keys.target:RemoveModifierByName("modifier_imba_drow_ranger_marksmanship_723_proc_armor")
	end
end

function modifier_imba_drow_ranger_marksmanship_723:GetModifierAttackRangeBonus()
	if not self:GetParent():PassivesDisabled() and self:GetStackCount() == 0 then
		return self:GetAbility():GetSpecialValueFor("range_bonus")
	end
end

function modifier_imba_drow_ranger_marksmanship_723:IsHidden()					return true end

function modifier_imba_drow_ranger_marksmanship_723:IsAura()					return not self:GetParent():IsIllusion() end
function modifier_imba_drow_ranger_marksmanship_723:IsAuraActiveOnDeath() 		return false end

function modifier_imba_drow_ranger_marksmanship_723:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("agility_range") end
function modifier_imba_drow_ranger_marksmanship_723:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_drow_ranger_marksmanship_723:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_drow_ranger_marksmanship_723:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO end
function modifier_imba_drow_ranger_marksmanship_723:GetModifierAura()			return "modifier_imba_drow_ranger_marksmanship_723_aura_bonus" end

function modifier_imba_drow_ranger_marksmanship_723:GetAuraEntityReject(hTarget)	return not self:GetAbility():IsTrained() or not hTarget:IsRangedAttacker() or self:GetParent():PassivesDisabled() or not self.start_particle end

-----------------------------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_MARKSMANSHIP_723_AURA_BONUS --
-----------------------------------------------------------

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:OnCreated()
	self.agility_multiplier	= self:GetAbility():GetSpecialValueFor("agility_multiplier") * 0.01
	
	self.agility_to_add = self:GetCaster():GetAgility() * self.agility_multiplier
	
	self:StartIntervalThink(0.5)
end

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:OnRefresh()
	if self:GetAbility() then
		self.agility_multiplier	= self:GetAbility():GetSpecialValueFor("agility_multiplier") * 0.01
	end
end

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:OnIntervalThink()
	self.agility_to_add = 0
	
	if self:GetCaster() and not self:GetCaster():IsNull() then
		self.agility_to_add = self:GetCaster():GetAgility() * self.agility_multiplier
	end
end

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:CheckState()
	return {[MODIFIER_STATE_CANNOT_MISS] = true}
end

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS}
end

function modifier_imba_drow_ranger_marksmanship_723_aura_bonus:GetModifierBonusStats_Agility()
	return self.agility_to_add
end

------------------------------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_MARKSMANSHIP_723_PROC_DAMAGE --
------------------------------------------------------------

function modifier_imba_drow_ranger_marksmanship_723_proc_damage:IsHidden()		return true end
function modifier_imba_drow_ranger_marksmanship_723_proc_damage:IsPurgable()	return false end

function modifier_imba_drow_ranger_marksmanship_723_proc_damage:OnCreated()
	if not IsServer() then return end

	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_drow_ranger_marksmanship_723_proc_damage:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT}
end

function modifier_imba_drow_ranger_marksmanship_723_proc_damage:GetModifierPreAttack_BonusDamagePostCrit()
	return self.bonus_damage
end

-----------------------------------------------------------
-- MODIFIER_IMBA_DROW_RANGER_MARKSMANSHIP_723_PROC_ARMOR --
-----------------------------------------------------------

function modifier_imba_drow_ranger_marksmanship_723_proc_armor:IsHidden()	return true end
function modifier_imba_drow_ranger_marksmanship_723_proc_armor:IsPurgable()	return false end

function modifier_imba_drow_ranger_marksmanship_723_proc_armor:OnCreated()
	self.base_armor = self:GetParent():GetPhysicalArmorBaseValue() * (-1)
end

function modifier_imba_drow_ranger_marksmanship_723_proc_armor:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_imba_drow_ranger_marksmanship_723_proc_armor:GetModifierPhysicalArmorBonus()
	return self.base_armor
end

------------------------
-- TRUESHOT AURA 7.20 --
------------------------

LinkLuaModifier("modifier_imba_drow_ranger_trueshot_720", "components/abilities/heroes/hero_drow_ranger.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_drow_ranger_trueshot_720_global", "components/abilities/heroes/hero_drow_ranger.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_drow_ranger_trueshot_720_aura", "components/abilities/heroes/hero_drow_ranger.lua", LUA_MODIFIER_MOTION_NONE)

imba_drow_ranger_trueshot_720 					= class({})
modifier_imba_drow_ranger_trueshot_720			= class({})
-- modifier_imba_drow_ranger_trueshot_720_global 	= class({})
modifier_imba_drow_ranger_trueshot_720_aura 	= class({})

function imba_drow_ranger_trueshot_720:GetIntrinsicModifierName()
	return "modifier_imba_drow_ranger_trueshot_720"
end

function imba_drow_ranger_trueshot_720:OnSpellStart()
	if not IsServer() then return end

	local trueshot_modifier = self:GetCaster():FindModifierByName("modifier_imba_drow_ranger_trueshot_720")
	
	if trueshot_modifier then
		trueshot_modifier.activation_counter = self:GetDuration() + 0.1
		trueshot_modifier:StartIntervalThink(-1)
		trueshot_modifier:OnIntervalThink()
		trueshot_modifier:StartIntervalThink(0.1)
	end
	
	--#6 talent: Trueshot Burst
	if self:GetCaster():HasTalent("special_bonus_imba_drow_ranger_6")	then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_trueshot_talent_buff", {duration = self:GetDuration()})
	end
end

---------------------------------
-- TRUESHOT AURA MODIFIER 7.20 --
---------------------------------

function modifier_imba_drow_ranger_trueshot_720:IsHidden()				return true end

function modifier_imba_drow_ranger_trueshot_720:IsAura() 				return true end
function modifier_imba_drow_ranger_trueshot_720:IsAuraActiveOnDeath() 	return false end

function modifier_imba_drow_ranger_trueshot_720:GetAuraRadius()			return 25000 end
function modifier_imba_drow_ranger_trueshot_720:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_drow_ranger_trueshot_720:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_drow_ranger_trueshot_720:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_drow_ranger_trueshot_720:GetModifierAura()		return "modifier_imba_drow_ranger_trueshot_720_aura" end

function modifier_imba_drow_ranger_trueshot_720:GetAuraEntityReject(hEntity)
	if not IsServer() then return end

	-- If Drow Ranger (or the caster) is not broken and the unit is either a hero or is a ranged attacker and the ability is active, then they get the aura effects
	if self:GetAbility() and self:GetAbility():IsTrained() and not self:GetCaster():PassivesDisabled() and (hEntity:IsHero() or (hEntity:IsRangedAttacker() and self.activation_counter ~= nil and self.activation_counter > 0)) then
		return false
	else
		return true
	end
end

function modifier_imba_drow_ranger_trueshot_720:OnCreated()
	if not IsServer() then return end
	
	self.activation_counter = 0

	self:StartIntervalThink(0.1)
end

function modifier_imba_drow_ranger_trueshot_720:OnIntervalThink()
	self:SetStackCount(self:GetCaster():GetAgility() * (self:GetAbility():GetTalentSpecialValueFor("trueshot_ranged_attack_speed") / 100))
	
	if self.activation_counter > 0 then
		self.activation_counter = math.max(self.activation_counter - 0.1, 0)
	end
end

--------------------------------------
-- TRUESHOT AURA MODIFIER BUFF 7.20 --
--------------------------------------

function modifier_imba_drow_ranger_trueshot_720_aura:GetEffectName()
	return "particles/units/heroes/hero_drow/drow_aura_buff.vpcf"
end

function modifier_imba_drow_ranger_trueshot_720_aura:OnCreated()
	self.melee_fencing_efficiency	= self:GetAbility():GetSpecialValueFor("melee_fencing_efficiency") / 100
end

function modifier_imba_drow_ranger_trueshot_720_aura:DeclareFunctions()
  	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_imba_drow_ranger_trueshot_720_aura:GetModifierAttackSpeedBonus_Constant()
	if self == nil or self:GetCaster() == nil then return end
	
	local trueshot_stacks			= self:GetCaster():GetModifierStackCount("modifier_imba_drow_ranger_trueshot_720", self:GetCaster())

	if self:GetParent():IsRangedAttacker() then
		return trueshot_stacks
	else
		return trueshot_stacks * self.melee_fencing_efficiency
	end
end

-------------------------------------------

-- Client-side helper functions --
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_5", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_6", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_9", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_drow_ranger_5		= modifier_special_bonus_imba_drow_ranger_5 or class({})
modifier_special_bonus_imba_drow_ranger_6		= modifier_special_bonus_imba_drow_ranger_6 or class({})
modifier_special_bonus_imba_drow_ranger_9		= modifier_special_bonus_imba_drow_ranger_9 or class({})

function modifier_special_bonus_imba_drow_ranger_5:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_5:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_drow_ranger_6:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_6:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_6:RemoveOnDeath() 	return false end

function imba_drow_ranger_marksmanship:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_drow_ranger_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_drow_ranger_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_drow_ranger_5"), "modifier_special_bonus_imba_drow_ranger_5", {})
	end
end

function imba_drow_ranger_trueshot_720:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_drow_ranger_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_drow_ranger_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_drow_ranger_6"), "modifier_special_bonus_imba_drow_ranger_6", {})
	end
end


---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_7", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_frost_arrows_damage", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_10", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_drow_ranger_3", "components/abilities/heroes/hero_drow_ranger", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_drow_ranger_7					= modifier_special_bonus_imba_drow_ranger_7 or class({})
modifier_special_bonus_imba_drow_ranger_frost_arrows_damage	= modifier_special_bonus_imba_drow_ranger_frost_arrows_damage or class({})
modifier_special_bonus_imba_drow_ranger_10					= modifier_special_bonus_imba_drow_ranger_10 or class({})
modifier_special_bonus_imba_drow_ranger_3					= modifier_special_bonus_imba_drow_ranger_3 or class({})

function modifier_special_bonus_imba_drow_ranger_7:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_7:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_7:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_drow_ranger_frost_arrows_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_frost_arrows_damage:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_frost_arrows_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_drow_ranger_10:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_10:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_10:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_drow_ranger_3:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_3:IsPurgable()		return false end
function modifier_special_bonus_imba_drow_ranger_3:RemoveOnDeath() 	return false end

-----------------------
-- TALENT 9 MODIFIER --
-----------------------
-- +x Gust Distance/Knockback

function modifier_special_bonus_imba_drow_ranger_9:IsHidden() 		return true end
function modifier_special_bonus_imba_drow_ranger_9:IsPurgable() 		return false end
function modifier_special_bonus_imba_drow_ranger_9:RemoveOnDeath() 	return false end

function imba_drow_ranger_gust:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_drow_ranger_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_drow_ranger_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_drow_ranger_9"), "modifier_special_bonus_imba_drow_ranger_9", {})
	end
end
