MeepoFixes = MeepoFixes or class({})

function MeepoFixes:FindMeepos(main, includeMain)
	local playerId = main:GetPlayerID()
	local meepos = includeMain and {main} or {}
	for _,clone in ipairs(Entities:FindAllByName("npc_dota_hero_meepo")) do
		if clone:IsRealHero() and clone ~= main and clone:GetPlayerID() == playerId then
			table.insert(meepos, clone)
		end
	end
	return meepos
end

function MeepoFixes:ShareRespawnTime(unit, respawnTime)
	if unit:GetFullName() == "npc_dota_hero_meepo" then
		for _,clone in ipairs(MeepoFixes:FindMeepos(unit)) do
			clone:SetTimeUntilRespawn(respawnTime)
		end
	end
end

function MeepoFixes:IsMeepoClone(unit)
	return unit:GetFullName() == "npc_dota_hero_meepo" and unit:IsTrueHero() and not unit:IsMainHero()
end

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

	for m = 1, #meepo_table do
		if meepo_table[m] == PlayerResource:GetSelectedHeroEntity(meepo_table[m]:GetPlayerID()) then -- Real Meepo
			caster = meepo_table[m]
		else -- if IsClone()
--			print("Ability Points ("..m.."): "..caster:GetAbilityPoints().."/"..meepo_table[m]:GetAbilityPoints())
--			meepo_table[m]:SetAbilityPoints(0)

--			if meepo_table[m]:GetLevel() ~= caster:GetLevel() then
				--meepo_table[m]:SetLevel(caster:GetLevel())
--			end

			-- Abilities handle
--			for a = 0, caster:GetAbilityCount()-1 do
--				local skill1 = caster:GetAbilityByIndex(a)
--				local skill2 = meepo_table[m]:GetAbilityByIndex(a)
--				if skill1 and skill2 and skill2:GetLevel() ~= skill1:GetLevel() then
--					skill2:SetLevel(skill1:GetLevel())
--				end
--			end

			-- Items handle
			for i = 0, 8 do
				local item1 = caster:GetItemInSlot(i)
				local item2 = meepo_table[m]:GetItemInSlot(i)

				for _, boots in pairs(meepo_extra_boots) do
					if item1 and item1:GetName() == boots and not meepo_table[m]:HasItemInInventory(item1:GetName()) then
--						print("Item 1:", item1:GetName())
--						UTIL_Remove(item2)
						local item = CreateItem(item1:GetName(), meepo_table[m], meepo_table[m])
						meepo_table[m]:AddItem(item)
						item:SetSellable(false)
						item:SetDroppable(false)
					end
				end

				if item2 then
--					print("Item 2:", item2:GetName())
				end
			end
--			TrackXP(caster, meepo_table[m])
		end
	end
end

function KillMeepos(keys)
	local caster = keys.caster
	local ability = keys.ability
	if caster.OwnerMeepo then caster = caster.OwnerMeepo end
	for _,v in ipairs(caster.Clones) do
		v:ForceKill(false)
	end
end
