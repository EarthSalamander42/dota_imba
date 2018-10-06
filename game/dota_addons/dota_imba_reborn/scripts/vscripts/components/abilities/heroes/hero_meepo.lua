-- Created by Wouterz90: https://github.com/ModDota/AbilityLuaSpellLibrary/blob/master/game/scripts/vscripts/heroes/meepo/divided_we_stand.lua

modifier_meepo_divided_we_stand_lua = modifier_meepo_divided_we_stand_lua or class({})

function modifier_meepo_divided_we_stand_lua.IsHidden(self)
	return false
end
function modifier_meepo_divided_we_stand_lua.IsPermanent(self)
	return true
end
function modifier_meepo_divided_we_stand_lua.OnCreated(self)
	if IsServer() then
		self.StartIntervalThink(self,FrameTime())
	end
end
function modifier_meepo_divided_we_stand_lua.OnIntervalThink(self)
	local meepo = self.GetParent(self)
	local mainMeepo = self.GetCaster(self)
	local ability = self.GetAbility(self)
	if not self.pt then self.pt = nil end
	if mainMeepo~=meepo then
		local boots = {"item_imba_guardian_greaves","item_imba_power_treads_2","item_imba_arcane_boots","item_imba_lifesteal_boots","item_imba_blink_boots"}
		local item = ""
		for _, name in pairs(boots) do
			if item=="" then
				for j=0,5,1 do
					local it = mainMeepo.GetItemInSlot(mainMeepo,j)
					if it and (name==it.GetAbilityName(it)) then
						item=name
						if name == "item_imba_power_treads_2" then
							self.pt = it
						end
					end
				end
			else
				break
			end
		end
		local itemHandle = nil
		if item~="" then
			if meepo["item"] then
				if meepo["item"]~=item then
					UTIL_Remove(meepo["itemHandle"])
					itemHandle = meepo.AddItemByName(meepo,item)
					itemHandle.SetDroppable(itemHandle,false)
					itemHandle.SetSellable(itemHandle,false)
					itemHandle.SetCanBeUsedOutOfInventory(itemHandle,false)
					meepo["itemHandle"]=itemHandle
					meepo["item"]=item
				end
			else
				meepo["itemHandle"]=meepo.AddItemByName(meepo,item)
				meepo["item"]=item
			end
		end
		for j=0,5,1 do
			local itemToCheck = meepo.GetItemInSlot(meepo,j)
			if itemToCheck then
				local name = itemToCheck.GetAbilityName(itemToCheck)
				if name~=item then
					UTIL_Remove(itemToCheck)
				end
			end
		end
		-- Mega Treads fix
		if meepo["itemHandle"] and meepo["item"] and self.pt then
			if meepo["item"] == "item_imba_power_treads_2" then
				if meepo["itemHandle"].state ~= self.pt.state then
					meepo["itemHandle"].state = self.pt.state
				end
			end
		end
		meepo.CalculateStatBonus(meepo)
	end
end
