modifier_mutation_hyper_blink = class({})

function modifier_mutation_hyper_blink:IsHidden()		return true end
function modifier_mutation_hyper_blink:IsPurgable()		return false end
function modifier_mutation_hyper_blink:RemoveOnDeath()	return false end

function modifier_mutation_hyper_blink:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ABILITY_EXECUTED}
end

function modifier_mutation_hyper_blink:OnAbilityExecuted(keys)
	if keys.unit == self:GetParent() and keys.ability and keys.ability:GetCursorPosition() and bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		self:GetParent():Blink(keys.ability:GetCursorPosition(), false, true)
	end
end
