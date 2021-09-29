-- Extension of CDOTA_BaseNPC class.

function CDOTA_BaseNPC:GetNetworth()
	if not self:IsRealHero() then return 0 end
	local gold = self:GetGold()

	-- Iterate over item slots adding up its gold cost
	for i = 0, 15 do
		local item = self:GetItemInSlot(i)
		if item then
			gold = gold + item:GetCost()
		end
	end

	return gold
end

-- Initializes heroes' innate abilities
function CDOTA_BaseNPC:InitializeAbilities()	
	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do		
		local current_ability = self:GetAbilityByIndex(i)		

		if current_ability then
			if current_ability.IsInnateAbility and current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end

			if current_ability.IsDisabledByDefault and current_ability:IsDisabledByDefault() then
				current_ability:SetActivated(false)
			end
		end
	end
end

function CDOTA_BaseNPC:FindItemByName(ItemName, bBackpack, bStash)
	local count = 5

	if bBackpack == true then
		count = 8
	end

	if bStash == true then
		count = 14
	end

	for slot = 0, count do
		local item = self:GetItemInSlot(slot)
		if item then
			if item:GetName() == ItemName then
				return item
			end
		end
	end

	return nil
end

function CDOTA_BaseNPC:RemoveItemByName(ItemName, bStash)
	local count = 8

	if bStash == true then
		count = 14
	end

	for slot = 0, count do
		local item = self:GetItemInSlot(slot)
		if item then
			if item:GetName() == ItemName then
				self:RemoveItem(item)
				break
			end
		end
	end
end

-- Checks if the attacker's damage is classified as "hero damage".	 More `or`s may need to be added.
function CDOTA_BaseNPC:IsHeroDamage(damage)
	if damage > 0 then
		if self:GetName() == "npc_dota_roshan" or self:IsControllableByAnyPlayer() or self:GetName() == "npc_dota_shadowshaman_serpentward" then
			return true
		end
	end

	return false
end

-- Checks if a given unit is Roshan
function CDOTA_BaseNPC:IsRoshan()
	if self:GetName() == "npc_imba_roshan" or self:GetName() == "npc_dota_roshan" or self:GetUnitLabel() == "npc_diretide_roshan" then
		return true
	else
		return false
	end
end

function CDOTA_BaseNPC:StopCustomMotionControllers()
	local modifiers = self:FindAllModifiers()

	for _,modifier in pairs(modifiers) do
		if modifier.IsMotionController then
			if modifier.IsMotionController() then
				modifier:Destroy()
			end
		end
	end
end

function CDOTA_BaseNPC:SetUnitOnClearGround()
	Timers:CreateTimer(FrameTime(), function()
		self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
		ResolveNPCPositions(self:GetAbsOrigin(), 64)
	end)
end

-- Safely checks if this unit is a hero or a creep
function CDOTA_BaseNPC:IsHeroOrCreep()
	if self.IsCreep and self:IsCreep() then
		return true
	elseif self.IsHero and self:IsHero() then
		return true
	end
	return false
end

function CDOTA_BaseNPC:IsImbaInvisible()
	if self:IsInvisible() then return true end

	for _, modifier in pairs(IMBA_INVISIBLE_MODIFIERS) do
		if self:HasModifier(modifier) then
			return true
		end
	end

	return false
end

-- Talent handling
function CDOTA_BaseNPC:HasTalent(talentName)
	if self and not self:IsNull() and self:HasAbility(talentName) then
		if self:FindAbilityByName(talentName):GetLevel() > 0 then return true end
	end

	return false
end

function CDOTA_BaseNPC:FindTalentValue(talentName, key)
	if self:HasAbility(talentName) then
		local value_name = key or "value"
		return self:FindAbilityByName(talentName):GetSpecialValueFor(value_name)
	end

	return 0
end

function CDOTA_BaseNPC:HighestTalentTypeValue(talentType)
	local value = 0
	for i = 0, 23 do
		local talent = self:GetAbilityByIndex(i)
		if talent and string.match(talent:GetName(), "special_bonus_"..talentType.."_(%d+)") and self:FindTalentValue(talent:GetName()) > value then
			value = self:FindTalentValue(talent:GetName())
		end
	end

	return value
end

function CDOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = self:GetAbilityKeyValues()
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName then 
		local talent = self:GetCaster():FindAbilityByName(talentName)
		if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
	end
	return base
end

function CDOTA_BaseNPC:GetTeamRealName()
	local team = {}
	team[2] = "Radiant"
	team[3] = "Dire"

	return team[self:GetTeamNumber()]
end

function CDOTA_BaseNPC:GetIllusionBounty()
	return self:GetLevel() * 2
end

local ignored_pfx_list = {}
ignored_pfx_list["particles/dev/empty_particle.vpcf"] = true
ignored_pfx_list["particles/ambient/fountain_danger_circle.vpcf"] = true
ignored_pfx_list["particles/range_indicator.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_skeletonking/wraith_king_ambient_custom.vpcf"] = true
ignored_pfx_list["particles/generic_gameplay/radiant_fountain_regen.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_wisp/wisp_tether.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_donkey_ti7/courier_donkey_ti7_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_roshan_darkmoon/courier_roshan_darkmoon.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_roshan_desert_sands/baby_roshan_desert_sands_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_babyroshan_winter18/courier_babyroshan_winter18_ambient.vpcf"] = true
ignored_pfx_list["particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf"] = true
ignored_pfx_list["particles/hero/slardar/slardar_rain_cloud.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_earth_spirit/espirit_stoneremnant.vpcf"] = true
ignored_pfx_list["particles/econ/items/tiny/tiny_prestige/tiny_prestige_tree_ambient.vpcf"] = true
ignored_pfx_list["particles/item/rapier/item_rapier_trinity.vpcf"] = true
ignored_pfx_list["particles/item/rapier/item_rapier_archmage.vpcf"] = true
ignored_pfx_list["particles/item/rapier/item_rapier_cursed.vpcf"] = true
ignored_pfx_list["particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_ambient_mace_aeons.vpcf"] = true
ignored_pfx_list["particles/econ/events/ti7/ti7_hero_effect_1.vpcf"] = true
ignored_pfx_list["particles/econ/events/ti9/ti9_emblem_effect_loadout.vpcf"] = true
ignored_pfx_list["particles/econ/events/ti8/ti8_hero_effect.vpcf"] = true
ignored_pfx_list["particles/econ/events/ti7/ti7_hero_effect.vpcf"] = true
ignored_pfx_list["particles/econ/events/ti10/emblem/ti10_emblem_effect.vpcf"] = true
ignored_pfx_list["particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"] = true

-- Call custom functions whenever CreateParticle is being called anywhere
local original_CreateParticle = CScriptParticleManager.CreateParticle
CScriptParticleManager.CreateParticle = function(self, sParticleName, iAttachType, hParent, hCaster)
	local override = nil

--[[
		if hCaster then
			override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
		end
		
		if override then
			sParticleName = override["1"]
		end
--]]
		
--	print("CreateParticle response:", sParticleName)

	-- call the original function
	local response = original_CreateParticle(self, sParticleName, iAttachType, hParent)

	if not ignored_pfx_list[sParticleName] then
		table.insert(CScriptParticleManager.ACTIVE_PARTICLES, {response, 0})
	end

	return response
end

-- Call custom functions whenever CreateParticleForTeam is being called anywhere
local original_CreateParticleForTeam = CScriptParticleManager.CreateParticleForTeam
CScriptParticleManager.CreateParticleForTeam = function(self, sParticleName, iAttachType, hParent, iTeamNumber, hCaster)
--	print("Create Particle (override):", sParticleName, iAttachType, hParent, iTeamNumber, hCaster)

	local override = nil

--[[
	if hCaster then
		override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
	end

	if override then
		sParticleName = override["1"]
	end
--]]

	-- call the original function
	local response = original_CreateParticleForTeam(self, sParticleName, iAttachType, hParent, iTeamNumber)

	if not ignored_pfx_list[sParticleName] then
		table.insert(CScriptParticleManager.ACTIVE_PARTICLES, {response, 0})
	end

	return response
end

-- Call custom functions whenever CreateParticleForPlayer is being called anywhere
local original_CreateParticleForPlayer = CScriptParticleManager.CreateParticleForPlayer
CScriptParticleManager.CreateParticleForPlayer = function(self, sParticleName, iAttachType, hParent, hPlayer, hCaster)
--	print("Create Particle (override):", sParticleName, iAttachType, hParent, hPlayer, hCaster)

	local override = nil

--[[
	if hCaster then
		override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
	end

	if override then
		sParticleName = override["1"]
	end
--]]

	-- call the original function
	local response = original_CreateParticleForPlayer(self, sParticleName, iAttachType, hParent, hPlayer)

	if not ignored_pfx_list[sParticleName] then
		table.insert(CScriptParticleManager.ACTIVE_PARTICLES, {response, 0})
	end

	return response
end

-- Call custom functions whenever CreateIllusions is being called anywhere
local original_CreateIllusions = CreateIllusions
CreateIllusions = function(hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
--	print("Create Illusions (override):", hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

	-- call the original function
	local response = original_CreateIllusions(hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

	for i = 1, #response do
		local illusion = response[i]

		if hModifierKeys.duration and type(hModifierKeys.duration) == "number" then
			print("Add fail-safe kill target in "..hModifierKeys.duration.." seconds.")
			illusion:AddNewModifier(hOwner, nil, "modifier_kill", {duration = hModifierKeys.duration})
		end
	end

	return response
end

CDOTA_BaseNPC.SOUNDS_OVERRIDE = {}

-- Call custom functions whenever EmitSound is being called anywhere
local original_EmitSound = CDOTA_BaseNPC.EmitSound
CDOTA_BaseNPC.EmitSound = function(self, sSoundName, hCaster)
--	print("Create Particle (override):", sSoundName)

	local override_sound = nil

--[[
	if IsValidEntity(self) and self.GetPlayerOwnerID and self:GetPlayerOwnerID() and self:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end
--]]

	-- call the original function
	local response = original_EmitSound(self, sSoundName)

	return response
end

-- Call custom functions whenever StopSound is being called anywhere
local original_StopSound = CDOTA_BaseNPC.StopSound
CDOTA_BaseNPC.StopSound = function(self, sSoundName, hCaster)
--	print("Create Particle (override):", sSoundName)

local override_sound = nil

--[[
	if IsValidEntity(self) and self.GetPlayerOwnerID and self:GetPlayerOwnerID() and self:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end
--]]

	-- call the original function
	local response = original_StopSound(self, sSoundName)

	return response
end

local original_EmitSoundOn = EmitSoundOn
EmitSoundOn = function(sSoundName, hParent, hCaster)
--	print("Create Particle (override):", sSoundName)

local override_sound = nil

--[[
	if IsValidEntity(hParent) and hParent.GetPlayerOwnerID and hParent:GetPlayerOwnerID() and hParent:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end
--]]

	-- call the original function
	local response = original_EmitSoundOn(sSoundName, hParent)

	return response
end

local original_EmitSoundOnLocationWithCaster = EmitSoundOnLocationWithCaster
EmitSoundOnLocationWithCaster = function(vLocation, sSoundName, hParent, hCaster)
	if hParent == nil then
		print("CRITICAL ERROR: Missing hParent for function: EmitSoundOnLocationWithCaster.")
		return
	end

--	print("Create Particle (override):", sSoundName)

	local override_sound = nil

--[[
	if IsValidEntity(hParent) and hParent.GetPlayerOwnerID and hParent:GetPlayerOwnerID() and hParent:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end
--]]

	-- call the original function
	local response = original_EmitSoundOnLocationWithCaster(vLocation, sSoundName, hCaster)

	return response
end

-- Currently only checks stuff for monkey king
function CDOTA_BaseNPC:IsEligibleHero()
	if (self:GetName() == "npc_dota_hero_monkey_king" or self:GetName() == "npc_dota_hero_rubick") and self:GetAbsOrigin() ~= Vector(0,0,0) then 
		return false
	end

	return true
end

----------------------------------------------------------------------------------
-- credits to yahnich for every functions below
----------------------------------------------------------------------------------

function CDOTA_BaseNPC:IsFakeHero()
	if self:IsIllusion() or (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")) or self:IsTempestDouble() or self:IsClone() then
		return true
	end

	return false
end

function CDOTA_BaseNPC:IsRealHero()
	if not self:IsNull() then
		return self:IsHero() and not ( self:IsIllusion() or self:IsClone() ) and not self:IsFakeHero()
	end
end

function CDOTA_BaseNPC:Blink(position, bTeamOnlyParticle, bPlaySound)
	if self:IsNull() then return end

	if bPlaySound == true then EmitSoundOn("DOTA_Item.BlinkDagger.Activate", self) end

	local blink_pfx
	local blink_pfx_name = "particles/items_fx/blink_dagger_start.vpcf"

	if bTeamOnlyParticle == true then
		blink_pfx = ParticleManager:CreateParticleForTeam(blink_pfx_name, PATTACH_CUSTOMORIGIN, nil, self:GetTeamNumber(), self)
		ParticleManager:SetParticleControl(blink_pfx, 0, self:GetAbsOrigin())
	else
		blink_pfx = ParticleManager:CreateParticle(blink_pfx_name, PATTACH_CUSTOMORIGIN, nil, self)
		ParticleManager:SetParticleControl(blink_pfx, 0, self:GetAbsOrigin())
	end

	ParticleManager:ReleaseParticleIndex(blink_pfx)
	FindClearSpaceForUnit(self, position, true)
	ProjectileManager:ProjectileDodge( self )

	local blink_end_pfx
	local blink_end_pfx_name = "particles/items_fx/blink_dagger_end.vpcf"

	if bTeamOnlyParticle == true then
		blink_end_pfx = ParticleManager:CreateParticleForTeam(blink_end_pfx_name, PATTACH_ABSORIGIN, self, self:GetTeamNumber(), self)
	else
		blink_end_pfx = ParticleManager:CreateParticle(blink_end_pfx_name, PATTACH_ABSORIGIN, self, self)
	end

	ParticleManager:ReleaseParticleIndex(blink_end_pfx)

	if bPlaySound == true then EmitSoundOn("DOTA_Item.BlinkDagger.NailedIt", self) end
end

function CDOTA_BaseNPC:GetAverageBaseDamage()
	return (self:GetBaseDamageMax() + self:GetBaseDamageMin()) / 2
end

function CDOTA_BaseNPC:SetAverageBaseDamage(average, variance) -- variance is in percent (50 not 0.5)
	local var = variance or ((self:GetBaseDamageMax() / self:GetBaseDamageMin()) * 100 )
	self:SetBaseDamageMax(math.ceil(average*(1+(var/100))))
	self:SetBaseDamageMin(math.floor(average*(1-(var/100))))
end

function CDOTA_BaseNPC:HasShard()
	if self:HasModifier("modifier_item_aghanims_shard") then
		return true
	end

	return false
end

function CDOTA_BaseNPC:IsCustomHero()
	if GetKeyValueByHeroName(self:GetUnitName(), "IsCustom") and GetKeyValueByHeroName(self:GetUnitName(), "IsCustom") == 1 then
		return true
	end

	return false
end

-- Call custom functions whenever AddNewModifier is being called anywhere
local original_AddNewModifier = CDOTA_BaseNPC.AddNewModifier
CDOTA_BaseNPC.AddNewModifier = function(self, hCaster, hAbility, pszScriptName, hModifierTable)
--	print("Add new modifier (override):", hCaster, hAbility, pszScriptName, hModifierTable)

	if not self or not IsValidEntity(self) or pszScriptName == nil then
		print("AddNewModifier: Invalid arguments which might crash the game, let's prevent that.")

		return
	end

	-- call the original function
	local response = original_AddNewModifier(self, hCaster, hAbility, pszScriptName, hModifierTable)

	return response
end
