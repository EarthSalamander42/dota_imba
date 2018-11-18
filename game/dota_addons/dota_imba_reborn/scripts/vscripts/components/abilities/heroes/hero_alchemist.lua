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
--     Hewdraw

local LinkedModifiers = {}

-------------------------------------------
--              ACID SPRAY
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_acid_spray_debuff_dot"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_acid_spray_thinker"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_acid_spray_handler"] = LUA_MODIFIER_MOTION_NONE,
})

imba_alchemist_acid_spray = imba_alchemist_acid_spray or class ({})

function imba_alchemist_acid_spray:GetAbilityTextureName()
	return "alchemist_acid_spray"
end

function imba_alchemist_acid_spray:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function imba_alchemist_acid_spray:IsHiddenWhenStolen()
--	local caster = self:GetCaster()
--	if caster:HasAbility("imba_alchemist_chemical_rage") then
--		return true
--	end
	return false
end

function imba_alchemist_acid_spray:GetAOERadius()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")

	return radius
end

function imba_alchemist_acid_spray:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local point = self:GetCursorPosition()
	local team_id = caster:GetTeamNumber()
	local cast_responses = {"alchemist_alch_ability_acid_01", "alchemist_alch_ability_acid_02", "alchemist_alch_ability_acid_03", "alchemist_alch_ability_acid_04", "alchemist_alch_ability_acid_05", "alchemist_alch_ability_acid_06", "alchemist_alch_ability_acid_07", "alchemist_alch_ability_acid_08", "alchemist_alch_ability_acid_09", "alchemist_alch_ability_acid_10", "alchemist_alch_ability_acid_11", "alchemist_alch_ability_acid_12"}
	EmitSoundOn(cast_responses[math.random(1, #cast_responses)], caster)

	local duration = ability:GetSpecialValueFor("duration")
	local thinker = CreateModifierThinker(caster, self, "modifier_imba_acid_spray_thinker", {duration = duration}, point, team_id, false)
	return true
end

modifier_imba_acid_spray_thinker = modifier_imba_acid_spray_thinker or class({})

function modifier_imba_acid_spray_thinker:IsAura()
	return true
end

function modifier_imba_acid_spray_thinker:OnCreated(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.thinker = self:GetParent()
		self.ability = self:GetAbility()
		self.modifier_spray = "modifier_imba_acid_spray_handler"
		self.thinker_loc = self.thinker:GetAbsOrigin()

		self.thinker:EmitSound("Hero_Alchemist.AcidSpray")

		self.radius = self.ability:GetSpecialValueFor("radius")

		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_POINT_FOLLOW, self.thinker)
		ParticleManager:SetParticleControl(self.particle, 0, (Vector(0, 0, 0)))
		ParticleManager:SetParticleControl(self.particle, 1, (Vector(self.radius, 1, 1)))
		ParticleManager:SetParticleControl(self.particle, 15, (Vector(25, 150, 25)))
		ParticleManager:SetParticleControl(self.particle, 16, (Vector(0, 0, 0)))

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_acid_spray_thinker:OnIntervalThink()
	local units = FindUnitsInRadius(self.thinker:GetTeamNumber(),
		self.thinker_loc,
		nil,
		self.radius,
		self.ability:GetAbilityTargetTeam(),
		self.ability:GetAbilityTargetType(),
		self.ability:GetAbilityTargetFlags(),
		FIND_ANY_ORDER,
		false)

	for _,unit in pairs (units) do
		if unit:HasModifier(self.modifier_spray) then
			local modifier_spray_handler = unit:FindModifierByName(self.modifier_spray)
			if modifier_spray_handler and not modifier_spray_handler.center then
				modifier_spray_handler.center = self.thinker_loc
			end
		end
	end
end

function modifier_imba_acid_spray_thinker:GetAuraRadius()
	return self.radius
end

function modifier_imba_acid_spray_thinker:GetAuraSearchTeam()
	return self.ability:GetAbilityTargetTeam()
end

function modifier_imba_acid_spray_thinker:GetAuraSearchType()
	return self.ability:GetAbilityTargetType()
end

function modifier_imba_acid_spray_thinker:GetAuraSearchFlags()
	return self.ability:GetAbilityTargetFlags()
end

function modifier_imba_acid_spray_thinker:GetModifierAura()
	return "modifier_imba_acid_spray_handler"
end


function modifier_imba_acid_spray_thinker:OnDestroy(keys)
	if IsServer() then
		local thinker = self:GetParent()
		thinker:StopSound("Hero_Alchemist.AcidSpray")
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

modifier_imba_acid_spray_handler = modifier_imba_acid_spray_handler or class({})

function modifier_imba_acid_spray_handler:IsHidden()
	return true
end

function modifier_imba_acid_spray_handler:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local unit = self:GetParent()

		self.modifier = unit:AddNewModifier(caster, ability, "modifier_imba_acid_spray_debuff_dot", {})
		self.modifier.damage = ability:GetSpecialValueFor("damage")
		self.modifier.stack_damage = ability:GetSpecialValueFor("stack_damage")

		-- #5 Talent: Greed stacks increase acid spray damage
		if caster:HasTalent("special_bonus_imba_alchemist_5") then
			local greed_stacks	=	caster:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount()
			local bonus_damage	=	(caster:FindTalentValue("special_bonus_imba_alchemist_5") / 100) * greed_stacks

			self.modifier.damage = self.modifier.damage + bonus_damage
		end
		local tick_rate = ability:GetSpecialValueFor("tick_rate")
		self:StartIntervalThink(tick_rate)
	end
end

function modifier_imba_acid_spray_handler:OnIntervalThink()
	if IsServer() then
		if self.modifier:IsNull() then
			return --volvo pls
		end
		self.modifier:OnIntervalThink(true, false)
	end
end

function modifier_imba_acid_spray_handler:DeclareFunctions()
	local decFuncs={
		MODIFIER_EVENT_ON_DEATH
	}
	return decFuncs
end

-- #4 Talent : Enemies that die under the effect of Acid Spray spawn gold bags.
function modifier_imba_acid_spray_handler:OnDeath(params)
	if IsServer() then
		-- Ability properties
		caster 	= 	self:GetCaster()
		parent	=	self:GetParent()

		if (params.unit == parent) then

			-- Illusions are ignored.
			if params.unit:IsIllusion() then
				return nil
			end

			if caster:HasTalent("special_bonus_imba_alchemist_4") and caster:HasModifier("modifier_imba_goblins_greed_passive") then
				-- Ability paramaters
				local greed_stacks		=	caster:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount()
				local stacks_to_gold 	=	caster:FindTalentValue("special_bonus_imba_alchemist_4", "stacks_to_gold_percentage" ) * 0.01
				local gold				=	greed_stacks * stacks_to_gold
				local drop_chance_hero	=	caster:FindTalentValue("special_bonus_imba_alchemist_4", "drop_chance_percentage_hero")
				local drop_chance_creep =   caster:FindTalentValue("special_bonus_imba_alchemist_4", "drop_chance_percentage_creep")

				local drop_chance
				if params.unit:IsHero() then
					drop_chance = drop_chance_hero
				else
					drop_chance = drop_chance_creep
				end

				-- % Chance to drop gold bag
				if RollPercentage(drop_chance) then
					-- Drop gold bag
					local newItem = CreateItem( "item_bag_of_gold", nil, nil )
					newItem:SetPurchaseTime( 0 )
					newItem:SetCurrentCharges( gold )

					local drop = CreateItemOnPositionSync( parent:GetAbsOrigin(), newItem )
					local dropTarget = parent:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) )
					newItem:LaunchLoot( true, 300, 0.75, dropTarget )
					EmitSoundOn( "Dungeon.TreasureItemDrop", parent )
				end
			end
		end
	end
end

modifier_imba_acid_spray_debuff_dot = modifier_imba_acid_spray_debuff_dot or class({})

function modifier_imba_acid_spray_debuff_dot:IsDebuff()
	return true
end

function modifier_imba_acid_spray_debuff_dot:IsPurgable()
	return true
end

function modifier_imba_acid_spray_debuff_dot:OnCreated()
	self.caster = self:GetCaster()
	local ability = self:GetAbility()

	self.armor_reduction = ability:GetSpecialValueFor("armor_reduction")
	self.stack_armor_reduction = ability:GetSpecialValueFor("stack_armor_reduction")
	
	if IsServer() then
		self:SetStackCount(1)
		local tick_rate = ability:GetSpecialValueFor("tick_rate")
		self:StartIntervalThink(tick_rate)
	end
end

function modifier_imba_acid_spray_debuff_dot:OnIntervalThink(aura_tick, consume_stacks)
	if IsServer() then
		if aura_tick then
			self:IncrementStackCount()
		end
		self.caster = self.caster or self:GetCaster()
		self.ability = self.ability or self:GetAbility()

		if self.caster:IsIllusion() then --prevent ability from becoming nil if the illusion is dead for to long
			if not self.caster:IsAlive() then
				self.caster = self.caster:GetPlayerOwner():GetAssignedHero()
				self.ability = self.caster:FindAbilityByName("imba_alchemist_acid_spray")
		end
		end

		local unit = self:GetParent()

		if unit:IsCourier() then
			self:Destroy()
			return nil
		end

		if aura_tick
			or consume_stacks
			or (not unit:HasModifier("modifier_imba_acid_spray_handler")
			and not unit:HasModifier("modifier_imba_chemical_rage_aura")) then
			local damage = self.damage + self.stack_damage * self:GetStackCount()
			local damage_table = {
				victim = unit,
				attacker = self.caster,
				damage = damage,
				damage_type = self.ability:GetAbilityDamageType(),
				ability = self.ability,
			}
			ApplyDamage(damage_table)
			EmitSoundOn("Hero_Alchemist.AcidSpray.Damage", unit)

			if not aura_tick then
				self:DecrementStackCount()
			end
			if self:GetStackCount() == 0 then
				if consume_stacks then
					return
				end
				unit:RemoveModifierByName("modifier_imba_acid_spray_debuff_dot")
				return
			end
			if consume_stacks then
				self:OnIntervalThink(false, consume_stacks)
			end
		end
	end
end

function modifier_imba_acid_spray_debuff_dot:OnStackCountChanged(old_stack_count)
	self.caster = self.caster or self:GetCaster()
	self.ability = self.ability or self:GetAbility()
	if self.caster:IsIllusion() then --prevent ability from becoming nil if the illusion is dead for to long
		if not self.caster:IsAlive() then
			self.caster = self.caster:GetPlayerOwner():GetAssignedHero()
			self.ability = self.caster:FindAbilityByName("imba_alchemist_acid_spray")
	end
	end
	local stack_count = self:GetStackCount()
	local max_stacks = self.ability:GetSpecialValueFor("max_stacks")
	if self.caster:HasModifier("modifier_imba_chemical_rage_buff_haste") then
		max_stacks = max_stacks + max_stacks
	end
	if stack_count > max_stacks then
		self:SetStackCount(max_stacks)
	end
end

function modifier_imba_acid_spray_debuff_dot:GetTexture()
	return "alchemist_acid_spray" --prevent texture from dissapearing if the illusion is dead for to long
end

function modifier_imba_acid_spray_debuff_dot:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_acid_spray_debuff_dot:GetModifierPhysicalArmorBonus()
	local armor_reduction = self.armor_reduction + self.stack_armor_reduction * self:GetStackCount()
	return armor_reduction * (-1)
end

function modifier_imba_acid_spray_debuff_dot:GetModifierMoveSpeedBonus_Percentage()
	-- Talent #1 : Sticky acid now slows targets affected.
	return self:GetCaster():FindTalentValue("special_bonus_imba_alchemist_1")
end
-------------------------------------------
--          UNSTABLE CONCOCTION
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_unstable_concoction_stunned"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_unstable_concoction_handler"] = LUA_MODIFIER_MOTION_NONE,
})
imba_alchemist_unstable_concoction = imba_alchemist_unstable_concoction or class({})

function imba_alchemist_unstable_concoction:GetAbilityTextureName()
	return "alchemist_unstable_concoction"
end

function imba_alchemist_unstable_concoction:GetCastRange(location, target)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return self.BaseClass.GetCastRange(self, location, target)
	end
	return 0
end

function imba_alchemist_unstable_concoction:IsHiddenWhenStolen()
	return false
end

function imba_alchemist_unstable_concoction:OnUnStolen()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_imba_unstable_concoction_handler")
end

function imba_alchemist_unstable_concoction:OnSpellStart()
	local caster = self:GetCaster()
	local cast_response = {"alchemist_alch_ability_concoc_01", "alchemist_alch_ability_concoc_02", "alchemist_alch_ability_concoc_03", "alchemist_alch_ability_concoc_04", "alchemist_alch_ability_concoc_05", "alchemist_alch_ability_concoc_06", "alchemist_alch_ability_concoc_07", "alchemist_alch_ability_concoc_08", "alchemist_alch_ability_concoc_10"}
	local last_second_throw_response = {"alchemist_alch_ability_concoc_16", "alchemist_alch_ability_concoc_17"}
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		local target = self:GetCursorTarget()
		-- Stops the charging sound
		caster:StopSound("Hero_Alchemist.UnstableConcoction.Fuse")
		--Emit the throwing sound
		caster:EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
		-- Last second throw responses
		local modifier_unstable_handler = caster:FindModifierByName("modifier_imba_unstable_concoction_handler")
		if modifier_unstable_handler then
			local remaining_time = modifier_unstable_handler:GetRemainingTime()
			if remaining_time < 1 then
				EmitSoundOn(last_second_throw_response[math.random(1,#last_second_throw_response)], caster)
			end
		end

		caster:RemoveModifierByName("modifier_imba_unstable_concoction_handler")

		caster:StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)
		caster:FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)

		-- Set how much time the spell charged
		self.time_charged = GameRules:GetGameTime() - self.brew_start

		-- Remove the brewing modifier
		caster:RemoveModifierByName("modifier_imba_unstable_concoction_handler")

		Timers:CreateTimer(0.3, function()
			local projectile_speed = self:GetSpecialValueFor("movement_speed")
			local info =
			{
				Target = target,
				Source = caster,
				Ability = self,
				bDodgeable = false,
				EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
				iMoveSpeed = projectile_speed,
			}

			ProjectileManager:CreateTrackingProjectile(info)
		end)
		return
	end

	EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
	caster:StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self.brew_start = GameRules:GetGameTime()
	self.brew_time = self:GetSpecialValueFor("brew_time")
	local extra_brew_time = self:GetSpecialValueFor("extra_brew_time")
	local duration = self.brew_time + extra_brew_time
	self.stun = self:GetSpecialValueFor("stun")
	self.damage = self:GetSpecialValueFor("damage")
	self.radius_increase = self:GetSpecialValueFor("radius_increase") / self.brew_time
	local greed_modifier = caster:FindModifierByName("modifier_imba_goblins_greed_passive")
	if greed_modifier then
		local greed_stacks = greed_modifier:GetStackCount()
		local greed_multiplier = self:GetSpecialValueFor("time_per_stack")
		duration = duration + (greed_stacks * greed_multiplier)
	end

	-- #6 Talent : When in Chemical Rage, Alchemist brews Unstable Concoction faster.
	local speed_multiplier
	if caster:HasTalent("special_bonus_imba_alchemist_6")  and caster:FindModifierByName("modifier_imba_chemical_rage_buff_haste")  then
		speed_multiplier	=	caster:FindTalentValue("special_bonus_imba_alchemist_6")
	else speed_multiplier	=	1 		end

	duration = duration / speed_multiplier

	caster:AddNewModifier(caster, self, "modifier_imba_unstable_concoction_handler", {duration = duration,})
	CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { brew_start = GameRules:GetGameTime(), radius_increase = self.radius_increase,})
	self.radius = self:GetSpecialValueFor("radius")

	-- Play the sound, which will be stopped when the sub ability fires
	caster:EmitSound("Hero_Alchemist.UnstableConcoction.Fuse")
end

function imba_alchemist_unstable_concoction:OnProjectileHit(target, location)
	if IsServer() then

		local caster = self:GetCaster()
		local particle_acid_blast = "particles/hero/alchemist/acid_spray_blast.vpcf"
		local brew_duration = (GameRules:GetGameTime() - self.brew_start)
		caster:FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
		--Emit blow up sound
		target:EmitSound("Hero_Alchemist.UnstableConcoction.Stun")

		-- If the target is an enemy:
		if target:GetTeam() ~= caster:GetTeam() or target == caster then
			local damage_type = self:GetAbilityDamageType()
			local stun = self.stun
			local damage = self.damage
			local radius = self:GetAOERadius()
			local kill_response = {"alchemist_alch_ability_concoc_09", "alchemist_alch_ability_concoc_15"}

			if target then
				location = target:GetAbsOrigin()
			end
			local units = FindUnitsInRadius(caster:GetTeam(), location, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags() - DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)

			local brew_percentage = brew_duration / self.brew_time

			-- #6 Talent : When in Chemical Rage, Alchemist brews Unstable Concoction faster.
			local speed_multiplier
			if caster:HasTalent("special_bonus_imba_alchemist_6") and caster:FindModifierByName("modifier_imba_chemical_rage_buff_haste")  then
				speed_multiplier	=	caster:FindTalentValue("special_bonus_imba_alchemist_6")
			else speed_multiplier	=	1 		end

			brew_percentage = brew_percentage * speed_multiplier

			local damage = damage * brew_percentage
			local stun_duration = stun * brew_percentage
			if stun_duration > stun then
				stun_duration = stun
			end

			if target then
				if target == caster then
					if not target:IsMagicImmune() then
						if not target:IsInvulnerable() then
							if not target:IsOutOfGame() then
								ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = damage_type,})
								target:AddNewModifier(caster, self, "modifier_imba_unstable_concoction_stunned", {duration = stun_duration,})
							end
						end
					end
				else
					if target:TriggerSpellAbsorb(self) then
						return
					end
				end
			end

			-- Apply the AoE stun and damage with the variable duration
			local enemy_killed = false
			for _,unit in pairs(units) do
				if unit:GetTeam() ~= caster:GetTeam() then
					ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = damage_type,})
					unit:AddNewModifier(caster, self, "modifier_imba_unstable_concoction_stunned", {duration = stun_duration,})

					-- See if enemy survive the impact to decide if to roll for a kill response
					Timers:CreateTimer(FrameTime(), function()
						if not unit:IsAlive() and RollPercentage(50) then
							EmitSoundOn(kill_response[math.random(1, #kill_response)], caster)
						end
					end)

					if unit:HasModifier("modifier_imba_acid_spray_handler") then
						local acid_spray_modifier = unit:FindModifierByName("modifier_imba_acid_spray_handler")
						local acid_spray_ability = acid_spray_modifier:GetAbility()
						local acid_spray_radius = acid_spray_ability:GetAOERadius()
						if acid_spray_modifier.center then
							location = acid_spray_modifier.center
						end

						particle_acid_blast_fx = ParticleManager:CreateParticle(particle_acid_blast, PATTACH_WORLDORIGIN, caster)
						ParticleManager:SetParticleControl(particle_acid_blast_fx, 0, location)
						ParticleManager:SetParticleControl(particle_acid_blast_fx, 1, location)
						ParticleManager:SetParticleControl(particle_acid_blast_fx, 2, Vector(acid_spray_radius, 0, 0))
						ParticleManager:ReleaseParticleIndex(particle_acid_blast_fx)

						local acid_spray_units = FindUnitsInRadius(caster:GetTeam(), location, nil, acid_spray_radius * 2, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
						local damage_multiplier = self:GetSpecialValueFor("acid_spray_damage") * 0.01

						for _,acid_spray_unit in pairs(acid_spray_units) do
							local actual_damage = ApplyDamage({victim = acid_spray_unit, attacker = caster, damage = damage * damage_multiplier, damage_type = damage_type,})
							local modifier = acid_spray_unit:FindModifierByName("modifier_imba_acid_spray_debuff_dot")
							if modifier then
								modifier:OnIntervalThink(false, true)
							end
						end
						local modifier = unit:FindModifierByName("modifier_imba_acid_spray_debuff_dot")
						if modifier then
							modifier:OnIntervalThink(false, true)
						end
					end
				end
			end
			-- Talent #2 : Unstable Concoction can now be cast on allies to grant them Chemical Rage.
		else
			local total_duration = brew_duration * caster:FindTalentValue("special_bonus_imba_alchemist_2")
			local chemical_rage = caster:FindAbilityByName("imba_alchemist_chemical_rage")

			target:AddNewModifier(caster, chemical_rage, "modifier_imba_chemical_rage_buff_haste", { duration = total_duration })
		end
	end
end

function imba_alchemist_unstable_concoction:GetAbilityTextureName()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return "alchemist_unstable_concoction_throw"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end

function imba_alchemist_unstable_concoction:GetCooldown(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		if IsServer() then
			return self.BaseClass.GetCooldown(self, level) - (GameRules:GetGameTime() - self.brew_start)
		end
		return 0
	end
	if IsServer() then
		return 0
	end
	return self.BaseClass.GetCooldown(self, level)
end

function imba_alchemist_unstable_concoction:GetManaCost(level)
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return 0
	end
	return self.BaseClass.GetManaCost(self, level)
end


function imba_alchemist_unstable_concoction:GetCastTime()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return self.BaseClass.GetCastTime(self)
	end
	return 0
end

function imba_alchemist_unstable_concoction:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


function imba_alchemist_unstable_concoction:CastFilterResultTarget( target )
	-- Talent #2 : Unstable Concoction can now be cast on allies.
	if IsServer() then
		local caster = self:GetCaster()
		local hasTalent = caster:HasTalent("special_bonus_imba_alchemist_2")
		if target ~= nil then
			if target:GetTeam() == caster:GetTeam() and not hasTalent then
				return UF_FAIL_FRIENDLY
			end

			if caster == target then
				return UF_FAIL_CUSTOM
			end
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber() )
		return nResult
	end
end

function imba_alchemist_unstable_concoction:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_cast_on_self"
end

function imba_alchemist_unstable_concoction:ProcsMagicStick()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_unstable_concoction_handler") then
		return false
	end
	return true
end

function imba_alchemist_unstable_concoction:GetAOERadius()
	local caster = self:GetCaster()
	local brew_start = 0
	local radius_increase = 0
	if IsServer() then
		brew_start = self.brew_start
		radius_increase = self.radius_increase
	else
		local net_table = CustomNetTables:GetTableValue("player_table", tostring(caster:GetPlayerOwnerID())) or {}
		brew_start = net_table.brew_start or 0
		radius_increase = net_table.radius_increase or 0
	end
	local radius = self:GetSpecialValueFor("radius") + (GameRules:GetGameTime() - brew_start) * radius_increase
	return radius
end

modifier_imba_unstable_concoction_handler = modifier_imba_unstable_concoction_handler or class({})

function modifier_imba_unstable_concoction_handler:IsPurgable()
	return false
end


function modifier_imba_unstable_concoction_handler:IsHidden()
	return true
end

function modifier_imba_unstable_concoction_handler:OnDestroy()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		--Blow up the concoction on death
		if not caster:IsAlive() then
			caster:EmitSound("Hero_Alchemist.UnstableConcoction.Stun")
			caster:StopSound("Hero_Alchemist.UnstableConcoction.Fuse")
			ability:OnProjectileHit(caster, caster:GetAbsOrigin())
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
		end
	end
end

function modifier_imba_unstable_concoction_handler:OnCreated()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_unstable_concoction_handler:OnIntervalThink()
	if IsServer() then
		local caster = self:GetParent()
		local ability = self:GetAbility()
		local last_second_response = {"alchemist_alch_ability_concoc_11", "alchemist_alch_ability_concoc_12", "alchemist_alch_ability_concoc_13", "alchemist_alch_ability_concoc_14", "alchemist_alch_ability_concoc_18", "alchemist_alch_ability_concoc_19", "alchemist_alch_ability_concoc_20"}
		local self_blow_response = {"alchemist_alch_ability_concoc_21", "alchemist_alch_ability_concoc_22", "alchemist_alch_ability_concoc_23", "alchemist_alch_ability_concoc_24", "alchemist_alch_ability_concoc_25"}
		local brew_time_passed	=	self:GetDuration()

		-- Show the particle to all allies
		local allHeroes = HeroList:GetAllHeroes()
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
		local number = math.abs(GameRules:GetGameTime() - ability.brew_start - brew_time_passed)

		if caster:HasTalent("special_bonus_imba_alchemist_6") and caster:HasModifier("modifier_imba_chemical_rage_buff_haste") then
			number = number * caster:FindTalentValue("special_bonus_imba_alchemist_6")
		end

		-- Get the integer. Add a bit because the think interval isn't a perfect 0.5 timer
		local integer = math.floor(number)
		if integer <= 0 and not self.last_second_responded then
			self.last_second_responded = true
			EmitSoundOn(last_second_response[math.random(1,#last_second_response)], caster)
		end

		-- Get the amount of digits to show
		local digits = math.floor(math.log10(number)) + 2

		-- Round the decimal number to .0 or .5
		local decimal = number % 1

		if decimal < 0.04 then
			decimal = 1 -- ".0"
		elseif decimal > 0.5
			and decimal < 0.54 then
			decimal = 8 -- ".5"
		else
			return
		end

		-- Don't display the 0.0 message
		if not (integer == 0 and decimal <= 1) then
			for k, v in pairs(allHeroes) do
				if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
					local particle = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_OVERHEAD_FOLLOW, caster, PlayerResource:GetPlayer(v:GetPlayerID()))
					ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(particle, 1, Vector(0, integer, decimal))
					ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))

					if caster:HasTalent("special_bonus_imba_alchemist_6") and caster:HasModifier("modifier_imba_chemical_rage_buff_haste") then
						Timers:CreateTimer(0.5 / caster:FindTalentValue("special_bonus_imba_alchemist_6"), function()
							ParticleManager:DestroyParticle(particle, true)
							ParticleManager:ReleaseParticleIndex(particle)
						end)
					else
						ParticleManager:ReleaseParticleIndex(particle)
					end
				end
			end
		else

			-- Set how much time the spell charged
			ability.time_charged = GameRules:GetGameTime() - ability.brew_start

			-- Self-blow response
			EmitSoundOn(self_blow_response[math.random(1, #self_blow_response)], caster)

			local info =
				{
					Target = caster,
					Source = caster,
					Ability = ability,
					bDodgeable = false,
					EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
					iMoveSpeed = ability:GetSpecialValueFor("movement_speed"),
				}
			ProjectileManager:CreateTrackingProjectile(info)
			ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
			caster:RemoveModifierByName("modifier_imba_unstable_concoction_handler")
		end
	end
end


modifier_imba_unstable_concoction_stunned = modifier_imba_unstable_concoction_stunned or class({})
function modifier_imba_unstable_concoction_stunned:CheckState()
	local state =
		{[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_imba_unstable_concoction_stunned:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return decFuncs
end

function modifier_imba_unstable_concoction_stunned:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_unstable_concoction_stunned:IsPurgable() return false end
function modifier_imba_unstable_concoction_stunned:IsPurgeException() return true end
function modifier_imba_unstable_concoction_stunned:IsStunDebuff() return true end
function modifier_imba_unstable_concoction_stunned:IsHidden() return false end
function modifier_imba_unstable_concoction_stunned:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_imba_unstable_concoction_stunned:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
-------------------------------------------
--      GOBLINS GREED & GREEVILS GREED
-------------------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_goblins_greed_passive"] = LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_greevils_greed_handler"]= LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_greevil_gold"]			= LUA_MODIFIER_MOTION_NONE,
})
imba_alchemist_goblins_greed = imba_alchemist_goblins_greed or class ({})

function imba_alchemist_goblins_greed:GetAbilityTextureName()
	return "alchemist_goblins_greed"
end

function imba_alchemist_goblins_greed:IsStealable()
	return false
end

function imba_alchemist_goblins_greed:OnInventoryContentsChanged()
	-- Checks if Alchemist now has a scepter, or still has it.
	if IsServer() then
		local caster = self:GetCaster()
		local mammonite_ability = "imba_alchemist_mammonite"

		if caster:HasAbility(mammonite_ability) then
			local mammonite_ability_handler = caster:FindAbilityByName(mammonite_ability)
			if mammonite_ability_handler then
				if caster:HasScepter() then
					mammonite_ability_handler:SetLevel(1)
					mammonite_ability_handler:SetHidden(false)
				else
					if mammonite_ability_handler:GetLevel() > 0 then
						mammonite_ability_handler:SetLevel(0)
						mammonite_ability_handler:SetHidden(true)
					end
				end
			end
		end
	end
end

function imba_alchemist_goblins_greed:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target)
end

function imba_alchemist_goblins_greed:GetIntrinsicModifierName()
	return "modifier_imba_goblins_greed_passive"
end

function imba_alchemist_goblins_greed:OnUpgrade()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())
	local base_gold = self:GetSpecialValueFor("bonus_gold")
	local base_gold_1 = self:GetLevelSpecialValueFor("bonus_gold", self:GetLevel() - 2)
	local stacks = modifier:GetStackCount()
	if self:GetLevel() == 1 then
		base_gold_1 = 0
	end
	modifier:SetStackCount(stacks + (base_gold - base_gold_1))
end

function imba_alchemist_goblins_greed:OnSpellStart()
	if IsServer() then
		-- Can't spawn multiple greevils
		if self.greevil_active then self:EndCooldown() return end

		-- Ability properties
		local caster	= 	self:GetCaster()
		local target	=	self:GetCursorTarget()
		local cast_sound=	"DOTA_Item.Hand_Of_Midas"
		local modifier = caster:FindModifierByName(self:GetIntrinsicModifierName())
		-- Ability_paramaters
		local gold_multiplier	=	self:GetSpecialValueFor("gold_multiplier")
		local exp_multiplier	=	self:GetSpecialValueFor("exp_multiplier")
		local total_gold		=	target:GetGoldBounty() * gold_multiplier
		local total_exp			=	target:GetDeathXP()	* exp_multiplier
		local bonus_stacks		=	self:GetSpecialValueFor("bonus_stacks")
		local greevil_duration	=	self:GetSpecialValueFor("greevil_duration")
		self.greevil_active = true
		-- Play sound and show gold gain message to the owner
		target:EmitSound(cast_sound)
		SendOverheadEventMessage(PlayerResource:GetPlayer(caster:GetPlayerID()), OVERHEAD_ALERT_GOLD, target, total_gold, nil)

		-- Draw the midas gold conversion particle
		local particle_fx = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(particle_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)

		-- Grant gold and XP only to the caster
		target:SetDeathXP(0)
		target:SetMinimumGoldBounty(0)
		target:SetMaximumGoldBounty(0)

		-- Consume target
		target:Kill(self, caster)
		caster:AddExperience(total_exp, false, false)
		caster:ModifyGold(total_gold, true, 0)

		modifier:SetStackCount(modifier:GetStackCount() + bonus_stacks )


		-- Spawn greevil
		self.greevil = CreateUnitByName("npc_imba_alchemist_greevil", target:GetAbsOrigin(), true, caster, caster, caster:GetTeam())
		self.greevil:SetOwner(caster)
		self.greevil_ability = self.greevil:FindAbilityByName("imba_alchemist_greevils_greed")
		self.greevil_ability:SetLevel(1)

		--Destroy the greevil after the duration ends
		Timers:CreateTimer(greevil_duration,function()
			self.greevil:Destroy()
			self.greevil_active = false
		end)

		Timers:CreateTimer(0.1, function()
			self.greevil:MoveToNPC(caster)
		end)

		-- Apply periodic gold modifier
		caster:AddNewModifier(caster, self, "modifier_imba_greevil_gold", {duration = greevil_duration} )
	end
end


-- Periodic gold modifier
modifier_imba_greevil_gold 	=	modifier_imba_greevil_gold or class({})

function modifier_imba_greevil_gold:OnCreated()
	if IsServer() then
		-- Start giffing gold
		self:StartIntervalThink(2)
	end
end

function modifier_imba_greevil_gold:OnIntervalThink()
	if IsServer() then
		-- Ability properties
		local caster	=	self:GetCaster()
		local ability	=	self:GetAbility()
		local gold_particle	= "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
		local player 	= PlayerResource:GetPlayer(caster:GetPlayerID())
		local greed_modifier = caster:FindModifierByName("modifier_imba_goblins_greed_passive")
		local stacks
		if greed_modifier then
			stacks = greed_modifier:GetStackCount()
		end

		-- Ability paramaters
		local gold_pct	=	ability:GetSpecialValueFor("periodic_gold_percentage")
		local total_gold=	math.floor(stacks * (gold_pct/100))

		-- Apply gold particle
		local gold_particle_fx = ParticleManager:CreateParticleForPlayer(gold_particle, PATTACH_ABSORIGIN, caster, player)
		ParticleManager:SetParticleControl(gold_particle_fx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(gold_particle_fx, 1, caster:GetAbsOrigin())


		-- Gold message
		local msg_particle = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
		local msg_particle_fx = ParticleManager:CreateParticleForPlayer(msg_particle, PATTACH_ABSORIGIN, caster, player)
		ParticleManager:SetParticleControl(msg_particle_fx, 1, Vector(0, total_gold, 0))
		ParticleManager:SetParticleControl(msg_particle_fx, 2, Vector(2, string.len(total_gold) + 1, 0))
		ParticleManager:SetParticleControl(msg_particle_fx, 3, Vector(255, 200, 33) )-- Gold

		-- Give gold
		caster:ModifyGold(total_gold, false, DOTA_ModifyGold_Unspecified)

	end
end

function modifier_imba_greevil_gold:IsHidden() return true end
function modifier_imba_greevil_gold:IsPurgable() return true end
function modifier_imba_greevil_gold:IsDebuff() return false end

modifier_imba_goblins_greed_passive = modifier_imba_goblins_greed_passive or class ({})

function modifier_imba_goblins_greed_passive:RemoveOnDeath()
	return false
end

function modifier_imba_goblins_greed_passive:IsPermanent()
	return true
end

function modifier_imba_goblins_greed_passive:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_imba_goblins_greed_passive:OnCreated()
	if IsServer() then
		self.greed_stacks = self:GetStackCount()
		local caster = self:GetCaster()
		if not caster:IsIllusion() then
			local ability = self:GetAbility()

		end
	end
end

function modifier_imba_goblins_greed_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_imba_goblins_greed_passive:OnDeath(keys)
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local attacker = keys.attacker
	local unit = keys.unit
	local reincarnate = keys.reincarnate

	if caster:PassivesDisabled() then
		return
	end

	if caster == attacker and caster:GetTeamNumber() ~= unit:GetTeamNumber() then

		-- If the target is reincarnating, do nothing
		if reincarnate then
			return nil
		end

		local stacks = self:GetStackCount()
		local hero_multiplier = 1
		if unit:IsHero() then
			hero_multiplier = ability:GetSpecialValueFor("hero_multiplier")
		end
		caster:ModifyGold(stacks * hero_multiplier, false, DOTA_ModifyGold_Unspecified)
		local player = PlayerResource:GetPlayer(caster:GetPlayerID())
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
		local particle1 = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_ABSORIGIN, unit, player)
		ParticleManager:SetParticleControl(particle1, 0, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle1, 1, unit:GetAbsOrigin())

		local symbol = 0 -- "+" presymbol
		local color = Vector(255, 200, 33) -- Gold
		local lifetime = 2
		local digits = string.len(stacks) + 1
		local particleName = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"
		local particle2 = ParticleManager:CreateParticleForPlayer(particleName, PATTACH_ABSORIGIN, unit, player)
		ParticleManager:SetParticleControl(particle2, 1, Vector(symbol, stacks, symbol))
		ParticleManager:SetParticleControl(particle2, 2, Vector(lifetime, digits, 0))
		ParticleManager:SetParticleControl(particle2, 3, color)

		local stack_bonus = ability:GetSpecialValueFor("bonus_bonus_gold")
		local duration = ability:GetSpecialValueFor("duration")
		self:SetStackCount(stacks + stack_bonus)

		Timers:CreateTimer(duration, function()
			if not stacks then return nil end
			stacks = self:GetStackCount()
			self:SetStackCount(stacks - stack_bonus)
		end)
	end
end



-- LITTLE GREEVIL SHIT

imba_alchemist_greevils_greed = imba_alchemist_greevils_greed or class ({})

function imba_alchemist_greevils_greed:GetAbilityTextureName()
	return "alchemist_goblins_greed"
end

function imba_alchemist_greevils_greed:GetCastRange()
	return 1
end

function imba_alchemist_greevils_greed:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local owner = caster:GetOwner()

	local greed_ability = owner:FindAbilityByName("imba_alchemist_goblins_greed")

	local hull_size = target:GetHullRadius()
	local particle_greevil_fx = ParticleManager:CreateParticle(particle_greevil, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle_greevil_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_greevil_fx, 1, Vector(hull_size*3, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_greevil_fx)


	caster.target = nil
	caster:MoveToNPC(caster:GetOwner())
end

function imba_alchemist_greevils_greed:GetIntrinsicModifierName()
	return "modifier_imba_greevils_greed_handler"
end

modifier_imba_greevils_greed_handler = modifier_imba_greevils_greed_handler or class ({})

function modifier_imba_greevils_greed_handler:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.owner = self.caster:GetOwner()

		-- Start thinking
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_greevils_greed_handler:OnIntervalThink()
	if IsServer() then
		-- If Alchemist is invisible, remove the model
		if self.owner:IsImbaInvisible() then
			self.caster:AddNoDraw()
		else
			self.caster:RemoveNoDraw()
		end

		-- If the greevil's target is dead, clear the target
		if self.caster.target and not self.caster.target:IsAlive() then
			self.caster.target = nil
		end

		-- If the greevil does not have a target, go back to Alchemist, if he is alive.
		if not self.caster.target then
			if self.owner:IsAlive() then
				self.caster:MoveToNPC(self.owner)

				-- If Alchemist is dead, THEN THE MADAFAKA IS DEAD TOO MUHAHAHAHA
			else
				self:Destroy()
			end
		end
	end
end

function modifier_imba_greevils_greed_handler:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}

		return state
	end
end


----------------------------------
--          CHEMICAL RAGE       --
----------------------------------
-- Visible Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_chemical_rage_buff_haste"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_chemical_rage_aura_buff"]	=	LUA_MODIFIER_MOTION_NONE,
})
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_imba_chemical_rage_handler"] = LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_chemical_rage_aura"] 		= LUA_MODIFIER_MOTION_NONE,
	["modifier_imba_chemical_rage_aura_talent"] =  LUA_MODIFIER_MOTION_NONE,
})
imba_alchemist_chemical_rage = imba_alchemist_chemical_rage or class ({})

function imba_alchemist_chemical_rage:GetAbilityTextureName()
	return "alchemist_chemical_rage"
end

function imba_alchemist_chemical_rage:IsHiddenWhenStolen()
	return false
end

function imba_alchemist_chemical_rage:GetAssociatedSecondaryAbilities()
	return "imba_alchemist_acid_spray"
end

function imba_alchemist_chemical_rage:OnSpellStart()
	local caster = self:GetCaster()
	local cast_response = {"alchemist_alch_ability_rage_01", "alchemist_alch_ability_rage_02", "alchemist_alch_ability_rage_03", "alchemist_alch_ability_rage_04", "alchemist_alch_ability_rage_05", "alchemist_alch_ability_rage_06", "alchemist_alch_ability_rage_07", "alchemist_alch_ability_rage_08", "alchemist_alch_ability_rage_09", "alchemist_alch_ability_rage_10", "alchemist_alch_ability_rage_11", "alchemist_alch_ability_rage_12", "alchemist_alch_ability_rage_13", "alchemist_alch_ability_rage_15", "alchemist_alch_ability_rage_16", "alchemist_alch_ability_rage_17", "alchemist_alch_ability_rage_18", "alchemist_alch_ability_rage_19", "alchemist_alch_ability_rage_20", "alchemist_alch_ability_rage_21", "alchemist_alch_ability_rage_22", "alchemist_alch_ability_rage_23", "alchemist_alch_ability_rage_24", "alchemist_alch_ability_rage_25"}

	-- See if enough enemies are nearby to inform them about the visitation rules of your swamp
	local radius_of_swamp = 800
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius_of_swamp, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER, false)
	local swamp_maximum_occupancy = PlayerResource:GetPlayerCount() * 0.25

	--Wait how many of you are there around me?
	if #enemies >= swamp_maximum_occupancy then
		-- WHAT ARE YOU DOING IN MY SWAMP?!
		caster:EmitSound("Imba.AlchemistMySwamp")
	else
		-- Play cast response
		EmitSoundOn(cast_response[math.random(1,#cast_response)], caster)
	end

	caster:Purge(false, true, false, false, false)
	caster:AddNewModifier(caster, self, "modifier_imba_chemical_rage_handler", {})
	caster:EmitSound("Hero_Alchemist.ChemicalRage.Cast")
end

modifier_imba_chemical_rage_handler = modifier_imba_chemical_rage_handler or class ({})

function modifier_imba_chemical_rage_handler:IsHidden()
	return true
end

function modifier_imba_chemical_rage_handler:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:GetUnitName() == "npc_dota_hero_alchemist" then
			caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
		end
		local ability = self:GetAbility()
		self:SetDuration(ability:GetSpecialValueFor("transformation_time"), false)
	end
end

function modifier_imba_chemical_rage_handler:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end

function modifier_imba_chemical_rage_handler:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local buff_duration = ability:GetSpecialValueFor("duration")
		if caster:HasModifier("modifier_imba_chemical_rage_buff_haste") then
			caster:RemoveModifierByName("modifier_imba_chemical_rage_buff_haste")
		end
		caster:AddNewModifier(caster, ability, "modifier_imba_chemical_rage_buff_haste", {duration = buff_duration})

		-- Remove aura modifier if it already exists
		if caster:HasModifier("modifier_imba_chemical_rage_aura_talent") then
			caster:RemoveModifierByName("modifier_imba_chemical_rage_aura_talent")
		end

		-- Apply new aura modifier
		if caster:HasTalent("special_bonus_imba_alchemist_8") then
			caster:AddNewModifier(caster, ability, "modifier_imba_chemical_rage_aura_talent", {duration = buff_duration})
		end
	end
end

modifier_imba_chemical_rage_buff_haste = modifier_imba_chemical_rage_buff_haste or class ({})

function modifier_imba_chemical_rage_buff_haste:AllowIllusionDuplicate()
	return true
end

function modifier_imba_chemical_rage_buff_haste:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local parent = self:GetParent()

		local particle_acid_aura = "particles/hero/alchemist/chemical_rage_acid_aura.vpcf"
		-- Ability paramaters
		self.ability			= 	caster:FindAbilityByName("imba_alchemist_acid_spray")
		self.radius				=	self.ability:GetSpecialValueFor("radius")

		local particle_acid_aura_fx = ParticleManager:CreateParticle(particle_acid_aura, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle_acid_aura_fx, 0, parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_acid_aura_fx, 1, parent:GetAbsOrigin())
		self:AddParticle(particle_acid_aura_fx, false, false, -1, false, false)

	end
end

function modifier_imba_chemical_rage_buff_haste:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		if caster:GetUnitName() == "npc_dota_hero_alchemist" and caster == parent then
			caster:StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
		end
	end
end

function modifier_imba_chemical_rage_buff_haste:IsAura()
	return true
end

function modifier_imba_chemical_rage_buff_haste:GetAuraRadius()
	return self.radius
end

function modifier_imba_chemical_rage_buff_haste:GetAuraSearchTeam()
	return self.ability:GetAbilityTargetTeam()
end

function modifier_imba_chemical_rage_buff_haste:GetAuraSearchType()
	return self.ability:GetAbilityTargetType()
end

function modifier_imba_chemical_rage_buff_haste:GetAuraSearchFlags()
	return self.ability:GetAbilityTargetFlags()
end

function modifier_imba_chemical_rage_buff_haste:GetModifierAura()
	return "modifier_imba_chemical_rage_aura"
end

function modifier_imba_chemical_rage_buff_haste:DeclareFunctions()
	local table = {
		MODIFIER_PROPERTY_BASE_MANA_REGEN,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return table
end

function modifier_imba_chemical_rage_buff_haste:GetActivityTranslationModifiers()
	return "chemical_rage"
end

function modifier_imba_chemical_rage_buff_haste:GetAttackSound()
	return "Hero_Alchemist.ChemicalRage.Attack"
end

function modifier_imba_chemical_rage_buff_haste:GetModifierBaseManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_imba_chemical_rage_buff_haste:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end

function modifier_imba_chemical_rage_buff_haste:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_imba_chemical_rage_buff_haste:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("base_attack_time")
end

function modifier_imba_chemical_rage_buff_haste:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

function modifier_imba_chemical_rage_buff_haste:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_chemical_rage_buff_haste:GetStatusEffectName()
	return "particles/status_fx/status_effect_chemical_rage.vpcf"
end

function modifier_imba_chemical_rage_buff_haste:StatusEffectPriority()
	return 10
end

function modifier_imba_chemical_rage_buff_haste:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_imba_chemical_rage_buff_haste:HeroEffectPriority()
	return 10
end

-- Chemical Rage Acid aura
modifier_imba_chemical_rage_aura = modifier_imba_chemical_rage_aura or class({})

function modifier_imba_chemical_rage_aura:IsDebuff()
	return true
end

function modifier_imba_chemical_rage_aura:IsHidden()
	return true
end

function modifier_imba_chemical_rage_aura:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local unit = self:GetParent()
		self.ability = caster:FindAbilityByName("imba_alchemist_acid_spray")
		self.modifier = unit:FindModifierByName("modifier_imba_acid_spray_debuff_dot")

		if self.modifier then
			self.modifier.damage = self.ability:GetSpecialValueFor("damage")
			self.modifier.stack_damage = self.ability:GetSpecialValueFor("stack_damage")
			local tick_rate = self.ability:GetSpecialValueFor("tick_rate")
			self:StartIntervalThink(tick_rate)
		end
	end
end

function modifier_imba_chemical_rage_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_chemical_rage_aura:OnIntervalThink()
	if IsServer() then
		if self.modifier:IsNull() then
			return --volvo pls
		end
		self.modifier:OnIntervalThink(true, false)
	end
end

-- #8 Talent: Chemical Rage gives a bonus damage aura equal to greed stacks
modifier_imba_chemical_rage_aura_talent	=	modifier_imba_chemical_rage_aura_talent or class ({})

function modifier_imba_chemical_rage_aura_talent:IsHidden()
	return true
end

function modifier_imba_chemical_rage_aura_talent:IsAura()
	return true
end

function modifier_imba_chemical_rage_aura_talent:GetAuraRadius()
	return self:GetCaster():FindTalentValue("special_bonus_imba_alchemist_8")
end

function modifier_imba_chemical_rage_aura_talent:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_chemical_rage_aura_talent:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_chemical_rage_aura_talent:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_imba_chemical_rage_aura_talent:GetModifierAura()
	return "modifier_imba_chemical_rage_aura_buff"
end

modifier_imba_chemical_rage_aura_buff	=	modifier_imba_chemical_rage_aura_buff or class({})

function modifier_imba_chemical_rage_aura_buff:OnCreated()
	if IsServer() then
		caster	=	self:GetCaster()

		self:SetStackCount(caster:FindModifierByName("modifier_imba_goblins_greed_passive"):GetStackCount())
	end
end
function modifier_imba_chemical_rage_aura_buff:DeclareFunctions()
	local decFuncs	=	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
	return decFuncs
end

function modifier_imba_chemical_rage_aura_buff:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount()
end

function modifier_imba_chemical_rage_aura_buff:IsDebuff()
	return false
end

function modifier_imba_chemical_rage_aura_buff:IsHidden()
	return false
end

----------------------------------
--         MAMMONITE            --
----------------------------------
-- Hidden Modifiers:
MergeTables(LinkedModifiers,{
	["modifier_mammonite_passive"] = LUA_MODIFIER_MOTION_NONE,
})
imba_alchemist_mammonite = imba_alchemist_mammonite or class({})

function imba_alchemist_mammonite:GetAbilityTextureName()
	return "custom/alchemist_mammonite"
end

function imba_alchemist_mammonite:OnToggle() return end

function imba_alchemist_mammonite:GetIntrinsicModifierName()
	return "modifier_mammonite_passive"
end

-- Scepter gold attacks modifier
modifier_mammonite_passive = modifier_mammonite_passive or class({})

function modifier_mammonite_passive:IsHidden() return true end
function modifier_mammonite_passive:IsPurgable() return false end
function modifier_mammonite_passive:IsDebuff() return false end
function modifier_mammonite_passive:RemoveOnDeath() return false end

function modifier_mammonite_passive:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	self.gold_damage = self.ability:GetSpecialValueFor("gold_damage")
end

function modifier_mammonite_passive:OnRefresh()
	self:OnCreated()
end

function modifier_mammonite_passive:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_ABILITY_LAYOUT}

	return decFuncs
end

function modifier_mammonite_passive:GetModifierAbilityLayout()
	return 5
end

function modifier_mammonite_passive:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		if self.caster:HasScepter() then
			if self.ability:GetToggleState() then
				local gold = self.caster:GetGold()
				local gold_percent = self.gold_damage * 0.01
				local gold_damage = gold * gold_percent
				return gold_damage
			end
		end
	end
end

function modifier_mammonite_passive:OnAttackFinished(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply if the attacker is the caster
		if self.caster == attacker then
			if self.caster:HasScepter() then
				if self.ability:GetToggleState() then
					local gold = self.caster:GetGold()
					local gold_percent = self.gold_damage * 0.01
					local gold_damage = gold * gold_percent
					self.caster:SpendGold(gold_damage, DOTA_ModifyGold_Unspecified)
				end
			end
		end
	end
end
-------------------------------------------
for LinkedModifier, MotionController in pairs(LinkedModifiers) do
	LinkLuaModifier(LinkedModifier, "components/abilities/heroes/hero_alchemist.lua", MotionController)
end
