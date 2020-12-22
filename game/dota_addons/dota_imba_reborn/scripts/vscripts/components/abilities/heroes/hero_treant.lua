-- Creator:
--	   AltiV, March 31st, 2020

LinkLuaModifier("modifier_imba_treant_natures_grasp_creation_thinker", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_damage", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_damage_bonus", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_grasp_latch_thinker", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_treant_leech_seed_autocast_handler", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_leech_seed", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_leech_seed_slow", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_leech_seed_enemy_target", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_treant_living_armor", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_treant_natures_guise", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_guise_tree_walking", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_guise_invis", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_natures_guise_active_cooldown", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_treant_overgrowth", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_treant_overgrowth_giant_ent", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

imba_treant_natures_grasp								= imba_treant_natures_grasp or class({})
modifier_imba_treant_natures_grasp_creation_thinker		= modifier_imba_treant_natures_grasp_creation_thinker or class({})
modifier_imba_treant_natures_grasp_damage				= modifier_imba_treant_natures_grasp_damage or class({})
modifier_imba_treant_natures_grasp_damage_bonus			= modifier_imba_treant_natures_grasp_damage_bonus or class({})
modifier_imba_treant_natures_grasp_latch_thinker		= modifier_imba_treant_natures_grasp_latch_thinker or class({})

imba_treant_leech_seed									= imba_treant_leech_seed or class({})
modifier_imba_treant_leech_seed_autocast_handler		= modifier_imba_treant_leech_seed_autocast_handler or class({})
modifier_imba_treant_leech_seed							= modifier_imba_treant_leech_seed or class({})
modifier_imba_treant_leech_seed_slow					= modifier_imba_treant_leech_seed_slow or class({})
modifier_imba_treant_leech_seed_enemy_target			= modifier_imba_treant_leech_seed_enemy_target or class({})

imba_treant_living_armor								= imba_treant_living_armor or class({})
modifier_imba_treant_living_armor						= modifier_imba_treant_living_armor or class({})

imba_treant_natures_guise								= imba_treant_natures_guise or class({})
modifier_imba_treant_natures_guise						= modifier_imba_treant_natures_guise or class({})
modifier_imba_treant_natures_guise_tree_walking			= modifier_imba_treant_natures_guise_tree_walking or class({})
modifier_imba_treant_natures_guise_invis				= modifier_imba_treant_natures_guise_invis or class({})
modifier_imba_treant_natures_guise_active_cooldown		= modifier_imba_treant_natures_guise_active_cooldown or class({})

imba_treant_overgrowth									= imba_treant_overgrowth or class({})
modifier_imba_treant_overgrowth							= modifier_imba_treant_overgrowth or class({})
modifier_imba_treant_overgrowth_giant_ent				= modifier_imba_treant_overgrowth_giant_ent or class({})

-------------------------------
-- IMBA_TREANT_NATURES_GRASP --
-------------------------------

function imba_treant_natures_grasp:OnSpellStart()
	local cast_position		= self:GetCaster():GetAbsOrigin()
	local cursor_position	= self:GetCursorPosition()
	-- Use this to "pair" all of the thickets in a cast, so they can all be set with the increased effects when any of them touch a tree
	local unique_string		= DoUniqueString(self:GetName())
	local thicket_thinker	= nil
	
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if cursor_position == cast_position then
		cursor_position = cursor_position + self:GetCaster():GetForwardVector()
	end
	
	if not self.thinker_tracker then
		self.thinker_tracker = {}
	end
	
	self:GetCaster():EmitSound("Hero_Treant.NaturesGrasp.Cast")
	
	-- "The thickets are placed with 175 distance from each other, with the first one starting 100 range in front of Treant Protector, resulting in a total length of 1500."
	for thicket = 1, math.floor((self:GetCastRange(cursor_position, self:GetCaster()) - 100) / self:GetSpecialValueFor("vine_spawn_interval")) do
		self:GetCaster():SetContextThink(DoUniqueString("grasp_thinker"), function()
			thicket_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_imba_treant_natures_grasp_creation_thinker", {
				duration		= self:GetSpecialValueFor("vines_duration"),
				unique_string	= unique_string
			}, GetGroundPosition(cast_position + (cursor_position - cast_position):Normalized() * (100 + (self:GetSpecialValueFor("vine_spawn_interval") * (thicket - 1))), nil), self:GetCaster():GetTeamNumber(), false)
			
			thicket_thinker:EmitSound("Hero_Treant.NaturesGrasp.Spawn")
			
			if thicket == math.floor((self:GetCastRange(cursor_position, self:GetCaster()) - 100) / self:GetSpecialValueFor("vine_spawn_interval")) then
				self.thinker_tracker[unique_string] = nil
			end
			
			return nil
		end, self:GetSpecialValueFor("creation_interval") * (thicket - 1))
	end
end

---------------------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GRASP_CREATION_THINKER --
---------------------------------------------------------

function modifier_imba_treant_natures_grasp_creation_thinker:IsHidden()		return true end
function modifier_imba_treant_natures_grasp_creation_thinker:IsPurgable()	return false end

function modifier_imba_treant_natures_grasp_creation_thinker:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	if not IsServer() then return end
	
	self.latch_range	= self:GetAbility():GetSpecialValueFor("latch_range")
	self.latch_vision	= self:GetAbility():GetSpecialValueFor("latch_vision") -- There's a latch vision value, but the ability doesn't seem to actually provide vision?
	self.damage_per_second	= self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
	self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
	
	-- IMBAfication: "It's Literally Macropyre"
	if self:GetCaster():GetLevel() >= 25 then
		self.damage_type	= DAMAGE_TYPE_PURE
	else
		self.damage_type	= self:GetAbility():GetAbilityDamageType()
	end
	
	self.unique_string	= keys.unique_string
	
	self.bramble_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_bramble_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.bramble_particle, 0, Vector(0, 0, 0))
	self:AddParticle(self.bramble_particle, false, false, -1, false, false)
	
	-- As long as any part of a tree is touching the radius (i.e. the entire tree doesn't have to be in the radius)
	-- (Is that standard?)
	if not self:GetAbility().thinker_tracker[self.unique_string] and GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self.latch_range, false) then
		self:GetAbility().thinker_tracker[self.unique_string] = true
		
		self.bTouchingTree = true
		
		for _, ent in pairs(Entities:FindAllByName("npc_dota_thinker")) do
			if ent:HasModifier(self:GetName()) and ent:FindModifierByName(self:GetName()).unique_string == self.unique_string and ent:FindModifierByName(self:GetName()).bramble_particle then
				ParticleManager:SetParticleControl(ent:FindModifierByName(self:GetName()).bramble_particle, 1, Vector(1, 0, 0))
				ent:FindModifierByName(self:GetName()).bTouchingTree = true
			end
		end
		
		ParticleManager:SetParticleControl(self.bramble_particle, 1, Vector(1, 0, 0))
	elseif self:GetAbility().thinker_tracker[self.unique_string] then
		ParticleManager:SetParticleControl(self.bramble_particle, 1, Vector(1, 0, 0))
		self.bTouchingTree = true
	end
end

function modifier_imba_treant_natures_grasp_creation_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Treant.NaturesGrasp.Destroy")
end

function modifier_imba_treant_natures_grasp_creation_thinker:IsAura()						return true end
function modifier_imba_treant_natures_grasp_creation_thinker:IsAuraActiveOnDeath() 			return false end

function modifier_imba_treant_natures_grasp_creation_thinker:GetAuraRadius()				return self.latch_range end

-- IMBAfication: "It's Literally Macropyre"
function modifier_imba_treant_natures_grasp_creation_thinker:GetAuraSearchFlags()
	if self:GetCaster():GetLevel() >= 25 then
		return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	else
		return DOTA_UNIT_TARGET_FLAG_NONE
	end
end

function modifier_imba_treant_natures_grasp_creation_thinker:GetAuraSearchTeam()			return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_treant_natures_grasp_creation_thinker:GetAuraSearchType()			return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP end

function modifier_imba_treant_natures_grasp_creation_thinker:GetModifierAura()
	if self.bTouchingTree then
		return "modifier_imba_treant_natures_grasp_damage_bonus"
	else
		return "modifier_imba_treant_natures_grasp_damage"
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GRASP_DAMAGE --
-----------------------------------------------

-- Going to use stack count for movement slow here specifically due to stuff like Morphling/Pugna/Rubick exceptions
function modifier_imba_treant_natures_grasp_damage:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self.damage_per_second	= self:GetAbility():GetTalentSpecialValueFor("damage_per_second")
		self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
		
		if self:GetCaster():GetLevel() >= 25 then
			self.damage_type	= DAMAGE_TYPE_PURE
		else
			self.damage_type	= self:GetAbility():GetAbilityDamageType()
		end
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_imba_treant_natures_grasp_creation_thinker") then
		self.damage_per_second	= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").damage_per_second
		self.movement_slow		= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").movement_slow
		self.damage_type		= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").damage_type
	else
		self:Destroy()
	end
	
	self.interval			= 0.25
	self.damage_per_tick	= self.damage_per_second * self.interval
	
	if not self:GetParent():IsHero() then
		self.damage_per_tick	= self.damage_per_tick * 0.5
	end
	
	self:SetStackCount(self.movement_slow * (-1))
	
	self:GetParent():EmitSound("Hero_Treant.NaturesGrasp.Damage")
	
	-- "Deals 7.5/10/12.5/15 (3.75/5/6.25/7.5 against creeps) damage in 0.25 second intervals, starting 0.25 seconds after the debuff is placed."
	self:StartIntervalThink(self.interval)
end

function modifier_imba_treant_natures_grasp_damage:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_imba_treant_natures_grasp_damage:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_treant_natures_grasp_damage:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():IsMagicImmune() then
		return self:GetStackCount()
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GRASP_DAMAGE_BONUS --
-----------------------------------------------------

-- Going to use stack count for movement slow here specifically due to stuff like Morphling/Pugna/Rubick exceptions
function modifier_imba_treant_natures_grasp_damage_bonus:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self.damage_per_second	= self:GetAbility():GetTalentSpecialValueFor("damage_per_second") * 1.5
		self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
		if self:GetCaster():GetLevel() >= 25 then
			self.damage_type	= DAMAGE_TYPE_PURE
		else
			self.damage_type	= self:GetAbility():GetAbilityDamageType()
		end
	elseif self:GetAuraOwner() and self:GetAuraOwner():HasModifier("modifier_imba_treant_natures_grasp_creation_thinker") then
		self.damage_per_second	= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").damage_per_second * 1.5
		self.movement_slow		= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").movement_slow
		self.damage_type		= self:GetAuraOwner():FindModifierByName("modifier_imba_treant_natures_grasp_creation_thinker").damage_type
	else
		self:Destroy()
	end
	
	self.interval			= 0.25
	self.damage_per_tick	= self.damage_per_second * self.interval
	
	if not self:GetParent():IsHero() then
		self.damage_per_tick	= self.damage_per_tick * 0.5
	end
	
	self:SetStackCount(self.movement_slow * (-1))
	
	self:GetParent():EmitSound("Hero_Treant.NaturesGrasp.Damage")
	
	-- "Deals 7.5/10/12.5/15 (3.75/5/6.25/7.5 against creeps) damage in 0.25 second intervals, starting 0.25 seconds after the debuff is placed."
	self:StartIntervalThink(self.interval)
end

function modifier_imba_treant_natures_grasp_damage_bonus:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_imba_treant_natures_grasp_damage_bonus:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_treant_natures_grasp_damage_bonus:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():IsMagicImmune() then
		return self:GetStackCount()
	end
end

------------------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GRASP_LATCH_THINKER --
------------------------------------------------------

-- Not sure what this is supposed to be used for but seems like I don't need it?

----------------------------
-- IMBA_TREANT_LEECH_SEED --
----------------------------

function imba_treant_leech_seed:GetIntrinsicModifierName()
	return "modifier_imba_treant_leech_seed_autocast_handler"
end

function imba_treant_leech_seed:GetBehavior()
	if self:GetCaster():GetModifierStackCount("modifier_imba_treant_leech_seed_autocast_handler", self:GetCaster()) == 0 then
		return tonumber(tostring(self.BaseClass.GetBehavior(self))) + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function imba_treant_leech_seed:GetCastRange(location, target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_treant_leech_seed_autocast_handler", self:GetCaster()) == 1 then
		return self:GetSpecialValueFor("remnants_cast_range")
	else
		return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
	end
end

function imba_treant_leech_seed:CastFilterResultTarget(target)
	if self:GetCaster():GetModifierStackCount("modifier_imba_treant_leech_seed_autocast_handler", self:GetCaster()) == 1 then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function imba_treant_leech_seed:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Treant.LeechSeed.Cast")
	
	local seed_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(seed_particle, 1, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1")))
	
	-- IMBAfication: Remnants of Leech Seed
	if self:GetAutoCastState() then
		local target = self:GetCursorTarget()
		
		if not target:TriggerSpellAbsorb(self) then
			target:EmitSound("Hero_Treant.LeechSeed.Target")
			
			ParticleManager:SetParticleControlEnt(seed_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			
			if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
				target:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_leech_seed", {duration = self:GetSpecialValueFor("duration") - FrameTime()})
			else
				target:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_leech_seed_enemy_target", {duration = self:GetSpecialValueFor("duration") - FrameTime()})
			end
		end
	else
		self:GetCaster():EmitSound("Hero_Treant.LeechSeed.Target")
		
		ParticleManager:SetParticleControlEnt(seed_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_leech_seed", {duration = self:GetSpecialValueFor("duration") - FrameTime()})
	end
	
	ParticleManager:ReleaseParticleIndex(seed_particle)
end

function imba_treant_leech_seed:OnProjectileHit_ExtraData(target, location, ExtraData)
	target:Heal(self:GetTalentSpecialValueFor("leech_damage") * self:GetSpecialValueFor("damage_interval"), self:GetCaster())
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, self:GetTalentSpecialValueFor("leech_damage") * self:GetSpecialValueFor("damage_interval"), nil)
end

------------------------------------------------------
-- MODIFIER_IMBA_TREANT_LEECH_SEED_AUTOCAST_HANDLER --
------------------------------------------------------

function modifier_imba_treant_leech_seed_autocast_handler:IsHidden() 		return true end
function modifier_imba_treant_leech_seed_autocast_handler:IsPurgable()		return false end
function modifier_imba_treant_leech_seed_autocast_handler:RemoveOnDeath()	return false end

-- Make the IMBAfication unit target logic be default
function modifier_imba_treant_leech_seed_autocast_handler:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self:GetAbility():ToggleAutoCast()
		self:SetStackCount(1)
	end
end

function modifier_imba_treant_leech_seed_autocast_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_imba_treant_leech_seed_autocast_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
end

-------------------------------------
-- MODIFIER_IMBA_TREANT_LEECH_SEED --
-------------------------------------

function modifier_imba_treant_leech_seed:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_interval	= self:GetAbility():GetSpecialValueFor("damage_interval")
	self.leech_damage		= self:GetAbility():GetTalentSpecialValueFor("leech_damage")
	self.movement_slow		= self:GetAbility():GetSpecialValueFor("movement_slow")
	self.slow_duration		= self:GetAbility():GetSpecialValueFor("slow_duration")
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	
	if not IsServer() then return end
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.damage_interval)
end

function modifier_imba_treant_leech_seed:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Treant.LeechSeed.Tick")

	self.enemy_heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	if #self.enemy_heroes >= 1 then
		self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.enemy_heroes[1])
		ParticleManager:ReleaseParticleIndex(self.damage_particle)
		self.damage_particle = nil
	
		ApplyDamage({
			victim 			= self.enemy_heroes[1],
			damage 			= self.leech_damage * self.damage_interval,
			damage_type		= self.damage_type,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
		
		self.enemy_heroes[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_treant_leech_seed_slow", {
			duration 		= self.slow_duration * (1 - self.enemy_heroes[1]:GetStatusResistance()),
			movement_slow	= self.movement_slow
		})
		
		ProjectileManager:CreateTrackingProjectile({
			EffectName			= "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
			Ability				= self:GetAbility(),
			-- Source				= self:GetCaster(),
			Source				= self.enemy_heroes[1],
			vSourceLoc			= self.enemy_heroes[1]:GetAbsOrigin(),
			Target				= self:GetCaster(),
			iMoveSpeed			= self.projectile_speed,
			flExpireTime		= nil,
			bDodgeable			= false,
			bIsAttack			= false,
			bReplaceExisting	= false,
			iSourceAttachment	= nil,
			bDrawsOnMinimap		= nil,
			bVisibleToEnemies	= true,
			bProvidesVision		= false,
			iVisionRadius		= nil,
			iVisionTeamNumber	= nil,
			ExtraData			= {}
		})
		
		self.enemy_heroes = nil
		
		return nil
	else
		self.enemy_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		if #self.enemy_creeps >= 1 then
			self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.enemy_creeps[1])
			ParticleManager:ReleaseParticleIndex(self.damage_particle)
			self.damage_particle = nil
			
			ApplyDamage({
				victim 			= self.enemy_creeps[1],
				damage 			= self.leech_damage * self.damage_interval,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			self.enemy_creeps[1]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_treant_leech_seed_slow", {
				duration		= self.slow_duration * (1 - self.enemy_creeps[1]:GetStatusResistance()),
				movement_slow	= self.movement_slow
			})
			
			ProjectileManager:CreateTrackingProjectile({
				EffectName			= "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
				Ability				= self:GetAbility(),
				-- Source				= self:GetCaster(),
				Source				= self.enemy_heroes[1],
				vSourceLoc			= self.enemy_heroes[1]:GetAbsOrigin(),
				Target				= self:GetCaster(),
				iMoveSpeed			= self.projectile_speed,
				flExpireTime		= nil,
				bDodgeable			= false,
				bIsAttack			= false,
				bReplaceExisting	= false,
				iSourceAttachment	= nil,
				bDrawsOnMinimap		= nil,
				bVisibleToEnemies	= true,
				bProvidesVision		= false,
				iVisionRadius		= nil,
				iVisionTeamNumber	= nil,
				ExtraData			= {}
			})
		end
		
		self.enemy_creeps = nil
	end
end

------------------------------------------
-- MODIFIER_IMBA_TREANT_LEECH_SEED_SLOW --
------------------------------------------

function modifier_imba_treant_leech_seed_slow:OnCreated(keys)
	if not IsServer() then return end
	
	self.movement_slow	= keys.movement_slow
	
	self:SetStackCount(self.movement_slow)
end

function modifier_imba_treant_leech_seed_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_imba_treant_leech_seed_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end

--------------------------------------------------
-- MODIFIER_IMBA_TREANT_LEECH_SEED_ENEMY_TARGET --
--------------------------------------------------

function modifier_imba_treant_leech_seed_enemy_target:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_interval	= self:GetAbility():GetSpecialValueFor("damage_interval")
	self.leech_damage		= self:GetAbility():GetTalentSpecialValueFor("leech_damage")
	self.movement_slow		= self:GetAbility():GetSpecialValueFor("movement_slow") * 0.5
	self.remnants_radius	= self:GetAbility():GetSpecialValueFor("remnants_radius")
	self.projectile_speed	= self:GetAbility():GetSpecialValueFor("projectile_speed")
	
	if not IsServer() then return end
	
	self.damage_type		= self:GetAbility():GetAbilityDamageType()
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.damage_interval)
end

function modifier_imba_treant_leech_seed_enemy_target:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Treant.LeechSeed.Tick")

	self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(self.damage_particle)
	self.damage_particle = nil
	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.leech_damage * self.damage_interval,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.remnants_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		ProjectileManager:CreateTrackingProjectile({
			EffectName			= "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
			Ability				= self:GetAbility(),
			Source				= unit,
			vSourceLoc			= unit:GetAbsOrigin(),
			Target				= self:GetCaster(),
			iMoveSpeed			= self.projectile_speed,
			flExpireTime		= nil,
			bDodgeable			= false,
			bIsAttack			= false,
			bReplaceExisting	= false,
			iSourceAttachment	= nil,
			bDrawsOnMinimap		= nil,
			bVisibleToEnemies	= true,
			bProvidesVision		= false,
			iVisionRadius		= nil,
			iVisionTeamNumber	= nil,
			ExtraData			= {}
		})
	end
end

------------------------------
-- IMBA_TREANT_LIVING_ARMOR --
------------------------------

function imba_treant_living_armor:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Treant.LivingArmor.Cast")

	if self:GetCaster():HasTalent("special_bonus_imba_treant_living_armor_aoe") then
		for _, ally in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, self:GetCaster():FindTalentValue("special_bonus_imba_treant_living_armor_aoe"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)) do
			ally:EmitSound("Hero_Treant.LivingArmor.Target")
			
			ally:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_living_armor", {duration = self:GetSpecialValueFor("duration")})
		end
	else
		if self:GetCursorTarget() then
			self:GetCursorTarget():EmitSound("Hero_Treant.LivingArmor.Target")
		
			self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_living_armor", {duration = self:GetSpecialValueFor("duration")})
		else
			local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			
			if #allies >= 1 then
				allies[1]:EmitSound("Hero_Treant.LivingArmor.Target")
			
				allies[1]:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_living_armor", {duration = self:GetSpecialValueFor("duration")})
			end
		end
	end
end

---------------------------------------
-- MODIFIER_IMBA_TREANT_LIVING_ARMOR --
---------------------------------------

function modifier_imba_treant_living_armor:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.total_heal		= self:GetAbility():GetTalentSpecialValueFor("total_heal")
	self.bonus_armor	= self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.duration		= self:GetAbility():GetSpecialValueFor("duration")
	self.remnants_damage_block_instances	= self:GetAbility():GetSpecialValueFor("remnants_damage_block_instances")
	self.remnants_damage_block				= self:GetAbility():GetSpecialValueFor("remnants_damage_block")
	
	self.heal_per_tick	= self.total_heal / self.duration
	
	if not IsServer() then return end
	
	self.armor_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.armor_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.armor_particle, false, false, -1, false, false)
	
	self:SetStackCount(self.remnants_damage_block_instances)
	
	self:StartIntervalThink(1)
end

function modifier_imba_treant_living_armor:OnRefresh()
	self:OnCreated()
end

function modifier_imba_treant_living_armor:OnIntervalThink()
	self:GetParent():Heal(self.heal_per_tick, self:GetCaster())
	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_per_tick, nil)
end

function modifier_imba_treant_living_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_imba_treant_living_armor:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_imba_treant_living_armor:GetModifierTotal_ConstantBlock(keys)
	if self:GetStackCount() >= 1 and keys.damage >= 5 and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		self:DecrementStackCount()
		return self.remnants_damage_block
	end
end

-------------------------------
-- IMBA_TREANT_NATURES_GUISE --
-------------------------------

function imba_treant_natures_guise:IsInnateAbility()	return true end

function imba_treant_natures_guise:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES
end

function imba_treant_natures_guise:GetCastPoint()
	return self:GetSpecialValueFor("cast_cast_point")
end

function imba_treant_natures_guise:GetCastRange(location, target)
	return self:GetSpecialValueFor("cast_cast_range")
end

function imba_treant_natures_guise:GetCooldown(level)
	return self:GetSpecialValueFor("cooldown_time")
end

function imba_treant_natures_guise:GetManaCost(level)
	return self:GetSpecialValueFor("cast_mana_cost")
end

function imba_treant_natures_guise:CastFilterResultTarget(target)
	if self:GetCaster():HasModifier("modifier_imba_treant_natures_guise_active_cooldown") then
		return UF_FAIL_CUSTOM
	elseif target == self:GetCaster() then
		return UF_FAIL_CUSTOM
	elseif GridNav and GridNav.IsNearbyTree and not GridNav:IsNearbyTree(target:GetAbsOrigin(), self:GetSpecialValueFor("radius"), false) then
		return UF_FAIL_CUSTOM
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function imba_treant_natures_guise:GetCustomCastErrorTarget(target)
	if self:GetCaster():HasModifier("modifier_imba_treant_natures_guise_active_cooldown") then
		return "#dota_cursor_cooldown_no_time"
	elseif target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	elseif GridNav and GridNav.IsNearbyTree and not GridNav:IsNearbyTree(target:GetAbsOrigin(), self:GetSpecialValueFor("radius"), false) then
		return "#dota_hud_error_cant_cast_on_units_not_near_trees"
	end
end

function imba_treant_natures_guise:GetIntrinsicModifierName()
	return "modifier_imba_treant_natures_guise"
end

function imba_treant_natures_guise:OnSpellStart()
	self:EndCooldown()

	self:GetCursorTarget():EmitSound("Hero_Treant.NaturesGuise.On")
	
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_naturesguise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCursorTarget())
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCursorTarget(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetCursorTarget(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCursorTarget():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_natures_guise_tree_walking", {})
	
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_natures_guise_active_cooldown", {duration = self:GetSpecialValueFor("cast_cooldown") * self:GetCaster():GetCooldownReduction()})
end

----------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GUISE --
----------------------------------------

function modifier_imba_treant_natures_guise:IsHidden()		return true end
function modifier_imba_treant_natures_guise:IsPurgable()	return false end
function modifier_imba_treant_natures_guise:RemoveOnDeath()	return false end

function modifier_imba_treant_natures_guise:CheckState()
	if not IsServer() then return nil end
	
	if self:GetAbility() then
		if self:GetAbility():IsCooldownReady() and not self:GetParent():HasModifier("modifier_imba_treant_natures_guise_tree_walking") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_treant_natures_guise_tree_walking", {})
		elseif not self:GetAbility():IsCooldownReady() and self:GetParent():HasModifier("modifier_imba_treant_natures_guise_tree_walking") then
			self:GetParent():RemoveModifierByName("modifier_imba_treant_natures_guise_tree_walking")
		end
	end
end

function modifier_imba_treant_natures_guise:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

-- "Reacts on any damage greater than 0 from any player (including allies and self) or Roshan."
function modifier_imba_treant_natures_guise:OnAttackLanded(keys)
	if self:GetAbility() and keys.target == self:GetParent() and keys.damage > 0 and (keys.attacker:GetPlayerOwnerID() or keys.attacker:IsRoshan()) then
		if self:GetParent():HasModifier("modifier_imba_treant_natures_guise_tree_walking") and not GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false) then
			-- Only play the sound if the damage instance removes the tree walking and starts the CD
			if self:GetAbility():IsCooldownReady() then
				self:GetParent():EmitSound("Hero_Treant.NaturesGuise.Off")
			end
		
			self:GetParent():RemoveModifierByName("modifier_imba_treant_natures_guise_tree_walking")
		end
		
		-- Start the cooldown time if Treant Protector is hit while he doesn't have tree walking or he is not near a tree (meaning he is not utilizing the tree walking)
		if not self:GetParent():HasModifier("modifier_imba_treant_natures_guise_tree_walking") or not GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), false) then
			self:GetAbility():StartCooldown(self:GetAbility():GetEffectiveCooldown(self:GetAbility():GetLevel()))
		end
	end
end

-----------------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GUISE_TREE_WALKING --
-----------------------------------------------------

function modifier_imba_treant_natures_guise_tree_walking:IsHidden() 	return self:GetStackCount() ~= 0 end
function modifier_imba_treant_natures_guise_tree_walking:IsPurgable()	return self:GetParent() ~= self:GetCaster() end

function modifier_imba_treant_natures_guise_tree_walking:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.radius			= self:GetAbility():GetSpecialValueFor("radius")
	self.grace_time		= self:GetAbility():GetSpecialValueFor("grace_time")
	self.regen_amp		= self:GetAbility():GetSpecialValueFor("regen_amp")
	self.movement_bonus	= self:GetAbility():GetSpecialValueFor("movement_bonus")
	
	if not IsServer() then return end
	
	self.invis_counter		= 0
	self.uninvis_counter	= 0
	self.interval			= FrameTime()
	
	self:SetStackCount(-1)
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)
end

function modifier_imba_treant_natures_guise_tree_walking:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() return end
	
	if GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self.radius, false) then	
		self:SetStackCount(0)
		self.uninvis_counter = 0
		
		if self:GetCaster():HasTalent("special_bonus_imba_treant_natures_guise_invisibility") and not self:GetParent():HasModifier("modifier_imba_treant_natures_guise_invis") then
			self.invis_counter = self.invis_counter + self.interval
			
			if self.invis_counter >= self.grace_time then
				self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_imba_treant_natures_guise_invis", {})
				
				self.invis_counter = 0
			end
		end
	else
		if self:GetParent() ~= self:GetCaster() then
			self:StartIntervalThink(-1)
			self:Destroy()
			return nil
		end
	
		self:SetStackCount(-1)
		self.invis_counter = 0
		
		if self:GetParent():HasModifier("modifier_imba_treant_natures_guise_invis") then
			self.uninvis_counter = self.uninvis_counter + self.interval
			
			if self.uninvis_counter >= self.grace_time then
				self:GetParent():RemoveModifierByName("modifier_imba_treant_natures_guise_invis")
				
				self.uninvis_counter = 0
			end
		end
	end
end

function modifier_imba_treant_natures_guise_tree_walking:OnDestroy()
	if not IsServer() then return end
	
	if self:GetParent():HasModifier("modifier_imba_treant_natures_guise_invis") then
		self:GetParent():RemoveModifierByName("modifier_imba_treant_natures_guise_invis")
	end
end


function modifier_imba_treant_natures_guise_tree_walking:CheckState()
	return {[MODIFIER_STATE_ALLOW_PATHING_TROUGH_TREES] = true}
end

function modifier_imba_treant_natures_guise_tree_walking:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE, -- I don't know how this one works
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		-- MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE -- This still doesn't work
		
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_imba_treant_natures_guise_tree_walking:GetModifierMoveSpeedBonus_Percentage()
	if self:GetStackCount() == 0 then
		return self.movement_bonus
	end
end

-- function modifier_imba_treant_natures_guise_tree_walking:GetModifierHealAmplify_PercentageSource(keys)

-- end

function modifier_imba_treant_natures_guise_tree_walking:GetModifierHealAmplify_PercentageTarget()
	if self:GetStackCount() == 0 then
		return self.regen_amp
	end
end

function modifier_imba_treant_natures_guise_tree_walking:GetModifierHPRegenAmplify_Percentage()
	if self:GetStackCount() == 0 then
		return self.regen_amp
	end
end

-- function modifier_imba_treant_natures_guise_tree_walking:GetModifierLifestealRegenAmplify_Percentage()

-- end

function modifier_imba_treant_natures_guise_tree_walking:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		self.invis_counter = 0
	end
end

----------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GUISE_INVIS --
----------------------------------------------

function modifier_imba_treant_natures_guise_invis:IsHidden() 	return true end
function modifier_imba_treant_natures_guise_invis:IsPurgable()	return false end

function modifier_imba_treant_natures_guise_invis:CheckState()
	return {[MODIFIER_STATE_INVISIBLE] = true}
end

function modifier_imba_treant_natures_guise_invis:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_imba_treant_natures_guise_invis:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		self:Destroy()
	end
end

function modifier_imba_treant_natures_guise_invis:GetModifierInvisibilityLevel()
	return 1
end

--------------------------------------------------------
-- MODIFIER_IMBA_TREANT_NATURES_GUISE_ACTIVE_COOLDOWN --
--------------------------------------------------------

function modifier_imba_treant_natures_guise_active_cooldown:IsDebuff()		return true end
function modifier_imba_treant_natures_guise_active_cooldown:IsPurgable()	return false end
function modifier_imba_treant_natures_guise_active_cooldown:RemoveOnDeath()	return false end

----------------------------
-- IMBA_TREANT_OVERGROWTH --
----------------------------

function imba_treant_overgrowth:GetCastRange(location, target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_treant_overgrowth:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.CastAnim")
	
	return true
end

function imba_treant_overgrowth:OnSpellStart()
	-- Using one variable to track total number of units hit (allows overlapping), and a table for the standard logic (cannot stack the damage/root/disarm modifier)
	local enemies_hit = 0
	local enemies_hit_table = {}
	
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.Cast")

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	local overgrowth_primary_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetTalentSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	enemies_hit = enemies_hit + #overgrowth_primary_enemies
	
	for _, enemy in pairs(overgrowth_primary_enemies) do
		-- "Forces a stop command onto the targets upon cast, so that their current move, attack and spell cast orders get canceled."
		enemy:Stop()
	
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_overgrowth", {duration = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
		
		enemies_hit_table[enemy:entindex()] = true
	end
	
	if self:GetCaster():HasScepter() then
		local overgrowth_eyes_enemies = nil
		
		-- npc_dota_treant_eyes - modifier_treant_eyes_in_the_forest - duration: -1.00, createtime: 156.34
		for _, ent in pairs(Entities:FindAllByName("npc_dota_treant_eyes")) do
			if ent:IsAlive() and ent:GetOwner() == self:GetCaster() then
				overgrowth_eyes_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), ent:GetAbsOrigin(), nil, self:GetTalentSpecialValueFor("eyes_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
				
				enemies_hit = enemies_hit + #overgrowth_eyes_enemies
				
				for _, enemy in pairs(overgrowth_eyes_enemies) do
					if not enemies_hit_table[enemy:entindex()] then
						-- "Forces a stop command onto the targets upon cast, so that their current move, attack and spell cast orders get canceled."
						enemy:Stop()
					
						enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_overgrowth", {duration = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
						
						enemies_hit_table[enemy:entindex()] = true
					end
				end
			end
		end
	end
	
	if enemies_hit >= 1 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_overgrowth_giant_ent", {
			duration	= self:GetSpecialValueFor("ent_size_duration"),
			enemies_hit	= enemies_hit,
		})
	end
end

-------------------------------------
-- MODIFIER_IMBA_TREANT_OVERGROWTH --
-------------------------------------

function modifier_imba_treant_overgrowth:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_imba_treant_overgrowth:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage	= self:GetAbility():GetTalentSpecialValueFor("damage")
	
	if not IsServer() then return end
	
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_imba_treant_overgrowth:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

-- "Roots and disarms the targets, preventing them from moving, attacking and casting certain mobility spells. "
function modifier_imba_treant_overgrowth:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
end

-----------------------------------------------
-- MODIFIER_IMBA_TREANT_OVERGROWTH_GIANT_ENT --
-----------------------------------------------

function modifier_imba_treant_overgrowth_giant_ent:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	self.ent_strength_per_unit		= self:GetAbility():GetSpecialValueFor("ent_strength_per_unit")
	self.ent_model_size_per_unit	= self:GetAbility():GetSpecialValueFor("ent_model_size_per_unit")

	if not IsServer() then return end
	
	self:SetStackCount(keys.enemies_hit)
	
	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_treant_overgrowth_giant_ent:OnRefresh(keys)
	if not self:GetAbility() then self:Destroy() return end

	self.ent_strength_per_unit		= self:GetAbility():GetSpecialValueFor("ent_strength_per_unit")
	self.ent_model_size_per_unit	= self:GetAbility():GetSpecialValueFor("ent_model_size_per_unit")
	
	if not IsServer() then return end
	
	if self:GetStackCount() < keys.enemies_hit then
		self:SetStackCount(keys.enemies_hit)
		
		if self:GetParent().CalculateStatBonus then
			self:GetParent():CalculateStatBonus(true)
		end
	end
end

function modifier_imba_treant_overgrowth_giant_ent:OnDestroy()
	if not IsServer() then return end
	
	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_treant_overgrowth_giant_ent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_imba_treant_overgrowth_giant_ent:GetModifierBonusStats_Strength()
	return self:GetStackCount() * self.ent_strength_per_unit
end

function modifier_imba_treant_overgrowth_giant_ent:GetModifierModelScale()
	return self:GetStackCount() * self.ent_model_size_per_unit
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_treant_natures_guise_invisibility", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_treant_natures_grasp_damage", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_treant_living_armor_heal", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_treant_leech_seed_heal", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_treant_living_armor_aoe", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_treant_overgrowth_damage", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_treant_natures_guise_invisibility		= modifier_special_bonus_imba_treant_natures_guise_invisibility or class({})
modifier_special_bonus_imba_treant_natures_grasp_damage				= modifier_special_bonus_imba_treant_natures_grasp_damage or class({})
modifier_special_bonus_imba_treant_living_armor_heal				= modifier_special_bonus_imba_treant_living_armor_heal or class({})
modifier_special_bonus_imba_treant_leech_seed_heal					= modifier_special_bonus_imba_treant_leech_seed_heal or class({})
modifier_special_bonus_imba_treant_living_armor_aoe					= modifier_special_bonus_imba_treant_living_armor_aoe or class({})
modifier_special_bonus_imba_treant_overgrowth_damage				= modifier_special_bonus_imba_treant_overgrowth_damage or class({})

function modifier_special_bonus_imba_treant_natures_guise_invisibility:IsHidden() 		return true end
function modifier_special_bonus_imba_treant_natures_guise_invisibility:IsPurgable() 	return false end
function modifier_special_bonus_imba_treant_natures_guise_invisibility:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_treant_natures_guise_invisibility:OnCreated()
	if not IsServer() then return end
	
	if self:GetParent():HasAbility("imba_treant_natures_guise") and self:GetParent():HasModifier("modifier_imba_treant_natures_guise_tree_walking") and GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self:GetParent():FindAbilityByName("imba_treant_natures_guise"):GetSpecialValueFor("radius"), false) then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("imba_treant_natures_guise"), "modifier_imba_treant_natures_guise_invis", {})
	end
end

function modifier_special_bonus_imba_treant_natures_grasp_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_treant_natures_grasp_damage:IsPurgable() 		return false end
function modifier_special_bonus_imba_treant_natures_grasp_damage:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_treant_living_armor_heal:IsHidden() 		return true end
function modifier_special_bonus_imba_treant_living_armor_heal:IsPurgable() 		return false end
function modifier_special_bonus_imba_treant_living_armor_heal:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_treant_leech_seed_heal:IsHidden() 			return true end
function modifier_special_bonus_imba_treant_leech_seed_heal:IsPurgable() 		return false end
function modifier_special_bonus_imba_treant_leech_seed_heal:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_treant_living_armor_aoe:IsHidden() 		return true end
function modifier_special_bonus_imba_treant_living_armor_aoe:IsPurgable() 		return false end
function modifier_special_bonus_imba_treant_living_armor_aoe:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_treant_overgrowth_damage:IsHidden() 		return true end
function modifier_special_bonus_imba_treant_overgrowth_damage:IsPurgable() 		return false end
function modifier_special_bonus_imba_treant_overgrowth_damage:RemoveOnDeath() 	return false end

function imba_treant_natures_grasp:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_treant_natures_grasp_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_natures_grasp_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_natures_grasp_damage"), "modifier_special_bonus_imba_treant_natures_grasp_damage", {})
	end
end

function imba_treant_leech_seed:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_treant_leech_seed_heal") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_leech_seed_heal") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_leech_seed_heal"), "modifier_special_bonus_imba_treant_leech_seed_heal", {})
	end
end

function imba_treant_living_armor:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_treant_living_armor_heal") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_living_armor_heal") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_living_armor_heal"), "modifier_special_bonus_imba_treant_living_armor_heal", {})
	end
	
	if self:GetCaster():HasTalent("special_bonus_imba_treant_living_armor_aoe") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_living_armor_aoe") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_living_armor_aoe"), "modifier_special_bonus_imba_treant_living_armor_aoe", {})
	end
end

function imba_treant_natures_guise:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_treant_natures_guise_invisibility") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_natures_guise_invisibility") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_natures_guise_invisibility"), "modifier_special_bonus_imba_treant_natures_guise_invisibility", {})
	end
end

function imba_treant_overgrowth:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_treant_overgrowth_damage") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_treant_overgrowth_damage") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_treant_overgrowth_damage"), "modifier_special_bonus_imba_treant_overgrowth_damage", {})
	end
end
