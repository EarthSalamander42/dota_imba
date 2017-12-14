--	Author		 -	d2imba
--	DateCreated	 -	25.03.2015	<-- It owes Jesus money
--	Date Updated -	05.03.2017
--	Converted to Lua by zimberzimber

-- Illusions don't apply afterburn stacks

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_radiance == nil then item_imba_radiance = class({}) end
LinkLuaModifier( "modifier_imba_radiance_basic", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Item stats
LinkLuaModifier( "modifier_imba_radiance_aura", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Aura
LinkLuaModifier( "modifier_imba_radiance_burn", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )			-- Damage + blind effect
LinkLuaModifier( "modifier_imba_radiance_afterburn", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )		-- Sticky effect after leaving the Radiance AoE

function item_imba_radiance:GetIntrinsicModifierName()
	return "modifier_imba_radiance_basic" end

function item_imba_radiance:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:HasModifier("modifier_imba_radiance_aura") then
			caster:RemoveModifierByName("modifier_imba_radiance_aura")
		else
			caster:AddNewModifier(caster, self, "modifier_imba_radiance_aura", {})
		end
	end
end

function item_imba_radiance:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_imba_radiance_aura") then
		return "custom/imba_radiance" end
	
	return "custom/imba_radiance_inactive"
end

-----------------------------------------------------------------------------------------------------------
--	Basic modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_basic == nil then modifier_imba_radiance_basic = class({}) end
function modifier_imba_radiance_basic:IsHidden() return true end
function modifier_imba_radiance_basic:IsDebuff() return false end
function modifier_imba_radiance_basic:IsPurgable() return false end
function modifier_imba_radiance_basic:IsPermanent() return true end
function modifier_imba_radiance_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Adds the unique modifier to the owner when created
function modifier_imba_radiance_basic:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_imba_radiance_aura") then
			parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_radiance_aura", {})
		end
	end
end

-- Removes the unique modifier from the owner if this is the last Radiance in its inventory
function modifier_imba_radiance_basic:OnDestroy(keys)
	if IsServer() then
		local parent = self:GetParent()
		if not parent:HasModifier("modifier_imba_radiance_basic") then
			parent:RemoveModifierByName("modifier_imba_radiance_aura")
		end
	end
end

function modifier_imba_radiance_basic:DeclareFunctions()
	return { MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, }
end

function modifier_imba_radiance_basic:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_damage") end

-----------------------------------------------------------------------------------------------------------
--	Aura definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_aura == nil then modifier_imba_radiance_aura = class({}) end
function modifier_imba_radiance_aura:IsAura() return true end
function modifier_imba_radiance_aura:IsHidden() return true end
function modifier_imba_radiance_aura:IsDebuff() return false end
function modifier_imba_radiance_aura:IsPurgable() return false end

function modifier_imba_radiance_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end
	
function modifier_imba_radiance_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
	
function modifier_imba_radiance_aura:GetModifierAura()
	return "modifier_imba_radiance_burn"
end
	
function modifier_imba_radiance_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

-- Create the glow particle and start thinking
function modifier_imba_radiance_aura:OnCreated()
	if IsServer() then
		local parent = self:GetParent()

		self.particle = ParticleManager:CreateParticle(parent.radiance_effect, PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(self.particle, 2, parent:GetFittingColor())
		self:StartIntervalThink(0.5)
	end
end

-- Destroy the glow particle
function modifier_imba_radiance_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

-- Set color of the radiance glow based on its carrier
function modifier_imba_radiance_aura:OnIntervalThink()
	if IsServer() then
		ParticleManager:SetParticleControl(self.particle, 2, self:GetParent():GetFittingColor())
	end
end

-----------------------------------------------------------------------------------------------------------
--	Aura effects (damage + blind)
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_burn == nil then modifier_imba_radiance_burn = class({}) end
function modifier_imba_radiance_burn:IsHidden() return false end
function modifier_imba_radiance_burn:IsDebuff() return true end
function modifier_imba_radiance_burn:IsPurgable() return false end

function modifier_imba_radiance_burn:DeclareFunctions()
	return { MODIFIER_PROPERTY_MISS_PERCENTAGE, } end

function modifier_imba_radiance_burn:OnCreated()
	if IsServer() then

		-- Particle creation
		local parent = self:GetParent()
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)

		-- Start thinking
		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))

		-- Parameter storage
		local ability = self:GetAbility()
		self.base_damage = ability:GetSpecialValueFor("base_damage")
		self.extra_damage = ability:GetSpecialValueFor("extra_damage")
		self.aura_radius = ability:GetSpecialValueFor("aura_radius")
		self.miss_chance = ability:GetSpecialValueFor("miss_chance")
		self.count_to_afterburn = ability:GetSpecialValueFor("stack_decay")
		self.afterburner_counter = 0
	end
end

function modifier_imba_radiance_burn:OnDestroy()
	if IsServer() then

		-- Destroy particle
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		
		-- Apply afterburn with the appropriate amount of accumulates stacks
		local stacks = self:GetStackCount()
		if stacks > 0 then
			local parent = self:GetParent()
			local modifier_afterburn = parent:FindModifierByName("modifier_imba_radiance_afterburn")
			if not modifier_afterburn then
				modifier_afterburn = parent:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_imba_radiance_afterburn", {})
			end
			
			if modifier_afterburn then
				modifier_afterburn:SetStackCount(modifier_afterburn:GetStackCount() + stacks)
			end
		end
	end
end

function modifier_imba_radiance_burn:OnIntervalThink()
	if IsServer() then

		-- Parameters
		local ability = self:GetAbility()
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
				if hero:FindModifierByName("modifier_imba_radiance_aura") then
					real_hero_nearby = true					
					break
				end
			end
		end		

		-- If the real hero is nearby, increase damage and afterburn counter by 1
		if real_hero_nearby then
			damage = damage + self.extra_damage * parent:GetHealth() * 0.01
			self.afterburner_counter = self.afterburner_counter + 1

			-- If the afterburner counter has reached its target, reset it and add a stack to this modifier
			if self.afterburner_counter >= self.count_to_afterburn then
				self.afterburner_counter = 0
				self:SetStackCount(self:GetStackCount() + 1)
			end
		end
		
		-- Apply damage
		ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		
		-- Handle particle and color based on Radiance carrier
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle, 2, caster:GetFittingColor())
	end
end

function modifier_imba_radiance_burn:GetModifierMiss_Percentage()
	return self.miss_chance end

-----------------------------------------------------------------------------------------------------------
--	Afterburn modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_afterburn == nil then modifier_imba_radiance_afterburn = class({}) end
function modifier_imba_radiance_afterburn:IsHidden() return false end
function modifier_imba_radiance_afterburn:IsDebuff() return true end
function modifier_imba_radiance_afterburn:IsPurgable() return false end

function modifier_imba_radiance_afterburn:OnCreated()
	if IsServer() then

		-- Parameter storage
		local ability = self:GetAbility()
		local think_interval = ability:GetSpecialValueFor("think_interval")
		self.base_damage = ability:GetSpecialValueFor("base_damage")
		self.extra_damage = ability:GetSpecialValueFor("extra_damage")
		self.miss_chance = ability:GetSpecialValueFor("miss_chance")

		-- Particle creation
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 2, ability:GetCaster():GetFittingColor())

		-- Start thinking
		self:StartIntervalThink(think_interval)
	end
end

function modifier_imba_radiance_afterburn:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_radiance_afterburn:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()

		-- If the parent has the radiance burn modifier, do nothing
		if not parent:HasModifier("modifier_imba_radiance_burn") then

			-- If the original item is gone, do nothing and destroy the modifier
			local ability = self:GetAbility()
			if not ability then
				self:Destroy()
				return nil
			end

			-- Parameters
			local caster = ability:GetCaster()
			local stacks = self:GetStackCount()
			local damage = self.base_damage
			
			-- Calculate and deal damage
			damage = damage + self.extra_damage * parent:GetHealth() * 0.01
			ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
			self:SetStackCount(self:GetStackCount() - 1)
			if self:GetStackCount() <= 0 then self:Destroy() return end
			
			local parent_loc = parent:GetAbsOrigin()
			ParticleManager:SetParticleControl(self.particle, 1, Vector(parent_loc.x,parent_loc.y, 100)) -- lul orgy -- I'm 12 btw haHAA
			ParticleManager:SetParticleControl(self.particle, 2, caster:GetFittingColor())
		end
	end
end

function modifier_imba_radiance_afterburn:DeclareFunctions()
	return { MODIFIER_PROPERTY_MISS_PERCENTAGE, } end

function modifier_imba_radiance_afterburn:GetModifierMiss_Percentage()
	return self.miss_chance end