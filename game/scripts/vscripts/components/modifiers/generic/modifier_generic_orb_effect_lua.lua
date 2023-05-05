-- Generic Orb Effect Library created by Elfansoer (with modifications by AltiV)
-- See the reference at https://github.com/Elfansoer/dota-2-lua-abilities/blob/c3bfb93a32e8257f861a5e32e4d25231185a6ba4/scripts/vscripts/lua_abilities/generic/modifier_generic_orb_effect_lua.lua

-- There's some weird bug that lets you bypass target flags if you level up the ability mid-attack -_-

modifier_generic_orb_effect_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_orb_effect_lua:IsHidden()
	return true
end

function modifier_generic_orb_effect_lua:IsDebuff()
	return false
end

function modifier_generic_orb_effect_lua:IsPurgable()
	return false
end

function modifier_generic_orb_effect_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_orb_effect_lua:OnCreated( kv )
	-- generate data
	self.ability = self:GetAbility()
	self.cast = false
	self.records = {}
	
	-- Test variable for proper projectile effect display
	self.target = nil
end

function modifier_generic_orb_effect_lua:OnRefresh( kv )
end

function modifier_generic_orb_effect_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_orb_effect_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_generic_orb_effect_lua:OnAttackRecord( params )
	if params.attacker~=self:GetParent() then return end

	-- check autocast
	if (self.ability:GetAutoCastState() and self.ability:IsFullyCastable() and not self:GetParent():IsSilenced()) or self.cast then
		-- filter whether target is valid 
		if UnitFilter(
			params.target,
			self.ability:GetAbilityTargetTeam(),
			self.ability:GetAbilityTargetType(),
			self.ability:GetAbilityTargetFlags(),
			self:GetCaster():GetTeamNumber()
		) == UF_SUCCESS then
			self.bPrimed = true
			self.cast = true
		else
			self.bPrimed = false
			self.cast = false
		end
	else
		self.bPrimed = false
	end

	-- register attack if being cast and fully castable
	if self.cast and self.ability:IsFullyCastable() and not self:GetParent():IsSilenced() then
		-- run OrbRecord script if available
		if self.ability.OnOrbRecord then self.ability:OnOrbRecord( params ) end
	end
end


function modifier_generic_orb_effect_lua:OnAttack( params )
	if params.attacker~=self:GetParent() then return end

	-- -- check autocast
	-- if self.ability:GetAutoCastState() then
		-- -- filter whether target is valid 
		-- if UnitFilter(
			-- params.target,
			-- self.ability:GetAbilityTargetTeam(),
			-- self.ability:GetAbilityTargetType(),
			-- self.ability:GetAbilityTargetFlags(),
			-- self:GetCaster():GetTeamNumber()
		-- ) == UF_SUCCESS then
			-- self.cast = true
		-- end
	-- end

	-- register attack if being cast and fully castable
	if (self.cast and self.ability:IsFullyCastable() and not self:GetParent():IsSilenced() and UnitFilter(params.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS) or self.bPrimed then	
		-- use mana and cd
		self.ability:UseResources(true, false, false, true)

		-- record the attack
		self.records[params.record] = true

		-- run OrbFire script if available
		if self.ability.OnOrbFire then self.ability:OnOrbFire( params ) end
	end

	self.cast = false
end
function modifier_generic_orb_effect_lua:GetModifierProcAttack_Feedback( params )
	if self.records[params.record] then
		-- apply the effect
		if self.ability.OnOrbImpact then self.ability:OnOrbImpact( params ) end
	end
end
function modifier_generic_orb_effect_lua:OnAttackFail( params )
	if self.records[params.record] then
		-- apply the fail effect
		if self.ability.OnOrbFail then self.ability:OnOrbFail( params ) end
	end
end
function modifier_generic_orb_effect_lua:OnAttackRecordDestroy( params )
	-- destroy attack record
	self.records[params.record] = nil
	
	-- run OrbRecordDestroy script if available
	if self.ability.OnOrbRecordDestroy then self.ability:OnOrbRecordDestroy( params ) end
end

function modifier_generic_orb_effect_lua:GetModifierAttackRangeBonus()
	if not IsServer() then return end

	if self:GetAbility():GetAutoCastState() and self:GetParent():GetAggroTarget() and UnitFilter(self:GetParent():GetAggroTarget(), self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS and self:GetAbility().GetTalentSpecialValueFor then
		return self:GetAbility():GetTalentSpecialValueFor("attack_range_bonus")
	end
end

function modifier_generic_orb_effect_lua:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.ability then
		-- if this ability, cast
		-- if params.ability==self:GetAbility() and not self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) then
		if params.ability==self:GetAbility() and ((not self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) and params.target and UnitFilter(params.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS) or (self:FlagExist( params.order_type, DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO ) and not self:GetAbility():GetAutoCastState())) then -- Remember that logic is reversed such that not being detected here usually mean it's on
			self.cast = true
			return
		end

		-- if casting other ability that cancel channel while casting this ability, turn off
		local pass = false
		local behavior = params.ability:GetBehavior()
		if self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL ) or 
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT ) or
			self:FlagExist( behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL )
		then
			local pass = true -- do nothing
		end

		if self.cast and (not pass) then
			self.cast = false
		end
	else
		-- if ordering something which cancel channel, turn off
		if self.cast then
			if self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_POSITION ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_MOVE_TO_TARGET )	or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_MOVE ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_ATTACK_TARGET ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_STOP ) or
				self:FlagExist( params.order_type, DOTA_UNIT_ORDER_HOLD_POSITION )
			then
				self.cast = false
			end
		end
	end
end

-- This isn't perfect because it will still show the orb if you autocast it against a magic immune target, even if the orb cannot be cast on them
function modifier_generic_orb_effect_lua:GetModifierProjectileName( params )
	if self.ability.GetProjectileName then
		if self.cast or (self.ability:GetAutoCastState() and self.ability:IsFullyCastable() and not self:GetParent():IsSilenced()) then
			 self.target = self:GetParent():GetAttackTarget()

			 if self.target and UnitFilter(self.target, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber()) == UF_SUCCESS then
				return self.ability:GetProjectileName()
			 end
		end
	end
end

--------------------------------------------------------------------------------
-- Helper: Flags
function modifier_generic_orb_effect_lua:FlagExist(a,b)--Bitwise Exist
	a = tonumber(tostring(a))
	b = tonumber(tostring(b))
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end
--------------------------------------------------------------------------------
-- Graphics & Animations