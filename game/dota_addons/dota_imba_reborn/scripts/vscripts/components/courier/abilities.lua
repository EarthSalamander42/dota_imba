--[[	Author: EarthSalamander #42
		Date: 29.01.2018	]]

courier_movespeed = class({})

function courier_movespeed:GetIntrinsicModifierName()
	return "modifier_courier_turbo"
end

LinkLuaModifier("modifier_courier_turbo", "components/courier/abilities.lua", LUA_MODIFIER_MOTION_NONE)

modifier_courier_turbo = modifier_courier_turbo or class({})

function modifier_courier_turbo:IsPurgable() return false end
function modifier_courier_turbo:IsHidden() return true end
function modifier_courier_turbo:RemoveOnDeath() return false end
--[[
function modifier_courier_turbo:OnCreated()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_courier_flying", {})
	end
end
--]]
function modifier_courier_turbo:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

function modifier_courier_turbo:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
--		MODIFIER_EVENT_ON_MODEL_CHANGED,
	}

	return funcs
end

function modifier_courier_turbo:GetVisualZDelta()
	return 220
end

function modifier_courier_turbo:OnCreated()
	if IsServer() then
		self.fv_set = false
		self:StartIntervalThink(0.1)
	end
end

function modifier_courier_turbo:OnIntervalThink()
	if self:GetParent():IsIdle() then
		if IsNearEntity("ent_dota_fountain", self:GetParent():GetAbsOrigin(), 1200) == true then
			local courier_point = Entities:FindByClassname(nil, "info_courier_spawn_radiant"):GetAbsOrigin()

			if self:GetParent():GetTeamNumber() == 3 then
				courier_point = Entities:FindByClassname(nil, "info_courier_spawn_dire"):GetAbsOrigin()
			end

			if USE_TEAM_COURIER == false then
--				print("Turbo pos!")
				courier_point = IMBA_TURBO_COURIER_POSITION[self:GetParent():GetTeamNumber()][self:GetParent().courier_count]
			end

			local distance = (self:GetParent():GetAbsOrigin() - courier_point):Length2D()

			if distance > 100 then
				self:GetParent():MoveToPosition(courier_point)
				-- move to turbo point using ability
			else
				if self.fv_set == false then
					self.fv_set = true
					-- set forward vector to point over enemy ancient
				end
			end

--			if IsNearEntity(courier_point, 100) then
--			--	print("Courier is at base position, move it to turbo position!")
--			end
		else
			if IsNearEntity("ent_dota_shop", self:GetParent():GetAbsOrigin(), 100) == false then
				self:GetParent():FindAbilityByName("courier_return_to_base"):CastAbility()
			end
		end

		return
	else
		if self.fv_set == true then
			self.fv_set = false
		end
	end
end

function modifier_courier_turbo:GetModifierMoveSpeed_Absolute()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_courier_turbo:GetModifierMoveSpeed_Max()
	return self:GetAbility():GetSpecialValueFor("movespeed")
end
--[[
function modifier_courier_turbo:OnModelChanged()
	Timers:CreateTimer(1.0, function()
		if PlayerResource.GetSteamID == nil then return end
		if tostring(PlayerResource:GetSteamID(self:GetParent():GetOwner():GetPlayerID())) == "76561198015161808" then
			self:GetParent():SetModel("models/items/courier/chocobo/chocobo_flying.vmdl")
			self:GetParent():SetOriginalModel("models/items/courier/chocobo/chocobo_flying.vmdl")

			Timers:CreateTimer(1.0, function()
				local pfx = ParticleManager:CreateParticle("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf", PATTACH_ABSORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(pfx)
			end)
		else
			self:GetParent():SetModel("models/props_gameplay/donkey_wings.vmdl")
			self:GetParent():SetOriginalModel("models/props_gameplay/donkey_wings.vmdl")
		end
	end)
end
--]]
--------------------------------------------
--[[

imba_courier_transfer_items = class({})

function imba_courier_transfer_items:OnSpellStart()
	if IsServer() then
		print("Add item transfer modifier!")
		self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_imba_courier_transfer_items", {})
	end
end

LinkLuaModifier("modifier_imba_courier_transfer_items", "components/courier/abilities.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_courier_transfer_items = modifier_imba_courier_transfer_items or class({})

function modifier_imba_courier_transfer_items:IsPurgable() return false end
function modifier_imba_courier_transfer_items:IsHidden() return false end

function modifier_imba_courier_transfer_items:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
	}
end

function modifier_imba_courier_transfer_items:OnCreated()
	if IsServer() then
		print("Transfer modifier granted")
		self:GetParent():MoveToNPC(self:GetParent():GetOwner())
		self:StartIntervalThink(0.1)
		self:OnIntervalThink()
	end
end

function modifier_imba_courier_transfer_items:OnIntervalThink()
	local distance = (self:GetParent():GetAbsOrigin() - self:GetParent():GetOwner():GetAbsOrigin()):Length2D()

	print("Distance:", distance)
	if distance < self:GetAbility():GetSpecialValueFor("handoff_distance") then
		for itemSlot = 0, 8 do
			local item = self:GetParent():GetItemInSlot(itemSlot)

			if item then
				for itemSlotOwner = 0, 8 do
					print("Free slot in owner inventory?", self:GetParent():GetOwner():HasFreeSlotInInventory())
					if self:GetParent():GetOwner():HasFreeSlotInInventory() then
						self:GetParent():RemoveItem(item)
						self:GetParent():GetOwner():AddItemByName(item:GetName())
					end
				end
			end
		end

		-- fail-safe probably not required but meh
		if self:GetParent():HasModifier("modifier_imba_courier_transfer_items") then
			self:GetParent():RemoveModifierByName("modifier_imba_courier_transfer_items")
		end
	end
end

function modifier_imba_courier_transfer_items:OnOrder(params)
	-- on any order given, remove the modifier
	if params.unit == self:GetParent() then
		-- fail-safe probably not required but meh
		print(params)
		if self:GetParent():HasModifier("modifier_imba_courier_transfer_items") then
			if keys.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
				local ability = EntIndexToHScript(params.entindex_ability)
				print(ability)

				if ability then
					if ability.GetName then
						if ability:GetName() ~= "modifier_imba_courier_transfer_items" then
							self:GetParent():RemoveModifierByName("modifier_imba_courier_transfer_items")
						end
					end
				end
			end
		end
	end
end
--]]
imba_courier_autodeliver = class({})

function imba_courier_autodeliver:OnToggle()
	if self:GetToggleState() == true then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_courier_autodeliver", {})
	else
		self:GetCaster():RemoveModifierByName("modifier_imba_courier_autodeliver")
	end
end

LinkLuaModifier("modifier_imba_courier_autodeliver", "components/courier/abilities.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_courier_autodeliver = modifier_imba_courier_autodeliver or class({})

function modifier_imba_courier_autodeliver:IsPurgable() return false end
function modifier_imba_courier_autodeliver:IsHidden() return false end

function modifier_imba_courier_autodeliver:OnCreated()
	if IsServer() then
		self.deliver_time_check = 0.0
		self:StartIntervalThink(1.0)
		ExecuteOrderFromTable(newOrder)
	end
end

-- BUG TODO: courier don't deliver any items when it spawn until you give him any order
function modifier_imba_courier_autodeliver:OnIntervalThink()
	if self:GetParent():GetOwner() == nil then self:StartIntervalThink(-1) return end

--	print("Idle?", self:GetParent():IsIdle())

	-- if the courier is moving or is near secret shop, end the script
--	print("Near secret shop?", IsNearEntity("ent_dota_shop", self:GetParent():GetAbsOrigin(), 100))
	if not self:GetParent():IsIdle() or IsNearEntity("ent_dota_shop", self:GetParent():GetAbsOrigin(), 100) == true then
		self.deliver_time_check = 0.0
		return
	end

	local has_item_to_deliver = false

	-- check if the courier have an item in inventory
	for itemSlot = 0, 8 do
		local item = self:GetParent():GetItemInSlot(itemSlot)

		if item then
		--	print("Item to deliver! (in courier)")
			has_item_to_deliver = true
			break
		end
	end

	-- check if the owner have an item in stash
	if has_item_to_deliver == false then
		for itemSlot = 9, 14 do
			local item = self:GetParent():GetOwner():GetItemInSlot(itemSlot)

			if item then
			--	print("Item to deliver! (in stash)")
				has_item_to_deliver = true
				break
			end
		end
	end

--	print("item to deliver?", has_item_to_deliver)

	if has_item_to_deliver == true then
		-- if the hero buy an item, reset the timer and end the function
		if self:GetParent():GetOwner().reset_turbo_deliver == true then
		--	print("Hero bought an item, refresh timer!")
			self:GetParent():GetOwner().reset_turbo_deliver = false -- TODO: set this value to false only when the courier meets the hero
			self.deliver_time_check = 0.0
			return
		-- if the hero didn't buy an item between the last check, increase the timer
		else
			self.deliver_time_check = self.deliver_time_check + 1.0
		--	print("Increase timer check:", self.deliver_time_check)
		end

	--	print("Timer check:", self.deliver_time_check.." / "..self:GetAbility():GetSpecialValueFor("delay"))
		-- if the timer is equal or higher than the autodeliver time, deliver items and reset timer to 0
		if self.deliver_time_check >= self:GetAbility():GetSpecialValueFor("delay") then
			-- check if the owner have free slots to receive items
			local has_free_slot = self:GetParent():GetOwner():HasFreeSlotInInventory()

		--	print("Hero have free slot?", has_free_slot)

			-- if the hero have at least 1 free slot, auto-deliver and reset timer
			if has_free_slot == true then
--				print(self:GetParent():IsControllableByAnyPlayer())
--				ExecuteOrderFromTable({ UnitIndex = self:GetParent():entindex(), OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET, AbilityIndex = self:GetParent():FindAbilityByName("courier_take_stash_and_transfer_items"):GetEntityIndex(), Queue = false})
				self:GetParent():FindAbilityByName("courier_take_stash_and_transfer_items"):CastAbility()
				self.deliver_time_check = 0.0
			else
			--	print("hero inventory is full!")
			end
		end
	end
end
