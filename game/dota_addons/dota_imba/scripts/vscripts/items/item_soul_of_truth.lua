--[[
		By: AtroCty
		Date: 27.05.2017
		Updated:  27.05.2017
	]]

LinkLuaModifier( "modifier_imba_soul_of_truth_buff", "items/item_soul_of_truth.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imba_soul_of_truth_vision", "items/item_soul_of_truth.lua", LUA_MODIFIER_MOTION_NONE )
-------------------------------------------
--			  SOUL OF TRUTH
-------------------------------------------
item_imba_soul_of_truth = item_imba_soul_of_truth or class({})
-------------------------------------------

function item_imba_soul_of_truth:OnSpellStart()
    if IsServer() then
		-- Parameters
		local hCaster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		
		hCaster:AddNewModifier(hCaster, self, "modifier_imba_soul_of_truth_buff", {duration = duration})
		self:Destroy()
	end
end

-------------------------------------------
modifier_imba_soul_of_truth_buff = modifier_imba_soul_of_truth_buff or class({})
function modifier_imba_soul_of_truth_buff:IsDebuff() return false end
function modifier_imba_soul_of_truth_buff:IsHidden() return false end
function modifier_imba_soul_of_truth_buff:IsPurgable() return false end
function modifier_imba_soul_of_truth_buff:IsPurgeException() return false end
function modifier_imba_soul_of_truth_buff:IsStunDebuff() return false end
function modifier_imba_soul_of_truth_buff:RemoveOnDeath() return false end
-------------------------------------------
function modifier_imba_soul_of_truth_buff:OnCreated()
	local hItem = self:GetAbility()
	self.radius = hItem:GetSpecialValueFor("radius")
	self.armor = hItem:GetSpecialValueFor("armor")
	self.health_regen = hItem:GetSpecialValueFor("health_regen")
	self.eye_pfx = ParticleManager:CreateParticle("particles/item/soul_of_truth/soul_of_truth_overhead.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	self:AddParticle(self.eye_pfx, false, false, MODIFIER_PRIORITY_HIGH, false, false)
	
end

function modifier_imba_soul_of_truth_buff:DeclareFunctions()
    local decFuns =
    {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN
    }
    return decFuns
end

function modifier_imba_soul_of_truth_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_imba_soul_of_truth_buff:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_imba_soul_of_truth_buff:GetAuraRadius()
	return self.radius
end

function modifier_imba_soul_of_truth_buff:OnDeath(keys)
	if (keys.unit == self:GetParent()) and (not keys.reincarnate) then
		ParticleManager:DestroyParticle( self.eye_pfx, false )
		ParticleManager:ReleaseParticleIndex(self.eye_pfx)
		self.eye_pfx = nil
		self:Destroy()
	end	
end

function modifier_imba_soul_of_truth_buff:OnRespawn(keys)
	if (keys.unit == self:GetParent()) then
		Timers:CreateTimer(0.1, function()
			self.eye_pfx = ParticleManager:CreateParticle("particles/item/soul_of_truth/soul_of_truth_overhead.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
			self:AddParticle(self.eye_pfx, false, false, MODIFIER_PRIORITY_HIGH, false, false)
		end)
	end
end

function modifier_imba_soul_of_truth_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_imba_soul_of_truth_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_soul_of_truth_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL + DOTA_UNIT_TARGET_CUSTOM + DOTA_UNIT_TARGET_TREE
end

function modifier_imba_soul_of_truth_buff:GetTexture()
	return "custom/imba_soul_of_truth"
end

function modifier_imba_soul_of_truth_buff:GetModifierAura()
	return "modifier_imba_soul_of_truth_vision"
end

function modifier_imba_soul_of_truth_buff:IsAura() return true end

modifier_imba_soul_of_truth_vision = modifier_imba_soul_of_truth_vision or class({})
function modifier_imba_soul_of_truth_vision:CheckState()
	local state = {[MODIFIER_STATE_INVISIBLE] = false}
	return state
end

function modifier_imba_soul_of_truth_vision:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_imba_soul_of_truth_vision:IsHidden() return true end
function modifier_imba_soul_of_truth_vision:IsPurgable() return false end
function modifier_imba_soul_of_truth_vision:IsDebuff() return true end