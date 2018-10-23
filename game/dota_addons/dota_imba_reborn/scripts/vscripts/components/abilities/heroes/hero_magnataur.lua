-- Editors:
--     AtroCty, 28.03.2017

-- util
-- Checks if a unit is near units of a certain class not on its team
local function IsNearEnemyClass(unit, radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, unit:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() ~= unit:GetTeam() then
			return true
		end
	end
	
	return false
end

-------------------------------------------
--				POLARIZE
-------------------------------------------

LinkLuaModifier("modifier_imba_polarize_debuff", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_polarize_debuff = modifier_imba_polarize_debuff or class({})

function modifier_imba_polarize_debuff:IsDebuff()
	return true
end

function modifier_imba_polarize_debuff:IsPurgable()
	return false
end

function modifier_imba_polarize_debuff:IsHidden()
	return false
end

function modifier_imba_polarize_debuff:GetTexture()
	return "custom/magnus_polarize"
end


function modifier_imba_polarize_debuff:OnCreated()
	if IsServer() then
		self.parent = self:GetParent()
		self.caster = self:GetCaster()

		local think_interval

		if self.caster:HasTalent("special_bonus_imba_magnataur_7") then
			think_interval = self.caster:FindTalentValue("special_bonus_imba_magnataur_7")
		else
			think_interval = 1.0
		end

		self:StartIntervalThink(think_interval)
	end
end

function modifier_imba_polarize_debuff:OnIntervalThink()
	if IsServer() then
		-- #7 Talent: Polarzied enemies are constantly pulled towards their nearest ally, the pull strength is 10% of their movement speed
		if self.caster:HasTalent("special_bonus_imba_magnataur_7") then
			local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

			for _,enemy in pairs (enemies) do
				if enemy ~= self.parent then
					local direction = (enemy:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
					local new_point = self.parent:GetAbsOrigin() + direction * self.parent:GetIdealSpeed() * self.caster:FindTalentValue("special_bonus_imba_magnataur_7","pull_strength") * 0.01

					-- Play the particle
					self.parent:AddNewModifier(self.caster,nil,"modifier_imba_polarize_debuff_pull",{duration = 0.15})

					self.parent:SetAbsOrigin(new_point)
					-- Find a clear space to stand on
					self.parent:SetUnitOnClearGround()
					-- Break the loop to prevent chaos!!
					break
				end
			end
		end
	end
end


function modifier_imba_polarize_debuff:GetEffectName()
	return "particles/econ/items/magnataur/seismic_berserker/seismic_berserker_weapon_horn_b.vpcf"
end

function modifier_imba_polarize_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

LinkLuaModifier("modifier_imba_polarize_debuff_stack", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_polarize_debuff_stack = modifier_imba_polarize_debuff_stack or class({})

function modifier_imba_polarize_debuff_stack:IsDebuff()
	return true
end

function modifier_imba_polarize_debuff_stack:IsPurgable()
	return false
end

function modifier_imba_polarize_debuff_stack:IsHidden()
	return true
end

function modifier_imba_polarize_debuff_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_polarize_debuff_stack:OnCreated( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()

		if parent:HasModifier("modifier_imba_polarize_debuff") then
			local modifier = parent:FindModifierByName("modifier_imba_polarize_debuff")
			modifier:IncrementStackCount()
			local max_duration = params.duration
			local modifier_counter = parent:FindAllModifiersByName("modifier_imba_polarize_debuff_stack")
			for _,modi in ipairs(modifier_counter) do
				local current_duration = modi:GetDuration()
				if current_duration > max_duration then
					max_duration = current_duration
				end
			end
			modifier:SetDuration(max_duration, true)
		else
			parent:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff", {duration = params.duration})
			parent:FindModifierByName("modifier_imba_polarize_debuff"):SetStackCount(1)
		end
	end
end

function modifier_imba_polarize_debuff_stack:OnDestroy( )
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_imba_polarize_debuff") then
			parent:FindModifierByName("modifier_imba_polarize_debuff"):DecrementStackCount()
		end
	end
end

LinkLuaModifier("modifier_imba_polarize_debuff_pull", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

modifier_imba_polarize_debuff_pull = class ({})

function modifier_imba_polarize_debuff_pull:IsDebuff()
	return true
end

function modifier_imba_polarize_debuff_pull:IsPurgable()
	return false
end

function modifier_imba_polarize_debuff_pull:IsHidden()
	return true
end

function modifier_imba_polarize_debuff_pull:GetEffectName()
	return "particles/hero/magnataur/skewer_entangle_debuff.vpcf"
end

function modifier_imba_polarize_debuff_pull:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


-------------------------------------------
--				MAGNETIZE
-------------------------------------------

LinkLuaModifier("modifier_imba_magnetize_debuff", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_magnetize_debuff = modifier_imba_magnetize_debuff or class({})

function modifier_imba_magnetize_debuff:IsDebuff()
	return true
end

function modifier_imba_magnetize_debuff:IsPurgable()
	return false
end

function modifier_imba_magnetize_debuff:IsHidden()
	return false
end

function modifier_imba_magnetize_debuff:GetTexture()
	return "custom/magnus_magnetize"
end

function modifier_imba_magnetize_debuff:GetEffectName()
	return "particles/econ/items/magnataur/seismic_berserker/seismic_berserker_weapon_horn_b.vpcf"
end

function modifier_imba_magnetize_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

LinkLuaModifier("modifier_imba_magnetize_debuff_stack", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_magnetize_debuff_stack = modifier_imba_magnetize_debuff_stack or class({})

function modifier_imba_magnetize_debuff_stack:IsDebuff()
	return true
end

function modifier_imba_magnetize_debuff_stack:IsPurgable()
	return false
end

function modifier_imba_magnetize_debuff_stack:IsHidden()
	return true
end

function modifier_imba_magnetize_debuff_stack:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_imba_magnetize_debuff_stack:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()

		local duration = self:GetRemainingTime()
		self.max_duration = self:GetAbility():GetSpecialValueFor("magnetize_duration")

		if parent:HasModifier("modifier_imba_magnetize_debuff") then
			local modifier = parent:FindModifierByName("modifier_imba_magnetize_debuff")
			modifier:IncrementStackCount()
			local modifier_counter = parent:FindAllModifiersByName("modifier_imba_magnetize_debuff_stack")
			for _,modi in ipairs(modifier_counter) do
				local current_duration = modi:GetDuration()
				if current_duration < duration then
					duration = current_duration
				end
			end
			modifier:SetDuration(duration, true)
		else
			parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_magnetize_debuff", {duration = duration})
			parent:FindModifierByName("modifier_imba_magnetize_debuff"):SetStackCount(1)
		end
		self:StartIntervalThink(self.max_duration)
	end
end

function modifier_imba_magnetize_debuff_stack:OnIntervalThink()
	if IsServer() then
		self.max_duration = self:GetAbility():GetSpecialValueFor("magnetize_duration")
		local parent = self:GetParent()

		-- Find 1 enemy to launch the shockwave
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), nil, self.distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for _,enemy in pairs (enemies) do
			local direction

			-- If there are more than 1 enemies and the target is the parent, search for a new target
			if enemy == parent and #enemies > 1 then
			else

				-- If there are no nearby enemies, launch the shockwave in a random direction :D
				if #enemies <= 1 then
					direction = (parent:GetAbsOrigin() - (parent:GetAbsOrigin() + RandomVector(64))):Normalized()
				else
					if enemy == parent then
					else
						-- Else, launch the shockwave towards the nearest enemy
						direction = (enemy:GetAbsOrigin() - parent:GetAbsOrigin()):Normalized()
					end
				end
				-- If there are more than 1 enemies and the target is the parent, do nothing
				if enemy == parent and #enemies > 1 then
				else
					parent:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_magnetize_debuff_immune",{duration = 0.1})
					-- Launch projectile
					local projectile =
						{
							Ability				= self:GetAbility(),
							EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
							vSpawnOrigin		= parent:GetAbsOrigin(),
							fDistance			= self.distance,
							fStartRadius		= self.radius,
							fEndRadius			= self.radius,
							Source				= self:GetCaster(),
							bHasFrontalCone		= false,
							bReplaceExisting	= false,
							iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
							iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							fExpireTime 		= GameRules:GetGameTime() + 5.0,
							bDeleteOnHit		= false,
							vVelocity			= Vector(direction.x,direction.y,0) * self.speed,
							bProvidesVision		= false,
							ExtraData			= {damage = self.damage, distance = self.distance, polarize_duration = self.polarize_duration, magnetize_duration = self.magnetize_duration, speed = self.speed, radius = self.radius, magnetize_shockwave = 1, talent = 0}
						}
					ProjectileManager:CreateLinearProjectile(projectile)
					-- Break the loop after launching the shockwave
					break
				end
			end
		end

		-- Get the stack modifier
		local modifier_magnetize = parent:FindModifierByName("modifier_imba_magnetize_debuff")
		local modifier_magnetize_stack = parent:FindModifierByName("modifier_imba_magnetize_debuff_stack")

		-- Reduce it by one count
		if modifier_magnetize then
			if modifier_magnetize:GetStackCount() <= 1 then
				modifier_magnetize:Destroy()
				modifier_magnetize_stack:Destroy()
			else
				modifier_magnetize:DecrementStackCount()
				modifier_magnetize:SetDuration(self.max_duration, true)
				modifier_magnetize_stack:DecrementStackCount()
				modifier_magnetize_stack:SetDuration(self.max_duration, true)
			end
		end
	end
end

LinkLuaModifier("modifier_imba_magnetize_debuff_immune", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
modifier_imba_magnetize_debuff_immune = modifier_imba_magnetize_debuff_immune or class({})

function modifier_imba_magnetize_debuff_immune:IsDebuff()
	return false
end

function modifier_imba_magnetize_debuff_immune:IsPurgable()
	return false
end

function modifier_imba_magnetize_debuff_immune:IsHidden()
	return true
end

-------------------------------------------
--				SHOCKWAVE
-------------------------------------------

LinkLuaModifier("modifier_imba_shockwave_root", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
imba_magnataur_shockwave = imba_magnataur_shockwave or class({})

function imba_magnataur_shockwave:GetAbilityTextureName()
	return "magnataur_shockwave"
end

function imba_magnataur_shockwave:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Magnataur.ShockWave.Cast")
		self.swing_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		local swing = self.swing_fx
		ParticleManager:SetParticleControlEnt(self.swing_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.swing_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(self:GetBackswingTime(), function()
			ParticleManager:DestroyParticle(swing, false)
			ParticleManager:ReleaseParticleIndex(swing)
		end)
		return true
	end
end

function imba_magnataur_shockwave:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Magnataur.ShockWave.Cast")
		ParticleManager:DestroyParticle(self.swing_fx, false)
		return true
	end
end

function imba_magnataur_shockwave:IsStealable()
	return true
end

function imba_magnataur_shockwave:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_shockwave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local secondary_damage = self:GetSpecialValueFor("secondary_damage")
		local spread_angle = self:GetSpecialValueFor("spread_angle")
		local secondary_amount = self:GetSpecialValueFor("secondary_amount")
		local secondary_occurance = self:GetSpecialValueFor("secondary_occurance")
		local distance = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local polarize_duration = self:GetTalentSpecialValueFor("polarize_duration")
		local magnetize_duration = self:GetTalentSpecialValueFor("magnetize_duration")
		local speed = self:GetSpecialValueFor("speed")
		local radius = self:GetSpecialValueFor("radius")
		local direction = (target_loc - caster_loc):Normalized()

		-- Creating a unique list of hit-Targets, delete it after 15 secs
		local index = "hit_targets_" .. tostring(GameRules:GetDOTATime(true,true))
		self[index] = {}
		self[index .. "_counter"] = secondary_occurance
		Timers:CreateTimer(15, function()
			self[index] = nil
			self[index .. "_counter"] = nil
		end)

		-- Play cast sound on dummy, which tracks the shockwave
		caster:EmitSound("Hero_Magnataur.ShockWave.Particle")
		if not caster:EmitCasterSound("npc_dota_hero_magnataur",{
			"magnataur_magn_shockwave_01",
			"magnataur_magn_shockwave_02"}, 75, DOTA_CAST_SOUND_FLAG_NONE, nil, nil ) then
			if not caster:EmitCasterSound("npc_dota_hero_magnataur",{
				"magnataur_magn_shockwave_04",
				"magnataur_magn_shockwave_05"}, 50, DOTA_CAST_SOUND_FLAG_NONE, nil, nil) then
				caster:EmitCasterSound("npc_dota_hero_magnataur",{
					"magnataur_magn_shockwave_03"}, 15, DOTA_CAST_SOUND_FLAG_NONE, nil, nil)
			end
		end

		-- Launch projectile
		local projectile =
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
				vSpawnOrigin		= caster_loc,
				fDistance			= distance,
				fStartRadius		= radius,
				fEndRadius			= radius,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 5.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(direction.x,direction.y,0) * speed,
				bProvidesVision		= false,
				ExtraData			= {index = index, damage = damage, secondary_damage = damage/2, spread_angle = spread_angle, secondary_amount = secondary_amount, distance = distance, polarize_duration = polarize_duration, magnetize_duration = magnetize_duration, speed = speed, direction_x = direction.x, direction_y = direction.y, radius = radius, magnetize_shockwave = 0, talent = 1, caster_loc_x = caster_loc.x, caster_loc_y = caster_loc.y}
			}
		ProjectileManager:CreateLinearProjectile(projectile)
	end
end

function imba_magnataur_shockwave:OnProjectileThink_ExtraData(location, ExtraData)
	if IsServer() then
		local caster = self:GetCaster()
		local distance = (location - Vector(ExtraData.caster_loc_x,ExtraData.caster_loc_y,0)):Length2D()
		-- #1 Talent: Shockwave now spawns secondary shockwaves halfway through
		if caster:HasTalent("special_bonus_imba_magnataur_1") and ExtraData.talent == 1 and distance > (ExtraData.distance/2 - ExtraData.speed * FrameTime()) and distance < ExtraData.distance/2 then
			local start_angle
			local interval_angle = 0
			local direction = Vector(ExtraData.direction_x,ExtraData.direction_y,0)
			if ExtraData.secondary_amount == 1 then
				start_angle = 0
			else
				start_angle = ExtraData.spread_angle * (-1)
				interval_angle = (ExtraData.spread_angle * 2 / ExtraData.secondary_amount )
			end
			for i = 1, ExtraData.secondary_amount, 1 do
				local angle = start_angle + i * interval_angle + 45
				local new_direction = RotateVector2D(direction,angle,true)
				local velocity = new_direction * ExtraData.speed
				-- Launch projectile
				local projectile =
					{
						Ability				= self,
						EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
						vSpawnOrigin		= location, -- if it is too static change this to target:GetAbsOrigin()
						fDistance			= ExtraData.distance/2,
						fStartRadius		= ExtraData.radius,
						fEndRadius			= ExtraData.radius,
						Source				= caster,
						bHasFrontalCone		= false,
						bReplaceExisting	= false,
						iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime 		= GameRules:GetGameTime() + 5.0,
						bDeleteOnHit		= false,
						vVelocity			= Vector(velocity.x,velocity.y,0),
						bProvidesVision		= false,
						ExtraData			= {index = ExtraData.index, damage = ExtraData.damage, secondary_damage = ExtraData.damage/2, spread_angle = ExtraData.spread_angle, secondary_amount = ExtraData.secondary_amount, distance = ExtraData.distance, polarize_duration = ExtraData.polarize_duration,  magnetize_duration = ExtraData.magnetize_duration, speed = ExtraData.speed, direction_x = new_direction.x, direction_y = new_direction.y, radius = ExtraData.radius, magnetize_shockwave = 0, talent = 0}
					}
				ProjectileManager:CreateLinearProjectile(projectile)
			end
			-- Emit Hit-sound
			EmitSoundOnLocationWithCaster(location, "Hero_Magnataur.ShockWave.Target", caster)
		end
	end
end

function imba_magnataur_shockwave:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()

		-- #7 Talent: If the shockwave is generated from ubercharge, just damage and apply the modifier.
		if ExtraData.ubercharge == 1 then
			-- Apply secondary damage
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = DAMAGE_TYPE_MAGICAL})
			target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
		else

			-- Determines if this is a Shockwave spawned from Magnetize
			if ExtraData.magnetize_shockwave == 1 then

				-- If the target is the one releasing magnetize, do nothing
				if target:HasModifier("modifier_imba_magnetize_debuff_immune") then
				else
					-- Apply damage
					ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
					-- Apply Polarize only
					target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
				end

			else

				local was_hit = false
				for _,hit_target in pairs(self[ExtraData.index]) do
					if hit_target == target then
						was_hit = true
					end
				end

				if was_hit then
					-- Apply secondary damage
					ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.secondary_damage, damage_type = self:GetAbilityDamageType()})
					target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
					-- Get if the target already has Magnetize debuff
					local modifier_magnetize = target:FindModifierByName("modifier_imba_magnetize_debuff")
					local magnetize_debuff = nil
					-- If the debuff is present, apply the don't apply the Magnetize debuff
					if modifier_magnetize then
						magnetize_debuff = target:AddNewModifier(caster, self, "modifier_imba_magnetize_debuff_stack", {duration = modifier_magnetize:GetRemainingTime()})
					else
						magnetize_debuff = target:AddNewModifier(caster, self, "modifier_imba_magnetize_debuff_stack", {duration = ExtraData.magnetize_duration})
					end
					if magnetize_debuff then
						magnetize_debuff.damage = ExtraData.damage/4
						magnetize_debuff.distance = ExtraData.distance
						magnetize_debuff.polarize_duration = ExtraData.polarize_duration
						magnetize_debuff.magnetize_duration = ExtraData.magnetize_duration
						magnetize_debuff.speed = ExtraData.speed
						magnetize_debuff.radius = ExtraData.radius
					end
					-- #5 Talent: Shockwave roots the target for 1 second, 0.5 seconds for secondary Shockwaves
					if caster:HasTalent("special_bonus_imba_magnataur_5") then
						target:AddNewModifier(caster, self, "modifier_imba_shockwave_root", {duration = caster:FindTalentValue("special_bonus_imba_magnataur_5","secondary_duration")})
					end
				else
					-- Apply full damage
					ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})

					-- Add it into the unique hittable
					table.insert(self[ExtraData.index], target)

					-- Split the Shockwave if target has been Polarized and is a hero
					if (self[ExtraData.index .. "_counter"] > 0) and target:HasModifier("modifier_imba_polarize_debuff") and target:IsRealHero() then

						-- Reduce the amount of occurances
						self[ExtraData.index .. "_counter"] = self[ExtraData.index .. "_counter"] - 1

						local start_angle
						local interval_angle = 0
						local direction = Vector(ExtraData.direction_x,ExtraData.direction_y,0)
						if ExtraData.secondary_amount == 1 then
							start_angle = 0
						else
							start_angle = ExtraData.spread_angle * (-1)
							interval_angle = (ExtraData.spread_angle * 2 / ExtraData.secondary_amount )
						end
						for i = 1, ExtraData.secondary_amount, 1 do
							local angle = start_angle + i * interval_angle + 45
							local new_direction = RotateVector2D(direction,angle,true)
							local velocity = new_direction * ExtraData.speed
							-- Launch projectile
							local projectile =
								{
									Ability				= self,
									EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
									vSpawnOrigin		= location, -- if it is too static change this to target:GetAbsOrigin()
									fDistance			= ExtraData.distance/2,
									fStartRadius		= ExtraData.radius,
									fEndRadius			= ExtraData.radius,
									Source				= caster,
									bHasFrontalCone		= false,
									bReplaceExisting	= false,
									iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
									iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									fExpireTime 		= GameRules:GetGameTime() + 5.0,
									bDeleteOnHit		= false,
									vVelocity			= Vector(velocity.x,velocity.y,0),
									bProvidesVision		= false,
									ExtraData			= {index = ExtraData.index, damage = ExtraData.damage, secondary_damage = ExtraData.damage/2, spread_angle = ExtraData.spread_angle, secondary_amount = ExtraData.secondary_amount, distance = ExtraData.distance, polarize_duration = ExtraData.polarize_duration,  magnetize_duration = ExtraData.magnetize_duration, speed = ExtraData.speed, direction_x = new_direction.x, direction_y = new_direction.y, radius = ExtraData.radius, magnetize_shockwave = 0, talent = 0}
								}
							ProjectileManager:CreateLinearProjectile(projectile)
						end
					end
					-- Apply Polarize & Magnetize
					target:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = ExtraData.polarize_duration})
					-- Get if the target already has Magnetize debuff
					local modifier_magnetize = target:FindModifierByName("modifier_imba_magnetize_debuff_stack")
					local magnetize_debuff
					-- If the debuff is present, apply the don't apply the Magnetize debuff
					if modifier_magnetize then
						magnetize_debuff = target:AddNewModifier(caster, self, "modifier_imba_magnetize_debuff_stack", {duration = modifier_magnetize:GetRemainingTime()})
					else
						magnetize_debuff = target:AddNewModifier(caster, self, "modifier_imba_magnetize_debuff_stack", {duration = ExtraData.magnetize_duration})
					end
					if magnetize_debuff then
						magnetize_debuff.damage = ExtraData.damage/4
						magnetize_debuff.distance = ExtraData.distance
						magnetize_debuff.polarize_duration = ExtraData.polarize_duration
						magnetize_debuff.magnetize_duration = ExtraData.magnetize_duration
						magnetize_debuff.speed = ExtraData.speed
						magnetize_debuff.radius = ExtraData.radius
					end
					-- #5 Talent: Shockwave roots the target for 1 second, 0.5 seconds for secondary Shockwaves
					if caster:HasTalent("special_bonus_imba_magnataur_5") then
						target:AddNewModifier(caster, self, "modifier_imba_shockwave_root", {duration = caster:FindTalentValue("special_bonus_imba_magnataur_5")})
					end
				end
			end
			-- Emit Hit-sound
			target:EmitSound("Hero_Magnataur.ShockWave.Target")
		end
	end
end

function imba_magnataur_shockwave:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

modifier_imba_shockwave_root = class({})

function modifier_imba_shockwave_root:IsHidden() return false end
function modifier_imba_shockwave_root:IsPurgable() return true end
function modifier_imba_shockwave_root:IsDebuff() return true end

function modifier_imba_shockwave_root:CheckState()
	local state = {[MODIFIER_STATE_ROOTED] = true}
	return state
end

function modifier_imba_shockwave_root:GetEffectName()
	return "particles/hero/magnataur/skewer_entangle_debuff.vpcf"
end

function modifier_imba_shockwave_root:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-------------------------------------------
--				EMPOWER
-------------------------------------------

imba_magnataur_empower = imba_magnataur_empower or class({})
LinkLuaModifier("modifier_imba_empower_aura", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower_particle", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_supercharged", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower_linger", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_empower_polarizer", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ubercharged", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ubercharged_indicator", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_empower:GetAbilityTextureName()
	return "magnataur_empower"
end

function imba_magnataur_empower:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Magnataur.Empower.Cast")
	return true
end

function imba_magnataur_empower:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- #8 Talent: Applying Empower on an already Supercharged target makes it Ubercharged
		if caster:HasTalent("special_bonus_imba_magnataur_8") and target:HasModifier("modifier_imba_supercharged") then
			Timers:CreateTimer(FrameTime(), function()
				local shockwave_ability = caster:FindAbilityByName("imba_magnataur_shockwave")
				if shockwave_ability then
					target:AddNewModifier(caster, shockwave_ability, "modifier_imba_ubercharged", { duration = caster:FindTalentValue("special_bonus_imba_magnataur_8")})
				end
			end)
		end

		-- Params
		local empower_duration = self:GetSpecialValueFor("empower_duration")
		local supercharge_duration = self:GetSpecialValueFor("supercharge_duration")
		if target:HasModifier("modifier_imba_empower") then
			target:AddNewModifier(caster, self, "modifier_imba_supercharged", { duration = supercharge_duration})
		end
		target:AddNewModifier(caster, self, "modifier_imba_empower", { duration = empower_duration})

		if not caster:EmitCasterSound("npc_dota_hero_magnataur",{
			"magnataur_magn_empower_01",
			"magnataur_magn_empower_03",
			"magnataur_magn_empower_04",
			"magnataur_magn_empower_05"}, 25, DOTA_CAST_SOUND_FLAG_NONE, 10, "empower") then
			caster:EmitCasterSound("npc_dota_hero_magnataur",{
				"magnataur_magn_empower_02"}, 15, DOTA_CAST_SOUND_FLAG_NONE, 10, "empower")
		end
	end
end

function imba_magnataur_empower:GetIntrinsicModifierName()
	return "modifier_imba_empower_aura"
end

function imba_magnataur_empower:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_empower:IsStealable()
	return true
end

-- Scepter Aura & self-sustain
modifier_imba_empower_aura = modifier_imba_empower_aura or class({})

function modifier_imba_empower_aura:GetAuraEntityReject(target)
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()

		-- Illusion handling
		if (parent:GetUnitName() == target:GetUnitName()) and target ~= parent then
			return true
		end

		-- Active only on Scepter
		if parent:HasScepter() then
			if not self.particle then
				self.particle = ParticleManager:CreateParticle("particles/auras/aura_empower.vpcf", PATTACH_POINT_FOLLOW, parent)
				self:AddParticle(self.particle,false,false,-1,false,false)
			end
			if target:IsRealHero() then
				return false
			end
		else
			if self.particle then
				ParticleManager:DestroyParticle(self.particle, false)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self.particle = nil
			end
		end

		-- Always on caster
		if target == parent then
			if not parent:HasModifier("modifier_imba_empower_polarizer") then
				parent:AddNewModifier(parent,ability,"modifier_imba_empower_polarizer",{})
			end
			return false
		end

		return true
	end
end

function modifier_imba_empower_aura:GetAuraRadius()
	if self:GetCaster():IsRealHero() then
		return self:GetAbility():GetSpecialValueFor("radius_scepter")
	end
	return 0
end

function modifier_imba_empower_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_empower_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_empower_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_imba_empower_aura:GetModifierAura()
	return "modifier_imba_empower"
end

function modifier_imba_empower_aura:IsAura()
	return true
end

function modifier_imba_empower_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_empower_aura:IsHidden()
	return true
end

modifier_imba_empower = modifier_imba_empower or class({})

function modifier_imba_empower:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_EVENT_ON_ATTACK_LANDED,
			MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
		}
	return decFuncs
end

function modifier_imba_empower:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():IsRealHero() then
		return self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
	end
	return 0
end

function modifier_imba_empower:OnAttackLanded( params )
	local ability = self:GetAbility()
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		if params.attacker == parent and ( not parent:IsIllusion() ) then
			local cleave_particle = "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf"
			local splash_particle = "particles/hero/magnataur/magnataur_empower_splash.vpcf"
			if parent:HasModifier("modifier_imba_supercharged") then
				cleave_particle = "particles/hero/magnataur/magnataur_empower_cleave_red_effect.vpcf"
				splash_particle = "particles/hero/magnataur/magnataur_empower_red_splash.vpcf"
			end
			if parent:HasModifier("modifier_imba_supercharged") and caster:HasTalent("special_bonus_imba_magnataur_3") then
				cleave_particle = "particles/hero/magnataur/magnataur_empower_cleave_red_effect_plus.vpcf"
				splash_particle = "particles/hero/magnataur/magnataur_empower_red_splash_plus.vpcf"
			end
			if params.attacker:IsRangedAttacker() then
				-- Ranged-Attacker
				local cleave_damage_ranged = ability:GetSpecialValueFor("cleave_damage_ranged") / 100
				local splash_radius = ability:GetSpecialValueFor("splash_radius")

				-- Set the splash radius to supercharged values if the attacker is supercharged
				if parent:HasModifier("modifier_imba_supercharged") then
					splash_radius = ability:GetSpecialValueFor("super_splash_radius")
				end

				-- Find enemies to damage
				local enemies = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, splash_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

				-- Deal damage
				for _,enemy in pairs(enemies) do
					if enemy ~= params.target and not enemy:IsAttackImmune() then
						ApplyDamage({attacker = params.attacker, victim = enemy, ability = ability, damage = (params.damage * cleave_damage_ranged), damage_type = DAMAGE_TYPE_PURE})
					end
				end

				local cleave_pfx = ParticleManager:CreateParticle(splash_particle, PATTACH_ABSORIGIN, params.target)
				ParticleManager:SetParticleControl(cleave_pfx, 0, params.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(cleave_pfx, 1, Vector(splash_radius, 0, 0))
				ParticleManager:ReleaseParticleIndex(cleave_pfx)
			else
				-- Melee-Attacker
				local cleave_damage_pct = ability:GetSpecialValueFor("cleave_damage_pct") / 100
				local cleave_radius_start = ability:GetSpecialValueFor("cleave_radius_start")
				local cleave_radius_end = ability:GetSpecialValueFor("cleave_radius_end")
				local cleave_distance = ability:GetSpecialValueFor("cleave_distance")

				-- Set the cleave properties to supercharged values if the attacker is supercharged
				if parent:HasModifier("modifier_imba_supercharged") then
					cleave_radius_start = ability:GetSpecialValueFor("super_cleave_start")
					cleave_radius_end = ability:GetSpecialValueFor("super_cleave_end")
					cleave_distance = ability:GetSpecialValueFor("super_cleave_distance")
				end

				-- #6 Talent: Empower grants melee targets 360 degree cleave radius
				if caster:HasTalent("special_bonus_imba_magnataur_6") then
					local cleave_splash_particle = "particles/hero/magnataur/magnataur_empower_cleave_splash_effect.vpcf"

					if parent:HasModifier("modifier_imba_supercharged") then
						cleave_splash_particle = "particles/hero/magnataur/magnataur_empower_cleave_splash_red_effect.vpcf"
					end

					-- #3 Talent: Supercharge grants the target's 30% main attribute as bonus damage, change particle effects
					if parent:HasModifier("modifier_imba_supercharged") and caster:HasTalent("special_bonus_imba_magnataur_3") then
						cleave_splash_particle = "particles/hero/magnataur/magnataur_empower_cleave_splash_red_effect_plus.vpcf"
					end

					-- Find enemies to damage
					local enemies = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.target:GetAbsOrigin(), nil, cleave_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

					-- Deal damage
					for _,enemy in pairs(enemies) do
						if enemy ~= params.target and not enemy:IsAttackImmune() then
							ApplyDamage({attacker = params.attacker, victim = enemy, ability = ability, damage = (params.damage * cleave_damage_pct), damage_type = DAMAGE_TYPE_PURE})
						end
					end

					local cleave_splash_pfx = ParticleManager:CreateParticle(cleave_splash_particle, PATTACH_ABSORIGIN, params.target)
					ParticleManager:SetParticleControl(cleave_splash_pfx, 0, params.target:GetAbsOrigin())
					ParticleManager:SetParticleControl(cleave_splash_pfx, 1, Vector(cleave_distance, 0, 0))
					ParticleManager:ReleaseParticleIndex(cleave_splash_pfx)
				else
					DoCleaveAttack( params.attacker, params.target, ability, (params.damage * cleave_damage_pct), cleave_radius_start, cleave_radius_end, cleave_distance, cleave_particle )
				end
			end
			local empower_duration = ability:GetSpecialValueFor("empower_duration")
		end
	end
end

function modifier_imba_empower:IsDebuff()
	return false
end

function modifier_imba_empower:IsPurgable()
	return true
end

function modifier_imba_empower:IsHidden()
	return false
end

function modifier_imba_empower:OnCreated( params )
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_particle", {})
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_polarizer", {})
		if caster ~= parent then
			self.interval = 0.1
			if params.isProvidedByAura then
				self.remaining_duration = 0
			else
				self.remaining_duration = params.duration
			end
			self:StartIntervalThink(self.interval)
		end
		if not params.was_refreshed then
			parent:EmitSound("Hero_Magnataur.Empower.Target")
		end
	end
end

function modifier_imba_empower:OnRefresh( params )
	if IsServer() then
		local parent = self:GetParent()
		local caster = self:GetCaster()
		parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_particle", {})
		if caster ~= parent then
			self.remaining_duration = params.duration
			parent:RemoveModifierByName("modifier_imba_empower_linger")
		end
		parent:EmitSound("Hero_Magnataur.Empower.Target")
	end
end

function modifier_imba_empower:OnDestroy( )
	if IsServer() then
		if self:GetCaster() ~= self:GetParent() then
			if self:GetDuration() == 0.5 then
				local parent = self:GetParent()
				local ability = self:GetAbility()
				local linger_duration = ability:GetSpecialValueFor("linger_duration")
				if parent:HasModifier("modifier_imba_empower_linger") then
					local linger_remaining = parent:FindModifierByName("modifier_imba_empower_linger"):GetRemainingTime()
					if linger_duration < linger_remaining then
						linger_duration = linger_remaining
					end
					parent:RemoveModifierByName("modifier_imba_empower_linger")
				end
				self.was_refreshed = true
				parent:AddNewModifier(self:GetCaster(), ability, "modifier_imba_empower", { duration = linger_duration, was_refreshed = true})
			end
		end
	end
end

function modifier_imba_empower:OnIntervalThink( )
	if IsServer() then
		-- Check if target now receives this buff via aura. Aura = 0.5 sec duration
		-- Reminder: GetDuration = maximum duration, not remaining time
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		if self:GetDuration() == 0.5 then
			if not parent:HasModifier("modifier_imba_empower_linger") then
				parent:AddNewModifier(caster, ability, "modifier_imba_empower_linger", { duration = self.remaining_duration})
			end
		else
			self.remaining_duration = self.remaining_duration - self.interval
		end
		if not (parent:HasModifier("modifier_imba_empower_particle") or parent:HasModifier("modifier_imba_supercharged")) then
			parent:AddNewModifier(caster, ability, "modifier_imba_empower_particle", {})
		end
		if not parent:HasModifier("modifier_imba_empower_polarizer") then
			parent:AddNewModifier(caster, self:GetAbility(), "modifier_imba_empower_polarizer", {})
		end
	end
end

modifier_imba_empower_particle = modifier_imba_empower_particle or class({})

function modifier_imba_empower_particle:IsHidden()
	return true
end

function modifier_imba_empower_particle:OnCreated( )
	local parent = self:GetParent()
	if parent:HasModifier("modifier_imba_supercharged") or not parent:HasModifier("modifier_imba_empower") then
		self:Destroy()
		return
	end
	if not self.particle then
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_empower.vpcf", PATTACH_POINT_FOLLOW, parent)
		self:AddParticle(self.particle,false,false,-1,false,false)
		self:StartIntervalThink(0.2)
	end
end

function modifier_imba_empower_particle:OnIntervalThink( )
	self:OnCreated()
end

function modifier_imba_empower_particle:OnRefresh()
	self:OnCreated()
end

function modifier_imba_empower_particle:IsPurgable()
	return true
end

modifier_imba_empower_linger = modifier_imba_empower_linger or class({})

function modifier_imba_empower_linger:IsDebuff()
	return false
end

function modifier_imba_empower_linger:IsHidden()
	return true
end

function modifier_imba_empower_linger:IsPurgable()
	return true
end

modifier_imba_empower_polarizer = modifier_imba_empower_polarizer or class({})

function modifier_imba_empower_polarizer:IsDebuff()
	return false
end

function modifier_imba_empower_polarizer:IsHidden()
	return true
end

function modifier_imba_empower_polarizer:IsPurgable()
	return true
end

function modifier_imba_empower_polarizer:OnCreated()
	if IsServer() then
		-- Find enemies to polarize
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()

		self.search_radius = self.ability:GetSpecialValueFor("search_radius")

		local empower_search = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local refresh_interval = self.ability:GetSpecialValueFor("refresh_interval")

		for _,enemy in pairs (empower_search) do
			local polarize_debuff = enemy:FindModifierByName("modifier_imba_polarize_debuff")
			if (not (polarize_debuff and polarize_debuff:GetDuration() > self.ability:GetSpecialValueFor("polarize_duration"))) then
				enemy:AddNewModifier(self.caster, nil, "modifier_imba_polarize_debuff", {duration = self.ability:GetSpecialValueFor("polarize_duration")})
			end
		end

		self:StartIntervalThink(refresh_interval)
	end
end

function modifier_imba_empower_polarizer:OnIntervalThink()
	if IsServer() then
		if (not (self.parent:HasModifier("modifier_imba_empower") or self.parent:HasModifier("modifier_imba_empower_aura"))) then
			self:Destroy()
			return
		end
		-- Find enemies to polarize
		local empower_search = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local refresh_interval = self.ability:GetSpecialValueFor("refresh_interval")

		for _,enemy in pairs (empower_search) do
			local polarize_debuff = enemy:FindModifierByName("modifier_imba_polarize_debuff")
			if (not (polarize_debuff and polarize_debuff:GetDuration() > self.ability:GetSpecialValueFor("polarize_duration"))) then
				enemy:AddNewModifier(self.caster, nil, "modifier_imba_polarize_debuff", {duration = self.ability:GetSpecialValueFor("polarize_duration")})
			end
		end
	end
end

modifier_imba_supercharged = modifier_imba_supercharged or class({})

function modifier_imba_supercharged:OnCreated( params )
	if IsServer() then
		local particle = ParticleManager:CreateParticle("particles/hero/magnataur/magnataur_empower_red.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(particle,false,false,-1,false,false)
	end
end

function modifier_imba_supercharged:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_imba_empower") then
			parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_empower_particle", {})
		end
	end
end

function modifier_imba_supercharged:IsDebuff()
	return false
end

function modifier_imba_supercharged:IsHidden()
	return false
end

function modifier_imba_supercharged:GetEffectName()
	if self:GetParent():HasModifier("modifier_imba_ubercharged") then
		return nil
	else
		return "particles/hero/magnataur/magnataur_supercharge.vpcf"
	end
end

function modifier_imba_supercharged:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_supercharged:GetTexture()
	return "custom/magnus_supercharge"
end

function modifier_imba_supercharged:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		}
	return decFuncs
end

function modifier_imba_supercharged:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("supercharge_as")
end

function modifier_imba_supercharged:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("supercharge_ms")
end

-- #3 Talent: Supercharge grants the target's 30% main attribute as bonus damage
function modifier_imba_supercharged:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster():HasTalent("special_bonus_imba_magnataur_3") then
		local bonus_damage = self:GetParent():GetPrimaryStatValue() * self:GetCaster():FindTalentValue("special_bonus_imba_magnataur_3") * 0.01
		return bonus_damage
	end
	return 0
end


modifier_imba_ubercharged = modifier_imba_ubercharged or class({})

function modifier_imba_ubercharged:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_imba_ubercharged:OnCreated()
	if IsServer() then
		if not self:GetParent():HasModifier("modifier_imba_ubercharged_indicator") then
			local modifier_indicator = self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_imba_ubercharged_indicator",{})
			if modifier_indicator then
				modifier_indicator:SetStackCount(1)
			end
		end
	end
end

function modifier_imba_ubercharged:OnAttackLanded(params)
	if IsServer() then
		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()

		local ubercharge_indicator = parent:FindModifierByName("modifier_imba_ubercharged_indicator")
		if parent == params.attacker and ubercharge_indicator:GetStackCount() >= 1 then

			-- Declaring the table to a different function
			self:CreateShockwave(parent, params.target, caster, ability)

			ubercharge_indicator:SetStackCount(0)
		end
	end
end

function modifier_imba_ubercharged:CreateShockwave(parent, target, caster, ability)
	if ability:GetLevel() > 0 then
		-- Parameters
		self.parent_loc = parent:GetAbsOrigin()
		self.direction = (target:GetAbsOrigin() - self.parent_loc):Normalized()
		self.damage = ability:GetSpecialValueFor("damage")/2
		self.radius = ability:GetSpecialValueFor("radius")
		self.distance = ability:GetCastRange(self.parent_loc,caster) + GetCastRangeIncrease(caster)
		self.speed = ability:GetSpecialValueFor("speed")
		self.polarize_duration = ability:GetSpecialValueFor("polarize_duration")

		-- Launch projectile
		local shockwave_projectile =
			{
				Ability				= ability,
				EffectName			= "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
				vSpawnOrigin		= self.parent_loc,
				fDistance			= self.distance,
				fStartRadius		= self.radius,
				fEndRadius			= self.radius,
				Source				= caster,
				bHasFrontalCone		= false,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 5.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(self.direction.x,self.direction.y,0) * self.speed,
				bProvidesVision		= false,
				ExtraData			= {damage = self.damage, distance = self.distance, polarize_duration = self.polarize_duration, speed = self.speed, radius = self.radius, ubercharge = 1}
			}
		ProjectileManager:CreateLinearProjectile(shockwave_projectile)

		-- Play cast sound
		EmitSoundOnLocationWithCaster(self.parent_loc, "Hero_Magnataur.ShockWave.Particle", parent)
	end
end

function modifier_imba_ubercharged:OnDestroy()
	if IsServer() then
		if self:GetParent():HasModifier("modifier_imba_ubercharged_indicator") then
			self:GetParent():RemoveModifierByName("modifier_imba_ubercharged_indicator")
		end
	end
end

function modifier_imba_ubercharged:IsDebuff()
	return false
end

function modifier_imba_ubercharged:IsHidden()
	return false
end

function modifier_imba_ubercharged:IsPurgable()
	return true
end

function modifier_imba_ubercharged:GetEffectName()
	return "particles/hero/magnataur/magnataur_ubercharge.vpcf"
end

function modifier_imba_ubercharged:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ubercharged:GetTexture()
	return "custom/magnus_ubercharge"
end

modifier_imba_ubercharged_indicator = modifier_imba_ubercharged_indicator or class({})

function modifier_imba_ubercharged_indicator:IsDebuff()
	return false
end

function modifier_imba_ubercharged_indicator:IsHidden()
	return false
end

function modifier_imba_ubercharged_indicator:IsPurgable()
	return true
end

function modifier_imba_ubercharged_indicator:GetTexture()
	return "custom/magnus_ubercharge"
end

function modifier_imba_ubercharged_indicator:DestroyOnExpire()
	return false
end

function modifier_imba_ubercharged_indicator:OnCreated()
	if IsServer() then
		self.stacking_up = 0
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_ubercharged_indicator:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()

		-- Stack up for ubercharge to refresh itself
		if self:GetStackCount() < 1 then
			if self.stacking_up < 1 then
				self:SetDuration(caster:FindTalentValue("special_bonus_imba_magnataur_8","refresh_interval"),true)
			end
			self.stacking_up = self.stacking_up + 1
		end
		if self.stacking_up >= 10 and self:GetStackCount() < 1 then
			self:SetDuration(-1,true)
			self.stacking_up = 0
			self:SetStackCount(1)
		end
	end
end

-------------------------------------------
--				SKEWER
-------------------------------------------

imba_magnataur_skewer = imba_magnataur_skewer or class({})
LinkLuaModifier("modifier_imba_skewer_motion_controller", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skewer_motion_controller_target", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skewer_slow", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_skewer_entangle", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_skewer:GetAbilityTextureName()
	return "magnataur_skewer"
end

function imba_magnataur_skewer:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	if self.begged_for_pardon then return false end
	return true
end

function imba_magnataur_skewer:CastFilterResult()
	if IsServer() then
		self.begged_for_pardon = true
	end
end

function imba_magnataur_skewer:GetBehavior()
	if self:GetCaster():HasModifier("modifier_imba_skewer_motion_controller") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
end


function imba_magnataur_skewer:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local range = self:GetSpecialValueFor("range") + GetCastRangeIncrease(caster)
		local distance = (target_loc - caster_loc):Length2D()
		local direction = (target_loc - caster_loc):Normalized()
		local current_cooldown = self:GetCooldownTimeRemaining()
		self:EndCooldown()

		if distance > range then
			distance = range
		end

		-- Play the cast sound
		caster:EmitSound("Hero_Magnataur.Skewer.Cast")

		if not caster:EmitCasterSound("npc_dota_hero_magnataur",{
			"magnataur_magn_skewer_01",
			"magnataur_magn_skewer_02",
			"magnataur_magn_skewer_03",
			"magnataur_magn_skewer_07",
			"magnataur_magn_skewer_09",
			"magnataur_magn_skewer_12",
			"magnataur_magn_skewer_13",
			"magnataur_magn_skewer_14"}, 25, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, 3, "Skewer") then
			caster:EmitCasterSound("npc_dota_hero_magnataur",{
				"magnataur_magn_lasthit_09"}, 20, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, 3, "Skewer")
		end

		-- Add Motion-Controller-Modifier
		caster:AddNewModifier(caster, self, "modifier_imba_skewer_motion_controller", {distance = distance, direction_x = direction.x, direction_y = direction.y, direction_z = direction.z, cooldown = current_cooldown, cast_sound = cast_sound})

		-- #4 Talent: Skewer creates a mini Reverse Polarity on casting, playing the Reverse Polarity particle
		if caster:HasTalent("special_bonus_imba_magnataur_4") then
			local radius = caster:FindTalentValue("special_bonus_imba_magnataur_4")

			caster:EmitSound("Hero_Magnataur.ReversePolarity.Cast")

			local animation_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(animation_pfx, 0, caster, PATTACH_POINT_FOLLOW, nil, (caster_loc + direction * 100), true)
			ParticleManager:SetParticleControl(animation_pfx, 1, Vector(radius, 0, 0))
			ParticleManager:SetParticleControl(animation_pfx, 2, Vector(self:GetCastPoint(), 0, 0))
			ParticleManager:SetParticleControl(animation_pfx, 3, caster:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(animation_pfx)
		end
	end
end

function imba_magnataur_skewer:GetCastAnimation()
	return ACT_DOTA_MAGNUS_SKEWER_START
end

function imba_magnataur_skewer:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_skewer:IsStealable()
	return true
end

function imba_magnataur_skewer:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_skewer_motion_controller") then
		return "custom/magnataur_beg_my_pardon"
	else
		return "magnataur_skewer"
	end
end

function imba_magnataur_skewer:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end

modifier_imba_skewer_motion_controller = modifier_imba_skewer_motion_controller or class({})

function modifier_imba_skewer_motion_controller:OnCreated( params )
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local caster_loc = caster:GetAbsOrigin()

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

		-- Parameters
		self.speed = ability:GetSpecialValueFor("speed") * FrameTime()
		self.skewer_radius = ability:GetSpecialValueFor("skewer_radius")
		self.tree_radius = ability:GetSpecialValueFor("tree_radius")
		self.slow_duration = ability:GetSpecialValueFor("slow_duration")
		self.horned_distance = ability:GetSpecialValueFor("horned_distance")
		self.pardon_min_range = ability:GetSpecialValueFor("pardon_min_range")
		self.damage = ability:GetSpecialValueFor("damage")
		self.pardon_extra_dmg = ability:GetSpecialValueFor("pardon_extra_dmg")
		self.entangle_dur = ability:GetSpecialValueFor("entangle_dur")
		self.distance = params.distance
		self.cast_sound = params.cast_sound
		self.direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self.traveled = 0
		self.final = false
		self.cooldown = params.cooldown

		self.skewer_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.skewer_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.skewer_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_horn", caster:GetAbsOrigin(), true)

		-- #4 Talent: Skewer creates a mini Reverse Polarity on casting, pulling in enemies within 375 radius
		if caster:HasTalent("special_bonus_imba_magnataur_4") then
			local radius = caster:FindTalentValue("special_bonus_imba_magnataur_4")
			local pulled_loc = caster_loc + self.direction * 100

			local enemies = FindUnitsInRadius(caster:GetTeam(), pulled_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)

			for _,enemy in ipairs(enemies) do
				-- Play the drag particle
				local pull_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pull_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(pull_pfx, 1, pulled_loc)
				ParticleManager:ReleaseParticleIndex(pull_pfx)

				enemy:InterruptMotionControllers(true)
				enemy:StopCustomMotionControllers()
				enemy:SetAbsOrigin(pulled_loc)
				FindClearSpaceForUnit(enemy, pulled_loc, true)
				enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = 0.1})
				enemy:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
			end
		end
		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_imba_skewer_motion_controller:OnIntervalThink()
	if IsServer() then
		-- Check motion controllers
		if not self:CheckMotionControllers() then
			self:Destroy()
			return nil
		end

		-- Horizontal Motion
		self:HorizontalMotion(self:GetParent(), self.frametime)
	end
end

function modifier_imba_skewer_motion_controller:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		self:GetAbility():StartCooldown(self.cooldown)

		ParticleManager:DestroyParticle(self.skewer_fx, false)
		ParticleManager:ReleaseParticleIndex(self.skewer_fx)
		GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), (self.tree_radius + 100), false)
	end
end

function modifier_imba_skewer_motion_controller:IsHidden()
	return true
end

function modifier_imba_skewer_motion_controller:IgnoreTenacity()
	return true
end

function modifier_imba_skewer_motion_controller:IsMotionController()
	return true
end

function modifier_imba_skewer_motion_controller:IsPurgable()
	return false
end

function modifier_imba_skewer_motion_controller:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_imba_skewer_motion_controller:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_imba_skewer_motion_controller:HorizontalMotion( unit, time )
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local ability = self:GetAbility()

		GridNav:DestroyTreesAroundPoint(caster_loc, self.tree_radius, false)
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, self.skewer_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _,enemy in ipairs(enemies) do
			if not enemy:HasModifier("modifier_imba_skewer_motion_controller_target") then
				local set_point = caster:GetAbsOrigin() + self.direction * self.horned_distance
				enemy:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, enemy).z))
				enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_motion_controller_target", {direction_x = self.direction.x, direction_y = self.direction.y, direction_z = self.direction.z, speed = self.speed})
			end
		end

		-- Move the caster while the distance traveled is less than the original distance upon cast
		if (self.traveled < self.distance) and caster:IsAlive() and not ability.begged_for_pardon then
			local set_point =  caster:GetAbsOrigin() + self.direction * self.speed
			caster:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, caster).z))
			-- Calculate the new travel distance
			self.traveled = self.traveled + self.speed

			-- if the next 3 frames are the end, start final animation
			if ((self.traveled + (3 * self.speed)) > self.distance) and not self.final then
				caster:FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
				caster:StartGesture(ACT_DOTA_MAGNUS_SKEWER_END)
				self.final = true
			end
		else
			-- Remove the motion controller once the distance has been traveled
			if not self.final then
				caster:FadeGesture( ACT_DOTA_CAST_ABILITY_3 )
				caster:StartGesture( ACT_DOTA_MAGNUS_SKEWER_END )
			end

			local responses = {"magnataur_magn_skewer_04","magnataur_magn_skewer_05","magnataur_magn_skewer_06","magnataur_magn_skewer_08","magnataur_magn_skewer_10","magnataur_magn_skewer_11"}
			caster:EmitCasterSound("npc_dota_hero_magnataur",responses, 25, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, 2, "Skewer")

			self:EndSkewer()
		end
	end
end

function modifier_imba_skewer_motion_controller:EndSkewer()
	if IsServer() then
		if self.skewer_finished then
			return nil
		end

		self.skewer_finished = true

		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local caster_loc = caster:GetAbsOrigin()
		local piked_enemies = {}
		piked_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.skewer_radius * 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		local polarize_counter = 0

		-- Check if polarized targets shall be entangled
		for _,enemy in ipairs(piked_enemies) do
			if enemy:HasModifier("modifier_imba_polarize_debuff") then
				polarize_counter = polarize_counter + 1
				if polarize_counter == 2 then
					break
				end
			end
		end

		for _,enemy in ipairs(piked_enemies) do
			local damage = self.damage
			if ability.begged_for_pardon then
				damage = damage + self.pardon_extra_dmg
			end
			local modifier = enemy:FindModifierByNameAndCaster("modifier_imba_skewer_motion_controller_target",caster)
			if modifier then
				if ability.begged_for_pardon and not enemy:HasModifier("modifier_imba_polarize_debuff") then
					local knockup_duration = 0.5 + (math.random() * 0.3)
					local angle = (math.random() - 0.5) * 100
					local knockback =
						{
							should_stun = 1,
							knockback_duration = knockup_duration,
							duration = knockup_duration,
							knockback_distance = self.pardon_min_range + knockup_duration * 100,
							knockback_height = 125 + (knockup_duration * 50),
							center_x = (caster_loc - (RotateVector2D(self.direction,angle, true))*1000).x ,
							center_y = (caster_loc - (RotateVector2D(self.direction,angle, true))*1000).y,
							center_z = caster_loc.z
						}
					enemy:AddNewModifier(caster, self:GetAbility(), "modifier_knockback", knockback)
					Timers:CreateTimer(knockup_duration, function()
						ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
					end)
				else
					local knockup_duration = 0
					if ability.begged_for_pardon then
						knockup_duration = 0.5
						local knockback =
							{
								should_stun = 1,
								knockback_duration = knockup_duration,
								duration = knockup_duration,
								knockback_distance = self.pardon_min_range + knockup_duration * 100,
								knockback_height = 125 + (knockup_duration * 50),
								center_x = caster_loc.x,
								center_y = caster_loc.y,
								center_z = caster_loc.z
							}
						enemy:AddNewModifier(caster, self:GetAbility(), "modifier_knockback", knockback)
					end
					Timers:CreateTimer(knockup_duration, function()
						ApplyDamage({victim = enemy, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
						if enemy:HasModifier("modifier_imba_polarize_debuff") and (polarize_counter == 2) then
							enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_entangle", {duration = self.entangle_dur})
						else
							FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
						end
					end)
				end
				enemy:AddNewModifier(caster, ability, "modifier_imba_skewer_slow", {duration = self.slow_duration, pardoned = self.begged_for_pardon})
			end
		end
		ability.begged_for_pardon = nil

		-- Find a clear space to stand on
		caster:SetUnitOnClearGround()

		-- Enough with the skewer for today.
		self:Destroy()
	end
end

modifier_imba_skewer_motion_controller_target = modifier_imba_skewer_motion_controller_target or class({})

function modifier_imba_skewer_motion_controller_target:OnCreated( params )
	if IsServer() then
		self.direction = Vector(params.direction_x, params.direction_y, params.direction_z)
		self.speed = params.speed

		self.frametime = FrameTime()
		self:StartIntervalThink(self.frametime)
	end
end

function modifier_imba_skewer_motion_controller_target:OnIntervalThink()
	-- Check for motion controllers
	if not self:CheckMotionControllers() then
		self:Destroy()
		return nil
	end

	-- Horizontal motion
	self:HorizontalMotion(self:GetParent(), self.frametime)
end

function modifier_imba_skewer_motion_controller_target:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		-- Find a clear space to stand on
		caster:SetUnitOnClearGround()
	end
end

function modifier_imba_skewer_motion_controller_target:RemoveOnDeath()
	return false
end

function modifier_imba_skewer_motion_controller_target:IgnoreTenacity()
	return true
end

function modifier_imba_skewer_motion_controller_target:IsMotionController()
	return true
end

function modifier_imba_skewer_motion_controller_target:GetMotionControllerPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function modifier_imba_skewer_motion_controller_target:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_imba_skewer_motion_controller_target:HorizontalMotion( unit, time )
	if IsServer() then
		local caster = self:GetCaster()

		-- Move the target while caster has motion-controller
		if caster:HasModifier("modifier_imba_skewer_motion_controller") and caster:IsAlive() then
			local set_point = unit:GetAbsOrigin() + self.direction * self.speed
			unit:SetAbsOrigin(Vector(set_point.x, set_point.y, GetGroundPosition(set_point, unit).z))
		else
			-- Remove the motion controller once the caster lost the motion-controller
			self:Destroy()
		end
	end
end

function modifier_imba_skewer_motion_controller_target:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

function modifier_imba_skewer_motion_controller_target:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

modifier_imba_skewer_slow = modifier_imba_skewer_slow or class({})

function modifier_imba_skewer_slow:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		}
	return decFuncs
end

function modifier_imba_skewer_slow:GetModifierMoveSpeedBonus_Percentage()
	if self.pardoned then return self:GetAbility():GetSpecialValueFor("pardon_slow") * (-1) end
	return self:GetAbility():GetSpecialValueFor("slow") * (-1)
end

function modifier_imba_skewer_slow:GetModifierAttackSpeedBonus_Constant()
	if self.pardoned then return self:GetAbility():GetSpecialValueFor("pardon_slow") * (-1) end
	return self:GetAbility():GetSpecialValueFor("slow") * (-1)
end

function modifier_imba_skewer_slow:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf"
end

function modifier_imba_skewer_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_skewer_slow:OnCreated( params )
	self.pardoned = params.pardoned
end

modifier_imba_skewer_entangle = modifier_imba_skewer_entangle or class({})

function modifier_imba_skewer_entangle:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_MOVESPEED_LIMIT
		}
	return decFuncs
end

function modifier_imba_skewer_entangle:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_imba_skewer_entangle:CheckState()
	local state =
		{
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true
		}
	return state
end

function modifier_imba_skewer_entangle:GetEffectName()
	return "particles/hero/magnataur/skewer_entangle_debuff.vpcf"
end

function modifier_imba_skewer_entangle:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_imba_skewer_entangle:OnCreated()
	if IsServer() then
		self.position = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.4)
	end
end

function modifier_imba_skewer_entangle:OnIntervalThink()
	if IsServer() then
		if (self.position - self:GetParent():GetAbsOrigin()):Length2D() > 3 then
			self:Destroy()
		end
	end
end

-------------------------------------------
--			REVERSE POLARITY
-------------------------------------------

imba_magnataur_reverse_polarity = imba_magnataur_reverse_polarity or class({})
LinkLuaModifier("modifier_imba_reverse_polarity_slow", "components/abilities/heroes/hero_magnataur", LUA_MODIFIER_MOTION_NONE)

function imba_magnataur_reverse_polarity:GetAbilityTextureName()
	return "magnataur_reverse_polarity"
end

function imba_magnataur_reverse_polarity:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		local radius = self:GetTalentSpecialValueFor("main_radius")
		local caster_loc = caster:GetAbsOrigin()

		caster:EmitSound("Hero_Magnataur.ReversePolarity.Anim")

		local animation_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(animation_pfx, 0, caster, PATTACH_POINT_FOLLOW, nil, caster_loc, true)
		ParticleManager:SetParticleControl(animation_pfx, 1, Vector(radius, 0, 0))
		ParticleManager:SetParticleControl(animation_pfx, 2, Vector(self:GetCastPoint(), 0, 0))
		ParticleManager:SetParticleControl(animation_pfx, 3, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(animation_pfx)
		return true
	end
end

function imba_magnataur_reverse_polarity:IsHiddenWhenStolen()
	return false
end

function imba_magnataur_reverse_polarity:IsStealable()
	return true
end

function imba_magnataur_reverse_polarity:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()

		-- Setting the direction where Magnus is looking at so turning during cast-point is possible
		local direction = caster:GetForwardVector()

		-- Parameters
		local damage = self:GetTalentSpecialValueFor("damage")
		local radius = self:GetTalentSpecialValueFor("main_radius")
		local hero_stun_duration = self:GetSpecialValueFor("hero_stun_duration")
		local polarize_slow_duration = hero_stun_duration -- In case this needs to be changed
		local creep_stun_duration = self:GetSpecialValueFor("creep_stun_duration")
		local pull_offset = self:GetSpecialValueFor("pull_offset")
		local pull_per_stack = self:GetTalentSpecialValueFor("pull_per_stack")
		local polarize_duration = self:GetSpecialValueFor("polarize_duration")
		local polarize_slow = self:GetSpecialValueFor("polarize_slow")
		local global_pull = self:GetSpecialValueFor("global_pull")
		local final_loc = caster_loc + (direction * pull_offset)

		-- Play cast sound
		caster:EmitSound("Hero_Magnataur.ReversePolarity.Cast")
		local responses = {"magnataur_magn_polarity_01","magnataur_magn_polarity_02","magnataur_magn_polarity_03","magnataur_magn_polarity_04","magnataur_magn_polarity_05","magnataur_magn_polarity_06","magnataur_magn_polarity_07","magnataur_magn_polarity_08","magnataur_magn_polarity_09","magnataur_magn_polarity_10"}
		caster:EmitCasterSound("npc_dota_hero_magnataur",responses, 25, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil, nil)

		local creeps = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, radius, self:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,creep in ipairs(creeps) do
			creep:SetAbsOrigin(final_loc)
			FindClearSpaceForUnit(creep, final_loc, true)
			creep:AddNewModifier(caster, self, "modifier_stunned", {duration = creep_stun_duration})
			ApplyDamage({victim = creep, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
			creep:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
		end

		-- Finding all heroes on the map
		local enemies = FindUnitsInRadius(caster:GetTeam(), caster_loc, nil, FIND_UNITS_EVERYWHERE, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			local particle_loc = final_loc
			local enemy_pos = enemy:GetAbsOrigin()
			local current_distance = ( caster_loc - enemy_pos ):Length2D()
			local pull_distance = radius
			local point_direction = (final_loc - enemy_pos):Normalized()
			local pull_pfx

			-- Increase pull-radius if the target has Polarize-stacks
			if enemy:HasModifier("modifier_imba_polarize_debuff") then
				pull_distance = pull_distance + (enemy:FindModifierByName("modifier_imba_polarize_debuff"):GetStackCount() * pull_per_stack)
				pull_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControl(pull_pfx, 0, enemy:GetAbsOrigin())

				-- #2 Talent: All Polarized enemy pulled towards Magnus that did not end up in the stun area are slowed
				if caster:HasTalent("special_bonus_imba_magnataur_2") and pull_distance > radius then
					enemy:AddNewModifier(caster, self, "modifier_imba_reverse_polarity_slow", {duration = caster:FindTalentValue("special_bonus_imba_magnataur_2")})
				end
			else
				pull_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_reverse_polarity_pull.vpcf", PATTACH_CUSTOMORIGIN, caster)
				ParticleManager:SetParticleControl(pull_pfx, 0, enemy:GetAbsOrigin())
			end

			-- Check if the target will be pulled into the main-radius, else check for slow, else global pull
			if pull_distance >= current_distance then
				-- Play pull particle
				enemy:InterruptMotionControllers(true)
				enemy:StopCustomMotionControllers()
				enemy:SetAbsOrigin(final_loc)
				FindClearSpaceForUnit(enemy, final_loc, true)
				enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = hero_stun_duration})
				enemy:AddNewModifier(caster, nil, "modifier_imba_polarize_debuff_stack", {duration = polarize_duration})
				ApplyDamage({victim = enemy, attacker = caster, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
				enemy:EmitSound("Hero_Magnataur.ReversePolarity.Stun")
			elseif pull_distance > radius then
				pull_distance = pull_distance - radius
				local knockbackProperties =
					{
						center_x = caster:GetAbsOrigin()[1]+1,
						center_y = caster:GetAbsOrigin()[2]+1,
						center_z = caster:GetAbsOrigin()[3],
						duration = FrameTime()*2,
						knockback_duration = FrameTime()*2,
						knockback_distance = -pull_distance,
						knockback_height = 0,
						should_stun = 0
					}
				-- Apply knockback on enemies hit
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockbackProperties)
				particle_loc = enemy_pos + ((final_loc - enemy_pos):Normalized() * pull_distance)
			else
				pull_distance = global_pull
				local knockbackProperties =
					{
						center_x = caster:GetAbsOrigin()[1]+1,
						center_y = caster:GetAbsOrigin()[2]+1,
						center_z = caster:GetAbsOrigin()[3],
						duration = FrameTime()*2,
						knockback_duration = FrameTime()*2,
						knockback_distance = -pull_distance,
						knockback_height = 0,
						should_stun = 0
					}
				-- Apply knockback on enemies hit
				enemy:AddNewModifier(caster, self, "modifier_knockback", knockbackProperties)
				particle_loc = enemy_pos + ((final_loc - enemy_pos):Normalized() * pull_distance)
			end

			-- If an enemy was moved to the fountain area, remove it from there
			if enemy:IsRealHero() and IsNearEnemyClass(enemy, 1700, "ent_dota_fountain") then
				local fountain_loc
				if enemy:GetTeam() == DOTA_TEAM_GOODGUYS then
					fountain_loc = Vector(7472, 6912, 512)
				else
					fountain_loc = Vector(-7456, -6938, 528)
				end
				FindClearSpaceForUnit(enemy, fountain_loc + (enemy:GetAbsOrigin() - fountain_loc):Normalized() * 1700, true)
			end

			ParticleManager:SetParticleControl(pull_pfx, 1, particle_loc)
			ParticleManager:ReleaseParticleIndex(pull_pfx)

		end
	end
end

function imba_magnataur_reverse_polarity:GetCastRange( location , target)
	return self.BaseClass.GetCastRange(self,location,target)
end

modifier_imba_reverse_polarity_slow = modifier_imba_reverse_polarity_slow or class({})

function modifier_imba_reverse_polarity_slow:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
		}
	return decFuncs
end

function modifier_imba_reverse_polarity_slow:GetModifierMoveSpeedBonus_Percentage( )
	return self:GetCaster():FindTalentValue("special_bonus_imba_magnataur_2","polarize_slow") * (-1)
end

function modifier_imba_reverse_polarity_slow:IsHidden()
	return false
end

function modifier_imba_reverse_polarity_slow:IsDebuff()
	return true
end

function modifier_imba_reverse_polarity_slow:IsPurgable()
	return true
end
