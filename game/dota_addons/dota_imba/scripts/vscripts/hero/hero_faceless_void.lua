
--	Author		 - Zimberzimber
--	Date Created - 22.03.2017

CreateEmptyTalents("faceless_void")

LinkLuaModifier("modifier_imba_faceless_void_chronocharges", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Chronocharges counter
if modifier_imba_faceless_void_chronocharges == nil then modifier_imba_faceless_void_chronocharges = class({}) end
function modifier_imba_faceless_void_chronocharges:IsPurgable()		return false end
function modifier_imba_faceless_void_chronocharges:IsDebuff()		return false end
function modifier_imba_faceless_void_chronocharges:IsHidden()		return false end
function modifier_imba_faceless_void_chronocharges:RemoveOnDeath()	return false end
function modifier_imba_faceless_void_chronocharges:GetTexture()
	return "faceless_void_time_lock" end

-------------------------------------------------------------
--------------------	  Timelord		 --------------------
-------------------------------------------------------------
if imba_faceless_void_timelord == nil then imba_faceless_void_timelord = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_timelord", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- increases attack speed by [current attack speed] * 0.15

function imba_faceless_void_timelord:IsInnateAbility()
	return true
end

function imba_faceless_void_timelord:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE end

function imba_faceless_void_timelord:GetIntrinsicModifierName()
	return "modifier_imba_faceless_void_timelord" end

----------------------------------
-----	Timelord Modifier	  ----
----------------------------------
if modifier_imba_faceless_void_timelord == nil then modifier_imba_faceless_void_timelord = class({}) end
function modifier_imba_faceless_void_timelord:IsPurgable()	return false end
function modifier_imba_faceless_void_timelord:IsDebuff()	return false end
function modifier_imba_faceless_void_timelord:IsHidden()	return true end

function modifier_imba_faceless_void_timelord:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
	return funcs
end

function modifier_imba_faceless_void_timelord:OnCreated()
	self:StartIntervalThink(0.2)
	self.bonusAS = 0
	
	-- Initialize chronocharge counter
	local parent = self:GetParent()
	if not parent:HasModifier("modifier_imba_faceless_void_timelord") then
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_faceless_void_timelord", {}) 
	end
end

function modifier_imba_faceless_void_timelord:OnIntervalThink()
	local parent = self:GetParent()
	local currentAS = parent:GetAttackSpeed() - self.bonusAS
	local increase = self:GetAbility():GetSpecialValueFor("as_pcnt_increase") * 0.01
	self.bonusAS = currentAS * increase
end

function modifier_imba_faceless_void_timelord:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return 0 end
	return self.bonusAS * 100
end

-------------------------------------------------------------
--------------------	  Time Walk		 --------------------
-------------------------------------------------------------
if imba_faceless_void_time_walk == nil then imba_faceless_void_time_walk = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_time_walk_damage_counter", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)-- Reduced moenemt/attack speed stolen by caster
LinkLuaModifier("modifier_imba_faceless_void_time_walk_buff_as", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Bonus attack speed stolen from enemies
LinkLuaModifier("modifier_imba_faceless_void_time_walk_buff_ms", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Bonus movement speed stolen from enemies
LinkLuaModifier("modifier_imba_faceless_void_time_walk_cast", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_HORIZONTAL)	-- Motion + invuln
LinkLuaModifier("modifier_imba_faceless_void_time_walk_slow", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Reduced moenemt/attack speed stolen by caster

function imba_faceless_void_time_walk:IsHiddenWhenStolen() return false end

function imba_faceless_void_time_walk:GetCastRange()
	-- Affects only the cast range indicator so you can see the max jump range
	if IsClient() then
		return self:GetSpecialValueFor("range") + self:GetCaster():FindTalentValue("special_bonus_imba_faceless_void_5")
	end
end

function imba_faceless_void_time_walk:GetIntrinsicModifierName()
	if not self:GetCaster():IsIllusion() then
		return "modifier_imba_faceless_void_time_walk_damage_counter"
	end
end

function imba_faceless_void_time_walk:OnUpgrade()
	if IsServer() then
		-- No reason for this to exist if stolen
		if not self:IsStolen() then
			local caster = self:GetCaster()
			if not caster:HasModifier("modifier_imba_faceless_void_chronocharges") then
				caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_chronocharges", {})
			end
		end
	end
end

function imba_faceless_void_time_walk:GetCastAnimation()
	return ACT_DOTA_FLINCH end

function imba_faceless_void_time_walk:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	return true
end

function imba_faceless_void_time_walk:OnSpellStart()
	local caster = self:GetCaster()
	local slow_radius = self:GetSpecialValueFor("slow_radius")
	
	-- Play sound and apply casting modifier
	caster:EmitSound("Hero_FacelessVoid.TimeWalk")
	caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_walk_cast", {})
	
	-- Heal recent damage
	if caster.time_walk_damage_taken then
		caster:SetHealth(caster:GetHealth() + caster.time_walk_damage_taken)
	end
	
	local aoe_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_slow.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(aoe_pfx, 1, Vector(slow_radius,0,0))
	ParticleManager:ReleaseParticleIndex(aoe_pfx)
	ProjectileManager:ProjectileDodge(caster)
end

------------------------------------------
-----	Time Walk damage counter	 -----
------------------------------------------
if modifier_imba_faceless_void_time_walk_damage_counter == nil then modifier_imba_faceless_void_time_walk_damage_counter = class({}) end
function modifier_imba_faceless_void_time_walk_damage_counter:IsPurgable()	return false end
function modifier_imba_faceless_void_time_walk_damage_counter:IsDebuff()	return false end
function modifier_imba_faceless_void_time_walk_damage_counter:IsHidden()	return true end

function modifier_imba_faceless_void_time_walk_damage_counter:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_TAKEDAMAGE ,}
	return funcs
end

function modifier_imba_faceless_void_time_walk_damage_counter:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if not caster.time_walk_damage_taken then
			caster.time_walk_damage_taken = 0
		end
	end
end

function modifier_imba_faceless_void_time_walk_damage_counter:OnTakeDamage( keys )
	if IsServer() then
		local ability = self:GetAbility()

		-- If the ability was unlearned, do nothing
		if not ability then return nil end

		-- Parameters
		local caster = ability:GetCaster()
		local damage_time = ability:GetSpecialValueFor("damage_time") + caster:FindTalentValue("special_bonus_imba_faceless_void_6")
		local damage_taken = keys.damage
		
		-- Stores this instance of damage
		caster.time_walk_damage_taken = caster.time_walk_damage_taken + damage_taken

		-- Decrease damage counter after the duration is up
		Timers:CreateTimer(damage_time, function()
			if caster.time_walk_damage_taken then
				caster.time_walk_damage_taken = caster.time_walk_damage_taken - damage_taken
			end
		end)
	end
end

----------------------------------
-----	Time Walk AS buff	 -----
----------------------------------
if modifier_imba_faceless_void_time_walk_buff_as == nil then modifier_imba_faceless_void_time_walk_buff_as = class({}) end
function modifier_imba_faceless_void_time_walk_buff_as:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_faceless_void_time_walk_buff_as:IsPurgable()	return false end
function modifier_imba_faceless_void_time_walk_buff_as:IsDebuff()	return false end
function modifier_imba_faceless_void_time_walk_buff_as:IsHidden()	return true end

function modifier_imba_faceless_void_time_walk_buff_as:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_walk_buff_as:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() end

----------------------------------
-----	Time Walk MS buff	 -----
----------------------------------
if modifier_imba_faceless_void_time_walk_buff_ms == nil then modifier_imba_faceless_void_time_walk_buff_ms = class({}) end
function modifier_imba_faceless_void_time_walk_buff_ms:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_faceless_void_time_walk_buff_ms:IsPurgable()	return false end
function modifier_imba_faceless_void_time_walk_buff_ms:IsDebuff()	return false end
function modifier_imba_faceless_void_time_walk_buff_ms:IsHidden()	return true end

function modifier_imba_faceless_void_time_walk_buff_ms:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_walk_buff_ms:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() end

---------------------------------------------------
-----	Time Walk casting buff + particle	  -----
---------------------------------------------------
if modifier_imba_faceless_void_time_walk_cast == nil then modifier_imba_faceless_void_time_walk_cast = class({}) end
function modifier_imba_faceless_void_time_walk_cast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_imba_faceless_void_time_walk_cast:IsPurgable() return	false end
function modifier_imba_faceless_void_time_walk_cast:IsDebuff() return	false end
function modifier_imba_faceless_void_time_walk_cast:IsHidden() return	true end

function modifier_imba_faceless_void_time_walk_cast:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf" end

function modifier_imba_faceless_void_time_walk_cast:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_faceless_void_time_walk_cast:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_INVULNERABLE] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true, }
		return state
	end
end

function modifier_imba_faceless_void_time_walk_cast:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		
		-- Compare distance to cast point and max distance, use whichever is closer
		local max_distance = ability:GetSpecialValueFor("range") + GetCastRangeIncrease(caster) + caster:FindTalentValue("special_bonus_imba_faceless_void_5")
		local distance = (caster:GetAbsOrigin() - caster:GetCursorPosition()):Length2D()
		if distance > max_distance then distance = max_distance end
		
		self.velocity = ability:GetSpecialValueFor("speed")
		self.direction = (caster:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
		self.distance_traveled = 0
		self.distance = distance
		
		-- Enemy effect handler
		self:StartIntervalThink(0)
		self.as_stolen = 0
		self.ms_stolen = 0

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end	
	end
end

function modifier_imba_faceless_void_time_walk_cast:OnIntervalThink()

	local caster = self:GetParent()
	local ability = self:GetAbility()
	
	local aoe = self:GetAbility():GetSpecialValueFor("slow_radius")
	local duration = self:GetAbility():GetSpecialValueFor("duration")
	local as_steal = self:GetAbility():GetSpecialValueFor("as_steal")
	local ms_steal = self:GetAbility():GetSpecialValueFor("ms_steal_pcnt")
	local chronocharges = 0
	
	-- Slow enemies
	enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		if not enemy:HasModifier("modifier_imba_faceless_void_time_walk_slow") then
		
			-- If the enemy is a real hero index their move and attack speed, and grant a chronocharge
			if enemy:IsRealHero() then
				self.as_stolen = self.as_stolen + enemy:GetAttackSpeed() * as_steal
				self.ms_stolen = self.ms_stolen + enemy:GetMoveSpeedModifier(enemy:GetBaseMoveSpeed()) * ms_steal
				chronocharges = chronocharges + 1
			end
			
			-- Play hit particle only on hit heroes, and their illusions to prevent the caster from finding the real hero with this skill.
			if enemy:IsHero() then
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(particle, 0, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
			end
			
			-- Apply the slow
			enemy:AddNewModifier(caster, ability, "modifier_imba_faceless_void_time_walk_slow", {duration = duration})
		end
	end
	
	-- If spell not stolen, add chronocharges
	if not ability:IsStolen() then
		AddStacksLua(ability, caster, caster, "modifier_imba_faceless_void_chronocharges", chronocharges, false)
	end
	
	self:StartIntervalThink(0.1)
end

function modifier_imba_faceless_void_time_walk_cast:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local duration = ability:GetSpecialValueFor("duration")
		local aoe = self:GetAbility():GetSpecialValueFor("slow_radius")
		
		local asBuff = caster:AddNewModifier(caster, ability, "modifier_imba_faceless_void_time_walk_buff_as", {duration = duration})
		local msBuff = caster:AddNewModifier(caster, ability, "modifier_imba_faceless_void_time_walk_buff_ms", {duration = duration})
		asBuff:SetStackCount(self.as_stolen)
		msBuff:SetStackCount(self.ms_stolen)
		
		-- Timer because it has a slight offset otherwise
		Timers:CreateTimer(0.1, function()
			-- Play particle around landing point
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_slow.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 1, Vector(aoe,aoe,aoe))
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Stop the casting animation and remove caster modifier 
			caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
		end)
	end
end

function modifier_imba_faceless_void_time_walk_cast:OnDestroy()
	if IsServer() then
	end
end

function modifier_imba_faceless_void_time_walk_cast:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local caster = self:GetCaster()
		
		if self.distance_traveled < self.distance then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + self.direction * self.velocity * dt)
			self.distance_traveled = self.distance_traveled + self.velocity * dt
		else
			caster:InterruptMotionControllers(true)
			self:Destroy()
		end
	end
end

-----------------------------------
-----	Time Walk debuff	  -----
-----------------------------------
if modifier_imba_faceless_void_time_walk_slow == nil then modifier_imba_faceless_void_time_walk_slow = class({}) end
function modifier_imba_faceless_void_time_walk_slow:IsPurgable() return true end
function modifier_imba_faceless_void_time_walk_slow:IsHidden() return false end
function modifier_imba_faceless_void_time_walk_slow:IsDebuff() return true end

function modifier_imba_faceless_void_time_walk_slow:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk_debuff.vpcf" end

function modifier_imba_faceless_void_time_walk_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_faceless_void_time_walk_slow:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_walk_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("ms_steal_pcnt") * -1 end

function modifier_imba_faceless_void_time_walk_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_steal") * -1 end

----------------------------------------------------------------
--------------------	  Time Dilation		--------------------
----------------------------------------------------------------
if imba_faceless_void_time_dilation == nil then imba_faceless_void_time_dilation = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_time_dilation_buff", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Ally/Caster buff
LinkLuaModifier("modifier_imba_faceless_void_time_dilation_slow", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Enemy debuff
LinkLuaModifier("modifier_imba_faceless_void_time_dilation_talent_buff", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Talent caster buff

function imba_faceless_void_time_dilation:IsHiddenWhenStolen() return false end
	
function imba_faceless_void_time_dilation:GetCastRange()
	-- Affects only the cast range indicator so you can see the effect radius
	-- Don't forget to add a note that says its unaffected by cast range increase!!!
	if IsClient() then
		return self:GetSpecialValueFor("area_of_effect")
	end
end

function imba_faceless_void_time_dilation:OnUpgrade()
	if IsServer() then
		-- If the ability was stolen, and OnUpgrade is called for the first time (It gets called once per ability level)
		if self:IsStolen() then
			if self:GetLevel() == 1 then
				local caster = self:GetCaster()
				local originalCaster = caster.spellStealTarget
				
				-- If the last caster was indexed (should be, but just in case)
				if originalCaster then
					local chronochargeModifier = originalCaster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
					if chronochargeModifier then
						AddStacksLua(self, caster, caster, "modifier_imba_faceless_void_chronocharges", chronochargeModifier:GetStackCount(), false)
					end
				end
			end
		else
			local caster = self:GetCaster()
			if not caster:HasModifier("modifier_imba_faceless_void_chronocharges") then
				caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_chronocharges", {})
			end
		end
	end
end

function imba_faceless_void_time_dilation:OnUnStolen()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_faceless_void_chronocharges") then
			caster:RemoveModifierByName("modifier_imba_faceless_void_chronocharges")
		end
	end
end

function imba_faceless_void_time_dilation:OnSpellStart()
	local caster = self:GetCaster()
	local aoe = self:GetSpecialValueFor("area_of_effect")
	local duration = self:GetSpecialValueFor("duration")
	local cd_increase = self:GetSpecialValueFor("cd_increase")
	local cd_decrease = self:GetSpecialValueFor("cd_decrease")
	local charge_gain = self:GetSpecialValueFor("charge_gain")
	local chronocharges = 0
	
	local chronocharges_modifier = caster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
	if chronocharges_modifier then
		chronocharges = chronocharges_modifier:GetStackCount()
	else
		caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_chronocharges", {})
	end
	
	-- Get enemies caught in the aoe
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy:IsRealHero() then
			-- Iterate through the enemies abilities
			local abilities_on_cooldown = 0
			for i = 0, 23 do
				local current_ability = enemy:GetAbilityByIndex(i)
				if current_ability and not current_ability:IsPassive() and not current_ability:IsAttributeBonus() and not current_ability:IsCooldownReady() then
					current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + cd_increase )
					abilities_on_cooldown = abilities_on_cooldown + 1
					chronocharges = chronocharges + charge_gain
				end
			end
			
			if abilities_on_cooldown > 0 then
				local debuff = enemy:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_dilation_slow", {duration = duration})
				debuff:SetStackCount(abilities_on_cooldown)
				
				enemy:EmitSound("Hero_FacelessVoid.TimeDilation.Target")
			
				local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)
			end
		end
	end
	
	-- Get allies caught in the aoe
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	local charges_spent = 0
	for _,ally in pairs(allies) do
		-- Stop if there are no more chronocharges left and the caster doesn't have the talent
		if not caster:HasTalent("special_bonus_imba_faceless_void_7") then
			if chronocharges <= 0 then break end
		end
		
		-- Iterate through the allies abilities
		local abilities_on_cooldown = 0
		for i = 0, 23 do
			if chronocharges > 0 or caster:HasTalent("special_bonus_imba_faceless_void_7") then
				local current_ability = ally:GetAbilityByIndex(i)
				
				-- If there is an ability, it's not the casted ability, learned, not a passive, not a talent, and on cooldown
				if current_ability and current_ability ~= self and current_ability:GetLevel() > 0 and not current_ability:IsPassive() and not current_ability:IsAttributeBonus() and not current_ability:IsCooldownReady() then
					local newCooldown = current_ability:GetCooldownTimeRemaining() - cd_decrease
					current_ability:EndCooldown()
					current_ability:StartCooldown(newCooldown)
					abilities_on_cooldown = abilities_on_cooldown + 1
					
					if not caster:HasTalent("special_bonus_imba_faceless_void_7") then
						chronocharges = chronocharges - 1
					end
				end
				
			-- Stop if there are no more chronocharges left and the caster doesn't have the talent
			else
				break
			end
		end
		
		-- If the ally had any cooldowns tweaked apply positive buff with stacks equal to affected skills
		if abilities_on_cooldown > 0 then
			local buff = ally:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_dilation_buff", {duration = duration})
			buff:SetStackCount(abilities_on_cooldown)
			
			ally:EmitSound("Hero_FacelessVoid.TimeDilation.Target")
			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, ally)
			ParticleManager:SetParticleControl(hit_pfx, 0, ally:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)
			
			charges_spent = charges_spent + abilities_on_cooldown
		end
	end
	
	if caster:HasTalent("special_bonus_imba_faceless_void_1") and charges_spent > 0 then
		local talent_mod = caster:FindModifierByName("modifier_imba_faceless_void_time_dilation_talent_buff")
		-- If the caster already has the modifier for whatever reason, stacks will get merged, but old ones will expire when they should've originaly.
		if talent_mod then
			local time_left = talent_mod:GetRemainingTime()
			local current_stacks = talent_mod:GetStackCount()
			
			Timers:CreateTimer(time_left, function()
				if not talent_mod:IsNull() then
					talent_mod:SetStackCount(talent_mod:GetStackCount() - current_stacks)
				end
			end)
		else
			caster:AddNewModifier(caster, self, "modifier_imba_faceless_void_time_dilation_talent_buff", {duration = duration})
		end
		AddStacksLua(self, caster, caster, "modifier_imba_faceless_void_time_dilation_talent_buff", charges_spent, true)
	end
	
	-- Update Chronocharge counter, but only if the spell is not stolen
	if not self:IsStolen() then
		chronocharges_modifier = caster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
		chronocharges_modifier:SetStackCount(chronocharges)
	end
	
	-- Particles and sound
	caster:EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
	
	local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_timedialate.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(aoe * 2, 0, 0))
	ParticleManager:ReleaseParticleIndex(cast_pfx)
	
	local cast_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(cast_pfx_2, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(cast_pfx_2)
end

-----------------------------------
-----	Time Dilation buff	  -----
-----------------------------------
if modifier_imba_faceless_void_time_dilation_buff == nil then modifier_imba_faceless_void_time_dilation_buff = class({}) end
function modifier_imba_faceless_void_time_dilation_buff:IsPurgable() return true end
function modifier_imba_faceless_void_time_dilation_buff:IsHidden() return false end
function modifier_imba_faceless_void_time_dilation_buff:IsDebuff() return false end

function modifier_imba_faceless_void_time_dilation_buff:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf" end

function modifier_imba_faceless_void_time_dilation_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_faceless_void_time_dilation_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
					MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_dilation_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("ms_buff") * self:GetStackCount() end

function modifier_imba_faceless_void_time_dilation_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_buff") * self:GetStackCount() end

function modifier_imba_faceless_void_time_dilation_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetCaster():FindSpecificTalentValue("special_bonus_imba_faceless_void_2","hp_regen") * self:GetStackCount() end

function modifier_imba_faceless_void_time_dilation_buff:GetModifierConstantManaRegen()
	return self:GetAbility():GetCaster():FindSpecificTalentValue("special_bonus_imba_faceless_void_2","mp_regen") * self:GetStackCount() end

-------------------------------------------
-----	Time Dilation talent buff	  -----
-------------------------------------------
if modifier_imba_faceless_void_time_dilation_talent_buff == nil then modifier_imba_faceless_void_time_dilation_talent_buff = class({}) end
function modifier_imba_faceless_void_time_dilation_talent_buff:IsPurgable() return true end
function modifier_imba_faceless_void_time_dilation_talent_buff:IsHidden() return true end
function modifier_imba_faceless_void_time_dilation_talent_buff:IsDebuff() return false end

function modifier_imba_faceless_void_time_dilation_talent_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_dilation_talent_buff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetCaster():FindSpecificTalentValue("special_bonus_imba_faceless_void_1", "ms_pcnt") * self:GetStackCount() end

function modifier_imba_faceless_void_time_dilation_talent_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetCaster():FindSpecificTalentValue("special_bonus_imba_faceless_void_1", "as_bonus") * self:GetStackCount() end

-----------------------------------
-----	Time Dilation slow	  -----
-----------------------------------
if modifier_imba_faceless_void_time_dilation_slow == nil then modifier_imba_faceless_void_time_dilation_slow = class({}) end
function modifier_imba_faceless_void_time_dilation_slow:IsPurgable() return true end
function modifier_imba_faceless_void_time_dilation_slow:IsHidden() return false end
function modifier_imba_faceless_void_time_dilation_slow:IsDebuff() return true end

function modifier_imba_faceless_void_time_dilation_slow:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf.vpcf" end

function modifier_imba_faceless_void_time_dilation_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end
	
function modifier_imba_faceless_void_time_dilation_slow:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_time_dilation_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("ms_debuff") * self:GetStackCount() * -1 end

function modifier_imba_faceless_void_time_dilation_slow:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("as_debuff") * self:GetStackCount() * -1 end

-------------------------------------------------------------
--------------------	  Time Lock		 --------------------
-------------------------------------------------------------
if imba_faceless_void_time_lock == nil then imba_faceless_void_time_lock = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_time_lock", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Passive effect
LinkLuaModifier("modifier_imba_faceless_void_time_lock_stun", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- The stun

function imba_faceless_void_time_lock:GetIntrinsicModifierName()
	if not self:GetCaster():IsIllusion() then
		return "modifier_imba_faceless_void_time_lock"
	end
end

--------------------------------
-----	Time Lock passive	----
--------------------------------
if modifier_imba_faceless_void_time_lock == nil then modifier_imba_faceless_void_time_lock = class({}) end
function modifier_imba_faceless_void_time_lock:IsPurgable()			return false end
function modifier_imba_faceless_void_time_lock:IsDebuff()			return false end
function modifier_imba_faceless_void_time_lock:IsHidden()			return true end
 
function modifier_imba_faceless_void_time_lock:DeclareFunctions()
	local funcs = { MODIFIER_EVENT_ON_ATTACK_LANDED, }
	return funcs
end

function modifier_imba_faceless_void_time_lock:OnAttackLanded( keys )
	if IsServer() then
		local target = keys.target		-- Unit getting hit
		local attacker = keys.attacker	-- Unit landing the hit
		local parent = self:GetParent()	-- Unit holding this modifier
		local ability = self:GetAbility()
		
		-- See if the passive owner is the attacker, and that they're not broken
		if parent == attacker and not target:IsBuilding() and not parent:PassivesDisabled() and parent:GetTeamNumber() ~= target:GetTeamNumber() then
			local bashChance = ability:GetSpecialValueFor("bash_chance") * 0.01
			local bashDamage = ability:GetSpecialValueFor("bash_damage")
			local bashDuration = ability:GetSpecialValueFor("bash_duration")
			local cdIncrease = ability:GetSpecialValueFor("cd_increase")
			
			-- See if the chance passed
			if math.random() <= bashChance then
				target:AddNewModifier(parent, ability, "modifier_imba_faceless_void_time_lock_stun", { duration = bashDuration })
				ApplyDamage({attacker = parent, victim = target, ability = ability, damage = bashDamage, damage_type = DAMAGE_TYPE_MAGICAL})
				EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", target) 
				
				-- Add a chronocharge if a hero was bashed
				if target:IsRealHero() then
					AddStacksLua(ability, parent, parent, "modifier_imba_faceless_void_chronocharges", 1, false)
				end
				
				-- Iterate through all victims abilities
				for i = 0, 23 do
					local targetAbility = target:GetAbilityByIndex(i)
					
					-- If there is an ability, it's learned, not a passive, not a talent/attribute bonus, and on cooldown, apply cooldown increase
					if targetAbility and targetAbility:GetLevel() > 0 and not targetAbility:IsPassive() and not targetAbility:IsAttributeBonus() and not targetAbility:IsCooldownReady() then
						local newCooldown = targetAbility:GetCooldownTimeRemaining() + cdIncrease
						targetAbility:EndCooldown()
						targetAbility:StartCooldown(newCooldown)
					end
				end
			end
		end
	end
end

--------------------------------
-----	Time Lock Stun		----
--------------------------------
if modifier_imba_faceless_void_time_lock_stun == nil then modifier_imba_faceless_void_time_lock_stun = class({}) end
function modifier_imba_faceless_void_time_lock_stun:IsPurgable()		return false end
function modifier_imba_faceless_void_time_lock_stun:IsDebuff()			return true end
function modifier_imba_faceless_void_time_lock_stun:IsHidden()			return true end
function modifier_imba_faceless_void_time_lock_stun:IsStunDebuff()		return true end
function modifier_imba_faceless_void_time_lock_stun:IsPurgeException()	return true end

function modifier_imba_faceless_void_time_lock_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_imba_faceless_void_time_lock_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_imba_faceless_void_time_lock_stun:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(128,128,255)
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end
	
function modifier_imba_faceless_void_time_lock_stun:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end end
		
function modifier_imba_faceless_void_time_lock_stun:CheckState()
	if IsServer() then
		local state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FROZEN ] = true	}
		return state
	end
end

----------------------------------------------------------------
--------------------	  Chronosphere		--------------------
----------------------------------------------------------------
if imba_faceless_void_chronosphere == nil then imba_faceless_void_chronosphere = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_aura", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Aura - Handle applier
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_handler", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Handler
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_caster_buff", "hero/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)-- Bonus attack speed for caster and their minions
	
function imba_faceless_void_chronosphere:IsHiddenWhenStolen() return false end

function imba_faceless_void_chronosphere:GetAOERadius()
	local caster = self:GetCaster()
	local chronocharge_radius = self:GetSpecialValueFor("chronocharge_radius") * (1 + caster:FindTalentValue("special_bonus_imba_faceless_void_8") * 0.01)
	local aoe = self:GetSpecialValueFor("base_radius")
	
	if caster:HasModifier("modifier_imba_faceless_void_chronocharges") then
		aoe = aoe + chronocharge_radius * caster:GetModifierStackCount("modifier_imba_faceless_void_chronocharges", caster)
	end
	
	return aoe
end

function imba_faceless_void_chronosphere:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor("scepter_cooldown") end
	return self.BaseClass.GetCooldown( self, level )
end

function imba_faceless_void_chronosphere:OnSpellStart()
	local caster = self:GetCaster()
	local chrono_center = self:GetCursorPosition()
	local sound_cast = "Hero_FacelessVoid.Chronosphere"
		
	-- Parameters
	local base_radius = self:GetSpecialValueFor("base_radius")
	local chronocharge_radius = self:GetSpecialValueFor("chronocharge_radius") * (1 + caster:FindTalentValue("special_bonus_imba_faceless_void_8") * 0.01)
	local duration = self:GetSpecialValueFor("duration")
	
	-- Fetch chronocharges and reset counter
	local chronocharges = 0
	local chronochargeModifier = caster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
	if chronochargeModifier then
		chronocharges = chronochargeModifier:GetStackCount()
		chronochargeModifier:SetStackCount(0)
	end

	-- Calculate final chronosphere parameters
	local total_radius = base_radius + chronocharge_radius * chronocharges
	
	-- Increases duration if the caster has the talent for it
	duration = duration + caster:GetSpellPower() * caster:FindTalentValue("special_bonus_imba_faceless_void_4")
	
	-- Create flying vision node
	self:CreateVisibilityNode(chrono_center, total_radius, duration)

	-- Decide which cast sound to play
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), chrono_center, nil, total_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
	if #heroes >= IMBA_PLAYERS_ON_GAME * 0.35 then
		if self:IsStolen() then
			caster:EmitSound("Imba.StolenZaWarudo")		-- If stolen, Star Platinum ZA WARUDO
		else
			caster:EmitSound("Imba.FacelessZaWarudo")	-- Otherwise Dio ZA WARUDO
		end
	else
		caster:EmitSound(sound_cast)
	end
	
	-- Create the dummy and give it the chronosphere aura
	local dummy = CreateUnitByName("npc_dummy_unit", chrono_center, false, caster, caster, caster:GetTeamNumber())
	local mod = dummy:AddNewModifier(caster, self, "modifier_imba_faceless_void_chronosphere_aura", {duration = duration})
	
	-- If chronocharges were spent, index them in the aura modifier as stacks
	if chronocharges > 0 then
		mod:SetStackCount(chronocharges)
	end
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_WORLDORIGIN, dummy)
		ParticleManager:SetParticleControl(particle, 0, dummy:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(total_radius, total_radius, total_radius))
			
	Timers:CreateTimer(duration, function()
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex(particle)
		dummy:Destroy()
	end)
end

---------------------------------
-----	Chronosphere Aura	-----
---------------------------------
if modifier_imba_faceless_void_chronosphere_aura == nil then modifier_imba_faceless_void_chronosphere_aura = class({}) end
function modifier_imba_faceless_void_chronosphere_aura:IsPurgable() return false end
function modifier_imba_faceless_void_chronosphere_aura:IsHidden() return true end
function modifier_imba_faceless_void_chronosphere_aura:IsAura() return true end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraDuration()
	if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_faceless_void_3") then return 0.01 end
	return 0.1 end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_OTHER end

function modifier_imba_faceless_void_chronosphere_aura:GetModifierAura()
	return "modifier_imba_faceless_void_chronosphere_handler" end
	
function modifier_imba_faceless_void_chronosphere_aura:GetAuraRadius()
	local ability = self:GetAbility()
	local base_radius = ability:GetSpecialValueFor("base_radius")
	local bonus_radius = ability:GetSpecialValueFor("chronocharge_radius") * (1 + ability:GetCaster():FindTalentValue("special_bonus_imba_faceless_void_8") * 0.01)
	
	return base_radius + bonus_radius * self:GetStackCount()
end

function modifier_imba_faceless_void_chronosphere_aura:OnCreated()
	if IsServer() then
		Timers:CreateTimer(FrameTime(), function()
			if self:GetStackCount() > 0 then
				self:StartIntervalThink(0.1)
				self.modifiers = {}
			end
		end)
	end
end

function modifier_imba_faceless_void_chronosphere_aura:OnRemoved()
	if IsServer() then
		if self.modifiers then
			for _,mod in pairs(self.modifiers) do
				if not mod:IsNull() then mod:Destroy() end
			end
		end
	end
end

function modifier_imba_faceless_void_chronosphere_aura:OnIntervalThink()
	local radius = self:GetAuraRadius()
	local caster = self:GetCaster()
	
	-- Find the caster and unit under their control under the Chronosphere, and give them the attack speed bonus modifier
	local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	for _,unit in ipairs(units) do
		if unit == caster or unit:GetPlayerOwner() == caster:GetPlayerOwner() then
			if not self.modifiers[unit:GetEntityIndex()] then
				local mod = unit:AddNewModifier(caster, self:GetAbility(), "modifier_imba_faceless_void_chronosphere_caster_buff", {})
				mod:SetStackCount(self:GetStackCount())
				table.insert(self.modifiers, unit:GetEntityIndex(),mod)
			end
		end
	end
	
	-- Iterate through the units belonging to the caster and see if they're inside the Chronosphere. If not, remove the modifier.
	local parent = self:GetParent()
	for id,mod in pairs(self.modifiers) do
		local unit = EntIndexToHScript(id)
		if CalcDistanceBetweenEntityOBB(parent, unit) > self:GetAuraRadius() then
			if not mod:IsNull() then mod:Destroy() end
			self.modifiers[id] = nil -- table.remove(self.modifiers, id) didn't work
		end
	end
end

-------------------------------------
-----	Chronosphere Handler	-----
-------------------------------------
if modifier_imba_faceless_void_chronosphere_handler == nil then modifier_imba_faceless_void_chronosphere_handler = class({}) end
function modifier_imba_faceless_void_chronosphere_handler:IsHidden() return true end
function modifier_imba_faceless_void_chronosphere_handler:IsPurgable() return false end
function modifier_imba_faceless_void_chronosphere_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Utilizes the stack system to work
--	0 stacks = Everything that doesn't fit under other categories
--	1 stacks = Caster or units under their control
--	2 stacks = Ally when caster has a scepter
--	3 stacks = Anyone who has the Timelord ability thats not the caster

function modifier_imba_faceless_void_chronosphere_handler:IsDebuff()
	if self:GetStackCount() == 1 then
		return false end
	return true
end

function modifier_imba_faceless_void_chronosphere_handler:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetAbility():GetCaster()
		
		if parent == caster or parent:GetPlayerOwner() == caster:GetPlayerOwner() then
			self:SetStackCount(1)
			if caster:HasTalent("special_bonus_imba_faceless_void_3") then
				self:StartIntervalThink(0.1)
			end
		elseif parent:FindAbilityByName("imba_faceless_void_timelord") then
			self:SetStackCount(3)
		elseif caster:HasScepter() and caster:GetTeamNumber() == parent:GetTeamNumber() then
			self:SetStackCount(2)
		end
	end
end

-- Used only for projectile dodging
function modifier_imba_faceless_void_chronosphere_handler:OnIntervalThink()
	ProjectileManager:ProjectileDodge(self:GetParent()) end

function modifier_imba_faceless_void_chronosphere_handler:DeclareFunctions()
	local funcs ={ 	MODIFIER_EVENT_ON_ORDER,
					MODIFIER_PROPERTY_MOVESPEED_MAX,
					MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
					MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
					MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, }
					
	return funcs
end

function modifier_imba_faceless_void_chronosphere_handler:CheckState()
	local stacks = self:GetStackCount()
	local state = {}
	
	if stacks == 0 then
		state = {	[MODIFIER_STATE_FROZEN] = true,
					[MODIFIER_STATE_ROOTED] = true,
					[MODIFIER_STATE_STUNNED] = true,
					[MODIFIER_STATE_SILENCED] = true,
					[MODIFIER_STATE_INVISIBLE] = false,}
	elseif stacks == 1 then
		state = {	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
					[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, }
	end
	return state
end

function modifier_imba_faceless_void_chronosphere_handler:GetPriority()
	if self:GetStackCount() == 0 then
		return MODIFIER_PRIORITY_HIGH end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierMoveSpeed_Absolute()
	if self:GetStackCount() == 1 then
		if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_faceless_void_3") then
			return 5000
		end
		return self:GetAbility():GetSpecialValueFor("movement_speed")
	end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierMoveSpeed_Max()
	if self:GetStackCount() == 1 then
		return self:GetAbility():GetSpecialValueFor("movement_speed") end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount() == 2 then
		return self:GetAbility():GetSpecialValueFor("scepter_ally_as_slow") * -1 end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierMoveSpeedBonus_Percentage()
	if self:GetStackCount() == 2 then
		return self:GetAbility():GetSpecialValueFor("scepter_ally_ms_slow_pcnt") * -1 end
end
	
function modifier_imba_faceless_void_chronosphere_handler:GetModifierProjectileSpeedBonus()
	if self:GetStackCount() == 2 then
		return self:GetAbility():GetSpecialValueFor("scepter_ally_projectile_slow") * -1 end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierPercentageCasttime()
	if self:GetStackCount() == 2 then
		return self:GetAbility():GetSpecialValueFor("scepter_ally_casttime_pcnt_debuff") * -0.01 end
end

-----------------------------------------------
-----	Chronosphere Caster Modifier	  -----
-----------------------------------------------
if modifier_imba_faceless_void_chronosphere_caster_buff == nil then modifier_imba_faceless_void_chronosphere_caster_buff = class({}) end
function modifier_imba_faceless_void_chronosphere_caster_buff:IsPurgable() return false end
function modifier_imba_faceless_void_chronosphere_caster_buff:IsHidden() return false end
function modifier_imba_faceless_void_chronosphere_caster_buff:IsDebuff() return false end
function modifier_imba_faceless_void_chronosphere_caster_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_faceless_void_chronosphere_caster_buff:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf" end
	
function modifier_imba_faceless_void_chronosphere_caster_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN  end
	
function modifier_imba_faceless_void_chronosphere_caster_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_chronosphere_caster_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("chronocharge_attackspeed") * (1 + self:GetAbility():GetCaster():FindTalentValue("special_bonus_imba_faceless_void_8") * 0.01) * self:GetStackCount() end
