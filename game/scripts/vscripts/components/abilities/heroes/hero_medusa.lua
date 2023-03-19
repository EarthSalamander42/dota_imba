-- Creator:
--	   AltiV, April 29th, 2019
-- Primary Idea Giver:
--     Acalia

LinkLuaModifier("modifier_imba_medusa_split_shot", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_serpent_shot", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_enchanted_aim", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_medusa_mystic_snake_slow", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_mystic_snake_tracker", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_medusa_mana_shield_meditate", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_mana_shield", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_medusa_stone_gaze", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_facing", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_stone", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_red_eyes", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_red_eyes_facing", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_medusa_stone_gaze_stiff_joints", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

imba_medusa_split_shot                          = class({})
modifier_imba_medusa_split_shot                 = class({})
modifier_imba_medusa_serpent_shot               = class({})
modifier_imba_medusa_enchanted_aim              = class({})

imba_medusa_mystic_snake                        = class({})
modifier_imba_medusa_mystic_snake_slow          = class({})
modifier_imba_medusa_mystic_snake_tracker       = class({})

imba_medusa_mana_shield                         = class({})
modifier_imba_medusa_mana_shield_meditate       = class({})
modifier_imba_medusa_mana_shield                = class({})

imba_medusa_stone_gaze                          = class({})
modifier_imba_medusa_stone_gaze                 = class({})
modifier_imba_medusa_stone_gaze_facing          = class({})
modifier_imba_medusa_stone_gaze_stone           = class({})
modifier_imba_medusa_stone_gaze_red_eyes        = class({})
modifier_imba_medusa_stone_gaze_red_eyes_facing = class({})
modifier_imba_medusa_stone_gaze_stiff_joints    = class({})

----------------
-- SPLIT SHOT --
----------------

function imba_medusa_split_shot:CastFilterResult()
	if not IsServer() then return end

	if #self:GetCaster():FindAllModifiersByName("modifier_imba_medusa_enchanted_aim") >= self:GetSpecialValueFor("enchanted_aim_stack_limit") then
		return UF_FAIL_CUSTOM
	else
		return UF_SUCCESS
	end
end

function imba_medusa_split_shot:GetCustomCastError()
	if not IsServer() then return end

	return "#dota_hud_error_medusa_enchanted_aim_limit"
end

function imba_medusa_split_shot:OnAbilityPhaseStart()
	if #self:GetCaster():FindAllModifiersByName("modifier_imba_medusa_enchanted_aim") >= self:GetSpecialValueFor("enchanted_aim_stack_limit") then
		DisplayError(self:GetCaster():GetPlayerID(), "Cannot exceed " .. self:GetSpecialValueFor("enchanted_aim_stack_limit") .. " stacks of Enchanted Aim.")
		return false
	else
		return true
	end
end

function imba_medusa_split_shot:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_medusa_split_shot", self:GetCaster()) == 0 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_medusa_split_shot:GetManaCost(level)
	if self:GetCaster():GetModifierStackCount("modifier_imba_medusa_split_shot", self:GetCaster()) == 0 then
		return 0
	else
		return self:GetCaster():GetMaxMana() * self:GetSpecialValueFor("enchanted_aim_mana_loss_pct") / 100
	end
end

function imba_medusa_split_shot:ResetToggleOnRespawn() -- Doesn't seem like this works, so gonna handle logic in OnOwnerSpawned()/OnOwnerDied()
	return false
end

function imba_medusa_split_shot:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function imba_medusa_split_shot:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function imba_medusa_split_shot:OnUpgrade()
	-- Check for illusions to toggle Split Shot on if the owner has it on (overkill on the nil checks but I don't want to get back to this)
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end

function imba_medusa_split_shot:GetIntrinsicModifierName()
	return "modifier_imba_medusa_split_shot"
end

function imba_medusa_split_shot:OnToggle()
	if not IsServer() then return end

	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_serpent_shot", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_medusa_serpent_shot", self:GetCaster())
	end
end

-- IMBAfication: Enchanted Aim
function imba_medusa_split_shot:OnSpellStart()
	if self:GetAutoCastState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_enchanted_aim", { duration = self:GetSpecialValueFor("enchanted_aim_duration") })
	end
end

-------------------------
-- SPLIT SHOT MODIFIER --
-------------------------

function modifier_imba_medusa_split_shot:IsHidden() return true end

function modifier_imba_medusa_split_shot:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_medusa_split_shot:OnAttack(keys)
	if not IsServer() then return end

	-- "Secondary arrows are not released upon attacking allies."
	-- The "not keys.no_attack_cooldown" clause seems to make sure the function doesn't trigger on PerformAttacks with that false tag so this thing doesn't crash
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() and self:GetAbility():IsTrained() then
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("split_shot_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)

		local target_number = 0

		local apply_modifiers = self:GetParent():HasTalent("special_bonus_imba_medusa_split_shot_modifiers")

		for _, enemy in pairs(enemies) do
			if enemy ~= keys.target then
				self.split_shot_target = true

				self:GetParent():PerformAttack(enemy, false, apply_modifiers, true, true, true, false, false)

				self.split_shot_target = false

				target_number = target_number + 1

				if target_number >= self:GetAbility():GetTalentSpecialValueFor("arrow_count") then
					break
				end
			end
		end
	end
end

function modifier_imba_medusa_split_shot:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end

	if self.split_shot_target then
		return self:GetAbility():GetSpecialValueFor("damage_modifier")
	else
		return 0
	end
end

function modifier_imba_medusa_split_shot:GetActivityTranslationModifiers()
	return "split_shot"
end

function modifier_imba_medusa_split_shot:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end

	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

---------------------------
-- SERPENT SHOT MODIFIER --
---------------------------

function modifier_imba_medusa_serpent_shot:IsPurgable() return false end

function modifier_imba_medusa_serpent_shot:RemoveOnDeath() return false end

function modifier_imba_medusa_serpent_shot:OnCreated()
	self.damage_modifier            = self:GetAbility():GetSpecialValueFor("damage_modifier")
	self.serpent_shot_damage_pct    = self:GetAbility():GetSpecialValueFor("serpent_shot_damage_pct")
	self.serpent_shot_mana_burn_pct = self:GetAbility():GetSpecialValueFor("serpent_shot_mana_burn_pct")

	-- This is purely to prevent arrows doing extra damage if you toggle while a projectile is mid-air
	-- (Does not prevent toggle off arrows from doing 0 damage)
	self.records                    = {}

	if not IsServer() then return end

	self.attack = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self.serpent_shot_damage_pct / 100
	self:SetStackCount(self.attack)
	self:StartIntervalThink(0.1)
end

function modifier_imba_medusa_serpent_shot:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount(0)
	self.attack = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * self.serpent_shot_damage_pct / 100
	self:SetStackCount(self.attack)
end

function modifier_imba_medusa_serpent_shot:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROJECTILE_NAME,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return decFuncs
end

-- Remove modifier if the ability doesn't exist (Morphling/Rubick exception)
function modifier_imba_medusa_serpent_shot:OnAttackRecord(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then
		if not self:GetAbility() then
			self:Destroy()
			return
		end

		self.records[keys.record] = true
	end
end

function modifier_imba_medusa_serpent_shot:OnAttackRecordDestroy(keys)
	if keys.attacker == self:GetParent() then
		-- destroy attack record
		self.records[keys.record] = nil
	end
end

function modifier_imba_medusa_serpent_shot:GetModifierProjectileName(keys)
	return "particles/units/heroes/hero_medusa/medusa_serpent_shot_particle.vpcf"
end

-- This technically doesn't do anything but is purely for visual purposes
function modifier_imba_medusa_serpent_shot:GetModifierPreAttack_BonusDamage(keys)
	if (not keys.target or (keys.target and not keys.target:IsBuilding() and not keys.target:IsOther())) then
		return (self:GetStackCount() / (self.serpent_shot_damage_pct / 100)) * (100 - self.serpent_shot_damage_pct) / 100 * (-1)
	end
end

function modifier_imba_medusa_serpent_shot:GetModifierProcAttack_BonusDamage_Magical(keys)
	if not IsServer() or keys.target:IsBuilding() or keys.target:IsOther() or keys.target:IsMagicImmune() then return end

	if self.records[keys.record] then
		return self:GetStackCount()
	end
end

function modifier_imba_medusa_serpent_shot:GetModifierDamageOutgoing_Percentage(keys)
	if keys.attacker == self:GetParent() and self:GetStackCount() > 0 and (not keys.target or (keys.target and not keys.target:IsBuilding() and not keys.target:IsOther())) then
		return -100
	end
end

function modifier_imba_medusa_serpent_shot:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and keys.damage_category == 1 and keys.damage_type == 1 and not keys.unit:IsBuilding() and not keys.unit:IsOther() and not keys.unit:IsMagicImmune() and self.records[keys.record] then
		local damage_dealt = keys.damage

		if keys.original_damage <= 0 then
			local damageTable = {
				victim       = keys.unit,
				damage       = self:GetStackCount() * (100 + self.damage_modifier) / 100, -- reminder that damage_modifier is technically a negative number
				damage_type  = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetParent(),
				ability      = self:GetAbility()
			}

			damage_dealt = ApplyDamage(damageTable)
		end

		keys.unit:ReduceMana(damage_dealt * self.serpent_shot_mana_burn_pct / 100)

		local manaburn_particle = ParticleManager:CreateParticle("particles/item/diffusal/diffusal_manaburn_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
		ParticleManager:ReleaseParticleIndex(manaburn_particle)
	end
end

---------------------------------------
-- SPLIT SHOT ENCHANTED AIM MODIFIER --
---------------------------------------

function modifier_imba_medusa_enchanted_aim:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_medusa_enchanted_aim:OnCreated()
	-- Technically it would be better to use self:GetParent():Script_GetAttackRange(), but this is heavily abusable stacking with both itself as well as Hurricane Pike variants (infinite attack range for 10 seconds seemsgood)
	self.attack_range    = self:GetAbility():GetSpecialValueFor("enchanted_aim_bonus_attack_range")
	self.incoming_damage = self:GetAbility():GetSpecialValueFor("enchanted_aim_bonus_incoming_damage")
end

function modifier_imba_medusa_enchanted_aim:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_medusa_enchanted_aim:GetModifierAttackRangeBonus()
	return self.attack_range
end

function modifier_imba_medusa_enchanted_aim:GetModifierIncomingDamage_Percentage()
	return self.incoming_damage
end

------------------
-- MYSTIC SNAKE --
------------------

function imba_medusa_mystic_snake:GetCooldown(level)
	if self:GetCaster():GetLevel() >= 20 then
		return self:GetSpecialValueFor("innate_cooldown")
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function imba_medusa_mystic_snake:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_Medusa.MysticSnake.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_medusa" and RollPercentage(75) then
		local random_response = RandomInt(1, 6)

		-- Plays line 1 or lines 3-7
		if random_response >= 2 then random_response = random_response + 1 end

		self:GetCaster():EmitSound("medusa_medus_mysticsnake_0" .. random_response)
	end

	local particle_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_cast)

	local particle_snake = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_snake, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_snake, 1, self:GetCursorTarget():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_snake, 2, Vector(self:GetSpecialValueFor("initial_speed"), 0, 0))

	local targets = self:GetCursorTarget():GetEntityIndex()

	local snake =
	{
		Target            = self:GetCursorTarget(),
		Source            = self:GetCaster(),
		Ability           = self,
		--EffectName 			= "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
		iMoveSpeed        = self:GetSpecialValueFor("initial_speed"),
		--vSourceLoc 			= self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack2")), -- This does nothing
		bDrawsOnMinimap   = false,
		bDodgeable        = false,
		bIsAttack         = false,
		bVisibleToEnemies = true,
		bReplaceExisting  = false,
		flExpireTime      = GameRules:GetGameTime() + 10,
		bProvidesVision   = true,
		iVisionRadius     = 100, -- AbilitySpecial?
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData         = {
			bounces        = 0,
			mana_stolen    = 0,
			damage         = self:GetSpecialValueFor("snake_damage"),
			particle_snake = particle_snake,
			speed          = self:GetSpecialValueFor("initial_speed")
		}
	}

	ProjectileManager:CreateTrackingProjectile(snake)
end

function imba_medusa_mystic_snake:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsServer() or not hTarget then return end

	-- Snake has returned to the caster; give the mana and destroy the particle
	if hTarget == self:GetCaster() then
		if self:GetCaster().GiveMana then
			self:GetCaster():GiveMana(ExtraData.mana_stolen)

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetCaster(), ExtraData.mana_stolen, nil)
		end

		self:GetCaster():EmitSound("Hero_Medusa.MysticSnake.Return")

		local return_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_impact_return.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(return_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(return_particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(return_particle)

		ParticleManager:DestroyParticle(ExtraData.particle_snake, false)
		ParticleManager:ReleaseParticleIndex(ExtraData.particle_snake)

		-- Don't continue with the rest of the logic
		return
	end

	if hTarget:IsAlive() and not hTarget:IsInvulnerable() and not hTarget:IsOutOfGame() then
		if not hTarget:TriggerSpellAbsorb(self) then
			hTarget:EmitSound("Hero_Medusa.MysticSnake.Target")

			-- "Applies the mana loss first, and then the damage (and then the Stone Gaze debuff [if scepter])."
			-- "The snake does not steal any mana from illusions it jumps on."
			if hTarget:GetMana() and hTarget:GetMaxMana() and not hTarget:IsIllusion() then
				-- Store amount of mana before stealing some
				local target_mana   = hTarget:GetMana()
				local mana_to_steal = hTarget:GetMaxMana() * (self:GetTalentSpecialValueFor("snake_mana_steal") + (self:GetSpecialValueFor("mana_thief_steal") * ExtraData.bounces)) / 100

				hTarget:ReduceMana(mana_to_steal)

				-- "Upon returning to Medusa, she receives exactly the amount of mana all targets lost to Mystic Snake." seems to be a lie based on vanilla testing since it still steals the standard amount even if it burns less due to manaloss reductions so zzz
				if target_mana < mana_to_steal then
					ExtraData.mana_stolen = ExtraData.mana_stolen + math.max(target_mana, 0)
				else
					ExtraData.mana_stolen = ExtraData.mana_stolen + math.max(mana_to_steal, 0)
				end
			end

			local damageTable = {
				victim       = hTarget,
				damage       = ExtraData.damage,
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			}

			-- "Deals Pure damage to units petrified by Stone Gaze."
			if hTarget:HasModifier("modifier_imba_medusa_stone_gaze_stone") then
				damageTable.damage_type = DAMAGE_TYPE_PURE
			end

			ApplyDamage(damageTable)

			-- Aghanim's Scepter causes Mystic Snake to turn enemies into stone for 1 second, increases by 0.3 seconds per bounce.
			if self:GetCaster():HasScepter() then
				local stone_gaze_ability = self:GetCaster():FindAbilityByName("imba_medusa_stone_gaze")

				if stone_gaze_ability and stone_gaze_ability:IsTrained() then
					hTarget:AddNewModifier(self:GetCaster(), stone_gaze_ability, "modifier_imba_medusa_stone_gaze_stone",
						{
							duration              = self:GetSpecialValueFor("stone_form_scepter_base") + self:GetSpecialValueFor("stone_form_scepter_increment") * ExtraData.bounces,
							bonus_physical_damage = stone_gaze_ability:GetSpecialValueFor("bonus_physical_damage")
						})
				end
			end

			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_mystic_snake_slow", { duration = self:GetSpecialValueFor("slow_duration") * (1 - hTarget:GetStatusResistance()) })

			-- This is an IMBAfication branching off a somewhat necessary modifier, as this is used to make sure one mystic snake doesn't hit the same target more than once
			local tracker_modifier = hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_mystic_snake_tracker", { duration = self:GetSpecialValueFor("myotoxin_duration") })

			if tracker_modifier then
				tracker_modifier.number = ExtraData.particle_snake
			end

			-- Increment bounce count
			ExtraData.bounces = ExtraData.bounces + 1
		else
			-- Custom function to bring the mystic snake back to Medusa, since there's too many detached situations where this happens
			self:Return(hTarget, vLocation, ExtraData)
		end
	end

	-- Small delay between bounces (doesn't seem to be a thing anymore)
	--Timers:CreateTimer(self:GetSpecialValueFor("jump_delay"), function()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)

	-- If the snake has not reached max bounces yet, look for nearby enemies
	if ExtraData.bounces >= self:GetSpecialValueFor("snake_jumps") or #enemies <= 1 then
		self:Return(hTarget, vLocation, ExtraData)
	else
		local found_target = false

		for _, enemy in pairs(enemies) do
			if enemy ~= hTarget then
				local tracker_modifiers = enemy:FindAllModifiersByName("modifier_imba_medusa_mystic_snake_tracker")
				local proceed           = true

				-- If the target is already tagged as having been hit by mystic snake, check the next target
				for _, modifier in pairs(tracker_modifiers) do
					if modifier.number == ExtraData.particle_snake then
						proceed = false
					end
				end

				if proceed then
					found_target = true

					local snake  =
					{
						Target            = enemy,
						Source            = hTarget,
						Ability           = self,
						iMoveSpeed        = ExtraData.speed + self:GetSpecialValueFor("quick_snake_speed"),
						bDrawsOnMinimap   = false,
						bDodgeable        = false,
						bIsAttack         = false,
						bVisibleToEnemies = true,
						bReplaceExisting  = false,
						flExpireTime      = GameRules:GetGameTime() + 10,
						bProvidesVision   = true,
						iVisionRadius     = 100, -- AbilitySpecial?
						iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
						ExtraData         = {
							bounces        = ExtraData.bounces,
							mana_stolen    = ExtraData.mana_stolen,
							damage         = ExtraData.damage + self:GetSpecialValueFor("snake_damage") * self:GetSpecialValueFor("snake_scale") / 100,
							particle_snake = ExtraData.particle_snake,
							speed          = ExtraData.speed + self:GetSpecialValueFor("quick_snake_speed")
						}
					}

					ProjectileManager:CreateTrackingProjectile(snake)

					ParticleManager:SetParticleControl(ExtraData.particle_snake, 1, enemy:GetAbsOrigin())
					ParticleManager:SetParticleControl(ExtraData.particle_snake, 2, Vector(ExtraData.speed + self:GetSpecialValueFor("quick_snake_speed"), 0, 0))
					break
				end
			end
		end

		if not found_target then
			self:Return(hTarget, vLocation, ExtraData)
		end
	end
	--end)
end

-- This function handles returning the Mystic Snake back to Medusa (simple tracking projectile to Medusa)
function imba_medusa_mystic_snake:Return(hTarget, vLocation, ExtraData)
	if not IsServer() then return end

	-- Replace the "damage" particle with the "return" particle (subtle stuff like not having blood effect on impact...)
	ParticleManager:DestroyParticle(ExtraData.particle_snake, false)
	ParticleManager:ReleaseParticleIndex(ExtraData.particle_snake)

	local particle_snake = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile_return.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster(), self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle_snake, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_snake, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_snake, 2, Vector(self:GetSpecialValueFor("return_speed"), 0, 0))

	local snake =
	{
		Target            = self:GetCaster(),
		Source            = hTarget,
		Ability           = self,
		iMoveSpeed        = self:GetSpecialValueFor("return_speed"),
		bDrawsOnMinimap   = false,
		bDodgeable        = false,
		bIsAttack         = false,
		bVisibleToEnemies = true,
		bReplaceExisting  = false,
		flExpireTime      = GameRules:GetGameTime() + 10,
		bProvidesVision   = true,
		iVisionRadius     = 100, -- AbilitySpecial?
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData         = {
			bounces        = ExtraData.bounces,
			mana_stolen    = ExtraData.mana_stolen,
			damage         = ExtraData.damage,
			particle_snake = particle_snake,
		}
	}

	ProjectileManager:CreateTrackingProjectile(snake)
end

--------------------------------------------
-- MODIFIER_IMBA_MEDUSA_MYSTIC_SNAKE_SLOW --
--------------------------------------------

function modifier_imba_medusa_mystic_snake_slow:OnCreated()
	self.movement_slow = self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
	self.turn_slow     = self:GetAbility():GetSpecialValueFor("turn_slow") * (-1)
end

function modifier_imba_medusa_mystic_snake_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}
end

function modifier_imba_medusa_mystic_snake_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end

function modifier_imba_medusa_mystic_snake_slow:GetModifierTurnRate_Percentage()
	return self.turn_slow
end

-----------------------------------
-- MYSTIC SNAKE TRACKER MODIFIER --
-----------------------------------

function modifier_imba_medusa_mystic_snake_tracker:IgnoreTenacity() return true end

function modifier_imba_medusa_mystic_snake_tracker:IsPurgable() return false end

function modifier_imba_medusa_mystic_snake_tracker:RemoveOnDeath() return false end

function modifier_imba_medusa_mystic_snake_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_medusa_mystic_snake_tracker:OnCreated()
	self.myotoxin_stack_deal   = self:GetAbility():GetSpecialValueFor("myotoxin_stack_deal")
	self.myotoxin_stack_take   = self:GetAbility():GetSpecialValueFor("myotoxin_stack_take")
	self.myotoxin_duration_inc = self:GetAbility():GetSpecialValueFor("myotoxin_duration_inc")
	self.myotoxin_base_aspd    = self:GetAbility():GetSpecialValueFor("myotoxin_base_aspd")
	self.myotoxin_stack_aspd   = self:GetAbility():GetSpecialValueFor("myotoxin_stack_aspd")
	self.myotoxin_base_cast    = self:GetAbility():GetSpecialValueFor("myotoxin_base_cast")
	self.myotoxin_stack_cast   = self:GetAbility():GetSpecialValueFor("myotoxin_stack_cast")
	self.myotoxin_max_stacks   = self:GetAbility():GetSpecialValueFor("myotoxin_max_stacks")

	if not IsServer() then return end

	self:SetStackCount(0)
end

function modifier_imba_medusa_mystic_snake_tracker:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}

	return decFuncs
end

-- IMBAfication: Myotoxin
function modifier_imba_medusa_mystic_snake_tracker:OnTakeDamage(keys)
	if keys.damage > 0 and self:GetStackCount() < self.myotoxin_max_stacks then
		if keys.attacker == self:GetParent() then
			self:SetStackCount(math.min(self:GetStackCount() + self.myotoxin_stack_deal), self.myotoxin_max_stacks)
			self:SetDuration(self:GetRemainingTime() + self.myotoxin_duration_inc, true)
		elseif keys.unit == self:GetParent() then
			self:SetStackCount(math.min(self:GetStackCount() + self.myotoxin_stack_take), self.myotoxin_max_stacks)
			self:SetDuration(self:GetRemainingTime() + self.myotoxin_duration_inc, true)
		end
	end
end

function modifier_imba_medusa_mystic_snake_tracker:GetModifierAttackSpeedBonus_Constant()
	return self.myotoxin_base_aspd + self:GetStackCount() * self.myotoxin_stack_aspd
end

function modifier_imba_medusa_mystic_snake_tracker:GetModifierPercentageCasttime()
	return self.myotoxin_base_cast + self:GetStackCount() * self.myotoxin_stack_cast
end

-----------------
-- MANA SHIELD --
-----------------

function imba_medusa_mana_shield:GetIntrinsicModifierName()
	return "modifier_imba_medusa_mana_shield_meditate"
end

function imba_medusa_mana_shield:ProcsMagicStick() return false end

function imba_medusa_mana_shield:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function imba_medusa_mana_shield:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function imba_medusa_mana_shield:OnToggle()
	if not IsServer() then return end

	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")

		if self:GetCaster():GetName() == "npc_dota_hero_medusa" and RollPercentage(20) then
			if not self.responses then
				self.responses =
				{
					["medusa_medus_manashield_02"] = 0,
					["medusa_medus_manashield_03"] = 0,
					["medusa_medus_manashield_04"] = 0,
					["medusa_medus_manashield_06"] = 0
				}
			end

			for response, timer in pairs(self.responses) do
				if GameRules:GetDOTATime(true, true) - timer >= 20 then
					self:GetCaster():EmitSound(response)
					self.responses[response] = GameRules:GetDOTATime(true, true)
					break
				end
			end
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_mana_shield", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")

		self:GetCaster():RemoveModifierByNameAndCaster("modifier_imba_medusa_mana_shield", self:GetCaster())
	end
end

-----------------------------------
-- MANA SHIELD MEDITATE MODIFIER --
-----------------------------------

function modifier_imba_medusa_mana_shield_meditate:IsHidden() return true end

function modifier_imba_medusa_mana_shield_meditate:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED -- IMBAfication: Meditation
	}

	return decFuncs
end

function modifier_imba_medusa_mana_shield_meditate:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() and not self:GetParent():HasModifier("modifier_imba_medusa_mana_shield") and not keys.attacker:PassivesDisabled() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetAbility():IsTrained() and not self:GetParent():PassivesDisabled() then
		local meditate_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/meditate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(meditate_particle)

		if not keys.attacker:IsIllusion() then
			local enchanted_aim_modifiers = #self:GetParent():FindAllModifiersByName("modifier_imba_medusa_enchanted_aim")
			local efficacy_reduction      = (100 - (self:GetAbility():GetSpecialValueFor("meditate_enchanted_reduction") * enchanted_aim_modifiers)) / 100

			self:GetParent():GiveMana(keys.damage * self:GetAbility():GetSpecialValueFor("meditate_mana_acquire_pct") / 100 * efficacy_reduction)
		end
	end
end

--------------------------
-- MANA SHIELD MODIFIER --
--------------------------

function modifier_imba_medusa_mana_shield:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf"
end

function modifier_imba_medusa_mana_shield:IsPurgable() return false end

function modifier_imba_medusa_mana_shield:RemoveOnDeath() return false end

function modifier_imba_medusa_mana_shield:OnCreated()
	self.damage_per_mana    = self:GetAbility():GetSpecialValueFor("damage_per_mana")
	self.absorption_tooltip = self:GetAbility():GetSpecialValueFor("absorption_tooltip")
	-- self.initiates_shield_mana_conversion	= self:GetAbility():GetSpecialValueFor("initiates_shield_mana_conversion")
	-- self.initiates_shield_max_stacks		= self:GetAbility():GetSpecialValueFor("initiates_shield_max_stacks")

	if not IsServer() then return end

	-- Start tracking mana percentages and mana values to determine if mana was lost
	self.mana_raw = self:GetParent():GetMana()
	self.mana_pct = self:GetParent():GetManaPercent()

	-- self:StartIntervalThink(FrameTime())
end

-- function modifier_imba_medusa_mana_shield:OnIntervalThink()
-- if not IsServer() then return end

-- -- If mana percentage at any frame is lower than the frame before it, set stacks
-- if self:GetParent():GetManaPercent() < self.mana_pct and self:GetParent():GetMana() < self.mana_raw then
-- self:SetStackCount(min(self:GetStackCount() + (self.mana_raw - self:GetParent():GetMana()) * (self.initiates_shield_mana_conversion / 100), self.initiates_shield_max_stacks))
-- end

-- self.mana_raw = self:GetParent():GetMana()
-- self.mana_pct = self:GetParent():GetManaPercent()
-- end

function modifier_imba_medusa_mana_shield:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}

	return decFuncs
end

function modifier_imba_medusa_mana_shield:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end

	-- "While spell immune, Mana Shield does not react on magical damage."
	if not (keys.damage_type == DAMAGE_TYPE_MAGICAL and self:GetParent():IsMagicImmune()) and self:GetParent().GetMana then
		-- Calculate how much mana will be used in attempts to block some damage
		local mana_to_block = keys.original_damage * self.absorption_tooltip / 100 / self.damage_per_mana

		if mana_to_block >= self:GetParent():GetMana() then
			self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")

			local shield_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:ReleaseParticleIndex(shield_particle)
		end

		local mana_before = self:GetParent():GetMana()
		self:GetParent():ReduceMana(mana_to_block)
		local mana_after = self:GetParent():GetMana()

		return math.min(self.absorption_tooltip, self.absorption_tooltip * self:GetParent():GetMana() / math.max(mana_to_block, 1)) * (-1)
	end
end

-- IMBAfication: Initiate's Shield
-- function modifier_imba_medusa_mana_shield:GetModifierTotal_ConstantBlock(keys)
-- local blocked = self:GetStackCount()

-- -- Block for the smaller value between total current stacks and total damage
-- if blocked > 0 then
-- SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_MAGICAL_BLOCK , self:GetParent(), min(self:GetStackCount(), keys.damage), self:GetParent())
-- self:SetStackCount(max(self:GetStackCount() - keys.damage, 0))
-- end

-- return blocked
-- end

----------------
-- STONE GAZE --
----------------

function imba_medusa_stone_gaze:GetAssociatedPrimaryAbilities()
	return "imba_medusa_mystic_snake"
end

function imba_medusa_stone_gaze:GetIntrinsicModifierName()
	return "modifier_imba_medusa_stone_gaze_red_eyes"
end

function imba_medusa_stone_gaze:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():EmitSound("Hero_Medusa.StoneGaze.Cast")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_medusa_stone_gaze", { duration = self:GetTalentSpecialValueFor("duration") })
end

-------------------------
-- STONE GAZE MODIFIER --
-------------------------

function modifier_imba_medusa_stone_gaze:IsPurgable() return false end

function modifier_imba_medusa_stone_gaze:OnCreated()
	self.radius                = self:GetAbility():GetSpecialValueFor("radius")
	self.stone_duration        = self:GetAbility():GetTalentSpecialValueFor("stone_duration")
	self.face_duration         = self:GetAbility():GetSpecialValueFor("face_duration")
	self.vision_cone           = self:GetAbility():GetSpecialValueFor("vision_cone") -- It's 0.08715 in the abilityspecial for some reason...w/e I'll just use it
	self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.speed_boost           = self:GetAbility():GetSpecialValueFor("speed_boost")
	self.stiff_joints_duration = self:GetAbility():GetSpecialValueFor("stiff_joints_duration")

	self.tick_interval         = 0.1

	if not IsServer() then return end

	local gaze_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(gaze_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(gaze_particle, false, false, -1, false, false)

	self:StartIntervalThink(self.tick_interval)
end

function modifier_imba_medusa_stone_gaze:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		-- Check to see if any enemy's forward vector in radius is within the required vision cone
		-- "Stone Gaze does not affect neutral creeps."
		if math.abs(AngleDiff(VectorToAngles(enemy:GetForwardVector()).y, VectorToAngles(self:GetParent():GetAbsOrigin() - enemy:GetAbsOrigin()).y)) <= self.vision_cone * 1000 and enemy:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS then
			local facing_modifier = enemy:FindModifierByNameAndCaster("modifier_imba_medusa_stone_gaze_facing", self:GetParent())
			local stone_modifier  = enemy:FindModifierByNameAndCaster("modifier_imba_medusa_stone_gaze_stone", self:GetParent())

			if not facing_modifier and not stone_modifier then
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_medusa_stone_gaze_facing",
					{
						duration              = self:GetRemainingTime(),
						radius                = self.radius,
						stone_duration        = self.stone_duration,
						face_duration         = self.face_duration,
						bonus_physical_damage = self.bonus_physical_damage,
						tick_interval         = self.tick_interval,
						stiff_joints_duration = self.stiff_joints_duration
					})
			end
		end
	end
end

function modifier_imba_medusa_stone_gaze:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Medusa.StoneGaze.Cast")
end

function modifier_imba_medusa_stone_gaze:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end

function modifier_imba_medusa_stone_gaze:GetModifierMoveSpeedBonus_Percentage()
	return self.speed_boost
end

function modifier_imba_medusa_stone_gaze:GetOverrideAnimation()
	return ACT_DOTA_MEDUSA_STONE_GAZE
end

--------------------------------
-- STONE GAZE FACING MODIFIER --
--------------------------------

function modifier_imba_medusa_stone_gaze_facing:IgnoreTenacity() return true end

function modifier_imba_medusa_stone_gaze_facing:IsPurgable() return false end

function modifier_imba_medusa_stone_gaze_facing:OnCreated(params)
	self.counter = 0

	if self:GetAbility() then
		self.slow        = self:GetAbility():GetSpecialValueFor("slow")
		self.vision_cone = self:GetAbility():GetSpecialValueFor("vision_cone")
	else
		self.slow        = 35
		self.vision_cone = 0.08715
	end

	if not IsServer() then return end

	self.radius                = params.radius
	self.stone_duration        = params.stone_duration
	self.face_duration         = params.face_duration
	self.bonus_physical_damage = params.bonus_physical_damage
	self.stiff_joints_duration = params.stiff_joints_duration

	self.tick_interval         = params.tick_interval
	self.play_sound            = true

	self:SetStackCount(self.slow)

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)

	self:StartIntervalThink(self.tick_interval)
end

function modifier_imba_medusa_stone_gaze_facing:OnIntervalThink()
	if not IsServer() then return end

	if math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.vision_cone * 1000 and (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.radius and self:GetCaster():IsAlive() then
		if self.play_sound and self:GetParent():IsHero() then
			self:GetParent():EmitSound("Hero_Medusa.StoneGaze.Target")
			self.play_sound = false
		end

		self:SetStackCount(self.slow)

		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)

		self.counter = self.counter + self.tick_interval

		if self.counter >= self.face_duration then
			if self:GetParent():IsHero() then
				self:GetParent():EmitSound("Hero_Medusa.StoneGaze.Stun")
			end

			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_medusa_stone_gaze_stone",
				{
					duration              = self.stone_duration * (1 - self:GetParent():GetStatusResistance()),
					bonus_physical_damage = self.bonus_physical_damage
				})
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_medusa_stone_gaze_stiff_joints",
				{
					duration              = self.stiff_joints_duration * (1 - self:GetParent():GetStatusResistance()),
					bonus_physical_damage = self.bonus_physical_damage
				})
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	else
		if not self.play_sound then
			self.play_sound = true
		end

		self:SetStackCount(0)
		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

		-- "Stone Gaze ends when Medusa dies . . ."
		if not self:GetCaster():IsAlive() then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end

function modifier_imba_medusa_stone_gaze_facing:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_medusa_stone_gaze_facing:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * (-1)
end

function modifier_imba_medusa_stone_gaze_facing:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * (-1)
end

-------------------------------
-- STONE GAZE STONE MODIFIER --
-------------------------------

function modifier_imba_medusa_stone_gaze_stone:IsPurgable() return false end

function modifier_imba_medusa_stone_gaze_stone:IsPurgeException() return true end

function modifier_imba_medusa_stone_gaze_stone:GetEffectName()
	return "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf"
end

function modifier_imba_medusa_stone_gaze_stone:GetStatusEffectName()
	return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf"
end

function modifier_imba_medusa_stone_gaze_stone:OnCreated(params)
	if self:GetAbility() then
		self.bonus_physical_damage = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	else
		self:Destroy()
	end

	-- if not IsServer() then return end

	-- self.bonus_physical_damage = params.bonus_physical_damage
end

function modifier_imba_medusa_stone_gaze_stone:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_imba_medusa_stone_gaze_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT -- IMBAfication: Become Sediment
	}
end

function modifier_imba_medusa_stone_gaze_stone:GetModifierIncomingPhysicalDamage_Percentage(keys)
	return self.bonus_physical_damage
end

function modifier_imba_medusa_stone_gaze_stone:OnTakeDamageKillCredit(keys)
	if keys.target == self:GetParent() and self:GetParent():GetHealth() <= keys.damage then
		if keys.attacker == self:GetParent() then
			TrueKill(self:GetCaster(), self:GetParent(), self:GetAbility())
		else
			TrueKill(keys.attacker, self:GetParent(), self:GetAbility())
		end
	end
end

----------------------------------
-- STONE GAZE RED EYES MODIFIER --
----------------------------------

function modifier_imba_medusa_stone_gaze_red_eyes:IsHidden() return true end

function modifier_imba_medusa_stone_gaze_red_eyes:OnCreated()
	self.red_eyes_vision_cone = self:GetAbility():GetSpecialValueFor("red_eyes_vision_cone")

	self.red_eyes_radius      = self:GetAbility():GetSpecialValueFor("red_eyes_radius")
	self.red_eyes_duration    = self:GetAbility():GetSpecialValueFor("red_eyes_duration")

	self.tick_interval        = 0.1

	if not IsServer() then return end

	self:StartIntervalThink(self.tick_interval)
end

function modifier_imba_medusa_stone_gaze_red_eyes:OnRefresh()
	self:OnCreated()
end

function modifier_imba_medusa_stone_gaze_red_eyes:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.red_eyes_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		local facing_modifier = enemy:FindModifierByNameAndCaster("modifier_imba_medusa_stone_gaze_red_eyes_facing", self:GetParent())
		local stone_modifier  = enemy:FindModifierByNameAndCaster("modifier_imba_medusa_stone_gaze_stone", self:GetParent())

		-- Check to see if any enemy's AND parent's forward vector is within the required vision cone
		-- "Stone Gaze does not affect neutral creeps."		
		if
			math.abs(AngleDiff(VectorToAngles(enemy:GetForwardVector()).y, VectorToAngles(self:GetParent():GetAbsOrigin() - enemy:GetAbsOrigin()).y)) <= self.red_eyes_vision_cone * 1000 and
			math.abs(AngleDiff(VectorToAngles(self:GetParent():GetForwardVector()).y, VectorToAngles(enemy:GetAbsOrigin() - self:GetParent():GetAbsOrigin()).y)) <= self.red_eyes_vision_cone * 1000 and
			enemy:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS and
			not self:GetParent():PassivesDisabled() and
			not self:GetParent():IsIllusion() and
			self:GetParent():IsAlive()
		then
			if not facing_modifier and not stone_modifier then
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_medusa_stone_gaze_red_eyes_facing",
					{
						duration = self.red_eyes_duration
					})
			end
		elseif facing_modifier then
			facing_modifier:Destroy()
		end
	end
end

-----------------------------------------
-- STONE GAZE RED EYES FACING MODIFIER --
-----------------------------------------

function modifier_imba_medusa_stone_gaze_red_eyes_facing:IgnoreTenacity() return true end

function modifier_imba_medusa_stone_gaze_red_eyes_facing:OnCreated(params)
	self.bonus_physical_damage   = self:GetAbility():GetSpecialValueFor("bonus_physical_damage")
	self.red_eyes_max_slow       = self:GetAbility():GetSpecialValueFor("red_eyes_max_slow")
	self.red_eyes_stone_duration = self:GetAbility():GetSpecialValueFor("red_eyes_stone_duration")

	if not IsServer() then return end

	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_imba_medusa_stone_gaze_red_eyes_facing:OnDestroy()
	if not IsServer() then return end

	if self:GetRemainingTime() <= 0 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_medusa_stone_gaze_stone",
			{
				duration              = self.red_eyes_stone_duration * (1 - self:GetParent():GetStatusResistance()),
				bonus_physical_damage = self.bonus_physical_damage
			})
	end
end

function modifier_imba_medusa_stone_gaze_red_eyes_facing:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_medusa_stone_gaze_red_eyes_facing:GetModifierMoveSpeedBonus_Percentage()
	return ((1 - self:GetRemainingTime() / self:GetDuration()) * self.red_eyes_max_slow) * (-1)
end

--------------------------------------
-- STONE GAZE STIFF JOINTS MODIFIER --
--------------------------------------

function modifier_imba_medusa_stone_gaze_stiff_joints:IsPurgable() return false end

function modifier_imba_medusa_stone_gaze_stiff_joints:OnCreated(params)
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	self.stiff_joints_movespeed = self:GetAbility():GetSpecialValueFor("stiff_joints_movespeed")
	self.stiff_joints_turnspeed = self:GetAbility():GetSpecialValueFor("stiff_joints_turnspeed")
	self.stiff_joints_orders = self:GetAbility():GetSpecialValueFor("stiff_joints_orders")

	if not IsServer() then return end

	self.bonus_physical_damage = params.bonus_physical_damage

	self:SetStackCount(self.stiff_joints_orders)
end

function modifier_imba_medusa_stone_gaze_stiff_joints:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_medusa_stone_gaze_stiff_joints:GetModifierIncomingPhysicalDamage_Percentage(keys)
	if not IsServer() then return end

	if not self:GetParent():FindModifierByNameAndCaster("modifier_imba_medusa_stone_gaze_stone", self:GetCaster()) then
		return self.bonus_physical_damage
	else
		return 0
	end
end

function modifier_imba_medusa_stone_gaze_stiff_joints:GetModifierMoveSpeedBonus_Percentage()
	return self.stiff_joints_movespeed
end

function modifier_imba_medusa_stone_gaze_stiff_joints:GetModifierTurnRate_Percentage()
	return self.stiff_joints_turnspeed
end

function modifier_imba_medusa_stone_gaze_stiff_joints:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then
		self:DecrementStackCount()

		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_mystic_snake_mana_steal", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_medusa_extra_split_shot_targets", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_medusa_stone_gaze_duration", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_medusa_split_shot_modifiers", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_medusa_bonus_mana", "components/abilities/heroes/hero_medusa", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_mystic_snake_mana_steal         = modifier_special_bonus_imba_mystic_snake_mana_steal or class({})
modifier_special_bonus_imba_medusa_extra_split_shot_targets = modifier_special_bonus_imba_medusa_extra_split_shot_targets or class({})
modifier_special_bonus_imba_medusa_stone_gaze_duration      = modifier_special_bonus_imba_medusa_stone_gaze_duration or class({})
modifier_special_bonus_imba_medusa_split_shot_modifiers     = modifier_special_bonus_imba_medusa_split_shot_modifiers or class({})
modifier_special_bonus_imba_medusa_bonus_mana               = class({})

function modifier_special_bonus_imba_mystic_snake_mana_steal:IsHidden() return true end

function modifier_special_bonus_imba_mystic_snake_mana_steal:IsPurgable() return false end

function modifier_special_bonus_imba_mystic_snake_mana_steal:RemoveOnDeath() return false end

function modifier_special_bonus_imba_medusa_extra_split_shot_targets:IsHidden() return true end

function modifier_special_bonus_imba_medusa_extra_split_shot_targets:IsPurgable() return false end

function modifier_special_bonus_imba_medusa_extra_split_shot_targets:RemoveOnDeath() return false end

function modifier_special_bonus_imba_medusa_stone_gaze_duration:IsHidden() return true end

function modifier_special_bonus_imba_medusa_stone_gaze_duration:IsPurgable() return false end

function modifier_special_bonus_imba_medusa_stone_gaze_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_medusa_split_shot_modifiers:IsHidden() return true end

function modifier_special_bonus_imba_medusa_split_shot_modifiers:IsPurgable() return false end

function modifier_special_bonus_imba_medusa_split_shot_modifiers:RemoveOnDeath() return false end

function modifier_special_bonus_imba_medusa_bonus_mana:IsHidden() return true end

function modifier_special_bonus_imba_medusa_bonus_mana:IsPurgable() return false end

function modifier_special_bonus_imba_medusa_bonus_mana:RemoveOnDeath() return false end

function modifier_special_bonus_imba_medusa_bonus_mana:OnCreated()
	self.bonus_mana = self:GetParent():FindTalentValue("special_bonus_imba_medusa_bonus_mana")
end

function modifier_special_bonus_imba_medusa_bonus_mana:DeclareFunctions()
	return { MODIFIER_PROPERTY_MANA_BONUS }
end

function modifier_special_bonus_imba_medusa_bonus_mana:GetModifierManaBonus()
	return self.bonus_mana
end

function imba_medusa_mana_shield:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_medusa_bonus_mana") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_medusa_bonus_mana") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_medusa_bonus_mana"), "modifier_special_bonus_imba_medusa_bonus_mana", {})
	end
end
