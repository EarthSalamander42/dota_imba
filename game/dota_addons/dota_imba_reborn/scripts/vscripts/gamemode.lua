if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('libraries/adv_log')
require('libraries/animations')
require('libraries/keyvalues')
require('libraries/modifiers')
require('libraries/notifications')
require('libraries/player')
require('libraries/player_resource')
require('libraries/projectiles')
require('libraries/rgb_to_hex')
require('libraries/timers')

require('internal/gamemode')
require('internal/events')

require('components/api/imba')
require('components/battlepass/donator')
require('components/battlepass/experience')
require('components/battlepass/imbattlepass')
require('components/hero_selection/hero_selection')
require('components/mutation/mutation')
require('components/runes')
require('components/settings/settings')
require('components/team_selection')

require('events/events')
require('filters')

-- Use this function as much as possible over the regular Precache (this is Async Precache)
function GameMode:PostLoadPrecache()

end

function GameMode:OnFirstPlayerLoaded()
	api.imba.register(function()
		-- configure log from api
		Log:ConfigureFromApi()
	end)

	GoodCamera = Entities:FindByName(nil, "good_healer_6")
	BadCamera = Entities:FindByName(nil, "bad_healer_6")

	if GetMapName() ~= "imba_1v1" then
		ROSHAN_SPAWN_LOC = Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):GetAbsOrigin()
		Entities:FindByClassname(nil, "npc_dota_roshan_spawner"):RemoveSelf()
		if GetMapName() ~= "imba_1v1" then
			local roshan = CreateUnitByName("npc_imba_roshan", ROSHAN_SPAWN_LOC, true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end

function GameMode:OnAllPlayersLoaded()
	-- Setup filters
--	GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap(GameMode, "HealingFilter"), self )
	GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap(GameMode, "OrderFilter"), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(GameMode, "DamageFilter"), self )
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap(GameMode, "GoldFilter"), self )
	GameRules:GetGameModeEntity():SetModifyExperienceFilter( Dynamic_Wrap(GameMode, "ExperienceFilter"), self )
	GameRules:GetGameModeEntity():SetModifierGainedFilter( Dynamic_Wrap(GameMode, "ModifierFilter"), self )
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter( Dynamic_Wrap(GameMode, "ItemAddedFilter"), self )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 )
	GameRules:GetGameModeEntity():SetPauseEnabled(false)
end

function GameMode:InitGameMode()
	-- Store day/night time clientside
	StoreCurrentDayCycle()
	CustomGameEventManager:RegisterListener("change_companion", Dynamic_Wrap(self, "DonatorCompanionJS"))
	CustomGameEventManager:RegisterListener("change_companion_skin", Dynamic_Wrap(self, "DonatorCompanionSkinJS"))

	self:SetUpFountains()
	self:_InitGameMode()
end

-- Set up fountain regen
function GameMode:SetUpFountains()

	local fountainEntities = Entities:FindAllByClassname( "ent_dota_fountain")
	for _,fountainEnt in pairs( fountainEntities ) do
		fountainEnt:AddNewModifier( fountainEnt, fountainEnt, "modifier_fountain_aura_lua", {} )
		fountainEnt:AddAbility("imba_fountain_danger_zone"):SetLevel(1)

		-- remove vanilla fountain healing
		if fountainEnt:HasModifier("modifier_fountain_aura") then
			fountainEnt:RemoveModifierByName("modifier_fountain_aura")
			fountainEnt:AddNewModifier(fountainEnt, nil, "modifier_fountain_aura_lua", {})
		end
	end
end

function GameMode:DonatorCompanionJS(event)
	DonatorCompanion(event.ID, event.unit, event.js)
end

function GameMode:DonatorCompanionSkinJS(event)
	DonatorCompanionSkin(event.ID, event.unit, event.skin)
end
