-- Creator:
--	   AltiV, August 27th, 2019
-- Primary Idea Giver:
--     Kinkykids

LinkLuaModifier("modifier_imba_batrider_sticky_napalm_handler", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_batrider_sticky_napalm", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_batrider_flamebreak_damage", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_batrider_flamebreak_damage_thinker", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_batrider_firefly", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)
-- Having issues with just attaching the Firefly particles to Batrider himself (ember drops + particles going invis if caster is invis + particles no longer follow if Batrider dies), so I'm going to make a thinker and try to attach that instead
LinkLuaModifier("modifier_imba_batrider_firefly_thinker", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_batrider_flaming_lasso", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_batrider_flaming_lasso_self", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_generic_motion_controller", "components/modifiers/generic/modifier_generic_motion_controller", LUA_MODIFIER_MOTION_BOTH)

imba_batrider_sticky_napalm							= class({})
modifier_imba_batrider_sticky_napalm_handler		= class({})
modifier_imba_batrider_sticky_napalm				= class({})

imba_batrider_flamebreak							= class({})
modifier_imba_batrider_flamebreak_damage			= class({})
modifier_imba_batrider_flamebreak_damage_thinker	= class({})

imba_batrider_firefly								= class({})
modifier_imba_batrider_firefly						= class({})
modifier_imba_batrider_firefly_thinker				= class({})

imba_batrider_methane_boost							= class({})

imba_batrider_flaming_lasso							= class({})
modifier_imba_batrider_flaming_lasso				= class({})
modifier_imba_batrider_flaming_lasso_self			= class({})

---------------------------------
-- IMBA_BATRIDER_STICKY_NAPALM --
---------------------------------

function imba_batrider_sticky_napalm:GetIntrinsicModifierName()
	return "modifier_imba_batrider_sticky_napalm_handler"
end

function imba_batrider_sticky_napalm:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_batrider_sticky_napalm:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Batrider.StickyNapalm.Cast")
	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Batrider.StickyNapalm.Impact", self:GetCaster())
	
	self.napalm_impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(self.napalm_impact_particle, 0, self:GetCursorPosition())
	ParticleManager:SetParticleControl(self.napalm_impact_particle, 1, Vector(self:GetSpecialValueFor("radius"), 0, 0))
	ParticleManager:SetParticleControl(self.napalm_impact_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.napalm_impact_particle)
	self.napalm_impact_particle = nil
	
	self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetCursorPosition(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(self.enemies) do
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_sticky_napalm", {duration = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
	end
	
	-- "Provides 400 radius flying vision at the targeted point upon cast for 2 seconds."
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), 400, 2, false)
	
	self.napalm_impact_particle = nil
	self.enemies				= nil
end

--------------------------------------------------
-- MODIFIER_IMBA_BATRIDER_STICKY_NAPALM_HANDLER --
--------------------------------------------------

function modifier_imba_batrider_sticky_napalm_handler:IsHidden()	return true end

function modifier_imba_batrider_sticky_napalm_handler:OnIntervalThink()
	if not IsServer() then return end

	if self:GetAbility():GetAutoCastState() and self:GetAbility():IsFullyCastable() and not self:GetAbility():IsInAbilityPhase() and not self:GetCaster():IsHexed() and not self:GetCaster():IsNightmared() and not self:GetCaster():IsOutOfGame() and not self:GetCaster():IsSilenced() and not self:GetCaster():IsStunned() and not self:GetCaster():IsChanneling() then
		self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
		self:GetAbility():CastAbility()
	end
end

function modifier_imba_batrider_sticky_napalm_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER, MODIFIER_PROPERTY_IGNORE_CAST_ANGLE, MODIFIER_PROPERTY_DISABLE_TURNING}
	
	return decFuncs
end

function modifier_imba_batrider_sticky_napalm_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() then return end
	
	if keys.ability == self:GetAbility() then
		-- IMBAfication: Oil Slick
		if keys.order_type == DOTA_UNIT_ORDER_CAST_POSITION and (keys.new_pos - self:GetCaster():GetAbsOrigin()):Length2D() <= self:GetAbility():GetCastRange(self:GetCaster():GetCursorPosition(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus() then
			self.bActive = true
		else
			self.bActive = false
		end
		
		-- IMBAfication: Oil Leak
		if keys.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO then
			-- Due to logic order, this is actually reversed
			if self:GetAbility():GetAutoCastState() then
				self:SetStackCount(0)
				self:StartIntervalThink(-1)
			else
				self:StartIntervalThink(0.1)
				self:SetStackCount(1)
			end
		end
	else
		self.bActive = false
	end
end

function modifier_imba_batrider_sticky_napalm_handler:GetModifierIgnoreCastAngle()
	if not IsServer() or self.bActive == false then return end
	return 1
end

function modifier_imba_batrider_sticky_napalm_handler:GetModifierDisableTurning()
	if not IsServer() or self.bActive == false then return end
	return 1
end

------------------------------------------
-- MODIFIER_IMBA_BATRIDER_STICKY_NAPALM --
------------------------------------------

-- TODO: Get this particle to work?
function modifier_imba_batrider_sticky_napalm:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_napalm_damage_debuff.vpcf"
end

function modifier_imba_batrider_sticky_napalm:GetStatusEffectName()
	return "particles/status_fx/status_effect_stickynapalm.vpcf"
end

function modifier_imba_batrider_sticky_napalm:OnCreated()
	self.max_stacks			= self:GetAbility():GetSpecialValueFor("max_stacks")
	self.movement_speed_pct	= self:GetAbility():GetSpecialValueFor("movement_speed_pct")
	self.turn_rate_pct		= self:GetAbility():GetSpecialValueFor("turn_rate_pct")
	self.damage				= self:GetAbility():GetSpecialValueFor("damage")
	
	if not IsServer() then return end
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= nil,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	-- "Sticky Napalm triggers on any damage instance caused by Batrider, except from Orb of Venom, Radiance, Spirit Vessel, Urn of Shadows and damage with the no-reflection flag."
	-- Orb of Venom seems to already be taken care of innately so it doesn't have to be added to this list
	self.non_trigger_inflictors = {
		["imba_batrider_sticky_napalm"] = true,
		
		["item_imba_cloak_of_flames"]	= true,
		["item_imba_radiance"]			= true,
		
		["item_imba_urn_of_shadows"]	= true,
		["item_imba_spirit_vessel"]		= true,
	}
	
	self:SetStackCount(1)
	
	self.stack_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_batrider/batrider_stickynapalm_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
	ParticleManager:SetParticleControl(self.stack_particle, 1, Vector(math.floor(self:GetStackCount() / 10), self:GetStackCount() % 10, 0))
	self:AddParticle(self.stack_particle, false, false, -1, false, false)
end

function modifier_imba_batrider_sticky_napalm:OnRefresh()
	self.max_stacks			= self:GetAbility():GetSpecialValueFor("max_stacks")
	self.movement_speed_pct	= self:GetAbility():GetSpecialValueFor("movement_speed_pct")
	self.turn_rate_pct		= self:GetAbility():GetSpecialValueFor("turn_rate_pct")
	self.damage				= self:GetAbility():GetSpecialValueFor("damage")

	if not IsServer() then return end

	if self:GetStackCount() < self.max_stacks then
		self:IncrementStackCount()
	end
	
	if self.stack_particle then
		ParticleManager:SetParticleControl(self.stack_particle, 1, Vector(math.floor(self:GetStackCount() / 10), self:GetStackCount() % 10, 0))
	end
end

function modifier_imba_batrider_sticky_napalm:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, MODIFIER_EVENT_ON_TAKEDAMAGE}
end

function modifier_imba_batrider_sticky_napalm:GetModifierMoveSpeedBonus_Percentage()
	return math.min(self:GetStackCount(), self.max_stacks) * self.movement_speed_pct
end

function modifier_imba_batrider_sticky_napalm:GetModifierTurnRate_Percentage()
	return self.turn_rate_pct
end

function modifier_imba_batrider_sticky_napalm:OnTakeDamage(keys)
	if keys.attacker == self:GetCaster() and keys.unit == self:GetParent() and (not keys.inflictor or not self.non_trigger_inflictors[keys.inflictor:GetName()]) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
		self.damage_debuff_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_napalm_damage_debuff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.damage_debuff_particle)
		self.damage_debuff_particle = nil
		
		-- The wikis don't say anything about creep-heroes so I'll just assume they'll be treated as creeps
		if self:GetParent():IsHero() then
			self.damage_table.damage = self.damage * self:GetStackCount()
		else
			self.damage_table.damage = self.damage * 0.5 * self:GetStackCount()
		end
		
		ApplyDamage(self.damage_table)
	end
end

------------------------------
-- IMBA_BATRIDER_FLAMEBREAK --
------------------------------

function imba_batrider_flamebreak:GetAOERadius()
	return self:GetSpecialValueFor("explosion_radius")
end
			
function imba_batrider_flamebreak:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_imba_batrider_flamebreak_cooldown")
end

function imba_batrider_flamebreak:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	local flamebreak_dummy = CreateModifierThinker(self:GetCaster(), self, nil, {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	flamebreak_dummy:EmitSound("Hero_Batrider.Flamebreak")

	local flamebreak_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(flamebreak_particle, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 128)) -- Arbitrary verticality increase
	ParticleManager:SetParticleControl(flamebreak_particle, 1, Vector(self:GetSpecialValueFor("speed")))
	ParticleManager:SetParticleControl(flamebreak_particle, 5, self:GetCursorPosition())

	if not self.projectile_table then
		self.projectile_table = {
			Ability				= self,
			EffectName			= nil,
			vSpawnOrigin		= nil,
			fDistance			= nil,
			fStartRadius		= 0,
			fEndRadius			= 0,
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_NONE,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType		= DOTA_UNIT_TARGET_NONE,
			fExpireTime 		= nil,
			bDeleteOnHit		= false,
			vVelocity			= nil,
			bProvidesVision		= true,
			-- "The projectile has 175 radius flying vision. This vision does not last."
			iVisionRadius 		= 175,
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
			
			ExtraData			= nil
		}
	end
	
	self.projectile_table.vSpawnOrigin	= self:GetCaster():GetAbsOrigin()
	self.projectile_table.fDistance		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D()
	self.projectile_table.fExpireTime 	= GameRules:GetGameTime() + 10.0
	self.projectile_table.vVelocity		= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0)
	self.projectile_table.ExtraData		= 
	{
		flamebreak_dummy_entindex	= flamebreak_dummy:entindex(),
		flamebreak_particle			= flamebreak_particle
	}
	
	ProjectileManager:CreateLinearProjectile(self.projectile_table)
end

-- Make the travel sound follow the Molotov
function imba_batrider_flamebreak:OnProjectileThink_ExtraData(location, data)
	if data.flamebreak_dummy_entindex then
		EntIndexToHScript(data.flamebreak_dummy_entindex):SetAbsOrigin(location)
	end
end

function imba_batrider_flamebreak:OnProjectileHit_ExtraData(target, location, data)	
	EmitSoundOnLocationWithCaster(location, "Hero_Batrider.Flamebreak.Impact", self:GetCaster())
	
	if data.flamebreak_dummy_entindex then
		EntIndexToHScript(data.flamebreak_dummy_entindex):StopSound("Hero_Batrider.Flamebreak")
		EntIndexToHScript(data.flamebreak_dummy_entindex):RemoveSelf()
	end
	
	if data.flamebreak_particle then
		ParticleManager:DestroyParticle(data.flamebreak_particle, false)
		ParticleManager:ReleaseParticleIndex(data.flamebreak_particle)
	end
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("explosion_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	if not self.initial_damage_table then
		self.initial_damage_table	= {
			victim 			= nil,
			damage 			= self:GetSpecialValueFor("damage_impact"),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}
	end

	for _, enemy in pairs(enemies) do
		-- "Does not affect Roshan."
		if not enemy:IsRoshan() then
			self.initial_damage_table.victim = enemy
			ApplyDamage(self.initial_damage_table)
			
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
			{
				distance		= self:GetSpecialValueFor("knockback_distance"),
				direction_x 	= (enemy:GetAbsOrigin() - location):Normalized().x,
				direction_y 	= (enemy:GetAbsOrigin() - location):Normalized().y,
				direction_z 	= (enemy:GetAbsOrigin() - location):Normalized().z,
				duration 		= self:GetSpecialValueFor("knockback_duration"),
				height			= self:GetSpecialValueFor("knockback_height") * ((enemy:GetAbsOrigin() - location):Length2D() / self:GetSpecialValueFor("knockback_distance")),
				bGroundStop 	= false,
				bDecelerate 	= false,
				bInterruptible 	= false,
				bIgnoreTenacity	= true, -- IMBAfication: Potent Molotov
				bStun			= true, -- IMBAfication: Remnants of Flamebreak
				bTreeRadius		= nil,
				bDestroyTreesAlongPath = true
			})

			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_flamebreak_damage",
			{
				duration			= self:GetTalentSpecialValueFor("damage_duration") * (1 - enemy:GetStatusResistance()),
				damage_per_second	= self:GetSpecialValueFor("damage_per_second"),
				damage_type			= self:GetAbilityDamageType()
			})
		end
	end
end

-- particles/units/heroes/hero_warlock/warlock_upheaval.vpcf
-- I was gonna consider modifying this particle to have some sort of lingering flames from Flamebreak, but having that on a potential 4 second cooldown would be too broken and laggy
-- Also removing the talent to prevent lag is a bad idea especially since it's a Level 25 talent

----------------------------------------------
-- MODIFIER_IMBA_BATRIDER_FLAMEBREAK_DAMAGE --
----------------------------------------------

function modifier_imba_batrider_flamebreak_damage:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_batrider_flamebreak_damage:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_flamebreak_debuff.vpcf"
end

function modifier_imba_batrider_flamebreak_damage:OnCreated(params)
	if not IsServer() then return end
	
	self.damage_per_second	= params.damage_per_second
	self.damage_type		= params.damage_type
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= self.damage_per_second,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	self:StartIntervalThink(1)
end

function modifier_imba_batrider_flamebreak_damage:OnIntervalThink()
	ApplyDamage(self.damage_table)
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_per_second, nil)
		
	if self:GetParent():IsRealHero() and not self:GetParent():IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_batrider" and RollPercentage(50) then		
		self:GetCaster():EmitSound("batrider_bat_ability_firefly_0"..RandomInt(1, 6))
	end
end

---------------------------
-- IMBA_BATRIDER_FIREFLY --
---------------------------

function imba_batrider_firefly:GetAssociatedSecondaryAbilities()
	return "imba_batrider_methane_boost"
end

-- "When Batrider dies during Firefly, the already existing fire on the ground still stays for the remaining duration."
--   "The buffs remain visible in the HUD, and are now only responsible for keeping the already existing fire up."
--   "This means when respawning before they expire, they do not make Batrider fly again or make him leave fire behind again."

-- Okay, to somewhat explain what's going on in this block:
--   When Batrider dies, check for any existing Firefly modifiers
--   Because the modifier is only supposed to persist to keep lingering flames alive, if Batrider was using the Quiet Flight IMBAfication, there are no flames to preserve so we can safely destroy it
--   Otherwise, make the thinker that followed Batrider to produce the flames STOP following so it'll just continue producing on the spot where Batrider died
--   Then set the modifier stack count to -1, which has logic set to not do flight or create new damage spots in that scenario
--   Then, remove the ember_particle which dealt with flame drops and sparks around Batrider
--   (Also remove any true sight modifiers as a result of the talent)
--   Finally, if any firefly modifiers existed, destroy the firefly loop sound early
function imba_batrider_firefly:OnOwnerDied()
	local firefly_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_batrider_firefly")
	
	for _, mod in pairs(firefly_modifiers) do
		if not mod.firefly_thinker then
			mod:Destroy()
		else
			mod.firefly_thinker:FollowEntity(nil, false)
			mod:SetStackCount(-1)
			ParticleManager:DestroyParticle(mod.ember_particle, false)
			ParticleManager:ReleaseParticleIndex(mod.ember_particle)
		end
		
		if mod.truesight_modifier then
			mod.truesight_modifier:Destroy()
		end
	end
	
	if #firefly_modifiers >= 1 then
		self:GetCaster():StopSound("Hero_Batrider.Firefly.loop")
	end
end

function imba_batrider_firefly:OnUpgrade()
	if not self.methane_boost_ability or self.methane_boost_ability:IsNull() then
		self.methane_boost_ability = self:GetCaster():FindAbilityByName("imba_batrider_methane_boost")
	end
	
	if self.methane_boost_ability then
		if not self.methane_boost_ability:IsTrained() then
			self.methane_boost_ability:SetActivated(false)
			self.methane_boost_ability:SetLevel(1)
		end
	end
end

function imba_batrider_firefly:OnSpellStart()
	if not self.methane_boost_ability or self.methane_boost_ability:IsNull() then
		self.methane_boost_ability = self:GetCaster():FindAbilityByName("imba_batrider_methane_boost")
	end
		
	if self.methane_boost_ability then
		if not self.methane_boost_ability:IsTrained() then
			self.methane_boost_ability:SetLevel(1)
		end
		
		self.methane_boost_ability:SetActivated(true)
	end

	self:GetCaster():EmitSound("Hero_Batrider.Firefly.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_batrider" then
		if not self.responses then
			self.responses = {
				"batrider_bat_ability_firefly_01",
				"batrider_bat_ability_firefly_04",
				"batrider_bat_ability_firefly_07",
				"batrider_bat_ability_firefly_08",
				"batrider_bat_ability_firefly_09",
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_firefly", {duration = self:GetTalentSpecialValueFor("duration")})
end

------------------------------------
-- MODIFIER_IMBA_BATRIDER_FIREFLY --
------------------------------------

function modifier_imba_batrider_firefly:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_batrider_firefly:IsPurgable()	return false end
function modifier_imba_batrider_firefly:RemoveOnDeath()	return false end

function modifier_imba_batrider_firefly:OnCreated()
	self.movement_speed		= self:GetAbility():GetSpecialValueFor("movement_speed")
	self.bonus_vision		= self:GetAbility():GetSpecialValueFor("bonus_vision")
	self.quiet_flight_multi	= self:GetAbility():GetSpecialValueFor("quiet_flight_multi")
	
	if not IsServer() then return end
	
	self.damage_per_second	= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.tick_interval		= self:GetAbility():GetSpecialValueFor("tick_interval")
	self.tree_radius		= self:GetAbility():GetSpecialValueFor("tree_radius")
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self.damage_table		= {
		victim 			= nil,
		damage 			= self.damage_per_second * self.tick_interval,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	-- Use these to track where and which enemies to be damaged
	self.damage_spots		= {}
	self.damaged_enemies	= {}
	
	self.think_interval		= 0.1
	self.counter			= 0
	-- Keep IntervalThink at 0.1 seconds (for damage spot drops + tree destruction), but change time_to_tick based on when it should do damage
	self.time_to_tick		= 0.1

	self.firefly_debuff_particle	= nil
	
	if self:GetCaster():HasTalent("special_bonus_unique_imba_batrider_firefly_truesight") then
		self.truesight_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_gem_of_true_sight", {duration = self:GetRemainingTime()}) -- The radius was designated with the "radius" KV for the item in npc_items_custom.txt (guess that's just how it works)
	end
	
	if not self:GetAbility():GetAutoCastState() then
		self:GetParent():EmitSound("Hero_Batrider.Firefly.loop")
		
		self.ember_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.ember_particle, 11, Vector(1, 0, 0))
		self:AddParticle(self.ember_particle, false, false, -1, false, false)
		
		self.firefly_thinker = CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_imba_batrider_firefly_thinker", {duration = self:GetRemainingTime()}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		self:SetStackCount(1)
		
		self:StartIntervalThink(self.think_interval)
	end
end

-- IntervalThink only starts once self.firefly_thinker exists (which handles flame drops)
function modifier_imba_batrider_firefly:OnIntervalThink()
	self.counter	= self.counter + self.think_interval

	-- Stack count goes to -1 if Batrider dies, otherwise just do things normally
	if self:GetStackCount() >= 0 then
		table.insert(self.damage_spots, self:GetParent():GetAbsOrigin())
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.tree_radius, true)
	end

	if self.counter >= self.time_to_tick then
		for damage_spot = 1, #self.damage_spots do
			self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.damage_spots[damage_spot], nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(self.enemies) do
				if not self.damaged_enemies[enemy] then
					self.damage_table.victim = enemy
					
					self.firefly_debuff_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
					ParticleManager:ReleaseParticleIndex(self.firefly_debuff_particle)
					
					ApplyDamage(self.damage_table)
					self.damaged_enemies[enemy] = true
					
					if enemy:IsRealHero() and not enemy:IsAlive() and self:GetCaster():GetName() == "npc_dota_hero_batrider" and RollPercentage(50) then
						if not self.kill_responses then
							self.responses = {
								"batrider_bat_ability_firefly_02",
								"batrider_bat_ability_firefly_05",
								"batrider_bat_ability_firefly_06"
							}
						end
						
						self:GetCaster():EmitSound(self.kill_responses[RandomInt(1, #self.kill_responses)])
					end
				end
			end
		end
		
		self.counter = 0
		-- Clear out damaged enemies table for next interval
		self.damaged_enemies = {}
	end

	-- "Deals 5/15/25/35 damage in 0.4 or 0.5 seconds intervals, starting 0.1 seconds after cast, the first interval is 0.4 seconds, the rest are 0.5 seconds, resulting in 31 (Talent 47) damage instances."
	if self:GetElapsedTime() < self.tick_interval then
		self.time_to_tick = 0.4
	else
		self.time_to_tick = 0.5
	end
end

function modifier_imba_batrider_firefly:OnDestroy()
	if not IsServer() then return end
	
	if self:GetStackCount() >= 0 then
		self:GetParent():StopSound("Hero_Batrider.Firefly.loop")
	end
	
	if self:GetAbility() and self:GetAbility().methane_boost_ability and #self:GetParent():FindAllModifiersByName(self:GetName()) == 0 then
		self:GetAbility().methane_boost_ability:SetActivated(false)
	end
end

function modifier_imba_batrider_firefly:CheckState()
	if self:GetStackCount() == 1 then
		return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	elseif self:GetStackCount() == 0 then
		return {[MODIFIER_STATE_FLYING]	= true}
	end
end

function modifier_imba_batrider_firefly:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
end

function modifier_imba_batrider_firefly:GetVisualZDelta()
	return 240
end

function modifier_imba_batrider_firefly:GetModifierMoveSpeedBonus_Percentage()
	if self:GetStackCount() == 1 then
		return self.movement_speed
	elseif self:GetStackCount() == 0 then
		return self.movement_speed * self.quiet_flight_multi
	end
end

function modifier_imba_batrider_firefly:GetBonusDayVision()
	return self.bonus_vision
end

function modifier_imba_batrider_firefly:GetBonusNightVision()
	return self.bonus_vision
end

function modifier_imba_batrider_firefly:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	-- IMBAfication: Quiet Flight
	-- Expected behavior: Because auto-cast is typically reserved for deviant behavior (w.r.t. vanilla mechanics), the fire should be turned on if auto-cast is turned OFF
	if self:GetAbility():GetAutoCastState() and not self.firefly_thinker and self:GetStackCount() ~= -1 then
		self:GetParent():EmitSound("Hero_Batrider.Firefly.loop")
		
		self.ember_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.ember_particle, 11, Vector(1, 0, 0))
		self:AddParticle(self.ember_particle, false, false, -1, false, false)		
		
		self.firefly_thinker = CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_imba_batrider_firefly_thinker", {duration = self:GetRemainingTime()}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		self:SetStackCount(1)
		
		self:StartIntervalThink(self.think_interval)
	end
end

--------------------------------------------
-- MODIFIER_IMBA_BATRIDER_FIREFLY_THINKER --
--------------------------------------------

function modifier_imba_batrider_firefly_thinker:IsPurgable() return false end

function modifier_imba_batrider_firefly_thinker:CheckState() return {
	-- keep thinker visible by everyone, so the firefly ground pfx don't disappear when batrider is no longer visible
	[MODIFIER_STATE_PROVIDES_VISION] = true,
} end

function modifier_imba_batrider_firefly_thinker:OnCreated()
	if not IsServer() then return end

	self.firefly_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- The immortal particle effect doesn't have CP11 set to (1, 0, 0) which basically ends up making the flames invisible, so I have to force it here
	ParticleManager:SetParticleControl(self.firefly_particle, 11, Vector(1, 0, 0))
	self:AddParticle(self.firefly_particle, false, false, -1, false, false)

	self:StartIntervalThink(0.1)
end

function modifier_imba_batrider_firefly_thinker:OnIntervalThink()
	self:GetParent():SetAbsOrigin(self:GetCaster():GetAbsOrigin())
end

function modifier_imba_batrider_firefly_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():RemoveSelf()
end

---------------------------------
-- IMBA_BATRIDER_METHANE_BOOST --
---------------------------------

function imba_batrider_methane_boost:GetAssociatedPrimaryAbilities()
	return "imba_batrider_firefly"
end

function imba_batrider_methane_boost:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Batrider.Methane_Boost_Cast")

	local smoke_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_smoke.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(smoke_particle, 3, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(smoke_particle)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_motion_controller", 
	{
		distance		= self:GetTalentSpecialValueFor("distance"),
		direction_x 	= self:GetCaster():GetForwardVector().x,
		direction_y 	= self:GetCaster():GetForwardVector().y,
		direction_z 	= self:GetCaster():GetForwardVector().z,
		duration 		= self:GetSpecialValueFor("duration"),
		height			= nil,
		bGroundStop 	= false,
		bDecelerate 	= true,
		bInterruptible 	= false,
		bIgnoreTenacity	= true,
		bStun			= false,
		bTreeRadius		= nil,
		bDestroyTreesAlongPath = false
	})
	
	self:SetActivated(false)
end

---------------------------------
-- IMBA_BATRIDER_FLAMING_LASSO --
---------------------------------

function imba_batrider_flaming_lasso:OnSpellStart()
	local target = self:GetCursorTarget()
	
	if target:TriggerSpellAbsorb(self) then return end
	
	self:GetCaster():EmitSound("Hero_Batrider.FlamingLasso.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_batrider" then
		local random_int = RandomInt(1, 11)
		
		if random_int <= 9 then
			self:GetCaster():EmitSound("batrider_bat_ability_lasso_0"..random_int)
		else
			self:GetCaster():EmitSound("batrider_bat_ability_lasso_"..random_int)
		end
	end	
	
	-- "Can be cast on Roshan, but he is neither disabled nor dragged (Upgradable by Aghanim's Scepter. nor damaged). Batrider is still disarmed."
	if not target:IsRoshan() then
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_flaming_lasso", {
			duration			= self:GetSpecialValueFor("duration")  * (1 - target:GetStatusResistance()),
			attacker_entindex	= self:GetCaster():entindex()
		})
	end

	if self:GetCaster():HasScepter() then
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius_scepter"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		for _, enemy in pairs(enemies) do
			if enemy ~= target and enemy:IsConsideredHero() then
				enemy:AddNewModifier(target, self, "modifier_imba_batrider_flaming_lasso", {
					duration			= self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance()),
					attacker_entindex	= self:GetCaster():entindex()
				})
				
				break
			end
		end
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_batrider_flaming_lasso_self", {duration = self:GetSpecialValueFor("duration") * (1 - target:GetStatusResistance())})
end

------------------------------------------
-- MODIFIER_IMBA_BATRIDER_FLAMING_LASSO --
------------------------------------------

function modifier_imba_batrider_flaming_lasso:IsDebuff()	return true end

function modifier_imba_batrider_flaming_lasso:GetEffectName()
	return "particles/units/heroes/hero_batrider/batrider_flaming_lasso_generic_smoke.vpcf"
end

function modifier_imba_batrider_flaming_lasso:OnCreated(params)
	if not IsServer() then return end
	
	if params.attacker_entindex then
		self.attacker = EntIndexToHScript(params.attacker_entindex)
	else
		self.attacker = self:GetCaster()
	end
	
	self.drag_distance			= self:GetAbility():GetSpecialValueFor("drag_distance")
	self.break_distance			= self:GetAbility():GetSpecialValueFor("break_distance")
	
	if self:GetCaster():HasScepter() then
		self.damage				= self:GetAbility():GetSpecialValueFor("scepter_damage")
	else
		self.damage				= self:GetAbility():GetSpecialValueFor("damage")
	end
	
	self.counter			= 0
	self.damage_instances	= 1 - self:GetParent():GetStatusResistance()
	self.interval			= FrameTime()
	
	self.chariot_max_length	= self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
	self.vector				= self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
	self.current_position	= self:GetCaster():GetAbsOrigin()	
	
	self.damage_table = {
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self:GetAbility():GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self.attacker,
		ability 		= self:GetAbility()
	}
	
	self:GetParent():EmitSound("Hero_Batrider.FlamingLasso.Loop")
	
	self.lasso_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	if self:GetCaster():GetName() == "npc_dota_hero_batrider" then
		ParticleManager:SetParticleControlEnt(self.lasso_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "lasso_attack", self:GetCaster():GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(self.lasso_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	end
	
	ParticleManager:SetParticleControlEnt(self.lasso_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.lasso_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(self.interval)
end

function modifier_imba_batrider_flaming_lasso:OnRefresh(params)
	self:OnCreated(params)
end

function modifier_imba_batrider_flaming_lasso:OnIntervalThink()
	-- "If Batrider teleports a distance greater than 425, the lasso breaks." (This one's gonna have a higher break distance than 425 but same concept applies)
	if (self:GetCaster():GetAbsOrigin() - self.current_position):Length2D() > self.break_distance or not self:GetCaster():IsAlive() then
		self:Destroy()
	else
		self.vector				= self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
		self.current_position	= self:GetCaster():GetAbsOrigin()
		
		if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.drag_distance then
			self:GetParent():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin() + self.vector:Normalized() * self.drag_distance, nil))
		end
	end	

	self.counter = self.counter + self.interval
	
	if self.counter >= self.damage_instances then
		ApplyDamage(self.damage_table)
		self.counter = 0
	end
end

function modifier_imba_batrider_flaming_lasso:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_Batrider.FlamingLasso.Loop")
	self:GetParent():EmitSound("Hero_Batrider.FlamingLasso.End")

	local self_lasso_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_batrider_flaming_lasso_self", self:GetCaster())

	if self_lasso_modifier then
		self_lasso_modifier:Destroy()
	end
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)	
end

function modifier_imba_batrider_flaming_lasso:CheckState()
	return {
		[MODIFIER_STATE_STUNNED]							= true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY]	= true
	}
end

function modifier_imba_batrider_flaming_lasso:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST}
end

function modifier_imba_batrider_flaming_lasso:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

-- "The lasso also breaks when either Batrider or the target dies. Casting Dismember or Walrus Kick on the lasso target breaks the lasso as well."
-- I am 100% going to forget to update the Walrus Kick modifier here when/if Tusk gets IMBAfied so I guess I'll just pre-empt some stuff???
function modifier_imba_batrider_flaming_lasso:OnAbilityFullyCast(keys)
	if keys.target == self:GetParent() and keys.ability and (keys.ability:GetName() == "pudge_dismember" or keys.ability:GetName() == "imba_pudge_dismember" or keys.ability:GetName() == "tusk_walrus_kick" or keys.ability:GetName() == "imba_tusk_walrus_kick") then
		self:Destroy()
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_BATRIDER_FLAMING_LASSO_SELF --
-----------------------------------------------

function modifier_imba_batrider_flaming_lasso_self:IsDebuff()	return true end
function modifier_imba_batrider_flaming_lasso_self:IsPurgable()	return false end

function modifier_imba_batrider_flaming_lasso_self:OnCreated()
	self.bat_attacks_dmg_pct	= self:GetAbility():GetSpecialValueFor("bat_attacks_dmg_pct")
end

-- IMBAfication: The Bat Attacks
-- function modifier_imba_batrider_flaming_lasso_self:CheckState()
	-- return {
		-- [MODIFIER_STATE_DISARMED]							= true
	-- }
-- end

function modifier_imba_batrider_flaming_lasso_self:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION, MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_imba_batrider_flaming_lasso_self:GetOverrideAnimation()
	return ACT_DOTA_LASSO_LOOP
end

function modifier_imba_batrider_flaming_lasso_self:GetModifierDamageOutgoing_Percentage()
	return (100 - self.bat_attacks_dmg_pct) * (-1)
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown", "components/abilities/heroes/hero_batrider", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown	= class({})

function modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown:IsHidden() 		return true end
function modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown:IsPurgable() 		return false end
function modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown:RemoveOnDeath() 	return false end

function imba_batrider_flamebreak:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_unique_imba_batrider_flamebreak_cooldown") and not self:GetCaster():HasModifier("modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_unique_imba_batrider_flamebreak_cooldown"), "modifier_special_bonus_unique_imba_batrider_flamebreak_cooldown", {})
	end
end
