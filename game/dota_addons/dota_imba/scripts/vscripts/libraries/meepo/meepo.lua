function TrackMeepos()
local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
local meepo_extra_boots = {
	"item_imba_ironleaf_boots",
	"item_imba_power_treads_2",
	"item_imba_haste_boots",
--	"item_imba_octarine_core",
--	"item_imba_skadi",
	"item_branches"
}

print("Tracking Meepos...")

	for m = 1, #meepo_table do
		if meepo_table[m] == PlayerResource:GetSelectedHeroEntity(meepo_table[m]:GetPlayerID()) then -- Real Meepo
			caster = meepo_table[m]
		else
			for i = 0, 8 do
				local item1 = caster:GetItemInSlot(i)
				local item2 = meepo_table[m]:GetItemInSlot(i)

				for _, boots in pairs(meepo_extra_boots) do
					if item1 and item1:GetName() == boots and not meepo_table[m]:HasItemInInventory(item1:GetName()) then
						local item = CreateItem(item1:GetName(), meepo_table[m], meepo_table[m])
						meepo_table[m]:AddItem(item)
						item:SetSellable(false)
						item:SetDroppable(false)
					end
				end
			end
		end
	end
end

function KillMeepos()
local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")

	if meepo_table then
		for i = 1, #meepo_table do
			if meepo_table[i]:IsClone() then
				meepo_table[i]:SetRespawnsDisabled(true)
			else
				local hero_level = math.min(meepo_table[i]:GetLevel(), 25)
				local respawn_time = HERO_RESPAWN_TIME_PER_LEVEL[hero_level]
				meepo_table[i]:SetTimeUntilRespawn(respawn_time)
			end
		end
	end
end
