-- Modified version of Dota Dressing Room - Warmful Ancient library, all credits goes to their respective owners.
-- Credits: https://steamcommunity.com/sharedfiles/filedetails?id=1663264349

--[[
  Wearable Library by pilaoda
  
--]]

require("libraries/activity_modifier")

if not Wearable then
	Wearable = {}
	Wearable.__index = Wearable
	_G.Wearable = Wearable
end

local attach_map = {
	customorigin = PATTACH_CUSTOMORIGIN,
	PATTACH_CUSTOMORIGIN = PATTACH_CUSTOMORIGIN,
	point_follow = PATTACH_POINT_FOLLOW,
	PATTACH_POINT_FOLLOW = PATTACH_POINT_FOLLOW,
	absorigin_follow = PATTACH_ABSORIGIN_FOLLOW,
	PATTACH_ABSORIGIN_FOLLOW = PATTACH_ABSORIGIN_FOLLOW,
	rootbone_follow = PATTACH_ROOTBONE_FOLLOW,
	PATTACH_ROOTBONE_FOLLOW = PATTACH_ROOTBONE_FOLLOW,
	renderorigin_follow = PATTACH_RENDERORIGIN_FOLLOW,
	PATTACH_RENDERORIGIN_FOLLOW = PATTACH_RENDERORIGIN_FOLLOW,
	absorigin = PATTACH_ABSORIGIN,
	PATTACH_ABSORIGIN = PATTACH_ABSORIGIN,
	customorigin_follow = PATTACH_CUSTOMORIGIN_FOLLOW,
	PATTACH_CUSTOMORIGIN_FOLLOW = PATTACH_CUSTOMORIGIN_FOLLOW,
	worldorigin = PATTACH_WORLDORIGIN,
	PATTACH_WORLDORIGIN = PATTACH_WORLDORIGIN
}

local PrismaticParticles = {}

local DefaultPrismatic = {}

local EtherealParticles = {}

local EtherealParticle2Names = {}

function Wearable:Init()
	local npc_heroes = LoadKeyValues("scripts/npc/npc_heroes.txt")
	Wearable.items_game = LoadKeyValues("scripts/items/items_game.txt")

	Wearable.asset_modifier = LoadKeyValues("scripts/items/asset_modifier.txt")
	Wearable.control_points = LoadKeyValues("scripts/items/control_points.txt")
	Wearable.respawn_items = LoadKeyValues("scripts/items/respawn_items.txt")

	Wearable.heroes = {} -- 英雄槽位信息
	Wearable.Index2Name = {}
	for heroname, hero in pairs(npc_heroes) do
		if heroname ~= "Version" then
			Wearable.heroes[heroname] = {}
			Wearable.heroes[heroname]["bundles"] = {}

			Wearable.Index2Name[heroname] = {}

			local heroSlots = Wearable.heroes[heroname]
			if hero.ItemSlots then
				for SlotID, Slot in pairs(hero.ItemSlots) do
					heroSlots[Slot.SlotName] = {}
					local heroSlot = heroSlots[Slot.SlotName]
					heroSlot.SlotIndex = Slot.SlotIndex -- number

					Wearable.Index2Name[heroname][Slot.SlotIndex] = Slot.SlotName

					heroSlot.SlotText = Slot.SlotText
					heroSlot.ItemDefs = {}
					if Slot.DisplayInLoadout then
						heroSlot.DisplayInLoadout = Slot.DisplayInLoadout
					end
				end
			end
		end
	end

	local items = Wearable.items_game.items
	local name2itemdef_Map = {}
	Wearable.items = items -- 所有饰品信息
	Wearable.bundles = {} -- 捆绑包
	Wearable.couriers = {} -- 信使
	Wearable.wards = {} -- 守卫

	for itemDef, item in pairs(items) do
		local used_by_heroes = item.used_by_heroes
		local item_slot = item.item_slot
		if not item_slot then
			item_slot = "weapon"
		end

		if item.prefab == "wearable" and used_by_heroes then
			-- 可佩戴饰品
			for heroname, activated in pairs(used_by_heroes) do
				if activated == 1 then
					local heroSlot = Wearable.heroes[heroname][item_slot]
					if heroSlot then
						table.insert(heroSlot.ItemDefs, itemDef)
						-- 添加款式信息，将用于UI更新
						if item.visuals and item.visuals.styles then
							if not heroSlot.styles then
								heroSlot.styles = {}
							end
							heroSlot.styles[itemDef] = {}
							local style_table = item.visuals.styles
							for style, style_table in pairs(item.visuals.styles) do
								heroSlot.styles[itemDef][style] = {}
								heroSlot.styles[itemDef][style].name = style_table.name
								if
									style_table.alternate_icon and item.visuals.alternate_icons and
										item.visuals.alternate_icons[tostring(style_table.alternate_icon)]
								 then
									heroSlot.styles[itemDef][style].icon_path =
										item.visuals.alternate_icons[tostring(style_table.alternate_icon)].icon_path
								end
							end
						end
					end
				end
			end

			name2itemdef_Map[item.name] = itemDef
		elseif item.prefab == "taunt" and used_by_heroes then
			-- 嘲讽
			for heroname, activated in pairs(used_by_heroes) do
				if activated == 1 then
					item_slot = "taunt"
					local heroSlot = Wearable.heroes[heroname][item_slot]
					if heroSlot then
						table.insert(heroSlot.ItemDefs, itemDef)
					end
				end
			end
		elseif item.prefab == "default_item" and used_by_heroes then
			-- 默认饰品
			for heroname, activated in pairs(used_by_heroes) do
				if activated == 1 then
					if Wearable.heroes[heroname] then
						local heroSlot = Wearable.heroes[heroname][item_slot]
						if heroSlot then
							heroSlot.DefaultItem = itemDef
							table.insert(heroSlot.ItemDefs, itemDef)
						end
					elseif heroname == "all" then
						for heroname2, hero in pairs(Wearable.heroes) do
							local heroSlot = hero[item_slot]
							if heroSlot then
								heroSlot.DefaultItem = itemDef
								table.insert(heroSlot.ItemDefs, itemDef)
							end
						end
					end
				end
			end
		end
	end

	-- 捆绑包
	for itemDef, item in pairs(items) do
		local used_by_heroes = item.used_by_heroes
		if item.prefab == "bundle" and type(used_by_heroes) == "table" then
			for heroname, activated in pairs(used_by_heroes) do
				if activated == 1 then
					table.insert(Wearable.heroes[heroname]["bundles"], itemDef)
					Wearable.bundles[itemDef] = {}
					for subItemName, subItem_activated in pairs(item.bundle) do
						if subItem_activated == 1 then
							subItemDef = name2itemdef_Map[subItemName]
							table.insert(Wearable.bundles[itemDef], subItemDef)
						end
					end
				end
			end
		end
	end

	-- 信使
	for itemDef, item in pairs(items) do
		if item.prefab == "courier" then
			Wearable.couriers[itemDef] = {}
			local item_table = Wearable.couriers[itemDef]
			-- 添加款式信息，将用于UI更新
			if item.visuals and item.visuals.styles then
				item_table.styles = item_table.styles or {}
				local style_table = item.visuals.styles
				for style, style_table in pairs(item.visuals.styles) do
					item_table.styles[style] = {}
					item_table.styles[style].name = style_table.name
					if
						style_table.alternate_icon and item.visuals.alternate_icons and
							item.visuals.alternate_icons[tostring(style_table.alternate_icon)]
					 then
						item_table.styles[style].icon_path =
							item.visuals.alternate_icons[tostring(style_table.alternate_icon)].icon_path
					end
				end
			end
		end
	end

	-- 守卫
	for itemDef, item in pairs(items) do
		if item.prefab == "ward" then
			Wearable.wards[itemDef] = {}
			local item_table = Wearable.wards[itemDef]
			-- 添加款式信息，将用于UI更新
			if item.visuals and item.visuals.styles then
				item_table.styles = item_table.styles or {}
				local style_table = item.visuals.styles
				for style, style_table in pairs(item.visuals.styles) do
					item_table.styles[style] = {}
					item_table.styles[style].name = style_table.name
					if
						style_table.alternate_icon and item.visuals.alternate_icons and
							item.visuals.alternate_icons[tostring(style_table.alternate_icon)]
					 then
						item_table.styles[style].icon_path =
							item.visuals.alternate_icons[tostring(style_table.alternate_icon)].icon_path
					end
				end
			end
		end
	end

	Wearable:UICacheAvailableWards()

	-- 棱彩宝石
	Wearable.prismatics = {}
	for color_key, color_table in pairs(Wearable.items_game.colors) do
		if string.sub(color_key, 1, 8) == "unusual_" then
			Wearable.prismatics[color_key] = color_table
		end
	end

	Wearable.combination = {}

	Convars:RegisterCommand(
		"show_itemdefs",
		Dynamic_Wrap(Wearable, "ShowItemdefs"),
		"show current units' itemdefs",
		FCVAR_NOTIFY
	)

end

function Wearable:RequestParticles()
	Http:RequestParticles(
		function(sBody)
			local hBody = JSON:decode(sBody)
			-- PrintTable(hBody)
			PrismaticParticles = hBody.PrismaticParticles
			DefaultPrismatic = hBody.DefaultPrismatic
			EtherealParticles = hBody.EtherealParticles
			-- 虚灵宝石
			local EtherealParticleKeys = {}
			for sEtherealName, sEtherealParticle in pairs(EtherealParticles) do
				EtherealParticleKeys[sEtherealName] = 1
				EtherealParticle2Names[sEtherealParticle] = sEtherealName
				PrismaticParticles[sEtherealParticle] = 1
			end

			CustomNetTables:SetTableValue("gems", "prismatics", Wearable.prismatics)
			CustomNetTables:SetTableValue("gems", "ethereals", EtherealParticleKeys)
			Wearable.PrismaticParticles = PrismaticParticles
		end
	)
end

function Wearable:ShowItemdefs()
	local hPlayer = Convars:GetCommandClient()
	CustomGameEventManager:Send_ServerToPlayer(hPlayer, "ShowItemdefs", {})
end

function Wearable:WearDefaults(hUnit)
	local hHeroSlots = Wearable.heroes[hUnit:GetUnitName()]
	hUnit.Slots = {}

	-- for i, child in ipairs(hUnit:GetChildren()) do
	--     if child:GetClassname() == "dota_item_wearable" then
	--         child:AddEffects(EF_NODRAW)
	--     end
	-- end

	for sSlotName, hSlot in pairs(hHeroSlots) do
		if hSlot.DefaultItem then
			Wearable:Wear(hUnit, hSlot.DefaultItem)
		end
	end
	local unit_index = hUnit:GetEntityIndex()
	CustomNetTables:SetTableValue("hero_wearables", tostring(unit_index), hUnit.Slots)
end

function Wearable:GetSlotName(sItemDef)
	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	local hItem = Wearable.items[sItemDef]
	local sSlotName = hItem.item_slot
	if hItem.prefab == "taunt" then
		sSlotName = "taunt"
	elseif not sSlotName then
		sSlotName = "weapon"
	end
	return sSlotName
end

function Wearable:GetSlotNameBySlotIndex(hUnit, nSlotIndex)
	local sHeroName = ""
	if type(hUnit) == "string" then
		sHeroName = hUnit
	else
		sHeroName = hUnit:GetUnitName()
	end
	local sSlotName = Wearable.Index2Name[sHeroName][nSlotIndex]
	return sSlotName
end

function Wearable:GetSlotIndex(hUnit, sItemDef)
	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	local sHeroName = hUnit:GetUnitName()
	local hItem = Wearable.items[sItemDef]
	local sSlotName = hItem.item_slot

	if hItem.prefab == "taunt" then
		sSlotName = "taunt"
	elseif not sSlotName then
		sSlotName = "weapon"
	end
	return Wearable.heroes[sHeroName][sSlotName].SlotIndex
end

function Wearable:IsDisplayInLoadout(sHeroName, sSlotName)
	local heroSlots = Wearable.heroes[sHeroName]
	local Slot = heroSlots[sSlotName]
	if (not Slot) or Slot.DisplayInLoadout == 0 then
		return false
	end
	return true
end

function Wearable:GetRepawnUnitName(sHeroName, hNewWears)
	local sUnitName = string.gsub(sHeroName, "npc_dota_hero", "npc_dota_unit")
	local sUnitNameWithWear = sUnitName
	for nSlotIndexNew = 0, 10 do
		local sSlotNameNew = Wearable:GetSlotNameBySlotIndex(sHeroName, nSlotIndexNew)
		if sSlotNameNew and hNewWears[sSlotNameNew] and Wearable:IsDisplayInLoadout(sHeroName, sSlotNameNew) then
			local sItemDefNew = hNewWears[sSlotNameNew].sItemDef
			local sStyleNew = hNewWears[sSlotNameNew].sStyle
			if Wearable.respawn_items[sItemDefNew] == 1 then
				sUnitNameWithWear = sUnitNameWithWear .. "__" .. nSlotIndexNew .. "_" .. sItemDefNew
			end
		end
	end
	return sUnitNameWithWear
end

-- 重生单位，或者重生模式复制单位时，添加非重生饰品时使用
function Wearable:WearAfterRespawn(hUnit, hNewWears)
	hUnit.Slots = {}
	for sSlotName, hNewWear in pairs(hNewWears) do
		local sItemDef = hNewWear.sItemDef
		if Wearable.respawn_items[sItemDef] == 1 and GameRules.herodemo.m_bRespawnWear then
			-- 重生模型设置重生饰品table
			local hWear = {}
			hWear["itemDef"] = sItemDef
			hWear["bRespawnItem"] = true
			hWear["particles"] = {}
			hUnit.Slots[sSlotName] = hWear

			local asset_modifiers = Wearable.asset_modifier[sItemDef]
			if asset_modifiers then
				for _, am_table in pairs(asset_modifiers) do
					if type(am_table) == "table" and am_table.type == "activity" then
						-- 修改动作
						-- print("activity", am_table.modifier)
						if not am_table.style or tostring(am_table.style) == sStyle then
							ActivityModifier:AddWearableActivity(hUnit, am_table.modifier, sItemDef)
							hWear["activity"] = true
						end
					elseif type(am_table) == "table" and am_table.type == "particle_projectile" then
						-- 更换攻击弹道特效
						if
							((not am_table.style) or tostring(am_table.style) == sStyle) and
								(not am_table.spawn_in_loadout_only)
						 then
							local default_projectile = am_table.asset
							local new_projectile = am_table.modifier
							if hUnit:GetRangedProjectileName() == default_projectile then
								hWear["default_projectile"] = default_projectile
								hUnit:SetRangedProjectileName(new_projectile)
							end
						end
					elseif type(am_table) == "table" and am_table.type == "entity_model" then
						-- print("entity_model", am_table.asset)
						-- 更换召唤物模型
						hUnit.summon_model = hUnit.summon_model or {}
						hUnit.summon_model[am_table.asset] = am_table.modifier
						hWear["bChangeSummon"] = hWear["bChangeSummon"] or {}
						hWear["bChangeSummon"][am_table.asset] = true
	
						-- 召唤物skin写在外面，目前发现骨法金棒子 剑圣金猫
						local nSkin = asset_modifiers["skin"]
						if nSkin ~= nil then
							hUnit.summon_skin = nSkin
						end
					end
				end
			end

			if DefaultPrismatic[sItemDef] and not hUnit.prismatic then
				local sPrismaticName = DefaultPrismatic[sItemDef]
				Wearable:SwitchPrismatic(hUnit, sPrismaticName)
			end
		else
			-- 重生模式穿非重生饰品，或者非重生模式穿任意饰品
			Wearable:_WearProp(hUnit, sItemDef, sSlotName, "0")
		end
	end

	if hUnit.prismatic then
		Wearable:SwitchPrismatic(hUnit, hUnit.prismatic)
	end

	if hUnit.ethereals then
		for sEtherealName, old_p_index in pairs(hUnit.ethereals) do
			if old_p_index ~= false then
				ParticleManager:DestroyParticle(old_p_index, true)
				ParticleManager:ReleaseParticleIndex(old_p_index)
				local particle_name = EtherealParticles[sEtherealName]
				local p_index = Wearable:AddParticle(hUnit, nil, particle_name, nil, "0")
				if hUnit.prismatic then
					local sHexColor = Wearable.prismatics[hUnit.prismatic].hex_color
					local vColor = HexColor2RGBVector(sHexColor)
					ParticleManager:SetParticleControl(p_index, 16, Vector(1, 0, 0))
					ParticleManager:SetParticleControl(p_index, 15, vColor)
				end
				hUnit.ethereals[sEtherealName] = p_index
			end
		end
	end

	local unit_index = hUnit:GetEntityIndex()
	CustomNetTables:SetTableValue("hero_wearables", tostring(unit_index), hUnit.Slots)
end

-- 通过重生带饰品的新单位来换多件饰品
function Wearable:_WearItemsRespawn(hUnitOrigin, hNewWears)
	local nUnitIndexOld = hUnitOrigin.nOriginID or hUnitOrigin:GetEntityIndex()

	local sUnitName = hUnitOrigin.sUnitName
	local sUnitNameWithWear = sUnitName

	local hBundle = {}
	for sSubSlotName, hNewWear in pairs(hNewWears) do
		local sSubItemDef = hNewWear.sItemDef
		local sSubItemStyle = hNewWear.sStyle
		local hSubItem = {
			unit = nUnitIndexOld,
			itemDef = sSubItemDef,
			itemStyle = sSubItemStyle,
			slotName = sSubSlotName
		}
		table.insert(hBundle, hSubItem)
	end

	if GameRules.herodemo.m_bRespawnWear then
		sUnitNameWithWear = Wearable:GetRepawnUnitName(hUnitOrigin:GetUnitName(), hNewWears)
	end
	-- 非重生模式时，需要重生一个默认单位，单位名不变

	local hPlayer = hUnitOrigin:GetPlayerOwner()
	local nPlayerID = hPlayer:GetPlayerID()
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(nPlayerID)

	local position = hUnitOrigin:GetAbsOrigin()
	local forward = hUnitOrigin:GetForwardVector()
	print("_WearItemsRespawn", sUnitNameWithWear)

	CreateUnitByNameAsync(
		sUnitNameWithWear,
		position,
		true,
		nil,
		nil,
		hUnitOrigin:GetTeam(),
		function(hUnitNew)
			table.insert(GameRules.herodemo.m_tAlliesList, hUnitNew)
			CustomNetTables:SetTableValue(
				"hero_prismatic",
				tostring(hUnitNew:GetEntityIndex()),
				CustomNetTables:GetTableValue("hero_prismatic", tostring(hUnitOrigin:GetEntityIndex()))
			)
			CustomNetTables:SetTableValue(
				"hero_ethereals",
				tostring(hUnitNew:GetEntityIndex()),
				CustomNetTables:GetTableValue("hero_ethereals", tostring(hUnitOrigin:GetEntityIndex()))
			)

			CustomNetTables:SetTableValue("hero_wearables", tostring(hUnitOrigin:GetEntityIndex()), nil)
			CustomNetTables:SetTableValue("hero_prismatic", tostring(hUnitOrigin:GetEntityIndex()), nil)
			CustomNetTables:SetTableValue("hero_ethereals", tostring(hUnitOrigin:GetEntityIndex()), nil)

			hUnitNew.nOriginID = nUnitIndexOld
			hUnitNew.prismatic = hUnitOrigin.prismatic
			hUnitNew.ethereals = hUnitOrigin.ethereals
			hUnitOrigin:RemoveSelf()
			hUnitNew:SetOwner(hPlayerHero)
			hUnitNew:SetControllableByPlayer(nPlayerID, false)
			-- hUnitNew:SetRespawnPosition(hPlayerHero:GetAbsOrigin())
			FindClearSpaceForUnit(hUnitNew, position, false)
			hUnitNew:SetForwardVector(forward)
			hUnitNew:Hold()
			hUnitNew:SetIdleAcquire(false)
			hUnitNew:SetAcquisitionRange(0)
			hUnitNew.sUnitName = sUnitName
			hUnitNew.sHeroName = string.gsub(sUnitName, "npc_dota_unit", "npc_dota_hero")
			Wearable:WearAfterRespawn(hUnitNew, hNewWears)
			CustomGameEventManager:Send_ServerToPlayer(
				hPlayer,
				"RespawnWear",
				{
					old_unit = nUnitIndexOld,
					new_unit = hUnitNew:GetEntityIndex(),
					bundle = hBundle
				}
			)
		end
	)
end

-- 通过重生带饰品的新单位来换装单件itemDef
function Wearable:_WearRespawn(hUnitOrigin, sItemDef, sSlotName, sStyle)
	local hNewWears = {}

	local hItem = Wearable.items[sItemDef]
	for sSlotNameOrigin, hWearOrigin in pairs(hUnitOrigin.Slots) do
		hNewWears[sSlotNameOrigin] = {
			sItemDef = hWearOrigin["itemDef"],
			sStyle = "0"
		}
	end

	if hItem.prefab == "bundle" then
		for _, sSubItemDef in pairs(Wearable.bundles[sItemDef]) do
			local sSubSlotName = Wearable:GetSlotName(sSubItemDef)
			hNewWears[sSubSlotName] = {
				sItemDef = sSubItemDef,
				sStyle = "0"
			}
		end
	else
		hNewWears[sSlotName] = {
			sItemDef = sItemDef,
			sStyle = "0"
		}
	end

	Wearable:_WearItemsRespawn(hUnitOrigin, hNewWears)
end

-- 判断换某套搭配时是否需要重生
function Wearable:ShouldRespawnForCombination(hUnit, hCombination)
	for _, _hWear in pairs(hUnit.Slots) do
		if _hWear["bRespawnItem"] then
			-- 被替换的饰品中有重生饰品
			return true
		end
	end

	if GameRules.herodemo.m_bRespawnWear then
		for nSlotIndex = 0, 10 do
			local nItemDef = hCombination["itemDef" .. nSlotIndex]
			if Wearable.respawn_items[tostring(nItemDef)] == 1 then
				-- 搭配中有重生饰品
				return true
			end
		end
	end

	return false
end

-- 判断换某个itemDef时是否需要重生，包括捆绑包
function Wearable:ShouldRespawnForItem(hUnit, sItemDef)
	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	local bHasRespawnItem = false
	for _, _hWear in pairs(hUnit.Slots) do
		if _hWear["bRespawnItem"] then
			bHasRespawnItem = true
			break
		end
	end

	local hItem = Wearable.items[sItemDef]
	if hItem.prefab == "bundle" then
		if GameRules.herodemo.m_bRespawnWear then
			for _, sSubItemDef in pairs(Wearable.bundles[sItemDef]) do
				local sSubSlotName = Wearable:GetSlotName(sSubItemDef)
				local hSubWearOld = hUnit.Slots[sSubSlotName]
				if hSubWearOld and hSubWearOld["bRespawnItem"] then
					-- 被替换的槽位中有重生饰品
					return true
				elseif Wearable.respawn_items[sSubItemDef] == 1 then
					-- 捆绑包中有重生饰品
					return true
				end
			end
		else
			if bHasRespawnItem then
				-- 已关闭重生饰品模式，但原单位仍有重生饰品，需要重生一个默认单位
				return true
			end
		end

		return false
	end

	local sSlotName = Wearable:GetSlotName(sItemDef)
	local hWearOld = hUnit.Slots[sSlotName]

	if not GameRules.herodemo.m_bRespawnWear and bHasRespawnItem then
		-- 已关闭重生饰品模式，但原单位仍有重生饰品，需要重生一个默认单位
		return true
	elseif hWearOld and GameRules.herodemo.m_bRespawnWear and hWearOld["bRespawnItem"] then
		-- 被替换的槽位中有重生饰品，需要重生一个不包含该重生饰品的单位
		return true
	elseif GameRules.herodemo.m_bRespawnWear and Wearable.respawn_items[sItemDef] == 1 then
		-- 新饰品为重生饰品
		return true
	else
		return false
	end
end

-- 通过生成prop_dynamic来换装
function Wearable:_WearProp(hUnit, sItemDef, sSlotName, sStyle)
	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	if not sStyle then
		sStyle = "0"
	elseif type(sStyle) ~= "string" then
		sStyle = tostring(sStyle)
	end

	local hItem = Wearable.items[sItemDef]
	local sUnitName = hUnit:GetUnitName()
	local sHeroName = hUnit:GetUnitName()

	local sModel_player = hItem.model_player
	local hWear = {}
	hWear["itemDef"] = sItemDef
	hWear["particles"] = {}

	-- 删除原饰品
	if hUnit.Slots then
		if hUnit.Slots[sSlotName] then

			for p_name, p in pairs(hUnit.Slots[sSlotName]["particles"]) do
				if p ~= false then
					ParticleManager:DestroyParticle(p, true)
					ParticleManager:ReleaseParticleIndex(p)
				end
				if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
					hUnit["prismatic_particles"][p_name] = nil
				end
			end

			if hUnit.Slots[sSlotName]["replace_particle_names"] then
				-- 恢复被替换的特效
				for replace_p_name, _ in pairs(hUnit.Slots[sSlotName]["replace_particle_names"]) do
					for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
						for p_name, sub_p in pairs(hSubWear["particles"]) do
							if replace_p_name == p_name then
								Wearable:AddParticle(hUnit, hSubWear, replace_p_name, sSubSlotName)
								break
							end
						end
					end
				end
			end

			if hUnit.Slots[sSlotName]["default_projectile"] then
				hUnit:SetRangedProjectileName(hUnit.Slots[sSlotName]["default_projectile"])
			end

			if hUnit.Slots[sSlotName]["additional_wearable"] then
				for _, prop in pairs(hUnit.Slots[sSlotName]["additional_wearable"]) do
					if prop and IsValidEntity(prop) then
						prop:RemoveSelf()
					end
				end
			end
			if hUnit.Slots[sSlotName]["model"] then
				local prop = hUnit.Slots[sSlotName]["model"]
				if prop and IsValidEntity(prop) then
					prop:RemoveSelf()
				end
			end
			if hUnit.Slots[sSlotName]["bChangeSkin"] then
				hUnit:SetSkin(0)
			end
			if hUnit.Slots[sSlotName]["bChangeModel"] then
				hUnit:SetOriginalModel(hUnit.old_model)
				hUnit:SetModel(hUnit.old_model)
			end
			if hUnit.Slots[sSlotName]["bChangeSummon"] then
				for sSummonName, b in pairs(hUnit.Slots[sSlotName]["bChangeSummon"]) do
					hUnit.Slots[sSlotName]["bChangeSummon"][sSummonName] = false
					hUnit.summon_model[sSummonName] = nil
				end
			end
			if hUnit.Slots[sSlotName]["activity"] then
				ActivityModifier:RemoveWearableActivity(hUnit, hUnit.Slots[sSlotName].itemDef)
			end

			hUnit.summon_skin = nil
			hUnit.Slots[sSlotName] = nil
		end
	else
		Wearable:SetHeroWearablesTable(hUnit, sSlotName)
		Wearable:_WearProp(hUnit, sItemDef, sSlotName, sStyle)
		return
	end

	hWear["style"] = sStyle

	-- 生成饰品模型
	if sModel_player then
		local sPropClass = Wearable:GetPropClass(hUnit, sItemDef)
		local sDefaultAnim = Wearable:SpecialFixAnim(hUnit, sItemDef)
		local hModel = nil
		if sDefaultAnim then
--			hModel =
--				SpawnEntityFromTableSynchronous(
--				sPropClass,
--				{
--					model = sModel_player,
--					DefaultAnim = sDefaultAnim
--				}
--			)

			hModel = CreateUnitByName("wearable_dummy", hUnit:GetAbsOrigin(), false, nil, nil, hUnit:GetTeam())
		else
--			hModel = SpawnEntityFromTableSynchronous(sPropClass, {model = sModel_player})
			hModel = CreateUnitByName("wearable_dummy", hUnit:GetAbsOrigin(), false, nil, nil, hUnit:GetTeam())
--			hModel:AddNewModifier(self, ability, "modifier_illusion", { duration = duration })
--			hModel:MakeIllusion()
			-- hModel:SetRenderColor(100,100,255)
		end
		hModel:SetOriginalModel(sModel_player)
		hModel:SetModel(sModel_player)
		hModel:AddNewModifier(nil, nil, "modifier_wearable", {})
		hModel:SetOwner(hUnit)
		hModel:SetParent(hUnit, "")
		hModel:FollowEntity(hUnit, true)
		hWear["model"] = hModel
		if hItem.visuals and hItem.visuals.skin then
			hModel:SetSkin(hItem.visuals.skin)
		end
	end

	local asset_modifiers = Wearable.asset_modifier[sItemDef]
	if asset_modifiers then
		for am_name, am_table in pairs(asset_modifiers) do
			if am_name == "styles" then
				-- 不同款式设置模型皮肤
				local style_table = am_table[sStyle]
				if style_table and style_table.model_player and style_table.model_player ~= sModel_player then
					hWear["model"]:SetModel(style_table.model_player)
				end
				if style_table and style_table.skin and hWear["model"] then
					hWear["model"]:SetSkin(style_table.skin)
				end
				if style_table and style_table.skin and not hWear["model"] then
					-- 召唤物款式， 目前仅发现德鲁伊熊灵
					hUnit.summon_skin = style_table.skin
				end
			elseif type(am_table) == "table" and am_table.type == "additional_wearable" then
				-- print("additional_wearable", am_table.asset)
				-- 额外模型
				if not hWear["additional_wearable"] then
					hWear["additional_wearable"] = {}
				end
				local sModel = am_table.asset
				local hModel = SpawnEntityFromTableSynchronous("prop_dynamic", {model = sModel})
				hModel:SetOwner(hUnit)
				hModel:SetParent(hUnit, "")
				hModel:FollowEntity(hUnit, true)
				table.insert(hWear["additional_wearable"], hModel)
			elseif type(am_table) == "table" and am_table.type == "entity_model" then
				-- 更换英雄模型
				-- print("entity_model", am_table.asset)

				if sHeroName == am_table.asset then
					local sNewModel = am_table.modifier
					if not hUnit.old_model then
						hUnit.old_model = hUnit:GetModelName()
					end
					hUnit:SetOriginalModel(sNewModel)
					hUnit:SetModel(sNewModel)
					hWear["bChangeModel"] = true
				else
					-- 更换召唤物模型
					hUnit.summon_model = hUnit.summon_model or {}
					hUnit.summon_model[am_table.asset] = am_table.modifier
					hWear["bChangeSummon"] = hWear["bChangeSummon"] or {}
					hWear["bChangeSummon"][am_table.asset] = true

					-- 召唤物skin写在外面，目前发现骨法金棒子 剑圣金猫
					local nSkin = asset_modifiers["skin"]
					if nSkin ~= nil then
						hUnit.summon_skin = nSkin
					end
				end
			elseif type(am_table) == "table" and am_table.type == "hero_model_change" then
				-- 更换英雄变身模型
				-- print("hero_model_change", am_table.asset)
				if ((not am_table.style) or tostring(am_table.style) == sStyle) then
					hUnit.hero_model_change = am_table
				end
			end
		end

		-- 一定要在更换模型后面，否则可能找不到attachment
		for _, am_table in pairs(asset_modifiers) do
			if type(am_table) == "table" and am_table.type == "particle_create" then
				-- 周身特效
				if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
					local particle_name = am_table.modifier
					local bReplaced = false
					if not Wearable:IsDisplayInLoadout(sHeroName, sSlotName) then
						-- 隐藏槽位查看特效是否已被替换
						for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
							if hSubWear["replace_particle_names"] and hSubWear["replace_particle_names"][particle_name] then
								bReplaced = true
								hWear["particles"][particle_name] = false
								break
							end
						end
					end
					if not bReplaced then
						Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
					end
				end
			elseif type(am_table) == "table" and am_table.type == "particle_replace" then
				-- 替换隐藏槽位里的默认周身特效，此时同槽位旧饰品已被删除，不会检测
				if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
					local default_particle_name = am_table.asset
					local particle_name = am_table.modifier
					for sSubSlotName, hSubWear in pairs(hUnit.Slots) do
						for p_name, sub_p in pairs(hSubWear["particles"]) do
							if default_particle_name == p_name then
								if sub_p ~= false then
									ParticleManager:DestroyParticle(sub_p, true)
									ParticleManager:ReleaseParticleIndex(sub_p)
									hSubWear["particles"][p_name] = false
								end
								break
							end
						end
					end
					Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
					hWear["replace_particle_names"] = hWear["replace_particle_names"] or {}
					hWear["replace_particle_names"][default_particle_name] = true
				end
			elseif type(am_table) == "table" and am_table.type == "particle_projectile" then
				-- 更换攻击弹道特效
				if ((not am_table.style) or tostring(am_table.style) == sStyle) and (not am_table.spawn_in_loadout_only) then
					local default_projectile = am_table.asset
					local new_projectile = am_table.modifier
					if hUnit:GetRangedProjectileName() == default_projectile then
						hWear["default_projectile"] = default_projectile
						hUnit:SetRangedProjectileName(new_projectile)
					end
				end
			elseif type(am_table) == "table" and am_table.type == "model_skin" then
				-- 模型皮肤
				-- print("model_skin", am_table.skin)
				if not am_table.style or tostring(am_table.style) == sStyle then
					hUnit:SetSkin(am_table.skin)
					hWear["bChangeSkin"] = true
				end
			elseif type(am_table) == "table" and am_table.type == "activity" then
				-- 修改动作
				-- print("activity", am_table.modifier)
				if not am_table.style or tostring(am_table.style) == sStyle then
					ActivityModifier:AddWearableActivity(hUnit, am_table.modifier, sItemDef)
					hWear["activity"] = true
				end
			end
		end
	end

	hUnit.Slots[sSlotName] = hWear

	if DefaultPrismatic[sItemDef] and not hUnit.prismatic then
		local sPrismaticName = DefaultPrismatic[sItemDef]
		Wearable:SwitchPrismatic(hUnit, sPrismaticName)
	end

	local unit_id = hUnit:GetEntityIndex()
	if Wearable:IsDisplayInLoadout(hUnit:GetUnitName(), sSlotName) then
		CustomGameEventManager:Send_ServerToAllClients(
			"UpdateWearable",
			{unit = unit_id, itemDef = sItemDef, itemStyle = sStyle, slotName = sSlotName}
		)
	end

	CustomNetTables:SetTableValue("hero_wearables", tostring(unit_id), hUnit.Slots)
end

function Wearable:Wear(hUnit, sItemDef, sStyle)
	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	local hItem = Wearable.items[sItemDef]
	-- print("Wear", sItemDef, hItem, sStyle)

	if hItem.prefab == "bundle" then
		-- 捆绑包
		if Wearable:ShouldRespawnForItem(hUnit, sItemDef) then
			Wearable:_WearRespawn(hUnit, sItemDef)
			return
		end

		for _, sSubItemDef in pairs(Wearable.bundles[sItemDef]) do
			Wearable:Wear(hUnit, sSubItemDef)
		end
		return
	end

	local sSlotName = Wearable:GetSlotName(sItemDef)

	if not sStyle then
		sStyle = "0"
	elseif type(sStyle) ~= "string" then
		sStyle = tostring(sStyle)
	end

	if Wearable:ShouldRespawnForItem(hUnit, sItemDef) then
		Wearable:_WearRespawn(hUnit, sItemDef, sSlotName, sStyle)
	else
		Wearable:_WearProp(hUnit, sItemDef, sSlotName, sStyle)
	end
end

function Wearable:WearCourier(hUnit, sItemDef, sStyle, bFlying, bDire)
	print("WearCourier", hUnit, sItemDef, sStyle, type(sItemDef), type(sStyle), bFlying, bDire)
	local hItem = Wearable.items[sItemDef]

	if type(sItemDef) ~= "string" then
		sItemDef = tostring(sItemDef)
	end

	if not sStyle then
		sStyle = "0"
	elseif type(sStyle) ~= "string" then
		sStyle = tostring(sStyle)
	end

	-- 删除原有特效
	hUnit.skin = 0
	if hUnit["particles"] then
		for p_name, p in pairs(hUnit["particles"]) do
			if p ~= false then
				ParticleManager:DestroyParticle(p, true)
				ParticleManager:ReleaseParticleIndex(p)
			end
			if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
				hUnit["prismatic_particles"][p_name] = nil
			end
			hUnit["particles"][p_name] = nil
		end
	end

	local asset_modifiers = Wearable.asset_modifier[sItemDef]
	if asset_modifiers then
		if asset_modifiers["skin"] then
			-- 设置模型皮肤
			hUnit.skin = asset_modifiers["skin"]
		end
		for am_name, am_table in pairs(asset_modifiers) do
			if am_name == "styles" then
				-- 不同款式设置模型皮肤
				local style_table = am_table[sStyle]
				if style_table and style_table.skin then
					hUnit.skin = style_table.skin
				end
			elseif
				type(am_table) == "table" and
					((bDire and am_table.asset == "dire") or ((not bDire) and am_table.asset == "radiant"))
			 then
				if
					((not bFlying) and type(am_table) == "table" and am_table.type == "courier") or
						(bFlying and type(am_table) == "table" and am_table.type == "courier_flying")
				 then
					if ((not am_table.style) or tostring(am_table.style) == sStyle) then
						local sNewModel = am_table.modifier
						print(sNewModel)
						hUnit:SetOriginalModel(sNewModel)
						hUnit:SetModel(sNewModel)
					end
				end
			end
		end

		hUnit:SetSkin(hUnit.skin)

		for am_name, am_table in pairs(asset_modifiers) do
			if type(am_table) == "table" and am_table.type == "particle_create" then
				-- 周身特效
				if ((not am_table.style) or tostring(am_table.style) == sStyle) then
					if (not am_table.flying_courier_only) or bFlying then
						if ((not am_table.radiant_only) or (not bDire)) and ((not am_table.dire_only) or bDire) then
							local particle_name = am_table.modifier
							local p = Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
							hUnit.particles = hUnit.particles or {}
							hUnit.particles[particle_name] = p
						end
					end
				end
			end
		end
	end

	if bFlying and (not hUnit:HasModifier("flying")) then
		hUnit:AddNewModifier(hUnit, nil, "flying", {})
	elseif (not bFlying) and hUnit:HasModifier("flying") then
		hUnit:RemoveModifierByName("flying")
	end
end

function Wearable:WearWard(hUnit, sItemDef, sStyle)
	print("WearWard", hUnit, sItemDef, sStyle)
	local hItem = Wearable.items[sItemDef]

	if not sStyle then
		sStyle = "0"
	elseif type(sStyle) ~= "string" then
		sStyle = tostring(sStyle)
	end

	-- 删除原有特效
	if hUnit["particles"] then
		for p_name, p in pairs(hUnit["particles"]) do
			if p ~= false then
				ParticleManager:DestroyParticle(p, true)
				ParticleManager:ReleaseParticleIndex(p)
			end
			if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
				hUnit["prismatic_particles"][p_name] = nil
			end
			hUnit["particles"][p_name] = nil
		end
	end

	local asset_modifiers = Wearable.asset_modifier[sItemDef]
	if asset_modifiers then
		for am_name, am_table in pairs(asset_modifiers) do
			if am_name == "styles" then
				-- 不同款式设置模型皮肤
				local style_table = am_table[sStyle]
				if style_table and style_table.skin then
					hUnit.skin = style_table.skin
				end
			elseif
				type(am_table) == "table" and am_table.type == "entity_model" and hUnit:GetUnitName() == am_table.asset
			 then
				if ((not am_table.style) or tostring(am_table.style) == sStyle) then
					local sNewModel = am_table.modifier
					print(sNewModel)
					hUnit:SetOriginalModel(sNewModel)
					hUnit:SetModel(sNewModel)
				end
			end
		end

		for am_name, am_table in pairs(asset_modifiers) do
			if type(am_table) == "table" and am_table.type == "particle_create" then
				-- 周身特效
				if ((not am_table.style) or tostring(am_table.style) == sStyle) then
					local particle_name = am_table.modifier
					local p = Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
					hUnit.particles = hUnit.particles or {}
					hUnit.particles[particle_name] = p
				end
			end
		end
	end
end

function Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)
	-- print("AddParticle", hUnit, hWear, particle_name, sSlotName, sStyle)
	local attach_type = PATTACH_CUSTOMORIGIN
	local attach_entity = hUnit
	if hWear and hWear["model"] then
		attach_entity = hWear["model"]
	end
	local p_table = Wearable.control_points[particle_name]
	if p_table then
		if p_table.attach_type then
			attach_type = attach_map[p_table.attach_type]
		end
		if p_table.attach_entity == "parent" then
			attach_entity = hUnit
		end
	end

	local p = ParticleManager:CreateParticle(particle_name, attach_type, attach_entity)

	if p_table and p_table["control_points"] then
		local cps = p_table["control_points"]
		for _cpi, cp_table in pairs(cps) do
			if (not cp_table.style) or tostring(cp_table.style) == sStyle then
				local control_point_index = cp_table.control_point_index
				attach_type = cp_table.attach_type
				if attach_type == "vector" then
					-- 控制点设置向量
					local vPosition = String2Vector(cp_table.cp_position)
					-- print(p, control_point_index, vPosition)
					ParticleManager:SetParticleControl(p, control_point_index, vPosition)
				else
					-- 控制点绑定实体
					local inner_attach_entity = attach_entity
					local attachment = cp_table.attachment
					if cp_table.attach_entity == "parent" then
						inner_attach_entity = hUnit
					elseif cp_table.attach_entity == "self" and hWear and hWear["model"] then
						inner_attach_entity = hWear["model"]
					end
					local position = hUnit:GetAbsOrigin()
					if cp_table.position then
						position = String2Vector(cp_table.position)
					end
					attach_type = attach_map[attach_type]

					-- 绑定饰品模型，且attachment为空饰品没attachment会让特效消失
					if cp_table.attach_entity ~= "self" or attachment then
						-- print(p, control_point_index, inner_attach_entity, attach_type, attachment, position)
						ParticleManager:SetParticleControlEnt(
							p,
							control_point_index,
							inner_attach_entity,
							attach_type,
							attachment,
							position,
							true
						)
					end
				end
			end
		end
	end

	-- if p_table and p_table["default_color"] and (not hUnit.prismatic) then
	--     local nR = p_table["default_color"].r
	--     local nG = p_table["default_color"].g
	--     local nB = p_table["default_color"].b
	--     ParticleManager:SetParticleControl(p, 16, Vector(1, 0, 0))
	--     ParticleManager:SetParticleControl(p, 15, Vector(nR, nG, nB))
	-- end

	if PrismaticParticles[particle_name] then
		hUnit["prismatic_particles"] = hUnit["prismatic_particles"] or {}
		if hUnit["prismatic_particles"][particle_name] then
			hUnit["prismatic_particles"][particle_name].particle_index = p
		else
			hUnit["prismatic_particles"][particle_name] = {
				particle_index = p,
				slot_name = sSlotName,
				style = sStyle
			}
		end

		if hUnit.prismatic then
			local sHexColor = Wearable.prismatics[hUnit.prismatic].hex_color
			local vColor = HexColor2RGBVector(sHexColor)
			ParticleManager:SetParticleControl(p, 16, Vector(1, 0, 0))
			ParticleManager:SetParticleControl(p, 15, vColor)
		end
	end

	-- print(particle_name, p)
	-- 虚灵特效没有hWear
	if hWear then
		hWear["particles"][particle_name] = p
	end
	return p
end

-- 切换棱彩宝石，如果切换的是已有的则去除
function Wearable:SwitchPrismatic(hUnit, sPrismaticName)
	print("SwitchPrismatic", hUnit.prismatic, sPrismaticName)
	if hUnit.prismatic == sPrismaticName then
		Wearable:RemovePrismatic(hUnit)
		return
	end

	if not hUnit["prismatic_particles"] then
		Notifications:BottomToAll(
			{text = "NoPrismaticParticle", duration = 3, style = { color = "white", ["font-size"] = "30px", ["background-color"] = "rgb(136, 34, 34)", opacity = "0.5" }}
		)
		
		return
	end

	hUnit.prismatic = sPrismaticName
	local sHexColor = Wearable.prismatics[sPrismaticName].hex_color
	local vColor = HexColor2RGBVector(sHexColor)

	for particle_name, p_table in pairs(hUnit["prismatic_particles"]) do
		if not p_table.hidden then
			local particle_index = p_table.particle_index
			local sSlotName = p_table.slot_name
			local sStyle = p_table.style
			local hWear = nil
			if hUnit.Slots then
				hWear = hUnit.Slots[sSlotName]
			end

			if particle_index ~= false then
				ParticleManager:DestroyParticle(particle_index, true)
				ParticleManager:ReleaseParticleIndex(particle_index)
			end
			local new_p_index = Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)

			p_table.particle_index = new_p_index
			if hWear then
				hWear["particles"][particle_name] = new_p_index
			end

			local sEtherealName = EtherealParticle2Names[particle_name]
			if sEtherealName then
				hUnit.ethereals[sEtherealName] = new_p_index
			end
		end
	end

	CustomNetTables:SetTableValue("hero_prismatic", tostring(hUnit:GetEntityIndex()), {prismatic_name = sPrismaticName})
end

-- 移除棱彩宝石
function Wearable:RemovePrismatic(hUnit)
	print("RemovePrismatic")
	hUnit.prismatic = nil

	if not hUnit["prismatic_particles"] then
		return
	end

	for particle_name, p_table in pairs(hUnit["prismatic_particles"]) do
		local particle_index = p_table.particle_index
		local sSlotName = p_table.slot_name
		local sStyle = p_table.style
		local hWear = nil
		if hUnit.Slots then
			hWear = hUnit.Slots[sSlotName]
		end
		if particle_index ~= false then
			ParticleManager:DestroyParticle(particle_index, true)
			ParticleManager:ReleaseParticleIndex(particle_index)
		end
		local new_p_index = Wearable:AddParticle(hUnit, hWear, particle_name, sSlotName, sStyle)

		p_table.particle_index = new_p_index
		if hWear then
			hWear["particles"][particle_name] = new_p_index
		end

		local sEtherealName = EtherealParticle2Names[particle_name]
		if sEtherealName then
			hUnit.ethereals[sEtherealName] = new_p_index
		end
	end

	CustomNetTables:SetTableValue("hero_prismatic", tostring(hUnit:GetEntityIndex()), {prismatic_name = nil})
end

-- 开关虚灵宝石
function Wearable:ToggleEthereal(hUnit, sEtherealName)
	hUnit.ethereals = hUnit.ethereals or {}
	local particle_name = EtherealParticles[sEtherealName]
	if not hUnit.ethereals[sEtherealName] then
		local p_index = Wearable:AddParticle(hUnit, nil, particle_name, nil, "0")
		if hUnit.prismatic then
			local sHexColor = Wearable.prismatics[hUnit.prismatic].hex_color
			local vColor = HexColor2RGBVector(sHexColor)
			ParticleManager:SetParticleControl(p_index, 16, Vector(1, 0, 0))
			ParticleManager:SetParticleControl(p_index, 15, vColor)
		end
		hUnit.ethereals[sEtherealName] = p_index
	else
		local p_index = hUnit.ethereals[sEtherealName]
		if p_index ~= false then
			ParticleManager:DestroyParticle(p_index, true)
			ParticleManager:ReleaseParticleIndex(p_index)
		end
		hUnit.ethereals[sEtherealName] = false
		hUnit["prismatic_particles"][particle_name] = nil
	end

	CustomNetTables:SetTableValue("hero_ethereals", tostring(hUnit:GetEntityIndex()), hUnit.ethereals)
end

-- 重置宝石
function Wearable:ResetGems(hUnit)
	if not hUnit.ethereals then
		return
	end
	for sEtherealName, p_index in pairs(hUnit.ethereals) do
		if p_index then
			Wearable:ToggleEthereal(hUnit, sEtherealName)
		end
	end
	Wearable:RemovePrismatic(hUnit)
end

-- 预读取单位饰品
function Wearable:UICacheAvailableItems(sUnitName)
	local sHeroName = string.gsub(sUnitName, "npc_dota_unit", "npc_dota_hero")
	if not CustomNetTables:GetTableValue("hero_available_items", sUnitName) then
		CustomNetTables:SetTableValue("hero_available_items", sUnitName, Wearable.heroes[sHeroName])
	end
	-- PrintTable(CustomNetTables:GetTableValue("hero_available_items", sUnitName))
end

-- 预读取信使饰品
function Wearable:UICacheAvailableCouriers()
	if not CustomNetTables:GetTableValue("other_available_items", "courier") then
		CustomNetTables:SetTableValue("other_available_items", "courier", Wearable.couriers)
	end
	-- PrintTable(CustomNetTables:GetTableValue("other_available_items", "courier"))
end

-- 预读取守卫饰品
function Wearable:UICacheAvailableWards()
	if not CustomNetTables:GetTableValue("other_available_items", "ward") then
		CustomNetTables:SetTableValue("other_available_items", "ward", Wearable.wards)
	end
	-- PrintTable(CustomNetTables:GetTableValue("other_available_items", "courier"))
end

-- 复制英雄饰品
function Wearable:WearLike(hUnitOrigin, hUnitNew)
	local hHeroSlots = Wearable.heroes[hUnitNew:GetUnitName()]
	hUnitNew.Slots = {}

	for sSlotName, hWear in pairs(hUnitOrigin.Slots) do
		Wearable:Wear(hUnitNew, hWear["itemDef"], hWear["style"])
	end

	local unit_index = hUnitNew:GetEntityIndex()
	CustomNetTables:SetTableValue("hero_wearables", tostring(unit_index), hUnitNew.Slots)
end

-- 隐藏英雄饰品
function Wearable:HideWearables(hUnit)
	-- print("HideWearable", hUnit.Slots, IsServer())
	for sSlotName, hWear in pairs(hUnit.Slots) do
		if hWear["model"] then
			hWear["model"]:AddEffects(EF_NODRAW)
		end
		for p_name, p in pairs(hWear["particles"]) do
			if p ~= false then
				ParticleManager:DestroyParticle(p, true)
				ParticleManager:ReleaseParticleIndex(p)
			end
			if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
				hUnit["prismatic_particles"][p_name].hidden = true
			end
		end
		if hWear["additional_wearable"] then
			for _, prop in pairs(hWear["additional_wearable"]) do
				if prop and IsValidEntity(prop) then
					prop:AddEffects(EF_NODRAW)
				end
			end
		end
	end
end

-- 显示英雄饰品
function Wearable:ShowWearables(hUnit)
	-- print("ShowWearables", hUnit.Slots, IsServer())
	for sSlotName, hWear in pairs(hUnit.Slots) do
		if hWear["model"] then
			hWear["model"]:RemoveEffects(EF_NODRAW)
		end
		for p_name, p in pairs(hWear["particles"]) do
			if hUnit["prismatic_particles"] and hUnit["prismatic_particles"][p_name] then
				hUnit["prismatic_particles"][p_name].hidden = false
			end
			local new_p = Wearable:AddParticle(hUnit, hWear, p_name, sSlotName, hWear["style"])
		end
		if hWear["additional_wearable"] then
			for _, prop in pairs(hWear["additional_wearable"]) do
				if prop and IsValidEntity(prop) then
					prop:RemoveEffects(EF_NODRAW)
				end
			end
		end
	end
end

-- 换装搭配
function Wearable:WearCombination(hUnit, sCombinationID)
	local sHeroName = hUnit:GetUnitName()
	if not type(sCombinationID) == "string" then
		sCombinationID = tostring(sCombinationID)
	end
	local hCombination = Wearable.combination[sCombinationID]
	local nHeroID = DOTAGameManager:GetHeroIDByName(hUnit:GetUnitName())
	if nHeroID ~= tonumber(hCombination.heroID) then
		return
	end
	if Wearable:ShouldRespawnForCombination(hUnit, hCombination) then
		local hNewWears = {}

		for nSlotIndex = 0, 10 do
			local nItemDef = hCombination["itemDef" .. nSlotIndex]
			local sStyle = hCombination["style" .. nSlotIndex]
			local sSlotName = Wearable:GetSlotNameBySlotIndex(sHeroName, nSlotIndex)
			if sSlotName and nItemDef ~= 0 and nItemDef ~= "0" then
				hNewWears[sSlotName] = {sItemDef = tostring(nItemDef), sStyle = sStyle}
			end
		end
		Wearable:_WearItemsRespawn(hUnit, hNewWears)
	else
		for nSlotIndex = 0, 10 do
			local nItemDef = hCombination["itemDef" .. nSlotIndex]
			local sStyle = hCombination["style" .. nSlotIndex]
			local sSlotName = Wearable:GetSlotNameBySlotIndex(sHeroName, nSlotIndex)
			if sSlotName and nItemDef ~= 0 and nItemDef ~= "0" then
				Wearable:_WearProp(hUnit, tostring(nItemDef), sSlotName, sStyle)
			end
		end
		local unit_index = hUnit:GetEntityIndex()
		CustomNetTables:SetTableValue("hero_wearables", tostring(unit_index), hUnit.Slots)
	end
end

-- 缓存搭配
function Wearable:CacheCombination(hCombination)
	hCombination.combinationID = tostring(hCombination.combinationID)
	Wearable.combination[hCombination.combinationID] = hCombination
end

function Wearable:CacheCombinationPage(hPage)
	for _, hCombination in pairs(hPage) do
		Wearable:CacheCombination(hCombination)
	end
end

function Wearable:SpecialFixAnim(hUnit, sItemDef)
	if sItemDef == "9972" then
		-- 修复猛犸凶残螺旋战盔动作
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "12412" then
		-- 修复萨尔不朽武器
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "12414" then
		-- 修复沉默不朽武器
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9462" then
		-- 修复冰魂不朽肩
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9747" or sItemDef == "12424" then
		-- 修复冥魂大帝不朽武器
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7810" or sItemDef == "7813" then
		-- 修复编织者不朽触角
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9235" then
		-- 修复小精灵至宝动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7571" then
		-- 修复虚空不朽武器动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7375" then
		-- 修复海民不朽企鹅动作 其他动作还没支持
	elseif sItemDef == "9059" then
		-- 修复主宰至宝动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9241" then
		-- 修复血魔不朽头动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9196" or sItemDef == "9452" then
		-- 修复大树不朽动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9971" then
		-- 修复猛犸凶残螺旋长角动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9970" then
		-- 修复猛犸凶残螺钻铁槌动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7910" then
		-- 修复蓝胖不朽背部动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "12792" then
		-- 修复巫妖邪会仪式意念动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9756" then
		-- 修复巫妖不朽武器动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9089" then
		-- 修复死灵法不朽武器动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9741" then
		-- 修复末日不朽手臂动作 其他动作还没支持 会随机出现受伤状态bug
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7427" or sItemDef == "7508" then
		-- 修复死灵法不朽肩部动作 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif hUnit:GetUnitName() == "npc_dota_hero_huskar" and Wearable:GetSlotName(sItemDef) == "weapon" then
		-- 修复神灵投矛 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif hUnit:GetUnitName() == "npc_dota_hero_enchantress" and Wearable:GetSlotName(sItemDef) == "weapon" then
		-- 修复小鹿投矛 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "8004" or sItemDef == "8038" or sItemDef == "8010" then
		-- 修复屠夫不朽勾 其他动作还没支持 会随机出现受伤状态bug
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "7509" or sItemDef == "8376" then
		-- 修复黑鸟不朽武器 其他动作还没支持
		return "ACT_DOTA_IDLE"
	elseif sItemDef == "9740" or sItemDef == "12299" then
		-- 修复黑贤不朽手臂 其他动作还没支持
		return "ACT_DOTA_IDLE"
	end
	return nil
end

function Wearable:GetPropClass(hUnit, sItemDef)
	if sItemDef == "4810" then
		-- 蝙蝠不良头巾需要物理
		return "prop_physics"
	end
	return "prop_dynamic"
end

if not Wearable.heroes then
	Wearable:Init()
end

function Wearable:SetHeroWearablesTable(hUnit, sSlotName)
	if not hUnit.Slots then
		hUnit.Slots = {}
		CustomNetTables:SetTableValue("hero_wearables", tostring(hUnit:GetEntityIndex()), hUnit.Slots)
	end

--	print("Default Wearables:")
	for i, child in ipairs(hUnit:GetChildren()) do
		if IsValidEntity(child) and child:GetClassname() == "dota_item_wearable" then
			if child:GetModelName() ~= "" then
				if IsInToolsMode() then
--					print("Wearable:", child, child:GetModelName())
				end

				for key, value in pairs(Wearable.items_game["items"]) do
					if value["model_player"] == child:GetModelName() then
						local item_slot = value["item_slot"]

						if not item_slot then
							item_slot = "weapon"
						end

--						print(key)
--						print(value["model_player"])
--						print(item_slot)

						if not hUnit.Slots[item_slot] then
--							print("Remove wearable:", child:GetModelName())
							UTIL_Remove(child)

							Wearable:_WearProp(hUnit, tonumber(key), item_slot)
						end

						break
					end
				end
			end
		end
	end
end

function Wearable:RemoveWearables(hUnit)
	for i, child in ipairs(hUnit:GetChildren()) do
		if IsValidEntity(child) and child:GetClassname() == "dota_item_wearable" then
			if child:GetModelName() ~= "" then
				UTIL_Remove(child)
			end
		end
	end
end