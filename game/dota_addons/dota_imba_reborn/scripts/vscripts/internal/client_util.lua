function MergeTables( t1, t2 )
	for name,info in pairs(t2) do
		t1[name] = info
	end
end

function C_DOTA_BaseNPC:HasTalent(talentName)
	if self:HasModifier("modifier_"..talentName) then
		return true 
	end

	return false
end

function C_DOTA_BaseNPC:FindTalentValue(talentName, key)
	if self:HasModifier("modifier_"..talentName) then  
		local value_name = key or "value"
		local specialVal = AbilityKV[talentName]["AbilitySpecial"]
		for l,m in pairs(specialVal) do
			if m[value_name] then
				return m[value_name]
			end
		end
	end    
	return 0
end

function C_DOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = AbilityKV[self:GetName()]
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName and self:GetCaster():HasModifier("modifier_"..talentName) then 
		base = base + self:GetCaster():FindTalentValue(talentName) 
	end
	return base
end

function C_DOTA_Modifier_Lua:CheckUniqueValue(value, tSuperiorModifierNames)
	local hParent = self:GetParent()
	if tSuperiorModifierNames then
		for _,sSuperiorMod in pairs(tSuperiorModifierNames) do
			if hParent:HasModifier(sSuperiorMod) then
				return 0
			end
		end
	end
	if bit.band(self:GetAttributes(), MODIFIER_ATTRIBUTE_MULTIPLE) == MODIFIER_ATTRIBUTE_MULTIPLE then
		if self:GetStackCount() == 1 then
			return 0
		end
	end
	return value
end

function C_DOTA_Modifier_Lua:CheckUnique(bCreated)
return nil end