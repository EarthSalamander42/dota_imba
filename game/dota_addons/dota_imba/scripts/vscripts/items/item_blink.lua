--	Author: AtroCty
--	Date: 			15.09.2016	
--	Last Update:	03.03.2017
--	Converted to Lua by zimberzimber

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger definition
-----------------------------------------------------------------------------------------------------------
if item_imba_blink == nil then item_imba_blink = class({}) end
LinkLuaModifier( "modifier_imba_blink_dagger_handler", "items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown

function item_imba_blink:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function item_imba_blink:GetIntrinsicModifierName()
	return "modifier_imba_blink_dagger_handler"
end

function item_imba_blink:OnSpellStart()
	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()	
	local target_point = self:GetCursorPosition()		
	
	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")

	-- Disjointing everything
	ProjectileManager:ProjectileDodge(caster)

	-- Creating the particle & sound at the start-location
	local blink_pfx = ParticleManager:CreateParticle(caster.blink_effect, PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(blink_pfx)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")
	
	-- Set distance if targeted destiny is beyond range
	if distance > max_blink_range then
		-- Extra parameters
		local max_extra_distance = self:GetSpecialValueFor("max_extra_distance")
		local max_extra_cooldown = self:GetSpecialValueFor("max_extra_cooldown")

		-- Calculate total overshoot distance
		if distance > max_extra_distance then
			target_point = origin_point + (target_point - origin_point):Normalized() * max_extra_distance
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * (1 - caster:GetCooldownReduction() * 0.01))
			end)

		-- Calculate cooldown increase if between the two extremes
		else
			local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction * (1 - caster:GetCooldownReduction() * 0.01))
			end)
		end
	end
	
	-- Adding an extremely small timer for the particles, else they will only appear at the dest
	Timers:CreateTimer(0.01, function()
		caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(caster, target_point, true)
		
		-- Create Particle on end-point
		local blink_end_pfx = ParticleManager:CreateParticle(caster.blink_effect_end, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_end_pfx)
	end)
end

function item_imba_blink:GetAbilityTextureName()
	if not IsClient() then return end
	local caster = self:GetCaster()
	if not caster.blink_icon_client then return "custom/imba_blink" end
	return "custom/imba_blink"..caster.blink_icon_client
end

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger Handler 
-----------------------------------------------------------------------------------------------------------
if modifier_imba_blink_dagger_handler == nil then modifier_imba_blink_dagger_handler = class({}) end
function modifier_imba_blink_dagger_handler:IsHidden() return true end
function modifier_imba_blink_dagger_handler:IsDebuff() return false end
function modifier_imba_blink_dagger_handler:IsPurgable() return false end
function modifier_imba_blink_dagger_handler:RemoveOnDeath() return false end
function modifier_imba_blink_dagger_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_blink_dagger_handler:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		if caster:IsRealHero() then
		
			local carrier_name = caster:GetName()
			local blinkResponse = {
				npc_dota_hero_antimage		= "antimage_anti_blink_01",
				npc_dota_hero_brewmaster	= "brewmaster_brew_blink_02",
				npc_dota_hero_bristleback	= "bristleback_bristle_blink_02",
				npc_dota_hero_chen			= "chen_chen_blink_02",
				npc_dota_hero_clinkz		= "clinkz_clinkz_blink_02",
				npc_dota_hero_doom_bringer	= "doom_bringer_doom_blink_02",
				npc_dota_hero_invoker		= "invoker_invo_blink_02",
				npc_dota_hero_jakiro		= "jakiro_jak_blink_02",
				npc_dota_hero_leshrac		= "leshrac_lesh_blink_02",
				npc_dota_hero_lycan			= "lycan_lycan_blink_02",
				npc_dota_hero_meepo			= "meepo_meepo_blink_02",
				npc_dota_hero_naga_siren	= "naga_siren_naga_blink_02",
				npc_dota_hero_nyx_assassin	= "nyx_assassin_nyx_blink_02",
				npc_dota_hero_silencer		= "silencer_silen_blink_02",
				npc_dota_hero_bane			= "bane_bane_blink_03",
				npc_dota_hero_skeleton_king	= "skeleton_king_wraith_blink_02"
			}
			
			if blinkResponse[carrier_name] then
				Timers:CreateTimer(0.2, function()	-- So it comes after the "ka-ching"
					EmitAnnouncerSoundForPlayer(blinkResponse[carrier_name], caster:GetPlayerID())
				end)
			end
		end
	end
	self:OnIntervalThink()
	self:StartIntervalThink(1.0)
end

function modifier_imba_blink_dagger_handler:OnIntervalThink()
	local caster = self:GetCaster()
	if caster:IsIllusion() then return end
	if IsServer() then
		self:SetStackCount(caster.blink_icon)
	end
	if IsClient() then
		local icon = self:GetStackCount()
		if icon == 0 then
			caster.blink_icon_client = nil
		else
			caster.blink_icon_client = icon
		end
	end
end

function modifier_imba_blink_dagger_handler:DeclareFunctions()
	local funcs = {	MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_blink_dagger_handler:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")

	local parent = self:GetParent()					-- Modifier carrier
	local unit = keys.unit							-- Who took damage

	if parent == unit then
		-- Custom function from funcs.lua
		if IsHeroDamage(keys.attacker, keys.damage) then
			if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
				ability:StartCooldown(blink_damage_cooldown)
			end
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Blink Boots definition
-----------------------------------------------------------------------------------------------------------
if item_imba_blink_boots == nil then item_imba_blink_boots = class({}) end
LinkLuaModifier( "modifier_imba_blink_boots_handler", "items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown + item bonuses

function item_imba_blink_boots:GetAbilityTextureName()
	return "custom/imba_blink_boots"
end

function item_imba_blink_boots:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES end

function item_imba_blink_boots:GetIntrinsicModifierName()
	return "modifier_imba_blink_boots_handler" end

function item_imba_blink_boots:OnSpellStart()
	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	local target_point = self:GetCursorPosition()

	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")

	-- Disjointing everything
	ProjectileManager:ProjectileDodge(caster)

	-- Creating the particle & sound at the start-location
	local blink_pfx = ParticleManager:CreateParticle(caster.blink_effect, PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(blink_pfx)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	-- Set distance if targeted destiny is beyond range
	if distance > max_blink_range then
		-- Extra parameters
		local max_extra_distance = self:GetSpecialValueFor("max_extra_distance")
		local max_extra_cooldown = self:GetSpecialValueFor("max_extra_cooldown")

		-- Calculate total overshoot distance
		if distance > max_extra_distance then
			target_point = origin_point + (target_point - origin_point):Normalized() * max_extra_distance
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * (1 - caster:GetCooldownReduction() * 0.01))
			end)

			-- Calculate cooldown increase if between the two extremes
		else
			local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction * (1 - caster:GetCooldownReduction() * 0.01))
			end)
		end
	end

	-- Adding an extremely small timer for the particles, else they will only appear at the dest
	Timers:CreateTimer(0.01, function()
		caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(caster, target_point, true)

		-- Create Particle on end-point
		local blink_end_pfx = ParticleManager:CreateParticle(caster.blink_effect_end, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(blink_end_pfx)
	end)
end

-----------------------------------------------------------------------------------------------------------
--	Blink Boots Handler 
-----------------------------------------------------------------------------------------------------------
if modifier_imba_blink_boots_handler == nil then modifier_imba_blink_boots_handler = class({}) end
function modifier_imba_blink_boots_handler:IsHidden() return true end
function modifier_imba_blink_boots_handler:IsDebuff() return false end
function modifier_imba_blink_boots_handler:IsPurgable() return false end
function modifier_imba_blink_boots_handler:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_blink_boots_handler:DeclareFunctions()
	local funcs = {	MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE, }
	return funcs
end

function modifier_imba_blink_boots_handler:GetModifierMoveSpeedBonus_Special_Boots()
	local ability = self:GetAbility()
	local speed_bonus = ability:GetSpecialValueFor("bonus_movement_speed")
	return speed_bonus
end

function modifier_imba_blink_boots_handler:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")

	local parent = self:GetParent()					-- Modifier carrier
	local unit = keys.unit							-- Who took damage

	if parent == unit then
		-- Custom function from funcs.lua
		if IsHeroDamage(keys.attacker, keys.damage) then
			if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
				ability:StartCooldown(blink_damage_cooldown)
			end
		end
	end
end
