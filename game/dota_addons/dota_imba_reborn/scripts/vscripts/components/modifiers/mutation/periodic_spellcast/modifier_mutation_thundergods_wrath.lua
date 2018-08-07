-- Doesn't fully mimic the base skill as it doesn't hit "visible" invisible units, and true sight doesn't work based on aura

modifier_mutation_thundergods_wrath = class({})

function modifier_mutation_thundergods_wrath:IsHidden() return true end
function modifier_mutation_thundergods_wrath:IsDebuff() return true end
function modifier_mutation_thundergods_wrath:IsPurgable() return false end

function modifier_mutation_thundergods_wrath:OnCreated()
	if IsClient() then return end
	local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
	local vision_radius = 500 -- How much vision the skill gives around all units impacted
	local vision_duration = 3 -- How long the vision duration lasts
	
	self.damage = 300 + (80 * game_time)

	-- Borrowing code from hero_zuus.lua
	local hero = self:GetParent()
	local target_point = hero:GetAbsOrigin()
	EmitSoundOn("Hero_Zuus.GodsWrath", hero)
	
	local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))		
	ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))	
	ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))
	ParticleManager:ReleaseParticleIndex(thundergod_strike_particle)
	
	local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	ParticleManager:SetParticleControl(particle, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle)

	local damageTable = {
		victim = hero,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		attacker = self:GetCaster(),
	}
	
	if not hero:IsInvisible() then
		ApplyDamage(damageTable)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, hero, self.damage, nil)
	end
	
	AddFOWViewer(DOTA_TEAM_GOODGUYS, target_point, vision_radius, vision_duration, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, target_point, vision_radius, vision_duration, false)
end
	
function modifier_mutation_thundergods_wrath:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_mutation_thundergods_wrath:GetPriority()
	return MODIFIER_PRIORITY_HIGH 
end
