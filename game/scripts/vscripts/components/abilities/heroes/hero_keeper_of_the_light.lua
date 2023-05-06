-- Creator:
--	   AltiV, March 1st, 2019

LinkLuaModifier("modifier_imba_keeper_of_the_light_illuminate_self_thinker", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_spirit_form_illuminate", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_blinding_light", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_blinding_light_knockback", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_keeper_of_the_light_chakra_magic", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_mana_leak", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_recall", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_spotlights", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp_aura", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_keeper_of_the_light_will_o_wisp_blessing", "components/abilities/heroes/hero_keeper_of_the_light.lua", LUA_MODIFIER_MOTION_NONE)

imba_keeper_of_the_light_illuminate							= class({})
modifier_imba_keeper_of_the_light_illuminate_self_thinker	= class({}) -- Custom class for attempting non-channel logic
modifier_imba_keeper_of_the_light_illuminate				= class({})
modifier_imba_keeper_of_the_light_spirit_form_illuminate	= class({})

imba_keeper_of_the_light_illuminate_end						= class({})

imba_keeper_of_the_light_blinding_light						= class({})
modifier_imba_keeper_of_the_light_blinding_light			= class({})
modifier_imba_blinding_light_knockback						= class({})		

imba_keeper_of_the_light_chakra_magic						= class({})
modifier_imba_keeper_of_the_light_chakra_magic				= class({})

modifier_imba_keeper_of_the_light_mana_leak					= class({})

imba_keeper_of_the_light_recall								= class({})
modifier_imba_keeper_of_the_light_recall					= class({})

imba_keeper_of_the_light_spotlights							= class({})
modifier_imba_keeper_of_the_light_spotlights				= class({})

imba_keeper_of_the_light_will_o_wisp						= class({})
modifier_imba_keeper_of_the_light_will_o_wisp				= class({})
modifier_imba_keeper_of_the_light_will_o_wisp_aura			= class({})
modifier_imba_keeper_of_the_light_will_o_wisp_blessing		= class({})

----------------
-- ILLUMINATE --
----------------

function imba_keeper_of_the_light_illuminate:GetAssociatedSecondaryAbilities()
	return "imba_keeper_of_the_light_illuminate_end"
end

-- Level-up of Illuminate also levels up the Illuminate End ability
function imba_keeper_of_the_light_illuminate:OnUpgrade()
	if not IsServer() then return end
	
	local illuminate_end = self:GetCaster():FindAbilityByName("imba_keeper_of_the_light_illuminate_end")
	
	if illuminate_end then
		illuminate_end:SetLevel(self:GetLevel())
	end
end

function imba_keeper_of_the_light_illuminate:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	self.caster		= self:GetCaster()

	-- Get the position of where Illuminate was cast towards
	self.position	= self:GetCursorPosition()

	-- Emit casting sound
	self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Charge")
	
	self.caster:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_illuminate_self_thinker", {duration = self:GetSpecialValueFor("max_channel_time")})
end

function imba_keeper_of_the_light_illuminate:OnChannelThink()
	-- Logic was moved to the "modifier_imba_keeper_of_the_light_illuminate_self_thinker" modifier's OnIntervalThink(FrameTime())
end

function imba_keeper_of_the_light_illuminate:OnChannelFinish(bInterrupted)
	-- Logic was moved to the "modifier_imba_keeper_of_the_light_illuminate_self_thinker" modifier's OnDestroy()
end

-----------------------------
-- ILLUMINATE SELF THINKER --
-----------------------------

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:IsPurgable()	return false end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_spirit_form_ambient.vpcf"
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.damage_per_second				= self.ability:GetSpecialValueFor("damage_per_second")
	self.max_channel_time				= self.ability:GetSpecialValueFor("max_channel_time")
	--self.radius						= self.ability:GetSpecialValueFor("radius")
	self.range							= self.ability:GetSpecialValueFor("range")
	self.speed							= self.ability:GetSpecialValueFor("speed")
	self.vision_radius					= self.ability:GetSpecialValueFor("vision_radius")
	self.vision_duration				= self.ability:GetSpecialValueFor("vision_duration")
	self.channel_vision_radius			= self.ability:GetSpecialValueFor("channel_vision_radius")
	self.channel_vision_interval		= self.ability:GetSpecialValueFor("channel_vision_interval")
	self.channel_vision_duration		= self.ability:GetSpecialValueFor("channel_vision_duration")
	self.channel_vision_step			= self.ability:GetSpecialValueFor("channel_vision_step")
	self.total_damage					= self.ability:GetSpecialValueFor("total_damage")
	self.transient_form_ms_reduction	= self.ability:GetSpecialValueFor("transient_form_ms_reduction")
	
	-- Save the position of the caster into variable (since caster might move before wave is fired)
	self.caster_location	= self.caster:GetAbsOrigin()
	
	-- Get the position of where Illuminate was cast towards
	self.position			= self.ability.position

	-- Distance between vision nodes (vanilla is 150 but this has better vision spread)
	self.vision_node_distance	= self.channel_vision_radius * 0.5
	
	if not IsServer() then return end
	
	-- Calculate direction for which Illuminate is going to travel
	self.direction	= (self.position - self.caster_location):Normalized()
	
	-- Get the time that the channel starts
	self.game_time_start		= GameRules:GetGameTime()
	
	-- Keep a counter for the vision spots that slowly build as channeling continues
	self.vision_counter 		= 1
	self.vision_time_count		= GameRules:GetGameTime()
	
	-- Emit glowing staff particle
	self.weapon_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate_cast.vpcf", PATTACH_POINT_FOLLOW, self.caster)
	ParticleManager:SetParticleControlEnt(self.weapon_particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
	self:AddParticle(self.weapon_particle, false, false, -1, false, false)
	
	self.caster:SwapAbilities("imba_keeper_of_the_light_illuminate", "imba_keeper_of_the_light_illuminate_end", false, true)
	
	-- I can't restore the standard spirit form models so I'll have to use some abstractions...
	local horse_thinker = 	CreateModifierThinker(self.caster, self.ability, nil, {duration = self.max_channel_time}, self.caster_location, self.caster:GetTeamNumber(), false)
	
	-- CreateUnitByName("npc_dummy_unit", self.caster_location, true, self.caster, self.caster, self.caster:GetTeam())
	
	self.spirit = horse_thinker
	-- Set the unit/horse facing in the direction of where the wave will shoot
	horse_thinker:SetForwardVector(self.direction)
	horse_thinker:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_spirit_form_illuminate", {duration = self.duration})
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:OnIntervalThink()
	if not IsServer() then return end
	
	-- Every 0.5 seconds, create a visibility node further ahead
	if GameRules:GetGameTime() - self.vision_time_count >= self.channel_vision_interval then
		self.vision_time_count = GameRules:GetGameTime()
		self.ability:CreateVisibilityNode(self.caster_location + (self.direction * self.channel_vision_step * self.vision_counter), self.channel_vision_radius, self.channel_vision_duration)
		self.vision_counter = self.vision_counter + 1
	end
	
	self:SetStackCount(math.min((GameRules:GetGameTime() - self.game_time_start + self.ability:GetCastPoint()) * self.damage_per_second, self.total_damage))
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:OnDestroy()
	if not IsServer() then return end

	self.direction					= (self.position - self.caster_location):Normalized()
	self.duration 					= self.range / self.speed

	self.game_time_end				= GameRules:GetGameTime()
	
	self.caster:EmitSound("Hero_KeeperOfTheLight.Illuminate.Discharge")

	self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
	
	CreateModifierThinker(self.caster, self.ability, "modifier_imba_keeper_of_the_light_illuminate", {
		duration		= self.range / self.speed,
		direction_x 	= self.direction.x,	-- x direction of where Illuminate will travel
		direction_y 	= self.direction.y,	-- y direction of where Illuminate will travel
		channel_time 	= self.game_time_end - self.game_time_start	-- total time Illuminate was channeled for
	}, 
	self.caster_location, self.caster:GetTeamNumber(), false)
	
	-- Swap the main ability back in
	self.caster:SwapAbilities("imba_keeper_of_the_light_illuminate_end", "imba_keeper_of_the_light_illuminate", false, true)
	
	-- Remove the "spirit" channeling Illuminate
	if self.spirit then
		self.spirit:RemoveSelf()
	end
	
	-- Voice response
	if self.caster:GetName() == "npc_dota_hero_keeper_of_the_light" then
		if RollPercentage(5) then
			self.caster:EmitSound("keeper_of_the_light_keep_illuminate_06")
		elseif RollPercentage(50) then
			if RollPercentage(50) then
				self.caster:EmitSound("keeper_of_the_light_keep_illuminate_05")
			else
				self.caster:EmitSound("keeper_of_the_light_keep_illuminate_07")
			end
		end
	end
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:GetModifierMoveSpeedBonus_Percentage()
	if not self.caster:HasScepter() then
		return self.transient_form_ms_reduction * (-1)
	end
end

function modifier_imba_keeper_of_the_light_illuminate_self_thinker:CheckState()
	if IsServer() and not self.ability:IsChanneling() and self.caster:HasTalent("special_bonus_imba_keeper_of_the_light_travelling_light") then
		return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	end
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
	--self.max_channel_time			= self.ability:GetSpecialValueFor("max_channel_time")
	self.radius						= self.ability:GetSpecialValueFor("radius")
	--self.range						= self.ability:GetSpecialValueFor("range")
	self.speed						= self.ability:GetSpecialValueFor("speed")
	--self.vision_radius				= self.ability:GetSpecialValueFor("vision_radius")
	--self.vision_duration			= self.ability:GetSpecialValueFor("vision_duration")
	--self.channel_vision_radius		= self.ability:GetSpecialValueFor("channel_vision_radius")
	--self.channel_vision_interval	= self.ability:GetSpecialValueFor("channel_vision_interval")
	--self.channel_vision_duration	= self.ability:GetSpecialValueFor("channel_vision_duration")
	--self.channel_vision_step		= self.ability:GetSpecialValueFor("channel_vision_step")
	self.total_damage				= self.ability:GetSpecialValueFor("total_damage")

	self.duration			= params.duration
	self.direction			= Vector(params.direction_x, params.direction_y, 0)
	self.direction_angle	= math.deg(math.atan2(self.direction.x, self.direction.y))
	self.channel_time		= params.channel_time
	
	-- Create the Illuminate particle with CP1 being the velocity and CP3 being the origin
	-- Why is the circle particle so bright
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/kotl_illuminate.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, self.direction * self.speed)
	ParticleManager:SetParticleControl(self.particle, 3, self.parent:GetAbsOrigin())
	
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	-- Initialize table of enemies hit so we don't hit things more than once
	self.hit_targets = {}
	
	self:OnIntervalThink()
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_keeper_of_the_light_illuminate:OnIntervalThink()
	if not IsServer() then return end

	local targets 	= FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage	= math.min((self.channel_time + self.ability:GetCastPoint()) * self.damage_per_second, self.total_damage)
	
	local valid_targets	=	{}
	
	-- Borrowed from Bristleback logic which I still don't fully understand, but essentially this checks to make sure the target is within the "front" of the wave, because the local targets table returns everything in a circle
	for _, target in pairs(targets) do
		local target_pos 	= target:GetAbsOrigin()
		local target_angle	= math.deg(math.atan2((target_pos.x - self.parent:GetAbsOrigin().x), target_pos.y - self.parent:GetAbsOrigin().y))
		
		local difference = math.abs(self.direction_angle - target_angle)
		
		-- If the enemy's position is not within the front semi-circle, remove them from the table
		if difference <= 90 or difference >= 270 then
			table.insert(valid_targets, target)
		end
	end
	
	-- By the end, the valid_targets table SHOULD have every unit that's actually in the "front" (semi-circle) of the wave, aka they should actually be hit by the wave
	for _, target in pairs(valid_targets) do
	
		local hit_already = false
	
		for _, hit_target in pairs(self.hit_targets) do
			if hit_target == target then
				hit_already = true
				break
			end
		end
		
		if not hit_already then
			-- Deal damage to enemies...
			if target:GetTeam() ~= self.caster:GetTeam() then
				local damage_type	= DAMAGE_TYPE_MAGICAL
				
				if self.caster:HasTalent("special_bonus_imba_keeper_of_the_light_pure_illuminate") then
					damage_type		= DAMAGE_TYPE_PURE
				end
			
				local damageTable = {
					victim 			= target,
					-- Damage starts ramping from when cast time starts, so just gonna simiulate the effects by adding the cast point
					damage 			= damage,
					damage_type		= damage_type,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self.caster,
					ability 		= self.ability
				}
				
				ApplyDamage(damageTable)
				
				-- Spotlights
				local spotlight_modifier = self.caster:FindModifierByName("modifier_imba_keeper_of_the_light_spotlights")
				
				if spotlight_modifier then
					spotlight_modifier:Spotlight(target:GetAbsOrigin(), self.radius, spotlight_modifier:GetAbility():GetSpecialValueFor("attack_duration"))
				end
			--...and heal allies
			elseif GameRules:IsDaytime() and self.caster:HasScepter() then
				target:Heal(damage, self.caster)
				
				-- Apparently the vanilla skill only shows the heal number if it's a hero?...
				if target:IsHero() then
					SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, damage, nil)
				end
			end
			
			-- Apply sounds (wave sound + horse sounds)
			target:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target")
			target:EmitSound("Hero_KeeperOfTheLight.Illuminate.Target.Secondary")
			
			-- Apply the "hit by Illuminate" particle
			local particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact_small.vpcf"
			
			-- Heroes get a larger particle (supposedly)
			if target:IsHero() then
				particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_illuminate_impact.vpcf"
			end
			
			local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Add the target to the list of targets hit so they can't get hit again
			table.insert(self.hit_targets, target)
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

-------------------------------------
-- ILLUMINATE SPIRIT FORM MODIFIER --
-------------------------------------

function modifier_imba_keeper_of_the_light_spirit_form_illuminate:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end

function modifier_imba_keeper_of_the_light_spirit_form_illuminate:CheckState()
	return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
end

function modifier_imba_keeper_of_the_light_spirit_form_illuminate:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MODEL_CHANGE
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_spirit_form_illuminate:GetModifierModelChange()
	return "models/items/keeper_of_the_light/ti7_immortal_mount/kotl_ti7_immortal_horsefx_proxy.vmdl"
end

--------------------
-- ILLUMINATE END --
--------------------

function imba_keeper_of_the_light_illuminate_end:GetAssociatedPrimaryAbilities()
	return "imba_keeper_of_the_light_illuminate"
end

function imba_keeper_of_the_light_illuminate_end:ProcsMagicStick() return false end

function imba_keeper_of_the_light_illuminate_end:OnSpellStart()
	if not IsServer() then return end

	self.caster	= self:GetCaster()
	
	-- Check if the caster has the Illuminate ability
	local illuminate	= self.caster:FindAbilityByName("imba_keeper_of_the_light_illuminate")
	
	if illuminate then
		
		-- Then check if the caster is currently "channeling" the illuminate (which they should be if this end ability is castable in the first place)
		local illuminate_self_thinker = self.caster:FindModifierByName("modifier_imba_keeper_of_the_light_illuminate_self_thinker")

		-- If so, destroy it (which will release the wave)
		if illuminate_self_thinker then
			illuminate_self_thinker:Destroy()
		end
	end
end

--------------------
-- BLINDING LIGHT --
--------------------

function imba_keeper_of_the_light_blinding_light:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) * (math.max(self:GetCaster():FindTalentValue("special_bonus_imba_keeper_of_the_light_luminous_burster", "cooldown_mult"), 1))
end

-- Strobe IMBAfication will be an "opt-out" add-on
function imba_keeper_of_the_light_blinding_light:OnUpgrade()
	if self:GetLevel() == 1 then
		self:ToggleAutoCast()
	end
end

function imba_keeper_of_the_light_blinding_light:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

function imba_keeper_of_the_light_blinding_light:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_keeper_of_the_light_blinding_light:OnSpellStart()
	self.caster		= self:GetCaster()
	
	-- AbilitySpecials
	self.miss_rate				= self:GetSpecialValueFor("miss_rate")
	self.duration				= self:GetSpecialValueFor("duration")
	self.radius					= self:GetSpecialValueFor("radius")
	self.knockback_duration		= self:GetSpecialValueFor("knockback_duration")
	self.knockback_distance		= self:GetSpecialValueFor("knockback_distance")
	self.damage					= self:GetSpecialValueFor("damage")
	self.cast_range_tooltip		= self:GetSpecialValueFor("cast_range_tooltip")
	self.strobe_count			= self:GetSpecialValueFor("strobe_count")
	self.strobe_delay			= self:GetSpecialValueFor("strobe_delay")
	
	if not IsServer() then return end
	
	if self.caster:GetName() == "npc_dota_hero_keeper_of_the_light" and RollPercentage(15) then
		self.caster:EmitSound("keeper_of_the_light_keep_illuminate_02")
	end
	
	-- IMBAfication: Strobe
	local counter 	= 1
	local position	= self:GetCursorPosition()
	
	Timers:CreateTimer(0, function()
		self:Pulse(position)
		
		if self:GetAutoCastState() and counter <= self.strobe_count then
			counter = counter + 1
			return self.strobe_delay
		end
	end)
	
	if self.caster:HasTalent("special_bonus_imba_keeper_of_the_light_luminous_burster") then
		local bursts			= 0
		local max_bursts		= self.caster:FindTalentValue("special_bonus_imba_keeper_of_the_light_luminous_burster")
		local burst_delay		= self.caster:FindTalentValue("special_bonus_imba_keeper_of_the_light_luminous_burster", "delay")
		
		local burst_direction	= (position - self.caster:GetAbsOrigin()):Normalized()
		
		Timers:CreateTimer(burst_delay, function()
			local burst_position	= position + (burst_direction * self.radius * (bursts + 1))
		
			self:Pulse(burst_position)
			
			bursts = bursts + 1
			
			if bursts < max_bursts then
				return burst_delay
			end
		end)
	end
end

function imba_keeper_of_the_light_blinding_light:Pulse(position)
	if not IsServer() then return end

	-- Emit sound
	self.caster:EmitSound("Hero_KeeperOfTheLight.BlindingLight")
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", PATTACH_POINT_FOLLOW, self.caster, self.caster)
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, position)
	ParticleManager:SetParticleControl(particle, 2, Vector(self.radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle)
	
	-- Spotlights
	local spotlight_modifier = self.caster:FindModifierByName("modifier_imba_keeper_of_the_light_spotlights")
	
	if spotlight_modifier then
		spotlight_modifier:Spotlight(position, self.radius, spotlight_modifier:GetAbility():GetSpecialValueFor("attack_duration"))
	end
	
	-- Apply Blinding Light modifier and blind to all applicable enemies in radius
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim 			= enemy,
			damage 			= self.damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self.caster,
			ability 		= self
		}
								
		ApplyDamage(damageTable)
		
		enemy:FaceTowards(position * (-1))
		enemy:SetForwardVector((enemy:GetAbsOrigin() - position):Normalized())
		
		-- nil checks cause of timer shenanigans
		enemy:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_blinding_light", {duration = self.duration * (1 - enemy:GetStatusResistance())})
		
		if enemy:HasModifier("modifier_imba_blinding_light_knockback") then
			enemy:FindModifierByName("modifier_imba_blinding_light_knockback"):Destroy()
		end
		
		enemy:AddNewModifier(self.caster, self, "modifier_imba_blinding_light_knockback", {x = position.x, y = position.y, z = position.z, duration = self.knockback_duration * (1 - enemy:GetStatusResistance())})
	end
end

-----------------------------
-- BLINDING LIGHT MODIFIER --
-----------------------------

function modifier_imba_keeper_of_the_light_blinding_light:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end

function modifier_imba_keeper_of_the_light_blinding_light:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.miss_rate				= self.ability:GetSpecialValueFor("miss_rate")
end

function modifier_imba_keeper_of_the_light_blinding_light:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_blinding_light:GetModifierMiss_Percentage()
    return self.miss_rate
end

------------------------------
-- BLINDING LIGHT KNOCKBACK --
------------------------------

function modifier_imba_blinding_light_knockback:IsHidden() return true end

function modifier_imba_blinding_light_knockback:OnCreated(params)
	if not IsServer() then return end
	
	self.ability				= self:GetAbility()
	self.parent					= self:GetParent()
	
	-- AbilitySpecials
	self.knockback_duration		= self.ability:GetSpecialValueFor("knockback_duration")
	self.knockback_distance		= self.ability:GetSpecialValueFor("knockback_distance")
	
	-- Calculate speed at which modifier owner will be knocked back
	self.knockback_speed		= self.knockback_distance / self.knockback_duration
	
	-- Get the center of the Blinding Light sphere to know which direction to get knocked back
	self.position	= Vector(params.x, params.y, params.z)

	self.parent:StartGesture(ACT_DOTA_FLAIL)
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_imba_blinding_light_knockback:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = (me:GetOrigin() - self.position):Normalized()
	
	me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )
end

function modifier_imba_blinding_light_knockback:OnDestroy()
	if not IsServer() then return end

	-- Destroy trees around landing zone
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), 150, true )
	
	self.parent:FadeGesture(ACT_DOTA_FLAIL)
	
	self.parent:RemoveHorizontalMotionController( self )
	-- self:GetParent():InterruptMotionControllers( true )
	
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

function modifier_imba_blinding_light_knockback:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_DISABLE_TURNING
    }

    return decFuncs
end

function modifier_imba_blinding_light_knockback:GetModifierDisableTurning()
	return 1
end

------------------
-- CHAKRA MAGIC --
------------------

function imba_keeper_of_the_light_chakra_magic:OnAbilityPhaseStart()
	if self:GetCursorTarget():GetTeam() ~= self:GetCaster():GetTeam() then
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
	end
	
	return true
end

function imba_keeper_of_the_light_chakra_magic:OnAbilityPhaseInterrupted()
	if self:GetCursorTarget():GetTeam() ~= self:GetCaster():GetTeam() then
		self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2)
	end
end

function imba_keeper_of_the_light_chakra_magic:OnSpellStart()
	self.caster		= self:GetCaster()
	self.target		= self:GetCursorTarget()
	
	-- AbilitySpecials
	self.mana_restore		= self:GetSpecialValueFor("mana_restore")
	self.cooldown_reduction	= self:GetSpecialValueFor("cooldown_reduction")
	self.duration			= self:GetSpecialValueFor("duration")
	-- self.mana_leak_pct		= self:GetSpecialValueFor("mana_leak_pct")
	-- self.stun_duration		= self:GetSpecialValueFor("stun_duration")
	
	if not IsServer() then return end
	
	if self.target:GetTeam() == self.caster:GetTeam() then
		-- Emit cast sound
		self.caster:EmitSound("Hero_KeeperOfTheLight.ChakraMagic.Target")
		
		-- Emit particle
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", PATTACH_POINT_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, self.target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		
		-- The lengths we go to to replicate hero responses (nah prob just me)
		if self.caster:GetName() == "npc_dota_hero_keeper_of_the_light" then
			if RollPercentage(15) then
				self.caster:EmitSound("keeper_of_the_light_keep_chakramagic_02")
			elseif RollPercentage(25) then
				if self.caster == self.target then
					self.caster:EmitSound("keeper_of_the_light_keep_chakramagic_06")
				else
					if RollPercentage(50) then
						self.caster:EmitSound("keeper_of_the_light_keep_chakramagic_03")
					else
						self.caster:EmitSound("keeper_of_the_light_keep_chakramagic_06")
					end
				end
			end
		end
		
		self.target:GiveMana(self.mana_restore)
		
		-- Apparently the vanilla skill only shows the mana number if it's a hero?...
		if self.target:IsHero() then
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.target, self.mana_restore, nil)
		end
		
		for abilities = 0, 23 do
			local ability = self.target:GetAbilityByIndex(abilities)
		
			if ability and ability:GetAbilityType() ~= ABILITY_TYPE_ULTIMATE and ability ~= self then
				local remaining_cooldown = ability:GetCooldownTimeRemaining()
				
				if remaining_cooldown > 0 then
					ability:EndCooldown()
					ability:StartCooldown(math.max(remaining_cooldown - self.cooldown_reduction, 0))
				end
			end
		end
	-- Enemy logic
	else
		if self.target:TriggerSpellAbsorb(self) then return end
	
		-- Emit cast sound
		self.caster:EmitSound("Imba.Hero_KeeperOfTheLight.ManaLeak.Cast")
		self.target:EmitSound("Imba.Hero_KeeperOfTheLight.ManaLeak.Target")
		self.target:EmitSound("Imba.Hero_KeeperOfTheLight.ManaLeak.Target.FP")
		
		--particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf CP0
		--particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak_cast.vpcf CP0 CP1
		
		-- Emit particle
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak_cast.vpcf", PATTACH_POINT_FOLLOW, self.caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle, 1, self.target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.particle)
		
		if self.caster:GetName() == "npc_dota_hero_keeper_of_the_light" then
			if RollPercentage(50) then
				self.caster:EmitSound("keeper_of_the_light_keep_manaleak_0"..math.random(1, 5))
			end
		end
		
		-- IMBAfication: Mana Leak
		self.target:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_mana_leak", {duration = self.duration * (1 - self.target:GetStatusResistance())})
		
		-- Flow Inhibition Talent
		if self.caster:HasTalent("special_bonus_imba_keeper_of_the_light_flow_inhibition") then
			local inhibition_multiplier = self.caster:FindTalentValue("special_bonus_imba_keeper_of_the_light_flow_inhibition")
		
			self.target:ReduceMana(self.mana_restore * inhibition_multiplier)
			
			-- Apparently the vanilla skill only shows the mana number if it's a hero?...
			if self.target:IsHero() then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self.target, self.mana_restore * inhibition_multiplier, nil)
			end
			
			for abilities = 0, 23 do
				local ability = self.target:GetAbilityByIndex(abilities)
			
				if ability and ability:GetAbilityType() ~= ABILITY_TYPE_ULTIMATE then
					local remaining_cooldown = ability:GetCooldownTimeRemaining()
					
					ability:EndCooldown()
					ability:StartCooldown(remaining_cooldown + (self.cooldown_reduction * inhibition_multiplier))
				end
			end
		end
	end
end

---------------
-- MANA LEAK --
---------------

function modifier_imba_keeper_of_the_light_mana_leak:GetTexture()
	return "keeper_of_the_light_mana_leak"
end

-- function modifier_imba_keeper_of_the_light_mana_leak:GetEffectName()
	-- return "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf"
-- end

function modifier_imba_keeper_of_the_light_mana_leak:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	-- AbilitySpecials
	self.mana_leak_pct		= self.ability:GetSpecialValueFor("mana_leak_pct")
	self.stun_duration		= self.ability:GetSpecialValueFor("stun_duration")
	
	if not IsServer() then return end
	
	self.starting_position	= self.parent:GetAbsOrigin()
	
	if self.parent:GetMaxMana() <= 0 then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration * (1 - self.parent:GetStatusResistance())})
		self:Destroy()
	else
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(particle)
		self:StartIntervalThink(0.1)
	end
end

function modifier_imba_keeper_of_the_light_mana_leak:OnRefresh()
	self:OnCreated()
end

function modifier_imba_keeper_of_the_light_mana_leak:OnIntervalThink()
	if not IsServer() then return end
	
	local new_position		= self.parent:GetAbsOrigin()
	local distance			= (self.starting_position - new_position):Length2D()
	local max_mana			= self.parent:GetMaxMana()
	
	if distance > 0 and distance <= 300 then
		self.parent:ReduceMana((distance * 0.01) * (max_mana * self.mana_leak_pct * 0.01))
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(particle)
	end
	
	if self.parent:GetMana() <= 0 then
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration * (1 - self.parent:GetStatusResistance())})
		self:Destroy()
	end
	
	self.starting_position = new_position
end

function modifier_imba_keeper_of_the_light_mana_leak:OnDestroy()
	if not IsServer() then return end

	self.parent:StopSound("Imba.Hero_KeeperOfTheLight.ManaLeak.Target.FP")
end

function modifier_imba_keeper_of_the_light_mana_leak:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ORDER
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_mana_leak:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self.parent and (keys.order_type == 1 or keys.order_type == 2 or keys.order_type == 3) then
		-- Spotlights
		local spotlight_modifier = self.caster:FindModifierByName("modifier_imba_keeper_of_the_light_spotlights")
		
		if spotlight_modifier then
			spotlight_modifier:Spotlight(self.parent:GetAbsOrigin(), spotlight_modifier:GetAbility():GetSpecialValueFor("passive_radius"), spotlight_modifier:GetAbility():GetSpecialValueFor("damaged_duration"))
		end
	end
end

------------
-- RECALL --
------------

function imba_keeper_of_the_light_recall:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() then
		self:SetHidden(false)
	else
		self:SetHidden(true)
	end
end

function imba_keeper_of_the_light_recall:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_keeper_of_the_light_recall:OnSpellStart()
	self:GetCaster():EmitSound("Hero_KeeperOfTheLight.Recall.Cast")
	
	if not self:GetCursorTarget() or self:GetCursorTarget() == self:GetCaster() then
		local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		for _, ally in pairs(allies) do
			if ally ~= self:GetCaster() then
				self:GetCaster():SetCursorCastTarget(ally)
				break
			end
		end
	end
	
	if self:GetCursorTarget() and self:GetCursorTarget() ~= self:GetCaster() then
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_imba_keeper_of_the_light_recall", {duration = self:GetSpecialValueFor("teleport_delay")})
	end
end

---------------------
-- RECALL MODIFIER --
---------------------

function modifier_imba_keeper_of_the_light_recall:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall.vpcf"
end

function modifier_imba_keeper_of_the_light_recall:OnCreated()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_KeeperOfTheLight.Recall.Target")
end

function modifier_imba_keeper_of_the_light_recall:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_KeeperOfTheLight.Recall.Target")
	
	-- The full duration has passed, and the teleport has succeeded
	if self:GetRemainingTime() <= 0 then
		local caster_position	= self:GetCaster():GetAbsOrigin()
		
		if self:GetAbility() and self:GetCaster() and self:GetCaster():IsAlive() then
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_POINT, self:GetParent())
			ParticleManager:ReleaseParticleIndex(particle)
			
			-- Teleport the parent to the caster's position
			FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), false)
			
			EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_KeeperOfTheLight.Recall.End", self:GetCaster())
			
			local parent	= self:GetParent()
			
			Timers:CreateTimer(FrameTime(), function()
				if parent then
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_POINT, parent)
					ParticleManager:ReleaseParticleIndex(particle)
				end
			end)
			
			-- Send a stop command
			self:GetParent():Stop()
		end
	end
end

function modifier_imba_keeper_of_the_light_recall:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return decFuncs
end

-- "Damage is checked before any sort of reduction. This means that it gets canceled even when the damage is fully blocked. Has no minimum damage threshold."
function modifier_imba_keeper_of_the_light_recall:OnTakeDamage(keys)
	if not IsServer() then return end
	
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and (keys.attacker:IsRealHero() or keys.attacker:IsRoshan()) and keys.original_damage > 0 then
		self:GetParent():EmitSound("Hero_KeeperOfTheLight.Recall.Fail")
		
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_failure.vpcf", PATTACH_POINT, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
		
		self:Destroy()
	end
end

----------------
-- SPOTLIGHTS --
----------------

function imba_keeper_of_the_light_spotlights:IsInnateAbility()	return true end

function imba_keeper_of_the_light_spotlights:GetIntrinsicModifierName()
	return "modifier_imba_keeper_of_the_light_spotlights"
end

function imba_keeper_of_the_light_spotlights:OnInventoryContentsChanged()
	if not self.spotlights_modifier then
		self.spotlights_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_keeper_of_the_light_spotlights", self:GetCaster())
	end

	if self.spotlights_modifier then
		if self:GetCaster():HasScepter() then
			self.spotlights_modifier:StartIntervalThink(0.1)
		else
			self.spotlights_modifier:StartIntervalThink(-1)
		end
	end
end

function imba_keeper_of_the_light_spotlights:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

-------------------------
-- SPOTLIGHTS MODIFIER --
-------------------------

function modifier_imba_keeper_of_the_light_spotlights:IsHidden()	return true end

function modifier_imba_keeper_of_the_light_spotlights:OnCreated()
	self.ability			= self:GetAbility()
	self.parent				= self:GetParent()
	
	-- AbilitySpecials
	self.passive_radius		= self.ability:GetSpecialValueFor("passive_radius")
	self.attack_duration	= self.ability:GetSpecialValueFor("attack_duration")
	self.damaged_duration	= self.ability:GetSpecialValueFor("damaged_duration")
end

function modifier_imba_keeper_of_the_light_spotlights:OnIntervalThink()
	if GameRules:IsDaytime() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent():GetCurrentVisionRange(), 0.1, false)
	end
end


function modifier_imba_keeper_of_the_light_spotlights:DeclareFunctions()
	local decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_spotlights:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self.parent and not self.parent:PassivesDisabled() and self.ability:IsCooldownReady() then
		self:Spotlight(keys.target:GetAbsOrigin(), self.passive_radius, self.attack_duration)
		self.ability:UseResources(false, false, false, true)
	end
end

function modifier_imba_keeper_of_the_light_spotlights:OnTakeDamage(keys)
	if not IsServer() then return end

	if keys.unit == self.parent and not self.parent:PassivesDisabled() and self.ability:IsCooldownReady() then
		self:Spotlight(keys.attacker:GetAbsOrigin(), self.passive_radius, self.damaged_duration)
		self.ability:UseResources(false, false, false, true)
	end
end

function modifier_imba_keeper_of_the_light_spotlights:Spotlight(position, radius, duration)
	if not IsServer() or self.parent:PassivesDisabled() then return end
	
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling.vpcf", PATTACH_POINT, self.parent)
	ParticleManager:SetParticleControl(particle, 0, position)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 1, 1))
	
	AddFOWViewer(self.parent:GetTeam(), position, radius, duration, false)
	
	Timers:CreateTimer(duration, function()
		if self and particle then
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end)
end

-----------------
-- WILL O WISP --
-----------------

function imba_keeper_of_the_light_will_o_wisp:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_keeper_of_the_light_will_o_wisp:OnUpgrade()
	local recall_ability = self:GetCaster():FindAbilityByName("imba_keeper_of_the_light_recall")
	
	if recall_ability then
		recall_ability:SetLevel(self:GetLevel())
	end
end



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
	-- The initial off duration + total amount of time it's on + total amount of time it's off minus one instace
	self.duration = self.off_duration_initial + (self.on_duration * self.on_count) + (self.off_duration * (self.on_count - 1))

	if not IsServer() then return end

	-- Issue: This thing actually has a slightly larger hitbox than the standard wisp -_-
	local ignis_fatuus = CreateUnitByName("npc_dota_ignis_fatuus", self.position, true, self.caster, self.caster, self.caster:GetTeamNumber())
	
	-- Add the hypnotizing aura modifier
	ignis_fatuus:AddNewModifier(self.caster, self, "modifier_imba_keeper_of_the_light_will_o_wisp", {duration = self.duration})
	
	-- Set up gold bounty
	ignis_fatuus:SetMaximumGoldBounty(self.bounty)
	ignis_fatuus:SetMinimumGoldBounty(self.bounty)
	
	if self.caster:GetName() == "npc_dota_hero_keeper_of_the_light" then
		-- 6 responses, but #4 is unused
		local response = math.random(1, 5)
		
		if response >= 4 then
			response = (response + 1)
		end

		-- This thing gets interrupted a lot by KOTL moving right after and IDK how to fix that
		self.caster:EmitSound("keeper_of_the_light_keep_spiritform_0"..response)
	end
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
	self.on_count						= self.ability:GetSpecialValueFor("on_count")
	self.radius							= self.ability:GetSpecialValueFor("radius")
	self.hit_count						= self.ability:GetSpecialValueFor("hit_count")
	self.off_duration					= self.ability:GetSpecialValueFor("off_duration")
	self.on_duration					= self.ability:GetSpecialValueFor("on_duration")
	self.off_duration_initial			= self.ability:GetSpecialValueFor("off_duration_initial")
	self.fixed_movement_speed			= self.ability:GetSpecialValueFor("fixed_movement_speed")
	self.bounty							= self.ability:GetSpecialValueFor("bounty")
	self.ignis_blessing_duration		= self.ability:GetSpecialValueFor("ignis_blessing_duration")
	
	if not IsServer() then return end
	
	-- Calculate health chunks that Ignis Fatuus will lose on getting attacked
	self.health_increments		= self.parent:GetMaxHealth() / self.hit_count
	
	-- Emit cast sounds
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Cast")
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Spawn")
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Aura")
	
	-- This gives Ignis Fatuus a visible model
	-- CP1 = Vector(radius, 1, 1)
	-- CP2 = Vector("hypnotize is on", 0, 0)
	-- CP3/4/5 = I don't know
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 1, 1))
	ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
	
	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_on.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(self.particle2, 2, Vector(0, 0, 0))
	self:AddParticle(self.particle2, false, false, -1, false, false)
	
	-- Destroy trees around cast point
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.radius, true )
	
	self.timer = 0
	self.pulses = 0
	self.is_on = false
	
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_keeper_of_the_light_will_o_wisp:OnIntervalThink()
	if not IsServer() then return end

	self.timer = self.timer + FrameTime()
	
	if not self.is_on and (self.pulses == 0 and self.timer >= self.off_duration_initial) or (self.pulses > 0 and self.timer >= self.off_duration)  then
		self.is_on 	= true
		self.pulses = self.pulses + 1
		
		self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Active")
		ParticleManager:SetParticleControl(self.particle, 2, Vector(1, 0, 0))
		ParticleManager:SetParticleControl(self.particle2, 2, Vector(1, 0, 0))

		self.timer = 0		
	elseif self.is_on then
		if self.timer >= self.on_duration then
			self.is_on = false
			ParticleManager:SetParticleControl(self.particle, 2, Vector(0, 0, 0))
			ParticleManager:SetParticleControl(self.particle2, 2, Vector(0, 0, 0))
			self.timer = 0
		else
			local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			
			for _, enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_imba_keeper_of_the_light_will_o_wisp_aura") then
					enemy:AddNewModifier(self.parent, self.ability, "modifier_imba_keeper_of_the_light_will_o_wisp_aura", {duration = self.on_duration - self.timer})
				end
				
				-- CALLING THIS A BILLION TIMES CAUSE IDK WHY IT KEEPS FAILING
				enemy:FaceTowards(self.parent:GetAbsOrigin())
			end
			
			local truesight_modifier = self.parent:FindModifierByName("modifier_item_imba_gem_of_true_sight")
			
			if not truesight_modifier then
				self.parent:AddNewModifier(self.caster, self.caster:FindAbilityByName("special_bonus_imba_keeper_of_the_light_ignis_truesight"), "modifier_item_imba_gem_of_true_sight", {duration = self.on_duration})
			end
		end
	end
end

function modifier_imba_keeper_of_the_light_will_o_wisp:OnRemoved()
	if not IsServer() then return end
	
	self.parent:EmitSound("Hero_KeeperOfTheLight.Wisp.Destroy")
	self.parent:StopSound("Hero_KeeperOfTheLight.Wisp.Aura")
	
	local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	-- Remove exisiting hypnotize modifiers on everyone if the wisp is destroyed during this
	for _, enemy in pairs(enemies) do
		local hypnotize_modifier = enemy:FindModifierByNameAndCaster("modifier_imba_keeper_of_the_light_will_o_wisp_aura", self.parent)
		
		if hypnotize_modifier then
			hypnotize_modifier:Destroy()
		end
	end
	
	self.parent:ForceKill(false)
end

-- IMBAfication: Ignis Blessing
function modifier_imba_keeper_of_the_light_will_o_wisp:CheckState(keys)
	return {
		[MODIFIER_STATE_SPECIALLY_DENIABLE] = true
	}
end

function modifier_imba_keeper_of_the_light_will_o_wisp:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		
		MODIFIER_EVENT_ON_ATTACKED
    }
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

-- Arbitrary size reduction to try and match vanila
function modifier_imba_keeper_of_the_light_will_o_wisp:GetModifierModelScale()
    return -40
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
			keys.attacker:AddNewModifier(self.caster, self.ability, "modifier_imba_keeper_of_the_light_will_o_wisp_blessing", {duration = self.ignis_blessing_duration})
		end
	end
end

-------------------------------
-- WILL O WISP MODIFIER AURA --
-------------------------------
-- I guess this isn't technically an aura but w/e using vanilla descriptions

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:IgnoreTenacity()	return true end
function modifier_imba_keeper_of_the_light_will_o_wisp_aura:IsPurgable() 		return false end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_debuff.vpcf"
end

-- Doesn't feel like this is working for some reason
function modifier_imba_keeper_of_the_light_will_o_wisp_aura:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_dazzle.vpcf"
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:OnCreated()
	self.ability				= self:GetAbility()
	self.caster					= self:GetCaster()
	self.parent					= self:GetParent()
	
	-- AbilitySpecials
	self.fixed_movement_speed		= self.ability:GetSpecialValueFor("fixed_movement_speed")
	self.tunnel_vision_reduction	= self.ability:GetSpecialValueFor("tunnel_vision_reduction")
	
	if not IsServer() then return end
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
	
	self.parent:FaceTowards(self.caster:GetAbsOrigin())
	self.parent:Stop()
	
	self.parent:StartGesture(ACT_DOTA_DISABLED)
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = (self.caster:GetOrigin() - me:GetOrigin()):Normalized()
	
	me:SetOrigin( me:GetOrigin() + distance * self.fixed_movement_speed * dt )
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:OnDestroy()
	if not IsServer() then return end

	self.parent:RemoveHorizontalMotionController( self )
	self.parent:FadeGesture(ACT_DOTA_DISABLED)
end

-- Creeps don't turn to face the wisp zzzzzzzzzz
function modifier_imba_keeper_of_the_light_will_o_wisp_aura:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,	-- Using this as substitute for Sleep which isn't a provided state
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE 
    }
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:GetModifierMoveSpeed_Absolute()
    return self.fixed_movement_speed
end

function modifier_imba_keeper_of_the_light_will_o_wisp_aura:GetBonusVisionPercentage()
    return self.tunnel_vision_reduction * (-1)
end

-----------------------------------
-- WILL O WISP BLESSING MODIFIER --
-----------------------------------

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:GetEffectName()
	return "particles/hero/keeper_of_the_light/ignis_blessing.vpcf"
end

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_spirit_form.vpcf"
end

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:OnCreated()
	self.ability						= self:GetAbility()
	self.caster							= self:GetCaster()
	self.parent							= self:GetParent()
	
	-- AbilitySpecials
	self.ignis_blessing_int_to_damage	= self.ability:GetSpecialValueFor("ignis_blessing_int_to_damage")

	if not IsServer() then return end
	
	if self.caster.GetIntellect then
		self:SetStackCount(self.caster:GetIntellect() * self.ignis_blessing_int_to_damage * 0.01)
	end
end

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:OnRefresh()
	self:OnCreated()
end

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
    }

    return decFuncs
end

function modifier_imba_keeper_of_the_light_will_o_wisp_blessing:GetModifierProcAttack_BonusDamage_Pure()
    return self:GetStackCount()
end


---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight", "components/abilities/heroes/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_keeper_of_the_light_travelling_light", "components/abilities/heroes/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition", "components/abilities/heroes/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate", "components/abilities/heroes/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight	= modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight or class({})
modifier_special_bonus_imba_keeper_of_the_light_travelling_light	= modifier_special_bonus_imba_keeper_of_the_light_travelling_light or class({})
modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition	= modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition or class({})
modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate	= modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate or class({})

function modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight:IsHidden() 		return true end
function modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight:IsPurgable()		return false end
function modifier_special_bonus_imba_keeper_of_the_light_ignis_truesight:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_keeper_of_the_light_travelling_light:IsHidden() 		return true end
function modifier_special_bonus_imba_keeper_of_the_light_travelling_light:IsPurgable()		return false end
function modifier_special_bonus_imba_keeper_of_the_light_travelling_light:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition:IsHidden() 		return true end
function modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition:IsPurgable()		return false end
function modifier_special_bonus_imba_keeper_of_the_light_flow_inhibition:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate:IsHidden() 		return true end
function modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate:IsPurgable()		return false end
function modifier_special_bonus_imba_keeper_of_the_light_pure_illuminate:RemoveOnDeath() 	return false end

-- -- Client-side helper functions --

LinkLuaModifier("modifier_special_bonus_imba_keeper_of_the_light_luminous_burster", "components/abilities/heroes/hero_keeper_of_the_light", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_keeper_of_the_light_luminous_burster		= class({})

-------------------------------
-- LUMINOUS BURSTER MODIFIER --
-------------------------------
function modifier_special_bonus_imba_keeper_of_the_light_luminous_burster:IsHidden() 		return true end
function modifier_special_bonus_imba_keeper_of_the_light_luminous_burster:IsPurgable() 		return false end
function modifier_special_bonus_imba_keeper_of_the_light_luminous_burster:RemoveOnDeath() 	return false end

function imba_keeper_of_the_light_blinding_light:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_keeper_of_the_light_luminous_burster") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_keeper_of_the_light_luminous_burster") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_keeper_of_the_light_luminous_burster"), "modifier_special_bonus_imba_keeper_of_the_light_luminous_burster", {})
	end
end
