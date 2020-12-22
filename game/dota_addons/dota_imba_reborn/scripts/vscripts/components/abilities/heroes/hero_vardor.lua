 -- Author: Nibuja: https://steamcommunity.com/profiles/76561198068804194/
-- Editor: EarthSalamander

ListenToGameEvent("npc_spawned", function(keys)
	if not IsServer() then return end

	local npc = EntIndexToHScript(keys.entindex)

	if not IsValidEntity(npc) then
		return
	end

	if npc:GetUnitName() == "npc_dota_hero_vardor" then
		if npc.yari == nil then
			npc:SetContextThink(DoUniqueString("init_vardor"), function()
				Wearable:_WearProp(npc, "127", "body_head")
--				Wearable:_WearProp(npc, "7749", "shoulder")
				Wearable:_WearProp(npc, "9460", "head")
				Wearable:_WearProp(npc, "7747", "belt")
				Wearable:_WearProp(npc, "7746", "arms")
				npc.spear_wearable = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/heroes/vardor/spear_normal.vmdl"})
				npc:SetRenderColor(255, 0, 0)

				local tempParticle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_yari_weak.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, npc)
				ParticleManager:SetParticleControlEnt(tempParticle, 1, npc, PATTACH_POINT_FOLLOW, "attach_weapon", npc:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(tempParticle, 2, npc, PATTACH_POINT_FOLLOW, "attach_spear_end", npc:GetAbsOrigin(), true)
				npc.weaponParticle = tempParticle
			end, 0.2)
		end
	end
end, nil)

LinkLuaModifier("modifier_vardor_yari_unit", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

------------------------
-- YARI UNIT MODIFIER --
------------------------

modifier_vardor_yari_unit = modifier_vardor_yari_unit or class({})

function modifier_vardor_yari_unit:OnCreated(params)
	if IsServer() then
		if not self:GetAbility() or not self:GetCaster() then
			self:GetParent():ForceKill(false)			
			self:RemoveSelf()
			self:Destroy()
		end
	end

	-- Ability properties	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.mind_bleed_modifier = "modifier_vardor_mental_thrusts_debuff"
	self.mental_ability_name = "vardor_mental_thrusts"

	if not IsServer() then return end

	self.is_charge_yari = params.is_charge_yari		

	-- Talent: Grounded Yaris inflict 1 mind bleed stack per second
	if self.caster:HasTalent("special_bonus_vardor_ground_yaris_mind_bleed") then
		self.mind_bleed_stacks = self.caster:FindTalentValue("special_bonus_vardor_ground_yaris_mind_bleed")
		self.radius = self.caster:FindTalentValue("special_bonus_vardor_ground_yaris_mind_bleed", "radius")

		-- Only actually do this if Mental Thrusts has been learned
		if self.caster:HasAbility(self.mental_ability_name) then
			self.mental_ability = self.caster:FindAbilityByName(self.mental_ability_name)
			if self.mental_ability then
				self.duration = self.mental_ability:GetSpecialValueFor("duration")

				self:StartIntervalThink(self.caster:FindTalentValue("special_bonus_vardor_ground_yaris_mind_bleed", "interval"))
			end
		end
	end
end

function modifier_vardor_yari_unit:OnIntervalThink()
	if not IsServer() then return end

	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)		

	for _, enemy in pairs(enemies) do
		if not enemy:HasModifier(self.mind_bleed_modifier) then
			enemy:AddNewModifier(self.caster, self.mental_ability, self.mind_bleed_modifier, {duration = self.duration})
		end

		local modifier = enemy:FindModifierByName(self.mind_bleed_modifier)
		if modifier then
			for i = 1, self.mind_bleed_stacks do			
				modifier:IncrementStackCount()
			end
		end
	end
end

function modifier_vardor_yari_unit:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_VISUAL_Z_DELTA}

	return decFuncs
end

function modifier_vardor_yari_unit:GetVisualZDelta()
	return 100
end

function modifier_vardor_yari_unit:CheckState()
	 return {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true}
end

-- Whenever a yari "dies", it should seek the caster's charges modifier and increase it by one stack
function modifier_vardor_yari_unit:OnDestroy()
	if not IsServer() then return end		

	-- Is it a yari charge? If it isn't, don't grant a charge back to the caster when this unit dies
	if self.is_charge_yari == 0 then return end

	local modifier = self.caster:FindModifierByName("modifier_vardor_piercing_shot_charges")
	if modifier then
		modifier:IncrementStackCount()
	end
end


-------------------
-- PIERCING SHOT --
-------------------
LinkLuaModifier("modifier_vardor_yari_dummy", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_vardor_piercing_shot_charges", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vardor_piercing_shot_target_debuff", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vardor_piercing_shot_root_aura", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vardor_piercing_shot_root_debuff", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

vardor_piercing_shot = vardor_piercing_shot or class({})

function vardor_piercing_shot:GetIntrinsicModifierName()
	return "modifier_vardor_piercing_shot_charges"
end

function vardor_piercing_shot:GetCooldown(level)
	-- This ability is 'unlocked' by having a Yari to cast it with, so no cooldowns are actually used in it.
	return 0
end

function vardor_piercing_shot:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function vardor_piercing_shot:OnUpgrade()
	local caster = self:GetCaster()
	local ability = self
	local modifier_charges = "modifier_vardor_piercing_shot_charges"

	-- Ignore if this is level 1 upgrade as this is done on the modifier creation
	if ability:GetLevel() == 1 then return end

	-- For every upgrade above level 1, check how many new Yaris should be given to the charges modifier
	local previous_yari_count = ability:GetLevelSpecialValueFor("initial_yari_count", ability:GetLevel() - 2)	
	local current_yari_count = ability:GetSpecialValueFor("initial_yari_count")	

	-- If new Yari(s) are supposed to be given, add them to the charges modifier
	if current_yari_count > previous_yari_count then
		local new_yaris = current_yari_count - previous_yari_count
		local modifier = caster:FindModifierByName(modifier_charges)
		if modifier then
			modifier:SetStackCount(modifier:GetStackCount() + new_yaris)
		end
	end
end

function vardor_piercing_shot:OnSpellStart()
	-- Ability properties	
	local caster = self:GetCaster()	
	local ability = self
	local target = ability:GetCursorTarget()
	local modifier_charges = "modifier_vardor_piercing_shot_charges"

	-- If cast on an enemy, set it as the target.
	if target then
		self:PierceTargetUnit(target)
	else
		-- Otherwise, set the ground as the target point
		self:PierceTargetLocation(self:GetCursorPosition(), true)
	end

	-- Use up one yari stack
	local modifier = caster:FindModifierByName(modifier_charges)
	if modifier then
		modifier:DecrementStackCount()
	end
end


function vardor_piercing_shot:PierceTargetUnit(target)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self	

	-- Ability specials
	local hit_radius = ability:GetSpecialValueFor("hit_radius")
	local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local cast_range = self:GetCastRange(caster:GetAbsOrigin(), target) + self:GetCaster():GetCastRangeBonus()	

	-- Calculate direction
	local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()

	-- local particleName = "particles/units/heroes/hero_mars/mars_spear.vpcf"
	local particleName = "particles/hero/vardor/vardor_piercing_shot_linear.vpcf"
	local spear_projectile = {
		Ability = ability,
		EffectName = particleName,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = cast_range,
		fStartRadius = hit_radius,
		fEndRadius = hit_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = true,
		vVelocity = direction * projectile_speed * Vector(1, 1, 0),
		fExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = true,
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber(),		
	}

	ProjectileManager:CreateLinearProjectile(spear_projectile)
end

function vardor_piercing_shot:OnProjectileHit(target, location)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_target = "modifier_vardor_piercing_shot_target_debuff"
	local modifier_charges = "modifier_vardor_piercing_shot_charges"

	-- Ability specials
	local direct_damage = ability:GetSpecialValueFor("direct_damage")
	local spear_duration = ability:GetSpecialValueFor("spear_duration")

	-- If the spear hit a target, then give it the stuck target debuff and deal damage
	if target then

		-- Emit Sound
		EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_EarthSpirit.StoneRemnant.Impact", caster)	

		if not target:HasModifier(modifier_target) then	
			-- Apply target pierce modifier on target and give it one stack
			local modifier = target:AddNewModifier(caster, ability, modifier_target, {duration = spear_duration})
			if modifier then
				modifier:IncrementStackCount()
			end

		else
			-- If the target is already afflicted by a Yari, add a stack
			local modifier = target:FindModifierByName(modifier_target)
			if modifier then
				modifier:IncrementStackCount()
				modifier:ForceRefresh()
			end
		end

		-- Deal damage immediately
		local damageTable = {victim = target,
							attacker = caster,
							damage = direct_damage,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self}

		ApplyDamage(damageTable)

		return true
	else
		-- If the projectile reached its max range without hitting anything, make it 
		location = GetGroundPosition(location, nil)
		self:PierceTargetLocation(location, true)
		return true
	end
end

function vardor_piercing_shot:PierceTargetLocation(target_point, is_charge_yari)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_yari_properties = "modifier_vardor_yari_unit"
	local modifier_root_aura = "modifier_vardor_piercing_shot_root_aura"

	-- Ability specials	
	local damage_ground = ability:GetSpecialValueFor("damage_ground")	
	local radius = ability:GetSpecialValueFor("radius")
	local root_duration = ability:GetSpecialValueFor("root_duration")
	local spawn_delay = ability:GetSpecialValueFor("spawn_delay")
	local spear_duration = ability:GetSpecialValueFor("spear_duration")	

	-- Summon Yari on target location and give it yari properties, kill duration and give it the root aura
	local dummy = CreateUnitByName("npc_dota_vardor_spear_dummy" , target_point, false, caster, caster, caster:GetTeamNumber())        
	dummy:AddNewModifier(caster, self, "modifier_kill", {duration = spear_duration})
	dummy:AddNewModifier(caster, ability, modifier_yari_properties, {is_charge_yari = is_charge_yari})

	dummy:SetModelScale(0)

	-- Apply particles on target area
	local particle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_piercing_shot_ground.vpcf", PATTACH_CUSTOMORIGIN, dummy)
	ParticleManager:SetParticleControl(particle, 0, target_point)
	ParticleManager:SetParticleControl(particle, 2, Vector(radius,0,0))
	ParticleManager:SetParticleControl(particle, 3, Vector(spear_duration,0,0))
	ParticleManager:ReleaseParticleIndex(particle)

	-- Wait for the delay
	Timers:CreateTimer(spawn_delay, function()
		if IsServer() then
			-- Emit Sound
			EmitSoundOnLocationWithCaster(target_point, "Hero_EarthSpirit.StoneRemnant.Impact", caster)	

			dummy:AddNewModifier(caster, ability, modifier_root_aura, {duration = root_duration})

			-- Find all enemies in around the target point
			local enemies = FindUnitsInRadius(  caster:GetTeamNumber(),
												target_point,
												nil,
												radius,
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
												DOTA_UNIT_TARGET_FLAG_NONE,
												FIND_ANY_ORDER,
												false)

			for _, enemy in pairs(enemies) do			
				-- Deal damage to all enemies around the target point						
				local damageTable = {victim = enemy,
									attacker = caster,
									damage = damage_ground,
									damage_type = DAMAGE_TYPE_MAGICAL,
									ability = ability}

				ApplyDamage(damageTable)
			end
		end		
	end)
end

-----------------------------------------
-- PIERCING SHOT YARI CHARGES MODIFIER --
-----------------------------------------

modifier_vardor_piercing_shot_charges = modifier_vardor_piercing_shot_charges or class({})

function modifier_vardor_piercing_shot_charges:IsHidden() return false end
function modifier_vardor_piercing_shot_charges:IsPurgable() return false end
function modifier_vardor_piercing_shot_charges:IsDebuff() return false end
function modifier_vardor_piercing_shot_charges:RemoveOnDeath() return false end
function modifier_vardor_piercing_shot_charges:IsPurgeException() return false end

function modifier_vardor_piercing_shot_charges:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end

		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()

		-- Ability properties
		self.initial_yari_count = self.ability:GetTalentSpecialValueFor("initial_yari_count")

		-- Create a dummy unit to hold the yari particles
		local yariHolder = CreateUnitByName("spearholder_unit", self.caster:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeam())
		-- yariHolder:SetModel("models/dummy.vmdl")
		yariHolder:SetAbsOrigin(self.caster:GetAbsOrigin())
		yariHolder:AddNewModifier(self.caster, self.ability, "modifier_vardor_yari_dummy", {EntIndex = self.caster:entindex(), Count = self.initial_yari_count})
		self.yariHolder = yariHolder
		self.yariHolder:SetModelScale(0.7)
		self.yariManager =  self.yariHolder:FindModifierByName("modifier_vardor_yari_dummy")

		-- Set initial stacks of the yari
		self:SetStackCount(self.initial_yari_count)

		self:StartIntervalThink(10)
	end
end

function modifier_vardor_piercing_shot_charges:OnIntervalThink()
	-- The role of this interval is to make sure if something weird happened that caused a loss of the ability charges it would readjust the stacks
	-- Yaris can either be on the ground or stuck on enemies.

	-- Expected charges
	local expected_charges = self.ability:GetTalentSpecialValueFor("initial_yari_count")

	-- Check for yaris being laid down on the ground
	local yaris = 0	
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
    
	for _, unit in pairs(units) do
		if unit:GetUnitName() == "npc_dota_vardor_spear_dummy" then
            -- Check if it has the is_charge_yari property
            local modifier = unit:FindModifierByName("modifier_vardor_yari_unit")
            if modifier.is_charge_yari == 1 then
    			-- Found a valid Yari!
    			yaris = yaris + 1
            end
		end
	end    

	-- Check for enemies with stuck yaris debuff on them	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_DAMAGE_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		if enemy:HasModifier("modifier_vardor_piercing_shot_target_debuff") then
			local modifier_debuff = enemy:FindModifierByName("modifier_vardor_piercing_shot_target_debuff")
			if modifier_debuff then
				-- Found a yari!
				yaris = yaris + modifier_debuff:GetStackCount()
			end
		end
	end

	-- Get how much yaris are currently unused
	local stacks = self:GetStackCount()

	-- At the end of this check, the amount of found yaris should be equal to the expected amount
	local found_yaris = yaris + stacks
	if found_yaris ~= expected_charges then		
		self:SetStackCount(expected_charges)
	end
end

function modifier_vardor_piercing_shot_charges:OnStackCountChanged(previous_stacks)
	if not IsServer() then return end

	-- If there are no more yaris to use, disable the ability
	if self:GetStackCount() <= 0 then
		self.ability:SetActivated(false)			

	-- If the ability is disabled and the stacks is now on at least one, activate it.
	elseif not self.ability:IsActivated() then
		self.ability:SetActivated(true)
	end

	local caster = self:GetCaster()
	local casterLoc = caster:GetAbsOrigin()

	-- Destroy other weapon effect
	if caster.weaponParticle then
		ParticleManager:DestroyParticle(caster.weaponParticle, true)
		caster.weaponParticle = false
	end

	-- If there are no available yaris, change the weapon to weak version
	if self:GetStackCount() == 0 then

		local tempParticle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_yari_weak.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(tempParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon", casterLoc, true)
		ParticleManager:SetParticleControlEnt(tempParticle, 2, caster, PATTACH_POINT_FOLLOW, "attach_spear_end", casterLoc, true)
		caster.weaponParticle = tempParticle

	-- If there is atleast one yari swap to normal version
	elseif self:GetStackCount() > 0 then

		-- check if the return effect should be oppressed (e.g. when jumping)
		local ret = 1
		if caster.oppressReturn then
			if caster.oppressReturn == true then
				ret = 0
			end
		end
		if previous_stacks > 0 then
			ret = 0
		end

		local tempParticle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_yari_normal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
		ParticleManager:SetParticleControlEnt(tempParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon", casterLoc, true)
		ParticleManager:SetParticleControlEnt(tempParticle, 2, caster, PATTACH_POINT_FOLLOW, "attach_spear_end", casterLoc, true)
		caster.weaponParticle = tempParticle

	end
	if self.yariManager then
		self.yariManager:ChangeCount(self:GetStackCount())
	end
end

modifier_vardor_yari_dummy = class({})

function modifier_vardor_yari_dummy:CheckState()   
	local state = {
					[MODIFIER_STATE_UNSELECTABLE] = true,
					[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_NO_HEALTH_BAR] = true,
					[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
					[MODIFIER_STATE_ATTACK_IMMUNE] = true,
					[MODIFIER_STATE_MAGIC_IMMUNE] = true,
				}
	return state
end

function modifier_vardor_yari_dummy:OnCreated(event)
	if IsServer() then
		self.target = EntIndexToHScript(event.EntIndex)
		self:StartIntervalThink(0.005)

		-- Init particle table for yaris
		self.particles = {}
		self:ChangeCount(event.Count)
		self.currentCount = event.Count
		if not self.currentCount then self.currentCount = 0 end
		self.lastCount = self.currentCount
	end
end

function modifier_vardor_yari_dummy:ChangeCount(newCount, reapply)

	local parent = self:GetParent()
	local attachment = self.target:ScriptLookupAttachment("attach_hitloc")
	local targetLoc = self.target:GetAttachmentOrigin(attachment)
	local targetVec = self.target:GetForwardVector()

	parent:SetAbsOrigin(targetLoc)
	parent:SetForwardVector(targetVec)

	-- check if the return effect should be oppressed (e.g. when jumping)
	local ret = 1
	if self.target.oppressReturn then
		if self.target.oppressReturn == true then
			ret = 0
		end
	end

	-- start checks
	local startIndex = 2
	if not self.currentCount then self.currentCount = 0 end
	if not newCount then newCount = 0 end

	if reapply then
		-- Remove all yari particles
		for _,particle in pairs(self.particles) do
			ParticleManager:DestroyParticle(particle, true)
		end
		self.particles = {}
	else
		if newCount == self.currentCount then
			-- return, since we don't change anything
			return

		elseif newCount > self.currentCount then
			-- add a new yari, so just set the startIndex
			startIndex = self.currentCount + 1
			if startIndex < 2 then
				self.currentCount = newCount
				return
			end

		else
			-- remove old yari effects
			for i=newCount + 1,10 do
				if self.particles[i] then
					ParticleManager:DestroyParticle(self.particles[i], true)
				end
			end
			self.currentCount = newCount
			return

		end
	end

	-- Add new belt yaris, if the new count is atleast 2 (so one is stored on the back)
	for i=startIndex, newCount do
		local particleIndex = tostring(i - 1)

		local tempParticle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_yari_belt_smoother.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(tempParticle, 10, Vector(ret, 0, 0))
		ParticleManager:SetParticleControlEnt(tempParticle, 6, parent, PATTACH_POINT_FOLLOW, "spear_pos_"..particleIndex.."_end", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(tempParticle, 7, parent, PATTACH_POINT_FOLLOW, "spear_pos_"..particleIndex, parent:GetAbsOrigin(), true)
		
		self.particles[i] = tempParticle
	end

	self.currentCount = newCount
end

function modifier_vardor_yari_dummy:Hide(refresh)
	-- Remove all yari particles
	for _,particle in pairs(self.particles) do
		ParticleManager:DestroyParticle(particle, true)
	end
	self.particles = {}
	self.lastCount = self.currentCount
	self.currentCount = 0

	-- if refresh is given, EndHide immidiatly
	if refresh then
		self:EndHide()
	end
end

function modifier_vardor_yari_dummy:EndHide(stackCount)
	-- Reapply the yari particles after a short delay
	Timers:CreateTimer({
		endTime = 0.05,
		callback = function()
			if not stackCount then
				stackCount = self.lastCount or self.currentCount
			end

			self:ChangeCount(stackCount, true)
		end
	})
end

function modifier_vardor_yari_dummy:OnIntervalThink()
	if IsServer() then
		if self.target then
			-- Move the dummy alongside the hero
			local attachment = self.target:ScriptLookupAttachment("attach_hitloc")
			local targetLoc = self.target:GetAttachmentOrigin(attachment)
			local targetVec = self.target:GetForwardVector()

			-- if the distance is too big, hide and teleport the yari particles
			local oldLoc = self:GetParent():GetAbsOrigin()
			local distance = (oldLoc - targetLoc):Length2D()
			if distance > 600 then
				self:Hide(true)
			end

			self:GetParent():SetAbsOrigin(targetLoc)
			self:GetParent():SetForwardVector(targetVec)
		end
	end
end

function modifier_vardor_yari_dummy:OnDestroy()
	if IsServer() then
		for _,particle in pairs(self.particles) do
			ParticleManager:DestroyParticle(particle, true)
		end
	end
end


------------------------------------------
-- PIERCING SHOT TARGET DEBUFF MODIFIER --
------------------------------------------

modifier_vardor_piercing_shot_target_debuff = modifier_vardor_piercing_shot_target_debuff or class({})

function modifier_vardor_piercing_shot_target_debuff:IsHidden() return false end
function modifier_vardor_piercing_shot_target_debuff:IsPurgable() return true end
function modifier_vardor_piercing_shot_target_debuff:IsDebuff() return true end

function modifier_vardor_piercing_shot_target_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_mind_bleed = "modifier_vardor_mental_thrusts_debuff"

	-- Ability specials
	self.think_interval = self.ability:GetSpecialValueFor("think_interval")
	self.slow_pct = self.ability:GetSpecialValueFor("slow_pct")
	self.mind_bleed_stacks = self.ability:GetSpecialValueFor("mind_bleed_stacks")
	self.damage_over_time_target = self.ability:GetSpecialValueFor("damage_over_time_target")

	-- Calculate actual damage on each interval tick
	self.damage_per_tick = self.damage_over_time_target * self.think_interval

	if IsServer() then
		-- Add pierced shot particle on target
		local particleName = "particles/hero/vardor/vardor_piercing_shot_debuff.vpcf"
		if self.parent:IsHero() then particleName = "particles/hero/vardor/vardor_piercing_shot_debuff_hero.vpcf" end
		self.debuffParticle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, self.parent)		
		ParticleManager:SetParticleControlEnt(self.debuffParticle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.debuffParticle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.debuffParticle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

		-- Start thinking!	
		self:StartIntervalThink(self.think_interval)
	end
end

function modifier_vardor_piercing_shot_target_debuff:OnIntervalThink()	
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- Deal damage	
	local damageTable = {victim = self.parent,
						attacker = self.caster,
						damage = self.damage_per_tick * stacks,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self.ability}

	ApplyDamage(damageTable)

	-- Check if Vardor has or learned Mental Thrusts	
	if self.caster:HasAbility("vardor_mental_thrusts") then		
		local ability_thrust = self.caster:FindAbilityByName("vardor_mental_thrusts")
		if ability_thrust then			
			if ability_thrust:GetLevel() > 0 then			

				-- Get duration of the Mental Thrusts
				local duration = ability_thrust:GetSpecialValueFor("duration")

				-- Add the Mind Bleed modifier to the target if he doesn't have it already
				if not self.parent:HasModifier(self.modifier_mind_bleed) then
					self.parent:AddNewModifier(self.caster, ability_thrust, self.modifier_mind_bleed, {duration = duration})
				end

				-- Add Mind Bleed stacks every tick to the target
				local modifier = self.parent:FindModifierByName(self.modifier_mind_bleed)
				if modifier then
					-- Determine how many new stacks will be given this interval
					local stacks_to_add = self.mind_bleed_stacks * stacks
					for i = 1, stacks_to_add do
						modifier:IncrementStackCount()
					end
				end
			end
		end
	end
end

function modifier_vardor_piercing_shot_target_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					  MODIFIER_PROPERTY_TOOLTIP,
					  MODIFIER_PROPERTY_TOOLTIP2}

	return decFuncs
end

function modifier_vardor_piercing_shot_target_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct * self:GetStackCount() * (-1)
end

function modifier_vardor_piercing_shot_target_debuff:OnDestroy()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- Return all the Yari(s) to the caster, according to the amount of 
		if self.caster:HasModifier("modifier_vardor_piercing_shot_charges") then
			local modifier = self.caster:FindModifierByName("modifier_vardor_piercing_shot_charges")
			if modifier then
				modifier:SetStackCount(modifier:GetStackCount() + stacks)
			end
		end

		-- Remove the spear particle
		ParticleManager:DestroyParticle(self.debuffParticle, false)
		ParticleManager:ReleaseParticleIndex(self.debuffParticle)
	end
end

function modifier_vardor_piercing_shot_target_debuff:OnTooltip()
	return self.damage_per_tick * self:GetStackCount()
end

function modifier_vardor_piercing_shot_target_debuff:OnTooltip2()
	return self.mind_bleed_stacks * self:GetStackCount()
end

--------------------------------------
-- PIERCING SHOT ROOT AURA MODIFIER --
--------------------------------------

modifier_vardor_piercing_shot_root_aura = modifier_vardor_piercing_shot_root_aura or class({})

function modifier_vardor_piercing_shot_root_aura:IsHidden() return true end
function modifier_vardor_piercing_shot_root_aura:IsPurgable() return false end
function modifier_vardor_piercing_shot_root_aura:IsDebuff() return false end

function modifier_vardor_piercing_shot_root_aura:OnCreated()
	if IsServer() then 
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties	
	self.ability = self:GetAbility()	

	-- Ability specials
	self.radius = self.ability:GetSpecialValueFor("radius")
end

function modifier_vardor_piercing_shot_root_aura:IsAura() return true end
function modifier_vardor_piercing_shot_root_aura:GetAuraDuration() return 0.5 end
function modifier_vardor_piercing_shot_root_aura:GetAuraRadius() return self.radius end
function modifier_vardor_piercing_shot_root_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_vardor_piercing_shot_root_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_vardor_piercing_shot_root_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_vardor_piercing_shot_root_aura:GetModifierAura() return "modifier_vardor_piercing_shot_root_debuff" end

----------------------------------------
-- PIERCING SHOT ROOT DEBUFF MODIFIER --
----------------------------------------

modifier_vardor_piercing_shot_root_debuff = modifier_vardor_piercing_shot_root_debuff or class({})

function modifier_vardor_piercing_shot_root_debuff:IsHidden() return false end
function modifier_vardor_piercing_shot_root_debuff:IsPurgable() return false end
function modifier_vardor_piercing_shot_root_debuff:IsDebuff() return true end

function modifier_vardor_piercing_shot_root_debuff:CheckState()
	 return {[MODIFIER_STATE_ROOTED] = true}	
end

function modifier_vardor_piercing_shot_root_debuff:GetEffectName()
	return "particles/hero/vardor/vardor_piercing_shot_root.vpcf"
end

function modifier_vardor_piercing_shot_root_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------
-- GRACEFUL JUMP --
-------------------

LinkLuaModifier("modifier_vardor_graceful_jump", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vardor_graceful_jump_root", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_charges", "components/modifiers/generic/modifier_generic_charges", LUA_MODIFIER_MOTION_NONE)

vardor_graceful_jump = vardor_graceful_jump or class({})

function vardor_graceful_jump:GetIntrinsicModifierName()
	return "modifier_generic_charges"
end

function vardor_graceful_jump:GetAOERadius()
	return self:GetSpecialValueFor("yari_search_radius")
end

function vardor_graceful_jump:CastFilterResultLocation(location)	
	if not IsServer() then return end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_range = self:GetCastRange(location, target)

	-- Ability specials
	local yari_search_radius = ability:GetSpecialValueFor("yari_search_radius")

	-- Look for a Yari in the cast range + search radius to ease using nearby Yaris
	yari_search_radius = yari_search_radius + cast_range

	-- Look for a Yari unit around the target location in the radius 
	local units = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, yari_search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

	for _, unit in pairs(units) do
		if unit:GetUnitName() == "npc_dota_vardor_spear_dummy" then
			-- Found a Yari!
			return UF_SUCCESS			
		end
	end

	-- If we're here, we didn't find any Yaris in range: show custom cast error
	return UF_FAIL_CUSTOM
end

function vardor_graceful_jump:GetCustomCastErrorLocation()
	return "#dota_hud_error_vardor_no_yaris_in_range"
end

function vardor_graceful_jump:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local modifier_ball = "modifier_vardor_graceful_jump"	
	local cast_range = self:GetCastRange(self:GetCursorPosition(), target)

	-- Ability specials
	local yari_search_radius = ability:GetSpecialValueFor("yari_search_radius")
	local jump_speed = ability:GetSpecialValueFor("jump_speed")	

	-- If no target was found and the ability still started, that means there is a Yari around the cast point
	if not target then
		-- Look for a Yari in the cast range + search radius to ease using nearby Yaris
		yari_search_radius = yari_search_radius + cast_range

		-- Find the closest Yari!

		local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, yari_search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

		for _, unit in pairs(units) do
			if unit:GetUnitName() == "npc_dota_vardor_spear_dummy" then
				-- Found the Yari!
				target = unit
				break
			end	
		end
	end

	-- If SOMEHOW there's still no targets, fail to cast and refund
	if not target then
		print("NO YARI I TOLD YOU WTF IS WRONG WITH YOU")
		self:EndCooldown()
		self:RefundManaCost()

		-- refund charge (todo: modifier_generic_charges:RefreshCharges() helper)
		if self:GetCaster():HasModifier("modifier_generic_charges") then
			for _, mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_generic_charges")) do
				if mod:GetAbility():GetAbilityName() == self:GetAbilityName() then
					mod:SetStackCount(mod:GetStackCount() + 1)
					break
				end
			end
		end

		DisplayError(self:GetCaster():GetPlayerID(), "#dota_hud_error_vardor_no_yaris_in_range")

		return
	end

	-- Emit sound
	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_SkywrathMage.ConcussiveShot.Cast", caster)

	-- Become a ball of light and travel quickly towards the target!
	caster:AddNewModifier(caster, ability, modifier_ball, {})

	-- Fire yourself as a projectile!
	local particleName = "particles/hero/vardor/vardor_graceful_jump_projectile.vpcf"
	local projectileTable = {
				Source = caster,
				Target = target,
				Ability = self,  
				EffectName = particleName,
				iMoveSpeed = jump_speed,
				vSourceLoc= caster:GetAbsOrigin(),             -- Optional (HOW)
				bDrawsOnMinimap = false,                          -- Optional
				bDodgeable = true,                             -- Optional
				bIsAttack = false,                              -- Optional
				bVisibleToEnemies = true,                        -- Optional
				bReplaceExisting = false,                        -- Optional
				bProvidesVision = true,                        -- Optional
				iVisionRadius = 400,                              -- Optional
				iVisionTeamNumber = caster:GetTeamNumber()      -- Optional
			}      
	ProjectileManager:CreateTrackingProjectile(projectileTable)
end

function vardor_graceful_jump:OnProjectileHit(target, location)	
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_ball = "modifier_vardor_graceful_jump"
	local modifier_charges = "modifier_vardor_piercing_shot_charges"
	local modifier_yari_debuff = "modifier_vardor_piercing_shot_target_debuff"
	local modifier_root = "modifier_vardor_graceful_jump_root"

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local damage_radius = ability:GetSpecialValueFor("damage_radius")	

	-- Remove the modifier from the caster
	if caster:HasModifier(modifier_ball) then
		caster:RemoveModifierByName(modifier_ball)
	end

	-- Emit sound
	EmitSoundOnLocationWithCaster(location, "Hero_SkywrathMage.ConcussiveShot.Target", caster)

	-- Show hit particle
	local particle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_graceful_jump_ground.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 1, location)
	ParticleManager:ReleaseParticleIndex(particle)

	-- Set the caster on the hit location and give it a valid space to land on
	FindClearSpaceForUnit(caster, location, true)

	-- Find all enemies in range and deal damage to them
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, enemy in pairs(enemies) do
		local damageTable = {victim = enemy,
						attacker = caster,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = ability}

		ApplyDamage(damageTable)

		-- Talent: Graceful Jump also roots all nearby enemies
		if caster:HasTalent("special_bonus_vardor_graceful_jump_root") then
			local root_duration = caster:FindTalentValue("special_bonus_vardor_graceful_jump_root")
			if root_duration ~= 0 then
				enemy:AddNewModifier(caster, ability, modifier_root, {duration = root_duration})
			end
		end
	end

	-- If for some reason we didn't hit the target, do nothing else.
	if not target then return end

	-- If target was a yari, destroy it and retrieve a charge
	if target:GetUnitName() == "npc_dota_vardor_spear_dummy" then
		target:ForceKill(false)
		target:RemoveSelf()

	-- If target was an enemy hero, find if he has Yari stacks and consume one stack.
	else
		if target:HasModifier(modifier_yari_debuff) and caster:HasModifier(modifier_charges) then
			local modifier_debuff = target:FindModifierByName(modifier_yari_debuff)
			local modifier_charges_buff = caster:FindModifierByName(modifier_charges)
			if modifier_debuff and modifier_charges_buff then
				 if modifier_debuff:GetStackCount() > 1 then
					-- If a stack was reduced without the modifier being destroyed, a stack needs to be given back to the caster				 	
					modifier_debuff:DecrementStackCount()
					modifier_charges_buff:IncrementStackCount()
				 else
					-- No stacks left, modifier can be destroyed.
					modifier_debuff:Destroy()
				 end
			end
		end
	end

	-- Find the yari count modifier
	local yariModifier = caster:FindModifierByName(modifier_charges)
	if yariModifier then

		-- Hide the additional yaris for the jump
		caster.oppressReturn = false

		if yariModifier.yariManager then
			yariModifier.yariManager:EndHide(yariModifier:GetStackCount())
		end
	end
end


-----------------------------------
-- GRACEFUL JUMP TRAVEL MODIFIER --
-----------------------------------

modifier_vardor_graceful_jump = modifier_vardor_graceful_jump or class({})

function modifier_vardor_graceful_jump:IsHidden() return true end
function modifier_vardor_graceful_jump:IsPurgable() return false end
function modifier_vardor_graceful_jump:IsDebuff() return false end

function modifier_vardor_graceful_jump:OnCreated()
	if not IsServer() then return end

	self:GetParent():AddNoDraw()

	-- Find the yari count modifier
	local yariModifier = self:GetParent():FindModifierByName("modifier_vardor_piercing_shot_charges")
	if yariModifier then

		-- Hide the additional yaris for the jump
		self:GetParent().oppressReturn = true

		if yariModifier.yariManager then
			yariModifier.yariManager:Hide()
		end
	end
end

function modifier_vardor_graceful_jump:CheckState()
	 return {
	[MODIFIER_STATE_INVULNERABLE] = true,			
	[MODIFIER_STATE_STUNNED] = true}
end

function modifier_vardor_graceful_jump:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveNoDraw()
end


---------------------------------
-- GRACEFUL JUMP ROOT MODIFIER --
---------------------------------

modifier_vardor_graceful_jump_root = modifier_vardor_graceful_jump_root or class({})

function modifier_vardor_graceful_jump_root:GetTexture()
	return "custom/vardor/vardor_graceful_jump"
end

function modifier_vardor_graceful_jump_root:IsHidden() return false end
function modifier_vardor_graceful_jump_root:IsPurgable() return true end
function modifier_vardor_graceful_jump_root:IsDebuff() return true end

function modifier_vardor_graceful_jump_root:CheckState()
	return {[MODIFIER_STATE_ROOTED] = true}
end

function modifier_vardor_graceful_jump_root:GetEffectName()
	return "particles/piercing_shot_ground_root.vpcf"
end

function modifier_vardor_graceful_jump_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------
-- MENTAL THRUSTS --
--------------------
LinkLuaModifier("modifier_vardor_mental_thrusts", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vardor_mental_thrusts_debuff", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

vardor_mental_thrusts = vardor_mental_thrusts or class({})

function vardor_mental_thrusts:GetIntrinsicModifierName()
	return "modifier_vardor_mental_thrusts"
end

------------------------------------
-- MENTAL THRUSTS ATTACK MODIFIER --
------------------------------------

modifier_vardor_mental_thrusts = modifier_vardor_mental_thrusts or class({})

function modifier_vardor_mental_thrusts:IsHidden() return true end
function modifier_vardor_mental_thrusts:IsPurgable() return false end
function modifier_vardor_mental_thrusts:IsDebuff() return false end

function modifier_vardor_mental_thrusts:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()	
	self.modifier_debuff = "modifier_vardor_mental_thrusts_debuff"

	-- Ability specials
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_vardor_mental_thrusts:DeclareFunctions()
	local decFuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return decFuncs
end

function modifier_vardor_mental_thrusts:OnAttackLanded(keys)
	if not IsServer() then return end

	local attacker = keys.attacker
	local target = keys.target

	-- Only apply on attacks that the caster did on an enemy
	if attacker == self.caster and attacker:GetTeamNumber() ~= target:GetTeamNumber() then

		-- Does not apply if the attacker's passive are broken
		if attacker:PassivesDisabled() then
			return 
		end

		-- Does not apply if the attacker is an illusion
		if attacker:IsIllusion() then
			return
		end

		-- Does not apply on wards or buildings
		if target:IsBuilding() or target:IsOther() then
			return
		end

		-- Does not apply on magic immune enemies
		if target:IsMagicImmune() then
			return
		end

		-- If target doesn't have Mind Bleed debuff yet, apply a new stack
		if not target:HasModifier(self.modifier_debuff) then
			target:AddNewModifier(self.caster, self.ability, self.modifier_debuff, {duration = self.duration})
		end

		-- Increase the stacks of the debuff by 1
		local modifier = target:FindModifierByName(self.modifier_debuff)
		if modifier then
			modifier:IncrementStackCount()
		end
	end
end

------------------------------------
-- MENTAL THRUSTS DEBUFF MODIFIER --
------------------------------------

modifier_vardor_mental_thrusts_debuff = modifier_vardor_mental_thrusts_debuff or class({})

function modifier_vardor_mental_thrusts_debuff:IsHidden() return false end
function modifier_vardor_mental_thrusts_debuff:IsPurgable() return true end
function modifier_vardor_mental_thrusts_debuff:IsHidden() return false end

function modifier_vardor_mental_thrusts_debuff:GetTexture()
	return "custom/vardor/vardor_mental_thrusts"
end

function modifier_vardor_mental_thrusts_debuff:OnCreated()
	if IsServer() then
		if not self:GetAbility() then self:Destroy() end
	end

	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	-- Ability specials
	self.aspd_rdct_stack = self.ability:GetSpecialValueFor("aspd_rdct_stack")
	self.cast_point_inc_stack = self.ability:GetSpecialValueFor("cast_point_inc_stack")
	self.main_att_rdct_stack = self.ability:GetSpecialValueFor("main_att_rdct_stack")
	self.incoming_dmg_inc_stack = self.ability:GetSpecialValueFor("incoming_dmg_inc_stack")	
	self.duration = self.ability:GetSpecialValueFor("duration")

	-- Talent: Mind Bleed stacks are twice as effective
	if self.caster:HasTalent("special_bonus_vardor_mental_thrusts_bonus") then
		local talent_multiplier = self.caster:FindTalentValue("special_bonus_vardor_mental_thrusts_bonus")

		if talent_multiplier ~= 0 then
			self.aspd_rdct_stack = self.aspd_rdct_stack * talent_multiplier
			self.cast_point_inc_stack = self.cast_point_inc_stack * talent_multiplier
			self.main_att_rdct_stack = self.main_att_rdct_stack * talent_multiplier
			self.incoming_dmg_inc_stack = self.incoming_dmg_inc_stack * talent_multiplier
		end
	end

	-- Initialize stacks table
	self.stack_table = {}

	if IsServer() then
		self.debuff_particle = ParticleManager:CreateParticle("particles/hero/vardor/vardor_mind_bleed_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent) 
		ParticleManager:SetParticleControl(self.debuff_particle, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.debuff_particle, false, false, -1, false, true)

		-- Start thinking
		self:StartIntervalThink(1)
	end
end

function modifier_vardor_mental_thrusts_debuff:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end

	local stacks = self:GetStackCount()

	-- We only care about stack incrementals
	if stacks > prev_stacks then
		-- Insert the current game time of the stack that was just added to the stack table
		table.insert(self.stack_table, GameRules:GetGameTime())

		-- Refresh timer
		self:ForceRefresh()
	end

	if self.parent:IsHero() then
		self.parent:CalculateStatBonus(true)
	end
end

function modifier_vardor_mental_thrusts_debuff:OnIntervalThink()	
	local repeat_needed = true

	-- We'll repeat the table removal check and remove as many expired items from it as needed.
	while repeat_needed do
		-- Check if the firstmost entry in the table has expired
		local item_time = self.stack_table[1]

		-- If the difference between times is longer, it's time to get rid of a stack
		if GameRules:GetGameTime() - item_time >= self.duration then

			-- Check if there is only one stack, which would mean bye bye debuff
			if self:GetStackCount() == 1 then
				self:Destroy()
				break
			else
				-- Remove the entry from the table
				table.remove(self.stack_table, 1)

				-- Decrement a stack
				self:DecrementStackCount()
			end
		else
			-- If no more items need to be removed, no need to repeat the table
			repeat_needed = false
		end
	end
end

function modifier_vardor_mental_thrusts_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					  MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
					  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					  MODIFIER_PROPERTY_TOOLTIP}

	return decFuncs
end

function modifier_vardor_mental_thrusts_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.aspd_rdct_stack * self:GetStackCount() * (-1)
end

function modifier_vardor_mental_thrusts_debuff:GetModifierPercentageCasttime()
	return self.cast_point_inc_stack * self:GetStackCount() * (-1)
end

function modifier_vardor_mental_thrusts_debuff:GetModifierBonusStats_Strength()
	if not self.parent:IsHero() then return end

	if self.parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
		return self.main_att_rdct_stack * self:GetStackCount() * (-1)
	end

	return 0
end

function modifier_vardor_mental_thrusts_debuff:GetModifierBonusStats_Agility()
	if not self.parent:IsHero() then return end

	if self.parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then
		return self.main_att_rdct_stack * self:GetStackCount() * (-1)
	end

	return 0
end

function modifier_vardor_mental_thrusts_debuff:GetModifierBonusStats_Intellect()
	if not self.parent:IsHero() then return end

	if self.parent:GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then
		return self.main_att_rdct_stack * self:GetStackCount() * (-1)
	end

	return 0
end

function modifier_vardor_mental_thrusts_debuff:GetModifierIncomingDamage_Percentage()
	return self.incoming_dmg_inc_stack * self:GetStackCount()
end

function modifier_vardor_mental_thrusts_debuff:OnTooltip()
	return self.main_att_rdct_stack * self:GetStackCount() * (-1)
end


----------------------------
-- CELESTIAL RAIN OF YARI --
----------------------------

vardor_celestial_rain_of_yari = vardor_celestial_rain_of_yari or class({})

function vardor_celestial_rain_of_yari:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self

	-- Aghs effect: Adds an additional ring
	if caster:HasScepter() then
		return self:GetSpecialValueFor("scepter_aoe_radius")
	end

	return self:GetSpecialValueFor("aoe_radius")

end

function vardor_celestial_rain_of_yari:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target_point = ability:GetCursorPosition()	
	local piercing_shot_ability_name = "vardor_piercing_shot"

	-- Ability specials
	local initial_yari = ability:GetSpecialValueFor("initial_yari")
	local additional_rings = ability:GetSpecialValueFor("additional_rings")
	local additional_yaris_per_ring = ability:GetSpecialValueFor("additional_yaris_per_ring")
	local ring_distance = ability:GetSpecialValueFor("ring_distance")
	local yari_fall_delay = ability:GetSpecialValueFor("yari_fall_delay")
	local scepter_additional_rings = ability:GetSpecialValueFor("scepter_additional_rings")

	-- Scepter effect: Adds an additional ring
	if caster:HasScepter() then
		additional_rings = scepter_additional_rings
	end

	-- Starting direction
	local direction = (target_point - caster:GetAbsOrigin()):Normalized()

	-- Find the Piercing Shot ability. Without it, this ultimate is wasted and does not functions!!
	local piercing_shot_ability
	if caster:HasAbility(piercing_shot_ability_name) then
		piercing_shot_ability = caster:FindAbilityByName(piercing_shot_ability_name)
		if not piercing_shot_ability then
			return
		end
	else
		return
	end

	-- Drop the initial yari exactly in the center
	piercing_shot_ability:PierceTargetLocation(target_point, false)
	
	-- Initialize variables
	local yari_count = initial_yari
	local distance_from_center = 0	
	local new_point = target_point	
	local angle
	local yari_drop_points = {}

	for i = 1, additional_rings do
		-- Define the new ring values
		yari_count = yari_count + additional_yaris_per_ring
		distance_from_center = distance_from_center + ring_distance
		
		-- Start raining yaris on the ring!
		for j = 1, yari_count do					

			angle = QAngle(0, (j-1) * (360/yari_count), 0)
			new_point = target_point + distance_from_center * direction			
			new_point = RotatePosition(target_point, angle, new_point)
			new_point = GetGroundPosition(new_point, nil)	
			
			-- Insert point to the table
			table.insert(yari_drop_points, new_point)
		end
	end

	Timers:CreateTimer(yari_fall_delay, function()
		local point = table.remove(yari_drop_points, 1)

		-- Spawn a Yari at chosen point
		piercing_shot_ability:PierceTargetLocation(point, false)

		-- Check if there are anymore points in the table
		if next(yari_drop_points) ~= nil then
			return yari_fall_delay
		end

		return
	end)
	
end




---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_vardor_bonus_yari", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_vardor_bonus_yari = modifier_special_bonus_vardor_bonus_yari or class({})

function modifier_special_bonus_vardor_bonus_yari:IsHidden() 		return true end
function modifier_special_bonus_vardor_bonus_yari:IsPurgable()		return false end
function modifier_special_bonus_vardor_bonus_yari:RemoveOnDeath() 	return false end

function modifier_special_bonus_vardor_bonus_yari:OnCreated()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local charges_modifier_name = "modifier_vardor_piercing_shot_charges"

	if caster:HasModifier(charges_modifier_name) then
		local modifier = caster:FindModifierByName(charges_modifier_name)
		if modifier then
			modifier:IncrementStackCount()
		end
	else
		-- In case for some reason the user doesn't have the modifier, wait for him to have it and check periodically
		self:StartIntervalThink(5)		
	end
end

function modifier_special_bonus_vardor_bonus_yari:OnIntervalThink()
	if caster:HasModifier(charges_modifier_name) then
		local modifier = caster:FindModifierByName(charges_modifier_name)
		if modifier then
			modifier:IncrementStackCount()
		end
		self:StartIntervalThink(-1)
	end
end

LinkLuaModifier("modifier_special_bonus_vardor_ground_yaris_mind_bleed", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_vardor_ground_yaris_mind_bleed	= modifier_special_bonus_vardor_ground_yaris_mind_bleed or class({})

function modifier_special_bonus_vardor_ground_yaris_mind_bleed:IsHidden() 		return true end
function modifier_special_bonus_vardor_ground_yaris_mind_bleed:IsPurgable()		return false end
function modifier_special_bonus_vardor_ground_yaris_mind_bleed:RemoveOnDeath() 	return false end


LinkLuaModifier("modifier_special_bonus_vardor_graceful_jump_root", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_vardor_graceful_jump_root	= modifier_special_bonus_vardor_graceful_jump_root or class({})

function modifier_special_bonus_vardor_graceful_jump_root:IsHidden() 		return true end
function modifier_special_bonus_vardor_graceful_jump_root:IsPurgable()		return false end
function modifier_special_bonus_vardor_graceful_jump_root:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_vardor_mental_thrusts_bonus", "components/abilities/heroes/hero_vardor", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_vardor_mental_thrusts_bonus	= modifier_special_bonus_vardor_mental_thrusts_bonus or class({})

function modifier_special_bonus_vardor_mental_thrusts_bonus:IsHidden() 		return true end
function modifier_special_bonus_vardor_mental_thrusts_bonus:IsPurgable()		return false end
function modifier_special_bonus_vardor_mental_thrusts_bonus:RemoveOnDeath() 	return false end