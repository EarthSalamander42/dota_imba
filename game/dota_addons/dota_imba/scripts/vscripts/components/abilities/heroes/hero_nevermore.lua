-- Author: Shush
-- Date: 22/04/2017

-- utils
-- Returns true if a hero has red hair
local function IsGinger(unit)

	local ginger_hero_names = {
		"npc_dota_hero_enchantress",
		"npc_dota_hero_lina",
		"npc_dota_hero_windrunner"
	}

	local unit_name = unit:GetName()
	for _,name in pairs(ginger_hero_names) do
		if name == unit_name then
			return true
		end
	end
	
	return false
end

------------------------------------
--     SHADOW RAZE (CLOSE)        --
------------------------------------
imba_nevermore_shadowraze_close = imba_nevermore_shadowraze_close or class({})
LinkLuaModifier("modifier_shadow_raze_combo", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadow_raze_prevention", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadow_raze_pool", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_shadowraze_debuff", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_shadowraze_close:GetAbilityTextureName()
   return "nevermore_shadowraze1"
end

function imba_nevermore_shadowraze_close:IsHiddenWhenStolen()
	return false
end

function imba_nevermore_shadowraze_close:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)

	-- Talent: Shadowraze mana cost reduction (REMOVED)
	--manacost = manacost - caster:FindTalentValue("special_bonus_imba_nevermore_1")

	return manacost
end

function imba_nevermore_shadowraze_close:GetCooldown(level)
	local caster = self:GetCaster()
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- If the caster is in Soul Harvest, there is no cooldown for razes
	if caster:HasModifier(modifier_harvest) then
		return 0
	end

	-- Otherwise, return normal cooldown
	local cooldown = self.BaseClass.GetCooldown(self, level)

	-- Talent: Shadowraze cooldown reduction (REMOVED)
	--cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_nevermore_3")

	return cooldown
end


function imba_nevermore_shadowraze_close:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end

function imba_nevermore_shadowraze_close:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)
	local caster = self:GetCaster()
	--Talent #8: Cast point is halved when in soul frenzy
	if caster:HasTalent("special_bonus_imba_nevermore_8") and caster:HasModifier("modifier_imba_reqiuem_harvest") and caster:IsAlive() then
		cast_point = cast_point / 2
	end
	return cast_point
end

function imba_nevermore_shadowraze_close:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_07", "nevermore_nev_ability_shadow_18", "nevermore_nev_ability_shadow_21"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("raze_radius")
	local raze_distance = ability:GetSpecialValueFor("raze_distance")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Play cast sound
	EmitSoundOn(sound_raze, caster)

	-- Calculate the center point of the raze
	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	local raze_hit_hero = CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

	--if caster is in Soul Harvest and the raze didn't hit any hero, remove the modifier
	if caster:HasModifier(modifier_harvest) and not raze_hit_hero then
		caster:RemoveModifierByName(modifier_harvest)
	end

end


------------------------------------
--     SHADOW RAZE (MEDIUM)       --
------------------------------------
imba_nevermore_shadowraze_medium = imba_nevermore_shadowraze_medium or class({})

function imba_nevermore_shadowraze_medium:GetAbilityTextureName()
   return "nevermore_shadowraze2"
end

function imba_nevermore_shadowraze_medium:IsHiddenWhenStolen()
	return false
end

function imba_nevermore_shadowraze_medium:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)

	-- Talent: Shadowraze mana cost reduction (REMOVED)
   -- manacost = manacost - caster:FindTalentValue("special_bonus_imba_nevermore_1")

	return manacost
end

function imba_nevermore_shadowraze_medium:GetCooldown(level)
	local caster = self:GetCaster()
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- If the caster is in Soul Harvest, there is no cooldown for razes
	if caster:HasModifier(modifier_harvest) then
		return 0
	end

	-- Otherwise, return normal cooldown
	local cooldown = self.BaseClass.GetCooldown(self, level)

	-- Talent: Shadowraze cooldown reduction (REMOVED)
  --  cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_nevermore_3")

	return cooldown
end

function imba_nevermore_shadowraze_medium:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end

function imba_nevermore_shadowraze_medium:GetCastPoint()
	local caster = self:GetCaster()
	local cast_point = self.BaseClass.GetCastPoint(self)
	--Talent #8: Cast point is halved when in soul frenzy
	if caster:HasTalent("special_bonus_imba_nevermore_8") and caster:HasModifier("modifier_imba_reqiuem_harvest") then
		cast_point = cast_point / 2
	end
	return cast_point
end

function imba_nevermore_shadowraze_medium:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_08", "nevermore_nev_ability_shadow_20", "nevermore_nev_ability_shadow_22"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	local modifier_combo = "modifier_shadow_raze_combo"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("raze_radius")
	local raze_distance = ability:GetSpecialValueFor("raze_distance")
	local additional_raze_count = ability:GetSpecialValueFor("additional_raze_count")
	local raze_angle = ability:GetSpecialValueFor("raze_angle")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Play cast sound
	EmitSoundOn(sound_raze, caster)

	-- Start a table of enemies hit
	self.enemies_hit = {}

	-- Calculate the center point of the primary raze
	local main_raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	local raze_hit_hero = CastShadowRazeOnPoint(caster, ability, main_raze_point, raze_radius)


	-- Additional razes, if feasible
	local extra_razes_did_hit = false -- check if at least one extra raze hit an enemy hero

	if additional_raze_count > 0 then
		local last_left_raze_point = main_raze_point
		local last_right_raze_point = main_raze_point

		for i = 2, additional_raze_count, 2 do
			local left_qangle = QAngle(0, raze_angle, 0)
			local right_qangle = QAngle(0, raze_angle * (-1), 0)

			last_left_raze_point = RotatePosition(caster:GetAbsOrigin(), left_qangle, last_left_raze_point)
			last_right_raze_point = RotatePosition(caster:GetAbsOrigin(), right_qangle, last_right_raze_point)

			local extra_hit_1 = CastShadowRazeOnPoint(caster, ability, last_left_raze_point, raze_radius)
			local extra_hit_2 = CastShadowRazeOnPoint(caster, ability, last_right_raze_point, raze_radius)
			if extra_hit_1 or extra_hit_2 then --did any of these pair of razes hit an enemy hero?
				extra_razes_did_hit = true
			end
		end
	end

	--if caster is in Soul Harvest and no razes hit an hero, remove the modifier
	if caster:HasModifier(modifier_harvest) and not raze_hit_hero and not extra_razes_did_hit then
		caster:RemoveModifierByName(modifier_harvest)
	end
end

------------------------------------
--       SHADOW RAZE (FAR)        --
------------------------------------
imba_nevermore_shadowraze_far = imba_nevermore_shadowraze_far or class({})

function imba_nevermore_shadowraze_far:GetAbilityTextureName()
   return "nevermore_shadowraze3"
end

function imba_nevermore_shadowraze_far:IsHiddenWhenStolen()
	return false
end

function imba_nevermore_shadowraze_far:GetManaCost(level)
	local caster = self:GetCaster()
	local manacost = self.BaseClass.GetManaCost(self, level)

	--Talent: Shadowraze mana cost reduction (REMOVED)
	--manacost = manacost - caster:FindTalentValue("special_bonus_imba_nevermore_1")

	return manacost
end

function imba_nevermore_shadowraze_far:GetCooldown(level)
	local caster = self:GetCaster()
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- If the caster is in Soul Harvest, there is no cooldown for razes
	if caster:HasModifier(modifier_harvest) then
		return 0
	end

	-- Otherwise, return normal cooldown
	local cooldown = self.BaseClass.GetCooldown(self,level)

	--Talent: Shadowraze cooldown reduction (REMOVED)
   -- cooldown = cooldown - caster:FindTalentValue("special_bonus_imba_nevermore_3")

	return cooldown
end

function imba_nevermore_shadowraze_far:GetCastPoint()
	local caster = self:GetCaster()
	local cast_point = self.BaseClass.GetCastPoint(self)
	--Talent #8: Cast point is halved when in soul frenzy
	if caster:HasTalent("special_bonus_imba_nevermore_8") and caster:HasModifier("modifier_imba_reqiuem_harvest") then
		cast_point = cast_point / 2
	end
	return cast_point
end

function imba_nevermore_shadowraze_far:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end

function imba_nevermore_shadowraze_far:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	local modifier_combo = "modifier_shadow_raze_combo"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- Ability specials
	local main_raze_radius = ability:GetSpecialValueFor("main_raze_radius")
	local main_raze_distance = ability:GetSpecialValueFor("main_raze_distance")
	local level_5_raze_radius = ability:GetSpecialValueFor("level_5_raze_radius")
	local level_5_raze_distance = ability:GetSpecialValueFor("level_5_raze_distance")
	local level_6_raze_radius = ability:GetSpecialValueFor("level_6_raze_radius")
	local level_6_raze_distance = ability:GetSpecialValueFor("level_6_raze_distance")
	local level_7_raze_radius = ability:GetSpecialValueFor("level_7_raze_radius")
	local level_7_raze_distance = ability:GetSpecialValueFor("level_7_raze_distance")

	-- Get the current ability level
	local level_of_ability = ability:GetLevel()

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Play cast sound
	EmitSoundOn(sound_raze, caster)

	-- Start a table of enemies hit
	self.enemies_hit = {}

	-- Calculate the center point of the primary raze
	local main_raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * main_raze_distance
	local raze_hit_hero = CastShadowRazeOnPoint(caster, ability, main_raze_point, main_raze_radius)

	-- Check if ability is level 5 or above

	local lvl_5_raze_hit_hero = false --check wether this raze hit an enemy hero

	--if level_of_ability >= 5 then
	if level_of_ability >= 2 then

		-- Create a second raze with its values
		local level_5_raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * level_5_raze_distance
		lvl_5_raze_hit_hero = CastShadowRazeOnPoint(caster, ability, level_5_raze_point, level_5_raze_radius)
	end

	-- Check if ability is level 6 or above

	local lvl_6_raze_hit_hero = false --check wether this raze hit an enemy hero

	--if level_of_ability >= 6 then
	if level_of_ability >= 3 then
	
		-- Create a third raze with its values, behind the caster
		local back_direction = (main_raze_point - caster:GetAbsOrigin()):Normalized()
		local level_6_raze_point = caster:GetAbsOrigin() + back_direction * level_6_raze_distance
		lvl_6_raze_hit_hero = CastShadowRazeOnPoint(caster, ability, level_6_raze_point, level_6_raze_radius)
	end

	-- Check if abiility is level 7

	local lvl_7_raze_hit_hero = false --check wether this raze hit an enemy hero

	--if level_of_ability == 7 then
	if level_of_ability == 4 then
	
		-- Create the last raze at the far end
		local level_7_raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * level_7_raze_distance
		local lvl_7_raze_hit_hero = CastShadowRazeOnPoint(caster, ability, level_7_raze_point, level_7_raze_radius)
	end

	--if caster is in Soul Harvest and no razes hit an hero, remove the modifier
	if caster:HasModifier(modifier_harvest) and not raze_hit_hero and not lvl_5_raze_hit_hero and not lvl_6_raze_hit_hero and not lvl_7_raze_hit_hero then
		caster:RemoveModifierByName(modifier_harvest)
	end

end


-------------------------
-- Shadowraze Handlers --
-------------------------

--Return a boolean if the caster has the Soul Harvest modifier: True if the raze hit an enemy hero, false otherwise. 
--Return nil if the caster doesn't have the modifier.
function CastShadowRazeOnPoint(caster, ability, point, radius)
	-- Ability properties
	local particle_raze = "particles/hero/nevermore/nevermore_shadowraze.vpcf"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"
	local requiem_debuff = "modifier_imba_reqiuem_debuff"
	local pool_modifier = "modifier_imba_shadow_raze_pool"
	local modifier_combo = "modifier_shadow_raze_combo"
	local modifier_prevention = "modifier_shadow_raze_prevention"
	local shadow_combo_duration = ability:GetSpecialValueFor("shadow_combo_duration")

	--Ability attributes
	local pool_duration = caster:FindTalentValue("special_bonus_imba_nevermore_1","duration")
	local pool_radius = caster:FindTalentValue("special_bonus_imba_nevermore_1","radius")

	-- Add particle effects. CP0 is location, CP1 is radius
	local particle_raze_fx = ParticleManager:CreateParticle(particle_raze, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_raze_fx, 0, point)
	ParticleManager:SetParticleControl(particle_raze_fx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_raze_fx)

	-- Find enemy units in radius
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
									  point,
									  nil,
									  radius,
									  DOTA_UNIT_TARGET_TEAM_ENEMY,
									  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									  DOTA_UNIT_TARGET_FLAG_NONE,
									  FIND_ANY_ORDER,
									  false)

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune() then

			-- Check if the table exists
			if ability.enemies_hit then

				-- Check if that enemy was already marked in the table, otherwise, mark it
				local enemy_marked = false
				for _,enemy_hit in pairs(ability.enemies_hit) do
					if enemy == enemy_hit then
						enemy_marked = true
					end
				end

				if not enemy_marked then
					table.insert(ability.enemies_hit, enemy)
				end

				-- If enemy was NOT marked yet, deal damage to it
				if not enemy_marked then
					ApplyShadowRazeDamage(caster, ability, enemy)
					--#6 Talent: Shadowraze refresh Requiem of Souls' debuff
					if caster:HasTalent("special_bonus_imba_nevermore_6") and enemy:HasModifier("modifier_imba_reqiuem_debuff") then
						local modifier_handler = enemy:FindModifierByName(requiem_debuff)
						if modifier_handler then
							local new_duration = modifier_handler.duration
							enemy:RemoveModifierByName(requiem_debuff)
							enemy:AddNewModifier(caster, modifier_handler.ability, requiem_debuff, {duration = new_duration})
						end
					end

				end

			else --If there was no table, just damage enemy
				ApplyShadowRazeDamage(caster, ability, enemy)
				--#6 Talent: Shadowraze refresh Requiem of Souls' debuff
					if caster:HasTalent("special_bonus_imba_nevermore_6") and enemy:HasModifier("modifier_imba_reqiuem_debuff") then
						local modifier_handler = enemy:FindModifierByName(requiem_debuff)
						if modifier_handler then
							local new_duration = modifier_handler.duration
							enemy:RemoveModifierByName(requiem_debuff)
							enemy:AddNewModifier(caster, modifier_handler.ability, requiem_debuff, {duration = new_duration})
						end
					end
			end
		end
	end

	--#1 Talent: apply a damaging pool on the area hit by the shadowraze
	if caster:HasTalent("special_bonus_imba_nevermore_1") then
		CreateModifierThinker(caster, ability, pool_modifier, {duration = pool_duration, radius = pool_radius}, point, caster:GetTeamNumber(), false)
	end

	if #enemies > 0 then
		-- Apply a shadow combo modifier to caster if it doesn't have it. Regardless, add a stack and refresh
		if not caster:HasModifier(modifier_combo) and not caster:HasModifier(modifier_prevention) then
			caster:AddNewModifier(caster, ability, modifier_combo, {duration = shadow_combo_duration})
		end

		local modifier_combo_handler = caster:FindModifierByName(modifier_combo)
		if modifier_combo_handler then
			modifier_combo_handler:IncrementStackCount()
			modifier_combo_handler:ForceRefresh()
		end
	
		-- Check if the raze has hit an enemy hero for Soul Frenzy
		if caster:HasModifier(modifier_harvest) then
			for _,enemy in pairs(enemies) do
				if enemy:IsRealHero() then	
					return true
				end
			end
		end
		return false
	end
end

function ApplyShadowRazeDamage(caster, ability, enemy)
	-- Ability properties
	local particle_soul = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"
	local modifier_souls = "modifier_imba_necromastery_souls"
	local modifier_dark_lord = "modifier_imba_dark_lord_debuff"
	local modifier_debuff = "modifier_imba_shadowraze_debuff"

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local damage_per_soul = ability:GetSpecialValueFor("damage_per_soul")
	local souls_per_raze = ability:GetSpecialValueFor("souls_per_raze")
	local soul_projectile_speed = ability:GetSpecialValueFor("soul_projectile_speed")
	local stack_bonus_damage = ability:GetSpecialValueFor("stack_bonus_damage")
	local duration = ability:GetSpecialValueFor("duration")
	
	-- Add stacking Shadowraze damage
	local debuff_boost = 0
		
	if enemy:HasModifier(modifier_debuff) then
		debuff_boost	= stack_bonus_damage * enemy:FindModifierByName(modifier_debuff):GetStackCount()
		damage 			= damage + debuff_boost
	end
	
	-- If the caster has Necromastery souls, increase the damage of Shadowraze and steal a soul    
	if caster:HasModifier(modifier_souls) then
		local stacks = caster:GetModifierStackCount(modifier_souls, caster)

		-- Talent: Necromastery soul grant additional damage (REMOVED)
	   -- damage_per_soul = damage_per_soul + caster:FindTalentValue("special_bonus_imba_nevermore_8")
	   
		-- Adjust damage
		damage = damage + (stacks * damage_per_soul) + debuff_boost

		-- Add a Necromastery stack if it was a hero
		if enemy:IsRealHero() then
			AddNecromasterySouls(caster, souls_per_raze)
		end

		-- If caster is not broken, launch a soul projectile to the caster
		if not caster:PassivesDisabled() then
			local soul_projectile = {Target = caster,
									 Source = enemy,
									 Ability = ability,
									 EffectName = particle_soul,
									 bDodgeable = false,
									 bProvidesVision = false,
									 iMoveSpeed = soul_projectile_speed,
									 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
									 }


			ProjectileManager:CreateTrackingProjectile(soul_projectile)
		end
	end

	-- If the enemy is affected by Presence of the Dark Lord's debuff, add a stack to it
	if enemy:HasModifier(modifier_dark_lord) then
		local modifier_dark_lord_handler = enemy:FindModifierByName(modifier_dark_lord)
		if modifier_dark_lord_handler then
			modifier_dark_lord_handler:IncrementStackCount()
		end
	end

	-- Deal damage
	local damageTable = {victim = enemy,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
						}

	local actualy_damage = ApplyDamage(damageTable)    
	
	-- Apply a debuff stack that causes shadowrazes to do more damage
	if not enemy:HasModifier(modifier_debuff) then
		enemy:AddNewModifier(caster, ability, modifier_debuff, {duration = duration})
	end
	
	local modifier_debuff_counter = enemy:FindModifierByName(modifier_debuff)
	if modifier_debuff_counter then
		modifier_debuff_counter:IncrementStackCount()
		modifier_debuff_counter:ForceRefresh()
	end
end

function UpgradeShadowRazes(caster, ability)
	local raze_close = "imba_nevermore_shadowraze_close"
	local raze_medium = "imba_nevermore_shadowraze_medium"
	local raze_far = "imba_nevermore_shadowraze_far"

	-- Get handles
	local raze_close_handler
	local raze_medium_handler
	local raze_far_handler

	if caster:HasAbility(raze_close) then
		raze_close_handler = caster:FindAbilityByName(raze_close)
	end

	if caster:HasAbility(raze_medium) then
		raze_medium_handler = caster:FindAbilityByName(raze_medium)
	end

	if caster:HasAbility(raze_far) then
		raze_far_handler = caster:FindAbilityByName(raze_far)
	end

	-- Get the level to compare
	local leveled_ability_level = ability:GetLevel()

	if raze_close_handler and raze_close_handler:GetLevel() < leveled_ability_level then
		raze_close_handler:SetLevel(leveled_ability_level)
	end

	if raze_medium_handler and raze_medium_handler:GetLevel() < leveled_ability_level then
		raze_medium_handler:SetLevel(leveled_ability_level)
	end

	if raze_far_handler and raze_far_handler:GetLevel() < leveled_ability_level then
		raze_far_handler:SetLevel(leveled_ability_level)
	end
end



-- Shadow Combo modifier
modifier_shadow_raze_combo = modifier_shadow_raze_combo or class({})

function modifier_shadow_raze_combo:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.razes = {}
		self.razes[1] = "imba_nevermore_shadowraze_close"
		self.razes[2] = "imba_nevermore_shadowraze_medium"
		self.razes[3] = "imba_nevermore_shadowraze_far"
		self.modifier_prevention = "modifier_shadow_raze_prevention"

		-- Ability specials
		self.combo_prevention_duration = self.ability:GetSpecialValueFor("combo_prevention_duration")
		self.combo_threshold = self.ability:GetSpecialValueFor("combo_threshold")
	end
end

function modifier_shadow_raze_combo:IsHidden() return false end
function modifier_shadow_raze_combo:IsPurgable() return false end

function modifier_shadow_raze_combo:OnStackCountChanged()
	if IsServer() then
		-- Get stack count
		local stacks = self:GetStackCount()

		-- If the caster has the prevention modifier, do nothing
		if self.caster:HasModifier(self.modifier_prevention) then
			return nil
		end

		-- If the stack count below the threshold, do nothing
		if stacks < self.combo_threshold then
			return nil
		end

		-- Wait a frame
		Timers:CreateTimer(FrameTime(), function()
			-- Otherwise, find all caster's razes and refresh their cooldowns
			for i = 1, #self.razes do
				if self.caster:HasAbility(self.razes[i]) then
					self.raze_close_handler = self.caster:FindAbilityByName(self.razes[i])
					if self.raze_close_handler then
						self.raze_close_handler:EndCooldown()
					end
				end
			end
		end)

		-- Give the caster the prevention modifier
		self.caster:AddNewModifier(self.caster, self.ability, self.modifier_prevention, {duration = self.combo_prevention_duration})
		self:Destroy()
	end
end


-- Shadow Combo prevention modifier
modifier_shadow_raze_prevention = modifier_shadow_raze_prevention or class({})

function modifier_shadow_raze_prevention:IsHidden() return false end
function modifier_shadow_raze_prevention:IsPurgable() return false end
function modifier_shadow_raze_prevention:IsDebuff() return true end


-- Shadow pool modifier (copied from Lina, please feel free to improve it as needed)
modifier_imba_shadow_raze_pool = modifier_imba_shadow_raze_pool or class({})

function modifier_imba_shadow_raze_pool:OnCreated(kv)
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_effect = "particles/hero/nevermore/nevermore_shadowraze_talent_pool.vpcf"

		-- Talent specials
		self.radius = kv.radius
		self.flat_damage = self.caster:FindTalentValue("special_bonus_imba_nevermore_1", "flat_dmg_per_sec")
		self.percent_damage = self.caster:FindTalentValue("special_bonus_imba_nevermore_1", "pc_dmg_per_sec")
		self.tick_interval = self.caster:FindTalentValue("special_bonus_imba_nevermore_1", "tick_interval")

		-- Play shadow pool particle effect, assign to modifier
		local particle_pool = ParticleManager:CreateParticle(self.particle_effect, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_pool, 2, (self.parent:GetAbsOrigin()+ Vector(0,0,10)))

		self:AddParticle(particle_pool, false, false, -1, false, false)

		-- Calculate damage per tick
		self.percent_damage_per_tick = self.percent_damage * self.tick_interval
		self.flat_damage_per_tick = self.flat_damage * self.tick_interval

		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_shadow_raze_pool:OnIntervalThink()
	if IsServer() then
		-- Find enemies in AoE
		local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(),
										  self.parent:GetAbsOrigin(),
										  nil,
										  self.radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
										  DOTA_UNIT_TARGET_FLAG_NONE,
										  FIND_ANY_ORDER,
										  false)

		-- Deal damage per tick to each enemy
		for _,enemy in pairs(enemies) do
			damage_table = ({victim = enemy,
						 attacker = self.caster,
						 ability = self.ability,
						 damage = ((enemy:GetMaxHealth() / 100) * self.percent_damage_per_tick) + self.flat_damage_per_tick,
						 damage_type = DAMAGE_TYPE_MAGICAL})

			ApplyDamage(damage_table)
		end
	end
end

-- Modifier to track increasing raze damage
modifier_imba_shadowraze_debuff = class ({})

function modifier_imba_shadowraze_debuff:IsDebuff() return true end

------------------------------------
--           NECROMASTERY         --
------------------------------------
imba_nevermore_necromastery = imba_nevermore_necromastery or class({})
LinkLuaModifier("modifier_imba_necromastery_souls", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_necromastery_talent_extra_cap", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_nevermore_2", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)

-- Required to change behaviour on client-side
modifier_special_bonus_imba_nevermore_2 = class ({})

function modifier_special_bonus_imba_nevermore_2:IsHidden() 		return true end
function modifier_special_bonus_imba_nevermore_2:IsPurgable() 		return false end
function modifier_special_bonus_imba_nevermore_2:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_nevermore_2:OnCreated()
	if not IsServer() then return end
	if self:GetParent():FindAbilityByName("imba_nevermore_necromastery") then
		self:GetParent():FindAbilityByName("imba_nevermore_necromastery"):GetBehavior()
	end
end

-- Should close out talent behavior change problems
function imba_nevermore_necromastery:OnOwnerSpawned()
	if not IsServer() then return end
	if self:GetCaster():HasAbility("special_bonus_imba_nevermore_2") and self:GetCaster():FindAbilityByName("special_bonus_imba_nevermore_2"):IsTrained() and not self:GetCaster():HasModifier("modifier_special_bonus_imba_nevermore_2") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_nevermore_2", {})
	end
end

---

function imba_nevermore_necromastery:GetAbilityTextureName()
   return "nevermore_necromastery"
end

function imba_nevermore_necromastery:GetIntrinsicModifierName()
	return "modifier_imba_necromastery_souls"
end

function imba_nevermore_necromastery:GetBehavior()
	--Talent #2: Necromastery can be activated to consume souls in order to heal. Will spare some souls if Nevermore heal to max before consuming all of them
	if self:GetCaster():HasTalent("special_bonus_imba_nevermore_2") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	end
	-- Default behavior, without talent #2
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function imba_nevermore_necromastery:IsHiddenWhenStolen()
	return true
end

function imba_nevermore_necromastery:OnUnStolen()
	local caster = self:GetCaster()
	local modifier_souls = "modifier_imba_necromastery_souls"

	if caster:HasModifier(modifier_souls) then
		caster:RemoveModifierByName(modifier_souls)
	end
end

function imba_nevermore_necromastery:OnUpgrade()
	local caster = self:GetCaster()
	local upgrade_response = "nevermore_nev_ability_mastery_01"

	-- Play upgrade response sound
	EmitSoundOn(upgrade_response, caster)
end

function imba_nevermore_necromastery:GetManaCost(level)
	return 0
end

function imba_nevermore_necromastery:GetCooldown(level)
	
	local cooldown = self:GetCaster():FindTalentValue("special_bonus_imba_nevermore_2", "cooldown")

	return cooldown
end


function imba_nevermore_necromastery:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local particle_one = "particles/hero/nevermore/nevermore_necromastery_heal_1.vpcf"
	local particle_two = "particles/hero/nevermore/nevermore_necromastery_heal_2.vpcf"
	local necromastery_heal_one = nil
	local necromastery_heal_two = nil
	local souls_modifier = "modifier_imba_necromastery_souls"

	-- Ability specials
	local heal_per_soul = caster:FindTalentValue("special_bonus_imba_nevermore_2", "heal_per_soul")

	if IsServer() then

		--calculate the number of souls to consume
		local max_health = caster:GetMaxHealth()
		local current_health = caster:GetHealth()
		local missing_health = max_health - current_health
		--max health: do nothing
		if missing_health <= 0 then
			return
		end

		--particle effects

		necromastery_heal_one = ParticleManager:CreateParticle(particle_one, PATTACH_WORLDORIGIN, nil)
		necromastery_heal_two = ParticleManager:CreateParticle(particle_two, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(necromastery_heal_one, 0, (caster:GetAbsOrigin() + Vector (0,0,-290)))
		ParticleManager:SetParticleControl(necromastery_heal_two, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(necromastery_heal_two, 1, (caster:GetAbsOrigin() + (caster:GetForwardVector():Normalized() * caster:GetBaseMoveSpeed()) + Vector (0,0,30)))
		ParticleManager:ReleaseParticleIndex(necromastery_heal_one)
		ParticleManager:ReleaseParticleIndex(necromastery_heal_two)

		local souls_needed = (missing_health / heal_per_soul) + 1
		local soul_stacks = 0

		--retrieve the current soul stacks on Nevermore
		if not caster:HasModifier(souls_modifier) then
			soul_stacks = 0
		else
			soul_stacks = caster:GetModifierStackCount(souls_modifier, caster)
		end

		--remove soul stacks and heal Nevermore
		if soul_stacks < souls_needed then
			--not enough souls to heal to max: remove them all and heal accordingly
			caster:SetHealth(current_health + (soul_stacks * heal_per_soul))
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, soul_stacks * heal_per_soul, nil)
			caster:SetModifierStackCount(souls_modifier, caster, 0)
		else
			--enough souls to heal to max. remove only the souls needed
			caster:SetHealth(max_health)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, caster, souls_needed * heal_per_soul, nil)
			caster:SetModifierStackCount(souls_modifier, caster, soul_stacks - souls_needed)
		end

	end

end



-- Necromastery souls modifier
modifier_imba_necromastery_souls = modifier_imba_necromastery_souls or class({})

function modifier_imba_necromastery_souls:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_soul_creep = "particles/units/heroes/hero_nevermore/nevermore_necro_souls.vpcf"
	self.particle_soul_hero = "particles/hero/nevermore/nevermore_soul_projectile.vpcf"
	self.requiem_ability = "imba_nevermore_requiem"
	self.extra_cap_modifier = "modifier_imba_necromastery_talent_extra_cap"

	-- Ability specials
	self.creep_kill_soul_count = self.ability:GetSpecialValueFor("creep_kill_soul_count")
	self.hero_kill_soul_count = self.ability:GetSpecialValueFor("hero_kill_soul_count")
	self.hero_attack_soul_count = self.ability:GetSpecialValueFor("hero_attack_soul_count")
	self.shadowraze_soul_count = self.ability:GetSpecialValueFor("shadowraze_soul_count")
	self.damage_per_soul = self.ability:GetSpecialValueFor("damage_per_soul")
	self.base_max_souls = self.ability:GetSpecialValueFor("max_souls")
	self.scepter_max_souls = self.ability:GetSpecialValueFor("scepter_max_souls")
	self.max_souls = self.base_max_souls
	self.total_max_souls = self.base_max_souls
	self.temporary_soul_duration = self.ability:GetSpecialValueFor("temporary_soul_duration")
	self.max_temporary_souls_pct = self.ability:GetSpecialValueFor("max_temporary_souls_pct")
	self.soul_projectile_speed = self.ability:GetSpecialValueFor("soul_projectile_speed")
	self.souls_lost_on_death_pct = self.ability:GetSpecialValueFor("souls_lost_on_death_pct")

	if IsServer() then

		-- If Necromastery is stolen, find the owner and get the stack count. Nothing can proc Necromastery when stolen
		if self.ability:IsStolen() then
			-- Find the owner
			local enemy_heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
												   self.caster:GetAbsOrigin(),
												   nil,
												   5000,
												   DOTA_UNIT_TARGET_TEAM_ENEMY,
												   DOTA_UNIT_TARGET_HERO,
												   DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
												   FIND_CLOSEST,
												   false)

			-- Cycle between heroes to see who has the modifier
			local modifier_souls = "modifier_imba_necromastery_souls"
			for _,enemy_hero in pairs(enemy_heroes) do
				if enemy_hero:HasModifier(modifier_souls) then
					local modifier_souls_handler = enemy_hero:FindModifierByName(modifier_souls)
					if modifier_souls_handler then
						local stacks = modifier_souls_handler:GetStackCount()
						self:SetStackCount(stacks)
						break
					end
				end
			end

			return nil
		end



		-- Decide how many temporary souls we can have at once
		self.max_souls_inc_temp = self.base_max_souls * (1 + (self.max_temporary_souls_pct * 0.01))

		-- If a table is not yet declared, assign it now
		if not self.soul_table then
			self.soul_table = {}
		end

		-- Start thinking
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_necromastery_souls:GetHeroEffectName()
	return "particles/units/heroes/hero_nevermore/nevermore_souls_hero_effect.vpcf"
end

function modifier_imba_necromastery_souls:OnIntervalThink()
	if IsServer() then

		--Scepter: Maximum Necromastery soul increase
		if self.caster:HasScepter() then
			--self.already_accounted = true -- necessary or else there would be an infinite increase to the cap
			self.max_souls = self.scepter_max_souls
		else
			self.max_souls = self.base_max_souls
		end

	   -- print(self.max_souls)
	  --  print(self.total_max_souls)
		
		-- Check if the souls cap is correct and reset it in case it's wrong 
		--(happens with a bug that reset the extra max souls cap from talent #3 on death and when dropping/selling aghanim scepter)
		
		if self.caster:HasTalent("special_bonus_imba_nevermore_3") then
			if self.total_max_souls ~= self.max_souls + self.ability.hero_killed then
				self.total_max_souls = self.max_souls + self.ability.hero_killed
			end
		else --updates the cap if scepter is bought or discarded when you don't have the talent
			self.total_max_souls = self.max_souls
		end

		--print(self.total_max_souls)

		-- Recalculate temporary souls
		self.max_souls_inc_temp = self.total_max_souls * (1 + (self.max_temporary_souls_pct * 0.01))

		-- Check if we have less souls than how many are registered in the table.
		local stacks = self:GetStackCount()

		-- If the caster hasn't gone beyond the maximum souls, set the duration to infinity
		if stacks <= self.total_max_souls then
			self:SetDuration(-1, true)
		end

		-- Souls were removed as stacks, but still need to be eliminated from the table
		if stacks < #self.soul_table then
			for i = #self.soul_table, (stacks + 1), -1 do
				table.remove(self.soul_table)
			end
		end

		-- Check if there are temporary souls
		if #self.soul_table > self.total_max_souls then

			-- Check each temporary soul's duration, to decide if he can go free
			for i = #self.soul_table, (self.total_max_souls + 1), -1 do
				if self.soul_table[i] + self.temporary_soul_duration < GameRules:GetGameTime() then
					table.remove(self.soul_table, i)
					self:DecrementStackCount()
				end
			end
		end
	end
end

function modifier_imba_necromastery_souls:OnRefresh()
	self:OnCreated()
end

function modifier_imba_necromastery_souls:OnStackCountChanged(old_stack_count)
	if IsServer() then
		-- If Necromastery is stolen, do nothing
		if self.ability:IsStolen() then
			return nil
		end

		-- Get current stack count
		local stacks = self:GetStackCount()

		-- New soul coming in
		if stacks > old_stack_count then

			-- If no new souls (even temporary ones) can come in, reduce the stack count to the maximum possible
			if stacks > self.max_souls_inc_temp then
				self:SetStackCount(self.max_souls_inc_temp)
				return nil
			end

			if stacks > self.total_max_souls then
				-- Set the new temporary soul duration
				self:SetDuration(self.temporary_soul_duration, true)
			end

			-- Insert new stack values on the soul table
			table.insert(self.soul_table, GameRules:GetGameTime())
		end
	end
end

function modifier_imba_necromastery_souls:DestroyOnExpire()
	return false
end

function modifier_imba_necromastery_souls:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					  MODIFIER_EVENT_ON_ATTACK_LANDED,
					  MODIFIER_EVENT_ON_DEATH}

	return decFuncs
end

function modifier_imba_necromastery_souls:GetModifierPreAttack_BonusDamage()
	local stacks = self:GetStackCount()

	-- Talent: Necromastery soul grant additional damage (REMOVED)
   -- local damage_per_soul = self.damage_per_soul + self.caster:FindTalentValue("special_bonus_imba_nevermore_8")

	return self.damage_per_soul * stacks
end

function modifier_imba_necromastery_souls:OnAttackLanded(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.target

		-- If Necromastery is stolen, do nothing
		if self.ability:IsStolen() then
			return nil
		end

		-- Only apply if the attacker is the caster
		if self.caster == attacker then

			-- If the caster is broken, do nothing
			if self.caster:PassivesDisabled() then
				return nil
			end

			-- #4 Talent: Souls now also grant lifesteal, only from enemies creeps or heroes
			if self.caster:HasTalent("special_bonus_imba_nevermore_4") then
				if target:GetTeamNumber() ~= self.caster:GetTeamNumber() and target:IsCreep() or target:IsHero() then
					local particle_lifesteal = "particles/generic_gameplay/generic_lifesteal.vpcf"

					if self.caster:IsRealHero() then

						local damage = keys.damage
						local stacks = self:GetStackCount()
						local lifesteal_per_soul = self.caster:FindTalentValue("special_bonus_imba_nevermore_4")

						-- Calculate lifesteal percentage
						local lifesteal = lifesteal_per_soul * stacks

						-- Heal the caster for a percentage of damage dealt
						local heal_amount = damage * lifesteal * 0.01
						self.caster:Heal(heal_amount, self.caster)

						-- Add lifesteal effect
						local particle_lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self.caster)
						ParticleManager:SetParticleControl(particle_lifesteal_fx, 0, self.caster:GetAbsOrigin())
					else
						-- Add lifesteal effect
						local particle_lifesteal_fx = ParticleManager:CreateParticle(particle_lifesteal, PATTACH_ABSORIGIN_FOLLOW, self.caster)
						ParticleManager:SetParticleControl(particle_lifesteal_fx, 0, self.caster:GetAbsOrigin())
					end
				end
			end

			-- If the target wasn't a real hero, do nothing
			if not target:IsRealHero() then
				return nil
			end

			-- Gain a soul and refresh
			AddNecromasterySouls(self.caster, self.hero_attack_soul_count)

			-- If caster is not broken and is visible, launch a hero soul to the caster
			if not self.caster:PassivesDisabled() and not self.caster:IsImbaInvisible() then
				local soul_projectile = {Target = self.caster,
										 Source = target,
										 Ability = self.ability,
										 EffectName = self.particle_soul_hero,
										 bDodgeable = false,
										 bProvidesVision = false,
										 iMoveSpeed = self.soul_projectile_speed,
										 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
										 }


				ProjectileManager:CreateTrackingProjectile(soul_projectile)
			end
		end
	end
end

function modifier_imba_necromastery_souls:OnDeath(keys)
	if IsServer() then
		local target = keys.unit
		local attacker = keys.attacker

		-- If Necromastery is stolen, do nothing
		if self.ability:IsStolen() then
			return nil
		end

		-- If the caster of the ability is a Nether Ward, do nothing
		if string.find(self.caster:GetUnitName(), "npc_imba_pugna_nether_ward") then
			return nil
		end

		-- Only apply if the caster is the attacker (and NOT the victim)
		if self.caster == attacker and self.caster ~= target then

			-- If the target was an illusion, do nothing
			if target:IsIllusion() then
				return nil
			end

			-- If the target was a tempest double, do nothing
			if target:IsTempestDouble() then
				return nil
			end

			-- If the target was a building, do nothing
			if target:IsBuilding() then
				return nil
			end

			-- If the target was a ginger, do nothing
			if IsGinger(target) then
				return nil
			end


			-- Decide how many souls should the caster get
			local soul_count = 0
			if target:IsRealHero() then
				--Talent #3: Increase souls cap permanently on hero kills. It is a retroactive talent, so when activated it will account all the hero kills
				self.ability.hero_killed = (self.ability.hero_killed or (self.caster:GetKills() - 1)) + 1
				--print(self.ability.hero_killed)
				--print(self.total_max_souls)
				soul_count = self.hero_kill_soul_count
			else
				soul_count = self.creep_kill_soul_count
			end

			-- Increase souls appropriately
			AddNecromasterySouls(self.caster, soul_count)

			-- If caster is not disabled and is visible, launch a soul
			if not self.caster:PassivesDisabled() and not self.caster:IsImbaInvisible() then
				if soul_count == self.hero_kill_soul_count then
					-- Launch a hero soul to the caster
					local soul_projectile = {Target = self.caster,
											 Source = target,
											 Ability = self.ability,
											 EffectName = self.particle_soul_hero,
											 bDodgeable = false,
											 bProvidesVision = false,
											 iMoveSpeed = self.soul_projectile_speed,
											 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
											 }


					ProjectileManager:CreateTrackingProjectile(soul_projectile)

				else
					-- Launch a creep soul to the caster
					local soul_projectile = {Target = self.caster,
											 Source = target,
											 Ability = self.ability,
											 EffectName = self.particle_soul_creep,
											 bDodgeable = false,
											 bProvidesVision = false,
											 iMoveSpeed = self.soul_projectile_speed,
											 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
											 }


					ProjectileManager:CreateTrackingProjectile(soul_projectile)
				end
			end
		end


		-- If the caster was the one who died, he loses half his stacks (unless he has #7 Talent)
		if self.caster == target then
			local stacks = self:GetStackCount()
			local stacks_lost = math.floor(stacks * (self.souls_lost_on_death_pct * 0.01))

			-- #7 Talent: Necromastery souls are not lost on death
			if not self.caster:HasTalent("special_bonus_imba_nevermore_7") then
				RemoveNecromasterySouls(self.caster, stacks_lost)
			end

			-- If the caster has Requiem of Souls, use the spell with a death cast tag
			if self.caster:HasAbility(self.requiem_ability) then
				local requiem_ability_handler = self.caster:FindAbilityByName(self.requiem_ability)
				if requiem_ability_handler then
					if requiem_ability_handler:GetLevel() >= 1 then
						requiem_ability_handler:OnSpellStart(true)
					end
				end
			end
		end
	end
end

function modifier_imba_necromastery_souls:IsPermanent() return true end
function modifier_imba_necromastery_souls:IsHidden() return false end
function modifier_imba_necromastery_souls:IsPurgable() return false end
function modifier_imba_necromastery_souls:IsDebuff() return false end
function modifier_imba_necromastery_souls:AllowIllusionDuplicate() return true end

function AddNecromasterySouls(caster, soul_count)
	local modifier_souls = "modifier_imba_necromastery_souls"

	-- If caster is broken, do nothing
	if caster:PassivesDisabled() then
		return nil
	end

	if caster:HasModifier(modifier_souls) then
		local modifier_souls_handler = caster:FindModifierByName(modifier_souls)
		if modifier_souls_handler then
			for i = 1, soul_count do
				modifier_souls_handler:IncrementStackCount()
			end
		end
	end
end

function RemoveNecromasterySouls(caster, soul_count)
	local modifier_souls = "modifier_imba_necromastery_souls"

	if caster:HasModifier(modifier_souls) then
		local modifier_souls_handler = caster:FindModifierByName(modifier_souls)
		if modifier_souls_handler then
			for i = 1, soul_count do
				modifier_souls_handler:DecrementStackCount()
			end
		end
	end
end


------------------------------------
--   PRESENCE OF THE DARK LORD    --
------------------------------------
imba_nevermore_dark_lord = imba_nevermore_dark_lord or class({})
LinkLuaModifier("modifier_imba_dark_lord_aura", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_dark_lord_debuff", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_dark_lord:GetAbilityTextureName()
   return "nevermore_dark_lord"
end

function imba_nevermore_dark_lord:GetIntrinsicModifierName()
	return "modifier_imba_dark_lord_aura"
end

function imba_nevermore_dark_lord:OnUpgrade()
	local caster = self:GetCaster()
	local upgrade_response = "nevermore_nev_ability_presence_0"..math.random(1,3)

	EmitSoundOn(upgrade_response, caster)
end

-- Presence of the Dark Lord aura
modifier_imba_dark_lord_aura = modifier_imba_dark_lord_aura or class({})

function modifier_imba_dark_lord_aura:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_soul_hero = "particles/hero/nevermore/nevermore_soul_projectile.vpcf"
	self.modifier_souls = "modifier_imba_necromastery_souls"

	-- Ability specials
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")

	-- Start thinking
	self:StartIntervalThink(1)
end

function modifier_imba_dark_lord_aura:OnIntervalThink()
	if IsServer() then
		-- #5 Talent: Presence of the Lord gain a soul from nearby enemies
		if self.caster:HasTalent("special_bonus_imba_nevermore_5") and self.caster:HasModifier(self.modifier_souls) and self.caster:IsAlive() then
			local soul_drain_count = self.caster:FindTalentValue("special_bonus_imba_nevermore_5")
			local soul_projectile_speed

			-- Find the projectile speed through the necro ability
			local modifier_souls_handler = self.caster:FindModifierByName(self.modifier_souls)
			if not modifier_souls_handler then
				return nil
			else
				soul_projectile_speed = modifier_souls_handler:GetAbility():GetSpecialValueFor("soul_projectile_speed")
			end

			-- Find real enemy heroes nearby
			local enemy_heroes = FindUnitsInRadius(self.caster:GetTeamNumber(),
												   self.caster:GetAbsOrigin(),
												   nil,
												   self.aura_radius,
												   DOTA_UNIT_TARGET_TEAM_ENEMY,
												   DOTA_UNIT_TARGET_HERO,
												   DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
												   FIND_ANY_ORDER,
												   false)

			-- Each enemy hero sends a soul. Illusions only fake it instead
			for _,enemy_hero in pairs(enemy_heroes) do

				-- Send a soul if Nevermore is visible
				if not self.caster:IsImbaInvisible() then
					local soul_projectile = {Target = self.caster,
										 Source = enemy_hero,
										 Ability = self.ability,
										 EffectName = self.particle_soul_hero,
										 bDodgeable = false,
										 bProvidesVision = false,
										 iMoveSpeed = soul_projectile_speed,
										 iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
										 }


					ProjectileManager:CreateTrackingProjectile(soul_projectile)
				end

				-- If it's a real hero, gain a soul
				if enemy_hero:IsRealHero() then
					AddNecromasterySouls(self.caster, soul_drain_count)
				end
			end
		end
	end
end

function modifier_imba_dark_lord_aura:IsHidden() return true end
function modifier_imba_dark_lord_aura:IsPurgable() return false end
function modifier_imba_dark_lord_aura:IsDebuff() return false end

function modifier_imba_dark_lord_aura:OnRefresh()
	self:OnCreated()
end

function modifier_imba_dark_lord_aura:AllowIllusionDuplicate()
	return true
end

function modifier_imba_dark_lord_aura:GetAuraEntityReject(target)

	-- If the target cannot see the caster, the aura wouldn't affect it
	if not target:CanEntityBeSeenByMyTeam(self.caster) then
		return true -- reject it
	end

	return false -- accept
end

function modifier_imba_dark_lord_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_imba_dark_lord_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_imba_dark_lord_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_dark_lord_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_imba_dark_lord_aura:GetModifierAura()
	return "modifier_imba_dark_lord_debuff"
end

function modifier_imba_dark_lord_aura:IsAura()
	-- If caster is broken, aura stops emitting itself
	if self.caster:PassivesDisabled() then
		return false
	end

	return true
end


-- Presence of the Dark Lord armor reduction debuff modifier
modifier_imba_dark_lord_debuff = modifier_imba_dark_lord_debuff or class({})

function modifier_imba_dark_lord_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()

	-- Ability specials
	self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
	self.raze_armor_reduction = self.ability:GetSpecialValueFor("raze_armor_reduction")
	self.raze_reduction_duration = self.ability:GetSpecialValueFor("raze_reduction_duration")
	self.max_stacks = self.ability:GetSpecialValueFor("max_stacks")

	if IsServer() then
		-- Initialize a "timer"
		if not self.last_stack then
			self.last_stack = GameRules:GetGameTime()
		end

		-- Start thinking
		self:StartIntervalThink(0.25)
	end
end

function modifier_imba_dark_lord_debuff:OnIntervalThink()
	if IsServer() then
		local stacks = self:GetStackCount()

		-- If there is at least one stack, check if the duration was reached
		if stacks > 0 then
			if self.last_stack + self.raze_reduction_duration < GameRules:GetGameTime() then

				-- If the duration was reached, remove all stacks
				self:SetStackCount(0)
			end
		end
	end
end

function modifier_imba_dark_lord_debuff:OnStackCountChanged()
	if IsServer() then
		-- If the stack count is above the maximum, set it at the maximum again
		local stacks = self:GetStackCount()
		if stacks > self.max_stacks then
			self:SetStackCount(self.max_stacks)
		end

		-- Set the new stack (psuedo) duration
		self.last_stack = GameRules:GetGameTime()
	end
end


function modifier_imba_dark_lord_debuff:IsHidden() return false end
function modifier_imba_dark_lord_debuff:IsPurgable() return false end
function modifier_imba_dark_lord_debuff:IsDebuff() return true end

function modifier_imba_dark_lord_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}

	return decFuncs
end

function modifier_imba_dark_lord_debuff:GetModifierPhysicalArmorBonus()
	local stacks = self:GetStackCount()

	--Talent: Presence of the Dark Lord Armor reduction increase (REMOVED)
	--local armor_reduction = self.armor_reduction + self.caster:FindTalentValue("special_bonus_imba_nevermore_2", "armor_reduction")
	--local raze_armor_reduction = self.raze_armor_reduction + self.caster:FindTalentValue("special_bonus_imba_nevermore_2", "raze_armor_reduction")

	local total_armor_reduction = self.armor_reduction + stacks * self.raze_armor_reduction

	return total_armor_reduction * (-1)
end



------------------------------------
--       REQUIEM OF SOULS         --
------------------------------------
imba_nevermore_requiem = imba_nevermore_requiem or class({})
LinkLuaModifier("modifier_imba_reqiuem_phase_buff", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reqiuem_debuff", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reqiuem_harvest", "components/abilities/heroes/hero_nevermore.lua", LUA_MODIFIER_MOTION_NONE)

function imba_nevermore_requiem:GetAbilityTextureName()
   return "nevermore_requiem"
end

function imba_nevermore_requiem:IsHiddenWhenStolen()
	return false
end

function imba_nevermore_requiem:GetAssociatedSecondaryAbilities()
	return "imba_nevermore_necromastery"
end

function imba_nevermore_requiem:OnAbilityPhaseStart()
	-- Play sound
	if self:GetCaster():IsImbaInvisible() then
		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Nevermore.RequiemOfSoulsCast", self:GetCaster())
	else
		self:GetCaster():EmitSound("Hero_Nevermore.RequiemOfSoulsCast")
	end

	-- Start cast animation
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_6)

	-- Caster becomes phased while casting
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_reqiuem_phase_buff", {})

	return true
end

function imba_nevermore_requiem:OnAbilityPhaseInterrupted()
	-- Stop cast animation
	self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_6)

	-- Remove phased movement from caster
	self:GetCaster():RemoveModifierByName("modifier_imba_reqiuem_phase_buff")
end

function imba_nevermore_requiem:OnSpellStart(death_cast)
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_requiem_01", "nevermore_nev_ability_requiem_02", "nevermore_nev_ability_requiem_03", "nevermore_nev_ability_requiem_04", "nevermore_nev_ability_requiem_05", "nevermore_nev_ability_requiem_06", "nevermore_nev_ability_requiem_07", "nevermore_nev_ability_requiem_08", "nevermore_nev_ability_requiem_11", "nevermore_nev_ability_requiem_12", "nevermore_nev_ability_requiem_13", "nevermore_nev_ability_requiem_14"}
	local sound_cast = "Hero_Nevermore.RequiemOfSouls"
	local particle_caster_souls = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_a.vpcf"
	local particle_caster_ground = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf"
	local modifier_phase = "modifier_imba_reqiuem_phase_buff"
	local modifier_souls = "modifier_imba_necromastery_souls"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"

	-- Ability specials
	local harvest_base_cd = ability:GetSpecialValueFor("harvest_base_cd")
	local souls_per_line = ability:GetSpecialValueFor("souls_per_line")
	local travel_distance = ability:GetSpecialValueFor("travel_distance")

	-- Play cast response
	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	-- Play cast sound
	EmitSoundOn(sound_cast, caster)

	-- Remove phased movement from caster
	caster:RemoveModifierByName(modifier_phase)

	-- Add particles for the caster and the ground
	local particle_caster_souls_fx = ParticleManager:CreateParticle(particle_caster_souls, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 1, Vector(lines, 0, 0))
	ParticleManager:SetParticleControl(particle_caster_souls_fx, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_caster_souls_fx)

	local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(lines, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)

	-- Find the Necromastery modifier, its stack count and the ability that used it
	local modifier_souls_handler
	local stacks
	local necro_ability
	local max_souls

	if caster:HasModifier(modifier_souls) then
		modifier_souls_handler = caster:FindModifierByName(modifier_souls)
		if modifier_souls_handler then
			stacks = modifier_souls_handler:GetStackCount()
			necro_ability = modifier_souls_handler:GetAbility()
		max_souls = modifier_souls_handler.total_max_souls
		end
	end

	-- If the modifier was not found, Requiem fails (no souls to release).
	if not modifier_souls_handler then
		return nil
	end

	-- Talent: Maximum Necromastery soul increase (REMOVED)
	-- max_souls = max_souls + caster:FindTalentValue("special_bonus_imba_nevermore_6")

	local line_count
	-- Determind if it was a death cast (clears and ignores temporary souls)
	if death_cast and not caster:HasTalent("special_bonus_imba_nevermore_7") then
		-- Remove souls that are above the maximum
		if stacks > max_souls then
			local temp_souls_count = stacks - max_souls
			RemoveNecromasterySouls(caster, temp_souls_count)
			stacks = max_souls
		end

		-- Determine the amount of lines to create
		line_count = math.floor(stacks / souls_per_line)

	else
		-- Determine the amount of lines to create
		line_count = math.floor(stacks / souls_per_line)

		-- Remove souls that are above the maximum
		if stacks > max_souls then
			local temp_souls_count = stacks - max_souls
			RemoveNecromasterySouls(caster, temp_souls_count)
		end
	end

	-- Add the Soul Harvest modifier to the caster
	caster:AddNewModifier(caster, ability, modifier_harvest, {duration = harvest_base_cd})

	-- Calculate the first line location, in front of the caster
	local line_position = caster:GetAbsOrigin() + caster:GetForwardVector() * travel_distance

	-- Create the first line
	CreateRequiemSoulLine(caster, ability, line_position, death_cast)

	-- Calculate the location of every other line
	local qangle_rotation_rate = 360 / line_count
	for i = 1, line_count - 1 do
		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(caster:GetAbsOrigin(), qangle, line_position)

		-- Create every other line
		CreateRequiemSoulLine(caster, ability, line_position, death_cast)
	end
end

function imba_nevermore_requiem:OnProjectileHit_ExtraData(target, location, extra_data)
	-- If there was no target, do nothing
	if not target then
		return nil
	end

	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local modifier_debuff = "modifier_imba_reqiuem_debuff"
	local modifier_harvest = "modifier_imba_reqiuem_harvest"
	local scepter_line = extra_data.scepter_line

	-- Ability specials
	local damage = ability:GetSpecialValueFor("damage")
	local slow_duration = ability:GetSpecialValueFor("slow_duration")
	local harvest_line_duration_inc = ability:GetSpecialValueFor("harvest_line_duration_inc")
	local scepter_line_damage_pct = ability:GetSpecialValueFor("scepter_line_damage_pct")

	-- Convert from string to bool
	if scepter_line == 0 then
		scepter_line = false
	else
		scepter_line = true
	end

	-- Apply the debuff on enemies hit
	target:AddNewModifier(caster, ability, modifier_debuff, {duration = slow_duration})

	-- If the caster still has the Soul Harvest buff, increase it
	if caster:HasModifier(modifier_harvest) and target:IsRealHero() then
		local modifier_harvest_handler = caster:FindModifierByName(modifier_harvest)
		if modifier_harvest_handler then
			modifier_harvest_handler:SetDuration(modifier_harvest_handler:GetRemainingTime() + harvest_line_duration_inc, true)
		end
	end

	-- If this line is a scepter line, reduce the damage
	if scepter_line then
		damage = damage * (scepter_line_damage_pct * 0.01)
	end



	-- Damage the target
	local damageTable = {victim = target,
						damage = damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						attacker = caster,
						ability = ability
						}

	local damage_dealt = ApplyDamage(damageTable)

	-- If this line is a scepter line, heal the caster for the actual damage dealt
	if scepter_line then
		caster:Heal(damage_dealt, caster)
	end
end


function CreateRequiemSoulLine(caster, ability, line_end_position, death_cast)
	-- Ability properties
	local particle_lines = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf"
	local scepter = caster:HasScepter()

	-- Ability specials
	local travel_distance = ability:GetSpecialValueFor("travel_distance")
	local lines_starting_width = ability:GetSpecialValueFor("lines_starting_width")
	local lines_end_width = ability:GetSpecialValueFor("lines_end_width")
	local travel_distance = ability:GetSpecialValueFor("travel_distance")
	local lines_travel_speed = ability:GetSpecialValueFor("lines_travel_speed")

	-- Calculate the time that it would take to reach the maximum distance
	local max_distance_time = travel_distance / lines_travel_speed

	-- Calculate velocity
	local velocity = (line_end_position - caster:GetAbsOrigin()):Normalized() * lines_travel_speed

	-- Launch the line
	projectile_info = {Ability = ability,
					   EffectName = particle_lines,
					   vSpawnOrigin = caster:GetAbsOrigin(),
					   fDistance = travel_distance,
					   fStartRadius = lines_starting_width,
					   fEndRadius = lines_end_width,
					   Source = caster,
					   bHasFrontalCone = false,
					   bReplaceExisting = false,
					   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
					   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					   bDeleteOnHit = false,
					   vVelocity = velocity,
					   bProvidesVision = false,
					   ExtraData = {scepter_line = false}
					   }

	-- Create the projectile
	ProjectileManager:CreateLinearProjectile(projectile_info)

	-- Create the particle
	local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_lines_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
	ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
	ParticleManager:ReleaseParticleIndex(particle_lines_fx)

	-- If the caster has a Scepter, wait for line to finish, then summon the lines back to the caster
	-- Doesn't trigger when triggered from caster's death
	if scepter and not death_cast then
		Timers:CreateTimer(max_distance_time, function()
			-- Calculate velocity
			local velocity = (caster:GetAbsOrigin() - line_end_position):Normalized() * lines_travel_speed

			-- Launch the line
			projectile_info = {Ability = ability,
							   EffectName = particle_lines,
							   vSpawnOrigin = line_end_position,
							   fDistance = travel_distance,
							   fStartRadius = lines_end_width,
							   fEndRadius = lines_starting_width,
							   Source = caster,
							   bHasFrontalCone = false,
							   bReplaceExisting = false,
							   iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
							   iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
							   iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							   bDeleteOnHit = false,
							   vVelocity = velocity,
							   bProvidesVision = false,
							   ExtraData = {scepter_line = true}
							   }

			-- Create the projectile
			ProjectileManager:CreateLinearProjectile(projectile_info)

			-- Create the particle
			local particle_lines_fx = ParticleManager:CreateParticle(particle_lines, PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_lines_fx, 0, line_end_position)
			ParticleManager:SetParticleControl(particle_lines_fx, 1, velocity)
			ParticleManager:SetParticleControl(particle_lines_fx, 2, Vector(0, max_distance_time, 0))
			ParticleManager:ReleaseParticleIndex(particle_lines_fx)
		end)
	end
end


-- Requiem of Souls caster phased modifier
modifier_imba_reqiuem_phase_buff = modifier_imba_reqiuem_phase_buff or class({})

function modifier_imba_reqiuem_phase_buff:CheckState()
	local state = {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	return state
end

function modifier_imba_reqiuem_phase_buff:IsHidden() return true end
function modifier_imba_reqiuem_phase_buff:IsPurgable() return false end
function modifier_imba_reqiuem_phase_buff:IsDebuff() return false end



-- Requiem of Souls slow debuff
modifier_imba_reqiuem_debuff = modifier_imba_reqiuem_debuff or class({})

function modifier_imba_reqiuem_debuff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self:GetDuration()
	self.particle_black_screen = "particles/hero/nevermore/screen_requiem_indicator.vpcf"

	-- Ability specials
	self.damage_reduction_pct = self.ability:GetSpecialValueFor("damage_reduction_pct")
	self.ms_slow_pct = self.ability:GetSpecialValueFor("ms_slow_pct")

	if IsServer() then
		self.scepter = self.caster:HasScepter()

		-- Paint the eyes of players in black if the caster has a scepter
		if self.scepter and self.parent:IsRealHero() then
			local requiem_screen_particle = ParticleManager:CreateParticleForPlayer(self.particle_black_screen, PATTACH_EYES_FOLLOW, self.parent, PlayerResource:GetPlayer(self.parent:GetPlayerID()))
			self:AddParticle(requiem_screen_particle, false, false, -1, false, false)
		end
	end
end

function modifier_imba_reqiuem_debuff:IsHidden() return false end
function modifier_imba_reqiuem_debuff:IsPurgable() return true end
function modifier_imba_reqiuem_debuff:IsDebuff() return true end

function modifier_imba_reqiuem_debuff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
					  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}

	return decFuncs
end

function modifier_imba_reqiuem_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction_pct * (-1)
end

function modifier_imba_reqiuem_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow_pct * (-1)
end


-- Requiem of Souls Soul Harvest modifier
modifier_imba_reqiuem_harvest = modifier_imba_reqiuem_harvest or class({})

function modifier_imba_reqiuem_harvest:OnCreated()
	if IsServer() then
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.razes = {}
		self.razes[1] = "imba_nevermore_shadowraze_close"
		self.razes[2] = "imba_nevermore_shadowraze_medium"
		self.razes[3] = "imba_nevermore_shadowraze_far"

		-- Find all raze skills
		for i = 1, #self.razes do
			if self.caster:HasAbility(self.razes[i]) then
				local raze_handler = self.caster:FindAbilityByName(self.razes[i])
				if raze_handler then
					-- If razes were found, refresh their cooldown
					raze_handler:EndCooldown()
				end
			end
		end
	end
end

function modifier_imba_reqiuem_harvest:IsHidden() return false end
function modifier_imba_reqiuem_harvest:IsPurgable() return false end
function modifier_imba_reqiuem_harvest:IsDebuff() return false end
