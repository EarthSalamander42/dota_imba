-- Creator:
--	   AltiV, August 22nd, 2019

LinkLuaModifier("modifier_imba_weaver_the_swarm_unit", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_weaver_the_swarm_debuff", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_weaver_shukuchi_handler", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_weaver_shukuchi", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_weaver_geminate_attack", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
-- This modifier deals with handler the attack after delay (so we don't rely on potentially laggy timers)
LinkLuaModifier("modifier_imba_weaver_geminate_attack_delay", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_weaver_time_lapse_aura", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_weaver_time_lapse", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

imba_weaver_the_swarm						= class({})
modifier_imba_weaver_the_swarm_unit			= class({})
modifier_imba_weaver_the_swarm_debuff		= class({})

imba_weaver_shukuchi						= class({})
modifier_imba_weaver_shukuchi_handler		= class({})
modifier_imba_weaver_shukuchi				= class({})

imba_weaver_geminate_attack					= class({})
modifier_imba_weaver_geminate_attack		= class({})
modifier_imba_weaver_geminate_attack_delay	= class({}) 

imba_weaver_time_lapse						= class({})
modifier_imba_weaver_time_lapse_aura		= class({})
modifier_imba_weaver_time_lapse				= class({})

---------------
-- THE SWARM --
---------------

function imba_weaver_the_swarm:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end
	
	-- Rationale for how this is programmed:
		-- The Swarm latches onto the first enemy it hits which then destroys the linear projectile, but ONLY if the target doesn't already have a latched beetle
		-- Therefore, I cannot make the proejctile simply have bDeleteOnHit = true, otherwise multiple could stack on one unit and not reach anything behind them
		-- But if I do bDeleteOnHit = false, one beetle can latch onto multiple enemies at once which is also bad
		-- Therefore, I need to do bDeleteOnHit = false BUT also make the projectile delete itself once it latches onto a valid target, which means I need its projectileID
		-- I cannot create a linear projectile and feed its own ID into ExtraData, just based on how the functions work
		-- Therefore, I'm going to make some modifier thinkers on these travelling beetles and attach the projectileIDs to those, which then delete themselves in an OnCreated function for the enemy
	
	self:GetCaster():EmitSound("Hero_Weaver.Swarm.Cast")
	
	if self:GetCaster():GetName() == "npc_dota_hero_weaver" and RollPercentage(75) then
		self:GetCaster():EmitSound("weaver_weav_ability_swarm_0"..RandomInt(1, 6))
	end
	
	local start_pos			= nil
	local beetle_dummy		= nil
	local projectile_table	= nil
	local projectileID		= nil
	
	for beetles = 1, self:GetSpecialValueFor("count") do
		start_pos = self:GetCaster():GetAbsOrigin() + RandomVector(RandomInt(0, self:GetSpecialValueFor("spawn_radius")))
		
		beetle_dummy = CreateModifierThinker(self:GetCaster(), self, nil, 
		{
			
		}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
		
		-- Let's not kill eardrums
		if beetles == 1 then
			beetle_dummy:EmitSound("Hero_Weaver.Swarm.Projectile")	
		end
	
		projectile_table = {
			Ability				= self,
			EffectName			= "particles/units/heroes/hero_weaver/weaver_swarm_projectile.vpcf",
			-- "The beetles spawn within a 300 radius around of Weaver (random position) and move forward as a swarm."
			vSpawnOrigin		= start_pos,
			-- "The Swarm moves forward at a speed of 600, taking 5 seconds to reach max distance."
			-- Gonna add the 5 second as an AbilitySpecial which isn't a thing in vanilla
			fDistance			= (self:GetSpecialValueFor("speed") * self:GetSpecialValueFor("travel_time")) + self:GetCaster():GetCastRangeBonus(),
			fStartRadius		= self:GetSpecialValueFor("radius"),
			fEndRadius			= self:GetSpecialValueFor("radius"),
			Source				= self:GetCaster(),
			bHasFrontalCone		= false,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NO_INVIS,
			iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime 		= GameRules:GetGameTime() + 10.0,
			bDeleteOnHit		= false,
			vVelocity			= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
			bProvidesVision		= true,
			-- "The beetles provide flying vision while traveling forwards and while attached to a unit."
			iVisionRadius 		= 321,
			iVisionTeamNumber 	= self:GetCaster():GetTeamNumber(),
			
			ExtraData			= 
			{
				beetle_entindex	= beetle_dummy:entindex()
			}
		}
		
		projectileID = ProjectileManager:CreateLinearProjectile(projectile_table)
		
		beetle_dummy.projectileID	= projectileID
	end
end

-- Make the travel sound follow the bettle
function imba_weaver_the_swarm:OnProjectileThink_ExtraData(location, data)
	if data.beetle_entindex and EntIndexToHScript(data.beetle_entindex) and not EntIndexToHScript(data.beetle_entindex):IsNull() then
		EntIndexToHScript(data.beetle_entindex):SetAbsOrigin(location)
	end
end

function imba_weaver_the_swarm:OnProjectileHit_ExtraData(target, location, data)
	if target and not target:HasModifier("modifier_imba_weaver_the_swarm_debuff") and data.beetle_entindex and EntIndexToHScript(data.beetle_entindex) and not EntIndexToHScript(data.beetle_entindex):IsNull() then
		target:EmitSound("Hero_Weaver.SwarmAttach")
		
		-- "When attached, the beetle always stays 64 range in front of the unit."
		local beetle = CreateUnitByName("npc_dota_weaver_swarm", self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 64, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		beetle:AddNewModifier(self:GetCaster(), self, "modifier_imba_weaver_the_swarm_unit", 
		{
			destroy_attacks		= self:GetTalentSpecialValueFor("destroy_attacks"),
			target_entindex		= target:entindex()
		})
		beetle:SetForwardVector((target:GetAbsOrigin() - beetle:GetAbsOrigin()):Normalized())
		
		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_weaver_the_swarm_debuff",
		{
			duration 			= self:GetSpecialValueFor("duration"),
			damage				= self:GetSpecialValueFor("damage"),
			attack_rate			= self:GetSpecialValueFor("attack_rate"),
			armor_reduction		= self:GetTalentSpecialValueFor("armor_reduction"), -- Needs to be clientside...
			
			damage_type			= self:GetAbilityDamageType(),
			
			beetle_entindex		= beetle:entindex()
		})
		
		if data.beetle_entindex and EntIndexToHScript(data.beetle_entindex) and EntIndexToHScript(data.beetle_entindex).projectileID then
			ProjectileManager:DestroyLinearProjectile(EntIndexToHScript(data.beetle_entindex).projectileID)
			EntIndexToHScript(data.beetle_entindex):StopSound("Hero_Weaver.Swarm.Projectile")
			EntIndexToHScript(data.beetle_entindex):RemoveSelf()
		end

	elseif not target and data.beetle_entindex and EntIndexToHScript(data.beetle_entindex) and not EntIndexToHScript(data.beetle_entindex):IsNull() then
		EntIndexToHScript(data.beetle_entindex):StopSound("Hero_Weaver.Swarm.Projectile")
		EntIndexToHScript(data.beetle_entindex):RemoveSelf()
	end
end

-----------------------------
-- THE SWARM UNIT MODIFIER --
-----------------------------

function modifier_imba_weaver_the_swarm_unit:IsHidden()		return true end
function modifier_imba_weaver_the_swarm_unit:IsPurgable()	return false end

function modifier_imba_weaver_the_swarm_unit:GetEffectName()
	return "particles/units/heroes/hero_weaver/weaver_swarm_debuff.vpcf"
end

function modifier_imba_weaver_the_swarm_unit:OnCreated(params)
	if not IsServer() then return end

	self.destroy_attacks			= params.destroy_attacks
	self.target						= EntIndexToHScript(params.target_entindex)
	self.hero_attack_multiplier		= 2

	-- Calculate health chunks that the unit will lose on getting attacked
	self.health_increments		= self:GetParent():GetMaxHealth() / self.destroy_attacks
	
	-- local phantoms_embrace_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_phantom_ambient.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	-- ParticleManager:SetParticleControlEnt(phantoms_embrace_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	-- self:AddParticle(phantoms_embrace_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_weaver_the_swarm_unit:OnIntervalThink()
	if self.target and not self.target:IsNull() then
		-- "If a beetle's target turns invisible after latching, the beetle dies instantly (credited to no one), if the unit is not under True Sight."
		-- "When the beetles get affected by Chronosphere they instantly die, credited to no one."
		if (self.target:IsInvisible() and not self:GetParent():CanEntityBeSeenByMyTeam(self.target)) or self:GetParent():HasModifier("modifier_imba_faceless_void_chronosphere_handler") then
			self:GetParent():ForceKill(false)
			self:Destroy()

		elseif self.target:IsAlive() then
			self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin() + self.target:GetForwardVector() * 64)
			self:GetParent():SetForwardVector((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
		end
	end
end

function modifier_imba_weaver_the_swarm_unit:OnDestroy()
	if not IsServer() then return end
	
	if self.target and not self.target:IsNull() and self.target:HasModifier("modifier_imba_weaver_the_swarm_debuff") then
		self.target:RemoveModifierByName("modifier_imba_weaver_the_swarm_debuff")
	end
end

function modifier_imba_weaver_the_swarm_unit:CheckState()
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		[MODIFIER_STATE_MAGIC_IMMUNE]		= true,
	}
end

function modifier_imba_weaver_the_swarm_unit:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

-- These aren't working right now
function modifier_imba_weaver_the_swarm_unit:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_imba_weaver_the_swarm_unit:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_imba_weaver_the_swarm_unit:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_weaver_the_swarm_unit:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_imba_weaver_the_swarm_unit:OnAttacked(keys)
    if not IsServer() then return end
	
	if keys.target == self:GetParent() then
		
		if keys.attacker:IsHero() then
			self:GetParent():SetHealth(self:GetParent():GetHealth() - (self.health_increments * self.hero_attack_multiplier))
		else
			self:GetParent():SetHealth(self:GetParent():GetHealth() - self.health_increments)
		end
		
		if self:GetParent():GetHealth() <= 0 then
			self:GetParent():EmitSound("Hero_Grimstroke.InkCreature.Death")
		
			self:GetParent():Kill(nil, keys.attacker)
			self:Destroy()
		end
	end
end

-------------------------------
-- THE SWARM DEBUFF MODIFIER --
-------------------------------

function modifier_imba_weaver_the_swarm_debuff:IgnoreTenacity()	return false end
function modifier_imba_weaver_the_swarm_debuff:IsPurgable()		return false end

function modifier_imba_weaver_the_swarm_debuff:GetEffectName()
	return "particles/units/heroes/hero_weaver/weaver_swarm_infected_debuff.vpcf"
end

-- "Beetles attack in 1.25/1.1/0.95/0.8 second intervals, starting immediately when latching on a unit, resulting in up to 13/15/17/21 attacks."
function modifier_imba_weaver_the_swarm_debuff:OnCreated(params)
	if self:GetAbility() then
		self.armor_reduction	= self:GetAbility():GetTalentSpecialValueFor("armor_reduction")
		self.mana_burn_pct		= self:GetAbility():GetTalentSpecialValueFor("mana_burn_pct")
	else
		self.armor_reduction	= 1
		self.mana_burn_pct		= 50
	end

	if not IsServer() then return end
	
	self.damage			= params.damage
	self.attack_rate	= params.attack_rate
	self.damage_type	= params.damage_type
	self.beetle			= EntIndexToHScript(params.beetle_entindex)
	
	self.damage_table	= {
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	}
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.attack_rate)
end

function modifier_imba_weaver_the_swarm_debuff:OnIntervalThink()
	self:IncrementStackCount()
	
	ApplyDamage(self.damage_table)
	
	-- IMBAfication: M. Eater
	self:GetParent():ReduceMana(self.damage * self.mana_burn_pct * 0.01)
end

function modifier_imba_weaver_the_swarm_debuff:OnDestroy()
	if not IsServer() then return end
	
	if self.beetle and not self.beetle:IsNull() and self.beetle:IsAlive() then
		self.beetle:ForceKill(false)
	end
end

function modifier_imba_weaver_the_swarm_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED				-- IMBAfication: Aggravate
	}
end

function modifier_imba_weaver_the_swarm_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction * self:GetStackCount() * (-1)
end

function modifier_imba_weaver_the_swarm_debuff:OnAttackLanded(keys)
	if keys.attacker == self:GetCaster() and keys.target == self:GetParent() then
		self:IncrementStackCount()
		
		-- ApplyDamage(self.damage_table)
		
		-- self:GetParent():ReduceMana(self.damage * self.mana_burn_pct * 0.01)
	end
end

--------------
-- SHUKUCHI --
--------------

-- Minor difference between vanilla and IMBA: The vanilla version has some sort of small delay between being able to deal damage instances, so spamming the ability with WTF mode on won't apply damage each cast...
-- This one has no sort of delay
function imba_weaver_shukuchi:GetIntrinsicModifierName()
	return "modifier_imba_weaver_shukuchi_handler"
end

function imba_weaver_shukuchi:GetCooldown(level)
	if not self.glitch_point_position then
		return self.BaseClass.GetCooldown(self, level)
	else
		return 0
	end
end

function imba_weaver_shukuchi:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Weaver.Shukuchi")

	if self:GetCaster():FindModifierByNameAndCaster("modifier_imba_weaver_shukuchi", self:GetCaster()) then
		self:GetCaster():RemoveModifierByName("modifier_imba_weaver_shukuchi")
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_weaver_shukuchi", {duration = self:GetSpecialValueFor("duration")})
	
	if self:GetAutoCastState() and self.glitch_point_position then
		local warp_particle = ParticleManager:CreateParticle("particles/items2_fx/teleport_end_streak.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(warp_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(warp_particle)
		FindClearSpaceForUnit(self:GetCaster(), self.glitch_point_position, false)
	end
end

function imba_weaver_shukuchi:OnOwnerDied()
	if self.glitch_point_particle then
		ParticleManager:DestroyParticle(self.glitch_point_particle, true)
		ParticleManager:ReleaseParticleIndex(self.glitch_point_particle)
		self.glitch_point_particle = nil
	end

	if self.glitch_point_position then
		self.glitch_point_position = nil
	end
end

function imba_weaver_shukuchi:OnUnStolen()
	self:OnOwnerDied()
end

-------------------------------
-- SHUKUCHI HANDLER MODIFIER --
-------------------------------

function modifier_imba_weaver_shukuchi_handler:IsHidden()	return true end

function modifier_imba_weaver_shukuchi_handler:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ORDER}
	
	return decFuncs
end

function modifier_imba_weaver_shukuchi_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
		
	if self:GetAbility().glitch_point_particle and self:GetAbility().glitch_point_position then
		ParticleManager:DestroyParticle(self:GetAbility().glitch_point_particle, true)
		ParticleManager:ReleaseParticleIndex(self:GetAbility().glitch_point_particle)
		
		self:GetAbility().glitch_point_position = nil
	end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
		
		
	else
		-- This block runs when auto-cast is turned on
		self:SetStackCount(1)
		
		self:GetAbility().glitch_point_particle = ParticleManager:CreateParticle("particles/ambient/wormhole_circle_rings.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(self:GetAbility().glitch_point_particle, 0, GetGroundPosition(self:GetParent():GetAbsOrigin(), nil))
		
		self:GetAbility().glitch_point_position	= self:GetParent():GetAbsOrigin()
	end
end

-----------------------
-- SHUKUCHI MODIFIER --
-----------------------

function modifier_imba_weaver_shukuchi:GetEffectName()
	return "particles/units/heroes/hero_weaver/weaver_shukuchi.vpcf"
end

function modifier_imba_weaver_shukuchi:OnCreated()
	self.fade_time		= self:GetAbility():GetSpecialValueFor("fade_time")
	self.speed			= self:GetAbility():GetTalentSpecialValueFor("speed")
	
	if not IsServer() then return end
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self.damage				= self:GetAbility():GetTalentSpecialValueFor("damage")
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	
	self.hit_targets		= {}
	self.shukuchi_particle	= nil
	self.damage_table		= {
		victim 			= nil,
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetParent(),
		ability 		= self:GetAbility()
	}	
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_weaver_shukuchi:OnIntervalThink()
	self.enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(self.enemies) do
		if not self.hit_targets[enemy] then
			self.shukuchi_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_shukuchi_damage_arc.vpcf", PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(self.shukuchi_particle, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.shukuchi_particle)
			self.shukuchi_particle = nil
		
			self.damage_table.victim	= enemy
			ApplyDamage(self.damage_table)
			self.hit_targets[enemy]	= true
		end
	end
end

function modifier_imba_weaver_shukuchi:CheckState()
	if self:GetElapsedTime() >= self.fade_time then
		return {
			[MODIFIER_STATE_INVISIBLE]			= true,
			[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
			[MODIFIER_STATE_UNSLOWABLE]			= true
		}
	else
		return {
			[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
			[MODIFIER_STATE_UNSLOWABLE]			= true
		}
	end
end

function modifier_imba_weaver_shukuchi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
end

function modifier_imba_weaver_shukuchi:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_imba_weaver_shukuchi:GetModifierMoveSpeedBonus_Constant()
	return self.speed
end

function modifier_imba_weaver_shukuchi:GetModifierInvisibilityLevel()
	return math.min(self:GetElapsedTime() / self.fade_time, 1)
end

function modifier_imba_weaver_shukuchi:OnAttack(keys)
	if keys.attacker == self:GetParent() and not keys.no_attack_cooldown and self:GetElapsedTime() >= self.fade_time then
		self:Destroy()
	end
end

function modifier_imba_weaver_shukuchi:OnAbilityFullyCast(keys)
	if keys.unit == self:GetParent() and keys.ability ~= self:GetAbility() and self:GetElapsedTime() >= self.fade_time then
		self:Destroy()
	end
end

---------------------
-- GEMINATE ATTACK --
---------------------
function imba_weaver_geminate_attack:GetBehavior()				return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
function imba_weaver_geminate_attack:GetIntrinsicModifierName()	return "modifier_imba_weaver_geminate_attack" end
function imba_weaver_geminate_attack:OnAbilityPhaseStart()		return false end

------------------------------
-- GEMINATE ATTACK MODIFIER --
------------------------------

function modifier_imba_weaver_geminate_attack:IsHidden()	return true end

function modifier_imba_weaver_geminate_attack:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_imba_weaver_geminate_attack:OnAttack(keys)
	if not IsServer() then return end

	local ability = self:GetAbility()
	local parent = self:GetParent()
	local target = keys.target

	if not target or target:IsNull() then
		return
	end
	if target.GetUnitName == nil or not target:IsBaseNPC() then
		return
	end
	if keys.attacker == parent and ability:IsFullyCastable() and not parent:IsIllusion() and not parent:PassivesDisabled() and not keys.no_attack_cooldown and target:GetUnitName() ~= "npc_dota_observer_wards" and target:GetUnitName() ~= "npc_dota_sentry_wards" then
		for geminate_attacks = 1, ability:GetTalentSpecialValueFor("tooltip_attack") do
			parent:AddNewModifier(target, ability, "modifier_imba_weaver_geminate_attack_delay", {delay = ability:GetSpecialValueFor("delay") * geminate_attacks})
		end
		
		ability:UseResources(false, false, false, true)
	end
end

------------------------------------
-- GEMINATE ATTACK DELAY MODIFIER --
------------------------------------

function modifier_imba_weaver_geminate_attack_delay:IsHidden()		return true end
function modifier_imba_weaver_geminate_attack_delay:IsPurgable()	return false end
function modifier_imba_weaver_geminate_attack_delay:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_weaver_geminate_attack_delay:OnCreated(params)
	if not IsServer() then return end
	
	self.bonus_damage	= self:GetAbility():GetSpecialValueFor("bonus_damage")
	
	if self:GetAbility():GetAutoCastState() and not self:GetParent():IsRooted() then
		local new_position = self:GetCaster():GetAbsOrigin() + RandomVector((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D())
	
		local geminate_lapse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(geminate_lapse_particle, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(geminate_lapse_particle, 2, new_position)
		ParticleManager:SetParticleControl(geminate_lapse_particle, 61, Vector(1, 0, 0))
		ParticleManager:ReleaseParticleIndex(geminate_lapse_particle)
	
		FindClearSpaceForUnit(self:GetParent(), new_position, false)
		self:GetParent():SetForwardVector((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())
		GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius(), true)
		
		ProjectileManager:ProjectileDodge(self:GetParent())
	end
	
	if params and params.delay then
		self:StartIntervalThink(params.delay)
	end
end

function modifier_imba_weaver_geminate_attack_delay:OnIntervalThink()
	if self:GetParent():IsAlive() then
		self.attack_bonus = true
		self:GetParent():PerformAttack(self:GetCaster(), true, true, true, false, true, false, false) 
		self.attack_bonus = false
		
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_imba_weaver_geminate_attack_delay:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_imba_weaver_geminate_attack_delay:GetModifierPreAttack_BonusDamage()
	if not IsServer() or not self.attack_bonus then return end

	return self.bonus_damage
end

----------------
-- TIME LAPSE --
----------------

function imba_weaver_time_lapse:GetIntrinsicModifierName()	return "modifier_imba_weaver_time_lapse_aura" end

function imba_weaver_time_lapse:GetBehavior()
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetBehavior(self)
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end

function imba_weaver_time_lapse:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_weaver_time_lapse:OnSpellStart()
	if not self:GetCursorTarget() or self:GetCursorTarget() == self:GetCaster() then
		if not self.intrinsic_modifier then
			self.intrinsic_modifier = self:GetCaster():FindModifierByName(self:GetIntrinsicModifierName())
		end
		
		if self.intrinsic_modifier and
		self.intrinsic_modifier.instances_health and
		self.intrinsic_modifier.instances_health[1] and
		self.intrinsic_modifier.instances_mana and
		self.intrinsic_modifier.instances_mana[1] and
		self.intrinsic_modifier.instances_position and
		self.intrinsic_modifier.instances_position[1] then
			self:GetCaster():EmitSound("Hero_Weaver.TimeLapse")
			
			local time_lapse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(time_lapse_particle, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(time_lapse_particle, 2, self.intrinsic_modifier.instances_position[1])
			ParticleManager:ReleaseParticleIndex(time_lapse_particle)
			
			-- "Time Lapse disjoints projectiles and applies a strong dispel upon cast."
			ProjectileManager:ProjectileDodge(self:GetCaster())
			self:GetCaster():Purge(false, true, false, true, true)
			-- "Weaver is ordered to stop right after getting moved back. However, shift-queued commands are not canceled."
			self:GetCaster():Stop()
	
			-- IMBAfication: Paradox
			-- "API Additions - Global (Server): * CreateIllusions( hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) Note: See script_help2 for supported modifier keys"
			CreateIllusions(self:GetCaster(), self:GetCaster(), 
			{
				outgoing_damage = 0,
				incoming_damage	= 0,
				bounty_base		= self:GetCaster():GetIllusionBounty(),
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= 5
			}
			, 1, self:GetCaster():GetHullRadius(), true, true)
	
			self:GetCaster():SetHealth(math.max(self.intrinsic_modifier.instances_health[1], 1))
			self:GetCaster():SetMana(self.intrinsic_modifier.instances_mana[1])
			FindClearSpaceForUnit(self:GetCaster(), self.intrinsic_modifier.instances_position[1], false)
		end
	else
		local target_modifier = self:GetCursorTarget():FindModifierByName("modifier_imba_weaver_time_lapse")
		
		if target_modifier and
		target_modifier.instances_health and
		target_modifier.instances_health[1] and
		target_modifier.instances_mana and
		target_modifier.instances_mana[1] and
		target_modifier.instances_position and
		target_modifier.instances_position[1] then
			self:GetCursorTarget():EmitSound("Hero_Weaver.TimeLapse")
			
			local time_lapse_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", PATTACH_WORLDORIGIN, self:GetCursorTarget())
			ParticleManager:SetParticleControl(time_lapse_particle, 0, self:GetCursorTarget():GetAbsOrigin())
			ParticleManager:SetParticleControl(time_lapse_particle, 2, target_modifier.instances_position[1])
			ParticleManager:ReleaseParticleIndex(time_lapse_particle)
		
			-- "Applies the disjoint and strong dispel on the target ally as well."
			ProjectileManager:ProjectileDodge(self:GetCursorTarget())
			self:GetCursorTarget():Purge(false, true, false, true, true)
		
			-- IMBAfication: Paradox
			-- "API Additions - Global (Server): * CreateIllusions( hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) Note: See script_help2 for supported modifier keys"
			CreateIllusions(self:GetCaster(), self:GetCursorTarget(), 
			{
				outgoing_damage = 0,
				incoming_damage	= 0,
				bounty_base		= self:GetCursorTarget():GetIllusionBounty(),
				bounty_growth	= nil,
				outgoing_damage_structure	= nil,
				outgoing_damage_roshan		= nil,
				duration		= 5
			}
			, 1, self:GetCaster():GetHullRadius(), true, true)		
		
			self:GetCursorTarget():SetHealth(math.max(target_modifier.instances_health[1], 1))
			self:GetCursorTarget():SetMana(target_modifier.instances_mana[1])
			FindClearSpaceForUnit(self:GetCursorTarget(), target_modifier.instances_position[1], false)
		end
	end
	
	-- IMBAfication: It's Rewind Time
	if not self.abilities_to_refresh then
		self.abilities_to_refresh = {"imba_weaver_the_swarm", "imba_weaver_shukuchi", "imba_weaver_geminate_attack"}
	end
	
	for _, ability in pairs(self.abilities_to_refresh) do
		if self:GetCaster():FindAbilityByName(ability) then
			self:GetCaster():FindAbilityByName(ability):EndCooldown()
		end
	end	
end

------------------------------
-- TIME LAPSE AURA MODIFIER --
------------------------------

function modifier_imba_weaver_time_lapse_aura:IsHidden()			return true end

function modifier_imba_weaver_time_lapse_aura:OnCreated()
	if not IsServer() then return end
	
	-- This doesn't work???
	-- TODO: Double check this
	-- self.lapsed_time		= self:GetAbility():GetSpecialValueFor("lapsed_time")
	self.lapsed_time		= 5
	
	self.instances_health 	= {}
	self.instances_mana 	= {}
	self.instances_position	= {}
	self.interval			= 0.1
	self.total_saved_points	= self.lapsed_time / self.interval
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)
end

function modifier_imba_weaver_time_lapse_aura:OnIntervalThink()
	if self:GetParent():IsAlive() then
		table.insert(self.instances_health, self:GetParent():GetHealth())
		table.insert(self.instances_mana, self:GetParent():GetMana())
		table.insert(self.instances_position, self:GetParent():GetAbsOrigin())

		if #self.instances_health >= self.total_saved_points then
			table.remove(self.instances_health, 1)
			table.remove(self.instances_mana, 1)
			table.remove(self.instances_position, 1)
		end
	end
end

function modifier_imba_weaver_time_lapse_aura:IsAura() 				return true end
function modifier_imba_weaver_time_lapse_aura:IsAuraActiveOnDeath() return true end

function modifier_imba_weaver_time_lapse_aura:GetAuraRadius()		return FIND_UNITS_EVERYWHERE end
function modifier_imba_weaver_time_lapse_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD end

function modifier_imba_weaver_time_lapse_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_imba_weaver_time_lapse_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO end
function modifier_imba_weaver_time_lapse_aura:GetModifierAura()		return "modifier_imba_weaver_time_lapse" end

-- "When cast on allies who just respawned, their health, mana and position are not set back to what they were before the death."
-- "This means allies cannot be sent back to their death location after respawning, unlike how Weaver can when cast on self."
function modifier_imba_weaver_time_lapse_aura:GetAuraEntityReject(target) return target == self:GetCaster() end

-------------------------
-- TIME LAPSE MODIFIER --
-------------------------

function modifier_imba_weaver_time_lapse:IsHidden()	return true end

function modifier_imba_weaver_time_lapse:OnCreated()
	if not IsServer() then return end
	
	-- This doesn't work???
	-- self.lapsed_time		= self:GetAbility():GetSpecialValueFor("lapsed_time")
	self.lapsed_time		= 5
	
	self.instances_health 	= {}
	self.instances_mana 	= {}
	self.instances_position	= {}
	self.interval			= 0.1
	self.total_saved_points	= self.lapsed_time / self.interval
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)
end

function modifier_imba_weaver_time_lapse:OnIntervalThink()
	table.insert(self.instances_health, self:GetParent():GetHealth())
	table.insert(self.instances_mana, self:GetParent():GetMana())
	table.insert(self.instances_position, self:GetParent():GetAbsOrigin())

	if #self.instances_health >= self.total_saved_points then
		table.remove(self.instances_health, 1)
		table.remove(self.instances_mana, 1)
		table.remove(self.instances_position, 1)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_weaver_shukuchi_damage", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_weaver_shukuchi_damage	= modifier_special_bonus_imba_weaver_shukuchi_damage or class({})
modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks	= modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks or class({})
modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack	= modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack or class({})

function modifier_special_bonus_imba_weaver_shukuchi_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_weaver_shukuchi_damage:IsPurgable()		return false end
function modifier_special_bonus_imba_weaver_shukuchi_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks:IsHidden() 		return true end
function modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks:IsPurgable()		return false end
function modifier_special_bonus_imba_weaver_the_swarm_destroy_attacks:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack:IsHidden() 		return true end
function modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack:IsPurgable()		return false end
function modifier_special_bonus_imba_weaver_geminate_attack_tooltip_attack:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_weaver_the_swarm_armor_reduction", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_weaver_shukuchi_hasted_speed", "components/abilities/heroes/hero_weaver", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_weaver_the_swarm_armor_reduction	= class({})
modifier_special_bonus_imba_weaver_shukuchi_hasted_speed		= class({})

function modifier_special_bonus_imba_weaver_the_swarm_armor_reduction:IsHidden() 		return true end
function modifier_special_bonus_imba_weaver_the_swarm_armor_reduction:IsPurgable() 		return false end
function modifier_special_bonus_imba_weaver_the_swarm_armor_reduction:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_weaver_shukuchi_hasted_speed:IsHidden() 		return true end
function modifier_special_bonus_imba_weaver_shukuchi_hasted_speed:IsPurgable() 		return false end
function modifier_special_bonus_imba_weaver_shukuchi_hasted_speed:RemoveOnDeath() 	return false end

function imba_weaver_the_swarm:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_weaver_the_swarm_armor_reduction") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_weaver_the_swarm_armor_reduction") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_weaver_the_swarm_armor_reduction"), "modifier_special_bonus_imba_weaver_the_swarm_armor_reduction", {})
	end
end

function imba_weaver_shukuchi:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_weaver_shukuchi_hasted_speed") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_weaver_shukuchi_hasted_speed") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_weaver_shukuchi_hasted_speed"), "modifier_special_bonus_imba_weaver_shukuchi_hasted_speed", {})
	end
end
