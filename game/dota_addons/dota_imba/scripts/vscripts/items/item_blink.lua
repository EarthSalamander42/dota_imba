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
	return DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end

function item_imba_blink:GetIntrinsicModifierName()
	return "modifier_imba_blink_dagger_handler" end

function item_imba_blink:OnSpellStart()
	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	
	local target_point
	if self:GetCursorTargetingNothing() then
		target_point = self:GetCursorPosition()
	else
		local target = self:GetCursorTarget()
		
		if target == caster then
			if self.teamFountain == nil then	-- nil = fountain wasn't searched for
			
				-- Find a fountain entity
				local fountain = Entities:FindByClassname(nil, "ent_dota_fountain")
				
				-- Set fountain to false in case the while loop doesn't start
				self.teamFountain = false
				
				-- If a fountain is found...
				while fountain do
				
					-- Check if that fountain is on the casters team
					if fountain:GetTeamNumber() == caster:GetTeamNumber() then
					
						-- Index it inside the ability and end loop
						self.teamFountain = fountain
						break
					else
						
						-- Find next fountain. If no fountain was found, end loop
						fountain = Entities:FindByClassname(fountain, "ent_dota_fountain")
						if not fountain then break end
					end
				end
				
				target_point = self.teamFountain:GetAbsOrigin()
				
			elseif self.teamFountain then		-- If previous check didn't pass, should be true
				target_point = self.teamFountain:GetAbsOrigin()
				
			else								-- self.teamFountain should be false
                self:EndCooldown()
                self:RefundManaCost()
				return
			end
		elseif target then
			target_point = target:GetAbsOrigin()
		else
			target_point = self:GetCursorPosition()
		end
	end
	
	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")
	
	local blink_effect = "particles/item/blink/blink_dagger_start_imba.vpcf"
	local blink_effect_end = "particles/item/blink/blink_dagger_imbaend.vpcf"
	
	-- Disjointing everything
	ProjectileManager:ProjectileDodge(caster)
	
	-- Defining the color, either default or by command
	local color
	if caster.blinkcolor then
		color = caster.blinkcolor
	else
		color = Vector(0, 20, 255) -- Blueish, just a little brighter
	end
	
	-- Creating the particle & sound at the start-location
	local blink_pfx = ParticleManager:CreateParticle(blink_effect, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(blink_pfx, 15, color)
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
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * caster:GetCooldownReduction())
			end)

		-- Calculate cooldown increase if between the two extremes
		else
			local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction * caster:GetCooldownReduction())
			end)
		end
	end
	
	-- Adding an extremely small timer for the particles, else they will only appear at the dest
	Timers:CreateTimer(0.01, function()
		caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(caster, target_point, true)
		
		-- Create Particle on end-point
		local blink_end_pfx = ParticleManager:CreateParticle(blink_effect_end, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(blink_end_pfx, 15, color )
		ParticleManager:ReleaseParticleIndex(blink_end_pfx)
	end)
end

function item_imba_blink:GetAbilityTextureName()
	if IsClient() then
		local caster = self:GetCaster()
		if not caster:IsHero() then return "custom/imba_blink" end
		
		local carrier_name = caster:GetName()
		local uniqueBlink = {
			npc_dota_hero_antimage		= "antimage",
			npc_dota_hero_bristleback	= "bristleback",
			npc_dota_hero_brewmaster	= "brewmaster",
			npc_dota_hero_chen			= "chen",
			npc_dota_hero_clinkz		= "clinkz",
			npc_dota_hero_doom_bringer	= "doom",
			npc_dota_hero_invoker		= "invoker",
			npc_dota_hero_jakiro		= "jakiro",
			npc_dota_hero_leshrac		= "leshrac",
			npc_dota_hero_lycan			= "lycan",
			npc_dota_hero_meepo			= "meepo",
			npc_dota_hero_naga_siren	= "naga",
			npc_dota_hero_nyx_assassin	= "nyx",
			npc_dota_hero_silencer		= "silencer"
		}
		
		if uniqueBlink[carrier_name] then
			return "custom/imba_blink_"..uniqueBlink[carrier_name]
		end
		
		return "custom/imba_blink"
	end
end

-----------------------------------------------------------------------------------------------------------
--	Blink Dagger Handler 
-----------------------------------------------------------------------------------------------------------
if modifier_imba_blink_dagger_handler == nil then modifier_imba_blink_dagger_handler = class({}) end
function modifier_imba_blink_dagger_handler:IsHidden() return true end
function modifier_imba_blink_dagger_handler:IsDebuff() return false end
function modifier_imba_blink_dagger_handler:IsPurgable() return false end
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
end

function modifier_imba_blink_dagger_handler:DeclareFunctions()
	local funcs = {	MODIFIER_EVENT_ON_TAKEDAMAGE,}
	return funcs
end

function modifier_imba_blink_dagger_handler:OnTakeDamage( keys )
	local ability = self:GetAbility()
	local blink_damage_cooldown = ability:GetSpecialValueFor("blink_damage_cooldown")
	
	local parent = self:GetParent()					-- Modifier carrier
	local attacker_name = keys.attacker:GetName()	-- Name of the attacker
	local unit = keys.unit							-- Who took damage
	local damage = keys.damage						-- Damage taken
	
	if parent == unit and damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) and ( keys.attacker:GetTeam() ~= parent:GetTeam() ) then
		if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
			ability:StartCooldown(blink_damage_cooldown)
		end
	end
end

-----------------------------------------------------------------------------------------------------------
--	Blink Boots definition
-----------------------------------------------------------------------------------------------------------
if item_imba_blink_boots == nil then item_imba_blink_boots = class({}) end
LinkLuaModifier( "modifier_imba_blink_boots_handler", "items/item_blink.lua", LUA_MODIFIER_MOTION_NONE ) -- Check if the target was damaged and set cooldown + item bonuses

function item_imba_blink_boots:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING end
	
function item_imba_blink_boots:GetIntrinsicModifierName()
	return "modifier_imba_blink_boots_handler" end

function item_imba_blink_boots:OnSpellStart()
	local caster = self:GetCaster()
	local origin_point = caster:GetAbsOrigin()
	
	local target_point
	if self:GetCursorTargetingNothing() then
		target_point = self:GetCursorPosition()
		print("a")
	else
		local target = self:GetCursorTarget()
		
		if target == caster then
			if self.teamFountain == nil then	-- nil = fountain wasn't searched for
			
				-- Find a fountain entity
				local fountain = Entities:FindByClassname(nil, "ent_dota_fountain")
				
				-- Set fountain to false in case the while loop doesn't start
				self.teamFountain = false
				
				-- If a fountain is found...
				while fountain do
				
					-- Check if that fountain is on the casters team
					if fountain:GetTeamNumber() == caster:GetTeamNumber() then
					
						-- Index it inside the ability and end loop
						self.teamFountain = fountain
						break
					else
						
						-- Find next fountain. If no fountain was found, end loop
						fountain = Entities:FindByClassname(fountain, "ent_dota_fountain")
						if not fountain then break end
					end
				end
				
				target_point = self.teamFountain:GetAbsOrigin()
				
			elseif self.teamFountain then		-- If previous check didn't pass, should be true
				target_point = self.teamFountain:GetAbsOrigin()
				
			else								-- self.teamFountain should be false
                self:EndCooldown()
                self:RefundManaCost()
				return
			end
		elseif target then
			target_point = target:GetAbsOrigin()
		else
			target_point = self:GetCursorPosition()
		end
	end
	
	local distance = (target_point - origin_point):Length2D()
	local max_blink_range = self:GetSpecialValueFor("max_blink_range")
	
	local blink_effect = "particles/item/blink/blink_dagger_start_imba.vpcf"
	local blink_effect_end = "particles/item/blink/blink_dagger_imbaend.vpcf"
	
	-- Disjointing everything
	ProjectileManager:ProjectileDodge(caster)
	
	-- Defining the color, either default or by command
	local color
	if caster.blinkcolor then
		color = caster.blinkcolor
	else
		color = Vector(0, 20, 255) -- Blueish, just a little brighter
	end
	
	-- Creating the particle & sound at the start-location
	local blink_pfx = ParticleManager:CreateParticle(blink_effect, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(blink_pfx, 15, color)
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
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * caster:GetCooldownReduction())
			end)

		-- Calculate cooldown increase if between the two extremes
		else
			local extra_fraction = (distance - max_blink_range) / (max_extra_distance - max_blink_range)
			Timers:CreateTimer(0.03, function()
				self:StartCooldown(self:GetCooldownTimeRemaining() + max_extra_cooldown * extra_fraction * caster:GetCooldownReduction())
			end)
		end
	end
	
	-- Adding an extremely small timer for the particles, else they will only appear at the dest
	Timers:CreateTimer(0.01, function()
		caster:SetAbsOrigin(target_point)
		FindClearSpaceForUnit(caster, target_point, true)
		
		-- Create Particle on end-point
		local blink_end_pfx = ParticleManager:CreateParticle(blink_effect_end, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(blink_end_pfx, 15, color )
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
	local attacker_name = keys.attacker:GetName()	-- Name of the attacker
	local unit = keys.unit							-- Who took damage
	local damage = keys.damage						-- Damage taken
	
	if parent == unit and damage > 0 and (attacker_name == "npc_dota_roshan" or keys.attacker:IsControllableByAnyPlayer()) and ( keys.attacker:GetTeam() ~= parent:GetTeam() ) then
		if ability:GetCooldownTimeRemaining() < blink_damage_cooldown then
			ability:StartCooldown(blink_damage_cooldown)
		end
	end
end