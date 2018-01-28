-- Author: Cookies
-- 26/01/2018 // DD/MM/AAAA
-- Elder Dragon Form original author: SquawkyArctangent

---------------------------
--		BREATH FIRE  	 --
---------------------------

imba_dragon_knight_breathe_fire = class({})

LinkLuaModifier("modifier_imba_breathe_fire_debuff", "hero/hero_dragon_knight", LUA_MODIFIER_MOTION_NONE)

function imba_dragon_knight_breathe_fire:GetAbilityTextureName()
   return "dragon_knight_breathe_fire"
end

function imba_dragon_knight_breathe_fire:IsHiddenWhenStolen()
	return false
end

function imba_dragon_knight_breathe_fire:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local target_point = self:GetCursorPosition()
	local modifier_movement = "modifier_imba_breathe_fire_debuff"
	local sound_cast = "Hero_DragonKnight.BreathFire"
	local particle = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"

	-- Ability specials
	local speed = ability:GetSpecialValueFor("speed")
	local range = ability:GetSpecialValueFor("range")
	local start_radius = ability:GetSpecialValueFor("start_radius") 	
	local end_radius = ability:GetSpecialValueFor("end_radius") 	

	-- Play cast sound
	EmitSoundOn(sound_cast, caster) 	

	--#3 Talent: Casting gust allow Drow auto attacks, for 5 seconds, to cast mini gusts on the target to knock it 50 units away (no damage/silence)
	if caster:HasTalent("special_bonus_imba_drow_ranger_3") then
		local buff_duration = caster:FindTalentValue("special_bonus_imba_drow_ranger_3", "buff_duration")
		caster:AddNewModifier(caster, ability, "modifier_imba_gust_buff", { duration = buff_duration })
	end

	--#1 Talent: Gust can be selfcast on Drow Ranger, sendind a wave that will push her forward too, silencing any enemy it comes in contact to
	if caster == target and caster:HasTalent("special_bonus_imba_drow_ranger_1") then
		-- Start moving
		local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})

		-- Assign the ending point of gust, sent in the direction Drow has been facing, as the target location in the modifier
		if modifier_movement_handler then
			modifier_movement_handler.target_point = caster:GetAbsOrigin() + (caster:GetForwardVector() * range) 
		end
	end

	--if gust was self cast, set the target point of the gust at 900 units far in the direction drow was facing
	if caster == target then
		target_point = caster:GetAbsOrigin() + (caster:GetForwardVector() * range)
	end

	Timers:CreateTimer(FrameTime(), function()
		-- Send Gust!
		local gust_projectile = {	Ability = ability,
									EffectName = particle,
									vSpawnOrigin = caster:GetAbsOrigin(),
									fDistance = range,
									fStartRadius = start_radius,
									fEndRadius = end_radius,
									Source = caster,
									bHasFrontalCone = false,
									bReplaceExisting = false,
									iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,							
									iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,							
									bDeleteOnHit = false,
									vVelocity = (((target_point - caster:GetAbsOrigin()) * Vector(1, 1, 0)):Normalized()) * speed,
									bProvidesVision = false,							
								}

		ProjectileManager:CreateLinearProjectile(gust_projectile)
	end)
 end 

function imba_dragon_knight_breathe_fire:OnProjectileHit(target, location)
	if IsServer() then
		-- Ability properties

		-- Ability specials 	
		local debuff_duration = self:GetSpecialValueFor("duration")
		local damage = self:GetSpecialValueFor("damage")

		-- if no target was found, do nothing
		if not target then
			return nil
		end

		-- Deal damage
		local damageTable = {
			victim = target,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			attacker = self:GetCaster(),
			ability = self
		}

		ApplyDamage(damageTable)	

		-- Apply silence
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_breathe_fire_debuff", {duration = debuff_duration})
	end
end

modifier_imba_breathe_fire_debuff = class({})

function modifier_imba_breathe_fire_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
--		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
--		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
--		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_imba_breathe_fire_debuff:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		local attack_damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())
		local damage_reduction = damage_reduction = self:GetAbility():GetSpecialValueFor("reduction") / 100 * attack_damage
		print(attack_damage, damage_reduction, attack_damage - damage_reduction)
		return attack_damage - damage_reduction
	end
end

function modifier_imba_breathe_fire_debuff:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire_trail.vpcf"
end

function modifier_imba_breathe_fire_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end	
function modifier_imba_breathe_fire_debuff:IsHidden() return false end
function modifier_imba_breathe_fire_debuff:IsPurgable() return true end
function modifier_imba_breathe_fire_debuff:IsDebuff() return true end

imba_dragon_knight_dragon_tail = class({})

function imba_dragon_knight_dragon_tail:GetCastRange()
self.cast_range = 150

	if self:GetCaster() and self:GetCaster().HasModifier and self:GetCaster():HasModifier("modifier_elder_dragon_form_lua") then
		self.cast_range = self:GetSpecialValueFor("dragon_cast_range")
	end

	return self.cast_range
end

function imba_dragon_knight_dragon_tail:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()

		if target and not target:IsMagicImmune() and not target:IsInvulnerable() then
			target:EmitSound("Hero_DragonKnight.DragonTail.Target")
			ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_dragon_tail.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})

			ApplyDamage({
				attacker = self:GetCaster(),
				victim = target,
				damage_type = self:GetAbilityDamageType(),
				damage = self:GetAbilityDamage(),
				ability = self
			})
		end
	end
end
