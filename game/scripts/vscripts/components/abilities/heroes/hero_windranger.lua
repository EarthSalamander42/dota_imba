-- Creator:
--	   AltiV, September 5th, 2019

LinkLuaModifier("modifier_imba_windranger_shackle_shot", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_windranger_powershot", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_windranger_powershot_scattershot", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_windranger_powershot_overstretch", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_windranger_windrun", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_windranger_windrun_slow", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_windranger_windrun_invis", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_windranger_advancement", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

LinkLuaModifier("modifier_imba_windranger_focusfire_vanilla_enhancer", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_windranger_focusfire", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

imba_windranger_shackleshot                         = class({})
modifier_imba_windranger_shackle_shot               = class({})

imba_windranger_powershot                           = class({})
modifier_imba_windranger_powershot                  = class({})
modifier_imba_windranger_powershot_scattershot      = class({})
modifier_imba_windranger_powershot_overstretch      = class({})

imba_windranger_windrun                             = class({})
modifier_imba_windranger_windrun_handler            = class({})
modifier_imba_windranger_windrun                    = class({})
modifier_imba_windranger_windrun_slow               = class({})
modifier_imba_windranger_windrun_invis              = class({})

imba_windranger_advancement                         = class({})
modifier_imba_windranger_advancement                = class({})

imba_windranger_focusfire_vanilla_enhancer          = class({})
modifier_imba_windranger_focusfire_vanilla_enhancer = class({})

imba_windranger_focusfire                           = class({})
modifier_imba_windranger_focusfire                  = class({})

---------------------------------
-- IMBA_WINDRANGER_SHACKLESHOT --
---------------------------------

function imba_windranger_shackleshot:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_imba_windranger_shackle_shot_cooldown")
end

-- Splinter Sister IMBAfication will be an "opt-out" add-on
function imba_windranger_shackleshot:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_windranger_shackleshot:OnSpellStart()
	local target = self:GetCursorTarget()

	self:GetCaster():EmitSound("Hero_Windrunner.ShackleshotCast")

	-- IMBAfication: Natural Slinger
	-- Rough check to assume a tree was targeted, since CutDown doesn't work with "artificial" trees
	if target:GetName() == "" then
		local temp_thinker = CreateModifierThinker(self:GetCaster(), self, nil, { duration = 0.1 }, target:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

		ProjectileManager:CreateTrackingProjectile({
			Target     = temp_thinker,
			Source     = self:GetCaster(),
			Ability    = self,
			EffectName = "particles/units/heroes/hero_windrunner/windrunner_shackleshot.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("arrow_speed"),
			bDodgeable = true,
			ExtraData  = {
				location_x = self:GetCaster():GetAbsOrigin().x,
				location_y = self:GetCaster():GetAbsOrigin().y,
				location_z = self:GetCaster():GetAbsOrigin().z,
			}
		})
	else
		ProjectileManager:CreateTrackingProjectile({
			Target     = target,
			Source     = self:GetCaster(),
			Ability    = self,
			EffectName = "particles/units/heroes/hero_windrunner/windrunner_shackleshot.vpcf",
			iMoveSpeed = self:GetSpecialValueFor("arrow_speed"),
			bDodgeable = true,
			ExtraData  = {
				location_x = self:GetCaster():GetAbsOrigin().x,
				location_y = self:GetCaster():GetAbsOrigin().y,
				location_z = self:GetCaster():GetAbsOrigin().z,
			}
		})
	end
end

-- This helper function looks for valid targets
function imba_windranger_shackleshot:SearchForShackleTarget(target, target_angle, ignore_list, target_count)
	local shackleTarget = nil

	-- "Shackleshot always prioritizes units over trees as a secondary target."
	-- Check for units first
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("shackle_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_FARTHEST, false)

	for _, enemy in pairs(enemies) do
		if enemy ~= target and not ignore_list[enemy] and math.abs(AngleDiff(target_angle, VectorToAngles(enemy:GetAbsOrigin() - target:GetAbsOrigin()).y)) <= self:GetSpecialValueFor("shackle_angle") then
			shackleTarget = enemy

			target:EmitSound("Hero_Windrunner.ShackleshotBind")
			enemy:EmitSound("Hero_Windrunner.ShackleshotBind")

			local shackleshot_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_POINT_FOLLOW, target, self:GetCaster())
			ParticleManager:SetParticleControlEnt(shackleshot_particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(shackleshot_particle, 2, Vector(self:GetTalentSpecialValueFor("stun_duration"), 0, 0))

			if target.AddNewModifier then
				local target_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_shackle_shot", { duration = self:GetTalentSpecialValueFor("stun_duration") * (1 - target:GetStatusResistance()) })

				if target_modifier then
					target_modifier:AddParticle(shackleshot_particle, false, false, -1, false, false)
				end
			end

			if enemy.AddNewModifier then
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_shackle_shot", { duration = self:GetTalentSpecialValueFor("stun_duration") * (1 - enemy:GetStatusResistance()) })
			end

			break
		end
	end

	-- Then check trees (don't let this bounce from tree to tree I guess)
	if not shackleTarget and target:GetName() ~= "npc_dota_thinker" then
		local trees = GridNav:GetAllTreesAroundPoint(target:GetAbsOrigin(), self:GetSpecialValueFor("shackle_distance"), false)

		for _, tree in pairs(trees) do
			if not ignore_list[enemy] and math.abs(AngleDiff(target_angle, VectorToAngles(tree:GetAbsOrigin() - target:GetAbsOrigin()).y)) <= self:GetSpecialValueFor("shackle_angle") then
				shackleTarget = tree

				if target.AddNewModifier then
					local shackleshot_tree_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_POINT_FOLLOW, target, self:GetCaster())
					ParticleManager:SetParticleControl(shackleshot_tree_particle, 1, tree:GetAbsOrigin())
					ParticleManager:SetParticleControl(shackleshot_tree_particle, 2, Vector(self:GetTalentSpecialValueFor("stun_duration"), 0, 0))

					local target_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_shackle_shot", { duration = self:GetTalentSpecialValueFor("stun_duration") * (1 - target:GetStatusResistance()) })

					if target_modifier then
						target_modifier:AddParticle(shackleshot_tree_particle, false, false, -1, false, false)
					end
				end

				break
			end
		end
	end

	if not shackleTarget then
		local shackleshot_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_single.vpcf", PATTACH_ABSORIGIN, target, self:GetCaster())
		ParticleManager:ReleaseParticleIndex(shackleshot_particle)
	end

	return shackleTarget
end

function imba_windranger_shackleshot:OnProjectileHit_ExtraData(target, location, ExtraData)
	if not ExtraData.bSplinterSister or ExtraData.bSplinterSister ~= 1 then
		if not target or (target.IsMagicImmune and target:IsMagicImmune()) or (target.TriggerSpellAbsorb and target:TriggerSpellAbsorb(self)) then return end

		-- Initialize table to hold the shackled targets (so a unit doesn't somehow get shackled more than once by the cast)
		local shackled_targets = {}

		target:EmitSound("Hero_Windrunner.ShackleshotStun")

		-- The next_target variable will be fed the targets through the self:SearchForShackleTarget function
		local next_target = target

		-- Check for up to shackle_count units
		for targets = 0, self:GetSpecialValueFor("shackle_count") do
			-- If a target was found, keep going for up to shackle_count hits
			if next_target then
				next_target = self:SearchForShackleTarget(next_target, VectorToAngles(next_target:GetAbsOrigin() - Vector(ExtraData.location_x, ExtraData.location_y, ExtraData.location_z)).y, shackled_targets, targets)

				if next_target then
					shackled_targets[next_target] = true

					if targets == 0 and self:GetCaster():GetName() == "npc_dota_hero_windrunner" and RollPercentage(35) then
						if not self.responses then
							self.responses =
							{
								"windrunner_wind_ability_shackleshot_05",
								"windrunner_wind_ability_shackleshot_06",
								"windrunner_wind_ability_shackleshot_07",
							}
						end

						self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
					end

					-- targets == 0 represents the unit that was originally targeted; if there's no unit behind them just apply the fail stun and that's it
				elseif targets == 0 then
					local stun_modifier = target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("fail_stun_duration") * (1 - target:GetStatusResistance()) })

					if stun_modifier then
						local shackleshot_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_single.vpcf", PATTACH_ABSORIGIN, target, self:GetCaster())
						-- TODO: Figure out how this particle is oriented?
						ParticleManager:SetParticleControlForward(shackleshot_particle, 2, Vector(ExtraData.location_x, ExtraData.location_y, ExtraData.location_z):Normalized())
						stun_modifier:AddParticle(shackleshot_particle, false, false, -1, false, false)
					end
				end
				-- If no target was found to latch to, stop the for-loop
			else
				break
			end
		end
		-- IMBAfication: Spliter Sister
	elseif target then
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Windrunner.ProjectileImpact", self:GetCaster())
		self:GetCaster():PerformAttack(target, true, true, true, true, false, false, false)
	end
end

-------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_SHACKLE_SHOT --
-------------------------------------------

function modifier_imba_windranger_shackle_shot:CheckState()
	return { [MODIFIER_STATE_STUNNED] = true }
end

function modifier_imba_windranger_shackle_shot:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION,

		MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_imba_windranger_shackle_shot:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

-- IMBAfication: Splinter Sister
function modifier_imba_windranger_shackle_shot:OnAttackLanded(keys)
	if keys.attacker == self:GetCaster() and keys.target == self:GetParent() and not keys.no_attack_cooldown and self:GetAbility() and self:GetAbility():GetAutoCastState() then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetCaster():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)) do
			if enemy ~= self:GetParent() and enemy:FindModifierByNameAndCaster("modifier_imba_windranger_shackle_shot", self:GetCaster()) and self:GetAbility() then
				EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Windrunner.Attack", self:GetCaster())
				ProjectileManager:CreateTrackingProjectile({
					Target            = enemy,
					Source            = self:GetParent(),
					Ability           = self:GetAbility(),
					EffectName        = self:GetCaster():GetRangedProjectileName() or "particles/units/heroes/hero_windrunner/windrunner_base_attack.vpcf",
					iMoveSpeed        = self:GetCaster():GetProjectileSpeed() or 1250,
					bDrawsOnMinimap   = false,
					bDodgeable        = true,
					bIsAttack         = true, -- Does this even do anything
					bVisibleToEnemies = true,
					bReplaceExisting  = false,
					flExpireTime      = GameRules:GetGameTime() + 10.0,
					bProvidesVision   = false,
					ExtraData         = { bSplinterSister = true }
				})
			end
		end
	end
end

-------------------------------
-- IMBA_WINDRANGER_POWERSHOT --
-------------------------------

-- Not gonna do the voicelines for this one cause I'd need to track hero kills with the arrows and stuff and it's gonna get annoying

function imba_windranger_powershot:GetIntrinsicModifierName()
	return "modifier_imba_windranger_powershot"
end

function imba_windranger_powershot:OnSpellStart()
	EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Ability.PowershotPull", self:GetCaster())

	if not self.powershot_modifier or self.powershot_modifier:IsNull() then
		self.powershot_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_windranger_powershot", self:GetCaster())
	end

	-- TODO: REMOVE THIS WHEN DONE WITH EVERYTHING
	if self:GetCaster():HasAbility("imba_windranger_advancement") then
		self:GetCaster():FindAbilityByName("imba_windranger_advancement"):SetLevel(1)
	end

	if self:GetCaster():HasAbility("imba_windranger_focusfire_vanilla_enhancer") then
		self:GetCaster():FindAbilityByName("imba_windranger_focusfire_vanilla_enhancer"):SetLevel(1)
	end
end

function imba_windranger_powershot:OnChannelThink(flInterval)
	self.powershot_modifier:SetStackCount(math.min((GameRules:GetGameTime() - self:GetChannelStartTime()) * 100, 100))
end

function imba_windranger_powershot:OnChannelFinish(bInterrupted)
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	if self.powershot_modifier then
		self.powershot_modifier:SetStackCount(0)
	end

	if bInterrupted or not self:GetAutoCastState() then
		local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime()) / self:GetChannelTime()

		if channel_pct < self:GetSpecialValueFor("scattershot_min") / 100 or channel_pct > self:GetSpecialValueFor("scattershot_max") / 100 then
			self:FirePowershot(channel_pct)
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_powershot_scattershot",
				{
					duration     = self:GetSpecialValueFor("scattershot_interval") * (self:GetSpecialValueFor("scattershot_shots") - 1),
					channel_pct  = channel_pct,
					cursor_pos_x = self:GetCursorPosition().x,
					cursor_pos_y = self:GetCursorPosition().y,
					cursor_pos_z = self:GetCursorPosition().z
				})
		end
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_powershot_overstretch", {})
	end
end

function imba_windranger_powershot:FirePowershot(channel_pct, overstretch_bonus)
	-- This "dummy" literally only exists to attach the gush travel sound to
	local powershot_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	powershot_dummy:EmitSound("Ability.Powershot")
	-- Keep track of how many units the Powershot will hit to calculate damage reductions
	powershot_dummy.units_hit = 0

	local powershot_particle = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"

	-- IMBAfication: Godshot
	if channel_pct >= self:GetSpecialValueFor("godshot_min") / 100 and channel_pct <= self:GetSpecialValueFor("godshot_max") / 100 then
		powershot_particle = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot_godshot.vpcf"
		powershot_dummy:EmitSound("Hero_Windranger.Powershot_Godshot")
	end

	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)

	-- IMBAfication: Overstretched
	if not overstretch_bonus then
		overstretch_bonus = 0
	end

	ProjectileManager:CreateLinearProjectile({
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		EffectName = powershot_particle,
		fDistance = self:GetSpecialValueFor("arrow_range") + overstretch_bonus + self:GetCaster():GetCastRangeBonus(),
		fStartRadius = self:GetSpecialValueFor("arrow_width"),
		fEndRadius = self:GetSpecialValueFor("arrow_width"),
		vVelocity = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("arrow_speed") * Vector(1, 1, 0),
		bProvidesVision = true,
		iVisionRadius = self:GetSpecialValueFor("vision_radius"),
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData = {
			dummy_index = powershot_dummy:entindex(),
			channel_pct = channel_pct * 100
		}
	})
end

function imba_windranger_powershot:OnProjectileThink_ExtraData(location, data)
	if data.dummy_index then
		EntIndexToHScript(data.dummy_index):SetAbsOrigin(location)
	end

	GridNav:DestroyTreesAroundPoint(location, 75, true)
end

function imba_windranger_powershot:OnProjectileHit_ExtraData(target, location, data)
	if target and data.dummy_index and EntIndexToHScript(data.dummy_index) and not EntIndexToHScript(data.dummy_index):IsNull() and EntIndexToHScript(data.dummy_index).units_hit then
		EmitSoundOnLocationWithCaster(location, "Hero_Windrunner.PowershotDamage", self:GetCaster())

		local damage      = self:GetTalentSpecialValueFor("powershot_damage") * data.channel_pct / 100 * ((100 - self:GetSpecialValueFor("damage_reduction")) / 100) ^ EntIndexToHScript(data.dummy_index).units_hit
		local damage_type = self:GetAbilityDamageType()

		-- IMBAfication: Godshot
		if data.channel_pct >= self:GetSpecialValueFor("godshot_min") and data.channel_pct <= self:GetSpecialValueFor("godshot_max") then
			damage      = self:GetTalentSpecialValueFor("powershot_damage") * self:GetSpecialValueFor("godshot_damage_pct") / 100
			damage_type = DAMAGE_TYPE_PURE

			target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", { duration = self:GetSpecialValueFor("godshot_stun_duration") * (1 - target:GetStatusResistance()) })
			-- IMBAfication: Scattershot
		elseif data.channel_pct >= self:GetSpecialValueFor("scattershot_min") and data.channel_pct <= self:GetSpecialValueFor("scattershot_max") then
			damage = self:GetTalentSpecialValueFor("powershot_damage") * self:GetSpecialValueFor("scattershot_damage_pct") / 100 * ((100 - self:GetSpecialValueFor("damage_reduction")) / 100) ^ EntIndexToHScript(data.dummy_index).units_hit
		end

		ApplyDamage({
			victim       = target,
			damage       = damage,
			damage_type  = damage_type,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})

		EntIndexToHScript(data.dummy_index).units_hit = EntIndexToHScript(data.dummy_index).units_hit + 1
	elseif data.dummy_index then
		EntIndexToHScript(data.dummy_index):StopSound("Ability.Powershot")
		EntIndexToHScript(data.dummy_index):RemoveSelf()
	end
end

----------------------------------------
-- MODIFIER_IMBA_WINDRANGER_POWERSHOT --
----------------------------------------

function modifier_imba_windranger_powershot:IsHidden() return self:GetStackCount() <= 0 end

----------------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_POWERSHOT_SCATTERSHOT --
----------------------------------------------------

function modifier_imba_windranger_powershot_scattershot:IsPurgable() return false end

function modifier_imba_windranger_powershot_scattershot:OnCreated(params)
	if not IsServer() then return end

	self.channel_pct           = params.channel_pct
	self.cursor_pos            = Vector(params.cursor_pos_x, params.cursor_pos_y, params.cursor_pos_z)

	self.scattershot_interval  = self:GetAbility():GetSpecialValueFor("scattershot_interval")
	self.scattershot_deviation = self:GetAbility():GetSpecialValueFor("scattershot_deviation")

	self:OnIntervalThink()
	self:StartIntervalThink(self.scattershot_interval)
end

function modifier_imba_windranger_powershot_scattershot:OnIntervalThink()
	if self:GetAbility() then
		self:GetParent():SetCursorPosition(RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, RandomInt(-self.scattershot_deviation, self.scattershot_deviation), 0), self.cursor_pos))
		self:GetAbility():FirePowershot(self.channel_pct)
	end
end

----------------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_POWERSHOT_OVERSTRETCH --
----------------------------------------------------

-- TODO: Find a way to hold the powershot gesture if possible?

function modifier_imba_windranger_powershot_overstretch:OnCreated()
	if self:GetAbility() then
		self.overstretch_bonus_range_per_second = self:GetAbility():GetSpecialValueFor("overstretch_bonus_range_per_second")
	else
		self.overstretch_bonus_range_per_second = 0
	end

	if not IsServer() then return end

	self.destroy_orders =
	{
		[DOTA_UNIT_ORDER_STOP]             = true,
		[DOTA_UNIT_ORDER_CONTINUE]         = true,
		[DOTA_UNIT_ORDER_CAST_POSITION]    = true,
		[DOTA_UNIT_ORDER_CAST_TARGET]      = true,
		[DOTA_UNIT_ORDER_CAST_TARGET_TREE] = true,
		[DOTA_UNIT_ORDER_CAST_NO_TARGET]   = true,
		[DOTA_UNIT_ORDER_CAST_TOGGLE]      = true
	}

	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_2)

	self:StartIntervalThink(1)
end

function modifier_imba_windranger_powershot_overstretch:OnIntervalThink()
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_2)
	self:IncrementStackCount()
end

function modifier_imba_windranger_powershot_overstretch:OnDestroy()
	if not IsServer() or not self:GetAbility() then return end

	self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_2)

	self:GetParent():SetCursorPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector())
	-- By logic this should be fully channeled already so 1 = 100%
	self:GetAbility():FirePowershot(1, self:GetStackCount() * self.overstretch_bonus_range_per_second)
end

function modifier_imba_windranger_powershot_overstretch:CheckState()
	return {
		[MODIFIER_STATE_ROOTED]   = true,
		[MODIFIER_STATE_DISARMED] = true
	}
end

function modifier_imba_windranger_powershot_overstretch:DeclareFunctions()
	return { MODIFIER_EVENT_ON_ORDER }
end

function modifier_imba_windranger_powershot_overstretch:OnOrder(keys)
	if keys.unit == self:GetParent() and self.destroy_orders[keys.order_type] then
		self:Destroy()
	end
end

-----------------------------
-- IMBA_WINDRANGER_WINDRUN --
-----------------------------

function imba_windranger_windrun:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_windranger_windrun:OnInventoryContentsChanged()
	-- Caster got scepter
	if self:GetCaster():HasScepter() then
		if self:GetCaster():HasModifier("modifier_generic_charges") then
			local has_rightful_modifier = false

			for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_generic_charges")) do
				if mod:GetAbility():GetAbilityName() == self:GetAbilityName() then
					has_rightful_modifier = true
					break
				end
			end

			if has_rightful_modifier == false then
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
			end
		else
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_charges", {})
		end
	end
end

function imba_windranger_windrun:OnSpellStart()
	self:GetCaster():EmitSound("Ability.Windrun")

	if self:GetCaster():GetName() == "npc_dota_hero_windrunner" and RollPercentage(75) then
		if not self.responses then
			self.responses =
			{
				"windrunner_wind_spawn_04",
				"windrunner_wind_move_08",
				"windrunner_wind_move_10",
			}
		end

		-- This one doesn't work or something
		-- EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_windrun", { duration = self:GetSpecialValueFor("duration") })

	if self:GetCaster():HasTalent("special_bonus_imba_windranger_windrun_invisibility") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_windrun_invis", { duration = self:GetSpecialValueFor("duration") })
	end
end

--------------------------------------
-- MODIFIER_IMBA_WINDRANGER_WINDRUN --
--------------------------------------

function modifier_imba_windranger_windrun:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf"
end

function modifier_imba_windranger_windrun:OnCreated()
	if self:GetAbility() then
		self.movespeed_bonus_pct       = self:GetAbility():GetSpecialValueFor("movespeed_bonus_pct")
		self.evasion_pct_tooltip       = self:GetAbility():GetSpecialValueFor("evasion_pct_tooltip")
		self.scepter_bonus_movement    = self:GetAbility():GetSpecialValueFor("scepter_bonus_movement")

		self.radius                    = self:GetAbility():GetSpecialValueFor("radius")
		self.gale_enchantment_radius   = self:GetAbility():GetSpecialValueFor("gale_enchantment_radius")
		self.gale_enchantment_duration = self:GetAbility():GetSpecialValueFor("gale_enchantment_duration")
	else
		self.movespeed_bonus_pct       = 0
		self.evasion_pct_tooltip       = 0
		self.scepter_bonus_movement    = 0

		self.radius                    = 0
		self.gale_enchantment_radius   = 0
		self.gale_enchantment_duration = 0
	end

	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function modifier_imba_windranger_windrun:OnIntervalThink()
	for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.gale_enchantment_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if self:GetCaster() == self:GetParent() and ally ~= self:GetCaster() then
			ally:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_windranger_windrun", { duration = self.gale_enchantment_duration })
		end
	end
end

function modifier_imba_windranger_windrun:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():StopSound("Ability.Windrun")
end

-- function modifier_imba_windranger_windrun:CheckState()
-- if self:GetParent():GetLevel() >= 25 then
-- return {[MODIFIER_STATE_ALLOW_PATHING_TROUGH_TREES] = true}
-- end
-- end

function modifier_imba_windranger_windrun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end

function modifier_imba_windranger_windrun:GetModifierMoveSpeedBonus_Percentage()
	if self:GetCaster() then
		if not self:GetCaster():HasScepter() then
			return self.movespeed_bonus_pct
		else
			return self.movespeed_bonus_pct + self.scepter_bonus_movement
		end
	end
end

function modifier_imba_windranger_windrun:GetModifierEvasion_Constant()
	return self.evasion_pct_tooltip
end

function modifier_imba_windranger_windrun:GetModifierIgnoreMovespeedLimit()
	if self:GetCaster() and self:GetCaster():HasScepter() then
		return 1
	end
end

function modifier_imba_windranger_windrun:GetActivityTranslationModifiers()
	return "windrun"
end

function modifier_imba_windranger_windrun:IsAura() return true end

function modifier_imba_windranger_windrun:GetModifierAura() return "modifier_imba_windranger_windrun_slow" end

function modifier_imba_windranger_windrun:GetAuraRadius() return self.radius end

function modifier_imba_windranger_windrun:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_windranger_windrun:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_windranger_windrun:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_windranger_windrun:IsAuraActiveOnDeath() return false end

-- "The slow is provided by an aura on Windranger. Its debuff lingers for 2.5 seconds."
function modifier_imba_windranger_windrun:GetAuraDuration() return 2.5 end

-------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_WINDRUN_SLOW --
-------------------------------------------

function modifier_imba_windranger_windrun_slow:GetEffectName()
	return "particles/units/heroes/hero_windrunner/windrunner_windrun_slow.vpcf"
end

function modifier_imba_windranger_windrun_slow:OnCreated()
	if self:GetAbility() then
		self.enemy_movespeed_bonus_pct = self:GetAbility():GetSpecialValueFor("enemy_movespeed_bonus_pct")
	else
		self.enemy_movespeed_bonus_pct = 0
	end
end

function modifier_imba_windranger_windrun_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_windranger_windrun_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.enemy_movespeed_bonus_pct
end

--------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_WINDRUN_INVIS --
--------------------------------------------

function modifier_imba_windranger_windrun_invis:CheckState()
	return { [MODIFIER_STATE_INVISIBLE] = true }
end

function modifier_imba_windranger_windrun_invis:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_imba_windranger_windrun_invis:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_windranger_windrun_invis:OnAttack(keys)
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown then
		self:Destroy()
	end
end

function modifier_imba_windranger_windrun_invis:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability ~= self:GetAbility() and keys.ability:GetName() ~= "imba_windranger_advancement" then
		self:Destroy()
	end
end

---------------------------------
-- IMBA_WINDRANGER_ADVANCEMENT --
---------------------------------

-- TODO: This needs an ability icon

function imba_windranger_advancement:IsInnateAbility() return true end

function imba_windranger_advancement:OnSpellStart()
	ProjectileManager:ProjectileDodge(self:GetCaster())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller",
		{
			distance        = self:GetSpecialValueFor("advancement_distance"),
			direction_x     = self:GetCaster():GetForwardVector().x,
			direction_y     = self:GetCaster():GetForwardVector().y,
			direction_z     = self:GetCaster():GetForwardVector().z,
			duration        = self:GetSpecialValueFor("advancement_duration"),
			height          = self:GetSpecialValueFor("advancement_height"),
			bGroundStop     = true,
			bDecelerate     = false,
			bInterruptible  = false,
			bIgnoreTenacity = true
		})
end

------------------------------------------------
-- IMBA_WINDRANGER_FOCUSFIRE_VANILLA_ENHANCER --
------------------------------------------------

function imba_windranger_focusfire_vanilla_enhancer:IsInnateAbility() return true end

function imba_windranger_focusfire_vanilla_enhancer:GetIntrinsicModifierName()
	return "modifier_imba_windranger_focusfire_vanilla_enhancer"
end

---------------------------------------------------------
-- MODIFIER_IMBA_WINDRANGER_FOCUSFIRE_VANILLA_ENHANCER --
---------------------------------------------------------

function modifier_imba_windranger_focusfire_vanilla_enhancer:IsHidden() return true end

function modifier_imba_windranger_focusfire_vanilla_enhancer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_windranger_focusfire_vanilla_enhancer:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability:GetName() == "windrunner_focusfire" then
		self.ability = keys.ability
		self.target  = keys.ability:GetCursorTarget()
	end
end

function modifier_imba_windranger_focusfire_vanilla_enhancer:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and self:GetParent():HasModifier("modifier_windrunner_focusfire") and self.target and not self.target:IsNull() and self.target:IsAlive() and self.target == keys.target and RollPseudoRandom(self.ability:GetSpecialValueFor("ministun_chance"), self) then
		keys.target:EmitSound("DOTA_Item.MKB.Minibash")
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = 0.1 * (1 - keys.target:GetStatusResistance()) })
	end
end

-------------------------------
-- IMBA_WINDRANGER_FOCUSFIRE --
-------------------------------

-- Tried to replicate the vanilla ability as usual, but it seems far too hacky to properly replicate the "on_the_move" aspect where forward vector is separate from Windranger's movement, so I will just be using the vanilla ability
-- There was a suggestion to use a separate entity to control the movement, but this starts breaking apart when you have to start considering forced movements (i.e. how do you make the forced movement affect both the movement control unit AND Windranger, without ending up making that movement control unit a target for other abilities?)

function imba_windranger_focusfire:OnSpellStart()
	self:GetCaster():EmitSound("Ability.Focusfire")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_windranger_focusfire", { duration = self:GetDuration() })
end

----------------------------------------
-- MODIFIER_IMBA_WINDRANGER_FOCUSFIRE --
----------------------------------------

function modifier_imba_windranger_focusfire:IsPurgable() return false end

function modifier_imba_windranger_focusfire:OnCreated(params)
	self.bonus_attack_speed         = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.focusfire_damage_reduction = self:GetAbility():GetSpecialValueFor("focusfire_damage_reduction")
	self.focusfire_fire_on_the_move = self:GetAbility():GetSpecialValueFor("focusfire_fire_on_the_move")

	if not IsServer() then return end

	self.bFocusing = true

	self.target = self:GetAbility():GetCursorTarget()

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_windranger_focusfire:OnIntervalThink()
	if self:GetParent():AttackReady() and self.target and not self.target:IsNull() and self.target:IsAlive() and (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():Script_GetAttackRange() and self.bFocusing then
		--self:GetParent():SetForwardVector((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
		self:GetParent():StartGesture(ACT_DOTA_ATTACK)
		self:GetParent():PerformAttack(self.target, true, true, false, true, true, false, false)
	end
end

function modifier_imba_windranger_focusfire:CheckState()
	return {}
end

function modifier_imba_windranger_focusfire:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_windranger_focusfire:GetModifierAttackSpeedBonus_Constant()
	if IsClient() or self:GetParent():GetAttackTarget() == self.target then
		return self.bonus_attack_speed
	end
end

function modifier_imba_windranger_focusfire:GetModifierPreAttack_BonusDamage()
	if IsClient() or self:GetParent():GetAttackTarget() == self.target then
		return self.focusfire_damage_reduction
	end
end

-- function modifier_imba_windranger_focusfire:GetModifierDisableTurning()
-- return 1
-- end

function modifier_imba_windranger_focusfire:GetActivityTranslationModifiers()
	return "focusfire"
end

function modifier_imba_windranger_focusfire:OnOrder(keys)
	if keys.unit == self:GetParent() then
		if keys.order_type == DOTA_UNIT_ORDER_STOP or keys.order_type == DOTA_UNIT_ORDER_CONTINUE or not self:GetParent():AttackReady() then
			self.bFocusing = false
		else
			self.bFocusing = true
		end
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_windranger_powershot_damage", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_windranger_shackle_shot_duration", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_windranger_windrun_invisibility", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_windranger_powershot_damage      = modifier_special_bonus_imba_windranger_powershot_damage or class({})
modifier_special_bonus_imba_windranger_shackle_shot_duration = modifier_special_bonus_imba_windranger_shackle_shot_duration or class({})
modifier_special_bonus_imba_windranger_windrun_invisibility  = modifier_special_bonus_imba_windranger_windrun_invisibility or class({})

function modifier_special_bonus_imba_windranger_powershot_damage:IsHidden() return true end

function modifier_special_bonus_imba_windranger_powershot_damage:IsPurgable() return false end

function modifier_special_bonus_imba_windranger_powershot_damage:RemoveOnDeath() return false end

function modifier_special_bonus_imba_windranger_shackle_shot_duration:IsHidden() return true end

function modifier_special_bonus_imba_windranger_shackle_shot_duration:IsPurgable() return false end

function modifier_special_bonus_imba_windranger_shackle_shot_duration:RemoveOnDeath() return false end

function modifier_special_bonus_imba_windranger_windrun_invisibility:IsHidden() return true end

function modifier_special_bonus_imba_windranger_windrun_invisibility:IsPurgable() return false end

function modifier_special_bonus_imba_windranger_windrun_invisibility:RemoveOnDeath() return false end

LinkLuaModifier("modifier_special_bonus_imba_windranger_shackle_shot_cooldown", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_windranger_focusfire_damage_reduction", "components/abilities/heroes/hero_windranger", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_windranger_shackle_shot_cooldown      = class({})
modifier_special_bonus_imba_windranger_focusfire_damage_reduction = class({})

function modifier_special_bonus_imba_windranger_shackle_shot_cooldown:IsHidden() return true end

function modifier_special_bonus_imba_windranger_shackle_shot_cooldown:IsPurgable() return false end

function modifier_special_bonus_imba_windranger_shackle_shot_cooldown:RemoveOnDeath() return false end

function modifier_special_bonus_imba_windranger_focusfire_damage_reduction:IsHidden() return true end

function modifier_special_bonus_imba_windranger_focusfire_damage_reduction:IsPurgable() return false end

function modifier_special_bonus_imba_windranger_focusfire_damage_reduction:RemoveOnDeath() return false end

function imba_windranger_shackleshot:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_windranger_shackle_shot_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_windranger_shackle_shot_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_windranger_shackle_shot_cooldown"), "modifier_special_bonus_imba_windranger_shackle_shot_cooldown", {})
	end
end

function imba_windranger_focusfire:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_windranger_focusfire_damage_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_windranger_focusfire_damage_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_windranger_focusfire_damage_reduction"), "modifier_special_bonus_imba_windranger_focusfire_damage_reduction", {})
	end
end
