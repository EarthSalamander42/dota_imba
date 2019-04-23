-- Created by Wouterz90: https://github.com/ModDota/AbilityLuaSpellLibrary/blob/master/game/scripts/vscripts/heroes/meepo/divided_we_stand.lua

modifier_meepo_divided_we_stand_lua = modifier_meepo_divided_we_stand_lua or class({})

function modifier_meepo_divided_we_stand_lua:IsHidden()
	return false
end

function modifier_meepo_divided_we_stand_lua:IsPermanent()
	return true
end

function modifier_meepo_divided_we_stand_lua:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime() * 2) -- could use frametime but i'm not sure if it affects FPS somehow
	end
end

function modifier_meepo_divided_we_stand_lua:OnIntervalThink()
	local boots = {
		"item_imba_guardian_greaves",
		"item_imba_power_treads_2",
		"item_imba_arcane_boots",
		"item_imba_lifesteal_boots",
		"item_imba_blink_boots",
		"item_imba_transient_boots",
	}

	local all_boots = {
		"item_boots",
		"item_travel_boots",
		"item_travel_boots_2",
		"item_tranquil_boots",
		"item_imba_guardian_greaves",
		"item_imba_power_treads_2",
		"item_imba_arcane_boots",
		"item_imba_lifesteal_boots",
		"item_imba_blink_boots",
		"item_imba_transient_boots",
	}

	local break_loop = false
	local ignore_custom_boots = false

	-- if it's a clone
--	print("Clone?", self:GetParent():IsClone())
	if self:GetParent():IsClone() then
		for _, boots in pairs(all_boots) do
			if self:GetParent():HasItemInInventory(boots) then
				ignore_custom_boots = true
				break
			end
		end

		if ignore_custom_boots == false then
			for _, boots_name in pairs(boots) do
--				print("Boots:", boots_name)
				for i = 0, 5 do
					self:GetParent():GetCloneSource().main_boots = nil
					local item = self:GetParent():GetCloneSource():GetItemInSlot(i)
--					print("Item hscript:", i, item)

					-- if a pair of boots is found, do nothing
					if item then
--						print(item:GetAbilityName().." / "..boots_name)
						if item:GetAbilityName() == boots_name then
							self:GetParent():GetCloneSource().main_boots = item
							break_loop = true

							break
						end
					end
				end

				if break_loop == true then
					break
				end
			end
		end

		local found_boots = self:GetParent():GetCloneSource().main_boots

		-- Pair of boots found, do something
		if break_loop == true then
--			print("Boots found in main meepo:", found_boots:GetAbilityName())
			if not self:GetParent():HasItemInInventory(found_boots:GetAbilityName()) then
				self:GetParent():AddItemByName(found_boots:GetAbilityName())
			end
		else
			for _, boots_name in pairs(boots) do
				self:GetParent():RemoveItemByName(boots_name)
			end
		end

		-- Mega Treads fix (not working kappa)
--		if found_boots and found_boots:GetAbilityName() == "item_imba_power_treads_2" then
--			print(found_boots.state.." / "..self:GetParent():FindItemInInventory("item_imba_power_treads_2").state)
--			if found_boots.state ~= self:GetParent():FindItemInInventory("item_imba_power_treads_2").state then
--				found_boots.state = self:GetParent():FindItemInInventory("item_imba_power_treads_2").state
--			end
--		end

		self:GetParent():CalculateStatBonus()
	end
end
