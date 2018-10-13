-- Created by AltiV (August 15th, 2018)

-- Original Release "Issues"
-- 1. Does not take inspiration from trees. Attempting to get any of their models crashes the client.
-- 2. Retains particle effects from original hero. The vanilla Mischief skill does this as well, but
-- it allows for less "strategic" usage of the mutation here because everyone has a persisting Frantic
-- particle effect, and some of the custom heroes have a vibrant colour particle that carries over.
-- 3. Roshan pit drops are not based on amount of Roshan kills. This is minor and chosen to be ignored.

------------------------------------------
-- Local Variables Outside of Functions --
------------------------------------------

-- Base list of things to transform into
local model_list = {
	-- Couriers
	"models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
	"models/items/courier/faceless_rex/faceless_rex_flying.vmdl",
	"models/items/courier/hermit_crab/lotus_orb.vmdl",
	"models/items/courier/kanyu_shark/kanyu_shark.vmdl",
	"models/items/courier/mole_messenger/mole_messenger_lvl7.vmdl",
	
	-- Treasure Chests
	"models/props_gameplay/treasure_chest001.vmdl",
	"models/props_generic/chest_treasure_02.vmdl",
	"models/props_gameplay/treasure_chest_gold.vmdl",
	
	-- Wards
	"models/items/wards/esl_wardchest_woody/esl_wardchest_woody.vmdl",
	"models/items/wards/f2p_ward/f2p_ward.vmdl",
	"models/items/wards/fairy_dragon/fairy_dragon.vmdl",
	"models/items/wards/phoenix_ward/phoenix_ward.vmdl",
	"models/items/wards/portal_ward/portal_ward.vmdl",
	
	-- "Standard" items
	"models/props_gameplay/chicken.vmdl",
	"models/props_gameplay/crown001.vmdl",
	"models/props_gameplay/gem01.vmdl",
	"models/props_gameplay/heart001.vmdl",
	"models/props_gameplay/mango.vmdl",
	"models/props_gameplay/red_box.vmdl",
	"models/props_gameplay/salve_blue.vmdl",
	"models/props_gameplay/salve_red.vmdl",
	"models/props_gameplay/smoke.vmdl",
	"models/props_gameplay/tombstonea01.vmdl",
	
	-- Rapiers
	"models/props_gameplay/divine_rapier.vmdl",
	"models/cursed_rapier.vmdl",
}

-- Powerup Runes (Includes cooresponding particle effects)
local rune_list = {
	{"models/props_gameplay/rune_arcane.vmdl", "particles/generic_gameplay/rune_arcane.vpcf"},
	{"models/props_gameplay/rune_doubledamage01.vmdl", "particles/generic_gameplay/rune_doubledamage.vpcf"},
	{"models/props_gameplay/rune_frost.vmdl", "particles/econ/items/puck/puck_snowflake/puck_snowflake_ambient.vpcf"},
	{"models/props_gameplay/rune_haste01.vmdl", "particles/generic_gameplay/rune_haste.vpcf"},
	{"models/props_gameplay/rune_illusion01.vmdl", "particles/generic_gameplay/rune_invisibility.vpcf"},
	{"models/props_gameplay/rune_invisibility01.vmdl", "particles/generic_gameplay/rune_invisibility.vpcf"},
	{"models/props_gameplay/pumpkin_rune.vmdl", ""},
	{"models/props_gameplay/rune_regeneration01.vmdl", "particles/generic_gameplay/rune_regeneration.vpcf"}
}

-- Roshan Pit Items
local rosh_list = {
	"models/rosh/roshan_halloween.vmdl",
	"models/props_gameplay/aegis.vmdl",
	"models/props_gameplay/cheese.vmdl",
	"models/props_gameplay/refresher_shard.vmdl"
}

-- Don't know if I can just pull these positions from the runes.lua file but I'll throw them here for now...
local rune_spots = {
	Vector(-1712, 1184, 176),
	Vector(2394.590576, -1857.834473, 192)
}

local bounty_spots = {
	Vector(-4328.077637, 1591.967407, 432),
	Vector(4263.922363, -1704.032593, 436),
	Vector(3686.955078, -3624.810791, 304),
	Vector(-3149.034180, 3725.841309, 304)
}

 -- Not actually accurate spot but close enough
local rosh_pit = Vector(-2382, 1850, 176)

local selection = "models/props_gameplay/treasure_chest001.vmdl"	-- Putting a default model to maybe prevent some potential crashes
local zHeight	= 0													-- Visual height of model; should only need to be non-zero for runes

------------------------
-- Initialize Classes --
------------------------

LinkLuaModifier("modifier_mutation_mischief_transform", "components/modifiers/mutation/modifier_mutation_mischief.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_mutation_mischief_transform_extra", "components/modifiers/mutation/modifier_mutation_mischief.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_mischief 					= class({})
modifier_mutation_mischief_transform 		= class({})
modifier_mutation_mischief_transform_extra	= class({})

-----------------------------------------------------------
-- Main Mischief Modifier (Internal Timer for Transform) --
-----------------------------------------------------------

function modifier_mutation_mischief:IsHidden() 		return false end
function modifier_mutation_mischief:RemoveOnDeath() return false end
function modifier_mutation_mischief:IsPurgable() 	return false end

function modifier_mutation_mischief:GetTexture()	return "monkey_king_untransform" end

function modifier_mutation_mischief:OnCreated()
	if not IsServer() then return end
	self.initial_delay 	= 15	-- Delay time until the modifier activates
	self.internal_timer = 0 	-- Initialize internal timer
	self.tick_rate 		= 0.1	-- Set tick rate for timer
	self.transform_time = 2.5	-- Amount of time to wait (in seconds) before transforming
	
	Timers:CreateTimer(self.initial_delay, function()
		self:StartIntervalThink(self.tick_rate)
	end)
end

function modifier_mutation_mischief:OnIntervalThink()
	-- Don't tick down if unit already has the transform modifier or standard Mischief
	if not self:GetParent():HasModifier("modifier_mutation_mischief_transform") and not self:GetParent():HasModifier("modifier_monkey_king_transform") then
		if not self:GetParent():IsMoving() then
			self.internal_timer = self.internal_timer + self.tick_rate
		else
			self.internal_timer = 0
		end
		
		if self.internal_timer >= self.transform_time then
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_mischief_transform", {})
			Timers:CreateTimer(FrameTime(), function()
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_mischief_transform_extra", {})
			end)
			self.internal_timer = 0
		end
	end
end

-- Break Mischief if unit starts an attack, takes damage, or casts an ability
function modifier_mutation_mischief:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

-- Separate helper function that resets internal timer and removes the transform modifiers if they exist
function modifier_mutation_mischief:Exposed()
	self.internal_timer = 0
	if self:GetParent():HasModifier("modifier_mutation_mischief_transform") then
		self:GetParent():RemoveModifierByName("modifier_mutation_mischief_transform")
		self:GetParent():RemoveModifierByName("modifier_mutation_mischief_transform_extra")
	end
end

function modifier_mutation_mischief:OnAttackStart( keys )
	if keys.attacker == self:GetParent() then
		self:Exposed()
	end
end

function modifier_mutation_mischief:OnTakeDamage( keys )	
	if keys.unit == self:GetParent() or keys.attacker == self:GetParent() then
		self:Exposed()
	end
end

function modifier_mutation_mischief:OnAbilityFullyCast( keys )
	if keys.unit == self:GetParent() then
		self:Exposed()
	end
end

--------------------------
-- Transformed Modifier --
--------------------------

-- start step by step
-- create a hidden dummy unit that follows the hero position, make a condition if abs origin not same, set it up
-- dummy_unit:AddEffects(EF_NODRAW) to hide
-- RemoveEffects(EF_NODRAW) to hide
-- with those informations you should be able to start a base

-- Yeah IDK

function modifier_mutation_mischief_transform:IsHidden()	return false end
function modifier_mutation_mischief_transform:IsPurgable()	return true end

function modifier_mutation_mischief_transform:GetEffectName()
	return "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf"
end

function modifier_mutation_mischief_transform:GetTexture()
	return "monkey_king_mischief"
end

function modifier_mutation_mischief_transform:CheckState()
	local state = {
	[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR]				= true,
	[MODIFIER_STATE_LOW_ATTACK_PRIORITY] 		= true	}
	
	return state
end

function modifier_mutation_mischief_transform:OnCreated()
	if not IsServer() then return end

	self.search_range 	= 350 	-- Maximum range from places of interest to take inspiration
	self.particle		= ""	-- Give extra particle effect around model if it originally has one
	self.model_found 	= false -- Use this to keep track of when a model has been settled on
	
	-- Was supposed to search for tree models but I can't get this block to work so skipping it
	-- local trees = GridNav:GetAllTreesAroundPoint(self:GetParent():GetAbsOrigin(), self.search_range, false)
	-- if #trees > 0 then
		-- for _, tree in pairs(trees) do
			 -- selection = tree:GetModelName() -- Crashes the game
			 -- self.model_found = true
			 -- break
		-- end
	-- end
	
	-- Next, check if unit is near a bounty rune spot
	if not self.model_found then
		for _, pos in pairs(bounty_spots) do
			if (self:GetParent():GetAbsOrigin() - pos):Length() <= self.search_range then
				selection = "models/props_gameplay/rune_goldxp.vmdl"
				self.particle = "particles/generic_gameplay/rune_bounty_first.vpcf"
				zHeight = 50
				self.model_found = true -- Do not need to check the rest of the test cases
				break
			end
		end
	end
	
	-- Next, check if unit is near a powerup rune spot
	if not self.model_found then
		local rand = RandomInt(1, #rune_list)
		for _, pos in pairs(rune_spots) do
			if (self:GetParent():GetAbsOrigin() - pos):Length() <= self.search_range then
				selection = rune_list[rand][1]
				self.particle = rune_list[rand][2]
				zHeight = 50
				self.model_found = true -- Do not need to check the rest of the test cases
				break
			end
		end
	end
	
	-- Next, check if unit is near the center of the Rosh pit
	if not self.model_found then
		local rand = RandomInt(1, #rosh_list)
		if (self:GetParent():GetAbsOrigin() - rosh_pit):Length() <= self.search_range then
			selection = rosh_list[rand]
			self.model_found = true -- Do not need to check the rest of the test cases
		end
	end
	
	-- Next, check if unit is near any other creep
	if not self.model_found then
		local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(),
		self:GetParent():GetAbsOrigin(),
		nil,
		self.search_range,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_TREE, -- Don't think this tree thing works...
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
		if (#units > 0) then
			for _, unit in pairs(units) do
				selection = unit:GetModelName()
				self.model_found = true -- Do not need to check the rest of the test cases
				break
			end
		end
	end
		
	-- If all of the above criteria is not met, choose from the base list of available models
	if not self.model_found then
		selection = model_list[RandomInt(1, #model_list)]
		-- Cursed Rapier has a special particle effect
		if selection == "models/cursed_rapier.vmdl" then
			particle = "particles/hw_fx/cursed_rapier.vpcf"
		end
	end
	
	EmitSoundOn("Hero_MonkeyKing.Transform.On", self:GetParent()) -- Sounds not working even with Precache?
end

function modifier_mutation_mischief_transform:OnRemoved()
	if not IsServer() then return end
	EmitSoundOn("Hero_MonkeyKing.Transform.Off", self:GetParent())
	
	-- Reset particle name and height back to default
	self.particle	= ""
	zHeight			= 0
	
	-- Play the Mischief particle effect again
	local poof = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(poof, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(poof)
end

function modifier_mutation_mischief_transform:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE
	}

	return funcs
end

function modifier_mutation_mischief_transform:GetModifierModelChange()
	return selection
end

---------------------------------------
-- Transformed Modifier (Extra Data) --
---------------------------------------

function modifier_mutation_mischief_transform_extra:IsHidden()		return true end
function modifier_mutation_mischief_transform_extra:IsPurgable()	return true end

function modifier_mutation_mischief_transform_extra:OnCreated()
	if not IsServer() then return end
	self:SetStackCount(zHeight)
	self.particle = ParticleManager:CreateParticle(self:GetParent():FindModifierByName("modifier_mutation_mischief_transform").particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_mutation_mischief_transform_extra:OnDestroy()
	if not IsServer() then return end
	ParticleManager:DestroyParticle(self.particle, true)
end

function modifier_mutation_mischief_transform_extra:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}

	return funcs
end	

function modifier_mutation_mischief_transform_extra:GetVisualZDelta()
	return self:GetStackCount()
end
