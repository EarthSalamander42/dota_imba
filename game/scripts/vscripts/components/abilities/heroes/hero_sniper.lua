-- Editors:
--     Shush, 20.04.2017

--------------------------------
--         SHRAPNEL           --
--------------------------------
imba_sniper_shrapnel = class({})
LinkLuaModifier("modifier_imba_shrapnel_attack", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shrapnel_charges", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shrapnel_aura", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shrapnel_slow", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sniper_shrapnel:GetAbilityTextureName()
	return "sniper_shrapnel"
end

function imba_sniper_shrapnel:GetIntrinsicModifierName()
	return "modifier_imba_shrapnel_charges"
end

function imba_sniper_shrapnel:IsHiddenWhenStolen()
	return false
end

function imba_sniper_shrapnel:GetAOERadius()
	local ability = self
	local radius = ability:GetSpecialValueFor("radius")
	return radius
end

function imba_sniper_shrapnel:GetCastRange(location, target)
	local caster = self:GetCaster()
	local base_range = self.BaseClass.GetCastRange(self, location, target)

	-- #1 Talent: Shrapnel's cast range becomes global
	if caster:HasTalent("special_bonus_imba_sniper_1") then
		base_range = math.max(base_range, base_range * caster:FindTalentValue("special_bonus_imba_sniper_1"))
	else
		base_range = math.max(base_range, base_range)
	end

	return base_range
end

function imba_sniper_shrapnel:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = self:GetCursorPosition()
	local cast_response = { "sniper_snip_ability_shrapnel_01", "sniper_snip_ability_shrapnel_03" }
	local group_cast_response = { "sniper_snip_ability_shrapnel_02", "sniper_snip_ability_shrapnel_04", "sniper_snip_ability_shrapnel_06" }
	local rare_group_cast_response = "sniper_snip_ability_shrapnel_06"
	local sound_cast = "Hero_Sniper.ShrapnelShoot"
	local sound_shrapnel = "Hero_Sniper.ShrapnelShatter"
	local particle_launch = "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf"
	local modifier_charge = "modifier_imba_shrapnel_charges"
	local modifier_slow_aura = "modifier_imba_shrapnel_aura"
	local modifier_range = "modifier_imba_shrapnel_attack"

	-- Ability specials
	local delay = ability:GetSpecialValueFor("delay")
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("radius")

	-- Find how many enemies in inside the target point
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	-- If there are 4 enemies, roll for a rare group cast sound
	if #enemies >= 4 then
		if RollPercentage(5) then
			EmitSoundOn(rare_group_cast_response, caster)

			-- Roll for a normal group response
		elseif RollPercentage(75) then
			EmitSoundOn(group_cast_response[math.random(1, #group_cast_response)], caster)
		end

		-- Roll for a normal cast response
	elseif RollPercentage(75) then
		EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)
	end

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Play shrapnel sound
	EmitSoundOn(sound_shrapnel, caster)

	-- Find the location the launch will go to
	local distance = (target_point - caster:GetAbsOrigin()):Length2D()
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()
	local launch_position = caster:GetAbsOrigin() + direction * (distance / 2)

	-- Add a launch particle effect
	local particle_launch_fx = ParticleManager:CreateParticle(particle_launch, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle_launch_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_launch_fx, 1, Vector(launch_position.x, launch_position.y, launch_position.z + 1000))
	ParticleManager:ReleaseParticleIndex(particle_launch_fx)

	-- Reduce a charge
	if caster:HasModifier(modifier_charge) then
		local modifier_charge_handler = caster:FindModifierByName(modifier_charge)
		if modifier_charge_handler then
			modifier_charge_handler:DecrementStackCount()
		end
	end

	-- Wait for the delay to end
	Timers:CreateTimer(delay, function()
		-- Apply a modifier thinker on target location
		CreateModifierThinker(caster, ability, modifier_slow_aura, { duration = duration }, target_point, caster:GetTeamNumber(), false)

		-- Apply the attack check modifier to the caster for the duration
		caster:AddNewModifier(caster, ability, modifier_range, { duration = duration })

		-- Add a FOW Viewer for the duration
		AddFOWViewer(caster:GetTeamNumber(), target_point, radius, duration, false)
	end)
end

-- Freely attack target modifier
modifier_imba_shrapnel_attack = class({})

function modifier_imba_shrapnel_attack:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_slow = "modifier_imba_shrapnel_slow"
		self.modifier_attack = "modifier_imba_shrapnel_attack"

		-- Ability specials
		self.distance_damage_pct = self.ability:GetSpecialValueFor("distance_damage_pct")

		-- Global fire distance
		self.global_fire_distance = 25000

		-- Start thinking. Commit once immediately, without waiting for the next frame
		self:OnIntervalThink()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_shrapnel_attack:IsHidden() return true end

function modifier_imba_shrapnel_attack:IsPurgable() return false end

function modifier_imba_shrapnel_attack:IsDebuff() return false end

function modifier_imba_shrapnel_attack:OnIntervalThink()
	if IsServer() then
		-- Look for new illusions that do not have this modifier, but only if that's the real caster's
		if self.caster:IsRealHero() then
			local heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
				self.caster:GetAbsOrigin(),
				nil,
				5000,
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false)

			-- Give illusions the attack buff
			for _, hero in pairs(heroes) do
				if hero:GetUnitName() == self.caster:GetUnitName() and hero:IsIllusion() and not hero:HasModifier(self.modifier_attack) then
					hero:AddNewModifier(self.caster, self.ability, self.modifier_attack, { duration = self:GetRemainingTime() })
				end
			end
		end

		-- If there is no target currently set, clear distance and do nothing else
		if not self.current_target then
			self.distance_from_target = nil
			return nil
		end

		-- Check if the target still has the shrapnel debuff. If not, disable global attack range and clear the target
		if not self.current_target:HasModifier(self.modifier_slow) then
			self.current_target = nil
			self.global_distance = false
		end

		-- If there's no more a target, do nothing
		if not self.current_target then
			return nil
		end

		-- However, if there still is, get the distance from it
		self.distance_from_target = (self.caster:GetAbsOrigin() - self.current_target:GetAbsOrigin()):Length2D()
	end
end

function modifier_imba_shrapnel_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_shrapnel_attack:OnOrder(keys)
	if IsServer() then
		local order_type = keys.order_type
		local target = keys.target
		local unit = keys.unit

		-- Only apply if the caster is the issuing unit
		if unit == self.parent then
			-- If the target is a Roshan, do nothing.
			if target and target:IsRoshan() then
				self.current_target = nil
				self.global_distance = false
				return nil
			end

			-- If the caster issued an attack on a target with the shrapnel debuff, apply global range
			if order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and target:HasModifier(self.modifier_slow) then
				self.current_target = target
				self.global_distance = true
			else
				-- Otherwise, disable global attack range and clear target mark
				self.current_target = nil
				self.global_distance = false
			end
		end
	end
end

function modifier_imba_shrapnel_attack:GetModifierAttackRangeBonus()
	-- Only apply if the caster should be able to attack globally
	if self.global_distance then
		return self.global_fire_distance
	end

	return nil
end

function modifier_imba_shrapnel_attack:GetModifierDamageOutgoing_Percentage()
	if IsServer() then
		-- If the distance is not defined or there is no target, do nothing
		if not self.current_target or not self.distance_from_target then
			return 0
		end

		-- Get the caster's attack range
		local caster_attack_range = self.caster:Script_GetAttackRange()

		-- If the caster's range isn't buffed, do nothing
		if caster_attack_range < self.global_fire_distance then
			return 0
		end

		-- If it is, check if the distance from the target of the original attack range
		if self.distance_from_target <= (caster_attack_range - self.global_fire_distance) then
			-- If the target is inside the normal attack range, do nothing
			return 0
		else
			-- Otherwise, reduce the outgoing damage
			local distance_damage_pct = self.distance_damage_pct

			-- #8 Talent: Shrapnel attacks increase the damage done to the target instead of lowering it
			if self.caster:HasTalent("special_bonus_imba_sniper_8") then
				return distance_damage_pct
			else
				return (100 - distance_damage_pct) * (-1)
			end
		end
	end
end

-- Shrapnel charges modifier
modifier_imba_shrapnel_charges = class({})

function modifier_imba_shrapnel_charges:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.modifier_charge = "modifier_imba_shrapnel_charges"

		-- Ability specials
		self.max_charge_count = self.ability:GetSpecialValueFor("max_charge_count")
		self.charge_replenish_rate = self.ability:GetSpecialValueFor("charge_replenish_rate")

		-- -- If it the real one, set max charges
		-- if self.caster:IsRealHero() then
		self:SetStackCount(self.max_charge_count)
		-- else
		-- -- Illusions find their owner and its charges
		-- local playerid = self.caster:GetPlayerID()
		-- local real_hero = playerid:GetAssignedHero()

		-- if hero:HasModifier(self.modifier_charge) then
		-- self.modifier_charge_handler = hero:FindModifierByName(self.modifier_charge)
		-- if self.modifier_charge_handler then
		-- self:SetStackCount(self.modifier_charge_handler:GetStackCount())
		-- self:SetDuration(self.modifier_charge_handler:GetRemainingTime(), true)
		-- end
		-- end
		-- end

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_shrapnel_charges:OnIntervalThink()
	if IsServer() then
		local stacks = self:GetStackCount()

		if self.caster:HasAbility("special_bonus_imba_sniper_4") and self.caster:FindAbilityByName("special_bonus_imba_sniper_4"):GetLevel() == 1 then
			self.max_charge_count = self.ability:GetSpecialValueFor("max_charge_count") * self.caster:FindTalentValue("special_bonus_imba_sniper_4", "max_charge_mult")
		else
			self.max_charge_count = self.ability:GetSpecialValueFor("max_charge_count")
		end

		-- If we have at least one stack, set ability to active, otherwise disable it
		if stacks > 0 then
			self.ability:SetActivated(true)
		else
			self.ability:SetActivated(false)
		end
		-- If we're at max charges, do nothing else
		if stacks == self.max_charge_count then
			return nil
		end

		-- If a charge has finished charging, give a stack
		if self:GetRemainingTime() < 0 then
			local replenish_count = 1
			if self.caster:HasAbility("special_bonus_imba_sniper_4") and self.caster:FindAbilityByName("special_bonus_imba_sniper_4"):GetLevel() == 1 then
				replenish_count = self.caster:FindTalentValue("special_bonus_imba_sniper_4", "charges_per_recharge")
			end

			for i = 1, replenish_count do
				self:IncrementStackCount()

				-- If after incrementing, the stack count is now at max, do nothing
				if self:GetStackCount() == self.max_charge_count then
					break
				end
			end
		end
	end
end

function modifier_imba_shrapnel_charges:OnStackCountChanged(old_stack_count)
	if IsServer() then
		-- Current stacks
		local stacks = self:GetStackCount()
		local true_replenish_cooldown = self.ability:GetSpecialValueFor("charge_replenish_rate")

		-- If the stacks are now 0, start the ability's cooldown
		if stacks < 1 then
			self.ability:EndCooldown()
			self.ability:StartCooldown(self:GetRemainingTime())
		end

		-- If the stack count is now 1, and the skill is still in cooldown because of some cd manipulation, refresh it
		if stacks == 1 and not self.ability:IsCooldownReady() then
			self.ability:EndCooldown()
		end

		local lost_stack
		if old_stack_count > stacks then
			lost_stack = true
		else
			lost_stack = false
		end

		if not lost_stack then
			-- If we're not at the max stacks yet, reset the timer
			if stacks < self.max_charge_count then
				self:SetDuration(true_replenish_cooldown, true)
			else
				-- Otherwise, stop the timer
				self:SetDuration(-1, true)
			end
		else
			if old_stack_count == self.max_charge_count then
				self:SetDuration(true_replenish_cooldown, true)
			end
		end
	end
end

function modifier_imba_shrapnel_charges:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_imba_shrapnel_charges:OnAbilityFullyCast(keys)
	if IsServer() then
		local ability = keys.ability
		local unit = keys.unit

		-- If this was the caster casting Refresher, refresh charges
		if unit == self.caster and ability:GetName() == "item_refresher" then
			self:SetStackCount(self.max_charge_count)
		end
	end
end

function modifier_imba_shrapnel_charges:DestroyOnExpire()
	return false
end

function modifier_imba_shrapnel_charges:IsHidden() return false end

function modifier_imba_shrapnel_charges:IsPurgable() return false end

function modifier_imba_shrapnel_charges:IsDebuff() return false end

-- #4 Talent: Doubles the maximum amount of Shrapnel charges and grants twice the amount of charges per recharge
-- Triggers the "restart" of the charges modifier
LinkLuaModifier("modifier_special_bonus_imba_sniper_4", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_sniper_4 = modifier_special_bonus_imba_sniper_4 or class({})

function modifier_special_bonus_imba_sniper_4:IsHidden() return true end

function modifier_special_bonus_imba_sniper_4:IsPurgable() return false end

function modifier_special_bonus_imba_sniper_4:RemoveOnDeath() return false end

-- function modifier_special_bonus_imba_sniper_4:OnCreated()
-- if not IsServer() then return end

-- self:StartIntervalThink(FrameTime())
-- end

-- function modifier_special_bonus_imba_sniper_4:OnIntervalThink()
-- if self:GetParent():HasModifier("modifier_imba_shrapnel_charges") and self:GetCaster():HasAbility("imba_sniper_shrapnel") then
-- self:GetParent():FindModifierByName("modifier_imba_shrapnel_charges"):SetStackCount(math.min(self:GetStackCount() + math.max(self:GetCaster():FindAbilityByName("imba_sniper_shrapnel"):GetSpecialValueFor("max_charge_count") * (self:GetCaster():FindTalentValue("special_bonus_imba_sniper_4", "max_charge_mult") - 1), 0), self:GetCaster():FindAbilityByName("imba_sniper_shrapnel"):GetSpecialValueFor("max_charge_count") * (self:GetCaster():FindTalentValue("special_bonus_imba_sniper_4", "max_charge_mult"))))

-- if self:GetParent():FindModifierByName("modifier_imba_shrapnel_charges"):GetStackCount() >= self:GetCaster():FindAbilityByName("imba_sniper_shrapnel"):GetSpecialValueFor("max_charge_count") * (self:GetCaster():FindTalentValue("special_bonus_imba_sniper_4", "max_charge_mult")) then
-- self:GetParent():FindModifierByName("modifier_imba_shrapnel_charges"):SetDuration(-1, true)
-- end
-- end

-- self:StartIntervalThink(-1)
-- end

-- Shrapnel slow aura modifier
modifier_imba_shrapnel_aura = class({})

function modifier_imba_shrapnel_aura:IsHidden() return true end

function modifier_imba_shrapnel_aura:IsPurgable() return false end

function modifier_imba_shrapnel_aura:IsDebuff() return false end

function modifier_imba_shrapnel_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.particle_shrapnel = "particles/units/heroes/hero_sniper/sniper_shrapnel.vpcf"
	if self.caster:HasTalent("special_bonus_imba_sniper_3") then
		self.particle_shrapnel = "particles/econ/items/sniper/sniper_charlie/sniper_shrapnel_charlie.vpcf"
	end

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")

	-- Add shrapnel particl effect
	self.particle_shrapnel_fx = ParticleManager:CreateParticle(self.particle_shrapnel, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 1, Vector(self.radius, self.radius, 0))
	ParticleManager:SetParticleControl(self.particle_shrapnel_fx, 2, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_shrapnel_fx, false, false, -1, false, false)
end

function modifier_imba_shrapnel_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_shrapnel_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_shrapnel_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_shrapnel_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_shrapnel_aura:GetModifierAura()
	return "modifier_imba_shrapnel_slow"
end

function modifier_imba_shrapnel_aura:IsAura()
	return true
end

-- Shrapnel slow debuff modifier
modifier_imba_shrapnel_slow = class({})

function modifier_imba_shrapnel_slow:IsHidden() return false end

function modifier_imba_shrapnel_slow:IsPurgable() return false end

function modifier_imba_shrapnel_slow:IsDebuff() return true end

function modifier_imba_shrapnel_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.damage = self.ability:GetSpecialValueFor("damage")
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")

	if IsServer() then
		-- Deal damage
		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)

		-- Start thinking for damage
		self:StartIntervalThink(1)
	end
end

function modifier_imba_shrapnel_slow:OnIntervalThink()
	if IsServer() then
		-- Deal another instance of damage
		local damageTable = {
			victim = self.parent,
			attacker = self.caster,
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self.ability
		}

		ApplyDamage(damageTable)
	end
end

function modifier_imba_shrapnel_slow:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MISS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_shrapnel_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end

function modifier_imba_shrapnel_slow:GetModifierPhysicalArmorBonus()
	-- #3 Talent: Enemy units under Shrapnel's lose armor and can miss attacks.
	return self:GetCaster():FindTalentValue("special_bonus_imba_sniper_3", "armor_reduction") * (-1)
end

function modifier_imba_shrapnel_slow:GetModifierMiss_Percentage()
	-- #3 Talent: Enemy units under Shrapnel's lose armor and can miss attacks.
	return self:GetCaster():FindTalentValue("special_bonus_imba_sniper_3", "miss_chance_pct")
end

--------------------------------
--         HEADSHOT           --
--------------------------------
imba_sniper_headshot = class({})
-- LinkLuaModifier("modifier_imba_headshot_attacks", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headshot_slow", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_perfectshot_stun", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_headshot_eyeshot", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_sniper_headshot", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)

modifier_imba_sniper_headshot = class({})
-- modifier_imba_sniper_headshot	= modifier_imba_sniper_headshot or class({})


-- function imba_sniper_headshot:GetAbilityTextureName()
-- return "sniper_headshot"
-- end

-- function imba_sniper_headshot:IsHiddenWhenStolen()
-- return true
-- end

-- function imba_sniper_headshot:GetIntrinsicModifierName()
-- return "modifier_imba_headshot_attacks"
-- end

function imba_sniper_headshot:GetIntrinsicModifierName()
	-- return "modifier_imba_headshot_attacks"
	return "modifier_imba_sniper_headshot"
end

-----------------------------------
-- MODIFIER_IMBA_SNIPER_HEADSHOT --
-----------------------------------

-- I'm rewriting Headshot because the code here is EXTREMELY difficult to read through; I'll keep the old code commented out so you can make your own comparisons
-- -- AltiV

function modifier_imba_sniper_headshot:IsHidden() return self:GetStackCount() <= 0 end

-- -- This doesn't even work -_-
-- function modifier_imba_sniper_headshot:AllowIllusionDuplicate()
-- return false
-- end

function modifier_imba_sniper_headshot:OnCreated()
	if not IsServer() then return end

	self.headshot_records    = {}
	self.perfectshot_records = {}
end

function modifier_imba_sniper_headshot:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PROJECTILE_NAME,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_imba_sniper_headshot:OnAttackRecord(keys)
	if not self:GetParent():PassivesDisabled() and not self:GetParent():IsIllusion() and keys.target and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("perfectshot_attacks") and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("proc_chance"), self) then
			self.headshot_records[keys.record] = true
		elseif self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("perfectshot_attacks") - 1 then
			self.headshot_records[keys.record]    = true
			self.perfectshot_records[keys.record] = true
		end
	end
end

function modifier_imba_sniper_headshot:OnAttackRecordDestroy(keys)
	if self.headshot_records[keys.record] then
		self.headshot_records[keys.record] = nil
	end

	if self.perfectshot_records[keys.record] then
		self.perfectshot_records[keys.record] = nil
	end

	if self.take_aim_aimed_assault and self.take_aim_aimed_assault[keys.record] then
		self.take_aim_aimed_assault[keys.record] = nil
	end
end

function modifier_imba_sniper_headshot:OnAttack(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():PassivesDisabled() and keys.target and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and (not self.take_aim_aimed_assault or self.take_aim_aimed_assault and not self.take_aim_aimed_assault[keys.record]) then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("perfectshot_attacks") - 1 then
			self:IncrementStackCount()
		else
			self:SetStackCount(0)
		end
	end
end

function modifier_imba_sniper_headshot:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and keys.target and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.target:IsMagicImmune() then
		if self.headshot_records[keys.record] then
			-- "The knockback is not applied on units who are already affected by other sources of forced movement."
			if keys.target.Custom_IsUnderForcedMovement and not keys.target:Custom_IsUnderForcedMovement() then
				keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {
					center_x           = self:GetParent():GetAbsOrigin()[1] + 1,
					center_y           = self:GetParent():GetAbsOrigin()[2] + 1,
					center_z           = self:GetParent():GetAbsOrigin()[3],
					duration           = self:GetAbility():GetSpecialValueFor("knockback_duration") * (1 - keys.target:GetStatusResistance()),
					knockback_duration = self:GetAbility():GetSpecialValueFor("knockback_duration") * (1 - keys.target:GetStatusResistance()),
					knockback_distance = self:GetAbility():GetSpecialValueFor("knockback_distance"),
					knockback_height   = 0,
					should_stun        = 0
				})

				keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_headshot_slow", { duration = self:GetAbility():GetSpecialValueFor("headshot_duration") * (1 - keys.target:GetStatusResistance()) })
			end
		end

		-- IMBAfication: Perfect Shot
		if self.perfectshot_records[keys.record] then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_perfectshot_stun", {
				duration = self:GetAbility():GetSpecialValueFor("perfectshot_stun_duration") * (1 - keys.target:GetStatusResistance())
			})
		end

		if self.take_aim_aimed_assault and self.take_aim_aimed_assault[keys.record] and self:GetCaster():HasTalent("special_bonus_imba_sniper_7") then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_headshot_eyeshot", {
				duration = self:GetCaster():FindTalentValue("special_bonus_imba_sniper_7", "duration") * (1 - keys.target:GetStatusResistance())
			})
		end
	end
end

function modifier_imba_sniper_headshot:GetModifierProjectileName(keys)
	if (self:GetStackCount() == self:GetAbility():GetSpecialValueFor("perfectshot_attacks") - 1 or (self:GetCaster():GetModifierStackCount("modifier_imba_take_aim_range", self:GetCaster()) and self:GetCaster():GetModifierStackCount("modifier_imba_take_aim_range", self:GetCaster()) == 0)) and (self:GetParent():GetAttackTarget() and not self:GetParent():GetAttackTarget():IsBuilding() and not self:GetParent():GetAttackTarget():IsOther() and self:GetParent():GetAttackTarget():GetTeamNumber() ~= self:GetParent():GetTeamNumber()) then
		return "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
	end
end

function modifier_imba_sniper_headshot:GetModifierPreAttack_BonusDamage(keys)
	if keys.target and not self:GetParent():IsIllusion() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self.headshot_records[keys.record] then
		return self:GetAbility():GetSpecialValueFor("headshot_damage")
	end
end

function modifier_imba_sniper_headshot:GetModifierPreAttack_CriticalStrike(keys)
	if keys.target and not self:GetParent():IsIllusion() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self.perfectshot_records[keys.record] then
		return self:GetAbility():GetSpecialValueFor("perfectshot_critical_dmg_pct")
	end
end

-- -- Attacks counter
-- modifier_imba_headshot_attacks = class({})

-- function modifier_imba_headshot_attacks:OnCreated()
-- if IsServer() then
-- -- Ability properties
-- self.caster = self:GetCaster()
-- self.ability = self:GetAbility()
-- self.modifier_headshot_counter = "modifier_imba_headshot_counter"
-- self.modifier_imba_headshot_slow = "modifier_imba_headshot_slow"
-- self.modifier_imba_perfectshot_stun = "modifier_imba_perfectshot_stun"
-- self.ability_aim = "imba_sniper_take_aim"

-- -- Ability specials
-- self.headshot_attacks = self.ability:GetSpecialValueFor("headshot_attacks")
-- self.headshot_damage = self.ability:GetSpecialValueFor("headshot_damage")
-- self.headshot_duration = self.ability:GetSpecialValueFor("headshot_duration")
-- self.perfectshot_critical_dmg_pct = self.ability:GetSpecialValueFor("perfectshot_critical_dmg_pct")
-- self.perfectshot_stun_duration = self.ability:GetSpecialValueFor("perfectshot_stun_duration")
-- self.perfectshot_attacks = self.ability:GetSpecialValueFor("perfectshot_attacks")
-- self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
-- self.knockback_distance = self.ability:GetSpecialValueFor("knockback_distance")
-- self.knockback_duration = self.ability:GetSpecialValueFor("knockback_duration")

-- self.proc_chance_pseudo		= self.proc_chance_pseudo or 0
-- self.PRNG_forty_pct_chance	= 20.20	-- Change this number if you change the headshot proc chance

-- -- Illusion crash fix
-- if self:GetAbility():GetLevel() ~= 0 then
-- -- Set stack count at 1
-- self:SetStackCount(1)
-- end

-- -- Seriously why does this modifier use so many god damn variables
-- self.attacks = self.attacks or 0
-- end
-- end

-- function modifier_imba_headshot_attacks:OnRefresh()
-- self:OnCreated()
-- end

-- function modifier_imba_headshot_attacks:IsHidden() return true end
-- function modifier_imba_headshot_attacks:IsPurgable() return false end
-- function modifier_imba_headshot_attacks:IsDebuff() return false end

-- function modifier_imba_headshot_attacks:DeclareFunctions()
-- local decFuncs = {MODIFIER_EVENT_ON_ATTACK_START,
-- MODIFIER_EVENT_ON_ATTACK,
-- MODIFIER_EVENT_ON_ATTACK_LANDED,
-- MODIFIER_EVENT_ON_ATTACK_FINISHED,
-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
-- MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE}
-- return decFuncs
-- end

-- function modifier_imba_headshot_attacks:OnAttackStart(keys)
-- if IsServer() then
-- local attacker = keys.attacker
-- local target = keys.target

-- local stacks = self:GetStackCount()

-- -- Only apply on caster's attacks
-- if attacker == self.caster then

-- -- If headshot is stolen, reset stacks to 1 over and over so it can't proc
-- if self.ability:IsStolen() then
-- self:SetStackCount(1)
-- end

-- -- Clear all marks, to start in a state of a new shot
-- self:ClearAllMarks()
-- self.increment_stacks = true

-- -- If caster is broken or an illusion, do nothing
-- if self.caster:PassivesDisabled() or self.caster:IsIllusion() then
-- self.increment_stacks = false
-- return nil
-- end

-- -- If the target is a buidling, do nothing
-- if target and target:IsBuilding() or target:IsOther() or target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
-- return nil
-- end

-- -- Why was there no proc chance thing implemented for like the longest time...anyways gonna simulate pseudo-random here since the base function is already taken by the perfectshot one below
-- -- if (RollPercentage(self.proc_chance_pseudo + self.PRNG_forty_pct_chance)) then
-- -- -- #5 Talent: Normal headshots have a chance to become Perfectshots
-- -- if self.caster:HasTalent("special_bonus_imba_sniper_5") and RollPseudoRandom(self.caster:FindTalentValue("special_bonus_imba_sniper_5"), self) then
-- -- self:ApplyAllMarks()
-- -- else
-- -- self:ApplyHeadshotMarks()
-- -- end	

-- -- self.proc_chance_pseudo = 0
-- -- else
-- -- self.proc_chance_pseudo = self.proc_chance_pseudo + self.PRNG_forty_pct_chance
-- -- end

-- -- Decide if this attack should be a perfectshot
-- if stacks % self.perfectshot_attacks == 0 then
-- self:ApplyAllMarks()
-- self.increment_stacks = true
-- end

-- -- Take Aim guaranteed Perfectshot
-- if self.caster:HasAbility(self.ability_aim) and self.caster:IsRealHero() then
-- local ability_aim_handler = self.caster:FindAbilityByName(self.ability_aim)

-- -- Check if Take Aim was found and is learned
-- if ability_aim_handler and ability_aim_handler:GetLevel() > 0 then

-- -- Check if the Take Aim is ready to be shot
-- local modifier_aim_stacks
-- local modifier_aim_handler = self.caster:FindModifierByName("modifier_imba_take_aim_range")

-- if modifier_aim_handler then
-- modifier_aim_stacks = modifier_aim_handler:GetStackCount()
-- end

-- if modifier_aim_handler and modifier_aim_stacks == 0 then

-- -- Proc a Perfect Shot, but do not count a stack
-- self:ApplyAllMarks(true)
-- self.increment_stacks = false
-- end
-- end
-- end
-- end
-- end
-- end

-- function modifier_imba_headshot_attacks:OnAttack(keys)
-- if IsServer() then
-- local attacker = keys.attacker
-- local target = keys.target

-- -- Only apply on caster's attacks
-- if attacker == self.caster and not target:IsBuilding() and not target:IsOther() and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

-- -- Increment stack count as soon as the attack fires
-- if self.increment_stacks then
-- self:IncrementStackCount()
-- end

-- -- Apply the relevant stats for the attack that is flying towards the enemy
-- if self.enable_headshot_bonus_damage then
-- self.attack_headshot_slow = true
-- end

-- if self.enable_critical_damage then
-- self.attack_perfectshot_stun = true
-- end

-- -- A moment after the attack is fired, reset attack marks (so next shots wouldn't benefit from them)
-- Timers:CreateTimer(FrameTime(), function()
-- self:ClearAllMarks()
-- end)

-- -- Clear forced mark
-- local modifier_aim_handler = self.caster:FindModifierByName("modifier_imba_take_aim_range")

-- if modifier_aim_handler then
-- modifier_aim_handler.forced_aimed_assault = nil
-- end
-- end
-- end
-- end

-- function modifier_imba_headshot_attacks:OnAttackLanded(keys)
-- if IsServer() then
-- local attacker = keys.attacker
-- local target = keys.target

-- -- Only apply on caster's attacks
-- if attacker == self.caster and not keys.no_attack_cooldown and not target:IsBuilding() and not target:IsOther() and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
-- self.attacks = self.attacks + 1

-- -- If target is magic immune, we won't get any headshot or perfectshot, because fuck logic
-- if target:IsMagicImmune() then
-- if self.attacks > self.perfectshot_attacks then
-- self.attacks = 0
-- end

-- return nil
-- end

-- -- If a Perfectshot is marked, headshot and stun the target
-- -- if self.attack_perfectshot_stun then
-- if self.attacks > self.perfectshot_attacks then
-- target:AddNewModifier(self.caster, self.ability, self.modifier_imba_headshot_slow, {duration = self.headshot_duration})
-- target:AddNewModifier(self.caster, self.ability, self.modifier_imba_perfectshot_stun, {duration = self.perfectshot_stun_duration})

-- -- Knocknback enemy
-- local knockback = {
-- center_x = self.caster:GetAbsOrigin()[1]+1,
-- center_y = self.caster:GetAbsOrigin()[2]+1,
-- center_z = self.caster:GetAbsOrigin()[3],
-- duration = self.knockback_duration,
-- knockback_duration = self.knockback_duration,
-- knockback_distance = self.knockback_distance,
-- knockback_height = 0,
-- should_stun = 0
-- }

-- local knockback_modifier = target:AddNewModifier(self.caster, self.ability, "modifier_knockback", knockback)

-- if knockback_modifier then
-- knockback_modifier:SetDuration(self.knockback_duration * (1 - target:GetStatusResistance()), true)
-- end

-- if self.attacks > self.perfectshot_attacks then
-- self.attacks = 0
-- end

-- -- Not a Perfectshot, but might be a Headshot
-- elseif RollPseudoRandom(self.proc_chance, self) then
-- target:AddNewModifier(self.caster, self.ability, self.modifier_imba_headshot_slow, {duration = self.headshot_duration})

-- -- Knocknback enemy
-- local knockback = {
-- center_x = self.caster:GetAbsOrigin()[1]+1,
-- center_y = self.caster:GetAbsOrigin()[2]+1,
-- center_z = self.caster:GetAbsOrigin()[3],
-- duration = self.knockback_duration,
-- knockback_duration = self.knockback_duration,
-- knockback_distance = self.knockback_distance,
-- knockback_height = 0,
-- should_stun = 0
-- }

-- local knockback_modifier = target:AddNewModifier(self.caster, self.ability, "modifier_knockback", knockback)

-- if knockback_modifier then
-- knockback_modifier:SetDuration(self.knockback_duration * (1 - target:GetStatusResistance()), true)
-- end
-- end

-- -- #7 Talent: Take Aim's Aimed Assaults cause the target to bleed and lose vision
-- if self.caster:HasTalent("special_bonus_imba_sniper_7") and self.aimed_assault and target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
-- local eyeshot_duration = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "duration")
-- target:AddNewModifier(self.caster, self.ability, "modifier_imba_headshot_eyeshot", {duration = eyeshot_duration})
-- end
-- end
-- end
-- end

-- function modifier_imba_headshot_attacks:OnAttackFinished(keys)
-- if IsServer() then
-- local attacker = keys.attacker
-- local target = keys.target

-- -- Only apply on caster's attacks
-- if attacker == self.caster then
-- -- No matter what happened, clear stats in the next frame
-- Timers:CreateTimer(FrameTime(), function()
-- self.attack_perfectshot_stun = false
-- self.attack_headshot_slow = false

-- -- Clear Aimed Assault, in case it's marked
-- self.aimed_assault = false
-- end)
-- end
-- end
-- end

-- function modifier_imba_headshot_attacks:ApplyHeadshotMarks()
-- -- Apply marks associated with headshots
-- self.enable_headshot_bonus_damage = true
-- end

-- function modifier_imba_headshot_attacks:ApplyAllMarks(aimed_assault)
-- -- Apply marks
-- self.enable_headshot_bonus_damage = true
-- self.enable_critical_damage = true

-- if aimed_assault then
-- self.aimed_assault = true
-- end

-- -- Set the projectile to be used
-- self.caster:SetRangedProjectileName("particles/units/heroes/hero_sniper/sniper_assassinate.vpcf")
-- end

-- function modifier_imba_headshot_attacks:ClearAllMarks()
-- -- Clear all marks
-- self.enable_headshot_bonus_damage = false
-- self.enable_critical_damage = false

-- if not self.ability:IsStolen() then
-- -- Clear projectile
-- self.caster:SetRangedProjectileName("particles/units/heroes/hero_sniper/sniper_base_attack.vpcf")
-- else
-- -- Retrieve Rubick's projectile in case of stolen spell
-- self.caster:SetRangedProjectileName("particles/units/heroes/hero_rubick/rubick_base_attack.vpcf")
-- end
-- end

-- function modifier_imba_headshot_attacks:GetModifierPreAttack_BonusDamage()
-- if IsServer() then
-- -- Only apply if the next shot is going to be a headshot
-- if self.enable_headshot_bonus_damage then
-- return self.headshot_damage
-- end

-- return false
-- end
-- end

-- function modifier_imba_headshot_attacks:GetModifierPreAttack_CriticalStrike()
-- if IsServer() then
-- -- Only apply if the next shot is going to be a perfect shot
-- if self.enable_critical_damage then
-- return self.perfectshot_critical_dmg_pct
-- end
-- end
-- end

-- function modifier_imba_headshot_attacks:OnStackCountChanged(old_stack_count)
-- if IsServer() then
-- -- If we're past the perfect shot count, reset stacks
-- if old_stack_count >= self.perfectshot_attacks then
-- self:SetStackCount(1)
-- end
-- end
-- end

-- Headshot slow modifier
modifier_imba_headshot_slow = class({})

function modifier_imba_headshot_slow:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.headshot_ms_slow_pct = self.ability:GetSpecialValueFor("headshot_ms_slow_pct")
	self.headshot_as_slow = self.ability:GetSpecialValueFor("headshot_as_slow")

	if not IsServer() then return end

	-- Add Headshot particle effects
	local particle_slow_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_slow_fx, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_slow_fx, false, false, -1, false, true)
end

function modifier_imba_headshot_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_headshot_slow:GetModifierAttackSpeedBonus_Constant()
	return self.headshot_as_slow * (-1)
end

function modifier_imba_headshot_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.headshot_ms_slow_pct * (-1)
end

function modifier_imba_headshot_slow:IsHidden() return false end

function modifier_imba_headshot_slow:IsPurgable() return true end

function modifier_imba_headshot_slow:IsDebuff() return true end

-- Perfectshot stun modifier
modifier_imba_perfectshot_stun = class({})

function modifier_imba_perfectshot_stun:OnCreated()
	-- Ability properties
	self.ability = self:GetAbility()

	-- Ability specials
	self.perfectshot_stun_duration = self.ability:GetSpecialValueFor("perfectshot_stun_duration")

	if not IsServer() then return end

	-- Add Perfectshot particle effects
	local particle_stun_fx = ParticleManager:CreateParticle("particles/hero/sniper/perfectshot_stun.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(particle_stun_fx, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_stun_fx, 1, self:GetParent():GetAbsOrigin())
	self:AddParticle(particle_stun_fx, false, false, -1, false, true)
end

function modifier_imba_perfectshot_stun:CheckState()
	local state
	-- Get remaining time, compare it to how long the stun is supposed to go on
	local time_remaining = self:GetRemainingTime()
	local modifier_duration = self:GetDuration()

	if self.perfectshot_stun_duration and (modifier_duration - time_remaining) > self.perfectshot_stun_duration then
		state = nil
	else
		state = { [MODIFIER_STATE_STUNNED] = true }
	end

	return state
end

function modifier_imba_perfectshot_stun:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }

	return decFuncs
end

function modifier_imba_perfectshot_stun:IsHidden() return false end

function modifier_imba_perfectshot_stun:IsPurgeException() return true end

function modifier_imba_perfectshot_stun:IsStunDebuff() return true end

modifier_imba_headshot_eyeshot = modifier_imba_headshot_eyeshot or class({})

function modifier_imba_headshot_eyeshot:IsHidden() return false end

function modifier_imba_headshot_eyeshot:IsPurgable() return true end

function modifier_imba_headshot_eyeshot:IsDebuff() return true end

function modifier_imba_headshot_eyeshot:OnCreated()
	-- Talent properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Talent specials
	self.damage_per_second = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "damage_per_second")
	self.vision_loss = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "vision_loss")
	self.damage_interval = self.caster:FindTalentValue("special_bonus_imba_sniper_7", "damage_interval")

	if IsServer() then
		-- Start thinking
		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_headshot_eyeshot:OnIntervalThink()
	local damage = self.damage_per_second * self.damage_interval

	-- Deal damage to the parent
	local damageTable = {
		victim = self.parent,
		attacker = self.caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability
	}

	local actual_damage = ApplyDamage(damageTable)

	-- Show bleed notification
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, self.parent, actual_damage, nil)
end

function modifier_imba_headshot_eyeshot:DeclareFunctions()
	local decFuncs = { MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION }

	return decFuncs
end

function modifier_imba_headshot_eyeshot:GetBonusDayVision()
	return self.vision_loss * (-1)
end

function modifier_imba_headshot_eyeshot:GetBonusNightVision()
	return self.vision_loss * (-1)
end

--------------------------------
--         TAKE AIM           --
--------------------------------
imba_sniper_take_aim = class({})
LinkLuaModifier("modifier_imba_take_aim_range", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sniper_take_aim:GetAbilityTextureName()
	return "sniper_take_aim"
end

function imba_sniper_take_aim:GetIntrinsicModifierName()
	return "modifier_imba_take_aim_range"
end

function imba_sniper_take_aim:IsStealable()
	return false
end

function imba_sniper_take_aim:GetCastRange(location, target)
	local caster = self:GetCaster()

	-- Passive range
	local range = self:GetSpecialValueFor("passive_bonus_range")

	local aim_bonus_range = self:GetSpecialValueFor("aim_bonus_range")

	-- Get caster's base attack range
	-- Valve pls, no function for base attack range? really? *sigh* hardcoded it is then
	local base_range = 550

	range = range + aim_bonus_range + base_range
	return range
end

function imba_sniper_take_aim:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	-- local modifier_aim = "modifier_imba_take_aim_range"

	-- -- Find modifier, mark it
	-- local modifier_aim_handler = caster:FindModifierByName(modifier_aim)
	-- if modifier_aim_handler then
	-- modifier_aim_handler.forced_aimed_assault = true
	-- end

	if self:GetCaster():HasModifier("modifier_imba_take_aim_range") then
		self:GetCaster():FindModifierByName("modifier_imba_take_aim_range"):SetStackCount(0)
	end

	-- Move to attack, mark as forced Aimed Assault
	caster:MoveToTargetToAttack(target)
	caster:PerformAttack(target, false, true, false, false, true, false, false)
end

-- Bonus range modifier
modifier_imba_take_aim_range = class({})

function modifier_imba_take_aim_range:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	-- self.modifier_headshot = "modifier_imba_headshot_attacks"
	self.forced_aimed_assault = false

	-- Ability specials
	self.passive_bonus_range = self.ability:GetSpecialValueFor("passive_bonus_range")
	self.aim_bonus_range = self.ability:GetSpecialValueFor("aim_bonus_range")
	self.cooldown = self.ability:GetSpecialValueFor("cooldown")

	-- Start thinking
	if IsServer() then
		-- When first learned, toggle spell on
		if not self.toggled_on_default then
			self.toggled_on_default = true
			self.ability:ToggleAutoCast()
		end

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_take_aim_range:IsHidden() return true end

function modifier_imba_take_aim_range:IsPurgable() return false end

function modifier_imba_take_aim_range:IsDebuff() return false end

function modifier_imba_take_aim_range:OnRefresh()
	self:OnCreated()
end

function modifier_imba_take_aim_range:OnIntervalThink()
	if IsServer() then
		self.caster:SetAcquisitionRange(self.caster:Script_GetAttackRange() + 100)

		-- If the next shot should be an Aimed Shot, set stacks to 0, otherwise set to 1
		if self.ability:IsCooldownReady() and self.ability:GetAutoCastState() and self.caster:IsRealHero() then
			self:SetStackCount(0)
		else
			self:SetStackCount(1)
		end

		if not self.headshot_modifier and self:GetParent():HasModifier("modifier_imba_sniper_headshot") then
			self.headshot_modifier = self:GetParent():FindModifierByName("modifier_imba_sniper_headshot")
		end
	end
end

function modifier_imba_take_aim_range:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK
	}
end

-- IMBAfication: Aimed Assault
function modifier_imba_take_aim_range:OnAttackRecord(keys)
	if not self:GetParent():IsIllusion() and keys.target and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetStackCount() == 0 and self.headshot_modifier then
		self.headshot_modifier.headshot_records[keys.record]    = true
		self.headshot_modifier.perfectshot_records[keys.record] = true

		if not self.headshot_modifier.take_aim_aimed_assault then
			self.headshot_modifier.take_aim_aimed_assault = {}
		end

		self.headshot_modifier.take_aim_aimed_assault[keys.record] = true
	end
end

function modifier_imba_take_aim_range:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker

		-- Only apply if the attacker is the caster
		if self.caster == attacker then
			-- -- If the attacker fired an Aimed Shot manually, set stacks to 0
			-- if self.forced_aimed_assault then
			-- self:SetStackCount(0)
			-- end

			-- If the attacker fired an Aimed Shot, go on cooldown
			if self:GetStackCount() == 0 and self.ability:IsCooldownReady() then
				self.ability:UseResources(false, false, false, true)
			end
		end
	end
end

function modifier_imba_take_aim_range:GetModifierAttackRangeBonus()
	--Passive range
	local range = self.passive_bonus_range

	-- If caster is broken, no passive range is given
	if self.caster:PassivesDisabled() then
		range = 0
	end

	-- #7 Talent: Take Aim Aimed Assault attack range
	local aim_bonus_range = self.aim_bonus_range + self.caster:FindTalentValue("special_bonus_imba_sniper_7")

	-- Bonus range if the ability is ready and is toggled on. Illusions do not gain the bonus range
	if self:GetStackCount() == 0 then
		range = range + aim_bonus_range
	end

	return range
end

--------------------------------
--        ASSASSINATE         --
--------------------------------
imba_sniper_assassinate = class({})
LinkLuaModifier("modifier_imba_sniper_assassinate_handler", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assassinate_cross", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_assassinate_ministun", "components/abilities/heroes/hero_sniper.lua", LUA_MODIFIER_MOTION_NONE)

function imba_sniper_assassinate:IsHiddenWhenStolen()
	return false
end

function imba_sniper_assassinate:GetIntrinsicModifierName()
	return "modifier_imba_sniper_assassinate_handler"
end

function imba_sniper_assassinate:GetBehavior()
	if not self:GetCaster():HasTalent("special_bonus_imba_sniper_6") then
		return self.BaseClass.GetBehavior(self)
	else
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_sniper_assassinate:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	-- #6 Talent: Assassination's cast point increases. When executed, it launches three projectiles towards the target.
	if self:GetCaster():HasTalent("special_bonus_imba_sniper_6") and self:GetCaster():GetModifierStackCount("modifier_imba_sniper_assassinate_handler", self:GetCaster()) == 1 then
		cast_point = cast_point + self:GetCaster():FindTalentValue("special_bonus_imba_sniper_6", "cast_point_increase")

		-- What is this balancing in my IMBA game
		-- (Make Overcharge not boost this speed cause it gets way too crazy)
		if IsServer() == true and self:GetCaster():HasModifier("modifier_imba_wisp_overcharge_721_aura") or self:GetCaster():HasModifier("modifier_imba_wisp_overcharge_721") and self:GetCaster().FindModifierByName then
			local overcharge_modifier = self:GetCaster():FindModifierByName("modifier_imba_wisp_overcharge_721") or self:GetCaster():FindModifierByName("modifier_imba_wisp_overcharge_721_aura")

			if overcharge_modifier.bonus_cast_speed then
				cast_point = cast_point / ((100 - math.min(overcharge_modifier.bonus_cast_speed, 99.99)) / 100)
			end
		end
	end

	--[[	
	-- #6 Talent: Assassination's cast point decreases.
	if self:GetCaster():HasTalent("special_bonus_imba_sniper_9") then
		cast_point = cast_point - self:GetCaster():FindTalentValue("special_bonus_imba_sniper_9")
	end
--]]
	if self:GetCaster():HasScepter() then
		cast_point = cast_point - self:GetSpecialValueFor("scepter_cast_time")
	end

	return cast_point
end

function imba_sniper_assassinate:GetAssociatedSecondaryAbilities()
	return "imba_sniper_headshot"
end

function imba_sniper_assassinate:OnAbilityPhaseStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = { "sniper_snip_ability_assass_02", "sniper_snip_ability_assass_06", "sniper_snip_ability_assass_07", "sniper_snip_ability_assass_08" }
	local modifier_cross = "modifier_imba_assassinate_cross"

	-- Ability specials
	local sight_duration = ability:GetSpecialValueFor("sight_duration")

	if self:GetAutoCastState() then
		sight_duration = sight_duration + self:GetCaster():FindTalentValue("special_bonus_imba_sniper_6", "cast_point_increase")
	end

	-- #6 Talent: Assassination's cast point increases. When executed, it launches three projectiles towards the target.
	-- Reset the animation before Sniper shoots
	if caster:HasTalent("special_bonus_imba_sniper_6") and self:GetCaster():GetModifierStackCount("modifier_imba_sniper_assassinate_handler", self:GetCaster()) == 1 then
		self.bAutoCast = true

		local scepter_speed_mult = 1

		if caster:HasScepter() then
			scepter_speed_mult = 0.7
		end

		-- "Reload" animation, to make it look good with the entire visual of the assassination talent
		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.75 * scepter_speed_mult)

		self.timer = Timers:CreateTimer(1.75 * scepter_speed_mult, function()
			if caster:GetCurrentActiveAbility() and caster:GetCurrentActiveAbility():GetName() == "imba_sniper_assassinate" then
				caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
				caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
			end
		end)
	else
		self.bAutoCast = false

		local playback_rate = 1.15

		if caster:HasScepter() then
			playback_rate = 1.5
		end

		caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, playback_rate)
	end

	-- Initialize index table
	if not self.enemy_table then
		self.enemy_table = {}
	end

	-- Targets
	local targets = {}

	-- Get targets
	targets[1] = self:GetCursorTarget()

	-- Play prepare cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Apply crosshair on target(s)
	for _, target in pairs(targets) do
		target:AddNewModifier(caster, ability, modifier_cross, { duration = sight_duration })

		-- Index enemy
		table.insert(self.enemy_table, target)
	end

	return true
end

function imba_sniper_assassinate:OnAbilityPhaseInterrupted()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_cross = "modifier_imba_assassinate_cross"

	-- Stop animations
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

	-- If the timer for the True Assassination animations is still running, destroy it
	if self.timer then
		Timers:RemoveTimer(self.timer)
		self.timer = nil
	end

	-- Find all enemies
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		FIND_UNITS_EVERYWHERE, -- global
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false)

	-- Remove the cross modifier from them, if they have it
	for _, enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_cross) then
			enemy:RemoveModifierByName(modifier_cross)
		end
	end

	-- Clear enemy table
	self.enemy_table = nil
end

function imba_sniper_assassinate:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Ability specials
	local projectiles = ability:GetSpecialValueFor("projectiles")

	-- Targets
	local targets = {}

	-- Get targets
	targets[1] = self:GetCursorTarget()

	-- Make up a table of enemies hit by the current cast
	self.enemies_hit = {}

	-- Kill responses marker
	self.enemy_died = false

	-- #6 Talent: Assassination's cast point increases. When executed, it launches three projectiles towards the target.
	-- Increase projectiles to fire
	if caster:HasTalent("special_bonus_imba_sniper_6") and self.bAutoCast then
		projectiles = caster:FindTalentValue("special_bonus_imba_sniper_6", "total_projectiles")
	end

	-- Fire projectiles!
	local projectiles_fired = 0
	local bAutoCast         = self.bAutoCast

	Timers:CreateTimer(function()
		-- Increment projectile count
		projectiles_fired = projectiles_fired + 1

		-- Fire projectile
		self:FireAssassinateProjectile(targets, projectiles_fired, projectiles, bAutoCast)

		-- Check if we need to fire more projectiles (#6 Talent)
		if projectiles_fired < projectiles then
			return caster:FindTalentValue("special_bonus_imba_sniper_6", "refire_delay")
		end
	end)
end

function imba_sniper_assassinate:FireAssassinateProjectile(targets, projectile_num, total_projectiles, bAutoCast)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local particle_projectile = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
		local sound_assassinate = "Ability.Assassinate"
		local sound_assassinate_launch = "Hero_Sniper.AssassinateProjectile"

		-- Play assassinate sound
		EmitSoundOn(sound_assassinate, caster)

		-- Play assassinate projectile sound
		EmitSoundOn(sound_assassinate_launch, caster)

		-- Ability specials
		local travel_speed = ability:GetSpecialValueFor("travel_speed")

		-- Mark the target(s) as a primary target
		for _, target in pairs(targets) do
			target.primary_assassination_target = true

			-- Launch assassinate projectile
			local assassinate_projectile
			assassinate_projectile = {
				Target = target,
				Source = caster,
				Ability = ability,
				EffectName = particle_projectile,
				iMoveSpeed = travel_speed,
				bDodgeable = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
				ExtraData = {
					target_entindex   = target:entindex(),
					projectile_num    = projectile_num,
					total_projectiles = total_projectiles,
					bAutoCast         = bAutoCast
				}
			}

			ProjectileManager:CreateTrackingProjectile(assassinate_projectile)
		end
	end
end

function imba_sniper_assassinate:OnProjectileHit_ExtraData(target, location, extradata)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local almost_kill_responses = { "sniper_snip_ability_fail_02", "sniper_snip_ability_fail_04", "sniper_snip_ability_fail_05", "sniper_snip_ability_fail_06", "sniper_snip_ability_fail_07", "sniper_snip_ability_fail_08" }
	local modifier_cross = "modifier_imba_assassinate_cross"
	local modifier_ministun = "modifier_imba_assassinate_ministun"

	-- Projectile's extra data
	local projectile_num = extradata.projectile_num

	-- Ability special
	local damage = ability:GetSpecialValueFor("damage")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")

	-- If the target still has it, remove the crosshair modifier
	if projectile_num == extradata.total_projectiles and EntIndexToHScript(extradata.target_entindex) then
		EntIndexToHScript(extradata.target_entindex):RemoveModifierByName(modifier_cross)
	end

	-- If there was no target, do nothing else
	if not target then
		return nil
	end

	self:AssassinateHit(target, projectile_num)

	-- Wait a small delay, then remove the primary target mark
	Timers:CreateTimer(0.3, function()
		target.primary_assassination_target = false
	end)

	-- Wait a very small delay, then check if nobody died, and the primary target is almost dead
	Timers:CreateTimer(0.1, function()
		if not self.enemy_died then
			local hp_pct = target:GetHealthPercent()
			if hp_pct <= 10 and target:IsAlive() then
				EmitSoundOn(almost_kill_responses[math.random(1, #almost_kill_responses)], caster)
			end
		end
	end)
end

function imba_sniper_assassinate:AssassinateHit(target, projectile_num)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local kill_responses = { "sniper_snip_ability_assass_03", "sniper_snip_ability_assass_04", "sniper_snip_ability_assass_05", "sniper_snip_ability_assass_03", "sniper_snip_kill_03", "sniper_snip_kill_08", "sniper_snip_kill_10", "sniper_snip_kill_13", "sniper_snip_tf2_01", "sniper_snip_tf2_01" }
	local particle_sparks = "particles/units/heroes/hero_sniper/sniper_assassinate_impact_sparks.vpcf"
	local particle_light = "particles/units/heroes/hero_sniper/sniper_assassinate_endpoint.vpcf"
	local particle_stun = "particles/hero/sniper/perfectshot_stun.vpcf"
	local modifier_ministun = "modifier_imba_assassinate_ministun"
	local modifier_perfectshot = "modifier_imba_perfectshot_stun"
	local modifier_headshot = "modifier_imba_headshot_slow"
	local head_shot_ability = "imba_sniper_headshot"

	-- Ability special
	local damage = ability:GetSpecialValueFor("damage")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")

	if caster:HasScepter() then
		ministun_duration = ability:GetSpecialValueFor("scepter_stun_duration")
	end

	-- Add table key to target
	local target_key = target:entindex() .. tostring(projectile_num)

	-- If that enemy was already hit on this cast, do nothing
	for _, enemy in pairs(self.enemies_hit) do
		if enemy == target_key then
			return nil
		end
	end

	-- Add that enemy to the list of enemies that got hit
	table.insert(self.enemies_hit, target_key)

	-- Primary target block with Linken and do not need the extra hit particle
	if target.primary_assassination_target then
		-- If target has Linken's Sphere off cooldown, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end
	else
		-- Apply blow particles on non-primary targets that got hit
		local particle_sparks_fx = ParticleManager:CreateParticle(particle_sparks, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle_sparks_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_sparks_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_sparks_fx)

		local particle_light_fx = ParticleManager:CreateParticle(particle_light, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle_light_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_light_fx)
	end

	-- Deal damage to target, if it's not magic immune
	if not target:IsMagicImmune() then
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability
		}

		ApplyDamage(damageTable)

		-- Apply a ministun to the target
		target:AddNewModifier(caster, ability, modifier_ministun, { duration = ministun_duration * (1 - target:GetStatusResistance()) })

		-- Memes (give a small cooldown to it so you don't potentially get the voice thing spammed upon multiple projectile lands
		if target:IsRealHero() and not target:IsAlive() and RollPercentage(100) and (not self.meme_cooldown or GameRules:GetGameTime() - self.meme_cooldown >= 2.0) then
			target:EmitSound("Hero_Sniper.Boom_Headshot")

			self.meme_cooldown = GameRules:GetGameTime()
		end
	end

	-- #2 Talent: Assassinate now knockbacks all units hit
	if caster:HasTalent("special_bonus_imba_sniper_2") then
		local push_distance = caster:FindTalentValue("special_bonus_imba_sniper_2")

		-- Knockback enemies up and towards the target point
		local knockbackProperties =
		{
			center_x = caster:GetAbsOrigin().x,
			center_y = caster:GetAbsOrigin().y,
			center_z = caster:GetAbsOrigin().z,
			duration = 0.2 * (1 - target:GetStatusResistance()),
			knockback_duration = 0.2 * (1 - target:GetStatusResistance()),
			knockback_distance = push_distance,
			knockback_height = 0
		}

		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)
	end

	-- Wait a game tick, and see if a target has died. If so, and it was the first to die, speak and mark the event
	Timers:CreateTimer(FrameTime(), function()
		if not target:IsAlive() and not self.enemy_died then
			self.enemy_died = true

			if RollPercentage(50) then
				EmitSoundOn(kill_responses[math.random(1, #kill_responses)], caster)
			end
		end
	end)
end

function imba_sniper_assassinate:OnProjectileThink_ExtraData(location, extradata)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self

	-- Extra Data
	local projectile_num = extradata.projectile_num

	-- Ability specials
	local bullet_radius = ability:GetSpecialValueFor("bullet_radius")

	-- Find enemy units around the area of the bullet
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		location,
		nil,
		bullet_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _, enemy in pairs(enemies) do
		if not enemy.primary_assassination_target then
			self:AssassinateHit(enemy, projectile_num)
		end
	end
end

function imba_sniper_assassinate:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

----------------------------------------------
-- MODIFIER_IMBA_SNIPER_ASSASSINATE_HANDLER --
----------------------------------------------

modifier_imba_sniper_assassinate_handler = modifier_imba_sniper_assassinate_handler or class({})

function modifier_imba_sniper_assassinate_handler:IsHidden() return true end

function modifier_imba_sniper_assassinate_handler:IsPurgable() return false end

function modifier_imba_sniper_assassinate_handler:RemoveOnDeath() return false end

function modifier_imba_sniper_assassinate_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_sniper_assassinate_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_sniper_assassinate_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-- Cross enemy debuff
modifier_imba_assassinate_cross = class({})

function modifier_imba_assassinate_cross:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.particle_cross = "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf"

		-- Netural units do not share vision
		if self.parent:IsNeutralUnitType() then
			self.should_share_vision = false
		else
			self.should_share_vision = true
		end

		-- Apply crosshair for allies
		self.particle_cross_fx = ParticleManager:CreateParticleForTeam(self.particle_cross, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_cross_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_cross_fx, false, false, -1, false, true)
	end
end

function modifier_imba_assassinate_cross:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_imba_assassinate_cross:IgnoreTenacity() return true end

function modifier_imba_assassinate_cross:IsHidden() return false end

function modifier_imba_assassinate_cross:IsPurgable() return false end

function modifier_imba_assassinate_cross:IsDebuff() return true end

function modifier_imba_assassinate_cross:CheckState()
	local state = nil
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		state = { [MODIFIER_STATE_PROVIDES_VISION] = true }
	end

	if self.should_share_vision then
		state = {
			[MODIFIER_STATE_PROVIDES_VISION] = true,
			[MODIFIER_STATE_INVISIBLE] = false
		}
	end

	return state
end

function modifier_imba_assassinate_cross:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

-- Ministun debuff
modifier_imba_assassinate_ministun = class({})

function modifier_imba_assassinate_ministun:IsHidden() return false end

function modifier_imba_assassinate_ministun:IsPurgeException() return true end

function modifier_imba_assassinate_ministun:IsStunDebuff() return true end

function modifier_imba_assassinate_ministun:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_assassinate_ministun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_imba_assassinate_ministun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_assassinate_ministun:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_assassinate_ministun:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_sniper_7", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_sniper_8", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_sniper_7 = modifier_special_bonus_imba_sniper_7 or class({})
modifier_special_bonus_imba_sniper_8 = modifier_special_bonus_imba_sniper_8 or class({})

function modifier_special_bonus_imba_sniper_7:IsHidden() return true end

function modifier_special_bonus_imba_sniper_7:IsPurgable() return false end

function modifier_special_bonus_imba_sniper_7:RemoveOnDeath() return false end

function modifier_special_bonus_imba_sniper_8:IsHidden() return true end

function modifier_special_bonus_imba_sniper_8:IsPurgable() return false end

function modifier_special_bonus_imba_sniper_8:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_sniper_6", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_sniper_9", "components/abilities/heroes/hero_sniper", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_sniper_6 = class({})
modifier_special_bonus_imba_sniper_9 = class({})

function modifier_special_bonus_imba_sniper_6:IsHidden() return true end

function modifier_special_bonus_imba_sniper_6:IsPurgable() return false end

function modifier_special_bonus_imba_sniper_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_sniper_6:OnCreated()
	if not IsServer() then return end

	if self:GetParent():HasAbility("imba_sniper_assassinate") then
		self:GetParent():FindAbilityByName("imba_sniper_assassinate"):ToggleAutoCast()

		if self:GetParent():HasModifier("modifier_imba_sniper_assassinate_handler") then
			self:GetParent():FindModifierByName("modifier_imba_sniper_assassinate_handler"):SetStackCount(1)
		end
	end
end

function modifier_special_bonus_imba_sniper_9:IsHidden() return true end

function modifier_special_bonus_imba_sniper_9:IsPurgable() return false end

function modifier_special_bonus_imba_sniper_9:RemoveOnDeath() return false end

function imba_sniper_assassinate:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_sniper_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_sniper_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_sniper_6"), "modifier_special_bonus_imba_sniper_6", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_sniper_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_sniper_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_sniper_9"), "modifier_special_bonus_imba_sniper_9", {})
	end
end
