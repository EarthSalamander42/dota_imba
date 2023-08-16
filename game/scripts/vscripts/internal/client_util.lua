require('libraries/keyvalues')
VANILLA_ABILITIES_BASECLASS = require('components/abilities/vanilla_baseclass')

function MergeTables(t1, t2)
	for name, info in pairs(t2) do
		t1[name] = info
	end
end

function PrintTable(t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= "table" then return end

	done = done or {}
	done[t] = true
	indent = indent or 0

	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end

	table.sort(l)
	for k, v in ipairs(l) do
		-- Ignore FDesc
		if v ~= 'FDesc' then
			local value = t[v]

			if type(value) == "table" and not done[value] then
				done[value] = true
				print(string.rep("\t", indent) .. tostring(v) .. ":")
				PrintTable(value, indent + 2, done)
			elseif type(value) == "userdata" and not done[value] then
				done[value] = true
				print(string.rep("\t", indent) .. tostring(v) .. ": " .. tostring(value))
				PrintTable((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
			else
				if t.FDesc and t.FDesc[v] then
					print(string.rep("\t", indent) .. tostring(t.FDesc[v]))
				else
					print(string.rep("\t", indent) .. tostring(v) .. ": " .. tostring(value))
				end
			end
		end
	end
end

function C_DOTA_BaseNPC:HasTalent(talentName)
	if self:HasModifier("modifier_" .. talentName) then
		return true
	end

	return false
end

--Load ability KVs
local AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")

function C_DOTA_BaseNPC:FindTalentValue(talentName, key)
	if self:HasModifier("modifier_" .. talentName) then
		local value_name = key or "value"
		local specialVal = AbilityKV[talentName]["AbilitySpecial"]
		if not specialVal then specialVal = AbilityKV[talentName]["AbilityValues"] end

		for l, m in pairs(specialVal or {}) do
			-- AbilitySpecial structure
			if type(m) == "table" and m[value_name] then
				return m[value_name]
			end

			-- AbilityValues structure
			if l == value_name then
				return m
			end
		end
	end

	return 0
end

function C_DOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = AbilityKV[self:GetName()]
	for k, v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l, m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName and self:GetCaster():HasModifier("modifier_" .. talentName) then
		base = base + self:GetCaster():FindTalentValue(talentName)
	end
	return base
end

function CDOTA_Modifier_Lua:CheckUniqueValue(value, tSuperiorModifierNames)
	local hParent = self:GetParent()
	if tSuperiorModifierNames then
		for _, sSuperiorMod in pairs(tSuperiorModifierNames) do
			if hParent:HasModifier(sSuperiorMod) then
				return 0
			end
		end
	end
	if bit.band(self:GetAttributes(), MODIFIER_ATTRIBUTE_MULTIPLE) == MODIFIER_ATTRIBUTE_MULTIPLE then
		if self:GetStackCount() == 1 then
			return 0
		end
	end
	return value
end

function CDOTA_Modifier_Lua:CheckUnique(bCreated)
	return nil
end

function IsDaytime()
	if CustomNetTables:GetTableValue("game_options", "isdaytime") then
		if CustomNetTables:GetTableValue("game_options", "isdaytime").is_day then
			local is_day = CustomNetTables:GetTableValue("game_options", "isdaytime").is_day

			if is_day == 1 then
				return true
			else
				return false
			end
		end
	end

	return true
end

function C_DOTA_BaseNPC:HasShard()
	if self:HasModifier("modifier_item_aghanims_shard") then
		return true
	end

	return false
end

if not C_DOTA_BaseNPC.GetAttackRange then
	function C_DOTA_BaseNPC:GetAttackRange()
		return self:Script_GetAttackRange()
	end
end

if not C_DOTA_BaseNPC.GetMagicalArmorValue then
	function C_DOTA_BaseNPC:GetMagicalArmorValue()
		local experimental_formula = false
		local inflictor = nil
		return self:Script_GetMagicalArmorValue(experimental_formula, inflictor)
	end
end

--[[
function C_DOTA_BaseNPC:IsInRiver()
	if self:GetAbsOrigin().z < 160 then
		return true
	else
		return false
	end
end
--]]

-- Call custom functions whenever GetAbilityTextureName is being called anywhere
original_Ability_GetAbilityTextureName = C_DOTA_Ability_Lua.GetAbilityTextureName
C_DOTA_Ability_Lua.GetAbilityTextureName = function(self)
	-- call the original function
	local response = original_Ability_GetAbilityTextureName(self)
	local override_image = CustomNetTables:GetTableValue("battlepass_player", response .. '_' .. self:GetCaster():GetPlayerOwnerID())

	--	print(response, override_image)

	if override_image then
		--		print("GetAbilityTextureName (override):", response, override_image["1"])
		response = override_image["1"]
	end

	return response
end

-- Call custom functions whenever GetAbilityTextureName is being called anywhere
original_Item_GetAbilityTextureName = C_DOTA_Item_Lua.GetAbilityTextureName
C_DOTA_Item_Lua.GetAbilityTextureName = function(self)
	-- call the original function
	local response = original_Item_GetAbilityTextureName(self)

	-- special rules for specific items
	if response == "item_radiance" then
		if not self:GetCaster():HasModifier("modifier_imba_radiance_aura") then
			response = "item_radiance_inactive"
		end
	end

	local override_image = CustomNetTables:GetTableValue("battlepass_player", response .. '_' .. self:GetCaster():GetPlayerOwnerID())

	--	print(response)

	if override_image then
		--		print("GetAbilityTextureName (override):", response, override_image["1"])
		response = override_image["1"]
		--		print("New image:", response)
	end

	return response
end

--[[ -- not procing somehow, leaving it there in case
original_Ability_GetEffectName = CDOTA_Modifier_Lua.GetEffectName
CDOTA_Modifier_Lua.GetEffectName = function(self)
	-- call the original function
	local response = original_Ability_GetEffectName(self)
	local override = CustomNetTables:GetTableValue("battlepass_player", response..'_'..self:GetCaster():GetPlayerOwnerID())

	print("GetEffectName (vanilla):", response)

	if override then
		print("GetEffectName (override):", override)
		return override
	end

	return response
end
--]]

--[[
-- Call custom functions whenever GetAttackSound is being called anywhere
original_GetAttackSound = C_DOTA_Ability_Lua.GetAttackSound
C_DOTA_Ability_Lua.GetAttackSound = function(self)
	-- call the original function
	local response = original_GetAttackSound(self)
	local override_sound = CustomNetTables:GetTableValue("battlepass", response..'_'..self:GetCaster():GetPlayerOwnerID())

	if override_sound then
		print("GetAttackSound (override):", response, override_sound["1"])
		response = override_sound["1"]
	end

	return response
end

-- Call custom functions whenever GetHeroEffectName is being called anywhere
original_GetHeroEffectName = C_DOTA_Ability_Lua.GetHeroEffectName
C_DOTA_Ability_Lua.GetHeroEffectName = function(self)
	-- call the original function
	local response = original_GetHeroEffectName(self)
	local override_image = CustomNetTables:GetTableValue("battlepass", response..'_'..self:GetCaster():GetPlayerOwnerID())

	if override_image then
--		print("GetHeroEffectName (override):", response, override_image["1"])
		response = override_image["1"]
	end

	return response
end
--]]
