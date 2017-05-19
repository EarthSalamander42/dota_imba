--[[
		By: AtroCty
		Date: 11.05.2017
		Updated:  11.05.2017
	]]
	
item_imba_aegis = item_imba_aegis or class({})
LinkLuaModifier("modifier_item_imba_aegis", "items/item_aegis.lua", LUA_MODIFIER_MOTION_NONE)
modifier_item_imba_aegis = modifier_item_imba_aegis or class({})
-- Passive modifier
function modifier_item_imba_aegis:OnCreated()
	-- Parameters
	local item = self:GetAbility()
	self:SetDuration(item:GetSpecialValueFor("disappear_time"),true)
	self.reincarnate_time = item:GetSpecialValueFor("reincarnate_time")
	self.vision_radius = item:GetSpecialValueFor("vision_radius")
end

function modifier_item_imba_aegis:OnRefresh()
	self:SetDuration(self:GetAbility():GetSpecialValueFor("disappear_time"),true)
end

function modifier_item_imba_aegis:DeclareFunctions()
    local decFuncs =
	{
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_DEATH
	}
    return decFuncs
end

function modifier_item_imba_aegis:GetPriority()
	return 100
end

function modifier_item_imba_aegis:ReincarnateTime()
	if IsServer() then
		local parent = self:GetParent()
		-- Refresh all your abilities
		for i = 0, 15 do
			local current_ability = parent:GetAbilityByIndex(i)

			-- Refresh
			if current_ability then
				current_ability:EndCooldown()
			end
		end
		self:GetAbility():CreateVisibilityNode(parent:GetAbsOrigin(), self.vision_radius, self.reincarnate_time)
		local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(particle, 1, Vector(self.reincarnate_time,0,0))
		ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
	end
	return self.reincarnate_time
end


function modifier_item_imba_aegis:OnDeath(params)
    if IsServer() then
        -- Only apply if the caster is the unit that died
        if self:GetParent() == params.unit and params.reincarnate then                
			-- Force respawning in the delay time, with no regards to the real respawn timer
			Timers:CreateTimer(FrameTime(), function()
				params.unit:SetTimeUntilRespawn(self.reincarnate_time)
			end)
        end
    end
end

function modifier_item_imba_aegis:IsDebuff() return false end
function modifier_item_imba_aegis:IsHidden() return false end
function modifier_item_imba_aegis:IsPurgable() return false end
function modifier_item_imba_aegis:IsPurgeException() return false end
function modifier_item_imba_aegis:IsStunDebuff() return false end