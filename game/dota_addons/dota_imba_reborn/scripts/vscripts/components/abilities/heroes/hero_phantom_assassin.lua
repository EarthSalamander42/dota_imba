-- Editors:
--		15.04.2017 - sercankd 
--		01.06.2018 - zimberzimber
--		18.08.2018 - EarthSalamander #42

-------------------------------------------
-- Stifling Dagger
-------------------------------------------

imba_phantom_assassin_stifling_dagger = class({})

LinkLuaModifier("modifier_imba_stifling_dagger_slow", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_silence", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_bonus_damage", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_stifling_dagger_dmg_reduction", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_stifling_dagger:GetAbilityTextureName()
	return "phantom_assassin_stifling_dagger"
end

function imba_phantom_assassin_stifling_dagger:OnSpellStart()

	local caster 	= self:GetCaster()
	local target 	= self:GetCursorTarget()
	local scepter 	= caster:HasScepter()

	--ability specials
	self.scepter_knives_interval 	=	0.3
	self.cast_range					=	self:GetCastRange() + GetCastRangeIncrease(caster)
	self.playbackrate				=	1 + self.scepter_knives_interval

	--TALENT: +35 Stifling Dagger bonus damage
	if caster:HasTalent("special_bonus_imba_phantom_assassin_1") then
		bonus_damage	=	self:GetSpecialValueFor("bonus_damage") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_1")
	else
		bonus_damage	=	self:GetSpecialValueFor("bonus_damage")
	end

	--coup de grace variables
	local ability_crit = caster:FindAbilityByName("modifier_imba_coup_de_grace")
	local ps_coup_modifier = "modifier_imba_phantom_strike_coup_de_grace"

	StartSoundEvent("Hero_PhantomAssassin.Dagger.Cast", caster)

	local extra_data = {main_dagger = true}

	self:LaunchDagger(target, extra_data)

	-- Secondary knives
	if scepter or caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
		local secondary_knives_thrown = 0

		-- TALENT: +1 Stifling Dagger bonus dagger (like aghs)
		if not scepter and caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
			scepter_dagger_count = self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_3")
			secondary_knives_thrown = scepter_dagger_count
		elseif scepter and caster:HasTalent("special_bonus_imba_phantom_assassin_3") then
			scepter_dagger_count = self:GetSpecialValueFor("scepter_dagger_count") + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_3")
		else
			scepter_dagger_count = self:GetSpecialValueFor("scepter_dagger_count")
		end

		-- Prepare extra_data
		extra_data = {main_dagger = false}

		-- Clear marks from all enemies
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			caster:GetAbsOrigin(),
			nil,
			self.cast_range,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_UNITS_EVERYWHERE,
			false
		)

		for _, enemy in pairs (enemies) do
			enemy.hit_by_pa_dagger = false
		end

		-- Mark the main target, set variables
		target.hit_by_pa_dagger = true
		local dagger_target_found

		-- Look for a secondary target to throw a knife at
		Timers:CreateTimer(self.scepter_knives_interval, function()
			-- Set variable for clear action
			dagger_target_found = false

			-- Look for a target in the cast range of the spell
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
				caster:GetAbsOrigin(),
				nil,
				self.cast_range,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_ANY_ORDER,
				false)

			-- Check if there's an enemy unit without a mark. Mark it and throw a dagger to it
			for _, enemy in pairs (enemies) do
				if not enemy.hit_by_pa_dagger then
					enemy.hit_by_pa_dagger = true
					dagger_target_found = true

					caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, self.playbackrate)

					self:LaunchDagger(enemy, extra_data)
					break -- only hit the first enemy found
				end
			end

			-- If all enemies were found with a mark, clear all marks from everyone
			if not dagger_target_found then
				for _, enemy in pairs (enemies) do
					enemy.hit_by_pa_dagger = false
				end

				-- Throw dagger at a random enemy
				local enemy = enemies[RandomInt(1, #enemies)]

				self:LaunchDagger(enemy, extra_data)
			end

			-- Check if there are knives remaining
			secondary_knives_thrown = secondary_knives_thrown + 1
			if secondary_knives_thrown < scepter_dagger_count then
				return self.scepter_knives_interval
			else
				return nil
			end
		end)
	end
end

function imba_phantom_assassin_stifling_dagger:LaunchDagger(enemy)
	if enemy == nil then return end

	local dagger_projectile = {
		EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		Dodgeable = true,
		Ability = self,
		ProvidesVision = true,
		VisionRadius = 600,
		bVisibleToEnemies = true,
		iMoveSpeed = self:GetSpecialValueFor("dagger_speed"),
		Source = self:GetCaster(),
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		Target = enemy,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		bReplaceExisting = false,
		ExtraData = extra_data
	}

	ProjectileManager:CreateTrackingProjectile(dagger_projectile)
end

function imba_phantom_assassin_stifling_dagger:OnProjectileHit( target, location )

	local caster = self:GetCaster()

	if not target then
		return false
	end

	-- With 20 percentage play random stifling dagger response
	local responses = {"phantom_assassin_phass_ability_stiflingdagger_01","phantom_assassin_phass_ability_stiflingdagger_02","phantom_assassin_phass_ability_stiflingdagger_03","phantom_assassin_phass_ability_stiflingdagger_04"}
	caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 20, DOTA_CAST_SOUND_FLAG_NONE, 20,"stifling_dagger")

	-- If the target possesses a ready Linken's Sphere, do nothing else
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		if target:TriggerSpellAbsorb(self) then
			return false
		end
	end

	-- Apply slow and silence modifiers
	if not target:IsMagicImmune() then
		target:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_silence", {duration = self:GetSpecialValueFor("silence_duration")})
		target:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_slow", {duration = self:GetSpecialValueFor("slow_duration")})
	end

	caster:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_dmg_reduction", {})
	caster:AddNewModifier(caster, self, "modifier_imba_stifling_dagger_bonus_damage", {})

	-- fix to not decrement phantom strike attacks on dagger hit
	if caster:HasModifier("modifier_imba_phantom_strike_coup_de_grace") then
		caster:SetModifierStackCount("modifier_imba_phantom_strike_coup_de_grace", caster, caster:GetModifierStackCount("modifier_imba_phantom_strike_coup_de_grace", caster) + 1)
	end

	-- Attack (calculates on-hit procs)
	local initial_pos = caster:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()

	-- Offset is necessary, because cleave from Battlefury doesn't work (in any direction) if you are exactly on top of the target unit
	local offset = 100 --dotameters (default melee range is 150 dotameters)

	-- Find the distance vector (distance, but as a vector rather than Length2D)
	-- z is 0 to prevent any wonkiness due to height differences, we'll use the targets height, unmodified
	local distance_vector = Vector(target_pos.x - initial_pos.x, target_pos.y - initial_pos.y, 0)
	-- Normalize it, so the offset can be applied to x/y components, proportionally
	distance_vector = distance_vector:Normalized()

	-- Offset the caster 100 units in front of the target
	target_pos.x = target_pos.x - offset * distance_vector.x
	target_pos.y = target_pos.y - offset * distance_vector.y

	caster:SetAbsOrigin(target_pos)
	caster:PerformAttack(target, true, true, true, true, true, false, true)
	caster:SetAbsOrigin(initial_pos)

	caster:RemoveModifierByName( "modifier_imba_stifling_dagger_bonus_damage" )
	caster:RemoveModifierByName( "modifier_imba_stifling_dagger_dmg_reduction" )
	return true
end

function imba_phantom_assassin_stifling_dagger:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end
-------------------------------------------
-- Stifling Dagger slow modifier
-------------------------------------------

modifier_imba_stifling_dagger_slow = class({})

function modifier_imba_stifling_dagger_slow:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local dagger_vision = self:GetAbility():GetSpecialValueFor("dagger_vision")
		local duration = self:GetAbility():GetSpecialValueFor("slow_duration")
		local stifling_dagger_modifier_slow_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
		ParticleManager:ReleaseParticleIndex(stifling_dagger_modifier_slow_particle)

		-- Add vision for the duration
		AddFOWViewer(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), dagger_vision, duration, false)
	end
end

function modifier_imba_stifling_dagger_slow:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_STATE_PROVIDES_VISION }
	return funcs
end

function modifier_imba_stifling_dagger_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("move_slow");
end

function modifier_imba_stifling_dagger_slow:GetModifierProvidesFOWVision()	return true end

function modifier_imba_stifling_dagger_slow:IsDebuff()		return true end

function modifier_imba_stifling_dagger_slow:IsPurgable()	return true end

-------------------------------------------
-- Stifling Dagger silence modifier
-------------------------------------------

modifier_imba_stifling_dagger_silence = class({})

function modifier_imba_stifling_dagger_silence:OnCreated()
	self.stifling_dagger_modifier_silence_particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target)
	ParticleManager:ReleaseParticleIndex(self.stifling_dagger_modifier_silence_particle)
end

function modifier_imba_stifling_dagger_silence:CheckState()
	local states = { [MODIFIER_STATE_SILENCED] = true, }
	return states
end

function modifier_imba_stifling_dagger_silence:IsDebuff() 	return true end

function modifier_imba_stifling_dagger_silence:IsPurgable()	return true end

function modifier_imba_stifling_dagger_silence:IsHidden()		return true end

-------------------------------------------
-- Stifling Dagger bonus damage modifier
-------------------------------------------

modifier_imba_stifling_dagger_bonus_damage = class({})

function modifier_imba_stifling_dagger_bonus_damage:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
	return funcs
end

function modifier_imba_stifling_dagger_bonus_damage:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_imba_stifling_dagger_bonus_damage:IsBuff()			return true end

function modifier_imba_stifling_dagger_bonus_damage:IsPurgable() 	return false end

function modifier_imba_stifling_dagger_bonus_damage:IsHidden() 	  return true end

-------------------------------------------
-- Stifling Dagger damage reduction modifier
-------------------------------------------

modifier_imba_stifling_dagger_dmg_reduction = class({})

function modifier_imba_stifling_dagger_dmg_reduction:OnCreated()
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_imba_stifling_dagger_dmg_reduction:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE}
	return decFunc
end

function modifier_imba_stifling_dagger_dmg_reduction:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction * (-1)
end


----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Phantom Strike
-------------------------------------------

imba_phantom_assassin_phantom_strike = class({})

function imba_phantom_assassin_phantom_strike:GetAbilityTextureName()
	return "phantom_assassin_phantom_strike"
end

LinkLuaModifier("modifier_imba_phantom_strike", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_phantom_strike_coup_de_grace", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
function imba_phantom_assassin_phantom_strike:IsNetherWardStealable() return false end
function imba_phantom_assassin_phantom_strike:CastFilterResultTarget(target)
	if IsServer() then
		local caster = self:GetCaster()
		local casterID = caster:GetPlayerOwnerID()
		local targetID = target:GetPlayerOwnerID()

		-- Can't cast on self (self blink!)
		if target == caster then
			return UF_FAIL_CUSTOM
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_phantom_assassin_phantom_strike:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_cast_on_self"
end

function imba_phantom_assassin_phantom_strike:OnSpellStart()
	if IsServer() then
		self.caster 	= self:GetCaster()
		self.target 	= self:GetCursorTarget()

		--ability specials
		self.bonus_attack_speed =	self:GetSpecialValueFor("bonus_attack_speed")
		self.buff_duration 		=	self:GetSpecialValueFor("buff_duration")
		self.projectile_speed 	=	self:GetSpecialValueFor("projectile_speed")
		self.projectile_width 	=	self:GetSpecialValueFor("projectile_width")
		self.attacks 			= 	self:GetSpecialValueFor("attacks")

		--TALENT: +30 Phantom Strike bonus attack speed
		if self.caster:HasTalent("special_bonus_imba_phantom_assassin_2") then
			self.bonus_attack_speed	=	self:GetSpecialValueFor("bonus_attack_speed") + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_2")
		else
			self.bonus_attack_speed =	self:GetSpecialValueFor("bonus_attack_speed")
		end

		-- Trajectory calculations
		self.caster_pos = self.target:GetAbsOrigin()
		self.target_pos = self.target:GetAbsOrigin()
		self.direction	= ( self.target_pos - self.caster_pos ):Normalized()
		self.distance = ( self.target_pos - self.caster_pos ):Length2D()

		-- If the target possesses a ready Linken's Sphere, do nothing else
		if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
			if self.target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		self.blink_projectile = {
			Ability				= self,
			vSpawnOrigin		= self.caster_pos,
			fDistance			= self.distance,
			fStartRadius		= self.projectile_width,
			fEndRadius			= self.projectile_width,
			Source				= self.caster,
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			bDeleteOnHit		= false,
			vVelocity			= Vector(self.direction.x, self.direction.y, 0) * self.projectile_speed,
			bProvidesVision		= false,
		}

		ProjectileManager:CreateLinearProjectile(self.blink_projectile)
		StartSoundEvent("Hero_PhantomAssassin.Strike.Start", self:GetCaster())

		-- Blink
		local distance = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D()
		local direction = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
		local blink_point = self.caster:GetAbsOrigin() + direction * (distance - 128)
		self.caster:SetAbsOrigin(blink_point)
		Timers:CreateTimer(FrameTime(), function()
			FindClearSpaceForUnit(self.caster, blink_point, true)
		end)

		self.caster:SetForwardVector(direction)

		-- Disjoint projectiles
		ProjectileManager:ProjectileDodge(self.caster)

		-- Fire blink particle
		self.blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:ReleaseParticleIndex(self.blink_pfx)

		-- Fire blink end sound
		self.target:EmitSound("Hero_PhantomAssassin.Strike.End")

		-- Apply coup de grace modifier on caster it was an enemy
		if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then

			-- Apply blink strike modifier on caster
			self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike", { duration= self.buff_duration })

			-- Apply crit modifier
			self.caster:AddNewModifier(self.caster, self, "modifier_imba_phantom_strike_coup_de_grace", { duration= self.buff_duration })

			--Increased Coup de Grace chance for the next 4 attacks
			--TALENT
			if self.caster:HasTalent("special_bonus_imba_phantom_assassin_6") then
				attacks_count = self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_6") + 4
			else
				attacks_count = self.attacks
			end

			self.caster:SetModifierStackCount( "modifier_imba_phantom_strike_coup_de_grace", self.caster, attacks_count)

			-- If cast on an enemy, immediately start attacking it
			self.caster:MoveToTargetToAttack(self.target)
		end
	end
end

-------------------------------------------
-- Phantom Strike modifier
-------------------------------------------

modifier_imba_phantom_strike = class({})

function modifier_imba_phantom_strike:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
	return funcs
end

function modifier_imba_phantom_strike:GetModifierAttackSpeedBonus_Constant()
	local caster = self:GetCaster()
	self.speed_bonus = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	return self.speed_bonus
end

function modifier_imba_phantom_strike:IsBuff()		  return true end

function modifier_imba_phantom_strike:IsPurgable()  return true end

-------------------------------------------
-- Phantom Strike coup de grace modifier
-------------------------------------------

modifier_imba_phantom_strike_coup_de_grace = class({})

function modifier_imba_phantom_strike_coup_de_grace:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED }
	return funcs
end

function modifier_imba_phantom_strike_coup_de_grace:OnAttackLanded(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local owner = self:GetParent()
		local modifier_speed = "modifier_imba_phantom_strike"
		local stackcount = self:GetStackCount()

		-- If attack was not performed by the modifier's owner, do nothing
		if owner ~= keys.attacker then
			return
		end

		if stackcount == 1 then
			self:Destroy()
			if caster:HasModifier(modifier_speed) then
				caster:RemoveModifierByName(modifier_speed)
			end
		else
			self:DecrementStackCount()
		end
	end
end

function modifier_imba_phantom_strike_coup_de_grace:IsBuff()			return true end

function modifier_imba_phantom_strike_coup_de_grace:IsPurgable()	return true end

----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Blur
-------------------------------------------

imba_phantom_assassin_blur = class({})

LinkLuaModifier("modifier_imba_blur", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blur_blur", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE) --wat
LinkLuaModifier("modifier_imba_blur_speed", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blur_smoke", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_VERTICAL)

function imba_phantom_assassin_blur:GetAbilityTextureName()
	return "phantom_assassin_blur"
end

function imba_phantom_assassin_blur:GetIntrinsicModifierName()
	return "modifier_imba_blur"
end

function imba_phantom_assassin_blur:OnSpellStart()
	if IsServer() then
		ProjectileManager:ProjectileDodge(self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_blur_smoke", { duration = self:GetSpecialValueFor("duration")})
	end
end

-------------------------------------------
-- Blur modifier
-------------------------------------------

modifier_imba_blur = class({})

function modifier_imba_blur:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.modifier_aura = "modifier_imba_blur_blur"
		self.modifier_speed = "modifier_imba_blur_speed"

		-- Ability specials
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
		self.ms_duration = self:GetAbility():GetSpecialValueFor("speed_bonus_duration")

		-- Start thinking
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_blur:OnRefresh()
	self:OnCreated()
end

function modifier_imba_blur:OnIntervalThink()
	if IsServer() then

		-- Find nearby enemies
		local nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

		-- If there is at least one, apply the blur modifier
		if #nearby_enemies > 0 and self.caster:HasModifier(self.modifier_aura) then
			self.caster:RemoveModifierByName(self.modifier_aura)

			-- Else, if there are no enemies, remove the modifier
		elseif #nearby_enemies == 0 and not self.caster:HasModifier(self.modifier_aura) then
			self.caster:AddNewModifier(self.caster, self:GetAbility(), self.modifier_aura, {})

			local responses = {"phantom_assassin_phass_ability_blur_01",
				"phantom_assassin_phass_ability_blur_02",
				"phantom_assassin_phass_ability_blur_03"
			}
			self.caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 10, DOTA_CAST_SOUND_FLAG_NONE, 50,"blur")
		end
	end
end

function modifier_imba_blur:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_imba_blur:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_imba_blur:GetModifierIncomingDamage_Percentage()

	--TALENT: Blur now grants +30% chance to evade any damage
	if RollPercentage(self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_8")) then
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_EVADE, self.caster, 0, nil)
		return -100
	end

	return nil
end

function modifier_imba_blur:OnAttackFail(keys)
	if IsServer() then
		if keys.target == self:GetParent() then
			
			-- If the caster doesn't have the evasion speed modifier yet, give it to him
			if not self.caster:HasModifier(self.modifier_speed) then
				self.caster:AddNewModifier(self.caster, self:GetAbility(), self.modifier_speed, {duration = self.ms_duration})
			end

			-- Increment a stack and refresh
			local modifier_speed_handler = self.caster:FindModifierByName(self.modifier_speed)
			if modifier_speed_handler then
				modifier_speed_handler:IncrementStackCount()
				modifier_speed_handler:ForceRefresh()
			end
		end
	end
end

function modifier_imba_blur:IsHidden() return true end
function modifier_imba_blur:IsBuff() return true end
function modifier_imba_blur:IsPurgable() return false end


-- Evasion speed buff modifier
modifier_imba_blur_speed = class({})

function modifier_imba_blur_speed:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- Ability specials
	self.speed_bonus_duration = self:GetAbility():GetSpecialValueFor("speed_bonus_duration")
	self.blur_ms = self:GetAbility():GetSpecialValueFor("blur_ms")

	if IsServer() then

		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_blur_speed:OnIntervalThink()
	if IsServer() then

		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.speed_bonus_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_blur_speed:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_blur_speed:IsHidden() return false end
function modifier_imba_blur_speed:IsPurgable() return true end
function modifier_imba_blur_speed:IsDebuff() return false end

function modifier_imba_blur_speed:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}

	return decFunc
end

function modifier_imba_blur_speed:GetModifierMoveSpeedBonus_Constant()
	return self.blur_ms * self:GetStackCount()
end



-------------------------------------------
-- Blur blur modifier
-------------------------------------------

modifier_imba_blur_blur = class({})

function modifier_imba_blur_blur:OnCreated()
	self.blur_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
end

function modifier_imba_blur_blur:GetStatusEffectName()
	return "particles/hero/phantom_assassin/blur_status_fx.vpcf"
end

function modifier_imba_blur_blur:StatusEffectPriority()  return 11 end

function modifier_imba_blur_blur:CheckState()
	local states = { [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true, }
	return states
end

function modifier_imba_blur_blur:OnRemoved()
	ParticleManager:DestroyParticle(self.blur_particle, false)
end

function modifier_imba_blur_blur:OnDestroy()
	ParticleManager:ReleaseParticleIndex(self.blur_particle)
end

function modifier_imba_blur_blur:IsHidden() return true end
function modifier_imba_blur_blur:IsDebuff() return false end
function modifier_imba_blur_blur:IsPurgable() return false end

-------------------------------------------
-- Blur invuln modifier
-------------------------------------------

modifier_imba_blur_smoke = class({})
function modifier_imba_blur_smoke:IsHidden()	return false end
function modifier_imba_blur_smoke:IsDebuff()	return false end
function modifier_imba_blur_smoke:IsPurgable() return false end

function modifier_imba_blur_smoke:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_imba_blur_smoke:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_active_blur.vpcf"
end

function modifier_imba_blur_smoke:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_blur_smoke:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
	}
end

function modifier_imba_blur_smoke:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_imba_blur_smoke:GetModifierInvisibilityLevel()
	return 1
end

function modifier_imba_blur_smoke:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Hero_PhantomAssassin.Blur")
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_blur_smoke:OnIntervalThink()
	if self.linger == true then return end

	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("vanish_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	if #enemies > 0 then
		self.linger = true
		self:StartIntervalThink(-1)
		Timers:CreateTimer(self:GetAbility():GetSpecialValueFor("fade_duration"), function()
			self:Destroy()
		end)
	end
end

function modifier_imba_blur_smoke:OnRemoved()
	if IsServer() then
		self:GetParent():EmitSound("Hero_PhantomAssassin.Blur.Break")
	end
end

----------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------
-- Coup De Grace
-------------------------------------------

imba_phantom_assassin_coup_de_grace = class({})

LinkLuaModifier("modifier_imba_coup_de_grace", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_coup_de_grace_crit", "components/abilities/heroes/hero_phantom_assassin", LUA_MODIFIER_MOTION_NONE)

function imba_phantom_assassin_coup_de_grace:GetIntrinsicModifierName()
	return "modifier_imba_coup_de_grace"
end

function imba_phantom_assassin_coup_de_grace:GetAbilityTextureName()
	return "phantom_assassin_coup_de_grace"
end

-------------------------------------------
-- Coup De Grace modifier
-------------------------------------------

modifier_imba_coup_de_grace = class({})

function modifier_imba_coup_de_grace:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	if self.caster:IsIllusion() then return end
	self.parent = self:GetParent()
	self.ps_coup_modifier = "modifier_imba_phantom_strike_coup_de_grace"
	self.modifier_stacks = "modifier_imba_coup_de_grace_crit"

	-- Ability specials
	self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
	self.crit_increase_duration = self:GetAbility():GetSpecialValueFor("crit_increase_duration")
	self.crit_bonus = self:GetAbility():GetSpecialValueFor("crit_bonus")
end

function modifier_imba_coup_de_grace:OnRefresh()
	self:OnCreated()
end

function modifier_imba_coup_de_grace:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED}
	return funcs
end

function modifier_imba_coup_de_grace:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		local target = keys.target							-- TALENT: +8 sec Coup de Grace bonus damage duration
		local crit_duration = self.crit_increase_duration + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_7")
		local crit_chance_total = self.crit_chance

		-- Ignore crit for buildings
		if target:IsBuilding() then
			return end

		-- if we have phantom strike modifier, apply bonus percentage to our crit_chance
		if self.caster:HasModifier(self.ps_coup_modifier) then
			local ps_coup_modifier_handler = self.caster:FindModifierByName(self.ps_coup_modifier)
			if ps_coup_modifier_handler then
				local bonus_coup_de_grace_chance = ps_coup_modifier_handler:GetAbility():GetSpecialValueFor("bonus_coup_de_grace")

				-- TALENT: +5% Phantom Strike bonus crit chance
				bonus_coup_de_grace_chance = bonus_coup_de_grace_chance + self:GetCaster():FindTalentValue("special_bonus_imba_phantom_assassin_4")

				-- Calculate total crit chance
				local crit_chance_total = crit_chance_total + bonus_coup_de_grace_chance
			end
		end

		if RollPseudoRandom(crit_chance_total, self) then
			StartSoundEvent("Hero_PhantomAssassin.CoupDeGrace", target)
			local responses = {"phantom_assassin_phass_ability_coupdegrace_01",
				"phantom_assassin_phass_ability_coupdegrace_02",
				"phantom_assassin_phass_ability_coupdegrace_03",
				"phantom_assassin_phass_ability_coupdegrace_04"
			}
			self.caster:EmitCasterSound("npc_dota_hero_phantom_assassin",responses, 50, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, 20,"coup_de_grace")

			-- If the caster doesn't have the stacks modifier, give it to him
			if not self.caster:HasModifier(self.modifier_stacks) then
				self.caster:AddNewModifier(self.caster, self:GetAbility(), self.modifier_stacks, {duration = crit_duration})
			end

			-- Find the modifier, increase a stack and refresh it
			local modifier_stacks_handler = self.caster:FindModifierByName(self.modifier_stacks)
			if modifier_stacks_handler then
				modifier_stacks_handler:IncrementStackCount()
				modifier_stacks_handler:ForceRefresh()
			end

			-- TALENT: +100% Coup de Grace crit damage
			local crit_bonus = self.crit_bonus + self.caster:FindTalentValue("special_bonus_imba_phantom_assassin_5")

			-- Mark the attack as a critical in order to play the bloody effect on attack landed
			self.crit_strike = true
			return crit_bonus
		else
			-- If this attack wasn't a critical strike, remove possible markers from it.
			self.crit_strike = false
		end

		return nil
	end
end

function modifier_imba_coup_de_grace:OnAttackLanded(keys)
	if IsServer() then
		local target = keys.target
		local attacker = keys.attacker
		local fatality = self:GetAbility():GetSpecialValueFor("fatality_chance")
		if IsInToolsMode() then fatality = 25 end

		-- Only apply if the attacker is the caster and it was a critical strike
		if self:GetCaster() == attacker then
			-- Prevent Fatality on buildings
			if target:IsBuilding() or target:IsRoshan() then return end

			-- Roll for fatality
			if RandomInt(1, 100) <= fatality then
				if target:GetHealthPercent() >= self:GetAbility():GetSpecialValueFor("fatality_threshold") then
					target:EmitSound("Hero_Pangolier.TailThump.Shield")
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, 999999, nil)
					return
				end

				TrueKill(self.caster, target, self:GetAbility())
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, 999999, nil)

				-- Global effect when killing a real hero
				if target:IsRealHero() then
					-- Play screen blood particle
					local blood_pfx = ParticleManager:CreateParticle("particles/hero/phantom_assassin/screen_blood_splatter.vpcf", PATTACH_EYES_FOLLOW, target)

					-- Play fatality message
					Notifications:BottomToAll({text = "FATALITY!", duration = 4.0, style = {["font-size"] = "50px", color = "Red"} })

					-- Play global sounds
					self:GetCaster():EmitSound("Hero_PhantomAssassin.CoupDeGrace")
					self:GetCaster():EmitSound("Imba.PhantomAssassinFatality")
					return nil
				end
			end

			if self.crit_strike then
				-- If that attack was marked as a critical strike, apply the particles
				local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, attacker)
				ParticleManager:SetParticleControlEnt(coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(coup_pfx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(coup_pfx)
			end
		end
	end
end

function modifier_imba_coup_de_grace:IsPassive() return true end

function modifier_imba_coup_de_grace:IsHidden()
	local stacks = self:GetStackCount()
	if stacks > 0 then
		return false
	end

	return true
end


modifier_imba_coup_de_grace_crit = class({})

function modifier_imba_coup_de_grace_crit:OnCreated(params)
	-- Ability properties
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- Ability specials
	self.crit_increase_duration = params.duration
	self.crit_increase_damage = self:GetAbility():GetSpecialValueFor("crit_increase_damage")

	if IsServer() then
		-- Initialize table
		self.stacks_table = {}

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_coup_de_grace_crit:OnIntervalThink()
	if IsServer() then
		-- Check if there are any stacks left on the table
		if #self.stacks_table > 0 then

			-- For each stack, check if it is past its expiration time. If it is, remove it from the table
			for i = #self.stacks_table, 1, -1 do
				if self.stacks_table[i] + self.crit_increase_duration < GameRules:GetGameTime() then
					table.remove(self.stacks_table, i)
				end
			end

			-- If after removing the stacks, the table is empty, remove the modifier.
			if #self.stacks_table == 0 then
				self:Destroy()

				-- Otherwise, set its stack count
			else
				self:SetStackCount(#self.stacks_table)
			end

			-- Recalculate bonus based on new stack count
			self:GetParent():CalculateStatBonus()

			-- If there are no stacks on the table, just remove the modifier.
		else
			self:Destroy()
		end
	end
end

function modifier_imba_coup_de_grace_crit:OnRefresh()
	if IsServer() then
		-- Insert new stack values
		table.insert(self.stacks_table, GameRules:GetGameTime())
	end
end

function modifier_imba_coup_de_grace_crit:IsHidden() return false end
function modifier_imba_coup_de_grace_crit:IsPurgable() return true end
function modifier_imba_coup_de_grace_crit:IsDebuff() return false end


function modifier_imba_coup_de_grace_crit:DeclareFunctions()
	local decFunc = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return decFunc
end

function modifier_imba_coup_de_grace_crit:GetModifierPreAttack_BonusDamage()
	return self.crit_increase_damage * self:GetStackCount()
end
