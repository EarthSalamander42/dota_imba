-- Creator:
--	   AltiV, December 10th, 2019

LinkLuaModifier("modifier_imba_form_change", "components/abilities/imba_form_change", LUA_MODIFIER_MOTION_NONE)

imba_form_change 			= imba_form_change or class({})
modifier_imba_form_change	= modifier_imba_form_change or class({})

----------------------
-- IMBA_FORM_CHANGE --
----------------------

function imba_form_change:IsInnateAbility()	return true end
function imba_form_change:IsStealable()		return false end

function imba_form_change:GetIntrinsicModifierName()
	return "modifier_imba_form_change"
end

function imba_form_change:GetAbilityTextureName()
   if self:GetCaster():GetModifierStackCount("modifier_imba_form_change", self:GetCaster()) == 0 then
		return "custom/form_change_new"
   else
		return "custom/form_change_old"
   end
end

function imba_form_change:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function imba_form_change:CastFilterResult()
	if self:GetCaster():IsOutOfGame() then
		return UF_FAIL
	end
end

function imba_form_change:OnSpellStart()
	if not self.form then
		self.particle_name = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death_channel.vpcf"
		self.form = "new"
	end
	
	self.particle = ParticleManager:CreateParticle(self.particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)
end

function imba_form_change:OnChannelFinish(bInterrupted)
	if not bInterrupted then
		if self.form == "new" then
			self.particle_name = "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire_channel.vpcf"
			self.form = "old"
		else
			self.particle_name = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death_channel.vpcf"
			self.form = "new"
		end
		
		if not self.current_abilities or not self.previous_abilities then
			
			if self:GetName() == "imba_form_change_clinkz" then
				self.current_abilities = {
					"imba_clinkz_death_pact_723",
					"imba_clinkz_skeleton_walk_723",
					"special_bonus_imba_clinkz_death_pact_723_health",
					"special_bonus_imba_clinkz_skeleton_walk_723_strafe_duration"
				}
				self.previous_abilities = {
					"imba_clinkz_strafe",
					"imba_clinkz_skeleton_walk",
					"special_bonus_hp_regen_16",
					"special_bonus_imba_clinkz_9"
				}
			elseif self:GetName() == "imba_form_change_drow_ranger" then
				self.current_abilities = {
					"imba_drow_ranger_frost_arrows_723",
					"imba_drow_ranger_multishot",
					"imba_drow_ranger_marksmanship_723",
					"special_bonus_agility_12",
					"special_bonus_unique_drow_ranger_1",
					"special_bonus_imba_drow_ranger_frost_arrows_damage",
					"special_bonus_unique_drow_ranger_3",
					"special_bonus_cooldown_reduction_40"
				}
				self.previous_abilities = {
					"imba_drow_ranger_frost_arrows",
					"imba_drow_ranger_trueshot_720",
					"imba_drow_ranger_marksmanship",
					"special_bonus_imba_drow_ranger_5",
					"special_bonus_evasion_25",
					"special_bonus_imba_drow_ranger_6",
					"special_bonus_imba_drow_ranger_10",
					"special_bonus_imba_drow_ranger_3"
				}
			elseif self:GetName() == "imba_form_change_life_stealer" then
				self.current_abilities = {
					"imba_life_stealer_rage_723",
					"imba_life_stealer_feast_723",
					"imba_life_stealer_open_wounds_723",
					"imba_life_stealer_infest_723"
				}
				self.previous_abilities = {
					"imba_life_stealer_rage",
					"imba_life_stealer_feast",
					"imba_life_stealer_open_wounds",
					"imba_life_stealer_infest"
				}
			elseif self:GetName() == "imba_form_change_riki" then
				self.current_abilities = {
					"imba_riki_smoke_screen_723",
					"imba_riki_blink_strike_723",
					"imba_riki_tricks_of_the_trade_723",
					"imba_riki_cloak_and_dagger_723",
					"special_bonus_hp_regen_8",
					"special_bonus_attack_speed_25",
					"special_bonus_attack_damage_35",
					"special_bonus_imba_riki_smokescreen_cooldown",
					"special_bonus_imba_riki_cloak_and_dagger_damage",					
					"special_bonus_imba_riki_tricks_of_the_trade_cooldown",
					"special_bonus_imba_riki_cloak_and_dagger_invis"
				}
				self.previous_abilities = {
					"imba_riki_smoke_screen",
					"imba_riki_blink_strike",
					"imba_riki_cloak_and_dagger",
					"imba_riki_tricks_of_the_trade",
					"special_bonus_imba_riki_1",
					"special_bonus_imba_riki_4",
					"special_bonus_imba_riki_3",
					"special_bonus_imba_riki_5",
					"special_bonus_imba_riki_2",
					"special_bonus_imba_riki_7",
					"special_bonus_imba_riki_8"
				}
			elseif self:GetName() == "imba_form_change_obsidian_destroyer" then
				self.current_abilities = {
					"imba_outworld_devourer_arcane_orb",
					"imba_outworld_devourer_astral_imprisonment",
					"imba_outworld_devourer_essence_flux",
					"imba_outworld_devourer_sanity_eclipse",
					"special_bonus_attack_speed_20",
					"special_bonus_mp_350",
					"special_bonus_armor_6",
					"special_bonus_imba_outworld_devourer_sanity_eclipse_multiplier",
					"special_bonus_imba_outworld_devourer_arcane_orb_damage"
				}
				self.previous_abilities = {
					"imba_obsidian_destroyer_arcane_orb",
					"imba_obsidian_destroyer_astral_imprisonment",
					"imba_obsidian_destroyer_equilibrium",
					"imba_obsidian_destroyer_sanity_eclipse",
					"special_bonus_imba_obsidian_destroyer_2",
					"special_bonus_movement_speed_25",
					"special_bonus_imba_obsidian_destroyer_4",
					"special_bonus_imba_obsidian_destroyer_10",
					"special_bonus_imba_obsidian_destroyer_9"
				}
			else
				self.current_abilities	= {}
				self.previous_abilities = {}
			end
		end
	
		-- This sets it to the old form
		if self:GetCaster():GetModifierStackCount("modifier_imba_form_change", self:GetCaster()) == 0 then
			self:FormChange(self.current_abilities, self.previous_abilities)
		
			self:GetCaster():SetModifierStackCount("modifier_imba_form_change", self:GetCaster(), -1)

			if self:GetName() == "imba_form_change_obsidian_destroyer" and self:GetCaster():HasAbility("imba_outworld_devourer_astral_imprisonment_movement") then
				self:GetCaster():RemoveAbility("imba_outworld_devourer_astral_imprisonment_movement")
			end
		-- This sets it to the new form
		else
			self:FormChange(self.previous_abilities, self.current_abilities)

			self:GetCaster():SetModifierStackCount("modifier_imba_form_change", self:GetCaster(), 0)

			if self:GetName() == "imba_form_change_obsidian_destroyer" and not self:GetCaster():HasAbility("imba_outworld_devourer_astral_imprisonment_movement") then
				local movement_ability = self:GetCaster():AddAbility("imba_outworld_devourer_astral_imprisonment_movement")
				movement_ability:SetLevel(1)
				movement_ability:SetAbilityIndex(4)
			end
		end
	end
end

function imba_form_change:FormChange(old_ability_table, new_ability_table)
	local old_ability = nil
	local new_ability = nil
	
	for ability = 1, #old_ability_table do
		old_ability	= self:GetCaster():FindAbilityByName(old_ability_table[ability])
		new_ability = self:GetCaster():AddAbility(new_ability_table[ability])
		
		if old_ability and new_ability then
			new_ability:SetLevel(old_ability:GetLevel())
			new_ability:StartCooldown(old_ability:GetCooldownTimeRemaining())
			
			self:GetCaster():SwapAbilities(old_ability:GetName(), new_ability:GetName(), false, true)
			
			self:GetCaster():RemoveAbilityByHandle(old_ability)
			
			old_ability = nil
			new_ability = nil
		end
	end
end

-------------------------------
-- MODIFIER_IMBA_FORM_CHANGE --
-------------------------------

function modifier_imba_form_change:IsHidden()			return self:GetRemainingTime() <= 0 and self:GetDuration() ~= -1 end
function modifier_imba_form_change:DestroyOnExpire()	return false end

function modifier_imba_form_change:OnCreated()
	if not IsServer() then return end
	
	if self:GetParent():IsIllusion() and self:GetParent():GetPlayerOwner():GetAssignedHero() and self:GetParent():GetPlayerOwner():GetAssignedHero():HasModifier("modifier_imba_form_change") then
		self.initialized = true
		
		if self:GetParent():GetPlayerOwner():GetAssignedHero():FindModifierByName("modifier_imba_form_change"):GetAbility().form == "old" then
			self:GetAbility():OnChannelFinish(false)
		end
		
		self:SetDuration(math.max(self:GetParent():GetPlayerOwner():GetAssignedHero():FindModifierByName("modifier_imba_form_change"):GetRemainingTime(), 0), true)
		self:StartIntervalThink(math.max(self:GetParent():GetPlayerOwner():GetAssignedHero():FindModifierByName("modifier_imba_form_change"):GetRemainingTime(), 0))
	end
end

function modifier_imba_form_change:OnIntervalThink()
	if self:GetAbility() then
		self:GetAbility():SetHidden(true)
	end
	
	self:StartIntervalThink(-1)
end

function modifier_imba_form_change:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ORDER}
end

function modifier_imba_form_change:OnOrder(keys)
	if not IsServer() or not self:GetAbility() or keys.unit ~= self:GetParent() or self.initialized == true or keys.order_type == DOTA_UNIT_ORDER_STOP then return end
	
	self.initialized = true
	self:SetDuration(self:GetAbility():GetSpecialValueFor("duration"), true)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("duration"))
end

-----------------------
-- HERO FORM CHANGES -- 
-----------------------

imba_form_change_clinkz	= imba_form_change
imba_form_change_drow_ranger = imba_form_change
imba_form_change_life_stealer = imba_form_change
imba_form_change_riki = imba_form_change
imba_form_change_obsidian_destroyer	= imba_form_change

---------------------------
-- IMBA_FORM_CHANGE_RIKI --
---------------------------



-- function imba_form_change_riki:OnChannelFinish(bInterrupted)
	-- if not bInterrupted then
		-- if not self.current_abilities then
			-- self.current_abilities = {"imba_riki_smoke_screen_723", "imba_riki_blink_strike_723", "imba_riki_tricks_of_the_trade_723", "imba_riki_cloak_and_dagger_723"}
		-- end
		
		-- if not self.previous_abilities then
			-- self.previous_abilities = {"imba_riki_smoke_screen", "imba_riki_blink_strike", "imba_riki_cloak_and_dagger", "imba_riki_tricks_of_the_trade"}
		-- end
	
		-- if self:GetCaster():GetModifierStackCount("modifier_imba_form_change", self:GetCaster()) == 0 then
			-- self:FormChange(self.current_abilities, self.previous_abilities)
		
			-- self:GetCaster():SetModifierStackCount("modifier_imba_form_change", self:GetCaster(), -1)
		-- else
			-- self:FormChange(self.previous_abilities, self.current_abilities)

			-- self:GetCaster():SetModifierStackCount("modifier_imba_form_change", self:GetCaster(), 0)
		-- end
	-- end
-- end
