-- Editors:
--     zimberzimber, 22.03.2017

LinkLuaModifier("modifier_imba_faceless_void_chronocharges", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Chronocharges counter
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
LinkLuaModifier("modifier_imba_faceless_void_timelord", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- increases attack speed by [current attack speed] * 0.15

function imba_faceless_void_timelord:GetAbilityTextureName()
	return "custom/faceless_void_timelord"
end

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

	-- #6 TALENT: Timelord bonuses are increased while in chronosphere
	local talent_multiplication = 1
	if parent:HasTalent("special_bonus_imba_faceless_void_6") then
		local chrono_stacks	=	parent:GetModifierStackCount("modifier_imba_faceless_void_chronosphere_handler", parent)
		if chrono_stacks == 1 or chrono_stacks == 3 then
			talent_multiplication  = parent:FindTalentValue("special_bonus_imba_faceless_void_6")
		end
	end

	local increase = self:GetAbility():GetSpecialValueFor("as_pcnt_increase") * 0.01 * talent_multiplication
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
LinkLuaModifier("modifier_imba_faceless_void_time_walk_damage_counter", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)-- Reduced moenemt/attack speed stolen by caster
LinkLuaModifier("modifier_imba_faceless_void_time_walk_buff_as", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Bonus attack speed stolen from enemies
LinkLuaModifier("modifier_imba_faceless_void_time_walk_buff_ms", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Bonus movement speed stolen from enemies
LinkLuaModifier("modifier_imba_faceless_void_time_walk_cast", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Motion + invuln
LinkLuaModifier("modifier_imba_faceless_void_time_walk_slow", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Reduced moenemt/attack speed stolen by caster

function imba_faceless_void_time_walk:GetAbilityTextureName()
	return "faceless_void_time_walk"
end

function imba_faceless_void_time_walk:IsHiddenWhenStolen() return false end
function imba_faceless_void_time_walk:IsNetherWardStealable() return false end

function imba_faceless_void_time_walk:GetCastRange()
	-- Affects only the cast range indicator so you can see the max jump range
	if IsClient() then
		return self:GetSpecialValueFor("range")
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
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.damage_time = self.ability:GetSpecialValueFor("damage_time")

	if IsServer() then
		if not self.caster.time_walk_damage_taken then
			self.caster.time_walk_damage_taken = 0
		end
	end
end

function modifier_imba_faceless_void_time_walk_damage_counter:OnTakeDamage( keys )
	if IsServer() then
		local unit = keys.unit
		local damage_taken = keys.damage

		-- Only apply if the one taking damage is Faceless Void himself
		if unit == self.caster then

			-- Stores this instance of damage
			self.caster.time_walk_damage_taken = self.caster.time_walk_damage_taken + damage_taken

			-- Decrease damage counter after the duration is up
			Timers:CreateTimer(self.damage_time, function()
				if self.caster.time_walk_damage_taken then
					self.caster.time_walk_damage_taken = self.caster.time_walk_damage_taken - damage_taken
				end
			end)
		end
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
function modifier_imba_faceless_void_time_walk_cast:IgnoreTenacity() return true end
function modifier_imba_faceless_void_time_walk_cast:IsMotionController() return true end
function modifier_imba_faceless_void_time_walk_cast:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

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
		local max_distance = ability:GetSpecialValueFor("range") + GetCastRangeIncrease(caster)
		local distance = (caster:GetAbsOrigin() - caster:GetCursorPosition()):Length2D()
		if distance > max_distance then distance = max_distance end

		self.velocity = ability:GetSpecialValueFor("speed")
		self.direction = (caster:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
		self.distance_traveled = 0
		self.distance = distance

		-- Enemy effect handler
		self.as_stolen = 0
		self.ms_stolen = 0

		self.frametime = FrameTime()
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_faceless_void_time_walk_cast:OnIntervalThink()

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)

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
		self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):GetStackCount() + chronocharges)
	end
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

function modifier_imba_faceless_void_time_walk_cast:HorizontalMotion( me, dt )
	if IsServer() then

		local caster = self:GetCaster()

		if self.distance_traveled < self.distance then
			caster:SetAbsOrigin(caster:GetAbsOrigin() + self.direction * self.velocity * dt)
			self.distance_traveled = self.distance_traveled + self.velocity * dt
		else
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
LinkLuaModifier("modifier_imba_faceless_void_time_dilation_buff", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Ally/Caster buff
LinkLuaModifier("modifier_imba_faceless_void_time_dilation_slow", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)			-- Enemy debuff
LinkLuaModifier("modifier_imba_time_dilation_talent", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Talent caster buff

function imba_faceless_void_time_dilation:GetAbilityTextureName()
	return "faceless_void_time_dilation"
end

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
						self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):GetStackCount())
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

					-- #1 TALENT: Time Dilation grants Backtrack
					if caster:HasTalent("special_bonus_imba_faceless_void_1") then
						caster:AddNewModifier(caster, self, "modifier_imba_time_dilation_talent", {duration  = caster:FindTalentValue("special_bonus_imba_faceless_void_1", "duration")})
					end

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

		-- #7 TALENT: Time Dilation no longer spends chronocharges to affect allies.
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

-- #2 TALENT: Time dilation gives hp and mana regen
function modifier_imba_faceless_void_time_dilation_buff:GetModifierConstantHealthRegen()
	return self:GetAbility():GetCaster():FindTalentValue("special_bonus_imba_faceless_void_2","hp_regen") * self:GetStackCount() end

function modifier_imba_faceless_void_time_dilation_buff:GetModifierConstantManaRegen()
	return self:GetAbility():GetCaster():FindTalentValue("special_bonus_imba_faceless_void_2","mp_regen") * self:GetStackCount() end

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

--------------------------------------
---	Time Dilation Backtrack talent --- (#1 TALENT modifier)
--------------------------------------
modifier_imba_time_dilation_talent = modifier_imba_time_dilation_talent or class({})

-- Modifier properties
function modifier_imba_time_dilation_talent:IsPurgable() return false end
function modifier_imba_time_dilation_talent:IsHidden() return false end
function modifier_imba_time_dilation_talent:IsDebuff() return false end

function modifier_imba_time_dilation_talent:OnCreated()
	if IsServer() then
		-- This is possibly not the same
		self.parent	= 	self:GetParent()
		self.caster = 	self:GetCaster()
		self:IncrementStackCount()
	end
end

function modifier_imba_time_dilation_talent:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_imba_time_dilation_talent:DeclareFunctions()
	local funcs	=	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_imba_time_dilation_talent:GetModifierIncomingDamage_Percentage()
	local caster	=	self:GetCaster()
	-- When Void takes damage Give him a chance to prevent that damage
	local chance = self.caster:FindTalentValue("special_bonus_imba_faceless_void_1", "backtrack_pct_per_enemy") * self:GetStackCount()
	local max_chance = self.caster:FindTalentValue("special_bonus_imba_faceless_void_1", "max_pct")

	if chance < max_chance then
		if RollPercentage(chance) then
			-- ACTUAL BACKTRACK PARTICLE!!!
			local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(backtrack_fx)
			return -100
		end
	else
		if RollPercentage(max_chance) then
			local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(backtrack_fx)
			return -100
		end
	end
end

-------------------------------------------------------------
--------------------	  Time Lock		 --------------------
-------------------------------------------------------------
if imba_faceless_void_time_lock == nil then imba_faceless_void_time_lock = class({}) end
LinkLuaModifier("modifier_imba_faceless_void_time_lock", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Passive effect
LinkLuaModifier("modifier_imba_faceless_void_time_lock_stun", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- The stun

function imba_faceless_void_time_lock:GetAbilityTextureName()
	return "faceless_void_time_lock"
end

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
	local funcs = { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
	return funcs
end

function modifier_imba_faceless_void_time_lock:GetModifierProcAttack_BonusDamage_Magical( keys )
	if IsServer() then
		local target = keys.target		-- Unit getting hit
		local attacker = keys.attacker	-- Unit landing the hit
		local parent = self:GetParent()	-- Unit holding this modifier
		local ability = self:GetAbility()
		local bonus_damage_to_main_target = 0

		-- See if the passive owner is the attacker, and that they're not broken
		if parent == attacker and not target:IsRoshan() and not target:IsBuilding() and not parent:PassivesDisabled() and parent:GetTeamNumber() ~= target:GetTeamNumber() then
			local bashChance = ability:GetSpecialValueFor("bash_chance")
			local bashDamage = ability:GetSpecialValueFor("bash_damage")
			local bashDuration = ability:GetSpecialValueFor("bash_duration")
			local creep_bash_duration = ability:GetSpecialValueFor("creep_bash_duration")
			local cdIncrease = ability:GetSpecialValueFor("cd_increase")
			local talent_cd_increase = 0

			-- See if the chance passed
			if RollPseudoRandom(bashChance, self) then
				-- Deal damage
				bonus_damage_to_main_target = bonus_damage_to_main_target + bashDamage

				-- If the target is not in a Chronosphere, apply bash normally.
				if not target:FindModifierByName("modifier_imba_faceless_void_chronosphere_handler") then
					-- #4 TALENT: Increases the cd increase on bash on enemies affected by time dilation and reduces his own
					if target:FindModifierByName("modifier_imba_faceless_void_time_dilation_slow") then
						talent_cd_increase			=	attacker:FindTalentValue("special_bonus_imba_faceless_void_4", "target_increase")
						local caster_cd_decrease	=	attacker:FindTalentValue("special_bonus_imba_faceless_void_4", "self_reduction")

						-- Iterate through all of Void's abilities
						for i = 0, 23 do
							local casterAbility = attacker:GetAbilityByIndex(i)
							-- If there is an ability, it's learned, not a passive, not a talent/attribute bonus, and on cooldown, apply cooldown increase
							if casterAbility and casterAbility:GetLevel() > 0 and not casterAbility:IsPassive() and not casterAbility:IsAttributeBonus() and not casterAbility:IsCooldownReady() then
								local newCooldown = casterAbility:GetCooldownTimeRemaining() - caster_cd_decrease
								casterAbility:EndCooldown()
								casterAbility:StartCooldown(newCooldown)
							end
						end
					end

					-- #5 TALENT: Bash spawns Chronospheres
					if attacker:HasTalent("special_bonus_imba_faceless_void_5") then
						attacker:FindAbilityByName("imba_faceless_void_chronosphere"):OnSpellStart(true, target:GetAbsOrigin())
					end

					-- Stun, based on if it's a hero or a creep
					if target:IsHero() then
						target:AddNewModifier(parent, ability, "modifier_imba_faceless_void_time_lock_stun", { duration = bashDuration })
					else
						target:AddNewModifier(parent, ability, "modifier_imba_faceless_void_time_lock_stun", { duration = creep_bash_duration})
					end

					-- Emit sound
					EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", target)

					-- Add a chronocharge if a hero was bashed
					if target:IsRealHero() then
						self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):SetStackCount(self:GetParent():FindModifierByName("modifier_imba_faceless_void_chronocharges"):GetStackCount() + 1)
					end

					-- Iterate through all victims abilities
					for i = 0, 23 do
						local targetAbility = target:GetAbilityByIndex(i)

						-- If there is an ability, it's learned, not a passive, not a talent/attribute bonus, and on cooldown, apply cooldown increase
						if targetAbility and targetAbility:GetLevel() > 0 and not targetAbility:IsPassive() and not targetAbility:IsAttributeBonus() and not targetAbility:IsCooldownReady() then
							local newCooldown = targetAbility:GetCooldownTimeRemaining() + cdIncrease + talent_cd_increase
							targetAbility:EndCooldown()
							targetAbility:StartCooldown(newCooldown)
						end
					end
					-- If the target IS affected by Chrono though, find enemies to bash and bash them.
				else
					-- Find enemies
					local enemies = FindUnitsInRadius(attacker:GetTeamNumber(),
						target:GetAbsOrigin(),
						nil,
						5000, 					-- Should be big enough for any chrono size
						ability:GetAbilityTargetTeam(),
						ability:GetAbilityTargetType(),
						ability:GetAbilityTargetFlags(),
						FIND_ANY_ORDER,
						false)

					-- Bash them
					for _,enemy in pairs(enemies) do
						if enemy:FindModifierByName("modifier_imba_faceless_void_chronosphere_handler") then

							-- #4 TALENT: Increases the cd increase on bash on enemies affected by time dilation and reduces his own
							if enemy:FindModifierByName("modifier_imba_faceless_void_time_dilation_slow") then
								talent_cd_increase			=	attacker:FindTalentValue("special_bonus_imba_faceless_void_4", "target_increase")
								local caster_cd_decrease	=	attacker:FindTalentValue("special_bonus_imba_faceless_void_4", "self_reduction")

								-- Iterate through all of Void's abilities
								for i = 0, 23 do
									local casterAbility = attacker:GetAbilityByIndex(i)
									-- If there is an ability, it's learned, not a passive, not a talent/attribute bonus, and on cooldown, apply cooldown increase
									if casterAbility and casterAbility:GetLevel() > 0 and not casterAbility:IsPassive() and not casterAbility:IsAttributeBonus() and not casterAbility:IsCooldownReady() then
										local newCooldown = casterAbility:GetCooldownTimeRemaining() - caster_cd_decrease
										casterAbility:EndCooldown()
										casterAbility:StartCooldown(newCooldown)
									end
								end
							end

							-- #5 TALENT: Bash spawns Chronospheres
							if attacker:HasTalent("special_bonus_imba_faceless_void_5") then
								attacker:FindAbilityByName("imba_faceless_void_chronosphere"):OnSpellStart(true, enemy:GetAbsOrigin())
							end

							-- Stun, based on if it's a hero or a creep
							if target:IsHero() then
								target:AddNewModifier(parent, ability, "modifier_imba_faceless_void_time_lock_stun", { duration = bashDuration })
							else
								target:AddNewModifier(parent, ability, "modifier_imba_faceless_void_time_lock_stun", { duration = creep_bash_duration})
							end

							-- Bonus damage to main target is already bundled in "GetModifierProcAttack_BonusDamage_Magical", so no need to damage the main target.
							if target ~= enemy then
								-- Deal damage
								ApplyDamage({attacker = parent, victim = enemy, ability = ability, damage = bashDamage, damage_type = DAMAGE_TYPE_MAGICAL})
							end
							-- Emit sound
							EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", enemy)

							-- Add a chronocharge if a hero was bashed
							if enemy:IsRealHero() then
								AddStacksLua(ability, parent, parent, "modifier_imba_faceless_void_chronocharges", 1, false)
							end

							-- Iterate through all victims abilities
							for i = 0, 23 do
								local enemyAbility = enemy:GetAbilityByIndex(i)
								-- If there is an ability, it's learned, not a passive, not a talent/attribute bonus, and on cooldown, apply cooldown increase
								if enemyAbility and enemyAbility:GetLevel() > 0 and not enemyAbility:IsPassive() and not enemyAbility:IsAttributeBonus() and not enemyAbility:IsCooldownReady() then
									local newCooldown = enemyAbility:GetCooldownTimeRemaining() + cdIncrease + talent_cd_increase
									enemyAbility:EndCooldown()
									enemyAbility:StartCooldown(newCooldown)
								end
							end

						end
					end
				end
			end
		end
		return bonus_damage_to_main_target
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
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_aura", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)		-- Aura - Handle applier
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_handler", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)	-- Handler
LinkLuaModifier("modifier_imba_faceless_void_chronosphere_caster_buff", "components/abilities/heroes/hero_faceless_void.lua", LUA_MODIFIER_MOTION_NONE)-- Bonus attack speed for caster and their minions

function imba_faceless_void_chronosphere:GetAbilityTextureName()
	return "faceless_void_chronosphere"
end

function imba_faceless_void_chronosphere:IsHiddenWhenStolen() return false end

function imba_faceless_void_chronosphere:GetAOERadius()
	local caster = self:GetCaster()
	local chronocharge_radius = self:GetSpecialValueFor("chronocharge_radius")
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

function imba_faceless_void_chronosphere:OnSpellStart( mini_chrono, target_location )
	local caster = self:GetCaster()
	local ability = self
	local chrono_center = self:GetCursorPosition()

	-- #5 TALENT: Mini chrono spawns around the bash target
	if target_location then
		chrono_center = target_location
	end

	local sound_cast = "Hero_FacelessVoid.Chronosphere"

	-- Parameters
	local base_radius = self:GetSpecialValueFor("base_radius")
	local chronocharge_radius = self:GetSpecialValueFor("chronocharge_radius")
	local duration = self:GetSpecialValueFor("duration")
	local total_radius

	-- #5 TALENT: Mini chrono doesn't consume charges
	if not mini_chrono then
		-- Fetch chronocharges and reset counter
		local chronocharges = 0
		local chronochargeModifier = caster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
		if chronochargeModifier then
			chronocharges = chronochargeModifier:GetStackCount()
		end

		-- Calculate final chronosphere parameters
		total_radius = base_radius + chronocharge_radius * chronocharges
	else
		-- #5 TALENT: Mini chrono has a different AOE and duration
		total_radius 		= 	caster:FindTalentValue("special_bonus_imba_faceless_void_5", "aoe")
		duration 			=	caster:FindTalentValue("special_bonus_imba_faceless_void_5", "duration")
	end

	-- Create flying vision node
	AddFOWViewer(caster:GetTeamNumber(), chrono_center, total_radius, duration, false)

	local enemies_count = 0
	if not mini_chrono then
		-- Decide which cast sound to play
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), chrono_center, nil, total_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false)
		enemies_count = #enemies
		if enemies_count >= PlayerResource:GetPlayerCount() * 0.35 then
			if self:IsStolen() then
				caster:EmitSound("Imba.StolenZaWarudo")		-- If stolen, Star Platinum ZA WARUDO
			else
				caster:EmitSound("Imba.FacelessZaWarudo")	-- Otherwise Dio ZA WARUDO
			end
		else
			caster:EmitSound(sound_cast)
		end
	end

	self.mini_chrono = mini_chrono
	-- Create the dummy and give it the chronosphere aura
	local mod = CreateModifierThinker(caster,
		ability,
		"modifier_imba_faceless_void_chronosphere_aura",
		{duration = duration},
		chrono_center,
		caster:GetTeamNumber(),
		false
	)
end

---------------------------------
-----	Chronosphere Aura	-----
---------------------------------
if modifier_imba_faceless_void_chronosphere_aura == nil then modifier_imba_faceless_void_chronosphere_aura = class({}) end
function modifier_imba_faceless_void_chronosphere_aura:IsPurgable() return false end
function modifier_imba_faceless_void_chronosphere_aura:IsHidden() return true end
function modifier_imba_faceless_void_chronosphere_aura:IsAura() return true end
function modifier_imba_faceless_void_chronosphere_aura:IsNetherWardStealable() return false end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraDuration()
	if self:GetAbility():GetCaster():HasTalent("special_bonus_imba_faceless_void_3") then return 0.01 end
	return 0.1
end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_OTHER end

function modifier_imba_faceless_void_chronosphere_aura:GetModifierAura()
	return "modifier_imba_faceless_void_chronosphere_handler" end

function modifier_imba_faceless_void_chronosphere_aura:GetAuraRadius()
	return self.total_radius
end

function modifier_imba_faceless_void_chronosphere_aura:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.mini_chrono = self.ability.mini_chrono
		-- Fetch chronocharges and reset counter
		if not self.mini_chrono then
			local chronocharges = 0
			local chronochargeModifier = self.caster:FindModifierByName("modifier_imba_faceless_void_chronocharges")
			if chronochargeModifier then
				chronocharges = chronochargeModifier:GetStackCount()
				chronochargeModifier:SetStackCount(0)
			end
			-- If chronocharges were spent, set the stack count accordingly
			self:SetStackCount(chronocharges)
		end

		self.base_radius = self.ability:GetSpecialValueFor("base_radius")
		self.bonus_radius = self.ability:GetSpecialValueFor("chronocharge_radius")
		self.total_radius = self.base_radius + self.bonus_radius * self:GetStackCount()

		-- #5 TALENT: Mini chrono has a different AOE
		if self.mini_chrono then
			self.total_radius 		= 	self.caster:FindTalentValue("special_bonus_imba_faceless_void_5", "aoe")
		end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chronosphere.vpcf", PATTACH_WORLDORIGIN, self.parent)
		ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(self.total_radius, self.total_radius, self.total_radius))
		self:AddParticle(particle, false, false, -1, false, false)

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
--  4 stacks = Caster or units under thier control and this is a mini chrono

function modifier_imba_faceless_void_chronosphere_handler:IsDebuff()
	if self:GetStackCount() == 1 or self:GetStackCount() == 4 then
		return false end
	return true
end

function modifier_imba_faceless_void_chronosphere_handler:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()
		self.mini_chrono = self:GetAbility().mini_chrono

		if self.parent == self.caster or self.parent:GetPlayerOwner() == self.caster:GetPlayerOwner() then
			if not self.mini_chrono then
				self:SetStackCount(1)
			else
				self:SetStackCount(4)
			end
		elseif self.parent:HasAbility("imba_faceless_void_timelord") then
			self:SetStackCount(3)
		elseif self.caster:HasScepter() and self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then
			self:SetStackCount(2)
		end

		-- #3 TALENT: Void dodges projectiles in Chrono
		if self:GetStackCount() == 1 then
			if self.caster:HasTalent("special_bonus_imba_faceless_void_3") then
				ProjectileManager:ProjectileDodge(self.parent)
			end
		end

		self:StartIntervalThink(FrameTime())
	end
end

function modifier_imba_faceless_void_chronosphere_handler:OnIntervalThink()
	if IsServer() then

		-- Normal frozen enemy gets interrupted all the time
		if self:GetStackCount() == 0 then

			-- Make certain people are stunned
			self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_stunned", {duration = FrameTime()})

			-- Non-IMBA handling
			self.parent:InterruptMotionControllers(true)

			-- IMBA handling
			local modifiers = self.parent:FindAllModifiers()
			for _,modifier in pairs(modifiers) do
				if modifier.IsMotionController then
					if modifier:IsMotionController() then
						modifier:Destroy()
					end
				end
			end
		end
	end
end

function modifier_imba_faceless_void_chronosphere_handler:DeclareFunctions()
	local funcs ={ 	MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		-- #8 TALENT: Void cleaves from attacks in chrono
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_imba_faceless_void_chronosphere_handler:CheckState()
	local stacks = self:GetStackCount()
	local state = {}

	if stacks == 0 then
		if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
			state = {[MODIFIER_STATE_STUNNED] = true,
				[MODIFIER_STATE_FROZEN] = true}
		end

		state = {	[MODIFIER_STATE_FROZEN] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_INVISIBLE] = false,}
	elseif stacks == 1 or stacks == 4 then
		state = {	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true, }
	end
	return state
end

function modifier_imba_faceless_void_chronosphere_handler:GetPriority()
	if self:GetStackCount() == 0 then
		return MODIFIER_PRIORITY_HIGH end
end

-- #3 TALENT: Void gains infinite movement speed in Chrono
function modifier_imba_faceless_void_chronosphere_handler:GetModifierMoveSpeed_Absolute()
	if self:GetStackCount() == 1 or self:GetStackCount() == 4 then
		-- This section does not work with mini-chronos
		if self:GetStackCount() ~= 4 then
			if self:GetCaster():HasTalent("special_bonus_imba_faceless_void_3") then
				return self:GetCaster():FindTalentValue("special_bonus_imba_faceless_void_3", "move_speed")
			end
		end
		return self:GetAbility():GetSpecialValueFor("movement_speed")
	end
end

function modifier_imba_faceless_void_chronosphere_handler:GetModifierMoveSpeed_Max()
	if self:GetStackCount() == 1 or self:GetStackCount() == 4 then
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

-- #8 TALENT: Void cleaves from attacks in chrono
function modifier_imba_faceless_void_chronosphere_handler:OnAttackLanded( params )
	local caster 	= self:GetCaster()
	if caster:HasTalent("special_bonus_imba_faceless_void_8") then
		local ability	= self:GetAbility()
		if (params.attacker == caster) and caster:IsRealHero() and (params.target:GetTeamNumber() ~= caster:GetTeamNumber()) and self:GetStackCount() == 1 then
			local cleave_particle = "particles/econ/items/faceless_void/faceless_void_weapon_bfury/faceless_void_weapon_bfury_cleave.vpcf"
			local cleave_damage_pct = caster:FindTalentValue("special_bonus_imba_faceless_void_8", "cleave_damage_pct") / 100
			local cleave_radius_start = caster:FindTalentValue("special_bonus_imba_faceless_void_8", "cleave_starting_width")
			local cleave_radius_end = caster:FindTalentValue("special_bonus_imba_faceless_void_8", "cleave_ending_width")
			local cleave_distance = caster:FindTalentValue("special_bonus_imba_faceless_void_8", "cleave_distance")

			DoCleaveAttack( params.attacker, params.target, ability, (params.damage * cleave_damage_pct), cleave_radius_start, cleave_radius_end, cleave_distance, cleave_particle )
		end
	end
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
	return PATTACH_ABSORIGIN_FOLLOW  end

function modifier_imba_faceless_void_chronosphere_caster_buff:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, }
	return funcs
end

function modifier_imba_faceless_void_chronosphere_caster_buff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("chronocharge_attackspeed") * self:GetStackCount() end
