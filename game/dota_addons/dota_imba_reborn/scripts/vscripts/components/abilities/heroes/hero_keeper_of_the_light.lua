-- Creator:
--	   AltiV, March 1st, 2019

LinkLuaModifier("modifier_imba_keeper_of_the_light_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_spirit_form_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_blinding_light", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blinding_light_knockback", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_charka_magic", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp_aura", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

imba_keeper_of_the_light_illuminate							= class({})
modifier_imba_keeper_of_the_light_illuminate				= class({})
modifier_imba_keeper_of_the_light_spirit_form_illuminate	= class({})

imba_keeper_of_the_light_illuminate_end						= class({})

imba_keeper_of_the_light_blinding_light						= class({})
modifier_imba_keeper_of_the_light_blinding_light			= class({})
modifier_imba_blinding_light_knockback						= class({})		

imba_keeper_of_the_light_charka_magic						= class({})
modifier_imba_keeper_of_the_light_charka_magic				= class({})

imba_keeper_of_the_light_spotlights							= class({})

imba_keeper_of_the_light_will_o_wisp						= class({})
modifier_imba_keeper_of_the_light_will_o_wisp				= class({})
modifier_imba_keeper_of_the_light_will_o_wisp_aura			= class({})

----------------
-- Illuminate --
----------------

function imba_keeper_of_the_light_illuminate:GetAssociatedSecondaryAbilities()
	return "imba_keeper_of_the_light_illuminate_end"
end

-- First level-up of Illuminate also levels up the Illuminate End ability
function imba_keeper_of_the_light_illuminate:OnUpgrade()
	if not IsServer() then return end
	
	local illuminate_end = self:GetCaster():FindAbilityByName("imba_keeper_of_the_light_illuminate_end")
	
	if illuminate_end then
		illuminate_end:SetLevel(self:GetLevel())
	end
end

function imba_keeper_of_the_light_illuminate:OnSpellStart()
	self.caster	= self:GetCaster()
	
	self.speed				= self:GetSpecialValueFor("speed")
	
	-- Save the position of the caster into variable (since caster might move before wave is fired)
	self.caster_location	= self.caster:GetAbsOrigin()
	
	-- Get the position of where Illuminate was cast towards
	self.position			= self:GetCursorPosition()

	-- Vision parameters
	self.vision_node_radius		= 450
	self.vision_node_distance	= self.vision_node_radius * 0.5
	self.vision_node_duration	= 10.34
	
	if not IsServer() then return end
	
	-- Calculate direction for which Illuminate is going to travel
	self.direction	= (self.position - self.caster_location):Normalized()
	
	-- Get the time that the channel starts
	self.game_time_start		= GameRules:GetGameTime()
	
	-- Keep a counter for the vision spots that slowly build as channeling continues
	self.vision_counter 		= 1
	self.vision_time_count		= GameRules:GetGameTime()
	
	-- Emit casting sound
	self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
	
	-- Emit glowing staff particle
	self.weapon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate_cast.vpcf", PATTACH_POINT_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(self.weapon_particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
	
	self.caster:SwapAbilities("imba_keeper_of_the_light_illuminate", "imba_keeper_of_the_light_illuminate_end", false, true)
end

function imba_keeper_of_the_light_illuminate:OnChannelThink()
	if not IsServer() then return end
	
	-- Every 0.5 seconds, create a visibility node further ahead
	if GameRules:GetGameTime() - self.vision_time_count >= 0.5 then
		self.vision_time_count = GameRules:GetGameTime()
		self:CreateVisibilityNode(self.caster_location + (self.direction * self.vision_node_distance * self.vision_counter), self.vision_node_radius, self.vision_node_duration)
		self.vision_counter = self.vision_counter + 1
	end
end

-- TODO: Add response sounds and do Transient/Spirit form for channeling while moving
-- need horse hitting enemy sounds
function imba_keeper_of_the_light_illuminate:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	-- AbilitySpecials
	self.damage_per_second			= self:GetSpecialValueFor("damage_per_second")
	self.max_channel_time			= self:GetSpecialValueFor("max_channel_time")
	self.radius						= self:GetSpecialValueFor("radius")
	self.range						= self:GetSpecialValueFor("range")
	self.speed						= self:GetSpecialValueFor("speed")
	self.vision_radius				= self:GetSpecialValueFor("vision_radius")
	self.vision_duration			= self:GetSpecialValueFor("vision_duration")
	self.channel_vision_radius		= self:GetSpecialValueFor("channel_vision_radius")
	self.channel_vision_interval	= self:GetSpecialValueFor("channel_vision_interval")
	self.channel_vision_duration	= self:GetSpecialValueFor("channel_vision_duration")
	self.channel_vision_step		= self:GetSpecialValueFor("channel_vision_step")
	self.total_damage				= self:GetSpecialValueFor("total_damage")

	self.direction					= (self.position - self.caster_location):Normalized()
	self.duration 					= self.range / self.speed

	self.game_time_end				= GameRules:GetGameTime()

	--if bInterrupted then
		--ACT_DOTA_CAST_ABILITY_7
		-- Create the Illuminate particle with CP1 being the velocity and CP3 being the origin
		-- Why is the circle particle so bright
		-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_spiritform.vpcf", PATTACH_WORLDORIGIN, self.caster)
		-- ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_WORLDORIGIN, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		-- ParticleManager:SetParticleControl(self.particle, 1, self.direction * self.speed)
		-- ParticleManager:SetParticleControl(self.particle, 3, self.caster:GetAbsOrigin())
		-- ParticleManager:ReleaseParticleIndex(self.particle)
		
		-- how do i get this to work ugh
		-- local asdf = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_illuminate_spirit.vpcf", PATTACH_WORLDORIGIN, self.caster)
		-- ParticleManager:SetParticleControlEnt(asdf, 0, self.caster, PATTACH_WORLDORIGIN, "attach_hitloc", self.caster:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex(asdf)
	--else
		self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Discharge")

		self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
		
		CreateModifierThinker(self.caster, self, "modifier_imba_keeper_of_the_light_illuminate", {
			duration		= self.range / self.speed,
			direction_x 	= self.direction.x,	-- x direction of where Illuminate will travel
			direction_y 	= self.direction.y,	-- y direction of where Illuminate will travel
			channel_time 	= self.game_time_end - self.game_time_start	-- total time Illuminate was channeled for
		}, 
		self.caster:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
		
		-- Remove the glowing staff particle effect
		ParticleManager:DestroyParticle(self.weapon_particle, false)
		ParticleManager:ReleaseParticleIndex(self.weapon_particle)
	--end
	
	self.caster:SwapAbilities("imba_keeper_of_the_light_illuminate_end", "imba_keeper_of_the_light_illuminate", false, true)
end

-----------------------------
-- ILLUMINATE WAVE THINKER --
-----------------------------

function modifier_imba_keeper_of_the_light_illuminate:OnCreated( params )
	if not IsServer() then return end

	self.ability	= self:GetAbility()
	self.parent		= self:GetParent()
	self.caster		= self:GetCaster()

	-- AbilitySpecials
	self.damage_per_second			= self.ability:GetSpecialValueFor("damage_per_second")
	self.max_channel_time			= self.ability:GetSpecialValueFor("max_channel_time")
	self.radius						= self.ability:GetSpecialValueFor("radius")
	self.range						= self.ability:GetSpecialValueFor("range")
	self.speed						= self.ability:GetSpecialValueFor("speed")
	self.vision_radius				= self.ability:GetSpecialValueFor("vision_radius")
	self.vision_duration			= self.ability:GetSpecialValueFor("vision_duration")
	self.channel_vision_radius		= self.ability:GetSpecialValueFor("channel_vision_radius")
	self.channel_vision_interval	= self.ability:GetSpecialValueFor("channel_vision_interval")
	self.channel_vision_duration	= self.ability:GetSpecialValueFor("channel_vision_duration")
	self.channel_vision_step		= self.ability:GetSpecialValueFor("channel_vision_step")
	self.total_damage				= self.ability:GetSpecialValueFor("total_damage")

	self.duration			= params.duration
	self.direction			= Vector(params.direction_x, params.direction_y, 0)
	self.direction_angle	= math.deg(math.atan2(self.direction.x, self.direction.y))
	self.channel_time		= params.channel_time
	
	-- Create the Illuminate particle with CP1 being the velocity and CP3 being the origin
	-- Why is the circle particle so bright
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate.vpcf", PATTACH_WORLDORIGIN, self.caster)
	ParticleManager:SetParticleControl(self.particle, 1, self.direction * self.speed)
	ParticleManager:SetParticleControl(self.particle, 3, self.parent:GetAbsOrigin())
	
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- Initialize table of enemies hit so we don't hit things more than once
	self.hit_enemies = {}
	
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

-- TODO: Change from enemy to both teams for ally healing in daytime
-- TODO: Make the particle not visible in fog...
function modifier_imba_keeper_of_the_light_illuminate:OnIntervalThink()
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- Borrowed from Bristleback logic which I still don't fully understand, but essentially this checks to make sure the enemy is within the "front" of the wave, because the local enemies table returns everything in a circle
	for _, enemy in pairs(enemies) do
		local enemy_pos 	= enemy:GetAbsOrigin()
		local enemy_angle	= math.deg(math.atan2((enemy_pos.x - self.parent:GetAbsOrigin().x), enemy_pos.y - self.parent:GetAbsOrigin().y))
		
		local difference = math.abs(self.direction_angle - enemy_angle)
		
		-- If the enemy's position is not within the front semi-circle, remove them from the table
		if difference > 90 and difference < 270 then
			table.remove(enemies, _)
		end
	end
	
	-- By the end, the enemies table SHOULD have every unit that's actually in the "front" (semi-circle) of the wave, aka they should actually be hit by the wave
	for _, enemy in pairs(enemies) do
	
		local hit_already = false
	
		for _, hit_enemy in pairs(self.hit_enemies) do
			if hit_enemy == enemy then
				hit_already = true
				break
			end
		end
		
		if not hit_already then
			local damageTable = {
				victim 			= enemy,
				-- Damage starts ramping from when cast time starts, so just gonna simiulate the effects by adding the cast point
				damage 			= math.min((self.channel_time + self.ability:GetCastPoint()) * self.damage_per_second, self.max_channel_time * self.damage_per_second),
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self.caster,
				ability 		= self.ability
			}
									
			ApplyDamage(damageTable)
			
			-- Apply sounds (wave sound + horse sounds)
			enemy:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target")
			enemy:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target.Secondary")
			
			-- Apply the "hit by Illuminate" particle
			local particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact_small.vpcf"
			
			-- Heroes get a larger particle (supposedly)
			if enemy:IsHero() then
				particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact.vpcf"
			end
			
			local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Add the enemy to the list of enemies hit so they can't get hit again
			table.insert(self.hit_enemies, enemy)
		end
	end

	-- Move the wave forward by a frame
	self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + (self.direction * self.speed * FrameTime()))
end

-- Safety destructor?
function modifier_imba_keeper_of_the_light_illuminate:OnDestroy()
	if not IsServer() then return end

	self.parent:RemoveSelf()
end

--------------------
-- ILLUMINATE END --
--------------------

function imba_keeper_of_the_light_illuminate_end:GetAssociatedPrimaryAbilities()
	return "imba_keeper_of_the_light_illuminate"
end

function imba_keeper_of_the_light_illuminate_end:OnSpellStart()
	if not IsServer() then return end

	self.caster	= self:GetCaster()
	
	if self.caster:IsChanneling() then
		local illuminate	= self.caster:FindAbilityByName("imba_keeper_of_the_light_illuminate")
		
		if illuminate then
			illuminate:EndChannel(false)
			self.caster:SwapAbilities("imba_keeper_of_the_light_illuminate_end", "imba_keeper_of_the_light_illuminate", false, true)
		end
	end
end

--------------------
-- BLINDING LIGHT --
--------------------

------------------
-- CHAKRA MAGIC --
------------------

---------------
-- MANA LEAK --
---------------

-- Might remove this / incorporate into talent

-----------------
-- WILL O WISP --
-----------------

function imba_keeper_of_the_light_will_o_wisp:OnSpellStart()
	self.caster		= self:GetCaster()
	self.position	= self:GetCursorPosition()
	
	-- AbilitySpecials
	self.on_count				= self:GetSpecialValueFor("on_count")
	self.radius					= self:GetSpecialValueFor("radius")
	self.hit_count				= self:GetSpecialValueFor("hit_count")
	self.off_duration			= self:GetSpecialValueFor("off_duration")
	self.on_duration			= self:GetSpecialValueFor("on_duration")
	self.off_duration_initial	= self:GetSpecialValueFor("off_duration_initial")
	self.fixed_movement_speed	= self:GetSpecialValueFor("fixed_movement_speed")
	self.bounty					= self:GetSpecialValueFor("bounty")

	-- Calculate total duration that the wisp will be present for using on and off durations
	self.duration = self.off_duration_initial + (self.on_duration * self.on_count) + (self.off_duration + (self.on_count - 1))

	if not IsServer() then return end

	CreateUnitByNameAsync("npc_dota_ignis_fatuus", self.position, true, self.caster, self.caster, self.caster:GetTeam(), function(ignis_fatuus)
		-- Add the hypnotizing aura modifier
		ignis_fatuus:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_will_o_wisp", {duration = self.duration})
		
		-- Set up gold bounty
		ignis_fatuus:SetMaximumGoldBounty(self.bounty)
		ignis_fatuus:SetMinimumGoldBounty(self.bounty)
	end)
end

--------------------------
-- WILL O WISP MODIFIER --
--------------------------

function modifier_imba_keeper_of_the_light_will_o_wisp:IsPurgable()		return false end

function modifier_imba_keeper_of_the_light_will_o_wisp:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.on_count				= self.ability:GetSpecialValueFor("on_count")
	self.radius					= self.ability:GetSpecialValueFor("radius")
	self.hit_count				= self.ability:GetSpecialValueFor("hit_count")
	self.off_duration			= self.ability:GetSpecialValueFor("off_duration")
	self.on_duration			= self.ability:GetSpecialValueFor("on_duration")
	self.off_duration_initial	= self.ability:GetSpecialValueFor("off_duration_initial")
	self.fixed_movement_speed	= self.ability:GetSpecialValueFor("fixed_movement_speed")
	self.bounty					= self.ability:GetSpecialValueFor("bounty")
	
	if not IsServer() then return end
	
	-- Calculate health chunks that Ignis Fatuus will lose on getting attacked
	self.health_increments		= self.parent:GetMaxHealth() / self.hit_count
	
	-- This gives Ignis Fatuus a visible model
	-- CP1 = Vector(radius, 1, 1)
	-- CP2 = Vector("hypnotize is on", 0, 0)
	-- CP3/4/5 = I don't know
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
	
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	--particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_debuff.vpcf
	--particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf
	--particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_start.vpcf
end

function modifier_imba_keeper_of_the_light_will_o_wisp:OnRemoved()
	if not IsServer() then return end
	
	self.parent:ForceKill(false)
end

function modifier_imba_keeper_of_the_light_will_o_wisp:IsAura() 				return true end
function modifier_imba_keeper_of_the_light_will_o_wisp:IsAuraActiveOnDeath() 	return false end

function modifier_imba_keeper_of_the_light_will_o_wisp:GetAuraRadius()			return 625 end
function modifier_imba_keeper_of_the_light_will_o_wisp:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_keeper_of_the_light_will_o_wisp:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_keeper_of_the_light_will_o_wisp:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_keeper_of_the_light_will_o_wisp:GetModifierAura()		return "modifier_imba_keeper_of_the_light_will_o_wisp_aura" end

function modifier_imba_keeper_of_the_light_will_o_wisp:GetAuraEntityReject(hEntity)
	if not IsServer() then return end

	-- -- Aura should not be active while it is off
	
	return false
end

-- IMBAfication: I forget what I named this need to find my notes
function modifier_imba_keeper_of_the_light_will_o_wisp:CheckState(keys)
	local state = {
	[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}

	return state
end

function modifier_imba_keeper_of_the_light_will_o_wisp:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		
		MODIFIER_EVENT_ON_ATTACKED
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_will_o_wisp:GetAbsoluteNoDamageMagical()
    return 1
end

function modifier_imba_keeper_of_the_light_will_o_wisp:GetAbsoluteNoDamagePhysical()
    return 1
end

function modifier_imba_keeper_of_the_light_will_o_wisp:GetAbsoluteNoDamagePure()
    return 1
end

function modifier_imba_keeper_of_the_light_will_o_wisp:OnAttacked(keys)
    if not IsServer() then return end
	
	if keys.target == self.parent and (keys.attacker:IsRealHero() or keys.attacker:IsClone() or keys.attacker:IsTempestDouble()) then
		-- Deal with enemy logic first

		if self.parent:GetTeam() ~= keys.attacker:GetTeam() then
		
			self.parent:SetHealth(self.parent:GetHealth() - self.health_increments)
			
			if self.parent:GetHealth() <= 0 then
				self.parent:Kill(nil, keys.attacker)
				-- This needs to be called to have the proper particle removal
				self:Destroy()
			end
		
		-- Then with ally logic
		else
		
		end
	end
end

-------------------------------
-- WILL O WISP MODIFIER AURA --
-------------------------------

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:OnCreated()

end

-- function imba_bristleback_viscous_nasal_goo:GetIntrinsicModifierName()
	-- return "modifier_imba_bristleback_viscous_nasal_goo_autocaster"
-- end

-- function imba_bristleback_viscous_nasal_goo:GetBehavior()
	-- if self:GetCaster():HasScepter() then
		-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
	-- else
		-- return self.BaseClass.GetBehavior(self)
	-- end
-- end

-- function imba_bristleback_viscous_nasal_goo:OnSpellStart()
	-- self.caster	= self:GetCaster()
	
	-- -- AbilitySpecials
	-- self.goo_speed					= self:GetSpecialValueFor("goo_speed")
	-- self.goo_duration				= self:GetSpecialValueFor("goo_duration")
	-- self.base_armor					= self:GetSpecialValueFor("base_armor")
	-- self.armor_per_stack			= self:GetSpecialValueFor("armor_per_stack")
	-- self.base_move_slow				= self:GetSpecialValueFor("base_move_slow")
	-- self.move_slow_per_stack		= self:GetSpecialValueFor("move_slow_per_stack")
	-- --self.stack_limit 				= self:GetSpecialValueFor("stack_limit")
	-- self.goo_duration_creep			= self:GetSpecialValueFor("goo_duration_creep")
	-- self.radius_scepter 			= self:GetSpecialValueFor("radius_scepter")
	
	-- self.disgust_knockback 			= self:GetSpecialValueFor("disgust_knockback")
	-- self.disgust_knockup 			= self:GetSpecialValueFor("disgust_knockup")
	-- self.base_disgust_duration 		= self:GetSpecialValueFor("base_disgust_duration")
	-- self.disgust_duration_per_stack	= self:GetSpecialValueFor("disgust_duration_per_stack")
	
	-- if not IsServer() then return end
	
	-- self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
	
	-- if self.caster:HasScepter() then
		-- local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		
		-- for _, enemy in pairs(enemies) do
			-- local projectile =
			-- {
				-- Target 				= enemy,
				-- Source 				= self.caster,
				-- Ability 			= self,
				-- EffectName 			= "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
				-- iMoveSpeed 			= self.goo_speed,
				-- vSourceLoc			= self.caster:GetAbsOrigin(),
				-- bDrawsOnMinimap		= false,
				-- bDodgeable			= true,
				-- bIsAttack 			= false,
				-- bVisibleToEnemies	= true,
				-- bReplaceExisting 	= false,
				-- flExpireTime 		= GameRules:GetGameTime() + 10,
				-- bProvidesVision 	= false,
				-- iVisionRadius 		= 0,
				-- iVisionTeamNumber 	= self.caster:GetTeamNumber()
			-- }
			
			-- ProjectileManager:CreateTrackingProjectile(projectile)
		-- end
	-- else
		-- self.target	= self:GetCursorTarget()
	
		-- -- Stop if target has linkens
		-- if self.target:TriggerSpellAbsorb(self) then return end
	
		-- local projectile =
		-- {
			-- Target 				= self.target,
			-- Source 				= self.caster,
			-- Ability 			= self,
			-- EffectName 			= "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
			-- iMoveSpeed 			= self.goo_speed,
			-- vSourceLoc			= self.caster:GetAbsOrigin(),
			-- bDrawsOnMinimap		= false,
			-- bDodgeable			= true,
			-- bIsAttack 			= false,
			-- bVisibleToEnemies	= true,
			-- bReplaceExisting 	= false,
			-- flExpireTime 		= GameRules:GetGameTime() + 10,
			-- bProvidesVision 	= false,
			-- iVisionRadius 		= 0,
			-- iVisionTeamNumber 	= self.caster:GetTeamNumber()
		-- }
		
		-- ProjectileManager:CreateTrackingProjectile(projectile)
	-- end
		
	-- if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
		-- self.caster:EmitSound("bristleback_bristle_nasal_goo_0"..math.random(1,7))
	-- end
-- end

-- function imba_bristleback_viscous_nasal_goo:OnProjectileHit(hTarget, vLocation)
	-- if hTarget ~= nil and hTarget:IsAlive() and not hTarget:IsMagicImmune() then
		-- local goo_modifier = hTarget:AddNewModifier(self.caster, self, "modifier_imba_bristleback_viscous_nasal_goo", {duration = self.goo_duration})
		
		-- hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")
		
		-- -- IMBAfication: Disgust
		-- local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		-- for	_, enemy in pairs(enemies) do
			-- if enemy ~= hTarget then
				-- local knockback = {
					-- should_stun 		= 0,
					-- knockback_distance 	= self.disgust_knockback * goo_modifier:GetStackCount(), 
					-- knockback_height 	= self.disgust_knockup * goo_modifier:GetStackCount(),
					-- center_x			= hTarget:GetAbsOrigin().x,
					-- center_y			= hTarget:GetAbsOrigin().y,
					-- center_z			= hTarget:GetAbsOrigin().z,
					-- knockback_duration	= self.base_disgust_duration + (self.disgust_duration_per_stack * goo_modifier:GetStackCount()) -- This doesn't work or something?
				-- }

				-- enemy:AddNewModifier(self.caster, self, "modifier_knockback", knockback):SetDuration(self.base_disgust_duration + (self.disgust_duration_per_stack * goo_modifier:GetStackCount()), true)
			-- end
		-- end
	-- end
-- end

-- --------------------------------
-- -- VISCOUS NASAL GOO MODIFIER --
-- --------------------------------

-- function modifier_imba_bristleback_viscous_nasal_goo:GetEffectName()
	-- return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
-- end

-- -- IDK which status effect it uses for this one and I can't find it so might just leave it, cause it's not this one...
-- function modifier_imba_bristleback_viscous_nasal_goo:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_goo.vpcf"
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.goo_speed				= self.ability:GetSpecialValueFor("goo_speed")
	-- self.goo_duration			= self.ability:GetSpecialValueFor("goo_duration")
	-- self.base_armor				= self.ability:GetSpecialValueFor("base_armor")
	-- self.armor_per_stack		= self.ability:GetSpecialValueFor("armor_per_stack")
	-- self.base_move_slow			= self.ability:GetSpecialValueFor("base_move_slow")
	-- self.move_slow_per_stack	= self.ability:GetSpecialValueFor("move_slow_per_stack")
	-- self.stack_limit 			= self.ability:GetSpecialValueFor("stack_limit") + self.caster:FindTalentValue("special_bonus_unique_bristleback")
	-- self.goo_duration_creep		= self.ability:GetSpecialValueFor("goo_duration_creep")
	-- self.radius_scepter 		= self.ability:GetSpecialValueFor("radius_scepter")

	-- if not IsServer() then return end

	-- self:SetStackCount(1)
	
	-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	-- ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo:OnRefresh()
	-- if not IsServer() then return end

	-- if self:GetStackCount() < self.stack_limit then
		-- self:IncrementStackCount()
		-- ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
	-- end
	
	-- -- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	-- self:SetDuration(self.goo_duration * (1 - self.parent:GetStatusResistance()), true)
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        -- MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo:GetModifierMoveSpeedBonus_Percentage()
    -- return ((self.base_move_slow + (self.move_slow_per_stack * self:GetStackCount())) * (-1))
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo:GetModifierPhysicalArmorBonus()
    -- return ((self.base_armor + (self.armor_per_stack * self:GetStackCount())) * (-1))
-- end

-- -------------------------------------------
-- -- VISCOUS NASAL GOO AUTOCASTER MODIFIER --
-- -------------------------------------------

-- function modifier_imba_bristleback_viscous_nasal_goo_autocaster:IsHidden()	return true end

-- function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnCreated()
	-- if not IsServer() then return end

	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()

	-- self:StartIntervalThink(0.1)
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnRefresh()
	-- if not IsServer() then return end

	-- self:StartIntervalThink(-1)

	-- self:OnCreated()
-- end

-- function modifier_imba_bristleback_viscous_nasal_goo_autocaster:OnIntervalThink()
	-- if not IsServer() then return end

	-- if self.ability:GetAutoCastState() and self.ability:IsFullyCastable() and not self.ability:IsInAbilityPhase() then
		-- if self.caster:HasScepter() then
			-- self.caster:CastAbilityNoTarget(self.ability, self.caster:GetPlayerID())
		-- else
			-- local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.ability:GetCastRange(self.caster:GetAbsOrigin(), self.caster), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
			
			-- if #enemies > 0 then
				-- self.caster:CastAbilityOnTarget(enemies[1], self.ability, self.caster:GetPlayerID())
			-- end
		-- end

		-- Timers:CreateTimer(self.ability:GetBackswingTime(), function()
			-- -- This is just to prevent Bristleback from bricking up in super low CD situations, but he won't target people after cast then
			-- if not self.ability:IsNull() and self.ability:GetCooldownTimeRemaining() > self.ability:GetBackswingTime() then
				-- self.caster:MoveToPositionAggressive(self.caster:GetAbsOrigin())
			-- end
		-- end)
	-- end
-- end

-- -----------------
-- -- Quill Spray --
-- -----------------

-- function imba_bristleback_quill_spray:GetIntrinsicModifierName()
	-- return "modifier_imba_bristleback_quill_spray_autocaster"
-- end

-- function imba_bristleback_quill_spray:OnSpellStart()
	-- self.caster	= self:GetCaster()
	
	-- -- AbilitySpecials
	-- self.radius					= self:GetSpecialValueFor("radius") -- Note that the particle doesn't seem to support proper radius change so be warned...
	-- -- self.quill_base_damage		= self:GetSpecialValueFor("quill_base_damage")
	-- -- self.quill_stack_damage		= self:GetSpecialValueFor("quill_stack_damage")
	-- -- self.quill_stack_duration	= self:GetSpecialValueFor("quill_stack_duration")
	-- -- self.max_damage				= self:GetSpecialValueFor("max_damage")
	-- self.projectile_speed		= self:GetSpecialValueFor("projectile_speed")
	
	-- -- Calculate amount of time quills should "exist" based on speed and radius
	-- self.duration				= self.radius / self.projectile_speed
	
	-- if not IsServer() then return end
	
	-- CreateModifierThinker(self.caster, self, "modifier_imba_bristleback_quillspray_thinker", {duration = self.duration}, self.caster:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
	
	-- self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")
-- end 

-- -------------------------
-- -- QUILL SPRAY THINKER --
-- -------------------------

-- function modifier_imba_bristleback_quillspray_thinker:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.radius					= self.ability:GetSpecialValueFor("radius")
	-- self.quill_base_damage		= self.ability:GetSpecialValueFor("quill_base_damage")
	-- self.quill_stack_damage		= self.ability:GetSpecialValueFor("quill_stack_damage") + self.caster:FindTalentValue("special_bonus_unique_bristleback_2")
	-- self.quill_stack_duration	= self.ability:GetSpecialValueFor("quill_stack_duration")
	-- self.max_damage				= self.ability:GetSpecialValueFor("max_damage")
	-- -- self.projectile_speed		= self.ability:GetSpecialValueFor("projectile_speed")
	
	-- if not IsServer() then return end
	
	-- -- CP60 for colour, CP61 Vector(1, 0, 0) to activate it
	-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN, self.parent)
	-- -- For the hell of it
	-- ParticleManager:SetParticleControl(self.particle, 60, Vector(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)))
	-- ParticleManager:SetParticleControl(self.particle, 61, Vector(1, 0, 0))
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- -- Establish table to populate hit enemies with (so they only get hit once per quill spray)
	-- self.hit_enemies = {}
	
	-- self:StartIntervalThink(FrameTime())
-- end

-- function modifier_imba_bristleback_quillspray_thinker:OnIntervalThink()
	-- if not IsServer() then return end

	-- -- From 0 to 1 to track how far the quills have spread and the damage radius
	-- local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)
	
	-- local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	-- for _, enemy in pairs(enemies) do
	
		-- local hit_already = false
	
		-- for _, hit_enemy in pairs(self.hit_enemies) do
			-- if hit_enemy == enemy then
				-- hit_already = true
				-- break
			-- end
		-- end

		-- if not hit_already then
			-- local quill_spray_stacks 	= 0
			-- local quill_spray_modifier	= enemy:FindModifierByName("modifier_imba_bristleback_quill_spray")
			
			-- if quill_spray_modifier then
				-- quill_spray_stacks		= quill_spray_modifier:GetStackCount()
			-- end
		
			-- local damageTable = {
				-- victim 			= enemy,
				-- damage 			= math.min(self.quill_base_damage + (self.quill_stack_damage * quill_spray_stacks), self.max_damage),
				-- damage_type		= DAMAGE_TYPE_PHYSICAL,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self.caster,
				-- ability 		= self.ability
			-- }
									
			-- ApplyDamage(damageTable)
			
			-- -- Blood particle is smaller than vanilla...but IDK how much people care about this
			-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			-- ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin())
			-- ParticleManager:ReleaseParticleIndex(particle)
			
			-- enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")
			
			-- enemy:AddNewModifier(self.caster, self.ability, "modifier_imba_bristleback_quill_spray", {duration = self.quill_stack_duration})
			
			-- table.insert(self.hit_enemies, enemy)
			
			-- if not enemy:IsAlive() and enemy:IsRealHero() and (enemy.IsReincarnating and not enemy:IsReincarnating()) then
				-- self.caster:EmitSound("bristleback_bristle_quill_spray_0"..math.random(1,6))
			-- end
		-- end
	-- end
-- end

-- -- IDK if I really need this but I'm hearing potential horror stories
-- function modifier_imba_bristleback_quillspray_thinker:OnDestroy()
	-- if not IsServer() then return end

	-- self.parent:RemoveSelf()
-- end

-- --------------------------
-- -- QUILL SPRAY MODIFIER --
-- --------------------------

-- function modifier_imba_bristleback_quill_spray:IsPurgable()	return false end

-- function modifier_imba_bristleback_quill_spray:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.radius					= self.ability:GetSpecialValueFor("radius")
	-- self.quill_base_damage		= self.ability:GetSpecialValueFor("quill_base_damage")
	-- self.quill_stack_damage		= self.ability:GetSpecialValueFor("quill_stack_damage")
	-- self.quill_stack_duration	= self.ability:GetSpecialValueFor("quill_stack_duration")
	-- self.max_damage				= self.ability:GetSpecialValueFor("max_damage")
	-- self.projectile_speed		= self.ability:GetSpecialValueFor("projectile_speed")

	-- self:IncrementStackCount()
	
	-- if not IsServer() then return end
	
	-- -- Why does the normal particle emit so many quills
	-- --if self:GetParent():IsCreep() then
		-- self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	-- --else
	-- --	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	-- --end

	-- ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- -- Stacks don't get refreshed with subsequent stacks
	-- Timers:CreateTimer(self.quill_stack_duration * (1 - self.parent:GetStatusResistance()), function()
		-- -- Really don't want errors here...
		-- if self ~= nil and not self:IsNull() and not self.ability:IsNull() and not self.parent:IsNull() and not self.caster:IsNull() then
			-- self:DecrementStackCount()
		-- end
	-- end)
-- end

-- function modifier_imba_bristleback_quill_spray:OnRefresh()
	-- if not IsServer() then return end

	-- self:OnCreated()
	
	-- -- Custom Status Resist nonsense (need to learn how to make an all-encompassing function for this...)
	-- self:SetDuration(self.quill_stack_duration * (1 - self.parent:GetStatusResistance()), true)
-- end

-- --------------------------------
-- -- QUILL SPRAY STACK MODIFIER --
-- --------------------------------

-- -- IDK why this thing uses two modifiers for vanilla seems like just one can handle it

-- -------------------------------------
-- -- QUILL SPRAY AUTOCASTER MODIFIER --
-- -------------------------------------

-- function modifier_imba_bristleback_quill_spray_autocaster:IsHidden()	return true end

-- function modifier_imba_bristleback_quill_spray_autocaster:OnCreated()
	-- if not IsServer() then return end

	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- self.cardio_threshold	= self.ability:GetSpecialValueFor("cardio_threshold")
	-- self.last_position		= self.caster:GetAbsOrigin()
	-- self.distance			= self.distance or 0

	-- self:StartIntervalThink(0.1) -- Could make this every frame but that might be too much of a crutch lul
-- end

-- function modifier_imba_bristleback_quill_spray_autocaster:OnRefresh()
	-- if not IsServer() then return end

	-- self:StartIntervalThink(-1)

	-- self:OnCreated()
-- end

-- function modifier_imba_bristleback_quill_spray_autocaster:OnIntervalThink()
	-- if not IsServer() then return end

	-- if self.ability:GetAutoCastState() and self.ability:IsFullyCastable() then
		-- self.caster:CastAbilityImmediately(self.ability, self.caster:GetPlayerID())
	-- end
	
	-- -- IMBAfication: Cardio
	-- self.distance			= self.distance + (self.caster:GetAbsOrigin() - self.last_position):Length()
	-- self.last_position		= self.caster:GetAbsOrigin()
	
	-- if self.distance >= self.cardio_threshold then
		-- self.ability:OnSpellStart()
		-- self.distance = 0
	-- end
-- end

-- -----------------
-- -- Bristleback --
-- -----------------

-- function imba_bristleback_bristleback:ResetToggleOnRespawn()	return true end

-- function imba_bristleback_bristleback:GetIntrinsicModifierName()
	-- return "modifier_imba_bristleback_bristleback"
-- end

-- -- IMBAfication: Heavy Arms Shell
-- function imba_bristleback_bristleback:OnToggle()
	-- self.caster	= self:GetCaster()

	-- if self:GetToggleState() then
		-- self.caster:AddNewModifier(self.caster, self, "modifier_imba_bristleback_bristleback_has", {})
	-- else
		-- self.caster:RemoveModifierByName("modifier_imba_bristleback_bristleback_has")
	-- end
-- end

-- --------------------------
-- -- BRISTLEBACK MODIFIER --
-- --------------------------

-- function modifier_imba_bristleback_bristleback:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.front_damage_reduction		= 0
	-- self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	-- self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	-- self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	-- self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	-- self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	
	-- self.cumulative_damage			= self.cumulative_damage or 0
-- end

-- function modifier_imba_bristleback_bristleback:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_bristleback_bristleback:DeclareFunctions()
    -- local decFuncs = {
        -- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_EVENT_ON_TAKEDAMAGE
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_bristleback_bristleback:GetModifierIncomingDamage_Percentage(keys)
	-- if self.parent:PassivesDisabled() then return 0 end

	-- local forwardVector			= self.caster:GetForwardVector()
	-- local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	-- local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
	-- local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	-- local difference = math.abs(forwardAngle - reverseEnemyAngle)

	-- --print(difference)
	
	-- -- Check for Heavy Arms Shell modifier
	-- if self.caster:HasModifier("modifier_imba_bristleback_bristleback_has") then
		-- self.front_damage_reduction		= self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		-- self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction") + self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		-- self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction") + self.ability:GetSpecialValueFor("HAS_damage_reduction_inc")
		-- self.quill_release_threshold	= self.ability:GetSpecialValueFor("HAS_quill_release_threshold")
	-- else
		-- self.front_damage_reduction		= 0
		-- self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
		-- self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
		-- self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
	-- end
	
	-- -- There's 100% a more straightforward way to calculate this but I can't think properly right now
	-- if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		-- --print("Hit the back ", (self.back_damage_reduction), "%")
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex(particle)
	
		-- local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex(particle2)
		
		-- self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		-- return self.back_damage_reduction * (-1)
	-- elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 
		-- --print("Hit the side", (self.side_damage_reduction), "%")
		-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		-- ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex(particle)
		
		-- return self.side_damage_reduction * (-1)
	-- else
		-- --print("Hit the front")
		-- return self.front_damage_reduction * (-1)
	-- end
-- end

-- function modifier_imba_bristleback_bristleback:OnTakeDamage( keys )
	-- if keys.unit == self.parent then
		-- if self.parent:PassivesDisabled() or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
	
		-- -- Pretty inefficient to calculate this stuff twice but I don't want to make these class variables due to how much damage might stack in a single frame...
		-- local forwardVector			= self.caster:GetForwardVector()
		-- local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
				
		-- local reverseEnemyVector	= (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
		-- local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

		-- local difference = math.abs(forwardAngle - reverseEnemyAngle)

		-- if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
			-- self:SetStackCount(self:GetStackCount() + keys.damage)
			
			-- local quill_spray_ability = self.parent:FindAbilityByName("imba_bristleback_quill_spray")
			
			-- if quill_spray_ability and quill_spray_ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
				-- quill_spray_ability:OnSpellStart()
				-- -- IMBAfication: Overflow Harnessing
				-- self:SetStackCount(self:GetStackCount() - self.quill_release_threshold)
			-- end
		-- end
	-- end
-- end

-- -------------------------------------------
-- -- BRISTLEBACK HEAVY ARMS SHELL MODIFIER --
-- -------------------------------------------

-- function modifier_imba_bristleback_bristleback_has:IsPurgable() return false end

-- function modifier_imba_bristleback_bristleback_has:OnCreated()
	-- self.parent	= self:GetParent()
	
	-- if not IsServer() then return end

	-- self.particle = ParticleManager:CreateParticle("particles/econ/items/pangolier/pangolier_ti8_immortal/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	-- ParticleManager:SetParticleControl(self.particle, 1, self.parent:GetAbsOrigin())
	-- ParticleManager:SetParticleControl(self.particle, 3, Vector(50, 0, 0))
	-- self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- self.parent:EmitSound("Imba.BristlebackHASStart")
-- end

-- function modifier_imba_bristleback_bristleback_has:CheckState(keys)
	-- local state = {
	-- [MODIFIER_STATE_ROOTED] = true,
	-- [MODIFIER_STATE_DISARMED] = true
	-- }

	-- return state
-- end

-- -------------
-- -- Warpath --
-- -------------

-- function imba_bristleback_warpath:GetIntrinsicModifierName()
	-- return "modifier_imba_bristleback_warpath"
-- end

-- ----------------------
-- -- WARPATH MODIFIER --
-- ----------------------

-- function modifier_imba_bristleback_warpath:IsHidden()
	-- if self:GetStackCount() >= 1 then 
		-- return false
	-- else
		-- return true
	-- end
-- end

-- function modifier_imba_bristleback_warpath:DestroyOnExpire() return false end

-- function modifier_imba_bristleback_warpath:GetEffectName()
	-- if self:GetStackCount() >= 1 then 
		-- return "particles/units/heroes/hero_bristleback/bristleback_warpath_dust.vpcf"
	-- end
-- end

-- function modifier_imba_bristleback_warpath:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.damage_per_stack		= self.ability:GetSpecialValueFor("damage_per_stack") + self.caster:FindTalentValue("special_bonus_imba_bristleback_3")
	-- self.move_speed_per_stack	= self.ability:GetSpecialValueFor("move_speed_per_stack")
	-- self.stack_duration			= self.ability:GetSpecialValueFor("stack_duration")
	-- self.max_stacks				= self.ability:GetSpecialValueFor("max_stacks")
	
	-- self.counter				= self.counter or 0
	-- self.particle_table			= self.particle_table or {}
-- end

-- function modifier_imba_bristleback_warpath:OnRefresh()
	-- self:OnCreated()
-- end

-- function modifier_imba_bristleback_warpath:DeclareFunctions()
	-- local decFuncs = {
		-- MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        -- MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		-- MODIFIER_PROPERTY_MODEL_SCALE,
		-- -- IMBAfication: I Swear On Me Mum
		-- MODIFIER_EVENT_ON_HERO_KILLED
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_bristleback_warpath:GetModifierPreAttack_BonusDamage(keys)
	-- if not self.parent:IsIllusion() then
		-- -- Need to call this somewhere other than OnCreated since it can be boosted by talent
		-- self.damage_per_stack		= self.ability:GetSpecialValueFor("damage_per_stack") + self.caster:FindTalentValue("special_bonus_imba_bristleback_3")
		
		-- return self.damage_per_stack * self:GetStackCount()
	-- end
-- end

-- function modifier_imba_bristleback_warpath:GetModifierMoveSpeedBonus_Percentage(keys)
	-- return self.move_speed_per_stack * self:GetStackCount()
-- end

-- -- Gonna ignore the mechanic that updates stacks for illusions too for now
-- function modifier_imba_bristleback_warpath:OnAbilityFullyCast(keys)
	-- if keys.ability and keys.unit == self.parent and not self.parent:PassivesDisabled() and not keys.ability:IsItem() then
		
		-- -- Keep a separate variable for "virtual" stacks so as to proper handle refreshing and decrementing when going past standard max stacks
		-- self.counter = self.counter + 1
		
		-- self:SetStackCount(math.min(self.counter, self.max_stacks))
		
		-- if self:GetStackCount() < self.max_stacks then
			-- local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_warpath.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			-- ParticleManager:SetParticleControlEnt(particle, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControlEnt(particle, 4, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
			-- table.insert(self.particle_table, particle)
		-- end
		
		-- self:SetDuration(self.stack_duration, true)
		
		-- -- Stacks don't get refreshed with subsequent stacks
		-- Timers:CreateTimer(self.stack_duration, function()
			-- if self ~= nil and not self:IsNull() and not self.ability:IsNull() and not self.parent:IsNull() and not self.caster:IsNull() and self:GetStackCount() > 0 then
				-- self.counter = self.counter - 1
				
				-- self:SetStackCount(math.min(self.counter, self.max_stacks))

				-- if #self.particle_table > 0 then
					-- ParticleManager:DestroyParticle(self.particle_table[1], false)
					-- ParticleManager:ReleaseParticleIndex(self.particle_table[1])
					-- table.remove(self.particle_table, 1)
				-- end
			-- end
		-- end)
	-- end
-- end

-- function modifier_imba_bristleback_warpath:GetModifierModelScale()
	-- return self:GetStackCount() * 5
-- end

-- function modifier_imba_bristleback_warpath:OnHeroKilled(keys)
	-- if keys.target == self.caster and keys.attacker ~= self.caster then
		-- keys.attacker:AddNewModifier(self.caster, self.ability, "modifier_imba_bristleback_warpath_revenge", {})
	-- end
-- end

-- ----------------------------
-- -- WARPATH STACK MODIFIER --
-- ----------------------------

-- -- Nothing to see here...

-- ------------------------------
-- -- WARPATH REVENGE MODIFIER --
-- ------------------------------

-- function modifier_imba_bristleback_warpath_revenge:IsPurgable()		return false end
-- function modifier_imba_bristleback_warpath_revenge:RemoveOnDeath()	return false end

-- function modifier_imba_bristleback_warpath_revenge:OnCreated()
	-- self.ability	= self:GetAbility()
	-- self.caster		= self:GetCaster()
	-- self.parent		= self:GetParent()
	
	-- -- AbilitySpecials
	-- self.revenge_inc_dmg_pct	= self.ability:GetSpecialValueFor("revenge_inc_dmg_pct")
-- end

-- function modifier_imba_bristleback_warpath_revenge:OnRefresh()	
	-- self:SetStackCount(self:GetStackCount() + self.revenge_inc_dmg_pct)
-- end

-- function modifier_imba_bristleback_warpath_revenge:DeclareFunctions()
    -- local decFuncs = {
        -- MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		-- MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_PROPERTY_TOOLTIP
    -- }

    -- return decFuncs
-- end

-- function modifier_imba_bristleback_warpath_revenge:GetModifierIncomingDamage_Percentage(keys)
	-- if keys.target == self.parent then
		-- if keys.attacker == self.caster then
			-- return self:GetStackCount()
		-- else
			-- return 0
		-- end
	-- end
-- end

-- function modifier_imba_bristleback_warpath_revenge:OnDeath(keys)
	-- if keys.unit == self.parent and keys.attacker == self.caster then
		-- self:Destroy()
	-- end
-- end

-- function modifier_imba_bristleback_warpath_revenge:OnTooltip()
	-- return self:GetStackCount()
-- end

-- ---------------------
-- -- TALENT HANDLERS --
-- ---------------------

-- -- Gonna leave everything here vanilla for now cause his talents seem really strong as is and I don't want to destroy the balance and thematics for now

-- -- # Talents
-- -- * Level 10: +3 Mana Regen | +20 Movement Speed
-- -- * Level 15: +6 Max Goo Stacks | +250 Health
-- -- * Level 20: +25 Quill Stack Damage | +25 Health Regen
-- -- * Level 25: +30 Warpath Damage Per Stack | 15% Spell Lifesteal

-- -- Client-side helper functions --

-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_1", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_2", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
 -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_3", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_4", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_5", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_6", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_7", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)
-- -- LinkLuaModifier("modifier_special_bonus_imba_bristleback_8", "components/abilities/heroes/hero_bristleback", LUA_MODIFIER_MOTION_NONE)

-- -- modifier_special_bonus_imba_bristleback_1		= class({})
-- -- modifier_special_bonus_imba_bristleback_2		= class({})
 -- modifier_special_bonus_imba_bristleback_3		= class({})
-- -- modifier_special_bonus_imba_bristleback_4		= class({})
-- -- modifier_special_bonus_imba_bristleback_5		= class({})
-- -- modifier_special_bonus_imba_bristleback_6		= class({})
-- -- modifier_special_bonus_imba_bristleback_7		= class({})
-- -- modifier_special_bonus_imba_bristleback_8		= class({})

-- -- -----------------------
-- -- -- TALENT 1 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_1:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_1:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_1:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 2 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_2:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_2:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_2:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 3 MODIFIER --
-- -- -----------------------
-- -- +30 Warpath Damage Per Stack
-- function modifier_special_bonus_imba_bristleback_3:IsHidden() 			return true end
-- function modifier_special_bonus_imba_bristleback_3:IsPurgable() 		return false end
-- function modifier_special_bonus_imba_bristleback_3:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 4 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_4:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_4:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_4:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 5 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_5:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_5:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_5:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 6 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_6:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_6:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_6:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 7 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_7:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_7:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_7:RemoveOnDeath() 		return false end

-- -- -----------------------
-- -- -- TALENT 8 MODIFIER --
-- -- -----------------------
-- -- function modifier_special_bonus_imba_bristleback_8:IsHidden() 			return true end
-- -- function modifier_special_bonus_imba_bristleback_8:IsPurgable() 		return false end
-- -- function modifier_special_bonus_imba_bristleback_8:RemoveOnDeath() 		return false end

-- function imba_bristleback_warpath:OnOwnerSpawned()
	-- if self:GetCaster():HasTalent("modifier_special_bonus_imba_bristleback_3") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_bristleback_3") then
		-- self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_bristleback_3"), "modifier_special_bonus_imba_bristleback_3", {})
	-- end
-- end
