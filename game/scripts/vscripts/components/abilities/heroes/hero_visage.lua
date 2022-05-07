-- Creator:
--	   AltiV, August 6th, 2019

LinkLuaModifier("modifier_imba_visage_grave_chill_buff", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_grave_chill_debuff", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_soul_assumption", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_soul_assumption_stacks", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_soul_assumption_counter", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_gravekeepers_cloak", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_gravekeepers_cloak_secondary", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_gravekeepers_cloak_secondary_ally", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_stone_form_self_cast", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_summon_familiars", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_summon_familiars_petrifying_breath", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_summon_familiars_stone_form_root", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_summon_familiars_stone_form_buff", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_visage_become_familiar_delay", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_visage_become_familiar", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

imba_visage_grave_chill									= class({})
modifier_imba_visage_grave_chill_buff					= class({})
modifier_imba_visage_grave_chill_debuff					= class({})

imba_visage_soul_assumption								= class({})
modifier_imba_visage_soul_assumption					= class({})
modifier_imba_visage_soul_assumption_stacks				= class({})
modifier_imba_visage_soul_assumption_counter			= class({})

imba_visage_gravekeepers_cloak							= class({})
modifier_imba_visage_gravekeepers_cloak					= class({})
modifier_imba_visage_gravekeepers_cloak_secondary		= class({})
modifier_imba_visage_gravekeepers_cloak_secondary_ally	= class({})

imba_visage_stone_form_self_cast						= class({})
modifier_imba_visage_stone_form_self_cast				= class({})

imba_visage_summon_familiars							= class({})
modifier_imba_visage_summon_familiars					= class({})
modifier_imba_visage_summon_familiars_petrifying_breath	= class({})

imba_visage_summon_familiars_stone_form					= class({})
modifier_imba_visage_summon_familiars_stone_form_root	= class({})
modifier_imba_visage_summon_familiars_stone_form_buff	= class({})

imba_visage_become_familiar								= class({})
modifier_imba_visage_become_familiar_delay				= class({})
modifier_imba_visage_become_familiar					= class({})

-----------------
-- GRAVE CHILL --
-----------------

function imba_visage_grave_chill:OnSpellStart()
	local target = self:GetCursorTarget()
	
	-- Blocked by Linken's
	if target:TriggerSpellAbsorb(self) then return end
		
	self:GetCaster():EmitSound("Hero_Visage.GraveChill.Cast")
	target:EmitSound("Hero_Visage.GraveChill.Target")

	if self:GetCaster():GetName() == "npc_dota_hero_visage" and RollPercentage(25) then
		if not self.responses then
			self.responses = 
			{
				"visage_visa_gravechill_04",
				"visage_visa_gravechill_05",
				"visage_visa_gravechill_14",
				"visage_visa_gravechill_21",
				"visage_visa_gravechill_22"
			}
		end
		
		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end
	
	local chill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_cast_beams.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(chill_particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(chill_particle, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(chill_particle)
	
	-- I set the target as the caster here rather than the caster itself because I am utilizing that target's Death's Enticement IMBAfication modifier stacks, which I want to show on client-side
	self:GetCaster():AddNewModifier(target, self, "modifier_imba_visage_grave_chill_buff", {duration = self:GetSpecialValueFor("chill_duration") * (1 - target:GetStatusResistance())})
	
	-- "Grave Chill also grants the buff to Familiars within 1200 range of Visage. The buff on the Familiars is not aura-based. It places a separate buff on each Familiar."
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	
	for _, ally in pairs(allies) do
		if string.find(ally:GetDebugName(), "npc_dota_visage_familiar") then
			ally:AddNewModifier(target, self, "modifier_imba_visage_grave_chill_buff", {duration = self:GetSpecialValueFor("chill_duration") * (1 - target:GetStatusResistance())})
		end
	end
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_imba_visage_grave_chill_debuff", {duration = self:GetSpecialValueFor("chill_duration") * (1 - target:GetStatusResistance())})
end

-------------------------------
-- GRAVE CHILL BUFF MODIFIER --
-------------------------------

function modifier_imba_visage_grave_chill_buff:IsDebuff()	return false end

function modifier_imba_visage_grave_chill_buff:OnCreated()
	self.movespeed_bonus					= self:GetAbility():GetSpecialValueFor("movespeed_bonus")
	self.attackspeed_bonus					= self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
	self.deaths_enticement_bonus_per_sec	= self:GetAbility():GetSpecialValueFor("deaths_enticement_bonus_per_sec")
	
	if not IsServer() then return end
	
	-- Custom variable in on_unit_spawned.lua or on_hero_spawned.lua
	if self:GetCaster().time_spawned then
		self:SetStackCount(math.floor(GameRules:GetGameTime() - self:GetCaster().time_spawned) * (-1))
	end
	
	local chill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_caster.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- I have no god damn idea what connects to where
	ParticleManager:SetParticleControlEnt(chill_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true)
	
	if self:GetParent():GetName() == "npc_dota_hero_visage" and not self:GetParent():HasModifier("modifier_imba_visage_become_familiar") then
		ParticleManager:SetParticleControlEnt(chill_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_tail_tip", self:GetParent():GetAbsOrigin(), true)ParticleManager:SetParticleControlEnt(chill_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_wingtipL", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(chill_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_wingtipR", self:GetParent():GetAbsOrigin(), true)
	else
		ParticleManager:SetParticleControlEnt(chill_particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)ParticleManager:SetParticleControlEnt(chill_particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(chill_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)	
	end
	
	self:AddParticle(chill_particle, false, false, -1, false, false)
end

function modifier_imba_visage_grave_chill_buff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_visage_grave_chill_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_imba_visage_grave_chill_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus
end

function modifier_imba_visage_grave_chill_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus + (self:GetStackCount() * (-1) * self.deaths_enticement_bonus_per_sec)
end

function modifier_imba_visage_grave_chill_buff:GetModifierTurnRate_Percentage()
	return self:GetStackCount() * (-1) * self.deaths_enticement_bonus_per_sec
end

---------------------------------
-- GRAVE CHILL DEBUFF MODIFIER --
---------------------------------

function modifier_imba_visage_grave_chill_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_visage/status_effect_visage_chill_slow.vpcf"
end

function modifier_imba_visage_grave_chill_debuff:OnCreated()
	self.movespeed_bonus					= self:GetAbility():GetSpecialValueFor("movespeed_bonus") * (-1)
	self.attackspeed_bonus					= self:GetAbility():GetSpecialValueFor("attackspeed_bonus") * (-1)
	self.deaths_enticement_bonus_per_sec	= self:GetAbility():GetSpecialValueFor("deaths_enticement_bonus_per_sec")
	
	if not IsServer() then return end

	-- Custom variable in on_unit_spawned.lua or on_hero_spawned.lua
	if self:GetParent().time_spawned then
		self:SetStackCount(math.floor(GameRules:GetGameTime() - self:GetParent().time_spawned) * (-1))
	end
	
	local chill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(chill_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(chill_particle, false, false, -1, false, false)
end

function modifier_imba_visage_grave_chill_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_visage_grave_chill_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_imba_visage_grave_chill_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_bonus
end

function modifier_imba_visage_grave_chill_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed_bonus + (self:GetStackCount() * self.deaths_enticement_bonus_per_sec)
end

function modifier_imba_visage_grave_chill_debuff:GetModifierTurnRate_Percentage()
	return self:GetStackCount() * self.deaths_enticement_bonus_per_sec
end

---------------------
-- SOUL ASSUMPTION --
---------------------

function imba_visage_soul_assumption:GetIntrinsicModifierName()
	return "modifier_imba_visage_soul_assumption"
end

function imba_visage_soul_assumption:OnUpgrade()
	if not IsServer() then return end
	
	if self:GetLevel() >= 1 and self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()) and not self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).particle then
		self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
		self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()):AddParticle(self:GetCaster():FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), self:GetCaster()).particle, false, false, -1, false, false)
	end
end

function imba_visage_soul_assumption:OnSpellStart()
	local target = self:GetCursorTarget()
	
	self:GetCaster():EmitSound("Hero_Visage.SoulAssumption.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_visage" then
		if RollPercentage(10) then
			if not self.responses_rare then
				self.responses_rare = 
				{
					"visage_visa_soulassumption01",
					"visage_visa_soulassumption02",
					"visage_visa_soulassumption07"
				}
			end
			
			self:GetCaster():EmitSound(self.responses_rare[RandomInt(1, #self.responses_rare)])
		else
			if not self.responses then
				self.responses = 
				{
					"visage_visa_gravechill_24",
					"visage_visa_gravechill_26",
					"visage_visa_gravechill_27",
					"visage_visa_gravechill_28",
					"visage_visa_gravechill_32"
				}
			end
			
			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end
	end
	
	local assumption_counter_modifier	= self:GetCaster():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_counter", self:GetCaster())
	local damage_bars					= 0
	local effect_name					= "particles/units/heroes/hero_visage/visage_soul_assumption_bolt.vpcf"
	-- IMBAfication: Soul Accelerant
	local overflow_counter				= 1
	
	if assumption_counter_modifier then	
		damage_bars = math.min(math.floor(assumption_counter_modifier:GetStackCount() / self:GetSpecialValueFor("damage_limit")), self:GetSpecialValueFor("stack_limit"))
		overflow_counter = math.max(assumption_counter_modifier:GetStackCount() - (self:GetSpecialValueFor("damage_limit") * self:GetSpecialValueFor("stack_limit")), 0)
		
		if damage_bars > 0 then
			effect_name	="particles/units/heroes/hero_visage/visage_soul_assumption_bolt"..damage_bars..".vpcf"
		end
		
		local assumption_stack_modifiers = self:GetCaster():FindAllModifiersByName("modifier_imba_visage_soul_assumption_stacks")
		
		for _, mod in pairs(assumption_stack_modifiers) do
			mod:Destroy()
		end
		
		assumption_counter_modifier:Destroy()
	end
	
	local projectile =
	{
		Target 				= nil,
		Source 				= self:GetCaster(),
		Ability 			= self,
		EffectName 			= effect_name,
		iMoveSpeed			= math.min(self:GetSpecialValueFor("bolt_speed") + overflow_counter, self:GetSpecialValueFor("soul_accelerant_max")),
		vSourceLoc 			= self:GetCaster():GetAbsOrigin(),
		bDrawsOnMinimap 	= false,
		bDodgeable 			= true,
		bIsAttack 			= false,
		bVisibleToEnemies 	= true,
		bReplaceExisting 	= false,
		flExpireTime 		= GameRules:GetGameTime() + 10.0,
		bProvidesVision 	= false,
		
		iSourceAttachment	= DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		
		ExtraData = {
			charges			= damage_bars
		}
	}
	
	projectile.Target = target
	ProjectileManager:CreateTrackingProjectile(projectile)
	
	local target_counter = 1
	
	-- CDOTA_BaseNPC: GetCastRangeBonus() added in Summer Scrub patch xd
	-- "Heroes and illusions have a higher priority than other units. Treats creep-heroes as creeps."
	local enemy_heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemy_heroes) do	
		if target_counter >= self:GetTalentSpecialValueFor("targets") then
			break
		end	
	
		if enemy ~= target then
			projectile.Target = enemy
			ProjectileManager:CreateTrackingProjectile(projectile)
			
			target_counter = target_counter + 1
		end
	end
	
	if target_counter < self:GetTalentSpecialValueFor("targets") then
		local enemy_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false) 
		
		for _, enemy in pairs(enemy_creeps) do
			if target_counter >= self:GetTalentSpecialValueFor("targets") then
				break
			end
		
			if enemy ~= target then
				projectile.Target = enemy
				ProjectileManager:CreateTrackingProjectile(projectile)
				
				target_counter = target_counter + 1		
			end
		end
	end
end

function imba_visage_soul_assumption:OnProjectileHit_ExtraData(target, location, data)
	if target and not target:TriggerSpellAbsorb(self) then
		target:EmitSound("Hero_Visage.SoulAssumption.Target")

		local damageTable = {
			victim 			= target,
			damage 			= self:GetSpecialValueFor("soul_base_damage") + (self:GetTalentSpecialValueFor("soul_charge_damage") * data.charges),
			damage_type		= self:GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		}

		ApplyDamage(damageTable)
	end
end

-------------------------------
-- SOUL ASSUMPTION MODIFIER --
------------------------------

function modifier_imba_visage_soul_assumption:IsHidden()		return true end
function modifier_imba_visage_soul_assumption:IsPurgable()		return false end
function modifier_imba_visage_soul_assumption:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- This shouldn't really happen but in case it gets ported in already leveled
function modifier_imba_visage_soul_assumption:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() and self:GetAbility():GetLevel() >= 1 and not self.particle then
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.particle, false, false, -1, false, false)
	end
end

function modifier_imba_visage_soul_assumption:OnDestroy()
	if IsServer() and self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_visage_soul_assumption:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	
	return decFuncs
end

function modifier_imba_visage_soul_assumption:OnTakeDamage(keys)
	-- "Only counts damage dealt by players (including their summons) and Roshan."
	-- "Only counts when the damage was dealt to a hero (excluding illusions and creep-heroes)."
	-- "Does not count self-inflicted damage, or damage less than 2 or greater than 3000 (after reductions)."

	if (keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetAbility():GetSpecialValueFor("radius") and
	(keys.attacker:IsControllableByAnyPlayer() or keys.attacker:IsRoshan()) and
	(keys.unit:IsRealHero() or string.find(keys.attacker:GetDebugName(), "npc_dota_visage_familiar")) and -- IMBAfication: Familiar Flow
	keys.unit ~= keys.attacker and
	keys.damage >= self:GetAbility():GetSpecialValueFor("damage_min") and
	keys.damage <= self:GetAbility():GetSpecialValueFor("damage_max") and
	-- Seems like Soul Assumption damage doesn't feed into its own stacks
	keys.inflictor ~= self:GetAbility() then	

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_soul_assumption_counter", 
		{
			duration	= self:GetAbility():GetSpecialValueFor("stack_duration"),
			stacks		= keys.damage
		})
	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_soul_assumption_stacks", 
		{
			duration	= self:GetAbility():GetSpecialValueFor("stack_duration"),
			stacks		= keys.damage
		})
	end
end

-------------------------------------
-- SOUL ASSUMPTION STACKS MODIFIER --
-------------------------------------

function modifier_imba_visage_soul_assumption_stacks:IsHidden()				return true end
function modifier_imba_visage_soul_assumption_stacks:IsPurgable()			return false end
function modifier_imba_visage_soul_assumption_stacks:GetAttributes()		return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_visage_soul_assumption_stacks:OnCreated(params)
	if not IsServer() then return end

	self.damage_limit	= self:GetAbility():GetSpecialValueFor("damage_limit")
	self.stack_limit	= self:GetAbility():GetSpecialValueFor("stack_limit")

	self:SetStackCount(params.stacks)

	local assumption_modifier			= self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption", self:GetCaster())
	local assumption_counter_modifier 	= self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_counter", self:GetCaster())
	
	if assumption_modifier and assumption_modifier.particle and assumption_counter_modifier then
		assumption_counter_modifier:SetStackCount(assumption_counter_modifier:GetStackCount() + params.stacks)
	
		for bar = 1, self.stack_limit do
			ParticleManager:SetParticleControl(assumption_modifier.particle, bar, Vector(assumption_counter_modifier:GetStackCount() - (self.damage_limit * bar), 0, 0))
		end
	end
end

function modifier_imba_visage_soul_assumption_stacks:OnDestroy()
	if not IsServer() then return end
	
	local assumption_modifier			= self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption", self:GetCaster())
	local assumption_counter_modifier 	= self:GetParent():FindModifierByNameAndCaster("modifier_imba_visage_soul_assumption_counter", self:GetCaster())
	
	if assumption_counter_modifier then
		assumption_counter_modifier:SetStackCount(assumption_counter_modifier:GetStackCount() - self:GetStackCount())
		
		if assumption_modifier and assumption_modifier.particle then
			for bar = 1, self.stack_limit do
				ParticleManager:SetParticleControl(assumption_modifier.particle, bar, Vector(assumption_counter_modifier:GetStackCount() - (self.damage_limit * bar), 0, 0))
			end
		end
	end
end

------------------------------------
-- SOUL ASSUMPTION COUNT MODIFIER --
------------------------------------

function modifier_imba_visage_soul_assumption_counter:IsHidden()	return true end
function modifier_imba_visage_soul_assumption_counter:IsPurgable()	return false end

-------------------------
-- GRAVEKEEPER'S CLOAK --
-------------------------

function imba_visage_gravekeepers_cloak:GetIntrinsicModifierName()
	return "modifier_imba_visage_gravekeepers_cloak"
end

function imba_visage_gravekeepers_cloak:OnUpgrade()
	local cloak_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_visage_gravekeepers_cloak", self:GetCaster())
	
	if cloak_modifier then
		if self:GetLevel() >= 1 and not cloak_modifier.initialized then
			cloak_modifier:SetStackCount(self:GetSpecialValueFor("max_layers"))
			cloak_modifier.initialized	= true
		end
	end
end

-- Hmm...
function imba_visage_gravekeepers_cloak:OnSpellStart()

end

----------------------------------
-- GRAVEKEEPER'S CLOAK MODIFIER --
----------------------------------

function modifier_imba_visage_gravekeepers_cloak:IsHidden()	return self:GetAbility() == nil or self:GetAbility():GetLevel() < 1 end

-- This OnCreated block is technically not vanilla
function modifier_imba_visage_gravekeepers_cloak:OnCreated()
	if not IsServer() then return end
	
	self.cloak_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_cloak_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	-- The particle only supports up to 4 layers but we have more here
	for layer = 2, 5 do
		ParticleManager:SetParticleControl(self.cloak_particle, layer, Vector(1, 0, 0))
	end
	
	self:AddParticle(self.cloak_particle, false, false, -1, false, false)
	
	self:StartIntervalThink(self:GetAbility():GetTalentSpecialValueFor("recovery_time"))
end

function modifier_imba_visage_gravekeepers_cloak:OnIntervalThink()
	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_layers") then
		self:IncrementStackCount()
		
		for layer = 2, 5 do
			if self:GetStackCount() + 1 >= layer then
				ParticleManager:SetParticleControl(self.cloak_particle, layer, Vector(1, 0, 0))
			else
				ParticleManager:SetParticleControl(self.cloak_particle, layer, Vector(0, 0, 0))
			end
		end
	else
		-- IMBAfication: Cloak Encompassing
		local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		for _, ally in pairs(allies) do
			if ally ~= self:GetParent() and not string.find(ally:GetDebugName(), "npc_dota_visage_familiar") then
				local secondary_cloak_modifier = ally:FindModifierByNameAndCaster("modifier_imba_visage_gravekeepers_cloak_secondary_ally", self:GetCaster())
				
				if not secondary_cloak_modifier or secondary_cloak_modifier:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_layers") then
					ally:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_gravekeepers_cloak_secondary_ally", {})
					break
				end
			end
		end
	end
	
	-- Restart interval think every time due to recovery time changing based on ability level
	self:StartIntervalThink(-1)
	self:StartIntervalThink(self:GetAbility():GetTalentSpecialValueFor("recovery_time"))
end

-- We don't even need this block now if the OnCreated exists
-- function modifier_imba_visage_gravekeepers_cloak:OnStackCountChanged(stackCount)
	-- -- If max stacks have been reached, the modifier no longer needs to think
	-- if self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("max_layers") then
		-- -- Vanilla would just stop interval think at max stacks, but let's add another mechanic
		-- -- self:StartIntervalThink(-1)

	-- -- Otherwise, if the stack has been reduced to one below its max, start the interval think
	-- -- (cannot be called below that because it would keep resetting the think timer otherwise)
	-- elseif stackCount == self:GetAbility():GetSpecialValueFor("max_layers") and self:GetStackCount() == self:GetAbility():GetSpecialValueFor("max_layers") - 1 then
		-- self:StartIntervalThink(self:GetAbility():GetTalentSpecialValueFor("recovery_time"))
	-- end
-- end

function modifier_imba_visage_gravekeepers_cloak:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	
	return decFuncs
end

-- "Only reacts on player-based damage, excluding self-inflicted damage."
function modifier_imba_visage_gravekeepers_cloak:GetModifierIncomingDamage_Percentage(keys)
	if not self:GetParent():PassivesDisabled() and keys.attacker:IsControllableByAnyPlayer() and keys.attacker ~= self:GetParent() and keys.damage > self:GetAbility():GetSpecialValueFor("minimum_damage") and self:GetStackCount() > 0 then
		self:DecrementStackCount()
		
		for layer = 2, 5 do
			if self:GetStackCount() + 1 >= layer then
				ParticleManager:SetParticleControl(self.cloak_particle, layer, Vector(1, 0, 0))
			else
				ParticleManager:SetParticleControl(self.cloak_particle, layer, Vector(0, 0, 0))
			end
		end		
		
		return self:GetAbility():GetSpecialValueFor("damage_reduction") * (self:GetStackCount() + 1) * (-1)
	else
		return 0
	end
end

function modifier_imba_visage_gravekeepers_cloak:IsAura()						return true end
function modifier_imba_visage_gravekeepers_cloak:IsAuraActiveOnDeath() 			return false end

function modifier_imba_visage_gravekeepers_cloak:GetAuraRadius()				return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_visage_gravekeepers_cloak:GetAuraSearchFlags()			return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED end

function modifier_imba_visage_gravekeepers_cloak:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_visage_gravekeepers_cloak:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_visage_gravekeepers_cloak:GetModifierAura()				return "modifier_imba_visage_gravekeepers_cloak_secondary" end

function modifier_imba_visage_gravekeepers_cloak:GetAuraEntityReject(hTarget)	return self:GetCaster():PassivesDisabled() or not hTarget:GetOwner() or not hTarget:GetOwner() == self:GetCaster() or not string.find(hTarget:GetDebugName(), "npc_dota_visage_familiar") end

--------------------------------------------
-- GRAVEKEEPER'S CLOAK SECONDARY MODIFIER --
--------------------------------------------

function modifier_imba_visage_gravekeepers_cloak_secondary:OnCreated()
	self.damage_reduction				= self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.familiar_max_damage_reduction	= self:GetAbility():GetSpecialValueFor("familiar_max_damage_reduction")
end

function modifier_imba_visage_gravekeepers_cloak_secondary:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

-- "Unlike the damage reduction on the hero itself, this damage reduction has no minimum threshold."
function modifier_imba_visage_gravekeepers_cloak_secondary:GetModifierIncomingDamage_Percentage(keys)
	return math.min(self:GetCaster():GetModifierStackCount("modifier_imba_visage_gravekeepers_cloak", self:GetCaster()) * self.damage_reduction, self.familiar_max_damage_reduction) * (-1)
end

-------------------------------------------------
-- GRAVEKEEPER'S CLOAK SECONDARY ALLY MODIFIER --
-------------------------------------------------

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:IsPurgable()	return false end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:OnCreated()
	self.minimum_damage		= self:GetAbility():GetSpecialValueFor("minimum_damage")
	self.damage_reduction	= self:GetAbility():GetSpecialValueFor("damage_reduction")
	
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:OnRefresh()
	self:OnCreated()
end

-- If stacks reach 0, destroy the modifier (after a short delay so it can block a last damage instance) as it's no longer needed
function modifier_imba_visage_gravekeepers_cloak_secondary_ally:OnStackCountChanged(stackCount)
	if self:GetStackCount() <= 0 then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:OnIntervalThink()
	self:StartIntervalThink(-1)
	self:Destroy()
end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:GetModifierIncomingDamage_Percentage(keys)
	if keys.attacker:IsControllableByAnyPlayer() and keys.attacker ~= self:GetParent() and keys.damage > self.minimum_damage and self:GetStackCount() > 0 then
		self:DecrementStackCount()
		return self.damage_reduction * (self:GetStackCount() + 1) * (-1)
	else
		return 0
	end
end

function modifier_imba_visage_gravekeepers_cloak_secondary_ally:OnTooltip()
	return self.damage_reduction * self:GetStackCount()
end

--------------------------
-- STONE FORM SELF CAST --
--------------------------

function imba_visage_stone_form_self_cast:IsStealable()	return false end
function imba_visage_stone_form_self_cast:ProcsMagicStick() return false end

function imba_visage_stone_form_self_cast:GetAssociatedSecondaryAbilities()
	return "imba_visage_summon_familiars"
end

function imba_visage_stone_form_self_cast:GetIntrinsicModifierName()
	return "modifier_imba_visage_stone_form_self_cast"
end

-- "If the familiar is stunned, silenced, sleeping, hidden, feared or hypnotized, it cannot be made to enter Stone Form."
function imba_visage_stone_form_self_cast:OnSpellStart()
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)
	
	for _, ally in pairs(allies) do
		if string.find(ally:GetDebugName(), "npc_dota_visage_familiar") then
			local stone_form_ability = ally:FindAbilityByName("imba_visage_summon_familiars_stone_form")
			
			if stone_form_ability and stone_form_ability:IsCooldownReady() and
			not (ally:IsStunned() or ally:IsSilenced() or ally:IsNightmared() or ally:IsOutOfGame()) then
				stone_form_ability:CastAbility()
				break
			end
		end
	end
end

-----------------------------------
-- STONE FORM SELF CAST MODIFIER --
-----------------------------------

-- This tracks cooldowns of familiars and sets its own cooldown accordingly

function modifier_imba_visage_stone_form_self_cast:IsHidden()	return true end

function modifier_imba_visage_stone_form_self_cast:OnCreated()
	if not IsServer() then return end
	
	self.summon_familiars_ability	= self:GetCaster():FindAbilityByName("imba_visage_summon_familiars")
	self.lowest_cooldown			= 99
	self.stone_form_ability			= nil
	
	self:StartIntervalThink(0.1)
end

-- This block seems like it could be problematic with respect to memory usage
function modifier_imba_visage_stone_form_self_cast:OnIntervalThink()
	if self.summon_familiars_ability and self.summon_familiars_ability.familiar_table then
		self.bValidFamiliars = false

		for num = 1, #self.summon_familiars_ability.familiar_table do
			if self.summon_familiars_ability.familiar_table[num] and EntIndexToHScript(self.summon_familiars_ability.familiar_table[num]) and EntIndexToHScript(self.summon_familiars_ability.familiar_table[num]):IsAlive() then
				self.bValidFamiliars = true
				break
			end
		end
		
		if not self.bValidFamiliars then
			self:GetAbility():SetActivated(false)
			return
		else
			self:GetAbility():SetActivated(true)
		end
		
		self.lowest_cooldown	= 99
		
		local allies 			= FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false)
		
		for _, ally in pairs(allies) do
			if string.find(ally:GetDebugName(), "npc_dota_visage_familiar") then
				self.stone_form_ability = ally:FindAbilityByName("imba_visage_summon_familiars_stone_form")
				
				if self.stone_form_ability and self.stone_form_ability:GetCooldownTimeRemaining() <= self.lowest_cooldown then
					self.lowest_cooldown = self.stone_form_ability:GetCooldownTimeRemaining()
				end
			end
		end
		
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(self.lowest_cooldown)
	else
		self:GetAbility():SetActivated(false)
		self.summon_familiars_ability = self:GetCaster():FindAbilityByName("imba_visage_summon_familiars")
	end
end

----------------------
-- SUMMON FAMILIARS --
----------------------
-- TODO: familiars take 4 hp damage if all the damage is blocked by a right click (but still does 0 from magic???)
-- ...yeah I might just ignore this

function imba_visage_summon_familiars:GetAssociatedPrimaryAbilities()
	return "imba_visage_stone_form_self_cast"
end

function imba_visage_summon_familiars:OnUpgrade()
	local stone_form_self_cast_ability = self:GetCaster():FindAbilityByName("imba_visage_stone_form_self_cast")
	
	if stone_form_self_cast_ability then
		stone_form_self_cast_ability:SetLevel(self:GetLevel())
	end

	local become_familiar_ability = self:GetCaster():FindAbilityByName("imba_visage_become_familiar")
	
	if become_familiar_ability then
		become_familiar_ability:SetLevel(self:GetLevel())
	end	
end

function imba_visage_summon_familiars:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Visage.SummonFamiliars.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_visage" then
		if not self.responses then
			self.responses = 
			{
				"visage_visa_summon_03",
				"visage_visa_summon_04"
			}
		end
		
		if self.responses then
			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end
	end
	
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	
	-- Baseline familiars
	local unit_count = self:GetSpecialValueFor("initial_familiar_count")
	
	if self:GetCaster():GetLevel() >= 25 then
		unit_count = self:GetSpecialValueFor("familiars_at_level_25")
	end
	
	if self:GetCaster():HasScepter() then
		unit_count = unit_count + 1
	end
	
	-- Probably don't need one of these since I'm making more of them innate
	-- if self:GetCaster():HasTalent("") then
		-- unit_count = unit_count + 1
	-- end
	
	-- "The Familiars are summoned 200 range in front on Visage, with 120 range distance between the Familiars. Visage is always at the center of the line."
	-- Forward Vector: self:GetCaster():GetForwardVector() * 200
	-- Perpendicular Vector: self:GetCaster():GetRightVector() * (math.max(unit_count - 1, 0) * 120 * (-0.5))
	
	if self.familiar_table then
		for num = 1, #self.familiar_table do
			if self.familiar_table[num] and EntIndexToHScript(self.familiar_table[num]) and EntIndexToHScript(self.familiar_table[num]).IsNull and not EntIndexToHScript(self.familiar_table[num]):IsNull() and EntIndexToHScript(self.familiar_table[num]).IsAlive and EntIndexToHScript(self.familiar_table[num]):IsAlive() and EntIndexToHScript(self.familiar_table[num]).ForceKill then
				EntIndexToHScript(self.familiar_table[num]):ForceKill(false)
			end
		end
	end
	
	-- Empty out the table to insert new familiars
	self.familiar_table = {}

	-- I guess it's bad to initialize a variable multiple times so I'll do it outside the loop?
	
	local familiar 				= nil
	local spawn_location		= nil
	local stone_form_ability 	= nil
	local summon_particle		= nil

	for num = 1, unit_count do
		spawn_location = self:GetCaster():GetAbsOrigin() + 
		-- Front vector
		(self:GetCaster():GetForwardVector() * 200) + 
		-- Perpendicular vector (gets the left-most spot where the first familiar will spawn, then loops through the rest being 120 distance apart)
		(self:GetCaster():GetRightVector() * ((math.max(unit_count - 1, 0) * 120) * (-0.5 + ((math.max(num - 1, 0)) / (unit_count - 1)))))
	
		familiar = CreateUnitByName("npc_dota_visage_familiar"..math.min(self:GetLevel(), 3), spawn_location, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		
		summon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_summon_familiars.vpcf", PATTACH_ABSORIGIN, familiar)
		ParticleManager:ReleaseParticleIndex(summon_particle)
		
		familiar:AddNewModifier(self:GetCaster(), self, "modifier_imba_visage_summon_familiars", {})
		familiar:SetForwardVector(self:GetCaster():GetForwardVector())
		stone_form_ability = familiar:FindAbilityByName("imba_visage_summon_familiars_stone_form")
		
		if stone_form_ability then
			stone_form_ability:SetLevel(self:GetLevel())
		end
		
		-- Set ownership to Visage
		familiar:SetOwner(self:GetCaster())
		familiar:SetTeam(self:GetCaster():GetTeam())
		familiar:SetControllableByPlayer(self:GetCaster():GetPlayerID(), false)
		
		-- Set unit values
		familiar:SetBaseMaxHealth(self:GetSpecialValueFor("familiar_hp"))
		familiar:SetMaxHealth(self:GetSpecialValueFor("familiar_hp"))
		familiar:SetHealth(self:GetSpecialValueFor("familiar_hp"))
		
		familiar:SetPhysicalArmorBaseValue(self:GetSpecialValueFor("familiar_armor"))
		
		familiar:SetBaseMoveSpeed(self:GetTalentSpecialValueFor("familiar_speed"))
		
		familiar:SetBaseDamageMin(self:GetTalentSpecialValueFor("familiar_attack_damage"))
		familiar:SetBaseDamageMax(self:GetTalentSpecialValueFor("familiar_attack_damage"))
		
		table.insert(self.familiar_table, familiar:entindex())
	end
end
			
-------------------------------
-- SUMMON FAMILIARS MODIFIER --
-------------------------------

function modifier_imba_visage_summon_familiars:IsHidden()	return true end
function modifier_imba_visage_summon_familiars:IsPurgable()	return false end

function modifier_imba_visage_summon_familiars:OnCreated()
	self.unfeeling_status_resistance	= self:GetAbility():GetSpecialValueFor("unfeeling_status_resistance")
	self.petrifying_breath_duration		= self:GetAbility():GetSpecialValueFor("petrifying_breath_duration")
	
	if not IsServer() then return end
	
	self:StartIntervalThink(FrameTime())
end

-- IDK why this is a thing but vanilla familiars can push each other around so let's implement it here and make everything potentially stupidly laggy
function modifier_imba_visage_summon_familiars:OnIntervalThink()
	-- Rubick exception
	if not self:GetAbility() then
		self:StartIntervalThink(-1)
		self:GetParent():ForceKill(false)
	end
	
	local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():GetHullRadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
	
	for _, ally in pairs(allies) do
		if ally ~= self:GetParent() and string.find(ally:GetDebugName(), "npc_dota_visage_familiar") and not ally:IsMoving() then
			ally:SetAbsOrigin(GetGroundPosition(ally:GetAbsOrigin() + (ally:GetAbsOrigin() - self:GetParent():GetAbsOrigin()), ally))
		end
	end
end

function modifier_imba_visage_summon_familiars:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
	
	return state
end

function modifier_imba_visage_summon_familiars:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,	-- IMBAfication: Unfeeling Stone
		MODIFIER_EVENT_ON_ATTACK_LANDED					-- IMBAfication: Petrifying Breath
	}
	
	return decFuncs
end

function modifier_imba_visage_summon_familiars:GetModifierStatusResistanceStacking()
	return self.unfeeling_status_resistance
end

function modifier_imba_visage_summon_familiars:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_visage_summon_familiars_petrifying_breath", {duration = self.petrifying_breath_duration * (1 - keys.target:GetStatusResistance())})
	end
end

-------------------------------------------------
-- SUMMON FAMILIARS PETRIFYING BREATH MODIFIER --
-------------------------------------------------

function modifier_imba_visage_summon_familiars_petrifying_breath:IsPurgable()	return false end

function modifier_imba_visage_summon_familiars_petrifying_breath:OnCreated()
	if self:GetAbility() then
		self.petrifying_breath_reduction_per_stack	= self:GetAbility():GetSpecialValueFor("petrifying_breath_reduction_per_stack")
	else
		self.petrifying_breath_reduction_per_stack	= 0
	end
	
	if not IsServer() then return end
	
	self:IncrementStackCount()
end

function modifier_imba_visage_summon_familiars_petrifying_breath:OnRefresh()
	self:OnCreated()
end

function modifier_imba_visage_summon_familiars_petrifying_breath:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	
	return decFuncs
end

function modifier_imba_visage_summon_familiars_petrifying_breath:GetModifierMoveSpeedBonus_Constant()
	return self.petrifying_breath_reduction_per_stack * self:GetStackCount() * (-1)
end

function modifier_imba_visage_summon_familiars_petrifying_breath:GetModifierAttackSpeedBonus_Constant()
	return self.petrifying_breath_reduction_per_stack * self:GetStackCount() * (-1)
end

---------------------------------
-- SUMMON FAMILIARS STONE FORM --
---------------------------------

-- 0.55 seconds is default, so making the stun delay longer or shorter should change the speed of the cast animation
-- function imba_visage_summon_familiars_stone_form:GetPlaybackRateOverride()
	-- return self:GetSpecialValueFor("stun_delay") / 0.55
-- end

function imba_visage_summon_familiars_stone_form:ProcsMagicStick() return false end

function imba_visage_summon_familiars_stone_form:OnSpellStart()
	-- Remove this block when done with testing and the whole thing is properly ported over
	local summon_familiars_ability = self:GetCaster():GetOwner():FindAbilityByName("imba_visage_summon_familiars")
	
	if not summon_familiars_ability then
		self:SetHidden(true)
		return
	end
	--

	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_visage_summon_familiars_stone_form_root", {duration = self:GetSpecialValueFor("stun_delay")})
end

-----------------------------------------------
-- SUMMON FAMILIARS STONE FORM ROOT MODIFIER --
-----------------------------------------------

function modifier_imba_visage_summon_familiars_stone_form_root:IsPurgable()	return false end

function modifier_imba_visage_summon_familiars_stone_form_root:OnDestroy()
	-- Only apply the buff if the modifier lasts for its full duration (i.e. the familiar doesn't die mid-cast)
	if not IsServer() or not self:GetAbility() or self:GetRemainingTime() > 0 then return end
		
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_summon_familiars_stone_form_buff", {duration = self:GetAbility():GetSpecialValueFor("stone_duration")})
end

-- "During the effect delay, the Familiar is rooted and disarmed, being prevented from moving or attacking."
function modifier_imba_visage_summon_familiars_stone_form_root:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] 							= true,
		[MODIFIER_STATE_DISARMED]							= true,
		
		-- These aren't vanilla states but it seems to make sense cause you can otherwise spam the ability during the delay time and get a bunch of stuns in WTF mode
		[MODIFIER_STATE_SILENCED]							= true,
	}
	
	return state
end

-----------------------------------------------
-- SUMMON FAMILIARS STONE FORM BUFF MODIFIER --
-----------------------------------------------

function modifier_imba_visage_summon_familiars_stone_form_buff:GetEffectName()
	return "particles/units/heroes/hero_visage/visage_stone_form_area_energy.vpcf"
end

function modifier_imba_visage_summon_familiars_stone_form_buff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.hp_regen		= self:GetAbility():GetSpecialValueFor("hp_regen")
	
	if not IsServer() then return end

	self.stun_radius	= self:GetAbility():GetSpecialValueFor("stun_radius")
	self.stun_damage	= self:GetAbility():GetSpecialValueFor("stun_damage")
	self.stun_duration	= self:GetAbility():GetSpecialValueFor("stun_duration")
	self.stone_duration	= self:GetAbility():GetSpecialValueFor("stone_duration")
	
	self:GetParent():EmitSound("Visage_Familar.StoneForm.Cast")
	
	local stone_form_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_stone_form.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	self:AddParticle(stone_form_particle, false, false, -1, false, false)

	-- "Upon landing, trees in the surrounding area are destroyed"
	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius(), true)
	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local damageTable = {
		victim 			= nil,
		damage 			= self.stun_damage,
		damage_type		= self:GetAbility():GetAbilityDamageType(),
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetParent(),
		ability 		= self:GetAbility()
	}
	
	local stun_modifier = nil
	
	if #enemies >= 1 then
		self:GetParent():EmitSound("Visage_Familar.StoneForm.Stun")
	end
	
	-- "Stone Form first applies the debuff, then the damage."
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
	
		damageTable.victim	= enemy

		ApplyDamage(damageTable)
	end
	
	-- Initiate counter and tick down every interval
	self.counter = self.stone_duration
	
	self:StartIntervalThink(1)
end

-- Counter countdown
function modifier_imba_visage_summon_familiars_stone_form_buff:OnIntervalThink()
	self.counter = self.counter - 1

	-- CreateParticleForPlayer wasn't working for me
	self.stone_form_overhead_particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_visage/visage_stoneform_overhead_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
	ParticleManager:SetParticleControl(self.stone_form_overhead_particle, 1, Vector(0, self.counter, 0))
	ParticleManager:SetParticleControl(self.stone_form_overhead_particle, 2, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(self.stone_form_overhead_particle)
end

function modifier_imba_visage_summon_familiars_stone_form_buff:OnDestroy()
	local stone_form_transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_visage/visage_familiar_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(stone_form_transform_particle)
end

-- "After the effect delay, the Familiar's health regeneration is heavily boosted, it is turned invulnerable and it gets disabled."
function modifier_imba_visage_summon_familiars_stone_form_buff:CheckState()
	if not IsServer() then return end

	local state = {
		[MODIFIER_STATE_INVULNERABLE] 	= true,
		-- Using MODIFIER_STATE_STUNNED breaks the cast animation...gonna just override with a gesture
		[MODIFIER_STATE_STUNNED] 		= true
	}
	
	return state
end

function modifier_imba_visage_summon_familiars_stone_form_buff:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
		
	}
	
	return decFuncs
end

function modifier_imba_visage_summon_familiars_stone_form_buff:GetModifierConstantHealthRegen()
	return self.hp_regen
end

function modifier_imba_visage_summon_familiars_stone_form_buff:GetVisualZDelta()
	return 0
end

---------------------
-- BECOME FAMILIAR --
---------------------

function imba_visage_become_familiar:IsStealable()	return false end

function imba_visage_become_familiar:OnSpellStart()
	self:SetActivated(false)

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_visage_become_familiar_delay", {duration = self:GetSpecialValueFor("familiar_transform_delay")})
end

------------------------------------
-- BECOME FAMILIAR DELAY MODIFIER --
------------------------------------

function modifier_imba_visage_become_familiar_delay:IsPurgable()	return false end

function modifier_imba_visage_become_familiar_delay:GetEffectName() return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_dark.vpcf" end

function modifier_imba_visage_become_familiar_delay:OnCreated()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Visage_Familar.BellToll")
end

function modifier_imba_visage_become_familiar_delay:OnDestroy()
	if not IsServer() then return end

	local become_familiar_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_visage_become_familiar", self:GetCaster())
	
	if not become_familiar_modifier then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_visage_become_familiar", {})
	else
		become_familiar_modifier:Destroy()
	end
	
	self:GetAbility():SetActivated(true)
end

------------------------------
-- BECOME FAMILIAR MODIFIER --
------------------------------

function modifier_imba_visage_become_familiar:IsPurgable()	return false end

function modifier_imba_visage_become_familiar:OnCreated()
	self.familiar_speed					= self:GetAbility():GetTalentSpecialValueFor("familiar_speed")
	self.familiar_attack_damage			= self:GetAbility():GetSpecialValueFor("familiar_attack_damage")
	self.familiar_attack_rate			= self:GetAbility():GetSpecialValueFor("familiar_attack_rate")
	self.familiar_vision_daytime		= self:GetAbility():GetSpecialValueFor("familiar_vision_daytime")
	self.familiar_vision_nighttime		= self:GetAbility():GetSpecialValueFor("familiar_vision_nighttime")
	self.familiar_projectile_speed		= self:GetAbility():GetSpecialValueFor("familiar_projectile_speed")
	self.familiar_armor					= self:GetAbility():GetSpecialValueFor("familiar_armor")
	self.familiar_movement_turn_rate	= self:GetAbility():GetSpecialValueFor("familiar_movement_turn_rate")
	self.familiar_attack_range			= self:GetAbility():GetSpecialValueFor("familiar_attack_range")

	if not IsServer() then return end
	
	-- self.standard_projectile_speed	= self:GetParent():GetProjectileSpeed()

	-- self.damage_reducer				= self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) - self.familiar_attack_damage
	
	-- self:SetStackCount(self.damage_reducer)
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_visage_become_familiar:OnIntervalThink()
	-- self:SetStackCount(0)
	-- self.damage_reducer	 = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) - self.familiar_attack_damage
	-- self:SetStackCount(self.damage_reducer)

	if not GameRules:IsDaytime() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.familiar_vision_daytime, 0.1, false)
	else
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.familiar_vision_nighttime, 0.1, false)
	end
end

function modifier_imba_visage_become_familiar:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING]				= true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]	= true,
		
		[MODIFIER_STATE_MUTED]				= true,
	}
	
	return state
end

function modifier_imba_visage_become_familiar:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		-- MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		
		-- MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		-- MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE,
		-- MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
	
	return decFuncs
end

function modifier_imba_visage_become_familiar:GetModifierModelChange()
	-- return "models/heroes/visage/visage_familiar.vmdl"
	return "models/items/visage/immortal_familiar/immortal_familiar.vmdl"
end

function modifier_imba_visage_become_familiar:GetModifierProjectileName()
	-- return "particles/units/heroes/hero_visage/visage_familiar_base_attack.vpcf"
	return "particles/econ/items/visage/immortal_familiar/visage_immortal_ti5/visage_familiar_base_attack_ti5.vpcf"
end

-- function modifier_imba_visage_become_familiar:GetModifierProjectileSpeedBonus()
	-- if not IsServer() then return end

	-- return self.familiar_projectile_speed - self.standard_projectile_speed
-- end

-- function modifier_imba_visage_become_familiar:GetModifierBaseAttack_BonusDamage()
	-- return self:GetStackCount() * (-1)
-- end

-- function modifier_imba_visage_become_familiar:GetModifierAttackRangeOverride()
	-- return self.familiar_attack_range
-- end

function modifier_imba_visage_become_familiar:GetModifierMoveSpeedOverride()
	return self.familiar_speed
end

function modifier_imba_visage_become_familiar:GetModifierTurnRate_Override()
	return self.familiar_movement_turn_rate
end

-- Yeah this seems too strong lol
-- function modifier_imba_visage_become_familiar:GetModifierBaseAttackTimeConstant()
	-- return self.familiar_attack_rate
-- end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_visage_soul_assumption_extra_targets", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_visage_soul_assumption_charge_damage", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_visage_soul_assumption_extra_targets	= modifier_special_bonus_imba_visage_soul_assumption_extra_targets or class({})
modifier_special_bonus_imba_visage_soul_assumption_charge_damage	= modifier_special_bonus_imba_visage_soul_assumption_charge_damage or class({})
modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction	= modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction or class({})

function modifier_special_bonus_imba_visage_soul_assumption_extra_targets:IsHidden() 		return true end
function modifier_special_bonus_imba_visage_soul_assumption_extra_targets:IsPurgable()		return false end
function modifier_special_bonus_imba_visage_soul_assumption_extra_targets:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_visage_soul_assumption_charge_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_visage_soul_assumption_charge_damage:IsPurgable()		return false end
function modifier_special_bonus_imba_visage_soul_assumption_charge_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction:IsHidden() 		return true end
function modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction:IsPurgable()		return false end
function modifier_special_bonus_imba_visage_gravekeepers_cloak_cd_reduction:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed", "components/abilities/heroes/hero_visage", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed	= class({})

function modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed:IsHidden() 		return true end
function modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed:IsPurgable() 	return false end
function modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed:RemoveOnDeath() 	return false end

function imba_visage_summon_familiars:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_visage_summon_familiars_bonus_move_speed") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_visage_summon_familiars_bonus_move_speed"), "modifier_special_bonus_imba_visage_summon_familiars_bonus_move_speed", {})
	end
end
