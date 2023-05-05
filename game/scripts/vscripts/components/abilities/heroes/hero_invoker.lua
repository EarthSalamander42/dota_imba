-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Editors:
--     naowin, 03.05.2018
--     naowin, 03.08.2019
--     AltiV,  22.12.2019

imba_invoker = imba_invoker or class({})

-------------------------------------------------------------------------------------------------------------------------
--	Setup Base Abilities
-------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------
--	Invoker: QUAS
---------------------------------------------------------------------------------------------------------------------

imba_invoker_quas = class({})

LinkLuaModifier("modifier_imba_invoker_quas", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

function imba_invoker_quas:ProcsMagicStick() return false end

function imba_invoker_quas:OnUpgrade()
	if not IsServer() then return end

	CustomNetTables:SetTableValue("player_table", "quas_level"..tostring(self:GetCaster():GetPlayerOwnerID()), {self:GetLevel()})
end

function imba_invoker_quas:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if math.random(0, 100) >= 50 then
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		else
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		end

		imba_invoker:update_orbs(caster, self, "imba_invoker_quas", "particles/units/heroes/hero_invoker/invoker_quas_orb.vpcf")
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Invoker: Quas Orb modifier
---------------------------------------------------------------------------------------------------------------------

modifier_imba_invoker_quas = modifier_imba_invoker_quas or class({})

function modifier_imba_invoker_quas:IsBuff() 		return true  end
function modifier_imba_invoker_quas:IsHidden() 		return false end
function modifier_imba_invoker_quas:IsDebuff() 		return false end
function modifier_imba_invoker_quas:IsPurgable() 	return false end
function modifier_imba_invoker_quas:RemoveOnDeath() return false end
function modifier_imba_invoker_quas:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end

function modifier_imba_invoker_quas:OnCreated(kv)
	if IsServer() then 
		self.bonus_strength = kv.bonus_strength
		self.health_regen_per_instance = kv.health_regen_per_instance
	else
		local net_table = CustomNetTables:GetTableValue("player_table", "quas"..self:GetParent():GetPlayerOwnerID()) or {}
		self.bonus_strength = net_table.quas_bonus_strength
		self.health_regen_per_instance = net_table.quas_health_regen_per_instance
	end
end

function modifier_imba_invoker_quas:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_imba_invoker_quas:GetModifierConstantHealthRegen() 
	return self.health_regen_per_instance
end

function modifier_imba_invoker_quas:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


---------------------------------------------------------------------------------------------------------------------
--	Invoker: WEX
---------------------------------------------------------------------------------------------------------------------
imba_invoker_wex = class({})
LinkLuaModifier("modifier_imba_invoker_wex", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

function imba_invoker_wex:ProcsMagicStick() return false end

function imba_invoker_wex:OnUpgrade()
	if not IsServer() then return end

	CustomNetTables:SetTableValue("player_table", "wex_level"..tostring(self:GetCaster():GetPlayerOwnerID()), {self:GetLevel()})
end

function imba_invoker_wex:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if math.random(0, 100) >= 50 then
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		else
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		end

		imba_invoker:update_orbs(caster, self, "imba_invoker_wex", "particles/units/heroes/hero_invoker/invoker_wex_orb.vpcf")
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Invoker: Wex Orb modifier
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_wex = modifier_imba_invoker_wex or class({})
function modifier_imba_invoker_wex:IsBuff() 		return true  end
function modifier_imba_invoker_wex:IsHidden() 		return false end
function modifier_imba_invoker_wex:IsDebuff() 		return false end
function modifier_imba_invoker_wex:IsPurgable() 	return false end
function modifier_imba_invoker_wex:RemoveOnDeath()	return false end
function modifier_imba_invoker_wex:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_imba_invoker_wex:OnCreated(kv)
	if IsServer() then 
		self.bonus_agility 				= kv.bonus_agility
		self.move_speed_per_instance 	= kv.move_speed_per_instance
		self.attack_speed_per_instance 	= kv.attack_speed_per_instance
	else
		local net_table 				= CustomNetTables:GetTableValue("player_table", "wex"..self:GetParent():GetPlayerOwnerID()) or {}
		self.bonus_agility 				= net_table.wex_bonus_agility
		self.move_speed_per_instance 	= net_table.wex_move_speed_per_instance
		self.attack_speed_per_instance 	= net_table.wex_attack_speed_per_instance
	end
end

function modifier_imba_invoker_wex:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

-- Movement speed buff is working but dosent show up in hero stats
function modifier_imba_invoker_wex:GetModifierMoveSpeedBonus_Percentage() 
	return self.move_speed_per_instance
end

function modifier_imba_invoker_wex:GetModifierAttackSpeedBonus_Constant() 
	return self.attack_speed_per_instance
end

function modifier_imba_invoker_wex:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end


---------------------------------------------------------------------------------------------------------------------
--	Invoker: EXORT
---------------------------------------------------------------------------------------------------------------------

imba_invoker_exort = class({})

LinkLuaModifier("modifier_imba_invoker_exort", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

function imba_invoker_exort:ProcsMagicStick() return false end

function imba_invoker_exort:OnUpgrade()
	if not IsServer() then return end

	CustomNetTables:SetTableValue("player_table", "exort_level"..tostring(self:GetCaster():GetPlayerOwnerID()), {self:GetLevel()})
end

function imba_invoker_exort:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		if math.random(0, 100) >= 50 then
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		else
			caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		end

		imba_invoker:update_orbs(caster, self, "imba_invoker_exort", "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf")
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Invoker: Exort Orb modifier
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_exort = modifier_imba_invoker_exort or class({})
function modifier_imba_invoker_exort:IsBuff() 			return true  end
function modifier_imba_invoker_exort:IsHidden() 		return false end
function modifier_imba_invoker_exort:IsDebuff() 		return false end
function modifier_imba_invoker_exort:IsPurgable() 		return false end
function modifier_imba_invoker_exort:RemoveOnDeath()	return false end
function modifier_imba_invoker_exort:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}

	return funcs
end

function modifier_imba_invoker_exort:OnCreated(kv)
	if IsServer() then 
		self.bonus_intelligence = kv.bonus_intelligence
		self.bonus_damage_per_instance = kv.bonus_damage_per_instance
	else
		local net_table = CustomNetTables:GetTableValue("player_table", "exort"..self:GetParent():GetPlayerOwnerID()) or {}
		self.bonus_intelligence = net_table.exort_bonus_intelligence
		self.bonus_damage_per_instance = net_table.exort_bonus_damage_per_instance
	end
end

function modifier_imba_invoker_exort:GetModifierBonusStats_Intellect()
	return self.bonus_intelligence
end

function modifier_imba_invoker_exort:GetModifierBaseAttack_BonusDamage() 
	return self.bonus_damage_per_instance
end

function modifier_imba_invoker_exort:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

---------------------------------------------------------------------------------------------------------------------
--	Utility / Help Functions for orb control
---------------------------------------------------------------------------------------------------------------------
function imba_invoker:update_orbs(caster, ability, invoked_orb, particle_path)
	if IsServer() then 
		-- need to make sure we dont mess up orb order
		imba_invoker.orb_sync = false

		-- Instantiate objects
		if caster.invoked_orbs == nil then 
			caster.invoked_orbs = {}
		end

		if caster.invoked_orbs_particle == nil then
				caster.invoked_orbs_particle = {}
		end

		if caster.invoked_orbs_particle_attach == nil then
			caster.invoked_orbs_particle_attach = {}
			caster.invoked_orbs_particle_attach[1] = "attach_orb1"
			caster.invoked_orbs_particle_attach[2] = "attach_orb2"
			caster.invoked_orbs_particle_attach[3] = "attach_orb3"
		end

		-- Invoker can only have three orbs active at any given time.  Each time an orb is activated, its hscript is
		-- placed into caster.invoked_orbs[3], the old [3] is moved into [2], and the old [2] is moved into [1].
		-- Therefore, the oldest orb is located in [1], and the newest is located in [3].
		-- Now, shift the ordered list of currently summoned orbs down, and add the newest orb to the queue.
		local remove_orb = caster.invoked_orbs[1]
		caster.invoked_orbs[1] = caster.invoked_orbs[2]
		caster.invoked_orbs[2] = caster.invoked_orbs[3]
		caster.invoked_orbs[3] = ability

		-- Remove the oldest orb's particle effect.
		if caster.invoked_orbs_particle[1] ~= nil then
			ParticleManager:DestroyParticle(caster.invoked_orbs_particle[1], false)
			caster.invoked_orbs_particle[1] = nil
		end

		--Shift the ordered list of currently summoned orb particle effects down, and create the new particle.
		caster.invoked_orbs_particle[1] = caster.invoked_orbs_particle[2]
		caster.invoked_orbs_particle[2] = caster.invoked_orbs_particle[3]
		caster.invoked_orbs_particle[3] = ParticleManager:CreateParticle(particle_path, PATTACH_OVERHEAD_FOLLOW, caster, caster)
		ParticleManager:SetParticleControlEnt(caster.invoked_orbs_particle[3], 1, caster, PATTACH_POINT_FOLLOW, caster.invoked_orbs_particle_attach[1], caster:GetAbsOrigin(), false)
		
		-- Shift the ordered list of currently summoned orb particle effect attach locations down.
		local temp_attachment_point = caster.invoked_orbs_particle_attach[1]
		caster.invoked_orbs_particle_attach[1] = caster.invoked_orbs_particle_attach[2]
		caster.invoked_orbs_particle_attach[2] = caster.invoked_orbs_particle_attach[3]
		caster.invoked_orbs_particle_attach[3] = temp_attachment_point

		-- Update orb modifiers
		imba_invoker:update_orb_modifiers(caster, ability, remove_orb)

		-- Change base_attack_effect depending on current orb setup
		imba_invoker:update_base_attack(caster) 
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Help function, update orb modifier
---------------------------------------------------------------------------------------------------------------------
function imba_invoker:update_orb_modifiers(caster, ability, orb_to_remove)	
	-- Find modifier to remove...
	local orb_modifier = nil
	if orb_to_remove ~= nil then
		if orb_to_remove:GetName() == "imba_invoker_quas" then
			orb_modifier = "modifier_imba_invoker_quas"
		elseif orb_to_remove:GetName() == "imba_invoker_wex" then
			orb_modifier = "modifier_imba_invoker_wex"
		elseif orb_to_remove:GetName() == "imba_invoker_exort" then
			orb_modifier = "modifier_imba_invoker_exort"
		end
	end

	if orb_modifier ~= nil then 
		local modifiers = caster:FindAllModifiersByName(orb_modifier)
		local oldest
		for i = 0, 2, 1 do
			if oldest == nil then 
				oldest = modifiers[i]
			elseif modifiers[i] ~= nil and modifiers[i]:GetCreationTime() > oldest:GetCreationTime() then
				oldest = modifiers[i]
			end
		end
		
		if oldest then
			-- turns out this removes the oldest running modifier by name
			caster:RemoveModifierByName(oldest:GetName())
		end
	end
	
	local new_orb = ability:GetName()
	if new_orb == "imba_invoker_quas" then
		local bonus_strength 					= ability:GetSpecialValueFor("bonus_strength")
			local health_regen_per_instance 	= ability:GetSpecialValueFor("health_regen_per_instance")
		caster:AddNewModifier(caster, ability, "modifier_imba_invoker_quas", { 	duration = -1, 
																				bonus_strength = bonus_strength, 
																				health_regen_per_instance = health_regen_per_instance})

		CustomNetTables:SetTableValue("player_table", "quas"..caster:GetPlayerOwnerID(), { 	quas_bonus_strength = bonus_strength, 
																							quas_health_regen_per_instance = health_regen_per_instance})
	elseif new_orb == "imba_invoker_wex" then
		local bonus_agility 					= ability:GetSpecialValueFor("bonus_agility")
		local move_speed_per_instance 			= ability:GetSpecialValueFor("move_speed_per_instance")
			local attack_speed_per_instance 	= ability:GetSpecialValueFor("attack_speed_per_instance")
		caster:AddNewModifier(caster, ability, "modifier_imba_invoker_wex", {	duration = -1, 
																					bonus_agility = bonus_agility, 
																					move_speed_per_instance = move_speed_per_instance,
																					attack_speed_per_instance = attack_speed_per_instance})

		CustomNetTables:SetTableValue("player_table", "wex"..caster:GetPlayerOwnerID(), { 	wex_bonus_agility = bonus_agility, 
																										wex_move_speed_per_instance = move_speed_per_instance, 
																										wex_attack_speed_per_instance = attack_speed_per_instance})
	elseif new_orb == "imba_invoker_exort" then
		local bonus_intelligence 			= ability:GetSpecialValueFor("bonus_intelligence")
		local bonus_damage_per_instance 	= ability:GetSpecialValueFor("bonus_damage_per_instance")
		caster:AddNewModifier(caster, ability, "modifier_imba_invoker_exort", {	duration = -1, 
																						bonus_intelligence = bonus_intelligence, 
																						bonus_damage_per_instance = bonus_damage_per_instance})

		CustomNetTables:SetTableValue("player_table", "exort"..caster:GetPlayerOwnerID(), { 	exort_bonus_intelligence = bonus_intelligence, 
																								exort_bonus_damage_per_instance = bonus_damage_per_instance})
	end
end	

function imba_invoker:update_base_attack(caster) 
	local quas 	= 0 
	local wex 	= 0 
	local exort = 0 

	-- Dont override item-effects
	if (not string.find(caster:GetRangedProjectileName(), 'invoker', 1, true)) then
		return 
	end

	for _,orb in pairs(caster.invoked_orbs) do 
		local orb_type = orb:GetAbilityName() 

		if orb_type == 'imba_invoker_quas' then 
			quas = quas + 1
		elseif orb_type == 'imba_invoker_wex' then
			wex = wex + 1
		elseif orb_type == 'imba_invoker_exort' then
			exort = exort + 1
		end
	end

	local quas_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
	local wex_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
	local exort_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"
	local all_attack = "particles/units/heroes/hero_invoker/invoker_base_attack.vpcf"

	-- temporary
	if caster.bPersona then
		quas_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf"
		wex_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf"
		exort_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf"
		all_attack = "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf"
	end

	if quas >= 2 then
		caster:SetRangedProjectileName(quas_attack)
	elseif wex >= 2 then
		caster:SetRangedProjectileName(wex_attack)
	elseif exort >= 2 then
		caster:SetRangedProjectileName(exort_attack)
	elseif quas == 1 and wex == 1 and exort == 1 then
		caster:SetRangedProjectileName(all_attack)
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Invoker's aghs... triggers +1 to all orbs on creation
---------------------------------------------------------------------------------------------------------------------
modifier_imba_invoker_aghanim_buff = class({})

function modifier_imba_invoker_aghanim_buff:IsPurgable()	return false end
function modifier_imba_invoker_aghanim_buff:IsHidden() 		return true  end
function modifier_imba_invoker_aghanim_buff:IsDebuff() 		return false end
function modifier_imba_invoker_aghanim_buff:RemoveOnDeath() return false end

function modifier_imba_invoker_aghanim_buff:OnCreated()
	if IsServer() then
		local caster 	= self:GetCaster()
		local quas 		= caster:FindAbilityByName("imba_invoker_quas")
		local wex 		= caster:FindAbilityByName("imba_invoker_wex")
		local exort 	= caster:FindAbilityByName("imba_invoker_exort")

		quas:SetLevel(quas:GetLevel() + 1)
		wex:SetLevel(wex:GetLevel() + 1)
		exort:SetLevel(exort:GetLevel() + 1)
	end
end

function modifier_imba_invoker_aghanim_buff:OnDestroy()
	if not IsServer() then return end
	
	local caster 	= self:GetCaster()
	local quas 		= caster:FindAbilityByName("imba_invoker_quas")
	local wex 		= caster:FindAbilityByName("imba_invoker_wex")
	local exort 	= caster:FindAbilityByName("imba_invoker_exort")
	
	quas:SetLevel(quas:GetLevel() - 1)
	wex:SetLevel(wex:GetLevel() - 1)
	exort:SetLevel(exort:GetLevel() - 1)
end

-------------------------------------------------------------------------------------------------------------------------
--	Invoker's Invoke
-------------------------------------------------------------------------------------------------------------------------
	imba_invoker_invoke = imba_invoker_invoke or class({})

	LinkLuaModifier("modifier_imba_invoker_invoke_buff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_imba_invoker_aghanim_buff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

	function imba_invoker_invoke:IsInnateAbility() return true end

	function imba_invoker_invoke:OnInventoryContentsChanged() 
		if IsServer() then
			if self:GetCaster():HasScepter() and (not self:GetCaster():HasModifier("modifier_imba_invoker_aghanim_buff")) then 
				self:GetCaster():AddNewModifier(self:GetCaster(), {}, "modifier_imba_invoker_aghanim_buff", {duration = -1})
			elseif not self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_imba_invoker_aghanim_buff") then
				self:GetCaster():RemoveModifierByName("modifier_imba_invoker_aghanim_buff")
			end
		end
	end

	function imba_invoker_invoke:GetCooldown(iLevel)
		local quas_level = CustomNetTables:GetTableValue("player_table", "quas_level"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if quas_level then quas_level = quas_level["1"] else quas_level = 0 end
		local wex_level = CustomNetTables:GetTableValue("player_table", "wex_level"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if wex_level then wex_level = wex_level["1"] else wex_level = 0 end
		local exort_level = CustomNetTables:GetTableValue("player_table", "exort_level"..tostring(self:GetCaster():GetPlayerOwnerID()))
		if exort_level then exort_level = exort_level["1"] else exort_level = 0 end
		local orb_levels = math.min(quas_level, 7) + math.min(wex_level, 7) + math.min(exort_level, 7)
		local cdr = self:GetSpecialValueFor("cooldown_reduction_per_orb")

		return self.BaseClass.GetCooldown(self, iLevel) - (cdr * orb_levels)
	end

	function imba_invoker_invoke:OnSpellStart()
		if IsServer() then
			local caster 				= self:GetCaster()
			local ability 				= self
			local ability_level 		= ability:GetLevel() -1
			local max_invoked_spells 	= ability:GetLevelSpecialValueFor("max_invoked_spells", ability_level)
			local invoker_empty1 		= "invoker_empty1"
			local invoker_empty2 		= "invoker_empty2"
			local spell_to_be_invoked

			local quas_orbs 		= caster:FindAllModifiersByName("modifier_imba_invoker_quas")
			local wex_orbs 			= caster:FindAllModifiersByName("modifier_imba_invoker_wex")
			local exort_orbs 		= caster:FindAllModifiersByName("modifier_imba_invoker_exort")
			local num_quas_orbs 	= table.getn(quas_orbs)
			local num_wex_orbs 		= table.getn(wex_orbs)
			local num_exort_orbs 	= table.getn(exort_orbs)
			
			-- TODO: Check for other functions that let you spam this sound
			caster:EmitSound("Hero_Invoker.Invoke")

			-- If we have 3 invoked orbs then we can invoke spells!
			if num_quas_orbs + num_wex_orbs + num_exort_orbs == 3 then
				-- Change the Invoke particle effect color depending on invoked orbs.
				local quas_particle_effect_color 	= Vector(0, 0, 255)
				local wex_particle_effect_color 	= Vector(255, 0, 255)
				local exort_particle_effect_color 	= Vector(255, 102, 0)

				-- Create the Invoke particle effect's with general color.
				local invoke_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_invoke.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

				-- Change the Invoke particle effect's color depending on which orbs are invoked.
				ParticleManager:SetParticleControl(invoke_particle_effect, 2, ((quas_particle_effect_color * num_quas_orbs) + (wex_particle_effect_color * num_wex_orbs) + (exort_particle_effect_color * num_exort_orbs)) / 3)

				-- Determine the spell depending on invoked orbs.
				if num_quas_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_cold_snap"
				elseif num_quas_orbs == 2 and num_wex_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_ghost_walk"
				elseif num_quas_orbs == 2 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_ice_wall"
				elseif num_wex_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_emp"
				elseif num_wex_orbs == 2 and num_quas_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_tornado"
				elseif num_wex_orbs == 2 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_alacrity"
				elseif num_exort_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_sun_strike"
				elseif num_exort_orbs == 2 and num_quas_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_forge_spirit"
				elseif num_exort_orbs == 2 and num_wex_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_chaos_meteor"
				elseif num_quas_orbs == 1 and num_wex_orbs == 1 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_deafening_blast"
				end

				-- This is 4th ability slot i.e the first Invoked Spell
				local invoker_slot1 = caster:GetAbilityByIndex(3):GetAbilityName() 
				
				-- If we only have 1 max invoke spell then just swap abilityes in the same slot
				if max_invoked_spells == 1 and invoker_slot1 ~= spell_to_be_invoked then
					caster:SwapAbilities(invoker_slot1, spell_to_be_invoked, false, true)
					caster:FindAbilityByName(spell_to_be_invoked):SetLevel(1)
				-- Otherwise reset the slots and then place the abilities in the proper slots
				elseif max_invoked_spells == 2 and invoker_slot1 ~= spell_to_be_invoked then

					if invoker_slot1 ~= invoker_empty1 then
						caster:SwapAbilities(invoker_empty1, invoker_slot1, true, false) 
					end

					-- This is the 5th ablity slot i.e the second invoked spell
					local invoker_slot2 = caster:GetAbilityByIndex(4):GetAbilityName()			
					if invoker_slot2 ~= invoker_empty2 then
						caster:SwapAbilities(invoker_empty2, invoker_slot2, true, false) 
					end

					caster:SwapAbilities(spell_to_be_invoked, invoker_empty1, true, false) 
					caster:SwapAbilities(invoker_slot1, invoker_empty2, true, false)
					local invoked_spell = caster:FindAbilityByName(spell_to_be_invoked)
					if invoked_spell ~= nil then
						--print("Invoke: " .. invoked_spell:GetAbilityName())
						invoked_spell:SetLevel(1)
					else 
						--print("Could not find spell to invoke!")
					end

					-- if we invoked same spell again... then dont trigger cooldown
					if spell_to_be_invoked == invoker_slot1 and invoker_slot2 == invoker_empty2 then
						ability:EndCooldown()
						caster:GiveMana(ability:GetManaCost(-1))
					-- if we just switched spells... then dont trigger cooldown
					elseif spell_to_be_invoked == invoker_slot2 then
						ability:EndCooldown()
						caster:GiveMana(ability:GetManaCost(-1))
					end
				else
					-- if we invoked same spell again... then dont trigger cooldown
					ability:EndCooldown()
					caster:GiveMana(ability:GetManaCost(-1))

					-- all this is becuz we want to be able to run around and invoke stuff for flashy cosmetics... oh and wand abuse.
				end
			else
				-- in case someone is stupid enought to invoke with no orb out...
				ability:EndCooldown()
				caster:GiveMana(ability:GetManaCost(-1))
			end
		end 
	end

	---------------------------------------------------------------------------------------------------------------------
	-- This method is run each time "invoke" reaches a new lvl. Invoker's Invoke ability is abit special and gets auto-leveled 
	-- by a call from events.lua/OnPlayerLevelUp() at lvl 6, 12 and 18.
	---------------------------------------------------------------------------------------------------------------------
	function imba_invoker_invoke:OnUpgrade() 
		if IsServer() then
			if self.caster == nil then
				self.caster = self:GetCaster()
			end
			if self.ability == nil then
				self.ability = self.caster:FindAbilityByName("imba_invoker_invoke")
			end

			-- Remove old instance and create new...
			if self.caster:HasModifier("modifier_imba_invoker_invoke_buff") then
				self.caster:RemoveModifierByName("modifier_imba_invoker_invoke_buff")
			end

			self.caster:AddNewModifier(self.caster, self.ability, "modifier_imba_invoker_invoke_buff", {duration = -1})
		end
	end

	--[[
	---------------------------------------------------------------------------------------------------------------------
	--	Invoker's Fake Invoke
	---------------------------------------------------------------------------------------------------------------------
	LinkLuaModifier("modifier_imba_invoker_invoke_buff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
	function imba_invoker_invoke:Invoke(caster)
		if IsServer() then 
			local ability 				= caster:FindAbilityByName("invoker_invoke")
			local ability_level 		= ability:GetLevel() -1
			local invoker_empty1 		= "invoker_empty1"
			local invoker_empty2 		= "invoker_empty2"
			local spell_to_be_invoked

			local quas_orbs 		= caster:FindAllModifiersByName("modifier_invoker_quas_instance")
			local wex_orbs 			= caster:FindAllModifiersByName("modifier_invoker_wex_instance")
			local exort_orbs 		= caster:FindAllModifiersByName("modifier_invoker_exort_instance")
			local num_quas_orbs 	= table.getn(quas_orbs)
			local num_wex_orbs 		= table.getn(wex_orbs)
			local num_exort_orbs 	= table.getn(exort_orbs)

			if num_quas_orbs + num_wex_orbs + num_exort_orbs == 3  then
				-- Determine the spell depending on invoked orbs.
				if num_quas_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_cold_snap"
				elseif num_quas_orbs == 2 and num_wex_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_ghost_walk"
				elseif num_quas_orbs == 2 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_ice_wall"
				elseif num_wex_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_emp"
				elseif num_wex_orbs == 2 and num_quas_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_tornado"
				elseif num_wex_orbs == 2 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_alacrity"
				elseif num_exort_orbs == 3 then
					spell_to_be_invoked = "imba_invoker_sun_strike"
				elseif num_exort_orbs == 2 and num_quas_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_forge_spirit"
				elseif num_exort_orbs == 2 and num_wex_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_chaos_meteor"
				elseif num_quas_orbs == 1 and num_wex_orbs == 1 and num_exort_orbs == 1 then
					spell_to_be_invoked = "imba_invoker_deafening_blast"
				end

				local invoker_slot1 		= caster:GetAbilityByIndex(3):GetAbilityName() 
				local invoker_slot2 		= caster:GetAbilityByIndex(4):GetAbilityName() 
				
				if invoker_slot1 == invoker_empty1 and invoker_slot2 == invoker_empty2 then
					caster:SwapAbilities(spell_to_be_invoked, invoker_slot2, true, false) 
				elseif invoker_slot1 == invoker_empty1 then 
					caster:SwapAbilities(spell_to_be_invoked, invoker_empty1, true, false) 
				elseif invoker_slot1 == invoker_empty2 then 
					caster:SwapAbilities(spell_to_be_invoked, invoker_empty2, true, false)
				elseif invoker_slot2 == invoker_empty1 then 
					caster:SwapAbilities(spell_to_be_invoked, invoker_empty1, true, false)
				elseif invoker_slot2 == invoker_empty2 then 
					caster:SwapAbilities(spell_to_be_invoked, invoker_empty2, true, false) 
				else
					caster:SwapAbilities(spell_to_be_invoked, invoker_slot2, true, false) 
				end
					
				local invoked_spell = caster:FindAbilityByName(spell_to_be_invoked)
				if invoked_spell ~= nil then
					--print("Invoke: " .. invoked_spell:GetAbilityName())
					invoked_spell:SetLevel(1)
				else 
					--print("Could not find spell to invoke!")
				end

				-- if we invoked same spell again... then dont trigger cooldown
				if spell_to_be_invoked == invoker_slot1 and invoker_slot2 == invoker_empty2 then
					ability:EndCooldown()
					caster:GiveMana(ability:GetManaCost(-1))
				end

				-- if we just switched spells... then dont trigger cooldown
				if spell_to_be_invoked == invoker_slot2 then
					ability:EndCooldown()
					caster:GiveMana(ability:GetManaCost(-1))
				end
			end
		end
	end
	]]

	---------------------------------------------------------------------------------------------------------------------
	-- Invoker's Invoke buff modifier (moved from hero_selection.lua).
	-- I keept it as this is a power players are expecting from invoker. But not sure if this is needed...
	---------------------------------------------------------------------------------------------------------------------
	modifier_imba_invoker_invoke_buff = class({})
	function modifier_imba_invoker_invoke_buff:IsPurgable()		return false end
	function modifier_imba_invoker_invoke_buff:IsHidden() 		return true  end
	function modifier_imba_invoker_invoke_buff:RemoveOnDeath() 	return false end
	function modifier_imba_invoker_invoke_buff:OnCreated()
		if IsServer() then
			self.caster 	= self:GetCaster()
			self.ability 	= self:GetAbility()
			if self.ability == nil then
				self.ability = self.caster:FindAbilityByName("invoker_invoke")
			end

			-- Get skill stats 
			local invoke_lvl 			= self.ability:GetLevel() - 1
			self.spell_amp 				= self.ability:GetLevelSpecialValueFor("bonus_spellpower", invoke_lvl)
			self.int_buff 				= self.ability:GetLevelSpecialValueFor("bonus_intellect", invoke_lvl)
			self.magic_resist 			= self.ability:GetLevelSpecialValueFor("magic_resistance_pct", invoke_lvl)
			self.cooldown_reduction 	= self.ability:GetLevelSpecialValueFor("cooldown_reduction_pct", invoke_lvl)
			self.spell_lifesteal 		= self.ability:GetLevelSpecialValueFor("spell_lifesteal", invoke_lvl)

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerID()), "invoker_helper", {ability_index = self.ability:GetAbilityIndex()})
		end
	end

	function modifier_imba_invoker_invoke_buff:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_EVENT_ON_ABILITY_EXECUTED
		}

		return funcs
	end

	function modifier_imba_invoker_invoke_buff:GetModifierSpellAmplify_Percentage()
		return self.spell_amp
	end

	function modifier_imba_invoker_invoke_buff:GetModifierMagicalResistanceBonus()
		return self.magic_resist
	end
	function modifier_imba_invoker_invoke_buff:GetModifierBonusStats_Intellect()
		return self.int_buff
	end

	function modifier_imba_invoker_invoke_buff:GetCustomCooldownReductionStacking()
		return self.cooldown_reduction
	end

	function modifier_imba_invoker_invoke_buff:GetModifierSpellLifesteal()
		return self.spell_lifesteal
	end

	function modifier_imba_invoker_invoke_buff:OnAbilityExecuted(kv)
		if IsServer() then 
			local caster = self:GetParent()
			if kv.unit == caster then
				if kv.ability:GetName() == "invoker_invoke" then
					imba_invoker_invoke:Invoke(caster)
				end
			end
		end
	end


-------------------------------------------------------------------------------------------------------------------------
--	Invoker SPELLS
-------------------------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------------------
	--	Invoker's Sun Strike
	---------------------------------------------------------------------------------------------------------------------
		imba_invoker_sun_strike = class({})
		imba_invoker_sun_strike.ability_particle_effect = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
		imba_invoker_sun_strike.ability_outer_beam_effect = "particles/hero/invoker/sunstrike/imba_invoker_sun_strike_outer_beam.vpcf"
		imba_invoker_sun_strike.ability_team_particle_effect = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
		LinkLuaModifier("modifier_imba_invoker_sun_strike", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_sun_strike_cataclysm", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_sun_strike_beam_only", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_sun_strike_incinerate", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		
		LinkLuaModifier("modifier_imba_invoker_sun_strike_thinker", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		
		modifier_imba_invoker_sun_strike_thinker	= modifier_imba_invoker_sun_strike_thinker or class({})
		
		function imba_invoker_sun_strike:GetCastAnimation()
			return ACT_DOTA_CAST_SUN_STRIKE
		end

		function imba_invoker_sun_strike:GetBehavior()
			if IsServer() then
				return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
			else
				return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
			end
		end

		-- function imba_invoker_sun_strike:CastFilterResultTarget( target )
			-- if target ~= nil and target == self:GetCaster() then
				-- return UF_SUCCESS
			-- end
		-- end

		function imba_invoker_sun_strike:OnSpellStart()
			-- local target = self:GetCursorTarget()
			-- local double_tap = false
			-- if target ~= nil and target:GetName() == "npc_dota_hero_invoker" then 
				-- double_tap = true
			-- end 

			-- local caster 				= self:GetCaster() 
			-- local caster_team		 	= caster:GetTeam()
			-- local target_point 			= self:GetCursorPosition()
			-- local target 				= self:GetCursorTarget()
			-- local ability 				= caster:FindAbilityByName("imba_invoker_sun_strike")
			
			-- -- Get the skill Stats
			-- local delay 				= self:GetSpecialValueFor("delay")
			-- local area_of_effect 		= self:GetSpecialValueFor("area_of_effect")
			-- local vision_distance 		= self:GetSpecialValueFor("vision_distance")
			-- local vision_duration 		= self:GetSpecialValueFor("vision_duration")
			-- local all_heroes 			= HeroList:GetAllHeroes()

			-- -- Check if we have Cataclysm talent
			-- if double_tap then
				-- if caster:HasTalent("imba_special_bonus_unique_invoker_5") then 
					-- local bonus_area_of_effect 	=  caster:FindTalentValue("imba_special_bonus_unique_invoker_5", "bonus_area_of_effect")
					-- local cooldown 				=  caster:FindTalentValue("imba_special_bonus_unique_invoker_5", "cooldown")
					-- local minimum_range 		=  caster:FindTalentValue("imba_special_bonus_unique_invoker_5", "minimum_range")
					-- local maximum_range 		=  caster:FindTalentValue("imba_special_bonus_unique_invoker_5", "maximum_range")
					-- area_of_effect 				= area_of_effect + bonus_area_of_effect

					-- -- Cast Cataclysm SunStrike...
					-- imba_invoker_sun_strike:CastCataclysmSunStrike({
						-- caster 					= caster,
						-- caster_team 			= caster_team,
						-- ability 				= ability,
						-- target_point			= target_point,
						-- delay 					= delay,
						-- area_of_effect 			= area_of_effect,
						-- damage 					= damage,
						-- vision_distance 		= vision_distance,
						-- vision_duration 		= vision_duration,
						-- all_heroes 				= all_heroes,
						-- cooldown 				= cooldown,
						-- minimum_range 			= minimum_range,
						-- maximum_range 			= maximum_range
					-- })
				-- else
					-- -- This should not be possible.
					-- ability:EndCooldown()
					-- caster:GiveMana(ability:GetManaCost(-1))
				-- end
			-- else
				-- -- Cast Normal SunStrike
				-- imba_invoker_sun_strike:CastSunStrike(
				-- {
					-- caster 				= caster,
					-- caster_team 		= caster_team,
					-- ability 			= ability,
					-- target_point		= target_point,
					-- delay 				= delay,
					-- area_of_effect 		= area_of_effect,
					-- damage 				= damage,
					-- vision_distance 	= vision_distance,
					-- vision_duration 	= vision_duration,
					-- all_heroes 			= all_heroes
				-- })

			---------------------
			-- "FIXED" VERSION --
			---------------------

			if not self:GetCaster():HasAbility("imba_invoker_exort") then return end

			self:GetCaster():StartGesture(ACT_DOTA_CAST_SUN_STRIKE)

			local bCataclysm = self:GetCursorTarget() == self:GetCaster()

			if bCataclysm and self:GetCaster():HasScepter() then
				bCataclysm = 1
				self:StartCooldown(self:GetSpecialValueFor("cataclysm_cooldown") * self:GetCaster():GetCooldownReduction())
			else
				bCataclysm = 0
			end

			CreateModifierThinker(self:GetCaster(), self, "modifier_imba_invoker_sun_strike_thinker", {
				duration 			= self:GetSpecialValueFor("delay"),
				area_of_effect 		= self:GetSpecialValueFor("area_of_effect"),
				target_point_x		= self:GetCursorPosition().x,
				target_point_y		= self:GetCursorPosition().y,
				target_point_z		= self:GetCursorPosition().z,
				incinerate_duration	= self:GetSpecialValueFor("incinerate_duration"),
				damage				= self:GetLevelSpecialValueFor("damage", self:GetCaster():FindAbilityByName("imba_invoker_exort"):GetLevel() - 1),
				bCataclysm			= bCataclysm
			}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
		end

		function imba_invoker_sun_strike:CastSunStrike(kv)
			local caster 				= kv.caster
			local caster_team		 	= kv.caster_team
			local target_point 			= kv.target_point
			local ability 				= kv.ability
			local delay 				= kv.delay
			local area_of_effect 		= kv.area_of_effect
			local vision_distance 		= kv.vision_distance
			local vision_duration 		= kv.vision_duration
			local all_heroes 			= kv.all_heroes

			-- Create vision on target location
			local duration = delay + vision_duration
			ability:CreateVisibilityNode(target_point, vision_distance, vision_duration)

			-- Play SunStrike Sound!
			EmitSoundOnLocationWithCaster(target_point, "Hero_Invoker.SunStrike.Charge", caster)

			for _,hero in pairs(all_heroes) do
				-- For each real hero
				if hero:IsRealHero() then 
					-- That is on your team
					if hero:GetTeam() == caster_team then
						-- This is the only SunStrike dealing dmg
						if hero:GetPlayerID() == caster:GetPlayerID() then 
							CreateModifierThinker(
								caster, 
								ability, 
								"modifier_imba_invoker_sun_strike", 	
								{
									duration 			= delay,
									area_of_effect 		= area_of_effect,
									target 				= hero:entindex()
								}, 
								target_point, 
								caster:GetTeamNumber(), false)
						-- Only show particle effects
						else
							CreateModifierThinker(
								caster, 
								ability, 
								"modifier_imba_invoker_sun_strike_beam_only", 	
								{
									duration 			= delay,
									area_of_effect 		= area_of_effect,
									target 				= hero:entindex(),
									show_beam			= "true",
									show_crater 		= "true"
								}, 
								target_point, 
								caster:GetTeamNumber(), false)
						end
					-- Only show 2nd particle effect
					else
						CreateModifierThinker(
								caster, 
								ability, 
								"modifier_imba_invoker_sun_strike_beam_only", 	
								{
									duration 			= delay,
									area_of_effect 		= area_of_effect,
									target 				= hero:entindex(),
									show_crater 		= "true"
								}, 
								target_point, 
								caster:GetTeamNumber(), false)
					end
				end
			end
		end

		function imba_invoker_sun_strike:CastCataclysmSunStrike(kv)
			local caster 				= kv.caster
			local caster_team		 	= kv.caster_team
			local target_point 			= kv.target_point
			local ability 				= kv.ability
			local delay 				= kv.delay
			local area_of_effect 		= kv.area_of_effect
			local damage 				= kv.damage
			local vision_distance 		= kv.vision_distance
			local vision_duration 		= kv.vision_duration
			local all_heroes 			= kv.all_heroes
			local cooldown 				= kv.cooldown
			local minimum_range 		= kv.minimum_range
			local maximum_range 		= kv.maximum_range
			
			-- Set Cooldown, account for cooldown reductions
			local current_cooldown 			= ability:GetCooldownTime()
			local unaltered_cooldown 		= ability:GetCooldown(1)
			local cooldown_reduction_pct 	= current_cooldown / unaltered_cooldown
			ability:StartCooldown(cooldown * cooldown_reduction_pct)

			-- Play SunStrike Sound!
			EmitSoundOnLocationWithCaster(target_point, "Hero_Invoker.SunStrike.Charge", caster)
			
			for _,hero in pairs(all_heroes) do
				-- For each real hero
				if hero:IsRealHero() then 
					-- That is not on our team...
					if hero:GetPlayerID() and hero:GetTeam() ~= caster:GetTeam() and hero:IsAlive() then
						-- Create 2 random sunstrike locations
						local target_point1 = hero:GetAbsOrigin()  + RandomVector(math.random(minimum_range, maximum_range))
						local target_point2 = hero:GetAbsOrigin()  - RandomVector(math.random(minimum_range, maximum_range))

						ability:CreateVisibilityNode(target_point1, vision_distance, vision_duration)
						ability:CreateVisibilityNode(target_point2, vision_distance, vision_duration)
				
						EmitSoundOnLocationWithCaster(target_point1, "Hero_Invoker.Cataclysm.Ignite", caster)
						EmitSoundOnLocationWithCaster(target_point2, "Hero_Invoker.Cataclysm.Ignite", caster)

						-- For each hero...
						for _,hero2 in pairs(all_heroes) do
							-- If hero and cater is both invoker...
							if hero2:GetPlayerID() == caster:GetPlayerID() then
								CreateModifierThinker(
									caster, 
									ability, 
									"modifier_imba_invoker_sun_strike_cataclysm", 	
									{
										duration 			= delay,
										area_of_effect 		= area_of_effect,
										target 				= hero2:entindex()
									}, 
									target_point1, 
									caster:GetTeamNumber(), false)

								CreateModifierThinker(
									caster, 
									ability, 
									"modifier_imba_invoker_sun_strike_cataclysm", 	
									{
										duration 			= delay,
										area_of_effect 		= area_of_effect,
										target 				= hero2:entindex()
									}, 
									target_point2, 
									caster:GetTeamNumber(), false)
							else
								CreateModifierThinker(
									caster, 
									ability, 
									"modifier_imba_invoker_sun_strike_beam_only", 	
									{
										duration 			= delay,
										area_of_effect 		= area_of_effect,
										target 				= hero2:entindex(),
										show_beam			= "true",
										show_crater 		= "true"
									}, 
									target_point1, 
									caster:GetTeamNumber(), false)

								CreateModifierThinker(
									caster, 
									ability, 
									"modifier_imba_invoker_sun_strike_beam_only", 	
									{
										duration 			= delay,
										area_of_effect 		= area_of_effect,
										target 				= hero2:entindex(),
										show_beam			= "true",
										show_crater 		= "true"
									}, 
									target_point2, 
									caster:GetTeamNumber(), false)
							end
						end
					end
				end
			end
		end

		function imba_invoker_sun_strike:OnHit(caster, ability, enemies_hit, damage) 
			-- Initialize damage table
			local damage_table 			= {}
			damage_table.attacker 		= caster
			damage_table.ability 		= ability
			damage_table.damage_type 	= ability:GetAbilityDamageType() 
			damage_table.damage 		= damage / table.getn(enemies_hit)
			
			-- Deal damage to each enemy hero
			for _,hero in pairs(enemies_hit) do
				damage_table.victim = hero
				ApplyDamage(damage_table)
			end
		end

		function imba_invoker_sun_strike:GetAOERadius()
			return self:GetSpecialValueFor("area_of_effect")
		end 

		modifier_imba_invoker_sun_strike = class({})
		function modifier_imba_invoker_sun_strike:OnCreated(kv)
			if IsServer() then
				self.caster 			= self:GetCaster()
				self.target_point 		= self:GetParent():GetAbsOrigin()
				self.direction 			= (self.target_point - self.caster:GetAbsOrigin()):Normalized()
				self.target 			= EntIndexToHScript(kv.target)
				-- make sure direction is horizontal
				self.direction.z 		= 0

				local invoker_exort 		= self.caster:FindAbilityByName("imba_invoker_exort")
				local exort_level 			= invoker_exort:GetLevel() - 1
				self.ability 				= self:GetAbility()
				self.damage 				= self.ability:GetLevelSpecialValueFor("damage", exort_level)
				self.incinerate_duration 	= self.ability:GetSpecialValueFor("incinerate_duration")
				self.mini_beam_radius 		= self.ability:GetSpecialValueFor("incinerate_beam_radius")

				self.area_of_effect 		= kv.area_of_effect
				self.degrees 				= 180 / 6

				-- Show the sun strike beam
				local sun_strike_beam = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_team_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam, 0, self.target_point) 
				ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(self.area_of_effect,0, 0))

				-- For debugging purpouse. Nice to check the actual aoe of the spell.
				-- local cirle_area = self.area_of_effect + (self.mini_beam_radius / 2 )
				--DebugDrawCircle(self.target_point, Vector(255,0,255), 255, cirle_area, true, 20)

				self.fierd_sunstrikes = 0
				self:StartIntervalThink(0.1)
			end
		end

		function modifier_imba_invoker_sun_strike:OnIntervalThink()
			if IsServer() then
--				EmitSoundOnLocationWithCaster(self.target_point, "Hero_Invoker.SunStrike.Charge", self.caster)
				
				-- upper beam
				local small_target_point = self.target_point + (self.direction * self.mini_beam_radius)
				local sun_strike_beam = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_outer_beam_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam, 0, small_target_point) 
				--ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(50,0, 0))

				-- mirrored bottom beam
				local small_target_point2 = self.target_point - (self.direction * self.mini_beam_radius)
				local sun_strike_beam2 = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_outer_beam_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam2, 0, small_target_point2) 
				--ParticleManager:SetParticleControl(sun_strike_beam2, 1, Vector(50,0, 0))

				self.fierd_sunstrikes = self.fierd_sunstrikes + 2
				self.direction = RotatePosition(Vector(0,0,0), QAngle(0, self.degrees, 0), self.direction)

				if self.fierd_sunstrikes == 12 then 
					self:StartIntervalThink(-1)
				end
			end
		end

		function modifier_imba_invoker_sun_strike:OnRemoved()
			if IsServer() then
				local search_area = self.area_of_effect + (self.mini_beam_radius / 2)
				local nearby_enemy_units = FindUnitsInRadius(
						self.caster:GetTeam(),
						self.target_point, 
						nil, 
						search_area, 
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
						FIND_ANY_ORDER, 
						false)

				local enemies_hit = 1
				local hit_table = {}
				if nearby_enemy_units ~= nil then
					for _,hero in pairs(nearby_enemy_units) do
						hero:AddNewModifier(self.caster, self.ability, "modifier_imba_invoker_sun_strike_incinerate", {duration = self.incinerate_duration, damage = self.damage})

						-- calculate if target got hit by main sun-strike
						if (self.target_point - hero:GetAbsOrigin()):Length2D() <= self.area_of_effect then
							hit_table[enemies_hit] = hero
							enemies_hit = enemies_hit + 1
						end					
					end				
				end

				if enemies_hit > 1 then 
					imba_invoker_sun_strike:OnHit(self.caster, self.ability, hit_table, self.damage)
				end

				EmitSoundOnLocationWithCaster(self.target_point, "Hero_Invoker.SunStrike.Ignite", self.caster)
				self.caster:StopSound("Hero_Invoker.SunStrike.Charge")

				local sun_strike_crater = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_crater, 0, self.target_point)
				ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(self.area_of_effect,0, 0))
			end
		end

		modifier_imba_invoker_sun_strike_cataclysm = class({})
		function modifier_imba_invoker_sun_strike_cataclysm:OnCreated(kv)
			if IsServer() then
				self.caster 				= self:GetCaster()
				self.target_point 			= self:GetParent():GetAbsOrigin()
				self.target 				= EntIndexToHScript(kv.target)

				local invoker_exort 		= self.caster:FindAbilityByName("imba_invoker_exort")
				local exort_level 			= invoker_exort:GetLevel() - 1
				self.ability 				= self:GetAbility()
				self.damage 				= self.ability:GetLevelSpecialValueFor("damage", exort_level)
				self.incinerate_duration 	= self.ability:GetSpecialValueFor("incinerate_duration")
				self.area_of_effect 		= kv.area_of_effect

				-- Show the sun strike beam
				local sun_strike_beam = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_team_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_beam, 0, self.target_point) 
				ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(self.area_of_effect,0, 0))
			end
		end

		function modifier_imba_invoker_sun_strike_cataclysm:OnRemoved()
			if IsServer() then
				--ParticleManager:DestroyParticle(sun_strike_beam3, false)
				local sun_strike_crater = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_team_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
				ParticleManager:SetParticleControl(sun_strike_crater, 0, self.target_point)
				ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(self.area_of_effect,0, 0))

				-- Check if we hit stuff
				local nearby_enemy_units = FindUnitsInRadius(
					self.caster:GetTeam(),
					self.target_point, 
					nil, 
					self.area_of_effect, 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
					FIND_ANY_ORDER, 
					false)

				if nearby_enemy_units ~= nil then
					-- Add incinerate to enemies hit
					for _,hero in pairs(nearby_enemy_units) do
						hero:AddNewModifier(self.caster, self.ability, "modifier_imba_invoker_sun_strike_incinerate", {duration = self.incinerate_duration, damage = self.damage})
					end	
					-- Damage is shared between all units hit
					imba_invoker_sun_strike:OnHit(self.caster, self.ability, nearby_enemy_units, self.damage)
				end
			end
		end

		modifier_imba_invoker_sun_strike_incinerate = class({})
		function modifier_imba_invoker_sun_strike_incinerate:IsDebuff() 		return true end
		function modifier_imba_invoker_sun_strike_incinerate:GetEffectName() 	return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end
		function modifier_imba_invoker_sun_strike_incinerate:OnCreated(kv)
			if IsServer() then 
				self:SetStackCount(self:GetStackCount() + 1)

				self.caster 			= self:GetCaster()
				self.ability 			= self:GetAbility()
				self.incinerate_damage 	= self.ability:GetSpecialValueFor("incinerate_dmg")
				self.damage 			= kv.damage
				self.burn_dps 			= ((self.damage / 100) * self.incinerate_damage) / 5

				self:StartIntervalThink(0.2 * (1 - self:GetParent():GetStatusResistance()))
			end
		end

		function modifier_imba_invoker_sun_strike_incinerate:OnIntervalThink()	
			if IsServer() then
				-- Apply damage
				local damage_table = {}
				damage_table.attacker = self.caster
				damage_table.victim = self:GetParent()
				damage_table.ability = self.ability
				damage_table.damage_type = DAMAGE_TYPE_PURE
				damage_table.damage = self.burn_dps * self:GetStackCount()
				ApplyDamage(damage_table)
			end
		end

		function modifier_imba_invoker_sun_strike_incinerate:OnRefresh()
			if IsServer() then 
				self:SetStackCount(self:GetStackCount() + 1)
			end
		end

		modifier_imba_invoker_sun_strike_beam_only = class({})
		function modifier_imba_invoker_sun_strike_beam_only:OnCreated(kv)
			if IsServer() then
				self.caster 			= self:GetCaster()
				self.target_point 		= self:GetParent():GetAbsOrigin()
				self.show_beam			= kv.show_beam
				self.show_crater 		= kv.show_crater
				self.target 			= EntIndexToHScript(kv.target)
				self.area_of_effect 	= kv.area_of_effect

				if self.show_beam ~= nil then 
					-- Show the sun strike beam
					local sun_strike_beam = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_team_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
					ParticleManager:SetParticleControl(sun_strike_beam, 0, self.target_point) 
					ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(self.area_of_effect,0, 0))
				end
			end
		end

		function modifier_imba_invoker_sun_strike_beam_only:OnRemoved()
			if IsServer() then
				if self.show_crater ~= nil then
					--ParticleManager:DestroyParticle(sun_strike_beam3, false)
					local sun_strike_crater = ParticleManager:CreateParticleForPlayer(imba_invoker_sun_strike.ability_particle_effect, PATTACH_POINT, self.target, PlayerResource:GetPlayer(self.target:GetPlayerID()))
					ParticleManager:SetParticleControl(sun_strike_crater, 0, self.target_point)
					ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(self.area_of_effect,0, 0))
				end
			end
		end

		----------------------------------------------
		-- MODIFIER_IMBA_INVOKER_SUN_STRIKE_THINKER --
		----------------------------------------------

		function modifier_imba_invoker_sun_strike_thinker:OnCreated(kv)
			if not IsServer() then return end

			self.area_of_effect 		= self:GetAbility():GetSpecialValueFor("area_of_effect")
			self.damage					= self:GetAbility():GetLevelSpecialValueFor("damage", self:GetCaster():FindAbilityByName("imba_invoker_exort"):GetLevel())
			self.vision_distance		= self:GetAbility():GetSpecialValueFor("vision_distance")
			self.vision_duration		= self:GetAbility():GetSpecialValueFor("vision_duration")
			self.cataclysm_min_range	= self:GetAbility():GetSpecialValueFor("cataclysm_min_range")
			self.cataclysm_max_range	= self:GetAbility():GetSpecialValueFor("cataclysm_max_range")

			self.incinerate_duration	= self:GetAbility():GetSpecialValueFor("incinerate_duration")
			self.mini_beam_radius 		= self:GetAbility():GetSpecialValueFor("incinerate_beam_radius")

			self.bCataclysm				= kv.bCataclysm

			self.sun_strike_points		= {}

			if (kv.target_point_x and kv.target_point_y and kv.target_point_z) then
				self.target_point = Vector(kv.target_point_x, kv.target_point_y, kv.target_point_z)
			end

			if not self.target_point or self.target_point == self:GetCaster():GetAbsOrigin() then
				self.target_point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()
			end

			if not self.bCataclysm or self.bCataclysm == 0 then
				EmitSoundOnLocationForAllies(self.target_point, "Hero_Invoker.SunStrike.Charge", self:GetCaster())

				AddFOWViewer(self:GetCaster():GetTeamNumber(), self.target_point, self.vision_distance, self.vision_duration, false)

				local sun_strike_beam = nil

				if self.target_point then
					sun_strike_beam = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_POINT, self:GetCaster(), self:GetCaster():GetTeamNumber())
					ParticleManager:SetParticleControl(sun_strike_beam, 0, self.target_point) 
					ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(self.area_of_effect, 0, 0))
					self:AddParticle(sun_strike_beam, false, false, -1, false, false)
					
					table.insert(self.sun_strike_points, self.target_point)
				else

				end
			else
				self.cataclysm_point	= nil

				local enemies = FindUnitsInRadius(
					self:GetCaster():GetTeamNumber(),
					self:GetCaster():GetAbsOrigin(),
					nil,
					FIND_UNITS_EVERYWHERE,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
					FIND_ANY_ORDER,
					false
				)

				for _, enemy in pairs(enemies) do
					if (enemy:IsRealHero() or enemy:IsTempestDouble()) and not enemy:IsClone() then
						for beam = 1, 2 do
							if beam == 1 then
								self.cataclysm_point = enemy:GetAbsOrigin() + RandomVector(self.cataclysm_min_range)
							elseif beam == 2 then
								-- IDK wtf this "160-200" range thing is so I'm just doing what's logical in my head)
								self.cataclysm_point = RotatePosition(enemy:GetAbsOrigin(), QAngle(0, RandomInt(120, 240), 0), self.cataclysm_point)
							end
							
							EmitSoundOnLocationWithCaster(self.cataclysm_point, "Hero_Invoker.SunStrike.Charge", self:GetCaster())
							AddFOWViewer(self:GetCaster():GetTeamNumber(), self.cataclysm_point, self.vision_distance, self.vision_duration, false)
							
							sun_strike_beam = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl(sun_strike_beam, 0, self.cataclysm_point)
							ParticleManager:SetParticleControl(sun_strike_beam, 1, Vector(self.area_of_effect, 0, 0))
							self:AddParticle(sun_strike_beam, false, false, -1, false, false)
							
							table.insert(self.sun_strike_points, self.cataclysm_point)
						end
					end
				end
			end
			
			-- As cool as it is, this thing is way too laggy
			
			-- self.direction 			= (self.target_point - self:GetCaster():GetAbsOrigin()):Normalized()
			-- self.degrees 			= 180 / 6
			-- self.fierd_sunstrikes 	= 0
			
			-- self.sun_strike_beam	= nil
			-- self.sun_strike_beam2	= nil
			
			-- self:StartIntervalThink(0.1)
		end

		-- function modifier_imba_invoker_sun_strike_thinker:OnIntervalThink()
			-- for location = 1, #self.sun_strike_points do
				-- -- upper beam
				-- self.sun_strike_beam = ParticleManager:CreateParticleForTeam("particles/hero/invoker/sunstrike/imba_invoker_sun_strike_outer_beam.vpcf", PATTACH_POINT, self:GetCaster(), self:GetCaster():GetTeamNumber())
				-- ParticleManager:SetParticleControl(self.sun_strike_beam, 0, self.sun_strike_points[location] + (self.direction * self.mini_beam_radius))
				-- self:AddParticle(self.sun_strike_beam, false, false, -1, false, false)
				
				-- -- mirrored bottom beam
				-- self.sun_strike_beam2 = ParticleManager:CreateParticleForTeam("particles/hero/invoker/sunstrike/imba_invoker_sun_strike_outer_beam.vpcf", PATTACH_POINT, self:GetCaster(), self:GetCaster():GetTeamNumber())
				-- ParticleManager:SetParticleControl(self.sun_strike_beam2, 0, self.sun_strike_points[location] - (self.direction * self.mini_beam_radius))
				-- self:AddParticle(self.sun_strike_beam2, false, false, -1, false, false)
				
				-- self.direction = RotatePosition(Vector(0,0,0), QAngle(0, self.degrees, 0), self.direction)
			-- end

			-- self.fierd_sunstrikes = self.fierd_sunstrikes + 2

			-- if self.fierd_sunstrikes == 12 then 
				-- self:StartIntervalThink(-1)
			-- end
		-- end
		
		function modifier_imba_invoker_sun_strike_thinker:OnDestroy()
			if not IsServer() then return end
			
			for location = 1, #self.sun_strike_points do
				EmitSoundOnLocationWithCaster(self.sun_strike_points[location], "Hero_Invoker.SunStrike.Ignite", self:GetCaster())
				-- self:GetCaster():StopSound("Hero_Invoker.SunStrike.Charge")
				
				local sun_strike_crater = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(sun_strike_crater, 0, self.sun_strike_points[location])
				ParticleManager:SetParticleControl(sun_strike_crater, 1, Vector(self.area_of_effect,0, 0))
				ParticleManager:ReleaseParticleIndex(sun_strike_crater)
				
				local nearby_enemy_units = FindUnitsInRadius(
					self:GetCaster():GetTeamNumber(),
					self.sun_strike_points[location], 
					nil, 
					self.area_of_effect + (self.mini_beam_radius / 2),
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
					FIND_ANY_ORDER, 
					false)
				
				local incinerate_modifier = nil

				if #nearby_enemy_units > 0 then
					-- Add incinerate to enemies hit
					for _, enemy in pairs(nearby_enemy_units) do					
						
						if (GetGroundPosition(enemy:GetAbsOrigin(), nil) - self.sun_strike_points[location]):Length2D() <= self.area_of_effect then
							ApplyDamage({
								victim 			= enemy,
								damage 			= self.damage / #nearby_enemy_units,
								damage_type		= DAMAGE_TYPE_PURE,
								damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
								attacker 		= self:GetCaster(),
								ability 		= self:GetAbility()
							})
						end
						
						incinerate_modifier = enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_invoker_sun_strike_incinerate", {duration = self.incinerate_duration, damage = self.damage})
						
						if incinerate_modifier then
							incinerate_modifier:SetDuration(self.incinerate_duration * (1 - enemy:GetStatusResistance()), true)
						end
					end
				end
			end
		end
		
	---------------------------------------------------------------------------------------------------------------------
	--	Invoker's Cold Snap
	---------------------------------------------------------------------------------------------------------------------
		imba_invoker_cold_snap = class({})
		LinkLuaModifier("modifier_imba_invoker_cold_snap", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_cold_snap_stun_duration", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_cold_snap_cooldown", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_cold_snap_buff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function imba_invoker_cold_snap:GetCastAnimation()
			return ACT_DOTA_CAST_COLD_SNAP
		end

		function imba_invoker_cold_snap:OnSpellStart()
			if IsServer() then 
				local caster 				= self:GetCaster()
				local target 				= self:GetCursorTarget()
				local ability 				= caster:FindAbilityByName("imba_invoker_cold_snap") 
				local quas_level 			= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1

				-- Get skill stats
				local cold_snap_duration 	= ability:GetLevelSpecialValueFor("duration", quas_level) 
				local freeze_duration 		= ability:GetLevelSpecialValueFor("freeze_duration", quas_level) 
				local freeze_cooldown 		= ability:GetLevelSpecialValueFor("freeze_cooldown", quas_level) 
				local freeze_damage 		= ability:GetLevelSpecialValueFor("freeze_damage", quas_level)
				local damage_trigger	 	= ability:GetSpecialValueFor("damage_trigger")

				-- Play Cold Snap Sounds!
				caster:EmitSound("Hero_Invoker.ColdSnap.Cast")
				target:EmitSound("Hero_Invoker.ColdSnap")

				caster:StartGesture(ACT_DOTA_CAST_COLD_SNAP)

				if target:GetTeam() ~= caster:GetTeam() then
					if target:TriggerSpellAbsorb(self) then
						return nil
					end

					-- Apply cold snap to target
					target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap", {duration = cold_snap_duration})
					target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_stun_duration", {duration = freeze_duration * (1 - target:GetStatusResistance())}) 
					target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_cooldown", {duration = freeze_cooldown * (1 - target:GetStatusResistance())})

					-- Apply damage
					local damage_table = {}
					damage_table.attacker = caster
					damage_table.victim = target
					damage_table.ability = ability
					damage_table.damage_type = ability:GetAbilityDamageType() 
					damage_table.damage = freeze_damage
					ApplyDamage(damage_table)
				else
					ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
					target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_buff", {duration = cold_snap_duration})
				end
			end
		end

		---------------------------------------------------------------------------------------------------------------------
		--	Cold Snap debuff modifier
		---------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_cold_snap = class({})
		LinkLuaModifier("modifier_imba_invoker_cold_snap_stun_duration", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_cold_snap_cooldown", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function modifier_imba_invoker_cold_snap:IsBuff() 			return false end
		function modifier_imba_invoker_cold_snap:IsHidden() 		return false end
		function modifier_imba_invoker_cold_snap:IsDebuff() 		return true  end
		function modifier_imba_invoker_cold_snap:IsPurgable() 		return true end
		function modifier_imba_invoker_cold_snap:IgnoreTenacity()	return true end
		function modifier_imba_invoker_cold_snap:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf" end
		function modifier_imba_invoker_cold_snap:DeclareFunctions()
			local funcs = {
				MODIFIER_EVENT_ON_TAKEDAMAGE
			}
			
			return funcs
		end

		function modifier_imba_invoker_cold_snap:OnTakeDamage(kv) 
			if IsServer() then
				local caster 			= self:GetCaster()
				local target 			= kv.unit
				local ability 			= caster:FindAbilityByName("imba_invoker_cold_snap") 
				local quas_level 		= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1

				-- Only proc cold_snap if the target still have cold_snap debuff and the attacker is not the taret itself
				if caster ~= target and target:HasModifier("modifier_imba_invoker_cold_snap") then
					local freeze_duration 			= ability:GetLevelSpecialValueFor("freeze_duration", quas_level) 
					local freeze_cooldown 			= ability:GetLevelSpecialValueFor("freeze_cooldown", quas_level) 
					local freeze_damage 			= ability:GetLevelSpecialValueFor("freeze_damage", quas_level)
					local damage_trigger 			= ability:GetSpecialValueFor("damage_trigger")

					-- If target is dealt enought damage to trigger cold_snap and the effect is not on cooldown...
					if kv.damage >= damage_trigger and not target:HasModifier("modifier_imba_invoker_cold_snap_cooldown") and target:IsAlive() then
						target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_stun_duration", {duration = freeze_duration * (1 - target:GetStatusResistance())}) 
						target:AddNewModifier(caster, ability, "modifier_imba_invoker_cold_snap_cooldown", {duration = freeze_cooldown * (1 - target:GetStatusResistance())})

						-- Apply damage
						local damage_table 			= {}
						damage_table.attacker 		= caster
						damage_table.victim 		= target
						damage_table.ability 		= ability
						damage_table.damage_type 	= ability:GetAbilityDamageType() 
						damage_table.damage 		= freeze_damage
						ApplyDamage(damage_table)
					end
				end
			end
		end

		---------------------------------------------------------------------------------------------------------------------
		--	Cold Snap cooldown modifier - dummy modifier, used to check if coldsnap proc is on cooldown
		---------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_cold_snap_cooldown = class({})
		function modifier_imba_invoker_cold_snap_cooldown:IsHidden() 	return true  end
		function modifier_imba_invoker_cold_snap_cooldown:IsPurgable() 	return false end

		---------------------------------------------------------------------------------------------------------------------
		--	Cold Snap stun modifier
		---------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_cold_snap_stun_duration = class({})
		function modifier_imba_invoker_cold_snap_stun_duration:IsDebuff() 		return true  end
		function modifier_imba_invoker_cold_snap_stun_duration:IsPurgable() 	return false end
		function modifier_imba_invoker_cold_snap_stun_duration:IsHidden() 		return true  end
		function modifier_imba_invoker_cold_snap_stun_duration:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf" end
		function modifier_imba_invoker_cold_snap_stun_duration:OnCreated(kv) 
			if IsServer() then
				local target 	 = self:GetParent()		
				self.stun_effect = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)

				-- Play ColdSnap Freeze sound
				target:EmitSound("Hero_Invoker.ColdSnap.Freeze")
			end
		end

		function modifier_imba_invoker_cold_snap_stun_duration:CheckState()
			local state = {
				[MODIFIER_STATE_STUNNED] = true,
				[MODIFIER_STATE_FROZEN] = true,
			}
			return state
		end

		function modifier_imba_invoker_cold_snap_stun_duration:OnRemoved()
			if IsServer() then
				if self.stun_effect ~= nil then
					ParticleManager:DestroyParticle(self.stun_effect, false)
				end
			end
		end

		---------------------------------------------------------------------------------------------------------------------
		--	Cold Snap friendly modifier
		---------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_cold_snap_buff = class({})
		function modifier_imba_invoker_cold_snap_buff:IsDebuff() 		return false end
		function modifier_imba_invoker_cold_snap_buff:IsHidden() 		return false end
		function modifier_imba_invoker_cold_snap_buff:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf" end
		function modifier_imba_invoker_cold_snap_buff:DeclareFunctions()
			local funcs = {
				MODIFIER_EVENT_ON_ATTACK_LANDED
			}
			
			return funcs
		end

		function modifier_imba_invoker_cold_snap_buff:OnAttackLanded(kv)
			if IsServer() then 
				local attacker = kv.attacker
				local target = kv.target

				if target == self:GetParent() and attacker:GetTeam() ~= self:GetCaster():GetTeam() and attacker ~= self:GetParent() and not attacker:IsOther() and not attacker:IsBuilding() and not attacker:IsMagicImmune() then
					attacker:AddNewModifier(self.caster, self.ability, "modifier_imba_invoker_cold_snap_stun_duration", {duration = self.freeze_duration * (1 - attacker:GetStatusResistance())}) 

					-- Apply damage
					local damage_table 			= {}
					damage_table.attacker 		= self.caster
					damage_table.victim 		= attacker
					damage_table.ability 		= self.ability
					damage_table.damage_type 	= self.ability:GetAbilityDamageType() 
					damage_table.damage 		= self.freeze_damage
					ApplyDamage(damage_table)
				end
			end
		end

		function modifier_imba_invoker_cold_snap_buff:OnCreated(kv) 
			if IsServer() then
				self.caster 			= self:GetCaster()
				self.ability 			= self:GetAbility()
				self.quas_level 		= self.caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				self.freeze_duration	= self.ability:GetLevelSpecialValueFor("freeze_duration", self.quas_level) 
				self.freeze_damage 		= self.ability:GetLevelSpecialValueFor("freeze_damage", self.quas_level)
			end
		end



	---------------------------------------------------------------------------------------------------------------------
	--	Invoker's Ghost Walk
	---------------------------------------------------------------------------------------------------------------------
		LinkLuaModifier("modifier_imba_invoker_ghost_walk", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

		imba_invoker_ghost_walk = class({})

		function imba_invoker_ghost_walk:GetCastAnimation()
			return ACT_DOTA_CAST_GHOST_WALK
		end

		function imba_invoker_ghost_walk:OnSpellStart()
			if IsServer() then
				local caster 						= self:GetCaster()
				local ability 						= caster:FindAbilityByName("imba_invoker_ghost_walk")

				-- Get skill stats
				local ghost_walk_duration 			= ability:GetSpecialValueFor("duration")
				local area_of_effect 				= ability:GetSpecialValueFor("area_of_effect") 
				local aura_fade_time 				= ability:GetSpecialValueFor("aura_fade_time")
				local invis_fade_time 				= ability:GetSpecialValueFor("invis_fade_time")
				local quas_level 					= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local wex_level 					= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1
				local self_slow 					= ability:GetLevelSpecialValueFor("self_slow", wex_level)
				local enemy_slow 					= ability:GetLevelSpecialValueFor("enemy_slow", quas_level)
				local aura_think_interval 			= ability:GetSpecialValueFor("aura_update_interval")		
				local increase_max_movement_speed 	= ability:GetSpecialValueFor("increase_max_movement_speed")		
				
				caster:StartGesture(ACT_DOTA_CAST_GHOST_WALK)
				
				-- Play Ghost Walk sound
				caster:EmitSound("Hero_Invoker.GhostWalk")

				-- Add Ghost Walk modifier
				caster:AddNewModifier(caster, self, "modifier_imba_invoker_ghost_walk", {	duration 			= ghost_walk_duration, 
																							self_slow 			= self_slow, 
																							enemy_slow 			= enemy_slow,
																							max_movement_speed 	= max_movement_speed,
																							aura_fade_time 		= aura_fade_time,
																							aura_think_interval = aura_think_interval,
																							area_of_effect 		= area_of_effect,
																							invis_fade_time 	= invis_fade_time})
				-- stats for client... should i replace with multiple modifiers?
				CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { 	ghost_walk_self_slow = self_slow, 
																										ghost_walk_enemy_slow = enemy_slow})
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Ghost Walk - self-modifier
		---------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_ghost_walk = class({})
		LinkLuaModifier("modifier_invis_fade_ghost_walk", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_ghost_walk_aura", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function modifier_imba_invoker_ghost_walk:IsHidden() 		return false end
		function modifier_imba_invoker_ghost_walk:IsPurgable() 		return false end
		function modifier_imba_invoker_ghost_walk:IsDebuff() 		return false end
		function modifier_imba_invoker_ghost_walk:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf" end
		function modifier_imba_invoker_ghost_walk:DeclareFunctions()
			return {
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
				MODIFIER_EVENT_ON_ATTACK,
				MODIFIER_EVENT_ON_ABILITY_EXECUTED,
				MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
				MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			}
		end

		function modifier_imba_invoker_ghost_walk:GetModifierIgnoreMovespeedLimit()
			return 1
		end

		function modifier_imba_invoker_ghost_walk:CheckState()
			return {
				[MODIFIER_STATE_INVISIBLE] 			= true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
			}
		end

		function modifier_imba_invoker_ghost_walk:GetPriority()
			return MODIFIER_PRIORITY_NORMAL
		end

		function modifier_imba_invoker_ghost_walk:GetModifierInvisibilityLevel()
			return 100
		end

		function modifier_imba_invoker_ghost_walk:OnCreated(kv) 
			if IsServer() then 
				self.caster 				= self:GetCaster()
				self.parent 				= self:GetParent()
				self.area_of_effect 		= kv.area_of_effect
				self.aura_fade_time 		= kv.aura_fade_time
				self.enemy_slow 			= kv.enemy_slow
				self.self_slow 				= kv.self_slow
				self.ghost_walk_fade_time 	= kv.invis_fade_time
				self.max_movement_speed 	= kv.max_movement_speed

				-- self:StartIntervalThink(kv.aura_think_interval)
			else
				-- Set client-value for self_slow
				local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetParent():GetPlayerOwnerID())) or {}
				self.self_slow = net_table.ghost_walk_self_slow
			end
		end

		function modifier_imba_invoker_ghost_walk:OnRefresh(kv) 
			if IsServer() then
				self.area_of_effect 		= kv.area_of_effect
				self.aura_fade_time 		= kv.aura_fade_time
				self.enemy_slow 			= kv.enemy_slow
				self.self_slow 				= kv.self_slow
				self.ghost_walk_fade_time 	= kv.invis_fade_time
			end
		end

		-- function modifier_imba_invoker_ghost_walk:OnIntervalThink()
			-- if IsServer() then
				-- local nearby_enemy_units = FindUnitsInRadius(	
					-- self.caster:GetTeam(), 
					-- self.caster:GetAbsOrigin(), 
					-- nil, 
					-- self.area_of_effect, 
					-- DOTA_UNIT_TARGET_TEAM_ENEMY,
					-- DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					-- DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, 
					-- FIND_ANY_ORDER, 
					-- false)

				-- if nearby_enemy_units ~= nil then
					-- for _,enemy in pairs(nearby_enemy_units) do
						-- if enemy ~= self.parent then
							-- enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_imba_invoker_ghost_walk_aura", {duration = self.aura_fade_time, enemy_slow = self.enemy_slow})
						-- end
					-- end
				-- end
			-- end
		-- end

		function modifier_imba_invoker_ghost_walk:OnAttack(kv)
			if IsServer() then	
				-- Only break ghost_walk if invoker is attacking
				if self.parent == kv.attacker then
					if self.caster:HasModifier("modifier_imba_invoker_ghost_walk") then
						self.caster:RemoveModifierByName("modifier_imba_invoker_ghost_walk")
					end
				end
			end
		end

		function modifier_imba_invoker_ghost_walk:OnAbilityExecuted(kv)
			if IsServer() then
				local caster = kv.unit
				-- Only break ghost_walk if invoker executed an ability
				if self.parent == caster then 
					if caster:HasModifier("modifier_imba_invoker_ghost_walk") then
						self.caster:RemoveModifierByName("modifier_imba_invoker_ghost_walk")
						-- Becuz it's OP! The intended functionality here is to be able to cast a spell and immediatly reapply ghost walk.
						-- This will also let us invoke another spell before we are visible... rat-doto engaged!
						caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_invis_fade_ghost_walk", {duration = self.ghost_walk_fade_time})
					end
				end
			end
		end

		function modifier_imba_invoker_ghost_walk:GetModifierMoveSpeedBonus_Percentage()
			return self.self_slow
		end
		
		function modifier_imba_invoker_ghost_walk:IsAura() 					return true end
		function modifier_imba_invoker_ghost_walk:GetModifierAura()			return "modifier_imba_invoker_ghost_walk_aura" end

		function modifier_imba_invoker_ghost_walk:GetAuraRadius()			return self.area_of_effect end
		function modifier_imba_invoker_ghost_walk:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
		function modifier_imba_invoker_ghost_walk:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_ENEMY end
		function modifier_imba_invoker_ghost_walk:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

		function modifier_imba_invoker_ghost_walk:IsAuraActiveOnDeath() 	return false end
		function modifier_imba_invoker_ghost_walk:GetAuraDuration()			return self.aura_fade_time end

		--------------------------------------------------------------------------------------------------------------------
		--	Ghost Walk - fade-invis-modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_invis_fade_ghost_walk = class({})
		function modifier_invis_fade_ghost_walk:IsHidden() 		return false end
		function modifier_invis_fade_ghost_walk:IsPurgable() 	return false end
		function modifier_invis_fade_ghost_walk:IsDebuff() 		return false end
		function modifier_invis_fade_ghost_walk:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_INVISIBILITY_LEVEL
			}
			
			return funcs
		end
		function modifier_invis_fade_ghost_walk:CheckState()
			local state = {
				[MODIFIER_STATE_INVISIBLE] 			= true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
			}
			return state
		end

		function modifier_invis_fade_ghost_walk:GetPriority()
			return MODIFIER_PRIORITY_NORMAL
		end

		function modifier_invis_fade_ghost_walk:GetModifierInvisibilityLevel()
			return 100
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Ghost Walk - SlowAura
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_ghost_walk_aura = class({})
		function modifier_imba_invoker_ghost_walk_aura:IsHidden() 		return false end
		function modifier_imba_invoker_ghost_walk_aura:IsPurgable() 	return false end
		function modifier_imba_invoker_ghost_walk_aura:IsDebuff() 		return true  end
		function modifier_imba_invoker_ghost_walk_aura:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf" end
		function modifier_imba_invoker_ghost_walk_aura:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
			}
			
			return funcs
		end

		function modifier_imba_invoker_ghost_walk_aura:OnCreated(kv)
			if IsServer() then
				self.caster 		= self:GetCaster()
				self.parent 		= self:GetParent()

				-- Check that target is not invoker himself.
				if self.caster ~= self.parent then
					-- Apply Ghost Walk aura effect
					self.ghost_walk_effect_frost = ParticleManager:CreateParticle("particles/status_fx/status_effect_frost.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				end
				
				local quas_level 					= self.caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				self.enemy_slow 					= self:GetAbility():GetLevelSpecialValueFor("enemy_slow", quas_level)
				
				self:SetStackCount(self.enemy_slow)
			-- else
				-- -- Set client-value for self_slow
				-- local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
				-- self.enemy_slow = net_table.ghost_walk_enemy_slow
			end
		end

		-- function modifier_imba_invoker_ghost_walk_aura:OnRefresh(kv) 
			-- if IsServer() then
				-- self.enemy_slow = kv.enemy_slow
			-- else
				-- local net_table = CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
				-- self.enemy_slow = net_table.ghost_walk_enemy_slow
			-- end
		-- end

		function modifier_imba_invoker_ghost_walk_aura:OnRemoved()
			if IsServer() then	
				if self.ghost_walk_effect_frost ~= nil then
					ParticleManager:DestroyParticle(self.ghost_walk_effect_frost, false)
				end
			end
		end
		
		function modifier_imba_invoker_ghost_walk_aura:GetModifierMoveSpeedBonus_Percentage()
			return self:GetStackCount()
		end
		
	--------------------------------------------------------------------------------------------------------------------
	--	Invoker's Alacrity
	--------------------------------------------------------------------------------------------------------------------
		imba_invoker_alacrity = class({})
		imba_invoker_alacrity.ability_effect_path 	= "particles/hero/invoker/alacrity/imba_invoker_alacrity.vpcf"
		imba_invoker_alacrity.buff_effect_path 		= "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf"
		LinkLuaModifier("modifier_imba_invoker_alacrity", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function imba_invoker_alacrity:GetCastAnimation()
			return ACT_DOTA_CAST_ALACRITY
		end

		function imba_invoker_alacrity:OnSpellStart()
			if IsServer() then
				local caster 				= self:GetCaster()
				local target 				= self:GetCursorTarget() 
				local ability 				= self

				-- Get skill stats
				local wex_level 			= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1
				local exort_level 			= caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				local alacrity_duration 	= ability:GetSpecialValueFor("duration")
				local bonus_attack_speed 	= ability:GetLevelSpecialValueFor("bonus_attack_speed", wex_level)
				local bonus_damage 			= ability:GetLevelSpecialValueFor("bonus_damage", exort_level)

				-- Play Alacrity Sound!
				EmitSoundOn("Hero_Invoker.Alacrity", caster)

				if caster:HasTalent("imba_special_bonus_unique_invoker_6") and target == caster then 
					for _,hero in pairs(HeroList:GetAllHeroes()) do
						if hero == caster then 
							hero:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
							duration = alacrity_duration * 2, 
							bonus_attack_speed = bonus_attack_speed, 
							bonus_damage = bonus_damage})
						elseif hero:GetTeam() == caster:GetTeam() then
							hero:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
							duration = alacrity_duration, 
							bonus_attack_speed = bonus_attack_speed, 
							bonus_damage = bonus_damage})
						end
					end	

					-- Set Cooldown, account for cooldown reductions
					local cooldown 					= caster:FindTalentValue("imba_special_bonus_unique_invoker_6", "alacrity_cooldown")
					local current_cooldown 			= ability:GetCooldownTime()
					local unaltered_cooldown 		= ability:GetCooldown(1)
					local cooldown_reduction_pct 	= current_cooldown / unaltered_cooldown
					ability:StartCooldown(cooldown * cooldown_reduction_pct)
				else
					target:AddNewModifier(caster, ability, "modifier_imba_invoker_alacrity", {
						duration = alacrity_duration, 
						bonus_attack_speed = bonus_attack_speed, 
						bonus_damage = bonus_damage})
				end

				-- Set client-values for alacrity
				CustomNetTables:SetTableValue("player_table", tostring(caster:GetPlayerOwnerID()), { alacrity_bonus_damage = bonus_damage, alacrity_attack_speed = bonus_attack_speed,})
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's Alacrity modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_alacrity = class({})
		function modifier_imba_invoker_alacrity:IsHidden() 		return false end
		function modifier_imba_invoker_alacrity:IsPurgable() 	return false end
		function modifier_imba_invoker_alacrity:IsBuff() 		return true  end
		function modifier_imba_invoker_alacrity:GetEffectName() return imba_invoker_alacrity.ability_effect_path end
		function modifier_imba_invoker_alacrity:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
				MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				MODIFIER_EVENT_ON_ATTACK_LANDED
			}

			return funcs
		end

		function modifier_imba_invoker_alacrity:OnCreated(kv)
			if IsServer() then
				self.parent 			= self:GetParent()
				self.ability 			= self:GetAbility()
				self.number_of_chains 	= self.ability:GetSpecialValueFor("number_of_chains")

				self.alacrity_effect 	= ParticleManager:CreateParticle(imba_invoker_alacrity.buff_effect_path, PATTACH_OVERHEAD_FOLLOW, self.parent)

				self.bonus_damage 		= kv.bonus_damage
				self.bonus_attack_speed = kv.bonus_attack_speed

			else
				local net_table 		= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
				self.bonus_damage 		= net_table.alacrity_bonus_damage or 0
				self.bonus_attack_speed = net_table.alacrity_attack_speed or 0
			end
		end

		function modifier_imba_invoker_alacrity:OnAttackLanded(kv)
			if IsServer() then
				local parent = self:GetParent()
				if kv.attacker == parent and ( not parent:IsIllusion() ) then

					local caster 			= self:GetCaster()
					local target 			= kv.target

					if parent:IsRangedAttacker() then 
						modifier_imba_invoker_alacrity:Ranged_Chain_Attack(caster, parent, self.ability, kv.target, kv.damage, self.number_of_chains) 
					else
						modifier_imba_invoker_alacrity:Melee_Chain_lightning(caster, parent, self.ability, kv.target, kv.damage, self.number_of_chains) 			
					end
				end
			end
		end

		function modifier_imba_invoker_alacrity:Ranged_Chain_Attack(caster, attacker, ability, target, damage, chains) 
			if IsServer() then 
				if chains ~= nil and chains > 0 then
					local chain_particle = attacker:GetRangedProjectileName()
					local chain_distance = ability:GetSpecialValueFor("chain_distance")

					-- Find enemy to chain too
					local chain_enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, chain_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					for _,enemy in pairs(chain_enemies) do
						if enemy ~= target then 

							chains = chains - 1 
							local attack_projectile
							attack_projectile = {
								Target = enemy,
								Source = target,
								Ability = ability,
								EffectName = chain_particle,
								iMoveSpeed = 1200,
								bDodgeable = true,
								bVisibleToEnemies = true,
								bReplaceExisting = false,
								bProvidesVision = false,
								ExtraData = {damage = damage, attacker = attacker:entindex(), chains = chains}
							}

							ProjectileManager:CreateTrackingProjectile(attack_projectile)
							return
						end
					end
				end
			end
		end

		function imba_invoker_alacrity:OnProjectileHit_ExtraData(target, location, ExtraData) 
			if IsServer() then 
				local ability 			= self
				local chains 			= ExtraData.chains
				local attacker 			= EntIndexToHScript(ExtraData.attacker)
				local chain_distance 	= ability:GetSpecialValueFor("chain_distance")

						-- Apply damage
				local damage_table = {}
				damage_table.attacker = attacker
				damage_table.victim = target
				damage_table.ability = ability
				damage_table.damage_type = DAMAGE_TYPE_MAGICAL
				damage_table.damage = (ExtraData.damage / 100) * ability:GetSpecialValueFor("chain_damage_pct")
				ApplyDamage(damage_table)

				if chains ~= nil and chains > 0 then
					local caster 			= self:GetCaster()
					local chain_particle 	= attacker:GetRangedProjectileName()

					-- Find enemy to chain too
					local chain_enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, chain_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					for _,enemy in pairs(chain_enemies) do
						if enemy ~= target then 
							chains = chains - 1
							local attack_projectile
							attack_projectile = {
								Target = enemy,
								Source = target,
								Ability = ability,
								EffectName = chain_particle,
								iMoveSpeed = 1200,
								bDodgeable = true,
								bVisibleToEnemies = true,
								bReplaceExisting = false,
								bProvidesVision = false,
								ExtraData = {damage = ExtraData.damage, attacker = ExtraData.attacker, chains}
							}

							ProjectileManager:CreateTrackingProjectile(attack_projectile)
							return
						end
					end			
				end
			end
		end

		function modifier_imba_invoker_alacrity:Melee_Chain_lightning(caster, attacker, ability, target, damage, chains) 
			if IsServer() then 

				if chains < ability:GetSpecialValueFor("number_of_chains") then
					-- Apply damage
					local damage_table = {}
					damage_table.attacker = attacker
					damage_table.victim = target
					damage_table.ability = ability
					damage_table.damage_type = DAMAGE_TYPE_MAGICAL
					damage_table.damage = (damage / 100) * ability:GetSpecialValueFor("chain_damage_pct")
					ApplyDamage(damage_table)
				end

				if chains ~= nil and chains > 0 then
					local chain_particle 	= "particles/hero/invoker/alacrity/imba_invoker_alacrity_chain_lightning.vpcf"
					local chain_distance 	= ability:GetSpecialValueFor("chain_distance")

					-- Find enemy to chain too
					local chain_enemies = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, chain_distance, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
					for _,enemy in pairs(chain_enemies) do
						if enemy ~= target then 

							local chain_pfx = ParticleManager:CreateParticle(chain_particle, PATTACH_WORLDORIGIN, target)
							ParticleManager:SetParticleControl(chain_pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y , target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))   
							ParticleManager:SetParticleControl(chain_pfx, 1, Vector(enemy:GetAbsOrigin().x, enemy:GetAbsOrigin().y, enemy:GetAbsOrigin().z + enemy:GetBoundingMaxs().z ))
							ParticleManager:ReleaseParticleIndex(chain_pfx)

							chains = chains - 1
							modifier_imba_invoker_alacrity:Melee_Chain_lightning(caster, attacker, ability, enemy, damage, chains) 
							return
						end
					end
				end
			end
		end

		function modifier_imba_invoker_alacrity:OnRemoved()
			if IsServer() then
				if self.alacrity_effect ~= nil then
					ParticleManager:DestroyParticle(self.alacrity_effect, false)
				end
			end
		end

		function modifier_imba_invoker_alacrity:OnRefresh(kv)
			if IsServer() then
				self.bonus_damage 		= kv.bonus_damage
				self.bonus_attack_speed = kv.bonus_attack_speed
			else
				local net_table 		= CustomNetTables:GetTableValue("player_table", tostring(self:GetCaster():GetPlayerOwnerID())) or {}
				self.bonus_damage 		= net_table.alacrity_bonus_damage or 0
				self.bonus_attack_speed = net_table.alacrity_attack_speed or 0
			end
		end


		function modifier_imba_invoker_alacrity:GetModifierAttackSpeedBonus_Constant()
			return self.bonus_attack_speed 
		end

		function modifier_imba_invoker_alacrity:GetModifierPreAttack_BonusDamage()
			return self.bonus_damage
		end



	--------------------------------------------------------------------------------------------------------------------
	--	Invoker's Forge Spirit
	--------------------------------------------------------------------------------------------------------------------
		LinkLuaModifier("modifier_imba_invoker_forge_spirit", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

		imba_invoker_forge_spirit = class({})

		function imba_invoker_forge_spirit:GetCastAnimation()
			return ACT_DOTA_CAST_FORGE_SPIRIT
		end

		function imba_invoker_forge_spirit:OnSpellStart()
			if IsServer() then
				local caster 		= self:GetCaster()
				local ability 		= caster:FindAbilityByName("imba_invoker_forge_spirit")
				local quas_level 	= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local exort_level 	= caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				local spirit_name 	= "npc_dota_invoker_forged_spirit"
				local spirit_level 	= 3;

				-- Get skill stats
				local spirit_damage 		= ability:GetLevelSpecialValueFor("spirit_damage", exort_level) 
				local spirit_hp 			= ability:GetLevelSpecialValueFor("spirit_hp", quas_level) 
				local spirit_armor 			= ability:GetLevelSpecialValueFor("spirit_armor", exort_level) 
				local spirit_attack_range 	= ability:GetLevelSpecialValueFor("spirit_attack_range", quas_level) 
				local spirit_mana 			= ability:GetLevelSpecialValueFor("spirit_mana", exort_level) 
				local spirit_duration 		= ability:GetLevelSpecialValueFor("spirit_duration", quas_level) 
				local spirit_count_quas 	= ability:GetLevelSpecialValueFor("spirit_count", quas_level)
				local spirit_count_exort 	= ability:GetLevelSpecialValueFor("spirit_count", exort_level)

				-- Initialize array
				if ability.forged_spirits == nil then
					ability.forged_spirits = {}
				end

				-- Play ForgeSpirit sound
				caster:EmitSound("Hero_Invoker.ForgeSpirit")

				-- Calculate number of additional spirits we can summon
				local spirit_count
				if spirit_count_quas < spirit_count_exort then
					spirit_count = spirit_count_quas
				else
					spirit_count = spirit_count_exort
				end

				if caster:HasTalent("imba_special_bonus_unique_invoker_3") then
					local additional_spirits 	= caster:FindTalentValue("imba_special_bonus_unique_invoker_3","additional_spirits")
					spirit_count 				= spirit_count + additional_spirits

					local reduced_duration 		= caster:FindTalentValue("imba_special_bonus_unique_invoker_3","reduced_duration")
					spirit_duration				= spirit_duration - reduced_duration
				end


				-- We dont kill off old spirits... 
				-- the limited duration and our enemies will handle that...
				-- Tho we do need to cleanup dead spirits
				local updated_spirit_array = {}
				for _,spirit in pairs(ability.forged_spirits) do
					-- lua will delete the reference in our array uppon death
					if not spirit:IsNull() then 
						table.insert(updated_spirit_array, spirit)
					end
				end

				-- Replace old array
				ability.forged_spirits = updated_spirit_array

				-- Summon new Spirits
				for i = 1, spirit_count do
					local forged_spirit = CreateUnitByName(spirit_name, caster:GetAbsOrigin() + RandomVector(100), true, caster, caster, caster:GetTeamNumber())

					if caster.bPersona then
						forged_spirit:SetOriginalModel("models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl")
						forged_spirit:SetModel("models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl")
						forged_spirit:SetRangedProjectileName("particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf")
					end

					-- Remove forge_spirit's base ability and add IMBA molten strike
					--forged_spirit:RemoveAbility("forged_spirit_melting_strike")
					forged_spirit:AddAbility("imba_forged_spirit_melting_strike") 
					forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):SetLevel(1)	
					forged_spirit:AddAbility("imba_forged_spirit_death") 
					forged_spirit:FindAbilityByName("imba_forged_spirit_death"):SetLevel(1)	

					-- Apply stats to spirit
					local melt_duration 		= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("duration") 
					local max_armor_removed 	= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("max_armor_removed") 
					local melt_armor_removed 	= forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetSpecialValueFor("armor_removed") 
					local melt_strike_mana_cost = forged_spirit:FindAbilityByName("imba_forged_spirit_melting_strike"):GetManaCost(1)

					forged_spirit:AddNewModifier(
						caster, 
						self, 
						"modifier_imba_invoker_forge_spirit", 
						{	
							duration = spirit_duration, 
							melt_duration = melt_duration, 
							melt_armor_removed = melt_armor_removed,
							melt_strike_mana_cost = melt_strike_mana_cost, 
							max_armor_removed = max_armor_removed
						}
					)

					forged_spirit:AddNewModifier(caster, self, "modifier_kill", {duration = spirit_duration})
					forged_spirit:AddNewModifier(caster, self, "modifier_phased", {duration = 0.03})
					forged_spirit:SetUnitOnClearGround()
					forged_spirit:SetManaGain(spirit_mana);
					forged_spirit:CreatureLevelUp(1)

					-- Set spirit base_damage
					forged_spirit:SetBaseDamageMin(spirit_damage) 
					forged_spirit:SetBaseDamageMax(spirit_damage)
					-- Set spirit health 
					forged_spirit:SetBaseMaxHealth(spirit_hp)
					forged_spirit:SetPhysicalArmorBaseValue(spirit_armor)
					
					forged_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
					-- Add summoned spirit to array
					table.insert(ability.forged_spirits, forged_spirit)
				end
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Forge Spirit modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_forge_spirit = class({})
		LinkLuaModifier("modifier_imba_forged_spirit_melting_strike", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function modifier_imba_invoker_forge_spirit:IsHidden() 	return true end
		function modifier_imba_invoker_forge_spirit:IsPassive() return true end
		function modifier_imba_invoker_forge_spirit:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
				MODIFIER_EVENT_ON_ATTACK_LANDED
			}
			
			return funcs
		end

		function modifier_imba_invoker_forge_spirit:OnCreated(kv)
			if IsServer() then
				self.caster					= self:GetCaster()
				self.ability 				= self:GetAbility()
				self.parent 				= self:GetParent()
				local quas_level 			= self.caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local exort_level 			= self.caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				self.spirit_attack_range 	= self.ability:GetLevelSpecialValueFor("spirit_attack_range", quas_level) 
				self.death_damage 			= self.ability:GetLevelSpecialValueFor("death_damage", exort_level) 
				self.death_radius			= self.ability:GetSpecialValueFor("death_radius")
				self.melt_duration 			= kv.melt_duration
				self.melt_strike_mana_cost  = kv.melt_strike_mana_cost
				self.max_armor_removed 		= kv.max_armor_removed
				self.melt_armor_removed 	= kv.melt_armor_removed
				self:SetStackCount(self.spirit_attack_range) 	
			end
		end

		function modifier_imba_invoker_forge_spirit:OnAttackLanded(kv)
			if IsServer() then
				local attacker = kv.attacker
				local target = kv.target

				if attacker == self.parent and target:IsHero() or target:IsIllusion() then
					if attacker:GetMana() >= self.melt_strike_mana_cost then
						if target:HasModifier("modifier_imba_forged_spirit_melting_strike") then
							debuff_count = target:GetModifierStackCount("modifier_imba_forged_spirit_melting_strike", self.caster)
							if debuff_count > self.max_armor_removed then
								debuff_count = self.max_armor_removed
							end
						end

						target:AddNewModifier(
							self.parent, 
							self.ability, 
							"modifier_imba_forged_spirit_melting_strike", 
							{
								duration = self.melt_duration * (1 - target:GetStatusResistance()), 
								max_armor_removed = self.max_armor_removed,
								melt_strike_mana_cost = self.melt_strike_mana_cost,
								melt_armor_removed = self.melt_armor_removed
							})

					end
				end
			end
		end

		function modifier_imba_invoker_forge_spirit:GetModifierAttackRangeBonus()
			return self:GetStackCount() 
		end

		function modifier_imba_invoker_forge_spirit:OnRemoved()
			if IsServer() then 
				local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf"
				local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_WORLDORIGIN, nil )
				local attach_point = self:GetParent():ScriptLookupAttachment( "attach_hitloc" )
				ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAttachmentOrigin(attach_point) )
				ParticleManager:SetParticleControl( pfx, 1, self:GetParent():GetAttachmentOrigin(attach_point) )
				ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAttachmentOrigin(attach_point) )
				ParticleManager:ReleaseParticleIndex(pfx)

				local nearby_enemy_units = FindUnitsInRadius(
						self.caster:GetTeam(),
						self:GetParent():GetAbsOrigin(), 
						nil, 
						self.death_radius, 
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
						DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 
						FIND_ANY_ORDER, 
						false)

				if nearby_enemy_units ~= nil then
					for _,enemy in pairs(nearby_enemy_units) do
						-- Apply damage
						local damage_table = {}
						damage_table.attacker = self.caster
						damage_table.victim = enemy
						damage_table.ability = self.ability
						damage_table.damage_type = DAMAGE_TYPE_MAGICAL
						damage_table.damage = self.death_damage
						ApplyDamage(damage_table)			
					end
				end
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Forge Spirit's Meling Strike
		--------------------------------------------------------------------------------------------------------------------
		imba_forged_spirit_melting_strike = class({})
		function imba_forged_spirit_melting_strike:OnSpellStart()
		end

		modifier_imba_forged_spirit_melting_strike = class({})
		function modifier_imba_forged_spirit_melting_strike:IsHidden() return false end
		function modifier_imba_forged_spirit_melting_strike:IsDebuff() return true  end
		function modifier_imba_forged_spirit_melting_strike:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
			}
			
			return funcs
		end

		function modifier_imba_forged_spirit_melting_strike:OnCreated(kv)
			if IsServer() then
				self.max_armor_removed 		= kv.max_armor_removed
				self.melt_strike_mana_cost 	= kv.melt_strike_mana_cost
				self.melt_armor_removed 	= kv.melt_armor_removed
				self:SetStackCount(self.melt_armor_removed)
			end
		end

		function modifier_imba_forged_spirit_melting_strike:OnRefresh(kv)
			if IsServer() then
				local curr_stacks = self:GetStackCount()
				if curr_stacks + self.melt_armor_removed < self.max_armor_removed then
					self:SetStackCount(curr_stacks + self.melt_armor_removed)
					self:GetCaster():SpendMana(self.melt_strike_mana_cost, nil)
				end
			end
		end

		function modifier_imba_forged_spirit_melting_strike:GetModifierPhysicalArmorBonus()
			return self:GetStackCount() * -1
		end	

		--------------------------------------------------------------------------------------------------------------------
		-- Forge Spirit's Death Explosion
		--------------------------------------------------------------------------------------------------------------------
		imba_forged_spirit_death = class({})
		function imba_forged_spirit_death:IsHidden() return false end
		function imba_forged_spirit_death:IsPassive() return true end

	--------------------------------------------------------------------------------------------------------------------
	--	Invoker's: Tornado
	--------------------------------------------------------------------------------------------------------------------
		imba_invoker_tornado = class({})
		imba_invoker_tornado.loop_interval = 0.03
		imba_invoker_tornado.ability_effect_path 			= "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
--		imba_invoker_tornado.ability_effect_path 			= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
		imba_invoker_tornado.ability_effect_cyclone_path 	= "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf"
--		imba_invoker_tornado.ability_effect_cyclone_path 	= "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf"
		LinkLuaModifier("modifier_imba_invoker_tornado", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_tornado_cyclone", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_tornado_empower_debuff", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function imba_invoker_tornado:GetCooldown(invoke_level)
			if self:GetCaster():HasTalent("imba_special_bonus_unique_invoker_8") then 
				local cooldown = self.BaseClass.GetCooldown(self, invoke_level) - self:GetCaster():FindTalentValue("imba_special_bonus_unique_invoker_8", "cooldown_reduction")
				return cooldown
			else
				return self.BaseClass.GetCooldown(self, invoke_level)
			end
		end

		function imba_invoker_tornado:GetCastAnimation()
			return ACT_DOTA_CAST_TORNADO
		end

		function imba_invoker_tornado:OnSpellStart()
			if IsServer() then 
				local caster 					= self:GetCaster()
				local ability 					= caster:FindAbilityByName("imba_invoker_tornado")
				local caster_location 			= caster:GetAbsOrigin() 

				-- Get skill stats
				local quas_level 				= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local wex_level 				= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1
				local tornado_travel_distance 	= ability:GetLevelSpecialValueFor("travel_distance", wex_level)
				local wex_land_damage 			= ability:GetLevelSpecialValueFor("wex_damage", wex_level)
				local tornado_lift_duration  	= ability:GetLevelSpecialValueFor("lift_duration", quas_level)
				local area_of_effect 			= ability:GetSpecialValueFor("area_of_effect")
				local base_damage 				= ability:GetSpecialValueFor("base_damage")
				local travel_speed 				= ability:GetSpecialValueFor("travel_speed")
				local end_vision_duration 		= ability:GetSpecialValueFor("end_vision_duration")
				local vision_distance 			= ability:GetSpecialValueFor("vision_distance")
				local cyclone_initial_height 	= ability:GetSpecialValueFor("cyclone_initial_height")
				local cyclone_min_height 		= ability:GetSpecialValueFor("cyclone_min_height")
				local cyclone_max_height 		= ability:GetSpecialValueFor("cyclone_max_height")
				local tornado_duration 			= tornado_travel_distance / travel_speed
				local daze_duration 			= 0

				-- Do we have empowered tornado talent?
				if caster:HasTalent("imba_special_bonus_unique_invoker_8") then
					-- Set Cooldown, account for cooldown reductions
					local current_cooldown 			= ability:GetCooldownTime()
					local unaltered_cooldown 		= ability:GetCooldown(1)
					local cooldown_reduction_pct 	= current_cooldown / unaltered_cooldown
					ability:StartCooldown(unaltered_cooldown * cooldown_reduction_pct)

					daze_duration = caster:FindTalentValue("imba_special_bonus_unique_invoker_8", "daze_duration")
				end

				-- Create a dummy unit that will follow the path of the tornado, providing flying vision and sound.
				local tornado_dummy_unit =  CreateModifierThinker(caster, self, nil, {},caster_location, caster:GetTeamNumber(), false)
				-- Play tornado sound 
				tornado_dummy_unit:EmitSound("Hero_Invoker.Tornado")

				-- Create tornado projectile object
				local tornado_projectile_table =  
				{
					EffectName 			= imba_invoker_tornado.ability_effect_path,
					Ability 			= ability,
					vSpawnOrigin 		= caster_location,
					fDistance 			= tornado_travel_distance,
					fStartRadius 		= area_of_effect,
					fEndRadius 			= area_of_effect,
					Source 				= tornado_dummy_unit,
					bHasFrontalCone 	= false,
					iMoveSpeed 			= travel_speed,
					bReplaceExisting 	= false,
					bProvidesVision 	= true,
					iVisionTeamNumber 	= caster:GetTeam(),
					iVisionRadius 		= vision_distance,
					bDrawsOnMinimap 	= false,
					bVisibleToEnemies 	= true, 
					iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
					fExpireTime 		= GameRules:GetGameTime() + tornado_duration + 20,
					ExtraData 			= 	{	tornado_lift_duration 	= tornado_lift_duration, 
												end_vision_duration 	= end_vision_duration,
												base_damage 			= base_damage,
												wex_land_damage			= wex_land_damage,
												cyclone_initial_height 	= cyclone_initial_height,
												cyclone_min_height		= cyclone_min_height,
												cyclone_max_height 		= cyclone_max_height,
												daze_duration 			= daze_duration,
												cyclone_effect_path 	= imba_invoker_tornado.ability_effect_cyclone_path,
												vision_distance 		= vision_distance,
												tornado_dummy_unit 		= tornado_dummy_unit:entindex()
											}
				}

				-- Get cast and target-points and make sure they are at ground level.
				local target_point 					= self:GetCursorPosition()
				local caster_point 					= caster_location 

				-- Normalize the vector for the difference between the points.
				local point_difference_normalized 	= (target_point - caster_point):Normalized()
				
				-- Set direction and travel_speed of Tornado
				local projectile_vvelocity 			= point_difference_normalized * travel_speed
				projectile_vvelocity.z = 0
				tornado_projectile_table.vVelocity 	= projectile_vvelocity
				
				-- Crate the acctual projectile
				local tornado_projectile = ProjectileManager:CreateLinearProjectile(tornado_projectile_table)

			end
		end

		function imba_invoker_tornado:OnProjectileThink_ExtraData(vLocation, ExtraData)
			if IsServer() then 
				EntIndexToHScript(ExtraData.tornado_dummy_unit):SetAbsOrigin(vLocation)
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Tornado On Hit
		--------------------------------------------------------------------------------------------------------------------
		function imba_invoker_tornado:OnProjectileHit_ExtraData(target, location, ExtraData)
			if IsServer() then
				if target ~= nil then 
					local caster 					= self:GetCaster()
					local base_damage 				= ExtraData.base_damage
					local wex_land_damage			= ExtraData.wex_land_damage
					local tornado_lift_duration 	= ExtraData.tornado_lift_duration
					local cyclone_initial_height 	= ExtraData.cyclone_initial_height
					local cyclone_min_height 		= ExtraData.cyclone_min_height
					local cyclone_max_height 		= ExtraData.cyclone_max_height
					local tornado_start 			= GameRules:GetGameTime()
					local vision_distance 			= ExtraData.vision_distance
					local end_vision_duration 		= ExtraData.end_vision_duration
					
					if tornado_lift_duration ~= nil then
						-- Save the target's forward vector so we can put them back facing in the same direction when they land.
						target.invoker_tornado_forward_vector = target:GetForwardVector()
						
						target:AddNewModifier(caster, target, "modifier_imba_invoker_tornado_cyclone", {duration = tornado_lift_duration * (1 - target:GetStatusResistance())})
						local cyclone_effect = ParticleManager:CreateParticle(ExtraData.cyclone_effect_path, PATTACH_ABSORIGIN, target)

						target:EmitSound("Hero_Invoker.Tornado.Target")
						
						-- Flying position variables
						local flying_z_modifier = target:FindModifierByName("modifier_imba_invoker_tornado_cyclone")
						local z_position = 0
						tornado_lift_duration = flying_z_modifier:GetDuration()

						-- 1/10th of the total cyclone duration will be spent ascending and descending to and from the initial height.
						local time_to_reach_initial_height 		= 2/10
						-- This is the height to add every frame when the unit is first cycloned, and applies repeatedly, until the cyclone reaches its max height.
						local initial_ascent_height_per_frame 	= ((cyclone_initial_height) / time_to_reach_initial_height) * imba_invoker_tornado.loop_interval 
						-- This is the height to add or remove every frame while the caster is in up/down cycle motion.
						local up_down_cycle_height_per_frame 	= initial_ascent_height_per_frame / 3  
						-- Cap this value so the unit doesn't jerk up and down for short-duration cyclones.
						if up_down_cycle_height_per_frame > 7.5 then  
							up_down_cycle_height_per_frame = 7.5
						end

						-- This is calculated when the unit begins descending. Basicly the speed by which affected units decend
						local final_descent_height_per_frame = nil  

						-- Time to go down, added 1x0.03 because testing showed we need another frame.
						local time_to_stop_fly = tornado_lift_duration - time_to_reach_initial_height -- imba_invoker_tornado.loop_interval
						-- Loop up and down
						local going_up = true
						-- Loop every frame for the duration
						Timers:CreateTimer(function()
							local time_in_air = GameRules:GetGameTime() - tornado_start
							
							self:spinn({target = target, tornado_lift_duration = tornado_lift_duration})
							-- Throw target unit up in the air towards cyclone's initial height.
							if z_position < cyclone_initial_height and time_in_air <= time_to_reach_initial_height then
								--print("+",initial_ascent_height_per_frame,z_position)
								z_position = z_position + initial_ascent_height_per_frame
								flying_z_modifier:SetStackCount(z_position)
								return imba_invoker_tornado.loop_interval
							-- Go down until the target reaches the ground.
							elseif time_in_air > time_to_stop_fly and time_in_air <= tornado_lift_duration then
								--Since the unit may be anywhere between the cyclone's min and max height values when they start descending to the ground,
								--the descending height per frame must be calculated when that begins, so the unit will end up right on the ground when the duration ends.
								if final_descent_height_per_frame == nil then
									-- distance to ground
									local descent_initial_height_above_ground = cyclone_initial_height
									-- Since (time_to_reach_initial_height / imba_invoker_tornado.loop_interval) will end up in a decimal we will get rounding issues in the loop. 
									-- By using math.floor we discards decimals and gives us the correct value which to divide reamining distance to ground
									local rounding_coeff = math.floor(time_to_reach_initial_height / imba_invoker_tornado.loop_interval)
									-- Final value which we subtracts from unit z-position untill it reaches ground.
									final_descent_height_per_frame = descent_initial_height_above_ground / rounding_coeff
									--print("descent_initial_height_above_ground: " .. descent_initial_height_above_ground .. " times leftt: " .. rounding_coeff)
								end

								--print("-",final_descent_height_per_frame,z_position, time_in_air)
								z_position = z_position - final_descent_height_per_frame
								flying_z_modifier:SetStackCount(z_position)
								return imba_invoker_tornado.loop_interval
							-- Before its time to decend we make Up and down cycles
							elseif time_in_air <= tornado_lift_duration then
								-- Up
								if z_position < cyclone_max_height and going_up then 
									--print("going up")
									z_position = z_position + up_down_cycle_height_per_frame
									flying_z_modifier:SetStackCount(z_position)
									return imba_invoker_tornado.loop_interval
								-- Down
								elseif z_position >= cyclone_min_height then
									going_up = false
									--print("going down")
									z_position = z_position - up_down_cycle_height_per_frame
									flying_z_modifier:SetStackCount(z_position)
									return imba_invoker_tornado.loop_interval
								-- Go up
								else
									--print("going up again")
									going_up = true
									return imba_invoker_tornado.loop_interval
								end
								return imba_invoker_tornado.loop_interval
							end
								-- Stop sound
								target:StopSound("Hero_Invoker.Tornado.Target")
								-- Cleanup
								ParticleManager:DestroyParticle(cyclone_effect, false)
								-- Cant deal damage if modifiers are on
								if target:HasModifier("modifier_imba_invoker_tornado") then
									target:RemoveModifierByName("modifier_imba_invoker_tornado") 
								end

								if target:HasModifier("modifier_imba_invoker_tornado_cyclone") then
									target:RemoveModifierByName("modifier_imba_invoker_tornado_cyclone")
									target:SetAbsOrigin(GetGroundPosition(target:GetAbsOrigin(), caster))
								end

								-- Apply damage
								self:LandDamage(target, caster, self, {base_damage = base_damage, wex_land_damage = wex_land_damage})

								-- If we have empower tornado talent... apply disarm
								if ExtraData.daze_duration > 0 then
									target:AddNewModifier(caster, self, "modifier_imba_invoker_tornado_empower_debuff", {duration = ExtraData.daze_duration * (1 - target:GetStatusResistance())})
								end
						end)		
					end
				else 
					EntIndexToHScript(ExtraData.tornado_dummy_unit):StopSound("Hero_Invoker.Tornado")
					EntIndexToHScript(ExtraData.tornado_dummy_unit):RemoveSelf()
					self:CreateVisibilityNode(location, ExtraData.vision_distance, ExtraData.end_vision_duration)
				end
			end
		end

		function imba_invoker_tornado:spinn(kv)
			local target = kv.target
			local total_degrees = 20

			--Rotate as close to 20 degrees per x.x seconds (666.666 degrees per second) as possible, so that the target lands facing their initial direction.
			if kv.target.invoker_tornado_degrees_to_spin == nil and kv.tornado_lift_duration ~= nil then
				local ideal_degrees_per_second = 666.666
				local ideal_full_spins = (ideal_degrees_per_second / 360) * kv.tornado_lift_duration
				--Round the number of spins to aim for to the closest integer.
				ideal_full_spins = math.floor(ideal_full_spins + .5) 
				local degrees_per_second_ending_in_same_forward_vector = (360 * ideal_full_spins) / kv.tornado_lift_duration
				kv.target.invoker_tornado_degrees_to_spin = degrees_per_second_ending_in_same_forward_vector * imba_invoker_tornado.loop_interval
			end
			
			target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0, kv.target.invoker_tornado_degrees_to_spin, 0), target:GetForwardVector()))
		end

		function imba_invoker_tornado:LandDamage(target, attacker, ability, kv)
			local damage_type = self:GetAbilityDamageType() 
			target:EmitSound("Hero_Invoker.Tornado.LandDamage")
			
			--Set so the target is facing the original direction as they were when they were hit by the tornado.
			if target.invoker_tornado_forward_vector ~= nil then
				target:SetForwardVector(target.invoker_tornado_forward_vector)
			end

			-- Apply damage
			local damage_table = {}
			damage_table.attacker = attacker
			damage_table.victim = target
			damage_table.ability = ability
			damage_table.damage_type = ability:GetAbilityDamageType() 
			damage_table.damage = kv.base_damage + kv.wex_land_damage
			ApplyDamage(damage_table)
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Tornado help modifier - hide dummy unit from game
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_tornado = class({})
		function modifier_imba_invoker_tornado:IsHidden() 	return false end
		function modifier_imba_invoker_tornado:IsBuff() 	return false end
		function modifier_imba_invoker_tornado:IsDebuff() 	return false end
		function modifier_imba_invoker_tornado:IsPassive() 	return false end
		function modifier_imba_invoker_tornado:IsPurgable() return false end
		function modifier_imba_invoker_tornado:CheckState()
			local state = {
				[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
				[MODIFIER_STATE_NO_TEAM_MOVE_TO] 	= true,
				[MODIFIER_STATE_NO_TEAM_SELECT] 	= true,
				[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
				[MODIFIER_STATE_ATTACK_IMMUNE] 		= true,
				[MODIFIER_STATE_MAGIC_IMMUNE] 		= true,
				[MODIFIER_STATE_INVULNERABLE] 		= true,
				[MODIFIER_STATE_NOT_ON_MINIMAP] 	= true,
				[MODIFIER_STATE_UNSELECTABLE] 		= true,
				[MODIFIER_STATE_OUT_OF_GAME] 		= true,
				[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
				[MODIFIER_STATE_ROOTED] 			= true,
			}
			return state
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Tornado modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_tornado_cyclone = class({})
		function modifier_imba_invoker_tornado_cyclone:IsHidden() 	return true  end
		function modifier_imba_invoker_tornado_cyclone:IsBuff() 	return false end
		function modifier_imba_invoker_tornado_cyclone:IsDebuff() 	return false end
		function modifier_imba_invoker_tornado_cyclone:IsPassive() 	return false end
		function modifier_imba_invoker_tornado_cyclone:IsPurgable() return false end
		function modifier_imba_invoker_tornado_cyclone:CheckState()
			local state = {
				[MODIFIER_STATE_NO_UNIT_COLLISION] 	= true,
				[MODIFIER_STATE_STUNNED] 			= true,
				[MODIFIER_STATE_ROOTED] 			= true,
				[MODIFIER_STATE_DISARMED] 			= true,
				[MODIFIER_STATE_INVULNERABLE] 		= true,
				[MODIFIER_STATE_NO_HEALTH_BAR] 		= true,
				[MODIFIER_STATE_FLYING] 			= true,
			}
			return state
		end

		function modifier_imba_invoker_tornado_cyclone:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_VISUAL_Z_DELTA
			}
			
			return funcs
		end

		function modifier_imba_invoker_tornado_cyclone:GetVisualZDelta()
			return self:GetStackCount()
		end

		function modifier_imba_invoker_tornado_cyclone:OnCreated(kv)
		end


		function modifier_imba_invoker_tornado_cyclone:OnRemoved(kv)
			self:SetStackCount(0)
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Tornado talent modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_tornado_empower_debuff = class({})
		function modifier_imba_invoker_tornado_empower_debuff:IsHidden() 	return false end
		function modifier_imba_invoker_tornado_empower_debuff:IsBuff() 		return false end
		function modifier_imba_invoker_tornado_empower_debuff:IsDebuff() 	return true end
		function modifier_imba_invoker_tornado_empower_debuff:IsPassive() 	return false end
		function modifier_imba_invoker_tornado_empower_debuff:IsPurgable() 	return false end
		function modifier_imba_invoker_tornado_empower_debuff:CheckState()
			local state = {
				[MODIFIER_STATE_PASSIVES_DISABLED] 	= true,
			}
			return state
		end


	---------------------------------------------------------------------------------------------------------------------
	--	Invoker's EMP
	---------------------------------------------------------------------------------------------------------------------
		imba_invoker_emp = class({})
		LinkLuaModifier("modifier_imba_invoker_emp", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_emp_overload", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

		function imba_invoker_emp:GetCastAnimation()
			return ACT_DOTA_CAST_EMP
		end

		function imba_invoker_emp:GetAOERadius()
			return self:GetSpecialValueFor("area_of_effect")
		end 

		function imba_invoker_emp:OnSpellStart()
			 if IsServer() then 
			 
				self:GetCaster():StartGesture(ACT_DOTA_CAST_EMP)
			 
				local target_point = self:GetCursorPosition()

				self:CastEMP(
				{	
					caster 			= self:GetCaster(), 
					ability 		= self,
					target_point 	= target_point, 
					current_charge	= 1
				})
			end
		end

		function imba_invoker_emp:CastEMP(kv)	
			local caster 			= kv.caster
			local ability 			= kv.ability
			local target_point 		= kv.target_point
			local current_charge	= kv.current_charge
			local wex_level 		= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1
			local delay 			= ability:GetLevelSpecialValueFor("delay", wex_level)
				
			CreateModifierThinker(
						caster, 
						ability, 
						"modifier_imba_invoker_emp", 	
						{
							duration 				= delay,
							current_charge 			= current_charge
						}, target_point, caster:GetTeamNumber(), false)
		end

		-----------------------------------------------------------------------------------------------------------------
		--	EMP ThinkerModifier
		-----------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_emp = class({})
		function modifier_imba_invoker_emp:OnCreated(kv)
			if IsServer() then 
				self.caster 					= self:GetCaster()
				self.ability 					= self:GetAbility()
				self.target_point 				= self:GetParent():GetAbsOrigin()
				self.current_charge	 			= kv.current_charge
				
				local invoker_wex 				= self.caster:FindAbilityByName("imba_invoker_wex")
				local wex_level 				= invoker_wex:GetLevel() - 1

				-- Get the Skills stats
				self.mana_burned 				= self.ability:GetLevelSpecialValueFor("mana_burned", wex_level)
				self.after_shock_duration		= self.ability:GetSpecialValueFor("after_shock_duration")
				self.area_of_effect 			= self.ability:GetSpecialValueFor("area_of_effect")
				self.damage_per_mana_pct 		= self.ability:GetSpecialValueFor("damage_per_mana_pct")
				self.mana_gain_per_mana_pct 	= self.ability:GetSpecialValueFor("mana_gain_per_mana_pct")
				self.emp_recharge_threshold 	= 0
				self.emp_effect_reduction 		= 0
				self.emp_total_charges			= 0

				-- Check if we have emp talent?
				if self.caster:HasTalent("imba_special_bonus_unique_invoker_1") then
					-- Get talent values
					self.emp_recharge_threshold = self.caster:FindTalentValue("imba_special_bonus_unique_invoker_1", "threshold")
					self.emp_effect_reduction 	= self.caster:FindTalentValue("imba_special_bonus_unique_invoker_1", "effect_reduction")
					self.emp_total_charges 		= self.caster:FindTalentValue("imba_special_bonus_unique_invoker_1", "charges")
				end

				-- Play EMP Sound!
				EmitSoundOnLocationWithCaster(self.caster:GetAbsOrigin(), "Hero_Invoker.EMP.Cast", self.caster)
				EmitSoundOnLocationWithCaster(self.target_point, "Hero_Invoker.EMP.Charge", self.caster)

				-- Create EMP Effect
				self.emp_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(self.emp_effect, 0, self.target_point)
				ParticleManager:SetParticleControl(self.emp_effect, 1, Vector(self.area_of_effect, 0, 0))
			end
		end

		function modifier_imba_invoker_emp:OnRemoved()
			if IsServer() then
				ParticleManager:DestroyParticle(self.emp_effect, false)
				-- Create EMP explosion
				local emp_explosion_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf",  PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(emp_explosion_effect, 0, self.target_point)
				ParticleManager:SetParticleControl(emp_explosion_effect, 1, Vector(self.area_of_effect, 0, 0))
				-- Play EMP Discharge sound
				EmitSoundOnLocationWithCaster(self.target_point, "Hero_Invoker.EMP.Discharge", self.caster)
				
				-- Check if we hit stuff
				local nearby_enemy_units = FindUnitsInRadius(
					self.caster:GetTeam(), 
					self.target_point, nil, self.area_of_effect, 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 
					FIND_ANY_ORDER, 
					false)

				local enemy_heroes_hit = 0
				for i, individual_enemy in ipairs(nearby_enemy_units) do
					-- Apply damage, drain mana, gain mana to caster, and return true/false if we drained full amount of mana from enemy
					if self:OnHit(self.caster, self.ability, individual_enemy, self.mana_burned, self.after_shock_duration, self.damage_per_mana_pct, self.mana_gain_per_mana_pct) and individual_enemy:IsHero() then
						enemy_heroes_hit = enemy_heroes_hit + 1
					end
				end

				-- if there is enough charges left
				if self.current_charge < self.emp_total_charges then
					-- and hit enough enemyheroes
					if self.emp_recharge_threshold > 0 and self.emp_recharge_threshold <= enemy_heroes_hit then
						-- Apply emp talent damage efficiency effect
						self.mana_burned = self.mana_burned * ((100 - self.emp_effect_reduction ) / 100)

						-- Cast Emp again!
						local next_charge = self.current_charge + 1	
						self:CastEMP(
						{	
							caster 			= self.caster, 
							ability 		= self.ability,
							target_point 	= self.target_point, 
							current_charge	= next_charge
						})
					end
				end
			end
		end

		function modifier_imba_invoker_emp:OnHit(caster, ability, enemy, mana_to_burn, after_shock_duration, damage_per_mana_pct, mana_gain_per_mana_pct)
			local full_mana_burn = false
			-- Calculate mana to burn. If amount of mana burned is greater then amount of mana remaning then we remove what remains. 
			local enemy_mana_to_burn = enemy:GetMana()
			if mana_to_burn < enemy_mana_to_burn then
				enemy_mana_to_burn = mana_to_burn
				full_mana_burn = true
			end
			
			-- Burn an amount of mana dependent on WEX.
			enemy:ReduceMana(enemy_mana_to_burn)
			-- Apply damage based on amount burned * damage_per_mana_pct modifier.
			ApplyDamage({	
				victim = enemy, 
				attacker = caster, 
				damage = enemy_mana_to_burn * (damage_per_mana_pct / 100), 
				damage_type = DAMAGE_TYPE_PURE
			})
			
			-- Restore some of the burnt mana to Invoker if the affected unit is a real hero.
			if enemy:IsRealHero() then
				enemy:AddNewModifier(caster, ability, "modifier_imba_invoker_emp_overload", {duration = after_shock_duration * (1 - enemy:GetStatusResistance())}) 
				caster:GiveMana(enemy_mana_to_burn * (mana_gain_per_mana_pct / 100))
			end

			return full_mana_burn
		end	

		-----------------------------------------------------------------------------------------------------------------
		--	EMP overload. No mana gain for 5sec.
		-----------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_emp_overload = class({})
		function modifier_imba_invoker_emp_overload:IsPassive() 	return false end
		function modifier_imba_invoker_emp_overload:IsBuff() 		return false end
		function modifier_imba_invoker_emp_overload:IsDebuff() 		return true  end
		function modifier_imba_invoker_emp_overload:IsPurgable() 	return true  end
		function modifier_imba_invoker_emp_overload:IsHidden() 		return false end
		function modifier_imba_invoker_emp_overload:DeclareFunctions()
			local funcs = {
				MODIFIER_EVENT_ON_MANA_GAINED
			}

			return funcs
		end

		function modifier_imba_invoker_emp_overload:OnManaGained(kv) 
			if kv.unit == self:GetParent() then
				local current_mana = kv.unit:GetMana();
				kv.unit:SetMana(current_mana - kv.gain);
			end
		end

	--------------------------------------------------------------------------------------------------------------------
	--	Invoker's: Ice Wall
	--------------------------------------------------------------------------------------------------------------------
		imba_invoker_ice_wall = class({})
		imba_invoker_ice_wall.ice_wall_effect = "particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf"
		LinkLuaModifier("modifier_imba_invoker_ice_wall", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_ice_wall_slow", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_ice_wall_attack_slow", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function imba_invoker_ice_wall:GetCastAnimation()
			return ACT_DOTA_CAST_ICE_WALL
		end

		function imba_invoker_ice_wall:OnSpellStart()
			if IsServer() then
				local caster				 		= self:GetCaster()
				local caster_point 					= caster:GetAbsOrigin() 
				local caster_direction 				= caster:GetForwardVector()
				local ability 						= caster:FindAbilityByName("imba_invoker_ice_wall")
				local quas_level 					= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local exort_level 					= caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				local cast_direction 				= Vector(-caster_direction.y, caster_direction.x, caster_direction.z)

				-- Get the Skills stats
				local ice_wall_placement_distance 	= ability:GetSpecialValueFor("wall_placement_distance")
				local ice_wall_length 				= ability:GetSpecialValueFor("wall_length")
				local ice_wall_slow_duration 		= ability:GetSpecialValueFor("slow_duration")
				local ice_wall_damage_interval 		= ability:GetSpecialValueFor("damage_interval")
				local ice_wall_area_of_effect 		= ability:GetSpecialValueFor("wall_area_of_effect")
				local ice_wall_duration 			= ability:GetLevelSpecialValueFor("duration", quas_level)
				local ice_wall_slow 				= ability:GetLevelSpecialValueFor("slow", quas_level)
				local attack_slow 					= ability:GetSpecialValueFor("attack_slow")
				local ice_wall_damage_per_second 	= ability:GetLevelSpecialValueFor("damage_per_second", exort_level)

				local ice_wall_effects 				= ""
				local ice_wall_spike_effects 		= ""

				--local target_point 						= caster_point + (caster_direction * ice_wall_placement_distance)
				ability.endpoint_distance_from_center	= (cast_direction * ice_wall_length) / 2
				--local ice_wall_end_point 			= target_point - endpoint_distance_from_center

				self:GetCaster():StartGesture(ACT_DOTA_CAST_ICE_WALL)
				
				-- Play Ice Wall sound
				EmitSoundOn("Hero_Invoker.IceWall.Cast", caster)

				local ice_walls 		= 1
				local ice_wall_offset 	= 0
				local z_offset 			= 0 
				-- With talent we get THICC icewall
				if caster:HasTalent("imba_special_bonus_unique_invoker_4") then
					ice_walls		= caster:FindTalentValue("imba_special_bonus_unique_invoker_4", "ice_walls")
					ice_wall_offset = caster:FindTalentValue("imba_special_bonus_unique_invoker_4", "ice_wall_offset")
					z_offset 		= 75
					imba_invoker_ice_wall.ice_wall_effect = "particles/hero/invoker/icewall/imba_invoker_ice_wall.vpcf"
				end

				for i = 0, (ice_walls -1) do 
					local target_point = caster_point + (caster_direction * ice_wall_placement_distance + (ice_wall_offset * i))
					target_point = GetGroundPosition(target_point, caster)
					
					local ice_wall_point = target_point
					ice_wall_point.z = ice_wall_point.z - z_offset
					--Display the Ice Wall particles in a line.
					local ice_wall_particle_effect = ParticleManager:CreateParticle(imba_invoker_ice_wall.ice_wall_effect, PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, ice_wall_point - ability.endpoint_distance_from_center)
					ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, ice_wall_point + ability.endpoint_distance_from_center)
					
					local ice_wall_particle_effect_spikes = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl(ice_wall_particle_effect_spikes, 0, target_point - ability.endpoint_distance_from_center)
					ParticleManager:SetParticleControl(ice_wall_particle_effect_spikes, 1, target_point + ability.endpoint_distance_from_center)

					if ice_wall_effects == "" then 
						ice_wall_effects = string.format("%d", ice_wall_particle_effect)
					else
						ice_wall_effects = string.format("%s %d", ice_wall_effects, ice_wall_particle_effect)
					end

					if ice_wall_effects == "" then 
						ice_wall_spike_effects = string.format("%d", ice_wall_particle_effect_spikes)
					else
						ice_wall_spike_effects = string.format("%s %d", ice_wall_spike_effects, ice_wall_particle_effect_spikes)
					end
				end

				local thinker_point = caster_point 
				local thinger_area 	= ice_wall_area_of_effect
				if ice_walls - 1 == 0 then 
					thinker_point = thinker_point + (caster_direction * ice_wall_placement_distance)
				else
					thinker_point = thinker_point + (caster_direction * ice_wall_placement_distance + (ice_wall_offset * ((ice_walls - 1) / 2)))
					ice_wall_area_of_effect = ice_wall_area_of_effect + (100 * ((ice_walls - 1) / 2))
				end

				CreateModifierThinker(
						caster, 
						ability, 
						"modifier_imba_invoker_ice_wall", 	
						{
							duration 							= ice_wall_duration,
							ice_wall_damage_interval 			= ice_wall_damage_interval,
							ice_wall_slow_duration 				= ice_wall_slow_duration,
							ice_wall_slow 						= ice_wall_slow,
							attack_slow 						= attack_slow,
							ice_wall_damage_per_second 			= ice_wall_damage_per_second,
							ice_wall_area_of_effect 			= ice_wall_area_of_effect,
							ice_wall_length 					= ice_wall_length,
							ice_wall_particle_effect 			= ice_wall_effects,
							ice_wall_particle_effect_spikes 	= ice_wall_spike_effects
						}, thinker_point, caster:GetTeamNumber(), false)
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Ice Wall modifier
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_ice_wall = class({})
		modifier_imba_invoker_ice_wall.npc_radius_constant = 65
		function modifier_imba_invoker_ice_wall:OnCreated(kv)
			if IsServer() then
				local ice_wall_damage_interval 			= kv.ice_wall_damage_interval
				self.slow_duration 						= kv.ice_wall_slow_duration
				self.ice_wall_slow 						= kv.ice_wall_slow
				self.attack_slow 						= kv.attack_slow
				-- damage per second... i.e multiply with the time and we get the correct value
				self.ice_wall_damage_per_second 		= kv.ice_wall_damage_per_second * kv.ice_wall_damage_interval
				self.ice_wall_area_of_effect 			= kv.ice_wall_area_of_effect
				self.ice_wall_length 					= kv.ice_wall_length
				self.search_area 						= kv.ice_wall_length + (kv.ice_wall_area_of_effect * 2)
				self.GetTeam 							= self:GetParent():GetTeam()
				self.origin 							= self:GetParent():GetAbsOrigin()
				self.ability 							= self:GetAbility()
				self.endpoint_distance_from_center  	= self:GetAbility().endpoint_distance_from_center
				self.ice_wall_start_point 				= self.origin - self.endpoint_distance_from_center
				self.ice_wall_end_point 				= self.origin + self.endpoint_distance_from_center
				self.ice_wall_particle_effect 			= kv.ice_wall_particle_effect
				self.ice_wall_particle_effect_spikes 	= kv.ice_wall_particle_effect_spikes

				-- For debugg, sometimes you need to check the acctual area of effect for multiple ice_walls
				--DebugDrawCircle(self:GetParent():GetAbsOrigin(), Vector(255,0,255), 255, self.ice_wall_area_of_effect, true, 20)

				self:StartIntervalThink(ice_wall_damage_interval)
			end
		end

		function modifier_imba_invoker_ice_wall:OnIntervalThink()
			if IsServer() then
				local nearby_enemy_units = FindUnitsInRadius(
					self.GetTeam, 
					self.origin, 
					nil, 
					self.search_area, 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
					FIND_ANY_ORDER, 
					false)


				for _,enemy in pairs(nearby_enemy_units) do
					if enemy ~= nil and enemy:IsAlive() then
						local target_position = enemy:GetAbsOrigin()
						if self:IsUnitInProximity(self.ice_wall_start_point, self.ice_wall_end_point, target_position, self.ice_wall_area_of_effect) then
							enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_invoker_ice_wall_slow", {duration = self.slow_duration, enemy_slow = self.ice_wall_slow * (1 - enemy:GetStatusResistance())})
							enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_imba_invoker_ice_wall_attack_slow", {duration = self.slow_duration, enemy_slow = self.attack_slow * (1 - enemy:GetStatusResistance())})

							-- Apply damage
							local damage_table 			= {}
							damage_table.attacker 		= self:GetParent()
							damage_table.victim			= enemy
							damage_table.ability 		= self.ability
							damage_table.damage_type 	= self.ability:GetAbilityDamageType() 
							damage_table.damage 		= self.ice_wall_damage_per_second
							ApplyDamage(damage_table)
						end
					end
				end
			end
		end

		function modifier_imba_invoker_ice_wall:OnRemoved() 
			if self.ice_wall_particle_effect ~= nil then
				for effect in string.gmatch(self.ice_wall_particle_effect, "([^ ]+)") do
					ParticleManager:DestroyParticle(tonumber(effect), false)                
				end
			end

			if self.ice_wall_particle_effect_spikes ~= nil then
				for effect in string.gmatch(self.ice_wall_particle_effect_spikes, "([^ ]+)") do
					ParticleManager:DestroyParticle(tonumber(effect), false)
				end
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Help function - check proximity of target vs ice_wall - beware contains maths... ._. 
		--------------------------------------------------------------------------------------------------------------------
		function modifier_imba_invoker_ice_wall:IsUnitInProximity(start_point, end_point, target_position, ice_wall_radius)
			-- craete vector which makes up the ice wall 
			local ice_wall = end_point - start_point
			-- create vector for target relative to start_point of the ice wall
			local target_vector = target_position - start_point

			local ice_wall_normalized = ice_wall:Normalized()
			-- create a dot vector of the normalized ice_wall vector
			local ice_wall_dot_vector = target_vector:Dot(ice_wall_normalized)
			-- here we will store the targeted enemies closest position
			local search_point
			-- if all the datapoints in the dot vector is below 0 then the target is outside our search hence closest point is start_point.
			if ice_wall_dot_vector <= 0 then
				search_point = start_point

			-- if all th datapoinst in the dot vector is above the max length of our search then there closest point is the end_point
			elseif ice_wall_dot_vector >= ice_wall:Length2D() then
				search_point = end_point

			-- if a datapoinst in the dot vector within range then the closest position is... 
			else
				search_point = start_point + (ice_wall_normalized * ice_wall_dot_vector)
			end 
			-- with all that setup we can now get the distance from our ice_wall! :D 
			local distance = target_position - search_point
			-- Is the distance less then our "area of effect" radius? true/false
			return distance:Length2D() <= ice_wall_radius + modifier_imba_invoker_ice_wall.npc_radius_constant
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Ice Wall slow aura 
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_ice_wall_slow = class({})
		function modifier_imba_invoker_ice_wall_slow:IsPassive() 		return false end
		function modifier_imba_invoker_ice_wall_slow:IsBuff() 			return false end
		function modifier_imba_invoker_ice_wall_slow:IsDebuff() 		return true  end
		function modifier_imba_invoker_ice_wall_slow:IsPurgable() 		return false end
		function modifier_imba_invoker_ice_wall_slow:IsHidden() 		return false end
		function modifier_imba_invoker_ice_wall_slow:GetEffectName() 	return "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf" end
		function modifier_imba_invoker_ice_wall_slow:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
			}
			
			return funcs
		end

		function modifier_imba_invoker_ice_wall_slow:GetTexture()
			return "invoker_ice_wall"
		end

		function modifier_imba_invoker_ice_wall_slow:OnCreated(kv)
			if IsServer() then
				self.caster = self:GetCaster()
				self.parent = self:GetParent()
				self:SetStackCount(kv.enemy_slow)

				-- Apply Ice wall slow effect
				--self.ice_wall_effect_aura = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			end
		end

		function modifier_imba_invoker_ice_wall_slow:OnRefresh(kv) 
			if IsServer() then
				self:SetStackCount(kv.enemy_slow)
			end
		end

		function modifier_imba_invoker_ice_wall_slow:OnRemoved()
			if IsServer() then
				if self.ice_wall_effect_aura ~= nil then
					--ParticleManager:DestroyParticle(self.ice_wall_effect_aura, false)
				end
			end
		end

		function modifier_imba_invoker_ice_wall_slow:GetModifierMoveSpeedBonus_Percentage()
			return self:GetStackCount()
		end

		--------------------------------------------------------------------------------------------------------------------
		--	Invoker's: Ice Wall slow attack 
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_ice_wall_attack_slow = class({})
		function modifier_imba_invoker_ice_wall_attack_slow:IsDebuff()			return true  end
		function modifier_imba_invoker_ice_wall_attack_slow:IsHidden() 			return true  end
		function modifier_imba_invoker_ice_wall_attack_slow:IsPurgable() 		return true  end
		function modifier_imba_invoker_ice_wall_attack_slow:IsPurgeException() 	return true  end
		function modifier_imba_invoker_ice_wall_attack_slow:IsStunDebuff() 		return false end
		function modifier_imba_invoker_ice_wall_attack_slow:DeclareFunctions()
			local funcs = {
				MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
			}
			
			return funcs
		end

		function modifier_imba_invoker_ice_wall_attack_slow:GetTexture()
			return "invoker_ice_wall"
		end

		function modifier_imba_invoker_ice_wall_attack_slow:OnCreated(kv)
			if IsServer() then
				self.caster = self:GetCaster()
				self.parent = self:GetParent()
				self:SetStackCount(kv.enemy_slow)
			end
		end

		function modifier_imba_invoker_ice_wall_attack_slow:OnRefresh(kv) 
			if IsServer() then
				self:SetStackCount(kv.enemy_slow)
			end
		end

		function modifier_imba_invoker_ice_wall_attack_slow:GetModifierMoveSpeedBonus_Percentage()
			return self:GetStackCount()
		end



	--------------------------------------------------------------------------------------------------------------------
	--	Invoker's: Chaos Meteor
	--------------------------------------------------------------------------------------------------------------------
		imba_invoker_chaos_meteor = class({})
		imba_invoker_chaos_meteor.loop_interval = 0.03
		LinkLuaModifier("modifier_imba_invoker_chaos_meteor", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_chaos_meteor_burn", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_chaos_meteor_burn_effect", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_chaos_meteor_aura", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		function imba_invoker_chaos_meteor:GetCastAnimation()
			return ACT_DOTA_CAST_CHAOS_METEOR
		end

		function imba_invoker_chaos_meteor:OnSpellStart()
			if IsServer() then
				local caster 			= self:GetCaster()
				local ability 			= self
				local target_point 		= self:GetCursorPosition()
				local number_of_meteors = 1

				if caster:HasTalent("imba_special_bonus_unique_invoker_2") then
					number_of_meteors = caster:FindTalentValue("imba_special_bonus_unique_invoker_2","number_of_meteors")
				end
				
				self:GetCaster():StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)
				
				imba_invoker_chaos_meteor:CastMeteor(caster, ability, target_point, number_of_meteors)
				
				if number_of_meteors > 1 then 
					local fiered_meteors = 1
					local endTime = GameRules:GetGameTime() + 1
					Timers:CreateTimer({
						endTime = 0.1,
						callback = function()
							fiered_meteors = fiered_meteors + 1
							
							local new_target_point = target_point + RandomVector(math.random(150, 300) - 150)
							imba_invoker_chaos_meteor:CastMeteor(caster, ability, new_target_point, number_of_meteors)

							if fiered_meteors == number_of_meteors then
								return  
							elseif fiered_meteors == number_of_meteors - 1 then  
								return 0.2
							else
								return 0.1
							end
						end
					})
				end
			end
		end

		function imba_invoker_chaos_meteor:CastMeteor(caster, ability, target_point, number_of_meteors)
			if IsServer() then 
				local chaos_meteor_land_time = ability:GetSpecialValueFor("land_time")

				CreateModifierThinker(	
					caster, 
					ability, 
					"modifier_imba_invoker_chaos_meteor", 	
					{
						duration = chaos_meteor_land_time
					}, 
					target_point, 
					caster:GetTeamNumber(), 
					false
				)
			end
		end

		modifier_imba_invoker_chaos_meteor = class({})
		function modifier_imba_invoker_chaos_meteor:OnCreated(kv)
			if IsServer() then
				self.caster = self:GetCaster()
				self.ability = self:GetAbility()
				self.target_point = self:GetParent():GetAbsOrigin()
				self.caster_location 					= self.caster:GetAbsOrigin()
				self.caster_location_ground 			= GetGroundPosition(self.caster:GetAbsOrigin(), self.caster)
				self.wex_level 							= self.caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1
				self.exort_level 						= self.caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				self.chaos_meteor_travel_distance 		= self.ability:GetLevelSpecialValueFor("travel_distance", self.wex_level)
				self.chaos_meteor_main_dmg				= self.ability:GetLevelSpecialValueFor("main_damage", self.exort_level)
				self.chaos_meteor_burn_dps				= self.ability:GetLevelSpecialValueFor("burn_dps", self.exort_level)
				self.chaos_meteor_travel_speed 			= self.ability:GetSpecialValueFor("travel_speed")
				self.chaos_meteor_burn_duration 		= self.ability:GetSpecialValueFor("burn_duration")
				self.chaos_meteor_burn_dps_inverval		= self.ability:GetSpecialValueFor("burn_dps_inverval")
				self.chaos_meteor_damage_interval		= self.ability:GetSpecialValueFor("damage_interval")
				self.chaos_meteor_vision_distance 		= self.ability:GetSpecialValueFor("vision_distance")
				self.chaos_meteor_end_vision_duration 	= self.ability:GetSpecialValueFor("end_vision_duration")
				self.chaos_meteor_area_of_effect 		= self.ability:GetSpecialValueFor("area_of_effect")		
				self.location_difference_normalized 	= (self.target_point - self.caster_location_ground):Normalized()
				self.chaos_meteor_land_time 			= self.ability:GetSpecialValueFor("land_time")
				self.chaos_meteor_velocity 				= self.location_difference_normalized * self.chaos_meteor_travel_speed
				self.chaos_meteor_duration 				= self.chaos_meteor_travel_distance / self.chaos_meteor_travel_speed

				-- Play Chaos Meteor Sounds
				self.caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
				
				self.meteor_dummy = CreateModifierThinker(self.caster, self.ability, nil, {}, self.target_point, self.caster:GetTeamNumber(), false)
				self.meteor_dummy:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

				-- Create start_point of the meteor 1000z up in the air! Meteors velocity is same while falling through the air as it is rolling on the ground.
				local chaos_meteor_fly_original_point = (self.target_point - (self.chaos_meteor_velocity * self.chaos_meteor_land_time)) + Vector(0, 0, 1000)
				--Create the particle effect consisting of the meteor falling from the sky and landing at the target point.
				self.chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, self.caster)
				ParticleManager:SetParticleControl(self.chaos_meteor_fly_particle_effect, 0, chaos_meteor_fly_original_point)
				ParticleManager:SetParticleControl(self.chaos_meteor_fly_particle_effect, 1, self.target_point)
				ParticleManager:SetParticleControl(self.chaos_meteor_fly_particle_effect, 2, Vector(self.chaos_meteor_land_time, 0, 0))
			end
		end

		function modifier_imba_invoker_chaos_meteor:OnRemoved()
			if IsServer() then 
				self.meteor_dummy:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
				self.meteor_dummy:AddNewModifier(	
					self.caster, 
					self.ability, 
					"modifier_imba_invoker_chaos_meteor_aura", 
					{
						duration 				= -1,
						chaos_meteor_duration 	= self.chaos_meteor_duration,
						burn_duration 			= self.chaos_meteor_burn_duration,
						main_dmg 				= self.chaos_meteor_main_dmg,
						burn_dps 				= self.chaos_meteor_burn_dps,
						burn_dps_inverval 		= self.chaos_meteor_burn_dps_inverval,
						damage_interval 		= self.chaos_meteor_damage_interval,
						area_of_effect 			= self.chaos_meteor_area_of_effect
					}
				)

				-- Meteor Projectile object
				local meteor_projectile_obj =  
				{
					EffectName 					= "particles/hero/invoker/chaosmeteor/imba_invoker_chaos_meteor.vpcf",
					Ability 					= self.ability,
					vSpawnOrigin 				= self.target_point,
					fDistance 					= self.chaos_meteor_travel_distance,
					fStartRadius 				= self.chaos_meteor_area_of_effect,
					fEndRadius 					= self.chaos_meteor_area_of_effect,
					Source 						= self.chaos_meteor_dummy_unit,
					bHasFrontalCone 			= false,
					iMoveSpeed 					= self.chaos_meteor_travel_speed,                              
					bReplaceExisting 			= false,
					bProvidesVision 			= true,
					iVisionTeamNumber 			= self.caster:GetTeam(),
					iVisionRadius 				= self.chaos_meteor_vision_distance,
					bDrawsOnMinimap 			= false,
					bVisibleToEnemies 			= true, 
					iUnitTargetTeam 			= DOTA_UNIT_TARGET_NONE,
					iUnitTargetFlags 			= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 			= DOTA_UNIT_TARGET_NONE,
					fExpireTime 				= GameRules:GetGameTime() + self.chaos_meteor_land_time + self.chaos_meteor_duration + self.chaos_meteor_end_vision_duration,
					ExtraData 					= {
						meteor_dummy 			= self.meteor_dummy:entindex(),
						vision_distance 		= self.chaos_meteor_vision_distance,
						vision_duration 		= self.chaos_meteor_end_vision_duration
					}
				}
				meteor_projectile_obj.vVelocity = self.chaos_meteor_velocity
				meteor_projectile_obj.vVelocity.z = 0
				ProjectileManager:CreateLinearProjectile(meteor_projectile_obj)

				-- Cleanup
				ParticleManager:DestroyParticle(self.chaos_meteor_fly_particle_effect, false)
			end
		end

		function imba_invoker_chaos_meteor:OnProjectileThink_ExtraData(location, ExtraData)
			if IsServer() then
				EntIndexToHScript(ExtraData.meteor_dummy):SetAbsOrigin(location)
			end
		end

		function imba_invoker_chaos_meteor:OnProjectileHit_ExtraData(target, location, ExtraData)
			if IsServer() then 
				if target == nil then 
					EntIndexToHScript(ExtraData.meteor_dummy):StopSound("Hero_Invoker.ChaosMeteor.Loop")
					EntIndexToHScript(ExtraData.meteor_dummy):RemoveSelf()
					self:CreateVisibilityNode(location, ExtraData.vision_distance, ExtraData.vision_duration)
				end
			end 
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Chaos Meteor modifier - applies burn debuff and damage. also hides dummy unit from game 
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_chaos_meteor_aura = class({})
		function modifier_imba_invoker_chaos_meteor_aura:OnCreated(kv)
			if IsServer() then
				self.caster 				= self:GetCaster()
				self.ability 				= self:GetAbility()
				self.GetTeam 				= self:GetParent():GetTeam()
				self.chaos_meteor_duration 	= kv.chaos_meteor_duration
				self.damage_interval 		= kv.damage_interval
				self.main_dmg 				= kv.main_dmg
				self.burn_duration 			= kv.burn_duration
				self.burn_dps 				= kv.burn_dps
				self.burn_dps_inverval		= kv.burn_dps_inverval 
				self.area_of_effect 		= kv.area_of_effect

				if self.caster:HasTalent("imba_special_bonus_unique_invoker_2") then
					local number_of_meteors = self.caster:FindTalentValue("imba_special_bonus_unique_invoker_2","number_of_meteors")
					-- reduce damage by number of meteors... cuz this would be broken
					self.burn_dps 			= self.burn_dps / number_of_meteors
					self.main_dmg 			= self.main_dmg / number_of_meteors
				end

				self.direction = (self:GetParent():GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
				self.direction.z = 0

				self.hit_table = {}

				self:StartIntervalThink(kv.damage_interval)
			end
		end

		function modifier_imba_invoker_chaos_meteor_aura:OnIntervalThink()
			if IsServer() then
				local start_point 	= self:GetParent():GetAbsOrigin()
				local end_point 	= start_point - (self.direction * 500)
				for _,enemy in pairs(self.hit_table) do 
					if enemy:IsNull() == false and enemy:HasModifier("modifier_imba_invoker_chaos_meteor_burn") then 
						-- Reusing old method for calculating distance vs a line
						if modifier_imba_invoker_ice_wall:IsUnitInProximity(start_point, end_point, enemy:GetAbsOrigin(), 300) then
							local burn_modifiers = enemy:FindAllModifiersByName("modifier_imba_invoker_chaos_meteor_burn")
							for _,modifier in pairs(burn_modifiers) do
								modifier:ForceRefresh()
							end

							local burn_effect_modifier = enemy:FindModifierByName("modifier_imba_invoker_chaos_meteor_burn_effect")
							if burn_effect_modifier ~= nil then 
								burn_effect_modifier:ForceRefresh()
							end
						end

					end
				end

				-- Find enemies close enought to be affected by the meteor
				local nearby_enemy_units = FindUnitsInRadius(
					self.GetTeam, 
					self:GetParent():GetAbsOrigin(), 
					nil, 
					self.area_of_effect, 
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
					DOTA_UNIT_TARGET_FLAG_NONE, 
					FIND_ANY_ORDER, 
					false)

				for _,enemy in pairs(nearby_enemy_units) do
					if self.hit_table[enemy:GetName()] == nil then
						self.hit_table[enemy:GetName()] = enemy
					end

					if enemy ~= nil then
						-- Add burn debuff
						enemy:AddNewModifier(	
							self.caster, 
							self.ability, 
							"modifier_imba_invoker_chaos_meteor_burn", 
							{
								duration 			= self.burn_duration,
								burn_dps 			= self.burn_dps,
								burn_dps_inverval 	= self.burn_dps_inverval
							}
						)

						enemy:AddNewModifier(	
							self.caster, 
							self.ability, 
							"modifier_imba_invoker_chaos_meteor_burn_effect", 
							{
								duration 			= self.burn_duration
							}
						)


						-- Apply meteor main dmg
						local damage_table 			= {}
						damage_table.attacker 		= self.caster
						damage_table.victim			= enemy
						damage_table.ability 		= self.ability
						damage_table.damage_type 	= self.ability:GetAbilityDamageType() 
						damage_table.damage 		= self.main_dmg
						ApplyDamage(damage_table)
					end
				end
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Chaos Meteor burn modifier - applies burn damage per dps interval
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_chaos_meteor_burn = class({})
		function modifier_imba_invoker_chaos_meteor_burn:IsDebuff() return true end
		function modifier_imba_invoker_chaos_meteor_burn:IgnoreTenacity()	return true end
		function modifier_imba_invoker_chaos_meteor_burn:GetAttributes()
			return MODIFIER_ATTRIBUTE_MULTIPLE
		end

		function modifier_imba_invoker_chaos_meteor_burn:OnCreated(kv) 
			if IsServer() then
				self.caster 			= self:GetCaster()
				self.parent 			= self:GetParent()
				self.ability 			= self:GetAbility()
				self.damage_type 		= self.ability:GetAbilityDamageType() 
				self.burn_dps_inverval 	= kv.burn_dps_inverval
				self.burn_dps 			= kv.burn_dps

				self:StartIntervalThink(self.burn_dps_inverval)
			end
		end

		function modifier_imba_invoker_chaos_meteor_burn:OnIntervalThink()

			if IsServer() then
				-- Apply meteor debuff burn dmg
				local damage_table 			= {}
				damage_table.attacker 		= self.caster
				damage_table.victim			= self.parent
				damage_table.ability 		= self.ability
				damage_table.damage_type 	= self.damage_type
				damage_table.damage 		= self.burn_dps
				ApplyDamage(damage_table)
			end
		end


		--------------------------------------------------------------------------------------------------------------------
		-- Chaos Meteor burn effect
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_chaos_meteor_burn_effect = class({})
		function modifier_imba_invoker_chaos_meteor_burn_effect:IsHidden() 		return true end
		function modifier_imba_invoker_chaos_meteor_burn_effect:IgnoreTenacity()	return true end
		function modifier_imba_invoker_chaos_meteor_burn_effect:GetEffectName() return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf" end



	--------------------------------------------------------------------------------------------------------------------
	-- Invoker's Deafening Blast
	--------------------------------------------------------------------------------------------------------------------
		imba_invoker_deafening_blast = class({})
		imba_invoker_deafening_blast.knockback_interval = 0.03
		imba_invoker_deafening_blast.ability_effect_path 			= "particles/units/heroes/hero_invoker/invoker_deafening_blast.vpcf"
--		imba_invoker_deafening_blast.ability_effect_path 			= "particles/econ/items/invoker/invoker_ti6/invoker_deafening_blast_ti6.vpcf"
		imba_invoker_deafening_blast.ability_effect_path_aoe		= "particles/hero/invoker/deafeningblast/imba_invoker_deafening_blast.vpcf"
		imba_invoker_deafening_blast.ability_disarm_effect_path 	= "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf"
		imba_invoker_deafening_blast.ability_knockback_effect_path 	= "particles/units/heroes/hero_invoker/invoker_deafening_blast_knockback_debuff.vpcf"

		LinkLuaModifier("modifier_imba_invoker_deafening_blast", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_deafening_blast_frozen", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_deafening_blast_knockback", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)
		LinkLuaModifier("modifier_imba_invoker_deafening_blast_disarm", "components/abilities/heroes/hero_invoker.lua", LUA_MODIFIER_MOTION_NONE)

		function imba_invoker_deafening_blast:GetCastAnimation()
			return ACT_DOTA_CAST_DEAFENING_BLAST
		end

		function imba_invoker_deafening_blast:OnSpellStart()
			if IsServer() then 
				local caster 			= self:GetCaster()
				local ability 			= self
				local caster_location 	= caster:GetAbsOrigin()
				local target_point 		= ability:GetCursorPosition()
				local direction 		= (target_point - caster_location):Normalized()
				-- make sure direction is horizontal
				direction.z 			= 0

				self:GetCaster():StartGesture(ACT_DOTA_CAST_DEAFENING_BLAST)

				-- Play Deafening Blast sound 
				EmitSoundOnLocationWithCaster(caster_location, "Hero_Invoker.DeafeningBlast", caster)

				ability.hit_table = {}
				
				-- Cast spiral
				if caster:HasTalent("imba_special_bonus_unique_invoker_7") then
					local num_deafening_blasts		= caster:FindTalentValue("imba_special_bonus_unique_invoker_7","number_of_blasts")

					CreateModifierThinker(
							caster, 
							ability, 
							"modifier_imba_invoker_deafening_blast", 	
							{
								num_deafening_blasts = num_deafening_blasts
							}, 
							target_point, 
							caster:GetTeamNumber(), false)	
				-- Cast normal
				else
					imba_invoker_deafening_blast:CastDeafeningBlast(caster, ability, target_point)
				end
			end
		end

		function imba_invoker_deafening_blast:CastDeafeningBlast(caster, ability, target_point)
			if IsServer() then
				local caster_location 	= caster:GetAbsOrigin()
				local quas_level 		= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local exort_level 		= caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				local wex_level 		= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1

				-- Get skill stats
				local deafening_blast_damage 				= ability:GetLevelSpecialValueFor("damage", exort_level)
				local deafening_blast_knockback_duration 	= ability:GetLevelSpecialValueFor("knockback_duration", quas_level) + 0.1
				local deafening_blast_disarm_duration 		= ability:GetLevelSpecialValueFor("disarm_duration", wex_level)
				local deafening_blast_travel_distance 		= ability:GetSpecialValueFor("travel_distance")
				local deafening_blast_travel_speed 			= ability:GetSpecialValueFor("travel_speed")
				local deafening_blast_radius_start 			= ability:GetSpecialValueFor("radius_start")
				local deafening_blast_radius_end 			= ability:GetSpecialValueFor("radius_end")

				local direction = (target_point - caster_location):Normalized()
				direction.z 	= 0

				-- Create projectile
				local deafening_blast_projectile_table = 
				{
					EffectName 			= imba_invoker_deafening_blast.ability_effect_path,
					Ability 			= ability,
					vSpawnOrigin 		= caster:GetAbsOrigin(),
					vVelocity 			= direction * deafening_blast_travel_speed,
					fDistance 			= deafening_blast_travel_distance,
					fStartRadius 		= deafening_blast_radius_start,
					fEndRadius 			= deafening_blast_radius_end,
					Source 				= caster,
					bHasFrontalCone 	= true,
					bReplaceExisting 	= false,
					iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					ExtraData = {
						deafening_blast_damage 				= deafening_blast_damage, 
						deafening_blast_knockback_duration 	= deafening_blast_knockback_duration, 
						deafening_blast_knockback_distance  = deafening_blast_knockback_distance,
						deafening_blast_disarm_duration 	= deafening_blast_disarm_duration,
						disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
						knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
					}
				}

				ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
			end
		end

		function imba_invoker_deafening_blast:RadialDeafeningBlast(caster, ability, target_point, num_blasts)
			if IsServer() then 
				-- reset so we can deal damage again
				ability.hit_table = {}

				local caster_location 	= caster:GetAbsOrigin()
				local quas_level 		= caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				local exort_level 		= caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				local wex_level 		= caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1

				-- Get skill stats
				local deafening_blast_damage 				= ability:GetLevelSpecialValueFor("damage", exort_level)
				local deafening_blast_knockback_duration 	= ability:GetLevelSpecialValueFor("knockback_duration", quas_level) + 0.1
				local deafening_blast_disarm_duration 		= ability:GetLevelSpecialValueFor("disarm_duration", wex_level)
				local deafening_blast_travel_distance 		= ability:GetSpecialValueFor("travel_distance")
				local deafening_blast_travel_speed 			= ability:GetSpecialValueFor("travel_speed")
				local deafening_blast_radius_start 			= ability:GetSpecialValueFor("radius_start")
				local deafening_blast_radius_end 			= ability:GetSpecialValueFor("radius_end")

				if caster:HasTalent("imba_special_bonus_unique_invoker_7") then
					local damage_reduction = caster:FindTalentValue("imba_special_bonus_unique_invoker_7","damage_reduction")
					deafening_blast_damage = deafening_blast_damage * ((100 - damage_reduction) / 100)
				end

				local direction = (target_point - caster_location):Normalized()
				direction.z 	= 0

				local degrees = 360 / num_blasts

				-- Play Deafening Blast sound 
				EmitSoundOnLocationWithCaster(caster_location, "Hero_Invoker.DeafeningBlast", caster)

				for index = 1, num_blasts, 1 do
					-- Create projectile
					local deafening_blast_projectile_table = 
					{
						EffectName 			= imba_invoker_deafening_blast.ability_effect_path_aoe,
						Ability 			= ability,
						vSpawnOrigin 		= caster:GetAbsOrigin(),
						vVelocity 			= direction * deafening_blast_travel_speed,
						fDistance 			= deafening_blast_travel_distance,
						fStartRadius 		= deafening_blast_radius_start,
						fEndRadius 			= deafening_blast_radius_end,
						Source 				= caster,
						bHasFrontalCone 	= true,
						bReplaceExisting 	= false,
						iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
						iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						ExtraData = {
							deafening_blast_damage 				= deafening_blast_damage, 
							deafening_blast_knockback_duration 	= deafening_blast_knockback_duration, 
							deafening_blast_knockback_distance  = deafening_blast_knockback_distance,
							deafening_blast_disarm_duration 	= deafening_blast_disarm_duration,
							disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
							knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
						}
					}

					ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
					-- Rotate direciton for 360/num_blasts degrees
					direction = RotatePosition(Vector(0,0,0), QAngle(0, degrees, 0), direction)
				end
			end
		end

		function imba_invoker_deafening_blast:OnProjectileHit_ExtraData(target, location, ExtraData)
			if IsServer() then
				if target then
					local caster = self:GetCaster()
					local target_entity_index = target:GetEntityIndex()
					-- Is this first time we hit the enemy?
					if self.hit_table[target_entity_index] == nil then
						-- add to hit table...
						self.hit_table[target_entity_index] = true

						self:KnockBackAndDisarm(caster, target, ExtraData.deafening_blast_knockback_duration, ExtraData.deafening_blast_disarm_duration , ExtraData.disarm_effect_path, ExtraData.knockback_effect_path)
						
						-- Apply deafening blast damage
						local damage_table 			= {}
						damage_table.attacker 		= caster
						damage_table.victim			= target
						damage_table.ability 		= self
						damage_table.damage_type 	= self:GetAbilityDamageType() 
						damage_table.damage 		= ExtraData.deafening_blast_damage
						ApplyDamage(damage_table)
					end
				end
			end	
		end

		function imba_invoker_deafening_blast:CheckHitList(target_entity_id) 
			if self.hit_table[target_entity_id] == nil then
				self.hit_table[target_entity_id] = true
				return true
			else
				return false
			end
		end

		function imba_invoker_deafening_blast:KnockBackAndDisarm(caster, target, knockback_duration, disarm_duration, disarm_effect_path, knockback_effect_path)
			-- Add knockback and frozen modifier
			target:AddNewModifier(caster, self, "modifier_imba_invoker_deafening_blast_knockback", {duration = knockback_duration * (1 - target:GetStatusResistance())})
			target:AddNewModifier(caster, self, "modifier_imba_invoker_deafening_blast_frozen", {duration = knockback_duration + disarm_duration * (1 - target:GetStatusResistance())})
		end

		modifier_imba_invoker_deafening_blast = class({})
		function modifier_imba_invoker_deafening_blast:OnCreated(kv)
			if IsServer() then
				self.target_point 		= self:GetParent():GetAbsOrigin()
				self.caster_location 	= self:GetCaster():GetAbsOrigin()
				self.caster 			= self:GetCaster()
				self.ability 			= self:GetAbility()

				self.quas_level 		= self.caster:FindAbilityByName("imba_invoker_quas"):GetLevel() - 1
				self.exort_level 		= self.caster:FindAbilityByName("imba_invoker_exort"):GetLevel() - 1
				self.wex_level 			= self.caster:FindAbilityByName("imba_invoker_wex"):GetLevel() - 1

				self.deafening_blast_damage 				= self.ability:GetLevelSpecialValueFor("damage", self.exort_level)
				self.deafening_blast_knockback_duration 	= self.ability:GetLevelSpecialValueFor("knockback_duration", self.quas_level) + 0.1
				self.deafening_blast_disarm_duration 		= self.ability:GetLevelSpecialValueFor("disarm_duration", self.wex_level)
				self.deafening_blast_travel_distance 		= self.ability:GetSpecialValueFor("travel_distance")
				self.deafening_blast_travel_speed 			= self.ability:GetSpecialValueFor("travel_speed")
				self.deafening_blast_radius_start 			= self.ability:GetSpecialValueFor("radius_start")
				self.deafening_blast_radius_end 			= self.ability:GetSpecialValueFor("radius_end")

				self.num_deafening_blasts 		= kv.num_deafening_blasts
				self.remaining_deafening_blast 	= kv.num_deafening_blasts + 1
				self.direction 					= (self.target_point - self.caster_location):Normalized() 
				self.direction.z 				= 0
				self.degrees 					= 360 / self.num_deafening_blasts
			
				self:StartIntervalThink(0.05)
			end
		end

		function modifier_imba_invoker_deafening_blast:OnIntervalThink()
			if IsServer() then 
				-- Create projectile
				local deafening_blast_projectile_table = 
				{
					EffectName 			= imba_invoker_deafening_blast.ability_effect_path_aoe,
					Ability 			= self.ability,
					vSpawnOrigin 		= self.caster:GetAbsOrigin(),
					vVelocity 			= self.direction * self.deafening_blast_travel_speed,
					fDistance 			= self.deafening_blast_travel_distance,
					fStartRadius 		= self.deafening_blast_radius_start,
					fEndRadius 			= self.deafening_blast_radius_end,
					Source 				= self.caster,
					bHasFrontalCone 	= true,
					bReplaceExisting 	= false,
					iUnitTargetTeam 	= DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetFlags 	= DOTA_UNIT_TARGET_FLAG_NONE,
					iUnitTargetType 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					ExtraData = {
						deafening_blast_damage 				= self.deafening_blast_damage, 
						deafening_blast_knockback_duration 	= self.deafening_blast_knockback_duration, 
						deafening_blast_knockback_distance  = self.deafening_blast_knockback_distance,
						deafening_blast_disarm_duration 	= self.deafening_blast_disarm_duration,
						disarm_effect_path 					= imba_invoker_deafening_blast.ability_disarm_effect_path,
						knockback_effect_path 				= imba_invoker_deafening_blast.ability_knockback_effect_path
					}
				}

				ProjectileManager:CreateLinearProjectile(deafening_blast_projectile_table)
				-- Rotate direciton for 360/num_blasts degrees
				self.direction = RotatePosition(Vector(0,0,0), QAngle(0, self.degrees, 0), self.direction)

				self.remaining_deafening_blast = self.remaining_deafening_blast - 1
						
				if self.remaining_deafening_blast == 0 then 
					self:GetParent():RemoveModifierByName("modifier_imba_invoker_deafening_blast")
				end
			end
		end

		function modifier_imba_invoker_deafening_blast:OnRemoved()
			if IsServer() then
				imba_invoker_deafening_blast:RadialDeafeningBlast(
					self.caster, 
					self.ability,
					self.target_point,
					self.num_deafening_blasts
				)
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Invoker's Deafening Blast modifier - provides knockback for a short duration
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_deafening_blast_frozen = class({})
		function modifier_imba_invoker_deafening_blast_frozen:IsHidden() 		return false end
		function modifier_imba_invoker_deafening_blast_frozen:IsDebuff() 		return true  end
		function modifier_imba_invoker_deafening_blast_frozen:IsPurgable() 		return false end
		function modifier_imba_invoker_deafening_blast_frozen:GetEffectName() 	return "particles/status_fx/status_effect_frost.vpcf" end
		function modifier_imba_invoker_deafening_blast_frozen:CheckState()
			local state = {
				[MODIFIER_STATE_FROZEN] = true
			}
			return state
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Invoker's Deafening Blast 2nd modifier - enemies are rooted during knockback
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_deafening_blast_knockback = class({})
		function modifier_imba_invoker_deafening_blast_knockback:IsHidden() 	return false end
		function modifier_imba_invoker_deafening_blast_knockback:IsDebuff() 	return true  end
		function modifier_imba_invoker_deafening_blast_knockback:IsPurgable() 	return false end
		function modifier_imba_invoker_deafening_blast_knockback:CheckState()
		local state = {
				[MODIFIER_STATE_ROOTED] = true,
			}
			return state
		end

		function modifier_imba_invoker_deafening_blast_knockback:GetOverrideAnimation()
			return ACT_DOTA_DISABLED
		end

		function modifier_imba_invoker_deafening_blast_knockback:OnCreated(kv)
			if IsServer() then 
				self.knockback_effect = ParticleManager:CreateParticle(kv.knockback_effect_path, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				self.knockback_direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() 
				self.knockback_speed = 6

				self:StartIntervalThink(imba_invoker_deafening_blast.knockback_interval)
			end
		end

		function modifier_imba_invoker_deafening_blast_knockback:OnIntervalThink()
			if IsServer() then
				local new_location = self:GetParent():GetAbsOrigin() + self.knockback_direction * self.knockback_speed
				self:GetParent():SetAbsOrigin(GetGroundPosition(new_location, self:GetParent()))
			end
		end

		function modifier_imba_invoker_deafening_blast_knockback:OnRemoved()
			if IsServer() then
				ParticleManager:DestroyParticle(self.knockback_effect, false)
				FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
			end
		end

		--------------------------------------------------------------------------------------------------------------------
		-- Invoker's Deafening Blast 3rd modifier - provides disarm for a short duration
		--------------------------------------------------------------------------------------------------------------------
		modifier_imba_invoker_deafening_blast_disarm = class({})
		function modifier_imba_invoker_deafening_blast_disarm:IsHidden() 	return true end
		function modifier_imba_invoker_deafening_blast_disarm:IsDebuff() 	return true end
		function modifier_imba_invoker_deafening_blast_disarm:IsPurgable() 	return false end
		function modifier_imba_invoker_deafening_blast_disarm:StatusEffectPriority() return 15 end
		function modifier_imba_invoker_deafening_blast_disarm:CheckState()
			local state = {
				[MODIFIER_STATE_DISARMED] = true
			}
			return state
		end
