function GetClientSync(key)
 	local value = CustomNetTables:GetTableValue( "syncing_purposes", key).value
	return value
end

function MergeTables( t1, t2 )
    for name,info in pairs(t2) do
        t1[name] = info
    end
end


function GetTableLength(rndTable)
	local counter = 0
	for k,v in pairs(rndTable) do
		counter = counter + 1
	end
	return counter
end

function PrintAll(t)
	for k,v in pairs(t) do
		print(k,v)
	end
end

function printObj(obj, hierarchyLevel) 
    if (hierarchyLevel == nil) then
        hierarchyLevel = 0
    elseif (hierarchyLevel == 4) then
        return 0
    end
local whitespace = ""
for i=0,hierarchyLevel,1 do
    whitespace = whitespace .. "-"
end
io.write(whitespace)
print(obj)
if (type(obj) == "table") then
    for k,v in pairs(obj) do
        io.write(whitespace .. "-")
        if (type(v) == "table") then
            printObj(v, hierarchyLevel+1)
        else
            print(v)
        end         
    end
else
    print(obj)
end
end

function C_DOTA_BaseNPC:HasTalent(_,modifierName) -- We need to know modifier! not talent name, but we also want this check to appear seamless server side, so just ignore first value
	if self:HasModifier(modifierName) then
		if self:HasModifier("modifier_"..modifierName) then return true end
	end
	return false
end

function C_DOTA_BaseNPC:FindTalentValue(talentName) -- This value is not protected by a HasAbility check clientside! so hopefully you encased your code with HasTalent first!
  local specialVal = AbilityKV[talentName]["AbilitySpecial"]
	for l,m in pairs(specialVal) do
		if m["value"] then
			return m["value"]
		end
	end
	return 0
end

function C_DOTA_BaseNPC:FindSpecificTalentValue(talentName,valname)  --Same deal as FindTalentValue.
  local specialVal = AbilityKV[talentName]["AbilitySpecial"]
	for l,m in pairs(specialVal) do
		if m[valname] then
			return m[valname]
		end
	end
  return 0
end

function C_DOTABaseAbility:GetTalentSpecialValueFor(value)
	local base = self:GetSpecialValueFor(value)
	local talentName
	local kv = AbilityKV[talentName]
	for k,v in pairs(kv) do -- trawl through keyvalues
		if k == "AbilitySpecial" then
			for l,m in pairs(v) do
				if m[value] then
					talentName = m["LinkedSpecialBonus"]
				end
			end
		end
	end
	if talentName and self:GetCaster():HasTalent(talentName) then 
		base = base + self:GetCaster():FindTalentValue(talentName) 
	end
	return base
end

function C_DOTA_BaseNPC:HealDisabled()
	if self:HasModifier("Disabled_silence") or 
	   self:HasModifier("primal_avatar_miss_aura") or 
	   self:HasModifier("modifier_reflection_invulnerability") or 
	   self:HasModifier("modifier_elite_burning_health_regen_block") or 
	   self:HasModifier("modifier_elite_entangling_health_regen_block") or 
	   self:HasModifier("modifier_plague_damage") or 
	   self:HasModifier("modifier_rupture_datadriven") or 
	   self:HasModifier("fire_aura_debuff") or 
	   self:HasModifier("item_sange_and_yasha_4_debuff") or 
	   self:HasModifier("cursed_effect") then
	return true
	else return false end
end