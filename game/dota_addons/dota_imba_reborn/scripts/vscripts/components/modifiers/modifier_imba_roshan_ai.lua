if modifier_imba_roshan_ai == nil then modifier_imba_roshan_ai = class({}) end

function modifier_imba_roshan_ai:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_imba_roshan_ai:IsPurgeException() return false end
function modifier_imba_roshan_ai:IsPurgable() return false end
function modifier_imba_roshan_ai:IsDebuff() return false end
function modifier_imba_roshan_ai:IsHidden() return true end

function modifier_imba_roshan_ai:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_imba_roshan_ai:OnCreated()
	if IsServer() then
		self.leash_distance = 900
		self.ForwardVector = self:GetParent():GetForwardVector()
		self.returningToLeash = false
		self:StartIntervalThink(1.0)
	end
end

function modifier_imba_roshan_ai:OnIntervalThink()
	-- if Roshan finished returning to his pit, purge him
	if self.returningToLeash == true and self:GetParent():IsIdle() then
		self.returningToLeash = false
		self:GetParent():Purge(false, true, true, true, false)
--		self:SetForwardVector(self.ForwardVector)
	end

	-- if Roshan is too far from pit, return him
	if (self:GetParent():GetAbsOrigin() - _G.ROSHAN_SPAWN_LOC):Length2D() >= self.leash_distance then
		self.returningToLeash = true
		self:GetParent():MoveToPosition(_G.ROSHAN_SPAWN_LOC)
	end
end

-- function modifier_imba_roshan_ai:OnAttackLanded(keys)
	-- if IsServer() then
		-- if self:GetParent() == keys.target then
			-- if keys.attacker:IsIllusion() then
				-- keys.attacker:ForceKill(true)
			-- end
		-- end
	-- end
-- end

function modifier_imba_roshan_ai:OnDeath( keys )
	if keys.unit ~= self:GetParent() then return end

	GAME_ROSHAN_KILLS = GAME_ROSHAN_KILLS + 1

	if keys.attacker and keys.attacker.GetTeamNumber then
		_G.GAME_ROSHAN_KILLER_TEAM = keys.attacker:GetTeamNumber()
	end

	local item = CreateItem("item_aegis", nil, nil)
	local pos = self:GetParent():GetAbsOrigin()
	local drop = CreateItemOnPositionSync(pos, item)
	item:LaunchLoot(false, 300, 0.5, pos)

	if GAME_ROSHAN_KILLS >= 2 then
		for i = 1, GAME_ROSHAN_KILLS -1 do
			local item = CreateItem("item_imba_cheese", nil, nil)
			local drop = CreateItemOnPositionSync(pos, item)
			local new_pos = pos + RandomVector(RandomInt(100, 150))
			
			if GridNav:IsTraversable(new_pos) then
				item:LaunchLoot(false, 300, 0.5, new_pos)
			else
				self:GetParent():DropItemAtPositionImmediate(item, new_pos)
			end
		end
	end

	if GAME_ROSHAN_KILLS >= 3 then
		if GAME_ROSHAN_KILLS == 3 then
			if RollPercentage(50) then
				local item = CreateItem("item_refresher_shard", nil, nil)
				local drop = CreateItemOnPositionSync(pos, item)
				local new_pos = pos + RandomVector(RandomInt(100, 150))
				
				if GridNav:IsTraversable(new_pos) then
					item:LaunchLoot(false, 300, 0.5, new_pos)
				else
					self:GetParent():DropItemAtPositionImmediate(item, new_pos)
				end
			else
				local item = CreateItem("item_ultimate_scepter_2", nil, nil)
				local drop = CreateItemOnPositionSync(pos, item)
				local new_pos = pos + RandomVector(RandomInt(100, 150))
				
				if GridNav:IsTraversable(new_pos) then
					item:LaunchLoot(false, 300, 0.5, new_pos)
				else
					self:GetParent():DropItemAtPositionImmediate(item, new_pos)
				end
			end
		else
			for i = 1, GAME_ROSHAN_KILLS -2 do
				local item = CreateItem("item_refresher_shard", nil, nil)
				local drop = CreateItemOnPositionSync(pos, item)
				local new_pos = pos + RandomVector(RandomInt(100, 150))
				
				if GridNav:IsTraversable(new_pos) then
					item:LaunchLoot(false, 300, 0.5, new_pos)
				else
					self:GetParent():DropItemAtPositionImmediate(item, new_pos)
				end
			end
			
			local item = CreateItem("item_ultimate_scepter_2", nil, nil)
			local drop = CreateItemOnPositionSync(pos, item)
			local new_pos = pos + RandomVector(RandomInt(100, 150))
			
			if GridNav:IsTraversable(new_pos) then
				item:LaunchLoot(false, 300, 0.5, new_pos)
			else
				self:GetParent():DropItemAtPositionImmediate(item, new_pos)
			end
		end
	end

	-- Respawn time for Roshan
	local respawn_time = RandomInt(ROSHAN_RESPAWN_TIME_MIN, ROSHAN_RESPAWN_TIME_MAX) * 60
	Timers:CreateTimer(respawn_time, function()
		local roshan = CreateUnitByName("npc_dota_roshan", _G.ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
		roshan:AddNewModifier(roshan, nil, "modifier_imba_roshan_ai", {})
	end)

	CombatEvents("kill", "roshan_dead", keys.unit, keys.attacker)
end
