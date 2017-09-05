--[[	Author: Yahnich
		Date: 28.03.2017	]]
CreateEmptyTalents('juggernaut')

-- JUGGERNAUT SPECIFIC UTILITY FUNCTIONS --
function IsTotem(unit) -- have to do it like this because server and client side classes are different thanks valve
	return ( not unit:HasMovementCapability() )
end

-- BLADE FURY --
imba_juggernaut_blade_fury = imba_juggernaut_blade_fury or class({})
function imba_juggernaut_blade_fury:IsNetherWardStealable() return true end
function imba_juggernaut_blade_fury:GetCastRange()
	return self:GetTalentSpecialValueFor("effect_radius")
end

function imba_juggernaut_blade_fury:GetAbilityTextureName()
   return "juggernaut_blade_fury"
end

function imba_juggernaut_blade_fury:GetCooldown(nLevel)
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
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
LinkLuaModifier("modifier_imba_juggernaut_blade_fury_deflect_buff", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_juggernaut_blade_fury_succ", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_fury = modifier_imba_juggernaut_blade_fury or class({})

function modifier_imba_juggernaut_blade_fury:OnCreated()
	self.caster = self:GetCaster()
	self.original_caster = self.caster
	self.ability = self:GetAbility()
	self.dps = self.ability:GetTalentSpecialValueFor("damage_per_sec")
	-- self.evasion = self.ability:GetTalentSpecialValueFor("evasion")
	self.radius = self.ability:GetTalentSpecialValueFor("effect_radius")
	self.tick = self.ability:GetTalentSpecialValueFor("damage_tick")
	self.caster = self:GetCaster()
	if IsServer() then
		if self.caster:IsAlive() then
			self.blade_fury_spin_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(self.blade_fury_spin_pfx, 5, Vector(self.radius * 1.2, 0, 0))
			-- #2 Talent: Create a Secondary Blade Fury for better looking fx
			if self.caster:HasTalent("special_bonus_imba_juggernaut_2") then
				self.blade_fury_spin_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
				ParticleManager:SetParticleControl(self.blade_fury_spin_pfx_2, 5, Vector(self.radius * 1.2, 0, 0))
			end
			self:StartIntervalThink(self.tick)
			self.caster:EmitSound("Hero_Juggernaut.BladeFuryStart")
			StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_1, rate = 1.0})
		end
	end
end

function modifier_imba_juggernaut_blade_fury:OnIntervalThink()
	local damage = self.dps * self.tick
	local caster_loc = self.caster:GetAbsOrigin()
	-- Iterate through nearby enemies
	local furyEnemies = FindUnitsInRadius(self.caster:GetTeamNumber(), caster_loc, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- #1 Talent: Blade Fury acts as a vacuum, sucking enemies toward Juggernaut
	if self.original_caster:HasTalent("special_bonus_imba_juggernaut_1") then
	local nearbyEnemies = FindUnitsInRadius(self.caster:GetTeamNumber(), caster_loc, nil, self.radius*self.original_caster:FindTalentValue("special_bonus_imba_juggernaut_1"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _,nearbyEnemy in pairs(nearbyEnemies) do	
			-- How many layers of irony are you on?
			if not nearbyEnemy:HasModifier("modifier_imba_juggernaut_blade_fury_succ") then
			nearbyEnemy:AddNewModifier(self.caster,self.ability,"modifier_imba_juggernaut_blade_fury_succ",{})
			end
		end
	end

	-- #2 Talent: Blade Fury slowly increases in sizes
	if self.original_caster:HasTalent("special_bonus_imba_juggernaut_2") then
		self.radius = self.radius + self.original_caster:FindTalentValue("special_bonus_imba_juggernaut_2")
		if self.blade_fury_spin_pfx then
			ParticleManager:SetParticleControl(self.blade_fury_spin_pfx, 5, Vector(self.radius * 1.2, 0, 0))
		end
		if self.blade_fury_spin_pfx_2 then
			ParticleManager:SetParticleControl(self.blade_fury_spin_pfx_2, 5, Vector(self.radius * 1.2, 0, 0))
		end
	end
	
	for _,enemy in pairs(furyEnemies) do	
		-- Play hit sound
		enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
		-- Play hit particle
		local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(slash_pfx)
		if self.original_caster:HasTalent("special_bonus_imba_juggernaut_6") then
			self.bladedance = self.bladedance or self.caster:FindAbilityByName("imba_juggernaut_blade_dance")
			self.prng = self.prng or 0
			-- Benefits from Wind Dance.
			local wind_dance = self.original_caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_wind_dance")
			if wind_dance then
			damage = damage + (wind_dance:GetStackCount() * self.original_caster:FindTalentValue("special_bonus_imba_juggernaut_6","dps") * self.tick)
			end
			-- Crit Chance
			local crit = self.bladedance:GetTalentSpecialValueFor("crit_damage") / 100
			local chance = self.bladedance:GetTalentSpecialValueFor("crit_chance")			
			if RollPercentage( chance + self.prng - math.floor( (chance - 5)/chance ) ) then
				self.prng = 0
				local crit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(crit_pfx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(crit_pfx)
				self:GetParent():EmitSound("Hero_Juggernaut.BladeDance")
				self:GetParent():EmitSound("Hero_Juggernaut.PreAttack")
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

-- G I B B D A S U C C
modifier_imba_juggernaut_blade_fury_succ = modifier_imba_juggernaut_blade_fury_succ or class({})

function modifier_imba_juggernaut_blade_fury_succ:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.target = self:GetParent()
	-- I would want to set this to FrameTime, but lags. Sadness.
	self.succ_tick = self.ability:GetTalentSpecialValueFor("succ_tick")
	if IsServer() then
		self:StartIntervalThink(self.succ_tick)
	end
end

function modifier_imba_juggernaut_blade_fury_succ:OnIntervalThink()
	if IsServer() then
		if (not self.caster:IsAlive()) or (not self.caster:HasModifier("modifier_imba_juggernaut_blade_fury")) then
			self:Destroy()
			return nil
		end
		
		-- Ability Specials
		enemy_position = self.target:GetAbsOrigin()
		caster_position = self.caster:GetAbsOrigin()
		
		self.radius = self.ability:GetTalentSpecialValueFor("effect_radius")
		succ_radius = self.radius * self.caster:FindTalentValue("special_bonus_imba_juggernaut_1")
		
		-- Direction
		direction = ( enemy_position - caster_position ):Normalized() * (-1)
		distance = ( enemy_position - caster_position ):Length2D()
		
		-- If the target is over its effect radius, then destroys itself.
		if distance > succ_radius then
			self:Destroy()
			return nil
		end
		
		-- If it's not hugged by Juggernaut, SUCC IT IN!
		if distance > 100 then
			-- Pull Strength. The closer the enemy gets, the closer they get
			newPosition = enemy_position + direction * self.succ_tick * (succ_radius - distance) * 0.2
			-- Set the new point
			self.target:SetAbsOrigin(newPosition)
			self.target:SetUnitOnClearGround()
		else
			self.target:SetUnitOnClearGround()
		end
	end
end

function modifier_imba_juggernaut_blade_fury:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
	return state
end

function modifier_imba_juggernaut_blade_fury:DeclareFunctions()
 	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
-- 		MODIFIER_PROPERTY_EVASION_CONSTANT
 	}
 	return funcs
end

-- Mi o sutete mo, myōri wa sutezu.
function modifier_imba_juggernaut_blade_fury:OnAttackLanded(keys)
	if IsServer() then
	local target = keys.target
	local attacker = keys.attacker
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	check_attack_capability = attacker:GetAttackCapability()
	
	attacker_projectile_particle = attacker:GetRangedProjectileName()
	attacker_projectile_speed = attacker:GetProjectileSpeed()
	
		-- Check if the attacker is a ranged attacker.
		if target == self.caster and check_attack_capability == 2 then
			
			-- Nullifies the attack, FrameTime() does not help.
			self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_fury_deflect_buff", {duration = 0.01})
			
			-- Nullifies Item Modifiers such as Deso if Juggernaut doesn't have it.
			self.caster:Purge(false, true, true, false, false)
			
			-- Play hit sound
			self.caster:EmitSound("Hero_Juggernaut.BladeFury.Impact")
			
			-- Play hit particle
			local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
			ParticleManager:SetParticleControl(slash_pfx, 0, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(slash_pfx)
		
			local enemy = FindUnitsInRadius(self.caster:GetTeamNumber(),
                                          self.caster:GetAbsOrigin(),
                                          nil,
                                          self.ability:GetSpecialValueFor("deflect_radius"),
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

				if enemy[1] then
						deflected_target = enemy[1]
						
						local projectile_deflected
						projectile_deflected = {
								hTarget = deflected_target,
								hCaster = self.caster,
								Ability = self.ability,
								EffectName = attacker_projectile_particle,
								iMoveSpeed = attacker_projectile_speed,
								vSourceLoc = self.caster:GetAbsOrigin(),
								-- TreeBehavior = PROJECTILES_NOTHING,
								bDodgeable = true,
								flRadius = 1,
								bVisibleToEnemies = true,
								bDestroyOnDodge = true,
								bReplaceExisting = false,
								bProvidesVision = false,
								OnProjectileHitUnit = function(params,projectileID)
									ProjectileHit(params, projectileID, self.ability, attacker, deflected_target, self.caster)
								end,
								}

						TrackingProjectiles:Projectile(projectile_deflected)
						-- ProjectileManager:CreateTrackingProjectile(projectile_deflected)
						
				end
		end
	end
end

function ProjectileHit(params, projectileID, modifier, attacker, target, deflector)

	if target:HasModifier("modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit") or (not target:IsAlive()) then
	else
	target:AddNewModifier(deflector,modifier,"modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit",{duration = 0.01})
	end
	
	-- Perform an instant attack on hit enemy
	attacker:PerformAttack(target, false, true, true, false, false, false, false)
	-- target:RemoveModifierByName("modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit") --Injected into imba.lua
	-- On behalf of deflecting projectiles, list of items that changed to nullify on hit effects and have their modifier applied on attacking allied, in alphabetical order:
	-- Abyssal Blade Family, Butterfly, Crit Family, Diffusal, Echo Sabre, Mjollnir Family, MKB, Nether Wand Family, Silver Edge Family, Spellfencer, Starfury and Triumverate Family
end

-- Deflected kill credited to the caster.
modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit = modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit or class({})

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:IsHidden() return false end
function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:IsPurgable() return false end
function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:IsDebuff() return false end

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:DeclareFunctions()
	local decFuncs = 
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return decFuncs
end

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:OnTakeDamage(keys)
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.ability = self:GetAbility()
		local damage = keys.damage
		local target = keys.target
		local attacker = keys.attacker
		
		-- Calculates damage
		parent_health = self.parent:GetHealth()
		if keys.damage > parent_health and target == self.parent then
			-- Deals damage, crediting to the caster
			ApplyDamage({attacker = self.caster, victim = self.parent, ability = self.ability, damage = target_health + 10, damage_type = DAMAGE_TYPE_PURE, damage_flag = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})
		end
	end
end

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:StatusEffectPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:GetPriority()
    return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_juggernaut_blade_fury_deflect_on_kill_credit:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
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
		if self.blade_fury_spin_pfx then
			ParticleManager:DestroyParticle(self.blade_fury_spin_pfx, false)
			ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx)
			self.blade_fury_spin_pfx = nil
		end
		if self.blade_fury_spin_pfx_2 then
			ParticleManager:DestroyParticle(self.blade_fury_spin_pfx_2, false)
			ParticleManager:ReleaseParticleIndex(self.blade_fury_spin_pfx_2)
			self.blade_fury_spin_pfx_2 = nil
		end
	end
end

modifier_imba_juggernaut_blade_fury_deflect_buff = modifier_imba_juggernaut_blade_fury_deflect_buff or class({})

function modifier_imba_juggernaut_blade_fury_deflect_buff:IsHidden() return true end
function modifier_imba_juggernaut_blade_fury_deflect_buff:IsPurgable() return false end
function modifier_imba_juggernaut_blade_fury_deflect_buff:IsDebuff() return false end

function modifier_imba_juggernaut_blade_fury_deflect_buff:OnCreated()
    self.caster = self:GetCaster()
end

function modifier_imba_juggernaut_blade_fury_deflect_buff:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
    return decFuncs
end

function modifier_imba_juggernaut_blade_fury_deflect_buff:GetModifierIncomingDamage_Percentage(params)	
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, self.caster, params.damage, nil)
	return -100	
end

-- HEALING WARD --
imba_juggernaut_healing_ward = imba_juggernaut_healing_ward or class({})
function imba_juggernaut_healing_ward:IsNetherWardStealable() return false end

function imba_juggernaut_healing_ward:GetAbilityTextureName()
   return "juggernaut_healing_ward"
end

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



imba_juggernaut_healing_ward_passive = imba_juggernaut_healing_ward_passive or class({})

function imba_juggernaut_healing_ward_passive:GetAbilityTextureName()
	return "juggernaut_healing_ward"
end

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
modifier_imba_juggernaut_healing_ward_passive = modifier_imba_juggernaut_healing_ward_passive or class({})

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

function modifier_imba_juggernaut_healing_ward_passive:GetAuraEntityReject(target)
	if target:GetUnitName() == self:GetParent():GetUnitName() then return true end
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
modifier_imba_juggernaut_healing_ward_aura = modifier_imba_juggernaut_healing_ward_aura or class({})

function modifier_imba_juggernaut_healing_ward_aura:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.attack_speed = 0
	if IsTotem(self.caster) then
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec_totem")
		if self.caster:GetOwner():HasTalent("special_bonus_imba_juggernaut_3") then
		self.attack_speed = self.caster:GetOwner():FindTalentValue("special_bonus_imba_juggernaut_3","totem_value")
		end
	else
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec")
		if self.caster:GetOwner():HasTalent("special_bonus_imba_juggernaut_3") then
		self.attack_speed = self.caster:GetOwner():FindTalentValue("special_bonus_imba_juggernaut_3")
		end
	end
end

function modifier_imba_juggernaut_healing_ward_aura:OnRefresh()
	if IsTotem(self.caster) then
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec_totem")
		if self.caster:GetOwner():HasTalent("special_bonus_imba_juggernaut_3") then
		self.attack_speed = self.caster:GetOwner():FindTalentValue("special_bonus_imba_juggernaut_3","totem_value")
		end
	else
		self.healing = self.ability:GetTalentSpecialValueFor("heal_per_sec")
		if self.caster:GetOwner():HasTalent("special_bonus_imba_juggernaut_3") then
		self.attack_speed = self.caster:GetOwner():FindTalentValue("special_bonus_imba_juggernaut_3")
		end
	end
end

function modifier_imba_juggernaut_healing_ward_aura:GetEffectName()
	return "particles/units/heroes/hero_juggernaut/juggernaut_ward_heal.vpcf"
end

function modifier_imba_juggernaut_healing_ward_aura:DeclareFunctions()
	funcs = { MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
	return funcs
end

function modifier_imba_juggernaut_healing_ward_aura:GetModifierHealthRegenPercentage()
	return self.healing
end

function modifier_imba_juggernaut_healing_ward_aura:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end


-- BLADE DANCE --
imba_juggernaut_blade_dance = imba_juggernaut_blade_dance or class({})

function imba_juggernaut_blade_dance:GetIntrinsicModifierName()
	return "modifier_imba_juggernaut_blade_dance_passive"
end

function imba_juggernaut_blade_dance:GetAbilityTextureName()
	return "juggernaut_blade_dance"
end

function imba_juggernaut_blade_dance:CastFilterResultLocation(position)
	if IsServer() then
		local caster = self:GetCaster()
		if caster:IsDisarmed() then
			return UF_FAIL_CUSTOM
		end
	end
end

function imba_juggernaut_blade_dance:GetCustomCastErrorTarget(target)
	return "dota_hud_error_cant_use_disarmed"	
end

function imba_juggernaut_blade_dance:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	self.endPoint = position
	self.initialPos = caster:GetAbsOrigin()
	self.second_dash = false
	self.third_dash = false
	caster:FaceTowards(position)
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

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_empowered_slice", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_empowered_slice = modifier_imba_juggernaut_blade_dance_empowered_slice or class({})

function modifier_imba_juggernaut_blade_dance_empowered_slice:IsHidden()
	return true
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE}
	
	return funcs
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:GetModifierTurnRate_Percentage()
	return 999999
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:RemoveOnDeath()
	return false
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:IsMotionController()
	return true
end
function modifier_imba_juggernaut_blade_dance_empowered_slice:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end
function modifier_imba_juggernaut_blade_dance_empowered_slice:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		
		EmitSoundOn("Hero_Juggernaut.PreAttack", self.parent)
		EmitSoundOn("Hero_EarthShaker.Attack", self.parent)
		self.speed = self.ability:GetTalentSpecialValueFor("active_speed")
		self.has_slice_enemy = false
		self.enemies_hit = {}
		
		if self.second_dash or self.third_dash then
		self.initialPos = self.initialPos
		self.endPoint = self.endPoint
		else
		self.initialPos = self.ability.initialPos
		self.endPoint = self.ability.endPoint
		end
		
		self.maxDistance = self.ability:GetTalentSpecialValueFor("active_distance")
		self.distance_left = ( self.endPoint - self.caster:GetAbsOrigin() ):Length2D()
		self.direction = ( self.endPoint - self.caster:GetAbsOrigin() ):Normalized()
		self.distance_limit = self.maxDistance - ( self.endPoint - self.initialPos ):Length2D()		
		self.traveled = 0		
		self.secret_blade = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_secret_blade")
		self.frametime = FrameTime()
		self.caster:FaceTowards(self.endPoint)
		self.initialAngle = self.parent:GetAnglesAsVector()
		Timers:CreateTimer(0.02, function()
			self.initialAngle = self.parent:GetAnglesAsVector()
		end)
		if self.secret_blade then
		self.attack_count = self.secret_blade:GetStackCount()
		self.secret_blade:Destroy()
		end
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self.parent, self.frametime)

	-- Look for enemies to attack
	self:SeekAndDestroy()
end

-- Chikara ga minagitte kuru!
function modifier_imba_juggernaut_blade_dance_empowered_slice:SeekAndDestroy()
	if IsServer() then
		local sliceEnemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)
		local enemy_hit = false
		
			for _,enemy in pairs(sliceEnemies) do
				
				-- If no hits were left, exit
				if self.attack_count < 1 then
					self:Destroy()
					return nil
				end
						
				-- If this enemy was already hit by this cast, do nothing
				enemy_hit = false
				
				for _,hit_enemy in pairs(self.enemies_hit) do
					-- If the enemy is hit once, do nothing
					if hit_enemy == enemy then
						enemy_hit = true
					end
					
					-- If the enemy is gone, do nothing either
					if enemy:IsInvisible() or enemy:IsOutOfGame() then
						enemy_hit = true
					end
					
					-- If this enemy is attack immune, still do nothing
					if enemy:IsAttackImmune() then
					enemy_hit = true
					end
				end
				
				-- If the target is valid
				if not enemy_hit then
					
					-- Play hit sound
					enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
					-- Play hit particle
					local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
					ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(slash_pfx)

					-- Deal damage
					self.caster:PerformAttack(enemy, true, true, true, true, false, false, true)
					
					-- There are enemies being hit haha now you cant bug me with Stack Overflow :3
					self.has_slice_enemy = true
					
					-- #4 Talent. Indicating Blade Dance's active strikes three times: once in a straight line forward, and twice to the sides. 
					if self.caster:HasTalent("special_bonus_imba_juggernaut_4") then
					self.targetted_enemy = enemy
					end
					
					-- Add a modifier to indicate the amount of times hit
					if (not enemy:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count")) then
					sliced_count = enemy:AddNewModifier(self.caster,self.ability,"modifier_imba_juggernaut_blade_dance_empowered_slice_count",{duration = 1.0})
						if sliced_count then
						sliced_count:IncrementStackCount()
						end
					end
					
					-- Minus one attack count
					self.attack_count = self.attack_count - 1
					
					-- Add this enemy to the hit table
					table.insert(self.enemies_hit, enemy)
				end
			end
	end
end


function modifier_imba_juggernaut_blade_dance_empowered_slice:HorizontalMotion( me, dt )
	if IsServer() then	
		-- Get the vectors, simple methemetics
		
		-- Direction
		self.direction = ( self.endPoint - self.caster:GetAbsOrigin() ):Normalized()	
		-- Next traveled point
		self.newPoint = self.caster:GetAbsOrigin() + self.direction * self.speed * dt
		-- Distance Travelled
		self.distance_travelled = ( self.caster:GetAbsOrigin() - self.initialPos ):Length2D()
		-- Check if it is almost to its destination
		self.max_travel_distance = self.maxDistance - self.distance_travelled
		
		-- Check if the see if the endPoint is more than 100 units and the distance remaining is more than 100 units
		if self.distance_left > 100 and self.max_travel_distance > 100 then
			local oldPos = self.caster:GetAbsOrigin()
			self.caster:SetAbsOrigin(self.newPoint)
			self.distance_left = ( self.endPoint - self.caster:GetAbsOrigin() ):Length2D()
			self.max_travel_distance = self.distance_left - self.maxDistance
			
			-- Create the fluid movement particle
			local sliceFX = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_omnislash/dc_juggernaut_omni_slash_rope.vpcf", PATTACH_ABSORIGIN  , self.caster)
			ParticleManager:SetParticleControl(sliceFX, 0, oldPos)
			ParticleManager:SetParticleControl(sliceFX, 2, oldPos)
			ParticleManager:SetParticleControl(sliceFX, 3, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(sliceFX)
		else			
			-- if the endPoint is within the distance limit, set the endPoint as the newPoint
			if self.distance_limit > 0 then
			self.newPoint = self.endPoint
			end
			
			
			-- Create the fluid movement particle
			local sliceFX = ParticleManager:CreateParticle("particles/econ/items/juggernaut/bladekeeper_omnislash/dc_juggernaut_omni_slash_rope.vpcf", PATTACH_ABSORIGIN  , self.caster)
			ParticleManager:SetParticleControl(sliceFX, 0, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(sliceFX, 2, self.caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(sliceFX, 3, self.caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(sliceFX)
		
			-- Move the caster to the newPoint
			FindClearSpaceForUnit(self.caster, self.newPoint, true)
			self.caster:FaceTowards(self.newPoint)
			self.caster:SetUnitOnClearGround()
			
			-- If no hits were left, destroy itself
			if self.attack_count < 1 then
			self:Destroy()
			end
			
			-- If there were no valid targets, proceeds to destroy itself
			if not self.has_slice_enemy then
				
				
				-- #4 Talent. Blade Dance's active strikes three times: once in a straight line forward, and twice to the sides. 
				if self.caster:HasTalent("special_bonus_imba_juggernaut_4") and (not self.third_dash_finale) then
					
					-- Third Dash checking has a higher priority than second dash, because self.second_dash is initialized first, then comes self.third_dash
					-- If this is the end of the second dash, commence the third dash
					if self.third_dash then
					self:SeekAndDestroyPtTweeDecimation()
					return
					end
						
					-- If this is the end of the initial dash, commence the second dash
					if not self.second_dash then
					self.second_dash = true
					self:SeekAndDestroyPtTweeDecimation()
					return
					end
						
				else
					-- If the caster does not have the talent or it is the third dash, then negates itself
					self:Destroy()
					return nil
						
				end
				
			else
			-- If there are more, proceed to Annihilation Phase
			self:SeekAndDestroyPtTooAnnihilation()
			end
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

function modifier_imba_juggernaut_blade_dance_empowered_slice:SeekAndDestroyPtTooAnnihilation()
	if IsServer() then
		local enemy_hit = false
		
		-- If there were no enemies in the list, proceed to self-destruct
		if (not self.has_slice_enemy) then
		self:Destroy()
		return nil
		end
		
		for _,enemy in pairs(self.enemies_hit) do
			
			-- If no hits were left, finish the finale
			if self.attack_count < 1 then
				self:Destroy()
				return nil
			end
			
			-- If this enemy is not a valid target, do nothing
			if enemy:IsInvisible() or enemy:IsOutOfGame() then
				enemy_hit = true
			end
			
			-- If this enemy is attack immune, do nothing either
			if enemy:IsAttackImmune() then
				enemy_hit = true
			end
			
			-- If enemy is already stroke 3 times, still do nothing
			if enemy:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count") then
				sliced_enemy = enemy:FindModifierByName("modifier_imba_juggernaut_blade_dance_empowered_slice_count")
				sliced_enemy_stack = sliced_enemy:GetStackCount()
					if sliced_enemy_stack >= self.ability:GetTalentSpecialValueFor("secret_blade_max_hits") then
						enemy_hit = true
					end
			end
			
			-- If the target is valid
			if not enemy_hit then

			-- Play hit sound
			enemy:EmitSound("Hero_Juggernaut.BladeFury.Impact")
			-- Play hit particle
			local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(slash_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(slash_pfx)

			-- Deal damage
			self.caster:PerformAttack(enemy, true, true, true, true, false, false, true)

			-- Add a modifier to indicate the amount of times hit
			if enemy:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count") then
			enemy_sliced = enemy:FindModifierByName("modifier_imba_juggernaut_blade_dance_empowered_slice_count")
			enemy_sliced:IncrementStackCount()
			end
					
			-- Minus one attack count
			self.attack_count = self.attack_count - 1
			
			end	
		end
		
		for _,enemy in pairs(self.enemies_hit) do
			-- If this is the third slice, end the finale
			if enemy:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count") then
			sliced_enemy = enemy:FindModifierByName("modifier_imba_juggernaut_blade_dance_empowered_slice_count")
			sliced_enemy_stack = sliced_enemy:GetStackCount()
				if sliced_enemy_stack >= self.ability:GetTalentSpecialValueFor("secret_blade_max_hits") then
				
					-- #4 Talent. Blade Dance's active strikes three times: once in a straight line forward, and twice to the sides. 
					if self.caster:HasTalent("special_bonus_imba_juggernaut_4") and (not self.third_dash_finale) and self.attack_count > 0 then
						
						-- Third Dash checking has a higher priority than second dash, because self.second_dash is initialized first, then comes self.third_dash
						-- If this is the end of the second dash, commence the third dash
						if self.third_dash then
						self:SeekAndDestroyPtTweeDecimation()
						return
						end
						
						-- If this is the end of the initial dash, commence the second dash
						if not self.second_dash then
						self.second_dash = true
						self:SeekAndDestroyPtTweeDecimation()
						return
						end
						
					else
						-- If the caster does not have the talent or it is the third dash, then negates itself
						self:Destroy()
						return nil
						
					end
				end
			end
		end
		
		-- Repeat the Annihilation Phase
		self:SeekAndDestroyPtTooAnnihilation()
	end
end

-- #4 Talent Slice, two thirds Annihilation one part the Juggernaut, b*tch!
function modifier_imba_juggernaut_blade_dance_empowered_slice:SeekAndDestroyPtTweeDecimation()
	if IsServer() then
		-- If no hits were left, destroy itself
		if self.attack_count < 1 then
			-- If no enemies were slashed yet, set the caster to the original point
			if self.second_dash or self.third_dash then
			self.caster:SetAbsOrigin(self.newPoint)
			self.second_dash = false
			self.third_dash = false
			end
		self.caster:SetUnitOnClearGround()
		self:Destroy()
		end
			
		-- Remove the sliced modifier for them to be sliced again.
		for _,enemy in pairs(self.enemies_hit) do
			if enemy:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice_count") then
				enemy:RemoveModifierByName("modifier_imba_juggernaut_blade_dance_empowered_slice_count")
			end
		end
		
		-- Get the point of the horizontal slice
		if (not self.targetted_enemy) then
			target_position = self.newPoint
		else
			target_position = self.targetted_enemy:GetAbsOrigin()
		end
		
		local direction
		local final_location
		local set_location
		local initialPos = self.caster:GetAbsOrigin()
		
		-- Determine the angle for Juggernaut to force move to
		-- On the second dash, self.quangle_angle is set
		if self.second_dash then
		self.qangle_angle = 90 + (self.initialAngle).y
		end
		
		
		-- Rotate the angles
		self.caster:SetAngles(0,self.qangle_angle,0)
		
		-- If this is the second dash, proceed to this step
		if self.second_dash then
			-- Set the caster on the target's position to calculate the force to move to.
			self.caster:SetAbsOrigin(target_position)
			
			-- Calculate the force to move to after setting to the target's position
			direction = self.caster:GetForwardVector()   
			
			final_location = target_position + direction * self.maxDistance * 0.5
			set_location = target_position + direction * (-1) * self.maxDistance * 0.5
			
			self.caster:SetAbsOrigin(set_location)
		
		-- If this is the third dash, proceed to this step
		elseif self.third_dash then
			-- Calculate the force to move to
			direction = self.caster:GetForwardVector() 
			
			final_location = initialPos + direction * (-1) * self.maxDistance
		end
		
		-- Set the params for the next attack
		self.endPoint = final_location
		self.initialPos = self.caster:GetAbsOrigin()
		self.attack_count = self.attack_count 
		
		-- Ends itself and gives birth to the next cycle
		self:Destroy()
	end
end

function modifier_imba_juggernaut_blade_dance_empowered_slice:OnDestroy()
	if IsServer() then
		-- When it ends, check if it triggers the second dash
		if self.second_dash then
			second_dash_handler = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_empowered_slice", {})

			if second_dash_handler then
			second_dash_handler.attack_count = self.attack_count
			second_dash_handler.second_dash = false
			second_dash_handler.third_dash = true
			second_dash_handler.initialPos = self.caster:GetAbsOrigin()
			second_dash_handler.endPoint = self.endPoint
			second_dash_handler.target_position = target_position
			second_dash_handler.qangle_angle = self.qangle_angle
			end
			return
		end
		-- When it ends, check if it triggers the third dash
		if self.third_dash then
		
			third_dash_handler = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_empowered_slice", {})
	
			if third_dash_handler then
			third_dash_handler.attack_count = self.attack_count
			third_dash_handler.third_dash = false
			third_dash_handler.third_dash_finale = true
			third_dash_handler.initialPos = self.caster:GetAbsOrigin()
			third_dash_handler.endPoint = self.endPoint
			third_dash_handler.target_position = self.target_position
			third_dash_handler.qangle_angle = self.qangle_angle
			end
			return
		end
		if self.third_dash_finale then
			-- If the final dash is finished, set Juggernaut's position to the target and destroys itself
			if self.target_position then
			self.caster:SetAbsOrigin(self.target_position)
			self.caster:SetUnitOnClearGround()
			end
		end
	end
end

modifier_imba_juggernaut_blade_dance_empowered_slice_count = modifier_imba_juggernaut_blade_dance_empowered_slice_count or class({})

function modifier_imba_juggernaut_blade_dance_empowered_slice_count:IsHidden()
	return true
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_passive", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_passive = modifier_imba_juggernaut_blade_dance_passive or class({})

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
		if RollPseudoRandom(self.chance, self) then
			
			local crit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/jugg_crit_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(crit_pfx, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(crit_pfx)
			
			self.critProc = true
			-- Play crit sound

			self:GetParent():EmitSound("Hero_Juggernaut.BladeDance")
			return self.crit
		else
			self.critProc = false			
			return nil
		end
	end

	function modifier_imba_juggernaut_blade_dance_passive:OnAttackLanded(params)
		if params.attacker == self:GetParent() then
			-- Split Wind Dance and Secret Blade
			self:HandleWindDance(self.critProc)
			self:HandleSecretBlade()
			self:HandleJadeBlossom(self.critProc)
			self.critProc = false
		end
	end
end

function modifier_imba_juggernaut_blade_dance_passive:HandleWindDance(bCrit)
	if self.caster:IsRealHero() then
		-- If Juggernaut is in the middle of Blade Dance, he cannot gain Wind Dance stacks.
		if self.caster:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice") then			
			return nil
		end
		
		-- If the attacker is an image, proc Wind Dance for Juggernaut himself
		if self.caster:HasModifier("modifier_imba_omni_slash_image") then
		
		-- Juggernaut's image has it's original caster set as it's caster  
		omnislash_talent_modifier = self.caster:FindModifierByName("modifier_imba_omni_slash_image")
		local true_caster = omnislash_talent_modifier:GetCaster()
			
			-- If the caster is valid, then proceed
			if true_caster then
			
				-- Get the original caster's Blade Dance Ability
				local true_caster_blade_dance = true_caster:FindAbilityByName("imba_juggernaut_blade_dance")
				
				-- Get the original caster's Wind Dance
				local true_caster_wind_dance = true_caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_wind_dance")
				
				-- Get if the attacker crits
				if bCrit then
				
					-- If original caster's Wind Dance is not found, create Wind Dance based on its original caster
					if not true_caster_wind_dance then true_caster_wind_dance = true_caster:AddNewModifier(true_caster, true_caster_blade_dance, "modifier_imba_juggernaut_blade_dance_wind_dance", {duration = true_caster_blade_dance:GetTalentSpecialValueFor("bonus_duration")}) end
					
					-- Refresh it
					true_caster_wind_dance:ForceRefresh()
				
				-- If the attacker does not crit and the original caster's Wind Dance is found, set the new duration	
				elseif true_caster_wind_dance then
					true_caster_wind_dance:SetDuration(true_caster_wind_dance:GetDuration(), true) -- does not roll refresh
				end
			
			end
		
		end
			
		local wind_dance = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_wind_dance")
		if bCrit then
			if not wind_dance then wind_dance = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_wind_dance", {duration = self.ability:GetTalentSpecialValueFor("bonus_duration")}) end
			wind_dance:ForceRefresh()
		elseif wind_dance then
			wind_dance:SetDuration(wind_dance:GetDuration(), true) -- does not roll refresh
		end
	end
end

function modifier_imba_juggernaut_blade_dance_passive:HandleSecretBlade()
	if self.caster:IsRealHero() then
		-- If Juggernaut is in the middle of Blade Dance, he cannot gain Secret Blade stacks.
		if self.caster:HasModifier("modifier_imba_juggernaut_blade_dance_empowered_slice") then			
			return nil
		end
		
		-- If the attacker is an image, proc Secret Blade for Juggernaut himself
		if self.caster:HasModifier("modifier_imba_omni_slash_image") then
		
		-- Juggernaut's image has it's original caster set as it's caster 
		omnislash_talent_modifier = self.caster:FindModifierByName("modifier_imba_omni_slash_image") 
		local true_caster = omnislash_talent_modifier:GetCaster()
			
			-- If the caster is valid, then proceed
			if true_caster then
				
				-- Get the original caster's Blade Dance Ability
				local true_caster_blade_dance = true_caster:FindAbilityByName("imba_juggernaut_blade_dance")
				
				-- Get the original caster's Secret Blade
				local true_caster_secret_blade = true_caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_secret_blade")
				
				-- If not found, create Secret Blade based on its original caster
				if not true_caster_secret_blade then true_caster_secret_blade = true_caster:AddNewModifier(true_caster, true_caster_blade_dance, "modifier_imba_juggernaut_blade_dance_secret_blade", {duration = true_caster_blade_dance:GetTalentSpecialValueFor("secret_blade_duration")}) end
				
				-- Refresh it
				true_caster_secret_blade:ForceRefresh()
				
				end
			
			end
		
		local secret_blade = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_secret_blade")
		
		if not secret_blade then secret_blade = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_secret_blade", {duration = self.ability:GetTalentSpecialValueFor("secret_blade_duration")}) end
		secret_blade:ForceRefresh()
	end
end

function modifier_imba_juggernaut_blade_dance_passive:HandleJadeBlossom(bCrit)
	-- If the attacker is valid, then proc it.
	if self.caster:IsRealHero() then
		-- Only procs if the attacker crits
		if bCrit then
			-- If the attacker is an image, proc Jade Blossom for Juggernaut himself
			if self.caster:HasModifier("modifier_imba_omni_slash_image") then
				
				-- Juggernaut's image has it's original caster set as it's caster 
				omnislash_talent_modifier = self.caster:FindModifierByName("modifier_imba_omni_slash_image")
				local true_caster = omnislash_talent_modifier:GetCaster()
				
				-- If the caster is valid, then proceed
				if true_caster then
					
					-- Get the original caster's Blade Dance Ability
					local true_caster_blade_dance = true_caster:FindAbilityByName("imba_juggernaut_blade_dance")
					
					-- Check if the original caster has this talent
					if true_caster:HasTalent("special_bonus_imba_juggernaut_8") then
						
						-- If so, get the modifier name
						local true_caster_jade_blossom = true_caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_jade_blossom")
						
						-- If the modifier exists, refresh it
						if true_caster_jade_blossom then
							true_caster_jade_blossom:ForceRefresh()
						else
							-- If not, create Jade Blossom based on its original caster
							true_caster_jade_blossom = true_caster:AddNewModifier(true_caster, true_caster_blade_dance, "modifier_imba_juggernaut_blade_dance_jade_blossom", {duration = true_caster:FindTalentValue("special_bonus_imba_juggernaut_8","duration")})
						end
					
					end
				
				end
			
			end
				
			-- If the attacker is Juggernaut himself, also proc Jade Blossom
			if self.caster:HasTalent("special_bonus_imba_juggernaut_8") then
				-- Get the modifier name
				local jade_blossom = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_jade_blossom")
				-- If the modifier exists, refresh it
				if jade_blossom then
					jade_blossom:ForceRefresh()
				else
					-- If not, create Jade Blossom
					jade_blossom = self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_juggernaut_blade_dance_jade_blossom", {duration = self.caster:FindTalentValue("special_bonus_imba_juggernaut_8","duration")})
				end
			end
		end
	end
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_wind_dance", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_wind_dance = modifier_imba_juggernaut_blade_dance_wind_dance or class({})

function modifier_imba_juggernaut_blade_dance_wind_dance:GetTexture()
	return "juggernaut_blade_dance" end

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

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_secret_blade", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_secret_blade = modifier_imba_juggernaut_blade_dance_secret_blade or class({})

function modifier_imba_juggernaut_blade_dance_secret_blade:GetTexture()
	return "custom/juggernaut_secret_blade" end

function modifier_imba_juggernaut_blade_dance_secret_blade:OnCreated()
	self:StartIntervalThink(1)
end

function modifier_imba_juggernaut_blade_dance_secret_blade:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
		self:GetParent():CalculateStatBonus()
	end
end

function modifier_imba_juggernaut_blade_dance_secret_blade:OnStackCountChanged()
	local serverCheck = 0
	if IsServer() then -- why? ? ? ? ? (Preserve the question marks ! ! ! ! ! ? ? ? ? ? )
		self:GetParent():CalculateStatBonus()
		serverCheck = 1
		if self:GetStackCount() == self:GetAbility():GetTalentSpecialValueFor("active_min_stacks") then
		self:GetParent():EmitSound("Imba.JuggernautLightsaber")
		end
	end
	if self:GetStackCount() + serverCheck >= self:GetAbility():GetTalentSpecialValueFor("active_min_stacks") and self:GetAbility():GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE  then -- inject function calls clientside and serverside
	-- Change behavior
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
	self:GetAbility():GetBehavior()
	self:GetAbility():GetCastRange(self:GetCaster(), self:GetCaster():GetAbsOrigin())
	self:GetAbility():GetCooldown()
	elseif self:GetStackCount() + serverCheck < self:GetAbility():GetTalentSpecialValueFor("active_min_stacks") and self:GetAbility():GetBehavior() == DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE  then
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
	self:GetAbility():GetCastRange(self:GetCaster(), self:GetCaster():GetAbsOrigin())
	self:GetAbility():GetCooldown()
	end
	
end

function modifier_imba_juggernaut_blade_dance_secret_blade:OnRemoved()
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
	self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), self:GetCaster())
	self:GetAbility():GetCooldown()
end

LinkLuaModifier("modifier_imba_juggernaut_blade_dance_jade_blossom", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_blade_dance_jade_blossom = modifier_imba_juggernaut_blade_dance_jade_blossom or class ({})

function modifier_imba_juggernaut_blade_dance_jade_blossom:GetTexture()
	return "juggernaut_omni_slash" end

-- Credits: DrTeaSpoon for the innovation
function modifier_imba_juggernaut_blade_dance_jade_blossom:OnCreated()
	if IsServer() then
		self.duration = self:GetCaster():FindTalentValue("special_bonus_imba_juggernaut_8","duration")
		self:NewStack(self.duration)
	end
end
function modifier_imba_juggernaut_blade_dance_jade_blossom:OnRefresh()
	if IsServer() then
		self:NewStack(self.duration)
		self:SetDuration(self.duration,true)
	end
end
function modifier_imba_juggernaut_blade_dance_jade_blossom:NewStack()
	if IsServer() then
		self:IncrementStackCount()
		Timers:CreateTimer(self.duration, function()
		self:ExpiredStack()
		end)
	end
end
function modifier_imba_juggernaut_blade_dance_jade_blossom:ExpiredStack()
	if IsServer() then
		if (not self:IsNull()) then
			if self:GetStackCount() > 0 then
				self:DecrementStackCount()
			else
				self:Destroy()
			end
		end
	end
end

-- OMNI SLASH --
imba_juggernaut_omni_slash = imba_juggernaut_omni_slash or class({})
LinkLuaModifier("modifier_imba_omni_slash_caster", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_omni_slash_image", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)

function imba_juggernaut_omni_slash:IsNetherWardStealable() return false end
function imba_juggernaut_omni_slash:GetIntrinsicModifierName()
	return	"modifier_imba_juggernaut_omni_slash_cdr"
end

function imba_juggernaut_omni_slash:IsHiddenWhenStolen()
	return false
end

function imba_juggernaut_omni_slash:GetAbilityTextureName()
   return "juggernaut_omni_slash"
end

function imba_juggernaut_omni_slash:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local rand = math.random
	local im_the_juggernaut_lich = 10
	local ryujinnokenwokurae = 10
	if RollPercentage(im_the_juggernaut_lich) then
		caster:EmitSound("juggernaut_jug_rare_17")
	elseif RollPercentage(im_the_juggernaut_lich) then
		caster:EmitSound("Imba.JuggernautGenji")
	else
		caster:EmitSound("juggernaut_jug_ability_omnislash_0"..rand(3))
	end
	
	return true
end

function imba_juggernaut_omni_slash:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	
	self.minimum_damage = self:GetSpecialValueFor("min_damage")
	self.previous_position = self.caster:GetAbsOrigin()
	
	-- #7 Talent: Omnislash sends an image to commit the slashes, Juggernaut is free to continue as normal
	-- Senbonzakura Kageyoshi
	if self.caster:HasTalent("special_bonus_imba_juggernaut_7") then
	
		if self.target:TriggerSpellAbsorb(self) then
			return nil
		end
		
		-- Superclone Credits: igo95862 & Freeman322
		local omnislash_image = CreateUnitByName(self.caster:GetUnitName(), self.caster:GetAbsOrigin(), true, self.caster, self.caster:GetOwner(), self.caster:GetTeamNumber())
		
		local caster_level = self.caster:GetLevel()
		for i=2, caster_level do
			omnislash_image:HeroLevelUp(false)
		end
		
		for ability_id=0, 15 do
			local ability = omnislash_image:GetAbilityByIndex(ability_id)
			if ability then
				ability:SetLevel(self.caster:GetAbilityByIndex(ability_id):GetLevel())
			end
		end
		
		for item_id=0, 5 do
			local item_in_caster = self.caster:GetItemInSlot(item_id)
			if item_in_caster ~= nil then
				local item_name = item_in_caster:GetName()
				if not (item_name =="item_smoke_of_deceit" or item_name == "item_ward_observer" or item_name == "item_ward_sentry" or item_name == "item_imba_ironleaf_boots") then
					local item_created = CreateItem (item_in_caster:GetName(), omnislash_image, omnislash_image)
					omnislash_image:AddItem(item_created)
					item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges())
				end
			end
		end
		
        -- Search for buffs and debuffs
        local caster_modifiers = self.caster:FindAllModifiers()
		
		for _,modifier in pairs(caster_modifiers) do
			if modifier:GetName() == "modifier_imba_juggernaut_blade_fury" then
				caster_blade_fury_modifier = self.caster:FindModifierByName("modifier_imba_juggernaut_blade_fury") 
				blade_fury_modifier = omnislash_image:AddNewModifier(omnislash_image, modifier:GetAbility(), modifier:GetName(), {duration = modifier:GetRemainingTime()})
				if blade_fury_modifier then
				blade_fury_modifier.original_caster = self.caster
				blade_fury_modifier.radius = caster_blade_fury_modifier.radius
				end
			elseif modifier.IsPurgable then
				if modifier:IsPurgable() then
				omnislash_image:AddNewModifier(omnislash_image, modifier:GetAbility(), modifier:GetName(), {duration = modifier:GetRemainingTime()})
				end
			end
		end
		
		omnislash_image:SetAbilityPoints(0)

		omnislash_image:SetHasInventory(false)
		omnislash_image:SetCanSellItems(false)
		
		-- Add the image indicator
		omnislash_image:AddNewModifier(self.caster, self, "modifier_imba_omni_slash_image", {})
		
		local omnislash_modifier_handler = omnislash_image:AddNewModifier(omnislash_image, self, "modifier_imba_omni_slash_caster", {})
		
		if omnislash_modifier_handler then
		omnislash_modifier_handler.original_caster = self.caster
		end
		
		FindClearSpaceForUnit(omnislash_image, self.target:GetAbsOrigin() + RandomVector(128), false)
		
		omnislash_image:EmitSound("Hero_Juggernaut.OmniSlash")
		
		Timers:CreateTimer(FrameTime(), function()
		if (not omnislash_image:IsNull()) then
		self.current_position = omnislash_image:GetAbsOrigin()
		
		StartAnimation(omnislash_image, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
		
		omnislash_image:PerformAttack(self.target, true, true, true, true, false, false, false)
		
		-- Play particle trail when moving
		local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, omnislash_image)
		ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
		ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
		ParticleManager:ReleaseParticleIndex(trail_pfx)
		
		end
		end)
	else
	
		local omnislash_modifier_handler = self.caster:AddNewModifier(self.caster, self, "modifier_imba_omni_slash_caster", {original_caster = self.caster})

		if omnislash_modifier_handler then
		omnislash_modifier_handler.original_caster = self.caster
		end
		
		self:SetActivated(false)
		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), self.caster)

		FindClearSpaceForUnit(self.caster, self.target:GetAbsOrigin() + RandomVector(128), false)
		
		self.caster:EmitSound("Hero_Juggernaut.OmniSlash")

		StartAnimation(self.caster, {activity = ACT_DOTA_OVERRIDE_ABILITY_4, rate = 1.0})
		
		if self.target:TriggerSpellAbsorb(self) then
			return nil
		end
		
		Timers:CreateTimer(FrameTime(), function()
		
		self.current_position = self.caster:GetAbsOrigin()
		
		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), nil)
		
		self.caster:PerformAttack(self.target, true, true, true, true, true, false, false)
		
		-- Play particle trail when moving
		local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(trail_pfx, 0, self.previous_position)
		ParticleManager:SetParticleControl(trail_pfx, 1, self.current_position)
		ParticleManager:ReleaseParticleIndex(trail_pfx)
		end)
	end
		
end

modifier_imba_omni_slash_image = modifier_imba_omni_slash_image or class ({})

function modifier_imba_omni_slash_image:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_SUPER_ILLUSION,
				   MODIFIER_PROPERTY_ILLUSION_LABEL,
				   MODIFIER_PROPERTY_IS_ILLUSION,
				   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				   MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
				   MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
				   MODIFIER_EVENT_ON_DEATH}
	
	return funcs
end

function modifier_imba_omni_slash_image:CheckState()
	local state = {[MODIFIER_STATE_UNSELECTABLE] = true,
				   [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
				   [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_INVULNERABLE] = true,
				   [MODIFIER_STATE_NO_HEALTH_BAR] = true,
				   [MODIFIER_STATE_MAGIC_IMMUNE] = true,
					}
				   
    return state
end

function modifier_imba_omni_slash_image:GetIsIllusion()
	return true
end

function modifier_imba_omni_slash_image:GetModifierSuperIllusion()
	return true
end

function modifier_imba_omni_slash_image:GetModifierIllusionLabel()
	return true
end

function modifier_imba_omni_slash_image:OnDeath(keys)
	if keys.unit == self:GetParent() then
		self:GetParent():AddNoDraw()
	end
end

-- Enough for 15 slashes. Lol
function modifier_imba_omni_slash_image:GetModifierAttackSpeedBonus_Constant()
	return -99999999
end

function modifier_imba_omni_slash_image:GetModifierAttackSpeedBaseOverride()
	return -99999999
end

function modifier_imba_omni_slash_image:GetModifierAttackPointConstant()
	return 99999999
end

function modifier_imba_omni_slash_image:IsHidden()
	return true
end

function modifier_imba_omni_slash_image:IsPurgable()
	return false
end

function modifier_imba_omni_slash_image:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

modifier_imba_omni_slash_caster = modifier_imba_omni_slash_caster or class({})

function modifier_imba_omni_slash_caster:OnCreated()
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.base_bonus_damage = self.ability:GetTalentSpecialValueFor("bonus_damage_att")
		self.minimum_damage = self.ability:GetTalentSpecialValueFor("min_damage")
		
		if not self.ability then
			self:Destroy()
			return nil
		end
		
		-- Add the first instance of Omnislash to proc the minimum damage
		self.slash = true
		
		-- Seriously!? Took me 2 hours to fix this. >:(
		if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
		if (not self.caster:IsNull()) then
		if not self.original_caster:HasScepter() then
			self.bounce_range = self.ability:GetTalentSpecialValueFor("bounce_range")
			self.bounce_amt = self.ability:GetTalentSpecialValueFor("jump_amount")
		else
			self.bounce_range = self.ability:GetTalentSpecialValueFor("scepter_bounce_range")
			self.bounce_amt = self.ability:GetTalentSpecialValueFor("scepter_jump_amt")
		end
	
		self.hero_agility = self.original_caster:GetAgility()
		self.ability:SetRefCountsModifiers(false)
		self:StartIntervalThink(self.ability:GetSpecialValueFor("bounce_delay"))
		end
		end)
		end
end

function modifier_imba_omni_slash_caster:OnIntervalThink()
	-- Get the hero Agility while casting Omnislash
	self.hero_agility = self.original_caster:GetAgility()
	self:BounceAndSlaughter()
end

function modifier_imba_omni_slash_caster:BounceAndSlaughter()
	self.nearby_enemies = FindUnitsInRadius(	self.caster:GetTeamNumber(),
												self.caster:GetAbsOrigin(),
												nil,
												self.bounce_range,
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
												DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
												FIND_ANY_ORDER,
												false)	
	if self.bounce_amt >= 1 and #self.nearby_enemies >= 1 then
		for _,enemy in pairs(self.nearby_enemies) do
			local previous_position = self.caster:GetAbsOrigin()
			FindClearSpaceForUnit(self.caster, enemy:GetAbsOrigin() + RandomVector(128), false)
			
			self.caster:MoveToTargetToAttack(enemy)
			
			local current_position = self.caster:GetAbsOrigin()			

			-- Provide vision of the target for a short duration
			self.ability:CreateVisibilityNode(current_position, 300, 1.0)

			-- Perform the slash
			self.slash = true
			
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

function modifier_imba_omni_slash_caster:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
					MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
					MODIFIER_PROPERTY_PRE_ATTACK}

    return decFuncs
end

function modifier_imba_omni_slash_caster:GetModifierBaseAttack_BonusDamage()
	-- Due to one TimeFrame created to recognize the original caster, add an instance to see if the modifier recognizes the original caster
	if self.hero_agility then
	local bonus_damage = self.hero_agility * self.base_bonus_damage * 0.01
	
	-- In case if the lead dev changes mind and allow 2 of these to stack, use self.original_caster than self.caster for versatility. >:3
	if self.original_caster:HasTalent("special_bonus_imba_juggernaut_8") then
		jade_blossom = self.original_caster:FindModifierByName("modifier_imba_juggernaut_blade_dance_jade_blossom")
		if jade_blossom then
			blossomed_damage = self.hero_agility + jade_blossom:GetStackCount()
			bonus_damage = blossomed_damage * self.base_bonus_damage * 0.01 
		end
	end
	
	return bonus_damage
	end
    return 0
end

-- Omnislash's minimum damage handler
function modifier_imba_omni_slash_caster:GetModifierProcAttack_BonusDamage_Physical(kv)
	if IsServer() then
		
		-- If the damage is not conducted by the ability itself, do nothing.
		if not self.slash then
			return nil
		end

		-- If Omnislash's slash damage is less than minimum damage, add the bonus till minimum threshold
		if kv.attacker == self.caster and kv.damage <= self.minimum_damage then
			-- Set the slash ability to false so it won't trigger for normal attacks
			self.slash = false
			return self.minimum_damage - kv.damage
		end
	end
end

function modifier_imba_omni_slash_caster:OnDestroy()
	if IsServer() then
		PlayerResource:SetCameraTarget(self.caster:GetPlayerID(), nil)

		if self.bounce_amt > 1 then
			local rand = RandomInt(1, 2)
			self.caster:EmitSound("juggernaut_jug_ability_waste_0"..rand)
		end
		
		-- If jugg has stopped bouncing, stop the animation.
		if self.bounce_amt == 0 or  #self.nearby_enemies == 0 then
		self.caster:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
		end

		self.ability:SetActivated(true)	
		
		-- Create the delay effect before the image destroys itself.
		if self.caster:HasModifier("modifier_imba_omni_slash_image") then
			if self.caster:HasModifier("modifier_imba_juggernaut_blade_fury") then
				self.caster:RemoveModifierByName("modifier_imba_juggernaut_blade_fury")
			end
			self.caster:MakeIllusion()
			
			Timers:CreateTimer(0.12, function()
			if self.caster:IsAlive() and (not self.caster:IsNull()) then
				self.caster:SetModel("models/development/invisiblebox.vmdl")
			end
			end)
			Timers:CreateTimer(0.6, function()
			if self.caster:IsAlive() and (not self.caster:IsNull()) then
				self.caster:ForceKill(false)
			end
			end)
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

function modifier_imba_omni_slash_caster:IsHidden() return false end
function modifier_imba_omni_slash_caster:IsPurgable() return false end
function modifier_imba_omni_slash_caster:IsDebuff() return false end

LinkLuaModifier("modifier_imba_juggernaut_omni_slash_cdr", "hero/hero_juggernaut", LUA_MODIFIER_MOTION_NONE)
modifier_imba_juggernaut_omni_slash_cdr = modifier_imba_juggernaut_omni_slash_cdr or class({})

function modifier_imba_juggernaut_omni_slash_cdr:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
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
		local cd = self.ability:GetCooldownTimeRemaining()
		self.ability:EndCooldown()
		self.ability:StartCooldown(cd)
	end
end