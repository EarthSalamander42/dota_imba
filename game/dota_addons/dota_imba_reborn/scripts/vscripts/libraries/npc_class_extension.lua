-- Extension of CEntityInstance class.

-- Checks if the entity is any kind of tree (either regular or temporary)
function CEntityInstance:Custom_IsTree()
	if self:Custom_IsRegularTree() or self:Custom_IsTempTree() then
		return true
	end

	return false
end

-- Checks if the entity is a regular tree that spawns in the map
function CEntityInstance:Custom_IsRegularTree()
	if self.CutDown then
		return true	
	end

	return false
end

-- Checks if the entity is a temporary tree that despawns after a while (Furion's Sprout, gg branch etc.)
function CEntityInstance:Custom_IsTempTree()
	if self:GetClassname() == "dota_temp_tree" then
		return true
	end

	return false
end

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
		if not CScriptParticleManager.ACTIVE_PARTICLES then CScriptParticleManager.ACTIVE_PARTICLES = {} end
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
		if not CScriptParticleManager.ACTIVE_PARTICLES then CScriptParticleManager.ACTIVE_PARTICLES = {} end
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

-- Call custom functions whenever EmitSound is being called anywhere
local original_EmitSound = CDOTA_BaseNPC.EmitSound
CDOTA_BaseNPC.EmitSound = function(self, sSoundName, hCaster)
--	print("Create Particle (override):", sSoundName)

	local override_sound = nil

	if IsValidEntity(self) and self.GetPlayerOwnerID and self:GetPlayerOwnerID() and self:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end

	-- call the original function
	local response = original_EmitSound(self, sSoundName)

	return response
end

-- Call custom functions whenever StopSound is being called anywhere
local original_StopSound = CDOTA_BaseNPC.StopSound
CDOTA_BaseNPC.StopSound = function(self, sSoundName, hCaster)
--	print("Create Particle (override):", sSoundName)

local override_sound = nil

	if IsValidEntity(self) and self.GetPlayerOwnerID and self:GetPlayerOwnerID() and self:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end

	-- call the original function
	local response = original_StopSound(self, sSoundName)

	return response
end

local original_EmitSoundOn = EmitSoundOn
EmitSoundOn = function(sSoundName, hParent, hCaster)
--	print("Create Particle (override):", sSoundName)

local override_sound = nil

	if IsValidEntity(hParent) and hParent.GetPlayerOwnerID and hParent:GetPlayerOwnerID() and hParent:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end

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

	if IsValidEntity(hParent) and hParent.GetPlayerOwnerID and hParent:GetPlayerOwnerID() and hParent:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID())
	elseif IsValidEntity(hCaster) and hCaster.GetPlayerOwnerID and hCaster:GetPlayerOwnerID() and hCaster:GetPlayerOwnerID() ~= -1 then
		override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID())
	end
	
	if override_sound then
		--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	end

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

function CDOTA_BaseNPC:GetCastRangeIncrease()
	local cast_range_increase = 0
	-- Only the greatefd st increase counts for items, they do not stack
	for _, parent_modifier in pairs(self:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonus then
			cast_range_increase = math.max(cast_range_increase,parent_modifier:GetModifierCastRangeBonus())
		end
	end

	for _, parent_modifier in pairs(self:FindAllModifiers()) do        
		if parent_modifier.GetModifierCastRangeBonusStacking and parent_modifier:GetModifierCastRangeBonusStacking() then
			cast_range_increase = cast_range_increase + parent_modifier:GetModifierCastRangeBonusStacking()
		end
	end

	return cast_range_increase
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

function CDOTA_BaseNPC:AddRangeIndicator(hCaster, hAbility, sAttribute, iRange, iRed, iGreen, iBlue, bShowOnCooldown, bShowAlways, bWithCastRangeIncrease, bRemoveOnDeath)
	local modifier = self:AddNewModifier(hCaster or self,hAbility, "modifier_imba_range_indicator", {
		sAttribute = sAttribute,
		iRange = iRange,
		iRed = iRed,
		iGreen = iGreen,
		iBlue = iBlue,
		bShowOnCooldown = bShowOnCooldown,
		bShowAlways = bShowAlways,
		bWithCastRangeIncrease = bWithCastRangeIncrease,
		bRemoveOnDeath = bRemoveOnDeath
	})

	if modifier then
		return modifier
	end

	return nil
end

function CDOTA_BaseNPC:CenterCameraOnEntity(hTarget, iDuration)
	PlayerResource:SetCameraTarget(self:GetPlayerID(), hTarget)
	if iDuration == nil then iDuration = FrameTime() end
	if iDuration ~= -1 then
		Timers:CreateTimer(iDuration, function()
			PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			Timers:CreateTimer(FrameTime(), function() --fail-safe
				PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			end)
			Timers:CreateTimer(FrameTime() * 3, function() --fail-safe
				PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
			end)
		end)
	end
end

function CDOTA_BaseNPC:SetCreatureHealth(health, update_current_health)
	self:SetBaseMaxHealth(health)
	self:SetMaxHealth(health)

	if update_current_health then
		self:SetHealth(health)
	end
end

-- Checks if a unit is near units of a certain class on the same team
function CDOTA_BaseNPC:IsNearFriendlyClass(radius, class)
	local class_units = Entities:FindAllByClassnameWithin(class, self:GetAbsOrigin(), radius)

	for _,found_unit in pairs(class_units) do
		if found_unit:GetTeam() == self:GetTeam() then
			return true
		end
	end
	
	return false
end

-- 100% kills a unit. Activates death-preventing modifiers, then removes them. Does not killsteal from Reaper's Scythe.
function CDOTA_BaseNPC:TrueKill(target, ability)
	local modifiers_to_remove = {
		"modifier_invulnerable",
		"modifier_imba_dazzle_shallow_grave",
		"modifier_imba_aphotic_shield_buff_block",
		"modifier_imba_spiked_carapace",
		"modifier_borrowed_time",
		"modifier_imba_centaur_return",
		"modifier_item_greatwyrm_plate_unique",
		"modifier_item_greatwyrm_plate_active",
		"modifier_item_crimson_guard_unique",
		"modifier_item_crimson_guard_active",
		"modifier_item_vanguard_unique",
		"modifier_item_imba_initiate_robe_stacks",
		"modifier_imba_cheese_death_prevention",
		"modifier_imba_rapier_cursed",
		"modifier_imba_dazzle_nothl_protection_aura_talent",
		"modifier_imba_battle_trance_720",
		"modifier_imba_huskar_berserkers_blood_crimson_priest",
	}

	-- Extremely specific blademail interaction because fuck everything
	if self:HasModifier("modifier_item_blade_mail_reflect") then
		target:RemoveModifierByName("modifier_imba_purification_passive")
	end

	local nothlProtection = target:FindModifierByName("modifier_imba_dazzle_nothl_protection")

	if nothlProtection and nothlProtection:GetStackCount() < 1 then
		nothlProtection:SetStackCount(1)
		nothlProtection:StartIntervalThink(1)
	end

	-- Deals lethal damage in order to trigger death-preventing abilities... Except for Reincarnation
	if not ( target:HasModifier("modifier_imba_reincarnation") or target:HasModifier("modifier_imba_reincarnation_wraith_form_buff") or target:HasModifier("modifier_imba_reincarnation_wraith_form") ) then
		target:Kill(ability, self)
	end
	
	if target:HasAbility("imba_huskar_berserkers_blood") and target:FindAbilityByName("imba_huskar_berserkers_blood"):IsCooldownReady() then
		target:FindAbilityByName("imba_huskar_berserkers_blood"):StartCooldown(FrameTime())
	end

	-- Removes the relevant modifiers
	for k, v in pairs(modifiers_to_remove) do
		if target:HasModifier(v) then
			target:RemoveModifierByName(v)
		end
	end

	-- Kills the target
	if not target:HasModifier("modifier_imba_reincarnation_wraith_form") then
		target:Kill(ability, self)
	end
end

function CDOTA_BaseNPC:ChangeAttackProjectileImba()
	local particle_deso = "particles/items_fx/desolator_projectile.vpcf"
	local particle_skadi = "particles/items2_fx/skadi_projectile.vpcf"
	local particle_lifesteal = "particles/item/lifesteal_mask/lifesteal_particle.vpcf"
	local particle_deso_skadi = "particles/item/desolator/desolator_skadi_projectile_2.vpcf"
	local particle_clinkz_arrows = "particles/units/heroes/hero_clinkz/clinkz_searing_arrow.vpcf"
	local particle_dragon_form_green = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_corrosive.vpcf"
	local particle_dragon_form_red = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_fire.vpcf"
	local particle_dragon_form_blue = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
	local particle_terrorblade_transform = "particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf"

	-- If the unit has a Desolator and a Skadi, use the special projectile
	if self:HasModifier("modifier_item_imba_desolator") or self:HasModifier("modifier_item_imba_desolator_2") then
		if self:HasModifier("modifier_item_imba_skadi") then
			self:SetRangedProjectileName(particle_deso_skadi)
		-- If only a Desolator, use its attack projectile instead
		else
			self:SetRangedProjectileName(particle_deso)
		end
	-- If only a Skadi, use its attack projectile instead
	elseif self:HasModifier("modifier_item_imba_skadi") then
		self:SetRangedProjectileName(particle_skadi)

	-- If the unit has any form of lifesteal, use the lifesteal projectile
	elseif self:HasModifier("modifier_imba_morbid_mask") or self:HasModifier("modifier_imba_mask_of_madness") or self:HasModifier("modifier_imba_satanic") or self:HasModifier("modifier_item_imba_vladmir") or self:HasModifier("modifier_item_imba_vladmir_blood") then		
		self:SetRangedProjectileName(particle_lifesteal)	

	-- If it's one of Dragon Knight's forms, use its attack projectile instead
	elseif self:HasModifier("modifier_dragon_knight_corrosive_breath") then
		self:SetRangedProjectileName(particle_dragon_form_green)
	elseif self:HasModifier("modifier_dragon_knight_splash_attack") then
		self:SetRangedProjectileName(particle_dragon_form_red)
	elseif self:HasModifier("modifier_dragon_knight_frost_breath") then
		self:SetRangedProjectileName(particle_dragon_form_blue)

	-- If it's a metamorphosed Terrorblade, use its attack projectile instead
	elseif self:HasModifier("modifier_terrorblade_metamorphosis") then
		self:SetRangedProjectileName(particle_terrorblade_transform)

	-- Else, default to the base ranged projectile
	else
--		print(self:GetKeyValue("ProjectileModel"))
		self:SetRangedProjectileName(self:GetKeyValue("ProjectileModel"))
	end
end

function CDOTA_BaseNPC:CalculateDirection(target)
	local pos1 = self
	local pos2 = target
	if self.GetAbsOrigin then pos1 = self:GetAbsOrigin() end
	if target.GetAbsOrigin then pos2 = target:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	return direction
end

-- Serversided function only
function CDOTA_BaseNPC:DropItem(hItem, sNewItemName, bLaunchLoot)
	local vLocation = GetGroundPosition(self:GetAbsOrigin(), self)
	local sName
	local vRandomVector = RandomVector(100)

	if hItem then
		sName = hItem:GetName()
		self:DropItemAtPositionImmediate(hItem, vLocation)
	else
		sName = sNewItemName
		hItem = CreateItem(sNewItemName, nil, nil)
		CreateItemOnPositionSync(vLocation, hItem)
	end

	if sName == "item_imba_rapier" then
		hItem:GetContainer():SetRenderColor(230,240,35)
	elseif sName == "item_imba_rapier_2" then
		hItem:GetContainer():SetRenderColor(240,150,30)
		hItem.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_trinity.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hItem.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_magic" then
		hItem:GetContainer():SetRenderColor(35,35,240)
	elseif sName == "item_imba_rapier_magic_2" then
		hItem:GetContainer():SetRenderColor(140,70,220)
		hItem.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_archmage.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hItem.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_cursed" then
		hItem.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_cursed.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hItem.rapier_pfx, 0, vLocation + vRandomVector)
		hItem.x_pfx = ParticleManager:CreateParticle("particles/item/rapier/cursed_x.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hItem.x_pfx, 0, vLocation + vRandomVector)
	end

	if bLaunchLoot then
		hItem:LaunchLoot(false, 250, 0.5, vLocation + vRandomVector)
	end
end

-- Autoattack lifesteal
function CDOTA_BaseNPC:GetLifesteal()
	local lifesteal = 0
	local multiplier = 0

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal and parent_modifier:GetModifierLifesteal() then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifestealAmplify and parent_modifier:GetModifierLifestealAmplify() then
			multiplier = multiplier + parent_modifier:GetModifierLifestealAmplify()
		end
	end

	if lifesteal ~= 0 and multiplier ~= 0 then
		lifesteal = lifesteal * (multiplier / 100)
	end

	return lifesteal
end

-- Spell lifesteal
function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	local multiplier = 0

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifesteal and parent_modifier:GetModifierSpellLifesteal() then
			lifesteal = lifesteal + parent_modifier:GetModifierSpellLifesteal()
		end
	end

	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifestealAmplify and parent_modifier:GetModifierSpellLifestealAmplify() then
			multiplier = multiplier + parent_modifier:GetModifierSpellLifestealAmplify()
		end
	end

	if lifesteal ~= 0 and multiplier ~= 0 then
		lifesteal = lifesteal * (multiplier / 100)
	end

	return lifesteal
end

-- Universal damage amplification
function CDOTA_BaseNPC:GetIncomingDamagePct()
	-- Fetch damage amp from modifiers
	local damage_amp = 1
	local vanguard_damage_reduction = 1
	for _, parent_modifier in pairs(self:FindAllModifiers()) do

		-- Vanguard-based damage reduction does not stack
		if parent_modifier.GetCustomIncomingDamageReductionUnique then
			vanguard_damage_reduction = math.min(vanguard_damage_reduction, (100 - parent_modifier:GetCustomIncomingDamageReductionUnique()) * 0.01)
		end

		-- Stack all other custom sources of damage amp
		if parent_modifier.GetCustomIncomingDamagePct then
			damage_amp = damage_amp * (100 + parent_modifier:GetCustomIncomingDamagePct()) * 0.01
		end
	end

	-- Calculate total damage amp
	damage_amp = damage_amp * vanguard_damage_reduction

	return (damage_amp - 1) * 100
end

-- Physical damage block
function CDOTA_BaseNPC:GetDamageBlock()

	-- Fetch damage block from custom modifiers
	local damage_block = 0
	local unique_damage_block = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		-- Vanguard-based damage block does not stack
		if parent_modifier.GetCustomDamageBlockUnique then
			unique_damage_block = math.max(unique_damage_block, parent_modifier:GetCustomDamageBlockUnique())
		end

		-- Stack all other sources of damage block
		if parent_modifier.GetCustomDamageBlock then
			damage_block = damage_block + parent_modifier:GetCustomDamageBlock()
		end
	end

	-- Calculate total damage block
	damage_block = damage_block + unique_damage_block

	-- Ranged attackers only benefit from part of the damage block
	if self:IsRangedAttacker() then
		return 0.6 * damage_block
	else
		return damage_block
	end
end

-- TEMPORARY: No class defined yet

-- Gets all Ethereal abilities
function GetEtherealAbilities()
	local abilities = {
		"modifier_imba_ghost_shroud_active",
		"modifier_imba_ghost_state",
		"modifier_item_imba_ethereal_blade_ethereal",
	}

	return abilities
end

-- Cleave-like cone search - returns the units in front of the caster in a cone.
function FindUnitsInCone(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, targetTeam, targetUnit, targetFlags, findOrder, bCache)
	local vDirectionCone = Vector( vDirection.y, -vDirection.x, 0.0 )
	local enemies = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, endRadius + flLength, targetTeam, targetUnit, targetFlags, findOrder, bCache )
	local unitTable = {}

	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy ~= nil then
				local vToPotentialTarget = enemy:GetOrigin() - vPosition
				local flSideAmount = math.abs( vToPotentialTarget.x * vDirectionCone.x + vToPotentialTarget.y * vDirectionCone.y + vToPotentialTarget.z * vDirectionCone.z )
				local enemy_distance_from_caster = ( vToPotentialTarget.x * vDirection.x + vToPotentialTarget.y * vDirection.y + vToPotentialTarget.z * vDirection.z )
				
				-- Author of this "increase over distance": Fudge, pretty proud of this :D 
				
				-- Calculate how much the width of the check can be higher than the starting point
				local max_increased_radius_from_distance = endRadius - startRadius
				
				-- Calculate how close the enemy is to the caster, in comparison to the total distance
				local pct_distance = enemy_distance_from_caster / flLength
				
				-- Calculate how much the width should be higher due to the distance of the enemy to the caster.
				local radius_increase_from_distance = max_increased_radius_from_distance * pct_distance
				
				if ( flSideAmount < startRadius + radius_increase_from_distance ) and ( enemy_distance_from_caster > 0.0 ) and ( enemy_distance_from_caster < flLength ) then
					table.insert(unitTable, enemy)
				end
			end
		end
	end

	return unitTable
end

-- Check if an unit is near the enemy fountain
function IsNearFountain(location, distance)
	for _, fountain in pairs(Entities:FindAllByClassname("ent_dota_fountain")) do
		if (fountain:GetAbsOrigin() - location):Length2D() <= distance then
			return true
		end
	end

	return false
end
