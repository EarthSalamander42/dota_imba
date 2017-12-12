--[[
		Author: MouJiaoZi
		Date: 2017/12/12


]]

item_tpscroll = item_tpscroll or class({})

LinkLuaModifier("modifier_item_imba_tpscroll_active", "items/item_tp", LUA_MODIFIER_MOTION_NONE)

function item_tpscroll:GetAOERadius() return self:GetSpecialValueFor("maximum_distance") end

function item_tpscroll:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local max_distance = ability:GetSpecialValueFor("maximum_distance")
	local start_pfx_name = "particles/items2_fx/teleport_start.vpcf"
	local end_pfx_name = "particles/items2_fx/teleport_end.vpcf"
	self.location = Vector(0,0,0)
	local building = FindUnitsInRadius(caster:GetTeamNumber(), ability:GetCursorPosition(), nil, max_distance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
	if #building >= 1 then
		self.location = ability:GetCursorPosition()
	else
		local building = FindUnitsInRadius(caster:GetTeamNumber(), ability:GetCursorPosition(), nil, 9999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local building_pos = building[1]:GetAbsOrigin()
		self.location = ((caster:GetAbsOrigin() - building_pos) * max_distance) + building_pos
	end
	self.buff = caster:AddNewModifier(caster, ability, "modifier_item_imba_tpscroll_active", {duration = ability:GetSpecialValueFor("tooltip_channel_time")})
	self.start_pfx = ParticleManager:CreateParticle(start_pfx_name, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(self.start_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 4, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.start_pfx, 6, caster:GetAbsOrigin())
	self.end_pfx = ParticleManager:CreateParticle(end_pfx_name, PATTACH_WORLDORIGIN, caster)
	for i=0,3 do
		ParticleManager:SetParticleControl(self.end_pfx, i, self.location)
	end
	ParticleManager:SetParticleControl(self.end_pfx, 5, self.location)
end

function item_tpscroll:OnChannelThink( fInterval )
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self.location, self:GetSpecialValueFor("vision_radius"), FrameTime(), false)
end

function item_tpscroll:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	local ability = self
	if bInterrupted then -- unsuccessful
		self.buff:Destroy()

	else -- successful


	end
	ParticleManager:DestroyParticle(self.start_pfx, false)
	ParticleManager:DestroyParticle(self.end_pfx, false)
	ParticleManager:ReleaseParticleIndex(self.start_pfx)
	ParticleManager:ReleaseParticleIndex(self.end_pfx)
end

modifier_item_imba_tpscroll_active = modifier_item_imba_tpscroll_active or class({})