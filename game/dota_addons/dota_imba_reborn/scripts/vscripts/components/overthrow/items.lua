--[[ items.lua ]]

--Spawns Bags of Gold in the middle
function Imbathrow:ThinkGoldDrop()
	local r = RandomInt( 1, 100 )
	if r > ( 100 - self.m_GoldDropPercent ) then
		self:SpawnGold()
	end
end

function Imbathrow:SpawnGold()
	local overBoss = Entities:FindByName( nil, "@overboss" )
	local throwCoin = nil
	local throwCoin2 = nil
	if overBoss then
		throwCoin = overBoss:FindAbilityByName( 'dota_ability_throw_coin' )
		throwCoin2 = overBoss:FindAbilityByName( 'dota_ability_throw_coin_long' )
	end

	-- sometimes play the long anim
	if throwCoin2 and RandomInt( 1, 100 ) > 80 then
		overBoss:CastAbilityNoTarget( throwCoin2, -1 )
	elseif throwCoin then
		overBoss:CastAbilityNoTarget( throwCoin, -1 )
	else
		self:SpawnGoldEntity( Vector( 0, 0, 0 ) )
	end
end

function Imbathrow:SpawnGoldEntity( spawnPoint )
	local item_name = "item_bag_of_gold"

	if Imbathrow.USE_RUNES_IN_KOBOLD_THROW == true then
		if RandomInt(1, 100) < Imbathrow.RUNES_SPAWN_CHANCE then
			item_name = Imbathrow.RUNES_LIST[RandomInt(1, #Imbathrow.RUNES_LIST)]
		end
	end

	EmitGlobalSound("Item.PickUpGemWorld")
	local newItem = CreateItem( item_name, nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	local dropRadius = RandomFloat( self.m_GoldRadiusMin, self.m_GoldRadiusMax )
	newItem:LaunchLootInitialHeight( false, 0, 500, 0.75, spawnPoint + RandomVector( dropRadius ) )
	newItem:SetContextThink( "KillLoot", function() return self:KillLoot( newItem, drop ) end, 20 )
end

--Removes Bags of Gold after they expire
function Imbathrow:KillLoot( item, drop )

	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitGlobalSound("Item.PickUpWorld")

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

function Imbathrow:SpecialItemAdd( event )
	local item = EntIndexToHScript( event.ItemEntityIndex )
	local owner = EntIndexToHScript( event.HeroEntityIndex )
	local hero = owner:GetClassname()
	local ownerTeam = owner:GetTeamNumber()
	local sortedTeams = {}
	for _, team in pairs( self.m_GatheredShuffledTeams ) do
		table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
	end

	-- reverse-sort by score
	table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )
	local n = TableCount( sortedTeams )
	local leader = sortedTeams[1].teamID
	local lastPlace = sortedTeams[n].teamID

	local tableindex = 0
	local tier1 = 
	{
		"item_imba_urn_of_shadows",
		"item_ring_of_basilius",
		"item_imba_ring_of_aquila",
		"item_imba_arcane_boots",
		"item_tranquil_boots",
		"item_phase_boots",
		"item_power_treads",
		"item_medallion_of_courage",
		"item_soul_ring",
		"item_gem",
		"item_orb_of_venom",
		"item_imba_poor_mans_shield",
		"item_imba_ogre_seal_totem",
	}
	local tier2 = 
	{
		"item_imba_blink",
		"item_imba_force_staff",
		"item_cyclone",
		"item_imba_ghost",
		"item_imba_vanguard",
		"item_imba_mask_of_madness",
		"item_imba_blade_mail",
		"item_helm_of_the_dominator",
		"item_imba_vladmir",
		"item_imba_sange",
		"item_imba_yasha",
		"item_imba_kaya",
		"item_imba_mekansm",
		"item_hood_of_defiance",
		"item_imba_veil_of_discord",
		"item_glimmer_cape",
		"item_imba_armlet",
		"item_imba_ancient_janggo",
		"item_imba_white_queen_cape",
		"item_imba_cheese",
		"item_imba_echo_sabre",
		"item_imba_aether_lens",
		"item_imba_cloak_of_flames",
		"item_imba_spirit_vessel",
	}
	local tier3 = 
	{
		"item_imba_shivas_guard",
		"item_sphere",
		"item_imba_diffusal_blade",
		"item_imba_maelstrom",
		"item_basher",
		"item_imba_shadow_blade",
		"item_imba_desolator",
		"item_ultimate_scepter",
		"item_bfury",
		"item_imba_pipe",
		"item_imba_heavens_halberd",
		"item_imba_crimson_guard",
		"item_black_king_bar",
		"item_imba_black_queen_cape",
		"item_imba_bloodstone_720",
		"item_lotus_orb",
		"item_imba_guardian_greaves",
		"item_imba_lifesteal_boots",
		"item_imba_moon_shard",
		"item_imba_vladmir_2",
		"item_imba_arcane_nexus",
		"item_imba_hurricane_pike",
		"item_imba_nullifier",
	}
	local tier4 = 
	{
		"item_imba_skadi",
		"item_imba_sange_yasha",
		"item_imba_kaya_and_sange",
		"item_imba_yasha_and_kaya",
		"item_imba_greater_crit",
		"item_imba_sheepstick",
		"item_imba_orchid",
		"item_imba_heart",
		"item_imba_mjollnir",
		"item_imba_ethereal_blade",
		"item_imba_radiance",
		"item_imba_abyssal_blade",
		"item_imba_butterfly",
		"item_imba_monkey_king_bar",
		"item_imba_satanic",
		"item_imba_octarine_core",
		"item_imba_silver_edge",
		"item_imba_rapier",
		"item_imba_rapier_magic",
		"item_imba_assault",
		"item_imba_diffusal_blade_2",
		"item_imba_power_treads_2",
		"item_imba_haste_boots",
		"item_imba_ironleaf_boots",
		"item_imba_blink_boots",
		"item_imba_reverb_rapier",
		"item_imba_manta",
	}
	local tier5 = 
	{
		"item_imba_bloodthorn",
		"item_imba_siege_cuirass",
		"item_imba_sogat_cuirass",
		"item_imba_jarnbjorn",
		"item_imba_desolator_2",
		"item_imba_witchblade",
		"item_imba_starfury",
		"item_imba_ultimate_scepter_synth",
		"item_imba_rapier_2",
		"item_imba_rapier_magic_2",
		"item_imba_rapier_cursed",
		"item_imba_hellblade",
		"item_imba_meteor_hammer_4",
		"item_imba_rod_of_atos_2",
		"item_imba_the_triumvirate_v2",
		"item_imba_wand_of_the_brine",
		"item_imba_glimmerdark_shield",
		"item_imba_lance_of_longinus",
		"item_imba_nullifier_2",
		"item_imba_bladestorm_mail",
		"item_imba_origin",
		"item_the_caustic_finale",
	}

	local t1 = PickRandomShuffle( tier1, self.tier1ItemBucket )
	local t2 = PickRandomShuffle( tier2, self.tier2ItemBucket )
	local t3 = PickRandomShuffle( tier3, self.tier3ItemBucket )
	local t4 = PickRandomShuffle( tier4, self.tier4ItemBucket )
	local t5 = PickRandomShuffle( tier5, self.tier5ItemBucket )

	local spawnedItem = ""

	-- pick the item we're giving them
	if GetTeamHeroKills( leader ) > 5 and GetTeamHeroKills( leader ) <= 10 then
		if ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 0 ) and ( self.leadingTeamScore - self.runnerupTeamScore < 3 ) then
			spawnedItem = t1
		elseif ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 3 ) then
			spawnedItem = t2
		elseif ownerTeam == lastPlace then
			spawnedItem = t4
		else
			spawnedItem = t3
		end
	elseif GetTeamHeroKills( leader ) > 10 and GetTeamHeroKills( leader ) <= 15 then
		if ownerTeam == leader and ( self.leadingTeamScore - self.runnerupTeamScore > 3 ) then
			spawnedItem = t3
		elseif ownerTeam == lastPlace then
			spawnedItem = t5
		else
			spawnedItem = t4
		end
	else
		spawnedItem = t3
	end

	-- add the item to the inventory and broadcast
	owner:AddItemByName( spawnedItem )
	EmitGlobalSound("powerup_04")
	local overthrow_item_drop =
	{
		hero_id = hero,
		dropped_item = spawnedItem
	}
	CustomGameEventManager:Send_ServerToAllClients( "overthrow_item_drop", overthrow_item_drop )
end

function Imbathrow:ThinkSpecialItemDrop()
	-- Stop spawning items after 15
	if self.nNextSpawnItemNumber >= 15 then
		return
	end
	-- Don't spawn if the game is about to end
	if nCOUNTDOWNTIMER < 20 then
		return
	end
	local t = GameRules:GetDOTATime( false, false )
	local tSpawn = ( self.spawnTime * self.nNextSpawnItemNumber )
	local tWarn = tSpawn - 15
	
	if not self.hasWarnedSpawn and t >= tWarn then
		-- warn the item is about to spawn
		self:WarnItem()
		self.hasWarnedSpawn = true
	elseif t >= tSpawn then
		-- spawn the item
		self:SpawnItem()
		self.nNextSpawnItemNumber = self.nNextSpawnItemNumber + 1
		self.hasWarnedSpawn = false
	end
end

function Imbathrow:PlanNextSpawn()
	local missingSpawnPoint =
	{
		origin = "0 0 384",
		targetname = "item_spawn_missing"
	}

	local r = RandomInt( 1, 8 )
	if GetMapName() == "desert_quintet" then
		print("map is desert_quintet")
		r = RandomInt( 1, 6 )
	elseif GetMapName() == "temple_quartet" then
		print("map is temple_quartet")
		r = RandomInt( 1, 4 )
	end
	local path_track = "item_spawn_" .. r
	local spawnPoint = Vector( 0, 0, 700 )
	local spawnLocation = Entities:FindByName( nil, path_track )

	if spawnLocation == nil then
		spawnLocation = SpawnEntityFromTableSynchronous( "path_track", missingSpawnPoint )
		spawnLocation:SetAbsOrigin(spawnPoint)
	end
	
	self.itemSpawnLocation = spawnLocation
	self.itemSpawnIndex = r
end

function Imbathrow:WarnItem()
	-- find the spawn point
	self:PlanNextSpawn()

	local spawnLocation = self.itemSpawnLocation:GetAbsOrigin();

	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_will_spawn", { spawn_location = spawnLocation } )
	EmitGlobalSound( "powerup_03" )
	
	-- fire the destination particles
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "Start", "0", 0, self, self )

	-- Give vision to the spawn area (unit is on goodguys, but shared vision)
	local visionRevealer = CreateUnitByName( "npc_vision_revealer", spawnLocation, false, nil, nil, DOTA_TEAM_GOODGUYS )
	visionRevealer:SetContextThink( "KillVisionRevealer", function() return visionRevealer:RemoveSelf() end, 35 )
	local trueSight = ParticleManager:CreateParticle( "particles/econ/wards/f2p/f2p_ward/f2p_ward_true_sight_ambient.vpcf", PATTACH_ABSORIGIN, visionRevealer )
	ParticleManager:SetParticleControlEnt( trueSight, PATTACH_ABSORIGIN, visionRevealer, PATTACH_ABSORIGIN, "attach_origin", visionRevealer:GetAbsOrigin(), true )
	visionRevealer:SetContextThink( "KillVisionParticle", function() return trueSight:RemoveSelf() end, 35 )
end

function Imbathrow:SpawnItem()
	-- notify everyone
	CustomGameEventManager:Send_ServerToAllClients( "item_has_spawned", {} )
	EmitGlobalSound( "powerup_05" )

	-- spawn the item
	local startLocation = Vector( 0, 0, 700 )
	local treasureCourier = CreateUnitByName( "npc_dota_treasure_courier" , startLocation, true, nil, nil, DOTA_TEAM_NEUTRALS )
	local treasureAbility = treasureCourier:FindAbilityByName( "dota_ability_treasure_courier" )
	treasureAbility:SetLevel( 1 )
    --print ("Spawning Treasure")
    targetSpawnLocation = self.itemSpawnLocation
    treasureCourier:SetInitialGoalEntity(targetSpawnLocation)
    local particleTreasure = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN, treasureCourier )
	ParticleManager:SetParticleControlEnt( particleTreasure, PATTACH_ABSORIGIN, treasureCourier, PATTACH_ABSORIGIN, "attach_origin", treasureCourier:GetAbsOrigin(), true )
	treasureCourier:Attribute_SetIntValue( "particleID", particleTreasure )
end

function Imbathrow:ForceSpawnItem()
	self:WarnItem()
	self:SpawnItem()
end

function Imbathrow:KnockBackFromTreasure( center, radius, knockback_duration, knockback_distance, knockback_height )
	local targetType = bit.bor( DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_HERO )
	local knockBackUnits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, center, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, targetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
 
	local modifierKnockback =
	{
		center_x = center.x,
		center_y = center.y,
		center_z = center.z,
		duration = knockback_duration,
		knockback_duration = knockback_duration,
		knockback_distance = knockback_distance,
		knockback_height = knockback_height,
	}

	for _,unit in pairs(knockBackUnits) do
--		print( "knock back unit: " .. unit:GetName() )
		unit:AddNewModifier( unit, nil, "modifier_knockback", modifierKnockback );
	end
end


function Imbathrow:TreasureDrop( treasureCourier )
	--Create the death effect for the courier
	local spawnPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	spawnPoint.z = 400
	local fxPoint = treasureCourier:GetInitialGoalEntity():GetAbsOrigin()
	fxPoint.z = 400
	local deathEffects = ParticleManager:CreateParticle( "particles/treasure_courier_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( deathEffects, 0, fxPoint )
	ParticleManager:SetParticleControlOrientation( deathEffects, 0, treasureCourier:GetForwardVector(), treasureCourier:GetRightVector(), treasureCourier:GetUpVector() )
	EmitGlobalSound( "lockjaw_Courier.Impact" )
	EmitGlobalSound( "lockjaw_Courier.gold_big" )

	--Spawn the treasure chest at the selected item spawn location
	local newItem = CreateItem( "item_treasure_chest", nil, nil )
	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	drop:SetForwardVector( treasureCourier:GetRightVector() ) -- oriented differently
	newItem:LaunchLootInitialHeight( false, 0, 50, 0.25, spawnPoint )

	--Stop the particle effect
	DoEntFire( "item_spawn_particle_" .. self.itemSpawnIndex, "stopplayendcap", "0", 0, self, self )

	--Knock people back from the treasure
	self:KnockBackFromTreasure( spawnPoint, 375, 0.25, 400, 100 )
		
	--Destroy the courier
	UTIL_Remove( treasureCourier )
end

function Imbathrow:ForceSpawnGold()
	self:SpawnGold()
end

