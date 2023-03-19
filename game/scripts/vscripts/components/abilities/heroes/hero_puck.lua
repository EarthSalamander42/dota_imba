-- Creator:
--	   AltiV, June 9th, 2019

LinkLuaModifier("modifier_imba_puck_illusory_orb", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_puck_waning_rift", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_puck_phase_shift", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_puck_phase_shift_handler", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_puck_dream_coil", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_puck_dream_coil_thinker", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_puck_dream_coil_visionary", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

imba_puck_illusory_orb                  = class({})
modifier_imba_puck_illusory_orb         = class({})

imba_puck_waning_rift                   = class({})
modifier_imba_puck_waning_rift          = class({})

imba_puck_phase_shift                   = class({})
modifier_imba_puck_phase_shift          = class({})
modifier_imba_puck_phase_shift_handler  = class({})

imba_puck_ethereal_jaunt                = class({})

imba_puck_dream_coil                    = class({})
modifier_imba_puck_dream_coil           = class({})
modifier_imba_puck_dream_coil_thinker   = class({})
modifier_imba_puck_dream_coil_visionary = class({})

------------------
-- ILLUSORY ORB --
------------------

function imba_puck_illusory_orb:GetAssociatedSecondaryAbilities()
	return "imba_puck_ethereal_jaunt"
end

function imba_puck_illusory_orb:OnUpgrade()
	local jaunt_ability = self:GetCaster():FindAbilityByName("imba_puck_ethereal_jaunt")

	if jaunt_ability and not self.jaunt_ability then
		self.jaunt_ability = jaunt_ability

		if not jaunt_ability:IsTrained() then
			self.jaunt_ability:SetLevel(1)
		end
	end
end

function imba_puck_illusory_orb:OnSpellStart()
	-- In reality this small block would never be called, but this was just during testing with ability replacements
	local jaunt_ability = self:GetCaster():FindAbilityByName("imba_puck_ethereal_jaunt")

	if jaunt_ability and not self.jaunt_ability then
		self.jaunt_ability = jaunt_ability

		if not jaunt_ability:IsTrained() then
			self.jaunt_ability:SetLevel(1)
		end
	end

	-- Keep track of orbs for better ability handling (rather than not getting to jaunt to a second orb if a first expires while both are in flight)
	if not self.orbs then
		self.orbs = {}
	end

	self.talent_cast_range_increases = 0

	for ability = 0, 23 do
		local found_ability = self:GetCaster():GetAbilityByIndex(ability)

		if found_ability and string.find(found_ability:GetName(), "cast_range") and self:GetCaster():HasTalent(found_ability:GetName()) then
			self.talent_cast_range_increases = self.talent_cast_range_increases + self:GetCaster():FindTalentValue(found_ability:GetName())
		end
	end

	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	-- IMBAfication: Dichotomous
	-- Reverse Orb
	self:FireOrb(self:GetCaster():GetAbsOrigin() - self:GetCursorPosition())
	-- Main Orb
	self:FireOrb(self:GetCursorPosition() - self:GetCaster():GetAbsOrigin())

	if self.jaunt_ability then
		self.jaunt_ability:SetActivated(true)
	end

	-- IMBAfication: Eternal Jaunt
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_puck_illusory_orb", { duration = ((self:GetSpecialValueFor("max_distance") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_puck_illusory_orb_speed"), 1)) + GetCastRangeIncrease(self:GetCaster()) + self.talent_cast_range_increases) / (self:GetSpecialValueFor("orb_speed") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_puck_illusory_orb_speed"), 1)) })
end

function imba_puck_illusory_orb:OnProjectileThink_ExtraData(location, data)
	if not IsServer() then return end

	if data.orb_thinker then
		EntIndexToHScript(data.orb_thinker):SetAbsOrigin(location)
	end

	-- "The orb leaves behind a trail of flying vision, with a radius of 450. The vision lingers for 5 seconds."
	-- IDK why the specialvalue is 3.34 but I guess vanilla doesn't use it, also vanilla vision circles are more segmented it seems...
	self:CreateVisibilityNode(location, self:GetSpecialValueFor("orb_vision"), 5)
end

function imba_puck_illusory_orb:FireOrb(position)
	-- Create thinker for position and sound handling
	local orb_thinker = CreateModifierThinker(
		self:GetCaster(),
		self,
		nil, -- Maybe add one later
		{},
		self:GetCaster():GetOrigin(),
		self:GetCaster():GetTeamNumber(),
		false
	)

	orb_thinker:EmitSound("Hero_Puck.Illusory_Orb")

	-- Create linear projectile
	local projectile_info = {
		Source            = self:GetCaster(),
		Ability           = self,
		vSpawnOrigin      = self:GetCaster():GetOrigin(),
		bDeleteOnHit      = false,
		iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType   = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		EffectName        = "particles/units/heroes/hero_puck/puck_illusory_orb.vpcf",
		fDistance         = (self:GetSpecialValueFor("max_distance") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_puck_illusory_orb_speed"), 1)) + GetCastRangeIncrease(self:GetCaster()) + self.talent_cast_range_increases,
		fStartRadius      = self:GetSpecialValueFor("radius"),
		fEndRadius        = self:GetSpecialValueFor("radius"),
		vVelocity         = position:Normalized() * self:GetSpecialValueFor("orb_speed") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_puck_illusory_orb_speed"), 1),
		bReplaceExisting  = false,
		bProvidesVision   = true,
		iVisionRadius     = self:GetSpecialValueFor("orb_vision"),
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData         = {
			orb_thinker = orb_thinker:entindex(),
		}
	}

	local projectile = ProjectileManager:CreateLinearProjectile(projectile_info)

	-- Shove the thinker's entity index into orb table (would probably be marginally nicer to shove the projectile id but it seems messy trying to get that into ExtraData
	table.insert(self.orbs, orb_thinker:entindex())
end

function imba_puck_illusory_orb:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	if target then
		target:EmitSound("Hero_Puck.IIllusory_Orb_Damage")

		local damageTable = {
			victim       = target,
			damage       = self:GetAbilityDamage(),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		}

		ApplyDamage(damageTable)
	else
		if data.orb_thinker then
			table.remove(self.orbs, 1)
			EntIndexToHScript(data.orb_thinker):StopSound("Hero_Puck.Illusory_Orb")
			EntIndexToHScript(data.orb_thinker):RemoveSelf()
		end

		if self.jaunt_ability and #self.orbs == 0 then
			self.jaunt_ability:SetActivated(false)
		end
	end
end

---------------------------
-- ILLUSORY ORB MODIFIER --
---------------------------

function modifier_imba_puck_illusory_orb:IsHidden() return true end

function modifier_imba_puck_illusory_orb:OnRefresh()
	if not IsServer() then return end

	self:SetStackCount(0)
end

-----------------
-- WANING RIFT --
-----------------

function imba_puck_waning_rift:GetAOERadius()
	return self:GetTalentSpecialValueFor("radius")
end

function imba_puck_waning_rift:CastFilterResultTarget(target)
	return UF_SUCCESS
end

function imba_puck_waning_rift:GetBehavior()
	return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function imba_puck_waning_rift:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_puck_waning_rift_range")
end

function imba_puck_waning_rift:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_puck_waning_rift_cooldown")
end

function imba_puck_waning_rift:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Puck.Waning_Rift")

	if self:GetCaster():GetName() == "npc_dota_hero_puck" then
		self:GetCaster():EmitSound("puck_puck_ability_rift_0" .. RandomInt(1, 3))
	end

	local rift_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(rift_particle, 1, Vector(self:GetTalentSpecialValueFor("radius"), 0, 0))
	ParticleManager:ReleaseParticleIndex(rift_particle)

	if not self:GetCaster():IsRooted() then
		FindClearSpaceForUnit(self:GetCaster(), self:GetCursorPosition(), true)
	end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetTalentSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		-- "Waning Rift first applies the damage, then the debuff."

		local damageTable = {
			victim       = enemy,
			damage       = self:GetTalentSpecialValueFor("damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		}

		ApplyDamage(damageTable)

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_puck_waning_rift", { duration = self:GetSpecialValueFor("silence_duration") * (1 - enemy:GetStatusResistance()) })
	end
end

--------------------------
-- WANING RIFT MODIFIER --
--------------------------

function modifier_imba_puck_waning_rift:GetEffectName()
	if not self:GetParent():IsCreep() then
		return "particles/generic_gameplay/generic_silenced.vpcf"
	else
		return "particles/generic_gameplay/generic_silenced_lanecreeps.vpcf"
	end
end

function modifier_imba_puck_waning_rift:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_puck_waning_rift:OnCreated()
	self.glitter_vision_reduction = self:GetAbility():GetSpecialValueFor("glitter_vision_reduction")

	if not IsServer() then return end

	self:SetStackCount(self:GetAbility():GetSpecialValueFor("trickster_null_instances"))
end

function modifier_imba_puck_waning_rift:CheckState()
	return { [MODIFIER_STATE_SILENCED] = true }
end

-- IMBAfication: Pocket Glitter
-- IMBAfication: Trickster's Inhibition
function modifier_imba_puck_waning_rift:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}

	return decFuncs
end

function modifier_imba_puck_waning_rift:GetBonusVisionPercentage()
	return self.glitter_vision_reduction
end

function modifier_imba_puck_waning_rift:GetModifierTotalDamageOutgoing_Percentage(keys)
	if not IsServer() then return end

	if self:GetStackCount() > 0 then
		self:DecrementStackCount()
		return -100
	end
end

-----------------
-- PHASE SHIFT --
-----------------

function imba_puck_phase_shift:CastFilterResultTarget(target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_NONE, DOTA_UNIT_TARGET_NONE, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, self:GetCaster():GetTeamNumber())
	end
end

function imba_puck_phase_shift:ProcsMagicStick() return false end

-- function imba_puck_phase_shift:GetAbilityTargetFlags()
-- if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
-- return DOTA_UNIT_TARGET_FLAG_NONE
-- else
-- return DOTA_UNIT_TARGET_FLAG_INVULNERABLE -- Doesn't seem like this works
-- end
-- end


-- function imba_puck_phase_shift:GetAbilityTargetTeam()
-- if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
-- return DOTA_UNIT_TARGET_TEAM_NONE
-- else
-- return DOTA_UNIT_TARGET_TEAM_FRIENDLY
-- end
-- end

-- function imba_puck_phase_shift:GetAbilityTargetType()
-- if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
-- return DOTA_UNIT_TARGET_NONE
-- else
-- return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
-- end
-- end


function imba_puck_phase_shift:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_puck_phase_shift:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_puck_phase_shift_handler", self:GetCaster()) == 0 then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		return self:GetSpecialValueFor("sinusoid_cast_range") - self:GetCaster():GetCastRangeBonus()
	end
end

function imba_puck_phase_shift:GetIntrinsicModifierName()
	return "modifier_imba_puck_phase_shift_handler"
end

function imba_puck_phase_shift:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Puck.Phase_Shift")

	if self:GetCaster():GetName() == "npc_dota_hero_puck" then
		self:GetCaster():EmitSound("puck_puck_ability_phase_0" .. RandomInt(1, 7))
	end

	if self:GetAutoCastState() then
		-- IMBAfication: Sinusoid
		if self:GetCursorPosition() and not self:GetCursorTarget() then
			FindClearSpaceForUnit(self:GetCaster(), self:GetCursorPosition(), true)
		elseif self:GetCursorTarget() then
			if self:GetCursorTarget() ~= self:GetCaster() then
				self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_puck_phase_shift", { duration = self:GetSpecialValueFor("duration") + FrameTime() })
			end

			-- Kinda hacky way to allow Puck to self-cast channel (cause I don't think there's any existing ability that actually lets you do that normally)
			self:GetCaster():SetCursorCastTarget(nil)
			self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
			self:OnSpellStart()
		end
	end

	-- "The buff lingers for one server tick once the channeling ends or is interrupted, which allows using items while still invulnerable and hidden."
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_puck_phase_shift", { duration = self:GetSpecialValueFor("duration") + FrameTime() })

	if self:GetCaster():HasTalent("special_bonus_imba_puck_phase_shift_attacks") then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetAbsOrigin(), nil, self:GetCaster():Script_GetAttackRange() + 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)) do
			if enemy:GetName() ~= "npc_dota_unit_undying_zombie" then
				self:GetCaster():PerformAttack(enemy, true, true, true, false, true, false, false)
			end
		end
	end
end

function imba_puck_phase_shift:OnChannelFinish(interrupted)
	self:GetCaster():StopSound("Hero_Puck.Phase_Shift")

	local phase_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_puck_phase_shift", self:GetCaster())

	-- "The buff lingers for one server tick once the channeling ends or is interrupted, which allows using items while still invulnerable and hidden."
	if phase_modifier then
		phase_modifier:StartIntervalThink(FrameTime())
	end
end

--------------------------
-- PHASE SHIFT MODIFIER --
--------------------------

-- Yeah this doesn't work so just gotta call it manually I guess
-- function modifier_imba_puck_phase_shift:GetEffectName()
-- return "particles/units/heroes/hero_puck/puck_phase_shift.vpcf"
-- end

-- function modifier_imba_puck_phase_shift:GetEffectAttachType()
-- return PATTACH_WORLDORIGIN
-- end


-- Turns Puck green or something a frame before disappearing? This probably isn't actually used
function modifier_imba_puck_phase_shift:GetStatusEffectName()
	return "particles/status_fx/status_effect_phase_shift.vpcf"
end

function modifier_imba_puck_phase_shift:OnCreated()
	if not IsServer() then return end

	ProjectileManager:ProjectileDodge(self:GetParent())

	local phase_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_phase_shift.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	-- This doesn't seem to match the vanilla particle affect properly...the standard is more diffused, but "particles/units/heroes/hero_puck/puck_phase_shift.vpcf" leaves a focused dot which kinda overlaps with the space
	ParticleManager:SetParticleControl(phase_particle, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(phase_particle, false, false, -1, false, false)

	self:GetParent():AddNoDraw()

	if self:GetParent() ~= self:GetCaster() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_puck_phase_shift:OnRefresh()
	self:OnCreated()
end

function modifier_imba_puck_phase_shift:OnIntervalThink()
	if not IsServer() then return end

	if not self:GetAbility() or not self:GetAbility():IsChanneling() then
		self:Destroy()
	end
end

function modifier_imba_puck_phase_shift:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveNoDraw()
end

function modifier_imba_puck_phase_shift:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME]  = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}

	if self:GetParent() ~= self:GetCaster() then
		state[MODIFIER_STATE_STUNNED] = true
	end

	return state
end

----------------------------------
-- PHASE SHIFT HANDLER MODIFIER --
----------------------------------

function modifier_imba_puck_phase_shift_handler:IsHidden() return true end

function modifier_imba_puck_phase_shift_handler:DeclareFunctions()
	local decFuncs = { MODIFIER_EVENT_ON_ORDER }

	return decFuncs
end

function modifier_imba_puck_phase_shift_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

--------------------
-- ETHEREAL JAUNT --
--------------------

function imba_puck_ethereal_jaunt:GetAssociatedPrimaryAbilities()
	return "imba_puck_illusory_orb"
end

function imba_puck_ethereal_jaunt:ProcsMagicStick() return false end

-- IMBAfication: Eternal Jaunt
-- Putting mana cost on this so it doesn't get (too) out of hand
function imba_puck_ethereal_jaunt:GetManaCost(level)
	if not self:GetCaster():GetModifierStackCount("modifier_imba_puck_illusory_orb", self:GetCaster()) or self:GetCaster():GetModifierStackCount("modifier_imba_puck_illusory_orb", self:GetCaster()) <= 0 then
		return 0
	else
		return self:GetCaster():GetMaxMana() * self:GetSpecialValueFor("eternal_max_mana_pct") / 100
	end
end

function imba_puck_ethereal_jaunt:OnUpgrade()
	-- This shouldn't result in bugs because an orb can't even be in flight before this ability is leveled
	self:SetActivated(false)

	local orb_ability = self:GetCaster():FindAbilityByName(self:GetAssociatedPrimaryAbilities())

	if orb_ability then
		self.orb_ability = orb_ability
	end
end

function imba_puck_ethereal_jaunt:OnSpellStart()
	if self.orb_ability and self.orb_ability.orbs and #self.orb_ability.orbs >= 1 then
		self:GetCaster():EmitSound("Hero_Puck.EtherealJaunt")

		local jaunt_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_illusory_orb_blink_out.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(jaunt_particle)

		FindClearSpaceForUnit(self:GetCaster(), EntIndexToHScript(self.orb_ability.orbs[#self.orb_ability.orbs]):GetAbsOrigin(), true)
		ProjectileManager:ProjectileDodge(self:GetCaster())

		if self:GetCaster():GetName() == "npc_dota_hero_puck" and (not self:GetCaster():GetModifierStackCount("modifier_imba_puck_illusory_orb", self:GetCaster()) or self:GetCaster():GetModifierStackCount("modifier_imba_puck_illusory_orb", self:GetCaster()) <= 0) then
			self:GetCaster():EmitSound("puck_puck_ability_orb_0" .. RandomInt(1, 3))
		end

		-- IMBAfication: Eternal Jaunt
		if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_puck_illusory_orb", self:GetCaster()) then
			self:GetCaster():FindModifierByNameAndCaster("modifier_imba_puck_illusory_orb", self:GetCaster()):IncrementStackCount()
		end
	end
end

----------------
-- DREAM COIL --
----------------

function imba_puck_dream_coil:GetAOERadius()
	return self:GetSpecialValueFor("coil_radius")
end

-- The variable fed into the method is if the ability is recast via the Midsummer's Nightmare IMBAfication
function imba_puck_dream_coil:OnSpellStart(refreshDuration)
	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Puck.Dream_Coil", self:GetCaster())

	if not refreshDuration then
		if self:GetCaster():GetName() == "npc_dota_hero_puck" then
			self:GetCaster():EmitSound("puck_puck_ability_dreamcoil_0" .. RandomInt(1, 2))
		end
	end

	-- "When upgraded [with Aghanim's scepter], latches on spell immune enemies without stunning them . . ."
	local target_flag    = DOTA_UNIT_TARGET_FLAG_NONE
	local latch_duration = self:GetSpecialValueFor("coil_duration")

	if self:GetCaster():HasScepter() then
		target_flag    = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		latch_duration = self:GetSpecialValueFor("coil_duration_scepter")
	end

	-- IMBAfication: Midsummer's Nightmare
	if refreshDuration then
		latch_duration = refreshDuration
	end

	-- Create thinker for...I guess just the particle effects?
	local coil_thinker = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_imba_puck_dream_coil_thinker",
		{ duration = latch_duration },
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
	)

	local target_type = DOTA_UNIT_TARGET_HERO

	if self:GetCaster():HasTalent("special_bonus_imba_puck_dream_coil_targets") then
		target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end

	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("coil_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, target_flag, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		ApplyDamage({
			victim       = enemy,
			damage       = self:GetSpecialValueFor("coil_initial_damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance()) })

		local coil_modifier = enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_puck_dream_coil",
			{
				duration     = latch_duration,
				coil_thinker = coil_thinker:entindex()
			})

		if not refreshDuration then
			coil_modifier:SetDuration(latch_duration * (1 - enemy:GetStatusResistance()), true)
		end

		-- IMBAfication: Visionary
		for index = 0, 23 do
			local ability = enemy:GetAbilityByIndex(index)

			if ability and ability:GetAbilityType() == ABILITY_TYPE_ULTIMATE then
				self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_imba_puck_dream_coil_visionary", { duration = latch_duration })
			end
		end
	end
end

function imba_puck_dream_coil:OnProjectileHit_ExtraData(target, location, data)
	if not IsServer() then return end

	if target then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Puck.ProjectileImpact", self:GetCaster())

		self:GetCaster():PerformAttack(target, false, true, true, false, false, false, false)
	end
end

-------------------------
-- DREAM COIL MODIFIER --
-------------------------

function modifier_imba_puck_dream_coil:IsPurgable() return not self:GetCaster():HasScepter() end

function modifier_imba_puck_dream_coil:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_puck_dream_coil:OnCreated(params)
	self.coil_break_radius          = self:GetAbility():GetSpecialValueFor("coil_break_radius")
	self.coil_stun_duration         = self:GetAbility():GetSpecialValueFor("coil_stun_duration")
	self.coil_break_damage          = self:GetAbility():GetSpecialValueFor("coil_break_damage")
	self.coil_break_damage_scepter  = self:GetAbility():GetSpecialValueFor("coil_break_damage_scepter")
	self.coil_stun_duration_scepter = self:GetAbility():GetSpecialValueFor("coil_stun_duration_scepter")

	self.rapid_fire_interval        = self:GetAbility():GetSpecialValueFor("rapid_fire_interval")
	self.rapid_fire_max_distance    = self:GetAbility():GetSpecialValueFor("rapid_fire_max_distance")

	if not IsServer() then return end

	self.ability_damage_type   = self:GetAbility():GetAbilityDamageType()
	self.coil_thinker          = EntIndexToHScript(params.coil_thinker)
	self.coil_thinker_location = self.coil_thinker:GetAbsOrigin()

	local coil_particle        = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_dreamcoil_tether.vpcf", PATTACH_ABSORIGIN, self.coil_thinker, self:GetCaster())
	ParticleManager:SetParticleControlEnt(coil_particle, 0, self.coil_thinker, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.coil_thinker_location, true)
	ParticleManager:SetParticleControlEnt(coil_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(coil_particle, false, false, -1, false, false)

	self.interval = 0.1
	self.counter  = 0

	self:StartIntervalThink(self.interval)
end

-- Supposedly should not use MODIFIER_EVENT_ON_UNIT_MOVED due to potentially massive lag, so gonna just use a 0.1s IntervalThinker
-- I guess conveniently this could also be used for Rapid Fire checking
function modifier_imba_puck_dream_coil:OnIntervalThink()
	if not IsServer() then return end

	self.counter = self.counter + self.interval

	if self:GetCaster():IsAlive() and self.counter >= self.rapid_fire_interval and self:GetAbility() then
		self.counter = 0

		local direction = (self:GetParent():GetAbsOrigin() - self.coil_thinker_location):Normalized()

		if (self:GetCaster():GetAbsOrigin() - self.coil_thinker_location):Length2D() <= self.rapid_fire_max_distance then
			EmitSoundOnLocationWithCaster(self.coil_thinker_location, "Hero_Puck.Attack", self:GetCaster())

			local projectile =
			{
				Target            = self:GetParent(),
				Source            = self.coil_thinker,
				Ability           = self:GetAbility(),
				EffectName        = self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_puck/puck_base_attack.vpcf",
				iMoveSpeed        = self:GetCaster():GetProjectileSpeed() or 900,
				-- vSourceLoc 			= self.coil_thinker_location,
				bDrawsOnMinimap   = false,
				bDodgeable        = true,
				bIsAttack         = true, -- Does this even do anything
				bVisibleToEnemies = true,
				bReplaceExisting  = false,
				flExpireTime      = GameRules:GetGameTime() + 10.0,
				bProvidesVision   = false,
			}

			ProjectileManager:CreateTrackingProjectile(projectile)
		end
	end

	if (self:GetParent():GetAbsOrigin() - self.coil_thinker_location):Length2D() >= self.coil_break_radius then
		self:GetParent():EmitSound("Hero_Puck.Dream_Coil_Snap")

		-- Check for scepter
		local stun_duration = self.coil_stun_duration
		local break_damage = self.coil_break_damage

		if self:GetCaster():HasScepter() then
			stun_duration = self.coil_stun_duration_scepter
			break_damage = self.coil_break_damage_scepter
		end

		local damageTable = {
			victim       = self:GetParent(),
			damage       = break_damage,
			damage_type  = self.ability_damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self:GetAbility()
		}

		ApplyDamage(damageTable)

		-- IMBAfication: Midsummer's Nightmare
		if self:GetAbility() then
			self:GetCaster():SetCursorPosition(self:GetParent():GetAbsOrigin())
			self:GetAbility():OnSpellStart(self:GetRemainingTime() + (stun_duration * (1 - self:GetParent():GetStatusResistance())))
		end

		-- Putting the break stun modifier after the IMBAfication because it was getting overwritten by the basic lower duration stun
		local stun_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = stun_duration * (1 - self:GetParent():GetStatusResistance()) })

		self:Destroy()
	end
end

function modifier_imba_puck_dream_coil:CheckState()
	return { [MODIFIER_STATE_TETHERED] = true }
end

---------------------------------
-- DREAM COIL THINKER MODIFIER --
---------------------------------

function modifier_imba_puck_dream_coil_thinker:OnCreated()
	if not IsServer() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_dreamcoil.vpcf", PATTACH_WORLDORIGIN, nil, self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 0, self:GetParent():GetAbsOrigin())
end

function modifier_imba_puck_dream_coil_thinker:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	self:GetParent():RemoveSelf()
end

-----------------------------------
-- DREAM COIL VISIONARY MODIFIER --
-----------------------------------

function modifier_imba_puck_dream_coil_visionary:IsDebuff() return false end

function modifier_imba_puck_dream_coil_visionary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_puck_dream_coil_visionary:OnCreated()
	if not IsServer() then return end

	self:SetStackCount(math.ceil(self:GetAbility():GetCooldownTimeRemaining()))
	self:StartIntervalThink(0.1)
end

function modifier_imba_puck_dream_coil_visionary:OnIntervalThink()
	if self:GetAbility() then
		self:SetStackCount(math.ceil(self:GetAbility():GetCooldownTimeRemaining()))
	else
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_puck_phase_shift_attacks", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_puck_illusory_orb_speed", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_puck_dream_coil_targets", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_puck_phase_shift_attacks = modifier_special_bonus_imba_puck_phase_shift_attacks or class({})
modifier_special_bonus_imba_puck_illusory_orb_speed  = modifier_special_bonus_imba_puck_illusory_orb_speed or class({})
modifier_special_bonus_imba_puck_dream_coil_targets  = modifier_special_bonus_imba_puck_dream_coil_targets or class({})

function modifier_special_bonus_imba_puck_phase_shift_attacks:IsHidden() return true end

function modifier_special_bonus_imba_puck_phase_shift_attacks:IsPurgable() return false end

function modifier_special_bonus_imba_puck_phase_shift_attacks:RemoveOnDeath() return false end

function modifier_special_bonus_imba_puck_illusory_orb_speed:IsHidden() return true end

function modifier_special_bonus_imba_puck_illusory_orb_speed:IsPurgable() return false end

function modifier_special_bonus_imba_puck_illusory_orb_speed:RemoveOnDeath() return false end

function modifier_special_bonus_imba_puck_dream_coil_targets:IsHidden() return true end

function modifier_special_bonus_imba_puck_dream_coil_targets:IsPurgable() return false end

function modifier_special_bonus_imba_puck_dream_coil_targets:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_puck_waning_rift_cooldown", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_puck_waning_rift_range", "components/abilities/heroes/hero_puck", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_puck_waning_rift_cooldown = class({})
modifier_special_bonus_imba_puck_waning_rift_range    = modifier_special_bonus_imba_puck_waning_rift_range or class({})

function modifier_special_bonus_imba_puck_waning_rift_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_puck_waning_rift_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_puck_waning_rift_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_puck_waning_rift_range:IsHidden() return true end

function modifier_special_bonus_imba_puck_waning_rift_range:IsPurgable() return false end

function modifier_special_bonus_imba_puck_waning_rift_range:RemoveOnDeath() return false end

function imba_puck_waning_rift:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_puck_waning_rift_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_puck_waning_rift_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_puck_waning_rift_cooldown"), "modifier_special_bonus_imba_puck_waning_rift_cooldown", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_puck_waning_rift_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_puck_waning_rift_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_puck_waning_rift_range"), "modifier_special_bonus_imba_puck_waning_rift_range", {})
	end
end
