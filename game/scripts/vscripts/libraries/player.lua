-- Extension of CDOTA_BaseNPC class.

-- Deprecated
-- some of the code is based on yahnich's version of Boss Hunters illusion system
function CDOTA_BaseNPC:CreateIllusion(duration, inc, out, pos, mod, ab)
	if pos == nil then
		pos = self:GetAbsOrigin() + RandomVector(RandomInt(50, 100))
	else
		pos = pos + RandomVector(RandomInt(50, 100))
	end

	local illusion = CreateUnitByName(self:GetUnitName(), pos, true, self, nil, self:GetTeamNumber())
	FindClearSpaceForUnit(self, self:GetAbsOrigin() + RandomVector(RandomInt(10, 100)), true)
	FindClearSpaceForUnit(illusion, illusion:GetAbsOrigin(), true)

	illusion:SetBaseMaxHealth(self:GetMaxHealth())
	illusion:SetMaxHealth(self:GetMaxHealth())
	illusion:SetHealth(self:GetHealth())
	illusion:SetMana(self:GetMana())

--	illusion:SetAverageBaseDamage(self:GetAverageBaseDamage(), 15)
--	illusion:SetPhysicalArmorBaseValue(self:GetPhysicalArmorValue(false))
	illusion:SetBaseAttackTime(self:GetBaseAttackTime())
	illusion:SetBaseMoveSpeed(self:GetIdealSpeed())

	illusion:SetOriginalModel(self:GetModelName())
	illusion:SetModel(self:GetModelName())
	illusion:SetModelScale(self:GetModelScale())

--	local moveCap = DOTA_UNIT_CAP_MOVE_NONE
--	if self:HasMovementCapability() then
--		moveCap = DOTA_UNIT_CAP_MOVE_GROUND
--		if self:HasFlyMovementCapability() then
--			moveCap = DOTA_UNIT_CAP_MOVE_FLY
--		end
--	end
--	illusion:SetMoveCapability( moveCap )
--	illusion:SetAttackCapability(self:GetOriginalAttackCapability())
	illusion:SetUnitName(self:GetUnitName())
	if self:IsRangedAttacker() then
		illusion:SetRangedProjectileName(self:GetRangedProjectileName())
	end

	-- billion thanks for that to yahnich
	for _, wearable in ipairs(self:GetChildren()) do
		if wearable:GetClassname() == "dota_item_wearable" and wearable:GetModelName() ~= "" then
			local newWearable = CreateUnitByName("wearable_dummy", illusion:GetAbsOrigin(), false, nil, nil, self:GetTeam())
			newWearable:SetOriginalModel(wearable:GetModelName())
			newWearable:SetModel(wearable:GetModelName())
			newWearable:AddNewModifier(nil, nil, "modifier_wearable", {})
			newWearable:AddNewModifier(self, ability, "modifier_kill", { duration = duration })
			newWearable:AddNewModifier(self, ability, "modifier_illusion", { duration = duration })
			if specIllusionModifier then
				newWearable:AddNewModifier(self, ability, specIllusionModifier, { duration = duration })
			end
			newWearable:MakeIllusion()
			newWearable:SetParent(illusion, nil)
			newWearable:FollowEntity(illusion, true)
			-- newWearable:SetRenderColor(100,100,255)
			Timers:CreateTimer(1, function()
				if illusion and not illusion:IsNull() and illusion:IsAlive() then
					return 0.25
				else
					UTIL_Remove( newWearable )
				end
			end)
		end
	end

	illusion:SetForwardVector(self:GetForwardVector())
	illusion:AddNewModifier(self, ability, "modifier_kill", {duration = duration}) -- I'm not sure this is needed, but just in case
	illusion:AddNewModifier(self, nil, "modifier_illusion", {duration = duration, outgoing_damage = out, incoming_damage = inc})
	illusion:SetControllableByPlayer(self:GetPlayerID(), true)

	illusion:SetPlayerID(self:GetPlayerID())
	illusion:SetOwner(self:GetPlayerOwner())

	local targetLevel = self:GetLevel()
	for i=1,targetLevel-1 do
		illusion:HeroLevelUp(false)
	end

	illusion:SetAbilityPoints(0)

	for abilitySlot=0,15 do
		local ability = self:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	for itemSlot=0,8 do
		local item = self:GetItemInSlot(itemSlot)
		if item ~= nil then
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, illusion, illusion)
			illusion:AddItem(newItem)
			newItem:SetPurchaser(nil)
			newItem:SetStacksWithOtherOwners(true)
		end
	end

	if mod then
		for _, modifier in pairs(mod) do
			illusion:AddNewModifier(self, ab, modifier, {})
		end
	end

--[[
	if IsMutationMap() then
		if self:HasModifier("modifier_mutation_kill_streak_power") then
			illusion:AddNewModifier(illusion, nil, "modifier_mutation_kill_streak_power", {}):SetStackCount(self:FindModifierByName("modifier_mutation_kill_streak_power"):GetStackCount())
		end
	end
--]]
	illusion:MakeIllusion()

	return illusion
end

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

function CDOTA_BaseNPC:GetHeroType()
	if self:GetKeyValue("GibType") then
		return self:GetKeyValue("GibType")
	else
		return "default"
	end
end

function CDOTA_BaseNPC:EmitCasterSound(sCasterName, tSoundNames, fChancePct, flags, fCooldown, sCooldownindex)
	flags = flags or 0
	if self:GetName() ~= sCasterName then
		return true
	end
	
	if fCooldown then
		if self[sCooldownindex] then
			return true
		else
			self[sCooldownindex] = true
			Timers:CreateTimer(fCooldown, function()
				self[sCooldownindex] = nil
			end)
		end
	end

	if fChancePct then
		if fChancePct <= math.random(1,100) then
			return false -- Only return false if chance was missed
		end
	end
	if (bit.band(flags, DOTA_CAST_SOUND_FLAG_WHILE_DEAD) > 0) or self:IsAlive() then
		local sound = tSoundNames[math.random(1,#tSoundNames)]
		if bit.band(flags, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS) > 0 then
			self:EmitSound(sound)
		--elseif bit.band(flags, DOTA_CAST_SOUND_FLAG_GLOBAL) > 0 then
			-- Iterate through players, added later
		else
			StartSoundEventReliable(sound, self)
		end
	end
	return true
end

function CDOTA_BaseNPC:GetRealDamageDone(hTarget)
	local base_damage = self:GetAverageTrueAttackDamage(hTarget)
	local armor_reduction = GetReductionFromArmor(hTarget:GetPhysicalArmorValue(false))
	return base_damage - (base_damage * armor_reduction)
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

function CDOTA_BaseNPC:IsImbaInvisible()
	if self:IsInvisible() then
		return true
	end

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

	for k,v in pairs(self:GetAbilityKeyValues()) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				else
					-- print("GetTalentSpecialValueFor: Special ability value not found:", value)
					local vanilla_ability_name = string.gsub(self:GetAbilityName(), "imba_", "")
					-- print("Switch to vanilla ability:", vanilla_ability_name)

					for k,v in pairs(GetAbilitySpecials(vanilla_ability_name)) do
						if k == "AbilitySpecial" then
							for l,m in pairs(v) do
								if m[value] then
									talentName = m["LinkedSpecialBonus"]
								end
							end

							break
						end
					end
				end
			end

			break
		elseif k == "AbilityValues" then -- new vanilla format
			for l,m in pairs(v) do
				print(l, m)
				if type(m) == "table" then
					if m[value] then
						talentName = m["LinkedSpecialBonus"]
					end
				else
					print("GetTalentSpecialValueFor: No talent for this vanilla ability value:", value)
				end
			end

			break
		end
	end

	if talentName then 
		local talent = self:GetCaster():FindAbilityByName(talentName)
		if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
	end

	return base
end

function CDOTA_BaseNPC:GetFittingColor()
	-- Specially colored item modifiers have priority, in this order
	if self:FindModifierByName("modifier_item_imba_rapier_cursed") then
		return Vector(1,1,1)
	elseif self:FindModifierByName("modifier_item_imba_skadi") then
		return Vector(50,255,255)
	-- Heroes' color is based on attributes
	elseif self:IsHero() then
		
		local hero_color = self:GetHeroColorPrimary()
		if hero_color then
			return hero_color
		end
		
		local r = self:GetStrength()
		local g = self:GetAgility()
		local b = self:GetIntellect()
		local highest = math.max(r, math.max(g,b))
		r = math.max(255 - (highest - r) * 20, 0)
		g = math.max(255 - (highest - g) * 20, 0)
		b = math.max(255 - (highest - b) * 20, 0)
		return Vector(r,g,b)
	
	-- Other units use the default golden glow
	else
		return Vector(253, 144, 63)
	end
end

-- TODO: Merge primary and secondary color in a dimensional table to reduce those to 1 function
function CDOTA_BaseNPC_Hero:GetHeroColorPrimary()
	local heroname = self:GetName()
	local hero_theme =
	{
		["npc_dota_hero_abaddon"] = Vector(164,234,240),
		["npc_dota_hero_abyssal_underlord"] = Vector(170,255,0),
		["npc_dota_hero_alchemist"] = Vector(192,127,35),
		["npc_dota_hero_ancient_apparition"] = Vector(160,249,255),
		["npc_dota_hero_antimage"] = Vector(129,162,255),
		["npc_dota_hero_arc_warden"] = Vector(96,171,198),
		["npc_dota_hero_axe"] = Vector(171,0,0),
		["npc_dota_hero_bane"] = Vector(134,38,151),
		["npc_dota_hero_batrider"] = Vector(253,102,36),
		["npc_dota_hero_beastmaster"] = Vector(255,244,194),
		["npc_dota_hero_bloodseeker"] = Vector(167,10,10),
		["npc_dota_hero_bounty_hunter"] = Vector(255,164,66),
		["npc_dota_hero_brewmaster"] = Vector(181,166,139),
		["npc_dota_hero_bristleback"] = Vector(255,234,206),
		["npc_dota_hero_broodmother"] = Vector(60,255,0),
		["npc_dota_hero_centaur"] = Vector(255,221,180),
		["npc_dota_hero_chaos_knight"] = Vector(255,0,0),
		["npc_dota_hero_chen"] = Vector(190,223,242),
		["npc_dota_hero_clinkz"] = Vector(191,147,17),
		["npc_dota_hero_crystal_maiden"] = Vector(155,214,245),
		["npc_dota_hero_dark_seer"] = Vector(136,145,231),
		["npc_dota_hero_dazzle"] = Vector(235,156,255),
		["npc_dota_hero_death_prophet"] = Vector(173,247,208),
		["npc_dota_hero_disruptor"] = Vector(208,241,255),
		["npc_dota_hero_doom_bringer"] = Vector(239,239,203),
		["npc_dota_hero_dragon_knight"] = Vector(255,90,0),
		["npc_dota_hero_drow_ranger"] = Vector(144,175,195),
		["npc_dota_hero_earth_spirit"] = Vector(204,255,0),
		["npc_dota_hero_earthshaker"] = Vector(255,120,0),
		["npc_dota_hero_elder_titan"] = Vector(148,251,255),
		["npc_dota_hero_ember_spirit"] = Vector(155,113,0),
		["npc_dota_hero_enchantress"] = Vector(255,166,50),
		["npc_dota_hero_enigma"] = Vector(52,73,144),
		["npc_dota_hero_faceless_void"] = Vector(170,85,255),
		["npc_dota_hero_furion"] = Vector(12,255,0),
		["npc_dota_hero_gyrocopter"] = Vector(255,108,0),
		["npc_dota_hero_huskar"] = Vector(254,216,176),
		["npc_dota_hero_invoker"] = Vector(22,53,79),
		["npc_dota_hero_jakiro"] = Vector(160,182,200),
		["npc_dota_hero_juggernaut"] = Vector(255,233,0),
		["npc_dota_hero_keeper_of_the_light"] = Vector(253,255,231),
		["npc_dota_hero_kunkka"] = Vector(64,87,98),
		["npc_dota_hero_legion_commander"] = Vector(255,248,220),
		["npc_dota_hero_leshrac"] = Vector(158,39,219),
		["npc_dota_hero_lich"] = Vector(82,204,226),
		["npc_dota_hero_life_stealer"] = Vector(255,102,0),
		["npc_dota_hero_lina"] = Vector(255,0,0),
		["npc_dota_hero_lion"] = Vector(255,126,0),
		["npc_dota_hero_lone_druid"] = Vector(255,249,161),
		["npc_dota_hero_luna"] = Vector(103,179,238),
		["npc_dota_hero_lycan"] = Vector(212,66,21),
		["npc_dota_hero_magnataur"] = Vector(97,255,246),
		["npc_dota_hero_medusa"] = Vector(174,237,64),
		["npc_dota_hero_meepo"] = Vector(122,70,23),
		["npc_dota_hero_mirana"] = Vector(127,223,254),
		["npc_dota_hero_monkey_king"] = Vector(255,224,100),
		["npc_dota_hero_morphling"] = Vector(88,201,194),
		["npc_dota_hero_naga_siren"] = Vector(0,173,167),
		["npc_dota_hero_necrolyte"] = Vector(225,233,98),
		["npc_dota_hero_nevermore"] = Vector(64,0,0),
		["npc_dota_hero_night_stalker"] = Vector(21,13,50),
		["npc_dota_hero_nyx_assassin"] = Vector(66,41,255),
		["npc_dota_hero_obsidian_destroyer"] = Vector(132,239,223),
		["npc_dota_hero_ogre_magi"] = Vector(255,215,27),
		["npc_dota_hero_omniknight"] = Vector(255,210,179),
		["npc_dota_hero_oracle"] = Vector(231,207,109),
		["npc_dota_hero_phantom_assassin"] = Vector(169,255,250),
		["npc_dota_hero_phantom_lancer"] = Vector(255,234,172),
		["npc_dota_hero_phoenix"] = Vector(255,173,30),
		["npc_dota_hero_puck"] = Vector(236,52,156),
		["npc_dota_hero_pudge"] = Vector(69,58,24),
		["npc_dota_hero_pugna"] = Vector(149,240,109),
		["npc_dota_hero_queenofpain"] = Vector(195,0,0),
		["npc_dota_hero_rattletrap"] = Vector(202,128,0),
		["npc_dota_hero_razor"] = Vector(0,89,255),
		["npc_dota_hero_riki"] = Vector(97,92,255),
		["npc_dota_hero_rubick"] = Vector(32,140,0),
		["npc_dota_hero_sand_king"] = Vector(252,228,94),
		["npc_dota_hero_shadow_demon"] = Vector(250,7,41),
		["npc_dota_hero_shadow_shaman"] = Vector(255,54,0),
		["npc_dota_hero_shredder"] = Vector(255,209,109),
		["npc_dota_hero_silencer"] = Vector(41,167,255),
		["npc_dota_hero_skeleton_king"] = Vector(0,239,135),
		["npc_dota_hero_skywrath_mage"] = Vector(131,248,249),
		["npc_dota_hero_slardar"] = Vector(75,160,247),
		["npc_dota_hero_slark"] = Vector(138,127,221),
		["npc_dota_hero_sniper"] = Vector(251,213,111),
		["npc_dota_hero_spectre"] = Vector(254,98,241),
		["npc_dota_hero_spirit_breaker"] = Vector(42,162,192),
		["npc_dota_hero_storm_spirit"] = Vector(60,125,255),
		["npc_dota_hero_sven"] = Vector(255,248,195),
		["npc_dota_hero_techies"] = Vector(255,210,0),
		["npc_dota_hero_templar_assassin"] = Vector(254,94,162),
		["npc_dota_hero_terrorblade"] = Vector(113,138,184),
		["npc_dota_hero_tidehunter"] = Vector(166,204,220),
		["npc_dota_hero_tinker"] = Vector(66,205,240),
		["npc_dota_hero_tiny"] = Vector(231,175,101),
		["npc_dota_hero_treant"] = Vector(66,142,51),
		["npc_dota_hero_troll_warlord"] = Vector(140,211,252),
		["npc_dota_hero_tusk"] = Vector(43,86,248),
		["npc_dota_hero_undying"] = Vector(151,148,78),
		["npc_dota_hero_ursa"] = Vector(255,195,52),
		["npc_dota_hero_vengefulspirit"] = Vector(146,157,255),
		["npc_dota_hero_venomancer"] = Vector(153,185,108),
		["npc_dota_hero_viper"] = Vector(98,242,111),
		["npc_dota_hero_visage"] = Vector(69,190,180),
		["npc_dota_hero_warlock"] = Vector(255,164,91),
		["npc_dota_hero_weaver"] = Vector(95,123,56),
		["npc_dota_hero_windrunner"] = Vector(156,232,110),
		["npc_dota_hero_winter_wyvern"] = Vector(105,165,255),
		["npc_dota_hero_wisp"] = Vector(207,239,255),
		["npc_dota_hero_witch_doctor"] = Vector(142,143,186),
		["npc_dota_hero_zuus"] = Vector(113,255,250),
	}
	if hero_theme[heroname] then
		return hero_theme[heroname]
	end
	return false
end

function CDOTA_BaseNPC_Hero:GetHeroColorSecondary()
	local heroname = self:GetName()
	local hero_theme =
	{
		["npc_dota_hero_abaddon"] = Vector(55,220,190),
		["npc_dota_hero_abyssal_underlord"] = Vector(255,255,127),
		["npc_dota_hero_alchemist"] = Vector(30,112,57),
		["npc_dota_hero_ancient_apparition"] = Vector(46,118,238),
		["npc_dota_hero_antimage"] = Vector(0,18,255),
		["npc_dota_hero_arc_warden"] = Vector(43,130,210),
		["npc_dota_hero_axe"] = Vector(255,58,58),
		["npc_dota_hero_bane"] = Vector(51,19,54),
		["npc_dota_hero_batrider"] = Vector(255,192,104),
		["npc_dota_hero_beastmaster"] = Vector(89,63,13),
		["npc_dota_hero_bloodseeker"] = Vector(255,0,0),
		["npc_dota_hero_bounty_hunter"] = Vector(255,255,255),
		["npc_dota_hero_brewmaster"] = Vector(155,112,36),
		["npc_dota_hero_bristleback"] = Vector(255,200,83),
		["npc_dota_hero_broodmother"] = Vector(198,255,0),
		["npc_dota_hero_centaur"] = Vector(247,58,0),
		["npc_dota_hero_chaos_knight"] = Vector(247,156,49),
		["npc_dota_hero_chen"] = Vector(199,223,252),
		["npc_dota_hero_clinkz"] = Vector(192,39,12),
		["npc_dota_hero_crystal_maiden"] = Vector(117,175,241),
		["npc_dota_hero_dark_seer"] = Vector(71,75,248),
		["npc_dota_hero_dazzle"] = Vector(75,37,94),
		["npc_dota_hero_death_prophet"] = Vector(51,0,77),
		["npc_dota_hero_disruptor"] = Vector(105,176,255),
		["npc_dota_hero_doom_bringer"] = Vector(243,48,0),
		["npc_dota_hero_dragon_knight"] = Vector(255,216,0),
		["npc_dota_hero_drow_ranger"] = Vector(165,216,235),
		["npc_dota_hero_earth_spirit"] = Vector(254,241,127),
		["npc_dota_hero_earthshaker"] = Vector(255,60,0),
		["npc_dota_hero_elder_titan"] = Vector(76,255,244),
		["npc_dota_hero_ember_spirit"] = Vector(221,0,0),
		["npc_dota_hero_enchantress"] = Vector(255,214,181),
		["npc_dota_hero_enigma"] = Vector(77,57,136),
		["npc_dota_hero_faceless_void"] = Vector(35,63,120),
		["npc_dota_hero_furion"] = Vector(255,162,0),
		["npc_dota_hero_gyrocopter"] = Vector(255,50,3),
		["npc_dota_hero_huskar"] = Vector(255,140,16),
		["npc_dota_hero_invoker"] = Vector(189,93,30),
		["npc_dota_hero_jakiro"] = Vector(202,250,254),
		["npc_dota_hero_juggernaut"] = Vector(255,25,0),
		["npc_dota_hero_keeper_of_the_light"] = Vector(255,255,255),
		["npc_dota_hero_kunkka"] = Vector(24,48,62),
		["npc_dota_hero_legion_commander"] = Vector(171,80,0),
		["npc_dota_hero_leshrac"] = Vector(119,109,251),
		["npc_dota_hero_lich"] = Vector(150,236,255),
		["npc_dota_hero_life_stealer"] = Vector(67,0,0),
		["npc_dota_hero_lina"] = Vector(251,94,0),
		["npc_dota_hero_lion"] = Vector(249,227,42),
		["npc_dota_hero_lone_druid"] = Vector(223,255,112),
		["npc_dota_hero_luna"] = Vector(156,212,244),
		["npc_dota_hero_lycan"] = Vector(212,154,20),
		["npc_dota_hero_magnataur"] = Vector(0,104,177),
		["npc_dota_hero_medusa"] = Vector(87,205,80),
		["npc_dota_hero_meepo"] = Vector(112,94,100),
		["npc_dota_hero_mirana"] = Vector(127,223,254),
		["npc_dota_hero_monkey_king"] = Vector(255,171,97),
		["npc_dota_hero_morphling"] = Vector(156,181,176),
		["npc_dota_hero_naga_siren"] = Vector(0,71,131),
		["npc_dota_hero_necrolyte"] = Vector(196,190,28),
		["npc_dota_hero_nevermore"] = Vector(11,0,0),
		["npc_dota_hero_night_stalker"] = Vector(0,0,0),
		["npc_dota_hero_nyx_assassin"] = Vector(44,188,255),
		["npc_dota_hero_obsidian_destroyer"] = Vector(141,255,203),
		["npc_dota_hero_ogre_magi"] = Vector(255,72,0),
		["npc_dota_hero_omniknight"] = Vector(228,164,100),
		["npc_dota_hero_oracle"] = Vector(233,183,125),
		["npc_dota_hero_phantom_assassin"] = Vector(39,120,146),
		["npc_dota_hero_phantom_lancer"] = Vector(191,100,19),
		["npc_dota_hero_phoenix"] = Vector(201,76,0),
		["npc_dota_hero_puck"] = Vector(53,140,189),
		["npc_dota_hero_pudge"] = Vector(32,59,14),
		["npc_dota_hero_pugna"] = Vector(198,255,74),
		["npc_dota_hero_queenofpain"] = Vector(255,240,240),
		["npc_dota_hero_rattletrap"] = Vector(202,81,0),
		["npc_dota_hero_razor"] = Vector(250,250,255),
		["npc_dota_hero_riki"] = Vector(158,115,230),
		["npc_dota_hero_rubick"] = Vector(93,140,40),
		["npc_dota_hero_sand_king"] = Vector(255,173,85),
		["npc_dota_hero_shadow_demon"] = Vector(241,12,184),
		["npc_dota_hero_shadow_shaman"] = Vector(255,210,0),
		["npc_dota_hero_shredder"] = Vector(253,100,17),
		["npc_dota_hero_silencer"] = Vector(88,206,255),
		["npc_dota_hero_skeleton_king"] = Vector(0,239,67),
		["npc_dota_hero_skywrath_mage"] = Vector(245,204,81),
		["npc_dota_hero_slardar"] = Vector(101,206,255),
		["npc_dota_hero_slark"] = Vector(154,150,243),
		["npc_dota_hero_sniper"] = Vector(46,46,46),
		["npc_dota_hero_spectre"] = Vector(90,34,85),
		["npc_dota_hero_spirit_breaker"] = Vector(23,231,213),
		["npc_dota_hero_storm_spirit"] = Vector(98,247,255),
		["npc_dota_hero_sven"] = Vector(252,241,152),
		["npc_dota_hero_techies"] = Vector(255,229,218),
		["npc_dota_hero_templar_assassin"] = Vector(255,144,238),
		["npc_dota_hero_terrorblade"] = Vector(137,188,224),
		["npc_dota_hero_tidehunter"] = Vector(92,180,173),
		["npc_dota_hero_tinker"] = Vector(134,229,253),
		["npc_dota_hero_tiny"] = Vector(25,12,12),
		["npc_dota_hero_treant"] = Vector(79,123,98),
		["npc_dota_hero_troll_warlord"] = Vector(107,255,246),
		["npc_dota_hero_tusk"] = Vector(93,173,255),
		["npc_dota_hero_undying"] = Vector(133,207,109),
		["npc_dota_hero_ursa"] = Vector(204,0,0),
		["npc_dota_hero_vengefulspirit"] = Vector(52,143,255),
		["npc_dota_hero_venomancer"] = Vector(157,247,28),
		["npc_dota_hero_viper"] = Vector(33,85,38),
		["npc_dota_hero_visage"] = Vector(143,230,180),
		["npc_dota_hero_warlock"] = Vector(255,84,0),
		["npc_dota_hero_weaver"] = Vector(150,100,78),
		["npc_dota_hero_windrunner"] = Vector(232,209,110),
		["npc_dota_hero_winter_wyvern"] = Vector(209,238,255),
		["npc_dota_hero_wisp"] = Vector(72,79,255),
		["npc_dota_hero_witch_doctor"] = Vector(127,97,161),
		["npc_dota_hero_zuus"] = Vector(113,150,255),
	}
	if hero_theme[heroname] then
		return hero_theme[heroname]
	end
	return false
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
	return modifier
end

function CDOTA_BaseNPC:FindAbilityWithHighestCooldown()
	local highest_cd_ability = nil

	for i = 0, 24 do
		local ability = self:GetAbilityByIndex(i)

		if ability then
			if highest_cd_ability == nil then
				highest_cd_ability = ability
			elseif ability:IsTrained() then
				if ability:GetCooldownTimeRemaining() > highest_cd_ability:GetCooldownTimeRemaining() then
					highest_cd_ability = ability
				end
			end
		end
	end

	return highest_cd_ability
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

-- Call custom functions whenever CreateLinearProjectile is being called anywhere
local original_CreateLinearProjectile = ProjectileManager.CreateLinearProjectile
ProjectileManager.CreateLinearProjectile = function(self, hHandle)
--	print("CreateLinearProjectile (override):", hHandle)
	if not hHandle.EffectName then return original_CreateLinearProjectile(self, hHandle) end

	local override = CustomNetTables:GetTableValue("battlepass_player", hHandle.EffectName..'_'..hHandle.Ability:GetCaster():GetPlayerOwnerID()) 

	if override then
		hHandle.EffectName = override["1"]
	end

	return original_CreateLinearProjectile(self, hHandle)
end

-- Call custom functions whenever CreateTrackingProjectile is being called anywhere
local original_CreateTrackingProjectile = ProjectileManager.CreateTrackingProjectile
ProjectileManager.CreateTrackingProjectile = function(self, hHandle)
--	print("CreateTrackingProjectile (override):", hHandle)
--	print(hHandle.EffectName)
	if not hHandle.EffectName then return original_CreateTrackingProjectile(self, hHandle) end

	local override = CustomNetTables:GetTableValue("battlepass_player", hHandle.EffectName..'_'..hHandle.Ability:GetCaster():GetPlayerOwnerID()) 

	if override then
--		print(override["1"])
		hHandle.EffectName = override["1"]
	end

	return original_CreateTrackingProjectile(self, hHandle)
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

if not CScriptParticleManager.ACTIVE_PARTICLES then CScriptParticleManager.ACTIVE_PARTICLES = {} end

-- Call custom functions whenever CreateParticle is being called anywhere
local original_CreateParticle = CScriptParticleManager.CreateParticle
CScriptParticleManager.CreateParticle = function(self, sParticleName, iAttachType, hParent, hCaster)
	local override = nil

	if hCaster then
		override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
	end

	if override then
		sParticleName = override["1"]
	end

--	print("CreateParticle response:", sParticleName)

	-- call the original function
	local response = original_CreateParticle(self, sParticleName, iAttachType, hParent)

	if not ignored_pfx_list[sParticleName] then
		if hCaster and not hCaster:IsHero() then
			table.insert(CScriptParticleManager.ACTIVE_PARTICLES, {response, 0})
		else
			table.insert(CScriptParticleManager.ACTIVE_PARTICLES, {response, 0})
		end
	end

	return response
end

-- Call custom functions whenever CreateParticleForTeam is being called anywhere
local original_CreateParticleForTeam = CScriptParticleManager.CreateParticleForTeam
CScriptParticleManager.CreateParticleForTeam = function(self, sParticleName, iAttachType, hParent, iTeamNumber, hCaster)
--	print("Create Particle (override):", sParticleName, iAttachType, hParent, iTeamNumber, hCaster)

	local override = nil

	if hCaster then
		override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
	end

	if override then
		sParticleName = override["1"]
	end

	-- call the original function
	local response = original_CreateParticleForTeam(self, sParticleName, iAttachType, hParent, iTeamNumber)

	return response
end

-- Call custom functions whenever CreateParticleForPlayer is being called anywhere
local original_CreateParticleForPlayer = CScriptParticleManager.CreateParticleForPlayer
CScriptParticleManager.CreateParticleForPlayer = function(self, sParticleName, iAttachType, hParent, hPlayer, hCaster)
--	print("Create Particle (override):", sParticleName, iAttachType, hParent, hPlayer, hCaster)

	local override = nil

	if hCaster then
		override = CustomNetTables:GetTableValue("battlepass_player", sParticleName..'_'..hCaster:GetPlayerOwnerID()) 
	end

	if override then
		sParticleName = override["1"]
	end

	-- call the original function
	local response = original_CreateParticleForPlayer(self, sParticleName, iAttachType, hParent, hPlayer)

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

	local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID()) 

	if override_sound then
--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	else
		if hCaster then
			local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID()) 

			if override_sound then
--				print("EmitSoundOn (override):", sSoundName, override_sound["1"])
				sSoundName = override_sound["1"]
			end
		end
	end

	-- call the original function
	local response = original_EmitSound(self, sSoundName)

	return response
end

-- Call custom functions whenever StopSound is being called anywhere
local original_StopSound = CDOTA_BaseNPC.StopSound
CDOTA_BaseNPC.StopSound = function(self, sSoundName, hCaster)
--	print("Create Particle (override):", sSoundName)

	local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..self:GetPlayerOwnerID()) 

	if override_sound then
--		print("StopSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	else
		if hCaster then
			local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID()) 

			if override_sound then
--				print("StopSoundOn (override):", sSoundName, override_sound["1"])
				sSoundName = override_sound["1"]
			end
		end
	end

	-- call the original function
	local response = original_StopSound(self, sSoundName)

	return response
end

local original_EmitSoundOn = EmitSoundOn
EmitSoundOn = function(sSoundName, hParent, hCaster)
--	print("Create Particle (override):", sSoundName)

	local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID()) 

	if override_sound then
--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	else
		if hCaster then
			local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID()) 

			if override_sound then
--				print("EmitSoundOn (override):", sSoundName, override_sound["1"])
				sSoundName = override_sound["1"]
			end
		end
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
	local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hParent:GetPlayerOwnerID()) 

	if override_sound then
--		print("EmitSoundOn (override):", sSoundName, override_sound["1"])
		sSoundName = override_sound["1"]
	else
		if hCaster then
			local override_sound = CustomNetTables:GetTableValue("battlepass_player", sSoundName..'_'..hCaster:GetPlayerOwnerID()) 

			if override_sound then
--				print("EmitSoundOn (override):", sSoundName, override_sound["1"])
				sSoundName = override_sound["1"]
			end
		end
	end

	-- call the original function
	local response = original_EmitSoundOnLocationWithCaster(vLocation, sSoundName, hCaster)

	return response
end

--[[ -- not working WTF?
-- Call custom functions whenever IsReincarnating is being called anywhere
local original_IsReincarnating = CDOTA_BaseNPC.IsReincarnating
CDOTA_BaseNPC.IsReincarnating = function(self)

	-- call the original function
	local response = original_IsReincarnating(self)
	print("Is Reincarnating?:", response)

	-- stop right there if vanilla IsReincarnating is true
	if response == true then
		return true
	end

	-- otherwise, check for imba reincarnation modifiers
	for _, modifier in pairs(IMBA_REINCARNATION_MODIFIERS) do
		if self:HasModifier(modifier) then
			return true
		end
	end

	return response
end
--]]

--[[ Should be ready to work, not required yet
local original_Ability_GetProjectileName = CDOTA_Ability_Lua.GetProjectileName
CDOTA_Ability_Lua.GetProjectileName = function(self)
	-- call the original function
	local response = original_Ability_GetProjectileName(self)
	local override = CustomNetTables:GetTableValue("battlepass_player", response..'_'..self:GetCaster():GetPlayerOwnerID()) 

	print("GetProjectileName (vanilla):", response)

	if override then
		print("GetProjectileName (override):", override)
		return override
	end

	return response
end
--]]

--[[ for SOME reasons, those functions are not triggered when CDOTABaseAbility.OnProjectileHit is called on any ability
local original_OnProjectileHit = CDOTABaseAbility.OnProjectileHit
CDOTABaseAbility.OnProjectileHit = function(self, hTarget, vLocation)
	print("Ability/Item:", self:GetAbilityName())
	if self == nil then return end

	print("target has lotus orb?", hTarget:HasModifier("modifier_item_imba_lotus_orb_active"))
	if hTarget:HasModifier("modifier_item_imba_lotus_orb_active") then
		return false
	else
		return original_OnProjectileHit(self, hTarget, vLocation)
	end
end

local original_OnProjectileHit_ExtraData = CDOTABaseAbility.OnProjectileHit_ExtraData
CDOTABaseAbility.OnProjectileHit_ExtraData = function(self, hTarget, vLocation)
	print("Ability/Item:", self:GetAbilityName())
	if self == nil then return end

	print("target has lotus orb?", hTarget:HasModifier("modifier_item_imba_lotus_orb_active"))
	if hTarget:HasModifier("modifier_item_imba_lotus_orb_active") then
		return false
	else
		return original_OnProjectileHit_ExtraData(self, hTarget, vLocation)
	end
end
--]]

----------------------------------------------------------------------------------
-- credits to yahnich for every functions below
----------------------------------------------------------------------------------

function CDOTA_BaseNPC:IsMonkeyKingClone()
	local monkey_king_soldier_modifiers = {
		"modifier_monkey_king_fur_army_soldier_hidden",
		"modifier_monkey_king_fur_army_soldier",
		"modifier_monkey_king_fur_army_thinker",
		"modifier_monkey_king_fur_army_soldier_inactive",
		"modifier_monkey_king_fur_army_soldier_in_position",
	}

	for _, v in pairs(monkey_king_soldier_modifiers) do
	  if self:HasModifier(v) then
		return true
	  end
	end

	return false
end

function CDOTA_BaseNPC:IsFakeHero()
	return self:IsIllusion() or self:IsMonkeyKingClone() or self:IsTempestDouble() or self:IsClone()
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
	return (self:GetBaseDamageMax() + self:GetBaseDamageMin())/2
end

function CDOTA_BaseNPC:SetAverageBaseDamage(average, variance) -- variance is in percent (50 not 0.5)
	local var = variance or ((self:GetBaseDamageMax() / self:GetBaseDamageMin()) * 100 )
	self:SetBaseDamageMax(math.ceil(average*(1+(var/100))))
	self:SetBaseDamageMin(math.floor(average*(1-(var/100))))
end

-- Check if the unit is under forced movement (this is mostly just for Sniper's Headshot but may potentially be used for general checks)
-- This function will naturally be faulty due to requiring manual add of every modifier that has forced movement but as many cases as possible will be covered
function CDOTA_BaseNPC:Custom_IsUnderForcedMovement()
	-- Using https://dota2.gamepedia.com/Forced_movement as reference
	local forced_movement_modifiers = {
		["modifier_knockback"]									= true,
		["modifier_generic_motion_controller"]					= true,
		
		["modifier_pudge_dismember"]							= true,
		["modifier_imba_dismember"]								= true,
		["modifier_faceless_void_chronosphere_freeze"]			= true,
		["modifier_imba_faceless_void_chronosphere_handler"]	= true,
		
		-- Fully disabling forced movement
		["modifier_batrider_flaming_lasso"]						= true,
		["modifier_imba_batrider_flaming_lasso"]				= true,
		["modifier_beastmaster_prima_roar_push"]				= true,
		["modifier_brewmaster_primal_split"]					= true,
		["modifier_rattletrap_cog_push"]						= true,
		["modifier_imba_rattletrap_cog_push"]					= true,
		["modifier_dark_seer_vacuum"]							= true,
		["modifier_imba_dark_seer_vacuum"]						= true,
		["modifier_earthshaker_enchant_totem_leap"]				= true,
		["modifier_earthshaker_enchant_totem_lua_leap"]			= true,
		["modifier_imba_earthshaker_enchant_totem_leap"]		= true,
		["modifier_enigma_black_hole_pull"]						= true,
		["modifier_imba_enigma_black_hole"]						= true,
		["modifier_eul_cyclone"]								= true,
		["modifier_faceless_void_time_walk"]					= true,
		["modifier_imba_faceless_void_time_walk_cast"]			= true,
		["modifier_invoker_tornado"]							= true,
		["modifier_imba_invoker_tornado"]						= true,
		["modifier_kunkka_torrent"]								= true,
		["modifier_life_stealer_infest_effect"]					= true,
		["modifier_imba_life_stealer_infest_effect"]			= true,
		["modifier_life_stealer_assimilate_effect"]				= true,
		["modifier_imba_life_stealer_infest_effect"]			= true,
		["modifier_lion_impale"]								= true,
		["modifier_imba_earthspike_death_spike"]				= true,
		["modifier_magnataur_skewer_movement"]					= true,
		["modifier_imba_skewer_motion_controller"]				= true,
		["modifier_mars_spear"]									= true,
		["modifier_monkey_king_tree_dance_activity"]			= true,
		["modifier_monkey_king_bounce_leap"]					= true,
		["modifier_morphling_adaptive_strike"]					= true,
		["modifier_nyx_assassin_impale"]						= true,
		["modifier_imba_swashbuckle_dash"]						= true,
		["modifier_imba_shield_crash_jump"]						= true,
		["modifier_pangolier_gyroshell"]						= true,
		["modifier_pudge_meat_hook"]							= true,
		["modifier_imba_hook_target_enemy"]						= true,
		["modifier_imba_hook_target_ally"]						= true,
		["modifier_rubick_telekinesis"]							= true,
		["modifier_imba_telekinesis"]							= true,
		["modifier_sandking_impale"]							= true,
		["modifier_sandking_burrowstrike"]						= true,
		["modifier_imba_burrowstrike_burrow"]					= true,
		["modifier_brewmaster_storm_cyclone"]					= true,
		["modifier_storm_spirit_electric_vortex_pull"]			= true,
		["modifier_imba_vortex_pull"]							= true,
		["modifier_techies_suicide_leap"]						= true,
		["modifier_imba_techies_suicide_leap"]					= true,
		["modifier_tidehunter_ravage"]							= true,
		["modifier_tiny_toss"]									= true,
		["modifier_tiny_toss_movement"]							= true,
		["modifier_tusk_snowball_movement"]						= true,
		["modifier_tusk_snowball_movement_friendly"]			= true,
		["modifier_tusk_walrus_punch_air_time"]					= true,
		["modifier_tusk_walrus_kick_air_time"]					= true,
		
		-- Non-disabling forced movement
		["modifier_flamebreak_knockback"]						= true,
		["modifier_rattletrap_hookshot"]						= true,
		["modifier_imba_rattletrap_hookshot"]					= true,
		["modifier_drowranger_wave_of_silence_knockback"]		= true,
		["modifier_imba_gust_movement"]							= true,
		["modifier_earth_spirit_boulder_smash"]					= true,
		["modifier_imba_boulder_smash_push"]					= true,
		["modifier_earth_spirit_rolling_boulder_caster"]		= true,
		["modifier_imba_rolling_boulder"]						= true,
		["modifier_earth_spirit_geomagnetic_grip"]				= true,
		["modifier_imba_geomagnetic_grip_pull"]					= true,
		["modifier_ember_spirit_fire_remnant"]					= true,
		["modifier_item_forcestaff_active"]						= true,
		["modifier_item_imba_force_staff_active"]				= true,
		["modifier_item_hurricane_pike_active"]					= true,
		["modifier_item_hurricane_pike_active_alternate"]		= true,
		["modifier_item_imba_hurricane_pike_force_ally"]		= true,
		["modifier_item_imba_hurricane_pike_force_enemy"]		= true,
		["modifier_item_imba_lance_of_longinus_force_ally"]		= true,
		["modifier_item_imba_lance_of_longinus_force_enemy_ranged"]	= true,
		["modifier_item_imba_lance_of_longinus_force_enemy_melee"]	= true,
		["modifier_item_imba_lance_of_longinus_force_self_ranged"]	= true,
		["modifier_item_imba_lance_of_longinus_force_self_melee"]	= true,
		["modifier_huskar_life_break_charge"]					= true,
		["modifier_imba_huskar_life_break_charge"]				= true,
		["modifier_invoker_deafening_blast_knockback"]			= true,
		["modifier_imba_invoker_deafening_blast_knockback"]		= true,
		["modifier_wisp_tether"]								= true,
		["modifier_imba_wisp_tether_latch"]						= true,
		["modifier_blinding_light_knockback"]					= true,
		["modifier_imba_blinding_light_knockback"]				= true,
		["modifier_kunkka_ghost_ship_knockback"]				= true,
		["modifier_imba_ghostship_drag"]						= true,
		["modifier_mirana_leap"]								= true,
		["modifier_imba_leap_movement"]							= true,
		["modifier_morphling_waveform"]							= true,
		["modifier_phoenix_icarus_dive"]						= true,
		["modifier_imba_phoenix_icarus_dive_dash_dummy"]		= true,
		["modifier_phoenix_sun_ray"]							= true,
		["imba_phoenix_sun_ray_toggle_move"]					= true,
		["modifier_slark_pounce"]								= true,
		["modifier_imba_slark_pounce"]							= true,
		["modifier_spirit_breaker_charge_of_darkness"]			= true,
		["modifier_imba_spirit_breaker_charge_of_darkness"]		= true,
		["modifier_imba_spirit_breaker_charge_of_darkness_clothesline"]	= true,
		["modifier_imba_spirit_breaker_charge_of_darkness_taxi"]		= true,
		["modifier_storm_spirit_ball_lightning"]				= true,
		["modifier_imba_ball_lightning"]						= true,
		["modifier_shredder_timber_chain"]						= true,
		["modifier_imba_timbersaw_timber_chain"]				= true	
	}
	
	local bForcedMovement = false

	for _, modifier in pairs(self:FindAllModifiers()) do
		if forced_movement_modifiers[modifier:GetName()] then
			bForcedMovement = true
			break
		end
	end
	
	return bForcedMovement
end

function CDOTA_BaseNPC:HasShard()
	return self:HasModifier("modifier_item_aghanims_shard")
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

if not CDOTA_BaseNPC.GetAttackRange then
	function CDOTA_BaseNPC:GetAttackRange()
		return self:Script_GetAttackRange()
	end
end

if not CDOTA_BaseNPC.ReduceMana then
	function CDOTA_BaseNPC:ReduceMana(amount, mana_burning_ability)
		return self:Script_ReduceMana(amount, mana_burning_ability)
	end
end

if not CDOTA_BaseNPC.GetMagicalArmorValue then
	function CDOTA_BaseNPC:GetMagicalArmorValue()
		local experimental_formula = false
		local inflictor = nil
		return self:Script_GetMagicalArmorValue(experimental_formula, inflictor)
	end
end

-- Checks if the unit (hero or unit with inventory) has an empty space in inventory
function CDOTA_BaseNPC:Custom_HasAnyAvailableInventorySpace()
	-- If it's a hero, just use the known function
	if self:IsHero() then
		return self:HasAnyAvailableInventorySpace()
	else
		-- Otherwise, we need to check if there's at least one empty space (for creep heroes)
		for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local item = self:GetItemInSlot(i)

			-- If there is not item in a slot, then we have a free space
			if not item then
				return true
			end
		end

		-- If we got here, then we don't have a free space
		return false
	end
end

function CDOTA_BaseNPC:IMBA_GetHeroStartingGold()
	PlayerResource:SetGold(self:GetPlayerID(), 0, false)

	-- could use dynamic vanilla starting gold, but then some bugs raises like re-random feature giving double starting gold and xp if a backend banned hero is picked
	local hero_gold = HERO_INITIAL_GOLD
	local custom_gold_bonus = CUSTOM_GOLD_BONUS[GetMapName()] or 100

	if custom_gold_bonus > 100 then
		hero_gold = hero_gold * custom_gold_bonus / 100
	end


	return hero_gold
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