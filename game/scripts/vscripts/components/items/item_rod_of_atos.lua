-- Creator:
-- 	AltiV - February 23rd, 2019

LinkLuaModifier("modifier_item_imba_rod_of_atos_debuff", "components/items/item_rod_of_atos.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_rod_of_atos", "components/items/item_rod_of_atos.lua", LUA_MODIFIER_MOTION_NONE)

item_imba_rod_of_atos                 = class({})
modifier_item_imba_rod_of_atos_debuff = class({})
modifier_item_imba_rod_of_atos        = class({})

item_imba_rod_of_atos_2               = item_imba_rod_of_atos

----------------------
-- ROD OF ATOS BASE --
----------------------

function item_imba_rod_of_atos:GetIntrinsicModifierName()
	return "modifier_item_imba_rod_of_atos"
end

function item_imba_rod_of_atos:GetAbilityTextureName()
	if self:GetLevel() == 2 then
		if self:GetCaster():GetModifierStackCount("modifier_item_imba_rod_of_atos", self:GetCaster()) == self:GetSpecialValueFor("curtain_fire_activation_charge") then
			return "imba_rod_of_atos_2_cfs"
		else
			return "imba_rod_of_atos_2"
		end
	else
		return "item_rod_of_atos"
	end
end

function item_imba_rod_of_atos:GetAOERadius()
	if self:GetLevel() >= 2 and self:GetCaster():GetModifierStackCount("modifier_item_imba_rod_of_atos", self:GetCaster()) == self:GetSpecialValueFor("curtain_fire_activation_charge") then
		return self:GetSpecialValueFor("curtain_fire_radius")
	else
		return 0
	end
end

function item_imba_rod_of_atos:OnSpellStart()
	self.caster                           = self:GetCaster()

	-- AbilitySpecials
	-- self.bonus_intellect	=	self:GetSpecialValueFor("bonus_intellect")
	-- self.bonus_strength		=	self:GetSpecialValueFor("bonus_strength")
	-- self.bonus_agility		=	self:GetSpecialValueFor("bonus_agility")
	self.duration                         = self:GetSpecialValueFor("duration")
	self.tooltip_range                    = self:GetSpecialValueFor("tooltip_range")
	self.projectile_speed                 = self:GetSpecialValueFor("projectile_speed")

	self.curtain_fire_radius              = self:GetSpecialValueFor("curtain_fire_radius")
	self.curtain_fire_length              = self:GetSpecialValueFor("curtain_fire_length")
	self.curtain_fire_shot_count          = self:GetSpecialValueFor("curtain_fire_shot_count")
	self.curtain_fire_shot_per_hero_count = self:GetSpecialValueFor("curtain_fire_shot_per_hero_count")
	self.curtain_fire_delay               = self:GetSpecialValueFor("curtain_fire_delay")
	self.curtain_fire_speed               = self:GetSpecialValueFor("curtain_fire_speed")
	self.curtain_fire_activation_charge   = self:GetSpecialValueFor("curtain_fire_activation_charge")

	self.curtain_fire_radius_second       = self:GetSpecialValueFor("curtain_fire_radius_second")
	self.curtain_fire_projectile_radius   = self:GetSpecialValueFor("curtain_fire_projectile_radius")

	if not IsServer() then return end

	local caster_location = self.caster:GetAbsOrigin()
	local target          = self:GetCursorTarget()
	local target_location = 0
	local direction       = 0

	-- Play the cast sound
	self.caster:EmitSound("DOTA_Item.RodOfAtos.Cast")

	-- Only the upgraded version with enough charges gets Curtain Fire Shooting (also no tempest doubles allowed cause anti-fun)
	if self:GetLevel() < 2 or self:GetCurrentCharges() < self.curtain_fire_activation_charge or self.caster:IsTempestDouble() then
		local projectile =
		{
			Target            = target,
			Source            = self.caster,
			Ability           = self,
			EffectName        = "particles/items2_fx/rod_of_atos_attack.vpcf",
			iMoveSpeed        = self.projectile_speed,
			vSourceLoc        = caster_location,
			bDrawsOnMinimap   = false,
			bDodgeable        = true,
			bIsAttack         = false,
			bVisibleToEnemies = true,
			bReplaceExisting  = false,
			flExpireTime      = GameRules:GetGameTime() + 20,
			bProvidesVision   = false,
		}

		ProjectileManager:CreateTrackingProjectile(projectile)

		-- Increment a charge towards Curtain Fire Shooting
		if self:GetLevel() >= 2 then
			self:SetCurrentCharges(math.min(self:GetCurrentCharges() + 1, self.curtain_fire_activation_charge))
			-- This is just for client-side showing AoE radius when it is ready
			local modifier = self.caster:FindModifierByName("modifier_item_imba_rod_of_atos")

			if modifier then
				modifier:SetStackCount(self:GetCurrentCharges())
			end
		end

		return
	end

	-- If the thing is casted (this is "legacy" code that allowed location cast but it was removed)
	if target then
		target_location = target:GetAbsOrigin()
	else
		target_location = self:GetCursorPosition()
	end

	-- Get the direction between the caster and the target
	direction     = (target_location - caster_location):Normalized()

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), target_location, nil, self.curtain_fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

	local counter = 0

	for _, enemy in pairs(enemies) do
		Timers:CreateTimer(counter * self.curtain_fire_delay, function()
			local projectile =
			{
				Target            = enemy,
				Source            = self.caster,
				Ability           = self,
				EffectName        = "particles/items2_fx/rod_of_atos_attack.vpcf",
				iMoveSpeed        = self.projectile_speed,
				vSourceLoc        = caster_location,
				bDrawsOnMinimap   = false,
				bDodgeable        = true,
				bIsAttack         = false,
				bVisibleToEnemies = true,
				bReplaceExisting  = false,
				flExpireTime      = GameRules:GetGameTime() + 20,
				bProvidesVision   = false,
				--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				--	iVisionRadius 		= 400,
				--	iVisionTeamNumber 	= self.caster:GetTeamNumber()
				-- ExtraData			= {caster = self.caster, duration = self.duration} -- IDK if this doesn't work with items or something
			}

			ProjectileManager:CreateTrackingProjectile(projectile)
		end)

		counter = counter + 1
	end

	local curtain_fire_starting_point = target_location - (direction * 1400)

	for shot = 0, self.curtain_fire_shot_count + (#enemies * self.curtain_fire_shot_per_hero_count) do
		Timers:CreateTimer(shot * self.curtain_fire_delay, function()
			local random_spawn_distance  = RandomInt(-self.curtain_fire_length, self.curtain_fire_length)

			local random_spawn_location  = curtain_fire_starting_point + Vector(direction.y * random_spawn_distance, -direction.x * random_spawn_distance, 100) -- 100 is so the projectiles don't all spawn sunk into the ground
			local random_target_location = GetGroundPosition(target_location + RandomVector(self.curtain_fire_radius_second * 0.5), nil)
			local random_fire_direction  = random_target_location - random_spawn_location

			-- So the console doesn't yell at us for non-zero vertical velocity
			random_fire_direction.z      = 0

			local linear_projectile      = {
				Ability          = self,
				EffectName       = "particles/items2_fx/rod_of_atos_attack_" .. string.lower(self.caster:GetTeamRealName()) .. ".vpcf", -- Borrowing pre-made projectile...
				vSpawnOrigin     = random_spawn_location,
				fDistance        = random_fire_direction:Length2D() + self.curtain_fire_radius_second,
				fStartRadius     = self.curtain_fire_projectile_radius,
				fEndRadius       = self.curtain_fire_projectile_radius,
				Source           = self.caster,
				bHasFrontalCone  = true,
				bReplaceExisting = false,
				iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime      = GameRules:GetGameTime() + 10.0,
				bDeleteOnHit     = true,
				vVelocity        = random_fire_direction:Normalized() * self.curtain_fire_speed,
				bProvidesVision  = false
			}

			ProjectileManager:CreateLinearProjectile(linear_projectile)
		end)
	end

	-- Reset charges to 0
	self:SetCurrentCharges(0)
	self.caster:FindModifierByName("modifier_item_imba_rod_of_atos"):SetStackCount(0)
end

function item_imba_rod_of_atos:OnProjectileHit(target, location)
	if not IsServer() then return end

	-- Check if a valid target has been hit
	if target and not target:IsMagicImmune() then
		-- This is where we get really jank...again. Try to differentiate between the targetted and the linear projectiles to apply different affects. More difficult on items cause apparently they don't get access to ExtraData.

		local contactDistance = (target:GetAbsOrigin() - location):Length2D()

		-- Arbitrary numerical value based on super rough testing (still might break on super high movement speeds)
		local targetted_projectile = (self:GetLevel() == 1 or contactDistance <= 65)

		-- Assumption: If contact distance is within hull radius, then it's the targetted projectile. Otherwise it's the linear
		-- Problem arises if people blink directly onto the projectile in which case it'd be treated like a targetted but eh.....
		if targetted_projectile then
			-- Check for Linken's / Lotus Orb
			if target:TriggerSpellAbsorb(self) then return nil end
		end

		-- Otherwise, play the sound...
		target:EmitSound("DOTA_Item.RodOfAtos.Target")

		-- IMBAfication: Ankle Breaker			
		ApplyDamage({
			victim       = target,
			damage       = target:GetIdealSpeed() * self:GetSpecialValueFor("ankle_breaker_damage_pct") / 100,
			damage_type  = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self.caster,
			ability      = self
		})

		if targetted_projectile then
			-- ...and apply the Cripple modifier.
			target:AddNewModifier(self.caster, self, "modifier_item_imba_rod_of_atos_debuff", { duration = self.duration * (1 - target:GetStatusResistance()) })
		end
	end
end

---------------------------------
-- ROD OF ATOS DEBUFF MODIFIER --
---------------------------------

function modifier_item_imba_rod_of_atos_debuff:GetEffectName()
	return "particles/items2_fx/rod_of_atos.vpcf"
end

function modifier_item_imba_rod_of_atos_debuff:CheckState(keys)
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end

--------------------------
-- ROD OF ATOS MODIFIER --
--------------------------

function modifier_item_imba_rod_of_atos:IsHidden() return true end

function modifier_item_imba_rod_of_atos:IsPurgable() return false end

function modifier_item_imba_rod_of_atos:RemoveOnDeath() return false end

function modifier_item_imba_rod_of_atos:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_rod_of_atos:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	if not IsServer() then return end

	-- Need to do this instead of using the "ItemInitialCharges" KV because the latter messes with sell prices
	if self:GetAbility() and self:GetAbility():GetLevel() >= 2 and not self:GetAbility().initialized then
		self:GetAbility():SetCurrentCharges(self:GetAbility():GetSpecialValueFor("initial_charges"))
		self:GetAbility().initialized = true
	end
end

function modifier_item_imba_rod_of_atos:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_intellect")
	end
end

function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end

function modifier_item_imba_rod_of_atos:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_agility")
	end
end
