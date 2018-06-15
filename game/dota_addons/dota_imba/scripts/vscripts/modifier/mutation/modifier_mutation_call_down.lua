
modifier_mutation_call_down = class({})

function modifier_mutation_call_down:IsHidden() return true end

function modifier_mutation_call_down:OnCreated()
	if not IsServer() then return end
	self.interval = 2.0	-- This is Call Down's interval to FIRST explosion DO NOT CHANGE THIS
	self.radius = 600 -- Radius
	self:StartIntervalThink(0.1)
	self.parent = self:GetParent()
end

function modifier_mutation_call_down:OnIntervalThink()
	local x = math.random(-8000, 8000)
	local y = math.random(-8000, 8000)
	local pos = GetGroundPosition(Vector(x, y, 0), nil)
	CreateModifierThinker(self, nil, "thinker_call_down", {duration = self.interval, raidus = self.radius}, pos, 0, false)
	local thinker = CreateModifierThinker(self, nil, "thinker_call_down_2", {duration = self.interval + 2.0, raidus = self.radius}, pos, 0, false)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle, 0, pos)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0-self.radius))
	self:AddParticle(particle, false, false, -1, false, false)
end

thinker_call_down = class({})
thinker_call_down_2 = class({})

function thinker_call_down:OnCreated(keys)
	if not IsServer() then return end
	self.radius = keys.radius or 400
	self.damage_1 = math.max(50, 50 * (GameRules:GetGameTime() / 60)) -- first explosion damage
	self.slow_1 = 30 -- first explosion slow down
	self.slow_duration = 3.0 -- slow down duration
end

function thinker_call_down:OnDestroy()
	if not IsServer() then return end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 5, Vector(self.radius, 0, 0))
	self:AddParticle(particle, false, false, -1, false, false)
	local units = FindUnitsInRadius(1,
									self:GetParent():GetAbsOrigin(),
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
							damage = self.damage_1,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = nil, --Optional.
							}
		ApplyDamage(damageTable)
		unit:AddNewModifier(self:GetParent(), nil, "modifier_call_down_slow", {duration = self.slow_duration, slow = self.slow_1})
	end
end

function thinker_call_down_2:OnCreated(keys)
	if not IsServer() then return end
	----------
	-- Create Particle
	----------
	self.radius = keys.radius or 400
	self.damage_2 = math.max(75, 75 * (GameRules:GetGameTime() / 60))	-- second explosion damage
	self.slow_2 = 70 -- second explosion slow down
	self.slow_duration = 3.0 -- slow down duration
end

function thinker_call_down_2:OnDestroy()
	if not IsServer() then return end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(particle, 3, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 5, Vector(self.radius, 0, 0))
	self:AddParticle(particle, false, false, -1, false, false)
	local units = FindUnitsInRadius(1,
									self:GetParent():GetAbsOrigin(),
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
							damage = self.damage_2,
							damage_type = DAMAGE_TYPE_MAGICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = nil, --Optional.
							}
		ApplyDamage(damageTable)
		unit:AddNewModifier(self:GetParent(), nil, "modifier_call_down_slow", {duration = self.slow_duration, slow = self.slow_2})
	end
end

modifier_call_down_slow = class({})

function modifier_call_down_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_call_down_slow:IsHidden() return true end

function modifier_call_down_slow:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
	return funcs
end

function modifier_call_down_slow:OnCreated(keys)
	self.slow = keys.slow or 0
end

function modifier_call_down_slow:GetModifierMoveSpeedBonus_Percentage()	return (0-self.slow) end