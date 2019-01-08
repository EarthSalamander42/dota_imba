--[[


	Ember Rune

	Contributors: Lindbrum (14th March 2018)
]]

LinkLuaModifier("modifier_imba_ember_rune_burn", "modifier/runes/modifier_imba_ember_rune", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ember_rune_on_hit", "modifier/runes/modifier_imba_ember_rune", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------
-- Rune modifier
----------------------------------------------------------------
modifier_imba_ember_rune = modifier_imba_ember_rune or class({})

function modifier_imba_ember_rune:IsAura() return true end
function modifier_imba_ember_rune:GetAuraRadius() return self.aura_radius end
function modifier_imba_ember_rune:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_ember_rune:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_ember_rune:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_ember_rune:GetModifierAura() return "modifier_imba_ember_rune_burn" end

function modifier_imba_ember_rune:GetTexture()
	return "custom/imba_rune_double_damage"
end

function modifier_imba_ember_rune:GetEffectName()
	return "particles/items2_fx/radiance_owner.vpcf"
end

function modifier_imba_ember_rune:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_ember_rune:OnCreated()
	if not IsServer() then return end
	self.aura_radius = 600
	self.burn_duration = 10.0
end

function modifier_imba_ember_rune:GetAuraEntityReject(target)
	if self:GetParent() == target then
		return true
	end

	return false
end

function modifier_imba_ember_rune:DeclareFunctions()
	local funcs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return funcs
end

function modifier_imba_ember_rune:OnAttackLanded(kv)
	if not IsServer() then return end
	--Only proceed if the attacker is the parent
	if not self:GetParent() == kv.attacker then return end

	local target = kv.target
	--Can't affect spell immune enemies and buildings
	if target:IsMagicImmune() or target:IsBuilding() then return end
	--Apply debuff if the target isn't affected already, else add a stack (like Huskar's Burning Spear)
	if target:HasModifier("modifier_imba_ember_rune_on_hit") then
		local modifier = target:FindModifierByName("modifier_imba_ember_rune_on_hit")
		modifier:SetStackCount(modifier:GetStackCount() + 1)
		modifier:SetDuration(self.burn_duration, true)
	else
		target:AddNewModifier(self:GetParent(), nil, "modifier_imba_ember_rune_on_hit", {duration = self.burn_duration})
		local modifier = target:FindModifierByName("modifier_imba_ember_rune_on_hit")
		modifier:SetStackCount(1)
	end
end

----------------------------------------------------------------------
-- Immolation aura debuff
----------------------------------------------------------------------
modifier_imba_ember_rune_burn = modifier_imba_ember_rune_burn or class({})
function modifier_imba_ember_rune_burn:IsHidden() return false end
function modifier_imba_ember_rune_burn:IsDebuff() return true end
function modifier_imba_ember_rune_burn:IsPurgable() return false end

function modifier_imba_ember_rune_burn:DeclareFunctions()
	return { MODIFIER_PROPERTY_MISS_PERCENTAGE } end

function modifier_imba_ember_rune_burn:OnCreated()
	if IsServer() then

		-- Particle creation
		self.particle = ParticleManager:CreateParticle(self:GetCaster().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

		-- Start thinking
		self:StartIntervalThink(1.0)

		-- Parameter storage
		self.base_damage = 80
		self.extra_damage = 2.0
		self.aura_radius = 600
		self.miss_chance = 20
	end
end

function modifier_imba_ember_rune_burn:OnDestroy()
	if IsServer() then
		-- Destroy particle
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_ember_rune_burn:OnIntervalThink()
	if IsServer() then
		-- Parameters
		local parent = self:GetParent()
		local caster = self:GetCaster()
		local damage = self.base_damage
		local real_hero_nearby = false

		-- Checks for the presence of the real hero
		if caster:IsRealHero() then
			real_hero_nearby = true
		else
			local real_hero_finder = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false)
			for _,hero in pairs(real_hero_finder) do
				if hero:FindModifierByName("modifier_imba_ember_rune") then
					real_hero_nearby = true
					break
				end
			end
		end

		-- If the real hero is nearby, increase damage
		if real_hero_nearby then
			damage = damage + self.extra_damage * parent:GetHealth() * 0.01
		end

		local damage_table = {victim = parent, 
			attacker = caster, 
			ability = nil, 
			damage = damage, 
			damage_type = DAMAGE_TYPE_MAGICAL
		}

		-- Apply damage
		ApplyDamage(damage_table)

		-- Handle particle and color based on Radiance carrier
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, caster:GetFittingColor())
	end
end

function modifier_imba_ember_rune_burn:GetModifierMiss_Percentage()
	return self.miss_chance
end


-------------------------------------------------------------------------------------------
-- On-hit burning debuff
-------------------------------------------------------------------------------------------
modifier_imba_ember_rune_on_hit = modifier_imba_ember_rune_on_hit or class({})

function modifier_imba_ember_rune_on_hit:IsHidden() return false end
function modifier_imba_ember_rune_on_hit:IsDebuff() return true end
function modifier_imba_ember_rune_on_hit:IsPurgable() return true end

function modifier_imba_ember_rune_on_hit:OnCreated()
	if not IsServer() then return end
	self.damage_per_sec = 20

	--Add burning effect
	self.particle = ParticleManager:CreateParticle(self:GetParent().radiance_effect, PATTACH_ABSORIGIN_FOLLOW, parent)
--	ParticleManager:AddParticle(self.particle, false, true, 10, true, false)

	self:OnIntervalThink()

	self:StartIntervalThink(1.0)
end

function modifier_imba_ember_rune_on_hit:OnIntervalThink()
	if not IsServer() then return end

	-- Calculate damage based on stacks
	local total_damage = self.damage_per_sec * self:GetStackCount()
	local damage_table = {
		victim = self:GetParent(),
		attacker = self:GetCaster(), 
		ability = nil, 
		damage = total_damage, 
		damage_type = DAMAGE_TYPE_MAGICAL
	}

	-- Apply damage
	ApplyDamage(damage_table)
end