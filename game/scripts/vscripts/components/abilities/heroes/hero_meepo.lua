-- Created by Wouterz90: https://github.com/ModDota/AbilityLuaSpellLibrary/blob/master/game/scripts/vscripts/heroes/meepo/divided_we_stand.lua

LinkLuaModifier("modifier_item_imba_lotus_orb_active", "components/items/item_lotus_orb.lua", LUA_MODIFIER_MOTION_NONE)

modifier_meepo_divided_we_stand_lua = modifier_meepo_divided_we_stand_lua or class({})

function modifier_meepo_divided_we_stand_lua:IsHidden() return true end
function modifier_meepo_divided_we_stand_lua:RemoveOnDeath() return false end
function modifier_meepo_divided_we_stand_lua:IsPurgable() return false end

function modifier_meepo_divided_we_stand_lua:OnCreated()
	if IsServer() then	
		self:StartIntervalThink(FrameTime() * 2) -- could use frametime but i'm not sure if it affects FPS somehow
	end
end

function modifier_meepo_divided_we_stand_lua:OnIntervalThink()
	local boots = {
		"item_imba_guardian_greaves",
		"item_imba_origin_treads",
		"item_imba_arcane_boots",
		"item_imba_lifesteal_boots",
		"item_imba_blink_boots",
		"item_imba_transient_boots",
	}

	local all_boots = {
		"item_boots",
		"item_travel_boots",
		"item_travel_boots_2",
		"item_tranquil_boots",
		"item_imba_guardian_greaves",
		"item_imba_origin_treads",
		"item_imba_arcane_boots",
		"item_imba_lifesteal_boots",
		"item_imba_blink_boots",
		"item_imba_transient_boots",
	}

	local break_loop = false
	local ignore_custom_boots = false

	-- if it's a clone
--	print("Clone?", self:GetParent():IsClone())
	if self:GetParent():IsClone() then
		for _, boots in pairs(all_boots) do
			if self:GetParent():HasItemInInventory(boots) then
				ignore_custom_boots = true
				break
			end
		end

		if ignore_custom_boots == false then
			for _, boots_name in pairs(boots) do
--				print("Boots:", boots_name)
				for i = 0, 5 do
					self:GetParent():GetCloneSource().main_boots = nil
					local item = self:GetParent():GetCloneSource():GetItemInSlot(i)
--					print("Item hscript:", i, item)

					-- if a pair of boots is found, do nothing
					if item then
--						print(item:GetAbilityName().." / "..boots_name)
						if item:GetAbilityName() == boots_name then
							self:GetParent():GetCloneSource().main_boots = item
							break_loop = true

							break
						end
					end
				end

				if break_loop == true then
					break
				end
			end
		end

		local found_boots = self:GetParent():GetCloneSource().main_boots

		-- Pair of boots found, do something
		if break_loop == true then
--			print("Boots found in main meepo:", found_boots:GetAbilityName())
			if not self:GetParent():HasItemInInventory(found_boots:GetAbilityName()) then
				self.cloned_boots = self:GetParent():AddItemByName(found_boots:GetAbilityName())
				
				if self.cloned_boots and self:GetParent():HasItemInInventory(found_boots:GetAbilityName()) and self.cloned_boots:GetItemSlot() ~= found_boots:GetItemSlot() then
					self:GetParent():SwapItems(self.cloned_boots:GetItemSlot(), found_boots:GetItemSlot())
				end
			end
		else
			for _, boots_name in pairs(boots) do
				self:GetParent():RemoveItemByName(boots_name)
			end
		end

		-- Mega Treads fix
		-- The Mega Treads lua file has a crapton of garbage code along with lines that expilcitly forbid clones from getting the bonus modifiers or something...so I guess I'll just leave it
		if found_boots and found_boots:GetAbilityName() == "item_imba_origin_treads" then
			-- print(found_boots.state.." / "..self:GetParent():FindItemInInventory("item_imba_origin_treads").state)
			if found_boots.state ~= self:GetParent():FindItemInInventory("item_imba_origin_treads").state then
--				self:GetParent():FindItemInInventory("item_imba_origin_treads").state = found_boots.state

				if self:GetParent():HasModifier("modifier_item_imba_origin_treads") and self:GetParent():GetCloneSource():HasModifier("modifier_item_imba_origin_treads") then
					self:GetParent():FindModifierByName("modifier_item_imba_origin_treads"):SetStackCount(self:GetParent():GetCloneSource():FindModifierByName("modifier_item_imba_origin_treads"):GetStackCount())
				end
			end
		end

		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_meepo_divided_we_stand_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_meepo_divided_we_stand_lua:OnAbilityFullyCast(keys)
	if not IsServer() then return end

	-- print(keys.ability:IsItem())
	-- print(self:GetParent().GetCloneSource)
	-- print(keys.unit)
	-- print(self:GetParent():GetCloneSource())

	if keys.ability and keys.ability.IsItem and keys.ability:IsItem() and self:GetParent().GetCloneSource and (keys.unit and keys.unit == self:GetParent():GetCloneSource() or (keys.target and keys.target == self:GetParent():GetCloneSource() and keys.unit:GetTeamNumber() == self:GetParent():GetCloneSource():GetTeamNumber())) then
		local modifier_name			= nil
		local modifier_duration		= nil
	
		-- Garbage case-by-case basis here
		if keys.ability:GetName() == "item_imba_white_queen_cape" or keys.ability:GetName() == "item_minotaur_horn" then
			modifier_name		= "modifier_black_king_bar_immune"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		elseif keys.ability:GetName() == "item_imba_black_king_bar" then
			modifier_name		= "modifier_item_imba_black_king_bar_buff"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		-- Angelic Alliance
		elseif keys.ability:GetName() == "item_imba_angelic_alliance" then
			modifier_name		= "modifier_imba_angelic_alliance_buff"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		-- Blademail
		elseif keys.ability:GetName() == "item_imba_blade_mail" or keys.ability:GetName() == "item_imba_bladestorm_mail" then
			modifier_name		= "modifier_item_imba_blade_mail_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		-- Butterfly
		elseif keys.ability:GetName() == "item_imba_butterfly" then
			modifier_name		= "modifier_item_imba_butterfly_flutter"
			modifier_duration	= keys.ability:GetSpecialValueFor("flutter_duration")
		-- Jarnbjorn
		elseif keys.ability:GetName() == "item_imba_jarnbjorn" then
			modifier_name		= "modifier_item_imba_static_charge"
			modifier_duration	= keys.ability:GetSpecialValueFor("static_duration")
		-- KYS
		elseif keys.ability:GetName() == "item_imba_sange" then
			modifier_name		= "modifier_item_imba_sange_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_heavens_halberd" then
			modifier_name		= "modifier_item_imba_heavens_halberd_ally_buff"
			modifier_duration	= keys.ability:GetSpecialValueFor("buff_duration")
		elseif keys.ability:GetName() == "item_imba_yasha" then
			modifier_name		= "modifier_item_imba_yasha_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_kaya" or keys.ability:GetName() == "item_imba_arcane_nexus" then
			modifier_name		= "modifier_item_imba_kaya_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_sange_yasha" then
			modifier_name		= "modifier_item_imba_sange_yasha_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_kaya_and_sange" then
			modifier_name		= "modifier_item_imba_kaya_and_sange_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_yasha_and_kaya" then
			modifier_name		= "modifier_item_imba_yasha_and_kaya_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		elseif keys.ability:GetName() == "item_imba_sange_yasha" then
			modifier_name		= "modifier_item_imba_sange_yasha_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		-- Linken's Sphere
		elseif keys.ability:GetName() == "item_sphere" then
			modifier_name		= "modifier_item_sphere_target"
			modifier_duration	= keys.ability:GetSpecialValueFor("block_cooldown")
		-- Lotus Orb
		elseif keys.ability:GetName() == "item_imba_lotus_orb" then
			modifier_name		= "modifier_item_imba_lotus_orb_active"
			modifier_duration	= keys.ability:GetSpecialValueFor("active_duration")
		-- Mask of Madness
		elseif keys.ability:GetName() == "item_imba_mask_of_madness" then
			modifier_name		= "modifier_imba_mask_of_madness_berserk"
			modifier_duration	= keys.ability:GetSpecialValueFor("berserk_duration")
		-- Mjollnir
		elseif keys.ability:GetName() == "item_imba_mjollnir" then
			modifier_name		= "modifier_item_imba_static_charge"
			modifier_duration	= keys.ability:GetSpecialValueFor("static_duration")
		-- Spirit Vessel
		elseif keys.ability:GetName() == "item_imba_spirit_vessel" then
			modifier_name		= "modifier_item_imba_spirit_vessel_heal"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		-- Urn of Shadows
		elseif keys.ability:GetName() == "item_imba_urn_of_shadows" then
			modifier_name		= "modifier_imba_urn_of_shadows_active_ally"
			modifier_duration	= keys.ability:GetSpecialValueFor("duration")
		-- Valiance
		elseif keys.ability:GetName() == "item_imba_valiance" and not self:GetParent():GetCloneSource():HasModifier("modifier_item_imba_valiance_counter") then
			modifier_name		= "modifier_item_imba_valiance_guard"
			modifier_duration	= keys.ability:GetSpecialValueFor("guard_duration")
		end
		
		-- Apply the modifier from above
		if modifier_name and modifier_duration then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, modifier_name, {duration = modifier_duration})
		end
		
		-- Special exceptions
		if keys.ability:GetName() == "item_imba_the_triumvirate_v2" then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_the_triumvirate_v2_sange", {duration = keys.ability:GetSpecialValueFor("active_duration")})
			Timers:CreateTimer(FrameTime(), function()
				self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_the_triumvirate_v2_yasha", {duration = keys.ability:GetSpecialValueFor("active_duration")})
				Timers:CreateTimer(FrameTime(), function()
					self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_the_triumvirate_v2_kaya", {duration = keys.ability:GetSpecialValueFor("active_duration")})
				end)
			end)
		elseif keys.ability:GetName() == "item_imba_black_queen_cape" then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_imba_black_queen_cape_active_bkb", {duration = keys.ability:GetSpecialValueFor("bkb_duration")})
			if keys.ability:GetCurrentCharges() >= 1 then
				self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_imba_black_queen_cape_active_heal", {duration = keys.ability:GetSpecialValueFor("heal_duration")})
			end
		elseif keys.ability:GetName() == "item_imba_satanic" then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_imba_satanic", {duration = keys.ability:GetSpecialValueFor("unholy_rage_duration")})
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_imba_satanic_active", {duration = keys.ability:GetSpecialValueFor("unholy_rage_duration")})
		elseif keys.ability:GetName() == "item_imba_bloodstone_720" then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_bloodstone_active_720", {duration = keys.ability:GetSpecialValueFor("restore_duration")})
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_bloodstone_active_cdr_720", {duration = keys.ability:GetSpecialValueFor("active_duration")})
		elseif keys.ability:GetName() == "item_imba_glimmerdark_shield" then
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_glimmerdark_shield_prism", {duration = keys.ability:GetSpecialValueFor("prism_duration")})
			self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_gem_of_true_sight", {duration = keys.ability:GetSpecialValueFor("prism_duration")})
		elseif keys.ability:GetName() == "item_imba_shadow_blade" then
			Timers:CreateTimer(keys.ability:GetSpecialValueFor("invis_fade_time"), function()
				local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(particle_invis_start_fx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

				self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_shadow_blade_invis", {duration = keys.ability:GetSpecialValueFor("invis_duration")})
			end)	
		elseif keys.ability:GetName() == "item_imba_silver_edge" then
			Timers:CreateTimer(keys.ability:GetSpecialValueFor("invis_fade_time"), function()
				local particle_invis_start_fx = ParticleManager:CreateParticle("particles/generic_hero_status/status_invisibility_start.vpcf", PATTACH_ABSORIGIN, self:GetParent())
				ParticleManager:SetParticleControl(particle_invis_start_fx, 0, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_invis_start_fx)

				self:GetParent():AddNewModifier(self:GetParent():GetCloneSource(), keys.ability, "modifier_item_imba_silver_edge_invis", {duration = keys.ability:GetSpecialValueFor("invis_duration")})
			end)
		end
	end
end
	
-- Crash exception nonsense (mostly with Dazzle's Shallow Grave)
function modifier_meepo_divided_we_stand_lua:OnDeath(keys)
	if keys.unit:GetPlayerOwnerID() == self:GetParent():GetPlayerOwnerID() and keys.unit:GetName() == self:GetParent():GetName() and not keys.unit:IsIllusion() then
		if self:GetParent():IsAlive() then
			TrueKill(self:GetParent(), self:GetParent(), self:GetAbility())
		elseif self:GetParent():GetCloneSource() and self:GetParent():GetCloneSource():IsAlive() then
			TrueKill(self:GetParent():GetCloneSource(), self:GetParent():GetCloneSource(), self:GetAbility())
		end
	end
end