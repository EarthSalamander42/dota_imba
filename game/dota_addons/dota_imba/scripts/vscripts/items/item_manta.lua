LinkLuaModifier( "modifier_item_manta_passive", "items/item_manta.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_manta_invulnerable", "items/item_manta.lua", LUA_MODIFIER_MOTION_NONE )

if item_imba_manta == nil then item_imba_manta = class({}) end

function item_imba_manta:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function item_imba_manta:GetAbilityTextureName()
   return "item_manta"
end

--	function item_imba_assault:GetIntrinsicModifierName()
--		return "modifier_item_manta_passive"
--	end

function item_imba_manta:OnCreated()
self.ability = self:GetAbility()

--	if not self.ability then
--		self:Destroy()
--	end

	self.modifier_self = "modifier_imba_assault_cuirass"

	caster:AddNewModifier(self:GetCaster(), nil, "modifier_item_manta_passive", {})
end

function item_imba_manta:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("tooltip_illusion_duration")
local invulnerability_duration = self:GetSpecialValueFor("invuln_duration")
local images_count = self:GetSpecialValueFor("images_count")
local cooldown_melee = self:GetSpecialValueFor("cooldown_melee")
local outgoingDamage = self:GetSpecialValueFor("images_do_damage_percent_ranged")
local incomingDamage = self:GetSpecialValueFor("images_take_damage_percent_ranged")

	if not caster:IsRangedAttacker() then  --Manta Style's cooldown is less for melee heroes.
		self:EndCooldown()
		self:StartCooldown(cooldown_melee)
		local outgoingDamage = self:GetSpecialValueFor("images_do_damage_percent_melee")
		local incomingDamage = self:GetSpecialValueFor("images_take_damage_percent_melee")
	end

	caster:Purge(false, true, false, false, false)
	caster:AddNewModifier(caster, self, "modifier_manta_invulnerable", {duration=invulnerability_duration})

	if not caster.manta then
		caster.manta = {}
	end

	for k,v in pairs(caster.manta) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),		-- North
		Vector( 0, 72, 0 ),		-- East
		Vector( -72, 0, 0 ),	-- South
		Vector( 0, -72, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )

	caster:EmitSound("DOTA_Item.Manta.Activate")
	local manta_particle = ParticleManager:CreateParticle("particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	Timers:CreateTimer(invulnerability_duration, function()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin() + table.remove( vRandomSpawnPos, 1 ), true)

		for i=1, images_count do
			local origin = caster:GetAbsOrigin() + table.remove( vRandomSpawnPos, 1 )
			local illusion = IllusionManager:CreateIllusion(caster, self, origin, caster, {damagein=incomingDamage, damageout=outcomingDamage, unique="manta_"..i, duration=duration})
			table.insert(caster.manta, illusion)
		end

		ParticleManager:DestroyParticle(manta_particle, false)
		ParticleManager:ReleaseParticleIndex(manta_particle)
	end)
end

-----------------------------------------------------------------------------------------------------------
--	Reveal modifier
-----------------------------------------------------------------------------------------------------------

if modifier_item_manta_passive == nil then modifier_item_manta_passive = class({}) end
function modifier_item_manta_passive:IsPassive() return true end
function modifier_item_manta_passive:IsHidden() return true end
function modifier_item_manta_passive:IsPurgable() return false end

function modifier_item_manta_passive:DeclareFunctions()	
	local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return decFuncs	
end

function modifier_item_manta_passive:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_item_manta_passive:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_manta_passive:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_strength")
end

function modifier_item_manta_passive:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_item_manta_passive:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_item_manta_passive:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_item_manta_passive:OnDestroy()

end

modifier_manta_invulnerable = class({})

--------------------------------------------------------------------------------

function modifier_manta_invulnerable:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_manta_invulnerable:CheckState()
	local state = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	
	return state
end
