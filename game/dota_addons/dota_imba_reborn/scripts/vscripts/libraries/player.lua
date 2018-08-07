-- Health regeneration % amplification
function CDOTA_BaseNPC:GetHealthRegenAmp()
	local regen_increase = 0
	for _, parent_modifier in pairs(self:FindAllModifiers()) do
		if parent_modifier.GetModifierHealthRegenAmp then
			regen_increase = regen_increase + parent_modifier:GetModifierHealthRegenAmp()
		end
	end
	return regen_increase
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
