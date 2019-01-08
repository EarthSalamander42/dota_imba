-- Editors:
--     Firetoad
--     AtroCty, 23.03.2017
--     naowin, 20.05.2018

-------------------------------------------
-- 	#8 Talent - Blazing strike
-------------------------------------------

LinkLuaModifier("modifier_special_bonus_imba_lina_8", "components/abilities/heroes/hero_lina.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lina_8 = modifier_special_bonus_imba_lina_8 or class({})

function modifier_special_bonus_imba_lina_8:IsHidden() return false end
function modifier_special_bonus_imba_lina_8:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lina_8:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return decFuncs
end

function modifier_special_bonus_imba_lina_8:OnAttackLanded( params )
	if IsServer() then
		local parent = self:GetParent()
		local target = params.target
		if parent == params.attacker and target:GetTeamNumber() ~= parent:GetTeamNumber() and (target.IsCreep or target.IsHero) then
			local int = parent:GetIntellect()
			local ticks = parent:FindTalentValue("special_bonus_imba_lina_8", "ticks_amount")
			local duration = parent:FindTalentValue("special_bonus_imba_lina_8", "duration")
			local dmg_int_pct = parent:FindTalentValue("special_bonus_imba_lina_8", "dmg_int_pct")
			local dmg_per_tick = ( int * dmg_int_pct / 100) / (duration / ticks)
			local tick_duration = duration / ticks
			target:AddNewModifier(parent, nil, "modifier_imba_blazing_fire", {duration = duration, dmg_per_tick = dmg_per_tick, tick_duration = tick_duration})
		end
	end
end

LinkLuaModifier("modifier_imba_blazing_fire", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)
modifier_imba_blazing_fire = class({})

function modifier_imba_blazing_fire:OnCreated( params )
	if IsServer() then
		self.dmg_per_tick = params.dmg_per_tick
		self.counter = 10
		local parent = self:GetParent()
		self:StartIntervalThink(params.tick_duration)
		self.particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_fiery_soul.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.particle_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_fx, 1, Vector(1,0,0))
	end
end

function modifier_imba_blazing_fire:OnRefresh( params )
	if IsServer() then
		self.dmg_per_tick = params.dmg_per_tick
		self.counter = 10
	end
end

function modifier_imba_blazing_fire:OnIntervalThink( )
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = self.dmg_per_tick, damage_type = DAMAGE_TYPE_MAGICAL})
		self.counter = self.counter - 1
	end
end

function modifier_imba_blazing_fire:OnDestroy( params )
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = (self.dmg_per_tick * self.counter), damage_type = DAMAGE_TYPE_MAGICAL})
		ParticleManager:DestroyParticle(self.particle_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_fx)
	end
end

function modifier_imba_blazing_fire:IsDebuff()
	return true
end

function modifier_imba_blazing_fire:IsHidden()
	return false
end

function modifier_imba_blazing_fire:GetTexture()
	return "lina_fiery_soul"
end

-------------------------------------------
--			DRAGON SLAVE
-------------------------------------------

imba_lina_dragon_slave = class({})

function imba_lina_dragon_slave:GetAbilityTextureName()
	return "lina_dragon_slave"
end

function imba_lina_dragon_slave:OnUpgrade()
	self.cast_point = self.cast_point or self:GetCastPoint()
end

function imba_lina_dragon_slave:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local primary_damage = self:GetSpecialValueFor("primary_damage")
		local secondary_damage = self:GetSpecialValueFor("secondary_damage")
		local spread_angle = self:GetSpecialValueFor("spread_angle")
		local secondary_amount = self:GetTalentSpecialValueFor("secondary_amount")
		local speed = self:GetSpecialValueFor("speed")
		local width_initial = self:GetSpecialValueFor("width_initial")
		local width_end = self:GetSpecialValueFor("width_end")
		local primary_distance = self:GetCastRange(caster_loc,caster) + GetCastRangeIncrease(caster)
		local secondary_distance = self:GetSpecialValueFor("secondary_distance")
		local split_delay = self:GetSpecialValueFor("split_delay")
		local secondary_width_initial = self:GetSpecialValueFor("secondary_width_initial")
		local secondary_width_end = self:GetSpecialValueFor("secondary_width_end")
		local cdr_hero = self:GetSpecialValueFor("cdr_hero")
		local cdr_units = self:GetSpecialValueFor("cdr_units")

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()
		local primary_direction = (target_loc - caster_loc):Normalized()
		local split_timer = (CalculateDistance(caster_loc,target_loc) / speed)
		local velocity = direction * speed
		local primary_velocity = primary_direction * speed

		local projectile =
			{
				Ability				= self,
				EffectName			= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
				vSpawnOrigin		= caster_loc,
				fDistance			= primary_distance,
				fStartRadius		= width_initial,
				fEndRadius			= width_end,
				Source				= caster,
				bHasFrontalCone		= true,
				bReplaceExisting	= false,
				iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
				iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				fExpireTime 		= GameRules:GetGameTime() + 10.0,
				bDeleteOnHit		= false,
				vVelocity			= Vector(velocity.x,velocity.y,0),
				bProvidesVision		= false,
				ExtraData			= {damage = primary_damage, cdr_hero = cdr_hero, cdr_units = cdr_units}
			}
		ProjectileManager:CreateLinearProjectile(projectile)

		if secondary_amount == 0 then
			return true
		end

		caster:EmitSound("Hero_Lina.DragonSlave")

		Timers:CreateTimer(split_timer - 0.1, function()
			local particle_fx = ParticleManager:CreateParticle("particles/hero/lina/dragon_slave_delay.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle_fx, 0, (target_loc + Vector(0,0,50)))
			ParticleManager:SetParticleControl(particle_fx, 1, (target_loc + Vector(0,0,50)))
			ParticleManager:SetParticleControl(particle_fx, 3, (target_loc + Vector(0,0,50)))
			Timers:CreateTimer(split_delay + 0.1, function()
				ParticleManager:DestroyParticle(particle_fx, false)
				ParticleManager:ReleaseParticleIndex(particle_fx)
				local particle_fx2 = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl(particle_fx2, 0, target_loc)
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(particle_fx2, false)
					ParticleManager:ReleaseParticleIndex(particle_fx2)
				end)
			end)
		end)

		Timers:CreateTimer((split_timer + split_delay), function()
			EmitSoundOnLocationWithCaster( target_loc, "Hero_Lina.DragonSlave", caster )
			local start_angle
			local interval_angle = 0
			if secondary_amount == 1 then
				start_angle = 0
			else
				start_angle = spread_angle * (-1)
				interval_angle = spread_angle * 2 / (secondary_amount - 1)
			end
			for i = 1, secondary_amount, 1 do
				local angle = start_angle + (i-1) * interval_angle
				velocity = RotateVector2D(direction,angle,true) * speed
				local projectile =
					{
						Ability				= self,
						EffectName			= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
						vSpawnOrigin		= target_loc,
						fDistance			= secondary_distance,
						fStartRadius		= secondary_width_initial,
						fEndRadius			= secondary_width_end,
						Source				= caster,
						bHasFrontalCone		= true,
						bReplaceExisting	= false,
						iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime 		= GameRules:GetGameTime() + 10.0,
						bDeleteOnHit		= false,
						vVelocity			= Vector(velocity.x,velocity.y,0),
						bProvidesVision		= false,
						ExtraData			= {damage = secondary_damage, cdr_hero = cdr_hero, cdr_units = cdr_units}
					}
				ProjectileManager:CreateLinearProjectile(projectile)
			end
		end)

		if caster:HasTalent("special_bonus_imba_lina_2") then
			local new_loc = target_loc + primary_direction * secondary_distance
			local new_timer = (CalculateDistance(caster_loc,new_loc) / speed)

			Timers:CreateTimer((new_timer + split_delay), function()
				EmitSoundOnLocationWithCaster( new_loc, "Hero_Lina.DragonSlave", caster )

				local projectile =
					{
						Ability				= self,
						EffectName			= "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
						vSpawnOrigin		= new_loc,
						fDistance			= primary_distance,
						fStartRadius		= width_initial,
						fEndRadius			= width_end,
						Source				= caster,
						bHasFrontalCone		= true,
						bReplaceExisting	= false,
						iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						fExpireTime 		= GameRules:GetGameTime() + 10.0,
						bDeleteOnHit		= false,
						vVelocity			= Vector(primary_velocity.x,primary_velocity.y,0),
						bProvidesVision		= false,
						ExtraData			= {damage = primary_damage, cdr_hero = cdr_hero, cdr_units = cdr_units}
					}

				ProjectileManager:CreateLinearProjectile(projectile)
			end)
		end
	end
end

function imba_lina_dragon_slave:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()
		local ability_laguna = caster:FindAbilityByName("imba_lina_laguna_blade")
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
		-- #5 Talent: Lina's Spells causes DoT based on Fiery Soul stacks
		if caster:HasTalent("special_bonus_imba_lina_5") then
			local blaze_burn = target:FindModifierByName("modifier_imba_fiery_soul_blaze_burn")
			if blaze_burn then
				blaze_burn:ForceRefresh()
			else
				local fiery_soul = caster:FindAbilityByName("imba_lina_fiery_soul")
				if fiery_soul:GetLevel() > 0 then
					target:AddNewModifier(caster,fiery_soul,"modifier_imba_fiery_soul_blaze_burn",{duration = caster:FindTalentValue("special_bonus_imba_lina_5","duration")})
				end
			end
		end
		target:RemoveModifierByName("modifier_imba_blazing_fire")
		if ability_laguna and not ability_laguna:IsCooldownReady() then
			local cdr
			if target:IsHero() and not target:IsIllusion() then
				cdr = ExtraData.cdr_hero
			else
				cdr = ExtraData.cdr_units
			end
			local current_cooldown = ability_laguna:GetCooldownTimeRemaining()
			ability_laguna:EndCooldown()
			ability_laguna:StartCooldown(current_cooldown - cdr)
		end
	end
	return false
end

function imba_lina_dragon_slave:IsStealable()
	return true
end

function imba_lina_dragon_slave:IsHiddenWhenStolen()
	return false
end

function imba_lina_dragon_slave:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	return cooldown
end

-------------------------------------------
--			LIGHT STRIKE ARRAY
-------------------------------------------

imba_lina_light_strike_array = class({})
LinkLuaModifier("modifier_imba_lsa_talent_magma", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)

function imba_lina_light_strike_array:GetAbilityTextureName()
	return "lina_light_strike_array"
end

function imba_lina_light_strike_array:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target_loc = self:GetCursorPosition()
		local caster_loc = caster:GetAbsOrigin()

		-- Parameters
		local radius = self:GetSpecialValueFor("aoe_radius")
		local cast_delay = self:GetSpecialValueFor("cast_delay")
		local stun_duration = self:GetSpecialValueFor("stun_duration")
		local damage = self:GetTalentSpecialValueFor("damage")
		local secondary_delay = self:GetSpecialValueFor("secondary_delay")
		local array_count = self:GetSpecialValueFor("array_count")
		local array_rings_count = self:GetSpecialValueFor("array_rings_count")
		local rings_radius = self:GetSpecialValueFor("rings_radius")
		local rings_delay = self:GetSpecialValueFor("rings_delay")
		local rings_distance = self:GetSpecialValueFor("rings_distance")

		-- Distances
		local direction = (target_loc - caster_loc):Normalized()

		-- Emit cast-sound
		caster:EmitSound("Ability.PreLightStrikeArray")

		-- Response 20%
		if (math.random(1,5) < 2) and (caster:GetName() == "npc_dota_hero_lina") then
			caster:EmitSound("lina_lina_ability_lightstrike_0"..math.random(1,6))
		end

		-- Only create the main array blast
		self:CreateStrike( target_loc, 0, cast_delay, radius, damage, stun_duration )

		-- #7 Talent, Main Light Strike Array's explosion is repeated 2 times
		if caster:HasTalent("special_bonus_imba_lina_7") then
			local nuclear_radius = radius
			local nuclear_stun_duration = stun_duration
			for k=1, caster:FindTalentValue("special_bonus_imba_lina_7")-1, 1 do
				nuclear_radius = nuclear_radius + caster:FindTalentValue("special_bonus_imba_lina_7","add_radius") * k
				nuclear_stun_duration = nuclear_stun_duration * (1/(caster:FindTalentValue("special_bonus_imba_lina_7","stun_reduct")*k))
				self:CreateStrike( target_loc, (cast_delay * k), cast_delay, nuclear_radius, damage, nuclear_stun_duration )
			end
		end

		for i=0, array_count-1, 1 do
			local distance = i
			local count = i
			local next_distance = i+1
			local array_strike = i+1

			distance = radius * (distance + rings_distance)
			next_distance = radius * (next_distance + rings_distance)

			--if i == 0 then
			--	distance = 0
			--	next_distance = 0.25 * radius
			--else
			--if math.mod(i,2) == 1 then
			--		distance = radius * (distance + 0.25)
			--		next_distance = radius * (next_distance + 0.25)
			--else
			--	distance = radius * distance * (-1)
			--end
			--end

			local delay = math.abs(distance / (radius * 2)) * cast_delay
			-- local position = target_loc + distance * direction

			-- Create 6 LSA rings around the explosion
			local rings_direction = direction
			for j=1, array_rings_count, 1 do
				rings_direction = RotateVector2D(rings_direction,((360/array_rings_count)),true)
				-- new_rings_direction = RotateVector2D(rings_direction,30,true) -- Determines the Hexagon angle
				local ring_distance = rings_radius * (array_strike + 1)
				local ring_delay = math.abs((radius * (i + cast_delay + rings_distance)) / (rings_radius * 2)) * cast_delay
				local ring_position = target_loc + ring_distance * rings_direction
				self:CreateStrike( ring_position, (cast_delay + ring_delay), (cast_delay + rings_delay), rings_radius, damage, stun_duration )
			end
		end
	end
end

function imba_lina_light_strike_array:CreateStrike( position, delay, cast_delay, radius, damage, stun_duration )
	local caster = self:GetCaster()

	Timers:CreateTimer(delay, function()
		local cast_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", PATTACH_WORLDORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(cast_pfx, 0, position)
		ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius * 2, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)
	end)

	Timers:CreateTimer((delay+cast_delay), function()
		-- Emit particle + sound
		local blast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blast_pfx, 0, position)
		ParticleManager:SetParticleControl(blast_pfx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(blast_pfx)
		EmitSoundOnLocationWithCaster( position, "Ability.LightStrikeArray", caster )

		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(position, radius, false)

		-- Deal damage and stun
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			self:OnHit(enemy, damage, stun_duration)
		end

		-- #4 Talent: After a Light Strike Array hits the ground, magma erupts and damages nearby enemy units
		if caster:HasTalent("special_bonus_imba_lina_4") then
			CreateModifierThinker(caster, self, "modifier_imba_lsa_talent_magma", {duration = stun_duration, radius = radius}, position, caster:GetTeamNumber(), false)
		end
	end)
end

function imba_lina_light_strike_array:OnHit( target, damage, stun_duration )
	local caster = self:GetCaster()
	ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
	-- #5 Talent: Lina's Spells causes DoT based on Fiery Soul stacks
	if caster:HasTalent("special_bonus_imba_lina_5") then
		local blaze_burn = target:FindModifierByName("modifier_imba_fiery_soul_blaze_burn")
		if blaze_burn then
			blaze_burn:ForceRefresh()
		else
			local fiery_soul = caster:FindAbilityByName("imba_lina_fiery_soul")
			if fiery_soul:GetLevel() > 0 then
				target:AddNewModifier(caster,fiery_soul,"modifier_imba_fiery_soul_blaze_burn",{duration = caster:FindTalentValue("special_bonus_imba_lina_5","duration")})
			end
		end
	end
	target:RemoveModifierByName("modifier_imba_blazing_fire")
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
end

function imba_lina_light_strike_array:GetAOERadius()
	return self:GetSpecialValueFor("aoe_radius")
end

function imba_lina_light_strike_array:IsHiddenWhenStolen()
	return false
end



-- From The Ash magma modifier
modifier_imba_lsa_talent_magma = modifier_imba_lsa_talent_magma or class({})

function modifier_imba_lsa_talent_magma:OnCreated(kv)
	if IsServer() then
		-- Talent properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
		self.parent = self:GetParent()
		self.particle_effect = "particles/hero/lina/from_the_ash.vpcf"

		-- Talent specials
		self.radius = kv.radius
		print(self.radius)
		self.damage = self.caster:FindTalentValue("special_bonus_imba_lina_4", "damage")
		self.tick_interval = self.caster:FindTalentValue("special_bonus_imba_lina_4", "tick_interval")

		-- Play magma particle effect, assign to modifier
		local particle_magma = ParticleManager:CreateParticle(self.particle_effect, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_magma, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_magma, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_magma, 2, Vector(1,0,0))
		ParticleManager:SetParticleControl(particle_magma, 3, self.parent:GetAbsOrigin())

		self:AddParticle(particle_magma, false, false, -1, false, false)

		-- Calculate damage per tick
		self.damage_per_tick = self.damage * self.tick_interval

		-- Start thinking
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_imba_lsa_talent_magma:OnIntervalThink()
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
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL})

			ApplyDamage(damage_table)
		end
	end
end

-------------------------------------------
--				FIERY SOUL
-------------------------------------------

imba_lina_fiery_soul = class({})
LinkLuaModifier("modifier_imba_fiery_soul", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiery_soul_counter", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiery_soul_blaze_burn", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_fiery_soul_talent", "components/abilities/heroes/hero_lina", LUA_MODIFIER_MOTION_NONE)
function imba_lina_fiery_soul:IsStealable() return false end
function imba_lina_fiery_soul:GetIntrinsicModifierName()
	return "modifier_imba_fiery_soul"
end


function imba_lina_fiery_soul:GetAbilityTextureName()
	return "lina_fiery_soul"
end

function imba_lina_fiery_soul:GetCooldown()
	if self:GetBehavior() ~= DOTA_ABILITY_BEHAVIOR_PASSIVE then
		return self:GetTalentSpecialValueFor("active_cooldown")
	end
	return 0
end

function imba_lina_fiery_soul:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()

		-- Wait for the game to tick to remove the modifier
		Timers:CreateTimer(FrameTime(), function()
			local fiery_modifier = caster:FindModifierByName("modifier_imba_fiery_soul_counter")
			if fiery_modifier then
				fiery_modifier:Destroy()
			end
		end)

		-- Parameters
		local immolation_damage_min = caster:FindTalentValue("special_bonus_imba_lina_3")
		local immolation_damage_max = caster:FindTalentValue("special_bonus_imba_lina_3","value2")
		local immolation_aoe = caster:FindTalentValue("special_bonus_imba_lina_3","aoe")
		local min_damage_aoe = caster:FindTalentValue("special_bonus_imba_lina_3","min_damage_aoe")
		local max_damage_aoe = caster:FindTalentValue("special_bonus_imba_lina_3","max_damage_aoe")

		-- Emit particle + sound
		EmitSoundOnLocationWithCaster( caster_loc, "Hero_Phoenix.SuperNova.Explode", caster )

		local blast_pfx = ParticleManager:CreateParticle( "particles/hero/lina/lina_immolation.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( blast_pfx, 0, caster_loc )
		ParticleManager:SetParticleControl( blast_pfx, 1, Vector(1.5,1.5,1.5) )
		ParticleManager:SetParticleControl( blast_pfx, 3, caster_loc )
		ParticleManager:SetParticleControl( blast_pfx, 13, Vector(immolation_aoe, 0, 0))
		ParticleManager:SetParticleControl( blast_pfx, 15, caster_loc)
		ParticleManager:ReleaseParticleIndex(blast_pfx)
		-- Destroys trees
		GridNav:DestroyTreesAroundPoint(caster_loc, immolation_aoe, false)

		-- Deal damage
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, immolation_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in ipairs(enemies) do
			local distance = ( caster_loc - enemy:GetAbsOrigin() ):Length2D()
			local immolation_damage

			-- Deal the damage based on the target's distance
			if distance >= min_damage_aoe then
				immolation_damage = immolation_damage_min
			elseif distance <= max_damage_aoe then
				immolation_damage = immolation_damage_max
			else
				immolation_damage = immolation_damage_min + math.floor((immolation_damage_max - immolation_damage_min) * ((min_damage_aoe - distance)/(min_damage_aoe - max_damage_aoe)))
			end

			enemy:RemoveModifierByName("modifier_imba_blazing_fire")
			ApplyDamage({attacker = caster, victim = enemy, ability = self, damage = immolation_damage, damage_type = self:GetAbilityDamageType()})

			-- #5 Talent: Lina's Spells causes DoT based on Fiery Soul stacks
			if caster:HasTalent("special_bonus_imba_lina_5") then
				local blaze_burn = enemy:FindModifierByName("modifier_imba_fiery_soul_blaze_burn")
				if blaze_burn then
					blaze_burn:ForceRefresh()
				else
					local fiery_soul = caster:FindAbilityByName("imba_lina_fiery_soul")
					if fiery_soul:GetLevel() > 0 then
						enemy:AddNewModifier(caster,fiery_soul,"modifier_imba_fiery_soul_blaze_burn",{duration = caster:FindTalentValue("special_bonus_imba_lina_5","duration")})
					end
				end
			end
		end

	end
end

modifier_imba_fiery_soul = class({})

function modifier_imba_fiery_soul:OnCreated()
	-- Turns the skill into passive, tooltip purposes
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
end

function modifier_imba_fiery_soul:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		}
	return decFuncs
end

function modifier_imba_fiery_soul:OnAbilityFullyCast( params )
	if IsServer() then
		local item = params.ability:IsItem()
		if item then
			return
		end
		local parent = self:GetParent()
		local caster = params.ability:GetCaster()
		if (caster == parent) then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_fiery_soul_counter", {duration = self:GetAbility():GetSpecialValueFor("duration")})

			-- Fiery Soul ability cooldown reduction
			for ability_id = 0, 15 do
				local caster_ability = caster:GetAbilityByIndex(ability_id)
				if caster_ability then
					local ability_name = caster_ability:GetAbilityName()
					-- Does not reduce the cooldown of the current ability being casted
					if params.ability:GetName() == ability_name then
					else
						-- Get the modifier
						local fiery_counter = caster:FindModifierByName("modifier_imba_fiery_soul_counter")
						if fiery_counter then
							-- Get the ability cooldown
							local cooldown_remaining = caster_ability:GetCooldownTimeRemaining()
							local cooldown_reduction = self:GetAbility():GetSpecialValueFor("cdr_pct") * fiery_counter:GetStackCount()

							caster_ability:EndCooldown()
							if cooldown_remaining > cooldown_reduction then
								caster_ability:StartCooldown( cooldown_remaining - cooldown_reduction )
							end
						end
					end
				end
			end

		end
		return true
	end
end

function modifier_imba_fiery_soul:IsHidden()
	return true
end

function modifier_imba_fiery_soul:IsPurgable()
	return false
end

-- ClientSide fails the check on "GetCaster():HasTalent" so we need a workaround. 
-- instead i created a permanent modifier and used check GetCaster():HasModifier() 
-- to determine if we have talent selected. // naowin
modifier_imba_fiery_soul_talent = class({})
function modifier_imba_fiery_soul_talent:IsPassive() return true end
function modifier_imba_fiery_soul_talent:IsPermanent() return true end

modifier_imba_fiery_soul_counter = class({})

function modifier_imba_fiery_soul_counter:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		self:SetStackCount(1)
		self.particle = ParticleManager:CreateParticle("particles/hero/lina/fiery_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(self.particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 3, Vector(1,0,0))
		ParticleManager:SetParticleControl(self.particle, 4, Vector(1,0,0))

		if caster:HasTalent("special_bonus_imba_lina_3") then 
			caster:AddNewModifier(caster , self:GetAbility(), "modifier_imba_fiery_soul_talent", {})
		end
	end
end

-- Credits: yannich
-- #3 Talent: Reaching 3 Fiery Soul stacks allows Lina to unleash a blast of hot shockwave.
function modifier_imba_fiery_soul_counter:OnRefresh()
	local caster 		= self:GetCaster()
	local ability 		= self:GetAbility()
	local stacks 		= self:GetStackCount()
	local max_stacks 	= ability:GetTalentSpecialValueFor("max_stacks")
	if IsServer() then
		if stacks < max_stacks then
			self:SetStackCount(stacks+1)
			ParticleManager:SetParticleControl(self.particle, 3, Vector(stacks,0,0))
			ParticleManager:SetParticleControl(self.particle, 4, Vector(stacks,0,3 ))
		end

		if caster:HasTalent("special_bonus_imba_lina_3") then 
			caster:AddNewModifier(caster, ability, "modifier_imba_fiery_soul_talent", {})
		end
	end

	local stacks = self:GetStackCount()
	if caster:HasModifier("modifier_imba_fiery_soul_talent") then
		if stacks == max_stacks  then -- inject function calls clientside and serverside (but this is not run on clientside?)
			-- Change behavior
			ability.GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE end
			ability:GetBehavior()
			ability:GetCooldown()

			if IsClient() then
				ability:GetBehavior()
			end
		elseif stacks < max_stacks then
			ability.GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
			ability:GetBehavior()
			ability:GetCooldown()
		end
	end
end

-- When selecting #3 Talent while having max stacks, refresh the modifier to inject function calls

LinkLuaModifier("modifier_special_bonus_imba_lina_3", "components/abilities/heroes/hero_lina.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_lina_3 = modifier_special_bonus_imba_lina_3 or class({})

function modifier_special_bonus_imba_lina_3:IsHidden() return false end
function modifier_special_bonus_imba_lina_3:RemoveOnDeath() return false end

function modifier_special_bonus_imba_lina_3:OnCreated()
	if IsServer() then
		fiery_soul = self:GetParent():FindAbilityByName("imba_lina_fiery_soul")
		if fiery_soul:GetLevel() > 0 then
			local fiery_soul_modifier = self:GetParent():FindModifierByName("modifier_imba_fiery_soul_counter")
			if fiery_soul_modifier then
				-- On refresh, it adds a stack count if its less than max stacks
				fiery_soul_modifier:DecrementStackCount()
				fiery_soul_modifier:ForceRefresh()
			end
		end
	end
end

function modifier_imba_fiery_soul_counter:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
	self:GetAbility().GetBehavior = function() return DOTA_ABILITY_BEHAVIOR_PASSIVE end
	self:GetAbility():GetBehavior()
	self:GetAbility():GetCooldown()
end

function modifier_imba_fiery_soul_counter:GetTexture()
	return "lina_fiery_soul"
end

function modifier_imba_fiery_soul_counter:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
			MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
			MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		}
	return decFuncs
end

function modifier_imba_fiery_soul_counter:GetModifierAttackSpeedBonus_Constant()
	local speed = self:GetAbility():GetTalentSpecialValueFor("bonus_as")
	return speed * self:GetStackCount()
end

function modifier_imba_fiery_soul_counter:GetModifierMoveSpeedBonus_Percentage()
	local speed = self:GetAbility():GetSpecialValueFor("bonus_ms_pct")
	return speed * self:GetStackCount()
end

function modifier_imba_fiery_soul_counter:GetModifierPercentageCasttime()
	return self:GetAbility():GetSpecialValueFor("animation_pct") * self:GetStackCount()
end

--function modifier_imba_fiery_soul_counter:GetCustomCooldownReductionStacking()
--	return self:GetAbility():GetSpecialValueFor("cdr_pct") * self:GetStackCount()
--end

modifier_imba_fiery_soul_blaze_burn = class({})

function modifier_imba_fiery_soul_blaze_burn:IsHidden() return false end
function modifier_imba_fiery_soul_blaze_burn:IsPurgable() return true end
function modifier_imba_fiery_soul_blaze_burn:IsDebuff() return true end

function modifier_imba_fiery_soul_blaze_burn:OnCreated()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.tick = self.caster:FindTalentValue("special_bonus_imba_lina_5","tick")
	self.particle_flame = "particles/hero/clinkz/searing_flames_active/burn_effect.vpcf"

	if IsServer() then
		-- Add and attach flaming particle
		self.particle_flame_fx = ParticleManager:CreateParticle(self.particle_flame, PATTACH_POINT_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.particle_flame_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)

		self:AddParticle(self.particle_flame_fx, false, false, -1, false, false)

		-- Set the flaming color like Firetoad. RE
		self.parent:SetRenderColor(255, 86, 1)

		self:StartIntervalThink(self.tick)
	end
end

function modifier_imba_fiery_soul_blaze_burn:OnIntervalThink()
	if IsServer() then
		local fiery_soul_counter = self.caster:FindModifierByName("modifier_imba_fiery_soul_counter")
		if fiery_soul_counter then
			local damage = fiery_soul_counter:GetStackCount() * self.caster:FindTalentValue("special_bonus_imba_lina_5")
			ApplyDamage({attacker = self.caster, victim = self.parent, ability = self.ability, damage = damage, damage_type = self.ability:GetAbilityDamageType()})
		end
	end
end

function modifier_imba_fiery_soul_blaze_burn:OnRefresh()
	if IsServer() then
		self:SetDuration(self.caster:FindTalentValue("special_bonus_imba_lina_5","duration"),true)
	end
end

function modifier_imba_fiery_soul_blaze_burn:OnDestroy()
	if IsServer() then
		-- Prevent conflict with Firetoad. :D
		if self.parent:HasModifier("modifier_imba_lion_hex") then
		else
			self.parent:SetRenderColor(255,255,255)
		end
	end
end

-------------------------------------------
--			LAGUNA BLADE
-------------------------------------------

imba_lina_laguna_blade = class({})

function imba_lina_laguna_blade:GetAbilityTextureName()
	return "lina_laguna_blade"
end

function imba_lina_laguna_blade:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local target_loc = target:GetAbsOrigin()
		local caster_loc = caster:GetAbsOrigin()
		local damage_type = self:GetAbilityDamageType()

		local damage = self:GetSpecialValueFor("damage")
		local effect_delay = self:GetSpecialValueFor("effect_delay")
		local bounce_amount = self:GetSpecialValueFor("bounce_amount")
		local bounce_range = self:GetSpecialValueFor("bounce_range")
		local bounce_delay = self:GetSpecialValueFor("bounce_delay")

		-- Play the cast sound + fire particle
		caster:EmitSound("Ability.LagunaBlade")
		local blade_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(blade_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster_loc, true)
		ParticleManager:SetParticleControlEnt(blade_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)
		ParticleManager:ReleaseParticleIndex(blade_pfx)

		-- If the target possesses a ready Spell-Counter, do nothing further
		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(self) then
				return nil
			end
		end

		Timers:CreateTimer(effect_delay, function()
			ApplyDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = damage_type})

			-- #5 Talent: Lina's Spells causes DoT based on Fiery Soul stacks
			if caster:HasTalent("special_bonus_imba_lina_5") then
				local blaze_burn = target:FindModifierByName("modifier_imba_fiery_soul_blaze_burn")
				if blaze_burn then
					blaze_burn:ForceRefresh()
				else
					local fiery_soul = caster:FindAbilityByName("imba_lina_fiery_soul")
					if fiery_soul:GetLevel() > 0 then
						target:AddNewModifier(caster,fiery_soul,"modifier_imba_fiery_soul_blaze_burn",{duration = caster:FindTalentValue("special_bonus_imba_lina_5","duration")})
					end
				end
			end

			target:RemoveModifierByName("modifier_imba_blazing_fire")
			if caster:HasTalent("special_bonus_imba_lina_6") then
				target:AddNewModifier(caster, self, "modifier_stunned", { duration = caster:FindTalentValue("special_bonus_imba_lina_6") })
			end
			-- Bouncing --
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			-- Remove main-target from list
			for i=1,#enemies,1 do
				if enemies[i] == target then
					table.remove(enemies, i)
				end
			end
			-- Bounce on remaining targets
			Timers:CreateTimer(bounce_delay, function()
				for i=1, math.min(#enemies,bounce_amount),1 do
					local bounce_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
					ParticleManager:SetParticleControlEnt(bounce_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_loc, true)
					ParticleManager:SetParticleControlEnt(bounce_pfx, 1, enemies[i], PATTACH_POINT_FOLLOW, "attach_hitloc", enemies[i]:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(bounce_pfx)
					Timers:CreateTimer(effect_delay, function()
						ApplyDamage({victim = enemies[i], attacker = caster, ability = self, damage = damage, damage_type = damage_type})
						-- #5 Talent: Lina's Spells causes DoT based on Fiery Soul stacks
						if caster:HasTalent("special_bonus_imba_lina_5") then
							local blaze_burn = enemies[i]:FindModifierByName("modifier_imba_fiery_soul_blaze_burn")
							if blaze_burn then
								blaze_burn:ForceRefresh()
							else
								local fiery_soul = caster:FindAbilityByName("imba_lina_fiery_soul")
								if fiery_soul:GetLevel() > 0 then
									enemies[i]:AddNewModifier(caster,fiery_soul,"modifier_imba_fiery_soul_blaze_burn",{duration = caster:FindTalentValue("special_bonus_imba_lina_5","duration")})
								end
							end
						end
						enemies[i]:RemoveModifierByName("modifier_imba_blazing_fire")
						if caster:HasTalent("special_bonus_imba_lina_6") then
							enemies[i]:AddNewModifier(caster, self, "modifier_stunned", { duration = caster:FindTalentValue("special_bonus_imba_lina_6") })
						end
					end)
				end
			end)
		end)
	end
end

-- Restrict Laguna Blade being casted on magic immune without scepter
function imba_lina_laguna_blade:CastFilterResultTarget( target )
	if IsServer() then

		if target ~= nil and target:IsMagicImmune() and ( not self:GetCaster():HasScepter() ) then
			return UF_FAIL_MAGIC_IMMUNE_ENEMY
		end

		local nResult = UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
		return nResult
	end
end

function imba_lina_laguna_blade:GetAbilityDamageType()
	if self:GetCaster():HasScepter() then return DAMAGE_TYPE_PURE end
	return DAMAGE_TYPE_MAGICAL
end

function imba_lina_laguna_blade:GetAOERadius()
	return self:GetSpecialValueFor("bounce_range")
end

function imba_lina_laguna_blade:GetCooldown( nLevel )
	local cooldown = self.BaseClass.GetCooldown( self, nLevel )
	local caster = self:GetCaster()
	return cooldown
end

function imba_lina_laguna_blade:IsHiddenWhenStolen()
	return false
end
