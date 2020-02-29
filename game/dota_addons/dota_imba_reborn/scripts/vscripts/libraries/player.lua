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
function CDOTA_BaseNPC:InitializeInnateAbilities()	
	-- Cycle through all of the heroes' abilities, and upgrade the innates ones
	for i = 0, 15 do		
		local current_ability = self:GetAbilityByIndex(i)		
		if current_ability and current_ability.IsInnateAbility then
			if current_ability:IsInnateAbility() then
				current_ability:SetLevel(1)
			end
		end
	end
end

-- Serversided function only
function CDOTA_BaseNPC:DropRapier(hItem, sNewItemName)
	local vLocation = self:GetAbsOrigin()
	local sName
	local hRapier
	local vRandomVector = RandomVector(100)
	if hItem then
		hRapier = hItem
		sName = hItem:GetName()
		self:DropItemAtPositionImmediate(hRapier, vLocation)
	else
		sName = sNewItemName
		hRapier = CreateItem(sNewItemName, nil, nil)
		CreateItemOnPositionSync(vLocation, hRapier)
	end
	if sName == "item_imba_rapier" then
		hRapier:GetContainer():SetRenderColor(230,240,35)
	elseif sName == "item_imba_rapier_2" then
		hRapier:GetContainer():SetRenderColor(240,150,30)
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_trinity.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_magic" then
		hRapier:GetContainer():SetRenderColor(35,35,240)
	elseif sName == "item_imba_rapier_magic_2" then
		hRapier:GetContainer():SetRenderColor(140,70,220)
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_archmage.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
	elseif sName == "item_imba_rapier_cursed" then
		hRapier.rapier_pfx = ParticleManager:CreateParticle("particles/item/rapier/item_rapier_cursed.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.rapier_pfx, 0, vLocation + vRandomVector)
		hRapier.x_pfx = ParticleManager:CreateParticle("particles/item/rapier/cursed_x.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(hRapier.x_pfx, 0, vLocation + vRandomVector)
	end
	hRapier:LaunchLoot(false, 250, 0.5, vLocation + vRandomVector)
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

function CDOTA_BaseNPC:SetUnitOnClearGround()
	Timers:CreateTimer(FrameTime(), function()
		self:SetAbsOrigin(Vector(self:GetAbsOrigin().x, self:GetAbsOrigin().y, GetGroundPosition(self:GetAbsOrigin(), self).z))		
		FindClearSpaceForUnit(self, self:GetAbsOrigin(), true)
		ResolveNPCPositions(self:GetAbsOrigin(), 64)
	end)
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
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierLifesteal()
		end
	end
	return lifesteal
end

-- Spell lifesteal
function CDOTA_BaseNPC:GetSpellLifesteal()
	local lifesteal = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierSpellLifesteal then
			lifesteal = lifesteal + parent_modifier:GetModifierSpellLifesteal()
		end
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

function CDOTA_BaseNPC:IsImbaReincarnating()
	if self:IsReincarnating() then
		return true
	end

	for _, modifier in pairs(IMBA_REINCARNATION_MODIFIERS) do
		if self:HasModifier(modifier) then
			return true
		end
	end

	return false
end

-- Talent handling
function CDOTA_BaseNPC:HasTalent(talentName)
	if self:HasAbility(talentName) then
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

-- Commenting out all of these custom functions for now because they're causing mass errors
-- -- Call custom functions whenever CreateParticle is being called anywhere
-- original_CreateParticle = CScriptParticleManager.CreateParticle
-- CScriptParticleManager.CreateParticle = function(self, sParticleName, iAttachType, hParent)
-- --	print("Create Particle (override):", sParticleName, iAttachType, hParent)

	-- -- call the original function
	-- local response = original_CreateParticle(self, sParticleName, iAttachType, hParent)

	-- return response
-- end

-- -- Call custom functions whenever CreateIllusions is being called anywhere
-- original_CreateIllusions = CreateIllusions
-- CreateIllusions = function(hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
-- --	print("Create Illusions (override):", hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

	-- -- call the original function
	-- local response = original_CreateIllusions(hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)

	-- for i = 1, #response do
		-- local illusion = response[i]

		-- if hModifierKeys.duration and type(hModifierKeys.duration) == "number" then
			-- print("Add fail-safe kill target in "..hModifierKeys.duration.." seconds.")
			-- illusion:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = hModifierKeys.duration})
		-- end
	-- end

	-- return response
-- end

-- -- Call custom functions whenever EmitSound is being called anywhere
-- original_EmitSound = CDOTA_BaseNPC.EmitSound
-- CDOTA_BaseNPC.EmitSound = function(self, sSoundName)
-- --	print("Create Particle (override):", sSoundName)

	-- -- call the original function
	-- local response = original_EmitSound(self, sSoundName)

	-- return response
-- end

----------------------------------------------------------------------------------
-- credits to yahnich for every functions below
----------------------------------------------------------------------------------

function CDOTA_BaseNPC:IsFakeHero()
	if self:IsIllusion() or (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_monkey_king_fur_army_soldier_hidden")) or self:IsTempestDouble() or self:IsClone() then
		return true
	else return false end
end

function CDOTA_BaseNPC:IsRealHero()
	if not self:IsNull() then
		return self:IsHero() and not ( self:IsIllusion() or self:IsClone() ) and not self:IsFakeHero()
	end
end

function CDOTA_BaseNPC:Blink(position, bTeamOnlyParticle, bPlaySound)
	if self:IsNull() then return end
	
	-- Keep the static strings in or else you're going to get potential nils if IMBA BP is disabled
	local blink_effect		= "particles/items_fx/blink_dagger_start.vpcf"
	local blink_effect_end	= "particles/items_fx/blink_dagger_end.vpcf"
	
	if CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetPlayerOwnerID())) then
		blink_effect		= CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetPlayerOwnerID()))["blink"]["effect1"]
		blink_effect_end	= CustomNetTables:GetTableValue("battlepass_item_effects", tostring(self:GetPlayerOwnerID()))["blink"]["effect2"]
	end
	
--	print(blink_effect, blink_effect_end, blink_sound)

	local blink_sound = "DOTA_Item.BlinkDagger.Activate"
	if self.blink_effect or (self:GetPlayerOwner() and self:GetPlayerOwner().blink_effect) then blink_effect = self.blink_effect end
	if self.blink_effect_end or (self:GetPlayerOwner() and self:GetPlayerOwner().blink_effect_end) then blink_effect_end = self.blink_effect_end end
	if self.blink_sound or (self:GetPlayerOwner() and self:GetPlayerOwner().blink_sound) then blink_sound = self.blink_sound end
	if bPlaySound == true then EmitSoundOn(blink_sound, self) end

--	print(self.blink_effect, self.blink_effect_end, self.blink_sound)

	local blink_pfx
	if bTeamOnlyParticle == true then
		blink_pfx = ParticleManager:CreateParticleForTeam(blink_effect, PATTACH_CUSTOMORIGIN, nil, self:GetTeamNumber())
		ParticleManager:SetParticleControl(blink_pfx, 0, self:GetAbsOrigin())
	else
		blink_pfx = ParticleManager:CreateParticle(blink_effect, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(blink_pfx, 0, self:GetAbsOrigin())
	end
	ParticleManager:ReleaseParticleIndex(blink_pfx)
	FindClearSpaceForUnit(self, position, true)
	ProjectileManager:ProjectileDodge( self )
	local blink_end_pfx
	if bTeamOnlyParticle == true then
		blink_end_pfx = ParticleManager:CreateParticleForTeam(blink_effect_end, PATTACH_ABSORIGIN, self, self:GetTeamNumber())
	else
		blink_end_pfx = ParticleManager:CreateParticle(blink_effect_end, PATTACH_ABSORIGIN, self)
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
