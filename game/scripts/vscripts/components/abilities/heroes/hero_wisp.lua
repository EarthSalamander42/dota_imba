-- Editors:
--     EarthSalamander #42, 23.05.2018 (contributor)
--	   Naowin, 13.06.2018 (creator)
--     Based on old Dota 2 Spell Library: https://github.com/Pizzalol/SpellLibrary/blob/master/game/scripts/vscripts/heroes/hero_wisp

------------------------------
--			TETHER			--
------------------------------
imba_wisp_tether = class({})
-- This modifier applies on Wisp and deals with giving the target heal and mana amp
LinkLuaModifier("modifier_imba_wisp_tether", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_ally", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_latch", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_slow", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_wisp_tether_slow_immune", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_ally_attack", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_imba_wisp_tether_bonus_regen", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

-- This deals with the auto-cast logic for the Backpack Wisp IMBAfication
LinkLuaModifier("modifier_imba_wisp_tether_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_tether_backpack", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_tether:GetIntrinsicModifierName()
	return "modifier_imba_wisp_tether_handler"
end

function imba_wisp_tether:GetBehavior()
	if self:GetCaster():GetLevel() < self:GetSpecialValueFor("backpack_level_unlock") then
		return self.BaseClass.GetBehavior(self)
	else
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_wisp_tether:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_wisp_tether_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_wisp_5")
	else
		-- If the below value is negative then it doesn't show cast range properly on client-side, but still respects no cast range increases in server-side so...
		return self:GetSpecialValueFor("backpack_distance") - self:GetCaster():GetCastRangeBonus()
	end
end

function imba_wisp_tether:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "dota_hud_error_cant_cast_on_self"
	elseif target:HasModifier("modifier_imba_wisp_tether") and self:GetCaster():HasModifier("modifier_imba_wisp_tether_ally") then
		return "WHY WOULD YOU DO THIS"
	end
end

function imba_wisp_tether:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		if target == caster then
			return UF_FAIL_CUSTOM
		end

		if target:IsCourier() then
			return UF_FAIL_COURIER
		end

		if target:HasModifier("modifier_imba_wisp_tether") and self:GetCaster():HasModifier("modifier_imba_wisp_tether_ally") then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter(target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), caster:GetTeamNumber())
		return nResult
	end
end

function imba_wisp_tether:OnSpellStart()
	local ability             = self:GetCaster():FindAbilityByName("imba_wisp_tether")
	local caster              = self:GetCaster()
	local destroy_tree_radius = ability:GetSpecialValueFor("destroy_tree_radius")
	local movespeed           = ability:GetSpecialValueFor("movespeed")
	local regen_bonus         = ability:GetSpecialValueFor("tether_bonus_regen")
	local latch_distance      = self:GetSpecialValueFor("latch_distance")

	if caster:HasTalent("special_bonus_imba_wisp_5") then
		ability.bonus_range = caster:FindTalentValue("special_bonus_imba_wisp_5")
		latch_distance      = latch_distance + ability.bonus_range
	end

	-- needed to be accessed globaly
	ability.slow_duration   = ability:GetSpecialValueFor("stun_duration")
	ability.slow            = ability:GetSpecialValueFor("slow")

	self.caster_origin      = self:GetCaster():GetAbsOrigin()
	self.target_origin      = self:GetCursorTarget():GetAbsOrigin()
	self.tether_ally        = self:GetCursorTarget()
	self.tether_slowedUnits = {}
	self.target             = self:GetCursorTarget()

	-- Shifting caster of modifier from Wisp to the target so you can access their stats on client-side without laggy ass nettables or hack methods
	caster:AddNewModifier(self.target, self, "modifier_imba_wisp_tether", {})

	-- Why are there always so many stupid hidden OP buffs programmed in I'm commenting these out
	-- local self_regen_bonus = caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_tether_bonus_regen", {})
	-- self_regen_bonus:SetStackCount(regen_bonus)
	local tether_modifier = self:GetCursorTarget():AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_ally", {})
	tether_modifier:SetStackCount(movespeed)
	-- local target_regen_bonus = self:GetCursorTarget():AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_bonus_regen", {})
	-- target_regen_bonus:SetStackCount(regen_bonus)

	if caster:HasModifier("modifier_imba_wisp_overcharge") then
		if self.target:HasModifier("modifier_imba_wisp_overcharge") then
			self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
		end

		imba_wisp_overcharge:AddOvercharge(self:GetCaster(), self.target)
	end

	--7.21 version
	if caster:HasAbility("imba_wisp_overcharge_721") and caster:HasModifier("modifier_imba_wisp_overcharge_721") then
		self.target:AddNewModifier(caster, caster:FindAbilityByName("imba_wisp_overcharge_721"), "modifier_imba_wisp_overcharge_721", {})
	end

	if caster:HasTalent("special_bonus_imba_wisp_2") then
		self.tether_ally:SetStolenScepter(true)
		if self.tether_ally.CalculateStatBonus then
			self.tether_ally:CalculateStatBonus(true)
		end
	end

	if caster:HasTalent("special_bonus_imba_wisp_6") then
		self.target:AddNewModifier(self:GetCaster(), ability, "modifier_imba_wisp_tether_ally_attack", {})
	end

	if not self:GetAutoCastState() then
		local distToAlly = (self:GetCursorTarget():GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
		if distToAlly >= latch_distance then
			caster:AddNewModifier(caster, self, "modifier_imba_wisp_tether_latch", { destroy_tree_radius = destroy_tree_radius })
		end
	else
		caster:AddNewModifier(self.target, self, "modifier_imba_wisp_tether_backpack", {})
	end

	-- Let's manually add Tether Break for Rubick and Morphling so they can use the skill properly
	if not caster:HasAbility("imba_wisp_tether_break") then
		caster:AddAbility("imba_wisp_tether_break")
	end

	caster:SwapAbilities("imba_wisp_tether", "imba_wisp_tether_break", false, true)
	caster:FindAbilityByName("imba_wisp_tether_break"):SetLevel(1)
	-- "Goes on a 0.25-second cooldown when Tether is cast, so that it cannot be immediately broken."
	caster:FindAbilityByName("imba_wisp_tether_break"):StartCooldown(0.25)
end

-- Remove Tether Break for Rubick and Morphling when skill is lost
function imba_wisp_tether:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_tether_break") then
		self:GetCaster():RemoveAbility("imba_wisp_tether_break")
	end
end

---------------------
-- TETHER MODIFIER --
---------------------

modifier_imba_wisp_tether = class({})

function modifier_imba_wisp_tether:IsHidden() return false end

function modifier_imba_wisp_tether:IsPurgable() return false end

function modifier_imba_wisp_tether:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_imba_wisp_tether:OnCreated(params)
	self.target         = self:GetCaster()
	-- Store this value in those scenarios where Wisp would otherwise be sloweed by the tethered target (ex. Pangolier's Rolling Thunder)
	-- Second parameter of CDOTA_BaseNPC:GetMoveSpeedModifier checks if you want the value with no slows accounted for returned
	-- False for original means that Wisp can get slowed, and true for target means Wisp won't get slowed if the target gets slowed
	self.original_speed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.target_speed   = self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true)
	self.difference     = self.target_speed - self.original_speed

	if IsServer() then
		self.radius          = self:GetAbility():GetSpecialValueFor("radius")
		self.tether_heal_amp = self:GetAbility():GetSpecialValueFor("tether_heal_amp")

		if self:GetCaster():HasTalent("special_bonus_imba_wisp_5") then
			self.radius = self.radius + self:GetCaster():FindTalentValue("special_bonus_imba_wisp_5")
		end

		-- used to count total health/mana gained during 1sec
		self.total_gained_mana   = 0
		self.total_gained_health = 0
		self.update_timer        = 0
		self.time_to_send        = 1

		self:GetCaster():EmitSound("Hero_Wisp.Tether")
	end

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_wisp_tether:OnIntervalThink()
	self.difference     = 0

	self.original_speed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.target_speed   = self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true)
	self.difference     = self.target_speed - self.original_speed

	if not IsServer() then return end

	-- Morphling/Rubick exception...as per usual
	if not self:GetAbility() or not self:GetAbility().tether_ally then
		self:Destroy()
		return
	end

	self.update_timer = self.update_timer + FrameTime()

	-- handle health and mana
	if self.update_timer > self.time_to_send then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.target, self.total_gained_health * self.tether_heal_amp, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, self.total_gained_mana * self.tether_heal_amp, nil)

		self.total_gained_mana   = 0
		self.total_gained_health = 0
		self.update_timer        = 0
	end

	if (self:GetParent():IsOutOfGame()) then
		self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
		return
	end

	if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
		return
	end

	if (self:GetAbility().tether_ally:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius then
		return
	end

	self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether")
end

function modifier_imba_wisp_tether:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_EVENT_ON_MANA_GAINED,

		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}

	return decFuncs
end

function modifier_imba_wisp_tether:OnHealReceived(keys)
	if keys.unit == self:GetParent() then
		self.target:Heal(keys.gain * self.tether_heal_amp, self:GetAbility())
		-- in order to avoid spam in "OnGained" we group it up in total_gained. Value is sent and reset each 1s
		self.total_gained_health = self.total_gained_health + keys.gain
	end
end

function modifier_imba_wisp_tether:OnManaGained(keys)
	if keys.unit == self:GetParent() and self.target.GiveMana then
		self.target:GiveMana(keys.gain * self.tether_heal_amp)
		-- in order to avoid spam in "OnGained" we group it up in total_gained. Value is sent and reset each 1s
		self.total_gained_mana = self.total_gained_mana + keys.gain
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeedOverride()
	if self.target and self.target.GetBaseMoveSpeed then
		return self.target:GetBaseMoveSpeed()
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeedBonus_Constant()
	if self.original_speed and self.target:GetMoveSpeedModifier(self.target:GetBaseMoveSpeed(), true) >= self.original_speed and self.difference then
		return self.difference
	end
end

function modifier_imba_wisp_tether:GetModifierMoveSpeed_Limit()
	return self.target_speed
end

function modifier_imba_wisp_tether:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_imba_wisp_tether:OnRemoved()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_imba_wisp_tether_latch") then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end

		-- if self:GetParent():HasModifier("modifier_imba_wisp_tether_bonus_regen") then
		-- self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_bonus_regen")
		-- end

		if self:GetParent():HasModifier("modifier_imba_wisp_tether_backpack") then
			self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_backpack")
		end

		if self.target:HasModifier("modifier_imba_wisp_tether_ally") then
			self.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
			self.target:RemoveModifierByName("modifier_imba_wisp_tether_ally")
			--self.target:RemoveModifierByName("modifier_imba_wisp_tether_bonus_regen")
		end

		if self:GetCaster():HasTalent("special_bonus_imba_wisp_2") then
			self.target:SetStolenScepter(false)

			if self.target.CalculateStatBonus then
				self.target:CalculateStatBonus(true)
			end
		end

		self:GetCaster():EmitSound("Hero_Wisp.Tether.Stop")
		self:GetCaster():StopSound("Hero_Wisp.Tether")
		self:GetParent():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	end
end

------------------------------
--	 TETHER Regen modifier	--
------------------------------
-- modifier_imba_wisp_tether_bonus_regen = class({})
-- function modifier_imba_wisp_tether_bonus_regen:IsHidden() return true end
-- function modifier_imba_wisp_tether_bonus_regen:IsPurgable() return false end
-- function modifier_imba_wisp_tether_bonus_regen:DeclareFunctions()
-- local decFuncs = {
-- MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
-- }

-- return decFuncs
-- end

-- function modifier_imba_wisp_tether_bonus_regen:GetTexture()
-- return "wisp_tether"
-- end

-- function modifier_imba_wisp_tether_bonus_regen:GetModifierHealthRegenPercentage()
-- return self:GetStackCount() / 100
-- end


------------------------------
--	 TETHER AllY modifier	--
------------------------------
modifier_imba_wisp_tether_ally = class({})

function modifier_imba_wisp_tether_ally:IsHidden() return false end

function modifier_imba_wisp_tether_ally:IsPurgable() return false end

function modifier_imba_wisp_tether_ally:OnCreated()
	if IsServer() then
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.pfx, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_ally:OnIntervalThink()
	if IsServer() then
		-- Morphling/Rubick exception
		if not self:GetAbility() then
			self:Destroy()
			return
		end

		local velocity = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		local vVelocity = velocity / FrameTime()
		vVelocity.z = 0

		local projectile =
		{
			Ability          = self:GetAbility(),
			--			EffectName			= "particles/hero/ghost_revenant/blackjack_projectile.vpcf",
			vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
			fDistance        = velocity:Length2D(),
			fStartRadius     = 100,
			fEndRadius       = 100,
			bReplaceExisting = false,
			iMoveSpeed       = vVelocity,
			Source           = self:GetCaster(),
			iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime      = GameRules:GetGameTime() + 1,
			bDeleteOnHit     = false,
			vVelocity        = vVelocity / 3,
			ExtraData        = {
				slow_duration = self:GetAbility().slow_duration,
				slow          = self:GetAbility().slow
			}
		}

		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function imba_wisp_tether:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target ~= nil then
		-- Variables
		local caster        = self:GetCaster()
		local slow          = ExtraData.slow
		local slow_duration = ExtraData.slow_duration

		-- Acalia wants more stuff here...

		-- Apply slow debuff
		local slow_ref      = target:AddNewModifier(caster, self, "modifier_imba_wisp_tether_slow", { duration = slow_duration * (1 - target:GetStatusResistance()) })
		slow_ref:SetStackCount(slow)

		-- An enemy unit may only be slowed once per cast.
		-- We store the enemy unit to the hashset, so we can check whether the unit has got debuff already later on.
		--self:GetAbility().tether_slowedUnits[target] = true
	end
end

function modifier_imba_wisp_tether_ally:OnRemoved()
	if IsServer() then
		self:GetParent():StopSound("Hero_Wisp.Tether.Target")
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)

		if self:GetAbility() then
			self:GetAbility().target = nil
		end

		-- self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_slow_immune")
		-- self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_slow_immune")
		self:GetParent():RemoveModifierByName("modifier_imba_wisp_tether_ally_attack")
		self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")

		--7.21 version
		local overcharge_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_wisp_overcharge_721", self:GetCaster())
		if overcharge_modifier then
			overcharge_modifier:Destroy()
		end
	end
end

function modifier_imba_wisp_tether_ally:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_wisp_tether_ally:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("movespeed")
	end
end

--------------------------------------
--	 TETHER Track attack modifier	--
--------------------------------------
modifier_imba_wisp_tether_ally_attack = class({})
function modifier_imba_wisp_tether_ally_attack:IsHidden() return true end

function modifier_imba_wisp_tether_ally_attack:IsPurgable() return false end

function modifier_imba_wisp_tether_ally_attack:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK
	}

	return decFuncs
end

function modifier_imba_wisp_tether_ally_attack:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetCaster():PerformAttack(params.target, true, true, true, false, true, false, false)
		end
	end
end

--------------------------------------
--	 TETHER slow immune modifier	--
--------------------------------------
-- modifier_imba_wisp_tether_slow_immune = class({})
-- function modifier_imba_wisp_tether_slow_immune:IsHidden() return true end
-- function modifier_imba_wisp_tether_slow_immune:DeclareFunctions()
-- local funcs = {
-- MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
-- MODIFIER_PROPERTY_MOVESPEED_LIMIT
-- }
-- return funcs
-- end

-- function modifier_imba_wisp_tether_slow_immune:OnCreated(params)
-- if IsServer() then
-- self.limit 			= params.limit
-- self.minimum_speed 	= params.minimum_speed
-- else
-- local net_table 	= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
-- self.minimum_speed 	= net_table.tether_minimum_speed or 0
-- self.limit 			= net_table.tether_limit or 0
-- end
-- end

-- function modifier_imba_wisp_tether_slow_immune:GetModifierMoveSpeed_AbsoluteMin()
-- return self.minimum_speed
-- end

-- function modifier_imba_wisp_tether_slow_immune:GetModifierMoveSpeed_Limit()
-- return self.limit
-- end

------------------------------
--	 TETHER slow modifier	--
------------------------------
modifier_imba_wisp_tether_slow = class({})

function modifier_imba_wisp_tether_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_imba_wisp_tether_slow:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end

function modifier_imba_wisp_tether_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

------------------------------
--	 TETHER latch modifier	--
------------------------------
modifier_imba_wisp_tether_latch = class({})

function modifier_imba_wisp_tether_latch:IsHidden() return true end

function modifier_imba_wisp_tether_latch:IsPurgable() return false end

function modifier_imba_wisp_tether_latch:OnCreated(params)
	if IsServer() then
		self.target               = self:GetAbility().target
		self.destroy_tree_radius  = params.destroy_tree_radius
		-- "Pulls Io at a speed of 1000, until coming within 300 range of the target."
		self.final_latch_distance = 300

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_wisp_tether_latch:OnIntervalThink()
	if IsServer() then
		--"The pull gets interrupted when Io gets stunned, hexed, hidden, feared, hypnotize, or rooted during the pull."
		-- self:GetParent():IsFeared() and self:GetParent():IsHypnotized() don't actually exist as Valve functions but they'll be placeholders for if it gets implemented one way or another
		if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame() or (self:GetParent().IsFeared and self:GetParent():IsFeared()) or (self:GetParent().IsHypnotized and self:GetParent():IsHypnotized()) or self:GetParent():IsRooted() then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end

		-- Calculate the distance
		local casterDir = self:GetCaster():GetAbsOrigin() - self.target:GetAbsOrigin()
		local distToAlly = casterDir:Length2D()
		casterDir = casterDir:Normalized()

		if distToAlly > self.final_latch_distance then
			-- Leap to the target
			distToAlly = distToAlly - self:GetAbility():GetSpecialValueFor("latch_speed") * FrameTime()
			distToAlly = math.max(distToAlly, self.final_latch_distance) -- Clamp this value

			local pos = self.target:GetAbsOrigin() + casterDir * distToAlly
			pos = GetGroundPosition(pos, self:GetCaster())

			self:GetCaster():SetAbsOrigin(pos)
		end


		if distToAlly <= self.final_latch_distance then
			-- We've reached, so finish latching
			GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self.destroy_tree_radius, false)
			ResolveNPCPositions(self:GetCaster():GetAbsOrigin(), 128)
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether_latch")
		end
	end
end

function modifier_imba_wisp_tether_latch:OnDestroy()
	if not IsServer() then return end

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

------------------------------
--		 BREAK TETHER 		--
------------------------------
imba_wisp_tether_break = class({})
function imba_wisp_tether_break:IsInnateAbility() return true end

function imba_wisp_tether_break:IsStealable() return false end

function imba_wisp_tether_break:ProcsMagicStick() return false end

function imba_wisp_tether_break:OnSpellStart()
	-- Let's manually add Tether for Morphling so they can use the skill properly (super bootleg)
	if not self:GetCaster():HasAbility("imba_wisp_tether") then
		local stolenAbility = self:GetCaster():AddAbility("imba_wisp_tether")
		stolenAbility:SetLevel(min((self:GetCaster():GetLevel() / 2) - 1, 4))
		self:GetCaster():SwapAbilities("imba_wisp_tether_break", "imba_wisp_tether", false, true)
	end

	self:GetCaster():RemoveModifierByName("modifier_imba_wisp_tether")
	local target = self:GetCaster():FindAbilityByName("imba_wisp_tether").target
	if target ~= nil and target:HasModifier("modifier_imba_wisp_overcharge") then
		target:RemoveModifierByName("modifier_imba_wisp_overcharge")
	end
end

-- ugh
function imba_wisp_tether_break:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_tether") then
		self:GetCaster():RemoveAbility("imba_wisp_tether")
	end
end

-----------------------------
-- TETHER HANDLER MODIFIER --
-----------------------------

modifier_imba_wisp_tether_handler = class({})

function modifier_imba_wisp_tether_handler:IsHidden() return true end

function modifier_imba_wisp_tether_handler:IsPurgable() return false end

function modifier_imba_wisp_tether_handler:RemoveOnDeath() return false end

function modifier_imba_wisp_tether_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_wisp_tether_handler:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_ORDER }

	return decFuncs
end

function modifier_imba_wisp_tether_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-----------------------------
-- TETHER BACKPACK MODIFIER --
-----------------------------

modifier_imba_wisp_tether_backpack = class({})

function modifier_imba_wisp_tether_backpack:IsPurgable() return false end

function modifier_imba_wisp_tether_backpack:OnCreated()
	if not IsServer() then return end

	self.backpack_distance = self:GetAbility():GetSpecialValueFor("backpack_distance")

	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * self.backpack_distance * (-1)))

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_wisp_tether_backpack:OnIntervalThink()
	if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsRooted() or self:GetParent():IsOutOfGame() then
		self:Destroy()
		return
	end

	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * self.backpack_distance * (-1)))
end

function modifier_imba_wisp_tether_backpack:OnDestroy()
	if not IsServer() then return end

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

------------------------------
--			SPIRITS			--
------------------------------
imba_wisp_spirits = class({})
LinkLuaModifier("modifier_imba_wisp_spirits", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_hero_hit", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_creep_hit", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_slow", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirit_damage_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_spirits_true_sight", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_spirits:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_wisp_10", "cdr_mult"), 1)
end

function imba_wisp_spirits:OnSpellStart()
	if IsServer() then
		self.caster                  = self:GetCaster()
		self.ability                 = self.caster:FindAbilityByName("imba_wisp_spirits")
		self.start_time              = GameRules:GetGameTime()
		self.spirits_num_spirits     = 0
		local spirit_min_radius      = self.ability:GetSpecialValueFor("min_range")
		local spirit_max_radius      = self.ability:GetSpecialValueFor("max_range")
		local spirit_movement_rate   = self.ability:GetSpecialValueFor("spirit_movement_rate")
		local creep_damage           = self.ability:GetSpecialValueFor("creep_damage")
		local explosion_damage       = self.ability:GetTalentSpecialValueFor("explosion_damage")
		local slow                   = self.ability:GetSpecialValueFor("slow")
		local spirit_duration        = self.ability:GetSpecialValueFor("spirit_duration")
		local spirit_summon_interval = self.ability:GetSpecialValueFor("spirit_summon_interval")
		local max_spirits            = self.ability:GetSpecialValueFor("num_spirits")
		local collision_radius       = self.ability:GetSpecialValueFor("collision_radius")
		local explosion_radius       = self.ability:GetSpecialValueFor("explode_radius")
		local spirit_turn_rate       = self.ability:GetSpecialValueFor("spirit_turn_rate")
		local vision_radius          = self.ability:GetSpecialValueFor("explode_radius")
		local vision_duration        = self.ability:GetSpecialValueFor("vision_duration")
		local slow_duration          = self.ability:GetSpecialValueFor("slow_duration")
		local damage_interval        = self.ability:GetSpecialValueFor("damage_interval")

		-- Large Hadron Collider talent
		if self.caster:HasTalent("special_bonus_imba_wisp_10") then
			spirit_movement_rate   = spirit_movement_rate * math.max(self.caster:FindTalentValue("special_bonus_imba_wisp_10"), 1)
			spirit_summon_interval = spirit_summon_interval / math.max(self.caster:FindTalentValue("special_bonus_imba_wisp_10"), 1)
			max_spirits            = max_spirits * math.max(self.caster:FindTalentValue("special_bonus_imba_wisp_10"), 1)
			spirit_turn_rate       = spirit_turn_rate * math.max(self.caster:FindTalentValue("special_bonus_imba_wisp_10"), 1)
		end

		self.spirits_movementFactor         = 1
		self.ability.spirits_spiritsSpawned = {}

		EmitSoundOn("Hero_Wisp.Spirits.Cast", self.caster)

		-- Exception for naughty Morphlings...
		if self.caster:HasModifier("modifier_imba_wisp_spirits") then
			self.caster:RemoveModifierByName("modifier_imba_wisp_spirits")
		end

		-- Let's manually add Toggle Spirits for Rubick and Morphling so they can use the skill properly
		if not self.caster:HasAbility("imba_wisp_spirits_toggle") then
			self.caster:AddAbility("imba_wisp_spirits_toggle")
		end

		self.caster:SwapAbilities("imba_wisp_spirits", "imba_wisp_spirits_toggle", false, true)
		self.caster:FindAbilityByName("imba_wisp_spirits_toggle"):SetLevel(1)
		self.caster:AddNewModifier(
			self.caster,
			self.ability,
			"modifier_imba_wisp_spirits",
			{
				duration               = spirit_duration,
				spirits_starttime      = GameRules:GetGameTime(),
				spirit_summon_interval = spirit_summon_interval,
				max_spirits            = max_spirits,
				collision_radius       = collision_radius,
				explosion_radius       = explosion_radius,
				spirit_min_radius      = spirit_min_radius,
				spirit_max_radius      = spirit_max_radius,
				spirit_movement_rate   = spirit_movement_rate,
				spirit_turn_rate       = spirit_turn_rate,
				vision_radius          = vision_radius,
				vision_duration        = vision_duration,
				creep_damage           = creep_damage,
				explosion_damage       = explosion_damage,
				slow_duration          = slow_duration,
				slow                   = slow
			})

		self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_wisp_spirit_damage_handler", { duration = -1, damage_interval = damage_interval })
	end
end

-- Remove Toggle Spirits for Rubick and Morphling when skill is lost
function imba_wisp_spirits:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_spirits_toggle") then
		self:GetCaster():RemoveAbility("imba_wisp_spirits_toggle")
	end
end

modifier_imba_wisp_spirit_damage_handler = class({})
function modifier_imba_wisp_spirit_damage_handler:IsHidden() return true end

function modifier_imba_wisp_spirit_damage_handler:IsPurgable() return false end

function modifier_imba_wisp_spirit_damage_handler:OnCreated(params)
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		self:StartIntervalThink(params.damage_interval)
	end
end

function modifier_imba_wisp_spirit_damage_handler:OnIntervalThink()
	if IsServer() then
		self.ability.hit_table = {}
	end
end

------------------------------
--		SPIRITS	modifier	--
------------------------------
modifier_imba_wisp_spirits = class({})
function modifier_imba_wisp_spirits:OnCreated(params)
	if IsServer() then
		self.start_time                = params.spirits_starttime
		self.spirit_summon_interval    = params.spirit_summon_interval
		self.max_spirits               = params.max_spirits
		self.collision_radius          = params.collision_radius
		self.explosion_radius          = params.explosion_radius
		self.spirit_radius             = params.collision_radius
		self.spirit_min_radius         = params.spirit_min_radius
		self.spirit_max_radius         = params.spirit_max_radius
		self.spirit_movement_rate      = params.spirit_movement_rate
		self.spirit_turn_rate          = params.spirit_turn_rate
		self.vision_radius             = params.vision_radius
		self.vision_duration           = params.vision_duration
		self.creep_damage              = params.creep_damage
		self.explosion_damage          = params.explosion_damage
		self.slow_duration             = params.slow_duration
		self.slow                      = params.slow

		-- timers for tracking update of FX
		self:GetAbility().update_timer = 0
		self.time_to_update            = 0.5

		EmitSoundOn("Hero_Wisp.Spirits.Loop", self:GetCaster())

		self:StartIntervalThink(0.03)
	end
end

function modifier_imba_wisp_spirits:OnIntervalThink()
	if IsServer() then
		local caster                 = self:GetCaster()
		local caster_position        = caster:GetAbsOrigin()
		local ability                = self:GetAbility()
		local elapsedTime            = GameRules:GetGameTime() - self.start_time
		local idealNumSpiritsSpawned = elapsedTime / self.spirit_summon_interval

		-- add time to update timer
		ability.update_timer         = ability.update_timer + FrameTime()


		idealNumSpiritsSpawned = math.min(idealNumSpiritsSpawned, self.max_spirits)

		if ability.spirits_num_spirits < idealNumSpiritsSpawned then
			-- Spawn a new spirit
			local newSpirit = CreateUnitByName("npc_dota_wisp_spirit", caster_position, false, caster, caster, caster:GetTeam())

			-- Create particle FX
			local pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, newSpirit)
			if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_disarm_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
				newSpirit.spirit_pfx_disarm = pfx
			elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_silence_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit)
				newSpirit.spirit_pfx_silence = pfx
			else -- Just for Rubick...since he's not stealing the silence/disarm skill right now
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit, caster)
				newSpirit.spirit_pfx_silence = pfx
			end

			if caster:HasTalent("special_bonus_imba_wisp_3") then
				self.true_sight_radius = caster:FindTalentValue("special_bonus_imba_wisp_3", "true_sight_radius")
				local true_sight_aura = newSpirit:AddNewModifier(caster, self, "modifier_imba_wisp_spirits_true_sight", {})
				true_sight_aura:SetStackCount(self.true_sight_radius)
				newSpirit:SetDayTimeVisionRange(self.true_sight_radius)
				newSpirit:SetNightTimeVisionRange(self.true_sight_radius)
			end

			-- Update the state
			local spiritIndex = ability.spirits_num_spirits + 1
			newSpirit.spirit_index = spiritIndex
			ability.spirits_num_spirits = spiritIndex
			ability.spirits_spiritsSpawned[spiritIndex] = newSpirit

			-- Apply the spirit modifier
			newSpirit:AddNewModifier(
				caster,
				ability,
				"modifier_imba_wisp_spirit_handler",
				{
					duraiton         = -1,
					vision_radius    = self.vision_radius,
					vision_duration  = self.vision_duration,
					tinkerval        = 360 / self.spirit_turn_rate / self.max_spirits,
					collision_radius = self.collision_radius,
					explosion_radius = self.explosion_radius,
					creep_damage     = self.creep_damage,
					explosion_damage = self.explosion_damage,
					slow_duration    = self.slow_duration,
					slow             = self.slow
				}
			)
		end

		--------------------------------------------------------------------------------
		-- Update the radius
		--------------------------------------------------------------------------------
		local currentRadius        = self.spirit_radius
		local deltaRadius          = ability.spirits_movementFactor * self.spirit_movement_rate * 0.03
		currentRadius              = currentRadius + deltaRadius
		currentRadius              = math.min(math.max(currentRadius, self.spirit_min_radius), self.spirit_max_radius)
		self.spirit_radius         = currentRadius

		--------------------------------------------------------------------------------
		-- Update the spirits' positions
		--------------------------------------------------------------------------------
		local currentRotationAngle = elapsedTime * self.spirit_turn_rate
		local rotationAngleOffset  = 360 / self.max_spirits
		local numSpiritsAlive      = 0

		for k, spirit in pairs(ability.spirits_spiritsSpawned) do
			if not spirit:IsNull() then
				numSpiritsAlive     = numSpiritsAlive + 1

				-- Rotate
				local rotationAngle = currentRotationAngle - rotationAngleOffset * (k - 1)
				local relPos        = Vector(0, currentRadius, 0)
				relPos              = RotatePosition(Vector(0, 0, 0), QAngle(0, -rotationAngle, 0), relPos)
				local absPos        = GetGroundPosition(relPos + caster_position, spirit)

				spirit:SetAbsOrigin(absPos)

				-- Update particle... switch particle depending on currently active effect.
				-- the dealy is needed since it takes 0.3s for spirits to fade in.
				if ability.update_timer > self.time_to_update then
					if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
						if spirit.spirit_pfx_silence ~= nil then
							ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
						end
					elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
						if spirit.spirit_pfx_disarm ~= nil then
							ParticleManager:DestroyParticle(spirit.spirit_pfx_disarm, true)
						end
					end
				end

				if spirit.spirit_pfx_silence ~= nil then
					spirit.currentRadius = Vector(currentRadius, 0, 0)
					ParticleManager:SetParticleControl(spirit.spirit_pfx_silence, 1, Vector(currentRadius, 0, 0))
				end

				if spirit.spirit_pfx_disarm ~= nil then
					spirit.currentRadius = Vector(currentRadius, 0, 0)
					ParticleManager:SetParticleControl(spirit.spirit_pfx_disarm, 1, Vector(currentRadius, 0, 0))
				end
			end
		end

		if ability.update_timer > self.time_to_update then
			ability.update_timer = 0
		end

		if ability.spirits_num_spirits == self.max_spirits and numSpiritsAlive == 0 then
			-- All spirits have been exploded.
			caster:RemoveModifierByName("modifier_imba_wisp_spirits")
			return
		end
	end
end

function modifier_imba_wisp_spirits:Explode(caster, spirit, explosion_radius, explosion_damage, ability)
	if IsServer() then
		EmitSoundOn("Hero_Wisp.Spirits.Target", spirit)
		ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, spirit, caster)

		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			caster:GetTeam(),
			spirit:GetAbsOrigin(),
			nil,
			explosion_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		local damage_table       = {}
		damage_table.attacker    = caster
		damage_table.ability     = ability
		damage_table.damage_type = ability:GetAbilityDamageType()
		damage_table.damage      = explosion_damage

		-- Deal damage to each enemy hero
		for _, enemy in pairs(nearby_enemy_units) do
			if enemy ~= nil then
				damage_table.victim = enemy

				ApplyDamage(damage_table)
			end
		end

		-- Let's just have another one here for Rubick to "properly" destroy Spirit particles
		if spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
			ParticleManager:ReleaseParticleIndex(spirit.spirit_pfx_silence)
		end

		ability.spirits_spiritsSpawned[spirit.spirit_index] = nil
	end
end

function modifier_imba_wisp_spirits:OnRemoved()
	if IsServer() then
		self:GetCaster():SwapAbilities("imba_wisp_spirits_toggle", "imba_wisp_spirits", false, true)
		local ability = self:GetAbility()
		local caster  = self:GetCaster()
		for k, spirit in pairs(ability.spirits_spiritsSpawned) do
			if not spirit:IsNull() then
				spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
			end
		end

		self:GetCaster():StopSound("Hero_Wisp.Spirits.Loop")
	end
end

-- not required
--[[
function modifier_imba_wisp_spirits:GetTexture()
	if self:GetAbility().spirits_movementFactor == 1 then
		return "kunnka_tide_red"
	else
		return "kunnka_tide_high"
	end
end
--]]
----------------------------------------------------------------------
--		SPIRITS	true_sight modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_true_sight = class({})
function modifier_imba_wisp_spirits_true_sight:IsAura()
	return true
end

function modifier_imba_wisp_spirits_true_sight:IsHidden()
	return true
end

function modifier_imba_wisp_spirits_true_sight:IsPurgable()
	return false
end

function modifier_imba_wisp_spirits_true_sight:GetAuraRadius()
	return self:GetStackCount()
end

function modifier_imba_wisp_spirits_true_sight:GetModifierAura()
	return "modifier_truesight"
end

function modifier_imba_wisp_spirits_true_sight:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_wisp_spirits_true_sight:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_wisp_spirits_true_sight:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER
end

function modifier_imba_wisp_spirits_true_sight:GetAuraDuration()
	return 0.5
end

----------------------------------------------------------------------
--		SPIRITS	on creep hit modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_creep_hit = class({})
function modifier_imba_wisp_spirits_creep_hit:IsHidden() return true end

function modifier_imba_wisp_spirits_creep_hit:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, self:GetCaster())
	end
end

function modifier_imba_wisp_spirits_creep_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end

----------------------------------------------------------------------
--		SPIRITS	on hero hit modifier 								--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_hero_hit = class({})
function modifier_imba_wisp_spirits_hero_hit:IsHidden() return true end

function modifier_imba_wisp_spirits_hero_hit:OnCreated(params)
	if IsServer() then
		local target = self:GetParent()
		local slow_modifier = target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_wisp_spirits_slow", { duration = params.slow_duration * (1 - target:GetStatusResistance()) })
		slow_modifier:SetStackCount(params.slow)
	end
end

----------------------------------------------------------------------
--		SPIRITS	on hero hit slow modifier							--
----------------------------------------------------------------------
modifier_imba_wisp_spirits_slow = class({})
function modifier_imba_wisp_spirits_slow:IsDebuff() return true end

function modifier_imba_wisp_spirits_slow:IsHidden() return true end

function modifier_imba_wisp_spirits_slow:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
	return funcs
end

function modifier_imba_wisp_spirits_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

function modifier_imba_wisp_spirits_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end

----------------------------------------------------------------------
--		SPIRITS	modifier (keep them from getting targeted)			--
----------------------------------------------------------------------
modifier_imba_wisp_spirit_handler = class({})
function modifier_imba_wisp_spirit_handler:CheckState()
	local state = {
		[MODIFIER_STATE_NO_TEAM_MOVE_TO]    = true,
		[MODIFIER_STATE_NO_TEAM_SELECT]     = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE]      = true,
		[MODIFIER_STATE_MAGIC_IMMUNE]       = true,
		[MODIFIER_STATE_INVULNERABLE]       = true,
		[MODIFIER_STATE_UNSELECTABLE]       = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]     = true,
		[MODIFIER_STATE_NO_HEALTH_BAR]      = true,
	}

	return state
end

function modifier_imba_wisp_spirit_handler:OnCreated(params)
	if IsServer() then
		self.caster            = self:GetCaster()
		self.ability           = self:GetAbility()
		self.vision_radius     = params.vision_radius
		self.vision_duration   = params.vision_duration
		self.tinkerval         = params.tinkerval
		self.collision_radius  = params.collision_radius
		self.explosion_radius  = params.explosion_radius
		self.creep_damage      = params.creep_damage
		self.explosion_damage  = params.explosion_damage
		self.slow_duration     = params.slow_duration
		self.slow              = params.slow

		-- dmg timer and hittable
		self.damage_interval   = 0.10
		self.damage_timer      = 0
		self.ability.hit_table = {}

		self:StartIntervalThink(self.damage_interval)
	end
end

function modifier_imba_wisp_spirit_handler:OnIntervalThink()
	if IsServer() then
		local spirit = self:GetParent()
		-- Check if we hit stuff
		local nearby_enemy_units = FindUnitsInRadius(
			self.caster:GetTeam(),
			spirit:GetAbsOrigin(),
			nil,
			self.collision_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		spirit.hit_table = self.ability.hit_table
		if nearby_enemy_units ~= nil and #nearby_enemy_units > 0 then
			modifier_imba_wisp_spirit_handler:OnHit(self.caster, spirit, nearby_enemy_units, self.creep_damage, self.ability, self.slow_duration, self.slow)
		end
	end
end

function modifier_imba_wisp_spirit_handler:OnHit(caster, spirit, enemies_hit, creep_damage, ability, slow_duration, slow)
	local hit_hero           = false
	-- Initialize damage table
	local damage_table       = {}
	damage_table.attacker    = caster
	damage_table.ability     = ability
	damage_table.damage_type = ability:GetAbilityDamageType()

	-- Deal damage to each enemy hero
	for _, enemy in pairs(enemies_hit) do
		-- cant dmg ded stuff + cant dmg if ded
		if enemy:IsAlive() and not spirit:IsNull() then
			local hit = false

			damage_table.victim = enemy

			if enemy:IsConsideredHero() and not enemy:IsIllusion() then
				enemy:AddNewModifier(caster, ability, "modifier_imba_wisp_spirits_hero_hit", { duration = 0.03, slow_duration = slow_duration, slow = slow })
				if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
					enemy:AddNewModifier(caster, ability, "modifier_disarmed", { duration = ability:GetSpecialValueFor("spirit_debuff_duration") * (1 - enemy:GetStatusResistance()) })
				elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
					enemy:AddNewModifier(caster, ability, "modifier_silence", { duration = ability:GetSpecialValueFor("spirit_debuff_duration") * (1 - enemy:GetStatusResistance()) })
				end

				hit_hero = true
				--hit = true
			else
				if spirit.hit_table[enemy] == nil then
					spirit.hit_table[enemy] = true
					enemy:AddNewModifier(caster, ability, "modifier_imba_wisp_spirits_creep_hit", { duration = 0.03 })
					damage_table.damage = creep_damage
					hit = true
				end
			end

			if hit then
				ApplyDamage(damage_table)
			end
		end
	end

	if hit_hero then
		spirit:RemoveModifierByName("modifier_imba_wisp_spirit_handler")
	end
end

function modifier_imba_wisp_spirit_handler:OnRemoved()
	if IsServer() then
		local spirit = self:GetParent()
		local ability = self:GetAbility()

		modifier_imba_wisp_spirits:Explode(self.caster, spirit, self.explosion_radius, self.explosion_damage, ability)

		if spirit.spirit_pfx_silence ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_silence, true)
		end

		if spirit.spirit_pfx_disarm ~= nil then
			ParticleManager:DestroyParticle(spirit.spirit_pfx_disarm, true)
		end

		-- Create vision
		ability:CreateVisibilityNode(spirit:GetAbsOrigin(), self.vision_radius, self.vision_duration)

		-- Kill
		spirit:ForceKill(true)
	end
end

--------------------------------------
--		SPIRITS	TOGGLE	Near/Far	--
--------------------------------------
imba_wisp_spirits_toggle = class({})

function imba_wisp_spirits_toggle:IsStealable() return false end

function imba_wisp_spirits_toggle:ProcsMagicStick() return false end

function imba_wisp_spirits_toggle:OnSpellStart()
	if IsServer() then
		-- Let's manually add Spirits for Morphling so they can use the skill properly (super bootleg)
		if not self:GetCaster():HasAbility("imba_wisp_spirits") then
			local stolenAbility = self:GetCaster():AddAbility("imba_wisp_spirits")
			stolenAbility:SetLevel(min((self:GetCaster():GetLevel() / 2) - 1, 4))
			self:GetCaster():SwapAbilities("imba_wisp_spirits_toggle", "imba_wisp_spirits", false, true)
		end

		local caster                 = self:GetCaster()
		local ability                = caster:FindAbilityByName("imba_wisp_spirits")
		local spirits_movementFactor = ability.spirits_movementFactor

		if ability.spirits_movementFactor == 1 then
			ability.spirits_movementFactor = -1
		else
			ability.spirits_movementFactor = 1
		end
	end
end

-- ugh
function imba_wisp_spirits_toggle:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_spirits") then
		self:GetCaster():RemoveAbility("imba_wisp_spirits")
	end
end

------------------------------------------
--		SPIRITS	Swap silence/disarm		--
------------------------------------------
LinkLuaModifier("modifier_imba_wisp_swap_spirits_disarm", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_swap_spirits_silence", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
imba_wisp_swap_spirits = class({})

function imba_wisp_swap_spirits:IsInnateAbility() return true end

function imba_wisp_swap_spirits:IsStealable() return false end

function imba_wisp_swap_spirits:GetIntrinsicModifierName()
	return "modifier_imba_wisp_swap_spirits_silence"
end

function imba_wisp_swap_spirits:GetIntrinsicModifierName()
	return "modifier_imba_wisp_swap_spirits_silence"
end

function imba_wisp_swap_spirits:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_wisp_swap_spirits_silence") then
		return "wisp_swap_spirits_silence"
	elseif self:GetCaster():HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
		return "wisp_swap_spirits_disarm"
	end
end

function imba_wisp_swap_spirits:OnSpellStart()
	if IsServer() then
		local caster   = self:GetCaster()
		local ability  = caster:FindAbilityByName("imba_wisp_spirits")
		--local spirits_movementFactor 	= ability.spirits_movementFactor
		local particle = nil
		local silence  = false
		local disarm   = false

		if not self.particles then
			self.particles = {}
		end

		if caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
			caster:RemoveModifierByName("modifier_imba_wisp_swap_spirits_disarm")
			caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_swap_spirits_silence", {})
		elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
			caster:RemoveModifierByName("modifier_imba_wisp_swap_spirits_silence")
			caster:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_swap_spirits_disarm", {})
		end

		if caster:HasModifier("modifier_imba_wisp_swap_spirits_silence") then
			particle = "particles/units/heroes/hero_wisp/wisp_guardian_silence_a.vpcf"
			silence  = true
			disarm   = false
		elseif caster:HasModifier("modifier_imba_wisp_swap_spirits_disarm") then
			particle = "particles/units/heroes/hero_wisp/wisp_guardian_disarm_a.vpcf"
			silence  = false
			disarm   = true
		end

		if ability.spirits_spiritsSpawned then
			for k, spirit in pairs(ability.spirits_spiritsSpawned) do
				if not spirit:IsNull() then
					if self.particles[k] then
						ParticleManager:DestroyParticle(self.particles[k], false)
						ParticleManager:ReleaseParticleIndex(self.particles[k])
					end

					self.particles[k] = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, spirit)
					if silence then
						spirit.spirit_pfx_silence = self.particles[k]
					elseif disarm then
						spirit.spirit_pfx_disarm = self.particles[k]
					end
				end
			end
		end
	end
end

modifier_imba_wisp_swap_spirits_disarm = class({})

function modifier_imba_wisp_swap_spirits_disarm:IsHidden() return true end

function modifier_imba_wisp_swap_spirits_disarm:IsPurgable() return false end

function modifier_imba_wisp_swap_spirits_disarm:RemoveOnDeath() return false end

modifier_imba_wisp_swap_spirits_silence = class({})

function modifier_imba_wisp_swap_spirits_silence:IsHidden() return true end

function modifier_imba_wisp_swap_spirits_silence:IsPurgable() return false end

function modifier_imba_wisp_swap_spirits_silence:RemoveOnDeath() return false end

------------------------------
--		OVERCHARGE		--
------------------------------
imba_wisp_overcharge = class({})
LinkLuaModifier("modifier_imba_wisp_overcharge", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_drain", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_regen_talent", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_aura", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_overcharge:IsNetherWardStealable()
	return false
end

function imba_wisp_overcharge:AddOvercharge(caster, target, efficiency, overcharge_duration)
	local ability             = caster:FindAbilityByName("imba_wisp_overcharge")
	local tether_ability      = caster:FindAbilityByName("imba_wisp_tether")

	local bonus_attack_speed  = ability:GetSpecialValueFor("bonus_attack_speed")
	local bonus_cast_speed    = ability:GetSpecialValueFor("bonus_cast_speed")
	local bonus_missile_speed = ability:GetSpecialValueFor("bonus_missile_speed")
	local bonus_damage_pct    = ability:GetSpecialValueFor("bonus_damage_pct")
	local bonus_attack_range  = ability:GetSpecialValueFor("bonus_attack_range")

	if caster:HasTalent("special_bonus_imba_wisp_1") then
		local bonus_effect  = caster:FindTalentValue("special_bonus_imba_wisp_1")
		bonus_attack_speed  = bonus_attack_speed + bonus_effect
		bonus_cast_speed    = bonus_cast_speed
		bonus_missile_speed = bonus_missile_speed + bonus_effect
		bonus_attack_range  = bonus_attack_range + bonus_effect
	end

	if caster:HasTalent("special_bonus_imba_wisp_4") then
		local damage_reduction = caster:FindTalentValue("special_bonus_imba_wisp_4")
		bonus_damage_pct       = bonus_damage_pct - damage_reduction
	end

	if caster:HasTalent("special_bonus_imba_wisp_8") and efficiency == 1.0 then
		local bonus_regen      = caster:FindTalentValue("special_bonus_imba_wisp_8", "bonus_regen")
		local overcharge_regen = caster:AddNewModifier(caster, ability, "modifier_imba_wisp_overcharge_regen_talent", {})
		overcharge_regen:SetStackCount(bonus_regen)
	end

	if efficiency ~= nil and efficiency < 1.0 then
		bonus_attack_speed  = bonus_attack_speed * efficiency
		bonus_cast_speed    = bonus_cast_speed * efficiency
		bonus_missile_speed = bonus_missile_speed * efficiency
		bonus_attack_range  = bonus_attack_range * efficiency
		bonus_damage_pct    = bonus_damage_pct * efficiency
	end

	-- set stats for client
	CustomNetTables:SetTableValue(
		"player_table",
		tostring(caster:GetPlayerOwnerID()),
		{
			overcharge_bonus_attack_speed  = bonus_attack_speed,
			overcharge_bonus_cast_speed    = bonus_cast_speed,
			overcharge_bonus_missile_speed = bonus_missile_speed,
			overcharge_bonus_damage_pct    = bonus_damage_pct,
			overcharge_bonus_attack_range  = bonus_attack_range,
		})

	target:AddNewModifier(
		caster,
		ability,
		"modifier_imba_wisp_overcharge",
		{
			duration            = overcharge_duration,
			bonus_attack_speed  = bonus_attack_speed,
			bonus_cast_speed    = bonus_cast_speed,
			bonus_missile_speed = bonus_missile_speed,
			bonus_damage_pct    = bonus_damage_pct,
			bonus_attack_range  = bonus_attack_range,
		})
end

function imba_wisp_overcharge:OnToggle()
	if IsServer() then
		local caster         = self:GetCaster()
		local ability        = caster:FindAbilityByName("imba_wisp_overcharge")
		local tether_ability = caster:FindAbilityByName("imba_wisp_tether")

		if ability:GetToggleState() then
			EmitSoundOn("Hero_Wisp.Overcharge", caster)

			local drain_interval = ability:GetSpecialValueFor("drain_interval")
			local drain_pct      = ability:GetSpecialValueFor("drain_pct")

			imba_wisp_overcharge:AddOvercharge(caster, caster, 1.0, -1)

			if caster:HasModifier("modifier_imba_wisp_tether") then
				if tether_ability.target:HasModifier("modifier_imba_wisp_overcharge") then
					tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
				end

				imba_wisp_overcharge:AddOvercharge(caster, tether_ability.target, 1.0, -1)
			end

			if caster:HasScepter() then
				caster:AddNewModifier(caster, ability, "modifier_imba_wisp_overcharge_aura", {})
			end

			drain_pct = drain_pct / 100
			caster:AddNewModifier(caster, ability, "modifier_imba_wisp_overcharge_drain", { duration = -1, drain_interval = drain_interval, drain_pct = drain_pct })
		else
			caster:StopSound("Hero_Wisp.Overcharge")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_drain")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_regen_talent")
			caster:RemoveModifierByName("modifier_imba_wisp_overcharge_aura")

			if caster:HasModifier("modifier_imba_wisp_tether") then
				tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge")
				tether_ability.target:RemoveModifierByName("modifier_imba_wisp_overcharge_regen_talent")
			end
		end
	end
end

----------------------------------
--	Overchargge Aura modifier	--
----------------------------------
modifier_imba_wisp_overcharge_aura = class({})
function modifier_imba_wisp_overcharge_aura:IsHidden() return false end

function modifier_imba_wisp_overcharge_aura:IsPurgable() return false end

function modifier_imba_wisp_overcharge_aura:IsNetherWardStealable()
	return false
end

function modifier_imba_wisp_overcharge_aura:OnCreated()
	if IsServer() then
		self.ability            = self:GetAbility()
		self.tether_ability     = self:GetCaster():FindAbilityByName("imba_wisp_tether")
		self.scepter_radius     = self.ability:GetSpecialValueFor("scepter_radius")
		self.scepter_efficiency = self.ability:GetSpecialValueFor("scepter_efficiency")

		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_wisp_overcharge_aura:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local nearby_friendly_units = FindUnitsInRadius(
			caster:GetTeam(),
			caster:GetAbsOrigin(),
			nil,
			self.scepter_radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			FIND_ANY_ORDER,
			false)

		for _, unit in pairs(nearby_friendly_units) do
			if unit ~= caster and unit ~= self.tether_ability.target and unit ~= "npc_dota_hero" then
				imba_wisp_overcharge:AddOvercharge(caster, unit, self.scepter_efficiency, 1)
			end
		end
	end
end

----------------------------------
--	Overchargge buff modifier	--
----------------------------------
modifier_imba_wisp_overcharge = class({})
function modifier_imba_wisp_overcharge:IsBuff() return true end

function modifier_imba_wisp_overcharge:IsPurgable() return false end

function modifier_imba_wisp_overcharge:IsNetherWardStealable() return false end

function modifier_imba_wisp_overcharge:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end

function modifier_imba_wisp_overcharge:OnCreated(params)
	if IsServer() then
		self.overcharge_pfx      = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster())
		self.bonus_attack_speed  = params.bonus_attack_speed
		self.bonus_cast_speed    = params.bonus_cast_speed
		self.bonus_missile_speed = params.bonus_missile_speed
		self.bonus_damage_pct    = params.bonus_damage_pct
		self.bonus_attack_range  = params.bonus_attack_range
	else
		local net_table          = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
		self.bonus_attack_speed  = net_table.overcharge_bonus_attack_speed or 0
		self.bonus_cast_speed    = net_table.overcharge_bonus_cast_speed or 0
		self.bonus_missile_speed = net_table.overcharge_bonus_missile_speed or 0
		self.bonus_damage_pct    = net_table.overcharge_bonus_damage_pct or 0
		self.bonus_attack_range  = net_table.overcharge_bonus_attack_range or 0
	end
end

function modifier_imba_wisp_overcharge:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.overcharge_pfx, false)
		if not self:GetCaster():HasModifier("modifier_imba_wisp_overcharge") then
			self:GetCaster():RemoveModifierByName("modifier_imba_wisp_overcharge_drain")
		end
	end
end

function modifier_imba_wisp_overcharge:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_imba_wisp_overcharge:GetModifierPercentageCasttime()
	return self.bonus_cast_speed
end

function modifier_imba_wisp_overcharge:GetModifierProjectileSpeedBonus()
	return self.bonus_missile_speed
end

function modifier_imba_wisp_overcharge:GetModifierIncomingDamage_Percentage()
	return self.bonus_damage_pct
end

-- function modifier_imba_wisp_overcharge:GetModifierAttackRangeBonus()
-- return self.bonus_attack_range
-- end

----------------------------------------------
--	Overchargge health/mana-drain modifier	--
----------------------------------------------
modifier_imba_wisp_overcharge_drain = class({})
function modifier_imba_wisp_overcharge_drain:IsHidden() return true end

function modifier_imba_wisp_overcharge_drain:IsPurgable() return false end

function modifier_imba_wisp_overcharge_drain:OnCreated(params)
	if IsServer() then
		self.caster         = self:GetCaster()
		self.ability        = self:GetAbility()
		self.drain_pct      = params.drain_pct
		self.drain_interval = params.drain_interval
		self.deltaDrainPct  = self.drain_interval * self.drain_pct
		self:StartIntervalThink(self.drain_interval)
	end
end

function modifier_imba_wisp_overcharge_drain:OnIntervalThink()
	-- hp removal instead of self dmg... this wont break urn or salve
	local current_health = self.caster:GetHealth()
	local health_drain   = current_health * self.deltaDrainPct
	self.caster:ModifyHealth(current_health - health_drain, self.ability, true, 0)

	self.caster:SpendMana(self.caster:GetMana() * self.deltaDrainPct, self.ability)
end

------------------------------
--	Overcharge Talent	    --
------------------------------
modifier_imba_wisp_overcharge_regen_talent = class({})
function modifier_imba_wisp_overcharge_regen_talent:IsHidden() return true end

function modifier_imba_wisp_overcharge_regen_talent:IsPurgable() return false end

function modifier_imba_wisp_overcharge_regen_talent:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}

	return decFuncs
end

function modifier_imba_wisp_overcharge_regen_talent:GetModifierTotalPercentageManaRegen()
	return self:GetStackCount()
end

------------------------------
--			RELOCATE		--
------------------------------
imba_wisp_relocate = class({})
LinkLuaModifier("modifier_imba_wisp_relocate", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_relocate_cast_delay", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_relocate_talent", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

function imba_wisp_relocate:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_wisp_9")
end

function imba_wisp_relocate:GetBehavior()
	if IsServer() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET
	end
end

function imba_wisp_relocate:OnSpellStart()
	if IsServer() then
		local unit                 = self:GetCursorTarget()
		local tether_ability       = self:GetCaster():FindAbilityByName("imba_wisp_tether")
		self.relocate_target_point = self:GetCursorPosition()
		local vision_radius        = self:GetSpecialValueFor("vision_radius")
		local cast_delay           = self:GetSpecialValueFor("cast_delay")
		local return_time          = self:GetSpecialValueFor("return_time")
		local destroy_tree_radius  = self:GetSpecialValueFor("destroy_tree_radius")

		EmitSoundOn("Hero_Wisp.Relocate", self:GetCaster())

		if unit == self:GetCaster() then
			if self:GetCaster():GetTeam() == DOTA_TEAM_GOODGUYS then
				-- radiant fountain location
				self.relocate_target_point = Vector(-7168, -6646, 528)
			else
				-- dire fountain location
				self.relocate_target_point = Vector(7037, 6458, 512)
			end
		end

		local channel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
		ParticleManager:SetParticleControl(channel_pfx, 0, self:GetCaster():GetAbsOrigin())

		local endpoint_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf", PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster())
		ParticleManager:SetParticleControl(endpoint_pfx, 0, self.relocate_target_point)

		-- Create vision
		self:CreateVisibilityNode(self.relocate_target_point, vision_radius, cast_delay)

		if self:GetCaster():HasTalent("special_bonus_imba_wisp_7") then
			local immunity_duration = self:GetCaster():FindTalentValue("special_bonus_imba_wisp_7", "duration")
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_relocate_talent", { duration = immunity_duration })
			if tether_ability.target ~= nil then
				tether_ability.target:AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_relocate_talent", { duration = immunity_duration })
			end
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_relocate_cast_delay", { duration = cast_delay })

		Timers:CreateTimer({
			endTime = cast_delay,
			callback = function()
				ParticleManager:DestroyParticle(channel_pfx, false)
				ParticleManager:DestroyParticle(endpoint_pfx, false)

				if not imba_wisp_relocate:InterruptRelocate(self:GetCaster(), self, tether_ability) then
					EmitSoundOn("Hero_Wisp.Return", self:GetCaster())
					EmitSoundOn("Hero_Wisp.ReturnCounter", self:GetCaster())

					GridNav:DestroyTreesAroundPoint(self.relocate_target_point, destroy_tree_radius, false)

					-- Here we go again (Rubick)
					if not self:GetCaster():HasAbility("imba_wisp_relocate_break") then
						self:GetCaster():AddAbility("imba_wisp_relocate_break")
					end

					self:GetCaster():SwapAbilities("imba_wisp_relocate", "imba_wisp_relocate_break", false, true)
					local break_ability = self:GetCaster():FindAbilityByName("imba_wisp_relocate_break")
					break_ability:SetLevel(1)

					if self:GetCaster():HasModifier("modifier_imba_wisp_tether") and tether_ability.target:IsHero() then
						self.ally = tether_ability.target
					else
						self.ally = nil
					end

					self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_relocate", { duration = return_time, return_time = return_time })
				end
			end
		})
	end
end

function imba_wisp_relocate:InterruptRelocate(caster, ability, tether_ability)
	if not caster:IsAlive() or caster:IsStunned() or caster:IsHexed() or caster:IsNightmared() or caster:IsOutOfGame() or caster:IsRooted() then
		return true
	end

	return false
end

-- Remove Relocate Break for Rubick when skill is lost
function imba_wisp_relocate:OnUnStolen()
	if self:GetCaster():HasAbility("imba_wisp_relocate_break") then
		self:GetCaster():RemoveAbility("imba_wisp_relocate_break")
	end
end

----------------------
--	Relocate timer	--
----------------------
modifier_imba_wisp_relocate_cast_delay = class({})


--------------------------
--	Relocate modifier	--
--------------------------
modifier_imba_wisp_relocate = class({})
function modifier_imba_wisp_relocate:IsDebuff() return false end

function modifier_imba_wisp_relocate:IsHidden() return false end

function modifier_imba_wisp_relocate:IsPurgable() return false end

function modifier_imba_wisp_relocate:IsStunDebuff() return false end

function modifier_imba_wisp_relocate:IsPurgeException() return false end

function modifier_imba_wisp_relocate:OnCreated(params)
	if IsServer() then
		local caster             = self:GetCaster()
		local ability            = self:GetAbility()
		local ally               = ability.ally

		self.return_time         = params.return_time
		self.return_point        = self:GetCaster():GetAbsOrigin()

		self.eject_cooldown_mult = self:GetAbility():GetSpecialValueFor("eject_cooldown_mult")

		-- Create marker at origin
		self.caster_origin_pfx   = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker.vpcf", PATTACH_WORLDORIGIN, caster, caster)
		ParticleManager:SetParticleControl(self.caster_origin_pfx, 0, caster:GetAbsOrigin())

		-- Add teleport effect
		local caster_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, caster, caster)
		ParticleManager:SetParticleControl(caster_teleport_pfx, 0, caster:GetAbsOrigin())

		-- Move units
		FindClearSpaceForUnit(caster, ability.relocate_target_point, true)
		caster:Interrupt()

		local teleport_out_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster())
		--		ParticleManager:SetParticleControl(teleport_out_pfx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:DestroyParticle(teleport_out_pfx, false)
		ParticleManager:ReleaseParticleIndex(teleport_out_pfx)

		if caster:HasModifier("modifier_imba_wisp_tether") and ally ~= nil and ally:IsHero() then
			self.ally_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, ally, caster)
			ParticleManager:SetParticleControl(self.ally_teleport_pfx, 0, ally:GetAbsOrigin())
			FindClearSpaceForUnit(ally, ability.relocate_target_point + Vector(100, 0, 0), true)
			ally:Interrupt()
		end

		self.timer_buff = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_timer_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster, caster)
		ParticleManager:SetParticleControlEnt(self.timer_buff, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.timer_buff, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		self.relocate_timerPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		local timerCP1_x = self.return_time >= 10 and 1 or 0
		local timerCP1_y = self.return_time % 10
		ParticleManager:SetParticleControl(self.relocate_timerPfx, 1, Vector(timerCP1_x, timerCP1_y, 0))

		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_wisp_relocate:OnIntervalThink()
	self.return_time = self.return_time - 1
	local timerCP1_x = self.return_time >= 10 and 1 or 0
	local timerCP1_y = self.return_time % 10
	ParticleManager:SetParticleControl(self.relocate_timerPfx, 1, Vector(timerCP1_x, timerCP1_y, 0))
end

function modifier_imba_wisp_relocate:OnRemoved()
	if IsServer() then
		EmitSoundOn("Hero_Wisp.TeleportOut", self:GetCaster())
		StopSoundOn("Hero_Wisp.ReturnCounter", self:GetCaster())

		-- Add teleport effect
		local caster_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster())
		ParticleManager:SetParticleControl(caster_teleport_pfx, 0, self:GetCaster():GetAbsOrigin())

		-- remove origin marker + delay timer
		ParticleManager:DestroyParticle(self.relocate_timerPfx, false)
		ParticleManager:DestroyParticle(self.caster_origin_pfx, false)
		ParticleManager:DestroyParticle(self.timer_buff, false)

		self:GetCaster():SetAbsOrigin(self.return_point)
		self:GetCaster():Interrupt()

		local tether_ability = self:GetCaster():FindAbilityByName("imba_wisp_tether")
		if self:GetCaster():HasModifier("modifier_imba_wisp_tether") and tether_ability.target ~= nil and tether_ability.target:IsHero() and self:GetCaster():IsAlive() then
			tether_ability.target:SetAbsOrigin(self.return_point + Vector(100, 0, 0))
			self.ally_teleport_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_teleport.vpcf", PATTACH_CUSTOMORIGIN, tether_ability.target, self:GetCaster())
			ParticleManager:SetParticleControlEnt(self.ally_teleport_pfx, 0, tether_ability.target, PATTACH_POINT, "attach_hitloc", tether_ability.target:GetAbsOrigin(), true)
			tether_ability.target:Interrupt()
		end

		self:GetCaster():SwapAbilities("imba_wisp_relocate_break", "imba_wisp_relocate", false, true)

		if self:GetRemainingTime() >= 0 then
			local relocate_ability = self:GetCaster():FindAbilityByName("imba_wisp_relocate")

			relocate_ability:StartCooldown(relocate_ability:GetCooldownTimeRemaining() + (self:GetRemainingTime() * self.eject_cooldown_mult))
		end
	end
end

modifier_imba_wisp_relocate_talent = class({})
function modifier_imba_wisp_relocate_talent:IsDebuff() return false end

function modifier_imba_wisp_relocate_talent:IsHidden() return false end

function modifier_imba_wisp_relocate_talent:IsPurgable() return false end

function modifier_imba_wisp_relocate_talent:IsStunDebuff() return false end

function modifier_imba_wisp_relocate_talent:IsPurgeException() return false end

function modifier_imba_wisp_relocate_talent:RemoveOnDeath() return true end

function modifier_imba_wisp_relocate_talent:CheckState()
	local state = { [MODIFIER_STATE_MAGIC_IMMUNE] = true }
	return state
end

function modifier_imba_wisp_relocate_talent:GetEffectName()
	return "particles/item/black_queen_cape/black_king_bar_avatar.vpcf"
end

function modifier_imba_wisp_relocate_talent:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------
--		RELOCATE BREAK		--
------------------------------
imba_wisp_relocate_break = class({})

function imba_wisp_relocate_break:IsStealable() return false end

function imba_wisp_relocate_break:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:RemoveModifierByName("modifier_imba_wisp_relocate")
	end
end

-------------------------------
-- OVERCHARGE (7.21 VERSION) --
-------------------------------

LinkLuaModifier("modifier_imba_wisp_overcharge_721", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_721_aura", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_wisp_overcharge_721_handler", "components/abilities/heroes/hero_wisp.lua", LUA_MODIFIER_MOTION_NONE)

imba_wisp_overcharge_721                  = class({})
modifier_imba_wisp_overcharge_721         = class({})
modifier_imba_wisp_overcharge_721_aura    = class({})
modifier_imba_wisp_overcharge_721_handler = class({})

function imba_wisp_overcharge_721:GetBehavior()
	if self:GetCaster():HasTalent("special_bonus_imba_wisp_12") then
		if self:GetCaster():GetModifierStackCount("modifier_imba_wisp_overcharge_721_handler", self:GetCaster()) == 0 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		else
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function imba_wisp_overcharge_721:GetCooldown(level)
	if self:GetCaster():HasTalent("special_bonus_imba_wisp_12") then
		if self:GetCaster():GetModifierStackCount("modifier_imba_wisp_overcharge_721_handler", self:GetCaster()) == 0 then
			return self:GetSpecialValueFor("talent_cooldown")
		else
			return self.BaseClass.GetCooldown(self, level)
		end
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_wisp_overcharge_721:GetIntrinsicModifierName()
	return "modifier_imba_wisp_overcharge_721_handler"
end

function imba_wisp_overcharge_721:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_overcharge_721", { duration = self:GetSpecialValueFor("duration") })
end

function imba_wisp_overcharge_721:OnToggle()
	if not IsServer() then return end

	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_wisp_overcharge_721", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_wisp_overcharge_721", self:GetCaster())
	end
end

----------------------------------------
-- OVERCHARGE MODIFIER (7.21 VERSION) --
----------------------------------------

function modifier_imba_wisp_overcharge_721:IsPurgable() return false end

function modifier_imba_wisp_overcharge_721:GetEffectName()
	return self:GetParent().overcharge_effect
end

function modifier_imba_wisp_overcharge_721:OnCreated()
	self.ability               = self:GetAbility()
	self.caster                = self:GetCaster()
	self.parent                = self:GetParent()

	-- AbilitySpecials
	self.bonus_attack_speed    = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_damage_pct      = self.ability:GetSpecialValueFor("bonus_damage_pct") - self.caster:FindTalentValue("special_bonus_imba_wisp_4")
	self.hp_regen              = self.ability:GetSpecialValueFor("hp_regen")

	self.bonus_missile_speed   = self.ability:GetSpecialValueFor("bonus_missile_speed")
	self.bonus_cast_speed      = self.ability:GetSpecialValueFor("bonus_cast_speed")
	self.bonus_attack_range    = self.ability:GetSpecialValueFor("bonus_attack_range")

	self.talent_drain_interval = self.ability:GetSpecialValueFor("talent_drain_interval")
	self.talent_drain_pct      = self.ability:GetSpecialValueFor("talent_drain_pct")

	if not IsServer() then return end

	self:GetParent():EmitSound("Hero_Wisp.Overcharge")

	local tether_ability = self:GetCaster():FindAbilityByName("imba_wisp_tether")

	if tether_ability and tether_ability.target and not tether_ability.target:HasModifier("modifier_imba_wisp_overcharge_721") then
		tether_ability.target:AddNewModifier(self.caster, self.ability, "modifier_imba_wisp_overcharge_721", {})
	end

	if self.caster == self.parent and self.ability:GetToggleState() then
		if not self.ability:GetAutoCastState() then
			self:SetDuration(-1, true)
			self:StartIntervalThink(self.talent_drain_interval)
		else
			-- Toggle off the ability and re-cast with the proper default logic
			self.ability:ToggleAbility()
			self:StartIntervalThink(-1)
			self.ability:CastAbility()
		end
	end
end

function modifier_imba_wisp_overcharge_721:OnIntervalThink()
	self.parent:ModifyHealth(self.caster:GetHealth() * (1 - (self.talent_drain_pct / 100 * self.talent_drain_interval)), self.ability, false, 0)
	self.parent:ReduceMana(self.caster:GetMana() * self.talent_drain_pct / 100 * self.talent_drain_interval)
end

function modifier_imba_wisp_overcharge_721:OnRefresh()
	self:OnCreated()
end

function modifier_imba_wisp_overcharge_721:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Wisp.Overcharge")

	local tether_ability = self:GetCaster():FindAbilityByName("imba_wisp_tether")

	if tether_ability and tether_ability.target then
		local overcharge_modifier = tether_ability.target:FindModifierByNameAndCaster("modifier_imba_wisp_overcharge_721", self:GetCaster())

		if overcharge_modifier then
			overcharge_modifier:Destroy()
		end
	end
end

function modifier_imba_wisp_overcharge_721:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

		-- IMBAfication: Fundamental Shift
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		-- MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return decFuncs
end

function modifier_imba_wisp_overcharge_721:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

-- function modifier_imba_wisp_overcharge_721:GetModifierIncomingDamage_Percentage()
-- return self.bonus_damage_pct
-- end

function modifier_imba_wisp_overcharge_721:GetModifierHealthRegenPercentage()
	return self.hp_regen
end

function modifier_imba_wisp_overcharge_721:GetModifierProjectileSpeedBonus()
	return self.bonus_missile_speed
end

function modifier_imba_wisp_overcharge_721:GetModifierPercentageCasttime(keys)
	if self:GetParent().HasAbility and self:GetParent():HasAbility("furion_teleportation") and self:GetParent():FindAbilityByName("furion_teleportation"):IsInAbilityPhase() then
		return 0
	else
		return self.bonus_cast_speed
	end
end

-- function modifier_imba_wisp_overcharge_721:GetModifierAttackRangeBonus()
-- return self.bonus_attack_range
-- end

-- Scepter stuff
function modifier_imba_wisp_overcharge_721:IsAura() return self:GetParent() == self:GetCaster() and self:GetCaster():HasScepter() end

function modifier_imba_wisp_overcharge_721:IsAuraActiveOnDeath() return false end

function modifier_imba_wisp_overcharge_721:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("scepter_radius") end

function modifier_imba_wisp_overcharge_721:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_wisp_overcharge_721:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_wisp_overcharge_721:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_wisp_overcharge_721:GetModifierAura() return "modifier_imba_wisp_overcharge_721_aura" end

function modifier_imba_wisp_overcharge_721:GetAuraEntityReject(hEntity) return hEntity:HasModifier("modifier_imba_wisp_overcharge_721") end

---------------------------------------------
-- OVERCHARGE AURA MODIFIER (7.21 VERSION) --
---------------------------------------------

function modifier_imba_wisp_overcharge_721_aura:IsPurgable() return false end

function modifier_imba_wisp_overcharge_721_aura:GetEffectName()
	return self:GetParent().overcharge_effect
end

function modifier_imba_wisp_overcharge_721_aura:OnCreated()
	self.ability             = self:GetAbility()
	self.caster              = self:GetCaster()
	self.parent              = self:GetParent()

	-- AbilitySpecials
	self.scepter_efficiency  = self.ability:GetSpecialValueFor("scepter_efficiency")

	self.bonus_attack_speed  = self.ability:GetSpecialValueFor("bonus_attack_speed") * self.scepter_efficiency
	self.bonus_damage_pct    = self.ability:GetSpecialValueFor("bonus_damage_pct") - self.caster:FindTalentValue("special_bonus_imba_wisp_4") * self.scepter_efficiency
	self.hp_regen            = self.ability:GetSpecialValueFor("hp_regen") * self.scepter_efficiency

	self.bonus_missile_speed = self.ability:GetSpecialValueFor("bonus_missile_speed") * self.scepter_efficiency
	self.bonus_cast_speed    = self.ability:GetSpecialValueFor("bonus_cast_speed") * self.scepter_efficiency
	self.bonus_attack_range  = self.ability:GetSpecialValueFor("bonus_attack_range") * self.scepter_efficiency
end

function modifier_imba_wisp_overcharge_721_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_wisp_overcharge_721_aura:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

		-- IMBAfication: Fundamental Shift
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		-- MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return decFuncs
end

function modifier_imba_wisp_overcharge_721_aura:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

-- function modifier_imba_wisp_overcharge_721_aura:GetModifierIncomingDamage_Percentage()
-- return self.bonus_damage_pct
-- end

function modifier_imba_wisp_overcharge_721_aura:GetModifierHealthRegenPercentage()
	return self.hp_regen
end

function modifier_imba_wisp_overcharge_721_aura:GetModifierProjectileSpeedBonus()
	return self.bonus_missile_speed
end

function modifier_imba_wisp_overcharge_721_aura:GetModifierPercentageCasttime()
	return self.bonus_cast_speed
end

-- function modifier_imba_wisp_overcharge_721_aura:GetModifierAttackRangeBonus()
-- return self.bonus_attack_range
-- end

------------------------------------------------
-- OVERCHARGE HANDLER MODIFIER (7.21 VERSION) --
------------------------------------------------

-- A talent that adds an auto-cast function to an ability...that's new

function modifier_imba_wisp_overcharge_721_handler:IsHidden() return true end

function modifier_imba_wisp_overcharge_721_handler:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_ORDER }

	return decFuncs
end

function modifier_imba_wisp_overcharge_721_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or not self:GetParent():HasTalent("special_bonus_imba_wisp_12") or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_wisp_11", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_wisp_6", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_wisp_11 = modifier_special_bonus_imba_wisp_11 or class({})
modifier_special_bonus_imba_wisp_6  = modifier_special_bonus_imba_wisp_6 or class({})

function modifier_special_bonus_imba_wisp_11:IsHidden() return true end

function modifier_special_bonus_imba_wisp_11:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_11:RemoveOnDeath() return false end

function modifier_special_bonus_imba_wisp_6:IsHidden() return true end

function modifier_special_bonus_imba_wisp_6:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_6:RemoveOnDeath() return false end

-- Client-side helper functions
LinkLuaModifier("modifier_special_bonus_imba_wisp_4", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_wisp_9", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_wisp_10", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_wisp_12", "components/abilities/heroes/hero_wisp", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_wisp_4 = class({})

function modifier_special_bonus_imba_wisp_4:IsHidden() return true end

function modifier_special_bonus_imba_wisp_4:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_4:RemoveOnDeath() return false end

modifier_special_bonus_imba_wisp_9 = class({})

function modifier_special_bonus_imba_wisp_9:IsHidden() return true end

function modifier_special_bonus_imba_wisp_9:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_9:RemoveOnDeath() return false end

modifier_special_bonus_imba_wisp_10 = class({})

function modifier_special_bonus_imba_wisp_10:IsHidden() return true end

function modifier_special_bonus_imba_wisp_10:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_10:RemoveOnDeath() return false end

modifier_special_bonus_imba_wisp_12 = class({})

function modifier_special_bonus_imba_wisp_12:IsHidden() return true end

function modifier_special_bonus_imba_wisp_12:IsPurgable() return false end

function modifier_special_bonus_imba_wisp_12:RemoveOnDeath() return false end

function imba_wisp_spirits:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_wisp_10") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_wisp_10") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_wisp_10"), "modifier_special_bonus_imba_wisp_10", {})
	end
end

function imba_wisp_overcharge_721:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_wisp_4") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_wisp_4") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_wisp_4"), "modifier_special_bonus_imba_wisp_4", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_wisp_12") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_wisp_12") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_wisp_12"), "modifier_special_bonus_imba_wisp_12", {})
	end
end

function imba_wisp_relocate:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_wisp_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_wisp_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_wisp_9"), "modifier_special_bonus_imba_wisp_9", {})
	end
end

-- Arcana death pfx handler
modifier_wisp_death = modifier_wisp_death or class({})

function modifier_wisp_death:RemoveOnDeath()
	return false
end

function modifier_wisp_death:IsHidden()
	return true
end

function modifier_wisp_death:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_wisp_death:OnDeath(params)
	if not IsServer() then return end

	if params.unit == self:GetParent() then
		print("WISP IS DEAD!")
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_death_override.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent())
		--		ParticleManager:SetParticleControl(pfx, 0, Vector(self:GetParent():GetAbsOrigin().x, self:GetParent():GetAbsOrigin().y, self:GetParent():GetAbsOrigin().z + 100))
	end
end
