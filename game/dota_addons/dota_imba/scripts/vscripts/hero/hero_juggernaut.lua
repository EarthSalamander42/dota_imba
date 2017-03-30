--[[	Author: Yahnich
		Date: 28.03.2017	]]
CreateEmptyTalents('juggernaut')

-- JUGGERNAUT SPECIFIC UTILITY FUNCTIONS --
function IsTotem(unit) -- have to do it like this because server and client side classes are different thanks valve
	return ( not unit:HasMovementCapability() )
end

-- BLADE FURY --
imba_juggernaut_blade_fury = class({})

function imba_juggernaut_blade_fury:GetCastRange()
	return self:GetTalentSpecialValueFor("effect_radius")
end

function imba_juggernaut_blade_fury:GetCooldown(nLevel)
	local cooldown = self.BaseClass.GetCooldown( self, nLevel ) + self:GetCaster():FindTalentValue("special_bonus_imba_juggernaut_7")
	return cooldown
end

function imba_juggernaut_blade_fury:OnSpellStart()
	local caster = self:GetCaster()
	caster:Purge(false, true, false, false, false)	
	caster:AddNewModifier(caster, self, "modifier_imba_juggernaut_blade_fury", {duration = self:GetSpecialValueFor("duration")})

	-- Play cast lines
	local rand = RandomInt(2, 9)
	if (rand >= 2 and rand <= 3) or (rand >= 5 and rand <= 9) then
		caster:EmitSound("juggernaut_jug_ability_bladefury_0"..rand)
	elseif rand >= 10 and rand <= 18 then
		caster:EmitSound("Imba.JuggernautBladeFury"..rand)
	end
end

LinkLuaModifier("modifier_imba_juggernaut_blade_fury", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_fury = class({})

function modifier_imba_juggernaut_blade_fury:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.dps = self.ability:GetTalentSpecialValueFor("damage_per_sec")
	self.evasion = self.ability:GetTalentSpecialValueFor("evasion")
	self.radius = self.ability:GetTalentSpecialValueFor("effect_radius")
	self.tick = self.ability:GetTalentSpecialValueFor("damage_tick")
	self.caster = self:GetCaster()
	if IsServer() then
		self.blade_fury_spin_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.blade_fury_spin_pfx, 5, Vector(self.radius * 1.2, 0, 0))
		self:StartIntervalThink(self.tick)
		self.caster:EmitSound("Hero_Juggernaut.BladeFuryStart")
		StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
	end
end

function modifier_imba_juggernaut_blade_fury:OnIntervalThink()
	local damage = self.dps * self.tick
	local caster_loc = self.caster:GetAbsOrigin()
	-- Iterate through nearby enemies
	local furyEnemies = FindUnitsInRadius(self.caster:GetTeamNumber(), caster_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(furyEnemies) do	
		-- Play hit sound
		enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
		-- Play hit particle
		local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(slash_pfx)
		if self.caster:HasTalent("special_bonus_imba_juggernaut_6") then
			self.bladedance = self.bladedance or self.caster:FindAbilityByName("imba_juggernaut_blade_dance")
			self.prng = self.prng or 0
			local crit = self.bladedance:GetTalentSpecialValueFor("crit_damage") / 100
			local chance = self.bladedance:GetTalentSpecialValueFor("crit_chance")
			print(chance)
			if RollPercentage( chance + self.prng - math.floor( (chance - 5)/chance ) ) then
				self.prng = 0
				local crit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(crit_pfx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(crit_pfx)

				self:GetParent():EmitSound("Hero_Juggernaut.BladeDance")
				damage = damage * crit
				SendOverheadEventMessage(self.caster, OVERHEAD_ALERT_CRITICAL, enemy, damage, self.caster)
			else
				self.prng = self.prng + 1
			end
		end
		-- Deal damage
		ApplyDamage({attacker = self.caster, victim = enemy, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

function modifier_imba_juggernaut_blade_fury:OnRemoved()
	if IsServer() then
		self.caster:StopSound("Hero_Juggernaut.BladeFuryStart")
		self.caster:EmitSound("Hero_Juggernaut.BladeFuryStop")
		if self.caster:HasModifier("modifier_imba_omni_slash_caster") then
			StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
		else
			EndAnimation(self.caster)
		end
		ParticleManager:DestroyParticle(self.blade_fury_spin_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx)
		self.blade_fury_spin_pfx = nil
	end
end

function modifier_imba_juggernaut_blade_fury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end

function modifier_imba_juggernaut_blade_fury:GetModifierEvasion_Constant()
	return self.evasion
end


-- HEALING WARD --
imba_juggernaut_healing_ward = class({})

function imba_juggernaut_healing_ward:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	
	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")

	-- Spawn the Healing Ward
	local healing_ward = CreateUnitByName("npc_imba_juggernaut_healing_ward", targetPoint, true, caster, caster, caster:GetTeam())

	-- Make the ward immediately follow its caster
	healing_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	Timers:CreateTimer(0.1, function()
		healing_ward:MoveToNPC(caster)
	end)

	-- Increase the ward's health, if appropriate
	SetCreatureHealth(healing_ward, self:GetTalentSpecialValueFor("health"), true)

	-- Prevent nearby units from getting stuck
	ResolveNPCPositions(healing_ward:GetAbsOrigin(), healing_ward:GetHullRadius() + healing_ward:GetCollisionPadding())
	
	-- Apply the Healing Ward duration modifier
	healing_ward:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetTalentSpecialValueFor("duration")})
	-- Grant the Healing Ward its abilities
	healing_ward:AddAbility("imba_juggernaut_healing_ward_passive"):SetLevel( self:GetLevel() )
end



imba_juggernaut_healing_ward_passive = class({})

function imba_juggernaut_healing_ward_passive:GetIntrinsicModifierName()
	return "modifier_imba_juggernaut_healing_ward_passive"
end

function imba_juggernaut_healing_ward_passive:CastFilterResult()
	if not IsTotem(self:GetCaster()) then
		return UF_SUCCESS
	else
		return UF_FAIL_CUSTOM
	end
end

function imba_juggernaut_healing_ward_passive:GetCustomCastError()
	return "Already totem"
end

function imba_juggernaut_healing_ward_passive:OnSpellStart()
	local caster = self:GetCaster()
	local targetPoint = self:GetCursorPosition()
	-- Play cast sound
	caster:EmitSound("Hero_Juggernaut.HealingWard.Cast")
	
	-- Transform ward into totem
	caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
	caster:SetModel("models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl")
	SetCreatureHealth(caster, self:GetTalentSpecialValueFor("health_totem"), true)
	caster:FindModifierByName("modifier_imba_juggernaut_healing_ward_passive"):ForceRefresh()
end

LinkLuaModifier("modifier_imba_juggernaut_healing_ward_passive", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_healing_ward_passive = class({})

function modifier_imba_juggernaut_healing_ward_passive:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsTotem(self:GetParent()) then
		self.radius = self.ability:GetTalentSpecialValueFor("heal_radius_totem")
	else
		self.radius = self.ability:GetTalentSpecialValueFor("heal_radius")
	end
	
	if IsServer() then
		-- Play spawn particle
		local eruption_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControl(eruption_pfx, 0, self.caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(eruption_pfx)

		-- Attach ambient particle
		self.caster.healing_ward_ambient_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.caster.healing_ward_ambient_pfx, 0, self.caster:GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(self.caster.healing_ward_ambient_pfx, 1, Vector(self.ability:GetTalentSpecialValueFor("heal_radius"), 1, 1))
		ParticleManager:SetParticleControlEnt(self.caster.healing_ward_ambient_pfx, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		
		EmitSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
		self:StartIntervalThink(0.1) -- anti valve garbage measures
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnRefresh()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsTotem(self:GetParent()) then
		self.radius = self.ability:GetTalentSpecialValueFor("heal_radius_totem")
		
	else
		self.radius = self.ability:GetTalentSpecialValueFor("heal_radius")
	end
	if IsServer() then
		-- Play spawn particle
		local eruption_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_healing_ward/juggernaut_healing_ward_eruption_dc.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControl(eruption_pfx, 0, self.caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(eruption_pfx)

		-- Attach ambient particle
		ParticleManager:DestroyParticle(self.caster.healing_ward_ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.caster.healing_ward_ambient_pfx)
		self.caster.healing_ward_ambient_pfx = nil
		self.caster.healing_ward_ambient_pfx = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_healing_ward/juggernaut_healing_ward_dc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl(self.caster.healing_ward_ambient_pfx, 0, self.caster:GetAbsOrigin() + Vector(0, 0, 100))
		ParticleManager:SetParticleControl(self.caster.healing_ward_ambient_pfx, 1, Vector(self.ability:GetTalentSpecialValueFor("heal_radius_totem"), 1, 1))
		ParticleManager:SetParticleControlEnt(self.caster.healing_ward_ambient_pfx, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnIntervalThink()
	if IsTotem(self:GetParent()) and self:GetParent():GetModelName() == "models/heroes/juggernaut/jugg_healing_ward.vmdl" then
		self:GetParent():SetModel("models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl")
	elseif not IsTotem(self:GetParent()) and self:GetParent():GetModelName() == "models/items/juggernaut/ward/dc_wardupate/dc_wardupate.vmdl" then
		self:GetParent():SetModel("models/heroes/juggernaut/jugg_healing_ward.vmdl")
	end
end

function modifier_imba_juggernaut_healing_ward_passive:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetModifierAura()
	return "modifier_imba_juggernaut_healing_ward_aura"
end

function modifier_imba_juggernaut_healing_ward_passive:GetAuraEntityReject(hEntity)
	if hEntity == self:GetParent() then return true end
	return false
end


--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_imba_juggernaut_healing_ward_passive:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------
function modifier_imba_juggernaut_healing_ward_passive:IsPurgable()
    return false
end

function modifier_imba_juggernaut_healing_ward_passive:CheckState()
    local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
	}
	return state
end

function modifier_imba_juggernaut_healing_ward_passive:DeclareFunctions()
	funcs = { 
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_imba_juggernaut_healing_ward_passive:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_imba_juggernaut_healing_ward_passive:OnAttackLanded(params) -- health handling
	if params.target == self:GetParent() then
		local damage = 1
		if params.attacker:IsRealHero() or params.attacker:IsTower() then
			damage = 3
		end
		if self:GetParent():GetHealth() > damage then
			self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
		else
			self:GetParent():Kill(nil, params.attacker)
		end
	end
end

function modifier_imba_juggernaut_healing_ward_passive:OnDeath(params) -- modifier kill instadeletes thanks valve
	if params.unit == self:GetParent() then
		ParticleManager:DestroyParticle(self.caster.healing_ward_ambient_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.caster.healing_ward_ambient_pfx)
		self.caster.healing_ward_ambient_pfx = nil
		StopSoundOn("Hero_Juggernaut.HealingWard.Loop", self:GetParent())
	end
end

LinkLuaModifier("modifier_imba_juggernaut_healing_ward_aura", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_healing_ward_aura = class({})

function modifier_imba_juggernaut_healing_ward_aura:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsTotem(self.caster) then
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec_totem")
	else
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec")
	end
end

function modifier_imba_juggernaut_healing_ward_aura:OnRefresh()
	if IsTotem(self.caster) then
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec_totem")
	else
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec")
	end
end

function modifier_imba_juggernaut_healing_ward_aura:GetEffectName()
	return "particles/units/heroes/hero_juggernaut/juggernaut_ward_heal.vpcf"
end

function modifier_imba_juggernaut_healing_ward_aura:DeclareFunctions()
	funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE }
	return funcs
end

function modifier_imba_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage()
	return self.healing
end


-- BLADE DANCE --
imba_juggernaut_blade_dance = class({})

function imba_juggernaut_blade_dance:GetIntrinsicModifierName()
	return "modifier_imba_juggernaut_blade_dance_passive"
end

function imba_juggernaut_blade_dance:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	self.endTarget = target
	caster:AddNewModifier(caster, self, "modifier_imba_juggernaut_blade_dance_empowered_slice", {})
end

function imba_juggernaut_blade_dance:GetCastRange()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return self:GetTalentSpecialValueFor("active_distance")
	end
	return 0
end

function imba_juggernaut_blade_dance:GetCooldown()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return self:GetTalentSpecialValueFor("active_cooldown")
	end
	return 0
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_empowered_slice", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_HORIZONTAL)
modifier_imba_juggernaut_blade_dance_empowered_slice = class({})

function modifier_imba_juggernaut_blade_dance_empowered_slice:IsHidden()
	return true
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:OnCreated( )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
		EmitSoundOn("Hero_Juggernaut.PreAttack", self:GetParent())
		EmitSoundOn("Hero_EarthShaker.Attack", self:GetParent())
		self.speed = self.ability:GetTalentSpecialValueFor("active_speed")
		self.endTarget = self.ability.endTarget
		self.distance_left = ( self.endTarget:GetAbsOrigin() - self.caster:GetAbsOrigin() ):Length2D()
		self.direction = ( self.endTarget:GetAbsOrigin() - self.caster:GetAbsOrigin() ):Normalized()
		self.traveled = 0
		self:StartIntervalThink(self.caster:GetSecondsPerAttack()/2)
		self.wind_dance = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_wind_dance")
		self:SeekAndDestroy()
	end
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:SeekAndDestroy( )
	local sliceEnemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(sliceEnemies) do	
		-- Play hit sound
		enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
		-- Play hit particle
		local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(slash_pfx)
		-- Deal damage
		self.caster:PerformAttack(enemy, true, true, true, true, false, false, true)
		self.wind_dance:DecrementStackCount()
	end
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:OnIntervalThink( )
	self:SeekAndDestroy()
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		if self.distance_left > 100 and not self.wind_dance:IsNull() and self.wind_dance:GetStackCount() > 0 then
			local oldPos = self.caster:GetAbsOrigin()
			self.direction = ( self.endTarget:GetAbsOrigin() - self.caster:GetAbsOrigin() ):Normalized()
			self.caster:SetAbsOrigin(self.caster:GetAbsOrigin() + self.direction * self.speed * dt)
			self.distance_left = ( self.endTarget:GetAbsOrigin() - self.caster:GetAbsOrigin() ):Length2D()
			local sliceFX = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_omnislash/dc_juggernaut_omni_slash_rope.vpcf", PATTACH_ABSORIGIN  , self.caster)
			ParticleManager:SetParticleControl(sliceFX, 0, oldPos)
			ParticleManager:SetParticleControl(sliceFX, 2, oldPos)
			ParticleManager:SetParticleControl(sliceFX, 3, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(sliceFX)
		else
			self.caster:InterruptMotionControllers(true)
			FindClearSpaceForUnit(self.caster, self.endTarget:GetAbsOrigin() - self.endTarget:GetForwardVector()*150, true)
			self.caster:MoveToTargetToAttack(self.endTarget)
			self.caster:SetForwardVector(self.endTarget:GetForwardVector())
			self:Destroy()
		end       
	end
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:CheckState()
    local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:StatusEffectPriority()
	return 20
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end


LinkLuaModifier("modifier_imba_juggernaut_blade_dance_passive", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_passive = class({})

function modifier_imba_juggernaut_blade_dance_passive:IsHidden()
	return true
end

function modifier_imba_juggernaut_blade_dance_passive:OnCreated()
	self:StartIntervalThink(1)
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self.crit = self.ability:GetTalentSpecialValueFor("crit_damage")
	self.chance = self.ability:GetTalentSpecialValueFor("crit_chance")
	self.critProc = false
	self.prng = 0
	-- Turn unit target passive, tooltip purposes
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
end

function modifier_imba_juggernaut_blade_dance_passive:OnRefresh()
	self.crit = self.ability:GetTalentSpecialValueFor("crit_damage")
	self.chance = self.ability:GetTalentSpecialValueFor("crit_chance")
end

function modifier_imba_juggernaut_blade_dance_passive:OnIntervalThink() -- account for talents being skilled
	self:ForceRefresh()
end

function modifier_imba_juggernaut_blade_dance_passive:DeclareFunctions()
	funcs = {
				MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
				MODIFIER_EVENT_ON_ATTACK_LANDED
			}
	return funcs
end

if IsServer() then
	function modifier_imba_juggernaut_blade_dance_passive:GetModifierPreAttack_CriticalStrike(params)
		if self:GetParent():PassivesDisabled() then return nil end
		if RollPercentage( self.chance + self.prng - math.floor( (self.chance - 5)/self.chance ) ) then
			self.prng = 0
			local crit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(crit_pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(crit_pfx)
			
			self.critProc = true
			-- Play crit sound
			self:GetParent():EmitSound("Hero_Juggernaut.BladeDance")
			return self.crit
		else
			self.critProc = false
			self.prng = self.prng + 1
			return nil
		end
	end

	function modifier_imba_juggernaut_blade_dance_passive:OnAttackLanded(params)
		if params.attacker == self:GetParent() then
			self:HandleWindDance(self.critProc)
			self.critProc = false
		end
	end
end

function modifier_imba_juggernaut_blade_dance_passive:HandleWindDance(bCrit)
	if self:GetCaster():IsRealHero() then
		local wind_dance = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_wind_dance")
		if bCrit then
			if not wind_dance then wind_dance = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_wind_dance", {duration = self.ability:GetTalentSpecialValueFor("bonus_duration")}) end
			wind_dance:ForceRefresh()
		elseif wind_dance then
			wind_dance:SetDuration(wind_dance:GetDuration(), true) -- does not roll refresh
		end
	end
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_wind_dance", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_wind_dance = class({})

function modifier_imba_juggernaut_blade_dance_wind_dance:OnCreated()
	self.agi = self:GetAbility():GetTalentSpecialValueFor("bonus_agi")
	self.ms = self:GetAbility():GetTalentSpecialValueFor("bonus_ms")
	
	self:StartIntervalThink(1)
end

function modifier_imba_juggernaut_blade_dance_wind_dance:OnRefresh()
	self.agi = self:GetAbility():GetTalentSpecialValueFor("bonus_agi")
	self.ms = self:GetAbility():GetTalentSpecialValueFor("bonus_ms")
	if IsServer() then
		self:IncrementStackCount()
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_imba_juggernaut_blade_dance_wind_dance:OnStackCountChanged()
	local serverCheck = 0
	if IsServer() then -- why? ? ? ? ?
		self:GetParent():CalculateStatBonus()
		serverCheck = 1
	end
	if self:GetStackCount() + serverCheck >= self:GetAbility():GetTalentSpecialValueFor("active_min_stacks") and self:GetAbility():GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE then -- inject function calls clientside and serverside
		-- Change behavior
		self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
		self:GetAbility():GetBehavior()
		self:GetAbility():GetCastRange(self:GetCaster(), self:GetCaster():GetAbsOrigin())
		self:GetAbility():GetCooldown()
	elseif self:GetStackCount() + serverCheck < self:GetAbility():GetTalentSpecialValueFor("active_min_stacks") and self:GetAbility():GetBehavior() == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE then
		self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
		self:GetAbility():GetBehavior()
		self:GetAbility():GetCastRange(self:GetCaster(), self:GetCaster():GetAbsOrigin())
		self:GetAbility():GetCooldown()
	end
end

function modifier_imba_juggernaut_blade_dance_wind_dance:OnRemoved()
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
	self:GetAbility():GetCastRange(self:GetCaster(), self:GetCaster():GetAbsOrigin())
	self:GetAbility():GetCooldown()
end

function modifier_imba_juggernaut_blade_dance_wind_dance:DeclareFunctions()
	funcs = {
				MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
			}
	return funcs
end

function modifier_imba_juggernaut_blade_dance_wind_dance:GetModifierMoveSpeedBonus_Percentage()
	return self.ms * self:GetStackCount()
end

function modifier_imba_juggernaut_blade_dance_wind_dance:GetModifierBonusStats_Agility()
	return self.agi * self:GetStackCount()
end


-- OMNI SLASH --
imba_juggernaut_omni_slash = class({})

function imba_juggernaut_omni_slash:GetIntrinsicModifierName()
	return	"modifier_imba_juggernaut_omni_slash_cdr"
end


function imba_juggernaut_omni_slash:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	local rand_number = rand(100)
	if rand_number <= 15 then
		caster:EmitSound("juggernaut_jug_rare_17")
	else
		caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
	end
	return true
end

function imba_juggernaut_omni_slash:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local omnislash_modifier = caster:AddNewModifier(caster, self, "modifier_imba_omni_slash_caster", {})
	

	PlayerResource:SetCameraTarget(caster:GetPlayerID(), caster)


	FindClearSpaceForUnit(caster, target:GetAbsOrigin() + RandomVector(128), false)
	
	caster:EmitSound("Hero_Juggernaut.OmniSlash")

	StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
	
	if target:TriggerSpellAbsorb(ability) then
		return nil
	else
		caster:PerformAttack(target, true, true, true, true, true, false, false)
	end
end


LinkLuaModifier("modifier_imba_omni_slash_caster", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_HORIZONTAL)
modifier_imba_omni_slash_caster = class({})

function modifier_imba_omni_slash_caster:OnCreated( )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if not self.caster:HasScepter() then
		self.bounce_range = self.ability:GetTalentSpecialValueFor("bounce_range")
		self.bounce_amt = self.ability:GetTalentSpecialValueFor("jump_amount")
	else
		self.bounce_range = self.ability:GetTalentSpecialValueFor("bounce_range_scepter")
		self.bounce_amt = self.ability:GetTalentSpecialValueFor("jump_amount_scepter")
	end
	
	if IsServer() then
		self:StartIntervalThink(self.ability:GetSpecialValueFor("bounce_delay"))
	end
end

function modifier_imba_omni_slash_caster:OnIntervalThink( )
	self:BounceAndSlaughter()
end

function modifier_imba_omni_slash_caster:BounceAndSlaughter( )
	nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
	print(self.bounce_amt, self.bounce_amt >= 1 and #nearby_enemies >= 1)
	if self.bounce_amt >= 1 and #nearby_enemies >= 1 then
		for _,enemy in pairs(nearby_enemies) do
			local previous_position = self.caster:GetAbsOrigin()
			FindClearSpaceForUnit(self.caster, enemy:GetAbsOrigin() + RandomVector(128), false)
			self.caster:MoveToTargetToAttack(enemy)
			local current_position = self.caster:GetAbsOrigin()

			-- Provide vision of the target for a short duration
			self.ability:CreateVisibilityNode(current_position, 300, 1.0)

			-- Perform the slash
			self.caster:PerformAttack(enemy, true, true, true, true, true, false, false)

			-- If the target is not Roshan or a hero, instantly kill it
			if not ( enemy:IsHero() or IsRoshan(enemy) ) then
				enemy:Kill(self.ability, self.caster)
			end

			-- Count down amount of slashes
			self.bounce_amt = self.bounce_amt - 1

			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.OmniSlash.Damage")

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
			local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)
			break
		end
	else
		self:Destroy()
	end
end

function modifier_imba_omni_slash_caster:OnRemoved()
	if IsServer() then
		if self.caster:HasModifier("modifier_imba_blade_fury_caster") then
			StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
		else
			EndAnimation(self.caster)
		end
		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), nil)
		if self.bounce_amt > 1 then
			local rand = RandomInt(1, 2)
			caster:EmitSound("juggernaut_jug_ability_waste_0"..rand)
		end
	end
end

function modifier_imba_omni_slash_caster:CheckState()
    local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end

function modifier_imba_omni_slash_caster:StatusEffectPriority()
	return 20
end

function modifier_imba_omni_slash_caster:GetStatusEffectName()
	return "particles/status_fx/status_effect_omnislash.vpcf"
end

LinkLuaModifier("modifier_imba_juggernaut_omni_slash_cdr", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_HORIZONTAL)
modifier_imba_juggernaut_omni_slash_cdr = class({})

function modifier_imba_juggernaut_omni_slash_cdr:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.cdr = self.ability:GetTalentSpecialValueFor("cdr_per_attack")
end

function modifier_imba_juggernaut_omni_slash_cdr:OnRefresh()
	self.cdr = self.ability:GetTalentSpecialValueFor("cdr_per_attack")
end

function modifier_imba_juggernaut_omni_slash_cdr:IsHidden()
	return true
end


function modifier_imba_juggernaut_omni_slash_cdr:DeclareFunctions()
	funcs = { 
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_imba_juggernaut_omni_slash_cdr:OnAttackLanded(params) -- health handling
	if params.attacker == self:GetParent() and params.target:IsRealHero() and not self.ability:IsCooldownReady() then
		local cd = self.ability:GetCooldownTimeRemaining() - self.cdr
		self.ability:EndCooldown()
		self.ability:StartCooldown(cd)
	end
end

function Omnislash( keys )
	-- Start jumping loop
	Timers:CreateTimer(0, function()

		-- Update previous position
		previous_position = current_position
		
		-- Find eligible targets
		nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		
		-- If there is an eligible target, slash it
		if nearby_enemies[1] then

			-- Set the current target
			current_target = nearby_enemies[1]
			current_position = current_target:GetAbsOrigin()

			-- Move the caster to the current target
			FindClearSpaceForUnit(caster, current_position, true)

			-- Set the caster's attack target as the current target
			caster:SetAttacking(current_target)
			caster:SetForceAttackTarget(current_target)
			Timers:CreateTimer(0.01, function()
				caster:SetForceAttackTarget(nil)
			end)

			-- Provide vision of the target for a short duration
			ability:CreateVisibilityNode(current_position, 300, 1.0)

			-- Perform the slash
			caster:PerformAttack(current_target, true, true, true, true, true, false, false)

			-- If the target is not Roshan or a hero, instantly kill it
			if not ( current_target:IsHero() or IsRoshan(current_target) ) then
				ApplyDamage({attacker = caster, victim = current_target, ability = ability, damage = current_target:GetHealth(), damage_type = DAMAGE_TYPE_PURE})
			end

			-- Count down amount of slashes
			jumps_remaining = jumps_remaining - 1

			-- Play hit sound
			current_target:EmitSound(sound_hit)

			-- Play hit particle on the current target
			local hit_pfx = ParticleManager:CreateParticle(particle_hit, PATTACH_ABSORIGIN_FOLLOW, current_target)
			ParticleManager:SetParticleControl(hit_pfx, 0, current_position)
			ParticleManager:ReleaseParticleIndex(hit_pfx)

			-- Play particle trail when moving
			local trail_pfx = ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(trail_pfx, 0, previous_position)
			ParticleManager:SetParticleControl(trail_pfx, 1, current_position)
			ParticleManager:ReleaseParticleIndex(trail_pfx)

			-- Update jump count
			local current_agi = caster:GetAgility()
			if current_agi > previous_agi then
				jumps_remaining = jumps_remaining + (current_agi - previous_agi) * agi_per_jump
				previous_agi = current_agi
			end

			-- If there are enough jumps left, keep slashing
			if jumps_remaining >= 1 then
				return bounce_delay

			-- Else, end the omnislash
			else
				caster:RemoveModifierByName(modifier_caster)
				if caster:HasModifier("modifier_imba_blade_fury_caster") then
					StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
				else
					EndAnimation(caster)
				end
				PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
			end

		-- Else, end the omnislash
		else
			caster:RemoveModifierByName(modifier_caster)
			if caster:HasModifier("modifier_imba_blade_fury_caster") then
				StartAnimation(caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
			else
				EndAnimation(caster)
			end
			PlayerResource:SetCameraTarget(caster:GetPlayerID(), nil)
		end
	end)
end