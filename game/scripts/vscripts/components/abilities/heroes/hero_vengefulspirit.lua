-- Editors:
--     Firetoad
--     AtroCty, 20.04.2017

LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_4", "components/abilities/heroes/hero_vengefulspirit.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_vengefulspirit_4 = modifier_special_bonus_imba_vengefulspirit_4 or class({})

function modifier_special_bonus_imba_vengefulspirit_4:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_4:RemoveOnDeath() return false end

function modifier_special_bonus_imba_vengefulspirit_4:IsAura() return true end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraEntityReject(target)
	if IsServer() then
		-- Always reject caster
		if target == self:GetCaster() then
			return true
		end
		return false
	end
end

function modifier_special_bonus_imba_vengefulspirit_4:GetModifierAura()
	return "modifier_imba_rancor_allies"
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraRadius()
	local caster = self:GetCaster()
	if caster:IsRealHero() then
		return self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_4", "radius")
	else
		return 0
	end
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_special_bonus_imba_vengefulspirit_4:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

-------------------------------------------
--				 RANCOR
-------------------------------------------
LinkLuaModifier("modifier_imba_rancor", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rancor_stack", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_rancor_allies", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_rancor = class({})
function imba_vengefulspirit_rancor:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_rancor:IsRefreshable() return false end

function imba_vengefulspirit_rancor:IsStealable() return false end

function imba_vengefulspirit_rancor:IsNetherWardStealable() return false end

function imba_vengefulspirit_rancor:IsInnateAbility() return true end

function imba_vengefulspirit_rancor:GetAbilityTextureName()
	return "vengeful_rancor"
end

-------------------------------------------

function imba_vengefulspirit_rancor:GetIntrinsicModifierName()
	return "modifier_imba_rancor"
end

-------------------------------------------
modifier_imba_rancor = class({})
function modifier_imba_rancor:IsDebuff() return false end

function modifier_imba_rancor:IsHidden() return true end

function modifier_imba_rancor:IsPurgable() return false end

function modifier_imba_rancor:IsPurgeException() return false end

function modifier_imba_rancor:IsStunDebuff() return false end

-------------------------------------------

function modifier_imba_rancor:OnCreated()
	self.dmg_received_pct = self.dmg_received_pct or 0
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
end

function modifier_imba_rancor:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_imba_rancor:OnTakeDamage(params)
	if self:GetAbility() and ((self:GetParent() == params.unit) or params.unit:HasModifier("modifier_imba_rancor_allies")) and params.damage > 0 and not self:GetParent():PassivesDisabled() and params.unit:IsRealHero() then
		-- Check for Rancor Talent for allied damage
		if params.unit:HasModifier("modifier_imba_rancor_allies") and not (self:GetParent() == params.unit) then
			if params.unit:FindModifierByNameAndCaster("modifier_imba_rancor_allies", self:GetParent()) then
				self.dmg_received_pct = self.dmg_received_pct + ((100 / self:GetParent():GetMaxHealth()) * math.min(params.damage, self:GetParent():GetHealth())) * (self:GetParent():FindTalentValue("special_bonus_imba_vengefulspirit_4", "rate_pct") / 100)
			end
		else
			-- Calculates percentage of damage taken relative to max health
			self.dmg_received_pct = self.dmg_received_pct + ((100 / self:GetParent():GetMaxHealth()) * math.min(params.damage, self:GetParent():GetHealth()))
		end

		while (self.dmg_received_pct >= self:GetAbility():GetSpecialValueFor("stack_receive_pct")) do
			if self:GetParent():HasModifier("modifier_imba_rancor_stack") then
				local modifier = self:GetParent():FindModifierByName("modifier_imba_rancor_stack")
				-- Adding a limit to prevent possible exploits
				if modifier:GetStackCount() < self.max_stacks then
					modifier:IncrementStackCount()
				end
			else
				local modifier = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_rancor_stack", {})
				modifier:SetStackCount(1)
			end
			self.dmg_received_pct = self.dmg_received_pct - self:GetAbility():GetSpecialValueFor("stack_receive_pct")
		end
	end
end

-------------------------------------------
modifier_imba_rancor_allies = class({})
function modifier_imba_rancor_allies:IsDebuff() return false end

function modifier_imba_rancor_allies:IsHidden() return true end

function modifier_imba_rancor_allies:IsPurgable() return false end

function modifier_imba_rancor_allies:IsPurgeException() return false end

function modifier_imba_rancor_allies:IsStunDebuff() return false end

function modifier_imba_rancor_allies:RemoveOnDeath() return false end

-------------------------------------------
modifier_imba_rancor_stack = class({})
function modifier_imba_rancor_stack:IsDebuff() return false end

function modifier_imba_rancor_stack:IsHidden() return false end

function modifier_imba_rancor_stack:IsPurgable() return false end

function modifier_imba_rancor_stack:IsPurgeException() return false end

function modifier_imba_rancor_stack:IsStunDebuff() return false end

function modifier_imba_rancor_stack:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_rancor_stack:OnCreated()
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")

	if IsServer() then
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("stack_duration"))
	end
end

function modifier_imba_rancor_stack:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() then
			if self:GetStackCount() == 1 then
				self:Destroy()
			else
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_imba_rancor_stack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_imba_rancor_stack:GetModifierSpellAmplify_Percentage()
	if self:GetAbility() then
		return (self:GetAbility():GetSpecialValueFor("spell_power") * self:GetStackCount())
	end
end

function modifier_imba_rancor_stack:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return (self:GetAbility():GetSpecialValueFor("damage_pct") * self:GetStackCount())
	end
end

function modifier_imba_rancor_stack:IsAura() return true end

function modifier_imba_rancor_stack:IsAuraActiveOnDeath() return true end

function modifier_imba_rancor_stack:GetModifierAura() return "modifier_imba_rancor_ally_aura" end

function modifier_imba_rancor_stack:GetAuraEntityReject(target) if target == self:GetCaster() then return true end end

function modifier_imba_rancor_stack:GetAuraRadius()
	if self:GetCaster():IsRealHero() and self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("aura_radius")
	end
end

function modifier_imba_rancor_stack:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end

function modifier_imba_rancor_stack:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_rancor_stack:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

------------------------------------
-- MODIFIER_IMBA_RANCOR_ALLY_AURA --
------------------------------------

LinkLuaModifier("modifier_imba_rancor_ally_aura", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

modifier_imba_rancor_ally_aura = modifier_imba_rancor_ally_aura or class({})

function modifier_imba_rancor_ally_aura:OnCreated()
	self.spell_power = self:GetAbility():GetSpecialValueFor("spell_power") * self:GetAbility():GetSpecialValueFor("aura_efficiency") / 100
	self.damage_pct  = self:GetAbility():GetSpecialValueFor("damage_pct") * self:GetAbility():GetSpecialValueFor("aura_efficiency") / 100

	if not IsServer() then return end

	self.modifier = self:GetAuraOwner():FindModifierByName("modifier_imba_rancor_stack")

	if not self.modifier then self:Destroy() end

	self:StartIntervalThink(0.1)
end

function modifier_imba_rancor_ally_aura:OnIntervalThink()
	if self.modifier and not self.modifier:IsNull() then
		self:SetStackCount(self.modifier:GetStackCount())
	else
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_imba_rancor_ally_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_imba_rancor_ally_aura:GetModifierSpellAmplify_Percentage()
	return (self.spell_power * self:GetStackCount())
end

function modifier_imba_rancor_ally_aura:GetModifierPreAttack_BonusDamage()
	return (self.damage_pct * self:GetStackCount())
end

-------------------------------------------
--            MAGIC MISSILE
-------------------------------------------

imba_vengefulspirit_magic_missile = class({})
function imba_vengefulspirit_magic_missile:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_magic_missile:IsRefreshable() return true end

function imba_vengefulspirit_magic_missile:IsStealable() return true end

function imba_vengefulspirit_magic_missile:IsNetherWardStealable() return true end

-------------------------------------------

function imba_vengefulspirit_magic_missile:GetAOERadius()
	return self:GetTalentSpecialValueFor("split_radius")
end

function imba_vengefulspirit_magic_missile:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_11")
end

function imba_vengefulspirit_magic_missile:CastFilterResultTarget(target)
	if not self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_5") then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
	end
end

function imba_vengefulspirit_magic_missile:OnSpellStart(params, reduce_pct, target_loc, ix)
	if IsServer() then
		local caster = self:GetCaster()
		local target
		if params then
			target = params
		else
			target = self:GetCursorTarget()
		end

		-- Parameters
		local damage = self:GetTalentSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local split_radius = self:GetSpecialValueFor("split_radius")
		local split_reduce_pct = self:GetSpecialValueFor("split_reduce_pct")
		local split_amount = self:GetSpecialValueFor("split_amount")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local index

		-- Create an unique index, else use the old
		if ix then
			index = ix
		else
			index = DoUniqueString("projectile")
			proj_index = "projectile_" .. index
			-- Finished traveling counter
			self[index] = 0
			-- Already hit targets
			self[proj_index] = {}
			table.insert(self[proj_index], target)
		end

		-- Reduce damage and stun duration if this is a secondary, else emit cast-sound
		if reduce_pct then
			damage = math.ceil(damage - (damage * (reduce_pct / 100)))
			stun_duration = stun_duration - (stun_duration * (reduce_pct / 100))
			split_reduce_pct = reduce_pct + (reduce_pct * (split_reduce_pct / 100))
		else
			caster:EmitSound("Hero_VengefulSpirit.MagicMissile")
			if (math.random(1, 100) <= 5) and (caster:GetName() == "npc_dota_hero_vengefulspirit") then
				caster:EmitSound("vengefulspirit_vng_cast_05")
			end
		end

		local projectile
		if params then
			projectile =
			{
				Target            = target,
				Source            = target_loc,
				Ability           = self,
				EffectName        = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
				iMoveSpeed        = projectile_speed,
				bDrawsOnMinimap   = false,
				bDodgeable        = true,
				bIsAttack         = false,
				bVisibleToEnemies = true,
				bReplaceExisting  = false,
				flExpireTime      = GameRules:GetGameTime() + 10,
				bProvidesVision   = false,
				--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
				--	iVisionRadius 		= 400,
				--	iVisionTeamNumber 	= caster:GetTeamNumber()
				ExtraData         = { index = index, target_index = target:GetEntityIndex(), damage = damage, stun_duration = stun_duration, split_radius = split_radius, split_reduce_pct = split_reduce_pct, split_amount = split_amount }
			}
		else
			projectile =
			{
				Target            = target,
				Source            = caster,
				Ability           = self,
				EffectName        = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
				iMoveSpeed        = projectile_speed,
				vSpawnOrigin      = caster:GetAbsOrigin(),
				bDrawsOnMinimap   = false,
				bDodgeable        = true,
				bIsAttack         = false,
				bVisibleToEnemies = true,
				bReplaceExisting  = false,
				flExpireTime      = GameRules:GetGameTime() + 10,
				bProvidesVision   = false,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
				--	iVisionRadius 		= 400,
				--	iVisionTeamNumber 	= caster:GetTeamNumber()
				ExtraData         = { index = index, target_index = target:GetEntityIndex(), damage = damage, stun_duration = stun_duration, split_radius = split_radius, split_reduce_pct = split_reduce_pct, split_amount = split_amount }
			}
		end
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function imba_vengefulspirit_magic_missile:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		local caster = self:GetCaster()
		local proj_index = "projectile_" .. ExtraData.index
		self[ExtraData.index] = self[ExtraData.index] + 1
		if target then
			if #self[proj_index] == 1 then
				if target:TriggerSpellAbsorb(self) then
					return nil
				end
			end
			ApplyDamage({ victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType() })
			if (not target:IsMagicImmune()) or caster:HasTalent("special_bonus_imba_vengefulspirit_5") then
				target:AddNewModifier(caster, self, "modifier_stunned", { duration = ExtraData.stun_duration * (1 - target:GetStatusResistance()) })
			end
		end

		EmitSoundOnLocationWithCaster(location, "Hero_VengefulSpirit.MagicMissileImpact", caster)

		local valid_targets = {}
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ExtraData.split_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, enemy in ipairs(enemies) do
			local already_hit = false
			for _, stored_target in ipairs(self[proj_index]) do
				if stored_target == enemy then
					already_hit = true
					break
				end
			end
			if not already_hit then
				table.insert(valid_targets, enemy)
			end
		end
		local target_missiles = math.min(#valid_targets, ExtraData.split_amount)

		if target then
			for i = 1, target_missiles do
				self:OnSpellStart(valid_targets[i], ExtraData.split_reduce_pct, target, ExtraData.index)
				table.insert(self[proj_index], valid_targets[i])
			end
		end
		-- Delete these variables if no more targets are avaible
		if self[ExtraData.index] == #self[proj_index] then
			self[ExtraData.index] = nil
			self[proj_index] = nil
		end
	end
end

-------------------------------------------
--          WAVE OF TERROR
-------------------------------------------

imba_vengefulspirit_wave_of_terror = class({})
function imba_vengefulspirit_wave_of_terror:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_wave_of_terror:IsRefreshable() return true end

function imba_vengefulspirit_wave_of_terror:IsStealable() return true end

function imba_vengefulspirit_wave_of_terror:IsNetherWardStealable() return true end

function imba_vengefulspirit_wave_of_terror:GetAbilityTextureName()
	return "vengefulspirit_wave_of_terror"
end

-------------------------------------------
LinkLuaModifier("modifier_imba_wave_of_terror", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

function imba_vengefulspirit_wave_of_terror:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_10")
end

function imba_vengefulspirit_wave_of_terror:OnSpellStart()
	if IsServer() then
		-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
		if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
			self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
		end

		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local speed = self:GetSpecialValueFor("wave_speed")
		local wave_width = self:GetSpecialValueFor("wave_width")
		local duration = self:GetSpecialValueFor("duration")
		local primary_distance = self:GetCastRange(caster_loc, caster) + GetCastRangeIncrease(caster)
		local vision_aoe = self:GetSpecialValueFor("vision_aoe")
		local vision_duration = self:GetSpecialValueFor("vision_duration")

		local dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		dummy:EmitSound("Hero_VengefulSpirit.WaveOfTerror")

		if caster:GetName() == "npc_dota_hero_vengefulspirit" then
			caster:EmitSound("vengefulspirit_vng_ability_0" .. math.random(1, 9))
		end

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()
		local velocity = direction * speed

		local projectile =
		{
			Ability           = self,
			EffectName        = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
			vSpawnOrigin      = caster_loc,
			fDistance         = primary_distance,
			fStartRadius      = wave_width,
			fEndRadius        = wave_width,
			Source            = caster,
			bHasFrontalCone   = false,
			bReplaceExisting  = false,
			iUnitTargetTeam   = self:GetAbilityTargetTeam(),
			iUnitTargetFlags  = self:GetAbilityTargetFlags(),
			iUnitTargetType   = self:GetAbilityTargetType(),
			fExpireTime       = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit      = false,
			vVelocity         = Vector(velocity.x, velocity.y, 0),
			bProvidesVision   = true,
			iVisionRadius     = vision_aoe,
			iVisionTeamNumber = caster:GetTeamNumber(),
			ExtraData         = { damage = damage, duration = duration, dummy_entindex = dummy:entindex() }
		}
		ProjectileManager:CreateLinearProjectile(projectile)

		-- Vision geometry
		local current_distance = vision_aoe / 2
		local tick_rate = vision_aoe / speed / 2

		-- -- Provide vision along the projectile's path
		-- Timers:CreateTimer(0, function()
		-- local current_vision_location = caster_loc + direction * current_distance

		-- self:CreateVisibilityNode(current_vision_location, vision_aoe, vision_duration)
		-- dummy:SetAbsOrigin(current_vision_location)

		-- current_distance = current_distance + vision_aoe / 2
		-- if current_distance < primary_distance then
		-- return tick_rate
		-- end
		-- end)
	end
end

function imba_vengefulspirit_wave_of_terror:OnProjectileThink_ExtraData(location, ExtraData)
	if ExtraData.dummy_entindex then
		AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self:GetSpecialValueFor("vision_aoe"), self:GetSpecialValueFor("vision_duration"), false)
		EntIndexToHScript(ExtraData.dummy_entindex):SetAbsOrigin(location)
	end
end

function imba_vengefulspirit_wave_of_terror:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		ApplyDamage({ victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType() })
		target:AddNewModifier(caster, self, "modifier_imba_wave_of_terror", { duration = ExtraData.duration * (1 - target:GetStatusResistance()) })
	else
		-- self:CreateVisibilityNode(location, self:GetSpecialValueFor("vision_aoe"), self:GetSpecialValueFor("vision_duration"))

		if ExtraData.dummy_entindex then
			EntIndexToHScript(ExtraData.dummy_entindex):ForceKill(false)
		end
	end
	return false
end

-------------------------------------------
modifier_imba_wave_of_terror = class({})
function modifier_imba_wave_of_terror:IsDebuff() return true end

function modifier_imba_wave_of_terror:IsHidden() return false end

function modifier_imba_wave_of_terror:IsPurgable() return true end

function modifier_imba_wave_of_terror:IsStunDebuff() return false end

function modifier_imba_wave_of_terror:RemoveOnDeath() return true end

-------------------------------------------

function modifier_imba_wave_of_terror:OnCreated(params)
	local ability = self:GetAbility()

	if not ability then
		self:Destroy()
		return
	end

	self.armor_reduction = ability:GetTalentSpecialValueFor("armor_reduction") * (-1)
	self.atk_reduction_pct = ability:GetSpecialValueFor("atk_reduction_pct") * (-1)
end

function modifier_imba_wave_of_terror:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_imba_wave_of_terror:GetModifierPhysicalArmorBonus()
	return self.armor_reduction
end

function modifier_imba_wave_of_terror:GetModifierBaseDamageOutgoing_Percentage()
	return self.atk_reduction_pct
end

function modifier_imba_wave_of_terror:GetEffectName()
	return "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror_recipient.vpcf"
end

function modifier_imba_wave_of_terror:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

-------------------------------------------
--            VENGEANCE AURA
-------------------------------------------
LinkLuaModifier("modifier_imba_command_aura_positive", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_positive_aura", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_negative", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_command_aura_negative_aura", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_command_aura = class({})
function imba_vengefulspirit_command_aura:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_command_aura:IsRefreshable() return false end

function imba_vengefulspirit_command_aura:IsStealable() return false end

function imba_vengefulspirit_command_aura:IsNetherWardStealable() return false end

function imba_vengefulspirit_command_aura:GetAbilityTextureName()
	return "vengefulspirit_command_aura"
end

-------------------------------------------

function imba_vengefulspirit_command_aura:GetIntrinsicModifierName()
	return "modifier_imba_command_aura_positive_aura"
end

function imba_vengefulspirit_command_aura:OnOwnerDied()
	if self:IsTrained() and not self:GetCaster():IsIllusion() and not self:GetCaster():PassivesDisabled() then
		local num_illusions_on_death = self:GetSpecialValueFor("num_illusions_on_death")
		local bounty_base            = self:GetCaster():GetIllusionBounty()

		if self:GetCaster():GetLevel() >= self:GetSpecialValueFor("illusion_upgrade_level") then
			num_illusions_on_death = self:GetSpecialValueFor("num_illusions_on_death_upgrade")
		end

		if self:GetCaster():HasScepter() then
			bounty_base = 0
		end

		local super_illusions = CreateIllusions(self:GetCaster(), self:GetCaster(),
			{
				outgoing_damage           = 100 - self:GetSpecialValueFor("illusion_damage_out_pct"),
				incoming_damage           = self:GetSpecialValueFor("illusion_damage_in_pct") - 100,
				bounty_base               = bounty_base,
				bounty_growth             = nil,
				outgoing_damage_structure = nil,
				outgoing_damage_roshan    = nil,
				duration                  = nil
			}
			, num_illusions_on_death, self:GetCaster():GetHullRadius(), true, true)

		for _, illusion in pairs(super_illusions) do
			illusion:SetHealth(illusion:GetMaxHealth())
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_vengefulspirit_hybrid_special", {}) -- speshul snowflek modifier from vanilla
			-- "The illusion spawns 108 range away from Vengeful Spirit's death location. It appears either north, east, south or west from that spot."
			FindClearSpaceForUnit(illusion, self:GetCaster():GetAbsOrigin() + Vector(RandomInt(0, 1), RandomInt(0, 1), 0) * 108, true)

			PlayerResource:NewSelection(self:GetCaster():GetPlayerID(), super_illusions)
		end
	end
end

-- Positive Aura Effects
-------------------------------------------
modifier_imba_command_aura_positive = class({})
function modifier_imba_command_aura_positive:IsDebuff() return false end

function modifier_imba_command_aura_positive:IsHidden() return false end

function modifier_imba_command_aura_positive:IsPurgable() return false end

function modifier_imba_command_aura_positive:IsPurgeException() return false end

function modifier_imba_command_aura_positive:IsStunDebuff() return false end

function modifier_imba_command_aura_positive:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_command_aura_positive:OnCreated()
	self.spell_power      = self:GetAbility():GetSpecialValueFor("spell_power") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "spell_power")
	self.bonus_damage_pct = self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")
end

function modifier_imba_command_aura_positive:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_command_aura_positive:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end

function modifier_imba_command_aura_positive:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster() then
		if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
			return 0
		else
			return self.bonus_damage_pct
		end
	end
end

function modifier_imba_command_aura_positive:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster() then
		if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
			return self.bonus_damage_pct
		else
			return 0
		end
	end
end

-------------------------------------------
modifier_imba_command_aura_positive_aura = class({})
function modifier_imba_command_aura_positive_aura:IsAura() return true end

function modifier_imba_command_aura_positive_aura:IsDebuff() return false end

function modifier_imba_command_aura_positive_aura:IsHidden() return true end

function modifier_imba_command_aura_positive_aura:IsPurgable() return false end

function modifier_imba_command_aura_positive_aura:IsPurgeException() return false end

function modifier_imba_command_aura_positive_aura:IsStunDebuff() return false end

function modifier_imba_command_aura_positive_aura:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_command_aura_positive_aura:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return decFuncs
end

function modifier_imba_command_aura_positive_aura:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			-- If this is an illusion, do nothing
			if not params.unit:IsRealHero() then
				return nil
			end
			local ability = self:GetAbility()
			ability.enemy_modifier = params.attacker:AddNewModifier(params.unit, ability, "modifier_imba_command_aura_negative_aura", {})
		end
	end
end

function modifier_imba_command_aura_positive_aura:GetAuraEntityReject(target)
	if IsServer() then
		if self:GetParent():PassivesDisabled() then return true end
		return false
	end
end

function modifier_imba_command_aura_positive_aura:GetModifierAura()
	return "modifier_imba_command_aura_positive"
end

function modifier_imba_command_aura_positive_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_command_aura_positive_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-------------------------------------------
modifier_imba_command_aura_negative = class({})
function modifier_imba_command_aura_negative:IsDebuff() return true end

function modifier_imba_command_aura_negative:IsHidden() return false end

function modifier_imba_command_aura_negative:IsPurgable() return false end

function modifier_imba_command_aura_negative:IsPurgeException() return false end

function modifier_imba_command_aura_negative:IsStunDebuff() return false end

function modifier_imba_command_aura_negative:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_command_aura_negative:OnCreated()
	self.spell_power      = (self:GetAbility():GetSpecialValueFor("spell_power") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "spell_power")) * (-1)
	self.bonus_damage_pct = (self:GetAbility():GetSpecialValueFor("bonus_damage_pct") + self:GetCaster():FindTalentValue("special_bonus_imba_vengefulspirit_3", "bonus_damage_pct")) * (-1)
end

function modifier_imba_command_aura_negative:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return decFuncs
end

function modifier_imba_command_aura_negative:GetModifierSpellAmplify_Percentage()
	return self.spell_power
end

function modifier_imba_command_aura_negative:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
		return 0
	else
		return self.bonus_damage_pct
	end
end

function modifier_imba_command_aura_negative:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") then
		return self.bonus_damage_pct
	else
		return 0
	end
end

-------------------------------------------
modifier_imba_command_aura_negative_aura = class({})
function modifier_imba_command_aura_negative_aura:IsAura() return true end

function modifier_imba_command_aura_negative_aura:IsDebuff() return true end

function modifier_imba_command_aura_negative_aura:IsHidden() return true end

function modifier_imba_command_aura_negative_aura:IsPurgable() return false end

function modifier_imba_command_aura_negative_aura:IsPurgeException() return false end

function modifier_imba_command_aura_negative_aura:IsStunDebuff() return false end

function modifier_imba_command_aura_negative_aura:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_command_aura_negative_aura:OnCreated()
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_command_aura_negative_aura:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_EVENT_ON_RESPAWN
	}
	return decFuns
end

function modifier_imba_command_aura_negative_aura:OnRespawn(params)
	if IsServer() then
		if (self:GetCaster() == params.unit) then
			self:Destroy()
		end
	end
end

function modifier_imba_command_aura_negative_aura:GetModifierAura()
	return "modifier_imba_command_aura_negative"
end

function modifier_imba_command_aura_negative_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_command_aura_negative_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

---

LinkLuaModifier("modifier_imba_vengefulspirit_command_aura_723", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vengefulspirit_command_aura_effect_723", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vengefulspirit_command_negative_aura_723", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_vengefulspirit_command_negative_aura_effect_723", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_command_aura_723                          = imba_vengefulspirit_command_aura_723 or class({})
modifier_imba_vengefulspirit_command_aura_723                 = modifier_imba_vengefulspirit_command_aura_723 or class({})
modifier_imba_vengefulspirit_command_aura_effect_723          = modifier_imba_vengefulspirit_command_aura_effect_723 or class({})
modifier_imba_vengefulspirit_command_negative_aura_723        = modifier_imba_vengefulspirit_command_negative_aura_723 or class({})
modifier_imba_vengefulspirit_command_negative_aura_effect_723 = modifier_imba_vengefulspirit_command_negative_aura_effect_723 or class({})

------------------------------------------
-- IMBA_VENGEFULSPIRIT_COMMAND_AURA_723 --
------------------------------------------

function imba_vengefulspirit_command_aura_723:GetIntrinsicModifierName()
	return "modifier_imba_vengefulspirit_command_aura_723"
end

-- function imba_vengefulspirit_command_aura_723:OnOwnerDied()
-- if self:IsTrained() and not self:GetCaster():IsIllusion() and not self:GetCaster():PassivesDisabled() then
-- local num_illusions_on_death	= self:GetSpecialValueFor("num_illusions_on_death")
-- local bounty_base				= self:GetCaster():GetIllusionBounty()

-- if self:GetCaster():GetLevel() >= self:GetSpecialValueFor("illusion_upgrade_level") then
-- num_illusions_on_death		= self:GetSpecialValueFor("num_illusions_on_death_upgrade")
-- end

-- if self:GetCaster():HasScepter() then
-- bounty_base					= 0
-- end

-- local super_illusions = CreateIllusions(self:GetCaster(), self:GetCaster(),
-- {
-- outgoing_damage 			= 100 - self:GetSpecialValueFor("illusion_damage_out_pct"),
-- incoming_damage				= self:GetSpecialValueFor("illusion_damage_in_pct") - 100,
-- bounty_base					= bounty_base,
-- bounty_growth				= nil,
-- outgoing_damage_structure	= nil,
-- outgoing_damage_roshan		= nil,
-- duration					= nil
-- }
-- , num_illusions_on_death, self:GetCaster():GetHullRadius(), true, true)

-- for _, illusion in pairs(super_illusions) do
-- illusion:SetHealth(illusion:GetMaxHealth())
-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_vengefulspirit_hybrid_special", {}) -- speshul snowflek modifier from vanilla
-- -- "The illusion spawns 108 range away from Vengeful Spirit's death location. It appears either north, east, south or west from that spot."
-- FindClearSpaceForUnit(illusion, self:GetCaster():GetAbsOrigin() + Vector(RandomInt(0, 1), RandomInt(0, 1), 0) * 108, true)

-- PlayerResource:NewSelection(self:GetCaster():GetPlayerID(), super_illusions)
-- end
-- end
-- end

---------------------------------------------------
-- MODIFIER_IMBA_VENGEFULSPIRIT_COMMAND_AURA_723 --
---------------------------------------------------

function modifier_imba_vengefulspirit_command_aura_723:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_imba_vengefulspirit_command_aura_723:OnDeath(keys)
	if keys.unit == self:GetParent() and keys.unit:IsRealHero() then
		keys.attacker:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_vengefulspirit_command_negative_aura_723", {})

		self:GetCaster():SetContextThink(DoUniqueString(self:GetName()), function()
			for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)) do
				-- Lots of checks to attempt to extract the Vengeful Spirit strong illusion
				if unit:GetName() == self:GetCaster():GetName() and unit ~= self:GetCaster() and unit:GetOwner() and unit:GetOwner():GetAssignedHero() and unit:GetOwner():GetAssignedHero() == self:GetCaster() then
					-- Give modifiers for custom talents that require client-side stuff
					if unit:HasTalent("special_bonus_imba_vengefulspirit_5") and not unit:HasModifier("modifier_special_bonus_imba_vengefulspirit_5") then
						unit:AddNewModifier(unit, unit:FindAbilityByName("special_bonus_imba_vengefulspirit_5"), "modifier_special_bonus_imba_vengefulspirit_5", {})
					end

					if unit:HasTalent("special_bonus_imba_vengefulspirit_11") and not unit:HasModifier("modifier_special_bonus_imba_vengefulspirit_11") then
						unit:AddNewModifier(unit, unit:FindAbilityByName("special_bonus_imba_vengefulspirit_11"), "modifier_special_bonus_imba_vengefulspirit_11", {})
					end
				end
			end

			return nil
		end, FrameTime())
	end
end

function modifier_imba_vengefulspirit_command_aura_723:IsHidden() return true end

-- function modifier_imba_vengefulspirit_command_aura_723:IsAura()						return true end
-- function modifier_imba_vengefulspirit_command_aura_723:IsAuraActiveOnDeath() 		return false end

-- function modifier_imba_vengefulspirit_command_aura_723:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("aura_radius") end
-- function modifier_imba_vengefulspirit_command_aura_723:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end
-- function modifier_imba_vengefulspirit_command_aura_723:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
-- function modifier_imba_vengefulspirit_command_aura_723:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
-- function modifier_imba_vengefulspirit_command_aura_723:GetModifierAura()			return "modifier_imba_vengefulspirit_command_aura_effect_723" end
-- function modifier_imba_vengefulspirit_command_aura_723:GetAuraEntityReject(hTarget)	return self:GetCaster():PassivesDisabled() end

----------------------------------------------------------
-- MODIFIER_IMBA_VENGEFULSPIRIT_COMMAND_AURA_EFFECT_723 --
----------------------------------------------------------

-- Using bootleg way to deal with client/server interaction for strength/agility/intellect
-- On serverside, set the stack count to the attribute number (strength = 0, agility = 1, intellect = 2)
-- By the time a frame passes, hypothetically speaking the client side should be able to read the proper stack count, which will then store the value in a variable before setting the stack count back to nothing since vanilla doesn't have a stack number
function modifier_imba_vengefulspirit_command_aura_effect_723:OnCreated()
	self.initialized = false

	self:StartIntervalThink(FrameTime())

	if not IsServer() then return end

	if self:GetParent().GetPrimaryAttribute then
		self:SetStackCount(self:GetParent():GetPrimaryAttribute() or 0)
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:OnIntervalThink()
	if not self.initialized then
		self.hero_primary_attribute = self:GetStackCount()
		self:SetStackCount(0)
		self.initialized = true
		if IsServer() then
			self:StartIntervalThink(0.5)
		else
			self:StartIntervalThink(-1)
		end
	end

	if IsServer() and self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_vengefulspirit_command_aura_effect_723:GetModifierBonusStats_Strength()
	if self:GetAbility() and self.hero_primary_attribute == DOTA_ATTRIBUTE_STRENGTH then
		return self:GetAbility():GetSpecialValueFor("bonus_attributes") + self:GetAbility():FindTalentValue("special_bonus_unique_vengeful_spirit_2")
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:GetModifierBonusStats_Agility()
	print(self.hero_primary_attribute, DOTA_ATTRIBUTE_AGILITY)
	if self:GetAbility() and self.hero_primary_attribute == DOTA_ATTRIBUTE_AGILITY then
		print(self:GetAbility():GetSpecialValueFor("bonus_attributes"), self:GetAbility():FindTalentValue("special_bonus_unique_vengeful_spirit_2"))
		return self:GetAbility():GetSpecialValueFor("bonus_attributes") + self:GetAbility():FindTalentValue("special_bonus_unique_vengeful_spirit_2")
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:GetModifierBonusStats_Intellect()
	if self:GetAbility() and self.hero_primary_attribute == DOTA_ATTRIBUTE_INTELLECT then
		return self:GetAbility():GetSpecialValueFor("bonus_attributes") + self:GetAbility():FindTalentValue("special_bonus_unique_vengeful_spirit_2")
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:GetModifierAttackRangeBonus()
	if self:GetAbility() and self:GetParent():IsRangedAttacker() then
		return self:GetAbility():GetSpecialValueFor("bonus_attack_range")
	end
end

function modifier_imba_vengefulspirit_command_aura_effect_723:OnTooltip()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_attributes") + self:GetAbility():FindTalentValue("special_bonus_unique_vengeful_spirit_2")
	end
end

------------------------------------------------------------
-- MODIFIER_IMBA_VENGEFULSPIRIT_COMMAND_NEGATIVE_AURA_723 --
------------------------------------------------------------

function modifier_imba_vengefulspirit_command_negative_aura_723:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_RESPAWN
	}
end

function modifier_imba_vengefulspirit_command_negative_aura_723:OnRespawn(keys)
	if keys.unit == self:GetCaster() then
		self:Destroy()
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_723:IsHidden() return true end

function modifier_imba_vengefulspirit_command_negative_aura_723:IsAura() return true end

function modifier_imba_vengefulspirit_command_negative_aura_723:IsAuraActiveOnDeath() return false end

function modifier_imba_vengefulspirit_command_negative_aura_723:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end

function modifier_imba_vengefulspirit_command_negative_aura_723:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_vengefulspirit_command_negative_aura_723:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_imba_vengefulspirit_command_negative_aura_723:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_vengefulspirit_command_negative_aura_723:GetModifierAura() return "modifier_imba_vengefulspirit_command_negative_aura_effect_723" end

-------------------------------------------------------------------
-- MODIFIER_IMBA_VENGEFULSPIRIT_COMMAND_NEGATIVE_AURA_EFFECT_723 --
-------------------------------------------------------------------

-- Using bootleg way to deal with client/server interaction for strength/agility/intellect
-- On serverside, set the stack count to the attribute number (strength = 0, agility = 1, intellect = 2)
-- By the time a frame passes, hypothetically speaking the client side should be able to read the proper stack count, which will then store the value in a variable before setting the stack count back to nothing since vanilla doesn't have a stack number
function modifier_imba_vengefulspirit_command_negative_aura_effect_723:OnCreated()
	self.bonus_attributes = self:GetAbility():GetTalentSpecialValueFor("bonus_attributes") * (-1)
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor("bonus_attack_range") * (-1)

	self.initialized = false

	self:StartIntervalThink(FrameTime())

	if not IsServer() then return end

	if self:GetParent().GetPrimaryAttribute then
		self:SetStackCount(self:GetParent():GetPrimaryAttribute() or 0)
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:OnIntervalThink()
	if not self.initialized then
		self.hero_primary_attribute = self:GetStackCount()
		self:SetStackCount(0)
		self.initialized = true
		if IsServer() then
			self:StartIntervalThink(0.5)
		else
			self:StartIntervalThink(-1)
		end
	end

	if IsServer() and self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,

		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:GetModifierBonusStats_Strength()
	if self.hero_primary_attribute == DOTA_ATTRIBUTE_STRENGTH then
		return self.bonus_attributes
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:GetModifierBonusStats_Agility()
	if self.hero_primary_attribute == DOTA_ATTRIBUTE_AGILITY then
		return self.bonus_attributes
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:GetModifierBonusStats_Intellect()
	if self.hero_primary_attribute == DOTA_ATTRIBUTE_INTELLECT then
		return self.bonus_attributes
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() then
		return self.bonus_attack_range
	end
end

function modifier_imba_vengefulspirit_command_negative_aura_effect_723:OnTooltip()
	return self.bonus_attributes
end

-------------------------------------------
--            NETHER SWAP
-------------------------------------------

LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_nether_swap", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_nether_swap = class({})
function imba_vengefulspirit_nether_swap:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_nether_swap:IsRefreshable() return true end

function imba_vengefulspirit_nether_swap:IsStealable() return true end

function imba_vengefulspirit_nether_swap:IsNetherWardStealable() return false end

function imba_vengefulspirit_nether_swap:GetAbilityTextureName()
	return "vengefulspirit_nether_swap"
end

-------------------------------------------

function imba_vengefulspirit_nether_swap:GetIntrinsicModifierName()
	return "modifier_generic_charges"
end

function imba_vengefulspirit_nether_swap:CastFilterResultTarget(target)
	-- local casterID = caster:GetPlayerOwnerID()
	-- local targetID = target:GetPlayerOwnerID()

	if target ~= nil and target == self:GetCaster() then
		return UF_FAIL_OTHER
	end

	if target ~= nil and (not target:IsHero()) and (not self:GetCaster():HasScepter()) then
		return UF_FAIL_CREEP
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, self:GetCaster():GetTeamNumber())
end

-- function imba_vengefulspirit_nether_swap:GetBehavior()
-- if not self:GetCaster():HasScepter() then
-- return self.BaseClass.GetBehavior(self)
-- else
-- return self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_AOE
-- end
-- end

function imba_vengefulspirit_nether_swap:GetAOERadius()
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_radius")
	end
end

function imba_vengefulspirit_nether_swap:GetCooldown(nLevel)
	-- if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
	-- return self.BaseClass.GetCooldown( self, nLevel )
	if IsServer() then
		return 0.25 -- Literally just for some WTF-check logic in modifier_generic_charges.lua
	end
end

function imba_vengefulspirit_nether_swap:CastTalentMeteor(target)
	local caster = self:GetCaster()
	projectile =
	{
		Target            = target,
		Source            = caster,
		Ability           = self,
		EffectName        = "particles/hero/vengefulspirit/rancor_magic_missile.vpcf",
		iMoveSpeed        = 1250,
		vSpawnOrigin      = caster:GetAbsOrigin(),
		bDrawsOnMinimap   = false,
		bDodgeable        = true,
		bIsAttack         = false,
		bVisibleToEnemies = true,
		bReplaceExisting  = false,
		flExpireTime      = GameRules:GetGameTime() + 10,
		bProvidesVision   = false,
		--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		--	iVisionRadius 		= 400,
		--	iVisionTeamNumber 	= caster:GetTeamNumber()
	}
	ProjectileManager:CreateTrackingProjectile(projectile)
end

function imba_vengefulspirit_nether_swap:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Parameters
		local swapback_delay = self:GetTalentSpecialValueFor("swapback_delay")
		local swapback_duration = self:GetSpecialValueFor("swapback_duration")
		local tree_radius = self:GetSpecialValueFor("tree_radius")

		-- If the target possesses a ready Linken's Sphere, do nothing
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		-- Ministun the target if it's an enemy
		if target:GetTeamNumber() ~= caster:GetTeamNumber() then
			target:AddNewModifier(caster, self, "modifier_stunned", { duration = 0.1 })
		end

		-- Play sounds
		caster:EmitSound("Hero_VengefulSpirit.NetherSwap")
		target:EmitSound("Hero_VengefulSpirit.NetherSwap")

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(caster)
		if target:GetTeamNumber() == caster:GetTeamNumber() then
			ProjectileManager:ProjectileDodge(target)
		end

		-- Play caster particle
		local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

		-- Play target particle
		local target_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:SetParticleControlEnt(target_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(target_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		local target_loc = target:GetAbsOrigin()
		local caster_loc = caster:GetAbsOrigin()

		-- Adjust target's position if it is inside the enemy fountain
		local fountain_loc
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			fountain_loc = Vector(7472, 6912, 512)
		else
			fountain_loc = Vector(-7456, -6938, 528)
		end
		if (caster_loc - fountain_loc):Length2D() < 1700 then
			caster_loc = fountain_loc + (target_loc - fountain_loc):Normalized() * 1700
		end

		-- Swap positions
		-- Timers:CreateTimer(FrameTime(), function()
		FindClearSpaceForUnit(caster, target_loc, true)
		FindClearSpaceForUnit(target, caster_loc, true)

		-- #6 Talent - cast weak meteors
		if caster:HasTalent("special_bonus_imba_vengefulspirit_6") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				self:CastTalentMeteor(enemy)
			end
			if #enemies >= 1 then
				caster:EmitSound("Hero_VengefulSpirit.MagicMissile")
			end
		end
		-- end)

		if self:GetCaster():HasScepter() then
			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target_loc, nil, self:GetSpecialValueFor("scepter_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				-- Vanilla modifier
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_vengefulspirit_wave_of_terror_fear", { duration = self:GetSpecialValueFor("scepter_duration") * (1 - enemy:GetStatusResistance()) })
			end
		end

		-- Destroy trees around start and end areas
		GridNav:DestroyTreesAroundPoint(caster_loc, tree_radius, false)
		GridNav:DestroyTreesAroundPoint(target_loc, tree_radius, false)

		local ability_handle = caster:FindAbilityByName("imba_vengefulspirit_swap_back")
		-- Swap positions
		Timers:CreateTimer(swapback_delay, function()
			caster:AddNewModifier(caster, self, "modifier_imba_nether_swap", { duration = swapback_duration })
			ability_handle.position = caster_loc
		end)
	end
end

function imba_vengefulspirit_nether_swap:OnUpgrade()
	local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")

	if ability_handle then
		-- Upgrades Return to level 1 and make it inactive, if it hasn't already
		if ability_handle:GetLevel() < 1 then
			ability_handle:SetLevel(1)
			ability_handle:SetActivated(false)
		end
	end
end

function imba_vengefulspirit_nether_swap:GetAssociatedSecondaryAbilities()
	return "imba_vengefulspirit_swap_back"
end

function imba_vengefulspirit_nether_swap:OnProjectileHit(target, location)
	local caster = self:GetCaster()

	if target then
		local damage = caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "damage")
		local stun_duration = caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "stun_duration")
		ApplyDamage({ victim = target, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType() })
		if not target:IsMagicImmune() then
			target:AddNewModifier(caster, self, "modifier_stunned", { duration = stun_duration * (1 - target:GetStatusResistance()) })
		end
	end

	EmitSoundOnLocationWithCaster(location, "Hero_VengefulSpirit.MagicMissileImpact", caster)
end

-- Mechanic moved from Nether Swap Aghanim's to Vengeance Aura Standard
-- function imba_vengefulspirit_nether_swap:OnOwnerDied()
-- local caster = self:GetCaster()
-- if self:GetLevel() > 0 and caster:HasScepter() and( not caster:IsIllusion() ) then
-- local super_illusion = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, nil, caster:GetTeam())
-- super_illusion:AddNewModifier(caster, self, "modifier_illusion", {outgoing_damage = -(100 - self:GetSpecialValueFor("tooltip_illu_dmg_scepter")), incoming_damage = -(100 - self:GetSpecialValueFor("tooltip_illu_amp_scepter"))})
-- super_illusion:AddNewModifier(caster, self, "modifier_vengefulspirit_hybrid_special", {}) -- speshul snowflek modifier from vanilla
-- super_illusion:SetRespawnsDisabled(true)
-- super_illusion:MakeIllusion()

-- super_illusion:SetControllableByPlayer(caster:GetPlayerID(), true)
-- super_illusion:SetPlayerID(caster:GetPlayerID())

-- local parent_level = caster:GetLevel()
-- for i=1, parent_level-1 do
-- super_illusion:HeroLevelUp(false)
-- end

-- -- Set the skill points to 0 and learn the skills of the caster
-- super_illusion:SetAbilityPoints(0)
-- for abilitySlot=0,15 do
-- local ability = caster:GetAbilityByIndex(abilitySlot)
-- if ability ~= nil then
-- local abilityLevel = ability:GetLevel()
-- local abilityName = ability:GetAbilityName()
-- local illusionAbility = super_illusion:FindAbilityByName(abilityName)
-- if illusionAbility then
-- illusionAbility:SetLevel(abilityLevel)
-- end
-- end
-- end

-- -- Recreate the items of the caster
-- for itemSlot=0,5 do
-- local item = caster:GetItemInSlot(itemSlot)
-- if item ~= nil then
-- local itemName = item:GetName()
-- local newItem = CreateItem(itemName, super_illusion, super_illusion)
-- super_illusion:AddItem(newItem)
-- end
-- end
-- end
-- end
-------------------------------------------
modifier_imba_nether_swap = class({})
function modifier_imba_nether_swap:IsDebuff() return false end

function modifier_imba_nether_swap:IsHidden() return true end

function modifier_imba_nether_swap:IsPurgable() return false end

function modifier_imba_nether_swap:IsPurgeException() return false end

function modifier_imba_nether_swap:IsStunDebuff() return false end

function modifier_imba_nether_swap:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_nether_swap:OnCreated()
	if IsServer() then
		local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")
		if ability_handle then
			ability_handle:SetActivated(true)
		end
	end
end

function modifier_imba_nether_swap:OnDestroy()
	if IsServer() then
		local ability_handle = self:GetCaster():FindAbilityByName("imba_vengefulspirit_swap_back")
		if ability_handle then
			ability_handle:SetActivated(false)
		end
	end
end

-------------------------------------------
--            SWAPBACK
-------------------------------------------
LinkLuaModifier("modifier_imba_swap_back", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

imba_vengefulspirit_swap_back = class({})
function imba_vengefulspirit_swap_back:IsHiddenWhenStolen() return false end

function imba_vengefulspirit_swap_back:IsRefreshable() return true end

function imba_vengefulspirit_swap_back:IsStealable() return true end

function imba_vengefulspirit_swap_back:IsNetherWardStealable() return false end

function imba_vengefulspirit_swap_back:GetAbilityTextureName()
	return "vengeful_swap_back"
end

-------------------------------------------
function imba_vengefulspirit_swap_back:GetAssociatedPrimaryAbilities()
	return "imba_vengefulspirit_nether_swap"
end

function imba_vengefulspirit_swap_back:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self.position

		local ability_handle = caster:FindAbilityByName("imba_vengefulspirit_nether_swap")
		local tree_radius = ability_handle:GetSpecialValueFor("tree_radius")
		-- Play sounds
		caster:EmitSound("Hero_VengefulSpirit.NetherSwap")

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(caster)

		-- Play particle
		local swap_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_vengeful/vengeful_nether_swap.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(swap_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(swap_pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

		FindClearSpaceForUnit(caster, target_loc, true)
		-- #6 Talent - cast weak meteors
		if caster:HasTalent("special_bonus_imba_vengefulspirit_6") then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, caster:FindTalentValue("special_bonus_imba_vengefulspirit_6", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				ability_handle:CastTalentMeteor(enemy)
			end
		end

		-- Destroy trees around end area
		GridNav:DestroyTreesAroundPoint(target_loc, tree_radius, false)

		if caster:HasModifier("modifier_imba_nether_swap") then
			caster:RemoveModifierByNameAndCaster("modifier_imba_nether_swap", caster)
		end
	end
end

-- This modifier is there to set the ability hidden when gained through illusion or spellsteal
function imba_vengefulspirit_swap_back:GetIntrinsicModifierName()
	return "modifier_imba_swap_back"
end

-------------------------------------------
modifier_imba_swap_back = class({})
function modifier_imba_swap_back:IsDebuff() return false end

function modifier_imba_swap_back:IsHidden() return true end

function modifier_imba_swap_back:IsPurgable() return false end

function modifier_imba_swap_back:IsPurgeException() return false end

function modifier_imba_swap_back:IsStunDebuff() return false end

function modifier_imba_swap_back:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_swap_back:OnCreated()
	if IsServer() then
		self:GetAbility():SetActivated(false)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_1", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_2", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_vengefulspirit_1 = modifier_special_bonus_imba_vengefulspirit_1 or class({})
modifier_special_bonus_imba_vengefulspirit_2 = modifier_special_bonus_imba_vengefulspirit_2 or class({})

function modifier_special_bonus_imba_vengefulspirit_1:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_1:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_1:RemoveOnDeath() return false end

function modifier_special_bonus_imba_vengefulspirit_2:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_2:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_2:RemoveOnDeath() return false end

-- Client-side helper functions --
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_3", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_5", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_8", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_9", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_10", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_11", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_vengefulspirit_command_aura_attributes", "components/abilities/heroes/hero_vengefulspirit", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_vengefulspirit_3 = class({})
function modifier_special_bonus_imba_vengefulspirit_3:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_3:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_3:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_5 = class({})
function modifier_special_bonus_imba_vengefulspirit_5:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_5:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_5:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_8 = class({})
function modifier_special_bonus_imba_vengefulspirit_8:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_8:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_8:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_9 = class({})
function modifier_special_bonus_imba_vengefulspirit_9:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_9:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_9:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_10 = class({})
function modifier_special_bonus_imba_vengefulspirit_10:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_10:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_10:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_11 = class({})
function modifier_special_bonus_imba_vengefulspirit_11:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_11:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_11:RemoveOnDeath() return false end

modifier_special_bonus_imba_vengefulspirit_command_aura_attributes = class({})
function modifier_special_bonus_imba_vengefulspirit_command_aura_attributes:IsHidden() return true end

function modifier_special_bonus_imba_vengefulspirit_command_aura_attributes:IsPurgable() return false end

function modifier_special_bonus_imba_vengefulspirit_command_aura_attributes:RemoveOnDeath() return false end

function imba_vengefulspirit_magic_missile:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_5"), "modifier_special_bonus_imba_vengefulspirit_5", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_11") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_11") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_11"), "modifier_special_bonus_imba_vengefulspirit_11", {})
	end
end

function imba_vengefulspirit_wave_of_terror:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_9") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_9") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_9"), "modifier_special_bonus_imba_vengefulspirit_9", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_10") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_10") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_10"), "modifier_special_bonus_imba_vengefulspirit_10", {})
	end
end

function imba_vengefulspirit_command_aura:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_3") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_3") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_3"), "modifier_special_bonus_imba_vengefulspirit_3", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_8") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_8"), "modifier_special_bonus_imba_vengefulspirit_8", {})
	end
end

function imba_vengefulspirit_command_aura_723:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_vengefulspirit_command_aura_attributes") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_vengefulspirit_command_aura_attributes") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_vengefulspirit_command_aura_attributes"), "modifier_special_bonus_imba_vengefulspirit_command_aura_attributes", {})
	end
end
