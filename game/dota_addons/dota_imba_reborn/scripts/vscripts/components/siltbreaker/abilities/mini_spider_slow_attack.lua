mini_spider_slow_attack = class({})
LinkLuaModifier( "modifier_mini_spider_slow_attack", "components/siltbreaker/modifiers/modifier_mini_spider_slow_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mini_spider_slow_attack_debuff", "components/siltbreaker/modifiers/modifier_mini_spider_slow_attack_debuff", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------

function mini_spider_slow_attack:GetIntrinsicModifierName()
	return "modifier_mini_spider_slow_attack"
end

-------------------------------------------------------------------------
