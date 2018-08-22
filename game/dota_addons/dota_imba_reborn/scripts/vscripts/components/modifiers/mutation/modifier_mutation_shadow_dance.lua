LinkLuaModifier("modifier_mutation_shadow_dance_buff", "components/modifiers/mutation/modifier_mutation_shadow_dance.lua", LUA_MODIFIER_MOTION_NONE )

modifier_mutation_shadow_dance = modifier_mutation_shadow_dance or class({})

function modifier_mutation_shadow_dance:IsPurgable() return false end
function modifier_mutation_shadow_dance:RemoveOnDeath() return false end
function modifier_mutation_shadow_dance:IsHidden() return true end

if IsServer() then
	function modifier_mutation_shadow_dance:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_TAKEDAMAGE,
			MODIFIER_EVENT_ON_ATTACK_LANDED,
		}

		return funcs
	end

	function modifier_mutation_shadow_dance:OnCreated()
		self.delay = 3.0

		self:GetParent().last_seen = 0
		self:StartIntervalThink(0.1)
	end

	function modifier_mutation_shadow_dance:OnIntervalThink()
--		print("last seen "..self:GetParent():GetUnitName().." :", self:GetParent().last_seen)

		if not self:GetParent():IsAlive() then return end

		if self:GetParent():GetTeamNumber() == 2 then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:CanEntityBeSeenByMyTeam(self:GetParent()) and hero:GetTeamNumber() == 3 then
					modifier_mutation_shadow_dance:ResetCheck(self:GetParent())

					return
				end
			end
		elseif self:GetParent():GetTeamNumber() == 3 then
			for _, hero in pairs(HeroList:GetAllHeroes()) do
				if hero:CanEntityBeSeenByMyTeam(self:GetParent()) and hero:GetTeamNumber() == 2 then
					modifier_mutation_shadow_dance:ResetCheck(self:GetParent())

					return
				end
			end
		end

		self:GetParent().last_seen = self:GetParent().last_seen + 0.1

		if self:GetParent().last_seen and self:GetParent().last_seen >= self.delay then
			if not self:GetParent():HasModifier("modifier_mutation_shadow_dance_buff") then
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_mutation_shadow_dance_buff", {})
			end
		end
	end

	function modifier_mutation_shadow_dance:OnTakeDamage(kv)
		if self:GetParent()	== kv.unit then
			modifier_mutation_shadow_dance:ResetCheck(self:GetParent())
		end
	end

	function modifier_mutation_shadow_dance:OnAttackLanded(kv)
		if self:GetParent()	== kv.attacker then
			modifier_mutation_shadow_dance:ResetCheck(self:GetParent())
		end
	end

	function modifier_mutation_shadow_dance:ResetCheck(hero)
		hero.last_seen = 0

		if hero:HasModifier("modifier_mutation_shadow_dance_buff") then
			hero:RemoveModifierByName("modifier_mutation_shadow_dance_buff")
		end
	end
end

modifier_mutation_shadow_dance_buff = modifier_mutation_shadow_dance_buff or class({})

function modifier_mutation_shadow_dance_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	}

	return funcs
end

function modifier_mutation_shadow_dance_buff:GetEffectName()
	return "particles/econ/events/fall_major_2016/radiant_fountain_regen_fm06_lvl2.vpcf"
end

function modifier_mutation_shadow_dance_buff:GetModifierHealthRegenPercentage()
	return CustomNetTables:GetTableValue("mutation_info", "slark_mode")["1"]
end

function modifier_mutation_shadow_dance_buff:GetModifierTotalPercentageManaRegen( params )
	return CustomNetTables:GetTableValue("mutation_info", "slark_mode")["2"]
end

function modifier_mutation_shadow_dance_buff:GetTexture()
	return "slark_shadow_dance"
end
