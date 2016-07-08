--[[	Author: sercankd
		Date: 08.07.2016	]]

require('libraries/tool')

function AddSpirits( keys )
    local caster = keys.caster
	local ability = keys.ability
	local max_spirits = ability:GetLevelSpecialValueFor("max_units", ability:GetLevel()-1)
    -- initialize spirit count
		if caster.spirit_count == nil then
				caster.spirits = {}
				caster.spirit_count = 0
		else
			caster.spirit_count = caster.spirit_count + 1
		end
	-- remove more than allowed max spirit count
		if caster.spirit_count >= max_spirits then
			for k,v in ipairs(caster.spirits) do
				if IsValidEntity(v) and v:IsAlive() then
					v:ForceKill(false)
					table.remove(caster.spirits,k)
					caster.spirit_count = caster.spirit_count - 1
				end 
			end
		end
end

--reduces value of spirit count table
function RemoveSpirits( keys )
    local caster = keys.caster
    if caster.spirit_count then
        caster.spirit_count = caster.spirit_count - 1
    end
end

function spawn_spirits( keys )
	-- body
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel() - 1)
	local enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_HERO, 0, 0, false)
	local targets = {}
		-- Populate the enemies table
		if not enemies then
			return
		else
			enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_HERO, 0, 0, false)
		end
		--sort enemies by health
		for k,v in pairs(enemies) do
			local HP = v:GetHealth()
			targets[HP] = {enemy = enemy}
		end
		for key,enemy in spairs(targets,_,max_targets) do
			local unit = CreateUnitByName("npc_spectre_haunt", enemy:GetAbsOrigin(), true, caster, caster:GetOwner(), caster:GetTeam())
			--spawn the spirits near choosen enemies
				unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
				unit:AddNewModifier(nil, nil, "modifier_phased", {Duration = 0.05})
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_imba_haunt", {})
			-- populate spirits table
				table.insert(caster.spirits,unit)
				caster.spirit_count = caster.spirit_count + 1
			--expire spirits
				unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
				caster.spirit_count = caster.spirit_count - 1
		end

end