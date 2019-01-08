-- Editors:
--     Firetoad
--     Hewdraw
--     AtroCty, 10.09.2017

-------------------------------------------
--			DELIGHTFUL TORMENT
-------------------------------------------
LinkLuaModifier("modifier_imba_delightful_torment_thinker", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_delightful_torment_as_bonus", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)

imba_queenofpain_delightful_torment = class({})
function imba_queenofpain_delightful_torment:IsHiddenWhenStolen() return false end
function imba_queenofpain_delightful_torment:IsRefreshable() return false end
function imba_queenofpain_delightful_torment:IsStealable() return false end
function imba_queenofpain_delightful_torment:IsNetherWardStealable() return false end
function imba_queenofpain_delightful_torment:IsInnateAbility() return true end

function imba_queenofpain_delightful_torment:GetAbilityTextureName()
	return "custom/queenofpain_delightful_torment"
end
-------------------------------------------

function imba_queenofpain_delightful_torment:GetIntrinsicModifierName()
	return "modifier_imba_delightful_torment_thinker"
end

-------------------------------------------
modifier_imba_delightful_torment_thinker = class({})
function modifier_imba_delightful_torment_thinker:IsDebuff() return false end
function modifier_imba_delightful_torment_thinker:IsHidden() return true end
function modifier_imba_delightful_torment_thinker:IsPurgable() return false end
function modifier_imba_delightful_torment_thinker:IsPurgeException() return false end
function modifier_imba_delightful_torment_thinker:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_delightful_torment_thinker:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_imba_delightful_torment_thinker:OnTakeDamage( params )
	local parent = self:GetParent()
	if params.attacker == parent then
		if params.unit:IsRealHero() and not parent:PassivesDisabled() then
			-- Parameters
			local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cooldown_reduction")

			-- If a hero was damaged, reduce all ability cooldowns
			for i = 0, 15 do
				local current_ability = parent:GetAbilityByIndex(i)
				if current_ability then
					local cooldown_remaining = current_ability:GetCooldownTimeRemaining()
					current_ability:EndCooldown()
					if cooldown_remaining > cooldown_reduction then
						current_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
					end
				end
			end

			-- Talent #4 handling
			if parent:HasTalent("special_bonus_imba_queenofpain_4") then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_delightful_torment_as_bonus", {duration = parent:FindTalentValue("special_bonus_imba_queenofpain_4", "duration")})
			end
		end
	end
end

-- Talent #4 handling
-------------------------------------------
modifier_imba_delightful_torment_as_bonus = class({})
function modifier_imba_delightful_torment_as_bonus:IsDebuff() return false end
function modifier_imba_delightful_torment_as_bonus:IsHidden() return true end
function modifier_imba_delightful_torment_as_bonus:IsPurgable() return false end
function modifier_imba_delightful_torment_as_bonus:IsPurgeException() return false end
function modifier_imba_delightful_torment_as_bonus:IsStunDebuff() return false end
function modifier_imba_delightful_torment_as_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-------------------------------------------

function modifier_imba_delightful_torment_as_bonus:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return decFuns
end

function modifier_imba_delightful_torment_as_bonus:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return 10
	end
end

-------------------------------------------
--			  SHADOW STRIKE
-------------------------------------------
LinkLuaModifier("modifier_imba_shadow_strike_debuff", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)

imba_queenofpain_shadow_strike = class({})
function imba_queenofpain_shadow_strike:IsHiddenWhenStolen() return false end
function imba_queenofpain_shadow_strike:IsRefreshable() return true end
function imba_queenofpain_shadow_strike:IsStealable() return true end
function imba_queenofpain_shadow_strike:IsNetherWardStealable() return true end

function imba_queenofpain_shadow_strike:GetAbilityTextureName()
	return "queenofpain_shadow_strike"
end
-------------------------------------------

function imba_queenofpain_shadow_strike:OnSpellStart( params )
	if IsServer() then
		local caster = self:GetCaster()
		local target
		if params then
			target = params
		else
			target = self:GetCursorTarget()
			caster:EmitSound("Hero_QueenOfPain.ShadowStrike")
			if (math.random(1,100) <= 15) and (caster:GetName() == "npc_dota_hero_queenofpain") then
				caster:EmitSound("queenofpain_pain_ability_shadowstrike_0"..math.random(1,4))
			end
		end

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local sec_damage_total = self:GetSpecialValueFor("sec_damage_total")
		local damage_interval = self:GetSpecialValueFor("damage_interval")
		local duration = self:GetSpecialValueFor("duration")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")

		-- Play caster particle
		local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster_pfx, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(caster_pfx, 3, Vector(projectile_speed, 0, 0))
		ParticleManager:ReleaseParticleIndex(caster_pfx)

		local projectile =
			{
				Target 				= target,
				Source 				= caster,
				Ability 			= self,
				EffectName 			= "particles/units/heroes/hero_queenofpain/queen_shadow_strike.vpcf",
				iMoveSpeed			= projectile_speed,
				vSourceLoc 			= caster:GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 20,
				bProvidesVision 	= false,
				--	iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				--	iVisionRadius 		= 400,
				--	iVisionTeamNumber 	= caster:GetTeamNumber()
				ExtraData			= {init_damage = damage, sec_damage_total = sec_damage_total, damage_interval = damage_interval, duration = duration}
			}
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function imba_queenofpain_shadow_strike:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
			local caster = self:GetCaster()
			local damage_per_interval = ExtraData.sec_damage_total / (ExtraData.duration / ExtraData.damage_interval)
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.init_damage, damage_type = self:GetAbilityDamageType()})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, ExtraData.init_damage, nil)
			target:AddNewModifier(caster, self, "modifier_imba_shadow_strike_debuff", {duration = ExtraData.duration, damage_per_interval = damage_per_interval, damage_interval = ExtraData.damage_interval})
		end
	end
end
-------------------------------------------
modifier_imba_shadow_strike_debuff = class({})
function modifier_imba_shadow_strike_debuff:IsDebuff() return true end
function modifier_imba_shadow_strike_debuff:IsHidden() return false end
function modifier_imba_shadow_strike_debuff:IsPurgable() return true end
function modifier_imba_shadow_strike_debuff:IsPurgeException() return false end
function modifier_imba_shadow_strike_debuff:IsStunDebuff() return false end
-------------------------------------------
function modifier_imba_shadow_strike_debuff:OnCreated( params )
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local slow_decay_pct = ability:GetSpecialValueFor("slow_decay_pct")
	self.slow = ability:GetSpecialValueFor("init_move_slow_pct")
	self.slow_decrease = self.slow * (slow_decay_pct / 100)

	if IsServer() then
		if not self.dagger_pfx then
			self.dagger_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
			for _, cp in pairs({ 0, 2, 3 }) do
				ParticleManager:SetParticleControlEnt(self.dagger_pfx, cp, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			end
			self:AddParticle(self.dagger_pfx, false, false, 0, true, false)
		end
		self.damage_interval = params.damage_interval / 0.5
		self.damage_per_interval = params.damage_per_interval
	end
	self.counter = 0
	-- WARNING: Only works like this if the intervals are made in 0.5 steps!
	self:StartIntervalThink(0.5)
end

function modifier_imba_shadow_strike_debuff:OnRefresh( params )
	self:OnCreated(params)
end

function modifier_imba_shadow_strike_debuff:OnIntervalThink()
	self.counter = self.counter + 1

	-- Slow handling
	if math.mod(self.counter,2) == 0 then
		if self.slow > self.slow_decrease then
			self.slow = self.slow - self.slow_decrease
		else
			self.slow = 0
		end
	end
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		-- Damage handling
		if math.mod(self.counter,self.damage_interval) == 0 then
			ApplyDamage({victim = parent, attacker = self:GetCaster(), ability = ability, damage = self.damage_per_interval, damage_type = ability:GetAbilityDamageType()})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, self.damage_per_interval, nil)

			-- Talent #6 handling
			local caster = self:GetCaster()
			if caster:HasAbility("imba_queenofpain_scream_of_pain") and caster:HasTalent("special_bonus_imba_queenofpain_6") and parent:IsHero() then
				local scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
				scream:OnSpellStart(caster:FindTalentValue("special_bonus_imba_queenofpain_6", "damage_pct"), parent, 1)
				if scream:GetLevel() >= 1 then
				end
			end
		end
	end
end

function modifier_imba_shadow_strike_debuff:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuncs
end

-- Talent #3 handling
function modifier_imba_shadow_strike_debuff:OnTakeDamage( keys )
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if caster:HasTalent("special_bonus_imba_queenofpain_3") and keys.attacker == caster and keys.unit == parent and caster:GetTeam() ~= parent:GetTeam() and keys.inflictor ~= ability then
			local damage = self.damage_per_interval
			if damage > 0 then
				ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = nil})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, parent, damage, nil)
			end
		end
	end
end

function modifier_imba_shadow_strike_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * (-1)
end

function modifier_imba_shadow_strike_debuff:GetModifierProvidesFOWVision()
	if self:GetCaster():HasTalent("special_bonus_imba_queenofpain_1") then
		return 1
	else
		return 0
	end
end

-------------------------------------------
--				BLINK
-------------------------------------------
LinkLuaModifier("modifier_imba_queenofpain_blink_decision_time", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)

imba_queenofpain_blink = class({})
function imba_queenofpain_blink:IsHiddenWhenStolen() return false end
function imba_queenofpain_blink:IsRefreshable() return true end
function imba_queenofpain_blink:IsStealable() return true end
function imba_queenofpain_blink:IsNetherWardStealable() return false end

function imba_queenofpain_blink:GetAbilityTextureName()
	return "queenofpain_blink"
end
-------------------------------------------

function imba_queenofpain_blink:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_pos = caster:GetAbsOrigin()
		local target_pos = self:GetCursorPosition()

		-- Parameters
		local blink_range = self:GetSpecialValueFor("blink_range") + GetCastRangeIncrease(caster)
		local scream_damage_pct = self:GetSpecialValueFor("scream_damage_pct")

		local distance = (target_pos - caster_pos)

		-- Range-check
		if distance:Length2D() > blink_range then
			target_pos = caster_pos + (distance:Normalized() * blink_range)
		end

		-- Disjointing everything
		ProjectileManager:ProjectileDodge(caster)

		--[[local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			local shadow_strike = caster:FindAbilityByName("imba_queenofpain_shadow_strike")
			shadow_strike:OnSpellStart(enemy)
		end--]]
		-- Particle & sound IN
		caster:EmitSound("Hero_QueenOfPain.Blink_in")
		local blink_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(blink_pfx, 0, caster_pos )
		ParticleManager:SetParticleControl(blink_pfx, 1, target_pos )
		ParticleManager:ReleaseParticleIndex(blink_pfx)

		-- Place hero
		FindClearSpaceForUnit(caster, target_pos, true)

		-- Particle & sound OUT
		caster:EmitSound("Hero_QueenOfPain.Blink_out")
		local blink_end_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(blink_end_pfx, 0, target_pos )
		ParticleManager:SetParticleControlForward(blink_end_pfx, 0, distance:Normalized())
		ParticleManager:ReleaseParticleIndex(blink_end_pfx)

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)

		-- Use Scream of Pain if avaible
		if caster:HasAbility("imba_queenofpain_scream_of_pain") then
			local scream = caster:FindAbilityByName("imba_queenofpain_scream_of_pain")
			if scream:GetLevel() >= 1 then
				scream:OnSpellStart(scream_damage_pct)
			end
		end

		-- Talent #5 handling
		if caster:HasTalent("special_bonus_imba_queenofpain_5") and not caster:HasModifier("modifier_imba_queenofpain_blink_decision_time") then
			self:EndCooldown()
			caster:AddNewModifier(caster, self, "modifier_imba_queenofpain_blink_decision_time", {duration = caster:FindTalentValue("special_bonus_imba_queenofpain_5")})
		end

	end
end

function imba_queenofpain_blink:GetManaCost()
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_imba_queenofpain_blink_decision_time") then
		return self:GetSpecialValueFor("mana_cost") * 2
	else
		return self:GetSpecialValueFor("mana_cost")
	end
end

-- Talent #5 handling
-------------------------------------------
modifier_imba_queenofpain_blink_decision_time = class({})
function modifier_imba_queenofpain_blink_decision_time:IsDebuff() return false end
function modifier_imba_queenofpain_blink_decision_time:IsHidden() return true end
function modifier_imba_queenofpain_blink_decision_time:IsPurgable() return false end
function modifier_imba_queenofpain_blink_decision_time:IsPurgeException() return false end
function modifier_imba_queenofpain_blink_decision_time:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_queenofpain_blink_decision_time:OnDestroy()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()) - self:GetCaster():FindTalentValue("special_bonus_imba_queenofpain_5"))
		end
	end
end


-------------------------------------------
--			SCREAM OF PAIN
-------------------------------------------
LinkLuaModifier("modifier_imba_scream_of_pain_reflect", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)
imba_queenofpain_scream_of_pain = class({})

function imba_queenofpain_scream_of_pain:GetAbilityTextureName()
	return "queenofpain_scream_of_pain"
end

function imba_queenofpain_scream_of_pain:IsHiddenWhenStolen() return false end
function imba_queenofpain_scream_of_pain:IsRefreshable() return true end
function imba_queenofpain_scream_of_pain:IsStealable() return true end
function imba_queenofpain_scream_of_pain:IsNetherWardStealable() return true end
-------------------------------------------
function imba_queenofpain_scream_of_pain:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

function imba_queenofpain_scream_of_pain:OnSpellStart(scream_damage_pct, source_unit, is_talent)
	if IsServer() then
		local caster = self:GetCaster()
		local scream_source
		if source_unit then
			scream_source = source_unit
			scream_source:EmitSound("Imba.QueenOfPainSecondaryScreamOfPain")
		else
			scream_source = caster
			scream_source:EmitSound("Hero_QueenOfPain.ScreamOfPain")
		end

		-- Prevent reclusive instances of Talent 6 & 8 overlapping with each other
		if not is_talent then
			is_talent = 0
		end

		local scream_loc = scream_source:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		if scream_damage_pct then
			damage = damage * (scream_damage_pct / 100)
		end
		local pain_duration = self:GetSpecialValueFor("pain_duration")
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local radius = self:GetSpecialValueFor("radius")
		local pain_reflect_pct = self:GetSpecialValueFor("pain_reflect_pct")

		local scream_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN, scream_source)
		ParticleManager:SetParticleControl(scream_pfx, 0, scream_loc )

		-- Get Targets & fire projectiles
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), scream_loc, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= scream_source then
				local projectile =
					{
						Target 				= enemy,
						Source 				= scream_source,
						Ability 			= self,
						EffectName 			= "particles/units/heroes/hero_queenofpain/queen_scream_of_pain.vpcf",
						iMoveSpeed			= projectile_speed,
						vSourceLoc 			= scream_loc,
						bDrawsOnMinimap 	= false,
						bDodgeable 			= true,
						bIsAttack 			= false,
						bVisibleToEnemies 	= true,
						bReplaceExisting 	= false,
						flExpireTime 		= GameRules:GetGameTime() + 20,
						bProvidesVision 	= false,
						iSourceAttachment 	= DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
						--	iVisionRadius 		= 400,
						--	iVisionTeamNumber 	= caster:GetTeamNumber()
						ExtraData			= {damage = damage, pain_duration = pain_duration, pain_reflect_pct = pain_reflect_pct, is_talent = is_talent}
					}
				ProjectileManager:CreateTrackingProjectile(projectile)
			end
		end
	end
end

function imba_queenofpain_scream_of_pain:OnProjectileHit_ExtraData(target, location, ExtraData)
	if IsServer() then
		if target then
			local caster = self:GetCaster()
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
			target:AddNewModifier(caster, self, "modifier_imba_scream_of_pain_reflect", {duration = ExtraData.pain_duration, pain_reflect_pct = ExtraData.pain_reflect_pct, damage_threshold = ExtraData.damage})
			if target:IsAlive() == false then
				if (math.random(1,100) <= 15) and (caster:GetName() == "npc_dota_hero_queenofpain") then
					caster:EmitSound("queenofpain_pain_ability_screamofpain_0"..math.random(1,4))
				end
			end

			-- Talent #7 handling
			if caster:HasTalent("special_bonus_imba_queenofpain_7") then
				target:AddNewModifier(caster, self, "modifier_imba_sonic_wave_daze", {stacks = caster:FindTalentValue("special_bonus_imba_queenofpain_7")})
			end

			-- Talent #8 handling
			if caster:HasTalent("special_bonus_imba_queenofpain_8") and caster:HasAbility("imba_queenofpain_shadow_strike") and ExtraData.is_talent == 0 then
				local shadow_strike_ability = caster:FindAbilityByName("imba_queenofpain_shadow_strike")
				if shadow_strike_ability:GetLevel() > 0 then
					local init_damage = shadow_strike_ability:GetSpecialValueFor("damage")
					local duration = shadow_strike_ability:GetSpecialValueFor("duration")
					local sec_damage_total = shadow_strike_ability:GetSpecialValueFor("sec_damage_total")
					local damage_interval = shadow_strike_ability:GetSpecialValueFor("damage_interval")
					local damage_over_time = sec_damage_total / math.floor(duration / damage_interval)
					ApplyDamage({victim = target, attacker = caster, ability = shadow_strike_ability, damage = init_damage, damage_type = DAMAGE_TYPE_MAGICAL})
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, init_damage, nil)
					target:AddNewModifier(caster, shadow_strike_ability, "modifier_imba_shadow_strike_debuff", {duration = duration, damage_per_interval = damage_over_time, damage_interval = damage_interval})
				end
			end
		end
	end
end

-------------------------------------------
modifier_imba_scream_of_pain_reflect = class({})
function modifier_imba_scream_of_pain_reflect:IsDebuff() return true end
function modifier_imba_scream_of_pain_reflect:IsHidden() return false end
function modifier_imba_scream_of_pain_reflect:IsPurgable() return true end
-------------------------------------------
function modifier_imba_scream_of_pain_reflect:OnCreated( params )
	if IsServer() then
		self.damage_threshold = params.damage_threshold
		self.pain_reflect_pct = params.pain_reflect_pct
		self.damage_counter = 0
	end
end

function modifier_imba_scream_of_pain_reflect:OnRefresh( params )
	if IsServer() then
		self:OnCreated(params)
	end
end


function modifier_imba_scream_of_pain_reflect:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_imba_scream_of_pain_reflect:OnTakeDamage( params )
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if params.attacker == parent then
			local damage = params.damage
			if (self.damage_counter + damage) > self.damage_threshold then
				damage = self.damage_threshold - self.damage_counter
				self:Destroy()
			else
				self.damage_counter = self.damage_counter + damage
			end
			ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS})
		end
	end
end

-------------------------------------------
--            SONIC WAVE
-------------------------------------------
LinkLuaModifier("modifier_imba_sonic_wave", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_sonic_wave_daze", "components/abilities/heroes/hero_queenofpain", LUA_MODIFIER_MOTION_NONE)

imba_queenofpain_sonic_wave = class({})

function imba_queenofpain_sonic_wave:GetAbilityTextureName()
	return "queenofpain_sonic_wave"
end

function imba_queenofpain_sonic_wave:IsHiddenWhenStolen() return false end
function imba_queenofpain_sonic_wave:IsRefreshable() return true end
function imba_queenofpain_sonic_wave:IsStealable() return true end
function imba_queenofpain_sonic_wave:IsNetherWardStealable() return true end
-------------------------------------------
function imba_queenofpain_sonic_wave:GetIntrinsicModifierName()
	return "modifier_imba_sonic_wave"
end

function imba_queenofpain_sonic_wave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local start_radius = self:GetSpecialValueFor("start_radius")
		local end_radius = self:GetSpecialValueFor("end_radius")
		local travel_distance = self:GetSpecialValueFor("travel_distance") + GetCastRangeIncrease(caster)
		local projectile_speed = self:GetSpecialValueFor("projectile_speed")
		local direction
		if target_loc == caster_loc then
			direction = caster:GetForwardVector()
		else
			direction = (target_loc - caster_loc):Normalized()
		end

		travel_distance = travel_distance + GetCastRangeIncrease(caster)

		-- Scepter-damage
		if caster:HasScepter() then
			damage = self:GetSpecialValueFor("damage_scepter")
		end

		caster:EmitSound("Hero_QueenOfPain.SonicWave")

		-- Talent #2 handling
		local projectiles = 1
		if caster:HasTalent("special_bonus_imba_queenofpain_2") then
			projectiles = caster:FindTalentValue("special_bonus_imba_queenofpain_2")
			damage = damage / projectiles
		end

		projectile =
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",
				vSpawnOrigin		= caster_loc,
				fDistance			= travel_distance,
				fStartRadius		= start_radius,
				fEndRadius			= end_radius,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= self:GetAbilityTargetTeam(),
				iUnitTargetFlags	= self:GetAbilityTargetFlags(),
				iUnitTargetType		= self:GetAbilityTargetType(),
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= true,
				vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
				bProvidesVision		= false,
				ExtraData			= {damage = damage}
			}

		ProjectileManager:CreateLinearProjectile(projectile)

		-- Talent #2 extra (invisible) projectiles
		if projectiles > 1 then
			projectile.EffectName = ""
			projectiles = projectiles -1
			Timers:CreateTimer(0.06, function()
				ProjectileManager:CreateLinearProjectile(projectile)
				projectiles = projectiles -1
				if projectiles > 0 then
					return 0.06
				end
			end)
		end
	end
end

function imba_queenofpain_sonic_wave:OnProjectileHit_ExtraData(target, location, ExtraData)
	local caster = self:GetCaster()
	if target then
		ApplyDamage({attacker = caster, victim = target, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		if caster:HasScepter() then
			target:AddNewModifier(caster, self, "modifier_imba_sonic_wave_daze", {stacks = self:GetSpecialValueFor("orders_scepter")})
		end
		if target:IsAlive() == false then
			if (math.random(1,100) <= 15) and (caster:GetName() == "npc_dota_hero_queenofpain") then
				caster:EmitSound("queenofpain_pain_ability_sonicwave_0"..math.random(1,4))
			end
		end

		-- Talent #8 handling
		if caster:HasTalent("special_bonus_imba_queenofpain_8") and caster:HasAbility("imba_queenofpain_shadow_strike") then
			local shadow_strike_ability = caster:FindAbilityByName("imba_queenofpain_shadow_strike")
			if shadow_strike_ability:GetLevel() > 0 then
				local init_damage = shadow_strike_ability:GetSpecialValueFor("damage")
				local duration = shadow_strike_ability:GetSpecialValueFor("duration")
				local sec_damage_total = shadow_strike_ability:GetSpecialValueFor("sec_damage_total")
				local damage_interval = shadow_strike_ability:GetSpecialValueFor("damage_interval")
				local damage_over_time = sec_damage_total / math.floor(duration / damage_interval)
				ApplyDamage({victim = target, attacker = caster, ability = shadow_strike_ability, damage = init_damage, damage_type = DAMAGE_TYPE_MAGICAL})
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, target, init_damage, nil)
				target:AddNewModifier(caster, shadow_strike_ability, "modifier_imba_shadow_strike_debuff", {duration = duration, damage_per_interval = damage_over_time, damage_interval = damage_interval})
			end
		end
	end
end

function imba_queenofpain_sonic_wave:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("cooldown_scepter") end
	return self.BaseClass.GetCooldown( self, nLevel )
end

-------------------------------------------
modifier_imba_sonic_wave = class({})
function modifier_imba_sonic_wave:IsDebuff() return false end
function modifier_imba_sonic_wave:IsHidden() return true end
function modifier_imba_sonic_wave:IsPurgable() return false end
function modifier_imba_sonic_wave:IsPurgeException() return false end
function modifier_imba_sonic_wave:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_sonic_wave:DeclareFunctions()
	local decFuns =
		{
			MODIFIER_EVENT_ON_TAKEDAMAGE
		}
	return decFuns
end

function modifier_imba_sonic_wave:OnTakeDamage( params )
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		if params.attacker == parent and params.inflictor then
			if params.inflictor == ability then
				local lifesteal_amount = ability:GetSpecialValueFor("absorb_pct")

				-- Particle effect
				local lifesteal_pfx = ParticleManager:CreateParticle("particles/hero/queenofpain/lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControl(lifesteal_pfx, 0, params.unit:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(lifesteal_pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(lifesteal_pfx, 2, params.unit:GetAbsOrigin())
				ParticleManager:SetParticleControl(lifesteal_pfx, 3, Vector((CalculateDistance(params.unit,parent)/100),0,0))
				ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

				local self_lifesteal_pfx = ParticleManager:CreateParticle("particles/hero/queenofpain/self_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
				ParticleManager:SetParticleControlEnt(self_lifesteal_pfx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

				-- If the target is a real hero, heal for the full value
				if params.unit:IsRealHero() then
					parent:Heal(params.damage * lifesteal_amount * 0.01, parent)

					-- else, heal for half of it
				else
					parent:Heal(params.damage * lifesteal_amount * 0.005, parent)
				end
			end
		end
	end
end

-------------------------------------------
modifier_imba_sonic_wave_daze = class({})
function modifier_imba_sonic_wave_daze:IsDebuff() return true end
function modifier_imba_sonic_wave_daze:IsHidden() return false end
function modifier_imba_sonic_wave_daze:IsPurgable() return true end
function modifier_imba_sonic_wave_daze:IsStunDebuff() return false end
-------------------------------------------

function modifier_imba_sonic_wave_daze:OnCreated( params )
	if IsServer() then
		self:SetStackCount(params.stacks)
	end
end

function modifier_imba_sonic_wave_daze:OnRefresh( params )
	if IsServer() then
		self:OnCreated(params)
	end
end

-------------------------------------------

function modifier_imba_sonic_wave_daze:GetEffectName()
	return "particles/hero/queenofpain/sonic_wave_daze.vpcf"
end

function modifier_imba_sonic_wave_daze:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
