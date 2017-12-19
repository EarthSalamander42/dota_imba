--[[
Usage:
Usage of this lib is 99% going to involve calls to just CreateIllusion, which handles all stuff under the hood.  There may be some special things you need to do involving illus 
on other heroes, and for that there is a callback func built into CreateIllusion

IllusionManager:CreateIllusion(OwningEntity,Ability(can be nil),SpawnVector,IllusionBase,{uniquekeys=here,CanBeNil})
IllusionManager:CreateIllusion(handle,handle,vector,handle,{table})

Accepted Special Keys
duration							 = override duration	  provided by Ability, or use this if Ability is nil
damagein							 = override DamageIn  % provided by Ability, or use this if Ability is nil
damageout							 = override DamageOut % provided by Ability, or use this if Ability is nil
modifier_illusion_name = use a special built in 'modifier_illusion', like juxtapose (which doesn't work anyway so don't do it)
unique								 = assign a unique index to this illusions baseclass, allowing only one of each type to exist in the world
NOTE: in regards to the 'unique' specialkey, it's attached to the already existing baseclass! that means if you call two different base types and attempt to use unique, you can have multiple uniques!! this completely defeats the purpose of this key

Example:
IllusionManager:CreateIllusion(OwningEntity,Ability(can be nil),SpawnVector					  ,IllusionBase,{uniquekeys=here,CanBeNil})
IllusionManager:CreateIllusion(caster, ability, caster:GetAbsOrigin() ,caster, {unique='mantas'..i,callback = mantacallback})

Manta Usage:

~~~

function mantacallback()
	print('we did it!')
end

for i=1,2 do
	IllusionManager:CreateIllusion(caster,ability,caster:GetAbsOrigin(),caster,{unique='mantas'..i,callback = mantacallback})
end

~~~

Creates an illusion owned by caster, with stats from ability, at casters origin, and with casters basemodel and stats.  It must be written in a loop to create more than one illusions with unique keys based on the iterator.
After being created, it will look at a function named 'mantacallback' and then run that to assign any special things necessary after the original callback.

]]--
IllusionManager = IllusionManager or class({})

LinkLuaModifier("modifier_illusion_manager"					 		 , "libraries/illusionmanager", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_illusion_manager_out_of_world" , "libraries/illusionmanager", LUA_MODIFIER_MOTION_NONE)

modifier_illusion_manager = class({
	DeclareFunctions                 				= function(self) return modifier_illusion_manager.funcs  end,       
	IsDebuff                         				= function(self) return false                  				 	 end,    
	IsPurgable                       				= function(self) return false                 					 end,  
	IsHidden										= function(self) return true														 end,
	GetModifierDamageOutgoing_Percentage 			= function(self) return self.damageout 									 end,
	GetModifierIncomingDamage_Percentage			= function(self) return self.damagein										 end,
},
{
	funcs = {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	},
	states = {}
})		

modifier_illusion_manager_out_of_world	= class({
	DeclareFunctions                 = function(self) return modifier_illusion_manager_out_of_world.funcs end,       
	CheckState						 = function(self) return self.states   											 					end,
	IsDebuff                         = function(self) return false                               					end,    
	IsPurgable                       = function(self) return false                               					end,    
	IsHidden						 = function(self) return true																 					end,				
	},
	{
	funcs = {MODIFIER_PROPERTY_BONUS_DAY_VISION,
			MODIFIER_PROPERTY_BONUS_NIGHT_VISION},
	states = {[MODIFIER_STATE_OUT_OF_GAME]=true,
		[MODIFIER_STATE_INVULNERABLE]=true,
		[MODIFIER_STATE_NO_HEALTH_BAR]=true,
		[MODIFIER_STATE_STUNNED]=true,
		[MODIFIER_STATE_UNSELECTABLE]=true,
		[MODIFIER_STATE_NO_UNIT_COLLISION]=true,
		[MODIFIER_STATE_PASSIVES_DISABLED]=true,
		[MODIFIER_STATE_MUTED]=true,
	}		
})

function modifier_illusion_manager:OnCreated(params)
	self.damagein  = params.damagein
	self.damageout = params.damageout
	self.special_modifier = params.special_modifier
end

function modifier_illusion_manager:OnTakeDamage(params)
	if not IsServer() then return end	
	if params.unit == self:GetParent() then
		if params.damage > self:GetParent():GetHealth() then
			params.damage = 0 																																					 -- prevent death and make it look like we really died
			self:GetParent():SetHealth(1)
			self:GetParent().active = 0
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_illusion_manager_out_of_world", {})
		end
	end
end

function modifier_illusion_manager:OnDestroy()
	if not IsServer() then return end	
	IllusionManager:WipeIllusion(self:GetParent())	
	self:GetParent():SetHealth(1)
	self:GetParent().active = 0
	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_illusion_manager_out_of_world", {special_modifier = self.special_modifier})	
	local illusiontimer = self:GetParent():FindModifierByName("modifier_illusion")	
	if self.special_modifier then
		illusiontimer = self:GetParent():FindModifierByName(self.special_modifier)
	end
	illusiontimer:SetDuration(1,true) 																															 -- prevent modifier_illusion from running out 
end

function modifier_illusion_manager_out_of_world:GetBonusDayVision() return -10000 end
function modifier_illusion_manager_out_of_world:GetBonusNightVision() return -10000 end

function modifier_illusion_manager_out_of_world:OnCreated(params)
	if not IsServer() then return end	
	local poof = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( poof, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,100) )
	ParticleManager:ReleaseParticleIndex(poof)
	EmitSoundOn('General.Illusion.Destroy',self:GetParent()) 
	self:GetParent():AddNoDraw()																																		 -- our illusion is 'dead' here
	IllusionManager:WipeIllusion(self:GetParent())		
	self.special_modifier = params.special_modifier
	self.illusiontimer = self:GetParent():FindModifierByName('modifier_illusion')
	if self.special_modifier then
		self.illusiontimer = self:GetParent():FindModifierByName(self.special_modifier)
	end
	self:StartIntervalThink(.1)
end

function modifier_illusion_manager_out_of_world:OnIntervalThink()
	if not IsServer() then return end	
	self:GetParent():SetAbsOrigin(self:GetParent():GetOwner():GetAbsOrigin())  	 -- this prevents the weird 'teleport' effect from doing setabsorigin.  I could also add a frame delay to the absorigin set but i'm lazy
	self.illusiontimer:SetDuration(1,true)	 -- constantly watch modifier_illusion and just keep the duration running
end

function modifier_illusion_manager_out_of_world:OnDestroy()
	if not IsServer() then return end	
	self:GetParent():RemoveNoDraw()																																   -- place our little guy back into the world
end

function IllusionManager:CreateIllusion(tEntity,tSkill,vSpawnLocation,tIllusionBase,tSpecialKeys,hAttackTarget)
	if not IsServer() then return end
	if not tIllusionBase then print('No unit specified!'); return end
	local illusion_name = tIllusionBase:GetUnitName()
	if not tEntity.illusions then tEntity.illusions = {} end 		 																		 -- create a table that will hold all of our named illusions by key on the original caster
	for k,v in ipairs(tEntity.illusions) do 										 																		 -- iterate through requested illus with the required commands
		if v.illusionname == illusion_name and not v:IsNull() then 																		 -- illusion is inactive, usable and not deleted by engine
			if tSpecialKeys.unique then															 																		 -- our illusion is 'unique', meaning only one of this kind can exist
				if tSpecialKeys.unique == v.unique then																										 -- if our found illusion matches the key..
					IllusionManager:KillIllusion(v)																													 -- poof him !
					IllusionManager:MoveExistingIllusion(tEntity,tIllusionBase,tSkill,vSpawnLocation,v,tSpecialKeys,hAttackTarget) -- create him where requested
					return																																									 -- return execution to wherever this was requested from
				end
			elseif v.unique then
				-- don't touch unique illusions, because they could conflict with non-unique ones
				-- example is Spectre's Haunt illusions that don't use unique keys, but they have their own special modifiers
				-- and Manta having unique illusions fucks it all up
			elseif v.active == 0 then																																		 -- 'dumbfire' illusion, we can have many many types of this illu
				IllusionManager:MoveExistingIllusion(tEntity,tIllusionBase,tSkill,vSpawnLocation,v,tSpecialKeys,hAttackTarget)	 -- provided we have a created entity, move him and do expected routines
				return
			end
		end
	end
	local illucallback = function(tIllusion) 																	 -- xxxxxxxxxxxxxxxxxxxxxxxxxx
		IllusionManager:IllusionCallback(tEntity,tIllusion,tSkill,tSpecialKeys,tIllusionBase,hAttackTarget)  -- callback for async request
		if tSpecialKeys.callback then																						 --
			if tSpecialKeys.callback_table and type(tSpecialKeys.callback_table) == "table" then
				tSpecialKeys:callback(tIllusion, tSpecialKeys.callback_table)
			else
				tSpecialKeys:callback(tIllusion)																			 -- (callbackception)
			end
		end																																		 -- 
		return tIllusion -- this will returns execution with a 'completed' unit, should be ready to receive commands now
	end																																				 -- xxxxxxxxxxxxxxxxxxxxxxxxxx
	local illusion = CreateUnitByNameAsync(illusion_name, vSpawnLocation, true, tEntity, nil, tEntity:GetTeamNumber(),illucallback) -- Use an async operation to allow the game to perform other ops while we're waiting for this
	-- TODO: Seems obvious, no?
--	for int, unit in pairs(HeroSelection.heroes_custom) do
--		if unit == illusion_name then
--			CustomHeroAttachments(illusion_name)
--		end
--	end
	-- We are still requesting illusions but no available ones exist! do the really shitty createbyname func to lag the fuck out of everyone for no reason!
end	

function IllusionManager:MoveExistingIllusion(tEntity,tIllusionBase,tSkill,vSpawnLocation,tFoundIllusion,tSpecialKeys,hAttackTarget)
	if not IsServer() then return end	
	local tEntityAngles = tEntity:GetAngles()
	tFoundIllusion:SetAbsOrigin(vSpawnLocation)
	tFoundIllusion:Stop()
	local tIllusionHealth = tEntity:GetHealth()
	if tIllusionHealth <= 1 then
		tIllusionHealth = 1
	end
	tFoundIllusion:SetHealth(tIllusionHealth)
	tFoundIllusion:SetMana(tEntity:GetMana())
	tFoundIllusion:SetAngles(tEntityAngles.x, tEntityAngles.y, tEntityAngles.z)
	tFoundIllusion:RemoveModifierByName('modifier_illusion_manager_out_of_world')
	IllusionManager:ResetIllusion(tIllusionBase,tFoundIllusion)
	if hAttackTarget and ( not hAttackTarget:IsNull() ) and hAttackTarget:IsAlive() then
		if tSpecialKeys.force_attack and tSpecialKeys.force_attack == 1 then
			tFoundIllusion:SetForceAttackTarget(hAttackTarget)
		else
			tFoundIllusion:MoveToTargetToAttack(hAttackTarget)
		end
	end
	IllusionManager:SetModifiers(tEntity,tIllusionBase,tFoundIllusion,tSkill,tSpecialKeys)
	tFoundIllusion.active = 1
	if tSpecialKeys.callback then
		if tSpecialKeys.callback_table and type(tSpecialKeys.callback_table) == "table" then
			tSpecialKeys:callback(tFoundIllusion, tSpecialKeys.callback_table)
		else
			tSpecialKeys:callback(tFoundIllusion)
		end
	end
end

function IllusionManager:KillIllusion(tEntity,sName) -- when an illusion is KILLED or DURATION ran out
--	if not IsServer() then return end	
	if tEntity.active == 0 then return end
	local poof = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_killed.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( poof, 0, tEntity:GetAbsOrigin()+Vector(0,0,100) )
	ParticleManager:ReleaseParticleIndex(poof)
	EmitSoundOn('General.Illusion.Destroy',tEntity)
	tEntity:AddNewModifier(tEntity, nil, "modifier_illusion_manager_out_of_world",{}) -- make them disappear until required...
	tEntity.active = 0 -- for our main iterator when we request illus
end

function IllusionManager:ResetIllusion(tEntity,tIllusion)  -- Wipe AND re-add skills/items etc
	if not IsServer() then return end	
	IllusionManager:WipeIllusion(tIllusion)
	--start at baseline, we have no ability points... add and skill up requisite skills.
	for ability_slot = 0, 15 do
		local ability = tEntity:GetAbilityByIndex(ability_slot)
		if ability then
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			local illusionAbility = tIllusion:FindAbilityByName(abilityName)
--			print("WTFFF")
			if illusionAbility then 
				illusionAbility:SetLevel(abilityLevel) 
			else
				if abilityName == "imba_sniper_headshot" then -- For reasons i could've find yet, this ability causes server to crash on an illusion
					print("Found sniper's headshot! ignoring..")
				else
					local newability = tIllusion:AddAbility(abilityName)
					newability:SetLevel(abilityLevel)
				end
			end
		end
	end
	if tIllusion:IsCreep() then return end	
	local illusion_level = tIllusion:GetLevel()
	local entity_level 	 = tEntity:GetLevel()
	local leveldifference = entity_level-illusion_level
	for i=1,leveldifference do
		tIllusion:HeroLevelUp(false)
	end	
	tIllusion:SetAbilityPoints(0)
	--Recreate the caster's items for the illusion.
	for item_slot = 0, 8 do
		local individual_item = tEntity:GetItemInSlot(item_slot)
		if individual_item then
			local illusion_duplicate_item = CreateItem(individual_item:GetName(), tIllusion, tIllusion)
			local illusion_individual_item = tIllusion:AddItem(illusion_duplicate_item)
			if individual_item.activestate then
				illusion_individual_item:SetActiveState(individual_item.activestate)
			end
		end
	end
--	print("Illusion bounty:", illusion_level*2)
--	tIllusion:SetMinimumGoldBounty(illusion_level*2)
--	tIllusion:SetMaximumGoldBounty(illusion_level*2)
--	tIllusion:SetDeathXP(illusion_level*2)
end

function IllusionManager:WipeIllusion(tIllusion)  -- Wipe illusion of any notable characteristics (skills, items, etc)
	if not IsServer() then return end
	for ability_slot = 0, 15 do
		local wipe_ability_index = tIllusion:GetAbilityByIndex(ability_slot)
		if wipe_ability_index then
			local abilityName = wipe_ability_index:GetAbilityName()
			tIllusion:RemoveAbility(abilityName)
		end
	end
	if tIllusion:IsCreep() then return end	
	for item_slot = 0, 8 do	
		local wipe_item_index = tIllusion:GetItemInSlot(item_slot)
		if wipe_item_index then
--			UTIL_Remove(wipe_item_index)
			tIllusion:RemoveItem(wipe_item_index)
		end		
	end
end

function IllusionManager:SetModifiers(tEntity,tIllusionBase,tIllusion,tSkill,tSpecialKeys) -- damage percents, durations... etc
	local duration,damagein,damageout
	if tSkill and not ( type(tSkill) == 'string' ) then
		duration,damagein,damageout = getkvValues(tSkill,"duration","damage_in","damage_out")
	elseif tSkill == 'dummy' then
		duration,damagein,damageout = FrameTime(),1000,-100
	else
		duration,damagein,damageout = 20,300,-80 -- just set a default so that we're not sending nil, these illusions are pretty bad but it least it's doing 'something'
	end	
	if tSpecialKeys.duration  then duration  = tSpecialKeys.duration  end
	if tSpecialKeys.damagein  then damagein  = tSpecialKeys.damagein  end
	if tSpecialKeys.damageout then damageout = tSpecialKeys.damageout end	
	-- Give them all base abilities
	if not tIllusion:IsCreep() then
		tIllusion:SetPlayerID(tEntity:GetPlayerID())
	end
	if tSpecialKeys.controllable and tSpecialKeys.controllable == 0 then
	else
		tIllusion:SetControllableByPlayer(tEntity:GetPlayerID(),true)
	end
	tIllusion:SetOwner(tEntity)
	IllusionManager:ResetIllusion(tIllusionBase,tIllusion)
	if tSpecialKeys.modifier_illusion_name then
		-- do we have a 'special' modifier request for illus?
		if tIllusion:HasModifier(tSpecialKeys.modifier_illusion_name) then
			tIllusion:FindModifierByName(tSpecialKeys.modifier_illusion_name):SetDuration(duration+FrameTime(),true)
		else
			tIllusion:AddNewModifier(tEntity, nil, tSpecialKeys.modifier_illusion_name, {duration = duration+FrameTime(),DestroyOnExpire = false}) -- blue color and duration ticker for team ONLY
		end
	else
		-- apply reg illusion modifier if no special request present
		if tIllusion:HasModifier('modifier_illusion') then
			tIllusion:FindModifierByName('modifier_illusion'):SetDuration(duration+FrameTime(),true)
		else
			tIllusion:AddNewModifier(tEntity, nil, "modifier_illusion", {duration = duration+FrameTime(),DestroyOnExpire = false}) -- blue color and duration ticker for team ONLY
		end
	end
	-- Any additional modifiers to apply to the illusion IN ADDITION TO "modifier_illusion" (or special replacement above)
	-- Duration is the same as the illusion duration - could be something to expand upon, making the durations independent, if desired
	if tSpecialKeys.additional_modifiers and type(tSpecialKeys.additional_modifiers) == "table" then
		local additional_modifiers = tSpecialKeys.additional_modifiers
		for index, modifier in ipairs(additional_modifiers) do
			if tIllusion:HasModifier(modifier) then
				tIllusion:FindModifierByName(modifier):SetDuration(duration+FrameTime(), true)
			else
				tIllusion:AddNewModifier(tEntity, tSkill, modifier, {duration = duration+FrameTime(),DestroyOnExpire = false})
			end
		end
	end
	if not tIllusion:IsIllusion() then tIllusion:MakeIllusion() end -- no bounty for you
	tIllusion:AddNewModifier(tEntity, nil, "modifier_illusion_manager", {duration=duration,special_modifier = tSpecialKeys.modifier_illusion_name,damagein=damagein,damageout=damageout})
end

function IllusionManager:RemoveIllusion(tEntity,sName)  -- DELETE entity from the game
	if not IsServer() then return end	
	UTIL_Remove(tEntity) -- There really is no need for this unless maybe a player dc's and for some reason out of world illusions are causing lag.
end

function IllusionManager:IllusionCallback(tEntity,tIllusion,tSkill,tSpecialKeys,tIllusionBase,hAttackTarget) -- Only called when a new entity needs to be produced
	if not IsServer() then return end	
	if not tIllusion:IsCreep() then
		tIllusion:SetPlayerID(tEntity:GetPlayerID())
	end
	tIllusion:SetControllableByPlayer(tEntity:GetPlayerID(),true)
	tIllusion:SetOwner(tEntity)	
	IllusionManager:ResetIllusion(tIllusionBase,tIllusion)
	if hAttackTarget and ( not hAttackTarget:IsNull() ) and hAttackTarget:IsAlive() then
		if tSpecialKeys.force_attack and tSpecialKeys.force_attack == 1 then
			tIllusion:SetForceAttackTarget(hAttackTarget)
		else
			tIllusion:MoveToTargetToAttack(hAttackTarget)
		end
	end
	IllusionManager:SetModifiers(tEntity,tIllusionBase,tIllusion,tSkill,tSpecialKeys)
	tIllusion.active = 1	
	if tSpecialKeys.unique then
		tIllusion.unique = tSpecialKeys.unique
	end
	tIllusion.illusionname = tIllusionBase:GetUnitName()
	table.insert(tEntity.illusions,tIllusion)
	return
end
