--[[ 	Author: AtroCty
		Date: 
		15.09.2016	
		Last Update:
		15.09.2016	
	]]--

function TimberChain( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local cooldown = (ability:GetCooldown(ability_level) * GetCooldownReduction(caster) )
	
	-- Create damaged Unitlist if it not exist
	if not ability.chain_damagedUnits then
		ability.chain_damagedUnits = {}
	end

	-- Sound, particle and modifier keys
	local sound_cast = keys.sound_cast
	local sound_retract = keys.sound_retract
	local sound_impact = keys.sound_impact
	local particle_chain = keys.particle_chain
	local particle_trail = keys.particle_trail
	local particle_tree = keys.particle_tree
	local modifier_caster = keys.modifier_caster
	local modifier_dummy = keys.modifier_dummy
	local modifier_stack = keys.modifier_stack
	local modifier_cooldown = keys.modifier_cooldown
	
	-- Parameters
	local scepter = HasScepter(caster)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local chain_radius = ability:GetLevelSpecialValueFor("chain_radius", ability_level)
	local range = ability:GetLevelSpecialValueFor("range", ability_level)
	
	local caster_loc = caster:GetAbsOrigin()
	local start_loc = caster_loc + caster:GetForwardVector() * chain_radius

	-- Calculate range
	local range = range + GetCastRangeIncrease(caster)
	
	-- Cooldown calculations
	RemoveStacks(ability, caster, modifier_stack, 1)
	ability:ApplyDataDrivenModifier(caster, caster, modifier_cooldown, {duration = cooldown})
	local counter = caster:GetModifierStackCount(modifier_stack, caster)
	ability:EndCooldown()
	if not (counter >= 1) then
		local CDBuff = caster:FindModifierByName(modifier_cooldown)
		local remaining_duration = CDBuff:GetRemainingTime()
		ability:StartCooldown(remaining_duration)
	else

	end
	
	-- Play chai n launch sound
	caster:EmitSound(sound_cast)

	-- Create and set up the chain dummy unit
	local chain_dummy = CreateUnitByName("npc_dummy_blank", start_loc + Vector(0, 0, 150), false, caster, caster, caster:GetTeam())
	chain_dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, chain_dummy, modifier_dummy, {})
	chain_dummy:SetForwardVector(caster:GetForwardVector())

	-- Make the chain always visible to both teams
	caster:MakeVisibleToTeam(DOTA_TEAM_GOODGUYS, range / speed)
	caster:MakeVisibleToTeam(DOTA_TEAM_BADGUYS, range / speed)
	
	-- Initialize chain variables
	local chain_loc = start_loc
	local tick_rate = 0.03

	-- Attach the chain particle
	local chain_pfx = ParticleManager:CreateParticle(particle_chain, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(chain_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(chain_pfx, 1, chain_dummy:GetAbsOrigin())
	ParticleManager:SetParticleControl(chain_pfx, 2, Vector(speed,0,0))
	ParticleManager:SetParticleControl(chain_pfx, 3, Vector(10,0,0))

	speed = speed * tick_rate
	
	-- Remove the caster's chain
	local weapon_chain
	if caster:IsHero() then
		weapon_chain = caster:GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
		if weapon_chain ~= nil then
			weapon_chain:AddEffects( EF_NODRAW )
		end
	end
	
	local travel_distance = (caster_loc - chain_loc ):Length2D()
	local chain_step = caster:GetForwardVector() * speed
	local target_hit = false
	local target
	local final_loc

	-- Main chain loop
	Timers:CreateTimer(tick_rate, function()

		-- Check for valid units in the area
		local trees = GridNav:GetAllTreesAroundPoint(chain_loc, chain_radius, false)
		for _,tree in pairs(trees) do
			target_hit = true
			target = tree
			final_loc = target:GetAbsOrigin()
			chain_dummy:EmitSound(sound_impact)
			chain_dummy:SetAbsOrigin( Vector( final_loc.x, final_loc.y, chain_loc.z ) )
			ParticleManager:SetParticleControl(chain_pfx, 1, chain_dummy:GetAbsOrigin())
			break
		end
		
		-- If a valid target was hit, start dragging them
		if target_hit then
		
			-- Apply stun/root modifier, and damage if the target is an enemy
			ability:ApplyDataDrivenModifier(caster, caster, modifier_caster, {})
		end

		-- If no target was hit and the maximum range is not reached, move the chain and keep going
		if not target_hit and travel_distance < range then

			-- Move the chain
			chain_dummy:SetAbsOrigin(chain_loc + chain_step)
			ParticleManager:SetParticleControl(chain_pfx, 1, chain_dummy:GetAbsOrigin())

			-- Recalculate position and distance
			chain_loc = chain_dummy:GetAbsOrigin()
			travel_distance = (chain_loc - caster_loc):Length2D()
			return tick_rate
		end
		
		-- If we are here, this means the chain has to start reeling back; prepare return variables
		local direction = ( caster_loc - chain_loc )
		local current_tick = 0

		if caster.chain_id == nil then
			caster.chain_id = {}
		end
		table.insert(caster.chain_id, false)
	
		local id = #(caster.chain_id)
		
		-- Stop the extending sound and start playing the return sound
		caster:StopSound(sound_cast)
		caster:EmitSound(sound_retract)

		-- Play sound reaction according if a target was hit
		if (RandomInt(1,2) == 1) then
			if target_hit then
				caster:EmitSound("shredder_timb_timberchain_0"..RandomInt(1,9))
			else
				caster:EmitSound("shredder_timb_failure_0"..RandomInt(1,3))
			end
		end
		-- chain reeling loop
		Timers:CreateTimer(tick_rate, function()

			-- Recalculate position variables
			if target_hit then
				caster_loc = caster:GetAbsOrigin()
			else
				caster_loc = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1"))
			end
			chain_loc = chain_dummy:GetAbsOrigin()
			direction = ( chain_loc - caster_loc  )
			chain_step = direction:Normalized() * speed
			current_tick = current_tick + 1
			
			-- If the target is close enough, or the chain has been out too long, finalize the chain return
			if direction:Length2D() < speed or current_tick > 300 then
				-- Stop moving the target
				if target_hit then
					-- Clear the damaged units list
					ability.chain_damagedUnits = {}
					
					-- Destroy tree and apply effect
					tree_pfx = ParticleManager:CreateParticle(particle_tree, PATTACH_POINT, target)
					ParticleManager:SetParticleControl(tree_pfx, 0, final_loc)
					ParticleManager:ReleaseParticleIndex(tree_pfx)
					target:CutDown(DOTA_TEAM_GOODGUYS)
					chain_dummy:EmitSound(sound_impact)
					
					FindClearSpaceForUnit(caster, final_loc, false)
					caster.chain_id[id]=true
				end

				local check = CheckChainCount(caster.chain_id)
				
				if ( check == id) and (caster.chain_id[id] == true) then
					ability.chain_damagedUnits = {}
				end
				
				if ( check == id) and (caster.chain_id[id] == 2) then
					caster.chain_id[id] = true
					check = CheckChainCount(caster.chain_id)
				end
				
				if (caster.chain_id[check] == 2) then
					caster:RemoveModifierByName(modifier_caster)
				end
				
				if (check == nil) then 
					caster.chain_id = nil
					caster:RemoveModifierByName(modifier_caster)
				end
				
				-- Destroy the chain dummy and particles
				chain_dummy:Destroy()
				ParticleManager:DestroyParticle(chain_pfx, false)
				ParticleManager:ReleaseParticleIndex(chain_pfx)

				-- Stop playing the reeling sound
				caster:StopSound(sound_retract)

				-- Give back the caster's chain
				if weapon_chain ~= nil then
					weapon_chain:RemoveEffects( EF_NODRAW )
				end
				
			else
				if not target_hit then
					chain_dummy:SetAbsOrigin(chain_loc - chain_step)
					ParticleManager:SetParticleControl(chain_pfx, 1, chain_dummy:GetAbsOrigin())
					caster.chain_id[id] = 2
				end
				
				if ((target_hit == true) and (id == CheckChainCount(caster.chain_id))) then
					local pos = caster_loc + chain_step
					pos = GetGroundPosition( pos, caster )
					caster:SetAbsOrigin(pos)
					caster_loc = GetGroundPosition( caster_loc, caster )
					if (current_tick % 3) == 0 then
						local trail_pfx = ParticleManager:CreateParticle(particle_trail, PATTACH_ABSORIGIN, caster)
						ParticleManager:SetParticleControl(trail_pfx, 0, caster_loc)
						Timers:CreateTimer(0.05, function() 
							ParticleManager:DestroyParticle(trail_pfx,false)
						end)
					end
				end
				
				return tick_rate
			end
		end)
	end)
end

function TimberChainDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
	local sound_damage = keys.sound_damage
	local hit_particle = keys.hit_particle
	local hit_particle_glow = keys.hit_particle_glow
	
	
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	for _,target in pairs(targets) do
		-- Already got damaged
		if ability.chain_damagedUnits[target] then
			return
		end

		-- Apply damage, sound and particles
		ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_PURE})
		local hit_pfx = ParticleManager:CreateParticle(hit_particle, PATTACH_POINT, target)
		ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(hit_pfx)
		hit_pfx = ParticleManager:CreateParticle(hit_particle_glow, PATTACH_POINT, target)
		ParticleManager:SetParticleControl(hit_pfx, 0, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(hit_pfx)
		target:EmitSound(sound_damage)
		ability.chain_damagedUnits[target] = true
	end
end

function TimberChainStack( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_stack = keys.modifier_stack
	local counter = caster:GetModifierStackCount(modifier_stack, caster)
	local max_counter = ability:GetLevelSpecialValueFor("max_counter", ability_level)
	if counter < max_counter then
		AddStacks(ability, caster, caster, modifier_stack, 1, false)
	end
end

function ChainInitialize( keys )
	local caster = keys.caster
	local ability = keys.ability
	local modifier_stack = keys.modifier_stack
	local modifier_cooldown = keys.modifier_cooldown
	local ability_level = ability:GetLevel() - 1
	local counter = caster:GetModifierStackCount(modifier_stack, caster)
	local max_counter = ability:GetLevelSpecialValueFor("max_counter", ability_level)
	local modifier_counter = caster:FindAllModifiersByName(modifier_cooldown)
	counter = max_counter - counter - #modifier_counter
	AddStacks(ability, caster, caster, modifier_stack, counter, true)
end

-- Checks current casted chains
-- returns false if chain is still flying, true when target was hit, 2 if missed, nil if everything is done
function CheckChainCount ( chain_id )
	local missed = nil
	for i = 1, #chain_id do
		if chain_id[i] == false then
			return i
		end
		if (chain_id[i] == 2) and (missed == nil) then
			missed = i
		end
	end
	return missed
end

function ReactiveArmorInitiliaze( keys )
	local caster = keys.caster
	caster.reactive_magic_damage_counter = 0
	caster.reactive_phys_damage_counter = 0
end

function ReactiveArmorCheck( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local physical_stacks = keys.physical_stacks
	local magical_stacks = keys.magical_stacks
	local physical_counter = keys.physical_counter
	local magical_counter = keys.magical_counter
	local stack_limit = ability:GetLevelSpecialValueFor("stack_limit", ability_level)
	
	local particle_armor = {}
	particle_armor[1] = keys.particle_armor1
	particle_armor[2] = keys.particle_armor2
	particle_armor[3] = keys.particle_armor3
	particle_armor[4] = keys.particle_armor4
	particle_armor[5] = keys.particle_armor4
	
	local phys_stack_count = caster:FindAllModifiersByName(physical_stacks)
	phys_stack_count = #phys_stack_count
	
	if phys_stack_count >= 1 then
		if not caster:HasModifier(physical_counter) then
			ability:ApplyDataDrivenModifier(caster, caster, physical_counter, {})
		end
		caster:SetModifierStackCount(physical_counter, ability, phys_stack_count)
	else
		if caster:HasModifier(physical_counter) then
			caster:RemoveModifierByName(physical_counter)
		end
	end
	
	local mag_stack_count = caster:FindAllModifiersByName(magical_stacks)
	mag_stack_count = #mag_stack_count
	
	if mag_stack_count >= 1 then
		if not caster:HasModifier(magical_counter) then
			ability:ApplyDataDrivenModifier(caster, caster, magical_counter, {})
		end
		caster:SetModifierStackCount(magical_counter, ability, mag_stack_count)
	else
		if caster:HasModifier(magical_counter) then
			caster:RemoveModifierByName(magical_counter)
		end
	end
	
	if (stack_limit < ( phys_stack_count + mag_stack_count ) ) then
		ReactiveArmorStackOverflow( keys )
	end
	
	-- Dynamic particles based on max-stacks
	for i = 1, 5 do
		if (((mag_stack_count + phys_stack_count) > math.floor( (stack_limit / 5 ) * (i-1) ) )	and not caster.armor_particles[i] ) then
			print("hit_pfx",i)
			caster.armor_particles[i] = ParticleManager:CreateParticle(particle_armor[i], PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControlEnt(caster.armor_particles[i], 0, caster, PATTACH_POINT_FOLLOW, "attach_armor", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(caster.armor_particles[i], 2, caster:GetAbsOrigin())
			if i == 5 then
				ParticleManager:SetParticleControlEnt(caster.armor_particles[i], 4, caster, PATTACH_POINT_FOLLOW, "attach_chimmney", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_chimmney")), true)
				local temp = caster.armor_particles[i]
				Timers:CreateTimer(1, function()
					ParticleManager:DestroyParticle(temp, false)
					ParticleManager:ReleaseParticleIndex(temp)
				end)
				caster.armor_particles[i] = nil
			end
		elseif (((mag_stack_count + phys_stack_count) <= math.floor( (stack_limit / 5 ) * (i-1) ) ) and caster.armor_particles[i] ) then
			print("destroy",i)
			ParticleManager:DestroyParticle(caster.armor_particles[i], false)
			ParticleManager:ReleaseParticleIndex(caster.armor_particles[i])
			caster.armor_particles[i] = nil
		end
	end

end

function ReactiveArmor( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	if not caster.armor_particles then caster.armor_particles = {} end
	
	local ability_level = ability:GetLevel() - 1
	local stack_damage = ability:GetLevelSpecialValueFor("stack_damage", ability_level)
	
	if caster.reactive_phys_damage_counter > 0 then
		local physical_stacks = keys.physical_stacks
		local count = 1 + math.floor((caster.reactive_phys_damage_counter / stack_damage))
		caster.reactive_phys_damage_counter = 0
		while count >= 1 do
			ability:ApplyDataDrivenModifier(caster, caster, physical_stacks, {})
			count = count - 1
		end
		return nil
	elseif caster.reactive_magic_damage_counter > 0 then
		local magical_stacks = keys.magical_stacks
		local count = 1 + math.floor((caster.reactive_magic_damage_counter / stack_damage))
		caster.reactive_magic_damage_counter = 0
		while count >= 1 do
			ability:ApplyDataDrivenModifier(caster, caster, magical_stacks, {})
			count = count - 1
		end
		return nil
	end
end

function ReactiveArmorStackOverflow( keys )
	local caster = keys.caster
	local ability = keys.ability
	local physical_stacks = keys.physical_stacks
	local magical_stacks = keys.magical_stacks
	local magic = caster:FindModifierByName(magical_stacks)
	
	local mag_duration
	local phy_duration
	if magic then
		mag_duration = magic:GetRemainingTime()
	end
	
	local physic = caster:FindModifierByName(physical_stacks)
	if physic then
		phy_duration = physic:GetRemainingTime()
	end
	
	if physic and magic then
		if phy_duration <= mag_duration then
			caster:RemoveModifierByName(physical_stacks)
		else
			caster:RemoveModifierByName(magical_stacks)
		end
	elseif physic then
		caster:RemoveModifierByName(physical_stacks)
	else
		caster:RemoveModifierByName(magical_stacks)
	end
end

function ReactiveArmorClear( keys )
	local caster = keys.caster
	for i = 1,5 do
		if caster.armor_particles[i] then
			ParticleManager:DestroyParticle(caster.armor_particles[i], false)
		end
	end
	caster.armor_particles = {}
end

function Dendrophobia( keys )
	local caster = keys.caster
	local ability = keys.ability
	local trees = GridNav:GetAllTreesAroundPoint(Vector(0,0,0), 25000, false)
	local modifier_stack = keys.modifier_stack
	local counter = caster:GetModifierStackCount(modifier_stack, caster)
	local chopped_trees = 2371 - #trees
	local limit = 300
	if chopped_trees > limit then chopped_trees = limit end
	if not (counter == chopped_trees) then
		if caster:HasModifier(modifier_stack) then
			if chopped_trees == 0 then
				caster:RemoveModifierByName(modifier_stack)
			else
				caster:SetModifierStackCount(modifier_stack, ability, chopped_trees)
			end
		else
		ability:ApplyDataDrivenModifier(caster, caster, modifier_stack, {})
		caster:SetModifierStackCount(modifier_stack, ability, chopped_trees)
		end
	end
end

function ChakramInitiliaze( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier_dummy = keys.modifier_dummy
	
	if caster.color then
		ability.color = caster.color
	else
		ability.color = ability.color or 1
	end
	-- Sound, particle and modifier keys
	local particle_chakram = keys.particle_chakram
	local particle_chakram_stay = keys.particle_chakram_stay
	
	local color_list = {}
		--Red
	table.insert(color_list, Vector(255,0,0))
		--Orange
	table.insert(color_list, Vector(255,128,0))
		--Yellow
	table.insert(color_list, Vector(255,255,0))
		--Green
	table.insert(color_list, Vector(0,255,0))
		--Blue
	table.insert(color_list, Vector(0,255,255))
		--Darkblue
	table.insert(color_list, Vector(0,0,255))
		--Purple
	table.insert(color_list, Vector(128,0,255))
	local color
	
	if not caster.color then
		color = color_list[ability.color]
		ability.color = ability.color + 1
		if ability.color == 8 then
			ability.color = 1
		end
	else
		color = caster.color		
	end
	
	print(color)
	-- Parameters
	local scepter = HasScepter(caster)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local caster_loc = caster:GetAbsOrigin()
	local chakram_loc = caster_loc
	local target_loc = keys.target_points[1]
	
	local target_distance = ( caster_loc - target_loc ):Length2D()
	local travel_distance = ( caster_loc - chakram_loc ):Length2D()
		
	-- Create Chakram dummy
	local chakram_dummy = CreateUnitByName("npc_dummy_blank", caster_loc, false, caster, caster, caster:GetTeam())
	chakram_dummy["flag_return"] = false
	chakram_dummy:AddNewModifier(caster, nil, "modifier_phased", {})
	ability:ApplyDataDrivenModifier(caster, chakram_dummy, modifier_dummy, {})
	local target_movement = (target_loc - caster_loc ):Normalized() * speed
	local target_movement2 = (  Vector(target_loc.x, target_loc.y, 0) - Vector(caster_loc.x, caster_loc.y, 0) ):Normalized() * speed
	chakram_dummy:SetForwardVector(caster:GetForwardVector())
	
	-- Set Chakram particles
	local chakram_pfx = ParticleManager:CreateParticle(particle_chakram, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(chakram_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(chakram_pfx, 15, color)
	ParticleManager:SetParticleControl(chakram_pfx, 16, Vector(1,0,0))
	ParticleManager:SetParticleControl(chakram_pfx, 1, target_movement)
	
	local tick_rate = 0.03
	
	speed = speed * tick_rate
	
	local flag = 0
	local ticks = 0
	
	-- Valve's Particle-Animation-System is faster, so an Offset is needed for a clean transition
	local animation_offset = 1.24
	
	local chakram_step = chakram_dummy:GetForwardVector() * speed * animation_offset

	local flag_target = false
	local chakram_stay_pfx
	
	
	Timers:CreateTimer(tick_rate, function()
		
		if travel_distance < target_distance then
			-- Move the chakram
			chakram_dummy:SetAbsOrigin(chakram_loc + chakram_step)

			-- Recalculate position and distance
			chakram_loc = chakram_dummy:GetAbsOrigin()
			travel_distance = (caster_loc - chakram_loc):Length2D()
			return tick_rate
		else
			
			if flag_target == true then
				ParticleManager:DestroyParticle(chakram_pfx, false)
				ParticleManager:ReleaseParticleIndex(chakram_pfx)
				flag_target = 2
				tick_rate = 1
			end
			
			if flag_target == false then
				
				chakram_stay_pfx = ParticleManager:CreateParticle(particle_chakram_stay, PATTACH_CUSTOMORIGIN, caster)
				chakram_loc = GetGroundPosition( chakram_loc, chakram_dummy )
				ParticleManager:SetParticleControl(chakram_stay_pfx, 0, chakram_loc)
				ParticleManager:SetParticleControl(chakram_stay_pfx, 15, color)
				ParticleManager:SetParticleControl(chakram_stay_pfx, 16, Vector(1,0,0))
			
				flag_target = true
			end
			
			flag = flag + 1
			
			if ticks > 10 then
				
				ParticleManager:DestroyParticle(chakram_stay_pfx, false)
				ParticleManager:ReleaseParticleIndex(chakram_stay_pfx)
				chakram_dummy:Destroy()
				return nil
			end
			ticks = ticks + 1
			return tick_rate
		end
	end)
end