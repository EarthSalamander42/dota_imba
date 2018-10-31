-- Editors:
--     Firetoad
--     AtroCty, 09.04.2017

-------------------------------------------
--			  BESERKERS RAGE
-------------------------------------------
LinkLuaModifier("modifier_imba_berserkers_rage_ranged", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_rage_slow", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_berserkers_rage_melee", "components/abilities/heroes/hero_troll_warlord", LUA_MODIFIER_MOTION_NONE)

imba_troll_warlord_berserkers_rage = imba_troll_warlord_berserkers_rage or class({})
function imba_troll_warlord_berserkers_rage:IsHiddenWhenStolen() return false end
function imba_troll_warlord_berserkers_rage:IsRefreshable() return true end
function imba_troll_warlord_berserkers_rage:IsStealable() return false end
function imba_troll_warlord_berserkers_rage:IsNetherWardStealable() return false end
function imba_troll_warlord_berserkers_rage:ResetToggleOnRespawn() return true end

-- Always have one of the buffs
function imba_troll_warlord_berserkers_rage:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
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
			caster:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", false, true)
			caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
			self.mode = 2
		else
			caster:RemoveModifierByName("modifier_imba_berserkers_rage_melee")
			caster:AddNewModifier(caster, self, "modifier_imba_berserkers_rage_ranged", {})
			caster:SwapAbilities("imba_troll_warlord_whirling_axes_ranged", "imba_troll_warlord_whirling_axes_melee", true, false)
			caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
			self.mode = 1
		end
	end
end

function imba_troll_warlord_berserkers_rage:GetAbilityTextureName()
	if self.mode == 1 then
		return "troll_warlord_berserkers_rage_active"
	else
		return "troll_warlord_berserkers_rage"
	end
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
		if (parent == params.attacker) and (parent:IsRealHero() or parent:IsClone()) and not params.target:IsBuilding() then
			local ability = self:GetAbility()
			if RollPseudoRandom(ability:GetSpecialValueFor("bash_chance"), ability) then
				local bash_damage = ability:GetSpecialValueFor("bash_damage")
				local bash_duration = ability:GetSpecialValueFor("bash_duration")
				ApplyDamage({victim = params.target, attacker = parent, ability = ability, damage = bash_damage, damage_type = ability:GetAbilityDamageType()})
				params.target:AddNewModifier(parent, ability, "modifier_stunned", {duration = bash_duration})
				params.target:EmitSound("DOTA_Item.SkullBasher")
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
			if RollPseudoRandom(ability:GetSpecialValueFor("hamstring_chance"), ability) then
				local hamstring_duration = ability:GetSpecialValueFor("hamstring_duration")
				params.target:AddNewModifier(parent, ability, "modifier_imba_berserkers_rage_slow", {duration = hamstring_duration})
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
		target:AddNewModifier(caster, self, "modifier_imba_whirling_axes_ranged", {duration = ExtraData.duration})
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
	local decFuns =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return decFuns
end

function modifier_imba_whirling_axes_ranged:OnCreated()
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
		enemy:AddNewModifier(caster, self, "modifier_imba_whirling_axes_melee", {duration = blind_duration, blind_stacks = blind_stacks})
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
			MODIFIER_PROPERTY_MISS_PERCENTAGE,
			MODIFIER_EVENT_ON_ATTACK_FAIL
		}
	return decFuns
end

function modifier_imba_whirling_axes_melee:OnCreated(params)
	self.miss_chance = self:GetAbility():GetSpecialValueFor("blind_pct")
	if IsServer() then
		self:SetStackCount(params.blind_stacks)
	end
end

function modifier_imba_whirling_axes_melee:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_imba_whirling_axes_melee:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_whirling_axes_melee:OnAttackFail(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if self:GetStackCount() == 1 then
				self:Destroy()
			else
				self:DecrementStackCount()
			end
		end
	end
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
	if (
		(params.attacker == parent) or
		((params.attacker:GetTeamNumber() == parent:GetTeamNumber()) and params.attacker:HasModifier("modifier_imba_battle_trance") and parent:HasScepter())) and
		(not params.attacker:PassivesDisabled()) and (params.attacker:IsRealHero() or params.attacker:IsClone()) then
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
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return decFuns
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

imba_troll_warlord_battle_trance = imba_troll_warlord_battle_trance or class({})
function imba_troll_warlord_battle_trance:IsHiddenWhenStolen() return false end
function imba_troll_warlord_battle_trance:IsRefreshable() return true end
function imba_troll_warlord_battle_trance:IsStealable() return true end
function imba_troll_warlord_battle_trance:IsNetherWardStealable() return true end

function imba_troll_warlord_battle_trance:GetAbilityTextureName()
	return "troll_warlord_battle_trance"
end
-------------------------------------------

function imba_troll_warlord_battle_trance:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetTalentSpecialValueFor("buff_duration")

		-- Decide which cast sound to play
		local sound = "troll_warlord_troll_battletrance_0"..math.random(1,6)
		if (math.random(1,100) <= 10) then
			-- local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
			--if #heroes >= PlayerResource:GetPlayerCount() * 0.6666 then
				sound = "Imba.TrollAK47"
			--end
		end
		local allies = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, 25000, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		caster:EmitSound(sound)
		for _,ally in ipairs(allies) do
			local mod = ally:AddNewModifier(caster, self, "modifier_imba_battle_trance", {duration = duration})
			mod.sound = sound
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
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
		}
	return decFuns
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
