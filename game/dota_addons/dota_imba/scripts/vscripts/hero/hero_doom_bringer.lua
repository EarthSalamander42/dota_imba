-------------------------------------------
--			GOD'S STRENGTH
-------------------------------------------
LinkLuaModifier("modifier_imba_doom_bringer_doom", "hero/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_doom_bringer_doom_enemies", "hero/hero_doom_bringer", LUA_MODIFIER_MOTION_NONE)

imba_doom_bringer_doom = class({})
function imba_doom_bringer_doom:IsHiddenWhenStolen() return false end
function imba_doom_bringer_doom:IsRefreshable() return true end
function imba_doom_bringer_doom:IsStealable() return true end
function imba_doom_bringer_doom:IsNetherWardStealable() return false end

function imba_doom_bringer_doom:GetAbilityTextureName()
   return "doom_bringer_doom"
end

function imba_doom_bringer_doom:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		caster:AddNewModifier(caster, self, "modifier_imba_doom_bringer_doom", {duration = duration})
		caster:EmitSound("Hero_DoomBringer.Doom")
		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	end
end
-------------------------------------------
modifier_imba_doom_bringer_doom = class({})
function modifier_imba_doom_bringer_doom:IsDebuff() return false end
function modifier_imba_doom_bringer_doom:IsHidden() return false end
function modifier_imba_doom_bringer_doom:IsPurgable() return false end
function modifier_imba_doom_bringer_doom:IsPurgeException() return false end
function modifier_imba_doom_bringer_doom:IsStunDebuff() return false end
function modifier_imba_doom_bringer_doom:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_doom_bringer_doom:IsAura()
	return true
end

function modifier_imba_doom_bringer_doom:GetAuraSearchTeam()
	return self:GetAbility():GetAbilityTargetTeam()
end

function modifier_imba_doom_bringer_doom:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_doom_bringer_doom:GetModifierAura()
	return "modifier_imba_doom_bringer_doom_enemies"
end

function modifier_imba_doom_bringer_doom:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_imba_doom_bringer_doom:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_imba_doom_bringer_doom:GetAuraEntityReject(target)
	if IsServer() then
		if self:GetParent() == target then
			print("Remove caster bonus aura")
			return true
		end
	end
	return false
end

function modifier_imba_doom_bringer_doom:OnCreated()
local caster = self:GetCaster()

--	if IsServer() then
		caster.DoomPFX = ParticleManager:CreateParticle("particles/units/hero/doom_bringer/doom/doom_bringer_doom_self.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(self:GetCaster().DoomPFX, 4, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
--		self:AddParticle( nFXIndex, false, false, -1, false, true )
--	end
end

function modifier_imba_doom_bringer_doom:DeclareFunctions()
	local decFuns =
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return decFuns
end

function modifier_imba_doom_bringer_doom:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_bonus")
end

function modifier_imba_doom_bringer_doom:OnDestroy()
local caster = self:GetCaster()

	ParticleManager:DestroyParticle(caster.DoomPFX, true)
	ParticleManager:ReleaseParticleIndex(caster.DoomPFX)
end

-------------------------------------------
modifier_imba_doom_bringer_doom_enemies = class({})
function modifier_imba_doom_bringer_doom_enemies:IsDebuff() return false end
function modifier_imba_doom_bringer_doom_enemies:IsHidden() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgable() return false end
function modifier_imba_doom_bringer_doom_enemies:IsPurgeException() return false end
function modifier_imba_doom_bringer_doom_enemies:IsStunDebuff() return false end
function modifier_imba_doom_bringer_doom_enemies:RemoveOnDeath() return true end
-------------------------------------------

function modifier_imba_doom_bringer_doom_enemies:OnCreated()
local parent = self:GetParent()

	parent.DoomEffect = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	self:AddParticle(parent.DoomEffect, false, false, -1, false, false)
	ParticleManager:SetParticleControlEnt( parent.DoomEffect, 4, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true )
	parent:Purge( true, false, false, false, false)
	self:StartIntervalThink(1.0)
end

function modifier_imba_doom_bringer_doom_enemies:OnRefresh()
	self:OnCreated()
end

function modifier_imba_doom_bringer_doom_enemies:GetStatusEffectName()
	return "particles/status_fx/status_effect_doom.vpcf"
end

function modifier_imba_doom_bringer_doom_enemies:StatusEffectPriority()
	return 10
end

function modifier_imba_doom_bringer_doom_enemies:CheckState()	
	local state = {} 
	state = {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}
	
	return state
end

function modifier_imba_doom_bringer_doom_enemies:OnIntervalThink()
	local damage_table = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self:GetAbility():GetSpecialValueFor("damage"),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility()
	}
	ApplyDamage(damage_table)
end