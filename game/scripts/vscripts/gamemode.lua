-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
	_G.GameMode = class({})
end

-- clientside KV loading
require('addon_init')

require('libraries/adv_log')
require('libraries/timers')
require('libraries/notifications')
require('libraries/npc_class_extension')
require('libraries/rgb_to_hex')
require('libraries/keyvalues')
require('libraries/disable_help')
require('libraries/modifiers')
require('libraries/animations')

require('internal/gamemode')
require('settings')
require('events')
require('filters')

require('components/hero_selection')
require('components/respawn_timer')
require('components/vanillafier_tooltips/init')
require('components/runes/runes')
VANILLA_ABILITIES_BASECLASS = require('components/abilities/vanilla_baseclass')

function GameMode:PostLoadPrecache()
	--PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

-- CAREFUL, FOR REASONS THIS FUNCTION IS ALWAYS CALLED TWICE
function GameMode:InitGameMode()
	self:_InitGameMode()
end

function GameMode:SetupPostTurboRules()
	-- Ancients don't regen
	local forts = Entities:FindAllByClassname("npc_dota_fort")

	for _, fort in pairs(forts) do
		fort:SetBaseHealthRegen(0.0)
	end
end

function GameMode:SetupFountains()
	for _, fountainEnt in pairs(Entities:FindAllByClassname("ent_dota_fountain") or {}) do
		fountainEnt:AddAbility("imba_fountain_danger_zone"):SetLevel(1)

		-- remove vanilla fountain healing
		if fountainEnt:HasModifier("modifier_fountain_aura") then
			fountainEnt:RemoveModifierByName("modifier_fountain_aura")
			fountainEnt:AddNewModifier(fountainEnt, nil, "modifier_fountain_aura_lua", {})
		end

		local danger_zone_pfx = ParticleManager:CreateParticle("particles/ambient/fountain_danger_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(danger_zone_pfx, 0, fountainEnt:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(danger_zone_pfx)
	end
end

function GameMode:CheckFullTeamDisconnect(iTeam)
	local count = 0

	for i = 1, PlayerResource:GetPlayerCountForTeam(iTeam) do
		local iPlayerID = PlayerResource:GetNthPlayerIDOnTeam(iTeam, i)

		if PlayerResource:GetConnectionState(iPlayerID) ~= DOTA_CONNECTION_STATE_CONNECTED then
			count = count + 1
		end
	end

	if count == PlayerResource:GetPlayerCountForTeam(iTeam) then
		local winner_team = 2
		if iTeam == 2 then winner_team = 3 end

		GameRules:SetGameWinner(winner_team)
	end
end
