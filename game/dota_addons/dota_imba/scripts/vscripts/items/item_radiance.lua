--	Author		 -	d2imba
--	DateCreated	 -	25.03.2015	<-- It owes Jesus money
--	Date Updated -	05.03.2017
--	Converted to Lua by zimberzimber

-- Illusions don't apply afterburn stacks

-----------------------------------------------------------------------------------------------------------
--	Item Definition
-----------------------------------------------------------------------------------------------------------
if item_imba_radiance == nil then item_imba_radiance = class({}) end
LinkLuaModifier( "modifier_imba_radiance_basic", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )		-- Item stat
LinkLuaModifier( "modifier_imba_radiance_aura", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )		-- Aura
LinkLuaModifier( "modifier_imba_radiance_burn", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )		-- Damage + blind effect
LinkLuaModifier( "modifier_imba_radiance_afterburn", "items/item_radiance.lua", LUA_MODIFIER_MOTION_NONE )	-- Sticky effect after leaving the Radiance AoE

function item_imba_radiance:GetCastRange()
	return self:GetSpecialValueFor("aura_radius")
end

function item_imba_radiance:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_ITEM end
	
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
function modifier_imba_radiance_basic:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_radiance_basic:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		
		if not parent:IsIllusion() then
			local mods = parent:FindAllModifiersByName("modifier_imba_radiance_basic")
			if not mods[2] then
				parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_radiance_aura", {}) 
			end
			
		else
			local ownerFinder = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH , DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false) 
			for _,hero in pairs(ownerFinder) do
				if hero:GetName() == parent:GetName() and hero:IsRealHero() then
					if hero:FindModifierByName("modifier_imba_radiance_aura") then
						parent:AddNewModifier(parent, self:GetAbility(), "modifier_imba_radiance_aura", {}) 
					end
				end
			end
		end
	end
end

function modifier_imba_radiance_basic:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		
		if parent:FindModifierByName("modifier_imba_radiance_aura") then
			Timers:CreateTimer(0.01, function()
				if not parent:FindModifierByName("modifier_imba_radiance_basic") then
					parent:RemoveModifierByName("modifier_imba_radiance_aura")
				end
			end)
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
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
	
function modifier_imba_radiance_aura:GetModifierAura()
	return "modifier_imba_radiance_burn" end
	
function modifier_imba_radiance_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius") end

function modifier_imba_radiance_aura:OnCreated()
	if IsServer() then
		-- Particle creation
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		
		local parent = self:GetParent()
		if parent:FindModifierByName("modifier_item_imba_rapier_cursed") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(1,1,1))
		
		elseif parent:FindModifierByName("modifier_item_imba_skadi") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(50,255,255))
			
		elseif parent:FindModifierByName("modifier_item_imba_nether_wand") or parent:FindModifierByName("modifier_item_imba_elder_staff") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(100,255,100))
			
		elseif parent:IsHero() then
			-- Calculate color based on stats
			local r = parent:GetStrength()
			local g = parent:GetAgility()
			local b = parent:GetIntellect()
			local highest = math.max(r, math.max(g,b))
			r = r / highest * 255
			g = g / highest * 255
			b = b / highest * 255
			ParticleManager:SetParticleControl(self.particle, 2, Vector(r,g,b))
			
		else
			ParticleManager:SetParticleControl(self.particle, 2, Vector(253, 144, 63))
		end
		
		self:StartIntervalThink(0.5)
	end
end

function modifier_imba_radiance_aura:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_imba_radiance_aura:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		
		-- Set color based on carrier
		if parent:FindModifierByName("modifier_item_imba_rapier_cursed") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(1,1,1))
		
		elseif parent:FindModifierByName("modifier_item_imba_skadi") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(50,255,255))
			
		elseif parent:FindModifierByName("modifier_item_imba_nether_wand") or parent:FindModifierByName("modifier_item_imba_elder_staff") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(100,255,100))
			
		elseif parent:IsHero() then
			-- Calculate color based on stats
			local r = parent:GetStrength()
			local g = parent:GetAgility()
			local b = parent:GetIntellect()
			local highest = math.max(r, math.max(g,b))
			r = r / highest * 255
			g = g / highest * 255
			b = b / highest * 255
			ParticleManager:SetParticleControl(self.particle, 2, Vector(r,g,b))
			
		else
			ParticleManager:SetParticleControl(self.particle, 2, Vector(253, 144, 63))
		end
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
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local thinkInterval = ability:GetSpecialValueFor("think_interval")
		self:StartIntervalThink(thinkInterval)
		
		-- Particle creation
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		
		-- If the parent has the afterburn debuff, remove it and keep counting stacks through here
		local afterburn = parent:FindModifierByName("modifier_imba_radiance_afterburn")
		if afterburn then
			AddStacksLua(ability, ability:GetCaster(), parent, "modifier_imba_radiance_burn", afterburn:GetStackCount())
			afterburn:Destroy()
		end
	end
end

function modifier_imba_radiance_burn:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		
		local stacks = self:GetStackCount()
		if self.fakeStacks then stacks = stacks - self.fakeStacks end
		
		if stacks > 0 then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			parent:AddNewModifier(ability:GetCaster(), ability, "modifier_imba_radiance_afterburn", {})
			AddStacksLua(ability, ability:GetCaster(), parent, "modifier_imba_radiance_afterburn", stacks)
		end
	end
end

function modifier_imba_radiance_burn:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local parent = self:GetParent()
		
		local baseDamage = ability:GetSpecialValueFor("base_damage")
		local healthDamage = ability:GetSpecialValueFor("extra_damage")
		local totalDamage = baseDamage
		local realHero
		
		local ownerFinder = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, 25000, DOTA_UNIT_TARGET_TEAM_BOTH , DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_ANY_ORDER , false) 
		for _,hero in pairs(ownerFinder) do
			if hero:GetName() == caster:GetName() and hero:IsRealHero() and hero:FindModifierByName("modifier_imba_radiance_aura") then
				if CalcDistanceBetweenEntityOBB(hero, parent) <= ability:GetSpecialValueFor("aura_radius") then
					realHero = hero end
				break
			end
		end
		
		-- If the *real* hero is in range
		if realHero then
			totalDamage = healthDamage / 100 * parent:GetHealth() + baseDamage
			AddStacksLua(ability, caster, parent, "modifier_imba_radiance_burn", 1)
		else
			AddStacksLua(ability, caster, parent, "modifier_imba_radiance_burn", 1)
			if not self.fakeStacks then
				self.fakeStacks = 1
			else
				self.fakeStacks = self.fakeStacks + 1
			end
		end
		
		-- Apply damage and add stacks
		ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = totalDamage, damage_type = DAMAGE_TYPE_MAGICAL})
		
		-- Handle particle and color based on Radiance carrier
		ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
		
		if caster:FindModifierByName("modifier_item_imba_rapier_cursed") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(1,1,1))
		
		elseif caster:FindModifierByName("modifier_item_imba_skadi") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(50,255,255))
			
		elseif caster:FindModifierByName("modifier_item_imba_nether_wand") or caster:FindModifierByName("modifier_item_imba_elder_staff") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(100,255,100))
			
		elseif caster:IsHero() then
			-- Calculate color based on stats
			local r = caster:GetStrength()
			local g = caster:GetAgility()
			local b = caster:GetIntellect()
			local highest = math.max(r, math.max(g,b))
			r = r / highest * 255
			g = g / highest * 255
			b = b / highest * 255
			ParticleManager:SetParticleControl(self.particle, 2, Vector(r,g,b))
			
		else
			ParticleManager:SetParticleControl(self.particle, 2, Vector(253, 144, 63))
		end
	end
end

function modifier_imba_radiance_burn:GetModifierMiss_Percentage()
	return self:GetAbility():GetSpecialValueFor("miss_chance") end

-----------------------------------------------------------------------------------------------------------
--	Afterburn modifier definition
-----------------------------------------------------------------------------------------------------------
if modifier_imba_radiance_afterburn == nil then modifier_imba_radiance_afterburn = class({}) end
function modifier_imba_radiance_afterburn:IsHidden() return false end
function modifier_imba_radiance_afterburn:IsDebuff() return true end
function modifier_imba_radiance_afterburn:IsPurgable() return false end

function modifier_imba_radiance_afterburn:OnCreated()
	if IsServer() then
		local thinkInterval = self:GetAbility():GetSpecialValueFor("think_interval")
		self:StartIntervalThink(thinkInterval)
		
		-- Particle creation
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
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
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local stacks = self:GetStackCount()
		
		local baseDamage = ability:GetSpecialValueFor("base_damage")
		local healthDamage = ability:GetSpecialValueFor("extra_damage")
		local stackDecay = ability:GetSpecialValueFor("stack_decay")
		local totalDamage = baseDamage
		
		if stacks >= stackDecay then
			totalDamage = healthDamage / 100 * parent:GetHealth() + baseDamage
		else
			local newHealthDamage = healthDamage / stackDecay * stacks
			totalDamage = newHealthDamage / 100 * parent:GetHealth() + baseDamage
		end
		
		ApplyDamage({victim = parent, attacker = caster, ability = ability, damage = totalDamage, damage_type = DAMAGE_TYPE_MAGICAL})
		self:SetStackCount(stacks - stackDecay)
		if self:GetStackCount() <= 0 then self:Destroy() return end
		
		local org = parent:GetAbsOrigin()
		ParticleManager:SetParticleControl(self.particle, 1, Vector(org.x,org.y, 100)) -- lul orgy
		
		if caster:FindModifierByName("modifier_item_imba_rapier_cursed") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(1,1,1))
		
		elseif caster:FindModifierByName("modifier_item_imba_skadi") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(50,255,255))
			
		elseif caster:FindModifierByName("modifier_item_imba_nether_wand") or caster:FindModifierByName("modifier_item_imba_elder_staff") then
			ParticleManager:SetParticleControl(self.particle, 2, Vector(100,255,100))
			
		elseif caster:IsHero() then
			-- Calculate color based on stats
			local r = caster:GetStrength()
			local g = caster:GetAgility()
			local b = caster:GetIntellect()
			local highest = math.max(r, math.max(g,b))
			r = r / highest * 255
			g = g / highest * 255
			b = b / highest * 255
			ParticleManager:SetParticleControl(self.particle, 2, Vector(r,g,b))
			
		else
			ParticleManager:SetParticleControl(self.particle, 2, Vector(253, 144, 63))
		end
	end
end