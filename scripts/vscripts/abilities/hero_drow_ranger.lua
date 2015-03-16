--[[Author: hewdraw
	Date: 14-3-2015.]]

function FrostArrows( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier
	local freeze_modifier = keys.freeze_modifier
	local ability_level = ability:GetLevel() - 1
	local stacks_to_freeze = ability:GetLevelSpecialValueFor("stacks_to_freeze", ability_level)

	-- Counts stacks up to stacks_to_freeze; when that number is reached, removes all stacks and roots the target with freeze_modifier
	if not target:HasModifier(stack_modifier) then
		ability:ApplyDataDrivenModifier(caster, target, stack_modifier, {})
		target:SetModifierStackCount(stack_modifier, ability, 1)
	elseif target:GetModifierStackCount(stack_modifier, ability) < stacks_to_freeze - 1 then
		local stack_count = target:GetModifierStackCount(stack_modifier, ability)
		target:SetModifierStackCount(stack_modifier, ability, stack_count + 1)
	else
		target:RemoveModifierByName(stack_modifier)
		ability:ApplyDataDrivenModifier(caster, target, freeze_modifier, {})
	end	
end

-- Resets frost arrows stacks on the target when the slow wears off
function FrostArrowsEnd( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stack_modifier = keys.stack_modifier

	target:RemoveModifierByName(stack_modifier)
end

function Gust( keys )
	local vCaster = keys.caster:GetAbsOrigin()
	local vTarget = keys.target:GetAbsOrigin()
	local caster = keys.caster
	local distance = caster:GetAttackRange()

	-- calculates knockback distance
	local len = ( vTarget - vCaster ):Length2D()
	if len > distance then
		len = 25
	else
		len = distance - len + 25
	end

	-- knockbacks using modifier_knockback
	local knockbackModifierTable =
	{
		should_stun = 1,
		knockback_duration = keys.duration,
		duration = keys.duration,
		knockback_distance = len,
		knockback_height = keys.height,
		center_x = keys.caster:GetAbsOrigin().x,
		center_y = keys.caster:GetAbsOrigin().y,
		center_z = keys.caster:GetAbsOrigin().z
	}
	keys.target:AddNewModifier( keys.caster, nil, "modifier_knockback", knockbackModifierTable )
end

function Trueshot( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local buff_modifier = keys.modifier
	local prefix = "modifier_trueshot_damage_mod_"
	
	if(target:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK) then
		Timers:CreateTimer( DoUniqueString( "trueshot_updateDamage_" .. target:entindex() ), {
			endTime = 0.25,
			callback = function()
				-- Adjust damage based on agility of caster
				local agility = caster:GetAgility()
				local percent = ability:GetLevelSpecialValueFor( "trueshot_ranged_damage", ability:GetLevel() - 1 )
				local damage = math.floor( agility * percent / 100 )

				-- Check if the unit is Drow Ranger
				if target == caster then
					damage = math.floor( agility * percent / 50 )
				end
				
				-- Check if unit has attribute
				if not target.TrueshotDamage then
					target.TrueshotDamage = 0
				end
				
				-- Check if unit doesn't have buff
				if not target:HasModifier(buff_modifier) then
					damage = 0
				end
				
				local damage_ref = damage
				
				-- If the stored value is different
				if target.TrueshotDamage ~= damage then
					-- modifier values
					local bitTable = { 512, 256, 128, 64, 32, 16, 8, 4, 2, 1 }
					
					-- Get the list of modifiers on the hero and loops through removing
					local modCount = target:GetModifierCount()
					for i = 0, modCount do
						for u = 1, #bitTable do
							local val = bitTable[u]
							if target:GetModifierNameByIndex( i ) == prefix .. val then
								target:RemoveModifierByName( prefix .. val )
							end
						end
					end
					
					-- Add modifiers
					for p = 1, #bitTable do
						local val = bitTable[p]
						local count = math.floor( damage / val )
						if count >= 1 then
							ability:ApplyDataDrivenModifier( caster, target, prefix .. val, {} )
							damage = damage - val
						end
					end
				end
				target.TrueshotDamage = damage_ref
				return 0.25
			end
		})
	else
		target:RemoveModifierByName(buff_modifier)
	end
end

function Marksmanship( keys )
	local caster = keys.caster
	local ability = keys.ability
	local effect_radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )
	local tree_radius = ability:GetLevelSpecialValueFor( "tree_radius_scepter", ( ability:GetLevel() - 1 ) )
	local modifier_effect = keys.modifier_effect
	local modifier_scepter = keys.modifier_scepter
	local modifier_invis = keys.modifier_invis
	local scepter = HasScepter(caster)
	local caster_position = caster:GetAbsOrigin()

	-- Count units in radius
	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster_position, caster, effect_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
	local count = 0
	for k, v in pairs( units ) do
		count = count + 1
	end

	-- Count trees in radius
	local trees = Entities:FindAllByClassnameWithin( "ent_dota_tree", caster_position, tree_radius )
	local tree_count = 0
	for k, v in pairs( trees ) do
		tree_count = tree_count + 1
	end

	-- Apply and destroy
	if scepter == true then
		if caster:HasModifier( modifier_effect ) then
			caster:RemoveModifierByName( modifier_effect )
		end
		if count == 0 then
			if not caster:HasModifier( modifier_scepter ) then
				ability:ApplyDataDrivenModifier( caster, caster, modifier_scepter, {} )
			end
			if tree_count ~= 0 then
					ability:ApplyDataDrivenModifier( caster, caster, modifier_invis, {} )
					caster:AddNewModifier(caster, ability, "modifier_invisible", {fadetime = 300.0})
			else
					caster:RemoveModifierByName( modifier_invis )
					caster:RemoveModifierByName( "modifier_invisible" )
			end
		elseif count ~= 0 then
				caster:RemoveModifierByName( modifier_scepter )
				caster:RemoveModifierByName( modifier_invis )
				caster:RemoveModifierByName( "modifier_invisible" )
		end
	else
		if caster:HasModifier( modifier_scepter ) then
			caster:RemoveModifierByName( modifier_scepter )
		end
		if caster:HasModifier( modifier_invis ) then
			caster:RemoveModifierByName( modifier_invis )
			caster:RemoveModifierByName( "modifier_invisible" )
		end
		if count == 0 and not caster:HasModifier( modifier_effect ) then
			ability:ApplyDataDrivenModifier( caster, caster, modifier_effect, {} )
		elseif count ~= 0 and caster:HasModifier( modifier_effect ) then
			caster:RemoveModifierByName( modifier_effect )
		end
	end
end