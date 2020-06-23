-- Editors:
--     Firetoad
--     AtroCty, 09.04.2017

-------------------------------------------
--			  BESERKERS RAGE
-------------------------------------------
LinkLuaModifier("modifier_imba_berserkers_rage_ranged", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_rage_slow", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_rage_melee", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_rage_ensnare", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_berserkers_rage = imba_troll_warlord_berserkers_rage or class({})
function imba_troll_warlord_berserkers_rage:IsHiddenWhenStolen() return false end
function imba_troll_warlord_berserkers_rage:IsRefreshable() return true end
function imba_troll_warlord_berserkers_rage:IsStealable() return false end
function imba_troll_warlord_berserkers_rage:IsNetherWardStealable() return false end
function imba_troll_warlord_berserkers_rage:ResetToggleOnRespawn() return true end

function imba_troll_warlord_berserkers_rage:ProcsMagicStick() return false end

-- Always have one of the buffs
function imba_troll_warlord_berserkers_rage:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()

		if self:GetLevel() == 1 then
			caster:FindAbilityByName("imba_troll_warlord_whirling_axes_melee"):SetActivated(false)
		end

		if not (caster:HasModifier("modifier_imba_berserkers_rage_ranged") or caster:HasModifier("modifier_imba_berserkers_rage_melee")) then
			if self:GetToggleState() then
				caster:AddNewModifier(caster, self, "modifier_imba_berserkers_rage_melee", {})
			else
				caster:AddNewModifier(caster, self, "modifier_imba_berserkers_rage_ranged", {})
			end
		end
	end
end

function imba_troll_warlord_berserkers_rage:OnOwnerSpawned()
	if self.mode == 1 then
		self:ToggleAbility()
		self:ToggleAbility()
		self:ToggleAbility()
		-- Yeah, volvo.
	end
	
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_1") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_1") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_1"), "modifier_special_bonus_imba_troll_warlord_1", {})
	end
end

function imba_troll_warlord_berserkers_rage:OnToggle()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_TrollWarlord.BerserkersRage.Toggle")
		-- Randomly play a cast line
		if RollPercentage(25) and (caster:GetName() == "npc_dota_hero_troll_warlord") and not caster.beserk_sound then
			caster:EmitSound("troll_warlord_troll_beserker_0"..math.random(1,4))
			caster.beserk_sound = true
			Timers:CreateTimer( 10, function()
				caster.beserk_sound = nil
			end)
		end

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

		if caster:HasModifier("modifier_imba_berserkers_rage_ranged") and self:GetToggleState() then
			caster:RemoveModifierByName("modifier_imba_berserkers_rage_ranged")
			caster:AddNewModifier(caster, self, "modifier_imba_berserkers_rage_melee", {})
--			caster:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", false, true)
			caster:FindAbilityByName("imba_troll_warlord_whirling_axes_melee"):SetActivated(true)
			caster:FindAbilityByName("imba_troll_warlord_whirling_axes_ranged"):SetActivated(false)
			caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			self.mode = 2
		else
			caster:RemoveModifierByName("modifier_imba_berserkers_rage_melee")
			caster:AddNewModifier(caster, self, "modifier_imba_berserkers_rage_ranged", {})
--			caster:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
			caster:FindAbilityByName("imba_troll_warlord_whirling_axes_melee"):SetActivated(false)
			caster:FindAbilityByName("imba_troll_warlord_whirling_axes_ranged"):SetActivated(true)
			caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
			self.mode = 1
		end
	end
end

function imba_troll_warlord_berserkers_rage:GetAbilityTextureName()
	-- blah blah client/server side
	-- if self.mode == 1 then
	if self:GetCaster():HasModifier("modifier_imba_berserkers_rage_melee") then
		return "troll_warlord_berserkers_rage_active"
	else
		return "troll_warlord_berserkers_rage"
	end
end

function imba_troll_warlord_berserkers_rage:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end

	local ensnare_duration	= self:GetSpecialValueFor("ensnare_duration")

	if hTarget then
		hTarget:EmitSound("n_creep_TrollWarlord.Ensnare")
		
		if hTarget:IsAlive() then
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_berserkers_rage_ensnare", {duration = ensnare_duration * (1 - hTarget:GetStatusResistance())})
		end
	end
end


----
-- Mini section for the ensnare before going into melee modifier
----

modifier_imba_berserkers_rage_ensnare	= class({})

function modifier_imba_berserkers_rage_ensnare:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf"
end

function modifier_imba_berserkers_rage_ensnare:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end

-------------------------------------------
modifier_imba_berserkers_rage_melee = modifier_imba_berserkers_rage_melee or class({})
function modifier_imba_berserkers_rage_melee:AllowIllusionDuplicate() return true end
function modifier_imba_berserkers_rage_melee:IsDebuff() return false end
function modifier_imba_berserkers_rage_melee:IsHidden() return true end
function modifier_imba_berserkers_rage_melee:IsPurgable() return false end
function modifier_imba_berserkers_rage_melee:IsPurgeException() return false end
function modifier_imba_berserkers_rage_melee:IsStunDebuff() return false end
function modifier_imba_berserkers_rage_melee:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_berserkers_rage_melee:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
		}
	return decFuns
end

function modifier_imba_berserkers_rage_melee:GetAttackSound()
	return "Hero_TrollWarlord.ProjectileImpact"
end

function modifier_imba_berserkers_rage_melee:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_move_speed")
end

function modifier_imba_berserkers_rage_melee:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_imba_berserkers_rage_melee:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("base_attack_time")
end

function modifier_imba_berserkers_rage_melee:OnAttackLanded( params )
	if IsServer() then
		if params.attacker:PassivesDisabled() then
			return nil
		end
		local parent = self:GetParent()
		if (parent == params.attacker) and (parent:IsRealHero() or parent:IsClone()) and params.attacker:GetTeam() ~= params.target:GetTeam() and not params.target:IsOther() and not params.target:IsBuilding() then
			local ability = self:GetAbility()
			
			-- Bash is now a talent, get bent lul
			if parent:HasTalent("special_bonus_imba_troll_warlord_9") then
				
				-- Add Troll Warlord to Skull Basher restriction since he has this talent now
				if not self.bash_talent then
					table.insert(IMBA_DISABLED_SKULL_BASHER, "npc_dota_hero_troll_warlord")
					
					self.bash_talent = true
				end
				
				if RollPseudoRandom(ability:GetSpecialValueFor("ensnare_chance"), ability) then
					local bash_damage = ability:GetSpecialValueFor("bash_damage")
					local ensnare_duration = ability:GetSpecialValueFor("ensnare_duration")
					ApplyDamage({victim = params.target, attacker = parent, ability = ability, damage = bash_damage, damage_type = DAMAGE_TYPE_MAGICAL})
					params.target:AddNewModifier(parent, ability, "modifier_stunned", {duration = ensnare_duration * (1 - params.target:GetStatusResistance())})
					
					params.target:EmitSound("DOTA_Item.SkullBasher")
				end
			else
				if not params.target:IsMagicImmune() and RollPseudoRandom(ability:GetSpecialValueFor("ensnare_chance"), ability) then
					local net =
					{
						Target = params.target,
						Source = parent,
						Ability = self:GetAbility(),
						bDodgeable = false,
						EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net_projectile.vpcf",
						iMoveSpeed = 1500, -- IDK how fast this is supposed to be...
						flExpireTime = GameRules:GetGameTime() + 10
					}

					ProjectileManager:CreateTrackingProjectile(net)
				end
			end
		end
	end
end

function modifier_imba_berserkers_rage_melee:GetActivityTranslationModifiers()
	if self:GetParent():GetName() == "npc_dota_hero_troll_warlord" then
		return "melee"
	end
	return 0
end

-- Note: This is for BAT-modifying, since only troll modify BAT of others and himself
function modifier_imba_berserkers_rage_melee:GetPriority()
	return 1
end

function modifier_imba_berserkers_rage_melee:GetModifierAttackRangeBonus()
	return -350
end

function modifier_imba_berserkers_rage_melee:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_berserk_buff.vpcf"
end

function modifier_imba_berserkers_rage_melee:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end
-------------------------------------------
modifier_imba_berserkers_rage_ranged = modifier_imba_berserkers_rage_ranged or class({})
function modifier_imba_berserkers_rage_ranged:AllowIllusionDuplicate() return true end
function modifier_imba_berserkers_rage_ranged:IsDebuff() return false end
function modifier_imba_berserkers_rage_ranged:IsHidden() return true end
function modifier_imba_berserkers_rage_ranged:IsPurgable() return false end
function modifier_imba_berserkers_rage_ranged:IsPurgeException() return false end
function modifier_imba_berserkers_rage_ranged:IsStunDebuff() return false end
function modifier_imba_berserkers_rage_ranged:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_berserkers_rage_ranged:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
		}
	return decFuns
end

function modifier_imba_berserkers_rage_ranged:GetModifierMoveSpeedBonus_Constant()
	return self:GetCaster():FindTalentValue("special_bonus_imba_troll_warlord_1", "movespeed_pct")
end

function modifier_imba_berserkers_rage_ranged:GetModifierPhysicalArmorBonus()
	return self:GetCaster():FindTalentValue("special_bonus_imba_troll_warlord_1", "armor")
end

function modifier_imba_berserkers_rage_ranged:GetModifierBaseAttackTimeConstant()
	return self:GetCaster():FindTalentValue("special_bonus_imba_troll_warlord_1", "bat")
end

-- Note: This is for BAT-modifying, since only troll modify BAT of others and himself
function modifier_imba_berserkers_rage_ranged:GetPriority()
	return 1
end

function modifier_imba_berserkers_rage_ranged:OnAttackLanded( params )
	if IsServer() then
		local parent = self:GetParent()
		if params.attacker:PassivesDisabled() then
			return nil
		end
		if (parent == params.attacker) and (parent:IsRealHero() or parent:IsClone()) then
			local ability = self:GetAbility()
			if RollPseudoRandom(ability:GetSpecialValueFor("ensnare_chance"), ability) then
				local hamstring_duration = ability:GetSpecialValueFor("hamstring_duration")
				params.target:AddNewModifier(parent, ability, "modifier_imba_berserkers_rage_slow", {duration = hamstring_duration * (1 - params.target:GetStatusResistance())})
				params.target:EmitSound("DOTA_Item.Daedelus.Crit")
			end
		end
	end
end

-------------------------------------------
modifier_imba_berserkers_rage_slow = modifier_imba_berserkers_rage_slow or class({})
function modifier_imba_berserkers_rage_slow:IsDebuff() return true end
function modifier_imba_berserkers_rage_slow:IsHidden() return false end
function modifier_imba_berserkers_rage_slow:IsPurgable() return true end
function modifier_imba_berserkers_rage_slow:IsStunDebuff() return false end
function modifier_imba_berserkers_rage_slow:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_berserkers_rage_slow:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return decFuns
end

function modifier_imba_berserkers_rage_slow:OnCreated()
	self.slow = self:GetAbility():GetSpecialValueFor("hamstring_slow_pct") * (-1)
end

function modifier_imba_berserkers_rage_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

-------------------------------------------
--		  WHIRLING AXES (RANGED)
-------------------------------------------
LinkLuaModifier("modifier_imba_whirling_axes_ranged", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_whirling_axes_ranged = imba_troll_warlord_whirling_axes_ranged or class({})
function imba_troll_warlord_whirling_axes_ranged:IsHiddenWhenStolen() return false end
function imba_troll_warlord_whirling_axes_ranged:IsRefreshable() return true end
function imba_troll_warlord_whirling_axes_ranged:IsStealable() return true end
function imba_troll_warlord_whirling_axes_ranged:IsNetherWardStealable() return true end

function imba_troll_warlord_whirling_axes_ranged:GetAbilityTextureName()
	return "troll_warlord_whirling_axes_ranged"
end
-------------------------------------------

function imba_troll_warlord_whirling_axes_ranged:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_troll_warlord_5")
end

function imba_troll_warlord_whirling_axes_ranged:OnUpgrade()
	if IsServer() then
		local ability_melee = self:GetCaster():FindAbilityByName("imba_troll_warlord_whirling_axes_melee")
		local level = self:GetLevel()
		if ability_melee then
			if ability_melee:GetLevel() < level then
				ability_melee:SetLevel(level)
			end
		end
	end
end

function imba_troll_warlord_whirling_axes_ranged:OnAbilityPhaseStart()
	if self:GetCaster():HasModifier("modifier_imba_battle_trance_720") then
		self:SetOverrideCastPoint(0)
	else
		self:SetOverrideCastPoint(0.2) -- Hard-coded...but yeah
	end
	
	return true
end

function imba_troll_warlord_whirling_axes_ranged:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local axe_width = self:GetSpecialValueFor("axe_width")
		local axe_speed = self:GetSpecialValueFor("axe_speed")
		local axe_range = self:GetSpecialValueFor("axe_range") + GetCastRangeIncrease(caster)
		local axe_damage = self:GetSpecialValueFor("axe_damage")
		local duration = self:GetSpecialValueFor("duration")
		local axe_spread = self:GetSpecialValueFor("axe_spread")
		local axe_count = self:GetSpecialValueFor("axe_count")
		local on_hit_pct = self:GetSpecialValueFor("on_hit_pct")
		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end

		-- #7 Talent: Ranged Whirling Axe axes count
		axe_count = axe_count + caster:FindTalentValue("special_bonus_imba_troll_warlord_7", "axe_count_increase")
		axe_spread = axe_spread + caster:FindTalentValue("special_bonus_imba_troll_warlord_7", "axe_spread_increase")

		-- Emit sounds
		caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Ranged")
		-- Randomly play a cast line
		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_troll_warlord") then
			caster:EmitSound("troll_warlord_troll_whirlingaxes_0"..math.random(1,6))
		end
		-- Create a unique table with stored hit enemies
		local index = DoUniqueString("index")
		self[index] = {}
		-- Dynamic projectile spawning via angles
		local start_angle
		local interval_angle = 0
		if axe_count == 1 then
			start_angle = 0
		else
			start_angle = axe_spread / 2 * (-1)
			interval_angle = axe_spread / (axe_count - 1)
		end
		for i = 1, axe_count, 1 do
			local angle = start_angle + (i-1) * interval_angle
			local velocity = RotateVector2D(direction,angle,true) * axe_speed

			local projectile =
				{
					Ability				= self,
					EffectName			= "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf",
					vSpawnOrigin		= caster_loc,
					fDistance			= axe_range,
					fStartRadius		= axe_width,
					fEndRadius			= axe_width,
					Source				= caster,
					bHasFrontalCone		= false,
					bReplaceExisting	= false,
					iUnitTargetTeam		= self:GetAbilityTargetTeam(),
					iUnitTargetFlags	= self:GetAbilityTargetFlags(),
					iUnitTargetType		= self:GetAbilityTargetType(),
					fExpireTime 		= GameRules:GetGameTime() + 10.0,
					bDeleteOnHit		= false,
					vVelocity			= Vector(velocity.x,velocity.y,0),
					bProvidesVision		= false,
					ExtraData			= {index = index, damage = axe_damage, duration = duration, axe_count = axe_count, on_hit_pct = on_hit_pct}
				}
			ProjectileManager:CreateLinearProjectile(projectile)
		end
	end
end

function imba_troll_warlord_whirling_axes_ranged:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	if target then
		local was_hit = false
		for _, stored_target in ipairs(self[ExtraData.index]) do
			if target == stored_target then
				was_hit = true
				break
			end
		end
		if was_hit then
			return nil
		end
		table.insert(self[ExtraData.index],target)
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		if RollPseudoRandom(ExtraData.on_hit_pct, self) then
			caster:PerformAttack(target, true, true, true, true, false, true, true)
		end
		target:AddNewModifier(caster, self, "modifier_imba_whirling_axes_ranged", {duration = ExtraData.duration * (1 - target:GetStatusResistance())})
		target:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")
	else
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
		if self[ExtraData.index]["count"] == ExtraData.axe_count then
			self[ExtraData.index] = nil
		end
	end
end

-------------------------------------------
modifier_imba_whirling_axes_ranged = modifier_imba_whirling_axes_ranged or class({})
function modifier_imba_whirling_axes_ranged:IsDebuff() return true end
function modifier_imba_whirling_axes_ranged:IsHidden() return false end
function modifier_imba_whirling_axes_ranged:IsPurgable() return true end
function modifier_imba_whirling_axes_ranged:IsPurgeException() return false end
function modifier_imba_whirling_axes_ranged:IsStunDebuff() return false end
function modifier_imba_whirling_axes_ranged:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_whirling_axes_ranged:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_whirling_axes_ranged:OnCreated()
	if not self:GetAbility() then self:Destroy() return end

	self.slow = self:GetAbility():GetTalentSpecialValueFor("movement_speed") * (-1)
end

function modifier_imba_whirling_axes_ranged:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
-------------------------------------------
--		  WHIRLING AXES (MELEE)
-------------------------------------------
LinkLuaModifier("modifier_imba_whirling_axes_melee", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_whirling_axes_melee = imba_troll_warlord_whirling_axes_melee or class({})
function imba_troll_warlord_whirling_axes_melee:IsHiddenWhenStolen() return false end
function imba_troll_warlord_whirling_axes_melee:IsRefreshable() return true end
function imba_troll_warlord_whirling_axes_melee:IsStealable() return true end
function imba_troll_warlord_whirling_axes_melee:IsNetherWardStealable() return true end

function imba_troll_warlord_whirling_axes_melee:GetAbilityTextureName()
	return "troll_warlord_whirling_axes_melee"
end
-------------------------------------------

function imba_troll_warlord_whirling_axes_melee:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_troll_warlord_5")
end

function imba_troll_warlord_whirling_axes_melee:OnUpgrade()
	if IsServer() then
		local ability_ranged = self:GetCaster():FindAbilityByName("imba_troll_warlord_whirling_axes_ranged")
		local level = self:GetLevel()
		if ability_ranged then
			if ability_ranged:GetLevel() < level then
				ability_ranged:SetLevel(level)
			end
		end
	end
end

function imba_troll_warlord_whirling_axes_melee:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local axe_radius = self:GetSpecialValueFor("axe_radius")
		local max_range = self:GetSpecialValueFor("max_range")
		local axe_movement_speed = self:GetSpecialValueFor("axe_movement_speed")
		local whirl_duration = self:GetSpecialValueFor("whirl_duration")
		local direction = caster:GetForwardVector()
		-- Emit sounds
		caster:EmitSound("Hero_TrollWarlord.WhirlingAxes.Melee")
		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_troll_warlord") then
			caster:EmitSound("troll_warlord_troll_whirlingaxes_0"..math.random(1,6))
		end
		-- Create a unique table with stored hit enemies
		local index = DoUniqueString("index")
		self[index] = {}
		-- Set the particle
		local axe_pfx = {}
		local axe_loc = {}
		local axe_random = {}
		for i=1, 10, 1 do
			table.insert(axe_pfx, ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_melee.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster))
			ParticleManager:SetParticleControl(axe_pfx[i], 1, caster_loc)
			ParticleManager:SetParticleControl(axe_pfx[i], 4, Vector(whirl_duration,0,0))
			table.insert(axe_random, math.random()*0.9+1.8)
		end
		local counter = 0
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
		-- Projectile logic
		-- Note: Most of it is purely cosmetical, it's basicly just checking if new units are in the increasing range
		-- Why? Because trollolololo
		Timers:CreateTimer(FrameTime(), function()
			counter = counter + FrameTime()
			caster_loc = caster:GetAbsOrigin()
			if counter <= (whirl_duration / 2) then
				for i=1, 10, 1 do
					axe_loc[i] = counter * (max_range - axe_radius) * RotateVector2D(direction,36*i + counter*axe_movement_speed,true):Normalized()
					self:DoAxeStuff(index,counter * (max_range-axe_radius)+axe_radius,caster_loc)
				end
			else
				for i=1, 10, 1 do
					axe_loc[i] = (whirl_duration - counter/2) * (max_range - axe_radius) * RotateVector2D(direction,36*i + counter*axe_movement_speed*axe_random[i],true):Normalized()
					self:DoAxeStuff(index,(whirl_duration - counter/2) * (max_range-axe_radius)+axe_radius,caster_loc)
				end
			end
			for i=1, 10, 1 do
				ParticleManager:SetParticleControl(axe_pfx[i], 1, caster_loc + axe_loc[i] + Vector(0,0,40))
			end
			if counter <= whirl_duration then
				return FrameTime()
			else
				for i=1, 10, 1 do
					ParticleManager:DestroyParticle(axe_pfx[i], false)
					ParticleManager:ReleaseParticleIndex(axe_pfx[i])
				end
			end
		end)
	end
end

function imba_troll_warlord_whirling_axes_melee:DoAxeStuff(index,range,caster_loc)
	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor("damage")
	local blind_duration = self:GetSpecialValueFor("blind_duration")
	local blind_stacks = self:GetSpecialValueFor("blind_stacks")
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, range, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _,enemy in ipairs(enemies) do
		local was_hit = false
		for _, stored_target in ipairs(self[index]) do
			if enemy == stored_target then
				was_hit = true
				break
			end
		end
		if was_hit then
			return nil
		else
			table.insert(self[index],enemy)
		end
		ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
		-- Imbued Axes
		caster:PerformAttack(enemy, true, true, true, true, false, true, true)
		enemy:AddNewModifier(caster, self, "modifier_imba_whirling_axes_melee", {duration = blind_duration * (1 - enemy:GetStatusResistance()), blind_stacks = blind_stacks})
		enemy:EmitSound("Hero_TrollWarlord.WhirlingAxes.Target")
	end
end

-------------------------------------------
modifier_imba_whirling_axes_melee = modifier_imba_whirling_axes_melee or class({})
function modifier_imba_whirling_axes_melee:IsDebuff() return true end
function modifier_imba_whirling_axes_melee:IsHidden() return false end
function modifier_imba_whirling_axes_melee:IsPurgable() return true end
function modifier_imba_whirling_axes_melee:IsPurgeException() return false end
function modifier_imba_whirling_axes_melee:IsStunDebuff() return false end
function modifier_imba_whirling_axes_melee:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_whirling_axes_melee:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_MISS_PERCENTAGE
		}
		
	return decFuns
end

function modifier_imba_whirling_axes_melee:OnCreated(params)
	self.miss_chance = self:GetAbility():GetSpecialValueFor("blind_pct")
end

function modifier_imba_whirling_axes_melee:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_imba_whirling_axes_melee:OnRefresh(params)
	self:OnCreated(params)
end

-------------------------------------------
--				FERVOR
-------------------------------------------
LinkLuaModifier("modifier_imba_fervor", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fervor_stacks", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_fervor = imba_troll_warlord_fervor or class({})
function imba_troll_warlord_fervor:IsHiddenWhenStolen() return false end
function imba_troll_warlord_fervor:IsRefreshable() return false end
function imba_troll_warlord_fervor:IsStealable() return false end
function imba_troll_warlord_fervor:IsNetherWardStealable() return false end

function imba_troll_warlord_fervor:GetAbilityTextureName()
	return "troll_warlord_fervor"
end
-------------------------------------------

function imba_troll_warlord_fervor:GetIntrinsicModifierName()
	local hCaster = self:GetCaster()
	if hCaster:IsRealHero() or hCaster:IsClone() then
		return "modifier_imba_fervor"
	end
	return nil
end

function imba_troll_warlord_fervor:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		if (math.random(1,100) <= 25) and (caster:GetName() == "npc_dota_hero_troll_warlord") then
			caster:EmitSound("troll_warlord_troll_fervor_0"..math.random(1,6))
		end
	end
end

-------------------------------------------
modifier_imba_fervor = modifier_imba_fervor or class({})
function modifier_imba_fervor:IsDebuff() return false end
function modifier_imba_fervor:IsHidden() return true end
function modifier_imba_fervor:IsPurgable() return false end
function modifier_imba_fervor:IsPurgeException() return false end
function modifier_imba_fervor:IsStunDebuff() return false end
function modifier_imba_fervor:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_fervor:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED
		}
	return decFuns
end

function modifier_imba_fervor:OnAttackLanded(params)
	local parent = self:GetParent()
	
	-- params.original_damage > 0 is so the Imbued Axes IMBAfication from Whirling Axes doesn't trigger Fervor
	if (
		(params.attacker == parent) or
		((params.attacker:GetTeamNumber() == parent:GetTeamNumber()) and params.attacker:HasModifier("modifier_imba_battle_trance") and parent:HasScepter())) and (params.attacker:IsRealHero() or params.attacker:IsClone()) and params.original_damage > 0 then
		
		local modifier = params.attacker:FindModifierByNameAndCaster("modifier_imba_fervor_stacks",parent)
		if modifier then
			if modifier.last_target == params.target then
--				if modifier:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
					modifier:IncrementStackCount()
--				end
			else
				local loss_pct = 1 - (self:GetAbility():GetTalentSpecialValueFor("switch_lose_pct") / 100)
				modifier:SetStackCount(math.max(math.floor(modifier:GetStackCount() * loss_pct),1))
				modifier.last_target = params.target
			end
		else
			modifier = params.attacker:AddNewModifier(parent, self:GetAbility(), "modifier_imba_fervor_stacks", {})
			modifier.last_target = params.target
		end
	end
end

-------------------------------------------
modifier_imba_fervor_stacks = modifier_imba_fervor_stacks or class({})
function modifier_imba_fervor_stacks:IsDebuff() return false end
function modifier_imba_fervor_stacks:IsHidden() return false end
function modifier_imba_fervor_stacks:IsPurgable() return false end
function modifier_imba_fervor_stacks:IsPurgeException() return false end
function modifier_imba_fervor_stacks:IsStunDebuff() return false end
function modifier_imba_fervor_stacks:RemoveOnDeath() return false end
-------------------------------------------

function modifier_imba_fervor_stacks:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_imba_fervor_stacks:OnCreated()
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_imba_fervor_stacks:GetModifierAttackSpeedBonus_Constant()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetTalentSpecialValueFor("bonus_as") * self:GetStackCount()
	end
	return 0
end

-------------------------------------------
--			  BATTLE TRANCE
-------------------------------------------
LinkLuaModifier("modifier_imba_battle_trance", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_battle_trance_720", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_battle_trance_vision_720", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_battle_trance = imba_troll_warlord_battle_trance or class({})
function imba_troll_warlord_battle_trance:IsHiddenWhenStolen() return false end
function imba_troll_warlord_battle_trance:IsRefreshable() return true end
function imba_troll_warlord_battle_trance:IsStealable() return true end
function imba_troll_warlord_battle_trance:IsNetherWardStealable() return true end

function imba_troll_warlord_battle_trance:GetAbilityTextureName()
	return "troll_warlord_battle_trance"
end
-------------------------------------------

-- Let's try it at the extremely reduced cooldown first and see if it's too strong or not
-- function imba_troll_warlord_battle_trance:GetCooldown( nLevel )
	-- if IsClient() or not self:GetAutoCastState() then
		-- return self.BaseClass.GetCooldown( self, nLevel )
	-- else
		-- return self:GetSpecialValueFor("self_cooldown")
	-- end
-- end

function imba_troll_warlord_battle_trance:GetBehavior()
	if IsServer() and self:GetAutoCastState() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST +DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST	
	end
end

function imba_troll_warlord_battle_trance:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_troll_warlord_battle_trance:OnSpellStart()
	if IsServer() then
		local caster	= self:GetCaster()
	
		if not self:GetAutoCastState() then
			-- The old Battle Trance
			local duration = self:GetTalentSpecialValueFor("buff_duration")

			-- Decide which cast sound to play
			local sound = "troll_warlord_troll_battletrance_0"..math.random(1,6)
			if (math.random(1,100) <= 10) then
				-- local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
				--if #heroes >= PlayerResource:GetPlayerCount() * 0.6666 then
					sound = "Imba.TrollAK47"
				--end
			end
			local allies = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			caster:EmitSound(sound)
			for _,ally in ipairs(allies) do
				local mod = ally:AddNewModifier(caster, self, "modifier_imba_battle_trance", {duration = duration})
				mod.sound = sound
				
				if ally.GetAttackTarget and ally:GetAttackTarget() then
					ally:GetAttackTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_battle_trance_vision_720", {duration = duration})
				end
			end
		else
			--The new Battle Trance
			
			-- AbilitySpecials
			local trance_duration	= self:GetSpecialValueFor("trance_duration")
			
			-- Emit sound
			caster:EmitSound("Hero_TrollWarlord.BattleTrance.Cast")
			
			-- Purge debuffs
			caster:Purge(false, true, false, false, false)
			
			-- Apply the lifesteal/movespeed/attackspeed/min health/tracking modifier
			caster:AddNewModifier(caster, self, "modifier_imba_battle_trance_720", {duration = trance_duration})
		end
		
		local cast_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt( cast_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(cast_pfx)
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	end
end

-------------------------------------------
modifier_imba_battle_trance = modifier_imba_battle_trance or class({})
function modifier_imba_battle_trance:IsDebuff() return false end
function modifier_imba_battle_trance:IsHidden() return false end
function modifier_imba_battle_trance:IsPurgable() return false end
function modifier_imba_battle_trance:IsPurgeException() return false end
function modifier_imba_battle_trance:IsStunDebuff() return false end
function modifier_imba_battle_trance:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_battle_trance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end

function modifier_imba_battle_trance:OnCreated()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	self.bonus_as = ability:GetTalentSpecialValueFor("bonus_as")
	self.bonus_bat = min(ability:GetTalentSpecialValueFor("bonus_bat"), parent:GetBaseAttackTime())
	if parent:IsRealHero() and IsServer() then
		EmitSoundOnClient("Hero_TrollWarlord.BattleTrance.Cast.Team", parent:GetPlayerOwner())
		if self.sound == "Imba.TrollAK47" then
			EmitSoundOnClient("Imba.TrollAK47.Team", parent:GetPlayerOwner())
		end
	end
end

function modifier_imba_battle_trance:OnRefresh()
	self:OnCreated()
end

function modifier_imba_battle_trance:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasAbility("imba_troll_warlord_fervor") and parent:HasModifier("modifier_imba_fervor_stacks") then
			parent:RemoveModifierByName("modifier_imba_fervor_stacks")
		end
	end
end

function modifier_imba_battle_trance:GetPriority()
	return 10
end

function modifier_imba_battle_trance:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_battle_trance:GetModifierBaseAttackTimeConstant()
	return self.bonus_bat
end

function modifier_imba_battle_trance:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_imba_battle_trance:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

-------------------------------------------
-- BATTLE TRANCE MODIFIER (7.20 VERSION) --
-------------------------------------------

modifier_imba_battle_trance_720 = class({})

function modifier_imba_battle_trance_720:IsPurgable()	return false end

function modifier_imba_battle_trance_720:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_imba_battle_trance_720:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.lifesteal		= self.ability:GetSpecialValueFor("lifesteal")
	self.attack_speed	= self.ability:GetSpecialValueFor("attack_speed")
	self.movement_speed	= self.ability:GetSpecialValueFor("movement_speed")
	self.range			= self.ability:GetSpecialValueFor("range")
	
	self.bonus_bat 		= min(self.ability:GetTalentSpecialValueFor("bonus_bat"), self.parent:GetBaseAttackTime())

	if not IsServer() then return end
	
	-- Keep track of a target (otherwise caster keeps switching if target goes out of range)
	self.target = nil
	
	-- IntervalThink for enemy tracking
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

-- Kinda convoluted...
function modifier_imba_battle_trance_720:OnIntervalThink()
	if not IsServer() or self.ability:IsNull() then return end

	-- If there's already a valid target, don't do anything else
	if self.target and self.target:IsAlive() and not self.target:IsAttackImmune() and not self.target:IsInvulnerable() and self.caster:CanEntityBeSeenByMyTeam(self.target) then
			
		if self:GetStackCount() ~= 1 then
			self:SetStackCount(1)
		end
		
		self.caster:MoveToTargetToAttack(self.target)
	
		if not self.target:HasModifier("modifier_imba_battle_trance_vision_720") and (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() <= self.range then
			self.target:AddNewModifier(self.caster, self.ability, "modifier_imba_battle_trance_vision_720", {})
		elseif self.target:HasModifier("modifier_imba_battle_trance_vision_720") and (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.range then
			self.target:RemoveModifierByName("modifier_imba_battle_trance_vision_720")
		end
		
		-- Target found; don't need to continue logic
		return
	-- If there is a target but they failed the above check, remove any vision modifier they may have because they shouldn't be the target anymore
	elseif self.target and self.target:HasModifier("modifier_imba_battle_trance_vision_720") then
		self.target:RemoveModifierByName("modifier_imba_battle_trance_vision_720")
	end

		self.caster:MoveToTargetToAttack(self.target)
	-- If the caster is targetting someone but they aren't set in the variable, do so
	if self.caster:GetAttackTarget() and self.caster:GetAttackTarget():IsAlive() and not self.caster:GetAttackTarget():IsAttackImmune() and not self.caster:GetAttackTarget():IsInvulnerable() and self.caster:CanEntityBeSeenByMyTeam(self.caster:GetAttackTarget()) then
		self.target = self.caster:GetAttackTarget()
		self.caster:MoveToTargetToAttack(self.target)
		
		-- Target found; don't need to continue logic
		return
	end
	
	-- Otherwise, find a target
	local hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)

	if #hero_enemies > 0 then
		for enemy = 1, #hero_enemies do
			if self.caster:CanEntityBeSeenByMyTeam(hero_enemies[enemy]) then
				self.caster:MoveToTargetToAttack(hero_enemies[enemy])
				self.target = hero_enemies[enemy]
				self:SetStackCount(1)
				
				-- Target found; don't need to continue logic
				return
			end
		end
	end

	-- If there's no heroes around, check for creeps
	local non_hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
	
	if #non_hero_enemies > 0 then
		for enemy = 1, #non_hero_enemies do
			if self.caster:CanEntityBeSeenByMyTeam(non_hero_enemies[enemy]) and not non_hero_enemies[enemy]:IsRoshan() then
				self.caster:MoveToTargetToAttack(non_hero_enemies[enemy])
				self.target = non_hero_enemies[enemy]
				self:SetStackCount(1)
				
				-- Target found; don't need to continue logic
				return
			end
		end
	end
	
	-- If the function has gotten this far, then no one is around for the caster to wail on...return full control of hero
	if self.target then
		if self.target:HasModifier("modifier_imba_battle_trance_vision_720") then
			self.target:RemoveModifierByName("modifier_imba_battle_trance_vision_720")
		end	
	
		self.target	= nil
	end
	
	self:SetStackCount(0)
end

function modifier_imba_battle_trance_720:OnDestroy()
	if self.target and self.target:HasModifier("modifier_imba_battle_trance_vision_720") then
		self.target:RemoveModifierByName("modifier_imba_battle_trance_vision_720")
	end	
end

function modifier_imba_battle_trance_720:GetPriority()
	return 10
end

-- More logic in the order filter cause of stupid potential stops/interrupts
function modifier_imba_battle_trance_720:CheckState()
	-- Use stack count to track if the caster has locked onto a target (for client/server purposes...assuming this is important)
	if self:GetStackCount() == 1 then
		local state = {}
		
		state[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
		
		if self.caster:HasScepter() then
			state[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
		end
		
		return state
	else
		return {}
	end
end

function modifier_imba_battle_trance_720:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,

		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_TOOLTIP,
		
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end

-- Custom function made in IMBA library and not in DeclareFunctions
function modifier_imba_battle_trance_720:GetModifierLifesteal()
	return self.lifesteal
end

function modifier_imba_battle_trance_720:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_imba_battle_trance_720:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_imba_battle_trance_720:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_imba_battle_trance_720:GetMinHealth()
	return 1
end

function modifier_imba_battle_trance_720:OnTooltip()
	return self.lifesteal
end

function modifier_imba_battle_trance_720:GetModifierBaseAttackTimeConstant()
	return self.bonus_bat
end

--------------------------------------------------
-- BATTLE TRANCE VISION MODIFIER (7.20 VERSION) --
--------------------------------------------------

modifier_imba_battle_trance_vision_720 = class({})

function modifier_imba_battle_trance_vision_720:IsPurgable()		return false end
function modifier_imba_battle_trance_vision_720:IgnoreTenacity()	return false end

function modifier_imba_battle_trance_vision_720:GetPriority()	return MODIFIER_PRIORITY_ULTRA end

function modifier_imba_battle_trance_vision_720:GetEffectName()
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_battle_trance_upgrade") then
		return "particles/items2_fx/true_sight_debuff.vpcf"
	end
end

function modifier_imba_battle_trance_vision_720:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_battle_trance_vision_720:CheckState()
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_battle_trance_upgrade") then
		return {[MODIFIER_STATE_INVISIBLE] = false}
	end
end

function modifier_imba_battle_trance_vision_720:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end

function modifier_imba_battle_trance_vision_720:GetModifierProvidesFOWVision()
	return 1
end

-- Client-side helper functions

LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_7", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_troll_warlord_7		= modifier_special_bonus_imba_troll_warlord_7 or class({})

function modifier_special_bonus_imba_troll_warlord_7:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_7:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_7:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_1", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_2", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_4", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_5", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_8", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_troll_warlord_1		= modifier_special_bonus_imba_troll_warlord_1 or class({})
modifier_special_bonus_imba_troll_warlord_2		= modifier_special_bonus_imba_troll_warlord_2 or class({})
modifier_special_bonus_imba_troll_warlord_4		= modifier_special_bonus_imba_troll_warlord_4 or class({})
modifier_special_bonus_imba_troll_warlord_5		= modifier_special_bonus_imba_troll_warlord_5 or class({})
modifier_special_bonus_imba_troll_warlord_8		= modifier_special_bonus_imba_troll_warlord_5 or class({})
modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade	= modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade or class({})

function modifier_special_bonus_imba_troll_warlord_1:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_1:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_1:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_troll_warlord_2:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_2:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_2:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_troll_warlord_4:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_4:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_4:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_troll_warlord_5:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_5:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_5:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_troll_warlord_8:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_8:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_8:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade:IsHidden() 		return true end
function modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade:IsPurgable() 		return false end
function modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade:RemoveOnDeath() 	return false end

function imba_troll_warlord_whirling_axes_ranged:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_2") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_2"), "modifier_special_bonus_imba_troll_warlord_2", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_5") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_5") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_5"), "modifier_special_bonus_imba_troll_warlord_5", {})
	end
end

function imba_troll_warlord_fervor:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_4") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_4") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_4"), "modifier_special_bonus_imba_troll_warlord_4", {})
	end
end

function imba_troll_warlord_battle_trance:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_8") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_8") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_8"), "modifier_special_bonus_imba_troll_warlord_8", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_troll_warlord_battle_trance_upgrade") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_troll_warlord_battle_trance_upgrade"), "modifier_special_bonus_imba_troll_warlord_battle_trance_upgrade", {})
	end
end
