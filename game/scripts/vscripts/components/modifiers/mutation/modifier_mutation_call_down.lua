LinkLuaModifier("modifier_thinker_call_down", "components/modifiers/mutation/modifier_mutation_call_down.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_thinker_call_down_second", "components/modifiers/mutation/modifier_mutation_call_down.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_call_down_slow", "components/modifiers/mutation/modifier_mutation_call_down.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_call_down = class({})
function modifier_mutation_call_down:IsHidden() return true end
function modifier_mutation_call_down:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION]      = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO]        = true,
		[MODIFIER_STATE_NO_TEAM_SELECT]         = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED]     = true,
		[MODIFIER_STATE_ATTACK_IMMUNE]          = true,
		[MODIFIER_STATE_MAGIC_IMMUNE]           = true,
		[MODIFIER_STATE_INVULNERABLE]           = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP]         = true,
		[MODIFIER_STATE_UNSELECTABLE]           = true,
		[MODIFIER_STATE_OUT_OF_GAME]            = true,
		[MODIFIER_STATE_NO_HEALTH_BAR]          = true,
		[MODIFIER_STATE_ROOTED]                 = true,
	}

	return state
end

---------------------------------------
--          Call Down                -- 
---------------------------------------
function modifier_mutation_call_down:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	-- This is the delay to first Call Down
	self.first_call_down_delay = 2.0    
	-- This is the delay to first Call Down
	self.second_call_down_delay = 4.0    

	self.MAP_SIZE = 6000    
	-- number of call downs to spawn
	self.num_call_downs         = 5
	self.radius                 = 600
	self.first_slow             = 30
	self.first_slow_duration    = 2.0
	self.second_slow            = 75
	self.second_slow_duration   = 3.0

	self:StartIntervalThink(10.0)
end

function modifier_mutation_call_down:OnIntervalThink()
	if IsServer() then

		self.parent.pos_list = {}

		for i = 0, self.num_call_downs do 
			local x = math.random(-7500, 7500)
            local y = math.random(-7500, 7500)
            local pos = GetGroundPosition(Vector(x, y, 0), nil)
			--DebugDrawCircle(pos, Vector( 0, 255, 0 ), 255, 50, false, 0.1 )
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self.parent)
			ParticleManager:SetParticleControl(particle, 0, pos)
			ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0-self.radius))
			-- save position
			self.parent.pos_list[i] = pos

			CreateModifierThinker(self.parent, nil, "modifier_thinker_call_down", {duration = self.first_call_down_delay, index = i, radius = self.radius, delay = self.first_call_down_delay, slow = self.first_slow, slow_duration = self.first_slow_duration}, pos, 0, false)
			CreateModifierThinker(self.parent, nil, "modifier_thinker_call_down_second", {duration = self.second_call_down_delay, index = i, radius = self.radius, slow = self.second_slow, slow_duration = self.second_slow_duration}, pos, 0, false)
		end
	end
end

---------------------------------------
--        First Call Down            --
---------------------------------------
modifier_thinker_call_down = class({})
function modifier_thinker_call_down:OnCreated(keys)
	if IsServer() then
		self.radius = keys.radius
		self.slow = keys.slow
		self.slow_duration = keys.slow_duration
		self.index = keys.index
		self.delay = keys.delay
		self.pos = GetGroundPosition(self:GetCaster().pos_list[keys.index], nil)

		local missile = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self.parent)
		-- position of missile in the air
		ParticleManager:SetParticleControl(missile, 0, self.pos + Vector (0, 0, 1000))
		-- target missile will land at
		ParticleManager:SetParticleControl(missile, 1, self.pos)
		EmitSoundOnLocationWithCaster(self.pos, "Hero_Gyrocopter.CallDown.Fire", self:GetCaster())

		-- delay explosion untill missile has landed...
		Timers:CreateTimer(self.delay, function()
			local crater = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, self.parent)
			-- Position of crater
			ParticleManager:SetParticleControl(crater, 3, self.pos)
			-- Radius of explosion
			ParticleManager:SetParticleControl(crater, 5, Vector(self.radius, 0, 0))
		end)
	end
end

function modifier_thinker_call_down:OnDestroy()    
	if IsServer() then
		EmitSoundOnLocationWithCaster(self.pos, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())

		-- calc damage for first explosion 
		local call_down_damage = math.ceil(50 * (GameRules:GetGameTime() / 60))
		local units = FindUnitsInRadius(1,
									self.pos,
									nil,
									self.radius,
									DOTA_UNIT_TARGET_TEAM_BOTH,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)

		for _,unit in pairs(units) do
			local damageTable = {
				victim = unit,
				attacker = self:GetParent(),
				damage = call_down_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,        
			}

			ApplyDamage(damageTable)
			local ref = unit:AddNewModifier(self:GetParent(), nil, "modifier_call_down_slow", {duration = self.slow_duration})
			if ref ~= nil then
				ref:SetStackCount(self.slow)
			end
		end
	end
end


---------------------------------------
--        Second Call Down           --
---------------------------------------
modifier_thinker_call_down_second = class({})
function modifier_thinker_call_down_second:OnCreated(keys)
	if IsServer() then 
		self.radius = keys.radius
		self.slow = keys.slow
		self.slow_duration = keys.slow_duration
		self.index = keys.index
		self.pos = GetGroundPosition(self:GetCaster().pos_list[keys.index], nil)

		self.particle = ParticleManager:CreateParticle("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self.parent)
		-- position of missile in the air
		ParticleManager:SetParticleControl(self.particle, 0, self.pos + Vector (0, 0, 10000))
		-- target missile will land at
		ParticleManager:SetParticleControl(self.particle, 1, self.pos)
	end
end

function modifier_thinker_call_down_second:OnDestroy()    
	if IsServer() then
		EmitSoundOnLocationWithCaster(self.pos, "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())

		-- calc damage for second explosion 
		local call_down_damage = math.ceil(75 * (GameRules:GetGameTime() / 60))
		local units = FindUnitsInRadius(1,
									self.pos,
									nil,
									self.radius,
									DOTA_UNIT_TARGET_TEAM_BOTH,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
									DOTA_UNIT_TARGET_FLAG_NONE,
									FIND_ANY_ORDER,
									false)

		for _,unit in pairs(units) do
			local damageTable = {
				victim = unit,
				attacker = self:GetParent(),
				damage = call_down_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,        
			}

			ApplyDamage(damageTable)
			local ref = unit:AddNewModifier(self:GetParent(), nil, "modifier_call_down_slow", {duration = self.slow_duration})
			if ref ~= nil then
				ref:SetStackCount(self.slow)
			end
		end
	end
end


---------------------------------------
--        Slow Modifier              --
---------------------------------------
modifier_call_down_slow = class({})
function modifier_call_down_slow:IsHidden() return false end
function modifier_call_down_slow:IsPurgable() return false end
function modifier_call_down_slow:DeclareFunctions()
	local decFuns = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return decFuns
end

function modifier_call_down_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount()
end
