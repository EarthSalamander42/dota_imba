if Imbattlepass == nil then Imbattlepass = class({}) end

function Imbattlepass:Init()
	ImbattlepassReward = {}
	for ID = 0, PlayerResource:GetPlayerCount() -1 do
		ImbattlepassReward[ID] = {}
		for i = 1, #XP_level_table do
			ImbattlepassReward[ID][i] = false
			if get_stats_for_player(ID).xp > XP_level_table[i] then
				ImbattlepassReward[ID][i] = true
				print("Reward Enabled:", i)
			end
		end
	end
end

function Imbattlepass:GetRewardUnlocked(ID, reward_id)
	return ImbattlepassReward[ID][reward_id]
end

--[[ Not Added yet: 
	Custom Icons if has special item effects
	Rank Double Down,
	XP Boosters,
	TP Scroll effect + pro team effect,
	golden roshan contributor statue(level 500?),
	Fountain effect,
	Force Staff effect,
	Mekansm/Guardian Greaves effect,
	Mjollnir/Jarnbjorn effect,
	Companion unlocking (need to create the companion choice in-game and remove the one in website),
	Dagon effect,
	Eul Scepter effect,
	Level Up effect (not sure it's possible),
	Bottle effect,
	Aegis effect,
	Hermes companion with all cosmetics,
	River painting (if possible),
	Deny creep effect with ? instead of !,
	Tiny unique set,
--]]

--[[ Actual Rewards
	Level 9: Blink Effect (Blue/Green)
	Level 18: Blink Effect (Green)
	Level 27: Blink Effect (Water/Blue)
	Level 36: Blink Effect (Water/Blue 2)
	Level 44: Radiance Effect (Water)
	Level 45: Blink Effect (Snow)
	Level 54: Blink Effect (Red)
	Level 60: Sheepstick Effect (Blue Pig + Winter)
	Level 63: Blink Effect (Red 2)
	Level 72: Blink Effect (Gold)
	Level 81: Blink Effect (Gold 2)
	Level 88: Radiance Effect (Red)
	Level 90: Blink Effect (Purple)
	Level 100: Shiva Effect (Water)
	Level 120: Sheepstick Effect (Bird + Red)
--]]
