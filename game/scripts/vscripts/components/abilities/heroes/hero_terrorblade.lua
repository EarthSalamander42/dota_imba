-- Creator:
--	   AltiV, January 7th, 2020

LinkLuaModifier("modifier_imba_terrorblade_reflection_slow", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_reflection_unit", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_reflection_infinity_mirror_stacks", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_terrorblade_conjure_image_autocast", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_conjure_image_autocast_cooldown", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform_aura", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_transform_aura_applier", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_terrorblade_metamorphosis_fear_thinker", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_terrorblade_power_rend", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

imba_terrorblade_reflection                                    = imba_terrorblade_reflection or class({})
modifier_imba_terrorblade_reflection_slow                      = modifier_imba_terrorblade_reflection_slow or class({})
modifier_imba_terrorblade_reflection_unit                      = modifier_imba_terrorblade_reflection_unit or class({})
modifier_imba_terrorblade_reflection_infinity_mirror_stacks    = modifier_imba_terrorblade_reflection_infinity_mirror_stacks or class({})

imba_terrorblade_conjure_image                                 = imba_terrorblade_conjure_image or class({})
modifier_imba_terrorblade_conjure_image_autocast               = modifier_imba_terrorblade_conjure_image_autocast or class({})
modifier_imba_terrorblade_conjure_image_autocast_cooldown      = modifier_imba_terrorblade_conjure_image_autocast_cooldown or class({})

imba_terrorblade_metamorphosis                                 = imba_terrorblade_metamorphosis or class({})
modifier_imba_terrorblade_metamorphosis_transform              = modifier_imba_terrorblade_metamorphosis_transform or class({})
modifier_imba_terrorblade_metamorphosis                        = modifier_imba_terrorblade_metamorphosis or class({})
modifier_imba_terrorblade_metamorphosis_transform_aura         = modifier_imba_terrorblade_metamorphosis_transform_aura or class({})
modifier_imba_terrorblade_metamorphosis_transform_aura_applier = modifier_imba_terrorblade_metamorphosis_transform_aura_applier or class({})

imba_terrorblade_terror_wave                                   = imba_terrorblade_terror_wave or class({})
modifier_imba_terrorblade_metamorphosis_fear_thinker           = modifier_imba_terrorblade_metamorphosis_fear_thinker or class({})

imba_terrorblade_power_rend                                    = imba_terrorblade_power_rend or class({})
modifier_imba_terrorblade_power_rend                           = modifier_imba_terrorblade_power_rend or class({})

imba_terrorblade_sunder                                        = imba_terrorblade_sunder or class({})

---------------------------------
-- IMBA_TERRORBLADE_REFLECTION --
---------------------------------

function imba_terrorblade_reflection:GetAOERadius()
	return self:GetSpecialValueFor("range")
end

function imba_terrorblade_reflection:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + (self:GetSpecialValueFor("infinity_radius_per_stack") * self:GetCaster():GetModifierStackCount("modifier_imba_terrorblade_reflection_infinity_mirror_stacks", self:GetCaster())) - self:GetCaster():GetCastRangeBonus()
end

function imba_terrorblade_reflection:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_terrorblade_reflection_cooldown")
end

-- IMBAfication: Infinity Mirror
function imba_terrorblade_reflection:GetIntrinsicModifierName()
	return "modifier_imba_terrorblade_reflection_infinity_mirror_stacks"
end

function imba_terrorblade_reflection:OnSpellStart()
	if not IsServer() then return end

	local spawn_range = 108
	local slow_modifier = nil

	if self:GetCaster():GetName() == "npc_dota_hero_terrorblade" then
		if RollPercentage(1) then
			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				EmitSoundOnClient("terrorblade_terr_morph_reflection_01", self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient("terrorblade_terr_reflection_01", self:GetCaster():GetPlayerOwner())
			end
		elseif RollPercentage(3) then
			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				EmitSoundOnClient("terrorblade_terr_morph_reflection_06", self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient("terrorblade_terr_reflection_06", self:GetCaster():GetPlayerOwner())
			end
		elseif RollPercentage(20) then
			if not self.responses then
				self.responses =
				{
					"terrorblade_terr_reflection_02",
					"terrorblade_terr_reflection_03",
					"terrorblade_terr_reflection_04",
					"terrorblade_terr_reflection_05",
					"terrorblade_terr_reflection_07"
				}
			end

			if not self.responses_morph then
				self.responses_morph =
				{
					"terrorblade_terr_morph_reflection_02",
					"terrorblade_terr_morph_reflection_03",
					"terrorblade_terr_morph_reflection_04",
					"terrorblade_terr_morph_reflection_05",
					"terrorblade_terr_morph_reflection_07"
				}
			end

			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
				EmitSoundOnClient(self.responses_morph[RandomInt(1, #self.responses_morph)], self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
			end
		end
	end

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("range") + (self:GetSpecialValueFor("infinity_radius_per_stack") * self:GetCaster():GetModifierStackCount("modifier_imba_terrorblade_reflection_infinity_mirror_stacks", self:GetCaster())), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)) do
		if enemy:GetHullRadius() > 8 then
			spawn_range = 108
		else
			spawn_range = 72
		end

		enemy:EmitSound("Hero_Terrorblade.Reflection")

		local illusions = CreateIllusions(self:GetCaster(), enemy, {
			outgoing_damage           = self:GetTalentSpecialValueFor("illusion_outgoing_damage"),
			incoming_damage           = -100,
			bounty_base               = 0,
			bounty_growth             = nil,
			outgoing_damage_structure = nil,
			outgoing_damage_roshan    = nil,
			duration                  = self:GetSpecialValueFor("illusion_duration") + (self:GetSpecialValueFor("infinity_duration_per_stack") * self:GetCaster():GetModifierStackCount("modifier_imba_terrorblade_reflection_infinity_mirror_stacks", self:GetCaster()))
		}
		, 1, spawn_range, false, true)

		for _, illusion in pairs(illusions) do
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_reflection_unit", { enemy_entindex = enemy:entindex() })
			-- Vanilla modifier to give the illusions that Terrorblade illusion texture
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_reflection_invulnerability", {})
		end

		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_reflection_slow", { duration = self:GetSpecialValueFor("illusion_duration") * (1 - enemy:GetStatusResistance()) })
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_REFLECTION_SLOW --
-----------------------------------------------

function modifier_imba_terrorblade_reflection_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_imba_terrorblade_reflection_slow:OnCreated(keys)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
end

function modifier_imba_terrorblade_reflection_slow:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_terrorblade_reflection_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

-----------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_REFLECTION_UNIT --
-----------------------------------------------

-- Textures for illusions don't work like this
-- function modifier_imba_terrorblade_reflection_unit:GetStatusEffectName()
-- return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
-- end

-- function modifier_imba_terrorblade_reflection_unit:StatusEffectPriority()
-- return MODIFIER_PRIORITY_SUPER_ULTRA
-- end	

function modifier_imba_terrorblade_reflection_unit:IsPurgable() return false end

function modifier_imba_terrorblade_reflection_unit:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_imba_terrorblade_reflection_unit:OnCreated(keys)
	if not IsServer() then return end

	self.enemy_entindex = keys.enemy_entindex
end

function modifier_imba_terrorblade_reflection_unit:CheckState()
	if EntIndexToHScript(self.enemy_entindex) and not EntIndexToHScript(self.enemy_entindex):IsNull() and self:GetParent():IsAlive() and EntIndexToHScript(self.enemy_entindex):IsAlive() then
		if not EntIndexToHScript(self.enemy_entindex):IsInvisible() or self:GetParent():CanEntityBeSeenByMyTeam(EntIndexToHScript(self.enemy_entindex)) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.enemy_entindex
			})
		else
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = EntIndexToHScript(self.enemy_entindex):GetAbsOrigin()
			})
		end
	else
		self:GetParent():ForceKill(false)
	end
end

function modifier_imba_terrorblade_reflection_unit:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

function modifier_imba_terrorblade_reflection_unit:OnDeath(keys)
	if EntIndexToHScript(self.enemy_entindex) and not EntIndexToHScript(self.enemy_entindex):IsNull() and keys.unit == EntIndexToHScript(self.enemy_entindex) and keys.unit:IsRealHero() and
		self:GetParent():GetOwner() and self:GetParent():GetOwner():GetAssignedHero() and self:GetParent():GetOwner():GetAssignedHero():HasModifier("modifier_imba_terrorblade_reflection_infinity_mirror_stacks") then
		self:GetParent():GetOwner():GetAssignedHero():FindModifierByName("modifier_imba_terrorblade_reflection_infinity_mirror_stacks"):IncrementStackCount()
	end
end

-----------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_REFLECTION_INFINITY_MIRROR_STACKS --
-----------------------------------------------------------------

function modifier_imba_terrorblade_reflection_infinity_mirror_stacks:IsPurgable() return false end

function modifier_imba_terrorblade_reflection_infinity_mirror_stacks:RemoveOnDeath() return false end

function modifier_imba_terrorblade_reflection_infinity_mirror_stacks:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP }
end

function modifier_imba_terrorblade_reflection_infinity_mirror_stacks:OnTooltip(keys)
	if self:GetAbility() then
		if keys.fail_type == 0 then
			return self:GetAbility():GetSpecialValueFor("range") + (self:GetAbility():GetSpecialValueFor("infinity_radius_per_stack") * self:GetStackCount())
		elseif keys.fail_type == 1 then
			return self:GetAbility():GetSpecialValueFor("illusion_duration") + (self:GetAbility():GetSpecialValueFor("infinity_duration_per_stack") * self:GetStackCount())
		end
	end
end

------------------------------------
-- IMBA_TERRORBLADE_CONJURE_IMAGE --
------------------------------------

-- IMBAfication: Optimal Creation
function imba_terrorblade_conjure_image:GetIntrinsicModifierName()
	return "modifier_imba_terrorblade_conjure_image_autocast"
end

function imba_terrorblade_conjure_image:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_Terrorblade.ConjureImage")

	if self:GetCaster():GetName() == "npc_dota_hero_terrorblade" then
		if RollPercentage(2) then
			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				EmitSoundOnClient("terrorblade_terr_morph_conjureimage_03", self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient("terrorblade_terr_conjureimage_03", self:GetCaster():GetPlayerOwner())
			end
		elseif RollPercentage(3) then
			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				EmitSoundOnClient("terrorblade_terr_morph_conjureimage_01", self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient("terrorblade_terr_conjureimage_01", self:GetCaster():GetPlayerOwner())
			end
		elseif RollPercentage(20) then
			if not self.responses then
				self.responses =
				{
					"terrorblade_terr_conjureimage_02",
					"terrorblade_terr_demon_09",
					"terrorblade_terr_demon_10",
					"terrorblade_terr_demon_11",
				}
			end

			if not self.responses_morph then
				self.responses_morph =
				{
					"terrorblade_terr_morph_conjureimage_02",
					"terrorblade_terr_morph_demon_09",
					"terrorblade_terr_morph_demon_10",
					"terrorblade_terr_morph_demon_11",
				}
			end

			if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
				-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
				EmitSoundOnClient(self.responses_morph[RandomInt(1, #self.responses_morph)], self:GetCaster():GetPlayerOwner())
			else
				EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
			end
		end
	end

	local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
		outgoing_damage           = self:GetSpecialValueFor("illusion_outgoing_damage"),
		incoming_damage           = self:GetSpecialValueFor("illusion_incoming_damage"),
		bounty_base               = self:GetCaster():GetIllusionBounty(), -- Custom function but it should just be caster level * 2
		bounty_growth             = nil,
		outgoing_damage_structure = nil,
		outgoing_damage_roshan    = nil,
		duration                  = self:GetSpecialValueFor("illusion_duration")
	}
	, 1, 108, false, true)

	if illusions then
		for _, illusion in pairs(illusions) do
			-- Vanilla modifier to give the illusions that Terrorblade illusion texture
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_terrorblade_conjureimage", {})

			illusion:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
		end
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_CONJURE_IMAGE_AUTOCAST --
------------------------------------------------------

function modifier_imba_terrorblade_conjure_image_autocast:IsHidden() return true end

function modifier_imba_terrorblade_conjure_image_autocast:IsPurgable() return false end

function modifier_imba_terrorblade_conjure_image_autocast:RemoveOnDeath() return false end

function modifier_imba_terrorblade_conjure_image_autocast:CheckState()
	if not IsServer() then return end

	if self:GetAbility() and self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and not self:GetAbility():IsInAbilityPhase() and
		not self:GetCaster():IsHexed() and not self:GetCaster():IsNightmared() and not self:GetCaster():IsOutOfGame() and not self:GetCaster():IsSilenced() and not self:GetCaster():IsStunned() and not self:GetCaster():IsChanneling() and not self:GetCaster():HasModifier("modifier_imba_terrorblade_conjure_image_autocast_cooldown") then
		-- This is so you don't kill your machine when turning WTF mode on
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_terrorblade_conjure_image_autocast_cooldown", { duration = 1 })

		if self:GetCaster().GetPlayerID then
			if self:GetCaster():GetAggroTarget() then
				self:GetCaster():CastAbilityImmediately(self:GetAbility(), self:GetCaster():GetPlayerID())
			else
				self:GetCaster():CastAbilityNoTarget(self:GetAbility(), self:GetCaster():GetPlayerID())
			end
		elseif self:GetCaster().GetPlayerOwner and self:GetCaster():GetPlayerOwner().GetPlayerID then
			if self:GetCaster():GetAggroTarget() then
				self:GetCaster():CastAbilityImmediately(self:GetAbility(), self:GetCaster():GetPlayerOwner():GetPlayerID())
			else
				self:GetCaster():CastAbilityNoTarget(self:GetAbility(), self:GetCaster():GetPlayerOwner():GetPlayerID())
			end
		end
	end
end

---------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_CONJURE_IMAGE_AUTOCAST_COOLDOWN --
---------------------------------------------------------------

function modifier_imba_terrorblade_conjure_image_autocast_cooldown:IsDebuff() return true end

function modifier_imba_terrorblade_conjure_image_autocast_cooldown:IsHidden() return true end

function modifier_imba_terrorblade_conjure_image_autocast_cooldown:IsPurgable() return false end

function modifier_imba_terrorblade_conjure_image_autocast_cooldown:RemoveOnDeath() return false end

function modifier_imba_terrorblade_conjure_image_autocast_cooldown:IgnoreTenacity() return true end

------------------------------------
-- IMBA_TERRORBLADE_METAMORPHOSIS --
------------------------------------

function imba_terrorblade_metamorphosis:OnSpellStart()
	if not IsServer() then return end

	-- Hero_Terrorblade.Metamorphosis
	-- Hero_Terrorblade.Metamorphosis.Scepter
	-- Hero_Terrorblade.Metamorphosis.Fear
	self:GetCaster():EmitSound("Hero_Terrorblade.Metamorphosis")

	if self:GetCaster():GetName() == "npc_dota_hero_terrorblade" then
		if not self.responses then
			self.responses =
			{
				"terrorblade_terr_morph_metamorphosis_01",
				"terrorblade_terr_morph_metamorphosis_02",
				"terrorblade_terr_morph_metamorphosis_03",
				"terrorblade_terr_morph_metamorphosis_04",
				"terrorblade_terr_morph_metamorphosis_05",
				"terrorblade_terr_morph_metamorphosis_06",
				"terrorblade_terr_morph_metamorphosis_07",
				"terrorblade_terr_morph_metamorphosis_08",
				"terrorblade_terr_morph_metamorphosis_09",
				"terrorblade_terr_morph_demon_12",
				"terrorblade_terr_morph_demon_13",
				"terrorblade_terr_morph_demon_14"
			}
		end

		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end

	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)

	self:GetCaster():RemoveModifierByName("modifier_imba_terrorblade_metamorphosis")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_metamorphosis_transform", { duration = self:GetSpecialValueFor("transformation_time") })

	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("metamorph_aura_tooltip"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
		if unit ~= self:GetCaster() and unit:IsIllusion() and unit:GetPlayerOwnerID() == self:GetCaster():GetPlayerOwnerID() and unit:GetName() == self:GetCaster():GetName() then
			unit:RemoveModifierByName("modifier_imba_terrorblade_metamorphosis")
			unit:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_metamorphosis_transform", { duration = self:GetSpecialValueFor("transformation_time") })
		end
	end
end

-------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM --
-------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform:IsHidden() return true end

function modifier_imba_terrorblade_metamorphosis_transform:IsPurgable() return false end

function modifier_imba_terrorblade_metamorphosis_transform:OnCreated()
	self.duration = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end

	local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(transform_particle)

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_terrorblade_metamorphosis_transform_aura_applier", {})

	if self:GetParent():HasAbility("imba_terrorblade_terror_wave") then
		self:GetParent():FindAbilityByName("imba_terrorblade_terror_wave"):SetActivated(false)
	end
end

function modifier_imba_terrorblade_metamorphosis_transform:OnDestroy()
	if not IsServer() then return end

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_terrorblade_metamorphosis", { duration = self.duration })
end

function modifier_imba_terrorblade_metamorphosis_transform:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

---------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS --
---------------------------------------------

function modifier_imba_terrorblade_metamorphosis:IsPurgable() return false end

function modifier_imba_terrorblade_metamorphosis:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.bonus_range  = self:GetAbility():GetTalentSpecialValueFor("bonus_range")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.speed_loss   = self:GetAbility():GetSpecialValueFor("speed_loss") * (-1)

	if not IsServer() then return end

	self.previous_attack_cability = self:GetParent():GetAttackCapability()

	self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)

	if self:GetParent():HasAbility("imba_terrorblade_terror_wave") then
		if not self:GetParent():FindAbilityByName("imba_terrorblade_terror_wave"):IsTrained() then
			self:GetParent():FindAbilityByName("imba_terrorblade_terror_wave"):SetLevel(1)
		end

		self:GetParent():FindAbilityByName("imba_terrorblade_terror_wave"):SetActivated(true)
	end
end

function modifier_imba_terrorblade_metamorphosis:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3_END)

	self:GetParent():SetAttackCapability(self.previous_attack_cability)

	self:GetParent():RemoveModifierByName("modifier_imba_terrorblade_metamorphosis_transform_aura_applier")

	if self:GetParent():HasAbility("imba_terrorblade_terror_wave") then
		self:GetParent():FindAbilityByName("imba_terrorblade_terror_wave"):SetActivated(false)
	end
end

function modifier_imba_terrorblade_metamorphosis:CheckState()
	if not self:GetAbility() then
		self:Destroy()
		return
	end
end

function modifier_imba_terrorblade_metamorphosis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,

		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,

		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_imba_terrorblade_metamorphosis:GetModifierModelChange()
	return "models/heroes/terrorblade/demon.vmdl"
end

-- I can't tell if this is working at all
function modifier_imba_terrorblade_metamorphosis:GetAttackSound()
	return "Hero_Terrorblade_Morphed.Attack"
end

function modifier_imba_terrorblade_metamorphosis:GetModifierProjectileName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"
end

function modifier_imba_terrorblade_metamorphosis:OnAttackStart(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.preAttack")
	end
end

function modifier_imba_terrorblade_metamorphosis:OnAttack(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.Attack")
	end
end

function modifier_imba_terrorblade_metamorphosis:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		self:GetParent():EmitSound("Hero_Terrorblade_Morphed.projectileImpact")
	end
end

-- "Using Metamorphosis does not increase Rubick's attack range."
function modifier_imba_terrorblade_metamorphosis:GetModifierAttackRangeBonus()
	if self:GetParent():GetName() ~= "npc_dota_hero_rubick" then
		return self.bonus_range
	end
end

function modifier_imba_terrorblade_metamorphosis:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_imba_terrorblade_metamorphosis:GetModifierMoveSpeedBonus_Constant()
	return self.speed_loss
end

------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM_AURA --
------------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform_aura:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	if not IsServer() then return end

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_terrorblade_metamorphosis_transform", { duration = self:GetAbility():GetSpecialValueFor("transformation_time") })
end

function modifier_imba_terrorblade_metamorphosis_transform_aura:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveModifierByName("modifier_imba_terrorblade_metamorphosis_transform")
	self:GetParent():RemoveModifierByName("modifier_imba_terrorblade_metamorphosis")
end

--------------------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_TRANSFORM_AURA_APPLIER --
--------------------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:OnCreated()
	self.metamorph_aura_tooltip = self:GetAbility():GetSpecialValueFor("metamorph_aura_tooltip")
end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsHidden() return true end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsAura() return true end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:IsAuraActiveOnDeath() return false end

-- "The transformation aura's buff lingers for 1 second."
function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraDuration() return 1 end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraRadius() return self.metamorph_aura_tooltip end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetModifierAura() return "modifier_imba_terrorblade_metamorphosis_transform_aura" end

function modifier_imba_terrorblade_metamorphosis_transform_aura_applier:GetAuraEntityReject(hTarget) return hTarget == self:GetParent() or self:GetParent():IsIllusion() or not hTarget:IsIllusion() or hTarget:GetPlayerOwnerID() ~= self:GetCaster():GetPlayerOwnerID() or hTarget:HasModifier("modifier_terrorblade_reflection_invulnerability") end

----------------------------------
-- IMBA_TERRORBLADE_TERROR_WAVE --
----------------------------------

function imba_terrorblade_terror_wave:IsInnateAbility() return true end

function imba_terrorblade_terror_wave:IsDisabledByDefault() return true end

-- The wave is released 0.6 seconds after cast, starting at the original cast location.
-- The cast sound is global and audible to the enemy through the fog of war.
-- The wave travels outwards at a speed of 1000, taking 1.6 seconds to reach max radius.
function imba_terrorblade_terror_wave:OnSpellStart()
	if not IsServer() then return end

	EmitGlobalSound("Hero_Terrorblade.Metamorphosis.Scepter")

	CreateModifierThinker(self:GetCaster(), self, "modifier_imba_terrorblade_metamorphosis_fear_thinker", { duration = self:GetSpecialValueFor("spawn_delay") + (self:GetSpecialValueFor("radius") / self:GetSpecialValueFor("speed")) }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

----------------------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_METAMORPHOSIS_FEAR_THINKER --
----------------------------------------------------------

function modifier_imba_terrorblade_metamorphosis_fear_thinker:OnCreated()
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.fear_duration = self:GetAbility():GetSpecialValueFor("fear_duration")
	self.radius        = self:GetAbility():GetSpecialValueFor("radius")
	self.speed         = self:GetAbility():GetSpecialValueFor("speed")
	self.spawn_delay   = self:GetAbility():GetSpecialValueFor("spawn_delay")

	if not IsServer() then return end

	self.bLaunched     = false
	self.feared_units  = {}
	self.fear_modifier = nil

	self:StartIntervalThink(self.spawn_delay)
end

-- Once again, wiki says nothing about a width (might be 1 for all I know, but I'll arbitrarily make it 50)
function modifier_imba_terrorblade_metamorphosis_fear_thinker:OnIntervalThink()
	if not self.bLaunched then
		self.bLaunched = true

		local wave_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_scepter.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(wave_particle, 0, self:GetParent():GetAbsOrigin())
		-- Yeah, this particle CP doesn't actually match the speed (vanilla uses 1400 as CP value, while the speed is 1600)
		ParticleManager:SetParticleControl(wave_particle, 1, Vector(self.speed, self.speed, self.speed))
		ParticleManager:SetParticleControl(wave_particle, 2, Vector(self.speed, self.speed, self.speed))
		ParticleManager:ReleaseParticleIndex(wave_particle)

		self:StartIntervalThink(-1)
		self:StartIntervalThink(FrameTime())
	else
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, math.min(self.speed * (self:GetElapsedTime() - self.spawn_delay), self.radius), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if not self.feared_units[enemy:entindex()] and (enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= math.min(self.speed * (self:GetElapsedTime() - self.spawn_delay), self.radius) - 50 then
				enemy:EmitSound("Hero_Terrorblade.Metamorphosis.Fear")

				-- Vanilla fear modifier
				self.fear_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_terrorblade_fear", { duration = self.fear_duration })

				if self.fear_modifier then
					self.fear_modifier:SetDuration(self.fear_duration * (1 - enemy:GetStatusResistance()), true)
				end

				self.feared_units[enemy:entindex()] = true
			end
		end
	end
end

---------------------------------
-- IMBA_TERRORBLADE_POWER_REND --
---------------------------------

function imba_terrorblade_power_rend:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_CUSTOM
	elseif not target.GetStrength then
		return UF_FAIL_OTHER
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	end
end

function imba_terrorblade_power_rend:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function imba_terrorblade_power_rend:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)

		if not self:IsTrained() then
			self:SetLevel(1)
		end
	else
		self:SetHidden(true)
	end
end

function imba_terrorblade_power_rend:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_terrorblade_power_rend:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	local caster_strength = self:GetCaster():GetStrength()
	local caster_agility = self:GetCaster():GetAgility()
	local caster_intellect = self:GetCaster():GetIntellect()

	local target_strength = target:GetStrength()
	local target_agility = target:GetAgility()
	local target_intellect = target:GetIntellect()

	self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")

	local rend_particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(rend_particle_1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(rend_particle_1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(rend_particle_1, 15, Vector(255, 0, 0))
	ParticleManager:SetParticleControl(rend_particle_1, 16, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(rend_particle_1)

	local rend_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(rend_particle_2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(rend_particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(rend_particle_2, 15, Vector(255, 0, 0))
	ParticleManager:SetParticleControl(rend_particle_2, 16, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(rend_particle_2)

	local caster_modifier = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_power_rend", { duration = self:GetSpecialValueFor("duration") })

	if caster_modifier then
		caster_modifier.strength_differential = target_strength - caster_strength
		caster_modifier.agility_differential = target_agility - caster_agility
		caster_modifier.intellect_differential = target_intellect - caster_intellect
	end

	local target_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_terrorblade_power_rend", { duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance()) })

	if target_modifier then
		target_modifier.strength_differential = caster_strength - target_strength
		target_modifier.agility_differential = caster_agility - target_agility
		target_modifier.intellect_differential = caster_intellect - target_intellect
	end
end

------------------------------------------
-- MODIFIER_IMBA_TERRORBLADE_POWER_REND --
------------------------------------------

function modifier_imba_terrorblade_power_rend:IsPurgable() return false end

function modifier_imba_terrorblade_power_rend:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_terrorblade_power_rend:OnCreated()
	if not IsServer() then return end

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_terrorblade_power_rend:OnIntervalThink()
	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end

	self:StartIntervalThink(-1)
end

function modifier_imba_terrorblade_power_rend:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_imba_terrorblade_power_rend:GetModifierBonusStats_Strength()
	if self.strength_differential then
		return self.strength_differential
	end
end

function modifier_imba_terrorblade_power_rend:GetModifierBonusStats_Agility()
	if self.agility_differential then
		return self.agility_differential
	end
end

function modifier_imba_terrorblade_power_rend:GetModifierBonusStats_Intellect()
	if self.intellect_differential then
		return self.intellect_differential
	end
end

-----------------------------
-- IMBA_TERRORBLADE_SUNDER --
-----------------------------

function imba_terrorblade_sunder:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_CUSTOM
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	end
end

function imba_terrorblade_sunder:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function imba_terrorblade_sunder:GetCooldown(level)
	if self.GetCursorTarget and self:GetCursorTarget() and self:GetCursorTarget():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and self:GetCursorTarget():IsMagicImmune() then
		return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_terrorblade_sunder_cooldown") + self:GetSpecialValueFor("spell_immunity_cooldown_increase")
	else
		return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_terrorblade_sunder_cooldown")
	end
end

function imba_terrorblade_sunder:OnSpellStart()
	if not IsServer() then return end

	local target = self:GetCursorTarget()

	if target:TriggerSpellAbsorb(self) then return end

	local caster_health_percent = self:GetCaster():GetHealthPercent()
	local target_health_percent = target:GetHealthPercent()

	self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
	target:EmitSound("Hero_Terrorblade.Sunder.Target")

	if self:GetCaster():GetName() == "npc_dota_hero_terrorblade" then
		if not self.responses then
			self.responses =
			{
				"terrorblade_terr_demonattack_08",
				"terrorblade_terr_sunder_01",
				"terrorblade_terr_sunder_02",
				"terrorblade_terr_sunder_04",
				"terrorblade_terr_sunder_05",
				"terrorblade_terr_sunder_07",
				"terrorblade_terr_sunder_08",
				"terrorblade_terr_sunder_09",
				"terrorblade_terr_sunder_10",
				"terrorblade_terr_sunder_11"
			}
		end

		if not self.responses_morph then
			self.responses_morph =
			{
				"terrorblade_terr_morph_demonattack_08",
				"terrorblade_terr_morph_sunder_01",
				"terrorblade_terr_morph_sunder_02",
				"terrorblade_terr_morph_sunder_04",
				"terrorblade_terr_morph_sunder_05",
				"terrorblade_terr_morph_sunder_07",
				"terrorblade_terr_morph_sunder_08",
				"terrorblade_terr_morph_sunder_09",
				"terrorblade_terr_morph_sunder_10",
				"terrorblade_terr_morph_sunder_11"
			}
		end

		if self:GetCaster():HasModifier("modifier_imba_terrorblade_metamorphosis") then
			-- WHy isn't there a function that plays only on one unit but not on client? This function doesn't make the sound come out of the unit which is wrong, but no one else is supposed to hear these voicelines either. Ugh...
			EmitSoundOnClient(self.responses_morph[RandomInt(1, #self.responses_morph)], self:GetCaster():GetPlayerOwner())
		else
			EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		end
	end

	local sunder_particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(sunder_particle_1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(sunder_particle_1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(sunder_particle_1)

	local sunder_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(sunder_particle_2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(sunder_particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(sunder_particle_2)

	self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * math.max(target_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) / 100)
	target:SetHealth(target:GetMaxHealth() * math.max(caster_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) / 100)
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_terrorblade_reflection_cooldown", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_terrorblade_sunder_cooldown", "components/abilities/heroes/hero_terrorblade", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_terrorblade_reflection_cooldown        = modifier_special_bonus_imba_terrorblade_reflection_cooldown or class({})
modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range = modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range or class({})
modifier_special_bonus_imba_terrorblade_sunder_cooldown            = modifier_special_bonus_imba_terrorblade_sunder_cooldown or class({})

function modifier_special_bonus_imba_terrorblade_reflection_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_terrorblade_reflection_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_terrorblade_reflection_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:IsHidden() return true end

function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:IsPurgable() return false end

function modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range:RemoveOnDeath() return false end

function modifier_special_bonus_imba_terrorblade_sunder_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_terrorblade_sunder_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_terrorblade_sunder_cooldown:RemoveOnDeath() return false end

function imba_terrorblade_reflection:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_reflection_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_reflection_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_reflection_cooldown"), "modifier_special_bonus_imba_terrorblade_reflection_cooldown", {})
	end
end

function imba_terrorblade_metamorphosis:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_metamorphosis_attack_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_metamorphosis_attack_range"), "modifier_special_bonus_imba_terrorblade_metamorphosis_attack_range", {})
	end
end

function imba_terrorblade_sunder:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_terrorblade_sunder_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_terrorblade_sunder_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_terrorblade_sunder_cooldown"), "modifier_special_bonus_imba_terrorblade_sunder_cooldown", {})
	end
end
