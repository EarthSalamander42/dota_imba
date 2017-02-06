---------------------------------
-- Glaives of Wisdom hit counter dummy modifier
---------------------------------
-- LinkLuaModifier("imba_silencer_glaives_hit_counter", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
imba_silencer_glaives_hit_counter = class({})

function imba_silencer_glaives_hit_counter:OnCreated( kv )
	if IsServer() then
		self.target = self:GetParent()
		self.caster = self:GetAbility():GetCaster()
		self.hits_to_silence = kv.req_hits
		self.silence_duration = kv.silence_dur
	end
end

function imba_silencer_glaives_hit_counter:OnStackCountChanged(old_stack_count)
	if IsServer() then
		if self:GetStackCount() >= self.hits_to_silence then
			self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_silence", {duration = self.silence_duration})
			self:SetStackCount(0)
		end
	end
end

function imba_silencer_glaives_hit_counter:IsDebuff()
	return true
end

function imba_silencer_glaives_hit_counter:IsHidden()
	return false --true
end

---------------------------------
-- Glaives of Wisdom int reduction modifier
---------------------------------
-- LinkLuaModifier("imba_silencer_glaives_int_damage", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
imba_silencer_glaives_int_damage = class({})

function imba_silencer_glaives_int_damage:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		self.int_reduction_pct = kv.int_reduction
		self.total_int_reduced = 0
	end
end

function imba_silencer_glaives_int_damage:IsDebuff()
	return true
end

function imba_silencer_glaives_int_damage:OnStackCountChanged(old_stack_count)
	if IsServer() then
		local target = self:GetParent()
		local target_intelligence = target:GetIntellect()
		if target_intelligence > 1 then
			local int_to_steal = math.max(1, math.floor(target_intelligence * self.int_reduction_pct / 100))
			local int_taken
			if ( (target_intelligence - int_to_steal) >= 1 ) then
				int_taken = int_to_steal
			else
				int_taken = -(1 - target_intelligence)
			end
			-- Calculate the amount of mana to remove, based on int-based max mana
			local mana_to_burn = self.int_reduction_pct / 100 * target:GetMana() * ( target_intelligence * 12 + 50 ) / target:GetMaxMana()
			self.total_int_reduced = self.total_int_reduced + int_taken
			target:ReduceMana(mana_to_burn)
			target:CalculateStatBonus()
		end
	end
end

function imba_silencer_glaives_int_damage:GetTexture()
	return "silencer_glaives_of_wisdom"
end

function imba_silencer_glaives_int_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function imba_silencer_glaives_int_damage:GetModifierBonusStats_Intellect()
	return -self.total_int_reduced
end