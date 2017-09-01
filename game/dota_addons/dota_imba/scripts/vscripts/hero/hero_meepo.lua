function CreateMeepo(keys)
	local caster = keys.caster
	local ability = keys.ability
	if not caster.IsMeepoClone then
		if not caster:HasModifier("modifier_divided_we_stand_arena") then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_divided_we_stand_arena", {})
		end
		local clone = CreateHeroForPlayer(caster:GetUnitName(), caster:GetPlayerOwner())
		FindClearSpaceForUnit(clone, caster:GetAbsOrigin(), true)
		clone:SetPlayerID(caster:GetPlayerID())
		clone:SetControllableByPlayer(caster:GetPlayerID(), true)
		clone:SetOwner(caster)
		clone.OwnerMeepo = caster
		clone.IsMeepoClone = true

		for i = 1, caster:GetLevel() - 1 do
			clone:HeroLevelUp(false)
		end
		if not ability.Clones then ability.Clones = {} end
		table.insert(ability.Clones, clone)
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

function TrackMeepos(keys)
local caster = keys.caster
local ability = keys.ability

	local meepo_table = Entities:FindAllByName("npc_dota_hero_meepo")
	if meepo_table then
		for m = 1, #meepo_table do
			if meepo_table[m] == PlayerResource:GetSelectedHeroEntity(caster:GetPlayerID()) then -- Real Meepo
			else -- if IsClone()
--				print("Ability Points ("..m.."): "..caster:GetAbilityPoints().."/"..meepo_table[m]:GetAbilityPoints())
				meepo_table[m]:SetAbilityPoints(0)

				if meepo_table[m]:GetLevel() ~= caster:GetLevel() then
					--meepo_table[m]:SetLevel(caster:GetLevel())
				end

				-- Abilities handle
				for a = 0, caster:GetAbilityCount()-1 do
					local skill1 = caster:GetAbilityByIndex(a)
					local skill2 = meepo_table[m]:GetAbilityByIndex(a)
					if skill1 and skill2 and skill2:GetLevel() ~= skill1:GetLevel() then
						skill2:SetLevel(skill1:GetLevel())
					end
				end

				-- Items handle
				for i = 0, 8 do
					local item1 = caster:GetItemInSlot(i)
					local item2 = meepo_table[m]:GetItemInSlot(i)

					if item1 and not meepo_table[m]:HasItemInInventory(item1:GetName()) then
						print("Item 1:", item1:GetName())
--						UTIL_Remove(item2)
						local item = CreateItem(item1:GetName(), meepo_table[m], meepo_table[m])
						meepo_table[m]:AddItem(item)
						item:SetSellable(false)
						item:SetDroppable(false)
					end

					if item2 then
--						print("Item 2:", item2:GetName())
					end
				end
				TrackXP(caster, meepo_table[m])
			end
		end
	end
end

--================================

function TrackXP(meepo, clone)
local mxp = meepo:GetCurrentXP()
local cxp = clone:GetCurrentXP()

	if cxp > mxp then
		local diff = cxp - mxp
		meepo:AddExperience(diff, 0, false, false)
	elseif mxp > cxp then
		local diff = mxp - cxp
		clone:AddExperience(diff, 0, false, false)
	end
end 