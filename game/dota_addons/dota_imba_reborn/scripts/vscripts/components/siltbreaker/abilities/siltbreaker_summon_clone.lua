
siltbreaker_summon_clone = class({})
LinkLuaModifier( "modifier_siltbreaker_summon_clone", "components/siltbreaker/modifiers/modifier_siltbreaker_summon_clone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_clone", "components/siltbreaker/modifiers/modifier_siltbreaker_clone", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_immune_physical", "components/siltbreaker/modifiers/modifier_siltbreaker_immune_physical", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_immune_magical", "components/siltbreaker/modifiers/modifier_siltbreaker_immune_magical", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function siltbreaker_summon_clone:OnSpellStart()
	if IsServer() then
		self.invuln_duration = self:GetSpecialValueFor( "invuln_duration" )

		local hBoss = self:GetCaster()
		hBoss:AddNewModifier( self:GetCaster(), self, "modifier_siltbreaker_summon_clone", { duration = self.invuln_duration } )

		hBoss.nSummonCloneCasts = hBoss.nSummonCloneCasts + 1
	end
end

--------------------------------------------------------------------------------

