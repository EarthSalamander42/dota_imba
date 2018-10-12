-- Editors:
--     Lindbrum, 11.11.2017

LinkLuaModifier("modifier_special_bonus_imba_pangolier_3", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_pangolier_3 = modifier_special_bonus_imba_pangolier_3 or class({})

function modifier_special_bonus_imba_pangolier_3:IsHidden() return true end
function modifier_special_bonus_imba_pangolier_3:IsPurgable() return false end
function modifier_special_bonus_imba_pangolier_3:RemoveOnDeath() return false end

--Talent #3: Grants Pangolier a parry modifier that will gain stacks through Shield Crash
function modifier_special_bonus_imba_pangolier_3:OnCreated()
	if IsServer() then
		self.shield_crash = self:GetCaster():FindAbilityByName("imba_pangolier_shield_crash")
		self.en_guarde = "modifier_imba_shield_crash_block"

		self:GetCaster():AddNewModifier(self:GetCaster(), self.shield_crash, self.en_guarde, {})
	end
end

function modifier_special_bonus_imba_pangolier_3:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_RESPAWN}

	return funcs
end

function modifier_special_bonus_imba_pangolier_3:OnRespawn(kv)
	if IsServer() then
		--Add again the modifier if somehow it was lost (stupid bugs)
		if not self:GetCaster():HasModifier(self.en_guarde) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self.shield_crash, self.en_guarde, {})

			--reset to last amount of stacks recorded
			self:GetCaster():SetModifierStackCount(self.en_guarde, self:GetCaster(), self:GetCaster():GetModifierStackCount("modifier_special_bonus_imba_pangolier_3", self:GetCaster()))
		end
	end
end

-------------------------------------
-----        SWASHBUCKLE       ------
-------------------------------------
imba_pangolier_swashbuckle = imba_pangolier_swashbuckle or class({})
LinkLuaModifier("modifier_imba_swashbuckle_dash", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_slashes", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_swashbuckle_buff", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)

function imba_pangolier_swashbuckle:GetAbilityTextureName()
	return "pangolier_swashbuckle"
end

function imba_pangolier_swashbuckle:IsHiddenWhenStolen() return false end
function imba_pangolier_swashbuckle:IsStealable() return true end
function imba_pangolier_swashbuckle:IsNetherWardStealable() return true end

function imba_pangolier_swashbuckle:GetAssociatedSecondaryAbilities()
	return "imba_pangolier_heartpiercer"
end

function imba_pangolier_swashbuckle:GetManaCost(level)
	local manacost = self.BaseClass.GetManaCost(self, level)

	return manacost
end

function imba_pangolier_swashbuckle:GetCastRange()
	return self:GetSpecialValueFor("dash_range")
end

function imba_pangolier_swashbuckle:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end

function imba_pangolier_swashbuckle:OnUpgrade()
	if IsServer() then
		--reapply En Guarde talent modifier to update the counter attack damage KV
		local caster = self:GetCaster()
		local en_guarde = "modifier_imba_shield_crash_block"

		if caster:HasTalent("special_bonus_imba_pangolier_3") then
			local stacks = caster:GetModifierStackCount(en_guarde, caster)
			caster:RemoveModifierByName(en_guarde)
			caster:AddNewModifier(caster, caster:FindAbilityByName("imba_pangolier_shield_crash"), en_guarde, {})
			caster:SetModifierStackCount(en_guarde, caster, stacks)
		end
	end
end

function imba_pangolier_swashbuckle:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local point = caster:GetCursorPosition()
	local sound_cast = "Hero_Pangolier.Swashbuckle.Cast"
	local modifier_movement = "modifier_imba_swashbuckle_dash"
	local attack_modifier = "modifier_imba_swashbuckle_slashes"

	-- Ability specials
	local dash_range = ability:GetSpecialValueFor("dash_range")
	local range = ability:GetSpecialValueFor("range")

	--Cancel Rolling Thunder if he was rolling
	local rolling_thunder = "modifier_pangolier_gyroshell" --Vanilla
	--local rolling_thunder = "modifier_imba_pangolier_gyroshell_roll" --Imba
	if caster:HasModifier(rolling_thunder) then
		caster:RemoveModifierByName(rolling_thunder)
	end

	-- Turn Pangolier toward the point he will dash (fix targeting for when cast in range AND there are no nearby enemies after dash)
	local direction = (point - caster:GetAbsOrigin()):Normalized()

	caster:SetForwardVector(direction)

	--play animation
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

	-- Play cast sound
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)

	--Begin moving to target point
	caster:AddNewModifier(caster, ability, modifier_movement, {})

	--Pass the targeted point to the modifier
	local modifier_movement_handler = caster:FindModifierByName(modifier_movement)
	modifier_movement_handler.target_point = point
end

--Dash movement modifier
modifier_imba_swashbuckle_dash = modifier_imba_swashbuckle_dash or class({})

function modifier_imba_swashbuckle_dash:OnCreated()
	--Ability properties
	self.attack_modifier = "modifier_imba_swashbuckle_slashes"
	self.dash_particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf"
	self.hit_sound = "Hero_Pangolier.Swashbuckle.Damage"

	--Ability specials
	self.dash_speed = self:GetAbility():GetSpecialValueFor("dash_speed")
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.talent_radius = self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_1", "radius")

	if IsServer() then
		--variables
		self.time_elapsed = 0

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self:GetCaster():GetAbsOrigin() - self.target_point):Length2D()
			self.dash_time = self.distance / self.dash_speed
			self.direction = (self.target_point - self:GetCaster():GetAbsOrigin()):Normalized()

			--Add dash particle
			local dash = ParticleManager:CreateParticle(self.dash_particle, PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(dash, 0, self:GetCaster():GetAbsOrigin()) -- point 0: origin, point 2: sparkles, point 5: burned soil
			self:AddParticle(dash, false, false, -1, true, false)

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

--pangolier is stunned during the dash
function modifier_imba_swashbuckle_dash:CheckState()
	--Talent #2: Pangolier is invulnerable while dashing
	if self:GetCaster():HasTalent("special_bonus_imba_pangolier_2") then
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_INVULNERABLE] = true
		}
	else
		state = {
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
		}
	end

	return state
end

function modifier_imba_swashbuckle_dash:IsHidden() return true end
function modifier_imba_swashbuckle_dash:IsPurgable() return false end
function modifier_imba_swashbuckle_dash:IsDebuff() return false end
function modifier_imba_swashbuckle_dash:IgnoreTenacity() return true end
function modifier_imba_swashbuckle_dash:IsMotionController() return true end
function modifier_imba_swashbuckle_dash:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_swashbuckle_dash:OnIntervalThink()

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	--Talent #1: Enemies in the dash path are applied a basic attack
	if self:GetCaster():HasTalent("special_bonus_imba_pangolier_1") then
		self.enemies_hit = self.enemies_hit or {}
		local direction = self:GetCaster():GetForwardVector()
		local caster_loc = self:GetCaster():GetAbsOrigin()
		local target_loc = caster_loc + direction * self.talent_radius

		--Check for enemies in front of pangolier
		local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),
			caster_loc,
			target_loc,
			nil,
			self.talent_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		for _,enemy in pairs(enemies) do
			--Do nothing if the target was hit already
			local already_hit = false
			for k,v in pairs(self.enemies_hit) do

				if v == enemy then
					already_hit = true
					break
				end
			end

			if not already_hit then
				--Play damage sound effect
				EmitSoundOn(self.hit_sound, enemy)

				--can't hit Ethereal enemies
				if not enemy:IsAttackImmune() then
					--Apply the basic attack
					self:GetCaster():PerformAttack(enemy, true, true, true, true, false, false, true)

					table.insert(self.enemies_hit, enemy) --Mark the target as hit
				end
			end

		end
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)
end

function modifier_imba_swashbuckle_dash:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still dashing
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.dash_time then

			-- Go forward
			local new_location = self:GetCaster():GetAbsOrigin() + self.direction * self.dash_speed * dt
			self:GetCaster():SetAbsOrigin(new_location)
		else
			self:Destroy()
		end
	end
end

function modifier_imba_swashbuckle_dash:OnRemoved()
	if IsServer() then
		self:GetCaster():SetUnitOnClearGround()

		--Pangolier finished the dash: look for enemies in range starting from the nearest
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.range,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
			FIND_CLOSEST,
			false)

		--Check if there is an enemy hero in range. In case there is, he will be targeted, otherwise the nearest enemy unit is targeted
		local target_unit = nil
		local target_direction = nil
		if #enemies > 0 then --In case there is no target in range, Pangolier will attack in front of him
			for _,enemy in pairs(enemies) do
				target_unit = target_unit or enemy	--track the nearest unit
				if enemy:IsRealHero() then
					target_unit = enemy
					break
				end
		end
		--Turn Pangolier towards the target
		target_direction = (target_unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
		self:GetCaster():SetForwardVector(target_direction)
		end

		--plays the slash animation
		self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

		--Add the attack modifier on Pangolier that will handle the slashes

		local attack_modifier_handler = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.attack_modifier, {})

		--pass the target
		attack_modifier_handler.target = target_unit
	end
end

--attack modifier: will handle the slashes
modifier_imba_swashbuckle_slashes = modifier_imba_swashbuckle_slashes or class({})

function modifier_imba_swashbuckle_slashes:OnCreated()
	--Ability properties
	self.buff = "modifier_imba_swashbuckle_buff"
	self.particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
	self.hit_particle = "particles/generic_gameplay/generic_hit_blood.vpcf"
	self.slashing_sound = "Hero_Pangolier.Swashbuckle"
	self.hit_sound= "Hero_Pangolier.Swashbuckle.Damage"
	self.slash_particle = {}
	--Ability specials
	self.range = self:GetAbility():GetSpecialValueFor("range")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.start_radius = self:GetAbility():GetSpecialValueFor("start_radius")
	self.end_radius = self:GetAbility():GetSpecialValueFor("end_radius")
	self.strikes = self:GetAbility():GetSpecialValueFor("strikes")
	self.attack_interval = self:GetAbility():GetSpecialValueFor("attack_interval")
	self.buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")

	if IsServer() then
		--variables
		self.executed_strikes = 0

		--wait one frame to acquire the target from the ability
		Timers:CreateTimer(FrameTime(), function()
			--Set the point to use for the direction. If no units were found from the ability, use Pangolier current forward vector
			self.direction = nil -- needed for the particle
			if self.target then
				self.direction = (self.target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
				self.fixed_target = self:GetCaster():GetAbsOrigin() + self.direction * self.range -- will lock the targeting on the direction of the target on-cast
			else --no units found
				self.direction = self:GetCaster():GetForwardVector():Normalized()
				self.fixed_target = self:GetCaster():GetAbsOrigin() + self.direction * self.range
			end

			--start interval thinker
			self:StartIntervalThink(self.attack_interval)
		end)
	end
end

function modifier_imba_swashbuckle_slashes:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}

	return declfuncs
end

function modifier_imba_swashbuckle_slashes:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_1_END
end

function modifier_imba_swashbuckle_slashes:OnIntervalThink()
	if IsServer() then
		--check if pangolier is done slashing
		if self.executed_strikes == self.strikes then
			self:Destroy()
			return nil
		end

		--Talent #2: Pangolier disjoint projectiles while slashing
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_2") then
			ProjectileManager:ProjectileDodge(self:GetCaster())
		end

		--play slashing particle
		self.slash_particle[self.executed_strikes] = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(self.slash_particle[self.executed_strikes], 0, self:GetCaster():GetAbsOrigin()) --origin of particle
		ParticleManager:SetParticleControl(self.slash_particle[self.executed_strikes], 1, self.direction * self.range) --direction and range of the subparticles


		--plays the attack sound
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.slashing_sound, self:GetCaster())

		--Check for enemies in the direction set on cast
		local enemies = FindUnitsInLine(
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			self.fixed_target,
			nil,
			self.start_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
		)

		for _,enemy in pairs(enemies) do
			--Play damage sound effect
			EmitSoundOn(self.hit_sound, enemy)

			--can't hit Ethereal enemies
			if not enemy:IsAttackImmune() then
				--Play blood particle on targets
				local blood_particle = ParticleManager:CreateParticle(self.hit_particle, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(blood_particle, 0, enemy:GetAbsOrigin()) --origin of particle
				ParticleManager:SetParticleControl(blood_particle, 2, self.direction * 500) --direction and speed of the blood spills

				--Talent #8: Swashbuckle also uses a % of Pangolier attack damage
				if self:GetCaster():HasTalent("special_bonus_imba_pangolier_8") then
					self.damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) / (100 / self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_8"))
				end

				--Apply the damage from the slash
				local damageTable = {victim = enemy,
					damage = self.damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
					attacker = self:GetCaster(),
					ability = nil
				}

				ApplyDamage(damageTable)
				SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_DAMAGE, enemy, self.damage, nil)

				--Apply on-hit effects
				self:GetCaster():PerformAttack(enemy, true, true, true, true, false, true, true)
			end
		end

		--increment the slash counter
		self.executed_strikes = self.executed_strikes + 1
	end
end

function modifier_imba_swashbuckle_slashes:OnRemoved()
	if IsServer() then
		--remove slash particle instances
		for k,v in pairs(self.slash_particle) do
			ParticleManager:DestroyParticle(v, false)
			ParticleManager:ReleaseParticleIndex(v)
		end

		--Apply the attack speed buff
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff, {duration = self.buff_duration})
	end
end

function modifier_imba_swashbuckle_slashes:CheckState()
	state = {[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true}

	return state
end

--Swashbuckle attack speed buff
modifier_imba_swashbuckle_buff = modifier_imba_swashbuckle_buff or class({})

function modifier_imba_swashbuckle_buff:IsHidden() return false end
function modifier_imba_swashbuckle_buff:IsPurgable() return true end
function modifier_imba_swashbuckle_buff:IsDebuff() return false end

function modifier_imba_swashbuckle_buff:OnCreated()
	if IsServer() then
		--Ability properties


		--Ability specials
		self.bonus_as = self:GetAbility():GetSpecialValueFor("bonus_attackspeed")
		self.max_attacks = self:GetAbility():GetSpecialValueFor("max_attacks")

		--Set stacks to the max attacks
		self:SetStackCount(self.max_attacks)

		self.attacks = 0
	end
end

function modifier_imba_swashbuckle_buff:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK}

	return funcs
end

function modifier_imba_swashbuckle_buff:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_imba_swashbuckle_buff:OnAttack(keys)
	if IsServer() then
		--Proceed only if the attacker is the caster
		if keys.attacker == self:GetCaster() then
			--increase the attack count
			self.attacks = self.attacks + 1
			--decrease stacks on modifier
			self:SetStackCount(self:GetStackCount() - 1)

			--Remove the buff after the max attacks have been performed
			if self.attacks >= self.max_attacks then
				self:Destroy()
			end
		end
	end
end

-------------------------------------
-----      SHIELD CRUSH         -----
-------------------------------------
imba_pangolier_shield_crash = imba_pangolier_shield_crash or class({})
LinkLuaModifier("modifier_imba_shield_crash_buff", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) -- Damage reduction
LinkLuaModifier("modifier_imba_shield_crash_jump", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) -- movement
LinkLuaModifier("modifier_imba_shield_crash_block", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) -- Talent #3: parry stacks
LinkLuaModifier("modifier_imba_shield_crash_block_parry", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) --Talent #3: Pangolier parry (100% evasion)
LinkLuaModifier("modifier_imba_shield_crash_block_miss", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) --Talent #3: Parried attack debuff (remove true strike during the attack)

function imba_pangolier_shield_crash:GetAbilityTextureName()
	return "pangolier_shield_crash"
end

function imba_pangolier_shield_crash:IsHiddenWhenStolen()  return false end
function imba_pangolier_shield_crash:IsStealable() return true end
function imba_pangolier_shield_crash:IsNetherWardStealable() return false end

-- Should close out problems with Pangolier not getting the specific talent if skilled while dead
function imba_pangolier_shield_crash:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_pangolier_3") and self:GetCaster():FindAbilityByName("special_bonus_imba_pangolier_3"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_pangolier_3") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_pangolier_3", {})
	end
end

function imba_pangolier_shield_crash:GetManaCost(level)
	local manacost = self.BaseClass.GetManaCost(self, level)

	return manacost
end

function imba_pangolier_shield_crash:GetCooldown(level)

	local cooldown = self.BaseClass.GetCooldown(self, level)
	local caster = self:GetCaster()
	local roll_cooldown = self:GetSpecialValueFor("roll_cooldown")

	-- Shield Crash cooldown is set to 2 seconds during Rolling Thunder
	if caster:HasModifier("modifier_pangolier_gyroshell") then

		return roll_cooldown

	end
	return cooldown
end


function imba_pangolier_shield_crash:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end


function imba_pangolier_shield_crash:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_cast= "Hero_Pangolier.TailThump.Cast"
	local gyroshell_ability = caster:FindAbilityByName("imba_pangolier_gyroshell")
	local modifier_movement = "modifier_imba_shield_crash_jump"
	local dust_particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf"
	

	-- Ability specials
	local jump_duration = ability:GetSpecialValueFor("jump_duration")
	local jump_duration_gyroshell = ability:GetSpecialValueFor("jump_duration_gyroshell")
	local jump_height = ability:GetSpecialValueFor("jump_height")
	local jump_height_gyroshell = ability:GetSpecialValueFor("jump_height_gyroshell")
	local jump_horizontal_distance = ability:GetSpecialValueFor("jump_horizontal_distance")

	-- Play animation and dust particle
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	local dust = ParticleManager:CreateParticle(dust_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(dust, 0, caster:GetAbsOrigin())

	-- Play cast sound
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)

	--jump in the faced direction
	local modifier_movement_handler = caster:AddNewModifier(caster, ability, modifier_movement, {})

	-- Assign the landing point, jump height and duration in the modifier
	if modifier_movement_handler then
		modifier_movement_handler.dust_particle = dust

		if self:IsStolen() then --Avoid errors because gyroshell isn't associated to Shield Crash when stolen

			modifier_movement_handler.target_point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * jump_horizontal_distance
			modifier_movement_handler.jump_height = jump_height
			modifier_movement_handler.jump_duration = jump_duration
		else

			local gyroshell_horizontal_distance
			if gyroshell_ability then
				gyroshell_horizontal_distance = jump_duration_gyroshell * gyroshell_ability:GetSpecialValueFor("forward_move_speed")
			end

			--if Pangolier is rolling, the jump will be longer
			if caster:HasModifier("modifier_pangolier_gyroshell") then
				modifier_movement_handler.target_point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * gyroshell_horizontal_distance
				modifier_movement_handler.jump_height = jump_height_gyroshell
				modifier_movement_handler.jump_duration = jump_duration_gyroshell
			else --shorter jump
				modifier_movement_handler.target_point = caster:GetAbsOrigin() + caster:GetForwardVector():Normalized() * jump_horizontal_distance
				modifier_movement_handler.jump_height = jump_height
				modifier_movement_handler.jump_duration = jump_duration
			end
		end
	end
end

--Shield Crash damage reduction modifier
modifier_imba_shield_crash_buff = modifier_imba_shield_crash_buff or class ({})
function modifier_imba_shield_crash_buff:OnCreated(kv)
	-- Ability properties
	self.stacks = kv.stacks
	self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
	self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
	self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
	self.sound = "Hero_Pangolier.TailThump.Shield"
	self.buff_particles = {}

	-- Ability specials
	self.damage_reduction_pct = self:GetAbility():GetSpecialValueFor("hero_stacks")


	if IsServer() then
		--set the stacks to the total % of mitigation for readability
		self:SetStackCount(self.damage_reduction_pct * self.stacks)

		--Play buff sound effect
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.sound, self:GetCaster())

		--Add buff particles depending on the stack amount:
		if self.stacks > 0 then --Tier 1: up to 2 enemy heroes hit. Pangolier will gain a swirling effect on him with floating shields.
			self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) --origin
			self:AddParticle(self.buff_particles[1], false, false, -1, true, false)

			if self.stacks >= 3 then --Tier 2: 3 enemy heroes hit. Pangolier will also have a light aura under his feet
				self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) --origin
				self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

				if self.stacks >= 4 then --Tier 3: 4+ enemy heroes hit. Pangolier will gain an ascending light effect
					self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) --origin
					self:AddParticle(self.buff_particles[3], false, false, -1, true, false)
				end
			end
		end
	end
end


function modifier_imba_shield_crash_buff:DestroyOnExpire()
	return true
end

function modifier_imba_shield_crash_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}

	return decFuncs
end

function modifier_imba_shield_crash_buff:GetModifierIncomingDamage_Percentage()

	return self.damage_reduction_pct * self.stacks * (-1)
end



function modifier_imba_shield_crash_buff:IsPermanent() return false end
function modifier_imba_shield_crash_buff:IsHidden() return false end
function modifier_imba_shield_crash_buff:IsPurgable() return true end
function modifier_imba_shield_crash_buff:IsDebuff() return false end
function modifier_imba_shield_crash_buff:AllowIllusionDuplicate() return true end
function modifier_imba_shield_crash_buff:IsStealable() return true end



--Shield crash jump movement modifier
modifier_imba_shield_crash_jump = modifier_imba_shield_crash_jump or class({})

function modifier_imba_shield_crash_jump:OnCreated()
	-- Ability properties
	self.buff_modifier = "modifier_imba_shield_crash_buff"
	self.smash_particle = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"
	self.smash_sound = "Hero_Pangolier.TailThump"
	self.gyroshell = "modifier_pangolier_gyroshell" --Vanilla
	--self.gyroshell = "modifier_imba_gyroshell_roll" --Imba

	-- Ability specials
	-- self.jump_height passed by the ability
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.hero_stacks = self:GetAbility():GetSpecialValueFor("hero_stacks")

	if IsServer() then

		-- Variables
		self.time_elapsed = 0
		self.jump_z = 0
		self.no_horizontal = false

		-- Wait one frame to get the target point from the ability's OnSpellStart, then calculate distance
		Timers:CreateTimer(FrameTime(), function()
			self.distance = (self:GetCaster():GetAbsOrigin() - self.target_point):Length2D()
			self.jump_time = self.jump_duration
			self.jump_speed = self.distance / self.jump_time

			self.direction = (self.target_point - self:GetCaster():GetAbsOrigin()):Normalized()

			self.frametime = FrameTime()
			self:StartIntervalThink(self.frametime)
		end)
	end
end

function modifier_imba_shield_crash_jump:CheckState()
	--becomes fully disabled if jumping while not rolling
	if self:GetCaster():HasModifier(self.gyroshell) then
		state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else
		state = {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true}
	end

	return state
end

function modifier_imba_shield_crash_jump:OnIntervalThink()
	-- Check motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Vertical Motion
	self:VerticalMotion(self:GetCaster(), self.frametime)

	-- Horizontal Motion only needed when Pangolier isn't rolling, won't gain horizontal movement
	-- if Rolling Thunder end mid-jump
	if not self.no_horizontal and not self:GetCaster():HasModifier("modifier_pangolier_gyroshell") then
		self:HorizontalMotion(self:GetCaster(), self.frametime)
	else
		self.no_horizontal = true
	end
end

function modifier_imba_shield_crash_jump:IsHidden() return true end
function modifier_imba_shield_crash_jump:IsPurgable() return false end
function modifier_imba_shield_crash_jump:IsDebuff() return false end
function modifier_imba_shield_crash_jump:IgnoreTenacity() return true end
function modifier_imba_shield_crash_jump:IsMotionController() return true end
function modifier_imba_shield_crash_jump:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end

function modifier_imba_shield_crash_jump:VerticalMotion(me, dt)
	if IsServer() then

		-- Check if we're still jumping
		self.time_elapsed = self.time_elapsed + dt
		if self.time_elapsed < self.jump_time then

			-- Check if we should be going up or down
			if self.time_elapsed <= self.jump_time / 2 then
				-- Going up
				self.jump_z = self.jump_z + ((self.jump_height * dt) / (self.jump_time / 2))


				self:GetCaster():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + Vector(0,0,self.jump_z))
			else
				-- Going down
				self.jump_z = self.jump_z - ((self.jump_height * dt) / (self.jump_time / 2))
				if self.jump_z > 0 then
					self:GetCaster():SetAbsOrigin(GetGroundPosition(self:GetCaster():GetAbsOrigin(), self:GetCaster()) + Vector(0,0,self.jump_z))
				end

			end
		else
			self:Destroy()
		end
	end
end

function modifier_imba_shield_crash_jump:HorizontalMotion(me, dt)
	if IsServer() then
		-- Check if we're still jumping
		if self.time_elapsed < self.jump_time then

			-- Go forward
			local new_location = self:GetCaster():GetAbsOrigin() + self.direction * self.jump_speed * dt
			self:GetCaster():SetAbsOrigin(new_location)
		end
	end
end


function modifier_imba_shield_crash_jump:OnRemoved()
	if IsServer() then
		self:GetCaster():SetUnitOnClearGround()

		--play the smash particle
		local smash = ParticleManager:CreateParticle(self.smash_particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())

		-- Play smash sound
		EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.smash_sound, self:GetCaster())

		-- Find heroes in AoE and track how many will be damaged
		local enemy_heroes = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
			FIND_ANY_ORDER,
			false
		)

		local damaged_heroes = #enemy_heroes

		--Talent: extra damage for each enemy hero damaged (REMOVED)
		--local total_damage = self.damage + (damaged_heroes * self.talent_damage)

		-- Find all enemies in AoE
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		-- Deal damage to each enemy
		for _,enemy in pairs(enemies) do
			if not enemy:IsMagicImmune() then
				damage_table = ({
					victim = enemy,
					attacker = self:GetCaster(),
					ability = self:GetAbility(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL
				})

				ApplyDamage(damage_table)
			end
		end

		--Create the damage reduction modifier. If it already exist,
		--upgrade its stacks if the new count is higher and refresh
		if damaged_heroes > 0 then

			--Talent #3: Earn stacks of parry based on the heroes hit with Shield Crash
			if self:GetCaster():HasTalent("special_bonus_imba_pangolier_3") then
				local block_modifier_stacks = self:GetCaster():GetModifierStackCount("modifier_imba_shield_crash_block", self:GetCaster())
				self:GetCaster():SetModifierStackCount("modifier_imba_shield_crash_block", self:GetCaster(), block_modifier_stacks + damaged_heroes)
				self:GetCaster():SetModifierStackCount("modifier_special_bonus_imba_pangolier_3", self:GetCaster(), block_modifier_stacks + damaged_heroes)
			end

			if self:GetCaster():HasModifier(self.buff_modifier) then
				local old_stacks = self:GetCaster():GetModifierStackCount(self.buff_modifier, self:GetCaster())

				--Remove previous buff particles
				local buff = self:GetCaster():FindModifierByName("modifier_imba_shield_crash_buff")

				for k,v in pairs(buff.buff_particles) do
					ParticleManager:DestroyParticle(v, false)
					ParticleManager:ReleaseParticleIndex(v)
					table.remove(buff.buff_particles, k)
				end

				--remove modifier then reapply it to play update the particles
				self:GetCaster():RemoveModifierByName(self.buff_modifier)

				if damaged_heroes > old_stacks / self.hero_stacks then
					self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.duration, stacks = damaged_heroes})
				else
					self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.duration, stacks = old_stacks / self.hero_stacks})
				end
			else
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.buff_modifier, {duration = self.duration, stacks = damaged_heroes})
			end
		end

		--destroy and release particle indexes
		ParticleManager:DestroyParticle(self.dust_particle, false)
		ParticleManager:ReleaseParticleIndex(self.dust_particle)
		ParticleManager:ReleaseParticleIndex(smash)
	end
end

--Needed for imba Rolling Thunder modifier
--[[function modifier_imba_shield_crash_jump:OnDestroy()
	if IsServer() then
		--boost rolling thunder turn rate
		local gyroshell_handler = self:GetCaster():FindModifierByName(self.gyroshell)
		if gyroshell_handler then
			--plays bounce animation if rolling
			self:GetCaster():StartGesture()
			gyroshell_handler.boosted_turn = true
			gyroshell_handler.boosted_turn_time = 0
			gyroshell_handler:GetModifierTurnRate_Percentage()
		end
	end
end]]

--Talent #3 modifier: each stack will block an attack directed to Pangolier from an enemy hero and start a counterattack (1 Swashbuckle slash)
modifier_imba_shield_crash_block = modifier_imba_shield_crash_block or class({})

function modifier_imba_shield_crash_block:IsHidden() return false end
function modifier_imba_shield_crash_block:IsPurgable() return false end --WHY THE FUCK IS THIS FAILING SOMETIMES?!
function modifier_imba_shield_crash_block:IsPermanent() return true end
function modifier_imba_shield_crash_block:RemoveOnDeath() return false end
function modifier_imba_shield_crash_block:IsDebuff() return false end


function modifier_imba_shield_crash_block:OnCreated()
	if IsServer() then
		--Ability Properties

		self.swashbuckle = self:GetCaster():FindAbilityByName("imba_pangolier_swashbuckle")
		self.particle = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
		self.slashing_sound = "Hero_Pangolier.Swashbuckle"
		self.hit_sound= "Hero_Pangolier.Swashbuckle.Damage"
		self.hero_attacks = 0
		self.attackers = self.attackers or {}


		--Ability Specials
		self.counter_range = self.swashbuckle:GetSpecialValueFor("range")
		self.counter_damage = self.swashbuckle:GetSpecialValueFor("damage")
		self.start_radius = self.swashbuckle:GetSpecialValueFor("start_radius")
		self.end_radius = self.swashbuckle:GetSpecialValueFor("end_radius")

		--SORRY RUBICK!
		if self:GetAbility():IsStolen() then
			self:Destroy()
		end

		--initialize stack count
		self:SetStackCount(0)
	end
end

function modifier_imba_shield_crash_block:DeclareFunctions()
	funcs = {MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
		MODIFIER_PROPERTY_EVASION_CONSTANT}

	return funcs
end

function modifier_imba_shield_crash_block:GetModifierEvasion_Constant(params)
	--If the attack is to be parried, maximize evasion
	local parried = false
	for k,v in pairs(self.attackers) do
		if v == params.attacker then --has the attacker launched an attack to parry?
			parried = true
			break
		end
	end
	if parried then

		return 100
	else

		return 0
	end
end

function modifier_imba_shield_crash_block:OnAttackStart(keys)

	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		--proceed only if the target is Pangolier and the attacker is an hero
		if target == self:GetCaster() and attacker:IsHero() then

			--if pangolier is rolling, do nothing
			if self:GetCaster():HasModifier("modifier_pangolier_gyroshell") then
				return nil
			end

			--if no parry stacks remains, do nothing
			local stacks = self:GetCaster():GetModifierStackCount("modifier_imba_shield_crash_block", self:GetCaster())

			if stacks == 0 then
				--clears the attackers table to avoid inconsistencies
				self.attackers = {}
				return nil
			end

			--Makes Pangolier dodge the next hero attack
			--self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shield_crash_block_parry", {})

			--Makes the attacking hero ignore true strike
			attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_shield_crash_block_miss", {})


			--Register the attacker
			table.insert(self.attackers, attacker)

			--account the attack to parry
			self.hero_attacks = self.hero_attacks + 1

		end
	end
end

function modifier_imba_shield_crash_block:OnAttack(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target
		--proceed only if the target is Pangolier and the attacker is an hero
		if target == self:GetCaster() and attacker:IsHero() then

			--if Pangolier is rolling, do nothing
			if self:GetCaster():HasModifier("modifier_pangolier_gyroshell") then
				return nil
			end

			--check if the attack is going to be parried, remove true strike prevention

			if self.hero_attacks > 0 then
				--Signal that the attack was parried
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MISS, attacker, 0, nil)
				self.hero_attacks = self.hero_attacks - 1

			end

			--If all incoming attacks have been parried, remove the evasion on pangolier
			--if self.hero_attacks == 0 and self:GetCaster():HasModifier("modifier_imba_shield_crash_block_parry") then
			--	self:GetCaster():RemoveModifierByName("modifier_imba_shield_crash_block_parry")
			--end


			local stacks = self:GetCaster():GetModifierStackCount("modifier_imba_shield_crash_block", self:GetCaster())


			local caster_loc = self:GetCaster():GetAbsOrigin()
			local attacker_loc = attacker:GetAbsOrigin()
			local distance = (attacker_loc - caster_loc):Length2D()
			
			--counter if Pangolier has stacks, the attacker is an enemy and is in range
			if stacks > 0 and attacker:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and distance < self.counter_range then
				local old_direction = self:GetCaster():GetForwardVector()
				local direction = (attacker_loc - caster_loc):Normalized()
				local target_point = caster_loc + direction * self.counter_range

				--Make Pangolier turn to the target
				self:GetCaster():SetForwardVector(direction)

				--plays slash animation
				self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

				--plays the attack sound
				EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), self.slashing_sound, self:GetCaster())

				--play slashing particle
				local slash_particle = ParticleManager:CreateParticle(self.particle, PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(slash_particle, 0, self:GetCaster():GetAbsOrigin()) --origin of particle
				ParticleManager:SetParticleControl(slash_particle, 1, direction * self.counter_range) --direction and range of the subparticles



				--Check for enemies in the direction set on cast
				local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),
					caster_loc,
					target_point,
					nil,
					self.start_radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)


				for _,enemy in pairs(enemies) do

					--Play damage sound effect
					EmitSoundOn(self.hit_sound, enemy)

					--can't hit Ethereal enemies
					if not enemy:IsAttackImmune() then
						--Talent #8: Swashbuckle also uses Pangolier attack damage
						if self:GetCaster():HasTalent("special_bonus_imba_pangolier_8") then

							--Apply the damage from the slash
							local damageTable = {victim = enemy,
								damage = self.counter_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
								attacker = self:GetCaster(),
								ability = nil
							}



							ApplyDamage(damageTable)

							--and also perform a basic attack
							self:GetCaster():PerformAttack(enemy, true, true, true, true, false, false, true)

						else --No talent: only perform a fake basic attack for the on-hit effects
							--Apply the damage from the slash
							local damageTable = {victim = enemy,
								damage = self.counter_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
								attacker = self:GetCaster(),
								ability = nil
							}

							ApplyDamage(damageTable)

							--Apply on-hit effects
							self:GetCaster():PerformAttack(enemy, true, true, true, true, false, true, true)
						end
					end
				end

				--Decrease parry stacks
				self:GetCaster():SetModifierStackCount("modifier_imba_shield_crash_block", self:GetCaster(), stacks - 1)
				self:GetCaster():SetModifierStackCount("modifier_special_bonus_imba_pangolier_3", self:GetCaster(), stacks - 1)

				Timers:CreateTimer(0.5, function ()
					--Remove particles
					ParticleManager:DestroyParticle(slash_particle, false)
					ParticleManager:ReleaseParticleIndex(slash_particle)

					--end slash animation
					self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

					--Turn pangolier back to his previous direction
					self:GetCaster():SetForwardVector(old_direction)
				end)
			end
		end
	end
end

function modifier_imba_shield_crash_block:OnAttackFinished(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		--Proceed only if the target is Pangolier and the attacker is an hero
		if target == self:GetCaster() and attacker:IsHero() then

			--Remove debuff on attacker and remove him from table
			if attacker:HasModifier("modifier_imba_shield_crash_block_miss") then
				attacker:RemoveModifierByName("modifier_imba_shield_crash_block_miss")
				for k,v in pairs(self.attackers) do
					if v == attacker then
						table.remove(self.attackers, k)
					end
				end
			end
		end
	end
end

--Attackers debuff: deny their true strike effect while Pangolier is parrying their attack
modifier_imba_shield_crash_block_miss = modifier_imba_shield_crash_block_miss or class({})

function modifier_imba_shield_crash_block_miss:IsHidden() return true end
function modifier_imba_shield_crash_block_miss:IsDebuff() return true end
function modifier_imba_shield_crash_block_miss:IsPurgable() return false end
function modifier_imba_shield_crash_block_miss:RemoveOnDeath() return true end
function modifier_imba_shield_crash_block_miss:StatusEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_imba_shield_crash_block_miss:CheckState()
	state = {[MODIFIER_STATE_CANNOT_MISS] = false}

	return state
end

------------------------------------
-----      HEARTPIERCER        -----
------------------------------------
imba_pangolier_heartpiercer = imba_pangolier_heartpiercer or class({})
LinkLuaModifier("modifier_imba_heartpiercer_passive", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartpiercer_delay", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartpiercer_debuff", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartpiercer_talent_debuff", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) --visual
LinkLuaModifier("modifier_imba_heartpiercer_talent_debuff_2", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) --visual


function imba_pangolier_heartpiercer:GetAbilityTextureName()
	return "pangolier_heartpiercer"
end

function imba_pangolier_heartpiercer:GetIntrinsicModifierName()
	return "modifier_imba_heartpiercer_passive"
end

function imba_pangolier_heartpiercer:OnUnStolen()
	if IsServer() then
		local caster = self:GetCaster()

		--Remove the modifier from Rubick
		if caster:HasModifier("modifier_imba_heartpiercer_passive") then
			caster:RemoveModifierByName("modifier_imba_heartpiercer_passive")
		end
	end
end

function imba_pangolier_heartpiercer:OnUpgrade()
	--refresh intrinsic modifier to update KVs
	local caster = self:GetCaster()

	caster:RemoveModifierByName("modifier_imba_heartpiercer_passive")
	caster:AddNewModifier(caster, self, "modifier_imba_heartpiercer_passive", {})
end


function imba_pangolier_heartpiercer:IsStealable() return false end
function imba_pangolier_heartpiercer:IsNetherWardStealable() return false end

--HEARTPIERCER PASSIVE MODIFIER (the one that let Pangolier apply the debuff)
modifier_imba_heartpiercer_passive = modifier_imba_heartpiercer_passive or class ({})

function modifier_imba_heartpiercer_passive:OnCreated()
	--Ability properties
	self.proc_sound_hero = "Hero_Pangolier.HeartPiercer.Proc"
	self.proc_sound_creep = "Hero_Pangolier.HeartPiercer.Proc.Creep"
	self.delayed_debuff = "modifier_imba_heartpiercer_delay"
	self.procced_debuff = "modifier_imba_heartpiercer_debuff"
	self:GetCaster().allow_heartpiercer = true --Used for Talent #5 heartpiercer reproc loop prevention

	--Ability specials
	self.chance_pct = self:GetAbility():GetSpecialValueFor("chance_pct")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.debuff_delay = self:GetAbility():GetSpecialValueFor("debuff_delay")
end

function modifier_imba_heartpiercer_passive:DeclareFunctions()
	local declfuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return declfuncs
end

function modifier_imba_heartpiercer_passive:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target

		-- Only apply if the attacker is the parent
		if self:GetParent() == attacker then
			--If the target is a building, do nothing
			if target:IsBuilding() then
				return nil
			end

			-- If the parent is broken, do nothing
			if self:GetParent():PassivesDisabled() then
				return nil
			end

			--Won't work on Roshan
			--if target:IsRoshan() then
			--	return nil
			--  end

			--Roll for the pierce chance, won't work on magic immune enemies or if it would proc from Talent #5 attacks
			if self:GetCaster().allow_heartpiercer and not target:IsMagicImmune() and RollPercentage(self.chance_pct) then
				--heartpiercer procced

				--check if heartpiercer is already in effect on the target. If it is, refresh the modifier
				-- (will also take care of any change to bonus armor gained while debuffed)

				if target:HasModifier(self.procced_debuff) then
					target:RemoveModifierByName(self.procced_debuff)
					target:AddNewModifier(self:GetCaster(), self:GetAbility(), self.procced_debuff, {duration = self.duration})
					return
				else
					if not target:HasModifier(self.delayed_debuff) and not target:HasModifier(self.procced_debuff) then --heartpiercer wasn't already in effect: apply the delay if it's not already in effect
						--play proc sound effect
						if target:IsCreep() then
							EmitSoundOn(self.proc_sound_creep, target)
						else

							EmitSoundOn(self.proc_sound_hero, target)
						end

						target:AddNewModifier(self:GetParent(), self:GetAbility(), self.delayed_debuff, {duration = self.debuff_delay})
					end
				end
			end
		end
	end
end

function modifier_imba_heartpiercer_passive:IsHidden() return true end
function modifier_imba_heartpiercer_passive:IsPurgable() return false end
function modifier_imba_heartpiercer_passive:IsStealable() return false end
function modifier_imba_heartpiercer_passive:IsPermanent() return true end
function modifier_imba_heartpiercer_passive:IsDebuff() return false end


--Heartpiercer initial debuff delay modifier
modifier_imba_heartpiercer_delay = modifier_imba_heartpiercer_delay or class({})

function modifier_imba_heartpiercer_delay:OnCreated()
	--Ability properties
	self.icon = "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_delay.vpcf"

	--Ability specials
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")

	--add overhead particle
	local icon_particle = ParticleManager:CreateParticle(self.icon, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(icon_particle, false, false, -1, true, true)
end

function modifier_imba_heartpiercer_delay:OnRemoved()
	if IsServer() then
		--apply the debuff
		local modifier_handler = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_heartpiercer_debuff", {duration = self.duration})
	end
end

function modifier_imba_heartpiercer_delay:IsHidden() return false end
function modifier_imba_heartpiercer_delay:IsPurgable() return true end
function modifier_imba_heartpiercer_delay:IsPermanent() return false end
function modifier_imba_heartpiercer_delay:IsDebuff() return true end

--Heartpiercer debuff modifier
modifier_imba_heartpiercer_debuff = modifier_imba_heartpiercer_debuff or class ({})

function modifier_imba_heartpiercer_debuff:OnCreated()
	--Ability properties
	self.icon = "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_debuff.vpcf"
	self.debuff_sound_creep = "Hero_Pangolier.HeartPiercer.Creep"
	self.debuff_sound_hero = "Hero_Pangolier.HeartPiercer"

	--Ability specials
	self.armor = self:GetParent():GetPhysicalArmorValue() * (-1)
	self.slow_pct = self:GetAbility():GetSpecialValueFor("slow_pct")
	self.talent_interval = self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_5", "tick_interval")
	self.damage_per_second = self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_5", "damage_per_second")
	self.talent_tenacity_pct = self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_6")

	if IsServer() then
		--play debuff sound
		if self:GetParent():IsCreep() then
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), self.debuff_sound_creep, self:GetParent())
		else
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), self.debuff_sound_hero, self:GetParent())
		end

		--create overhead particle
		local icon_particle = ParticleManager:CreateParticle(self.icon, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(icon_particle, false, false, -1, true, true)

		--Talent #5: Victim will take damage over time and proc on-hit effects for Pangolier at each tick.
		-- The effect itself is coded internally to Heartpiercer base debuff, however we add a fake debuff to inform the target.
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_5") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_heartpiercer_talent_debuff", {})
		end

		--Talent #6: Victim will have decreased tenacity during Heartpiercer.
		-- The effect itself is coded internally to Heartpiercer base debuff, however we add a fake debuff to inform the target.
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_6") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_heartpiercer_talent_debuff_2", {})
		end
	end

	if self.talent_interval == 0 then self.talent_interval = 0.1 end

	--start thinking
	self:StartIntervalThink(self.talent_interval)
end

function modifier_imba_heartpiercer_debuff:OnIntervalThink()
	if IsServer() then
		--Talent #5: Heartpiercer deals damage over time and applies on-hit effects at each tick (except Heartpiercer)
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_5") then
			local damage_per_tick = self.damage_per_second * self.talent_interval

			local damageTable = {victim = self:GetParent(),
				damage = damage_per_tick,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker = self:GetCaster(),
				ability = self:GetAbility()
			}

			ApplyDamage(damageTable)

			--Disallow Heartpiercer from proccing
			self:GetCaster().allow_heartpiercer = false

			--Apply on-hit effects
			self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, true, true)

			--Allow Heartpiercer again
			self:GetCaster().allow_heartpiercer = true
		end
	end
end

function modifier_imba_heartpiercer_debuff:OnRemoved()
	if IsServer() then
		--Remove Talent #5 modifier
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_5") then
			self:GetParent():RemoveModifierByName("modifier_imba_heartpiercer_talent_debuff")
		end

		--Remove Talent #6 modifier
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_6") then
			self:GetParent():RemoveModifierByName("modifier_imba_heartpiercer_talent_debuff_2")
		end
	end
end

function modifier_imba_heartpiercer_debuff:CheckState()
	local state = {[MODIFIER_STATE_PASSIVES_DISABLED] = true} --break

	return state
end

function modifier_imba_heartpiercer_debuff:DeclareFunctions()
	local declfuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return declfuncs
end

function modifier_imba_heartpiercer_debuff:GetModifierStatusResistanceStacking()
	--Talent #6: Heartpiercer decrease the parent tenacity
	if self:GetCaster():HasTalent("special_bonus_imba_pangolier_6") then
		return self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_6") * (-1)
	end

	return 0
end

function modifier_imba_heartpiercer_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow_pct
end

function modifier_imba_heartpiercer_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_imba_heartpiercer_debuff:IsHidden() return false end
function modifier_imba_heartpiercer_debuff:IsPurgable() return true end
function modifier_imba_heartpiercer_debuff:IsPermanent() return false end
function modifier_imba_heartpiercer_debuff:IsDebuff() return true end

--Talent #5 fake modifier: It's just visual for the victim
modifier_imba_heartpiercer_talent_debuff = modifier_imba_heartpiercer_talent_debuff or class({})

function modifier_imba_heartpiercer_talent_debuff:IsHidden() return false end
function modifier_imba_heartpiercer_talent_debuff:IsPurgable() return true end
function modifier_imba_heartpiercer_talent_debuff:IsPermanent() return false end
function modifier_imba_heartpiercer_talent_debuff:IsDebuff() return true end

--Talent #6 fake modifier: It's just visual for the victim
modifier_imba_heartpiercer_talent_debuff_2 = modifier_imba_heartpiercer_talent_debuff_2 or class({})

function modifier_imba_heartpiercer_talent_debuff_2:IsHidden() return false end
function modifier_imba_heartpiercer_talent_debuff_2:IsPurgable() return true end
function modifier_imba_heartpiercer_talent_debuff_2:IsPermanent() return false end
function modifier_imba_heartpiercer_talent_debuff_2:IsDebuff() return true end




------------------------------------
-----    ROLLING THUNDER       -----
------------------------------------
imba_pangolier_gyroshell = imba_pangolier_gyroshell or class({})
--LinkLuaModifier("modifier_imba_gyroshell_roll", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) 				------|
--LinkLuaModifier("modifier_imba_gyroshell_ricochet", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)			------|  IMBA MODIFIERS (not used atm)
--LinkLuaModifier("modifier_imba_gyroshell_stun", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)				------|
--LinkLuaModifier("modifier_imba_pangolier_gyroshell_bounce", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE)	------|
LinkLuaModifier("modifier_imba_gyroshell_impact_check", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) -- extend Rolling Thunder on each impact and implement #7 Talent
LinkLuaModifier("modifier_imba_gyroshell_linger", "components/abilities/heroes/hero_pangolier.lua", LUA_MODIFIER_MOTION_NONE) --Talent #4: Extra spell immunity

function imba_pangolier_gyroshell:GetAbilityTextureName()
	return "pangolier_gyroshell"
end

function imba_pangolier_gyroshell:IsHiddenWhenStolen() return false end
function imba_pangolier_gyroshell:IsStealable() return true end
function imba_pangolier_gyroshell:IsNetherWardStealable() return false end

function imba_pangolier_gyroshell:GetManaCost(level)
	local manacost = self.BaseClass.GetManaCost(self, level)

	return manacost
end

function imba_pangolier_gyroshell:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	return cast_point
end

function imba_pangolier_gyroshell:OnAbilityPhaseStart()
	local sound_cast = "Hero_Pangolier.Gyroshell.Cast"
	local cast_particle = "particles/units/heroes/hero_pangolier/pangolier_gyroshell_cast.vpcf"
	local caster = self:GetCaster()

	--Play ability cast sound
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), sound_cast, caster)

	--Play the effect and animation
	self.cast_effect = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.cast_effect, 0, caster:GetAbsOrigin()) -- 0: Spotlight position,
	ParticleManager:SetParticleControl(self.cast_effect, 3, caster:GetAbsOrigin()) --3: shell and sprint effect position,
	ParticleManager:SetParticleControl(self.cast_effect, 5, caster:GetAbsOrigin()) --5: roses landing point

	return true
end

function imba_pangolier_gyroshell:OnAbilityPhaseInterrupted()

	--Destroy cast particle
	ParticleManager:DestroyParticle(self.cast_effect, true)
	ParticleManager:ReleaseParticleIndex(self.cast_effect)
end

function imba_pangolier_gyroshell:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local loop_sound = "Hero_Pangolier.Gyroshell.Loop"
	local roll_modifier = "modifier_pangolier_gyroshell" --Vanilla
	--local roll_modifier = "modifier_imba_gyroshell_roll" --Imba

	-- Ability specials
	local tick_interval = ability:GetSpecialValueFor("tick_interval")
	local forward_move_speed = ability:GetSpecialValueFor("forward_move_speed")
	local turn_rate_boosted = ability:GetSpecialValueFor("turn_rate_boosted")
	local turn_rate = ability:GetSpecialValueFor("turn_rate")
	local radius = ability:GetSpecialValueFor("radius")
	local hit_radius = ability:GetSpecialValueFor("hit_radius")
	local bounce_duration = ability:GetSpecialValueFor("bounce_duration")
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	local knockback_radius = ability:GetSpecialValueFor("knockback_radius")
	local ability_duration = ability:GetSpecialValueFor("duration")
	local jump_recover_time = ability:GetSpecialValueFor("jump_recover_time")


	-- Play animation
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)



	--Stop the cast effect and animation
	ParticleManager:DestroyParticle(self.cast_effect, false)
	ParticleManager:ReleaseParticleIndex(self.cast_effect)

	--Apply a basic purge
	caster:Purge(false, true, false, false, false)

	--[[ Prevent Pangolier from blinking while rolling
	local forbidden_items = {
		"item_imba_blink",
		"item_imba_blink_boots"
	}

	for i = 0, 5 do
		local current_item = caster:GetItemInSlot(i)
		local should_mute = false

		-- If this item is forbidden, do not refresh it
		for _,forbidden_item in pairs(forbidden_items) do
			if current_item and current_item:GetName() == forbidden_item then
				should_mute = true
			end
		end

		-- Make item inactive
		if current_item and should_mute then
			current_item:SetActivated(false)
		end
	end]]

	--Starts rolling (Vanilla modifier for now)
	caster:AddNewModifier(caster, ability, roll_modifier, {duration = ability_duration})

	--starts checking for hero impacts
	caster:AddNewModifier(caster, ability, "modifier_imba_gyroshell_impact_check", {duration = ability_duration})


	--Play Loop sound
	EmitSoundOn(loop_sound, caster)

	--Replay loop sound if pango didn't finish rolling
	caster:SetContextThink("Loop_sound_replay", function ()

			if caster:HasModifier("modifier_pangolier_gyroshell") then
				StopSoundOn(loop_sound, caster)
				EmitSoundOn(loop_sound, caster)

				return 8.6
			else
				return nil
			end
	end, 8.6)


end


-- Impact checker, will extend Rolling Thunder duration on each hero hit will also hadle the targets and damage for Talent #7
modifier_imba_gyroshell_impact_check = modifier_imba_gyroshell_impact_check or class({})

function modifier_imba_gyroshell_impact_check:IsHidden() return true end
function modifier_imba_gyroshell_impact_check:IsPurgable() return false end
function modifier_imba_gyroshell_impact_check:IsPermanent() return false end
function modifier_imba_gyroshell_impact_check:IsDebuff() return false end

function modifier_imba_gyroshell_impact_check:OnCreated()
	if IsServer() then
		--Ability Properties
		self.gyroshell = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell")
		self.targets = self.targets or {}


		--Ability Specials
		self.duration_extend = self:GetAbility():GetSpecialValueFor("duration_extend")
		self.hit_radius = self:GetAbility():GetSpecialValueFor("hit_radius")
		self.talent_duration = self:GetCaster():FindTalentValue("special_bonus_imba_pangolier_4")

		-- Increase think time so the talent damage hopefully doesn't stack in one instance
		self:StartIntervalThink(0.05)
	end
end

function modifier_imba_gyroshell_impact_check:OnIntervalThink()
	if IsServer() then

		--If pangolier stopped rolling, remove this modifier
		if not self:GetCaster():HasModifier("modifier_pangolier_gyroshell") then
			self:Destroy()
		end

		local enemies_hit = 0

		-- Find all enemies in AoE
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
			self:GetCaster():GetAbsOrigin(),
			nil,
			self.hit_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)



		-- Check how many targets are valid (not impacted recently)
		for _,enemy in pairs(enemies) do
			if enemy:IsRealHero() and not enemy:IsMagicImmune() then

				--Is he affected by a previous impact? if so, ignore it
				if not enemy:HasModifier("modifier_pangolier_gyroshell_timeout") then
					enemies_hit = enemies_hit + 1
					--Talent #7: Double damage taken by single targets on subsequent impacts
					if self:GetCaster():HasTalent("special_bonus_imba_pangolier_7") then

						local found = false

						for k,v in pairs(self.targets) do
							if v == enemy then
								found = true
							end
						end

						if found then --was this target hit already?
							--Check how many times this target was damaged already
							local times_hit = enemy.hit_times
							--print(times_hit)
							local extra_damage = self:GetAbility():GetSpecialValueFor("damage")

							--Multiplies the damage by 2 for each previous impact
							if times_hit > 1 then
								times_hit = times_hit - 1
								for i=1,times_hit do
									extra_damage = extra_damage * 2
								end
							end

							--print(extra_damage)

							local damageTable = {victim = enemy,
								damage = extra_damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NONE,
								attacker = self:GetCaster(),
								ability = self:GetAbility()
							}



							print(ApplyDamage(damageTable))

							enemy.hit_times = enemy.hit_times + 1 --increase hit count

						else --New target, add him to the table and set hit_time to 1
							--print("new target")
							enemy.hit_times = 1
							table.insert(self.targets, enemy)

						end
					end
				end

			end
		end

		--Extend Rolling Thunder if a valid hero was hit
		if enemies_hit > 0 then
			local time_remaining = self.gyroshell:GetRemainingTime()
			local new_duration = time_remaining + enemies_hit * self.duration_extend

			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell", {duration = new_duration})
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyroshell_impact_check", {duration = new_duration})
		end
	end
end

function modifier_imba_gyroshell_impact_check:OnRemoved()
	if IsServer() then

		--[[renable blink on Pangolier
		for i = 0, 5 do
			local current_item = self:GetCaster():GetItemInSlot(i)

			if current_item then
				current_item:SetActivated(true)
			end
		end]]

		--Talent #4: Extra duration on spell immunity after Rolling Thunder end
		if self:GetCaster():HasTalent("special_bonus_imba_pangolier_4") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_gyroshell_linger", {duration = self.talent_duration})
		end
	end
end


--Talent #4 modifier: spell immunity from Rolling Thunder linger after ending the skill
modifier_imba_gyroshell_linger = modifier_imba_gyroshell_linger or class({})

function modifier_imba_gyroshell_linger:IsHidden() return false end
function modifier_imba_gyroshell_linger:IsDebuff() return false end
function modifier_imba_gyroshell_linger:IsPurgable() return false end

function modifier_imba_gyroshell_linger:GetEffectName()
	return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_imba_gyroshell_linger:CheckState()
	local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}

	return state
end







--[[ Rolling Thunder IMBA modifier (INCOMPLETE)
modifier_imba_gyroshell_roll = modifier_imba_gyroshell_roll or class({})

function modifier_imba_gyroshell_roll:OnCreated()
	-- Ability properties
	self.stun_modifier = "modifier_imba_gyroshell_stun"
	self.collision_modifier = "modifier_imba_gyroshell_ricochet"
	self.shield_crash = "modifier_imba_shield_crash_jump"
	self.end_sound = "Hero_Pangolier.Gyroshell.Stop"
	self.sprinting_effect = "particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf"

	-- Ability specials
	self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
	self.forward_move_speed = self:GetAbility():GetSpecialValueFor("forward_move_speed")
	self.turn_rate_boosted = self:GetAbility():GetSpecialValueFor("turn_rate_boosted")
	self.boost_duration = self:GetAbility():GetSpecialValueFor("turn_rate_boost_duration")
	self.turn_rate = self:GetAbility():GetSpecialValueFor("turn_rate")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.hit_radius = self:GetAbility():GetSpecialValueFor("hit_radius")
	self.bounce_duration = self:GetAbility():GetSpecialValueFor("bounce_duration")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self.knockback_radius = self:GetAbility():GetSpecialValueFor("knockback_radius")
	self.jump_recover_time = self:GetAbility():GetSpecialValueFor("jump_recover_time")
	self.pause_duration = self:GetAbility():GetSpecialValueFor("pause_duration")

	if IsServer() then

		--play initial roll gesture
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

		--Add particles
		self.sprint = ParticleManager:CreateParticle(self.sprinting_effect, PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(self.sprint, 0, self:GetCaster():GetAbsOrigin()) --origin

		self:AddParticle(self.sprint, false, false, -1, true, false)


		--declaring variables
		self.initial_direction = self:GetCaster():GetForwardVector() --will be needed to stop turning after pangolier turn 180°
		self.issued_order = false --is pangolier turning?
		self.boosted_turn = true --is pangolier turning faster? (on start, collision, jump)
		self.boosted_turn_time = 0 --will count how many ticks have been passed with boosted turn rate
		self:GetModifierTurnRate_Percentage() --start with boosted turn rate


		--start modifier interval thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_gyroshell_roll:IsHidden() return true end
function modifier_imba_gyroshell_roll:IsPurgable() return false end
function modifier_imba_gyroshell_roll:IsDebuff() return false end
function modifier_imba_gyroshell_roll:IgnoreTenacity() return true end
function modifier_imba_gyroshell_roll:IsMotionController() return true end
function modifier_imba_gyroshell_roll:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM end


function modifier_imba_gyroshell_roll:OnIntervalThink()

	--Interrupt if Pangolier has been stunned, rooted or taunted
	if self:GetCaster():IsStunned() or self:GetCaster():IsRooted() or self:GetCaster():GetForceAttackTarget() then

		 return self:Destroy()
		
	end

	--center particles on Pangolier
	ParticleManager:SetParticleControl(self.sprint, 0, self:GetCaster():GetAbsOrigin())

	--check what the turn rate should be
	if self.boosted_turn then
		--return to normal turn rate if boost duration expired
		if self.boosted_turn_time == self.boost_duration then
			self.boosted_turn = false
			self:GetModifierTurnRate_Percentage()
		end
		self.boosted_turn_time = self.boosted_turn_time + self.tick_interval
	end

	--check if we have to stop turning: stop the order once pangolier has turned 180° from the order launch
	if (self:GetCaster():GetForwardVector() + self.initial_direction) == Vector(0,0,0) then
		self:GetCaster():Interrupt() --stop turning
		self.issued_order = false

	end

	--if no orders are issued, Pangolier will move in a straight line
	if not self.issued_order then
		self:GetCaster():MoveToPosition(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 100)
	end

	--destroys nearby trees
	GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self.radius, false)
	

	-- Check Motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end


	-- Horizontal motion, don't move if Pangolier has just bounced
	if not self:GetCaster():HasModifier(self.collision_modifier) then
		self:HorizontalMotion(self:GetParent(), self.tick_interval)
	end


end

function modifier_imba_gyroshell_roll:HorizontalMotion(me, dt)
	if IsServer() then

			-- Go forward, check if Pangolier is going to collide with impassable terrain
			local expected_location = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self.forward_move_speed * dt
			local isTraversable = GridNav:IsTraversable(expected_location)
			

			if self:GetCaster():HasModifier("modifier_imba_shield_crash_jump") or isTraversable then --can Pangolier proceed?
				
				self:GetCaster():SetAbsOrigin(expected_location)
			else --Pangolier collide, reverse his direction and pause him slitghly
				
				self:GetCaster():SetForwardVector(self:GetCaster():GetForwardVector() * (-1))
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), self.collision_modifier, {duration = self.pause_duration})
			end

	end 
end


function modifier_imba_gyroshell_roll:OnRemoved()    
	if IsServer() then
		self:GetCaster():SetUnitOnClearGround()
		self:GetCaster():StopSound(self.loop_sound)
		EmitSoundOn(self.end_sound, self:GetCaster())
	end

end

function modifier_imba_gyroshell_roll:OnDestroy()

	if IsServer() then
		--release particle index
		ParticleManager:DestroyParticle(self.sprint, false)
		ParticleManager:ReleaseParticleIndex(self.sprint)
	end

end

function modifier_imba_gyroshell_roll:DeclareFunctions()
	local declfuncs = {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
						MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
						MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
						MODIFIER_PROPERTY_MODEL_CHANGE,
						MODIFIER_EVENT_ON_ORDER}

	return declfuncs
end 

function modifier_imba_gyroshell_roll:OnOrder(keys)
	if IsServer() then
		--filter orders
		if keys.unit == self:GetCaster() then
		local order_type = keys.order_type	

		-- On any movement order, track the initial direction of Pangolier
		if order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET 
		or order_type == DOTA_UNIT_ORDER_ATTACK_MOVE or order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
			self.initial_direction = self:GetCaster():GetForwardVector()
			self.issued_order = true
		end
	end

	end
end

--Fixed movement speed. Motion controller will handle the movement
function modifier_imba_gyroshell_roll:GetModifierMoveSpeed_Absolute()
	return 1 
end

function modifier_imba_gyroshell_roll:GetModifierTurnRate_Percentage()

	if IsServer() then

		local base_tr = 1.0 --HARDCODED because fucking volvo can't provide a simple function -.-

		--calculating turn rates
		--converting from degrees/second to radians/second
		local tr_per_sec_in_radians = (self.turn_rate * math.pi) / 180
		local boosted_tr_per_sec_in_radians = (self.turn_rate_boosted * math.pi) / 180 

		--converting from radians/second to radians/0.03s (actual turn rate)
		local tr_in_radians = tr_per_sec_in_radians * 0.03
		local boosted_tr_in_radians = boosted_tr_per_sec_in_radians * 0.03

		--calculating percentage needed to achieve the desired turn rates
		local tr_percentage = 100 - ((100 * tr_in_radians) / base_tr )
		local boosted_tr_percentage = 100 - ((100 * (tr_in_radians + boosted_tr_in_radians)) / base_tr)


		if self.boosted_turn then
			return boosted_tr_percentage * (-1)
		end
		return tr_percentage * (-1)
	end
end

function modifier_imba_gyroshell_roll:GetModifierModelChange()
	return "models/heroes/pangolier/pangolier_gyroshell.vmdl"
end

function modifier_imba_gyroshell_roll:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

--Collision modifier: will disable Rolling Thunder motion controllers while it's active
modifier_imba_gyroshell_ricochet = modifier_imba_gyroshell_ricochet or class({})

function modifier_imba_gyroshell_ricochet:OnCreated()

	--Ability properties
	self.gyroshell = "modifier_imba_gyroshell_roll"
	self.bounce_sound = "Hero_Pangolier.Gyroshell.Carom"

	--play the bounce sound
	EmitSoundOn(self.bounce_sound, self:GetCaster())
	--play the bounce animation
	self:GetCaster():StartGesture(ACT_DOTA_FLAIL)
end

function modifier_imba_gyroshell_ricochet:OnDestroy()

	--boost rolling thunder turn rate
	local gyroshell_handler = self:GetCaster():FindModifierByName(self.gyroshell)
	if gyroshell_handler then
		gyroshell_handler.boosted_turn = true
		gyroshell_handler.boosted_turn_time = 0
		gyroshell_handler:GetModifierTurnRate_Percentage()
	end
end


function modifier_imba_gyroshell_ricochet:IsHidden() return true end
function modifier_imba_gyroshell_ricochet:IsPurgable() return true end
function modifier_imba_gyroshell_ricochet:IsDebuff() return false end
]]
