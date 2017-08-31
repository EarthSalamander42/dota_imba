function CreateMeepo(keys)
	local caster = keys.caster
	local ability = keys.ability
	if not caster.IsMeepoClone then
		for i = 1, 70 do
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
			ability:ApplyDataDrivenModifier(caster, clone, "modifier_divided_we_stand_clone", {})
			if not ability.Clones then ability.Clones = {} end
			table.insert(ability.Clones, clone)
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

function TrackMeepos(keys)
	local caster = keys.caster
	local ability = keys.ability
	for _,v in ipairs(ability.Clones) do
		TrackXP(caster, v)
		v:SetAbilityPoints(caster:GetAbilityPoints())
		for i = 0, caster:GetAbilityCount() - 1 do
			local skill = caster:GetAbilityByIndex(i)
			if skill then
				local clone_skill = v:FindAbilityByName(skill:GetName())
				if clone_skill then
					--if clone_skill:GetL > skill then
					--	skill:SetLevel(clone_skill:GetLevel())
					--end
				end
			end
		end
		--[[
		for i = 0, 5 do
			FillSlotsWithDummy(v)
			local item1 = caster:GetItemInSlot(i)
			local item2 = v:GetItemInSlot(i)
			if item1 then
				UTIL_Remove(item2)
				v:AddItem(item1)
			end
			ClearSlotsFromDummy(v)
		end]]
	end
end

function TrackSkills(keys)
	local caster = keys.caster
	local ability = keys.ability

	if v:GetLevel() ~= caster:GetLevel() then
		--v:SetLevel(caster:GetLevel())
	end
	for i = 0, caster:GetAbilityCount()-1 do
		local skill1 = caster:GetAbilityByIndex(i)
		local skill2 = v:GetAbilityByIndex(i)
		if skill1 and skill2 and skill2:GetLevel() ~= skill1:GetLevel() then
			skill2:SetLevel(skill1:GetLevel())
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
		meepo:AddExperience(diff, 0, false, false)
	end
end 