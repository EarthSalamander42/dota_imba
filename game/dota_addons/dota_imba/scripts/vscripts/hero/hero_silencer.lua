-- File left empty for CreateEmptyTalents function to use this

LinkLuaModifier("modifier_imba_silencer_glaives_hit_counter", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_silencer_glaives_int_damage", "hero/hero_silencer/imba_glaives_of_wisdom", LUA_MODIFIER_MOTION_NONE)

function GlaiveHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local intellect_damage_pct  = ability:GetSpecialValueFor("intellect_damage_pct")
	local hits_to_silence = ability:GetSpecialValueFor("hits_to_silence")
	local hit_count_duration = ability:GetSpecialValueFor("hit_count_duration")
	local silence_duration = ability:GetSpecialValueFor("silence_duration")
	local int_reduction_pct = ability:GetSpecialValueFor("int_reduction_pct")
	local int_reduction_duration = ability:GetSpecialValueFor("int_reduction_duration")
	local caster_int = caster:GetIntellect()

	--[[ SILENCER TALENT CHECK - replace hardcoded numbers
	if caster:HasModifier("") then
		intellect_damage_pct = intellect_damage_pct + 25
	end
	if caster:HasModifier("") then
		silence_duration = silence_duration + 0.25
	end
	]]

	local glaive_pure_damage = caster_int * intellect_damage_pct / 100

	local damage_table = {
		victim = target,
		attacker = caster,
		damage = glaive_pure_damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	ApplyDamage( damage_table )

	local hit_counter = target:FindModifierByName("modifier_imba_silencer_glaives_hit_counter")
	if not hit_counter then
		target:AddNewModifier(caster, ability, "modifier_imba_silencer_glaives_hit_counter", {req_hits = hits_to_silence, silence_dur = silence_duration})
		hit_counter = target:FindModifierByName("modifier_imba_silencer_glaives_hit_counter")
	end
	hit_counter:IncrementStackCount()
	hit_counter:SetDuration(hit_count_duration, true)

	local int_damage = target:FindModifierByName("modifier_imba_silencer_glaives_int_damage")
	if not int_damage then
		target:AddNewModifier(caster, ability, "modifier_imba_silencer_glaives_int_damage", {int_reduction = int_reduction_pct})
		int_damage = target:FindModifierByName("modifier_imba_silencer_glaives_int_damage")
	end
	int_damage:IncrementStackCount()
	int_damage:SetDuration(int_reduction_duration, true)
end