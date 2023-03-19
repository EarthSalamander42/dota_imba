-- Editors:
--     Firetoad
--     AtroCty, 23.04.2017
--     AltiV, 17.01.2020


LinkLuaModifier("modifier_imba_poison_sting_v2_ward", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_venomancer_plague_ward_v2", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

modifier_imba_poison_sting_v2_ward      = modifier_imba_poison_sting_v2_ward or class({})

imba_venomancer_plague_ward_v2          = imba_venomancer_plague_ward_v2 or class({})
modifier_imba_venomancer_plague_ward_v2 = modifier_imba_venomancer_plague_ward_v2 or class({})

-------------------------------------------
--				TOXICITY
-------------------------------------------
LinkLuaModifier("modifier_imba_toxicity", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_toxicity_debuff", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

imba_venomancer_toxicity = class({})
function imba_venomancer_toxicity:IsHiddenWhenStolen() return false end

function imba_venomancer_toxicity:IsRefreshable() return false end

function imba_venomancer_toxicity:IsStealable() return false end

function imba_venomancer_toxicity:IsNetherWardStealable() return false end

function imba_venomancer_toxicity:IsInnateAbility() return true end

function imba_venomancer_toxicity:GetAbilityTextureName()
	return "venomancer_toxicity"
end

-------------------------------------------

function imba_venomancer_toxicity:GetIntrinsicModifierName()
	return "modifier_imba_toxicity"
end

-------------------------------------------
modifier_imba_toxicity = class({})
function modifier_imba_toxicity:IsDebuff() return false end

function modifier_imba_toxicity:IsHidden() return true end

function modifier_imba_toxicity:IsPurgable() return false end

function modifier_imba_toxicity:IsPurgeException() return false end

function modifier_imba_toxicity:IsStunDebuff() return false end

function modifier_imba_toxicity:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_toxicity:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_imba_toxicity:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			local debuff = enemy:FindModifierByNameAndCaster("modifier_imba_toxicity_debuff", caster)
			local poisons = {}
			table.insert(poisons, enemy:FindModifierByNameAndCaster("modifier_imba_venomous_gale", caster))
			table.insert(poisons, enemy:FindModifierByNameAndCaster("modifier_imba_poison_sting_debuff", caster))
			table.insert(poisons, enemy:FindModifierByNameAndCaster("modifier_imba_poison_sting_debuff_ward", caster))
			table.insert(poisons, enemy:FindModifierByNameAndCaster("modifier_imba_poison_sting_v2_ward", caster))
			local novas = enemy:FindAllModifiersByName("modifier_imba_poison_nova")
			for _, nova in pairs(novas) do
				if nova:GetCaster() == self:GetCaster() then
					table.insert(poisons, nova)
				end
			end
			-- Only increase or apply if not break, but still remove debuff if no poison is applied
			if not caster:PassivesDisabled() then
				for _, poison in pairs(poisons) do
					if debuff then
						debuff:IncrementStackCount()
					else
						debuff = enemy:AddNewModifier(caster, ability, "modifier_imba_toxicity_debuff", {})
					end
				end
			end
			if debuff and (#poisons == 0) then
				debuff:Destroy()
			end
		end
	end
end

-------------------------------------------
modifier_imba_toxicity_debuff = class({})
function modifier_imba_toxicity_debuff:IsDebuff() return true end

function modifier_imba_toxicity_debuff:IsHidden() return false end

function modifier_imba_toxicity_debuff:IsPurgable() return false end

function modifier_imba_toxicity_debuff:IsPurgeException() return false end

function modifier_imba_toxicity_debuff:IsStunDebuff() return false end

function modifier_imba_toxicity_debuff:RemoveOnDeath() return true end

-------------------------------------------

function modifier_imba_toxicity_debuff:OnCreated()
	self:SetStackCount(1)
end

-- -- TOXICITY meme with global cooldown
-- function modifier_imba_toxicity_debuff:OnDeath( params )
-- if IsServer() then
-- local caster = self:GetCaster()
-- if (params.unit == self:GetParent()) and params.unit:IsRealHero() and (params.attacker == caster) then
-- if self:GetStackCount() > 100 and not _G.TOXICITY then
-- _G.TOXICITY = true
-- local dummy = CreateUnitByName("npc_dummy_unit", params.unit:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
-- dummy:EmitSound("Venomancer.Toxicity")
-- Timers:CreateTimer(60, function()
-- _G.TOXICITY = nil
-- dummy:Destroy()
-- end)
-- end
-- end
-- end
-- end

function modifier_imba_toxicity_debuff:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		-- MODIFIER_EVENT_ON_DEATH
	}
	return decFuns
end

function modifier_imba_toxicity_debuff:GetModifierMagicalResistanceBonus()
	if self:GetAbility() then
		return (self:GetAbility():GetTalentSpecialValueFor("magic_amp_pct") * self:GetStackCount()) * (-1)
	end
end

-------------------------------------------
--            VENOMOUS GALE
-------------------------------------------
LinkLuaModifier("modifier_imba_venomous_gale", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_venomous_gale_wardcast", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

imba_venomancer_venomous_gale = class({})
function imba_venomancer_venomous_gale:IsHiddenWhenStolen() return false end

function imba_venomancer_venomous_gale:IsRefreshable() return true end

function imba_venomancer_venomous_gale:IsStealable() return true end

function imba_venomancer_venomous_gale:IsNetherWardStealable() return true end

function imba_venomancer_venomous_gale:GetAbilityTextureName()
	return "venomancer_venomous_gale"
end

-------------------------------------------

function imba_venomancer_venomous_gale:GetCastRange(location, target)
	-- local range = self:GetSpecialValueFor("cast_range")
	-- if IsServer() then
	-- local caster = self:GetCaster()
	-- if (caster:GetAbsOrigin() - location):Length2D() <= (range + GetCastRangeIncrease(caster)) then
	-- self.bWardCaster = nil
	-- return range
	-- end
	-- local ward_range = self:GetSpecialValueFor("ward_range") + GetCastRangeIncrease(caster)
	-- local wards = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, ward_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY,  DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	-- for _, ward in pairs(wards) do
	-- if ward.bIsScourge then
	-- self.bWardCaster = ward
	-- return 25000
	-- end
	-- end
	-- self.bWardCaster = nil
	-- end
	-- return range

	if IsClient() then
		return self.BaseClass.GetCastRange(self, location, target)
	else
		for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("ward_range") + self:GetCaster():GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)) do
			if ally:GetName() == "npc_dota_venomancer_plagueward" and ally:GetOwner() == self:GetCaster() then
				return 25000
			end
		end

		-- Cast range is standard if no nearby plague wards are found
		return self.BaseClass.GetCastRange(self, location, target)
	end
end

function imba_venomancer_venomous_gale:GetCastAnimation()
	if self.bWardCaster then
		return 0
	else
		return ACT_DOTA_CAST_ABILITY_1
	end
end

function imba_venomancer_venomous_gale:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	local caster_loc
	local cast_range = self:GetSpecialValueFor("cast_range")
	local ward_range = self:GetSpecialValueFor("ward_range") + GetCastRangeIncrease(caster)

	-- if (caster:GetAbsOrigin() - target_loc):Length2D() >= (cast_range + GetCastRangeIncrease(caster)) then
	-- local wards = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, ward_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	-- for _, ward in pairs(wards) do
	-- if ward:GetUnitName() == "npc_imba_venomancer_scourge_ward" then
	-- self.bWardCaster = ward
	-- break
	-- end
	-- end
	-- end

	if (self:GetCaster():GetAbsOrigin() - self:GetCursorPosition()):Length2D() > self:GetSpecialValueFor("cast_range") + self:GetCaster():GetCastRangeBonus() then
		for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("ward_range") + self:GetCaster():GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)) do
			if ally:GetName() == "npc_dota_venomancer_plagueward" and ally:GetOwner() == self:GetCaster() and (ally:GetAbsOrigin() - self:GetCursorPosition()):Length2D() < (self:GetCaster():GetAbsOrigin() - self:GetCursorPosition()):Length2D() then
				self.bWardCaster = ally
				break
			end
		end
	end

	local mouth_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_venomous_gale_mouth.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	if self.bWardCaster then
		caster_loc = self.bWardCaster:GetAbsOrigin()
		ParticleManager:SetParticleControlEnt(mouth_pfx, 0, self.bWardCaster, PATTACH_POINT_FOLLOW, "attach_attack1", self.bWardCaster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(mouth_pfx)
		self.bWardCaster:AddNewModifier(caster, self, "modifier_imba_venomous_gale_wardcast", { duration = 0.4 })
		self.bWardCaster:FadeGesture(ACT_DOTA_ATTACK)
		self.bWardCaster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2.3)
		self.bWardCaster:SetForwardVector((target_loc - caster_loc):Normalized())
	else
		caster_loc = caster:GetAbsOrigin()
		ParticleManager:SetParticleControlEnt(mouth_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(mouth_pfx)
	end

	-- Parameters
	local duration = self:GetSpecialValueFor("duration")
	local strike_damage = self:GetSpecialValueFor("strike_damage")
	local tick_damage = self:GetSpecialValueFor("tick_damage")
	local tick_interval = self:GetSpecialValueFor("tick_interval")
	local projectile_speed = self:GetSpecialValueFor("speed")
	local radius = self:GetSpecialValueFor("radius")

	local direction
	if target_loc == caster_loc then
		direction = caster:GetForwardVector()
	else
		direction = (target_loc - caster_loc):Normalized()
	end
	local index = DoUniqueString("index")
	self[index] = {}
	local travel_distance
	caster:EmitSound("Hero_Venomancer.VenomousGale")

	local projectile_count = 1
	if caster:HasTalent("special_bonus_imba_venomancer_7") then
		projectile_count = caster:FindTalentValue("special_bonus_imba_venomancer_7")
	end

	ParticleManager:SetParticleControlEnt(mouth_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_mouth", caster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(mouth_pfx)

	for i = 1, projectile_count, 1 do
		local angle = 360 - (360 / projectile_count) * i
		local velocity = RotateVector2D(direction, angle, true)
		local projectile
		if self.bWardCaster then
			travel_distance = self:GetSpecialValueFor("ward_range") + GetCastRangeIncrease(caster)
			projectile =
			{
				Ability           = self,
				EffectName        = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
				vSpawnOrigin      = self.bWardCaster:GetAbsOrigin(),
				fDistance         = travel_distance,
				fStartRadius      = radius,
				fEndRadius        = radius,
				Source            = caster,
				bHasFrontalCone   = true,
				bReplaceExisting  = false,
				iUnitTargetTeam   = self:GetAbilityTargetTeam(),
				iUnitTargetFlags  = self:GetAbilityTargetFlags(),
				iUnitTargetType   = self:GetAbilityTargetType(),
				fExpireTime       = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit      = true,
				vVelocity         = Vector(velocity.x, velocity.y, 0) * projectile_speed,
				-- "The projectile has 280 radius flying vision. This vision does not last."
				bProvidesVision   = true,
				iVisionRadius     = 280,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				ExtraData         = { index = index, strike_damage = strike_damage, duration = duration, projectile_count = projectile_count }
			}
		else
			travel_distance = self.BaseClass.GetCastRange(self, target_loc, nil) + GetCastRangeIncrease(caster)
			projectile =
			{
				Ability           = self,
				EffectName        = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
				vSpawnOrigin      = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_mouth")),
				fDistance         = travel_distance,
				fStartRadius      = radius,
				fEndRadius        = radius,
				Source            = caster,
				bHasFrontalCone   = true,
				bReplaceExisting  = false,
				iUnitTargetTeam   = self:GetAbilityTargetTeam(),
				iUnitTargetFlags  = self:GetAbilityTargetFlags(),
				iUnitTargetType   = self:GetAbilityTargetType(),
				fExpireTime       = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit      = true,
				vVelocity         = Vector(velocity.x, velocity.y, 0) * projectile_speed,
				bProvidesVision   = true,
				iVisionRadius     = 280,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
				ExtraData         = { index = index, strike_damage = strike_damage, duration = duration, projectile_count = projectile_count }
			}
		end
		ProjectileManager:CreateLinearProjectile(projectile)
	end

	self.bWardCaster = nil
end

function imba_venomancer_venomous_gale:OnProjectileHit_ExtraData(target, location, ExtraData)
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
		else
			table.insert(self[ExtraData.index], target)
		end
		ApplyDamage({ victim = target, attacker = caster, ability = self, damage = ExtraData.strike_damage, damage_type = self:GetAbilityDamageType() })
		target:AddNewModifier(caster, self, "modifier_imba_venomous_gale", { duration = ExtraData.duration * (1 - target:GetStatusResistance()) })
		target:EmitSound("Hero_Venomancer.VenomousGaleImpact")

		-- Talent: Gale Hero Impact Summons {s:value} Wards
		if (target:IsRealHero() or target:IsClone()) and self:GetCaster():HasTalent("special_bonus_imba_venomancer_venomous_gale_plague_wards") and self:GetCaster():HasAbility("imba_venomancer_plague_ward_v2") and self:GetCaster():FindAbilityByName("imba_venomancer_plague_ward_v2"):IsTrained() then
			local starting_position = target:GetAbsOrigin() + RandomVector(100)

			for num = 1, self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_venomous_gale_plague_wards") do
				self:GetCaster():FindAbilityByName("imba_venomancer_plague_ward_v2"):OnSpellStart(RotatePosition(target:GetAbsOrigin(), QAngle(0, (360 / self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_venomous_gale_plague_wards")) * num, 0), starting_position))
			end
		end
	else
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] or 0
		self[ExtraData.index]["count"] = self[ExtraData.index]["count"] + 1
		if self[ExtraData.index]["count"] == ExtraData.projectile_count then
			if (#self[ExtraData.index] > 0) and (caster:GetName() == "npc_dota_hero_venomancer") then
				caster:EmitSound("venomancer_venm_cast_0" .. math.random(1, 2))
			end
			self[ExtraData.index] = nil
		end
	end
end

-------------------------------------------
modifier_imba_venomous_gale = class({})
function modifier_imba_venomous_gale:IsDebuff() return true end

function modifier_imba_venomous_gale:IsHidden() return false end

function modifier_imba_venomous_gale:IsStunDebuff() return false end

function modifier_imba_venomous_gale:RemoveOnDeath() return true end

function modifier_imba_venomous_gale:IgnoreTenacity() return true end

-------------------------------------------

function modifier_imba_venomous_gale:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_gale_poison_debuff.vpcf"
end

function modifier_imba_venomous_gale:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_venomous_gale:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_imba_venomous_gale:OnCreated()
	self.ability = self:GetAbility()

	self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")
	self.tick_damage = self.ability:GetSpecialValueFor("tick_damage")

	if not IsServer() then return end

	self.movement_slow = self.ability:GetTalentSpecialValueFor("movement_slow")
	self:SetStackCount(self.movement_slow * (1 - self:GetParent():GetStatusResistance()) * (-1) * 100)

	self.slow_recover_instances = 50 -- Total duration divided by intervals
	self.recover_per_instance = (self.movement_slow * (1 - self:GetParent():GetStatusResistance())) / self.slow_recover_instances

	self.counter = 0

	self:StartIntervalThink(0.3)
end

function modifier_imba_venomous_gale:OnRefresh()
	self:OnCreated()
end

function modifier_imba_venomous_gale:OnIntervalThink()
	self.counter = self.counter + 1
	local parent = self:GetParent()
	if self.counter >= (self.tick_interval / 0.3) then
		self.counter = 0

		ApplyDamage({ victim = parent, attacker = self:GetCaster(), ability = self.ability, damage = self.tick_damage, damage_type = self.ability:GetAbilityDamageType() })
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, self.tick_damage, nil)
	end

	-- if self.movement_slow > 0 then
	-- self.movement_slow = self.movement_slow - 1
	-- end

	if self:GetStackCount() <= 0 then
		self:SetStackCount(self:GetStackCount() + (self.recover_per_instance * 100))
	end
end

-- "A unit with less that 25% of its maximum health can be denied when it has the Venomous Gale debuff on."
function modifier_imba_venomous_gale:CheckState()
	if self:GetParent():GetHealthPercent() < 25 then
		return { [MODIFIER_STATE_SPECIALLY_DENIABLE] = true }
	end
end

function modifier_imba_venomous_gale:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_imba_venomous_gale:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() / 100
end

-------------------------------------------
modifier_imba_venomous_gale_wardcast = class({})
function modifier_imba_venomous_gale_wardcast:IsDebuff() return true end

function modifier_imba_venomous_gale_wardcast:IsHidden() return true end

function modifier_imba_venomous_gale_wardcast:IsPurgable() return false end

function modifier_imba_venomous_gale_wardcast:IsPurgeException() return false end

function modifier_imba_venomous_gale_wardcast:IsStunDebuff() return false end

function modifier_imba_venomous_gale_wardcast:RemoveOnDeath() return true end

-------------------------------------------

function modifier_imba_venomous_gale_wardcast:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_PROPERTY_DISABLE_TURNING
	}
	return decFuns
end

function modifier_imba_venomous_gale_wardcast:GetModifierDisableTurning()
	return 1
end

-------------------------------------------
--			  POISON STING
-------------------------------------------
LinkLuaModifier("modifier_imba_poison_sting", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_poison_sting_debuff", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_poison_sting_debuff_ward", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

imba_venomancer_poison_sting = class({})
function imba_venomancer_poison_sting:IsHiddenWhenStolen() return false end

function imba_venomancer_poison_sting:IsRefreshable() return false end

function imba_venomancer_poison_sting:IsStealable() return false end

function imba_venomancer_poison_sting:IsNetherWardStealable() return false end

function imba_venomancer_poison_sting:GetAbilityTextureName()
	return "venomancer_poison_sting"
end

-------------------------------------------

function imba_venomancer_poison_sting:GetIntrinsicModifierName()
	return "modifier_imba_poison_sting"
end

-------------------------------------------
modifier_imba_poison_sting = class({})
function modifier_imba_poison_sting:IsDebuff() return false end

function modifier_imba_poison_sting:IsHidden() return true end

function modifier_imba_poison_sting:IsPurgable() return false end

function modifier_imba_poison_sting:IsPurgeException() return false end

function modifier_imba_poison_sting:IsStunDebuff() return false end

function modifier_imba_poison_sting:RemoveOnDeath() return false end

-------------------------------------------

function modifier_imba_poison_sting:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_imba_poison_sting:OnAttack(params)
	if IsServer() then
		local caster = self:GetCaster()
		if (caster == params.target) and (params.attacker.IsCreep or params.attacker.IsHero) then
			if not params.attacker:IsBuilding() and caster:HasTalent("special_bonus_imba_venomancer_6") then
				local ability = self:GetAbility()
				local duration = ability:GetSpecialValueFor("duration")
				local mod = params.attacker:AddNewModifier(caster, ability, "modifier_imba_poison_sting_debuff", { duration = (duration - FrameTime()) * (1 - params.attacker:GetStatusResistance()) })
				-- mod:IncrementStackCount()
			end
		end
	end
end

function modifier_imba_poison_sting:OnAttackLanded(params)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local duration = ability:GetSpecialValueFor("duration")

		if caster:PassivesDisabled() then return end

		if (caster == params.attacker) and (params.target.IsCreep or params.target.IsHero) then
			if not params.target:IsBuilding() and not params.target:IsMagicImmune() then
				local mod = params.target:AddNewModifier(caster, ability, "modifier_imba_poison_sting_debuff", { duration = (duration - FrameTime()) * (1 - params.target:GetStatusResistance()) })
				-- if mod then
				-- mod:IncrementStackCount()
				-- end
			end
		end


		-- if params.attacker:GetName() == "npc_dota_venomancer_plagueward" then
		-- if (params.attacker:GetPlayerOwnerID() == caster:GetPlayerID()) and params.attacker.bIsScourge and (params.target.IsCreep or params.target.IsHero) then
		-- if not params.target:IsBuilding() then
		-- local poison = params.target:FindModifierByNameAndCaster("modifier_imba_poison_sting_debuff",caster)

		-- if poison then
		-- poison:SetDuration(poison:GetDuration(), true)
		-- else -- Scrouge Wards can now apply poison sting but it won't make it stack like crazy without talent
		-- params.target:AddNewModifier(caster, ability, "modifier_imba_poison_sting_debuff", {duration = duration})
		-- end

		-- if caster:HasTalent("special_bonus_imba_venomancer_8") then
		-- local mod = params.target:AddNewModifier(caster, ability, "modifier_imba_poison_sting_debuff_ward", {duration = duration})
		-- if mod then
		-- mod:IncrementStackCount()
		-- end
		-- end
		-- end
		-- end
		-- end
	end
end

-------------------------------------------
modifier_imba_poison_sting_debuff = class({})
function modifier_imba_poison_sting_debuff:IsDebuff() return true end

function modifier_imba_poison_sting_debuff:IsHidden() return false end

function modifier_imba_poison_sting_debuff:IsStunDebuff() return false end

function modifier_imba_poison_sting_debuff:RemoveOnDeath() return true end

function modifier_imba_poison_sting_debuff:IgnoreTenacity() return true end

-------------------------------------------

function modifier_imba_poison_sting_debuff:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_imba_poison_sting_debuff:OnCreated(params)
	self.damage             = self:GetAbility():GetSpecialValueFor("damage")
	self.stack_damage       = self:GetAbility():GetSpecialValueFor("stack_damage")
	self.hp_regen_reduction = self:GetAbility():GetSpecialValueFor("hp_regen_reduction") * (-1)

	if not IsServer() then return end

	self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("movement_speed_pct") * (1 - self:GetParent():GetStatusResistance()) * (-1) * 100)

	self:OnIntervalThink()
	self:StartIntervalThink(1)
end

function modifier_imba_poison_sting_debuff:OnRefresh(params)
	self.damage             = self.damage + self:GetAbility():GetSpecialValueFor("stack_damage")
	self.hp_regen_reduction = self:GetAbility():GetSpecialValueFor("hp_regen_reduction") * (-1)

	if not IsServer() then return end

	self:OnIntervalThink()
end

function modifier_imba_poison_sting_debuff:OnIntervalThink()
	ApplyDamage({
		victim       = self:GetParent(),
		damage       = self.damage,
		damage_type  = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
		attacker     = self:GetCaster(),
		ability      = self:GetAbility()
	})

	SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
end

function modifier_imba_poison_sting_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,

		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_poison_sting_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() / 100
end

function modifier_imba_poison_sting_debuff:GetModifierHPRegenAmplify_Percentage()
	return self.hp_regen_reduction
end

function modifier_imba_poison_sting_debuff:OnTooltip()
	return self.damage
end

-------------------------------------------
modifier_imba_poison_sting_debuff_ward = class({})
function modifier_imba_poison_sting_debuff_ward:IsDebuff() return true end

function modifier_imba_poison_sting_debuff_ward:IsHidden() return false end

function modifier_imba_poison_sting_debuff_ward:IsStunDebuff() return false end

function modifier_imba_poison_sting_debuff_ward:RemoveOnDeath() return true end

-------------------------------------------

function modifier_imba_poison_sting_debuff_ward:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_imba_poison_sting_debuff_ward:OnCreated(params)
	local ability = self:GetAbility()
	self.damage = ability:GetSpecialValueFor("damage")
	self.movement_speed_pct = ability:GetSpecialValueFor("movement_speed_pct")
	self.stack_damage = ability:GetSpecialValueFor("stack_damage")
	self:StartIntervalThink(1)
	self:DamageTick(true)
end

function modifier_imba_poison_sting_debuff_ward:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_poison_sting_debuff_ward:DamageTick(bFirstHit)
	local damage
	if bFirstHit then
		damage = self.damage + self.stack_damage * self:GetStackCount()
	else
		damage = self.damage + self.stack_damage * (self:GetStackCount() - 1)
	end
	local parent = self:GetParent()
	if IsServer() then
		local final_damage = ApplyDamage({
			attacker     = self:GetCaster(),
			victim       = parent,
			ability      = self:GetAbility(),
			damage       = damage,
			damage_type  = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
		})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, final_damage, nil)
	end
end

function modifier_imba_poison_sting_debuff_ward:GetModifierMoveSpeedBonus_Percentage()
	return (self.movement_speed_pct + (self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_2") * self:GetStackCount())) * (-1)
end

function modifier_imba_poison_sting_debuff_ward:OnIntervalThink()
	self:DamageTick()
end

function modifier_imba_poison_sting_debuff_ward:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_imba_poison_sting_debuff_ward:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

----------------------------------------
-- MODIFIER_IMBA_POISON_STING_V2_WARD --
----------------------------------------

function modifier_imba_poison_sting_v2_ward:IgnoreTenacity() return true end

function modifier_imba_poison_sting_v2_ward:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_imba_poison_sting_v2_ward:OnCreated()
	self.damage             = self:GetAbility():GetSpecialValueFor("damage") * 0.5
	self.hp_regen_reduction = self:GetAbility():GetSpecialValueFor("hp_regen_reduction") * (-1)

	if not IsServer() then return end

	self:SetStackCount(self:GetAbility():GetTalentSpecialValueFor("movement_speed_pct") * (1 - self:GetParent():GetStatusResistance()) * (-1) * 100)

	self:OnIntervalThink()
	self:StartIntervalThink(1)
end

function modifier_imba_poison_sting_v2_ward:OnRefresh()
	self.damage             = self.damage + (self:GetAbility():GetSpecialValueFor("stack_damage") * 0.5)
	self.hp_regen_reduction = self:GetAbility():GetSpecialValueFor("hp_regen_reduction") * (-1)

	if not IsServer() then return end

	self:OnIntervalThink()
end

function modifier_imba_poison_sting_v2_ward:OnIntervalThink()
	if not self:GetParent():HasModifier("modifier_imba_poison_sting_debuff") then
		ApplyDamage({
			victim       = self:GetParent(),
			damage       = self.damage,
			damage_type  = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS,
			attacker     = self:GetCaster(),
			ability      = self:GetAbility()
		})

		SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
	end
end

function modifier_imba_poison_sting_v2_ward:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,

		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_poison_sting_v2_ward:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():HasModifier("modifier_imba_poison_sting_debuff") then
		return self:GetStackCount() / 100
	end
end

function modifier_imba_poison_sting_v2_ward:GetModifierHPRegenAmplify_Percentage()
	if not self:GetParent():HasModifier("modifier_imba_poison_sting_debuff") then
		return self.hp_regen_reduction
	end
end

function modifier_imba_poison_sting_v2_ward:OnTooltip()
	if not self:GetParent():HasModifier("modifier_imba_poison_sting_debuff") then
		return self.damage
	else
		return 0
	end
end

-------------------------------------------
--			  PLAGUE WARD
-------------------------------------------
LinkLuaModifier("modifier_imba_plague_ward", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

imba_venomancer_plague_ward = class({})
function imba_venomancer_plague_ward:IsHiddenWhenStolen() return false end

function imba_venomancer_plague_ward:IsRefreshable() return true end

function imba_venomancer_plague_ward:IsStealable() return true end

function imba_venomancer_plague_ward:IsNetherWardStealable() return false end

function imba_venomancer_plague_ward:GetAbilityTextureName()
	return "venomancer_plague_ward"
end

-------------------------------------------

function imba_venomancer_plague_ward:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end

		-- Parameters
		local duration = self:GetSpecialValueFor("duration")
		local scourge_hp = self:GetSpecialValueFor("scourge_hp")
		local scourge_damage = self:GetSpecialValueFor("scourge_damage")
		local scourge_gold = self:GetSpecialValueFor("scourge_gold")
		local scourge_xp = self:GetSpecialValueFor("scourge_xp")
		local plague_count = self:GetSpecialValueFor("plague_count")
		local plague_hp = self:GetSpecialValueFor("plague_hp")
		local plague_damage = self:GetSpecialValueFor("plague_damage")
		local plague_radius = self:GetSpecialValueFor("plague_radius")

		-- Talent #5 %-based additional ward-stats
		scourge_hp = scourge_hp + (scourge_hp * caster:FindTalentValue("special_bonus_imba_venomancer_5") / 100)
		scourge_damage = scourge_damage + (scourge_damage * caster:FindTalentValue("special_bonus_imba_venomancer_5") / 100)
		plague_hp = plague_hp + (plague_hp * caster:FindTalentValue("special_bonus_imba_venomancer_5") / 100)
		plague_damage = plague_damage + (plague_damage * caster:FindTalentValue("special_bonus_imba_venomancer_5") / 100)

		-- Create Scourge Ward and set values + cosmetics
		local scourge_ward = CreateUnitByName("npc_imba_venomancer_scourge_ward", target_loc, true, caster, caster, caster:GetTeamNumber())
		scourge_ward:EmitSound("Hero_Venomancer.Plague_Ward")
		local spawn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(spawn_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(spawn_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(spawn_fx)

		if (math.random(1, 100) <= 20) and (caster:GetName() == "npc_dota_hero_venomancer") then
			caster:EmitSound("venomancer_venm_ability_ward_0" .. math.random(1, 6))
		end

		local ability_gale = caster:FindAbilityByName("imba_venomancer_venomous_gale")
		if ability_gale then
			scourge_ward:AddRangeIndicator(caster, ability_gale, "ward_range", nil, 183, 247, 33, false, false, true)
		end

		scourge_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
		scourge_ward:SetForwardVector(direction)
		scourge_ward:AddNewModifier(caster, self, "modifier_kill", { duration = duration })
		scourge_ward:AddNewModifier(caster, self, "modifier_magic_immune", { duration = duration })
		scourge_ward:SetBaseMaxHealth(scourge_hp)
		scourge_ward:SetMaxHealth(scourge_hp)
		scourge_ward:SetHealth(scourge_hp)
		scourge_ward:SetDeathXP(scourge_xp)
		scourge_ward:SetMaximumGoldBounty(scourge_gold)
		scourge_ward:SetMinimumGoldBounty(scourge_gold)
		scourge_ward:SetBaseDamageMin(scourge_damage)
		scourge_ward:SetBaseDamageMax(scourge_damage)
		scourge_ward.bIsScourge = true

		if plague_count >= 1 then
			local start_angle = math.random() * 360
			local angle = 360 / plague_count
			local mod_ward = scourge_ward:AddNewModifier(caster, self, "modifier_imba_plague_ward", { duration = duration })
			mod_ward.ward_list = {}
			for i = 1, plague_count, 1 do
				local plague_loc = target_loc + RotateVector2D(direction, start_angle + (angle * i), true) * plague_radius
				local plague_ward = CreateUnitByName("npc_imba_venomancer_plague_ward", plague_loc, true, caster, caster, caster:GetTeamNumber())
				plague_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
				plague_ward:SetForwardVector(direction)
				local mod_kill = plague_ward:AddNewModifier(caster, self, "modifier_kill", { duration = duration })
				plague_ward:AddNewModifier(caster, self, "modifier_magic_immune", { duration = duration })

				-- causing lag!
				--				local link_fx = ParticleManager:CreateParticle("particles/hero/venomancer/ward_link.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				--				ParticleManager:SetParticleControlEnt(link_fx, 0, scourge_ward, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", scourge_ward:GetAbsOrigin(), true)
				--				ParticleManager:SetParticleControlEnt(link_fx, 1, plague_ward, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", plague_ward:GetAbsOrigin(), true)
				--				mod_kill:AddParticle(link_fx,false,false,-1,false,false)

				plague_ward:SetBaseMaxHealth(plague_hp)
				plague_ward:SetMaxHealth(plague_hp)
				plague_ward:SetHealth(plague_hp)
				plague_ward:SetBaseDamageMin(plague_damage)
				plague_ward:SetBaseDamageMax(plague_damage)
				table.insert(mod_ward.ward_list, plague_ward)
			end
		end
	end
end

-------------------------------------------
modifier_imba_plague_ward = class({})
function modifier_imba_plague_ward:IsDebuff() return false end

function modifier_imba_plague_ward:IsHidden() return false end

function modifier_imba_plague_ward:IsPurgable() return false end

function modifier_imba_plague_ward:IsPurgeException() return false end

function modifier_imba_plague_ward:IsStunDebuff() return false end

function modifier_imba_plague_ward:RemoveOnDeath() return true end

-------------------------------------------

function modifier_imba_plague_ward:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_imba_plague_ward:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_EVENT_ON_DEATH
	}
	return decFuns
end

function modifier_imba_plague_ward:CheckState()
	local state =
	{
		[MODIFIER_STATE_INVULNERABLE] = true
	}
	return state
end

function modifier_imba_plague_ward:OnDeath(params)
	if IsServer() then
		for i = 1, #self.ward_list do
			if params.unit == self.ward_list[i] then
				table.remove(self.ward_list, i)
			end
			if #self.ward_list == 0 then
				self:Destroy()
			end
		end
	end
end

------------------------------------
-- IMBA_VENOMANCER_PLAGUE_WARD_V2 --
------------------------------------

function imba_venomancer_plague_ward_v2:OnSpellStart(talent_spawn_location)
	local spawn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(spawn_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(spawn_fx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(spawn_fx)

	local plague_ward = CreateUnitByName("npc_dota_venomancer_plague_ward_" .. math.min(self:GetLevel(), 4), talent_spawn_location or self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	plague_ward:EmitSound("Hero_Venomancer.Plague_Ward")

	if self:GetCaster():HasAbility("imba_venomancer_venomous_gale") then
		plague_ward:AddRangeIndicator(self:GetCaster(), self:GetCaster():FindAbilityByName("imba_venomancer_venomous_gale"), "ward_range", nil, 183, 247, 33, false, false, true)
	end

	plague_ward:SetForwardVector(self:GetCaster():GetForwardVector())
	plague_ward:AddNewModifier(self:GetCaster(), self, "modifier_imba_venomancer_plague_ward_v2", {})
	plague_ward:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = self:GetSpecialValueFor("duration") })
	plague_ward:AddNewModifier(self:GetCaster(), self, "modifier_neutral_spell_immunity_visible", { duration = self:GetSpecialValueFor("duration") })

	plague_ward:SetBaseMaxHealth(self:GetSpecialValueFor("ward_hp_tooltip") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_plague_ward_upgrade"), 1))
	plague_ward:SetMaxHealth(self:GetSpecialValueFor("ward_hp_tooltip") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_plague_ward_upgrade"), 1))
	plague_ward:SetHealth(self:GetSpecialValueFor("ward_hp_tooltip") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_plague_ward_upgrade"), 1))

	plague_ward:SetBaseDamageMin((self:GetSpecialValueFor("ward_damage_tooltip") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_plague_ward_upgrade"), 1)) - 1)
	plague_ward:SetBaseDamageMax((self:GetSpecialValueFor("ward_damage_tooltip") * math.max(self:GetCaster():FindTalentValue("special_bonus_imba_venomancer_plague_ward_upgrade"), 1)) + 1)

	if self:GetCaster().GetPlayerID then
		plague_ward:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	elseif self:GetCaster():GetOwner() and self:GetCaster():GetOwner().GetPlayerID then
		plague_ward:SetControllableByPlayer(self:GetCaster():GetOwner():GetPlayerID(), true)
	end

	-- There was a better way to do this but I forgot where I implemented it
	if not talent_spawn_location and self:GetCaster():GetName() == "npc_dota_hero_venomancer" and RollPercentage(25) then
		if not self.responses then
			self.responses =
			{
				["venomancer_venm_ability_ward_01"] = 0,
				["venomancer_venm_ability_ward_02"] = 0,
				["venomancer_venm_ability_ward_03"] = 0,
				["venomancer_venm_ability_ward_04"] = 0,
				["venomancer_venm_ability_ward_05"] = 0,
				["venomancer_venm_ability_ward_06"] = 0
			}
		end

		for response, timer in pairs(self.responses) do
			if GameRules:GetDOTATime(true, true) - timer >= 60 then
				self:GetCaster():EmitSound(response)
				self.responses[response] = GameRules:GetDOTATime(true, true)
				break
			end
		end
	end
end

---------------------------------------------
-- MODIFIER_IMBA_VENOMANCER_PLAGUE_WARD_V2 --
---------------------------------------------

function modifier_imba_venomancer_plague_ward_v2:IsHidden() return true end

function modifier_imba_venomancer_plague_ward_v2:IsPurgable() return false end

function modifier_imba_venomancer_plague_ward_v2:RemoveOnDeath() return false end

function modifier_imba_venomancer_plague_ward_v2:OnCreated()
	self.split_count = self:GetAbility():GetSpecialValueFor("split_count")

	if not IsServer() then return end

	if self:GetParent():GetOwner() and self:GetParent():GetOwner() and self:GetParent():GetOwner():HasAbility("imba_venomancer_poison_sting") and self:GetParent():GetOwner():FindAbilityByName("imba_venomancer_poison_sting"):IsTrained() then
		self.poison_sting_ability = self:GetParent():GetOwner():FindAbilityByName("imba_venomancer_poison_sting")
	end
end

function modifier_imba_venomancer_plague_ward_v2:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_imba_venomancer_plague_ward_v2:OnAttack(keys)
	-- The "not keys.no_attack_cooldown" clause seems to make sure the function doesn't trigger on PerformAttacks with that false tag so this thing doesn't crash
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.no_attack_cooldown and not self:GetParent():PassivesDisabled() then
		local target_number = 0

		for _, enemy in pairs(FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.target then
				if target_number >= self.split_count then
					break
				else
					self:GetParent():PerformAttack(enemy, false, true, true, false, true, false, false)

					target_number = target_number + 1
				end
			end
		end
	end
end

function modifier_imba_venomancer_plague_ward_v2:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and keys.target and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not keys.target:IsMagicImmune() and not keys.target:IsBuilding() and not keys.target:IsOther() and not self:GetParent():PassivesDisabled() then
		if not self.poison_sting_ability then
			if self:GetParent():GetOwner() and self:GetParent():GetOwner():HasAbility("imba_venomancer_poison_sting") and self:GetParent():GetOwner():FindAbilityByName("imba_venomancer_poison_sting"):IsTrained() then
				self.poison_sting_ability = self:GetParent():GetOwner():FindAbilityByName("imba_venomancer_poison_sting")
			end
		end

		if self.poison_sting_ability and self:GetParent():GetOwner() and not self:GetParent():GetOwner():PassivesDisabled() then
			keys.target:AddNewModifier(self:GetParent():GetOwner(), self.poison_sting_ability, "modifier_imba_poison_sting_v2_ward", { duration = (self.poison_sting_ability:GetSpecialValueFor("duration") - FrameTime()) * (1 - keys.target:GetStatusResistance()) })
		end
	end
end

-------------------------------------------
--			   POISON NOVA
-------------------------------------------
LinkLuaModifier("modifier_imba_poison_nova_ring", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_poison_nova", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

imba_venomancer_poison_nova = class({})
function imba_venomancer_poison_nova:IsHiddenWhenStolen() return false end

function imba_venomancer_poison_nova:IsRefreshable() return true end

function imba_venomancer_poison_nova:IsStealable() return true end

function imba_venomancer_poison_nova:IsNetherWardStealable() return true end

function imba_venomancer_poison_nova:GetAbilityTextureName()
	return "venomancer_poison_nova"
end

-------------------------------------------

function imba_venomancer_poison_nova:GetCastRange(location, target)
	return self:GetTalentSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_venomancer_poison_nova:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local index = 0
		local radius = self:GetTalentSpecialValueFor("radius")
		local duration = self:GetTalentSpecialValueFor("duration")
		local main_damage
		if caster:HasScepter() then
			main_damage = self:GetSpecialValueFor("main_damage_scepter")
			index = DoUniqueString("index")
		else
			main_damage = self:GetSpecialValueFor("main_damage")
		end
		local damage_pct = self:GetSpecialValueFor("damage_pct") / 100
		local health_pct = self:GetSpecialValueFor("health_pct") / 100
		local health_threshold_pct = self:GetSpecialValueFor("health_threshold_pct") / 100
		local contagion_radius = self:GetSpecialValueFor("contagion_radius")
		local contagion_min_duration = self:GetSpecialValueFor("contagion_min_duration")

		-- Make caster briefly visible
		caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, 1.0)
		caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, 1.0)


		local line = math.random(1, 21)
		if line >= 10 then
			caster:EmitSound("venomancer_venm_ability_nova_" .. line)
		else
			caster:EmitSound("venomancer_venm_ability_nova_0" .. line)
		end

		caster:EmitSound("Hero_Venomancer.PoisonNova")

		local nova_caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(nova_caster_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(nova_caster_pfx)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_poison_nova_ring", { duration = ((self:GetTalentSpecialValueFor("radius") - self:GetSpecialValueFor("start_radius")) / self:GetSpecialValueFor("speed")) })

		-- local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		-- for _, enemy in pairs(enemies) do
		-- -- local poison = enemy:FindModifierByNameAndCaster("modifier_imba_poison_nova",caster)
		-- -- if poison and not caster:HasScepter() then
		-- -- -- Delete old poison and re-apply
		-- -- poison:Destroy()
		-- -- end
		-- enemy:AddNewModifier(caster, self, "modifier_imba_poison_nova", {
		-- duration = duration + 2*FrameTime(),
		-- main_damage = main_damage,
		-- damage_pct = damage_pct,
		-- health_pct = health_pct,
		-- health_threshold_pct = health_threshold_pct,
		-- contagion_radius = contagion_radius,
		-- contagion_min_duration = contagion_min_duration,
		-- index = index
		-- })
		-- end
	end
end

function imba_venomancer_poison_nova:GetCooldown(nLevel)
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
	return self.BaseClass.GetCooldown(self, nLevel)
end

------------------------------------
-- MODIFIER_IMBA_POISON_NOVA_RING --
------------------------------------

modifier_imba_poison_nova_ring = modifier_imba_poison_nova_ring or class({})

function modifier_imba_poison_nova_ring:IsHidden() return true end

function modifier_imba_poison_nova_ring:IsPurgable() return false end

function modifier_imba_poison_nova_ring:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_poison_nova_ring:OnCreated()
	if not IsServer() then return end

	self.radius                 = self:GetAbility():GetTalentSpecialValueFor("radius")
	self.start_radius           = self:GetAbility():GetSpecialValueFor("start_radius")
	self.speed                  = self:GetAbility():GetSpecialValueFor("speed")

	self.duration               = self:GetAbility():GetTalentSpecialValueFor("duration")
	self.main_damage            = self:GetAbility():GetSpecialValueFor("main_damage")
	self.index                  = 0
	self.damage_pct             = self:GetAbility():GetSpecialValueFor("damage_pct") / 100
	self.health_pct             = self:GetAbility():GetSpecialValueFor("health_pct") / 100
	self.health_threshold_pct   = self:GetAbility():GetSpecialValueFor("health_threshold_pct") / 100
	self.contagion_radius       = self:GetAbility():GetSpecialValueFor("contagion_radius")
	self.contagion_min_duration = self:GetAbility():GetSpecialValueFor("contagion_min_duration")

	if self:GetCaster():HasScepter() then
		self.main_damage = self:GetAbility():GetSpecialValueFor("main_damage_scepter")
		self.index = DoUniqueString("index")
	end

	self.cast_location = self:GetParent():GetAbsOrigin()

	self.hit_enemies = {}

	self.nova_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(self.nova_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.nova_particle, 1, Vector(self.radius, (self.radius - self.start_radius) / self.speed, self.speed))
	self:AddParticle(self.nova_particle, false, false, -1, false, false)

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_poison_nova_ring:OnIntervalThink()
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.cast_location, nil, math.min(self.start_radius + (self:GetElapsedTime() * self.speed), self.radius), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)) do
		if not self.hit_enemies[enemy:entindex()] then
			enemy:EmitSound("Hero_Venomancer.PoisonNovaImpact")

			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_poison_nova", {
				duration               = self.duration + 2 * FrameTime(),
				main_damage            = self.main_damage,
				damage_pct             = self.damage_pct,
				health_pct             = self.health_pct,
				health_threshold_pct   = self.health_threshold_pct,
				contagion_radius       = self.contagion_radius,
				contagion_min_duration = self.contagion_min_duration,
				index                  = self.index
			})

			self.hit_enemies[enemy:entindex()] = true
		end
	end
end

-------------------------------------------
modifier_imba_poison_nova = class({})
function modifier_imba_poison_nova:IsDebuff() return true end

function modifier_imba_poison_nova:IsHidden() return false end

function modifier_imba_poison_nova:IsPurgable() return false end

function modifier_imba_poison_nova:IsPurgeException() return false end

function modifier_imba_poison_nova:IsStunDebuff() return false end

function modifier_imba_poison_nova:RemoveOnDeath() return true end

function modifier_imba_poison_nova:IgnoreTenacity() return true end

-------------------------------------------

function modifier_imba_poison_nova:OnCreated(params)
	if IsServer() then
		self.main_damage = params.main_damage
		self.damage_pct = params.damage_pct
		self.health_pct = params.health_pct
		self.health_threshold_pct = params.health_threshold_pct
		self.contagion_radius = params.contagion_radius
		self.contagion_min_duration = params.contagion_min_duration
		self.index = params.index
		self:DealDamage(true)
		self:StartIntervalThink(1)
	end
end

function modifier_imba_poison_nova:DealDamage(bFirst)
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local current_health_pct = parent:GetHealth() / parent:GetMaxHealth()

	if not parent:IsMagicImmune() then
		-- Damage Calculation
		local damage = self.main_damage * (1 + ((math.max(0, current_health_pct - self.health_threshold_pct) / self.health_pct) * self.damage_pct))
		ApplyDamage({ victim = parent, attacker = caster, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL })
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, damage, nil)
	end

	-- Spread if it wasn't the impact-tick
	if not bFirst then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.contagion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if not (enemy == parent) then
				local bAlreadyAffected = false
				local nova_poison = enemy:FindAllModifiersByName("modifier_imba_poison_nova")
				for _, poison in pairs(nova_poison) do
					if poison.index == self.index then
						bAlreadyAffected = true
						break
					end
				end
				if not bAlreadyAffected then
					enemy:AddNewModifier(caster, self:GetAbility(), "modifier_imba_poison_nova", {
						duration = math.max(self:GetRemainingTime(), self.contagion_min_duration) + 2 * FrameTime(),
						main_damage = self.main_damage,
						damage_pct = self.damage_pct,
						health_pct = self.health_pct,
						health_threshold_pct = self.health_threshold_pct,
						contagion_radius = self.contagion_radius,
						contagion_min_duration = self.contagion_min_duration,
						index = self.index
					})
				end
			end
		end
	end
end

function modifier_imba_poison_nova:OnIntervalThink()
	if IsServer() then
		self:DealDamage(false)
	end
end

function modifier_imba_poison_nova:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_imba_poison_nova:StatusEffectPriority()
	return 10
end

function modifier_imba_poison_nova:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end

function modifier_imba_poison_nova:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-- function modifier_imba_poison_nova:GetAttributes()
-- return MODIFIER_ATTRIBUTE_MULTIPLE
-- end

-------------------------------------------

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_venomancer_4", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_6", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_plague_ward_upgrade", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_venomancer_4 = modifier_special_bonus_imba_venomancer_4 or class({})
modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards = modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards or class({})
modifier_special_bonus_imba_venomancer_6 = modifier_special_bonus_imba_venomancer_6 or class({})
modifier_special_bonus_imba_venomancer_plague_ward_upgrade = modifier_special_bonus_imba_venomancer_plague_ward_upgrade or class({})

function modifier_special_bonus_imba_venomancer_4:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_4:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_4:RemoveOnDeath() return false end

function modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_venomous_gale_plague_wards:RemoveOnDeath() return false end

function modifier_special_bonus_imba_venomancer_6:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_6:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_6:RemoveOnDeath() return false end

function modifier_special_bonus_imba_venomancer_plague_ward_upgrade:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_plague_ward_upgrade:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_plague_ward_upgrade:RemoveOnDeath() return false end

-- Client-side helper functions --
LinkLuaModifier("modifier_special_bonus_imba_venomancer_1", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_2", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_3", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_poison_sting_slow", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_venomancer_poison_nova_radius", "components/abilities/heroes/hero_venomancer", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_venomancer_1                  = class({})
modifier_special_bonus_imba_venomancer_2                  = class({})
modifier_special_bonus_imba_venomancer_3                  = class({})

modifier_special_bonus_imba_venomancer_poison_sting_slow  = modifier_special_bonus_imba_venomancer_poison_sting_slow or class({})
modifier_special_bonus_imba_venomancer_poison_nova_radius = modifier_special_bonus_imba_venomancer_poison_nova_radius or class({})

-- -----------------------
-- -- TALENT 1 MODIFIER --
-- -----------------------
-- +x% Venomous Gale Slow

function modifier_special_bonus_imba_venomancer_1:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_1:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_1:RemoveOnDeath() return false end

-- -----------------------
-- -- TALENT 2 MODIFIER --
-- -----------------------
-- Poison Sting now adds +x% slow per stack

function modifier_special_bonus_imba_venomancer_2:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_2:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_2:RemoveOnDeath() return false end

-- -----------------------
-- -- TALENT 3 MODIFIER --
-- -----------------------
-- +x% Compound Toxicity Magic Resistance Reduction

function modifier_special_bonus_imba_venomancer_3:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_3:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_venomancer_poison_sting_slow:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_poison_sting_slow:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_poison_sting_slow:RemoveOnDeath() return false end

function modifier_special_bonus_imba_venomancer_poison_nova_radius:IsHidden() return true end

function modifier_special_bonus_imba_venomancer_poison_nova_radius:IsPurgable() return false end

function modifier_special_bonus_imba_venomancer_poison_nova_radius:RemoveOnDeath() return false end

function imba_venomancer_venomous_gale:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_venomancer_1") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_venomancer_1") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_venomancer_1"), "modifier_special_bonus_imba_venomancer_1", {})
	end
end

function imba_venomancer_poison_sting:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_venomancer_2") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_venomancer_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_venomancer_2"), "modifier_special_bonus_imba_venomancer_2", {})
	end

	if self:GetCaster():HasTalent("special_bonus_imba_venomancer_poison_sting_slow") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_venomancer_poison_sting_slow") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_venomancer_poison_sting_slow"), "modifier_special_bonus_imba_venomancer_poison_sting_slow", {})
	end
end

function imba_venomancer_toxicity:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_venomancer_3") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_venomancer_3") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_venomancer_3"), "modifier_special_bonus_imba_venomancer_3", {})
	end
end

function imba_venomancer_poison_nova:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_venomancer_poison_nova_radius") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_venomancer_poison_nova_radius") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_venomancer_poison_nova_radius"), "modifier_special_bonus_imba_venomancer_poison_nova_radius", {})
	end
end
